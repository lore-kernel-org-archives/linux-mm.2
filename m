Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53AA3C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76456B08AF; Sun, 16 Aug 2026 18:47:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E946B08B1; Sun, 16 Aug 2026 18:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63986B08B2; Sun, 16 Aug 2026 18:47:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6300E6B08AF
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8D6E805DF
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:52 +0000 (UTC)
X-FDA: 85108621584.26.CB7F420
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf12.hostedemail.com (Postfix) with ESMTP id AFFD740002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="0 EkC16h";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=dghigcQF;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PyXPtjPVYE8Z0aMRtUKX037WUeKGrSifkaLdS3sKWUk=;
	b=y3thKj4pzWfiibyI+AMX15sQpBCixK2Pg7hbLuohMlSuBBFohQlFtXsY9SBR4xK+s5LTvp
	nXpXGsc/vf4XRipEqzhNHWRWp1fLQ8hR10vs2krLC8HbDTEBSL3f7Is+P4U7dw3VG6kjux
	NRIGLj9U1nA7OdBay08VBUR+EnUoT4c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920470;
	b=aDgzhzA0ctWZVm6YYaWyxg17ieW8LI1ZlNh/xl7ROuHlZJaUk24oa+JuKJp1/E8FZgs8tI
	p70Qr7vfPeFMMSWlzEZRcLCOptTfG/EUVn5UMOvLhGyb/CyF6JyypTTJZkdfjvgU/324Qd
	wiM646aeMuqe34RR7MxjXVULkW+Enxs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="0 EkC16h";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=dghigcQF;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 4ED26EC0235;
	Sun, 16 Aug 2026 18:47:50 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:47:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920470; x=
	1787006870; bh=PyXPtjPVYE8Z0aMRtUKX037WUeKGrSifkaLdS3sKWUk=; b=0
	EkC16hOhVsqh30c3Myj5XL1qP+K3wPn+xQsGWQHAIoL0MoTMTirS5zrh9jwW26t2
	fBAEm/dy2wTAwkB/h3ZE3kSUvy9x/4nvh1q27BabBNosXddL+HpAY6fRpJu3BipR
	8iqy3eHg6CeNMcQeurXur8Xo7z2x5a/ggI37tXw+K9PtbYpcZmV78hM9IvvkRE2R
	sOeKu+Tgb9UbXSGTfTBeKA659U+9g9mzfmac24WxtEmGHmzOq0bDGXyXmdcu1z5l
	cl7cPp1RdfPSNbG2FPTMz9N/DF8rPTqKVf+YY96FVzgS3ay4WBA77eGAzC0g05Vd
	832iL1c6w9+8FFo0LmIVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920470; x=1787006870; bh=P
	yXPtjPVYE8Z0aMRtUKX037WUeKGrSifkaLdS3sKWUk=; b=dghigcQFSuackbjpf
	i8ccZXUzsilX+jOQyQEmxsRAaw5KlmG+++n/q8Szwyp9fj5VwwLmt6JWIVLJtQPx
	9Z6z5+Rf/ctbSVUqrCVcu9kPxz3jn0iASTx1yvIRYNQGmvMMo4kC+KCy/MZyJasx
	564WfCpnJnO754Ya6z0dxyDhnjiSYP8aYao3MoBpoIf1W26oSdF9j3YrbHzlyZza
	JL4TYl/Rj1x3MEd+h/95I+G2hy9ObHkYRC3fw37KisBD9c7OLokNEIDSjvv0AGHF
	bhsQO+QwiedX376TuXwmQ9L+MjMyO/QDazWFYKgr/eisS7+NypQvIdmQbbH9uSDG
	z/IGg==
X-ME-Sender: <xms:Fj6Cah6znDgsOUy0HJujMw9V-DLP_g-Au06B1xf2g5413AmFWBbeUA>
    <xme:Fj6CakNtwNGlE1WSWZ3bsFDkwlkOGVFSx1DzGEJpiKytyC-zoJa7rmx-SN1YqtTty
    VRiSziF0BE-3AIQ39ENR89hDdHAlMG5Te0rpcWwNt3bt4zdYIe9nX0>
