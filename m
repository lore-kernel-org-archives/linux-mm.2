Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78292606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lprTDZ0s
Received: by kanga.kvack.org (Postfix)
	id BE5676B05B9; Mon, 16 Nov 2026 04:45:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6EEB6B05BA; Mon, 16 Nov 2026 04:45:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5DC46B05BB; Mon, 16 Nov 2026 04:45:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5DF6B05B9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:45:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1FED808FB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:05 +0000 (UTC)
X-FDA: 85440498570.22.956C2CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1C269180002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lprTDZ0s;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vyW5QdKol+80/fjPgvhCylUQMF0z10mUg5s+ZbR/1uo=;
	b=hs5b+67A1a/erj6DPabyp7SWy9V5hlQVq9FTknvxAAY4K0oNe+YXi3qs2dXhPhlLqaX+RI
	RLHx9jtOR6Mt76xtA4Zvb0igsUAv56UTqsGHxtsKOmli2q1CBfqFFFraYZ1VHeU/ohgYCA
	f8kcuYQu3idBD4pvxsWbr4BFdDb8Au4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822304;
	b=644SryYbTRSE5LVJ3zKGpwKZchrwPCnGHVqpFenr61TAFdFVxpaeVk4ZxVcTAoWVBzCbSl
	S90ldYMi9imlA8Rio/WQnzFBKo+WvO7l2VRteKU8N+bVaU7fa17frkZ45v6vOTSkZ2iQjZ
	rmThsYiH3SbmeqHvX+ag5gNKId6G7/U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lprTDZ0s;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66D2B46107;
	Mon, 16 Nov 2026 09:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580CE1F000CA;
	Mon, 16 Nov 2026 09:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822303;
	bh=vyW5QdKol+80/fjPgvhCylUQMF0z10mUg5s+ZbR/1uo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lprTDZ0sQotlHE/T58JvqHpPZT4UIPTL1aLAQ2c4vEHkIBx6rHhUdCUq6m8e1vPyK
	 PiAGWx2oLXgoC2RQpahV1BJEHTspBaY35fOQaE0ayPJbK2D8znJHHq+zsLdGNt6gmo
	 1ToKqIYZAcnAzWEMoa8mmSZAuSQ51ifK2Ug+BlNm+OEzaOIGtrPv9bhaXo5n2FMgMo
	 YmrevFYS1qHv7mgiu/jtpB+oRnR25WUoOcL7FMt/7bPHayO/XKCqSu3jFq6pRjjx+t
	 L5ywSOkyLF4vwl2LMkrIykHKjQIp144Z9EhRMyNsgYX2hNPyYUBU/u+Nxoq44qZVfi
	 6BOPmJD4ovJQg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:05 +0100
Subject: [PATCH v2 08/13] ipe: handle errors from resolving the real inode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-8-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Fan Wu <wufan@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1834; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fPWW49CWnZPR7FyEd0MmVPmcEagSdOdrpi8w3Ql2zVg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulA+1YdlymPb6RFeazOEZ/k9/VjUem+5eE6jlN7t0
 7Yx4SvsOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZyypDhn+mznLf+U0R+vBBZ
 s1aO3+fL589PdtqcVzunfSEpSbFkeRPDXxEHv5mMfn8u8x6Su3Zm4r9PZRP8z6gq18a9yVfc/lt
 4Og8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: wjw73pq7y5gsrb8ywwyb68z5sru6yfey
