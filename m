Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37F60C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 07:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D4E6B0088; Fri, 10 Jul 2026 03:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416D66B008A; Fri, 10 Jul 2026 03:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306236B008C; Fri, 10 Jul 2026 03:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 131636B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:30:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 794EC14038D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:30:16 +0000 (UTC)
X-FDA: 84972043632.28.AAE69BA
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9D87E100010
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:30:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZS2wxSjK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783668614;
	b=Xx8Rb72oGogZCa8Lep4OjPzJ01A5B0Ej5D9N4AdJlNWoGq+nwqlalsBZP3U9jY6eRxfMI9
	wlYlOcplx5O8pDl0W/a07Ww5J5Ftft9b9DsOl/0Y3HwrgVwXnK88Z3PvzomcrfPUxt6BUF
	cdmi0TC4BAhAXeYAmnHhJhuqhXvxwJA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZS2wxSjK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783668614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WATSgPtpfbLi/5qPX6bFc80cfd3JKyi/QUuUgx4rANk=;
	b=wFhI7F0fwzdIDGnHkdixb50vGqlDRjng/yF+KdQFhfhINNWdBWVWBPRa3nYlrdWBXHAu9F
	tJu1qd+4pgMUEzK1D9PBWqxJtupV+qGwvAYfVUZq85xb2iSeVhNnSHqdc7OChgn80RjkTU
	HUs3h851TyvYkPkTNGY7vFBkw8qI6Ig=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8487088510aso630270b3a.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783668613; x=1784273413; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WATSgPtpfbLi/5qPX6bFc80cfd3JKyi/QUuUgx4rANk=;
        b=ZS2wxSjKDX2nY7RRJ+ftHDoygBQm3TifVS913hQ3ODI0jBg72lVVnQutWZ0dTi9O2V
         nzSQbOc0pNyEatqbtgDl6H1i54M4MED9Kzc+NdPX8Vt9LUv0uFj5mrdDikRAnezGWz5p
         e/lBGt5FrslT08l1ve4nj4IeZTWQhTizauv7KIJaG9YdgCvGTqOrNCzcguwDonnb4wrT
         419Z35fxIbSAP5O3KJq93dIxr8zo2AmJVz+U/fskfO93YkFfEybSam3Y7HPYPJcX76Jg
         o1UnbTvfv6oSTBMb1qEo5K4sEHzdSOD+g91iE3MJ1Yq/HhXuJx4/3L/bj7zkMoKnuuwZ
         Heuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783668613; x=1784273413;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WATSgPtpfbLi/5qPX6bFc80cfd3JKyi/QUuUgx4rANk=;
        b=X9zmaWx1MecCAK9bnR1UVSiO4YDHzgV+VSqEUtoaiC3Oq/sIf+BmxaYmkmqn0bA67U
         d5uh1Fj+j22XN6ha3K2q3eSOrvj0e/kxtO7XhYA/FXU/okgWHfehPBZOlPFHhYR6jPBK
         qUTATn62lObt4SAYUh1yZU01Mi6xQ4fYrzpC2//f0qOH6nnxumCmOxJR8m5CdLUiDc2+
         lxP4bTxq9br5fS3eX2q/KPQKCCrW5q5SEY+8oHf17i7EMtf94G/c0fmbVWlw18JW64wI
         IsMHRM2CjjtG6M89F3zSk+bhD4pYV5IBPL3fnakuVRgiQ6zoQkMAbpWuLUjwoioX+GOZ
         8bgw==
X-Forwarded-Encrypted: i=1; AHgh+RpF5EFroBw7lEuLhmImZMFsd4xmJRYzdSWWC5QllqvRNJXxbdstJ6XMi7uW3RB8GFV1jFlIB96ZFQ==@kvack.org
X-Gm-Message-State: AOJu0YzCs3QOONXh3ZWpJdaBwU4kSSNXzh+ZOZ11slqkbTaJIRO5Wbs7
	UqovQAwiMcMCkVCfsGsnzYPFYU76M7CXxpc/3Btt9DX6oNjMrb5C/XNA
X-Gm-Gg: AfdE7cl8DZ7KeQBZVG5rb4FbaGQxXwf4hY/M6D99EppwNFb3Fna54B91Tf2GyxdD+/5
	lzpmrflJpbdFFtFvOmTL8vMwPYQr0KM7n+ATUzTVEwt9QFzlACK9EhqFCvM05/odwBg7oUaJSMR
	VmDJppw0jg3NoILcCRkQsWRe3SgfOtOraKRTbhl7u/iAvD55RRhx+cvuHQgRGPTIegtW6yvzLE7
	bRJkmPMBMmhI516hWAStYI2UkhXLT4vm4ytTEyUuEEKEQBSI88oDbRL7ixSPTT9qAVwyrZXPhQl
	NQnPGaAipQ+LoYAzgluaxj2Q9F14VQTP/+FvlaQebCkV2yp59TLK5HPzJJHbW4dwP3XI6BwYlLN
	hV1FKpGKpMf3Rho/VeflzGe7IFT3o/jZpAyb6bMu72JVFsNgab/9Q5HThMOiR7ZsW9OF5+EoXgF
	CpAmF8RRT10Eynse1eUyNtP0nYamspBuwXiABhP6Iyvs4vFIEl3v0H+8f5xMCWhSQwAX6f4fuF1
	gSTebklV83WU9wfaWnG/PcHZVbS8NW+rQ==
