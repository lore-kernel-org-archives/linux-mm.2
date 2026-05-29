Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CAFBCD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F44B6B0092; Fri, 29 May 2026 10:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A46C6B0093; Fri, 29 May 2026 10:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5940D6B0095; Fri, 29 May 2026 10:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45EEB6B0092
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:43:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 118851C0814
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:43:07 +0000 (UTC)
X-FDA: 84820724814.13.2F6DF0E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id B4D7D18000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:43:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=N9E9N33X;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780065785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Elw36BouPUMp0mEeSrBwT8wHQMoNjB+NX8AH+lO18hw=;
	b=Ijmr2Wvqd3EVMFVV0WgL33zajlgL1FCE5QVg6gyib59rwN29m8fpGoO2zXuWufBmKY6Bfu
	UUuf9PtVAWrTNAIh3iqEVl8XEvXbwoOuP7expo4fmUnaGE1tmwfnFZ9nyNodkMaTIwGzUS
	7KsVQR+2oj3Woon58/vJ2aaR0hJEo/E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=N9E9N33X;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780065785; a=rsa-sha256;
	cv=none;
	b=iCw64ldPbdo2ixtBuDmaeoEUgf06xDbSdu+diX0SHly/hQg08JflDNxYt6/Yk8WungKrOA
	qjQ/BfBAmSZyVQoMGc3uMyR2gjeE00ul+ZCN65mUyScUs/AHcdhJ3qcxeNW8QAEfalNvy7
	DXbN86KxWlIxszQsn0Eu0dboVtKu5n8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A05B202C;
	Fri, 29 May 2026 07:42:58 -0700 (PDT)
