Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A64BACD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E086B02CB; Mon,  1 Jun 2026 04:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165BF6B02CD; Mon,  1 Jun 2026 04:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2D26B02CE; Mon,  1 Jun 2026 04:37:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECF346B02CB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:37:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A188A1622A5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:37:17 +0000 (UTC)
X-FDA: 84830689314.08.242D91F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 724FD4000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:37:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PZxls1oX;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780303036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VvDYhItoRkSY+VDYaOrv7BbQfnd5C296YbD9BNrMnV8=;
	b=1TE+ryWZCw87X+9Mk4phVbBD6C6V+pE4y23KJIKZpPWyXOZdOO5TTd8yKHU6nGyrHidGiz
	14nAs3s2MuRqbt6L/hnPC8c/vlX7t9AY0UW/sKxDxS7XWrtR7gj28tFPMWUnd4sxNq6+xX
	FLC12pI1c5c/LT6aBmEFrGELkoOwINg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PZxls1oX;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780303036; a=rsa-sha256;
	cv=none;
	b=RkQrzb5k6P56jvbYKG8+VoyWjqlbQzLTm6B/A75/SkgvJr1FcmXRf/GoZxR9MEbFKwV369
	f8c3a4w4DRjI0SJ9Hywf+EcBOMgj0gmHjOKpojJvj1X0gICc+ywNUbVzrfDlRrhDu1O592
	p4dhXAEpU+AbAW+uADHPWjsrTE8VcKg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6BEF1E8D;
	Mon,  1 Jun 2026 01:37:07 -0700 (PDT)
