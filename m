Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 237A9C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF70B6B00A1; Wed, 26 Aug 2026 12:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8476B00A2; Wed, 26 Aug 2026 12:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F6C6B00A3; Wed, 26 Aug 2026 12:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A45E6B00A1
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:21:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6FAF5801A2
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:21:19 +0000 (UTC)
X-FDA: 85143935478.26.7E6049C
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf31.hostedemail.com (Postfix) with ESMTP id 894F220004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:21:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B P8PYzt";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=OZkFPany;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787761277;
	b=499twfmLhMFx6Oic2Sl+3hpXV4uvoQ64x5CZqazGVrxQwIxzR/jLv+Op3aDvKjLmoT7585
	N38R//bzB1fNflBAAOIaA6pF8zev6gz6QkjsgisBSE9bMrQnc4Eqxl954Vt5m12txe53fY
	WrN7iyw/h1GLv4A3TvOs46+aOEMNu3o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B P8PYzt";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=OZkFPany;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787761277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mSjV0I5LbWvQ9sczjJL6C6KyVdbqTRz8cyjnim/Edo=;
	b=wmAus/flmyC6tcRHX/UhLK6g7WOSG4OKbXOaREym9Gg2APS7oPT1c0aygM7omUBS5+m5FH
	qqE1yFKlrnce9UBTALvcM1vLtZ2ApXWxSR69agfQTTyKISc42P8FU9OBv4uHhxVs9x7o4+
	hojqgs92kZ1X0h+bv9fd6atXVBlXvF0=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 1949CEC01B8;
	Wed, 26 Aug 2026 12:21:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 26 Aug 2026 12:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787761277; x=
	1787847677; bh=5mSjV0I5LbWvQ9sczjJL6C6KyVdbqTRz8cyjnim/Edo=; b=B
	P8PYztGw2WCo+TvJSt+P6YuyWjwWc6g3OnhflMvlOKY73JNJqQZAS8rWpIkxa7jS
	5sy6kSLTNR6ZXg7Ye3++lUvIyDTBwJxL30+fyxiy8aWJ9Qs29R9VAsAP51Fq+dVi
	TORC/TNINXsILdoMIPh1jA/L6ujS/OddMjvAzebYyDDz9x6F5iEW/t9ulpIAamRl
	E+9VniKxIojwVi9x1hzFV8j2bVbrmhe3a3oytIexxkiCjpAM9t1z5tVm9uEicNF+
	TdMVh97zYqfBKWb8qK/G7fO9UKHp+DJg2/O9wTVyX60e0vx55u4hiwMd9gOfrHq4
	WFmzBNonn6CLm/ONCxPbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1787761277; x=1787847677; bh=5
	mSjV0I5LbWvQ9sczjJL6C6KyVdbqTRz8cyjnim/Edo=; b=OZkFPanygMXeDszE7
	n2A4Y4veWU+G9z5j3qcLApIpDZxDsfy/clS/lf3LKvFGzEQpIhjq0CLjDJ/LY4iU
	wJXNO/TFbHOHNsVa6hVWL9BI8vGauPInF2P44IMTVQji1L7XvJ2KMJpUJMTWAyf2
	4iSVkSvGu7Ri/5EWzwtjPZCNSPMEV9jqn8z4vIDbqqdPu4MTYtWBplRcSLQS14zj
	tIk5ZcFrKYMRWOa0bxyLEjqOuGIkHp7nasSHI5yGXrW5GTUI0vuOF/zN2VWFMCuw
	3Q5ZwLeKtXZbMBBmzhx7boygrk7vUcVle72ejnI4G5A/XG6RxL1WEzSeYpFOdkK5
	Cstgg==
X-ME-Sender: <xms:fBKPahdMo_r-egmMubW0YSx4uVn2zMI4o5rv9VFZ_FBOKC53_aKwUQ>
    <xme:fBKParLOXM5IfIbKlCkKNJqm5GBFtOJgZ5z_I11Tf8L9oBZ5WjBU2kBwm4oWwpVHX
    Zfj18SGQSjDuVKfim38cl_O2VlTbQI6sKZEILdF4BU5jCwc7HXCJP0>
