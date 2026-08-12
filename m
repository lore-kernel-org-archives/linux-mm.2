Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 627BBC5CFEB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30ADA6B015C; Wed, 12 Aug 2026 07:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BC006B015D; Wed, 12 Aug 2026 07:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA7E6B015E; Wed, 12 Aug 2026 07:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAC986B015C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:21:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2CD640369
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:21:38 +0000 (UTC)
X-FDA: 85092377076.27.6EDACBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2A39A40002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:21:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BmXhqXpH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786533697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+TveDZHhaOZxOI6aHVBWLYlU17AabpcT5JTtlV96+eA=;
	b=QIkRqO46KPtIs8ryELqcPA8bcq5rxyS3aGhoKt+acHBmWHNEkSzxhr/V8tOEiKKBcP7Oqd
	+FVvPQ4jC0LwRycClr/I+P1Rdph0RwRUkUXkZmCZ2r5A16OuHrxlf+ZWnV8g0IVsZp4MIF
	oFPT9ia4MA3PUVUVKS7UI87T4L0L3Gk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BmXhqXpH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786533697;
	b=aJm+fJw6Ew407gzq/qi5PfFcOC83o/sCIhXVlRu7vKBjIXKqyoETQ68OKu/uhtzPoO/MCh
	rXP8iOLkQ+MCjru/jolGMjnciTnZ/950PnDKwC65tlLd2ItAX+pa4/SFl/JrLuyciRSTo0
	AqUrI0ZHeoiRwtuUVOY79tcpBYWaCOA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2E4E600E2;
	Wed, 12 Aug 2026 11:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D901F000E9;
	Wed, 12 Aug 2026 11:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786533696;
	bh=+TveDZHhaOZxOI6aHVBWLYlU17AabpcT5JTtlV96+eA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BmXhqXpH52I2iHHZnRDP6XIleIkxYUTARJtDZTfgN3ma29eqOPVpovsyhj8t0O5tm
	 eskDXlbDcyfaWVlhD27C21PFw4XwN18QhZN7khcNfE8MEjYA43gycEqOEYgt1Ciu3g
	 5xGg5iozvCuX6IHRI+TfhTpZ4Cg4BReUlUZhENEqeTN7Jw/GwUinLa0UEsBjUHBdoE
	 CfvBxbe9NOkQ/YfJoq1NnMsw79f0fDyRytMhym/hkYvQT3AFi59a7w9AEL4FKhh2sv
	 n952ZvqgZiWGfwjDPVnHtQDOg8lvSVBcbyhNcfKb/MSsXPp4eOmk+Aj6UAJip9v/GY
	 oYYIElK2eTBFA==
Message-ID: <94b52871-9cfc-42d6-b30f-545b722e71a0@kernel.org>
Date: Wed, 12 Aug 2026 13:21:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 4/6] sh/mm: Stop using [p4d|pud|pmd]_ERROR()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
 <20260811042119.3652929-5-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811042119.3652929-5-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2A39A40002
