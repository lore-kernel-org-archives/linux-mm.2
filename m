Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F22B4CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 21:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543AD6B0005; Fri, 15 May 2026 17:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CCAB6B008A; Fri, 15 May 2026 17:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC416B008C; Fri, 15 May 2026 17:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 261D36B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 17:44:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 897261201DD
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:44:23 +0000 (UTC)
X-FDA: 84770983206.03.947FE09
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id B380E100005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:44:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eaGxJvaA;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778881461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kI2tbQ3gv/rOPLpkzmuHjc3hm2p0ykSJGbw2DjymBGE=;
	b=ah5cF23Y3DJ7n0toWyN/QumtQNfD4feCvSnjrXeTATJIEGe8YOSRpYgMGH+eAlS+7YF4H3
	zwkUe0MMhDngGii9tGAT0OcC3fAsg/A5bwBUOqIOTkJKCEx3x12vBcEXPkiYt7QolAyjFw
	e/9XkvjyhTt1qSeSxsz4Vd9u704frkY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778881461; a=rsa-sha256;
	cv=none;
	b=EzvuAkOmDXZ1IrpYE+kojSirdxktrFc7mskBy2h4aPzck0efCL3M5Qg5pVjbid4ZIowuVB
	vUhn18Y42P+KYDqqaauifGFRKWX5HLdoWJdLVW5keJVDSoaYqsOwNum0jx7X48phLGljd4
	Mh7YLKdzNwDjZkTtnSBi8G7ovjnJn6E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eaGxJvaA;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-651c5d525f6so624162d50.3
        for <linux-mm@kvack.org>; Fri, 15 May 2026 14:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778881461; x=1779486261; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kI2tbQ3gv/rOPLpkzmuHjc3hm2p0ykSJGbw2DjymBGE=;
        b=eaGxJvaA6kE+CSRZEOxWkmwzNPYDbWU5dtehhZ7RpJHi+ZB6HeJONliM+xORAFr4Ub
         OdarVlizTl3/6pDqovRde511GXsXY/Oo4fFyRAZjQ+rb+uFHT5GbtiePRRJeOHaiiAjs
         GRREz0VnUkTglC6DVh12x0situHsbeoT4f7MQr/h0rbk0jr4d4j9mbMEZClOj7uNrunn
         cu4K+OwmzitARF6Q8xXtRjE76Pi7ZANJrkwgH5ff7fAw6A/mGXI6amqHOad0X0MzProS
         MNfchY0RUxT4R8C7kmvPcYASFqwS5gyJ+q54tdMaH4YlY+Z5z/sUUv7wzuM0VZeiF7T7
         rmwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778881461; x=1779486261;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kI2tbQ3gv/rOPLpkzmuHjc3hm2p0ykSJGbw2DjymBGE=;
        b=etTt8P58foQ9QK7wRSsG12TF04TCfpEJ6im/SUkJFsZQh4rfyuCwO9W0+NAwuTQ3cn
         sSWmsYLiZbwWBFPu452pqpQ1c/A9NMZdtDI/6tGrrlC+jMmdE8GkdAQ9UWc+uSP5HSXG
         rj/LrXGUp6HbJyZhM9e987AKzFBHrOdvRupoagX1SFNfO+l6TAQsaexkO902tX81WUVo
         sPCvrauDCWu0Cjcb5MAhXZVN9zYIYnwajfsLmIadis4l7+y/k5RqT756C4FT9fG63Jv5
         PShrKDrxTTh2HG3MTNFjL0rZveyIVrIuLryqj5si9MQuHEyaQOj+7XL5MWyyesC1VllC
         lh8w==
X-Forwarded-Encrypted: i=1; AFNElJ+7lUyznPY2Z7BPtgbAB355gIvc81fTM2qwSMcK1qFAMlhZNBP8o87EXJER71DQmfefrZOI6P6sDw==@kvack.org
X-Gm-Message-State: AOJu0YwQx0ToPFtvTgBCRFLZURfHJUTgW7WEbVEHdnk0CHMbXGfijQj+
	LlBTSf4oIOqb6JZQSYOA71UmGJ03RH9pHQZ253iozbeigKZj2Ul4DLWx
