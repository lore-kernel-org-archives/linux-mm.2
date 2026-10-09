Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A776FCA601D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 15:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59C86B0093; Fri,  9 Oct 2026 11:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A476B0095; Fri,  9 Oct 2026 11:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35276B0096; Fri,  9 Oct 2026 11:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 987AD6B0093
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:32:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EB3A40431
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:32:20 +0000 (UTC)
X-FDA: 85303479240.11.056301F
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf29.hostedemail.com (Postfix) with ESMTP id 016E5120004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 15:32:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="H 4pucHH";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=veOOZ6++;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791559938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+bgswPNL65MGSFGW11p2LCgIfbz/AxZV0vuCj5wexO4=;
	b=fpajW5X9lXK+G1YuVN6bYH2/PMB1OXu7oUC2TZRzQax+1Xey5wHhkmR3UKghsu8zH8Zt3N
	Kf7lx8bP55y7YXKIRxWDZF+uyhdu9PNTSl9oQgz7XhrlDFX6YDtY+fJh9RsT8lZZNjqQxZ
	SBoyRQ9eVEM4NY8gkuh8qXfCg/KXm1k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="H 4pucHH";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=veOOZ6++;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791559938;
	b=6BN80KI6Jd8y6FXOdLSWJWwBD3AG3/sfycPYYRw0Y7I8ETVP5TjrJljj17XsqYCJWcQaqh
	jHA5NllPv0+kXwiMXupezpnAvYqiuw8eSYWB+j0dGRQqvmw9JwpSxltViLHLx7Q7x8UbYi
	xjI3O3vskmuH9FUqN/94o+8mzVGRqD4=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7B0951400146
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:32:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 09 Oct 2026 11:32:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1791559937; x=
	1791646337; bh=+bgswPNL65MGSFGW11p2LCgIfbz/AxZV0vuCj5wexO4=; b=H
	4pucHHJPHV+yJoef3QLQtrBLub+mhFKyW+KLFu1R5tVRdr3THPpoOAIGbih2FCuQ
	ae6n87IT8DG6gcdXtzK8g6zzvISCyusLd76sUbsOyY2FlY//eUQbkrCLSfNckVIR
	wRf561U65SnUMkE9+BtYgRD9W31CYqCsRAv8HEfYWA3ZAEX/dH2rgTmfQYRJkRLQ
	I4ruJ8hJyueFBtsogGH3YQ9u1O1b6XKQWBTu+17xPD1aispmE1FPUzmXFH3nGYRn
	cYuBwOxO0tOnr4FTH5ZoXV73D4nuog8BsXdS9yZYuHz+cfPxw+8aK/Z8kLA5FnE3
	Kr/e4byZp2Hn3SuyWxG2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1791559937; x=1791646337; bh=+
	bgswPNL65MGSFGW11p2LCgIfbz/AxZV0vuCj5wexO4=; b=veOOZ6++DlJbU5zYz
	5KFpJ4MzK7WOhm662nbWJCxjrtrBBuLOuwr0MGHJOQ9/DiwAGxuWEjlpEK/Ph9ES
	/nnJPj4gj9QVPng1dhdY7mPdT99giTwbn9vAvmElZRHqJkPgl9JS42ZU/iQTIqVQ
	KA1XJqUsHsBt1agdG0reEnx1JMcBo8dyzPgNzQgcazn53Fed2JHXpqHU+Ja8IQpe
	Wgtb8lnXKFGUTmD6F/FIBWAg9YwX1zNyTuMRIgk2FHWykte2dqUmUMO6dVgPSV9F
	zHNNXWftTUoCR+xT04mPhVKJgL2Oi9IEJPu2RjXaUOrAsnK2PkXDdfJdgd/F7RCz
	fiTkg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791559937; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:IJE1lb7a8Mrta6QuRh9BnyNfBbXoTbM0rmoUC7vevNWpLzR
	KfKRYBi/9NtFlHibK72WjN4L3mrbnOWx66Broxz5JRYDr5D6fxRM0ElyvoRTCUdn
	uwrzKpSWkl9cwAPN79Nlw12bGCNgZEWccbPfhx0Tjz9DxNBD96qQxtf8vOfPkd6V
	jBif0P/JiLJm2tEoY9GEufd+WDONLqEbbbv5rL9wsmJihuKtJ+ZHS7IGA3HOI90u
	KtWT5xzufztugqSnrpq0+SbUmH0sIF4h++y78qaaTSzqXvC0hapV402SokuJ8Fok
	5XvXk7PmiCLwM3/KG9oTOp/DoGpNLfjjrnJhuBA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:2EekE1/ihigsD9cpT1zjckYuZWhHwzubHH7Yq0Fu3mo=:aN06lza12BkjUCxSt1YCAEpD4/EDAaGcSM6aQTrH8G4=;
