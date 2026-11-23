Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E17606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cx0aumIA
Received: by kanga.kvack.org (Postfix)
	id 8E6D26B05BE; Mon, 23 Nov 2026 09:16:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897D76B05BF; Mon, 23 Nov 2026 09:16:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE116B05C0; Mon, 23 Nov 2026 09:16:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51DE16B05BE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:16:45 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6DD2C08E8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:16:44 +0000 (UTC)
X-FDA: 85466584728.05.DFB1552
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id EC593180002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:16:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cx0aumIA;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443403;
	b=lGnHUzwSyJ+eWJ044iSCE/ccN8K26NM5Z218brXP13Ak/w3/doLYzex2cQIbHYmkihMb6P
	SYeUrlbU0J5BrgFcNwQXtS59iK438I0dVlLGP1YFGUs2rPfIacjJC2/zuUo/ecI2r/DOeQ
	/83fow0LubaYyO0uXPytPuhfL7mon1Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MB4ylRBWhpP977K7CxD8OdJrbMU3UJuzSG35QAoRMs=;
	b=FcLF95l6gNdMMdMSas8t5x4CTqh8jboKFd9Z/pE+7Y7t6vVZkhVJZoWYB34q/JQJGOvg+T
	sSy5Bx/Ruone8ltefTZ5DzvTaO0Odl6KuszupwFZXtTA0QzcNjs6vB44YmmBtTLCF8jUTm
	z+wN++Cs/ysWupRJOaVsFu59ZQu4GsE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cx0aumIA;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1a3c08d6928so4608023c88.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443402; x=1796048202; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6MB4ylRBWhpP977K7CxD8OdJrbMU3UJuzSG35QAoRMs=;
        b=cx0aumIAK+0rFFjLieWEImQ5w0REuBJ5KsO2+AEstNaEYAGAS2IDiuP5IKSUV6YLoA
         1CtGhkBTVoa3H6BrhPjv9J27dFl6YMJU4GrlMRFhAy3HuDk4MsFw1mNG89AvQyljX8gd
         hzvRhPxR8qgfQmMgh0Uvh2SBbWuYlVhBthWE0S/6TwNJVU6BzFKF2o7l+dtiyBhvE3Va
         Vbw5LCZ0/uQkY2Ga1AVaDCQpT55AYLSw8fEMTK6samb21mrc9RL8PG6mDrNDRjClGVo5
         BkbHON3ZoTkDhCM+tHXFQFnfQJQQXjhAfEVLYLT3DfWPOfvetNEcaNS5asb3lX0mzCGq
         XTjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443402; x=1796048202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6MB4ylRBWhpP977K7CxD8OdJrbMU3UJuzSG35QAoRMs=;
        b=2xCFW580wW14goysPRN1chA5dONndk97wKByiw4qFNJeQQPZ+L9DrvvAhQkheSsZfV
         jF0ESym3Jtr7JQw7JPBrOjeyWjVKF3o15t9cow+ct6l0SXrQSMnEgyi2Bo4hM1O8BG8V
         U0LiLqxojFD5fQzniMi7hxhymYDaxGuJ2tGEpENAEdObv/WYk8PL8EPcf4XMV/r5wwEd
         kXVNC4vbfxkvy53dwQJI2KDX2Rbbjeo3Qq6QH64GyiU/KKog/He4s9WtDTffaGvP8T3v
         GHAilbKFqcOzx05twlElUvnbPggywT0eXSleDkQ7o3YFwPGzQw1SVp3TNZ6ZBo+HwRnO
         dDKw==
X-Gm-Message-State: APuU4Z9QM9StZ11PB3W5DTHo5aYSQqaZImtuu84j/EyC3IaOblwO3Q26
	A/V0GGgRbcuuNPrL5EcKje0vr+nb29EpsAGCh3weLh3cNhpDf+MHUEKqmLquP7Qr