X-Stat-Signature: zgj8s5nyhr39w1j7rzaquyi3e6rmfnu1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786533697-881425
X-HE-Meta: U2FsdGVkX1+bBil/kxZujt7LrZqPzzZ38ccA4DOHKImoJ1CclafoDDW/hQeKBhF1Z9+ZaXk421l1QoghJpZX365/2ZuMWmTPG3dvbTSFq+3NvEKW7jxYznU1DA+LtZ2ru5swe9Oc5aGSTWxhsU4FYasgdEig2WqJisyIhjKykA2HNCmUk2CUrk/Acgo3R6926fuylTQkuGQGY3VdT9sIUgiSOKeNQyB14hviv5ij4QXBpRpz4HkbTWmDNtD/RTzvFFAGduGQokIfqiuhTz+BWlU4mp8q/on6F33wdSXCar+0q4TxlJtOBxFKN6yn7BXcTvSKWEQQFiN4O4uRRD0l/tTiM8hgjmtA3g/hPgNcpcIDKKbubafwdu2/cW3uXSXcBWlgDJci31g09rwTOPlWp3h45Kkaw7EaWDLO0XCyRoMEo1U2nujJm5Jb56c+9OR9Q9qvmQGfRNKiMO3OBhth75t3KX2Cl038SmB/+XDyeJz4Ej36hO+3mxCi+N9vKROk+BmxDem1rTazXfUW72m2Xt1CKkr/GHgb/mMsBprihVB+aIh5kgvz3qARia4uMYjYy5zDiPaRDuMeb3Aft/3gRDXf9tuHeKyPj9eq/NN2ZsWxq8JTDMmtm8hpu3MXpxGcotnPndlnLXVJwVF6O86/cDaE8Y0RHFPe9uOsgmB2mwY7h1kq0vciaUV0NQ9Y4/1UybT/1zrswnp7cGHnHDlys/lt7+eKuXr0aRXs3Cs1HxjgUKUOCUYz5QbErClJvFQYLGsH4sWajxEunQZwoQ1BwX5DQzwrkI5KwKNTZJEq7WHzb39KUF2R6/JuD+7z1lJWuFcU1MhUWq0ksgM1B+x4Y53lZcUUgqcr0AGJjkjGKn/8CkmOugIE/EY873DpLtQlDPyMNsuz6uuybNGdSlihFojP2MtHy+AuK02blJuXMWv4XPVEWdfU8XrjCaNuLtx5W4vxPV9SbP5g9x41lTa
 GsUSPPIx
 io7/dnts3fIamT+8ffgLc+sVYnxjOlw4dicTxNerik0KqSXm+7TQ7PMniRJzi5zh0DUTr+plH+sw8RnUo8n1UvENbMTL2YelrMFfjzASH9gIc9gD8shr6ipO0kBCEe8KchufEzbBmtphzEGwHrfpQOAB4EnfWFXSYasPQdfxan9IFI+0p01LHtabehXASwSW7fbUPjmpmyYH/PRntwDuRwVpJwvR8aOynnmT59yfW/DrkeWMx0uymBhfzPs1qtHxijPbooat4/wVpOMdpOMgW5uyu83auiOUnb6qjFUO12GttrgISgLt2f6xaSGl83XG5V4WEy92yVzPrMMDEmXpSBelkkXFuPYcjwVfz8EIf2LcPNP8tyoSVtSK/CRzE9CCpxSR9YBaa1ZJZV4GONrG0w86w5BBcO1Tt/DiRw8wJq+cWw0P4z8LYKkuXKksdg4BRk75GExjABFGvdJrmU/Hnh16VGqCzsz0CBtFCcAFnC7OqqApNP/gpnFyjVkLo5kBPqrnq9LJAzTkc/84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 06:21, Anshuman Khandual wrote:
> Stop using [p4d|pud|pmd]_ERROR() in __get_pte_phys() as the pgtable entries
> are known to be NULL and hence could not really be accessed.
> 
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/sh/mm/init.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
> index b3c7fd84ceb4..0bb8555568a4 100644
> --- a/arch/sh/mm/init.c
> +++ b/arch/sh/mm/init.c
> @@ -58,22 +58,16 @@ static pte_t *__get_pte_phys(unsigned long addr)
>  	}
>  
>  	p4d = p4d_alloc(NULL, pgd, addr);
> -	if (unlikely(!p4d)) {
> -		p4d_ERROR(*p4d);
> +	if (unlikely(!p4d))
>  		return NULL;
> -	}
>  
>  	pud = pud_alloc(NULL, p4d, addr);
> -	if (unlikely(!pud)) {
> -		pud_ERROR(*pud);
> +	if (unlikely(!pud))
>  		return NULL;
> -	}
>  
>  	pmd = pmd_alloc(NULL, pud, addr);
> -	if (unlikely(!pmd)) {
> -		pmd_ERROR(*pmd);
> +	if (unlikely(!pmd))
>  		return NULL;
> -	}
>  
>  	return pte_offset_kernel(pmd, addr);
>  }

Do we want to print an error like "allocating p4d table failed"?

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

