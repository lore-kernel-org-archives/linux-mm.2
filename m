Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 682FF606A87E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=byXXsxYw
Received: by kanga.kvack.org (Postfix)
	id 733996B00EF; Wed,  4 Nov 2026 14:28:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70B646B05D3; Wed,  4 Nov 2026 14:28:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FC0F6B05E3; Wed,  4 Nov 2026 14:28:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40D156B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:28:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D35581A0828
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:28:28 +0000 (UTC)
X-FDA: 85398423096.30.CD58D21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 487A920005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:28:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byXXsxYw;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGh9qQAToZE5wrWgcgjg72Buy8fnK2LgswQGjbfg87A=;
	b=MggyP45MpXY2jAH5/NzmRSaxjKfeQWNcMldQzKF5X9VcVONZUmmWmj+EAOtmlAG99s1QcS
	TFXjMXO9yjGNkhLSUJtg39F84XVvlszGj3DQfK0Dm+XwI5ItgIEnYdMm4Bn8n2ec/n/OSQ
	sRIANfCVbFH0KGqoOfaxhhxnwYj30Bk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byXXsxYw;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820507;
	b=71Vyf4TiDLij8CLPFh1OzzQ3uDct34C1OLFawbiUP6FJdAFoLyculla/sr4nvvFvugsYLu
	qyrzw/7FPUtYq2CwvRbPw7N2K2jukrWltQi6cu8Tk49OaHS9z1KAE+VxAOSHptWXxaDXxr
	yi+aG4QwTp3+QzARm1vYU3QWzIknybs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 625A1418AD;
	Wed,  4 Nov 2026 19:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5B61F00A02;
	Wed,  4 Nov 2026 19:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820506;
	bh=gGh9qQAToZE5wrWgcgjg72Buy8fnK2LgswQGjbfg87A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=byXXsxYwwlEEzVCdRuUNyOsLcAI+STSe55KsEGh4BJlF7vBluSLDj7xpOzM7lQKQ4
	 uvVISAxqyAtBDBpIeAqQ8oGCN092NLKfSJVGkw+BNmr8dzLnc2og/C96qttPNVfs93
	 XwoNGni8iN/tC1YXe5AYuIZI6WQoC4tduRrr4C9eyl+yKXSLVR4nkDnOPM7geCc4uC
	 ftqw04+u+hakNSgLNjIxLDcE9txZXHVKfyY+39OrDntZluhV0w61HCQ45L1DfF68Lg
	 gd5gAsNrRK9OI6wE3u0lJntjeJWYJdgnxgjqgVsDg+10MAEUapfIUfBLUOI675u60V
	 wveEeYDFgw+HA==
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
Subject: [PATCH RESEND v2 50/51] proc: don't pin a symlink's entry while readlink() copies it out
Date: Wed,  4 Nov 2026 20:28:12 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-50-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1874; i=brauner@kernel.org; h=from:subject:message-id; bh=RrDLfW/scZN49peKw6fM9m5dxManPY8dszrBpi62+JM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9buKUeD/54oKQeSXpZxZOuLHujuvOvQuDLBr9a+Q0/ fdzHMw27yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIxk+MDF0xzMdUqudtc4xq io94MDlmc+iGj38/VuQy/ygRejLx7E1Ghg97a149/ZQ8UYb1fduSSTfDdZwEJovX7fM76eJtPX3 mTFYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kdhg5mfxmig6xcgh7dg8sjbdrc91iekf
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 487A920005
X-HE-Tag: 1793820508-20478
X-HE-Meta: U2FsdGVkX1/n6xoj3bsxy3g2w1hfh5Ik5Qg6J9JLixu02h1Hx2KXHZZLYyeEG1cV5/Zi+TwtE/EWSM0Ipe4BbavhW5qMTWPbi77QukPNMYg2zExtlwgQ/rN7CAd44ayRLkLNuuAmKArv7x399H7zTJKZmmiUgjCGqY0Bpr60HEzyC/hqmjmQiY1WEmSDP+4TfX9ot/KBzSptgxOPUYoitCoL1nlsLf1me3+/gr7Yhgb6fqTqmCdw+nTmyxmBrw6tChxxfYAB4BRwpQaJ3k6NGbHdDarHuZlhkKWLkWkLBs61FW2YmvhYXfWPi6xz0DuWnnsSwS0Y+doCy0MUIuOsGiLo5huQaa1ieNaa6A11QGNThZGVrF46Ss9OFpSkx34d0Zw+axktaHivmRVNpZmupdTFUq4kjJUgq2SoyP/6/1yoYhcPuQYdzzXSIdto8dgU+nEEOEEBWFBvtLHAhRE9HGn8+zmoP+A6rkTZwSq+G3VpNityGM/t9H8vVXJ8ny4HhcZOv/imCvO563eDH6C/JpimAGevbtbbdmjoEpOvbrAkx64StXovtDCPTeWtN8RsBUpSxQEhChaNgvYBdM2f3b82Qy8a8SK/h9NNtXpiKcxqZhdE3ekBdnQcISfECqzu1fDpgEloCKjNqRiBlrtge8IJx3B6NUrC1wua7mjb4aNNJqQ3gzaFkJGO89gDfwwa3lw3IAGKavXs9M+2hcMo4q20QzIOAdeRL6iNPwDZiivqSszlhvoLc8Rbjlg+96DsADO01gp0lI1eDxAmWbbH0MRGJWLcGvO04f2oXUtl50XdJfdNKHfJrQH1pyXNMShX6tJ9VAPCLAIFRIl/PQNik+L/cDHhnV2ul/Xm5DVTzzVPsqqrepLEX8dcVX0SJHAbtImRxfU43NVwzKUe1XxqEA7+om53tkZsioSZogNGLnKPYtCZWwyLQWOcQw+Z3wQloFehcyjnurIBDqCpCEj
 1xqwMvpp
 2+nOk0Hc7nLJV8U3c/Yj/tIRhaWo116t6HPIgm59qKEi3IRyF1Wbe3vWXjUO5RTCoQwsmn/0VuNksWx7BWjnzHvtUreE1aOU3HZA+BD4dySTyG7qojUQY00uKl89FzBMtXzD7/TCkDGs1W/UiBPpeHNavZ62Uv1jwU/v0n7PutJdZUNqLcpA6fjFNQfIV9hj2u9Itdhl9Su9xi9mKwj0eGMQVE7aNAqwaCzlvgadlEyUT7AovClRvCnhmTk3aREJIs+IsShzROzUe6E3IojWKP5LVFgk1pbTpguIwPLyc16SlHX+cqZMU0Fe/aRX/NerczFCMxMAsBgc8DtY8lrrqLnfxrXOHS9MHcSpByK5JpM3mLMnpW+o6axKQyUHgKR6P4gRyqsrhRQR6LtaWfT1hG2ymZHyhKk8YALlNk2cQ3RHr+eLudQp7hL9+Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_get_link() pins the entry with use_pde() and the delayed call
