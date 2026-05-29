Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B73E5CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E111D6B0005; Fri, 29 May 2026 04:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2326B0088; Fri, 29 May 2026 04:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB17D6B008A; Fri, 29 May 2026 04:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAC6F6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:35:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 523B1C3553
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:35:20 +0000 (UTC)
X-FDA: 84819798000.05.4B71C9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 581E11A000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:35:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHiWA6Jm;
	spf=pass (imf19.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780043718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pb8hRl9aeM4TyobxS9yOnAKjXiRrSGZc3kFIWxU6xN8=;
	b=2ihMH0tkoo1Y3T/MouJDyrPjAr7Se8FlypwzVX2QhNdtMpoIqjpTmoOIxkXsSUAAuvMDkm
	cJYLnxuvkkFJszmNBsdsMspx4sRP0qBmxPjBCq8UKIhQ0zqfzLsl1Ra4Hev7y7a5gkUdAf
	NRNCZHuAjvXOUk7oT6CIesDD69vasWQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHiWA6Jm;
	spf=pass (imf19.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780043718; a=rsa-sha256;
	cv=none;
	b=m9S8eyW//PqMCCP/k9qF/boJcIj4GjO9YMNOQPSJZcGENmbLj0dRSo5W11B2eejG1vJxfp
	/B6F9eg17KMuf0O13SL1g93uLrsMl8HpNtREHiqBDfQGxIvZRE05VEfiQu43muPsYmjkcf
	btiv33rtx3AvdeIjmxXhSuN7WKYWqes=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A645860594;
	Fri, 29 May 2026 08:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBAF1F00893;
	Fri, 29 May 2026 08:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780043717;
	bh=pb8hRl9aeM4TyobxS9yOnAKjXiRrSGZc3kFIWxU6xN8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=eHiWA6JmmhYrHhKFbvxiZTW2xJNbosNU9RTUq54HJ9qxC8j3R64ua2CiUQZSUqrGR
	 E4C4UAZoPRV+CsP2askx3paA4itfF9NPWE1l5jJvDfGPFPkEGz3bxaowNb98jVhwYd
	 sIzZwjUPwcgBigvncsDX4VRpDg0Tb6nhoOntqVSjMBnwzxSdSiLFK6FJIf15NU1oue
	 2e06gPFOVDKImLo61ENrTCqi0Vur53PFnTt+HyeKotfWsgoxzzM/t3v5FSFnxqJZ1x
	 5vkt06vWKXTJUvw6Aip6rqRQinfTHQ/h0Ol1LDsXkJDGByoWsG4GKZzw2U9VgRPNk4
	 X+1bHuoen9KnQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id BFDBEF40071;
	Fri, 29 May 2026 04:35:15 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Fri, 29 May 2026 04:35:15 -0400
X-ME-Sender: <xms:w08ZakpiqlRdTFy9M8HRTgnxe37LK5skX4bkamkDB8ZQY6J_BXof0g>
    <xme:w08ZalcpocRSklO6G3o4eP1S-C7Au03jLquVqT3dZ5DscMRpjm2bm4i_76NXPzOYq
    8m4qP5eSsmGjQA1h8D2q0tixCicp_xLKZTHbImZhneyxQr7DFoP86w>
X-ME-Proxy-Cause: dmFkZTEQkc69D4Zmkpn7XYQpl901Rkrrlg7dZ91u0M7kyZwKWzkp8pPC3OUm3GoeIl8ZEa
    YfWBmvqFv7f873bL+J6awk4ALyVkWsyPN8hSWHWjLy526VQi+F7vLkb0Se4dJsA0+9AZhC
    mbOE8Rse92D/zIxqfxjhk+KGvVsWFXzvhiWzaNvH5HcjXMs97MFy2Ahat6AJXkgvUokmXr
    /Gu6KLlQhkZMYy3mWkvL+fDWGnmRPKdBsaBtjexICmnhLEzeFMUm63gl1KF4NntnTnrGCZ
    5uP9Ng/N2EwYovqYva2VTXsDVpCTseypQ4wv1F7Roh5FxvMHGn/c9ZuTyDPXb5H5cYd9OF
    ouUVMrrrUvOBF+JwFSgKrNDT1DaZWGqGqIruNwSE/opEQSzIQ9zrw0wSLqFYazgl+kiQ2Y
    sOA6HQbJZ1rsrjuuE8457H8E9j+gYAMNvf2x/vyO3yPcSYsc6/o4Qv5NP528gMTHdvJaAm
    67pp6LKTMNBnVUl5+cMWaa7+cdgW/ehxUAOYaKGkKA+PbVR4+3EA/jVGZ6CQAJR+U55MP8
    RJ3nfWIh5Zcdgam/v5JKyDfCEfILxKZWGoRhtzNLhOLpeh2LqHMVG6TV6WbGBbiSYPAVd9
    5RD+D/lju40uQTEYWt1/7jLvi8oS4Hu5DB5XqNd+rkUXwkCvApYca1SMpU/Q
X-ME-Proxy: <xmx:w08ZalSR2fUKHnUGeophPGZfIoa3FLSiVorE0-OEfUNGV2uLw-_6ZA>
    <xmx:w08Zal3v_7ek3COIKrCDsZfg2jQl0m4Z3rI0TedAf7i9hjoae96Jag>
    <xmx:w08ZaiiajKIvWqZEZyaQI_aMtzFW-TTcZjHXYOCntS4zV902fIzDwQ>
    <xmx:w08ZajZHTB-r0fcFpaVE-YRBz0k-6zzT2wtxgkCJgsY-Wxa2QTmtlg>
    <xmx:w08ZarPj9tOVHrNBAweSV_sZUvum-foitmXNYw4RmHdlg2YpKR9_xRaz>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9B247182007A; Fri, 29 May 2026 04:35:15 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Fri, 29 May 2026 10:34:49 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
Message-Id: <8082b77d-6522-472a-9030-317087ecd7e9@app.fastmail.com>
In-Reply-To: <22042b98-cfcc-428e-bb08-ebcfe785eb69@arm.com>
References: <20260526175846.2694125-17-ardb+git@google.com>
 <20260526175846.2694125-32-ardb+git@google.com>
 <22042b98-cfcc-428e-bb08-ebcfe785eb69@arm.com>
Subject: Re: [PATCH v6 15/15] arm64: mm: Unmap kernel data/bss entirely from the linear
 map
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: panz7z7zhme8ydqx4myccws4zutyrt5k
X-Rspamd-Queue-Id: 581E11A000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780043718-10561
X-HE-Meta: U2FsdGVkX18QFTuywVNTKYJJGHXzn2QhLlHAcHP8vrB5nQ7lHQNeepqRmVLhLOY6CrAqjb3DU9fpCFnEtRBKEshK5iEL6ympqrEGtvMQJ2aLt2a0zek2ZFnz14UdMMO2XjctZkR++uWMG5EKK4XSr9IYKIiB5JhAPUtsyWwSR0XkaN776QDWUpDgiZn0fbHauB04x0/kVcfSECkPGabAOIxUrESkSCVAET4VWhUYA0EHe/9zDqAhZ+DM+yjroUMy3g/2NJa+hTDQwMAOy+majkgLJ3Fd98Of0ZJVjLr5rFAq8w/6nXWxFO/g3DDjTO6no/x3lwhy4wlbX1jQHaunzQzGXor7dZajmMXR6tsd2s+leZLDkd0ssvsAAWj/4RcjXZoEb+qld3yKyeuPpRWYCQSVzDEVRyv/py4feBZ18d0Vh9nGe2RtjzbIGjzIKkabOxQXTuQzFFfyHleckvHsU00ZjqS1pFGUInZ2nUUdbevxyTaJvK9b9gPgAEc7/jtb1nVOFosfheLWZ9Ish+dOkhRwuauAuZBQ48kK+i4GMnDNRuv68X2utt5hQmI1jYng74amCbStwQPvp7QCrp20AX44XHF9S/uXGQ0PNWRGXqVSWdw70crDm8q8g8HzZF58GhW4zSfXHDi5zzBkhg8gK+Se/New+LlAaziXS8lkYsDzOb5gOaNbqlGOQ/6Xv9QPw8LsgE81+FCGzdOr75objBnzmnxQPZ6iHTaVrpJErcMf/4uQMFh/HXppnBCc4U2ep1VpkDQhyJJ/MFsSzayAYF5lRihxuvtOOcvU5mcPuPjFelhPKhCo3zpuzgDy91akQhQXmozqbtszI2/kRPu3vV30drCqeK4ChFGgsdq0lygxbRh0QmiBzgDh9vhp2jZ22ajhOoMop5Fa+6NOyJcVjAM46LWBDUTgWch10UozFq08gZxu82OSYexJsJiGXuZdeeltZLbMGjH41/fKdNm
 hQ0B06C5
 HKPI3BGTh83pMyeAFnht+lm6sv20hpvVwtRNRI97MasRYHbG8yppEyEll3RnQ8N5++pXlvqxgtRuELq9Z780W+2R1vVt4bVTS7eL8qzUNrHf8Zif+SXbEd4VQwU9ecMFIRipEiIeuRr9LEDp05vz8tJ0ZpKoOefJH8acPpUUaY9Qtvso1D30ODINMtJcOfbNPkYqVXOPYZKu3RX9DuG7WO+hrU1v/dq6Y5su7KTVmzOLHle5eJs0ellcQSZdKPcW4o6iA3cYkdAVAAH3xGrOuRKuqwo2q9d1RVddLU6OsOghc6zQCLVAbPu9HWU4J6B/SOTvtSl3hus8DG6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Fri, 29 May 2026, at 10:29, Kevin Brodsky wrote:
> On 26/05/2026 19:59, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> The linear aliases of the kernel text and rodata are mapped read-only in
>> the linear map as well. Given that the contents of these regions are
>> mostly identical to the version in the loadable image, mapping them
>> read-only and leaving their contents visible is a reasonable hardening
>> measure.
>>
>> Data and bss, however, are now also mapped read-only but the contents of
>> these regions are more likely to contain data that we'd rather not leak.
>> So let's unmap these entirely in the linear map when the kernel is
>> running normally.
>>
>> When going into hibernation or waking up from it, these regions need to
>> be mapped, so map the region initially, and toggle the valid bit so
>> map/unmap the region as needed. (While the hibernation snapshot logic
>> seems able to map inaccessible pages as needed, it currently disregards
>> non-present pages entirely.)
>
> I'm not sure I understand this, is there something wrong with the
> kernel_page_present() check in safe_copy_page()?
>

No. If the hibernate code decides to snapshot a page and it is not mapped,
safe_copy_page() will do the right thing and map it on demand.

The problem is that pages belonging to the kernel image are marked as
PageReserved, and so the hibernation logic will not even consider the
pages for snapshotting if they are not mapped.

>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>> ---
>>  arch/arm64/mm/mmu.c | 39 +++++++++++++++++---
>>  1 file changed, 34 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index e7ca53d20b87..cb00e42abbe1 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -24,6 +24,7 @@
>>  #include <linux/mm.h>
>>  #include <linux/vmalloc.h>
>>  #include <linux/set_memory.h>
>> +#include <linux/suspend.h>
>>  #include <linux/kfence.h>
>>  #include <linux/pkeys.h>
>>  #include <linux/mm_inline.h>
>> @@ -1056,6 +1057,29 @@ static void __init __map_memblock(phys_addr_t start, phys_addr_t end,
>>  				 end - start, prot, early_pgtable_alloc, flags);
>>  }
>>  
>> +static void remap_linear_data_alias(bool unmap)
>> +{
>> +	set_memory_valid((unsigned long)lm_alias(__init_end),
>> +			 (unsigned long)(__bss_stop - __init_end) / PAGE_SIZE,
>> +			 !unmap);
>> +}
>> +
>> +static int arm64_hibernate_pm_notify(struct notifier_block *nb,
>> +				     unsigned long mode, void *unused)
>> +{
>> +	switch (mode) {
>> +	default:
>> +		break;
>> +	case PM_POST_HIBERNATION:
>> +		remap_linear_data_alias(true);
>> +		break;
>> +	case PM_HIBERNATION_PREPARE:
>> +		remap_linear_data_alias(false);
>> +		break;
>> +	}
>> +	return 0;
>> +}
>> +
>>  void __init mark_linear_text_alias_ro(void)
>>  {
>>  	/*
>> @@ -1064,6 +1088,16 @@ void __init mark_linear_text_alias_ro(void)
>>  	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
>>  			    (unsigned long)__init_begin - (unsigned long)_text,
>>  			    PAGE_KERNEL_RO);
>> +
>> +	remap_linear_data_alias(true);
>
> As suggested on v4, something like mark_linear_data_alias_valid(false)
> would be clearer.
>

Ack.

> Also, is there anything stopping us from doing that directly in map_mem()?
>

Excellent question. I will investigate.


