Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5229FCAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F908E000F; Tue,  9 Sep 2025 10:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77CAB8E0003; Tue,  9 Sep 2025 10:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B3FD8E000F; Tue,  9 Sep 2025 10:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6FE8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:15:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CEB451DE6B4
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:15:29 +0000 (UTC)
X-FDA: 83869909578.21.06AA3C8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id B56FC4001B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:15:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757427328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8LeUDwQ1TQcxoiiJ+B3yhPNPi07lHBnO96DM93lKFxs=;
	b=0G0U+t4CotL3w5dbqiQx/XnKhzqJhUvfvPLLKg+cc/dLcXF1uxgFlbfLw+zdYF5UieUwH9
	TgyQaAqo1zfwxconAV3yTTp/AO109//r9sza93cdDcyhuRh98c1pNaQP/nlne4geUqTUMj
	1sfG32kKNxfzk6mvEg74lX03IMPQ7So=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757427328; a=rsa-sha256;
	cv=none;
	b=KhzZ7v4uUo87lz6cQ/A757RQYoj7QiNBa/fu0BW1uNxCm6dyuZvJcNmLP0KB5Hy5+BhS0I
	YZqIMgE+4xMwGL1iI/gSOGkWUW10hiFI8/mAmLw0zfvW/qYddsyUKchaKdYH209mJSeh1y
	CmgWc20MTii1e5e49CxK5OKaKur06fE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C94C1424;
	Tue,  9 Sep 2025 07:15:18 -0700 (PDT)
Received: from [10.44.160.77] (e126510-lin.lund.arm.com [10.44.160.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C5F63F66E;
	Tue,  9 Sep 2025 07:15:15 -0700 (PDT)
Message-ID: <f27a2684-6656-4eb0-8255-e7bc4811ce87@arm.com>
Date: Tue, 9 Sep 2025 16:15:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
To: Juergen Gross <jgross@suse.com>, David Hildenbrand <david@redhat.com>,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
 <d23ea683-cca4-4973-88b1-4f6fd9b22314@redhat.com>
 <f6965a43-c299-4726-896e-6cccd0a23ae5@suse.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <f6965a43-c299-4726-896e-6cccd0a23ae5@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 83g3b8ajhf8qph8nnu5j7safpre14nhh
X-Rspam-User: 
X-Rspamd-Queue-Id: B56FC4001B
X-Rspamd-Server: rspam10
X-HE-Tag: 1757427327-659641
X-HE-Meta: U2FsdGVkX1+myrCTG6VG1ETUk/wrrbEuKIp1kucT7yzVuYnE/ZT0yVnmvbnN0OokihlP0M4ddl+aB5lanNtVWpEkiM4XCramwFsnxhGqwrgLNPc5LaOdT1QYZ5sGBDGTnQ1xPuhZaMGHuGLPJyl6CYxNJU0uMc1WOW/Er0RCP4I39qzdr0uDGBVhx0oujZkTDsAJsiqMQUuLWSW6HZ7umBbBHz6lU8zSOF13vnn60I8lWby8NvD23akpombcN7pBVuYQsjiWMnItrrifgIBJXyFCcP4v1c1nCMHgY1Aynu4e4lXUc3qb5BAnJLH0zG25uQmUJPg5H6LXh/rt2FCmD1uyTkraeD8cBm2oe1CBzXD+N4xu/DSCyKYEwvSrBgcZkWbp22YOtxsfGjSr2/qbt3NU3tXxLC6cAuhDPD1n5tGgb5vjy6DkO82W5dd/PwrHB0qUwcMU1KITEdC5feT5d+ByqEDzjE46BCLjvRsG3/AfVvga5Fll+Dw0j06hRNH/A1uAYsKFCETuW8Dsr2mVXVCVeaBVEspQ4DFEJUEsvgfB1wX/cZs8YijCuD2iWh1GxEBJYUqpGId2g1vf9h9nbkmp8V1/UsGxvSuElswauAC5kSznye6yutvQqQHn3S8KFHA/lSzHu4j52QBCaHJvuDteyNuD4Z2y+wba6TtIDlkAyrgpGAxjm3d8H90gIkeiiinxRUP1G4dIGULnCTbuO1qNMzQqnjgG1EIDJD6/T+Fa0y5WbaPgYebXGDIIrX6X+imnqyqY/Kx7dZHETYor1PPdP6/dEgWMRwoqD0L0gN9RYkef1gbaDLMxBw2COJRrCmv3lzLrK+MQ9BT39QErAgZtAnbi9vWIwtOem3gPvDjEw2ybih4gbFffadOYc4c7WWG8qpRkGzMiunicLIdROpPNwTF0jlEmpCHDILBOx3gfKas3P/QX0CDoRzIXTgQieBEhKmOv2nbIPGe+I3X
 OFjpdiXm
 uO/Z6ONoVLVpKD1sFOESpfqmeIXXSkfYEZFSkIoA1Sw4KUQ/DpS+OizpBLWz5pQCzpskulXy/+1Cwv17PS93zR1A9iFDu96M1xeSAYgoBJQycHdkNu1vkw+n4Z0mHegCmxzpq0/rFaB5gzLiHVA26GUj1bha2v7QSIP19EjXGEWjapHGZXJCtx8yeJRun2m9FuM2T38ay1AcB4uXXevfy9DJ7uA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/09/2025 12:57, Juergen Gross wrote:
> On 09.09.25 11:07, David Hildenbrand wrote:
>> On 08.09.25 09:39, Kevin Brodsky wrote:
>>> [...]
>>>
>>> Note: it is difficult to provide a default definition of
>>> lazy_mmu_state_t for architectures implementing lazy_mmu, because
>>> that definition would need to be available in
>>> arch/x86/include/asm/paravirt_types.h and adding a new generic
>>>   #include there is very tricky due to the existing header soup.
>>
>> Yeah, I was wondering about exactly that.
>>
>> In particular because LAZY_MMU_DEFAULT etc resides somewehere
>> compeltely different.
>>
>> Which raises the question: is using a new type really of any benefit
>> here?
>>
>> Can't we just use an "enum lazy_mmu_state" and call it a day?
>>
>
> The comment about the "header soup" made me look into this problem:
>
> It seems some of the "#include <asm/paravirt.h>" instances in the code
> base can just be dropped.
>
> For the remaining cases I'd like to suggest a reorg of the related
> headers:
> Instead of having the non-paravirt definition in one header and the
> paravirt
> ones in paravirt.h, maybe it would be better to have only the paravirt
> generic definitions in paravirt.h and the specific functions in the
> header
> defining the non-paravirt variant. This would probably resolve the
> problem
> with the "soup", as paravirt.h wouldn't rely on so many other headers.
>
> I'm just preparing a patch doing the removal of the not needed
> includes, but
> I'd be willing to address the disentangling as noted above.
>
> Thoughts?

I don't know enough about these headers to express an informed opinion,
but it does sound like a useful cleanup. Do you think it would allow
<asm/paravirt_types.h> to include <linux/mm_types.h>? This is what we
would need to have a generic definition of lazy_mmu_state_t (which could
be overridden by defining some __HAVE_ARCH macro in <asm/mmu.h>).

- Kevin

