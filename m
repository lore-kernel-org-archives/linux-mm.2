Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 120B0607A7C4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ijd6v8za
Received: by kanga.kvack.org (Postfix)
	id 2E5346B05B1; Wed,  4 Nov 2026 14:23:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296026B05B2; Wed,  4 Nov 2026 14:23:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AAEC6B05B7; Wed,  4 Nov 2026 14:23:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED5706B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:23:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 77BA440837
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:23:36 +0000 (UTC)
X-FDA: 85398410832.25.121CEC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB7D84000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:23:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ijd6v8za;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820214;
	b=OX1juF6vs2J5YgHamnPCNqhoU5T7wkZrc44ZF/TegCXhVs4rmzbnDd/ScniJKIcmBz22I0
	mAkYDkBjeQ+1TJEs/zsnZQ7t2KNywpQwjFz6KYXezbfn82dRPzvHLaxMtvYGpV88UIR6FO
	+mDXbFs5YLHMyG1St/wIUAQLg1xokWc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ijd6v8za;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QKQgab6F/A3kQED3xQkQ3++bbO+NbqHo8+XrgOES7ts=;
	b=W7eNsN+j3NMKOZ2AA4S1jtJd8Tx1EoS4PHXG+HWfVy8t9lrf+FYbWgvBokend7Xj2e3wVm
	8PPIcPaga9iIzxLlczzY6VwojfesCRT6YEDIx4k12gq6ClU7zPuqfiN7KrggtkI1ydJE89
	qmAncIKM5MlQwxxZ5zqwOUBNEycrP64=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 436EC60D82;
	Wed,  4 Nov 2026 19:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48D21F000C1;
	Wed,  4 Nov 2026 19:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820214;
	bh=QKQgab6F/A3kQED3xQkQ3++bbO+NbqHo8+XrgOES7ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijd6v8zaNqCLmRZYja1X4maFJ83wlAF/2YPzGzhX/4NJzDk8gpRvHBDtpnvW2kzrE
	 pKuK7II1mOaBx0Gj+L1vraczZZkB7OeRZ9ZoB7qpwQKM+pSqrDe3QY2fA7KCW/Fq2E
	 oXyjbE6QtyNjJgArz+0tadzVnc7sFgUV5Zt+ED3IG+SNM2u1iqpNqo6J7AwifNHxzv
	 2i3LIYQcM2epUeP/ADp5fAb3awZdnh30Pv8kl3Wbf1o49zKnVC71mI5vqn+a8eOGO2
	 saOpPzNjuia2w4fAF7Rtkl4Ucl9o3AVDThJjpyzmxHF+vZXftQlfa3DzlUUjytBfdL
	 q0wb/VbaGQJDg==
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
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH RESEND v2 30/51] net: pktgen: reject device names with a '/'
Date: Wed,  4 Nov 2026 20:23:19 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-30-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1684; i=brauner@kernel.org; h=from:subject:message-id; bh=F9CLtO30/n/hY0YqeSuPpMfy319PBmjhBXOfLkB61UI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bvywqoXlbXOlS3uySJpukM32T6snilzOFXlqcfhEv dGWr1sudJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE9TTD/4KNy/KDs66oZjvq T7CTumjecrWj1yL2eO6RGRVGM7v/WjIynJutWGeWKrqa/8u9wz/unp7yJ4GpNbJ15Zfil4dMVgm eYwEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1jrgbcichq4ekzwyq35mgucxirsipzmh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB7D84000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793820214-256846
X-HE-Meta: U2FsdGVkX1996RKWqvqK0etXAb3VcPMwCngkMoDwZ4bfEz5feJIDYRGy5A0XPRk0LkUz5Tch+6OavlRzN+ERFxQ7vwS9N46kCOrnpiLnOvVLVJmakvD4TYHjDBNV0uiJPW7CEgTFJDgRFhhpQpVpXIPrCO7fqip5pPv9HdyAb9k1mkeXvrhcbueW3RSwoi51nGKzPRz643S61fB3qOxDbLtv+GV4qt7OX/nddwilDlFlvhQPfY+yOXJg67yc1NNribi6ExTgeZJAk/l01A2dlDcWfAKnQFx/ukzeinr5ilYxh/sVuccxDL0qVDWK+Ll37wmfum9vySVBKIndncyaUDdFjGYsDyn3gs/pDk6E0Jb0dLDjy6xqAhNxgGw+8SvYtb/iuiaMrapGumK6MCYOLpPsTQphTvmeW6btLyeJGzJiPlAKqpUCK6QvGtr7cFa8MhnC2z5oapUCgU6dmR7OSWcW1+ef5/RIqWZLXirT4XEpQK0hIuCCnbn1awB3Il21oFx9zwjsuqbsO/bbatPJR7EkGQJ+4YjZXl5wsvw9XAcPwFvMtbVKLczFR1/5JLI1VwbOaAjkE2hKFmTzSf41/nnD2fvaRVWjhmc5LrItUD1vf3r8VFkLE2QTixjy5dccEz7BV7cDY7W1tqrx3JrZ5DX7OO5Vz30Az7nkDUhaEKrnxok+cpz9O1Zjmy+Y6sgCVrdS3ji8xk4Q2/B8fVYTiX+7tQ0k9+y0+rS+i3HPtgEkCe+3+w5wDY5/sV9b87fML7N7IxMIj5AH8VAl7kbsyZSHdSF97Vn3ZOZ4Y15XNGbuXOiuOpwgKEfHO4Oe4FoXz5tslBrUfcTYQP34N8r0M9Jpi/DRbjkaRyKsHO+io2+jHZGxJzWBxYoa+jKc7c34/zXv7w3TDSmEVJ+WzwNEe9FgbwE2hPHvsGGvnbCRl9qnTdyg7sJZeq/7dqFfz2nQJBcOCVagE+f63Pf3mX5
 Q0kwwEzI
 PBGXbuUzZosE18yZHF63h5fME0dxGOaU4JivD+VJy+iJDVXbS0NAjuMkGgMIfgHGy1KDWBxSHQPArxK5Ls76dNuw3/MdsiYW+Pkbr7F6UP3IB+JqynaPBmxu/4GkIo6uCpy3N0nW8lxiRT0Sjkvg1+gpOf1/EwPFazlExZSaDFFkwg4VqVTxLav9qRJC2cVmDTwLN6/N9+xsYvNX2zTjaDd6SvELydg72wwUk4Zy+TUUBbeTPlBDKn+7liZLFYD09qVx/emgUoqGb7aRh4QF7wAc/0AlHjGv0vb41tZUlb8A+zmlkhPGb19aqwWQsQDle/SxRnhRX/k8bMhlnrDMDlMnqDLUIIMgcrrlTkXiyULcuH0i+HO6d+YC+zM1o1CY4u3lfmeC112j66hbE5hHj8XN/nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"add_device" takes a name like eth0@1. Only the part in front of the
