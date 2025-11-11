Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D2C9CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 16:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699618E000D; Tue, 11 Nov 2025 11:44:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649EF8E0002; Tue, 11 Nov 2025 11:44:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55FF58E000D; Tue, 11 Nov 2025 11:44:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4388E8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:44:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03731C0118
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:44:29 +0000 (UTC)
X-FDA: 84098899500.08.A256720
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4AB7820003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:44:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rfXPZSdW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762879468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AFGArA0AwyLodhjb1ON/WMsB8iA1cwp5MzvB1sHE/Ws=;
	b=KC+de721qi3RJeTcMTfKGRLFhBUXhVRbE3+EQ/PSAqmZERe6NByk29SrJBpf/JOpdfsY5w
	EDVJ9lUGadx+k3RuC8k9ieCeJZhLZYMH06RL5pWJzkVdL9IsTNbfbtOEBPYGaa+PS3meEA
	yd+vvGGhsuSuMX3bypQkB7Z/gCCJsNw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762879468; a=rsa-sha256;
	cv=none;
	b=A9vXY/NYxYiBllHoFCTEZckZPN9Ozn0BW5Jm8iEAKQzAod/pg2N2JFu71e+XfzgXziruws
	onynG/GWIDBJvkI4nexaGHkZDd1Xl9y1BArb3CxZuqEeHU5KlKI5pLZml68JQpNXoQspjy
	R/GT4uTQTrk2OEpwfnzix6HOlVHsi7E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rfXPZSdW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Tue, 11 Nov 2025 08:44:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762879463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AFGArA0AwyLodhjb1ON/WMsB8iA1cwp5MzvB1sHE/Ws=;
	b=rfXPZSdWWJKvfp/fyeozoSkkYJwyDMDkRUVrEra7CvbSs6AFwxYotJETtKrWvS3TJZRC2h
	Arwcb/Xt1oFuQUnzOeHaCFe/795zZ0GNk5RO/LZXgNAfpb+qLnIUjCIe0slSEGkSjAeNYH
	bROAJPYA4Fq3TcbIL99NO0L3yuoCXjU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Harry Yoo <harry.yoo@oracle.com>, Qi Zheng <qi.zheng@linux.dev>, 
	hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
