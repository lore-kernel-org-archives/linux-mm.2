Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2BB960A260F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 17:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LaDVRy0r
Received: by kanga.kvack.org (Postfix)
	id 131A96B00EF; Fri, 20 Nov 2026 12:18:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2EE6B05B0; Fri, 20 Nov 2026 12:18:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13EF6B05B1; Fri, 20 Nov 2026 12:18:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC25A6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:18:42 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62AD7A00B8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:18:42 +0000 (UTC)
X-FDA: 85456156884.03.E7EDEC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1E9E620008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:18:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LaDVRy0r;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf13.hostedemail.com: domain of devnull+peder.bergan.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+peder.bergan.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795195120;
	b=HNQ0tO4dXg7CpEGpgojLh8qhqdI3f6rTiekgAwP+rWEj6WVupycJkaD+5eIGpiNJbqbYLe
	56TYGFatFRC0Tb0rzUd3sP2TtE0NV0fjEPkezCDhNv/DDw0Ax+hhujU1o9qkzqHkP/v1v3
	wbc+SbU41QFOyl5ZlDKBSOF7DVFeWu4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795195120;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=a1X8OcArTajS0cG5wRxnBcw8qQzAyLSvarhTdGhtG7Y=;
	b=zPsRFdYerRlpz08wHiwIj1AIpqNwA9z2o3brNKG1UmX0bM0E6EOMjYgPukI79PGMRycxw1
	AQA+j2pCtRa+D+9+McyoMwD8VdfQfdEzo+4D9QuvGc95kGGGBvH6a31+8fC851QK4O3Xbh
	HG/4Cf54rwdKMyPpKTX2vpKpwUjPVS0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LaDVRy0r;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf13.hostedemail.com: domain of devnull+peder.bergan.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+peder.bergan.gmail.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E88644F00;
	Fri, 20 Nov 2026 17:18:39 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795195119;
	b=IdNnpW8R2xmxtn0qLk5/b/CH7QCe3FssFAIXaelAz8HG/yunMTnzujjsiJK5hxgiHze9
	 kVbgcXImmG3HhrMjF3jnmb8W/bxqm62j+hq/1UJ2LMB21rswiuseZrLKDvbxTQ2jU5OLM
	 u2QJDeK6ZZMQXVxE7GesCAVcWx6LZwj6pfP8TYG1KU50tty2rjVX7l6U5J+NxZ2+AriQa
	 i8tsPNx7qTGZi/roo6aniNVaYGOBu0rFlvJv0B1Zk3Tc7e1hvMNdyBgDzC5YrBSfCLdb+
	 9AGusRWl4PuI0B52igDzH2EflkAzM1+GgV+C/bVkBJIlLuxiZ4AgPivx9/C7mfsBwpw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795195119;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=a1X8OcArTajS0cG5wRxnBcw8qQzAyLSvarhTdGhtG7Y=;
	b=a1MU19Ob8uVDEemjrjyOCRZAW+cWiekYeMnmJqVSOResJySDAGMcfv6ofmFeCVlQISyy
	 344s8SeV2+Lwp6N6qyOJZ6TxfY8FQsg5ScJlQZcm+t0TFDx9iC8+ZJIctX95gw4+AQD2o
	 kjfGJMmbn7SqKekG2QgrWEnXb1cxIkVOwvODrZ4A4FcUpuTZsO5wOn6sPbhzfXFH9rHJg
	 qtYJz6GB6ClncnCw9Jg6V7ZsMtjs2t1G5EdAnPRAxo5PVTcKlqtlfKIrHLRwSO12iYF50
	 alm99fMIuj5yg/Tj//lmG+OvFlECVGmpIId4ABtQ0xCvCTPuf2pEHrT0+QJmLBk16dw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4571B1F000C4;
	Fri, 20 Nov 2026 17:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795195119;
	bh=a1X8OcArTajS0cG5wRxnBcw8qQzAyLSvarhTdGhtG7Y=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=LaDVRy0r8JQyALWEpEzTDGhqF9B0H6b7dtKqfCnVXICM5EH8OhAPqxnWHUjBMg2qC
	 fejjT1m3rbbB5V6tyRWQILY8s10RXu0y8U8jWVP5JlPNmvoLSQWBXbNelPmRktTdgr
	 cij+PdaGQ9HHezZbxbVNN90hYNegAy/BcagU4BgYFQR6EyFINKypOy4JJq+0wZvt5J
	 Cf1B45BJToGrCloc6b9lIflpFfKP9wM7/Rcbq/pZonTziVyD6rQVwVwd5S64N+bkDU
	 0X/MXf4NGdLCfhQxHh49pmcnNyShjTT4NF3sDnwQZtVrLwrDbbRdLcNY8FZSxNiG+c
	 zlkODzihFGQlw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C9F764B871;
	Fri, 20 Nov 2026 17:18:32 +0000 (UTC)
