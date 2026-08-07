Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFD5C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962DB6B00B6; Fri,  7 Aug 2026 07:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93C926B00B7; Fri,  7 Aug 2026 07:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB746B00B8; Fri,  7 Aug 2026 07:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A62F6B00B6
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:37:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1784A039E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:36 +0000 (UTC)
X-FDA: 85074273312.11.12CF04D
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf04.hostedemail.com (Postfix) with ESMTP id 112BD40003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="x bftsFI";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=mNnlgo5w;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j0pTWFpZyp+VvcRD0WxQqHE3ctvFSewhwoAIj25qxck=;
	b=eXlGfP3cP+PtnQ8EFpdzHxN4+2Suxb71S+TXmfPMfoczUzgNTJVhdIcTO/1AplTBTzIIgb
	KCyh/kb6tOBnSJopqWT3RGXa7i5dAQQkybjec9/GMfJG+wIZFOxPIyOchn1/YRGKobr9wL
	xIW+Xc2YiDKIeGs7Hcz2UxK1xbtOloQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102655;
	b=mPkQ4FhoE/49slRRTw2kQV9hEeG+ysyvrD9+nzNmwvqCwzkbEQLvbJmqVzubf1eZdtHckX
	tNieJhBHL8+5rYXj3t0Dy/zFJtFFR7wO6og0vfOC79rBLNVk68YNtntX235+J7UiUwcVfD
	dGuTtzlKtwsVBiOyEhdLJ/pNwEcswvI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="x bftsFI";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=mNnlgo5w;
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id D90FE7A0120;
	Fri,  7 Aug 2026 07:37:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 07 Aug 2026 07:37:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102653; x=
	1786189053; bh=j0pTWFpZyp+VvcRD0WxQqHE3ctvFSewhwoAIj25qxck=; b=x
	bftsFIgYkMSok8nICxfbAq1vmfsz4Z0KdfsegX/1uf08o1cQaXApfJ5J8j0OTmd5
	C3PiD41M+AzixMpV8qI9YmCiXzNyGUd0NdwDVL7izDqRe2IjfthjC+myekxxpZE6
	xZkLw3stIVqqyrw66g1jQ6DTxLsmsTQTN/relElWyUQaW6MG+570UBEiaIC/hSc8
	rUBIKuXZy3zBQkTNbhXwteZi+tD7y+ewMMG0PZK4knc6JQ1K8vMPqe0a+Cioh61s
	+zJyBW2lcVo2ZrJ/eaWhAZpOGVYQyB9u6Z95p7x8syxqVzm5V+cfoFWjqorKQWPo
	OwctHlJA+VDcceIGu6DvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102653; x=1786189053; bh=j
	0pTWFpZyp+VvcRD0WxQqHE3ctvFSewhwoAIj25qxck=; b=mNnlgo5wXwMK2z/P+
	oeXSTUdjLJAgU/EBotX2PNmPJa0tc/1GpX1VDT6yzsXNIaddJn8xpQD+p/a9Apmy
	bwP/pyrqEVLDM9feG7wzBEyWazq0Qd8tozZOg6kDy7IG+LdD6k3Wv6HRYabHpmIm
	sF6eZBZ8mGE4Ch7U7/LaPZQO9qoqIS9uWN3Ea5A4a5NL0hjc1cym9Kulz2oq9xeN
	u4Fqe/FTcpOLleg+ds/3/c29oj3/ml/Vqfb1ka5nUSmFAAVzJOaJ+ouTwTdFb8v8
	L9/gDxGWDNnfQ9KD0PUSniknK3Is0dqAcxhqqdOenvof00yi/f0jXXquEvznI5Zq
	iA1Fw==
X-ME-Sender: <xms:fcN1ah0DD3AeiE6UvfCAF5QYfa6NkxzBXSClc8Fwutr-ln8PcCxAMQ>
    <xme:fcN1asCoFgbKkfBL7NmUuK0AonRB_Y-GoWY2nto0lczDEm4Fj11qLK8gwRypKmJlu
    wua5HNxR3m4T4Nv9ez3holE3ko4BdU3ce9guikiofGGgg02Fu5zgEqc>