Received: from [10.43.20.82] (e126510-lin.lund.arm.com [10.43.20.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5DC23F905;
	Fri, 29 May 2026 07:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780065783; bh=Jl9VQKojRAgBG12zDuJGeC336Uk4pqmCiAHAf+KoXfY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=N9E9N33X8n15HQwC5psjF+tcjK3WjyYarbBnqu3nIcNYoMawZ7mbV1yjWd13q7IJv
	 QTsroWS/j20zBbVb7rfEQI+Aiu3SBMqEK641u2iZkJkWxvlTEL5KjcIxaj6t8ojsHY
	 iT1KU9ZTFJfOcdoib6fau3D3/hY79iVtzbs6xxPI=
Message-ID: <b76b327f-612e-494f-b8d3-44108aa73d2a@arm.com>
Date: Fri, 29 May 2026 16:42:55 +0200
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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <96a8b6b9-71f2-4550-bbbb-fbfa146f4e6a@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d3zwqn36s9em89nd1znyd7ecwfdw3s8b
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B4D7D18000F
X-HE-Tag: 1780065784-971854
X-HE-Meta: U2FsdGVkX1+Jqy/U6i/oKpGI4zD9PgWB7xT8ek5BH3w6VCb5rhBuCiUmFTeIvR+HrmMw/WZBLrKrTFjFseDS2/6oNGyQ8SSBgl93JyKtm2rVel31btSwuI1STyJcu577J3hwMQo0XpYsPnFL4cC7SD4xZfXkahI6Uo0YNf/zUEyHOWj82fZKFZEb/6W1oMa69fyZTLSpCQmpPTBZaiKAZ7eK3Wz1MxzyN5C1xhwQcCpBwrBV2l36MyeUfW+jnGX04gnvmaGE/zNuiA7BDo63Um6XvgLWNjhZuuYj/ScxchrOu2L62QcIRbCE8y4XRFvGAc+r+YsuQfnd86a70ugZJVBoedGd06B481mEBbuH8IhL+LNdR+fi+N8yLbbicc9XkK9mazIidboIQQAeTADuCxz8R4JHdNMfGn7eYkpLuorwzcxqbNsqtQBkRrsB/vnKreGDTqqAijX99OqKlGQ6BR27bFxJaXapmLyi0ttlP5qqBbmBGInEV+0EEK6b+E7jiTCeh6MID6SkwgCdX57UGTOCAU6DuWQ+1zgowdHW5qIpH048qL0T7F/MEE43NWQ3dyZ/LudV+EZFhLgrIh5MTgylRIJxgdBWmeemX+dOqKC4IHGZNuHovftNtc3cuHvkDrFYUwS3VhU8J/mh+LCN3yQhN+TG51zHhwlmQRdaeBQkFUp7ivXSq98ksswErCEetcJMj2iVPD9wTk92+WYx1CiGw0LMumnoKRNCnn0uSp7lxOIYj8ks7MYo0Rnh3eKRBW7kQob5OCTLsXN2BnIAZNQd7hKxboHaQwNyzeUtC9LuByYafs6eV91TalmF8ejymR75JJR/Gb8nhklAFM7OqTRL8eDSYqtbHLlsZDKo/mOi35W84XUl42jxERPhwkH//Y5dKx+RJUM9219NPGI2DjJsb+3a8Dq4ly7tZvfu5spI9oI7915VAsleuxPUMJ83f37lP7LSVWiDrmJRGBi
 CF0B7xNu
 06Sffkss0Dy1g/i9yMe5+S4GsPwRGqafK+M8+tujUPHq/hxgRTqPn+DbDT4X5kwSQVnzpobWd7ZD3SVbJiNclxsJSz90G8NRc5iCh7wDl9ozZZZYRGH9uwPea2eMVDHoMnihfSApPVfkMJ/ptK9qMYG0QErIDKAqJutdgsroUOvYB05BHeJi6Nzn3sHQPW7BPVJ7LY59F0ZBofNKTidSl6itcXOjKEtXpmFwckKxEDDZRpKkdcj4OFi187CxZ8aRpalKNjJYMPZSSqdj/QbcPD/42PKWb5pCh6MIBAWxsWWiwYVGpxcR0zWJdm6fL/hytTxWtbKCwx33zBneh+6Dq3Z5kiMPr3lnE/Fmw0/Sd/LPPhyQvk0Y0Grpy4WF6k6H3F2VQvQBus93eHUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/05/2026 13:19, Ard Biesheuvel wrote:
> On Fri, 29 May 2026, at 10:27, Kevin Brodsky wrote:
>> On 26/05/2026 19:58, Ard Biesheuvel wrote:
>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>
>>> Move the fixmap and kasan page tables out of the BSS section, and place
>>> them at the end of the image, right before the init_pg_dir section where
>>> some of the other statically allocated page tables live.
>>>
>>> These page tables are currently the only data objects in vmlinux that
>>> are meant to be accessed via the kernel image's linear alias, and so
>>> placing them together allows the remainder of the data/bss section to be
>>> remapped read-only or unmapped entirely.
>>>
>>> Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>>> ---
>>>  arch/arm64/include/asm/mmu.h    | 2 ++
>>>  arch/arm64/kernel/vmlinux.lds.S | 8 +++++++-
>>>  arch/arm64/mm/fixmap.c          | 6 +++---
>>>  arch/arm64/mm/kasan_init.c      | 2 +-
>>>  4 files changed, 13 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
>>> index 5e1211c540ab..fb95754f2876 100644
>>> --- a/arch/arm64/include/asm/mmu.h
>>> +++ b/arch/arm64/include/asm/mmu.h
>>> @@ -13,6 +13,8 @@
>>>  
>>>  #ifndef __ASSEMBLER__
>>>  
>>> +#define __pgtbl_bss __section(".pgdir.bss") __aligned(PAGE_SIZE)
>>> +
>>>  #include <linux/refcount.h>
>>>  #include <asm/cpufeature.h>
>>>  
>>> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
>>> index e1ac876200a3..2b0ebfb30c63 100644
>>> --- a/arch/arm64/kernel/vmlinux.lds.S
>>> +++ b/arch/arm64/kernel/vmlinux.lds.S
>>> @@ -349,9 +349,15 @@ SECTIONS
>>>  	_edata = .;
>>>  
>>>  	/* start of zero-init region */
>>> -	BSS_SECTION(SBSS_ALIGN, 0, 0)
>>> +	BSS_SECTION(SBSS_ALIGN, 0, PAGE_SIZE)
>>>  	__pi___bss_start = __bss_start;
>>>  
>>> +	/* fixmap BSS starts here - preceding data/BSS is omitted from the linear map */
>>> +	.pgdir.bss (NOLOAD) : ALIGN(PAGE_SIZE) {
>> Do we actually need the NOLOAD type here?
> Yes, otherwise it is emitted as PROGBITS, resulting in all of BSS to be
> emitted into Image.

That's rather strange, aren't the .pgdir.bss input sections already
NOBITS since __pgtbl_bss is only used on default-initialised globals?
Also AFAIU NOLOAD does not prevent the output section from being emitted
into the ELF file.

- Kevin

