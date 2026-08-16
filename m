Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1777C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79F16B08AD; Sun, 16 Aug 2026 18:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51C06B08AF; Sun, 16 Aug 2026 18:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B400A6B08B0; Sun, 16 Aug 2026 18:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EF256B08AD
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB3D2A2FEA
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:50 +0000 (UTC)
X-FDA: 85108621500.18.765F24E
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0156B20004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R /D9hrJ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=cMcHegD+;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RDFiXs9UFefjDWAntFW6mYoilxTkA+zz17UfIDflfSQ=;
	b=aDRn6TATUI0ThY3hmVjVSUgpv8sUXSOi6CkJf8NHuqCSwUNS/ZaTty5QtaftXBaI7Mbq+7
	kteEU78PgDg88YwpZaQ9QtubF8KcoX5BzGsFU9UmNcbtTxJOxq4xRW1kZSXzIE8mOGGRIY
	v3t6O9Xsc4yiIM60b5MmVgApag+yd28=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R /D9hrJ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=cMcHegD+;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920469;
	b=jNMmSWgBGpJuy3Z1S4IscWSsTI/DhPbpuF3UVswNyfzHREgWV+XEvVgec7H4ECGmH7+cho
	Furi5oW76om0/dEICnRGqZNjho44Lt/lHrS+34CKVU9KbYmOgM2G33h0nLq9ALjVLWhjXm
	2G/D87QGjdPSLx6n3saMN0uwC/E+2fw=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 918E714000FE;
	Sun, 16 Aug 2026 18:47:48 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Sun, 16 Aug 2026 18:47:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920468; x=
	1787006868; bh=RDFiXs9UFefjDWAntFW6mYoilxTkA+zz17UfIDflfSQ=; b=R
	/D9hrJ/A6K3alQkubIQewlCsyxKk99E71DYl22d+XE0UTS8oqhOmPEXALqrmtPT+
	fhuQgCJdw2MUES2F9umkeZgwgY7Q+WO2UprI3k8gGgT9QVoKAYH0w2Yrx3UOpMRK
	T0EH6CMchU5fZMIz+NZ7j8tTZ0ons48Jar8nhm4n4gHQPLkgbj6fAW6o25vFywcN
	f7ZtVUKrem5+kj6u9Jezo+JKRRKvfGWl1AtB9D598iwPDoetjHIJBonwWcHev36V
	fpQ2h5896OHtH4/c0B1nLJ+qk+2/ePN4qBAyPZqaVs1L0VusKect+tsF/9Topjf5
	cYlwFEB4mSG/xDuea4zLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920468; x=1787006868; bh=R
	DFiXs9UFefjDWAntFW6mYoilxTkA+zz17UfIDflfSQ=; b=cMcHegD+siSteXceA
	eORchYYJpRg5mkjZpTJ4wtDQd1qhM4icwlRxaOng9Siw3K5cRYYAp7ay9pM9UbSi
	Crhn6tlhUd9aPwxLjlsga0sRqVLTa65D6RmWWVm0Z1/+jSLfVsxsGUFqZDtsD3da
	VwPhwjZqGp4gyFSzD4nBVo39qToJWxBQlF52iv/0BRsc4m+s5VJF9th88pwnxahQ
	zmSTYQb6PCLMAAiX1c1BLtjdxHH943hWM85tvUwHXmJNmBX3SXis9thMwQiemlzn
	VFWqoNl1GjEteU5c4kuGSgUd1IXh7wV2yHsqdNjtc6VrqiO92KGGjP8LSgVjdJT3
	3cy8A==
X-ME-Sender: <xms:FD6Caij5zk7EHpJYk0SEVw8nfTitQEEu943h-uXF36WJ-orjngfDXw>
    <xme:FD6CaoU7Ta24wJTMCQqNgdekAeNJJhvn77pjj6-pJD3HyDu4ao6fcLt0ktvzm9gwD
    VxNGk0LL5lCDQiMmp1q35P8SAnkeAtm7STFPtRlp6v2tju2s1cGw58>
