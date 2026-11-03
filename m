Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD155606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84736B05B6; Mon,  2 Nov 2026 20:52:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D356E6B05B8; Mon,  2 Nov 2026 20:52:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DD16B05B9; Mon,  2 Nov 2026 20:52:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 946086B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:52:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDB7C1C34EE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:52:23 +0000 (UTC)
X-FDA: 85392132966.03.024FF9F
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0DA60180005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:52:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793670741;
	b=w9b/VJ6P8NdF+rtJ/z+aEJyMApMj0wx4Wba+7PnmugIb0p3HmSw5Aktro8/NXuArvxPoG9
	F05r76TB8/wzHVOEBNOgaVoCS2HsDdbngH25/VPQvDjruzualbI7Ti569vBqG2bSIKTamb
	HoTDmXvwojyGTrgll9CYA4fB/TKLsw8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793670741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RtyNW0gmNKu+F4S4geYgGRfWCseBxV4f/FbulQHc5qY=;
	b=O5zkXnQSUoTaPj1BbBAmj08FEiJKFoPe+ts6897WlenPZkz5WX7V6TkzfNYsWbl2Q0/GG6
	BDwVhbIX2fSqlcjsgf16v71tYvdxlwES9w0DSznpZiHFlLp20uZjbV8TyR9aJro51v71iW
	0zWUzC91mLG3UpnqmFoCh3F/xgC4CMY=
Received: from loongson.cn (unknown [123.138.236.242])
	by gateway (Coremail) with SMTP id _____8Axj9FNPulqEc0bAA--.15278S3;
	Tue, 03 Nov 2026 09:52:13 +0800 (CST)
Received: from [127.0.0.1] (unknown [123.138.236.242])
	by front1 (Coremail) with SMTP id qMiowJDxBc1MPulq3QkyAA--.9889S2;
	Tue, 03 Nov 2026 09:52:12 +0800 (CST)
Subject: Re: [PATCH v1] mm/slub: Genericize x86-specific cmpxchg16b comment
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 loongarch@lists.linux.dev, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261102082730.12430-1-yangtiezhu@loongson.cn>
 <auihvtpGJPDbb4Hz@thinkstation>
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <5ce58389-db68-54f2-51fb-0d43b0e0cb2d@loongson.cn>
Date: Tue, 3 Nov 2026 09:52:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <auihvtpGJPDbb4Hz@thinkstation>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxBc1MPulq3QkyAA--.9889S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Ar13WFyktF43uFyDCF13WrX_yoW8Gr18pa
	yktFW8X398Xr1a9ws7Ca17Ww1fXa4UKr97Cw15G348Jr9xKr15GFy0yrWfWayrXryS9342
	kas2qFW3Zw4UXFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zwZ7UU
	UUU==
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0DA60180005
X-Stat-Signature: pcc3ua7fzqa8oqeyqq9mwfospu7o81bp
X-Rspam-User: 
X-HE-Tag: 1793670739-712560
X-HE-Meta: U2FsdGVkX1/kHZl5qu/hKFXdjBDHXz8e41VfWHK2VrXsuoVAYdfi2EkWw0mbZVmpuFZp02tRbKyA8zgihMDdnyy6pw6RrcbthvmfQYb6amaSA0nBOvitp2zc1RnlVFOn9606AcsyEIAmg49i0M3AZeB7WV/Qm3m2Qe29y2kNFApGL16Pkigx5QlAFowwvMCpa0VJXRaTr84UK05LN51B5lmtzW6/p1A8B4m5UOs9oS2iJy7o425m9JG2H6SCgcDJ6gK2dLnH2pNvkz1hHyzb0R4dOOGpnuE/Y5wFJQAm9hO10PBfDUJtg6R5kQF06LpspZ2UOKlU1oKsLPCRbCLvkHdxpClb714iyNr00zBINtzr7gFYTxuKVCaXG6mlIMwoTntDetCx++sga9v1ZG7jk6oksZmgMBGOEyvC//JwnhVsEQVcm9beMaYIS2bpmLjzx/nFcW95YPVOUHnUak+CtBFdMhHD+EV3bebAajLzq0ZAVR5I/kAiNoby3Cs24LCBZaAv/vIYNteVgMaAACQpXdUhCpRP/9zChIKV4x+cG25oX3zbEahsTf9uHVK3f5dsGNR4+PNLSjAmV4zs0UlV1bDgZEZgutswZH6YLkp2GHtfCX4cfTG2mYSpOA6AOzLWmJdG6xZi3qRGKXQBB8UYw6Oz0Qr2n7k/oij037CpTWh9Yw1pGyUm9gsau4jGzTKLjaOfYMkV/R0BgCLRnnHsuimZf5xT82BK/BWNJ6WLSrITSfPKSj+5zRVJCyNgKANbXNBJcMxWDJfu/9Z/y5xlIQ1ogHmqnQS2q5o8UwUfTYuJeMM9dDbmidOA1lNsp4xnfAerHnhksIDAblYdCdX++ee4qSMdKGlYfDzamrZKHBOhVb8KVWLiTRTTU2EFTwI1IhbRbQxSObWaa01FFGSjMQbvrSFVduU5qG/L0XodevIh0o7uLE/drSdY7m8RlAYI+tGIw+jCZUMujcTe8Uy
 expd5UFv
 PVxCekSy0fD2sEfyBAB1fgWhCy4yjSdz9sNxF3T10Qck58Q4sUs37B6bWLRvk718tWEi1bZxwWEtg5xFEyaVqmYOscw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/2 下午10:49, Harry Yoo wrote:
> On Mon, Nov 02, 2026 at 04:27:30PM +0800, Tiezhu Yang wrote:
>> The kmalloc_nolock() infrastructure relies on slab caches with double-word
>> atomic cmpxchg capabilities (__CMPXCHG_DOUBLE). The current inline comment
>> in __kmalloc_nolock_noprof() uses 'cmpxchg16b' as the prerequisite hardware
>> capability.

...

>> diff --git a/mm/slub.c b/mm/slub.c
>> index 45e077c7526c..216bc6b5d776 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -5589,8 +5589,8 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
>>   	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
>>   		/*
>>   		 * kmalloc_nolock() is not supported on architectures that
>> -		 * don't implement cmpxchg16b and thus need slab_lock()
>> -		 * which could be preempted by a nmi.
>> +		 * don't implement 128-bit atomic cmpxchg and thus need
>> +		 * slab_lock() which could be preempted by a nmi.
> 
> maybe "double-width atomic cmpxchg" is more accurate considering
> e.g.) x86-32 implements cmpxchg8b?

OK. Using "double-width atomic cmpxchg" is much more accurate
as it perfectly covers both 32-bit and 64-bit platforms, and
aligns well with the __CMPXCHG_DOUBLE flag.

I will send out v2 with this update later if no more comments.

Thanks,
Tiezhu