From: Peder Bergan via B4 Relay <devnull+peder.bergan.gmail.com@kernel.org>
Date: Fri, 20 Nov 2026 18:18:30 +0100
Subject: [PATCH v2] rust: put C helper exports in a dedicated namespace
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-rust-helper-namespace-v2-1-14315658f59e@gmail.com>
X-B4-Tracking: v=1; b=H4sIAOWAAGsC/4WOQQ6DIBREr2JYl1YwaNtV79G4APwITUXCR2Njv
 HvFHqDLN5l5mZUgRAdI7sVKIswO3eh34KeCaCt9D9R1OxNe8poxXtI4YaIW3gEi9XIADFIDFQ1
 cddUANJ0h+zZEMG45vM/2xzipF+iUZbmhJAJVUXptczQFTBHkcDn8HpaUS9ZhGuPneDezLPt3Z
 GaU0UrdZCmEqIypH/0g3fusx4G027Z9ATJI7VTxAAAA
X-Change-ID: 20261120-rust-helper-namespace-57e8c37ee7df
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Miguel Ojeda <ojeda@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
 Aaron Tomlin <atomlin@atomlin.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-modules@vger.kernel.org, 
 Wedson Almeida Filho <wedsonaf@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795195112; l=4679;
 i=peder.bergan@gmail.com; s=kernel-contributions;
 h=from:subject:message-id;
 bh=nX0YbO/vtt47+6y4IylipSM71r9O+9xEUx60Z3g64FY=;
 b=qTCg26Oq8Pjxp/oLQvY8MWSA8T9mQh94rZWp9HfgwSRh9oxjB4DdefYwAxmyYbkzevUK6a5Yn
 ivpi0EOBirtC6JIIrzz2MXAZX8yIJdIqYu1XBXqFFK89EROXaU6uqD3
X-Developer-Key: i=peder.bergan@gmail.com; a=ed25519;
 pk=39790pn1YZCulHBoUG1uiQI1Hm01EvhBEa2zVrS/yN0=
X-Endpoint-Received: by B4 Relay for
 peder.bergan@gmail.com/kernel-contributions with auth_id=1395
