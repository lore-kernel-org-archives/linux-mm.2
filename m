Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B577EC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 10:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AFB26B0005; Sun, 18 Jan 2026 05:51:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D286B0089; Sun, 18 Jan 2026 05:51:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714D16B008A; Sun, 18 Jan 2026 05:51:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 602AF6B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 05:51:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C22E71A050F
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 10:51:24 +0000 (UTC)
X-FDA: 84344768088.28.803EABD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E75B740006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 10:51:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Lh/W0wSu";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768733483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/C00al6g6oPolPDWSn93FdlakxVTOB2fb9Nh4JRQcOA=;
	b=uUKRC78BFK591HzfZ0YjQ3yEMhSBkBgZQvKcRrMQQZkUzF/JnVxI0yop43Al630fJTqXvS
	e8aA8RclFpP7cEmLvPk0vSvaCpFst/72WCSwKfmVWcvazklddSSP2UqSdJUqwjGag2AnP2
	fQVQjAWRTBOuejPbnyVOhNoGSyhpeWE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Lh/W0wSu";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768733483; a=rsa-sha256;
	cv=none;
	b=0kzlny2OdYAPe1exjLn5pzRIJqfScMb6cKnA8a9YviwX8U6zUEyBtziJs0AcS8E88xslXH
	KmyDRSMOq86BkJIPG6XCHNscp10qEb+mDG/L+ykFg5YTN/COnm2wB+KY26dZHeWWPzvKkY
	XaK/kBt6JTVPkbsK4wN9DbK2Hm37YB4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D15343FA8;
	Sun, 18 Jan 2026 10:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB210C116D0;
	Sun, 18 Jan 2026 10:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768733481;
	bh=cRUnDqszYzqdtiCqFz8ReeBCDwhfi0apCW2AsbShb5k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Lh/W0wSuyD/3XxpnQZN74YCKsYSsPpd3jS1Q3r7AHgEO5xu2v3rSWtugLiHErSsAq
	 4JpQxtNVF9al8cfXSw1DYrONPT7G8UsoJ77XHe6svoCRp/tW9Qfeji6jiFE7aHzsQH
	 z/ZTnDUiA0wsPpzzE1vwt/IAY1BJ9VFLFNZv4BDnIfxxiIS8VdnNIqdVBYH/LrQFV3
	 BWHp2W2iaokAL9JuD6rqhdXARUNaLG8q6Jb2XgJ0LlQ2ZObaymRkAkyImoQKx7BD6U
	 AHBp/YjdIu4qjc7tm+BL9TbDFIM5qTw8uAjNTwjdQ0kHzePglSKWDfWKJkUR6zjvse
	 qd7x6SKnbJnSw==
Message-ID: <4fd1610b-acc5-4c17-a227-4d63272d3718@kernel.org>
Date: Sun, 18 Jan 2026 11:51:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/pgtable: convert pgtable_t to ptdesc pointer
To: Alex Shi <seakeel@gmail.com>, Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>, alexs@kernel.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Guo Ren <guoren@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Michal Simek <monstr@monstr.eu>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Yoshinori Sato
 <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 "open list:ALPHA PORT" <linux-alpha@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:SYNOPSYS ARC ARCHITECTURE" <linux-snps-arc@lists.infradead.org>,
 "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
 "open list:MMU GATHER AND TLB INVALIDATION" <linux-arch@vger.kernel.org>,
 "open list:MMU GATHER AND TLB INVALIDATION" <linux-mm@kvack.org>,
 "open list:C-SKY ARCHITECTURE" <linux-csky@vger.kernel.org>,
 "open list:QUALCOMM HEXAGON ARCHITECTURE" <linux-hexagon@vger.kernel.org>,
 "open list:LOONGARCH" <loongarch@lists.linux.dev>,
 "open list:M68K ARCHITECTURE" <linux-m68k@lists.linux-m68k.org>,
 "open list:MIPS" <linux-mips@vger.kernel.org>,
 "open list:OPENRISC ARCHITECTURE" <linux-openrisc@vger.kernel.org>,
 "open list:PARISC ARCHITECTURE" <linux-parisc@vger.kernel.org>,
 "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
 "open list:SUPERH" <linux-sh@vger.kernel.org>,
 "open list:USER-MODE LINUX (UML)" <linux-um@lists.infradead.org>
References: <20260107064642.15771-1-alexs@kernel.org>
 <aV4h5vQUNXn5cpMY@kernel.org>
 <080e493a-e4f1-4c97-a3e1-f76f126b5213@gmail.com>
 <aV5yIuGi9Ni5YP5E@casper.infradead.org>
 <1d110134-89ab-474b-bca6-cfbfd4b5057f@gmail.com>
 <85a0be43-3598-435d-a50e-9403b7e963f7@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <85a0be43-3598-435d-a50e-9403b7e963f7@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ix8oxfsnyyy3chpbmin7wzbr51c8h4ip
