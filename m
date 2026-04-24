Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 873A6FB44C4
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6A96B0005; Fri, 24 Apr 2026 03:51:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAFE46B008A; Fri, 24 Apr 2026 03:51:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D716B008C; Fri, 24 Apr 2026 03:51:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC4B16B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:51:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E6291607BB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:51:27 +0000 (UTC)
X-FDA: 84692679414.11.C2505CB
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id 80C9620004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:51:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=F+ibmJo+;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777017085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/JtEzMAf3HHrd01fVfPU0c1qsQLQRrKfL4Fb7KVaB4=;
	b=0qPNn2//Or08akRudRcyfoVkwgLaeM56mBtZlC18LV06e8ogr2PMBYZSks0xBnGcUl86Ku
	63U88dwHx4Gsno+aodu566RFhKT9D0E2J0k1JV4oEcNTLmjmCjzeO/Nqz4P/9k+JTiHLtF
	5pEwtbuxte9mjTRqemgA4NTKkSkDCOs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=F+ibmJo+;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777017085; a=rsa-sha256;
	cv=none;
	b=t6AO6nvA4RgRyp3fEfqJi929oEx531RdDrRPlx5nY0+7uf4aLVlLBAjCR1KSo8h63ELpFV
	1A2dxELn+ezqLgvm7XjBRRF9EFyzzCQ1N2qFSrm4Hp+ZXkmXql3UbciW80k7vmgwtHWETr
	S0B0rCIk2u6TObQnCNVAnkeazVQxie0=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48a563e4ef7so40221245e9.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777017084; x=1777621884; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2/JtEzMAf3HHrd01fVfPU0c1qsQLQRrKfL4Fb7KVaB4=;
        b=F+ibmJo+Z2dzNRfx3eFls9M9CAZbNfqaDLfulCdWYk3Gue8hu0RSubTRi4t1z9K7be
         q9mCAl54qzPQh2HmsdjnLhsTWZEr9FyCOnUfb8ZKha+plpnDX7YdxHBePUwn6qkwqNtC
         NIaXqEenEfHjH66rSqA4+Kou3R/W95DrIEgXpQ+Mr13Z2y+sUdzYoUJzVUUVzUpcL0x4
         wlEY1BznCEbfCHW4V19wZhMHdbKtEU+r27KLE21rrCHoniJY+oT87a860CTsz3GR1dXy
         GntWyGe+51SFuaa1gyt50TjqWfl6tLRiqC+EYSuy/qb00Ve7L9gBI6FODeXvKimebCEr
         G6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777017084; x=1777621884;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2/JtEzMAf3HHrd01fVfPU0c1qsQLQRrKfL4Fb7KVaB4=;
        b=QSjUcO9Udz4lcq6e68vlO06AMTgBp6HOrBGOzMT9VMdBeSUPZHdVzNrj/Bh1dpm2sE
         9dy9J/dARZkNw7ObPOsCgvU+E9qM2dc1SUzxIUpsBtr1IpNcEsqy9yko7wWmCpkf2Uhq
         0rlnkHGkprXE16RxuhTMNUSossVe3IOULWT7+M8dpHOFEGRaIb9JNqiwlEc9olMgSGLq
         UshGb2gL73nsLo/kmfTS2MSoUx6jci1F0ED+ISL0BiyfZN52sEHqRlRZGqdAQ/7vFH89
         VHtjC7hoTbjMYpg7hmB1QuiYI2Dk3fVU1jKJTpKnKTBzW1deR4tr7VABg3sCyyvO7pPv
         drdA==
X-Forwarded-Encrypted: i=1; AFNElJ+4nx4fD+hHE5s4dtz/tS9wnmftMju9mbRzJe+s/SSwRAtYJZE313MfCzrRLy2cOp5zAPOCGQSTuw==@kvack.org
X-Gm-Message-State: AOJu0Yzykri/OTe5M+pTJBFXdbCGppTGZ+0N9ZU/ojhP6veC/xIBjfSa
	ZSqYbptNWsg6qLPqrP5KBDU+71lJerWYOiAlg3p6OJ8X5DoRF7AB2R/3UtjZnH3KUTQ=
