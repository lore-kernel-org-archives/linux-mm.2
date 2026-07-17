Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C29DEC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466206B00AF; Fri, 17 Jul 2026 13:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417476B00B3; Fri, 17 Jul 2026 13:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B78C6B00B6; Fri, 17 Jul 2026 13:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2AEE6B00AF
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:01:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 833621C015C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:13 +0000 (UTC)
X-FDA: 84998884026.24.CA80CC8
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf19.hostedemail.com (Postfix) with ESMTP id DDC081A0003
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=fUvzVVVA;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784307671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phv1B9Yxat6YIEopEPUTNjYYzL54eFSY9r4GoCdruM0=;
	b=l+AJ3kTa0hfqZezPZ6j9POi42IksAmgTmlCFeezHmQ0e9R7oZ/Aqyi1F2jkmouoD8+U1C4
	APFVKKA0Y4NjNjsW9YVoGrEajSiVPXWEuj/C0fuH4N+xLR45j3UPZKwcA/axmjbM2YdlpX
	Pr8TzBUlZ9R1Wd8EAEgvC0V1W4LjPKc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=fUvzVVVA;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784307671;
	b=F0KwzcQg/u2xPlCaLf1TBF8FOp4jMraEpaboDFc1xPyNf/SNPUDXMs/SAiO3jlVhO4wQfp
	4Hwjl8VRW+Ox5/VhxlIGW5fj5XqxUPFZlleh894pPy6OlSVVvF742S93j5WPac3chNld6N
	qn8AQNuuzc0106eb6cbbJvHnzM2Ejts=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=phv1B9Yxat6YIEopEPUTNjYYzL54eFSY9r4GoCdruM0=; b=fUvzVVVApRtKUdaKQ2JXL1FOSt
	P8LOocD9dNPQdTPWaFrOPMhbGyafnfbs/WBFs5ZfDMBbRXr8K05WR5fH0Z36lT1BR22jJnMaub5EU
	AMT7eivQQ9grDNDwPxeMXmIw6JkNAGLKM7T0UxfdFKEznNCh3OYKCAPolg9J78JZvmH4CMMGtrCAK
	44UejHZ6A78Sz6fs8j5HZ1q9fdMbbsLAuUIMFf1nq2RJSL4b4l86iYqDlF8NMykYSgAm2Nh0X7J25
	+r2Q0U/mXEgVjlcLibOlQkJ42708lC0+0Sy7MmCnQxSQ4zH/Kjgy7zf53CpP+vX6ALUUcegly8pP1
	6vbTt4+g==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wklvS-000000001w4-0k4V;
	Fri, 17 Jul 2026 13:00:38 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC v3 6/6] selftests/mm: cover /proc/pid/mem access to VM_PFNMAP memory
Date: Fri, 17 Jul 2026 13:00:36 -0400
Message-ID: <20260717170036.743149-7-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260717170036.743149-1-riel@surriel.com>
References: <20260717170036.743149-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DDC081A0003
X-Stat-Signature: gursykwzbgj9copmshrch1dzsb7gznej
X-HE-Tag: 1784307671-357585
X-HE-Meta: U2FsdGVkX1+R41be5/b5s9R7kySGXk+d/7ZyaCNHnQB6LMPtyJTDJo0aLIn5MlxiPxo0przT60JqM50HximyErt096CeejSZnD43xWgIcdgmsEsxQS87rwRnujkI4sVF4TgVcsFuqI9kh++HhMl8+cnkgBfyRsW/zOq+vGtzu1XYSwqfq+PtNYJo3lJln06yr+FLLGf1AXCcxBtbNIFecL6npCb2telERkooMaNJ4ALPEDAQ747CV2Bg7xQRq2zKdG2TwtjR+buGz5VaWjc1l8uHimiNHbQcUgNqvZPAfkMvcBMV681HaluMJq/8kGtCg2U4pTa63iAljn9Df9I5sJHW/9LD+EJQ2Cn/qLlhnTlaubPoukyjokLNhHfbrnUHDOC1QLebT9lR0Cl8OEVv/KHNyureIe6jxtgKKdZJj1uFcGaxhqPJdGKxC0sEBEkYK+h5eyBiKR/QjMiydYb2nR7k42HyhEz/ObsdAp17M0bsLrzua41o38saD6ORkOKavQIyjKY8DV+zcxHgBvAw0Sx3tF/lVwh40/JDFBIRfvQwBUlgujB0lfl7u4nbmnY7m95pv7xXL2g8Xd0FRQp5ljo292F/WP+NaOjCuJ7B8fGbtXb3dch7eIGFDkGlr/XTjfXXdsC7/4quRRptTH0s+2FZ/Z22zugP66P3yH6eG+r2Era7dbCKIBwLJr65p8hunDRm+H/+C0KbwD6yHexmhdyNKJcWxi5MBVNsKnnjr7ePi0zTOkk/agvGpat1lUz+9RvNBz23zwlIPVRBnoFGF9SAuLrUS1uwRLXhBDEzeTR32e/7cRV30NeHzcCbJC8Sm3viDubQft3N+eBS/Gmw+x4Xzjj3C6k5aLJHGhzgGkIJGcWH83I9h0jmp9d4UrIElaEvBQe6HgoDDAntynLleiNwYrh+rIbUIVBylIKnPz88otHKU3rdwxZFiIvLzBLmbwU5Jkj3vwwc/XEMqYo
 8ibGQ7TD
 JMQ6CYlWxUPUESrsODuo++8NN4yu36nv/9cnQphY6YlEI0avzih5zZ3E7H/JDlBUobeW8WkwxCxfvAc9OwI6zCnjsQSfvDytnlECmzX2iBL2Zu9x7A9GNHie7zJNdYg/z3zPVkmGblGQfc3u1s4UPMWJfL/n14OphOgZZS4yKIxMyMdNvael2sIl5DElh1qDAb1WO7zy6Vs6Rs1wOEWvhB7uGGre7or1y+LTplJnDI39xKw5K3ADcPYmpA0V9J021fyooHHYS0aFOQRYTQU3v77JW8O8yL3sVOu3M/4szXfMtXfIJwhWixmAbpBfvmZvXHUZZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reading a VM_PFNMAP mapping through /proc/pid/mem exercises
