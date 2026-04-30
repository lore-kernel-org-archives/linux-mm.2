Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B30FF8864
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0219C6B00AF; Wed, 29 Apr 2026 23:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3BBB6B00B1; Wed, 29 Apr 2026 23:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E8F6B00B2; Wed, 29 Apr 2026 23:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7A526B00AF
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 901D2140323
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:36 +0000 (UTC)
X-FDA: 84713784792.10.FD14B7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E003A4000E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mP65EIKs;
	spf=pass (imf01.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBUV1UY51EquXgvsu9l0J1vD54XyfRXbXcUtN91vcr4=;
	b=mPecXhx/n5wu16pYJwCnOcf+I8sjGBIsvkLxaTxMEsfKk7uukW+l0ChASL3fFsfMwliNYq
	AVtW9A77WW8+ptSTBhaHuJtwSOxka623ZDDJu6mNnWsfGabTZi/loaHSlZbhAcwUt8igLN
	9MR9rtC1+5kOWROyZgrRaIaR8jN8Cwc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519595; a=rsa-sha256;
	cv=none;
	b=SxI8x+lNn4HG6qpgpslYnxCJrend43IRN/FvRGH1LYPDNNcXVrQAW0F9OCv+e+FLkWBapz
	YsXBryj8/MT6rakUq1yC5ahHn+1L/UWb2mkBwQC9Q+sXQL1UXRTzTAemXJR3yucM3X9p5V
	nKdcj1zqiemxlcHJWkxP3lg16eiBgyw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mP65EIKs;
	spf=pass (imf01.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0412543C97;
	Thu, 30 Apr 2026 03:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76E4C2BCB9;
	Thu, 30 Apr 2026 03:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519593;
	bh=NX3tUbayE/lMyAJb6o3+e820TWiqNMgOixMjRLbyqAw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=mP65EIKsJxlWVdg+ZdXsnteOQuTT9vum2+qioBLuE0frnQQRT+QScmlJYMF4r2rSI
	 vRnOVIKGyMypZxqAJx34gvszIqHVXmR+QkkjPihM/bdH5nsCqw/IomU2lfLTIO3qaV
	 fvUnaxQNW+/G2HtGg5iLLamjVYA7JPeh8wZvmVHDfu5iMSPTt1nLar5p0412CtWDgK
	 lyGF9LgaCB6elDJvdu74+k3vsoWGMlR2V3nAuZBmKoikIMpqHRujdbYpu6ZuyNybOl
	 b62emfrFlXYc+v3w4ssHP5Gk2/SwOXz6mEx13YBbE2tukLYy+rUTQphw0/yGbP59MZ
	 ojfVmdQYoJ7+Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FD903809A07;
	Thu, 30 Apr 2026 03:25:50 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 01/18] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751954879.2274119.13489551409469223831.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:48 +0000
References: <20260227193030.272078-1-kas@kernel.org>
In-Reply-To: <20260227193030.272078-1-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, david@redhat.com, willy@infradead.org,
 usamaarif642@gmail.com, fvdl@google.com, osalvador@suse.de, rppt@kernel.org,
 vbabka@suse.cz, lorenzo.stoakes@oracle.com, ziy@nvidia.com, bhe@redhat.com,
 mhocko@suse.com, hannes@cmpxchg.org, corbet@lwn.net, chenhuacai@kernel.org,
 kernel@xen0n.name, palmer@dabbelt.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, david@kernel.org
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E003A4000E
X-Stat-Signature: n3nmqh881ws6xi4s1kc5zzngxmq8dms6
X-Rspam-User: 
X-HE-Tag: 1777519594-185144
X-HE-Meta: U2FsdGVkX1+c8KBp1mumBtXZZpPWjYPjYb2igWgHCkp1fS5EvKG1kSoN9cC0cN08uVZi4qaTfbotZFm9s2RQxQJXaU5YIHBmajfR5oQc1e130PZuzrhJLyChgssDnWBcnJBp0UmRUqxdgLyPt1kmKLRgJxVGF0PYjgEJLEQYwaKOeIg4cmZU96NgOTyL7x/luR7BfvDscfR/fMLldkymtBtSDM/Ra9mVO7Gl8X+TRfF1Lku1ZmutVAH00Bw8XK7sgCvXcqbVWVnkv6/GbEiX1RGLRZj81epCANtWBenbr6xPluFYaxxWwb6nZum/ZYccYkWJwri9oVZeJb6kxefZfhO6QSo993PIRJ9mlLwyWSbSsV4UTt1Wr7fpCslsd1s/+alFw9xNobkyQihzCTXXkYW6czXMajJqauJZ2gLzI5UB3mL7vpkiJD+soQP1O8Fm7dMk6g94xEtpytf21UNqFscDe+1+ZLsEwGSEcSrw9dxMZqOwrFiRiVy9+2N0i+xDiTcgVvB95EMBg7O3Wl9KeAcF5wocth7iMuEgheRRhagcfTBmZ9R+VPkZUuLo+uA/XzSDc4Ogqr0G9d535wZErLn4UOkuxKfiBVEUwU4bjAxitn7nS4C0cDSB4n9bDai9md0t/NhD7oIvQApsUToyZjlwOlOolriXRiZ3f3pZhXhlOuI71e/adl65l/EQ+69pif+Lx+gNUWcE1yYWOFpbX9NuHRawup0yeYDmMnnD5KOWZuAIVztE5KPirMKGHVMc2aHL3pjA1tUxDFAjaJhV6NR5MjVNvEv0hCDKYJxQojjEPNIYsv5OqIWnKyWDPg2IQtklyQIRqK3/SjXMmQmdLSjM6/YUAJduUDIvuLbZAwfkTmuvDC2qRscT+tUFFs3W439nMWycElwJIRSiSQDbmJqkwTUTG0PtH+NfEthCuJU36Yi0l0yVja1jlGwS1YiSFmkm4IwvphbmY9OdG1p
 Rd9Xjm+g
 oL9MFK26th/4KGKOiuotRs0SwWwHwfcEb27XdVnM4ct98tLMlgaYE9b21e7yB9oL8ux25llkcJKY5p8VP+JJ5wNgL1EVRXFWIH8QXCX4oTZDe6rTkFHiKkOxE1E+Fv81Hi8j5xm2Ot9FAfUqnwq1+rxfbs6XIoLfPw6P4M/a9yLyiQDDxtd+hdnP5rmafZJ+D268+VYPnzdDXLHrSfhynY8ZMxZLb39hyb5/eIFcb1Qr3rcpEHPoCmaXHrMzlbtg58DkAdY+QJruzmPwSAfr1vw8tO+aceG//fmI9Z4srzYwsGALCORoE88dcD+YqMHj4vVZypa5H4wZlOBQDtWbhvNsrRj1nPDt/nc3Vugdsf2t5x5retTRB0QBUr5ZUGxgHQ9nc6LA+23wle6KCu1C7KNmcaKTECHIwcTAOqh4KgHz+SdBNaunswK/u0LkCh9VSo2ZIpDu5xBxOtewq4wNgLR/xDPawvixLLea2fQr1PhGe/w0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:02 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.
> 
> This is preparation for adding the vmemmap_tails array to struct
> zone, which requires MAX_FOLIO_ORDER to be available in mmzone.h.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,01/18] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
    https://git.kernel.org/riscv/c/a2c77ec320a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