X-Rspamd-Queue-Id: 1C269180002
X-Rspam-User: 
X-HE-Tag: 1794822303-10285
X-HE-Meta: U2FsdGVkX19QEHpvHdkaO1RnuFArCGi1ZtGiQ2u3hfdatEyCGfQvpYpRDWxe7CDQ749Rpqe7UCHV1VwDz5dnNqcMofA5QFnpC/k11/bluhDP1NHuSQ9mLPrykJh7ophVVPUHvqL2eqCxMwxbsWZdBFxD5YayMFqzeYJqOh4y+kygGA3+CplZNmV0f24X8DuuTyScue5JmkF/DKZ0wwz7vMcTsLG9HXu16XnuYuWaSHziBChDIC6mOlEw1S3sUc2H1yCNKacZkVYwopjG0KP4BT/TQYpg5z2+XcwOkmKwJuQxiOgy2XqNuqWK9a7OWKTyND4GQcxZ9OKdPazis7pDh04FawwKkMml/cIlQZF/9GGpKTF+F4Y5urXpGdYW2HPXEBW0QBkjZr0OrCdW8/XJ8r7BsVpCJZo63X4Zl4d2vzD+qoa5109rgHclvoiz4Kh1kw8jPFl9Xe8OerSotJilEJ4hpEVCNENzxzWlK6dduIBhONX8pe89jY2IC6bdCGTGPS5WMPJOdS0gsjKPCm510yfJr/mr6BWq4HFap6qZUap5WG14koBGUF8igg1oxDyUkIDrXzmSUPZTgPNqOor3n7ItNxNsbbymPx6VN8VZ0KKBhcQfi4FJg5z8TeM0mRY/GXHeJU47Oatkbh8WCVdUyqidUOukP9pAFiSN40TPrBVShEGSD/GPCwVuVh/uhu3sfZphsQSaHmtUpbf4Jr7sNN8uwZ8rG517FsgAjcR9553RdVKqThAeHOjUEVPKTodtmzLOADhMTMgh4YcIfyEu+pjg4crLBImq+qE1SZpggONoxQW3K45l2T6Id/Q6kXJHty+n3esYkAulCFvz3NPfvNfWQtlsQ4CixtrtPvF6w/WvyzSlUkbZX3P3Z1d9AKQSG2r/OJHuc51+JllzPhw2Kj9x6KJu1DmdvRYi84BszeOIjfbRApNP0KWbJdinlbmyoHcos+siLHpGw7c7eBf
 WSXix39L
 nOwZGU2L+105R8BVqQbo1upr5tggbyr3M95+DUNTEKRL7HOyO45PxZG0OulZ18+A5I7lMgTFGLJMIpRzmWbLvtTTmi/21cu4B5ofgO1Tpz98wS7zUwbIRmPrDM5t9w3SnSciqNw0H7ykXuwy1abfZC7rUbBel+I8CRWq7WQ/AGOSezPnSZiDfe6vJR/nyZ11FoyQDVyNJHfcLz4KdNo2915lZKG2sWMtKx4Ww1xujaScT/A86jrtNd+Hj/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

d_real() is about to be able to fail for D_REAL_DATA. So switch
ipe_build_eval_ctx() from d_real_inode() to d_real_data_inode() and deal
with the error.

Currently, if overlayfs fails to resolve the data of a file it hands
back the overlayfs inode and IPE evaluates the policy against that. The
overlayfs inode has neither a block device nor any fs-verity state so
none of the properties of the file hosting the data are visible.

Instead, leave the block device and inode state of the evaluation
context unset if the data can't be resolved so the file is evaluated
without any dm-verity or fs-verity state. IOW, IPE reaches the same
verdict as today but without looking at the overlayfs inode.

This is a no-op until d_real() can actually fail.

Suggested-by: Fan Wu <wufan@kernel.org>
Link: https://lore.kernel.org/all/4e9a39ac-9ad5-49d8-b0c4-09e665504609@kernel.org
Acked-by: Fan Wu <wufan@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/ipe/eval.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 4a7be96c84f03..a2366eb9a47b3 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -102,9 +102,16 @@ void ipe_build_eval_ctx(struct ipe_eval_ctx *ctx,
 
 	if (file) {
 		build_ipe_sb_ctx(ctx, file);
-		ino = d_real_inode(file->f_path.dentry);
-		build_ipe_bdev_ctx(ctx, ino);
-		build_ipe_inode_ctx(ctx, ino);
+		/*
+		 * If the real data inode cannot be resolved, leave the bdev
+		 * and inode fields unset so the file is evaluated without
+		 * dm-verity/fs-verity state.
+		 */
+		ino = d_real_data_inode(file->f_path.dentry);
+		if (!IS_ERR(ino)) {
+			build_ipe_bdev_ctx(ctx, ino);
+			build_ipe_inode_ctx(ctx, ino);
+		}
 	}
 }
 

-- 
2.53.0


