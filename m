Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C3EFEEF2D
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99C116B0096; Tue,  7 Apr 2026 08:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94CF26B009E; Tue,  7 Apr 2026 08:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C65F6B00A1; Tue,  7 Apr 2026 08:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ECF86B0096
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:04:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 140BCC2666
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:58 +0000 (UTC)
X-FDA: 84631628676.02.5212CEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D50CB140003
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Aa1cVZWZ;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563496;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsKzd/YsEilzksREcfAUWlMIOPNBqVpAH0cAn8LhN3Q=;
	b=NGfAvMfEc022jqqtt52inocGxOQOsyqBpkCurjkDtfcEH9soMFaw2tsEJlkwZZ2NyxjNvP
	9kQ6scoP+qtuMJztnORCClriOC5DnThQRr0FS+ryxyos4BFNCkiqj+EcyMl42wlWFAKVV2
	48hz8UzVlgL4BlSn0Q7giVxVyesVUGE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Aa1cVZWZ;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563496; a=rsa-sha256;
	cv=none;
	b=dUe+VpBdeiAqYkdLHpjljv/0BoJFYqqrJvsBOdAwmmmPfruWOx7sI3gECgzUHyfhdKlJiv
	wZEyf32CVBPucgXyyvLoRfBSqkP04IG+2RHKiITYlse9y9MRGCbFOwe+cMivcXJmsU9WIP
	pH0eXDHI1UP4u9Upsg62IvOUMmmAz4A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3553944712;
	Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12800C116C6;
	Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563492;
	bh=BTGG77nQT8TmTG8unDXgY6sdHQV2fBDHN+rdF5bOjg0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Aa1cVZWZowsjBlb1luy7bwn9Gucm7HWBcA7jgDvDIyGBNDaSNdioaf838oymXM9K4
	 qsTLKlyBJ2Kvx0T5V9dq1zwQLfXG10NJMjSyJtzWptCMoVteMgh8NXcWDmFeEep1be
	 KaoX6ErOixlAOqijh7ivDm06we0P85Y5TBUSejJrS7HODSKOCFBilsU1JzuPQU7KhC
	 EYe0F/N5ZmIs4IG6i0QbkRCNfu/fzlaCFR7tXG7A9Ai+8jy0t+RbJhEoVcRtAJgcvq
	 KI+0eQHoJ5kGo/M7F2Amf0jmH1H6Cx9gLQQWkYodbaDRWNftZ5lhOeEx52/7PRk0R7
	 ZN7u9F9eHU9KA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096BBFEEF2E;
	Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:41 +0800
Subject: [PATCH v4 12/14] mm/vmscan: remove sc->file_taken
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-12-98cf3dc69519@tencent.com>
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
In-Reply-To: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563488; l=963;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=YGvPokmG7KQWmukudycU/AK+GVC/fttWQF1dztv7kG0=;
 b=1P3aU29mV5XCLDnjvo0mKBZ+hcU/s17mLd0L4aidsBN7iUJ1+9CVAiATK3e59bQecehiQ9XdN
 hnlmm1F1OG2B4X2BiJVZdOspefWVhhFIlm8UhrAaVrGk33xXc/BuG+6
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: D50CB140003
X-Stat-Signature: bpzd8cueqk7uodpxfp4dsk7e9doj3azo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775563495-699598
X-HE-Meta: U2FsdGVkX19CrJ6P6uWji3uAb2FolCXAtUTxGi1hUlrJgbMXn89hHW1tC7vbPP4IjzXoHKHZxNegjkEOm6CnoWPB6XDis0Tk/SMSVYfEi1Pgz2y0wSa4n0C997Ikd9xK9LRMHLmFnWWgwD+OfdOIitK+b/6QaycYBt4RxRV9Pe/oJlpX3eJSaXs/TI3XUTR4Y6ycIPvCWxObrKM4y6BxhURLMZ4XzOtWoik3r/EVYdLgfC0DIrZq9uIXkk2eBvj3iBuEUhZPvU1lQ79ty9cMhIutj6P+MslFRUzE9GgJx+m/E3fBDCWw35idXrmCXNvYDoKxKCEFiKP93e+3tx2apB8FPljBerudLLMAbWTM/ytF4yHvE/jFfIxOclVEcK9ACH3vniQXe279ctyz7nTNXkUTfSMtwbTCVaXM0VTc60JjLSdxIm+Z7419Cif97oqK78ve60Fmqfc9L1isnjVFla/LtwiismJYfTBXehatWAU+JS+cTs2wCdaJvlQEO+DsujEARwLoYkuFrHgnfsp2J1uGir2MpoW9QFSknNuukrbPtwN/Ul0iJtXP/m44bHSDeQatttGc3mS6+TbjbBr9IwPC4g628NRlm2UlTeYEjeHHMw3iBQZWuxUAHDEyJv/aEg92zYKnTbc73CcFtNUpTZUfxKpo1M8AirsGmOOZEyBO2tnK0/PYHFCjKYCIL/NSWPugzEuImQXFGlzWg5by6jcifipEWFtqnhWK8NqxXjTZKgJkaJWrtSzbcS19GFri3OP+xm1t1i1sON5P/2XrMaTQVNDk+qEIuI9ExKxfiuJbIN/SygnOY+1y3Tn5l47pM0JZ5TLqarc3wPpCJ0hwj77hXz6v7ehKFcPlhXAC+xOGLoPIDkqZ4gQdBMM2mgD4ullpi2+2zSswz7To418YOncpWLph0EzXIlJfYEbbtz+vBNB58bGa3LmrxFowVbHBE17H2Fpy0RXLkFCIgiz
 PzuZOHyH
 QBiwJ8HkRtFg/kxzb2xocFpy3WVMlZ+y/llZYSwXzzZpA+mACW+MwlnDC4jxS2ZVi92i9+GLOiOaMX+FycQIMy9uDGSC8Mnzi6b157ZZsxA7idK+TTIaVnRSzJ3WUHaz6FSbAF9aCFzNOHE9AUPadXtYjXckkh1AWUChY3Oc4ayrgTy/xwDom6gh9K5RoDr7bf3QRIg9EOyjGLCKHWolmbFdGKLzPuwma0nsjON40AhcbHrI0Im1XKSTdBRuHQ4J7S9pprkyiNB9rC/XqjM74dUodhHV4uJIh0uDmN8wtq+/Ay9eu0XZw/3gIL+JWOsArWLHY+m0taYOdwgpZnpBGazb96GD29EOunYp4NjrqUQPYHxxnf+RgEELSS1C6LTOVyyRn/z37YC8F/5h/RFOvk4KhdRvgxDRBjuxtgpQQqWmU7/7lRcyPlgT1uRON416wOn2dBIHWxNq/rMo38JImfqn7n1MgqbaD8DPR5ljf0Kh78erpu5/RRTAmVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No one is using it now, just remove it.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 73b1aeb6c292..79e8a8e6555c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -173,7 +173,6 @@ struct scan_control {
 		unsigned int congested;
 		unsigned int writeback;
 		unsigned int immediate;
-		unsigned int file_taken;
 		unsigned int taken;
 	} nr;
 
@@ -2040,8 +2039,6 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
 	sc->nr.taken += nr_taken;
-	if (file)
-		sc->nr.file_taken += nr_taken;
 
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			nr_scanned, nr_reclaimed, &stat, sc->priority, file);

-- 
2.53.0



