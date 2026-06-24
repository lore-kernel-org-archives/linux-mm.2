Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7F1ACDE001
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4AE6B0088; Wed, 24 Jun 2026 11:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64EA6B008A; Wed, 24 Jun 2026 11:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A07186B00B7; Wed, 24 Jun 2026 11:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6FE6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:23:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6040120291
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:23:36 +0000 (UTC)
X-FDA: 84915175632.24.A8564DF
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0DDB5180006
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:23:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OO/g13kB";
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782314615;
	b=7zUBE0yfCZnGX4oW4xgwEnoUdUBBOrxHLdOas5VmUh9z5g5qmXy3+sNF8ubvr1eRdmsINF
	nFH8O1D4ACPq6ht55AMw8O6K2g7wsSWv/6ADPtmrDjphw0WCxWIhWFxmmEgf9lI/QhbFbp
	SPaCuyv4zh/I48yCBIjBkZC5tDEoMPI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782314615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WU7DP8gS2bWrp9HjVS61UBsZ2iorph10vTjTK+XSa98=;
	b=PxESfLzAb2ANnIZ41wJfFS578c7qtcxOqCruPgon0PqUW7YqFdhbis3jv+b/6FIpbCLvyC
	iN1YE6p35obIXAKEGBk4dncK7+vDjqynCMhUCGd9xVh4JYRsxwGuibI+DMKdzydIBrXi91
	smQhgy9Oozv5PGp7T1VUemHmEPb/PRw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OO/g13kB";
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-48d6c621a67so688412b6e.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782314614; x=1782919414; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WU7DP8gS2bWrp9HjVS61UBsZ2iorph10vTjTK+XSa98=;
        b=OO/g13kBLaUH2+Uy6DuBxCJ/jHLrN3vREY2CK4tvMfnXwE6zRJTIHfn7NMCJLBHfRA
         Jiq5DRP1mOI1K2wzAZI2ksXmi0YCi1qCjPaHH40gpzl4o/tiHr8e0nI7BqqXu7FseX5F
         TUJzqOB27bFjjeZBGZ1S5UnPkoUK5nSuJaF1j+apqGXYTnpBxFnWukDAvDnWyXTc1HXt
         H6nh9ENhOTFMU+ptDQqcrlgu6xMCWKlqljzw7Wze4ktIDJgpvRTD5+xNDBQXGmSM+Bg7
         cqEQzur0MjPtvO+VUYayqSWfhTSH7Tt55SR1anR3KM0yXEMkE93l1ldLtgq4Bm6LSRD5
         KHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782314614; x=1782919414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WU7DP8gS2bWrp9HjVS61UBsZ2iorph10vTjTK+XSa98=;
        b=QCHrLAM/R79hf/+85+fCK5Sb1qL67kq4JxAEkGQ+TUQsEg+yxhe32bNTE35uchrZVF
         eBPD0JYA2pgnmH+O1Z9T83Ri7Am3GhaBk1naadKoxL+orPRghBErRxlDif6z4f5Yi8tC
         kDqTigC0VHrQM3c4rH0Ydop/Wi/spwq2MqeXM1OpVtXfQUvphmONfxT54tesQtHb1tax
         P80dTGGAtT0pZ+OfOeYCpFdTL4gD3DrgR620m6NZ8o3luooy/G7PV3YB+Owe2N8IAk9h
         AXjUD600lAT7twk0fUfNT4A79OcXVqboQnyU5dTC81gqj2gAosKhd7PpQcRYrvF7jOoL
         aEGw==
X-Forwarded-Encrypted: i=1; AFNElJ/X8/G7xhkyCN5SUIGK23qTu3ntNLskAJrtcgrMDRm1+mu5W0ZifZiVKWRSalXnb+KSfJhdg6fudQ==@kvack.org
X-Gm-Message-State: AOJu0Ywlu2yVTN8tn4Mho2YuUwsudDAvIAGfUVEsDGEDtyIVxoZSFpuF
	g2p4wKldQ+aXTYuJUgoRXXLcgDkaMZSZ/ZrLXK8DagweeaalHwcdMKmX
