Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58CB2606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 06:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bJonDl0C
Received: by kanga.kvack.org (Postfix)
	id 7A2816B0AF9; Fri, 23 Oct 2026 02:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72BC26B0AFA; Fri, 23 Oct 2026 02:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3586B0AFB; Fri, 23 Oct 2026 02:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 370346B0AF9
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:37:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA0F64034F
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:37:35 +0000 (UTC)
X-FDA: 85352934870.20.A671796
Received: from mta0.migadu.com (out-64.mta0.migadu.com [91.218.175.64])
	by imf31.hostedemail.com (Postfix) with ESMTP id 26AE420009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:37:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bJonDl0C;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.64 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792737454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRUq6OnGXL2wlDLuy2Qj0QtCSFDuIIO7KpdyvPeLi2Q=;
	b=nMueOkGTJ4/POkDdKN6c84UHHdPRJIqHGjFa0zCIQTVAdz7cPPaOhgeyO9u8WgQRhRC8pr
	XrfL83IJ7hnzF71pWUibooaXEY1ugJPKXDooISpIo0hS+N737/enymsXmiVONmh73A496p
	YbV58dEt/KY9Rz6XdDG7clL9onXjM2E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bJonDl0C;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.64 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792737454;
	b=h27slNPQjYrGriZtz37g4gPXioh0AA8pULJQ9cEd6KL+tkHNxdXlLJb26l+YbSRNlK3/w2
	NzU0MmIlxKpHz2PISJ7cFiGE1xSXdt1bct+TeguvNoniXcW7o9MxWofy0XmtLY+3RGyY4B
	YqHZbliFFELZb3mG8oVC0jAPSQcpW7c=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VxAlEuUl9LXtPCmJJe5vxG0UbJnUdNJ2BgA4diN+u9A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792737450; v=1; x=1793342250;
 b=bJonDl0CACNDQHh7qThbudTAaixIaG6O6tD7kERLO9DPU5slNL3P5yDD24ZWcdkLkuhkLMST
 uuqZqUe7QVYX3QxMcT5geBi8vmnYe5OdfSzMidhdAfRQ0jwOM+CNRqY5uiIdN3VsAxsp9bqNZX4
 y3B9RyaEfa5soy7lE2MDLcas=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 8830e17c029f41a8;
	Fri, 23 Oct 2026 06:37:30 +0000
X-Mizu-Trace-ID: 8830e17c029f41a8
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 3/5] mm: hugetlb: track CMA reservations by pool
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <b37a33e2-7dfb-4401-847e-919f0bd61271@linux.dev>
Date: Fri, 23 Oct 2026 14:37:12 +0800
Cc: Qi Zheng <zhengqi.arch@bytedance.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 david@kernel.org,
 osalvador@suse.de,
 akpm@linux-foundation.org,
 azpijr@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <6FC136B3-95F8-4F68-AB11-44D303AB374D@linux.dev>
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
 <29b35f7221c30f1dfa320a933f6095f37b612a37.1792651104.git.zhengqi.arch@bytedance.com>
 <b5745b31-adec-4158-bba4-2c21dbfe2566@linux.dev>
 <b37a33e2-7dfb-4401-847e-919f0bd61271@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 26AE420009
