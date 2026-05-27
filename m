Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DAECD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 16:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 188BF6B012F; Wed, 27 May 2026 12:04:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1399E6B0130; Wed, 27 May 2026 12:04:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0290D6B0131; Wed, 27 May 2026 12:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4A146B012F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:04:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACB9E1C0529
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:04:05 +0000 (UTC)
X-FDA: 84813671250.28.6A353F9
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id AE32BC000C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:04:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qZr8EQP9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779897843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0DofwycJUztzv8ieqZ6Ro3L+aNfF27V1vkVEXRjl8To=;
	b=XGcLheFc0gXVrDrWpB0lm+eozLKBbvTu5rK+L5aIb1Ll2bIVSonHFpsJco0+/FDAUEIDOj
	hiZTyYp4PsGCbqdG3bLtD9qqE45+VLRVJu7kzqJRB8tQ0T2kNDWZzYbAofJtRq5jUQ95rI
	0n8A7fLQsHIZyCk+vquNqvC+3uQr2cQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qZr8EQP9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779897843; a=rsa-sha256;
	cv=none;
	b=UasosXWKTl8wDhLcAKRyC47UZ2EUSmZgeEb6F2PJVHKMInBZliv1ZDSMRN4VcZqBqHDLCe
	I5Y+QTpG3t9N7uR2NroxAGywphSUbi3+62Bun2ZV3dC0xQdJkZF3rKFnmTPYedJbJw4GFY
	0cIrOUupDmvR2Oyk7+B9sl4PCAJondM=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-841ad134423so214611b3a.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 09:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779897842; x=1780502642; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0DofwycJUztzv8ieqZ6Ro3L+aNfF27V1vkVEXRjl8To=;
        b=qZr8EQP9l2oWhbb2by6P9EqvbJ1y5hjZEGeOcdKqq590QkWhNJPyN3eyxVrJdQUlna
         Nmdrn6J3L04so20UsfH2aNQPTs7+UFZkanRCuXtXXZm3wa30kW9LjZVzEOMiSB43xFMm
         jWkwr0N1NZ4Q3oBk3z7pmNv2xqqEg3aT51o7mzvOtQB/gpT80i0VzSW34sZGVYC7Ijkv
         fBz0YWlR49lATVd6AzT5n7hwIAXGOIhy5xIGCUhZOzSScgqB6fKXu4FKnexByPK4O/Sg
         6xm/3YmeKBw3d8pUMfHYevqmkYIfo4hWH9fnOtSEbINjdM2M+rViiXi9hQRvKqxd3bug
         Bqrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779897842; x=1780502642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0DofwycJUztzv8ieqZ6Ro3L+aNfF27V1vkVEXRjl8To=;
        b=iD5NfxsiX2tGPpUzANWXyLMPa6zalzJIpvMokHS5kAECEviJP4n3UM1lakcmp5nu09
         bO2e0VJYpwhSn0k3QEi0byPGFGCWsaFG+Vd2PnubCAPrNCedbDoIEKtFRRXZA4ik43ty
         BEC7qnNPGpyOSa1pekPcO3E7HQAG63PhIcLNQH6UxW+9fKNv6+99xhz5b3KGDdwoMSN5
         QsbgMaETYQYWwvuEhzOk7NrbKMvHyjn2SbdzchfoFCJA821LlyR/Jn/P65eeurejeVC8
         lsnWIsv8HZl0U370w5Mf/iBtgv6K2XhbwB4T70kS3OyHCWqmm1SQvNnf9TfTXsto/84O
         WxQA==
X-Forwarded-Encrypted: i=1; AFNElJ9fQRY+iPJ8Zn7G1DVNr8LU6Z2vJ20SgFCsi751H2NZCXOCXtaLAc6cBBRXWL4XVfs+vRZ0m5dkJg==@kvack.org
X-Gm-Message-State: AOJu0YxZodvl/vIZ+S5Voq1lt8pYbPEs1PnK5dP63Ig9S2vmtY5q1lNO
	b5eJ7DjP7mqiDSZohd/TfuvTtb6zf1Hp1jbZ/MkLZTqMJ93CSnI0r7L0
X-Gm-Gg: Acq92OENIBKJpiVyCyIfCNtZHjHmffb5GswmxRUkSkJwNk9aZaAIYbIah6j4vuVL9Pg
	e5jngduBlKaehpiSm9fJ0LKXS8a04yMBHYJqX/+LWQkSoZjGdx/EZAoj+e32wXAcwSDkNU5kBkn
	Mt7PcxBM4rnvrDB6iyzYzAlZYSDH1/RYOJkj15DkvWiD9H0n8YEEwjVp4yfPkJuLENgKY19mLBv
	X1W4tzVKgyL0KhPr+b9764hd2vpstN1gEEQXyK3cmGrz4AyTnRd2BjqlqVNkJD9UkT28TXYpEin
	pnjHjrrt8QihcMh4kmRbTdjxFTPUCzvKsjB74Kj4U8AtbFpDT79hdLtXx3ZdjyBZMGZiEyvIuD4
	PHwFEKacBXuU+s1HJ2Y8qbDW+AoYVDNBsgVMh88vDXEkkknUD8NmP/a93kCFwOxb3ZpVUFMF9oK
	sSbbx2a67SlTHFh+HFveRH0gQZBTlkCtiAndb+gObbsrUP7rBXZVsyA1hSB+WlRWWI8RgZ2lVFh
	eunDibAbuDDxBYjws2Ig8E=
X-Received: by 2002:a05:6a00:3923:b0:82f:21ee:270d with SMTP id d2e1a72fcca58-8415f0d7e75mr12854029b3a.1.1779897841590;
        Wed, 27 May 2026 09:04:01 -0700 (PDT)