X-ME-Received: <xmr:fcN1aqaZ_0xl3kOVF_fdRC9nvGDF5aJLkKuY6lHO-Cd5CNLmJWRZuR1bNF8>
X-ME-Proxy-Cause: dmFkZTFHgVqOo5hmjJljb3IAZGkXyyxzQaD6i5RNmNk424gVmZkPzr1NfNWN42YMHBLBJ7
    ouwgSkV7uP+O116AnyQ77X3VN5vAdqq1zvzV33EYJRHUa/cQ0OT9UF9tJbf4RJE1rh86et
    dgK/XsSmEjRvIZ4/DwnHkulf5IWkeizHGDAErUJF9mnMadsJqDG0SAHuOjgfipI02yAqvF
    a9Gp7D1P4aM7ojieUjy73reTq6pHjAlslJzhWF2Bayc7rzuN1loFnb3tH1A/9l8/u/BKz2
    kEn4hJCLyjrltgNf/ADveISAZdc/G8K4aY+0IiJqAeENTN6qSce54NhN3knOmRl67eS+Qh
    /GDhBAG3wst46ljWIEG6h6ptOpuEu5vMqJ7CiNfirp26y5hXcRosGEtwZNX9q+/Mx5m/Wm
    18OvmXPsEUykWNTvUXxAMk9ehrL5JG3kQbKJE6IMEikl2yq2a8p7fPSXxLgRyc+IBLe4eB
    sHARQUv0hKUKXc+Rk3Cw9iDyfk+gvnaNxGQ9Gr62oeu4PJGH5NWqcHovNLmY9RM7CkdLgE
    kG3sT4dCq8bDdk36o+UvVus9mH46NhTOVedbykvpE+hKqvsrqn8J3aRu6ncnXEqXGp8lcJ
    ktWemNxd0IqVDSIhQADkbPFZlfudXSNAeqIjWmB5lgnaRnE6RQ2TpJsIS97Q
X-ME-Proxy: <xmx:fcN1aoagw3eTixxg0QBAiiYqAY27j31s5J6RhHnYcDCHb0k6qvcamQ>
    <xmx:fcN1arkP1L5P7dumv8MtRLVYB3E3mfVG5bJj8GsshpqEZ2FyDjqzug>
    <xmx:fcN1aqT5P7LINDB4oPAggZF1ce63aCfsSkd400oN-CZChzn_0fgzEQ>
    <xmx:fcN1agXJpwqCB2tmpjpoCADfGvZxYU_yH-TLBLs0Ascy5Ykno2ZqqQ>
    <xmx:fcN1agJG3LL4hGGWwlQmIADcLl3it-c9hh7Z5TpPFE76Hq16j4O7rp3o>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:37:33 -0400 (EDT)
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
	kas@kernel.org