X-ME-Received: <xmr:FD6CamLNxb6VLNY6dmwcc0n63rIkmfjVHsD-n-qava3lM2QLm4vFk2T0lmY>
X-ME-Proxy-Cause: dmFkZTFX8QZ1Abcp//ElmtP0wYUsUMnb+KjPA544aOlJXhXcQAudkXa81C9Rj4L11ediC/
    SYpDnD1LvcyFEAv2YFQNL3ReIx6t28G7cFOXvsWQqNdQRv24cIelnnbcWrHqur16sY2q+b
    PHK84xbhjrx0R6ZFbdj3lDcQr+wbYteZ9PHsSvZgjQoovnxRkTlpJXxI+K+aK0DY9MqaWr
    nM0jSjvJAOtmNeFdTIuI9VxKMOFqeJI9DUUNBafqnTlsaU2K5w1xy/oDJpRmozGKRfcEpJ
    T4FDpTcqBKNo58tTW6I4nVl91YkYNyFfziYdH6IV5aj62MGBqsSUtSYZnaDODTOndFzTlc
    EbUeQzhKxJEmsRwlRPWupCudTuURb990558e34xXePZqhKsdittFqFVB13AvKNBPn+zTIC
    vmM4mIxGpPzx/nK894dSAKdZpvpkCU2McTpnHaRUIk0aWa95Ge9rfXUXULEztRAndnCYbt
    4qD7P3eAyIA5OFPCP2oHhYFpAkBT0mo15kPYR7H5/b3GrpRM2b7kXKyktWAQ4dA2U9USmE
    fM3n0gonMJM6KinITZmpApKtfVndLpnhEgoZeb0eJJWbRvyWRI94p3CA2ZvaB1HejNnPzR
    Unmc2v7FvenSNzXmIHyeuDNm+B0nonswhiJxC0bKiq5ZtPtGImr9bjx9A2Bw
