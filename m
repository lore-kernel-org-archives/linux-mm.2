Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B155AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376236B00BA; Thu,  9 Jul 2026 18:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FFB76B00BB; Thu,  9 Jul 2026 18:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19FD46B00BC; Thu,  9 Jul 2026 18:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD2516B00BA
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 35C161C80CD
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:58 +0000 (UTC)
X-FDA: 84970684596.12.DD4FB75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 843ED2000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UdDxyqeW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12q52AkfpwCcKaywW5xgOYdbyP2Q2Z9ADa+mmKu+0cs=;
	b=8Gt1dvR7BkXpMy19ZQM86qfd97X1KTQhvOt5Kl1RyYMlC65VvvjAqUywlUzDfiQycwgh8b
	4FM1UgXLindSLCJH06Y3GvoRvD0+yOybXO/7BodzVdZ5WWFEwdK+r55YopjAW2yxzAsCrV
	Seb7nCR7Tu7hrqXlesjZ1XehhkmrS6k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UdDxyqeW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636256;
	b=X44nnkHsSEygh5MUsqkhGa3jGix6vo7s7i1us6GoahU8sqZMr5ZSjhgBrluncNVhZcbptg
	9ePKaBaVMReNPO+xANKjWW1wR7umPXMW23AlIuhKuIb72WOWU1/Rd8n1THciDelDf48X+K
	X5vWCJr18MM8ThBOuisISa6I/dbk7bU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2655B6182F;
	Thu,  9 Jul 2026 22:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6498E1F00A3D;
	Thu,  9 Jul 2026 22:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636255;
	bh=12q52AkfpwCcKaywW5xgOYdbyP2Q2Z9ADa+mmKu+0cs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UdDxyqeWfhsab+ZCnH0169DDa43vbA6VPZXRbx5UcBWL8lwTBaogAuwpDN8SgMuim
	 utlPjzjYY4bNLcBs2mLEg33tzYzQeG1eGITGcAsScOJ1421UJprnf+/LePysZABfZB
	 eL1bSxQO+M/W+ln7FLu0xsnXFCiv6hc7MGEZ/eqtr0Po8tPf2/BdO4Rr/bGi5pxNoF
	 5DAvxLhF1xMYAKGzmYRdX5vgqEIkRsb5ZW2nwUBaHOypHAljcTK30ab+KK43cIlCi4
	 ktRt7a1oG9LwHNsuKJqcuM/rLAQ1HnG5Zn5VY3KsMn15i/Fntq+ng7t1irCsfEFyVr
	 qieo8Cc6KxcxQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:15 +0200
Subject: [PATCH v2 20/23] binfmt_misc: use __free(kfree) in
 bm_register_write()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-20-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1851; i=brauner@kernel.org;
 h=from:subject:message-id; bh=McQDaVPB5ahM1jPM6oFGOwP56eQl6ZRjgCLBJccmyO4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHx7GSCc9nVCw6ltRd0BrM/YZ9w75Haxr4FjtlRjv
 PGlWzm/O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACay8ifDP723NS/6HXyr7nkr
 llVbb3pZNM3GvU9UTDTpkNfibXNnxzEy/D9y13nd61X3nq9d1/ZR6PZvbyv1vWZyv9Vvif7i2br
 4Mz8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 843ED2000A
