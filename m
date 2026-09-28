Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4427C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFCE46B008C; Mon, 28 Sep 2026 05:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9ECD6B0093; Mon, 28 Sep 2026 05:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9BDF6B0095; Mon, 28 Sep 2026 05:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3466B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:14:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 09B8AA38DD
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:14:16 +0000 (UTC)
X-FDA: 85262609712.09.79F8834
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4401B20004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:14:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCN9NmS3;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790586854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojbopmmPdRq/zC/UNBXyGoZ8LTFlDLR7fEeeqgcm29E=;
	b=HHF00vTYuvBQiC8nX+kLs5eYt770JyGDSroE81grrN0+sqw1JHMbNEy2W0cYS01c49G1mE
	51skALXUwA4gTrQ9sQdsBODLJ9H1Tr2sjQpvY5BndrXjQ5cbb7Ld0O6zQjgzm3n4atFo2a
	GMURP03m/NO9ZMFoZ563f0bOpSIc/EI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790586854;
	b=rzGDd1kW8AH4cApRe8tv6PNO7YlITEXAX62UYo7FsH5gZUtHyOjAA6AIGEi5Kly7ThzeeW
	+8pLwDlRQ/vn+JbgRhcYncNHeJgmxYtRwQ4AD5pAot6rJKdyyRNHTd0jrUis8RNIdimAz4
	4cvB09ZgbwyL72I0FSGTTSMQe6TPvrg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCN9NmS3;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 819DA41A3C;
	Mon, 28 Sep 2026 09:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE7B1F000FF;
	Mon, 28 Sep 2026 09:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790586853;
	bh=ojbopmmPdRq/zC/UNBXyGoZ8LTFlDLR7fEeeqgcm29E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UCN9NmS3qDbL/ypLkWhgpQEUgaZ4gIGG221Wvzif/dNp8eyiOSruzJowP8cP4pGFM
	 14MqP4+FI2MUDZPI3gOzpTrMdGAkfw2O+19mcqK3Seb3Eo0jFpe80JS8YW1c6x8aXC
	 u1k7LD3qLH/vDSBkX8kvu4uevFpj9agKp4H7WHYVUcsjAUFa+i/y3n1U5qpSNXMb4l
	 XaLBkmIHOZ9IDkwYn39br9fJBSdvYc/8HtRZcFJoiS28pFCpghc2b7EJYOlKx73fbN
	 RfATo7vhTs5x24kuA9ETBFJATiCEaWFvbYQvDJoSr34yiscNvuPtVduFQZKAdPcxCm
	 szeHHvmBGEIEA==
