Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5309A607ED56
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZGa4uxN
Received: by kanga.kvack.org (Postfix)
	id 6A8936B05BA; Wed,  4 Nov 2026 14:37:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658E86B05DC; Wed,  4 Nov 2026 14:37:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D1546B05E0; Wed,  4 Nov 2026 14:37:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B2AE6B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:37:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA21E14081A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:37:37 +0000 (UTC)
X-FDA: 85398446154.07.0F02DEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 065252000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:37:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oZGa4uxN;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821056;
	b=2xRvcvOGrt4vdwJlyg22vpctaIdCqzThUeVn68WYZQhow36AKB3meXmCZB8+k1SrTOLAdx
	+A9+fep39wNzfeZ0llUJrwFr0b4ldN5gEgkFKGhLe9FaZHkhECgN/cFO0eEJDARoXw2rn7
	EtKJwuwerXHArIFW6nVSq43NZ/lrphI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oZGa4uxN;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBXs+Ai9hCvv2gTN7UF7ctcncQyXKpM3GPgKiB4YAT8=;
	b=W0mkfgqZA1lx+dLxcL6av2Rocs1x2S+/ZQmFEujR5witaClxsX8q7Qxa5GdJeebn8O10tR
	DRdEb2W5ttM3G3smFTdx72q9paM5OEUS2wze6FV3TQ9PGqpaTErXasY+mfeU2j7+3cOqUS
	OQoBziorfhRd+rCKV9H8NUxEBwhGy5g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BE6760DBB;
	Wed,  4 Nov 2026 19:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DB91F00919;
	Wed,  4 Nov 2026 19:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821055;
	bh=FBXs+Ai9hCvv2gTN7UF7ctcncQyXKpM3GPgKiB4YAT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZGa4uxNa4f8lPnKCnZcOshs5bIS38FNrm9Me6KMthFTmP+MOwFabIXkXu/wyKAZr
	 eMuwJ+f88gJjEcbCjCfZt9K+REs55uNNlIGT+aTII7ZPio3yO+n12ryLYxF/Wa4AGF
	 RTs/sXBBLK+HuDFmMw4GQx8DcZDiGoyEhXa9KRIJsWTr/ApICfUXhkzLdIecTTSsZM
	 nHz+oFP0Qjh5+4b8BIeAsHx40sCyakErwgtYM1ptBy94JFV23RAvKVaGe6b4yCL5Fu
	 zKdbeftWi3Cfr5diHQHdPhNunK20Crp1slFjQ4GoZOScF/vgZqztop91HodBl1uB/4
	 9Lcb7Om7gZE0g==
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
Subject: [PATCH RESEND v2 07/23] powerpc/rtasd: let procfs own the wait queue of the rtas error log
Date: Wed,  4 Nov 2026 20:37:20 +0100
Message-ID: <20261104-work-procfs-arch-v2-7-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1920; i=brauner@kernel.org; h=from:subject:message-id; bh=URY8OmvUYSj7cGs0MgqVpOcYmOKyD/AnlDpC5EfxAis=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vhysuHhtP2XD0+QvcrjIThN4YyziduaSa0B5Ze45 bccDt8i3VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRdXcYGf47m6tcV9TUtJW6 6rN1+ac5lkXuOyKb82c41N9Z+KfrawEjw4GOwjOGH8J1JW9/u80gYm/VabKvXdx4/nGt/Pjujku VLAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 065252000A
X-Stat-Signature: 4sga9r7uewj4cwpr48tro67ocom9iwno
X-Rspam-User: 
X-HE-Tag: 1793821055-766934
X-HE-Meta: U2FsdGVkX1/Sa3rafn5pRgkB1ZJ3Vs4PEDmfcse7BqqDdJwKGHRjK7c0FGazvC6hLnsr77MmaOVJXE+9ed+RivmLNhVqfXaRZHhY4x2aLKZ4CeHuP+/nk92FxfkGWIxCvnGe9qV53Cp3uRZbydOsK7x0bY4cNf2pUxLE7/Ersfx4u9zIrlBX3KNEz3NxxEuvWsl0izErFYn36a95H+NPi3q8PlSr03CUL17njPLahvdpCG6piG8FyWwoa5eyjnklsAyFD5d/oeXu98mcXvOa565l+fwdVlIYdxwngDJ9VJLzUIoybKALf5TriVrS9TZva6X7g/a7oD813+h5agIisML6ymqkrQSTiwiu8ivAVVGUnU5NH9PfuwWjV4krOvb8FkZooAykCQQuyzSFJS+nnfe4pdie3SQC82HNYQARVbl71APKKb7XhrAqt69JO4tyNEtfUTfIKmYRo6fi2YhOmBpX+zRQpa/QSqc/XsqYOYHzSo8Zx6OX01XzwDsAAI7foFh6bD4weiBKttIr8iUZzkxZFPEznrIABIxk0GBLegcnRsb+eG7Tv2PEE1rViECfEH30DdDOdT1fjD72jx/BJE2noE5+UyKdx5yr4VO7SwqsMP65IWnHpwzAOkJ2eWZyAVmBI/bmBOOMUPjTBhF0RCMxB8dS1Gwxg0oKwkVvCHH5vGNTQUuWxLXdqZCnaB6rTRlGxyrlz+DSBch7VaBNfSFUz2kzb2LOtAgp+cBkl6nl+Y8pSaL2Qfw88MucCSDyUowzFH/z+O0FRVku2/uuGj8F+hGVmZsVLJefTbhcxYwIjx2q3D7wLyCLHrThGx6Fz1rflWwBE4UJSJd+7C3PjwmR7yqnUv0ELpCG7kaXp8unUM0gFMuB/65NSiNGKvpB1aB3DM2UQ5i7TmNy8TCnVraDhAtxwfu0IGOPU/UJbQDUOrdpEros4hFwTOwOOmh4dPg84Nr8QB3xBeU63j5
 NYymq35B
 Cnh88m8ntJkCnH4OZKidX3QU82TEO2NM+7AQn+C3xsmulSb2Q9OWIcWYPMYXaqjtw/dECuJPImH0fUXKzZufFl3+225PI5Pj8wTntUhE0tj5Cd663sXMkavbFcjisgNWgXBCxKBT4G0P6uoYKvlL4EzvD/OJUJJJZxJc0imyBXf8ZHYn9KfAGWph2c9+Y0e2FTetvnpsdCDKHIPhu18rbSlIM4qIH2v4KJA30fLEGiMRi7aXioifG+Z9AAOiRbqxBnvK211Ox+DNU5KiiS71tnEQrog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

