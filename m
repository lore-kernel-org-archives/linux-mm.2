Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C4010BA422
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 04:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDD826B009F; Fri, 27 Mar 2026 00:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8E1A6B00A0; Fri, 27 Mar 2026 00:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCADF6B00A1; Fri, 27 Mar 2026 00:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A535C6B009F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:09:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 487111B9604
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:09:29 +0000 (UTC)
X-FDA: 84590513658.08.BFB88FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id BFFAA10000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:09:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kg11G2m3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774584567; a=rsa-sha256;
	cv=none;
	b=TV7K3XHFmZPgC4stR4uvWHPoB8Ki1Ut1btCCNPcN9vnv5DjfuOKTK3edPj+yXm2gC0Bot0
	UARFHW9NyAXnkpnvydDzOXUkNjpSgdeiGaGhnnrJC54q8Bl+QcEjKKAIOOmZwlUk0Awzz7
	XayDvVsqjCjZaZJsDw15yW801vaaGvg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kg11G2m3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774584567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xBu6I/pFt0gvzdeda0qc6sMvZUTQ6V0ZmA1phI3lDW4=;
	b=Qa23iyjX7TuLNE0KTt18zWv+P2l2nrYQwNq9vW1rR7+ZjHedNPauxIfMzbFgB/xGeD3VB3
	mzYRqETkc6nMjUvP28xQZCLWSecOFwf13tn1fxwQxc3Ml2lCWzJuhjBflfBW6UGOQjWSk3
	DhQRgGNZXdCi+6otSMuHT6aLs7UbbMQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93D234051A;
	Fri, 27 Mar 2026 04:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1604BC19423;
	Fri, 27 Mar 2026 04:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774584566;
	bh=VhiGD6KtnZd+xe0epOwm1e6fUvTl6fwsBNoGmCIAQ0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kg11G2m3jFiAiPDkATGEvbbcHL/zJ2zmEQ5D2n636p3oUTUSnG/e1d+RpTdkfmaaA
	 NS7AoHYrQd91kVcExk9gziM+pdkx1QnoLNI9NGQN7v91P2pCn9qJxx4r6X2SMcdj0f
	 xv+7Pww3LMLKFqZU3CDaf75z3HJonQQGmtG687gLa/M2m3Whv1AZqKEmHt/tFKVt4r
	 Rltst+bTIfBA9LgrcB9XYoaKL7gLZ9btDXeMWu8j8jBHRSjPJSzA9TELRX39Fg1KR3
	 ExsXg7qkcfsDRS0VA1M6WEpQJnIOiTwRofA6VV6V7Bm33/KACoXMGodk1r+eokiWn6
	 fzXm3rEfsSclw==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Josh Law <hlcj1234567@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kees Cook <kees@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering module
Date: Thu, 26 Mar 2026 21:09:23 -0700
Message-ID: <20260327040924.68553-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <E1A667AB-DCE4-4034-A36B-DAA458780A81@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cno49t7wbi8ouatxknyk4j1p1dsw5nbi
X-Rspamd-Queue-Id: BFFAA10000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774584567-843770
X-HE-Meta: U2FsdGVkX186omniydwRUNEtZAL5RliEmH1KFnF3n41pIkLiMEuUD4gLA22aKtfP0OGzZBWfgnxxgb9VfUOKUiwmkoy9D+CLI33TranDUAvFE5xpOfF/6tJKYbB8mLSEIjPrkrroo6e353XA0qW5dBBYIm4j3emj/1clRBOLpCHFCy4+HwEEqp8vz9Bg2QBVRxd4/+7eXVpq0AbTjEkbcS6lzlp7fgac8qdwPed6Tli1UrFlIXCK2x7bZ3ZMGijqMWTuoYB4F27LmS7fK+ZSWiUeETjFJpVfJ0EdBTV43WaNNtswlsKwlo0nSMO+xdH79lxiI/11Jfy3UL3p7Fd49YzDGgRjGnPv7h6EvrqV5LvVyZMwn/QrYzUiY0cOJog/9PH/EGC0NT58f61afdN4VKT7L4SYOJycboBGUI08EF+aYiZwZ5M4z0YVisx2/QItr6xs7ujLUkGumUHioOtXZTQUDh8BrDECUqqjrWZyHjCLtlXMvv20eOnMhqWxy2BsNsDxfGSRS+dW3h8u9TWoi/JqT3NsJzwy8QRcjoqAXwoA/+fYckw09YwGhPC077FApRn8u70CAALeqS9DnEYZ+JJYMlgtbwh+Uy0mJ8S9mnp0oFkHVmR2R4lETC0kooHEJIsJteT9NJJjkmw/7N860N/oYZr8mTNNUXhELadtxtrWt3yE4dQ/K10VhRfh2Hi7jFDAC2SfuiyB7vQ6JRhe2vKO+v43o1ea4n4F3crpPid4iuafzh8JA/xb2CRZ+WcOlF5lpxzU/zGDxlBvRLBUwTqXKaLZztpoYJ70UL+iiwqJQvki8/EBAcb4QHHr4Fy0P1vkvexVUU0V4JCJYmFU6EDT1hMfnVBYHoPPdrGY7QitByqldyJQI5ixoC8k/tAI2hgkcfgXvd3zhPcz9PZxIv4TcyIXh0elFjvPUkC0FI103/AMCsbxPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 16:39:54 +0000 Josh Law <objecting@objecting.org> wrote:

> 
> 
> On 26 March 2026 16:33:30 GMT, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

Thank you for sharing your findings and inputs, Lorenzo and Krzysztof.

[...]
> I am withdrawing all pending patches, I am not gonna even touch artificial intelligence again, and I am going to take a couple months break

Also thank you for making it clear about what will happen next.

I understand Josh will stop working on mm, and therefore DAMON too, as DAMON is
a part of mm.

Among Josh's patches that are already posted and still in the review stage,
DAMOS quota goal nid validation patch [1] is a bug fix, so it may need more
look and work.  I will do that.

For other patches including this one, I don't think we really need to continue
the works.  So I will just skip reviewing those.

[1] https://lore.kernel.org/20260325155221.202700-1-objecting@objecting.org


Thanks,
SJ

[...]

