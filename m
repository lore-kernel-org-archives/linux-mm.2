Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B8B160A2600
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=diFmkQfo
Received: by kanga.kvack.org (Postfix)
	id 8CE606B0610; Thu, 26 Nov 2026 06:22:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5E16B0611; Thu, 26 Nov 2026 06:22:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E33E6B0612; Thu, 26 Nov 2026 06:22:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 593A06B0610
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:22:13 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0086C03DB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:22:12 +0000 (UTC)
X-FDA: 85477031304.16.359DBA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2123CC0005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:22:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=diFmkQfo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692131;
	b=cDm1EinEJgBNf+cgEU9Cev4unwaWdVZWLbEMBbGQBd84OLJkFW2KygV1cdwJIrEGUq9il9
	oYPNxnve/qzyIspcRp9lmaaWgiEZDdFumz3092skpdBsA0JKM6+b1UfoI/x8gpoYiRtHMw
	xjVynGEweoJfRc+tnlXQ3Jht/nMgz6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUxcS45TVWAOQ3yj2MwWjXfOGvQz0MBdACY4dT2j47w=;
	b=WL+IBgNU6yvIuez3zciP/gTMRooBdQcHfap5g5K+tr2A2qVSGe6Yp0V8VL75FSyy/vZ1R9
	QfXTzJcTeVNookHQfjrAK1HUjD4jI/Pm4D22TLnPTzMCpssd2L/NDvUc9KNGaMPwsHdLEY
	sx+uvjHPBkzuEAUWoROIwz73P4mv/Fo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=diFmkQfo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CA7743893;
	Thu, 26 Nov 2026 11:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A771F000C4;
	Thu, 26 Nov 2026 11:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692130;
	bh=tUxcS45TVWAOQ3yj2MwWjXfOGvQz0MBdACY4dT2j47w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=diFmkQfoDg5QaKnzRhtb3dPuIfKNl0W3v2/HyhJ+bw2yp93GAHaSlIeWYzBHb/40m
	 i+ZtghuGSVyt695isWPEeoMaLeOsXG64CGjkz77ZObAMLql1JWy71PfnFBv6cXcAHP
	 fcz/yI6LnN1dX94cmS3ldnZicBUliyZTcZsAD/Zok4kH/2m9VTprVyh7kqa6YI5Cln
	 PPMegtrQjn23MEnKUCRDUCYTkntmVWGv1yGe7pI3s4ZvZXXqyimuS2nSji10j7XMoU
	 +EWnVm/T+sx6/6USLVlth9OiWz8f51m5+sw91RrDH7rROK0utXDuRj+7vNwFmAY6Bz
	 E9E2soRiU6+9A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:15:01 +0200
