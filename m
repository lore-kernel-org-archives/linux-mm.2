Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 418C9C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:45:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591DF6B0095; Wed,  2 Sep 2026 02:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5427E6B0096; Wed,  2 Sep 2026 02:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A2F6B0098; Wed,  2 Sep 2026 02:45:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CEF16B0095
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:45:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C1F7C0763
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:45:53 +0000 (UTC)
X-FDA: 85167886986.05.A5F8DEA
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id C087A20003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:45:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sGU9OboO;
	spf=pass (imf03.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788331551;
	b=3DOks7Qg+zS6D/5kMungIJgfI3mKTpCV2duwxvH7eRtCWqLXDO0GYhm0mcoTfTVFmmOk3Q
	OBfZRQAdPtGs5TWrOm7nUz5zSxelxCXQM/SPPQ/6qTT3RDjx+pKX8ITBmDhvrPdjsL1aJa
	Df22F3j6JQUocm4Ywp/iAcFlwP6DPao=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sGU9OboO;
	spf=pass (imf03.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788331551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sA++nWJofVz/EtAtHtRDwVJVg34ghqqVvTXtizuE6qM=;
	b=AdmHK68uNjKSXug9bua7QpUU9F/+Pbl7k2XPxlzLzi6SN7qqg5rDjrxw6R1DqZv8Sk3Jaj
	pr3e7k5AIakPX3Q9MLQDlCq0ZVf3yhPWM0tXyUmQ5M0PDg3OddiOAd4c+nFUUSacL9jlYN
	CVRZWxQjLa/xlLJcEe+GQ/WCk59Wzoo=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso1046006a91.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 23:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788331551; x=1788936351; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sA++nWJofVz/EtAtHtRDwVJVg34ghqqVvTXtizuE6qM=;
        b=sGU9OboOY5UsEzWYLc4uA9M3gRvXKjU9/zM+635/mSLe/pEVVXFe6lIwqUrjQbMs+z
         czgaUuZw6m/y0E47tdu4t7gh17psC2hf+bnhzXlODNcx9IF3aujWL82bH9LA26OsGTkb
         DI2ecmZLRZhwT4RWX/TbmtYr4mJcgghreun1fuG/yakxWFuhXzy5/QEQsX4ifPQY7Iar
         MU9XFl2ga8s9DZwI0zhck/i1Kdr9Lh6hZr8/OiRUgdCnVFIYsy8tZ2f+QaIVHWXEWe18
         bd9tsZp8gJkseGrk4VSgTZxDFrXj4Djnzx7T6sSaYhxRsGhuwGmECoq3uMPBT0Zr751c
         CIyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788331551; x=1788936351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sA++nWJofVz/EtAtHtRDwVJVg34ghqqVvTXtizuE6qM=;
        b=NWkPFnLPxL6tjvhzuqt80XDY6XD26m8fBT3+OlgryCuZVT/FnT8Is87kvZnBU+kH8L
         /Z2I57kcFPZMHQ6kQxugnf/5eFwSKfv53+TZw87GP7d9rx0vOPWYHolR1lKwwpEVgmfq
         6m7EUtsM8gN0ftjsNgVa9QSX6RFyUGJTgCm46NTtEEuWU/XGALHvCJYQYI1RIfHi92If
         45l+Yq1EWqk9vvYaNDOxgVckK1dirtjQFYlF3vkdKYdGCzXONxLaJseWsIwuAWYt73mw
         9b9DGlCvo4OLg+BiW3uHlSOuHFmB/PXv0ltibK/qzOcc9MS1GsuZTB4ciwxPUUnF1ZSC
         wwvA==
X-Forwarded-Encrypted: i=1; AKwUvBxXK8yOJfeUMzV65Py/rxF0LU2w8MwEXuQ9+W1kVAkBM8lzzw6/QMIW2Jyd1LRrkNGyfRGQdmF19g==@kvack.org
X-Gm-Message-State: AFuF++kD4iSESfDqs7Sf7FLgHSl7qkUQdxfa4y5ygwYRniUCokMpAUht
	2tmhjVuum7ngt7z8pqaeaWMLSqRI0HlzZyOw5L8UiMaWa0AsVSj+Iee0M75xPA==
X-Gm-Gg: AYBFou1IKCoa3UcBzGEXL2Bp0aWKex+IvkroPzCyqJfkFA0SEbFWYcgyBGyq84UuMbc
	e+QtmdFZ1AJ26Zc1aysC2LG7Wfd4tOeOBI0Ovrq1JoITPpfJgsCRYu4JUZjAm8XHhOLaqjA+mBi
	tCoHcoBn+BGTTpNfzQTHOZgA/hK7B68CIn/TZc1sDnUEDidl5S1x8qnJUH6Kezp4sWGeXaC9oEQ
	lQoVSAHQqet+iaUg0IthFHczPZDAh4Q6Vez/Q3SNguarYsPG1ylq5A0X/EwFmjCjWqd/wHODyeA
	OFtgfUo8aPxEQuPLstYPK0GlNGVHK1mcYC5isHx4PVWqZQP6j4cDhwzkGJx+zOTiE/FSBYs9Z4q
	l2hpczHs+tYY6j9fPuRZdJXf/DExVZjRefPC497MsTe2DY2XqoL8Rx7W1qrXYbOBCu7D8z2XS58
	FHlcAWK/HK8xbVZcNSJcTlZX5tScHkxgYFrhLM9EsCl10iMNb1jWEW+UFX57PUzqsxkz5MCH0Y+
	4H9MKCzsJnhvJFC
X-Received: by 2002:a17:90b:2808:b0:398:9be5:b417 with SMTP id 98e67ed59e1d1-39aee1c63b1mr4243684a91.18.1788331550609;
        Tue, 01 Sep 2026 23:45:50 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990bd1b395sm11051480a91.1.2026.09.01.23.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 23:45:50 -0700 (PDT)
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
Subject: [PATCH v2 2/3] mm: trace: decode MTE and shadow stack VMA flags
Date: Wed,  2 Sep 2026 14:45:09 +0800
Message-Id: <1c7f7003cff8d00209baa8498f1efee113f5b5a4.1788330432.git.zhaomeijing@lixiang.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1788330432.git.zhaomeijing@lixiang.com>
References: <cover.1788330432.git.zhaomeijing@lixiang.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qjhhhytw5d5yhfkpzdzwsqdtui5egfnp
X-Rspamd-Queue-Id: C087A20003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788331551-351602
X-HE-Meta: U2FsdGVkX1/QEo+6XszbJrRFbhiBMujSKVUR2gfwiZMD4daJ9HA4DekmLqDcWHyTJWwBy7kHk5TZ+MUZsmkOWtlRrAK3LTbULvrg2bMLWlz5ctjAEBgnOCLoAcrcHJqje8Ep5nU6z0LwyIHIWZ8d1RcHrxjGBJ5UE/Axi/7oa+etVNHm55u8hDd9gcVulckznyFOzSH7ZO7O4geJd0ThHIGL4pprvAmEQ9F3MRy9EycKXM4XgSLw7XL5eu+L1jkAdV39mqdTJIvbV7DivtibDopXWc85Fpc+6b6aFv4tM8QQI8vSHWWqofnV91dFdRM95I+uoh0feCioEIUT0MHfvzG9W5I3xFORcocWXJQvnqxeMTOZIrf++HLTEm9NIVo3tI5MnyUfuOANAtyTulC8yfdYphW3oFXVSbO4tRw4+R1T5As1R08sE81O6ucs00wHYBXUs+yf/IlPR6IxlkOErzwAq7RHkEQP2XiJiV+/Uatcg5pfyngaI1tz4eZd9djpEOvzdk9OmvaI8rjhPzq94NUaDr22gQzxYIRATmiF4OihTnQnLdURabT4TS+kNu6ll9fYKSKIHHHFc3gh9BndpMIlkrUoST8O5FgGuH4F71GvjWyj1lmJTifsmCcGPU3hhqy0Pr9onvJ6SnOWY7oQb3dMVTg6/k2uQGsZI+71wQPgzr4ioc4Ply2JTVXvKSCZjJ1xnVkw+Q0iPJBFWRbjlxRd/UF/ZMXcbDu/tuXAqkfrINaW5pQth5wcoDSOJha/9udOGlxmTiImtUHl+mYaLdA/ULR3P4mllaGVqroP7WigNrV8rrKaYCdGu5UvVlWb7AKAiTev+zbDTH3Fhn42RRc2GjK+USu8EdQeiDH8s3VQjjo8mMswDUZ4F0Xo88aGrzC2WQVFWw4Y+YQ9I52f8T2MmkB4Yvu3jGhuIen3ym1eZbtjNgYHfrpP5fJdnXWPuvBRiYl2Ne6K+L/kTna
 r3sz2BH5
 0XwO6MB+wY+bf8fdBLxeQIEuXgPjbgyDRUQOCaPXjWLHDWpquo3QzkSPaauPBUPZXnZu2isCwDN9OvJaT6MQ5rHLHJHo47fZqTUCx3jU6ZIaSBjhzoewKo2aCmmUr5egK5Onf0GS8XfZsbwdjGpgESixJs6dfj7gloTAvl3hp6IKDb3idw5StI8XpN3oCitRUo0f2x6G/mViWmv7N/VBWhH05+nVffxfu8y/6yC4TLBTzcYHsFYjclRfXhOL/CJ+ERWCBefWAJ2gv5yyoHHXEu/0WhjnGD9VKZQVvU251yUE5bwH1PkdZ0LQUxMtMxl9rjynULq9U9N0jobY+DvgT9cV24tFpQolQfpKJSHjb8EcxYnKP65PnUCghdHJB3noXmqfo9yQhW/8OdpWw0UslGYm9Z3a/w4tH/NAhHv4Z2ZZbVlzZzO3izpbutg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

show_vma_flags(), which is used by VMA tracepoints and %pGv, leaves
architecture-specific HIGH_ARCH_* bits unnamed.  Arm64 MTE flags and
user shadow stack flags are therefore printed as raw hexadecimal values.

These bit positions are shared between architectures.  For example, bit
37 represents VM_MTE_ALLOWED on arm64 but VM_SHADOW_STACK on x86, so a
shared HIGH_ARCH_* bit cannot be given an unconditional name.

Add conditionally compiled names for VM_MTE, VM_MTE_ALLOWED and
VM_SHADOW_STACK.  Keep the configuration guards aligned with the
definitions of these aliases so each shared bit position is decoded
according to the target architecture.

For example, an arm64 VMA containing VM_MTE_ALLOWED is now printed as:

  ...|account|mte_allowed|...

instead of:

  ...|account|0x2000000000

Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 include/trace/events/mmflags.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 02caeaf359ab..2f980d20a9f6 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -202,6 +202,19 @@ IF_HAVE_PG_ARCH_3(arch_3)
 # define IF_HAVE_VM_DROPPABLE(flag, name)
 #endif
 
+#ifdef CONFIG_ARM64_MTE
+# define IF_HAVE_VM_MTE(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_MTE(flag, name)
+#endif
+
+#if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_RISCV_USER_CFI) || \
+	defined(CONFIG_ARM64_GCS)
+# define IF_HAVE_VM_SHADOW_STACK(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_SHADOW_STACK(flag, name)
+#endif
+
 #define __def_vmaflag_names						\
 	{VM_READ,			"read"		},		\
 	{VM_WRITE,			"write"		},		\
@@ -237,6 +250,9 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
 	{VM_HUGEPAGE,			"hugepage"	},		\
 	{VM_NOHUGEPAGE,			"nohugepage"	},		\
 IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,	"droppable"	)		\
+IF_HAVE_VM_MTE(VM_MTE,			"mte")			\
+IF_HAVE_VM_MTE(VM_MTE_ALLOWED,		"mte_allowed")		\
+IF_HAVE_VM_SHADOW_STACK(VM_SHADOW_STACK, "shadow_stack")	\
 	{VM_MERGEABLE,			"mergeable"	}		\
 
 #define show_vma_flags(flags)						\
-- 
2.25.1

