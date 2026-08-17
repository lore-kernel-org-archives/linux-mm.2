Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50964C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3226B00D4; Mon, 17 Aug 2026 09:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA596B00E6; Mon, 17 Aug 2026 09:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6746B00EA; Mon, 17 Aug 2026 09:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D74C6B00D4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:29:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BCE54160678
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:29:23 +0000 (UTC)
X-FDA: 85110843006.23.94848B6
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id D2E82180005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:29:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Ye42Xwks;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786973361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UnfYmqxVfrOcWeieqowIf9SlkMC6J9el3UG+ajVf3ts=;
	b=ZvjphoTE6dnx3lijvLXj/KcioPNX3Hvkc9SK/0OtTlID4QnfRhaVj0OdWeEwF1CGzZR0CI
	redmQYJLqv3VKSeCOgzDNeaA9xdDJOVrZX85lW3RWn+HWaTzBCd6vQX/3BnsdtheyDn1FT
	tQTJXaGe9hKO9JVf3Xlo4sDaqdD6p4A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Ye42Xwks;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786973361;
	b=RKgiKrTya11dqlYFTqa3Jd05o61JDZ7qUmPjQnFQHjjyjS4r35azztrb1sF8ASKDB7E5j4
	QEqONY7jVLFit/fWpE+pp8mySIhz6ps31NFFRUKlpyRIZoO9liCYyExNEm4FVl/i4/xBfH
	uE06hOBgMKZKhWL3NQrE9aU38ctRXd8=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47fe89fb333so2068443f8f.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786973360; x=1787578160; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UnfYmqxVfrOcWeieqowIf9SlkMC6J9el3UG+ajVf3ts=;
        b=Ye42Xwks65/N482JERuySg2TsAxjfg2imi02aGT4petNUQ0thKHh8XJxtPFCljKP/w
         dZJDRxlCRwzdWlk/h85AzhIB3qhtUn1PT27b0QAFf3WaK3lh8dDI6ZsiMr2uAxGthNU4
         Jp+i2nqt4aAacLPUBjpElMt6oLF9kCainadF62ycp6A2IBaxpHzhLyndqIDRFZgmfRW0
         z5+LIFxidfAQicTO8tjCvVfLjHftxx5caa7oeO9tfdsl443VYdhXIBMuvcWVeqH9nNJT
         By1QMJeWUwG6sc9LyVHhK7RI2WBuvl6fJuUr//68kbBUNSkka7d+AziCS2IfLxBuXYff
         H0Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786973360; x=1787578160;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UnfYmqxVfrOcWeieqowIf9SlkMC6J9el3UG+ajVf3ts=;
        b=H9YsWesfd2A4lx/qhRMus56zAyYMECEZExlvq/5bT8STOjH5EiItr5tKeWKd0fcK7Z
         xyIXktRc4r6N+fE74GcRI/scUCrLLmc/VIOKQ5XY1+vh5K3PMVuCCB9f5RfM/oriT81K
         RivUD7GOpRNPl55ogkYSYlH6QCbZ9k8lghpocOdzxQMK1XZvy1bTQGfrCsGyR7TaeYcT
         S0SPh0MCNlwV7/NXeKuOCI7tv1chqtwJOx0wMxJNxlR9fnB4K0Mcd80fSgj+Tslqkcub
         mEgu9hcZ72PIBOkmEgB1Z7HsuhGcBn1nvjzATXbJ4VPN6APE/j6Uv5KTz9eooPmAd9wr
         g5Dg==
X-Forwarded-Encrypted: i=1; AHgh+RoKSD5dDGqHp/lYxpAjwmYzmmOhj5msORInQyF6kzIkAmHlmz4O6m2C78O96LZv3ckglxQFUKwTIw==@kvack.org
X-Gm-Message-State: AOJu0Yy+73qbgkUYTrczQLQnXRwis+Lv8ULSi/eY9b7aZGvgJHUR6yp9
	+Jk3qCCp5ohftqKOxDJaBLZRsd0EoW/BWL/BPS5nficjxYvSGVCG69Asc52teR67/J0=
X-Gm-Gg: AR+sD10Qg5m1s91xo5hT8fo05tsAIExXy8X8A29NeQq36fndEt2983l6G8GGygjUE2V
	aF8Tk2A523d2BP5wuo5hAWZwnouGXaTZ9iNdBID7gzC/uvCHtEcjPMz/qDl9/OyIXXQwxKKuJEf
	R8CgqBt65bFVb1PceW0yYWeiFy8ZHDXVvqAtLuKRqY2YusR5g4CdLQCbKE7PdQObOtjOmgP+Oul
	8CgLjnpc7rZTC1qAOyMioGtEnJLkAo6C/0k7wu5NbxeoyCOWugxeZISDHeabza2GqmYWlRX0BiV
	BVnrVoH5AyMoMJUtXN1oDuvpYHqKM00Qje0Rb7lraEZiVve+lKD/Fj6hVLkhqWfbjHA24CcEfqA
	eyTxrHbqni7G/lTE+eyObh3gg5OfhtGLOzGcd40zO/O3MjKl8eWQpQDp2S5aFP9sOuckjcvEsPo
	/ylH0tHBnarGUGOvXCG58pstdSKEIHVIQPTEVT+/bJChFVkn6mAVJrwClrf5w+XlnKoyCD9Es=
