Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A2CCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 17:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401336B0008; Thu,  4 Sep 2025 13:57:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D38E6B000C; Thu,  4 Sep 2025 13:57:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1F66B000E; Thu,  4 Sep 2025 13:57:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1ADED6B0008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:57:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BDE4416031F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:57:46 +0000 (UTC)
X-FDA: 83852325732.14.E355EF6
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf23.hostedemail.com (Postfix) with ESMTP id C4FCF140004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:57:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=vbfX1p7u;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=CORBvYQr;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757008665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fKkT/jtd0n27Ebg1XJYwdmE71ycuNc65mhqa+ae0eSM=;
	b=mC4uDbTITGnLPJWF8XLKLXx8c+De/iyGn4gl3Gl4GinCHe8N23oT6aS6HeDiEMh2JC+gcK
	bR0h4LebgueLkTwiRfopyLGy00Iw/7oes4fnSvdVf2VITnF7w1XpjAA68P3Nb1Qj7iClaQ
	n0AgjOAd4QC/ixA3Tg2z6WHRpScw5WI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=vbfX1p7u;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=CORBvYQr;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757008665; a=rsa-sha256;
	cv=none;
	b=eRMFxotukjj3SMWKlsfXQy7SdhAlvJOY3mEdCD4k3UfeZl9UZ0um3QvgsYTZCp+Bsm5qCc
	cSpjYy9tbJT/UUwqxW4wC0dXKl9bxRSFuwDb51LAkL701BlVpZxUVRArRaQ9cgh2rqucSp
	yEk9zsMSeFoYGj4nXGoCJaY/PHUWXvE=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 2310DEC0343;
	Thu,  4 Sep 2025 13:57:44 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 04 Sep 2025 13:57:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1757008664; x=1757095064; bh=fKkT/jtd0n
	27Ebg1XJYwdmE71ycuNc65mhqa+ae0eSM=; b=vbfX1p7uNPVEmS1xt0Y+B7P0rP
	Hrma7440GZyAbhSNpvBUZ63QUm7pGSdYhmZYUe/1oHb6iFEudqdSC+CW/3UF+aIf
	yQgtkRMwIbKBltlZWweVYvy5oeX+B1K87DPsbKyb0s2Px37wpDFpMwsRejx8DLmf
	taaRI2Pixl0dGUy5t7TmcN9X3OSaXlSaq4sX8e3bkR7aO4IXjXjg+JYUvLyv59UI
	lXC0Yvvq5+3enWmYiZLXw9cYD+NaO3i6hzb6HFeLTdxS1Ve9hutlgjuk13NKAI8I
	+JjFdra4quScQNC5G3GfyznQqkCgqUzoY6e40jR1zZvJac2GsjAQX2erYHDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757008664; x=1757095064; bh=fKkT/jtd0n27Ebg1XJYwdmE71ycuNc65mhq
	a+ae0eSM=; b=CORBvYQr8Y3saRfcSX967tyY4HxWnUPE1xA75VQPOHCtnp1dBUo
	4GlwupHSGvsP8BJ0Yz0kdMQwmwO6Ok8oapGDtibsF0I/CAbvhEzsY2f0SXrOBzjb
	iHu3GgrYUtQmipfcKydFnJQAfQlw6r02Af7ORAyvXr3OhYz8q24sTv1NcaOGZ80T
	04TlnpvQQYGJh3gNiZwsEtbf6Y+brj8OJXnvJTXs6ceOEjMp1o0Ox6xpzpH/kOAt
	k2G9aQo2JP4kbAI/qQArnJrQRO1GJTraR4lvTG7cctj0Vv6OIhDguiPZVkc5TG8D
	V/WIyTIVQIRHbQck+4CzODfZbILQcV/eFiQ==
X-ME-Sender: <xms:F9O5aLihvfWj940jH5OLqSdaG6Yzw5F9HfXCIKnqFcIZtWfacYzfMg>
    <xme:F9O5aFaUaToJGvCF8n3m2I7bM06rMKn1JABqhIWthM2p9XSClqsi7l5mnV4v5uRvB
    CUzKFPyLZZ36bgGBUw>
