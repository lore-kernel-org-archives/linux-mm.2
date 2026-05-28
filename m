Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E604CD6E45
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8E1F6B0096; Wed, 27 May 2026 20:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17386B0098; Wed, 27 May 2026 20:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B42BF6B0099; Wed, 27 May 2026 20:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3F36B0096
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8EC781C185B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:26 +0000 (UTC)
X-FDA: 84814977492.27.E94E9FF
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id CC5F420008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=NGmJL0OO;
	spf=pass (imf31.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928944; a=rsa-sha256;
	cv=none;
	b=qYhCoki3QFgsvkerirzgmxiYvvnV8EdfmsaeJE8uodapaF8wmcMXphRE0xcr74IZ2AOB8b
	doXwPC0jv9FG6mWeUrCgy0502lLQHmil+/V8fGhwydcR1vr5UEoU15rF9pk2oKIOqi/irw
	rlJivqHfZK78rX3lRhnKm2FhBA0zuJ0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=NGmJL0OO;
	spf=pass (imf31.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5nYKaNCeQT/DwcqeJQWCXYpZxCRsHAKcumYY0kdCcM=;
	b=DwwDdQjmS2AuhqqRgv80Lg5+Tsg78Ugck777MNO76T037cVxfL31U+GNCQb2/u4sQ/9Imy
	09E4V40np8ehM4ssHHd0OPs8daOoFEQWtWcONGrpLdR5HVG2qJBr0aYRAcTnwn56Md3PcD
	U8CtsynaRM9JQsabarEz3wEGLps6mAc=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 335A720B716F; Wed, 27 May 2026 17:42:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 335A720B716F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928933;
	bh=e5nYKaNCeQT/DwcqeJQWCXYpZxCRsHAKcumYY0kdCcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGmJL0OOZYP1NkGpncUVpqTRJll4ru23eY1btx1XhLvHqa5M9SYbNxXmXfey14qR4
	 TG6z/YMZg58z8hGpSdNlfnhM/0uqZxNjplYYGLtmIyiyYu7u8ARPtRnUG4Uaz/N/+7
	 NzTZxFKs7QTuzbMyG6zva5le+BF9QEX2AmSqkUug=
From: Jork Loeser <jloeser@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Kelley <mhklinux@outlook.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Subject: [RFC PATCH 04/20] kho: add callback for table pages
Date: Wed, 27 May 2026 17:41:46 -0700
Message-ID: <20260528004204.1484584-5-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CC5F420008
X-Stat-Signature: x5oht8n54i7owz4peogm8bcn1di4ar8j
X-HE-Tag: 1779928944-185251
X-HE-Meta: U2FsdGVkX180SdMyO016qD7/+AFre8tzCO8y5AP+EnWBETrmpQHSYlTA4P5r4QOhqOAFHmfb8Lt6Wi3VEw0rxuD2p/9K4Hs54QtzakGpkzkWS0y7gDATqntBLizVfi9k7AJmJlxKfygbGQu9NAMDJBjLgqwN3esGlJnNBG/EnewqKAHYpJXB3C1OZEouQyCEEO32TGzkIonLgcmN0vfpIIU0uddzEV4gtAU1eMk8JW/KmAaTUZ+iPEIGCSvCBm1iL1nRZ44NqYm4En0VZVboZ/pYD5Jf8hZ5O+i15kSY5ffLNnd9sVwotdmrpeuh1wFLTeNDBb5dIJ4c3UMqVKzM4jKUjsT27wYNyt10Ggk26CpWui9Mvw0ANhpDs2rxMd0BxEu9OEHBpMSge/MfKE77bY5BEcPArzGuaZmjuL+NkLIghSBxSxDAnj6fq7PjZodYA+GDjRn2eZznphLG09KDaqDnF6eMjjQi28+9BKWUIV/wMpAclw049rrIFU6Rdfcvq7GLEyYjrIo4nZSkCujH173ysd+qeer0JzGcDlZTZroAAIyHAV+Xg+y+cq/fmaJzrs6pEmDFV+u559pJ9ckIhLNv18roEDOK0ZmsXck1gpVTcoVeUkHILmpIj0i7TimQinn+4AP4CfIQ2By4nSdQdyXnCymHAXszWkXcgxJkY4uOgdTX+vBBfCVQTD8cG/mYy6D0NoSJvGh20itBg4iNXjDKsZiVeeE0WQt6++eDJIpn1LdHGctt71c+ODHgJbPI4fmptoG9BzCZeeh8/5K59u76n+IWD5O7QDLRx78gR1Z0HtKNB7+NzPMAlPDPEko/Ij36osjBCU85G5d5/kWWK0Mygjomdufl/42IZUZuIC29FiCNVe+kylLVCMlxyGH7N/Vl8oCtMwGlXl9fmg/N49IdXvT9/IX7N2a5ckv7OhNwFrK4gGlOiShQN3NFHrGUpTacSEBERlfsXi8PhEj
 Z/0AQAay
 cR+GTEvpZ0cESU9ClUKo7Gw9lhVimoqjibUpgAZ0QhMOmxx3p7P1OR0N6QHmoquiyTIqnsgaewav6BSwRoe7FgEH27t3zBZM0QSVrnsOIWJdaqJsQDSQwgjBjy58w9j65sqMLFoFtsHw2fCV6D2sO3in5/BGic7vkk02JaUmozBD+2UVYF4URfkR5QcL+l4D+gywM158VF72244Kl8mytlT5KTmyfBaLGX2UjHTJXg3dadB5QvbFbmxrdtbm+bYROA68V9wHNalZ+2269SXIbbDKo2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO memory preservation radix tree does not mark the table pages
themselves as scratch. This is done to avoid a circular dependency where
preserving a page can lead of allocating other preserved pages. This
means any walker looking for free ranges of memory outside of scratch
areas will ignore the table

Add a table callback that is invoked for each table page. The callback
is given the physical address of the table page.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 include/linux/kho_radix_tree.h     |  3 +++
 kernel/liveupdate/kexec_handover.c | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index 030da6399d28..fe7151d89361 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -37,12 +37,15 @@ struct kho_radix_tree {
 /**
  * struct kho_radix_walk_cb - Callbacks for KHO radix tree walk.
  * @key:      Called on each present key in the radix tree.
+ * @table:    Called on each table of the radix tree itself. Receives the
+ *            physical address of the page containing the table.
  *
  * For each callback, a return value of 0 continues the walk and a non-zero
  * return value is directly returned to the caller.
  */
 struct kho_radix_walk_cb {
 	int (*key)(unsigned long key);
+	int (*table)(phys_addr_t phys);
 };
 
 #ifdef CONFIG_KEXEC_HANDOVER
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b22b3cec251e..0f8d058f1a27 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -273,6 +273,12 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 	unsigned int i;
 	int err;
 
+	if (cb->table) {
+		err = cb->table(virt_to_phys(leaf));
+		if (err)
+			return err;
+	}
+
 	if (!cb->key)
 		return 0;
 
@@ -295,6 +301,12 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
 	unsigned int shift;
 	int err;
 
+	if (cb->table) {
+		err = cb->table(virt_to_phys(root));
+		if (err)
+			return err;
+	}
+
 	for (i = 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
 		if (!root->table[i])
 			continue;
-- 
2.43.0


