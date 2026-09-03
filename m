Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5BA2C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 09:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7796B0088; Thu,  3 Sep 2026 05:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67FD46B00AE; Thu,  3 Sep 2026 05:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCFD6B00AF; Thu,  3 Sep 2026 05:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF796B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:13:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88BFB1C217A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:13:45 +0000 (UTC)
X-FDA: 85171888410.30.58A3930
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8D41040002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:13:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=d1mPkZQO;
	spf=pass (imf12.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788426823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Eb7OOCldREczEc1zP4/rwq++5YqOpKv0/oThiUkNrw=;
	b=c258AqOdwKoXIx3361H0GkLGBVGFbSYS6whgtPmgdY0KxYScXKOLy3XWypE+y33Mc/zNks
	d039gZjPx54jDuRU+Ed987j+fekagbx+C+0g0bZRG31o5vpyI0J/eHhe4kWRzbtKWAVUeT
	Fg1GWH2ImGnODbtZWuqW27CbaP7HM8w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788426823;
	b=Nwtj9kDMTmAu+U/4qTkJZp5wWnZtXB7NGK8uBDQhKdvo83GRa9HE5aoA7JHllYIlObMAQn
	HuBaoVK1khLStx1B4YrXqm7KsQGZt0M0fj4GkOaLDD/TB7QaSpRw9E6gSadnb//mw6qysr
	aXuIh9Xi1hY1xWsxh7pWnLIOMS0oCm0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=d1mPkZQO;
	spf=pass (imf12.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=6Eb7OOCldREczEc1zP4/rwq++5YqOpKv0/oThiUkNrw=;
	b=d1mPkZQOntVWuJ3jJY+aIT4a0yYdMl2bhSahqBGDPdT3cvnlsYz1PeyUmxmEQL
	TzfaF5/o5YFGlOKwTqW1zgL/NbC522CD3ybxrokwxf284vI9XLNX6Z0g1CG258ij
	wJ8/mKoLu/wKqkRuqRQXW1CT8XnDEciKfuegBGzJhsaHA=
Message-ID: <baa22f03-e553-46cc-8c35-436363546605@163.com>
Date: Thu, 3 Sep 2026 17:13:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slab_common: fix shrink budget underflow in
 kfree_rcu_shrink_scan
To: Harry Yoo <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, paulmck@kernel.org,
 rcu@vger.kernel.org, xialonglong@kylinos.cn
References: <20260826075653.3304251-1-xialonglong2025@163.com>
 <apQsbGJDPPyXcn8R@dev>
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <apQsbGJDPPyXcn8R@dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnt+wqOplqb5p0AQ--.21702S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJFyrAF4ftF13XFyDGw1UAwb_yoWrZr4rpF
	W0ka4UKr4kJry8u3srXw4xXryay3yFkFWxGrWDAr43J3sI9F1rtryIyr1qvrWFyrn3Jw4S
	vr1qgFyDXFyjvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U5sqAUUUUU=
X-Originating-IP: [2409:8d1e:e12:253:60d4:70f8:e7c6:dcf9]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3A2ak2qZOi2XJAAA3P
X-Stat-Signature: g5chg97zg1xahwcgw5rps9b7dwdj7q51
X-Rspamd-Queue-Id: 8D41040002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788426822-915055
X-HE-Meta: U2FsdGVkX1/1y+Da7Fpkzul+H0eVx4C5U4d4hITslB6Qtk2Fnu7xYThuCCTo/xtUrm6GjC+0hxiZ/0Hd0Gq6aZPL3hZYPj1NRKCX+7NNTSsd4icgsCG34S6Cu7Ft3N7h7B54AMKs8llrsdfIQNtGzV2kjZs7bESkh7BEk47JMRm5xtB6eui0ACneikAKfNuUZvA26xJYczaf9tKRLkBdo2CdxOhUvnSpKtAvK/mu+SHhyujZHl3d9zJGF6/3Zp4qaDpFhwEhTqd9n/TBGYfmX9YNTJVMyzwIQ311CtWMQxgTfDUdXMohZ95kDpMk9mC03bpVs25ImY+ztV85bFBQaQXUPIb+TJEZUnuVY8Kd7yStrI8+G09ZwsZfkNQY8MlL5M9KgoiKoYQ0b9H0Zdfh7R4WhEg+MBHC8y7147USR1DlQE5+V5G6Jp8g4X49mkuDMmU5lWjEZsqMQC+d6IScW7Az4ZXz7XZaWLeUKNxHcmq0S54W1x0Xrlasy8cDGGsISkQvEtp73uRJ+C+xkW7xVkFZibro/8Kd4OTGM9gc9twGCKkc4WbuETzOfYhYOnEkQZw080+TQk2Dq5Ci03qM95bUszSSNkJ8vRSlcT/FIgnkG/BgMYFTCvLMYok2hU5bdfvBgNcpDcncJpN4Ibn/cfSYBRN7oyzuX2sw6X27kzycrGJqfAgNtZCsfJWaGZFToNQ4eiXtZQpMMnLgn60a3ObGELeoL6JhHcYM60StTw9Kt/hKVhwjglKJqsAW7yhZ5TVwO8dCyqJgoH0+CxCD4DbPOJ5sGMbuC/iRb1sIoTOgxHAPxi82iRxzlxoaLz+xuqL9dt0cJwll/hjHr08utGerPofCc9oxwzhalCS6mv+WgmmRnY/wkFt7LEmQ3nuPk5+DHdtYXjz3Wnyg7JpRVG4vHgijZnBWKWQD6iR6xEy9qIM2Z95N6XbTDwnGBJrQtvheT/sd8CflN220Joa
 vHBE5hkx
 ZDK43H3bFtTdXB/pmOCz/p/uMNiVVju6H5IhWil7ksSMz67LqXIZJFm3DnAg9rtInGYUBSrHHl4KJbFMojeprbNI/PsFdJYEsHmlS0s3JbzxVrYWqDx+gLVDNX7VIH48K410fmaKqBj2skr6PIoSe9cBEu+xMl9htdf36KOAw0kWJcyYz+UejXbaL87UdVoxBP8PoGBWC8V/LHhOcJukq9L9t2VM17Z/rUCp7RpnP9v5N5tMgcnUnaZz7ZXz0X9j67eQQIUxrhRmzr+eKNhEdfrvFOFcDwwO4J5jQKK1fonH5mzzzhsWibEpIMGRAdDxbo15I7MNr6a5R7NzfCUVgHmNNOSw04BY0Elov3TJLaBza7lOibvza8rzs0o0X/6Mt1aJaPtL8CLGscajSOyfkJ8een/j963ea1U4RMP0OWmW1mTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the reply.

在 2026/8/30 22:22, Harry Yoo 写道:
> On Wed, Aug 26, 2026 at 03:56:53PM +0800, Longlong Xia wrote:
>> From: Longlong Xia <xialonglong@kylinos.cn>
> Hi Longlong, I have a few questions.
>
>> The kfree_rcu shrinker decremented sc->nr_to_scan (unsigned long)
>> and then tested the result with <= 0. When a single CPU's object
>> count exceeds the remaining budget, the subtraction wraps to a large
>> positive value and the <= 0 comparison, which is equivalent to == 0
>> for an unsigned type, never fires again.
> Since when (which commit) has it been broken?
> If it has been undiscovered for a very long time, why is that so?

Since the shrinker was first added: 9154244c1ab6 ("rcu/tree: Add a
shrinker to prevent OOM due to kfree_rcu() batching", v5.8);

>
> And how did you discover this?

While reviewing the kvfree_rcu() batching paths with the help of AI
tooling (hence the Assisted-by: tag in the patch), which flagged the
unsigned subtraction feeding a "<= 0" test.

>> The scan loop then iterates
>> through every possible CPU instead of honouring the reclaim budget.
> Did you confirm this actually does happen? If so, how often does the
> kernel end up iterating through every possible CPUs, very rarely or
> almost always?

Yes, in two ways.


Experiment 1 -- deterministic, instrumented loop.  Per-CPU pr_info()
plus a test entry invoking kfree_rcu_shrink_scan() with a controlled
budget; 4-CPU QEMU guest, 400 objects queued on CPU0, budget 50:
   buggy:   cpu=0 count=400 nr_to_scan_after_sub=18446744073709551266
                 visits all 4 CPUs
   patched: cpu=0 count=400 nr_to_scan=50 BREAK

                stops at CPU0


Experiment 2 -- natural trigger, no kernel modification at all
(kprobes only).  Setup: 1 GiB QEMU guest, 4 possible CPUs, no swap.

   1. Observation: three kprobes.  Scan entry/exit record nr_to_scan
      and the return value; each kfree_rcu_monitor() hit inside a
      scan is one CPU the loop processed.

   2. Memory pressure: ~650 MiB of anonymous memory.

   3. krc backlog: loaded the in-tree test_vmalloc module ,

      which repeatedly vmalloc()s one page and frees it via kvfree_rcu();

     10 million iterations over ~70s kept the per-CPU queues populated.


Result within ~70s: 262 natural invocations, all from kswapd0;
171 of the 261 scans that found a backlog (66%) overshot the budget
(nr_to_scan = 128, freed up to 4479) and visited all 4 possible CPUs.


>
> Would this affect the kernel's reclamation behavior in some way?

The break was meant to cap the scan at the reclaim budget; once
the subtraction wraps, the cap is gone and one scan processes
every possible CPU, draining the whole backlog instead of a
budget-sized slice.


Thanks,

Longlong

>> Accumulate into freed and stop once freed >= nr_to_scan. The shrinker
>> core treats nr_to_scan as input-only, so dropping the decrement is
>> safe; freed becomes unsigned long to match the return type.
>>
>> Suggested-by: Hao Li <hao.li@linux.dev>
>> Assisted-by: Codex:gpt-5.6-sol
>> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
>> ---
>> Changes in v2:
>> - Rework per suggestion from Hao Li: accumulate into freed directly,
>>    compare freed >= nr_to_scan instead of decrementing nr_to_scan, and
>>    drop the per-CPU count local; promote freed to unsigned long.
>>
>> Link: https://lore.kernel.org/all/20260824091838.1692153-1-xialonglong2025@163.com/
>> ---
>>   mm/slab_common.c | 13 +++++--------
>>   1 file changed, 5 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 657fd75776ea..e227c2ef2a4e 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -2162,20 +2162,17 @@ kfree_rcu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
>>   static unsigned long
>>   kfree_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>>   {
>> -	int cpu, freed = 0;
>> +	int cpu;
>> +	unsigned long freed = 0;
>>   
>>   	for_each_possible_cpu(cpu) {
>> -		int count;
>>   		struct kfree_rcu_cpu *krcp = per_cpu_ptr(&krc, cpu);
>>   
>> -		count = krc_count(krcp);
>> -		count += drain_page_cache(krcp);
>> +		freed += krc_count(krcp);
>> +		freed += drain_page_cache(krcp);
>>   		kfree_rcu_monitor(&krcp->monitor_work.work);
>>   
>> -		sc->nr_to_scan -= count;
>> -		freed += count;
>> -
>> -		if (sc->nr_to_scan <= 0)
>> +		if (freed >= sc->nr_to_scan)
>>   			break;
>>   	}
>>   
>> -- 
>> 2.43.0


