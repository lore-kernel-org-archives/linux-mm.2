Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E459DE68166
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 10:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105806B0005; Tue, 17 Feb 2026 05:22:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 089476B0089; Tue, 17 Feb 2026 05:22:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7366B008A; Tue, 17 Feb 2026 05:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5ABF6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:22:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41BDB1B548D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:22:29 +0000 (UTC)
X-FDA: 84453559218.04.09C4BB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A5DBEA0008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:22:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JN4oGrsN;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771323747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=L86+dLSEMVRswkX1Mt8iSSrHZAdfomDMKcn5PPgAe5s=;
	b=UYM/iffO4ebTrueopEbbrdWJNwjQv+fiVBlQgse5wKvPtFrkgqs7XZBGZjvVEp+5XGAW2R
	95BAITegK6zfPx8kOo8KKXiMZM3tS1UhKqs1H4Ad89IYhzIIqpcJASbvXtbVm02tjcjvEU
	42YZ+5hl8KlLlAqb3kgds3HGCnx/UlA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JN4oGrsN;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771323747; a=rsa-sha256;
	cv=none;
	b=sQN7OJLwZnI9aDpaegjg1Sat/MCBa11r0Q2AvbubYAv0TFrOoGDw1aqVRsptb5gsD9ohJK
	n5A6HIelftqbTMuxfkOHZsZyS31Td5VspnzN4jqJsyuPZGMi3rqqDZHp6VxDlaIizc2Nv1
	s5iMZFyB8A6jDIPzzhT2m7Kps3oyzgk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B143F43354;
	Tue, 17 Feb 2026 10:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A930C4CEF7;
	Tue, 17 Feb 2026 10:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771323746;
	bh=KxpcopOEjFHbtR+DyqwMi+1SkvRvWGCf3bM86EXO6ew=;
	h=From:To:Cc:Subject:Date:From;
	b=JN4oGrsNn9tt1IBZV1a7NMTH0w2hXVGF8NzYzPgeXQlvbsUa3GT+iK6jYZlZSkMeo
	 lSO0EsAK/TfusTZrfri3dj31puHGu/eIM66Ms+9Vz4P/lXfu/WHDkJ3BrWxvkYNFsY
	 FpzCy/DpQwu+ZBG4i8istj/yqUnh1rASR3Uob08J+lnWIkkZW4/IJqYeowFpSKr1jQ
	 73VG9wegzrJff3b+/fB+OzD6IctykbMUlXh7Ipttvv5jTFFqNN2Unmp9MGycfuhN9B
	 w/qL3bXRYq3quS0y8BMbIPHQ830W7sgULrUw8x5nQwqOZfNsXzEw4FEcwjO8xpx5Bf
	 0RSVdjFvMoNBw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH] MAINTAINERS, mailmap: update e-mail address for Vlastimil Babka
