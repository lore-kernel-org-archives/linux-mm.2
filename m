Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17B63606A33B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qEGULJWY
Received: by kanga.kvack.org (Postfix)
	id 3690D6B05BC; Mon, 23 Nov 2026 09:16:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319E66B05BD; Mon, 23 Nov 2026 09:16:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207956B05BE; Mon, 23 Nov 2026 09:16:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC1A26B05BC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:16:34 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7649C1208D5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:16:34 +0000 (UTC)
X-FDA: 85466584308.22.A80863F
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id A19831C000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:16:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qEGULJWY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443392;
	b=Ari0OlziM7viBieLsqQXI8W6xw6N8bENKKswD7LuSFjIRAw//oRMtWFrv3zbYYCJdmVo8O
	JZPT0PlUTfTn7oISm3lD5CABRs0Q/h1VKHftdjQAPXEU/bxgEsjLVyL0uz3tGJ4rSuMZj7
	iYpMnOeRjq/l6UYZdl/lhpBwLlsEqcc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5wwuF3qNxJTr89B9mUIXsNBaKeE0BrKs6qw9tATjs8=;
	b=KzMLYY1rOv7BwBYlfaR6F7mXrxO5n6/n/Z1zsvM5SU6iF12rxNdQojfdKm3R0UGiBzZ34c
	a3Cxb5OQ+vD3ky8T6jUYZEIp3JUdrjt99z5ohTvbgg7IZLLNbTjzy3gOlz/oulbjlgsHSg
	eiQdPD1WcvAJI63eB+dL9x8AQWfzxRg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qEGULJWY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-38644aedba1so4948743eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443391; x=1796048191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N5wwuF3qNxJTr89B9mUIXsNBaKeE0BrKs6qw9tATjs8=;
        b=qEGULJWYTSApbAthbe9w9Lv6xOJFAqVONsFYQw6EJ7bdRWJJA1R3kg52NemNqMt3Xu
         CJ3hpO6YQ3VPQ7gquMLQK292APd4Y4IyWY9833OI9fgoALIZpa+EeKjxrdYh2PkuGjqA
         80vj/iRYzErgso/NpUa+9gh6Ld7XJbjuibM6XjUkXnesCi+KGSNvhFVhc40TEVFrdL4K
         BGZu4QqMo7Yp4qAuR6xh6Cg0vBWzda+t0wi4PeXC/MBMH9JyW+tg335/H/hQh7JAdm8n
         UFgE9qcHJ89VBOJ6HCof8WKDRjtP4NDawYGONHW+UnE1LUPx8vq4ZC9LVFDm1ZaTQouk
         8ntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443391; x=1796048191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N5wwuF3qNxJTr89B9mUIXsNBaKeE0BrKs6qw9tATjs8=;
        b=tghZvOKpkTDW77kRBfNS7zvFW+0hH3BRXQkXJb+P3aBCwGSKYgvhTygp1NqE5EOVwi
         AQjJ36U40srCLGAToCrHxELUvTbLsllsijtuOvTk1+Xb9xe+d/Nl4V23WKre8sXdh0c2
         qgPw+JAaYJzkOf2Nt2I5dSHRQMsjRFcg9huhwF/S4df22Z8hBLztTUFebnbw/QUz5w0H
         LA5Wt+8fN5a7rDAAT8L7uw4+NnMxf5mJb1EkpXBqkhS93Bj+gF88vhAmZqY4x8w3zRQJ
         SlnPzwaT2Q0fhY8vDCiLvdSJT6Gy3ZXKFRnlXkxz79mEnqwZFTJqvWZfBXmSY4oKtH6w
         +oSg==
X-Gm-Message-State: APuU4Z9KHhKAhBS0yYo54VIQhSIl8SJsO5u8SGwHb6AJM+/GTY2cu0ku
	9IEguvwSxuzPnkaZkm1CPoet8yHMcGUXf2VmG1Tx04TvjSJuTP58YXDCFQlr66y2
