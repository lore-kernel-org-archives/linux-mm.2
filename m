Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B85CA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 14:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D38B6B008A; Sat,  3 Oct 2026 10:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283F56B008C; Sat,  3 Oct 2026 10:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174056B0092; Sat,  3 Oct 2026 10:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E85A96B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:55:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8787CA7934
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 14:55:12 +0000 (UTC)
X-FDA: 85281612864.20.1A927A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 11A2720002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 14:55:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BVdfenim;
	spf=pass (imf31.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791039310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7a1SctiCKt2b+Nd5jqZyQ8jpoLFtlfz4f9NN/1vqWo=;
	b=N1Cg9Ph3Acvw627GpJeNoufVd5zS5ejvlLxZi6Xp2nAVbL34flZRiOLXmav/ZooYFntLIv
	EHYl4vOOw6KzpeINKO43Nl6Ea+5Jn321I0o+uYb2w+UNjflppUBXlv1j9BzN0MjOdjRQdh
	MkfM4VjBVSr13fy8lCov30A36/aPmTk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791039310;
	b=oWOl9+g6YY2VmYpkknpN0DLL4FzeWaI0VvPF2ZkLEd1OcSF3XGrujBenVq0qmjfOkcLcmf
	QsrfOGotDL0iyRNJf620gR+WF4Z49bceLdy5uJsdgFxgwAACboV+IRGZ6BeT4PkZAdKHRs
	RGpTnJ+8i/kQWdyPIrPLz01X8wY+s+o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BVdfenim;
	spf=pass (imf31.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791039309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F7a1SctiCKt2b+Nd5jqZyQ8jpoLFtlfz4f9NN/1vqWo=;
	b=BVdfenimWC4BsKJzavxdBhqdLo7674ObpYaJixXWzSa5VtYgrGzgNeORBP2FgaepLeQztJ
	f7X4dcDYMg2MJKaQY/9zaomellIHw3G2BQtfT1m8PD2Kt/m2UhyJXOWgpNrSgq6BLrHf4H
	sBOn7PdC4MqJ2aqy5d0qcGVMcTTupnw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-pqH6k3aUMQiW_hzu_6Tjzg-1; Sat, 03 Oct 2026 10:55:08 -0400
X-MC-Unique: pqH6k3aUMQiW_hzu_6Tjzg-1
X-Mimecast-MFC-AGG-ID: pqH6k3aUMQiW_hzu_6Tjzg_1791039308
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93e49a1d3b1so77497085a.2
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 07:55:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791039308; x=1791644108;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F7a1SctiCKt2b+Nd5jqZyQ8jpoLFtlfz4f9NN/1vqWo=;
        b=NB07Jo9pQT3Tz5DQ3w4DlkQO/i/d/O41QMbnIC1WvJL85mXMSTCmQ0LsQIcY2SFkC0
         jj+aVnhH2SdO65c+bE2XtOFYHXR0LlEHU9R7qQC1EQ0wDLLPFkI99Gf7yQSi82Q37ps8
         OIYeDnE4HDlOAKTf1nkeLe/IpEa78+ZfejADLdh0MRTFroLSS4spCxL4FOyVxLJxDd00
         2raaJguKveLM1XIn0ThFy3TrheDMDikEkCgT+7w9rAsxY6SyhwsK6dc17o/hxTieM+qM
         8jR8/cFq+yDVyq28vto8e5rt1lM/x4JBv8LXRxLrTNBHfwa89xHR9Ty0NrJqLEqS01WX
         O70A==
X-Forwarded-Encrypted: i=1; AKwUvBw8/KU5HUSviHOjEfvDyWUsiu//iz81f3lODSti2CsqySr0ei+5e1Bt/n+7GaRMo4mPNFEnTeJc3w==@kvack.org
X-Gm-Message-State: AFuF++mC1308SuRfSOTjhNN4uNJbL1UbIBfGJ8LMwzPJULsqiMgyV5vQ
	ypaX3xOO5wj3DxUEH6XusvLHjW2JssWl4HYQa9TEiagXKo9T295eiQf2YF4gQZ+fi7VaQJdSxuq
	60DRXWFkEPpL1hgPU1JrCNdJ8NW2m5I459GtSJy3Er2vR56K5kR4Y
X-Gm-Gg: AYBFou3ezLYwLYMTKUGYXAR6/2Is+ivUPOExkR5MIxSJt5PP36Eef70pbza+0cIHDO+
	u02o0FARS4GOH2ttx4zXZgTe37y7xdlEPK45R3vjWDtHlHUdA+6+s2vtkbR/DmKh9FedpLylPGb
	b8Lrjoz13WYoVhbOq7YoGrO3hcTK+E5RPBWxiUzgC2HbQ0XrgAz1t0Vroij8soWChKiw88ehKVE
	Uz1QGfceKjv2y42r9oGxEwErutC4VHdBxakkxiIYzcBbKluqfWFxqi4CjtKOs6dSNKxjaayUPUg
	6DIGGGkIT3lYoZWTUATOswKxtwOXLYyJYraN7Mm74j34AbRuIi0/T9awYDrsB1MdrydMoSAYca9
	9wQQ=
X-Received: by 2002:a05:620a:7119:b0:93c:6e7d:da68 with SMTP id af79cd13be357-93ce7a9d9e9mr1074796285a.3.1791039307554;
        Sat, 03 Oct 2026 07:55:07 -0700 (PDT)
X-Received: by 2002:a05:620a:7119:b0:93c:6e7d:da68 with SMTP id af79cd13be357-93ce7a9d9e9mr1074792885a.3.1791039307088;
        Sat, 03 Oct 2026 07:55:07 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93cca1a4312sm469801385a.10.2026.10.03.07.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2026 07:55:06 -0700 (PDT)
Message-ID: <12f22fd4-d137-4c7d-9ca4-38b0099f14f9@redhat.com>
Date: Sat, 3 Oct 2026 10:55:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/14] drivers: dax: use pgtable_has_pmd_leaves()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <700b622814a2b294083f9066631f655cf61c3070.1789695931.git.luizcap@redhat.com>
 <388b396c-2dca-492d-8873-c9c672ac30f2@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <388b396c-2dca-492d-8873-c9c672ac30f2@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FKi3oBYNbOHWkwtLCHFWb6AWHmTkLeV5aPCoNtE7Y1M_1791039308
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 11A2720002
X-Stat-Signature: s1yr8sokonhupqowcyndcbxthcr8nww8
X-HE-Tag: 1791039309-11722
X-HE-Meta: U2FsdGVkX19m5RQGpQAzOz4CqTe3HcX1xrRngnwTCqZMusJHHtU5nwLqijsu8Pwg9NykNo8xT92EYKRB4RSRhPeyKspuhSELpkUMmbvqJcrc+nIuwVNFJgfq4U2mkRu+CmLFgZimYqmwdt1mtJuYl0z/YUpFWuqUI5inC9SNZRH9y+BX6UG1bvEr27xq35Coctub59j+OxlDBOrgcuVGUr7/rgWhplUvIr3byKyyXM6X/UywlWNsB/d/eVbfFnUsZ8gsIGlwWH9wEz9KQsO2V858v5zLVx8fN+YSM8HzuVoCNHEYySckhXuHh3Ey1tL4CjVby72MrCmg6JbChV8eIn+9UBddf7wEp/hQoIl/i0M4bNUlLUg6p83mN511SYXRnc/F4hVhEW0Dj5dQ8RpWVEfDem5RwrW7hegk3y9sFDQWxDZDi4oiWVHGS0xHs3+VVhC3rfJHOut8L152XCuq2EynS8v8lQC9Cp19qwGj/2DRDjunzUVzVIrEE+kNu1Am1Yt/2WJLAr8BWyO8C7dIrj0zz2a6IleRajziXCcZmADMJHpm9hr6FCs7T2t3FDy32Zmg69veHsBbJh31Dl4YHPrLZF5Bl8qidLiwXOWvWBMweTdAKKWFT84wQboGmfukDOK1slFmNMsDajPNbUEbajhjKWXimNA+qPZnq1IrHxey7mvAyypK76MwZzMUQ3FB0jO9rD/rAeDaQgbR6Yd9Id8WDpIvt3Awdx/SasKRkWampg8Bjm25RqHfRCuA8PS2On8o5tm8U5FaLreYU7TOuYm3SBdClliulDcFBXPN5w/DppDelNGFCDpSghAJOpwslpq4LD7wEAEkewQYQRgOjhCtKhzcTtaqScR6k5RlFl8rrKhsxyhqddRrHhwvYwl0XDvBSUj8BHaBGhkES3wRmvj8MzBJzIilNjbAkTU64dLRJEJDZe/7Z7fE8Duyrbc/Lb7Tfa0vQK2KYh2cYUS
 A0gqyPGx
 dKXWQ+ePQfDy9+w3waZBM3Ef5T4ey50dIrFcHtbabLpKoviaMK+72VKIdR4EXY8iQzCWHDZrpbimsap05KvO0/hTPygMkNo4L68J0bD0jVqwIufbWIs8tBmgGxJ7wNOZz8hSS20V2sDzG4ecSUn5kGzvNsPj2XNYQrrpCjTplGvX238JmLrbnT39iTBByHBQQ0UVZL4lsZM1LbvWC2gZV1tohcDETZ1+zJbwOFVhzcTPBTuaBCL8sqc5OOXmL8qP6j+US9pDDN5Yd5w9mEYHRJCa11qZeQRbvzkWN7YXmPVk6ua7pGrCW+PXVO00mO844A7MsGxELIZXdJ8MM1j6dZlkSxEF5e9tBbqzVPTSz2Qb1049ZJQrcg9ApVI8VB7KOVx0jWwxOn7Ru9K4TZ/TY3OFunaRU9LbkPkxyTN4sVoHz647BQ3mtWWIdMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/2/26 3:15 PM, David Hildenbrand (Arm) wrote:
> On 9/18/26 03:45, Luiz Capitulino wrote:
>> dax_align_valid() uses has_transparent_hugepage() to check if PMD-sized
>> pages are supported, use pgtable_has_pmd_leaves() instead.
>>
>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   drivers/dax/dax-private.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
>> index 607a53a91f58..18a6295aa766 100644
>> --- a/drivers/dax/dax-private.h
>> +++ b/drivers/dax/dax-private.h
>> @@ -121,7 +121,7 @@ static inline bool dax_align_valid(unsigned long align)
>>   {
>>   	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
>>   		return true;
>> -	if (align == PMD_SIZE && has_transparent_hugepage())
>> +	if (align == PMD_SIZE && pgtable_has_pmd_leaves())
>>   		return true;
>>   	if (align == PAGE_SIZE)
>>   		return true;
> 
> The main part why we don't see any change is that dax_align_valid() is wrapped
> in the #ifdef CONFIG_TRANSPARENT_HUGEPAGE today.
> 
> Might we worth spelling that out in the patch description.

OK, the new changelog reads:

"""
dax_align_valid() uses has_transparent_hugepage() to check if PMD-sized
pages are supported, use pgtable_has_pmd_leaves() instead.

No functional change intended since the call happens under the
CONFIG_TRANSPARENT_HUGEPAGE guard and when CONFIG_TRANSPARENT_HUGEPAGE=y
both functions return the same value.
"""


