Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ABF4CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B21A8E0006; Sat,  4 Oct 2025 05:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2155E8E0002; Sat,  4 Oct 2025 05:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104348E0006; Sat,  4 Oct 2025 05:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECE0B8E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:19:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C5ADBCA49
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:19:51 +0000 (UTC)
X-FDA: 83959884582.15.41C0ECE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id D15E58000E
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:19:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HL4174Ye;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759569590; a=rsa-sha256;
	cv=none;
	b=Cfiob2VdFMZbVTO3vkvJa4ipT6vTcPQjtfWYcaMle8SNBizeTuTSnzzMV/EpvU/Ok8RvNF
	SbIeBsMP0Yimytfak1WTwK9a/zeeAP20e0msMClCa6JB8QUzpPiPp+lyYhOD2UrXUBcS/E
	0XGFwhM08rgg8XddeKlQNzu4ZIdFSJY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HL4174Ye;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759569590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uGsKshcLtVicYKckogwwVgGitnD5x+ZgM+2AE5VVavg=;
	b=JyeRWl+wF0L5e3ZxRQtyj2A9XeRxzHsNHQSwrlDXAu6+2EcIIceTPI7m0TuwpddW50Insl
	KSMpcJbU5LT5BbzApO6dgv88jvofh6J5+TIkkB4tiq1kyO+4JtTkLjxFWrC+Cosjn5pTS+
	G93PO+L3lRi+CBgqara+G98VANsDvu8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 69BDE433E5;
	Sat,  4 Oct 2025 09:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADC9C4CEF1;
	Sat,  4 Oct 2025 09:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759569588;
	bh=KY1sX8OSJOh9C1F2nogtM66uWvTnblV5Te6fP8LKJFo=;
	h=Date:From:To:Cc:Subject:From;
	b=HL4174YeEnScY90+2h9VljzlObU0qFm2rUj+ciEnAEqj1Bpm6LTXugsyjjnWH4hUP
	 ABdaSUkNiBn7I+XplDfuqNl9MHViaqzZQQeV17Uaxw9CBtGsVHvR/Q69DmMBKcKR0Y
	 ZOCWt0C1yp1vmg0vFRaUkMS9BETe51wzpngZ+kjn02UuQe3J29J4ZVTjyitab7yo97
	 CqatEoXMjJ49mSoGlNYjedIWgDviqNN4nwRkatvc6oHHUTleXx8k8kXrgTmXHHzL5P
	 uRjivTQmhNNRSb2tgPcWHR1RtcVx5ZKhfJ/0eGpn/bbOItFE3EXwM8XhIzxDcq1tNY
	 1DBtf8jNZ3+tg==
Date: Sat, 4 Oct 2025 11:19:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [GIT PULL] mm/mm_init: simplify deferred initialization of struct
 pages
Message-ID: <aODmrlNys5x2LVtl@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D15E58000E
X-Stat-Signature: 8jeqxjbr1od1mjufq3zshxz3yjqgfhkd
X-Rspam-User: 
X-HE-Tag: 1759569589-985454
X-HE-Meta: U2FsdGVkX1/bIV7gYohnP1H4xPFE7AofjCtS9dlVPVhU5WKWjTyR3N3Evz6j8FnAT42Z/oSVBbUOb75v6MD7jP/apP4EQr2a55KWx7FYn4JHjyE1m5ZR4+eaocq8D6dHjzJIhWqNREAMjA2Sqw87GH5IZfN5Cf+qNpPn+IOXMVUw+IrsPXn06ACKwTbP2SEtsnavOB8buGGVJO3msvJnP1XKkeRvctE/y3yXN3FiZC2ByLrWtV4X/IrUrKv0+gx5gqdZT4Rt0EKuAyPWX+nxUduHtO7pS1mKhJZjNVLHlb1ly6GLWgvQgwdESbU0/f/1XD43d0+m8mXks98aIUvKXZtPCVGn3Q38fzNv9YAk5d+guEXTUSwSI8XT+AzskqQkk6pujqm8cEmRc35TVw0Tp2MgoigwMFNPpInC1iAekeMpkVQoT2DiMqXH22U7oxJeTk2s0qR8JkNrxOqXzM71LlH9+PM5yuwUow2ckthdC6fujzqpJa4i/kUqIYLdbRBTP5sIxI0CpgrWC+LtS1LKERnRLjmjhLXEXu1Mue6E1TQq2uYoVEocDeA4biwP2ylUqXKloWm+olQIMbx7jCWH1jDHMXwE+5Ixv5zzjhkBIbbqBRBJS+TIKNaFzU2A4h7RDT4U40csgwzP7ZBebTGgiMzQMRRI+e2vqkJjaZp3yeHKRmcmQS1k+4zMmq2RDfVTsa0tLkIwAk5XyPfs5PlnX1TAAJd/wLRrbJF/bCzZ2nH0VbdWTp+DeqxDTjriDqlrZAeAUl3Xw6GdW+3UHqYn9nA8e3DfNOp2q5XLYqUg9A7+I8XuMNxvvmD1PBnTb8cx2T9nWXLQqAqnOSm8wRI4Tqq7cLvkqc+vPfVuz0ILh3FPWVSeli8uA+lT7I3m+I+mveptMm0B03G5Q9F1REVgIj5fsdbuF2XqKM4TswDiV03Y8O5EKqBpOB223P/ye/ukfbWdP5zHWvjSxZggyKW
 CH5u7fKk
 GmlyBEnm0urizXc+1+URfGuGMwj+K50xW5ZEDENrXavXt+oZIutogu7UTHs995z4abot6sIpwpOh0WVyuMiOjsAiq3h2w40Nc61mhiTmjfRPxhqQCACqCXHEmdwdhOdcXp/JVuIb8FkXotdinEei45JljT8vwmReCxnxYaYEQH0N2jvHw+N8avTc2kEZ+lrK/ZzMvRh8pLyR9vnhjjmQwEnKu3l/QfCkEIi8lpLuOEa6VBustP8y41VXI+b+W8ZEDtkpgRtLh1w2Q8Uq3qTgI2kYyQVJUtyQy9lJMzz+0dOFzy5mIlLPhP101RXyIYTP5ndlM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

The following changes since commit b320789d6883cc00ac78ce83bccbfe7ed58afcf0:

  Linux 6.17-rc4 (2025-08-31 15:33:07 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock tags/memblock-v6.18-rc1

for you to fetch changes up to e68f150bc11d0a05cbe984a4e5c0f72a95cae07d:

  memblock: drop for_each_free_mem_pfn_range_in_zone_from() (2025-09-14 08:49:03 +0300)

----------------------------------------------------------------
mm/mm_init: simplify deferred initialization of struct pages

Refactor and simplify deferred initialization of the memory map.

Beside the negative diffstat it gives 3ms (55ms vs 58ms) reduction in the
initialization of deferred pages on single node system with 64GiB of RAM.

----------------------------------------------------------------
Mike Rapoport (Microsoft) (4):
      mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()
      mm/mm_init: deferred_init_memmap: use a job per zone
      mm/mm_init: drop deferred_init_maxorder()
      memblock: drop for_each_free_mem_pfn_range_in_zone_from()

 .clang-format            |   1 -
 include/linux/memblock.h |  22 ------
 mm/memblock.c            |  64 ---------------
 mm/mm_init.c             | 197 ++++++++++++++++-------------------------------
 4 files changed, 65 insertions(+), 219 deletions(-)

-- 
Sincerely yours,
Mike.

