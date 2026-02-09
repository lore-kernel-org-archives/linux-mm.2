Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A158E81BD3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B5C6B009E; Mon,  9 Feb 2026 10:08:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 813536B00A2; Mon,  9 Feb 2026 10:08:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732BE6B00A3; Mon,  9 Feb 2026 10:08:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 616096B009E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:08:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD8D688DAD
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:08:48 +0000 (UTC)
X-FDA: 84425250336.13.59FC6C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 425D640004
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:08:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hHysNRIg;
	spf=pass (imf11.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770649727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPUqV2G4Ach91Ih94Oec+zKCJRL1csnjCWzGDZaM6fc=;
	b=d/dxAsVCCxnF0SjcmHsu1aHJTSoWyv4QgUeDJR1/BqPmWC1qbmUb+bEAEtPloTfwiM8M2w
	NxzHc5hEYwcI2KiYlIWLvlqVktB2IZ37f5xGKfk9Lod4f/7YbGjgB0muztni73sAJWqm9K
	oVH7LMqs7rMygMYZKrPjzuG2kbBPfos=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hHysNRIg;
	spf=pass (imf11.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770649727; a=rsa-sha256;
	cv=none;
	b=GU8PnQS63OhSUY4v54BdIn9uTL0g/HxcF46AZaOADeb06ypsazvDbePX/ebvqnyQD0GtOs
	TKDXQ53w6rtUbwNrolHwaP1v5NWlYY8L5sHXw1aNCBMOpPw/PnQfXVeSP5eusQtGhlmvUW
	f4yLXkgUCkmddKJHFXENi5skduEmNb4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 95B326011E;
	Mon,  9 Feb 2026 15:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E07C116C6;
	Mon,  9 Feb 2026 15:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770649726;
	bh=74hxAhJyO+2eTcl7giR1QDsEixnocOOTI/KCVXUN3oc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hHysNRIgE1EgualKU6aPczQKYfw+TDjGY4OatYFD3fS7TYkGD7WEmgWx3geZeHrfv
	 F1zDDpuaU0nwUv7Ae8xi1oXRUWF9pjvFzqRkh1G83qeRNbE6qwS1sk3FHaw39jYn+r
	 Nk+PQE+5SnWvARHfBa8QAWdgNoL3wy2mlksHsr/SXlqVp8ketneSvd/HphO2nVp9tE
	 BCsZzIL9BLqAHeIK57meLHZ0odqx+OpNBfkHnj8PRzutvNrHUWbq5+TlKgLRN2HHQv
	 huO+HUqNPVA5lqDphasR6vnb5IXL4MN7aVd4+kWDg4t8O5NV52bIkpeW9MtEreTJuG
	 K04aIwqR6xaWg==
Message-ID: <0f15b363-a5e5-4a58-89b0-13b5112772b0@kernel.org>
Date: Mon, 9 Feb 2026 16:08:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: rename my_zero_pfn() to zero_pfn()
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org
References: <20260209144058.2092871-1-rppt@kernel.org>
 <20260209144058.2092871-3-rppt@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260209144058.2092871-3-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 425D640004
X-Stat-Signature: tnd793a5s7raucckooucqsge9sbdcmto
X-Rspam-User: 
X-HE-Tag: 1770649727-535858
X-HE-Meta: U2FsdGVkX18sD2Byw6rGVUoMy372n7Gk0VyQVxop98NMVAvcT3LZxVz2yMgtTYnpQRAeimkm0Ca5oEFinSQQzN56JrcTxeRexw73J1q2aZewLK5lwFzjxlCj8PO132fQB27ErQ1kcP26Jv/QIGdZrLwN8Em65wVnCYWV1P1MP6FIMvBuN5wZXea3RwhuCGuWlozdTOeS0SGbYtpck4Qgnptn9l2PE3ONpltsLFnRlEGSPP5SQKVEoI6vCrvv9qvnhPhxx3m4w9/4h841Kc/jw9PtszT8rko4PYAuxAXdTnwn4tibXBFAxh7sF7S9bVlsB1zzJaLR6cSxQnZcWjYd6ZaewpZnvkl3vlbt9CdS1tpPGfgTYalfI341geq/XWTCD6lR2N2WalU0a/LsTlYz6GFTfmJtrfh9YMuU6+b9fbYqLXDn8gbFJazVK3amlgx74NkjFSXFzNw/0o3hWGKmdT46YJD96dC/Q2HwQQO2xNsJRZKGiIMnbCGH2LrbwfFZ14NpRiY4Ns8DVLEigZjheoDEho4pVI5O7mH6wRJ7O+CTfJBKD5gYfz6uQkNvyMndNRgPpjgGcwHddIda9MxflmWGBD5xe/Ht23k6M06rAfHnYCreq9clvRUW44j88FxigoNVjI+3qh1hTgLXkZgZ9F8DWkupcv2aT7JkQUWuKXNTHIhkdiKeKZ/kmH/W6bZqMhSUgGZfXKh4eV4kNR8aVaLP9C1YyQZHqiM6vB+FqAThwUpmZzexXVXEti+i9mYos2QSISnY08lt91u8oSBcznMzlsY5nJu556B6Wn4yzTDTszOPFmd+JO/n3wCabVIl8x9iWbmQsy8aVVWxrhaqWK+pEMVUwCa6O1N2XbDpZ6dMk3/bPlS59ZaWgmiP9OOdaQR9i8L4OERxpUTtgAGQ9PF9t2GkDtqIC0E0HjFp3Nar+Zrs1aPTf49v7ImPzB374RdGxTnOsSoOcYIYDEn
 rtgc1DhQ
 5jkvutiHHIfy3n52II+C/S7nMYxTlybXhmvRcC0YpTxvQ2WzzCc7KYi/+mkbNZmSQarbIzzE+RfbkKl5va7k4yGXTDCt9B3Xu4sxeI9adMKZ4mt+n+VyE7OhwttUsDIxBTuYxcoE4rg7GIK2kgpZB6Jm/TBrlKQ8rW1TjyG9XBYaktMCBIHAYKbDAcXmQ/suY6b26yvlcUVxhORtuYyLFnq8z/7VKfqKBpp5y8pAyTG+4KKp2QjKF+VefmBuiexjAr5oG2eAVrLgEJIoA7E6pLRSiUZsQaK1RXhVBWcWl0vPmBpOuhQzbeLYU+8C0DSj1Nkx9NsAjIbPO1Rzpnl8onoUF9FunHOR2f6/+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 09/02/2026 à 15:40, Mike Rapoport a écrit :
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> my_zero_pfn() is a silly name.
> 
> Rename zero_pfn variable to zero_page_pfn and my_zero_pfn() function to
> zero_pfn().
> 
> While on it, move extern declarations of zero_page_pfn outside the
> functions that use it and add a comment about what ZERO_PAGE is.

I guess the idea of the extern declaration being inside its only 
external users was to ensure nobody would start using it directly, hence 
bypassing the overloadable helpers.

Should we at least call the variable __zero_page_pfn instead in order to 
warn people that using it directly requires care ?

Christophe


