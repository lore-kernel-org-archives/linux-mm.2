Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 694E8CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD21E8E0133; Tue, 14 Oct 2025 10:38:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82B48E010A; Tue, 14 Oct 2025 10:38:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71318E0133; Tue, 14 Oct 2025 10:38:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 95D718E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:38:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A4771A0924
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:38:17 +0000 (UTC)
X-FDA: 83996975034.06.F632A88
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id 82DFA4000F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:38:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G7KAczSk;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760452695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ph45ShvU5LxibAKmRwrd9NsEUxkKQysF0rWNW9JCj9E=;
	b=uD+QC/+o3wmtaAhQusOxfFf5glswMSNZaJdV5ZmUYDSb6HEDfYD/9fnRZF4GbsgozTYSzR
	zWiqMkXGlKTd0HFRhvXWM9DgqYKRb2mWwp9ck/dxtC9Mp4RmOO47DbrcDnuLZS5F19YYwF
	dR9rCvIO6kWgOYr6LqOrt2PChbzTx4o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G7KAczSk;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760452695; a=rsa-sha256;
	cv=none;
	b=h5a9XY59HLky/5/UD2KHeSjV30aJaJTPmwDVK5p6bKrgUe3T3AwYhyYDgpi8lzcM3F/WzS
	LpJrKEFRDcQsZIrlnqgO68ArC4pTZACu48K21TIgjv8JtkCmpyaXNt2XgPQj7cIqscH9uk
	zZmXTac8jjYA92vaKWvHoRGfC2iTzIY=
Message-ID: <2e22cff1-fad7-45a6-bdd4-d5921d12c5e2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760452693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ph45ShvU5LxibAKmRwrd9NsEUxkKQysF0rWNW9JCj9E=;
	b=G7KAczSkogU8fLCXmjILNi+xkzGOvqobi5PzscfO4BTFXWU/rDzEBllPdzGmDpzXsyEFX9
	Qlky5S9AdHOpkGfRZpQtuXjHWNCe4jYCqtZFYbrzEzbwbJiD7kct25j/TjTKMsKQwZ1ALy
	rgMcbkTVubIVoWzJjOAMjHNusy6wM64=
Date: Tue, 14 Oct 2025 22:37:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
 <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
 <6f448506-677f-4e0c-aa9c-d5da061e57ee@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <6f448506-677f-4e0c-aa9c-d5da061e57ee@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ewb1i19cfnd9rprz5kwxqrpho56hcwni
X-Rspamd-Queue-Id: 82DFA4000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760452695-638715
X-HE-Meta: U2FsdGVkX1+fWKxvaEAkhkP8YjlaPCV+hMHXeV+jRPzeRecLFw9aB4cFIl+hOtLGlqQT+NcVA0iAy41ZLQrzETue5dPcV3QG3pj+JK+2mSZCw+cN7qPmDdGHXo32RUD42/n6cBLFrRbFEuTKLqRhl+8cKO1AR3uHyNxK9ZSimEWf4Kva8B1dxnTCOpBlSSVbVcUgKi5podTPrZcyprAuocmlE5S3ZK8VRSZZnR91K9G26iYBx3GTcXbTxFkzh3zE7r7yfo6upvVJ++C4iKPU/bPR0TrRXOw27J/3VaSGJ5dXVsYTHZeXuBuizDKhqbYgKAdiF/k08qy7fJpSX0ePRveW9y7jYN9nTJFmxCMw3YvQ7loCsXDZb3hop/Nr2+FpMj/pVqN/QHlmc91qyK5qJLvlMBUEH0uMwqkVXkf8lvYM0z3gshf076XfCt2+3/UvpfmGJDtYLDMM6Q6UNCHqFfjuXZCutSHasnGtT5ng8SHAcuV0DdLfVVPyF9SGz4nDodbRKzzsiKgAp2yKSziblb7/kjLm6xkLKPC5lWF0g+avQhug/BxiXMoWNTdSNGUKe2RWOLZ0qb9uG30NmA4G31N8wUQUVyocvZfCtLyi6BZoXev6Y4zbT1C6AYwBywRsp2HmRRJIGyZc3HZCQ1h6N651fo0scgDM33ugW4exNUH3378QfddYb6JAhQKjgDyNEiCdOP94JdHFSQtNpvJDyfEh9J4ErH8dacSlLOjQBPnNewthC96qK6xlA8ecA5h6sH5ZdmTxfAwAEl/GKR+kUAgnSMgWVUVFDDPRCf1GZyk6dn680nDHjYVE6Fd9MHUsMARdUwg8taF+IJo6DI79C8dRXvMfbGmOYsEnIAfcrnOBPRi3wrbKVdoMZx72V3YcFJxrCsAQwef3PqaEir1/EtrIpcAE4WCzPW71XbYoSSMRO//bLbjEyc6vlQiGycsVmAhVZLV4OsbYQ2ydu4X
 QpRwGwDh
 taEC8kEPOyYvjiXwAidg28hOxufPfr/eRzNKLCn+W/FhaRKl/E731thI2CN5gyKljK1JuBlahDx/tbXW+Hb8f2/REPvJs0FK1GLp+bXD4yzwrcRm86NKzFkB5/r9yyR8Ux2+Tty3Emi5ckIi9YjptPu8y/f8rzyUkhRu9d1A38IXAdtjzvbFnZyPzBQav1aTHOxrvKx4RPeSQRqOKuB3piqKOf/fQQcIolmYcpsNUjZ1czAmU5+uK63UcfjeT+Bb7pynAtz5sNorLVPMoLSm2VF8lPZ0IcBi+w+4zXvv1zOAkJD0v3Rq6x8VYrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/14 22:32, David Hildenbrand wrote:
> 
>> static inline int pte_protnone(pte_t pte)
>> {
>>     return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
>>         == _PAGE_PROTNONE;
>> }
>>
>> static inline int pte_present(pte_t a)
>> {
>>     return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
>> }
>> ```
>>
>> On x86, pte_present() returns true for a protnone pte. And I'd assume
>> other archs behave similarly ...
> 
> Applies to all architecture. prot-none entries must be present, 
> otherwise we'd have a lot of other issues :)

Thanks for confirming, David! That's good to know ;p

So @Lorenzo, looks like we're good here on the protnone front. Does
that clear up your concern?


