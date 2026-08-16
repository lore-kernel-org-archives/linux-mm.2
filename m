Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45058C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0FCA6B036E; Sun, 16 Aug 2026 18:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0BD6B036F; Sun, 16 Aug 2026 18:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61446B0372; Sun, 16 Aug 2026 18:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABC0D6B036E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FE66805D9
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:30 +0000 (UTC)
X-FDA: 85108618140.05.9FE8475
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1C691180008
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U 7g7kOh";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DjD3EFIf;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Yz+MQeog4f8alVx8miCtyDi54X9wM7Fdg32w1gvpyM=;
	b=l9tj2yFmEoc7CWYMyD5jTorUfKgPjehKsvibg4Mth0L+r/wDq/mznGoXtLUKuCI1yCO4Ol
	vhYkI9HnCiqYMb3bxYAd02S2zRfVS9WMRCFvLslcHIrMe7zst8dVZfPX7MsG5e4+g8srET
	KPknsWY4GhK08uzNGW+R1tpM54VKv2U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920388;
	b=svauMQdNi7HeunuknYMsAT49UI09U1IbP8Emg4jFkyatvDp1S0k4Y53dxHAhCNHfQhHtBe
	9He2bTpwDRZixyhnVNTA7ovQEOF+FxvvcvPd5njiLyqpINA072PsNsfEG2ipIdNZiTLRaC
	/qedMIf7qVXxSuqr25AlmAzlGhIWv94=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U 7g7kOh";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=DjD3EFIf;
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A171514000EE;
	Sun, 16 Aug 2026 18:46:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Sun, 16 Aug 2026 18:46:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920387; x=
	1787006787; bh=3Yz+MQeog4f8alVx8miCtyDi54X9wM7Fdg32w1gvpyM=; b=U
	7g7kOhfMJqjOAi+dbGwJXfRRqaaXLjJwtXsQeEA9D3Y2uNZcCziic5QZxRY/7nIJ
	BGeUVnTiY+UcoWWmKUL8cCJ0Ys/+DeDBTF22018QH1W3ubgIaHqKmPEZhSVOqkms
	FSofqfl0QsiKKsMI3TkQLxmmBy0gF7ae4OUZWdYAT8HMMMLGfIgNh/zkh4dvMa96
	FkSlQKO2zF0bP2pfp4FClK+PqwGUcL0O/s7EFBqVQTcoYL0ixsi3S47I7g3r0qfN
	SAvCq1CMQqtzP1NXMPouyU7CWh5p7gxsCz8caXl2SIdBhB2HjF60a8IGIwe9as0k
	5xR4VAvU9Ar9jBgcP6/pA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920387; x=1787006787; bh=3
	Yz+MQeog4f8alVx8miCtyDi54X9wM7Fdg32w1gvpyM=; b=DjD3EFIf9ognUhVez
	d6IWPQyTzU9K9kmpvkqWj3QeuLpMn7oldc8X/gWqyqpSFGlueHKUlhLhuB+jBWpK
	zXejcBu58l3E03ru64kqjwSu8RqwosIr1mbfFsnQz/a4arRvctPVdWdXPFUd7vfY
	49tX5O3xG9X7xsQX9EqmalwJlmg6Rm0Tn6OW+Iydx2iE30sSD/CwYrabWu8JKboH
	1N45kGs6xD/Zuth05e5jHVRjwzH0F0+IeD+iAyZC951UHUBYSrGNrrudLezaidLc
	r4PEJZfPfZLjCtneL/qU3fxjAs0z5q/PlVz6jbXcqek0AEhW9DauAO+BL/Wa54pT
	PdaxQ==
X-ME-Sender: <xms:wz2Cai67tQcXHVsm1PVvrrur1RHo4cpdMQN51XNHJurKCHyvX7No0w>
    <xme:wz2CahM8Z8vTjvGjJZ2F2iqrR_logd0yLSpVFldtmViMrht5Mgxy9n1ZL18gHvrPq
    Rzcst7RuJfAinN11WEs628msxO38yLKQPXl8ybkXORoH23PODBdVCCg>
