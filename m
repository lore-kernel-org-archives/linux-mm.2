Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91823CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 06:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B86C96B0088; Mon,  8 Jun 2026 02:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5EB76B008A; Mon,  8 Jun 2026 02:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74B66B008C; Mon,  8 Jun 2026 02:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98E566B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 02:36:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37F931C26D0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:36:53 +0000 (UTC)
X-FDA: 84855787506.07.75EE021
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 785C720004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:36:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VWSgcw7O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ruoyuw560@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ruoyuw560@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780900611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mbMuCvI13wK+vW6caoDnTbULN6HvH/7zcFjXyiZbrkQ=;
	b=ps9lyWy5ff+uWYx81eXn/+SKTU+tDfS1Q583pjcDAHWL0cdQbq29nKyfoXcJ6D57P+2lyf
	3YIHFCg424vovP5571EQNmPrTqQEqNy79wugjzQqcxYK5JvqKLAMgUUtjBGRtog75zVDWa
	WcjkIcONl02Vdz799fZHvgKz9R9Xgv8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VWSgcw7O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ruoyuw560@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ruoyuw560@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780900611;
	b=hdEFlF9ACh0IOpKVIBhbTmdBe4IqEQoWAZ2MaK7YwD+G3yTELzNaDM2Kn5g7OAT8o9+FMq
	NO0Tl2cn3hdVqofU92MauVzZZyxUsroVErN/B4pHpeHXBE6K18sAqvaIhCzqqRNM4Uxdls
	YLJY60yoOXUMxLQznvH4sCFRBldUrR4=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2bf3781ca51so38279675ad.0
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 23:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780900610; x=1781505410; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mbMuCvI13wK+vW6caoDnTbULN6HvH/7zcFjXyiZbrkQ=;
        b=VWSgcw7OBdkg2zRTA2c3eAQLx+Cb/Zqj2PzMJObCvh8awmpRPQ2Ynp/SAf3CZLwOh/
         4x3Cb/LS5Z3qGJD0pFRdkuMkxq0HhkMXI4UC3bFh7wyOJmgmBZUEe2Ywczr9srP2sbeQ
         606lpgRmf6v2maDfEFlwz17wo79e0h9NKxcD85WX3EO11qg9Zw7gqdZPmyRMjQUt6XWd
         9JXBG/VPiFEXCyzZnaRjq5ytt611OUsmA40CJbxREiGtdP/kwolZfchZKV833j1RGQX5
         BVDqEcs6UyEmcO0JYeuaoIOBn9D717fYsXi9UnAYPEPRoHgCphU5lXHSKQXqxuVXkT1A
         MhsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780900610; x=1781505410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbMuCvI13wK+vW6caoDnTbULN6HvH/7zcFjXyiZbrkQ=;
        b=n5eVkD+IQTdZDXzTUYTcSD9bjfodzHm3UvgqsaV/iYtrae7tenGEBf8xQEUgEcHnX8
         F9yO3DE5jyPPqQ6j1tdJ3QnEHnhdIcjTedwzK9skysXaImx8/komkuxxDLXnf7mazcIB
         aSw3Z75qTS/lUBS2ntejBjnyxCkDt8EcQe+QO8MTL2fUMUUBx26Fx/6Ig0ltudpivafn
         RY12bREBqvH5fmkTlDN6eHJM3aWu7/Xbm32KJHKf/87IgFOvw5k7+UiYmbY0GvxvpPQ2
         DCPQ329Q1ZqfvQ45v5WRrLsaEWzyrOA1/CO574abFY3cIizTnUwGky6HkuahvdjXjxzC
         q3Uw==
X-Forwarded-Encrypted: i=1; AFNElJ+fXKlUqfkU9E0fseIyihEDDc4QoAFxNFFWqaftv62GEZMk5JQYqGnImYeo5b28V3r6QYDJMt2t5Q==@kvack.org
X-Gm-Message-State: AOJu0YyNWQuClYl45Jd7lxfpXNcDym43pf7b2O67zRhtI07wVOme+nfI
	VhAwdObn6G0cTKOdadAQyEMbMq5FH2uycWauWjIRxFjZogGiPt5mNHQo
X-Gm-Gg: Acq92OFy5wdwUWT2U7snxBZj6WfIBKeRthnNpWxmNvdOzO76wRTjG/myakmLKZo8vkv
	gyuTw6ZVuiqgqkWMWqV5BEvRV11NZj2FJWcYxGtvgfNSJREf1nsJ2wX0yN+oixGB3NFE1hZupg8
	NWFR2sBcrIFpr9K5Bu7L+PVn4vVY+SwMW5kXBC58tZq3PftbHbMS6ydyBo6naH2zzB8+bRsbqeT
	r0/LPtuTzvOQNsVQwhzVwSt7SBK1YmYobqCnWCBk+2yWCFBnd1IzJSx8Y8pI0htx+GuiAKaBHEH
	A+W0743yo6nkKOY3/MC59LP3WN+5Ifq1bzB2TJ4GrOlxmDidZqa2ufz16uU2j3X/fGAojruageI
	5uNacBQ+tGuLy53lO9hUDYg2Rb4Ym6H7U4OJWbIFeKvF7w7588FFq1dhgFu+iiTF9wiiEzIg8Mc
	2YG501cFT5kV+HbYbASDePS4xh9ulS34A0dAluKzTXbPDCvCVLTRpM
