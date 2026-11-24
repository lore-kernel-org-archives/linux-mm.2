Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1689E606A684
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=M6pHtgbC
Received: by kanga.kvack.org (Postfix)
	id 16A0B6B07C3; Tue, 24 Nov 2026 11:47:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146A56B07C5; Tue, 24 Nov 2026 11:47:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056F86B07C6; Tue, 24 Nov 2026 11:47:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C92386B07C3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:47:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CE11C0C60
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:47:42 +0000 (UTC)
X-FDA: 85470593964.06.163A137
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4814C20003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:47:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=M6pHtgbC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795538860;
	b=LlrqiomLIW1EXR/ipw3++kb0z1HbrEwssxz1tIF5rge6C7QGjKa+/iuNYk9Gjr/MNG6CRw
	RfDaD7jj4DePEcoF0uq8uNG5A/i9+hDjSDzNtELoXOfBvhyIOdXL/STRsAYksa/lxvYCsG
	eXPWa8ZKAeW/r/dBBHlPCVjkMWJwaLI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795538860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJF0lTJAQJ039BwujcWG7eT8CFSLQY2LIYRtsZwL2wI=;
	b=8MaiuJOXqZndXkSIX06cbMlE/0rpgXixusWTQM9J4hA0Nz0vDy/yb0JuAMorknzGrZyCjS
	MO6jfyOxzSIMNR7L6rFu4HxT42O3pedcgnUPs9LX8dn8XkDkpsy8HLJ9kd0yMa1NGJyU3D
	jrC6bnd2dHP/a9DjlR2yTo/ZWgpujD8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=M6pHtgbC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cc147d86bebso2639709a12.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795538859; x=1796143659; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gJF0lTJAQJ039BwujcWG7eT8CFSLQY2LIYRtsZwL2wI=;
        b=M6pHtgbC1+a3V/eBqILZgmfHWrG7Gy8nIgXIgxQ1hoLQT8ZFL0wdI17p+dzVo3Tks3
         DI64iHnVdaP/WBsxDlJNvE9wT5yATE7uTEjGbLM+wTa/lu+EB4Gi7gl9kmKzRStFutAo
         rm/UIED4dGqoHeo0RCRGdWcHxMtimxYoQWztta5VvwrnPlhRmiD6Nf0FIIxYqsZdLSoq
         2YhDcan4ZxNtpBjuRjTCImww12/ufX52EgP0xll6FqS9DVnHOhOstyN8LT5eQugrD5Zw
         Xccw8+5DBjG9cGaDKkrrAghIqi4KaVolVpdmKx6Z0bFaihWhIsVfOCpUwXfP8f8il8D2
         fdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795538859; x=1796143659;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gJF0lTJAQJ039BwujcWG7eT8CFSLQY2LIYRtsZwL2wI=;
        b=ZCmgXpfbp5QvlY5e+zj0yF+Ont5cL+J6tIk5uu3PIz5qT+Rg5pJgqrOmFHJCN9OpN6
         666MyuxTR9LkZNgCO/TheFaerCX1nhUdlVQQ6z97vlWmbCHX2F4TM6efSvtEa8z2I3sv
         EuTmvqK5/ftCpQtUJs7cFSnak5ippYXKp0ntxGv2UZL1CAkMoC7mH4ER/Ppq/WzOP7jg
         tRpCZXWS9DugWhctIt88rdm3TTG+OvV7CVQ1KV0kRRejQ0+Hag64AjcGuukFLZ3ikc/9
         X8/8ZzCZbNs0LDQ6+n2ZWPFNADQHMjqQAzUJJW16nkZzRAEHLKI9YCbBhbTFcPGq5WHo
         gjOQ==
X-Forwarded-Encrypted: i=1; AL+hErG3OweweRENjam8WCXbkBxqw0WYbWQjNNmQ57kcgG9QUj0pukfuqteHvT5gMI0SLMRIAqcOhfO1LQ==@kvack.org
X-Gm-Message-State: APuU4Z+QUNrxX1N71TWDkVNnh5NSwAPBFo99wtq/zh9hmyStX3NbYIzm
	iDIlfzWMMVuvhvTUD3iVrIeE6KszH1CbQ0sHHxpwG+dCvIPTl21Zpedv
