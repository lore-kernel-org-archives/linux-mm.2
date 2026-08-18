Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72835C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 22:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715F46B008A; Tue, 18 Aug 2026 18:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7146B008C; Tue, 18 Aug 2026 18:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DCC66B0092; Tue, 18 Aug 2026 18:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37CAD6B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:19:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25FDCA22BA
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:19:19 +0000 (UTC)
X-FDA: 85115807238.23.15FD05F
Received: from mta0.migadu.com (out-152.mta0.migadu.com [91.218.175.152])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0E5D3120002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:19:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZcC2HYW1;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.152 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787091557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0/PYYZf0B0jnumyDzc2/R+5rLnnYPkDCDmUNUk2rS0=;
	b=ur7LPo6a7GRCEhpMNLMj0KD1lEAOOhVjvmKOAsuZefoe/H42jnImv1DR7lNHvtIUXH/gT3
	flG/nlDmU2Uq6t+FmiX3SxXIObzTp7nWMS+lRImVuRCp3cDE7aZfuhcyjz2lF/FQlf7jyt
	r7Y1BtsU18DWEcNf8/JsBVSHSaFmhB8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787091557;
	b=D2hAI+ZKyfhBlmiUpi6naJuHiaQjrFeXMYJgXZKS4qNQEDvI/IizBWltSwXgTZvArRXz07
	cU03IsFPYyDfCbSINatrA8k2EqwJiZOL/9jvdGRa+fVRsJEPkHrfjFBFwN7cR8s5LqpS2O
	/r5zYpwXvrNQ1vq8HhWHDYcpuiCu3fw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZcC2HYW1;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.152 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=L+2aeKPcHyJYbAXWC/tMY7CVwT8jSrUG9YyRuMei8kI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787091555; v=1; x=1787696355;
 b=ZcC2HYW1Q2r4Yt9tTGLc7EQ6daUehB9OD2wdntA4wLM5jOseAbRS0tHl4cW3908ZkzBFQQBF
 0zEYd4X5ijKRXUBYdIizpv/8dp2ZvKR28x1HHAp/x8ZF36RLYHuW1hXXUOUA4li18LxQkawl1Gp
 43mja065yZPX478kxZzuwTo8=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 40f4e78686b61702;
	Tue, 18 Aug 2026 22:19:05 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	mhocko@suse.com,
	akpm@linux-foundation.org
Cc: leon.hwang@linux.dev,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
Date: Wed, 19 Aug 2026 06:18:58 +0800
Message-Id: <20260818221858.86452-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260818115526.654d7311366b66cd031c67e4@linux-foundation.org>
References: <20260818115526.654d7311366b66cd031c67e4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1ih9rn6dnxgmobsam5653ny4hrzixwk6
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0E5D3120002
X-HE-Tag: 1787091556-166333
X-HE-Meta: U2FsdGVkX1+Fgs9T3E+PY6lFqeu9rA5yNyqL1YYttEd6wm7fpPD33nIOa2B1nvzaqu05Ef5zhp3PWJRnB7PBQkem1+gnC4OnxlZWBND5CWYV1GhWSv5yh7WZnOrOf9QBqaIDDdHgzudIKF3Xa8mVHb7bpfXYR0MMjF09m2yk6jv+mW88sLAxWvFzx1C7/A/fXexCI4YAHN9hQn1e3TRAMiAbtWxSFrubFL+xAYJDgUSsFI67wK84/UcwGI0UZ08e8xxJgizpd6/DUZCEcrw6Uu0p1OXJwKEpPvWXqmLkwT1XQJzNfNWlCVrx1V3DK98WMtqkJxIdh3ADD77+BTVIY4KST4hfQAv+v6IhqJw9x/l39IloQvf4oEYinFYoEF9ce2zTdIVMd/C7mP2k+7JDfBxPYW5bPd5B470jSm2VA8n3hmkljfJ3PM9ssNIK9g4xGXtdcLQ8wkrow+DCwEejOzJnogSV90G9TkRPZv5pHuKjlXZcZnf3tggTiTZZ1VEaBjFZVATQgPTTwtpX6aTrWnxuk2zuJDUVfn0ABszIO8zaNH8TTKwdmfDvE/qFE9nVpLvpezBH8ZoVQNtmFKjkXMdCHCA1B3mi6sgiDx1H9racvqjzhUb5DgNZst29qIOGY6RnIdWx0ULI2aBzkLXoYYfZOP2wkNsOKBzv7ozQyNrXP7wVIFnxi2JoQTBSUbJYC8/mAwvlxGFA6kr+HKwSqDcSfQegYUvWnPyjyicLS7P5tix38P6SXHUR2OKfaTYnOffxWcWvkPMWogvzK1zZfOD+xr/k/Wkevi3V3hview5FR4YDTrJobkZxnNl8K3WhTqgakvk3zNvkmbaC9zCA1gijuixR//zCHMR09KKnEpQt7MKrEXBY15m6hGbJNqROR3SIah3BrQ6/M8SB3Fj5paeCfjtg+0KOUMb4Fpwu/TdXJhP+qZx5Y3u0BhUzr9HfuzDwVUfX/pziPijSB5N
 PPAYv6W1
 Yw38beqZoKthuJe36/2GmwUd/DyETQ8JlRX6k5TZ3ghct+N6BS0Trd2XGz9GkIJXTwqxBN+3Mia+CM/fyt+PQOxSkfWLWINSGjfCmROwDOgqk3ExUrUW71qv3hTE+gQA3hFqpeW7WhBpm0nIntXjgUI47zkCSiV4o9jr5eqpbqcvLIPRxVB1gGDiDAfWioCcwvjQ5cQgDJfZzHroGBm0oIZUz7uP+yZK/PjrlMABjvtzyTmgBS01gLHzUIeyh1F10pOJtRDCPKRSK5KylIC12Qf4JTisbTjcpAjArODTivpG+1794oyDtF2cjvw/+NlcO6T1eH+yDRgo4G9lzzUdnnRxt+ShnuxHAfFRv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Michal

On Tue, Aug 18, 2026 at 11:55:26AM -0700, Andrew Morton wrote:
>On Tue, 18 Aug 2026 20:21:37 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
>
>> >>>  		if (!ptep) {
>> >>>  			address |= last_addr_mask;
>> >>
>> >> As Michal just put it:
>> >>
>> >> "PREEMPT_NONE is effectivelly dead and most cond_resched will/should be
>> >> removed. Is there any reason why you are not using full preemption when
>> >> requiring low latencies?"
>> >>
>> >> https://lore.kernel.org/r/aoRnUxUlgf_kRlm8@tiehlicka

Ah, I missed that PREEMPT_LAZY is now the default on major archs and
PREEMPT_NONE is effectively gone there ...

>> > 
>> > That's pretty bad behavior and we might want to fix it in earlier
>> > kernels.  Is PREEMPT_NONE effectively dead in 6.18.x and its
>> > existing users?
>> > 
>> > If yes, we do want to fix older kernels then we should merge this.
>> > 
>> 
>> Okay, but that would be stable-only fixes?
>
>Not understanding.
>
>Maybe you refer to adding a patch to -stable but not to -linus?  That's
>against the -stable rules
>(Documentation/process/stable-kernel-rules.rst).

Since cond_resched() is a scheduling no-op under LAZY/FULL anyway (only
the __might_resched() debug check remains), why not take this upstream
with Cc: stable?

Mainline scheduling stays unchanged, and stable can pick it up for old
PREEMPT_NONE kernels. wdyt?

Thanks, Lance

