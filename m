Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75A1FCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 01:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1BD6B00A0; Thu, 25 Jun 2026 21:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A91A6B00A1; Thu, 25 Jun 2026 21:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8F36B00A2; Thu, 25 Jun 2026 21:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 144C36B00A0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:55:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A926C19FA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:55:34 +0000 (UTC)
X-FDA: 84920396988.28.5296C47
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf09.hostedemail.com (Postfix) with ESMTP id 41069140004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:55:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of pengyu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=pengyu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782438932;
	b=6Nr+zqiLRVwpbs3Ia16DKCF9KjcaYP9Nsb+sn9QP4wk2fDe0b/II4M9Sd268X9R102k6Gy
	6aEN5kZozCxrI9Ctn4ZNDIdLvu2LnNg75DEOJgFCiAnkUeZ+NayJEy0vdsnWy3+IuDiv9v
	hs1L5N8DpUSHGJ10bHWnSvHOUM+ECgc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782438932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s0xCP4KWu4tvRGx1Bk35Nb1XpPf59ZmNkKNUUYsYMDM=;
	b=QBRH/xRfM/5hsD5wjaJG8cez4hfZovPJ82ONfHU9Tu+56O97hxfVB283JRnFu6D4utPmnW
	9Ju6aPM3QEvf4T2ZP2g+galgOqbJKLuRGUs8kxP+8UQ7d4ZwRxe8RJsOXTgHS9vydkD1B7
	NP+K+iYe9RRN/dyblspkgX839AcuH5Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of pengyu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=pengyu@kylinos.cn;
	dmarc=none
X-UUID: 167634d8710211f1aa26b74ffac11d73-20260626
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:9c9653c2-96d6-4a31-8a6e-5fc2d3a26971,IP:0,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:2
X-CID-META: VersionHash:e7bac3a,CLOUDID:d89af0c5808b4f65f03b3c06f107fd71,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|865|898,TC:nil,Content:4
	|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,O
	SI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 167634d8710211f1aa26b74ffac11d73-20260626
X-User: pengyu@kylinos.cn
Received: from [192.168.31.66] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <pengyu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 156880850; Fri, 26 Jun 2026 09:55:20 +0800
Message-ID: <08fd96fa-ee3a-4904-bd11-bb08bd90436f@kylinos.cn>
Date: Fri, 26 Jun 2026 09:55:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] arm64: early_ioremap fails to map ACPI MADT on 64K pages
To: Will Deacon <will@kernel.org>
Cc: lpieralisi@kernel.org, akpm@linux-foundation.org,
 catalin.marinas@arm.com, guohanjun@huawei.com, lenb@kernel.org,
 linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, rafael@kernel.org,
 sudeep.holla@kernel.org
References: <ajkFE6TmwW6B/huP@lpieralisi>
 <20260623024712.3480399-1-pengyu@kylinos.cn>
 <ajp25MIQJWWE1ziY@willie-the-truck>
