Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7099D6552C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 538FC6B0005; Wed, 17 Dec 2025 07:17:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6D76B0089; Wed, 17 Dec 2025 07:17:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5BB6B008A; Wed, 17 Dec 2025 07:17:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2CC756B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:17:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCAF5BC5F3
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:17:01 +0000 (UTC)
X-FDA: 84228862242.13.685D1B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2F01314000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:17:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PX/EJFlQ";
	spf=pass (imf23.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765973820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gcOG7/XFg5j5xSHGG88yJzOTETOfBIdSIIwt1tbPu9o=;
	b=0eJoqZELyVS72FxS30fnK29vinX+tgkXkZjyYBO5scPftWd2tiXrJrgnEpMiJlw6LL9LTK
	0Q+wop1PAeSL3oQTIaphLk0oAlF+YVqkKhUN4ZkLYz1qB1An0FKrTmYq0/VUz0fQUpqgu2
	L6aUO71DsaDlsQM8x0puJFhJoLnwr1E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PX/EJFlQ";
	spf=pass (imf23.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765973820; a=rsa-sha256;
	cv=none;
	b=ZgU9zIWK2CuI3lXm1LPoPx93sfanQx5wgtDlYkV8fcFou0p0iz3Q1MthnLgzJfKDiOZr8S
	4nKP4QulkeSm/A9qJ0myqvG56dTHs9mh2RY2xKDcqfU732+t4AtEFp8gKDfoalfeLqCLaK
	pNklYenITPG3DRtMPdiZ1HHcVt1Dnhk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 83AD3601A5;
	Wed, 17 Dec 2025 12:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D4CCC113D0;
	Wed, 17 Dec 2025 12:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765973819;
	bh=+N4sH+sHD/mZO0Dopjn0v7xWI8qX66vpH1TR36avIcM=;
	h=From:Date:Subject:To:Cc:From;
	b=PX/EJFlQdIuBgyDARQas6jPR6/RoewsC7HadKO+icTia7eEJOVUDgH0NHanwK6WHq
	 I6+mma7n9dPpK9KaTnCyCwpZAnZKommqNmqvbkwq9Ki3KNRFSXNH5tdvE/oUQo5EdW
	 R2FZAA9OBebqk4yxX6GN5ZOJRyQ6t09SlmQsrOw7+77kXujs+Ffvj8itQ0j8SrB1dA
	 3GTYsehdaup6CH/k4fBawqPNEg8KBHR9KcRkO/DjT5DloAhTjUjG3SAgJ2HYQxSELf
	 2sKvCVjwcsa1D0K77SP6ivJWUrN3szeBX5A9nrGfbd7VnarXM2RpW2ljzBCVwRM95u
	 xQPoJ/l7DIoAQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19AC2D65550;
	Wed, 17 Dec 2025 12:16:59 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Date: Wed, 17 Dec 2025 13:16:42 +0100
Subject: [PATCH v2] sysctl: Remove unused ctl_table forward declarations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251217-jag-sysctl_fw_decl-v2-1-d917a73635bc@kernel.org>
X-B4-Tracking: v=1; b=H4sIACmfQmkC/32NQQrDIBBFrxJmXUtHIrFd9R4lBDGjsRUNGtKG4
 N1rc4Au34P//g6ZkqMMt2aHRKvLLoYK/NSAnlSwxNxYGfiFC+Qo2FNZlresFz+Y9zCS9kxI3aH
 sUGipoQ7nRMZ9juijrzy5vMS0HR8r/uzf3IoMGVdXZTrZttLI+4tSIH+OyUJfSvkCUBUTnLUAA
 AA=
X-Change-ID: 20251215-jag-sysctl_fw_decl-58c718715c8c
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Petr Mladek <pmladek@suse.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 John Ogness <john.ogness@linutronix.de>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-hams@vger.kernel.org, netdev@vger.kernel.org, 
 Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4070;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=+N4sH+sHD/mZO0Dopjn0v7xWI8qX66vpH1TR36avIcM=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGlCnzn3+gSU0+j0UAVfyYseAC+Luiy67oOfV
 qoKl7xQ38Gdt4kBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJpQp85AAoJELqXzVK3
 lkFP6CUL/2DCbeAT7eVMIUFZuqFbctu8L27EdqamYQi/f14ivfW67IvMpQd8Ecs34YCaZK0a57n
 VIl4Z4L0Ryr0Ft1STkGYh1/pbipbCooRk3yYNucpnyHHJZpNrh89htfwoo43BNMR7dR83TrEQT1
 NCvvC0oKxZkeHvhidOVij1Z5Sbon0SHgnBuTRa23Nn8EGG+LqerkB/k0iFGtLGp5y7tFOruDgzo
 M0oGggM5rMfY2qCxSnYjSUAOLtYXznHU+hNAAxVC17o8jf8UZRRLLOkiADhHIqFTbZrTjP/2QAF
 O/A49Iw58uDNGcNHrvqfIOfHQ/O41LM1wXsCo5+0ijFAr9Ba0GMFlIjz3hCVO327HR792KjIf8H
 BjvCs2nQs+AX2XhGgZ+G+kS7SCm76yJr3Djq4RVTNN/0t9cFixWp93vjU1N6N20awGC38ev6EwK
 h0OwtNUDISj1y7LaFQgLFCXs+0yIZjVPe5uzzq5qMhx0RcXJUP/1kVq20J4OxdFpLO3aoZIsKW8
 zo=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F01314000A
X-Stat-Signature: w8up69qdzmzzk7y3axm5kxts1utqytuh
X-HE-Tag: 1765973820-956522
X-HE-Meta: U2FsdGVkX19+r687I3sBdADfuSvwhiJyccRHoOfRDercSQ2TMJiLLzi/AFb1fZLB1kw+vsfJsnVV0JtXXcx+QQEfGVZE357t72PkI17qayNJ0ymobVKTCxkT6JOfsWinNioYTYRbEHDU+/fe7E1CI77F5adUKg23tIlRUqxwXaD9sgVbiYw2GjbExl06zmYyBk4EMA5EfucGf+sBSTFUJ5ZWXR7Xkti4BOIZFU+ivwotAsJOPdRa7kH/8DZhd64JEkfEs81QlVwbATQvEMBlANz2kBBwUVAI2SllrZFfsxbHCcxeYZzfdxX9aIbErAQE15RFE/7IUC1lNRPAANXy9RW/w54PSsICmB7QxLVZeSbT5d+lYUkfAH6hXoUpZbAgzlotQTM8wEXKZGi+1ExkSt0xubkDdW3Uknm6UlH0vLlJMQ2YciydNEoSqpzh7yU1ojnBhpDTLWQ6UJ7duG8DC77zpYKpvJhgVeFks3SsQrBjk7rJsINdxVOMP2/g00s+a0+I0TnOmcTmQYUQGFdQsEsUKSYfnk/urwpn+uYGRTNdptKRNQpVAER8rAVFQ7SdO6op4VuJWSPARlrCj66AvooH53plSw0NnmU4Wmxt3BXfGuhOFU12BCiYDr/XUXtriJdYfPozG2vmdHBPUW/r7aF2fAw1bguym6+00H1VXjtcXJNA1kugK0CeDG/NPlbIJjZe75oj0r7Lix2LsS93Lm0bgiDhc5zhVmx3LGHTpsTETL7GPcIGttQs5drR/23V0SlFg8+lrgVNhR696ohknb/JgBiQzyYl5YJBnd+138FEEpNe+kouUn/k73qLONtv3zwI9vFlzrw/dHtjZjA2mNNEEgOqhezytww5tguurkQjdi/9rqwWxY8wRoBn6c7bXzeqO6OnabMB8XrVqij5GXQZAKziPwy6hml4aLI5EmonPhaRM8Zu1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove superfluous forward declarations of ctl_table from header files
where they are no longer needed. These declarations were left behind
after sysctl code refactoring and cleanup.

Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Joel Granados <joel.granados@kernel.org>
---
Apologies for such a big To: list. My idea is for this to go into
mainline through sysctl; get back to me if you prefer otherwise. On the
off chance that this has a V3, let me know if you want to be removed
from the To and I'll make that happen
---
Changes in v2:
- Replaced a ctl_table forward declaration in kernel/printk/internal.h
  with an actual #include <linux/sysctl.h>
- Link to v1: https://lore.kernel.org/r/20251215-jag-sysctl_fw_decl-v1-1-2a9af78448f8@kernel.org
---
 include/linux/fs.h       | 1 -
 include/linux/hugetlb.h  | 2 --
 include/linux/printk.h   | 1 -
 include/net/ax25.h       | 2 --
 kernel/printk/internal.h | 2 +-
 kernel/printk/sysctl.c   | 1 -
 6 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 04ceeca12a0d5caadb68643bf68b7a78e17c08d4..77f6302fdced1ef7e61ec1b35bed77c77b294124 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3487,7 +3487,6 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 ssize_t simple_attr_write_signed(struct file *file, const char __user *buf,
 				 size_t len, loff_t *ppos);
 
-struct ctl_table;
 int __init list_bdev_fs_names(char *buf, size_t size);
 
 #define __FMODE_EXEC		((__force int) FMODE_EXEC)
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 019a1c5281e4e6e04a9207dff7f7aa58c9669a80..18d1c4ecc4f948b179679b8fcc7870f3d466a4d9 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -16,8 +16,6 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/nodemask.h>
 
-struct ctl_table;
-struct user_struct;
 struct mmu_gather;
 struct node;
 
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 45c663124c9bd3b294031d839f1253f410313faa..63d516c873b4c412eead6ee4eb9f90a5c28f630c 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -78,7 +78,6 @@ extern void console_verbose(void);
 /* strlen("ratelimit") + 1 */
 #define DEVKMSG_STR_MAX_SIZE 10
 extern char devkmsg_log_str[DEVKMSG_STR_MAX_SIZE];
-struct ctl_table;
 
 extern int suppress_printk;
 
diff --git a/include/net/ax25.h b/include/net/ax25.h
index a7bba42dde153a2aeaf010a7ef8b48d39d15a835..beec9712e9c71d4be90acb6fc7113022527bc1ab 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -215,8 +215,6 @@ typedef struct {
 	unsigned short		slave_timeout;		/* when? */
 } ax25_dama_info;
 
-struct ctl_table;
-
 typedef struct ax25_dev {
 	struct list_head	list;
 
diff --git a/kernel/printk/internal.h b/kernel/printk/internal.h
index 5f5f626f427942ed8ea310f08c285775d8e095a6..29a3bd1799d426bc7b5ebdc28ff8b75214c57a57 100644
--- a/kernel/printk/internal.h
+++ b/kernel/printk/internal.h
@@ -4,9 +4,9 @@
  */
 #include <linux/console.h>
 #include <linux/types.h>
+#include <linux/sysctl.h>
 
 #if defined(CONFIG_PRINTK) && defined(CONFIG_SYSCTL)
-struct ctl_table;
 void __init printk_sysctl_init(void);
 int devkmsg_sysctl_set_loglvl(const struct ctl_table *table, int write,
 			      void *buffer, size_t *lenp, loff_t *ppos);
diff --git a/kernel/printk/sysctl.c b/kernel/printk/sysctl.c
index da77f3f5c1fe917d9ce2d777355403f123587757..f15732e93c2e9c0865c42e4af9cb6458d4402c0a 100644
--- a/kernel/printk/sysctl.c
+++ b/kernel/printk/sysctl.c
@@ -3,7 +3,6 @@
  * sysctl.c: General linux system control interface
  */
 
-#include <linux/sysctl.h>
 #include <linux/printk.h>
 #include <linux/capability.h>
 #include <linux/ratelimit.h>

---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20251215-jag-sysctl_fw_decl-58c718715c8c

Best regards,
-- 
Joel Granados <joel.granados@kernel.org>



