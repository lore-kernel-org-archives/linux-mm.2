Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76539ECD983
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 15:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6F5C6B0089; Thu,  5 Feb 2026 10:48:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1C6F6B008A; Thu,  5 Feb 2026 10:48:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B506B0092; Thu,  5 Feb 2026 10:48:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2986B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:48:21 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40E60160601
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:48:21 +0000 (UTC)
X-FDA: 84410834802.14.B2EA633
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8C30D140008
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:48:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nu876Qwq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770306499; a=rsa-sha256;
	cv=none;
	b=G0206OQLo3cjj6Zkb+Q0JMIRcUuzRekmfkwdYoE7rluP2SQ0R8zbJBNOGyZF8rqAM41eoD
	aszWpn4WM5G3ptovw+iuae+v83hUy/J+/Jv87CbJoQsSH1CUGgVoxnmfvE7a9ok/jJlY36
	Ra+rbr8ScKruqhHztDOvQtoAbQj+TDU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nu876Qwq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770306499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EXO/yr95BQvFU/kb/2U+bvG/94BK8oDMmoN0GatQvrk=;
	b=KjwsR9BMfuOR0xoRoN5FmXIM4dc9TxcRYcIVjfILdyJqwrEw4wLnEd8/isM9EKPwaJTI8H
	cPV+pcK5ASIa161vtvS3P63HwBCKYUKEDSpCHupDNVJMFyH4JadV3s1uSUDNp8bgtDJ8w+
	OIK55S83wEUSXKOYYfe2KkIwaJHsCMY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E27AA6011F;
	Thu,  5 Feb 2026 15:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64314C4CEF7;
	Thu,  5 Feb 2026 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770306498;
	bh=VWhQr3Z+ccbJrrcfBGfZJZEc2/K4wBqICeXlpi3Prmk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Nu876QwqbfV5qynC7ba1PNcW6kFoCiX0xZVJg94nQ/YAXjYFugrvsueR+JSpe2pae
	 rY0c8JfG9b0JRDqQq4Bdt0GAAGY6BNk/zv8c38yUpeHoXwsdifhSzLinBTFN/V0Els
	 iAKyKePSbqtE23p09QbWhgQhBbyVWbWFndo0F6gE0hqw0b/yi2PG6oWYQANy/Omti8
	 Nc0WwV5+q3NLPGWequp2spO0xxgan0o8bnhbcE4g7FWk60WSOiF76gkPRjnfrnLnF7
	 gYvEmGzE0oL1EF3oVxlAqGw1ynwGrzRJyw+5WNAEZBIGvWd8dEWsgXgor76Ac9oGz/
	 z/Q372FU9uAnA==
Message-ID: <ce4334f8-5e54-4dbf-9be0-059279ef1962@kernel.org>
Date: Thu, 5 Feb 2026 16:48:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
To: Kiryl Shutsemau <kas@kernel.org>, "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20260203174946.1198053-1-prsampat@amd.com>
 <20260203174946.1198053-2-prsampat@amd.com>
 <d07cbb96-ba30-4dcf-ad14-0479d6a989f2@kernel.org>
 <70be936e-e49d-4485-8d1e-416fdf8f40a4@amd.com>
 <aYR0vqwyFPo3EKAi@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYR0vqwyFPo3EKAi@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8C30D140008
