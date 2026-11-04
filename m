Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7951606D4D4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KuEw75ZJ
Received: by kanga.kvack.org (Postfix)
	id D398B6B05F1; Wed,  4 Nov 2026 14:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA606B05F2; Wed,  4 Nov 2026 14:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2206B05F3; Wed,  4 Nov 2026 14:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 924396B05F1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:59:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A3111A0868
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:59:09 +0000 (UTC)
X-FDA: 85398500418.04.B816127
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6C02F10000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:59:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KuEw75ZJ;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3KuHwYfVxA2BKW9aXWNrUpzpjPKgJiiNONww6sd1HY=;
	b=dEVdaEOAYx6SqymaQpIOlP+cXRSdO+ieYK4dSe10Cc8dGgvhOzGxf1w497ZCWGIyv8gzPk
	/YzRjNZECuBtiZFoIecaqZy6q/uW8npmItwmzIby45BI20Zqoh254H6qSnQe0sEYBrpzU0
	2x8a4ahBcLzXeWogZ6CkT5VJ/roQIY4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822347;
	b=rPFlP281JI+1zSVINbFAbHqYbRP5q/hgBYWgBiI9GOzIc7vIIFoiW1pucIXs4kxyX2WAvF
	ee45tN++anUgRYzSDBApLEOetdgWfp8IsUs38z8JPteIbherkANCesr0pWeCR6OKDhTfT3
	npdgQNTvmeoGT3t3bLFTUZ5KqGA9PRs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KuEw75ZJ;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EC6C61DDE;
	Wed,  4 Nov 2026 19:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044D51F00919;
	Wed,  4 Nov 2026 19:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822346;
	bh=Q3KuHwYfVxA2BKW9aXWNrUpzpjPKgJiiNONww6sd1HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KuEw75ZJhJWFk4/5j/u2bOa+7AhH2+fwulBHYqhzPzRCBHuO79mUpmvrjD0ahvKTk
	 tMMZB0uhduFqD7adhZiOSmSX6H7pUU+Iz/7fWtjCvnMrG3tjuNjl57qfHN8JLiB+Oq
	 Rm3Oh0NCtCkqXkQz/53JQM+5nP4aVm6NoL6aw41ZGwVH+gIjQScKsibl7t28PMzX8J
	 Relz0swIFmj1/UzelogqSD10+6zvUTgti41r7AxT6l0SRAeqLuXeHIz+lQBCMEudJ8
	 D0gnjIUhzk1S8cbTK7duy1QIkzoOq9EjAM3ep+eRVQ08x7iwdviy9H2Isj/FwB5UIH
	 +hsUDCjAUPclg==
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
Subject: [PATCH RESEND v2 05/13] netfilter: xt_recent: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:58:52 +0100
Message-ID: <20261104-work-procfs-net-v2-5-221e2437fed1@kernel.org>
In-Reply-To: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1724; i=brauner@kernel.org; h=from:subject:message-id; bh=gfCX4go650si/jmePs4ghyuoQlNEiWKnWuOHaoexE2I=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97tPgfnpmuaqac2LLJosupqrIeQbiDbdNDT4dmvzo/ DFR21+WHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPpn8vIMOlw/R+eP/7CM+xs f+8t/fr+Wv4HSZ077vpfLO+H/1bx0WL4n5Sf/jFhe7/3hinn+vZsSZ0htMuiNFR9e88x7jnfa+s e8QAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 4s73exnmo7acxoo6fjjksfwhteqmt33g
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 6C02F10000E
X-Rspam-User: 
X-HE-Tag: 1793822347-440126
X-HE-Meta: U2FsdGVkX1/7wV41BwR5fF/kZqX189Gz/HuOwAtRuWmk7RB22Qe3wyW9vN6rMNnoBMGMwUXN9eANAKKC+wp/brjE9GdLFqSlPTNKmo9btXws2708O5TxTEeGMC+NTHpl7Qo+rRXWDmbqKW4u12Jbh2HTTM003/EptL/JMUMEIZSC/r4w3Zmgyeq4F/APfUWD1DgqCgV9xo69GC1HycRzc5ScKKejTz3LDAbRg73VnfB5kFirLpMSEI9HYeOcPn9S+BQpWCZPcgNxX0lobElZjEpac9H4RvB2L8sqVcA53y+E0ip5ysyLILhbKOHQyQ+GHm32b5hZ3/vbzFd3kpTaoAWKdO997uUhiy0+lglH26QzOir/rGC00HLKVp47WfNa4dLxEhX6jiJcTIKJp3lIfVfDn4MpfdkMXydn2CEaJYWI5D3K1p99RWXV4VG71L1EZwIgUlYnUCvbLla6b0zdv3jNkBF/SU9asCrQCyao2RHdPc1MjXIEKiXsZqkPP2ivwk5rrHFm3kp7e6hj15NNZwdIa21/pdKnZxeYCDP2r16xxhoJpMeE4A2AW+P/V43KuCogUlu5Ju9CILOF5geTYyXQT2oUd/f8cQ6jheAB0izFnMdQ7wHzhUj+ddZN/U23koYg3wTceIUdqboPHtJwXFnk06m4BJjeXnSHsLoVtRcRfcrP5DVvsF1Miuc5qJe49prout9NVMakiP1WrMV1K8kj9sguNwZgjE0svvkl8Z28UagXYjoM3gsDAwN9PqpYMEnRm9hdWUTvCu4x2Qal+Ahjw6VJO94Rc9UNhcEFmD2H7QN6KEa/3opKMpV8PC3Ky76KThWDy/IjPm7yNk3hxRBQ0dviK11EA3Fq6hBwYoZPE31QGtXnE0wlMv8xNsDprNbSOOUHi1jdq2kpe76DQv8ni8ysHreZnVasc+3nAHC5l5M0Ez/vPnBizzaF93JfzFw/lXmO2gQtuQ6iQvx
 /hdNxTma
 Xs/jISbild+LL6JEQ1JlNtZgjRo8hhFeLM9KIDzpCGRy48tHHSw4LUCOpEWNRydZNLWezn/lDn5x2OeptK0vKK4okPPt2A5OTk+o5ghi5Ozode1t+/pdLn7myWmrun+dS+S9hw92Qz6WeyU7dwwhCPkTQGogprv4k+n0o+hviwl1UgPghiVXHg/ure/27r+QrEsG2gs6srVC3XIXNABejheDgG4wxRw+xKdU2kWEOM4eF2870Tz7dLSGbhZY7WQutQCOwrvjUfVpB67DRhWDb8Q7mREhw0VBZL1QdjstUJ0Fhh3dJbVTq3JkgyXqbkI6CZ/8Pq3GdgDq5LSPgmRLZU5JbXSDmYcpaKo3LXa4WoS355XwT0f80YjOenDAFaOay8HrbyAyMrj67W7zrOHKBXTRSBdO4XrgnaoE9/bhDBl/fCfaNgdZfY8Nzy3V4ny6cYJqe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to
