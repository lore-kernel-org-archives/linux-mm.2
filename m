Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DA31FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E4B6B008A; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1B06B008C; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23FAD6B0092; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1BCC6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C92C1C01D8
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:08 +0000 (UTC)
X-FDA: 84705117336.02.8D54805
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B07671A0012
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gTwWRFPy;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313226;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MlAYXdatOkYsBmWwDamZ3t+uS6MuaO8ApZ9DtN0OJJE=;
	b=JVjGHZzEQGB/8ZMH7PuzxJ8yb5Ub6neejyXt40z4azHCGTPvD5CPztXa5SiOaMpcX874kt
	5NXaMW+eznSoGdkBY095NuwtEoHXS5zlAPQnwbrfPnjBMAqw08OAJzZdSXuT3lDNDMREgG
	KJlfyxSGt671BnG0c3uShsvcWCk5o9I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gTwWRFPy;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313226; a=rsa-sha256;
	cv=none;
	b=q5R8FvxuvZAkM+qkV71Oy7odmizYJo2tPUEvtA+JdY4IjJk1XJWAUf16p/XKCAupvf7IGA
	ZPzWuZOgo6aLAnom9gscrzHFCxvK/19+Nm/KKXz4DwQNROILUsUMSNG6iWiZRsJZ2dFB5O
	av66/Yb7NYI2/JUDBNf30ltuI/crtE8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A1626132B;
	Mon, 27 Apr 2026 18:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA8A1C2BCFD;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313219;
	bh=qWXxnOnPKfbsgfdB3Dwc3NGWTEnlJEnolSGba/CZXrs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gTwWRFPyUOULpywF/HVBNioGbbTaT1EMkMrI7wQ5LfUYTpXNoRm8Hc9hG1apyWqm1
	 GEBgdjxaQ0EH/I/gzXRAFJZt7TpzESMoVvFAEIgOJqYj5M2IHwx9AzKfZLBpJF8ywG
	 8zv7E1n9hFesk28G3KIn6VGGGGKQXugnvmQu4AidfLIUKTd4S0t3xX4znOewyG9SKJ
	 0OT/3Hs9y+tD/q1k73uj6Ro131wpYGPnlL7kJx39WlWiJ6S15w6gWynJmdgkEpfFMD
	 Gc0femPldjpIrJrYRe09xKPXcCsJccggDe/upocV42WKpdqvkDaaPuhvw4LEycQOKc
	 /Asx3mLvLOpPA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15A4FF8868;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:06:57 +0800
