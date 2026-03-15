Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98AC9F30288
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 21:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125086B00D6; Sun, 15 Mar 2026 17:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F37BC6B00D7; Sun, 15 Mar 2026 17:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8086B00DB; Sun, 15 Mar 2026 17:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 889F36B00D6
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:00:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4EAEA1A0D07
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:28 +0000 (UTC)
X-FDA: 84549515736.21.4E5FFB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9BAE3140017
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H4UCZ0nv;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773608426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qG0FiHq3122N0rcYK4oCE99i2nUfs/WX8BknwBpkd04=;
	b=q7fMsk23r5JKr38Rl5iH6Aanha4OTSsgsNE5y2s5gp0gLclfrIgYoZKTAQ55a2/uRtY2hS
	1zOQ0X3Xe33oTRmFg11sbsv5AjCAsp/5fvc4cCfpg6g0V1OwBHhoWY3nXtdVBRRWA3KR+S
	Ni0xgy2zyAay5xqGa8eRwZOhmGvYmDo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H4UCZ0nv;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773608426; a=rsa-sha256;
	cv=none;
	b=Y112SDcpGVCVKRW26qwI+nlcgFrniCqdkMWe3qFB+VdW6tHrUDm5+rqsMdyxOHRQ3sYbot
	VW9LpEt4LhTyfKkLa21tCcWrGZg6L5LYz5MtoXz7SvknMxv2ce18Z4IrI7YK57m19adIFj
	x8qe9JPQ+igNrAXxlJC6Ni+mujGxql4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 96AD244723
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEF3C4CEF7;
	Sun, 15 Mar 2026 21:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773608425;
	bh=O/0+EEFKC+kJrViTx1hpFrUcUp3ITetgY1I7Ly2ASvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4UCZ0nv3gBgH8YiNIiRnB2qR3Ee9C8eNMYwibb6/8blLcIw3t8PCOrL9Isdi/2R9
	 rb8aByVgzVs2R5FADMzd1/m6NkxE4rfrP7s3fYiEWCmKsDEffQHiMDBJFomoxcZ8Y5
	 RZrMYxOensQkz8KytCvJtzwsRSLG+7JVnTeT4kLPkC28tGtjgkzcEgyzJl4yvSW9L3
	 o3uLy8DdNvD9TLyv2ovNm1oVLKMsmJLIApQZyrBCu9TylUd178/K5wlY6jfbrL2owW
	 SG85E/IEF5217827ZHWe/33YVaXNKpvwKOjiPgH2HJoWw417Kq0jYQDaCh1cEWP8vr
	 W1UfcZPSE4eww==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 09/10] selftests/damon/sysfs.py: check pause on assert_ctx_committed()
Date: Sun, 15 Mar 2026 14:00:08 -0700
Message-ID: <20260315210012.94846-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315210012.94846-1-sj@kernel.org>
References: <20260315210012.94846-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9BAE3140017
X-Stat-Signature: awy4tabujumh7atbfaz1yrd4gh67dpyk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773608426-690811
X-HE-Meta: U2FsdGVkX1/pf/9DlQoNK8OGAIHsAoH50WL6uwG85pTzAvze7zKt39UDpkTAI3PEkT3n7z5Cy8GD6la4DdeRmXfXBdRecHBk86Hy2WXhFPa6S4WlGXM9qmD3r7LOtLh4UluVF8ubOjxCHf4+/zLx/LOqtUFdhK+y/Gmh00DUGGsC3MIihdDYtb6ZMZOzEA7DGFj7SgAb/90xChZ/q1W6mZIewhyl0lrXUN7bo4CRfMPZBO/PVlqoZleXx2z+uc6wRzIV8Liz133bZfEN6M91EN4TjneHPfzRnBpDf2PsCYwY5dkEfrjYSna+NWdxriUkA86JGDff785XgpyjVlAayx8qQvdngh2ZZAAVW6YG9WPpHiuyBTPxquKD4zzmknAuonGXMNLODVk+JfKQEei7wGH4df1J0DiPi9J5pdCJJvhieYVSWoSVWK5IFz+zBlqmMomvRwHmK0JHaq2hd0MKVvM5pdZy/r481ITOck3ETTn+gPZD4FuRXfg3Z7aIbML8Yj1OkrvQab3/0oczTY/T27fPinCzwVUanoQW3GIbRGHoJcSmC5Dl9xh8szwo0Aqv/mlTkjnPnoKchG518RX72tAoOz/sPHEYhBsnBjLlOiOHsi+cHsr+qlChNQf9VkeAWIXqJpxPeRL3U5r7Aq/LXvuDtNGxZP8+MTa0wwAGpWJ+JzhNN0Psd73Vw6P0rPtRc8T+wv9or+DRKYIf1gB0TGqoo056Dc+IM6CeJdmNemmN9Ahh9CXV/+D/CKC1JEyatvcIopzX8Y3lzVRlKwkCHvVQCIMH6Fz6uFRQDaeKjZbSceP8ScaphaRXeZn+6FETLu0oCvUQyqb2vMOgSykmn+BC239flG77p4u178je4hA4FQ3GtQTZ2qengK9EytZEculeGy/fc1wFpQPTF8gXmplmkMmorC7y/UVEjaF/IXw96Erux4YM+e6PK8Jjo27jcKh3IMjtJWSJb+smfFn
 g8ww216W
 +u2V3rn6geGF8mCpOjAu4ULv1xbGMa77jahCm0n1/viiVQwATD8N6ngTMa4r1UALxEyApbN6Jc9nO8pB4n28kj/ApfxXzkO/UcVdAsKo+2FNDdmxfm4hnnlUrgp8v66eQJGDUMAniJQGOFZDooSCHnimt3ISpm12qk1B5jkCLcaw8Iw7gs8Gsj1hdRGdzx/ky0sIL5saIiVEufg8E8kx1f1kAEOzFfVdJ9GGdM/yz9GY5dwRHYIYesS8zdvePBVjuv2P8WEciFT41L8/EDQw47UZvKoZxhM2tU3G2klUrxZOjgaXnVisC1WAvm2iojpkrD2slgEEbCaH2kIUH8ZnNPLZX5mEqP7qabRpntL4JRv4I1m+jVXpbv2BNbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend sysfs.py tests to confirm damon_ctx->pause can be set using the
pause sysfs file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 3aa5c91548a53..e6d34ba05893f 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -190,6 +190,7 @@ def assert_ctx_committed(ctx, dump):
     assert_monitoring_attrs_committed(ctx.monitoring_attrs, dump['attrs'])
     assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
+    assert_true(dump['pause'] == ctx.pause, 'pause', dump)
 
 def assert_ctxs_committed(kdamonds):
     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-- 
2.47.3

