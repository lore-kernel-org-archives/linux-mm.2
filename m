Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D831606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 07:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K3Zn69FG
Received: by kanga.kvack.org (Postfix)
	id E703F6B0427; Tue, 20 Oct 2026 03:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20B66B0428; Tue, 20 Oct 2026 03:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10516B0429; Tue, 20 Oct 2026 03:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9FB6B0427
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:59:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B413408E6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:59:14 +0000 (UTC)
X-FDA: 85342254228.26.C70EAD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5213A40006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:59:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K3Zn69FG;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792483152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ReBTcrDImQvhoa5yHIWdOL2JpqjCmSuJOVv23tlb0UA=;
	b=A82RbV/sXBubJNSMnZcQgnPHu2T2X8Ikn2JLdsDJYIdMwZxZnEou/QkC/zdM9PRexBhemA
	c/z4IkdyHLlT6y83ZGq/l+7amNIQNOcTywOqrbsjswKw4s3vaObjs0Wri16cn6FICHgE4u
	WMJVe9z3tCyiSLMeDFn1QpRsL9kqfdI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792483152;
	b=lK2weSNC7HjcBDpEkGMysbQVdd3t0if+wK8pV6OY0jGnfiwxPkOkIV9a//Id52s7DhQ/RY
	PkNeIdYU6ZBBN4i6BOSULFEhuj8lGPEqEp2LpdRIDTyfnSoThyKj335cTDtsTKICB9G5FZ
	S3aR0KJ7XPUy3MYY9a3Bm+bs0KLaL0U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K3Zn69FG;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF0D260142;
	Tue, 20 Oct 2026 07:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8E51F000C4;
	Tue, 20 Oct 2026 07:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792483151;
	bh=ReBTcrDImQvhoa5yHIWdOL2JpqjCmSuJOVv23tlb0UA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K3Zn69FGWwSiJtnA3FBjGGoXJSaQ410NJ80DjvSu6xdbeDuevOL9AACByNV9xTbWq
	 o1J5l6e6+tCNtsnjE89KTNAGa4Lxg5PjNQ3TcF3VXEG21gwhgfJEATg3/IIt9tEc66
	 GJXmr+tN0rbXuqI4CE+7oAr1gZVH7BPL2W4HoyDbhMTuyHOZfNgC2AF5XZCMRCrQYA
	 WKrgr+M8EgQ19bpl4A8CTpaNg4Qazlsnj8fxenfx9YSQdnaAph96gxTN7GzGa/3r9W
	 IfKRxOxomD4OQCsbAf+EXogLaKsngv2775eNZwjfOvRUu0BspyMnzUWe72nWkaoNYR
	 0CXX9OuWyKmTA==
Message-ID: <b66b3450-ec8a-4c85-bb19-3731e21c0dff@kernel.org>
Date: Tue, 20 Oct 2026 09:59:07 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch v5] mm: vmstat_kunit: add synthetic benchmark for mm stats
To: David Rientjes <rientjes@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <920ba123-077e-c42d-ebdf-a5effccf2073@google.com>
 <8b077a83-3f79-cbfa-0273-e086b0e51ae4@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8b077a83-3f79-cbfa-0273-e086b0e51ae4@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5213A40006
