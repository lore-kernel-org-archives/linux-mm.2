Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C13BEC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 14:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9436B0005; Sun, 18 Jan 2026 09:11:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 970126B0089; Sun, 18 Jan 2026 09:11:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872B26B008A; Sun, 18 Jan 2026 09:11:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 772556B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:11:29 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15802D1F01
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:11:29 +0000 (UTC)
X-FDA: 84345272298.05.B710B03
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2530DC0008
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:11:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="f/iqI0wp";
	spf=pass (imf10.hostedemail.com: domain of seakeel@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=seakeel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768745487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqDJGvudyOS3k99PpLPEmecPUls9OZTpXwxY9UHrGPM=;
	b=GOM3QG1btFYm9byR+FXKjR4Y8r38kDx4fGJ/vO8AVGW+yFRtScTH79/gPARtzbA/Wt+E8u
	9kbXbDZG4Eo+OVhL8XAds1sshwqoJl5dsD2TKP/jhLVdcrles2sbPHoFGV3ZzJpLinGqHN
	twk32wCtG8ws05DQLjKzmwQepRcBYiQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="f/iqI0wp";
	spf=pass (imf10.hostedemail.com: domain of seakeel@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=seakeel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768745487; a=rsa-sha256;
	cv=none;
	b=NenSjWZb24/3C4YbJ6z8QCl1P1gQ9/9frnugMK+1r1hvUjfdvS9W+k4n6tzbZXPfbrQ8Ep
	ftMd5Uvs68OCX3ZKbNwzmeb5whyKyxUHWwZ+nM79n5HbjkuPY2nU2FgXXNJH/7fbxwNweB
	68S97r96MVavUjscuWbbdVUjI9LVWFE=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-bc274b8b15bso2214514a12.1
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 06:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768745486; x=1769350286; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AqDJGvudyOS3k99PpLPEmecPUls9OZTpXwxY9UHrGPM=;
        b=f/iqI0wp22w6YQzZefHhQju3/VIyYXo36FwsWFgbig5aEziy8QmliNh74xjV8c0N57
         iEVx1wS4V3OA7dDSDbOdr2vZSSD1PE2ggYDQOauc2wA2DEw6O3vRVzUAknn/OQxnn/gk
         o0l+CaQUtmSJ0+SolNEh6933hFPqL2J2g6DYvy/In7/lUOY3PtCHoYaRynbd/bFybd5+
         yo6qLMHC6M6CPw6NKCe2cfvg7Civqb8ScSykukuQ1CxV4kiXqjTKs65TjvI80YVPdULv
         1EZR5bzikFXV4WclA+R2XPnAoJcXRWGP2x2T5GwfXMfv344qQIdE7CvdhW5pRuBnzOx6
         HwSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768745486; x=1769350286;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AqDJGvudyOS3k99PpLPEmecPUls9OZTpXwxY9UHrGPM=;
        b=Nfi+zmbdtlfWR3YQY92wuOt9b0qdowl57VJslUYb2HDB89K8u+BymKgoMGgWfVxmq8
         thxQVWXt79HoSbyUl5iIYJt1AcSK5HHNGevFOlIlWIfcrbaYiOLlW1gk8k0Hft0Vrf0R
         dskLPsU9d1RH2EMRzaWqZk/VaBH5bc6lss14PS13y+jumc2uqvxwLpFbsESk5qI7ZBn4
         iM9fIPcv5IE2bkRw9xPXqiH9ffdDEVGVRvWQ8ruB3ODSA+23ZYWsabOIV+GnbFIGOoVn
         UOacLOsZ5CS6lUDaCedSk2n3eQWTtQ/GWFQMGcc2wo7otWckH9I9X8AATZkSlkqZfJMb
         +gNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSXCP/ldXhyOFg8EZbPJZ/CdEVBxqPUQRy1DA1L5iGlPMwoe4qt1Sr/wo4kC+/35Kvo2SBAA6fpw==@kvack.org
X-Gm-Message-State: AOJu0YyN8/TGW6QFdgDoTutU11y80eD2OlyjiW8TiqXDt6ydSR47NOje
	8ntV+lRZxFCFTl2hPOSWGsLWlAxW4AoT2qFpzMch38U78W3JkR65gDHK
X-Gm-Gg: AY/fxX5uPFGOe49pIn4M4q6APK/rrj9co2ulfBLjtAPuADSxKPJjAoVuFH7Tx+aeRYy
	YjzPMd/3tH6DUWQRfNresq07kn0LiCePlIXrbg7qEQxkfoQ7A/pT+Mw6DUAycJm7wHc5o+a7N8M
	zRWzQcHwd2M7A2z4Zndc+h6/t+Gao7NQt4yI2zOpmruWXIJZ4TfTwbR+kn0Oiq1PnTBhtD4iX48
	RKwgZp/pjfyjxZ+36g8RrOTNBaiFRtfN/Fmjtgx5dePBvSNVSMMmJjfyE/3catgipSgbbCvYYpo
	RYGI+qsFJjEjjwY99wdWbKOrn2cMrf/AY5vMIMTCNwV8Qxb330uMboPELAV9o9jBUetbIdgYrMy
	Hqz9KLXVj+5ZH29uMI+hw1Xb+2PHlHh2h493Qf9XXMNIJXOc54wIIlZjf2GT0AKgMxrOfcrtv0b
	nawLpiUFYS
X-Received: by 2002:a05:6a20:a122:b0:37e:61fc:a896 with SMTP id adf61e73a8af0-38dfe7c3042mr7636975637.66.1768745485767;
        Sun, 18 Jan 2026 06:11:25 -0800 (PST)
Received: from [192.168.2.226] ([114.92.45.6])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c5edf32d1f1sm6549138a12.22.2026.01.18.06.10.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 06:11:25 -0800 (PST)
Message-ID: <b27b8bc4-8730-4ce8-bf39-0ca8459feecc@gmail.com>
Date: Sun, 18 Jan 2026 22:10:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/pgtable: convert pgtable_t to ptdesc pointer
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
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
 <4fd1610b-acc5-4c17-a227-4d63272d3718@kernel.org>
Content-Language: en-US
From: Alex Shi <seakeel@gmail.com>
In-Reply-To: <4fd1610b-acc5-4c17-a227-4d63272d3718@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hyniytbdch5si44wtgtybt47b3dqnxod
X-Rspamd-Queue-Id: 2530DC0008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768745486-616616
X-HE-Meta: U2FsdGVkX1/S/Pfx2Y8Pah9bL37uGmiC40v5fP1FFaJG85qB2ovszaZrAeaffbXLuau8wj80cZ6HiAh/5pcLxkZROtZzNi2NGqT2w/6yzZGYk3Q6nADo5fE7HJg0SFk3MNhjyigHLqDJ1J9Fz8Hd28Fo82UExgL9s4+qQ3Za1gU0hb06Wv9wzpLijFHpuCk+4Eh6baCJT1uyfNNRTXwnsmVkn8Oa7kRMQMqkQcTjMhh1WMQmGn3KQydh5B+cFyPfIAq79zsINvkqDOPxJpWJQRXQ2vNBh46t4SGpgyXeq58+giXSvO8ERMQs8s6aoeeQjhuOd2Oy3XOnEr9d5W8GufKz29hf3herPzVKe8E9zNZcXqlin/fPw5QiO7EbCz0IvZ2KzZ7v0+H1TIf1LuDJmuaINZug/MRT+K6i9RpegKAtRFMWIAb1gnmJFiyMoONQfSSgssqTo2TIAepedKQrfq7YrLieYSxuNRC/KeEQnajGohhA6omX3KZGFAjjm3OsxXEC/TBKvkmsOYlvePSqa5B4AHvXR2KGQiWc26R0uSHVkGFc1iaocMKn+InxJJYR4M48NRKWFOm1gFNtowj0Y0cYtZhTuTMUlCcXTcS+4jNXzildjyLbofJ/7O6XBNcg8TBPXBJde4/BDJ3dFLqLVAEqIVcNAuKeNWa6x6IjAFRZtSEDI2EgysscLb/h003v2U1zljYnuhWAd/HDEohdm1k4f/MINxJyP1qc5JCB/ir56h6JxrdzxqinyhsGUBYYxw1PBHHjpps72LlumNH9+8j8d8qaZN+fSLikCGAeExocJKJEuzBlAr3FFPVeYnZ6JQeqVpSsQsZU4kOVzgCYWlQFeTwMANBZ+c5LnSYIKw9eZf3YsokmjAj0vaojLdruEwlsaaZsdCFZvTXoGo90z9cZY0al9SqTYGYjfdvTd9XNv5sOSX9kR/K0d5Uz9hrQvDpTa+GJbytqSxubkab
 OU/UWy8L
 HnNwIyrxaipm0DrjyiN7wZ3Yx8Bmr4K6IoLm81oyhC0lAGhm5LIJh2/iKzhwi/7lEcdIcccBQY25d7U2V6XQgG+37Pf3QkJ1SzCDs/c/wEnTm7Jyj4PtLioH4eTe8jeRlJfVjgN+zIJvKzyk2baya9BWVsMUIaZkMz7hjZlvUCC34vH7GCVStSFiqZcaF6gUBTVOjTaNCj7ADE6iT0N0P4QmQxFi5dymqPisnz6gj7Gi7ZwOB6rqkLB4RC1GT9jM7Q3qhQiSaGXhLH/KtT4P16nd9JdUebCe//Im3sOVjuk3TrdkwFJ5yKDPjhC6+zK2hjSm2wGM6wOBg1FNnlHC90lpouq0HiT+PujkEGVBlBpY3yQsYE7bVafbZCfN77iF46/TJMQOFPu+LHRLLdD1t/mQ2C5LN7mOty9jsVl6HYEp7ZoDqXg8PM//ULF3GHKYzrc+E6OE9jkmArmct3hg9TIPT83f76+I68XWWGS4KbsMGBfU7a1hs3Cw1ef4HeNWIq4+y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/18 18:51, David Hildenbrand (Red Hat) wrote:
> On 1/18/26 09:13, Alex Shi wrote:
>>
>>
>> On 2026/1/8 10:23, Alex Shi wrote:
>>>
>>>
>>> On 2026/1/7 22:48, Matthew Wilcox wrote:
>>>> On Wed, Jan 07, 2026 at 05:28:36PM +0800, Alex Shi wrote:
>>>>> Right, I will fix this. and sent the 2nd version.
>>>> No, the patch is stupid and wrong.  Don't send a v2.  You seem to 
>>>> have a
>>>> hairtrigger resend, so I'm trying to prevent a v2 being sent instead of
>>>> sending a patient reply.
>>>
>>> Hi Matthew,
>>>
>>> I hear you—no v2 will be sent.
>>> but sorry for a bit confusing, what's your expected fix? is the too
>>> quick resenting? or the direction to alignment pgtable_t with ptdesc is
>>> wrong?
>>
>> Hi Willy, Do you mind to share the detailed concern for this patch?
> 
> I think we recently had a discussion that we should much rather rework 
> core code to consistently make pgtable_t a pointer to the start of the 
> page table or something like that.
> 
> Because the way you change the code just means that we will not be able 
> to handle code that fits multiple pages tables into a single page 
> (s390x, ppc) consistently.
> 
>      arch/s390/include/asm/page.h:typedef pte_t *pgtable_t;
> 

Got it. Thanks a lot for the explanation!


