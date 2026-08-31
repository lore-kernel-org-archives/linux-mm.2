Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0897CC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 01:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA486B0092; Sun, 30 Aug 2026 21:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B836B0095; Sun, 30 Aug 2026 21:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A746B0098; Sun, 30 Aug 2026 21:24:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 411366B0092
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 21:24:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC76C1C1DEF
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:24:25 +0000 (UTC)
X-FDA: 85159819290.12.ED3FAA8
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2EB2540002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:24:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Fs/xB0Yg";
	spf=pass (imf27.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788139464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XoeDNcLDw7hqig4W64iLCrlEHYGNT6SfF67o40azHuY=;
	b=OMx41D+0KOhPyZzKqYaBcTLPKw6R8IfZU4g4M9z691gWj3IqSPw9gUU37iuqy4+0m01hKt
	0jeiZryihxY4sm8xW+bDkU4whZnb7Z+QaQ7Cx/eGLRCUiv14AgBalVkTdavv3h1xoMzVTA
	xkixL0WhVU+yu8HuX8eRZM36xA8Emrk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788139464;
	b=cJjiGQq/xyA2byCKAN0WByWJl+DfL/WU42DZw45CPWjvToCOjRLvGK6mBvo+QsmEjbB4rQ
	gv2p/H0tC+xLdqhD/jp57rAiJfkO6FNeOwM4wTmZOYgGN4Cnvuei3cXVnifZ0DKl8iRnm/
	Z1wPqclelkrradcthGPWU7boNr4n+dA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Fs/xB0Yg";
	spf=pass (imf27.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XoeDNcLDw7hqig4W64iLCrlEHYGNT6SfF67o40azHuY=;
	b=Fs/xB0Yg8kWOG2+vbJXCQn6KxCz4jWLUSzEAq/b1HKUjTI6Zn6a1TBwmvuGGuCcesE500xj3A
	SHlJN9aRXKf3A7Fs3t9RDcaKDSzLORDLcS8OYgkK4sJKg+bVG/PW2a9vzhyuN23Kf3k818vtagI
	kSNrNpmr3MK18T+muYRiL2Q=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hY9w638lvzpSvb;
	Mon, 31 Aug 2026 09:12:54 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 0BA4140577;
	Mon, 31 Aug 2026 09:24:11 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 31 Aug 2026 09:24:08 +0800
Message-ID: <fecbe6ee-12e3-4f3d-94ac-eb7cd08eeb0d@huawei.com>
Date: Mon, 31 Aug 2026 09:24:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/17] crash_dump: Fix potential double-free of
 keys_header
To: Sourabh Jain <sourabhjain@linux.ibm.com>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <mark.rutland@arm.com>, <chenhuacai@kernel.org>,
	<kernel@xen0n.name>, <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
	<npiggin@gmail.com>, <chleroy@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <akpm@linux-foundation.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<gshan@redhat.com>, <jic23@kernel.org>, <james.morse@arm.com>,
	<ardb@kernel.org>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<coxu@redhat.com>, <tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>,
	<adityag@linux.ibm.com>, <ionut.nechita@windriver.com>,
	<liaoyuanhong@vivo.com>, <seanjc@google.com>, <fuqiang.wang@easystack.cn>,
	<makb@juniper.net>, <piliu@redhat.com>, <ebiggers@kernel.org>,
	<jbouron@amazon.com>, <mclapinski@google.com>, <me@linux.beauty>,
	<graf@amazon.com>, <bgwin@google.com>, <robh@kernel.org>,
	<takahiro.akashi@linaro.org>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, Coiby Xu <coiby.xu@gmail.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
 <20260826092541.3905933-8-ruanjinjie@huawei.com>
 <87186b8a-f68c-400b-97cf-8ea6129eba69@linux.ibm.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <87186b8a-f68c-400b-97cf-8ea6129eba69@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2EB2540002
X-Stat-Signature: opcjkcy6e73feh5pmffpu4i3chdhf6wq
X-HE-Tag: 1788139462-143119
X-HE-Meta: U2FsdGVkX1/9trCIatd4TDljA/l9tf/0Yrg/Osc8toOvx2m+krSjZsbkp/Pdby6/MhWCccvpKeSdYnnE455DE6zHPslHg2rGwAG0LVNEM9G/EjObjIQPnRyVlgUQc5q2mMB7nAu79p6CQfIekJPpzJiNsK2IY4YS17CIbr7gnZuO6INAhWjvTtLd4OSORyVqkFIkAxxs8qjMW0Sh/ImT8DwG4XTcFSNzsSjCw49nDh6t+oYGd34Gzbs6RazEk51IShxfz3CxgJCHF+JAT21Qsl3VA7qLZRa0QyDBU28Rwvo5dyLJG6keyhnieThTs7sutGj5uQu3U4hU8Recl8lCmD9VXMIuy59UxBFt44Xnnso6mSd34okiAQLpri4R7d+nUWbtheFNWj1OOp776N7hinOdE55Ogr4GDHSRNKQtiTS6fddWkimPD9KdG48H4dhmTu7dIcQLtuCoFH7MqCqNxrgxPdp+gp8lVPO8+v0uk2Hzl2W+pvkAqHtJJG191f/zNuVBmYBtLYb5ik2wBV2io+OQEwukn6BfgkqCzdSITj4g+HMTUNBaa4q4nDpkdtarlMXECDt8fx9MvSI863RiISJJL4Kbj9jbwyY6zx9fyJnEentyy+5i1TxCvY8qgRnkr/krHGN3xNypgj8evxdTvp0SP5QVr4fwr49yleBtg5GlZIxOwJHAKJ1OQiw6xxAUgbZ7Blgn0Dojo8r69S+/TWlDf8n4A9o2TFZObiICqs2r28VQB4ez0IYma4cwM7SRFEQG/XGob3642tThvDbhwG80CKJw0AVFZL+p2MGtB/c7hLSpAYEjfnGkvBvjkm7YQBTK2nVqne6w3cE8SD/uOSwXCxy64yuVE3Kmzdn4nvhDRlit1Mlm6YpKFOnHgwhVNvvWGwmG3eOmZ0S0l9eyNQ1Vo5c7SisoQjgc2AvD2Awo++x3mw4rNhJ379811kTfs2MRTKma7kmD5OqDwHl
 P/SO/7Le
 zhFTgg3Q64U3jQi2+lAtu3UN/g5Uv3dDzumRidtU7D3QDQs53XlnWBpaSBJ2cXWfsnXai3oW+mlf4PX2boKYjn7R5cgDsZSmqqD78MLku9lGpA0NPSkxsXORFDeOec5/APT+gv3wsJaMvlSMwlnCA79rMgzU7S6TtfkOCNvZjIVoo8zOUNHIiakw9jwAnoL85n7N+tRnLfKFzUlmIkryGwYUeiSHPLazJx4kKbX8t9J19asr3/xtaA3peO96zPeR1CIlpir7+M3bqRZwcsuOMBztL32WgK/0wmgbKWrR9ytXV7CL6iZfNgy7QvsNn0j8hXhuwdogBpK7eAMjJPHJj5wArdHo4KN5OeB+x7fU/fgxemsSlzy1rZa2b8Yu/191qW23v+9OqvBY+8M7cBvY3aIIcU3/v96//FsmOGqsDpEmfc7r5Y9vnJFKrBCIKHr0IaMtQ6B1f9r1x8UMLSXKUa+1mVqM/GBHKB4izumgoTXI5ymN/GPpEjq+Q2ywgyRWeht7YJnQOCZmqTtR7RiM08TWgP9Xrd+93SonHzh531xanaXKV0RUKKobcYbr1I/g7iNDWGranR67CliIotZZrJhcQGCT8anPSBxseqt74GE+7J68uQVXBJx04z6luvxTPUY/YAxZy15JVxwBs3F1IOuUcIvkMnqray8OAmX044xAmY4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/30 13:59, Sourabh Jain 写道:
> Hello Jinjie,
> 
> Coiby is handling this issue in the below patch series:
> https://lore.kernel.org/all/20260828084900.1496839-2-coiby.xu@gmail.com/
> 
> Since the above patch series is all about crash_load_dm_crypt_keys,
> could you
> please consider dropping this patch from your series and reviewing his
> patch
> instead?

Absolutely, happy to do so — I'll drop this patch and review Coiby's
series instead.

> 
> Thanks,
> Sourabh Jain
> 
> On 26/08/26 14:55, Jinjie Ruan wrote:
>> `keys_header` was freed in `build_keys_header()` without being reset
>> to NULL, and the error path in `crash_load_dm_crypt_keys()` freed it
>> unconditionally even when reused, leading to double-free or
>> use-after-free.
>>
>> Add `free_keys_header()` to centralize freeing and NULL-setting.
>> Use it in `build_keys_header()` and only free in the error path when
>> the header was newly built (`!is_dm_key_reused`).
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Baoquan He <bhe@redhat.com>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
>> Cc: Pratyush Yadav <pratyush@kernel.org>
>> Cc: Dave Young <ruirui.yang@linux.dev>
>> Cc: stable@vger.kernel.org
>> Fixes: e3a84be1ec2f ("arm64,ppc64le/kdump: pass dm-crypt keys to kdump
>> kernel")
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>> ---
>>   kernel/crash_dump_dm_crypt.c | 15 +++++++++++----
>>   1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/crash_dump_dm_crypt.c b/kernel/crash_dump_dm_crypt.c
>> index c685497cd470..ed0960ff0987 100644
>> --- a/kernel/crash_dump_dm_crypt.c
>> +++ b/kernel/crash_dump_dm_crypt.c
>> @@ -363,15 +363,21 @@ static struct configfs_subsystem
>> config_keys_subsys = {
>>       },
>>   };
>>   +static void free_keys_header(void)
>> +{
>> +    if (keys_header) {
>> +        kvfree(keys_header);
>> +        keys_header = NULL;
>> +    }
>> +}
>> +
>>   static int build_keys_header(void)
>>   {
>>       struct config_item *item = NULL;
>>       struct config_key *key;
>>       int i, r;
>>   -    if (keys_header != NULL)
>> -        kvfree(keys_header);
>> -
>> +    free_keys_header();
>>       keys_header = kzalloc(get_keys_header_size(key_count), GFP_KERNEL);
>>       if (!keys_header)
>>           return -ENOMEM;
>> @@ -441,7 +447,8 @@ int crash_load_dm_crypt_keys(struct kimage *image)
>>       r = kexec_add_buffer(&kbuf);
>>       if (r) {
>>           pr_err("Failed to call kexec_add_buffer, ret=%d\n", r);
>> -        kvfree((void *)kbuf.buffer);
>> +        if (!is_dm_key_reused)
>> +            free_keys_header();
>>           return r;
>>       }
>>       image->dm_crypt_keys_addr = kbuf.mem;
> 


