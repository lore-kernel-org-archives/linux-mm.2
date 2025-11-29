Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33C62D116E2
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 00:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193BF6B0022; Fri, 28 Nov 2025 19:00:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16BB96B0023; Fri, 28 Nov 2025 19:00:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8E36B0027; Fri, 28 Nov 2025 19:00:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF1E46B0022
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 19:00:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84DFD5B473
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 00:00:41 +0000 (UTC)
X-FDA: 84161688282.19.0FC709D
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4CB921C0015
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 00:00:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UQczXs72;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764374439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHmRWDClvlHbKFXIzPmuqyHUybDkDInr6tGn1CVDivA=;
	b=q0I+CSz/GrvdhC7a3cIkzcFD052gCghPMLeaKdKyXtKETMxbDYVm5pj4Ky+I+yuytIPiK7
	zUJ6bw1aPH+QidqLc+r6/6rEihZ/+dP8FkU3JzUOOpYvv+6s03m7bb34rROmlYuyidnah2
	PR4NVor8QRZ3+np3ZoQT9R+wXGcQyTk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764374439; a=rsa-sha256;
	cv=none;
	b=1798KrgJo7bFbaNTHw64WIizM4e1Xiq55zap95NyodlKc3kk0QhjEfM/v+uInRvMuSo0zR
	2sfQEnhpSwsJx94JyQcxlvN5z2cbr/SI+Hckfbx87M5SpcTOSm/aHJpK3sNgcsRLFBRxJc
	oDePXVrPeruwk35drjlG4pCFYtkhMGo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UQczXs72;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8b2dcdde698so222826785a.3
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764374438; x=1764979238; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zHmRWDClvlHbKFXIzPmuqyHUybDkDInr6tGn1CVDivA=;
        b=UQczXs72866n2lGUnqkiqz1iuG/LSt9cm8fwyPjVhlgDJpSLNUmn/yTMIqI6uaavPU
         XggoQC3xjDY2ZZVbE6F1EYlJxqwmlYcJ/S6tVMWFycJOUIWTT/mYAPnKQKR+owrea8di
         2ByWtRwpWoeSrabnT/QHmJJrkAXypWbdZd2zo8lIuqfLP3ocbuTQnxLwq+a3vVeTX5H3
         oWxWLyFQ9+lzXpyHZTaoLBgq1C8PJBM8/fBPRq2TBPnvALhFtGZQZZqplrkGCZBAO79x
         mHaYXG6ezhneep79WXH6i80WEoE0KIXqkxBHqG5GffZvkTw+hgR3FeLZ3igOQmxHT/Wc
         qWhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764374438; x=1764979238;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zHmRWDClvlHbKFXIzPmuqyHUybDkDInr6tGn1CVDivA=;
        b=g46Xr0eOswB9z8NTWon9KrqEV3t9gsagqBix3KD5nMeH1uYI7MGRrjMVnj/SOPxMAg
         PXaj2VgTP/JCoRIpdAf0XAIZfSpGmnRaHsnBsbJwLpwLfN3HTEIHM4Pyr/R58EoUJbYs
         RrmajQLwO8CTgCRPLMEB1lnyXrJVyLsG30Nv4RwxJ1AOoqDy2+WgXh9xkL+eXK0ggBV/
         7UUp6f3gfF4UtFWqTNeSu3MwXNGtDRVzZz6UrOud8QKKDbUD+qyax+1tsNFzDE21YAVs
         jRA1pNgjjmIdGaGivAD9UQEwuzcga3XmJyltOBNRe8YPRxFL8K2p/SXQg0xs5UkHdXES
         I3yA==
X-Forwarded-Encrypted: i=1; AJvYcCV8jxqp/CPs81/+SA7/fAhJ8wtDcb+UW3P0VV+bOQY0XgpOQ8JHEi6Q82jl7cMTYEUnNDYjt9Sakg==@kvack.org
X-Gm-Message-State: AOJu0YywTEYfCfhEfQASwqrgyR8K7/cbnlp1HYaDincHSfY+apgW8PsI
	WVVOIcSs3YDrDYWyjxAls1uGqgbqBFX4vNXNbq8+72/fcusvzlEUMs5Mu1LGXBv9U/hq0tbwZby
	Anzpj9k/aYGK2Y3DxCs9q9p8qSFf10Ag=
