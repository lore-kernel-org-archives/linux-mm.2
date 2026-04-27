Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCC49FF886C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B41F6B0095; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351576B008A; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17D7E6B0093; Mon, 27 Apr 2026 14:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0DB16B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89344A028E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:08 +0000 (UTC)
X-FDA: 84705117336.17.F2584B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 973CF40007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jYI6TOMG;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313226;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+R8Z0psR6KGnW8ojnI0+W0drfcmwwBcvDsVKOEPnYI=;
	b=m2MjUQZoVxunB7o2eeJxtqY0mjzEDIQPzh9zRvKUGDVnu+lp1kU1/+y61DqcI+h8uL/wgM
	Ubg1kL+/dGdE3vAHiiKn6AbrxPiVWw/oTntrdIXKHWVZGE5kTaq+tO9tnB+WpPICeneHXw
	LJE2QTLZ4wJ1KMmvglqIQVOgZe7PVu8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jYI6TOMG;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313226; a=rsa-sha256;
	cv=none;
	b=IsO/Qc7IU76yWLV9IFFVCv8FqX3F8NGdBmdTiUMNwdzt0ab9+/Ylt06NHuMPQe/HEDec7b
	vOd2/Y5cvbzlA3XUE46P/hB/+P9kM6eV/MFVYLKox7yHDjnPFZCBkCxOr4nassyC1n9Xax
	O50T8wkX8dvC5LBCiGlhVwKAMs6zlxc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C22A61141;
	Mon, 27 Apr 2026 18:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC8E3C2BD05;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313220;
	bh=rcBrmg0snM6JI0g903MCsIhVcJ+GJOO20n6dAbfvTy0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jYI6TOMG+JJTVphq6SzcRN0+kuuK17v6dp12rIVsEjkH8BoNttmLvEWpaXGRb82In
	 ZjB1f0SHkUDd2zQjgy6jQTllh5+N/zyHfv2dgv+lT5BNJdJCFJi6f5XZvFThcD51Eb
	 2yc/JR/3Bnhri/SYdwbmna8iOTIdANE7pOiTdttNseDTPnmKQhwoqC4mQ5BitkZ5bz
	 oavkbFV1qzlIRblwG//vuT6/U7gns3VPDymcsTOxGUhY8Ef4WKYUNH2j1Ec1qXt3Ee
	 jtlce/MVMlmAhDvrHEWb2WiT3hzUG0paSMirVziqFdL7VPCW+vdoynwwrB3UtBE2kn
	 urRZBIW8FhtxA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E26FF8869;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:06:58 +0800
Subject: [PATCH v7 07/15] mm/mglru: use a smaller batch for reclaim
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-7-02fabb92dc43@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=1039;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=REAUkY7P+qbS2gt7Q4kH3cv5QJxrLEt1oxBV4cmZIDU=;
 b=Oe+X0XFDd2tUVhSD10mdWdex1S7xloMQEpmYk/axubPPkIr3rJZfc/oUwWtu9DGdy5Qlw3ZEC
 4smVANROV5ABXZXUZVsrrMBRAPr2kqTe6kPcqS5wA9E6mPJw7w/BTeA
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: rkfrx767i6bs1xjegb5kzyax8rkk6xgn
X-Rspamd-Queue-Id: 973CF40007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777313226-681580
X-HE-Meta: U2FsdGVkX1+yHXpSede4LwCbQz5trtt43j/52QTPLeo7fQaYzOeVJteaU8Y6o7yK8IJMae4CQBYUnADg96vJkn4rDdSJJGuA2UbGf1EQN4ILQ89P6e3e4hkKUOVtfZDJzmlajtA6Q5yLcwmfVGQDwmsSu4JEeYvGgzu12HR4FdrePmnAD3W1y+0/KAt4a4/UXUPQZuCAdQxHTD3lax+g0Yf3rJYlsN7A89T500SxyemYdAzzzlentqTUW/fylmompwN5d93mnxTVxKMUrpurTVQPTE3hv7CBs5z2n0KcNfK8GdjJDBbZq2blQuiIi6d1da1ej+SANsnkF+rHv14od3u9Sd0xX/w4ZW/nPW7Vh9tverJ1npx/c+AO8TevKgswKHjnDvez9zSLBwimuIm8mQfCYuRSveA4jezDBCNT+V3iH35XTej00cTRr06yIdvhsBb6v3rE9zx4psfdil6YdfGn0kJvx6eXorK4ts47OuJHSMjYXuFgHShYtwqq4+jWHTxxJJbSSJK0FLpvRKW+OLS10O0EIMUQy2WvUvICLMOnqIgQpnrzMS3H7pR8mKFk0DdBQtY9pqsM1mOaO738l7HuRWEchyEyLPDN9ci9OIig0aT5z7iKXwQpq5/tuqQIaQkTSz9+M/iqQtB8e8xQn2TGKzW9pm5X+rTi7jN6zz2mzs2iqMMB/7BZ2Mtnnm35NCya9GXIbFGXDohhJYPgrJM1nvLKTH/r6paYhEf2szDm6GQCPQdA6p8UPP3USXkUe6hm57m+IFCy/3VXZLsTg2ou0c9r6OBnaz/DkMq1pS3O0SwI8PsQ9Usc70nBPhNPnuN+4y8nQ9qsxCcXKOFvJv38+y6HsB8TtdrO16f4cqauLzWWEBBPeC4WOH1yqTX9J1Np01FRuAPIgMljRbIw54cuZJVYIRUT8/LZFx/eDzUC0CRHVQgDbMcNGnjplLn6ztZdPIDM34qc2qS90ZL
 lpNgMU/X
 XhfDYIzyu6mRXFznng2z1Ft35k6sLYmtS+f85E6YUciY+aZHOm9laYqgWMd2+H/V70chy0z6VN5AE53cCFPTlsL12im+jTz/jfkNnQY0oBIP1B2T95StHDZjc2/H0aJUas20DzdBR53EwXox5lkg+UR/Xw4uuuo8zJ6fU9yVmZ0CirMHRRspkqnaJ3ySQePsRB2bzWG0/El0JDiqt4c9xz0ccQoJacUHTAMzef+K/DImRNyejqHRM01eS9pQR6bZlGaG48usPJbNrRRZQ+OdVmcyPMYOUCmGMI0f1ERxeJM+0NWhs300RszH+AcN9kQnQc8IfNmyN/y6BHcuGrx8xXU/7AObgJeSxtHh2b2QEFpWkkyUu4JT755X9OvqRMtxpRFoEEojwDWCJ3I1i7fzH+uVEVfCkUmriGq8dZ21W1Z1P1rpwqKS3M1ShO1X4wB0g/kkq+HXpUp6R6SmhUHNCsO2CX/yRFj7c8GPmBiwERkbLt5odMP1tcmtrFUXqQAM8EXOZ40TEPJs1zp6YLZ77jadrwi3VYCMtxfCtcorKZlGgYC/9VQy2Sl1JmSZwaFTdSMeV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

With a fixed number to reclaim calculated at the beginning, making each
following step smaller should reduce the lock contention and avoid
over-aggressive reclaim of folios, as it will abort earlier when the
number of folios to be reclaimed is reached.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ac9d2d4f8e65..2a607546277c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5007,7 +5007,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			break;
 		}
 
-		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;

-- 
2.54.0



