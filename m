Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 019866078C0D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lv3gFXSS
Received: by kanga.kvack.org (Postfix)
	id 28DBE6B05D7; Wed,  4 Nov 2026 12:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23E426B05D8; Wed,  4 Nov 2026 12:55:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1328A6B05D9; Wed,  4 Nov 2026 12:55:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E66AC6B05D7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:55:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B47840748
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:55:39 +0000 (UTC)
X-FDA: 85398189198.29.CB9085A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B5E5F1C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:55:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lv3gFXSS;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89c02+ELWuX5+S2o66zdN47fZ8jrr3os6Vl1YJUNtuU=;
	b=UMRFzcSmNe9VgB2bwTOK9iMVYhrvmrWZgnz5ATwujj3bsY2jpiAjYpl69DTnzapik1L8U+
	z5A31Tn2oENIMKg28jSR4+82+DTXSnwT27XEv4+gGIqJf2utvjTAkKNUwzfyJyB7e2dYhs
	Nthj25iyqIsLbAgk2KrJ4UgjU4wRYyY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814937;
	b=6SUKPt3Vpm24N+27jI0RUeP7yL7pgAUeP+nQZ1M+JHI4xi7YXgX7Lf5Q2uMk+pCOrVx4vr
	+bqsNScWqciuyrx+/3D7BPgTDH6T752N8Nf8ax+EPym2dvaMvJ8kKDdRzrjXn7bt8Vkyo0
	H6PBWr980OM1nCXoMkhQxejhympXoVQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lv3gFXSS;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31A0960AB0;
	Wed,  4 Nov 2026 17:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4DE1F00A16;
	Wed,  4 Nov 2026 17:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814936;
	bh=89c02+ELWuX5+S2o66zdN47fZ8jrr3os6Vl1YJUNtuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lv3gFXSSZQ1eyeFxl4sMw4NV+sDGb399yJy5J5a617cu3SzjnnFfUG43Lfl/7N2wR
	 K+IhSwvXPWPYjM+q4YQ+IDJcS26tQY7yPe6vUEMgkrymmspdu0EotaGD42o6rpaRl9
	 0A3kHepPv/ApdT3/KV9Zp4gd4PPOjbWG6usoLl5/UMWpBcxegT2cBWuUjFbtBLH7mv
	 6ymbGGCGv3TrMbwp1kdSSvCMr+6QGHtpTwZWaklXV25iOtzvIgzYNxKq9awhT/uEik
	 dFy+Ax1siZAlHQyp0vw3cAsPNd4lTDPGDdUR7g3JwRgFyHgFv3m15tZ2mAVMcDLMbJ
	 1KqqoJMCmMAiQ==
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
Subject: [PATCH v2 35/51] proc: warn about entries left in /proc/net of a dying namespace
Date: Wed,  4 Nov 2026 18:47:21 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-35-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1410; i=brauner@kernel.org; h=from:subject:message-id; bh=WtI/bNxyA4ZViPTNrsQhWLRSUjQUZ6M8VP3x2XTkww0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9znslLxak6zXzI89Tlobt8x2XHObOOr/+XjXLr/wSD pcMiUNGHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOZcIHhv9PR9Kbfsr9EuEwS 1OuN4o2O2Xfx2elLdO/WqT/FzfBsLsMfvrrlGXyfnU+ePfxJ5/kd5mMSt0XZXSfwl/mEMKZnOc9 mAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: haihcpeqicfsagtg6kciimtnbkx41c36
X-Rspamd-Queue-Id: B5E5F1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793814937-572927
X-HE-Meta: U2FsdGVkX18+a4SHJJ9Z6RjKp18B3lEtVQz38Ryv9esTSCPATTvEyP3Pc40Nv6nxtLteO3RjKkhzgNX7GQMIwRmn1mP1XVpqCkdtIKb8Wz37ZkyWkRcJ1vipbdSuU7Z5t2x1r/wqBzyZz/9i7R0ibvujuC7W5QRRMoe8HkDyK5GBtIna+6l0pQMjAcKTg9tsbjxTlyPY3P0pocnn2qeP3XMERtzSaQM0iOrfgbOOvrQ8vOTpS4fnhvN8eLBl+WSTvuwEcLj2RCPIR16fU4QKXQXpTGQtFo6yso0F0gRi5cSMufEwHFvOhepoYgjPbbBR7xGBg6VvjvOkbwEuLsLHWc711s+bzQnxZbP9ib4AOpSm6wv7KJJU5lu2WYaBDzkKhMizzxY5/jfqyaaEznp3VDHadaN1QGoXf8BJof4BYMP5VXTY2ShnedofncdxgcUnDA56fHmFXCUv0B/e+DFdGNKC14QzNmiOoOTZRbsiIVnses30XqRKKNxc13wm5U2ahGCkwd0FDhKsNJ6yfFEanjC4bRNPVx915y2e9PfQXgrc06ggWP0j/77yE0oDJcMb4qhFvSZ1wZulJerBlDdM8VL/7+jOV4OSlgvkn5ZtVGoHP0w9cXCMJbjyEBNFRMJZmAm0GWOhsEEUe/mQqXRo+EhM0P5Kcwr2rJPTR7XcWXu9D0FdC5YrSOm0SOZ+PDGZufTKy9UDDbxzQd25XVxdgxdstOKxLg85Ri5bM9KxGeemM+ZyjbPljgux4PY1kc+jPoYjHcVlsnmL2u8QvVH5riIUVX85n+71OZD7BTJW+S8+GcIhIlOsbyOqfvl761Q4EP02jIO6Uf6n1gpAAeGdnlTnziOg/V++GUaj0F0mYtkwGiitwxXIPs9xMQV0tkGzm+zL9TJnIoAKKWeGyPy6QPBbmbaIgvtcZ5WVpUsh1W1eS0ZJ6IqwGzjxy8rdnsFiILLXykoYcqz0lwVVesm
 UavVybro
 WUryUm+AbIT+iM5rprncbJVh79FGK6igmVogWvxK1wVmn5Tiu8e9A2INl7FWXoBOvXpggBk8gHGO6mepARxzBTHZQE1yjAeOtGm/KyQmXU0TNwsSIcdXwwQacZdvv3DEkDDMOv4Kj+teo0oU5t1h8rED8OrQq0Bfp2bSvknptYZjEmDlhIVz9/BzooskjL6txfdamQWZrfvLTeDjRoQu8tBuNL0FSS12xp+N9PRQS0LWDKl8SN/GDzoswJMUAuYSFyBfbBDm7rPl+8K0jnODVF70cSg9BZl0QSFhG+WajsZ1mkEh82mgQCkRTNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_net_ns_exit() runs after all the other pernet exits and frees
net->proc_net right after removing "stat" from it. An entry that some
pernet exit forgot to remove is left with a freed ->parent, and so
PDE_NET() hands seq_open_net() and single_open_net() a freed struct net
when the entry is opened through a file descriptor that someone kept.

There is no such entry in the tree that we know of, but nothing would
tell us about one either. So warn about it like remove_proc_entry()
does for a directory that isn't empty.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: e9720acd728a ("[NET]: Make /proc/net a symlink on /proc/self/net (v3)")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/proc_net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index dbcf87a257e1..df5484813d5d 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -410,7 +410,13 @@ out:
 
 static __net_exit void proc_net_ns_exit(struct net *net)
 {
+	struct proc_dir_entry *left;
+
 	remove_proc_entry("stat", net->proc_net);
+	/* Whatever is left still points at net->proc_net and so at net. */
+	left = rb_entry_safe(rb_first(&net->proc_net->subdir),
+			     struct proc_dir_entry, subdir_node);
+	WARN(left, "/proc/net: leaking at least '%s'\n", left->name);
 	pde_free(net->proc_net);
 }
 

-- 
2.53.0