X-Received: by 2002:adf:f84f:0:b0:47f:eb22:4d9a with SMTP id ffacd0b85a97d-482a90e80aamr58867f8f.22.1786973360523;
        Mon, 17 Aug 2026 06:29:20 -0700 (PDT)
Received: from localhost (109-81-86-48.rct.o2.cz. [109.81.86.48])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5b77f41sm3794755f8f.27.2026.08.17.06.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 06:29:20 -0700 (PDT)
Date: Mon, 17 Aug 2026 15:29:19 +0200
From: Michal Hocko <mhocko@suse.com>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, audra@redhat.com, bingfangguo@tencent.com,
	cgroups@vger.kernel.org, hannes@cmpxchg.org,
	joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, muchun.song@linux.dev, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, zhuhui@kylinos.cn
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
Message-ID: <aoMMr6kEX7pW1dSF@tiehlicka>
References: <aoLGzZHS8kj53-ey@tiehlicka>
 <20260817131221.44761-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817131221.44761-1-husong@kylinos.cn>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D2E82180005
X-Stat-Signature: ydc7o3ngis98kw1zrnqw6gj994aj8rcb
X-Rspam-User: 
X-HE-Tag: 1786973361-913941
X-HE-Meta: U2FsdGVkX19WwXxQxNCEdPmSCo9B6p37rdQuvsyRJ0gVb5sqnjPVImfGWey0W9hboRY5ZqcHhKX46NNPujGtZM//NPdWd/Tu/kVBmp7OF1B8s8jYsNVJuYrzRy5THan7fep8bhI1NR7JcY5Xv1tnskdR6YvSF4f5gPnYyhwavV1HJo5GrYs7wD8a8LwJ6nVtSifRauDG7lS903VF0D7UQd8k/blZ9A5k2UmjCNAGf6s4qg4/QBfFJpSu4YRyRt3ZICjy8v+kX4ErUvZyWfmBaIzvblj21t46RUGaXF4mJZjyE/usw5HxE7n/t4euQgyzu3gh3Jcu97cQy+i0NWZbNrof/5Oor8NKxE35I7stF14weUFnkWgOLoLXf0cnOBDAtnaxQiQUA47Qm/6z1SDM/jTVYQGtQp3yDEI7G3vAq1cy2j32lYDmcRYq8Jr/NVeQBZtSSMdeqRH1XLPyBj96h5UExXtHkegwSmm/cYwGr+T5nDMDHf3JvGIPFPqcv/dJmHY6ED9+EWlbE9O3YuaFt26Aio8rGvIDDZlMR2ZZF9Of3kTcj6GfvNlmSK/duRA9JVkcvTsNiCB4ptYqNZY30Qnb9PaQUX2QdXUfLOFM4aCx8B0b/x4pQDxJqdIaSdgtS48Zg398TxJf0Jxrqxq51BTXq3XWmluoDSNTuR5C7dpc/NJZH7VVtlSqsFgFXU+QGVh+eqd+wxZSrzPMTitSBXqFKkUDUVge/6pJg2G3BXXQ0Qz/kR2Im7eoxcwZQdG5iaE0D+/0zmAVYcqoh2Za4ztQK5HCfNRpcyeXmVIsh0G4XUSCYM/qkUZdxIZINWdy7BCvfA0zRDhNUKREjGVpiXCZ33jU5t/WZE7AsiEv4bqc8tlZESvGERg9qKnjV1l7SmWSI8ZHPSAmwwDoS9xbBOL3UN5kDxtGFKZU9XHFntBW4K0UQ83j7NRGfICsJAx1o7qwg9sY0n/COkth/tg
 ULflvsrp
 BH2TWSBtL2mhsAfxCzohuj0ObJHHpiQIHrLoVAAIb/5XTKsoaQsyIbHXAu5AlY/vkmNAlxQaBVKitoINknn7zfJ34eG8Q0OcRqnQmgil/37Yiynjz1QGCkjQyaMWyLV9y9C9IV1hrQBcWs/CH81pLVOp5dgEe4WlNdnKhY7tdgSN/WVMMm5hLVcTlgPsTEdUlwe4KnibFhIaxN0arxiu6ZpWFmN31xRGC4YUnfCPQZaRKE/oEU5wKmsWjIySR29RCm3yXkRJpRn9GhxoIW6vLvbnKk7CXfjTUhzDUFuaa832nI0j7NrqDU0VE+P90aN7hUgxM9wvjybFB0dAg6mIOZUd/U1x8Bnw+kV2Tj5syR4qBHXSfphDuiLstekt2T+6y2cDKoMfRHQ9Np11V85MA0uP0ehYzL8KJngA1G8S4o07x18bzCKypofdTBiaE/WhrTfGGHM+iPeVpHS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 17-08-26 21:12:21, Song Hu wrote:
> On Mon 17-08-26, Michal Hocko wrote:
> > Is there any specific reason why the memcg stays in the cache slot
> > without any pages?
> 
> consume_stock() doesn't release the slot when nr_pages hits zero.  It
> is kept for the next charge of the same task and only gets displaced
> by a charge under a different memcg or by CPU hotplug.  The problem is
> that the offlining drain skips empty slots, so the css reference they
> hold is never dropped unless something unrelated displaces them.

This doesn't answer my question, really, does it? Is there any good
reason for this implementation? Why do we need to drop references
remotely when we can do so when the last cached charge is consumed?

-- 
Michal Hocko
SUSE Labs

