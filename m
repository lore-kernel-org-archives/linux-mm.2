Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B22F606B0E9
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ji+nEVur
Received: by kanga.kvack.org (Postfix)
	id 3219F6B05CF; Sat, 14 Nov 2026 08:07:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AAD16B05D1; Sat, 14 Nov 2026 08:07:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A286B05D2; Sat, 14 Nov 2026 08:07:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEC426B05CF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:07:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81350C03F8
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:53 +0000 (UTC)
X-FDA: 85433752026.08.05736FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BB1B740002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ji+nEVur;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661671;
	b=tiCG7rdhiOfSQxGyq7fg8XnuPtH5iZhykpoRoL+EL71cFetOIpyokwW10JW48N418r2bvS
	QkZ2Baa3uMjkBGHvJWVEDMhzVEcO0dKkCB8+IHgiFZRmVnb8LACxsl8b7EdbjSsXxPk2Zr
	AloVjdyBs5b09H12VwUf4Y05MHSyzrs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLEBqcSKp1qX1T09y3XaYhOvlZUW+haNA06sn1fKMTM=;
	b=CzhsD7HVtXSmi8AtaunnM2/3dTGad8ZnNMcDcjKiph4ghQ0T1O+Jd1WdQcD4kMik84Tchs
	1MsYNmEgb4AOuu0JB0P8swW25k7bUaaY10UozZlk1+/uZGOkRPFn9MvN1qkrBJcge16ft9
	uSZKtP7vt7jeYlsan2XiePLuRD0gThI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ji+nEVur;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 219C04329D;
	Sat, 14 Nov 2026 13:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377B01F000CA;
	Sat, 14 Nov 2026 13:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661671;
	bh=HLEBqcSKp1qX1T09y3XaYhOvlZUW+haNA06sn1fKMTM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ji+nEVurWmAWGlYK/nkfcItaW59n2bZXGZcxHBK4OdfGaK8u3mxnvdkxxHgDIydSr
	 p/UqYko0xoSz4+2DnS47tPHRl2jWXh7tXIePEIQLB3C3jGbWQ9Au7YS1vvY5l7fUr5
	 ph8m8OZcq0Am7xu1jp3h10AkrRPVtHIVmgjmJ4PmRoVOvpEKw36sGP9bQXZx0UwMKH
	 HxikLBXNjHLBDBGgc6E13ZKeQwUfqBkSNN+kiTaJ4yJMSSYs09p0VgPuGTW3tcdwiR
	 GA0Rcmh4JRimAm3px4/WK7WlefYTOW4KsqGKwhhMFZ1acn+6sH08twTlVYAZESB1es
	 3OH10sFCA79yg==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:00 +0100