X-Stat-Signature: f4x4etrs3uxgzf8ftx7wtxcf6szfx4gq
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792737453-761811
X-HE-Meta: U2FsdGVkX18iH+PLH5jH3YwbBAhoXgiKWMQX1QSUu/fm78u7h/HAGj0xigL4nnZK2dfWULYdBrEvr6Ad4TTn+os/j/AquPGBg07ZhNUvRogR3zfjiqRHL9hNMskOpWeApqcsEmhs37cxGSZZV2kF04VrxTxUMXYcSaKN6Bq82DJHYwbDAuGePT2eInztLfbfr8RnYcaTxzL/isKGgdxAu8IgWaEJjEAzZkGYFDPMPKUXrIr10Ho4AjQMLacDHYQHebalibLbwFO2my3fJU40m8bGTwaqcyajRNWcm58Fkg9qP6CHA/r6jAMWBWF7+TSTov2AjXRe07c0x6an0LHNJtWfMa4izXHtk4ouPz03UXp1p98jO3wTIw+2yHlinK396OKJ2aL/ShXHcVpiWgegMH3gAnXhNdYV92IeHFR2/I+fFNXvtNjkXzNfYDMal9e4jDbaz1UeRpIlGDe3liZybrv/nP9Z7GjWCADV5ARi7/nmI3Do4GpCZtu2rYvCIEUbBFHIzb08rPa7Nvz4sRT4l1v4zO9B2iRvSI/Cd/AZFixWfKK/32XdFZ2UjE33jwK5lq5szGBMjq82tPV9SO5byuYw6dUKZK7ewLEt+VXScw2qY6R7hT6F2aTiusC8QFPeslrdNsQS2cwmpdN1FzDXC68bpccTfSXaqMLjauGU3MKperW6moAYD70RZJRmmRlrYT8Q5vdwiruwc8i5Iy410nKyz5BvpD1mTJSQvFCf2sa2vji6/AvNWMbXk/mafktfun9+RXZQ/lI7g6PF6zN+BBtdz0MHPf0dQbPfXSrmy5ScS6C+KcUDlvsl+Pypykh6lW9ZxuG9pxazmdQlOYTWA47PwaXmJ2PxoiELIhbksbh4fTf9oaTFmUmt05pi4LAa3he5nN+UY2s3t33bhjBd6Rf1pQMNNTqSLi1iPnUeVzbvloAr5loIEb+sMfCbnwljTZb9NmHeeEewc9BhDBF
 hKR4cw1F
 4fDfWzYk5o8q4Wb0O5W7PRIsVS5LLm4S0l5EX0mpUocrEZ7E/H7uhOxB14eFWkEwcssDZ8sp/+FT5O7SG0tHR09DRUodCNqHHSLvfUJT6+Bs+HCjodVDkYehgvAdbEwPk4JrqMpAFBaIVk46DsmA0tZUpq5XAuzLjLhSe9ymPM94jiOwdk35ljKwX5r0P3S+bVnCT9yS1Ea7dYlmhCoV5JuuTXlEpFLIvrE8KKhURzXESk20mT8sAf+Q+cu+cMD9twx8VMTrCEL84jizCNVFmxbp8r8MtO25oyUOf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 23, 2026, at 14:35, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
