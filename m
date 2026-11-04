Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D896098F53
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HAw6s8BB
Received: by kanga.kvack.org (Postfix)
	id B82AA6B05BE; Wed,  4 Nov 2026 14:54:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5AD76B05C0; Wed,  4 Nov 2026 14:54:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A710F6B05C3; Wed,  4 Nov 2026 14:54:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 885DF6B05BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:54:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C6ECA078D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:54:37 +0000 (UTC)
X-FDA: 85398488994.04.0A16339
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 650134000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:54:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HAw6s8BB;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MznRqphvtEZQp5npCZI4V0Q6Ll7VzqUvC+SM21Py/Cg=;
	b=nf4PFtx/At/e8FPRJJ8r+56PbwK3/dXuDjSx7/2dB2vF+NqwZFBNlf8phygvENvKnu9Omx
	m/fVV0Wb3MHnrMy5L2xDJ/7QIq0hdQQEeuipTje5OGaODT4oQL9jzSe+u4bgSiMgO83vkr
	rjJo/QrFz1D5zongeo3rFQ5z4px+w8U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822075;
	b=bOKaVGbAvlUhVo2DYpQdB4A6eB/UyFDqISLDneUftmUZz2XxIHqIZCddcr8ExyPvFNInxH
	hk44C8KUfBeDBIxppJvNjuYF4m0ADiiolAzKiNM+e1CiEajfs100THp9Eu/zs15QNnXm/6
	warICHByhBZQYinXRb1PzpBQ63c/Jjk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HAw6s8BB;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 02D6B60DD5;
	Wed,  4 Nov 2026 19:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA34F1F00919;
	Wed,  4 Nov 2026 19:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822074;
	bh=MznRqphvtEZQp5npCZI4V0Q6Ll7VzqUvC+SM21Py/Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HAw6s8BBQpMyHhrBN/asRF3MyBAYmvDQG77oX4IdbQ/Fvo+Dc9HrA+ohRms91kTq1
	 tGhNQ04Nlq/t5AfIo9I0c2aXY/M5rtDTWUuPNd15k0EftQU6IZz/1TwoK5ymzaduHR
	 KvYeTEdLCNXdmy5ayLOGUZDs71r+gh7UBQKBI6RxE/xvbUti6reVcmIlIBukQg/oVZ
	 3GplheA6ivbtF04reRE084gkHonlgWY7/SEBNKSZb4CeUx9EDq8ilSbzdKz6xramV4
	 xWoLAYuCOzLrRq2otfJd3P7rRpoURXvc8stKQzocl2lC26pljUbnGmCOVptz3/wPze
	 zCe5glH7FfhIg==
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
Subject: [PATCH RESEND v2 19/30] sched/psi: mark the pressure files permanent
Date: Wed,  4 Nov 2026 20:54:20 +0100
Message-ID: <20261104-work-procfs-fs-v2-19-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2074; i=brauner@kernel.org; h=from:subject:message-id; bh=Q4lGavm4ZGBXo39Ieuspgksaf3Gh3Wa2s1ilX3Hj4ok=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97nE6m3h911tVzfl3TOQ+HGv+VCMdmrs1riUii6Fn/ h6jaTe6O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbyOoXhv3tM6SuHq3u6jjOp iTG8jZr+w3t5XtOCK765Bxxfv0uo9GVkmHSW9bDFvZMHG36nuv3fEtB3J4a7ZO+RCd52Z7kzO6s y+AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 650134000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: qnq49mhsq3czntofkdunnhgf5y64ncoi
X-Rspam-User: 
X-HE-Tag: 1793822075-356479
X-HE-Meta: U2FsdGVkX19BobvY020Gsu//TTMC13TP+www3nc9xJ2vmYPkVldbotmXF6hFCiRhdx8pu1lVODACom2X2QLwB/53EpTKBY7MDpiWY0PsRniBiJsmCOLhlane4Bhszn8kwPJYpr1yTDFmkz3JmaOcWsNhR2am72mD5Ebypufje9ISQMmrtk2lS+PaEBnE36gUQDKelqhn2KunhkGVyWfYeN18YENohubS7eUoWjPtqn3BTNbEHJU/hzHmlMZIm79d+59uSM2CGD7GpdsdZCQxLbCz/lWn9E+FmhDdYb81y96oaiExbcLg33qoJgPOHubhltf30lPCUn8uCIGO+IsPCSv1gbCkXdtlBZYUO1SrnfqZYLOJyEEPjDwvu65zg9Ioj2uDfpBr3d2Q8dZRXhpHdZtjkA28INoTtJ8wvR/4SYlj5SXTcBN7HVQ0zub1+jOxBjAsWWjp2NTVsmS52dOtgbiqDnWRzoEVZt+158TAlQMetEn9gLXTVoesSScs3PX5iCQP1OxM1RRRCTyxlfazt2sPCcf7Ok/KOT8yMoyILoU+ddtM8K2tQ90VDn6aVIbPlYCAgGOWwWdHP4qY6lxW81QI3/dUAdFHXHZc9/c1PuJZOb9UvVMoP+yOVzZvkC6qwPwWN2SLUDKOE5aUcmRPBpoRlb2id20NUf0ZfJPHwnOCN2IMnQq6xFlsB4FKZchcovqgtjdY/o+y8mJ5v7YXH4ATgJgTJvsNwT7ThilQCFe43FsvD56TMSeFVxpFOFhGxWTTpGIMguHtJFMuf1fY6x20RLBxhT/T9bskK6JrFKoJ9NZDEyqCaaua4vekIhP1GX+dT5T3k4wNetCjdEsMn6fmJmo5Z/mvhxJaWJm0SzpVIdbe2UBMa7FGPU9z/1HWOnIiob2uIDZmGJrzDk7gIJ+iFuwt70AcYl3hHShgpzc7Nst112kX3wtTCAhC5vh6nNsLAGhSJbI+ntwZFJM
 XNZy+GpN
 1QL6fXdLlkKxw7i7hvqfZbXcx1lrIKwQtOzolMTfx5TA7PNzblWluGsgD3yp3QrR3oTpxDjUu/x3KA3ejC70MgPPh8eq4U4V4k4ET4RcmqAINxDXRdj0+e6+OaX2AaUke834X1dLvOAVZj9X91mYLLP6ysSsSDY2/aDiL1nm/+istxrRajCrqxAYrtuB6OMWmlH6KO3SfyFJ7IV4+bh2efJ5WGpTHMYTQmbFQ344HR8eU9YEAjF4WYZtJbpT0BKUlhGqaYQoJrIX/7gO1ppkSTkWP/pILv2mn5Q22ur7+EZaOAvkHh0hv29FeH7RaMW17IvCkGvt5iGHtXqKBaQuQdGmkpWXGNZRejpQtkgrfzfuz8tUA9qgyh/x511fo7EjiGPjBYAImEq8sLhEmYsBK9JNVnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

