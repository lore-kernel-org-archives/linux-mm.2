Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01045CA5FC1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 09:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF2DC6B008A; Wed, 30 Sep 2026 05:54:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECB936B008C; Wed, 30 Sep 2026 05:54:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0C46B0092; Wed, 30 Sep 2026 05:54:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B63536B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:54:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22499806FF
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:54:46 +0000 (UTC)
X-FDA: 85269969372.20.0A0FE64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3F252180003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:54:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HTJ1Jzyx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790762084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgAe69WBQUho7eW0Z9ZwHqmj/zzAYdafzSIWlChsgyA=;
	b=4I36N5zsV/Pji62lRVcd3DjS/ZcLZ3Td8TwItpkxuu+R2rDQzGu1rVsD1lKSLpkT2u3ilJ
	D8u/Cb8QbH/XNDZ3XMCHWiGiiHY0XbYUEg0YX2JUUkldCn4vyM3wpNCNajtI09ZKXCnFsB
	IAiB9gRIW9Xr2dJNoaOYbBziykIPqgE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HTJ1Jzyx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790762084;
	b=J6eBZPkaxl1kanmFwXl5P7JWkrjyIRLWzE/HQaGJcUXB0ZqEhu94cfDWIajUbq8FQIlcWf
	BTe3ZKsUH/wWc8T0Ga2NZPAGZ6nFu/uiNt8S1SLzb9TCJH/92rB9pedYjUgmgyciEWHO54
	vpbK4C5z0v+dcDBQV2bu8zEWywnLHUA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67A15404E9;
	Wed, 30 Sep 2026 09:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9411F000FF;
	Wed, 30 Sep 2026 09:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790762083;
	bh=bgAe69WBQUho7eW0Z9ZwHqmj/zzAYdafzSIWlChsgyA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HTJ1Jzyxuo8O6yYFaHVRMy6wXOJ3yZrG1QxUp4E1RF4p1RQmp9lWKhOBUWj0Lrozl
	 ZvQaCyyz2V6InkoUweFn3NrEa0MhlhzpsV62uMSHpj4oJAQzDVaC0K9V4i22Q06IPq
	 AoCvNt3NwKOiToc2kwX+0rzGm8fdKGQhF28shnaMSeJjvIp5Yhzj7+chcQH0KFwcdG
	 TDsfafBw75WWeWWZ7by230qBq6/KLl5qxHvB2qs4XCd1foKQM6QJ7ThFQKc6BCsuS9
	 u8EEarsAehNLpbhfk+DnYHCXVAZxPHYCyFsQooFcvGX50HzaJno1MxKe2jJ/mCKKQo
	 3lCez0PmUlDYg==
Message-ID: <a0b8aee4-de11-437f-8d12-34b8a97eb6e9@kernel.org>
Date: Wed, 30 Sep 2026 11:54:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] arch, mm: promote DEBUG_WX to CHECK_WX
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mark Rutland <mark.rutland@arm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ritesh Harjani <ritesh.list@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Shrikanth Hegde
 <sshegde@linux.ibm.com>, Suren Baghdasaryan <surenb@google.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org