X-ME-Received: <xmr:Fj6CakivqmGiV_BgjEyop1zjNIFG6OzfOcwF55JGFQzMlGYZyGqn32gXbLA>
X-ME-Proxy-Cause: dmFkZTGLjSC+Sq1mG4OxzCqJWZCyq6WBdNxixaUzytYe9+wGJyabxJMeXSGoSuAsbaseo8
    j4DSEFeK04hDwZtES01hwyaQU7EBbvB2uUyGWGXfBIvFkincgAhOfMPuQIYJEtCVnAaSQR
    A4Ax8HD1ONlE2jDjL1mVvD+0hWY7OblS1nu5BjF2+enir154N1oLAu20vju0M/bNfdRnaJ
    kR8ssngVd0jx9kVZmvlOu6xrNJDHPkWuaI7duTsmkJWDtl1nRnZmYTu08hiimZvSmFoDki
    6dltoqAKCLj0c9eKP1Vuuwv4Z4pwJTjTf79O9CtQykYTwcA2QZ7OKyC8oLqq7vFkYshLYo
    e77wWWIENfWWfKsbKC1kP1m+OxwAAiqZx0bEjZKDuPeV22XOXIGcwfKRFV0FN1rHmveHL0
    Y6ejQe4oFZtmmgdQW5dIGSQZXfyUU5nLR+TZExZg0Bcb/lQn5/6SQDajFLx0I0bg5ey1S5
    VVBBbzfOElkCyYT+2y9mCdYY69R2UkeyosAzehBiW5C//ulhzKnXpLOIAglVsKGDLTD3qg
    KWjxi/4iYNGoMuWvB6ZUWuS8mA+ypg9x4kPFB/Msx2X7Cx2DUJIV3qpyFE9KM1niesKiwc
    ddPOQNpAyzTHzdRzd6gdnR6t2t+NbuyxnuFQ8diZkqJAQ06NMSk0cglrCNug
X-ME-Proxy: <xmx:Fj6Cams0FNOh1GD8Ydq2e-VIyGp_1FTHjlRCAHwB7Nmusiyatap6kg>
    <xmx:Fj6Cara0tyJyyCpiPelu4nA9b6aGIIX1r_LGNFdYODym4cq-O5ae2A>
    <xmx:Fj6CatWTXFCoJdBX5juAF0XJwfnaoba3jx7S45IOl4BAYeS62wJfxQ>
    <xmx:Fj6CamKkYL9Oke65FnGPHjt4PidGrdGaTMkREDtGPBhbghyAiX2v3w>
    <xmx:Fj6Can-0wwsVr_1rTIf9ZV4E29WzY3A_VG4LbVZBfE7HVE10QoLzuQci>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:49 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 50/57] selftests/mm: attribute collapses by candidate event alone
