Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD4F606A333
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C6CueXdC
Received: by kanga.kvack.org (Postfix)
	id D4AC86B0818; Tue, 27 Oct 2026 12:10:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22FB6B0819; Tue, 27 Oct 2026 12:10:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C38536B081A; Tue, 27 Oct 2026 12:10:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FFC86B0818
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:10:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03E3E1C4471
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:10:20 +0000 (UTC)
X-FDA: 85368893442.26.5FAA616
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3098A16000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:10:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=C6CueXdC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3Fc6Qd16BKiEoRWwD8fs3AmZLAKUuVGN6JC9AyRnB4=;
	b=N4eID4Izh60X9zCA8aVBpkVS3YFbOl8oE0OXGslhofhv2jAgmmTJLwAa4HMspkdxFJMCpd
	nSeM2MzqUdQqlNLHeoaIRgep+eEEta4/nncWqttM2pmJQlvb42kImGiuuI1ix6JEl1+sNL
	mC0Imf8FR5M1/nMS5u0GLZuShfyK//M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=C6CueXdC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117419;
	b=dhNHgwrD4WAc0sV0x9cOQAsS9xWWXacQKbdoTSvWuYAXBKwKVr7JM+pN/VBszLsaSPrllZ
	nl0r9LAwftmuPH9hrSYQIzRgtpYcZKixnjMFx/ZHynlDvbTZUDpzkTq5wUMDLKhVfK8ZLQ
	zq513pXtpI6jRpM7/svi2V1HRC/HMw8=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e9eb579c0eso25556465ad.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117418; x=1793722218; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K3Fc6Qd16BKiEoRWwD8fs3AmZLAKUuVGN6JC9AyRnB4=;
        b=C6CueXdCyBNRFMikbNRnFDoSelvj9XhEkxOOhUeva3aTAcV3iyH0mtngMoz394Xg5J
         HyXS+nZDWYR3LedWtQW7WUHJIwq5B/TDvw6glMHI7eofihdnl3+H4c3GuSdzr7UnFYZ8
         52fElk/sge81x2yxiY6H015nWQebWGpSNFMoS+eXpfyGZ1exvl89giD60/dam5zRCNym
         Y8fBljTd8nkuCkdLZWkCf2lBQdvr3nEzkILkUfULqAqYRVze9yt3jaLBNqNV69kvdMkH
         WPcg8HwP26PDaWlbSDrOJNnAuMAcKEnh9VJG1p+6vXIHDL/FeXN0shJVHoBZuTyPzOp5
         p8pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117418; x=1793722218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K3Fc6Qd16BKiEoRWwD8fs3AmZLAKUuVGN6JC9AyRnB4=;
        b=FSgxolzzMAG5z0W5TNCGfHvGOf/avFUCxa2prtjadJbl7M7QTY638zW4HWn0K83CI3
         e3q6xIwN2FPy/xga5HEH7kI4NaDVmsuEShOb9B1iPyylmrrIW9BzhX6wt33mefhk8BJr
         L0/CL/o0QPlsdsXl5WQnQw2n2ticzvS6+0YWzo8QSMivijO9wJy9+RmQz2Qad7WxaTQt
         pOFRFrSvP7JUxnjP6Gy2U5p5uhoBaiDE5EbJR6Rl5R2TX/Lca7lX+Zgre8Ri7NJibuxg
         O4o2s6wstJeEQTZ/D4f+cs1cIUqOh1ey5YoK7dGWo5KjguTp1NeMSBrtp7zjJmKRsvgk
         VVgw==
X-Gm-Message-State: AFq9FYJRj2ym9v81+lMg/SskC4KdyKw4JMkctWYDrP9n6Bwc5b76jkM+
	2+ux+6cN97ESo2AGWO0ivOf5ksDLL/QPkKzPqrPRG/rnPIgqW0yjvm2g3MIysg==
X-Gm-Gg: AYBFou3HxULxxaM7/aYWp9v5S02GmTbQRJj4L1f7yFFic0T5DMOuxxLvrO+1uMXHMUy
	isaioghq5psxe9EBCdJH1G8bjmkY/wEr8erUZEfG/3iwz1CaNrw0izggCFE7RHy/8+/lYJvMUip
	/fhYaxbDELXH2Jy1LZDOkjYFAy1OMPxCiipBnrEWG0FKY/7p56We3itOq+3UTsIBc+Bab6iZa11
	yLW22Q30jrjDw9Qe7F2lAHBV/3zIoF9Y8v8r2CamCZ3zC1twpugDe3EiT0rp9TdF2kWwxxETlxr
	5jeVl9gFcWZhWIl9RK6AA1cifrQC4jq8H9bJGDyuEOY8mMKIr0sZFo1OWje0vzWdTjCTTztfdGQ
	X6p5NRCy2oYtZ4lGhgZhrjOIr9jMzXsJQF0L9NDZCBsvIdXhQETEksl4GaCS41HHNEmSrEX9Jbw
	g6VU3fISTGyd9qPm0agoQ8cFKBCOCsz3EoJje4wBCgGTuzQ7jDeo7Vz0c0nUjgV1ufJ5qA8Pwac
	RUmMN00OZ3bkcSYpftGh1Ktl+f2hQ8in/eZIMvyzYO38a43m9ibRRabZFs+bb0OQIcrTbXMIrAf
	50HOzYCP/dvCqLeaX1oD3/bfuueZIm4RvoNc/bOA
X-Received: by 2002:a17:903:3c63:b0:2e9:87a1:98b8 with SMTP id d9443c01a7336-2ea9c95ba29mr81806135ad.73.1793117418072;
        Tue, 27 Oct 2026 09:10:18 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6c9d2cesm12213585ad.65.2026.10.27.09.10.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:10:17 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v3 11/18] mm/swap: remove available list
Date: Wed, 28 Oct 2026 00:09:49 +0800
Message-ID: <485a50f467e22ab0801b0ff16f2465fc4ed8c429.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3098A16000E
X-Rspam-User: 
X-Stat-Signature: ayc9qekumiewpoxjc3nt9u9bx83x778w
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793117419-495000
X-HE-Meta: U2FsdGVkX18BjRNN/g4IXZhDU7D+7nf/x8K00fKZHFrbdwi6ZIsiRHWx08He5WIbpvfIEPI73abvzei7iBFoayR0Yr8TjU9qs7BcxkggGdnPfeiXp77o6imnbvW2mtP8daBlfhXwbugHqG5RwDkhkpqxejA1DbEe2oq1FidspQUPk8uId/cK8yp5M/DK1Ka7Q0eqID4x7NRWDlk5vNQdJ3f9SKX1BGuNv+cn7IuHx67kgGVqZcmBKZXAEaMnNTGdZQVMSacIsGJdtESAqqZXjudEC2s8/X9NFAF9qIORK/O1RSU2WAK5Gh23pX0SdXkCKp09NawAKTWqFOd7LHpxlM022ut5SsAatPq18+8t641mSJidxOYNXT8S1/jjRlg8gPvKBzOyat1VrE87i6Zz4AvqUfIwoQTzeQ1uthyAlCV4NeD+tZNJDnKSFBphV8atKGbu4gzWwL1j9inHTTxzWlg+XwXfWR6UbDjohDRrfnbgDATzWM7vErLoI3ZsEMls7ayxhj1secoQftzaTcXMK3uJMsGtDSQThYM7Q/0JrouQmO4i8acx7Ce8hKFqgyHbBClEg42GxnFE4AtWPE2UFW+YN1cJahvl0kwFjNEwdTV8JG845KfKJ8DxvXpWFo6cFnky9Szct64OVPQTw3FJbeCaMRQjC6pAlMqaR3i1ZA8u0NNeExAZvSGnscC5BjUxOm2ALaXKnoWEyLgR+HoNF1XxNTp3C/2g21W8njOfA894UK1YscFHKchk3zPaUzQdib3EJdKbbw82Nyo+3J7ll35KVE5G++R3lIhrqX+awlKV/Wh97F1mBFbaeGzBBx2aru3nTkHd2OyvSDfHxrvUutLSIzmlpKQ0G9agkxvyCP057KrKBv0ZQw2ZqHqVzKSl9dPbRYlRN1FS0QycKQ3nLt9Xv2VvFYfEkDRZzQhpTVE16/NtkRq2uUOd8FAXXKnPBZ/mOCVJF1Cchwqu6e3
 AnKlTHSa
 T93S4vFWrv5SfZpeulAnWAZdRRE9j5NbbVj9i3qd6hHH0lV6LUMx6gZdXai4rsB+X6cP5J8/UCXN1T9LPou5iy1p17OsEANg4O65uDt8NtP7Dt6VD6B88CrobFvN8CnlZZmC2/iu90YQGAYG23LAWUzvNWS4ULfWisW5aTYsx2rcUwGduDCgHWklH2/dN9t4By0xjQKBk2ioanMTiC6kjpCy73Oac0zmgrk634F1tFHO8SXa51FtLnfWjvp2taZ7t6ox2gbmcODjYOLM919NkMRMrwmsk1AKO03iU8R2uc6feg5Y/gdjGjtZJ4NbdIuhvm1xkk7RLkgoMgoDqUlY6mP9OOBpt652OUklcS3Ug34mZjossxgiWSMaY0dFJjF+LtNta/KuD3zYEvjGOVfwCeqeOwnc4ZXdLWDoumJ/Qb8iHEG/E/SppQooa9LFvjwdd3ao+pidRudExhJhUUGV/RDnG3FK/iF/2AwlqAWzxbRBoF5cWld9Sd6mlCz/XC6ekY6w7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Pure cleanup, no functional change.

After the priority queue replaced the allocator's device selection,
swap_avail_head and swap_avail_lock are no longer used. Remove them.

The throttle path now walks swap_active_head under swapon_rwsem.
Check SWP_WRITEOK and the existing off-list state. This preserves the old
priority ordering and does not select a full swap device.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 33 ++++++---------------------------
 2 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 9357a9065f37..17b8ec654ee2 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -287,7 +287,6 @@ struct swap_info_struct {
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
-	struct plist_node avail_list;   /* entry in swap_avail_head */
 	const struct swap_ops *ops;
 };
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2065e566b7a3..0a16343a5b03 100644
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
@@ -1652,7 +1637,6 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 {
 	unsigned long pages;
 
-	spin_lock(&swap_avail_lock);
 	spin_lock(&swap_queue_update_lock);
 
 	/*
@@ -1672,10 +1656,8 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 	}
 
 	swap_queue_mask(si);
-	plist_del(&si->avail_list, &swap_avail_head);
 skip:
 	spin_unlock(&swap_queue_update_lock);
-	spin_unlock(&swap_avail_lock);
 }
 
 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
@@ -1684,7 +1666,6 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	long val;
 	unsigned long pages;
 
-	spin_lock(&swap_avail_lock);
 	spin_lock(&swap_queue_update_lock);
 
 	/*
@@ -1715,10 +1696,8 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	}
 
 	swap_queue_unmask(si);
-	plist_add(&si->avail_list, &swap_avail_head);
 skip:
 	spin_unlock(&swap_queue_update_lock);
-	spin_unlock(&swap_avail_lock);
 }
 
 /*
@@ -3844,7 +3823,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 	}
 	p->swap_extent_root = RB_ROOT;
 	plist_node_init(&p->list, 0);
-	plist_node_init(&p->avail_list, 0);
 	p->flags = SWP_USED;
 	percpu_up_write(&swapon_rwsem);
 	if (defer) {
@@ -4260,7 +4238,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	 */
 	si->prio = prio;
 	si->list.prio = -si->prio;
-	si->avail_list.prio = -si->prio;
 
 	/*
 	 * Publish swap_file before making the percpu ref live, then add the device
@@ -4409,14 +4386,16 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
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
 

