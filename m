Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F45CAC5BB
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 01:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375E18E0003; Sun,  5 Oct 2025 21:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3266E8E0002; Sun,  5 Oct 2025 21:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2630F8E0003; Sun,  5 Oct 2025 21:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1736F8E0002
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 21:50:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEAB4140310
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 01:50:22 +0000 (UTC)
X-FDA: 83966009484.27.56D6738
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5206C180005
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 01:50:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of wangfushuai@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=wangfushuai@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759715421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=+p89JIw5kFvyuxmSyAs4llxSV4DxJDc5T+48F1M56i0=;
	b=VGI43K63Kv32tEbpcUdWVGI3RIshdwidQGt8VoTtiC7tkm0d+8B6FPAe2at+bi+M55Itc3
	RyBEr6wCdNlTvJClgFnba4Ceqt2aelJAhbcZo/fm+7proWGY711OkAvMTtdRZBA733uWRA
	VMWm1ktt9k3dDTTYTz12bia0lp4NtkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759715421; a=rsa-sha256;
	cv=none;
	b=AlHhAGyx6bGwshB3fhR4TY1Fau33kQlRf3g2yqWLjEXdjXPBYgmL6cF4ZZx296sVhNfuMK
	VmXZ6JsTi3putBn1ZdeCAEo7QNkw1Zmc0/JI/vMg19t/mhjosemDVBDEhIn1i3U196bL4c
	YSriygBB4Za1VRtPlI1W7nIOWx2VMxo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of wangfushuai@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=wangfushuai@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
From: Fushuai Wang <wangfushuai@baidu.com>
To: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <david@redhat.com>,
	<mhocko@kernel.org>, <zhengqi.arch@bytedance.com>, <shakeel.butt@linux.dev>,
	<lorenzo.stoakes@oracle.com>, <axelrasmussen@google.com>,
	<yuanchu@google.com>, <weixugc@google.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Fushuai Wang
	<wangfushuai@baidu.com>
Subject: [PATCH v2] mm/vmscan: Remove redundant __GFP_NOWARN
Date: Mon, 6 Oct 2025 09:49:48 +0800
Message-ID: <20251006014948.44695-1-wangfushuai@baidu.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.127.72.16]
X-ClientProxiedBy: bjhj-exc11.internal.baidu.com (172.31.3.21) To
 bjkjy-exc17.internal.baidu.com (172.31.50.13)
X-FEAS-Client-IP: 172.31.50.13
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Stat-Signature: pogwcix5ag7dyziuroobq4snftqtknj4
X-Rspamd-Queue-Id: 5206C180005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759715419-287778
X-HE-Meta: U2FsdGVkX1+gb8f7ZJdraYGt0MM8A6BzYJhgiV87DYR+JHzLK8f26KIcby2lbmMBwTXq34wAFfA76AWYKfFK+/M/Di8vS2KY1ZgoXemw/hLq2ZjpvdtmKI0ph2a6Q9rA3VzHi6/6fSNvVFXbLM0Y8jC36MEbmmuaRdVe1asvgSFgIyPzwqowdggTrY6nLnvqZHft3cJlE6qfN4OGVzN1obOuVqpbBVihFQK7ICQC+TS9aFNKVVcDYEIrYrbW/4H15cAzdY93SSI2lJAfaq+gg/hr/YChJy+/GfRiex1t1NwzYMW4V8D1hwqxt1sah29X+Dve/xmZvt0jc0DWdsvrWigRgPE45pzZd9YSjN/xg1xbu6LK2y83f84q3qxJ3jaICW15UosrcgAcgrnD/TsMlLtX/ReMIwt57h5Baup+nYuPqRbQcKjb8sm0vpekG6vKbjiBoexwTiyPcrqDTtqEdbNfza/AaPump+npIb/Lk1e9mTsJ0S6JuBOTru0TkOBxS4YVEh2T4rGH9giMJzcfDtGppJd8Uq4VhPP/79MIE1tHP0ZdJTzd70WTLmuJrirSfw78M6h0EY6gmIvvkuB1Z8TelKzL+NTw+9ErJUMqY0A7NyPxm5sgqcM9qcQbgJFIK4SpM2VBE9FJwCelUhYrkGFh5uSvWtqZhTFrhB2M7NLzsZPhNwY/qllL7WFTQpLsIiHG9Z3FUbxTeK1tChpuPYyEX3bYjOidSZ1eIiiJHT5qXe69mK6mM7FCLe5NWTdvXe+LcctkfTI34O1XpaLaIneJqLYZFQOO5bAbD17SJLs3uYPr6ncDPk8gec4YjQ8ftxE1j9BJa7Zsv3T7pZAlLk8+xNogiIrq1hrUlXJx8IpgP+5snhcGe287zFkEi1yh2zd4YRVs+ZXDBvSUfHuAXcGnp7ICpqN8vFN5h3qbwofX0xTzYjg5goqXVxQDrq0ZgJeHXdrO6Al0gVwqg3u
 N1sL4jAw
 YoaAYYs1RJPGaMaBQnsbsGfLBNO9NyBY/lSihHE5Vabw+IRPRRDq/4VwtQWD2jzXCFcWQO1iY+cgZO8NMY6curbpElsdM3qi1/qS/n3cZqev/4/3OrEgz9a6xdUqPihyMpBgwofuaLQ806D8z3eLjygVmGa8IryE2XxhimnVmQWJCvT9Thm4w8EKcJxr/DsQYQ3cQq7+7z5ICmIwhiqwqzTJIgbUMr6po1qNCmdKREldbQuY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The __GFP_NOWARN flag was included in GFP_NOWAIT since commit
16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT"). So
remove the redundant __GFP_NOWARN flag.

Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..e7ecf3b608cf 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1054,7 +1054,7 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 		 * When this happens, 'page' will likely just be discarded
 		 * instead of migrated.
 		 */
-		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) | __GFP_NOWARN |
+		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
 			__GFP_NOMEMALLOC | GFP_NOWAIT,
 		.nid = target_nid,
 		.nmask = &allowed_mask,
-- 
2.36.1


