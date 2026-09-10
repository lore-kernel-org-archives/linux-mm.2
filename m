Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 646A7C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:07:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3336B009D; Thu, 10 Sep 2026 07:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3A86B009E; Thu, 10 Sep 2026 07:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E05C6B009F; Thu, 10 Sep 2026 07:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 331336B009D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:07:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C78CE120496
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:06:59 +0000 (UTC)
X-FDA: 85197575358.27.3B18A4B
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf14.hostedemail.com (Postfix) with ESMTP id D2E73100002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:06:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xsXDTggG;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038418;
	b=Aza+23qzMx2GlcmwaezVfqbwum8HEDxl3HgOJ+Ebt7qiEvTdjC5Z3TqJUjqBgUfsDYY+3s
	0NeSHBtW2MjBjtsoe7zFfbHC+sDCf/UQjXK7tdfyIlHRG/F8t0PWDaWRkB4xAolpllVrq4
	GrgMA2JMIQyDALm2hq7znRiMVOvS2CQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xsXDTggG;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NnCzMKK6Rrt9YRz206NHU/MZ6Oa3TFT+q8PJel2ZDiU=;
	b=Aj8EjZHC8ZT0QFDLaMJlOIFNexJGhYJBwKptyIWBM+yTVSFh3xO1JP8xH32PnoTj2uCgia
	K69XVoM2Fly1rjNg9Gy6ca4yq9w6A1VEopfBcCi7nRuTR2PE3YIp5oHFU+vbDRkPSkqUSq
	Jc6jCJrDXFwBtSmQlOvIFyWTayH/kZQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789038412; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NnCzMKK6Rrt9YRz206NHU/MZ6Oa3TFT+q8PJel2ZDiU=;
	b=xsXDTggG3THVc8alSA3iSzbfXGCxq4u6omP46g/bxSKe75gXJwK6mXyvRDUoQ55eh3mpYiA2ItwK7VQ+/U+6gQMztIrLmGQkSASQrn1MXcBQLlUELb7lLRsnr8Z/LM8a8XA1w+D87aSyg2caV15G+G9TWRF0cZyov+hW6729geU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0XAhNhUn_1789038410;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAhNhUn_1789038410 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 19:06:51 +0800
Message-ID: <c0527b13-a60e-4278-91ad-939aae7ea456@linux.alibaba.com>
Date: Thu, 10 Sep 2026 19:06:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/19] selftests/mm: stop khugepaged during the
 MADV_COLLAPSE cases
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 rppt@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-7-kirill@shutemov.name>
 <4e064b9d-aea9-485a-8547-3830999cff01@linux.alibaba.com>
 <aqE3Vq8Go01c1icS@thinkstation>
 <ba2d7885-f017-4d4c-bb59-e45f8b9f1b63@linux.alibaba.com>
 <aqKNcw8-2H035xyc@thinkstation>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aqKNcw8-2H035xyc@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D2E73100002