Subject: [PATCH RFC v2 19/42] smack: use fc_init_pseudo() for smackfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-19-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Casey Schaufler <casey@schaufler-ca.com>, 
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1015; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mE4jYSsHEwuAZf3nmG7Zw4WEpYRZ8AUzYrhlfcWNpTk=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGr4XHvIqDUMQ3Y3FWiJAOR/6/2bqf9F3aGnkKR/Ws7txmnIJ
 oh1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmr4XHsACgkQkcYbwGV43KJGMAD9GRGB
 jgYj+fXNJRfyU9Ary0JbYVPSrhncPXZR9kWxX5sBAJyDlhh8buWDux0CUa6zjYdeue58XdJanKh
 tYMsz8+gL
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: BB1B740002
X-Rspamd-Server: rspam12
X-Stat-Signature: y9ctrgu1mynzox46zoytn1iojx6ryzyg
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661671-156401
X-HE-Meta: U2FsdGVkX1/c9XsEONJ1wnqVZJ23R5lq0o7b+vzGtYXn2tcVM5ZxKXklvUimQN/uIi1N1V+Tr3d7KmEEiia0rlgK5yuTPVUYrzRvzcwxay+6QtcUs7uIRIAEl+McjYLLtxzT1wc5KRspXMZ8Khfp96ZuWtZ7QhG1s3uqYKDNFYPUPi9GjLoFTNf5o1HFaLeZ1z12VEVD7MF9Tq55fHEKl6lqDI+sv4f7s6GucPSeGYi5oUfIipwkm/wdJe7UW/NA9fk59JWJuDwldL12o/3rHFSJZywekeUoyE8+htPKFIoZKCUHk/ltRpnAXPL1wv+l1Hz32m+MnwXUv82KR/gTnCnDG0qjvNgvUgTZ8fL4uBoB7VMkYWlWoEvMpZAcNuLIJaNibJG2u4eUZ/ktAUu82L0CyDievWc3/RpnvHQOYddKJNqSczRn+FjS7u0dpKXqdhJZENwGZt4TghcGIxN4cb95hpbaHFTP8+Xa9L9N4sQ9bkj7obP04GyQErdukVksLIhB14D/DNdKsGcACEKFxNm/TSr5xhy1vBza4qQ4EeS+ozBJz/KomBpeP4dV5uHLSiAcBkkr8jZYp5OmCtPFeuZatdgN6cM7YiwKQ3uMYPn5M3uTzAjexFnMLdrOijTzK8GtX5OhisVl0e9vM2S9ciyfHpwmI9xyRP8QHjTbHfPhzuB9ZIbdbrTvf2TTEfwf11gpI/G1WCZTftKDvSG3X1BsDYI4G478d6cuZvcrf5DxpO+bwJriUg5eoG9Q6pXifPtMxyVFRMdoTUiCgkuWZR5N4ijFKBYhYw7xTfbsHyP1woNJIHd0zy9K3Hn4HgHeFs4SGXzWO7oH/9Ry/x1RXU1+DlVt1mHSpI53H1MVBcmL4hMkZwXIYJmV+8/+oRGv9nBOgZ1kx1WdmOsieIN9YXpHiqvtpxkG1wAuD5an/jrbSrAdXGylAYb6AoL7H2wtGKKTTiNDA/JahJO+XJj
 y3Q6LdOC
 5NKFNIudvoW5VwKxFCHQyKDTFITl4q38AhKXbAB2xhV0xio40OM01Eg67g8WuOCXZVBA2DLIbNLcFa+5nTP5iUlMR/aQDnREYnnqRdfSwcFwaV1Th6OAm9uL/WNH/DAJ9E20KZUJMBSBRQKP1zJYPrnGmkvcXz/4Zk04BUhkuF33DrmU5oSUipbl+VQtkTkC3NKGhlAyODDMwoTqcz9cn9lV8FwRo4j7vMuJ/JkiI55Iz53lH0vkx5tXfbf6I9ISpCNII8ydF6HKSk+9fo3tJWxk6LuFaA7IvdL7LFH5Vqu5VwXx9AJJTYI1m7paWTaoA4Ydy5vjl837fFfzPa+98T4XeI+qpR/eSBiQ8tJXFPt2uduA3a/f/oaMTtKIJQXwz/KWgiXCX67+8FyIuqr62S766ZQAzCO6DjOZXFfwuvGijt6vBuSAN+HPHngfCk/Ni3ZHmYHHYx5Q5zJyiYNbXhQZxpN7S5Vz+1AcpyTbixpF9K43t9IUsFMfx3KuJ4Qa6eXZ+0oVX0ESsP0fCxj/evpbTD1LJolusGp7oRKPhNgFNCrXos5EZWMFbyE7nmO3tJ874Nz4w1iYbCNaj+xAN89a5DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize smackfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. smackfs never holds executables or
device nodes.

Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/smack/smackfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index a72bc7fabea99..4a56bbeaeca37 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -25,6 +25,7 @@
 #include <linux/magic.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include "smack.h"
 
 #define BEBITS	(sizeof(__be32) * 8)
@@ -2880,6 +2881,7 @@ static const struct fs_context_operations smk_context_ops = {
  */
 static int smk_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &smk_context_ops;
 	return 0;
 }

-- 
2.53.0