X-Stat-Signature: hwqn45a4hi1i6gb3fmagbssfjdfx7m8q
X-HE-Tag: 1783636256-164121
X-HE-Meta: U2FsdGVkX1+B7o0UzS/Wpclicu+zD67QGh+D9Xe1fNavAB+SpbxIiqfoZYqyO1xgYU5+HFSdA/7fN/iPRqdU9DL1F9+v83I6QKorS3OhCzDrWuDeJ9nd4lXKePgXCIU+UTacDypRTQWP1KeDlBrlpJdQjyUqSfL0f9uyhwu+R3PfoflUR898CeoTacrQsWgxwsZaV4Zg5uPz79jNuPrEJX5W4AG7Omm6nb9NO0HdSF2BEB1AeLK84BRxUnCqfNhdCKA7cyNiQ6BXXxQziow6X/taKSGhL7/VeyN9kyBgPsYneIYaowLcYxkPY2OphCq1hi/ot7iL5P7vr5+ImG9a/34gD6vLGmc+YZ7RBdDkun2JvQJbFwJI+95BCCtNxg2vi//dHc9+nq6/L2q81GKXXXkeF0/ghIq7QkhwsKs2vixMy4AjBrSuD19v0MpjJQmlUpyCd0YiH1/BUqsCclmDfssHhYQu+ELSsb7aATzIlgFKKSyINCazARBMIvRH9wq/cV10t23tYcDMNMHeL9bsbpfCQcuzSVIY7qlt41JDARZ7yIWski8f2UwahiWLHYhQwyX55BjiOc0vLW854aJu0aRi3ZqSA+Ol+wAw/8+kU4hbddwb13M6XiZ+EW1jaIEUbtCCCF1q6bYn/uAbeufbSjwGXXR6Cj5QlL2fxp1040EDbg37HdC7IgCHpkWq0lnUhnK+RLCsTd86QFWw1SEWvAAofrFGlx8kLezJ5+if7djx4eqaVL26gDPhdjSovaNL0FYKGA4FCaGjpO+EDTUDkw1/gaE1rPQFk05k+HPjbRLOokhYB+7ccE8nsX+n+61DGxhL0zqxxWPzx2s3uCRABhuzTYyuUTuwIC/5dCuUIlvUbpE2ucev6REFrqM4JSE6GZ1lnXf+BQEX2rA9xGdb8MsiIzgdZOCC3utgwofXYJ/i+yScVOn06RoabRi9pRC4Bc4QJAoNGjYT3NCoYWl
 WTL5QAiA
 y3vhCVbD2xcFnMefq6LHbj4LqymuT6bZv3O2rOIq6e+rdDIkJQD8WF7bgPy6hgp0a4Ghdsk5w1NYLpXeVfiVTgPB5oQbtgPs7sYUoQUKCH7c1C2EoNdAVwi5Op3MncTpCfI4ayW/RdtR8QTCZUsB0rGms/LIi4tTyorsj4Hw04ViaS4Cm3uHLRdTSDCFKKzcdNeoB1PZsSVBC6c/L2EjAMTyOudKdEzGUis9NqorKyKzvWYGIIA7Ghez1eC6P36ECnY5pDQzufZFHQWk70xFE+ZBiOafkPhOE43YQVYvXuzmy+aa9hGnte6kUvmhAyVAo59DIR18u9DCLtGcJ5cQEItbGTJDUNZD+7MR8zUY49m7lqNNPP/lAD0jje6ZUGo9wjHA6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bm_register_write() has to free the entry it got from create_entry()
on every failure until add_entry() has linked it into the filesystem
and made the inode its owner. Arm the entry with __free(kfree) so the
error branches can simply return and disarm it via
retain_and_null_ptr() once ownership has been handed to the inode.
The interpreter file keeps its manual error cleanup as freeing the
entry would not close it.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index c2d947f934ab..6acce58ce405 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -796,13 +796,12 @@ static int add_entry(struct binfmt_misc_entry *e, struct super_block *sb)
 static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *ppos)
 {
-	struct binfmt_misc_entry *e;
+	struct binfmt_misc_entry *e __free(kfree) = NULL;
 	struct super_block *sb = file_inode(file)->i_sb;
-	int err = 0;
 	struct file *f = NULL;
+	int err;
 
 	e = create_entry(buffer, count);
-
 	if (IS_ERR(e))
 		return PTR_ERR(e);
 
@@ -819,7 +818,6 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 		if (IS_ERR(f)) {
 			pr_notice("register: failed to install interpreter file %s\n",
 				 e->interpreter);
-			kfree(e);
 			return PTR_ERR(f);
 		}
 		e->interp_file = f;
@@ -831,9 +829,11 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 			exe_file_allow_write_access(f);
 			filp_close(f, NULL);
 		}
-		kfree(e);
 		return err;
 	}
+
+	/* The entry is owned by its inode now. */
+	retain_and_null_ptr(e);
 	return count;
 }
 

-- 
2.53.0


