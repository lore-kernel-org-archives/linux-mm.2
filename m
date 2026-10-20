Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58490606A325
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 10:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Bk8B8FqQ
Received: by kanga.kvack.org (Postfix)
	id 5BEFA6B0476; Tue, 20 Oct 2026 06:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F746B0478; Tue, 20 Oct 2026 06:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45DD36B0479; Tue, 20 Oct 2026 06:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2366F6B0476
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:24:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFF0AC0108
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:23:59 +0000 (UTC)
X-FDA: 85342618998.03.26FB49E
Received: from mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
	by imf10.hostedemail.com (Postfix) with ESMTP id 37617C0008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:23:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bk8B8FqQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.3 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792491837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0BfaLNG+1GrzLtNTyjqq5RXnkyj8x654Yffp8nh3UTU=;
	b=unGXkTgOj99I8Oa7fBTsml53fUa2GIPVqGGmXYq24tAu0wKx9r8aMYkpLl4NBtgwYETkt2
	QJOumyLttViiDSNILMi+BF3D3STZibx6jCOBQfq7fE/HE2qfYD8SrfHnSFvcUJl89khBa8
	3FoEXLxhiXYndrMyWGN/getOPPMjuEo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bk8B8FqQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.3 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792491837;
	b=WvtM+w0wA3s9GfkEEWpZcz5YGlgK0AKf/ZFNNZXqXkpSVnv4LGlJfdcCS8vAfVMHAKRcwk
	Wc9XNPHe5QapNica9x/0aB3Bof4alcb1DUdrulq/Fcdsl8KjYWtfv9/9iNfcXqb1wAw6aC
	ABoKMkvyNCWeXssk64vk9G5xW5/YNek=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Xq83IAnPUw5tLOBMvZbp0yp+dVx7BwR94kISZs+eFjo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792491835; v=1; x=1793096635;
 b=Bk8B8FqQXjRrNooy3YQnQXwAZjDSUxdkp+EubYl6LibCd/jYCmR42jmXIqgWdfGU/BX2lFo3
 vP1KLSnQ2QVtXuPO1sP00Tb1+nXmG780o8kRV8dnsOQPde3y6xKMH2/Q7X+6uFQnkw/Ekn8ws1f
 tRPpRKPdAu2plYTElnjcKvIk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e512103824f9c4cb;
	Tue, 20 Oct 2026 10:23:55 +0000
X-Mizu-Trace-ID: e512103824f9c4cb
X-Migadu-Flow: FLOW_OUT
Message-ID: <04c89538-28c8-4d03-92c1-08d854a46ac4@linux.dev>
Date: Tue, 20 Oct 2026 18:23:49 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm: hugetlb: enable CMA allocation for PMD-sized
 pages
To: Lance Yang <lance.yang@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhengqi.arch@bytedance.com
References: <df6eee954b62f41d65c4d087d17a7a7cf60da791.1792136742.git.zhengqi.arch@bytedance.com>
 <20261020091653.14959-1-lance.yang@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261020091653.14959-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 37617C0008
