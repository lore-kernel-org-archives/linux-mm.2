Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB698606AA19
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uaddrix3
Received: by kanga.kvack.org (Postfix)
	id CF5236B05C9; Tue, 10 Nov 2026 09:53:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F006B05CA; Tue, 10 Nov 2026 09:53:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6DAE6B05CB; Tue, 10 Nov 2026 09:53:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7FE6B05C9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:53:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2CAFB1A0918
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:53:15 +0000 (UTC)
X-FDA: 85419502350.15.FD863D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3B36CC0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:53:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uaddrix3;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794322393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4AWesagrBNDvfdI2Zrx2GdO8Neuv0xeD/dEdr3QPpV4=;
	b=8HgLVGiORZa8+Z4RZV4huPDQk3YhpKYnbAXUrBbIHAVFwBKsVhJujqreiTlXkBA1/b+MYJ
	uYIwfGFhD01SJXA4OAeS6Nkr0ShMMt+LC6/npE2mFghxOHQ64NxLmh9qgpMSBxJAooJkKt
	lKCoEMx3hH+iemRVHgRYZk1+4ZvgG1k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794322393;
	b=f7x2foIqrxN498dK5hDKkEWmv4RxCT5zuGhAYJ7W+Kud0GAsp4c/U781ZwgBbgBOIBxYgS
	Uh23Z945MeujC2QBwvjpqj2V9R2VNeoQp/vMHJYz2RgTfBjziyVoStTVIGtD7wAIOC04Kd
	bfu04+H560e78THRSELg5stJTtmXQZc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uaddrix3;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5DB3639CC;
	Tue, 10 Nov 2026 14:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595991F008A2;
	Tue, 10 Nov 2026 14:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794322392;
	bh=4AWesagrBNDvfdI2Zrx2GdO8Neuv0xeD/dEdr3QPpV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uaddrix3GcBoBNtjsAiDwLrrVYpFLE4fHuJTEwWUlGuUYzQkzmu4F8MJIj3VH0OH+
	 b+txK+PSB/lTeonmTUAhuwv0yp8T3O7iBA+D0cJsU/y86AOeqnMMsuIpN1FWJqViGN
	 uf+iFIQlkvFYpd35eJRNvYchVdquMk9NFWJxsfXX0wFWi9R2P36n1fmjuhZE4WlKV3
	 0i32qYGEjlMZ413kar23TfRX0pZ6J4QfdS4/kSkqYsXu+YnekssbTHt3zdXCcUiTip
	 efB2nPCnEuwzpUlJuwvfo9QLppRvsn4jzbtI1TTlv13IkoXGJsJ8qbB9aSCkyMf/6P
	 Aj0//sOlext8g==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id A0A541980047;
	Tue, 10 Nov 2026 09:53:06 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 10 Nov 2026 09:53:08 -0500
X-ME-Sender: <xms:0i_zalTYoDMGGwfGOcj7NFVWzH10MzzR7E4etw4bM108qMV0Ea6UxA>
    <xme:0i_zau5zTzFmPi1hYQSfuP-dz83bs2BZpo5tFfBzaZW_auKGV7ew6b0BKTb_KMWqL
    eX5sdFfb9ah-wNTD94HPi2dUWaHxQxasqVLAijxEvPq-lCyc9KwypAQ>
