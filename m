Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84181D3515C
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A036B008A; Wed,  1 Apr 2026 05:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1DC6B0092; Wed,  1 Apr 2026 05:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07C96B0093; Wed,  1 Apr 2026 05:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D07126B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:48:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CE8EC71D1
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:48:41 +0000 (UTC)
X-FDA: 84609512442.24.629EFEA
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6E30E8000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:48:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o6x9jOhP;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775036919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQ8lIZi5cNaNtDxgsiU368Gc/m69M0yE00uYzoQg624=;
	b=vhYI//EsYL3TJ4Bv/TB0nkRH9GdE7swuC6eQdQGwLhU/+TPzjD5RRBPJfgIKmBVsGxJlcH
	HasuFyTbq+6X4HC7B7KPU2r8J/GjkD3A3GL096rbLexzMVk4vVzgvnttKNYO8FnQANHPsI
	qkZLzlc9UNWZyPkexEmKSvkEagn8c74=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775036919; a=rsa-sha256;
	cv=none;
	b=lPo7TsuXGmU9YRoZTUOitcUOPXolDbq3c4dkqV49HNuAguoZwo4OXl8EZCN9yTWBRzKw6W
	ke/0dnssZK3+FMi1Edtg0vp5gSdTlG61qYkqDcBP7F/p1EVSLuOzNWTuP2YpJGQocbpFyo
	sruGsMMNrwiOv1wth8QDSuhIE7SoMj8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o6x9jOhP;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775036915; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=GQ8lIZi5cNaNtDxgsiU368Gc/m69M0yE00uYzoQg624=;
	b=o6x9jOhP+XhfGVZ9LYGYGdnCRa8UYBcJUPbYYy3DnajAsTrx+R4EgkZP2Z3OnYgSAnsEfNGVDY3nBc7BF5/Bbgv30LIiovI3wRkx+/GBqr3J5md/EkAs5l8iEwWWHU62v/2kgGxdWLySSxNFrTkxcHZKC4fmTdqOrTm5yc3cM+s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X0AXFuR_1775036903;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X0AXFuR_1775036903 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Apr 2026 17:48:33 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Ingo Molnar <mingo@redhat.com>,  Peter
 Zijlstra <peterz@infradead.org>,  Ritesh Harjani <ritesh.list@gmail.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Ying Huang
 <huang.ying.caritas@gmail.com>,  Juri Lelli <juri.lelli@redhat.com>,  Mel
 Gorman <mgorman@suse.de>,  Vincent Guittot <vincent.guittot@linaro.org>,
  Dietmar Eggemann <dietmar.eggemann@arm.com>,  Steven Rostedt
 <rostedt@goodmis.org>