X-Original-From: Peder Bergan <peder.bergan@gmail.com>
Reply-To: peder.bergan@gmail.com
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1E9E620008
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8ix8dir9bixtd9d9d3g5j5w1f6my53j3
X-HE-Tag: 1795195119-390922
X-HE-Meta: U2FsdGVkX18dRW+PNYPHHjtBGVuJwg6glc2jXyqCdbg6fQi9n3YEmlq9V0XozMUKDE1MNOaAZzd7ZdOBWTKaPaTisuTe85xOiwGfCVui8iK0oy1ehynudbu7Y05YdRjStZIdlOCuc/vXhMAVQW8u+P9sapoc61qxGpoI/7JGvmgQeG9ikHJL9a3RuKIvUWJfWYqpB8s2IX9Y9L0wf3Ljn16Oluc1wgBuX1eoRw5hY7jNjKETOUwkQT1kQHCB4bBPJbZBU5iOROQdNg1oEmDu7ATBpJdlJzsERZsIXnkgCw6e3PGkllH6gMSHaLmmzdxhFxIHOj1DIzEdCZ+xz5bJWeSLIFs3ssyMt5LoPigPCasj+/by/JGHWv3hQo03e90JNUxFbb0JaQRpRMLHhUfBcCFGeIhSC2SHSrBmiTjY/J0tKCyxJo6X2gjUUnJez+/oV1Whrro2zgGvPeRtBD9qNdl0KiDSwXTJgNLE8PpKC7JuqJahLFAC/dFuKiG5rBvFAirx+vv74oXMVAk0BCPBkmPCfvzwqLIq04veCePeYcr83KuFsuPq1ZkIjOGqeyQlzfhqSRo1I67F5CVbgV9kv2xFhRhHlVet8/uhNfuGuTLSC9qFzLpAlnHn70yMJfIDzfQjk754BssWDixD6AtOA+XWL2PO9fa2NND/XMGV6UwH16bA4CeEBPC6k3eNv2ax666Lv/RlPhzeXGZ0cn/oxkReTI7R96K70JgKwgBZVMC5rD9QNak2asZHyYWBxE+6b0aIJkc3D8gl/a1lwa0h6x0V8lzTV+RjPDRotE/RhTkGTm7akc/1Z6wqY020mqNg2/uJMYz3/Y8WpXp9UyiGw4QugnObWmlhTTKEffXeZ6xVUCDl3O8izTJU4gVfuNIPLwrfKNTo2vhKXzQXSY1mBkBKkWHXpOLLEzr5ob/NMmNnzYvvjBo1GsyaYq4DW37hbEmTtojvT3bo4Wa0q9a
 XmgJDLlE
 kDoy6FAIOZ4+Jvf0C0uOqcpRpu5qTmdux2Ul1ot4WDQWWxGoC1t929aUb2fYBushXQ8fvuCDptihgOybx7RmZRCoVdc9FJ7m1M1m80Ik0GonYB0/NC7S73Jze+zhaAnmhBo+D28zMAw43uyp9G0gf8EZ8GmOTPJ4B9Z2vcjJohKMZe1tp+/t05PCcF+v1cB790Gera76u+vR8TfqL3EkTHf17n8/XnFUNCWgjalEaY6+SHyoDoYyFxJtEcyQPY9G2QTiWZ+3de5kAZbb34mU3IajNWbgR6rdaqmhU45xxnVWRFkqlF8CKJmbWC5QhK74QSNbeNMfwKY5kweM5xZUedDnVhxj/XsTsaXm2/8ucioX3uijbUPsn0wW7lhGzYOIvZmDaVTVIWIUkiXDABgP1E+mBAoopHd7xgwXeiznpcpeWEozZyiDQ5ui53SssjEZLlsGUeb3d7Cq+/evJ8S6SzQ7eMDX9I9TZoOy+yWwuvho2YIMcyqF8IW7v1d3lPQ6tY8B5N4RtfDf5o50gJ5WCg9L6h5sXbsvX7jBGqrwHwe9FWfVecdeINXdnqZxvvLu8R424bqmrnQ+hEU7pGy4TMg71Cvqox3Ywd7oM/aId5GSuulTuSmj9M+CMRLpBMJDiqd72sg8DVsvA4QLDjmu9n7dWHEldxQqEBCb3GpAMfpFYk8B+1JahLF5lIoqbHT7Ma5OuzCmzAmj4gq+qjqRCibGLv5hodDUa3rVUoqQjO8Ccxk2jgDneohgksmK9NsrWeHef0UM1oGqAVHQay6SBGfmPQ76X0lGDIo/wQAaZgxOfzZc30BTrxsZuxoapRlNiA3iY/1V6tR54JiyIJQX4G2Rps1GycdeAzvzgJX5Abc8Km7gto+zzEi1MSyFWU7tD6IoF+28j8mtZXRxIPURfxfwgAuaLVQs/bS74McZ6nMvDx71fQP+p0845IaGucRx3B44hlbrDG/yBWe4v3jyVBvU/rmiv
 PNp9YEzx
 OYOjxrUanefq4j4Zr5uJdMW2hFDY1P3XJbD9Wuv0Zh++0Q1WyAoRkSx9K7MTAyNae/VRt4wNuO78abtWwjIQuB2FGZEijQrW7kueMsaycHfd/d378pLcgKNLQSoAuINnNPtVbdV8UuImeXIymV2WRKw884GbaC0R7+Kah7h+t/vQyGRTeaFPcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Peder Bergan <peder.bergan@gmail.com>

The rust_helper_ prefix marks these C wrappers as Rust implementation
details. Their exports use the default namespace, so GPL-compatible
modules can link against them without an explicit import.

Export the wrappers in RUST_HELPERS so modpost can detect accidental
dependencies at build time by flagging a missing namespace import.
Have module! supply the import when the helpers are exported, since
inlining and generic instantiation can introduce calls through ordinary
Rust abstractions.

The KASAN test links its Rust object into a module whose C object
supplies the metadata. Import the namespace in that C file when
building the test as a module with out-of-line Rust helpers. External
modules that call these helpers without module! also need an explicit
import.

