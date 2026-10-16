Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0C80CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 18:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94336B0088; Fri, 16 Oct 2026 14:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6ECB6B008A; Fri, 16 Oct 2026 14:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5A026B0095; Fri, 16 Oct 2026 14:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7EB6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:39:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01D8F120575
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:39:37 +0000 (UTC)
X-FDA: 85329352836.05.155D5F0
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3D61318000C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:39:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dktfUnJ/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792175976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALkQQ5/x3zBWgVdEQUNbbeYhHmt5oOIu1VaCcylLTPI=;
	b=KIyyRFK975wBhtLDK1ugaLT4PHkQsQfizCcd8zM0ca/xIO4O29uqvQ7+mVHTJvsd6J2/gf
	LEdaFKPv6GGeeH8PHzTlIwDCfN/24niHSLyHBYeCmPqHWg1470lzGHWpEXOqT6Ao/zlcJ9
	klgLusniHd/r++BFAOrTtyqoi4IiImg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dktfUnJ/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792175976;
	b=eR4sDrFKaQyhCxeDs89AavtYdk4UR21Q0uNiR/el6PwUhAyRGoUrbLMffh7JDR7WU5uyc5
	zRVht7hjiT8jQoOk81yzAF751zILaOm96DPRmbupo41eDjsFwIA+VIR8or4hRmgIZVNE92
	9hoF7guCEmOc/aj6s1TEQv8iOM1+0uE=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e8b20a899fso913915ad.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792175975; x=1792780775; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ALkQQ5/x3zBWgVdEQUNbbeYhHmt5oOIu1VaCcylLTPI=;
        b=dktfUnJ/tcVSKL/t71BDfttQ5qqq3/VW4Y/TQw9PZz5KzSkNM5FM76+L+gDJ2b5rtu
         EWqKnWQc+VLB5BKUSyx5Xb0S2uAPaVXuW58ipUqr3pvskq9TQfX+nVS0WTv5A9Is+46G
         WzDj1nRK1G940VPYMctYFnP9SxdYjIrAVSqbkVJvMZzG93olji7UubyYAkBxGvs1G7iU
         ID1K3oVaadOQ73KlSZNYL8RQPQyZaHyAZ/PLJU6oHXYyD6xn4Lb0RfQMznR7UHJFE7VS
         QH4tnZj+r3nyqhrbfu9Q+6wF8b+GWIe9jdpXFAgg2UE/dKrNrM0bCKYjxz7T2epNCgMu
         cyBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792175975; x=1792780775;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ALkQQ5/x3zBWgVdEQUNbbeYhHmt5oOIu1VaCcylLTPI=;
        b=TUoEZavapL/3kPAP8+e1xqULdBW5pIbRdG1Cs9wdAtQEep8Q3VoJNUdd8GKj2uqN3f
         2xNRmaNrV1kDXTO2YedRVeQc25NckcoDgPCvK9VvC0IUrZ1obT3cty0Ptxsz4C29pu50
         9xfXKEvdz3z8P+7nquZ6DVKibdLO6Yu5wEiRyYYi0SeHRUKYFBPGhsyJbw8bykdZAA00
         oRkX7yZLzp2/m3ycmpprCqAiCjmtt0Q/d9vUoRsIH8b26+abRudjsjFDpG4BGEbgiiRx
         SgdiKKHW8dZE+Hcm0ocEPIsQ37NbsjBbNJjiBcCFYlpz6S4ssCD0DR65z8RofEYQftmw
         0jYw==
X-Gm-Message-State: AFq9FYKeWKCDDFtg9M5zl32S2T08wzT2ep2S9Be6hSr7skh+nAN74EEx
	anaXib2VTAdlDjY9tdDNRe6KRPIO8gtW+Avqi/4P/4BoNO/bSSOJCzRi
X-Gm-Gg: AYBFou2Uc56zCRy9fCfbmfIY3AVNP+sRjhYkhOzhKJUfFcXUVOLBuMcWJaSRbYMC4cV
	/qgt2k19e0hRa45qBbkys4uMniFPySDbzB7XhOPqAqTgjTCTEnq7U+Um/MXRgItGD5scXG330Zn
	1YzYa1CTSyigj3v209ryZ4YU1IKsxckWLgCWITZMHPRft48puyNuyQtcn34wyxLwi2SwPXZPhvd
	zYygfKyDcsrtyIkodvTCCdpZi8VTmgVfptsPCpEckLadaTcR50AgUedLuxaC378EblOFWWpsvus
	EpwWSe5hAI6XwjLnVQuQNkiuEZ8KW7RoBhIKwIlp0E3gXWTKWlesye8YGVIDscimoy1OchZ+0AU
	YyAJSzCoN9rygK137NQ9Pgl5dFf2ccS8KDqnVSXlmdBL5GAO7XwCT1xsjEG4KAIKvO3/uA8KK7h
	+LR9IUo0hMsCbB5GeI973AM4rmcH+e084qhngiawHJ5ShmEz+YFVe35BycXFy3SEBlN1gTjBtUz
	8uhrsirWw2sKSQn5NBeeMmd0tHSsfmOuB/tHvhK
