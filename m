Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B92AD606A333
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 17:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FpX9XV92
Received: by kanga.kvack.org (Postfix)
	id C18346B0622; Thu, 29 Oct 2026 13:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8D46B0623; Thu, 29 Oct 2026 13:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7A96B0624; Thu, 29 Oct 2026 13:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DD616B0622
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:30:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EAB4FA7F9B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:56 +0000 (UTC)
X-FDA: 85376354112.22.A636E19
Received: from mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 108FC4000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FpX9XV92;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793295055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YeQsqnpkwn6ypXN7vyNImbLG7QIbHLNRV1Ffg9tI2a4=;
	b=DtUKk7yl12I2cj1buc5vdTlEjUiTfFV6sIJdJbzmaG0ikfLAhIlpQwRvvM2L/Uq5j4kJwm
	vdo6zORZ1tK3LvWPcFY7xtaIXYGHxczDT8BrwbDc2C1H/pD/7ZGMhKcu/HudS/b5qknnFb
	lg6J5qbAhn4xAyxJPjI5NOAlbrCi4uE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FpX9XV92;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793295055;
	b=bVet3jgrzvYGns9dm2GbW5YFDkhSccHQ/m9yyCBHn80Mvp6cCbWDtwGvZIC/OemEeL/TVl
	NrM9TBtY6DooaKa5tMYAZTI6ckGuypsf1rssLkgcQNNzNStO2YABSfcifvOUPVuIj/IL/E
	e5LLXxeZd7xt2ui/6BgnzL9wpZf7DfQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5xQkj3N9yiVJ8AVum9FtJNkr8nMttgbgXIeAZWsu7R4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793295053; v=1; x=1793899853;
 b=FpX9XV92A0v/B1Tp65pVnzHFflZPsb/Paqgp5DTXqZzfwEOcbIYDvyjn/jkvkoHcKBLGzh0/
 6unVyNBofcX839jRDqKW1UmW2dv6/m5EhOwc+cVK5Nc6TT90RVisiUXypBi6CNimLs9DaW7jg8/
 74i75g7i084UaIvQJWOHH12o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e9111306d7fcf669;
	Thu, 29 Oct 2026 17:30:53 +0000
X-Mizu-Trace-ID: e9111306d7fcf669
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v6 5/8] LoongArch: Allow memblock arrays to resize
Date: Fri, 30 Oct 2026 02:29:52 +0900
Message-ID: <20261029172956.20791-6-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029172956.20791-1-dongtai.guo@linux.dev>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 108FC4000A
X-Stat-Signature: qmxa9sj64q8s8q1qomunrogkzhqi4eoq
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793295054-978300
X-HE-Meta: U2FsdGVkX1/gw1QJPvjwOcyXO2t3MK881LsSCJBYFNPY2UUcaGYKmkMgAIDiTDeVJ/XdQAXdnNt6FGrCaoVYqAqLC88xmJWWCTcBTLQSissqmiJvtGyFqYz5MYSmYgzI5hFXMFT9FBqRZeD9wF6lrzCDNGxd+2xij7SDBd4CFYtexjqjPqqSTYVbDaxS/UISUcaj7zOzCnxrzji5cuJ8iDgfhEiNnnGw3puOGKI0Y1tgRQ7AUrtg9DxdTodnWNQS0j8Wv4MczvbfCgaLvgPdlrU3lCEYzAwk1YONWZ1BScT1uwJLGbXjdx7D7OHFg3IwE2csM0Ze0dx5vgU2sPGTVSLIv6lCqlB7mna9WX97BOdQWZcGY9oWkHbmyo1wxVg11cHzCtzD7y5qsY89M0msrQnwkypFldFgsVuhtDgut8It3IJeSr8crMlIr33k8AukIBs+9I/i6So69BM6CVNdn5lFahKzmphKWqO1n3HB4urNXPumYbmVdaicVDskmzMotJ84A1FUnl/aeb5CHfymECaDSS3GAAuevCIxnx5YDA6zQZCXz8Ao387MRgF0zVm2U4T3eq3YlJuzkTuDPzYa7Nu042kVGp626eGGfwsHOvK3Igo6BNrwI8XBLQz5G7MEGCEbkkVcWsG5Jhx7Z3GUGVCl8QQtFhCzwORe7GEasLzzVwkCZhNpImrBDNksI0HvTXAi9jRkygGMLEAk0UetYozANFx17zT0vsam5dIcTb48cx6IQ3acEnCQPi8LZ1oX1oCfq45Y8RPErDHxZKMN09k2vvEadf11bsM91HZ7L6Q2I87B8bcTGrjYx7/y4R3g5HoP79148s0qlWe7TMGsdvakGZWPYTIc0Dv6Nxdsol3sSM829HXg1A3AtTRGzKbIiiB6K9nVDfUgzfVrhnhqPePvmwEyWUo2kWeXThDlJNajC+fO7XvXVJ3J+nN4jdrmZoHIi+7dpmDyDsbIYRI
 nsURII7G
 Xa5+CUK3KJalR0zAnD1TZZQxa56ibWU6iWSATHsEMN4Rz6XBPp0JFlXe4BGsLpj4AqnlgkcTnY80MavUjIcBBou4iOSPE0YyNw4vOvhOfRUcBkEF1Y0wzQ3kmvTjA1h6GL2sq/iZVflX7y7sxXvwgFR9Qf866SHWdR0z8W2Jj6kIkDdla2BrCLakS8K+9WE989nbsmZpQEBE2WghEYyrIl7RLf8bRnPss1jJHASszlasKLk0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: George Guo <guodongtai@kylinos.cn>

LoongArch never calls memblock_allow_resize(), so the reserved region
array cannot grow beyond INIT_MEMBLOCK_RESERVED_REGIONS entries
(INIT_MEMBLOCK_REGIONS + NR_CPUS).

After kexec, kho_memory_init() reserves every range preserved by KHO.
Each range that is not adjacent to another one needs its own entry, so
with enough scattered preserved pages the array overflows and the
incoming kernel panics:

  Kernel panic - not syncing: memblock: cannot resize reserved array
  Call Trace:
   memblock_double_array+0x2d4/0x2f8
   memblock_isolate_range+0x54/0x1a8
   memblock_setclr_flag+0x44/0xe0
   kho_preserved_memory_reserve+0x78/0xb8
   ...
   kho_memory_init+0xbc/0x394
   mm_core_init+0x124/0x154
   start_kernel+0x568/0x6dc

The liveupdate luo_stress_files test with 500 files triggers it on a
kernel without CONFIG_SMP, where NR_CPUS is 1. With CONFIG_SMP the
array is larger and the test passes, but more preserved memory still
overflows it.

When the reserved array is full, memblock allocates a bigger array
from free memory. This is only safe once all memory in use has been
reserved, so enable resizing in arch_mem_init() after the firmware,
kernel and initrd reservations are made.

The memory preserved by KHO is reserved later, in kho_memory_init().
A new array cannot land on it either, because kho_populate() already
limits memblock allocations to the KHO bootmem areas, which hold no
preserved data.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 arch/loongarch/kernel/setup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 6fa4a22a58fd..dff2e0c67ea0 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -402,6 +402,9 @@ static void __init arch_mem_init(char **cmdline_p)
 
 	check_kernel_sections_mem();
 
+	/* KHO may restore more reserved regions than the initial array holds. */
+	memblock_allow_resize();
+
 	memblock_set_bottom_up(true);
 
 	swiotlb_init(true, SWIOTLB_VERBOSE);
-- 
2.53.0


