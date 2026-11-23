Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D497606A333
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kavW/R8h
Received: by kanga.kvack.org (Postfix)
	id A4AF96B05CB; Mon, 23 Nov 2026 09:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22606B05CC; Mon, 23 Nov 2026 09:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937D66B05CD; Mon, 23 Nov 2026 09:19:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A2156B05CB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:19:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED7E1A0919
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:19:00 +0000 (UTC)
X-FDA: 85466590440.27.65493AD
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 349F0120005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:18:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="kavW/R8h";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443539;
	b=lE51AmZ4NI9G7T2CKHJT3DSi4Z1WiJkFJbVJJhSZkq5LXIWGH4vcWyI0jVuvG8vdXwJQRQ
	s+f5hsYBulsGO3pAz7wdYOk0/Lgsgou1Zysu+j+J6Iy4blOMSC58GcHEysSQkfWSTRBp5F
	jW3aWUCgzZ+KvXgalfBmopRIYRQwfvs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hO5PksLazy10kxPAE/Z7AHdutWvEqaEjYn4t7ERodC8=;
	b=Ewnh87AvkEPGkviPM6IjASxj1FKZ/9DxwzAz6KySo4znwJHO5GhKVhQy/VWO2Uz2I2a15N
	VftGbM11ssJmLZ4dfkxR2ZzeGyUNpZAJyHct7pahGOG1B4XIxc2lMFGhzyDDLZ/Y2gtxkx
	POfkXZ4VCDxfvj6Rt3zCsA6gaS/2A9M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="kavW/R8h";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1b3a05f8b5bso4180274c88.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443538; x=1796048338; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hO5PksLazy10kxPAE/Z7AHdutWvEqaEjYn4t7ERodC8=;
        b=kavW/R8hf+w1gFXHRdRC5xaL3BKq1dcuAkxJaMHeRFqCIiTf30Yku8atryvPoFbDX6
         ZjzmAa2FKJuCYePTuoyQyi69n6iC3/pcWik5eoT3HX9Z76QzSkuL2F6lFl1rdkHgqvZW
         ag5kou8xMTVHJK4xl2eFfadYKTUZQBpxm9b8qXsrSaLYVn2/OTPjB29o0lNaoNAvu0I3
         5i5J63y47B81pEHI8JDiHPfW5oB/9RaGiq3kISDce8XdSJlG8cUvCLy+GMa5psCGrdBq
         qutbDEEzqDm1ivyEacUdy5fYwHMvhdmKuhQ0mbqQfS2rHvqVso/W0gpsPu8YgKi6SpQq
         a0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443538; x=1796048338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hO5PksLazy10kxPAE/Z7AHdutWvEqaEjYn4t7ERodC8=;
        b=F64dfGs8uJIQAXh2d4pFV1bnUi8oYkLshFkvFf7yN5LoP4hnvD5qCrzoUvqri9Fjnh
         yeA/UqpngOTqbunGBcjh5rPqnNnzFO4Pjrh+ZRd8EzYq/WGoOEQysoNVmjYDkITxLiBL
         aFFVA2fYdREFCw6xiSMWbZGG8KDs2FkVin8Zxu4dG9erz2ELYaJakVyUvA7nrn4ZwVGA
         e3gh2ARLnX829yxHn0idp6yKXUPmB7jAcVtMuH7nwPYsDYqrWMo88M/X14/nc//4Yi6E
         rREIJNy3M0vrOhpS4FolnTOXw1nR2wkLQnqK9jC+PPdxCH4CriRtmIWO/OoKLCt7j5lk
         qH4w==
X-Gm-Message-State: APuU4Z8+UxLg1CHlou/uuZCcAlc5KTTQufXaI/bEEzMyCo2P7esGOBE7
	6HD0d1yfuxX6/DfyGfvABoGY++OD77pCHBk4wI8CtsuUSep1GmooZaWuDrWDCUj4
X-Gm-Gg: AZFdTZeVfOwyRGechGECh+ahLSZ7bzg1UjR2QVGhLQZY8ZrXKPDls0C5mdVC8tXTxIU
	pSljPk6JL4F6KqWf0ytk1uAKg9007qttrOOhmVsdr8P4+xqSg9Kez9/2JTX2U5kA8PtU7fvh5Z5
	0eucAcdkmJORaVAy65N4f/XCWwJ/5BmYlYq/oWUL3AUtc+VRH+7582303mlbNv6d9ewtBeSehHZ
	VrZBAYOLvkwFDWkmA1pK5gBZM0Ahn/TCIZh7CBmM2UMwsnsPwuOec6hdYlIIl3CdMe1GHjYx2OT
	K9w/kcurUv1Zi65HYqkYLJgc4r5rsmThlWRws3VfL0otmFb6fHC9IcnMVNApiWjzOJJxSC6Fwzy
	xctdwJAXeT5VZKvsdJuz2iKPFdpSCqxQ9zbj421NKD1GcdGRfDHkfZPw25SrB6bAvz0I2NEKZUQ
	Iusn9/a5yQVYwBik5DgqIH+VAE+DHy/yJ8HBsBpgC9yjPdDyHKCgAjUhN5gqKw8IVWdSubuB6AB
	23C/JWV8mJvq8YJzYq5pVhd5ljgkxsxvpTn3+NX0zRfCBagrKZ02W0e4vFEqsicoc9tRI87Ld8n
	R0IunnZzxLpDdVJ9OWfnUr1otMtilNEpMOAcCkHE4EKDoXYmvhjaSQkpTiV6ZKYq9Kx5eA==
