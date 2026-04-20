Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB2BF36C2A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 06:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83966B0005; Mon, 20 Apr 2026 02:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5AC86B0088; Mon, 20 Apr 2026 02:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B983F6B0089; Mon, 20 Apr 2026 02:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA0B76B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:56:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 676181B8C44
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:56:28 +0000 (UTC)
X-FDA: 84678025656.18.345985D
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf03.hostedemail.com (Postfix) with ESMTP id 679652000E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:56:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tlGk+B6c;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776668186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xGsb+8op9HfuZM90V1dqEvT2Pz/EwuZxxHDEbjQ1P60=;
	b=sODxhWnhNCIhaJ43n/ub45ta1llZv5XGnTSlC54Q3piWlcbdr9GkoKJvBUB33pZAPvKAUs
	uOGr0mYJjAjYxnkNAz5gVujZkhUVXw0ZMxEsPmcdaR585F2Bj350NAl4XpAa+dpTB4qmmF
	ds63uMD8v643C1TwPq/X9/kwnNXoCNw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tlGk+B6c;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776668186; a=rsa-sha256;
	cv=none;
	b=w0GJ8J853cxMsz4GakQvp8gKtzU+sxfpTkysCX7pJu3KP8/f4WL1SN1uw1w/vG1P3b8HKB
	tAjN6GAccg9x6CbTATAkqDQ8Gmm5qJCMwYmbZuBcV3X8zmYfWbL/xEDR3Oyy8loxJtjTbp
	e1EI/MJb5b0OuNLPAb58MxIjJ5BSmgc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776668184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xGsb+8op9HfuZM90V1dqEvT2Pz/EwuZxxHDEbjQ1P60=;
	b=tlGk+B6cD2wQoxeTxTQaIM9HgJG1/fOl+TD439S2eSzteQIBtVQoF/qt0Tj5ipd2lKSyoK
	a2eSdPyMUV2erR1RW8e8FhTveArdfnfmsDUDnpn9TBMKphzzrr6xeUo9Gzw4+q5jECH65z
	bKOrgBaU6HAeQpddApi0I5zgE6b3f1U=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: lance.yang@linux.dev,
	luizcap@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	dev.jain@arm.com,
	baohua@kernel.org
