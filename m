Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E1F3CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 18:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503F06B0088; Wed, 24 Jun 2026 14:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DC1A6B008A; Wed, 24 Jun 2026 14:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD956B008C; Wed, 24 Jun 2026 14:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6146B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:24:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D3E514044B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:24:07 +0000 (UTC)
X-FDA: 84915630534.08.0C1CE9B
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9A13540005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:24:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cYAJhkuB;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782325445;
	b=s5mFDSoWd0ANV3NTLEu0VO8s53p873IIqJ5Y+fC0Qq6iL/NKcdwhJ9lQICmhkXp2k2LDkb
	Y3kcS0osNzPPMbNFgHP9IdOYlqJ+l+yHY3KXsRdfTsFex3d7JLK2slwbFPcCXEEyu9OLN2
	+zXWxyjs/Z5qbGQKeLhBX6hhSCcOaqg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782325445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FP6al2QbtqiBNwNbl9L6yaRaxgcZf//eTD2veoNh+pw=;
	b=mGE70KnAuBGpEAZDBAciQWWsGhbPcB9+o6wykngBSAaXZZyD6azFZFOjhLofGF7BD+v8ey
	uawO7xjGyARkeH1q6cdqKQ0FudGU4zNEmzx+dAZzwxWuQRLbL2A41y/4dB5W7QufoSQ5z5
	PA1ol1PHSQJDK1PRFqHwYH/cAQS9J7c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cYAJhkuB;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7e6d991991dso1109355a34.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782325444; x=1782930244; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FP6al2QbtqiBNwNbl9L6yaRaxgcZf//eTD2veoNh+pw=;
        b=cYAJhkuBx572sD4jGvhlLsqLYMrkpX9PNknGVX5zkB7dbyBAPcWgM5dtWOw4Jf7vNu
         3DxRfS/1ACSzK9t5Z/HCWmAU/dTtRTpEKMvp3ErouUXoAm/ER7Utt4rVbG5rETf6X0kE
         s859bSlmY5KvUHlmnf8tgyP4PCj5NJp0bSeAinI7mTpTaIntVcqVKkktuJ0LBfBeS33n
         54L+i5pYQ2y51V2rSNPub4SVMSAzlHpK2u9icy7V9dMm5JDUxH8Tdeff5N/lHbJ1SAaT
         3auWyE8y9TfzqNnKtXa3s/YogL/kvnYjaLZsyUEK67QQ+PcWblNjMB9MJkxlXz3T9p0v
         MUYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782325444; x=1782930244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FP6al2QbtqiBNwNbl9L6yaRaxgcZf//eTD2veoNh+pw=;
        b=pvD9zUWJhWMImPD0cKEyrqi59pVkaUrRs47kUlfMMx9BL5BpcRm7T3Z8YOv+eY00HO
         Ii6LEtzZ6dg93FnVkRFKLrfMbyurPXqU1sKZFhru7FTzplgi8T4H7XnjF08sOBYjWQK7
         Ti2uqcZnNVpX/ZDl1crHLMc+rhP4wVggUQauIaLjf4E/yxxbONhJK3QYgalKpdpASdng
         +B/Vk+Q0g3Itc9WKNQxC8Lbc2HE2nHD2MO/8G0m8nOrSlV/ag76fiTccHHfYNtVRFpX/
         lKkCMdQ6TVjnQJfPeaKvyytZY6cKy9hC0T8my9g6jZz9S9/OJ/PGjUveEIc/u/r1evnz
         ywTw==
X-Forwarded-Encrypted: i=1; AFNElJ+6gkcNlPj5jFdzpGtcAVwFR3vROrkQjwQA+q189rePbv7Azej7MW8QQWPiT6KZbILEC+QWZNO26g==@kvack.org
X-Gm-Message-State: AOJu0YxFEe5z6mkcNo91T8g/+qprc9PAFQFlV8onL331Aq/sIrq+mGP5
	7eF1QxB1ManNLX0wxyG5VMXqqhkXgoQWNRc7CqHCb0FSqfaZN8x6MEZ6
