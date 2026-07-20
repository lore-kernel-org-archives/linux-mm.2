Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27228C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FBB16B00B3; Mon, 20 Jul 2026 10:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA686B00B5; Mon, 20 Jul 2026 10:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A506B00C8; Mon, 20 Jul 2026 10:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D22A76B00B3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:31:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67A7F1401C1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:31:35 +0000 (UTC)
X-FDA: 85009393350.19.DDDEB96
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9EBAE14000E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:31:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JYREMw/0";
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRblZRKVWZtwBROzeWSAhOYR72G85c1lXXCcvEtUJeU=;
	b=PKj8nhadCwk/Vzh5lgYsFEHLDUOZn39MPbWqBGd2ac/ArMNiApgm5x58bOFNjo6YKz4NmE
	JIz4ECAhh0ZnlLTrVPXOjMPjSCrptVKc2ogFZfneiJLOqrg1JQa0FZUBWH1mW2DrsdbQUV
	vZ1rKDzZHFD36ayvP3QpdipTMouOZFg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557893;
	b=bBq6FcY9oxp+ic2J7EkJNDhl0TwGE3G7dQSRH4SN8fO8tGERtzrrNoj+CKw37c6ZGIyc7s
	vj4dhDlOHKmMrL0eii5vXtmSHnpENJtFO0AdXY8c22qiUIKcMt7vc5PJSvlRxhIfLfsAaw
	jnpXHTKG6JYwH2dyEzwDx1iCXyfNb0Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JYREMw/0";
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-44cf70de986so3444801fac.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784557893; x=1785162693; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FRblZRKVWZtwBROzeWSAhOYR72G85c1lXXCcvEtUJeU=;
        b=JYREMw/05N/hXXiFJL4DU7K7G6ERvsRFFYRf5L9w1koqsfH9c0+8GlHxitnKlpWtYD
         L/qScIfg40olPSX5VrWMLQiKcnEFckQW/IzoTUTNaZpt+J//cVU31XboZRIFaxjSNgtG
         e2IC6v9dQdsYBIBaT624uSjR2AkKGwdWw/Yzfz55EyLfuzadAied1S4AGdG41hKO+SxD
         jW1TxUUYKg7rKmpO70WqLx99g6qMI8d3iHVeIyVH0+sRn3a7R3JoT69DLjyd9tejCO/I
         /VRcdvEAQWgcpIjPHALPmHn3TH1M7BQ6t2eZuntvgJqHS/o3MYXDO2V2w5noKavje7yR
         39kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784557893; x=1785162693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FRblZRKVWZtwBROzeWSAhOYR72G85c1lXXCcvEtUJeU=;
        b=Feu5FU5Wh6amrFAhI3IW0ko66JXmrz+gCCEw1lKhwWVS2tnbAE/tsTx29gJJmpTy5b
         Apj18QnJh7740cIYsU1/9jZPSSxrehANV5huB+TJkClTUxda4Iy6U6MEyB/MB//netMK
         bBkaMrq22WcDthjP6PeEb7UzxAfSc3MlebYBX/MmfuuvCd/oCKrCD/sCkM2PnFEw0vjk
         DdPFtiSrrQhlynsLzLYCUt/dz6ETcYp6o9Bf6ILNkr7MTHaXhvug+z1zNANVICLDCm1E
         MZ3dRSgSVhVrVFG0n0JZF9O5iH/HZyucGQs3qFNKpBIoUuwk02WKOq6jRcXHb19urdag
         EXqw==
X-Forwarded-Encrypted: i=1; AHgh+Rrnj+hAYhycrSuK9SdsEwVT2TyfMAjjKoIUHgom+O5Eh0dKIWcBKVLEfo+WMRG/5TmoYygfR+Vtvw==@kvack.org
X-Gm-Message-State: AOJu0Yz5+3kcJL9rVYL8YZ2sgbSp/26andpEzP4jpSJVdGK0sk6GqjMQ
	hU1NiRzbwjorVHyWpAs4UOKyubHsneTWeZ1WLISRAtbZYLpxDsbmNVdR