X-Received: by 2002:a17:902:ce83:b0:2dd:c100:b2c8 with SMTP id d9443c01a7336-2e9a6d3e4f7mr7793835ad.51.1792175974877;
        Fri, 16 Oct 2026 11:39:34 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e305f1dsm15091075ad.0.2026.10.16.11.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 11:39:34 -0700 (PDT)
Date: Sat, 17 Oct 2026 02:39:26 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, baohua@kernel.org, 
	kasong@tencent.com, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, hannes@cmpxchg.org
Subject: Re: [PATCH v2 2/4] mm/mglru: add PUD-level Bloom filter state and
 generic helpers
Message-ID: <atJuDwflq95pU14L@KASONG-MC4>
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
 <20260901063755.1519710-3-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901063755.1519710-3-hebaoquan@kylinos.cn>
X-Rspamd-Queue-Id: 3D61318000C
X-Stat-Signature: 6nuskku4s68naxdca8h679j43m5n3dif
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792175976-973475
X-HE-Meta: U2FsdGVkX1/4azxbDr1eZ5Oy0sOJwPpWnFhlCbm3A6YBDgPThSIvcQC+Y+ZdiOfuvpq0eMOTIvMYXWlkzoFzop0X3m4jBwk8RVrEQaoBg2HLuyWfx/xYyn4RQdGtPBqc78hG7s8YmWTGGSzzdDbD7it8SWEM6TimmWUd8QPHcmI8layHfELu3ZdRKf2wT/IktY5tnU+q+kLCI6Dtvft5bOhKdzHFX8eF31AL/iih8m3D/TdBnF2ddQT/ItUw7Ab8Br8WDjBy/ArxaPaYDx8Uycc8Qnl+Ph237BRYhjyLrkfDmu0Rq6O1bLWyStNojRY806TL5S1QrwglyNjMc4I3dqcJILRdstgohJm6Gg4jkgJIUMc8pWdxlMElc9I17X+HVUcGNiPNrRclpBZegfQugKSW23sHV3qTzRoRENE9+ErzqO61Y8+AJAS0OjTo36bULCGvNvcwdz4qJATq+0WAjqLo615dpC/jnWTCV+5ivEqfChoXzAb9I6e7SKYvlnd9MtpDo08Gu83r5YlKpzcBLzdxmJ2QNsSbDYRGFHgjBO7KYAtP2qNwXiZUrG6qEb4lg/wmVArSauNLDjCZWmAtFPaX35wKLBZCN+6qR89jxdlWefSR9KI6fwsvwhM0NFmvUwWz9Xdcibk/nuhX4SgPt42MfH8VnNuD3+gz0zy/EWzAwIUOyQzsFU2D6hHUDeNPvhOHB+Sw9qAHJyqa77fRASRY2GEQeEAwo4Uu0dMsYFTNHBaVrcn1fD5uGibXh+uGFf5Ok/SatWaexcvj3BOX9zw4yBMEMEFJs6nQbVzx8w5kZB9GliEptCJ+Q3+BC+1STPgSwpOQ+x3akRJ5FFsGp7HULcGE4vuFDOIzEuLb2092TUc4vJYphbz3QxW+CIRcCNMeJGb2H8vHusflRkI6XKT9E+feyFsWo0p538iXurOtLtj/RIZQnYONNJeRzMgckWuLZMuBZEmdCk0HSNS
 kCt/ps54
 7N3Bg5reN2EMHRXwDcIZOoUj8KucEHv+BCHer2G7ty0ADvEP/iVLjRSBeYazRveQxnckzcgcfLxX5j5RqMecFDxXRGX9s9YMQTyhwWUwTSZrr5f0mwsJ80oJI7qCgLuQcNMDxh+Om1FyL+MOVsmgrJst7cm1fSrWvp2jvW5fUARdwj9xPAWnwpLfHcY7l/nN5XpPI27gvr8pE8CC+jD3LVpBuluEE3Riui8C1etE9KUDVYvDk6Lw2f/GVU56dAGV4Txh+ljD5FikOIGJ9L1C6pnGdRYpyp+6lYpSmY5w7AupIZ+PLFYXrdPsjwZSVCts5/Gr9b4ZSyy1KcwpHHta1O9R3/luuaP/sVGNbas3xsaIqiJG4F+3QIQb9LBXUGjoTkHGeAyTSbvQDR/oArMqnNWbH9iH3/sckRaGfwgvHsmkUvgZjzBR5zfQV5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 02:37:53PM +0800, Baoquan He wrote:
> Rename the existing PMD-level filter array (filters -> pmd_filters) and
> add a second, coarser pair of PUD-level Bloom filters (pud_filters).
> The PUL filsters operate at 1GB (PUD) granularity, whose 512 PMDs would
> all fail the PMD-level filter - a general suppression of unnecessary page
> table walks. Cross-node empty walks are the most visible case: a foreign
> mm's PUDs have no young entries for this lruvec, so the entire PMD
> iteration is pure waste.
> 
> Generalize the Bloom filter helpers (test/update/reset_bloom_filter ->
> __test/update/reset_bloom_filter) to operate on a generic filters array,
> and add thin wrappers (test/update/reset_pmd_bloom_filter) that pass the
> PMD-level array, so the PUD-level pair can reuse the same hash,
> double-buffering and reset.

Hi Baoquan,

This is really nice idea, thanks! And sorry for the late response.

> 
> No behavior change yet; the PUD filters are populated and used by later
> patches.
> 
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  include/linux/mmzone.h |  6 ++++--
>  mm/vmscan.c            | 45 ++++++++++++++++++++++++++++--------------
>  2 files changed, 34 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index f75daa6cd02d..faf28d35065d 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -612,8 +612,10 @@ struct lru_gen_mm_state {
>  	struct list_head *head;
>  	/* where the last iteration ended before */
>  	struct list_head *tail;
> -	/* Bloom filters flip after each iteration */
> -	unsigned long *filters[NR_BLOOM_FILTERS];
> +	/* PMD-level Bloom filters flip after each iteration */
> +	unsigned long *pmd_filters[NR_BLOOM_FILTERS];
> +	/* PUD-level Bloom filters flip after each iteration */
> +	unsigned long *pud_filters[NR_BLOOM_FILTERS];

Or could we have macros like:
BLOOM_FILTER_LEVELS 2
BLOOM_FILTER_PUD 0
BLOOM_FILTER_PMD 1

(just personal flavor).

>  	/* the mm stats for debugging */
>  	unsigned long stats[NR_HIST_GENS][NR_MM_STATS];
>  };
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 55d43ab54459..cd09c5b8af8c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2842,14 +2842,13 @@ static void get_item_key(void *item, int *key)
>  	key[1] = hash >> BLOOM_FILTER_SHIFT;
>  }
>  
> -static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
> -			      void *item)
> +static bool __test_bloom_filter(unsigned long **filters, unsigned long seq, void *item)
>  {
>  	int key[2];
>  	unsigned long *filter;
>  	int gen = filter_gen_from_seq(seq);
>  
> -	filter = READ_ONCE(mm_state->filters[gen]);
> +	filter = READ_ONCE(filters[gen]);
>  	if (!filter)
>  		return true;
>  
> @@ -2858,14 +2857,13 @@ static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long s
>  	return test_bit(key[0], filter) && test_bit(key[1], filter);
>  }
>  
> -static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
> -				void *item)
> +static void __update_bloom_filter(unsigned long **filters, unsigned long seq, void *item)
>  {
>  	int key[2];
>  	unsigned long *filter;
>  	int gen = filter_gen_from_seq(seq);
>  
> -	filter = READ_ONCE(mm_state->filters[gen]);
> +	filter = READ_ONCE(filters[gen]);
>  	if (!filter)
>  		return;
>  
> @@ -2877,12 +2875,12 @@ static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
>  		set_bit(key[1], filter);
>  }
>  
> -static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq)
> +static void __reset_bloom_filter(unsigned long **filters, unsigned long seq)
>  {
>  	unsigned long *filter;
>  	int gen = filter_gen_from_seq(seq);
>  
> -	filter = mm_state->filters[gen];
> +	filter = filters[gen];
>  	if (filter) {
>  		bitmap_clear(filter, 0, BIT(BLOOM_FILTER_SHIFT));
>  		return;
> @@ -2890,7 +2888,24 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
>  
>  	filter = bitmap_zalloc(BIT(BLOOM_FILTER_SHIFT),
>  			       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
> -	WRITE_ONCE(mm_state->filters[gen], filter);
> +	WRITE_ONCE(filters[gen], filter);

So the helpers will be something like
test_bloom_filter(mm_state, level, ...), seems a bit cleaner?

