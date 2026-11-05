Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA53606D82C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=qDQSqMce;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oc1v99b/;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=qDQSqMce;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oc1v99b/
Received: by kanga.kvack.org (Postfix)
	id 7838F6B05C5; Thu,  5 Nov 2026 12:01:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75AC86B05C6; Thu,  5 Nov 2026 12:01:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622F36B05C7; Thu,  5 Nov 2026 12:01:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3806E6B05C5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:01:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B336120B00
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:04 +0000 (UTC)
X-FDA: 85401680448.08.87C2522
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8416F40016
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qDQSqMce;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="oc1v99b/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qDQSqMce;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="oc1v99b/";
	spf=pass (imf12.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTLCeN5jovvTBrG00oVZHmkRkUI0TUXDkV2kppClmaI=;
	b=aRb2g9KBzvYoRqwLVxSXsPijAw8jCgXA75iHvMprYfTZDLdMkgnC+SjAgzHDGmblS+A8Hq
	kGJdmAubnHdOiOqbQivzA/GSc0PMn/asPbM1FTTOTDQ+mQmRI3FmISC6tlr9+Hj3xbJJoF
	i0SHhBuq4MHcaO10uG9sGSEltXcPyTo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898062;
	b=yL8s1aRCDuugQltYy+17+7qusUQW4EiGqdzPxYK3W0jXBhWwc5qvu/Zcy/3WBbnnJ9Co2G
	+Ch3NtE+GUZXwINF8f4ClIk+B8vnY9vy9UZMMCBzi/2uhiQkNDPwADKEfwi85j63V9AJzv
	4kiXYd4JGNHAeZC3fpyStAbE5oL7Ns8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qDQSqMce;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="oc1v99b/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qDQSqMce;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="oc1v99b/";
	spf=pass (imf12.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4C63C202C6;
	Thu,  5 Nov 2026 17:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yTLCeN5jovvTBrG00oVZHmkRkUI0TUXDkV2kppClmaI=;
	b=qDQSqMcecgH0WXSk2Y240aQ1q68bCPZg+2Qse3YSTomNRPbmJ43/iO8LLK65XIw2Yuie8a
	aenffLtwlLO7coIupW7h0qzIUhGSlqfr9FXRoLGzyez21rEI7jLGfNEFGZsLegaQSo8jJA
	9VrV5WCcb0LrE1YWl6IUGwMUTZL2Gns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yTLCeN5jovvTBrG00oVZHmkRkUI0TUXDkV2kppClmaI=;
	b=oc1v99b/QcPAkScAs/xHlP0u67nIQGuCXV0P05kIB1+DDvNcWAVKTaS5tSV8uxTcV73Cw+
	KPwlc+NFP/MpB5BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yTLCeN5jovvTBrG00oVZHmkRkUI0TUXDkV2kppClmaI=;
	b=qDQSqMcecgH0WXSk2Y240aQ1q68bCPZg+2Qse3YSTomNRPbmJ43/iO8LLK65XIw2Yuie8a
	aenffLtwlLO7coIupW7h0qzIUhGSlqfr9FXRoLGzyez21rEI7jLGfNEFGZsLegaQSo8jJA
	9VrV5WCcb0LrE1YWl6IUGwMUTZL2Gns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yTLCeN5jovvTBrG00oVZHmkRkUI0TUXDkV2kppClmaI=;
	b=oc1v99b/QcPAkScAs/xHlP0u67nIQGuCXV0P05kIB1+DDvNcWAVKTaS5tSV8uxTcV73Cw+
	KPwlc+NFP/MpB5BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E4417133F6;
	Thu,  5 Nov 2026 17:00:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HMEkC0K27GqWRwAAD6G6ig:T7
	(envelope-from <clopez@suse.de>); Thu, 05 Nov 2026 17:00:59 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	peterx@redhat.com,
	ljs@kernel.org,
	imbrenda@linux.ibm.com,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v2 6/9] mm/mmu_notifier: add MMU_NOTIFIER_RANGE_PERM_UPGRADE
Date: Thu,  5 Nov 2026 17:50:03 +0100
Message-ID: <20261105165004.2663799-10-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261105165004.2663799-4-clopez@suse.de>
References: <20261105165004.2663799-4-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -12.30
X-Rspamd-Server: rspam06
X-Stat-Signature: 3fz38io85jgtzi9tt3xjx1xgx1qo3ydn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8416F40016
X-Rspam-User: 
X-HE-Tag: 1793898062-66927
X-HE-Meta: U2FsdGVkX188z2qjj1CiUIIg3rIgaRhTNpZiPefJey49fKq3Qxyg7PNiWNxuxWqPo/YRlWKIeLksOYCJZOw+QWaKhMzDfsUnkGC1ptxaQLyPK+jnNEb3rKYzKDcZrKyt0ZxKB8u7+ix7csQC0uRmzoRQDp92dtvjgwryYQwAHI3X+XB4G6MqIClAOE/P51KY2LzstlIHnC9z3Bh3Fw7xL1EqAvyGRZ137MyBdmHhHu1BSx81bDAgFKDA2GHtk+BCSJBo9/ME5X+yflGW1Tv/b0BtdCRtm72PYolDN/Q+n70ZBiYBUHRBiAf3WSTdKwWY5BGvNDoC0MFwiYhFdrYLUNVKwRfaX9Kfi+3smBwwBvDzsk8MwaPlWfrERr/VNbj16yiAYNSxkdQNe2MBYcqaEP5vexTeiwegOHWOVXxbJJVSwmrdFNma7zLORnl504dAARU5DUD6AVKO6qPycmCI4ZYPuIfdwRxpOA8ETcom20mMFQNJHI7XY7QPt83tISh6XRoO8VEzgPew+/L56b9zlFrC13q/3p6T0AWxeu43m5E0o7OiuXSSQITBiixFgXK5eS0WQfGIP7qqf0On1qJMT3wEZY5I/HLjVTG/YiSifnovY5bENWW1YniyVRgX7I3aPNYRKHGpJyABnI7oiaPFv5hSgK298Gq6Zs+EGhavKsN8NZPjuP1QUFMS3ZMjbCzTzKHp6JZjJciu8lfIXGllHXvRlsU61dF6NJjbFF+jXhUymGVJY9B6Wa/4VTd/ssl5+NpS6z7x8Y1Q58Iq5WuC3C9LZM/oBb7SFMhtWcCK9SJOk5dDVIKlcdSFWhTBw6Twv615Bj2MenTxlhlj3QY1lAZo4XBBAb9hd2L6qgTaGHOcqMDkMkpiEphRlZqpxDYj0CrAHH4Qth7bkMuLLEvz3mUiK7tve9D+srwDbDIoXVXODGCpUTPYYytu/FJSkt3hpMFll6aBUfNXUeO3mEH
 vSKtAjLe
 6Xx/6Cxy1BIB+iAKT87ZF04RNZYEt7Ij0mlYtrVQUksUKm9njug0LIeo6lQ8j2yfS6uhb1UV4WPVYvCoQQ8c8gUpym1aQDRuATgAvDlE4e6Cc/4CXOsVdS1YuDLf8pRa9MXfGKCrxiZHuhuS2jjoGLy8McAUYs8k/qEz466SOEg1ozSwT9XmDj3+aihvBR56d+ni8D4an4QEWAOqrk6tNG2fC+7M1R43ppecgFKLi/mX2/riGSVZHSYk44xP+UroGuZLLBjQBjclxbblsc9TQSDOYQVGlMEtkoTjEqXOn7XVTO2czqHwytG+c9zrKLTWCWpkX21Sh6JcYaj40mOi4vf8+y+5qiN2VbefGm39m+1CvS0doq7oi6WfjSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a range flag marking an invalidation that only upgrades permissions,
with no PFN change and no revoked access. change_protection() sets it
for MM_CP_PERM_UPGRADE and for the userfaultfd resolves, which unprotect
a page and thus only restore access.

Now that change_protection() keeps writable entries writable on these
changes, no present entry loses access. Writable migration and
device-private entries are still made read-only, which does not affect
secondary MMUs. Migration entries are only installed after secondary
MMUs are invalidated, and device-private pages are migrated back, with
an invalidation, before the CPU can access them.

hugetlb_change_protection() never sets the flag, as hugetlb does not
restore the write bit and may unshare page tables.

A secondary MMU can use the flag to keep its mappings rather than zap
them. Consumers that ignore it are unaffected.

Signed-off-by: Carlos López <clopez@suse.de>
---
 include/linux/mmu_notifier.h | 5 +++++
 mm/hugetlb.c                 | 4 ++++
 mm/mprotect.c                | 5 +++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index a11a44eef521..112be28cdf6b 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -60,6 +60,11 @@ enum mmu_notifier_event {
 };
 
 #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
+/*
+ * Set on an invalidation that only expands permissions without
+ * revoking any existing access, nor freeing/moving the underlying page.
+ */
+#define MMU_NOTIFIER_RANGE_PERM_UPGRADE (1 << 1)
 
 struct mmu_notifier_ops {
 	/*
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da5d04edf7c1..1a69d1da527e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6606,6 +6606,10 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 	 * In the case of shared PMDs, the area to flush could be beyond
 	 * start/end.  Set range.start/range.end to cover the maximum possible
 	 * range if PMD sharing is possible.
+	 *
+	 * MMU_NOTIFIER_RANGE_PERM_UPGRADE is never set here. hugetlb does not
+	 * restore the write bit, and huge_pmd_unshare() may drop the mapping,
+	 * so this is not a strict permission upgrade.
 	 */
 	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA,
 				0, mm, start, end);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 16b8aef755ab..fb2023dc6e66 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -601,8 +601,9 @@ static inline long change_pud_range(struct mmu_gather *tlb,
 			continue;
 
 		if (!range.start) {
-			mmu_notifier_range_init(&range,
-						MMU_NOTIFY_PROTECTION_VMA, 0,
+			mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA,
+						mm_cp_is_perm_upgrade(cp_flags) ?
+						MMU_NOTIFIER_RANGE_PERM_UPGRADE : 0,
 						vma->vm_mm, addr, end);
 			mmu_notifier_invalidate_range_start(&range);
 		}
-- 
2.51.0


