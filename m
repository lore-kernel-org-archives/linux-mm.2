Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BAD7C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9576B037A; Sun, 16 Aug 2026 18:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1C66B037B; Sun, 16 Aug 2026 18:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5993A6B037C; Sun, 16 Aug 2026 18:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27D146B037A
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A398380577
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:39 +0000 (UTC)
X-FDA: 85108618518.15.5166B09
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf07.hostedemail.com (Postfix) with ESMTP id C565D40006
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="m c1G/v9";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=fOTtMaWM;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920397;
	b=wwrzmW0FFStc+4nS/9LFANs0eNz/QyEeLSfBPxP9z1xyKOkf2ovqLjpqc6S0T4Wbm6jF0G
	yu93BuYAsrLDP9KzF4GT9DGxRRgZLOUxu+RNs6o3q6J62ji+Hz2S+Rr2DsW5VfrW5+3y/2
	3AETHd2hDhNt0HJ7EJ+ASuz1RtEgeMc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="m c1G/v9";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=fOTtMaWM;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6GvdX/z9pV4lxPc5SRlNT52Nk8AS9W2M2/m8d2d4Is4=;
	b=hLBxCH6woy6OrxptNKCiZR+IfYtE3UWjRx6r6qhUi2KZYsMGjXRXzVHhzDWJwJY3kQOI3b
	ii+ajeYAhQqlrmMrtneUh8RzHfvjpFiwsZCAByi+HttVrvaqIPONZGE6jM4pDRkcpKfWec
	6zFyfDPzp4Hb2iceboFR7/EqV2hmBBM=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id 66121EC0244;
	Sun, 16 Aug 2026 18:46:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Sun, 16 Aug 2026 18:46:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920397; x=
	1787006797; bh=6GvdX/z9pV4lxPc5SRlNT52Nk8AS9W2M2/m8d2d4Is4=; b=m
	c1G/v9uXgZYFsICqr+QjexNh2FmtgLrSlr6dPVqX0XI3dImjsBSP1R60zY41Eoaj
	5aRJnqRUNOV/2Ws+I0YNMdLWWNFMBoPavhEa15M9Reqq/cBAJGzVVG7BANQlctcQ
	Ei887na/bVCIyuCv54DNliN85QSOUnoY7nIhSy1UhtPPhpd0InWAtRNcifvMSAJg
	ZLvl/+nZtAa4Cl1H6KXdQ9VzpdYdCAR1KFN3j1aGJITx2ArNKl3lxRQTEUQNKtfO
	8RbvJLiXrVKTED9/bZB4RdM9DAx0G7tYye4mch1AH6wtvm9UzuJZ0IUXtrJaDQSC
	VX7nN2uk7kO5tu6QZ+K5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920397; x=1787006797; bh=6
	GvdX/z9pV4lxPc5SRlNT52Nk8AS9W2M2/m8d2d4Is4=; b=fOTtMaWM84K4Muz6r
	PzZ0Lal+gYVeumdOkmn7iZovsSiLzZPJVthtDVYytfcbi+dZBHqz8BmCdN+qRzeK
	r2PEUUMbakRN8e97AVEPFbRJ5ledgJlT52d4v2BIYtIrX/jeQqmlAYLBdSGer+CC
	VzS+09RzmGYz4oB772oWkJqDqqZryZxDXwpzDRNYIVKphAA38rVJM+QENVEFMDpE
	1TrYhQ6vDcoj1KaRuRkVbkGDG5ZJY0xWeY28Yw+GhsK3mgH3NkXln9+fJfkK2Tb/
	pdBY437ADNxHaltx70MYrrHfelsGTRoy9Cj0ZEI6SRkXE9H8ojAaYfH+ZXmtfX96
	x9CvA==
X-ME-Sender: <xms:zT2CamQZsKWHQaT2C1Xgj3C_sbjPqQ53-U3UYMBLaAVfFTB3hzsPKQ>
    <xme:zT2CalWfyD_io5bqyASUOe0QmmQhQ39FYd7M8HMoaqW_fNYea6wLpI60SkWi3T8mR
    vOFmJnnK826CMqTYSStktvi-ga7UZUUfO8dkFdUUwPAgrB7nptuK0fQ>
