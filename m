Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BBDFC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3816B0098; Wed,  2 Sep 2026 02:46:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1B86B0099; Wed,  2 Sep 2026 02:46:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1AE6B009B; Wed,  2 Sep 2026 02:46:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E00FA6B0098
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:46:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 742891A0769
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:46:05 +0000 (UTC)
X-FDA: 85167887490.14.FEC7B16
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9B81214000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:46:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jq8va15O;
	spf=pass (imf09.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788331563;
	b=Sza9rMo4FLUOiOen+yD7pHZ0BgcTJ/Hus254iONFAMxhq7GJq2/otm1aIIzgPV+b3jSOQD
	xSUL3mx99lZ6ChAYAQE+Iq/uN4/Z4sH4iq4Jj4TDRzDwo81AzIzJL9juU1b3k2LiV2N9pH
	7A3C9EdTMk456gwTEt2bKcPiytBQ5g4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jq8va15O;
	spf=pass (imf09.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788331563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yy14lSjlqIlp7/ZhnEryZaSDgqy5+mYft8l+OckZzk=;
	b=6eolr35ylEBuL84Dcgt3BVAFVxRq9RR5iZWxvBNhgju56asAoeHbITHe6mxbaBjbyf5vek
	cRGnSueAmP5Ge6usScZsNRQOyaDS3/gos9qv7VYz0q1NHqoTgfGq7wzdDolB4iHvGnkDs7
	oiWrWIx20wijoGHoNeNDnEq6uP4WWqc=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2d72ae08fa1so5671795ad.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 23:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788331562; x=1788936362; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4yy14lSjlqIlp7/ZhnEryZaSDgqy5+mYft8l+OckZzk=;
        b=jq8va15O9aYfgxW6fPQS7N0/L0TQ2vJoOrkdtdnMNNUq99tHv5vePp/vCO1Wp08izV
         Wl3eySyIdkPNYii7ITEOQqqknRBjH42e9hoTFZhVay25dDfIvkOYfiw6ujVSjmrmNOsq
         +mGi0HVbjPkIBEkC+l9tGzUGLNY0/DDBhVgRBCsQ+fIyAUcIoj2BoBb4NERgTO3EeQ0l
         rimwaM+yAV9iLNf0qCvXn6M6qTsYnT0+iwO0kx8NHAW+dLukE9iCKJdTdqQ+a2YH4cBM
         sWXdHjnHmF/vb21+XGKiCO9W/Kzg2L6b6StlBHEWQPlXxhSwsGCN05ytLTob1bz5ZnZ2
         A2NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788331562; x=1788936362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4yy14lSjlqIlp7/ZhnEryZaSDgqy5+mYft8l+OckZzk=;
        b=AJCCBpXpjglDK6IVI+WumpLvf0Ts1cTBBAaX26FrYCkFpM7RGDngkiH+hH/K2iu63R
         wBF8AjtLHKGLgVmqcI8czgcY1ibYfdMpLj9aHEWmQ6+uDkM0zqouXlsVYgmXqMNh9/Q1
         lNPDUpNKcpoELVwXz3lRCuvDNMo/98OJb61t9aAVQ8F97VUi4LvsjaGvildKmBOIh9+h
         HlVg2Hx03fSxOZBOixP5LkJN4RuBNNef9pYAnky9+QZTnqmYQvFlSRCAjYKBObeVrc1r
         afiRvsyS2L/p9oqhVDvalaXBdrENoqNuTG/IWdSUzrtn/v+nbFhngEX/Cj39nC3iCoe3
         y5Hg==
X-Forwarded-Encrypted: i=1; AKwUvByC/LM79bJXcr6/Y9LmTOujkCeYy8rS840ZyNDif+qm7qfBEu9LAeNWFkh5zFjmEq2byVdTolhUsQ==@kvack.org
X-Gm-Message-State: AFuF++nJKxnzMuUfO3eqVWgDTf9lG96UWl1sPqCJRhoo1ACXXY7TEFAD
	ydGH9tFin3O4IoQGp8gqVmY0taUDLWo4Ah3rlsO26ZAWZUX7FsKoq1jU
X-Gm-Gg: AYBFou0nNKmxTInGhDEheuhR4MSQcKtq2vzwHPRA0g8GbWpWLiKqA+laf4pV3llxWi4
	Ay5HUtAfReIyLxr59UWZzYujOnHkGHqy/YgM4GN7xtJ87wRapmisXwOCAtmrUB7UV1wU+pcIn+o
	IOBHj8MgFJXJgZt/4C4xPIbSeRemcWyO2S6BNZUYaQGOCW+XKPuitTMDwmuN1kjp5+pAq8jMeY+
	pfyY5pPmti2+rx55X+NwuS8ZiszLt+WnJ/B0fAGQyXJEAna7qSfmmqA5oSbeMjw4NC0O4taIos6
	1gvzExhbB6+4KuzbYMmvY82m3FYhIB09+mO9gTsyeWZOPBpdIpgOpZiHJaIQBILK66pR98z9Fl7
	peuw08m3o2cY0ogyL3bJgVo+7td3fAhzIcfd7UaE5mmCUwHpnFNuRiL6FWGTCSLGTvnWIPm7umg
	lZThbmgSQCKXDJnrIBm8KMjfEFOiSjPc5AqBUiGQ8wUOD8w63N+YZty9d+NZ2Ify4pYS3/oiANW
	kp2kYGq4rWSKpGY
X-Received: by 2002:a17:90b:380d:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-39aedc217demr3311370a91.0.1788331562371;
        Tue, 01 Sep 2026 23:46:02 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990bd1b395sm11051480a91.1.2026.09.01.23.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 23:46:01 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Meijing Zhao <zhaomeijing@lixiang.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Wandun Chen <chenwandun@lixiang.com>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] mm: trace: name protection key encoding bits
Date: Wed,  2 Sep 2026 14:45:10 +0800
Message-Id: <1871da32001243b37147bac5af02d2f2ec64304e.1788330432.git.zhaomeijing@lixiang.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1788330432.git.zhaomeijing@lixiang.com>
References: <cover.1788330432.git.zhaomeijing@lixiang.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B81214000A
X-Stat-Signature: f4bc8dnzgre9fuzjbfntua6nbp6ttnpr
X-Rspam-User: 
X-HE-Tag: 1788331563-575700
X-HE-Meta: U2FsdGVkX1+d8pJJlZEvTNtYQajE2EmDvQ3iwsbghnFzQQtNI9LgqSiU8YSGEq0ZUgDd207B33ce0b0f3uDgkmSfNN6QwJdVu1p7QWCqgA4Q2Xh+4YSFuuWbtTFU8pKDDDJpBUl/APvOqJ+n2p/OcjNT1as1HIcWE5kDRKDB1MLxRMAir0+mk9frmG6d9ixsG3Jyh2GjhXOr2pf+TnIA0pHz68n3k8YX3ZB6BqobyN//uOEOcImJtJNXGVoAS0lU++jCvhigipwuhRFbZ77qnueBZ9n52JmChw+BnQTe0nubfnPyEoT64k4cGbZnN3fah3SRkts55HnXnDpC5de6EgGxrtBJ9cQVa0Svgn8xoI024XKR3Bx939gQFmSSS6pXJYMSHivqjoK+AHmvsoho3ZYzseZ02KMJjFgD6y4tax3v9QBam0jykFPbW49O5x0n7RgXohEb8rTNp7OrCxX4MGuuvDTgKRLjh7mX1OE8Re/jnGcKDjxk6CJolBnkNwAxIeoHf2hTr/gxL+qdjK1JqqvCeJ8+KtyuxxwFB4XyotDuqPr7vxlhSGBsuYwyLnoSk9+vDDpHoA3fwSJ5mcwKj/eI4GakosM/WgUjz/9iSzuvI2hwCi5XFhZHEzPbaFVFTkPZ7+8jNBzQsyLWD3zuABX42XFU41xC3Pu2PcHoiu2zBqfJvo1O6XcNplas0jF4ENFt9ptbyvqdKje1E/fee/X1y0jI9YU4V3eY5AdctdPj7icM7br2Mfc3z3sDmWLyG9ltEAfWXCnu9WQUvEM4TMNXtz8kbIM95E8+XSkYLxob/6DAVykKjJxxiCgt06xAosSbb+PDp6GPZ744xTKUMJfTrQPSmcQU04ned8EGLlFioyEtSjlWYOH9ZGcdE3qskYplPwAaX/3m7BiYtINB7raVw1HyFIhkydJDVCmwN87O8lKfWT2V25+o/QNbAbz/sEszdwImfZOiPTNZAdb
 BY5TfPbn
 7oPd7+geUrxtqVa0ht6LCBa2xJhRHkLdPdqHdbw+C4z22y7zdJTZrelrtwtUe/Fw9A7W6tM+FtkXCzklK6OWUV8p03jSThToc1Al7eFHIJz/JDunBYIEBN6jbDUIN8zUvrd638PlQeXUJFgHrJTCpfLq0JH3yhSGgQRcIE6dAgh2jkW0WBNe6JwL1/U74u4iH3LDKLutELM+7RuQ3jBR6cNawedCm+0e2mbjmRqf2mer2T8Cwb91YLR8Ira/V2Ke6R5m6CTE+ocV9uBErlDeDlmOG/UbF0p3zEHAF2a2VaIM6iR0s+WTFxhqKshoCKML5mlKulmafYw5ITjDdE32IQ2f5rC2IuC/+CAKXU+L5pIdkJjdSxH2aXyyWRTzv9GnJa+8EetMpOF3f7b3wwcmvnde89FwY9+QjbO4baegMryDFMJWfD5dBc+YkIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

Protection keys are encoded in architecture-specific HIGH_ARCH_* VMA
flag bits.  show_vma_flags(), which is used by VMA tracepoints and %pGv,
does not name those bits, leaving them as raw hexadecimal values.

Name the protection-key encoding bits pkey_bit0 through pkey_bit4 under
CONFIG_ARCH_HAS_PKEYS.  The names make clear that these are bits of one
protection-key value rather than independent protection keys.  For
example, protection key 3 is represented as:

  pkey_bit0|pkey_bit1

Honor CONFIG_ARCH_PKEY_BITS when exposing bit 3 and bit 4 so only bits
provided by the architecture are included.

Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 include/trace/events/mmflags.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 2f980d20a9f6..ef9aa388b84f 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -202,6 +202,24 @@ IF_HAVE_PG_ARCH_3(arch_3)
 # define IF_HAVE_VM_DROPPABLE(flag, name)
 #endif
 
+#ifdef CONFIG_ARCH_HAS_PKEYS
+# define IF_HAVE_VM_PKEY(flag, name) {flag, name},
+#if CONFIG_ARCH_PKEY_BITS > 3
+# define IF_HAVE_VM_PKEY3(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_PKEY3(flag, name)
+#endif
+#if CONFIG_ARCH_PKEY_BITS > 4
+# define IF_HAVE_VM_PKEY4(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_PKEY4(flag, name)
+#endif
+#else
+# define IF_HAVE_VM_PKEY(flag, name)
+# define IF_HAVE_VM_PKEY3(flag, name)
+# define IF_HAVE_VM_PKEY4(flag, name)
+#endif
+
 #ifdef CONFIG_ARM64_MTE
 # define IF_HAVE_VM_MTE(flag, name) {flag, name},
 #else
@@ -250,6 +268,11 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
 	{VM_HUGEPAGE,			"hugepage"	},		\
 	{VM_NOHUGEPAGE,			"nohugepage"	},		\
 IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,	"droppable"	)		\
+IF_HAVE_VM_PKEY(VM_PKEY_BIT0,		"pkey_bit0")		\
+IF_HAVE_VM_PKEY(VM_PKEY_BIT1,		"pkey_bit1")		\
+IF_HAVE_VM_PKEY(VM_PKEY_BIT2,		"pkey_bit2")		\
+IF_HAVE_VM_PKEY3(VM_PKEY_BIT3,		"pkey_bit3")		\
+IF_HAVE_VM_PKEY4(VM_PKEY_BIT4,		"pkey_bit4")		\
 IF_HAVE_VM_MTE(VM_MTE,			"mte")			\
 IF_HAVE_VM_MTE(VM_MTE_ALLOWED,		"mte_allowed")		\
 IF_HAVE_VM_SHADOW_STACK(VM_SHADOW_STACK, "shadow_stack")	\
-- 
2.25.1

