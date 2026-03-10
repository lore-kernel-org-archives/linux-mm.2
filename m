Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B83E6EB104F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A666B0089; Tue, 10 Mar 2026 07:38:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 207A06B008A; Tue, 10 Mar 2026 07:38:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E516B008C; Tue, 10 Mar 2026 07:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 03C5C6B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:38:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2188C01BB
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:38:40 +0000 (UTC)
X-FDA: 84529956000.01.DA50701
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2C04FC0003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:38:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JPg4yHxS;
	spf=pass (imf28.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773142718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DlbppZcw7Bols0n34L6K8JFTRaNL701/JTjAGVZvn6I=;
	b=ZQLQ3gHW4y5uxZseVFsLB3RNoM/j7RO+mza2MIWMZZaAvSEioS/afTKeGiHaBmNPIheeTe
	ra9segDtP/GPZ13gHUX1yGXAURcfwLpumr5Xu3idVwMjRWWaAA25wImf3dOGSVziahOwbf
	4BxjGCyWpD+Il0GlmfzTWzdtQFCrm2w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773142718; a=rsa-sha256;
	cv=none;
	b=aHQl7MKFbNaVwtuq2hhTSw47pmf4+jX3SY6fDMOuzTECBvgZ2OpA8Yt/UyDHigPa0qWoy8
	x6Hv8/+8DFxUQrY/Dk+6VbIZCxNPAu9vmiitKc9bpA7ZjvMsQFNOZdnheCeqIY00nK0inx
	D6gTD6OZnj4Eqi6wa8zcIhrJeEdJwXs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JPg4yHxS;
	spf=pass (imf28.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Dl
	bppZcw7Bols0n34L6K8JFTRaNL701/JTjAGVZvn6I=; b=JPg4yHxSqT21AGjjiV
	YtSDD1/8otWOhrKofO9Onrj6ieTCiINPkoUnNRQHo2K7x0CoJuBVY0UV4PbelBhh
	imAeLne7foQZpOWlkc5PcEVRM4wWD1PefHCN+NbLOYfrIX/2rcAx7lryKYwoioHg
	G6A5mg52fwON4rczkt/ymRncg=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wAXvQ+eArBpwhXAAA--.11763S2;
	Tue, 10 Mar 2026 19:38:07 +0800 (CST)
From: ranxiaokai627@163.com
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	harry.yoo@oracle.com,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH 0/2] fix kmem over-charging for embedded obj_exts array
Date: Tue, 10 Mar 2026 11:38:02 +0000
Message-ID: <20260310113804.245647-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXvQ+eArBpwhXAAA--.11763S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKry8KFyfJFW3Jw4fur15Arb_yoWkKFg_ZF
	Z2qas8Xr4UGFyDGa47CF4UJFy3Ja13Jr4rGF17JrsrCF97KwnrArnxX3yxZ34kZF4rCwn8
	J3y5Wr1Fvr1xWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRMjjqJUUUUU==
X-Originating-IP: [117.176.242.62]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxh8uemmwAp9lNgAA3a
X-Stat-Signature: 6eid5u7s18z4x3hih768ubig1kp3rzp1
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C04FC0003
X-Rspamd-Server: rspam12
X-HE-Tag: 1773142716-886968
X-HE-Meta: U2FsdGVkX18A3oKjr++JGfBbFRDCmd/Bm8x9dWeDs6ZPCzUpvhDeDMwfYjbw1z5A2BHDSmvIrKQGkmfii9+HYOZ3O6tS4NzgUDq8lNZK466c6thYh6GwwvkPyEPR2hcklcF3JIw7vE5xzRJrG/RQo4VSOEyeBkw9J64lfevBLrDabz2S/4J+xSMhf9ufeWVswEefjDTvl7WBdTbdwWIavPfkZU9bMikblto3OCEWcZUBM5NPl2osb9cwnIOaNn58vhHVKSIVBtR6fsmJri4xwnOtKG6YHS9BjbC1xJo73mjSMOxyh8WwjYQ2tIV5MQPOMkEasivc0oVfr9H7if/mA/bo55CWV68JD1ld892y6rEq6Fo2363vCcxLSehtsRALa96gb3OmbLMVOm1XWCcOEmxKsHlpirDoT68y/fqxkWLdIrPLvVDY2vmlGzKcYJ+cc0O65xo+EUxLIe08V+sBjPcsUw8RTf5oMpT98k+JdWhvSQwWnPxLOm57VeFYS2fXv5PDtNpDH7SUojhZVzBoTnEwM78Jw2unyQ2U5Rcb2dVi6vKtqA9zvZFqdYKT39k26dKdESlNlRWM4YrIZ+u/IPWJDSM2laKk2pvFAVFgpz3qf+iawzk1ESULLHCB1GBlVj3r0dpNO9ozUwmnv4rNsg2ZwG70I6QKscADO4Os4XcWyqKws9GajNQjOlfUIlc4tJiWfoQ9T0/9q4cqudDrUJWOGf+HdbiaGgmR0Uexq75Zz9x3hF3QDV2lgZvPDk/9YiGSyE8VwtVW/TMBmgd77O3jekNN/NhRBzyvTFO0k6iLiVaHLqDsRQGhZNZEV4B0u/h0h/UGO0oX5CPY5M824DHqTxP9hjmbcQIyzcRxFEXC9EKOy4ALB7VSmk6ipe8DbRJZVL87cMK84ftNqEaFXZqPgQP0S/K3+iff+YiXj4LUbcDgc2tWFN5Smpp26ciLXOStsgf1/WBgZNejJnp
 YUguKzU+
 nWX/cZ5QFMUY5T6DenyuKdaR6UDrfkhLbFwsltjIcjBaIAiiuxZ9PVe0PbNYxi6wc7pxCuKj0Irf5i+ldq7IKuMxapJ/c3xPTfej0M0kjWN91Kf61mqtRzFVv3dKBxU8fQLt2tc2e1aZX30yB91zXK+KGdlBRENvyuWf8XRvBvZBNs/I+6EG5MbevhmPSM4j6PaQrltRTUmGNC4zsoIxRiJgnyth6dHCJ4sWr+hp7VqCoeAhSeUBWu2CEQ+2expZ+bRRop7gV1yk2z/CdgxGrRctZ/nzb+uy+7852TD3xmbEdwn2jSvh1eotAEE226zUtZXvpHxAfH1l+pmuymW68XE7hvlTImICj827KoMc/aIKAmvpo9UaahuvbjlfyK4HhbOStNQUhE4Rmgdr2GOpxwtnqCY2brRUKrrtoctgdbi3HImj6hvWK6Ag16FB8lu8tU4cs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Since commit a77d6d338685 ("mm/slab: place slabobj_ext metadata
in unused space within s->size"), the struct slabobj_ext array can
use slab leftover space or be embedded into the slub object to save
memory. In these cases, no extra kmalloc space is allocated for the
obj_exts array.

However, obj_full_size() always returns extra sizeof(struct obj_cgroup *)
bytes for every object, which leads to over-charging for slabs with
embedded obj_exts.

This series optimizes obj_full_size() to check whether obj_exts uses
slab leftover space or is embedded in the object. If so, only the object
size is charged. Otherwise, the extra obj_cgroup pointer space is also
charged.

Patch1 moves obj_exts_in_slab() definition to slab.h so it can be
       called from memcontrol.c.
Patch2 updates obj_full_size() to avoid over-charging.

Ran Xiaokai (2):
  mm/slab: move obj_exts_in_slab() definition to slab.h
  memcg: fix kmem over-charging for embedded obj_exts array

 mm/memcontrol.c | 19 ++++++++++++++-----
 mm/slab.h       | 19 +++++++++++++++++++
 mm/slub.c       | 19 -------------------
 3 files changed, 33 insertions(+), 24 deletions(-)

-- 
2.25.1