X-Stat-Signature: we8hnc5o4d8fsfqx9qrcd48zuwe6etqw
X-HE-Tag: 1770306499-434399
X-HE-Meta: U2FsdGVkX1+Q60w53L/pI2gTkayQvImHPm8Gw5krTbardO+VIr3yz4KqT49SaOSk3xAfS1uF9Q/ZGwYO4NMsZr8A4Y0tMTPOTWva4z1GZ19UlHhKxD9NzXHyc67AaVW1OEerhF0pjoBp8TxUJ44VNMpDLaFMLL/zLWeGa1M1cQgESDsP2g2BsJmubLMEkI3hKEOGTNlQU+0tleOE6HaYvWztet8TLhA6AeVvqto9h00/kdSi9ogxe9TQzZwaFehF/A2BbeGfhZTK3UdIy0iOh+4KR14mUq4DLqEgGOiu2wej1D+ufYXPVzI+9BLlYk46D6aB3C4Uxs6dLvBbT94IlAdGnSCWwFw6h/Lzpl5cYfhM36aW2I0twh89c2Ne74o7JteqJyERtlsmkLqqbiKPF6aDGbYoBeg3XAl3QdEn6areIwoq2HZ8+yzvwwTbUN+Vbhuur41RbGDvO0W2+bx5zf4zYjIYruXHoRZSqJ+jHgSwYyz/bj4v4LqP/BJvrKfjV41ta9Fdj6Q054RlfS5lYDWrMQOHvuZPpFRRfCL2Jrzj9mhWxI1R1iLwbUa/7PsnM9GlU8lIoiPtUkHodBOSOTe3CqHh7Mr3Vh77zW5ui3SRPEluSB5ZI67+4o3DTqT9W8V97BxjhtAIEaRNP7DYEkFIt3fU9rNuOUI0yJdlonDcF7D84Pble1HkWPgwCrRe+jK0yGnZV/zkUyObYX6WHPrYD2BFJ+g/CDN/djTq7dtz/h0cFzqvOwjRMTSpmSKQCLWhZk4JJWq9t3p/GydCoobEC0U2kR2QwgEh3hLd0euOx7wq9iEq4jL9IXKyqra/NYyoOBz8JmrAYtDU8sfVbWs9YUs9YvySR6VGQjHPMfEjOS8rn1OWC995Hm+EXHwJMBSBAsEnhHHNR2HnF2GELFEvfd11mI63QMAN3kbwLodRb4cVHGTLiFygpS43Ta/VAiX5GJL6yc9gITqufe7
 YPXV1UAL
 j2OpxpxN6l348NbPzyPUBZA64l31nz83qgMfJLTG2tWw802qdSlb6iREfp021MVyCPjfgKtW27L/UxxoQo/SxqyxEiPl4Fb3GkU7HFv9PkdIh2aYwk9fJ/ViwGYn9EbrQlrobtcGIwDXKb0iY/lbfSHUw9ne+5/SBVUYiiY5GgIAXcSSsROsXW80q10MSF9LuEjOqDqvCbwPluX6g+KabNT2ZuDoal6pagtTA2/cjoCuQt/6cqGLjsRWmk5a8jCip/vRtc5K18ns0n8y6Wh4XfUw3DBAR3u8WrIZMwNA5gnVMsaXhZe3FV5bg4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 11:48, Kiryl Shutsemau wrote:
> On Wed, Feb 04, 2026 at 09:50:09PM -0600, Pratik R. Sampat wrote:
>>
>>
>> On 2/4/26 2:00 PM, David Hildenbrand (arm) wrote:
>>>
>>> I really hate that accepting (and un-accepting) hotplugged memory is different to accepting ordinary boot memory.
>>>
>>> Is there really no way we can get a reasonable implementation where we just call a generic accept_memory() and it will know what to do?
>>>
>>
>> Sure, that shouldn't be impossible.
>>
>> The only reason I initially kept them separate is because we accept and update
>> the bitmap unconditionally. This mainly applies to cold-plugged memory since
>> their bitmap state after remove shouldn't matter. However, as we are now
>> correctly setting the bits in the hot-remove path we should be fine accepting
>> from the for_each_set_bitrange_from() logic within accept_memory(), I think.
>>
>> Something like so?
>>
>> diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
>> index d11e7836200a..e56adfd382f8 100644
>> --- a/drivers/firmware/efi/unaccepted_memory.c
>> +++ b/drivers/firmware/efi/unaccepted_memory.c
>> @@ -36,6 +36,7 @@ void accept_memory(phys_addr_t start, unsigned long size)
>>          unsigned long range_start, range_end;
>>          struct accept_range range, *entry;
>>          phys_addr_t end = start + size;
>> +       phys_addr_t bitmap_end;
>>          unsigned long flags;
>>          u64 unit_size;
>>
>> @@ -44,6 +45,21 @@ void accept_memory(phys_addr_t start, unsigned long size)
>>                  return;
>>
>>          unit_size = unaccepted->unit_size;
>> +       bitmap_end = unaccepted->phys_base + unaccepted->size * unit_size * BITS_PER_BYTE;
>> +
>> +       /* Memory completely beyond bitmap: hotplug memory, accept unconditionally */
>> +       if (start >= bitmap_end) {
>> +               arch_accept_memory(start, end);
>> +               return;
>> +       }
>> +
>> +       /* Memory partially beyond bitmap */
>> +       if (end > bitmap_end) {
>> +               arch_accept_memory(bitmap_end, end);
>> +               end = bitmap_end;
>> +       }
> 
> You are calling arch_accept_memory() on every memory allocation if the
> memory is not represented in the bitmap. Hard NAK.

In which scenarios would we not have memory represented in the bitmap? 
Guests with <4 GiB? (how does kexec work?) Anything else?

-- 
Cheers,

David

