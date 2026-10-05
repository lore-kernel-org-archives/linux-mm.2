Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B7D0CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 15:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14A826B0088; Mon,  5 Oct 2026 11:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FBD86B008C; Mon,  5 Oct 2026 11:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011826B0092; Mon,  5 Oct 2026 11:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D67E36B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:30:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49665802F5
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 15:30:49 +0000 (UTC)
X-FDA: 85288960218.26.303FFC1
Received: from mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0100C1C0009
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 15:30:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j6VTrRgn;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.3 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791214247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B2VA45vllBvMtIoncXl0OySE2UGSiOHXwSV6ttVKDEM=;
	b=ZjWnwk9w4lQmkLHhFBcvH3Fef1hXWJlfi9UH/RFdGGGDsLLuBgGo0c28pLYwdOleH3Ab5V
	SQJpaeR+PUbYnTi3E1mHQsRbYqQxktWtq8zwhFji9P69auHrVAF0PTsXGBs4eySSEBAxKj
	A50hDawyuy1QzXA86C8zZpDPJJOAvlU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j6VTrRgn;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.3 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791214247;
	b=HTMcv2sFi8lLNqozlOXHgLPn5hhxl+oLDmzRkjrXB6QDGd9S2Iai8tkycaqaX/iG7RvnTu
	4v1HaLzrYpm6PwY6ic4JEuBNAOHDrdITIosJcYTqoWSz0jk6mcFoImO0PlSpQSPyO+bLPa
	LmFOYailgTGbVLvncexrb41q5wNBSNw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=21gxMkJy8Tqmj1dU+Rerqv+FZsw/hh5Y+yv1SLdWWq4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791214245; v=1; x=1791819045;
 b=j6VTrRgnmgzRxAAV5m0NuUV7WgNA5nN8NbSXu28bo6iVIfQN3PvHmEkXzYNdZ5rWnac5ytVp
 Q3TotqNBm6pnqRcQnDWmsImLU3aT1Y9TxpIWmn7u08n7L6pSkC0iswyl3r7264eH7INwvUAKvcW
 CuBWw23onubzWK8GWFH4DDYQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0be697459824643c;
	Mon, 05 Oct 2026 15:30:33 +0000
X-Mizu-Trace-ID: 0be697459824643c
X-Migadu-Flow: FLOW_OUT
Message-ID: <5fd2d5a3-8499-4811-b2b0-457a2116807e@linux.dev>
Date: Mon, 5 Oct 2026 23:30:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
Content-Language: en-US
To: Rik van Riel <riel@surriel.com>, dave.hansen@linux.intel.com
Cc: luto@kernel.org, peterz@infradead.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
 qi.zheng@linux.dev, nadav.amit@gmail.com, thomas.lendacky@amd.com,
 kernel-team@meta.com, linux-mm@kvack.org, akpm@linux-foundation.org,
 brendan.jackman@linux.dev, jannh@google.com, mhklinux@outlook.com,
 andrew.cooper3@citrix.com, Manali.Shukla@amd.com, mingo@kernel.org,
 stable@vger.kernel.org, toshi.kani@hpe.com, david@kernel.org,
 mikhail.v.gavrilov@gmail.com, pfalcato@suse.de
References: <20261005052302.43042-1-lance.yang@linux.dev>
 <4686fbed54796cbd32b5d524938d9cde184ca501.camel@surriel.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <4686fbed54796cbd32b5d524938d9cde184ca501.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0100C1C0009