X-ME-Received: <xmr:fBKPagqKMeqTEU-qnIAXX1h0vNCmaMRAXq0Ee0QFbd8w8KkAQ1kSuvDI0IA>
X-ME-Proxy-Cause: dmFkZTEpX8HBQysEAMlAbdyKFX4BLzWtS7+Qo1RjxAJeMJnS381384CQaxM92QA8W5J6jo
    7r0RHbsPcTs1IpTXqcOu2ofgimA8w2hMK3OeOMvPUWs2NDJNBlDL/23E29uU3eWq90a8Ny
    uayj7GqONoh0NEQ91mQ/H+TE3rTPuVZ+wfrdHbeyaEyRe40ZIUYJyXTHqnubEDskXnqfPu
    FIQsvLmT+4mxeisAsg0TmWv4Y7l9NdKef8tTMihpDmjKvNxij8lw310+ofBfGEkzSLqnuN
    AyozbfZUQr702Kz+RkXguKuGQfBCnKcQhC5EFdpLjS6L6jWqh1sGvO+4Vl+gX27JPRP8Ht
    szkLAhJPkmHmsMuK+YkYr9yTyscVe3c0bf17pnNuHqUsHycYFqkLlrF5TB5u7lUu8OB/wM
    DV5bI0v3NOIPdRF9o4laEl7rxuvns0/4qf6WByMLMYQby4xvvTzd619MkHG7vrfgrIajil
    9xrS+oFmBCtWr0VBzXNyMXnf0FwgHZ5PK75YysAf2sIgyHUj7LJL1q92xLX6X1MBq4U7uW
    lhwF/3qJ1OK36392uADRBMFSzHu8Lqs4TMnvmDfirdJRnCCZGu0TGiK789fROlpmrPHxnW
    Q4Y5yNtbL6/Q5184MpQJ3sa7GKBP7KWtEmd2SUmUnu6UiB8GFfT1xjDdsnxA
X-ME-Proxy: <xmx:fBKPahWb-khyZOPyd2mpwNTBm5DFuvm2hVRrFRXRGCoMONke2zaejA>
    <xmx:fBKPar2YJHTRWMC3O3NWgvWKqA_HdYXs-4yn96wkxcgP96sJ3pYwaw>
    <xmx:fBKPai1yM6aMG0txUqE83j0j7xPiDWqodfWHy7cDugfuT6yvGXePCQ>
    <xmx:fBKPaqkql46GyvS23W_LXsuMmZH7j7jVT6wzjhAE1n9y02NStBKAUQ>
    <xmx:fRKPasmzk5pUV6uaz6rpLCWKy1FmrQapYrUNAazabmPEbKOmUXwurJTE>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 12:21:16 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org,
	usama.arif@linux.dev
Cc: lance.yang@linux.dev,
	ziy@nvidia.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 5/5] mm/huge_memory: turn the swapcache-with-mapping error case into an assert