rtas_log_poll() sleeps the poller on rtas_log_wait, which the blocking
read sleeps on as well. procfs owns the queue poll() uses now, so leave
the poll_wait() to it and wake its pollers along with the readers.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/rtasd.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/rtasd.c b/arch/powerpc/kernel/rtasd.c
index 360ed2e30fd5..fa9574131f40 100644
--- a/arch/powerpc/kernel/rtasd.c
+++ b/arch/powerpc/kernel/rtasd.c
@@ -33,6 +33,7 @@
 static DEFINE_SPINLOCK(rtasd_log_lock);
 
 static DECLARE_WAIT_QUEUE_HEAD(rtas_log_wait);
+static struct proc_dir_entry *rtas_log_entry;
 
 static char *rtas_log_buf;
 static unsigned long rtas_log_start;
@@ -259,6 +260,7 @@ void pSeries_log_error(char *buf, unsigned int err_type, int fatal)
 		WARN_ON_ONCE(!irqs_disabled()); /* @@@ DEBUG @@@ */
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		wake_up_interruptible(&rtas_log_wait);
+		proc_poll_notify(rtas_log_entry);
 		break;
 	case ERR_TYPE_KERNEL_PANIC:
 	default:
@@ -343,7 +345,6 @@ out:
 
 static __poll_t rtas_log_poll(struct file *file, poll_table * wait)
 {
-	poll_wait(file, &rtas_log_wait, wait);
 	if (rtas_log_size)
 		return EPOLLIN | EPOLLRDNORM;
 	return 0;
@@ -529,17 +530,15 @@ arch_initcall(rtas_event_scan_init);
 
 static int __init rtas_init(void)
 {
-	struct proc_dir_entry *entry;
-
 	if (!machine_is(pseries) && !machine_is(chrp))
 		return 0;
 
 	if (!rtas_log_buf)
 		return -ENODEV;
 
-	entry = proc_create("powerpc/rtas/error_log", 0400, NULL,
-			    &rtas_log_proc_ops);
-	if (!entry)
+	rtas_log_entry = proc_create("powerpc/rtas/error_log", 0400, NULL,
+				     &rtas_log_proc_ops);
+	if (!rtas_log_entry)
 		printk(KERN_ERR "Failed to create error_log proc entry\n");
 
 	return 0;

-- 
2.53.0


