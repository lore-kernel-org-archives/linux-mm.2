Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E53CF10854B3
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 22:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5702F6B0089; Sat, 14 Mar 2026 18:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546C06B008A; Sat, 14 Mar 2026 18:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 453366B008C; Sat, 14 Mar 2026 18:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 369C96B0089
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 18:32:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C8C301B8CFA
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 22:32:06 +0000 (UTC)
X-FDA: 84546117852.07.C4FAB21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2B888120004
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 22:32:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=clXEltE4;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773527525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W++djRxDoKo1QubUSnYfFq7DlvOv1yn2EBPJdIh2cyo=;
	b=FmVrmVIxrXG0JRvJiOB3E97Vo+NL+gddbNdjhD7Kh3llSD9ZLqDAYStyT2u3QFdjAq4S6s
	y4VgEtaH+Aqtx+DPUt07swCN/V5x8Z1RF3UusIa+6vFtqGx6KFWfult/DrzUxauEIT4w2G
	qNeREhqAHhmb0aNHUmiCyC4/vB+9lfk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=clXEltE4;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773527525; a=rsa-sha256;
	cv=none;
	b=EHA4DsnWy2vjYI2Pz73mCZ8T3kZVMLs3kkUSZRO0tfe/lrtvyiQHPyTxtK8PFSiKFftAEL
	2G6v13LzI3+yPDZjuySqOpred9yIMgjAu6SzACT6qUgTTsWggaVe1PysK6M+svt8RLkHoQ
	b87W3dADf64VafVVhzZLUKDzFYoeCAk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 752D360121;
	Sat, 14 Mar 2026 22:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D109C116C6;
	Sat, 14 Mar 2026 22:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773527524;
	bh=W++djRxDoKo1QubUSnYfFq7DlvOv1yn2EBPJdIh2cyo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=clXEltE4Q0rwKPvvOPSyWcV9RNCNqITssDacHWIwHKGefUhuMdvFSkXKt6S77Yh/U
	 a6i3Cv0miEIWjdNvCVSnVmBCr3UhH5wx7vzeTf7T/3UUgSYw/QugWlEY1zubxP3eRI
	 QePmw0YkO5g8GrpqLwLUblNaC1KqosHMxStZaL3k=
Date: Sat, 14 Mar 2026 15:32:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri
 Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Jan Kara <jack@suse.cz>, Oleg Nesterov
 <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Andrei Vagin
 <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>, Alexander Mikhalitsyn
 <alexander@mihalicyn.com>, Adrian Reber <areber@redhat.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 0/4] pid_namespace: make init creation more flexible
Message-Id: <20260314153203.cfae7d3f420d2da050870f4d@linux-foundation.org>
In-Reply-To: <20260313111014.2068913-1-ptikhomirov@virtuozzo.com>
References: <20260313111014.2068913-1-ptikhomirov@virtuozzo.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2B888120004
X-Stat-Signature: c4ocefndqjwm3n7fstx9e6nhmqh3r6yt
X-Rspam-User: 
X-HE-Tag: 1773527524-46416
X-HE-Meta: U2FsdGVkX1/o5QtsirAKjLID7dRMNxWrYlhRfE8H1ZYMS+OjzNfx8Prlg0ZHG3m9l3znbliFMnm8GokSHmnPsVJblhycENA+wLDx+HSk8bb6YVZHJ9TEQt9XOIadEDIapmCyt9v3semrY8B8ZA6QJybvNYfDzqHr0jYfZUyFdxs3usjuFPjGgU6IQ0gWl3vLb0+6rKxokQm0W12xFGOx0L6Qw2olpmHi/6ClEqjikKB0yk9OTjRoFc1f7JUuOBCyVXEEpKn/OSlbcRuKNVfgkFOkovUV1KX0xZduPsqGpdtr8nMV+orRc1bXB2tkOoINO7KNPLbDC2b3nfFwOTprMVZ4EDMixK53CWUXavJIf29eX3RYFW9AS9+xRrM3Xqf3fIF0Pl0ztmxj4Z50ruxuBsM9aAyaMrzS09A2K8nEKamhQ83WJPU9Hoo+EHotCqp035X6Zzx0hYIjk0jEPd3KL/kfjnwnBg7YyO99SL6gg4ZvbN8bcT9pwxgiOX6pBozBuHDbY3wbvedj/OULlDSytvsXmrmwgcGBpvyngaZiKCC0Q8XqWU3LKBKgLxaCSxU4q7ptO776S1KXNwpRge8qfPI115bpboxH0wXwVOxQbPEbPNZ1AFa83WHIZmH4HMujOb1qEfYW5v4skCG7UDBO98z4VEmgx3VVS2Xrifx2AY7RlZpLqqc0H+3tFP9yPCtTITAPP56rX0BZbwx0+rIP1vIkqyxo22g6+wJbVoibjx1j7+tZE4P8fOs8FPs1iajJXYyWffoxYAONzMst3TzZg9NbwgCyeGoo6cN+vgLngVo5O4NGN9vVnoKjQZSb5n0ocYBDmOiOJqNvB3PtxzhFk1W9ptTXL+PmNkLIIuOGtAj5NcS7Q4UCAkD3/e+fFRl1bVCEGylQdV+qrrC5jJa1N3z2uB2AJGq1EDWDKvIcpQ7zeksaxleyBh8vCikGhWmnSK68OYDyrpToLbmq4mc
 6/PoHc0K
 P0vOiU5Vo4pBIRdaGn2Qwd42taMGbtd4z+G2Xr06zpxLUB4RqR9MM+8GhjAnq3Yv/IAmGdLbF/Jx4/wL0KNHfdTtaebGMqQmqtw+CypraCSqdxp6yzsVLnMVL/ky7Vm05djPllItBBVcmtXDkBb8CAauxCoL+VfgTEZNjiorAzivkDK4DAtLl7ZawrCON9pN7d23BkYox9Vw1kVI7pRBYRVoIHLTPwsIcs970bTlj8kWmGYcjVxOA9jRn5w6myriDEJjFfKmHMs7MFTGj0uFE77fFF/xkIZff/QfTY0RCankerxwlxFDYVdV0lVeV8gPNYhphCsTXPtYYmx90kFYkt8sjXGgWxGWoIAkVNEBEgy2KGvIeFk5I8qmKulfvb76DfC5YrLUn/3lbIe51Qe/uj8/jglaOmEKtT3gcRNkay0De5TV4yqsNB/svZsVoJwU7AsF+57t8mYI2gTvuVmoyQe9a4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 12:09:38 +0100 Pavel Tikhomirov <ptikhomirov@virtuozzo.com> wrote:

> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christian Brauner <brauner@kernel.org>,

Actually Christian is much more pid_namespacey than am I.

Christian, a MAINTAINERS record would be helpful?

