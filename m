Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CE31C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1F86B00A7; Tue, 11 Aug 2026 13:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888AC6B00A9; Tue, 11 Aug 2026 13:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F336B00AA; Tue, 11 Aug 2026 13:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF8A6B00A7
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:53:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D15D8140185
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:53:43 +0000 (UTC)
X-FDA: 85089736326.08.877DC89
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf24.hostedemail.com (Postfix) with ESMTP id BC81B180013
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:53:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=BOkDF4Rz;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="N 4iS5iT";
	spf=pass (imf24.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786470821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+WO8Wd8uVuaOAqPz02lOuhC1hujQODpzz8Mj2pgUKU=;
	b=MepB1IV9oynPO3OZ8q9EnOktyTk2aQr9jYkekwpUkKsf4JcDgGWcb94Ow4S/+JGxGTyS9W
	M8POAz37WwIQGMtciay8wQynepcWnvZ0WyFDmL0N1YZDXIN/q0ODWcVsOjFGPcDvWaCDdm
	TWsbl4FNagKbFDHBgjml5sEcDgMINUM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786470821;
	b=J8CQVn76ezNy/8gzCXSMksmfHyskC5lPTSU5vFB+m517A0QzQXYOLck3S53C5K+14aCxvk
	PR5/xU9QYrT94492coo/04QKOFERIPsclaN3ZEM7IwUdHCylZYEI5aHzli5yoFFnTAXYTP
	fBWLGDTTpNdT0ANqYyLu2XJpLPUUwpI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=BOkDF4Rz;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="N 4iS5iT";
	spf=pass (imf24.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id A52E71300394;
	Tue, 11 Aug 2026 13:53:39 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 11 Aug 2026 13:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786470819;
	 x=1786478019; bh=J+WO8Wd8uVuaOAqPz02lOuhC1hujQODpzz8Mj2pgUKU=; b=
	BOkDF4Rz9/gooVjq3RpQHo3JgqyWe2UvkdyKkquJvQvwFmzg6JKoOyLQdtfEo9os
	mQPrjjoZ8lPFt6CGUqgCaJL+KYD79POq7sSJkXuoAF2eXi1fvAA85T4Ytwt5ur/Q
	nx+jUlDfH4eyDYxijQfeU7PLX023FwP9I1sIH97UyPDrGaSgF4aquxz32lGhkUgt
	VPPGFo6LQAwm4b5XHSLQz91GJaXZDpSzOuxSp+H+TfvoKfrvN4LXASTCzHd6zyeS
	EnDHlJha5SzE+CxhuQmFzFgWrs6c+eUJ8hr/mOBW15qfn+mIXzBlbV0RD4Rgtgzg
	1zeoXrPUD16fpAI8XoHcOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786470819; x=
	1786478019; bh=J+WO8Wd8uVuaOAqPz02lOuhC1hujQODpzz8Mj2pgUKU=; b=N
	4iS5iTGKooqdrvcsJTYS61BR/GSIT45Oo6QqU8ZU7sU0mXhtwYj7MB3Jt/Dx0ROe
	WWCQLGzlOjc/ospWcxf6DRzXygSS7RJUve2IQJZUBh795lT0a4nr7wM+C75qpRZY
	pAnHy1c3fGCJV8cdgknI5GL/qnynMG3dZKY3ktFPOILbcp96/cEcLmK1HqjrMdtZ
	bVd1bKcDGJtqBekmzpDH8Kt/eUgT9wx7T1mZRCUw7rWoiHNEWiJRkv45NdCb7Ivo
	8FBBpiS2U0nx5YufR55NmpXxHPL9ZGwYjt8vxD9aiX5ieIIFJl3fZp4EQaqD0WLU
	zCDK0gxpQBPdBrFDcum2g==
X-ME-Sender: <xms:omF7atYgKN-M4dSkgg2g107EOxf85SPIjPISOjO_-uyMGQ95gPTpoA>
    <xme:omF7ambU4drf8-qImr2vGKCYoOERMgvkEowW8H90c7JuQF9F7gakJh1u5fwVAdbP7
    vDb1ixUPNaU5b-Ye5w36rwhqVHs94AfSJUdLQnfXqqZhFz5p1vy>
X-ME-Received: <xmr:omF7akP-ZfsgjJJ6pKgoUOCz0fWLB_ynbFeIAX7VEbiHq9JdofK_GrkuHP6QU0WhMjccqqKM_rY0m3u7Tezlymg>
X-ME-Proxy-Cause: dmFkZTFP5tmiXRyqpvhao8uWnDWsuVG58E3QcpY8nNF+TN3d4+2z3XaWQJ1+2uEKcUq9Jg
    +xH/KDfBOi31TfxVE5vy2aZ5W5Eono+bvv7mBiiNvVW/C9tjIvrxCLzv7Tz6GJOSvAG1cd
    t11+FzpQNbill+yp1ZC7JKPVzEaxQ4CH2HewKTU1gYEn0mNFldMXWgoBvZ/c5OhwLZogLW
    sZeOMCUfQY9vOvCjGHA0ivpYn+5HBy3sK6RswFREIaUm9jlhbU7pV5ZXGDLpJAMlUAJ/Lo
    y1vjaaTNNEiBF07QqH8YbZg0fsVTsE2lSAku2XiqZRlB3GAWdGnDFC/NxQNHJZjZwh0bYp
    2D+LN2F74Yl3YoQ3TYGxnERSWoIxBO0+Rj9TdO4erTRPzAa6AXV7HsZRupEU6wVR1PLnZ/
    qD+OrnCT6HXewM+ux4wHGxmKexKv0hHPnfmxW9hJCXJtO2BNPDGZ1Lle6+NhqPYEPMPKNb
    X8R7eH/IiY0blGg6UPTOthFqGg5f8FXU1DJLEWoGZiH7qMjHDYZC3g35sbvFkqkMCq4alf
    ePCRDURBuId8UuInZQ/cP018GY4SJfHKmWBqr+4fdNBUm01zIs5NrvTiIC/1gDOpHLjt7/
    vRSUj7PMIURe49UfkaLBCD/7OYrpKZ/VT/L3AAfTp/3bPR88OP01AB0LJ4dA
X-ME-Proxy: <xmx:omF7amk6I74XTH719pm20D4Jw17uGY_WXvpXv-1zgcz3k1-tH8Xd4A>
    <xmx:omF7atbL7SGYJ6IhF5VsbqvIWP_50F2wK5RmksIElcj26ZbK3C0bTA>
    <xmx:omF7arFeKkTYWFWjXsQqbKd3VyVMr7Rw9bhdMGFsIQC0tlshQplL5g>
    <xmx:omF7aqIlFWIsTx-lbQsA0nCLMWVfVIX0FyTdhx7F9Q2DSOhpoNacaQ>
    <xmx:o2F7areimsI17MhYeg6_qPD8pxiIA70rILVQJMKSbjrob-vXhArnNqyj>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 13:53:31 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Tue, 11 Aug 2026 19:52:53 +0200
Subject: [PATCH v2 04/13] mm/secretmem: wipe secret pages before kdump
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260811-crash-zeroize-rework-v2-4-9561d13c2340@jaseg.de>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
In-Reply-To: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
To: Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
  Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
  "Serge E. Hallyn" <serge@hallyn.com>, Lukas Wunner <lukas@wunner.de>,
  Ignat Korchagin <ignat@linux.win>,
 Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Keith Busch <kbusch@kernel.org>,  Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>,  Sagi Grimberg <sagi@grimberg.me>,
 Trond Myklebust <trondmy@kernel.org>,  Anna Schumaker <anna@kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  Marc Dionne <marc.dionne@auristor.com>,
 Eric Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>,
 Eric Biggers <ebiggers@kernel.org>,  "Theodore Y. Ts'o" <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>,
  Alexander Viro <viro@zeniv.linux.org.uk>,
  Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
  Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
  Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
 keyrings@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-afs@lists.infradead.org, 
 netdev@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Stat-Signature: n5kcej67j1okxtcnpjqfc9zqsqngfzf7
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BC81B180013
X-HE-Tag: 1786470821-511402
X-HE-Meta: U2FsdGVkX1/LsvXrY3dYPLATdp0LCl88OQNWWE0NCaz2ba5DZWh54Ad7d47MVLLxt3G/phLbqCciW2dvRmE2R/4uQw24EKCSeEM+0IHu6VOngw1dqrDQ4u/r+iS3IGSLdHr+TjWmbYsRm4YzERqQ2Px2V8HDSa+tVkToENDrZkBfApcEs6Vj7wD/mt9KkvWP8+kw316yVnjgMnwiXHYtWhppkfHL+T7Gcb6Yy905sJm/++wSxVzCXaeyo3J4Jm/gyerjzoKDzCRjNS9rYO4s4E99JGWvsDF0g6YCzXD1xa3Jd7Mn7tyR0z+Ithnac/H2i/TbD7/0Are1VGGECP9JCh3tB1GMAYXu38jKS38QqIWf+Z5StzJ6icVhbs2HWCXKoT4dn+CixDWOvAp0mHBViWNwbUHsKEbYJuTghmbY3qL1aYf0j2Y5L7foRO5JRoKNz05E7xh6HGr0j0AEBWT+QemvwjUYY7zyhu871UDJZrTMahT/b1GbYlDNWw/boVYeAmww06jIhFMzo/SOeggnQYjkv1WcyIUZXLAmfI8HegU8s1ECox8gtAcPcT9XP01DAMGxdblXzJ7+FpND+qlMMJE2ERh054wzZf/3L+JO2R5dyOWUvThq2GYx81T9G/Ji9U3Vj1PDr2W3kl3gH2ZK44g8qOvv1pWdOb8EK56y6tIiOJ3swH+SNU+r+lBS6RsiWazeRIG/YqArsXWr7d+RKb9C7eavxf/QygihymN0DgjqBCVFNqLcUstN6yM4osB3J0JybFC1FK1lUre9TRTYBepYFrCtsHPlQkf8bR458AIr/pQXRXcPnKACy69pqB6jXe1Sw5wcJHY/0HP0pQ9u7HmOQpZyVCXzbtz2yRrXHgZzxN/RfDqpf+AKyOfxEtoBeXJWGHAh1KgCiVbNLxw2Mh+umoZLN0wNXm1qBcL7bywkHbcmRGHV0CgCCAvhLDGXLFP7CH8Zwx8ASbCCceB
 zeJQnvDK
 /ZeGILYBbtSlDvXXoKRj9A5nyI8QuZDJqas2P0k+I75rxW+RAYhg3AeGPP3nl9wvGnbNNNHqyKU10bo3CDnZzHv3EUgtHdsDyCh53qsylHn8bQS6cGc39tsF8Yo7TKTH1EDGuMyYbiqZhWvJ/Zaqv4L83yhZZA3n8EvkMcBbVTNUlS8cReESrSgPl34oHAFHP0ZM6Jrq55X8wLOhPY7h1uABhf/vVcMQPCE8+dZMTT/ZQRp5xyoBKPyHqJIIkVtT5tfaE2ZYZDXSb+BMI3fagWuy5SIPzlQgZg+7yZCFVZQWap6g1jRY3PcRkr5n4MGv4MZm1T3rBv5FkGZPKiuva87keLOF2VqkaCOJRoApXDcm0gG77a5Zynv+hm/UAQLe8ZziVML0ooiB8f4Gq8YljeAz3/rTQorc1JL2BA/xWm+ijVwZY/XB1D1i/exPAO8jgyoE+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register a CRASH_WIPE_SECRETS notifier that wipes secretmem folios. As a
result, when CONFIG_CRASH_WIPE_SECRETS is set, secretmem areas will be
cleared before the kdump kernel is kexec'ed.

The notifier runs after the other CPUs have been stopped, so the page
cache cannot be mutated concurrently and the xarray may be walked
without taking the i_pages lock. This is a best effort, defense in depth
measure. s_inode_list_lock is taken with trylock only. If a CPU was
stopped mid-modification the list may be inconsistent, and this late
into the panic path, there's nothing we can do about it.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 mm/secretmem.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index d29865075b6e..db00b7d06080 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -13,9 +13,11 @@
 #include <linux/bitops.h>
 #include <linux/printk.h>
 #include <linux/pagemap.h>
+#include <linux/notifier.h>
 #include <linux/syscalls.h>
 #include <linux/pseudo_fs.h>
 #include <linux/secretmem.h>
+#include <linux/crash_core.h>
 #include <linux/set_memory.h>
 #include <linux/sched/signal.h>
 
@@ -187,6 +189,54 @@ static const struct inode_operations secretmem_iops = {
 
 static struct vfsmount *secretmem_mnt;
 
+/* Called far into vpanic from crash_core.c with other CPUs stopped and
+ * preemption disabled
+ */
+static int secretmem_crash_wipe(struct notifier_block *nb, unsigned long action,
+		void *data)
+{
+	struct super_block *sb;
+	struct inode *inode;
+
+	if (!secretmem_mnt)
+		return NOTIFY_DONE;
+	sb = secretmem_mnt->mnt_sb;
+
+	/* If the list was modified in the exact moment we panic'ed, it might be
+	 * in an inconsistent state that would be unsafe to iterate. If we can't
+	 * get the lock, too bad, that's all we can do here.
+	 */
+	if (!spin_trylock(&sb->s_inode_list_lock)) {
+		pr_crit("crash_wipe_secrets: can't acquire secretmem superblock lock.\n"
+			 "crash_wipe_secrets: skipping zeroizing secretmem.\n");
+		return NOTIFY_DONE;
+	}
+
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		XA_STATE(xas, &inode->i_mapping->i_pages, 0);
+		struct folio *folio;
+
+		/* no need for locks if we're burning down the house :) */
+		xas_for_each(&xas, folio, ULONG_MAX) {
+			if (xas_retry(&xas, folio) || xa_is_value(folio))
+				continue;
+
+			/* secretmem_fault() already split the linear map */
+			set_direct_map_default_nosplit(folio_page(folio, 0));
+			folio_zero_segment(folio, 0, folio_size(folio));
+			crash_wipe_cache_range(folio_address(folio),
+					       folio_size(folio));
+		}
+	}
+	spin_unlock(&sb->s_inode_list_lock);
+	/* off to kexec()! */
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block secretmem_wipe_nb = {
+	.notifier_call = secretmem_crash_wipe
+};
+
 static struct file *secretmem_file_create(unsigned long flags)
 {
 	struct file *file;
@@ -212,6 +262,8 @@ static struct file *secretmem_file_create(unsigned long flags)
 	inode->i_mode |= S_IFREG;
 	inode->i_size = 0;
 
+	inode_sb_list_add(inode);
+
 	atomic_inc(&secretmem_users);
 
 	return file;
@@ -263,6 +315,7 @@ static int __init secretmem_init(void)
 	if (IS_ERR(secretmem_mnt))
 		return PTR_ERR(secretmem_mnt);
 
+	crash_wipe_secrets_register(&secretmem_wipe_nb);
 	return 0;
 }
 fs_initcall(secretmem_init);

-- 
2.53.0