X-ME-Received: <xmr:wz2CatidP5PV-1pM3lgHar17sNAZZ-nep8OEz0jPD7KjS1N5RTkBEzxj6-Y>
X-ME-Proxy-Cause: dmFkZTGj1BuhETEStCjbN/L6JrGmiaqzRpeX6rRNWhHsAzwzRlY9AKzqCvfWqke6XA7GOE
    A6FFYRRSvteD9S264L5lew1YUpPhGI3TlhRe1mYLYRUsBMnidhJP2r2PMm5Lpq2ztO8wmr
    yF1ddTX1W5NBA6qs0+EDXUaWwTs6UQPsEiicZ6SmY6z0vOVnZaAe+3gsuR1dg3g0gP4peZ
    U6KBKKlAxat5APGrEFg0r1ubDi9svGZRyISInygLcwTo8cXqakBbn35auVMrKeg7PKmswS
    qkEQEJGI+h4SGQWw8a8xHcXO10CUTBpRtdxlbIKv4nbtwWiZJ1jrVLIQttQS09NS+fWjNn
    6HzLMzm9DNDw61B2nSsR9GukLd62od1iLfT7YKnHgaC3UwalD7TMYHiRMPWLJfwOpz+p08
    K4F9yn8szmSmyQ8k4xp1xbjp++Cw7ifd/qAdDCX5wybC8EKHnqs9um7DxJaIJta+yjJwhG
    QNHw6zuuolynwtlWYUtWgrLd/Nv1uZYCe0w4LWJI4ojicPtFU41tlRVntG3HDsjNLEpZhY
    450m9elMctgV5MCBh248tYELoW9T9UxaeEUMZ1cVYuTVWVMMyEwqIZGoLAFxD5CM5cQxek
    nby3yM48SCOmGjJs1Qxbz7simVtLvPZ6zgoMfgiL5rjhL4HsQMmlGT25p9+A
X-ME-Proxy: <xmx:wz2Carsnk4p7ChU4I957FljKvhepN50MXkw4fxSeCf-7sTSCaP4pRg>
    <xmx:wz2CasYtHwAweHZ13O1_DC58qYy_xH2ZbnMdHhz0M5jxk81tqBpvzA>
    <xmx:wz2CaqV_7waANw-l6mlSwo-BjMPRFfociV9Bd0f7icosW8pU2wQjWQ>
    <xmx:wz2CavLriz_7Y0CnUWIFzcyFYyw7OX49ryT8A3IPl7fk14N6LNHCHA>
    <xmx:wz2CavYxyPjwdtIWC-3m3nzMiyYMwMYnYoPeC8-JDw-lGOK05DH_JNAG>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:26 -0400 (EDT)
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
Subject: [RFC PATCH 05/57] mm/collapse: state what a collapse may do in the policy
Date: Sun, 16 Aug 2026 23:45:17 +0100
Message-ID: <20260816224609.308019-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4ep1jgzauqzsojswtu48r4mr5w56jj3c
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1C691180008
X-HE-Tag: 1786920387-481986
X-HE-Meta: U2FsdGVkX19PYWwauVFVTb9fLXWAqYv1tbz+Q48lro6TmeXCUg/TIPwrw4QLJL7i8SdDtqVcZ5h5FE3Ye20QwlLnTuuabzRO3qioB6bwzM8dPlbPFTzowPZCn7bihM6ApejyYP03Vy6PzuJhHB21w3CSHFIX4lJM4k2wOC61dA9r1XNsGblvtaWCiypJQv1AJLUmsN5V/8sXM/OXOKa8x9kJW2sozrh0Jl7qTyzJal92bRDXMtRURIolCzD4K0MTy9SWNXz7o9HJcbEhFuIhyniQkcLt3LJfKk7uzj0nOmEf/gKR8wKU8OaIl3M64sm5YW9ck1pechmSeOHJBpMYGE4SMaKWY92DiZOKyjbkmKi0zN6tsf3JJCvwEZsu0CK5leGRtMHAKBjqMQYsNAUJBV+Q0JnWZnuRxX+JjoKjkDT06djfjnyPdrAmVQkVbtdVxavNjKEeYaxoORmwcbZ0cTZGRcV664VUW7xEsXk1FBy5w2Yc7PtwvEOYIY363poVg5Cwybdct6WXpK4Rl6/HjxbvMDvtEf0fT7zcU+/EOUB58zpfCKxNOB2en5Owcp9A0a4I/bou7YWl/PX0tq4zmBe4LxIwLgoke+kS7pRFfvRgI5SEcD66CL6YKngAZNJbehZgOn/iuxKfged9ifXrVyZK2WFRUmqctVIzhb6ileOQoQUrclMR2Qlb0Dn0GEbleNB1mNyDFj2yK6UvBt9XawygleRhiuOFVITGyiw0NjuEGMU0YtbrPeT0/nIpzt+45QbiNMLz7RLdPnnKZJXBI06f0UATX3Da3SNlQCMnfYdBGcgD4RQrtCQjFdI+nFupO1X8yQatm1BK4kotoN0DFvV9o+nE0ijzrSd3jjnXpNO1y0eRN3pFMG1dyX/3ZgEvrMCuMZnrz0zbg8gPGCp1NSkf0IEY4wrksa53V2F/PCR8IpCZyZT2IqHD50pu0HznXQ3zj27qAvVxOY2S1ht
 z9y04GNf
 rrJvYkZ937l5Wp9Xm/aGY1UC3haKY5woyjSOyPHKmdCawIMBA4gkiJF8kHG5zpMnIqoBUnJlvOOjf4JQFcCvH+9CpAQkA7GDGmNA2eus+XwzkAO2cWd/OOPjBVk0IOEJLToxiugYxInJLFs7xQsa9BIXnNQRi7ZfB5VvkQmclJSmX/7HVbB24albyNC0tojSlGgLciRcK3w2Mg2V9fJFY+2EGBuyPez8z7qX2J42dMgax1J6KtWn/vW93s0PyM5orEX0hwg2PKZwPrfzeXg+ztvcUfbPF/CxS9P/MZ7qTysHRiDSKL2MLs5iWFA77y9qjucbz4goJXBGfjSTn16Pp85T4HzTuMmc+tVTCT3mB/kj2/KwhFmRDU1ZEcBfeN8cdloHMSyU7VglsVEkDUZzVNe4aozmEfmc1Ey+L/MWLvg7vmMX0LbU1PrWN9Jd+yTVsyh6A4okq5cy5keY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Tests scattered through the collapse path decide what a collapse is
