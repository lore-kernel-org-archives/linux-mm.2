Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B026C531EB
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D376B009D; Thu, 19 Feb 2026 18:42:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BFD26B009E; Thu, 19 Feb 2026 18:42:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46326B009F; Thu, 19 Feb 2026 18:42:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF556B009F
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:42:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6510C1CB73
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:13 +0000 (UTC)
X-FDA: 84462832146.02.FC31E87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 63D42C0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBuVZgXb;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544531;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b448VSyFc7xNeuEwJ1OdE3RIhP7d4LdILcfB+MUIsfo=;
	b=cyvA6aepzZG1mckZWEBQoprQGrI4BvlyVnvdB+HBaYGt4WCahTfc+JLQuSinTsmTEE3OPL
	PTXB3ev0OO4hCd+MPDclc3PLyYesK6ykQXLeYQr8SQvs3xm3hujbN2aXLVPH1ptHCmzDYn
	RJ0A+jsv0vBIRUPjd4ufeDYTgvPECcg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBuVZgXb;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544531; a=rsa-sha256;
	cv=none;
	b=0n5eOQkCviLF44BijH/Tbgap8/U3t5bqURiey8mc8VwFz7xzd4Bd5PdGbNA1RHsH9EnImg
	Zt54j/JkLeTO5RXAvqi9eFZ4YFlEkJT+ggqk3IxsDZdp2lqWI34a9s575J4txsGW119Ko6
	QEZ9RdGyjopNbOnH3e7FNO/88wCtako=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 725DE44563;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5203BC19423;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544528;
	bh=yJRoofSZXDJaqGdGu9R8RavXCSOxdeInP5x/zkK9r8M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DBuVZgXb2JmAMtPPqJCDR4w7l0Pad0Y8BF2SKBdag28MYKZQTeqxA/FMzc9UGtCeF
	 r4DQxwPdCxdTxQsjXdDL9yWstxBluFeLZgp05mEGXiJL4Hvrz3hfJAin1iQA4KT0MC
	 HAJUkfiysvxCJDDpW1W2K3Oldr8+nA0m/zMGWYCSYIKSRTjOGalAoAS+BwDqygY4ZK
	 M+5I6WSlsPvYMWXpn8pcdf0CWaeQFSIsup8RQ+WUBmSOU/ij+79N+gQUvQdtnUV/kE
	 IQ+kcxyevprfYrBEEcVL8hTJ6miRSf/vXRdNYBeIgiIUPFOSW8L0p6TEPplW38XDov
	 we/mb0gzQqwXw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E7BC531EA;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 20 Feb 2026 07:42:15 +0800