X-Stat-Signature: a7p86nt7g4ppkaajc4okuosdrag7eqmc
X-HE-Tag: 1789038414-371904
X-HE-Meta: U2FsdGVkX19rYQAq4tPw+CJ0/HbsdosgDWCtN0ZkVH3033za1Q+OZf3BTCQS7vMpASCChyXjNFtxLydDF1QXnbx1by2NaL7bqv3D7eYpV884Jtxz//kIPxa5B0zfPXNJV6XwgRS82jxJib5qkHiHd0mkdsi6Kh/1gTghfpw/PCtefhnn/eDMF77hl73mpcxIsYfxl7212mJ5+9vCfKrtdzsyju9RMtzlwdhjEXP/BlyNWd8hGeNXEj4JukhQaGF4xCS18Gbk8rdTAU0RvgdOVfAcLJDsluc5Pd7KBHfSA8ZsjQERFoJjLWE2+rjblYeLbRtw/KH1Zhs6pVSASU+s3MlozACZ7rNBLmeFLbpq1k+/k56AmyWuJ9PE7dI+38kihjg9ruZN4hkO265grY7JVzAxAlGj9Ky7HNza1SX6JGMznGxPXPLk5+gNxcN3gMd6ZmgwOEnrnfWIbSmj3dhPT5imbIvl0x2reTVjTQFV3bldAwD81NIrSDosNdG23sc1NAtInarxbMFzJ7T5fYDISpLlJ48hs4AXE1fIPjFo+eUW7jbtaEhmrDkEd2y58908/jWy0cxLQNjVKVkd1alRnLGtK6oK8LeNWyJnZgw6YpIOdzJwEfPWk7bMESPs7oilq30KgoU6yAt/iZsVuaQRYfPm6D9DtT+D/fxYE4NWYigTmuqAsgA0q4eJjNyNpnWEMWhMfw3lILINqzkapCF9VI6AuqqOMgsHqQjJEUKrZUwMn81J8nHqekO4CnVI1JmpGnHxqm8XVWFwb8gOjU9xtkOKohW2z4ItxwZfCoTZBFaHuyAEho5/WTVQeXJIlKw63llwrYrWKphYKOD0wi9vsVK+hsOqx4mX2rmWxQ6vkzQw7CjaVM/9S9s2nOo4nh4J27a7RPa5QDruMKz7hpDUNKpl659+vNMLiS8A4Hs1yR6JyPrf85S/rN6hY0TBpzblRhfIR7AheI7tgK9PtK8
 HD+egds3
 M3ueFWfz0K0mI0mW5vLj01pYYKodASNs6v1PI5HEZQHaBtYDOdQsMq/1Wfhbvv07KAMwwe/NOSVt7ynoNKciE8wfsAEqJ76DUJTcgEqKOBrRzRVYv2q1fqTdgedM1Uesd7vsO67YgSoNlqrP6PoHkxVWoCQ1jDLXWvhkAZQ79khxh/kYQsBELF9iwOVPQvJFGJ4r7CHTxc3mKB/h5s5Dw9AZfj6i/mDWkzJ+ZAFN4kDVUXJ2LFJY99RKwfQeKXKULmMHT2LgoN8nV+pS513bbD8C+OI5ZudfUZo7UJkqVpFZrj8zcQubM5bwq+yMoAf8pjAlCcvooMk+EV+oWGRdlrEVZ6D5B2rKfdetNrf1zQjR9b8P4B/yBGpItL5F/A4xgMdLd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/10/26 6:59 PM, Kiryl Shutsemau wrote:
> On Thu, Sep 10, 2026 at 02:27:28PM +0800, Baolin Wang wrote:
>>
>>
>> On 9/9/26 6:41 PM, Kiryl Shutsemau wrote:
>>> On Wed, Sep 09, 2026 at 05:55:01PM +0800, Baolin Wang wrote:
>>>>
>>>>
>>>> On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
>>>>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>>>>
>>>>> __madvise_collapse() turns THP off before each MADV_COLLAPSE, both to keep
>>>>> khugepaged out of the range and to prove MADV_COLLAPSE ignores the setting.
>>>>> It clears the global controls only, which is no longer enough.  A per-order
>>>>> control overrides them, and -s, which makes the cases fault in folios of
>>>>> one order, leaves that order's control at "always".  khugepaged then
>>>>> collapses the very range the case is working on, and the case fails on a
>>>>> collapse that was interfered with rather than refused.
>>>>
>>>> Right. So I think the correct fix tag is b7f16963efe7 ("mm/khugepaged: run
>>>> khugepaged for all orders"), because before this commit, khugepaged would
>>>> not try to collapse this range since it only checked whether the PMD order
>>>> was suitable for collapse.
>>>
>>> Agreed.  The series is in mm-new already; if a respin is needed I will use
>>> that tag.
>>>
>>>>> @@ -547,9 +547,16 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>>>>>     	/*
>>>>>     	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
>>>>>     	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
>>>>> +	 *
>>>>> +	 * "inherit" rather than "never" so that MADV_COLLAPSE on shmem still
>>>>> +	 * finds an order to build.
>>>>>     	 */
>>>>>     	settings.thp_enabled = THP_NEVER;
>>>>>     	settings.shmem_enabled = SHMEM_NEVER;
>>>>> +	for (i = 0; i < NR_ORDERS; i++) {
>>>>> +		settings.hugepages[i].enabled = THP_INHERIT;
>>>>> +		settings.shmem_hugepages[i].enabled = SHMEM_INHERIT;
>>>>> +	}
>>>>
>>>> This looks like a workaround to me. Shouldn't we fix this in shmem instead?
>>>
>>> Good point.
>>>
>>> It can be a follow-up patch.  Do you want to make a proper shmem.c fix
>>> and update the selftest along with it?
>>
>> Either way works for me.
> 
> Please, do it as a standlone shmem fix, plus selftest update to reflect
> the change.

Ah, sorry, I misunderstood your points. I'll send out a fix patch tomorrow.