X-Received: by 2002:a05:7022:290:b0:1b5:dc3:209b with SMTP id a92af1059eb24-1b5568ac6b0mr11174075c88.22.1795443537970;
        Mon, 23 Nov 2026 06:18:57 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b56ef9fd16sm15243105c88.4.2026.11.23.06.18.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:18:57 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 12/19] mm/swap: remove available list
Date: Mon, 23 Nov 2026 22:18:44 +0800
Message-ID: <7a2be9c40cc82bf1bc1036ae7879ddfa9ac9a015.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 349F0120005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: qf51fg98794zrucejobw5ewmbyixrkoa
X-Rspam-User:
X-HE-Tag: 1795443539-871121
X-HE-Meta: U2FsdGVkX1+WRu77PqpoN2YvpPh8B7r8KZHBBE7A4yT3qgUT1yFcIb/z/+FNrwrBxlcM4QF3rIxnfcJWRavZVUBO1lewIMHHiqARNH8nvHSJ2WfT8Sk8paAuLcrM97q2NQiY5XWxnr2/wxZnkgIN9vwsvopz2cK8SqwYnUsh0yd5f0+zfI0zRIy2Tnx0y6LchVEo/cACcgVL0PI1g+R1yNCF2WaMhVUgO5ym4xGOphBIam4rqzYkmhdwhSE3tfk/+5SmFc9JhYTFKeHHINgaHxyHQdmqHpjKnck+k7+DgU24zal7WC4QNKffgdp9UAobS8WuehKQ+UQMrAtlceikGhUBj5u+wWHovnVaIxiLkoOBIA/5oKkdvYm7WCY70skgqg/urHSzgGSurkRHjLCSMQTHaZU2IvTcMCaW1q19s1/ViDIOYY2cYsoDqQNru8yyTID75PIKE4TJetydBadz26AE4oKMrLFPUSI705sHYhHtP7Tgf1jpYuUwVxw+ocEr5LoV2UzIIArolX5ma4zgFC7GPFmSK3KMxNNIeYS0ILgiL0oTCy9tHNujupYE8UlZf19gKwkjMgnFjqE5f82b+wBWLD0T8p1dcOy/bvSh18dhI+Oy5dlEZfYPOU2Px7emGYEcduKmievPGEUH1/Vu0FoUfimHu2qt5etEIbDcKQ9JRaTh0mS3XwaxoMKrtlo6ooBdC5bAlG5lMDH6uKybm3GUpc8VG+trfH/tirgpzLAXr+4CoE2r5LVXtSa40iXlthLl6vnh4VWR4QIjxsns/AUz27PesQL72xgJJa7yqFLeVND9s87zww+vC6m5yF+PIRhSW3XYaO3NfXKEzJWxpTBMfbbuMPC/6vGxs0idt9E/ExgvlW+Z272PtAmTGYcvZvCji9yBB3WXJz39kviovI3RnNw/ya1NWFghW1GWOagWCcAkMtKp7L/xK+eMyvBMtLEXvbL6oooawDqYvM3
 EWn5aqAY
 +RG0JcAptNyJQthYAjSJI7rQPyH8EcL2iT2/rLuGV+Me6EAhRDFvFw/i1YRi8qupnpser0ICWzeu4jBQkReu043t4tg3j63cL2SuhjYanuPCXT0ovsXLS5hlCvWiJ1Pnk/JcfjHYn8ATsGxwI8z1ng6VObKKWkhPufXCKRS6Hvkc9t6lexkJmq3n2Xv4cUGLULXC44l0fnjVIdn6MNEgT3F07TGjUC6VmZAkBoTWc8icpohXo5NUNsRiRNQ2nMZ+3lC6H2uNae0/5BB/d8wazHw33tphdgjSEPKmspruUKn5Ww8SaO/j4BBn1xO9w/PU5aOoL9zuszue8TBDOBiLN21Hiidmf9TFseuR5PI33VcvNhr3dIM9venSmSrja1qhDJB7py0WZn9Bf/4NvXTifYox+67bgjx1dvpqJN3/OhwHlRcbXIuL8rfhu1RHlVBEXsgWWyZGfOGOsaRTqA3skp4r7x/u4Pw1YXoq6uzrp/IhVp5M4ai4S6nCiJUx40db31j2J28HFkw3cUrkLDYYV8TkdvvuExqD4ZPV2n+EMwx6MyPDfN8FqzxkKcvsKV/Oq1R+MIUyCz7Bfeqv/IZxkIHgBJcFMIoDZ7jhS5HbO4vCdU8y7KVbLhCiEHA0M7iMcaf9K6HnEkLPfbnCVY6q8d4aBjcbxHc6HFDsj16t6nUKOv1OZXtddEWOtOK6mDo1jzEcZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The allocator now selects devices from the priority queue. Move the
