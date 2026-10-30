Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E91606A329
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 18:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=hVbj95Uf
Received: by kanga.kvack.org (Postfix)
	id C83716B05B1; Fri, 30 Oct 2026 14:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33036B05B3; Fri, 30 Oct 2026 14:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B48B96B05B4; Fri, 30 Oct 2026 14:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9169C6B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:32:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 887538079A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 18:32:18 +0000 (UTC)
X-FDA: 85380137556.27.C0186B9
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6B79620005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 18:32:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hVbj95Uf;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793385136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SmhaNZx9fzAsP3d5pmW+pPxvxrjdQVasbzqQOyPPKdo=;
	b=X7ny5us9O3r63RXPwx5IbcI/Bs3tUxx3xhV46PNQJPpxcqJF7x8SyvGGCAcZyjIXlpFH0p
	YmMRMKdHpzk1wu/pRq+FJS6g1RDi+cb06CjtWpa/s3vM4mvkQoRkWO7vQxllAGCTTSExsk
	EOJPqo0CuJFH/CkOtJW9B4dtr31RzVs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hVbj95Uf;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793385136;
	b=cr5xXKqguKwG3shMdptKv3dD5FK56DuXnvLpWdWeVtwsYIlDIaIxeMwor9h5drICk2Kg1u
	5W2bxdJOFdrSnMRKWk30JscLetO94OydkE1q0IMGNn2u4+Il64CZtPJeAQW816+VBUS5Mt
	2SODXWbiJYClnfBNWdIvhqHWEC2nHa8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=SmhaNZx9fzAsP3d5pmW+pPxvxrjdQVasbzqQOyPPKdo=; b=hVbj95Uf9oJvIeAQES6vymLH/j
	wKuzMjROSMhvF8gwrne+31UshGKyvIZ94yq49SJuKr0jq2FRRSmciwYsM7YIvPyj5imTltcBMrtM6
	Xtskm4Z5ye5w8yGkDzMKgkq78skBHsnIcqB+dYzX89XukVEM7B4TixkeJuvqoCiVggCrwVG7gPsjP
	1OOCYj2cI3yB4NxENHdplwFvwOQImAHnZ7zlNy19tFdd1ArdncLZrrIA/bFWvYMxfX/+bZdpFEu+n
	VUgSeRiawR46HouMDGDrCdzGhPODXB3wzt/lM/GUXdMf+y+ZYlxAvVQEmNdQhcgaBUo1Wy1hR1l+C
	eN3NbUDQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xMrOb-0040uF-2z;
	Fri, 30 Oct 2026 18:32:10 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 30 Oct 2026 11:31:10 -0700
Subject: [PATCH v2] mm: kmemleak: scan modified objects as soon as they are
 grayed
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-kmemleak-gray-drain-v2-1-3ec29a96668e@debian.org>
X-B4-Tracking: v=1; b=H4sIAG3i5GoC/22NQQ6CMBBFr0Jm7Zi2SkVX3sOwKHQKI1JMi0RCu
 LuAcefyJf+/N0GkwBThkkwQaODInV9A7RIoa+MrQrYLgxJKSyFTbFpqH2QarIIZ0QbDHp3NhNT
 C2fNRw/J8BnL83qy3/MvxVdyp7FfVuqg59l0Yt+wg192voP8WBokSD+okVKqdLTO6WirY+H0XK
 sjnef4Aa/H7O8kAAAA=
X-Change-ID: 20261015-kmemleak-gray-drain-fd80160fd946
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=6632; i=leitao@debian.org;
 h=from:subject:message-id; bh=Am15vGy4KAT+0gKSou3UJAm8KE5mqNB0nSviaBtOpGg=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq5OKm9gbp1quqr7syMzZeIrmtcUtbY0rBcskXP
 8jLe9DqKu+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCauTipgAKCRA1o5Of/Hh3
 bTP1D/93vZdWtXAgQ/ZWYTKCd4Zo3+u2tNGXofD71UzmXPugdegMEu59HaVSvyd8/dOI00GmUTS
 RVHjUAlmgX1tA6tBV0+UEjC/XGcbYxv/PhrbRrXQ8DUl0zQJ4y/ObrG17yanhYIZh+QHaIJzu0z
 p6vhii17vZA7h53+r+6bmsE/05gyJ3BET++tXIttgdRwbT7+GUHnFV0RyfynoshHr777UD0+5uW
 VlqZBWUNxPiOxK4rvbLJakYLnYFV6EW9LyJWzViSbFk02gxkIjTqbHB449kRHAHyfDvoHBK18XH
 stBYEVDFjsz2g3DLm2U7YSH4CmZJIT9OPAZpv9DXX8cKxSq7Fc2r8mVGFuUEa+kuwWtmak5nb9e
 m/qSRKYdLegwJvP0ZMuOtT3ZnFcybphBjG0w7TyYsd6PQ7whCSEseWVQrLaXeRp52WZjvM1zaFj
 /gpEfNRMJVu3FDVgpSxkOZTQdh3hFE+55wnDwhELU7HXxaYSl10vBXmU0HkCLkMCjmiie0mIXjO
 5yQP1yggPxqVlI9elSRRam9vl0hWYr6Ga+ukgAMtykB6aeunF51U8UH+rEXATEfm3LEXUWlJAss
 pdUQfcvxvfQN8UiD4ehWXit/6HxqL1JYbqhx5zZxdth253c8KYYxEQYJ+pCryfgo2YNwVQHeJnN
 E5/akRAq0HEATtw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 6B79620005
X-Stat-Signature: i3xo9r68d91zgxp6yap9yyuftanrqk6y
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793385137-943824
X-HE-Meta: U2FsdGVkX19pTY+Ck03MIptNCb5ER9T/wa7Chf2P1HXA3T+Nf8YezdQBZM2d5x2yH7PFhS2F31u4vDoxydOp1ARvOcZzYJtBsqW91kCMzfjF2+g2iywyY+AKLXSlh87d70QnryKbxMt9Um4B/xwfmYjdNifOJwliYNufmbW/K/Kjexwfow1tPOMluqLyxH6IP98Sv+W6XxKIEdIG+dCSolZon5HjX4CpXxY9SrevfUqcJ/vU1rao0OzTCMr85M9fqymMbFZawKTDKV3a+ODwkapda78fR74awK4Q0fMHtsOKfaliQoZt/k5J4e6Ibof1xnQ3U1UKUO1z+RI5Vu5Cq1eN8ffcrZSf5Z7yA18gbn1wJ4zycizHVHGfKeOCdpwG/42WuNfV6gqE+Dar7fH+/EvQ7nlXw7njhL/IPAlnJRVSBT5vQjO6G6e8SOQpkmmEmKAqRRIPiFpYtg7UYfq5PEATs3TZ7M91qYM0YDT4hu2DIu6uJK/Vo2ktTHSh/QhEYSy16ZU+QjBfWPyo0bAJiEZGf/0f/UghsYzauSyxl38gqEGBmKG3tx4VglGtJiqx614T6y0T+2MnbTSqzVYkU3S3eIrqxTvnQ/cn5RN7npNAQDM9IAMT01IjHQ7mlcH6yWWqopujTExxL3EKp5dAb6U6WMQvuq1xS+WX9N/ZRN7iAQgbiOJrdpu9ZbrXWCnlNjkv5USxlYmIEW2QLKDbV3LaHfQILU86WzUKW4AD0lVIBOiOqA2/JFw2A0NCNlasSzklyIukeP/zaY9JNpBzYGkiLnzmsgYL8k5h9aWxpegG0w0YCiEnSSSlLN1q6QUjd/PxNBUueE+M8UHDT2bvoF9fBR5H0AtQqWIV6gTWtXWmpI37owzh/FQRo6kJSYiNLsAaViiOjDqXjCoTLCFtLceOlkt2Lfe9TDvLlaL+/e0EX7i3yUmDGfEmB1plYL8lV1vQg7JhkOEHRWI+wBW
 u9a0KXKU
 LInHjTEEQw92huIBUe/nXSHxr4Z4SmDDEPsQ7YxvGhIrdIfX2LB5OOO9Rf4265zU33SvnnV/wPbQV9sZA+OVmid+mikg5rOodWKVmTyJ7I6iA1daLgWT39zZ0IKkjHr5AbLP3nGBbtUIrL8RLffQwXxTktOmGRaeZLMNQ/ObVX3RIfG/A+kv5Wc4SAJIvP1bUu5ysQ6gUBRYCxcxsFSIT2o9E2ZUtcmCVRmjFMsMpCiqv6E957zAQHc3FWemdldPSnUuCEUBZp69OePFi+1exZIuOvYU8i0ByGu2X/pAu6ZGfOD4Uo2wE2TXjLCRA3+ry2z1pyBzsN9KPC9WI0sF7iOBJK2dyqWtbU0K5uCpHwEZ7yHuOV2faiA5FQKPPlhdCGv619TuwOvu/hXqqM6CuqVZyXWSVFxwpr9uEXt0+IvlBZ6fqRLYncQcu8ZNQh8YCDCw3wyS3pauBTVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kmemleak keeps reporting the guard page of a systemd-journald thread
stack on Meta's debug kernels, even with min_unref_scans set:

  unreferenced object 0xffff88829a30ae40 (size 256):
    comm "systemd-journal", pid 961, jiffies 4294814590
    backtrace (crc 49b3881c):
      kmem_cache_alloc_noprof+0x2ee/0x630
      vm_area_dup+0x36/0x750
      __split_vma+0xef/0x7d0
      vma_modify+0x11c3/0x18a0
      vma_modify_flags+0x1ea/0x2a0
      mprotect_fixup+0x249/0x630
      do_mprotect_pkey+0x531/0x820
      __x64_sys_mprotect+0x7c/0x90

The VMA is still mapped. It was never faulted in, so it has no anon_vma
and no file, and the only pointer to it is a slot in a maple tree leaf.
The mm tree runs in RCU mode: every write replaces the leaf with a copy
and frees the old one after a grace period. journald rewrites its tree
every couple of seconds, while a scan on a large debug host takes many
minutes, so the leaf kmemleak queued is freed before its turn, and the
copy that replaced it was linked after its parent had been scanned.

The pass over modified objects is meant to catch such moved references,
and the new leaf, being a new white object, does get grayed there.

But the gray list is only scanned after the whole object_list walk, and
by then that copy has been replaced and freed as well. The confirmation
scan has no such pass, so the miss repeats round after round no matter
how many consecutive scans are required.

Scan the gray list during the walk instead, within a jiffy of an object
being grayed. Do it from a variant of kmemleak_cond_resched(), which
already pins the current object while the RCU read lock is dropped. The
live leaf is then read shortly after the walk reaches it, before it can
be freed.

Scanning the gray list after every grayed object made a full scan 41%
slower (1.72s -> 2.42s, arm64 guest with lockdep) when the pass grays a
million objects that do not point to each other. Scanning it at most
once a jiffy keeps that at the baseline, leaves idle, file storm and
mmap churn workloads unchanged, and still removes the false positives
at HZ=100.

I was able to come up with a reproducer that reproduces these false
positives most of the time:

https://github.com/leitao/linux/commit/1291579c487303c5ffbea2cf532649d26329c8a9

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v2:
- Keep kmemleak_cond_resched() and its callers as they are. Pass 2 calls
  a new kmemleak_resched_drain() helper, which decides when to scan the
  gray list and calls the new __kmemleak_cond_resched() (Catalin). The
  other two callers keep need_resched() and are not touched.
- Scan the gray list at most once a jiffy (Catalin). Doing it after every
  grayed object cost up to 41% of the scan time in a synthetic worst
  case. This part can be dropped if it is not wanted.
- Add the scan time numbers to the commit message.
- Keep Catalin's Reviewed-by, as both changes follow his review.
- Link to v1: https://patch.msgid.link/20261016-kmemleak-gray-drain-v1-1-3270256fdc8e@debian.org

Tested on an arm64 virtme-ng guest (8 vCPUs, lockdep, HZ=1000,
min_unref_scans=1), two boots of ten scans per kernel, same base:
- Guard VMA reproducer: base reported live guard VMAs as leaks in 19
  of 20 scans (up to 106 at once) and needed a confirmation pass in 17.
  v2 reported none and never needed one, so a scan took 13.6s instead
  of 26.4s.
- Pass 2 graying 1M objects that do not point to each other: base
  1.74s, v1 2.46s, v2 1.73s per scan.
- No lockdep, RCU or WARN splats in any run.

The v2 changes, the changelog update and the measurements above were
done with Claude Code (claude-opus-5-5).
---
 mm/kmemleak.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 8fa409a4f9fb26..7e24408ba83821 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1696,8 +1696,10 @@ static void scan_gray_list(void)
  * Conditionally call resched() in an object iteration loop while making sure
  * that the given object won't go away without RCU read lock by performing a
  * get_object() if necessaary.
+ * If @scan_gray is set, also scan the gray list while the RCU lock is dropped.
  */
-static void kmemleak_cond_resched(struct kmemleak_object *object)
+static void __kmemleak_cond_resched(struct kmemleak_object *object,
+				    bool scan_gray)
 {
 	if (!get_object(object))
 		return;	/* Try next object */
@@ -1709,6 +1711,8 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
 	raw_spin_unlock_irq(&kmemleak_lock);
 
 	rcu_read_unlock();
+	if (scan_gray)
+		scan_gray_list();
 	cond_resched_tasks_rcu_qs();
 	rcu_read_lock();
 
@@ -1721,6 +1725,26 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
 	put_object(object);
 }
 
+static void kmemleak_cond_resched(struct kmemleak_object *object)
+{
+	__kmemleak_cond_resched(object, false);
+}
+
+/*
+ * Scan newly grayed objects within a jiffy, not after the object_list walk:
+ * one may hold the only reference to another and be freed by then, like a
+ * maple tree node being replaced.
+ */
+static void kmemleak_resched_drain(struct kmemleak_object *object,
+				   unsigned long *last_drain)
+{
+	if (need_resched() ||
+	    (!list_empty(&gray_list) && time_after(jiffies, *last_drain))) {
+		__kmemleak_cond_resched(object, true);
+		*last_drain = jiffies;
+	}
+}
+
 /*
  * Scan all task kernel stacks, rescheduling between tasks. Each task is looked
  * up and pinned within its own RCU read-side section, so no lock is held across
@@ -1863,6 +1887,7 @@ static void dedup_flush(struct xarray *dedup)
 static int __kmemleak_scan(bool full)
 {
 	struct kmemleak_object *object;
+	unsigned long last_drain;
 	struct zone *zone;
 	int __maybe_unused i;
 	int stop = 0;
@@ -1979,10 +2004,10 @@ static int __kmemleak_scan(bool full)
 	 * Check for new or unreferenced objects modified since the previous
 	 * scan and color them gray until the next scan.
 	 */
+	last_drain = jiffies;
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
-		if (need_resched())
-			kmemleak_cond_resched(object);
+		kmemleak_resched_drain(object, &last_drain);
 
 		/*
 		 * This is racy but we can save the overhead of lock/unlock

---
base-commit: 587858367581b9c55c3690f4e63382ad622719d4
change-id: 20261015-kmemleak-gray-drain-fd80160fd946

Best regards,
--  
Breno Leitao <leitao@debian.org>