Subject: [PATCH v7 06/15] mm/mglru: avoid reclaim type fall back when
 isolation makes no progress
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-6-02fabb92dc43@tencent.com>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=1509;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=AV4QwhcpwdcCenfYKd1bClgIwnLcHYhA5p31fWGzsBc=;
 b=RPW2xoKjwCBGjBsqPc3JbY06T1rqff5twu3k3Hrf74NgrDi5y3NM+KsVtZEFYncyjGQRyHYN5
 LBoBHSYdPm5D6qX7Dp4Tr7taNsz+8t35dxHiq4sIzFQaSK4wDcmyNdq
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 7yjm639b7kxmsc5znjce8uxxj85pb5ge
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B07671A0012
X-Rspam-User: 
X-HE-Tag: 1777313226-150987
X-HE-Meta: U2FsdGVkX18PVJWiEuvTh8B7usWe5DfuFyvjn+OtnwfTA2uY4zR8/U8+MEkfrU07DVTQ5mZhf/xD/gwk+LKh0QDXHSQhoMCFPmEFvfJAHXrcrlyquU2ki69fi6ZI0Sn4xNzigzct8Z87iRK3FYttCkaqScCBkmf8hNOGotVt2zqTnLC5G6jTyjdqmGs1ga+a+8N6nfg9z4egYAA9Pt+h8JNpgJDlWqk6yoZaz6b6YGnKQpgiGs7hIcSZRnUToBJcm+mWhYnwcfFyjO35h8PJCG82sEyXIfkQWbB31S1wmV1tnlGfvHxbj0961M2EUDiT3J/di+6q+qRLA/+6XtfL2pphjJnnc4RH6UiSSvLkGoCJ9RGIa6fRSd0DMQGjiLbQd7yC7zR30PVX7KGWcHQnSHnfoRDuFxd1r5QUrKRi+UZ4NTMw3bHTKVOkj3YehOWRcXorc/Gj3HmcTTxf3UIOhOXPJ87CZIOlpV7ofqaU4tattYb4wy//zoBlb8i4ByPB2q5C6lp3qml00RiwJM75osCWo5xrohQaFv6YTjFrpXAUupTcygBishX8AcckadP4zC5bZYUOGXs3JB/Eywjha73/dL4Z9TejpudiWqRaXwoydCOYGv41a3z9Rhq/Zx44AHSR5vgDzKxcD4ZwlSzems9j0FIuxIXY+0hRhwpsxM8h+4mahbaM3kKC/nCbWfnuryGHIbAV4ZmrSkqVENPn08JAfwYT9rrOqycg7x+8AxR/kkkG4HQIK8uVqCBnd0G0iZpukWqY6+dHobjLK9giBhEcdBXr2OX01+8AxEUs4mZ32CTXZuMtxxtC6tO4xozmVQxIev33vI2HRX0heNaQfo5My3zrnZUDJWOXJSuH16NOM4FuwSTJYUNgQm2JBvwSJBrBG5f7Kqn23qUTb9slU8VKyT/OI3cgSyFPuDar5QWN924RRK2PEa5CPK6MjQg5Q88jrauxaib1RGnKVk8
 s4XnZ6sX
 tvRGAOxGXBFa0tWay2XF1+a1an/oD1pEkxbZYHHmnunGO0L+R/ZveVUASJjD7s3b7q+xN/1AfKh8xPvTQybrmMCQ+8JfTf2mE1W2tgvx5AOghMyaeBP94brTWEl7pOTSzVTvzmp+LglPwvRi4A1/Ckb7Pk42vAAGvOp3mKpTpkFLltDrG83uMph7aUp4N9vMCMDcudThI5T1syxJruRVsXR/4R8vqpbUNyWeZDg9qbeTKX54n0+O5a6Chb4qK9VV0n7Vd/oUPtlMTivD5YwnifP/IMwErz5sjVyzD+DCy61j5KDEDxBg9f3xipSxBxOmSm6k5MjhxeXGFCGSC2NoeD/H+0POE1zd1MtZEBrsEbcIMjjkM3g2Vbh2yll/fv3wp4i0QCCrVaCSH7svlCcSFC2w9NgL+Qa+N81VvC50uQ0yNH72ZbnaP7tavGYuQisVhY2lJbY8pmYysJBVTBeM0yNIWt6d/UjGBJ1V0nfEoKXe3Jsk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

While isolation makes no progress in scan_folios(), we quickly fall back
to the other type in isolate_folios(). This is incorrect, as the current
type may still have sufficient folios. Falling back can undermine the
positive_ctrl_err() result from get_type_to_scan(), which is derived
from swappiness.

So just continue scanning this type for another round.

Worth noting if the cold generations are all reclaimed, scan will no
longer make any progress either, which may undermine the swappiness
again. This is not a new issue and hence better be fixed later [1].

Link: https://lore.kernel.org/linux-mm/CAGsJ_4zjdOYEtuO6gNjABm7NDxW0skzBFNRNee-k2D6VwsYEQA@mail.gmail.com/ [1]
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2dbd39e29dfc..ac9d2d4f8e65 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4817,8 +4817,13 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			*isolate_scanned = scanned;
 			break;
 		}
-
-		type = !type;
+		/*
+		 * If scanned > 0 and isolated == 0, avoid falling back to the
+		 * other type, as this type remains sufficient. Falling back
+		 * too readily can disrupt the positive_ctrl_err() bias.
+		 */
+		if (!scanned)
+			type = !type;
 	}
 
 	return total_scanned;

-- 
2.54.0



