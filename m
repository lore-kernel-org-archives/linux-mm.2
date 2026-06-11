Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E6C8CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9933B6B0088; Thu, 11 Jun 2026 09:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969986B008C; Thu, 11 Jun 2026 09:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A6FA6B0092; Thu, 11 Jun 2026 09:37:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7ABAE6B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:37:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1375E140642
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:37:18 +0000 (UTC)
X-FDA: 84867733356.12.190A4F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7E902A000E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:37:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UmAJp2HG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781185036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OontUb7qE56W5Wue/M2LU8FmpW0BHV0EyXoJjTMFI3Y=;
	b=UKNTiRLbABRzwQVjTBBUgxujVoGhhW8hPFN1N2A7YavItdHBoo7xSAVft6AUovNG5PB2ZJ
	/M0V52J7oLW9h9UzAkxZGwmSWm9uFXavk/G+EeHca3wUtqlfk6Kb1rj6WMKqv7w6OCusvX
	JngAPM06rIKUiV96qF8ouISAjzfEj2A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UmAJp2HG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781185036;
	b=w8D5iT5gVjzXC2eGKyJC4iiZvuoFt94TuONMnNFD3ejgeDBSVpGVbljycV74uqwqXGk8nn
	aHCp4/6O2FrQPPFDNS0EiHpz4E4s0IHq8fDYgugDE7Z9COTOoz1l7ziRGMku3ieYbgUoim
	sfJGFYPsFcn9QCjQMAMgf+SQiYnO6fE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBAC9600AA;
	Thu, 11 Jun 2026 13:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463FB1F00893;
	Thu, 11 Jun 2026 13:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781185035;
	bh=OontUb7qE56W5Wue/M2LU8FmpW0BHV0EyXoJjTMFI3Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=UmAJp2HGw6a1cxu8Z7qUN33jlTIG2j+zWU8WRaBYMPD0e82ko/eZ36AgAOa43kY/h
	 lxlrudp9simk7JoBMca54NyZEiKzJWI3xHq2I1kMIbJ1GduGALBQqbCBcYKGWYTFml
	 5vfTpJMEs/Ewmp3fN/cMWDpJaVYBCErmVSoa/nVd3BNHzL1DSVVHXG8CYdXTe5g+EE
	 xDYke9gzTLyp1NWBse1zzjPaNGj6xpmesgfWQ6pdUmfK2zOnhfdz4GuStr5vUNRqfT
	 EAl2lV0KWC1COJwOyO0SXjG50HaGTpdkfNeGrd4M9vMiPC4pKJCOBSsVBpQaOqYjgK
	 0CNto2tHZMgOA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Tarun Sahu <tarunsahu@google.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH] mm/memfd_luo: validate serialized_data before conversion
