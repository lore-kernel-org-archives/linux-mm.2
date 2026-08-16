Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6604AC5DF70
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943A76B036F; Sun, 16 Aug 2026 18:46:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5176B0372; Sun, 16 Aug 2026 18:46:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5CC6B0375; Sun, 16 Aug 2026 18:46:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46FE46B036F
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB3F7A060B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:31 +0000 (UTC)
X-FDA: 85108618182.24.9CD2329
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf25.hostedemail.com (Postfix) with ESMTP id CBC9FA0006
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="a YM3Cqx";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=c55YAllF;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHXoaFr3Xl7m0kg4SnYsmksRc4op7lmfQDtkE+LuXY4=;
	b=U1Yi6dI0PT8hqSZcADMnPK5VeDYilvaAgC6sbS+JJmAXb6Js5/AyrUBPTZRFpg6E05SAup
	l/dJCVm2e/+hQx8IfsUvNkm6LYpGV5UfelAJc1L66p0iWj+wfRn4RvI/i6aRdwKh9GngGF
	x5BiOtylaGDygC/yQ/IH/iYxPmN5fK8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="a YM3Cqx";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=c55YAllF;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920389;
	b=DgKnCd+9aEo9uN+bO+4tZhLJVxgqF0AEU1iKOhjVA+PkCbA7T7E2gnvDCrySeYYB5qpRrT
	bO5KdmuyGRM+H2d5ttTEbcDa/1GSUb/HwAgHvmTF82Ix4cHx4JKBkw3gW1VLWIvhxPuy4k
	/047bgUfMsc2pjBMh6SvcDIOdUOGP30=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 57CE514000F8;
	Sun, 16 Aug 2026 18:46:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Sun, 16 Aug 2026 18:46:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920389; x=
	1787006789; bh=mHXoaFr3Xl7m0kg4SnYsmksRc4op7lmfQDtkE+LuXY4=; b=a
	YM3CqxMWC4w8Dbescu6PN7PKi8swtEa0wj40y1BxGNKVLIC8LIkPUUZWJl3pOr9r
	msff05iZkLAaHhIOo/2wMh+Mi3ElwpB767fs6iPJsVcbY+pkVpR16896Qo9qLPLQ
	LIJKGkfrEp6TZlYGJJAiJgKViA6HXiPSk6NUJCwbGkkO1K0X93NL5kKeVqJfXE5N
	AuX0SflMysadufZy0zdx6azcQVtGLNh09aHN5A6RuXlHGtM8wQVsqtn8Z2BJyLq9
	DazIskgVX6xE9q8CsHMjPlb9F5MaQS/je0MFrwJFHHX1EkoiK4P61wg43FFYuDTs
	rYICP8xqwmnUm0JOJGO7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920389; x=1787006789; bh=m
	HXoaFr3Xl7m0kg4SnYsmksRc4op7lmfQDtkE+LuXY4=; b=c55YAllFLUgt4HnS4
	SvDhPrbmHQ4iv3qKX0c2kkTJNECgf0+UoXVmAELh9yNotkkECH66scAHGi4xerT2
	o6+FOnt5TbdCS9n4e73bDTXeddHCiNB9AD6q4VHbo3h31k4XheCOw4aufxmg3+Sb
	Ld9ODcFi3vQxb0TLNjT6CzBkH8qieQLcjNQc3RL/ps5SQd7nLUv+p54wUGiqqyIe
	c/wJMpRKbhdblmkR7D8kqKA/djKYK1tQ9LaxXLJ+oAyXkWM1VINdja0pPfgUpyh5
	AMpRYhG5f3zTKN604St16D5mdW7QLHKuWQe31YXfmuiRujsezJ6BHWtpwoEWUOTA
	+kZ/w==
X-ME-Sender: <xms:xT2CaoRa_6WfbJ-awybMEd4thXCTC3QSoCCUv014zOzB1AzAOAeaGg>
    <xme:xT2CarFXL82Qvj4RA7I9G4g2S7sgq-Oo5yo2_mwBs1sX2Kx9OkmoasiwE4z-teRTb
    KFFgmbf4k0y951erxmUChwfF2-PeAYLjQiHw8uv_r8WOMFU1yjoNs0>