X-ME-Sender: <xms:AQnJagjwdlVd8z7gCtdVBR6HbPTSyQBkPcWa1eqcfO-C-hNSlZU9Vw>
    <xme:AQnJaqpqdIwZo3hkp9EkmO06fCZ4T1MNFWVncVWFn-uO3hTYfMJOa_k4Jtj7XmYEg
    76S-hO067lYJLyOvKfmKqx0d0S43_98lBvEMG0ho_5oC30CCd5D4Bff>
X-ME-Received: <xmr:AQnJasIL4IzGDOdZMa8vph0P1r6RnM_zaH-tbrYsacywPKS6wIyRBG8ulh0>
X-ME-Proxy-Cause: dmFkZTGIoGBLZMaAhgcaayk5wgp7rW9vayQkfonvs0TKGSEuuYzL1U5eWR8oX+vcbxv0ak
    vZ6V5Fk2n6N+IaumklX1qzBk7r0hEpcbcO59DsZzPQwz0SNLq5ubZVbwk/A0B0ImP1q9S/
    wvMCjtg/pGCexbzTYCAAsFMX+sI9bOrGKjIjV+CjlMDzV5ttTW2+3V5NxcPyUYh3hDVmY6
    5SaA7LVa7G47KypkYvo+NaxjJdB6S0C6Hb2KUpv2JaxJ1DNuAn/rjb2TmQMM/Oo0fomkKJ
    59473bNh2ppMgxEJkQDpXpn3GMfvTNgjovDF8A3Cgd0ETDAPdqWfdTSt6z83qaSG77WHP8
    E4WWrJXXsQ2prSH4+1DTNTm28udL3c4lzRGqwr+lm4HrCPdGDs+Qg1hs9wSN6t/rZAglOW
    hCxFh49dbPpj91VhuzQBsymuJR70MzKcnMX5mySqGuv+UgvWB3DU/XOYDVEAYxanagyVAe
    X49v0ytuoddIWVpRhSTGJHm0LeD6PVOg5oB0RKF0swxBTYUQMFz4rNbYoU2ESGpbB6u4f8
    krcEXW+jI3jdWaP+/YN7vNwcXI9leb+BgVNgSrqDB4Zw0xuK3Y6ZYxMsQjZcO5ry6Mb5ro
    Qx6Iqza9jJXjk22SJonaFwHTioFaiA21Ig6n+p+rqQVB3fYop6gloG8mrdjw
X-ME-Proxy: <xmx:AQnJanv03h7_v-57WjsLZOYrJZZGbpX4ri_MhBdbmW-4k2Akz_xgiw>
    <xmx:AQnJass28030c2MUlvAhqXDiuJ1Ltd4xWBMQqbDdce6MpE_bNu3o8w>
    <xmx:AQnJauWpPUOQr24Jz3GluKedtVDoVYTRaKjE5zTQ2TjROsCyuMomRg>
    <xmx:AQnJalUlLZVN2UWzA4gs67puE_dgEG175S_NpvYHklXAM2hStZED9Q>
    <xmx:AQnJarg7RUIubmank2IKctS2L_oP37LydzfO6W49o1W7mD6eonaOJs2b>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Oct 2026 11:32:16 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Shuah Khan <shuah@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 1/4] selftests/mm: open pagemap and kpageflags once for check_huge()