Suggested-by: Wedson Almeida Filho <wedsonaf@gmail.com>
Link: https://github.com/Rust-for-Linux/linux/issues/216
Signed-off-by: Peder Bergan <peder.bergan@gmail.com>
---
The modular x86-64 KASAN build failed at modpost on v1 and now passes
with strict namespace checks. With CONFIG_MODVERSIONS enabled, the
test module and kernel export record the same checksum for the helper.

OpenAI Codex assisted with coding and testing.
---
Changes in v2:
- Import RUST_HELPERS in the C metadata for the modular KASAN test
  when using out-of-line Rust helpers.
  https://lore.kernel.org/linux-modules/sashiko-outbox-225583@kernel.org/
- Link to v1: https://patch.msgid.link/20261120-rust-helper-namespace-v1-1-3b9a05553ff6@gmail.com
---
 mm/kasan/kasan_test_c.c | 3 +++
 rust/Makefile           | 4 +++-
 rust/exports.c          | 2 ++
 rust/macros/module.rs   | 5 +++++
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index b9e167ed5be32..f8e96c1194e02 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -34,6 +34,9 @@
 #define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : KASAN_GRANULE_SIZE)
 
 MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+#if defined(MODULE) && defined(CONFIG_RUST) && !defined(CONFIG_RUST_INLINE_HELPERS)
+MODULE_IMPORT_NS("RUST_HELPERS");
+#endif
 
 static bool multishot;
 
diff --git a/rust/Makefile b/rust/Makefile
index 0165626decbe7..17c559052e936 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -569,9 +569,10 @@ $(obj)/helpers/helpers.bc $(obj)/helpers/helpers_module.bc: $(src)/helpers/helpe
 
 rust_exports = $(NM) -p --defined-only $(1) | awk '$$2~/(T|R|D|B)/ && $$3!~/__(pfx|cfi|odr_asan)/ { printf $(2),$$3 }'
 
+rust_export_macro = EXPORT_SYMBOL_RUST_GPL
 quiet_cmd_exports = EXPORTS $@
       cmd_exports = \
-	$(call rust_exports,$<,"EXPORT_SYMBOL_RUST_GPL(%s);\n") > $@
+	$(call rust_exports,$<,"$(rust_export_macro)(%s);\n") > $@
 
 $(obj)/exports_core_generated.h: $(obj)/core.o FORCE
 	$(call if_changed,exports)
@@ -585,6 +586,7 @@ $(obj)/exports_core_generated.h: $(obj)/core.o FORCE
 # function either. Therefore, we export all symbols from helpers and bindings.
 # In the future, this may be revisited to reduce the number of exports after
 # the compiler is informed about the places codegen is required.
+$(obj)/exports_helpers_generated.h: private rust_export_macro = EXPORT_SYMBOL_RUST_HELPER_GPL
 $(obj)/exports_helpers_generated.h: $(obj)/helpers/helpers.o FORCE
 	$(call if_changed,exports)
 
diff --git a/rust/exports.c b/rust/exports.c
index 1b52460b0f4ee..fde2a52d2a1ae 100644
--- a/rust/exports.c
+++ b/rust/exports.c
@@ -14,6 +14,8 @@
 #include <linux/export.h>
 
 #define EXPORT_SYMBOL_RUST_GPL(sym) extern int sym; EXPORT_SYMBOL_GPL(sym)
+#define EXPORT_SYMBOL_RUST_HELPER_GPL(sym) \
+	extern int sym; EXPORT_SYMBOL_NS_GPL(sym, "RUST_HELPERS")
 
 #include "exports_core_generated.h"
 #include "exports_bindings_generated.h"
diff --git a/rust/macros/module.rs b/rust/macros/module.rs
index 0a7b9e24c9600..ac3376fa8fb85 100644
--- a/rust/macros/module.rs
+++ b/rust/macros/module.rs
@@ -467,6 +467,11 @@ pub(crate) fn module(info: ModuleInfo) -> Result<TokenStream> {
         }
     }
 
+    // Inlined kernel code can introduce calls to C helpers in any Rust module.
+    if !cfg!(CONFIG_RUST_INLINE_HELPERS) {
+        modinfo.emit_only_loadable("import_ns", "RUST_HELPERS", false);
+    }
+
     // Built-in modules also export the `file` modinfo string.
     let file =
         std::env::var("RUST_MODFILE").expect("Unable to fetch RUST_MODFILE environmental variable");

---
base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
change-id: 20261120-rust-helper-namespace-57e8c37ee7df

Best regards,
--  
Peder Bergan <peder.bergan@gmail.com>



