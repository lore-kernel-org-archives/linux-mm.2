Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C3CCA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEB3E6B0093; Mon,  5 Oct 2026 04:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2EB6B0095; Mon,  5 Oct 2026 04:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1D26B0096; Mon,  5 Oct 2026 04:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B164A6B0093
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:27:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E449A50E1
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:27:37 +0000 (UTC)
X-FDA: 85287893754.27.3D63DB3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id E253140007
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:27:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=G4VXDLj5;
	spf=none (imf01.hostedemail.com: domain of BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791188855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8X8AyjGJezhXg2/quolg72VYhJ3P5AViyggCu0d7uYw=;
	b=jRj7QmnRI0F7XPS1qk2JzlJ1jxCSUwj3enoSqV2CT/jKu1ndodwmCGJjBmtpr/RNNs8ecE
	j16lZqdqgbXEZE3BZx7nGwBjA1lvt+5lTmITlM+KkVjcjwFYgrvkFyUCcly0pFuCDOHZR9
	oDGFUj26dSbsvO9+EPimQdBdWm4xOfQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=G4VXDLj5;
	spf=none (imf01.hostedemail.com: domain of BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+468a587a01b7da22bf06+8443+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791188855;
	b=oMimbLBphdHpMow26E6NMpCQztgtUeJ5sMRJZMPlv99+JJxRy9T/pstW5HNfTqdJmGqsZA
	PzOm+0CanESWqTStohrCzBVmDpU5ReDSQJHQfKqPKMDaIQSb/VK0rgiw7dy37HR3yd6Lux
	oIe6NhBjMYafiTJz4PEbvf5HMlL6Z9I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8X8AyjGJezhXg2/quolg72VYhJ3P5AViyggCu0d7uYw=; b=G4VXDLj5GqKnej0EeZbmuWSaA/
	A+0i8Ht6NTm9K5qlFft2BDVJ/S4luUWFYMnS18jnBnJELhWxZA6jlqbFSq2e3RMlcZGMDDOKBto/e
	8qZrrw08U46vh0v6vNgPPYbRP3hDcA9IotVoN8rzaD82c0d2Ay/O995uj+9uSWbacZAXUyDTZp0RD
	5t6e+z3QAzYWR6yzGCWxAt8GpGr/mMMT8Ib1CRpWYdmk+N92ndE7UKD7AxUcNGGoNpv0ec1nnW0lA
	w3rz5MnD9pr4wV19KdIMYpmRzdq3wKOLaF4qzCKxHALsW6qXeJU9miWVdbYDtl04nGthVyT7ohRW/
	sSV6eXJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDe2m-0000000Fsip-20HA;
	Mon, 05 Oct 2026 08:27:32 +0000
Date: Mon, 5 Oct 2026 01:27:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
	tj@kernel.org, akpm@linux-foundation.org,
	Boris Burkov <boris@bur.io>
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <asNfdOfgN5z20jBT@infradead.org>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <903dd25b-7af3-44cc-9425-9499f50d5750@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <903dd25b-7af3-44cc-9425-9499f50d5750@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E253140007
X-Rspam-User: 
X-Stat-Signature: zmprmsifcp8upbz73p8dnp63xcsjz34r
X-HE-Tag: 1791188854-685340
X-HE-Meta: U2FsdGVkX1+9upxWKHK4xPuFih8+nu8YrNIWbU+4uJumd2D50rrR81GKtWW+VJHljEwk6+1tr33TZ3k+dzhL+zWl9eGHYZDsAI6kd4hecoWZBCs0OIjwOqpndQszui1B17Wnj5NpAIJBm+2GuvhQlbhk5v7MtbFvjiduPKUOTit2MkytOLnAy02q83K1DxXQQdtraQRfsUWhn8uRbl/yemVhxdEPkYzIQ4uKPMRxiIrgnb5vsJs/Pkylcpxm6+Ab9VLewZAjO6AUHB+TLBzPuchXw0HVjzThz6+qzZqCrmYbhgBncslkyiPLD5tETikqXWAQ9cnQ2frJqboVFnW2W+blmOKf6sxULS1RR45Y6V0QzNAMXgdpV8ZhnUYqxwvZxjsHbUkEV7CjC6qGVyPwqVha7t6xUAignSxYn+ZS3EfKb0qsd2GoShk1+7vF60M2MDAVisD79ddgHwto/pFcQ3dtCiw/5YzJD2vAcQFxO/qdRD1IMm2BL8nk8Zot88VaGMpochBFd7XLuYKzaaYxR1lbZPGiC8yDuuiTodCWMlZ5x2GyFr6dy1J+/9hTdjHr8yMlowEhSThtK2+SBxkGsVbkV7lfBBYrC6clp6yQXWBPasURSjulNAUBhtDfEdhIc2C1FDaYe5WySF/AvjANYzV3MSSTPL2917KgVkEqHR3dt8CPSydoOlKcSIwyeyOIEFymy9coavm3Lw80J+QhtWlS/8FN4ivD2+Vz7cZMZLA0W1L1cVbGgrOtnlExDEeXAX1lPh52EEoi4tIhl84KmtsKKgRNTrr/HJcfYn6wIUQGUsHoj2Z1AYsXheKsisM5r6sBOAf6prYqp9yIYJLEmJjxTu/DlkutusuCFEXvPTblCj2Kpc7xshLhGv51IYgblO1AtNvLEqyhicmnsxhgvmk9+IrXcMarorjXyBycq+EOJEAzd1moUY1lD+97svggA8E15eLBKyCIyyumN00
 56RZDfui
 TGPd9N5Zg578vAUFJRQ15wowafi+TfHsYa3hoeRUzlAnSa3pesgbVmwSzzimYEhca7H8TyFwrm4ZJpTp7/R3eF5kVbSdxFX68R4QCJaOVr2cXn8Qy5VdnS00oiQWim4HB9PGCiHeo28+/HmwOUxKuAXNN2ZKzjS+SWjC0aQi9P4DXKfoGqveHhUJfXdjFeyx8qyFWKMkk9gTp52HmuEULIG+r23IGSY2RcKVPxupjrHRbBZcl6kwBhsVwnYgEKLda4Z1XfLIaGO5bsYn+Bbd+zl4kykgyNcrww9U69VrQUCMsTuRVMcY1UOTuGo03DchsCsm5wZz8ryf+spytDQwUkWXanfGwugvYitg1HdBF1p4IJiJlbXXYHpp24t5DI2b1KS6XIVom7yd/NLAWVdLKwbk0nGy6+bKQK+ZSIF4hji7Lgje09kq4+wHwIBpoijsIGBz4+0tqgj+8sA2UdGEW7ecrS2xlELsKi4E12Z64FG1tXVNf+2cg1kTWvQYqP5lt2srNDjnGeYn/zfvDNnqBcJNw3eeMOwWGl6XyVlmD+rt1BebjkZXUtXmwYzLYfww2eEgbsRjjmBosb6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 05:23:54PM +0800, Julian Sun wrote:
> Could you elaborate on your concern about adding another
> blkdev_get_no_open() user here? Is it specific to this helper, or to
> submitting writeback with a temporary bdev reference without opening
> the device?

Both, really.


