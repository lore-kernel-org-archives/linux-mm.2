Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454BB606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 10:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I9UcKRqs
Received: by kanga.kvack.org (Postfix)
	id E825A6B05B6; Thu, 26 Nov 2026 05:37:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59CE6B05B8; Thu, 26 Nov 2026 05:37:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4FA56B05B6; Thu, 26 Nov 2026 05:37:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADA076B05B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:37:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46BE41C43AD
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:37:38 +0000 (UTC)
X-FDA: 85476918996.18.B01F0FA
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id 654E618000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:37:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=I9UcKRqs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795689456;
	b=ym3WmWyAp72rDb5mYSGeV7yXXJ9rF/OoAUOjSMAAgQDNKkw5BwV8+GRHRJoGOatBSmC2Yo
	wIL7zHlGy9Pz4xZmWzn367sAlRFk+UF+/4Wo7G9EIckiGwXbHpCrDsO2TMw7bnEU3a/faQ
	YOSNxvhYJCGO3eP3vj3ZZgsvIU/Is0s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795689456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zp08wFsGJ44C0c4ykLgsDmwy4mpu8EhHOI/Atjz+FcY=;
	b=fDTk4TyPXjMDVcFYk0std8ir7743a2zXt2PFc7+Fp5hzOUKv5WzTKh9xSsftq8uCMzuhUR
	KkjdgoY82cO6NFXEg16/aN4iDgg4Pb5f3CZ2C3grodc7+dpolqdhfPQ6MKb7kE40xDdDWk
	ZMUZM5MFXnH+w4SzWc65XpaljCQzjdI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=I9UcKRqs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a070755c8cso3377407b3a.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795689455; x=1796294255; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zp08wFsGJ44C0c4ykLgsDmwy4mpu8EhHOI/Atjz+FcY=;
        b=I9UcKRqshZGRKKGUH9CjYe5L4TbrkJ1LhuA6COv3FtvGAqmXG+bcqCn8sm4nktWnvW
         7yybFn0tmtp7s0MhwijFgC2aSAngif7aabIFyAPVEjxU4fgndgD6TgoYmxsdg0rygH+r
         A4yysAVXS27+E8MFA3ULR7J2rMEBEqxA3CLU46FayqTypiwZM+YdoM7b+AlRi+a8RiNA
         JexJ2Q3cfYDjyoeoWhKlgkcd0A7x6Bdj9QNuN00IUTYNe2NCJ1Xu6EmmfDtowHG2d0eR
         ubxibkEEQIndxMIutLsJqkEdMZ7tiC1kkC6ieTbxrP3Yt43uZ/3r1gW5tuwC3Aa03bHL
         ZJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795689455; x=1796294255;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zp08wFsGJ44C0c4ykLgsDmwy4mpu8EhHOI/Atjz+FcY=;
        b=q7zIhD1sRTPN+f6e3p424USyHOpUGQVYLP31PXNA6OniFNBUWB+tLnNFSnjYTS5to1
         QimODIatCNj0e7y6uq7AS2GJ9Yo3nWScLtJeS5eRwYSMQre0cKO9K5XySgG9Amg2WYRv
         bhUDLyObceyPeOcPf/GwlFYWLC/6Yx0Y7JG5ToELkjZS/yWSM2HhBx4+QJA6Ar5GSb9f
         F6ADQVh0ubvFLVGCu7QRfWsjyTNLgHzuBvq38W0t3BPZld8yKg1SOpQzX2apYiNz2tmL
         tu8JXUz8WBqh+BA5sJ0pUot/XuxRsKQBoW5biii0aXhi8wLf/UnlKxs/nv0MKg5P+VHa
         ticQ==
X-Forwarded-Encrypted: i=1; AL+hErEXkyW6Z7ESrYLZGx6eF8aOP7WhCJ/DcfCOb9rIzsq3rTit5RcFuMIaUyLILvJDAthfrellMEOIfg==@kvack.org
X-Gm-Message-State: APuU4Z8ChlS5XcRbp1QTs8MPGC8dqajxouVNwK8yZmzwQda27+DLIfFd
	tfnQZsgOQcA71du3ePvpXFQLgsU1TIbLNCTGcg4TSZJN+fRCZtPPrabi
