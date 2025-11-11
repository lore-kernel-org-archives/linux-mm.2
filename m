Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D0B9CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB1D88E000D; Tue, 11 Nov 2025 03:49:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61FD8E0002; Tue, 11 Nov 2025 03:49:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50B78E000D; Tue, 11 Nov 2025 03:49:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 912488E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:49:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28981590E8
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:49:06 +0000 (UTC)
X-FDA: 84097701492.13.E2997B6
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf23.hostedemail.com (Postfix) with ESMTP id 80A0D140008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:49:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=cCjfxdSd;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=HIm7hPIl;
	spf=pass (imf23.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762850944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lug3ME6CtD6QvK/qR5uG3WWqf/M2ZdQU/OQnEwpHbAk=;
	b=6I3m6IVl9Hf63rZWzgu6n8PZG293Q7XAxzI3+q4P+5zqfCX9IgvDA+PuFOhSNH1/XVlOUh
	da0YMGh5FaxtkWbTYmbndFLVe5xJYQkkDEp7HTuLqv5mJxZc6gVSmpLaQhKNqi2XTXeqJd
	f8ZVIz6W8zC6LamFU457GBJ5zhelKZQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=cCjfxdSd;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=HIm7hPIl;
	spf=pass (imf23.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762850944; a=rsa-sha256;
	cv=none;
	b=d0TniYGLct1g8m8uV82qz8w2Iz/eFbOqdQJPTd+f3QbL3Vx7Y3anF2La+aKBBmrmN5mWGO
	3zOqyOCN917SUgrKFCQSXebCZ7WoN/Je0obaA++GI6YgRAKckttfR8Gas172xtIbLEATbN
	FzvKuG3T543pYkB89LbL2ReNIuSsULI=
Date: Tue, 11 Nov 2025 09:49:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1762850942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lug3ME6CtD6QvK/qR5uG3WWqf/M2ZdQU/OQnEwpHbAk=;
	b=cCjfxdSdzShFAEa6SvGIzVs3lbcTA4pHEJ25qlpTUWLXnZtXrgeu1F9Lp05bUpaFskLvhr
	lIi3lbU8+TKDKtBzNN4i+MfzDlppoHqpK1TeDkHtTXQqeP7TQBatHoVCUyibXb1/0bYevy
	g1CBZoS2lGowkWa6daKovKfR5/XAEGsZpBb3GZaXTWb378xRVGe3AXhzwBh9atkqs+jUnI
	CRNtILc65XaP0p7cWpTJXbgRCHGrro9ob4Lf627HvhLEVwuZhUhzj2Udx6psxpTJE1txF3
	8eAdbFZyz1anOH4fXTM6iqEDaNJwaL7rrByrXovTa5H12vGtwCxQj/G91CpRwA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1762850942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lug3ME6CtD6QvK/qR5uG3WWqf/M2ZdQU/OQnEwpHbAk=;
	b=HIm7hPIlEuOw5BRjNF1vnYS3Kg1k6TeP51kIcZF3a318jajF+lq7IYXJkODd9SC+gCIdt7
	Zcpr2GVKPiesiqAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
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
Message-ID: <20251111084900.babaOj0w@linutronix.de>
References: <aQ1_f_6KPRZknUGS@harry>
 <366385a3-ed0e-440b-a08b-9cf14165ee8f@linux.dev>
 <aQ3yLER4C4jY70BH@harry>
 <hfutmuh4g5jtmrgeemq2aqr2tvxz6mnqaxo5l5vddqnjasyagi@gcscu5khrjxm>
 <aRFKY5VGEujVOqBc@hyeyoo>
 <2a68bddf-e6e6-4960-b5bc-1a39d747ea9b@linux.dev>
 <aRF7eYlBKmG3hEFF@hyeyoo>
 <aqdvjyzfk6vpespzcszfkmx522iy7hvddefcjgusrysglpdykt@uqedtngotzmy>
 <8d6655f8-2756-45bb-85c1-223c3a5e656c@linux.dev>
 <aRKqm24Lrg-JnCoh@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aRKqm24Lrg-JnCoh@hyeyoo>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 80A0D140008
X-Stat-Signature: edxh51a5obrkanjjx31m6retnsb5cqox
X-Rspam-User: 
X-HE-Tag: 1762850944-169325
X-HE-Meta: U2FsdGVkX19bzEdEebRPrTtq8SdXK1taRmCR0Cz8MT5obyyLvtEQ420hm0W1QNC8bNNhX16les742s61ePyFfNqq+mKGzH0EGX+D0xvl+E0xvw4tLTNIBGYytoWG+9eJK7NhRfndNyfggOYGwje8Eu8oJ0bMS4BccZZo6dRbLMwO9e15HXc1JteB3lOqbmNZfUn7jEk0elxkXlmjkbcJosHlpoZoVFHouyYIZQDfMsdJ0HrC4UACBeRHZMG6I3mNEB731ZTfQUtcQnaw8+ZAc3sYfVvFQzRbUjazUy75XSKNebC0GKldc7rGuokyF4Ue2Gpf6DCLnIGq17GqYI6bkDWSfBYQKWQjP8Vtpgh18fb+EK14A1ejrksZ8fd0XCktlAg0rakXfsjg+664RmaiWrDltXqTSsVOaBqHQyUZxN7QhEKhLHt8L+3SLIdOPOGADc2xMj1i77xqesHoTsdzKYxOv8REiW2qAfW+XK6seDdsU29SsRH0aDUee+E0iSgkA/f3s+NfIrFpUngIrf+Q1etcWvNOtHpgOk3e0ESWgIQAvqebpZACZoE0Sjyr+r1zWau60Y7CNwrfBSAPwInbvSinmuY+FZ2Wr9koqaZp8Epqj8O3SO9+Ca2Fai/5NFEoQR6SgP9UW49hrsS+qv1AOu8V8JD8O1ULr1Sk/kyDcAo1XI2erAD2h97Sgp9OerYidZKgsRAvH4Dwaz9xb9UYbi62NAfhzNxXIM0Cx179wKXXyeyn1Ef5KB/JoiE0MXzJdLAAxOFVd3VSwM04yQSRd9AC/CLIscdMZe6Pqs2vUxOvxPgGunbfRW3vX/shQ5rN8wbA1YCbEN0qKHPJ0T582pRke8bCGUmmdMIa0AiHw07VMvij6DF/oYtN3hJYl7uqjDWEL/ZWorZg/m4w2dMj2PeGpAJk2FJZZO6XUvpqmEeQcbFpsJp1a3mBIXPQdJH9HujSoTdHEnOG/r5NYkB
 qdZPWLJp
 s5m4F0seoDwYYFaJ0H457BOKSzWUj8TWv7qj9bSuWg2WRi4e9yu7AQH6TG1p/CeWN4P5yIJ0JyLrgC0FlJbJCDw2MBV4vuTMvjvIycL41VQv9ZcIp26VwUXUKVry4TLT2MUvoCv2UKeM2HKWBnk6T70F4pgr+7Fl1CNdxpPpHFxC//R0osIwIQRUC0Vl+fwTq9Rz5mlUpzcR4zrZhzpvcyy+ExjCOUdF62ogFAJKI0MoazWkTcljTpRBKuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-11 12:16:43 [+0900], Harry Yoo wrote:
> > However, in the !CONFIG_HAVE_CMPXCHG_LOCAL case, mod_node_page_state()
> > still calls local_irq_save(). Is this feasible in the PREEMPT_RT kernel?
> 
> Hmm I was going to say it's necessary, but AFAICT we don't allocate
> or free memory in hardirq context on PREEMPT_RT (that's the policy)
> and so I'd say it's not necessary to disable IRQs.
> 
> Sounds like we still want to disable IRQs only on !PREEMPT_RT on
> such architectures?
> 
> Not sure how seriously do PREEMPT_RT folks care about architectures
> without HAVE_CMPXCHG_LOCAL. (riscv and loongarch have ARCH_SUPPORTS_RT
> but doesn't have HAVE_CMPXCHG_LOCAL).

We take things seriously and you shouldn't make assumption based on
implementation. Either the API can be used as such or not.
In case of mod_node_page_state(), the non-IRQ off version
(__mod_node_page_state()) has a preempt_disable_nested() to ensure
atomic update on PREEMPT_RT without disabling interrupts.

Sebastian

