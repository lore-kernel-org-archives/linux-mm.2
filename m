Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11576C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83126B009B; Thu, 27 Aug 2026 04:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0DD76B009D; Thu, 27 Aug 2026 04:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4F56B009E; Thu, 27 Aug 2026 04:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F5C36B009B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:32:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13DF51C1316
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:32:24 +0000 (UTC)
X-FDA: 85146382608.29.FD01F55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 695E5100004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:32:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HSzghWaD;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787819542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukRIzjVW3PJew+TIHS6IrkoYjfe4R4pVLgU+bG3uWL0=;
	b=DptZjbGhIFBde3PdmvpIPVOlU4rV8F76cItZPlA01v9mUVb1wWyiSz2k+AWeGWpiKQsR5x
	qW6PR09J3p0dBGpfsT0bQkxPrfpnapvvUnaoTZ9ukvgdZkU/tiGb1IvTBobu4p+rA4sa9Q
	04rlS9wTZm2gQFlq0/rKpHszug0TAxA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787819542;
	b=5ThS87hy7YD/DfrQKDFaTLgZPMC+fERTmOkjR3pVtjGj2svs442VqwbQ2ZCgNVqQei88Pq
	bhY/wyEL9TlPE6vEdsifIndYmgxCbdFWbxXBc4UV0sXNkIHrt9KrFH+klRorUw1M4n0DQs
	kp3xW1A/0DULVGC3Hpk546cVv+isdPw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HSzghWaD;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE15F600D3;
	Thu, 27 Aug 2026 08:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6181F000E9;
	Thu, 27 Aug 2026 08:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787819541;
	bh=ukRIzjVW3PJew+TIHS6IrkoYjfe4R4pVLgU+bG3uWL0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HSzghWaDE8ySlLE8IXAL3A7zR55UAstoOY8K5pk/GrZfGVcuGZRHCy8t5WuZTZDu2
	 bzz5DUYMQrmdpgSQBxKADa7P59Ak/qukYQsjkJx2xN9G/HxlK1SgvITEy66G2nFS4E
	 fV/PSNxw/mqa5me1sGrPDFc3pOdaskXANHHlr8ZWFvlwoUPSnkng8IY4szbMEusVrH
	 XsAiDBBi9Ss4dxXAYIjX/s0YELdSLfp0V8FZOCyLTd7C6Taw/WqkXgqNbuYOPmDZRu
	 HhOq1zGzjTqN4zLYtNMyJt5aYGQwGjB4AL7LVDvgoyGApjsHw4pLiCmsUsPuNo0e6a
	 x/sU2NVOlFwXQ==
Message-ID: <34fa1a4d-e5fb-4e27-a53b-b57b96be3f8c@kernel.org>
Date: Thu, 27 Aug 2026 10:32:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mremap: reset unfaulted VMA page offset for
 MREMAP_DONTUNMAP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Li Xinhai <lixinhai.lxh@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+f12658786a4153df5113@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 695E5100004
