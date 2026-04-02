Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 005ABD6AAF9
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACA836B00A0; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92AEB6B00A5; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C2C6B0093; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 13BFA6B00A0
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C62665B86F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:47 +0000 (UTC)
X-FDA: 84614514894.20.ABD646F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id BCECC8000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fMIVSiCQ;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156025; a=rsa-sha256;
	cv=none;
	b=tiHLGkKF8o6olPQW+DMPtvmQBoNemwWTP7uW7EUSC3pC5WOj+h9Rkmy7jzvVyCpUmkDNbF
	afv2aNEvr62UBNvhTWeMbtJzJZ/rjzTPY070tb+QM5XOEt91T+FaZKt05xjNTxD3/SSFVv
	3iGuYR8zIbhqWfBNafozSrmXEF1Rxdo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156025;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIyEVjRp/8kPLwyKo0s2UUX3EoThbUVf6myMX/Z3txM=;
	b=MThG9uIdIHfAYAVPfnoqT7T+w86RVUSPD4bchV57Hlqn+UKAWQp3kNKAjTdPKzDUKJmmoB
	9OKPialRljhy41jv8I4h/6JAuC9Zw/j0e0ODpcLLzuYduJLlTQx6xvF21Pr+i65SynNRp3
	tr9qn+EJgAT48c4TK9m/t6LPFgg3cs8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fMIVSiCQ;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B1584453F;
	Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1665FC2BCF6;
	Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156022;
	bh=C+b0qe8+WwLoSOukrhjp8oUBTkwqOJFRbwKbGr2dnNg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fMIVSiCQAUklaISRQoCqFzL55chab5pSI3LhKi4fMM1oFPqf/SLCFSmX3BkVmxql6
	 YJ6MzgwwoTfT9+nPdi/DVx9SlJkOj2yImaxzdcghLNM8e3zFY/zXsnSV0tPNmVafs2
	 6uKoKG1bXSpjE4jvccYjV67/U0yDnn2gKCpKvytpQD99dyGO3N/M1fXXt5EeqiOres
	 9nCzBsVmTu9uZy6KPRzfuYjMX8IrFus5eEugVolMAlGa5ewIsXg1P2sin618FGzwqM
	 dQ/4zHWOuMe7cB8KOvme0c9dhTjGqqKJv+IzTHrdtfLhtIg8nmNaSW3EIJYd9wUlZ0
	 0Wa0cC/ME0nBg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C85AD6AAFA;
	Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:39 +0800
Subject: [PATCH v3 13/14] mm/vmscan: remove sc->unqueued_dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-13-a285efd6ff91@tencent.com>
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
In-Reply-To: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=936;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=e26nyKYLbSKDUtJliGN08CbrGD9gSe1V6+IS9z4KclM=;
 b=6RfwFUsNaOQsJCmIZR9jBEebpkVMA+ugGtcyI9hhtGMRsHXd3FE7z0CUa9CobREdLXlVjOORk
 jAEcEvC2s1ZAlqkMJ+7hhu27i8/1BUKAQstv4QRkUW5Bs6OLlS9LiOu
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BCECC8000B
X-Stat-Signature: c5d91edrhypru96gkytmuiengdn1acqo
X-HE-Tag: 1775156025-537028
X-HE-Meta: U2FsdGVkX1/wLgPaoHE7nARd65z6yoY3mGPh9gk2RH8jUYdmYhiV//1NEc10PRgoFVQMmPT01HZp5um3ofMoPa4RPY3+sixz8vYW672aOqjy/agaX3NO9OfcHA4JvJsFgVl0FnPIbymRfXwNraDqcRA/CqHMiYpM/a89xb/kSYz0J9tfrQRJe9ytm80oKwP1RgxvNRuTwQm+0T62qlhbw/wQG7ngC40G8yyomjdWsNJ0uqP6d+2VtevidWYtQCd6TnhNsRRQN6dnFEFMYqlo2yXScg18FS+vuzEwMDLeuBNv4KuiBaaoySzeBwnZ74wy9O1BFLk1ua01CzK3YJvBjvJQqZoV5jzV+dZJfylwA6WDbrqJ4sZfXPM+bEOaL39rg63xhoyi8f0wlqE3i3S39a/XxdEcr2azM0x4jCjwwCEK79iLQ++v71CSXID2LTxp9jL8tXbAxvvTlfZq+sbV4GBhTjO5Na60plurcmvxNe1Jl19q0TRcQcKIbqeEHhhhMO72olVawMb7BAnxstva6hbs+dUla6ya6poY2S+dHZNAAZg5+Mcs0IFGkTcJvxfyWaohoctbGmfVEcLU20/JNiQaB1xA15pade5kN6fvHdUQz/niu4xL4BW1a2iKo1k1SEMwnGNilYtHXcdAUKREgFevJMYNcTv562FMGFC8SwSRVmhKmXNI2cpruUvb6iiXs1aA/9Zy9QS+VbN8X8YQgTF3OYEwRbsnV40M9wcvQCYStnVTHO0WRSXHVOF80muntKIqrg8PHHxqkpVcxoGEhEyQbfBYjdzd+3ZQL4QvsiOsv4mDDdzUi2L9xSOZ0/Zu/nZN4LAbrv/fVAI+6f1khJpR71oxqy2nNfx6rJ2qHs+hH5+Z1caBdlWvFo75Sf6ujDbLNO8kSotnk0dWUIlTnqcMLUZkrK0piQX7ChCxVOil/yOesLFvZWciQqSMn9+SevWKIfmmuBqaLMd4DQf
 pgCXnW6e
 Xx1tD/JlZ3/UWgkz0rq6hfjQRcEkXwBE3HaUwOqZYBUoQU0SptV4p7gCOHgWG7bl/BJgpKOrzaNTGqyuCL7pFIf4l7KlQAT5h8DtqSabre9GaW4NPrv1McgLHLzm8FTmjtD6l56V06ilwh3DxamaiRkD4vLPjtcmODNmxV+FMS9cfbhVQTFQgGF5yDk7FIFePxOfZ2BCdcE1facpLwKLNxNHOVTZlhBOG2cL5Eg0rFeVhCtTwTXUdx7Hn3sBWKMEuzTOJBGKE7zq/gqBk5bmYjKVfjgKT8cWI8qSAIrRyWv6r0vtzTof7U2YFZsoMkhijhMon+TZBBZzyYYCwvMiGbxyBoJ4eUvoPWzVOoy+gcQt3RLy4khVUHf8AzU4HxQZJLXVN5+8/G2oz0RREO8OQTzNDRz0ail2FjfxfEJoFn68aNXnBC+v8cpQI83vMp3DeeWP3Ozzvwxjahk5WdLuSyoa9LUXzcmEHhU5hVHV7DtI8ZlkFaCXGPhPYyMsrn3D133SSbTv9Dn1i3m0V/kRk6L0NvLBD1Ea0u8sAliZN8p5RX0ZF3KHShYNwHPEY8J1wUxRA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No one is using it now, just remove it.

Suggested-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e4f27fd22422..9120d914445e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -169,7 +169,6 @@ struct scan_control {
 
 	struct {
 		unsigned int dirty;
-		unsigned int unqueued_dirty;
 		unsigned int congested;
 		unsigned int writeback;
 		unsigned int immediate;
@@ -2035,7 +2034,6 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	sc->nr.dirty += stat.nr_dirty;
 	sc->nr.congested += stat.nr_congested;
-	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr.writeback += stat.nr_writeback;
 	sc->nr.immediate += stat.nr_immediate;
 	sc->nr.taken += nr_taken;

-- 
2.53.0



