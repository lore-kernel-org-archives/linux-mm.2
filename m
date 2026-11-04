Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 379E8607CCA1
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g53FbUkZ
Received: by kanga.kvack.org (Postfix)
	id 5E2956B05B1; Wed,  4 Nov 2026 14:36:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592B46B05B2; Wed,  4 Nov 2026 14:36:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433976B05B7; Wed,  4 Nov 2026 14:36:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2553D6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:36:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD4B4A7EBC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:36:23 +0000 (UTC)
X-FDA: 85398443046.01.3A14CC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0BF9040003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:36:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g53FbUkZ;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVgyj+FYQ9g7uHqmkN/6kOivRqdCDmjAyQM7m79vY9A=;
	b=QUkxq1iXaDHBfVolZymp787FHr07SQXDxQPzq0NM3Ku4huw+kyIzI7a74u2bLEWSAkE/l6
	T+FC3X8rUmwO2O2KhT6MCmtZONFzPpUKQYbMyhAve7JZRADvKVO88FQZmseiZQDDREMnpM
	eBa5FOkvd7Mzff8nMmX0jc2H3QkeLGQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820982;
	b=Z3po9nj8BpeexfCRbdi246YjMCFoDQMUWuJ2d9Us1/471r/0wwmBHjQ/jIzmEMSW+zXd0l
	7a9k0Gm2lz5E5Npg+PZTGxZrLqBtdpiCnzS+mtehcSBPwPtm5AsoCdhvJndBEZUOZlpZsS
	9I5iy8cDZgX/7n5wHf7pIb0C/SriY7o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g53FbUkZ;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58AFE4307F;
	Wed,  4 Nov 2026 19:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3312C1F00A17;
	Wed,  4 Nov 2026 19:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820981;
	bh=qVgyj+FYQ9g7uHqmkN/6kOivRqdCDmjAyQM7m79vY9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g53FbUkZCSWNwnfejXhy6s2nelprEnvO5Q4YohPFBJHS+h/+Bis4YhN2/N/AQPc6j
	 fzYwibXDmXurtiMkWQn5u+VqbndlNGJtHCg2mWpnoK5k3yXNh3AEwdUXjS/Wn8YgAp
	 DsbkdUjLTcZjtiVPGmJw8p0/O2ZWUM6qG/u1JQ1LS7FQsul73LZQiypnKRi3hmBJNn
	 pWa+EONoOhGPwjSkAXUgj9sc5Wf8Ushz0fe45yGX+M0rWNNO/OogEaHlzCPeH+AsK7
	 UOZddBvu39FXQ3nOy8HZZvj2XFYHPYSGv2QlAmtdpAP6TIhnKozmF8NTYKArJ9/gig
	 pdBxHcmOh0+mA==
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
Subject: [PATCH RESEND v2 02/23] ARM: alignment: let procfs copy in writes
Date: Wed,  4 Nov 2026 20:36:07 +0100
Message-ID: <20261104-work-procfs-arch-v2-2-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1378; i=brauner@kernel.org; h=from:subject:message-id; bh=zhi1nqFEpiSFVRrnQoKgWCc9KudbEGTZB0sdbQtmzK0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97njXfbbxoNI5d7tgS3+dmRcrGv6d2Z0Tv6xkukLGh 2eO1xfe6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiITgLDX+mF5S+vT7n7/+IW 5t66y78vbZh5fg+zoqqy103BXpsgljCGf/rni1NaxQ39Co13b8868UXRoW/v43tTZjz4Lhnc/Iu pmREA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: fjqnfe7cp5q18xsmsjdrt7s1d5efws3t
X-Rspamd-Queue-Id: 0BF9040003
X-Rspam-User: 
X-HE-Tag: 1793820981-406437
X-HE-Meta: U2FsdGVkX1+6dshmse8B/mPUjBmZnEU58w+olkwS8TslZmzmaSvbFUVCYzSZjHkl67TkxpV61c+ytgRbIaK5Wi3P+/kgcZq8nHpJjZ3B1uZrqr8JZ2U91dL+PZfMfnOmqvGDS1ti3kI4bUToCpYX1lyJAyYnaz2QnRw4gTU2ceo3nVMwpPBGZKIREOiJGR+t3UT9eC+eifH9S1DtePUBPw7/qhkF60CEzhMaZh7lEmZzqoTu7UbQ4pL8dgj60oQBogIou82rZfI8x35UxRww+PSbgbEHxcg/NF2Jvx7FpMJcwxaS9OcOiPAZD5p6BGMsLBpiS42IDtANgvWdEUluJu+phSs/pRDFkjLIr3jHbMxQL/gNx2gPoIlIvFOzp7eH+zJdyYpF+0cR+ZFCx9n488aWRHbkSvzXBa8gjPDl3/6NT01dUZrV62Jt5SERJHMa7pfOky7bvGB58vLr1JNzMZBVKbfAbWWSe7ACS6FjAp6jW0ANKbK4VPSzJCjnScPOEbnWFtpz/t2Tq96VKuMkPyXnK4nqS4T2Bl8OFlgxAHpoM0m4GG1v1OW1Xo/eQY46n4NVSP/X1NXl+kllhQJ1b5+h3Ei8kZ1R/ZIqarg5XMFJyQrDsq/Cnzh1TgBDNLIrucvGxR++C1GOWfxHZZij872V9TZh2kogk0orlvEgyv5WiIt3ogJ2L6PhLW3ZY8JUB/SBLSjwpOCO+nIM6wuI5t92JHcwIkUUwI5NKymUnHqI7RaC+8EyZ6EYmgEDoZnTX9vnrBy9ONXmhlcC5MG9FRLW8zVzFu1cftE3TzWHWnLSq9ApnW4+wIc0gOmlYoVu37ekL8PTTIqLtS31NmGRbioHvbrd9jNNzICwFs+qp2X8AY92ogHmPhFc67fn6drVs4r7ZoiwUa1XyY1R0vaWzMhFsqARILGWgUP/00mce1HSbZ2yk//Bhc4IJG+xI555D++zjjQ8YPOLFuV0SQp
 UveusKA9
 uRs0vVSFXFEK2wYPsciMoLhJey+KayRGaAgIbR7J9KyfbKsCg5NpgQbu3OSKp28gZ9TbaFgH2nR8HXKTbziQ1hSn37yA/rsGj9DFaVOuUoVQlF1PYctLaSvf9pHydoAS0jShzQIVhg69eGESlSEXuMZsJEJCDR/bFijQbZmwiC86ci8Gs3gcgV9F8X5hb8DPt2UiEMoNAd/PzulZTcD5Uf+hoQrkLiEGx69MHxhcL06IjP98SeAigkTu20QKlK4FTu/bGf39I8mdfXpCJdi4eBoDmDH9hsfQBm1vOfYsHK4E5o7h6Gr1IlE7i4Pq80lG/Q8sM6xy+En0hJkbhYccoKDD8+YYCezl8hvTIUmD2jrpbis2/AqjbySq1q9QmlfD2nyDOTVzhZK0XvarEkcaN2wI41A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written to
/proc/cpu/alignment before it pins the entry, and take the mode from
that copy. Writes larger than PAGE_SIZE - 1 bytes fail with -EINVAL now.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/arm/mm/alignment.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 3e5e30968634..11ceefdfa388 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -144,14 +144,13 @@ static int alignment_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t alignment_proc_write(struct file *file, const char __user *buffer,
+static ssize_t alignment_proc_write(struct file *file, char *buffer,
 				    size_t count, loff_t *pos)
 {
 	char mode;
 
 	if (count > 0) {
-		if (get_user(mode, buffer))
-			return -EFAULT;
+		mode = buffer[0];
 		if (mode >= '0' && mode <= '5')
 			ai_usermode = safe_usermode(mode - '0', true);
 	}
@@ -160,7 +159,7 @@ static ssize_t alignment_proc_write(struct file *file, const char __user *buffer
 
 static const struct proc_ops alignment_proc_ops = {
 	.proc_show	= alignment_proc_show,
-	.proc_write	= alignment_proc_write,
+	.proc_write_buf	= alignment_proc_write,
 };
 #endif /* CONFIG_PROC_FS */
 

-- 
2.53.0


