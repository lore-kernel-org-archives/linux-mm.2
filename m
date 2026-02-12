Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DC17EB48EC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 09:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163D86B0089; Thu, 12 Feb 2026 04:09:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A7B6B008A; Thu, 12 Feb 2026 04:09:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 046EF6B008C; Thu, 12 Feb 2026 04:09:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E64BB6B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:09:09 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8B25160783
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:09:09 +0000 (UTC)
X-FDA: 84435230418.18.6FD98EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 117EF180008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:09:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JL7zXOIf;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770887348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+3mySfOCyr9xxEniwc0oVzeTFE2afaJqeWbH9jB1BI=;
	b=NsRxFhl163yuSVUgvAY4DHvaWAZhvH8BtGAIRpaMxXdzd+GdAnNt9cOJ9+d0Nhnpe7vKyi
	jUHOXf83FrHxfPHloc4VGyDf9Ia5iEjRublOWxOWq0X5iR9wJgpij2HPWRQ0RI9IYMHG8y
	dwkKhT77XeEg0ikV92F4wxVHo9K/u/o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JL7zXOIf;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770887348; a=rsa-sha256;
	cv=none;
	b=U649XyTqRkDTlxyy1QpBkEPpBZuVMy27dc7HXHIP9V7UDAaZRJ5AOtHeHXnTTbBRQuxatS
	i+89hew0bvNQgR6s2ucEbplRCIZlAluC4AQLRjTZoRdiWgFeEkguVe85Y0lrJHuxx5Rktx
	X5zXj1risBstETr/PUU3UyWKukmHinI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 640F260010;
	Thu, 12 Feb 2026 09:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AB9C4CEF7;
	Thu, 12 Feb 2026 09:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770887347;
	bh=l0CiImdGPEMjvntKjVO4vTyF7c5lEReGL3YH8ki5SX4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JL7zXOIfmbtfplPYGRKggj+zQaJ/W4E7I3zHrBBeaXS5iyDfe15uR6ojcLyHoADhz
	 ASVbwGBjjNrJqydFjg/nqkI8DF6MlCTjypxaCqPE7UE7nu4k27rSeN/ckWyOmHYMyW
	 QIz9WT0uvqOIPHZYIXj1uDLn9QueOOng49umF+qfRWJw4gT8oj2WMC5dEJOCAMMUzU
	 OKBluCHgAyknx+26IfmrH/jDAGseIPsZxPQ92lk7POP0Oyd43tN4La6jxIIHfHOk7i
	 VbduYtT6sgmjpfTTRP+yI43QIuisDCWtzpophYjXrV3ZFcfBgWkthdmqpUCbklpfIn
	 cSnnsPmseSZ+g==
Message-ID: <612ea310-699a-4fa4-b007-5b4ab5019eda@kernel.org>
Date: Thu, 12 Feb 2026 10:08:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] mm: cache struct page for empty_zero_page and
 return it from ZERO_PAGE()
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dinh Nguyen
 <dinguyen@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Guo Ren <guoren@kernel.org>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
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
References: <20260211103141.3215197-1-rppt@kernel.org>
 <20260211103141.3215197-5-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260211103141.3215197-5-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 96i59qnggdot4g9qjidhm781cmxsjh59
X-Rspamd-Queue-Id: 117EF180008
X-Rspam-User: 
X-HE-Tag: 1770887347-876074
X-HE-Meta: U2FsdGVkX1+aaT7hpDkfSsT47xNB6adfL5XPGro0ATe2ipvtUsYrk/1l1aAmaXm/UYVFpRdfHIPo2wG2ttGxoZXXt0fwmeQgDi8vRDAp9nF7d4PkkUVBDeQiEx84Lee4C0Dy8Uq07Ho1HGGLn+dPCJoCoGxYZy/SPdQb3X6nkwOah8AWr+D67k3Eb6pZFrSrlxnNBYwZDV9eG522MJqR/IPfVHrDIMEQbmcLnEoI7dYPY1ts4x4RhnsC03lvVqE0h0jCd/swWlK/mML0JAEYAnkgRz06/KC1wvjeWFHLINC+NNZPy11XZPdBVtylzIm/zMZQBr0KBXmKmhERHN0b5xJikDkUE+W2yjY5bJXSSbeKccTeHkRNIu0bA94/UkTzqFN5/QYGFurbUREjPYN/tJa+XCILksER4h3NhQRMvfRsZzOEYKPE1lMKDXTQRjWhxIs4LuNVt99+zoxC8x+01LRBE8DKYX11hmbsiWJTgyDorne2T0bTNeiQ6ZbdU9GVFB5Up/qf6zWjS1UerWLfCkY/tGOHCPEvEa5oi44bIXhV7SlPohbSxwIJiRcJifuHjkJvqSIdzVCsU8iwZp8DJJ3YsWzdz1ppC3VLaLPAOMSiR1SGjfym8z4ADCMEvgswtHCIwg+Y4rphx9IXgcO6cFiZnSVAdwyPBAuFJ4W8EJm8mQM8fOdd7pkGYx5S7HlCk17Ebk5+60HDg0WWj9Wve7nFAfyUogLNkDbwT9FmfanFPAAppahzydqsKFPidUvqwg1/gTdhgdyiLbU+wplKtm30xakjnCWHx1opmCbW3eoHHQEkqgxdGw101lfNjgCn2ZcYwHjiDXpjI6YcXp6Yn+FRpS4LkNRb3Kslyjs9CQAWBVgI94YD9NBfo8paUZKOnvB23YY19sntnE/jXKMCg6yO1r2vluSF9O/oPiAfQlc3/sWE66ewPlg7BWrQwmTnREPGJ5UACg/ujiA/nD+
 mqyM50Cc
 NgjuQq0d28+R9Cyey/u486MbeHbWqVpozavhzuZh5ef7LYfDd2X6cyG/hseJKHexZHCmf38DJiB8AEKKZU4dalyEUp6r71h7reIZAmedNeMsrgjcaHD09/MFT5k67NaEGcfog5oLELycj1WXX3VZlc4eEvRjTA1JAuldt4zrSQrQ48s2oyKRKL+PCZ2WD+Fj4ySwQoxShrEY5tFbfQNq1VA711hxqQjsQsIrVjzlEHo48+5MCpAIF8hOWOZzso/fOPuEgab97AaxROPp9uR0ECT7dzA0gTqWKqiDpw/ZIJ9kQvTTRex1SgTCYyAti9aNZJXuKQV2KKWw5+pGJxPRcXuz/MIPRDsNs7xBK+tLrzs8lNvm6ci5vhB+uzfuwR1+FPB0j8KLGM+/ne2Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 11:31, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> For most architectures every invocation of ZERO_PAGE() does
> virt_to_page(empty_zero_page). But empty_zero_page is in BSS and it is
> enough to get its struct page once at initialization time and then use
> it whenever a zero page should be accessed.
> 
> Add yet another __zero_page variable that will be initialized as
> virt_to_page(empty_zero_page) for most architectures in a weak
> arch_setup_zero_pages() function.
> 
> For architectures that use colored zero pages (MIPS and s390) rename their
> setup_zero_pages() to arch_setup_zero_pages() and make it global rather
> than static.
> 
> For architectures that cannot use virt_to_page() for BSS (arm64 and
> sparc64) add override of arch_setup_zero_pages().
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

