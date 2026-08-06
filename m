Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E602C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 06:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207466B007B; Thu,  6 Aug 2026 02:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B80E6B0088; Thu,  6 Aug 2026 02:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6BF6B008A; Thu,  6 Aug 2026 02:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D14036B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:58:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2B86A06F3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:58:48 +0000 (UTC)
X-FDA: 85069941936.13.9FEAF51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0884C1C0004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:58:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Id+KiXWC;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785999527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Og4J4rIMluGAROgsSgHc7NrmB9oSF18CDjoJb6Nf1RI=;
	b=EykH3IVXAK6R7ZcmjSMgOGpxTMAdA+iyWFxKfFCq2hK37Bbn5tOfIUvlehr+HEZf+TXB0k
	pWnF8h81AACVpdI3QmfVQAFywy5s8wog/3lR2gEkjEP1wujcgw77dhj1VCFXS+dBj98ZHU
	tFiO8sg8nURFqIspE6aRu5vY6h1D7qA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785999527;
	b=EWqEB/OHvO9/bvTbk/i7AvQd62ni/5sr6MpdrpipMcCteIL4Dl3LN7IdxQtjPAUuIDgsnM
	dqaePxefC6YBmPYZFMfGiAM26HM3JRBJvcPW8soqkEFQfn8sgCZBuSSy+6QHjhRjIMkl2N
	ib1Smj8iYl6aU6xwkFYyWQtc8bX+ih0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Id+KiXWC;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF84D42AC9;
	Thu,  6 Aug 2026 06:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DB91F000E9;
	Thu,  6 Aug 2026 06:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785999525;
	bh=Og4J4rIMluGAROgsSgHc7NrmB9oSF18CDjoJb6Nf1RI=;
	h=From:Date:Subject:To:Cc;
	b=Id+KiXWCH0b3bg7Qog+PMhWe2FZgZ/bTAjgf42f21DnSOXky2G+O00DZUtGzAPJTk
	 62wkCkugzNROZgeSjntHRq8FmWEy36oDPG5YXTBTgfzdUm/3sUidZ/0tLt18BVsBl5
	 wZwhfReGhh4l1mo2B1J6jXD5sNOb1l9+58CpldpJZ/YL+PZKh457y1F2Xy+LKyzlg9
	 S4guBDVMCwWjZLtf0a5AmV1xSfxMDseR+LLri3Bzd/71zyW3EmiIY8J6z5CR0EQa/5
	 H2i+UCbIIkFt+7FGSskzSLBNUcu3flkS0UsKXrtHlRcE/VHK870iAhYDPBNKxfw5Sy
	 d4kMiWejUY0gQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 06 Aug 2026 09:58:38 +0300
Subject: [PATCH] drivers/base, mm: move arch_numa.c to mm/
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJ0wdGoC/yWM0QrCMAwAf2Xk2WI7yhB/RXxIa1wjLJNkG8LYv
 9vq4x3H7WCkTAbXbgeljY1nqRBOHeSCMpLjR2XofT/4ix8cai5O1gldjDGlWF0IEWr/Vnry5/e
 63f9sa3pRXtqgFQmNXFKUXJqalUeW84S2kMJxfAEGyNpgjQAAAA==
X-Change-ID: 20260806-arch-numa-444bb4806114
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Danilo Krummrich <dakr@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, driver-core@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0884C1C0004
X-Stat-Signature: e71rqy6y58ghhc6sdzyuec3kkqjrrc9u
X-HE-Tag: 1785999526-145365
X-HE-Meta: U2FsdGVkX1/pr9XPQGuSM2GuD8/dVtjV7UCPaVWJc6AHsWV0bzcsf8rzqlMPrYn8uU5HOck70IYPlvV9fPBtw4fC+cEwvvsPPU/7jzWQttHoK82l7lKGVsHUBKyF5mKQrPrt6CZm2GgHQRqFZ+srfG7J+i3zxBDN51FJCuiX8xNnkHnvj2I+cme4g03DSOsOPrMbBXomXrZa4Y8+fWsLd5TMzJln6Tu9GETXw5jrcsLNDnN/1amTkeIIaqkx5KsbGBBv21fjfaTxN6BRhFNJzEJRy2q9tfEq7qIg/3mtaVUCQbFI8dPyqQFy9JRo14a1J1GQIT2mVvrDshUFEUPclQfqZxB/fMg9GVZWJDJXiO3XUePsgufR8/wuAxe/LhWWptV7SAiWDITlC/Bq4k8+57dP7uvF6eQ9lXVF6689p8rEZ4XgLmmYWJ1hG6SGX91BTXg2eccluy5tMYHyGiq3v6R51sCDm+9z1xF0gcsq0SDmLavUWhElL3voVIB2EZqUlL+9nZ0bYa1unBnqAEXFtfhtKepQUjH1/jdeGPRXgKktZTwkZf2ww8/s935XRnpBDYVRnOlxilPMVhHr8jRRzwyzcb1UriAZ74Jk4GIrHI5H4dcpLBnp4z+MZ4bNIwNCHB4B+P11ucSrDG5I212NU6WTvS0ELIgwlKtJTKDMoxYut543ZKbc0uX8T7gfQJ5gZXV5hua8LkVFhtwXDKDq9DwjPOtzyWO0JuYcMH8Ldh3wwV+dwUNEpC21eUz7ImpxqkKBPZHqhEzdFADfybLYaLUSNZFjSF/czwVGMFPC4Y5ga3NDYSp6e9j7H9ZehCpSkw/ZBR+PemZHuBN3xi82mOt5BiVeJNwwY1EQJ9Q73lgFD5DeoL3aucuXL1MxMm9GJDfI2wX2nPcXh0bFyYCaiunwEMZrFkt/e3PplfvRFHWvmiRCB2CDVoKhFL9bgm578UtKYqPdKA6Kf0yUphl
 4UmMB5iT
 GWVEr8XmGQ+JOpb5Wehf7JGXMhHder+Z+Cg2j9HN1btGxig4ZhIH9lZvZW+CpVH3zM6DUPLCPcPg35BSwixlal6uVJtFnm8KgoybfPtUHBSs8yQRrFexhEre/pqvTCZVMgm3r1wvgcuVh7m7mXSeSSZayLa2akDXwVOgoZ/HhnwkkqMtSnRWlgFg0YAYivWTfK5ycugASkezQ2/sAMHPsdZEzORHMQnHYppoZrmrIDHV3/dB/2Q3F7w8EQ1X2e5HOGPVzTV9lYKutqeUOuV+Q+nsaV9gPzl0yDxm7cpN3E4YzgNJxnmdloNT8QOx1xYyl+4igEZwb6T79yvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arch_numa.c implements boot time discovery and initialization of NUMA
