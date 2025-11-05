Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BACEDCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 23:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E53B8E0002; Wed,  5 Nov 2025 18:02:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 648098E000A; Wed,  5 Nov 2025 18:02:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534088E0002; Wed,  5 Nov 2025 18:02:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2DF8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:02:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E0AFB9D39
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:33 +0000 (UTC)
X-FDA: 84078079386.02.D6A05AB
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id F138CC0009
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 23:02:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aTYdomf4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762383751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tDmiGouP/lZqmqIQ4xLpqbP6meWUNvUiS6WQT0r7JQ=;
	b=YjvF2b2gmhxW/23FH95Ar3FHXpziX2HpRX+XcGQMQ0fXMzVY0hTb1cFPp3B8coKLoCw2GJ
	tcvdzC/46KVcZgTajIGYlst1o7UzTGTprkPeJj3w4V1HyI2TvYbewBJ3QvUzCTHEVLgvMr
	WWOoRBHoHGz6EFyp5Jf/DedCeSOYa0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762383751; a=rsa-sha256;
	cv=none;
	b=j4ZUYiZJIMMMZu9DKjt310ZbJUvDD9VpfYbOx5uYJJDaBLnAYKfpXLk3njDoLExlue2JGJ
	ZP4hYIJxYsn6Yi65Qr/PR5QlSzkHubJJKBu5/7cTgWVNZgkZdJn4DPrrfx7es4a1JXIEc/
	1aKrpyS2VEQx/sFpQH1o9Uml+SjZ6Gk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aTYdomf4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b996c8db896so288235a12.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 15:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762383750; x=1762988550; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8tDmiGouP/lZqmqIQ4xLpqbP6meWUNvUiS6WQT0r7JQ=;
        b=aTYdomf4RcyymKTNdrV+uQTzoCxwvsA0nWfNEFiiIn1pD6mFl244dpMiLbiQFtwFPZ
         FnYd7gApK5Ho7M0A5joatVuD1GgtJPkaMaerBGCW/0Qmt3F5GswvnElPNHvB3eysRNkp
         Ah/iRLsLRcmyWNEmTSSOwV1LNb3GpZ0tIlRZ3GDOJuij3UL2b/R/NJUN4C374ZVstAwM
         TLa+gV3+Q8WIA4wr8XjFJ+l7ZuyBlPUrIOlDLFlW3J4PwchGnolLGQvIVGISAc1HKTY+
         K0n92+XxbNsfAlDDB6zvyDltB9RQb44NkaDMMPDwVH62D3BijrXpqmkw80pna2W+pIPi
         KRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762383750; x=1762988550;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8tDmiGouP/lZqmqIQ4xLpqbP6meWUNvUiS6WQT0r7JQ=;
        b=TexHqmbobbXCr16PqP1sKfBJbNk9s4tQuO+cEW3W8+SCcjElATwTfnRcCE+bDNitnM
         eVgaFQUX024jDxt9PrVfbz/J/odMbfO7qrR7D2eLxBNwhx9Z12Hh7Fjsafam5FPClA3D
         xm5fGeY56lTq52u2GuuktkOUVlxgwR5y2DXImIbaEkNctyXGiAUFRDFQrRmWTEwUYbym
         mLrEe20voQF9CRxSUuGISg4J3P/PDI715s6ESSPWXSX7LG721kOKgmeuymljUU7cMBtA
         kjrzba2vzYcBbSShIvss2oAZeFpIDN6qUSgZdb58jm0mtjA1CUCK1T7CEbb7dtjeyDbf
         ro2Q==
X-Forwarded-Encrypted: i=1; AJvYcCV6T+g7AEeq/QGhCg0Mpy6rcX338AGDD1q4yWu9dlo2ygU4ehC3/RoRztugh3HI2bt/5TgS9CLFQg==@kvack.org
X-Gm-Message-State: AOJu0YypjWZpwYzF1sCzzhH/LrtiFoRLWwLR9QP8hb1NmrIhgFbGJSS+
	V/2vc5Dlb401x9bDAkrC3lNK025fitWvt19aKya8/ZwdoBmTZwU2d4vP
