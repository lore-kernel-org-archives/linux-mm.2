Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DDA8E7AD40
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 08:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 729D56B0096; Thu, 25 Dec 2025 03:22:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA086B0098; Thu, 25 Dec 2025 03:22:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617426B0099; Thu, 25 Dec 2025 03:22:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5481A6B0096
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:22:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2802C1645
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:22:50 +0000 (UTC)
X-FDA: 84257302500.01.16F5917
Received: from sg-1-103.ptr.blmpb.com (sg-1-103.ptr.blmpb.com [118.26.132.103])
	by imf09.hostedemail.com (Postfix) with ESMTP id A1236140008
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:22:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=aazWuKjP;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766650969; a=rsa-sha256;
	cv=none;
	b=ar3L6QQs8Aqiv8yX1KbN8ZB9YOVGaqY3FMEn/6zI/RhysmEhSoTaDbnF15H3q5gBl2x8+i
	O1XovW7yP8qojQYhIxalIT1ELXU3rDo44XYWKjJOhpBGVf5UYwV4yD3c/bk4/Yb9rOLaSV
	7yoXF9h+XUj+QSo3lniSySWhI8dpHHI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=aazWuKjP;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766650969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ttJk0p7bBgZoxWv2A6j13QFJkQF0RozkKQHOvbY4aE=;
	b=jqtG/JZc9UkOzsOmd2Kg0XtiET9Hn8xccvueRzVy9JhWojYYGfo4Pak/+q1k3QNu6EuP+q
	TELAxccSnp5Yy+9tFcxsaIEW1fzwFN0dRJa4HLENC3yoeqELKudFFxixmhvamJyWOQ1dC0
	Rbq1aiGNWw6lI3/FtW2a8JaMzKfQE6E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1766650961; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=8ttJk0p7bBgZoxWv2A6j13QFJkQF0RozkKQHOvbY4aE=;
 b=aazWuKjPLSwoZ+++jhTiQ1QBD2pTOYVlO5Rn7L25rQVSb2K1T8nOV7zZ+sJ36DF3KTyUlW
 PkCxTHJTF8G8GU/0iSLg1POffx9sZhgONYuG3v3qYK1SBGjwpnI7GMzygRC7yJTD6F0DXl
 8D/cGNpJBpvFWrJi62qzkU5Ur1tLv9STdDvEJPgd8YIRg5w82wrwD5T6PiL+6Ep7yWOmuZ
 wUxv1jxqu5hKVNnl2FzIEnWyCaolqq0Zd5StYr2yZl9I+g/9XKerjNnDRef0ylO0TTRG5Y
 DN3Qd+obFfEtQLyn1ojFc40Of2QMvUtWTl+MgKonLBb8ET4Sfntphy2niVHiCQ==