X-Stat-Signature: cqw81tdz1qqkhd31hymcfrg6iy3qegbw
X-Rspam-User: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792483152-973311
X-HE-Meta: U2FsdGVkX1///j3dSzIA+RujG0yuv5rHx76NRTBnZFvUTR5lINSSioyMJS6kYLS8UladC0duvLWm4mGB/xlgDNAO71NZ4v9+b3NTCa2J7Laj4GV7307Kvb7Vb3QsPVt5DVhr1RWICH+ax7WfmYhT3PzUce6PY49SvHcnrvJpvHzy4kL3kN8msn57nxLiZFAh/vibT8KvZqRj6BjM0Sn1HxW7FAyRD1KVuL7AUH4XufAWMyOktgmq8pqEZb8PkyihBMmL+M86+a7eX0E6SSTYoSFhEwCp3rGJQ1nPUd5SM7CMw8lx/4zNT51+7MleKCXyZXX0JCdXC7Fz0v6DP9oApXmqzmQtPiKPK2AfnKuiFdff8t2eod75mlPCnUTjTUQR4HpDnWMaXgg+npiyeRm1+oBCXZaXlC/vd/6L3LGKnGQRXGfjkTHI+7Ab5ZO2XxbqoYvOracrvD18Jjfyzj18+LDMup4+d+KOUIz8cHUqQrdA5GCkDJaBXTc2JJWQD+pswQF12IZbfeTknA+RqOY+5IQAo4QtuZ+JDgVB/pujJkqQI6vr51abCjbza/pfkqA26War3mL3lFwTdeFFG2K66GLO91A+VF7tgym+aGIayAUdG39tuVEP4pKpsNjNlgAj0i8JRpxaEq8WbozkrvX514cQJGNotisyRqkGjZ/HW9qEQgu6Yyg7DrR7e6FO+Aj7gRaIVUU1Xxzw0S7ZNJHwy+ewDCAPxzR4izHUiLpXgEb7PKc7oG1VqI6Wf24FYsbrUTxafC4KYEeJO577Fy7TYb2Gud+Gqd77hwNaPukOUL1d7uBr32J6uYyk7Vnw/QEls0VBmt8NrmjX6JB5WjL8dhkwr3J6vLxzaEojMstJbIvlrh3F8WO4a8AUyBfkO0VwPsw6ekfx8teD2BgAdEdT0TY3Bn1Kz4PSF5Gv6jj2tK/KV6V8PT1GAPgm3TiHWh/2nhK2YeILEFb6N1ppdUg
 Xxi8dpY7
 Zzp4zBNQc11+LPSgP8u/te8RSRK2SOgbeOoVmkTE46jH7Wkt8L/YyMnkjtVAN29GHyYhqj1ESKlK5cwz3bjrN5BF7BZZoFBvM2AZ/aBHrmSbqAuvg3iEU5ufYr0BRC1cr36GetFDCYNk+38jIRgjH+6CsDPQ+wvJoqo3vkULRDS1O5lxFOUvR1PrQSZpkgBW76Y99ZkOYSDuo43AsS0nsQZ0OE9S/TwXE15/fNV//cyFRUqise3d+NumB9A/Upot+yrb1H1cWXsjR06EBk9yvNbrTPKAglIu29tiZCldlQZtG9z9ynn5w+fuYG3+0gp/YaIAgzf+n9tcNdQO29PzimbJBEWN00MB9ks+YxvxqiGjTomIElH9UpGa0r/HfPJCIiq54RkAra8HuZyupZJjwWvhhcLWMsJ6FTOCGv6Pgt2DaApVZHo9rMeSV92FhdjVYGifgkHoHyV8wzsT+KJA+RiAQpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/17/26 00:35, David Rientjes wrote:
> On Fri, 9 Oct 2026, David Rientjes wrote:
> 
>> From: Christoph Lameter <cl@gentwo.org>
>>
>> Add a synthetic benchmark that can be used to measure performance of MM
>> statistics.  This is used to analyze any improvements or regressions in
>> functions that are frequently used in hot code paths.
>>
>> This is the first of three tests that measure the execution times of
>> critical MM functions anticipated to be used by developers to measure the
>> impact of any core changes that would end up causing workload performance
>> issues.  Vmstats are embedded into MM hotpaths, so any regression can
>> cause performance and scalability impact for users.  Google has carried
>> these tests internally and kept them updated since Christoph posted them
>> back in 2009 for this purpose.
>>
>> This can also be used to detect regressions over time, from kernel
>> version to kernel version, independent of development use cases.
>>
>> The test is run by KUnit or doing modprobe vmstat_kunit directly.
>>
>> Sample output:
>>  KTAP version 1
>>  1..1
>>  KTAP version 1
>>  # Subtest: vmstat
>>  # module: vmstat_kunit
>>       1..3
>>       # vmstat_test_inc_dec_zone_page_state: 10000 ops: inc_zone_page_state -> 8 cycles (4 ns/op), dec_zone_page_state -> 9 cycles (4 ns/op)
>>       ok 1 vmstat_test_inc_dec_zone_page_state
>>       # vmstat_test_interleaved_zone_page_state: 10000 ops: inc/dec pair -> 17 cycles (8 ns/op)
>>       ok 2 vmstat_test_interleaved_zone_page_state
>>       # vmstat_test_count_vm_event: 10000 ops: count_vm_event -> 4 cycles (2 ns/op)
>>       ok 3 vmstat_test_count_vm_event
>>  # vmstat: pass:3 fail:0 skip:0 total:3
>>  # Totals: pass:3 fail:0 skip:0 total:3
>>  ok 1 vmstat
>>
>> Assisted-by: Gemini:gemini-3.8-flash
>> Signed-off-by: Christoph Lameter <cl@gentwo.org>
>> Signed-off-by: David Rientjes <rientjes@google.com>
>> ---
>> v5:
>>  - added dependency on CONFIG_VM_EVENT_COUNTERS
>>  - expanded commit description
>>
>> Once we're happy with this change, I'll apply the same treatment to the
>> proposed pgalloc and slab tests.
>>
> 
> I've added the rationale for the change to the commit description as 
> primairly being used by developers to benchmark and monitor any 
> regressions in functions that are known to be super hot and impact 
> workload performance.
> 
> This is the simplest of the three tests that Christoph provided back in 
> 2009, the others are pgalloc and slab tests, see 
> https://marc.info/?l=linux-mm&m=178547194364290 and 
> https://marc.info/?l=linux-mm&m=178547193264283 for those.  Based on the 
> feedback to move to kunit, I forked this one off independently because it 
> was the simplest to address all the feedback and pave the way for the 
> other two to be upstreamed afterwards.
> 
> Is this acceptable for merge?  If we're happy with this, I'll move onto 
> the pgalloc and slab variants.

Works for me. The tests are rather small and I see value in them.


-- 
Cheers,

David

