Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F8C7FD8779
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 01:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE616B00C6; Tue, 17 Mar 2026 21:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F786B00C7; Tue, 17 Mar 2026 21:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CCD56B00C8; Tue, 17 Mar 2026 21:16:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0A3D6B00C6
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:16:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE432C1C31
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:16:43 +0000 (UTC)
X-FDA: 84557419086.11.A039509
Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8F249100005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:16:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=F29JCSOQ;
	spf=pass (imf14.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773796602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SUl7xz/kUSQqXnKKGh/x2QNXKHhN5Wx+n3klBSX56t8=;
	b=kww6IbiJW9dK6dRk1p3+BIORvi7cl8SLkQsPVfZMGtV9/AiL2JPGrx/7ModJn4VTnsKGzn
	lkCnhpiLoU1PoAN2+iP+y4pPJeb6ume7XsGnUe8fn/ou9+jxM4yca7q03ObGK4Gv71+dYz
	U8fJJStXa2Eq4WfFVnxg6X6LE5RjNVE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=F29JCSOQ;
	spf=pass (imf14.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773796602; a=rsa-sha256;
	cv=none;
	b=8YlDYgKSxR7Ci6xlwSvlN1mhdZmPs6yRjpasgf9G6CYq/0g9ghbp7m136wHONYtppuIlHS
	WDn+rIPR0D4NF7nxdOGj4B6mIEuKz/LTKFX3IhdRw9MzNPuvZoTQxdt7Kj10iEQtJLJjml
	ZFk3pWbdI94Z6BYMOCgZT4tOWi3FlfU=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 62I1GBap066683;
	Wed, 18 Mar 2026 09:16:11 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4fb9pn3vGKz2P3l1g;
	Wed, 18 Mar 2026 09:14:41 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Wed, 18 Mar 2026 09:16:07 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko
	<mhocko@kernel.org>,
        "T . J . Mercier" <tjmercier@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang
	<huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCHv3] mm: remove '!root_reclaim' checking in should_abort_scan()
Date: Wed, 18 Mar 2026 09:15:58 +0800
Message-ID: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 62I1GBap066683
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1773796574;
	bh=SUl7xz/kUSQqXnKKGh/x2QNXKHhN5Wx+n3klBSX56t8=;
	h=From:To:Subject:Date;
	b=F29JCSOQ+gNJuiNuwVPmL9qCZMSaaAM9fEJe3lrZ2VWJgqYQhM7lbGBhV23apVME5
	 sNkyNSnbI9dq/64iDqZZdabSBZXzjnRVE5BtKzEpqs7JUK56VMWejB/WJwPlaNQr2G
	 v2KUVWKVraVnn/J8pxRINZRz/1DdQYpDu31MbAZTr6xqOheiFdmpoQYPq28uPnH8qO
	 QlZuH5ASfGHjXDaNaSIaIOCeskPRqqEWZvpVzoPNAf+zHOppWmrK7naLcWw5XrTTan
	 40HYhBjBVQbVpr44coh4n4Vig+2sJ4U2QD/rfH6nhphuGOeLihq93aY9zYGJtdBbn4
	 Lx28XAs9g6cxg==
X-Rspamd-Queue-Id: 8F249100005
X-Stat-Signature: oy7eq1x5upjttfanywy635fbggucucgi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773796600-500707
X-HE-Meta: U2FsdGVkX1+qX9DahHkXm1drMRwufamx4Nn5bsz7mWYCIGCQtf+LNq1Yud265BuuZ+xQ5Wj4X85liwqBhoO+4G+UwGV/HrlKa++B3HPNyRQuOQUljMmjwlXM0wg5CKdrAmj/kvbebQo7bRzYGvJmbuJRI91n6GAeqT4DbSewnWQDPZDFrJ9Twjf1D2sZi2IaIKzjBbf7zJoznjnoPSkQviZEc/F8WuDnAEqIe2ccutdfrIjE1qUQlMaTsnp3qixwksiQAZsRn0lC5W7bw1VQRQz6WHS90ORAknEuz0NOm7DXgQGVpDt2+7YmYxpe/ozPzWCj2ZMd8Un34aG5vkZQKbVJ1xuWZB2lsvqOnNC35UkQL7o5Y6FDx4gn+SyAHMESYBI1mMRDlJkaivnk+7LuL7J312hAadCM32CusAvVfF1DuAql7CpB/J1d0wQYvLOwSCwLVxFbh1uiSUMI9mZS2UWS8Wj4mhuGBCPBFCICyo2NCjEkbbrRIBjynj3ewn5GIP6DK2AK+MHLglIvHxgVDjnGj1AijGPaszhZa2vlz2nx+0nbDqLnGV3fBODv4iUPSrdZXzu4YHbNYu5yN2QH3wuGtu27iShayUVtELgaOqE5U1ztdguHUJrapjetzVslI+3hyGjY7t9ga92U4gRpiw7F4QgvgwZV3DMhp0CMHL0iYqQu+bz1grf5yD/2vf7fWTQ2NFIJw/9SUSxsTAjsKqUL7j/N1QGXB3m/OClhEF3J82yseRXlC8rpr+XMamFp213/qLxsvXAGe5lHXj3D+xDGMB4602AQq9uh0dvW7uJh/LrnYNfBk2bA3lIyQiOMA7yspm7mJa6NQ3+LR60xTATBfCAZh5h3aHfXyuuWcRbqzYWwBHkxjuRoDptas/yXiuQJke3gBCpnCg0tweglDIet8cun3jsxBbqHaFS2trEE+jIMrz1BQtyT+vxXULi7xGezayfKoMpUasjWNvj
 N1iY0nSb
 15+gv4JK6A+Kvw4zNkeq9ky9u8C6etg6ZR01u3UHN32Gm6v11r0MrIs2TBZjX8HBpq5D8T8+WE0jRkNN5ZM+NfzRIW8ltoAsJ/zXLUUnHnCLm8QAPmsJ3FjItrTWWiHR9L6EfKhcgWmPbzo2ofrQ0tG8qLznz8I4L5yt0JO5QPsjqb5DffNORNYZAAYAL1lpxznO3Aw3gSOfaMIuLKtv6WUB0Z9G3Z7qNXqEUaOPo2rHLosf3SX3Nrl0XN3oXeYO3h8xQvrcoTGdyLoikzfF80K5wHFwymCR2pDaERdWB2XxuFW9Fwl5wRKHcjo2UAb2qSWGgYMS+KKuQ2UALWzylBPf9krVb7BleOeOc7sq4hdeJmRNWPdW1e+SzLc5z27sxu7CVgJ3q5WeeIxwiA41E26dg8vamLLR3NA2wmXSFlqVa+arDcsYHDZxQzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Android systems usually use memory.reclaim interface to implement user
space memory management which expects that the requested reclaim target
and actually reclaimed amount memory are not diverging by too much. With
the current MGRLU implementation there is, however, no bail out when the
reclaim target is reached and this could lead to an excessive reclaim
that scales with the reclaim hierarchy size.For example, we can get a
nr_reclaimed=394/nr_to_reclaim=32 proactive reclaim under a common 1-N
cgroup hierarchy.
This defect arised from the goal of keeping fairness among memcgs that
is, for try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
!root_reclaim(sc) check was there for reclaim fairness, which was
necessary before commit 'b82b530740b9' ("mm: vmscan: restore
incremental cgroup iteration") because the fairness depended on
attempted proportional reclaim from every memcg under the target
memcg. However after commit 'b82b530740b9' there is no longer a need
to visit every memcg to ensure fairness. Let's have try_to_shrink_lruvec
bail out when the nr_reclaimed achieved.

Suggested-by: T.J.Mercier <tjmercier@google.com>
Reviewed-by: T.J.Mercier <tjmercier@google.com>
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
Patchv2,v3: update commit message
---
---
 mm/vmscan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..10f1e7d716ca 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4839,10 +4839,6 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	int i;
 	enum zone_watermarks mark;
 
-	/* don't abort memcg reclaim to ensure fairness */
-	if (!root_reclaim(sc))
-		return false;
-
 	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
 		return true;
 
-- 
2.25.1


