Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EFF4606A330
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mVDBwAAm
Received: by kanga.kvack.org (Postfix)
	id 55F306B05B5; Sun, 15 Nov 2026 09:02:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50FE56B05B6; Sun, 15 Nov 2026 09:02:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0B96B05B7; Sun, 15 Nov 2026 09:02:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16A8D6B05B5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:02:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9EF6140750
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:30 +0000 (UTC)
X-FDA: 85437518460.08.F8E92B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D61EC80012
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVDBwAAm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794751348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exSQh+ckYaGqDXTdGKRk/DINSz+CEfauTHf2mGVm1qs=;
	b=VFBMaBGvulRsEOUjw5hXvr0dKivJvJXgbnFgXIKIGWr2amFmV4s2F4aHk1JYQXUEI4SpfF
	Z4EhHU4nPp6pk6cyUH0rSXZXTmbbPPxF0UXI66RJ5A2/cX/6j/KDsgNVoR6OkawZ88E8jy
	9H7tlLAYkmm/ch4zKRZCV+e/WZJkIC0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794751348;
	b=j+guZjcOwduu+JNS5l1OHPN77uj26iNzyxb5d03W1BuiJ7JFoMi4qIocKHfjJmaQq3jhqM
	dW1hXNjvmISlamMVNAdARjYsmbAwUBqhLc9dfdJUrDDH9nmKwmBQHFvgHSSQtweR6EKIvO
	wChm9ytkQO0bNtC47AbVDoIKTa6ch0o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVDBwAAm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E12C623AF;
	Sun, 15 Nov 2026 14:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB31C1F000C5;
	Sun, 15 Nov 2026 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751348;
	bh=exSQh+ckYaGqDXTdGKRk/DINSz+CEfauTHf2mGVm1qs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mVDBwAAmMMfoI07kdlegIgj6TgxNBrmadzij2h6L+/SAceIm4g1BJTXFeH0ULv6Ii
	 MPoimMgdje5DxfoVdFo/7BqRAQGTsQhv7It1+6irZXYWHEXZ/IzNq4GP/O0V9HGLtg
	 6rQFM0ffCCWzBpHlPrBmQN9XBNtRjC4D+i+pFgXM44MQRmgC05j/CSzPHmoN4wJnfl
	 R9SepAKc2/vo6FRAm246FMyCPUTXU7d9DXT4Ql136WAN1hFOWQQcczRtkn9BTJcjYs
	 uy1P6CM3r9DEp47qWwldVtxy/IzyZElL1ervdfnyBqFpt5CZ/2GmyBJR3A92OdCw4R
	 /TqtG5CUfs3Xw==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:35 +0100
Subject: [PATCH 05/13] selftests/bpf: handle d_real_data_inode() errors in
 bpf_testmod
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-5-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1590; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8ojyWSbSgAy9/5Lt4D7/0d3uAgnyMk/lTnwvRHMWeIQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B3q9z78x+8L37QlfDfd/xpzriLxjHO/uMxytjg93
 U+L72xW6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhI+ROG/84TY99yZnBb1Hzf
 rbrBVdn1Q2DcbIv7EvejegKfntz2Pprhn9prvXMcX0qPHJebwriM0ev68+tK155UXfQNusKZnbM
 rkgEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 4mcumt5793aim7oh6snqkhtjnkesxza7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D61EC80012