Subject: Re: [PATCH v3 02/10] mm: introduce pgtable_has_pmd_leaves()
Date: Mon, 20 Apr 2026 14:55:56 +0800
Message-Id: <20260420065556.74028-1-lance.yang@linux.dev>
In-Reply-To: <8a0b6d67-121a-4ac8-a74b-737d52d8b7ac@kernel.org>
References: <8a0b6d67-121a-4ac8-a74b-737d52d8b7ac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ujfza9gqbeqgchhakaaugiue7pyniwiq
X-Rspamd-Queue-Id: 679652000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776668186-257418
X-HE-Meta: U2FsdGVkX1+bkRu78QNr0zztkviPlv/kW3H/amlhBePO2vivOFzdZdtaUaFu0COzhOWVrrPZfE0XVj0Dm7CkHXDu26/Xs2bJPDpjs+72DsBDW2mB9JKnThaEk+ZXCrtFUCY/kete1SnzN0SfBTa3/7c0snrBf/jd/RbFD4eu6YarrWoyKVL3CRaCJYYkWBpRaG8m0HEN7aVMOCQeuEOKEQjyeY86YqZ3PI8olkJ/SAWArfsdRnXjVLgTshyJEc0U6FPRSFe2NJI4bfO/VXNJ3immzWhIO2K4CNdsBxP9BBRLZSeD/hBP0r3fjHFyi3jMOrWH13J3wtkwWGpNXLcLnJxQC6OrxCp0Rit1pGZOYbj+0qCkQN0tY5dNUtpQlNxIFgI7oR2hbvZ0JyXRaklFhwNB8/TVj2OHt38aQcT0dudX9BGDJ1fSyZr4nj/vKRNsD1IyfZUGUCzA/PlTXAoNKWcGUCmTV/O/It7d3GMJIWBD1K8Do4pccVeJNe/7geo4aQSje92wqVc5GpDVh83e5epPh9DPokYf9nEZyUvBC/X358Ig/NXegK6xxbStFQGy4h8pTifia7hT8x2pQFrMpRTq5zvp+iVscIP17bcs/sZiG3kgpUQ+c+HyEyd6O2H7zS2phM7tA+GqHrJGpWM3TV+5yndiHdImrKRL+J2DXzs0CMrKcgKYR2XZqqAJL3UaxP7aLpMBWDpECrrFdHa/iX0jXUNyzGn0MEyBPIJeTu5clkkaFVX2dzMaGWqRGDZBbxdaBl58vRKr2Ag6CGVmijxv3BlOqcX/dE0JjOf2eQwtCHEKk/B7n2VRTpck8x2w3XAzUfjR9GcadXpuBEv6WHqFb3lOa+IEvFxpn+uumSE8IvPLK5HZLjoMfoGckfTi7HNvpahTcBpCPlbmrwiFFJ9Xa8zY1MJzl6dsUILvc5iRmCRulb5ET+eIrTk30lGUfrHvbc1UmJah7u2pqXZ
 ZPVe1zCv
 ZRrfDz1JGDndccUtajDEphXFwSAza13VIqm0i9XjOz28OTEHNWKDG+uAteQKFir7GokEU7jAev4ArmRuTc2omk5KZurT+5OR0G7LeFIZ2kXFmOn0nfHXlI4fF0xhGuI4h/ULt0S5f9aGFP2IBufnw6R1qB80ec7r5fM+n/CkwiLqY7OnCr8ZxnwredBV5JGNjKxlHHTeGFswR4q+hdKQCVG1EYhI6E6VH4PSEvmLojaVqttQga6KIJH9EqnJ/nPxnNJVy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Apr 17, 2026 at 11:57:54AM +0200, David Hildenbrand (Arm) wrote:
>On 4/10/26 10:19, Lance Yang wrote:
[...]
>>>
>>> #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
>>> diff --git a/init/main.c b/init/main.c
>>> index 1cb395dd94e4..07f2ddbf9677 100644
>>> --- a/init/main.c
>>> +++ b/init/main.c
>>> @@ -1044,6 +1044,7 @@ void start_kernel(void)
>>> 	print_kernel_cmdline(saved_command_line);
>>> 	/* parameters may set static keys */
>>> 	parse_early_param();
>>> +	init_arch_has_pmd_leaves();
>> 
>> One more thought here: I don't see why we need boot-time caching.
>> 
>> has_transparent_hugepage() does *not* look expensive on the common
>> archs. On x86, it is just a CPU feature check. MIPS is different, yes,
>> only the first call there is more involved ...
>> 
>> But if we *really* want caching, couldn't we just do it lazily instead
>> of adding another early boot init step?
>> 
>> Something like:
>> 
>> bool pgtable_has_pmd_leaves(void)
>> {
>> 	static int __arch_has_pmd_leaves = -1;
>> 
>> 	if (READ_ONCE(__arch_has_pmd_leaves) < 0)
>> 		WRITE_ONCE(__arch_has_pmd_leaves, has_transparent_hugepage());
>> 
>> 	return READ_ONCE(__arch_has_pmd_leaves);
>
>Would look easier when just using two booleans: "has_pmd_leaves" and
>"probed".
>
>I do like static keys, though. And wonder whether just putting that into
>hugepage_init() would be sufficient?

Probably sufficient for the current callers, yes, since they are all
THP-related :)

But then the helper may return false simply because THP is not built,
rather than because the CPU lacks PMD leaf support, which does not match
its semantics very well.

To be clear, I like static keys too, as I suggested earlier ;)

Another boot-time init step that depends on specific init ordering seems
a bit shaky to me... At the very least, we'd need to document that
ordering very clearly.

Cheers,
Lance