/proc/net/xt_recent/<table> before it pins the entry, and take the
address from that copy. The removal of a table runs under recent_mutex
and doesn't wait for a writer that faults on its buffer anymore. Writes
larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/netfilter/xt_recent.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index a43fff5308da..72407eeaa9a6 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -553,8 +553,7 @@ static int recent_seq_open(struct inode *inode, struct file *file)
 }
 
 static ssize_t
-recent_mt_proc_write(struct file *file, const char __user *input,
-		     size_t size, loff_t *loff)
+recent_mt_proc_write(struct file *file, char *input, size_t size, loff_t *loff)
 {
 	struct recent_table *t = pde_data(file_inode(file));
 	struct recent_entry *e;
@@ -568,8 +567,7 @@ recent_mt_proc_write(struct file *file, const char __user *input,
 		return 0;
 	if (size > sizeof(buf))
 		size = sizeof(buf);
-	if (copy_from_user(buf, input, size) != 0)
-		return -EFAULT;
+	memcpy(buf, input, size);
 
 	/* Strict protocol! */
 	if (*loff != 0)
@@ -625,7 +623,7 @@ static const struct proc_ops recent_mt_proc_ops = {
 	.proc_seq_ops	= &recent_seq_ops,
 	.proc_state_size = sizeof(struct recent_iter_state),
 	.proc_open	= recent_seq_open,
-	.proc_write	= recent_mt_proc_write,
+	.proc_write_buf	= recent_mt_proc_write,
 };
 
 static int __net_init recent_proc_net_init(struct net *net)

-- 
2.53.0