X-Received: by 2002:a17:902:c946:b0:2bf:281f:19ec with SMTP id d9443c01a7336-2c1e8208778mr165217985ad.24.1780900610193;
        Sun, 07 Jun 2026 23:36:50 -0700 (PDT)
Received: from haichao.tail057a43.ts.net ([2001:da8:e000:1206:9a2:954d:67fe:d9c2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f84335sm168839725ad.19.2026.06.07.23.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 23:36:49 -0700 (PDT)
From: Ruoyu Wang <ruoyuw560@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ruoyu Wang <ruoyuw560@gmail.com>
Subject: [PATCH] mm: memcontrol-v1: use nofail allocations for soft limit trees
Date: Mon,  8 Jun 2026 14:36:44 +0800
Message-ID: <20260608063644.39-1-ruoyuw560@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: nhjcmedk7wtcbcuww6bh9n7fdunzs473
X-Rspamd-Queue-Id: 785C720004
X-HE-Tag: 1780900611-780842
X-HE-Meta: U2FsdGVkX19Ei4O5ODjRgF724jeISz3ho73ILh86hSKBb+7SNRqMKV5a7VO2v8BO0IP3wJSTOSm32xz5coDuxhG7nl0eC3oanqvoSMFG8GGHZTmZgIKI+g67iwuF0zM6XdiBL1zg5xHU6RIvmk39HJRT7iQngih4Zutw0Y98UutCUJcOpy+ExFA+wk7+pV5WMHEwMIkF64J5pQOOr+SJF9SEy+1IkvL7MXJaxTQAT+4uGohoc+TTapdUqUUu/IbJqKXYxJHyLwfQ6DUNYsmPWbXHJ3kzdJ3EAwIGepc4UMFMaKomczlSJ3phgjXI5/CMBmNp24zy4u1Le2g2y512gaEiwJHryo20iCWCpcygDcK27ziQvqzZkZk+jPKvt6tGgyYIxIIgiGv5/NmjWmqINU7WmiWWr/zEnvB+V+rYvLJSrrx56QmiTAI/biTTEDuefQalkRAnHXN/6wYcG/q3hUr7Pfk8vdMqGKzxSgMfC1yTRWM32EeuKgtcFjyBM2+1bUz5nDtd3FbtDmlchK8LiNeziFyqwiMM/CM3O0vbEN4ngSLUppR+RTD6jpy4fEWf8AVk0XKlXwWpdDpQuOkwT0ciYGqd8DjPzMoOR7lPdPJqsv6it2Dx+v4HO5IFIWWxm5bia8tmUPdFWjmWibsifpgTT/H/X0ymfUukhIOBSstCBY6ruy03uFGEMUm0e4GpwkOJjv0ZNkHauSwyF1swF45YMnpofaS4z5/3pBPfz9UCrr4h0ctkPET+Zph6J0hGh7rzd+BkOZEfERGOm0r/ZPjl49qKE+cmMaXWJ+/hj/5RXamwM1GGU194mrMJaCvhthPpWvBFTKlQTah3Op1wAIL2v+ZPR5cuVxowSmW8fShbdjZ/8tP86Mikw0iF294Q+uzxSatG/XmRzMZejv3PV4XJXDBUTUEQvGCVKfMT0StQeiaQVsdMKs1pes2w0AD5UaCC9/hhsWOTleE6Qiy
 yuWkScQy
 vY/4oDbSnv0DTyd5i9tM+hvrJIadaJXKNdA1XoCk/NZ5J+x3Hvc3beOXYvk9VIm9CqOq+fbU4KM/F4UBTNo77LOyOXaWJqZkEuBQrlTJWI7Tb9BvqOTY6SghC1tcHXD1fPO0ifQv5iWERvE1uXCak/GkTT2RmkJC49I5fYIQAukbXg7bBsMoS+ztVjhRarzmXJSxF0vMTKv4rq1VynpjikP1ut1gAZeMws1XewDKVANoBFP/XDg38lPbMnUySsoXiVIFAW5s0uOPZh9BbM7drbr4TVPKC3Q/+9BIPrfPi+RE6otiXX0FpQXsL7QtWTotC4mwvrwZsIviCT6sVIi0c0XQBCiwhAvEIOIzdHywcfbIqbaakV7sa/Pbcbh72a2W6NgmgMMe6bM2a9Vw95rw5Ir6Pr4sKH5Nvsyp78C6V5tVMrrnL2SNJBXpaO6iwlGCnaPsExw03/0ASKrLSG3g5rAHoamjBnRkWcxQhUk48gphZBBY0dmYqMAoX67ZPfK2RjYeA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg1_init() allocates one soft-limit tree node per NUMA node and
then initializes the returned object. If kzalloc_node() fails, the rb_root
and lock initialization dereference NULL.

The per-node soft-limit tree is required by memcg v1. Use nofail
GFP_KERNEL allocations for these init-time objects so the init path does
not continue without the required tree nodes.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
---
 mm/memcontrol-v1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 433bba9dfe715..3f41a15d8a8cf 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2246,7 +2246,8 @@ static int __init memcg1_init(void)
 	for_each_node(node) {
 		struct mem_cgroup_tree_per_node *rtpn;
 
-		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
+		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL | __GFP_NOFAIL,
+				    node);
 
 		rtpn->rb_root = RB_ROOT;
 		rtpn->rb_rightmost = NULL;
-- 
2.51.0


