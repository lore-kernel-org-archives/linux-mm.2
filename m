Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF02B606B6FE
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=D+1MEvKh
Received: by kanga.kvack.org (Postfix)
	id D6B2B6B05BC; Tue,  3 Nov 2026 03:34:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42576B05BD; Tue,  3 Nov 2026 03:34:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0AA06B05BE; Tue,  3 Nov 2026 03:34:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A18236B05BC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:34:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30C1D80345
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:34:38 +0000 (UTC)
X-FDA: 85393146636.11.F80498E
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 37B5E20005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:34:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=D+1MEvKh;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694876;
	b=H4YtdX3lgWOeuVWplBwCHIyqr/26O7EOUu7ytePgSdiO3ZqzzIvcsY/Y/te2pSx+AxujJb
	9YLyYtE3QT2osiMh8EmUimEzIewps/yOtG+0nPnMack1rwtxVylN529GZwiqsc8rJieZoq
	TNqxvFH/jfWa7clQhPPIvQoj6BKo72M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=D+1MEvKh;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o94uNRQqzrylUu01kiRSHaUQ5l5ZXHsTJxuqTtmUWsA=;
	b=n85ifCQ6inAxYZY8igDa6aTnRtN9Qo1kwceofGoPZy+sy4RJBJvhM6cYMkjM/LRMK7Z1jp
	gm0xe9l9xWMlrNbfwg23uW27KJ/RFRcP2tNib3NfTqcFx0hUyx7QsuLUm35kRA/l3/QXU6
	hqcu4cNiQM97KC7yOyQG4Zog++qpgFo=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48afbd2c386so2221213f8f.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 00:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793694875; x=1794299675; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o94uNRQqzrylUu01kiRSHaUQ5l5ZXHsTJxuqTtmUWsA=;
        b=D+1MEvKh8qIlvBAoyQEDgVs6tPdKSoGvIsOQk43vm9DYCc7fYXmkczAq/u8A08CW35
         CCqi8C6E8BLodpN5L0Uy0VS7DpY5RXN2VxotEuwlM7XKkxBhAQdFkRqfQbIiuyMiber5
         t9CBpPMMRFwYdAxckl5qgv6KRjJVblpxnlq7+AOw3kb4NUti2paX2KEkTfBRaejaMyYG
         RMar/Rw8EoPbdUQV8Qx3j+E2RVDytkBR31+LDTusKd43trp+9br9ZfeIuQQsMiXGmCid
         QK+fvdHLAvXPshSs4pLzPCEKsoqRe/2XZE9Ci1PcWubrVYSGyzp6JPZqkGfVk8rn8ccK
         ECUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793694875; x=1794299675;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o94uNRQqzrylUu01kiRSHaUQ5l5ZXHsTJxuqTtmUWsA=;
        b=O43ix/cCW2dpMz2lTkhZw+SlY85kMHJKSt20lLng92e3ALC142X59qSMWMsDt+0A8Z
         KcMoLfnThx15aR5lnt/ykNC3tAJILxBsFsrxnjADpFhWyX+CBMn27GGC8rwvnaaOdmKs
         5ph18ORNx1jf8xWf8vAxf/ip4Y0jVho+6TjobU0eQUQHkdjCBwWxirxPlKJP3UfdFgXI
         GaCCV1lrADrCmsZ3X0jz70jIkAJt7CrJNA+Tl5IVVD7SICxY+18zkrxrIHoJm3N0a2VY
         V4kWZrqCod+7oKX20B0j+GHDrGxgGQVPIt3zIMQuCJRJqYiyXPJ/L3fme8PSgzCC5ZBo
         AsVA==
X-Forwarded-Encrypted: i=1; AKwUvBx2qB3zEB+6bhMKzjFrJ3qzd5uS0wC1aE0QnoZT+vs2bfJukiKAicOr58okJH2jvc4HlvzlYOx2jA==@kvack.org
X-Gm-Message-State: APuU4Z9gr47KiYxttZqLEtoChrUS2RQX29aWlaf1kdUi2o1HXrlP0OXl
	MaCI95nNF+WMKFdPkZHv0W09xl/6yDXP2N6h/0UeehRO6CagCIPrDljyEL1XDZHS8wg=
X-Gm-Gg: AYBFou0NNZbTaEhGoaavmOEEpDaPHAs01fYFlooDuAVP5Eij1c2rj8srrsZ3YN9Buhw
	LYnVbzI2OAOEnxGVeYJ8IZsybduZWE2K/9rewlkRPEDz0oZMlkncm7EKFGQe50E+XX16h47/y0D
	dqK35RLj9Aj+58rMDx1OBDhlOHWJvNjUh3yuOTreuyF8Ncu8JBZruCVDMaN+zUtChRu3yvR7Fl5
	+lp69hC514O4QAcMmmdbFEsVs12pV0YBLer786YD/NpuD+dmgLv6UT0oeAmbRalyKwXqw9avdmv
	YM0GO+OA9Rrt9XkEUMx1dT51ivZl3UyogDS9rLuLc5pRoEE0sqkWhDeN5FmT9YfrWsz+0A/xSzG
	gzRTPNs52RCT6JyomEivGsTnV6h4g+MFP60SuEG/szg/50mDbGhCQv55yazFxQYEzSbkhdsvQAk
	9qGl8kMP9NOU4bZRqsSmYLZrpJA4bm+6kk+1ACnFcQqoQNSz/WvBbnUMMnPE8hJ+QCQUSI0M/JE
	+BSwIp+9NE7EAhBhEnMchEMn7bJycV/6lBhjdL8eRS6BdXmU7I+zvG4cy0DMlv9sHfiQnNb+K7N
	Oz8R5r55JviB+S5Z8XoFnghNGFfV7A1ooGZUhCs=
