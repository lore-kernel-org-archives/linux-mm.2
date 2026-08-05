Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3B7EC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 10:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B2F6B00A0; Wed,  5 Aug 2026 06:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF40D6B00A1; Wed,  5 Aug 2026 06:03:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09566B00A3; Wed,  5 Aug 2026 06:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77DC26B00A0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:03:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 109F61603D2
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:03:31 +0000 (UTC)
X-FDA: 85066778622.13.A9DA6DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 52991140009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:03:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3W2w0pT;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785924209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MwtspZMnFWA7BsVmyrJkIUlpBk6kNAmUxfeVp4Cf1pc=;
	b=tDBKlRSzIL1is+/irPeQtdDnDVOk31OxDYQiCagtOVG60gwoz7mCscQWniUEJOaj2lIrSy
	/FdMh+v6tRytShqAVWoVAmybPPNeja4q5huT7XjHcNR5k2KRY4krtBFkGd6zGf3mtF5p9E
	cxLVRLMOUQRHg6NVdlHmnKESYmGQjVI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785924209;
	b=haSB06yu3MIQ0s8EpftpNLRgsgj4IiX8G3rGcZHo/scttmR27R0FrRtLpKIgYNLF4jJbTR
	NwEI0Pqms5nR33T66PjonJIqfv7lH5wyK6Ba6qGL4f0zEwtpEwH5yaWJYuSD8nX7ZapxXf
	pDCKDURKp+7Fr2YEKKIS9gKf3enk9K0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3W2w0pT;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBC8D600AE;
	Wed,  5 Aug 2026 10:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8C01F00A3D;
	Wed,  5 Aug 2026 10:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785924208;
	bh=MwtspZMnFWA7BsVmyrJkIUlpBk6kNAmUxfeVp4Cf1pc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S3W2w0pT4H9XaHeVc3HvSp4e6zheDeu7X5ZWPFNNRqiiuueGH06xDeAlFmnXdk3db
	 HrShB7eMwOiofu4VTNY3lo12/kxB9fV02xBLwAvZjbOeULv9ajKJeSucjVcYCqsGEd
	 crmHKxHiV3483alYvtccbiz8IBY3AHXoH05eHAIa2e6d9KJmdyCzE/pBFXMF9KBCWx
	 MTD/30gGuw2TGcbGRP3iK6B1/bnno+pGQH6S8834/XWtpKmTdZ1OjL8GJLEJ078ium
	 Tv/DIFkxBXEVT1i/YkmBMO/cSRmcHCIXOVEiLT7oVKOlnkOqdxf63j/oSrhgisMMuE
	 Xf1XlyNHZcT5w==
Message-ID: <aaa9503a-348d-451a-b44f-9221517803c3@kernel.org>
Date: Wed, 5 Aug 2026 12:03:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: fix concurrent access issue in
 min_order_for_split()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: dayou5941@163.com, akpm@linux-foundation.org, ziy@nvidia.com,
 linux-mm@kvack.org, liyouhong <liyouhong@kylinos.cn>,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260805072625.2437636-1-dayou5941@163.com>
 <dbdb0f70-669b-4c68-a9cf-89d30c20f12f@kernel.org> <anL_I_2o3vfAaRLr@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anL_I_2o3vfAaRLr@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 52991140009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: c89pa7biqj1szgojdprzondc6m74fruu