Date: Sun, 16 Aug 2026 23:46:02 +0100
Message-ID: <20260816224609.308019-51-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: i6fjj3tmozspdwu7xzhsj8inkb4unqid
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AFFD740002
X-HE-Tag: 1786920470-433908
X-HE-Meta: U2FsdGVkX1/IP/O5D/vwtKvpdOLrk+q5UtSDBwz80AblAOivnJ+a61bMThUqibyjs8Zkp87yGNmhN5qOvtiwgnunYRdj8gUNPwOTrlEvCv5X7fn+3NqBK+p5P7kBqAndrWbT4eCyK9uoJUw7O+YQcXtdnZwBXaLXjWlUSidMjFOrGDEh+u5ZFZ1YEB4SYZXvSiA60ocHPwm8ltBbvNCGsRIRKcax4+qSAJ+4sbUfwccffXJFZVpOwjV18bvxRSW/r+YXlrFRf7Dk2IJ7FdWZSYjqJqz+89eqXdeX79uxH/lQCj4M/i8C3JicRq+dsc4+YM9GNkWaiorjZobqfrmc58nyYYaDkUkvxIHmENaEQkTqH6XYMx9uR7taFBSQXx+sivym4FQkOki4QuMXuYM21nf3vrQO6lVfWiBHpiuHsyu1oQXO/NAFyUdEmMo3WYwYrlwgtQgwg6W0pvc85g1ToaMKa1VZNKjm/+N7tBa0HjMCxE09/gtYAjCK0dhxz3uq8DVpNDNjWOz+vulP7M80bu5ebqVGgcosRGbnVm73sf2TsetFMvG3lopTdulDIKVOxkdq/vBOJ/TwgY/9RjE0pL8xmBgaHMJHC6pqIJWtn+Nk5ppuLXONwP463+FxDGyJQjPgqiIrN1WlI520l2s0QygoUzjOV0gtjST/IhETbAdIF/kSwqFukJbutY9/ePiojCdkdQfrGClgquJPH5T548reHbEz2QSA5e0kRFyWL01brRamtDHUR2/IFABSIiotjF81PZoV9KURxLY1KSHoceBRYfmED9UbF3Ch4lW/Ooq4ByBX7QODDhb4JihGsX3EQGINUGrQMAdYzCQxb86NLbKDhuQky7zNgiXtyuSwfgAJZ5upfdmMl0k0TVoDt7Sop/fT740DgpBrShkUf46xw/Tjenb2w8IPhFeAt/WDZEf8RG4aDEkk3LQMWrFZsayGxmyIkphCCJxAqaGi3xg
 qxeaVid/
 MZ7V/t/Q6y8Wa/LsdBXQRoq//YdVKyvW0WZp4adVh05EfmC9S69EklVlSQmel1pPaTiJJEwY2ERV42yeij2kIVa4Q7JOh/HRIJnner5/aFOwzgpZYqWEe9gObparAaPWMubM3lVXHg2hOF2Gr2lD6cY093AD5+PGfJ2MnIxVft/ozBXck2Xy0KqVkPWgZCrKBAc7RJGI+kOSdWZ0FKS0TOfi8RKODEYjy+4QszKDF6DV8wZp7jvs+yn64gWJlCCIiKsJkcD+bQd+pJxhmTygWs/NDLBrEuW0nQQYb2/prOmGnyUzb1AMFwQnrFdiRwUjplITGUb5u9cfXzlq9JA9Rk5JuIoZhfQhDP1TcshKca4kL9lNlkBQ57Ppv/nomAN25r5R5K4Rqs4z2wBvFLoFkmEUNt6PyjwUGWLDrs6Og/+GoS4xMuQeq3fx4EQobkIv6xiZsYbf7LMkwPvA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The check counts collapses of its window by matching isolate events
against the source PFNs it recorded beforehand.  That tracepoint went with
the mechanism that emitted it, so nothing would match.

Count the engine's per-candidate events instead: an install that
succeeded, at the window's address and order, is one collapse of that
window.

Preparing the window still checks that the sources are present, which is
the other thing those PFN lookups were doing.  The recorded PFNs
themselves are no longer needed, so the array goes.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 .../selftests/mm/khugepaged_sync_check.c      | 55 +++++++++----------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_sync_check.c b/tools/testing/selftests/mm/khugepaged_sync_check.c
index 4c37b697d3dd..2a0c247aeec5 100644
--- a/tools/testing/selftests/mm/khugepaged_sync_check.c
+++ b/tools/testing/selftests/mm/khugepaged_sync_check.c
@@ -7,10 +7,9 @@
  * advancing by two is a completion barrier for one full pass that
  * started after setup (khugepaged_full_pass()). Verify the pair gives
  * deterministic, attributable results: one barrier step over one
