Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E721F606AC02
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WrIOm0L/
Received: by kanga.kvack.org (Postfix)
	id 18FDD6B05E4; Wed,  4 Nov 2026 14:50:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168DA6B05E9; Wed,  4 Nov 2026 14:50:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0577C6B05F4; Wed,  4 Nov 2026 14:50:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBE8E6B05E4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:50:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F082C085B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:50:38 +0000 (UTC)
X-FDA: 85398478956.20.BC2D94A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id ADE93140003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:50:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WrIOm0L/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mLB2lug1OKcpaTlobTkzaZ+4AMl2gIULemZI4iRmrDM=;
	b=TOAvvJZDoU0uG47AqG+lyn0HCRampsE2t05IZc+PlgG/6ITmRhc4Ze1M//Ylab0ArNwxU8
	pYbmgnxSFaau6NVpXDxGPYXe6/j5GtUflHAEJu2zJXpIUtzKKtsp30oudXAxh70B+/H2bZ
	OPqI75jlpSjctwNVdh9C6ZH5v6dtRk4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WrIOm0L/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821836;
	b=ykFU+STb672XGPAC0vPQzfE6wPwvZ/SbYu6u4QscD4MLqzznVT1TyCYhaytp3uHLel/tDl
	2Xt8TPtJkLqwm0SLRd3RAEtI3HWD67Kjq572NiledoWmbdiSsCmNMaygdJzDjxJM4x53UR
	rywqOSBlTG+8R+fJ9avnaz09MNklt8Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC01340A9A;
	Wed,  4 Nov 2026 19:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A587C1F000C1;
	Wed,  4 Nov 2026 19:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821835;
	bh=mLB2lug1OKcpaTlobTkzaZ+4AMl2gIULemZI4iRmrDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WrIOm0L/grPWsfSZ6ocvkczbqe5CDNutaK+lDTDGBJkYNfb+vQmtT5HzyIbXGVqHH
	 hWnfF+S7ghDcf3jndcQSye5gCwb9X8DYtZdri/cLH978S1GzMeTX/+4g/zFpOiqiNK
	 nGuFtvQNq7yvniXZ/lBAZLMxXQj5TNH6p305lsSnFn9BJUumbxC//DQvRndQEXtUIa
	 VsDikB9RkzCyzs7pmF52v+oL+Q+io92cATYHoyvEmPEV6i1rQ6jpin6iZ1aKk7/AxO
	 XxSIj8Dyg+41tnOPmTEYgnhNZHK5o6ae9seSm1c3a/IOfHTAzonXKhXGQctCWgRh8w
	 JPeajEykQHbCQ==
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
Subject: [PATCH RESEND v2 03/30] lockd: let procfs copy in writes to nlm_end_grace
Date: Wed,  4 Nov 2026 20:50:21 +0100
Message-ID: <20261104-work-procfs-fs-v2-3-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1796; i=brauner@kernel.org; h=from:subject:message-id; bh=QwlEC6TnrlqFxD7H1NEPhBXC4WfFu5kv5jak1b43Ypw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97tG7Wbqw7qWfktj9CUmzLuQuTBZfWKLcsbIl+K3pw z0MHG/ZO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbiI8DwP2PPpKWpiYbxYn23 5wT0zN8bdozx+0+hGoFdAkmmD+0WvmZkOLRmopvW3kn6Pu/cks9Okva45eWqIVawWoo1YVdnzJR JbAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ADE93140003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: udkhpi6kod4y7tpkyf68pzwxm9t13o3a
X-HE-Tag: 1793821836-884864
X-HE-Meta: U2FsdGVkX18EXOFapk6sDMZYrOKpbn9q3VZTX+qDIJ73ucqioW0tj7tP9qe4j08FeudmTm575AYsscNpLwRJUYp3niw59+p5QvKQH5pQQcCP2RtPQ6p1S/W0crQIJIx5AGZb59wjui9vwXtmwBWeEuh9dkwSv4ToJqnx68YG8PZOToAuZT/Vpv82TLRictl0vlyjmyFsdyfgrTn6v7MXW2/L4m27cqhZVKhSlGrJU4Zew1jneFvmgc6v8MMYASKQp3gXl3sjuQFhSTE7MuoaxSxM3jcGzoXlt8JKNrrlHoIbw7F5h3Vs5fQRwJO+7IBZmlnOjaVDQPet9btsVd9LWEMLMqjI5V7HLeA6oOvtY+K5YCiRxLPe5fnBLijURgw8v13CZXxP/PJwvES87tVAopK2lLTm3zkSDZVfmzEMsFFRn0Y/WS3sCBQD4wl05gFUXFZEz6uXREhesX4rSWR0Wbu0Ne1t87muVHa1NyGnQuPOQU0AXc8pEo+99bV0GaomXp1eT0u/wma2iBMJW5/xlfWNwgFsgWpHV59m6Fr1c+DUHQnOW7Eqy7yvLiL5xL6eEZyi6MDSRfZ2TIwktFww9X2NlpWSu0LmSFsnpCDYoroh4NiFgl8Qj/cC6SElWsV+J/f2kGSsNZqbGJtJhUuMQhNhckr0pgnieWBUbtQ430Us944tplUgUeT+rw65J9zUqkLMP/o3uTTfqa74dohy1MJfSj9d/2nYLtcz/NrjEz0mXk6n0Lo+Uf9vOGR6NEZr++xeyIj7XLN6+iR5GlZRJplyo7QlYJhJo80ULqrNoVpEIc4r7pCosV9UKpc4SL09e1hQcwvTtWZqXQ/Q7K4aAbRvQjGEVGl6d5uidQDWnEyVk/ObHFWBF3pNp8JlzBQt25pju01tojXEeTRG/RfQQxVYK50fTSfbYit17jEsPqrNfaslmYo6pQjILK1MK8eGFZQzreHnzCv/ftQuh1b
 RqPvP6xg
 tzcluBfcr9aEkzd6GrDof6WTTAGlKLx9sw54QrCty2bFpOJLzloj2PaHiRJ9xbYs+P9IPuP6D2T3+0f1wwDvLdS/DaG1L5qmR8OxqKmh/zzh66Vy5N5WFoYPn5JE9ZMKUnFs5S+1h1nEpQRdS8NtVLpWCJ50f00eDp9oLxW6rfpHh6pF/ciJ+SioduYtMvi4f0n1dZMTE6rKXkRMDilUPiAMfTbP09MlD77Qf5XVMw+3pv86e587RlD3ce4ZL4FRwNBvNxSkyvwlYOd5MfnQl7/nKVJSg2UrbETlIZICdVKsy/Gr41vcHqhB7mXG+Zkq6njZKFavf+wAV1bUx+ERtA35xTDyuLBylZi7SPnt1QUEBNPCcPrmvnqT7bemakS5Ua0SK1zz+MY1v9ZWW6lGn8b2ilYJBAEfHjX4ctrhypcZaPWugW7GZjG1LZrsXgoGe1ETZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement ->proc_write_buf() so procfs copies in what is written before
