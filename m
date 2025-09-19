Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41C95CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 07:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93AE78E005E; Fri, 19 Sep 2025 03:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912D58E0022; Fri, 19 Sep 2025 03:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F818E005E; Fri, 19 Sep 2025 03:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77E8A8E0022
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:39:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24B6714059A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:39:00 +0000 (UTC)
X-FDA: 83905198440.15.A7585D8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 21961160009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:38:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758267538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WL/hlpPIHmBCHwGl4kJPfY6GPUtoIQwr+yM3ycauwvo=;
	b=mHzmI3RY8uoVQKvnDXHVhaJ0QdbpnLsrUPRUvv5N3iYc+tiPIC2dD+tSfmmfcTilLXvZFq
	BfMUuQye5CnrMUuyKVDEQVCmtDCpIK2ZqT7tK+GNT6FYR/0bZ8bDxuKkm3k1J7SbgoESHS
	y7NYQNq5J5Hrr4p0j3Lz984VtgmlBkI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758267538; a=rsa-sha256;
	cv=none;
	b=kSaVrZIkvmcuFiUXXUnOiKRXaP6UIHjtkzDuNd9/KHAJNSZH3eihPT052h+zyiYRc/64Kz
	rQLezRw7dYIT2G4MtD+PjFZX37/TOjLfpo241lHuv/UToqHgmqfDYx2NE0C8M/27P0P56S
	f6Y9+T9lH+H8yBF2G4pSXPVRkKgOfrA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 058611692;
	Fri, 19 Sep 2025 00:38:49 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A6BF3F66E;
	Fri, 19 Sep 2025 00:38:52 -0700 (PDT)
Message-ID: <eb29be48-5bca-4bf8-8c79-ee9511ad39a9@arm.com>
Date: Fri, 19 Sep 2025 13:08:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot
 is !NULL
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 xu.xin16@zte.com.cn
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>
References: <20250919071244.17020-1-richard.weiyang@gmail.com>
 <20250919071244.17020-2-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250919071244.17020-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 21961160009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: nhpid9tanhw69ozgcr6en3w4hafiaggq
X-HE-Tag: 1758267537-757947
X-HE-Meta: U2FsdGVkX1/Bvsy5h/uckXBuTdZAWko/moZLfGCsKUCp6KDK78xkhlUJG4Xjm9bBSHuWBJvlwByPDNz1gOPGp0Uh5HLwbWZrO3EBHItAkPGwNuopaYwEiiGAQ7mnnuFmkPZ3D7iNXLmAhhjN/R5XxCsBJC9tuITd5yEp3TPI9LFtZcULn/D0C4jA207df/TWsSkyO89bg5Zs5psH1F2ekSqKAU16mVN5iYpnOInZmVQkNOSEybEHB7P7BIJMnTGmRi73VKjUE7TN+awd28keaTumWHXCItoqxY7AcQDakOWvPKpo8hmJ//ULWAkpr3ybtMX3Trfigd5rfFSB1SQzdPu5tEDlsNMJ5V2ois/POc4dicINT07ajCm1+OfIGoabZGMeNqp7vYRihAmWD6CazReC+w9B2BiMzT5qOz+qbZviWAQIqwc6O6iUmiun8j4tbWmXGOEykiGD1h1bsVnJ0bQzZBqpK89I01Q2cs2lz6d/OcOEv04GrTVkGYU8DijfDZt+DFOp7zX5+xAxrHyL3E7MDFM+7WMBrqQeojTnx3r0KeF+kNQejVjr6lsvpecBjzB0upTuKh2fCg6cLvugRI01RHE/O2r7dAuonQhZLd5BKjVcdKaeu7fXsxAH9V8L31DSrDFbHprC6BrBwvcy6wT+mzvrtPr3a1E6mOxSFgjPaOwPwoZN7byu06AShwTVu0d2zo8Y40f1RqQ4gyKzi4/loNmAdIgIshgyzmQqKhvNvePNB805iHqNHqQVlOnbb0lGfdQryb3Ya5ttpSVYlu3QBhwd05YEsMbubJOOgLosiJKYVtztKa1q+Gv7Z6PddO40Q57D6gt8hcr8Dzulyztc6WCCassEtFt6XZ35grFGcw/I28OiIZ4ga1PPTmJIAZ8kScrSo5wk12b15f4FaQTlM0J4w9XvcBasWaqRK86LCxs2QbANMW8PJV2UEDEG+YP+nvO1xXlIBQz+o+M
 1wLdn1WD
 kCWoLdd1LWTERFTpjs9laX86hiBHi6cdao/YJxPaez2fWNv65fK+Xf1jOb8UHDxxz/XlCX6fTRgHfmq5JS0xqkrCHS2A1zLE6Gal9CRmGuVWywFJqZ1Oza+ORtg/b8OmUB4z56xt5JoPSOawGc2nQ1XppUVfv3qmAwJqGIZmLfU3ifo/VwuiQAC6J97kBOkFNa7ZsU3pIudwQfTo4C6WZxb5EdRVVEoHc+L7Cp02qQVSryHiH5Noe4e7IfWLljWYjq7+LMi2O+WxwXwuTkGNReDgwcjEwMlmirP0zQFiiAcz882/4ZTquxP2GoI/letyL75xplDv/i3/ExmIyFv6vHK5UnAgHYEJnD0M6boP5MdSj+Ty8RrSo2yKyOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 19/09/25 12:42 pm, Wei Yang wrote:
> When using mm_slot in ksm, there is code snip like:
>
>       slot = mm_slot_lookup(mm_slots_hash, mm);
>       mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>       if (mm_slot && ..) {
>       }
>
> The mm_slot_entry() won't return a valid value if slot is NULL
> generally. But currently it works since slot is the first element of
> struct ksm_mm_slot.
>
> To reduce the ambiguity and make it robust, access mm_slot_entry() when
> slot is !NULL.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

Reviewed-by: Dev Jain <dev.jain@arm.com>


