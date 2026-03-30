Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA735FF4946
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 06:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430616B0096; Mon, 30 Mar 2026 02:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407BC6B0098; Mon, 30 Mar 2026 02:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3451B6B0099; Mon, 30 Mar 2026 02:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 274696B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:22:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB49ABAE6E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:22:21 +0000 (UTC)
X-FDA: 84601734882.07.584499E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 004564000B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:22:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="y9RrhRs/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of BATV+d52e2ffbe62236f4cc0e+8254+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d52e2ffbe62236f4cc0e+8254+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774851740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5kUGJxxpOGZLNxEaIQpqI55lXs8cjlZDGWoRqiSlsk=;
	b=Xdjk9DR0i0nNfHHsR810+cimSIsgCVxGXJiq3E8s6bxT1oDkooHUXBOzA7vlskvVz0Rra0
	4xq3jTbMlo2MVh778ly6HaeSXZD1dhJ6n8DYcK7A1GFHoWHLtvd8aISSzwGczz/acovNIR
	evWjhxCyzOSG8tsJuGu+ZNVekckRnoM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774851740; a=rsa-sha256;
	cv=none;
	b=Rp7tYV66zLkd81dhxCLdwK07ubSVKNvCyJNI1aPrnyv77R0n8N2EL2jVXSl3dnCblRFtRi
	zBDa/EmmB3NGJeQzDuIQUkkPFYrPtfFXIyfX5vF8pAi1Zt5dkaxwrNa8RVmIE4wGIFUS8C
	t3HNMPvjIwi+7dWV+ygTmNxKpAN0z3M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="y9RrhRs/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of BATV+d52e2ffbe62236f4cc0e+8254+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d52e2ffbe62236f4cc0e+8254+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=A5kUGJxxpOGZLNxEaIQpqI55lXs8cjlZDGWoRqiSlsk=; b=y9RrhRs/Zry8zlwTPI1jczOx3d
	xuCD9gV3XOiWO8LpJLz297O2TSydy7FSArlNaq+7mSQahDYV/tAG2QXbtUETOkH05JMwJQyzom3lG
	LUIwG25Pc9bmFwY2+F/kM+1cyzrIoXn7B9D7jZ/h1Ys2daJmabCJjXScjMAsNSyA0y8yLo9DtgeFZ
	LPxFmO/LLL5I9lWecbvZS3d5amIE7m/Z3IsAmnvmG0MyUfz8WMLCOLgo7xayrkA3IXgmi8dYkGcyn
	VbBYo13aLpFjAPaitMlHibEV4aM/AVuCOdDnZdKS1vN1fJp8wRuAosgtvos2/6o0aIzkLTNGFDMnS
	9K25sYFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w760w-0000000Ag7m-46So;
	Mon, 30 Mar 2026 06:22:18 +0000
Date: Sun, 29 Mar 2026 23:22:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: mpenttil@redhat.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH v7 6/6] mm:/migrate_device.c: remove
 migrate_vma_collect_*()
Message-ID: <acoWmpfXXCfOOJGJ@infradead.org>
References: <20260330043017.251808-1-mpenttil@redhat.com>
 <20260330043017.251808-7-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260330043017.251808-7-mpenttil@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 004564000B
X-Stat-Signature: rwfn9wok94umho3zjonktexs96yseyo4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774851739-218580
X-HE-Meta: U2FsdGVkX18ajuI16qkCGcAdxwkKrx66sZyXEwQTWTZ+rroMLXu75ryiIUUVMnp/1GQkGWz3R8jSfiN7PVxBX74IR9+na5cjK7fMu/WE50VLyY6xIgHuuD8Sgh5xjyxWZ5Kw45PdpU2Q+p+7GgM6aROmIExq3p+HdacnWSz89hwFJv1bZQrSDybbNEtV/PDaZABpo8nCizHgD/FH7ZycozBDcx5d5sdlqcPsT2YGWI6hZcS2A7h1c88Jhc6PX3W1u4Z2T3gFKe14xP1bTxxIrONGU4/8dWeoULJpSB+ffBfet128RX+igmLy5VqhlChUG52hpzBwy+zf2oVJD3hb/TSXCc8+8XJSlmqwTw3/0aQATU/2lqPDLDED9AkEI7r2NnTCKxCb3vWWqGfinziJmRI7dPAWqpggTvHdI+7W9tMMPI1lENgqgaN9s37eno9gpj9yIR3c7Gx1PooK32djkXw7BN4Ga1oUO4XOYJ0bAhrU7whCQFexPBQJvbGVgR6xHn+c9WGwlBWiknBwVxnITwSiP5OHaL3RTjXFyKOHfbV1pixbzoL11u1RVOBhWz1nGKo2+WBrZcSInXeOftX/qJGc7N3D8cM6q8sUoYQPDl5WP53T2+T3rdcyaMQ7J/u97VbecWEGUY2S/a4pbTGSwJaCoAYt0tFc5VpvOganpx8MMdDUfQz/b6Cl0zj+m4oBR/v959OvtJREMlwf7bEyAVS9XZRb9ErrIW66hFcc/pG61TugwiFT4kLu+YRXtPoOYz2bLbZp2l7CMSbUV6caiZHqXX9Wm5I8ZMkT7oonyBjOtJTpGMsneeJ8YDmjY+1NSLZR8miv+9Lpt87zamR2YMBsKySRcP5aUagE5DDq1YSw+IvzDMJL/I7pZAqi8RJFuDMaK/IlSpDzf4xkp/dLpkLI6Fz6+S0KDabFawfwh5VLBipjxhyHQslyexjjFOC7HusmBi47L/yfeza3bQq
 YP23X0Tb
 xe6w8jP1dKiQ89w3TjWvSqwTgsUm3ArBEW7k6Gd21lmnlByzA9decR4lyYhbn5ulzcguzEEJ4TvMojK1h2a9mk//QV+HZd1r2kIbUdcviWUvO50WkMDPpUYE9o/oKinZkjpN/kFrI/GCovHGhdRHigG7YPRXUY1iqeAT3r/ih2qyPNFwfWsN0bUc1WOV+2+qS1vxNu5X0BuGxZCpMPqZrPOPdG0Ey6dt34ajejiG9+4BUUFb2JKGCV7UcHi0w6amHB+4QkUdKHgslw2QjciRwwGDyIEOfjUsJY8xSohP9XuIPD2kftbKRO664B+W/fP2Uxz4svgnKQHGrH1BlpZkEQjLKxnZue3PWzGLi0o6fJtXEb5ygdfhI9emLT/r6DQ4TvqiSa4sRZTCuTN3rT529gTrins9omP1dq/BB+kfQ3H6KmxpI6ALbJjK8Q9+ba6JRBR25NztQc4I8jnAt7aLNCvnbqRXLQrc5qwTwvpsqEBm8nCOu5HyBoNLAVljSIBlBcIs5pAPTEcMqlMh4xxC8Ef+SDYNwSXLnywtIKq17OTYe++ILa1v7tSOhfCS9kmjHd3GoeIkMhyF9nD3tGsKxwbwTxpK1ow56SjTnbsdqIO6WrMRR14fx83KWhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 07:30:17AM +0300, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> With the unified fault handling and migrate path,
> the migrate_vma_collect_*() functions are unused,
> let's remove them.

This should go into the patch removing the uses.


