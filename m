Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E44E7C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1DDF6B00D9; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2986B00E6; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23626B00CE; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5A56B00D2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:58:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2E7840344
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:58:19 +0000 (UTC)
X-FDA: 85164591918.17.83B95E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 065D01C0002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q+wPWbMJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788253098;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m7RKFhM7DKt8Tz328qe7qgNoYXTPWXPrwSWTo9vCt5A=;
	b=QpLc48zWoaGsvaNOzpzRstDauD1dubOV+bvICgH8FDOUdb9sxHMSbS+pcJSKIFkoXIopPP
	55W/9jjNKo6fBggnb32aDMCQME/dmFGAAoQhn4cuxSqNcPZnLY9F9hcNf4zYOKlkydGx2y
	Wza0kSQC7idBV64YO5jyfATnb6SL7yc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788253098;
	b=Ao6/L54qkop9BecZ4fXAMS7rp9a6+aKG9j4KcRI8MkrFo6UzIySbCOwpvfBMdjtYexPLQM
	1iTUfqm3NzbRbQTfRTA9zO06cFJ0UyB3Kwb7vpoH1dFRI+ELVX1SX5t5SoAIjXUyiQ4swT
	YPiakVcH39UvYrom4+ky3B+aUgjsAjU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q+wPWbMJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2398419D8;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA886C2BCFA;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788253096;
	bh=KlUxJ5Oj10Jo6f53V6E/JY8gDtVIZbewdVdCgVfLshY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Q+wPWbMJCk+meNviZObyUyWu0S1q5aygcJ0vIBA5TP5zHaOm4TplJAiH4BpPFySeO
	 jXDscHzc0zAOG/HMcwRWXD9XpaWU93ZFF0tfmWiw0bJ01q7Uceqo3IIq7xd/WZuxB9
	 2swdeXcjeKwomMGwC/lknTFwPgKJfI7c7T+t4n/aNYeh79wtPAmtVgF0ldq5pYhaXl
	 zghGJbbDc7WYzAwYaqBJsvT/po3TeYmWpCJJ6/qmBVrboEDpdyYxkxcnC9pRBO6LIb
	 VMVqTb+uDMcXtZ4aPdts5DLvfNV9kFrqi2EdAlj0GaZe/2w3bF9Vh9tn8+amJ8MHri
	 2tz4YIm78FBEA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B06C61DD3;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Tue, 01 Sep 2026 16:58:00 +0800
Subject: [PATCH RFC v2 1/6] mm/memcg: add a helper to kill the memcgid on
 offlining
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-bingfangguo-memcgid-rework-v2-1-8edd7f7a7251@tencent.com>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788253095; l=1251;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=3jIkwaCFjFq8QjiGq9DEwjO0Gl2r32Hxoi06xqqEo54=;
 b=fFy5sTfWuAG/5jEHRJE44WgGDDn7U5jjh+8LxOBk/3EumTxFbZ9fB/Db50YLW6h5pywsH36vd
 pgSY2DJLajRDGHE5DuQDgcZ12R0BvZh2CcatUZ1nsRPAiD576IfDQcW
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 065D01C0002
X-Stat-Signature: mkso3pgqodcn7pkfyah5joxpzju6i1ju
X-Rspam-User: 
X-HE-Tag: 1788253097-662259
X-HE-Meta: U2FsdGVkX19Tsd4YiK32XCG8wm6W1XBdoWDbSUM58GFfJ57xh8/bvv5EXrdMQPCtsqz1jPo9cl1JXcqhh3v0FMEsJ6nvVKNvh5FaCRs/+zep4vTihNMAQKQ97CJGu0aJb/QEoOQcs3kOKYvtLUaaoKjheH6ZRMik0WfZ12WVquAqClv9bpkRyzgc9Y21AkgfBi5/9OCeUdpathxlkfCOBdnqxL+IsjwQm0ZrHUDq34L+1GbAl5ifuFjpL2RfidxuIq7+TRoZDjUMo8iXeibzLYvhS9b977/IFakpBunhfDXyOE0W1T0dn1NRmQMmWebCLZylOdgruk1BVAW4mVGF9uI5YGT3skliv9gxEUXHYZA32xW8yeAIofjI7MwQ3mx6iUc6nvid2WJz01fMfk0DX/MLSKoZEo2tOaw3OowbVo3K1gwpCPI5OeCGqGpJLTl4gckPxPLP3F4kko2BFRMPJJnVGcb2Vnhj0tTl+M1Ce6kvGom2Pwh5AdpRmWtjAU+53TC5ISNW60jN1MIvE3S0SCETnfufw10At3SGMQ0uiVHff1RFyyDW54HOJJtRLL6fcznR8MH/2YxTFFlhemA8TYneHu4rNKJpkWEP7bJDaJa+XlZJcj+uw7NAjeJPi2WkSLcfqf7LdPe+J+Wms4CRRP4rByrjIPvnGZwIGFDuOntzfw9k8xs0LuQAM0TOPuVHBeq8l6Q9uJBQQYMYb5cwsSSJwsranNrS/fgq7YTNIRPCamsPDBHxyxNzfR8OlYUdIOrIL7PQyhMdWt3/Hjq1iVStWX7OQ7bq8IBZcHNwXyRExOceZYYie4qlpTtY4We45ez573K848QR8NsSlVWsnaGrA4DWywCAfmNmWvg1T5SgqtZAn/6r38ZiX2htadSvLF5fs5cQRBffBGQKxGP/Bm+ciUnSsQ73oTDAyETFYmsaxKC2kYtqLvbT6xtoWdpKCdNBYaA7VegHyq/KmIj
 9zFAoCy2
 pvXEf0oQwcTd4i+OXQqrkoj72VW+wW+wcxEKVKT9+BEWL7AxuFCMIye5ZyAto3CF6S5Q9nivjRYb0LyG2TXJmuPYkucv+xO/BQiaaWkU619s2uuuFYwg9ukvbO27Dn5a9wq2HAt5sZX4/1B4osFhixd0TvmdIXTYPsgiPnC87xGG3a53VnYYrNhj1laAVTcqwexi53e3/WuESZRWlXAK7iCqRw2Qnccg+I8eZjXy52cZ+xmrQpxb/ff1KEBZv1Vsnuln5hK58l14lpTJqdi+ij5nj0Ued/R3fclfbiUir4WEP9VtEz3ojK6vf41MKzYQMLyzU9dOc6J3uKOoTvMdg5nuRASTG6RcqhbEdpdoZTs5+JLWlag6hosJcR3WLTHrgxK91ALFMju5E1dpqe62Tob8WUynmFZXegKoNfXQxDW1UGT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

The online state holds one reference on the memcg private id; it is
released when the memcg goes offline. Put that release behind a small
helper, mem_cgroup_private_id_kill(), so css_offline() reads clearly
and the id refcount helpers stay symmetric: get_online() / kill() /
put().

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 256b68ffca70e..31cec9dde55f0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4048,6 +4048,11 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
 	}
 }
 
+static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
+{
+	mem_cgroup_private_id_put(memcg, 1);
+}
+
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
 {
 	while (!refcount_add_not_zero(n, &memcg->id.ref)) {
@@ -4385,7 +4390,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	drain_all_stock(memcg);
 
-	mem_cgroup_private_id_put(memcg, 1);
+	mem_cgroup_private_id_kill(memcg);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)

-- 
2.43.7