References: <20260926-direct-map-verify-wx-v2-1-efcd64a6b74a@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260926-direct-map-verify-wx-v2-1-efcd64a6b74a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3F252180003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 3sn3cs7mgodty9htnd9abygdcm1ume9y
X-HE-Tag: 1790762084-868877
X-HE-Meta: U2FsdGVkX1+KOqUclZBn/tHatBM2BL5w+CO3eOIXAPuq8iMKUsOREEdnF5mxh41rLJ/iOZY3HloZ2wkZUJnbkmE5BzHuACZf5warNYZ7njnpR4G1R6VRPARbzx1lGuk0m1t/1yD2TBhxp6C0PAYiAze7hdFZaAGvDpSVXWCswNivKo/SLu1iglRr8r1N1Q1dA5bNW3GXXFnTok5SJYPtoLpCWk4ieb9rNBzwI3vqFdaEb7+BiyglV8Nz9BfT7WxROcEyHyj9AbOjioRnKG8nUc8hU3k4kQ/zClz+FwDRW1r+NhcHCCxeFBhGD2e7FDGptmZda40d15eLz8Nk030YwwP8hhRNbzSHwDupiqWbFXTfCW174iG/NLu/4tOJ+r6sQRcrQdZqLQVa+4GdOFwcL17sAWgIe1vPgD8BKf4xI2JjPfkAgJs+oMJVfUsFkpBOIrlTmBcggJfnVRU8p/oCR5V205B5jbna8sfu/j1TL7yYkfWIjG5FKib6XZ2LWEwMzMD8h2D3cssSKi9lAstt3jreZ2C60W2IKYp2aAuSFpt7n5tFlZOvVJPS19ALXAocmFFIsqvN4wcoaD5MzYbuNTsao2fhXdBujq0NySoH09x/tXENPQpRTkUSbnVryVPpZ7rnTIDYgTpv7XzKZ2J0F4nTX1XlIgSxNBdrbo0UDZ++Y12W01yKBlX1ResbPQx8wuhhk3mRXuniAcWhJx69iwP0cSJIeuaAe8NARpo1NVWZpQJsnr2FjeESYygT1vLD/5jejZ2Wppw5MOlhIXR05IVvqaM1V8uKRnc+UOv/jLH9aWmFO8+zvK+PEGpm11yCIfChr0OgzIus/vQyIwr7KpZEDoszrld0hWFzLeCNSepWop+QXjtXPDE57fd+IH1Cimg6lsVxlobJx0W8lijcP362FlDl7gzPG+gFlyxtnMQW9rJNgripOfillJeK6dZKDscZfeFQ8FUQhVWJvV/
 gw5FLAIK
 btZ7qkH5oayiYT4Jap1JqRNZbZHH4zIQWAttvcjCQrE8+qTpzcpSK2HIq2zS0/VZho1ohJqf7Hykz3SD0vsWa97NTe+VGRv7GzQJAzliS46IruIbZfJcywZv9oqtaLJIMDmJ92JIu3uhSfnmHCgvjnLAfTUV6B+3j2goe12DtqTAtjUg4TM6RirOnpJgJrZrWzvmiy11I8vcdw3El16790mCGkG/qmi4vVp6KTzkmNwKAuMv/PUxDHWeEb3QPVbtqKuyRVo1VkLZpmx+ZEo5aqUslxyxa+LSH3NGyuVKqvWreGXOyU6/1pUgUor6Ex2yw/JaRyC2XeNmHOvESiv14oXRhNenEiocw5IaC8JOHfYCDPFOPb2QnE6myrm47dGDQZsTRiT7jo/a3QIgNoreTZ/71prriWXkTLD/trN0As1cNEDQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/26 11:29, Mike Rapoport (Microsoft) wrote:
> Verification that the kernel does not have writable + executable
> mappings is about detecting security risks rather than a pure debug
> feature.
> 
> Major distribution configurations enable it in their kernels as well as
> defconfigs of most architectures that have ARCH_HAS_DEBUG_WX.
> 
> Rename relevant generic configuration options to use CHECK_WX and move
> their definitions from mm/Kconfig.debug to mm/Kconfig.
> 
> Rename *debug_checkwx() funcitons and macros to *pgtable_checkwx().
> 
> For arm that does not widely enable it, only rename its variants of the
> config options.
> 
> Enabling CHECK_WX adds a few kilobytes to the kernel binary and while
> the added size can be slightly reduced with churny updates of
> architecture implementations of ptdump, the core functionality takes
> most of the added size. It cannot be moved to .init.text because the
> verification has to happen after init sections are freed.
> 
> With this, make generic CHECK_WX default to STRICT_KERNEL_RWX while
> still leaving users targeting small kernels the possibility to opt-out.
> 
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

