Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E366F01826
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E966B0005; Fri,  6 Mar 2026 05:47:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80C736B008A; Fri,  6 Mar 2026 05:47:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718206B008C; Fri,  6 Mar 2026 05:47:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5CAA26B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:47:49 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1CE2EC1F6B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:47:49 +0000 (UTC)
X-FDA: 84515312658.12.4C6C32D
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 41E8840006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:47:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NOfHMeXp;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772794067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjPP1MkY7cVIKE6dM0lngCXvsWMfl9x5zuCWaBUpV24=;
	b=1Ly0asPILvEJ3Icwfm3uHS4iBG/nZodaoozhqLMzOhFOyIyyvIdoF+dXoz7A+swg8b71Wp
	1UinTNgfd446zlV4jfZTSxTzCkcbs+J2GRD88vPj+MOyB4tVjjGgPqw9tNks1niBCWJmb0
	UHRyk2EiEoaLW2y7MmyoB+tb2UEosGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772794067; a=rsa-sha256;
	cv=none;
	b=2BC2Vq1rlvZWYGxFch0928NnT45R2CPBpb5tb0uoTeSd35ULql0U1rC2r2mFTal/dpt49b
	x26W5k1rRjhr9Xs9Idqb5ZhuTNj/YfqlKnNr3yuLp/KyULwzloLhpCYonGCD8FAtL8HbPR
	lzvSnw+0/0UIzOi0uJELV8JqGGNkB4c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NOfHMeXp;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <3dd4399f-a138-4ec0-b3a8-0ce200423ebe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772794065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tjPP1MkY7cVIKE6dM0lngCXvsWMfl9x5zuCWaBUpV24=;
	b=NOfHMeXpi6Cr3mGYireNzPc4UXDrWxm689oejv2P7DpZe+niwQ5cKFZE8SCUo/wX3HR8w5
	tZ/95TAThil5pEgo2sRPydEcoEMBDApYOgLMl1L44qQnR4nMQ3QDhEcdqIoKnQRa2iskft
	E9KTe9lhlr6eUH37SMjT6k5fL1LIIFk=
Date: Fri, 6 Mar 2026 13:47:35 +0300
MIME-Version: 1.0
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
Content-Language: en-GB
To: Zi Yan <ziy@nvidia.com>
Cc: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Balbir Singh <balbirs@nvidia.com>, Kiryl Shutsemau <kas@kernel.org>,
 matthew.brost@intel.com, npache@redhat.com, david@kernel.org,
 Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, riel@surriel.com, shakeel.butt@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
 <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
 <fbae2102-3e62-4df6-96bd-e8600ef2f497@nvidia.com>
 <FA698C89-7287-4615-BDC7-5D1F6CFB770A@nvidia.com>
 <5e59c077-9f06-4e45-86e1-ca696e6105b4@nvidia.com>
 <622eb392-8c04-473d-b42a-ecdc489799c4@linux.dev>
 <942f2df4-6fb5-415f-b7d4-87a83315890b@redhat.com>
 <f427c5f7-93d6-4eeb-bda6-5e40d42f2bba@linux.dev>
 <80683d6d-ea38-4326-af5e-e4c173bb1930@redhat.com>
 <332c9e16-46c3-4e1c-898e-2cb0a87ba1fc@linux.dev>
 <CDBCA254-3E40-4BFE-81DE-70DAC9D4222D@nvidia.com>
 <7996d5c5-24db-4ef2-b88a-1b9d33f9e976@linux.dev>
 <1EAE2E58-7A71-4B59-B1EF-3A3C753DDC1E@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <1EAE2E58-7A71-4B59-B1EF-3A3C753DDC1E@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: uui8y5x6n43efux7agzecrbakzxk8c1d