Subject: [PATCH RFC 14/15] mm, swap: add a special device for ghost swap
 setup
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-swap-table-p4-v1-14-104795d19815@tencent.com>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=5352;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=O3BFoOFHolD8K6jdQ6r7SaL/46khBUmErm+aeFqPkUg=;
 b=eSqTz2oJlmVuUdj4GCRJ+RA8upcoyTgpzycyxnyD0Gvm4OVZAjVNFL2ffi01TJr2LW/3Zm4hW
 BR62/OWEVH2B9/MuTlXAxlzz7upTFjH/F4IHkz8+Sd28aGdViLoTF/3
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 63D42C0005
X-Rspamd-Server: rspam02
X-Stat-Signature: a6p68b7wan86btunp1kqpj7ct7hmztsi
X-HE-Tag: 1771544531-179885
X-HE-Meta: U2FsdGVkX19MDNdDHy/S9hJk7y1Ft3z2iQ8MeG3biChiIh3j8BFmqYFwdsEl5h8KdCWMi8CDB5iBbBIpVNzPkucG/4lX/6J6hhLkRkPT0LZpPWqDuJWuEhpplkqc+KZKeYWYKlEkBSq+CWTgQX04p8IhWn/cNeVQg51tqcAueAsitkqgQftRd0e1fs7yQKVhtiYsjluJqYmjOL/+cOoEjrPpaXLFiRPG7jiAHMeAP5yBIy/V61G264G/QKuRQO/ErKNgDzB5p40iX/yJKbBkUnLsWrUJfgT/B75dHGf3brU8uUCcNGmEgykU6JW4CuZWFc/fB+lSsdhRBaslajk4W/E6Bew1iu5QLKAl1NPgdVOwooDOl4sE+zrr59hb2bh4Fa9Vva0Ie8gInZEea7Ohzm5OEazAUmeUQ9v+ZHIDbb2A94ianXXS0xPI7CcfpEJ3GdoJPm4TtmDqqhgBxVb5pdEifrf5SJvdFnwoF+WUX1XmHlhULp/Vk/I9nEHnn0J3Khw+T0HwoYUc4B6wClOfUovU2ThngFR939ndDjMWyqAEbQAo4dDhC1RZTDWQZDRM3LAneYy1it2IlFMQF+bk0TSoONfx91y98avLr3SuwA/SWnu5u2YFPcULUM0as/kT9PglZdlH+94QxirNMt4nigr/qHvWJE2lI3UgXQCWbVaIa7pW3Xp8r9alRIC5FeiL2eAbIlQ55fzDo8r3kiKOpFkwxi1nBDakzxDzwzjMc41w0UyNCkBPozmigYDsUNSwQe5pppMTAKflDpYWtU79DNx7byHAryu8HBjKZC8tx+iY18Zer8HWQf2b2KY5w6bgPIIydnC5Kx93VoYiSzwdHNfs0F9o/+U6CSrWKTGFQuQxMxKMpYVEsA8Srgtdef0NYOBBlthUgfBGa5g1qzN2H7o35boEgQKsMAPpAVt8Z9GMOVDtEAY1jrwwPHor9/OjimySb8pasnq7pOoCuC5
 XCvEQbPz
 YXhGtAKxiPrtw/qAxwa8P2jJwQVtthtjLp8wbwJY+dJA0VOX/oJmhMbHcvG/bhlfLdNdncvrnK7yE9zRroURLAy6gmLeiuWxlfiPCk0LdYiXlhTcUqFCNpKuqLeoKqge4bLLkKXUirznPtT9any84ULZisZy0YQVM1bsV5tNoRxhV43M/O37HSlcTozD98UQSrs9Y0mA2T5ZkL14Uy94rdj+zS8bFUz+qfq1SvmpvDqJik9C0ooH/o/NH6NTVL4zgmVP+BUxM9/67T2aZVKvvg8FbE0SiDGMsN90T7eeucRFH7P43WcyXTeQHMOeAeSqMdoEB8Bp6wLXJO8pXudbKBW5N1hWPkzirk/Zn/UXhr980QYU10+Wyp/NKD3FAFLcaAI3NfvwF5lkI4nb7tYIqDfs6Cg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Use /dev/ghostswap as a special device so userspace can setup ghost
swap easily without any extra tools.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 drivers/char/mem.c   | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/swap.h |  2 ++
 mm/swapfile.c        | 22 +++++++++++++++++++---
 3 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index cca4529431f8..8d0eb3f7d191 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -30,6 +30,7 @@
 #include <linux/uio.h>
 #include <linux/uaccess.h>
 #include <linux/security.h>
+#include <linux/swap.h>
 
 #define DEVMEM_MINOR	1
 #define DEVPORT_MINOR	4
@@ -667,6 +668,41 @@ static const struct file_operations null_fops = {
 	.uring_cmd	= uring_cmd_null,
 };
 