X-ME-Received: <xmr:F9O5aEl988_9Zid7bpBf8JWpFHAGAXWoGlvm1NouvuTJJjcP-AYaEYpVQI9n>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeiieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    ephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepkhhirhhilhhlsehshhhu
    thgvmhhovhdrnhgrmhgvnecuggftrfgrthhtvghrnhepiedvjeevteeuleegieevheevud
    evffekleekvdetjeeiffdtkeetveejjefgueffnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmh
    gvpdhnsggprhgtphhtthhopeduuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohep
    rghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurg
    hvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhopehlohhrvghniihordhsthhorghk
    vghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesoh
    hrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhrtghp
    thhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesgh
    hoohhglhgvrdgtohhmpdhrtghpthhtohepmhhhohgtkhhosehsuhhsvgdrtghomhdprhgt
    phhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrgh
X-ME-Proxy: <xmx:F9O5aDiwAqTOh0UQQcCbulVIqb7d-dO7VOChaj-8pinVOJSOTtSs7A>
    <xmx:F9O5aOTdj6ViXgxBew33Oe6D1AwmF8WjCq7FA55NQhu54VP7-h427A>
    <xmx:F9O5aMaVGv15mM4iSV-dE5oowNt_SSatNYjQqKlgPDzUeGxOnAAdRQ>
    <xmx:F9O5aDR8TmTJnVvSi8Ieg9wF3pSFT0bxjZgWrHuHcNsxcEmjizTkXg>
    <xmx:GNO5aOHfikJRX-FnSl-82pcEKeUyv5A63unMFIP9Yc3599veHJL2FDJj>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 4 Sep 2025 13:57:42 -0400 (EDT)
From: kirill@shutemov.name
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org
Cc: Usama Arif <usamaarif642@gmail.com>,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH] tools/mm: Add madvise tool
Date: Thu,  4 Sep 2025 18:57:29 +0100
Message-ID: <20250904175729.1029735-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C4FCF140004
X-Stat-Signature: j4ttri6oygcfbg8txbourbedshd7rer8
X-Rspam-User: 
X-HE-Tag: 1757008664-217392
X-HE-Meta: U2FsdGVkX1+t34IyCzHTyMPWR2CWTv/Kj1qgG288f8q3sckzYr4siXRWq0zH6gROIsWuiAH2854jZi/IHVsDw/xcZ/S6eaT54kci2UUyElx2I9EBnjpiotjGqq6P2cuds4YiotmRBx2CGyugtI/x5Ua52eh/GRiSyEOwhyqokReAqY+x7JNPYFhfcApP/Nnwj4opPY5ZqsieSPCmAUWHFpF9IBNuR+zgWgxVjoUe4drYmLaWyWkAaKlQDvazcjc3XUtY5a5NgA1fsGR/6JgF6JcI/9Tvo8hUo2yArf8synL/ANHNHvJiOFi3+5v+iQqGFL191yrqsjEjBo6dWsRl1aONCXyVuPyt17wEr9JChKE9dnw26ifWv8jvKF+EpNH7m8qmKWrCueDplp+D0m/taFpzPMpFmMiCxBPnKq9F4AAFMHJW57wJ4rWmgyl+9m3s+IA139wz4Jy+HPKtkki1+vgLzsaFzoit67YrqvF5eC8RrO5MoZ04fKGkh4PoICeYjdpQng5KvHxG3e0OfeMSn5GxF51hYHiBQyQwwNnBuEm/NKhq7stF/5wmFkmR9GBJV6tzkqwaczLJdNz3AIZjya7wq6FpNy0I1n6cV26ixfhIPPUfomvaYKeXn6BzP5mgbBzDJyOSPWs/SHMOkmzlg/Jn7RVBS/vQrpO46iHQrDEjWp65ezyERV95EWHVZ1f1S1AdS4bN1ydwzPSCnIzI5E3C88WbFhtSEvuFF2Ia8ppEQ+0/aG/RFFoGaPyd3eztiX+e+7e1BN39xtVs7IqFd+Lsyc1hF46NqeNiL2KEdRibnEPG483R2C9PXgLi6n50ol48Q5yWuy9t3aASK5aZZtHUEczjxGOrbBo8n4H2a4Vin8ySMkvmJjTZ7mzMZkB9XHaaQHX6DpbL9y2J6HGKvH1zRFKxyLD0sq+8kGILfSzYgNqD15xfMasUHz3ek3T8xKETUMu1sFzADalKlS4
 S+Tb8GSc
 EU5PNnPRAhKX3GJA70Uk8kr1AsnXVXFTrYAi5GI8zCgFKBJy2yzVOagvV0t0Ty7PpJKYVagoM7KSvS9zK5TYaFwaPHbm76no85d64nvAFRV997hGBHhwgDBl+7EurJuy8OLuapUzg0pGJ5ZE+jV6KWnLWM4WbIIhKkNH42ces7hRcsv0YifBotGO0ZTjhQ1pkB1C5F5Nq9G8Z6g0k56fW/QbH2q3ljuYhJYl4ayGo+YeFwVN07kLPwiMRwmyoacLhybiCuGn0wilIqLIQALTGVRbvL0PG0tjf3tYXL+0rSfEspvuszJawrT0jX/Sw04CgatIQSVLiVv5vAhMCsfBOS+iAr0Cc5JJzSPgYkZzivu/COyjz5/jKkX2zlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Add a simple tool that allows to issue an advice on a process or a file.

