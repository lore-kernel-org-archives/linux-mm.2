Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEF61606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=btak/NjA
Received: by kanga.kvack.org (Postfix)
	id A314E6B05B6; Sat,  7 Nov 2026 14:29:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2406B05B7; Sat,  7 Nov 2026 14:29:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1FD6B05B8; Sat,  7 Nov 2026 14:29:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FDFF6B05B6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:29:10 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9077A0184
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:29:09 +0000 (UTC)
X-FDA: 85409311218.19.FB5D5C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0854420006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:29:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="btak/NjA";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794079748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Ov7GeLhcYhxCP17ziUm+7IIU7rjkhp7m+eZjNGqqtY=;
	b=UnTWOIrb073WhRz7meR8MLtAn/DjGbLfs1Q+ZJFA2aezXVBn/882iMnGuvQr5/+p/zz/K6
	6WmDFKHAaTK3GYLI+rMlK113q1HFtOE1iYFCcSOQkKGXRT1ZNDuKRYH5UiF3Nv5cGhYJwi
	b79L97kGwu/nU8Ajn92lAP/banDD/zQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794079748;
	b=wuJigbsgHJIaQdOQR65At9SliCc/sMHQJVV6lZLBqjAO5YdGHp3ShWTDFfBkZrP0qHdGRc
	BMfqLXgBSwEQ86lSArzBKaU5MM1sEK35R1ArL4IZQ7ysUhE/c1PLrNU1RS1S2m5l51sE4f
	c38iA/sHfcsPhb1/AFJLqbudned3sQ0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="btak/NjA";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99CB0417BC;
	Sat,  7 Nov 2026 19:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507901F008A2;
	Sat,  7 Nov 2026 19:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794079746;
	bh=7Ov7GeLhcYhxCP17ziUm+7IIU7rjkhp7m+eZjNGqqtY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=btak/NjA5HXiNm9eB53iO2P0kVP6gcust1hNujA8Xhe6SIGL7ZPNyeyKDTGunctTR
	 +wKgGgu/BEey5ixlamyuuMx7Bcdih5YAlVE86Ut8vPi14t2nTSknpdYOCBbtRyD31Z
	 43q3G1u4wi8qbH6BgQk89ak9+8YtQ47eqIDkb9DJFZ5WcgDxml8QILGXk4mJORmmio
	 TMvcFjn52TIiV5wVNRNgUOElBw5Qrl22KgPhv0ObjtodP+I++g087oaMQpVvp+sica
	 4lColLpj+W/eH7yV/gc5tMuHVdVLNehJWSNNGUbPy1VCMfCagDWMrq8ZN3ehE7BBlz
	 vbreZ447FvvKA==
Message-ID: <bf5c4e81-2c9c-4f4a-ae7c-9edf6a524d1a@kernel.org>
Date: Sat, 7 Nov 2026 20:28:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: clear pmd in pmdp_invalidate()
To: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Cc: akpm@linux-foundation.org, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org
References: <f1b2ec5a-f7a7-442c-97fd-f67fe6ecb197@kernel.org>
 <20261104111254.320059-1-trintaeoitogc@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261104111254.320059-1-trintaeoitogc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0854420006
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 4de381x4g8cq7gbtznkdjnf3pyrspr5a
X-Rspam-User: 
X-HE-Tag: 1794079747-702639
X-HE-Meta: U2FsdGVkX1+Q+YSoyEh5P24Z8yVRSvB4yh0ZEYy7orHMxxUWOCO8adgt+B3VtMUhsau7H5f+rTZ0BPwTa+t5XiwSovt2CakVeQTZMFFo/Z3fxaZIbhNhc74/ccbeKWlL+4qdlNM19Se08p5j8Y9HwsuXm97agcKh1aapGQK5dk/SQBmQj9SUUPgLLJoesjVcZIoT2c6QfjEa/vkQrogyZwDqjyfg3BaiKPTNs3k0+vrKtgNygIc9kSGmsre7RbxLcVN+hrtLkYlGTxiWZfOSEO9Z97CWioksdDaQ86v34cHu4TCd7dJiJJ0Rx2FJXlLFJ4pLFyGnUrYFTuTPo4Be9auUBup+wwj3+9jpod2BwWJ+bh6fFO542iYCajmLQuxp6TLYEF5Domnjwd0zvH2XLUbaBXzp2XzrSe9qqDRsNHQPKjE6Jt/4RMiSqaTYxK4FKlZf/VW5h/dJe62Z6OtbvAp5cWPkRkocbR8ZGxwmVDuS85CEyur3TvjCZvikY7flLtiKvMTDa5eeF78Werrc352/wdFVdxRq3fmMINx1lOjm0kOlOv9pZZIJY4dUsO6i4hAmFfyOFIWJnW0pMhS17KcqgGsifaRkITNIoDw2fm2CaufrsdDzoPa3T2ZVhT+5Z7lWiAJ9nMiIIi/ubb2fpWr40KtxqV3KRq/2VEpnorAZyfQQFhWzAhe9UpYsuVuvcOpFakDMKZKDOic0GN3G10lzGtvOXFmjIY/kBzCAbPYTMArefHZeuh2iwInHUIhZuzHoWf+WGy4WJV6H3CZ48K8DVw9Fx9qvZOKSj7BWFqh/7tnBJNtBydLj2Jrgka8QKi2iE0xk2/RihvVFWuRlHeYOrz9E9564iKP1rvnAa8weI4MfJMXwOwDaoprhmi0b2EIrg2+/zdyUIuYwfCQ6BRJDNSAiyYPOsnPWKduMKhPgs32PUo+i6BbUmygdY9fBM8wk9HGy11hBu12jqAO
 S+BItRs9
 Ug7+cx/MH+H6mm3XkD3pfQR0yWvBR4CRp2Du6nAa4STBJ4puwEgnoye7CPVJdAmK2Q4eG33cYuBlLcH/HoT1Ffo094ycZS1oLTNWJKHvOBG8LfDhyhYdC0cHY98RKE4Xl/xeHZCtePyaiM4XrkzWFTBnIqRbe1FASqcTgXH5BN63r8PZeNwKiWrRysN3MlPkKJJZVZHsxRWiDpBJc32BfC+tJ5JiqiSBwcO4H9uNSdvvGk6bBwZZ2g67CW/IOuO8PX7dhlfIQCE4ALQqmQX7DvA7yB1Qw4E9x7RANnH5j99ooQXGCGqJZjx3R3QgHizhCGkP/LDYRSYZinBwlRH4Ft7hprsDIDDGqmam2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 12:12, Guilherme Giacomo Simoes wrote:
> David, I haved immersed inside this problem on last days, and how sashiko-bot
> very well apointed, I'm haved doing a wrong duplicated clear on pmd's. I not
> notice that the pmd_establish() already called the page_table_check_pmd_set()
> wich in turn call __page_table_check_pmd_clear(), my bad.
> 
> At first time, I thinked the problem is a duplicated
> page_table_check_pmd_set(), but with a LLM helpful I ruled out this hypothesis,
> because I not found any obvious call to page_table_check_pmd_set() before
> remove_migration_pte(). At second time, I suspicious that maybe we are haved a
> race condition, that make no sense...
> 
> After a lot of debug and tests, I found a thing.. And I attempt to test this.
> If you see inside arch/riscv/include/asm/pgtable.h, the pmd_mkinvalid() do:
> ```
> static inline pmd_t pmd_mkinvalid(pmd_t pmd)
> {
> 	return __pmd(pmd_val(pmd) & ~(_PAGE_PRESENT|_PAGE_PROT_NONE));
> }
> ```
> 
> but , the pmd_user_accessible_page() check `pmd_leaf(pmd) && pmd_user(pmd);`
> and pmd_leaf():
> ```
> static inline bool pmd_leaf(pmd_t pmd)
> {
> 	return pmd_present(pmd) && (pmd_val(pmd) & _PAGE_LEAF);
> }
> ```
> 
> and the pmd_present():
> ```
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> static inline int pmd_present(pmd_t pmd)
> {
> 	/*
> 	 * Checking for _PAGE_LEAF is needed too because:
> 	 * When splitting a THP, split_huge_page() will temporarily clear
> 	 * the present bit, in this situation, pmd_present() and
> 	 * pmd_trans_huge() still needs to return true.
> 	 */
> 	return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE | _PAGE_LEAF));
> }
> #else
> static inline int pmd_present(pmd_t pmd)
> {
> 	return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE));
> }
> #endif
> ```
> 
> And the TRANSPARENT HUGE PAGE , is exactly a page that I was allocated with
> mmap() (see my previous emails with my repro.c).
> 
> So, I change the pmd_mkinvalid() adding PAGE_LEAF flag:
> ```
> static inline pmd_t pmd_mkinvalid(pmd_t pmd)
> {
> 	return __pmd(pmd_val(pmd) & ~(_PAGE_PRESENT|_PAGE_PROT_NONE|_PAGE_LEAF));
> }
> ```
> 
> And this work for my repro.c.
> The problem here is what the documentation of pmd_present() say:
> ```
> 	/*
> 	 * Checking for _PAGE_LEAF is needed too because:
> 	 * When splitting a THP, split_huge_page() will temporarily clear
> 	 * the present bit, in this situation, pmd_present() and
> 	 * pmd_trans_huge() still needs to return true.
> 	 */
> ```
> 
> So the documentation say that if a THP is splitting, this should return true
> event though PAGE_PRESENT and PAGE_PROT_NONE is cleared.
> If you think about this, maybe make sense.
> 
> And after some searchs I saw that was already fixed by Yunhui Cui
> <cuiyunhui@bytedance.com>
> https://lore.kernel.org/all/20260523042052.35476-1-cuiyunhui@bytedance.com/

I remember that Zi is currently also fixing some pmd_mkinvalid() implementations.

Is there anything to fix from your side, or does the above fix already resolve
your problem?

-- 
Cheers,

David