X-Gm-Gg: AZFdTZfvzd1h6blJ8wvrdyE4ut9vOBE5/ibhw8uqIBYojBurWbLPL7UNaPHTbiulseY
	SM5T8kf4WcO4b8LSAUoZMFTZgSLYHcgIbxsx8A/NtZzYumtq0nfFBs56KVvjQlJq2UxDpPdiohI
	lFEWaux7+C0b/w0KuvFCO9x1MM2P4GBhdEjyPCmJYY4fpNkwQJDpTgA7MS2N9eFTQCibYZpVSzo
	gtWdBpo5L20umzLac0vzeaJ6bv971EzpwkJPTXClmQAr+c+95tTMST4WGVNeWQ1+xtf7UEL486q
	skO3WL5aTocOb+hu7f5SyuKm1lK1z9i+ff1G7Y6icW3COaWUU2kNklmnIc+XP8cC3G6mTgQhnNV
	yCuguOnMKRE0UjP2aKGgj3pV0zk8uILoStKjFmGIdkVmPuxbGD/mL7gMpvfr7ftM6e4juTgH3M5
	4meZ2AlQ1M7I+yDExsOC44YSWtOuI7/5SLibKALLlz+nfJf254mDat+haXOTc2IluZMf5sxiU1R
	3J8Yv08mtpxoB7YkQV1Qa/NSzvJbxFY9PMWn77ysVvAnPNny6iKHwhmjAzK+zNiYfXPUqYjJQmG
	fcc5E3MuDCLT3OU4YhkPUCxo9cwrgQOBXSb/iJoWdk/ahD33JoGt34q5yOXmM2n7+ao0SbpA1kf
	FfjeMYGM4bQjq4A==
X-Received: by 2002:a05:7301:4718:b0:369:1401:c5c2 with SMTP id 5a478bee46e88-3857025806bmr11873030eec.26.1795443391256;
        Mon, 23 Nov 2026 06:16:31 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38566cd4efesm37911629eec.12.2026.11.23.06.16.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:16:30 -0800 (PST)
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
Subject: [PATCH v5 03/19] mm/swap: cleanup and document swap device availability flag usage
Date: Mon, 23 Nov 2026 22:16:21 +0800
Message-ID: <5a83cfe8b0992c65cf4cca1e8cd612b4de0b78c6.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A19831C000F
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: qzsnw9b3cspjd4t4tt6q1jjicyned3qk
X-HE-Tag: 1795443392-852908
X-HE-Meta: U2FsdGVkX18KFnc/rcyO0a79qq9RE75IFWnk9mRV/KmE45WSgn5FURlMabvFtpEZ0lYbxw88GHoVIKOdMunhhscmRVPNLNa+k7yhtren0p74jehh+ajPEr1dGJaaC5IQpyiK16Isd6BBlzBpKMQ0vR/7uqbE7Ppepn6MFmvX/oeg/5+/E8dCf+YHQ0RnJoWY1FncjuWdOFQKrmGSTGOCKhNWbxYHp2Lw4np0O+cXGnhwFeB03rcb9Drwxg+xDOivEepyV4FDCL+2r0CsBRxAgkYJoqo8uUTyMUa7LRmT04jyw0/YwJphfuSXfGnaZOUEeFk9GyDYS+TNuOQbp794ocDQPRriY/E+HO6AA3FW3Hy2wIN7RgqV7wmKLCx7yB6Ze8s+JHxjqGBAWtLO+8DqKcxgMK/6DpFcMVgNUjlxGvEFV4nC8da+2vqmU6jk/P52I3E4Y57ujoDzdZ7bilItMkK+76HyHch8bTCW9YYf+AkOO43R+gvn71150WrliT0MIZI6DR8aIcBRNrwogcZjS6xTXETRqGMyrBRMT8OTX5Dz3FvCj5YhkfC0BXly+QNG87IJTL1gsI48kvnjhBdzO4QW1SzdNzA0x63ZIlvnl4N3yNPB/+LOg1NHfYHtbU56BvRsuWwBrtOH2iB4vCZ5p15MnZ6rElGIXi717NJNEndksQ6eZazAEsfqyCSLQGIBbf6BMSZphs/6GvefSRUHPFK2Ue3YqBsgTb9rI+gOd0mEv2uLBjlMF1dM3lbe6nO91koLnDDYKYp+nYMOG8aQns9lvEvTKltQasbZ4tz7ONjlREAoe1j/CH7LNQScBEG8ag9saqzRQBh8zlY44lg1yDIxiX96WqPhBw0a3x3XMHuOMnh894YRQfmhuIn+1s7PMgHdfZ017c3BEshO40qadakaEIldhXBHpnvBpANJMXocVxeEz0oa6K8PuBv0fgcGcQZex50q3zFJWjxMKaC
 8BrPKKEH
 iwr9yQsYCWccrVkiCIy5iE0tNQXFxcRbb4cf33VN8saz6k8TI3TqYlDqfJksMMcPRosIaKiMVqr2vmiJHoPXjmhQ8AHGgx50NFN/ZvWumtRt0Q6gkeo1+q7hB/DISoB/dkweBu8dq0IclHn9Ta3ZQErTW+qf+GPK6YdETHhzBCKx9KPE/FSyFS7cga8Mp0795N2yUlLJyi0mr7XFBJPfujU2Q7YER09+ut0yuRcyPeCoX6yoRVEw/SskhydxXmYU/zshDKtjm6WNm+ZPeOkBLs3ZDtMm0EJmvFr5aTaIDBacxe8iapo5FYMcoEVwPLw9u6unxU35ePBI9cWmXxy0QHjbRNmjdRhYI5rtjNOHCa7xgjBch7RltfFFwR3+HXn91f3Sefd1aFV/o5ywUAEVfZU0iYCl/FJsZ7OnHDFb5ZnfqoJoSKNi48g89Ag5Yn7B3K+7Z9C1wC602XNcz9ea+g9q5v8lTnCIDWwRAu7fx+LSgHjteWGsVvvUxjZonVHQzlrtyY+ISuZZ9YJ4EZWGcczyUTdC/k0/ACMpXAXeHjXtHgVssWWEELQNdeDAbn1kDxENjt7TAr85SYPJzythB47BjrpSVEi8EAdIg4aexjIuE3TzuzbuX6Gf01DP63u8+zHo2cy1b/Q8rxF9v9aAxg4/v4m+8vKbvp1OgRlB6fEgSGwd2m1S9dGBL2X3sZfRncxYW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Rework swap device flag and metadata handling to make the writable
publication and disable boundaries explicit.

Introduce swap_device_enable() and swap_device_disable(). Move
SWP_WRITEOK updates into these boundaries. Clear the writable flag,
set the off-list state and remove the available entry in one
swap_avail_lock critical section, before releasing swap_lock.

Preserve the existing swap_lock critical section across mapping lookup,
hibernation checks and the disable transition. Drain cluster allocators
after dropping swap_lock, retaining the device-identity protection
without holding swap_lock over all cluster locks.

Document the flag lifetime and locking rules.

Signed-off-by: Kairui Song <kasong@tencent.com>
Co-developed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/swap.h |  29 ++++--
 mm/swapfile.c        | 205 ++++++++++++++++++++-----------------------
 2 files changed, 118 insertions(+), 116 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4f686709d71f..0fa77f5679a2 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -188,6 +188,24 @@ struct swap_extent {
 	((offsetof(union swap_header, magic.magic) - \
 	  offsetof(union swap_header, info.badpages)) / sizeof(int))
 
+/*
+ * Swap device flags, except the ones documented below, all are immutable
+ * after exposed by swap_device_enable, and until the device is freed again
+ * (SWP_USED unset), except that teardown clears SWP_ACTIVATED after draining
+ * allocators and live references. The other exceptions:
+ * - SWP_USED: Protected by swap_lock. Indicates the device is inuse. Once
+ *   set, won't be cleared unless all reference to this device is freed and
+ *   swapoff finished.
+ * - SWP_WRITEOK: Protected by swap_lock, si->lock and swap_avail_lock.
+ *   Clearing this flag is followed by waiting for all current cluster lock
+ *   users to exit, so
+ *   checking this flag while holding any of these locks ensures the device
+ *   is safe to use at the moment. Note: clearing this flag doesn't affect
+ *   pending IO or async requests, it only prevents further entry allocation
+ *   or new async request (e.g. discard) from initiating.
+ * - SWP_HIBERNATION: Protected by swap_lock. Indicates if the device
+ *   is pinned for hibernation.
+ */
 enum {
 	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
 	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
@@ -256,14 +274,9 @@ struct swap_info_struct {
 	struct file *swap_file;		/* seldom referenced */
 	struct completion comp;		/* seldom referenced */
 	spinlock_t lock;		/*
-					 * protect map scan related fields like
-					 * inuse_pages and all cluster lists.
-					 * Other fields are only changed
-					 * at swapon/swapoff, so are protected
-					 * by swap_lock. changing flags need
-					 * hold this lock and swap_lock. If
-					 * both locks need hold, hold swap_lock
-					 * first.
+					 * Protect cluster lists. Other fields
+					 * are only changed at swapon/swapoff,
+					 * so are protected by swap_lock.
 					 */
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0ae901296731..f22197a6286c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1268,28 +1268,23 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 
 	spin_lock(&swap_avail_lock);
 
-	if (swapoff) {
-		/*
-		 * Forcefully remove it. Clear the SWP_WRITEOK flags for
-		 * swapoff here so it's synchronized by both si->lock and
-		 * swap_avail_lock, to ensure the result can be seen by
-		 * add_to_avail_list.
-		 */
-		lockdep_assert_held(&si->lock);
-		si->flags &= ~SWP_WRITEOK;
-		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
-	} else {
-		/*
-		 * If not called by swapoff, take it off-list only if it's
-		 * full and SWAP_USAGE_OFFLIST_BIT is not set (strictly
-		 * si->inuse_pages == pages), any concurrent slot freeing,
-		 * or device already removed from plist by someone else
-		 * will make this return false.
-		 */
+	/*
+	 * Force remove it only for swapoff. Else, take it off-list only if
+	 * it's full and SWAP_USAGE_OFFLIST_BIT is not set (strictly
+	 * si->inuse_pages == pages), so concurrent slot freeing, or
+	 * concurrent list removal will make the cmpxchg fail and skip
+	 * the removal.
+	 */
+	if (!swapoff) {
 		pages = si->pages;
 		if (!atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
 					     pages | SWAP_USAGE_OFFLIST_BIT))
 			goto skip;
+	} else {
+		lockdep_assert_held(&swap_lock);
+		lockdep_assert_held(&si->lock);
+		si->flags &= ~SWP_WRITEOK;
+		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
 	}
 
 	plist_del(&si->avail_list, &swap_avail_head);
@@ -1299,21 +1294,21 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 }
 
 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
-static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
+static void add_to_avail_list(struct swap_info_struct *si)
 {
 	long val;
 	unsigned long pages;
 
 	spin_lock(&swap_avail_lock);
 
-	/* Corresponding to SWP_WRITEOK clearing in del_from_avail_list */
-	if (swapon) {
-		lockdep_assert_held(&si->lock);
-		si->flags |= SWP_WRITEOK;
-	} else {
-		if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
-			goto skip;
-	}
+	/*
+	 * Add the device to the avail list if SWP_WRITEOK is set and
+	 * SWAP_USAGE_OFFLIST_BIT is still set. Swapoff clears
+	 * SWP_WRITEOK first, so the device won't be re-added after
+	 * swapoff starts unless swap_device_enable resurrects it.
+	 */
+	if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
+		goto skip;
 
 	if (!(atomic_long_read(&si->inuse_pages) & SWAP_USAGE_OFFLIST_BIT))
 		goto skip;
@@ -1369,7 +1364,7 @@ static void swap_usage_sub(struct swap_info_struct *si, unsigned int nr_entries)
 	 * add it to the plist.
 	 */
 	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
-		add_to_avail_list(si, false);
+		add_to_avail_list(si);
 }
 
 static void swap_range_alloc(struct swap_info_struct *si,
@@ -1421,7 +1416,7 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	 * up to dated.
 	 *
 	 * Paired with the spin_unlock() after setup_swap_info() in
-	 * enable_swap_info(), and smp_wmb() in swapoff.
+	 * swap_device_enable(), and smp_wmb() in swapoff.
 	 */
 	smp_rmb();
 	return true;
@@ -3140,58 +3135,88 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	return generic_swapfile_activate(sis, swap_file, span);
 }
 
-static void _enable_swap_info(struct swap_info_struct *si)
-{
-	atomic_long_add(si->pages, &nr_swap_pages);
-	total_swap_pages += si->pages;
-
-	assert_spin_locked(&swap_lock);
-
-	plist_add(&si->list, &swap_active_head);
-
-	/* Add back to available list */
-	add_to_avail_list(si, true);
-}
-
 /*
- * Called after the swap device is ready, resurrect its percpu ref, it's now
- * safe to reference it. Add it to the list to expose it to the allocator.
+ * Mark a fully initialized swap device writable and expose it to the
+ * allocator. The caller must have resurrected its percpu ref first.
  */
-static void enable_swap_info(struct swap_info_struct *si)
+static void swap_device_enable(struct swap_info_struct *si)
 {
-	percpu_ref_resurrect(&si->users);
 	spin_lock(&swap_lock);
+
 	spin_lock(&si->lock);
-	_enable_swap_info(si);
+	spin_lock(&swap_avail_lock);
+	si->flags |= SWP_WRITEOK;
+	spin_unlock(&swap_avail_lock);
 	spin_unlock(&si->lock);
+
+	atomic_long_add(si->pages, &nr_swap_pages);
+	total_swap_pages += si->pages;
+	plist_add(&si->list, &swap_active_head);
 	spin_unlock(&swap_lock);
+
+	add_to_avail_list(si);
 }
 
-static void reinsert_swap_info(struct swap_info_struct *si)
+static int swap_device_disable(struct address_space *mapping,
+			       struct swap_info_struct **swap_info)
 {
+	struct swap_info_struct *si;
+	struct swap_cluster_info *ci;
+	unsigned long offset, end;
+	int err = -EINVAL;
+
 	spin_lock(&swap_lock);
+	plist_for_each_entry(si, &swap_active_head, list) {
+		if ((si->flags & SWP_WRITEOK) &&
+		    si->swap_file->f_mapping == mapping) {
+			err = 0;
+			break;
+		}
+	}
+	if (err)
+		goto unlock;
+
+	/*
+	 * Refuse swapoff while the device is pinned for hibernation.
+	 */
+	if (si->flags & SWP_HIBERNATION) {
+		err = -EBUSY;
+		goto unlock;
+	}
+
+	if (security_vm_enough_memory_mm(current->mm, si->pages)) {
+		err = -ENOMEM;
+		goto unlock;
+	}
+	vm_unacct_memory(si->pages);
+
+	/* Serialize with the WRITEOK check in isolate_lock_cluster(). */
 	spin_lock(&si->lock);
-	_enable_swap_info(si);
+	del_from_avail_list(si, true);
 	spin_unlock(&si->lock);
-	spin_unlock(&swap_lock);
-}
 
-/*
- * Called after clearing SWP_WRITEOK, ensures cluster_alloc_range
- * see the updated flags, so there will be no more allocations.
- */
-static void wait_for_allocation(struct swap_info_struct *si)
-{
-	unsigned long offset;
-	unsigned long end = ALIGN(si->max, SWAPFILE_CLUSTER);
-	struct swap_cluster_info *ci;
+	plist_del(&si->list, &swap_active_head);
+	total_swap_pages -= si->pages;
+	atomic_long_sub(si->pages, &nr_swap_pages);
 
-	BUG_ON(si->flags & SWP_WRITEOK);
+	end = ALIGN(si->max, SWAPFILE_CLUSTER);
+unlock:
+	spin_unlock(&swap_lock);
+	if (err)
+		return err;
 
+	/*
+	 * The swap allocator doesn't take swap_lock. Looping through every
+	 * cluster lock after clearing SWP_WRITEOK ensures that allocators see
+	 * the updated flag and that no allocation remains in flight.
+	 */
 	for (offset = 0; offset < end; offset += SWAPFILE_CLUSTER) {
 		ci = swap_cluster_lock(si, offset);
 		swap_cluster_unlock(ci);
 	}
+
+	*swap_info = si;
+	return 0;
 }
 
 static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
@@ -3236,7 +3261,6 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 	}
 }
 
-
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
@@ -3245,7 +3269,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct address_space *mapping;
 	struct inode *inode;
 	unsigned int maxpages;
-	int err, found = 0;
+	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -3258,44 +3282,11 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		return PTR_ERR(victim);
 
 	mapping = victim->f_mapping;
-	spin_lock(&swap_lock);
-	plist_for_each_entry(p, &swap_active_head, list) {
-		if (p->flags & SWP_WRITEOK) {
-			if (p->swap_file->f_mapping == mapping) {
-				found = 1;
-				break;
-			}
-		}
-	}
-	if (!found) {
-		err = -EINVAL;
-		spin_unlock(&swap_lock);
-		goto out_dput;
-	}
-
-	/* Refuse swapoff while the device is pinned for hibernation */
-	if (p->flags & SWP_HIBERNATION) {
-		err = -EBUSY;
-		spin_unlock(&swap_lock);
-		goto out_dput;
-	}
-
-	if (!security_vm_enough_memory_mm(current->mm, p->pages))
-		vm_unacct_memory(p->pages);
-	else {
-		err = -ENOMEM;
-		spin_unlock(&swap_lock);
-		goto out_dput;
-	}
-	spin_lock(&p->lock);
-	del_from_avail_list(p, true);
-	plist_del(&p->list, &swap_active_head);
-	atomic_long_sub(p->pages, &nr_swap_pages);
-	total_swap_pages -= p->pages;
-	spin_unlock(&p->lock);
-	spin_unlock(&swap_lock);
+	err = swap_device_disable(mapping, &p);
+	filp_close(victim, NULL);
 
