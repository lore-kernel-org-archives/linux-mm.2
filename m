Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AB58E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 02:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22C4E6B008C; Wed, 18 Feb 2026 21:04:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3B66B0092; Wed, 18 Feb 2026 21:04:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D63F6B0093; Wed, 18 Feb 2026 21:04:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F02086B008C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:04:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2EFF1B4EDE
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:04:16 +0000 (UTC)
X-FDA: 84459561312.02.D6777D8
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id E1EF7160006
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:04:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AseHHS3i;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771466654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EdFeIfI8cied5QM4K9689DPXawhhk8T32tDnon6B7bQ=;
	b=EZVMm8z3PGBg3IUice3GQq+T+ndL29hzSZmkiGA92lmJlLKj0Y87amV6pFh32Cck1U1tI3
	6yzi/r38cD3cTG+3N93u+412HknDQcpIVSypjFJjXyZ87S/QGYVZbt/yOnW1vB1eFXXuKx
	bKH9TN4Msr3WiZf3UqcCljuyZ67Ahsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771466654; a=rsa-sha256;
	cv=none;
	b=SPhd5sXvBi7AYOBIsRdv8/IgaxuvWN6BgkhrZArCPoDeQh00cBIJtfcJWvdKGIlIAIW8zs
	7fYwlLZaL/PmgxzTLkCnK+qEp3bGC2e9HcO09vKWashTWYSwRsk0TFhnrUWxLOht1ikauH
	BHXOdZtG1KCy+Ih8IVAPr8grGHp1vGU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AseHHS3i;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d4c1d2123dso447218a34.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771466654; x=1772071454; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EdFeIfI8cied5QM4K9689DPXawhhk8T32tDnon6B7bQ=;
        b=AseHHS3ilc0Cs/dwvCxt/rUPIeigZhdGwj//QbsEQOEk4Qi3wVAxePDQjwVOC6HGCG
         fKv/dkciehxvjrFceHM8w9tRzFx37ycRV/lJ3RnaDRjOZXWKgZjhlNUaj6E3zJPn19lh
         VPQMn5YgAgMbkwzX1TYc+4QC6tSm/LZwbkldYaD71C7tuUT7EZRqGff6DrveZOiJ+rFF
         Xhz/H69E2m+eC9e/IJdcKI7xsGSiKbg1oymo78ou8UbZLDRDHD6EH4yCFvSornEHudGr
         vSmyH77StghKcjG6SljbVewmKW0MWzIc3xjE8vwSMeh2WxU0WxXNp357i0Oyl8zU9Hp0
         50jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771466654; x=1772071454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EdFeIfI8cied5QM4K9689DPXawhhk8T32tDnon6B7bQ=;
        b=QsH+f0jrevjn2XiRp5dEFltkc00AuZF7SsB57l+mKMfzh5BTPMH4lXe63dOYa1hI9D
         ls/JhXcqHKmZ+Zo4DFTwMAtQNy6POUwOh9hx5nGPDUQvgUMIUQzK6Gpq/slwAT4v63WU
         1zFHCvznL0iyQSkTqLaW/NABCNlm1RAmMZQDHFiEFtsITXdgpE0PkbZIOwwLD4l7hSgY
         CodWkj6qIVvAct/dx7XV0goYkAmjpHxTHXgFfkkk4ML0jWTO6CtxkTjs7yuX/ovJedlQ
         0myP/lSWhgjAXC24w4MpEfpqM67ImOD6Exn3e2JTBp7h1m3XmsS1mXTkOS/nzTE5kRc6
         h5dg==
X-Forwarded-Encrypted: i=1; AJvYcCXYjXy2sIjjtIP4QUmLTXdEKVNy+uPtyJ1sD6ZqZ902Q9V1gu8/SE/Lz8abKqKG0d2uJd4fbkxdtA==@kvack.org
X-Gm-Message-State: AOJu0YzlbsOO+3atDtYvjoBXhafjTDgZAAePpGhxo8cYEz50rvp+I+bc
	izYXJRxz02UX0JDkgWP6Kn3xdKz7nJa+0VbEjNhP4sMyWwHHl3sPpARU
X-Gm-Gg: AZuq6aK5FphMYDu5/i8+ZQm4JjaWOqsZYmqdWZ1vtavLtBC+zIOe5khhGebGh4dUIb9
	TUpFnhFd25NBjwAuZeCPwamqepUiuNFiNlgg6XXj19ft2pnglwTBLijptaTIPVzeyIEojIh7/LR
	nNgg9W67KwCF7NTvn0CEz/h2ZjtGQhwEL0b9o9a0dUafulzbnUSWGklESeiYSd95FPLh7T1q9lM
	U0l0QxPTpIM51rGo2IxPuAl8itUcaKZNtlsYcIto30m9hrJuUgnHdZDpSQbhoMB36hD1lhdvXZ7
	ATeVR7lHCmYU8BBkl6pt8TDtmkIrXp0Nc66DlFYJs0D9YdTw2arTQE7C9id1kvnr+f8rx0GeMa0
	8hGjyhQX4Jkdp1iGGM0aCm1Gmt7cBMnRCJgsQTMVX0xreka6t1hYzvDScPZMJVuM/esf/DCmbK1
	dc8AL9iJs2ydrOS75JKX0k9Xryt5yCG8GK/Q90a2a3XP2/NuSaRqNCfKrjAcUIvqA6+TuyAdvEZ
	tui56DqZXetmNikzkCOe/hUrK3IOiS/UsvVo1I=
X-Received: by 2002:a05:6820:151b:b0:676:7cea:7912 with SMTP id 006d021491bc7-679a746f4aemr2138268eaf.73.1771466653864;
        Wed, 18 Feb 2026 18:04:13 -0800 (PST)
Received: from syn-2603-8080-10f0-ab80-0000-0000-0000-1382.res6.spectrum.com ([2603:8080:10f0:ab80::1382])
        by smtp.googlemail.com with ESMTPSA id 006d021491bc7-676e3b52902sm12187297eaf.11.2026.02.18.18.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 18:04:13 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Dave Hansen" <dave.hansen@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	akpm@linux-foundation.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v6 3/4] x86/mm/pat: Convert populate_pgd() to use page table apis
Date: Wed, 18 Feb 2026 18:03:53 -0800
Message-ID: <20260219020354.321088-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260219020354.321088-1-vishal.moola@gmail.com>
References: <20260219020354.321088-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E1EF7160006
X-Stat-Signature: epoy8r3hwincnuw8kdy9zdu6z33p8yzu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771466654-375469
X-HE-Meta: U2FsdGVkX1862n3ddn/ek472oKeQzDewyXXIyq0MPD65+Piu6WFFxzymZ+qP8AVeJoW+CoZMuRXkrAAexdXTMSwu76Z9XMzNyRuiwa6bACT0dxSnn3buP4o6fUeETeWkGYrko3w72wCRQJ/lFr2ZpqztbVHpdhl/Cc0e1qZ81cW93kGecOoqAYgQxiLkpZu2nZ55V0/+clsJntzH+4Ui30j7/GqXR0+9gCyBf2gozCP2CLnL4tlRojymSMeTm7FW9gY8VJlHMG0n7e3glFOm+wWDM5OtlWGMAv2vzKSV5EnFCJCj69f0GciYGN0iDi+Sn/GG7JE0vMyNInqBSXUATxdFLhoR1480ndaCmAOh9RDBqHeudIEzj0WuU4hUuZv5uVHBMhg7c39AyPJGgnryiO3ZFGZYdMpetu3WnyI5C4vKQ3O3DjipHCzJEo1CGEoaTVzGIo6fwLqttCEbke+OC2ZMXgppzljUj6vHI/D3LTDUpKK1ax4cMhHF4busniYOUWPNmkDVQTVSHJ7f7Mq8VpC9txn60WLJLBZSkWwEb0tXYSIaafnvaSRGGiLE1B/7hAoDtdB5B3yQm+LLd9qAutKGvu6w1W6hneFdtGxrAISkz2eqd3N+NEz41GAmG/H7mUD2hQvHg0GBi2x2Y49rUyFbzofB8uOlOdUQ5I7HeCSakGQ0295DclhDLRrFMXcxwMJoJoG7LXM641F3Tp6FdyBsH/QHLRYajFSBUUH5OWWbRen307ECNJsz720Kwg/Q5vM7QNb7FfAEYv9Q0HXSyBMWmzb6cUt4SY3MB48WzkkyUYZKKH3MUIX93M47zYY5ZsRhI8xPUZIuuIDX814M5pgaw+8q0NIAVqS0C6eThhEte6xHtFPCsvHHJSRFV5ywUu3ZAFB+gblwfGhxNUHalOKJIPy175xiqd9mm4njTsWHkcviSlqD/7zQDbDilwD7wzXOj3/IUXto03tOx3i
 gUo2/Y0K
 mvh4Hx17cD8ZRwSa1aOysWlRYyNReajNeVBKf7vF3uFryVCx32ZrbTN83kZsJZecZkcypbKrwZtyBFarScVzS8KNSQMJYeeIcgv0kOiLxWY5nGFaxgwznegorGA2ToJecef63esujsSMrrPWwnPvshPiM6BBBQsSiMptm1cER3Ut//HNIo/HTfgLKKqVL+rRedpVWQju9+EH0tYyD4p4BuLeXufk9+M8DubTeBGtVo31U6vsnACjVG8v2SV0gkaNj4d7ZLlHlC6QQWzrVqhytZv4/w1oBN0bwHvtmSiXSmbhUdyKgz3sXjrC/4k0xqVj2BPoc2+NsjD47+dnDho7h15gtuaKu34MVB/F06OtZv3LM2u75HGhgMhhSVj2Oyjltk7MRfibkL5aqJ73n3KNUM/gogrgK7WFVdCMCpzb31RNnmNJ6D7ENhC+2QYhrOlDSJAzJLxA2qNLlSn3AA//vA1HTan/haW1sgcrF6DyiohrTEBuLmgRBBprGFqgFVgcjOzC1e6Tb/W9hljaBf8AJ0pDkvFZpDLLB2BFvhbi1aCM6g+I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We need all allocation and free sites to use the ptdesc APIs in order to
allocate them separately from regular pages. Convert the remaining
get_zeroed_page() calls to the generic page table apis, since those
use ptdescs already.

Pass through init_mm since these are kernel page tables, both functions
need it to identify kernel page tables. Also, the generic
implementations don't use the second argument. Pass it a placeholder so
we don't have to reimplement it or risk breaking other architectures.

Its not obvious if these pages get freed. Regardless, the only other
possible free paths have already been converted, and my frozen page
table test kernel hasn't found any issues.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 655bef618ea0..8f74d4bfd591 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1746,7 +1746,11 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	pgd_entry = cpa->pgd + pgd_index(addr);
 
 	if (pgd_none(*pgd_entry)) {
-		p4d = (p4d_t *)get_zeroed_page(GFP_KERNEL);
+		/* The generic implementation of p4d_alloc_one()
+		 * doesn't use the second argument. Pass it 0 as
+		 * a placeholder.
+		 */
+		p4d = p4d_alloc_one(&init_mm, 0);
 		if (!p4d)
 			return -1;
 
@@ -1758,7 +1762,11 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	 */
 	p4d = p4d_offset(pgd_entry, addr);
 	if (p4d_none(*p4d)) {
-		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
+		/* The generic implementation of pud_alloc_one()
+		 * doesn't use the second argument. Pass it 0 as
+		 * a placeholder.
+		 */
+		pud = pud_alloc_one(&init_mm, 0);
 		if (!pud)
 			return -1;
 
-- 
2.53.0


