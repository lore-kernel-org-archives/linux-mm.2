Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B67C0D0C84E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 10:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59C06B0005; Tue, 13 Jan 2026 05:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDCAB6B0089; Tue, 13 Jan 2026 05:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBE5D6B008A; Tue, 13 Jan 2026 05:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B62636B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:43:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2420557775
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:43:46 +0000 (UTC)
X-FDA: 84326604852.18.78F70BA
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0DB59140005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:43:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KvKDrmkm;
	spf=pass (imf26.hostedemail.com: domain of kaleposti@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=kaleposti@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768301024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VgnN5gtqEe3Q1O0kTTet9lBrugKrM6JP8dsQeWrl1xo=;
	b=l+GmRvNmbb88XFhynDsQx4fKhwZTFG3aisZLBUP80ZDDL0KzhvaWz/ueh/KPX2RqTtKqOD
	PiSPUnYidWwSUQfO5+iqP3Ebl0y4MlmG7MNZGdrPExOZBQnuTRahtFWFVXUDmOs+mRRMnt
	cTxFodnb08JO2B2LqMqgSGJzkEyjaqw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KvKDrmkm;
	spf=pass (imf26.hostedemail.com: domain of kaleposti@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=kaleposti@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768301024; a=rsa-sha256;
	cv=none;
	b=rHRTKJN/i0BgzdM2R0ui3ZvKZLp18AlpbJaF5h8zlqnRwyxBMzli4Pb9txZBPVkkXawNGF
	6MhB+3uOgFPeAIdnM1C+sOysotH99M5v4ZaRagCVmpRDzTyBtWrhLtDp5pj6ScDO4qtQez
	c5CZAxNvP48GhF7e6RiP3csORvAVABc=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-382f4aa8dd1so57265211fa.3
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768301022; x=1768905822; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VgnN5gtqEe3Q1O0kTTet9lBrugKrM6JP8dsQeWrl1xo=;
        b=KvKDrmkm6kBtlfsykKNb2MCGpOHhazvOLkuNoy73gkq6yU1USG+38BapZGMFXhblua
         JViOSxRbQEDuv9aKZ2SBOQ3+wQrhof4Q9HMFylFCmaJLXC85J4bxMUP5mAqpUnonCNsx
         CGLsc6s37hC8NhXAPCorRtXBlz0hsITPDS6x+k3Fj3zAesWuP7y10aD0sO5Tros9PgfF
         haGDAt7fAFALkPaxMYygOQ5LK6wizcCYkNhvgyaXxpaxkwbb2n3QT9lwlk5qW+jHYxuk
         6Q7dBmRXn3Ac6gJFEQNkoDrkEM0rpvAYqPA4Aob9wZUuaH7MhlrikN1HHq0dCGqitPFi
         TGng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768301022; x=1768905822;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VgnN5gtqEe3Q1O0kTTet9lBrugKrM6JP8dsQeWrl1xo=;
        b=AInpXviVXo6IlPFZjab8pMjhfPOARJVeRepH40Jj7uHeMqLqAFQ/IyQ3tkrdofSP1B
         ycTzMEaqkkbneGctgg0QDWDIbbBCRyXiWDDm08PwH0V/G1j9f4F+eh4kRdhq4C1+SqL4
         G4AiD7n5COSWVOBRIoTrHv0jMUFv4qFFNOG36ECa3IigKLfL9UTf++LLenMGsU9pRDJG
         HOUP4gpDrvI22VnzH48lA9p7uBAFgqGxDQJW5looOOnzhxJC4N1GuPEVH5aCqVDjcZlw
         NlgDm7aVqoP/9tl+4DEP/YTjHChk5TTKrIVusLBXDqrd51J9TWCg0bwIqZojFkteL7B8
         2HSA==
X-Forwarded-Encrypted: i=1; AJvYcCV8cOm2gbuJqVRaLlOnW8DkAgBCdFgMwYelpjZ3j8TRbsPTOoZUzWRI+u5EJl4hx8y25Xh9AxtZMA==@kvack.org
X-Gm-Message-State: AOJu0Yz6rDnOh5Bo+mRcT4F3thJLnW26Ao8V7ZJEVOUnBRsKOaxMJH98
	4QlH8e2LKbw1oU3pN8hN9hAkmK48/L5WeIVc+3w/8kzFOy3GG5/u4c/WeH6GiA==
X-Gm-Gg: AY/fxX6gCy9aVqeXUZ6x0iOeAo1Wy3UpqxHJXygbtjCJ4UOkAZU7ScRB3G/SJEBsSJF
	Cla2fb34deJ55edK863QvvNJBJJJ+YkNJTev79Nlceg6/xpqZHYXfJA/7qOjSBs0xYFdiUTlpyt
	yreTDjtmiYkRIb4l7w0rmJyvTq5k12hRx7YoVNzodC/nb8Dr+tif6QZo/QIJ11D8kwzonmCnyiU
	jgiel9PBUU8auXuElFc+uPOsXeo6Wlfpavdq1WcwL6zF4ndO6ze3hj02ntUT1ypjDlu8EF9h0O0
	UcWeAEN22+KsEtbtWAyG5FCJfvveqP6/KRfwXRywrkABrAlV2SzHp4DGLi4t/BP1WhfEB6X4dbl
	agNADOeWuJ359/sF17DG7yxKTc1olLorQG+a6KRR7tYBOcFP1Wxm5KJ65XiL9DAFsTA9VA9J/WC
	0G5MRvfw0ChDQkOZRhq7sA1Jf1QAaZBcMqz5T3zuM7Cd3rYJkkIWFk7gzQRw==
X-Google-Smtp-Source: AGHT+IEOoK2sWcGzQ5k4NJjsFR/RmdeWAB9vvZrFfNJ0u+S6dsEFK74/fdYnqiqEV2XmHMt6sJ390w==
X-Received: by 2002:a05:6512:138b:b0:598:e851:1db3 with SMTP id 2adb3069b0e04-59b6ef05760mr8236951e87.11.1768293628066;
        Tue, 13 Jan 2026 00:40:28 -0800 (PST)
Received: from [172.20.10.9] (mobile-access-c1d2ca-216.dhcp.inet.fi. [193.210.202.216])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b72f3ae82sm4416299e87.71.2026.01.13.00.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jan 2026 00:40:27 -0800 (PST)
Message-ID: <f861a1c6-7ec7-477c-bc42-f9aaf6724bed@gmail.com>
Date: Tue, 13 Jan 2026 10:40:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/29] arch, mm: consolidate hugetlb early reservation
From: Kalle Niemi <kaleposti@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: Alex Shi <alexs@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Jonathan Corbet <corbet@lwn.net>, Klara Modin <klarasmodin@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Palmer Dabbelt <palmer@dabbelt.com>, Pratyush Yadav <pratyush@kernel.org>,
 Richard Weinberger <richard@nod.at>, Ritesh Harjani <ritesh.list@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, x86@kernel.org, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org
References: <20260111082105.290734-1-rppt@kernel.org>
 <20260112142323.495fc43e662e7d276b0fa371@linux-foundation.org>
 <86b974d7-cabd-4913-b5f2-5b62b520e023@gmail.com>
Content-Language: en-US
In-Reply-To: <86b974d7-cabd-4913-b5f2-5b62b520e023@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: npcseswyuq5uttyjuabyuun6fqtypwz4
X-Rspamd-Queue-Id: 0DB59140005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768301023-266044
X-HE-Meta: U2FsdGVkX1/z4srJRY2kYoxFzNg3dGKlkpqC9LvGgDIR4soIHJwQJfeb83J1qQf3yzBKX/s1BC2AoZSXBAPv5pOv4QONYTeIo7HbeMVqGncRZ09u3haf386UbZAUaOnqlFC6jDpzNKWGsZiGSwdxhcjpKdJCY98zDeYYDL8huf++o2I+SRVq6MQA3gGQBRC0Nj2xgmk6mnefbWjkhYHCtGDVeBMN7anvDIwl4/+NNckaWH9zWNolQED2jiBXxSWSG8kGg8JpcoOrudGO33g17iY9TKUh41eiU80Y6ED5AexDwok2ByAoZt96VxR3tiMxcvgmFssWRkCzhKX6qbwAxVJHiG4NOydPj6OlKKhaAWCTnTYFJDhVH6aPDF+4NuRa7ZeJbBLmTRLUieqRW2sf/JuvgllH0E1vD2xaaQFh0YJkb9CY/4BWoGFtf5TzpDfeZ4RgaUWGCYQcmULEdA24UTBC2Wdm0VmU6BAD2Sj6Euylri7/ZKOsQMBdFlHUGh2cejAUHE0J1+OtRnlNesOkPOXb9nuCZGWuSA/1UgU2yKSZg5lAdZQ04o+DalyvtgXaLLWCuZqJs8W/091MMmMBknZBUmfodVjPVafSoYlo6w9TS+rhKzh6c1/QQ7Qg9al9T/oavH5B6ZkE1Jb6OxxHr8K7zU9OrMfc6DnysRJSfOCWe5/LosqEZPHGqegkNifDWiXIgx69RyejMUW6En6uh02B2C1ttY0eiwhU/BrxGgOpbyU/gc260eJYBPjTQJW/wQRaiRaJr+o/wU3FjFnFladl1kGNhG/bGJe9paz5bMtPRfR+j4xXf+ZYYLCzmaXR8teZP7dVgcFuJuMbpJt6N7g86IYNtHKth9wVtGXvyD8V+M/JCmVXU2NvTf0W+lQxWEONTZB1UTJVqfyxmZTUF9ZOddxiLWljER/brDjJI3pO0cB+/3YmllYzeFHsqiHOXWkaK81HPnmKp62s6z+
 EEJSQAO4
 heXTuGsxOYa84U7Pvh1r8WJkytfVpzMNbWImN8Ql3bCAYQ2VA09e5uETbiG2DEJZygbbM7IRNTL8/wd6ZjfbppYkKabrEGtNknVKuIR/mFys4HcJ8qsri52o0jmR5OBZ2AKbkCKjqUQGcCVfq/ZQMGH4tRxHwIn0UV+44rHZHudL+NKQ0BrBYQkvW9k7RcxOMjZIMLCxG1ny8RiCUuCy/x+WpIruRfCWu3H1IlOAtShhhogGHMb2v9fjczGJnKSNbhYnFuGAMpF/XwSaMEbFcJRVyVv0PoTBL8tTE/sejrZM44QNFKxz6jvk4oixZAS7z13Gu3PSn6XSEEheSS8bXObGUHJCDiCV4NWQX0vJ9N0uC/DQcqBuFwKkde5WRQb3/k2wR9JjiU6Vmc0ZC0WbqVbbGFQinZIQMh3s40bcdonHDa9hUNZ7mw4liQG+qsWS7sM3eqVN8ztJu+ywsNnfCA8icP5XcTpShC5r+8UlMA7dgBuVPq4RERb28QKrp7W8ZR8KR3UaaoVR374ODlOSNIoqHssE5+umcxdKO3eIWFhEbIwjJDhMBkX2lXHxODrzAqcPVNdpeYaCbpzX9Q5JBUKA160I76g3u01owM5kuMTIFNuY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 08:50, Kalle Niemi wrote:
> On 1/13/26 00:23, Andrew Morton wrote:
>> On Sun, 11 Jan 2026 10:20:34 +0200 Mike Rapoport <rppt@kernel.org> wrote:
>>
>>> v3 changes:
>>> * fix empty_zero_page initialization on arm
>>> * fix ZONE_DMA limit calculation on powerpc
>>> * add Acks
>>
>> updated, thanks.  I'll suppress the ensuing email flood.
>>
>> Kalle, can you please retest sometime, see if the BeagleBone Black boot
>> failure was fixed?
>>
>> Seems we haven't heard back from rmk regarding
>> https://lkml.kernel.org/r/aVrUDeSkqqY9ZCtS@shell.armlinux.org.uk.
> 
> Hello!
> 
> I will test this v3 patch ASAP and reply results here.
> Collective sorry for the delay; I have been busy!
> 
> BR
> Kalle

Hello!

I tried this patch by cloning 
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=hugetlb-init/v3

Boots succesfully on BeagleBone Black!

BR
Kalle