X-Gm-Gg: AZFdTZehm2hVkTQDx6kEbainwe9bQtM013FLhy6hkv7A+XXugsvqQZ4rGSuar2Hm4VE
	xqN2JtdzACKlo7TKeqfOQL78geIKCaqlwKlgekIf/PBHKR1heE1OxEq7dLrCifIKZMscaoY+Pp0
	x0IMAZ+/XK6KvscOlGv1XfWZvbYcqzSxrTqwsbumig/jBtwt/1CrkshWkbIRxGWhSwJIVYcnC9P
	le0gixO6CgwlrDKTuJ+m+t5YJw7sUl+fEeLUuzSIQpUpqDSO3PQt/SraxcXbMoJRwoGGybUzZ8A
	+jsJZB6YURomMfw3jO5UMcID68gXlzjPWzuS+N6zBxUmdRLuZuflAVdQAvJC9iMxR8SgYyIGvmb
	FlMNMPFR1dkUj167WYGZS/9rD1G3oRNmstdYTzIFkp5Lp1C3d1pLqdA1SRHoYiqsd4WzxcYaKGX
	+YVcippLB0V0VroFga1R3jHugaRqg2MAPN/xlrnXpv7RCq/dOAgF4081rYXt8Y6gbK7eLlCqy/W
	MaJW9yRDTYr17xxkXVKbsZm/pjXG+1NztSXz2F/w2Wm2c4bz8PmjBP6+TP3NTYP7EMCdnlOHbE8
	pBEAK8QVhfZDhs9GuDI86nklkeNp8h69BbGmoPwZ/cn9zH7xnnoYYRCmnXtaJjeozmwc2w==
X-Received: by 2002:a17:90b:4a4f:b0:3a0:cca0:4a8c with SMTP id 98e67ed59e1d1-3b41c8e0c68mr9566976a91.7.1795538858850;
        Tue, 24 Nov 2026 08:47:38 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcafe0sm25206556a91.16.2026.11.24.08.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 08:47:38 -0800 (PST)
Date: Wed, 25 Nov 2026 00:47:22 +0800
From: Kairui Song <ryncsn@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, damon@lists.linux.dev, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>, tj@kernel.org, mkoutny@suse.com
Subject: Re: [PATCH v6 17/18] mm/mglru: folio LRU refs based active/inactive
 number accounting