+#ifdef CONFIG_SWAP
+static ssize_t read_ghostswap(struct file *file, char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	union swap_header *hdr;
+	size_t to_copy;
+
+	if (*ppos >= PAGE_SIZE)
+		return 0;
+
+	hdr = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!hdr)
+		return -ENOMEM;
+
+	hdr->info.version = 1;
+	hdr->info.last_page = totalram_pages() - 1;
+	memcpy(hdr->magic.magic, "SWAPSPACE2", 10);
+	to_copy = min_t(size_t, count, PAGE_SIZE - *ppos);
+	if (copy_to_user(buf, (char *)hdr + *ppos, to_copy)) {
+		kfree(hdr);
+		return -EFAULT;
+	}
+
+	kfree(hdr);
+	*ppos += to_copy;
+	return to_copy;
+}
+
+static const struct file_operations ghostswap_fops = {
+	.llseek		= null_lseek,
+	.read		= read_ghostswap,
+	.write		= write_null,
+};
+#endif
+
 #ifdef CONFIG_DEVPORT
 static const struct file_operations port_fops = {
 	.llseek		= memory_lseek,
@@ -718,6 +754,9 @@ static const struct memdev {
 #ifdef CONFIG_PRINTK
 	[11] = { "kmsg", &kmsg_fops, 0, 0644 },
 #endif
+#ifdef CONFIG_SWAP
+	[DEVGHOST_MINOR] = { "ghostswap", &ghostswap_fops, 0, 0660 },
+#endif
 };
 
 static int memory_open(struct inode *inode, struct file *filp)
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3b2efd319f44..b57a4a40f4fe 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -421,6 +421,8 @@ void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
 extern atomic_t nr_real_swapfiles;
+
+#define DEVGHOST_MINOR	13	/* /dev/ghostswap char device minor */
 extern long total_swap_pages;
 extern atomic_t nr_rotate_swap;
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 65666c43cbd5..d054f40ec75f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -42,6 +42,7 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/major.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -1703,6 +1704,7 @@ int folio_alloc_swap(struct folio *folio)
 	unsigned int size = 1 << order;
 	struct swap_cluster_info *ci;
 
+	VM_WARN_ON_FOLIO(folio_test_swapcache(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
 
@@ -3421,6 +3423,10 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
 	if (err)
 		goto err;
+
+	if (!swap_header)
+		goto setup_cluster_info;
+
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 
@@ -3440,6 +3446,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 			goto err;
 	}
 
+setup_cluster_info:
 	INIT_LIST_HEAD(&si->free_clusters);
 	INIT_LIST_HEAD(&si->full_clusters);
 	INIT_LIST_HEAD(&si->discard_clusters);
@@ -3476,7 +3483,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	struct dentry *dentry;
 	int prio;
 	int error;
-	union swap_header *swap_header;
+	union swap_header *swap_header = NULL;
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
@@ -3528,6 +3535,15 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
+	/* /dev/ghostswap: synthesize a ghost swap device. */
+	if (S_ISCHR(inode->i_mode) &&
+	    imajor(inode) == MEM_MAJOR && iminor(inode) == DEVGHOST_MINOR) {
+		maxpages = round_up(totalram_pages(), SWAPFILE_CLUSTER);
+		si->flags |= SWP_GHOST | SWP_SOLIDSTATE;
+		si->bdev = NULL;
+		goto setup;
+	}
+
 	/*
 	 * The swap subsystem needs a major overhaul to support this.
 	 * It doesn't work yet so just disable it for now.
@@ -3550,13 +3566,13 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 	swap_header = kmap_local_folio(folio, 0);
-
 	maxpages = read_swap_header(si, swap_header, inode);
 	if (unlikely(!maxpages)) {
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;
 	}
 
+setup:
 	si->max = maxpages;
 	si->pages = maxpages - 1;
 	nr_extents = setup_swap_extents(si, swap_file, &span);
@@ -3585,7 +3601,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	if (si->bdev && bdev_nonrot(si->bdev)) {
 		si->flags |= SWP_SOLIDSTATE;
-	} else {
+	} else if (!(si->flags & SWP_SOLIDSTATE)) {
 		atomic_inc(&nr_rotate_swap);
 		inced_nr_rotate_swap = true;
 	}

-- 
2.53.0