X-Gm-Gg: AZFdTZepmLCgsdLTDhYuaVtdU8Kdbs8nOku/idVVgSuLjFVCmH6DR2QbsGWsFRAOiPM
	SrC0D9/W9WLimV5oH2hd8BvKKQ6sSGwwM44yLVhSWq6WtXRut729nIuQGxtNPqOZnVHxsjPnZ6X
	c3VdLivRn1swKLb1OvmZwymp5LDXuZgAy9iDno6cpYskDzEJNdFjgB8ClCoYteE+3KETJ2FwwZG
	J772Z5tlMY92M+AfBp63UZF1XgZIJSxOTf+wm184aBin/AH1dNxiW7YwXRS1FgjzkrHeMWEx/HE
	JZuly+Eh26Yv7MIH4cNpoT6OYF7G5HgQ04xDXoJg9ftfacj1Skp4U3pNtqmDvFmW+EwmBV+oQed
	sbTAtqARqXxhq7U/TGNLiWgS/F2xRJ48k4T4qMAWsbSsmM4/Xpb85Ek99BbRdQQGSxnA83Cn4S7
	dnXT/Pf9evwcnhqcWQehFImnls5oijglpVSbDD/eARuhT302M8HKQT2ng6Z93qidB+lhk+/pmln
	BsFG0PPJjke/YjQFND/8rsox7Ir9m7BZHYKhCZxTIPK+sIyLOpdr7A9WL0rBnqkw2dm8pFZw6oX
	1Z95ug8vMnPj4g44smfNsA/yGgdemOVG+Cf3bwAXmI5Tykt2nUBvavtHlGtTLCBzJ5dZNQ+gtHk
	mNB4+SQMNpbx5ow==
X-Received: by 2002:a05:6a21:3d8b:b0:3e2:7c10:d482 with SMTP id adf61e73a8af0-4014b564366mr17311908637.16.1795689454813;
        Thu, 26 Nov 2026 02:37:34 -0800 (PST)
Received: from KASONG-MC4 ([114.254.0.53])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87353b889sm10702825b3a.42.2026.11.26.02.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 02:37:34 -0800 (PST)
Date: Thu, 26 Nov 2026 18:37:22 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, axelrasmussen@google.com, baolin.wang@linux.alibaba.com, 
	baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, 
	kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, rppt@kernel.org, 
	shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, 
	sidchintamaneni@gmail.com
Subject: Re: [PATCH v9 07/16] mm/mglru: balance anon and file scan budget by
 refault rate
Message-ID: <awf7WGiaC4LVLYhA@KASONG-MC4>
References: <20261114200803.23129-1-baohua@kernel.org>
 <20261114200803.23129-8-baohua@kernel.org>
 <5238e574-ed22-4781-aac2-b91a6b2d911e@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5238e574-ed22-4781-aac2-b91a6b2d911e@linux.dev>