Message-ID: <awWvabJGg2A_rS_s@KASONG-MC4>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-17-8ffea39934a6@tencent.com>
 <sashiko-outbox-229933@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-229933@kernel.org>
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 3yy3sh1dwjjdqrf6rwq5xznpkiwqotyr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4814C20003
X-Rspam-User:
X-HE-Tag: 1795538860-300219
X-HE-Meta: U2FsdGVkX19KIby2DESBkNbnIULQxEeqquK/Kg6kWr8QHIhBqjMiORxxJSC+W+uOutz/Bk5y3nRNnshiC5LW4EdOl7fuPxlD+pYOIszH8hB0g17XAuz6Uxl4SpG76hlmhUnSwBH2XgbhzHcqRSg8D18qZeGhKBXYEACxM79KGemKk0yFp29VoCGF84nAnIWXrTPJtIr8RXg1tkZ7gGNSmO/m12pg/J3h4EChyEOwjVPOSkcWyuDecvlOQiZRfwHZ4sgFZHewU5YxfT/44Alcjd50o1J/9zgI1aM+xaQ1sr/F/YMOFpY3Cd19TO+N4ykNoYcWasnE+rwO1/egZSae0yCs3hUISXTvmxmKgHvRZrbjJfyuP1ACbRl8S0oszz/4ejabfK4OaVOxakpbCiYv22anhehGbJXwqrDYGtvC0Yr+CyWm8jpXBIlGIDo/Vz9d6Y/+piN3AI/jeIGWwQBWhNwmUF4P6fR8h0lp/vIruqv+EZHK4WlsgTO4bw/CzusfyIHVZYTPSAVPHpupdKL6rXjrlkGr3dwBRLAqVS/63t0EIRwbk3wntKffSfKGC1tGENphA9VjVSVCgsrwKA2Cl6TwDAuQcalXSuo6VwzWEerHXjR0GlAhwRKecBGm8kECPN9L6+rZShJrgwZdYe+O3MuQ6+/Lto9pyHuUor4zB48cJI16FUtXoqSYlNjkUOeD9FAncy5+59AV2mCJfiVoAgDFBOanRyGe9r3J/mXrt6ADarlMJUEwhoFR9oGh/+xmXLtliELCEDA0YBmzJtUkLsH3IT4hQZiwSEAMUWjt2Gd7/BVD1+cE9Y2AYPMSIb7sDeLZLPNIHDcyYlw06/zXitjgMvXhxuaMTTOD3T5UWvVaJwKR5KSM5+GlqcpNzA1+87Az+0l2/quKaZNig4VHVtiA8K7szZgDfHrnwRFlMMA9SpLv5bmeKMOR1HRWGZ7wLb2tPpUscNgRebwJVDc
 tVkVU8IN
 sH7pSZBwd3Mp9Xxa1r26QlzxZ3iIvLlrSY0rvz5Jy4CtKvv4OYhfWUQB3grYpVugY0Nn8VzmgG9aWrfg6LudNigX4UdipzzifUbLj2oDnuu2I+6YsPLNwoB9mdT9zUycPQKxJJ7LMRLikKyCeUsdyLSYNPXPgetvLAsvpaU92t1JwuwpD5QiMf3mWDs5s9mmHwCtw7tzPVIEi0+9sOdyV41jLZs2Lo7qNE8sxuFUcZy2XDTPM3ZSmCGkL6Vi6J2j902at/QtYx+q2OK8EJguVp8UzshSSq6EUb0p3B88bkvyre2X0FPvdjeFK/MaJuaieJGAh6CeirHSx1LyIjmotOW1HWpUyYEuViuXmaiumymJB3IQQPk64TNo3djFFvuJ6ln3eiKHsi4VSnZNc7t9yYfnMebUAA05oZFG7tsrzVU8cNBk6qYoCyaaYAvVMafjRESQ7xoGbnWDcx8uhRuv5JTH9lYg3cUEbj5ILE3PuZBeUlQ/kvX5VXFH4IEDutZGx8tewxJDP0jZNpj8nYtFaIIase4yQq05/V4ONTZK7bvg8YwaR7QV0YnrW2/NceVXRpnQfQ0jwbklgwYJQnleOyeZO5AS5hnncpjaocObQRZgOCmP1mE9I7yhW4BwcRNrpVhJf+zT6NtyoSgPg3cfURxeQifXjmhpgXeeT8NoEOGXF9sAqpbIIdFBlF+n5BiKW/4UKcuDpETBXqK8czQugE1miuEeljdz9veKSxmLgvD6pOuWJ/vVIc37N29ZT1pNaE91QtyDF514+yR+UNvgJ0X4O+3OLqIxIyInSB6S5n5Ry7Y+48glMo9dnjnAcL86/01qEZrqykmd8ifM6BSA22bC9spv23yr3So0G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 07:28:02PM +0800, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/mglru: extra atomic RMWs on folio->flags in