X-Gm-Gg: AR+sD11t0gMZcub8sCF9TBJ0K9WF2+U314jihwiPecnR59FgZo+obLUeWYIcI8X8bwh
	Q0+Mjk6yEJFo54CE/thjnOj8K2kRnnS+8tUI6r+cKoB5k+poyyNXHtyQ1E4NAQzQlKSA/WTrSEJ
	rikcbxO16fghbX7CTM6rkdXqHPkDb23TKDxCRR1iu+Ww8v34/vn+3AS4WCmJF6zGVKnxqV/zZ2v
	+VJuJf54zCFqweOMLrVE54Eab/yM65lSWI91boAbzNOyR+oaRfADGZ5jABqzW7VkD9csP/Y3ueu
	H+8KSjgsUjsPuhFs9ZxwXBPzTzkkDvPmzCbQVrqsXqk4LR+/WSQ+jEF2emte2yQ6M0E1jfXKc/G
	OmTfFXsBILp0s7xPCXcdYmBdcujgEJ/8FVvM8xon4hmOvaO5EOJdOiwPDX2GrojYoQ4zLJ3qR/n
	kUsDcfkLaryhz9WVQWINbcYdjw1UwgfLR/
X-Received: by 2002:a05:6870:248b:b0:447:7db4:d287 with SMTP id 586e51a60fabf-4569014b90fmr7202228fac.16.1784557892458;
        Mon, 20 Jul 2026 07:31:32 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5e::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4568e6a91eesm8991109fac.13.2026.07.20.07.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 07:31:31 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Barry <abarry@cray.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlb: fix subpool release race
Date: Mon, 20 Jul 2026 07:31:29 -0700
Message-ID: <20260720143130.516711-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720085024.1392261-1-chenyichong@uniontech.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9EBAE14000E
X-Stat-Signature: k5d8xbmj58ai4h6aa8yonq64i14czhay
X-HE-Tag: 1784557893-879555
X-HE-Meta: U2FsdGVkX1/eyhaGWXMk5gVF1BmGh45bRjCZphH4jlpHuYyBFdG+W/TE1a5lSveB65LvHEG/uCU+qHpQsEuSmMhuntARMOwb9Xmf2AcRHWqRUWIgx6+oRZGEtDQXG/qwfctQSk5+Viayvof4EN+cxHUc+6plwCE5YRo0R3VtrscPzS8WklQ10fGKPeNjLzRSKwvHDqbxVOg7lAGFEnlx4Lox0ufBMA6Csn8UNa0ECWR+lbUTFz5gyCMaBzxCAS2DuHhmC+oBXkQ9lfyYP12eYDQWkF+saO4pDFVttb+0UW3EpgLss0JcYcYw8Fe36QBe8e7SZzz6F7hqFnbpD+sqKanWN5A3upBreH2sEwySHGZ02szfmYALsPZEku/TTNGQsUhM1aEcN8y7+pQeaeQL0SOzN7kFAldcH3qA3jq2M7aGVkhL4tgpbdWcLGAj4v08N9zLIsGHlX/KmKcK77kYg18bl/xmlc3FhKEnFZN6WdnTuY5cuAO69xc3wKPll+pLFLsk9KC7Zb3QoR4YjYmDNHT6Wwcwox85tCCV+VIksflHYxzwkGZUC2SLp/W+5CHaYN4LOysNfQ+O3NQ08JatsCsP9bgeb5EfEW0fvYeGyCgzDuqTeR5k7oN1BhAZFaQd7G2iSZMgBl4ObFhcKQoumKo8pyPTwWJ8go7qleGAQIPUZ4XV/B7QTrnJNBf50BO+QcdZbAScUCogbR13dAOElU4L719iuQXKQs8/592D00xFpCCZ0bQVpocmmWBwh2Jx8tlZlHm74BmuvqE7YTOMOSUyWm4bySqqTj545N6osQ2KnruNbfv9CRxp7sjzFdkmDf+ducMX2yFoXalcmj73/F0aLBmaPxlvyrLvNq2dLlwTL/qh668l3wVjHYxDbL3Mi7G2LO2g+OfF3An40OLxEF03Cd3KMqvC5TIA4I/4AmxV2EsfjRUW1KDPPHyyrLVuV+mZClZOJ1ZuzJ9AETz
 z0glKY6T
 oWEZ0eg6RjALgpML586qkwdL/ZyNYMSFQThjjhM5XsjSBhJeDMHp2LzIDn01o8YB4MMh8VCmqrI4YRiuQuUGEgFZQXiZWBAaH81CulcQgsOBaXB0kRx7usSyEGi2XHiAGp9fh+i2wA9sU0UIVLgNArm4JA/fdwu8KtAQqTs+/tGclYGwCcpOEuXHMj0ARY85EQIG701VsAX31uwF2cTT4fzqAot48TZSOAFK99Vw+twTt8hjT+Xh88zdupvdP68cEK32ymsZH7Qoqm04utspcs6YUewJfznbA+lNM3oJlkAc89YaTtptqH5BFFkz09aDPl1ZKcMc6Kc3oeDVBiArcs2ulD6ViOPiaT/rgBU6Rg39so+Z/i2M1AER0uvePYN8qTnLaK6GnSXwvQU8isrTwN9J4lFEKVZC3IwHTKULkmKQdM/poKXxvKZ9eA/WVwmMcf5THdXvpTvUqwDWk9eSqrWsPcf7J63YRxEP39EtqfkqnbtLtncWaD4cQIQg1wA33yVcARo5YhhwMVWYmFlCsbNrYh5r/80ODzelUlt9gPW2wBT15sD5YJP7f0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Yichong, thank you for the patch!