Received: from fedora ([38.244.149.186])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d70e07fcsm2510447b3a.40.2026.05.27.09.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 09:04:01 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: dev.jain@arm.com
Cc: xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com
Subject: Re: [RFC PATCH 1/3] mm: make persistent huge zero folio read-only
Date: Thu, 28 May 2026 07:03:14 +0800
Message-ID: <20260527230314.572571-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <e5a59b25-d8ce-4d78-aec3-ee1b6efccfed@arm.com>
References: <e5a59b25-d8ce-4d78-aec3-ee1b6efccfed@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: em3dhhwaai5qegt7dmdqmzo1wen5akmp
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE32BC000C
X-Rspam-User: 
X-HE-Tag: 1779897843-145117
X-HE-Meta: U2FsdGVkX1+ar2k8Mtb21ZLKEyzQio59tFYBFHW0s5uXoP0S48VO/nPMFKQzjp/bwDn9UifErfU2WsrcOiCYzlzfk4OJzinVNa3u43NDvoI6U6Sj3v7QhJYNOaSH8FqW7Jqgs9DUrXvdFvfKGujd2633tch5zxAGWLVcQ/Z84S0gklpG57znr2/2fKmRiBUxNNkto8Bg9013iphhh/OrSY8KrD9A0LJ72BgM8l+Pd76fy9rd9KAmU/axFnrYbyEenkIoIQfjuNS5skEGgiZ4cNW9zxvLenJgcCVQKNm5ARUg9L1Mg/HUjGwJOhDW0qg6i4NJoeHRj82D2xnjWnZiXWLQFOV4LKxJogRfzxcfiavpTnrAZb32B9uDdHUw5oEbSpb9C60JrTNv61ZEOMjBeoLgO/c1QwSUoX0WsRrvPpRY7WsIqpBjjZ6FO7043QAURL7jH62x9vG2bgrNSLcwBT/uRWKFHmPU+pEVbnFNu+luVIL7p9MdPRKxLX0GbjV+NbAa/1qjPaBw6MWlnbvfk4OzYEtMme0yensqlt41z9Lv478ev/wqD4edVQuLiTOjlqGzFSkov0EKYBBAFgaicQvyAvWNsOaOCG3On8vsS8oGFvFzf4uw5i6PWn4oe1Rj7q6cH5W5sQWQM5ZLglif2dWWdsJLIkAPUuqd3ITVe+offSWd9U35NyhatAwtwwLeZgWyg5X3pciQIDPfFJapTA/mtlwUzRq9l4wwC6ZfokJYzX6R2qPsU6kfS/3LiIy/gTvKrWxLdCSDhi+UhACTG+0dfSze8R8PRyJPrS4KZ2BI6bi8yd95Of4/vp7PFH9hu52ap2vHGBm0OoZKh32pQr/laxypBC6zP9Lya5bR/Zn2qAF3suBbnUOWXEacC++I7cq+cPnUuNgmzI9k8DPXUbSKuZyblnSQqokSpBj7v0SoGR6r9Nnh/XlU5ZMWne9pxv9FJU0j1gAHtIW3iS5
 xEc947DX
 1Zn5+PRd7pyAI+97Um7TEOlCJI/g2Bg78uiaHCW3AvXzQuGI0KKNUVmBkY8KvJPWMvgRnfQCkVXy3GhVOiBWQz2Ka7CpStkCyOyla0Lq7uhYeipIg0karrYXjulSeYO09t05mMSzZqtZw4JTNQjVBOkCTtKF7cinvDOZ9OFqI859udqBoSwtfyWxWKzgGLs+g/LMUY+UfOdDLvK+ydLBJ4vQumQmoIFmCFggD/fZrM2BpPXDpIMDJbbYf5FkZqT1Qra0lRldOr1rID4RqySvIUoKgN1SPfIT83joVty5CnEIsI0yuVAIo0Bv9khMFSA7jfsflSBrhL8rkHKXW3gcHEkoS7Q0eRtkpvE4G+hx5yPifC9XmOQDbzKk2sUa9EyrAoRlanQae0wfIEaAgcUIaiV3CotXYiRwckTEJzSvqNGHrTQ0Rk12Gbms1QTV1/NJqwy9gsOY+4+bFMpa6xpC6eMgARuLLZpx6roQm4lfNLuaH0KpItZ0z8qX/gkPlPAyiXX0aj/529/7qTH6yqVu9KIWLv/u2ZCQaWjTgCgqZvm6l4XKm4Y1065yS+f0gBkmoOupiyklU2/TJ3QN/Th6F/4qbRHxmfON51NKZKHn0h9qL+ojC/mJVNpis3s+gvlUolslP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, May 27, 2026 at 07:02:55PM +0530, Dev Jain wrote:

[...]
>>  static atomic_t huge_zero_refcount;
>> +#ifdef CONFIG_READONLY_HUGE_ZERO_FOLIO
>> +struct folio *huge_zero_folio __ro_after_init;
>
>
>Can we guard this with CONFIG_PERSISTENT_HUGE_ZERO_FOLIO? Since
>in that case too the pointer is never written after init.
>

Yes, that makes sense. The pointer lifetime is tied to
CONFIG_PERSISTENT_HUGE_ZERO_FOLIO. I'll fix this in v2.

>>  
>> +#ifdef CONFIG_READONLY_HUGE_ZERO_FOLIO
>> +static bool __init make_huge_zero_folio_readonly(void)
>> +{
>> +	return arch_make_huge_zero_folio_readonly(READ_ONCE(huge_zero_folio));
>
>
>I think READ_ONCE is not required since no one is going to change the
>pointer after allocation?
>

Agreed, READ_ONCE is not needed here. I'll drop it in v2.

Thanks,
Xueyuan