Received: from [10.57.94.8] (unknown [10.57.94.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 367EE3F93E;
	Mon,  1 Jun 2026 01:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780303032; bh=KhZVl+Vwqx0OaCH6S7jXIByk6u8k8lh7Uhiuy+3SVi0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PZxls1oXIsr6hApf9XohwV3WTI1Qo/Er1dviSU6itCMJmAKDxMZHODtjuGAfErgJl
	 6867qR2HsryNZcylx+G0a/AX10BCLvlvPK4pBvuCBYe/sz6hhDG0C2A1TIs2eBczWC
	 E1gn7G1PE54lFFInYxUKOqbSvwpx/gKLHzFd0Yb4=
Message-ID: <69488547-cf2a-4aa0-bca7-0cb65aa01914@arm.com>
Date: Mon, 1 Jun 2026 10:37:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/15] arm64: Move fixmap and kasan page tables to end
 of kernel image
To: Ard Biesheuvel <ardb@kernel.org>, Ard Biesheuvel <ardb+git@google.com>,
 linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
References: <20260526175846.2694125-17-ardb+git@google.com>
 <20260526175846.2694125-26-ardb+git@google.com>
 <2a6f9f05-ac57-4ef8-9328-74cc8ccfea16@arm.com>
 <96a8b6b9-71f2-4550-bbbb-fbfa146f4e6a@app.fastmail.com>
 <b76b327f-612e-494f-b8d3-44108aa73d2a@arm.com>
 <feab72b8-2961-4145-ac5c-80e820bf1ce9@app.fastmail.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <feab72b8-2961-4145-ac5c-80e820bf1ce9@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9joobajwjgidbfdgz9ruf45oryat6q4u
X-Rspamd-Queue-Id: 724FD4000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780303035-803115
X-HE-Meta: U2FsdGVkX1/X/Aq1gdC/S6DczcEaOZTV9BPX/2TiOENcq+6qkVbGOoae1iCKc7nVVUdApgG65FV086SNtK3gYS+b3JdtrO8mURSZoM14MUS2FvZGOeb9DfrfEUeYcvnADb+kML+Hvy7/7c+d0qkPvMX59+dKEvc0NNIle7BoBh+z2WdlFxh9eVQDh4E/k/rZjMdHC9HuBbqPod9+VG6cJh/xdNlt0lvn/CzcKFHkCREnlbn47u9qXidsY4gJZxZM0zivOe7QH051WCTDLEx7zpaT0qVqEpsUwZmP7yZI1BDjSsMafFmHam9OvL3bP7soIAkMb1LoCBGPulvdoNlHtWF4s1WYE7K1350lzQvVTx88ZD+qZPkzVfzddM7ZVdUamsgfWPd6MSOG+w/SQ0kTeGTzrhUd02dv2CmPN7T/Bi4QrleJKlugrEI5zGq1nKXoUAVwwuxvMUW/+uRXCDSy5R8HJm/e2rj6Ovn54p2ieXPNhICL2Caqb469MaM+m10oupIb1bTDiL7wYZ9sx1s3KlFX7lZoPx2xNW4l4My5oAFJWxW5FxbUiA86doiIP8NWaavkaPcLjoarSSTF8wkey4snqx9xru1qFGgrCkLjHZp0eTjKeRwsu/aeiXIkeiL4Pxl98LnBnOP9BlxyWFS3ONndrvWi+rcE9nuZ2oJM5pxuhK0E0Wiz4iHvj2lrXzMSx0jwmoZIAyC4mMwY4+fNZdKoPgdQk6RWZ4uwu7VzvzZqGAg8KhZvNeeOBqA/AiXvsLGrG283DAMlX0kgDnyNSU0+XYTZFecl5CjqXgYeZcjwmFjVY41P0o8e71O8TKNiBWvur4i9OUuegWffN1zHUhvqHNydTsssrtnXFXxpLtjsShR92aa+LuFZnM5wCPdm8ZMFtvS22zsFEbXj54JGjmGV7rCXJzPcxiFoq/xLsHe4xYgGDJVbjWTMc4TTunU0rFxbaqRKHBxZNrhBtoU
 n1BtuQ9K
 P9OFRT17NDBnpzvzR27Y77pLnzyrNewMDmrduF8fRlHbZ/yw8A6s8VYAgVtfez/3bKH4B2PCKdKmPon0Xt4t2qNpok1TfT9wpWJzfwoMzZJ73HFSa1+k2MsctTvS3DnZ52sxLt17X5J1PTguZKZNXPvk53tsgGJez4txBKmonN3PZ8vrUpgVgZyY7kbxPeVKxH5+z+Hk64JJtkGEmU0wF672AmNAD/+OxDbFthqOFZPVoq4hZy9vzOaKNIB/ijWZIVmymjqkxF3jl6hn3LJP97QL0hORwpkNzQSArJHdp+FaOdS04wphT+jtC4jHZyVuOloI62wQ9pcBq7WE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/05/2026 16:47, Ard Biesheuvel wrote:
>>>>> +	/* fixmap BSS starts here - preceding data/BSS is omitted from the linear map */
>>>>> +	.pgdir.bss (NOLOAD) : ALIGN(PAGE_SIZE) {
>>>> Do we actually need the NOLOAD type here?
>>> Yes, otherwise it is emitted as PROGBITS, resulting in all of BSS to be
>>> emitted into Image.
>> That's rather strange, aren't the .pgdir.bss input sections already
>> NOBITS since __pgtbl_bss is only used on default-initialised globals?
> Not sure why, but the section was PROGBITS not NOBITS before I added the (NOLOAD)

I've had a closer look into this. Similar sections in other
architectures are all named .bss..<something>. If I rename this section
to .bss..pgdir, then indeed the compiler does emit an object file with
that section marked NOBITS:

$ readelf -e out/arch/arm64/mm/fixmap.o | grep bss
  [ 4] .bss              NOBITS          0000000000000000 0002ac 000000
00  WA  0   0  1
  [18] .bss..pgdir       NOBITS          0000000000000000 000750 005000
00  WA  0   0 4096

And then the linker does the right thing without having to use NOLOAD.

I was concerned that .bss..pgdir might get caught by BSS_SECTION(), but
it seems that the double dots are meant to prevent exactly that.

- Kevin