Message-ID: <jzihvbb6w26d4codfigy2o7b2h26izb4ahihouw54cvuzau54d@jyaa6rgpzuai>
References: <366385a3-ed0e-440b-a08b-9cf14165ee8f@linux.dev>
 <aQ3yLER4C4jY70BH@harry>
 <hfutmuh4g5jtmrgeemq2aqr2tvxz6mnqaxo5l5vddqnjasyagi@gcscu5khrjxm>
 <aRFKY5VGEujVOqBc@hyeyoo>
 <2a68bddf-e6e6-4960-b5bc-1a39d747ea9b@linux.dev>
 <aRF7eYlBKmG3hEFF@hyeyoo>
 <aqdvjyzfk6vpespzcszfkmx522iy7hvddefcjgusrysglpdykt@uqedtngotzmy>
 <8d6655f8-2756-45bb-85c1-223c3a5e656c@linux.dev>
 <aRKqm24Lrg-JnCoh@hyeyoo>
 <20251111084900.babaOj0w@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111084900.babaOj0w@linutronix.de>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gt81gw1egy6huima596eqajimy39bhmw
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AB7820003
X-Rspamd-Server: rspam10
X-HE-Tag: 1762879466-893283
X-HE-Meta: U2FsdGVkX1+yom1cm1y+sIr6bSpYDRSzALQMeZ7zZgk+XiZxa2Leg52Rsvr5DVS0Ren/mFnBfV3wR/g5rS0pggTxwra79+wcBI1wkAKJlnjfAZLLRGnmds4o7Z4IZ0DZe/qXC6upen5lkn2wWTKMWPgxA/Ax67vGQp75AK9u8I46z+6HoTWkvpfmXBdSULjiJxR9TkIJaZqO8r8OVG2kBVdMfRuubQXD8xBumlCBEJJXvISWGmw6kYO9OZCVWSqkpWTEWfULE3sWJ5qzSEOz8pHhVQiNeRo+ER1CcEciPz8/P351iyMzVXil0H44k/ni7PMV36OZPUZbX7/AhELu+6KtgZL1sk1qAL9Tx7IWKYeoXQL4YOPu1rHhLvsE33fKH1oK1g6CGTwaj3INRs+QIIoxCW4zUxRTs1POtAlLqoAYv3hLkJfKpZ7/AS44DvPqgDmmoKuzMGosLz1iXxQ1qAQ3BNVgpdsUFMEoqB2psknOSvV2euRA9Wfa3mSibxJauu3GngMqA8U4cgQY9aukdT7ZH2M5NncxXg+Phbg5TeYNMa+U3zOYQFkwnfiOIPV7R1G3un60Wn1iK+l0hqWCvAIyYc6hkz1kPwGWLAgdjmo5MeiN/feQ8Dnmw3SgdvRb7ijpgpfPJL3cRrDu9OVsHOd6wnkX0qCFfu6643q6Hk0OITVO4qeWUkX1twLZYrV7wyvS84vHtoVUDutZmW/Q+d0JnPnWO806bUd8wJACynngXF7Re3RDfeOQCnKw+6puyByaIyyTU0w7oVqpDF+8IrZoJ2Ci0vHsH699ituA//XYhyR5+3AKCXHpFFOZWGcZY4C7TrhT0a7rAgtWNM0K4y6XjWMAxdGzHQnszgHJgBXTQ20d3a6kxNhdrgIi4mG2qPf6bkzPxOC7dTVDNLbYGm02+ti/2oLnF1ijj0D3V0k/h1wZPN/xNc2fZP4ZVveauAW2VIOOD9pBs1PsrKQ
 4MjhMZkJ
 knDTdTXLdWpnx/FTHA5ZG2NpgxAfimZl/FpobH/F32bqbocJAMxSRcgezxgd3e6td7d8cSflY8nSbNT2zhmS3VicimD7dNT+5foUqq5gKWgn5KxMEyMuOqqX1rZst88p+uCXkd9FNgWMMkvjBo/KC6jQ3J18PHdD9xKl9XJ4JY1XaWheqLo33GJCWBa8Foo9/LKe+Y3BRryCn5erPnLxp99PGTFO+YWyLsHzys7UpfI5E+kTqBT5NHVga65Xq+jiVVUxB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 09:49:00AM +0100, Sebastian Andrzej Siewior wrote:
> On 2025-11-11 12:16:43 [+0900], Harry Yoo wrote:
> > > However, in the !CONFIG_HAVE_CMPXCHG_LOCAL case, mod_node_page_state()
> > > still calls local_irq_save(). Is this feasible in the PREEMPT_RT kernel?
> > 
> > Hmm I was going to say it's necessary, but AFAICT we don't allocate
> > or free memory in hardirq context on PREEMPT_RT (that's the policy)
> > and so I'd say it's not necessary to disable IRQs.
> > 
> > Sounds like we still want to disable IRQs only on !PREEMPT_RT on
> > such architectures?
> > 
> > Not sure how seriously do PREEMPT_RT folks care about architectures
> > without HAVE_CMPXCHG_LOCAL. (riscv and loongarch have ARCH_SUPPORTS_RT
> > but doesn't have HAVE_CMPXCHG_LOCAL).
> 
> We take things seriously and you shouldn't make assumption based on
> implementation. Either the API can be used as such or not.
> In case of mod_node_page_state(), the non-IRQ off version
> (__mod_node_page_state()) has a preempt_disable_nested() to ensure
> atomic update on PREEMPT_RT without disabling interrupts.
> 

Harry is talking about mod_node_page_state() on
!CONFIG_HAVE_CMPXCHG_LOCAL which is disabling irqs.

void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
					long delta)
{
	unsigned long flags;

	local_irq_save(flags);
	__mod_node_page_state(pgdat, item, delta);
	local_irq_restore(flags);
}

Is PREEMPT_RT fine with this?