Date: Fri,  9 Oct 2026 16:32:05 +0100
Message-ID: <20261009153210.236517-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261009153210.236517-1-kirill@shutemov.name>
References: <20261009153210.236517-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 016E5120004
X-Rspam-User: 
X-Stat-Signature: okebi6eddj8ga8c5jhjrfjpexijfub3a
X-HE-Tag: 1791559937-780661
X-HE-Meta: U2FsdGVkX18WZ9RE9V0H9mGMMjDFwEpZQvPo6tjx6mCiM2o7zeAfPQblwHRaAhNA8ZvoUMo5dm150gYzsDT6PtaS44T330O/ngcVQwTHRpWH9emM4ZeRoufq1ELT1uQ6Ed1KGjDkBG0YtwtZjttDRLUDTHyaz3WWqYn/wcISFHcwUwqhR2xHnPhlkye27qeYzsfrOVBPaz98w8i84wXqR8B/dRtYuafk3ez27GMbD5rD8GGwEaUVh08v41yuVI2KxD+iz4hkjnjIFD72/hgSHRa06RVCm3rHUFi+SVl5+NwDCwSLNlczmjAW6+X2pTZO6cOUTv55OIMoC19mW/3NNTftCAJ6tM58tFdcjg/Kak9M03hU76uY2ZFAYGhEtm/n+wFBDcp3PcehnnR/nVXyt8vUO6tY2EB5QU7J3RjdP9FBNjLigcwHWM2GYZBtHZp2vE3/7qp2XkEqZLRbLGv15CZ/Hs+p6pKxOL+vo4Eqp7BZ0YdF/5xE8ddHT9fHdkf9lrm+UPIBDTpPUREdaWx0E2iLegVErcYx4IhwzP4KA2GYCoQxM1XtnCq2sdA7hGeWDq1kQAMxIb9UKslGKS09HOc+798S/G7QhjJHjxfN5xaTlw1pjAnqoqTmUYxpUOUbxXjfQMDnSJkktmBFOIEpenDaYqI6KNr9hr60gDS2pXZwt8+nvd2VurZNZ9FUUat0A8/UbLLy4rGibvIogcQV816jVzL/JDn7SDWtuR2Inbvp2/gcBiNAzoHfaFtaFZXW47/jVSWkWpu/Gb60z3bE8gfvGoS/ldmSNEbYy1eyMgwn5L2mxJf+0GQkowNcI+evpvKP2LeCRXOGN0NQVUXKV+rMNcR0HrUes29LtpDlq5d1uk3ctMGwX4MBtPRrGklZ8xk2SlKWwbY0msHd+Zz2LCJcZGcsKTW7i/eB/JCWIfycRQejlHiBjWkvep/8dsbB4aC+cJpkATp8yMvqByQ
 HdB5Jprp
 FAx3r1eXbx/yEoPH849V5bU/LHE3YGjF+LGxpvTtKURpwDhFrcxeCI53BjSf2KJMXzsAo9ktMi80T2687jmMz3LSsyfQplcqb7TAjt3dzJc6qJ7lNdzqoEiY58+BLc55T/xV/+nJk/61PUYpBELHE0109ZwTDZgVO26/dTdOu0ZeUPnbrns+wUdKeolkwqMMVA8uG2UWLPiRvP6BirE7o3LTjXhK45ZyyEzw0ES2wA5vk8zL8/p+y9FJIOSl+snhrQwTj6CmBBaDGw10lkl7dd+TMTZy/W8cosrLOEXYPzejtotC16c+sHVgE76VT0eRkpKWs3mG0uAjo1yvCLWZnbuCIWsJbm2laCcvsGWkC3GfiibNObbV8B3Q+vSgko/VyQRbGjgzY2GPY3SgeAVw+2N7hNMProgcOW3fGAdR7p5h41CzASgPwVkhvTH+7pST5AG9bw07DBud0V0BF7ZZZPIjrdO94hNPy53I0M3zNoN14UPW4lb+KkY/PmnFx3QczC1WqODCHcMwJke9NJyoER9R3ywBAwC+GHX7eqsttDjiuFiPaQqYqrq6/Z+2DT9PMy8Ht
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

