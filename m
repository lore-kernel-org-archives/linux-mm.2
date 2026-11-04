Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5DA16070E6C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NBvnHOor
Received: by kanga.kvack.org (Postfix)
	id D46F16B05DA; Wed,  4 Nov 2026 14:24:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1EFE6B05DB; Wed,  4 Nov 2026 14:24:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35FD6B05DC; Wed,  4 Nov 2026 14:24:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91E2A6B05DA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:24:50 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27EE11A0852
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:24:50 +0000 (UTC)
X-FDA: 85398413940.12.41B6D7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 758111C0007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:24:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBvnHOor;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820288;
	b=xo82AD9vn6Uk9TmAQliGtQtDrGAdqwCeiRNZZRFpXIu8kZLrHO/vrLYh1ByneZepvWJzZ2
	Yd2GiejmR5u7DS7gzPxY0NzxerzZRoE/+ekdpD08A5x4fGm4T3PCmRBhClgI+dEwn4rxS7
	lxthDcGtxT3P8f3oAFcxTJXpeJGTb6E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBvnHOor;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89c02+ELWuX5+S2o66zdN47fZ8jrr3os6Vl1YJUNtuU=;
	b=LnI+ZnBi84whzDRVdVy8aMtxP3w2UX60+ZRZLoMJBk28mQYHTs921/wzmVR1RzaXtKF8FS
	EZW3Hq4iVaCJz15iHLZ3u22htvRwvN3c5+mxdS5w/g4sb0aozNf8cnLnes9ZdZVR4D5Inh
	ogn6KgSaxULAH/rao1bNe+BVKYHX+DI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0276B60D84;
	Wed,  4 Nov 2026 19:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C990C1F00919;
	Wed,  4 Nov 2026 19:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820287;
	bh=89c02+ELWuX5+S2o66zdN47fZ8jrr3os6Vl1YJUNtuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBvnHOoroeWxQ1cOOxGo9m9MA6Z7LEBlZbLAJEvOneMlnaSFVUAHEoOxi9i2IfbXF
	 w20Ht0aXbsrhlt2LI+8dp7MfxPXK35jBrTUUE4uym6/6KRNyTKrtxEXHNfYj+zGR1C
	 MrB2v0Z3ccjhhQerm8Lv/9FmrfKC9usWqJjV0ufa9B9Qw6Lmm2ksVQk22VO6bMLLE/
	 jg0y+5nrG1cHV7yAi4jBctD/xpQTxg0PKbh+cGWH0b/Sb4X964XH4XG0mppzdy1nTz
	 6/oUtDGSMGXK7yysZhE+5tK3yC0/sExDABR8ByjMCYipV1GH0kne1nc7HQcNhzHHJ2
	 v7JrFyLdA4wQQ==
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
Subject: [PATCH RESEND v2 35/51] proc: warn about entries left in /proc/net of a dying namespace
Date: Wed,  4 Nov 2026 20:24:33 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-35-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1410; i=brauner@kernel.org; h=from:subject:message-id; bh=WtI/bNxyA4ZViPTNrsQhWLRSUjQUZ6M8VP3x2XTkww0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bvymwr+T+Vz2JR+nc89N9V823XygyJDC9+jLAf3Jv AnTY2bf7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiI4WJGhsUW72quPfX4b31E IbtBQO1d76XlB6+6HQxzXub367PChF6Gv9IbN3C/7glYG3TsgoS65eoLbkHfXx9fd+nFlQ9vuiv 9tBkA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9nxfwxo517jq4xo6ftpi5n9iedeuot1a
X-Rspamd-Queue-Id: 758111C0007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820288-350758
X-HE-Meta: U2FsdGVkX18eYOYQox6uiNTxkLOXMC7aH8gYySbvgBLCtAfVdBGI+MGG5RzcIO8Jwo89HWr5aAZDV0fDpzRF5ZF3CHjvoR1r/TSwCp+kYDToWSU6ONPVDcbcSNHH5xc5OIfNUBbuIM435ZOy+howwQf8vwab1OM43bErmMM/0xwKuqp55tyTU+4I0ZoTj4Xd8ioC0UHUeSf+CqK968DO8nzb8N5qL6NaHQlM3UztEDD11x/MsnxTKNu5Z/oUDdSlPKaPjN16pHrFj3Q5o0Hd3Ii1lSg+aeCV5n7F7rX/IFfkeO0pLzqzlI/Mp3MXaob9VskycNjfzdL38QHllSfyRz92Mp/lgOm/PJ0O6h9a2o3q4iLRlahWhzY0PaohGCmoI4mBMbOT4ZPN85Jlt2mkz4BSA10qZmJiP5eHq+rcy7ksCllH9HvKvSAFsawyyavb8+4fuzhQHmWryR2Xvmo1i/l1mt4xAxxsZByTAV7w75+90lN74Yc25pg/CeeEnjVLzFNL8md6UGADpQ+K/DkwPdZMyLJEZqAMVzjIyRwStQFNkRj0XPNxrvU1q4tdd0Hnj86ioce3r2na6y3PoBUCIqOxRGY8t14m4XbBsj34uE1wZudvWAt0HhMx3xm4Y1x+8PYzUyqn5+3QXm2RYnJnOnFi1v/gjDP8bTsv9vWG3+FYMQGKOXEFhMgaDjh05mLDtkMD3R5CnWFxxI99zHy7exv72Jkadj+CawW9suGX3KYcIYSvVb346tFnrbJeJOeTd+7/wvx48opw3SZZyBOB6jExMEE1lSrUELzfaLU7gh7FO84pAk0uXeusCVEDlneu2rycGg/yAYLXoE6tLWjyRyED2q6to3sdUJM2+4jhUF54EGg009583+Q0AW8IEqouefZ86WaIcFjb2hE64sHekbEfRdEuHOghOKBY1fC5b5mhz6vtC3Fq4V3bgdAVD516vAQMxFEFSN+2M7VAVE9
 aFbbvokN
 t8bGpJMt7zNAdfuD+LkHdO0vkIaB2YWEekTq/4NVMwB5Bd2pRdJ1ccO/Y5uGHG0uLTNtBVsWSfTV89uaQBPzjbbIE0y9Y3ptDIfU4XVegSLBVRoROeMiK0VVHwpMl87sTiQEjY1qNq3u5pWEOV8fvk9nkYC7CCqtmc3bdpyiA2J49z062m1WiY6ed8UWB74wSBiZ5PdaI/bSxlU1IFqbrG5lHEnZJTOHKTvMgzg8qOpnLPmMD2bAiaWGTn3AjIJ2lSHnWDXjoTB0mEP1KFcv/QDJ8bhEl0QXU7aaJjIM3VV2IAnVkaBa01K0UHP9+bW/WR5dK2lHxXx3oczrUXM8hQ8G9s7TjEskOZqhoPV6QC5fWZKJ94ejFQjYl9IYI9IlytHEJfs3FF2k0l0AVkMZ5/rsi/fARq7fyHD7AsIi+RCv+T7/icgB/nJobgQ==
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


