Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A5F0EF36F7
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 07:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9832C6B0089; Mon,  9 Mar 2026 03:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CE46B008A; Mon,  9 Mar 2026 03:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FF46B008C; Mon,  9 Mar 2026 03:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 710C56B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:42:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1594B8D195
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:42:20 +0000 (UTC)
X-FDA: 84525731640.27.B60109E
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf18.hostedemail.com (Postfix) with ESMTP id E151D1C0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:42:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773042138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Km9ijWisF4SgmkUDRAWgprhBgoDuMX3ljLXlDkBflpU=;
	b=V7Q18zpLn6ZyUBTc1HAksFMwy82Pwl6ABR+7GT6mvfg0wR80ss/IuA98u4JBcSyZ620XMn
	FX7h7wMrZj6bnLRf6Oy6GUVfBMyCiD3/VBjl27kXGWz4J2W2qe7W7/ggxgeH/A5Vo0r6Jm
	Pm6iJ/jzsYRXG5qy5E9OYPodWtHrWHo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773042138; a=rsa-sha256;
	cv=none;
	b=nzIg9GytJLHGXIdrqXDE0rSaQYwRRIHH2WN9Wy3wdukn/0wqdR7fCE7c0PbdeVwBegDvmu
	T/vHtuy0UFl6iAm4mHjqfWqHSGV/X9kzE/Kgc4KQcoS9KRu/gAlZ7tMw5Va7wDybpB7+8f
	nHgdnPb0ua9UDbjpAPCvu6nae3d9Wuo=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 9 Mar 2026 16:42:13 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 9 Mar 2026 16:42:13 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: rafael@kernel.org, akpm@linux-foundation.org, kasong@tencent.com,
	pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
	linux-pm@vger.kernel.org, linux-mm@kvack.org, hyungjun.cho@lge.com,
	youngjun.park@lge.com
Subject: Re: [RFC PATCH v2] mm/swap, PM: hibernate: hold swap device
 reference across swap operation
Message-ID: <aa551UFgiq+gUl/T@yjaykim-PowerEdge-T330>
References: <20260306024608.1720991-1-youngjun.park@lge.com>
 <CACePvbXVvPp_a89UFztZo5nGawpFea9t=NRisf468VcxHgkX7A@mail.gmail.com>
 <aaqKJQeO8wLQL7Zn@yjaykim-PowerEdge-T330>
 <CACePvbVp=9PM=LUdL=aq8G2Svy+v04pBnf3ygRY+xW3WEHNm9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACePvbVp=9PM=LUdL=aq8G2Svy+v04pBnf3ygRY+xW3WEHNm9A@mail.gmail.com>
X-Rspamd-Queue-Id: E151D1C0005
X-Stat-Signature: dzgk4imr313soqy6min7qgogmh6zabf7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773042136-297291
X-HE-Meta: U2FsdGVkX19jUWtlAQXNMvedvWbvklvpqrkcZi4s4Bdl/+9XHNK9fYRwRmw8KLhe+blbKX+hzrZDsLxWzfM9lTdHuVxWzf1r5A5cmOp4RIYVTro+35HRRWTxAEbqf2uMDvWzFmtxyym7ccKagibwUonwju312RkkXh9C+tXyWVbn3ow6FN7Q8vH2jnCl6V1w6GLmDBdAMJaRVzUhTSDqhzEH7YuHwGmJtWlzWRUf1uEbGah53QQWhBIm7r45rilKn459mbejcFYFjaPOscArKwCIBImOQDkiATfr1mY7y0Fi5B9MxvMCunmF7B1R33LI3dzPpJnBzkP5fOIFqpGG1ahTCRTGfy81Ae8bDaVHDqgQRcD6+8y18SNGd6x0eh01fXNHhSqRoCYLiZ00chLJbImvvXwC3SClg6IJtBDd7tBQjecOOcjf0n0fKWWwnb7HQHg+FowCmYf5VH3+yIngPZ+qlBarZzr4LNme5obW/5xDWpVVTx+n8YbcqrKkata4xMuw/tT3fAIHpgWOCl/kRYMuw3fOVZv9tZMoUnL/xetZVi7CDxvWkKKCNi6lhOVM/Ha1qhQpDY3c3cSuXKzWNbS9Y9YONspEY+SjzM27I4GqkYb4wqqbcwvlHIa8tiOMO5Nw2C/GeriM16CkDFIHxaUMonJSXgX1vjdcfhxx2NMJuO3AmsC03jqOKr4rj+Dmsv5hiJVPgQ5X0aTiN+isnk9YM87RFSpPSu9Nmh9mOvvIwDwVyci22D48S6Hhvw1Kyv84nSj1uo1iOIT3UGAwrhW0BHbaSH+McjsjWAmDSYNq6IuzIS83rKENEdHVA2VEBKhf+EkDefNFTx3EC7CIqIXJ3c1IP+gpiImpbVxkA3oqiKNQSH7brcQwPJr8E7DP29qOLKkAJY7ifPsmPmPOtjUthYVPLdxUaxGMvj7810wVL7mT/P8FwinLo5quGXAw6UEw8QvrHS3uEpz+wb6
 +L+WCQEt
 vt3sql3KpDa9C2d6/H7umZph4AJ/qSL3pjFaw324ntdXgkCwz47ezyyFlHbnvItwCn7A7qGfSEECb84gA/O8YdlehuSCEgHxAC+0CytkTvJP+lTW2Ga6yOTIKkARqrZbRiBsH2/abFQB51xmuekoI+hg3xzd4/pAKJ43V+zmfgq4qHH4pD1XsK3T1sy0bW++lNu3p0JbYwRrKQp0+WGPRe1/khg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 08, 2026 at 11:43:20PM -0700, Chris Li wrote:

> Agree. That place needs fixing. We will make two patches.
> 
> Patch 1. Fix the swap off  racing between lookup and first allocation
> on suspend.
> swap_type_of() is very tricky for the device swap because of the
> conditional lookup of the si->start_block matching the offset or not.
> That make this patch very complex.
> 
> One idea to brainstorm:
> 
> So we can get the reference count on during snapshot_open(), after
> checking "root_swap" still points to valid swsusp_resume_device.
> Then we release the reference count on "root_swap" during snapshot_release().
> 
> That might side step the complexity of  swap_type_of() doing the
> si->start_block checking.
> 
> It should fix the bug you described here more simply.

While that approach would be great as a minimal fix, I think we still
cannot avoid the following situation.

Until the first swap offset is allocated, we cannot guarantee that swapoff
won't happen. To be safe, I think it is difficult to prevent swapoff
without holding the swap_lock.

So, to stick to the minimal fix principle and only address the currently
possible bug in uswsusp, we could consider:

1) Creating a separate function to grab the reference for uswsusp, and
   put it in snapshot_close().
2) Adding a parameter to swap_type_of() to decide whether to acquire the
   reference or not, and put it in swsusp_close() 

On all strategies, we do not grab the
reference when taking an in-kernel snapshot, and do not add alloc/free
get/put.

> > My proposal is to grab the reference at the lookup point to close this
> > initial race.
> 
> That is my suggested patch 1.
> 
> > If we do that, I believe we can remove the per-slot
> > get/put calls entirely, as the initial reference is sufficient to keep the
> 
> I suggest that as the patch 2. It is an optimization to eliminate the
> get/put pairs. It is optional. without it is fine in terms of
> correctness. Might not worth the trouble for patch 2.

Yes, I agree. I will split the patch into two as you suggested and think
about it further.

> > device alive until the operation completes.
> >
> > Regarding the reference release strategy in this patch:
> >
> > 1. uswsusp: The reference is released when the snapshot device file
> >    is closed(snapshot_release) and error paths.
> > 2. not uswsusp`: I only added reference release in the error paths.
> 
> That part makes this patch complex and harder to review. Need to
> carefully check whether we take the reference count or not.
> 
> >
> > About 2.. I conclude that on a successful resume, the system state reverts to

> > the snapshot point, making an explicit release unnecessary. However,
> > I am not 100% certain if this holds true for the swap reference
> > context.
> 
> That is the part I try to avoid: the very fragmented error condition
> for reference counting.
> Hopefully, with patch 1 idea we don't need that complexity.

I agree with you.
But, I believe it can be a safe modification that can be sufficiently
verified through review.

I would love to hear the thoughts of the hibernation maintainers and other
reviewers on this. Although there are some complex parts, I think this
modification has clear benefits.

Thanks

Best regards,
Youngjun Park

