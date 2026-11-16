Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36038606BE09
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MAOQF/Rj
Received: by kanga.kvack.org (Postfix)
	id 416956B05F4; Mon, 16 Nov 2026 06:08:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C65A6B05F5; Mon, 16 Nov 2026 06:08:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5136B05F6; Mon, 16 Nov 2026 06:08:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F30936B05F4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:08:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 883511608C3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:30 +0000 (UTC)
X-FDA: 85440708780.17.D3E1A8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BE0142000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MAOQF/Rj";
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827308;
	b=iOFNphoxropEH7MCWIDbdoEzgA4/MCauaguv7luCH6BdTgLYSYPkrukJrJRsNffwLeBgEj
	3geaxAQqW/yCqnVYKOcnWByZBeedm9Wiu/TFCRBzy5xi7V/Ya5iwMONXOtgSl8XEk/dtcs
	/3OQO72jdmff/UPk99wZR7ChVpG3pKo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MAOQF/Rj";
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Wy+scJ41Y8KmYhleRQezskd7+v4uNRBlIFkKwTMVMA=;
	b=nDo8/3ZZzKAg9FMr39MXbNe1xjjldB0adblU5xdOa5RQrP+jnIrsNSypCWz9ZeCchmRrOZ
	x+TaSAmu0wFSAqmpLeBvl8+xNfZvyYgriTDDbH1rEOzMcGcEWp2LpuOGMPxquTNb4LvPOi
	iVP+XllYcAb7MCOsLMiNI+yogoMdDQQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A2D2401FA;
	Mon, 16 Nov 2026 11:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA281F000C9;
	Mon, 16 Nov 2026 11:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827308;
	bh=2Wy+scJ41Y8KmYhleRQezskd7+v4uNRBlIFkKwTMVMA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MAOQF/Rj2EJww59dNiCxumtdpBg6TrUeioHJXL/bnUNEdpUa+TL9z32jyWcX7tf9f
	 YJlPw0lXLJuN+5nu7TRB/0yUYsrayfVUWBWRn7Xag0vLZsz5NbrTs5CwrGSRxbSogs
	 P/9NyJE2TSHUN6IYMouHl5EjNy6A8TIlTWZwYwJV2xPuUnoIigJD+H7vGh9TSZyMxj
	 4DkMGGlnmERtn/y0Q7vC3yziK9l/XelDpyyOK6XcWMfJfoaMe2RgysYQszYJSpfAbK
	 at3Nt4liC7nM7DMOWTOI39ukPd66Pb8dTLPpdP5tvFSKmeh82o41oMaYOJ0Z8Ld/8g
	 6mMsCjtcCJIUw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:52 +0100
Subject: [PATCH RFC v3 19/44] smack: use fc_init_pseudo() for smackfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-19-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1063; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mH75LpQDT6Rg7eXmytbmjrMu8Ad5NprhLDuRN3w7u4E=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elyyYcaRBJX9njuq/Xs+e0qULvo+Ofy7yZPN3Mk2k
 V/3Pt74sqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAix84x/C+c8DbZ9snBwuZV
 Ot+mNXG6qCX6nmf9lubn7/zkwaWjM1gYGfavmm/06upB/mOHiw4kL0t/3hrNdDv19L7DDxzblqU
 v384EAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BE0142000B
X-Stat-Signature: o9i7158ikfzjtkf6uwj9y1ewc14p1b8j
X-Rspam-User: 
X-HE-Tag: 1794827308-638485
X-HE-Meta: U2FsdGVkX1+M/Yeo9yx6LZlRVa0J3aEHWdEyPdWHsV6f2oOK7sG4yhIyXXnPzqlHMghEnJhB9ZaLvtAg1JXDIn8vRe7PbXqXDGsVF79iC8iGPlRgD0MotHcsiR+Guxo1qdrXHwaVdbs2YXImQ9avgts1gkUCwEsoyBLNQNfmgG3P1KNNInte0CeUhtHjKJN/3eyzR5L/oX4mZ4qrDPsTjsOXpI0vcw3FpKX00yznXc7Da99ixHDxxFiX4oOgDfajZo3sY3JmGTahIScznP0U8i/cpW39XP8EHTeqecm6Z+3PwUdhDjaOZdQaMaQNebj1qd+/U+ajoStSXADCAhOj98ba+e/0nM1UqPZ8fx6Z/KC/mwDouw7NEy9ZqgU5wFnzeq36VF3gZHOvyqXr9dsa0ch9gx2BTffIhTsvnTPJrnUXx0dnhK2M5SlgYGSmQHl9NTI6eXy37sCHvnv0nK/a1lK/cesrZnM1v2lF6HqpgfX8Ox4dIisxzaP8RLNY9ChXKfpbveSzQzN72nIQNUCrEDZ4ViGxuXDV+T6+yt+bpYvZg+qH9ndFlxS0l29DMDyiJchhoIRIXh63z00QHefM9RiNxG/L5k428ypKOJOKICfeRBpXwiUsiEj8qoWsrh4L4J5VChf0KV8UGM24YPcLTA/VHUSM+O8AfJal0/c+FSgXKIir8YmrKLOFNVaOiviBbtRjbiCvjoXGrslOEOTLAyLQpcv8cxRGBzfSXlZ2I9agX3GcdTxNcYxfYlCe/qHt3Dct4GWK+ESLnRf4oZxc4puDWnSmwN6u4yjd4+AbQ/dpEczDpUBfhhnhYZ1sEpIAuBnyOyGVjOTro131ag/EwRYXr+9kgwtzYh8pWBE86hPk9cOAaaOB0HLkmhkURWw+8DBwWdV8TSKAgNuaTgPP78V0FMiDdJwAtg8qlDre8Rq8FJipQueYbLvh4Lb/8bEUo0IG6XS51j4Gms/b8rk
 QH5QkM3F
 eEtWesO2lrfOIdzryUdzHNTaUGEU10YuK/jrGDm0YJsMJoYhUuVYiJEVXamk8D0J5yOEgA9sYdzJ8WbBWnFrcBBfJAm6oK61P7QLWlrSZKJ8Qk8eyy2YXbGhpdhYpaOnkRAUVxBzkESE6YudFVw1R37zATpXi21SqMu+FaHYRHheWciL+m4vHTCoSj2TYXDqcD0EKMTPI616X1MxqeXluHVLYYt3etqHLdrjvpXAzYEs/TbSJqFfqvHzvwNYSs79eFeKzPh1SUKkb4ZipbTm7wawHJ7uUOU5x7t0p0DrQJV2ZEKk4+2n2vXfpN9OPjzeQk5JaEQlttRliFR83qGRStxh/KoKf6AnIl+B1G+kNZNVRNn41hwIr6EVDoJ5LTc8u1y6m+mRygJsXszz/Ro04zWOzw56UvpJwgKx9
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
Reviewed-by: Chris Down <chris@chrisdown.name>
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


