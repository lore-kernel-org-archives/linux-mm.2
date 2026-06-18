Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC28CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9141F6B009F; Thu, 18 Jun 2026 11:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4306B00A0; Thu, 18 Jun 2026 11:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765626B00A1; Thu, 18 Jun 2026 11:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4936A6B009F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:15:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C72CA40188
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:36 +0000 (UTC)
X-FDA: 84893382672.07.63CB51B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2713B2000D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z6IRoX6r;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wcaOZ+THlXEeNyxi5XOx757xXbcMuDB56hf+0XEr0ao=;
	b=W6lGZ7YlfgVqOT3AsG9wjouFeq4jdItwGCCJbzG5pTZa7VyCFD9MYpaX2DPoj760sHQb0c
	C/nrOl2/ghXT66RBkYhsHLIJvq9sYxZXDRzck4+6r5cTBbH8da24b3yV111julvCnd+uNU
	l9hFoou0+cRzWBVfcVhiZiJuHK8hMU8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795735;
	b=ea+bgEGBMCcTBGz4jipCNvEyKwMUiBbAY6HWdD06kug/U/mM2T7aPAyliuX80bb/NZ4jOZ
	mktpYzhSKgjVk2Stw65V7ItbgbWv5HLfQb1KAKR+By5zECwI80426PgpzJpzB4kGBsp34/
	JkTCNUI6L1CszQH2X+ljWSud9U/BAI8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z6IRoX6r;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8E52600AB;
	Thu, 18 Jun 2026 15:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66201F00A3A;
	Thu, 18 Jun 2026 15:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781795734;
	bh=wcaOZ+THlXEeNyxi5XOx757xXbcMuDB56hf+0XEr0ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z6IRoX6rTjCgJ5+uGS69LdhfK+neY28Ivn4UZDzL2vWa4NVi0Dlykg2xWYphkvxB8
	 tT2eSMjIOIztvoXLALn7GvO/HcVe7yLGkbWZhn3MJ4StKcNuzBx1EocyFRWR406FDO
	 iIz7jJjddEGRT6YFdYQuDmqx3TSOdEX9AeEfVpf9NeAjhGDGkF9Wd0GJXyVodbbA5g
	 E1RIr8LwsuA5NgsUYntqiolCepCwO/utlXPOPtfKvjaVIjAcJFc1fbEIFguZ2zF0lR
	 ttTAkQACdbsz1RmnfOuQAREcVkpssJSwZKvZQ+O6g1YsxXGXLnYk8Ae8Gs72/e673J
	 4eMyjGj38bibw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 8 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 06/11] mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs
Date: Thu, 18 Jun 2026 08:15:10 -0700
Message-ID: <20260618151517.5366-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618151517.5366-1-sj@kernel.org>
References: <20260618151517.5366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2713B2000D
X-Stat-Signature: 5wg1azmmhfajcy9hq5ck4k5zzdpuow6t
X-HE-Tag: 1781795734-814421
X-HE-Meta: U2FsdGVkX1+dqGVaCeGFRZZsW1dQ4h6bf7LmQ6CpGSY5SPNdeoXowJ+ZAWa3fMnrGW1gwubpdhoaBt8ayuKMqCDCKxp5XkT4RTI/aFJ2vopsPH1h7KEPKuRhe6H8ZvkxGrljXjWyHSOmsXUdQy2HUIUse0w+t4OY1eOrrTTJYwVPzgLL0OUjXcnN68LE6TmFZ1I77tP0dSu5aXbSI7ELZPlIG4hEToZiE5jpxrXhiuhNHCVhhMLpxM7saGJK+HpCgJ01UjjVsi+lg43Z/mdydTb50vV+vtbtOFmvbnl6/V2UebLp/xqtBGSmUNmrrGyDCFO145mkW8qz01tU7lDFruIll6iwppaT4Q2vcUQMvnezNQyCstWkZamNiKsJggBgDEx0uwwz2imzA60Wq5X74Ty6pL0jMEnBGSxrW/bf27YmOsq3+OEPDYK7MWJ/7GCK/xUaa5lP2QJroF4Z1sOhuYswU8G9k4Hf4AMWC6+M90MIrz+cuXZxa2UQl/VUM6z6+YmXUYNWF9AbV19aeukUVuEpZCv066vtUnc3QEHU1c08oTk8NmVkdoyw7xD0k5TkQjR1pcrftH785N+gzf6Ml93Mf8ySzn1JVH/F7MxfQquGLm8rwMI/jSe9TW7o2Y8n9Zj65y3lbgCO1v2b7ryh+yGuKwrypux2wfKF36jQk3xFSeB/HKhVGhDvmmw3ZGBu8/YpAquhWoKV+JEtjJNyhwtjnKeNFnwdPRdleMY/1Vy0209qPD/2TFlXY9DSvXgkqudiS3kcJTK657vdX6CYRJTVwbHVw+fEmoialDc3y68E1O7+7HEAXeqSLY4HbBb1NUuNmjRHwFY7DN9OBY3u4DUGmFWJRzDYlIcsaYiPZeQQs4oE2GdKUlQx/DI2sEV4fsl/IMkwU2CtZ2hhhO49o3DSlS5BGaZDukhxXvZiKsjEXWhHVIfCBCDebIWL4Rwmg70UqLZNEbEtboFbZ45
 t/rYIyfO
 0hzRjnNKWJcbzr7/eTR7goIvBXWaYWUciepM1gIAR6r0ozCVnaTLHdI9dTPn5ctZSjifVeLnpkCSYbm49rhY0lgTTrjwa5eKczawZHT7qXSplA9bl8EDLUhX4yhgbIXRlZtwxyEaG9OMbriyUuoI7WSw2EStWQ8fMRHfdu5Af0THVevdEaL9FX5FA3PMXsL0A76/ig4REspyETe48RZyXH930AavC42IF1JeZFsLO9MKPIjz68h1rEDmHHx7IoOk9VsAFgSw/FQWnSFVaos2DKCdZag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme quota goal directories by adding kobject_del()
calls.

Fixes: 7f262da0a30d ("mm/damon/sysfs-schemes: implement files for scheme quota goals setup")
Cc: <stable@vger.kernel.org> # 6.8.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 2b0a1ac36420c..306c1d3d357c4 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1465,8 +1465,10 @@ static void damos_sysfs_quota_goals_rm_dirs(
 	struct damos_sysfs_quota_goal **goals_arr = goals->goals_arr;
 	int i;
 
-	for (i = 0; i < goals->nr; i++)
+	for (i = 0; i < goals->nr; i++) {
+		kobject_del(&goals_arr[i]->kobj);
 		kobject_put(&goals_arr[i]->kobj);
+	}
 	goals->nr = 0;
 	kfree(goals_arr);
 	goals->goals_arr = NULL;
-- 
2.47.3

