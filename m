Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC6D4606A323
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UQstwEo6
Received: by kanga.kvack.org (Postfix)
	id 0A91C6B066D; Wed, 21 Oct 2026 04:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080A96B066E; Wed, 21 Oct 2026 04:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8A06B066F; Wed, 21 Oct 2026 04:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C875B6B066D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:31:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 557C7120490
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:31:16 +0000 (UTC)
X-FDA: 85345963752.26.8B3A2F2
Received: from mail-pz2-f8.google.com (mail-pz2-f8.google.com [74.125.228.8])
	by imf31.hostedemail.com (Postfix) with ESMTP id E65B22000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:31:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UQstwEo6;
	spf=pass (imf31.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4koY4BOyWDff98SibzubYxzBLIkRmqVVsOccvbFql8c=;
	b=GHc/E5VKOFPfM17yie5K4g2il95MXh0bKbDe6q5y6BeIIvGrHt17qqBBLzhifIpoNFqfLl
	rTdgTBd3OXoRT0WefJhRwKdk6fhtxsRQmQKzDHQlAL+wI3Mq8r0Hr9XJPFAXRn8JdbPfB9
	Gsc696Ba5IN3U2pz6iKdN3Hs4ZOIyI8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UQstwEo6;
	spf=pass (imf31.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571474;
	b=JYstaCS+QrJET/ZqAqNq0NRb5TAe665Ymv/fd9zJktA9mVIvfCzOgYFA6dBCjgHK7qEY5R
	oYvWMd4PyeinxcfS+yP7MONClsLd3INgMl147rKoeLHwsmzDhX7Lc7wKE7k11jEI3huhri
	Ov4/tLfzUyMzDFIsIN6WWkMsNcElMMc=
Received: by mail-pz2-f8.google.com with SMTP id 41be03b00d2f7-cd5cd8e8104so19935a12.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792571473; x=1793176273; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4koY4BOyWDff98SibzubYxzBLIkRmqVVsOccvbFql8c=;
        b=UQstwEo6MGsuxSS/jrSMaiUtQHDgIc4Qaz7/x7hMwvVYQlXa0a6wraOG+R9BWDcfQ1
         Ou9eZbsbMvVULDXPEzNDa6wxiAHN+F7kTB6XSlnloV37HZ58szWkkIcj+dGq60LbUN52
         KlVHedglc1dj/4xU0WvslxnISEpc+6w9xssgvAjgwe4tZlnyQg3Tt5ei9if68+hIr2vF
         XbmdQtboN5MDfxXJP898RQGqIlZqTq9YLHukqVaTbcdeT5S+D1WtUAEX7gftdbvwJPcW
         JLyEpl1hQB7lOrOs7M0S0xLu12bPhfm0I7ggcnVTsaIdsOc+1NwfQI/QeWqYbmlGKj6/
         RB+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792571473; x=1793176273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4koY4BOyWDff98SibzubYxzBLIkRmqVVsOccvbFql8c=;
        b=fgnWjj8QxX5Vm5Yy9hfLseTd2XWt9wu5mXuPFfEhYhNplyFnfxDzmk2YI55xId8L+/
         nswUJATUV2HkDVtvg0y6KWkS+lYY4QsP9JFRbRdiOogK96JVGhZt/PlrgyKKpb6ax3WN
         qYnsN15+dbBhcvN6gowcBshoxy9tXTDG9JRya0xwW/dmEEY3SeindR6gUjz79ycKDhCv
         B6t1SNPPut0oGfDbPLHDov1YvLXYkOY+ddnulxOxSZvT3/fbHItK0IBsuelLVU7jayTK
         e7TtsEdPYBHL8Sb9IMVk4O9aNEfV1U1vA6rChgmTTszTdHddodXl1RcN8XKNglTh+iDC
         8/hg==
X-Forwarded-Encrypted: i=1; AKwUvBxLz4NTcrz8k3QKCdGqSArl8X0SVc7C/3VoArmCPAI2DKPenx/4PpVwieaSszbJNMPlbrxM/WScbA==@kvack.org
X-Gm-Message-State: AFq9FYKvxOPt51uUAxinn4mid3MLt1we+XcWX3MDkSLLjDsPDmOikX2I
	uTsGPtFxgDPt0UEVe9vWoZiIuaUj6Fe4I9AF9AodZBPepnf5yuUbhCtl
X-Gm-Gg: AYBFou0h4jXgfhM33m85OOxn8VGxRYDnotQ6Q1cgPCLqMaCa8DCVb/c6KlvsW+9bdyV
	XTNUvKVeMfa8fwPniY1lQZ/DWc2ClVlhsxzCEb/TfcM/1UcqIfGx5CabsSU+EwvtCEZ5PxjRbz4
	O3BDLMb8cEtSXwsBSOSsmTOYxxxWu5uAR6S41xa9nF8AcTtFXbMr2uqBdeF/eWmaVePT8yt0QQ5
	ZDyLbCnwBU5caFfOvi5ezFKbE79s2eQN7zARnpXeVNlgdkem35tMdoCOC6qUo68XBqNk2hoVQAo
	+xt+pHOotnOQD5+kvO6cDKLl6rm+A4zx3PaZZ0fFHnXp07OFywGb3etay2JgEOtsPDt3uz94217
	xT6QQep5t3umH2HySFFaqTAOwzenKG9RYBfjIX/TtrttcG2pymWUVgYKKzRYRzgBG+kRMfoBJWc
	/PvDu5wkp0Y3bN0qDecWmXYJwxqtKiuTbecKFodJc1PYJPv/ODym7Bh4Q+Al+pncX8r2jNJ76jx
	GnHufm+3JfbiewFutHNLWMDl8oEghDUqcya1m+1F6PnJhXN6w2g/qBH94u4Ag5/kgYO
X-Received: by 2002:a05:6a00:4b04:b0:89e:8242:f35f with SMTP id d2e1a72fcca58-8a089cf006cmr1210490b3a.13.1792571473289;
        Wed, 21 Oct 2026 01:31:13 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895e273bsm600653b3a.41.2026.10.21.01.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 01:31:12 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v9 3/8] crash_core: serialize crash header preparation against hotplug
Date: Wed, 21 Oct 2026 16:30:06 +0800
Message-ID: <20261021083011.2170525-4-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021083011.2170525-1-chenwandun1@gmail.com>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E65B22000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ccw715o1im67ae3k68eo8fgen5kjeca7
X-HE-Tag: 1792571474-405662
X-HE-Meta: U2FsdGVkX19hDYuv6RWqxgd5WsSjAsmw1XoP3cBJlOgP8M0wsu3tQKD1/cCDG29BVaA29QthxwOMSH0DKdAp2PEdPQtAn3gBe41XKywxT6TV0m2HGdDVl+xpupP3ooYttVV0usImRHXEI2qLi96X4nJQvpH+L+1/Vvhlbnrrw8Qf93EkGssfxqUjpQ+h2HZwlQ/222cG5lTMSDErPSR/sguc/RnWsh/5Uor7LGvoBg0/HmWBNYro2rccfQy3wI48m3SDJKjXGpnxeJKwAT7q6+L3VyLEA/o3BK8Zg4ylbLyWJ2S6+pxHClvrchvXLOxAR/07oza+COJyyUJ/itYLhHabu0uLJCAcoDMeZZW9LgwGK5P5tqsUPsijgRxU2ZfysewLheBlrKpo+y7OYN6ck85OyCGzDh8bAfSoloja3lwhhswQBW/Sr9LM2FkCVKle1gD/4ndOXubPFr4H3mAoH2Ot2j1sN2jN80W+A9OiB3vIOGnG5ijbRzoBea7djLiKZXVJyaqVz5lXTGDmZcl+i+iNd4O99qfoGDsJr62a5ZV3Q/eZaRV1TnlHq8d+ARY4UyKvUumeMgY2O2sGEkWJriKOBVu+jRfDNToOuPLgbAxJ3b3UqhEuIhZQm717E9EuR1wguKv9gRgckEdysFQUnudtUWGZvDKPXb6vjZ+bnrXvSvLrOA52DSPaDi5U359UwCWtbCk8lyJNSB7ByJ+v98yqDaZ/2QBu5BikEuiNUCXUM6QMrfTAkC7xoCa7BE3JWP27VRrK6qRGATn+uGFHnQbDgObm5d4x2TYO8qx4e2BW7Vag0KyNYD5Czo8ZXovtBg7SP0aZcTcvvsHCOJw4Aea50z5UbrC48x6dy9RqFDRcVTyKHQipEXR1xaKl6pqDL+0Ow73mDb9OEuwDGfOMWz/vahLG1ebVFwsdh3LTHDxJpjXiDsNSJWPRhRtuaC+L4N8VK4cJFRkvUH4CaJI
 T6qVwzJc
 czPqP70FHuohQUM5Wr6bc1Wl8xtS4Xi/vgI4TebQdj8t4ITLoAOnO+HvtCO2aYkhxlsVUiK0YwT1kcU/8iyABx/2oH745Ilb3xO7DuI8ytRRS4x/To9aWlQWoYMUcEParO4AufePePOsN9f0wXH+FJF8epjsgZnyWnSy9qOFKJfob9XyickOFv8ZrwvC87x67OiBHGNxq6EewUWUgDSH73nftaCLVrK/faf6dwPTUi6cmBj1Ks4GjNy1dmYD5QqEU+nsV/VIt4N72CpYu8t10m3kBZW1eo9lzw6DDFUD/RWMNI1rmRXeAS6zK1sfA4LGrrS1ifFiVXbJCLynSX4+oJGuCFEHFJj56VWcIghOu5Dv5Fd06j7XEDuputmKqntVAKzsea3S0x4p6Q49ULpUvwOtMkBiNShtzGbEx2CwXB4cPK/gvocDN6SwL5bp8Lsh7Ad2PyTB2JrZ81mDUSFOA+wa0LIsHlPTswpvYMHEQpon11AULAEKF/8QyxGMXVxO3IkkosLafMpj3fJRc9Krh/3XCq2Uk0xIDEnIQkJyBaTmGP19K2QBYOD7wIgxC7DaogZ+GJIwqL+8mPwKVpHnuWYhzfntDWA/ikjl1ct+VeiDuLAoV1VhgC1xqA/4iaQO8b2HJWcPvQ07pk1hTbs9I5WvdzTfQLpwlSXKAISetVvTHXY4Vk64Ly6S3HFwVue6kR1+M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

crash_prepare_headers() counts memory ranges before populating the
allocated crash_mem array. The weak implementation used by ARM64,
RISC-V and LoongArch walks memblock.memory, while x86 performs the same
two-pass operation over system RAM resources. Concurrent memory hotplug
can change range source between the two walks and make the populate
pass overflow cmem->ranges.

Take device_hotplug_lock when preparing crash headers during
kexec_file_load(). The x86/riscv memory hotplug path already takes
device_hotplug_lock, so call __crash_prepare_headers() directly
to avoid recursive locking.

Sashiko reported this issue in [1].

Fixes: 3751e728cef2 ("arm64: kexec_file: add crash dump support")
Fixes: 1bcca8620a91 ("LoongArch: Add crash dump support for kexec_file")
Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
Fixes: dd5f726076cc ("kexec: support for kexec on panic using new system call")
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://sashiko.dev/#/message/20260806101002.1F84E1F000E9@smtp.kernel.org [1]
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 arch/riscv/kernel/crash.c  |  2 +-
 arch/x86/kernel/crash.c    |  2 +-
 include/linux/crash_core.h |  2 ++
 kernel/crash_core.c        | 17 +++++++++++++++--
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/crash.c b/arch/riscv/kernel/crash.c
index fe5a4b306aae..ac8df2edf2a7 100644
--- a/arch/riscv/kernel/crash.c
+++ b/arch/riscv/kernel/crash.c
@@ -70,7 +70,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 	 * Create the new elfcorehdr reflecting the changes to CPU and/or
 	 * memory resources.
 	 */
-	if (crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
+	if (__crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
 		pr_err("unable to create new elfcorehdr");
 		goto out;
 	}
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index e6f23933a6df..bef008a0cb22 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -465,7 +465,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 	 * Create the new elfcorehdr reflecting the changes to CPU and/or
 	 * memory resources.
 	 */
-	if (crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
+	if (__crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
 		pr_err("unable to create new elfcorehdr");
 		goto out;
 	}
diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index bc087124cd78..28e7a81cf263 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -61,6 +61,8 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
 				       void **addr, unsigned long *sz);
 extern int crash_prepare_headers(int need_kernel_map, void **addr,
 				 unsigned long *sz, unsigned long *nr_mem_ranges);
+int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
+			    unsigned long *nr_mem_ranges);
 extern int crash_exclude_core_ranges(struct crash_mem **cmem);
 
 struct kimage;
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index faa0f22dbb41..8a861a946e26 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
+#include <linux/device.h>
 #include <linux/kmemleak.h>
 #include <linux/crash_core.h>
 #include <linux/reboot.h>
@@ -344,8 +345,8 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
 	return 0;
 }
 
-int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
-			  unsigned long *nr_mem_ranges)
+int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
+			    unsigned long *nr_mem_ranges)
 {
 	unsigned int max_nr_ranges;
 	struct crash_mem *cmem;
@@ -382,6 +383,18 @@ int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
 	return ret;
 }
 
+int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
+			  unsigned long *nr_mem_ranges)
+{
+	int ret;
+
+	lock_device_hotplug();
+	ret = __crash_prepare_headers(need_kernel_map, addr, sz, nr_mem_ranges);
+	unlock_device_hotplug();
+
+	return ret;
+}
+
 /**
  * crash_exclude_mem_range - exclude a mem range for existing ranges
  * @mem: mem->range contains an array of ranges sorted in ascending order
-- 
2.43.0