In-Reply-To: <aiqso7rkpX6oMer7@kernel.org> (Mike Rapoport's message of "Thu,
	11 Jun 2026 15:40:03 +0300")
References: <c2478f79207b10a13282d917c961261d17b86a15.1781173768.git.tarunsahu@google.com>
	<aiqso7rkpX6oMer7@kernel.org>
Date: Thu, 11 Jun 2026 15:37:12 +0200
Message-ID: <2vxzmrx1qjuf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 7E902A000E
X-Rspam-User: 
X-Stat-Signature: jkyqey3tao6bzh998p5grmp6rsripk9s
X-Rspamd-Server: rspam09
X-HE-Tag: 1781185036-860502
X-HE-Meta: U2FsdGVkX194LW4WjeD2dzbNkazM6P4k4gLMmfRxE6aQzJmMzxh68YVD6QpDCVa1LHc6eHftmqNrrD437WYrUhoae8zA4g5L6owu0Qn4f+rFFFtFE9BGKshjPG5YoR5GpB20qTdTwc0QhjSE3mAsURvozmsISCkS0r4p/OKzzj9hkXys1UDgA9onEUmDQ91b2B1E44uVceVvjsSUn9SoTwgj/JcTaKDXGdzjhVMIbYoDXrHqDNNNojYaqVMSjwbef04pPHgTXGlRthWbwML97QkU5/FNHmgWPUTnYoUYkis8209uZ7Rx5wyeqEwOTm4IiDDmv+fd2oF1t6j64e3cYoJcv0l8cOKBGA0ku6r7dYY6n3TowNoWHOs9tIDCBmmCLbyFTwbg+7Hl7pPNqfHQu70PHplvQNNyrP/ytALX1oJSR/2vsZ35nSmfuefAbwVbDW8XZVICKMRKhKUR4I2ELzU4w23YG+du+n+5JjaAlMpgp38KwY8e+/jW4aeX573kCVBW6gMrwYVtDvGAxzelXpsH587huK6iCvCHfcQHi0E3vVRF2EWvvf2p4J6FcAqZxS4595U9rEmMGS1uVDn5oFUFCnWXPZ5yMsw5RYbonatLcxVuPCx8cubWfQcftNX4BOu6wdh3afucNCdeT8p5a9anYywkDly+OFS1Y7RSnQdKThbl9rh97nOpBIGdLEREyUzqLPjnnDeIJZGZulX57fgK3pH9LklO5tuTdjRp9VT03vNDfGf14xvD4NuUcSrYob28OrPhfUZkH5KjuC+nViieTgnCt56QxwekwaehHnV/VFC7+j09IfPBSzB+9yKD9X63tQe+O2i6z5gMB+tCkZ+U+VtxOxRRbAO+wa/1Se9Oittjk+v7uRr73niU8WSljziQSuSV9aCChPsx3E8LT40XGFVVdWxJmh487sDAyPcnGaNnz74aOnKG4cXcRUcFyGr8BvaXtK83FI63m16
 KKitRcUc
 QddvP/owQihAwDi8qbANiTW00G6jx5YskhsG7J5q5qOXYvKH6XHMKUU9iJxHjBH+UTeM0QLZRaoHqdFmgxpl9EtBFhqK1jBNi2C4Hpq2CFrg4QyYNytsyY0nG683VJbuwn3WOWzP1Oy3cfSP9z3W1bpxYjSgvdxGBqZKjIA4b1N2GnqEfg3iAsk/65HX1M59jTc0XdpmZpoWCGlde0l6+eBTaC6qDlojyU1t9d9P3T68OBVnidHSQOav6Iv7nC2qtRdIVuMrQyDcxEzsaWDEUjNG/UQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11 2026, Mike Rapoport wrote:

> On Thu, Jun 11, 2026 at 10:30:03AM +0000, Tarun Sahu wrote:
>> In memfd_luo_finish() and memfd_luo_retrieve(), phys_to_virt() was called
>> on args->serialized_data before checking if the physical address is valid.
>> Since physical address 0 does not map to virtual NULL (due to direct
>> mapping offsets), the subsequent check 'if (!ser)' was ineffective at
>> catching a missing serialized_data, leading to unsafe dereferences later.
>> 
>> Validate that args->serialized_data is non-zero before calling
>> phys_to_virt().
>> 
>> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>>  mm/memfd_luo.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>> 
>> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
>> index 59de210bee5f..10f3983b0060 100644
>> --- a/mm/memfd_luo.c
>> +++ b/mm/memfd_luo.c
>> @@ -397,10 +397,11 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
>>  	if (args->retrieve_status)
>>  		return;
>>  
>> -	ser = phys_to_virt(args->serialized_data);
>> -	if (!ser)
>> +	if (!args->serialized_data)
>
> We really should make args->serialized_data a KHOSER_PTR

Hmm, that would also be a good idea. I suppose then it would be a better
to directly convert to using KHOSER_PTR() instead of this patch?

>
>>  		return;
>>  
>> +	ser = phys_to_virt(args->serialized_data);
>> +
>>  	if (ser->nr_folios) {
>>  		folios_ser = kho_restore_vmalloc(&ser->folios);
>>  		if (!folios_ser)
>> @@ -522,10 +523,11 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>>  	struct file *file;
>>  	int err;
>>  
>> -	ser = phys_to_virt(args->serialized_data);
>> -	if (!ser)
>> +	if (!args->serialized_data)
>>  		return -EINVAL;
>>  
>> +	ser = phys_to_virt(args->serialized_data);
>> +
>>  	/* Make sure the file only has seals supported by this version. */
>>  	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
>>  		err = -EOPNOTSUPP;
>> 
>> base-commit: 9716c086c8e8b141d35aa61f2e96a2e83de212a7
>> -- 
>> 2.54.0.1099.g489fc7bff1-goog
>> 

-- 
Regards,
Pratyush Yadav