X-Gm-Gg: ASbGncvXINTjkagEJQ52yRStETvStaWzHFfJ114zPUk1ak3aG3J/tiznE+rOAH5YdMs
	K6otGq9zJr19w8Gf8ushr7hylXG9///PKdBf9tF1SzuGtH/qmFnQxpfpcAijmPZjk1l+v71Z6xz
	PAcOVOlFOZqo/wjzW+Hc06i38xgL9N68xGOlHGlEnpLpooxxh9ReOh1q1iAV7eb6boguN1cHGDC
	CNKnSpgruK4ZeJCO6VNg81O3B35ZBiHXcQmcs0ioRCzu4wsoisXwTfMZ0y2TGdu3p10SqctLIrr
	oyEg
X-Google-Smtp-Source: AGHT+IHd5aus7xLL1lbMakx8my9JEdXXvqk12yHdvAK3yVZa/J9RwXfKg3ffaX0U1TVmb0a5FOWBg3uaiGhnsCPLNqU=
X-Received: by 2002:a05:620a:1708:b0:8b2:f090:b15d with SMTP id
 af79cd13be357-8b33d4aec0dmr3730187485a.80.1764374438149; Fri, 28 Nov 2025
 16:00:38 -0800 (PST)
MIME-Version: 1.0
References: <780ded63aca04eb513d6e7e2c8862e6972b84b45.1764297987.git.zhanghongru@xiaomi.com>
 <20251128120328.8693-1-zhongjinji@honor.com>
In-Reply-To: <20251128120328.8693-1-zhongjinji@honor.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 29 Nov 2025 08:00:27 +0800
X-Gm-Features: AWmQ_bkknGP0gyDHYOh0J5UdJeWbVzc-rPObIQG9XbG2qv10QnYMbETPC2P-VCw
Message-ID: <CAGsJ_4xtc7ipFKYNQkGa-dSn7C8S7-J8LURqYrehfgenfPT=+w@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/vmstat: get fragmentation statistics from
 per-migragetype count