X-Gm-Gg: AfdE7cmG+4Owb69X1tpcHtMFxewNW41woIKo38MNyuSUgdgNflin0bk/oeSeMaDI8ZH
	LG05MVWyjf6qF/cAwu+Uv3HWf3CdGCnWIbjAq14XYs8yEQ1Mwx7nGvcqs/7uBrnwN8q/Yh/2ROF
	hPoZjO2OcfjefxuIG5Gg4lbM8W0Pcs9Wy3t9rUATqhHUR6O9WqOgJcFO+1+560U5iiNp93glA8y
	5gM75TtgFdAlKQWKYYg0y/W1jBEsTU+IEbTPPyOQysuglGeQ7wLXVDvkWnnGPEa0EeiIBsPLRU9
	lWyix0EPNjLDhkD88cRl2qvywGezkKM4yTz+GAET8E80CZu4Tptl2QVweC1LuxokiJxH/hSl+/c
	KfpW2RlHujGEjuzcqKdOKNkAQSS9O0v4ZJtCTtltzWXPEryG825HNtrGfOYEyNe2oX/9bCmwkol
	3TpKPdGR7vhS8E1U07933MRRhpYQ4HtGUN4zCasB4YYjs=
X-Received: by 2002:a05:6808:c185:b0:464:5f3:ed1 with SMTP id 5614622812f47-48f29793dc2mr5618299b6e.26.1782314613671;
        Wed, 24 Jun 2026 08:23:33 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-48aebb9f1d7sm9220420b6e.4.2026.06.24.08.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:23:33 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 4/5] mm/memcontrol: convert memcg to use page_counter_stock
Date: Wed, 24 Jun 2026 08:23:29 -0700
Message-ID: <20260624152331.2228828-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260624144348.4117578-1-usama.arif@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7wtqztwh3hoptp3pgin47edpj855f1ps
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0DDB5180006
X-HE-Tag: 1782314614-858899
X-HE-Meta: U2FsdGVkX1+FUxL4FB+y24s3KgrXsiQyR0icHLk28koiPsVzd7heICZCR9HoTd2EqH5WLmSgzIldw40spOZOylQBMTd1MKPhJQLh6d+IRWqngsG7IBSTVakRw36xg4mF+IZEFR8lhGlJi+a+zQPizRbmtCY57qCVD/czlKCKcvNtw6uBF3nPQLRQzZzyqrZVmg95vGw745Wm9J0OrcUTbBqR0AyBRwP85yLzbnvz4XsmGaeeEwRBCEByuxbfoytBuSyLeLTnGVSmeM6ztNifXQmEtTXHHq9eNR+FxsE2jBDTjjrTmfzyPjjeQzb24do72ifKq27LY88Snb8lKUbOcfs6mTROEk7348BT+7cyjD5PfYSnNpmqx5ZpX1fZGo31zi9fBhTkzjyNndF8qO0haK/6DPHRrn/0czXPItklDdyRaw17ODdHk4s/sRnQ3KOKa0s3HMSjT3VsbssfP3+goPy/gkkZEOXGM6lU2r2P/g+4QNtRsBltmmkbIcV9iGVyPZpLp5GBU0HFhksQp8HCXoHnGWvWxddfe5Mg6r/9VQeAwjO4Md2nLklnyWA2v492cqNSKlN84QBtMpk+o7q+b+vKwIFzmODAUdE9p1j3AmraJujRhNHyxxhXncaP6CeH7eaK/yWoc2h9Xp3MHsrt+S7oaLHvgqb3E2YexdJ5fphpEfyoB9N6+SgNW1FpLdN9XDuSZlyw49vfc4Mg4d/vj/P8/zwuVdoZPH+5vR8HLjqDc0oYkfYF7KxLqgEaeVZAajQjr69X8lpPU98ZmOUJWudz2qOmLFILWbNSTz6lA0d+tVXw7bqf4DK8trWzlNHPeSQiV7G6wARiebZFb7ea8I92/YzsOcVMXKU/50VJuHZF6KerUfTq3ihUOWxvKGkVg3bqzpblmV9WAoJziqynyLzQ4CCwbRAFRziEqDHb8NRTi7E9LO9EvynMgR8b8sRzBafyeC3254+Ioe6NRfz
 r7nOsiw+
 YfCD6ZWzVbNq5sGR8QzmcLtdRV7neNewCv4dc+vpMfM3vkBHNgbvt9xz9lFd2hfAIfFaC4nxLrdZeSHTcb6Ve9SafOemIaTz73gO+UudUtCzKHweQL1eqcPM2ReLiZA7remQAhbli1TRgD2GU0nW1KU5rFeEX3skMtRJD2rweSjddLg8iTgY/L5126sW3hoMowrpNZ2oEKb/cdPjumem241FCQRRKCJMGNQDEDgL4Rttwa4Qacpe3xaT/9t5fyDUkRnDBHA5j0Q6XxWx4pNYGmyJPWi6WAGdsVEaseAVu9ppLOrezAIv+qAQxsYTk+mBCAg36T7SYl/wAIchNxNVpanV38b1hDPOw6xurh+BCQdxNgx/R4hGcppMJKXHvw69lmLLUYbOieBKhrMPDCXcBRpSwMWbQ3TEbIhsHX9MSPseeTUN50pn8aquRKgvApNwQKX3lmti153NmayWY1rD9OaaZko+UFDpkDcbUCNiAxSYbY1XNHzqrjEdzl6JMR7E9SOiHhBstsNf/C/51vWj65qcddR2BKWE3eGrO0JZjpzLHbeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Jun 2026 07:43:47 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> On Tue, 23 Jun 2026 11:01:22 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

