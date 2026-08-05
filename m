Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 246D6C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11BD56B007B; Wed,  5 Aug 2026 15:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F39A6B0088; Wed,  5 Aug 2026 15:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009226B0092; Wed,  5 Aug 2026 15:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB8EC6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:07:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5750812058B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:07:17 +0000 (UTC)
X-FDA: 85068148914.21.D6E0D28
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5A13C2000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:07:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M60DEs3g;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785956835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bf4C1433YPmcAdrQ6UIsaaRwbBD1WIAriLgZrgKPaRQ=;
	b=LVTXAD77BxaWF9+8hiTmWoRbdyJe06OA4En/vDbvGIZsjLrXzDYMDDpEFDul1JojPDle/5
	Jevyum11ZD7opLGly7i9JGytl4uJYaGlnPTb380qLl8Hjl6l0laCCjwcUAKIzxzx+BAAlx
	h7oumyzc6ivBRBr1FVh2a4d2GPZkcds=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785956835;
	b=Th9QHAzLuSuSynZB7OZo6uD9V950lLZqxR1bmtcZPpUaHlu/7mjIc13oitXPStlN9wyK62
	1MaRT4a+T3ruw2Sf+cd728BuPuTWH0yLWcYLE+v6mDJnLH3gfaEq845iIJc5ufBvQV9Skt
	8ShbUB9qtGm5fyLGL9PwjU4pOc1Jk20=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M60DEs3g;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 5 Aug 2026 12:07:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785956831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bf4C1433YPmcAdrQ6UIsaaRwbBD1WIAriLgZrgKPaRQ=;
	b=M60DEs3goINApcTnMMkH7P4umo5bL3SnRkEtbYYGALGh+oH0lBupYZjDycgk/IagkfGepL
	ftVvRczp/9J8MF3oM8m9/oa3oKoX0fEXA0ad0EZq1tin8wO43dhv8WWnvZxLvPDKrxDYmL
	TgKPs2JsYyQEOnIavmRToQ9s14v9tjg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, qi.zheng@linux.dev, 
	kasong@tencent.com, baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, cgroups@vger.kernel.org, 
	regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mm/memcg: folio/lruvec mismatch after cgroup
 offline: lru_size underflow and list_del corruption (7.1)
Message-ID: <anOHDekdEne06P97@linux.dev>
References: <anMmd1ADrDVwMO6v@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anMmd1ADrDVwMO6v@work>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5A13C2000A
X-Stat-Signature: 56d9pwe6tiuj9nca97hbxy4koxmw1d45
X-Rspam-User: 
X-HE-Tag: 1785956835-607031
X-HE-Meta: U2FsdGVkX18y5weR7MpZrQk9hOwVkW1v07a5t05csBDIZyrpbCR7qYDsnAVzjCT1rB/954jm3e6ceIVucAqAQN1fsibpEe4FXJorWjdOemxMB19vgxBxkHQQyv3BEWb5SQ+X09OXbKgEj8SUfwwcOOgykuhqadcAIFKHqs1bca0gVKQSPkg32TwoP6STFC+bzP4v2dI0EBLa6GFDitCS6Unr/3xY5pGXUQeoLaDU0F/F1Ezo+cn3ZXXGIzFDOstpoLpjbWJ91ds7vB0+1sO3irZeb8tAMSNnwf857C8bcMDRkX20947e0pLbfv7QtSUL6+g+Ab+0ZDP8CfKnVIAKTI9vx46uzpSxyfzf61BUjysLQ21w5Km85WkhZGwTHgCKJnOBKmf+gsHou6Zbrk+GcpSliMJAarxr2HwvcbScctJFlZVQSZ505VmjqTAWZfGEv1NEdX1PZqbuUgzuoKUC2564p1jYL9jeXr7QaWdzFeGaRZOm30Jz/W5VI2+w1Dm32e60esyaCgy1bnEZShf4Bpb0iXL+suhfebsjw/Hnc1PCduiEiREYraJr4T1/i8xrHhqKtvyWZdz67rowwDF8zcn8ejuf1ZlXh3Y5lcoPkEPuhVSUYe3f0kc7CGbbutKBO1GTBuDAHkJq25LkzyD2IVmIjhs1owrtSjefjels7SNbrTQzT5+GSjiUWr1VyWEZ7GYL1ExOWwcrXfC1wj1UgJafF0NNw/9i32YD7C2/t7q7xcnyVtAUNexDxlclvpIsGUMABl7d3C3bj4C8gmnCDcufaqDGA/CjhtT7vPRQhzokM6ICfq++ohJQInZw/MSlupVkaW65SXrVsLZ/5RzVUCWNTTLYMiqc3zl6FxMBXS2XUyJXX7Qsg9EOmljmK4DHrAIdiIPmG0djUN4RLY3GVcPhG4eCOuNfZ71l0bTBW5pMG0zX4OrE66Jdzd8nBDz4mYEQO4jqeM7qdH7gWpM
 qATD4/e7
 WkOBDqLDYc5fSHYD3KWh965S3h9JWsF2+hrWUx7ImvJ5UzIU2BFWZ4Rhyuez7qq+iorY6vHUnyb6W2Tro9EmdJv3j9JV7KPFrLFcAi/h/lpff97XNrFulyV7tg6l922+1Z3iyxR+dWVscvdqiQ/CJJ8mulXRCaGLdhmRqcC6EnEaI1KzRnf05ohtc5fKxi4ABOTeYFpYlaO0Vm47/rM9WWAmffTwnnz4FamV5fxYuDv6eR2wqQfOmzhkxMeja5gTov2i2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 02:03:03PM +0200, Karl Erik Hofseth wrote:
> Hi,
> 
> The following KASAN slab-use-after-free comes from a Fedora debug kernel
> build of 7.1.6 with de4660898b7a applied on top, provoked with the
> attached script. Further down are OOPSes generated by workloads in
> production on stock Fedora kernels. MGLRU on/off makes no difference.

Hi Karl,

Thanks a lot for the report and I think I understand the issue. We are not
handling the case of folio migration causing folio having objcg different
different from its node which breaks the assumption memcg_reparent_objcgs() have
for its locking lru of child and parent per-node LRUs.

Thanks for the reproducer and I was able to reproduce with inceased workers. I
will send out the fixes soon.

thanks,
Shakeel