X-Gm-Gg: ASbGncuCvHEFknDkGrENlPtJc11qNEjGjCAj/lUBZNoX8Fdo/BYEJX88M0E5yU/rINv
	rL2/XrUVbSZArqq1wcNoOT7xmJXTpvIWxzgVhyo2NI8s6UrJjF+xg9dpVRqK4ExSeP5DJyiKZ1W
	0KJweD4/T+Df6BFBRFOwxiFZSb9ehI5G1ruTqe6kAIeMuto72DyPPuaMkYWRmnYa9HQqf8vQOJu
	5oFmgEdSIDYjpPqagy9za9iNSRDtNQ3cfEhWXM9H27TcJAtqJOsUFDvsj+bg+frB8aAp5c10OYX
	vmXtukICatmAL9auX3F/t3S97cX4POoFCOz122HmuHQe00ItKzxPcuhwA6sZ0099dpihaYBCykL
	RVWC8d+6MIQeCPPwQE6z76U8+nwqfozUepVs0Fhqpod+tCRwn1+gC/N3GyI8xD5VaeT8XztEB5X
	s1AeWdFtA6tiPuD1fETzcqTnk=
X-Google-Smtp-Source: AGHT+IE8H0NdUg/c/thzQbZRKZeZtzM2gt17e0QQN2RbXKr1KgVctPF1CYPo5o3JzV+1jhxViXCLvA==
X-Received: by 2002:a17:902:d501:b0:295:34ba:7b0b with SMTP id d9443c01a7336-2962ae0fba9mr72522505ad.35.1762383749590;
        Wed, 05 Nov 2025 15:02:29 -0800 (PST)
Received: from mitchelllevy.localdomain ([131.107.147.147])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096839asm6325645ad.13.2025.11.05.15.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 15:02:29 -0800 (PST)
From: Mitchell Levy <levymitchell0@gmail.com>
Date: Wed, 05 Nov 2025 15:01:15 -0800
Subject: [PATCH v4 3/9] rust: percpu: Add C bindings for per-CPU variable
 API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-rust-percpu-v4-3-984b1470adcb@gmail.com>