Hello Usama!!

Thank you for reviewing the patch : -)

[...snip...]

> > @@ -2595,7 +2596,6 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
> >  static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  			    unsigned int nr_pages)
> >  {
> > -	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
> >  	int nr_retries = MAX_RECLAIM_RETRIES;
> >  	struct mem_cgroup *mem_over_limit;
> >  	struct page_counter *counter;
> > @@ -2606,36 +2606,30 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  	bool raised_max_event = false;
> >  	unsigned long pflags;
> >  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> > +	unsigned long nr_charged = 0;
> >  
> >  retry:
> > -	if (consume_stock(memcg, nr_pages))
> > -		return 0;
> > -
> > -	if (!allow_spinning)
> > -		/* Avoid the refill and flush of the older stock */
> > -		batch = nr_pages;
> > -
> >  	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
> >  	if (do_memsw_account() &&
> > -	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
> > +	    !page_counter_try_charge_stock(&memcg->memsw, nr_pages,
> > +					   &counter, NULL)) {
> >  		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
> >  		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
> >  		goto reclaim;
> >  	}
> >  
> > -	if (page_counter_try_charge(&memcg->memory, batch, &counter))
> > -		goto done_restock;
> > +	if (page_counter_try_charge_stock(&memcg->memory, nr_pages,
> > +					  &counter, &nr_charged)) {
> > +		if (!nr_charged)
> > +			return 0;
> > +		goto handle_high;
> > +	}
> >  
> >  	if (do_memsw_account())
> > -		page_counter_uncharge(&memcg->memsw, batch);
> > +		page_counter_uncharge(&memcg->memsw, nr_pages);
> 
> This needs a transactional rollback. page_counter_try_charge_stock() can
> succeed by consuming memsw stock and charging 0 new pages, but the
> memory-failure path unconditionally uncharges nr_pages from memsw.
> That turns a failed allocation into a real memsw usage decrement.

Hmmmmmmmmmm....... I'm not sure.

At this point in the code, we are either (1) using cgroup v1 with memsw
and charged successfully, or (2) not using cgroup v1 with memsw. So I'm
not sure if this really is unconditional, we're just distinguishing
between cases (1) and (2) by checking if we're using cgroupv1.

Or is your concern with taking a charge via stock, but uncharging with
a hierarchical page_counter walk? If so, I think there's a case to be
made here with just simply returning the stock. I just wanted to keep
it consistent with the original memcontrol code, which only used
stock to fulfill charges, not uncharges, since this could make the
stock grow without bound.

What do you think? Thanks again for reviewing Usama, I hope you have a
great day!!!
Joshua

