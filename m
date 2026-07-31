Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF89C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0F976B008A; Fri, 31 Jul 2026 14:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99AF6B0095; Fri, 31 Jul 2026 14:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64276B00A6; Fri, 31 Jul 2026 14:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2B16B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:08:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00C191A0550
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:08:08 +0000 (UTC)
X-FDA: 85049855856.01.30D43EA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 608072000F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:08:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=P31RC6J7;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785521287;
	b=j8rmxy0r8rEBrHQJmWBauW5PfBz8dyiyopp+2YDxbYMaGs/POISh2pAtzltsOGMhPjVOHy
	lTW6JY4PKseqmdtVB5kJGaQ8zG+YYlXCPzFISOuFlXp8++J366FanShxaCTMkqV8OJ7xCV
	P97vjIIco8JYsm8M8o+cB4/3SSOQ5aU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=P31RC6J7;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785521287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSu7HlraTrtCjx5JsJFL6p1xgqkSTFzQNybrZjtENdc=;
	b=sN8KHAbnBDc2TgUFp+ttxkgMuWsmFb3pboLjoYFa/GwNqOaeZNEtus0GlpPsWrY2GlCyMa
	LbyyvKWUHFjz3ONcw/9DH38JINuU81gq7UiFpEOXc1YxjcYPF/7LTElt9HPj1PNSEquYjr
	QIMk+8BXPS5plD66q4PVLRwSb7xmT3Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PSu7HlraTrtCjx5JsJFL6p1xgqkSTFzQNybrZjtENdc=; b=P31RC6J7kHO3GR0UKFbGSYsbUI
	KoU5Kjp6bTger6m+z79NQzGE4X+mbYGwyU3REKwoV6LYeM4ud4wLJYZQ1q19g4S5+8m6GAbRjaRVp
	o+PGXI4XbT9ydbNe1fk9+Wl04OJ8orkrYxfAWJJTrMCAQQ2+TfeNEcleEQlUJOCe7ph2F6loRNfgD
	/ct9qRrj40vo/9p0eBkrr9KZwvYqtRL1jLFi3B8O3ASt9WnUS0cHF4DRAX07Ya8EErl0XUdUoiAsa
	uUkniItM9pHsGIUlCetCMzDCcwcWN0L5xtTwdOEoNhef8TAmQdyFESmIEoT00Lt9ov/9DzZ5flr+Z
	fM+Wkk4g==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpre9-00ACx0-0B;
	Fri, 31 Jul 2026 18:07:49 +0000
Date: Fri, 31 Jul 2026 11:07:44 -0700
From: Breno Leitao <leitao@debian.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: rostedt@goodmis.org, pjaroszynski@nvidia.com, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, puranjay@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	kernel-team@meta.com, dcostantino@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <amzjjjZrseO-jMJL@gmail.com>
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
 <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
 <5b83b0a0-708a-458a-bdbd-41c6d4610349@paulmck-laptop>
 <amCT9QEgJRsLIb_y@gmail.com>
 <ffa5d8d2-1157-4a30-995c-ddae3566e3a4@paulmck-laptop>
 <amM1xUOhcpGpqIpe@gmail.com>
 <39c90e82-f785-4b47-9571-dd4b1339d685@paulmck-laptop>
 <amdWVTs0WKOxguxP@gmail.com>
 <amtZNwxZ3gpOsPER@gmail.com>
 <743bf971-b4aa-416b-b72b-88b538be727a@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <743bf971-b4aa-416b-b72b-88b538be727a@paulmck-laptop>
X-Debian-User: leitao
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 608072000F
X-Stat-Signature: 938z8zewy4phuo3rhjawchdk7mqyjgkz
X-Rspam-User: 
X-HE-Tag: 1785521287-897635
X-HE-Meta: U2FsdGVkX1+5gH+mMsWlfbk8HbZgQKmTkXltu1sZzcB2D9l/ClAhB3Ilq3rrytiULLI/L8w2YyJhhRKcDRzM+ZD2ZCLgcdYKxj2MYrOO2Wq2sMOCqmCjHo2G5NqC5/TBpBXYJATjyXVSjBZNyc3DWBBMVd2jwnvD3r/nmt44LxfT+S1BuXrZRIbskst717Ni2cq2oUkZSKO5EBkslTlQ+bQ/3HfxoTKpQgTcomKSHCdRAaeQKeF9GT3LoNqle+yZl/ds0RXgf6/Whyuj6DqvxHr4vcw2oo/7Ll/t3TJq/nucrieB3dgP0V8ogmMBl4xPRIisIf8D8qdG0egGi4T6iz6PVrgdWa85QhbHZ2TNiSnyRfP3acQHur5Ve+oh1p1MyDWfyBlNt4NNXKOyOHPxXyyOjPPJyuaT4Z9SnhloOys93x7snL/XnHBO/IF4+8IpPnmagLcKY+egitPD5do74jUWeIKuOB8RQr3vPobfCWM3707vOaG4P7dKeJjHLBwcRaqGfGhS2mA9+laTF7W1IoJFuuCcUDVXETQIsvWE0g6KkrnBv7MVoyAx1RaGbpWD+6FuYF3Z/1TmyIVD53b/vFY5G/AZwTqNu2XNoE44YYx/IouU/K+GqDSYWS8s798rhdfQTeNBs/aOeN5fc0RylMJdK/WFKaXF50gwEBmdiMtqU00Mkn+P5j3WDFA7vOPzZ3KhtucqJ4tkz4NvlfaNlRqaaRXL9rRhKm76eXqPLnORkWCEOdo5YlJ0WifJ4tr9gtRoslN1zpLC15CCPL9yAtQ0v42IRa5BJNBnYNMn4dQHHvfgpdvrUg0HmNB+89ZlRvOUYxLv7BZ98nqZJueBAWu2wWw146vDCn8usAYYkO1C+YWAGh20wA5IuEzPhwBaivfzZsbhjRzUwiGKa2vI3AYMcfZmv+WdAKVgaIMI0THvWuNQuh+SXfdLq36EnYlFX1F/WBBwPW1Dog18N1p
 DP9ceVm/
 rLEZFwTJpL4wxuI4fyWzsPnc5T+awdoooTvNgvNKVebKme7TIdRkvHwnEsUBAwlJpb5wwjdXghY6/++kkP+juCZFuyovfmab5EW+ny4hacSPSa4uDMGnobPHAI2as2uVDAJ5xmL/AIeqQ6ZdaH/CJXY2kRzGsgduJWOVXnkoccb/mab5C2I6qBmPGM9vodY97z9WZxnOrkgH6bpdStP7bf04A6yZyyIKpwy3UCTLUy80Bv22I5Dp9Czz4msVisLgdvSUS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 07:57:22AM -0700, Paul E. McKenney wrote:
> > I suppose we want two things:
> > 
> > 1) change cond_resched() with cond_resched_tasks_rcu_qs()
> > 2) Avoiding holding the ftrace lock while calling
> >    synchronize_rcu_tasks()? It can take up to 10 minutes on a healthy
> >    system to be releasd, right?
> 
> I do very much like both of those options.  ;-)
> 
> If #2 is impossible, would it make sense to have a mutex_lock_idle() or
> similar in order to sanctify the lock synchronize_rcu_tasks() latencies?

How would mutex_lock_idle() differ from a regular mutex_lock() when
sanctifying synchronize_rcu_tasks() latencies?