Subject: [PATCH RFC v2 48/54] mm/pageattr: let an architecture bracket the
 set_memory() entry points
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-48-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User:
X-Stat-Signature: 3d7o7i4ysdjiokhrumzxnmjq9juwumkr
X-Rspamd-Queue-Id: 2123CC0005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795692130-604001
X-HE-Meta: U2FsdGVkX18Z3ts/xliwErso9LG8n4RRFuq3qLPkvtPXBON0rCuXT4coq4rGA/83mvGwQdZjaMzjBQMERquNrO64l3BTQPqBikgs1f3Zgl9Al+UPcytn/KkYpjs3sLCtcMA31PpCmdV/ZeGTf+I8QMAxoHW60DsYxY+KRByV+GauzSooviY1amSMK7Qr+kV7vgdfTteSk2p01Juj7rE1Otd66VpUYu7RCRomKRS59fSX1AQw9o4VSDvFyE6z7qrZW/xZGH9QDQ/ktQeyqUDEcEWec38IUwze4h49Irl1FeRxNgHgRsBkPV2FqBtciLS0e3E5/yJthX1c2XbEDHSaGrz3GNSnD/LgiSKGbfzNasHsrz09OliWJ199IJeCq/JA3tEEyeoiUGYYkVXvWxndUlDsxhymKLbK1h0rAjsog0e/TV/LKSXAcWUDITW4qRUgWv1WysSzjSKxrlW5PUdZJF3kMgZa7WnixZ976EQCMKV0lLPdImGzfLSGDbdRDeQ9hXIr+uQvSsYvTborQotqD0ilk1sl+SJKXmQlB6FTF05ciCEwLQzxzv2fZ7XkPlthk8nRJ6bMCSwbGNw7ZH2x3yAo6J5CaAd7A/PDu5wY0R65ob94+a/W+v/hYjlILZ+sMcQc3WtCvFYJdPyvb0tZcIkUlzEP5WCmHDr70ID6/KvDqrXuephXideby9IX/OqUFDYGZTcdHwJO2RnSeKkCdR8bnudkgh9r+Zr3ZnY8P4z+uzP43OnaE6MRJRsyYA3qx11bnIZ55WT6HEAUhIVT7O2JmOXuLxu1A4EoAlEuQjTluR+dCI18ZjXR2Pz2ovaQc45iCnM4HsjU2KvBn1hUKM7NjtsDBfgILkf+7LfOBHYC1vkeENUgLvfhtWmYQ33GuKrV8Jhs6GThgZwgKcOYG9cPctITTXZBL6qoEyIcwsoWo1HScR2fPeYpSjH8uLzd/DFFZHetwA0KwZg7Lw9
 Q5All0Ew
 9MjSiqum+S154pD37zGIrNYNgBZNLD3Sp2xVjv5Hxf8A4qYCRhuikwGSOV64pNNqeoyRTqZZpPmatlLU9mWltF9ArQzccxkM8+K37aG49orfzkObnBmZVM/W+uv8cj2bMWQ/Pext7qxczepJETFm4+o0K92vScnqRHXl0N3HOxo5by9g8ZqPSZwIRX1n3uc6yvWvXhD4AVhL1Wq6EqmYQCUhyct4PRbOC4NmpvTLkWBAJZCS9y7pIui8+BLb3g01PamNDWmsXOalA8BsG0okfRMx8JQqeuqTEuIaE1NgQHigs9ho/yoxKCmVW4ojiGAd/Lw2cg1DvbYOd7PEi0gq9Qez1gm2U2yaRysWaa+SWn8AzO45Xubr0l4cw2TSGUf0Z1a2vlBoHXhb1eWbesyVRbBbvZCBOXCs+kZcVnPIvsn0Sx+1dKTxHTOJGJnDlOAa5a4PLPrbrCII8h6iXwOJ3HMT/Fffj0PtErbwLsk6UGWbiY/8lYlpgPI1wfHrYeGB1JrFiYOfHuhytzHY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

arm64 changes its kernel page tables in lazy MMU mode, so that a request
pays for one set of barriers for a range rather than one for every entry it
writes.

The core cannot enter lazy MMU mode by itself. On powerpc with the hash MMU
that disables preemption, and a CPA request may sleep.

Call arch_cpa_enter() and arch_cpa_leave() around the request of the
generic set_memory_*() and set_direct_map_*_noflush(). They do nothing by
default.

arm64 will use them to enable lazy MMU mode when it switches to the core.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/pageattr.h | 12 ++++++++++++
 mm/pageattr.c            | 12 ++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/pageattr.h b/include/linux/pageattr.h
index 1a4e7c5dca98..a2a7235a633e 100644
--- a/include/linux/pageattr.h
+++ b/include/linux/pageattr.h
@@ -171,4 +171,16 @@ static inline void cpa_init_op(struct cpa_data *cpa,
 
 int arch_cpa_prepare(struct cpa_data *cpa, enum cpa_op op);
 
+#ifndef arch_cpa_enter
+static inline void arch_cpa_enter(void)
+{
+}
+#endif
+
+#ifndef arch_cpa_leave
+static inline void arch_cpa_leave(void)
+{
+}
+#endif
+
 #endif /* _LINUX_PAGEATTR_H */
diff --git a/mm/pageattr.c b/mm/pageattr.c
index 555e55e7ecea..d8ca8fb9bdd1 100644
--- a/mm/pageattr.c
+++ b/mm/pageattr.c
@@ -615,7 +615,11 @@ static int set_memory_op(unsigned long addr, int numpages, enum cpa_op op)
 	    !(cpa.flags & CPA_REQ_SPLIT))
 		return 0;
 
-	return change_page_attr(&cpa);
+	arch_cpa_enter();
+	ret = change_page_attr(&cpa);
+	arch_cpa_leave();
+
+	return ret;
 }
 
 int set_memory_x(unsigned long addr, int numpages)
@@ -661,7 +665,11 @@ static int set_direct_map(struct page *page, unsigned int nr, enum cpa_op op)
 	 * set_direct_map_*_noflush() change only the direct map, not its
 	 * aliases.
 	 */
-	return change_page_attr_noflush(&cpa);
+	arch_cpa_enter();
+	ret = change_page_attr_noflush(&cpa);
+	arch_cpa_leave();
+
+	return ret;
 }
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)

-- 
2.53.0


