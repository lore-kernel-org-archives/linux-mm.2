Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49452C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2736B6B00D1; Mon, 21 Sep 2026 11:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2224C6B00D5; Mon, 21 Sep 2026 11:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EC0A6B00D5; Mon, 21 Sep 2026 11:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2FEE6B00D1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:15:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 758DE801B5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:15:59 +0000 (UTC)
X-FDA: 85238119638.26.5EFF50C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id DB527C0014
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:15:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQw77VEM;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790003757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xha6SzRmwzcqbwA6Ea+IAg1MkYKVwpH9imxtGliuizI=;
	b=LtI7aevrL4VIeFvi7N80P2ytkiCACx97DwibHuRYI5AAf8t8zjSc1oDSM7qBZxMaeGqP3Y
	AgtTK3v5L0CsbNE6wb3Lxamr0Gheze8kAFxU+fwNaPqxH57yIRh6qwE6nlzafcgJvvPcFW
	tOoRINGQRac+GgiUWqHox2COU/41Zb0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQw77VEM;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790003757;
	b=Wn+UKYZm9/qgwo1lAyhrYS6FyoYxVq+Vd4JaKxquid91XkJAjTruF/Ml5nWZX8mDiuVahr
	HAuU2gbTj1+q1jiDifsEPsaRUVVfs4SuLufKlC4eWeR5oJuqFzeEXcZyhtO+/cwEvDKiOO
	YqPbq66nvUyfe3Wos0oSI29gUNmRqsE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FFDC601F9;
	Mon, 21 Sep 2026 15:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9781F00898;
	Mon, 21 Sep 2026 15:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790003757;
	bh=Xha6SzRmwzcqbwA6Ea+IAg1MkYKVwpH9imxtGliuizI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQw77VEM7Ou5+88h9368Ql7ab8uQ+ELYghiXetB2nFdIaW20TrqvhSVvDZDnP6weD
	 EZlwRZVorUuoVbcT6lf8sSnxox/NM/KaANsgNBEGiUSW0absBAa9Q6ORDB3Zu+PZKW
	 lTQplllX1zVhK/PNK2QEI/+LQLaURhvqRBj4HcAgukS0ggS/ADGkYE8y7OivwNDItJ
	 WQChuFPbSVxWfXltkHCpsEiukWlPQRdw43GxOg+1/Lr0Gg2GHJHfdV9fBR59BwDtBm
	 UBvIs+hADqU3Gj38Gkf9XeV356wnbw6bLGfvy3cjTYSCy34K8o596NLeYFZyDJWpl6
	 2H89KZgPcb/pg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Xuewen Wang <wangxuewen@kylinos.cn>,
	Adrian Huang <adrianhuang0701@gmail.com>,
	Karthikeyan KS <karthiproffesional@gmail.com>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/4] mm/damon/sysfs: propagate damon_call() error in turn_damon_on
Date: Mon, 21 Sep 2026 08:15:44 -0700
Message-ID: <20260921151547.78472-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921151547.78472-1-sj@kernel.org>
References: <20260921151547.78472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DB527C0014
X-Stat-Signature: a3hqsib1sybgt1w5x9fjt7nyhjtijegs
X-Rspam-User: 
X-HE-Tag: 1790003757-600997
X-HE-Meta: U2FsdGVkX1+Zkh43gCZGdKh83srneWCEuMmW+tUsxZGqnkm6/4Z2+LJsszEKS65WtVrg+m/9dSDIxjSG8j18FblGqENrehGLk+aLXUHEjePFwutnoia9NenBlSNuTNbLdtqwT1yj83sbrrFcxn7CHs7Q9TCx4pW+2AcKZdxsk2nMbWOZAqHW7qEHIzWKKfSwVbqPQwor/JvuyoTb7MVbLH0DnaKo0nr9QVwZMkHsSTOOpMz6pVtTvErDta/hPByZCt60dABrw5UNohJhMZtAau227IR0DKLVtXkhQoCSixvMaQtt/LJP7e2sOihXORAEFx6ASBJndZI9J50P/vSw4/L6AZ4r/BPbHomgS0bnwFRFABIR59MNQ8CGM4YeEYOInbY9XgK+Cq8eNxT3bsJgC/RQwNEacc2YQXrB5BmTq+E2Sj+GJG7fciye7E6nq61yvLpvwhVthyx6FzCKhr1TsM5eV3fWR79tFRfmG8nqsglwGnXjxIIanCBZjULNydfIX5tDqQBcwKKUipECsAbUFoXmxLh+3uP49c40Oc99gY8oPXCFYpShN0HFFZk5j7JZHTHqnz+nm/pqXWEcp9Q9xJntDobSUiquPYU5onPG46csBdCWMnWZ6BWpRyvtvBpT0Tf7l5DD266KAjNxQx6tX4mhEes78UppZInpphTsOGjh7yp+eULorfEDm/33sbKmkRRIZzUHFltAhiCFZnjqm7CCkO72SAel7Davmuh6yetApVg6tOtInWzvKjHDKeMPnGsZgBbDftifc9yZCRhP3UFxYMOlVhGCRgw/GB551doFcJ/FMQqtg1x8HYlsph5bYNzequKGdTpac9Uq75if7mBMa9LmiyA2nD9x/4Ec9+2YfbWdI2cT3lAklqTi3V4svdTPPBtvGjLbL7dM74VGuqzZWzk6CZsnO/JQR9Gph0HzIKyIeFXxSVpSiNrEwz1MlM+9xcmbaBW4UU4eOTV
 4m+aZOB9
 3bQccV2KLVv+htkTVRJ0Ar1s3w+CJywSKBE5ZakeIXV+FJ/Ihzkur1mSepSC58bJzDi1roB8ui5QkCoY1bAbKQViDtUEjEVp+yhtMimWe3JgKgZPwH5PFVmfbmHUAoLePc7dMBtKpz2wbvSVcF0mUYTKH5AZIYW35OHNGhQHskHLX/+iBDF1TL1Z2nyQkNE6WUS5Nftn4qnTKCirsP5IHrrPqamP35O2gEaERVW8yZ+15xAsAwXsb6/xn/OUpMUOKrk3h/XX6KU16Eu5kqf31ieX+6nbmN+N8VZUinthJs/THDf5TDeNg74zau7CmmRdHKJ90
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xuewen Wang <wangxuewen@kylinos.cn>

damon_sysfs_turn_damon_on() ignored the return value of damon_call()
for the repeat call control registration and always returned the stale
result of damon_start() (0 at that point). When damon_call() fails,
e.g., the kdamond is already exiting, the user still gets success from
the state file write while monitoring is not actually on.

Save and return the damon_call() result instead. No rollback of
damon_start() is needed since a failed damon_call() guarantees the
context is stopped.

Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260915093928.3389096-1-wangxuewen@kylinos.cn
- Collect R-b: from SJ.
- Rebase to the latest mm-new.

 mm/damon/sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 43519afb9eb7..70a4b64fb8ea 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2607,7 +2607,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	repeat_call_control->data = kdamond;
 	repeat_call_control->repeat = true;
 	repeat_call_control->dealloc_on_cancel = true;
-	if (damon_call(ctx, repeat_call_control))
+	err = damon_call(ctx, repeat_call_control);
+	if (err)
 		kfree(repeat_call_control);
 	return err;
 }
-- 
2.47.3

