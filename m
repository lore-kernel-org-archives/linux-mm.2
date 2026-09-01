Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CAE8C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67CB56B00BD; Tue,  1 Sep 2026 07:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6540B6B00BE; Tue,  1 Sep 2026 07:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F136B00C0; Tue,  1 Sep 2026 07:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA496B00BD
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:40:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1DD3C03CC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:40:41 +0000 (UTC)
X-FDA: 85165001082.03.11C35FC
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id EA0AD1C0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:40:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oPCalbCN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788262839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NbJYqMSdfBVb+Q8QcPC8voCv5rVOzcHLGQSLMYKXoJs=;
	b=NV8OCrrP4oPC1gGDo3l+oLQHuOHg2sy9NJNcSsUiW8hD/i5NjUl8HyClg/b2fdICE5S0Oh
	r5smaOSd0cdiQicC0GzQ6F6VlFwq+kLtPX3VOPFnlqkYwoBBXy3fLpRnV2UlrMuv+nUKBC
	xuwMuJFmWmbBTOc/NjUcMTLbs6Efbhw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788262839;
	b=rkXOXq3nq+clGoaCR8nW/IJnnOipxqMggnAzOz/Wz9Y/j9TXFAfXX9iuBHZky2kl745iUN
	TSjtteI5jWdJipy3A4EFDkkb8xgSAOhgokwR7NU2Gym6o4BISzFkE8ojMXFL1bdHxhThDv
	iuCj0KEel8jAPUlCy1fXYnnwPtNoX9U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oPCalbCN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cc149372c14so635618a12.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 04:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788262839; x=1788867639; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NbJYqMSdfBVb+Q8QcPC8voCv5rVOzcHLGQSLMYKXoJs=;
        b=oPCalbCNoxn7M63zP97Wx8+N3D1qKWrFmZarsB5b32SmfMTi4Eu3fnJmBuEOMBhLgQ
         4HztbQgcMWZgBRm645l4TGbKUf41kp7Uz714aqQ8k73caxhr/4LP585NE1Wd+y27PBJW
         YDq4Q8Q39XEDJPLejRHYrJX9GOQ6/Feb/nj0fZ+hhzvkUThxJHyKua1k+eGg1kMczkRd
         494R7s5/C8Ngnthvc2/O8F4b8qkEB3ToeAKtn3SELCwNAkotmWCgmiXoQ+w2Esot4lBk
         dxLeqxYFjyirGtwM/4wgx4FP3wtWa2t30bRbXL9xwCzrEOzfijodwqV61xkn2bli2rjk
         NOxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788262839; x=1788867639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NbJYqMSdfBVb+Q8QcPC8voCv5rVOzcHLGQSLMYKXoJs=;
        b=e0wjK7lRVAESSMHiXxlWioQFPlr2pO+taHKX1baRcUoVunw6VmMSv7V38mvezqxCsh
         XIDlR4qePfKCU/tCKoR76IkQ3QhjGkqfsau2NRYUoktC5vb8NM/UqdLR915Mgz5nZbOY
         gLbvEw2ru+rBcMxQlDEcgIZnQcUI1hbhWK+pCFxDkv39NrqxzcjFngvzAAY0cKijlaPJ
         DbxbD6r/qY3dVEuv3YDZJUyyuobAL9x0AfCoo71MFwG5s64ga1ZwT5Rzfxv/j8yL6pbC
         BF+tR3Gz5S4vnV95mRucMJledRgUSQSgtbajXzH6BGxycruVJwqncj4KPBC+HG3kfyFL
         /giA==
X-Forwarded-Encrypted: i=1; AHgh+RqDz1WgRmzvzU78mDQoQlM1OEScOmn3V5AwJjWF0l7sHzZu2ZbJbn9yaOtL527rN/jw5IaItXka2Q==@kvack.org
X-Gm-Message-State: AFuF++llCkt8HpBFaO0IPRz67h+XJaBNYB84WyJZ3+Jz7vP/LKngcz+e
	aDk+9ppwth67b6ufBEM+JUGIM0bupJTFpPuziLf4lkmoz/KD7oSUDDre