X-Stat-Signature: gipigemi1a4r8h58y789ihtitss1f83o
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792491836-573061
X-HE-Meta: U2FsdGVkX1978CkIOdNYfnnsrOB5G9cFXpk/hz9iK79rqiovnNXZp5Q9a4JDavIyfuD7hwX3jeChegnpys9O5Mvtz3uwEo2xSRIcuC4f4+sSOymL8RTcZanPIPViMDxHbGIHoO+EE3mWk5hoN1/V7W2N7u54Ymil1TXfbGQMgX+Pbm48dlkpwkWu9XKUCvALtbb8+GoTV5ZBRIHrVFTSzdP+wyYs9CFthUVHMeGQkWJKPmZeX8wbf2gKL+d8AlVzRbK/800xaMUIpfY27sXRJ/X612hUkU6g855UN6SCGPaI5hPyfMMtwOkL1RiwupTg7kYehRLBiUoHq7D0lT0o087XuaupVyQs5xEt8ZaXX6fizpbnU83/1hG6K92Lm6qx7TcXosBmSOVFv/PvDHQzNuVcTVBCxYys1IoWQsDYVlVSjPZuPkvDBSHF4AZyoeTgzMcmGaY9hBjpWkJ2M2BWqqdEqJe27/r6pq94EKOrpa0BpspUM54WF1knqS308W+pzfcU3jR2RtXbjdjkFTCS3Lhl8/zNPaV/Nq5tArk2GsRO5ySrgM8vptZuqkrhAq/40jzD+7H9bU3wcrxEf2CSswABAtwcavrmUbOFns7pweStAqdeklu4El4lAzSzys1vfZYAlsICgWnsdLaQ6OtrRe6ldZRvlNz3TCcslvqMQf48oGg1NbIX/6DLf1flxDW1oiGP18BKsm7C2pUW0mIsLXIDlgD55gmreFQ5luTY3ykEUe9nMhx3unK4BW0EFNmfBMbACk1wtfHsBXIgo0aEzeSpqBA6BOOfo65vOEMyHZVJHIJTWWQLYTlDehE5ws4j1uCPTYroNbM5MHwnwMNRRlfxnvYYOurXRlyuvQMxCOksOLxUmS661DReCHFxGyFqaoBYwNNkyj+hyVmsK4FKrQ4wJMoKIrz2Gpw5mmd1vWfySTfGXtk7Kh7svUL1IIH01/FDs+CT4i08rj2vB78
 IMsqPPLV
 t6g0iIIZKLRDFAcfSjmtFQFHjnr7yc1AeTKUT2OlX0CfZ6SY+QJVV5p6oXW4tn2i1p3Ctjsg9vANeO6Nu0oocHBTbxYTRqJWvL6zxqQ9xpVC7Fbwgco1JffD9YXz6Zip4zUkXNtbf2ZnG/de9umN5NqVVdLDyxFkDrAfoVwwby4YCEc28c/rfhzKucAfDYaKYW6PLnjxA7JAIuMVW/3RdWIA825rrD4oL2cqN5XaTtIFFZQIgMYIT2Qxu2V0jkmJIRro7UtwWTaoBxiHvV+DpX6CKieBcnObvZHJlD0Knt+Ys0/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lance,

On 10/20/26 5:16 PM, Lance Yang wrote:
> 
> On Fri, Oct 16, 2026 at 06:07:36PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
> [...]
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 218fbaee6f7e5..8c00fd9d0658d 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1362,18 +1362,8 @@ static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
>> static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
>> 		int nid, nodemask_t *nodemask)
>> {
>> -	struct folio *folio;
>> -
>> -	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodemask);
>> -	if (folio)
>> -		return folio;
>> -
>> -	if (hugetlb_cma_exclusive_alloc(order))
>> -		return NULL;
>> -
>> -	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
>> -							  nid, nodemask);
>> -	return folio;
>> +	return (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
>> +							 nid, nodemask);
>> }
>> #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
>> static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask, int nid,
>> @@ -1849,11 +1839,18 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>> 	if (nid == NUMA_NO_NODE)
>> 		nid = numa_mem_id();
>>
>> -	if (order_is_gigantic(order))
>> -		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
>> -	else
>> -		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
>> -						 node_alloc_noretry);
>> +	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nmask);
>> +	if (!folio) {
> 
> Emm ... what about PF_MEMALLOC_PIN here?
> 
> If a FOLL_LONGTERM migration out of CMA needs a fresh hugetlb folio,
> this can allocate another CMA folio as the target.
> 
> With HVO disabled, the old folio is freed back to CMA and can be picked
> again again again.
> 
> I guess we'd keep migrating between CMA folios without ever completing
> the pin ... even if pinnable buddy memory is available, no?

Yes, you are right. A fresh migration target can come from CMA again,
causing repeated migration without completing the pin, even when
pinnable buddy memory is available.

The same missing PF_MEMALLOC_PIN check also affects 1 GiB CMA
allocations, so I had planned to fix it separately.

Thanks,
Qi

> 
> [...]
> 
> Cheers, Lance


