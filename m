Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 282C7C982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 03:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956A36B0088; Sat, 19 Sep 2026 23:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E956B008A; Sat, 19 Sep 2026 23:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86AE96B008C; Sat, 19 Sep 2026 23:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59B576B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 23:52:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46E7614036C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:52:26 +0000 (UTC)
X-FDA: 85232768292.13.0A132E3
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf19.hostedemail.com (Postfix) with ESMTP id E28171A0002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:52:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1lkRrGqD;
	spf=pass (imf19.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789876344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4CXJGmKHG01Cx5WADm45ZnwIf+yzPgsSp4LXsSCGK8w=;
	b=w5tCZvGHHZWqgXneLWeTZeUctFHORbHwMDm7oGh0lcciUu6nPs7YvZRV1G5Xs8Hm0qcinH
	5BaMEREuqrHvyltrd1RmL8VbMEUXZJyiHl5jlPGO2X4tzb3FcWhl5ds76Gge8OJUcteBmh
	nDLZg95z9EX79CvurE5Xj/l0YGuF+ZE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789876344;
	b=GdyLc41S9F0ZTCGwim07cCPeCuYnb/B6MEmL5AIgHgBIFMm7eN7sz/HALwbW2cWJY+EMfQ
	50AIZpNEDclzf+QrAOcRjDYEWbclVezCGIw4p06jLli8HLqyF9LNxeAM/wdsI+sYpfUzDW
	Mg2G6x40r9jHA68KrccILSff2LvVCGg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1lkRrGqD;
	spf=pass (imf19.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4CXJGmKHG01Cx5WADm45ZnwIf+yzPgsSp4LXsSCGK8w=;
	b=1lkRrGqDddig7anIp5WuNHAm+CuT3FvIsggB6VBKbwEF2UUvgcG9HIXey+Zr7ZvRIoY0aGqG4
	b1NaWsV+IYNc9zNPu7OWgW8LLxF5UL3Hg51zBkUv0TQ316qIuIhBTx2h1CSpbZOxa4mSd/F9cTt
	FP44s2lWygtUjNf1ecHgMFI=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hnXG031FSznTZk;
	Sun, 20 Sep 2026 11:41:12 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 4E14F40572;
	Sun, 20 Sep 2026 11:52:15 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemk200008.china.huawei.com (7.202.194.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 20 Sep 2026 11:52:12 +0800
Message-ID: <7e624b9b-b759-44c6-b1b8-810c36a066c5@huawei.com>
Date: Sun, 20 Sep 2026 11:52:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/17] crash: Normalize the kexec_load elfcorehdr at
 load time
To: <sashiko-reviews@lists.linux.dev>, <baoquan.he@linux.dev>,
	<gregkh@linuxfoundation.org>, <ruirui.yang@linux.dev>, <npiggin@gmail.com>,
	<liukexin@kylinos.cn>, <dave.hansen@linux.intel.com>,
	<mclapinski@google.com>, <ritesh.list@gmail.com>,
	<takahiro.akashi@linaro.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <will@kernel.org>, <pratyush@kernel.org>,
	<coxu@redhat.com>, <mingo@redhat.com>, <zhangtianyang@loongson.cn>,
	<linux-fsdevel@vger.kernel.org>, <sourabhjain@linux.ibm.com>,
	<hpa@zytor.com>, <rafael@kernel.org>, <graf@amazon.com>,
	<jbouron@amazon.com>, <yeoreum.yun@arm.com>, <hbathini@linux.ibm.com>,
	<chenhuacai@kernel.org>, <akpm@linux-foundation.org>,
	<lizhengyu3@huawei.com>, <chleroy@kernel.org>, <adityag@linux.ibm.com>,
	<dakr@kernel.org>, <piliu@redhat.com>, <pasha.tatashin@soleen.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
	<ardb@kernel.org>, <leitao@debian.org>, <catalin.marinas@arm.com>,
	<kees@kernel.org>, <thuth@redhat.com>, <blum@kernel.org>, <kas@kernel.org>,
	<maddy@linux.ibm.com>, <james.morse@arm.com>, <tglx@kernel.org>,
	<bp@alien8.d>, <e@domain.invalid>, <mark.rutland@arm.com>,
	<driver-core@lists.linux.dev>, <kernel@xen0n.name>, <chao.gao@intel.com>,
	<eric.devolder@oracle.com>, <tangyouling@kylinos.cn>, <palmer@rivosinc.com>,
	<loongarch@lists.linux.dev>, <bgwin@google.com>, <guodongtai@kylinos.cn>,
	<rppt@kernel.org>, <linuxppc-dev@lists.ozlabs.org>, <maqianga@uniontech.com>,
	<seanjc@google.com>, <vishal.l.verma@intel.com>, <robh@kernel.org>,
	<gshan@redhat.com>, <me@linux.beauty>, <sshegde@linux.ibm.com>,
	<mpe@ellerman.id.au>
CC: <kexec@lists.infradead.org>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-12-ruanjinjie@huawei.com>
 <20260918102742.414E21F000FF@smtp.kernel.org>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20260918102742.414E21F000FF@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Stat-Signature: 3fr1o4qc9prbmcyaz6qu4u88dqfamxdy
X-Rspam-User: 
X-Rspamd-Queue-Id: E28171A0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789876342-102715
X-HE-Meta: U2FsdGVkX1/MfuyVTSdAj6YYNZAFHG1+eoHQWyKWLfiP34tjP30jD+dNgaQGV/CMyjb4HGBOsNSd/PeLlJtWTvqnPNmvQpzgKkTGC4U/IBt7mTzu7w8Ej9Scxiase1Wbnxe4F0/A6k9rC7XEwZ2GO8Z6gW0pCCpfoUi1c5SxRniNvwUgNUCc7jKvjbL1aeiILgASv62JBs/gYG0uOgBCihdEP5S1GpnEXxWb2ROP/2Mmp2QRZXx4wV/s87LkYXyoVZ48kU10DWxU3jjnVUsNk4Z+0Q4Dv1VARw7kEgXwWHmQ3JyUnwR/PcljRuoHG8K/n4xLugKI/E9QDPpoi6nkBC6O8Aj/7T0puBygh39yWfRyq+IOZEXREaeIEwyw8RtrBGHv1vk1bHD1FFdhVRhzsdg32kyEAO2hzg4qUYiWmACySeRnptFLZV4Wqa4Q5U+5gaSX9wlIPogygvVX0tjZVRY06hqZYf5+Rdl5QIZKmUkVSL0O+B+Yz1lvciQyHaGv7LxmDO8gQy7h/REDfOykN5mTx88GChCcRQwexyj341jiUYSEZMgry8+QgJBXHlD9eegIZpZzGOZuUr5XXLJ1V1Gtwtpq/rkFvum0Q2vzAVFX1cA4dZVZDQWShVuq4JSOb0Ohv4MITFbHF3TdMp+rUgtzXrHBDvlGtmdI66tp5psZfHZg0mkoxX1lLd7R8ozOA1z5l6kYC/XBzxNC2GlLcow35nMdp2e531EAL5YnA8kwUTpb2RTYfIOm2VcOJyqma0F/rJ+svG1+ujqirlOrEc0Y8FetpuOAyip+8wwVq+CTCFPGvJTU/rt9itPpjh4ZzylpHmbLw9ipknT+I41+wfh07A+CHIrBGsTb2oxV66bA3ZvIzgq6kKi6B+0VnegbPZA0vhsWVCbmoYXpv+/73z+FuTJUUwS+/xrF3xXHAvQFTB3rvGYJ2kUZ9jsJg0E9EhzRzg9MPv6oflkrfpr
 qtkHs6ZT
 p+w2CeJqIz5p0lAs5/+KNeZfaPOzLnnXiSpha93r9j1HFle1X2dZ2QvqiP+jJdy0m7gDFBUNkIyHntmAiHtyZFbAFveM7nvZYrMBb6iyLM/fqV2btbnk0MISgiUovgbr5qWxQ46An+FvEQdQ9H+EqDN5ELdsOHCqrj2i+1fdOO/TdxTh7uJkK50gNZVZkdhFgfQG9YZJSYxoJv8mTD7DG1pjuGrdVkSdSNwwxM/aDKCf1oDQiOJyWOQeBkxcmJV38d0zOR+xPEGTj15lr3ufKLREF0orUZ9pEWFyvmCGGJfYU8AedDLeaRSqMZtQWXPU4q669UMF4rJwIIsSaqDmGXhtQwGWueYDqADK3sWcXvJd8hxA+jxXbNsFaDey6mqnA+eIr+nZxT6GO356JU6R2Fjz35PnT8+EygH/MmHzANlAFTI8CgKFTBxakpWi2kmtOjCwGNAzzgzuqBZ4SEDNF1Px563hnBFajBCYOVH/pbnwc/jK6lGY3EChjgSY0VGLcQTfm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/18 18:27, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] kexec: elfcorehdr_updated in struct kimage is write-only and unused
> --
> 
> commit 463b7b7692d8e96dc1be8ffaed1b6d0c8d298c9f
> Author: Jinjie Ruan <ruanjinjie@huawei.com>
> 
> crash: Normalize the kexec_load elfcorehdr at load time
> 
> This commit changes kexec_load to normalize the elfcorehdr at load time
> instead of waiting for the first crash hotplug event. By doing this while
> the device_hotplug_lock can be safely taken, it allows hotplug paths to
> skip CPU events safely and avoid racing with memory hotplug.
> 
>> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
>> index 3c9f4fbbe7ff0..f34fa8dba0288 100644
>> --- a/arch/x86/kernel/crash.c
>> +++ b/arch/x86/kernel/crash.c
>> @@ -457,9 +457,8 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
>>  	 * possible CPUs, there is no need to update the elfcorehdr
>>  	 * for additional CPU changes.
>>  	 */
>> -	if ((image->file_mode || image->elfcorehdr_updated) &&
>> -		((image->hp_action == KEXEC_CRASH_HP_ADD_CPU) ||
>> -		(image->hp_action == KEXEC_CRASH_HP_REMOVE_CPU)))
>> +	if (image->hp_action == KEXEC_CRASH_HP_ADD_CPU ||
>> +	    image->hp_action == KEXEC_CRASH_HP_REMOVE_CPU)
>>  		return;
> 
> [Severity: Low]
> Does this leave elfcorehdr_updated as a write-only and unused field?
> 
> Since this patch removes the last reader of image->elfcorehdr_updated,
> the field is now only written to in crash_handle_hotplug_event() and
> initialized in kernel/kexec_core.c:

Will remove unused  elfcorehdr_updated in v6.

> 
> kernel/crash_core.c:crash_handle_hotplug_event() {
>     ...
>     image->hp_action = KEXEC_CRASH_HP_NONE;
>     image->elfcorehdr_updated = true;
>     ...
> }
> 
> Should the elfcorehdr_updated field be completely removed from struct kimage
> in include/linux/kexec.h along with its assignments to avoid dead code and
> structure overhead?
> 

-- 
Best regards,
Jinjie


