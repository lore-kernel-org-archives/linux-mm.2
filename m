Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 055CF606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=J+FUQh3E
Received: by kanga.kvack.org (Postfix)
	id C37856B05B3; Tue, 17 Nov 2026 21:13:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0ED16B05B4; Tue, 17 Nov 2026 21:13:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00766B05B5; Tue, 17 Nov 2026 21:13:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 846396B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:13:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45248140508
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:13:35 +0000 (UTC)
X-FDA: 85446618390.28.33A7FF2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1AED040007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:13:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=J+FUQh3E;
	spf=pass (imf07.hostedemail.com: domain of wangxuewen_ky@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oMmQT4LBt4QnjZ5+vGEUUS6BupntHDb+BjkQkH+5Z5A=;
	b=T6MwOxlpw6HYpiJmItEHUrCD0Bf5ZycDEeSUL5rzcWw3Ju+f7jU1cWRmWgCf6kEK+V1ZLO
	HO09RRD2RYPEGfGiKrEixFbklW+BQHsIHGCDAOJhLRylN8FE3xnKuQ8/sDBfYUW5SU/SXv
	pu15vqBQ2fL3KqANAvAGUVn1TScfja8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968013;
	b=1gvrlbLhav9XkuAf5qol5WwNlwwXFGWRFLAcCuTdSRV4dZ+zFD4YolgpMCrbYysVIpLLS/
	ieKei7TuFxCw8F7jY6HnOUwp/rpo8xkeSWFQsNJlh+BivCGL1uBCQXWNaj6dFIODl5b4ZS
	4u0Vbz3KrzPb2QaWYcfXaAQV2hckitU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=J+FUQh3E;
	spf=pass (imf07.hostedemail.com: domain of wangxuewen_ky@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=oM
	mQT4LBt4QnjZ5+vGEUUS6BupntHDb+BjkQkH+5Z5A=; b=J+FUQh3EaYD0ZFihVE
	5lmw7TVgIYJcKLA3wxHzUNpBucd0IqGIBzT+aUhB7JPuVmF81Pl0yQ2OadyJzZl7
	6CTObX9LzScfzyyTrvHol1me+dHQBjncSTIaH6aDpeCmszVk2sr/z25GmB7mOU+a
	JhwXQM6/BSnm0HM3YzVL8IJOM=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgCn2J+nCf1q9_NEGg--.8212S2;
	Wed, 18 Nov 2026 10:12:56 +0800 (CST)
From: Xuewen Wang <wangxuewen_ky@163.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	sj@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v1] tools/mm: page-types: flush pending idle bitmap bits after walking
Date: Wed, 18 Nov 2026 10:12:53 +0800
Message-Id: <20261118021253.1691428-1-wangxuewen_ky@163.com>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgCn2J+nCf1q9_NEGg--.8212S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZryrJrWfKr18GF4UuFy3Jwb_yoW5Wr1rpr
	ZxK34jyw4kta4fGwnxZrnrAF1rAwn3XayfGrW7Gry5Za4UJF1jq3WxWF109w18WrWkCF43
	Ars8GFy5WFWUAr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jpWlkUUUUU=
X-CM-SenderInfo: pzdqw5pxhzv0xbn1qiywtou0bp/xtbC8AiGb2r9CahW0AAA3h
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1AED040007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: widwyya1cbmohmi4wt9ki79h6qhqcmq9
X-HE-Tag: 1794968011-860593
X-HE-Meta: U2FsdGVkX18SZmr221XlmDTubdlnQZnL3QqC0sEWnz1fpvlcyAVXG+3/Ij5Y9SerbUFrHfK7egB6WauEgmHmoil6CdopUpg44ITLeaA5fyZzsH/SVBUCWT7D6wIffm2/pt2dULm0RCkjD9D4hCHF94X+jMs/ykNECUkRuTYO7w3fms1L92w/lhtlD4L0/EE5+iRWgH2SMhkXVnF6MN/Rx2uyYzoeX/R9PBL7wf61zPcjnulKirfC5YT3Tnp+ddGQeNturwJawHtostyo06xKVWh7mnQ+gMaRzr7sadge/SbKNGwbQvfeliv5uPppcEtUiaLpvFvGtcJwIdWq/3l2wRHQGXdO6+A6bU3SAzwFhjZPWsKISq4g/cpTkeGjOllYGuAOyUYVCQri76cEFWxSQn3aqZGPo56CqXwTe5xVN6mec9nHKQ778y9Dnaf9b7DgKNGJU0U/f7//gAabukgjwDN/dPP6AfVfTZ3ORp206bYI8qkehORrSHi40nO3MQwKxZ2sYHu7YYWIpOaEuW1YplakufvDYqjYz4bC9yY94ko6TF3onVkuBaCMme8EwWMSw6EX8Uuuxe8uXbly3iJC3UjKzXYMO3ZxQmaMrQq0Syoxeg0EUM5da1a43n1CE6H453twx3W/aN5y5t2FeTK7Yy8zUeeAdT5D7Fb3z9YR9nRxiEr7R4t9F/kjE8vWCuonDreZxRWIbcPMFUcfNIgErf1drUxpT5n25rYJp0GXRXq4+N8C2YsjPI5k3bytwqspq+vSaUGx6OOxRzg33iTQiwefNt6h3zuYv/Xp1TzNyofGFvb9g6ndMf7yYhNhutqaUgY+Ok1s10HjiBITf4vYwVbW32SJ7Wg4U3kA0hjSoUOneFL5z1mrzFXoplc0B8LjPzIDM4NOJfL4E+n/a1uFM2RmhNlcxWognN+DBm+3AeXIq5U3twiySvTdtrVnlhSiGe0WyX+Vq1pQq/jVyul
 SnJNXnQk
 /KCU9nMirgFZZFzhzWLq9+NU2xY52gz56SOppvzAwkHOYRm5NULXurMqej5HjZTwUjHFD/xLqImZBjfpWmjY9Tx2w1ITgcWHNQuWIWYX3YnlKu7CcVFVxCMcEq4P7oltCV718XVq5bPCyPvikWBgdh9nX1Wsg5ntiQSyX7tB8S6raNTfgAWTga3ATI5b83MW6fnbUgHnm2d3qF60pLDdgGXrwZdMCRODqlWhFmRRxO0JDeR26sO1nuAqPXQ==
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
Place the final flush before the no-summary early return.

Use 1ULL for the bit mask so shifts by 32 through 63 are also valid
on 32-bit hosts.

Fixes: 59ae96ffc3a67 ("tools/vm/page-types.c: add support for idle page tracking")
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
Verified on live kernels (v5.10 and v6.6): after "page-types -f <file>
-i" on a 100-page test file, the kernel idle bitmap held 99/100 of the
bits before the fix and 100/100 after it.

 tools/mm/page-types.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
index 47e4781c5fc3..3833dba3c02e 100644
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
 
+	if (opt_mark_idle)
+		flush_page_idle();
+
 	if (opt_list == 1)
 		flush_page_range();
 
-- 
2.25.1