X-Received: by 2002:a05:6a00:8f0b:b0:846:22ea:e171 with SMTP id d2e1a72fcca58-84842fde6bcmr9857234b3a.3.1783668613389;
        Fri, 10 Jul 2026 00:30:13 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6d7a98asm9738725b3a.42.2026.07.10.00.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 00:30:11 -0700 (PDT)
Date: Fri, 10 Jul 2026 16:30:08 +0900
Message-ID: <m2cxwvti7z.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: nommu: free unused resources when mremap shrinks the vma
In-Reply-To: <20260710054648.924005-1-thehajime@gmail.com>
References: <20260710054648.924005-1-thehajime@gmail.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 9D87E100010
X-Rspam-User: 
X-Stat-Signature: 8k75mant5z68xf843pcscfptrewcoj5p
X-Rspamd-Server: rspam03
X-HE-Tag: 1783668614-555534
X-HE-Meta: U2FsdGVkX1+D3BAGrQL7dA9BPwqm3WW1GCoI9axSxew79armmSNXFEqY6Ulh8Bc/s28FNOEWi3LVC3mRamRUylISK/GO36k8lxaexwR7oqB9lIhboJPVP84Ul/S2mLHPB1NyTlJS/rShENKXvvS0m/qJJWAsGKj3pE7wPRXyU+lv197LPYe8khIpYyP16Bf/nCpgX8Zq6cqEmBURHaY19dW46hDaf8ogaeSAlOvgk9IK5KXjZYhnEqjXHc1b0lui1uccvJBIyR/68bamLoticwO3NsyDFTQ5nZgVYJN/trEInob2OtLc4oAMcdqSfp0DG7ct3cYv51wT4Ibb5snrJsmTtQunSyasC6H638PeLH3MYq2QK74p+evmHHzCPO0J0lHHEM0zZJlueeE74YknglXu4PStJFrdNXpqfyMrSFTaK1EIxGbhVGa0OrD7ce6+nwKD0IzmTQ/j/01GfbkH7zzYQGELR7WQOCmLYaYjeA+kKqIxzgRRmHlxb4zgmmq4YHxkUbOp4q9Jhu7chrRyWetyNymZDrHfCt0mE9fN9phO687t43g6fcBZAr7qBf0c4U5v09Ykk5UV2M7Loi3sjaQYaEaGm7UQrz6ZOn78pXj/q5JKe8NL9FWvTH2llZId8iy3MPHNYOJRPGnVsemp8R8vpCYQJxiCKhlKddMGN/EAbzZ+OPMhN8WcOCls/LHcdLbpHlLiDkNyeSUX1s3PcrnS2dDz1ShiCjzbEGMeCxpHpamcB4+uz+paGd8eiIwYUswohjCSYZCnPuMgbZgspDRBA9g02Wp539s9/5qecNc7orfH60cqruvQFlLpE7qJDRqeXaU94FXzN4myJaYKflB3JwijN/OcWkAYXwiLHF6iphtVmqddRJCiBH4BH3h04MuWAcKCXizoVFlf+dPxOY1f+tZrl4h5wK59QpZlnJBk7gBgz7Tqpc9dfD4cHPSHW7O8KAp8rwEtZJYJlee
 839n4MUW
 KtA29dDF/psXu7QTKP7018R3fF6dCl5uCbctr3OX2x+zRJW6Gp8AYo7Dzy3+3ZYHJUjUJWIRA6qgfMUgbujJPdH0wSOwqwoUrfZzKpUedVo16b3Jhhsy2ZkO4xa/swzHaJ/KJEE4woWvwLTGeLjX7C0Fplxvg5ZAbCrzwUUxb5vTOmxM448gGpzYZiyo+SYe5IMVpneos+MUQe255O4pM1yNBiZ1hM6yEOVI99wsD2Jt51PP1civak3Ss75mdiZXjY/MGp3Z7phJFlvXyzBLrC46qf49gxC51wIDDT8WWmsx9+KBm5GhXh3BOYUXaVCTMgjv3WfTeiUFhRfRFlUsJ+GfeMXc6muDzXpt4Y2DgpemIUFd9sD212hmuF4u6VgPxDsA39L/j3166Oo7zJoSUZ3p2Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 10 Jul 2026 14:46:48 +0900,
Hajime Tazaki wrote:
> 
> When shrinking a VMA via mremap, the bounds are modified directly:
> mm/nommu.c:do_mremap() {
>     ...
>     vma->vm_end = vma->vm_start + new_len;
>     ...
> }
> This shrink the VMA without updating its bounds in the maple tree.
> If the maple tree (mm->mm_mt) still contains the old bounds, a user
> process could access the freed portion. The stale maple tree would
> incorrectly return the shrunk VMA for an address past its new vm_end.
> 
> This commit fixes this issue by calling vmi_shrink_vma() when shrink
> happens.  Additionally, if a file-backed map is to be shrunk, it reports
> -EINVAL like do_munmap() does.
> 
> The issue is reported by Sashiko review, linked below.
> 
> Link: https://sashiko.dev/#/patchset/20260702012546.665383-1-thehajime@gmail.com
> Link: https://sashiko.dev/#/patchset/20260710021028.892645-1-thehajime%40gmail.com
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

I think the original issue reported by Sashiko is addressed, but found
another existing issue, which might take a bit to look into detail
(e.g., currently under nommu we cannot map (actually kernel_read())
/dev/zero, vma_set_anonymous() isn't called for /dev/zero on nommu,
etc).

So I will address this in a different patch, not in this one.

-- Hajime

