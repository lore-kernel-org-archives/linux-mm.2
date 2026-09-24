Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2126C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 12:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080D96B0092; Thu, 24 Sep 2026 08:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031376B0093; Thu, 24 Sep 2026 08:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E658A6B0095; Thu, 24 Sep 2026 08:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C426E6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:23:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 941AC8032A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:23:14 +0000 (UTC)
X-FDA: 85248570708.06.438D2CC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9B86B8000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:23:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VL2sSYmX;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790252592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkdsyrhyA/vNO4RhdAlaZTJ12eqNCfPF/sfVFVUwzLg=;
	b=pSZZ4VXQhbXB3S23IEk9RIQXIcjUCsuIEBayvGJB6Qe8Jdpoc93fNWmZul1jvSKypdmnx1
	bvpFD2yUDvC5kCy5rwLlce7YQ13jT4+yoSRsGRQVftpdz3F15Z3XHVBEN+IGGhBrlgdgv0
	5rVxevakJ5afSk6tPbwg4ohCu82WdPk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790252592;
	b=Soa4NAlaSehc0QRR420gI27DeN9QbqFBPQh9MOcUpjJBgvOzNn9n5A8dJtpGB7/YI6nkVg
	PqT6ZS+O9P+RMmS71QZbexTjhvcmHGl+rED1oSi6sq6owKIbDyjUz9jfNPZPjVxLandgZW
	hcHiyfEvA+aq01vslveOEYredqHReAM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VL2sSYmX;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 500FF152B;
	Thu, 24 Sep 2026 05:23:08 -0700 (PDT)