X-Rspam-User: 
X-Rspamd-Queue-Id: E75B740006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768733482-50952
X-HE-Meta: U2FsdGVkX18k0TiIEkocAKspWNRc7dXkNfa2anKdfmQyhAZAHDDlbb3g+PwZai4vl/ujWtJ3I7fWhqIe8V/wJmqEqMCwnChb905B0uayfc7F6FzBQXjwzYtu4XAuiBv+2CVuCsrOyDx9Uo6+or6SVppwwEwL5LGgEqb/tk6980x7shNuPse3RlQtA/4mVPneGjwrwsaj3LwjVLq+zN07aWUIPmyxcK+iT0Ns9TLHk6LyZoiI048mguIuk/2smz6Je18MZljOkTbT9mekAgN5qdkQsotxZp1VlpoglCPeTjVetmQO2LgOALTVRdJeyguchsglvPDV5g0gWb3KKgG2W+gvwfMTUtkI1WwWwzZ/cuY+H3zrQ+IpbvvXmj7H8AHRagh3KOv3eAh7AdYllLTiuz9EI+XMXYNESuKYO6MU6KDFmVDNfHy1FlWITNSOszf99T9uzT6gkbPFX/ooJ/xLQOL5Gy6zAdehAwt8qADhEDDBSrvQ2eK1dLsgwIkyyvoNQPuvF8gOGTW/hLP6u8wKjZWFs0WFVilyrO3Jdn+JLsHoRzkPAF9KG41reb2048c4W9dlZIRLgdpAj3BbA/eCYpCL5yh+HxqDkmmBLGzri8Jy90M9m2PLHvkuen4riEhpJAxPBONs7Yny5PIQRT92i3jq+ipbfufueQ+pLwdKGxkRoMF1aykhKpCZruKFpe5NVboew5mKgV5Q2y863AhA9Tk7oeHSUsyLVXiEOsVxVpCLPE5XnnECOn54RR5OdjhUgWDgs1cMPNGdxcLM0FRaVYlELopSTUqzvhJaIraIo875yKM8YRAQcKg0FRxxCIqL8HACnBNg1vdkRh+WDwoz3jeSD9ORrI6uk/lbWpvvmcgoVllrfe3d5Alwqg8FWoMgK8ywP2s8T+6SlNt67tLX3F5QAR2GIaaSiKciS88LTBUkTFpeGXANvRkWfmOvdZXHtqRyFS+sRoqgS69PJfi
 p+T5oyPc
 Gb2VjkOpuArnv1xOQVx+uBs4xZ1jfJDF+0jlu9pvWTfMAntf49UYz0GzQeTB8yXCOOmINfHcbnXxLNeuIe8g8qIJeH1klze8frtQwoZmxvWmgTc545+KFYgCGvFHyEumtDBAozrN8Jm6ndQcMjNBosPYfjri7a8PBxnjfU4TzGWR9NSoDwXraK9ZoNKzmMFl+YsPX+7uxhLWB/VtUIzLnMmW3FD4OhEdtoWmT/4C804KFUg+QLrH6H8uwVyut4uGdWuIDNC8mzy0aHtZpndybX5TS2SxN65M6Br+QOY/zQF4/CPi3/o2kI194XvPrCJe0fZAiMu/AmTbJjTY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/18/26 09:13, Alex Shi wrote:
> 
> 
> On 2026/1/8 10:23, Alex Shi wrote:
>>
>>
>> On 2026/1/7 22:48, Matthew Wilcox wrote:
>>> On Wed, Jan 07, 2026 at 05:28:36PM +0800, Alex Shi wrote:
>>>> Right, I will fix this. and sent the 2nd version.
>>> No, the patch is stupid and wrong.  Don't send a v2.  You seem to have a
>>> hairtrigger resend, so I'm trying to prevent a v2 being sent instead of
>>> sending a patient reply.
>>
>> Hi Matthew,
>>
>> I hear you—no v2 will be sent.
>> but sorry for a bit confusing, what's your expected fix? is the too
>> quick resenting? or the direction to alignment pgtable_t with ptdesc is
>> wrong?
> 
> Hi Willy, Do you mind to share the detailed concern for this patch?

I think we recently had a discussion that we should much rather rework 
core code to consistently make pgtable_t a pointer to the start of the 
page table or something like that.

Because the way you change the code just means that we will not be able 
to handle code that fits multiple pages tables into a single page 
(s390x, ppc) consistently.

	arch/s390/include/asm/page.h:typedef pte_t *pgtable_t;

-- 
Cheers

David