>   lru_gen_del_folio()
> --
> 
> commit c2fa4ccd879e2b2e8e7542ec52e0fe26798b936c
> Author: Kairui Song <kasong@tencent.com>
> 
> mm/mglru: folio LRU refs based active/inactive number accounting
> 
> This commit switches MGLRU active and inactive LRU size accounting from
> the generation window to per-folio LRU reference counts based on the
> LRU_REFS_ACTIVATED threshold.
> 
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index a4daf366e6aa7..b0f062e3a1905 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> 
> [ ... ]
> 
> > @@ -440,24 +445,33 @@ static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, struct foli
> >  static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
> >  {
> >  	unsigned long flags;
> > -	int gen = folio_lru_gen(folio);
> > +	unsigned int refs;
> > +	int gen;
> >  	int zone = folio_zonenum(folio);
> >  	int delta = folio_nr_pages(folio);
> >  	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
> > +	unsigned long max_seq = READ_ONCE(lruvec->lrugen.max_seq);
> >  
> > +	/* Keep LRU_REFS_FLAGS: refs carry access history across isolation */
> > +	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, 0);
> > +	gen = lru_get_gen_flags(flags);
> > +	refs = lru_get_refs_flags(flags);
> >  	if (gen < 0)
> >  		return false;
> >  
> >  	VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
> >  	VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
> >  
> > -	/* for folio_migrate_flags() */
> > -	flags = !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_active) : 0;
> > -	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flags);
> > -	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> > +	/*
> > +	 * See the comment in lru_gen_folio_seq.  For migration, compaction,
> > +	 * or any other isolation of a hot folio, try best to retain its gen
> > +	 * info. Ideally we would keep the full gen info.
> > +	 */
> > +	if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
> > +		folio_set_active(folio);
> 
> [Severity: Medium]
> Does moving set_mask_bits() before the gen < 0 check and splitting out
> folio_set_active() add unnecessary atomic RMWs on folio->flags in
> lru_gen_del_folio()?
> 
> set_mask_bits() unconditionally runs a try_cmpxchg() loop even when the
> masked bits are already zero, so every lruvec_del_folio() call when MGLRU
> is disabled at runtime (or on unevictable folios) now performs an atomic
> RMW instead of returning after a READ_ONCE() check.  When MGLRU is enabled,
> non-reclaim deletions of folios in the two youngest generations (such as
> __page_cache_release() in folios_put_refs(), which immediately clears
> PG_active via __folio_clear_lru_flags()) also execute two atomic RMWs
> (set_mask_bits() followed by folio_set_active()) instead of combining
> clearing LRU_GEN_MASK and setting PG_active into a single try_cmpxchg()
> loop after checking gen < 0.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com?part=17

Yeah it's true, but the overhead is really trivial, far below the noise floor
for folio operations.

I did a few vm-scalability tests on this with MGLRU disabled, and faulting
shmem folios, overall, the performance seems about ~0.07% slower while the
noise floor is about 3%.  In theory we do have maybe dozens cycles per
folio overhead though.

But well, I can apply a few micro optimizations here, they are easy to do
and will avoid the unnecessary overhead in the first place, good for
both MGLRU and CLRU.

Let me just wait a bit more for other reviews and maybe send a v7 with
following changes squashed into it if needed:

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index b0f062e3a190..f30ff9af2506 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -444,7 +444,7 @@ static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, struct foli
 
 static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
 {
-	unsigned long flags;
+	unsigned long flags = READ_ONCE(*folio_flags(folio, 0)), new_flags;
 	unsigned int refs;
 	int gen;
 	int zone = folio_zonenum(folio);
@@ -452,23 +452,26 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
 	unsigned long max_seq = READ_ONCE(lruvec->lrugen.max_seq);
 
-	/* Keep LRU_REFS_FLAGS: refs carry access history across isolation */
-	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, 0);
-	gen = lru_get_gen_flags(flags);
-	refs = lru_get_refs_flags(flags);
-	if (gen < 0)
+	if (lru_get_gen_flags(flags) < 0)
 		return false;
 
 	VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 
 	/*
-	 * See the comment in lru_gen_folio_seq.  For migration, compaction,
-	 * or any other isolation of a hot folio, try best to retain its gen
-	 * info. Ideally we would keep the full gen info.
+	 * Clear the gen and set PG_active, try best to retain its hotness
+	 * info while isolated.  The gen is the on-list marker, so setting or
+	 * clearing it needs the lruvec lock; a lazy promotion only moves it
+	 * between gens and can race with us here.  Refs must come from the
+	 * same snapshot, as they feed the accounting below.
 	 */
-	if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
-		folio_set_active(folio);
+	do {
+		gen = lru_get_gen_flags(flags);
+		refs = lru_get_refs_flags(flags);
+		new_flags = flags & ~LRU_GEN_MASK;
+		if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
+			new_flags |= BIT(PG_active);
+	} while (!try_cmpxchg(folio_flags(folio, 0), &flags, new_flags));
 
 	lru_gen_update_size(lruvec, folio, gen, -1);
 	if (lru_refs_is_active(refs))

