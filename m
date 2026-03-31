Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F7DFF60F7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C448E6B009E; Tue, 31 Mar 2026 05:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BA46B009F; Tue, 31 Mar 2026 05:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32C56B00A0; Tue, 31 Mar 2026 05:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3E946B009E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:40:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BCB713C10A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:40:37 +0000 (UTC)
X-FDA: 84605863314.15.1F99575
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id AF4FE18000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:40:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vi8vFZls;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774950035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQBRyg58p4LJKQTOIVHHfqxB1NELYk7tvl/qkSVtPgY=;
	b=rIFGfRyxZ5rhKoJEnxhE+de8L8JFcbjiXmVWSltLFnZ4Zg1mSY2a0QuFiq/AvXCLEtVgyi
	6x5sG+vCcX3Ijyk88bu5M6FR0nZlmS2vbRCOm0/Aw6u6OGsYfy7HpiqVjcs7FIRUjxKO7L
	OccbGTe5YAwxOugGp+a4ObGqy8l/DGM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vi8vFZls;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774950035; a=rsa-sha256;
	cv=none;
	b=zwOg2GbpD+CUOVgVtl7Ay4tW+g+O3Hj+FrF0CUHDbI9wC5R5UpxsPqkLTAAviVKZJVl5qi
	869yv9n1FJ/yxKPm4bDI7H5Wv4JNryDTujE47Be5K2uPbYcDid8LuApOFUBlmprio8S8PA
	28Qr4NN5//MKPOe5ioOE/yisnmoagIQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C77A94359D;
	Tue, 31 Mar 2026 09:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C4AC19423;
	Tue, 31 Mar 2026 09:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774950034;
	bh=uJMOWgINMXub8AP/Kf/qJSBe/DsTYp4xy6LyAUAYweU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vi8vFZlsgoCOH/wPS5qHFh+9FlxjtYdO3E6n4rykwKM/RFhjQSAm2r0FAcCfmxanX
	 8cDLuK9RMpqSLWUMKTYfvECTFdHSJ0adVPlDrHbPx18NGRCvaHyN65bWIGcLnoIfVY
	 0C4giDsiuFPLuJ/vb4OkMsYv4rOxn15A8xHyWPVgoneACXn7syXg2Wm1YWElxFnNSW
	 8lxDHaY7Q9beZxlUPgtPs67a4ginIchALCbX8EkYz6uBIYr3k805VD1JadWExZQR9B
	 obrhXR5VgZKWF1oYiRiT1wHxL/MTXg+JqgNaWWaTwUnQM3/bAnX3LoJQPWCzmCJjEj
	 oCogtt1sZFE1w==
Date: Tue, 31 Mar 2026 11:40:32 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 09/15] mm/compaction: Support dynamic housekeeping mask
 updates for kcompactd
Message-ID: <acuWkL9QHEUG7Olp@pavilion.home>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
 <20260325-dhei-v12-final-v1-9-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260325-dhei-v12-final-v1-9-919cca23cadf@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: AF4FE18000D
X-Stat-Signature: udebuk7e1wuy15t9c83des5bktfbbg1m
X-Rspamd-Server: rspam06
X-HE-Tag: 1774950035-382946
X-HE-Meta: U2FsdGVkX18wNNc+LpE8lEVNXj+GCyvU//hMpLVWp0fqgEMQSpiWNY4g1rytR4tEdZbwaoKm2gXWcJwGKjJX5ZukH65n9YfpEPRaIB2W37c/mcK48TGgttGdye4hoQoyIgxcFJKpMLzycVOwMku1yicoxp0enF37aNIqbKYMqYu7XRXFYIWuweDYla9k3Ea2VJlwQJLuasN5Ky+dhFyPwEmktUGbj/1CJCjTu6wixmRNiCwPfkxPJg888R59omQ2xvTRLMGRpqfZs0ZInwNKK42QPdYlr1s8/TNDViQ4J38j8W3A4vhEYLeIEJHMX4tZAz8qXln0H0JOzlX78U96CTh/ZDkEdqriXYe5cillh/Q+PFyLUpZJhD0JffFyzyvq8nTSiJ4+JFm10tyU+mdMhUQ3fPYFUJDeu43nQ+a1j/9zsjKb2KKQhWSWjGKO+PuAL0UM/d4wPFx1HjPLso2PWtoXV65QsIQSOeZ0eTsgZPj2mlgskzhZ4GIXW78Pv3GArUHyBnlwd+DY+T+ZS4nVCRLC6vu6uVHFATuDzbRI+gI9DaJNIhLynKONg1BtGHNphsJmIzK2J2xIB4+BzebUhaRKfvUm4u2abdAG6Kea8cVtpcg3KtFS3gU5KccNhPHjYCan8zzvRWCPjtsV2LQTt86UgzgV8R4kTxkcMsKRdIDQalG1U00y1HEPkV1bKnbFb0J6bWrY80k1ySiekWjkUl+K73xledbLR/Hb0PEmjm04pEmQbdeKObyIFD3kWqGq1NI4Dd+Hd+sDnpcz74LbFtbzMvTli/UXDg9PfbMFW1PwEKdtmCp3SdqKAd9p6gJCSD12pLH4bOnr9l7Fm6vsnc/Yy8M1p+3Pdab8mafbiTJtuQOngfHDVwOvK+1ZfEZm8B0M1IauKm+rREshk+YD5w6e67r00GJf0Sc+kIOyoCxj3YNVhPeh4oBpLhDXrOIsJXBIWYmY96Pfml9Ll2W
 Z1v3bWFn
 He2GFn+cTSSp81VeTMflHXjx5KFu8RgPzoDPvTVAooz2IXzFgpj7VE4uzKuFj5r7KPvExMTysqnxnTyuJfct8S4EYr5tobLJNl6ZWr4JtJVHUToz/rmBcxf0Dp+F1oAo/Un66v04Q9xVvQhZNbhx8wznIxV1SCnRs+OEwrDAjFU/EEZzG3YBwtGSlE85sVKQzjLEHsIuK+o9VwNxwPCvMqTHP4jf7Gm5y75O8lRtS5ymKIl3muEUHyzXFaWCJdJjlULeeVSh9QFgb7nSFETQY9+M643CBLdGS8Agh6RD2sACvok3/6nqhC60okQ1OoiMJmxqJJYNvCy2GBOOHZqIIJY2x9ySh7y4RkMtCTfyy7tdRBaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, Mar 25, 2026 at 05:09:40PM +0800, Qiliang Yuan a écrit :
> The kcompactd threads are affined to housekeeping CPUs (HK_TYPE_DOMAIN)
> at boot to avoid interference with isolated workloads. Currently,
> these threads do not migrate when the housekeeping boundaries are
> reconfigured at runtime.
> 
> Implement a housekeeping notifier to synchronize kcompactd affinity.
> 
> This ensures that background compaction threads honor the dynamic
> isolation boundaries configured via the DHEI sysfs interface.
> 
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>

Unbound kthreads are now handled by HK_TYPE_DOMAIN dynamically.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

