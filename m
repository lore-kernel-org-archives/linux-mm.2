Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F134606A335
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y6Xs8JpC
Received: by kanga.kvack.org (Postfix)
	id 94D226B05B5; Mon, 16 Nov 2026 04:44:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF6D6B05B6; Mon, 16 Nov 2026 04:44:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701E16B05B7; Mon, 16 Nov 2026 04:44:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44DA56B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:44:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B20A5808BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:55 +0000 (UTC)
X-FDA: 85440498150.02.EAA0933
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id EC0D0180005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y6Xs8JpC;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IANanOK2Ba1PGTfMVQPFJfqOkf92d3DF/Ps8jRPsPqw=;
	b=KmHQDSGmGBv5iyRF710tDTgP3jP7oAkU5Km9W1QCI4QhQNMDa20+ZgV+5HJ/kezw9lMNnV
	yMf2eSpL9jzN87xC4ie8CgL10XIKOkSkTUupV39fJI6p5em1dYqTP9A5+b67WpbfHbDpmF
	9TkQwMJwXswCljntXe6SmKI31EUfmOo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822294;
	b=OhYSa0nRmBCP/b7A2gSW3KB6oWbW0c4EzdH+MrZVx+YRx7NmN98V20JwYWc448L3uH2wSW
	R6jClPWPSu4OPCSPc2vCr4kTfnwAe7y/t5igLPGD9M/xbkJGkKNktcJLGG4nBek1T48teq
	Z2yKuoL/InaxP8AiRlwB96WRPEy0Z08=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y6Xs8JpC;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4203546108;
	Mon, 16 Nov 2026 09:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7DA1F000C4;
	Mon, 16 Nov 2026 09:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822293;
	bh=IANanOK2Ba1PGTfMVQPFJfqOkf92d3DF/Ps8jRPsPqw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Y6Xs8JpCsGXuHbxdEkg8lvIZQYZxeM+EJ6/DbIIqWmClvYwhme8OlMochEtTROaSS
	 NIgtmTOZQvl3ODCUHi1+8r00a+CowPB+/JjqNNeFEckqc0KlLZOR+chquX4RXbnEEt
	 T+ICKp+ujhe5EabSPRCkh0zedJI1hEyOAT1YDJEoCF1tTAtS1Yh0+xFsp1FS+p80q+
	 KbVba8MERMf1NeS/iLtTzcSPtilA6qtKnqXYNAAMkp7g0sTIr4vsiw5cXEor3Gd34E
	 7j4R6FigAMH/3wdIr7I6i223HI6JUXaqAEQ3fmMtNyp7Dqo1wM/YxSxPP8spa0l1Rp
	 j2zEak9XjptEw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:02 +0100
Subject: [PATCH v2 05/13] selftests/bpf: handle d_real_data_inode() errors
 in bpf_testmod
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-5-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1637; i=brauner@kernel.org;
 h=from:subject:message-id; bh=CFSBYOx5MWIEkJ6eS1K7mXopv2zlOaMFahzvyHIDvE0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulBSP4Vzyv7/kqnSF+a8D33eYM7sp7kgrt7916a/J
 qtF/2282VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRe/YMPxkDr+7Yeft72dTD
 cSE9HcVHy57JscvqXt2Zz6HRIfjssxojw/ufZRs3xR6Nefp/2c442Xe2d/LcVDb9vV3w2L+lIGf
 hfU4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EC0D0180005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: y9qo7pfeueaweug33x3bk1uoudju94hh
X-Rspam-User: 
X-HE-Tag: 1794822293-57684
X-HE-Meta: U2FsdGVkX1/gWiGIxFi9VUTvEGhMIk9+v++Ka/WRaAFIKPuBdaGkqD2DvyC7gtUdr4D9AXSI7rLWw9vGkIg56OW36inGlvL5n267gX8ts2o9P8m6i6YBMHDHp8MGnvMFYyBRLYXZ0y16EHvy54uXBjXlUbdO0ntw1AWSMLoJxTx7FcltRE+GXwiTdV75WmEZnvrXEx6tP9LUCi2LmdPVPD20vg/uowOWLoCXj3EwOosLRUE/p3dwRrRjI0t7FkOtBC/2CKb1ZTWugSL2MSfqfMIf+BYX+akG9ZezNZiaeXu2BR2v+mlPlc2coP8wTaWJ2xAvZ775meIDcWZpHDQQxOuSL/5jwvNwTAj9vrFlfaamA/FUoIq5d5p2ZX1arxhzDkd02G75iyIcEpn5V13vgSmIMJMLVGgAyw5jM6bOBK18xFyiM52tD18zOFw7b4HTn+9+0/TULxGmpg4dnIlXRJd7zIMAitjvNSoMzTw5K3HYpfOvJR9619M37N24XnvqnFImxPjs4X6K+ESMb3D74WxQszwUe3p+1HmIZa4V2x7HuPgT2/etMOwb/9/fu9VD5+d/wjRR8kxhv/I6UWLnloZ8NhqRhs3LP4xFMRhxczOAGHEORyi79bi9DzDAe2tinUGi3qDuZlCmKV6U1wSfQGkU4tdkQ7IYOTWSWTN+6847BV/FnHOZ4YiPQ53HTkOTvsu5C4NCalYsQ9gPBw/mpM7eHlg9SqMDtTf1mygU4ASd3K/1GYn2w9xruu6MC30FlZQTMlKX2DrGg+QUD0o6NawQHah9775jgGo3jXaovWKW2I7nGFTQebJhfccjjJhj7qcg5lp25b3Ro0ezw7+Uafv6vljRAzXx/W+E68VGAZuWBIDG0aTmbTR3qYvSjWKgjbMKC0LBMNhBp9HOVs/Gs0ozXLGijFqOLQycF6nNNIkqnlk2piCZVXiG+UKZKwSXS/IlafWZr4zUP+8vNyA
 mdfB5Ayd
 kOO7+ke4rP/vMC/Db4NC3swHm47CAVbN1GO3qCWLbO3DkIYjKKEPUJNu+0cIum+WYQ9CdHtKLeYcE3h0+1cZN8ejokumH/pbXs6h/+6OEaxLzgAYdzte5z7OxhCyv6fAso/DItMkPf2jGWfpput+uxCRw6ljvJVRYjGcYy5WxwwDAq8mGUzbdb8lsmNx/UUpep1tUTpt3FpGzZJsouQ63JKYWHk0lKsU2krFmuDWgLvu25+zpST8mWx5y3WcmiAoC2BxiU8pCyYYkDwGaJ9qCnRMo1coR4UOVz7lG
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

Acked-by: Alexei Starovoitov <ast@kernel.org>
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


