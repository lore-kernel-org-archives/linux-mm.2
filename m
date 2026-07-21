Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABD9CC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 10:09:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F566B00A7; Tue, 21 Jul 2026 06:09:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876196B00AA; Tue, 21 Jul 2026 06:09:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5D96B00AC; Tue, 21 Jul 2026 06:09:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 553506B00A7
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:09:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA90280433
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:09:35 +0000 (UTC)
X-FDA: 85012361910.01.CFF06FA
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf21.hostedemail.com (Postfix) with ESMTP id 827B41C000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:09:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q935BXKH;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784628574;
	b=EtJV8aEMKluz4LWdZTuyueu3odf4oZItzKTtp+DlmwMokNoe/K61ovPMam4wzxw82OIb+x
	YMn7joJax2TKgvoR6TET7UJ0cx2+6YYhdXym8ZtPNma8c2a4Ratg6SC26sks2doahwbw/E
	v8DZjnq9XzgP4sQ4g6XN1wjRrflP9xs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q935BXKH;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784628574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rtXOsg2ueYVGRLW3PtOke69mX+SA5v4SjKosXuE4yoQ=;
	b=GasYithd781+IJlCUqhOSbPHDkatrdwfLi7LNejcM6JT4ho6RTDy6mE0jsJFiGwL+plNTI
	r9+BaxQs5AwSCBZZJd1ZJbeKxUdTi06+XewhGLak/dw27y2fU0y7g87PX72EqOOJqgdt5A
	hP8SF2rfgWMqvLC0TcZRVE2tqf7yfb0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784628571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rtXOsg2ueYVGRLW3PtOke69mX+SA5v4SjKosXuE4yoQ=;
	b=q935BXKHNaNk7Cj1nFZHQed1RmkLiDzz5keIA85fn4hJm5pJQbJciDxylDv2c9ZmtJnJ8M
	TCnhPv9od99ouSEGlU0OQUNDGTfcI50VVTvBgElzJX2ybjNcgjGbJpp3YKlht7eK7tRcYT
	Xtjzse3jV/ssqqPojYUZctyv2V6zyaE=
From: Hongfu Li <hongfu.li@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] mm/memcg: check kzalloc_node() return in memcg1_init()
Date: Tue, 21 Jul 2026 18:09:16 +0800
Message-ID: <20260721100916.76822-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 827B41C000A
X-Stat-Signature: jbo71yk3krcxcwmic6oy33ywbrkwnoco
X-Rspam-User: 
X-HE-Tag: 1784628573-407220
X-HE-Meta: U2FsdGVkX1/8SXVgOqbWvNTS95eJfPYBTZm3vK/SRaDIfIFiAQYJ0EIOTg5zcTdh6GW/kC1waaFwmBvLch4Z8zQOwvOwg6nbwISLvE8FNBhgq9eHaE/3M3p3luKgcJmv4qvIl5jb6VNSNHf+BRdFm2e/Ijkc92N53pspl2LTbfsjSSRmnHj1DSApetcy9CK0R//dIgs2V7U5ECOqtz131R1KirIzQZwQ/AioNNRaT4JdhmBRKYbcp8yA1OQMaVPZ4sl4OD09vTiUWbUh5ZysDUtoFt2/OaYSC+hx4QBUVLb36zYIFtRdFMGsJr0XNnzFY3c46XaYMWDlue2IMLIwOFn1VIVtNuZ8yqnpA3xofq6yFTP/xyehvGoONfBaqBnLhYo+9xgaxYxXNp6tyj/74KYI2ji09eZVLNyZ0x6yHrdWrNiKfm0EoNqz5Uarx1+iPhA8vgQiwPz5XbhemAgLDeh5MUGTFYdbb4kQngwqYLUD/qj/VX2IWm8E/b/IFulJneVFwZfL9NeuF9yvq0oD99QdEFhLW4wqYH7yl+gdtja7ohE84KWA0HSqVV6DwKZ5N+hgtx2gVtk/wtcJSvkkoEjwnX5EmD7x/AxUvY3EcbPXlnjCwbjvtjq0Roqi+TD5x1++oGwsmbsGsC2AwEEKp+WbRm0KybKoYTJRzcTjVfDFVVz2L61PJoaM2DHly4yZAzL62MUY2O2uq5BlzSvob/1FhDxCs5yQKEX9LtoXawFWg7/9FOz+DvT9zJcdXEH0WSjN1B9E/BbjiqkRKdsMa0n5uKnB4Z3HfWdh2GMUdDhaJkuULqQeoKMa1Co1JBenzeYEpqgEoq3sg+aRxenEKBFb0Ha2G0xrQLfxaCu2qxHSwIPGw0NFQAGiWtr43TgxxHnaEkKl/NkZCgwjHu2b0sY125/SRZ8okOttnW0DPWNIzWWm8gy5r/dDHDT+Hu/AEPVN9q6RIQ7OQEyeBq9
 S7UPV+xo
 oFX/B00z2AsRBvucoL5IMbRaxQh/ZyXOZnLZoOi49Mbf5IlZ2x0lMuCyn2ss/6TUbuUMigDM3mQA9NxgmksMx/ZZg5ViKxRvDoF+K2V/Tk/lZbsaPlQ5sNnJnUgT7lTsfx/5M7X1MoE5j1wA8MFKO+PJQbOliiQEnZszUJOWIdJSVsrk22Hoh2gDhTYRIui3cxVL+6ME7ofSvirp3K/66E4YmIqWSmrOVjH6ChkuuHYKmXi9JSaXapf26Hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

Add NULL check for per-node kzalloc_node() allocations in memcg1_init().

Skip the NUMA node when allocation fails. All users of
soft_limit_tree.rb_tree_per_node[] safely handle NULL entries, only losing
soft-limit tracking for that node.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/memcontrol-v1.c | 2 +++++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 2dc599484d00..33ea693c9281 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2566,6 +2566,8 @@ static int __init memcg1_init(void)
 		struct mem_cgroup_tree_per_node *rtpn;
 
 		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
+		if (!rtpn)
+			continue;
 
 		rtpn->rb_root = RB_ROOT;
 		rtpn->rb_rightmost = NULL;
-- 
2.54.0