X-Rspam-User: 
X-Rspamd-Queue-Id: 41E8840006
X-Rspamd-Server: rspam12
X-HE-Tag: 1772794067-344019
X-HE-Meta: U2FsdGVkX184cf1QLlQKSnYBro42pRiolqTFfjWusVm4QgkKJaRXW2Yqlbepuojff/7LoyBdPVsJctU1pX2kzGIUHgcdX6BRDz8a8yV/Z+MRM/6QhGLKirofxKlsXkPrPePzIlyjarAFI+LbbTpoVva2MPCX3GzqSj1GkTiRFgxRDGIVjfY9iH5JlcxZvWLyo81XwX/sj+U6+oUCAEmaOTxzMS4SFnRA/8xFQhUCCV3xNk22N86Vr4z5Fb0NU5hlIpLvQTiuRjvPB6c4kHOaQRtIrPrJZRBwnAN8C4kCiP2I/2trZA29betQ3H7dbHcpOnlbwy2DA9lx89vkItO442LbPFfwU4WfpLPdSNYf+sEAmeOsuPwb1hHXMa/pP+s547JT5z7YCApeWLnAs2nP28XBkR2YufVIYP4S9XKy6QdaWI6t2bEiiPvrpvmnj9XmCzhmx1yzbdESr8mAJLMzzCCJFa7Hv7z3vWo7tWMZopR+Us8Y1+5abx67anSfNdB3Iir8YToBtRAkmbCFmXErOAbp77H9lkfhLwfGq8y5kGNfZMG87zB0rna3ZT1yn7oPtqmNi5PNOaMlNSjmlh3nEC2tYmOoodNALeinY+gZN45MCBiU/+uPxT4mmXQok/s+JRuL801gc56FVDKuF5t00GkGLd366gRxSeTLBJyGmjoetX0VaJaHBtRlFr35Qp8vIJyuBqluNENml1lrLPayAEEFh8BDDCErcbp0eIDBkg7e/18Q864lY4aQe/sHPxGL+1kHaLEk9kQq1OZFBiUyFuLC8bszBOASPlHVTihSVQtJfNulwU/TGo0GrQgR+Z+5qt2SwptOnzCqe9B9GZoWhWdH9Gim9Q0CxYvHHlUfr05d/7hoew6TZWRRydDGCM7YlPQweEzAPHokrphpM1FLF5J4SQR0AYe5bjyS/CFaiSNKYyMwHHH/V/dPeaxvxWvxaxcQgzyVSJgplnVKzQl
 DLTUDGir
 5Qy69iwslrCxhCNeE16G6HZ5gc79tiNT8fP1TkqrIPXBk4fZ5n7EqEGM5C8+XLPDNgGLNIGVMysg/u/rHkkhl4CYKg/9QRjR2gAMAJwaA4NFRbaLAcVD2mqy3MqtyYAO2RoT+MM72hhxnsisRuLPkNIh0pg9U2vIMNintokJi3zhcsKa6NHdqtUZ/dYSM50cf3t0ZhMhp3L7VzaPmOYYuJiZnj37wEh9qfxPOwZZt+y/1IPODFU+o1TI9KO2mhs7fdx0dMVfxZ3xVI9PLx0FgFBRMgQA1jmxqozCs5qKlcubXTwMAVoUcbuzkdoZNTj7gwyuymRKJSuzFsh5dW7u6xQIs6bSGkyYCq/8OPpJRih7sOIPFqBGxddgZgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> I do not think there is a need to explain why there is no folio_put()
> below. How about below?
> 
> 1. it makes sure the folio has the right ref count,
> 2. it explains folio_get() is for split_huge_pmd_address() instead of
>    folio_split_unmapped().
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 0a8b31939640f..0b31b878210ba 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -914,8 +914,14 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>  	unsigned long flags;
>  	int ret = 0;
> 
> +	VM_WARN_ON_ONCE(folio_ref_count(folio) == 1);

Thanks! I have sent it in [1]. One thing is, I think you mean over here
folio_ref_count(folio) != 1, right? Thats what the patch has.


[1] https://lore.kernel.org/all/20260306104409.3915811-1-usama.arif@linux.dev/

> +	/*
> +	 * take a reference, since split_huge_pmd_address() with freeze = true
> +	 * drops a reference at the end.
> +	 */
>  	folio_get(folio);
>  	split_huge_pmd_address(migrate->vma, addr, true);
> +	
>  	ret = folio_split_unmapped(folio, 0);
>  	if (ret)
>  		return ret;
> 
> 
>>
>>>>
>>>>
>>>> [1] https://gist.github.com/uarif1/65e1e816af7aa0ae38dd6ec64d62a993
>>>> [2] https://gist.github.com/uarif1/79ea9500667daa4e2ef09cb5d308f041
>>>> [3] https://gist.github.com/uarif1/8a35a6c65ba8b3a1c1dfe72dc30e821d
>>>
>>>
>>> Best Regards,
>>> Yan, Zi
> 
> 
> Best Regards,
> Yan, Zi


