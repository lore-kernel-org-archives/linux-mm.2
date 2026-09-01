Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71BBEC624CE
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 01:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635A56B0095; Mon, 31 Aug 2026 21:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60D536B0096; Mon, 31 Aug 2026 21:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BDF6B0098; Mon, 31 Aug 2026 21:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 266CD6B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:41:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89F111A031D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:41:24 +0000 (UTC)
X-FDA: 85163490888.03.8F488AD
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf19.hostedemail.com (Postfix) with ESMTP id D1FEC1A0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:41:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Jml/HTTQ";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788226882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPvP1K9EnRd/mao8eJm5iib0cl/6wBDf4gm9yBOU/uA=;
	b=FQXKWi2BTF7oFifW+yqipquvZTkvrBIUxF86NS21wzkf2KLA6WRQ5aaF2g0KR1qAwjBY0/
	YRZo8NuRdy+jXSYxdtNUNzi2FdAFMHoZkGvEbFSn3j0eU1vX8H1IyJfTtK7ls+u/MLabzb
	mv1gxxmgzD79iFn9jdecH/VCbKBgt+E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Jml/HTTQ";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788226882;
	b=NS+ovhm0ViJcFW4rfF3M1cflQmNlQUgaBJXwwAyavvA4a9hYcJUJlLcYjl/Bw8dcFvUIov
	iG4+9p4gdj1/5cngd0SjVMY6A0hIKDaO/M+S+O++bHAGbTjmztVrzBnxsoXPAhCvM/Vw3S
	2Cb5fRi00gLDaNq6UqINn+3luYLG7xI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zPvP1K9EnRd/mao8eJm5iib0cl/6wBDf4gm9yBOU/uA=;
	b=Jml/HTTQck/emuqLeeU2tibQLYjU8fXxCCcdo3klXPgO8NzCaTkbd5ycSpoG64qAUTvikX/3F
	607VcvF+fmYaem7r38R+LD9SNSgKkzUeX3TLkcP4y7zA0vceMDXkYNbj0KO3qWM1ZVKio3aaJuW
	cW+wJefcVETqqA/xk+td/6E=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hYpFv2FTwzRhVN;
	Tue,  1 Sep 2026 09:30:27 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 689A840561;
	Tue,  1 Sep 2026 09:41:14 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 1 Sep 2026 09:41:10 +0800
Message-ID: <fa771c74-c0b0-435d-9ebf-e52c00865c90@huawei.com>
Date: Tue, 1 Sep 2026 09:41:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/17] LoongArch: kexec: Fix CMA page leaks in segment
 placement retry loops
To: Huacai Chen <chenhuacai@kernel.org>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<kernel@xen0n.name>, <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
	<npiggin@gmail.com>, <chleroy@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <akpm@linux-foundation.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<gshan@redhat.com>, <jic23@kernel.org>, <james.morse@arm.com>,
	<ardb@kernel.org>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <coxu@redhat.com>, <tangyouling@kylinos.cn>,
	<hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<ionut.nechita@windriver.com>, <liaoyuanhong@vivo.com>, <seanjc@google.com>,
	<fuqiang.wang@easystack.cn>, <makb@juniper.net>, <piliu@redhat.com>,
	<ebiggers@kernel.org>, <jbouron@amazon.com>, <mclapinski@google.com>,
	<me@linux.beauty>, <graf@amazon.com>, <bgwin@google.com>, <robh@kernel.org>,
	<takahiro.akashi@linaro.org>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
 <20260826092541.3905933-6-ruanjinjie@huawei.com>
 <CAAhV-H7+dO2rnb4KxRvVo1w_Mx8Vfsdq7LAbkzPfNYrwUhEtfg@mail.gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <CAAhV-H7+dO2rnb4KxRvVo1w_Mx8Vfsdq7LAbkzPfNYrwUhEtfg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D1FEC1A0007