check_huge_anon() and check_huge_file() open /proc/self/pagemap and
/proc/kpageflags on every call.  The khugepaged test calls them hundreds
of times.

Open both once and keep the descriptors.  A pagemap descriptor is tied
to the mm of the process that opened it, and the khugepaged fork() cases
call check_huge() from the child, so reopen it when getpid() changes.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/vm_util.c | 62 ++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 762c31f7dfab..09d9135f0ca8 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -22,6 +22,44 @@
 unsigned int __page_size;
 unsigned int __page_shift;
 
+/*
+ * A pagemap file reads the mm of the process that opened it, so a child
+ * inherits a descriptor that describes its parent.  Open a new one whenever
+ * the pid changed since the last open.
+ */
+static int pagemap_fd_get(void)
+{
+	static int fd = -1;
+	static pid_t pid;
+
+	if (fd >= 0 && pid == getpid())
+		return fd;
+
+	if (fd >= 0)
+		close(fd);
+
+	fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (fd < 0)
+		ksft_exit_fail_msg("open pagemap fail\n");
+	pid = getpid();
+
+	return fd;
+}
+
+static int kpageflags_fd_get(void)
+{
+	static int fd = -1;
+
+	if (fd >= 0)
+		return fd;
+
+	fd = open(KPAGEFLAGS_PATH, O_RDONLY);
+	if (fd < 0)
+		ksft_exit_fail_msg("open kpageflags fail\n");
+
+	return fd;
+}
+
 uint64_t pagemap_get_entry(int fd, char *start)
 {
 	const unsigned long pfn = (unsigned long)start / getpagesize();
@@ -407,7 +445,6 @@ static bool check_huge_type(uint64_t categories, enum check_huge_type type)
 static bool __check_huge(void *addr, size_t len, int nr_hpages,
 		uint64_t hpage_size, enum check_huge_type type)
 {
-	bool ret = false;
 	int pagemap_fd, kpageflags_fd;
 	int nr_pmd_mappings = 0;
 	uint64_t pmd_pagesize, scan_mapping_size;
@@ -426,42 +463,33 @@ static bool __check_huge(void *addr, size_t len, int nr_hpages,
 	/* Some mTHP tests check a partially populated PMD-sized range. */
 	allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
 
-	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
-	if (pagemap_fd < 0)
-		ksft_exit_fail_msg("open pagemap fail\n");
-
-	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
-	if (kpageflags_fd < 0)
-		ksft_exit_fail_msg("open kpageflags fail\n");
+	pagemap_fd = pagemap_fd_get();
+	kpageflags_fd = kpageflags_fd_get();
 
 	if (!check_pmd_mapping &&
 	    !check_large_folios(pagemap_fd, kpageflags_fd,
 				addr, len, nr_hpages, hpage_size))
-		goto out;
+		return false;
 
 	for (; start < end; start += scan_mapping_size) {
 		categories = pagemap_scan_get_categories(pagemap_fd, start);
 		pfn = pagemap_get_pfn(pagemap_fd, start);
 		if (pfn == -1UL) {
 			if (!allow_nonpresent)
-				goto out;
+				return false;
 			else
 				continue;
 		}
 		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
 			nr_pmd_mappings++;
 		if (!check_huge_type(categories, type))
-			goto out;
+			return false;
 	}
 
 	if (check_pmd_mapping && (nr_pmd_mappings != nr_hpages))
-		goto out;
-	ret = true;
+		return false;
 
-out:
-	close(pagemap_fd);
-	close(kpageflags_fd);
-	return ret;
+	return true;
 }
 
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
-- 
2.54.0