X-ME-Received: <xmr:zT2CavQXe932g71QVg43mZ2xGGDU80Dv00DBryWa4zjsqKp-V6QrhLPHHe0>
X-ME-Proxy-Cause: dmFkZTGQiHMMNOd1xnoN6lXQSIrGAe7MwYo75Qud3VSOh3aIjL1T4IX+wE1i/v23Y8aWnG
    m9SHT5inuXsr6fNeLF7q+XcMZ+pkZJxjpb2XQQyKrFdYKaLz7QDFEiegvQaT+Y5rGxRgjF
    euipinLXiFMtCpFgMqQP9Dwn4SHq3YG285QsMU4KB7YfRQHYWKIG6dJTmdP/7bPKv1qUNe
    3LkhBXaaROXWrLGafj+UVrogU8Abxo2OvgWTBKIlLl3SY5Eb27sggkfdoaZJgpjY1+W5mK
    IYgTH3bmg7umgeRjJmx+WAhyhWPmGn2xLzWKHa3nzXVCTdFk2+6Uh9D41+s+1+4ThvFtt2
    jeK1puiUf8/lXHw9run/+wq4ZMkal3NqfCGVfHNZQeqzajSoM0xs91hLNdfkGJVMEPEo50
    EPe+Ncx4BTBm7MyOsoX0Yv+7dODbPcL1P8bwxI8Ww0Vd+OJKkNSE+UeUiLjokmOTqE3x/g
    NVb6tth4Fc2XxFG8ViDfPqUuCtPt+2/drARpFjlBg0GZTT3TNpKGPRy/wAl24096Jq8fMk
    0IMtaDT4p2a5c8LGBnQHrXa+BH7i8dsceJq7w4HtmfDRlPOGvjk72Mh1kFWRA+NJT+Ycq8
    hlwNa62Gk1NaJ1js+PYaOu4IOTxXbZOkzWhgmhlQmOvIcjzJo6//3LBCCChg
X-ME-Proxy: <xmx:zT2CagusP5FR8Kcb9L6a-8P_d6_Lfao_Wei_LCG9KyHRzdP1aGpLUA>
    <xmx:zT2CagZB00Az8HWMudWkHlQhxPss21VWr3iR2ZFkUYvv-0_w6nNadw>
    <xmx:zT2Caj9oruiohkqvAnRN0FLvKySv4EVZG-vOmI81D6twhQMIPYb4GA>
    <xmx:zT2CaiCh-BxLuM8yzAnYJe-ELwUpcFlS1enjrMT3iG3a2RYKzmAZEA>
    <xmx:zT2CapOH4Gc7ODx-0-N2H503P44BpMoKoUFLW7X1iyu3gewhPcL4V2gA>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:36 -0400 (EDT)
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
Subject: [RFC PATCH 10/57] mm/collapse: run a round and feed the outcomes back
Date: Sun, 16 Aug 2026 23:45:22 +0100
Message-ID: <20260816224609.308019-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C565D40006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3dtuesk6fdrt941zrk4a76nnr6ys1ke3
X-HE-Tag: 1786920397-902527
X-HE-Meta: U2FsdGVkX1+vwW/ma4nXF69Q1PWGjFP6+1M9TDtRoFSD5KQgmBBuXsgRHaHtUmP1pvKM/yFzSJz8fHvVazB4gUlQzCCsBdx4hB7epCOuquZFIiTMNn14PjBj0bt3yD/jZnIwpqFXh2tQ4CPB1zr6qx8P6ulSAn3TZmm6u7Vjx6/w90bkIvEkcW2fsqyGeCy3FK9RhqMX6+xTTDELnpCN4yY6DlEBkE/CPTxuwIuTnqPNqLd/OfwN/8yODSfggb3Rl+ZOUTbC5Kck2YhZpPU61hKp5GvwIVCv8k5uoZUAOH4ZFT0JAj27hBmFvyRARBZk7JJJsxP1uRoP5oNa1wtq5MoV2zHbjdkWK7mVi3rsPOtJSJr1LOSUep202rV6V2/O899WjuWLpwg+In7MCNmDRujHi5U9/g07Y/4VI+OwT35Kth20OYZqKC11okT302MrMXour2lXjm6eDtfL7K7flz0mQZwZfS5VSRNB++Dsj5n9GmranOVX50hT7phK2WsdeyXtZ66EpY6OjBIYhRWoWOlREf2et0QyQfboZpr97X8resEea3zWKK6fOjoUlUQ+rvcB7AVH9YCzuF+/Cwt9hjoJ4Kug46FSrh8hIvVIbIa9KnUOZvAYC7856SYdFK3RkTurGMPQDfeVOYQgZnNQWGiP3QvJAoItXiV74F6jnWUy3YjZkD9ylGexB3xhp4HayQrwLFvei/CDXhTecENeA5uqhUkHjWRQKmJRoQLrroP0bAwYWOG9tA+YxP7EthBgAORYvrMVxj3/B0QR6q/3wghReUulK2qsRTDHrQbKGUxEL+KcjqZHNjhLKm4qZ0SWKQU7jo9WVphgjMPbrgYqF6auxfXyUderze1xXo5FVhIcA6GhtPpfzYmqIFEGf/xZ3fIn9SwMvf7fj0CqdC3kadi1nNdLR2YpRQpcqPLno7LUAr5I/1/E3YnzXAxABX/Gx1MFcIjCeXyAZx+cpd+
 RP8QjM97
 vxWhRhL5uQUme3NlNWUVPBoh7VxholJI3reCV951VxFEAP3XPke5knTJHuYWRv5ospbTNB8ug2u3schRdxMrWCXSPa2mOED6AznJwKRU8Euq4TJ5mTFKHzi7vkk8LA2YAyyaK5SqaTddSypQrRPyIVAR08W8wg9h3qoaDDhPqcPC7GIcJiNIjdQz2ff6UX1k8UambvCzMcD6wOWyiOMCAat+6zRS3q1dU4jPkdAgU7MPB/EOj3ZUu2CsyNL8rF4kfW3zKYBZpDTRSXfp7OGkmsfQ79ll50ox/pI7QFzDEJ3yMM/EoG/goDgzJ6PWDsQQSzFhW0wmkDMMHUY1oA9Nlaqt0+HUdAP/63XYejtfuKCyF6E8cO1/S5LpKgJrZDj148AIWCrAhn24vLqtq9iU/J53+gT+7juSVTw/s9KCZVqqMNWaCF2j3PuNlDNza1QaoMv5m9ZyaifLCK5Ag+jTYma/HD9GMsac7fffl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A candidate a round attempts either collapsed or did not, and if it did
