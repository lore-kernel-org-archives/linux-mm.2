Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCE1BCD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 23:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12DEE6B02B9; Fri,  8 May 2026 19:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B81F6B02BB; Fri,  8 May 2026 19:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE89D6B02BC; Fri,  8 May 2026 19:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAA626B02B9
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:38:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D9D71403FA
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:38:47 +0000 (UTC)
X-FDA: 84745869894.24.0AEF1B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id AD46C160011
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:38:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=a3UyS6ah;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778283525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HEMx0+1xXAxhHI84wAkwpnkPM01Amt4qCDp0AC9y6Q=;
	b=WYKOz9QWJZMKSUhRdGOyC8DVjXnaHZ6YP/zOdGTJnqDOEbcRuotV08nyy8LvePJdrs1SBz
	Y/V3m+qP7whqolFgsxpYz63zqwboSU1u7T+WcBMWEelfi354ECCUhcEwhmz58KjUczxBTM
	fSM1E8SKO5ASl18k2nPrZcwuhVA43wc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=a3UyS6ah;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778283525; a=rsa-sha256;
	cv=none;
	b=g70wsfAZAqMUUuA3hw8SRmGYwqscWPv3nfNLEhuF+rPScxDp7+6+datteJjnGZEbQFCA2Y
	FctDXCkHzBiy1aglEplOTT0wuyVEI5qqDYyM+bJppaM1+fklqvuPBwOFhFC/NMRVUzGvMK
	i7JRA4F1F2ONruhRyMcP1j0oKx19NSI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 55BA7407A5;
	Fri,  8 May 2026 23:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9ECC2BCB0;
	Fri,  8 May 2026 23:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778283524;
	bh=7SrJUw9OQKNpHvI7CtXMMoCOc15QJdzCvPwUVAc8VNE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a3UyS6ahk2trguKf8SG4/QJFZe6zvkoD9WodHhelT7yKMjUNTDpJd0fxm/guCEknI
	 8C6G5eoi5i0mnIK/SV8AGZuLzTobgjxKc3KnFSfwaiXnkWDrtm12G+AIByCr+p+gkp
	 U5knNUaj82pN4HfbyJI3+78xqsA1Ugyw4C2Lk+gE=
Date: Fri, 8 May 2026 16:38:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: david@kernel.org, ljs@kernel.org, hughd@google.com, chrisl@kernel.org,
 kasong@tencent.com, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v3 0/9] Optimize anonymous large folio unmapping
Message-Id: <20260508163842.ad2b2202f827d3f86228758d@linux-foundation.org>
In-Reply-To: <20260506094504.2588857-1-dev.jain@arm.com>
References: <20260506094504.2588857-1-dev.jain@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bpq8j1yizt7aj1tqj1mmdqmzoywjksq4
X-Rspamd-Queue-Id: AD46C160011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778283525-477135
X-HE-Meta: U2FsdGVkX18KdQEMo+pDB4/VxoyZW91QJQKrNeklmKNJLndCcPjHBW/yxCe28avLb09RMf5mjNHMGysyJ/XjBMp8Z7QkL59Y2YWcSoFDJWbcx9O1IZOoBOI622bBvZItPL7HcKEPcNX8ZuGfEcqk0QdbjQiEvo31315/o71nd70DpS1i7yiWnxg5I5j6rptWEZE6dPkR9i9PmDU06oSsjNVLbXTr27mrsUZLkGYJPM6PTrBgYBrb+WZ6YwRwunmXegCVWh9GDY1dxILVyX9GrFpBlu2N9Ggznd7l/j83Z/eW/JE93BklPmTHm6i/jZJcO/spWSR0gSMM4O889V0qAG++OYXPPFF8rILaIfV2GEEAUHrIHxGttDSgyyowy0J7G6BPLkpDnjcytj59tMfH6SO4jt1u9c2cM0edKaoFY5AsNaJxf1iASHPvtfkUz3dB5DMGtyCchtI8K56gH4VkJAOU8x5voYdgJHV6XNWgXs9JzJwXgaOUkOLMw+XWU39k+lJZ6Xj2pYoChSQZpKdnzzH3T9vOOdfBJ3qxI432rvnM55v60Y1UOOvrQwNTbWcnWdfME5ndv9ZJSQyYw05OyONRANv+iSHZQNdgBwa+IS4s0wVnp+GovDQZvfI5sgLx/tsSpyPIDCZ3z1pCLm/Azai4lorqMN9SzwoOcoS7E2X/DlqjhlpS6yVCukZv0SADsu9LPHgXoXpqz07Gxm3mOIWxnHGxO6Upe4wc77WYIn4l2edwTQhRcADsIq4h1uKWLWce8oxeOxLuwO6sr2GsDcyTbXWzqKiqzpkCwpsTjex4LIvKZXyhY0xDBwdrGFwr/JMdhDiXrHijYSDTQFTxDARgMncsGltmvIjhBxEzy7IJIoW9pPB32Bvl3jDRK+sg40I7pCJVxPkcz5tcADPNRnBXnjHo2M84u0LJ2psQ6cqtQnIsEmeO6WEYsaw4EUEV4zE515Cz+h3x3ZU4w0N
 kqa998VA
 Fcd/ZW6zApqHnBxbJiZHMfCYSXmNGNzyYTmTaX6kMFXiGPdr0wxN0WhXWbdDxeziwe73WwzvWUl3zK51vJ0R6acDHdoetCvBqm5UYoEWTxbRkdqJkdpxs/+xvnvbc5VN4i4B3F7CAPsek4RW9TRr3z2oD1DDbQdo/75Yh38SRCzZ+ZDXoVixSPo3Nyc3ZH0A54Q7WYDqAp1343W5kOGjobeeCXvKz2OBcbceJftyrSF4BkR4p1CZKFKnA6gjWeg6O5zBDRqpQdGM77FXIebhaN+3nceunev93IJywWrhp+Lf4SYm5GkdS13MRQqpaYuzVf8QQ7N0/Sa+U+rw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  6 May 2026 15:14:55 +0530 Dev Jain <dev.jain@arm.com> wrote:

> Speed up unmapping of anonymous large folios by clearing the ptes, and
> setting swap ptes, in one go.
> 
> ...
> 
> Performance as measured on a Linux VM on Apple M3 (arm64):
> 
> Vanilla - Mean: 37401913 ns, std dev: 12%
> Patched - Mean: 17420282 ns, std dev: 11%
> 
> No regression observed on 4K folios.
> 
> Performance as measured on bare metal x86:
> 
> Vanilla - mean: 54986286 ns, std dev: 1.5%
> Patched - mean: 51930795 ns, std dev: 3%

That looks nice.

I'll pass at this time, wait for reviewer input.  Most reviewers are
jetlagged and exhausted, so a resend might be needed ;)

Saskiko said a few things:
	https://sashiko.dev/#/patchset/20260506094504.2588857-1-dev.jain@arm.com



