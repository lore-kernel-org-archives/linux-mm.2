Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62774CAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 11:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512E48E0002; Sun, 21 Sep 2025 07:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3648E0001; Sun, 21 Sep 2025 07:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8F38E0002; Sun, 21 Sep 2025 07:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 200CD8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 07:25:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C973F13AA8A
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:25:29 +0000 (UTC)
X-FDA: 83913026778.19.CABE63E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 902F240006
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:25:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758453928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=leZ44DLXYJ62OrzyT+JDWN/vH5mCj1fVH7dMAOjXHe4=;
	b=q7sAq26FT2v7R8FB8Y9b1eRY2gHdUwDA5dNY1HMlAtA9xEBbZ8XGlJ0SgeyznHmDUR9u0R
	51XzCUdL1+rgcS50CI6Fu26herjwzpTfO56pKLW/NyR7cLVDd0kdsW3M4zNp+TBOvoicTV
	gKI+MLLeOPUEkSR2kWzlMi9MVU2MP+A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758453928; a=rsa-sha256;
	cv=none;
	b=Hj3fhtTI5zqZQ4bTB0pgsWFVj5Eb205pswvSz157P9RMn37F0eJ+qDc+UTAoVj9iqrAe3a
	Ht5K7OqH7GkFpeSLHDRWOR00WIczRHbGdWwAWh/fVBuSF2v9Dp7W2VXdlrHpGHYm6JPOAI
	ukAstxuILPSNAtRY62W0AK26NAch6fs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 311F21516;
	Sun, 21 Sep 2025 04:25:18 -0700 (PDT)
Received: from [10.163.39.139] (unknown [10.163.39.139])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5DF23F673;
	Sun, 21 Sep 2025 04:25:17 -0700 (PDT)
Message-ID: <49731a4e-d00f-4f84-aaac-87405d6eadbf@arm.com>
Date: Sun, 21 Sep 2025 16:55:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
To: David Hildenbrand <david@redhat.com>, Kyle Meyer <kyle.meyer@hpe.com>
Cc: akpm@linux-foundation.org, corbet@lwn.net, linmiaohe@huawei.com,
 shuah@kernel.org, tony.luck@intel.com, jane.chu@oracle.com,
 jiaqiyan@google.com, Liam.Howlett@oracle.com, bp@alien8.de,
 hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org,
 laoar.shao@gmail.com, lorenzo.stoakes@oracle.com, mclapinski@google.com,
 mhocko@suse.com, nao.horiguchi@gmail.com, osalvador@suse.de,
 rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
 shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz,
 linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <aMiu_Uku6Y5ZbuhM@hpe.com>
 <a99eb11f-a7ac-48a3-a671-c5f0f6b5b491@arm.com>
 <8c3188da-7078-4099-973a-1d0d74db2720@redhat.com> <aMsDJ3EU1zVJ00cX@hpe.com>
 <cd71fac2-bb9d-4e84-a074-2b695654e655@redhat.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <cd71fac2-bb9d-4e84-a074-2b695654e655@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 902F240006