X-ME-Received: <xmr:0i_zaoqOOp8SxW4JGrZJ-WN_xb6XFInYPyMH93ZmUbEL7eFukgoXBO4skZM>
X-ME-Proxy-Cause: dmFkZTF/GFwh3rJdTHG+m4r/9nusArKB1/s/hEpKI5zPgz/j0NVs9fG+TFrQQtAuHGmWgA
    1tbmW3cxIzETgFcEkRf1jbRH09C/7wAmZtr7m1PAmHObJ0oPHKuJRs7OjPD+Yu1tUwWEfJ
    1waEsEuvglqdq+285oX/U2cWR/80QeQcu1jy8nii0+pJH8NB4DjUh758N4RM3iv10TIYNc
    uUKUSJga2KhUyfObbaC1KG0agxblxhp0nCVf8eCx7DFBKYc8e72YJYcOR0tezufCSh/yQK
    AwHzdksBbKWava7E3bJ7mWP5dEA/52o2Vw+Ypoga3ieMrWz9YkgBgJBGSf9TaMGUhbVwHN
    i9mgZDSMBr/kJlbNNSoHt3C10F31V9EDA1mhOk/6BT4QesLc7dExast3CNoDPurrsYIQLD
    bhc9hYCfCjasTg/8a4p0LzrPB3hejJgMh7PKRRrOUxihmv8TOc66WU/NmJdY2qRzM2QNYh
    1YayCPgJIn8kSsPpMnXZLo0JNHPXeuEval8vfDzG94/MmVT+kbaDQ+lmqPCJfZIjBWGMCr
    0FlkMJ1FP7f7GXGFRwgTPnofBkjrKYB5efCsSnvl0y0QjGGFZiPZGsk9HwKsqQRXd9XmjZ
    GFghtwH5ZbE7GACYhuOt2og4KnmM6jqwikwaIF0v5VpX+wniaYTn199C4DzQ
X-ME-Proxy: <xmx:0i_zahTsKw9rvhh6OOwTNOjiqYih3Fbvnlhk8jJOle4RBf__EuWzVg>
    <xmx:0i_zassqV0D2roeDBKn_2laU7WeGaevNL_liV8bY39pn6RZSS3nzPQ>
    <xmx:0i_zahOOOeKmxVT0lDwJqrl4pIkGIOiH8X_Cjb1B4Wp8KXZ0Di2Ojg>
    <xmx:0i_zamW2HF-ReEBeOE7_h0swvMseBB3aOND-fH2ZJirHhIJXXQSLWw>
    <xmx:0i_zaphox_-Bc3Xu-2j9WCASmv-rJKu99hChxOC0s84PeCuzS-Lj1AQQ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Nov 2026 09:53:05 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amit Shah <amit@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 4/4] splice: replace nosteal_pipe_buf_ops with default_pipe_buf_ops
Date: Tue, 10 Nov 2026 14:52:39 +0000
Message-ID: <20261110145241.536019-5-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261110145241.536019-1-kas@kernel.org>
References: <20261110145241.536019-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uwbriigyq1rgy73qj9q6o4ot4jxdw9yg
X-Rspamd-Queue-Id: 3B36CC0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794322393-77078
X-HE-Meta: U2FsdGVkX1+ibCsEy1Srbi5xFaOgFrjuLVoMkRVsO2KSPaGv3aglvtif4AhtqgT4CFSc6QXu5lXW5bq3rMOH8iBmxyS/zHaN4flYW7+fGYNnKqfosHC1f3pmdAN6oPdvaW7mAoSZSnlqaFNXsoEb67xRGdKg5PDbWvaE4IOVNNgwWdaYaxvmAALvuhaP/hSxi3Nx58Q9arN65Mp0NBSkyay2oLWGniftN0GoC+/moCJjsCKhptqiEi8azW/GVi5f/q4jL3OKVLEo2C7SbQHiFdbwr7oIRcMrgCq2BI+DvkDCExVOnGeCdgwUhon2fDllwxYV5WcGv1+wUPYJiMlUdBUXGvZcdPTP7o2ozYQidtQxFpRjm+LSBvC+bjvieOHmOo+lt/+VKXiA7WiPzC6Gd/i1mI7I44yB/Cr5XAXkkASqeJj/64nvbzcSWWSOJIE6rzqL46Ub6pv0fgMzlP6DDB4hYGwWwMGjL52ndtGOX8tXGic/QmOcADyz+IlOX57mTY7Yu7kblclGahIHIbuBnhwzZTuuQZJr5M5z+1MwcHehMzg8MZqGExzH/pUjv9rukYe3C0Rz6sfG64oE5LS6dz+DPHTVl/F0WQTmbjLD9APe+t8Wxi0gbuFHz4zUB4lukDtbLBICL003B3QE0XoGtDQWRmnE43kPK6QIigJ0t2C3IbvrCDAeRPYjc+5soMnRBNJqiDuixW+GcCW8eUyeh9W6qHOXw9wC4zgC02MpgaKgPxPxtfPZ5t0viYQ7pjxLwFo/Ldlo1RvRpHBR78pVidWU6qrktww497fHxG99exof6j88WKPX9Fo93u0J+vmNsTYhqcgzILwutKLwlmCgKAhD8CYp7YW+k34L8UDAst2FEKUdzvMbb7lgxatvWKIFwHoMzx6+P4abeKgpafbl+jCHMuAwW7/Bs8jiw2BsiI7hPZIcu5SyTRlvl+DKHsTQNu47uz0aERaQTJ30sK2
 EaKM70Tp
 1kpVBK6Y5JIt5rVckk4q0hqBhcv9P0thjveVVgFOSo4zKMWs1MWefANUQPxUrbY8aPRLGkzOB9sfRFG1sWjJrcj8qqQKUaHfj1BfrVfl+vwWJuLeBCGMjz6GLinLJhKA1sYXwS70du1ZC5qMsVKFvc6w6FwiRyL7Y5Wp9GUQ4DP1DB04sclvK7nFIOd5w2jFUF0Mg3S6JKVYAyx8MHyOmguEtgvOJ5aV3zc1Jh7/YJaDg0uRxoHwJkWFFw4QLIyguCi3TjPOBrqQaxEMtNghpXzhnX+hfSe1yQym4Dab1k+IzxVNw3ZvkoghOjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Without ->try_steal(), nosteal_pipe_buf_ops and default_pipe_buf_ops are