> Hi Muchun,
>=20
> On 10/22/26 7:21 PM, Muchun Song wrote:
>> On 2026/10/22 15:31, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>=20
>>> Introduce fixed default and PMD pool slots in preparation for =
PMD-sized
>>> HugeTLB CMA support. Continue accepting only the architecture's =
existing
>>> CMA page size and keep all gigantic sizes sharing the default pool.
>>> PMD-sized pool support will be added in a subsequent patch.
>>>=20
>>> Select the pool for allocation, CMA-only checks and boot-time =
accounting.
>>> Release folios through the CMA area that owns their physical memory,
>>> including after demotion.
>>>=20
>>> Record each pool's successfully reserved capacity and remove
>>> hugetlb_cma_validate_params(), since the per-pool CMA-only check =
handles
>>> missing or empty reservations.
>>>=20
>>> Assisted-by: LLM
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> ---
>>>   mm/hugetlb.c     |   6 +-
>>>   mm/hugetlb_cma.c | 154 =
++++++++++++++++++++++++++++++++---------------
>>>   mm/hugetlb_cma.h |  11 ++--
>>>   3 files changed, 112 insertions(+), 59 deletions(-)
>>>=20
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index b37d7d0db7fc9..6b08074d11f52 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -1368,7 +1368,7 @@ static struct folio =
*alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
>>>       if (folio)
>>>           return folio;
>>> -    if (hugetlb_cma_exclusive_alloc())
>>> +    if (hugetlb_cma_exclusive_alloc(order))
>>>           return NULL;
>>>       folio =3D (struct folio *)alloc_contig_frozen_pages(1 << =
order, gfp_mask,
>>> @@ -3635,7 +3635,7 @@ static void __init =
hugetlb_hstate_alloc_pages(struct hstate *h)
>>>        * Skip gigantic hugepages allocation if early CMA
>>>        * reservations are not available.
>>>        */
>>> -    if (hstate_is_gigantic(h) && hugetlb_cma_total_size() &&
>>> +    if (hstate_is_gigantic(h) && hugetlb_cma_size(h) &&
>>>           !hugetlb_early_cma(h)) {
>>>           pr_warn_once("hugetlb_cma is enabled, skip boot time =
allocation\n");
>>>           return;
>>> @@ -4338,8 +4338,6 @@ static __init void hugetlb_parse_params(void)
>>>           hcp->setup(hcp->val);
>>>       }
>>> -
>>> -    hugetlb_cma_validate_params();
>>>   }
>>>   /*
>>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>>> index 4f27eb242dc3b..c279c3f548705 100644
>>> --- a/mm/hugetlb_cma.c
>>> +++ b/mm/hugetlb_cma.c
>>> @@ -19,6 +19,7 @@
>>>   struct hugetlb_cma_pool {
>>>       struct cma *cma[MAX_NUMNODES];
>>>       unsigned long size;
>>> +    unsigned int order;
>>>   };
>>>   struct hugetlb_cma_config {
>>> @@ -27,14 +28,34 @@ struct hugetlb_cma_config {
>>>       unsigned int percent_in_node[MAX_NUMNODES];
>>>   };
>>> -static struct hugetlb_cma_pool hugetlb_cma __ro_after_init;
>>> -static struct hugetlb_cma_config hugetlb_cma_config __initdata;
>>> +enum {
>>> +    HUGETLB_CMA_DEFAULT,
>>> +    HUGETLB_CMA_PMD,
>>> +    HUGETLB_CMA_POOLS,
>>> +};
>> Since there are exactly two pool roles, could we make that explicit =
with
>> a typed enum, for example:
>>       enum hugetlb_cma_pool_id {
>>             HUGETLB_CMA_POOL_DEFAULT,
>>             HUGETLB_CMA_POOL_PMD,
>>             HUGETLB_CMA_NR_POOLS,
>>       };
>> and name the array hugetlb_cma_pools[]?
>=20
> Make sense, will do.
>=20
>>> +
>>> +static struct hugetlb_cma_pool hugetlb_cma[HUGETLB_CMA_POOLS] =
__ro_after_init;
>>> +static struct hugetlb_cma_config =
hugetlb_cma_config[HUGETLB_CMA_POOLS] __initdata;
>>>   static bool hugetlb_cma_only __ro_after_init;
>>>   static char hugetlb_cma_cmdline[COMMAND_LINE_SIZE] __initdata;
>>>   static unsigned int hugetlb_cma_cmdline_len __initdata;
>>> +static struct hugetlb_cma_pool *hugetlb_cma_pool(unsigned int =
order)
>> How about order_to_cma_pool()?
>=20
> will do.
>=20
>>> +{
>>> +    struct hugetlb_cma_pool *pmd_pool =3D =
&hugetlb_cma[HUGETLB_CMA_PMD];
>>> +
>>> +    if (order =3D=3D PMD_SHIFT - PAGE_SHIFT && pmd_pool->size)
>> PMD_ORDER is better.
>=20
> OK.
>=20
>> There's another question here: why does PMD-based page allocation
>> need to check the pool->size, but gigantic pages don't?
>=20
> The PMD size pool needs to be checked here. The check for gigantic =
pool,
> is deferred to the caller.
>=20
>>> +        return pmd_pool;
>>> +
>>> +    /* Preserve the default pool's use by gigantic sizes. */
>>> +    if (order_is_gigantic(order))
>>> +        return &hugetlb_cma[HUGETLB_CMA_DEFAULT];
>> If we also check size for gigantic pages here, would the code be =
simpler
>> that way for callers?
>=20
> Yes, will do.
>=20
>>> +
>>> +    return NULL;
>>> +}
>>> +
>>>   #ifdef CONFIG_NUMA
>>>   static phys_addr_t __init memblock_node_memory_size(int nid)
>>>   {
>>> @@ -56,10 +77,16 @@ static phys_addr_t __init =
memblock_node_memory_size(int nid)
>>>   void hugetlb_cma_free_frozen_folio(struct folio *folio)
>>>   {
>>> -    struct hugetlb_cma_pool *pool =3D &hugetlb_cma;
>>> +    unsigned int i;
>>> +    int nid =3D folio_nid(folio);
>>> +    unsigned long nr_pages =3D folio_nr_pages(folio);
>>> +
>> Please add a short comment here explaining why all pools must be =
searched:
>> after demotion, the folio order does not identify the CMA pool that =
originally
>> owns the physical range.
>=20
> How about the following comment:
>=20
>     /*
>      * Demotion can change the folio order, so search all pools for =
the
>      * CMA area that owns the physical range.
>      */

LGTM.

Thanks,
Muchun=