X-Stat-Signature: h6wiipao9gy54gaxazizi1datso4f5z7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758453927-396718
X-HE-Meta: U2FsdGVkX1+dmmEDlDa4Ifz+SAZl8lUcRpotN7gdXmdJ+QuE5rw2xnpbcNuPrt3b9OZglNk2j2JHB24cKMhlUe8x5zDK9Tw3HDzlgmzvAcsDm9OGb4yjQ+EYu2ddrkA4+lhlkVLPQvzCdyKfshCLS5IkaF7rNjKL9yOH7lWmwIcdQLYXmHi7bBP4CTVMEn531lxMp3teew31s5QL+L22tLl+FH08HrfRYcRNerkXqnhAzibCYsFprj7+Lu9KO18tXBcnhAZZV3q6H0MT3joQwq8VgAyD+Fu1uyGJH8ggQJN8UbHbif42jxBk8WPwedDPWcEpriO+7lHMhZ0E+NZ+RG50Rd1ZvEVcTct9eMTI3YKGt/Nql7JodAcMdDuHFOdcsHtnS3hBm8b2nsIJfjZiZqwe8B8vCgMRwI/ZF7sb1RvoQitwomVKdWRRqAox9OsY7o/vDSrFbOgYlaAFDK1tZBAdwjcyDAJly3elH3lV+9muJqC/lgKFMkzrDZ+lVNw7jMScrtPu+K0QryR/j+x235/VLfprzvKvzDZRgsIElSfuzsOLAv+iWEYd83lHR2axWlXenGx3hi5KAaP/gZAEQlSwaGsGtAyyBIbb+m4tsqrIy7vM8dQXRNFQxvndLio9frYJxPRsqwWKvea2RiCKQtjwhLHDgx09n791Nuz3uK+UHg1tTTbtbFSPXuFMBe9CPExJZ68nSO6oqNUaQ0tTdzCFVCv2Uv3oTVTWBO34YtJZ/5tFbvLUEjl6bQJuWYjdWV8Gm2XaPZyHyfra+q32R9NG9hKwglcKs19MdyXrshyiiaAie6CqHePXfSQtTv4tmNUwWpJ23j/4LOmVe5qA5tpwe1ndQx0UOwV8ciL8sL6YkwvLCvEU37wWaYrd0+86eXHmtyu46wsIgembz7hAzpSfWUCh6txFT15ufhx903YinYmUSpfsE4a/cabQeiFyqVjJO/8c3L4+lwAyKUW
 y8RPKkmy
 s3K9UU0WaUUbpx51y25R0HLHPrbf1RyWokaVqNr4PRF6tyx1vpVr/Pe6bKYpZnm9J7NMjLK633XBZ2Xhoy4L3nGm38aS1BxdRgXh/tdkaV/UpksgS1h6lX48RCC0WbBiC57DaDIIpIM3k8UHOTxndrjIVpLMy2gxrgvfBqOtpICIclfEGNnW2LWUdYtdG/3MfWH8g2HZJU7L9JknBEa5FPDTsOEKnWK1VihQEYYxFiOO7Uqo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/09/25 12:35 AM, David Hildenbrand wrote:
> On 17.09.25 20:51, Kyle Meyer wrote:
>> On Wed, Sep 17, 2025 at 09:02:55AM +0200, David Hildenbrand wrote:
>>>
>>>>> +
>>>>> +    0 - Enable soft offline
>>>>> +    1 - Disable soft offline for HugeTLB pages
>>>>> +
>>>>> +Supported values::
>>>>> +
>>>>> +    0 - Soft offline is disabled
>>>>> +    1 - Soft offline is enabled
>>>>> +    3 - Soft offline is enabled (disabled for HugeTLB pages)
>>>>
>>>> This looks very adhoc even though existing behavior is preserved.
>>>>
>>>> - Are HugeTLB pages the only page types to be considered ?
>>>> - How the remaining bits here are going to be used later ?
>>>>
>>>
>>> What I proposed (that could be better documented here) is that all other
>>> bits except the first one will be a disable mask when bit 0 is set.
>>>
>>> 2 - ... but yet disabled for hugetlb
>>> 4 - ... but yet disabled for $WHATEVER
>>> 8 - ... but yet disabled for $WHATEVERELSE
>>>
>>>> Also without a bit-wise usage roadmap, is not changing a procfs
>>>> interface (ABI) bit problematic ?
>>>
>>> For now we failed setting it to values that are neither 0 or 1, IIUC
>>> set_enable_soft_offline() correctly?
>>
>> Yes, -EINVAL will be returned.
>>
>>> So there should not be any problem, or which scenario do you have in mind?
>>
>> Here's an alternative approach.
>>
>> Do not modify the existing sysctl parameter:
>>
>> /proc/sys/vm/enable_soft_offline
>>
>> 0 - Soft offline is disabled
>> 1 - Soft offline is enabled
>>
>> Instead, introduce a new sysctl parameter:
>>
>> /proc/sys/vm/enable_soft_offline_hugetlb
>>
>> 0 - Soft offline is disabled for HugeTLB pages
>> 1 - Soft offline is enabled for HugeTLB pages
>>
>> and note in documentation that this setting only takes effect if
>> enable_soft_offline is enabled.
>>
>> Anshuman (and David), would you prefer this?
> 
> Hmm, at least I don't particularly like that. For each new exception we would create a new file, and the file has weird semantics such that it has no meaning when enable_soft_offline=0.

Agree with David here. Adding a new procfs file for a particular page
type's soft offline disable scenario does not really make sense. This
will extend the ABI unnecessarily without adding much benefit.

