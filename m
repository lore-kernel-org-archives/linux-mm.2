Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C2F609B34D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aDk6OKCI
Received: by kanga.kvack.org (Postfix)
	id 78ADB6B05FE; Mon,  2 Nov 2026 10:26:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C606B05FF; Mon,  2 Nov 2026 10:26:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651DC6B0600; Mon,  2 Nov 2026 10:26:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3756B05FE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:26:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1264A6689
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:26:15 +0000 (UTC)
X-FDA: 85390555110.28.0641DDD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0A6F140002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:26:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aDk6OKCI;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633174;
	b=Ucd0A58BAzh+0qIAXxTeLXgbQrxv1LVG+iFZCcX+SbiiWPVi1QL8vIPUOOQQCFdlIiDYw5
	nFO70VHHdIz93yzNBmWTwdmd7QBlZqZ+3imyWdtK3tK8R3jYu0DQax5qH3ZR5MtZRE2xuP
	f4Y7AFLXEpA4oSn5QkgctYUSSUeiUq8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aDk6OKCI;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1LcgTjI6osh59ZzieUt8cHCAfIdiXhMZk2FTOpmVb0=;
	b=p3uMGqcVLX3x2TTMdo7cM4qv77hum4ErRdYQoo55hX3r13SFaQ0DixhTKHDLX5u/qoCyX1
	Tes2gyG+QoMoXCAFCjM4weDGAAZHkDm1YAZ6ugylOSEJU6p35+afCRGhbxYZWDODAeSq6T
	E8W21CDyAUy8yM2GscPMWGqY5Isd6OY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 42BEC40A1D;
	Mon,  2 Nov 2026 15:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E611F00A16;
	Mon,  2 Nov 2026 15:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633173;
	bh=B1LcgTjI6osh59ZzieUt8cHCAfIdiXhMZk2FTOpmVb0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aDk6OKCI0ar0R/BnCnovLiGiUgsQiS5cX2Iwq/bm/oxbS1/IImKGdug7FdOjvklfD
	 64oCwGAK6j+ynLF1muOCW0FEO0ciDHlSkU3IC2ugiIhQRfFVM/NQ0oqazBDBhOY57h
	 sJCWDt4wqHqEb5aSyBD/+EPtWOITuneefzTGQ8mUGHB8tDqm3gA+4PZZ3S4JIuMiZc
	 GXmPDubR+xVQwezYvxsVrQArwRXqg2mHgtAgwVyPXxzSE4iifxjtpH179wLH+qs5l+
	 IW4VUxjdneaQ8roktcSnrLzCGbyg0Xatn3vQmPJgGEy5D/5zzbKmwEEMZ7lOT8pEwl
	 qwtHvgii6pE7g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:07:28 +0100
Subject: [PATCH RFC 18/27] sched/psi: mark the pressure files permanent
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-fs-v1-18-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
In-Reply-To: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2074; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tXr5cu1BdmO0jHsjps1+bZ2IKVwDVWrseoizU64SWOY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7kztYrxVWs4L7JrPOz+wSfbxdD3doWh3h9ivDfs
 j/t3nS+jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIl8TmNk2OS7Of/7mXtnrpvY
 SWw+cDKm06eJnev5ArnA2Z7Kmpt18xn+O605/1eW86zoiteWxTHfRDjWzEmrUjjwJ+3Hhezzqf8
 qeAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A6F140002
X-Stat-Signature: tiacyx7x9d8e4ugn9kht37376pehw9tj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793633173-322055
X-HE-Meta: U2FsdGVkX19PM+fD2Ha4g2r/GYOOhlaec68k8N+tZ9htKeP/OviDGBy/oqWUEWphDucVxf8ckTTNiOJNjId5m7hQN86bJAKlRb44oICnBZGnOZM+EYU+l6cWpujIHxFa4js478iA4fFs48kVQiS+BDAoSZff1lsOhef5nyE2Ogivu0tWm1thyptnAlTb65fRUGHROhOKSCvyQc4+jtyGnQgYRVh6TPmfmrcvotWgLHHouLMv1WOQ3P86qkT4xKt0yf3F2xCU0OC4Yjk/TraETAMHeWSsHeAikz1wNVSIOjQyGZyQqnGcxDsQ4kzTv/bW4KOLMmISzE+gcVXP7zGAqy+lUL7/Ox8O2PfHTLHHd3kIzMVASQuHGxkafgPsE6uJnP+2W0eXovPVRz8pHchhQROK2d196UFEGSD76nXuKkUCzZtCaBVJAzVBT0LqASlimrje82RBhHeV8RrGuC70LpLUyEPXBQVoBgr4lOroV7uobzMi2etHGnAbUosWoNuFKFMO2NWpevvVmHj2CBhKTewQOVwGaeNny6JlBwdelzOD7EqSaylNeyKqeNAwHszOuYKKxIpfRbSq1IAUkFdGZ6kPznkUXe1OnTXxVKyEmqN8m/3k0svGS7nDsB9mp0CN2D0l+q7sPK/bSG/gxoCVCYytO4FiNxnczLANfdqjWADLbTUt7Bw34iQuAgQjs2U7D3/b/g8n9/jTk7VDGrtlLPabHZ/m5X8vx3SgajeXF6DBqquQmOIjTqyTLhT8dklqwj0UiesZuZiAl3XPSEOtF4rFCfIzrjDDHQ5FjAybs4t9Zpmc32cx9qzp7riOqEGSRMpuo/SRUVUtLyTSQoWJdYf0TDBLhfM5d2dwO0eC33+gxiXSU4Wb/OzUqJ1ktoPhyAQDswxtY8lrfMoVgmC45n1MQiSNpOiulCKHHBBEeoskorjaEzTvFRxReXp+bd0UuW48mnRK0fTfKjC5r4o
 mF2QtaJS
 /WwTr50bsv4rPWWSGcbFUWHceT6Iw98fHd4+i4atIbzmHRqVvK1ucgcvXYyJqoEbxqEtt0JlLPkL0NntF3Nd+DQ6xJ+8SQkjT3+k36pnqXZUFF057Qft+3SkV+zqBoCXIY6tZC9ApdtZ55VnPMaC7Iira/f5X2IokLzWGXDVhklWlI0eg00BitW12oQLfDncoO7zopvErBtlXf8WxsoYsGQpnOtXU3L+8hRHTtDXPELmeY0RTyWX3JySQs1WGPmxU8OA+HgDeaLgpiWjLgOE63dDpyXOCdTh1A+eA
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
index 3132105bf382..9811c3b705eb 100644
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