X-Gm-Gg: Acq92OEARp7Vs2+El8t4TA09rQBCTQ4vBWCuMPzU79eTMd8W5Mo8mFWKJjz97RoyPL9
	8ZxlOL9beHlr5X1d98tEKt9rtvnc7FjjSTEXNVddPiSr88JF2HL0YD3fnP4nFDptuxshApEpgdB
	GbZskMPs7WbTsFYCZM1t88ozdv9mwxI14p1QV2EKVBL9u1TSUTquOaUylBoDz6bLlUdF/GqgLDc
	iiLDCeqwZTSgCftHfeNhRYqqGA12s8rzG9GfKx+BiPcRTmeGLR/dJyHROIPk/Pgr/zzHPoI3Blr
	IHpawNVcIS0T7gqgcEdhOyfrXK/CiVjWJfKnEl7FCKaTfpVTgkafYjcsQjAk3itgKbvRvol77HJ
	2g9neoL7QlLyl2EvTsni9Lqp4JNBkeK8AlSvt9FlQ1XN6lKA43sSYW8OVeLoR9TzgsmNuE94wUV
	ASHz5Z1JvPdZEUYycecm9x0ewiibKEEPrREWe75oCQitCa4V8ru/M7RZNnJPQ2NKk=
X-Received: by 2002:a05:690c:c513:b0:7b3:9f53:9374 with SMTP id 00721157ae682-7c959e88e51mr72446817b3.3.1778881460615;
        Fri, 15 May 2026 14:44:20 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:c::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c92e2e978fsm22034177b3.24.2026.05.15.14.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:44:20 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: David Carlier <devnexen@gmail.com>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	joshua.hahnjy@gmail.com,
	mawupeng1@huawei.com,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: restore subpool used_hpages on alloc_hugetlb_folio error
Date: Fri, 15 May 2026 14:44:18 -0700
Message-ID: <20260515214418.3259977-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260515202902.461539-1-devnexen@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B380E100005
X-Rspam-User: 
X-Stat-Signature: ktd68thxq7aa49ax3p1x5td7pincozf9
X-HE-Tag: 1778881461-228486
X-HE-Meta: U2FsdGVkX18ijHPo7elBvsq5vnyPhK8z5Qzadzn2Hi/vE14/HqoAH0JTMHqLlFv3uivWtm2LSB0oNUDr2/DquMabXPaOZbbW1Bq+i1DcGcK+u+yB5C3/TF388gdD79g7WXwrAkENP5NsN5JkC7ffCCgQ/IlMigY0PTjN+7QxoA5/3+lPeqh9PkIOa/rnxS+OSHwFdqvw5Iwkm+Tyd3h+W51jUywpdJMBBggOAN3dYN0xgnqZormM4uw/GYxBvvVJGRPrbQ9R8p2KIVNceTMuPHOouaaLopHQ7vuhdWZvPaSpFpraROPHJI8XGTnl+JrFuTvxvWUjUL9xv/OdGCfiWXgh6Yumlhyn/MSRrpti0GGUjBCtcTlIxZlGr6LJdAoMB06ImjBlelvNMkwx2lVlfotkmFuEjOciVVVcLstzvkYrvNe4Q2w4JCG0EvqeVQyhCRCcikfGKX2jvkoIAXsCYRCUU4Nrh6oK40JDGteaNOLJ4NCvgsnMlZEwkaa2N7Ga0Dp1E/AfMzrsdeX+aTSwcxgeu11o5u38OpcQKvaLmKqBTj9ot1VEZ2mAS2CGgTnxlcDSPwaF3BuF11hRQdFwa1ba95B2jS7dgzIWxQNiDwZjsqgdKU2n/LwEfPGkVvz9ti0qe1CBovzEcGEeYHor8PYD/OnlzRVxnq/CpYNNEEwujORgz9ujQ69CYRh4ovxlkDNMYnXa6nCdW9prMRbDq07pF6dwEVNhVxHWcaeIZkBmOLjCjTzxzPHp3e7pTPzU84Li2wpyXPEMp54CY71Llzp9uh5kYaB4bEDdmqdguv2ArAu41lsVxTxEAOMqE70I0beGwoV7zbqQmCE9FCput2BLkYdfbdHmyrKJ/GDOlEVgh2j1xe+ylOgdKcTKqUPwnRSlbia0CR0cTGy65nwVFZB9qdc8CPxePk+FfBs4A3Y0fig0/T382AcPxm/kcio5/laVkFP0JC31Lglng4T
 Xsj+x1kN
 Xq72hVXLyYdwAlGbSf0K0L7g1V7tQRIoXPhN9driysOV9eujgY0CbU+Mu07gykK6L8Hcp3ed7z0CRhfC2faVR73Ax4NUPEos3Z1RkFXRbEr3ziIQ89Vpeqldh8Ta6ArFaqfb/AKldcXFDEYBDcGlSLllTOXaFAElUc+La2CEU9Cnz/9nU2l+Z0/r/9BHbF39ClmFFs9HN0MFnDlAqj25uSAdZhhy3rig6njXfX8IwBbR5JJFcZqTPl3PtCMfhgqr4xQsXRlBZu3TH8WuguxHavaN3AZpgE0ekx9yUyKnkU1jkNNO/aAbORb3W6/hlEeHbpduqq0Qb7aajmORi1dx0GLpV0ECZt/4O2WArubXZgcIoeM6l03OZdBf5+hOKksSOhZ56ueLVXXqkAPA3xWYE07V4Hj1edVcRO5FMGaqmkyGCq7aMIBdRYYiHg2mNxf1wNKkE3Oh6mze8k/4cttq0Uc6xbZbdlsR+2kpcn9nWj+2+ux2XgH99FLNh6juK1tZge6dgQmeEuKnDegrsOhdgwNYsJwaHNhpMdkwIWRxYIiBXG68Gi7+ngGgha+QQxBdgEFRL00HQyPO7dzKy2gnhvK+dOraGTKgke00OBpgUHg6q+9DqoWiBzweDEz/U8dB9hdZxlXlWv0i5A9aXkF/R1gXpvPwQHTEJgHBe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 21:29:02 +0100 David Carlier <devnexen@gmail.com> wrote:

> Commit a833a693a490 added a !gbl_chg guard around the
> hugepage_subpool_put_pages() call in alloc_hugetlb_folio()'s
> out_subpool_put path so a failed allocation wouldn't drive
> h->resv_huge_pages negative.  But hugepage_subpool_get_pages()
> increments spool->used_hpages whenever max_hpages != -1, regardless
> of whether the request was satisfied from subpool reserves or needs
> global pages.  When gbl_chg > 0 and a later step fails (cgroup
> charge, dequeue, buddy alloc), used_hpages is never put back.
> 
> Each such failure leaks one count; eventually used_hpages reaches
> max_hpages and the subpool refuses every further allocation even
> though no pages are held.
> 
> Commit 1d3f9bb4c8af fixed the same defect in hugetlb_reserve_pages();
> apply the equivalent restore here, guarded by spool and max_hpages.

Hello David,

Thank you for the patch!

I noticed that this patch is quite similar to Zhao Li's patch [1] which
seems to address the same problem. Have you taken a look at his approach?
From what I can tell, the code change is also quite similar (except comments
and additional guards in the else if branch).

Just wanted to bring it to your attention in case you haven't seen it yet.

Have a great day!
Joshua

[1] https://lore.kernel.org/linux-mm/20260428114126.92091-2-enderaoelyther@gmail.com/


> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> Signed-off-by: David Carlier <devnexen@gmail.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Wupeng Ma <mawupeng1@huawei.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: <stable@vger.kernel.org>
> ---
>  mm/hugetlb.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cfb7cb2e9806..9614330889de 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3010,9 +3010,22 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  	 * put page to subpool iff the quota of subpool's rsv_hpages is used
>  	 * during hugepage_subpool_get_pages.
>  	 */
> -	if (map_chg && !gbl_chg) {
> -		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
> -		hugetlb_acct_memory(h, -gbl_reserve);
> +	if (map_chg) {
> +		/*
> +		 * Put used_hpages back for the global portion of the request that
> +		 * was never actually consumed; restore the subpool-reservation
> +		 * portion via hugepage_subpool_put_pages() so rsv_hpages is rebuilt.
> +		 */
> +		if (!gbl_chg) {
> +			gbl_reserve = hugepage_subpool_put_pages(spool, 1);
> +			hugetlb_acct_memory(h, -gbl_reserve);
> +		} else if (spool && spool->max_hpages != -1) {
> +			unsigned long flags;
> +
> +			spin_lock_irqsave(&spool->lock, flags);
> +			spool->used_hpages -= 1;
> +			unlock_or_release_subpool(spool, flags);
> +		}
>  	}
>  
>  
> -- 
> 2.53.0