X-ME-Received: <xmr:xT2Cah5U65dmWeqYbSSRV2WnNqQVRSpNU1ZK_Z_pFyT2HVygH-UXydG0e3I>
X-ME-Proxy-Cause: dmFkZTGj1BuhETEStCjbN/L6JrGmiaqzRpeX6rRNWhHsAzwzRlY9AKzqCvfWqke6XA7GOE
    A6FFYRRSvteD9S264L5lew1YUpPhGI3TlhRe1mYLYRUsBMnidhJP2r2PMm5Lpq2ztO8wmr
    yF1ddTX1W5NBA6qs0+EDXUaWwTs6UQPsEiicZ6SmY6z0vOVnZaAe+3gsuR1dg3g0gP4peZ
    U6KBKKlAxat5APGrEFg0r1ubDi9svGZRyISInygLcwTo8cXqakBbn35auVMrKeg7PKmswS
    qkEQEJGI+h4SGQWw8a8xHcXO10CUTBpRtdxlbIKv4nbtwWiZJ1jrVLIQttQS09NS+fWjmx
    kJfkCJarA+CKWoFELrMO+xFyN9skUAkWMIJFCoZs0ww52p03xN5269uqaLdXJZhhJnw51P
    pJAiV6KgxOayjzcdbjHznmIWAtiXC/kL1MmpHj1sKlILUfzdm+nj9opRb7cSWJO6WPUn87
    TpYeNZUjHs66wSPOBwVossQcukDWjK1YuqqPDPxP05a5pGxfw/QiM8DBKJqlZMeN1rT2T7
    u3O+T/BPulsGv+glBoLmjhm4blSdkZpIliMw28KCjwtdcq1eMRy6TLLfQMjDwHcYdEoLf5
    a7Ry8XeDa8Y/LOz3sWyJsySoSKZd6miYbNeg3WRmbo3sBb9qvpeES3J9zOfQ
