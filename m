Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9986F606E2D9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Va7zsSD/
Received: by kanga.kvack.org (Postfix)
	id B8C1A6B05EF; Wed,  4 Nov 2026 14:58:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CF66B05F0; Wed,  4 Nov 2026 14:58:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03C96B05F1; Wed,  4 Nov 2026 14:58:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77E136B05EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:58:55 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2019AC0869
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:58:55 +0000 (UTC)
X-FDA: 85398499830.18.D5B79B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 804AF20009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:58:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Va7zsSD/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffDqq2EmH3dLLxjgj5UCr7XG2Z9kHARzT7WYJIH1M8I=;
	b=5403D9/Iz5qtJa259djU1Qei3xkimDRVJSn7LIA5Rs0d7tLgznEOqfsZbQmuey+Iysshx6
	OjXuMznjZ0wwwkS+6qc5HjB4P1BNAjDtsuiIxrYfPAevoZ7hfl4iBnHcP1HMA9QexHD+gD
	bI9KXK7wlVh0O72TNE7OfCSn/KaWMLI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Va7zsSD/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822333;
	b=pPEoy3iUXNUMuEFTKE/mwYV9zvsOHBS4wD4w/8SK+DLqelk/2wl5i0hibeniSOZ8aWJ/hg
	S1pUue+KiWazB2qK8oxeJa4rNK/LqX5g9z1s80efn58ZGVbqSyOOJ5MtWsP5iN2LaC0rRp
	oiIfzJy/z6RNBWeqf40hOFCZpTOBTrs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89CA143C79;
	Wed,  4 Nov 2026 19:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475061F000C1;
	Wed,  4 Nov 2026 19:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822332;
	bh=ffDqq2EmH3dLLxjgj5UCr7XG2Z9kHARzT7WYJIH1M8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Va7zsSD/2UsqzeDK17UtGbxk8tZ8VFuDtrgV28CQXE3r+pUU3KAQ9HdqwNtJCrgiV
	 ER/DimX74CNEXlu3IVPIXGbqc5CE12lAQ7b50a7KHKJ/AN/yvURbL8BJKzY3tevFtZ
	 4hUGceV6oWXok2hp5oPMRcHlxbZdVLWyfg0KIahRV4dCHE2oE+Til1RUebK1MkIrRI
	 /sZV1JWTnpcc7uIQut/dpI2nvKSohpgIa1uCWZRw2Ljq27C9lceWDK43vqJZV6NQiW
	 fweTl9sYyzuDv6zPxbywF1J1VTwPH00pLECF3z2ro2vkAz/tU/vmL4m25vP2A1j8av
	 it6DkfL/lb1/A==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 04/13] netfilter: xt_recent: let procfs own the seq_file