/proc/pressure/* are created when psi initializes and never removed.
Say so with PROC_ENTRY_PERMANENT, procfs then calls into them without
pinning them, like it does for /proc/profile.

That also takes care of a rule the files bent. psi_write() takes the
seq_file's lock to serialize the triggers. A reader holds that lock
while it copies to userspace, and now that procfs owns the seq_file it
does that with the entry unpinned. So nothing that runs with the entry
pinned may wait for that lock, and psi_write() ran pinned. Nothing ever
waited for it since the files are never removed, but with the files
permanent nothing runs pinned at all.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/sched/psi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 9b99099017e1..cdb7a832333a 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1622,6 +1622,7 @@ static int psi_fop_release(struct inode *inode, struct file *file)
 }
 
 static const struct proc_ops psi_io_proc_ops = {
+	.proc_flags	= PROC_ENTRY_PERMANENT,
 	.proc_show	= psi_io_show,
 	.proc_write_buf	= psi_io_write,
 	.proc_poll	= psi_fop_poll,
@@ -1629,6 +1630,7 @@ static const struct proc_ops psi_io_proc_ops = {
 };
 
 static const struct proc_ops psi_memory_proc_ops = {
+	.proc_flags	= PROC_ENTRY_PERMANENT,
 	.proc_show	= psi_memory_show,
 	.proc_write_buf	= psi_memory_write,
 	.proc_poll	= psi_fop_poll,
@@ -1636,6 +1638,7 @@ static const struct proc_ops psi_memory_proc_ops = {
 };
 
 static const struct proc_ops psi_cpu_proc_ops = {
+	.proc_flags	= PROC_ENTRY_PERMANENT,
 	.proc_show	= psi_cpu_show,
 	.proc_write_buf	= psi_cpu_write,
 	.proc_poll	= psi_fop_poll,
@@ -1655,6 +1658,7 @@ static ssize_t psi_irq_write(struct file *file, char *buf, size_t nbytes,
 }
 
 static const struct proc_ops psi_irq_proc_ops = {
+	.proc_flags	= PROC_ENTRY_PERMANENT,
 	.proc_show	= psi_irq_show,
 	.proc_write_buf	= psi_irq_write,
 	.proc_poll	= psi_fop_poll,

-- 
2.53.0