To: zhongjinji <zhongjinji@honor.com>
Cc: zhanghongru06@gmail.com, Liam.Howlett@oracle.com, 
	akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org, 
	hannes@cmpxchg.org, jackmanb@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	rppt@kernel.org, surenb@google.com, vbabka@suse.cz, weixugc@google.com, 
	yuanchu@google.com, zhanghongru@xiaomi.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 8cecq8zthc15zfx68qq7pwcd11w6e459
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4CB921C0015
X-HE-Tag: 1764374439-556271
X-HE-Meta: U2FsdGVkX19AUSmHuupgf3fA2C6VaqVlrUIvPK9fxiV9aPmqDQQwED0I3xWDHd5QKYu3JKgDguHkqnMq3ZWbLzAwyZF5EpkC5XkNQKjjXa9PNZ7xvRLMlTi9K8fBq7obGljsyNQ29touB6HzYWr0S7ItSEVxzQhsQHeZRtzkMwZHe76hdyxL2itoL1kKGgsDc2JedNtU4O+ECaJCYLLPsQPFv8K5jnipeFOUiQvOkQC4Jm0IS5mW24/SEyQYeBbFa5SEBlkmISVYZ71S3YeIqvDAX4bTBv3EZX7dgrjoav+0kWTHFDstuWfORkYQkgmht0hZqxOSiZA8DC5xOsi59s4Zta71nNfhVgxwBPMII0mfWQjtJ3ApcyGtG3Bzeq2BDpXObdwspjjDezo9uSQwtLgXAqqk08LbYcNhhqB3m/gX1QZ8I+E91Y/5vDIZW9EVFjdIdLCoz1oudk3gvyHaqm0RMrkBFixnToTx/OEq5THIrcOQepVFMy8NFmLe+TTGfezpYo+s6CcFP++N4LkyhaHpnhbT6gQo/hAVcm7c2jjk6/RcEL6kfi5urw59wBzaouV1wejL4undlCmOg1iAjdk0V2DktR43OFqva8YFQcgZWhDlXPOjMPW6L+CnGTvr2OgIvxCtEqQryV2KuJLl1jGIO506qeAvWiYGsZ1RHxjM6ohjT9oldxv6ja9Yi9V3d6pi7laEcQghQ1RX9AgvNZGLWP4swMm63yx6Vdv8ltBRwnmPg+yz6LLePH1y8KoHD6+gjPlY+qxKzArQ2RD7K2O6oZXhwHbjX60hH7ePI/0go5dwuHJeUNCFdKiA6XdJq0KE2IaVJa3s3B/bScma5MZLMaSVRcqQlX9mFLVbboA1qvbeCv1HKPnbKphgo+pXNBbcp6pphteYwS13fOLAZL9nDb51z5LS1IxcmlFfR9tLPzy7mLF9LjIIfVz2piq41WhJjYMoAUKT4aTDKQe
 RLHfilPD
 vGplEs773l605os+r/qHmGrZ3xcxspa+sAtX4+qMGDYyr0gh2Ud4AINHCXz4nvVIwh3XhJiU0NlWkCThifrLxMV8JXzzQh4sWE9hQlzt9fdJaTr1MwD3Gi3XkRPnxevUyyX8c+ArEFS57pftNayECeZNLMCS0qlGVpQ0gL+1zEhciZtsJRRKOritHgmDZluKk+ttPzPQs5hfhjGNsmDy42KEpwyMWC4HLVy6zk6ObUu9pvHPrX+2KaYdxxrBJmdt5nhRhpGutjlCBTmSG43d15Qs/DedTGWotqhm62soNnSSDj9XdJ7QVxxyIwcuiZoIi+OrMe+i/1QJ8lsS01oV4cPKLCP3DOQTyvOSbt9T95/UjUjY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >       if (order >= pageblock_order && !is_migrate_isolate(migratetype))
> >               __mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, -nr_pages);
> > diff --git a/mm/vmstat.c b/mm/vmstat.c
> > index bb09c032eecf..9334bbbe1e16 100644
> > --- a/mm/vmstat.c
> > +++ b/mm/vmstat.c
> > @@ -1590,32 +1590,16 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
> >                                       zone->name,
> >                                       migratetype_names[mtype]);
> >               for (order = 0; order < NR_PAGE_ORDERS; ++order) {
> > -                     unsigned long freecount = 0;
> > -                     struct free_area *area;
> > -                     struct list_head *curr;
> > +                     unsigned long freecount;
> >                       bool overflow = false;
> >
> > -                     area = &(zone->free_area[order]);
> > -
> > -                     list_for_each(curr, &area->free_list[mtype]) {
> > -                             /*
> > -                              * Cap the free_list iteration because it might
> > -                              * be really large and we are under a spinlock
> > -                              * so a long time spent here could trigger a
> > -                              * hard lockup detector. Anyway this is a
> > -                              * debugging tool so knowing there is a handful
> > -                              * of pages of this order should be more than
> > -                              * sufficient.
> > -                              */
> > -                             if (++freecount >= 100000) {
> > -                                     overflow = true;
> > -                                     break;
> > -                             }
> > +                     /* Keep the same output format for user-space tools compatibility */
> > +                     freecount = READ_ONCE(zone->free_area[order].mt_nr_free[mtype]);
>
> I think it might be better for using an array of size NR_PAGE_ORDERS to store
> the free count for each order. Like the code below.

Right. If we want the freecount to accurately reflect the current system
state, we still need to take the zone lock.

Multiple independent WRITE_ONCE and READ_ONCE operations do not guarantee
correctness. They may ensure single-copy atomicity per access, but not for the
overall result.

Thanks
Barry

