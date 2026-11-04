Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72B7A606BA1E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QAJQ3+WL
Received: by kanga.kvack.org (Postfix)
	id 934266B05CC; Wed,  4 Nov 2026 14:51:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C176B05CD; Wed,  4 Nov 2026 14:51:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8212E6B05CE; Wed,  4 Nov 2026 14:51:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62FEA6B05CC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:51:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FA178084E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:51:53 +0000 (UTC)
X-FDA: 85398482106.22.65819DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 49DC74000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:51:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QAJQ3+WL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzw2p1lwQVTXGjOVK+O2fRllw6EWFGiyVpP4wwnyOh0=;
	b=PTpUxw3W4r3nbAwIjRV43SdvrO2PAOAOUil7WUKQJz3SQQbqmZRGMVa4aUFJ3zsR9+Ji15
	tx6+6YEEyBCKvmIww6JfpFZGYsA5vrjUUxnhnBoG7KiB1zRf2AUDy3EUyN7P+cHDKqOkN9
	KjwjkpRcyFeBlT2NWxMFk5lizb0Wd0A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QAJQ3+WL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821911;
	b=u6Tj918pACdqOKRUI46wO4L+OSnohTNZEjOjdQ+Apb4zmLtFeAD5yVxLLfXI9N6/hI3GYs
	sii0Yy4F7t6aV6fli9+7QlOT6R75aG7MwVMs6leIAG9JNAVbU0PgpyA7+X/+lwXxZTBTA8
	0j/PRYvVQ49rsw6LYFIsSIF629pu2RA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84484417A1;
	Wed,  4 Nov 2026 19:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515511F0093A;
	Wed,  4 Nov 2026 19:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821910;
	bh=lzw2p1lwQVTXGjOVK+O2fRllw6EWFGiyVpP4wwnyOh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAJQ3+WLDUkYLImp3HYyJ9xNQzT5ktofk3vTOb5CY1yyjGgMiMLV84eXcv7Ngn9pO
	 0R1aIfFok0raVnzXU9Vxsqv/+8svHg8UrA6VN+qDutbG0MoaDiCzmWdmWTuVYeXa/I
	 N2GChnCG6weK3daO3o2GHaFO3/dOVqhIMLzDjlCpOjj7c7+2YrdYYhUy9NCshP6wdl
	 Lk+TkGZGwLWFEFiLx/wufa/ZxQYuvNY4PHonWIRM9HX3gymQ16OIyPKKYKRaJNOE5j
	 ooOiwYlFZWYxO07ewx8hUYCero4307WQRVTKLVnFylG/X2Vx0yOkMhn63aRL8xUxMW
	 sonQvq7YDKhvw==
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
Subject: [PATCH RESEND v2 08/30] smb: client: let procfs own the seq_file of the smbdirect files
Date: Wed,  4 Nov 2026 20:51:35 +0100
Message-ID: <20261104-work-procfs-fs-v2-8-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1034; i=brauner@kernel.org; h=from:subject:message-id; bh=RIZYcDqYt7NhFvt2L4C6pTMn3DylkXBLCyRwuGHjm7I=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97jG5tPWrw/cVrCsb765In/OBvcn09R7LsHQ9/q6+O V1HHE9ndpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkz01Ghl3rSlga96Rmhvie 3JVu2vHMZ1KgvNQ2f7ZfM06avi3c5s3wv8ZDfv2t3meZR3nKlGZN/Jj7Lukpr3r48QVnD/23mvz tIT8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 49DC74000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: ryzozdzug5rgyg4xh5soukj53nqtnhf1
X-HE-Tag: 1793821911-149562
X-HE-Meta: U2FsdGVkX19S0aSKyekDeZHcQvZNg0FA+ZuEz/k0KvgEqlXPIoimuVeOiVgEiSTQdi0Iru4Ej5qNlhZsvTcUKN3hJwA6gUlr89G6Pz03wz4bMgi0CgN+GIzgPcxh6icjTWGDwVEt979xTFfT63tcaMHU+lumRJTPcY4xC2lkiczKcytCo3GgCoOuaUXQw7zwlN3mkSmL1UiF2MfFyoijdvQjxxOt7r4QhmrRdOLNRBeUnQqmfWpks7wohxB0y/LaH193VDQqH5u0GHaPnM/mF9/pX0XhMZbDTMoBVVd9O4xpOf+9D0UQqWWHyJCbG5p/7q0c5Z8mGcoou3wVMGx46RKkTojlLCFZLgLJK3aAqW846R6ODfZAN2p7lFNOLuUX/+NFn4Uek32MHrsehJsA0a5/oeaxJabJtPU811p9KPSempdw4kuEPpaIfIU7woePWV9Ndh4ABF5+JukgNvCKtdb+1wP4TV15tZJ6DTEKy/tO79VG+tIetVff/NGYJTZ2f1X5Wzl84BA0r5ijcPURlAOOG5hbzt9CZK0NTFsLx5zkyEjbVOfFGDtKW1H7+ptc/Vzolb4T1j3tNFKL7SBlLd6+R1MtuGowzHIUnAJYn5fCJsgJ7seG59FCjwmzeVUfF3LF1K6T9e0RsEP6OqCZ5LfNezfNr380XWi3gIKovqIE8ithSi2Xh/RKOfy71fXQ93vBTXbhGwAmITqeAuSybQG8YRZVC6cqHZk0koVvfytuxHtJRjjPs8VB3KcSX1x92jr7W7OwsiTS8ahqldGZDnNXQnwoMvFJQUR/ZwhtN8ly9S6lY7IuC3B18Ma3HShm4UDCqIbBzRyMnRq/2xGQLYDDKPF860X9wO/trQYLwKdLTwpei+6/vO0E2tSYBHscQ/4e2+YDVrTaB9H11wRp/BApgKgSBCrSyYl22pMXVej4GU+eVAUpX00QB0KpcoB7okAjjF/kD5Td14T2sa5
 77zMzPpb
 KMZRNTTZiyh06hYRoO0a1jrbqtDJhPhNLPPnpxwMIwKeklQzZ0NowDzhkcpJHK9B0ZfmKbr1QEpFqlAzXn3OMnpr+ITomQtMa0LP/zDAm0E5RPvrPX6mFfmZ6Hb2CUBKdH5yt1P2yAbYvwItbae1W8gG/Lgw+sl8aqX/SfMQPZwh5QjAWOwEtmGwbrOODftKxvkTvd4TaPgaPaXnWg6VRcJWRAs3FE1cK3+tB8G8fIz4c9gvCsiXSxHJHLFv+VHkbPNEaor0NdIlylILPmG6lXpSFGEgl9oByRLXNWzoraAeRrCdXl2Xuwv+kFOg3ovww0iCAiR3vdA47KJBVPKb7gP7LidPT/4tR7zB+Nf+q2ls/fCmlxu0xaIhzrB9rcyZ1rNlErNIR6a0f8RNv30wUXZTB2tg4443czWrz7DYVFA6QqBgsaVs7jt0j9fCXDTXA7UumFiudJ/sxzwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Declare the show function in PROC_FILE_DEFINE() and let procfs open and
free the seq_file. That makes the open functions unnecessary.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/smb/client/cifs_debug.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index dfcd2cdbb2a8..664072ab3342 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -873,16 +873,9 @@ static int name##_proc_show(struct seq_file *m, void *v) \
 	seq_printf(m, "%d\n", name); \
 	return 0; \
 } \
-static int name##_open(struct inode *inode, struct file *file) \
-{ \
-	return single_open(file, name##_proc_show, NULL); \
-} \
 \
 static const struct proc_ops cifs_##name##_proc_fops = { \
-	.proc_open	= name##_open, \
-	.proc_read	= seq_read, \
-	.proc_lseek	= seq_lseek, \
-	.proc_release	= single_release, \
+	.proc_show	= name##_proc_show, \
 	.proc_write	= name##_write, \
 }
 

-- 
2.53.0


