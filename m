Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7089606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 07:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0Nic9Lvl
Received: by kanga.kvack.org (Postfix)
	id E3B616B05B1; Thu, 26 Nov 2026 02:16:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB976B05B2; Thu, 26 Nov 2026 02:16:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDAD56B05B3; Thu, 26 Nov 2026 02:16:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0D376B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:16:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C4181602E3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:16:49 +0000 (UTC)
X-FDA: 85476412938.21.1993085
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4933640005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:16:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0Nic9Lvl;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795677407;
	b=zzrhGK+3Y/0eeYTkSewJob5eSUHLJ9pqhpQfbSgOORZzFesRGYUaQlBloHnSNbO/HAIHb8
	o6fwjrslvtUXJKRidrTAbnz3cs9Zhk8mtziRuyxnxt013ofs37wxvB478HKXg591KZBQNo
	ot1gOjdudoA4mCeSsj+SZ7ouDOK3uz4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795677407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tioXBSwm5pktLh4V7ZjeytUoL0urdjzGdHunvMaRHSk=;
	b=wZm7A0rmo8YkDs5HKIOHgTH2tkVcG5/pJdIg7faGI8Wm0rPd23IHl3vvKZ0A97nUlGIsPh
	W1jEA45sbVYmqrQxSb/QrmhdCPhzVtuQHsyzy+iE6P1c7foQAy+6J8JfSd91vgEuTaNw71
	OZIQNPFUMTMrW1AJg/mNp38mf7tg9Q8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0Nic9Lvl;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cd69954c755so4891554a12.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795677406; x=1796282206; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tioXBSwm5pktLh4V7ZjeytUoL0urdjzGdHunvMaRHSk=;
        b=0Nic9Lvlr/1obfd2AF2BnnyEaVKdCfzHq+DvkWYbhM0OH/swqYNfz7OU2l9/8vIFXE
         Yh9Kxr0KezIwz4JuD/ky8Zn+WQbaIkGYuJsGJbVF8Axyd+5EKwYj4M35UzIbje1qRQbR
         YHEVgmligcgJvf4jpp2B3QVY7RyOAdzJOh/Jk/Q8nwp9ZJ5lxOiLRCzu6Me0NlHuGUMP
         pH6pXUe35E4cWIVx/wgmbgyNRxnzeHvkQN/K3J5GdotqcnSjmFD/xMz2C0V5PX1gp9MM
         4FgWGy3/v/+VkHTzx3TneJo/nCFsGr9v7tlQy4Vq51sjpSVjhtsvkpsHDMGmEiVB4Cm4
         /5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795677406; x=1796282206;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tioXBSwm5pktLh4V7ZjeytUoL0urdjzGdHunvMaRHSk=;
        b=2O1WoBQ4LHZEHp/nmUFV3MYpJuf/P+2/gE1qG9zw2bFvrlMtmzwtM0ijGH8LlFBz11
         ellBiaXHwfNQAyMnF5u1Z/JWkWqoJNafnzMnOu6aAqFQKO6+MK9kLYakUB4tbMBQdJQ9
         fmldebmaIi3hn1usuTXZCUSwjaKtT/l0SF0f3Bao8bjpMYNb0D4b62vHnjQnSAdxMg+r
         6xkyHuJ0n0pxV05sHkSs77BARQwvKhUS59WmPrATnxlyNPsaU/L8j3sHTt7hlPvco9A+
         aBO5Ey93fiOxyokiarnE/i1ehgdyKASO5gsS423jHvr3l2GqGHfk9t/7jZOIDCOi35Tg
         XrYQ==
X-Forwarded-Encrypted: i=1; AL+hErHmPgOKMuVtd92+R5VtQEQEKDElS/BQIwYNysUMsnx94f9TL5DJRHdY5hSNELH6TGKA3CvxSX6zzA==@kvack.org
X-Gm-Message-State: APuU4Z8Xyhn6StHbbN4B9oJA8GLBILZgTWhxzzzi9gPY6C2kFdzsfCFF
	ryyYol+K4JnK+YN2wDJvb5HR5x5akQKCeexbBfBWvQASsl9tcM/cvCtytWwOPOQ7r5o=
