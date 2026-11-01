Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94863606ECC3
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 22:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RI6vqfud
Received: by kanga.kvack.org (Postfix)
	id A71DB6B05B7; Sun,  1 Nov 2026 17:16:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49346B05B8; Sun,  1 Nov 2026 17:16:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95EFF6B05B9; Sun,  1 Nov 2026 17:16:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75A546B05B7
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B40AA0AF9
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:16:35 +0000 (UTC)
X-FDA: 85387960350.11.1B21E60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 52F8B180003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:16:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RI6vqfud;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793571393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jMaG7E0faIciRuA0j8698KDnNXPdfgqG5SZCjrpwFM=;
	b=bvPSEwX0DM05S7UZ+/KL5N/kdfgBWBnOy/olUQfakFyHY41ImE+6/MnGHfW2kUGSBhIcJ/
	e8wO2Azp1/FsKDtsoi8oPVVEkYGv+0w8/+YcrwNBTniWPhOLVS6KxoqYrGCoG2vJU6g+Fm
	vgQCGHC0jyyDp63YRiskLKJIqAsxCok=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RI6vqfud;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793571393;
	b=3zIOhTpS24DFOSHTij95NchwkdhdlpnidldJbOEvXtaJ/8aj7uIo1qn3czjH/IidPsUzs2
	qWsPkV4JPJO7HmUbm0nfMxzA/8n7q3iUpoUeUGs55NzEi+dQ8CsoqxL1dFIlI8vRQ0ZdGU
	hx5atBnfbMKdB3xS39+Yc0KBtq1Uuuo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FC2441815;
	Sun,  1 Nov 2026 22:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4D81F000C1;
	Sun,  1 Nov 2026 22:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793571392;
	bh=7jMaG7E0faIciRuA0j8698KDnNXPdfgqG5SZCjrpwFM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=RI6vqfudUDAPQJyogDLl2CpARmQSYi02Z/r+Di8qbeK3KcSdM0cWSldHGeHFd7Wmg
	 oZkcWTzbyfmhEOg5tcfCHfhpf6iaGm+isSH86qaujprBW88A0OM503IaD8+WPv9717
	 bpcrsoSfdrv6EFgcaHxAfgeqBVd+9Lh2jlei+lTKhKmrMmF1DDRxKwuNJ2YAzniH64
	 bTK3lBMxJ6uc9UCiWTe96qjtjhpAxsSnnRxROmumhMt3+M7z/8Bl4vxi21IO/fXVoH
	 wUHNq2epY1lAcTmYzulW8paMq9f4RX7rYBp2SAoAq4o7yj3fGB1UzuSY/Wrq1aK7S0
	 zpB9EvUeVfZow==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5347838003B8;
	Sun,  1 Nov 2026 22:16:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/8] mm: Drop pxd_ERROR()
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <179357139104.2624073.10186400247460209292.git-patchwork-notify@kernel.org>
Date: Sun, 01 Nov 2026 22:16:31 +0000
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
In-Reply-To: <20260831054331.625505-1-anshuman.khandual@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-riscv@lists.infradead.org, linux-mm@kvack.org,
 samuel.holland@sifive.com, david@kernel.org, rppt@kernel.org,
 akpm@linux-foundation.org, ljs@kernel.org, ysato@users.sourceforge.jp,
 dalias@libc.org, glaubitz@physik.fu-berlin.de,
 James.Bottomley@HansenPartnership.com, deller@gmx.de, chenhuacai@kernel.org,
 kernel@xen0n.name, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 52F8B180003
