Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792C8606AB19
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LVMZm0IO
Received: by kanga.kvack.org (Postfix)
	id 8B5D06B05D6; Wed,  4 Nov 2026 14:46:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88CC16B05DE; Wed,  4 Nov 2026 14:46:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77CA46B05E0; Wed,  4 Nov 2026 14:46:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 567236B05D6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:46:56 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA23A40838
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:46:55 +0000 (UTC)
X-FDA: 85398469590.12.15078B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 382F580006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:46:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LVMZm0IO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goLGxFor5aDHmq+/63YZ7VsFVk0WPo8/IlwPxf0/q/E=;
	b=ROOJEqKsg9vrCaYAb85gF6SMmEwdwGLzltemKZQcT9fS6Y86IT2F7pECMawa0o0pKtbE3s
	f4O7UIxmHv2HxiwdDG8PWk2+d3btkFVRQQnm8NOUAKWsbAuqaDWfV38nrZsOM/eolgxIH6
	MgTei9UL2jC7XtB7IZHdcwCriIkcx0k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821614;
	b=7FwiZcEV8JlNAidVN9qaWVjeN074vAbu38qcC3TgxcXLPv+vu9zG+7F9nOOUVvM0jRfwJv
	WyvN2kbRb4sfGGP7sx9+6LY5a64GYKSELK37pytY7nQ3EcyiRbFKzMe5W1HHALNFj21CfC
	O4pYfl+YGRcWXzD1Vmts/ebAgoObsUg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LVMZm0IO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BCB5760D83;
	Wed,  4 Nov 2026 19:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4276C1F00A02;
	Wed,  4 Nov 2026 19:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821613;
	bh=goLGxFor5aDHmq+/63YZ7VsFVk0WPo8/IlwPxf0/q/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LVMZm0IOAoe/DQ3iyc33C0U6vvCfuYGfRKLyvK77JIS2ad2dYfo1fr0s6jyBo2HeF
	 /cO/gHafe4OKtglnS2gd2IbNq62I2DciBiFSQRPnWz49+1Da+Yfxn7yCQOHHdkkqhJ
	 SyQJLxdbTjGThvJqrZ0hQlwH1BvCiRfW2DR2w48PwSAs2SGNzc8ijfGt5Ti7FX0Ma9
	 ZALNkIaZxmt5uLaGJebUicapo3YQcj3RmKTzNB/is1bSZz6+a5/MRe1UfphuPsFeSA
	 fMTDefO4/GNM4PXANBsPbqE3sMPNAev963B+WLNxipJzgCOoS8dQJsh8kr6gfxBiJJ
	 8JFSzbUONxOuQ==
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
Subject: [PATCH RESEND v2 18/26] usb: gadget: function: rndis: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:46:38 +0100
Message-ID: <20261104-work-procfs-drivers-v2-18-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1569; i=brauner@kernel.org; h=from:subject:message-id; bh=saz4p5rW2UOPmCRi+6zEslqjX7E5721ehvji7/y2TLU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97upctyQt79Wuds/t/D5NXqfXll7mFlqtJ78++jiLv oG1bkd2RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETsOxn+CmzmuTZxSeutN4J8 yYLimhPX1T2olmPLe3C06PkTyd7GfkaGX4klP1sT33A25J06fD9ObenelTMCZxUxKZStmM3E/WI 5EwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j533twynhhp1cybgq9e5k1hy6ynyi74j
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 382F580006
X-HE-Tag: 1793821614-279772
X-HE-Meta: U2FsdGVkX1/Ocl3Ce/l66USlXTmxmdEnwmXYsgfG3FHmgrz3dXHbf5j9b8WPiNLBu0C3dFOpNtZgaw8116o+hBu7GM8IVu0NZL1i5P5FSbPFGLnfal5HRNQwokUDPD12AW0plurmfUyfJPS3TKNqe5cx9dLc5qj6cHBMqruFq43HNiFbmYaq5KaeUgxfSo6oThlQRnwi2yik6juqGUAot+aYaMJLZMpRsswLaW7xufGyWlout4LcYsbBi7R/6sNw7F7hv6+3vnjMsouMMe3LKaLl8KJGZHO6e+W3Wr2dvi3fOMvl4ErOV7XvztwwQxKDRVdUHo4kJf11U/fjBwwk+v1XJNW9hpkNu5v45bHioXAML/ak+JNKiABPjWYubhhO5hcgWUbYzbLB0TcI+XIkApl1lq51qS4/h+zHKjtl9lC0OrJOyVPDsiOzUzLM6y/8xG+P4Toi1qis1AdyiDkWPKg5LAGmEX3RS6lZufXqK6bPRcvOEJrtPkLWLqp298YJeOSuZhaH8Zq0uHa7AKsjI0eIbpb56MjsTXd1+RankwNY86mX8qyENKtZXxwV0xJu+Bv30ZZzIDPUz2sYbAw6PhYHi2HMBmSb0hxkwJV4jK0hYme7w6ezTx6ICFw0/OXaEsR+nTq257/r38xqVOK4qsBHtqtVtRqMQtggmU5NCAs3ZCM/poVsjXZPpJxH+WWhWznw8UADJYA4N1k+2Ek070u3Z86BwE8sWJRP2u9Ygy1XjZbsfsr+5jZj/e7JFgQ3QJBZPMCa8PdVPuOLrtaS8hHAvf9Iury9Cer5PLqQ9bIiRo0Cy7kvqlviHH+b/Xuz6qxGsHHFjgi4ZwPIcDz0HNLscR7KnNmQarpCWzOdi4PrmCoMJzW1AUp1gf59gVpTNPGxP1R0WxDGXIrdXVXIi+n4gEkDIl5P+/hCuYnK/t763vaIDd5GfkfrDNQJmQIJnqER3WgT9r/iCSHcm7i
 h7Ha6Nxw
 iJSaMp1K5SXqtWSld+yex1jnry1k7t3A/f6p8M04ZoxauIu4iAEBGHrR5oOOR/yrmPh2tezMn2RG3p4GCX5Q41Lm3GhPWWI5LCep6SpA2vNjoVa3cjlTNcwBZHX9YY69Edobx9BAL6dx1Cb0FdJzaSDR2FAg91aHDMx8xG88RxAX6nPStPTmaOgBN0oe52HRbi6agUsxyo/nPdbfWcUGmJVJMMQOas9tduex0dn8sJI+/mLTSIUTtQfvmX6Kr7bR5i4zWUqkl8+zqbjlL6ld9YnpN7InDcf0D0ErEgMcQSf/1yLv/mi1j2rSncOvmrrOg9Y6nRnYCgRLOEw5Bwo0mJjsHhEN/Fd/nzTeMZRz7ZClfMYZZim8uQ4cPTQ7X7sjU5p+454+pC6yj8xYKpSCxKk1dpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to
