Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 657C2C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 05:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387E66B0088; Wed,  5 Aug 2026 01:58:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35FCE6B008A; Wed,  5 Aug 2026 01:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276276B0092; Wed,  5 Aug 2026 01:58:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06A626B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 01:58:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76D0E1403C2
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:58:13 +0000 (UTC)
X-FDA: 85066160466.02.3CA5F29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B980512000D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:58:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WpTfVY+g;
	spf=pass (imf29.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785909491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v7zCWK++jNfxfhEt8Y8jIgML8WXQN15ZQy6uHyDnBnc=;
	b=SkuYZbD5xtrNPwcxXV8pLEuA/tQQsGgSzlmnZfOsQI6u8Ofefw4XOrrZnjw0Zmn6dSCsD/
	fICGg7QPUZcQEZWygVk2C5+61xA2px2necK5k2e6oPOl+vNzCTflyqAldu6cSKzfuXKyoq
	TPVA9RLnj1w0jRGx2+QhKVaG9DbgXu0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WpTfVY+g;
	spf=pass (imf29.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785909491;
	b=EC/KND3tWEBEDuaGkHfUCVhBHAb5wA5+5Q84H3xFyr4NmC/5MXHs4KoIeY8N2p7FoLKicQ
	0PMSgchd8AZmYtlGAmMX59o06PoynKum1BjpqELN71CB/E5aykDGWiH3nWUx7YsBNIz9Dq
	8UD3UZtvI/WRxg7PPCqeKsuAIXWTObg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12245403D2;
	Wed,  5 Aug 2026 05:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574631F000E9;
	Wed,  5 Aug 2026 05:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785909490;
	bh=v7zCWK++jNfxfhEt8Y8jIgML8WXQN15ZQy6uHyDnBnc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WpTfVY+gis0GaZ8Ilij2iuNXtip1yECYuuQNUlYVo6jVc87VSMT30kmNOwPl/ZTao
	 7oJbpElLKRYZM/H9E3uzPA0m2dDs7qxBrWfUSWeNQgVusyFJAB0zhgsb3CndB3eLBl
	 oVx+8kJVKo/dvCnEjFd77EC7hbxP5rQoI682riTb93MQ9TfiRSWCb3g5JOckn0oZli
	 58e+xTR7r2M3llPSRy5MrzI9rSBdgu2K2JYrZI3FiSOydblbfVLAtbSKgrhbcozdEM
	 SIQIBRN5owC9lJ1/5UdzSc5P9So3/Y8YL+DvqEaETnFE51wJndUFjamNuiFbFR2lzb
	 lLGJvpl87Db5A==
Message-ID: <595fe323-59d3-4f4a-92a3-ac5d67b7461b@kernel.org>
Date: Wed, 5 Aug 2026 07:58:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] mm: constify the pte_offset_map_ro_nolock() return
 value
To: Pedro Falcato <pfalcato@suse.de>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-7-pfalcato@suse.de> <anHJ48Glq8EdHatd@lucifer>
 <anI6BEyTJFzQY-N9@pedro-suse.lan>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <anI6BEyTJFzQY-N9@pedro-suse.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B980512000D
X-Stat-Signature: 3kcx9j15do86t8ho9mrjz5ahde13ahm1
X-HE-Tag: 1785909491-676205
X-HE-Meta: U2FsdGVkX19hhdxcFFIwhi7ycivmc+NIU7uXbAwRQBfu2aq1FJn/k018SJN0/D3Tzu4L7FAA+e5sTVIWcMOLMTUmFaNwu9KNsAz/p+RDZl0CKajGv6MZjREAkORp+FeMCmfWaUsMhbMW7Hr2JOf0/gKz/zmsfYgPFiWX0bnHXCPtarWHY1ioPee9Uzn/A2u1/P7SsM55oNeW4PSXYtwacU5QLPpOjYhfhip+9y/4rrN6SQx2f1WhXyiBsZQ9we7TBKvAZddA7Rjxa21V3oKWuKmcmUVcHlgVdM1BWfJfCTxWr/hemx0eq653F7XYGB7TURDTZOSHE8W3t1pdkr5xfLUUBeFw20nkOfBE3umo6ehT5GVnhW3+eq8HRk7nj5tdILKEa9OxBBZOMGCbq/nStrwGnU21A2n27ezLX8d+rzHOK/pM7UpQ3Y4eDHvWoQ4enikH2rEs+boRWWIixCJjlGAmrH7OOQTeAQbqCPg/t8nOGCPl2EM03Fx2vixTL7e7N0CPDQ/OC4MDpl/95D6sC34OPUv3fnPQ96aBtSP2A9p6/cqqVQBpNqy0O4NHEnodu5SAhQSCwrtjPdX6bBkxbnpQtzriDPIynvlpcy6toDpUn/rNifZaBkJZX8uJUC3//DLeXB59hgaL9bo0ICooE5bBhvV4jQeNIDV8kN4Y86oE7yVyjgpUcYHtxpBRSMG4bMxFZjsd8ltkDtVLOMmePbkRCGCwGsokexQSnjqNexCd7WxMn0nvO2yh04ryC07npNiFOvXH1XzvglOmxQgQXKtoK3KMrcpeFO/alqZ9aZ9R88Eqm6RLb4fwepPxUNfpMRaOMNSwmVe8fdEgyR1EK1yN/ON4HXDa2NezjRhgMteAZ4shO+jjk5QZsmtgGX9R5p+qsw1n4a7qzRa/kKO8/KjC1CKI3n7oLZbgWATXTwV1D9iqloJbT2lzvnC3rm8MKgGLeQBo8z7FNSiNGhX
 mkQ2O1S4
 ZqN2XFUnUkEB70uBMlQn7ny3vMgkS7vqu4qBvgXjnym1K83oNmI6aHpsWMI4Q84h3cG+CfvpuJrTEYJglrVmws6JAR2H5UaBFah4oTqbAvOXHHiS/CT6oKoHiN7nCc52oxIQsayipCDvpkd/5DxYuZu9Erro3pROUd2zwgigB6C3lGde0oWCd1mc8WVFDN7GZdGuiUpkVc32JQ6g2dNXbTqaiwaGzzD2GTFkFBW/xEE3lKtRUgz8vfvaCcuWOpLPPRlO/EHYSngmo/gZ0ABG7TwIXYiNgzzCkDuHaBuIbMJw7gDDD178MnQUmHAEwjb+LMFPsHOZH65L+TcEOZ+bZD/FN5jSPeEx50TQ6Rgci93UkiOFv7jesZ4Jg8ir+83JMOgnCSiK1fePSuXqek+6boFg36w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 04/08/2026 à 21:22, Pedro Falcato a écrit :
> On Tue, Aug 04, 2026 at 12:22:19PM +0100, Lorenzo Stoakes (ARM) wrote:
> 
>>
>>>   			if (!pte) {
>>>   				mmap_read_unlock(mm);
>>>   				result = SCAN_NO_PTE_TABLE;
>>> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
>>> index b91b1a98029c..2cfc6e608ef4 100644
>>> --- a/mm/pgtable-generic.c
>>> +++ b/mm/pgtable-generic.c
>>> @@ -308,8 +308,8 @@ pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>>>   	return NULL;
>>>   }
>>>
>>> -pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
>>> -				unsigned long addr, spinlock_t **ptlp)
>>> +const pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
>>
>> Can pmd be const too?
> 
> I was going to say "yes but then pmdp_get() also needs to be constfified" but
> actually no, it can't:
> 
> pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp) {
>          if (unlikely(pmd_bad(pmdval))) {
>                  pmd_clear_bad(pmd);
>                  goto nomap;
>          }
> }
> 
> so PTE mapping actually needs to write to the pmdp if the pmd looks bad.
> Tricky stuff :)

But if pmd is const, can it be bad at all ?

Christophe