X-ME-Proxy: <xmx:xT2Caomn-ommuBwWXyq0UjENinUCiifQW1LnOML_svDTviZODkAZPg>
    <xmx:xT2Canys6zGcz7znJevx_4XRgA6SralREnF_SmQUSOIMdQNFNAUrPQ>
    <xmx:xT2CaiP3oJg91WWc8Gh3-SuMFPAOWeGgdGyCzzmm7w4M_ie3Kva1Aw>
    <xmx:xT2CapgAnyVr01dmyzl0nOXAFl1l1ji_zZmfgHFoQR1oa6AZtwWsTQ>
    <xmx:xT2Caq2HqLsAyaWSkrlcRWKixnzG4mLwzgVDONR4MfyN1lP3VeMa5Gkf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:28 -0400 (EDT)
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
Subject: [RFC PATCH 06/57] mm/collapse: move the smallest collapse order to collapse.h
Date: Sun, 16 Aug 2026 23:45:18 +0100
Message-ID: <20260816224609.308019-7-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CBC9FA0006
X-Rspamd-Server: rspam07
X-Stat-Signature: znjobtw8fjnhh5wpoonbummrhy88gfop
X-HE-Tag: 1786920389-303542
X-HE-Meta: U2FsdGVkX18eSbpcf7Gfgnj9XQJWQzD7mqKPbYveAEF65UZqRRtcQfaTeXKxGr0M5QED1uiHGouy5CZFac8bJ7HzLIT4IzvOFNot5g5/k7TkVau2+hTQN+6oYrDsOniY3gMpqHrRS8tWJILYRyXZ6uYcB7ZXVnX5iZCHbVOxDS4oLEI0HL/AF2Qmg9GzEBzPwCWITj4/8HTUb0f502AL7/HaluICOuvWt1tJdnBs/w2YW8CDbrvrqx+usBcU6/BezWxCE8czl4JL8ptPzmgz2K7blegS56uLiTWXS/L7nyy+JNYj19inAYnRLgJoIvFETMde5WeoEnonKlyKEnpE2fBeY2fMEb1hjlPh8tP2kPVzdA/Bkb4ei05fR2Hc2mUWtnMH9PXbIhLmesG3YknVaroVqGlAZ8tDadwp030ZAi92RuTss2M6HNdrtLtid8O0y+s9ks23EXGXz8R1wYuIoHOb3FTVXLr8a07tCtGTHuGzNj1nMe7oqODS94+PVoNbiz6C8miRBg38kJrNsm7MEcGey/0fl405MJUAdSCvCJtJA6HXb/aI8v5lxc0bHkXeeai32NSgTjBPj8iBKY7cVvh9sXwluDCicIPXOEAQF8NKO+x3EwtXEIo/xdO2nbQMyaex6gftHvA7AUXcMLATAAsvor9tfxBQyIVg6uJnpbmv2CaeIRCLWOdFPOCdbdnOD4P2xePZ8Rtd9dBYLUv+5HffyqE4pHDW8JExkCFGEGLTle+RIbsTtmtRbRo1LKHp3kSlJmzFT+zpi9+pB8v6FTZj1HuLSKiKgshgEbgB9oRa3clT9pZ6VrCQd8WNKqTtZgHq5irRZkZIlcbVWcrVm4f8uM+Wt/qFkfgTuLBgMEE9T1AFsUNZK+aYCNIdUp865ir3vfBR7rfm4FGshN49CRZOtTYDo1FUc0GFlaawmiN223GKTL5Cqr/7KywD5xoFx3fQrTg648A9EigrsiR
 SezEwPcN
 z/ioImrldmKu86oONL+XGRsaczm2z3Bku27zDvoHoMaz248dH9kX2B1GMaB05S4qn1YtkzQS7Eaq/ud5Ds80aMmcj2I25hY/kJv7QIfAj9LtSy2YM4wVUSW8XdgR2UjmDVdj42A2gEPdfrxAtvu1l6d0TMfL7CmTxC9LQ9ZLrwYzABNP58yFSmhTplwvvrDYfeP/+FrBiAfKXo+yIHCDDI7QkA1cRWgpNaeDHOsO4AbS7LAqzWL7bINJtc34W86muWI4Hc0Ne+un7+eh17zxpz/pWZqywDCyu+3rnM+SKeLxfi6j4W0BY7VBfdIKDoVRFUiQC0F1vYi1tW4bbHfOIvPtk5FIGFAew0N4jEsndWc4I13KYRicMwRIebLj7p48XOdGqsGYLMi6/Gt5PBGUIeLZWxweNZXRD5qyV+oqZsJq8H1uS+l9gXGBuuZtPDWCBSPwDGxIoS6uLzvA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The floor on the order a collapse will build is a property of collapse,
not of khugepaged.  MADV_COLLAPSE reaches the same code and is held to
the same floor.

Move KHUGEPAGED_MIN_MTHP_ORDER to the shared header as
COLLAPSE_MIN_MTHP_ORDER.  Preparation for the collapse engine, which
sizes its per-window arrays from the same floor.

No functional change intended.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   | 3 +++
 mm/khugepaged.c | 6 ++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index 44f52ea5bbb8..1e969292edcb 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -7,6 +7,9 @@
 #include <linux/pgtable.h>
 #include <linux/types.h>
 
+/* The smallest order a collapse will build, and so the finest window it cuts */
+#define COLLAPSE_MIN_MTHP_ORDER		2
+
 enum scan_result {
 	SCAN_FAIL,
 	SCAN_SUCCEED,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index eebc044a930e..f31689bf75a6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -67,8 +67,6 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
-#define KHUGEPAGED_MIN_MTHP_ORDER	2
-
 /**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
@@ -1540,8 +1538,8 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 		 * any smaller order enabled. When at the smallest order
 		 * we must always move to the next offset.
 		 */
-		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
-			(enabled_orders & GENMASK(order - 1, 0))) {
+		if (order > COLLAPSE_MIN_MTHP_ORDER &&
+		    (enabled_orders & GENMASK(order - 1, 0))) {
 			order--;
 			continue;
 		}
-- 
2.54.0