Subject: Re: [PATCH] sched/numa, mm: Skip page promotion if cpu pid is valid
In-Reply-To: <7dd35e65-e0c2-423d-a82d-c9e488e85e33@kernel.org> (David
	Hildenbrand's message of "Tue, 31 Mar 2026 12:04:10 +0200")
References: <20260326071216.11883-1-donettom@linux.ibm.com>
	<f41ab7cb-4430-4338-8812-eb6aa98e9bf9@kernel.org>
	<2b8f30a6-a8d1-4ea5-8078-5eec399c8609@linux.ibm.com>
	<87cy0kpfdx.fsf@DESKTOP-5N7EMDA>
	<7dd35e65-e0c2-423d-a82d-c9e488e85e33@kernel.org>
Date: Wed, 01 Apr 2026 17:48:23 +0800
Message-ID: <874ilvui3c.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 6E30E8000B
X-Stat-Signature: azobn9mfwgmmjxticeg9qsap93he7ynw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775036918-629941
X-HE-Meta: U2FsdGVkX18bvSdZqRmDDCDWeeZRVvvtEmSwC65twV7EalqjFxQ3B7yFtqOnYVnZFZEqaa1BT8Ry5Y9bywEoBIXi6BHMK9tS169f6DrFfxxbCriPtOimBkz2EVQA5nnjvHQkd/FgNIePpxYcAXBq0wfTCSEe4l8rFs3vULNV+ru0KC5So6pYXsZFg5ZHNLRqTtpK3ZLhhgeWf5rJXbYpcgioIUP6uGAtXrOc2mnRl3UieWyvl6nKCQTw8kYq1N2Q/1AZ0hhg0D46Jt2wp98q/Zkqy2ICI2GlW44CyinmsY9l6z52Oec86L1BsH1+hobGYEtp4Wx1HuE/HENn6C2YMZBbpG9yf1Sd8L6lN0b1iiCnyuEmf4FU0BZqKsEP6obcUyGUrbqyfSh7eR+8c7NDOdvmskGj6JQFA93m44Jid5QKMoDgK7g18W87xeL0+abcxebCam6xFpI4xvvU1r1ZS8BMThWd1dlGOQLavqx6s3Sq1zSYvDjBaYJWBBUTKQRzDqvSTi2GZE2osmah7X/il9/V8oxylfg4HK+4Pk/pdst+xDBTMLMLpsZiGuhIYoNRBkCzZ95MLXV085TWjd2L1OTOLF1rV1jdyng5CDfQ1h0cjbo+iO3SBX7OaITQw8ezC35iUxKpUp13SdJkcw8AkuQPA0l4qhWeVUG9YjSrg2Jzk67KdXmjFHlqpPF8CVX2Y8UXbGj0CXZEOFTsnO+6P2VkAR667R/O65G3mUGN6Y3jqubZyVR0coaN322KsW2SDB5Je+0GKI76Lzqa0rJCAo8GmtolJ44G7DEVYgH5rLoSsErSelh7zBLHMHAU66y6HygVhHqH6IvB1rk3eqiTFAcaX7tG9XOdI55iImDEnE2bauhgR/XQeceU4pvY1Z3VGi+FpLdHzQGM2JIVHTzQt0A3kbk5CMAPAJ2W9XnLWoS4nJI8Sjyxr5MJvQOw9JFCdiW6xZ7N5ed++HEGkkH
 +gNZYmDs
 BF5K/+I0d5t8EDP5oUMYyWsLZBjFA4y/pRtCMn7TZQk4Qr/u5jVQc5YpQ7Avzr5os2HxSQcWW8ltxspoiw6KGYFpHHLGYvdYOvDFIxmYOhqZBGv0n0Mbdcwb5B91k5OJe2UM0LDROOfopGhraSxYowKTtLq2UkV596tmeiETYkxVQiAg3Ui6C1/eswoNvoX73WGrJPUYk8SChPwmLPSArknEocE5bVO4/PJTAK1XS7tw3g6dRi0MdfeMaM0YqLXEkWb32vh3+BCizuZWwHYVkmvkkUKWyOW2QGpDBN61wgb9wUuty/0UHJrdbXLDoegBwjeWtVcDpoOJPlcTwf1ujlDGe18Hf9h0BXNl1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 3/31/26 10:33, Huang, Ying wrote:
>> Hi, Donet,
>> 
>> Donet Tom <donettom@linux.ibm.com> writes:
>> 
>>> On 3/26/26 3:59 PM, David Hildenbrand (Arm) wrote:
>>>> Is that measurable? Should we at least have a Fixes: ?
>>>>
>>>> /*
>>>>   * When ...
>>>>
>>>> IIUC, as timestamp we use jiffies_to_msecs(). So, soon after bootup,
>>>> we would no longer get false positives for cpupid_valid().
>>>> I suppose overflows are not a problem, correct?
>>>
>>> Thank you, David, for guiding me in the right direction.
>>>
>>> I initially thought that overflows would not occur, and therefore
>>> cpupid_valid() would not produce false positives. However,
>>> after looking into it further, it appears that overflow can
>>> happen when storing the access time.
>>>
>>> The last_cpupid field is used to store the last access time.
>>> From the code, it appears that 21 bits are used for this
>>> (#define LAST_CPUPID_SHIFT (LAST__PID_SHIFT + LAST__CPU_SHIFT)).
>>>
>>> With 21 bits, the maximum value that can be stored is
>> 
>> It can be less than 21 bits, if CONFIG_NR_CPUS is small.
>> 
>> 	DEFINE(NR_CPUS_BITS, order_base_2(CONFIG_NR_CPUS));
>> 
>>> 2097151ms (35Hrs) . If the access time exceeds this
>>> range, it can overflow, which may lead to cpupid_valid()
>>> returning false positives.
>>>
>>> I think we need a reliable way to determine cpupid_valid() that
>>> does not produce false positives.
>> 
>> Yes.  IMHO, false positives is unavoidable.  So, the patch fixes a
>> temporal performance issue at the cost of a longstanding performance
>> issue.  Right?
>
>
> Could we set aside a bit to indicate "cpuid vs. time" ? We'd lose one
> bit for time, to we care?

Do we need one more bit for time and cpupid?  However, page flags are
precious resources.

> Would make it all easier to get ...

---
Best Regards,
Huang, Ying

