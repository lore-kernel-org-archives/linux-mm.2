Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E9DDCD583B
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 11:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996166B009B; Wed,  7 Jan 2026 06:34:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CAB6B009D; Wed,  7 Jan 2026 06:34:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8385B6B009E; Wed,  7 Jan 2026 06:34:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 734316B009B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:34:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 249C71AA5C6
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:34:03 +0000 (UTC)
X-FDA: 84304958766.16.6A5A0DB
Received: from sg-1-101.ptr.blmpb.com (sg-1-101.ptr.blmpb.com [118.26.132.101])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8A66F1C000B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:34:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=MEWQooMw;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767785641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqgHPcDteXeYtkcevndtOM5gbTYMZ0McWPYXT6sbL+I=;
	b=3qBc47skObxEsbD92sbiEktEAZj7bZqdVYfn859zZDn1qb6q+todr95KfHRVYceBW6FAhW
	d3fMPc43VFfC487+j9RV2XPBYCH3lb0ErJwD6v7OQML2SOi1vRdYOVYLrMGI9Egabo3qGh
	9y6H5MS9lAWvRW26lMM/ZUIyss8NMFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767785641; a=rsa-sha256;
	cv=none;
	b=JkO/saci1Qj6wdtQsIFBs51QFbbhpO0HE571mW4XapZC+eJ/YX/1GdHrM1tyl8ZKoP/jK4
	b46CkAVTgkj1rPfgwveIDscJxUFXrpbCi4iIjrUXRto8E6T52Y37SC/qIyaQZmnE5u2x3d
	tPBFU8D2iMjyE2XMwQodPZ3pepVIxRc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=MEWQooMw;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767785634; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=vqgHPcDteXeYtkcevndtOM5gbTYMZ0McWPYXT6sbL+I=;
 b=MEWQooMwwf387pl7+RcGoJSDMD39jWPto0yhnWCCSFVjoDtsKPQ4G5hMoSIImK2jLeVHI4
 EAevE6s3DtUImwb2xvXnZD2xmYjsfz9ApykwzFtODPNCzMYX/QH0aKGKDbWxQZj1d921ql
 V2+XLpBPBWbHrgI1K9TFLLabhVfEE93EFBi6DgT+fFRGdCNyiBgTJDbDO92YFkcUEwh9A8
 fAZvdx1uQ5FjJVS499gRpTe9bc019rf3wousP6eylUmrAB0fyMCOp4hXmROmIAq5XK9kIx
 0u/vvkvIf6QZnDiGehDMowsTkr+nkgILj6hhCfju/jIenLYzuixD1OPbOVNQNA==
Subject: [PATCH v2 6/8] mm/hugetlb: relocate the per-hstate struct kobject pointer
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+2695e44a0+a9cfc5+kvack.org+lizhe.67@bytedance.com>
Date: Wed,  7 Jan 2026 19:31:28 +0800
Message-Id: <20260107113130.37231-7-lizhe.67@bytedance.com>
References: <20260107113130.37231-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <20260107113130.37231-1-lizhe.67@bytedance.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Stat-Signature: 4tdzeix8uqed9nmttrz3963mu66htp49
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A66F1C000B
X-Rspam-User: 
X-HE-Tag: 1767785640-262766
X-HE-Meta: U2FsdGVkX19JPN5dWNan8fZ1Q9NSOLfvLt1yst5tV6DM5pfmXLDnE0dYCFh+8vjoRodR9BXTFn76iGyPO8uoi/goYmLW4UZ+j1r0uiNIFBOCmzm/WqIBZgH1A8bX1aPyafScxXFySB2yMxZ7jmDhSnxnLwT8sXs4TzUwc6xh7yOGv+18xsWd4solRsXSE+MfRn69rjc/cn8I3SmvpaMGESx2rZK719YHtfsGupT4LoKy0YDc9jQdBpx2Rnc7VMbPR5n00R9YA0tZLXlcqcgrm5qFqXEfhOQBr2F2rt9bB3y5SIEQ7hBsqI4tm37WEToNGE9cIdBS005kLrMdoT/Iw8Ta+Ibu/6BSuKmaWob533jzdQ1nJ6RQA+hyHYRGzlEWJrcm+l2apTwGVyXXaTS2b5ECLmudAa9O5iTrYoIkLvKuYjx6SxzxfQCWRqnz3tP2ENZY57oxmvydYzaEWZRuOxK5YK8sfcVR/j9YuxGrU/PrJ2hC6f+0P42097MHV0so4XmfP0eVIlAXcwJhx9ScW/ONo7FJxuAMD8v25a9zSoupxvVxUsrRGv/5LTXjZwxZ02mxOQvq/6IpStpN8j32vg0B1JPiHdusExKTWY7TuKtBZ2hEdxYWZeB84WBDixhwHkev0in5rvwI89lO/0szt+DFh8elfRZFdS2z3eDANM3ZmNfcQxMMWnm3BF2XS8rwG6yGw47YB0axdASHwm/icC6p5koT1bI7Zqi3oHmRfbg4BGO6fmIzA72XG+hezBrw1nsm76ds4QwrCehkARshTsEyjvW5m31d/g1HqDk6UGV2I22HIkkyK5Ea5jrVeAzoc8vU3dkm7RirotdNWhTy1JeYesUdRj9iw4CO9aSyrRPOFOt87eqRYd699PZA7xbIJ3FLjnT4FzlzouTRFvAV5MMs4gBh9q+rqw+j8+q73UjTLx1gRoSLYuIAI4L5QUqtgK4SP8fh936PxEy5H7u
 S/peBgov
 MPWlojlBvhH+qqOeelIWD3Fhy0wUwxHVDu953oLi1WBQ+XseIiigNd6sejjNJliovULoBpc0SHz2RxcEBwBI0UMZeE24Kl4QzrBxu6ASaD4vuJDAS2pjvVDh7ysy9FSFEKnIEy5tOhynnT45f9Ue3VxE54nCKwQvEUFa46mZ1wPVpSETKpLQQ0Gv39jTgoRQvtIz/+brOLsl2/o0tTae/BmRhLxW2Q0rEuS0xg09C5eBySC7URvxX+1I6+wZK823+q9ezVQOpEIX5EXbFPQmKzF2rutRpN1vhz+Ne
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Relocate the per-hstate struct kobject pointer from struct node_hstate
into a standalone structure.

