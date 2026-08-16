Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33011C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240846B088A; Sun, 16 Aug 2026 18:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217706B088B; Sun, 16 Aug 2026 18:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D2E6B088C; Sun, 16 Aug 2026 18:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3D5D6B088A
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D7151A0604
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:19 +0000 (UTC)
X-FDA: 85108620198.27.0DE2862
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf14.hostedemail.com (Postfix) with ESMTP id 52015100002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="n FwpijY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=kzT8VXqp;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920437;
	b=iPVbviEeZHylpdJQK4GQCbCvtQ388POY8jup6OZS4StAZmZeLgXDyw1v1QfPVDP3p+LTkY
	PBYQj+znSLCbKmQuUYDVJnuA/WMTGUPycayNwur1Y7PwvhHCtq3j+xi8Kh0k3DUdGUsmV0
	lq2GaVYwhq+0oBrso+cP1ec0X6PKLNo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="n FwpijY";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=kzT8VXqp;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j0njKa/sU97UuU9BC7LS/teFWmvcsdJR3szFnz2Zzu0=;
	b=V9iF2pUJEe/88Wh1T+1h3AEcm0eaxQgHLLt7FuysgDplGY0e1g1bwGRK12yq8P6DOJteGj
	xF1ab729urwgtCV8ANktry+11CCYNfG3NxCGkvLupKivm8qClh3pdgDhKixb0CurP4Vcty
	7isu/QI5JZ+j9JOGyE2cbh4F7AmYa2I=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D792414000F8;
	Sun, 16 Aug 2026 18:47:16 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Sun, 16 Aug 2026 18:47:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920436; x=
	1787006836; bh=j0njKa/sU97UuU9BC7LS/teFWmvcsdJR3szFnz2Zzu0=; b=n
	FwpijY7TTDo0MOviKSKnc53xYc9LVC2yNmby+rLfbuoxdBpQG/3VfPzA5ScaZeQk
	VJBprsmLnSS9QYbRHPPzoMg7QYsT+NyU/2WTHigZ6gqh7N5H0aRa+obNo5lMnz9+
	LIUDzFyF/ZjCZErzr6zVwQ1Bqrn2IKjWUutXndjWljG5vv3jDQQftjn0QIoD64xC
	2f3eqT0rHMRdKWY2omcSMPpKCKRv08oyTTG89ScCptgCjx1VNjOa5VqeDkOPl38C
	cUpqL5oI7MPT6jutBz2ks6pLq9EAP+cGTQHvOQC0TApQdjIbK8mUwp1tIg001iOI
	S0IJE7xr9gVjevZ4YO4uA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920436; x=1787006836; bh=j
	0njKa/sU97UuU9BC7LS/teFWmvcsdJR3szFnz2Zzu0=; b=kzT8VXqpML+W8GnWr
	QIdRiSkVJ/ZiLN2FHS7sFEVJfNIkVJg351UzPogM2LODLj3cfPmCV2O9dlYdokxr
	umwrk5AyQHqeMU7FJZzpfG6+TZuCyKnYVn3KOU6almFI5JnAvIrL+MV99NFSX5SW
	BtosKOzNt3bvMBShA6ykTWrhsT0qdk38rzrhAHFBCDBJL/gjhrbFym1ENyCWWliM
	zZmoMQCjlY9/SJJOUQperbWC6Je6wJBw+2Dfw1mNkNjIR06KkwiROJR3rtRq3F5/
	zbmaOWTlngBrg331nR1ETZ1AKbvzjLjbaWWCILyxzYcPsjs4w8vqyype7S48NZtx
	Y5b1Q==
X-ME-Sender: <xms:9D2Cao6T5Am1e-r5CD0avxfP5709yrBmlLEORGHXdGmAIC39KeJx7Q>
    <xme:9D2CavOcP4jGWAHUNEcMvIego9GeLyH2Wk3_s1cXQKLobntMaDZ5UV67XMxRhlexi
    Hxl7qJW8likbxSG6ag_v-5yHAUOBItXmZS4iyJw6GpdXbTfahOmV-8D>