X-Rspam-User: 
X-Stat-Signature: 8rhm8xmoru3tq5eo7mxhwaupusezicyw
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793571393-180363
X-HE-Meta: U2FsdGVkX19aPL9/GAXrHZVadU67d5xmmaJJAWl12xUCSkn5TgEDFSN2JA0wa95mwN0B8UYhCPeYuXuQOG7ZFEpd+LltbDGmzyDBm6Vp63GcdKaoOgq4uC9TP0x6U2K6gsTGDrCHLMirVAnX4LFOoqdNuOIKQLEi0Awq7vbId+n8ZZslWUqbUM75wpDBalYPdx1tWxqE/KFFyWmlHUl8nFvsLwRTMCkB+hqMIgl2eBAAWEA0+2vJlz8KmzMvbC3J40MgX9L70/AwXlGc9w20VXpJoIDRCEhrEqnAsKsmTW3V3z3wsbBE2OFHvHY5678Kc04+W6QgbYFyWPmSrOjAM+ijfIiyADT6Ugh5lGO8DVbdbNMhq6KBWTey/9vH+swxKb9VXZq8WY1yjvIFH5GWfokC+E9hTkrPJTEeM8/xmXqnLPvvJqM4A73QPqsSyKVYBNp2lbOvrnIpoAIOe+T8u8lzujbBss1lysRPuAG7ogg6r88xvT4+nTt2JOz+W3Qh+VyVZholmbyil0tIO2gJhl8gUzj8zyzXG8d/SIQt0dXa5Q7WNuSE99pOHLdsYV9VHttb+Pl9ozNqmyX37f6tYHipJNYTbu8iYS9aLvAzpFZVQ/SKod+DlVmlRTwJ+xeoLI7yQHKtwoxNF1+C8mjJviTKDN0wFmUbhCj/XDcIIsrQGsz7AGqVoBCw9yUQsJLcg9DbZNu2tVBue30vH6Wq38VVuwalWa3SrJKxfecZw8akDl08YLKIkSWVzoX0jKBBtnirmKmg3BncNfCqG/C2UwoOrYt0UoX1RUQ+JZ+fXwISxR4wzNeNWq/JsGXeAdyxKuaUbFED/GtMloHCEU/wsh5RnN+2A8GoEjtlzFV63SqmA3EF7YcDwocCvPSk0opRWAcegoE8GCay3ou+aHDjw888P7Ks2yoJs1Iz6kNj14roRIfm5VDZALoQAYQobG+kpzzvO8amiDryAwVziHm
 XbTGtWh3
 PzCipDVsAomx6Eqr+lgEWhDSY9fwUevcgJw4FMvuVHtIlMRZ5yFvBxAHBUXPCFvM8IGNBdTQQmX/ipthbEpzfW0IMbyezXvK/i4uGuqUbuQFlgmMglUmGRoKVgwSPxh243KvnyGEebDsKxGJDUKnYe2Gz7HlgOBQsIkYi/+NISgK8ydY9JF2i5Y4t6qNQwPFgfL+hXQW7ZrRgxTJ2I3Cv8Ph2JTPoza4Mj0Z44WQtQpBwI/CxDzt6uFBniiRmM1AfVbEGQIuafCzUL9k7tSE9QOypPz/BRsenjkM/hjzlE4ydtir08AJs/W6KscSfjaU2v7kYJqRFEAXxlFBHYeZQz5N/d6W0rgIHqGQzL+oNHkF4TkP92tnClzCQ9zMcAPRwe2p1OoBTnrD5nCgNpimgchMKY3RN0oAI3T0/1kRhN3B4hPUp4xpS/PtNMl6lGMNM7kt9+jdmFqaiCFsrAKYeg1MxWU+4FzTnkmUS/toxyWf7ahP65lDyXWOlZGrulZkYQxvkvHAxQ1KUgwtyW1TtA06C5iVUVKt439Bvgmyxk/KAc9djHXIJ/3a6Vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Mon, 31 Aug 2026 11:13:22 +0530 you wrote:
> pxd_ERROR() macros have been provided by all platforms, which are very much
> identical and can be dropped off completely if these pgtable printing could
> be moved to callers in generic MM aka all pxd_clear_bad().
> 
> But first cleanups and re-organizations are required in some platforms that
> are using these macros internally. Afterwards [pte|pmd|pud|p4d|pgd]_ERROR()
> macros have been completely dropped from the entire tree.
> 
> [...]

Here is the summary with links:
  - [1/8] mm: Make ptval_to_str() generally available
    (no matching commit)
  - [2/8] mm: Stop using pxd_ERROR()
    https://git.kernel.org/riscv/c/0666fc9d4432
  - [3/8] loongarch/mm: Stop using pte_ERROR()
    https://git.kernel.org/riscv/c/ea8763ac3af7
  - [4/8] parisc/mm: Directly use generic [pmd|pgd]_clear_bad()
    https://git.kernel.org/riscv/c/94d6c5466d1a
  - [5/8] sh/mm: Stop using pte_ERROR()
    https://git.kernel.org/riscv/c/6858e42cc2bc
  - [6/8] sh/mm: Stop using [p4d|pud|pmd]_ERROR()
    https://git.kernel.org/riscv/c/3b225ce37f62
  - [7/8] sh/mm: Stop using pgd_ERROR()
    https://git.kernel.org/riscv/c/66a0441a1791
  - [8/8] mm: Drop pxd_ERROR()
    https://git.kernel.org/riscv/c/c970236c300f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



