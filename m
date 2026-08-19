Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04373C5DF7D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 03:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60706B0096; Tue, 18 Aug 2026 23:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3436B0098; Tue, 18 Aug 2026 23:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2026B009B; Tue, 18 Aug 2026 23:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCB36B0096
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:16:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC393803C8
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:16:03 +0000 (UTC)
X-FDA: 85116555006.21.97CBEC6
Received: from mta0.migadu.com (out-232.mta0.migadu.com [91.218.175.232])
	by imf21.hostedemail.com (Postfix) with ESMTP id E06451C0007
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:16:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VeBYTpJK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.232 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787109362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ohHs8oYtJOw5ti1uvOp03JRMEgNNU6n6XMBkxO+jeM0=;
	b=7gnm8PguDZkOcEMK3wK4tC6TsnW4emApta1bZIgyq07bzPi3hob5P5uW1qsRnrvLsoBAv3
	CuD4E8Bg6mm18wGrYqSXNbUX4tldtCKetDW1Va2a8UMaG9I0fw5+K9mzWTkdlwNkzRWvzr
	0f2PtuE4D4M5rrOTLFM1nRjtDh/BJQY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VeBYTpJK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.232 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787109362;
	b=lXPhdjyM62okJ7WEl7C/b4yU+Q3q3hCtIpy13tHPam7Z1bpZCk2DCq59pY+ZKShgPd4MKS
	E60Q6sgixwXggEMxCzLDPclRsHWT5SjIko009XUrY0DP+yceZDy4JAqG/8KeXzrZb5K9iy
	CHKIMXJbtSZElmz5M6WuF3lxFobs7QE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5qF/vs72KBtna1aV3rs4NbQuGzDEr4hxwsxEq426ZqQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787109360; v=1; x=1787714160;
 b=VeBYTpJKXIx20O62DhA+jw+OtPFWz2TdY3wmC3NAB9KCKOq4Tqg4oVtvmbWjYhuU76RY3G+l
 oYxvfL9lPejeLq0KQ6v0yGLn2XUAW6MmiKkW5DdPyD23TAZj9c6fDxVEijJ4OY9n+nNwYLeFVSg
 w8zrIV0XOpA8ALq3aMa1KDp0=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.111.29] (223.70.160.239)
	by smtp.migadu.com with ESMTPS id bd93802a235b321d;
	Wed, 19 Aug 2026 03:16:00 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <9a92b4c9-ad33-492a-b206-2b0862585c64@linux.dev>
Date: Wed, 19 Aug 2026 11:15:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/oom_kill, proc: replace magic number 1000 with
 OOM_SCORE_ADJ_MAX
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liuye@kylinos.cn,
 mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev
References: <20260811033609.3992348-1-ye.liu@linux.dev>
 <20260818010433.65169-1-husong@kylinos.cn>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260818010433.65169-1-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: w3yn9uui7677dne3emgxbtppg3pg1d97
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E06451C0007
X-HE-Tag: 1787109361-409996
X-HE-Meta: U2FsdGVkX18wzpoJQiq7EK7acPHQVjRRors2eXhASPcBcG1AgeefjKRnIyX2VJh5uajOM02N3QX7NuNdJ6hgNRxWlId3gv0vvTglUlkOyZnt7JRU/HqfJeZ6s/+W+astK/ivc6lv9TeKb9lMyBzef4V8fYKalCNEOAQQYPkRrYrVaXTWaqHn6KpprTYjKjvk8L32+tZRlhbNxIqSAeKEVX0pz7x1YNfA42GL9eL3ZVDoD+W6rfBpps6ypyzduNPqdlczrNtf1TX9lTrp0VmBBusR3bMVcqq0OPXW7QMvClOtmStcAPALkWvqGTEvcp6Dwy127bGXp+4ptViWBsmur0MboMPh+C/8FD21miBE5JMD/4yAbNo+YZSgvlLRTHhXCu4Ctc4gAvFPPfi0I3vhYBPSU9RHxpjQcNrpjhcfTxFjMGI+VicOcq042jpaE11RpG2ttEjD5vQtUI0x5GMuETGgyQlGkM1+u0FrWDdFfsHwjkV4xMJemLOBr1+YwNppXR+peBs6GONrUgH85KhhPWBlVm7bfvrrr3TtAWy8YwkbyeabXNFED+T9AeUv8G4zKqt8kRSkz7ah30RKnak/36jUIaImh1JLQulR1ica3YCgDywZwTpLfm+SPEa08rQYHuq19vd6wLEUZfo8wnLqjHcdp1qxInjIcew6E0rWgttGU8SJTVxdSvUXYSuIMj17TxrkLP7KicGKDF0oVGkkOYo0YFAYJii45Wq1PpOyLkb6XXS0yOU7ZJgu/zd1/vH3LnPTOuZFVBHl2e9MEQaTjV8yZznyEu9QZJ9UGCHbCmm7NhZlSDwLjf5eV9pYgD04cBBt8DofnQ6Yti+xwIEX6smjU9GdcB+vtt5sw4FiOXZyNAbc/JIFUv9aLL9yZpI3Y29mM/RE7hIkRiDgTC7qHGRpmr9LEJJK6KOjbi4zAh/yqXA9n0FFsj0cvDaPbRUEp/YdMt/9U1SOk3uqrPj
 my5bWiQH
 BqVmJG/shgY3lcRNOHtuevZWIhFmA9nFLOqFyt53+TGGltvyGPCE/Q1bQXEitJLnLiFKvg98Rdi3XLXLIGhHPyVI53BR/oN1hsrK66UPCMDC/pVgt6QME1U8AyPZuHGOpHDMPh4yvg3NfvAYSkkLZ7Jn/5Wn/g8ZEUN2xDxTk3x6xsGQutDY9DSOCpNODoDh6iUpbfBNRDOw9p8QQgBBSY/okiQiOOBsT3ETvnI0XkI7wN2a+GK0ER2UGv7j+muk/+ylpzZTgE9LPu7u/I9AbssiCisPM1snTfEWUZ9DSjCyuLUUXKuTiwVe2MHnHKI4GyRNCvWf+8l47dkC4zliF8ylAS1uk/sAMp96m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/18 09:04, Song Hu 写道:
> On 2026/8/11 11:36, Ye Liu wrote:
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -230,7 +230,7 @@ long oom_badness(struct task_struct *p, unsigned long totalpages)
>>  	task_unlock(p);
>>
>>  	/* Normalize to oom_score_adj units */
>> -	adj *= totalpages / 1000;
>> +	adj *= totalpages / OOM_SCORE_ADJ_MAX;
> 
> One thing this line hides: for a memcg OOM, totalpages is
> mem_cgroup_get_max(), which can be below 1000 pages when the
> container limit is under 4M.  The division then yields 0, the whole
> oom_score_adj contribution goes away, and a task protected with
> -997 scores the same as a best-effort task with 1000.  The -1000
> exemption is checked separately above and still works.
> 
> DIV_ROUND_UP(totalpages, OOM_SCORE_ADJ_MAX) would preserve the adj
> weighting for small limits and change nothing meaningful for large
> ones.  This is an edge case, so probably fine to leave as is -
> noting it here since the line is being touched anyway.

Good catch. Yes, the truncation for totalpages < 1000 is real, 
but as you noted, it's an existing edge case. I'll keep this patch 
as a mechanical replacement and won't address it here. Out of curiosity,
are sub-4MB memcg limits actually used in practice? 

-- 
Thanks,
Ye Liu