remaining block-cgroup throttle traversal from swap_avail_head to
swap_active_head under swapon_rwsem. Check SWP_WRITEOK, the off-list
state and the backing block device to retain priority-ordered target
selection.

Remove swap_avail_head, swap_avail_lock, the per-device avail_list field
and their maintenance now that no consumer needs the available plist.
Queue masking and the embedded availability state remain serialized by
swap_queue_update_lock.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 33 ++++++---------------------------
 2 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6f32de173fb9..d31f3f023d36 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -289,7 +289,6 @@ struct swap_info_struct {
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
-	struct plist_node avail_list;   /* entry in swap_avail_head */
 	const struct swap_ops *ops;
 };
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1e5f88f516c1..1f31a3ae75d6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -96,21 +96,6 @@ static const char Bad_offset[] = "Bad swap offset entry ";
  */
 static PLIST_HEAD(swap_active_head);
 
-/*
- * all available (active, not full) swap_info_structs
- * protected with swap_avail_lock, ordered by priority.
- * This is used by folio_alloc_swap() instead of swap_active_head
- * because swap_active_head includes all swap_info_structs,
- * but folio_alloc_swap() doesn't need to look at full ones.
- * This uses its own lock instead of swapon_rwsem because when a
- * swap_info_struct changes between not-full/full, it needs to
- * add/remove itself to/from this list, but the swap_info_struct->lock
- * is held and the locking order requires swapon_rwsem to be taken
- * before any swap_info_struct->lock.
- */
-static PLIST_HEAD(swap_avail_head);
-static DEFINE_SPINLOCK(swap_avail_lock);
-
 static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
 {
 	lockdep_assert_held(&swapon_rwsem);
@@ -1711,7 +1696,6 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 {
 	unsigned long pages;
 
-	spin_lock(&swap_avail_lock);
 	spin_lock(&swap_queue_update_lock);
 
 	/*
@@ -1734,10 +1718,8 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 	}
 
 	swap_queue_mask(si);
-	plist_del(&si->avail_list, &swap_avail_head);
 skip:
 	spin_unlock(&swap_queue_update_lock);
-	spin_unlock(&swap_avail_lock);
 }
 
 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
@@ -1746,7 +1728,6 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	long val;
 	unsigned long pages;
 
-	spin_lock(&swap_avail_lock);
 	spin_lock(&swap_queue_update_lock);
 
 	/*
@@ -1777,10 +1758,8 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	}
 
 	swap_queue_unmask(si);
-	plist_add(&si->avail_list, &swap_avail_head);
 skip:
 	spin_unlock(&swap_queue_update_lock);
-	spin_unlock(&swap_avail_lock);
 }
 
 /*
@@ -3904,7 +3883,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 	}
 	p->swap_extent_root = RB_ROOT;
 	plist_node_init(&p->list, 0);
-	plist_node_init(&p->avail_list, 0);
 	p->flags = SWP_USED;
 	percpu_up_write(&swapon_rwsem);
 	if (defer) {
@@ -4320,7 +4298,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	 */
 	si->prio = prio;
 	si->list.prio = -si->prio;
-	si->avail_list.prio = -si->prio;
 
 	/*
 	 * Publish swap_file before making the percpu ref live, then add the device
@@ -4471,14 +4448,16 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 	if (current->throttle_disk)
 		return;
 
-	spin_lock(&swap_avail_lock);
-	plist_for_each_entry(si, &swap_avail_head, avail_list) {
-		if (si->bdev) {
+	percpu_down_read(&swapon_rwsem);
+	plist_for_each_entry(si, &swap_active_head, list) {
+		if ((si->flags & SWP_WRITEOK) &&
+		    !(atomic_long_read(&si->inuse_pages) &
+		      SWAP_USAGE_OFFLIST_BIT) && si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
 		}
 	}
-	spin_unlock(&swap_avail_lock);
+	percpu_up_read(&swapon_rwsem);
 }
 #endif
 