X-Gm-Gg: AZFdTZfm4MfoQdQwxT7L+EYJoUJAbhAzJ29bikAa6pNE0jvUojsdqNqx+h6v3kjiSAb
	B2ttPNN/r6/D9RmsQjkunODC54GGE9UuXs/rCC80/wTAKZ0jIFWpL/T9qNadFy2ue9ian4NI+d0
	sjCkZL5s338qOc5NfPWNmH8zp1Sky1IQnN3FEFpQlq7gcu2n42uxQTLsFsl2OMBWBhWjkK0CPHo
	YbAG0pPRAIKhY9fT0ZHCIEXMEDqO+XfEiuuNxsxz1UUIrhIMYKKxZFY+eMm1V73nGKwbX4vzE7r
	PvbEHvGHe1l5h7rHKaWGOnx6IsnKhLo055aUj4u7kP8tmuwkCUyjCJqA8nBulopI0/0TA5JtBGs
	VN5XNAJr60u89AouCJxGya+mXcoul0gT+OPhX9hrss8Hp+OVPuJBsRMw6nBRLnsXvk9ztifMIqw
	ktWmkPyUAXLDcuqbMlz/jr8vkDrzqQq+U1wZEXhuds6EaeklC0nzijrijpafN7b/11zxDb98+Bn
	uIvi6Jm7m51cx2Ln9+JT/Ofat6aG/FlMoOiPEX29dQHUKGHg2QnUs9+y2rF3o29dBI/oeA26W10
	feKzf/GIWmhL0bx5E81lgssDq1smyaVufPNRJ+5Hg/MPGPTU5gBp8Ll9FiGwny4pzAqyQzzQM+g
	=
X-Received: by 2002:a05:6a20:9389:b0:3eb:9e7e:1ebe with SMTP id adf61e73a8af0-4014b65c9ffmr25687016637.21.1795677405734;
        Wed, 25 Nov 2026 23:16:45 -0800 (PST)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c86d821637sm10523020b3a.0.2026.11.25.23.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 23:16:45 -0800 (PST)
Date: Thu, 26 Nov 2026 15:16:32 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
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
	Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 10/18] mm/mglru, gup: mark folios referenced via a
 fast helper
