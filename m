Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E809D2ECEF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4FD56B0321; Mon, 19 Jan 2026 18:03:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B925D6B0322; Mon, 19 Jan 2026 18:03:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87866B0323; Mon, 19 Jan 2026 18:03:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 969E76B0321
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:03:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F2A4C179E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:07 +0000 (UTC)
X-FDA: 84350240814.01.E330AF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id DBC1240011
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kmYAethO;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VO9wuUA/EX1nPbSdezgUs6+CQU3PwkcKqXHdDIEeFUA=;
	b=2ipfo/G1h0jBBgyKbHAJbnHhrGPYG3yx6tKFaakPPTtr0kyrTdGZDk2HVm0GQ8oiWR9sin
	ZzE7dfs4Irk0wlgVSW53ok/g47xW6Ls8QGrbCcN6x6mMGOyrEN73aYjYNdIQF747ScT5lm
	7pRvjJuUgYPT5bj5r0u/3slwCYvN47w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kmYAethO;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863785; a=rsa-sha256;
	cv=none;
	b=It4ELbCq5kcB/OCA8IJkiLpmzc8gLXkIxQpyJzeVrOnaZsJ2cIYi74/8CXQw3/4nuy22OB
	MaObef9VwqlnX8R3aP8IPndJCK+MuBlqwQfHJWKDs71RnDNo8GltZHPANW8mUHF9TGeRPF
	TGoAlgycb01trBkP0TDxh2SIgGOi1YI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 638BB600CB;
	Mon, 19 Jan 2026 23:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCEAC19423;
	Mon, 19 Jan 2026 23:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863785;
	bh=zj9sKtWRdKX3eQh5DiITmdQ2hR8ll6W7fi9C9Q8cgJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmYAethOA7nMRUFhdBBERTrxwJxKacgPLraITEsM51q/xkAq5MgpSYoRetjELCjTf
	 pVGZC4C7WCra3xxAMTL9T8fnDQ2zTp5N1EdgmR7rCAgofrrFbDHOqRn3u7c10Sa9gT
	 jANs1LZ+LwGchIOXjBKglorB87RFNVM8XFlI1Uqp2fTuIDfd9X9mhLBpit6JevElrF
	 JFOT+2uHzHYISS3Zp0CFmwJy79JYaIJ26eOy+SbJouNGpVhad79c/Mu9FMsnAmElcx
	 4ebU+qhgPTIMYX/TP8G4jX7GahExH0+5k6idx5iApHdM1lOY370XAIHNAerzmvCZxw
	 F2WUUFU/nU/6g==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 12/24] drivers/virtio/virtio_balloon: stop using balloon_page_push/pop()
