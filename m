Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21DEDD3B7E1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 23:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5556B000C; Sat,  6 Dec 2025 18:03:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B8A6B000D; Sat,  6 Dec 2025 18:03:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B23E6B000E; Sat,  6 Dec 2025 18:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67D4F6B000C
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 18:03:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE36313B801
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:03:27 +0000 (UTC)
X-FDA: 84190574454.19.BB96CE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6ADE54000C
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:03:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tUUDtxnD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765062206; a=rsa-sha256;
	cv=none;
	b=13Q9g6npJa2sSblJHmZ76p1m7Q9GNtYVGnBC5eqIbx7gwJP8y/3CIFG04AONKH5sPlEUhg
	ntgkHnlAYmBhu2SuLYVqHmTYgEDyVIfAEp6vHpbtAywzo9n9/qUnH4/IMnfgYp1jPS3uM9
	5F5PhxQVcfoyadzBmKzSSe3RkOW9D2k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tUUDtxnD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765062206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BiUTuUfe5vAoZQo+9tpLwvrSqI7Z3ZybwMJj6eLoJo8=;
	b=ZgTXfcPCcfsJPJ64wNqWgRoYIVKajg6u20dFIFIKvSOmOdaXp6oAtmJPEdC0kbqiIjX6G4
	tociJN77f09Vqh7mudtSNfcULpTs06+05WD583Ruo2U8xyeoZmkAQW2Z+TAotLt5CNE/EH
	4RQIi4SZI8X5oiUm7kXQBQvBaUrOBgQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC2946014C;
	Sat,  6 Dec 2025 23:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE274C4CEF5;
	Sat,  6 Dec 2025 23:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765062205;
	bh=KGnOcfnpQ9BU9FZJbzrgiU8lnduu/8HRPawdKcV6t1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUUDtxnD5j/gPnDazGeJDlVfGjKWIZmBD0OblMoGkBSR3WryqOqAP2BtduJHW0Ts1
	 zib5G2oPsbnoO0PpF3BE0aBcSjgf6rrxSEeHGJHAqhF6kJ1LszXt5G2ohGlc6+yUdy
	 s1fCdKColhX6jzjtk3VgF8N3NHN5Ai/CNEdqHnMiqpgkchklfoS77EULfkVIzP83kL
	 M4+grCe+p4WBo9sEMdr8CqWz1LBua/gXhaTVXsVMG/RhWBproCM+CptJ+pjKgNbYVp
	 fqabR6XaYXZQVJh7v5K0/LZS5/J14mfdaibZoq4izdmEGRDNVjD6mVEdyWP87vNXgC
	 jzCJjlTmsF/Gw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [RFC PATCH 04/10] liveupdate: flb: allow getting FLB data in early boot
Date: Sun,  7 Dec 2025 00:02:14 +0100
Message-ID: <20251206230222.853493-5-pratyush@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251206230222.853493-1-pratyush@kernel.org>
References: <20251206230222.853493-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6ADE54000C
X-Stat-Signature: tyfj59c9auuyungytfdngfxxtdfkh7o6
X-Rspam-User: 
X-HE-Tag: 1765062206-934566
X-HE-Meta: U2FsdGVkX18wxkr4UNfbAPmmjd6RXP+du3H9ZuvJGii9cgpXVfd3w7wod92nSXA3yHUlD/BfkFC504Gsp6/tBgqzI2rLvdKt7LcuFp1sYr9Pkf6vnYDVBXDiFb7T7fOuIWOO4H3M3DdOl6ALW2X80sJegUfMvdpELGMF9VIRyusyPSE0fG3JFy3S0Z9sjG2LMX+gWuNOwDzXRHzSBcoNiZaNhuSJEyHCd6vDnz5gakUQKAJkNvkFCg/4g5UA6TfXauLeKMRoIiuQZ0TnzOcrbqEiV9cSKFvino7qdjqjg6fdZXhWOvidb9DXeKkAgWjTYfWqs4/ewgZvzlECZvUi7oRBycXvPEbx5fo2qWYdYgaY5E1v1o9Fi0qtc/elEbGPHlCj8BHv/t1aIlVElO3YtSMaWKqJ9oqXYEoiyfJ+m+n5CMLXb4usfazP089ebc/LOaiJVDjzbwDtFDQb7QlR4mbXcr94KG0vSl8NRpZ0BYTrlSPNoKBhvA61H+sShWjr8GIX0eWJqZ0YvyyoW7blSMPBQxUrDOTgY/9o4mmE9EkVl9nNecEb61RWJuULuSwqrgV4s8NqztCjhzAGzMe1raFwSPpftHLysYi6C4zqseUqret6rSJG2PPzPk9brU91D1g0ODStejG7xumByauGreijLwtPSSbAShKtn/E4OiqOj/QkbYaqDaP0h1E29VSrWd7ZRofGobY3u9ZHaS/w3rO8z03qIzLBAvfmTA19n1FQACGk/oq+cAGkw1/MOvmQj1m4/CiUaQL2YMCZplUVoeBPYqufOCTBlh3IIIJJ2f/wOz7vfju9EZZ+fFR9drtfv039U4Lbx1pl4eNkT8at854nLgn/Ede6fKuUQLImRiPQqMgDdGEQCtaJMSXPpsksvIZczAnIQHixFXsfpgHxTun91gavkupFQ9oqMz7I1vLFkkcaIhv8hDjl/i0Ut8WfSW7MRHhQ65SyWp670g3
 yh+IKxTA
 8KxSZ8wrm/1falMT8e8NAzNaqxb+2RJbT4boYkxVcNYS392hu0iZOIHWEmUX3HmCwJ6Rkde80w2OYwbfZRhHw5RPkSU4LTZ8fZLpl6CDSFXwyQAW4LEfNAYb2O1kie4y7G6A5EUW00i/dppEEJRwbRXm/1CJ5RawkxG+jA35zvHHx4sfPqgTHP03xlcJEtEgzMLTx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To support hugepage preservation using LUO, the hugetlb subsystem needs
