Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE1E6606A6A8
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=HaLrY6vi
Received: by kanga.kvack.org (Postfix)
	id DC3BC6B0952; Wed, 25 Nov 2026 04:15:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D99FF6B0954; Wed, 25 Nov 2026 04:15:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB17F6B0955; Wed, 25 Nov 2026 04:15:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9FECF6B0952
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:15:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 204EFC0E32
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:15:01 +0000 (UTC)
X-FDA: 85473082002.02.EEFD38E
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf03.hostedemail.com (Postfix) with ESMTP id C1DF520008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:14:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=HaLrY6vi;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf03.hostedemail.com: domain of wangxuewen_ky@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795598099;
	b=nS0RRD60r1OxuUeEGG1tjjac8El2vGcBY95oRKbC1XNrvqossMharRwS7lkmNO2Acn4VbD
	o0JRSA6Vsjo9pfXr0pIfea5PE5QjKeG5QPvkEPsLYSYMGJxYnv2QQodTTwysqj4/W0rYqy
	Ty0FlU0DkZ+TCZn6oq5WuhUPnShqFqM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795598099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=y1kNffUcvdpobzp+ZxSevNO0697zJUK1Gx23nNr5DRA=;
	b=Eu9HH2fdpxb+OFou0rJTklIVUcLxsCNxU7MDgzSP67WZDCIl1vDMVmcf5qZkjrnfJj7xt/
	DGPUSBThAEWgKhPnYhWlDcC3gh4cuau3BJaMUEUQ9yuAkqfzXlNf+LMmwQtcBQMpBHO47F
	7PCufYaIrYnoWnLncU5Xl6b6zHUtJZU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=HaLrY6vi;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf03.hostedemail.com: domain of wangxuewen_ky@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=y1
	kNffUcvdpobzp+ZxSevNO0697zJUK1Gx23nNr5DRA=; b=HaLrY6viqHcpnU0jL7
	eP0yKx9h2tQX6XY4MuXniaW/35Y5CFq1Wza5sOm+BfCY9dT1OFWAaMfh3nHC5Inz
	5RYitasG2HO9jpCVhDAqr9mgHQXZv1BMIiKQjhYP8jN9nVm2xFD06+Z5T2n3+Qj8
	yB2uXDgX63scSD/dFxrk+RQxQ=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDH7yzwpgZrIz5UHg--.45691S2;
	Wed, 25 Nov 2026 17:14:25 +0800 (CST)
From: Xuewen Wang <wangxuewen_ky@163.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	chansen3@cisco.com,
	sj@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v2] tools/mm: page-types: flush pending idle bitmap bits after walking
Date: Wed, 25 Nov 2026 17:14:08 +0800
Message-Id: <20261125091408.1584017-1-wangxuewen_ky@163.com>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDH7yzwpgZrIz5UHg--.45691S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZryrJrWfKr18GF4UuFy3Jwb_yoW5Cryrpr
	ZxK34jyw4kta4fGwsxZrnrAF1rAwn3XayfGrW7G345ZayUJF1jq3Wxur10vw18WrWkCFW7
	Jrs8GF98WrWUArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jmwZ7UUUUU=
X-CM-SenderInfo: pzdqw5pxhzv0xbn1qiywtou0bp/xtbCzRNCK2sGpvOLoQAA3l
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: C1DF520008
X-Stat-Signature: gm53nc77bmik4uw3pjrrz1u9xyzbesgg
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795598096-506950
X-HE-Meta: U2FsdGVkX1/8Um8CCKk088Do4hOBh6bRbQ2sMnfc8+CYOCcFnLzuGPtoMcpXXihbUPvXp4/DY+V/Dj+96qwJNgm5b8BebNguvXQZZ3LlVQ/8jwwnEqkbxUt062LHsZJwYgcy7+zHUOrXDh9rmAk8xowRk7tRDqlUkkcrmrRyVMPq3L43efGPqIFYZqCQtYqZGLWmlACiUGb0sW2cvDaPTky1TaDvZN9J/9W4Y7Vc74IhABVE5pnBEc7pU/u1jRK9x561PVOY7vjsGwpcImIZwGHNn7Wyx9GG2bhJrZZxog4KptsHB3QL447/6UgGFpyzvKhObI5eLh0objVlINGIMeL3iTUPKqaGp1KQ9/ERFP/gjFD0jmSm6+ceC1uwHg6eo+z2FAVqSj2nAgPJa+jzWMyZHEslANfcMYyzEEoMswR8F8k1DGNTzbeI7ziKsl0/WVekjzUFJkF6XTYo46QTwNOC4Ka0S0iLrW91PSzNZBblIWrlFUxZdxoCGdzOTjZ7vb5KYn50gAICRgHUiARdCcgzL40+/An0yL0YCdNTPAwW3yiUF1Dm2LFuyYR/OvlJkk5Rv7m+oJx+1Q6hDpDYlSC+l3O7ZhKxklFTtWeVJH/UuTHaOaM8i678FNzYWzkFtIOin5qtgfC8wjnj6YPJW4biL9WR6u9zW893w5juJ4UwKik0CVLOGUnLB0gbDYYY6U0QU2c+sUdIaodIxUkHcvNNsFzeIIyxZ2bpwqWuRO4RSsEdKGYBCeWQqUmfDE3epFIQqK8IMovXWRvJMws5gFa640vcL0G0Xxl+kDFcnz5jf5EXl1DDpM/ZUzmprEvLydoaE6SQomqTyOyo1GQ8huj74oO48O5nZh0LdXszVvOggfMcQmqODfIMCevjQ1znW+aQcyzhEeEUNRj2C7Utq6ZES6DZ54ti5yzdPmQMZ6BBr8d/MvbGKYp6YBks1BMCQ5zUWTiFqIo4xzx3qgc
 MQ3P0NWY
 fj5ZASnRMuKdVWOLng2EwiId0hXZQtcwQK0FmAEAs66/OLs3gKtsn8nHouxJrEp5sjzEZ76u+Kn7M1nln7Qsm1eXGZ1CcgND6J1jYe1Xz7CpWxatxi39eJJQQMmTgtT4XvqLYPdgBECLBBbQVZppyMuGsSQVtww2Aw0j3wSWY88p3rRJmSr68LDe4RMxeF6b50QRPAMLwB5uf0HwwO87kvwB+x7AdCIuwVqfalJ+HNqemSNzcUasrdtazYDa0Z5i7HpSsPCnif+Il/9/R4NJ035Wn4Fr1XP7SFtr2LsLYwnRny0k2ey5j5nUbZgifuQymmUtG1WtPdc7QCYQP1WKr6UQjTSCnvzWHh6Em/+IYo+ENsejR4VTkOlv3hdh7ph18iLvlH15ixj93/RduX79bqXzyuTPdwAGGneHpe+gEg1flfP9cFCEXLub9sPb1nFbfdEU6bheNou157i8O1xyATS8obs3LPFwLy0M5UurIKIdY94yNStSFt61393zD8hJKl9N9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Xuewen Wang <wangxuewen@kylinos.cn>