X-HE-Tag: 1785924209-601808
X-HE-Meta: U2FsdGVkX1/hM0baO67pjjkgMtokt0JSHd7iCxwV3aFX+PhNoV0z7uNd//KZk4ZgybA4J+gD2mcwZ5b4C4fO4XYvpyjS/KTN7RLfHkYUcIqrD5ty6YqvHWhZs4gZ3cWoqmI0T9HLtxQP1SQGREVMsjNvyiYfIPAPSEFCuDOUlmWeZxppm11r9Hm0fxSb4t6iMoPDfPkOx+86/apyzWVlF96ApMXm0guzln0dG/eOtdi4tafnqIlYw1IfPRwnv2opDXuPoLX3eScKWAtOWMbPxb5M+La8jbuDnGhtFw9GVDe63Eccua6kyygoNghBXI1J2poNtgcJ1qfjCox7fWGbhLQ7Tsv51W6lrl1JUS/2QIRyKAz8z9FkfY7Vq2v57jAA+H0DrCEK7dsUbiMt+NSCnKYWogwiihMlxvwoW1dvBElyfZRAE4m2C/dS9pyVGJjgpV2Mh67h6jjsnmnBpbuXh/o24+iV2ySQNVddoDE1y3wUanpM0krF20qTgvkTgQ2lPVXvpSkiWHv29ecsq3tolJK5Xcgj9mM9xSqgB+kFdmMGLZbxO2xEcNItMvxk8vjfpfZuHwGiT9yK8m0HWDwFKyCIH3lKwP4DTOmra2Uk35miAjzgIT6Ms8hi8mNARIf4XwkkbbBCzx0830qt3pwQGJtibc6mVTYTpEk/JxwplN48BsCPAVN/RFI6g7lq58HzNgAVBYvqFpeUsscQrAVC3Liti7hnf6vgwrzz1pJWAq1nipWmYVqPOaoiUZ0JMTBipkc7v8f0LzYnS7cWbaQU6oXpLZCYpiN1WcFvoFMgdoUn8lo+TxJ6n34m4VQBzubZISBYgAr+eB4dIb8sRXvZFc1H00cC2AV01v0CyKD27s+oIT8OnKUh4lIJ+etjbSc+KjQoBoPGG64Ntwg/vNEzYtp14BHWVsCgq0QzbRAro+tC9CZDZM8/SAtg5E4dx4+l5jHlLfOGzMinLfcQE+V
 4uybwEkZ
 j64kwmqumKzewcb0VNxqNE+EjF7os8XJIwgO2+8L/SmHYiW8vp8/s2+OrhWS43sJDwIdgtZgzuTgxrA7m+IyLoBe+AkVeOXFTxJKMOlPZV0acoBBHdmhUtETCHB+fU8uFVp3bTw/drchuzMfAJs0SVgtJ7p5f7o/wopNXtZt+/iRUyMK358DrSpQtbWV2KyonJ8HWgQdwsThow2qbcX2COii17uw4PPCtv5hpyu7x9Gf5dZI5pFEyRXuHchplBKkL3t4jI0C6VW3HSlmNlA44M+kqxlJxHwfDCpIflOnZlc3aAbdFmV/ZDmyI2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>  	/*
>> @@ -2862,8 +2841,7 @@ static int soft_offline_in_use_page(struct page *page)
>>  	};
>>
>>  	if (!huge && folio_test_large(folio)) {
>> -		const int new_order = min_order_for_split(folio);
>> -
>> +		lock_page(page);
>>  		/*
>>  		 * If new_order (target split order) is not 0, do not split the
>>  		 * folio at all to retain the still accessible large folio.
>> @@ -2871,8 +2849,14 @@ static int soft_offline_in_use_page(struct page *page)
>>  		 * preferred, split it to non-zero new_order like it is done in
>>  		 * memory_failure().
>>  		 */
>> -		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
>> -						       /* release= */ true)) {
>> +		if (!min_order_for_split(folio))
>> +			ret = split_huge_page_to_order(page, 0);
>> +		else
>> +			ret = -EBUSY;
>> +		unlock_page(page);
>> +
>> +		if (ret) {
>> +			put_page(page);
>>  			pr_info("%#lx: thp split failed\n", pfn);
>>  			return -EBUSY;
> 
> Maybe return ret here? Seems a bit pointless to set ret, gate on it then not
> return it (even if result is the same)

I didn't check whether a caller actually relies on -EBUSY. So I decided to leave
the behavior unchanged.

-- 
Cheers,

David