Date: Wed, 26 Aug 2026 17:21:01 +0100
Message-ID: <20260826162101.1314941-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826162101.1314941-1-kirill@shutemov.name>
References: <20260826162101.1314941-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 894F220004
X-Stat-Signature: 8p1677bdr9uxroy7o1x796uy7dwew9xt
X-Rspam-User: 
X-HE-Tag: 1787761277-817185
X-HE-Meta: U2FsdGVkX1/P2p4pD7KBv2TLlqY77pll7oGSDN8fq0pFg+te1OQz1IAe5KtYusWbr+6+xdb8Vuqds01IDiO8bv08r7sLwxqi9ulvz+HtdniBneaJkn9xOgzPmGLQvEgvKiCIPQhk+mToxKaj1mXY/DrnUA+gBqWBsRxJaioutQ/IaJdCAFUvZxIa8+LeUn/D5eu98AUEmwMXfLXutbpyWO0hSX4zb3zlwJywyTaA9BlM3cIzDuJWBf/nc57ERcV4H9ox1RD9hKc19JlfbG8rUpExBSLf3/NE5TB6Uk3c9DH8brS0prv/6vS2mRgTaWzRudzXcgNuhoJTv35NWByv8VH/mGPpzukD+FXSW9z/F+OonLsLogjkfa+p/LnCINSsSiGEPbfzkRcEJtmDAVHNQD+o41ol6OTz5koGxc2tu58U3m2zCW9WhOdWY8QhoWlc3aLeNAY0waB1Uz6ik23fR6iAbwNhTVvMpMh7rxb5NofX4TclUHhSbKfFWXUb9jsQNQoCynYp9yTaMMzFlU0DH+edRrftVQSaUTHirCTDlAG5k3sE7M7nE1FFTY8KdQ6CoUZy2DKAdDy/Rn51Vhp6mTUVuhaNG+im5XB+stDIRWSGj1oIUsxuBqOaBCtrMC4Ka0ua32DcA9VIYKDeecf9bLpzH6tRSlKTcLJVgEUN9+T+jPqS3LXetjJOqyUvfHjnhsR84BJC0tm80e27JwT/1GiijKfDAvLdqnaJvXOu/R76nhCYxRAJuwJgTJXdkhsgwwCS6iJxFu/ABpvC1p8hPXX2w/Cc9OGL38fZmoRd12SOkBxL+gEDMYZCQ4GijUbO44mynQ0UhEvP1oqkp3/Yz7C0s+Cg1yqSytdW/lZttzcJAhF22pxw4P4IRn168Q+p2zacvTouupQNyd2i0d9PIQh+yk0Ra8psqRGl9zQknHkUJqLZ+7cBF2W5hxZJ6E7V+zFl/umNChIrtA+e5F+
 AZiar8Sd
 5R+S1rpuwFeSeA6KKNS56nryJIyKhDT451WSvxxPjWup720VKRqfYetUAUGc6rQ406zhDPp+pLQbyil8SLhd2POkrEkAC5u1g/M1WssXiEufQBFCVGQd9F/2OGpSiPSrgTIqUd/hDdLHsx8L82HRpjY1Yv9aSNI5G7dn9wT26W2Avk7BNIyQ5rnyWLjREyfUJkIu84fdU39LkIFzvthh8T7n6CryhdKHt93ahFYHrcekGbxKxNwjEkM9SASg738JAZjvEBD7dXACRty+OYsTUpN4mtsI4D/bN3+zJsD4+IgtComoIzV3+x8CidWb2k7uksaAu6BRWWOyOeQXEWXtvD0NK0l0ISX+kawMb1bIY28F0KU+zM4kBS92ufDEonBLfHhchNBI3r+ie3/sL9KSUGGboMWPiIPMm/hy2gWWgzV6jtGAQy3YJDhm2O7DS4YhtynFqPObKhgF34u1O6+DULZnd/E3+8P15BY+7LVNxXJmwlxO/wYG1JOl5lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A folio in the swapcache has no mapping.

__folio_freeze_and_split_unmapped() tests the combination after the freeze
and returns -EINVAL. It leaves the folio frozen. It is not a real
recovery.

Assert the condition with VM_WARN_ON_ONCE_FOLIO() upfront, and do not
pretend to recover from an impossible state.

PG_swapcache is protected by the folio lock and stable from the start of
the function.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/huge_memory.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 001d89c57fa2..8fc844ba67a1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3936,6 +3936,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	int ret = 0;
 
 	VM_WARN_ON_ONCE(!mapping && end);
+	VM_WARN_ON_ONCE_FOLIO(mapping && folio_test_swapcache(folio), folio);
 
 	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
 		return -EAGAIN;
@@ -3965,14 +3966,8 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
 	}
 
-	if (folio_test_swapcache(folio)) {
-		if (mapping) {
-			VM_WARN_ON_ONCE_FOLIO(mapping, folio);
-			return -EINVAL;
-		}
-
+	if (folio_test_swapcache(folio))
 		ci = swap_cluster_get_and_lock(folio);
-	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	if (do_lru)
-- 
2.54.0