X-HE-Tag: 1794751348-606021
X-HE-Meta: U2FsdGVkX18T6zC4qngirIbyDZu8A8dcpM2o98x9shqSeDVrSzCsCW5D5Cd/Sv/k8Z9Is8gew4zxmhRA7a1Zf2+0808qOIVLjTElRKJYqvyT61z1e6w7z5DSKuEw7EPaIqZCma5dKrCJ2fW4I/2IkdMeFPJRBCOYRPjhISvWrkJ4If+QUarE4qizV5cdwct+yiD/fS7O5bZ0OvOESljZqUooGERmBSsIIE/2spCV2nt1p1u3I9UjZW5W1KTnmswkdW3oKhol34jK0ISEDsQoFpv4JZrmRTBXsJCm3VEsTTeS2vntmNHpkm72KImp+Xs1wd+qBQFClhcGZv0nmf201pZo7SLc4vX9kr/bDuaFNbNaOjo2bEhHfRBBDmgtjM7oDNXSrMbWvQK4UCXBiI6/sND+vyrOH6HibK3KMcIhkzNIJOQsHV1H1dA4Ao2uYQoo8+yGSEXMWiF1NkJ936THPBFOkeL4ulUNa2XJrXbGcuvhNI8F6Dxo2fPjkRlrQmUIzVJfvk7ICR5tBEMST6pF6EcWyaJEw2EsfjfPvCirFlwio+d5XnLjn9VyWE7bSNvI7iMjTgQz2OQgrR2eTD3ZJke8ymaG/1gqSb2spPblivDyZlKcQZ6jrdH19r4joy3yjIvCti8/dC1HgnHBKjTpNjFKxfvo6RigBL3TLyY/kE38+hpdQjxpgvcmBfhuKS3zY3DfD7rwowAukvsOJWo98D6yNfGbmH9kpB4EzRYUK1y94o9F/kxV080icFsHRGymb6vd3K4+A6/OW7OE8ItAA13fCsb0hAp/B91DGaAcT6coiE25ggij1h2BfUKjG+8JJVgNi4LaZl/9RstkR8WLqk7hPGHarFt0Ni8bWWX9F2FqPq8MCXIov3+VsA5OtYtFllzPPgPUCMo7g5CpE/EltAd3ePNgv9TonF4xtTaa69X2y+cUPsIWVeIWT2T0bJffofIRmFGxhKK+fX4sYOj
 Ts+0L/r6
 +rlBRpn5pMQtIsr9War+v8I0OgdMf504UF9Ync9LvTcWFx3sNylQsVqBG1SbYsMXDTRajX0m6z5hMMpBHNlrNx/5ZXV3P747gXU8E+sisXgoKwtKOR2v1OAGYOvGOlxQMS97v9yspMlUr8WzzLzEfg7lQYAcgPAUEJMf/OODvTYAmsOrus9t2n5a6eVg5RvY5HpkrHwBsLNY9EUrk59tQvSvwiiL6rrlQ45rMZaY9rJkigqla8TOlVinS3M7RIK2xFERvGn11vo7afcTRKvyuNLWyw5jgcwxAS4V5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

d_real() is about to be able to fail for D_REAL_DATA. So switch
testmod_register_uprobe() from d_real_inode() to d_real_data_inode()
and drop the path again if the data of /proc/self/exe can't be
resolved.

That's hard to hit in practice because exec opened the file already but
it is the only modular user and d_real_inode() is going away.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/bpf/test_kmods/bpf_testmod.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
index 76fbe64755ef9..9d065a800f655 100644
--- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
@@ -948,6 +948,7 @@ static struct testmod_uprobe uprobe = {
 
 static __always_inline int testmod_register_uprobe(loff_t offset)
 {
+	struct inode *inode;
 	int err = -EBUSY;
 
 	if (uprobe.uprobe)
@@ -962,8 +963,14 @@ static __always_inline int testmod_register_uprobe(loff_t offset)
 	if (err)
 		goto out;
 
-	uprobe.uprobe = uprobe_register(d_real_inode(uprobe.path.dentry),
-					offset, 0, &uprobe.consumer);
+	inode = d_real_data_inode(uprobe.path.dentry);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		path_put(&uprobe.path);
+		goto out;
+	}
+
+	uprobe.uprobe = uprobe_register(inode, offset, 0, &uprobe.consumer);
 	if (IS_ERR(uprobe.uprobe)) {
 		err = PTR_ERR(uprobe.uprobe);
 		path_put(&uprobe.path);

-- 
2.53.0


