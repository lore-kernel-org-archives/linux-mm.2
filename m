Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C468FDEE39
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 17:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CF206B00A0; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A3A76B00A6; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4364F6B00A2; Thu, 23 Apr 2026 13:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE25D6B00A2
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:43:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B11AF1202E2
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:37 +0000 (UTC)
X-FDA: 84690542874.27.864AA68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id BBE3C140002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:43:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=blwlRd5B;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776966215;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7PYSStYWFGDj2FhrgMy9OWvG2ek167R43sWIGufT4ic=;
	b=IAVznaFOOjDOtZf84pdRrt79MriDunKa0wUPil6/DJTcfjzhGGEGvwvhKNWSIPoQCMEA9J
	LiqLrRbmOOie0xXW9GGp4aIk+ZnyMB7u3/0dJfQm0lnSFgQaMTsGYYmgGEkLnOaHy4ebbp
	UbjgwoOL32+6BDxp8RzmhisYiTSSlXc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776966215; a=rsa-sha256;
	cv=none;
	b=V+vBZMBn3sxGFZr7CHriKWXKX9XzWYkdLgo3rZso/gmqmV8j89oG++zv7HkvrqOgJaX0EH
	lawnc/lJmchWefKGAESvniTUrmA1Ryvp1gK+eYVdNyMd+weNGH3pqeE6o9ZjsI49Y/0CQn
	OhsivXYhbgeQkTfxf2N5RIymGxk2liU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=blwlRd5B;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4869D4476C;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2644BC2BCB7;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776966212;
	bh=Pi8alNHf2oX9gUTgyBWhZOdVukmwFFf1pCLzb3ZBy+Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=blwlRd5ByOUWM7dWrD26xsO59924KoDfg+NdyyzCwW6CLBiqL20pkeIibLeA9w4mw
	 BbrJEhs/3bsOsJwcMOI9wfo5Qm1QrMFsOucJhyFmwA06/489rr+n40IvwssF3lksQi
	 fYG8SWNtZ5sRb3NZ9a3HrdnZUtK/o8kPBIHz28fZJ4RFK8Td8zWugPBUzPRV9oPgk4
	 3m5rgN7Ygez0H52XBeT+3g7zhvV8PLrJRPOOyRpYevNavemtSET+3e7slJGFN8/dwm
	 yGfjtrn87DSf09pv7V0hxlrisFxCXhhWBlK9C67NAeWW9P0z096sQWR7d/ZuDt1wYG
	 g+bk3C6Pd6Rfw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE54FDEE39;
	Thu, 23 Apr 2026 17:43:32 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 24 Apr 2026 01:43:23 +0800
Subject: [PATCH v6 12/14] mm/vmscan: remove sc->file_taken
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-mglru-reclaim-v6-12-a57622d770c3@tencent.com>
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
In-Reply-To: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
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
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776966208; l=1018;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=hbjcSghvUpKJ+Cq31Huf7ozCEGn1Zf5iRINfj/MTnU4=;
 b=9Hs8tFOS36fafoVOzNH2AmgLcP26/rJlYpL3c+JrWMbVYfCT9/cI2Qno4ktn6aBAU5LO1x+jb
 UGIl2T7iv9UD0BDWwjOYZfuWOcY58EynFCKnUzbsEL02TQ99LaK7DZE
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: nxp5mgu38z6mihaikyjtcug4q1bgzgag
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BBE3C140002
X-Rspam-User: 
X-HE-Tag: 1776966215-385821
X-HE-Meta: U2FsdGVkX1/fNiwccF0VLMyRGqyv2MtAjxfzn5OFGzXEBEsiumG+md7LxSK/emKKSijo10KJelbUgwRGnPTTiKAU+tzyLlYYiLtMJR6CiZ9xepneTAaDMNXp062lwfqVdNWbVdwlm3LYVeyyKys+9hx2WJvzv3hxQ23m8d3BUKMrUVbCUHppvaxhV9JFc/UolRCAI3lJqs5x2AOByWUz2TEzTaW4+V/SY4uck4rF4Y1JxZiAT8cz/qpijWfvJjuZvkok+m1zFbRP+Uqu5ZDpo4dy4p4jKTaDA04QRE0wsbH9xhOr6PtcJfqw3yVnFCM3ptusvy57eIXam73BnqKl761N4vzTLeXLvkCwutQ5arURuKLeED9LfEX/n4zXQkrEzWtRduw3wffxdr885W/ROhrG1uM9nUbQhGNeH3c40pPhgbBjiIH5bS5dfUV6527FgS8ll8OLlw8iWvRQSbhL7IO30dGpiQAPGTJ6MgxTsHg/bG8JvE9hDKAyShc9ULH6ns33dbllfmxeU3t/s2pzJyaNqKNcMXKb8XB2pObIQnjxZlZM/53nYEkc9TgZHaTJIuWKMvOaG/UuBI7TvpQ0CCVZgxuAdA1JQvD9nImfl99RCIuargAEic/LmX/dIppkgPD65qgyvBvBMO4l8sTKshcGa3ROaDYEd8U4exyIikaGYG3hwNFAairj0KxhFoLCPMWTNHLhLF3chBKZQKs363Ftd04ClSIDb5B7AYC3HGZkhOugC5pRcOESrmt/l+21mF3OoqL6LS5QSBTjpPRpQ9fKFsMaUF931IgwJ6rJaFkLcFc8RfQZYz/qdaCxBqtS8Zs6cvzy3EC4PZI5EucV2a8wGxwbqjma9QkHZo+ZBmrkqMr77QiS97vjCt5xfwh+nyTin7sNL+3lXownNtU2ORLXvuJhaXgp1ANOWNu0lE4GKn9tlPbcjtxzK21zQ0xVGhofPHOItDNQNAiCfOI
 gg3bD+xl
 gbuFNQk7mQA2OMwPHGbfrIkfW9Pi13uf+XfLmhUStE9ziJbKj4AtcF8KGuKrhBIegMUJRVZ2OUq7ydXmMlwiBSZIUqgxuvL1JnOq4ztzJxJh0seceRzPd14uAcNmA3huSeW2njSGXCcGTBtfCFN5tCaGKflN2nnCyIec/3/E8hWTWs2Za91yUjFghi7vfoKfFXGt4KyaQIZvyiMJ65uR/anVfQe2AoeIhkK5ULmTm1AcVKsoBGd75EtjpIw7maGFrqh0rQ+nbTmAwUENt2sc42HqM+cQrDWRR3096LAErjAzfuKfDPu4YDQPfQfbqTM/xLybqXOAKevsONVNsgU9ULMbUH9reVoyuuNhu2U20zpFLf75Dh3gDL35lN0EY4XLkg3Uk/cJuQ55WCEJgAvvvIVkIF6KORqxvamh7cQ325rPhb7BSReXyJXuPU+ckwiJuWeOh4E0U+8uQY1fyYFS4LVO9OJ8qQYC0o3GTdBozq/PNPHrYM61p3A/YdvAX/XFdHD5IWPKImgSsftkTlZVBHLOhE+O/sXADXEYfpbos6Grdoobk+CxaDCr8NXcO5e543qpsog3ZGQtRdtHKCA3difhl3w==
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
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f6cb1a4b6a31..7bec0ae51465 100644
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
2.54.0



