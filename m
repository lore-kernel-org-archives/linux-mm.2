Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B852DCAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0504A8E0007; Tue,  9 Sep 2025 09:59:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026B38E0003; Tue,  9 Sep 2025 09:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5C28E0007; Tue,  9 Sep 2025 09:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA7988E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:59:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A2F0B9F8A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:59:54 +0000 (UTC)
X-FDA: 83869870308.28.70DF5C7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id BF960160005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:59:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757426393; a=rsa-sha256;
	cv=none;
	b=w9tv0zo9Y8w/xEynVgwUBC+vukdB0F2tWmcCQk00Rt6RbZPgLHxJtIDgLiBxgahq4aJ4hd
	SSo272LlHjMWuo7cXwS9luPanSpnD0/Ti7uSSZSCdfaW6eWQ85KtjB6AiHssSJO8J48JY7
	dgI6L7W52p4pJMM7RPVWybP1l8VU2hs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757426393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=me/PYrVLsmNCRPmt3YLLhQOu31Dt2HxN8RzThRmkvck=;
	b=2AbTe/3ow0RgU+KfrKakAQ8DWga9qf+unnZpC8LnbDAixcurdCas6fj8opEpkLdu5Q4IKu
	+jCZPdZio834RObMSdlWl7NfYnhvLwPdsaH7kf4fPN/VXvkFc+GinvOyldH2/U394tOOfY
	s13rE132PrZX/SflWPccXl2wdV4tPdY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E9261424;
	Tue,  9 Sep 2025 06:59:43 -0700 (PDT)
Received: from [10.44.160.77] (e126510-lin.lund.arm.com [10.44.160.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CF773F66E;
	Tue,  9 Sep 2025 06:59:44 -0700 (PDT)
Message-ID: <203c84db-1a58-42f0-a79b-35104d79e964@arm.com>
Date: Tue, 9 Sep 2025 15:59:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] Nesting support for lazy MMU mode
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
 <20250908191602.61160a7990b9ea418de758c7@linux-foundation.org>
 <d1b4ff2a-052f-4556-91ae-273962edbed0@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <d1b4ff2a-052f-4556-91ae-273962edbed0@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF960160005
X-Stat-Signature: xp5brrreb5e7fxtnxmdndnie9c9do6d9
X-Rspam-User: 
X-HE-Tag: 1757426392-659082
X-HE-Meta: U2FsdGVkX19Lh9vgh/QjJKzgFGixiVi4D5bPWUw8evw4RJ+foLFRu1eKyE8S6B3voBzmw6R5zoKOrNb7DBZDwX0LsFFyK0ybtOMFKBRQjeiaOKHi48ATtcf9yHq+bajXCP4HWXA6K4+MxjIh3QNrFVS2BqS5JQk0AgLwNsu+0MYyCdxur1MkMOTLaKmAhDA7PClYNHAPc6T5/zZzaHYEY24hjMhMR9NAUUSOaGCNyVylfMTiSI/ZstvI9hyDVnVZYJpAnpfZPZ7oZNsDb1VQ/rKz4ROChZq9nFVzPDpCZiDHhTfAimYlJwEdLpQoYX22EiJrbMd4EwStbBi2V8kSfVe1QpPeHfr4SkqbDuEm77Qx1OgmMEzYiZJ/zybkLTAoQxzAliYvM8xLtI7VrV74StLIIqYtxmtRWtVPwoeHkXrVK41hMAWUWzx2RKhak6O6OEbsWrPhH4dR4F9cwNpg1f3aWkZ7yPmGSlgMtlh5bm5kpQjQ1PsebNdLXhyXxwj/DqNAgm6XTUkPNv9bIjuDWTjKdlu6+KaU/uOLC9L1EZTpm2zfGmovxp2JjlfVY5MMCPjwBTfOs2brW/1OuscBL37Hr/MxInT8O21aIzdzGX9TjZ3yGF7SDTrDaC+f8utoz8PmnaU9gUXGIG+Jh5PnVr/NU/oiCA/FO38DU7aUNtkzq/IpsVVzhHqTL9cJy7E1poymc/YeJGiS9Y9+Quycs1oEXwutgx8fsyv4ap9k6WKUm0Ca5otv8QzI7eqPPQrDe6AEUZ2DDNMZPItZc4Cfqs3eUxtwxzScSYdHJPIMgcd5s8Vj0jBQKWYMM4+RuI1t92KpkN0DHuQZIawQIHLUFGB/R94F37SorF/qg9U0BrnYZOkiI6kUI0Xk38dqWdnaq8cisHoUwaIbuAB7BM/PmVPpJkZKkwMDGtdPUHjDhYitjdBzOElm1o+IQlGr7tJkOg5f5QKOjXyp087l242
 ysMLRBYu
 eCgpZWr9HcAXbEzvLuc2wn3VmTV3S0WeC1Tv6YzjPsysLVSoxqueI05QiepNf7gYlrwflIjSdFTWtSoNvOA0MFoDLKk7cQ1NgM1vCsVoFZdc7ViTT9C9j6XqGBw7lDhMys0DQWCCV54HTGVhWNCAW4zfAiHEZDTkNZIKXir4yMPGO1ifq5imKq2pD70yKLl6og7IhH5mxkTNWQrouL5duTAIqxjBP9lf3PBCZJnSYyfEVEJJeofEDgxtkA5eqC5IF46In
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/09/2025 11:21, David Hildenbrand wrote:
> On 09.09.25 04:16, Andrew Morton wrote:
>> On Mon,  8 Sep 2025 08:39:24 +0100 Kevin Brodsky
>> <kevin.brodsky@arm.com> wrote:
>>
>>> The main change enabling nesting is patch 2, following the approach
>>> suggested by Catalin Marinas [4]: have enter() return some state and
>>> the matching leave() take that state.
>>
>> This is so totally the correct way.  Thanks.
>
> Staring at this, I wonder if we could alternatively handle it like
> pagefault_disable()/pagefault_enable(), having something like
> current->lazy_mmu_enabled.
>
> We wouldn't have to worry about preemption in that case I guess
> (unless the arch has special requirements).
>
> Not sure if that was already discussed, just a thought. 

That's an interesting point, I think I've addressed it in reply to patch
2 [1].

- Kevin

[1]
https://lore.kernel.org/all/47ee1df7-1602-4200-af94-475f84ca8d80@arm.com/

