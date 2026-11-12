Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF5A3606A335
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qhR8siKF
Received: by kanga.kvack.org (Postfix)
	id B16D96B05B3; Thu, 12 Nov 2026 08:16:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7466B05B5; Thu, 12 Nov 2026 08:16:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B7166B05BB; Thu, 12 Nov 2026 08:16:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 711F96B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:16:47 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2B55A81C5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:16:46 +0000 (UTC)
X-FDA: 85426516812.18.0710225
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 055E6180008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:16:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qhR8siKF;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794489405;
	b=JDmCpn19tkyI0Oqx+P29PupiUQlvfhv6RZR6jGBBxX7wo7vFtYHOG6awXqxFgGrpzBKzld
	iBw3cPNTyauem96jc+OBnofm9CzrrqGpWXZzT17+jLG9IBG+wVQFHYFVqAA4XOb3XhI8RB
	0rr/RNc5gRwxvTyAWb3gWHvf4V2VIK8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qhR8siKF;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794489405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTBvg55fBuWD5tQeyFYmzV7yA87nWgeKUd2BDomzFCs=;
	b=5qQDi3km++pxx01ufSyN9WOmBKR8rwvaoUtKYmVVwGMqBlIxOwUH03S8FhGQtA1KNmf4Fu
	rI3i9Usbc8I4N153Vjazoxkck72xERc9Nv+axFYFQzp9qnKpo1amOWEgqhPPJut35J4pYI
	QXssxbCRsAc6IXsJpvpUQ4J7yy8Jl0M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25CFD1477;
	Thu, 12 Nov 2026 05:16:40 -0800 (PST)
Received: from [10.57.59.183] (unknown [10.57.59.183])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 008353F632;
	Thu, 12 Nov 2026 05:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794489403; bh=wTBvg55fBuWD5tQeyFYmzV7yA87nWgeKUd2BDomzFCs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qhR8siKF3uHjUA/hWmh1H8py+Ns7uPCZYEMtvUSIeYR5dIH30FjHUDT4bD49VvDcb
	 I5k/ohiMpYz3LO+MsI+K1M42BEms0asveRWV7ANV92sDMfAMZoQct9bN5pPyWH2lLi
	 +OTp7Uve9C+YFkm6cp8nZIyyLv2wUgeasDHv3a7E=
Message-ID: <9148043e-580c-42e5-a93f-3a177f8d75df@arm.com>
Date: Thu, 12 Nov 2026 14:16:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v10 07/22] arm64: Initialize POR_EL1 register on
 cpu_resume()
To: Mark Brown <broonie@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-hardening@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-7-aa6c4d9603bc@arm.com>
 <be361be8-c5ad-4ff7-a6db-7b0815bfe1d0@sirena.org.uk>
 <avNH_AdvK9AqvfF7@e129823.arm.com>
 <7b92f7c8-1543-447e-8ef3-aba608141699@arm.com>
 <6808f3a6-1c12-4cb2-a109-30704d812490@sirena.org.uk>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <6808f3a6-1c12-4cb2-a109-30704d812490@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: swgwenbjxwiohe3moya85i3b7bhwgc35
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 055E6180008
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794489404-44400
X-HE-Meta: U2FsdGVkX19pgAr+FgSNyAHn7Tiv0RR7q3oFfnad7srKmxZDX2Gtxo9fNx8frk4ygkDlKmtFUW0KXK63AbdQ6Hgzt1pzbruBRyXHxeoOxUr5xClnAsntyQuW+xM9E7ukblljKkjg5dEHANPaK1+62Awqwr2zHczP+rV7RM6PloP5VB+w7sRz4cl4ZJ/Ub0vKXfnXsOUAeisNTta8jm9OfpTTYMwjvQXZE0bzYbc68GsOVBBTg64d4GWbdTwU39fDcQ9oGhCm81mM99hpY1nfpZNtGwj/Fu4Y9Bdg/mAKVaFoJ3DtSn7GMas3qF/VI/mWWiTsOaQ+dwtNreFc2omL59HthyytCLgoVhTmtdSBewmFkmjH0a4ivcSQT2ziT3Eh0pBvn6DMPbiJb6EVZpA67ZCmjMWtZkHKETgV0yB6aKryTyFmhXb93jFUlPGqRDfzWwuPvWaxwFDvS5yBLUxIc0e9QX3P/Y3JrhwLIIxoSgqUfbwpb2PuV3aRz+zmw86yo62tSmQbus4TZRDOnJtCcT3daawBVofluhVg6vJBRwgLVgnoaNEFdkl1vUxtw9KvwviKt7wG1pAq8DTgpgckqr6TR+2NiTg+D71Hc749aX9QDIMch6tlvDWIKNE40/dJ7L5WxqgpQP5VK8R6eDTj09/YuA8+CGTOqlw2ctfxYB7SZEP+NQbEWthxq8vhWvrpn+qK7EvK42WEqkW77c+EQsAul7s+23UkXneiIPJR0m2G0rjyN7FXrZAzGZ+0J6kahSBCd6bZnPXzqu1NvmiMCYhWoFv8hK3bRc/9bAL2iui7EZ+67+gTHwZ/tgVouYfHMsY3ZQfy9rb0Wp7mgyqdYecQ6RUeZduGhVTYY5BYJpBEkBL2cTvb9FriZtcdu5u9uMOhEkn2uHZJFgG87a+5+HkP8i3q1/NZW4YaKmPuCe9NAv3JtHQXkqvr+e0PzcIQYckK7RoU002yQCSl2OQ
 CZunWzBI
 pcJMuSbkQTz1+YqI39h+ccn2FE+7Z7JZoSAgh60e9X+Q8QpAbfAZ92its9zsRbSEl/9QaxAoHhwlJ05hPU7xzv8MZ7qugzGPtLDgXiWUFZHfirs1fgYC9GuVufHwvCfwA5Y00Xa7FldM2/m10z41p14s8F6VrZikx9XPcNO5+zsUVGxwTPQ8EHd15skDamWqT/22S/Kcx2WwHGOcBiUZ1I9Rc0ilfq7bpFXUYMQhX8qKsU8kYnZDdvtSzN09Yh01ok/9lSg1vCk4s0HJ+BnmE+VbAL+Tb6rzSttlgW+FeUSwkq4gWY1UUX6D0eLaAvK+kfFzgK1+6MkNT7gcIlsNZcUVVmnx8Jn2Tq2garKC3uqhQZxSA8JTn0+M15076GXbO0/aUAwzJ+pr2Oxo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 12/11/2026 14:02, Mark Brown wrote:
>> Agreed (as Sashiko reported as well). Presumably that means we also need
>> an ISB after writing to POR_EL1 in cpu_enable_poe(), as that's basically
>> the same situation.
> Possibly just have one before writing TCR2_EL1 rather than for each of
> the indvididual features, that's harder to mess up?

cpu_enable_poe() directly writes to TCR2_EL1 so surely the extra ISB has
to be there (between writing to POR_EL1 and writing to TCR2_EL1)?

In _cpu_resume for now I'd keep the ISB directly after writing to
POR_EL1, as I'm not sure the ordering is needed for anything but POE and
it seems easier to follow with the ISB right after POR_EL1.

- Kevin