X-Gm-Gg: AeBDiesUfCNNxiKVvUXOhFBWNFUDbn7RpIgBz0juWtL+AKgmGIDHk++2FgJY1xc9rqy
	X/CHyMJxWUoT06QsKFkrVtETsIPxUSRaVejgePQ2YA6xx+5ZDo3rp86TnUS3fQ/e4itOQLwbeYb
	QtCsn7WcCU8JeIEItQP6S8C0fPCGeRhi4X69vOmhZrU6wUi4X2XCgcceCxgmfwA75ovq74KCCGb
	ega0+dGBylXchgqsQE7bXy66SrAVHxL0c36KS3+eMPkcv2fpfArdskpqhV6PR3dr+9YgvL1/7kI
	5kWAfN3x5qh3vF1CR8MKJP+rrYuZ4H5Rp1S1d96+aL3Oqwx0tqWy8Qxoiqn4cI13PeRQE9hOX0O
	FyQt0pn2WN7llqRIE5BZRTcC+L4HiZhy3IILAwElda8j1C9kvaC4tlMxsOx0LXv5bVVHm8hNbt5
	3tcMVIf8HEWPN5kefxsh9c8XYYBCaF1SWPanJCW91/VPxSQa0=
X-Received: by 2002:a05:600d:8496:10b0:489:a4:e555 with SMTP id 5b1f17b1804b1-48900a4e79fmr243967435e9.21.1777017083931;
        Fri, 24 Apr 2026 00:51:23 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a5aa3ae83sm334399355e9.12.2026.04.24.00.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 00:51:23 -0700 (PDT)
Date: Fri, 24 Apr 2026 09:51:22 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com, Minchan Kim <minchan@google.com>
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <aesg-sj6_VmXyqxb@tiehlicka>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-3-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421230239.172582-3-minchan@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 80C9620004
X-Stat-Signature: k8xtwmccushn711btmmchmfez7ainhc4
X-HE-Tag: 1777017085-449207
X-HE-Meta: U2FsdGVkX18S0pz4QzxShHrrSGYG8Grju0HijnPSrVMFrMVZo5h1fKGYYgOMZtbYL5If/hHR2lVupoaprxhrnR6a+m2P1uT3S0LE3ZR/DsJnTX0XzofxNW44nrwxG50KYjMHvQeBC5iXUWJE5YyBeQEeJBo7D0/9xOXAHLERnZmhwd8dZTdNPq5cyDbF5DpM8IXP2FWr8fa7VeSi6/8gjz5/VcF8J0V6yAtoSIeXFvEunHVUwMBYkOvlRDvMIrdMYZ6X5pubNSFoRGGP7NEwCGmTOlHaNDb2YvIV7qfPK0wbPtrpRYRyg7pkZOLal3xmB5atDKvev13DfMuRR4QCwkmMOr3c09o6uZOsbz1eH0q3NQjPpsGwho7A360iEpN+v2Vd0SuEBd3O5nYYQYWoZdhLzsViJZcv01/dIbmLKIdJlpnL3t9fA+ZZQ42rBOlNewVEumxhF+DpdLOGxxqbMr8lFHvmcIII2PMc0NtVNbWTHfEVyYQgavxOWqrSs9j2lccg19dWgacpPyv1Vy5mEiuDtcUlfWrPZRTaHYI7YJ0eVJ8PQdCXv16intql/phlZx6GbIc5jPO/WO0Qn1sxf3b0P85OVQTf1lK8IRvuqQhyihJRP8OFRZP5S4irQGdaJcJI2brVFOqscYKo9F5Jbn8Iuy1/L8NkARHvq5JFFFn/DwFRVujMvvDKA1OF3FNlhy3vFRYwuSsnFdyEQ+6XgSkLaLEB3MFyP3aiCn3XSJI4Wd9YG7DzpGXa7iGlACXtmmOIflGiYaUpPHu0iL1Gw2457Z3BVvOC4mHOhm91L7Kd0HgkYZFa6AFjSon6zmPuTBAkX4MHeA7KYp+bbSTN0WH/Yi+oNcMjE5aqQzY7uExiBH7iQeYSS8YxzZVrUP5zMF67bC7otjsPP8rZw0d1zhKm4x4no0A/zoiEGCGlrsGzsBEQnSXmh4XYMHCAl2FA534nsZ/iB0LmYo+9OAb
 XT9RbIEU
 TYVdhyhgLpBDkMtJ1HdTinmwwvMDJ0NwCRn1cadKSDJMhOZaZy+uHf+gZjeF1V1Zbu+mWyBiRjmJ9bnPW7sCIiwR/uHYwZsIcN+Um2TeCjHI7heKF/twfuIqxO6/3ApKGUX8R/c/hIvBCBpL8j4Wa4Dpop0ZO78ngZytPYj35uHtA7ssf4hrLK6/LtLK5asyEufUzh3xBAbHS+srUcNolmLTEnHDdS+r2efl+yV/zrc6fpesAcYsEaVnQ2WWiDu7TOo+ApDAhYaLB4l8N3IkKiApPdaiwpG4PKSPZX7WhcKoxamGgpczXfcNmO9bu0zb6258yy/AN2EM+ArNH2tX+cTfshaQWuQWeZDiNmZ8iFmJThfpLnI4Uq/jeJUlx+knZlKlpR1mnO3dmsPWRaA5EDzpClkQOhmPABLqcZoMVEV0B7Ko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 21-04-26 16:02:38, Minchan Kim wrote:
> For the process_mrelease reclaim, skip LRU handling for exclusive
> file-backed folios since they will be freed soon so pointless
> to move around in the LRU.
> 
> This avoids costly LRU movement which accounts for a significant portion
> of the time during unmap_page_range.
> 
> -   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
>      exit_mm
>      __mmput
>      exit_mmap
>      unmap_vmas
>    - unmap_page_range
>       - 55.75% folio_mark_accessed
>          + 48.79% __folio_batch_add_and_move
>            4.23% workingset_activation
>       + 12.94% folio_remove_rmap_ptes
>       + 9.86% page_table_check_clear
>       + 3.34% tlb_flush_mmu
>         1.06% __page_table_check_pte_clear
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>

As pointed out in the previous version of the patch. I really dislike
this to be mrelease or OOM specific. Behavior. You do not explain why
this needs to be this way, except for the performance reasons. My main
question is still unanswered (and NAK before this is sorted out). Why
this cannot be applied in general for _any_ exiting task. As you argue
the memory will just likely go away so why to bother?

> ---
>  mm/memory.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 2f815a34d924..fcb57630bb8d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1640,6 +1640,8 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
>  	bool delay_rmap = false;
>  
>  	if (!folio_test_anon(folio)) {
> +		bool skip_mark_accessed;
> +
>  		ptent = get_and_clear_full_ptes(mm, addr, pte, nr, tlb->fullmm);
>  		if (pte_dirty(ptent)) {
>  			folio_mark_dirty(folio);
> @@ -1648,7 +1650,16 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
>  				*force_flush = true;
>  			}
>  		}
> -		if (pte_young(ptent) && likely(vma_has_recency(vma)))
> +
> +		/*
> +		 * For the process_mrelease reclaim, skip LRU handling for exclusive
> +		 * file-backed folios since they will be freed soon so pointless
> +		 * to move around in the LRU.
> +		 */
> +		skip_mark_accessed = mm_flags_test(MMF_UNSTABLE, mm) &&
> +				     !folio_maybe_mapped_shared(folio);
> +		if (likely(!skip_mark_accessed) && pte_young(ptent) &&
> +		    likely(vma_has_recency(vma)))
>  			folio_mark_accessed(folio);
>  		rss[mm_counter(folio)] -= nr;
>  	} else {
> -- 
> 2.54.0.rc1.555.g9c883467ad-goog
> 

-- 
Michal Hocko
SUSE Labs

