Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B38ACEB5961
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 04:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABFF16B0005; Tue, 10 Feb 2026 23:08:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6E196B0089; Tue, 10 Feb 2026 23:08:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96CC86B008A; Tue, 10 Feb 2026 23:08:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 836F56B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 23:08:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8288571FE
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:08:32 +0000 (UTC)
X-FDA: 84430844064.05.08E8405
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1F0C24000E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:08:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QMKZovQU;
	spf=pass (imf11.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770782911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=D2eMYc+39p5sjw2VZLfFJ4kKNtq8lBxRgNa5raKSCaw=;
	b=vfsaCJowgCht8ROjfQYHD0a5lO8fFHbRCMIYsJOI3xqcyX56fmtdhPYZ2V/ClbrEPshF2+
	+Qko3WTk0wQvf8GbOJSStjH53RkeZt0IIt4bLQxejihfzDatQF1gD8OTZDKGeOgjpv18wq
	vdP9Jd/mzXXA299J+cjb0xBml/0rQr8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QMKZovQU;
	spf=pass (imf11.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770782911; a=rsa-sha256;
	cv=none;
	b=eCJp5BUPYHJ1vkOzIx35o3mJPt+9fnFMBb2tl/TCcA27nv6mCJjp7oCuoedzIw8CppFUqo
	QtDd6JOe/YZ+rQDonNqPzKIia7R4IGHM5fuESL7VUm4eU0bTWgFUv2vIxR1/1jM1lGHIGh
	VNbj+SCIVDnzbd7QZTzVVUYm1/w3dgQ=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8230c2d3128so763808b3a.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770782910; x=1771387710; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D2eMYc+39p5sjw2VZLfFJ4kKNtq8lBxRgNa5raKSCaw=;
        b=QMKZovQUxSRwDaAyuSb9nMxygpgYbZjw2PAPhlyAGTmHbMtb1gDH+15ZUaxitOpK85
         fMtmFu5n9K5O5Ybdjqx4v3r86EjiKdGmJnjh/hbQudyaBaIxlMxhP46udG8Z97ZBy8bi
         h3k7yu7FSFxhh4hdPeWiJdP+qMfbRIet+cttNInusGtdIUv41LJ2JOiPIV45avJ4yKFw
         7eBBsa3ulUxtmNji/wIf180uGFL+uMjXCfHiuTdOLIM4yVWKDnX1sRTus1YBX4Cj3tX+
         qhTptmNVrNDa/dfOyaIQQaSTW8y0X+e+PWkKRVp9o2X+4sWhfdeeQjs7XhfqVo7uzvzn
         yWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770782910; x=1771387710;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D2eMYc+39p5sjw2VZLfFJ4kKNtq8lBxRgNa5raKSCaw=;
        b=ZTfXOHug5gFI3hUeAKwZ9zKlSdIKRTu+2Kq2qS8svQYmySj2R2RZ5P4In27nEgkSsH
         APjozX1b/Mjb/+HFrl5FQ9Q4iyYFfNiMGauT+gQDtTdcXB31lIEuKFQNVLzUfWF9a8kp
         8jWaOxJsPYePlgcuS/Ff76IIwvFVWrgNDg1fjVE6OtvUtpEavpaz0UvoiCo7qa+q0zZm
         LClMHncww8e2qlhUrEKHxhvcJv8fFXKm2x2hd0Myt/6om9f8eQc+WSzYjgqpT+Kkdb16
         /xvDFxmGzhl5a/fpVFP0RhCrIRqqNdvJIk62BfGVJuKNX2SAscRH6uosqD1KEuaI6HTT
         VWyg==
X-Forwarded-Encrypted: i=1; AJvYcCWrlfP8yR2voLNftMZk9FIbKYjed+rGK3stFL3akoOAyk3Ssj8zF1CZDUDtl6HdBpHLhDt+CUzWAA==@kvack.org
X-Gm-Message-State: AOJu0Yy+IbqEX3IMfka42FeMZE5UVNUJRdG2CU5duT6slJQiFULem4x4
	ubuHcCYqwaDe13sbJbjlaW/fTwM/6uwCHjHMpD9QVGGvkAuuh7AgCRCD
X-Gm-Gg: AZuq6aLafnufSwwCPR5co4tk4ZKTLzdHRiNd/E2fnVoWry5wPCLoqJxeVeS/ssbcOhb
	m7hP/qESmuUADiZYewNhEs7tkWLin0rbcnimpGaBvhnakzx7Ts93ZfeKH+8Y507yas4tCp7Iloc
	gxEPJoPAeT1ZhVWs/END/QbEVtAAa9QnZO9GDlTiyLWG3O21Z2ZbWuATQVpiOXRa3CVEktP3TKX
	5q8Llec4/6tk64ZViza3qwFhx2GLRM+4vKY9eNzfLgNnt1ggjhkra1Ot/n2ErUHvW39Jym/kryN
	tpFc6omIxj1OreScohXSWBV3Fd/k0pdVR5b509i8/omHs0XxUf7Qsn3a2+2/2rsyr+sLkOojmfY
	BC+sIzcWcBTzdOX1cz2A401m41azxc0EVfHd3U3A6TaghxjfyZZy78/LcH74afMYIn/Q1gpgkds
	V7Y6klXE//GP1v3iRH
X-Received: by 2002:a05:6a20:c995:b0:38b:ee34:24f4 with SMTP id adf61e73a8af0-393acf8d036mr17280014637.15.1770782909791;
        Tue, 10 Feb 2026 20:08:29 -0800 (PST)
Received: from dw-tp ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e7d5e7csm568794b3a.33.2026.02.10.20.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 20:08:29 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, surenb@google.com
Subject: Re: [PATCH 1/1] mm: replace vma_start_write() with vma_start_write_killable()
In-Reply-To: <20260209220849.2126486-1-surenb@google.com>
Date: Wed, 11 Feb 2026 09:25:51 +0530
Message-ID: <874ino0w8o.ritesh.list@gmail.com>
References: <20260209220849.2126486-1-surenb@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1F0C24000E
X-Stat-Signature: kogznugd3b645wuyut3f3p9od5fzefnf
X-Rspam-User: 
X-HE-Tag: 1770782910-956562
X-HE-Meta: U2FsdGVkX1+/hZ712kZ+XrBX8jl8CiNmA9ukTuIxMoKCdWA06+7HlWgH73IRtX0QyhE8LIY/A771X8fHCOPivO3HQQ8yM0qBfhWGJtxOztikPUGOCZWAy5FzkHDIpGdYaBBfkNXVr31dRP7zzKjb9mmdjeEvxU9a+q3gTSdZoNjfqRJ2WncpRdcbMuhdny7G2+ljFnZ8tuRdYf8eZqVs3Fmvgjs3GZe70KjtKLo75S6+UIRqtty8sfJ+UVb7AqXafiL4N2q/CGm2X+slkOu33JqxpY3/XEQoXt9QxfsfMWr3ji2JG4NyBoIzYI5q5jsz+B4gkaurjN5r1Qkjphg02ZD26CvrG0qUhO0GHHdNBjSdCyY9BdcviX2U4yh+bs2YBnsBH+GN85Q7AaujZOqNruGnoon/MSXTE9oHa5GeAB4AdqpjOl8DvcCnVaiAbnj55c7Vv9P08IVcaGHGRUoNu+Qwj0VFe6SnuRevQEvG68w9LqFDTkkdkKya0dh0NLB+ztnJk7U+CoJyCCb9eajrenp8jhpEr5J9ITG8IhA2kSegzBQ1llYNXQPZiD7PB/t5gVDpJqfymqe7ny4n0AhK+QhVOworh29hZy9PmJzCdYe/HeXL6hbCZk3X0g0qk4g0EIG9avxPZbxh0WmFba3jmXYh3Ha7HGLmvs1BsHOrcJIxq+zIjtSEyOTmQM6t7ST+OaM89org63gqAezG8U9JlTFBumygulxK/YBTWo8Z4XhEshZHGa4qIMqr4VZvAMKMy6aGAc767+klMm1fvGLb814QgBn538cIhaDqz/h+XTmffeaJqs4p0T0nIB3lWjrww/N0K6C/mpym2nTq+mIYfKrW/VNrlOlZ/J3PABxv7IEgOAlQy+nmfvzwfcZK8wpnYTctNQtOCQfu+9hx4qwgseWK6/brHPtCqAw64Jtu6Z4vef/RNqOGzIu66wm9W3nBMpkz10o7NijyO6t7nvc
 wbaCaHji
 yypB64BfT2dLHnCKCw2NL0mwT2r8G1vXFvB0F5kZDnDQA4o0YbXeloavLK7pbqdK3j+9t75RtFl6+yE0BN9p9LslnDQ/qKACMPDYhA3mhtb+IHeimq02n9iGrJVDipbpXLtMKgHLVKNKuE0r8ANxvGyKyhx4cA1geSr3Dya1XLkGCLIBgcNhDGaoIttoHbrWXsV3ZEGDFyhy2iCEIB/uQFR2DWiXR80hkhB2ufJReEv3nzylO0beTHnkmNfGqjjQusz6R++9ndedDl08EEMgUyjbt1/LIPg6T49gSsst870R9LB+96LBMeSq3XEd0HrcLk7Tp0kv/FIVhv4vFSXak/rMtj4k7t3K010Ss9jb2NdphsuGVTZnb6EPiYZWSvBDwcCyv8KD6D4wzPe0I0gvxIicDNWbB9+EiteM7VzI/SfqsoN8xCv1L3OJly3e7gnxWisQAfVeIoFNRZFu+VOMDYoh/rIGyvqd0KAQp2OzJoeubh8WhOC3E3m9xInMwW7OIExjjyzJYU4MkegE0bDig8m6TyfOydMUJvpY8qq2rC99LTprfddXXDWm9CpyMuI6kk0FhyKf53lHtqgKy3RmaOvGhMbxaodUO+vSDtkuoeKSbPvzQ1TKYFnFjXgGT1bsi6cphJ9YNAxNQZv4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suren Baghdasaryan <surenb@google.com> writes:

> Now that we have vma_start_write_killable() we can replace most of the
> vma_start_write() calls with it, improving reaction time to the kill
> signal.
>
> There are several places which are left untouched by this patch:
>
> 1. free_pgtables() because function should free page tables even if a
> fatal signal is pending.
>
> 2. userfaultd code, where some paths calling vma_start_write() can
> handle EINTR and some can't without a deeper code refactoring.
>
> 3. vm_flags_{set|mod|clear} require refactoring that involves moving
> vma_start_write() out of these functions and replacing it with
> vma_assert_write_locked(), then callers of these functions should
> lock the vma themselves using vma_start_write_killable() whenever
> possible.
>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  arch/powerpc/kvm/book3s_hv_uvmem.c |  5 +-
>  include/linux/mempolicy.h          |  5 +-
>  mm/khugepaged.c                    |  5 +-
>  mm/madvise.c                       |  4 +-
>  mm/memory.c                        |  2 +
>  mm/mempolicy.c                     | 23 ++++++--
>  mm/mlock.c                         | 20 +++++--
>  mm/mprotect.c                      |  4 +-
>  mm/mremap.c                        |  4 +-
>  mm/pagewalk.c                      | 20 +++++--
>  mm/vma.c                           | 94 +++++++++++++++++++++---------
>  mm/vma_exec.c                      |  6 +-
>  12 files changed, 139 insertions(+), 53 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
> index 7cf9310de0ec..69750edcf8d5 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -410,7 +410,10 @@ static int kvmppc_memslot_page_merge(struct kvm *kvm,
>  			ret = H_STATE;
>  			break;
>  		}
> -		vma_start_write(vma);
> +		if (vma_start_write_killable(vma)) {
> +			ret = H_STATE;
> +			break;
> +		}
>  		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
>  		vm_flags = vma->vm_flags;
>  		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,


The above change w.r.t. powerpc error handling in function
kvmppc_memslot_page_merge() looks good to me. 

Please feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> # powerpc

-ritesh