X-Gm-Gg: AZFdTZeH5ILpUJgZUi0VQCkUvHrIz9J/EG9Q0x75+ntvwI12KxdasMY7nKnIRchoN0k
	Fym7im6Xnua8JfhChZQqDW6PCstQTsfh6cNzK37eAlkHhpfJHHq2mlEpMhRd+QzqLPlzDXinF/X
	oxVQOtoKTDZw7bMCkAuUAQY28RH9zVi17aCJhGEk/n8bvsxdAMEKocBoWjipII1oyZ7aI2uh9q0
	RN+FTZe4Cg52qFaS/Z4xcTxSEhXqkT2BDAdOawMfqnPjgAr1+1Z7VveyihpR8rD4S4UgN/9itZ7
	Lw0nxf96H8LplCzig6/PRfEKP2leuH4lpyIm1nTXR4ZyydAmFz3IocwqfY80L+ZbIYTouQNdnOi
	4oSOx8hOJh6/mrraXAY2ZKn6xIk7ZJy0GFtPBWwSPYCTUDJQIM7xHNmBhKhYYr6q7pfLwvHGqm9
	ui56hmn8Z8HREFJoFhR6kjBwaf4gf0gQjqlD4lyxc7zuObQ5T5s3FtZPu7L60UDI9H1AeW1Oq0j
	BtB78Pj/+ICnfk4TSpcrc9yc7UWxg1UE3u2w6DSORChf69ouL8tjy3eVUB7k6jyO2jvLxy4Mkfc
	5YVuGnmUI6N0Y3bWk2xBpw6l3PSQ/efpod1+xhRYPBlzGWHRn+ZCEsDgNRY1mQiUR/j45xwK3LA
	=
