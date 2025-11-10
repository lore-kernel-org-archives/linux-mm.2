Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 008A3CCFA1E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 10:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57D438E0014; Mon, 10 Nov 2025 05:37:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554CD8E0002; Mon, 10 Nov 2025 05:37:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492348E0014; Mon, 10 Nov 2025 05:37:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 396368E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:37:54 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCC574C7BD
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:37:53 +0000 (UTC)
X-FDA: 84094346826.10.1A2B754
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 290BC1C0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:37:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762771072; a=rsa-sha256;
	cv=none;
	b=odlyvmmlkHkJA42TANtfN6AlHF3hZ4KcXQWxEGg2+FbnexWqu1imW0LvcWgHLI69Iuzyvi
	vrHImLt1yAu6Te3Spqw3ygk+6OpVsWZSD1dcuE4/4m9+3E5COfYVKxB3FkMS94hk/ued3K
	jdNgdVoPos5xUtT/ZruaczS+k/lwKPw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762771072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hPCgPoE70BetgCqXoAumCGOuKiFkJIVELItuY0uabRE=;
	b=E1FI2pxbYGHWYFAbQA92jKafadApdwGpBNBvDfQBbYWsuwI/hFObfW8Z7zGt88eO62Wpw5
	CiBRLLhKJ8snja5cyjaL4HcU02FSGkXYWaJq8dcqoJmERkkvcBSUPDrglNXJhhFzlLD36a
	8FD+C7Z5mjCIOPVHnIl23Bsa/8hzzJU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4A3CFEC;
	Mon, 10 Nov 2025 02:37:43 -0800 (PST)
Received: from [10.57.39.147] (unknown [10.57.39.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EB953F66E;
	Mon, 10 Nov 2025 02:37:43 -0800 (PST)
Message-ID: <0d00dd6e-9e39-4ac6-8ea4-9407e75947eb@arm.com>
Date: Mon, 10 Nov 2025 11:37:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/12] mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE
To: Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-6-kevin.brodsky@arm.com>
 <6a9c846f-22b6-4d5f-81dc-6cdcd4905952@arm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <6a9c846f-22b6-4d5f-81dc-6cdcd4905952@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 290BC1C0002
X-Stat-Signature: jyr9b58irghrf8znikjtoopxtr7ub4y9
X-HE-Tag: 1762771071-363782
X-HE-Meta: U2FsdGVkX18GMFED62W0S+TYmbf1iY/otuNuzV5bzcrAXwaUI1MdvwVEHja83TPi9m7Bc8Z15oxk8B2Ico6LtZ8seLQPGiguV2AwiVhPAfDYURFc4rMZWLTHnujjnuUtQFWbxXzFwzci4ZEncCqK5bwoEDsStGmkNhh2dPWUJpLqOE248B3T28uNteXOtnBWc0AkxlUnqv3GJjMuRDVHSZzPC0qGz+p6pYHo46RzZyeIJtILvyXjRe3OQ8K86JRxIg1oGcYtf3PsNDXK9shB3fqQrfF+dawAuPf+TmwWudsL2SF1BnLIxIFOKegeOI+MGqSdrWfLSbevGynmDUzetBHdSvsEcj/snwDB6I4wxRFV+p8AB1CmfgOUQ3qlFEmN5ude1u1e8WU5/WWYcj+meHUeRxFhKQfliI5oi2SISWAxtTBNeEoplEJnDIn+GnCYTzIJaxiSJCDpClrrj5mm8rlBFBEgkp2AYROVftzcDQIyv2jp0r8jkiREammLJzyt0qo2UzPUpfdHCA1wIL2udkHssciWG0GdZGXMlea3PgCwCOfklPput2Cdn8xCLxUT0+E341r97AlQ7NkMS6C2CWwwlCHtWHAOoU71FI7BGdzePYwXJYX+jFFwM1tVz5tjtUHxb1VH8t/p/ksd+lyy1+MsadJ3l7pgK8sKqeG70NiEkIWpq6SWbY2Ajh2NKcbQ4zv427IV1415XG9ccUKxy1mq2o4MDICbKxPv6sZA0QMbEGCsmipJfzCR8aeGlGEDnhrl5teq0aFyIC/kMEWHy6MvNq0R4XHulr0lp/dob3QFIn1CThP3FUehyMlmhjA66FyZA0ubhHiImmJMSb5H44gvcHvwNwsXtwcE0EKBjF97TsSrq6bqQMfE/kmwe38bsUaLS8gZM3lFczWcM2GRsg2SnVw/rJ+poCCx1NM+Z5QHDMdbUAwf9Wp37ORZj3SUp9+wuIiCyirvsaQecD2
 /nhjtdUz
 PxVPuogIlOp913mHCB8mcYm6Gi5EDbExnzWRFjF5y1OTd0Z7xwUCYobRmLOt8rvfD3ZgjFllN9Z8WcyBzdFJj9+ElucRzQUIDOY2WnCqaesn7uNOdg00WSE/WL7/GR2oYbsBf9IzjDw3GkTmwNENroYerwRDeC9SPfGpGpxI2CF5GAKyQ+FtVyERSqNQfAXGPfGYULyDdNlxB/XpHtyPp1mEbLitDmYJTqc8yT1Nel25ohUI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/11/2025 13:56, Ryan Roberts wrote:
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 6663ffd23f25..e6bf5c7311b5 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -122,6 +122,7 @@ config ARM64
>>  	select ARCH_WANTS_NO_INSTR
>>  	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
>>  	select ARCH_HAS_UBSAN
>> +	select ARCH_HAS_LAZY_MMU_MODE
> nit: This list is mostly in alphabetical order. Further up the list there are a
> lot of ARCH_HAS_* entries. Perhaps move it to the correct position in that lot?
> Then ARCH_HAS_UBSAN stays out of order on its own.

That's fair, it does look like it's mostly in order apart from
ARCH_HAS_UBSAN. Will move it further up.

- Kevin

