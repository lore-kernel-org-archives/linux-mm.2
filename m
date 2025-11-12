Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D38FFCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 07:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BA848E0012; Wed, 12 Nov 2025 02:49:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392FF8E0002; Wed, 12 Nov 2025 02:49:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CFB68E0012; Wed, 12 Nov 2025 02:49:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1AAC28E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:49:37 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C18CB1403F1
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:49:36 +0000 (UTC)
X-FDA: 84101180352.17.371039B
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf21.hostedemail.com (Postfix) with ESMTP id C61921C0005
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:49:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="f2HB/A/h";
	dkim=pass header.d=linutronix.de header.s=2020e header.b="l0o/LkGf";
	spf=pass (imf21.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762933775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjmsQNbabVrHMjgajgEZibUL+efg9RjKcTRD2S+ysQ8=;
	b=xdPrAoHrFZDD/vg2H4/6EYzVQmdfnSY3KGiCmeZvCqeqhS2v2PJ7GJhD7nY3n7BD079RD1
	2MATXUiN40RBphkx/02GqmM4xwwiFqBC7cnQQfYREXb2kgVq/fbwG2rA1mp3wLwLsBMe3N
	LmntoRvc9Zf/Ovv/LsofW48TkQ0YGrk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762933775; a=rsa-sha256;
	cv=none;
	b=nwJGo88NdR+gs32cUVdPnza760HQquTzArGKok+psVCO4JdjggvJAzOGkRJ3mAfRwugBdv
	N2/adOTvw7ONtHRRQDoYNEm8DpontKs9Da6NavWvnXpjeMAF6ycbxqKVYRfy/N2yaBVSsg
	sKY1tXj5fnAB4xh53NvwWsfqahnKCQo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="f2HB/A/h";
	dkim=pass header.d=linutronix.de header.s=2020e header.b="l0o/LkGf";
	spf=pass (imf21.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Wed, 12 Nov 2025 08:49:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1762933772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hjmsQNbabVrHMjgajgEZibUL+efg9RjKcTRD2S+ysQ8=;
	b=f2HB/A/hb6zPD+MvHy/KC6OdmWpC1V68JL0jW4qNfv0jLBEggJ0szbe/6OorO2hbDxG684
	ArYQRJhVOGOBDvhNEI2ERthAEZnlBT2HjBfL/kf0+8KhcCPVsge0dLNgregR4MX6nJg5oo
	bpS9gAPhIWKi072xVwjJTvnB0IiQKxoKaQNhLFwvkVDMFFkJ7UIf+oDNa48WnLmlaNROEq
	5h/cgHgPc0QS7fhyI9Ff7mQduVeKdQ5HLfc6YYwGKQbSuZEok9BR/stoGLsi4VpqGFRO3c
	EeLwmycKHbL72hmLC4HFwiReBONSFKPSBT/oOafm0ECnUZHz10SG/AKDCb3VVg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1762933772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hjmsQNbabVrHMjgajgEZibUL+efg9RjKcTRD2S+ysQ8=;
	b=l0o/LkGfxoyEmPkG6koDawTBPXTEvwbAYcuza/5SjiqDSmJto9UrhdHQKSLqA10+aCQusg
	Q2gtdV349a9ij4Dg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Qi Zheng <qi.zheng@linux.dev>,
	hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@redhat.com,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
Message-ID: <20251112074930.mKu1J__U@linutronix.de>
References: <aQ3yLER4C4jY70BH@harry>
 <hfutmuh4g5jtmrgeemq2aqr2tvxz6mnqaxo5l5vddqnjasyagi@gcscu5khrjxm>
 <aRFKY5VGEujVOqBc@hyeyoo>
 <2a68bddf-e6e6-4960-b5bc-1a39d747ea9b@linux.dev>
 <aRF7eYlBKmG3hEFF@hyeyoo>
 <aqdvjyzfk6vpespzcszfkmx522iy7hvddefcjgusrysglpdykt@uqedtngotzmy>
 <8d6655f8-2756-45bb-85c1-223c3a5e656c@linux.dev>
 <aRKqm24Lrg-JnCoh@hyeyoo>
 <20251111084900.babaOj0w@linutronix.de>
 <jzihvbb6w26d4codfigy2o7b2h26izb4ahihouw54cvuzau54d@jyaa6rgpzuai>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <jzihvbb6w26d4codfigy2o7b2h26izb4ahihouw54cvuzau54d@jyaa6rgpzuai>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C61921C0005
X-Stat-Signature: i19mussni3so1drg534fm8qgq3s6kbh8
X-Rspam-User: 
X-HE-Tag: 1762933774-324806
X-HE-Meta: U2FsdGVkX18gur1+4AAlWqt3WwXNpfL+sNFbK3wEQ/PmobMcdfq8L+Li7kRCAziFrVIPXOrxoEUnFY4tkrzmRKgvFyFzTmuS1d+d2wV/hCzB/3Mz9wJJwBuDWxuc6eYo+AunGxZDIs0mN0iJb9tupAtcvQYMBEedS+RzkYr2dgYiXL9gLkXUSAV9G0RKLsUYwi/v0GBXQnb0oXcX5mRevIqq+2lb/S8glhJ7WPDjEubKXQXjD412m+UVodQAhb9qZpAGXTL81x4HwNFF2mbw5oI56LJt7JYe23WZPXEWvRbaMlXKmpZZZ/XEI1/z+wsutXwPTdOhb+ZR8om7Q0i1G0VDbZzlSdf/sbuBrc+TxHA3OS9uydgAghSst4+Dj5hLyQgA2bDUuHZu/698AymeHpKJhQf0LossvkAk2zBJGu0wdXT87XLcZJ475gds/z9UgsqjSgR2jFurc4sCacNDYmmPuuijmlQbOZrk1C9gdA/VHSmnVIUC6z5PIxpWzR2l9MVmzxQOMEOzhfuxddP9V/fzVQ0sgB/nenEl0XMDkFrSp7tAjwcrQTazeAgwDpk+Ps3hI85YQeenzIKp6/yA8KTqxI0Od1ruYC2fGsGL6jzd4SXCRSST22ynQh1lBqyNRdS7LXX1SvY3ey+vtguJY5/5xCibJw26g4zZg5ck0Bd0R3kSa1xB5FLifHBSQsGbU9RjAmvQGjUhyZchbtWellz8XspNcg0A2fS5ye5EyHdOpZJl1+/8b9DhdsBnFAPD4lcYmOlLuCggb+fxOyC87+cZ3Zq84xOUULaBAFcibhSirbMl9KNJ64GtuRlPqe6r4MxG2bLdcrBwSvvr0AUpd+9HYUuez6tEHlXwRQXaa6BMvzEQlZHANxy0P3e67eFLbrA4ucApgGzjv9G9Ze+to+PyDKcuMs73kt0cjyyMSHD4BcyrqnBX40pa15dbBNGCu6cvd5iKe1HYN9usqsD
 oJr+f0Z7
 pAAF8YxqbUavkTEWd98HZ2zRGNVNOW+jERhsUvhBqb8yTrUqWGbSrd0o1UxOjmaHakCVIiNvosuK27Di6mazL4Zfzuxyy9ssYsByr6L0jz3XfUICbKX1ZAs2XJsniIGldkvbLWAOMwy2rZZM3IrtOB12BjxHB7L8fHrr9fngUmYOgXY9eYBxQG5k2S1Vf9PCNSkB/oDCV0J1P20jbCF4Zom+GKZKJIPYxJ8RANG9bHpkytPjBO1j0+kUNWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-11 08:44:14 [-0800], Shakeel Butt wrote:
> On Tue, Nov 11, 2025 at 09:49:00AM +0100, Sebastian Andrzej Siewior wrote:
> > On 2025-11-11 12:16:43 [+0900], Harry Yoo wrote:
> > > > However, in the !CONFIG_HAVE_CMPXCHG_LOCAL case, mod_node_page_state()
> > > > still calls local_irq_save(). Is this feasible in the PREEMPT_RT kernel?
> > > 
> > > Hmm I was going to say it's necessary, but AFAICT we don't allocate
> > > or free memory in hardirq context on PREEMPT_RT (that's the policy)
> > > and so I'd say it's not necessary to disable IRQs.
> > > 
> > > Sounds like we still want to disable IRQs only on !PREEMPT_RT on
> > > such architectures?
> > > 
> > > Not sure how seriously do PREEMPT_RT folks care about architectures
> > > without HAVE_CMPXCHG_LOCAL. (riscv and loongarch have ARCH_SUPPORTS_RT
> > > but doesn't have HAVE_CMPXCHG_LOCAL).
> > 
> > We take things seriously and you shouldn't make assumption based on
> > implementation. Either the API can be used as such or not.
> > In case of mod_node_page_state(), the non-IRQ off version
> > (__mod_node_page_state()) has a preempt_disable_nested() to ensure
> > atomic update on PREEMPT_RT without disabling interrupts.
> > 
> 
> Harry is talking about mod_node_page_state() on
> !CONFIG_HAVE_CMPXCHG_LOCAL which is disabling irqs.
> 
> void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
> 					long delta)
> {
> 	unsigned long flags;
> 
> 	local_irq_save(flags);
> 	__mod_node_page_state(pgdat, item, delta);
> 	local_irq_restore(flags);
> }
> 
> Is PREEMPT_RT fine with this?

Yes.
The local_irq_save() is not strictly needed but I am fine with it to
keep it simple. The inner part is just counting.

Sebastian