X-Gm-Gg: AYBFou3wMVowaZM2Vlz69BCEhkL2yNET1eE2SIVXMQo47jZjaB7mHnA0Vwk8p3bPJHc
	8fBw3ekczKb2YQI/HjgbzsXczzxOcznirew05qaTgZOaHubIcuxeiLRlHB/0keSSKBOQrWsxXmb
	NahA/68I2HiEQxBdeyqiiqVV/bavyOeefHBAJOir0Uf2YPsWR5PBSNZ+pO3q3pF/gkjxPEH/Qb1
	cDRVz/s+hOIwONh19leCNLhRso9u6a/znelnf8A4eSCFP2ASTOZ8JfTw7PHsCI7znonsiVtBCO2
	DXY4E5H5v/3EiJ8KxVImmRSn/Spueb9lGRTgtVfmnehar3wtqLwypCCgwQRqreF0UiG2kqRBOme
	evpdJpYFfzYM4Hgm/Vq3MOPvBCey8zDl+OOhRqUKws8Nj2ZhjSAHs2B9s5siRpVsY1T+z5nUEpw
	dCPPKk/0MtE4Z7kBsePaLpC7YJHf7MLBmStDI8hpcM+gKXxaaZOnt8FdtU8Dd0PIO6ZkO9cjQZH
	dvx46bxqZU94bh7n0y2o+J1TQdjwHrzuXDWOv7vCDKo
X-Received: by 2002:a17:903:42cc:b0:2bf:27b2:4b80 with SMTP id d9443c01a7336-2d74e1386bcmr327790875ad.14.1788262838570;
        Tue, 01 Sep 2026 04:40:38 -0700 (PDT)