X-Received: by 2002:a05:6000:2892:b0:48d:eb44:650c with SMTP id ffacd0b85a97d-48e6e309f40mr28006453f8f.40.1793694874669;
        Tue, 03 Nov 2026 00:34:34 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8a7d1sm23718452f8f.38.2026.11.03.00.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:34:34 -0800 (PST)
Date: Tue, 3 Nov 2026 09:34:33 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] memcg: force charges from reclaim before trying
 the limits
Message-ID: <aumcmb9iBpovh97u@tiehlicka>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
 <20261030205418.341214-3-shakeel.butt@linux.dev>
 <auhN7v127jwy-q-W@tiehlicka>
 <auli2Zlf1F0tyi4X@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auli2Zlf1F0tyi4X@linux.dev>
X-Stat-Signature: zbs34578u6jx7sr1pzre834uaqta5k4z
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 37B5E20005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793694876-760991
X-HE-Meta: U2FsdGVkX183oOs6dWlq1jjtpg+qYoHmFE+GV2LtLGMcs2pjjdtvuDtTaVewjND+EsTgamZw7h6ykYDtfoQCixzK3wZNu29+eM4svztJGVYdxMuYhen4IuMnBhI1QRDilEUjNrfjS7iVs2URYm66Bq8k2eFhMs+vQhBB/AnshOVvB2VvsquZZePLZINLq3MvNuwhvpFZXSNBssV+q2cy6KjqXWbkmbHqHAZwi1EDeX0Gvx+JmIhb88M9MR2aKq/Yp03BIvS01PucHnaTh26vwcaWmcEqcUEzlwd525StwCP8atCXmJkSVrHchhV9ZvaASypRs9R/2DpUDp+/1VMi0nf+jCrXAJCvGB/eCU3w1Mv9QEq5a9ziY999ooUmrivxo76CVeQVPESaHBpN825RCVLyLoFQsbL6C+pb2Xq8FccABnP+RTibok1pdBAepOgdQeD7sgWqJ7QVK4gw4X41qjV9XXL4bBoizfJikhGq/kXmrkg7h/VVTtSCGl2a/lztML5KBXODOC3eiZY6ikWt65NEXdnZbec3dScx6SlxGr6jgfC3JhePcwPt00X/thZxlqTClg8w2ZqrFGz3EQ4x5hzrXJp2GENDa1x3kQIHRuTft774EpB6aYXsra/7c/ns167CxLVEDqzVxVjF7jvl9wpBSy7wooEjol6RHBErY9iFnQj2XPsj2XkT4rvIzTUkLVzz+To8kJ9dsJLeoqeG5gbe5u1xr5rkL2YKLCVuPBwz2thn21dR0uSiecNGSMPrbPZxzyyoM/8353X2mkLC9BSjvJIfwvXa9IZ+eMr2kStLqVFSEEQB06s8AFLq6FLDCYZhz04msvlEvS5UjpS/npIkwtBMj6f9we7Z8W8eBPct5MBBND0TPgAY2PYajncWOZEIzM6J6r1LbBKqng0anFT2WGxbwkBbOiCKJB7G4BhQsmUqbZf5UEETxIYLeo4uKLPccS3E84QnEUDSxkJ
 0exOxO14
 nmSbe+VBLiaKhF9X6pE2HGeOdCjfECulMOvYGoZcOJNGGKsdwkUxGH6Uqz6b4b5aO/gSJA/sd5J/DlVOUCYA41/OLuy7vr+dygJLToycusffpiBZsMO40eW/2Fup7oIxFklLes3YEI+LReCPiQlavmMJeO+IMddICZmD68O1RAEOsUDhpar/TaluUWdCUrD00Ggw0EjfWC8xgcG+quYb/H1uI9Co24DSzykecYoUDaVc37C5uVEonphpNZtG2lvtA4hMCcqS7/glJ/yb61ajineKNR8ip8cAAyeE90J623gU2/JyKWZR7GkBvpfn5F9C1j5yqCPMbe0bw20ceHKtLqI2Xi8EH6/3xTPRDrggYVEfxdpkKsiak2ZI1tyXkW6r6xQokE7ojXvouR5SWBrs/E3OfEbWMyVX2rkXD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 20:34:40, Shakeel Butt wrote:
> On Mon, Nov 02, 2026 at 09:46:38AM +0100, Michal Hocko wrote:
[...]
> > @@ -2789,6 +2779,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  	if (do_memsw_account())
> >  		page_counter_charge(&memcg->memsw, nr_pages);
> >  
> > +	/*
> > +	 * If the allocation has to be enforced, don't forget to raise
> > +	 * a MEMCG_MAX event.
> > +	 */
> > +	for (mem_over_limit = memcg; mem_over_limit;
> > +	     mem_over_limit = parent_mem_cgroup(mem_over_limit))
> > +		if (!mem_cgroup_margin(mem_over_limit))
> 
> Second, !mem_cgroup_margin() is true at usage == max, so a charge that fits
> exactly raises an event (unlike today).

True

> 
> > +			__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
> 
> Third, we definitely need a break here otherwise every ancestor at its limit gets
> an event which does not happen today.

This is a separate thing but shouldn't we actually raise the event on
all levels that are over?

> I want to keep my current version.

OK, fair enough. My intention was to have those two parts closer
together but this is not something I would insist.

Acked-by: Michal Hocko <mhocko@sus.com>
Thanks!

-- 
Michal Hocko
SUSE Labs

