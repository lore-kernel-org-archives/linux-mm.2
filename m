Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7186FCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 07:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCAEE8E0011; Mon,  1 Sep 2025 03:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54E08E0003; Mon,  1 Sep 2025 03:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1CDE8E0011; Mon,  1 Sep 2025 03:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4D58E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 03:41:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B0771DE95D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:41:25 +0000 (UTC)
X-FDA: 83839886130.06.5DDA9C2
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5A78940004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:41:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bkn7o1Mm;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756712483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTibsjsZinMAL6mt7SzQqJlZlrTvbHjOaiEQY+Pnxmo=;
	b=PZJcw4s0QsE9LLAWKhFOIiL5LRki/s52IoDKUrAAr7afnCmrYqiE4QJoJN/aM/QGpzJYnB
	Sm2SdD/Mps4cG7N6QMeV+ZCsHR6I4b3kq3eAn1o3KzlW3d26pfwveHiPf9dlkdepnMTcYJ
	XcDykSrkUf4UC0i3RI1CdFh57apYvAM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bkn7o1Mm;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756712483; a=rsa-sha256;
	cv=none;
	b=MIMUOA2JDkrzCmwEeVD28zQlOM+9CijGq7+bwLiu+6/1XU7iRgZNKlg5OCYj0P6eDrD1TG
	0UVgENRijVgbK8/wcV+NKdcVOtKwq7Ikgj63uCCzcwCxZYPDcu6+7O2ekTVMbRXbUE3kNq
	FMkPsqXiEfOOD9bCVFSRP2EwvnTplno=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45b869d3571so1628775e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 00:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756712482; x=1757317282; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fTibsjsZinMAL6mt7SzQqJlZlrTvbHjOaiEQY+Pnxmo=;
        b=bkn7o1MmdA6nD6LAhTpHFhRnBbdjSGCi2i1NMNMMJH4tuk4LX2BhXqgizecTf3KsIr
         UbiDr0MI7NycNRhbLDJgHifFI0vLBkuZWqNuPS/2YBZQHRYEYDbtVT9MoPbqyTAn7hiv
         MI2aRukhyrQxfkiKW0ltK8W4sRcIp6ivW+4VN+G30stHL/XtUuDjZB8OlezzGSx3X2DT
         RrBtA9hsgsQqwob9V2e4HGLIk26hl4HvqieOHrZV+xsSZX6C4J3g+9vsByfAvl70+NnJ
         cg4QPR0lzvdZ6cIW2w1keKKHU/aIeHQiEibWT/9VbPBm2BNcX5Rvzp9edogOYaaSUQQS
         Q5Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756712482; x=1757317282;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTibsjsZinMAL6mt7SzQqJlZlrTvbHjOaiEQY+Pnxmo=;
        b=fogBB5zZoZQM3fMds9+Pqg6aLOvgeJxz4FJryi5c63/2tFRM/wPv9VTQPTz4ijEk9c
         GNdM8hx2bOI0kNkkt+RLE5UnfMDGGMycpWO+JEAO7bwYGaxkGwt4FORvrCzqHd2nNFR5
         v0GJkefT7HMAdJPw0FSNIdKA10r/zWJNhSWm4U+pfIx1uim46HJBF4BfWfxndmXAKSN+
         l/R/3f9hQB6cnD54ztSFhoYiL1Nc+mrqxPqXbxc+MKuF3mr/aCqBojSGJff2A3Fro6ZS
         4vHqD/usE37oIBPu9lyXKWZ3njd+e1W4luIesQzIySXZAn7l9K9TkMSWJFhYr/ici3mQ
         ZTnw==
X-Forwarded-Encrypted: i=1; AJvYcCWQcq1Du8z+hB/VNoLpqEypR5weTE5nS9GSiHGYx5l/VoG/g21AJ6pevdrGOw3JxBWvq4F6biPKLw==@kvack.org
X-Gm-Message-State: AOJu0YzQ5ib5GPR2qUG+e04gdwA6oKjoVBMYPRayLOkN5DKzRxeYl/SK
	3JiuXaOl09ffwM7+tn4dalgI6Ug+u2zTNznmugCvGWyTlVmoqLH3J0fojpdYfq+PqQ4=