X-Rspam-User: 
X-Stat-Signature: 1qn643bwikw1ej96m13g37zawiq5bkmd
X-HE-Tag: 1791214246-494657
X-HE-Meta: U2FsdGVkX19s13oBzsdlyJhbbECylVVclV90uoPUT4flPr5nrlSb32KkDl6QlnG/iFtyzolvu/4FzgpoWF72RlPgU4pW4TuHd18NAtFAx0QxI5C3Uwib/eULWqB0HYUHP2AsS51oKb59nm04aI2ABnGZM42bM270yMZXoG7PrzdlBO2zPed9QV3EdQJE/ku9ANFt4/mHj4ZVAMrb4wV11d8w0Y4n9GeDVsFmpGMQ3sNvt9tXjiO63IEFjBhFP2zbIUfgkKK1G9NRtIttxYSsQa4T9g2Ij0U/0sSWuVjECSXsUI1W7LNZwHqNPJLMHj4iit1UhD/b3d5Soaq0xKI5HzFF74hmdETNEZQhyTzJFnSMckSou+bNmzxE4RFCL+Zj+0QXZme2F1Bbq6iKCb7lchbzNtvsqzQH1dcouXtkq8Bm5ur6UMaQWr+iCCWBwalMrBI107h2GsYvfth7Mh6INCjZ5gxuzW+Vwq9bdS5qwPxyNXShQJZVvM0i41xwz7GCQbAvp9rwSFtAP5y1EoFr67HvwmRtlatBdkxXMGOKieQ5resaP/zejMsp2zHuCIg7NrEpJ8MDidP20vXR5F/Vya5bkIlUJEPX5ZFqowTCay0iLzlIkj/qtme4ArrhilkxTK4JIgCFLctTYbZyt5NPFq7Uc4l34DbiY2No5ShYrn+S1PM/Dq66MTVrqck2ZrvXbrSg4b+0MPuG9Wy2BqKnjoNKIZjmPQyMJtUclnC0WK6hTuw28aihnuc72rQdso7zSmGMpfFg9CJuTef+Ee3oxKgdt7BOOz1YRolsIhHpzhwK0MeGnFpJPSU8NJJcTYGOBL3oOudKd4wBiUIpHKqWUaBUxN7khEstkqEzx+VSkSQZbMyerps4ED3anAt+C9Aj+2KKOsTtZaUmB+dj1SiTA/WUlEpD417ZACyLtoyWzM1BXWI92FnFq3mp7vYYErxisaFrgdCX+ttAhmJ3VW8
 +pzYwgU0
 vkU0eAl+CfROySkYx84zhLFh8DhdJKfEhaQar1vEVd99rakUz0T3KTHc4XND8OM+L/BnCl1+C9uox8ZC1CBSGaWlHLg0y8/VVdoFj+MFcoNrbVbx83ofZySEXI9DnaO+gyZ5PRaXav4GTM9AaMcilp1IR2CNAYJS7o8gHXQFi+c/tY1/kGIE1TqNdcUvg9f2d5tBbA4aJyuQ6JpdDjsxaSW+CKi8/6E1Yl8dXRXEPy3pw+X4EmznecEHSs0xmRAz1xS/WLi9iVI/8cWOsJ27F8VVgmv7FirUi7kJfzf+mVNsaeYu4v9ZB6Jp3g18FHYvszyxzLrZR1ItemfTvVN2sArNIouNkbPDksQo9CMDC84tCYuOrAbzNzH43sT+FH9MXxN7A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/5 23:15, Rik van Riel wrote:
> On Mon, 2026-10-05 at 13:23 +0800, Lance Yang wrote:
>> pud_free_pmd_page() uses a single-address invalidation to flush the
>> paging-structure caches before freeing the page tables. With AMD TCE
>> enabled, this only invalidates upper-level entries associated with
>> the
>> target address. Cached PMD entries for other addresses in the PUD
>> range can
>> still reference the PTE pages being freed.
>>
>> The AMD manual quoted in the commit enabling TCE says these
>> instructions
>> remove
>>
>>    "only those upper-level entries that lead to the target PTE in the
>> page
>>    table hierarchy, leaving unrelated upper-level entries intact."
>>
>> Even with all PTEs cleared, speculative page walks can cache present
>> PMD
>> entries after the earlier TLB purge.
> 
> The comment above the function says it all. The TLB
> range should already have been cleared by the time
> pud_free_pmd_page() gets called:
> 
> /**
>   * pud_free_pmd_page - Clear PUD entry and free PMD page
>   * @pud: Pointer to a PUD
>   * @addr: Virtual address associated with PUD
>   *
>   * Context: The PUD range has been unmapped and TLB purged.
>   * Return: 1 if clearing the entry succeeded. 0 otherwise.
>   *
>   * NOTE: Callers must allow a single page allocation.
>   */
> int pud_free_pmd_page(pud_t *pud, unsigned long addr)
> {
> 
> The PMD could have been (speculatively) loaded by the
> CPU after the PTEs were freed, so that one PMD mapping
> needs to be flushed here, but there should not be
> anything else left to flush.
> 
> The code looks odd, but it's a good idea to always
> ask your AI to draw up a full chain of events for
> a bug to trigger, going all the way back to something
> calling the mm from the outside.

Thanks for looking into this! I'll take another look
and trace it through.

