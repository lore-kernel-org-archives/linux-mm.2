Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A65766097655
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OMLUUnxm
Received: by kanga.kvack.org (Postfix)
	id BCBAE6B05C2; Wed,  4 Nov 2026 14:31:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA28A6B05C6; Wed,  4 Nov 2026 14:31:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A921C6B05C9; Wed,  4 Nov 2026 14:31:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C63A6B05C2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:31:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A22E120803
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:31:01 +0000 (UTC)
X-FDA: 85398429522.30.77EBFDD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4671F40014
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:30:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMLUUnxm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2X249K8Gv42gMme4huYd6C+95aEaWoamySHZXVPIjo=;
	b=SR04gbeatAcZpia839KSYWjq32C6ZQXl6IDcGJH6i2EeONcWxy/yrBtd2wOECKRobP6Wcy
	1cUw9C3QV71UIw/iPCl9RfHFQV6AAeknLp6LiWT3T7tkJZf0tCuawD97w4by+tFoQASQKy
	yAyDeAhuV+OiCDDNNw5vikotFciGN7k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMLUUnxm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820659;
	b=kpJXAilgevKlryUtwMJHiXV5J7kKv/6W3gX2RM6LlB5CD/B3i5kyyVviGbYfNmz2zeyATl
	Kl0BSM4/f+lZ0LfXs5gz3dMRCPs2UUmf3ZLbsq45Qv7TMvpy/SO5oZ4eGDHwrZbvSi4A31
	k0vCj52/aSIp1yAMDscygN4/aHFfFUg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9439043B79;
	Wed,  4 Nov 2026 19:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00C11F0093A;
	Wed,  4 Nov 2026 19:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820658;
	bh=u2X249K8Gv42gMme4huYd6C+95aEaWoamySHZXVPIjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMLUUnxmfEftMfptXH6aASt5Tju/99MVIqrfpjLsj+gTwl1dsyCFLVnKp80I6LuKO
	 oV0QkRgTSnk8cZI+NetFJ+jomOknbAag3B6bMdcrBaXvZtck+/xvDa4BUJ2zie3Nl+
	 JtAthSnHxj4wqZGdExdBuvFSspoTXOWRxDVg1T0H5FlP1TmWo+WfW5NXkRdAPOD/to
	 FaY8dSSINRoeizDC8sYIFz0FPC+mWeUMnxUQ3X2aX90CpJQU6c09w6oMI8u7UP1as/
	 taIX+tu/yWMo7E9CWiCSlS8Nu91tL7Ok4VCHWyN5iv9o3t3dpMoYVw8gZLA2ml/4cB
	 AZLZ4sqr4PQ7w==
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
Subject: [PATCH RESEND v2 06/23] proc: make room for more entry flags
Date: Wed,  4 Nov 2026 20:30:44 +0100
Message-ID: <20261104-work-procfs-core-v2-6-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=723; i=brauner@kernel.org; h=from:subject:message-id; bh=mmFUc3YfLRQzskFnHhhj02Zv0+dhV+Q1flCEFZM8H8c=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bq/YE8ppefVCfjBLi91KVfu7F1mOL7llu6gh/f5jz ymR0dtYOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYi1s3I8C83q8EjxTXpWd7G o5PTjr90WyF7Xu/d+3XP7z3p5dvzaw0jw/O3O9s41xUbhTy4tslNTFiwcAZnoY5Ak3vOm7LqhTE tjAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4671F40014
X-Stat-Signature: nsp3rqa969zhihmb3g9jkzi3ca66ihoa
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793820659-239071
X-HE-Meta: U2FsdGVkX1+beU19NpaNjxfcOaMMvoSSI0xN0ZvbYLzAYuamqKwniT12mpQs6CD83PAhMk2Q3cB0KxJ1sf2hht2JzaLfZ4ob12NceF95VV6tkfZshHgw+o5Nclmc7O/wYpI18Z0BOdvfSX4P3vkbSKKunsrFokHq56YigZjL1ZqdznNrelmlXKjy3vL3I9Ofb1w4sbmtpWQ69Yc7aw+XDjOtLbrZY77LBiZfSjs9cGznNFPs3BGK8FKyxVWdVEYW+gzBrmHDlnJz6S+ErXMilSoIslyIoX9VF1cJk2fdSod2PrizfuNXBKuKJMfZMit4vaX8EQuF3xDcZKec/Equvj6AOwNAHb7Os45gAPP16DRHvBfDh71nZc+1IY+ZHa9/TiiVyuyxqZMeUFeiQCzfs3Z+k8BHbt66M0GZM4SVmPAPFJn0vqVqptUwN1MbJV0NCkyM0D4z7cgZqTRVaJgn6NikZykefT43GwWVIeNVCyitYtImjbAZ7zcxRphRbA7Yco80tTfqZEy8Ef2id9nKhp9RzKrNrSYE2IT1vn6LxfZftZq2vSlVCEtOldRHNc3TCPRX8+zHTpwK3C/Qowdy/HV0sSGWwzX7HipVqDlM3WWinz45u0YYzyPm7hgQgpz7YRMYxZJMGJiyNN3baifjbF0hidaIvTtf/NZUFmqfpC3spCZp60p+8Qyxb1MYL3irlVdsW4uXgAGAV7Kcep1PijlBSNJfKhEL1D2IykGLN+TsxGsonBiEXZlfTy0Ilz/TcZWJDmbXHgd3OXDdKs+nPQUxYt9scAOmC231O3WOHE7nwe2Jx0xYyUfFftxTyESc3ueSF5ivkRd14SEOW5c6AiqEgRkh0L9xzThO+V7Ho1l3DWhRKXw0zbFFQENbi/jgoHEL+7jM9MGbj3D3/dyclreNEKX4t0RdIh8LRdFKs95kotXMcbM4n5J0BQu71tmgJpD+Qibk2xU6bSLujFw
 qIAq6Jv9
 JAqT7ZK4lZJiRfBH/xKahF5p3Y/YRu+KzM8WBr4Dbai132yQ9ttQTov2hFEJDAShNOqLcHDqACbhIa48Z/Ben/A+GURTtDsV8jz47vpw8zwk4MP2uEzNIA2PAJ7zNXfsbWBpfdwke12s2yqMPAHIJPlWq2aoPT6XFz7sT3isrsheLr/oeMliI0PAYB0ZMoUl9Pd3Bt21V/3ngHMV1tLOck4TXWz2pEpLhndkbtiEdP52cpLnmXTjCK/M1nqBrmmCtCVv4d5bkQ3EHHfEVT4niJLkUzvkbR4Qqd2xlj/H4+Vg885I/F4LEnHLo3gq87cV+bhtH2nPrMKpwmoaQPaXfi/fXWzJN7+bPD7tdcca9V61nHqYKOrxOGHDYE9/UnCzD2EKA0weJBQDw43SUpQyt8dJhcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

->flags of struct proc_dir_entry is a u8 and the next patches need more
flags than it has room for, so make it a u16. Bit 6 stays free,
vfs-7.5.mount takes it for PROC_ENTRY_CANT_MOUNT.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 33776bc00ff0..7dea0237f08b 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -61,7 +61,7 @@ struct proc_dir_entry {
 	struct rb_node subdir_node;
 	char *name;
 	umode_t mode;
-	u8 flags;
+	u16 flags;
 	u8 namelen;
 	char inline_name[];
 } __randomize_layout;

-- 
2.53.0