Message-ID: <21abd60c-e71b-40ed-9506-853d4485cf4b@kernel.org>
Date: Mon, 28 Sep 2026 11:14:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vmcoreinfo: export SECTION_HAS_MEM_MAP
To: Baoquan He <baoquan.he@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Carlier <devnexen@gmail.com>, Dave Young <ruirui.yang@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org>
 <arovLO37djQderTB@MiWiFi-R3L-srv>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arovLO37djQderTB@MiWiFi-R3L-srv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: g48tgooipdkkrsky4w7wcy84jddzqk33
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4401B20004
X-HE-Tag: 1790586854-736614
X-HE-Meta: U2FsdGVkX19N4RrRL3Jk0TRrtIFIicIDweYAGdR7EZgsgdtpqlVGkjewLmK5JpTsnXCGr8NYHod7iFKu1d7ulPe2wu1Jp+ju3EMtvjYis8ZmO/INTqvB2osbiRIMhjUcLEtuTfwDDuwAVkgsdLwBMOU18hhtrOP+GaNW5GVHLtYXmFl5ezy2gFsYCGZU92IIZAM1pT1J+O5YsK6In8y+IyOxySa0c4LQpqA2VG4G0GLwDQ3mcgsl6EoLgJh6LcqdAosjzosFpHfL+D73Q899u4DNrT3yTSeSwvxF9InU4heButVwuJGmFJA4lvGtOZKkdz1Jt6XyvK+2EKcFz/Aly9QeBWUTZVeujGKVFcl+vR3Y2wLsJ3Mp6OYOF8+4sAXhstIsGj094n13hTNfr4TT6c2X0eH7t/ZnQqZTtg52bPOBdWG9nQK9kTjx2T+52nfYn0W3gfvjuqf1MXSpWUGw4kOzMlLmx9bdCEIP3i/FyRjruX+Sy+jiyQK6SwqmawZbx29JDzujfiSp0cOZUsa5Zk9rdw15ii23dLvWhIdtUlTlookOCSop1xMNscQP4lWT+TImaaUSgBm6Eeh+wyl2DnPYO2Gc3l+wSq4TUNUh475YQgZHBOret5CUPEJVsH5P35VoH0xT/gH+z7MwjhD/xakj3OkIgMNjcGaWAjAmNGQizze3d1+EdDTIcWNlVq6xBR5aLYWB+diEvzOqgpWiAJHD5/vF6VmmH81MiN/o3Xk6tsHz7LgBvyQFZRiX+UOpCY3frP/pgZ3z2uhvRvzhnuWckJF4MY11Mkb5vpWx4W+1HZ9HUNyjc5B1Y/wLZAO4IIBcCEH9rzxRjcGtqU/hOz3/P4EpOh+c1kVvr8d5QrjwgChwR4tT5UhzIpgflMAzftpvou7bIAHOjCz/x6O9gLaM5XtihyaD0ummF/BbOS5hDJcmHd9AQqB9W7lKjnAutWCzNWkMnRcJcTmNek9
 Ten+OZSo
 bC8VxnQ+H87PsyYLwfRwUUnqJkA4YlHTbSfEHnBIPO1sbvogvIjDpfyslPRe3sALf5p9iPqgsqCUx7b9mSzKfF4ZNKJz4ZkrBPYiE4cVJ22l3zEPLKMdSxn/GpuOE5D8jKuXEUX0gvpMZEa3jJc11lx2Am+qTnM3yNGC0pHYADvOXtI02yd20PasF3ipGDBLOPxvAg5XBKczEeYoGkfPMAdWyq55Umw/+fywrQxD9rNIct8fTyeLQtkUOmIjYAT01DnMDiSrOr/ZbdYY7nUGiCDwJvgGgROljTilVczjwU91JrM0t2z6hB6YNar3Pv4I9RphRHBynsGP4ufw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 11:11, Baoquan He wrote:
> On 09/28/26 at 10:48am, David Hildenbrand (Arm) wrote:
>> The crash tool currently hardcodes SECTION_HAS_MEM_MAP, and makedumpfile
>> needs similar information (although still relying on
>> SECTION_MARKED_PRESENT, it should switch to SECTION_HAS_MEM_MAP).
>>
>> Let's just export the value instead, so tools that work on vmcoreinfo
>> will not have to guess.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>> Result of the discussion in reply to "[PATCH v2 00/13] mm/sparse: remove
>> SECTION_MARKED_PRESENT and further cleanups" [1]
>>
>> This patch can go in independently. It would be preferable if both
>> go into the same kernel release ;)
>>
>> [1] https://lore.kernel.org/r/20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org 
>> ---
>>  kernel/vmcore_info.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
>> index 5a417f8a922a..7833a36064a8 100644
>> --- a/kernel/vmcore_info.c
>> +++ b/kernel/vmcore_info.c
>> @@ -182,6 +182,7 @@ static int __init crash_save_vmcoreinfo_init(void)
>>  	VMCOREINFO_STRUCT_SIZE(mem_section);
>>  	VMCOREINFO_OFFSET(mem_section, section_mem_map);
>>  	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
>> +	VMCOREINFO_NUMBER(SECTION_HAS_MEM_MAP);
>>  	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
>>  #endif
>>  	VMCOREINFO_STRUCT_SIZE(page);
> 
> It would be good to add one section in
> Documentation/admin-guide/kdump/vmcoreinfo.rst, e.g
> 
> SECTION_HAS_MEM_MAP
> -------------------
> 
> Indicates a memory section has struct page array (mem_map). User-space
> tools should read this value but not hardcode it since the bit position
> could change between kernel versions.

I'm not particularly happy about having core-kernel defines documented in
kdump/vmcoreinfo.rst, though?

If it would be something vmcoreinfo special, sure. But not for basic defines.

"See the kernel source code" is really what anybody using this should be doing?

-- 
Cheers,

David

