Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB11C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 15:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694336B018D; Tue, 18 Aug 2026 11:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 671916B018E; Tue, 18 Aug 2026 11:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581076B018F; Tue, 18 Aug 2026 11:09:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE2C6B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:09:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA4E01A012A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:09:46 +0000 (UTC)
X-FDA: 85114724772.06.26AADBD
Received: from mta1.migadu.com (out-133.mta1.migadu.com [95.215.58.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id CEC434000B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:09:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QTbaK+bE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.133 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787065785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Dl6Wt3k7vyeHpAoWSgDxqZwa5BGvSU3LUP/O46fIxA=;
	b=NYAtALKPIiByysaNhLxvNbp2Zv9yIEYTKC+Mfgn0rWza7tToEboi3BcfmWO5uyDsK+C2Tc
	izUPKo5VJ3/5vmwumJat0sjy0IMiSYsRgGG0DwBMGrQSnIOmIH+CSTI3+eeOdHwbg05HB5
	97gG6W4DDlRWQ/Mnc38sXC3XbfR1j3c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QTbaK+bE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.133 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787065785;
	b=FwKwvq+M6h0Njq88xfuhWAgCga+Rx8px8f8E9wGPTfQcNOSR68NM4MRIu4+PjaLglTXMlf
	+4QJE21Pi3MV8dk7Pri1BnRyu+5oNpF+UyEsSTiSEd9a29/ImvekWoP8oEgjW55q9qhBCu
	QxBERSSgPd0Rb2lesJjkE4cbJHGcWio=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sEjhvPD2ekveHVjazAifLyhpA56JI5CFArPLYf0xVLY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787065783; v=1; x=1787670583;
 b=QTbaK+bEJOztQQi95vCcdTlkK1aS21S1B3dg4EZNpJrR2sHFM/LPNtWwnzGA+bHUR19RP0hj
 vRZjJeaYCZ8eOe6leyGjH5yd+rDdTXqesevO/pNuY9dmVfr624WHccB8gjECFnTGTlJVdI+mggY
 kRB5dbVsa+bONvOz7aNjQkx8=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:59::)
	by smtp.migadu.com with ESMTPS id ddfa09f4e93c0093;
	Tue, 18 Aug 2026 15:09:43 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 08:09:42 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, mhocko@suse.com, mhocko@kernel.org, 
	joshua.hahnjy@gmail.com, willy@infradead.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, zhuhui@kylinos.cn, audra@redhat.com, bingfangguo@tencent.com
Subject: Re: [PATCH v2] mm: memcg: release the css reference when a stock
 slot empties
Message-ID: <aoR1lxZCxkD2jEVr@linux.dev>
References: <20260818130135.154315-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818130135.154315-1-husong@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: CEC434000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 4o1gtu5g1e6goy9ob84uyq118ysnryb8
X-HE-Tag: 1787065784-502129
X-HE-Meta: U2FsdGVkX18ZluD8eJVO01/QlzrsZe96HXjRRE0KSXuJ1krNmlKTKLEMFxX1NiK4cAH2HfUsGIPJaGt39Ge6Mh/eYpR0xFnnxuIcHBbagQcVqE4Kk3UYqTOVRlOOJHT4JtmcgE1yL6t/2DE4S/DaE3iD+L//Ye1kJ/agbaYHlI1kp9C8FCAycjywSpURyuAsP5bgubqlbl/BiKn6sKE+LftsXB3nWkol4rlj/oeLhX/NE/oHRiMBJgwbVrYBLnz2wOaXBu2aa60XKC8vewrSP2WeVnkFNI4Byy/Drtp+Ae1NXTXM8tpcnZGapTioFDl+OQwmFXwOj9CUWGPFt5kaAfPztluPaawK3dxJYD0JwoFv1Mc6Rvi0+FgRY7yObJ7UZwGfZQ8nxUan3xl7JpAZaNm/ybd0rJc6x14T6dbkAb50qA2MVJhhTZI6ha+/4LeqIUltKpUZrv/e9qcmqLtWj1DmpecGdDKHCVdIJl2q2axOHAwyPH3K83lP2j2/6+b8dJjQvSeqgtzOmIHj5CciI20IZUwX/cwbBiIJiLOw1+Qw9LPeB4o/Za7nBwZRbUYtA4cdS9bWKOYfYMsX4X8KszaE5MEX/900Lq8FcRNWTeXxP1C1WaB+sJoJqxLuaEbWQv/yR7mzABERUdCii0gn9TbEqGp0zxx8TNXsz1S7m0uZTQTc1vc68fFpgLkxpS9VB4o61S8HPuswxtCEIX/uvUBUOaHPMbDjLyJbswlzz4nU0RfbsQTv+WLgmw+Hn8egADfEM/H5aOTosrQlIa2z+ht45I0rBqUeCMJI3SlSoDVaNs0pCaRoXJsnt84hvxNHSHUtw3+3FpD4LyzxImVbF3nG1Wo9bTzox6cpZcE88vaBbQ+RIIEmQnx771pVqOyQqSwlRgfPuQIBKPF8SUb+UTmr/S2d5OixiiXv6Y1If9GOOpuWsewjfwww39zoTffMYRv1PyUXnnuL0Jh67Yy
 OWHzONaQ
 XmxauuDORhzC3ZEsw3PPvqrfvfingHX3n2Zl8DTIOw33FMbN/orEOUVkReJ1CjGgLJgUFrzIJyNTvQ4SUaT6H5U/C+yKMSqcEeL7WsHu6WlzzRurdud6KAavSRO+l50AVid6INgo47pzsJ86Ljx7/KL41RJ4RIjcQf/xHq4LEG53QeNSJvnr17tdJKnbB5sV55RxKb6bnBi/K90ShBLSw7j6IsmeoJIF5rUuEo7zyoenD3EL7hSsxtgCnUtrNBtNqitHPKLThfGtaUA4TO38iumWbMzHZULm51sd6aiURf9mKoRLqWvF3+x5LNoubmeeDZJVFEsq7qmfBUFO7UwXwUkmydff/YHgnslLXhlaJnU6XechyUp4ImdFc9UrtWoWXXnqciLvoc/PMoDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 09:01:35PM +0800, Song Hu wrote:
> consume_stock() can drive a stock slot's nr_pages to zero while its
> cached[] pointer stays set, so the slot keeps pinning the css
> reference that refill_stock() took.  The offlining drain only
> flushes slots with cached pages, so the reference is never released
> unless the slot happens to be displaced by an unrelated charge or
> by CPU hotplug, and the memcg lingers in the dying state - up to
> NR_MEMCG_STOCK (7) of them per CPU under container churn.
> 
> Keeping the slot populated past the last page only saves a
> css_get()/css_put() pair on the next charge of the same memcg, and
> costs more than that: the offlining drain has to know about empty
> slots, and refill_stock() cannot reuse them either, so a charge
> under a different memcg evicts a live batch through the drain_idx
> rotation instead.
> 
> Drop the reference in consume_stock() when the slot empties.
> Empty slots stop existing, so is_memcg_drain_needed() and the drain
> path stay as they are, and refill_stock() reuses emptied slots
> directly.  The cost is one refcount pair per emptied slot, at most
> once per MEMCG_CHARGE_BATCH pages.
> 
> Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
> Signed-off-by: Song Hu <husong@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