not there is a reason.  Selection needs those outcomes to decide what
comes next: carry on past the window, try the same region at a lower
order, or give the table up.

Fill in collapse_run_batch(): run the round, then walk the batch handing
each candidate's result to classification.

The walk covers the whole batch.  A pass that refuses one candidate marks
it and carries on rather than truncating the round, so every candidate
has a result of its own to hand back.  Only an outcome that condemns the
table cuts the walk short, and then nothing of that table re-enters
selection.

The round and the classification it feeds are both stubs, so nothing is
attempted and nothing is decided.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/mm/collapse.c b/mm/collapse.c
index 6dae5e35e61d..ad9e5a447854 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -115,8 +115,16 @@
 struct collapse_candidate {
 	unsigned long addr;
 	unsigned int order;
+	enum scan_result result;
 };
 
+/* Where a candidate sits in the table, in the PTE offsets selection counts in */
+static unsigned int candidate_offset(const struct collapse_candidate *cand,
+				     unsigned long pmd_addr)
+{
+	return (cand->addr - pmd_addr) >> PAGE_SHIFT;
+}
+
 void collapse_control_release(struct collapse_control *cc)
 {
 	kfree(cc->candidates);
@@ -132,6 +140,17 @@ int collapse_control_init(struct collapse_control *cc)
 	return 0;
 }
 
+/*
+ * Carry one batch of candidates through the passes.  Every candidate comes back
+ * with a result of its own: the passes before the freeze mark what they refuse
+ * and carry on, each pass after it works on what the last left, so no failure
+ * truncates the round.
+ */
+static void collapse_round(struct mm_struct *mm, unsigned long pmd_addr,
+			   struct collapse_control *cc)
+{
+}
+
 /*
  * Is @count past a limit stated per PMD, when only part of a table was scanned?
  * Scale the comparison to the table so a partial scan is held to the same
@@ -455,6 +474,18 @@ static bool collapse_next_candidate(struct collapse_control *cc,
 	return false;
 }
 
+/*
+ * Feed one candidate's outcome back into selection: its region is done, it
+ * re-enters the retry store at a lower order, or the table is abandoned.
+ * Returns false in that last case.
+ */
+static bool collapse_classify_result(struct collapse_control *cc,
+				     unsigned int offset, unsigned int order,
+				     enum scan_result result)
+{
+	return true;
+}
+
 /*
  * Run and classify the collected batch.  Returns false when a candidate's
  * outcome abandons the table.
@@ -462,9 +493,30 @@ static bool collapse_next_candidate(struct collapse_control *cc,
 static bool collapse_run_batch(struct mm_struct *mm, unsigned long pmd_addr,
 			       struct collapse_control *cc)
 {
+	unsigned int i;
+
 	/* collapse_anon_pmd() only runs a round it has put something in */
 	VM_WARN_ON_ONCE(!cc->nr_candidates);
 
+	collapse_round(mm, pmd_addr, cc);
+
+	for (i = 0; i < cc->nr_candidates; i++) {
+		struct collapse_candidate *cand = &cc->candidates[i];
+		unsigned int offset = candidate_offset(cand, pmd_addr);
+
+		if (!collapse_classify_result(cc, offset, cand->order,
+					      cand->result)) {
+			/*
+			 * The table is abandoned: the candidates behind this one
+			 * keep their results and are left unclassified, so
+			 * nothing more of this table enters selection, and the
+			 * abandoning result clears what earlier ones left there.
+			 */
+			cc->nr_candidates = 0;
+			return false;
+		}
+	}
+
 	cc->nr_candidates = 0;
 	return true;
 }
@@ -502,6 +554,7 @@ static void collapse_add_candidate(struct collapse_control *cc,
 	cc->nr_candidates++;
 	cand->addr = addr;
 	cand->order = order;
+	cand->result = SCAN_FAIL;
 }
 
 /*
-- 
2.54.0