unpins it. vfs_readlink() copies the link to userspace in between. So a
page fault in that copy holds up remove_proc_entry() just like the
copies of reads and writes do, and the callers hold locks while they
wait. /proc/asound/<id> is removed with snd_card_mutex and info_mutex
held when a card changes its id.

The pin doesn't keep anything alive. proc_symlink() copies the target
and pde_free() frees it with the entry, and the inode holds a reference
to the entry. What the pin does is keep a removed symlink from being
followed. So check ->in_use instead and drop the delayed call. That
also takes an atomic pair off every traversal of /proc/net and
/proc/mounts.

Fixes: 7e0e953bb0cf ("procfs: fix race between symlink removals and traversals")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/inode.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 9933f03ab9fb..2d65f3c8ec03 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -629,19 +629,19 @@ static const struct file_operations proc_iter_file_ops_compat = {
 };
 #endif
 
-static void proc_put_link(void *p)
-{
-	unuse_pde(p);
-}
-
 static const char *proc_get_link(struct dentry *dentry,
 				 struct inode *inode,
 				 struct delayed_call *done)
 {
 	struct proc_dir_entry *pde = PDE(inode);
-	if (!use_pde(pde))
+
+	/*
+	 * No pin. The link lives with the entry, which the inode holds, and a
+	 * reader could fault while vfs_readlink() copies it out. Just don't
+	 * follow a removed one.
+	 */
+	if (unlikely(atomic_read(&pde->in_use) < 0))
 		return ERR_PTR(-EINVAL);
-	set_delayed_call(done, proc_put_link, pde);
 	return pde->data;
 }
 

-- 
2.53.0


