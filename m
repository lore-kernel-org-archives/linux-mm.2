Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E21A9FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 14:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D38D6B008C; Tue, 28 Apr 2026 10:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AAE26B0092; Tue, 28 Apr 2026 10:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8456B0093; Tue, 28 Apr 2026 10:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F14336B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:33:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 893571601FC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:33:23 +0000 (UTC)
X-FDA: 84708207486.22.369B792
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id B7A5B4000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:33:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FbU42jRe;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777386801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCeRU6cOGKNVeE/AiCfrrcl2X3vWG3pW8J9VodBpu8w=;
	b=faAUdpPN05LV0WmmminJE+RprZBLsKlElwJTntf3AplwQdPpvSAVK3RO0Rbwg7NjyMhtjr
	yqFpEBPQ5PC7RPtKJeKYUqLBMYCzEcePY+A0zq/XxGSFTPW56rcuCPmwsrHc0iOKLmWJA8
	fzuJxXUUdt1TaXc5WcuYJ4Fczcz9ucU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777386801; a=rsa-sha256;
	cv=none;
	b=6Bf7nJ+5OOVyhZb5OJdrw7JEdSaHJBApR3tzOusuMPg4nA0EzV2h6Xd0o3aMU2BW5NHGFF
	ih583bgqGhTmzPsYsFnRH0ywgTw6fHHLm1p05TGDF4Kd1aagcReQZCTN5avY5e6pxysVRf
	n2j0RIFYFDJYVVnz0nD/kPo7E1ws6WA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FbU42jRe;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5107D1C2B;
	Tue, 28 Apr 2026 07:33:15 -0700 (PDT)
Received: from [10.57.63.26] (unknown [10.57.63.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 63F283F763;
	Tue, 28 Apr 2026 07:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777386800; bh=JDB0ysfCc3O+HZNjVWKQweokOG4BHmdvpSRYZ50uqik=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FbU42jReibYsWd6NKeLPLPky/aF1mB/E/5caW6uLbtydQSXInHIvalDj+UTrucmln
	 IVac9HVMny8XP6YKuQG1qxX4EIUfT4ejmLXHbaPXPbN+XCqX2KeCsSs/4yxZDqGWlA
	 F3yTplVvLLv/4Zfv7lahY9A4k269KL0yro8NgtDo=
Message-ID: <e6bf70de-5d3e-412c-8585-677706a6dce9@arm.com>
Date: Tue, 28 Apr 2026 16:33:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/15] arm64: mm: Remove bogus stop condition from
 map_mem() loop
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-22-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260427153416.2103979-22-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B7A5B4000E
X-Rspam-User: 
X-Stat-Signature: ua3cw6ad8uim5igk3prnts3ojq6ign7e
X-HE-Tag: 1777386801-49197
X-HE-Meta: U2FsdGVkX1/T3LHoOW0jd4YHqBIXfYxSpcG19ZZ9uJedsDoh8+xbfPCbLXMnWOC0al2h4pxkV74wkPjl9mUNmVAcqXDJeAPIubLnXzJd8mmIv7/X/6aIUDE2btaGqLifAlWl973kLGq4/PxGNHclLQaFaLy6w3JVaLlZv5g9/xAlt/zGtXWa8fBvgPeQCwiAqxJ9OWIe8g1Ab7jH+WVPdrsJh3esmE1rKawSCG/3FhKcRqvQfU0saegUh9N0n/GHBJQOjc0UnstlFbtg1FEkBiDPQIg7pPEwH6qvHotO3bASsEGKi9vROkpo3mHFSDzYEDgSucfBLrUyh+a4qj7x6Rkao6TlsEPLXV+91aNWnChgqCeBBCC6CWcPsKinjXB+5ME5enbCjBAovMTHj3iT7nRf9sVw2iCiMV3FaPDefjXeS1Bl40vbBV+DPuEhvMfkLRCLX6MZb2NkaI8qMCf3fW2uMTR4+LoGLfONAk9QSYkUIMDEhzC8LJn0faK0SOke6jf7PaxCjgCEaNsTb2ISsBcqT7+LouX5QdYnuBVBGuBs0RDoNQLFWyFT9A7vRgoSLk9GODvI3iNgHWGnS/pDYaEzDrT5dr6LP3cK4mvFfUExycWnEQJ+EOFblWsWE6e/NHntI6Pe2Y/OYqyDlkzbA8EfwIGkzC3DUss/lZfbQT6nMMOA3ndr3oe3r4pB3xVc8owv9Tr2qNMV1gLr3oQ/cp+M/AFBYuFimmXpEgEduYx/oDATKEBeczFOIcmA74cxZd4OGDvJE4xuDOOqqKhWL84LXDyEL9qHiiBTlrtAhsoAu2kzbjjoL4SEuW30e6/PDcgG+z4ZFVwlOhV/PjlalknDhhRqbAIuxdaC8vEvtSDXiCNEE2d7Vgl3xH/7xVPQE6v/kFtjZgkJa1FPevU0yIerCZV83wd9yPAgpsku+jfa1EtOTG7uKOwkZ5aVg9hrnkXrrfezHqFgF5XDO3S
 0JIQxVpt
 6mj9fdwnvdxcFhr3spPvwgKZOPlYv/aoHYzBOoVIoFsuzgHSqBHfDUSMy0RK19So7SEVA/V19/bHYtcq3gjTSvkM93YimBOiOm1otJHQO5Wkrj5i0ZEswGyAZp4pZsF5kN0Hj3e10sS2g+h4pshb0DyojA/UfRnyddTLa1YQh/87EQ+O6z73+65+TXQkRg9/RF2YsGL2I2aTcjrelf+/aiLiZG7Zpw1qKZc316X05vwVYVXvxxJk6EDXB7IlhQNjtkh7MDOhFJDpdJsaJiY5Lv3DuIxGMac3hyXNr/2PqN585e8sw1sj3C4OO7TTsm3EHZWp19iN9HKVKHL5m0rvQmu45U2E5GauHWiKreJJvqF9xqayJZQDq1qiQm5EXPQdiF4JeR0sZGSYadElp2lNcbT2l67uQmFhaOMiFCndwjLH0eGBAJ05NmRUJDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/04/2026 17:34, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> The memblock API guarantees that start is not greater than or equal to
> end, so there is no need to test it. And if it were, it is doubtful that
> breaking out of the loop would be a reasonable course of action here
> (rather than attempting to map the remaining regions)
>
> So let's drop this check.
>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> ---
>  arch/arm64/mm/mmu.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 005844e521bd..bfbf3fe0d1be 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1177,8 +1177,6 @@ static void __init map_mem(pgd_t *pgdp)
>  
>  	/* map all the memory banks */
>  	for_each_mem_range(i, &start, &end) {
> -		if (start >= end)
> -			break;
>  		/*
>  		 * The linear map must allow allocation tags reading/writing
>  		 * if MTE is present. Otherwise, it has the same attributes as

