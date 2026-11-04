Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8A56070ABE
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KSlee+0X
Received: by kanga.kvack.org (Postfix)
	id CF8EF6B05BC; Wed,  4 Nov 2026 14:45:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD03F6B05BD; Wed,  4 Nov 2026 14:45:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE7A76B05BF; Wed,  4 Nov 2026 14:45:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EEAD6B05BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:45:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C2AD160851
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:45:56 +0000 (UTC)
X-FDA: 85398467112.24.6644B10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6D8124000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:45:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KSlee+0X;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9IR2jOxQyurV4Y0UWx6k8fIXiSGUImfiuKIP9CXfPTA=;
	b=ynWF7N3atGYn4blQl9Y1sj/4ZZnYNM7Z+BLndCn1z95TGTjMAy74yakZszZKIb3qGd8AN0
	98UHJRziW84NgtEH/W5qPTzfrat1QHOMN1xcp7BwHUTSLVXA7GYFL67wvuqZ8rXaWgwgEc
	Yg8j9lPDeTXoFuF1C4sSfAXtKkVukSs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821554;
	b=VYYtM7BmfbCOq1o7TPrNohBEnOhK1DJiqGeKgN2OlzanfFq7k1W4fwgY5Gmi/YQ84SxcEa
	JPN0ObqMEZJdt6XRw89wyUQIV6C+5GEg/K7eu91mI0AZabZON8QRnOSTiDBHI4P0QdfJGv
	/nfjzvTuffwk4vzJRx8eO9w4F9P8XoA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KSlee+0X;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01CD460F2F;
	Wed,  4 Nov 2026 19:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE861F000C1;
	Wed,  4 Nov 2026 19:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821553;
	bh=9IR2jOxQyurV4Y0UWx6k8fIXiSGUImfiuKIP9CXfPTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSlee+0XDq+bm+ysUh8nPtikOnchu9TkIAW1VCY3OCd0AvNcw44e5Hzp54rCEEeNB
	 L3jWndaPZFN6e+WP3JcpT+3RG0ZhvSz3tOpGSVIOUGFO+0FYAr1NPl7u7cOMMQ0fPJ
	 +knaMWTjbKoGzcmxQNH3DFEm9Ec3Nl5logdXw9qRd0FXTv0BIExvBcdGtMlpPD+P5X
	 hC9PgG8J3C1XX9TXnT/LOUtJaj+Lvw1tPb/+ixseUzpgnUtzTmNqW0vZ9e3rfcGTmn
	 SADjUJW9oNfrCSPr0BRrs6Hxsxw5J/g7bKH0shcxqMZgd6mz8rvFTNgLc1cdCHqadt
	 VP8DK/LvUQzHQ==
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
Subject: [PATCH RESEND v2 14/26] scsi: sg: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:45:39 +0100
Message-ID: <20261104-work-procfs-drivers-v2-14-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2854; i=brauner@kernel.org; h=from:subject:message-id; bh=PgyqcOYZULSLqb7qnigRBp/yeFf2Hrq3aYxTKZd6WWw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97mpZWdQr2n5nhfa9hbuuMma3507NEd2z6qhK4rplW k3LP34/01HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRYzMZfrPUzUxT2rba7uSD Anbzi5PuGN7V3NNXoe7+56FVZPzfOCeG36y1zXIX/9lqb7zUZV/JZH9mTlfh9l/TZrc98K+uDN6 7lxEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6D8124000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 6h5atcudcwd7fgyt3pgxf6rurjg6dzo6
X-Rspam-User: 
X-HE-Tag: 1793821554-697821
X-HE-Meta: U2FsdGVkX19Bz6lQ2fQa0wn05zT6Z38+YqWr7rf47GI7kttTOXg0TJIHkJ3+GxspR8r6iZ06D7sCmLs2KjGYVTVX7+qFXWrBHSc/hLgUOVADI2q2eyI3b28k8EAIh0YutUEtAUofcYgD6GgbkfPA2Nl6ScHZ0XgDrxLL1myHCA9gf9tORPfh6Ct0SkerGU8FPSv1W3y4ETR5/9ExZwYuBoaOLMkDGM8y+Lbo2PvgASwp/bATCZ6kOLem0qEDXJbDrBByfFOWu34dLOJOb7AbWxmCE1OmQyjG60uLmnL6cjHhYlM/1yRa+hWvp7na9KVRH/JLvQtKA6/sfsVDuaLJ/NTRf69WOaNYyEibltFcajIZlIK50Da16tMfnP8pQKPp0hAtHsx/dYqTTBB/3YIS3S9A+A3tCvSs/NdMAeQfAAPzCkDjJPty/zrCe/pW/Oqq6xa9vlBf1A3SxHOuLtHWjYJbxr6IlbHmGlO685zFsLJS27Cm/sec4jNSivZ/1bD7gt6yCBu1MCjKTJh+QvSJ5PaYSLR8jFXT34IAAmSBvyD7GqQ1pXQFwicIjARbaSZyE3wU1s974ns/narsnApwmZBvUfbxQGHUricUYDx3CRlTCE3Nnf/VRjpI98j6KmkBnzTg3RajmDeGuxHuh9bouK8JDI/JWCdCD2Yw7L1j3yL52LvY3lcLm9HJdq9x1l11EMrraLPd/9YPLqZ/Ar3lgwQW3IcZdrXCTeai1uBwsB93cfrKW5YAohmpfxMPPRvRIFWG84b0CIjVabHqxabxLUbR3uVYFSCqaM6mNqPxNL1b69oQqJ5CIKO1qsTTl2LA7XqV8jQaRREAgwFE8TJBef8JH8vONBfk3mk60Vlo7wbW2VTyemLgEuEEZeUI6PqxwA+nNo5LYs6+hPW4YL4B4h5bY8/Y3Ht8cDdPPhYp6GVB2YyCT/t9ckoMaI6FNMrBBD/rxgQznQ4zsdtSX+4
 WgRf2sH0
 Cvi3F2XywZvxQW2tUL8EUngbHaIUY52aCz9sfyFgUj7qsdOWTLXK33w4hVqJMWnfJK1TsLFOQkiu0uVYK5TPQQA14/48Yt6UACkcYF4ojQdfYE/lZ5S+zwek2+PRPA0/lSmSEVuz4o16aoB+jYRUQukkFAa9v0QfVtNohj+thBvmchTkf1pYxn/5jYGASD/Iv5uc3GARIcGaPDNm1Uwsw4U2M8LqKx0JHQ/+5N9jbiLgUixKpUTvU4nEZ4MMowcNTkOClJZKoLytMyjVjNF8SHKYJrB6c1GrNqSvQp2PNwDdecZMF1sSDqP0k4rGp9dslWEVg94McelQ/cByM+5bT/zRbffub9dNnw4YG9qWhAHhO6EEZN7uWe5JR2ilEhIDM+8DQYGmZrIxzUPjOR5ta675mGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() for allow_dio and def_reserved_size so