X-Received: by 2002:a05:701b:240c:b0:1b5:7111:5c4a with SMTP id a92af1059eb24-1b571115c94mr3404520c88.26.1795443401226;
        Mon, 23 Nov 2026 06:16:41 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b55681301asm28642799c88.8.2026.11.23.06.16.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:16:40 -0800 (PST)
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
Subject: [PATCH v5 04/19] mm/swap: introduce swap device iteration helper
Date: Mon, 23 Nov 2026 22:16:31 +0800
Message-ID: <be6ef058f4a6babd3562270daa5b61c4ff9a6a50.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EC593180002
X-Stat-Signature: g5cgw1mpkkgp7z3huc45u71eydoyxepm
X-Rspam-User:
X-HE-Tag: 1795443402-15928
X-HE-Meta: U2FsdGVkX1/IHZlq+FWF0Am9zHFF1huRWBM/qw59kG6SpALUPz9JVY4t9RgGrqHMGowgpaDi4bMcQhfSv8WptDeP5asd7awoR1dSL9W0hHvAK2GhTeWOfFm9Xud0Rb4NKjwMsaJ/EI4rM7HQQ8F5CWYEPg4sB0NuxChT/3EAoF4Udfno5rtjxJ8dJ9c4pi5mmn8HqxbBnwF7g/nxaGXmG/RloAdDDw/l1neYYg653Z2xR5DJhaiA2OyQ8dB8xYgdUV7VLHHGsHUKccmpfJmQcMQjHLi85q1oWJEsGjCNofjNnIiXmcs0WihGh8p2x/nVb77qsQHepUCP5DVUnnrWE/TjJ06lnWuVTwzfvUnEAjkLvVOePn5wK0KV9+WBCZVKOuHgDHorz5cLOkHEOCvYWVKU1OO7FRFBdSxencdFptMnrg+M6wdlIy3LCEHLqCkKvWijMmvv4nfOwuKD6gOxjSZOjv2xm6pQI9Qc14wtN8pj+KoOsJKmkck2Daq49nWbuMubZq4HFAK9LuzRF3AHMsbhRG5l0xUIPz/dHP4H/eAursEso55joSz4bH8iTORAu+wAOuGF192W0euoVlIhF8GvG5fJ8JoJ4pOxy50WFAkOKkdqQFgW1/tw5WxPg14z3BULOtVAmzmUf0nKM3/SUbOkSDPTnYOM8A0mbPPJaXBJlxY+oEjncy/BdCoVUYMrVIbBVIr0bwAdFWHUjQv1ZwmPRznvkSB1aqj4YjX8XdB1TMCqDOhGT/q9+J/4Cg38mqbbFcdqIn+coogAqR20NUUIJ18tpRYv/NNX0+EUOgzEu6aKNpiy96JW5ZUorLv8Qqa/W8c7K0pwyJjVC8kC1dwhGtDEKljcu8ASyGbL8pouTQoeqY2XFw4FyuKWSKw99pGQDw8yLHwlcCNEI2B+3t0k0CdHNFBPN0zXPZSeoh6I2EYtEK3dYMOaFPMwTFMhGUDtR6ldPIXAbbnDcwc
 8DtubqPg
 3fd2e7ZMheF1muUdwDU2lSTl201B74QQwVfXjMcL0rwrZT9kVmWjIuyfQMRDFvawNZ29LnEm5QnbnO2epjEzudm47zw4HQeqRFt6W1PAa4obMul/ASTFHcNxDDQHZgXtU+nPkShoLXOS5Q34FtGyxAAiTkw1A1D7Qx0zzK76/oG52PK37gNmiEfP9G4RtnfjcQngS1VxdSNkHs52jbfEuzMgQ1yREhyKC6Q98hm5Y+hQ9edxlJaePiLQ+HiGC02THSAh3LaFWVvoyaLAcTgOjA5ZWVvyQWU3jdDvtedc5sO3miU4oBygWmQSDS+iFLt4wXXLGrbAiHdrY/X/rQHWlUafVPUq/LtfsbavKgOt6CboIhe1QLuH2kAAdNeA1+9luOerzgoQPUNMLwyKwmnpMvImdUpRFWVtz5Hsyt+fw+g7Zkw+iukU5eK6vsLox1vJZ5Wd9yPosHW2ku1XKav78ilzkYLX3bnIoCYfvXogqcvkX9sB0X2XGQgT8W9gUrKiNFkh+ZbN+swmcOxJz7gxRJDmh8sRtZTx2GtfNbOcv+D2OTUtVdqy71+Tm+0cTgemors7iWIZcgo3WlhG7y6pS1rvCgzPsrROtbwBLu55lRp7NgDaJ2J+tuAkKe9+5DYoEJkNPvsRjKWwORoiLHJwGH/EXP1LyR8YnMt733U4ahygMBZlC+JQD/NcKP1tBTi2Ctay0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Separate iteration over allocated swap_info descriptors from iteration
over writable devices. Hibernation lookups require SWP_USED and
SWP_WRITEOK under swap_lock. Take a single snapshot for each flag
test, since unrelated bits in the same word can change during setup.

drain_mmlist() only needs the atomic usage count; walk every
descriptor without loading flags there. In si_swapinfo(), count
usage only for descriptors that are in use but no longer writable.

