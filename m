Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EEC3C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9FE06B0092; Tue,  8 Sep 2026 03:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B509B6B0093; Tue,  8 Sep 2026 03:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66556B0095; Tue,  8 Sep 2026 03:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 811EA6B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:23:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0604C1A03A3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:23:22 +0000 (UTC)
X-FDA: 85189754244.30.686227C
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F01640003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:23:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hyaS2dA6;
	spf=pass (imf12.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788852200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7nz+2I01rp2LskTbFRR2FK0vPBroOC8XutcipcnIsM=;
	b=3M3Y9/2Hxp1c2FNDbcBb68sBDgWk3t3b5yBaGMSrACoAvevzxjTA+8v96PmjDNj9ifPpYV
	VUNWnhu+QaWUXJukHref6z4nOvfw0YvBk8jPGjqvU+oLQSVNl2+WPacDtIjv4FdmSIMV8i
	aA+qI1OgjnYYcRnT7DBTlTrg5AaySlo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=hyaS2dA6;
	spf=pass (imf12.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788852200;
	b=WCYQmxbQQUWM6fiV0rZwV7cn5qLUHBIjmYPyM3R808BRmqUBTtuiQyX5H7+l/5q4HHyRgK
	8osqs0wj1O9bKVU/326pzsJYF1/Ejr5LufBUKjoFluf84QuJJgl44f/pFgPWSpNv4sfXJp
	zv9Pc0/Gpu4DKQqAJWzOcEyKWTtlCRs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=G7nz+2I01rp2LskTbFRR2FK0vPBroOC8XutcipcnIsM=;
	b=hyaS2dA64DcCg3GRIM7kcjDzC2hUqQBzbi0wYEmlK75paxqrzZ4Qk09vQIT+D6ItcGzT9PK7K
	+Fa6fiPBtKYscFQTRzVIbY6yweWimJ2oM5lKsGuwlq23S1Lfx1H1u//nCgErq4AFzAXXYPebOeM
	yjA4Etr6FTTSMfxdr1fEXw0=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hfFVy3mfZzKmVp;
	Tue,  8 Sep 2026 15:12:10 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id D100C40586;
	Tue,  8 Sep 2026 15:23:07 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemk200008.china.huawei.com (7.202.194.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 8 Sep 2026 15:23:05 +0800
Message-ID: <92050fca-96ff-46e6-aca8-3cecd7cfb778@huawei.com>
Date: Tue, 8 Sep 2026 15:23:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/12] LoongArch: kexec_file: Fix CMA page leaks in
 segment placement retry loops
To: Huacai Chen <chenhuacai@kernel.org>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<kernel@xen0n.name>, <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
	<npiggin@gmail.com>, <chleroy@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <akpm@linux-foundation.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<jic23@kernel.org>, <tan.shaopeng@jp.fujitsu.com>, <zengheng4@huawei.com>,
	<james.morse@arm.com>, <ardb@kernel.org>, <leitao@debian.org>,
	<yeoreum.yun@arm.com>, <sourabhjain@linux.ibm.com>, <robh@kernel.org>,
	<coxu@redhat.com>, <tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>,
	<adityag@linux.ibm.com>, <djbw@kernel.org>, <seanjc@google.com>,
	<liaoyuanhong@vivo.com>, <vishal.l.verma@intel.com>,
	<fuqiang.wang@easystack.cn>, <makb@juniper.net>, <piliu@redhat.com>,
	<ebiggers@kernel.org>, <jbouron@amazon.com>, <mclapinski@google.com>,
	<me@linux.beauty>, <graf@amazon.com>, <bgwin@google.com>,
	<takahiro.akashi@linaro.org>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260907125404.922123-1-ruanjinjie@huawei.com>
 <20260907125404.922123-6-ruanjinjie@huawei.com>
 <CAAhV-H7qjJ7BPnJ2KoQZSyMUvX_6i9H=EfdadXnmXtNiiB4ROA@mail.gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <CAAhV-H7qjJ7BPnJ2KoQZSyMUvX_6i9H=EfdadXnmXtNiiB4ROA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Stat-Signature: h3cxbmicx6qfnsiqzemka3i397bcjd4b
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F01640003
X-Rspam-User: 
X-HE-Tag: 1788852198-583714
X-HE-Meta: U2FsdGVkX19qklpZ/RCzttVKGZzEZKjL51+7Ig47Ra5ED+Vyz03v0bH/YZbuATRSr8JmdGRa40MUTIoUoFJP05G67yO0mXcbWmUboFGutcskU7dWc9WUmdWIeveVmhMsVJn5DVtZS9Jjs1oHHVbrtsuVKgfRE53m+3YyDh9D9d9YYiTqi+ZvX0yprID8H3sDd2lhwyxm+JgO950qztBn5LeL/HerjdIPxxDydRR/y91ix3r+PU8KsTnQsIMLLHGkY7gWFlkxhNxSnL+9rdEB+tsSPGdT8gdsuQr0oekW3C8MI3iXdVX5t9uToM13wucJOGG1F6C+lqD/XxE9OaNGxFhhwfegizFObwZDZZ9gONqcBVTndgyTUqCRrfYOZ+08+X8hzY1Lxd+vh7Ad/mJDeTQbrb55TXC3Sbz/rUYowLA15OcLzV+nNjy4nlz+rz0+7iPvm4goH36w7C1FtLpw5YPnKKroDYpZ20KjWwOUq0vUaGkKknsmKxw7ODNz8I2w+wF1i16jltYw0PWtDBwP6RZKNn2/Ms72l6Gvu+Hxi3jgEg61SMt0diTj0vsgNvL9aBLplpYab2LsuNt/gu7rDIr/yvDt9/VYsTisG4pbXJ5pVsd1ypgn+/qg+oRJSbzZWNAAr9s6XIe+ewIVYz0OEB4c5iqHWekOPSDHJWuxuOpYVarM8i1RTqOrd9BOZkac1ZTutEMMeYowCN8ojbr+uOt1Ez/LId7gsYpsRTbRAJJL1d4WLQvcznlxDETCk0s+2kadehldzYJv5vYR+f5xmH48WtOeLzlXS0mrfsnFyRasZvsyhLsacKTVhklg0gZFX32SuBiPTHTHLJODRrMFdC236l93f0qBbX/cN4dagupxftHK7aEAbCKD0UiiIIDcWAzFZ4eYv5D5Ic58wW+bFl63FPorreu5VJ/Ezd7YhNXtUKGu0fXeJcOXK5i399UXZQpr11QxtgvhRQkhkIf
 rzQJGsKJ
 eQhBzdGiwoQksLJ/jojuhWF5i+E6SYPW03+psHVohHAWrbKY/xD1Yrjjs0m6/esw6At9j/FoVJbnC892Q4zG9y4QwkTW63qBCtXLeh3TFdLSzTVJvZxYYhNjxKhCDuOPHdPnVnkRA2vUjsRWW6rjy4FJ4dApDHFOPOtdqlhibGiaBOzllcqMpVjIy/tKT8Veha5oerf1t1NU52p8rm8gXonIMNpPbpOQrYiDkNVil6/G1L1BOMuTKf2KxfNQG0Ljq76D3S0t9y2rU9WVHYGbqv+0At8mzcenRut+bq1GDUsnkZOBIo9Iq4+94gSvkWDl3SEpHorfPoSZ74tokNDnAEyk+pjMNdt4yw0/NHvd3f2+UpD2GV6/9U4jLP7Uu1Tg5si29aE9y6q+1/qnZ2KaFbRZaCjr9zSVpQ4BnpIfdVvziXLVBdNhW/QP8y2JuLDpf8DluFGt7/shDedTfGWaxQmNnKUF6jRFZfK0tF46csVE9fFnl4mZ5lur1KmaHBgugkWRrrqb4s0aYZWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/7 22:05, Huacai Chen 写道:
> Hi, Jinjie,

Hi Huacai,

> 
> On Mon, Sep 7, 2026 at 8:53 PM Jinjie Ruan <ruanjinjie@huawei.com> wrote:
>>
>> During kexec image placement retry loops, any midway failure causes
>> the loader to truncate `image->nr_segments` back to its initial state
>> to purge the failed segments.
>>
>> However, this truncation introduces a memory leak. The CMA pages
>> allocated via kexec_add_buffer() during the failed attempt are tracked
>> in the `image->segment_cma` array. Because the subsequent cleanup paths
>> only iterate up to the truncated `nr_segments` boundary, these allocated
>> CMA pages outside the new boundary are permanently leaked.
>>
>> Fix this by explicitly releasing the associated CMA buffers in
>> the failure paths before `image->nr_segments` is reduced.
> I'm not sure but does the elf version have similar problems as the efi version?

This issue does not exist in the ELF version, as the retry loop for
load_other_segments() does not exit here.

Best regards,
Jinjie

> 
> Huacai
> 
>>
>> Cc: Huacai Chen <chenhuacai@kernel.org>
>> Cc: WANG Xuerui <kernel@xen0n.name>
>> Cc: Youling Tang <tangyouling@kylinos.cn>
>> Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>> Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
>> Cc: Kees Cook <kees@kernel.org>
>> Cc: stable@vger.kernel.org
>> Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%40huawei.com
>> Fixes: 55d990f0084c ("LoongArch: Add EFI binary support for kexec_file")
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>> ---
>>  arch/loongarch/kernel/kexec_efi.c          | 1 +
>>  arch/loongarch/kernel/machine_kexec_file.c | 6 +++++-
>>  2 files changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/loongarch/kernel/kexec_efi.c b/arch/loongarch/kernel/kexec_efi.c
>> index 5ee78ebb1546..15fd797ff3de 100644
>> --- a/arch/loongarch/kernel/kexec_efi.c
>> +++ b/arch/loongarch/kernel/kexec_efi.c
>> @@ -86,6 +86,7 @@ static void *efi_kexec_load(struct kimage *image,
>>                  * We couldn't find space for the other segments; erase the
>>                  * kernel segment and try the next available hole.
>>                  */
>> +               kexec_free_segment_cma(image, kernel_segment_number);
>>                 image->nr_segments -= 1;
>>                 kbuf.buf_min = kernel_segment->mem + kernel_segment->memsz;
>>                 kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
>> diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
>> index 5412aa9f3568..62a5be102065 100644
>> --- a/arch/loongarch/kernel/machine_kexec_file.c
>> +++ b/arch/loongarch/kernel/machine_kexec_file.c
>> @@ -217,7 +217,11 @@ int load_other_segments(struct kimage *image,
>>         return 0;
>>
>>  out_err:
>> -       image->nr_segments = orig_segments;
>> +       while (image->nr_segments > orig_segments) {
>> +               kexec_free_segment_cma(image, image->nr_segments - 1);
>> +               image->nr_segments--;
>> +       }
>> +
>>         kfree(modified_cmdline);
>>         return ret;
>>  }
>> --
>> 2.34.1
>>