- * prepared window produces exactly one collapse attempt on that
- * window's source pages (mm_collapse_huge_page_isolate events filtered
- * by source PFN and order) and the window is collapsed
- * afterwards, repeatably.
+ * prepared window produces exactly one collapse of that window --
+ * mm_collapse_candidate install events at its address and order -- and
+ * the window is collapsed afterwards, repeatably.
  *
  * scan_sleep_millisecs is set to 60s to prove the wake path: without
  * the wake, one barrier step would sleep multiples of that and blow
@@ -51,11 +50,10 @@ static void trace_events_off(void)
 }
 
 /*
- * Count collapse attempts attributable to our window: isolate events whose
- * scan_pfn is one of the window's source PFNs, reported once per attempt.
+ * Count the collapses attributable to our window: per-candidate install
+ * events at the window's address and order, one per collapse.
  */
-static int count_attributed(unsigned long *pfns, int nr_pfns,
-			    unsigned int order)
+static int count_attributed(unsigned long addr, unsigned int order)
 {
 	char line[1024];
 	int count = 0;
@@ -66,25 +64,25 @@ static int count_attributed(unsigned long *pfns, int nr_pfns,
 		ksft_exit_fail_msg("Cannot open trace buffer\n");
 
 	while (fgets(line, sizeof(line), fp)) {
+		char *s;
 		unsigned long val;
 		unsigned int ord;
-		char *s, *o;
-		int i;
+		char *o;
 
-		s = strstr(line, "mm_collapse_huge_page_isolate:");
-		if (!s)
-			continue;
-		if (sscanf(s, "mm_collapse_huge_page_isolate: scan_pfn=0x%lx",
-			   &val) != 1)
-			continue;
-		o = strstr(s, "order=");
-		if (!o || sscanf(o, "order=%u", &ord) != 1 || ord != order)
-			continue;
-		for (i = 0; i < nr_pfns; i++) {
-			if (val == pfns[i]) {
-				count++;
-				break;
-			}
+		s = strstr(line, "mm_collapse_candidate:");
+		if (s) {
+			if (!strstr(s, "pass=install") ||
+			    !strstr(s, "result=succeeded"))
+				continue;
+			o = strstr(s, "addr=");
+			if (!o || sscanf(o, "addr=0x%lx", &val) != 1 ||
+			    val != addr)
+				continue;
+			o = strstr(s, "order=");
+			if (!o || sscanf(o, "order=%u", &ord) != 1 ||
+			    ord != order)
+				continue;
+			count++;
 		}
 	}
 	fclose(fp);
@@ -95,7 +93,6 @@ static void one_step(int iteration)
 {
 	const size_t window = getpagesize() << TARGET_ORDER;
 	const int nr_pages = 1 << TARGET_ORDER;
-	unsigned long pfns[1 << TARGET_ORDER];
 	bool collapsed, passed;
 	int attributed;
 	char *p;
@@ -106,11 +103,11 @@ static void one_step(int iteration)
 	if (p != BASE_ADDR)
 		ksft_exit_fail_perror("mmap() window");
 
-	/* Prepare one window; record its source PFNs. */
+	/* Prepare one window, and check the sources really are present. */
 	for (i = 0; i < nr_pages; i++) {
 		p[i * getpagesize()] = i + 1;
-		pfns[i] = pagemap_get_pfn(pagemap_fd, p + i * getpagesize());
-		if (pfns[i] == -1UL)
+		if (pagemap_get_pfn(pagemap_fd,
+				    p + i * getpagesize()) == -1UL)
 			ksft_exit_fail_msg("Source page not present\n");
 	}
 
@@ -133,7 +130,7 @@ static void one_step(int iteration)
 
 	collapsed = is_range_backed_by_folio_orders(p, window, TARGET_ORDER,
 						    pagemap_fd, kpageflags_fd);
-	attributed = count_attributed(pfns, nr_pages, TARGET_ORDER);
+	attributed = count_attributed((unsigned long)p, TARGET_ORDER);
 
 	ksft_test_result(collapsed && attributed == 1,
 			 "step %d: window collapsed, %d attributed result(s)\n",
-- 
2.54.0