From: Yu Peng <pengyu@kylinos.cn>
In-Reply-To: <ajp25MIQJWWE1ziY@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 41069140004
X-Stat-Signature: z6sg11uethqew7eqtuzobjz1w3jcanf5
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782438930-159575
X-HE-Meta: U2FsdGVkX18sXze4Y8Y/gboRNa6s1UMYDxlH9OZV1WKxYMhVfxFgJJ9HWB4V1XFXvP3vM7Z3nKt2M9VxE44zvzSuog7xndqvR/aiGwrcCHm2FaDEOD9uedd8TKsbKz8YXO6p1sstDMMjy69WXWmaDxQ3x27mVb8x0J/Av6ZZdJ89b/y9Tww7+5RhbgoNSSEtUGQD6Ns3CiQiBawm+HxR24WqLYNbojJV/33tCNjs7Jo6p1QFjd19bKXjHhalL974kfFvAkZ9q5Neb/vATqQmqRASG32Q5vcVkASPNMpHt4aaVlQgcIDidKvoCXEr2attzt/3J8gNPJpmSE7J4KdCd4+IlemEmrfRYOVgjJjGw0JOwQ2it9kpemaY9D43MfgN6SJ5jRkcPwTzzqywKS9uD14REOGb1jAPf4QHRN9pyyl05xRlC6/KQfHtSJusCCSiyiRdGObZPIRbwHBp/gYqw8UM5nMsp7lqPweeTIpdv/B4B3qd4sj5r5/gp4iKwbq5NAFKAlTfcQfIxRJPCfvHamnkrXAgxL0zKFZEfACa+9w/qJ1V+ngTkG66lygcpg4j7RLhGbpB0p+rq0HcDyiyG3kdAubCDUZdchG/Hc3uQdmoTF/E65w0WNnyXPqw5PIWO8GIlZo7A5sn+UKsDuYg+nwrTzDcz9jgvVsCh2DVuKoXxTphYjzEeVOoE895KDqsLSIZrgdesAL2Co7+fVyNkMvprRSsE0BgWGqpDzvFI2/9KbTUN/fqehwDYQvBda6Fc6HhKOCtilUHbdeLIoLAwQST2+AlGxFEZkefJSgrVn2uSvq+bKfc3HWVnu+1bnswSiH//CpF+1yBEE6WpcGmQ0T5iyOgaQLf+8IRk9wMe+IS4UlLQurPESs+Gg7xuOOxRw31aDdxmT8IZRO5IgzPjLlRK6Sx3h/1O/qrdPlyXVu+9Xlke/w6ZVesiZRZxmNUEWhg2SUGyh878fc8YX7
 QPy++uZA
 hlQm/YHLwfNtRLpOgeh53QsbfuzXjE28ow38um36SSx3dDKyQKRjDlZ7OA/54yh815N+pZdh21TQ+VpsFpaCPFcLsdX4qqLImhZV2hpR7mmzlsjU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/2026 8:07 PM, Will Deacon wrote:
> On Tue, Jun 23, 2026 at 10:47:12AM +0800, Yu Peng wrote:
>> Hi Lorenzo, Hanjun, Will,
>>
>> Thanks for confirming.
>>
>> I will send a proper patch for this. The change I plan to post is along
>> these lines:
>>
>> diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
>> index ... .. ...
>> --- a/arch/arm64/include/asm/fixmap.h
>> +++ b/arch/arm64/include/asm/fixmap.h
>> @@ -79,7 +79,11 @@ enum fixed_addresses {
>>   	 * Temporary boot-time mappings, used by early_ioremap(),
>>   	 * before ioremap() is functional.
>>   	 */
>> +#ifdef CONFIG_ARM64_64K_PAGES
>> +#define NR_FIX_BTMAPS		(SZ_512K / PAGE_SIZE)
>> +#else
>>   #define NR_FIX_BTMAPS		(SZ_256K / PAGE_SIZE)
>> +#endif
>>   #define FIX_BTMAPS_SLOTS	7
>>   #define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
> 
> I still don't understand why this issue is specific to 64k pages, though.
> 
> In the example you gave, the thing wasn't even 4k aligned.
> 
> Will

You're right, this is not specific to 64K pages.

I looked at 64K first because the current slot is only 4 pages there,
compared with 64 pages on 4K. Any initial offset therefore leaves much
less room in the page-aligned span.

A blanket SZ_512K slot does not look right either. On 4K pages it would
make the boot-ioremap area 512K * 7 = 3.5M, while arm64 requires it to
stay within one PMD:

   /*
    * The boot-ioremap range spans multiple pmds, for which
    * we are not prepared:
    */
   BUILD_BUG_ON((__fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT)
	       != (__fix_to_virt(FIX_BTMAP_END) >> PMD_SHIFT));

So I think the better fix is to preserve the 256K payload budget and add
one page for the possible initial offset:

#define NR_FIX_BTMAPS		((SZ_256K / PAGE_SIZE) + 1)

That should allow any table up to 256K to be mapped regardless of its
initial offset, without exceeding the single-PMD constraint.

Does this direction sound reasonable?

Thanks,
Yu Peng

