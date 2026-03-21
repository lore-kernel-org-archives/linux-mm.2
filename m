Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C19C71094489
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340216B00E9; Sat, 21 Mar 2026 13:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319EF6B00EF; Sat, 21 Mar 2026 13:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206966B00F2; Sat, 21 Mar 2026 13:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D72A96B00E9
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:54:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BEE8160456
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:54:38 +0000 (UTC)
X-FDA: 84570820236.27.8BE9646
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0DD80C0008
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:54:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QPBqAj1U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774115677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDNCLuRvpHJF3j0WD5/7wrOb9uLvEoDqqVsxha8lYJk=;
	b=jHx45bCFXfHZ8+mRSw+iQyp5KNkzuwAW2tWfDEYXbqm2wmB4arpQSKP+njUIbn4KZpVajk
	0e99v2klPjtniYvSCPsGinSZwC5GGBUZzVGyhmrKj9+AI8AwnbCHPO7Wak0Hju2V9DgqfD
	1kBP9cxjq1sWcFkqRRFm8FELwvLP/Cs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QPBqAj1U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774115677; a=rsa-sha256;
	cv=none;
	b=M3+UnJBQhiU/9WvcgQaYyPB1jm2iQ4o79/79p1/hm6hjzRiEYPmSrZU4fwnmOxVLSO/30r
	L4IBkZLxE4YFzJWxIXBFuguR+txYj7HyuHVWqko07FDQhvgj8u9ENbFlMLMWt0GJEONpLH
	RKScp7WkpJ+YAcWDux5aTWLeogAKn4E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 85A9F600AE;
	Sat, 21 Mar 2026 17:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E350C2BCB4;
	Sat, 21 Mar 2026 17:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774115676;
	bh=ypF4xKp6F1pbIquY3/unFTj0ZaJ4QsmqDevrapmiqYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPBqAj1UYUg3nMWYne8Sya+MKgu4V7EeGKLthl0o51iCB0NAPgs7sQgaXh4Xw8fds
	 2SU98NaNJ6MzubLEcUwGsVNIrEl9fomH6UIR1GjgcAr0qzkjoKQCVU3SbfxYkY2vZ/
	 uf2IwjhSs2FLSovNyLMfQUDal9VQijGA5yBmyICBzrzdUi/jhDx/WSjrYUnfLhsc3c
	 D0pPtbGN+xU9+tIGrC28zdpiWLbAFzGViZZ1ZbQB7/Z96r9ZVuZAw9JzvYt0FBTEXj
	 82ykqjvPVIW7xc+YYHt+LiyuD28YP5oqnjg/0115RkfzVYi01+0926YFH+/QpJMhFr
	 WpIlklGViaYsA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Law <objecting@objecting.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 3/3] mm/damon/sysfs: check contexts->nr in repeat_call_fn
Date: Sat, 21 Mar 2026 10:54:26 -0700
Message-ID: <20260321175427.86000-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321175427.86000-1-sj@kernel.org>
References: <20260321175427.86000-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0DD80C0008
X-Stat-Signature: ehr4nwbretjo9fu7id1sxkzn43ju8647
X-Rspam-User: 
X-HE-Tag: 1774115676-449535
X-HE-Meta: U2FsdGVkX18F9WTgrx0nsGgc+U4o7e9dwpieYAI7sFDvJQJHFYludSxZ20iyBrkczJRjhQH0LzXv2nAVhy5EFOTtijPovWSN480yNZpU6dcrZamFK+hEXfisdqZ63QIccYjxonH0KX1I7GuMhflJYW+Bq+E1NQLvbchLTw/TM/ec9WdUO1S1FCFMpumYwdaT5eQ4+LYvThtwh+XFOdQBBhempqSrV180/7qUhoHGUsJXMr7ob1KVE5PzYcbowPoUi49RJ7fMjV562PaI9YHS5uPI5o3DPJrJkIRidoUH98ike0USTLpGwYokQdLBBIOBrmDxSv7gaHThHuBI/U1NkAi2B7XNSI0fipEbyUeDEcBpDlTKNlDEUJD+eGk8dq/+IYyYLLIReqooRNtlcUxvoA04Yd5wiSip8EVsZUZ+PqeLPuBaSyX89flliuPx03enKGjvdyDAKAyuoVkJlsDJYZs5fEIXzIPmH4L8wpZFvRNqzi0ePPsTgC8xNs/bxIMv/JKqx3dAXp2XRxPHa+kN/8nYfOcy5DOHheQlFBgNdvKlgoBTMld7W7CJNFT+s+I/xlUQVTCjN6716zksZD0Xomc5avNvTF3UoOCP3VtrfgmxtAjmHw7Sc8SgXNG9WRLhf+BX2jIqw1nVYp6gYX9mieTJIKawvTL7IqRRaXxSHW8RK8ANxjSa/v8WW2MZr+XYHbAcR06qy4sjf1ZHwqJsuhJF7ofY4ljxxLbtCM2d3pOt/b5KZW4jyoq1VTj2RVoCdvEy8K97P1FKU8v8Y3ZidH8gBjFiTV4bLgxkRCFKOeXnzJRFGakolU4PmEZKP92Z5NO9jlz1gNbij7enJePm9ejJTJBcknn6R/3hleI9EljmO3FQB/gl4K/FX8NASB2O1UfKFBjUDZmbT9fRhhY+HTUHLq14aSfPKIUIFemzJDeZqU3m7Pr4owqDvFD+HNnt9EbLQkCoMuJ+CybEuM+
 hGzfDWn0
 +Av+/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Law <objecting@objecting.org>

damon_sysfs_repeat_call_fn() calls damon_sysfs_upd_tuned_intervals(),
damon_sysfs_upd_schemes_stats(), and
damon_sysfs_upd_schemes_effective_quotas() without checking
contexts->nr.  If nr_contexts is set to 0 via sysfs while DAMON is
running, these functions dereference contexts_arr[0] and cause a NULL
pointer dereference.  Add the missing check.

For example, the issue can be reproduced using DAMON sysfs interface and
DAMON user-space tool (damo) [1] like below.

    $ sudo damo start --refresh_interval 1s
    $ echo 0 | sudo tee \
            /sys/kernel/mm/damon/admin/kdamonds/0/contexts/nr_contexts

[1] https://github.com/damonitor/damo

Link: https://patch.msgid.link/20260320163559.178101-3-objecting@objecting.org
Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ddc30586c0e61..6a44a2f3d8fc9 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1620,9 +1620,12 @@ static int damon_sysfs_repeat_call_fn(void *data)
 
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return 0;
+	if (sysfs_kdamond->contexts->nr != 1)
+		goto out;
 	damon_sysfs_upd_tuned_intervals(sysfs_kdamond);
 	damon_sysfs_upd_schemes_stats(sysfs_kdamond);
 	damon_sysfs_upd_schemes_effective_quotas(sysfs_kdamond);
+out:
 	mutex_unlock(&damon_sysfs_lock);
 	return 0;
 }
-- 
2.47.3