topology on architectures that select GENERIC_ARCH_NUMA (currently arm64
and riscv).

Since this is step in the initialization of the memory management
subsystem, it's logical to have arch_numa.c in mm/ alongside numa.c,
numa_memblks.c and numa_emulation.c.

Move arch_numa.c to mm/ and add its F: entry to "MEMBLOCK AND MEMORY
MANAGEMENT INITIALIZATION" in MAINTAINERS.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 MAINTAINERS                      | 1 +
 drivers/base/Kconfig             | 7 -------
 drivers/base/Makefile            | 1 -
 mm/Kconfig                       | 7 +++++++
 mm/Makefile                      | 1 +
 {drivers/base => mm}/arch_numa.c | 0
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5114e6db7307..465b64f8e93c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16880,6 +16880,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
 F:	Documentation/core-api/boot-time-mm.rst
 F:	include/linux/kho/abi/memblock.h
 F:	include/linux/memblock.h
+F:	mm/arch_numa.c
 F:	mm/bootmem_info.c
 F:	mm/memblock.c
 F:	mm/memtest.c
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index f7d385cbd3ba..1d93bfc34490 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -239,13 +239,6 @@ config GENERIC_ARCH_TOPOLOGY
 	  appropriate scaling, sysfs interface for reading capacity values at
 	  runtime.
 
-config GENERIC_ARCH_NUMA
-	bool
-	select NUMA_MEMBLKS
-	help
-	  Enable support for generic NUMA implementation. Currently, RISC-V
-	  and ARM64 use it.
-
 config FW_DEVLINK_SYNC_STATE_TIMEOUT
 	bool "sync_state() behavior defaults to timeout instead of strict"
 	help
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 8074a10183dc..435710f643a5 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -25,7 +25,6 @@ obj-$(CONFIG_PINCTRL) += pinctrl.o
 obj-$(CONFIG_DEV_COREDUMP) += devcoredump.o
 obj-$(CONFIG_GENERIC_MSI_IRQ) += platform-msi.o
 obj-$(CONFIG_GENERIC_ARCH_TOPOLOGY) += arch_topology.o
-obj-$(CONFIG_GENERIC_ARCH_NUMA) += arch_numa.o
 obj-$(CONFIG_ACPI) += physical_location.o
 
 obj-y			+= test/
diff --git a/mm/Kconfig b/mm/Kconfig
index 9e0ca4824905..410b8a0a92b9 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1469,6 +1469,13 @@ config NUMA_EMU
 	  into virtual nodes when booted with "numa=fake=N", where N is the
 	  number of nodes. This is only useful for debugging.
 
+config GENERIC_ARCH_NUMA
+	bool
+	select NUMA_MEMBLKS
+	help
+	  Enable support for generic NUMA implementation. Currently, RISC-V
+	  and ARM64 use it.
+
 config ARCH_HAS_USER_SHADOW_STACK
 	bool
 	help
diff --git a/mm/Makefile b/mm/Makefile
index eff9f9e7e061..fd29be716fa8 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -122,6 +122,7 @@ obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_NUMA_MEMBLKS) += numa_memblks.o
 obj-$(CONFIG_NUMA_EMU) += numa_emulation.o
+obj-$(CONFIG_GENERIC_ARCH_NUMA) += arch_numa.o
 obj-$(CONFIG_BALLOON) += balloon.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
diff --git a/drivers/base/arch_numa.c b/mm/arch_numa.c
similarity index 100%
rename from drivers/base/arch_numa.c
rename to mm/arch_numa.c

---
base-commit: 075b74841bd0065a3bda3440873c747938e69b68
change-id: 20260806-arch-numa-444bb4806114

--
Sincerely yours,
Mike.