/proc/driver/rndis-<n> before it pins the entry, and handle the
commands from that copy. Writes larger than PAGE_SIZE - 1 bytes fail
with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/usb/gadget/function/rndis.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/function/rndis.c b/drivers/usb/gadget/function/rndis.c
index 3c7bd30b8a3a..e05e0c6ae8fb 100644
--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -1138,7 +1138,7 @@ static int rndis_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t rndis_proc_write(struct file *file, const char __user *buffer,
+static ssize_t rndis_proc_write(struct file *file, char *buffer,
 				size_t count, loff_t *ppos)
 {
 	rndis_params *p = pde_data(file_inode(file));
@@ -1146,9 +1146,8 @@ static ssize_t rndis_proc_write(struct file *file, const char __user *buffer,
 	int i, fl_speed = 0;
 
 	for (i = 0; i < count; i++) {
-		char c;
-		if (get_user(c, buffer))
-			return -EFAULT;
+		char c = *buffer;
+
 		switch (c) {
 		case '0':
 		case '1':
@@ -1185,7 +1184,7 @@ static ssize_t rndis_proc_write(struct file *file, const char __user *buffer,
 
 static const struct proc_ops rndis_proc_ops = {
 	.proc_show	= rndis_proc_show,
-	.proc_write	= rndis_proc_write,
+	.proc_write_buf	= rndis_proc_write,
 };
 
 #define	NAME_TEMPLATE "driver/rndis-%03d"

-- 
2.53.0