the same: generic_pipe_buf_release() and generic_pipe_buf_get().

Keep default_pipe_buf_ops, and use it in skb_splice_bits() and
fuse_dev_splice_read().  Export it in place of nosteal_pipe_buf_ops,
since fuse can be built as a module.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 fs/fuse/dev.c             | 2 +-
 fs/splice.c               | 8 +-------
 include/linux/pipe_fs_i.h | 2 --
 net/core/skbuff.c         | 2 +-
 4 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index e7238eed21fb..a5c08a00cf83 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1627,7 +1627,7 @@ static ssize_t fuse_dev_splice_read(struct file *in, loff_t *ppos,
 		 * Need to be careful about this.  Having buf->ops in module
 		 * code can Oops if the buffer persists after module unload.
 		 */
-		bufs[page_nr].ops = &nosteal_pipe_buf_ops;
+		bufs[page_nr].ops = &default_pipe_buf_ops;
 		bufs[page_nr].flags = 0;
 		ret = add_to_pipe(pipe, &bufs[page_nr++]);
 		if (unlikely(ret < 0))
diff --git a/fs/splice.c b/fs/splice.c
index ba8f6f9aa3f0..e9e0c6a7b23c 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -333,13 +333,7 @@ const struct pipe_buf_operations default_pipe_buf_ops = {
 	.release	= generic_pipe_buf_release,
 	.get		= generic_pipe_buf_get,
 };
-
-/* Pipe buffer operations for a socket and similar. */
-const struct pipe_buf_operations nosteal_pipe_buf_ops = {
-	.release	= generic_pipe_buf_release,
-	.get		= generic_pipe_buf_get,
-};
-EXPORT_SYMBOL(nosteal_pipe_buf_ops);
+EXPORT_SYMBOL(default_pipe_buf_ops);
 
 static void wakeup_pipe_writers(struct pipe_inode_info *pipe)
 {
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index fb6570e80d01..95f6236c5c5b 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -302,8 +302,6 @@ void free_pipe_info(struct pipe_inode_info *);
 bool generic_pipe_buf_get(struct pipe_inode_info *, struct pipe_buffer *);
 void generic_pipe_buf_release(struct pipe_inode_info *, struct pipe_buffer *);
 
-extern const struct pipe_buf_operations nosteal_pipe_buf_ops;
-
 unsigned long account_pipe_buffers(struct user_struct *user,
 				   unsigned long old, unsigned long new);
 bool too_many_pipe_buffers_soft(unsigned long user_bufs);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 48f676411724..e063241b2005 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3281,7 +3281,7 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		.pages = pages,
 		.partial = partial,
 		.nr_pages_max = MAX_SKB_FRAGS,
-		.ops = &nosteal_pipe_buf_ops,
+		.ops = &default_pipe_buf_ops,
 		.spd_release = sock_spd_release,
 	};
 	int ret = 0;
-- 
2.54.0


