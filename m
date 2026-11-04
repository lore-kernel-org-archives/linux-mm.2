Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A8D606B2EF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RsXLh3XH
Received: by kanga.kvack.org (Postfix)
	id 90D826B05B6; Wed,  4 Nov 2026 14:51:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5936B05BC; Wed,  4 Nov 2026 14:51:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9F76B05C8; Wed,  4 Nov 2026 14:51:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 605586B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:51:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04C1A14055C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:51:22 +0000 (UTC)
X-FDA: 85398480846.09.45C8792
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4811380007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:51:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RsXLh3XH;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LP8R0bNSKS2QH/Zql1k1p4KE760gSx77oAIYdTk5FHQ=;
	b=6Z7Gsvo4gaFhmaSfYIL1ztsng11MEsfSHe26XdCtKx6SYSk6FmIxPYuiMV9HBdskGBAwr9
	qxIlRxs6rKluqKoF+gvPToEW4oXsZn2iBumwotMWJ0Vk04TB+g5SOhNkUIwAYjZP/Rj5oK
	HkXYA7sPdixqOAcfuNxPWwjs7Ff2ZRI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RsXLh3XH;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821881;
	b=XKZ0HSCSx+v6adnWFTSeHHCDDxGCbLPQnuvaWV+IUFSIhGoRXT/xG9k+f2Z3oktm/FuEZZ
	Jc9IyAd84wClemJN1Frb8kL1xjK6NrCE5EiGmuhsXqL75fSn0McPcCfH1x5LsEkJt2bWlk
	tnuPDWhl/Sfv1XxgL4HybX/PSZToNcQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7C8760F31;
	Wed,  4 Nov 2026 19:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6873B1F000C1;
	Wed,  4 Nov 2026 19:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821880;
	bh=LP8R0bNSKS2QH/Zql1k1p4KE760gSx77oAIYdTk5FHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RsXLh3XHwh9i9KYLzGYCXUR/3jz6hvJBiKTUXoJMpIyHBIQckhaIML2AcsaatHJA1
	 0eBgijXzBWphawzWAAAliBSKwy94Zq0H8fcdbx7zd77a8zoJ0Ue7FRHLvIZ7LfaCRL
	 NWsF0xR2vHzqH47EGJ+b1zhQAPz56CBGLrP9V51eK/aUOfQX+ePGLsZp0VZGcq3umB
	 NDozx0Pud3lqomDaEsA6NBp0dWh/oMo1BEzvyC9LXCvrcoisYiWT1saIA5w7Ryz3SA
	 YyQib6eqTR5sEMMLmZee9CeR7k9yWAYrkLQ/ZLwHgmz6BrgXZZ6ltNiDOnrSr0ulvD
	 XM4slagBXfM8w==
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
Subject: [PATCH RESEND v2 06/30] nfsd: let procfs own the seq_file of /proc/fs/nfs/exports
Date: Wed,  4 Nov 2026 20:51:06 +0100
Message-ID: <20261104-work-procfs-fs-v2-6-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1388; i=brauner@kernel.org; h=from:subject:message-id; bh=zWLMsIr05BMF/tXliLgjdHfvlEWh2osbn3SGLQ8SJYE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97jGs4JaPtH3mH5ykZTabedr3t9eLXxuUWtVOVPA6f zVLaV15RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQOxTEy7LkV8VeozHTu0b5W PgXDRpfpiWc3tHXbzdur9fTJDgPvGob/HiLTPjd/X3HGOa2I9VGcSnVnmAirzPkpT6wvTMpmfzi TEwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t5h6twqe5jqzniipdf3xwne853opobgb
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 4811380007
X-HE-Tag: 1793821881-850097
X-HE-Meta: U2FsdGVkX181vGRyuDHffRttYo4EjaOrOl8+Myjg5PPzSUIJOdihOrVbeaJNYpGAP02A2UCWgLd5TdUnx8XcEiMg1aFWEtk3T1Tt5lltjS8QZ0y6hlosaZcC0stQIavk+N2KTJIXX4suObZqDyJRTCsdyG6XPnoBulv+YLn2qqc0z/zxG8cFJDQQ9Opqy8BJjVyXIup9G1NDZujkMddXG9aGgbx5+Z3OMU2u21++oGeFq+O4gtMxFhZHejQBm1BH3t5oIQewmi/sxaa6yGu57+xQX+e6uYGfw4CqK3OT5Oz4KsDYtJTwup2Te4CP53PGxYNIQ8UNax0Mr2ZVL70GA0+shqOajlk3k3/sdZ5CV9aPHL4XXwekaPj6HKezLYYLS1w7TGy3LRZAb003n32Hjw2yhf4eeJdo/idGuNuINLNVWW4TqBlPzq7PWl6NagLdAUAkPCLUpK91WVoteaTDZrWIgnx7XdhMLyHaAdCJEMCO6ggH+T4ZvB1/8FKmPTjQ4p1iRTjnS02MCluKdUSiG8HXvvKGEBYj2BEt1UX7BkcsDcM+552Yxo6kCfGeKDeB1DKdGQv9PSfzHwpfbHv0jZoOmnfTpduefKDZjQs5y355f8A09hOo+qTHobZQ+VmXET6UWQ0rnwoejjiaSM2Cn+cK+JlbT6Hw52bM9ff7f5SLOGhf8gfh2qO8jz6Ces090Vc/AZm3LFfEIJHxiC5qkbkHLh6Zp2ysfmjJaC9KJ2EyUc820Plka6wPo6Aw21skm+QhT/9jXX4ZghsE84qZ0z5LHDA9d1ekFX8w4xQLxBW0f5+mftd/4SapKLf9A/4oqX87gBfUfF8wfJRgHVCpNtjSY1s+q3FMusvPTq5nahT5e2wVxmU+YGXLT9hogs853uVymvfoD4CGHVcM/12FfCdGPHvmmukfUvmcjOPdfGEuTY1QRPVJeb5KI5xe5t1Hf/mDz7reumciQsQlPWu
 hr1EBh+b
 V5DPJ0V6v5DWiGzTuGi8QkkvAI23wHVTkp+HUYtU4JuDzhm6036J8abr/m3AObv2umxrjUMRFXsgs7a0as1fhQXXZWzViDNpBqWfEQZPGCApF8/45UKHSBtN2JPJAkdMZxmoYBV+u9lTCrKWjlt527z9+CTn7hwdge2zbHD9/Wnp1QrYnbcRkWoMFAgb4ltCf64wfEZCH9H5z4m4K3i0rtRMRScueK4McMRMjZmSg0eBWb/IK6U9+0KSS02YzqVjlaEzFsdLPXedHw/86OVEoGZnhURr5Gb8cTeDSLGf5iZU5oHxl26vF2S6vTkTDHzx98eoFFQ7eOLik/6MJYHChbJKehG7v4T4I+StoxE0xr93y5RgQaue5f8g2dh01BVEv5DqmzTNW1SIo2n46Cy50exsH7ZCN8B5MyYhLQzbp3batjZicP6H8ShLmlN2fp0+QCR95
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the seq_operations and let procfs open and free the seq_file.
->proc_open() and ->proc_release() only set up ->private and take and
drop the reference to the network namespace now. Reading the file then
no longer holds up its removal.

Acked-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/nfsd/nfsctl.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index f8ce3c0fb077..5b2782f9dbbd 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1407,16 +1407,23 @@ MODULE_ALIAS_FS("nfsd");
 
 #ifdef CONFIG_PROC_FS
 
+/* procfs opens the seq_file */
 static int exports_proc_open(struct inode *inode, struct file *file)
 {
-	return exports_net_open(current->nsproxy->net_ns, file);
+	exports_net_init(current->nsproxy->net_ns, file->private_data);
+	return 0;
+}
+
+static int exports_proc_release(struct inode *inode, struct file *file)
+{
+	exports_net_put(file->private_data);
+	return 0;
 }
 
 static const struct proc_ops exports_proc_ops = {
+	.proc_seq_ops	= &nfs_exports_op,
 	.proc_open	= exports_proc_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= exports_release,
+	.proc_release	= exports_proc_release,
 };
 
 static int create_proc_exports_entry(void)

-- 
2.53.0