X-ME-Proxy: <xmx:FD6Can1hoyC6PmwnR3KJ4dbo6AaCtxi4W6oWnQ3-zNUMuqfvESwEww>
    <xmx:FD6CamARxPMeY605qB94pGmuSHRBTI814URQxpldxXLXdEAlV-iRxg>
    <xmx:FD6CajfEmEZ_BSxer4SMt38i9c-XlD2tG1D68WIaL60-b1zGoTyJBA>
    <xmx:FD6CahxK0UCDvcRAJW9wRSf3H34UNiXlP6VB0qkJ-OWmeTGneOr14A>
    <xmx:FD6CagGoFvpkcKSU7TANtFqL-or-_aq0-dmKR8_hl6WToLkaPkCRXok_>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:47 -0400 (EDT)
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
Subject: [RFC PATCH 49/57] mm/khugepaged: drop the mmap_lock barrier from __khugepaged_exit()
Date: Sun, 16 Aug 2026 23:46:01 +0100
Message-ID: <20260816224609.308019-50-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6p1arom476x7ezby37aye4ed6mmo1o8n
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0156B20004
X-HE-Tag: 1786920468-350370
X-HE-Meta: U2FsdGVkX1/lfPts7lcIbvY6VeaIdiZfmYh5U/aiF+YW5yX7RJ1MmlDcRvbDypt3b4dmWx3z2Q8PDxiLkpiUHBf+kIVyZGlu+zrFk4nwpIl6mIoM4ZLUy93wg+YZPO8jyY3in5Iru+u6pxnD/u/O/hZZdHRo5I1au4QJJMMfepUvtVjilY4MxR61IuU4ybmSsFx+T8ye0f0bAaRIIBGSkW66FS09+QDEcJzhv0n6jRdd2bwN7B/hG6Oxv2ram9rx5I5BiFZgh7XucOT/j3PrLt6weJ9PxHxgIOCntdDisMtZwIc9oM6Apxk2lkcqnrD8VackByCQDueSz/ckbrpIL84chN76+WLl/11EPVovywCgZyQ7F1CsaUfuCrUbLXNwe8beLn1vyZ0SehISuraFfPtwm0N7Gsk3kLNjWLPEi0ZqMvmi8QeZZbyPOWAQxMPY+8Fx/SbOUKIggZQZQRjXwA5/IvLocERNJEboHF+KIjGWNwQX5uKQJ5GWeS6rYJXhMMyHvXTEArg8+0Y39c7z6p9j22OwM8kjc3iy3xRB2f0XplPxMjr/Ft5VKpzC4VD3xGVt6saiiUO+aFOMazjXqwJxF8s31QkpVfNj0h8PWJjTJ+RpelabKIBZcka523xs4dWBHexpYPopCAbc0MW1wWxUaZi8nrvSe20EKQMJjL7Ju/1a9k5yMMBFeGEEQlyB27W7WkfOiUdUO4IIDnLvhcYRobbGc82DdSKpMu5D/QHDXQ0GC5Wp3DI7CM32xK9CB+KyAeDoPitJXeFyeYhKBE5kebmG0Vk1bMscuDgf+pF9Qkq+L7C6LPu2l7YgDIZKvkcx29CdlEi68aWxCVhocYwFBN+wBAhNRNxPTEPzVhYnUVT8Mgpk9CNStX6jaFp+WyOZzCm02PMQV5CU1HOW/U8mNaYtPaCIMBBRHBn1NoDqyrr1GRzGsMliKnkfKP5mDAAoXOMdaOuysnuaq9m
 fpFgiIQV
 PLYCoZf59rLHtPjr6kWrJ9HvHo+SX88L7uhPWlPiEIZ+5I0/M/xjNbhNM2X3JF/GcfVz8JDU3iXFRD46Bi/8lI6GMAzUDs631Z1c4KLPF0FEoXZw4XpmBLBa+mJxAgsV/I7SFk6SNbK1kIDm7Y7jp5V7RZtKSJtOiYGW6Dcz0YdJVq8IvDJXXKvt9RroaG443JEaOzXNZh8naSXvZ66lrdcPtt7aigncoYQjEJ6I7fC37G0s8OIsNzCitC9HH0/OKBHWLcMZ5hioqlOu/znuBHybdxlsEL8slKIHwV0CIdMbdDsKDfjW3zBeIdoU2wQabV8CQuGIoNOkVl8QJcXO7o+eLMLSKFS4yrXfScRFqGi6ULz1vGmWnnzByqySK/delfwcG5l64C33jQpwP5U2k7Qum0zWpPH0RtiOVjO1Ta+986Pkkw+n1Z+Ok4yYeuZGxm8ijXeHM3QJkuFC2INT+24MQATt2kmthkHjFRC7JEsbu1ZxKpn4ofTLgWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

__khugepaged_exit() took mmap_lock for writing and dropped it again, to
wait for a scan holding it for reading before exit_mmap() destroyed the
page tables underneath it.

A scan now holds a reference on mm_users for as long as it runs, so it
cannot be in flight here at all: __mmput() runs only once that count has
reached zero, and asserts so on entry.  The barrier is redundant.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1d77d9a8046d..2b3364bdb100 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -434,16 +434,6 @@ void __khugepaged_exit(struct mm_struct *mm)
 		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
 		mm_slot_free(mm_slot_cache, slot);
 		mmdrop(mm);
-	} else if (slot) {
-		/*
-		 * This is required to serialize against
-		 * collapse_test_exit() (which is guaranteed to run
-		 * under mmap_lock read mode). Stop here (after we return all
-		 * pagetables will be destroyed) until khugepaged has finished
-		 * working on the pagetables under the mmap_lock.
-		 */
-		mmap_write_lock(mm);
-		mmap_write_unlock(mm);
 	}
 }
 
-- 
2.54.0