allowed to do by asking whether khugepaged started it.  Between them
they settle:

 - which VMAs are eligible, and how hard to try for a folio;
 - how many empty, swapped-out or shared PTEs a window may contain, and
   whether a sub-PMD window is held to a stricter rule than a PMD;
 - whether a range has to look used, and whether a MADV_FREE'd page is
   left alone;
 - whether the PMD is mapped as part of the request, and whether dirty
   pages are worth writing back and retrying.

None of those is a fact about khugepaged.  Each is something the caller
decided before asking, and the collapse code should not have to look up
who called to find out.

Add struct collapse_policy for the caller to fill: khugepaged from its
own settings, MADV_COLLAPSE from the fact that a user asked explicitly.
Every test becomes a read of a field.

khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
call.  That is the one change in behaviour: the tunables are sampled
once per pass rather than on every call, so a table scanned early in a
pass and one scanned late are judged alike.

cc->is_khugepaged stays, with a single reader left: the daemon's
collapse counter, which is bookkeeping and not policy.

collapse_file() also drops a NULL check on the collapse_control.  It has
one call site, reached only from collapse_single_pmd(), which
dereferences cc unconditionally, so the check was already dead.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   |  47 ++++++++++++++++++++++
 mm/khugepaged.c | 105 +++++++++++++++++++++++++++---------------------
 2 files changed, 107 insertions(+), 45 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index 9c82e71533df..44f52ea5bbb8 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -2,6 +2,7 @@
 #ifndef __MM_COLLAPSE_H
 #define __MM_COLLAPSE_H
 
+#include <linux/mm.h>
 #include <linux/nodemask.h>
 #include <linux/pgtable.h>
 #include <linux/types.h>
@@ -41,7 +42,53 @@ enum scan_result {
 	SCAN_PAGE_DIRTY_OR_WRITEBACK,
 };
 