procfs copies in what is written before it pins the entry, and parse
the number from that copy.

kstrtoul_from_user() looked at the first 66 bytes of whatever was
written. Now the whole write is parsed, and anything larger than
PAGE_SIZE - 1 bytes fails with -EINVAL from procfs before the
capability check.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/sg.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index fb3ab74e8727..df955896e65f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2288,18 +2288,18 @@ sg_get_dev(int dev)
 #ifdef CONFIG_SCSI_PROC_FS
 static int sg_proc_seq_show_int(struct seq_file *s, void *v);
 
-static ssize_t sg_proc_write_adio(struct file *filp, const char __user *buffer,
+static ssize_t sg_proc_write_adio(struct file *filp, char *buffer,
 			          size_t count, loff_t *off);
 static const struct proc_ops adio_proc_ops = {
 	.proc_show	= sg_proc_seq_show_int,
-	.proc_write	= sg_proc_write_adio,
+	.proc_write_buf	= sg_proc_write_adio,
 };
 
 static ssize_t sg_proc_write_dressz(struct file *filp, 
-		const char __user *buffer, size_t count, loff_t *off);
+		char *buffer, size_t count, loff_t *off);
 static const struct proc_ops dressz_proc_ops = {
 	.proc_show	= sg_proc_seq_show_int,
-	.proc_write	= sg_proc_write_dressz,
+	.proc_write_buf	= sg_proc_write_dressz,
 };
 
 static int sg_proc_seq_show_version(struct seq_file *s, void *v);
@@ -2360,7 +2360,7 @@ static int sg_proc_seq_show_int(struct seq_file *s, void *v)
 }
 
 static ssize_t 
-sg_proc_write_adio(struct file *filp, const char __user *buffer,
+sg_proc_write_adio(struct file *filp, char *buffer,
 		   size_t count, loff_t *off)
 {
 	int err;
@@ -2368,7 +2368,7 @@ sg_proc_write_adio(struct file *filp, const char __user *buffer,
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	err = kstrtoul_from_user(buffer, count, 0, &num);
+	err = kstrtoul(buffer, 0, &num);
 	if (err)
 		return err;
 	sg_allow_dio = num ? 1 : 0;
@@ -2376,7 +2376,7 @@ sg_proc_write_adio(struct file *filp, const char __user *buffer,
 }
 
 static ssize_t 
-sg_proc_write_dressz(struct file *filp, const char __user *buffer,
+sg_proc_write_dressz(struct file *filp, char *buffer,
 		     size_t count, loff_t *off)
 {
 	int err;
@@ -2385,7 +2385,7 @@ sg_proc_write_dressz(struct file *filp, const char __user *buffer,
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
 
-	err = kstrtoul_from_user(buffer, count, 0, &k);
+	err = kstrtoul(buffer, 0, &k);
 	if (err)
 		return err;
 	if (k <= 1048576) {	/* limit "big buff" to 1 MB */

-- 
2.53.0


