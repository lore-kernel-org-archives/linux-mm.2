Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF82BFF885E
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 06:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA656B008C; Sun, 26 Apr 2026 02:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53906B0092; Sun, 26 Apr 2026 02:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4816B0093; Sun, 26 Apr 2026 02:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB8DA6B008C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:27:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 561668AFD1
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:27:29 +0000 (UTC)
X-FDA: 84699725418.16.3BB0554
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8CB621A0010
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:27:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="YR/srrxs";
	spf=pass (imf19.hostedemail.com: domain of 3TrDtaQYKCLstvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3TrDtaQYKCLstvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777184847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StblesR9iaiFRRbioNuJy6fVbWaUnyZsVnFfUPQ3g9E=;
	b=Kwh7sFllWLDHag+IIS2qnhaQ7Gt4NqEUkHXMsJDF25p2Ge+xNvKZwisL8uFJMI5KMJzJja
	zBSwo7XHY7TmqxP/P01t/o7hp1qpzS08E1lUsCNTeME/2z2WCig8EEa27YIudPPZgpbquL
	JJNLFBzjBfo8EdklFmSkjyNz6eAE0N4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="YR/srrxs";
	spf=pass (imf19.hostedemail.com: domain of 3TrDtaQYKCLstvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3TrDtaQYKCLstvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777184847; a=rsa-sha256;
	cv=none;
	b=L5M1k497CdqksfBeJ2MR5cQrEdKRvwNz6r0dR84HJX/OiSWQan3hrsFUwMa1XAF9CW+xYi
	ahXuIqnV79xELFw4bEgJNtJmpejxlwyNa+2npHjRmP9nhmht5cXfwICDOg8B12aHBVR9ww
	mIOiZroZRAQFldwOOU4huzTIBgUinEo=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35da4795b3cso18269398a91.2
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 23:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777184846; x=1777789646; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=StblesR9iaiFRRbioNuJy6fVbWaUnyZsVnFfUPQ3g9E=;
        b=YR/srrxs1rOukrPncZC3daYCdUcT0gfZBJlBmNtDd0gVPAP2Kg2tNT7MtpiaykVxZY
         LJJi1U43KlwpMquaQU9p2JVNEY+9v0tseggVez1j5Ub1RXyfJX48CAzk5SGtf9ASHoze
         4rjfSELV0tHuP6Ieqdcq5GdNR6tU5yNH8aEXqGPg4fbm9szSfVyCV0qtIaifW1uVvKkg
         pi0TKJLneUeftVswnus+eZC2Bt49B8GlxLAnfJ30yFtsrT3Qrg715lSev7bXfgoDfwpG
         tFB7gmzPzrBOlqLg0CE3RN+fI7D+jQznZ/hxPPZys/IftEQIl8Yo0iPT6cuMhigc0dc+
         8lKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777184846; x=1777789646;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=StblesR9iaiFRRbioNuJy6fVbWaUnyZsVnFfUPQ3g9E=;
        b=mcf/wxLHUYYvXPiaERbeOs0OfYySCze2mDP7yDLtWODFO6FO9ZHA0VtS7KN1rzRz2z
         q/M21NXU+i9Lmr1un5/L55Sg3fLEIfyvzsj5QImIt0fvB4eI9IYdLCohQhMgdxguavRN
         x5FKsUaUaYniFJue7bXb2OLMItsG595JbnMUtWRaHxoDiZEoDMDJeUOz7OTFAYc7vb41
         fj+2WbzHsYRqIzwYlRXsAkgLDIWu19ApmEz8VXhFRgsZrbVfBCnxuugxZdW9x60lPIFw
         7bn55Ji6nl6bIGxtypRpO4kxKemfXDPujb1OAHjMrzrfWFhYwJZ7wNx8izFrwVj9d7DK
         4EoQ==
X-Forwarded-Encrypted: i=1; AFNElJ8jcj9TAuSjLr1PgBvbKz8m6WyRDt/2J4T3BxGlSklVuLgh9lqzGwIWoprhpY6IqqX12oh2uubPlA==@kvack.org
X-Gm-Message-State: AOJu0YxGl28fU5r8R+HYss55gA2TszKka0PgSLAAS1CfVPG7KGL0heFB
	lOg53A2SRmh7+uuyolNp1GaYjvRa6kt8ACseZqYW6tHhFQZJsHzoGo0Byfb4j17FVYZEcxHjERw
	st40J6g==
X-Received: from pjbiq12.prod.google.com ([2002:a17:90a:fb4c:b0:35c:27ed:8765])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:8cb:b0:35b:b52d:f34d
 with SMTP id 98e67ed59e1d1-361403b01b9mr28822090a91.5.1777184846217; Sat, 25
 Apr 2026 23:27:26 -0700 (PDT)
Date: Sat, 25 Apr 2026 23:27:17 -0700
In-Reply-To: <20260426062718.1238437-1-surenb@google.com>
Mime-Version: 1.0
References: <20260426062718.1238437-1-surenb@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260426062718.1238437-3-surenb@google.com>
Subject: [PATCH v2 2/3] selftests/proc: ensure the test is performed at the
 right page boundary
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8CB621A0010
X-Stat-Signature: sg55b4kqj8u99e7xixxi5f53obz8tfbh
X-HE-Tag: 1777184847-925341
X-HE-Meta: U2FsdGVkX1/xJKFEnO8y8p70aiwDV3STXfDpNxlYur5uOARRdWFzYy+mEyVsPmkfytBGwkLFUU3T2g8sVjGQqEO1+t5V6hLSH75xtpp8sBdm5ZS88+mxWz0rAuYaYim2md4J8jFvtLWQHFDd1ie1aGgzs8kquHgUOB8jV0zyH94efSBq4easSCyyisYrVjT180YK13bBDENZrDuatHxhap/GfTEa0hBqE7IZ5LyPblqumSy8w2khcAjepjL3FqutSWmOT2oB6BeKCrEtVm3enlqwgF91LDn6PIRm/tnO2u903ZoUiHGfEA0+v2KPKlcNiA4+ZYsHrmFZMU1OUFvJFsdjocw6QTckfLHcVizXY2cwzrqlzUq+VofHiiVxxs4O4KWbUKqwm10lL00/m5s2lz0L9N4yfpWWzMo8MgzsweOndaEwLY1y3kyD7v+Zf2NXtvm3icCVdu/RskkV5CDCwSJupKU6bFrbCDusQmrLFohTkNzF2dzGu+GoUetGRL9uuhmzghWguo5fxO+HNjNVY8cR+RrSN3XxDkOeNxVujgGzkmUPloJ2+gI/+333kFR4eMaAScf76fPX4MLi1j2Su3rdoqlQZUO/q2gl+JGm+HtOXVkAEEmMLw/DCSLLJN5d0Y/fAf0Of5/ulMSCqL4bw7B+O3ZpafPFAJAOKmRlNC3ok0xd9TYO9y1lxD7vV2FSkjNAAgWcIolAHP4fBjWQZrJjNsXCGTlpeOJL+3xcgFLgSyYwmhlP2JThM9QAa1+BFvuU8IS9lGnrIJh2gRZMAk64o+S6bIbCybazQ6mVLdGaRITLB2589d/7LaWlmcuCfdqu8Ljanu2P9dUav3QaxKX5zPbzAyCSKQUnvMz3esaGyzWbaO+pL9k5WVymQjMB74CM+cv6wR6qo2D0evFFDFCSjV9UiUYTNAghpSMq22cWR3tsR4gQNn4YIInamyKJM/N8AGtyI2w/+BOtMwJ
 sja/Ubt2
 cdnpM0SXxG2UN4JE64uERJlmtUxpPbt0FHAqHBxGw0dBk6+d7I+mJafxN1YXelwkQKkXWb2fHuNkjs7n0oVAuYspzpT3mBIpr0ufYsuV5R8IraJqgk6wWke6a6AbP/yx7X3ehCNf/EKB75B9Cw8FaHEt+Gnc5Osujek+ZEXT+duy7qb4bTjLloRTD2zCfnXFDTe7rGILOKH5JfCirb8qu2y3zTLnyhm4Ec/JGX3079fWzawyvMljUcTTPGs5rr/3EhSGragcWI1pcbmd4/aHFZIJ6W6H51G3uEUaAJzJIkRwh6z3T0aKUDSaRdsYUXfxxiWVGpJ/5KSsqyeZQZQiJK/itcMP1KlugWe9KyVHXpxRNkpvNtcVls4bIE1wtMnOW5/SpEA+c/VpYNmoIBrZcad6TjHxBVO4tPwAEp2WyS7SfyaIAYzmEuZvV8qvCGp8MxusVqJm1AhQ0L1Zya/gk8Gmv43f1/pXhnZXOCZ2fn0tuQ6s3HKW/dtvHEGYiMu/GPlcr7Jfy7FoAFduQoGcbCIojWbCbiyq+9kizqgy+rD0LNO7epEmKa/n4PecsKsI/XA+MEZIuPHl8FqwIonHyM+jaAXY15voLPWFubFNkhAMDVyqt1/6ynyXbFz74rIF4b7zdlqCTlTqmHlABGzVpZKitFKz+wjIk61Pihg6OiqINlusFklswgGBZyD9h3JOsrt6ffSib/vrltxtAnhhg2+r0+iM+dMkuseHLswOKQrWa9QdLAgC0Nd+QJvDbYp64Wuw1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running tearing tests we need to ensure the pages we use include
VMAs that were mapped by the child process for this test. Currently we
always use the first two pages, checking VMAs at their boundaries and
this works, however once we add tests for /proc/pid/smaps, the first two
pages might not contain the VMAs that child modifies.
Locate the page that contains the first VMA mapped by the child and use
that and the next page for the test.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <liam@infradead.org>
---
 tools/testing/selftests/proc/proc-maps-race.c | 119 +++++++++++++++---
 1 file changed, 100 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
index a734553718da..5eb350c23da4 100644
--- a/tools/testing/selftests/proc/proc-maps-race.c
+++ b/tools/testing/selftests/proc/proc-maps-race.c
@@ -39,6 +39,13 @@
 #include <sys/types.h>
 #include <sys/wait.h>
 
+#define min(a, b) \
+	({ \
+		typeof(a) _a = (a); \
+		typeof(b) _b = (b); \
+		_a < _b ? _a : _b; \
+	})
+
 /* /proc/pid/maps parsing routines */
 struct page_content {
 	char *data;
@@ -77,6 +84,7 @@ FIXTURE(proc_maps_race)
 	struct line_content first_line;
 	unsigned long duration_sec;
 	int shared_mem_size;
+	int skip_pages;
 	int page_size;
 	int vma_count;
 	bool verbose;
@@ -105,38 +113,102 @@ struct vma_modifier_info {
 	void *child_mapped_addr[];
 };
 
-
-static bool read_two_pages(FIXTURE_DATA(proc_maps_race) *self)
+static bool read_page(FIXTURE_DATA(proc_maps_race) *self,
+		      struct page_content *page)
 {
 	ssize_t  bytes_read;
 
-	if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
+	bytes_read = read(self->maps_fd, page->data, self->page_size);
+	if (bytes_read <= 0)
 		return false;
 
-	bytes_read = read(self->maps_fd, self->page1.data, self->page_size);
-	if (bytes_read <= 0)
+	/* Make sure data always ends with a newline character. */
+	if (page->data[bytes_read - 1] != '\n')
 		return false;
 
-	self->page1.size = bytes_read;
+	page->size = bytes_read;
 
-	bytes_read = read(self->maps_fd, self->page2.data, self->page_size);
-	if (bytes_read <= 0)
+	return true;
+}
+
+static bool parse_vma_line(char *line_start, char *line_end,
+			   unsigned long *start, unsigned long *end)
+{
+	bool found;
+
+	*line_end = '\0'; /* stop sscanf at the EOL */
+	found = (sscanf(line_start, "%lx-%lx", start, end) == 2);
+	*line_end = '\n';
+
+	return found;
+}
+
+static int locate_containing_page(FIXTURE_DATA(proc_maps_race) *self,
+				  unsigned long addr, unsigned long size)
+{
+	unsigned long start, end;
+	int page = 0;
+
+	if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
+		return -1;
+
+	while (true) {
+		char *curr_pos;
+		char *end_pos;
+
+		if (!read_page(self, &self->page1))
+			return -1;
+
+		curr_pos = self->page1.data;
+		end_pos = self->page1.data + self->page1.size;
+		while (curr_pos < end_pos) {
+			char *line_end;
+
+			line_end = strchr(curr_pos, '\n');
+			if (!line_end)
+				break;
+
+			if (parse_vma_line(curr_pos, line_end, &start, &end) &&
+			    start == addr && end == addr + size)
+				return page;
+
+			curr_pos = line_end + 1;
+		}
+		page++;
+	}
+
+	return 0;
+}
+
+static bool read_two_pages(FIXTURE_DATA(proc_maps_race) *self)
+{
+	if (lseek(self->maps_fd, 0, SEEK_SET) < 0)
 		return false;
 
-	self->page2.size = bytes_read;
+	for (int i = 0; i < self->skip_pages; i++)
+		if (!read_page(self, &self->page1))
+			return false;
 
-	return true;
+	return read_page(self, &self->page1) && read_page(self, &self->page2);
 }
 
-static void copy_first_line(struct page_content *page, char *first_line)
+static void copy_line(const char *line_start, const char *line_end,
+		      char *buf, size_t buf_size)
 {
-	char *pos = strchr(page->data, '\n');
+	size_t len = min(line_end - line_start, buf_size - 1);
 
-	strncpy(first_line, page->data, pos - page->data);
-	first_line[pos - page->data] = '\0';
+	strncpy(buf, line_start, len);
+	buf[len] = '\0';
 }
 
-static void copy_last_line(struct page_content *page, char *last_line)
+static void copy_first_line(struct page_content *page, char *first_line,
+			    size_t line_size)
+{
+	copy_line(page->data, strchr(page->data, '\n'), first_line, line_size);
+}
+
+static void copy_last_line(struct page_content *page, char *last_line,
+			   size_t line_size)
 {
 	/* Get the last line in the first page */
 	const char *end = page->data + page->size - 1;
@@ -146,8 +218,8 @@ static void copy_last_line(struct page_content *page, char *last_line)
 	/* search previous newline */
 	while (pos[-1] != '\n')
 		pos--;
-	strncpy(last_line, pos, end - pos);
-	last_line[end - pos] = '\0';
+
+	copy_line(pos, end, last_line, line_size);
 }
 
 /* Read the last line of the first page and the first line of the second page */
@@ -158,8 +230,8 @@ static bool read_boundary_lines(FIXTURE_DATA(proc_maps_race) *self,
 	if (!read_two_pages(self))
 		return false;
 
-	copy_last_line(&self->page1, last_line->text);
-	copy_first_line(&self->page2, first_line->text);
+	copy_last_line(&self->page1, last_line->text, LINE_MAX_SIZE);
+	copy_first_line(&self->page2, first_line->text, LINE_MAX_SIZE);
 
 	return sscanf(last_line->text, "%lx-%lx", &last_line->start_addr,
 		      &last_line->end_addr) == 2 &&
@@ -418,6 +490,8 @@ FIXTURE_SETUP(proc_maps_race)
 	struct vma_modifier_info *mod_info;
 	pthread_mutexattr_t mutex_attr;
 	pthread_condattr_t cond_attr;
+	unsigned long first_map_addr;
+	unsigned long last_map_addr;
 	unsigned long duration_sec;
 	char fname[32];
 
@@ -502,6 +576,13 @@ FIXTURE_SETUP(proc_maps_race)
 	self->page2.data = malloc(self->page_size);
 	ASSERT_NE(self->page2.data, NULL);
 
+	first_map_addr = (unsigned long)mod_info->child_mapped_addr[0];
+	last_map_addr = (unsigned long)mod_info->child_mapped_addr[mod_info->vma_count - 1];
+
+	self->skip_pages = locate_containing_page(self,
+					min(first_map_addr, last_map_addr),
+					self->page_size * 3);
+	ASSERT_NE(self->skip_pages, -1);
 	ASSERT_TRUE(read_boundary_lines(self, &self->last_line, &self->first_line));
 
 	/*
-- 
2.54.0.545.g6539524ca2-goog