X-Stat-Signature: uxw53e68bpwbf8yhjgxdt8n9w5b613f4
X-Rspam-User: 
X-HE-Tag: 1788226880-648637
X-HE-Meta: U2FsdGVkX1+pcIDhjW/6JLjiu4+zbh5AnX+dmqd4jG86lB8zkZb6/5LAli4CBHs3s4ePm9zFjA8l03KEdyT42N+Qa4E0nlTet8B0bW/Kjbwkvo4eJ8yzsB0HMgFgoH+FGx/GeusLGbjDb+ksKM281pCF0O5UUfiKk9AohmseUxvc6EjGR1OOUYH5xzzhXSHSt623cL+XekTERld+bxh/uYoadBO71MBiDXCdXl9bOww1Vv+jp+jrAeoMKn4ituFEKDLcDeZCjSbAGp5FzrHoK75eZ8WcotWuRdX12IkNMQD3aZ2ZuhZlpOBlaggKmF+RT78EPWrJbft/r369PlwXuJZPyd/9sZNy84aDypx8qNrM7TO5BbwVjD00vc1kP7xoFp+fFuG/rWuJazzFRP3S7CronEclIE/cNpIscktEpW1GNFFWSM3oAJbDkIP7dODwiDZDRN8O1CfU1CeCa0D5NHfZfwid6jsp5th4faA8BL9LLtiOmwa9CoAhkRbW0D62ylyyTtPKmiUe11lq4YYZjZwGdywXv2E1S3tG+/yOzzAaAMfqFnhZgQGJkg4ypV0g2W5QcCMuvii67+CnPR1DEqQcmxXSgZR7gLWxwEsNC6054smiY1b2LtoDsvtAwQ0YnW44b9ohBHVMsedWBLzDhTZ/NYv1eAlOsLt4OWH+hAUysUMEqqJweMnCjk6zX7YyjRNAXJb4ZFOjQ9lCB02ozDidG/ViuKOMmvl16AyX7D0jM7ftzyLaW+wBPbTB8p3d5aE0in+Hj2dFe7dqsMTmPs0fi43r4eFF+pmKUPuVjDYkHDdWlRUirCPX5G1ytCTZFYL4CwG/8OlXiIUa37+YqFNGOHbC1ylD2ysC8WPYphcUsa7wzNQqfYdKTSUc38wSEfQ990mbVExHSjwLBCk2+4bKx4Y3ibSNuww45uXxv1rtWCoH/lA/XoXU9qCCCPnb8bJJ8Uyr9e+D3+1tQ6Q
 gZnNv52T
 fXOqiM4PsUc9wRrgoWO9U5fyfwt4r2evi6UOXfD9umw/vyh0NdFTkptyW1Kb3RgjVIQcLSYFN9vv6nVouuDz78/ihaRY/VcHqelSowZEDitY21OeMCq2qrQknsUUS1y4iIo2SH/IEXAofxOaOCOSvtZeo14jAyG9Z7fgtcP3VkFHSG9UtoVyxWoeP2StALB2NMZkOR9GaO6woZG8zbVdGiAsOIMm1sqvEMnO1pE7v2Zdtj0+s6v8J3nshXxrIeUQ6TXD2rq6jzDRd60IHAcU/vC3/hLssaxqtV+jJO+EWoXPSg3FuyyrLd10LjDDWpj3FVaHjev70tjySh1/vnZ9/m2kXfMuvKNErw2Tw/g7H2RAwx5IdGbc+/hDTYht1E8Mx4gs8Ap52hfMpucXGvcMaWcCCwiS7RlSVyHsdtyN3BysqWk6yj4/V1+az0aWXfHpotB427OMxasFoIePmcpgvSp0R0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/31 22:09, Huacai Chen 写道:
> Hi, Jinjie,
> 
> Why does the ARM64 version of this patch use "kexec_file" in the
> subject line but the LoongArch version uses "kexec"? It is better to
> keep consistency.

Hi Huacai,

Thank you for the review. I will revise the subject in v4.

Best regards,
Jinjie

> 
> Huacai
> 
> On Wed, Aug 26, 2026 at 5:25 PM Jinjie Ruan <ruanjinjie@huawei.com> wrote:
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