X-ME-Received: <xmr:9D2Cajgd6vC6RFnaGmhCQBGP17PPITMPDvGVHdwBty4dSVubsGVqrW-7L80>
X-ME-Proxy-Cause: dmFkZTFX8QZ1Abcp//ElmtP0wYUsUMnb+KjPA544aOlJXhXcQAudkXa81C9Rj4L11ediC/
    SYpDnD1LvcyFEAv2YFQNL3ReIx6t28G7cFOXvsWQqNdQRv24cIelnnbcWrHqur16sY2q+b
    PHK84xbhjrx0R6ZFbdj3lDcQr+wbYteZ9PHsSvZgjQoovnxRkTlpJXxI+K+aK0DY9MqaWr
    nM0jSjvJAOtmNeFdTIuI9VxKMOFqeJI9DUUNBafqnTlsaU2K5w1xy/oDJpRmozGKRfcEpJ
    T4FDpTcqBKNo58tTW6I4nVl91YkYNyFfziYdH6IV5aj62MGBqsSUtSYZnaDODTOndFzTD5
    ylGlg2zq7m16jfM5uHJgPlIYbMxnPsaFzwmzt7lRLFaMXcTaKz54PlFbIvjMQOW6UMRTdo
    qJTi5mkLOtGPpWwYdcJg3eekaqRuyFT/TOyP3TJ0aR58vKWg9nB3VYpnFoaCeuEyCZDDvw
    1qnFPw7SZrPjoeir7CLHWxY6h3tVea27Z8Lz3Tztdek1L3AyXroPtcmRBi7gaOu/mMWaiG
    rWJ7/Akg0ggNjjzmQJ916tdv+9CwLGhh6B0ikeVXChonVeoq7RofIRBCPlDV8zcgCVXDWt
    nLtTsuB2Kqk3/b5bDoi4k+l6PtTz8vhwuFM3WW6Bwr3j7x1JzGPB+AxSWHrg
X-ME-Proxy: <xmx:9D2CapujG0eb3guYgTN0rUcgfdYrtbP7M1C2IyVqEfJk4AK6_R5Mpg>
    <xmx:9D2CaiYsB1iNLiiYVHWmUOe3GE9Qc42J1jvBVhp6rRcUeRFfx8nOaw>
    <xmx:9D2CaoUOwaM1cqyfUTQlZ0Ov3O0XdM8OS0SXWww0LlS2ShvswIXv6g>
    <xmx:9D2CalIBo0GVTkOiwUPSyb6LqXojuXSGUrcbPgbTltcL5pjE75c8CQ>
    <xmx:9D2Cai9S2yg3REmeiq1hjM5akrxYFYgRDzntBVAlYzqDtQ8kirDAfWtd>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:16 -0400 (EDT)
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
Subject: [RFC PATCH 31/57] mm/khugepaged: count collapses where khugepaged makes them
Date: Sun, 16 Aug 2026 23:45:43 +0100
Message-ID: <20260816224609.308019-32-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 52015100002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: q6pccimzjr7xthorgigwugxkd4ut9i4f
X-HE-Tag: 1786920437-978630
X-HE-Meta: U2FsdGVkX18kmpvEdnN1RoIaTbV5cPaH70pzChZlo2xIFoNrPuhEMno5MFmoIuuwTkJNIHABDokUJmXgHD/pEwYaN0Rq7W+77bOwjDss/eQwA7pVbhNcpLzWQ7yjXqZ+XM4xNlwgsP8S2+UMkrcstLiDHcVLV9z4WUdEf+shE7T7VF9Gw2NhzUtIL6A7ODiyE+u7NRNbbVYP+hNJFNwXCS5PxFqdFZ9o1IjKk7n7DZjBFKoZfos6+Fq7evqupOEv5LG13khv132gpZDVCH0RQCc5nzVCUi9tEVquvXxUqmBhU3qeelspFWfy5B9olS7cyP3/r5eSs7MPyEo2JmUkmER5zITAe9xolbwXGB72sYeU011MjzQEMCJKEMjVVZqWZ1zlVMgCxwSVoM/LbM8a/0Xxg7rdGrBtlEiPvN5TTZ+dHuQ+Si+PSjLXkBWzCR3C7meI/wYEGmyMuTV3jBRl6AZWzIS+yxAe16kdVyy62UoYHI+Qgs6onq65xRJdC83kYLTAl5Z+xhwpkdWfjwdg/zW+0gT1Fg0RrL6/NQCuEuubp+65TgNaYbBLSYbL2rkc6/XVQosrKuw+M28w08VWNjuEtcZfWGf9sOiuj4VbhmxkrdplQ6sea8zQIpdIN8R4rnPMXKFSXEhKRhy7JP6dyanXeb1Xqw++mY/rHqFUWpjkw2sD0GT6A2TpvxXYw+Q5RwoGZ1US0KILYaH++VptuKdFBoZBsvxpLB9dYANoXS+kBnIipfKRB1CHGehQ2qAFsf9hNzQpKKqayOK1fq44JpggBGHI6xv2Hp/qPXbyLy7GqbWEzNHqJI6BAE8SVAirjpFt1G1llTLuGpathHB2abDiFuHlvOr0SPCnvzI6+KuQEdAhcq+4USDdDG5NrsLX0C0/JiU+2WIILXhlWaKCMlv1OsLNxIbokRz7vrFeww4tPryFNVw5m2JUKoyylonPJDzDnRQAwYpH4sXADLn
 H28yb2nz
 8PsKC4f4mfWSF3s9jUaVMXyklgwmli/gy0WRDtrr6r1oWeBTUQEM4CFwySIKrlqNzXg12Buz9EwXXyOVt/r3YE6ljVJXNi4cCsE+dapCPACML6GlL5a/C2pZ2wfQ2g3kOaOcxeBtr12MPMLGsk0ZDeZGaet+kUqTDCnN5W7LJDCli71U42W6UjwpOYzDjIXK5Lyzn4y8VO/5gf6YK8qoiKHAkdErVzG1IF/98qFJ6IBh8DtLYnfCamJByNelZF0oXDBFHa6lEuwyO0R8BHZWtfeheu70uXwnk8ABhQ8C0pUzBdN4PEBvwGDXXHYKxeUynqddM4tJjCSJiEHSxxD7ThCZj2ejljjeP1OvKwKNA29v+Mn7UuzAoPXfCTve+3M3k2N+lxKTMPZkqmeGgqPHMStwgI4Si6t6kUBXg0CwWTNbkQTvZKy16DEilVp8S1wX4zBmrdVNRsSShBGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, and