This change prepares for a future patch that adds epoll support to the
=E2=80=9Czeroable_hugepages=E2=80=9D interface. When a huge folio is freed =
we must emit
an event, yet the freeing context may be atomic; therefore the
notification will be delegated to a workqueue. Extracting the struct
kobject pointer allows the workqueue callback to obtain it effortlessly.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb_sysfs.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 3f25a24e27cf..03b774b1191a 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -338,6 +338,10 @@ static int hugetlb_sysfs_add_hstate(struct hstate *h, =
struct kobject *parent,
 #ifdef CONFIG_NUMA
 static bool hugetlb_sysfs_initialized __ro_after_init;
=20
+struct node_hstate_item {
+	struct kobject *hstate_kobj;
+};
+
 /*
  * node_hstate/s - associate per node hstate attributes, via their kobject=
s,
  * with node devices in node_devices[] using a parallel array.  The array
@@ -347,7 +351,7 @@ static bool hugetlb_sysfs_initialized __ro_after_init;
  */
 struct node_hstate {
 	struct kobject		*hugepages_kobj;
-	struct kobject		*hstate_kobjs[HUGE_MAX_HSTATE];
+	struct node_hstate_item items[HUGE_MAX_HSTATE];
 };
 static struct node_hstate node_hstates[MAX_NUMNODES];
=20
@@ -501,7 +505,7 @@ static struct hstate *kobj_to_node_hstate(struct kobjec=
t *kobj, int *nidp)
 		struct node_hstate *nhs =3D &node_hstates[nid];
 		int i;
 		for (i =3D 0; i < HUGE_MAX_HSTATE; i++)
-			if (nhs->hstate_kobjs[i] =3D=3D kobj) {
+			if (nhs->items[i].hstate_kobj =3D=3D kobj) {
 				if (nidp)
 					*nidp =3D nid;
 				return &hstates[i];
@@ -526,7 +530,7 @@ void hugetlb_unregister_node(struct node *node)
=20
 	for_each_hstate(h) {
 		int idx =3D hstate_index(h);
-		struct kobject *hstate_kobj =3D nhs->hstate_kobjs[idx];
+		struct kobject *hstate_kobj =3D nhs->items[idx].hstate_kobj;
=20
 		if (!hstate_kobj)
 			continue;
@@ -534,7 +538,7 @@ void hugetlb_unregister_node(struct node *node)
 			sysfs_remove_group(hstate_kobj, &hstate_demote_attr_group);
 		sysfs_remove_group(hstate_kobj, &per_node_hstate_attr_group);
 		kobject_put(hstate_kobj);
-		nhs->hstate_kobjs[idx] =3D NULL;
+		nhs->items[idx].hstate_kobj =3D NULL;
 	}
=20
 	kobject_put(nhs->hugepages_kobj);
@@ -565,7 +569,7 @@ void hugetlb_register_node(struct node *node)
=20
 	for_each_hstate(h) {
 		err =3D hugetlb_sysfs_add_hstate(h, nhs->hugepages_kobj,
-				&nhs->hstate_kobjs[hstate_index(h)],
+				&nhs->items[hstate_index(h)].hstate_kobj,
 				&per_node_hstate_attr_group);
 		if (err) {
 			pr_err("HugeTLB: Unable to add hstate %s for node %d\n",
--=20
2.20.1