Received: from [10.57.83.110] (unknown [10.57.83.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C5E13F86C;
	Thu, 24 Sep 2026 05:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790252591; bh=6RiiprozYmDqlvYaiBGVz8TgL+fPnC8hgT90X3WinvY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VL2sSYmXUX7Oe1yYpOSWfGPfVESz/LeVs6qkwp1c7ZID3I/9r7KlqFgNVuLSNzCV9
	 EeeFBxAp7V1h25U7R5kNeEy+s+vXRYgfbFAS4N86NhOR8+pYZ62Ffl8B6WkVroZ3GM
	 9+ukhLWw1BwYdiBWnZvL8p/PGxHli+OEN3B4LpSg=
Message-ID: <a37eb779-b180-450c-8691-8d31b9717f16@arm.com>
Date: Thu, 24 Sep 2026 13:23:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] arm64: use hw_pte_val for HW PTE loads and stores
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
 <20260922-pte0_arm-v2-3-a3f1ddff0a8a@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260922-pte0_arm-v2-3-a3f1ddff0a8a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9B86B8000C
X-Stat-Signature: kde4u1ai3z5xq839sf9qydm8bejcxse5
X-Rspam-User: 
X-HE-Tag: 1790252592-434816
X-HE-Meta: U2FsdGVkX18ZkDnQgFMnTYcr//AoVlfZ5AB7f0Z5YCzAaxvp4mhN/mvOkDU7fBdVV+RHO3SxQ8vt4lPmodJEKK2SkPoFJp/X34H+KvV0RLhYk94pEh5eRsT53SdH8NOumXvQFgvL2XzFRZQOqNjkv/NgFUnNk/TZxwt9ISOPKKxEAgQn9MdIqJC629lnny3ma/6c5BQH9ZEFWzzmAN4zlzHOyfj1bgQWC9Pt2PeQ21exq3Y5HMS2gAfC/Xt9xg889XQuEgnDxtfjTu5MhA0DnTicpgJ3LC29vf5VSgR2qpXHF66bQ84KVHNTUDEc6hz2kVNC+V/Akt1NfsUOmdacSSByi+KPa4BsGZotG827F9A7Kcuq8DKEm48IArylxC0B3C8tiGbhwVw8zwdSOjvWb268MFkm3ORO/RqZKgxGpK9y06+ClMGD/NQ+1xs/beuFsiL2r8WNIXoROMFQ+k+M4OXpjrjfqqWAXr+Q/KMoUnWedSetGh6E3q71Q3DD9EZTXAMhQW8I+XjoRQ6zj6Em79IohFnR1CbQo8zAUYTQgSOAkyXg0xCqQqYgq2bqSB8h+VejsgPyVPIZOEjGsH9HDrjK3RqbU3NPyJ467LONMWjOkw2qslN6DYt98UyHMXL03ErfbQr90uqA6tW/5SLmFEPrIkPJPTMbd/E4mFeW6Z/0Dku8xyehlwV7tKvFZzgIgj4arnmZ6C6Jy2+4eOBo0pT48P9ng25sY/v/Wqy0s1OQ4KEpSqWFxpfb2MK7sZCX+nlTzzhdDFzs4zZ+00z1yqwSTf0GIH9qtftzOWK8IcAxYhjmtgSnTEym/SW8/8SbAaeUfWjjHwSMrlNIwDSP9g9SrXCfxhQLucaj4ET1ZWveVLikvwmkqxotvq7WKSVm/2FF4zctJtSuJIqqrN4kjzIQrWJ5TxfvjSfcBLfYzSCf5953PYckHicBHg0St7CAhU5z0/PcxhN9fYB63Mv
 0s8GJxsk
 /Xe3eORUWfp/ckX25aOXDdn17sILwhnImEzNCn9x/2Y8LQ0v2XJ7wU90welt6f8noiP28xQDzuS2+oQxf1Yof/pUHBx5NinbiEX5M8jffqWboec1RBbUlTDdaTjeSwY9fher66eIkxtMZv5521TuQT9XqvPfGZ3nmyvr2L7rOLhiRU8w/xvM2I0+Y4yEKjOAoE1EYb9uwCsBkER/fTzpowm7Y5qz3zqJuIW2MNWH68NuWJCV/fraefjQAOBksv55rw5H6dOOFU4V3zJk/TZAdpk/q9SxlIqS9Piwur5pOgX02D0xmElRhGoka7lJ8z5EHmfesx5sGXrQJfPz0xMy5tyJm9LF6uaW+lpcOLjAMWJ/5mkuynuJBPggy/ETCDUWT42hXltQsHRg2u8q+4pUMcwXNLzcUF3iyK5Pk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/09/2026 18:31, Muhammad Usama Anjum wrote:
> __ptep_get() returns a SW PTE value, while __set_pte_nosync() accepts
> one. When HW PTE storage uses a distinct hw_pte_t, reading or writing
> *ptep as a pte_t no longer satisfies those interfaces.
> 
> Use hw_pte_val() to expose the pteval_t stored in either the hw_pte_t
> wrapper or its pte_t alias. __set_pte_nosync() writes pte_val(pte) to
> that storage, while __ptep_get() reads it and reconstructs a pte_t with
> __pte().
> 
> This avoids imposing a generic conversion interface between HW and SW
> PTE representations, which may require architecture-specific context
> in the future.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  arch/arm64/include/asm/pgtable.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 4768ec59de555..ce6580ab63128 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -360,7 +360,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
>  
>  static inline void __set_pte_nosync(hw_pte_t *ptep, pte_t pte)
>  {
> -	WRITE_ONCE(*ptep, pte);
> +	WRITE_ONCE(hw_pte_val(*ptep), pte_val(pte));
>  }
>  
>  static inline void __set_pte_complete(pte_t pte)
> @@ -381,7 +381,7 @@ static inline void __set_pte(hw_pte_t *ptep, pte_t pte)
>  
>  static inline pte_t __ptep_get(hw_pte_t *ptep)
>  {
> -	return READ_ONCE(*ptep);
> +	return __pte(READ_ONCE(hw_pte_val(*ptep)));
>  }
>  
>  extern void __sync_icache_dcache(pte_t pteval);
> 