tests cc->is_khugepaged to know whether it should: the counter belongs to
the daemon, and MADV_COLLAPSE must not touch it.  So the one thing the
shared path still asks about its caller is bookkeeping, not policy.

Count in khugepaged's own walk instead, at the call it already makes.  The
question goes away, and cc->is_khugepaged with it -- nothing else read it.
current_is_khugepaged() is a different test, on the task rather than on
the request.

Preparation for moving the dispatcher into collapse.c, from where a static
in khugepaged.c is out of reach.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   | 2 --
 mm/khugepaged.c | 9 +++------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index 94c11051f06a..11f51c6ea444 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -114,8 +114,6 @@ struct collapse_policy {
 struct collapse_control {
 	struct collapse_policy policy;
 
-	bool is_khugepaged;
-
 	/* Num pages scanned per node */
 	u32 node_load[MAX_NUMNODES];
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8c770e251c22..907ed1131460 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -458,9 +458,7 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-static struct collapse_control khugepaged_collapse_control = {
-	.is_khugepaged = true,
-};
+static struct collapse_control khugepaged_collapse_control;
 
 #define khugepaged_defrag()					\
 	(transparent_hugepage_flags &				\
@@ -1639,8 +1637,6 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 		mmap_read_unlock(mm);
 	}
 end:
-	if (cc->is_khugepaged && result == SCAN_SUCCEED)
-		++khugepaged_pages_collapsed;
 	return result;
 }
 
@@ -1731,6 +1727,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			*result = collapse_single_pmd(khugepaged_scan.address,
 						      range_end, vma,
 						      &lock_dropped, cc);
+			if (*result == SCAN_SUCCEED)
+				++khugepaged_pages_collapsed;
 			/* move to next address */
 			khugepaged_scan.address = range_end;
 			if (lock_dropped)
@@ -2039,7 +2037,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
-	cc->is_khugepaged = false;
 	collapse_policy_forced(&cc->policy);
 	cc->progress = 0;
 	err = collapse_control_init(cc);
-- 
2.54.0