X-Stat-Signature: 7trcmgn6sfafe7dekxn99pump87ww6qr
X-Rspamd-Queue-Id: 654E618000A
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795689456-701703
X-HE-Meta: U2FsdGVkX1+NZstW9ANIXjiBgrTqZU0rK4pdWQZkP8rKxOzOEZOFO2WVYa+Z2LMNt5cqwWuA6VO/gcXPOEAmaR5PbDdHJAoe8By1bGqvGRudvCyZ6YofUgjujrlwrUNVvnetrjaRK1J/mKbek3CajLQb53N5V+YIOMLd3ELdAbpt37NMu1R8qfulvxUiB9xAJrjO2MA80sUML/C3rb06twntO+B6xgoSPzsmofMHeqLsHupOVXdfNQBL8vBbWFTBf6efmGpIqABHK7yIkYHvYgaL8Ig+80ijdqMP2SVNQuwa+N/EYjKLPQ41pPTfZe7j0CheUkkP/9M3qX4SLOp1k9GrXdbhMSJQF7FiY5BMU0sjm+Ed7SdMGn1bneRjI+/BeZtPwtySwvJZWciQUJX9GePgup780j5anB959wJrbvH/gQBBBtoPWrFKpino6+ioijjFGvrt8oK04sT3rHqzE3DdE0DUmZ0LxIhJzeV5q2Y+eSrx/HOc5fQwhQCMjb4siMyJpuqCEBnEbp+e6VJmdx4loc4Gatl6+Cn80tT4wHi9I2l62vzy/mfAAWeVE0bZeTZmHxtgeDHnDowJzUkT5zW6N6mbIQp+Gjv6OxZB/Lqwa38WyRl5GbT7DNkTWs6kv7ByYT5NNcUkMuk92414hcodsxV/SxwkMh9l6Dpaz/0lNAqh0PyTe9X+ShkO02mcyn+Avdi2R66bxfOpGgVW0qRLxuDbRjX4OuovKcCAHhF1tYcbPDgGpIGBgSkNfmTqvAAeS+3giryaQYL6Vx8gBAaRhRUedOLV3aLU1J6C/1WhIXei1JJoOOPRumaXxNSP2TRs2F4tWtq3NpwvCl15vI0DUARItWJv2DiLaQZA8EWv2rPRBElKSd7hJ7ePrpnwh11JF3st9QkPn/5O5RyqJ4EUZw2zS3SVKCqLWyGFYwRhYx2F/CDKLe5VOpNREKP8HqbXR0zibXkdvvR563b
 42YywOqQ
 IgZcbsRXPE2QzJtbjOAQrZoaW5hP5o+IMjFuuoItAdG+KQ476dncm3lgAUiv/LQ/6WrvY+caXGP3CRP6vG96jPfIz04jzbLV2Njd8xi/9F17FaPIJzqHzGx8s0mfX3GVoudn+OiGLTh2EJOO+Kb37duOsmN3GmWxoI7xN3cS4egG0xMP/EdtFlFxiGAK5U3yM2nlfxhPcjb0mHTruTYHnlthe93M62vXmcHzVvYMOxckH8WFCvpLapJaYOTwkVIU2vYH39hAWjoPh6zSqjz5ZXjzZZSpADK/bJpwhY2aW87uRdaNoFHGZWYjvMuFAjSVBdKRR567mw2mCadaSTf3FBOBLfy9qcvwKl1olDvRNfhe8TWB0u9NtOe8hvK7SH7Kka0KCOCIACtWzHYrmjPr+g8H+E4JtaQmBQfTplXsCIJViYr9UkOzY51eElzX5M37xM86FYwUNL/28XPRDv1xnZdM0HL+BFpI+D/QDRUy7/1YuB2zbNBB7+H+VUshzX65e34nq8vspSo/6MwqazLIEBNNeT3sxmPzryuab2JU6/2QPn/EgVUcZcgvj3YfjC+FZOroOp0Z2d3o1sWdDb8uZ/iT3LKWgz1XRvBG/mXYhMEL4vCu5zxuXmU4uI97B7haLH2XeIUNRQWAKK6EXljMMsSHTbzrq/AYh7xraCCPtpfXO35a7m4X58sLrR8k5VGrl8JqhOFImEwZnuNXFXBzfuZrErmoDrmJPvTMq5GUmp+4ioprZSQu+RaGXVCofDPKHfaYEq7lNJV0LaUJRnUKsiKkkSslz1kHGF03LGbUz4O7IC/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 05:48:38PM +0800, Ridong Chen wrote:
> 
> 
> On 11/15/2026 4:07 AM, Barry Song (Xiaomi) wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > Replace get_type_to_scan() and isolate_folios(), which selected one
> > type per batch, with a proportional split of the scan budget between
> > anon and file, and scan both types each round.
> > 
> > lru_gen_balance_scan() splits the total by
> > 
> >          anon : file = swappiness * r_file * w_anon :
> >                        (MAX_SWAPPINESS - swappiness) * r_anon * w_file
> > 
> > where r_anon and r_file are the per-type refault rates scaled by
> > 4096, clamped to [1, 4096]; a rate at the 4096 ceiling means the type
> > refaults at least as often as it is evicted. The w factors bias the
> > split toward the LRU sizes at mild swappiness and follow the IO cost
> > ratio at the extremes. Both rate accumulators start at MIN_LRU_BATCH,
> > so a type without eviction history reads as 100% until evictions
> > accumulate, and the floor of 1 keeps a type that never refaults from
> > zeroing out the other type's share. Swappiness 0 and
> > SWAPPINESS_ANON_ONLY keep their single-type behavior; at swappiness ==
> > MAX_SWAPPINESS the file factor is zero, so anon gets the whole budget,
> > as in the classical LRU; swappiness 1 no longer forces file-only
> > scanning as the old code did.
> > 
> > The proportional protection and priority reduction are applied to the
> > total once, before the split, and each budget is capped at its type's
> > evictable size. Regular reclaim derives the total from the evictable
> > sizes, so the budgets sum to it. The proactive path re-splits the
> > remaining target each round, so eviction keeps working while either
> > type makes progress, until the target is met or no progress is
> > possible. The debugfs scan_control gets .priority = DEF_PRIORITY so
> > eviction starts from the oldest gen and reports the default priority
> > in the tracepoints.
> > 
> > Note that we are already lenient with the debugfs proactive
> > reclaim interface. We may reclaim one generation ahead even
> > at `DEF_PRIORITY`, and with extreme swappiness values such
> > as 1 and 200, we may not fall back to the other type.
> > 
> > To address these cases and preserve the behavior of the
> > previous model before scan-budget-based reclaim, we would
> > need to add another flag to `scan_control`. However, this
> > may not be worthwhile for a debugfs interface that is likely
> > to be rarely used, especially given that we already have
> > memory-level and node-level proactive reclaim interfaces.
> > 
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Co-developed-by: Gaofei Lyu <lyugaofei@xiaomi.com>
> > Signed-off-by: Gaofei Lyu <lyugaofei@xiaomi.com>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >   mm/vmscan.c | 219 +++++++++++++++++++++++++++++++++-------------------
> >   1 file changed, 138 insertions(+), 81 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index f7fbe91fedf3..18cf1c084e78 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4863,79 +4863,110 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
> >   	return tier - 1;
> >   }
> > -static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
> > +/*
> > + * Balance the anon vs file scan budget using MGLRU's per-type refault
> > + * rates, where swappiness is the relative IO cost of anon vs file (see
> > + * Documentation/admin-guide/sysctl/vm.rst).
> > + *
> > + * On entry, nr[] holds the evictable size of each type, on return it
> > + * holds each type's scan budget, bounded by its evictable size.
> > + *
> > + * LRU lock not needed: a stale snapshot merely skews the split for one pass,
> > + * and MGLRU aging averages the fault rate so we can simply read it, no need
> > + * to do any extra work here. If reclaim is blocked by unfair type hotness or
> > + * stall aging, the priority will raise and a raised priority drives the
> > + * aging.
> > + *
> > + * Calculation is basically based on following formula with a LRU size bias:
> > + *
> > + * anon : file = swappiness * r_file * w_anon :
> > + *               (MAX_SWAPPINESS - swappiness) * r_anon * w_file
> > + *
> > + * r_file / r_anon: refault rate for file / anon.
> > + * w_file / w_anon: LRU size weight of file / anon.
> > + *
> > + * We don't calculate the scan cost. MGLRU uses lazy promotion, which will
> > + * cancel the scan budget naturally.
> > + */
> > +static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
> > +		unsigned long total_scan, unsigned long nr[])
> >   {
> > -	struct ctrl_pos sp, pv;
> > +	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> > +	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
> > +	u64 anon_scan, file_scan, total;
> > +	u64 anon_weight, file_weight;
> > +	int size_bias;
> > -	if (swappiness <= MIN_SWAPPINESS + 1)
> > -		return LRU_GEN_FILE;
> > +	total = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE];
> > +	if (!total)
> > +		return;
> > -	if (swappiness >= MAX_SWAPPINESS)
> > -		return LRU_GEN_ANON;
> > -	/*
> > -	 * Compare the sum of all tiers of anon with that of file to determine
> > -	 * which type to scan.
> > -	 */
> > -	read_ctrl_pos(lruvec, LRU_GEN_ANON, LRU_TIER_MIN, LRU_TIER_MAX,
> > -		      swappiness, &sp);
> > -	read_ctrl_pos(lruvec, LRU_GEN_FILE, LRU_TIER_MIN, LRU_TIER_MAX,
> > -		      MAX_SWAPPINESS - swappiness, &pv);
> > +	if (swappiness <= MIN_SWAPPINESS) {
> > +		nr[LRU_GEN_ANON] = 0;
> > +		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
> > +		return;
> > +	}
> > -	return positive_ctrl_err(&sp, &pv);
> > -}
> > +	if (swappiness == SWAPPINESS_ANON_ONLY) {
> > +		nr[LRU_GEN_FILE] = 0;
> > +		nr[LRU_GEN_ANON] = min_t(u64, total_scan, nr[LRU_GEN_ANON]);
> > +		return;
> > +	}
> > -static inline bool is_single_type_reclaim(int swappiness)
> > -{
> > -	return swappiness == MIN_SWAPPINESS ||
> > -	       swappiness == SWAPPINESS_ANON_ONLY;
> > -}
> > +	for (int type = LRU_GEN_ANON; type <= LRU_GEN_FILE; type++) {
> > +		int hist = lru_hist_from_seq(READ_ONCE(lrugen->min_seq[type]));
> > +		/* start at MIN_LRU_BATCH to smooth the rate on gen start */
> > +		u64 refaulted = MIN_LRU_BATCH, evicted = MIN_LRU_BATCH;
> > -static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> > -			  struct scan_control *sc, int swappiness,
> > -			  struct list_head *list, int *isolated,
> > -			  int *isolate_type, int *isolate_scanned)
> > -{
> > -	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
> > -	int type = get_type_to_scan(lruvec, swappiness);
> > -	int total_scanned = 0, scanned, tier;
> > -	bool tried = false;
> > +		for (int tier = 0; tier < MAX_NR_TIERS; tier++) {
> > +			refaulted += READ_ONCE(lrugen->avg_refaulted[type][tier]);
> > +			refaulted += atomic_long_read(&lrugen->refaulted[hist][type][tier]);
> > -retry:
> > -	tier = get_tier_idx(lruvec, type);
> > -	scanned = scan_folios(nr_to_scan, lruvec, sc,
> > -			      type, tier, list, isolated);
> > +			evicted += READ_ONCE(lrugen->avg_total[type][tier]);
> > +			evicted += atomic_long_read(&lrugen->evicted[hist][type][tier]);
> > +		}
> > -	total_scanned += scanned;
> > -	if (*isolated) {
> > -		*isolate_type = type;
> > -		*isolate_scanned = scanned;
> > -		return total_scanned;
> > +		/*
> > +		 * The rate scaled by 4096 to survive integer division, clamped
> > +		 * to [1, 4096] (~0% - 100%), the floor of 1 keeps a type that
> > +		 * never refaults from zeroing out the other type's share.
> > +		 */
> > +		refault_rate[type] = mul_u64_u64_div_u64(refaulted, 4096, evicted);
> > +		refault_rate[type] = clamp_t(u64, refault_rate[type], 1, 4096);
> >   	}
> >   	/*
> > -	 * We are running out of the current reclaim type. Fall back to
> > -	 * the other type if allowed.
> > +	 * The more extreme the swappiness, the wider the IO cost gap between
> > +	 * anon and file, so the split should follow the IO cost ratio rather
> > +	 * than the sizes. With a mild swappiness, balance the scan by the
> > +	 * actual LRU size more.
> >   	 */
> > -	if (!scanned && !tried && type_fallback_allowed) {
> > -		type = !type;
> > -		tried = true;
> > -		type_fallback_allowed = false;
> > -		goto retry;
> > -	}
> 
> Hi Kairui, Barry,
> 
> A question about the size weight:
> 
> > +	size_bias = max(1, min(swappiness, MAX_SWAPPINESS - swappiness));
> > +	anon_weight = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
> > +	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
> > +
> 
> In the classic LRU, get_scan_count() weights each type by its own size
> only.

Hi Ridong

> 
> Here each weight also includes the other type's size / size_bias. So
> around swappiness 100 the split follows the sizes like the classic LRU,
> but near swappiness 1 or 199 the sizes cancel out and the split follows
> swappiness only.
> 
> For example, anon 3G, file 100M, same refault rate, anon share of the
> scan budget:
> 
> 	  swappiness   classic   this patch
> 		 100         97%        96%
> 		  10         62%        28%
> 		   1         13%       0.5%
> 
> Having two behaviors in one formula is a bit confusing. What is the
> reason for this blending, and is there data behind it? Would weighting
> each type only by its own size, like get_scan_count(), work as well?

Your numbers are right, but get_scan_count() isn't just balancing by size:
swappiness goes through calculate_pressure_balance(), and the cost there is
refault IO plus rotation cost, size turns that pressure into a page count.

With w = own size we'd match your classic column exactly, the bias is the
only difference. And the bias is there on purpose: 0 and 201 are single-type
and never reach the formula, while 1/200 are their counterparts, which is what
get_type_to_scan() used to hard-code. If the user asks for an extreme setting
then we respect it, and 15/16 and 16/16 make those ends exact. And this also
matches the other parts:

We don't use classic's cost accounting here. The rotation part is gone
with lazy promotion: a young folio stays in its gen instead of being rotated,
so the budget is bounded by the evictable size automatically. And the refault
part is already kept per type and tier by MGLRU PID, and aging averages it
so we can read it locklessly, a stale snapshot only skews one pass.

So that's the whole model, it is a bit different but works well.
Barry posted a lot of test data through v1 to v9, the swappiness sweeps
(1/60/100/150/200, with per-type pgscan and refault) show the balance moving
as described, including the ends.

There could be some pitfall with PID's ineffective protection for
high swappiness so with high swappiness you may observe a worse
refault after this, however it is not caused by this, same problem
exists for file heavy workloads, and will be solved with MGLRU-FG.