Received: from localhost.localdomain ([2a12:a304:100:1e0::500e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d75988b6c7sm49316075ad.60.2026.09.01.04.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 04:40:38 -0700 (PDT)
From: Sun Jian <sun.jian.kdev@gmail.com>
To: kees@kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org
Cc: jack@suse.cz,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	tasos.papagiannnis@gmail.com,
	Sun Jian <sun.jian.kdev@gmail.com>
Subject: [PATCH bpf-next] exec: Drop bprm loader before closing bprm->file
Date: Tue,  1 Sep 2026 04:40:11 -0700
Message-ID: <20260901114011.112375-1-sun.jian.kdev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EA0AD1C0006
X-Stat-Signature: uhj1nufwgcbw5c3f3gq3h8u5sfjogy7m
X-Rspam-User: 
X-HE-Tag: 1788262839-405666
X-HE-Meta: U2FsdGVkX1/cLpVJ2mCwuTdQUPCx3hc4GaEJu0MroWAjSufulu5TVIwLJsG5wnM5/Mv62OKBmgac7r9BQGA5tlv7v233mDnDgd4WeGBfrYMRECEe7e+XX4wbkOQZIWUOOp+x9DZ4BJYhVamCdMe3xPAamLBIzYO/1dYoHh+JTVMHaTVhvbXO0ecS3qqrBjQdEVl1YfeGhV1FwB9bSlK/ch+M5sutmafYKQ4iCiNYdhlp+sohw48XWqGoOnay6JO5BZOfH5SOtPbixAQmDckFv77gF7nimfRD4K5eWpX597Apm59S4dyNIWugujUytvX1dLIrtKX4Rq9M9cY+WNn9Nfy0pyqXaxWdatOKZCphzvqy7jL7Ha0zLrIK85tzc2k1iZSisTcO2riwPbqEjQIMsWGOvR9bBzoiA2dTPqm5iLhOufJYcfuqkRE/B+YE0xCTO6LC7We7jWXr5xTxOF+4gxpO8vfdVAymlAWGMN2mdamXrCSRdmo4NMtRVpNJwmMRvEU8mNGmYRjkWMINIbZEjBCbcmuXNLdWS0x1DAcBWDxZoeUoTwEJGBlC93WLD/7cpQ8rgBhFzTSpZ8+4gCYcdA8U3jKFfdIqmbmYaBqYSnBxLQFZrGmv09V7NYleMLDLPt1MAIqppHj3E5K7BihBsfu8mqYCpblu1NrujdZTwa08/V5xBQdQKctOL3o2elEvrqWCxYC/oaSlA7f+4rfPs0J5076k7npjq80wWZDOmSNjPaaMMWNfRcjaKqYKsOUXla8JeatS/dxJ5VG8oivAuHBsvIGYxAnfG2MzqLu4Vfe3GASmj9g7LzoPcoWXmvTyK8TGcQgXrzRxspvJ8GbDXoQ40spnFpB1fwQFqmGGAWwIy5yEohPtuOe3683C4+ix3IriEfwpPyymdqGqFnmgc+vw86AyluJ3kbIez5DMIEltFc390K2+/6sOfqIsWzoa3xXPpM2iNKOVWUTUL+T
 b9shPR+/
 5AQsLyln6QIuzOYE6Y0ctx5DWYZqLqBKBwTH6j/gYj0BC8+75g0ndbMftPEE9SZ2SmQLQkPwDRB8sq7+QYnEnB2Gp0q1Kt7e6IrhiGcThFqet1bWh1cohdmdD9y6rhIhOVIRyI5fypOouZ1T75perNc98eZsS/FmimhOBLCjogwAGxDXUEY7ULKpDvdNKbfzTsOxyv4GdKMRyO7Nj1CSKDYIJCwRkg3tM6npgRuymmXP6k7pBoab5vqw/jnayeXmBBvINo8MN2iSJ7SFQrRWHOjzHE0ZdIr4jn+5chAB1HJ1Y5roL9Ok459EC6STTEQ+NAK0eER+sFFngDKU1aHv5ERxZqyCTUCo4+nccUv/RIYOmS99wgp5iftPwz0WpDEr5FV8u5aVlaUuEFdjDEr2QQsptzkZBquALjGl9ZMhyvo5XHCWUgALsGF4QO38/ya4C0w64ToRAFnNEd4j9v9n+uaCHfTAdDTw1oW1NPDqOEvaBAgBSa1//DkQpcy70ZfJVf8ErCZMNL2ku9jVZzhez5vgjreQoU2xi4nAldlm2U2SBeYiVutS2A+PFqgIFuW2OgU/R5L2TRCQcC7A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_bprm() currently drops what may be the final reference to
bprm->file before calling bprm_drop_loader(). Since
bprm_drop_loader() is attachable via BPF fentry and bprm->file is
exposed as a BTF_TYPE_SAFE_TRUSTED pointer, the file can be observed
after its reference has been released.

Move bprm_drop_loader() before do_close_execat(bprm->file), keeping
the file reference held while the hook runs. This preserves the
existing trusted BTF contract without changing verifier behavior.

The loader file and bprm->file have independent references, so this
reordering does not change their required teardown ordering.

Link: https://sashiko.dev/#/patchset/20260831092305.42062-1-tasos.papagiannnis@gmail.com?part=3
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
---
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index a14f28b15607..263b1f67f1f8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1469,9 +1469,9 @@ static void free_bprm(struct linux_binprm *bprm)
 	/* exec swapped the mm but failed before setup_new_exec() freed it */
 	if (bprm->old_mm)
 		exec_mm_put_old(bprm->old_mm);
-	do_close_execat(bprm->file);
 	/* An unconsumed PT_INTERP substitute from a binfmt_misc loader entry. */
 	bprm_drop_loader(bprm);
+	do_close_execat(bprm->file);
 	do_close_execat(bprm->executable);
 	/* If a binfmt changed the interp, free it. */
 	if (bprm->interp != bprm->filename)

base-commit: d761934c9483ecde93fe99d8705282f716dfee50
-- 
2.43.0