X-Gm-Gg: ASbGncuZ9AwF9Nv53udHJdv2vfDi4W3Bm35iT/mUKCId+zjkxg9LmFiH7EVbW/acX01
	Zz3PGrDVS16ANLGoQDz/4hBJQjnxtepfjF8g0XXzB2nuJR9EHfzO6iGsIlXi8VZgNPmmezKzirg
	PdUuzt84+j4rNwJPR7qBhUWsSM14rbmO1gQEQFNrMsSY8dRaJiT4cu16ucrAZs8pJl+IuHjTpsf
	EFd1jsUqIqyThp3vbFIIjpluUEAHrT4nYrSaXkoH6NY0HqBTfCgL5yy6lU9icasmhqrUFm3yqSE
	l0dSc/glg1F9ACNCyosZ8mTxLO8ho2PkqwkjgT7kxbiw1SWZm2yOQ8jf0hgA0Mq0xIR2a2zK5g0
	00pfPWqPbU4conBJ7V4hZ3EDAotr/PtjA65MnweCImt/7qTP+3oRcAk1M
X-Google-Smtp-Source: AGHT+IEOHCc1C43y9L1dHpZXh6OP0LizmCzEwU9EaGTg2xElyTZrzgDrpKZg4MhMcKWHXdtU0bUDNQ==
X-Received: by 2002:a7b:c3ce:0:b0:456:19be:5e8 with SMTP id 5b1f17b1804b1-45b855c980dmr32953665e9.20.1756712481379;
        Mon, 01 Sep 2025 00:41:21 -0700 (PDT)
Received: from localhost (109-81-86-254.rct.o2.cz. [109.81.86.254])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7e887fdcsm145730905e9.13.2025.09.01.00.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 00:41:21 -0700 (PDT)
Date: Mon, 1 Sep 2025 09:41:20 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, liam.howlett@oracle.com,
	lorenzo.stoakes@oracle.com, surenb@google.com, liulu.liu@honor.com,
	feng.han@honor.com, tianxiaobin@honor.com, fengbaopeng@honor.com
Subject: Re: [PATCH v6 2/2] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
Message-ID: <aLVOICSkyvVRKD94@tiehlicka>
References: <20250829065550.29571-1-zhongjinji@honor.com>
 <20250829065550.29571-3-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829065550.29571-3-zhongjinji@honor.com>
X-Stat-Signature: gkbj9bw8uqk75ti6i7u85myisamjcgpt
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A78940004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756712483-926772
X-HE-Meta: U2FsdGVkX1/2Qf0QZv/6CfDz08GcixBK1azCuvrunIm+L2sDGgrBGA4J9E0EPfMvwQgjHllU39WegDWKHTsUA0UotMLDeZ/Q6MklZQBkuudr4t2cf52quY764yiA1ansA2L7Wdn75Kl3kn0mji6rnf7igH4Icm2TnMxPVKfydSTEUGK14mQPxBKSLyHtsk/SxXA3XVjl55Co+XCtQAU53jpnskIpO1Gnx6EFJwCC8WHs6S+aP0eQ6mHfL+qhqw03KqChFlSVxqBP4Tco530MPsx/9p8LVJCFHM00iOTVZ1nYN6oI+Ms+1+3ouU/XOgbgRO/jTW0ZGwdhWHQ++q+c6ozopR8CH0OnX0mKL/Jr7sgYs505gzFEPRIs+Y1MORfYCgyWN7kFSHkGz7wXGeycsRyPXn2oYkkgx2N67eZy4MKs1tHbSW1oHO/12+ROsOM3D69Sak6JvnQC2JS4a60u3fva0br5R4AMeG61BZGEc35M0pw4i0YF3Xpv2d7fmDyJbmfj47WCSDVLf1bv64obTEFDI4SxEYKeR4Qpca+3+Lbn2kHLMC6DNJYv1vKtGjK0bWmvou3RR7MwpfySaEweIYvpkZZFQh14Q7oXtq+JdaLaoYpkZleR0T2F1YBoO8Y8e+lKX++TF9+1KDuUHB9K9ffXtdFDyoqX0Ms28PcjapUJYibUcNvRTOGIQa7VImb2r3+WJ0Pn/f703K3LtmOE3LAI2x85cJIvMa5DytKwOia+wTrsVPNACcVNPhIe2yxQN1H8ZF7HFFNtgLHoWTAc+vEaMC4NVUNwYavYfe+rstdQSMBzIvq3Xtl+oa29vKNDq+k9E4xbxm+depX9AKNwR1si2zdkl8yTUvVy1KVwvkWVZBC7DwIQ4715kJ/0s24rcUsyBSIiCsPqKnm5LPtojr2/X1rw8s2ZdDLGapwmV/D/NnWzsLtAxzo3bRerQuP8VUwJyDZarL5jGo8NtJJ
 hvFlAo3j
 u55+B/Xz8ifeYAuK9ZFKivudxek0dVv8nGL3R3hy2IVKS2sGkixxMkmeg5I2YaCGp6t1uGfIu+KheH3/YbZ0aN1xAMSf6AqL5nSCR0XLjjdQiM7JAp8jKbpgCKnNcaGgo0iY4x07U3iC3U+YvWGebs0bbzoKRA19mDUx26JYMuJ447KG2Zq2VvMYsJwOd1tSCwgPkND5P4SwyWZrfwuWo1gUTu4hudi7m4S8C1QJMUmw/Z2H9FhSC3liymQYCF0PiQ8DhbEKZVItRZiFwpdBq1Jri5DpjKmdIxES8HkYoTU2bP7qGnELNEohjIi/pFjn0ClmrxOcVU5S5Zig6SCqvhulMmPCTElqScuLEzo6kG8le6tj/1b1t/nCNyOuc5d4To1xAM8y8rXEUpZTyKx5tlmIYhxx7LPg13RFWqsMBQqqPizCp4YnkBNKoWWqdeFQgOwFEXfh3ChtIzVGl8ehkUTq1umgBKQU4O+eB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 29-08-25 14:55:50, zhongjinji wrote:
> When a process is OOM killed without reaper delay, the oom reaper and the
> exit_mmap() thread likely run simultaneously. They traverse the vma's maple
> tree along the same path and may easily unmap the same vma, causing them to
> compete for the pte spinlock.
> 
> When a process exits, exit_mmap() traverses the vma's maple tree from low
> to high addresses. To reduce the chance of unmapping the same vma
> simultaneously, the OOM reaper should traverse the vma's tree from high to
> low address.
> 
> Reported-by: tianxiaobin <tianxiaobin@honor.com>
> Reported-by: fengbaopeng <fengbaopeng@honor.com>
> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>

The changelog could be improved because it is a bit confusing at this
stage. I haven't payed a close attention to previous discussion (sorry)
but there are two Reported-bys without any actual problem statement
(sure contention could happen but so what? What was the observed
behavior). Also the first paragraph states that "without reaper delay"
there is a problem but the only situation we do not have a dealay is
when the task is frozen and there is no racing there.

As already said in the previous response I think this makes conceptual
sense especially for oom victims with large address spaces which take
more that the OOM_REAPER_DELAY to die. Maybe you want to use that as a
justiciation. My wording would be
"
Although the oom_reaper is delayed and it gives the oom victim chance to
clean up its address space this might take a while especially for
processes with a large address space footprint. In those cases
oom_reaper might start racing with the dying task and compete for shared
resources - e.g. page table lock contention has been observed.

Reduce those races by reaping the oom victim from the other end of the
address space.
"

Anyway, with a changelog clarified.
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/oom_kill.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index a5e9074896a1..01665a666bf1 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -516,7 +516,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  {
>  	struct vm_area_struct *vma;
>  	bool ret = true;
> -	VMA_ITERATOR(vmi, mm, 0);
> +	MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);
>  
>  	/*
>  	 * Tell all users of get_user/copy_from_user etc... that the content
> @@ -526,7 +526,12 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  	 */
>  	set_bit(MMF_UNSTABLE, &mm->flags);
>  
> -	for_each_vma(vmi, vma) {
> +	/*
> +	 * When two tasks unmap the same vma at the same time, they may contend
> +	 * for the pte spinlock. To reduce the probability of unmapping the same vma
> +	 * as exit_mmap, the OOM reaper traverses the vma maple tree in reverse order.
> +	 */
> +	mas_for_each_rev(&mas, vma, 0) {
>  		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
>  			continue;
>  
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs

