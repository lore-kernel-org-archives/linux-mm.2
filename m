Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE1F606EEA6
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=MjOO+13E
Received: by kanga.kvack.org (Postfix)
	id B97256B05D6; Mon,  9 Nov 2026 11:02:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24C06B05D7; Mon,  9 Nov 2026 11:02:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5BF6B05D8; Mon,  9 Nov 2026 11:02:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 720766B05D6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:02:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 101721C40F9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:02:27 +0000 (UTC)
X-FDA: 85416047934.26.84FD2C2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2D771120016
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:02:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MjOO+13E;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPDGF6IXWrblzJC60iTMPME/YZHsX/XZwrmc6jtde8w=;
	b=l6VYwoyFxzSh117rhEvB3pPE32BcqhcBsXBSr9anDN4xXkuwp+0SFGeCTq7qibkcyQHm8q
	67y4JfflSRckziZDCfSJnbUDHvwbkcKCAy+Gj9Y3JhtAYX831+sMQ1266oiVDR+s9MdRfn
	HkuMx0O+8P7eFS+6cVfz4AADm3Oo+Yk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240145;
	b=m3RliZJUCIUeqlAnvceAN3H35kjTtuycPLUj/oLQ2LRPOO3meyV3FoWAcqviI7NUdIVDLh
	LwTdQACPXHgdLnDQFlfmVHaIonDuGg5YxHXLtBGtmBJPoGLxvr1aQKNBj/V46pWxhmjSLk
	s6I2GUqVXn9PjqhrQFbxCAzaAVySO0c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MjOO+13E;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 586202F;
	Mon,  9 Nov 2026 08:02:21 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C6A83F632;
	Mon,  9 Nov 2026 08:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240144; bh=7lQIZULh5J1Hl9TkWIvvH26oFjy2YjVKRIp92NAf5N0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=MjOO+13EDwQFxplh8y2zy9+3siFjwxsSmc+dzoPYHyKnmN1JvLNhY/W07LEnJC+1l
	 sysFGL4K4QoHQg0D/keeeiYly5kz212yq/Zfq+xgd5tfW3DTl2WJg2hBWxPJCuMyqk
	 naaRRee+6j6TbSnsP7JfOgtcwa0AEuecMqKJ48rw=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:46 +0000
Subject: [PATCH RFC v10 21/22] arm64: mm: Map kernel image alias of
 init_pg_dir read-only
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-21-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=3031;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=7lQIZULh5J1Hl9TkWIvvH26oFjy2YjVKRIp92NAf5N0=;
 b=LoDGFEClYfGo5mtYK/pK9ZnXOnv9T2HDXy6Aj90eQ6QdUKa6c5axkQLFxUd9JMNimrSP5Ydw3
 0qkvhmxlsYxA3T1KVntwfvUbp5XSYIBU2rSgq697LjbRqZ4mmrLsYXT
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam06
X-Stat-Signature: nppeaaho7z8m49qtdoa7pt7iss34hok1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2D771120016
X-Rspam-User: 
X-HE-Tag: 1794240144-461030
X-HE-Meta: U2FsdGVkX1+4wBplvc6zf3sAXKw7eemxN+fH5KWIUqMVmFT2tQBN6nzKBSite0V84P7LKuuey0yck9dIiIxt+P1iWZ+2tCst40ZSisuACcrV72L67Ho6QCy7myK5Uj+8ap6y8QwI1VG+OKy7V3Ne3JEeRmye7fWN3nfbc5GqyOk5mFZyImKqHCVYUcwwvxvx8I4FUlXu7SjZTzYYvmFKtfRT0CdaLcGK/W5VRzKQnTjSlGiTodo3EI1tYEqAAWXXZ1XFOQs6SODoSsLFPFXYalEbtiJQe7QU6bvEhE/zoXosq8zW1J+Tip8W9CbtiPAwHAKwmHWd0g+9ORRWEIC8fkm+1WO+2xPxXpQhjrGRcwRM2JTlw5PFddjO7pFV8PiduT38XloLNHiMwbaGVlb0rqKawOhsGoalRIW+vJvOgg+OCwbS87uBK73gI9Dg92n1IAiJqqpq1lxOn8i36bx9HkmoQ5a7DwK24SGNcdK/FOotC+mjksHkqhCDnG9Qpm0hvkdIFkYmdkujvDcQt5Sv+PU7eqh1MlRH+0t4DfZmxg9sWl+wGEiASkVT+xGOt2+xuRsGmrbcZmV2ZURFNNLiUcWqIkpkKjH8DzIaLF1AyGQTydCZXLMXsZsDT+GW2NQTZPs29xVeh3aQp6Dh0lcAaNKT/blnuLCm8uH+0A1XfRkrY96TzmThZ86hJMYs+aN0Lilv+AJAjiRELwm77qFLwa1BnAswiORBzm3aaQpPfeKMXkp/+BNP/AsJpMvgtfZBe9KLAjiso74FWF7mY6qTscil09DOuQkoSktoNh3cqMYvpKV1u4ay0EQv1zCy7PtDyRG6T6AxhYOhxjSKJSGDbbkuaZtxDwPV2po23zNcV84eFS3pdog1kr09M1sGP+C+xe2SOFz7enQLBeOgCo34ocj1Q3UUt6oTRYTlT2Yfzbo3kf79hqo7CIXglAaq0Ab+PCEowDK9ruA+XEohnEA
 bGgctI17
 0YlqNxP6ygsqSYQiiMWMwzHToxwu9Yrdziy49Yy1fSjlsJkJSzzv3gPUKq2fcFA5OR7j1MMRrOhLfRgFrNPyovzH6ZyvWdUcIRAIVBx0M4OInJczUAqeHDz4i7gY42vd3xqS9bDZzoMcDUdbVTSe0nDXvRvxPGUeyrAGerwFpJQwGMiyOnBg3Wooovsm5uBGi+bYw611onG/E/FNa3xd760pb1T1+I6/jOgiPHpOL4Ja9FkeG/sNC/WbJETkDlCmcbtVzDXN7rcCu9FZXQC7XeRkIiTNKMWMpZzOA4bv8jzIsg4q6gArAF69F2h/KgxGWY2AIGy+22P86JAM44ybeGAIj7hGvhUb4oVOSGFS6Lmka5/vDh7Is8klbpjkxCE5qtGfUp0LNZVCIYoPmPf+9oxtGO2RoaKHTCGEm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Page tables in init_pg_dir are always modified via the linear map.
