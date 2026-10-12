Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3306CA9ECF
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 02:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 573A26B0088; Sun, 11 Oct 2026 22:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524FC6B008A; Sun, 11 Oct 2026 22:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413E26B008C; Sun, 11 Oct 2026 22:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1ABAF6B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 22:29:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CF9112079D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 02:29:45 +0000 (UTC)
X-FDA: 85312393530.19.619CE4E
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id E0169180002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 02:29:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=okXi17i7;
	spf=pass (imf06.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791772183;
	b=V/za9F5pTCfKr5JQvdJr11+m8Rpgn2xod4ckeuYXTkRXEcQgwzRBv5/dqBk489GUmziLMo
	F576QJTnnX+MAsFMVwBGS2L+uumMiyVPzVAUX5kbygI1erciVZ/klljFoLZfa+55VF199d
	I0huCDaqyge0/9Egna68YMGRVr48eF0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=okXi17i7;
	spf=pass (imf06.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791772183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YUzX3KLBEtejWmrVDJ7UhZNCGyRwxK6E6dSqlqcUQmw=;
	b=PFNK/KvlDRbkj7NmxtTzbk5CbFoXAnjYrKp7wxtYxiZ7fjbB6uJ3QxjYeJGmKH4PRKNgqs
	iZCIrFxh7BlrTP4VkeuXhj2QCTaOD7KzTmTqgXVHhhkwxHBWlnpGotGhetxMwBP2fMGOwS
	4v7twG0eSNK2rT05OADCsoVZ0vbY1Sg=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2dd1dcdcf95so6473255ad.1
        for <linux-mm@kvack.org>; Sun, 11 Oct 2026 19:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791772183; x=1792376983; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YUzX3KLBEtejWmrVDJ7UhZNCGyRwxK6E6dSqlqcUQmw=;
        b=okXi17i7m8BgJ/LgzqLmj66ERovFWyOKG38CCCmLaxZ7Z3vqNZqysEH3tSfXyz2QYJ
         55weBz8EBMLMVHOIZ0x7yNVQe4iIIsOUYXkNWqw0x9xBCltiav4MeKTzQ01jKRomTuoJ
         qVyNVZeCe5DEDhLukeLrpAKlNVhjrjJEw5PWJ6octMKUgZb1/Tso3twDo5xB12cvj2Wz
         smf+oTbDKk2OM1lr+K0lRQZXUPrOkbm4kpcMBCG4aKbVwcGCJL2dErZ06TLte2CKzrGH
         3dXl4mDbA+dqkXwb2yeZ85QRHXC/U+wPz6p+uUNYU0a+saPhBjov1b72jOuJId5WnuGl
         eblg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791772183; x=1792376983;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YUzX3KLBEtejWmrVDJ7UhZNCGyRwxK6E6dSqlqcUQmw=;
        b=tSN5bf6zXEcSi5E7TAXiVDdba9xzWbah5bj5kfMf6cP76/rOQP9o9b8NtZlB84oJWZ
         QfUri6LCctTYeeY/Bp57frKzLkoEW/dNEjnhJRl6/tqM//k8u5MlmnpsGb35h2Oi6dqQ
         /L5AAP51GA7ooLIxdhPBxqKkEekI4LsL6t12U+H2mbciMtE6bNxq93jqSLH1cyeKWhgW
         i7GP8I8lqpSdveB62IOmVpyeNoX6Imeh3Rh9Kax/vSSNdvJrhQjXlBtueHoyhiW98Nte
         GjDx8fkHyGvlhQREk3Px3xuGmfJkQhvKNg8ud2tC0T3BgSZQKuozg+b4N0V6jhschGhR
         ELUw==
X-Gm-Message-State: AFq9FYJjhDmIXIezg2cU+E2LXm2BFAgX9lIWIQJmtmtZnhEuAAvjST20
	hmsApozCM22yHxDOHG+K0IHXfv5n6+JSMZlRhqbBqTUrhVHzEttKCViS
X-Gm-Gg: AYBFou2flLby7e0pLzb/h/Anlu6ULfB63+fZ8kk9yxGOVZ/73wMnagbXOVxJEmuR1LD
	iQIHbsQyY9xxw+cPe92byNegRoo/CCzQ1yruwi53oW1Su1A2TUIKkweLtZPkmg9QCUxVfTLbDOn
	xZkV8er1e3KCGmfQgXnZiw49/3hgZerYNZ4xu3S7aM2OyfUQROEsiIxH0HC7PHfUWsoqjYChwkx
	clr/xWmhGP+qGXcFdZZCic6Z2YvXQjucwoS2Q4effcwHwOmnFnhOaL9B+rQCLNN772TWNto4djL
	DRHhJfhuaA75gFXWsFHXYTAL29jsnU/TGuzqHT6EaDc0WWSxWDtqOIir0j9xWgu36W8KNXaxllf
	x1a1jZPTnhEfEQXZJiqikGNB/axHFihfPDQmbNtCIcKT3nCLqK4caq7qIuy/zOYnWvLrTjRyv5I
	ugXPr3UwiuYO/ww4vS7DkPt9PaBPBjfxi6tJs/2MtgdrhnwodcyJTIXQfMzRaRS14NS1JV6iDAA
	44iB1XGQL2mUg==
X-Received: by 2002:a17:902:ffcf:b0:2df:34c0:72fe with SMTP id d9443c01a7336-2e84054243bmr52558625ad.35.1791772182510;
        Sun, 11 Oct 2026 19:29:42 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e84219e6cdsm37873555ad.28.2026.10.11.19.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 19:29:42 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	roman.gushchin@linux.dev,
	dave@stgolabs.net
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm: vmscan: don't count per-node proactive reclaim as memory pressure
Date: Mon, 12 Oct 2026 10:29:17 +0800
Message-ID: <20261012022917.1102467-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E0169180002
X-Rspam-User: 
X-Stat-Signature: tsdux8tp19w4nnata9o4iayqq3wgd8fk
X-HE-Tag: 1791772183-71519
X-HE-Meta: U2FsdGVkX19RB/xWo1T4oBBputlerANW8srsuHX44n3/RR5T5fbMoA6UgbBjPOT6nuErn9zBgiJfWJxxM92TXEOSUXPEteRbAvfDPXt3J9nUvh420e+7tiNdr6L04B0wFCKcqp3knq32LYqOFJo1vFGsYn4XtIvJ8tPUJ0lKY75EiqPC/eF0IXDAehHcnFhVfnN5uGeUtTxWppV8N/ZlCJWwWLY1jrGmuSZOiFSOhbH5bMpI7CKpARfQrweEMA9/rXTB9KwRZJBE7uDsQQz8ET/wexINM/SOayX1qyXyq+7GbWn3/Ywi9HYmqxtG4mdx1or+f+6N98w3J8fuC+MgQCnKi2H7S1gujKZKXFjGcLxxGNef4ZFshjcV36viKIRCH0Yt1HZkru2jwczsDeNiI/+o7KqdAHESbvkMQg8V4Fa+ppKDtUt3tUjrxcoqaPXNWnThw70OeiHKnxuK7o6OacxGrDcRuQEVS7zuirOLtGg2rCOmIXQEbL4TPjaKjBsg6oVboCfx1rKfgy6DfrvJ41qPPgpkDsEAymrCnc3eAk2g0gckQbfmAG54Vu/8WeQWFBg2qGg6TOd/2XjJF5nt5dfcZaV+QSfsNSO9Odto2Ey41nLcVvhR/CyIAthmuDa88FZxdAg4jN5lnd/KcuEVb5KIbpuXi3GL3isaEVkPWO5+OMV8sJSp83eoAT3UCS6aAMwJBZQygvzXwBeyAXiUVwD27jc4naT8jkqfLnp6JLeW4Q1ZYsSohl/6gOqqs/3sym4Ui8Eb7YZWUgcRNHKDyC+qiTN+tw3mOTyrchHr6CbAyMwI/h6/AekdylDJd/bFCbZE+WH4uGchCuSFitHmb7emKQEImRtSKAdFGR56/LNeNBsLDpWbVKnbuAKweo1NhsHR1ZqG0YgMU2CVEjC+/jkBIfuFlf2NCY4h/lDYLg/Fo/68rteSVzodi9a7uVCLFX7QYJ4pcHxCUfDm9xE
 7mOwpvxi
 vlKGZkLsWX+8JGnMO35Hhz3L311Y1Q7KLTYPlUczMuHbJPk7ewbJgJwVN6phhjN51xc7zuKQ1kSsEs0SFDS0Wfry92O3Z0ejTIOVdk1heeoY9gLwsswBa1Y4eHl4Uv2Qw783VAVbs5wq1ESzInE59OqBluxnJxXQqtIjdlBki793b3OklGunHxTeyYjASEkx7kD+Zcvwm5N4mPhmG+6kt7fjDXRgliny5Sh7OD5l3sqxot5YYJhS8r9LylsVoRUWs5N8mKTPBAittTVuyJeAwhuXc/XkCGR8wisvbgK2QQc0dae8yIuuw6K+OXjGm0WoiuBGnbCHfMF+34qwkJF22V2GcD3RCEbm+IKJxNzTGtrndoVU2d1G2K5qCnjLWKTJR7S+Rxzv6RE0f1zKLJp2EUSyPdl9PchvjriNZfi5pSgZ7NVaZDYR81tSi9TkpVPeHmf0jwKTqJJ2tkL1ruL4BcO95zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

When the cgroup has no memory pressure at all, writing to
/sys/devices/system/nodeX/reclaim triggers proactive reclaim on
NUMA node, causing increase in the writer cgroup's memory PSI.

Due to this reclaim is performed in the context of the write(),
accounted as memory pressure on the writer, like
commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
as memory pressure"). This is unexpected, the similar scenarios (e.g.
senpai) will continue to occur, only this time it is for the
/sys/devices/system/nodeX/reclaim knob.

The Documentation/ABI/stable/sysfs-devices-node documentation also
notes that "This interface is equivalent to the memcg variant."

This patch unifies the semantics of the memcg and node interfaces:
per-node proactive reclaim is no longer counted as memory pressure,
and the per-node proactive reclaim interface no longer produces
phantom pressure.

I ran demo[1] that performs per-node proactive reclaim 10000 times
in qemu, writer cgroup memory.pressure as follows:

without patch:

some avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
full avg10=31.53 avg60=13.42 avg300=3.31 total=10602985

with patch:

some avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
full avg10=9.59 avg60=3.41 avg300=0.81 total=2686221

[1] https://github.com/vernon2gh/app_and_module/tree/main/reclaim_node_psi

Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
V1 -> V2:
- Check `sc->proactive` to differentiate between proactive reclaim or
  page allocation. (Thanks Barry)

V1 : https://lore.kernel.org/linux-mm/20261005062236.564210-1-vernon2gm@gmail.com/
---
 mm/vmscan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 91295070ca33..2e9ca5e4c741 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7994,7 +7994,8 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 					   sc->gfp_mask);
 
 	cond_resched();
-	psi_memstall_enter(&pflags);
+	if (!sc->proactive)
+		psi_memstall_enter(&pflags);
 	delayacct_freepages_start();
 	fs_reclaim_acquire(sc->gfp_mask);
 	/*
@@ -8011,7 +8012,8 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(sc->gfp_mask);
 	delayacct_freepages_end();
-	psi_memstall_leave(&pflags);
+	if (!sc->proactive)
+		psi_memstall_leave(&pflags);
 
 	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed, NULL);
 
-- 
2.53.0