References: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
In-Reply-To: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, 
 Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
 Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tyler Hicks <code@tyhicks.com>, Allen Pais <apais@linux.microsoft.com>, 
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, Mitchell Levy <levymitchell0@gmail.com>
X-Mailer: b4 0.14.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762383744; l=1564;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=RzgX0CxF7lpE2xBLdNMOZqdleGvbOwroWvnQQx0XUzQ=;
 b=BeCtd9F7suE7Dhq3+o6ebU7TlEj99UaBn9HqDmYOGvEIlw2BwbjQ9A9aTMEUtVsnUSdALbpNh
 qiE95luFKqoDYzljVg+qh0guvKUgr5gg+ZhgEeKyQjxdMCVh5yTgo9e
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Stat-Signature: ahm4drrkhx646ch67sho13m189yfq91t
X-Rspam-User: 
X-Rspamd-Queue-Id: F138CC0009
X-Rspamd-Server: rspam10
X-HE-Tag: 1762383750-928203
X-HE-Meta: U2FsdGVkX19Bqg5F5PrNTRItq3VPamaTNwTrpgCcJw3qHWugOO69IUs4wBrM5lgOsjbCcRBPURmMQyBbmislxidiwSvdg8kef79BmWxv06vGQdCSby0kTyF2cB+mZXeN12O0m9O7mXhn/ExtXcRarZel4TwWnm5QmHHYZ8Wmx/uktZL12BxiH5hnI99DZGgIlO7hCZXRZ+KN4tOtR1Q76l+G3LRBZi1JHV92cWS8/dIIiSEUQ5HnV4KAZVs/gmXICOZU3Vimgsrb2hic9SwL+B+LLVaJOu8mZGwhma6MwM4o/2x07VpN8eYcdexwUDWL7ZSR/Z7bFA6cWto7Y9HXE4cAqly5G/3u9iutOoTSbvbNb4VnMwcmgQdVvPLnoS1qcUSaauQZ6grsyCS2U7Foiqi811KmWMkrUpSOECEyAb4oI+KPc0YyAko/ypLCO91WoPee+hW+SvrR/uDMFypzb6N9u7x3ybXhOkD69voGq3hwxdeqOHZAIZmXdUrn3kRw708bIXpqPZhNrWbvS/IqcMMU/q7w3c3yguhGhiw+tYcF4PYRR7Pb0HyWwK3DeP1DIXHYss7kvNajsjGnATSYh88PvxgvGcF0iZJbtkM9Y+1zzr66QgeJRBPfIzuUoEWsC71h6AXFFhqHG1FMNYxz/3cHYBy8I72HTem5rRYOGw8o5XidmRv7AMWvTykLHHSAvbRI7HhcHWfB3SAdNkef+qsJCSdAc0C/pYXZkUeI/u9rgdwnxS69DOlw1my7kNVlFafSKbSl7xaXCjm24pqJu86KAWutRbQ7l5UY6GmprbWLkpnxxSXjfWisY/jtoEfzO0pM08CaiTpmU5kFJNT53R1Evx8ml11rw2QxiE8+ot+g3y7rCGzfcPoDZYJnxh4WLRBN66O5NrUCaje3qp05O1GrhIOArVCin5raeOtntxtipMA7BuS4XeW7uxReMexbUvBZRrhTjZz1G21iSx4
 pKH4dBIw
 wpX/KAw+L3JYL2pSj+5hfb2c240Ssys8fxHADLp1jO56hm+hKXezBUGk5AmN2ODAxEZ9tCzuG1cm+7jykJGS85RqhYlPsPK3cM3lVutqEhU+mYxm7I/ISacJ7kX2Zhk2DVl7v65jtpOT1Irpxtf/ZA720uPKa5LlF6z/BBNPYm57Wwezzi9I7pW4p44TGAe1dscDMpv5JrxX+Dv2AB2kdtxO4MH6ix7SJltTo1OgCae2rVdGlvId+Wm3+rfRi6bRqh7oBD94xl8kGL4tbUW0yUTVWGbv2i3x3gE3r8TQRdIWIdf4nVaNazp+rHtxfREfJLvuGvl5YfIgqTzvDuBMmPcscEwU5n+i8VOlWPY1v+QcCt2n8fPRl85WHbRsk7DvxvSaswjrJoG8G5Jbo6U/rhtMeFVdIQfk7NtPZLFtvJ7Re5V6jJ33mlMT7d6l0GBuBdcg837I/fHsNOcCmxTwBdC70MN2guUyPSvhbd7nLp68YYZW3MMmAAtQAV2XRAsFuqPjJFuyBVmxGCKZcu45l8OgLFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add bindings necessary to implement a Rust per-CPU variable API,
specifically per-CPU variable allocation and management of CPU
preemption.

Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
---
 rust/helpers/helpers.c |  2 ++
 rust/helpers/percpu.c  |  9 +++++++++
 rust/helpers/preempt.c | 14 ++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
index 7cf7fe95e41d..2fc8d26cfe66 100644
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -31,9 +31,11 @@
 #include "of.c"
 #include "page.c"
 #include "pci.c"
+#include "percpu.c"
 #include "pid_namespace.c"
 #include "platform.c"
 #include "poll.c"
+#include "preempt.c"
 #include "property.c"
 #include "rbtree.c"
 #include "rcu.c"
diff --git a/rust/helpers/percpu.c b/rust/helpers/percpu.c
new file mode 100644
index 000000000000..a091389f730f
--- /dev/null
+++ b/rust/helpers/percpu.c
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/percpu.h>
+
+void __percpu *rust_helper_alloc_percpu(size_t sz, size_t align)
+{
+	return __alloc_percpu(sz, align);
+}
+
diff --git a/rust/helpers/preempt.c b/rust/helpers/preempt.c
new file mode 100644
index 000000000000..2c7529528ddd
--- /dev/null
+++ b/rust/helpers/preempt.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/preempt.h>
+
+void rust_helper_preempt_disable(void)
+{
+	preempt_disable();
+}
+
+void rust_helper_preempt_enable(void)
+{
+	preempt_enable();
+}
+

-- 
2.34.1


