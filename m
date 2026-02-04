Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49301E83EE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 08:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43BEE6B0005; Wed,  4 Feb 2026 03:57:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA0F6B008A; Wed,  4 Feb 2026 03:57:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F56A6B0092; Wed,  4 Feb 2026 03:57:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DA756B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:57:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E255BAE1D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:57:11 +0000 (UTC)
X-FDA: 84406169862.12.CC84667
Received: from outbound.baidu.com (mx24.baidu.com [111.206.215.185])
	by imf12.hostedemail.com (Postfix) with ESMTP id B074640006
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:57:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf12.hostedemail.com: domain of lirongqing@baidu.com designates 111.206.215.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770195430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=euOPnBCAVN04lBC/F9STdVzOtksMFUX8kmE4d4GWvss=;
	b=QNtw0Rb1Pit45zNZx1RdLYNAX91mVtxfR/v+3FqNyjZV6Bic3Xt2ZiRhs43cu49+dy9z+a
	+PmYrfv3iCDp0LqMUxG3ZF2vZlBnk2ZodREktFAWptghmc0tNiERXLHQKwUj1K5KjazLGE
	9zyvN8Wb0oomu3p2J/m1R1sSQaXhSgo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf12.hostedemail.com: domain of lirongqing@baidu.com designates 111.206.215.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770195430; a=rsa-sha256;
	cv=none;
	b=rCELQ8u2/k4G8SInhoJbCSQQgtZRIQqIhl1iIW58dZAOA03RJXoDOXKQFQ5ETmXOrkYsUF
	v7iEvQK7RQdilgmqBgoFSjXMdYQhsBMv3xpTKUyoQVvmINT3axHzEdN9Wu3g+LQdbgysfi
	/AgPG5t832jpO/3Jhuclljkc2tYvWqg=
From: lirongqing <lirongqing@baidu.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R .
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] mm/mmu_notifiers: Use hlist_for_each_entry_srcu() for SRCU list traversal
Date: Wed, 4 Feb 2026 03:09:37 -0500
Message-ID: <20260204080937.2472-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.127.73.8]
X-ClientProxiedBy: bjhj-exc9.internal.baidu.com (172.31.3.19) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B074640006
X-Stat-Signature: 8crsd5uzd815mkcqy6b154z1i7jrxmui
X-Rspam-User: 
X-HE-Tag: 1770195427-358617
X-HE-Meta: U2FsdGVkX1+S9Mm5T+j50epryBce87mwciG+4hDR/dvEdbZqCSsaiZn9xHsvr0LvjSAVSeSwwA3e1MqwXLhbUDsaJBQCVFCLuVd3KYt+HRgjWPsrI02DRTLJ3kf9GtOiB2XusGZvh0JcJpItEDnKz+cO1RHtsieS0pCOPJXVp9OS4Yq3ElkTKlCkUdiKY17dDfse4xjGw1S+ucOjWG/zCd3fSHZIF5tPGzxoSrdcF8S4KZ8Wcj1QaufZUaBmhKWv2DV3QT3jxVEbPJrg/5Tf+RtFy60zsLD8LWiINrjncHzJWrd9qVBITc6E4uIiuGM8ud85+tSyhhefyDjT6pONhcL0x2FPyf9r1aTXHpkASGMPsE5WUUfjvSfPB6JxhhrnJtVeqjmfoaImDfiDUsjAjo2NYHIVXMO9WugCq1Awg+vfhR85jP1t6bgFCpYooh7Y+Vf1uQQEd5fN+bU/Kl/6fc+EISipSTgf6O8A768it6vvz2C7K7eoDBOr2TkOwJK9enj7e1caN5Kq9THNJ/ZNx/5+2HZI/fAN1oEpb/awqIvx+D2b4ndBhhm0O5R16yXLCuODJeoIXsIoKuNeEiEo9z4PnvgdWgvQTYaJ86NqW2Ky6GiPp6y6/iQoTSztH8HPXDyJpZgzdMvwnrk39pJmKBppL7TpgoSbSkPnG4OBNhhJEn5lnhsN6k90DZ5+DHsv5rd8GHqztV1mb8Y6BIgJ9qHS4JrvUidFjGXD0j/TGUTXtvsmkB01vyn67GvR6ubXmnrSk4T+fXMK6IannTj2rEEOUjB9TAgDJ6KdxtSU63xyrSbc2FSKL7siWenBIWfKk5U91/kWNKkOthzR0MNadhmV2K/W5aj1MR0DnNbZzXLwQT2uUPSiZRZRnIh8oiLwKE1+4yvE5K5VcvBuYA78b/gHKQzH/jcUMpWqCmfTjHjzAwNcnqQzs22IE46Lr3OYgOhGBRIaQ7AztNs5soZ
 U/6Tb8bB
 hR0ap8vtQTmFYr1aDLvOiYk16itfrkVQY6+/vWsDjYZpPH+OW/FH/IzbnyX60yeajAM3gz7Zu580h/F76Yawpv5asYChUzlqo+IBBM1Sgc7O4+jtv1qS/LehkjGozfOqmNbrhIVUTa3tbY3X2Z3mNxsTemOb7QW3OS8aLHkbIMKDOofdGtrCe4KMlvhIBHkoCNO5acZLjoP0nh/4jOXUem/wZtdlmpXkCRcoLxMIIiOCS+YIvrZLXJvrHgBiU3U1TN9XiwgKwzvFYHNccIwwLB5P+tFxH7490xJLrWj57swXBe/1CTrTEyg5IzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

