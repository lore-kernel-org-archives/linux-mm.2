Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A99D59F7A
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 08:36:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37ED6B0005; Sat, 13 Dec 2025 03:36:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F676B0007; Sat, 13 Dec 2025 03:36:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25016B0008; Sat, 13 Dec 2025 03:36:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C17F96B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 03:36:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FF1A1358D2
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:36:52 +0000 (UTC)
X-FDA: 84213792264.04.7CF0618
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id AED70140013
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:36:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="hG8cp/wR";
	spf=pass (imf26.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765615010; a=rsa-sha256;
	cv=none;
	b=O+NRMz4krAjCjxwfSP/jEXLk9XY20eShSQdXPvftsiq5+ejyAkJOwHWo7sOiEkCPGSU20L
	OLIWegugtui16ElAyJwfB5g4uGJ6plzbnTo1w6e8yai8D0aNwA8i5BddTO9yHNcr2DC2jb
	eXw0ifPTLcvYz5fo/5nc+PaEjgNL9xg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="hG8cp/wR";
	spf=pass (imf26.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765615010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QUO4Z6t+8bAoOC2zkdCt5oTJYULmp/swr6svAoHv0Bo=;
	b=h1Z1ExHl97DBOM12twsXQQfwpgP/UMaPLqgbWJ45VxFSZBZ1huMOFUwhOcqiXv9ANR2CUk
	zAzjzVMq4mNpNTWuupinFtN0zK3PBQKktYAN0xGVfek6IohEnDVXwrVk/4AQic9epLaxQF
	EayO8Gnyh+lamNR1/3PKp7X4gaX1tmQ=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a081c163b0so8502205ad.0
        for <linux-mm@kvack.org>; Sat, 13 Dec 2025 00:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765615009; x=1766219809; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QUO4Z6t+8bAoOC2zkdCt5oTJYULmp/swr6svAoHv0Bo=;
        b=hG8cp/wRENTg2G+uBsGZM+v3sjxWNgRspmgbZNA1vHSRnr8bxAMPptsNl406H+FcnQ
         gbB5ccUy0nkVduTslAwJOI+t0L53VHCIrK501eXoWRs8Ny78EO/Hz7RYfqXp5wDXXF9O
         H/TM9UjS10KmMWWRY2x4O1IpyGpvuuqJ8P75iwic8OS2VrWcEhV8N8cMdcHOov6gaftw
         NiLV4x+oB5o0/jzfDKMDMKPsW9dtLiwZb9BU7gXEUFdvxiXLcSWIlNJcS3eG0DP+MWRZ
         AQR/w1e1OUe+e73AE4G2nvgv1MY4c7ZvU4otHWowcytljcA03Z8Ojs96shQN9IcmmXBB
         Dtsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765615009; x=1766219809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QUO4Z6t+8bAoOC2zkdCt5oTJYULmp/swr6svAoHv0Bo=;
        b=eT/qAwtSVYK3WdvPLOcvS/p8NvW14N6VLzFyP+2FfhHdYYhxUjBA/1R5Nl7FFotx8E
         3Z+saJ4Se6kFEBdnwHPE6uNE4e0I/kltukCaCGrbZYdjibd6q/KMhG0yW0Gr+ibHzPkD
         5yIVS7bL7ZDNnIZ3hgSoatkr5NoUqVS7Zv+O5YKa0FHfaUXaeTDO710YSXWGMv1j3yrv
         9XenpWlIbsNu3RK5sIwG61a6wGS/AH33ebakJzdGRLSZ+OVJHRm94OVOVOELF1x5/PIP
         HBPKGJSCJ35nk3a/5zwlXb/s32szIoMk40BLU0uoHm1TyWQ+VQwgI+RdxY0C1P/bosz9
         RIAQ==
X-Gm-Message-State: AOJu0YzqZrc1bvCLSr+QgWUeXAwkIA8fS/VJcNDd62P4zC2jzkNA0JSJ
	lpvdYgaBJi4g49N7jvwr6fzthAofN7aUQF2DSeSxtFryJkvZCW7qcVPA
X-Gm-Gg: AY/fxX6btoHfLZhaBz7EFSsSReSrGpFhAyqP2Le/ZPo9qoReNUyIVYN65HrMQftHnMY
	wKKHbgY6nSgErU22nj16Y7CTe70RJuUqVsiQuqRk+JMJXCSW6Jzpeze+L9f9YtLuk6bm8gtwOti
	boa5jSJKrnVEqAIeMoHmN7l4onPx7Hya85iOql/c+8V7fs1dU/+pLpxT/wJrkavddrWjhdsJWBQ
	bMpbRNX5Rv9DkCsPzVyJkD9LIpVNvrmOWYqx7d3c34QbWsqAQmPrb1tKynOk4j7WufAn66h7Ri2
	DuN8Sc8GMiI3g3UClVf32jMoxIRrqwosBhhR+B2gqkbLbwXJYmJtfbqx7C+MUhIY5144YT6nT8t
	B9RgQ8+W/lEgN+VuUiqUXsdw8qELekNXUnRmM8VrxycgMiVBkwEsfl6vCTKXg8oViJ0MJxXLxD/
	MwehjHlaOyAw9aTEfkUKyvC//9icNHYJjKZa4q93H+pTZ0paYmMY82EfVDZNwcCdYYGv8=
X-Google-Smtp-Source: AGHT+IF9irKZasWPzWyf4lQTlZvixoJdNYFsprCdE3fzI1IBo3nfOigGTBcKKIDBMGNNA+JEWKK67Q==
X-Received: by 2002:a17:902:ef47:b0:298:33c9:eda1 with SMTP id d9443c01a7336-29f24345b37mr37230755ad.43.1765615009519;
        Sat, 13 Dec 2025 00:36:49 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:6d95:e330:61e2:af5f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea016c86sm76479845ad.54.2025.12.13.00.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Dec 2025 00:36:48 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	yuzhao@google.com,
	heftig@archlinux.org,
	oleksandr@natalenko.name,
	bgeffon@google.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+90fcab4d88cffed6d0d8@syzkaller.appspotmail.com
Subject: [PATCH] mm: vmscan: always allow writeback during memcg reclaim
Date: Sat, 13 Dec 2025 14:06:39 +0530
Message-ID: <20251213083639.364539-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AED70140013
X-Rspamd-Server: rspam04
X-Stat-Signature: 1iua5k189owfeusg5k3r57xur1yitp14
X-HE-Tag: 1765615010-174555
X-HE-Meta: U2FsdGVkX1/sE9sWV4ySYuGjgYFPpSYQ7GeL5RFmUHZGZU+jCFF4AtGieYwxMDf57RAy3mx0dcbbWUYhIEu7wtSXvE4/lkMedWX5fqrQKzHukIUCDlv+LP5MJjHMTDuuuc3sTccd6La0lWy6A/NxPVRZCPdjWylnBRIFHgKszKCnJ6MxoZphdA3nm2t88tRn167BnRhmPfq27QO6XbPU6Mub+6YdE3dU8V9UKvZLIEsia/GVuXaZ9+pCsiPpgrVeOsWNArSI/81i6w9ciBvpVdX4Dz79Sf+jWD2VZjmiZ/+7VhSfhfTPE7+394XIKbCICPAuyb5KiPfcyNrRfjgJ4Eyc2M2sHb3tx7PVC6bxUJfsDsszFCG9JXVdaFXdMYkXNwrPOGRV8srn69/LuohpJGfpUn0j6Ta4H+BZxRWUGWJ6ke/QZ19kmJYhGFpB87VTHnqrMDwOtEPaiuDHIBSrcwjzv+UxotHeyNNWHl57ub85ayK6YjhFcc1adZ5Q5DPvkMvn3JF2elk7EvGTzes5zyB2N4VCWO9tEXxX2oIy2AXSenyxiMdVIbUht8CVzxp3SJNZ+DnLuoWoTrZ9ndLoyJsZUyp7/kbmwU16lMObDaM8zG7vUj0gY5oGKVfGJCbEy3gtwdC2ChwQP0W427+lIVE11oRe1vAS1jFsRkrMfmFsIwB9vfh9X1g3wP0Yz2Ec1blyyHG8I9xX+K05DPTfM3A3x27OqjAX9PfHA/xnSx1j42dXAcGj4oSi+NRNPaJq7fLExIEGyqjPeJkbCFzuTo8wV7//ikAzRMTusm3Zkdyi3wvnoraVgZ6pTgY5lv8DP6oqDtSv9hveg0j2lquXBQvtTB+4qSLpkhoi3meQEZlVJSqp/dZF4/tm2FbSQZrVQtrxCVEO7Tfxl4s4UBBAFJCPjp6fXCt4Urw8l+9e3G9C31Q+PvcmT9OnxJiUWKW1X/5HRj4bh17mLH7rkye
 loVvv7R0
 hLh4/Mz2BRiYcFo7vqJRwZGzQFcoRrwK6XsIAGG+Vp6XYmvnBs1Ltk8nFyehn4jwpJZHzLx3y1Z2TUoUnpRHRbJJVntJXAhiIQP/1f0FXbua8mvZIew2M36f68fRO2C96gRTAL+2lUy7aSmTOigwwJ08pOE824rPhUcouayuCzbLir3n7U7twivY8NH8Fu6DlqYfo/ZEunALiBA/7aXCop+YoMEztV250yQsqzq1tNCXILhkaoAiXqt7o+Ed5RvmzDS0B2ENZiDxUZkww8+0EDnfFdKo35OuS6LDHU6Q1LWZ8y6thik3gI4KI+Rfb5lx31snai+chUrN7VhnNLZhQdYU55n+W4a4ZHPXYHKiJ/11A/Wg0uY061uzFR2sK+mMOkSTPHBC5RZDGt+2/v7Qm2+pDe7NGIyomGt9nchl9rnRdp8fO4ig0o3UAWZhnuVWCqTKSW+8UncQz+5i6XnCA3m09afXfBamqtwgovvvwnk+tm7QC7UHJ0CaNmRxmCmxdL+p11sJ0yaEaWLvAk2gi5OUN/Bsz1NQhxpckn0Pzc3Yq5qFvfla7YnsW8KGqMhIUSNGdGWBKc/peZp59/8WThgqUYxGxTzpAHyETIyqgPyCr8WQQBn+YnpjSLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When laptop_mode is enabled, may_writepage is set to 0 in
try_to_free_mem_cgroup_pages(). This triggers a warning in MGLRU's
lru_gen_shrink_lruvec():

    VM_WARN_ON_ONCE(!sc->may_writepage || !sc->may_unmap);

The warning occurs because MGLRU expects full reclaim capabilities to
function correctly. The call path is:

    mem_cgroup_resize_max()
      try_to_free_mem_cgroup_pages()
        do_try_to_free_pages()
          shrink_node()
            shrink_lruvec()
              lru_gen_shrink_lruvec()  <-- WARNING

Unlike kswapd or direct reclaim where laptop_mode's disk-saving behavior
is a reasonable optimization, memcg limit enforcement is a hard
requirement - memory MUST be freed when a cgroup exceeds its limit.
The may_unmap field is already set unconditionally to 1 in this path,
acknowledging that memcg reclaim needs full capabilities.

Set may_writepage unconditionally to 1 for memcg reclaim to ensure
MGLRU works correctly and memory limits are properly enforced.

Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Reported-by: syzbot+90fcab4d88cffed6d0d8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=90fcab4d88cffed6d0d8
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

---
Note: Only compile-tested. No reproducer available from syzbot.
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 900c74b6aa62..5e1c99d9cbd7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6669,7 +6669,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.reclaim_idx = MAX_NR_ZONES - 1,
 		.target_mem_cgroup = memcg,
 		.priority = DEF_PRIORITY,
-		.may_writepage = !laptop_mode,
+		.may_writepage = 1,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
-- 
2.43.0