Content-Transfer-Encoding: quoted-printable
X-Original-From: lizhe.67@bytedance.com
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH 6/8] mm/hugetlb: relocate the per-hstate struct kobject pointer
Content-Type: text/plain; charset=UTF-8
From: =?utf-8?q?=E6=9D=8E=E5=96=86?= <lizhe.67@bytedance.com>
In-Reply-To: <20251225082059.1632-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+2694cf44f+26dd97+kvack.org+lizhe.67@bytedance.com>
Date: Thu, 25 Dec 2025 16:20:57 +0800
Message-Id: <20251225082059.1632-7-lizhe.67@bytedance.com>
Mime-Version: 1.0
References: <20251225082059.1632-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Rspamd-Queue-Id: A1236140008
X-Stat-Signature: mnsnywei1fogqtrhok8mbj93d376ihtm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766650968-928949
X-HE-Meta: U2FsdGVkX18KafoocLpV6S3QIikQ1FGgVXE6SpkjlXtG1yAiKJnOYpFS6q5Y0z7JGj7J6Afgy6oGKSj8w7j+pXXUlQudXhTu+BIneLTZiXkIKsWA0p9Di+vG1KHsG8KA4tF4AtMwlJ1qg01zNSrYdIHAF0qtCoEO9bah1K3FXhY91dh3SgKBBDmWTGkrkdbgZ33WFRf6OFgcgokVYgzdhl3WHvQmwqu8BSKiynGINNKRS84nCUL4AqF+jO2VZA9v7Fz2SNmJGSKzqUsQBWSN9/Yn655Qq9VzoI8BZX4MKATe2ymWfNTSceWcwqX6WWGkbO5w90ng8CTpTqbEWWaTOlMwdfyNh4+KxdCiulv03XmA7oHCNOeGnjHTQufKflS8HSoMnPag5QVpECGLbfaDhrgYFXcyx3Pyqxnevzfh6ZV3fRmJeHLvhpASSzL6ewITW91EE5melw86PMxPn/CWjfujzlPUKvqXSiWKd5RL7N03tsLhW5TT8s+7r8rBw4eFX3g9peW+eshvjvm5aP1ktU0xIZaVeUEff8SgAV0sdQeiBJFlslsC4A/8hJPIWT+QuXc+Z9QEN+kVHYZPMhstwTu4xdE6Db9XeaEd35tHCkjVqK3XYBFv2mH6PA1SZDW9AO79ZRCwofzXx8IrxDc+5lOc86iqdYYq7jZjRwWjTSU5zLf2QIhcSRwQbWppRWNftyqMCRg42MzHDni3g9hV4ctkYYMmve2WCaoHqJdQki68c6yvC0EH1iU0unI9kbevymYGXatbYpwSjhO4P8XKa+qQ7TgeHhGmPxS77pBUQANvg702Ep0xZ901Bxh6nncHLS8KDjlBY6/kg8RukbKom96tQtV8gn/xP1E4z7MN9G5w6ePrT7SbWMFwrXxuBlsBTTZ6z0kbOtuL4QN7hDN1UBZ0OlYRFgCsgdAuELbliikAbk9eTFdiDxVEGmTYfJe4Z2+t8WVwl03cLTd0z/i
 Ellzsame
 56dpn3TQdOxz/ofEMzTe4g0DKKMcV3gceqSrxz18lACrXz4PONgMCHfQ/9mnL1eiPDmHkk7huyT8Pp3LTX19jivKp4zA8dLyJtikT08v3s6SSRNy2G1eQ37pPsN864Q0ud49hGoMccSZc2lw66k+r6JVOtVoO7Qweo8b+90JwChi55XwaC+GcgpnBqL59oVMxO53dsiOtUHUsfKUuQnhw5JEQh3aBLo8Mh5vTv2OAfx6ZflAyQxJJY6/eCwEWky0dimzqdFArkuqu8H/TQXskwbw4i2wNp+WtL3yRgDreQljWAyJtE863Kf3SrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

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
index 87dcd3038abc..08ad39d3e022 100644
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
@@ -497,7 +501,7 @@ static struct hstate *kobj_to_node_hstate(struct kobjec=
t *kobj, int *nidp)
 		struct node_hstate *nhs =3D &node_hstates[nid];
 		int i;
 		for (i =3D 0; i < HUGE_MAX_HSTATE; i++)
-			if (nhs->hstate_kobjs[i] =3D=3D kobj) {
+			if (nhs->items[i].hstate_kobj =3D=3D kobj) {
 				if (nidp)
 					*nidp =3D nid;
 				return &hstates[i];
@@ -522,7 +526,7 @@ void hugetlb_unregister_node(struct node *node)
=20
 	for_each_hstate(h) {
 		int idx =3D hstate_index(h);
-		struct kobject *hstate_kobj =3D nhs->hstate_kobjs[idx];
+		struct kobject *hstate_kobj =3D nhs->items[idx].hstate_kobj;
=20
 		if (!hstate_kobj)
 			continue;
@@ -530,7 +534,7 @@ void hugetlb_unregister_node(struct node *node)
 			sysfs_remove_group(hstate_kobj, &hstate_demote_attr_group);
 		sysfs_remove_group(hstate_kobj, &per_node_hstate_attr_group);
 		kobject_put(hstate_kobj);
-		nhs->hstate_kobjs[idx] =3D NULL;
+		nhs->items[idx].hstate_kobj =3D NULL;
 	}
=20
 	kobject_put(nhs->hugepages_kobj);
@@ -561,7 +565,7 @@ void hugetlb_register_node(struct node *node)
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

