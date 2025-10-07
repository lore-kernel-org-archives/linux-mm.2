Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF90CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 09:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916428E000E; Tue,  7 Oct 2025 05:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ED6D8E0005; Tue,  7 Oct 2025 05:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82AAD8E000E; Tue,  7 Oct 2025 05:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 723E78E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 05:54:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3D5C13BD9F
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:54:51 +0000 (UTC)
X-FDA: 83970859182.21.98E32F5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 45A0A180006
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:54:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759830890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pC3uLzbBHPG+KxUszk3l+rjQMXRDj72VLolBxmUXsSE=;
	b=DK53tHrST8Ae/Mq0M05riAWPYL7Tgw9sVYd8su0jHnzazmCICzphSjt/hb09DZCZaXQKjy
	X+CeYstPf00Il5lVQWLe11zjeoT18wGD/tf6P41yvSWTVJX01ogC0loxsPVgp/kYerFR2x
	E8SOkoTL1sGRFpOnYU3q2YYteH2xToo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759830890; a=rsa-sha256;
	cv=none;
	b=KRfuszdoh/R+DQrteWlLO4O1f+emd2n398lSW9kO3ehghG/TqT/frehfHxqJDf7ERt1ZPd
	GUX+ua21Db+JeByBv7XgvRtgFNhNESVBXRhWdLkZqNbcweI8Jm9G6iO+DPSj5dydFS4LYZ
	PI/cby+ETJOGZ4d0Mzjzg1/dyld9RkU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4735F1424;
	Tue,  7 Oct 2025 02:54:41 -0700 (PDT)
Received: from [10.163.65.24] (unknown [10.163.65.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD1133F59E;
	Tue,  7 Oct 2025 02:54:43 -0700 (PDT)
Message-ID: <6253b463-bdbf-4c79-b1a7-65860b76beb4@arm.com>
Date: Tue, 7 Oct 2025 15:24:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/khugepaged: unify pmd folio installation with
 map_anon_folio_pmd()
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org, Usama Arif <usamaarif642@gmail.com>,
 Matthew Wilcox <willy@infradead.org>
References: <20251007005022.24413-1-richard.weiyang@gmail.com>
 <ed17533d-912c-46a1-8407-29fd989f22b3@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <ed17533d-912c-46a1-8407-29fd989f22b3@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 45A0A180006
X-Rspamd-Server: rspam03
X-Stat-Signature: 7ykg8t96crxtwrb88rjhn5y5gg1bo5np
X-HE-Tag: 1759830890-560841
X-HE-Meta: U2FsdGVkX1+FH44hv40DuuakqBwqfaS8Aq5ND0l61VfumxhUir29DO1jLUfeB8Jz7mc86RLufbKe3dZDKE5E7kVOmuMz1TDEGA9UUt7UbYEIWhCUKsti78ODLnN7ff7CJ7ZO+GLXZYS2Z7Z8+GQSLy3wx1AGFvvDXciXkLqRW3itgs/URP/kqqjJv+wD5/8pT4z16rGkadAilkrHtsAt0hS3vrQZDdf/WyyHbSP6pow7ih0tzP6hQmEi7a/1BT1Jxv1rY9Q+d1RxdXa6OXiIW7kxz+QR60tDcrei/97oEYFeym5Hg2Wme1f9IZJ4igQ4WSBDIqyopwmUZyiN+/xtH+uwDBYlF4GNUtRgYJO93nwLpQtx0hSaOdW0XLkljXgN/AnoIopBU//MrJlgrwa1wqP/iDgzIFLMlcW3QHPPy1SeOI3wkKyZDT6C5tuFvu4VjV0c9PERR9ZXHTXzfDjApLEJFnVEeq4GfY/uQ9XZUbY+TIW95Nt9QpU+4SLKnHVUeg6FarhAJT77+MfQFfS8zuPE9yHMg83qMz0u0sHo8R4bETBzO+Lo68tnVS6R/uY7Mr4bEyLH3ApBV3Na3u8G2hAI00Zb2cxytzIHwPGW200GLL+UyjnzMdktXEYwZ6RGESDpXMGuVLsCa8LIyFWcTcEQU6rgOZCLvhV6/V2xmDwh/Djri9M5ArKvLKepteQjG4Tm9m8Di31DX9AwlYncggonOx2uoCp0nCOUmjiLvbLBfpDeN8jlU7gViZPKLF+IrtBspbt0nCPl9VZFrmCAW4GLpMPT/teUH85SbcqmPMmn9NzSnaKFpM3bexLOHjrzCi3ODHXIail1K6jETYshzSWo9y7KeU12FraHFIb3Gv/9almZU/FE5vSVmrFPNIlNWWMNM1cC9he3RKHYBMT4G7gIJ8dw+tZ1KhoW5ryqOmMjO6+FI1dp0OSvyFxYLgpZGDxxnQWeSOu7lPxwEQb
 tcjxQwRT
 RQyDldABtlPmz8Wz/IE29Wyd6sRouv07opXb30uS1tNlHgtrwtJS6A2+IyDj6fdy4OiaSL43gn52OzQ95pZv4gMyQSY5oZ6/9vEBCNoyhY4UNnr3x9XFg+fnoucUNI7VEf4IGs7vCrYYLC82lwK7Rp+dVnl8RAEo/APgzcgAHEuMymWDjd3D6lkiqvwRSONI/OweRBd3E0chrqRpVHkyrIEshkmyYej2o64PQNHZG80g/KYPhoiTjJjSdn9sd70Sj71CczYvOV3EyecJ2DDEcG07zoSL5PSeb72rF7haFGsgZhYzb/+7V9Pr0wQ2WV9VgqEPAvwYpUpo7W1uK1sfZj30OGSi27T8XonzpsmRzr++ZktrfBHniXKTDC4tMvcFOfSoUgbadaY578iHRNMkPTl14KxRDkK2IUeiQfFBINTJvdwOZyFzQwdqUqyjiNVtNy4IU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/10/25 9:36 am, Anshuman Khandual wrote:
>
> On 07/10/25 6:20 AM, Wei Yang wrote:
>> Currently we install pmd folio with map_anon_folio_pmd() in
>> __do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd(). While in
>> collapse_huge_page(), it is done with identical code except statistics
>> adjustment.
>>
>> Unify the process with map_anon_folio_pmd() to install pmd folio. Split
>> it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be used
>> in page fault or not respectively.
>>
>> No functional change is intended.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Usama Arif <usamaarif642@gmail.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>>
>> ---
>> v2:
>>    * split to map_anon_folio_pmd_[no]pf() suggested by Matthew
> On which branch this patch applies against ?

+1, does not apply on mm-new for me. There have been multiple patches
changing the same file so it will be beneficial to say what commit
it applies against.

>

