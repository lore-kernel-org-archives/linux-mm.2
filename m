Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A50FF60F1
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802426B0095; Tue, 31 Mar 2026 05:17:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2B66B0096; Tue, 31 Mar 2026 05:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B426B0098; Tue, 31 Mar 2026 05:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 518216B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:17:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F27DE8CCE6
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:17:08 +0000 (UTC)
X-FDA: 84605804136.11.EFBC25B
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id CD08440005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:17:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SV0VIqPC;
	spf=pass (imf27.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774948627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVOJiF6uwcHFWAX/3sTvyGHbX8XKYvu+j1EC4JDT8wE=;
	b=zMGkwqmmyZp3zatogYehm9Xr625eueBau1/zX2ustI/61By3GphFzC0at8972A36VTHx0M
	GQrI1K8L7awQmIDxNRUkSKDSxXehvXnguhoBp06GO6n3qgGunsD+FS6J1IJ2F3cf2ggjKF
	6H+BXtLERhP8d1F6b7ku4M1hawtIc+0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SV0VIqPC;
	spf=pass (imf27.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774948627; a=rsa-sha256;
	cv=none;
	b=IonSmQaRZiPfY6hcy4jx4xfAF87ieocGlQwklZDgBEANRS25rAjMqnEqHPTBDVVzzkpwBK
	LugJn9uT7hZkGxXIDPIcfHmPDB7NMLk/VZcLms83/oDmB56AaEBqzV6+rkV2oOYElWc1Wr
	lSq3VJxWsvSYCnOJf+9caUI/077bHR4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774948622; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=KVOJiF6uwcHFWAX/3sTvyGHbX8XKYvu+j1EC4JDT8wE=;
	b=SV0VIqPCFm5TpASglJhPQ3j8PI2Q8ezdXtiPOTrvrYPomliv5JLUZRMSwbb87m6bgeKDuOLcVIt5j8yKpfxHKTc2MjgLsZJh0nXE4dXpPoHS/dP1BceRzhZpNxfHEfhFV7Hj1llYeqCNG5DMcAZq2GmohkxM/GEHfy2Es+YiZ2M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X03xQvk_1774948621;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X03xQvk_1774948621 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 17:17:02 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Ingo Molnar <mingo@redhat.com>,  Peter
 Zijlstra <peterz@infradead.org>,  Ritesh Harjani <ritesh.list@gmail.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Ying Huang
 <huang.ying.caritas@gmail.com>,  Juri Lelli <juri.lelli@redhat.com>,  Mel
 Gorman <mgorman@suse.de>,  Vincent Guittot <vincent.guittot@linaro.org>,
  Dietmar Eggemann <dietmar.eggemann@arm.com>,  Steven Rostedt
 <rostedt@goodmis.org>
Subject: Re: [PATCH] sched/numa, mm: Skip page promotion if cpu pid is valid
In-Reply-To: <eb9d54b5-6fe0-45b6-9a8d-aa117ccd3c0e@linux.ibm.com> (Donet Tom's
	message of "Tue, 31 Mar 2026 14:33:10 +0530")
References: <20260326071216.11883-1-donettom@linux.ibm.com>
	<f41ab7cb-4430-4338-8812-eb6aa98e9bf9@kernel.org>
	<2b8f30a6-a8d1-4ea5-8078-5eec399c8609@linux.ibm.com>
	<87cy0kpfdx.fsf@DESKTOP-5N7EMDA>
	<eb9d54b5-6fe0-45b6-9a8d-aa117ccd3c0e@linux.ibm.com>
Date: Tue, 31 Mar 2026 17:17:02 +0800
Message-ID: <875x6cpddd.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: CD08440005
X-Stat-Signature: 5k9dzbjtesyym13qnti3mwpe5hjax9cg
X-Rspamd-Server: rspam06
X-HE-Tag: 1774948625-245659
X-HE-Meta: U2FsdGVkX18rPVovY4XcrG/aH3esb60zcOlPH4+14pzi+S990sss3XkMBDsfp9agCrWeG7hWn4dtjab27opTXB9Iobmn5oBvJgI24DcFP/8CWVTNZ58Ox2085/TbQeSzisjEr5jC7qoY01IQaz4etmwwDEHdegbT+3mKq33odnJHTunBdfU7z6wiJ4QSGq6Ok/DX2vPM3WUhzQXLLFmGMUEfUPzLUhqjx2/WMKlCjdZZxo/1mExN8FaHXK2kP77iZ7aEuMM1QLfMlNFdaOdc99Ip0pF+oJxyY05VQBa5yF8OyNfghN9LvDCgm1Ej1i8C3VfHZI7nMfoIxBh90EmT/T0QRofrkgUW9N55goKa/HaIGchWMI3xfG0wjoF+vYWss61DLEXZOHNDe9+Dy6epYWptJQLnMx0jsm0bOnWY+yGOQSckdOB3GO7xy/kvGaq8ygL8hcD51z57evOrSMCdsWZtZ5LDHrCIIHNR/aW1SRfLNVn4kQZsNCMzQ4L64zjQeVZafsqGUax6bOEVcLMuvnChTmTbNcfWKUquuqHl1pj6zPUIxdMhYVAef/PcFs2Q5ZEYOTL/QWFBpBiBV1dJT/CV5t93DkqYOekvMu6LSPyVQM2va6XXM/JDWw9a4AnjCcX99XkSfeW+8qBzdSS/isANR2OxcUSHq/pHTJyWZ3foc8fMCDDNSDhef/Cr2mp2r4RjjaZmes3L6xXGej4LwyiNGBLNwJaUUH63YuDPy/mpEQGwSOAJ4O0seJlOt+DZU/ZmYA4g95OkDK1G0e4ZNr2sO8nxdkxXk86WmEPtKmMSTr5foU+FgdUvqZUhpgc27qvz/wFliYZQkjD2Aq1CUxQankPaymNY6z++u+OG0+5Ell8vf9DY6Ys3isYiFGiwnEG5LPcY6lm+oD5etyx/H9QHMml1hZmyakKry1pTN24cTkptE+/2Etya/IOjpI/ukuHfleEpTK3c+Dg6L0d
 OVB4Fdpf
 VZLMkC/45cNxCtiagqDQsk4QiwZEN5YTQGcddB9nEuuXV9sBFuG3xYUgjlL5XG9zTwrtWHE8EXRDjMv++N9cwkhPWG7yGFuEsqxWbsywK646z/AoDG/JftU9dgBungf0UKUIBkADwkTMDTYcU6/q+oSL5aDbvrfxJNOYIoZtqSyNfqy8la79ixFGaU7sf/zF8MjBAe8xXR4eNLg5beEmX1+LbNUI6wWKhxTDNXujhrJ24Wn+iOz54MWCVJQYdc+8x8xO0M7ko/2fem8jaSUdRKiDkLEKaPypzbnE1GOiFzHN9XoI/LCDStXG5d72vUeiNw2jeLSvhUpUYZY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Donet Tom <donettom@linux.ibm.com> writes:

> Hi
>
> On 3/31/26 2:03 PM, Huang, Ying wrote:
>> Hi, Donet,
>>
>> Donet Tom <donettom@linux.ibm.com> writes:
>>
>>> On 3/26/26 3:59 PM, David Hildenbrand (Arm) wrote:
>>>> On 3/26/26 08:12, Donet Tom wrote:
>>>>> If memory tiering is disabled, cpupid of slow memory pages may
>>>>> contain a valid CPU and PID. If tiering is enabled at runtime,
>>>>> there is a chance that in should_numa_migrate_memory(), this
>>>>> valid CPU/PID is treated as a last access timestamp, leading
>>>>> to unnecessary promotion.
>>>> Is that measurable? Should we at least have a Fixes: ?
>>>>
>>>>> Prevent this by skipping promotion when cpupid is valid.
>>>>>
>>>>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>>>>> ---
>>>>>    kernel/sched/fair.c | 7 +++++++
>>>>>    1 file changed, 7 insertions(+)
>>>>>
>>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>>> index 4b43809a3fb1..f5830a5a94d5 100644
>>>>> --- a/kernel/sched/fair.c
>>>>> +++ b/kernel/sched/fair.c
>>>>> @@ -2001,6 +2001,13 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>>>>>    		unsigned int latency, th, def_th;
>>>>>    		long nr = folio_nr_pages(folio);
>>>>>    
>>>> /*
>>>>    * When ...
>>>>
>>>>> +		/* When tiering is enabled at runtime, last_cpupid may
>>>>> +		 * hold a valid cpupid instead of an access timestamp.
>>>>> +		 * If so, skip page promotion.
>>>>> +		 */
>>>>> +		if (cpupid_valid(folio_last_cpupid(folio)))
>>>>> +			return false;
>>>>> +
>>>> IIUC, as timestamp we use jiffies_to_msecs(). So, soon after bootup,
>>>> we would no longer get false positives for cpupid_valid().
>>>> I suppose overflows are not a problem, correct?
>>> Thank you, David, for guiding me in the right direction.
>>>
>>> I initially thought that overflows would not occur, and therefore
>>> cpupid_valid() would not produce false positives. However,
>>> after looking into it further, it appears that overflow can
>>> happen when storing the access time.
>>>
>>> The last_cpupid field is used to store the last access time.
>>>  From the code, it appears that 21 bits are used for this
>>> (#define LAST_CPUPID_SHIFT (LAST__PID_SHIFT + LAST__CPU_SHIFT)).
>>>
>>> With 21 bits, the maximum value that can be stored is
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
>> Yes.  IMHO, false positives is unavoidable.  So, the patch fixes a
>> temporal performance issue at the cost of a longstanding performance
>> issue.  Right?
>
>
> I was trying to fix a functional issue. When memory tiering is
>
> enabled at runtime, treating last_cpupid as access time is incorrect, right?

I don't think that it's a functional issue.  It has only performance
impact.  Did you find any functionality bug?

---
Best Regards,
Huang, Ying

