Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A38FC591C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5B316B0088; Thu, 26 Feb 2026 05:01:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C32F96B0089; Thu, 26 Feb 2026 05:01:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35046B008A; Thu, 26 Feb 2026 05:01:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A00DD6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:01:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B4241CF02
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:01:11 +0000 (UTC)
X-FDA: 84486164742.16.961150B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7869E1C0002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:01:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A+trAdNZ;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772100069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVL1D+NAE1tMGpA3yVhv3rADrzKuJBmbK/iYOP/qDEA=;
	b=Kg8ApadKkXuB5/kyomRiI9ZhwQTHXX1GjGT7BXlJxf2IdAIzP6uWMJssLnhBXbwT3Vuec2
	hlFgFTUc8CI5ChRAaAH9Q3stGo5gmfH6NHXO38zCp5SL7ongQYa/7U38L4nkbwiySXzThj
	KaG1g2C5DL294m6vVf7S2ayfKxhOn1M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A+trAdNZ;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772100069; a=rsa-sha256;
	cv=none;
	b=m5IAFtiMKIcn2Srf+QduM3SGb3ZW4hQbxPpyq5i88doNQkU4LCKXRMBWBVETBHpj8ZdUCW
	33DRr6zYLkmdcFZkAydojBbCgOc1m8d17BL6RPV5XHeAncKf27r0G6ux7AbjkR3k05EWoz
	w8AkCjijDr3ej6Hl38jR7H719T7Z+uI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77E2C442D3;
	Thu, 26 Feb 2026 10:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B113EC19422;
	Thu, 26 Feb 2026 10:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772100068;
	bh=HEuk0s9GZMJPl2JuT5lCr+YlmbdmuejV1eS3nm6JHko=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A+trAdNZEwYhjQmBGJfZ6Vj8jtvHi8ZvdtrkS1EA5HCl3CZrzj0NNMQJ4hA/Xlo/x
	 g83xdKCdI7meSzm/0Ceq4+qRO/SdSW1dAZGW4UBLLA5S1crR6Bwahm82LQdYEB9T4c
	 MT3zIytjl20iBm5JJO3mgpIS+RvJcAu6nL2y0CDtbkQTcs6jfC7RqEm5TFTuUzFSBh
	 WIBbTUmLvmi7ul1fa9xOUF6EO64uv6v+3GrDp9dcO6NgLkPFTyEZCxovNVsWhAuwry
	 ekV9Y/Y9iAKPxpV9aTZ1n9UEJ1y24RC+dihZP7p37F3Bh/xuIPpF94AdbUqbMXpPZV
	 SdhhXDvwSkrkg==
Message-ID: <811c5456-44c9-4b90-bace-caba6cb6f972@kernel.org>
Date: Thu, 26 Feb 2026 11:01:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: khugepaged: simplify scanning progress in pmd
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 richard.weiyang@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260226081313.53518-1-vernon2gm@gmail.com>
 <06ff4738-e81a-49ab-9204-74a6829d8d8b@kernel.org>
 <zdvzmoop5xswqcyiwmvvrdfianm4ccs3gryfecwbm4bhuh7ebo@7an4huwgbuwo>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <zdvzmoop5xswqcyiwmvvrdfianm4ccs3gryfecwbm4bhuh7ebo@7an4huwgbuwo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7869E1C0002
X-Rspamd-Server: rspam02
X-Stat-Signature: 7f3tgsme7i3px9st1bkrz3tyrhb9ft44
X-HE-Tag: 1772100069-867692
X-HE-Meta: U2FsdGVkX1/ntMA36uTd0yX1MsCa1bYk+K0iheLVNYLcO/WfE0XMa5NbicjFmZGTs+fq24nRAV91hSCrXzTL36eQUB/GbrzhLKi4b42vLogJvdrTq19yee4unN+srr9DroR0NgE7+cWdv5IvOLJh9/XtAFBv/LZFeBMEPQLlZUTB3jWfCyu3yr9K6NJVCJMehTt2bA+fJeRmnBcdld2FbCxedLkDRviwZf7A5MTzrxpj92h5oUHIu0CxXmHgbEac1I+T+38lxzk/c0KUD3foNifsW8ZR6mxuYF1JxcoD+fafpYjUnvRVQdzc4PdbOeISboiGK2NHui5LarypUK8+6ZS0YznvGTlRsYuSbXzTNVKkgeW+bVpCG1h7wcc0P62pPwv7TLjRk5BKlcu3y2cN66b9DRhsrurvDf6SnJdvoDcmVYZMAOd0AcEjsm68jFXouSTgeUwNDAWfXK3QMeSHG2EqyM5Q0978LDLAjcscrsgj2bXgc2Fdl46IxPJhDxDvvbJdytKkOFw8uMqF+cV6fvEYUa4P9Ey4yht6Bw8EZl4riPnpql2nh944qm4NF/wW/gjqttAbwOg2o9hcu+C8rCEMFdiEIK5gOw4V6HV8ewkFhGd0xt4d85GJDm2c8aAOOdgzDJECOpVKKtXvQDDQbSaWO5I/p8WApBGW7WM2azHnqf4TSugdG3RPcfC81+rwqWtslsJ6eT7BrM8cRztq30h8Mlltao4cpgqdncj3N7D+uhNW6Chr7eqHLaom1A5//PJkAe18laCWEZC68k4DQ6KSlvuC3myXbQ9DSd3Qul4S7qC4EtEyCn6kCxdnZVrazDlGw4NepqTR4V1lUEekuFTle60SkqIm5t7024y76uusCYS/tyfViH9SU0VaR8vtRzxSfqbkiJIxTvSs8zCPKYBPrABX4NC9wjS0AepoTHDrCd5tnhHl8IiY9gUMRSTFJlEvUrtGvuXfVBKLmys
 zedyyazI
 11iiCIBN4JvO6yfbRvCfSrtIprpVeVBSq6PHGyE+TxehB3vQnbIQ9Esl1Jj5ObDYOMFplSL+xVD8588ARwftMKwi9METVE/OoYG+NQESEiKkNS474YIbwNTJTecy1BNs3DKOiSiXkiex/TLUpnB+fGYuT2qm6omGNZSK2r/w/9jgYaMwrgAqbRmyZClBwxy4AMG22xDsC+cWnoPgXBPzg/iMYjv9rlnb3DuQ3AqHMN3ein+kLo5RCQxsVwvHk7Nj+6pTaPDOf2oHEc+wuDhMfBjhACsA4hHav5SqFk33n991qHOaCusBEzTromi0MXSdb12aAAgO7fQ9+gvk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>>  static int khugepaged_has_work(void)
>> @@ -2545,13 +2555,14 @@ static int khugepaged_wait_event(void)
>>
>>  static void khugepaged_do_scan(struct collapse_control *cc)
>>  {
>> -	unsigned int progress = 0, pass_through_head = 0;
>> -	unsigned int pages = READ_ONCE(khugepaged_pages_to_scan);
>> +	const unsigned int progress_max = READ_ONCE(khugepaged_pages_to_scan);
>> +	unsigned int pass_through_head = 0;
>>  	bool wait = true;
>>  	enum scan_result result = SCAN_SUCCEED;
>>
>>  	lru_add_drain_all();
>>
>> +	cc->progress = 0;
> 
> madvise(MADV_COLLAPSE) is missing the initialization of "cc->progress"
> because "cc = kmalloc_obj(*cc)". We need to manually initialize it in
> madvise_collapse().

Right, although it wouldn't matter right now, because nobody would be
reading the value.

It's really weird that cc is not simply completely zeroed out in
madvise_collapse().

-- 
Cheers,

David