> unlock_or_release_subpool() drops spool->lock before checking whether the
> subpool can be freed.  However, subpool_is_free() reads fields that are
> updated under spool->lock, including count, used_hpages and rsv_hpages.
> 
> Another thread can update those fields before the first thread evaluates
> subpool_is_free(), allowing both threads to observe the final freeable
> state and release the subpool.

I don't think that the race you are mentioning can be hit in practice (i.e.
there is no user-visible change for this) since two threads cannot actually
observe the freeable state at the same time.

subpool_is_free() does an early exit on spool->count so it will never reach
the inside if block and have two threads try to decrement the
spool->hstate and free the spool twice. I'm wondering if we need the Fixes
tag in this case.

I do think that this is not obvious though, so having the subpool_is_free
check inside the locked section makes sense to me too.

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Have a great day!
Joshua

> Make the free decision while still holding spool->lock.  Keep the actual
> hugetlb_acct_memory() and kfree() calls after dropping the lock.

> Fixes: 90481622d757 ("hugepages: fix use after free bug in "quota" handling")
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> ---
>  mm/hugetlb.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e319c6a00555..46ab702c0fc0 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -140,12 +140,14 @@ static inline bool subpool_is_free(struct hugepage_subpool *spool)
>  static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
>  						unsigned long irq_flags)
>  {
> -	spin_unlock_irqrestore(&spool->lock, irq_flags);
> +	bool free_subpool = subpool_is_free(spool);
>  
>  	/* If no pages are used, and no other handles to the subpool
>  	 * remain, give up any reservations based on minimum size and
>  	 * free the subpool */
> -	if (subpool_is_free(spool)) {
> +	spin_unlock_irqrestore(&spool->lock, irq_flags);
> +
> +	if (free_subpool) {
>  		if (spool->min_hpages != -1)
>  			hugetlb_acct_memory(spool->hstate,
>  						-spool->min_hpages);
> -- 
> 2.51.0

