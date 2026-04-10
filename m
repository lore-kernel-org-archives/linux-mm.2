Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5449E99052
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 07:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2AFE6B0005; Fri, 10 Apr 2026 03:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB1D6B0089; Fri, 10 Apr 2026 03:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCAAA6B008A; Fri, 10 Apr 2026 03:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A62E46B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:55:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D624C1AC3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:55:14 +0000 (UTC)
X-FDA: 84641885748.28.BF2C13B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3B67C0008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:55:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qbmvvTsT;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775807712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbjHJNpu2qynxXHYH1dXr1XYQFmKUciYlwuVkZVhKbQ=;
	b=xDqCq+UcwXGwRtJMRXKbkS0nNSdOGcdWowFljL6YB669sro5byleHTWL4sCCXcYdZ34pix
	LkrSgFt0M0g8X3yNCS1sU6yRHw4X5fSg10QZG4Mx+vX/+FmvJTug16+hN/1jYvP3aLHSkL
	ueWyjLUcfwOBeP59JfkRm7b11zd36yk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qbmvvTsT;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775807712; a=rsa-sha256;
	cv=none;
	b=Pv38EfqCmAw3eOlf7Oz1s2qP8KxnRy9csMaNal4wBzxRW5Q7sCjwTFfFeFXHrgTg0vtkUQ
	5voIjMjOacAru4T8A0XeJ5rl+VkPVRTQPGED+DWgSwnCAMr4JnjXGb63P51tEsx5ve5DJS
	O/SCdtSpyDf6ycdkHCIc73RBvADMsrI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6087040A8D;
	Fri, 10 Apr 2026 07:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53431C19424;
	Fri, 10 Apr 2026 07:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775807711;
	bh=V2WaGIwNQByyApdD9rJsZSORL3u2V1EnnabUeYS07DE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qbmvvTsT63xwWfUSuuYpx96wf2awcOteh5/4PqhMIVYARDxVzvSTWkM9OP7KY+PCt
	 Vcy4Lw9hQjH+DGQVJ9+R9jxxYPrOhBpYQpG9e+FeUWsjxuNQQk5r+RTfwfVz/Kxh6a
	 Ai61m315lOGNCcw7UjcoQX4wfeg41Bbwom4Z86O/3EExnEIUmNvG+dUrBwy8xLDrey
	 P3oL+QPdyYpwUSBGf1pdWvuJi12t5zqskKHezNe2+cXp/ZSmfQeQZgnCX2rAtU2Vz+
	 NkUHMpLvG1LkAml+hatPUafZqtkHi8/vNbVxYKdicJh9FyY4+9G/wKKVUwecVDwmid
	 uFjL4toXO7izQ==
Date: Fri, 10 Apr 2026 10:55:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, peterx@redhat.com, surenb@google.com,
	aarcange@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: preserve write protection across UFFDIO_MOVE
Message-ID: <adis2GsC6q29ijL_@kernel.org>
References: <20260409152822.1073083-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409152822.1073083-1-gourry@gourry.net>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B3B67C0008
X-Stat-Signature: 3cyo1qrgm45aqtu77y198o9s6otax18g
X-Rspam-User: 
X-HE-Tag: 1775807712-464853
X-HE-Meta: U2FsdGVkX18KZeiglJFUe3dm0wf2jX0qu2RZfbOMU+gx1oaVDsDDCDvVms2PFkAAF83XdSmB/PUTe8W4+lRNYSmhbRRfdAmqUiBEBRxE0wi3ne24KeX/Y4QOTrz3xyndSvWEsf7J9OKHpIHUCqImYVq75ZX902jwziidMDX+MaLegzTwNUjoSgQk/4Hyxk1cQICOMxubuvZs+j0taWvmfeaTln5aIVUwQyJMnmxjaoqP+yhLDRfgZPVfhSEsXJO8QoTVgXh/WncYmNJHOuloVlPbjglTeU0jnd/3imI/10WfVkTFra0jJhtyo8ldY/lzw7syq0TFX9IuY5yZjFiVyQ8nBjBfKZeNmLVrMresMjx64iSKY5RKsHSpgBx8hnPBSY2U92iTGVP93yc4dv04EnN28YsGgRj76nWSM6jlbl5U/inRk5tsJ5JTZ+zJHrGUwsLftNbVcZNf8nKkdEfbpRma5janbWnJ8AdiwxnoC1HzayHedxPG/w1hS7mJv0TMvaov4Wp8Ib63X1t03jlAnQ/MwaR6/VRH+4WE2YxuyYECT/NVO/qkWiJ2i4I7dqRTLtrkOGcbZqL9YhBzHBzrhpvbz1jd0xCwdbGkZXUdvled+b/jIPSQQQj+E+q8Jja5kQ7fGV3b72LEt5S0QGTTSvvr3H80t0VDa6pA4HD7fLf3tkU7iOen/zfwVmFC8czz5yDCAks1ei0LqX+iGgSHPwAVE2TqfphEh6SszRE/m+DlCUJs9o2MXL5/v5OsqhtB8pxjz4VXNz9uWwWOglCSauC2k0c89y020BwX0so6wgNiaFNfLaHDt9FQq/lDLALluVcHfkdjier5Pm08AxT2IC1MGcSRLAh6iW/xESMqUKVJJra96w5KRc2B4+DoeNQDPpwWrHhAmhviASk2lmt5pq7ES9UtaKJvcPd+4XcHodTZlbuao1Ui/dp0hOHYAQAU8lV7rBMKBm1Hoijl0bz
 2FkVtf7c
 Ka/yx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 11:28:22AM -0400, Gregory Price wrote:
> move_present_ptes() unconditionally makes the destination PTE writable,
> dropping uffd-wp write-protection from the source PTE.
> 
> The original intent was to follow mremap() behavior, but mremap()'s
> move_ptes() preserves the source write state unconditionally.
> 
> Modify uffd to preserve the source write state and check the uffd-wp
> condition of the source before setting writable on the destination.
> 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price <gourry@gourry.net>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/userfaultfd.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index e6dfd5f28acd..783ca68aed88 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1123,7 +1123,10 @@ static long move_present_ptes(struct mm_struct *mm,
>  			orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
>  		if (pte_dirty(orig_src_pte))
>  			orig_dst_pte = pte_mkdirty(orig_dst_pte);
> -		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
> +		if (pte_write(orig_src_pte))
> +			orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
> +		if (pte_uffd_wp(orig_src_pte))
> +			orig_dst_pte = pte_mkuffd_wp(orig_dst_pte);
>  		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
>  
>  		src_addr += PAGE_SIZE;
> -- 
> 2.52.0
> 

-- 
Sincerely yours,
Mike.