Date: Tue, 20 Jan 2026 00:01:20 +0100
Message-ID: <20260119230133.3551867-13-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DBC1240011
X-Stat-Signature: puzyefi1ayg34387yh5bhuayrhihmsfs
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768863785-859455
X-HE-Meta: U2FsdGVkX1/klAFis2w4gj6C+vvgMJtah3q/5BD1fT72vSPZvR2yYSCfo2ku8dX5zgF6yE+2u2UrPk0c3X2vXvmXKapet6IGzL3/ZgIy7axMQaBngzzCkhX7DeWfEdJHI6OkqWMm1VR0iUN9K35UKsmSAOvP+cUIDSACfTa9cJAgrG8IycAOUHWNRrLzdySl3NjvsZTD2TWmOtaGCexaxtMM4WHCZU/XE1DNIhF/+qvZXT/MOPG8HzQWoCIyKPiqN3yJJSvGrQrgQis2oh4OdWp6DYuemlyq9Ic27HTr/5mudyxS+8I6J4tJmuepkFbnJHU25n7IINZfmdDpKWMKArujAlEOK5PxaF0ekXOY1Oxj1lvvjtwXyMJREUpsiggNsr1s9EIWolvkD9ET0CQptVz07gQaD21DJ/GM8/CNJqMCfTV/9NtbyImiTSbmPmYxmI7edFTpu1eWk7MPXgVodRR8AtKx5JTJbm9xqSQPUWlYscW4vUMzPMQo4a0x8FazzApBj7yRKyONVZoxLUlzeaz1+YqAXofe9TTJBGPCKs8vasXRBHF7wU6Xtfs5FUXxJXHpqp2iBwuS1PsNri5oP3+Jjq08nZMOkZLk1Pbi5NWkMSvvUhOVjSejsHtspeiB6GP8JRpO5FSJkqmINZLPhUglZVzdNJUp+L49l7801Op+jnZ02J2dnkQAX23Or/GzIic7eMb9NLat4rtT5AipCxWR1ZaGT2J6nFRfR9RzG7ZR0ooJCZjYUS6esYpMwlcotA/A/Iuk5XmzDSfqTpucGubqtYfDDDKcCAmCAzhnpxvpIW4Yxtb18SCBMAJQgut+S4JbYDi+jZCcMQ++EZm/J2V8cjA5o3FjqnrPi4zbWRa/o4M1JedHX1dVzcsnePYqhn+19zsAEbvT3aR+j7D2NULaa+wF5EBMKcUdrWVeEPxwHlUywFJSHBLJcjmWngXrBLMUy7kKinPkAQiV1Sz
 gjrXrfRV
 FROH85sWsXxOdj/Dr3Cf//r7VKzzEMhrezTyZGG/sswY24AzbPjTJ1EaUTy47pTMfvsox8z9gG2Y7MPQd5xQN8ab/szQXzmRJHkGaGcA2Rkw+aRjrG0vRQwdbDOt978tiG7L3pmb8WyrzTsIvs9FcWsbVL0VW8jpgqdHLJOeBEsDQCxWH4jkglGvjDrj4SUCkVl1un8ErwoNBRZrD+fbckCA2SgsDyWsdaSKeYbT1npuxqgr1/QyznJztkP9stRTEJJqCZfPQJbEyrWDRxYYizVi8BWZ6UPTV/PBkN/HimMqVAJ7PiTTJS5XUBMtSLvkfocRKj+0PIF/wN5c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's stop using these functions so we can remove them. They look like
belonging to the balloon API for managing the device balloon list when
really they are just simple helpers only used by virtio-balloon.

Let's just inline them and switch to a proper
list_for_each_entry_safe().

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 drivers/virtio/virtio_balloon.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 15c1cf5fd249c..6ae00de78b61b 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -242,8 +242,8 @@ static void set_page_pfns(struct virtio_balloon *vb,
 static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 {
 	unsigned int num_allocated_pages;
+	struct page *page, *next;
 	unsigned int num_pfns;
-	struct page *page;
 	LIST_HEAD(pages);
 
 	/* We can only do one array worth at a time. */
@@ -262,14 +262,15 @@ static unsigned int fill_balloon(struct virtio_balloon *vb, size_t num)
 			break;
 		}
 
-		balloon_page_push(&pages, page);
+		list_add(&page->lru, &pages);
 	}
 
 	mutex_lock(&vb->balloon_lock);
 
 	vb->num_pfns = 0;
 
-	while ((page = balloon_page_pop(&pages))) {
+	list_for_each_entry_safe(page, next, &pages, lru) {
+		list_del(&page->lru);
 		balloon_page_enqueue(&vb->vb_dev_info, page);
 
 		set_page_pfns(vb, vb->pfns + vb->num_pfns, page);
@@ -474,15 +475,19 @@ static inline s64 towards_target(struct virtio_balloon *vb)
 static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
 					     unsigned long num_to_return)
 {
-	struct page *page;
-	unsigned long num_returned;
+	unsigned long num_returned = 0;
+	struct page *page, *next;
+
+	if (unlikely(!num_to_return))
+		return 0;
 
 	spin_lock_irq(&vb->free_page_list_lock);
-	for (num_returned = 0; num_returned < num_to_return; num_returned++) {
-		page = balloon_page_pop(&vb->free_page_list);
-		if (!page)
-			break;
+
+	list_for_each_entry_safe(page, next, &vb->free_page_list, lru) {
+		list_del(&page->lru);
 		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
+		if (++num_returned == num_to_return)
+			break;
 	}
 	vb->num_free_page_blocks -= num_returned;
 	spin_unlock_irq(&vb->free_page_list_lock);
@@ -717,7 +722,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
 		}
 		virtqueue_kick(vq);
 		spin_lock_irq(&vb->free_page_list_lock);
-		balloon_page_push(&vb->free_page_list, page);
+		list_add(&page->lru, &vb->free_page_list);
 		vb->num_free_page_blocks++;
 		spin_unlock_irq(&vb->free_page_list_lock);
 	} else {
-- 
2.52.0