it pins the entry. simple_transaction_get() was only used to get a copy
of what was written, so look at procfs' copy instead and drop the
transaction. A second write to the same file doesn't fail with -EBUSY
anymore. Writes larger than PAGE_SIZE - 1 bytes fail with -EINVAL from
procfs instead of -EFBIG from simple_transaction_get(), which refused a
few bytes less.

Acked-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/lockd/procfs.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/lockd/procfs.c b/fs/lockd/procfs.c
index 74f7ab77535a..852cca8c3588 100644
--- a/fs/lockd/procfs.c
+++ b/fs/lockd/procfs.c
@@ -18,21 +18,15 @@
  * We only allow strings that start with 'Y', 'y', or '1'.
  */
 static ssize_t
-nlm_end_grace_write(struct file *file, const char __user *buf, size_t size,
-		    loff_t *pos)
+nlm_end_grace_write(struct file *file, char *buf, size_t size, loff_t *pos)
 {
-	char *data;
 	struct lockd_net *ln = net_generic(current->nsproxy->net_ns,
 					   lockd_net_id);
 
 	if (size < 1)
 		return -EINVAL;
 
-	data = simple_transaction_get(file, buf, size);
-	if (IS_ERR(data))
-		return PTR_ERR(data);
-
-	switch(data[0]) {
+	switch(buf[0]) {
 	case 'Y':
 	case 'y':
 	case '1':
@@ -61,10 +55,9 @@ nlm_end_grace_read(struct file *file, char __user *buf, size_t size,
 }
 
 static const struct proc_ops lockd_end_grace_proc_ops = {
-	.proc_write	= nlm_end_grace_write,
+	.proc_write_buf	= nlm_end_grace_write,
 	.proc_read	= nlm_end_grace_read,
 	.proc_lseek	= default_llseek,
-	.proc_release	= simple_transaction_release,
 };
 
 int __init

-- 
2.53.0