It can be useful to experiment with effects of an advice on a workload
without modifying the workload itself.

Only supports advices available for process_madvise().

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 tools/mm/.gitignore |   4 +-
 tools/mm/Makefile   |   2 +-
 tools/mm/madvise.c  | 170 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 174 insertions(+), 2 deletions(-)
 create mode 100644 tools/mm/madvise.c

diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
index 922879f93fc8..b713fcf4a2e0 100644
--- a/tools/mm/.gitignore
+++ b/tools/mm/.gitignore
@@ -1,4 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-slabinfo
+madvise
 page-types
 page_owner_sort
+slabinfo
+thp_swap_allocator_test
diff --git a/tools/mm/Makefile b/tools/mm/Makefile
index f5725b5c23aa..db315a48adcd 100644
--- a/tools/mm/Makefile
+++ b/tools/mm/Makefile
@@ -3,7 +3,7 @@
 #
 include ../scripts/Makefile.include
 
-BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test
+BUILD_TARGETS= madvise page-types page_owner_sort slabinfo thp_swap_allocator_test
 INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
 
 LIB_DIR = ../lib/api
diff --git a/tools/mm/madvise.c b/tools/mm/madvise.c
new file mode 100644
index 000000000000..038b3e1076ea
--- /dev/null
+++ b/tools/mm/madvise.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <limits.h>
+#include <stdarg.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+
+static void usage(void)
+{
+	printf("madvise TARGET ADVICE START END\n\n");
+	printf("Arguments:\n");
+	printf("\t<TARGET>\n");
+	printf("\t\tA process ID or a file to give the advice to.\n\n");
+	printf("\t\tUse \"./\" prefix if the file name is all digits.\n\n");
+	printf("\t<ADVICE>\n");
+	printf("\t\tcold\t\t- Deactivate a given range of pages\n");
+	printf("\t\tcollapse\t- Collapse pages in a given range into THPs\n");
+	printf("\t\tpageout\t\t- Reclaim a given range of pages\n");
+	printf("\t\twillneed\t- The specified data will be accessed in the near future\n");
+	printf("\n\t\tSee madvise(2) for more details.\n\n");
+	printf("\t<START>/<END>\n");
+	printf("\t\tStart and end addressed for the advice. Must be page-aligned.\n\n");
+	printf("\t\tFor PID case, it is addresses in the target process address space.\n\n");
+	printf("\t\tFor file case, it is offsets in the file.\n\n");
+}
+
+static void error(const char *fmt, ...)
+{
+	if (fmt) {
+		va_list argp;
+
+		va_start(argp, fmt);
+		vfprintf(stderr, fmt, argp);
+		va_end(argp);
+		printf("\n");
+	}
+
+	usage();
+	exit(-1);
+}
+
+#define PMD_SIZE_FILE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
+static unsigned long read_pmd_pagesize(void)
+{
+	int fd;
+	char buf[20];
+	ssize_t num_read;
+
+	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
+	if (fd == -1)
+		return 0;
+
+	num_read = read(fd, buf, 19);
+	if (num_read < 1) {
+		close(fd);
+		return 0;
+	}
+	buf[num_read] = '\0';
+	close(fd);
+
+	return strtoul(buf, NULL, 10);
+}
+
+static int pidfd_open(pid_t pid, unsigned int flags)
+{
+	return syscall(SYS_pidfd_open, pid, flags);
+}
+
+int main(int argc, const char *argv[])
+{
+	unsigned long pid, start, end, page_size;
+	int advice;
+	char *err;
+	int fd;
+
+	if (argc != 5)
+		error(NULL);
+
+	pid = strtoul(argv[1], &err, 10);
+	if (*err || err == argv[1] ||
+	    pid > INT_MAX || (pid_t)pid <= 0) {
+		// Not a PID, assume argv[1] is a file name
+		pid = 0;
+	}
+
+	if (pid) {
+		fd = pidfd_open(pid, 0);
+		if (fd < 0)
+			perror("pidfd_open()"), exit(-1);
+	} else {
+		fd = open(argv[1], O_RDWR);
+		if (fd < 0)
+			perror("open"), exit(-1);
+	}
+
+	if (!strcmp(argv[2], "cold"))
+		advice = MADV_COLD;
+	else if (!strcmp(argv[2], "collapse"))
+		advice = MADV_COLLAPSE;
+	else if (!strcmp(argv[2], "pageout"))
+		advice = MADV_PAGEOUT;
+	else if (!strcmp(argv[2], "willneed"))
+		advice = MADV_WILLNEED;
+	else
+		error("Unknown advice: %s\n", argv[2]);
+
+	page_size = sysconf(_SC_PAGE_SIZE);
+
+	start = strtoul(argv[3], &err, 0);
+	if (*err || err == argv[3])
+		error("Cannot parse start address\n");
+	if (start % page_size)
+		error("Start address is not aligned to page size\n");
+	end = strtoul(argv[4], &err, 0);
+	if (*err || err == argv[4])
+		error("Cannot parse end address\n");
+	if (end % page_size)
+		error("End address is not aligned to page size\n");
+
+	if (pid) {
+		struct iovec vec = {
+			.iov_base = (void *)start,
+			.iov_len = end - start,
+		};
+		ssize_t ret;
+
+		ret = process_madvise(fd, &vec, 1, advice, 0);
+		if (ret < 0)
+			perror("process_madvise"), exit(-1);
+
+		if ((unsigned long)ret != end - start)
+			printf("Partial advice occurred. Stopped at %#lx\n", start + ret);
+	} else {
+		unsigned long addr, hpage_pmd_size;
+		void *p;
+		int ret;
+
+		hpage_pmd_size = read_pmd_pagesize();
+		if (!hpage_pmd_size) {
+			printf("Reading PMD pagesize failed");
+			exit(-1);
+		}
+
+		// Allocate virtual address space to align the target mmap to PMD size
+		// Some advices require this.
+		p = mmap(NULL, end - start + hpage_pmd_size, PROT_NONE,
+			 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+		if (p == MAP_FAILED)
+			perror("mmap0"), exit(-1);
+		addr = (unsigned long)p;
+		addr += hpage_pmd_size - 1;
+		addr &= ~(hpage_pmd_size - 1);
+
+		p = mmap((void *)addr, end - start,
+			 PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED | MAP_POPULATE, fd, start);
+		if (p == MAP_FAILED)
+			perror("mmap"), exit(-1);
+
+		ret = madvise(p, end - start, advice);
+		if (ret)
+			perror("madvise"), exit(-1);
+	}
+
+	return 0;
+}
-- 
2.50.1


