Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A226AC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE8906B00CC; Tue, 14 Jul 2026 13:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A990C6B00CD; Tue, 14 Jul 2026 13:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A256B00CE; Tue, 14 Jul 2026 13:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A8D76B00CC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:29:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF2071C047C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:29:57 +0000 (UTC)
X-FDA: 84988070034.10.7907D1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1F2B180009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:29:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oCpbhHVh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784050196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6oib2F+Iwq8XkLAzZaDDtV/NgT4fqcpJDZGEXaDTLY=;
	b=jU8w0Zn7+xzeAF3HcjWTbRGbu3CWKv2myBN8EbP7PKvT317N3WWeIs3M+LO9EunFlotvAF
	SiPwMIPFDf0U4ApYRGlRSXthNkm4bQ/GBEDj+QyfW9cmi9D7y4A3bCSBs5T4JqYKRJ9kxy
	UJuKy8SwBIlND6nvgWYI+mVpGpVyvtI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oCpbhHVh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784050196;
	b=pi7L6deJ+ulVJB452g9xMfCdD3fQgAoSNJBwxa+HHwmP3KyQZ3WydvSorm81Sey8z5c2iD
	ylzX7qoIyr+7Z9wB2yvwVfzHTfjpGG4RBFAKBI+W829Nlz9+Dsf//UgmLxVS2BrOmKmEmI
	kXp3ypc6W3FUpR9fWg+y9c+fCDOf7zU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B31FB43A71;
	Tue, 14 Jul 2026 17:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79E81F00A3A;
	Tue, 14 Jul 2026 17:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784050194;
	bh=h6oib2F+Iwq8XkLAzZaDDtV/NgT4fqcpJDZGEXaDTLY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oCpbhHVhU4YG1EeK5Mz8gwjp70/H/XZioXNfwY6KQGIV744BEsChOpGqBZ8hoQ5gf
	 KfZRyQmXX8NMQ+6wq2bWCuxEbfMkdAWl5S64hnBs3vj8SqdX8gCSRQSlj9+WzEfggN
	 XQsswnB1jtSaKMzPL/20kSHSl/doBxDOleyFt2lh54MYhxGEgV1Vywy2JN6ZizZ7nt
	 G70zTfHbhplWuTD/b3sl/K0/E9dUT8DwrX+7QZ0fGydgHy2WeVb0ADFW2SvAk4L9Ok
	 aLxx3ML9nCJtJpwMslU9iCwIvJBuqDr6bwEKGe5N1fdBmpsG/zbIgCK1/XhoOQNWC6
	 YzP+yqCn4XBBg==
Message-ID: <7cff02d6-d3ce-4315-b667-34911fc6f321@kernel.org>
Date: Tue, 14 Jul 2026 19:29:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 10/34] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Dave Hansen <dave.hansen@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com, linux-csky@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux@armlinux.org.uk, akpm@linux-foundation.org, ankur.a.arora@oracle.com,
 rppt@kernel.org, linmag7@gmail.com, chleroy@kernel.org,
 klarasmodin@gmail.com, chenhuacai@kernel.org, kernel@xen0n.name,
 kas@kernel.org, zhangtianyang@loongson.cn, wangyuli@aosc.io,
 tsbogend@alpha.franken.de, ljs@kernel.org, jgg@ziepe.ca,
 catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de,
 ryan.roberts@arm.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 baolin.wang@linux.alibaba.com, tj@kernel.org, kevin.brodsky@arm.com,
 anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com,
 yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org,
 guoren@kernel.org, yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
 dinguyen@kernel.org, schuster.simon@siemens-energy.com,
 wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, muchun.song@linux.dev,
 vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org,
 djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com,
 Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi
References: <6007625e-c3f9-4ad6-99a8-61396bccbcec@kernel.org>
 <32d459d1-ad19-4baf-bbb1-0565458001d2@intel.com>
 <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
 <7e84b200-25eb-43a6-b5e2-5f27f2d82a77@intel.com>
 <31988089-095a-4eed-b5e2-c677c70f79f6@kernel.org>
 <14e250db-1641-4085-8d13-02f819657d5f@intel.com>
 <d83c76b3-ea4d-4c41-b4c5-f5ae558ace55@kernel.org>
 <alYgMxKqRnF6_X0A@e129823.arm.com>
 <6df814c9-405c-48d8-96ea-929c4b28949b@intel.com>
 <alZe-Cu7yQw9qRXU@e129823.arm.com> <alZo9feSrSB_StfO@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <alZo9feSrSB_StfO@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rr3djoxqogyzru73gb4s7mytxfnzdco7
