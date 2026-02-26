Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87ED3FD9E27
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 23:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F27F6B024C; Thu, 26 Feb 2026 18:57:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A1766B0258; Thu, 26 Feb 2026 18:57:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89FCB6B0257; Thu, 26 Feb 2026 18:57:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8386B0204
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:57:27 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC006C09FD
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:57:26 +0000 (UTC)
X-FDA: 84488272092.21.B4288FB
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id ED97F160002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:57:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HYRLerq1;
	spf=pass (imf08.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772150245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNUgR2Kd3YhmDJ/6Vafywh3aLwITPZTYfqFvR5qMllM=;
	b=SSlZA1i3nn3iRQx0ixKJfJuUn3yRk1SuAoZIWyYRDcRR9K0dkj/BO+SFvjXE7oSw1vxIow
	5OwFaJGwbHtesFpTCgNXxcAwvRKTb7DRehARPyIUwrWRqoBo0xADh0XTWyxTnkULcRvied
	vam4z882yo0rw4TKSCIHkUI0+27JQEs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HYRLerq1;
	spf=pass (imf08.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772150245; a=rsa-sha256;
	cv=none;
	b=pCMkUbw4aIU3YxJmqxPIbjZ4Qwq/gzNOXpLonyNkosi8iolw3IBOt8PAGuek64OYffysft
	0ETepz/PHgug9qdd9bYaRde/MKul8notvrsPFzdC1gi/KB1y8rsLdCipnTFM14g69em8FZ
	VgEY4sqgSv4OW5byUpAH+qUp2lI/0g4=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-124a60cc9a1so3937c88.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772150244; x=1772755044; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VNUgR2Kd3YhmDJ/6Vafywh3aLwITPZTYfqFvR5qMllM=;
        b=HYRLerq13XWS5yakHjngeaPeV7WQ9PWIWSSK3Gy47hhpp7vo+zrwIzzSx6P4l7xafn
         KTYs7VVQqGHS2yPkjfU8VxSL1S3oXSCKEIkgXGFemlx6Y1KYTefTVLS0f2TrmdpUyPtq
         fYmeS4bvdNnyzggOOb41wCV9mEjhdFJcoCgjxS9b/sdZtxCmpIJG3eVNKdIiK5swdIoz
         LHYPjzR0Csh0kRGfWoIPtrp6eiRkaxaoo5q61bDPxt9nVa12e+X8x+MQZdEd969NI6mp
         utj3HhvUGsJ5LZzA3/JZs4tJ/3x74N65o+FDcKTafl2dSZvSkW1DKzCYNiI8eYAW0kjT
         0Vjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772150244; x=1772755044;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VNUgR2Kd3YhmDJ/6Vafywh3aLwITPZTYfqFvR5qMllM=;
        b=gAUik9LF+E8XZ+0bNyTqO6T8tB6aYWRCp6lLR+wdg+nXcpj2jWvWgeCE3vi8E2JaAG
         7vKWVr0lxQAUT8S9WiSO6GsuwF6X1wBUnKFQX+KA9EnUlVlW8HajD3M8DMZZeNk+X7zx
         VWSrZT5872KmZR6rDC6GnqeyKbmUCUQSuNUC4FLYa+BD28bd0ugHzQn2PM1pWZCNs/Kw
         MQSAOi7RghFIYgRTBpuFvycn2bdkeeZEtCvc6Zxdt9a1Aao/JZgsu3Cb2gtf4ruty+Ak
         qAeQEschvAdsUHx5loCEnoTfddirCbCwpuQ3i8CzDK4xDQRmVRnsie30PhYHAKbUDqVU
         F8yw==
X-Forwarded-Encrypted: i=1; AJvYcCVN345QCn698mMj0looCveu5AxXzx4tk66LJrYOTDYDPzFvrTqRWA+hxIy3lYUmWS8m9B4Fd/8q/g==@kvack.org
X-Gm-Message-State: AOJu0YyN0HjrceFm8AbrDEOYzNsyETq0cfyZHulW21/dcbldn0P7Mg1d
	mqoCtg7fxh6/u1psE0zte3CmWdhXtgGg/b+i00Xp43YJ8ayjDthyw9ihNu+xf8H1wQ==
X-Gm-Gg: ATEYQzxwFxzFVVvAW9GqkUllw8mpxTBTNdR/ZUaoummkR6/IKTj9AXeh31CHHiDuN71
	2CKv0GK9cyqlTiVhA3dcKCeWfjl8KOHfTF3gw+Fcooti5e4aObJUuxX2oYzq6JM+7Jl/b+30/t3
	6qv+OuyTS+2GC8sex+blJK7O0hG2M8RpK++wHReZzxc2HcxzzqyB7MUQ4unKMT1Cv2dLCvl1uqS
	Ug3MTO8LUUdCTXPM8o0ghWlUbbd3Z4oWyoeo1up3Af4PuZzN/ww8/OgAagnmMgs2FphaxeUdKN5
	9emEvXBw85Och5ik4h2sovrvXXGGDH456LNuQJzjRX2TNUQEMxZsOSJg8UaK4t7BzI1Z33hceI5
	tOd/fTwLvQdJ+YQEs3fGx1855HpNWU8W2SGYG5KuBRKwIC3ol5CN6kBnFgvFUyE54ciyvFeI4OS
	TtIkg0WNGkYzzkeDCHtgKkb6YwyxlXQncuHcCCKQtmMP/JSA7iCYfE9Gh3d35B2a1W
X-Received: by 2002:a05:7022:983:b0:120:5719:624b with SMTP id a92af1059eb24-12788fcd440mr293274c88.18.1772150242894;
        Thu, 26 Feb 2026 15:57:22 -0800 (PST)
Received: from google.com ([2a00:79e0:2e51:8:d9de:6ece:634a:85ca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdd1f45e23sm2765928eec.24.2026.02.26.15.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 15:57:22 -0800 (PST)
Date: Thu, 26 Feb 2026 15:57:17 -0800
From: Isaac Manjarres <isaacmanjarres@google.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, rppt@kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] A pagetable library for the kernel?
Message-ID: <aaDd3Rth4RLndjvn@google.com>
References: <20260219175113.618562-1-jackmanb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260219175113.618562-1-jackmanb@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ED97F160002
X-Stat-Signature: 1jo53e931azdo4jfkn8id3cbxkrb3sp8
X-Rspam-User: 
X-HE-Tag: 1772150244-150
X-HE-Meta: U2FsdGVkX19R/jf3yBPmvQzb0VIfq7N8UnhVhllC61UidjykL5IXTunbosTn7O3LPfe9uUjbJDwONROUiPBlDQcfVrr65RTvw+igyv84Nde62NyRQk9sucigq2GLMOhTTfhxmNVS7asoQqJChY75Pf/i7qcycBOtMXo9xiUf9x0AuuLnul+A31CU8gKwphJ5oRt7xJRE6XVhQ0JCApxf6dn5hMqM3nJZLpnT4Xc8ZxR6/+5ToHAMS6EJhGt7HB5Fpe76uu9Qit0lRQFlthf5CaxhtSvaYsRkhyxHfvqJB/Bcee5kgfoV2dYX15bGu01L6LirbelJngBGBLdKBBb1TecrG6e0c2gr5ZrrDSZyeaTNtfV4vuynbIhZi4fp0Mfd1mvh2B+azSYUCu/DLfGBcnzSq8VQdfAF2qGiDP4gObhvhr+oCzJGdhp1RdXrHZ+q+1FS47wg/1z5G+5hPq5r9vzoBe6YPhMRRRQlmRDPz980P3vGbkZ8JS6ufwT/BkHXEgLZ6Cwxjh3roLbQpL4dMXzJHOCMcZDjc73AN36/o325mVub+ZDKO9PCiJ8rg0LtN+aqpHKMy6Xr18h/GJHIp3N64P/+GlJUmWkYL5hglpnoBb+WhC2SqBBqnDnnKc99nV8NZudSSrPe80HMYvojaaLsFTECRvQEkCY0GyDhyKwbFxoF9pnTT4izHn0tj5Ij14vLKIyHeTOo24XNXFGEGadwhC+2owLL50dnJwXfFpLZ1UZAS85t4aS9Dvo2MoS4pcYx7MU3xjxhg/Vh+e6Ih3PlMvBra69d3ajtlhIL8xzSLLn8/2FD3OTC8Yh8czNiezpgMN9Hv/o7oyGxFiphEtDdvD0gz+zn6mRtLMeQb6nMALLSJ9Bi1g2pFINrj7enCTQYed+nnZQnELZ0vKWG1s8XtRF9C7bdN0+eRyaGpITnoiVvAIy2JK0RaHrdW8U4VVy/ztbdamfwZdVtolZ
 knrj8p6k
 s5lOY7vojmoE9sMoyN0Hqt886yjIEwznRZ9GF07iWXfdFn3dlXIPLzTioLgvUZew/mensf61IVkctQH+NWnqDGQjb+mRzChM30P9p+u8CquJk+xpGePKMjrIpKGXpxSKQP/a14PksmbmvjSCI+pDSdNM5RcZlxssBEB6g3CxX2ANNfCUn6Ecz6+gka3T/7DaZ5ecoT5djmUvWVH+PoRO0Z9SoVKk99+rIr/Tq+EzngntcVe+FKWJgR/U7PQMr+2GnLwl/E7fAKZeVO5aOl7uX/wfsxYRfbTE5IkGzng9wk0ghOfaN1JLaeJAFRgEpBHxwq1YxRV9TRwGo//JUgpadabJPOagigIUr8zLqYD7hFbr3A/fVm1/z+xKRIWDzOG/NGtba5DJkMB1nLS4DB3IoZ3bYLv7FjgOz50KSwcBL45ciHKu9BPBGlvjcJpkEJz201U2K4HGdx5q2eh6Qx7nJDME8SDYsvoAcmjzGDJb1a7ouZGrU0yFdReA/MTRpd++pRAg+J0XPjEUSzFF9v6IJLx3XxRghXUTGuN4EnC2u5O7vFro3wCJy543ZDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 05:51:09PM +0000, Brendan Jackman wrote:
> As work on Address Space Isolation [0] trudges slowly along (next series coming
> soon™... I promise... some details of the plan are in [0]) I've been running
> into a common issue whenever I try to do new stuff with the kernel address
> space: We have too many sets of pagetable manipulation routines, and yet we
> don't have one that suits ASI's needs.
> 
> Similarly, I'm currently working on support for efficiently unmapping
> guest_memfd pages from the physmap (an extension to [1]) - in this case I've run
> into very much the same issues as with ASI.
> 
> Here are some areas of the kernel that manipulate pagetables:
> 
> 1. The collection of APIs that are specific to userspace pagetables: mmu_gather,
>    mm/pagewalk.c, some vm_fault logic, all that good stuff.
> 
> 2. The set_memory_* and set_direct_map_* APIs. (Which are implemented per-arch).
> 
> 3. Some non-userspace-specific APIs in mm/memory.c, such as
>    apply_to_page_range().
> 
> 4. mm/vmalloc.c
> 
> 5. Highmem logic such as kmap_local_*
> 
> 6. Boot and memory-hotplug support code (your architecture's version of
>    arch/x86/mm/init_64.c).
> 
> 7. x86's KPTI
> 
> 8. x86's LDT logic
> 
> (At LPC I started enumerating these off the top of my head and multiple people
> spoke out with more examples I hadn't thought of - please join in if you can see
> more!)
> 
> By and large, these components are designed completely independently from one
> another. This is made possible by the smart design of the low-level helper API
> (pte_present() and friends), and it does lead to nice explicit coding style.
> 
> Here are some "new" things I've wanted to do with pagetables, which are not
> currently supported by any library:
> 
> - Have a second kernel pagetable (for ASI's "nonsensitive address space")
> 
> - Modify pagetables safely from a context where allocation is not possible
> 
> - Modify the kernel's pagetables while accounting pagetable allocations to the
>   current process
> 
> I think it's time to discuss if there's a way to scope out a "library" that:
> 
> a) Reduces the overall amount of code in the kernel, while
> 
> b) Serving the needs of the incoming guest_memfd and ASI features.
> 
> In this session I'd first like to do a quick survey of the pagetable
> manipulation systems already in the kernel (that I know about), what purposes
> they serve and what capabilities they have. Then I'd like to discuss some ideas
> for the scope of a new "library" and which of these components it might replace.
> 
> Mike Rapoport has shared a prototype that he wrote for a generic higher-level
> PGD abstraction, so I will be using that as inspiration.
> 
> This is mostly about looking for feedback and input from maintainers and
> experts: what opportunities for refactoring might I be missing? What challenges
> might I be forgetting about for sharing code?
> 
> [0] https://lpc.events/event/19/contributions/2029/
> [1] https://lore.kernel.org/all/20260126164445.11867-1-kalyazin@amazon.com/

Hello Brendan,

Thanks for sharing this! I this it's a great idea to introduce a library
like this for the kernel page tables. I'm interested in participating
in this discussion as well.

Thanks,
Isaac