'@' has to name a network device. The rest is free text and all of it
becomes the name of a file in /proc/net/pktgen, where procfs takes a
'/' as a directory separator. So "add_device lo@a/b" makes procfs look
for a directory "lo@a" that doesn't exist and warn about it. Any user
can do that in a network namespace of its own:

  name 'lo@a/b'
  WARNING: fs/proc/generic.c:174 at __xlate_proc_name+0xb1/0xf0, CPU#3: bash/241
  Call Trace:
   __proc_create+0xd0/0x9b0
   proc_create_reg+0x45/0xf0
   proc_create_data+0x77/0xf0
   pktgen_thread_write+0xd8d/0x1750

With panic_on_warn that takes the machine down. And if "lo@a" exists
because somebody added a device of that name, procfs used to register
the new entry below that regular file, and removing "lo@a" freed both.

Reject names with a '/'.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: e6fce5b916cd ("pktgen: multiqueue etc.")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/core/pktgen.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index d63eeadddfcc..02af70d360bc 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3831,6 +3831,10 @@ static int pktgen_add_device(struct pktgen_thread *t, const char *ifname)
 	int err;
 	int node = cpu_to_node(t->cpu);
 
+	/* The name becomes the name of a file in /proc/net/pktgen. */
+	if (strchr(ifname, '/'))
+		return -EINVAL;
+
 	/* We don't allow a device to be on several threads */
 
 	if (__pktgen_NN_threads(t->net, ifname, FIND)) {

-- 
2.53.0