Date: Tue, 17 Feb 2026 11:21:52 +0100
Message-ID: <20260217102151.10425-2-vbabka@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f1qmyj8o5fewkhzh83xw9rbw91jp4bct
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A5DBEA0008
X-HE-Tag: 1771323747-260080
X-HE-Meta: U2FsdGVkX1+EKHq5OKTpVtdiM/qOWBTEC2bcN2r8K7gOhaN1xt+GTgebRs1ZqoisIHeIhrOuVoME9Ob8pDd4pbkQ4AlHPavHbr7lq9eQQle5m1tIe7S5gqExSwF5Sd8FdqziELL7eHLMH5nRFqJIzvfbj4OOHRoYx7cug2eJPniEwPRGqFTMMy0W5bmIRSPCw9BdTp48NMetHq/GWyVJiLZN+yvqMlRA2UDmuV71YGE3ZKxKu82ffYVBckQdJrBHygxtzxrDbrTF/Q+nIxQxsI8gDJpoFbRFDlXSHkZW2bT1MJ7BXffPqBG2cvKLfjGRaDBJj4syaaJwpwEd2bj05Y6kaxA272FmC8lIaUip5EZxsq7IK34LYupMbfVW8Lvs+xcRuFwPHCVsSlIYZLMyqxvN+SDeRdB+2NMFvf+0KWF0HJ47l8A1NoQ9hAVmn19nyC/MErYaenGK1OycPaUYXI9K/aUpm/upau3/QHbjDima/X6bfu8ckioIiTvqLdYTZgEUPkLe9gIlfuoX6Fkn4oULWjE7sFrQCNa/+nRsVqTiRirNA8Dq/9NKPGl0uzst8yOr+0uVq0btIC1/YDePDuxPFH2y1yLoObWYFdjeuDWHpLT6iTBI6jecnbE+jINhI5MvtBSA9yeiyb+/qyAVyOXXaczbJgKRt09gkHXIb2/HchzD8lDCwlY0r52UBSoalx0NMhDAkLsBXC9zwGa2NO2+XD3bjxGoo47i2vsnONxX1eUVGm6LpfAePXLVI+m5xWYxmJApXr6U2NPa6Xbodp0/WMswCtuYWIotDkszlC4i0U8Tcbi8dg9Ph8G6m0gJPdzcsGlB/INY0bMHaQZquyWxqpEhnWHj8AN/ue99lj38pCHHgqEUbH8fcck7AI2Yn8fag3trUHispk1TCOTgyo7v4jsRDtGxBkJYqfmyhIm3XruFPu8m51vlF52vm1PLdzwGHCBfM2uwmR//Aiz
 Q5Gdr35/
 0HbFe+MLnS224nnT17O9AfMqEqmnS5oEvU0IqeAJEwVjr1Z1LXG1VO+6M9uwUJGygjZW48mCQFBFpUpt17LYy0aWieBZDpn1ffn91yNhI2/LygoeFuMvvY9jjdvCETHjfIczvLMV6pUejNhY0S05Rou9xIM0Ugw+ia5YOCqTlaWsU9+zsENAKFxefFNuOD2wrezdr2GRGls8zrxBYyhND7yVeKCBs0eE77NMWDHWQUQ1CCr5udF/1PE0GFc2LtU2xxB3wXboDeRanbdbaoxu/TsCRbjauhqap1aBFEPHK4t+lbrIouZhINRn+zwLDVOwFow0KLZJ+KyQnkbXn+LXDqiZkg54d/aYw0Kupuv5uLtPvQ1cPRuUy7izbl95RnxsPogSFtJuFcSBRVks2tA0gyemHvayQEqfSMsmq0nqoihtnk2m2XpeNC5Gd8CnJs9YzodvVoA3xy3xg5xbBwqD6vDtvL2HwuUxWl2KneoJWlLohfWEM+eoUai/MJRkW4abm+cWNL2q1x0pHB1EBbCOMWQFegPuv31DN95nUDxM1Tr0Xk1JVRshNbyCFcRe+5FmDvdqz7o3Eb4CV02ZFKsssViQjn5Wbs0Ti5K77COmI1XYPqdel34E9vUwIwbERatMSD+Modluby/PuLQpkrVObNNxZfcRCuO9ZH3BbJOWYFDg3+NrK59qJ/Wzoec4f+PF3Ykvv60U9Dw1w1MS8I5UmSrxgKCSgR1rsSWocwotYN/cZ2zfpdTTT6wVYRhJgUnffS0GlZrUNTnradvtkDxVrOV7JgU/emZWywb6Izsq99XkhVSBLZRsDzNQE8SzBl4pNfNyXuOwkrlTIEC8In89JSHI72F++3V6HS1ST6q1XuJ4pvsVT5BlNzStcQi+UOBjKYuJK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hopefully improve e-mail performance.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 .mailmap    |  1 +
 MAINTAINERS | 18 +++++++++---------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/.mailmap b/.mailmap
index da4afd2b2415..2588a13061b9 100644
--- a/.mailmap
+++ b/.mailmap
@@ -870,6 +870,7 @@ Vivien Didelot <vivien.didelot@gmail.com> <vivien.didelot@savoirfairelinux.com>
 Vlad Dogaru <ddvlad@gmail.com> <vlad.dogaru@intel.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@parallels.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@virtuozzo.com>
+Vlastimil Babka <vbabka@kernel.org> <vbabka@suse.cz>
 WangYuli <wangyuli@aosc.io> <wangyl5933@chinaunicom.cn>
 WangYuli <wangyuli@aosc.io> <wangyuli@deepin.org>
 Weiwen Hu <huweiwen@linux.alibaba.com> <sehuww@mail.scut.edu.cn>
diff --git a/MAINTAINERS b/MAINTAINERS
index e08767323763..38e124413730 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16470,7 +16470,7 @@ M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
@@ -16600,7 +16600,7 @@ M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
@@ -16655,7 +16655,7 @@ F:	mm/oom_kill.c
 
 MEMORY MANAGEMENT - PAGE ALLOCATOR
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Vlastimil Babka <vbabka@suse.cz>
+M:	Vlastimil Babka <vbabka@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 R:	Brendan Jackman <jackmanb@google.com>
@@ -16702,7 +16702,7 @@ M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Rik van Riel <riel@surriel.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Harry Yoo <harry.yoo@oracle.com>
 R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
@@ -16801,7 +16801,7 @@ MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
 R:	Pedro Falcato <pfalcato@suse.de>
 L:	linux-mm@kvack.org
@@ -16831,7 +16831,7 @@ M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -16847,7 +16847,7 @@ M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 M:	David Hildenbrand <david@kernel.org>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -22934,7 +22934,7 @@ K:	\b(?i:rust)\b
 RUST [ALLOC]
 M:	Danilo Krummrich <dakr@kernel.org>
 R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
-R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Uladzislau Rezki <urezki@gmail.com>
 L:	rust-for-linux@vger.kernel.org
@@ -24083,7 +24083,7 @@ F:	Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
 F:	drivers/nvmem/layouts/sl28vpd.c
 
 SLAB ALLOCATOR
-M:	Vlastimil Babka <vbabka@suse.cz>
+M:	Vlastimil Babka <vbabka@kernel.org>
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Christoph Lameter <cl@gentwo.org>
 R:	David Rientjes <rientjes@google.com>
-- 
2.53.0


