Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B31C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 14:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DB66B0358; Sun, 16 Aug 2026 10:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BF4C6B0359; Sun, 16 Aug 2026 10:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D46F6B035B; Sun, 16 Aug 2026 10:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F01086B0358
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 10:23:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 616C24056F
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 14:23:08 +0000 (UTC)
X-FDA: 85107349656.15.B2994ED
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 872B4C0004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 14:23:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OVtYM7I8;
	spf=pass (imf28.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786890186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V80z3viJi/1rXBOV+LmIMGbRsmAIYZLeea8uFd5X4Y0=;
	b=Ms6mGRjXKygu96ESg2CdjtbehXSAd/gGnZq8gMPhLk4GCcQmlOPZd9v7QeR+J36KDtrr9d
	/EE+iWJ1r+oKtmGKKixiQ1cJkQ5TtsDO5/h4EGxhHCiCIVCUQXxNu+vcUcJP3aAAS5C16X
	CxGesesvYg/3DVqUsKanbbVBuwJAdX8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OVtYM7I8;
	spf=pass (imf28.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786890186;
	b=5nN8LK9MfTQCldTlljTmBi19AYWji+eZMCT/7cT4VgKmfdqjLMHv1QKelJL+8oN7j4xGlt
	fx3DkVVo6GX7IR8xvZUZWG7VQfZGjrE1iZb9DPOeSxez9w71O1ZgjzHkQFTJWimVgapO+o
	3W/Xaole7lUIb/RwWss+z/GxW4dV3VI=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cca0c5799eso23060275ad.0
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 07:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786890185; x=1787494985; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V80z3viJi/1rXBOV+LmIMGbRsmAIYZLeea8uFd5X4Y0=;
        b=OVtYM7I8cz9TX9D88FPHvtqgv3a5Gs3Se+r1giun53LVlfCRIwIYqN/AGiShhkSC93
         vtZShqHaNE8gKlorcLtNXVDhuLNKLLskv4Xixf742BEHpmHDxABATZ0HcX057hseWhjX
         /N7RUhIHJ/RbofQpyKCS51vQUxH4CXxx//gp0OFg5TCqGt3wc0Ea9Fl7+u/Zf684bNcw
         +pnLkZZ7Z0MYRQ7f1Lns1+pnHvMXZzO2Iw314HpWxNAgKSQSALwWWIs9ZMzyTIq0voC9
         1VWlTgpyyT8DcB/N74vdIDlhBFONfVEbuC+XFH23dW21jsCzfSuk4naJvEe9up+yPjC4
         z6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786890185; x=1787494985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V80z3viJi/1rXBOV+LmIMGbRsmAIYZLeea8uFd5X4Y0=;
        b=a1IO0XVohhk/tZPHM1BeEZG7v7HuFDJjpiRzyIznuOUj2db5F60YcYPh05E4aXyNUw
         k5kkQyqC12q13QKgXuvSZjfAKiLUVFqawP+grKg+ELyGNVcT0cI8VmvE7V+++VvIKwfV
         UDyPX8f3QotTe++WDU/QndmWKhuqYadpuN9F0M9AXOxK6JdmS4pu1Q1Uc+H2yRT1f/hP
         juF5uZ5K4T68CpgmzgAtITVMhOhwpQYJvRxhhUCOCp97aMK6lk8EG9F+dYxtnpc3sKfj
         euJdDu1t7kRFveVikY7eGhpNikZcIadgisvWaqH36w86uJ0jGSs+Cxw/nFnzRTZ+cPB1
         3IvA==
X-Forwarded-Encrypted: i=1; AHgh+RoGnMs6PqvGxatcjgV5d04+QHpqH3tOXy4CidMNFFuJ8w6NikVYKrjYqrTnq53lOrFDwS5RQXc3uQ==@kvack.org
X-Gm-Message-State: AOJu0YxKcwXfBq/mNgARZ1ycTKD+LYZe6Ht7FDah117PInHAN6rZI0Zr
	Ytccx35wxTRjA632JGWTbPsbnrcq/SBrLiDJxJYAVM2nRByzgvJzIndR
X-Gm-Gg: AR+sD10BJSmIKaNOqgJbIYYlUca4iOlOgAAHfQT9Tyzis7RCq6g9j+3U22Q14jymjiu
	hX/FgCYRBRiEnLkYP8uJ5XIQpLS3UGsdWOVGo+n+M26+1t+c+hZ8SxuMEfa+1MXx2RAVIzm8aBu
	38BwZqKZVb0w4t/wXL28v2dmUqVh+9+C4XaeWq6CYp5Ow9AJYIByfqUe2zpDCvI41AHwXGViaD3
	25J0v7f/9EBvesM18zEtl7aftazfkJlpl0fsgop4TjQ/SnP27zLBXB4RSvx6O7e/+tnPowzVeSS
	g8xWC8O3c1fSgXnecs82tKK7k9G4KKq+5nZEJemHK6tEz9NhXpTgnJflt/xL74MHsr+uX4oB9Tb
	eQdRbuwsA1dA5zFYeLu+kJ9g+6UGC7bKB1Y9ZP1l5FSQ4OCQfuSnVJgQll9pk0to+iDwoKVy/81
	+dm6Q5yuRKb+hGYi+czc+K56SbxuP5e4pR/68X9zAGD20Hoi1kbSYbMWjxcACq7kqLGie7cM/H1
	dyvB+2YIjKGns7DiA==
X-Received: by 2002:a17:902:ce8c:b0:2cf:afa5:b19a with SMTP id d9443c01a7336-2d3b0d13bb8mr212666695ad.11.1786890185194;
        Sun, 16 Aug 2026 07:23:05 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3aebc8199sm26102365ad.74.2026.08.16.07.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 07:23:04 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: will@kernel.org,
	mark.rutland@arm.com,
	sj@kernel.org,
	akpm@linux-foundation.org,
	shuah@kernel.org,
	kunwu.chan@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	"Lian Wang (ProcessMission)" <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [RFC PATCH 3/4] mm/damon/perf: add KUnit tests for the SPE record parser
Date: Sun, 16 Aug 2026 22:22:20 +0800
Message-ID: <20260816142222.689624-4-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260816142222.689624-1-kunwu.chan@linux.dev>
References: <20260816142222.689624-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: joh5q99fp61b4q3qgbmwwdwbp4sfxjax
X-Rspamd-Queue-Id: 872B4C0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786890186-517872
X-HE-Meta: U2FsdGVkX1+WJl2vHDnNMwoQZNFanllS/kh1GGyU1OkK2GK19ukvPy67EPbg9QXnGpaPI3gGAcEhYbJcioT6FZbD6FAjRU+uIjGfLY5w5+hmi/WJpYRYAHZLFo4Jnq/M6uW+j+0LjvhYgAoPfJHbnG6J0Lt6/7oxyZuTK4UjSX4G1EQR8t+WmDosmDG/KV8lqnoDCACFppMg0df7A7b157hStJkfHdeGeLjpU8ASFvxuCyzaBUHJAUaLRI7rrIx9LxLG+Yb/kenSICrh/Sje43vHZ6dB5ICHYoGHA2HCwB3R2KyAZBzPUAa0vgUY3mGWbXW8IKLKEwwX4vBp8TOZIqekTmsstg3gzyEHB8QRRyxp9SWQHpx47lO8K/LFTodtlleE4wD2RC8MfdIl6eiRdD9wzRiXvorvUCVCIIofOLNWYoOzMR1jKngTfAmEMFO7fhfFVsGEoinuUb/hYdhJWxOuOZRQQyPF4FFGgNFgUHETWb1EIqK6m0rTwIY9A66mXRHUqV+VYTXs712GNh7qujXqI/7dnb4l/I0yWCJbpIu3gyWAY5rSFAziZoCcVbBxfA2zZmcfceTLR0PyUqJtcjTGeG1xiGAutvcJsyWwc1ETqqt/6LhvHtPZvni0R5j1Q7YNffYO+VpupOvQa3XBQlhPeel8BFsdabqNfiKXtYqTvqWf/lg8Lh0zI5ulNcf/YGusX21KlIRm8fqtKY5ZNVAHQbduwNuOmvfHri1G3RHODOBIQ0fM0miR4vsJOH+sAe2o6dsR4VaBb/KUJV1dgm0/flHbbBwWKBFdvFLKtfF/Cz4yTum4WEDp0B2vx9F44OlO6uCvXYc3ByXmZSWQdCP/1yXnZRGmJKZLYCwDY5WrNYn9NhmQm1924CozFqVnbpPEy/9MszfhNM2FExLlVsvrU+JeuXeqI/Ba0f/tKUSP2emn8+ejQb6i8HCD1qvLwMg8/PJfFFsTrYP39Kl
 DxA6QsXl
 d4JCPGhFyVcJZ58KNiep+DUPPsE8104MVnk1pNqHUo+mC9xdYuI9duICjvF4J9azba273NbKFi+5mu3C1Q0ekGFPvZjeM/LYdeKFWjP3A+GOkBNaKLcQySUXWiZ4jm82D+1T3rFuMjJnGQKVB0n/PN7RrtY+K+0BakW9h1WpIHi6wI2PbqZRdnU8DxNDlfqCZi36/k4L5LNr4F0mWNcG6o1rPTrn0slze1Mdf+G3yCytK+kYzdiQCqfu2rJDp+F9edIPzn45oBaDEjDK7jOXx6pD6DkgOfaa7aqy0n9UPOkjXr7j71LgcGd5rN8WqQ0/NMVg3BKPrOMgVRQdCepH6pjGVF0u9SV4Cnny4kKYpgunnU5tB0N1ps/hxslgPYaGS1P8hypT1BfKp4PCdxudDU3PNTjdn3emeGcsFwQmmJJJckSlYhOoqCJD38URPfCHVQC4e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>

Add byte-exact tests for load and store records, timestamp terminators,
multiple records, PAD and ALIGNMENT packets, extended addresses, invalid
extended headers, error resynchronization, and records without a virtual
address.

Cover ALIGNMENT packets at both odd and already aligned stream offsets.
Also verify that a record split across two AUX snapshots leaves the tail
unchanged until the terminating packet becomes available.

Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
---
 mm/damon/perf/spe_parser_test.c | 365 ++++++++++++++++++++++++++++++++
 1 file changed, 365 insertions(+)
 create mode 100644 mm/damon/perf/spe_parser_test.c

diff --git a/mm/damon/perf/spe_parser_test.c b/mm/damon/perf/spe_parser_test.c
new file mode 100644
index 000000000000..598d9fd7cdc7
--- /dev/null
+++ b/mm/damon/perf/spe_parser_test.c
@@ -0,0 +1,365 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for the DAMON perf ARM SPE record parser.
+ *
+ * Each parameterized case feeds a byte-exact SPE packet stream (same
+ * encodings and decode order as tools/perf/util/arm-spe-decoder) into
+ * spe_parse_one_record() and verifies the synthesized records, the
+ * return values, and the aux_tail accounting.  The loop mirrors
+ * spe_backend_drain() including the caller-side window shrink.
+ */
+
+#include <kunit/test.h>
+#include <linux/slab.h>
+
+#include "spe_parser.h"
+
+/**
+ * struct spe_parse_case - One parser test case.
+ * @name:	Parameter description (shown on failure).
+ * @stream:	Byte-exact SPE packet stream.
+ * @len:	@stream length.
+ * @exp_reports:	Expected SPE_PARSE_REPORT count.
+ * @exp_skips:		Expected SPE_PARSE_SKIP count.
+ * @exp_errors:		Expected SPE_PARSE_ERROR count.
+ * @exp_tail:		Expected st->aux_tail after the stream.
+ * @exp_va: Expected virtual address of the first REPORT record.
+ * @exp_tid: Expected tid of the first REPORT record.
+ * @exp_is_write: Expected access type of the first REPORT record.
+ */
+struct spe_parse_case {
+	const char *name;
+	const u8 *stream;
+	size_t len;
+	unsigned int exp_reports;
+	unsigned int exp_skips;
+	unsigned int exp_errors;
+	unsigned long exp_tail;
+	unsigned long exp_va;
+	u32 exp_tid;
+	bool exp_is_write;
+};
+
+static const u8 stream_store[] = {
+	0x66, 0x2a, 0x00, 0x00, 0x00,			/* CONTEXT: 64-bit EL1 tid=42 */
+	0xb2, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* VA 0x1000 */
+	0x49, 0x01,					/* OP-TYPE: ST */
+	0x01,						/* END */
+};
+
+static const u8 stream_ts_load[] = {
+	0xb2, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* VA 0x2000 */
+	0x49, 0x00,					/* OP-TYPE: load */
+	0x71, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* TIMESTAMP end */
+};
+
+static const u8 stream_two[] = {
+	0x66, 0x2a, 0x00, 0x00, 0x00,			/* CONTEXT: 64-bit EL1 tid=42 */
+	0xb2, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* VA 0x1000 */
+	0x49, 0x01,					/* OP-TYPE: ST */
+	0x01,						/* END */
+	0xb2, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* VA 0x2000 */
+	0x49, 0x00,					/* OP-TYPE: load */
+	0x01,						/* END */
+};
+
+static const u8 stream_pad[] = {
+	0x00, 0x00,					/* PAD prefix */
+	0x66, 0x2a, 0x00, 0x00, 0x00,			/* CONTEXT: 64-bit EL1 tid=42 */
+	0xb2, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* VA 0x1000 */
+	0x49, 0x01,					/* OP-TYPE: ST */
+	0x01,						/* END */
+	0x00, 0x00, 0x00,				/* PAD padding */
+};
+
+static const u8 stream_alignment[] = {
+	0x66, 0x2a, 0x00, 0x00, 0x00,			/* CONTEXT: tid 42, pos 0-4 */
+	0x20, 0x00,					/* ALIGNMENT at odd pos 5 */
+	0xb2, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* VA 0x1000 */
+	0x49, 0x00,					/* OP-TYPE: load */
+	0x01,						/* END */
+};
+
+static const u8 stream_alignment_aligned[] = {
+	0x20, 0x00,					/* ALIGNMENT at even pos 0 */
+	0x66, 0x2a, 0x00, 0x00, 0x00,			/* CONTEXT: 64-bit EL1 tid=42 */
+	0xb2, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* VA 0x1000 */
+	0x49, 0x00,					/* OP-TYPE: load */
+	0x01,						/* END */
+};
+
+static const u8 stream_bad[] = {
+	0xff,						/* unknown header */
+	0x66, 0x2a, 0x00, 0x00, 0x00,			/* CONTEXT: 64-bit EL1 tid=42 */
+	0xb2, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* VA 0x1000 */
+	0x49, 0x01,					/* OP-TYPE: ST */
+	0x01,						/* END */
+};
+
+static const u8 stream_skip[] = {
+	0x49, 0x00,					/* OP-TYPE: load */
+	0x01,						/* END, no address */
+};
+
+static const u8 stream_other_pkts[] = {
+	0x42, 0x05,					/* EVENTS (width 1) */
+	0x43, 0x06,					/* DATA-SOURCE (width 1) */
+	0x98, 0x00, 0x00,				/* COUNTER (width 2) */
+	0xb2, 0x00, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* VA 0x3000 */
+	0x49, 0x00,					/* OP-TYPE: load */
+	0x01,						/* END */
+};
+
+static const u8 stream_truncated[] = {
+	0x66, 0x2a, 0x00, 0x00, 0x00,			/* CONTEXT: 64-bit EL1 tid=42 */
+	0xb2, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* VA 0x1000 */
+	0x49, 0x01,					/* OP-TYPE: ST, no END */
+};
+
+static const u8 stream_truncated_packet[] = {
+	0xb2, 0x00, 0x10,				/* short 8-byte address */
+};
+
+static const u8 stream_ext_addr[] = {
+	0x20, 0xb2,					/* EXTENDED ADDRESS, DATA_VIRT */
+	0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* VA 0x4000 */
+	0x49, 0x00,					/* OP-TYPE: load */
+	0x01,						/* END */
+};
+
+static const u8 stream_invalid_extended[] = {
+	0x20, 0x42, 0x00,				/* invalid extended EVENTS */
+	0x01,						/* END after resync */
+};
+
+static const u8 stream_pad_only[] = {
+	0x00, 0x00, 0x00,
+};
+
+static const u8 stream_empty[] = { 0x00 };
+
+static const struct spe_parse_case spe_parse_cases[] = {
+	{
+		.name = "store record",
+		.stream = stream_store,
+		.len = sizeof(stream_store),
+		.exp_reports = 1,
+		.exp_tail = 17,
+		.exp_va = 0x1000,
+		.exp_tid = 42,
+		.exp_is_write = true,
+	},
+	{
+		.name = "load record with timestamp terminator",
+		.stream = stream_ts_load,
+		.len = sizeof(stream_ts_load),
+		.exp_reports = 1,
+		.exp_tail = 20,
+		.exp_va = 0x2000,
+		.exp_tid = 0,
+		.exp_is_write = false,
+	},
+	{
+		.name = "two records in one window",
+		.stream = stream_two,
+		.len = sizeof(stream_two),
+		.exp_reports = 2,
+		.exp_tail = 29,
+		.exp_va = 0x1000,
+		.exp_tid = 42,
+		.exp_is_write = true,
+	},
+	{
+		.name = "pad-wrapped record",
+		.stream = stream_pad,
+		.len = sizeof(stream_pad),
+		.exp_reports = 1,
+		.exp_tail = 22,
+		.exp_va = 0x1000,
+		.exp_tid = 42,
+		.exp_is_write = true,
+	},
+	{
+		.name = "alignment packet at odd position",
+		.stream = stream_alignment,
+		.len = sizeof(stream_alignment),
+		.exp_reports = 1,
+		.exp_tail = 19,
+		.exp_va = 0x1000,
+		.exp_tid = 42,
+		.exp_is_write = false,
+	},
+	{
+		.name = "alignment packet at aligned position",
+		.stream = stream_alignment_aligned,
+		.len = sizeof(stream_alignment_aligned),
+		.exp_reports = 1,
+		.exp_tail = sizeof(stream_alignment_aligned),
+		.exp_va = 0x1000,
+		.exp_tid = 42,
+		.exp_is_write = false,
+	},
+	{
+		.name = "bad packet resync",
+		.stream = stream_bad,
+		.len = sizeof(stream_bad),
+		.exp_reports = 1,
+		.exp_errors = 1,
+		.exp_tail = 18,
+		.exp_va = 0x1000,
+		.exp_tid = 42,
+		.exp_is_write = true,
+	},
+	{
+		.name = "record without address",
+		.stream = stream_skip,
+		.len = sizeof(stream_skip),
+		.exp_skips = 1,
+		.exp_tail = 3,
+	},
+	{
+		.name = "events/source/counter packets ignored",
+		.stream = stream_other_pkts,
+		.len = sizeof(stream_other_pkts),
+		.exp_reports = 1,
+		.exp_tail = 19,
+		.exp_va = 0x3000,
+		.exp_is_write = false,
+	},
+	{
+		.name = "truncated trailing record retained",
+		.stream = stream_truncated,
+		.len = sizeof(stream_truncated),
+		.exp_tail = 0,
+	},
+	{
+		.name = "truncated packet retained",
+		.stream = stream_truncated_packet,
+		.len = sizeof(stream_truncated_packet),
+		.exp_tail = 0,
+	},
+	{
+		.name = "extended address packet",
+		.stream = stream_ext_addr,
+		.len = sizeof(stream_ext_addr),
+		.exp_reports = 1,
+		.exp_tail = 13,
+		.exp_va = 0x4000,
+		.exp_is_write = false,
+	},
+	{
+		.name = "invalid extended header resync",
+		.stream = stream_invalid_extended,
+		.len = sizeof(stream_invalid_extended),
+		.exp_skips = 1,
+		.exp_errors = 1,
+		.exp_tail = sizeof(stream_invalid_extended),
+	},
+	{
+		.name = "pad-only window",
+		.stream = stream_pad_only,
+		.len = sizeof(stream_pad_only),
+		.exp_tail = 3,
+	},
+	{
+		.name = "empty window",
+		.stream = stream_empty,
+		.len = 0,
+		.exp_tail = 0,
+	},
+};
+
+KUNIT_ARRAY_PARAM_DESC(spe_parse, spe_parse_cases, name);
+
+static void spe_parse_case_test(struct kunit *test)
+{
+	const struct spe_parse_case *tc = test->param_value;
+	struct spe_parser_state st = { 0 };
+	struct spe_record rec;
+	u8 *buf;
+	unsigned int reports = 0, skips = 0, errors = 0, guard = 0;
+	bool first_checked = false;
+
+	buf = kunit_kmalloc(test, tc->len ?: 1, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buf);
+	memcpy(buf, tc->stream, tc->len);
+	st.win = buf;
+	st.win_size = tc->len;
+
+	while (guard++ < SPE_BUFFER_MAX_RECORDS) {
+		unsigned long tail0 = st.aux_tail;
+		unsigned long consumed;
+		int ret = spe_parse_one_record(&st, &rec);
+
+		if (ret == SPE_PARSE_NEED_MORE)
+			break;
+
+		/* caller-side window shrink, mirrors spe_backend_drain() */
+		consumed = st.aux_tail - tail0;
+		st.win_size -= consumed;
+		memmove(st.win, st.win + consumed, st.win_size);
+
+		switch (ret) {
+		case SPE_PARSE_REPORT:
+			reports++;
+			if (!first_checked) {
+				KUNIT_EXPECT_EQ(test, tc->exp_va, rec.va);
+				KUNIT_EXPECT_EQ(test, tc->exp_tid, rec.tid);
+				KUNIT_EXPECT_EQ(test, tc->exp_is_write,
+						rec.is_write);
+				first_checked = true;
+			}
+			break;
+		case SPE_PARSE_SKIP:
+			skips++;
+			break;
+		case SPE_PARSE_ERROR:
+			errors++;
+			break;
+		}
+	}
+
+	KUNIT_EXPECT_EQ(test, tc->exp_reports, reports);
+	KUNIT_EXPECT_EQ(test, tc->exp_skips, skips);
+	KUNIT_EXPECT_EQ(test, tc->exp_errors, errors);
+	KUNIT_EXPECT_EQ(test, tc->exp_tail, st.aux_tail);
+	KUNIT_EXPECT_EQ(test, tc->exp_tail, st.bytes);
+	KUNIT_EXPECT_EQ(test, tc->exp_reports, st.records);
+}
+
+static void spe_split_record_test(struct kunit *test)
+{
+	struct spe_parser_state st = {
+		.win = (u8 *)stream_store,
+		.win_size = sizeof(stream_store) - 1,
+	};
+	struct spe_record rec;
+	int ret;
+
+	ret = spe_parse_one_record(&st, &rec);
+	KUNIT_ASSERT_EQ(test, SPE_PARSE_NEED_MORE, ret);
+	KUNIT_EXPECT_EQ(test, 0UL, st.aux_tail);
+	KUNIT_EXPECT_EQ(test, 0UL, st.bytes);
+
+	/* The next AUX copy starts at the unchanged tail and includes END. */
+	st.win_size = sizeof(stream_store);
+	ret = spe_parse_one_record(&st, &rec);
+	KUNIT_ASSERT_EQ(test, SPE_PARSE_REPORT, ret);
+	KUNIT_EXPECT_EQ(test, (unsigned long)sizeof(stream_store),
+			st.aux_tail);
+	KUNIT_EXPECT_EQ(test, 0x1000UL, rec.va);
+	KUNIT_EXPECT_EQ(test, 42U, rec.tid);
+}
+
+static struct kunit_case spe_parser_test_cases[] = {
+	KUNIT_CASE_PARAM(spe_parse_case_test, spe_parse_gen_params),
+	KUNIT_CASE(spe_split_record_test),
+	{},
+};
+
+static struct kunit_suite spe_parser_test_suite = {
+	.name = "damon_perf_spe_parser",
+	.test_cases = spe_parser_test_cases,
+};
+
+kunit_test_suite(spe_parser_test_suite);
-- 
2.43.0