__access_remote_vm() two ways: a COWed page has a struct page and is
returned by get_user_page_vma(), while a raw PFN has none and is reached
through vma->vm_ops->access().

Add two tests to pfnmap.c, both reading VM_PFNMAP memory through
/proc/self/mem.

procmem_cow_read maps the file MAP_PRIVATE and writable, writes to COW a
page, then reads it back. Without the struct-page path in
get_user_page_vma() this read is short: the access falls back to
generic_access_phys(), which ioremaps the PFN, and ioremap of a COWed RAM
page is rejected.

procmem_pfn_read reads a raw PFN back through ->access(). ioremap rejects
RAM, so it runs only for genuine device memory and is skipped for the
default /dev/mem System RAM target.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 tools/testing/selftests/mm/pfnmap.c | 66 +++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
index 4f550822385a..6ff5d1029517 100644
--- a/tools/testing/selftests/mm/pfnmap.c
+++ b/tools/testing/selftests/mm/pfnmap.c
@@ -31,6 +31,7 @@ static sigjmp_buf sigjmp_buf_env;
 static char *file = "/dev/mem";
 static off_t file_offset;
 static int fd;
+static int target_is_ram;
 
 static void signal_handler(int sig)
 {
@@ -113,6 +114,7 @@ static void pfnmap_init(void)
 		if (err)
 			ksft_exit_skip("Cannot find ram target in '/proc/iomem': %s\n",
 				       strerror(-err));
+		target_is_ram = 1;
 	} else {
 		file_offset = 0;
 	}
@@ -271,6 +273,70 @@ TEST_F(pfnmap, fork)
 	ASSERT_EQ(ret, 0);
 }
 
+TEST_F(pfnmap, procmem_cow_read)
+{
+	char *priv, *buf;
+	ssize_t rc;
+	int mem_fd;
+
+	/*
+	 * A COWed page in a VM_PFNMAP mapping has a struct page, so reading it
+	 * through /proc/self/mem -- __access_remote_vm() -> get_user_page_vma()
+	 * -- returns it directly, instead of routing to vma->vm_ops->access(),
+	 * which ioremaps the PFN and cannot reach a COWed RAM page.
+	 *
+	 * Map the file MAP_PRIVATE and writable, write to COW a page into anon
+	 * memory, then read the page back through /proc/self/mem.
+	 */
+	self->size2 = self->pagesize;
+	self->addr2 = mmap(NULL, self->size2, PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE, fd, file_offset);
+	if (self->addr2 == MAP_FAILED)
+		SKIP(return, "Cannot create a writable private pfnmap mapping");
+	priv = self->addr2;
+
+	/* COW the page and stamp known bytes into the anon copy. */
+	priv[0] = 0x42;
+	priv[self->pagesize - 1] = 0x24;
+
+	buf = malloc(self->pagesize);
+	ASSERT_NE(buf, NULL);
+
+	mem_fd = open("/proc/self/mem", O_RDONLY);
+	ASSERT_GE(mem_fd, 0);
+	rc = pread(mem_fd, buf, self->pagesize, (off_t)(uintptr_t)priv);
+	close(mem_fd);
+
+	ASSERT_EQ(rc, (ssize_t)self->pagesize);
+	EXPECT_EQ(buf[0], 0x42);
+	EXPECT_EQ(buf[self->pagesize - 1], 0x24);
+
+	free(buf);
+}
+
+TEST_F(pfnmap, procmem_pfn_read)
+{
+	char buf[64];
+	ssize_t rc;
+	int mem_fd;
+
+	/*
+	 * A raw PFN of a VM_IO/VM_PFNMAP mapping has no struct page, so
+	 * __access_remote_vm() reaches it through vma->vm_ops->access()
+	 * (generic_access_phys()). That ioremaps the PFN, which is rejected for
+	 * RAM, so this only applies to genuine device memory.
+	 */
+	if (target_is_ram)
+		SKIP(return, "Target is System RAM; ->access() cannot ioremap RAM");
+
+	mem_fd = open("/proc/self/mem", O_RDONLY);
+	ASSERT_GE(mem_fd, 0);
+	rc = pread(mem_fd, buf, sizeof(buf), (off_t)(uintptr_t)self->addr1);
+	close(mem_fd);
+
+	ASSERT_EQ(rc, (ssize_t)sizeof(buf));
+}
+
 int main(int argc, char **argv)
 {
 	for (int i = 1; i < argc; i++) {
-- 
2.53.0-Meta