-	wait_for_allocation(p);
+	if (err)
+		return err;
 
 	set_current_oom_origin();
 	err = try_to_unuse(p->type);
@@ -3303,8 +3294,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	if (err) {
 		/* re-insert swap space back into swap_list */
-		reinsert_swap_info(p);
-		goto out_dput;
+		swap_device_enable(p);
+		return err;
 	}
 
 	/*
@@ -3364,13 +3355,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->flags = 0;
 	spin_unlock(&swap_lock);
 
-	err = 0;
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
-out_dput:
-	filp_close(victim, NULL);
-	return err;
+	return 0;
 }
 
 #ifdef CONFIG_PROC_FS
@@ -3792,7 +3780,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	/*
 	 * Allocate or reuse existing !SWP_USED swap_info. The returned
 	 * si will stay in a dying status, so nothing will access its content
-	 * until enable_swap_info resurrects its percpu ref and expose it.
+	 * until swap_device_enable resurrects its percpu ref and expose it.
 	 */
 	si = alloc_swap_info();
 	if (IS_ERR(si))
@@ -3960,7 +3948,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->swap_file = swap_file;
 
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
-	enable_swap_info(si);
+	percpu_ref_resurrect(&si->users);
+	swap_device_enable(si);
 
 	pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K((unsigned long)si->pages), name->name, si->prio, nr_extents,