X-Stat-Signature: can4u3oxtgxwojhxdng3jw8ib8ajd6yb
X-HE-Tag: 1787819542-914711
X-HE-Meta: U2FsdGVkX1/ALlDnXWimRSL0Mw5q88L8jcvSBZ8RIG5QpRP4Q/aoYxdaQIqs/QgNqsBeMyHQeIhgkF8fWxvkS/LYCyrkSYIMpXqcC8TFE//cPOohE6Al4PLYKEQgWtdcjGilYXqVFUtKOmSqGTLNdtP4D5lC71VOLMJ0BjW5DO4yWluajttmpH8Py6K3GNAv8UU/RviXg45WMEzRB+r77lJbPICbL2VLBKcTK0VhTlnA/avZe1Zo0YQA6b4i91g+MKyNvisNNfzlM0V8K5U4ottVtjF3+bRmGDhTS4UiGS59Le0prxAa10LCVn0fHrVuT2CcUWm5x9jOSN3sddee9Uzn6QJDqfxazkrmHckuU9ZMkJ+wIPOD7C8nNGA/7RbIPrE12TWGNaN+XBS/12OvJopgLQEDPcQZCilEo6Bl1NqfxCmZv8f8b8Du3uGOQ+VvjC5UkspYwWJgM3yJPjRpdh9Q3/p5r617D0PWMukZzb5UV2smuYhJ0UTmTC8A5yhOIw9EplYfwsxgvyJgUS6iVPTsOY3Ceu+FDbdZnbqXHbVjut+avJ3311MTLfsepDZ94V2YV97G77wQiIp+GrKkj95nUOaCtvi0eCX0N3z6p5PvqkVl8B4BbSZ0YenLb0Ln5M8p88fMXMPkKfqzQHlmHlP7ITiAqW94mJ4FdzjslSZSwMdXO9Nd6DmofZVDG9waj1C3iqXg6j4sHA29mPu553nGqwFpEDMRYSM7EH6dcysVRKqqWkyytTq7p0fgxKE50qFgqS2khk9DQTR+5N7hUalsBXES5N0R3UsJGfJGCkQZJkyhukI+ACnJZ3GQDMnig5er3h1sCjHU4b7LaH0A15O+l//J47EUnzMSgVKelOFyeaYzeG49+re3VO7WXUBvBXXZFb4xZ5m/Ip/ymJv6WN+4I/Q+mg5MACSZd6L5NOqVpJw1FFVWi61t+zc8pGV0sYHitjOcowczsZXAlPw
 /8XfcxdE
 bygXUiTIoSvbv44f/LfPZHIhO3k4vL5HnHMwheZwOlUmdyWniioWNHXetghKHIcutirsMS5cGAOwgYcw7l+MPepGfvBiBD0H72eef78PcbOBMTvvpXYS5gLM3hTar+fzkHHgZncRtc2poXCqOS0hKRwzuUSZZ9ADAbEPGkFTszUxSldj2zhPJtGVR6M9NKJEC1ZEbBdWYCdEruAbrY+bjWIiLXHV0bTVcqHcPiu7YiFgGOtXYSfCN6y4plQYQfLAM0tP68+ulzWB0eqS5v+uOGol0IrLoo7BbAZjn48IGsdNfAthWtCcm4i1DCmVFJg8/YWcf+SWVxTnGHQueQvn6UnEDReR3R05hR7sQQsB5m0tAv+FMc0NZkzIUv/ejWWDoMr+Dv9b8/4rV84S1mQa4B7Km0xcBo3OZ7ZvRGex2HMbF7dziFJkLoGt4amKEyKQ3SOuJoh2kiMSBSB51lnx884m/21q2C3pg766NNMgeTUWUxv2QWgbb8hcAZgngWIGlcaLq+cdPFX2H5At/rkyw/kKkKfu7mK4YseIR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 9:55 AM, Lorenzo Stoakes (ARM) wrote:
> Uniquely an mremap() invocation using the MREMAP_DONTUNMAP flag can reset
> a faulted VMA into an unfaulted one.
> 
> It does so after the page tables have been moved to the copied VMA with
> MREMAP_DONTUNMAP leaving the old VMA in place which is naturally unfaulted
> as the page tables it had are no longer present.
> 
> However, in doing so, it violates the invariant that the anonymous page
> offset of an unfaulted VMA is vma->vm_start >> PAGE_SHIFT.
> 
> This is because a VMA may have been faulted in, mremap()'d (causing a delta
> between its page offset and vma->vm_start >> PAGE_SHIFT), and then
> mremap()'d again with MREMAP_DONTUNMAP resulting in the unfaulting.
> 
> This condition is a violation of a fundamental assumption in mm, but now
> also triggers an assert in assert_sane_pgoff() which explicitly checks for
> this condition.

Oof. So what's the worst thing that could happen before the assert was
added? We'd use the "unfaulted" state to allow a merge, but the wrong
pgoff could mess up the result of the merge somehow?

> Correct it by resetting the VMA's page offset at the point of completing
> the MREMAP_DONTUNMAP operation.
> 
> Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a87853b.ae6ddae5.3da009.0023.GAE@google.com/
> Fixes: 1583aa278f5f ("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/mremap.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index e8df5cdb0ac9..2b4b523a86b8 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1331,18 +1331,30 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
>  {
>  	unsigned long start = vrm->addr;
>  	unsigned long end = vrm->addr + vrm->old_len;
> -	unsigned long old_start = vrm->vma->vm_start;
> -	unsigned long old_end = vrm->vma->vm_end;
> +	struct vm_area_struct *vma = vrm->vma;
> +	unsigned long old_start = vma->vm_start;
> +	unsigned long old_end = vma->vm_end;
>  
>  	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
> -	vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
> +	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
>  
>  	/*
>  	 * anon_vma links of the old vma is no longer needed after its page
>  	 * table has been moved.
>  	 */
> -	if (new_vma != vrm->vma && start == old_start && end == old_end)
> -		unlink_anon_vmas(vrm->vma);
> +	if (new_vma != vma && start == old_start && end == old_end) {
> +		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
> +
> +		unlink_anon_vmas(vma);
> +		/*
> +		 * The VMA is now unfaulted and it is an invariant that
> +		 * unfaulted anonymous VMAs have page offset equal to
> +		 * vma->vm_start >> PAGE_SHIFT.
> +		 */
> +		vma_set_anon_pgoff(vma, pgoff_unfaulted);
> +		if (vma_is_anonymous(vma) && !vma->vm_file)
> +			vma_set_pgoff(vma, pgoff_unfaulted);
> +	}
>  
>  	/* Because we won't unmap we don't need to touch locked_vm. */
>  }
> 
> ---
> base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
> change-id: 20260824-fix-mremap-dontunmap-pgoff-a687134e995e
> 
> Best regards,