Move the live-reference warning from __swap_type_to_info() into
__swap_entry_to_info(). The iterator must inspect descriptors before
applying its flag filter, including descriptors whose device reference
is dead; entry-based lookup retains the warning.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swap.h     | 12 ++++----
 mm/swapfile.c | 77 ++++++++++++++++++++++++++++++++-------------------
 2 files changed, 54 insertions(+), 35 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index d488a69c2809..70fd3ab655ff 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -108,16 +108,16 @@ static inline unsigned int swp_cluster_offset(swp_entry_t entry)
  */
 static inline struct swap_info_struct *__swap_type_to_info(int type)
 {
-	struct swap_info_struct *si;
-
-	si = READ_ONCE(swap_info[type]); /* rcu_dereference() */
-	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
-	return si;
+	return READ_ONCE(swap_info[type]); /* rcu_dereference() */
 }
 
 static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
 {
-	return __swap_type_to_info(swp_type(entry));
+	struct swap_info_struct *si;
+
+	si = __swap_type_to_info(swp_type(entry)); /* rcu_dereference() */
+	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
+	return si;
 }
 
 static inline struct swap_cluster_info *__swap_offset_to_cluster(
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f22197a6286c..56b75770d320 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -106,6 +106,34 @@ static DEFINE_SPINLOCK(swap_avail_lock);
 
 struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
+static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
+{
+	lockdep_assert_held(&swap_lock);
+	while (*i < nr_swapfiles) {
+		struct swap_info_struct *si = __swap_type_to_info(*i);
+
+		VM_WARN_ON(!si);
+		(*i)++;
+		if (flag && (READ_ONCE(si->flags) & flag) != flag)
+			continue;
+		return si;
+	}
+	return NULL;
+}
+
+#define __for_each_swap(si, flag)			\
+	for (int __i = 0; ((si) = __swap_iter(&__i, flag));)
+
+/*
+ * for_each_swap_info - iterate over all allocated swap descriptors
+ * @si: the iterator
+ *
+ * Context: The caller must hold swap_lock. The lock may be dropped during
+ * the loop body but must be re-acquired before the next iteration.
+ */
+#define for_each_swap_info(si) __for_each_swap(si, 0)
+#define for_each_avail_swap(si) __for_each_swap(si, SWP_USED | SWP_WRITEOK)
+
 static struct kmem_cache *swap_table_cachep;
 
 /* Protects si->swap_file for /proc/swaps usage */
@@ -2284,26 +2312,18 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 {
-	int type;
-
-	lockdep_assert_held(&swap_lock);
+	struct swap_info_struct *si;
 
 	if (!device)
 		return -EINVAL;
 
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *sis = swap_info[type];
-
-		if (!(sis->flags & SWP_WRITEOK))
-			continue;
-
-		if (device == sis->bdev->bd_dev) {
-			struct swap_extent *se = first_se(sis);
-
-			if (se->start_block == offset)
-				return type;
+	for_each_avail_swap(si) {
+		if (device == si->bdev->bd_dev) {
+			if (first_se(si)->start_block == offset)
+				return si->type;
 		}
 	}
+
 	return -ENODEV;
 }
 
@@ -2470,16 +2490,13 @@ int find_hibernation_swap_type(dev_t device, sector_t offset)
 
 int find_first_swap(dev_t *device)
 {
-	int type, ret = -ENODEV;
+	int ret = -ENODEV;
+	struct swap_info_struct *si;
 
 	spin_lock(&swap_lock);
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *sis = swap_info[type];
-
-		if (!(sis->flags & SWP_WRITEOK))
-			continue;
-		*device = sis->bdev->bd_dev;
-		ret = type;
+	for_each_avail_swap(si) {
+		*device = si->bdev->bd_dev;
+		ret = si->type;
 		break;
 	}
 	spin_unlock(&swap_lock);
@@ -2996,12 +3013,14 @@ static int try_to_unuse(unsigned int type)
  */
 static void drain_mmlist(void)
 {
+	struct swap_info_struct *si;
 	struct list_head *p, *next;
-	unsigned int type;
 
-	for (type = 0; type < nr_swapfiles; type++)
-		if (swap_usage_in_pages(swap_info[type]))
+	for_each_swap_info(si) {
+		if (swap_usage_in_pages(si))
 			return;
+	}
+
 	spin_lock(&mmlist_lock);
 	list_for_each_safe(p, next, &init_mm.mmlist)
 		list_del_init(p);
@@ -3997,14 +4016,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 void si_swapinfo(struct sysinfo *val)
 {
-	unsigned int type;
+	struct swap_info_struct *si;
 	unsigned long nr_to_be_unused = 0;
 
 	spin_lock(&swap_lock);
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *si = swap_info[type];
+	for_each_swap_info(si) {
+		unsigned long flags = READ_ONCE(si->flags);
 
-		if ((si->flags & SWP_USED) && !(si->flags & SWP_WRITEOK))
+		if ((flags & (SWP_USED | SWP_WRITEOK)) == SWP_USED)
 			nr_to_be_unused += swap_usage_in_pages(si);
 	}
 	val->freeswap = atomic_long_read(&nr_swap_pages) + nr_to_be_unused;