mark_page_idle() buffers bits for one 64-page bitmap word and writes
that word when a page in another word is encountered.

walk_addr_ranges() tries to flush the final word by marking PFN 0.
If the last buffered PFN is below 64, this only adds a bit to the same
word and nothing is written. Otherwise it writes the pending word but
leaves an unwanted PFN 0 bit buffered. walk_page_cache() does not flush
at all, so its final pending bits are not written.

Extract the write operation into flush_page_idle() and use it both when
changing words and after either walker returns to main(). Clear the
buffer after a successful write and skip writes when it is empty.
Place the final flush before the no-summary early return and return
EXIT_FAILURE if it fails.

Use 1ULL for the bit mask so shifts by 32 through 63 are also valid
on 32-bit hosts.

Fixes: 59ae96ffc3a67 ("tools/vm/page-types.c: add support for idle page tracking")
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
Changes in v2:
- Return EXIT_FAILURE if the final flush_page_idle() fails, as suggested
  by Andrew Morton.

v1: https://lore.kernel.org/all/20261118021253.1691428-1-wangxuewen_ky@163.com/

Verified on live kernels (v5.10 and v6.6): after "page-types -f <file>
-i" on a 100-page test file, the kernel idle bitmap held 99/100 of the
bits before the fix and 100/100 after it.

 tools/mm/page-types.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
index 47e4781c5fc3..1695a7b42169 100644
--- a/tools/mm/page-types.c
+++ b/tools/mm/page-types.c
@@ -575,27 +575,39 @@ static int unpoison_page(unsigned long offset)
 	return 0;
 }
 
-static int mark_page_idle(unsigned long offset)
+static unsigned long page_idle_offset;
+static uint64_t page_idle_buf;
+
+static int flush_page_idle(void)
 {
-	static unsigned long off;
-	static uint64_t buf;
 	int len;
 
-	if ((offset / 64 == off / 64) || buf == 0) {
-		buf |= 1UL << (offset % 64);
-		off = offset;
+	if (!page_idle_buf)
 		return 0;
-	}
 
-	len = pwrite(page_idle_fd, &buf, 8, 8 * (off / 64));
+	len = pwrite(page_idle_fd, &page_idle_buf, 8,
+		     8 * (page_idle_offset / 64));
 	if (len < 0) {
 		perror("mark page idle");
 		return len;
 	}
 
-	buf = 1UL << (offset % 64);
-	off = offset;
+	page_idle_buf = 0;
+	return 0;
+}
+
+static int mark_page_idle(unsigned long offset)
+{
+	int ret;
+
+	if (offset / 64 != page_idle_offset / 64) {
+		ret = flush_page_idle();
+		if (ret < 0)
+			return ret;
+	}
 
+	page_idle_buf |= 1ULL << (offset % 64);
+	page_idle_offset = offset;
 	return 0;
 }
 
@@ -798,9 +810,6 @@ static void walk_addr_ranges(void)
 		else
 			walk_task(opt_offset[i], opt_size[i]);
 
-	if (opt_mark_idle)
-		mark_page_idle(0);
-
 	close(kpageflags_fd);
 }
 
@@ -1364,6 +1373,9 @@ int main(int argc, char *argv[])
 	else
 		walk_addr_ranges();
 
+	if (opt_mark_idle && flush_page_idle() < 0)
+		return EXIT_FAILURE;
+
 	if (opt_list == 1)
 		flush_page_range();
 
-- 
2.25.1