Subject: [PATCH v2 17/17] selftests/mm: zap whole PTE tables in the khugepaged race harness
Date: Fri,  7 Aug 2026 12:36:47 +0100
Message-ID: <20260807113647.3744609-18-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 6qaumwtktiht5fnxqjdkt6cfk7ymbixg
X-Rspamd-Queue-Id: 112BD40003
X-HE-Tag: 1786102654-754501
X-HE-Meta: U2FsdGVkX190vP4oAt+Qq8RwoiMI7bYhjjNG2J61wo4M9BRNlxQmuc7VAZF45E6WRB+6yBnApWf2uFXG6XseMPYnoqkznwLHnjz/dOBt8MO9Mi0DNtXLZ8Z44w+cAsuSHJ+f55t4LLcQ43qwDsarMg45XsvG/JqztVYU1EP+fxDRu5cgmA5Tfov097F607MM7aNovD0hvvZz3tiDyhZTPZMpgzmoljapDOTLlBuUFKTrHCYM7ib2Gm95TuQBbbtki0WUIYzaZUzajGNxVQdD+ASv9v49vmcfHoiLsE+DOkzOpVSXog7g3CK3g1I0n4eVMLdDaCgEZHikCYS58+HEdeRo0CTXt8B16Ggn18kLHcxfBLzLH94h/AWSv3sbPGaOpJiWh0jAdmDyBCeWfk4e2+2GwPwaybXjqXHErZBJrHqH4oS4BlzSk9NyRMN4rZUA5iQOEfCrNfkUbPQmIdiSPD5m+fqSnRbRWblSjEfinh378N0gpWF4LBmqOjZufc2y2iKy9rNBkp4VcVEGIn15d/8+Pzq3XtQi6xLaLmb9OY231Jf7KqcwRgs42yDHJx5DHR5CbnfN/hdN7tRwzVzPsVl62tHuUsux7PyeBkH15IxVGWGZpUwPwzerAQSGD+1zKjhA0fhc4V968qh0LUMrMS/1WfEq/uceFFXYZHNMfFtQKK1hBt0A2/WZzp3Ui96vdSv0jLaoCIcvgzcQaiKJszLKd3UV7hjuAqJKypQAQtK7ZPz7h1wftEXxOCFBeq5/R5KCwVZPWwyPa0l0Ycpw726xnT+YQnvj+OmPTsKcBvqL17vNxmPb5CuH2DE7sMsSdmfHuKky6p1hivQ2tpssQOPTyv9+K0sozDRbp+x3l8nBlxr+HPyZpH60qstKapjNPv0/b+jXZxVFTegzqolmefJqdCsLSJxeF/slwZJn54six/AWXNl1m60ufjsiPGlJZzHnxJrGhU2LIoSXLvB
 I8NGm1DE
 t6aA9vOaFrbrBn7Mm2sthX7jh4dPGCXbsKvk24O5+XV1SFaEN7Ie/7O02RqOVDzAhpjsTVGm4uwvpMKQYDULbzazwzGgWVuN8ser4HkZ0Uz4n7NCt1i82ZzwWqjJcGe9xZeLmmCZ+B4J7qKofj4FsYCaujrxc76JnaDckAMV0LO+PbgEa733XViZmOliend6U0PC5lHMNoa0yLwBecNA4NgMVGC4Kjh/0QWMRoNt4toeveDCtZknxPVXtOkAPQTaeisSzKU1J4y47YKPg1plDdDTLjLfQ85r13Z+9N3XpKos8Jdy+OJ3Tn86494LGp/1DAHHhCYvQybF3DExmQUZu02nSHjEsBKK4mCADIWIXOCpW6jjr1cHp7Ysy2pR0FwPU/b7Ck8GHzPWDaRjqVub2FNYHQv6Djxxe4UqqnlJc3cFzExdA7hSWeWb47cPu40JtGs3P1PF/uu58IEk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The harness's MADV_DONTNEED thread zaps 1 to 32 pages at a time, never a
whole PMD-aligned area.  Empty-table reclaim (CONFIG_PT_RECLAIM) only
engages when a zap spans a full table, so no soak ever ran it against a
collapse -- fuzzing had to find that class instead: the page table
vanishing between the engine's park and install passes.

Make the thread zap a whole PMD-aligned area once every 64 iterations, and
keep the fine-grained zaps as the common case.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index abd142db7cbe..1fbd20771a5a 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -121,8 +121,23 @@ static void *dontneed_fn(void *arg)
 		unsigned long page_idx = rand_page(&seed);
 		unsigned long nr = 1UL << (rand_r(&seed) % 6);	/* 1..32 pages */
 
-		madvise(region + page_idx * page_size, nr * page_size,
-			MADV_DONTNEED);
+		/*
+		 * Once in a while zap a whole PMD-aligned area: only a zap
+		 * spanning the full table triggers the empty-table reclaim
+		 * (CONFIG_PT_RECLAIM), which can free the table under a
+		 * collapse that is midway through it.  Sub-table zaps never
+		 * reach that path.
+		 */
+		if (!(rand_r(&seed) % 64)) {
+			unsigned long area = page_idx /
+					(hpage_pmd_size / page_size);
+
+			madvise(region + area * hpage_pmd_size,
+				hpage_pmd_size, MADV_DONTNEED);
+		} else {
+			madvise(region + page_idx * page_size,
+				nr * page_size, MADV_DONTNEED);
+		}
 		usleep(rand_r(&seed) % 500);
 	}
 	return NULL;
-- 
2.54.0