kpkeys_hardened_pgtables now prevents arbitrary code from writing
page tables via the linear map; map the kernel image alias of
init_pg_dir read-only to ensure that the kpkeys protection cannot be
bypassed.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/sections.h | 1 +
 arch/arm64/kernel/pi/map_kernel.c | 9 +++++++--
 arch/arm64/mm/mmu.c               | 8 ++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 51b0d594239e..dc961cf67168 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -23,6 +23,7 @@ extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
 extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
+extern char __pi_init_pg_dir[], __pi_init_pg_end[];
 
 static inline size_t entry_tramp_text_size(void)
 {
diff --git a/arch/arm64/kernel/pi/map_kernel.c b/arch/arm64/kernel/pi/map_kernel.c
index fb44cbdd2f29..81ca3e98f0f7 100644
--- a/arch/arm64/kernel/pi/map_kernel.c
+++ b/arch/arm64/kernel/pi/map_kernel.c
@@ -92,8 +92,13 @@ static void __init map_kernel(u64 kaslr_offset, u64 va_offset, int root_level)
 		    __inittext_end, prot, false, root_level);
 	map_segment(init_pg_dir, &pgdp, va_offset, __initdata_begin,
 		    __initdata_end, data_prot, false, root_level);
-	map_segment(init_pg_dir, &pgdp, va_offset, _data, _end, data_prot,
-		    true, root_level);
+	map_segment(init_pg_dir, &pgdp, va_offset, _data, init_pg_dir,
+		    data_prot, true, root_level);
+	/* Map init_pg_dir separately as we will remap it read-only later on */
+	map_segment(init_pg_dir, &pgdp, va_offset, init_pg_dir, init_pg_end,
+		    data_prot, true, root_level);
+	map_segment(init_pg_dir, &pgdp, va_offset, init_pg_end, _end,
+		    data_prot, true, root_level);
 	dsb(ishst);
 
 	idmap_cpu_replace_ttbr1((phys_addr_t)init_pg_dir);
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index c1e3260bd0db..b6a4371dd03f 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1267,6 +1267,14 @@ void mark_rodata_ro(void)
 	update_mapping_prot(__pa_symbol(_text), (unsigned long)_text,
 			    (unsigned long)_stext - (unsigned long)_text,
 			    PAGE_KERNEL_RO);
+	/*
+	 * Map the kernel image mapping of init_pg_dir read-only; it should
+	 * only be written via the linear map.
+	 */
+	section_size = (unsigned long)__pi_init_pg_end - (unsigned long)__pi_init_pg_dir;
+	update_mapping_prot(__pa_symbol(__pi_init_pg_dir),
+			    (unsigned long)__pi_init_pg_dir,
+			    section_size, PAGE_KERNEL_RO);
 
 	/* Map the kernel data/bss as invalid in the linear map */
 	mark_linear_data_alias_valid(false);

-- 
2.56.0