+/*
+ * What a collapse is allowed to do, decided by whoever asked for it, so the
+ * code doing it need not ask who its caller is: khugepaged fills this in from
+ * its own settings, MADV_COLLAPSE from the fact that a user asked explicitly.
+ */
+struct collapse_policy {
+	/* Limits, stated per PMD; HPAGE_PMD_NR means "no limit" */
+	unsigned int max_ptes_none;
+	unsigned int max_ptes_swap;
+	unsigned int max_ptes_shared;
+
+	/*
+	 * Hold a sub-PMD window to a stricter rule than a PMD: no swapped-out
+	 * and no shared PTEs at all, and max_ptes_none as
+	 * collapse_max_ptes_none() scales it.  khugepaged holds mTHP collapse
+	 * to that; an explicit request does not.
+	 */
+	bool strict_sub_pmd;
+
+	/*
+	 * Collapse only where it looks worth doing: require some sign the range
+	 * is in use, and leave clean lazyfree folios for reclaim rather than
+	 * collapsing them into a folio that is not lazyfree.  A user who asked
+	 * for a collapse gets one either way.
+	 */
+	bool skip_lazyfree;
+	bool require_referenced;
+
+	/*
+	 * Finish the job rather than leaving it half done for a fault to pick
+	 * up: map the PMD over a file collapse before returning, and write
+	 * dirty pages back and retry once instead of refusing them.  Both cost
+	 * latency the caller has asked to pay.
+	 */
+	bool install_pmd;
+	bool writeback_dirty;
+
+	/* How hard to try for a destination folio */
+	gfp_t gfp;
+
+	/* Which VMAs are eligible, as thp_vma_allowable_orders() spells it */
+	enum tva_type tva_type;
+};
+
 struct collapse_control {
+	struct collapse_policy policy;
+
 	bool is_khugepaged;
 
 	/* Num pages scanned per node */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a12aafae8d9c..eebc044a930e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -310,15 +310,12 @@ struct attribute_group khugepaged_attr_group = {
 static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order)
 {
-	const unsigned int max_ptes_none = khugepaged_max_ptes_none;
+	const unsigned int max_ptes_none = cc->policy.max_ptes_none;
 
 	if (vma && userfaultfd_armed(vma))
 		return 0;
-	/* for MADV_COLLAPSE, allow any empty/shared zeropage PTEs */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/* for PMD collapse, respect the user defined maximum */
-	if (is_pmd_order(order))
+	/* The limit as given, at the PMD order and wherever it is not capped */
+	if (is_pmd_order(order) || !cc->policy.strict_sub_pmd)
 		return max_ptes_none;
 	/*
 	 * for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_PTES_LIMIT,
@@ -350,19 +347,12 @@ static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
 		unsigned int order)
 {
 	/*
-	 * For MADV_COLLAPSE, do not restrict the number of PTEs that map shared
-	 * anonymous pages.
+	 * A sub-PMD window held to the strict rule takes no shared page at all:
+	 * an mTHP is not worth the CoW-breaking.
 	 */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/*
-	 * for mTHP collapse do not allow collapsing anonymous memory pages that
-	 * are shared between processes.
-	 */
-	if (!is_pmd_order(order))
+	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
 		return 0;
-	/* for PMD collapse, respect the user defined maximum */
-	return khugepaged_max_ptes_shared;
+	return cc->policy.max_ptes_shared;
 }
 
 /**
@@ -378,16 +368,12 @@ static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 		unsigned int order)
 {
 	/*
-	 * For MADV_COLLAPSE, do not restrict the number PTEs entries or
-	 * pagecache entries that are non-present.
+	 * A sub-PMD window held to the strict rule takes nothing non-present:
+	 * reading pages back to build an mTHP is not worth the latency.
 	 */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/* for mTHP collapse do not allow any non-present PTEs or pagecache entries */
-	if (!is_pmd_order(order))
+	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
 		return 0;
-	/* for PMD collapse, respect the user defined maximum */
-	return khugepaged_max_ptes_swap;
+	return cc->policy.max_ptes_swap;
 }
 
 int hugepage_madvise(struct vm_area_struct *vma,
@@ -686,7 +672,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			goto out;
@@ -775,12 +761,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		if (folio_test_large(folio))
 			list_add_tail(&folio->lru, compound_pagelist);
 next:
-		if (cc->is_khugepaged &&
+		if (cc->policy.require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
 
-	if (unlikely(cc->is_khugepaged && !referenced)) {
+	if (unlikely(cc->policy.require_referenced && !referenced)) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -984,6 +970,36 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 	return khugepaged_defrag() ? GFP_TRANSHUGE : GFP_TRANSHUGE_LIGHT;
 }
 
+/* khugepaged collapses on its own initiative, so it obeys its own settings. */
+static void collapse_policy_khugepaged(struct collapse_policy *p)
+{
+	p->max_ptes_none = READ_ONCE(khugepaged_max_ptes_none);
+	p->max_ptes_swap = READ_ONCE(khugepaged_max_ptes_swap);
+	p->max_ptes_shared = READ_ONCE(khugepaged_max_ptes_shared);
+	p->strict_sub_pmd = true;
+	p->skip_lazyfree = true;
+	p->require_referenced = true;
+	p->install_pmd = false;
+	p->writeback_dirty = false;
+	p->gfp = alloc_hugepage_khugepaged_gfpmask();
+	p->tva_type = TVA_KHUGEPAGED;
+}
+
+/* MADV_COLLAPSE was asked for explicitly, so it is not held to those. */
+static void collapse_policy_forced(struct collapse_policy *p)
+{
+	p->max_ptes_none = HPAGE_PMD_NR;
+	p->max_ptes_swap = HPAGE_PMD_NR;
+	p->max_ptes_shared = HPAGE_PMD_NR;
+	p->strict_sub_pmd = false;
+	p->skip_lazyfree = false;
+	p->require_referenced = false;
+	p->install_pmd = true;
+	p->writeback_dirty = true;
+	p->gfp = GFP_TRANSHUGE;
+	p->tva_type = TVA_FORCED_COLLAPSE;
+}
+
 #ifdef CONFIG_NUMA
 static int collapse_find_target_node(struct collapse_control *cc)
 {
@@ -1021,8 +1037,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 		struct collapse_control *cc, unsigned int order)
 {
 	struct vm_area_struct *vma;
-	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
-				 TVA_FORCED_COLLAPSE;
+	enum tva_type type = cc->policy.tva_type;
 
 	if (unlikely(collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
@@ -1205,8 +1220,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 		struct collapse_control *cc, unsigned int order)
 {
-	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
-		     GFP_TRANSHUGE);
+	gfp_t gfp = cc->policy.gfp;
 	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
@@ -1559,7 +1573,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
-	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
+	enum tva_type tva_flags = cc->policy.tva_type;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
@@ -1658,7 +1672,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			goto out_unmap;
@@ -1716,11 +1730,11 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			goto out_unmap;
 		}
 
-		if (cc->is_khugepaged &&
+		if (cc->policy.require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
-	if (cc->is_khugepaged &&
+	if (cc->policy.require_referenced &&
 		   (!referenced ||
 		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
@@ -2572,11 +2586,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	xas_unlock_irq(&xas);
 
 	/*
-	 * Remove pte page tables, so we can re-fault the page as huge.
-	 * If MADV_COLLAPSE, adjust result to call try_collapse_pte_mapped_thp().
+	 * Remove pte page tables, so we can re-fault the page as huge.  A caller
+	 * that wants the PMD mapped now is told to go and do that.
 	 */
 	retract_page_tables(mapping, start);
-	if (cc && !cc->is_khugepaged)
+	if (cc->policy.install_pmd)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
 	folio_unlock(new_folio);
 
@@ -2760,11 +2774,8 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 retry:
 	result = collapse_scan_file(mm, addr, file, pgoff, cc);
 
-	/*
-	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
-	 * then retry the collapse one time.
-	 */
-	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	/* Dirty pages are worth a writeback and one more try, if asked for */
+	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
 	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
 		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
 		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
@@ -2781,7 +2792,7 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 			result = SCAN_ANY_PROCESS;
 		else
 			result = try_collapse_pte_mapped_thp(mm, addr,
-							     !cc->is_khugepaged);
+							cc->policy.install_pmd);
 		if (result == SCAN_PMD_MAPPED)
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
@@ -2931,6 +2942,9 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 
 	lru_add_drain_all();
 
+	/* One policy for the whole pass, so every table is judged the same */
+	collapse_policy_khugepaged(&cc->policy);
+
 	cc->progress = 0;
 	while (true) {
 		cond_resched();
@@ -3159,6 +3173,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	if (!cc)
 		return -ENOMEM;
 	cc->is_khugepaged = false;
+	collapse_policy_forced(&cc->policy);
 	cc->progress = 0;
 
 	mmgrab(mm);
-- 
2.54.0


