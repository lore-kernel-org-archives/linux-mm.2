Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A08A606A328
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DblgrfJt
Received: by kanga.kvack.org (Postfix)
	id 214D36B081C; Wed, 21 Oct 2026 21:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED276B081D; Wed, 21 Oct 2026 21:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B3F66B081E; Wed, 21 Oct 2026 21:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CED126B081C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:57:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0FA86A071D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:38 +0000 (UTC)
X-FDA: 85348600596.27.6FCEC58
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 47063A0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DblgrfJt;
	spf=pass (imf25.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzZTIl9xajYqJye47ARFhIH6S/mo0DE83iMFJBmKqCA=;
	b=AUCBZyzhdDCjLBc75RgX16DjRsnRmG/PT1SSsa7/gxO7rrqoGTRdm0zrMu2Q+vnBcX/j2E
	+gc8zIH+x1s9JHy3ACdOnPKLx25uZrot29XbHf+H99uc6bD4/2ITOQmgkrMA0V+Vk7VpGe
	lASn+k4Z4Lh7F/0NxhbGD6Mwje4R7gk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634256;
	b=uKSJYFL9OKBaqzfjn6nzts5IeqDBPdUyIsmm8suTVLKM1b4p2i9Pvph5Iqw5vYQDOEud5r
	LUO19B5Nt7jndr2a68j6zRaDq2b+nBsoynqRvIAPE7pEEshR7RW37cQDsYto/qd/RpKoJY
	mM9aEUV8oBLSmQY2jFzvL8aGHJ/PIfI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DblgrfJt;
	spf=pass (imf25.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so838448a91.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792634255; x=1793239055; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hzZTIl9xajYqJye47ARFhIH6S/mo0DE83iMFJBmKqCA=;
        b=DblgrfJt2iiRmvI5sXO4jAEt8I00Ec52uPCtFiFIzPzjMRNxi7u3+GjJkNhMlugdTT
         JydYJXJu17d3dzwO963UHLODPT6dk8Ezc7y10nE5Qzgfd2L6lNYbY+3QiAN62HkXtEBD
         rjEYrrBfEHlNNSHnG7ygdvWKVN19evyZ9XTvFMyku7JeDZniFeu8vf+dNZ8LVPKJuifO
         JIzgKbNjr81ALjSK8poTktes/ozlyJFawFtHnNQGCVYwOxutbQoympeDtycgHEEqSXpT
         CdBfIvl5GSkaD7PhzVwAsuWotLo2PuFMCH4zllHCnh6xICCqdmb9Kf2INLvS4cp9mxOg
         gXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634255; x=1793239055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hzZTIl9xajYqJye47ARFhIH6S/mo0DE83iMFJBmKqCA=;
        b=1+2hzBkKbnZHMwpus/or5QkyUm11QJjKlVbR7/NQNZUcAsvwIBPYBb5f5xJTx+h1Lj
         aEt6e9SdX5N8ACUuD5mNOqlXLr3I1/2cVyGu0kZPX8tr/gyZK7eyHSmC8LqrHoffFIUn
         VdRH4A2GUNpU6Kz7sKAAczvjVMNyXI20o3kTZ+9bRAw8BhZvFDNfuBQShO8sqEtFWlFq
         Oy2rtb/B3skJ8TIO0rEIpziEPrdxZXQd2E1VVi2JG6+zNh5ccafGb0OkwnjrFA/Odh28
         4jWE6NGPIggbV7Q0PFvzGJLRnK1b/KEHr0C+T37BqoD7p0I09U+GVomLESH2y0vPGK+4
         uQ3Q==
X-Forwarded-Encrypted: i=1; AKwUvBwr0GJxgQIxzVJAzIJ/DYM4FBwgq5OoGhJ2omw6fC9BNLutdL4Sda+6MxzhAOYfZW4HO75vbyMi0g==@kvack.org
X-Gm-Message-State: AFq9FYL5gwOqI1y0CTNU8aWLTKjaFrT5Rca/LQG/ML4Iz3Rxu4QbrANh
	VIzgMsA+SL9IS0V3QyGwEXrMfCPt0CHkZbOr/XNbtpbWUoDMSqUwiPTh
X-Gm-Gg: AYBFou02bP3NSnjtjVq+yWAhxQhDqXvs/8FbO66qn7WHZ+WSYtFZYdzMEwXVUzpNzw6
	MPKPXoxmypvCzGdo7Q88cN6/WcEA/pvI7BlnmWii3yahZqZgEu+aLLsMFvSx3Pu8u9KBSClhy8p
	YT6asNMdMH47R/fVQE6txMEaj+Se9vEEQBeAlYpqlVBrsf7HUACi7jhOrSPGE+GZNHrZkTXSSMc
	QkIN1JG09l3WlGA51eOV5xXwsyIJiLabc6+zNtHrUAU13rLhuJ6JAJp8SIRkNg1y+hOZ9tYwKX0
	jTiLxRLPhMZD0Yf31g4k7xM7NwEccmp0tMt2YPKUinaLKOUY8mfJJKnA5MYsI9XJQVjh8ZsVdzg
	8rFpAKw1DrMBCS77DP93Mvhpdnp8IYKJ/xwjjR2ZQrmBgyuKAOV0MW34z7p5FzPmpTzFg0wKW51
	fY2Eh2eUuq8A2TVog2q+/per0YM1he5Fazsac8Oml1HVXcWx3dgKoaYCj3WA38ugBj9a0EDmezx
	BuPyeqODIgDfHwJucNwjtDaVElvtJM+aW84iHMM6DgY1ynwIp9dr4nSNGbPeIBLlF78jsfXYLy+
	wpibQ6ntmr0O787sBDpZuYE5To1mNyWbgSRJE9DVR7BRqjiEKEKIChogtI+Cxk/oq0Yx781bVzZ
	3i5fu1hU8EGravW4pbHYj/PH7
X-Received: by 2002:a17:90b:1dc4:b0:3ac:8897:7baa with SMTP id 98e67ed59e1d1-3ad86d4e4abmr2953396a91.40.1792634255162;
        Wed, 21 Oct 2026 18:57:35 -0700 (PDT)
Received: from coder-ast-ast-dev-ml-0.tail2dda0.ts.net ([153.61.198.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad85fa6b87sm2978876a91.3.2026.10.21.18.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 18:57:34 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	oleg@redhat.com,
	peterz@infradead.org,
	mhiramat@kernel.org,
	jolsa@kernel.org,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	surenb@google.com,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	hughd@google.com,
	kees@kernel.org,
	mingo@redhat.com,
	tglx@kernel.org,
	x86@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 3/9] uprobes/x86: Finish an unoptimization which failed half-way
Date: Thu, 22 Oct 2026 01:57:06 +0000
Message-ID: <20261022015712.1297331-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 47063A0003
X-Stat-Signature: tigcrgei357a9oir7uipkk5h8btjinj4
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792634256-126989
X-HE-Meta: U2FsdGVkX1+0zwvxtFQtBN82EHfaPxyjbJ086B8gwGMypA+4XHDMHp+IniKFHCvTwZ2dvQmdl6zPOJtVqWHWl39Uy0Ge511iHdkul1JMu+Slha/jaGG+u8P1DBU/tNJ1S91b3vN4Nv29juqde13zWiZDdP92y+WV2PU6ykOdBHnwm8DuLqiPM4VrxQEYDFwx87hdhe2cbzUFJCS5giRUbBBvD9Gf434ih8S0AFZ7MhxVeZhmBzqRD77jdCc21vOwRQsBI6OIWzEbvoJuG+CBqbqGf56UbpauO7RGvuYKNtGFcY0eCPWrsjgNuA4KrUtW3E/QvWhglHGwKuFuo5HYoXZJaym04+qL28xO92CwiEKXJffaIeHxqsE4kFrZqXyuoY+Q/7X6fU7+BR1Kyvw+Pw4yVzjcUCWOnKXfYWiCINSprvlllRSlZgZy5Aw0jKI3apiEFalacXZjp0wSihlCmjruIDLLPxv7+ilgOVAP4yJUQfTN2/1Im5wakAI5ftPsACgcO2sb2FjuCXeYfrkTzJ1FHtkxFwSKMYK/L17JmlqOHD9K4ScHxw3NAaAQ6/zFHf0GDtha/JCSIYmnpbOA5cwltnx0bdI1IOSmcmop7jkutoIAI14pXhy0xeu2OnmqS8DigIFTelXQJ910lOfK7EveBMObFX8t9FQEJR0bXdgVmrQ0RCQht+/HbbYifLFFPPcivvUZxLBurN01HlqgSIiPf/m/J9Rp225CnMhPlqFr7hkK0h69G1nz6vlnmjZM/SHk0XUh87X/hj/iK3qVrFNJYQ7RfNexIKLXFUT7uceLDw35mPzpYaOn6LAndNL93hJMNWh7sP9IY8LBtwVhr3Xe02KPPwCsikgnEPAbMsBqef88qPewfZ0GwOnJw9Bp7MYFGpMjMSYXNFUPYCIXGhth4/UAVRGumvE77/H7vg2gG2CYXwz9uHsg13hcr0Sjjhl5VRWDBNhD2jYfqby
 zHdHnf5z
 K/Hp4+AC37HG7EVBPbTbfS+imG/QhHFrH5+cx3mqCKCPiv+ukEgWwfLg8nA5YGVIe5NzjYfTgI4KgZOCU9DnkznTUCkN/QAFztGFf4QAA8j1Kr/b7ZmSztksKY6L4lIOEqWnxOovkRtUGAIcUl5GRqaDA0+Nejd4jc2Mx38wyOWpVxytQZHXOFOHAXXTb+09O0Hx+1CY+CjUS+0HfXp3L79YOCKdPnlZEB9Jh13EUnC8Ns3eL0K6Wa52KJrMawyoIWYLBzhf/i9baXefUlHf90UUQkW26NXSOsJ2XyQBg/ra6EPZ2q2pjPzeKvwyoH0YycgL72fW3FbERNai3is9o+0LR1ZOC/86nxqhJFGX6Uf0GdjhCXz64LqrXctHpV5Z3jl7AB3qzdtBhe8Usqrq8LJa2JOMbDtGFCMbh3ePNIcuhfHcpqYKXo6j+k8mUbbTLe7oFWCq41x3Kh2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alexei Starovoitov <ast@kernel.org>

int3_update_unoptimize() restores optimized nop10 in three writes:

  48 8d 64 24 80 e8 d0 d1 d2 d3    lea -0x80(%rsp),%rsp; call tramp
  cc 8d 64 24 80 e8 d0 d1 d2 d3    1. trap new entries
  cc 2e 0f 1f 84 e8 d0 d1 d2 d3    2. restore bytes 1..4
  66 2e 0f 1f 84 e8 d0 d1 d2 d3    3. restore byte 0

uprobe_write() can fail with -ENOMEM, or with -EINTR when the task is being
killed. When the 2nd write fails the result of the 1st one stays. Byte 0 is
a breakpoint and it works. But the next set_orig_insn() doesn't find lea in
byte 0, takes it for a plain breakpoint and restores one byte:

  66 8d 64 24 80 e8 d0 d1 d2 d3    lea -0x80(%rsp),%sp; call tramp

Nothing recognizes these bytes anymore. The process keeps the call into
uprobe trampoline, which can be unmapped already.

Teach is_optimized() to recognize the half-way state, and let the 1st write
of int3_update_unoptimize() skip what is already done.

The failure wasn't reproduced, but the state can be made by hand. Attach to
nop10, call it to get it optimized, write 0xcc over byte 0, detach.

"uprobes: Don't sleep on mmap_lock under dup_mmap_sem" needs this. There
fork() removes the breakpoint from its mm. When fork() is killed in
the middle register_for_each_vma() removes it for the second time.

Fixes: 554ba38456da ("uprobes/x86: Move optimized uprobe from nop5 to nop10")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/x86/kernel/uprobes.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 65a2de82ecd2..62bbe41c6466 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -896,6 +896,9 @@ static int verify_insn(struct page *page, unsigned long vaddr, uprobe_opcode_t *
 	case EXPECT_OPTIMIZED:
 		if (is_opt_insns(&old_opcode[0]))
 			return 1;
+		/* An earlier attempt got this far and failed, nothing to write. */
+		if (is_swbp_opt_insns(&old_opcode[0]))
+			return 0;
 		break;
 	case EXPECT_SWBP_OPTIMIZED:
 		if (is_swbp_opt_insns(&old_opcode[0]))
@@ -1109,6 +1112,17 @@ static bool __is_optimized(struct mm_struct *mm, uprobe_opcode_t *insn, unsigned
 		s32 raddr;
 	} *call = (struct __arch_relative_insn *)(insn + LEA_INSN_SIZE);
 
+	/*
+	 * INT3 followed by the rest of the optimized instructions is what is
+	 * left if int3_update_optimize() or int3_update_unoptimize() failed
+	 * half-way. It works as a breakpoint, but to restore the original
+	 * instruction it has to be unoptimized like a completely optimized one.
+	 * The same has to be done if a debugger has put its INT3 on top of an
+	 * optimized uprobe. The trampoline can be gone already, so do not look
+	 * at the target of the call.
+	 */
+	if (is_swbp_opt_insns(insn))
+		return true;
 	if (!is_opt_insns(insn))
 		return false;
 	return __in_uprobe_trampoline(mm, vaddr + OPT_INSN_SIZE + call->raddr);
-- 
2.55.0