to get liveupdate data when it allocates the hugepages to find out how
many pages are coming from live update. This data is preserved via LUO
FLB.

Since gigantic hugepage allocations happen before LUO (and much of the
rest of the system) is initialized, the usual
liveupdate_flb_get_incoming() can not work.

Add a read-only variant that fetches the FLB data but does not trigger
its retrieve or do any locking or reference counting. It is the caller's
responsibility to make sure there are no side effects of using this data
to the proper retrieve call that would happen later.

Refactor the logic to find the right FLB in the serialized data in a
helper that can be used from both luo_flb_retrieve_one() (called from
luo_flb_get_incoming()), and from luo_flb_get_incoming_early().

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 include/linux/liveupdate.h  |  6 ++++
 kernel/liveupdate/luo_flb.c | 69 +++++++++++++++++++++++++++++--------
 2 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 78e8c529e4e7..39b429d2c62c 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -232,6 +232,7 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 
 int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp);
 int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
+int liveupdate_flb_incoming_early(struct liveupdate_flb *flb, u64 *datap);
 
 #else /* CONFIG_LIVEUPDATE */
 
@@ -283,5 +284,10 @@ static inline int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb,
 	return -EOPNOTSUPP;
 }
 
+int liveupdate_flb_incoming_early(struct liveupdate_flb *flb, u64 *datap)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_LIVEUPDATE */
 #endif /* _LINUX_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index e80ac5b575ec..fb287734a88e 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -145,12 +145,25 @@ static void luo_flb_file_unpreserve_one(struct liveupdate_flb *flb)
 	}
 }
 
+static struct luo_flb_ser *luo_flb_find_ser(struct luo_flb_header *fh,
+					    const char *name)
+{
+	if (!fh->active)
+		return ERR_PTR(-ENODATA);
+
+	for (int i = 0; i < fh->header_ser->count; i++) {
+		if (!strcmp(fh->ser[i].name, name))
+			return &fh->ser[i];
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+
 static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = luo_flb_get_private(flb);
-	struct luo_flb_header *fh = &luo_flb_global.incoming;
 	struct liveupdate_flb_op_args args = {0};
-	bool found = false;
+	struct luo_flb_ser *ser;
 	int err;
 
 	guard(mutex)(&private->incoming.lock);
@@ -158,20 +171,12 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 	if (private->incoming.obj)
 		return 0;
 
-	if (!fh->active)
-		return -ENODATA;
+	ser = luo_flb_find_ser(&luo_flb_global.incoming, flb->compatible);
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
 
-	for (int i = 0; i < fh->header_ser->count; i++) {
-		if (!strcmp(fh->ser[i].name, flb->compatible)) {
-			private->incoming.data = fh->ser[i].data;
-			private->incoming.count = fh->ser[i].count;
-			found = true;
-			break;
-		}
-	}
-
-	if (!found)
-		return -ENOENT;
+	private->incoming.data = ser->data;
+	private->incoming.count = ser->count;
 
 	args.flb = flb;
 	args.data = private->incoming.data;
@@ -188,6 +193,40 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 	return 0;
 }
 
+/**
+ * liveupdate_flb_incoming_early - Fetch FLB data in early boot.
+ * @flb:   The FLB definition
+ * @datap: Pointer to serialized state handle of the FLB
+ *
+ * This function is intended to be called during early boot, before the
+ * liveupdate subsystem is fully initialized. It must only be called after
+ * liveupdate_early_init().
+ *
+ * Directly returns the u64 handle to the serialized state of the FLB, and does
+ * not trigger its retrieve. A later fetch of the FLB will trigger the retrieve.
+ * Callers must make sure there are no side effects because of this.
+ *
+ * Return: 0 on success, -errno on failure. -ENODATA means no incoming FLB data,
+ * -ENOENT means specific FLB not found in incoming data, and -EOPNOTSUPP when
+ * live update is disabled or not early initialization not finished.
+ */
+int __init liveupdate_flb_incoming_early(struct liveupdate_flb *flb, u64 *datap)
+{
+	struct luo_flb_ser *ser;
+
+	if (!luo_early_initialized()) {
+		pr_warn("LUO FLB retrieved before LUO early init!\n");
+		return -EOPNOTSUPP;
+	}
+
+	ser = luo_flb_find_ser(&luo_flb_global.incoming, flb->compatible);
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	*datap = ser->data;
+	return 0;
+}
+
 static void luo_flb_file_finish_one(struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = luo_flb_get_private(flb);
-- 
2.43.0


