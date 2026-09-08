Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D44F2C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2EB6B0098; Tue,  8 Sep 2026 05:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B336B009E; Tue,  8 Sep 2026 05:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91166B009F; Tue,  8 Sep 2026 05:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE4AF6B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:29:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4520DA04D8
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:29:44 +0000 (UTC)
X-FDA: 85190072688.26.80E9D8E
Received: from mta1.migadu.com (out-235.mta1.migadu.com [95.215.58.235])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3DB7720003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:29:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NT4ngglp;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.235 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859781;
	b=yzIrMcSGwY2tYWMJJv6PunalN8P+Z4Ai+dxZg9khh9rIdtZVX3cEXL1PQLPrLvD1c+EszO
	zwLFp2awa1FjUsEQItG3qTVVuTidz23769V9w2kUC9g+45IjZ+3soNmV6dsSYIBg3voE5V
	c0cO5YTYhPwIJL32GBn3s7JZSsS7E5E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NT4ngglp;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.235 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ppl9VV+uiGLGl6RPtIL8FAMmwVJi/D2fN8+Nfz4OxG8=;
	b=HaDQZ7E3/1bPKpbuA4K3Ub9lMlgObDQdOS1ESX0N3BK9I6QuKJLhfqmjrfBzw6A1rJO7lL
	X/tCyi8jvQL/m2cMQDLsqKqM90nqM6EJBuYqD1gzsgTACC0EXEkSFksU4v5gx8+1Icl3pH
	O9ekyqWSzapBplQA6oxsKC70wLY+jG4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=15IOOyKa+ijGmMxg7kwu9CI1MNJx0YkgAkPki5J/TZI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788859780; v=1; x=1789464580;
 b=NT4ngglpu+P1qCAwMpvi5skJVqMX/UTGMoDC8wwv+T+PdUQBVVmjF2FUVhdYdbO9TwQ0CvzN
 VImV7aNtVlKFs6JVQGKU8UHxprvBNk0VJgiTliDg1qEsPoHzunKUJDVQVQimHC01jnyUp+VmXla
 n3/GnnhU8bFZ68YQHQVjMam0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c1b4dc536328070e;
	Tue, 08 Sep 2026 09:29:39 +0000
X-Mizu-Trace-ID: c1b4dc536328070e
X-Migadu-Flow: FLOW_OUT
Message-ID: <cc7003c6-9be6-430e-a37b-e43a08402825@linux.dev>
Date: Tue, 8 Sep 2026 17:29:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/11] Documentation/mm: update DAX vmemmap
 deduplication docs
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
 <20260908030335.96549-12-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260908030335.96549-12-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3DB7720003
X-Stat-Signature: hac8wwmuotyey7qsdqqakhhneedehibn
X-Rspam-User: 
X-HE-Tag: 1788859781-983636
X-HE-Meta: U2FsdGVkX1/RlywNwPsJt6+mvYxUNB2/hfN9J/Fbe6FtSHdkgkx+r2McWvxs3nDjuofoQ8mFOLj2U/QshjUX03wPq7+BsJjot6sS1TsK51BkD+fEKuorPP9f4F6mjPKotbCPcq7e6hilrDU/J3wSWo+OROtJHAAnYeklVeuEwmahHVKNjYq87x/8D96F0AWsypvmiRtoDQQGJPVZX68GLUpxZWPC4FCzuEbgtfHXU0RVHtMvm+mHLdl7Ey2fBQsLMH2/rbcXI6bor7dPQxwqlVBYuBA/bX6vnfdtVUiBUIHQMBSAPdUjqTNExnyIEP127Txn3xlcYUBYcJ+nJOi7h67/U1O1dUJQRHhmv+85crfGZUfJRjJVvo5f4Q3sR15VgnW9QZt4IQR1JC5QJ8M7nEuizwkPivOHZPRxu/ALaEC488LWeix4KatMzHtZKz1ATfn7A6t6zb8HisaoWxlWgRVvE7QlcZ67c5rTVv68RsMTeciwT6Fw9xuavhQCCTWnOg2g2ocHWUtujDIzSfKnvyfO/QHqWBhoqzH9XK9LoCOI9xkZAuxZ9iCb5Tx3IzDhZrzzyUBnukgfUFsSfiRDiKWQfq6MEdwNja1vYP3Tb7YQwtP/nJ4+mJBYKXbSr4ZtfPwcXxd5ezlMdLnKG2bSxte5AZwNhUmN8XthYJR0Jf7uq+uQR6S4pzKGoX8L1uwe7G3BIjqdvuWzI6nlq2Lkc/KwoNmDB5phroIS2aN2e8lSmgOmvZS0LPGdepVHUjFhlyimg9TQSdx1J6Z8azltzCayGasle1MDRxh4qkdO7BS5ssP7QHUkfFS9v/6jYJkhwQlMOiyN2HBk4lFuURm2lfHle4Pk1E2lo428/n41R6YmxecS65NeqOCfZLdSzlW8GW32E3QH1cmLZxm+dyr/vK5kg9QeS8coERIEVPWJAHZC5r/7qxOl3dbyT2EAaA4iY7ZDU8wkayMDODesqFO
 oyn8zhQt
 Tuxf7Xoq+WjQ7Q/BtWvTkyg1ATJVCRP1TOY7JEegjKtpwwCb6SgWKdtHBwXrHTjoG71YFUQlvp41Pl5oAJOtLVWBMeBm2JS8xC8glXVbZBa6q+mgXEqE31fFWo9DBM68pJRIBos1CyHATRxyNP6ZvKzNW6y2WI9UbGu1YE5xSNPXfindN/PEXy3S/SNjUR1MAg+UJ+mGhfp8DMBjVpmNUSSPh0/9ZPIiBpfYqZgId6kyj5h8xqlVYXjA+cmpR7ykrSH5UMEPmihPxiDMxcqTC4nnqDdQ+Gl7FczR9IbU3Y228IKuCg1DH9f8YXsCj0uaiJTEgwuSJ1d1UFag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 11:03 AM, Muchun Song wrote:
> Device DAX now uses the common per-zone shared tail page for vmemmap
> deduplication. The old documentation still described a DAX-specific
> layout with a separately populated tail vmemmap page and half the HugeTLB
> savings.
> 
> Update the generic and powerpc documentation to describe the shared layout.
> In the powerpc document, keep the radix and 64K-specific details, drop the
> duplicated 4K PUD arithmetic, and replace the repeated device-dax diagrams
> with a single parameterized PMD/PUD diagram.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2:
> - Clarify the commit message to state that the 4K PUD arithmetic is
>    intentionally dropped reported by Sashiko.
> ---
>   Documentation/arch/powerpc/vmemmap_dedup.rst | 90 ++++----------------
>   Documentation/mm/vmemmap_dedup.rst           | 32 +------
>   2 files changed, 21 insertions(+), 101 deletions(-)

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