Date: Wed,  4 Nov 2026 20:58:38 +0100
Message-ID: <20261104-work-procfs-net-v2-4-221e2437fed1@kernel.org>
In-Reply-To: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1502; i=brauner@kernel.org; h=from:subject:message-id; bh=BFI4awwUWJFzxPnNllIUF4mTxSJuUKU00IOFrC3aQoI=; b=kA0DAAoWkcYbwGV43KIByyZiAGrrjiej6rmB1rbnTFWCev28j3SQbNVWhEo9oG7+1WnoRYXHo Ih1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmrrjicACgkQkcYbwGV43KL/sgEAvxrm KME07jPCmATQhxOPX+CkeymKJwNpyy2JVbz+TS4A/1C5qF1LfL94UG1aRkd9j3hJLBQu75wvUei vrFWvAtMP
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 804AF20009
X-Stat-Signature: 7o35zemkheyhhf4ijsjzym344bux6pd6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793822334-888779
X-HE-Meta: U2FsdGVkX19u6fsh+vJ//LZSgYB+5j7tsETP9GTxdhqT4TBNOirtHDM5AK6/0CWGHLPTwSPnkgpQuTTZ+H+qm9Pk72EXvpr9LBKFa8AcJWmUgrm7HkAbzdQuTRSuP/LRW+zJRuGzT34mq9JG85DGPIhsB3yeyGwJ0KdRe+7hjXRXCggAybN3qKmSZkSWk0MmF5RBOVNz/qqnonSddFO8zfwW8qwJ0ZOytqxHLsZbvDkJOgiGDBRwnx1sDVcQx5iX+z2NQOqun6H8kMn+sELZ80RdIAjJq4j7lSE3rjZ4j5NFM3UfpqFyYPUdizWxsF2igE7vxlF1iOk5TEy7NqEIYLQU214zD5pI2XFt8DCDjo6DGmoa6oRFMIosT+Gwo4PJEVIg0QbtEJrTaioR3sA8LoIwyHmD0JUGjdRjqh3GAFCZuYu1oV09rIfn2XzVDGH9jmdS7pIzyK8g+yV4kgfkSQ8AC9qdPAS8cOuk43rT1u9UCozujpX7dZo8eB8g7jUx88S0mRueogb1J30LPdZPbvdWB8Pd78utlc9RkJYXBjky/znER8lZrzggH3VgAQuf3LZTrjwAYUjKVjjAA+Wy61NM2cvH93+y1+09rMFs91g6fMreXKTVbhiNs6zRBQuJTzBuJJK1rt9UHQbicDR1//fJwTDLomcWPSlqNQtV4exUzA5VKRnNUCuaJiYMzhRhMN73IIHzZWA+dI9wqCTN9mgtCvsWTZeaAx781XPC9i0H636fWk7qm3a45E07VRlgFzrxoYzGmkVJwDAjeG/tNKZWILkm7uV2VKsGW6j8n/sW2kmFrm6qb/1KVlV7+G8x16jvu0fF2qlzLpSBQUc59nn1qL6R8HOurQkgwK4WxmlP+DGDZT5ulde9uyKuUDqyU5xRL8HcJHLW0jbpSbsMHJPs+UcwZykrG5M2hmCZq3a1X+NK6QEzs1ewSXmKZlkwkxbjlhjXUa6u1KjOT0Q
 eP3pz2A9
 Bv9viGmf58KU87Kqpzz52Rx7UjXePL+HLy9DhH3q0vyhoTfRMe5gsi4gs3E9WDhGMxPtuy5Fi+FD8EcLOJ5y8A9uGF+p6l/6NjMnZbmoAypm/TrBTTi1ri+9nM1dbJj6JPcLQyVR+POLIezlURnsDMNVsvHiRnOlzK+vHsNuuiFSfAOKT1wl+XIccX2f3OfBY4yTOtfkFh8bwoZxveDHdI1oQimk+OxFkI6CvjVfP5M/MIZztZR9nEyXiZAK001UOATe+Vlztg+7W8rAfCzSLXuCg9CLVbRq01rLukayHsIjAohP5l8UOa9mGtMMNV3Z213yI7uBtJx8GIN07MIcHUXKoXfIqsjIVQi9nlgjVFisLW4yFqbrp49GxoCAde3J/xfj5a2zQTAtcYZgWg511lK7tKueyRTpRTUEcZhWmkLau41TNNL5ZkcGDbBp3BcwOb6dX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and the size of the iterator state and let
procfs open and free the seq_file. ->proc_open() only fills in the table
now. Reading /proc/net/xt_recent/<table> then no longer holds up the
removal of the table.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/netfilter/xt_recent.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 55f1f2d89952..a43fff5308da 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -546,11 +546,7 @@ static const struct seq_operations recent_seq_ops = {
 
 static int recent_seq_open(struct inode *inode, struct file *file)
 {
-	struct recent_iter_state *st;
-
-	st = __seq_open_private(file, &recent_seq_ops, sizeof(*st));
-	if (st == NULL)
-		return -ENOMEM;
+	struct recent_iter_state *st = ((struct seq_file *)file->private_data)->private;
 
 	st->table    = pde_data(inode);
 	return 0;
@@ -626,11 +622,10 @@ recent_mt_proc_write(struct file *file, const char __user *input,
 }
 
 static const struct proc_ops recent_mt_proc_ops = {
+	.proc_seq_ops	= &recent_seq_ops,
+	.proc_state_size = sizeof(struct recent_iter_state),
 	.proc_open	= recent_seq_open,
-	.proc_read	= seq_read,
 	.proc_write	= recent_mt_proc_write,
-	.proc_release	= seq_release_private,
-	.proc_lseek	= seq_lseek,
 };
 
 static int __net_init recent_proc_net_init(struct net *net)

-- 
2.53.0


