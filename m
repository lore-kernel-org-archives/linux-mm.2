Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977FC606A881
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mNl2+90y
Received: by kanga.kvack.org (Postfix)
	id A047D6B05DF; Thu, 12 Nov 2026 07:34:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98E926B05E1; Thu, 12 Nov 2026 07:34:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A5B6B05DF; Thu, 12 Nov 2026 07:34:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 472596B05DF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:34:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBC3B12058A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:34:06 +0000 (UTC)
X-FDA: 85426409292.23.B2E6076
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id F09BE1C000F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:34:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mNl2+90y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794486845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLfvAl+y+GjjcH9CNw/4ElIGTmELHExYwuG632+gsLo=;
	b=ibs5bkv+MnxZRCZ95zvgYZMG17T4e90m76Te5dZ5rohF7fZa7lPMBC21VVFBYENAGT2Vct
	RIsjMwFHMqh6iMnDJpXZB19fA8uRj5EovMcx7/7alB4vYsLkoL5eriGonS3MXYIXpdQgyu
	wN6JyU8wCDE2vYoewNszkSKgCLMUCj8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mNl2+90y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794486845;
	b=bmG9i26G2RMF8p+ifgYGQDO0LmrwrjGmA75saktA52Qf7+X459Q2CJMrMO6qtt2WLtDz79
	R/QhkOYurBBfiYNC2Zax6vw89TSu7cnwVpb9Hq1ZYyaHa0hSJRe1afPdGp6/pCI1eH4aWk
	MIxuLUBg0mYxr6CSImJYwHLI33UaGz8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6769B63734;
	Thu, 12 Nov 2026 12:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D2D1F00A05;
	Thu, 12 Nov 2026 12:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794486844;
	bh=NLfvAl+y+GjjcH9CNw/4ElIGTmELHExYwuG632+gsLo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mNl2+90yrOnioBRhxRyXJL0FYDN2ojhE2hQJmHGJhO120AvUHPL9+18HhuJPScpkr
	 3rOnCv3yR3j3k5V5XXExWDKfShv+OWRKf2FvQqtW7ckfxRp5OxpY5BjSPcSsEDHIOI
	 8LNA7XaAaenbCfO+lIDQtFXgGlIwl+HNGqUR28hdRP3wM9FCAxNSalihFtn3X+byuA
	 yXdgdq1MCSYltVqooCuakopVO/xe7D7fpcjG/D+gItfFGUaCfSSwIOhGtmZf8qLgT0
	 arCGIH27msFG+pfhcuGQY5S/Ytb3YIxkI6oVeHTVEAw0y6zz3TOFJzm6E3Jd3mvulD
	 ABZfMy26eYUQA==
Message-ID: <fe58d4ad-0410-4525-a1dc-2cfb2ce1d52f@kernel.org>
Date: Thu, 12 Nov 2026 13:33:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] mm: drop HIGHPTE support altogether
To: Mike Rapoport <rppt@kernel.org>, Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andreas Larsson <andreas@gaisler.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Linus Walleij <linus.walleij@linaro.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Malin Jonsson
 <malin.jonsson@est.tech>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-5-arnd@kernel.org> <avWo4NrAPX8BisCY@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avWo4NrAPX8BisCY@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F09BE1C000F
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: rxschqfugxmqh9rojmxpx65mbrauzedt
X-HE-Tag: 1794486844-628913
X-HE-Meta: U2FsdGVkX1/tCelBlu72/jVtM4qkAsrGC2OubbT1y0eJ2aaiyikI2szxuj2mmA2h/drQp19EV+HTvZZMdvmUrGZ+cSGguRmZpSFGgqkL82W5CVIAL3WkSQ8PdvAYsEfb1gHipcR+t0OOxXZBEsc07dR75K4z1tA4T41lxOAujNhyIH0flU8OXkGH8Y+nd557KwPsAkFacQ3wu6RBdPO4e7Ubupo/bOYoTMxXx6UG64Jm4hUsfrlpCR3jCP4p21Ux8+Jv3G2PuXhssfAAZH3pD//jSoNsNlhDYnbJ5RhnC3ql3A8U/K277DEUe2iVWbPFV6vu0bG/sp2JhT+KuYwc5DwUQ6s8rPazaNQ1lA+BOT43zMw13/h5qDLojZAosZpmRQNRTJIsCM3wdWgaeKolPkZGSG7BlTkRl0JkEmhFlEj6Ubp6F/G7bWN6b/caZlny1L4fH4NLVWEFHyANwjFLMXtxvI4bmvUdBiRm7qHlJYd9DrGBU0uFe6/dw/CjgQv9x5zL7vTgh7Fs7Di9YD0J5McyzXhMp776A8peSJfLrxOvl58AlTOou0z3ksX9jiyaCB4iY9qBPUzR+fhLf4hcCuuvOx2owH699ONqavNjGO4fNGg9Yw00r/OlGhvJPE4DQ3thZjZQiT84wwww3p+NMMDvsU2EiHBgI+xpONRXiStP5XzqQp/4m5nAD8x97mZ2IJG2iHvIVKj7GH5++9nZN4sGloY3V4OncK7vShBaERwkQgks1M1I4ykQoGC0VcIe1Lv/VUV/jgcvT5KJofpqvaguiHMZCszhDJXS7tP+E4SfR5aWQm9VBdtwNsFxhYy94ArGc6WiE1f79/R21KzEckwQ3hsV5dkIonAUK5YJSqCCDq7X+ssTFLJCex/zDgFOh/GjkfNzt57MlZ0ypDhyK8Xcz/tL6OwnErSHF8HfDfNys66LHLgfR5rr+WasI25iR4W0S5hJwQvH751s8d6
 kNzo76oR
 QZcyQD0Y1hocboc+h15j8WWYO7LUciK5MKUMPa+yQvoJlkcRjCvSohGjJcHJbX/ArOTJkSsZlDQ36I39mPOMAYExTFHecPVUluhDZaVJdiGCurPeK4sSsAcW7+hcXoxImu2kKiiKKKMNCXuYrUjdFCEjYTC8ZUBrcwV0BGH1Dxrekqo+M0V34OJyMW3kNIP3/448icPCiFwlWiDmP6AdVYSpExOStkno0w6F0BWWj/QjTlFwPqzih4jdfXy83ZiKviQMWi+TVAsICMqAKg5ncbU0Gag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 12:54, Mike Rapoport wrote:
> On Thu, Nov 12, 2026 at 12:25:26PM +0100, Arnd Bergmann wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> With both x86 and arm having dropped CONFIG_HIGHPTE support, no
>> architecture is left using it, so remove the remnants in common code.
>>
>> It is likely that further cleanups are possible in the page table
>> code but those are not obvious from the config options.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  include/linux/hugetlb.h | 5 +----
>>  include/linux/mm.h      | 1 -
>>  include/linux/pgtable.h | 9 ---------
>>  3 files changed, 1 insertion(+), 14 deletions(-)
> 
> With this and arm HIGHPTE patches applied there are still a few leftovers:
> 
> $ git grep  HIGHPTE
> arch/arm/configs/vt8500_v6_v7_defconfig:CONFIG_HIGHPTE=y
> mm/memory.c:     * Dumping the PTE would be nice, but it's tricky with CONFIG_HIGHPTE,
> mm/pgtable-generic.c: * kmapped if necessary (when CONFIG_HIGHPTE), and locked against concurrent
> mm/userfaultfd.c:        * index ordering when CONFIG_HIGHPTE is enabled. We mapped dst_pte
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 


With these gone

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