Message-ID: <awfb-vGF62XvcX_F@KASONG-MC4>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-10-8ffea39934a6@tencent.com>
 <6c3d32a9-3004-4a17-b854-7088e69f164a@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c3d32a9-3004-4a17-b854-7088e69f164a@gmail.com>
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4933640005
X-Stat-Signature: 6ckmjgked3x7kinf8u6doym8t6u5g1ci
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795677407-801566
X-HE-Meta: U2FsdGVkX185Zq4xQIPgb6auSAeL9E7HVQxBfnELs3vdKSupw6Sk0TaoBbnqkypq0atd32G/5uMr1lnb7SyanzuFKBsrWAtgSE8pYc7c6e9P490Eyjby15AZyEYSlekGz7VNAIw63qCD+4h6H/JflNuO8nX56Ojkt3I9PNGCXt9Pb0HYSj3dkv8GIbK8s2a89Rq03aFqYuoe/S+m28/lr0pbVGMMxhsRHDux8oWJfapr3bql8MvDSd0g7hX2gKgvxqU5rzwE70Gtti+VEzJfRDTl2acFJEF9b1fbu25ooUhJ1KJPfIcaw4XJkto8ZxpVqHp6fbarbGRJpq2vrxas6qjjLQhaqzo5yl/2wHqPNZwUQjVUOhGAKgpO/Jt+45NFZjSYztOKxjbuXFwT+RZz1mgMbDknyS2KsT3c68ohVr+n3cstSOO98+7okHt3KxwENKEIYrrVGl1IEk1DK1fdLJR0OOPVR4Y/4Cp4BYKt1StTkibdQ3beVWzTsESj83/5+IgDDF+1NotgiJwrXkHHkN55NxkqLMEGk4sByPrDA6nonr5AYq0dwj3gYQvP+b8LjFL52eAHbKEkVB4yOc1FCImgPRAxFcOAUu66KFDWTnt2jVY0HKceira2PXdzwA+IQ5x1zMdB4+uraTL8NR+Bf21YO7kCuO1WYf3KWuysJvXBRkHcieuLUhjTMkXb5KMmxXpOZLppy1z9bxb0iMaslg1EskyYbCssGhEM0Ra9PkHZen0UWBcM0nHfZgKdRkMhiKZWy5JWRchI5EYWUBsQGf/VSsfo9DCA+4sHyaHJ2mQlrffO5qLQU5lBzc9uECRFDFyKbQu2z5qCMpl/u+wFl/7IllcNJpkJXtjoPFsBXb1mBUqkbKQglg2d5Buv5UjbNediJKvc4dGq8HppSZ/cUCnwwCWR02S3BmQtuAGJPa7viYysEoPlBDYhdLoZM+dDbuT97EDniQ287GQML7j
 0xe+ms0T
 r1QFCkIH3ewAJQd//HB82eoIU8EofE024pRZc8Jchs33t2MoI4hAvL15S3VJoVIGy3p89NO0nZdUUnR/+EgHykWgsniYldXSGgzQWfhjZyaDEUDcuZIB0TcWiCU9KlqrRWthTr87Q6F8ghGokBkrRcxz986GpuQHznz04Y9nuj72daidiJdHaKdmEPxQ6gQpGz79X9Is15/jCQCZMRNSZn4EZAWbIL4rvBB7gnHoowcwO+Ipax6E1vPnFqsh98hFyhG2xP3bOVoz9GHT2r5+fnONV2lmPqU+iu45D+qC8RPiHWpY9fxi1uNSbQXIF8A+frK3bbwaavYr2ix/1CuPeQLWQW5Pqf3LeC2wUaUczEbQFlFi5orqWC33r/9VGyI+9/oJU10vV8BY385QfuZbo9P/74ax3a1rGsOxDuQpRB3OZWbIO6okKlgqUqUJh1FMOP1QFGPt0i/ETXOUiD+PlKFsJ3FOiui7amLdLdmtFLamrZZ2FhaQf1onCpSiv4+5P3PWpwG8Fm2AXDznpjturSp4ZkyarlQEuIvGwBqTHCsxGry2JlQcSHEWuKGM5HZT8aeux2tYdFisPM98iDo2LUFrvToC43hayLMzUpK8jpTm9MSxrxvZR5qfbodzU0SEeNj/5CjqHqdIoGXwZsMfB5j/awAoCyno6kZ1GJ+Qg8fdob9N4rcfHF3e8QNcKKAIA6fZcdSC+R4yaJ5lx4D3C6VPcM+l6pDsy1K/M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 09:47:18PM +0800, Vernon Yang wrote:
> On Tue, Nov 24, 2026 at 02:53:02AM +0800, Kairui Song via B4 Relay wrote:
> > +/**
> > + * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
> > + * @folio: the folio
> > + *
> > + * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
> > + * untouched. For a folio off the gen lists with MGLRU off, a plain
> > + * PG_referenced set.
> > + */
> > +static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
> > +{
> > +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> > +	unsigned int refs;
> > +
> > +	do {
> > +		refs = lru_get_refs_flags(old_flags);
> > +		if (lru_get_gen_flags(old_flags) < 0 && !lru_gen_enabled()) {
> > +			/* For CLRU, just do folio_set_referenced() */
> > +			if (refs & LRU_REFS_REFERENCED)
> > +				break;
> > +			refs |= LRU_REFS_REFERENCED;
> > +		} else {
> > +			if (refs)
> > +				break;
> > +			refs = LRU_REFS_REFERENCED;
> > +		}
> > +		new_flags = old_flags;
> > +		lru_set_refs_flags(&new_flags, refs);
> > +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> > +}
> 
> The implementation code of this function looks a bit convoluted.
> Would it be better to simplify it into the following code?
> 
> 	do {
> 		bool clru = !lru_gen_enabled() && lru_get_gen_flags(old_flags) < 0;
> 
> 		refs = lru_get_refs_flags(old_flags);
> 		if (clru ? (refs & LRU_REFS_REFERENCED) : refs)
> 			break;
> 		new_flags = old_flags;
> 		lru_set_refs_flags(&new_flags, refs | LRU_REFS_REFERENCED);
> 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));

Hello Vernon,

That's very good suggestion!

Only one thing here is that
`!lru_gen_enabled() && lru_get_gen_flags(old_flags) < 0` doesn't mean
it's classical LRU, maybe it's just isolated. How about bool on_gen?
Or bool has_gen?

