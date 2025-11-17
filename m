Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 290EACE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 06:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759218E0005; Mon, 17 Nov 2025 01:42:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709E98E0002; Mon, 17 Nov 2025 01:42:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61F728E0005; Mon, 17 Nov 2025 01:42:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 507DE8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 01:42:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9C8C4E290
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:42:11 +0000 (UTC)
X-FDA: 84119154462.21.B37D966
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf23.hostedemail.com (Postfix) with ESMTP id F0B90140009
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:42:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LXkvl6fW;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763361730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F61/44VrimXOAEuXiMeNmI+aj0JYokmyCnACi/yOoLA=;
	b=xGQCterUeW4gOFqR/dR0eDu3ksw9XXxyOgCiZbmU+t6n9mpi+IhDY9ouAQTN2VCcXmwYFw
	sEgVHHE4RjTwmjWFr7Df7JStljhjE6snZhEyOhmQPMzsPZdCfX3DLxl2F7Y2R/FXLTFAll
	jjiNAUGtUMENGxbIt0ILEafQB5hujVo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LXkvl6fW;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763361730; a=rsa-sha256;
	cv=none;
	b=7G2JJk1lxN2OCZarH9Kd/hD4Zoi402CmqXc+r129UE0XCzjNeDY7jJbB4e4dnRBCv4cuV6
	pZ39+CTTweQ+LIaJIwNdrD7BrS4DGiJdWLbaewT70pgAPv59oIdNAJz14mAqqeYI0JPjo4
	c8dgu1kM8x5QzoWNAhDcFT7RVJjdXUw=
Message-ID: <8fbeb3e8-7c30-46f6-a0a4-289efbf45ac0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763361727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F61/44VrimXOAEuXiMeNmI+aj0JYokmyCnACi/yOoLA=;
	b=LXkvl6fWXks2EBeWBZhRCeAyF3ikTcHZiBnXiOf/E69BeQQS14g5s1Z7/bB8YxlQXeJX97
	ZSrM63UX77TU+weQcxR68BHoTI37uR0exm53LyIVRGyINLRhjXjK25ABUedOBpfn59DJNX
	OX6fbBjMivdCT5ijsyT8t8ax4mXTWFY=
Date: Mon, 17 Nov 2025 14:41:10 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/7] loongarch: mm: enable MMU_GATHER_RCU_TABLE_FREE
To: Huacai Chen <chenhuacai@kernel.org>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, dev.jain@arm.com, akpm@linux-foundation.org,
 david@redhat.com, ioworker0@gmail.com, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, WANG Xuerui <kernel@xen0n.name>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <146b5a0207052b38d04caac6b20756a61c2189b3.1763117269.git.zhengqi.arch@bytedance.com>
 <CAAhV-H6HL+mXeuLqgo5BOVBB0_GHTUmn7_7NTzdUpLX7NbuQ5w@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAAhV-H6HL+mXeuLqgo5BOVBB0_GHTUmn7_7NTzdUpLX7NbuQ5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: F0B90140009
X-Stat-Signature: q14hhh3bsneug5wbsiqtaottciiqzxuk
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763361729-281074
X-HE-Meta: U2FsdGVkX18E9sNYWGb7dWWC5h+hHosKmp+UKw0IYUMVOONh3H3HjzepDdxgVxANTtw2rsTZ6njFSV0d8PZ1qnd0+2XivP/dPodTQsE/2aqYsK1jCMdVW4BMS3s9KZVksRyuk6D406jOtFlQmDKxzSChRwsC9j72tmS88ZUlmK/TNptIEB1KI2iHCCXQbew9fgDaB18G2e429eoePxtL00wYEAYhHCZOLrB70WbZ0+zon7fte9Il1x5i3w8fKJmVMaoiPrV9KZQ9T3PFMeq+MKoF1OtvxSf+bBE0R5vmxBIrRLEF+B1YbrkoiqAWb7/q9OxwWVYuljPLakc2Vyqn+z5d5bN0sHd2EePMXo1f32b/D4xVn1UzQi0hOoXcQ9ckaX3QN1J2p43VBqoQQvK+20vczpDxTxPrnN/mlDI7KjowagUBlq6xX1pz1P9bEbfDoN8/jJTlybali71XeRTiewidEnkMeaUyWOsNP2quwiKC98O6HMLPEv5AXNXuyP4SHEdlO+igwfVBVBuaB52yCjpQsnwxyty+nsTEym4M6ChMrzyMU8Fir4ipQj7X8T8JVGADcMS+mVTzyuVY53C7lTTg/lopxXtAgwYggLJzj2i9Bv78XELJTFWJX1CUPTIa/eFmHQFsAWNak6ndSNmBRrJ45co72edkXJZa3CvmayrDGYU6GLVl0WoCE33EZ5GLBe3r6UEspiMq3KN8+w/ex4spgFULIsoD95yC0G3Kw8YdqqCbnkLL3kW/Gs14X3bVSg6kuLzlORdcHDZ2EXHG00+xQ1Qf5VWGgJvHyL0L2YHA1fZNTNXf3V/x5Uw4+HuE2VGDiOo1oJSyXwNRQf/lHSlzNsJu8zmGySIMrtWn8WbUMDaiwapSeo8N3dZA5FTyUANuGM2b2db/AvCN2SZVKv+dppWRcb2PdUzuXeTMDCgRaIZXpVigTQ4jC92Bc0xhXcPOyaB+3NblxsAtqH/
 N6TPRAOg
 EzM4Rv1Ny2brnHw+Y2qlGMu59a5EdINf7HrY6vaEPMBWoKmpLh0O8wwuzmkmiWjS1t8HFY/BTwQkmAEjs81VIuhnUe+2BYZrMCWQeiH+igaVFDYrq39hQQ53S492lmaULCjO1uE8ntd437TYhp0OEV40CbN8jIgXsxW/b1OGkdnE6dMDYLSpVzVWYDEEgP1Um9V2IHtGmnHUxtdmFXE+DVGfq7E8sLk7Clk5G77GAUqvTXATexC5rRV3ZLlXYTOo0zBoq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Huacai,

On 11/14/25 10:17 PM, Huacai Chen wrote:
> Hi, Qi Zheng,

[...]

>>
>> -#define __pmd_free_tlb(tlb, x, addr)   pmd_free((tlb)->mm, x)
>> +#define __pmd_free_tlb(tlb, x, addr)   \
>> +       tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
> I think we can define it in one line.

Do we need to change __pte_free_tlb() to a single-line format
as well?

Thanks,
Qi


>>