X-Rspamd-Queue-Id: 1F2B180009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784050195-611750
X-HE-Meta: U2FsdGVkX1+yDECUiDd9cgKWYUWVpif/9rCc3rAzZ4+MMQQN2k45J135uY/LtLrY6OFNv9mfQs7Q1McEQvBtld9l2TUg2uD4kAAl8pTJmy62W2e+LPrGiCfvgI3ii0BHa70KQc5cOhc2lckv6q/U3pMQtzBl0/W4TTHg+M3Sa0vRGZDkAl4cH0K7LEKID392iE87Vft9kgg4R7YSQaIPCIsIcsnWeTwcHu5ttUjBHrKLaQowEbewEnk9odjCPUNksCPmanV0bAIz0q8KLl1YJGOZqWz6q+C7srAlnMaM694uXJ3apwKi27agwsPI3LovlMW52O+Jb0GsHquSNxSDUkUuJJq9ZAE7zqE6UveWxsyMX3FyCEVSo5Pihojg23ggQfacoFcVvK08pxExvSFVw3Sf8PN/p4QsLGhB8Opj1d6jvKGrWfCTTWUdBLhV0zYlkmYRLI5qkOozX+WXLxUhyvAvXIIQFFuak73JaLZlEoM0bYWsMHvIX12dLTtk7veht/Fsj+pRkvFYPQ2WajK0uNFn0p32kpviKTMlg/Y6b5ehlP02EGDoYbq15C1QfdnwmNI9IAyG4cG2IOnC047mq29TGwNPDfHUiSXeFmi54cLQoV5bQe2FBlRlnAmoLzHLkFH17y5hEeRc8fks2Y8/nrWTxe+Jgw8cJN2a3w8pb8D7pSOQsUaZh5rj0zNNSdRBYpdfp7PygoOxRM2bYkB1kgzU4bksw3p4hsZamfz6HLgVs/DQJC5MqKSNPc7QN5mAGQPFZHikTx0e/baOlIfNLQmHiDwOaq5RT7n3JPT59p3REqSNVkH3fdFhiWj6Fdc5EkfEyIRpFZ8bnxk2OB/LxenPxv3yGQrLmztw5SfQKv+xt97Gz2PDpU3kXw9KJVoyoxnYPX4k7GwQ7hMYmtAGzBdhdyp2c3ACkvcYyzAdG7yyLxEpG9/C9z+AFvST7B/A3n1UtHr0Z9bvTzCfTI+
 dbHMbdt4
 sH3m/Gfmq1xz80fBA/xtPvvu/iAKNwo1erissjsyZKuzctPI7lhUTmO/J+b7T+om4WB7r00kj3DiERvylJi3arVgEhet7mlWw2/K9fnGtHP3ABNbGJKhd+EvubUJIuNDRTweA0ADeSVBH7QIv3HGgDZvOjuHiqSV0r14h/CldnUDv2pNcfAA9ecYZNKId3ArJOHjz/I+vP6ePWnGDu74IGDNupGwBg4IUpaU2G8ClmfK178t5rqGWTPVMg9J+XPo1UQMXHLTsIyooEZtEkKgS4j5jTmEgD6we8VwGctmUxjn4UCut17Pn75jkOOyN74723pyQUnrptTBVU0uH8j/BhrEMarSIBpgTy4rs3xoWGlX8d7XMLTvXB43ykmdXkzIucBRb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 18:51, Yeoreum Yun wrote:
> On Tue, Jul 14, 2026 at 05:08:24PM +0100, Yeoreum Yun wrote:
>> On Tue, Jul 14, 2026 at 07:35:19AM -0700, Dave Hansen wrote:
>>>
>>> This is indeed an improvement and a step in the right direction! Thanks
>>> for looking at this.
>>>
>>> But one of my test for whether it's good x86 code is whether there's any
>>> actually x86-specific logic in it. Isn't this basically a translation
>>> between the integer level number and whether it is folded?
>>>
>>> That seems like a common helper that more than one arch could use. Could
>>> this be stuck in a helper so that all arch/x86 has to do is:
>>>
>>> 	if (mm_pt_level_folded(mm, level))
>>> 		return;
>>
>> Yes. at least the level semantic in ptdump (pgd is level 0,
>> p4d is level 1, ...) is same to all archs where use ptdump.
>> So It seems reasonable to add this common helper in ptdump.c
>>
> 
> Furthermore, the effective_prot() need to require to identify whether
> it's the first pgtable to prevent the inheriting from dummy value.
> So I think it seems to make a ptdump_pt_level_first() like:
> 
> diff --git a/mm/ptdump.c b/mm/ptdump.c
> index 973020000096c..2ec5700e4be5e 100644
> --- a/mm/ptdump.c
> +++ b/mm/ptdump.c
> @@ -190,6 +190,23 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
>         st->note_page_flush(st);
>  }
> 
> +bool pdtump_pt_level_first(struct mm_struct *mm, int level)
> +{
> +       if (!mm || level > CONFIG_PGTABLE_LEVELS)
> +               return false;

Do we actually ever get !mm ?

-- 
Cheers,

David