The mmu_notifier_subscriptions list is protected by SRCU. While the
current code uses hlist_for_each_entry_rcu() with an explicit SRCU
lockdep check, it is more appropriate to use the dedicated
hlist_for_each_entry_srcu() macro.

This change aligns the code with the preferred kernel API for SRCU-protected
lists, improving code clarity and ensuring that the synchronization
method is explicitly documented by the iterator name itself.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 mm/mmu_notifier.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 8e0125d..2a2a582 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -309,7 +309,7 @@ static void mn_hlist_release(struct mmu_notifier_subscriptions *subscriptions,
 	 * ->release returns.
 	 */
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist,
+	hlist_for_each_entry_srcu(subscription, &subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu))
 		/*
 		 * If ->release runs before mmu_notifier_unregister it must be
@@ -372,7 +372,7 @@ int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
 	int young = 0, id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_srcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->clear_flush_young)
@@ -392,7 +392,7 @@ int __mmu_notifier_clear_young(struct mm_struct *mm,
 	int young = 0, id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_srcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->clear_young)
@@ -411,7 +411,7 @@ int __mmu_notifier_test_young(struct mm_struct *mm,
 	int young = 0, id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_srcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->test_young) {
@@ -466,7 +466,7 @@ static int mn_hlist_invalidate_range_start(
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist,
+	hlist_for_each_entry_srcu(subscription, &subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
 		const struct mmu_notifier_ops *ops = subscription->ops;
 
@@ -504,7 +504,7 @@ static int mn_hlist_invalidate_range_start(
 		 * notifiers and one or more failed start, any that succeeded
 		 * start are expecting their end to be called.  Do so now.
 		 */
-		hlist_for_each_entry_rcu(subscription, &subscriptions->list,
+		hlist_for_each_entry_srcu(subscription, &subscriptions->list,
 					 hlist, srcu_read_lock_held(&srcu)) {
 			if (!subscription->ops->invalidate_range_end)
 				continue;
@@ -542,7 +542,7 @@ mn_hlist_invalidate_end(struct mmu_notifier_subscriptions *subscriptions,
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription, &subscriptions->list, hlist,
+	hlist_for_each_entry_srcu(subscription, &subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->invalidate_range_end) {
 			if (!mmu_notifier_range_blockable(range))
@@ -577,7 +577,7 @@ void __mmu_notifier_arch_invalidate_secondary_tlbs(struct mm_struct *mm,
 	int id;
 
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_srcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 srcu_read_lock_held(&srcu)) {
 		if (subscription->ops->arch_invalidate_secondary_tlbs)
@@ -714,7 +714,7 @@ find_get_mmu_notifier(struct mm_struct *mm, const struct mmu_notifier_ops *ops)
 	struct mmu_notifier *subscription;
 
 	spin_lock(&mm->notifier_subscriptions->lock);
-	hlist_for_each_entry_rcu(subscription,
+	hlist_for_each_entry_srcu(subscription,
 				 &mm->notifier_subscriptions->list, hlist,
 				 lockdep_is_held(&mm->notifier_subscriptions->lock)) {
 		if (subscription->ops != ops)
-- 
2.9.4


