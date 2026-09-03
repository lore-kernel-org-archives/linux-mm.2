Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A1BC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 16:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460FF6B0088; Thu,  3 Sep 2026 12:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411FD6B008A; Thu,  3 Sep 2026 12:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327CB6B009E; Thu,  3 Sep 2026 12:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 106296B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:52:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 622FE1C22A5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:44:01 +0000 (UTC)
X-FDA: 85173023082.22.2E882FD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id B151E180009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:43:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tENFd08k;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788453839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnn/AYoSHbugk8b1Q7qn2t6H4dacOevAoUcpq3TWVlU=;
	b=Ufo7kXKARx64w++gOW9m659ew7BMW5hhAq1QuSK3Zm7BvsWneVvpVPMUKPePpUIi+226p+
	nFKsAiH3STJsZQb1WtSg8xa/YUF1/BqGS/Numu6COzN469CITB2FoIADkMGfyeU871VkoD
	cNTKGPz1CGKZ9HWfRlvP2ieOni46Glk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tENFd08k;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788453839;
	b=8PPl9M8tjewvLttYGTKZwwvitHYN+y7TCy5nGci3GG6HNQVCoJT4GtCK7ajHdQVxiKsISB
	JX90v9d7Zicczx6H3AEpljEiZzwBzJIA0z+Lk3Rwim03+BESNSvtEl5dm8aC5Cyw0lOttU
	3lH1agwkNGIudqd01zXK4nc5Gt6UoJE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DF901596;
	Thu,  3 Sep 2026 09:43:54 -0700 (PDT)
Received: from [10.57.6.2] (unknown [10.57.6.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D35D3F673;
	Thu,  3 Sep 2026 09:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788453837; bh=vWWRzkp0+9oMKve+SrPMb4YS1xG2sCsAn/SyP8y3BvA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tENFd08kZU5BI9AevP2DP6ylP6FwwMDs48XD+uMO7L0Bhz+L9BtkDN4I/SheeQ1Zu
	 vh3KCgFk+KLoT4gq3yBTLs7TWPaLUAlYsO6mFXeDPTzA2CxeRUO++TSblimvJgqJm4
	 jYV5T0gUjWBtFbQkkOYjGhGmPiH+d6vIqx+nfiEE=
Message-ID: <c234ed1b-b8ba-4a90-bb16-96d34878b893@arm.com>
Date: Thu, 3 Sep 2026 18:43:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 04/25] arm64: Introduce por_elx_set_pkey_perms()
 helper
To: Linu Cherian <linu.cherian@arm.com>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-4-743ad31b2c8f@arm.com>
 <apbkbH6Q4p5KYmpE@a079125.arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <apbkbH6Q4p5KYmpE@a079125.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3zf63i4gqqmft9cc5nexbpeof854faqz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B151E180009
X-Rspam-User: 
X-HE-Tag: 1788453839-648761
X-HE-Meta: U2FsdGVkX18TBDiL04whutBqbh8yOR/NN7HNHRp0VD0Dj9Y/MwBTDGcPk7NaZOZL7c3lotdafOdncPbKyRbSXrvJlA/SCBkhNc3q9GNiJ+IHDY7OnyEBs7RW89Bj6Cg2cF7QhHcYQSZDt75VbI5jcE1W7qvjHMgAIVkk3ouL3LXmvOcu0IW6y4H1eCwDItRRSQDnyS1Pz9Cyvu4N7T6CWdb3/S00xlM/9zAV7fK+2U0d9EqEa6tPjtcajbbyIFafa1YumwLe5fJfb4Cqsr48rx1PU2+671+hPKdYy1jOLYxFpG0mIRdMcL0u6lp5E+h4xGVA2jC5OiucRNrbg5Nxa/vKKDRC15kWU9c572Hsrj+qeCCmVSDTLAQXJ4qXKc8G3uLfI+RFMz++HsXvIPMB5eVwKgcYEM3eGo3N5h0GGhKYu3SZ/MdcWUfkAjPgremp2+XrgTwF/svy0txmgUag14c/bqMvRJ8WluxiQU0X/KIrNPxkaH1iQ8+jZTHeWzdsFvNOKKXLZjURVHTK6FDGdAZAL60WetVc/rP43PaZbojqYQSF5JHL7LEN4ZpEGtJhsSb9Qu0EGIz726teWv2cd5xGLp48MMoJ9UykaFYuB7fEa3a/Prvyp0xtYR1mSM+qCD9fQ3MmuFdTRYAnaaynQeXzIYq+NdNALAzgasmAdEdahGAKqmQzb+vq6NA3CVD/O2L+SKJSk7he0fuA6kJnqKwS3ql22rlDBYR4Ap3dzhlujhOxbOgr5aGntgfFQmm9qZnqAIiEvU2k6Qg+OP3PQxQ9SCPC1l1LTxLCutk48BGAIR/V7XYIxUhSsR70195KLhWlBC7tG7nQ9EJWJaAJVHk42Xfp1HuQf/yJXLWRlOliUUVAoQFznHFcSFOtmTL6D7VtJmifwwoAS9eZFsIca/M0QGymyiRNU+boZKJisHC1ypvHYCZt7olRPNfKsrYt0zsDT4NACxEnSpLKJnC
 1gB0jPhc
 nO3DgQGSQwfMqw9Oh4g7KMV/TzbwVlHDudHH9mZSBh8vftkgpNCr8E78IPB9mpEel+GzMjD+KGcoyN3X0scL1Oa0GBceGFwze434tslgA6vMN4GGC5cnQjO/hjXaaPCjdzAfs37GI7cT0BQ0svujlAF1Xn6oAdn7ESPb4o/tui7kgWzM57KMV7u7uZIT5T+376E3D/lpm97zElMbCD2Pb/GJ9m/ASwV+BvH+m/dajZ9rQprWCR8OAlBlrCG1UAoKerMCKcBdYYFUhWX/cfUaZdzLSl1qFETI+OGDlVbrpsJqa4GnO1YFCI7Top30mtI43w6ix+Vi/7XifQAp4DZ8hMEXj/IYhvzy4tgkX3LbuQEGsseuklZBGZ/UxGkf3Penem8LOyonVg9gXb8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/09/2026 16:42, Linu Cherian wrote:
> Kevin,
>
> On Tue, Aug 18, 2026 at 03:08:46PM +0100, Kevin Brodsky wrote:
>> Introduce a helper that sets the permissions of a given pkey
>> (POIndex) in the POR_ELx format, and make use of it in
>> arch_set_user_pkey_access().
>>
>> new_por now represents the permissions of a single pkey, so rename
>> it to new_perms and change its type accordingly.
>>
>> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  arch/arm64/include/asm/por.h |  7 +++++++
>>  arch/arm64/mm/mmu.c          | 26 ++++++++++----------------
>>  2 files changed, 17 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/por.h b/arch/arm64/include/asm/por.h
>> index d913d5b529e4..19b3dd1d43a0 100644
>> --- a/arch/arm64/include/asm/por.h
>> +++ b/arch/arm64/include/asm/por.h
>> @@ -31,4 +31,11 @@ static inline bool por_elx_allows_exec(u64 por, u8 pkey)
>>  	return perm & POE_X;
>>  }
>>  
>> +static inline u64 por_elx_set_pkey_perms(u64 por, u8 pkey, u8 perms)
>> +{
>> +	u64 shift = POR_ELx_PERM_SHIFT(pkey);
>> +
>> +	return (por & ~(POE_MASK << shift)) | ((u64)perms << shift);
> We could use standard bit field access macros here ?

Good idea, will do.

- Kevin