X-Gm-Gg: AfdE7cktOoiFQ8E0RjZfzjGPup5DyuxMRrl5UgRJPwN6JIBU1VaOw6QiutfIPOw0c1k
	ARL9N2t2g7ahslUS4h8LtgyXjsSrCViZOSL+zgtYU+3/U5EKoVgZ71MrzZKgWF1RtqeDrbrD/O5
	Emb4DZoOJwPjrvwZKblFpKNzERBVfJrlZcgnPtNacCR54jdCEnOLg5ANVP4itW6s/VHngWrD7yO
	Sg+PyI321iHdu9aG5Bnqxm3xMHXjeNY29HKM6JMcMdzgnVkRBzADsIJskpyKtRSuChCuGZPhqwh
	8SmLoekAugNIIAnidL6eZ6o0mg71ov0Q+VROVXibyNbasBt6kjL3t4A4lO5RI7OkREKzhLKb8cv
	cZUr5gDfjC30R8QjcLURh2yEanGSKr4bo8ym/WNwQ5BkNjHpVbgvp2PHop5dycZx6iw3PE1kl1S
	jVZbFUYnmKvX4wEIyuiG0od83ynVq/RHsf99ZH5JdIqzM=
X-Received: by 2002:a05:6830:4409:b0:7de:5612:d420 with SMTP id 46e09a7af769-7e986c7513bmr4005787a34.18.1782325444557;
        Wed, 24 Jun 2026 11:24:04 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9442e98e9sm11837257a34.25.2026.06.24.11.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 11:24:04 -0700 (PDT)
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
Date: Wed, 24 Jun 2026 11:24:01 -0700
Message-ID: <20260624182402.962094-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <120367a5-0a3c-40ba-a821-f46f8494ef85@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: deeoq5hfjzt8azkfgmui79aq44f6dksm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9A13540005
X-HE-Tag: 1782325445-645553
X-HE-Meta: U2FsdGVkX1/FE0sWsmSB/WOT3AdAuLdz6/8iXqHmCoByz1TVjTLJZiVQZTrmEbmHXYqYTXET4qx0ufI6vQif01wPtBk0p5Vuo8vD6Gkper4aPsw0JFcRSns62iXgU4V4Sez1ZTt5t0xwrQfgwWcoALcmf+2HjbSyqgLGHEvnLDFyaoAxd9+tFD/KxuP63phPNz61lcziG9ibomcvSa2UEY0RqVi0j5H31rOmNLiGmGFDzuDiACvL4sZN+9MoYg1tjO8wOTuuqdx8y04n9TdsPp578R8d0dTK207xf9PCJQIpcDiSIX+FarmoQ21X/etr8ddSsUARjPRArkWELBuZSOCcuOOym4plGxqcZgsLGhTFLZJns5gZH07kb27h5VMhwBXcodhXCU/+Rtp1pqmzvhSRSrt3FF7nCsmzzmJDgs04FjRncir0B7IjdcwfRDDKLfY9Ufle1RxE7iYojb1jiTRcD7b05MqjUE/g7Oe8mgUt1BT37a+gt3/UhCx2y+r42pCeZPhXWltfiDgefdVBJX3Oq0prnwe2pFCmabmhtk3E9h8RLXKvJD0aP2pNCFFK7r3qxT79fAciZTfNuYMETx1zpFTTgpGMHlzZWq0351ZtD9O+sV7c+ZS4S+bZEOy6eVu5aae1vpmt5vw/BnO+WzgC7AmGHd4Oo4O0IYgWo8+QfWQVmf+9MSjlz+ICnn0rJEp7u+oEWI8CF+2zvsnDqsCkVUoKDyy1ww5fKogxxgeG0nZTBw1+aRiRsUJKVGSwhvsjC9tEh4UnO8ZRjY253NCY6d3MkAmV9rK/k86KA+XC/k34oETPoCw9CEa1kekZT36sGMrC+M6XV6auA339WhFC6LwnBnH0Rx76aIiD+mXnbpVt4iaorXRV02wikutYW3y35XJsKkcORp+1csa7ni4TtjSlI11VPs7B47CMPyeK/2VgG9F/VzEj6/vRxGxtf7hh6QhVNHbu/kONhKI
 1KwJ3qNa
 nkeR40e7u46u0VEOqUJv7vNFjwD428JJc4SM8AM4HAMvsohvofTKzCJglFaLpybsFJ89TeJNqI5rWsGwDrqJxaOuT0OmPKa9rhBSozO4djuj1j/X0igYnBRx9liUiqwbQ3vlj2ake3+/BXkvHBihn+0FoRtlbizvJC7TVVyuM9swOaFsrMMqeLXsw6B9Fq4HEQdlb8rDsHPzInh8uYj3o7BHPnMtH23BzzGadUYgbjJJMgT5/tS8m0Xufc8iYQ/BxMKngdR+2AdJKpvNlY1jwjpO/tOVRR9Stfe/yJ4Yha9XFbBriaGQcxy3U+qciiImoaIDirQUUyCBaxkXniqxTa4ZKjABvKHHANU17p6medoEtfUx5agjYQ41ACE5BK5jrz+pe88DPMcOS6HA/AcGSKT5HFkNI0eXyPBtsqxPjnF54BUZAxfM7WVVH9akuFFCdVqwKRj+7QEapg+grK9OinS4cdLyuIP35kNE9qWggV/rDp1U+adMfisKwrSbmKTtkdGW3upKBLCaGZyJD6f/MHoLKfdxeR8tqCpTlvK+QUTHu2to=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Jun 2026 17:43:56 +0100 Usama Arif <usama.arif@linux.dev> wrote:

> 
> 
> On 24/06/2026 16:23, Joshua Hahn wrote:
> > On Wed, 24 Jun 2026 07:43:47 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> > 
> >> On Tue, 23 Jun 2026 11:01:22 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> > 
> > Hello Usama!!
> > 
> > Thank you for reviewing the patch : -)
> > 
> > [...snip...]
> > 
> >>> @@ -2595,7 +2596,6 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
> >>>  static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >>>  			    unsigned int nr_pages)
> >>>  {
> >>> -	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
> >>>  	int nr_retries = MAX_RECLAIM_RETRIES;
> >>>  	struct mem_cgroup *mem_over_limit;
> >>>  	struct page_counter *counter;
> >>> @@ -2606,36 +2606,30 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >>>  	bool raised_max_event = false;
> >>>  	unsigned long pflags;
> >>>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> >>> +	unsigned long nr_charged = 0;
> >>>  
> >>>  retry:
> >>> -	if (consume_stock(memcg, nr_pages))
> >>> -		return 0;
> >>> -
> >>> -	if (!allow_spinning)
> >>> -		/* Avoid the refill and flush of the older stock */
> >>> -		batch = nr_pages;
> >>> -
> >>>  	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
> >>>  	if (do_memsw_account() &&
> >>> -	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
> >>> +	    !page_counter_try_charge_stock(&memcg->memsw, nr_pages,
> >>> +					   &counter, NULL)) {
> >>>  		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
> >>>  		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
> >>>  		goto reclaim;
> >>>  	}
> >>>  
> >>> -	if (page_counter_try_charge(&memcg->memory, batch, &counter))
> >>> -		goto done_restock;
> >>> +	if (page_counter_try_charge_stock(&memcg->memory, nr_pages,
> >>> +					  &counter, &nr_charged)) {
> >>> +		if (!nr_charged)
> >>> +			return 0;
> >>> +		goto handle_high;
> >>> +	}
> >>>  
> >>>  	if (do_memsw_account())
> >>> -		page_counter_uncharge(&memcg->memsw, batch);
> >>> +		page_counter_uncharge(&memcg->memsw, nr_pages);
> >>
> >> This needs a transactional rollback. page_counter_try_charge_stock() can
> >> succeed by consuming memsw stock and charging 0 new pages, but the
> >> memory-failure path unconditionally uncharges nr_pages from memsw.
> >> That turns a failed allocation into a real memsw usage decrement.
> > 
> > Hmmmmmmmmmm....... I'm not sure.
> > 
> > At this point in the code, we are either (1) using cgroup v1 with memsw
> > and charged successfully, or (2) not using cgroup v1 with memsw. So I'm
> > not sure if this really is unconditional, we're just distinguishing
> > between cases (1) and (2) by checking if we're using cgroupv1.
> > 
> > Or is your concern with taking a charge via stock, but uncharging with
> > a hierarchical page_counter walk?
> 
> This was my concern. But I re-read the page_counter stock invariant,
> and the stock-hit case is not an undercount? Consuming stock transfers
> already-charged credit to the pending allocation; if the later memory charge
> fails, page_counter_uncharge() discards that consumed credit from the
> hierarchy. That should keeps usage equal to real charges plus remaining stock?

Yes, stock-hit case just does some math without doing any actual
charging. It's stuff that was pre-charged before, so we're not doing
any undercounting or leaking any charges.

What do you mean by "consumed credit"? From what I can see
page_counter_uncharge --> page_counter_cancel subtracts from
counter->usage, which should be the real charge + hierarchy walk.

Am I missing something :p please feel free to let me know!
Joshua

