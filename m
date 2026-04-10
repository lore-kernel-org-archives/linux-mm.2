Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19FF5F45A0F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E055D6B0099; Fri, 10 Apr 2026 17:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7826B009B; Fri, 10 Apr 2026 17:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09276B009D; Fri, 10 Apr 2026 17:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A66B16B0099
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:07:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 70ACE1A0272
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:58 +0000 (UTC)
X-FDA: 84643883436.23.688D983
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 95AE5A0017
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N4lfJPt+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775855276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Txux4TW6NI8BBnT/9aUbbKCnnuVuxmAnvDFuD00fzoQ=;
	b=1t1ZZbswx5B754iY0V5v0j/gswFjnXMD9AIbDTXDtkVrqMVhwKfencSNI1T3qUfzHkUNyJ
	tNwzGbL14h3G2Bd8J2iFBUNb+hRbc2WZR1Q4ha5mPk+FfDBDFmIeZAzLDiU91LVOigmH9E
	9vN/Hw9Wnj12W5+Pg+DoNsJY2GD/FsA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775855276; a=rsa-sha256;
	cv=none;
	b=Wzs2ZM0DhxrKC+AgfJzGduA5aHJG11r6A7IrVKFNrVAzNokiZLV8zLwVLdPzso0rMP3a9H
	YljzZt/3bWbOBdIQq5uUH5/DD1RUiugHNBJrs7uaL4SCi4x4nBTp2bT7aFt54aA6CkJhZk
	cZ6ZpSRotLO2jSSELZ+HozUqT3Lvzt4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N4lfJPt+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7dbd23bc684so1443161a34.2
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775855275; x=1776460075; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Txux4TW6NI8BBnT/9aUbbKCnnuVuxmAnvDFuD00fzoQ=;
        b=N4lfJPt+62H3bXvLOSF5GRzPuEqDCG7H5ZcyWc2FJrusAfUVJ35AQD3Esqs9u1KWrj
         k0JThlFSEhIULSv1H1RjgOGv47SNakPBebpokI4gwCm3Xzt1GTDRbRjI+Ph/CqvVGNn3
         H8AB9GSVRQpWH/Jk9s5PK06ecDjIuUjt200FNtFI+6VDL1RZwfxxb1Rhl2tpacoFfSiD
         eznSbv+0b6BO4I+ZVw+GpeZ6fLOZe8J6RU4gBj/UzTgjUrZihYsoDqfIIhItp+DYRp+c
         eAEaynVUVaQ8/jz9ZJvppd15MieEsh/sdD22u3YecppQTqGLnjxbI6Xq7E9CEoZz7V/I
         2i2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775855275; x=1776460075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Txux4TW6NI8BBnT/9aUbbKCnnuVuxmAnvDFuD00fzoQ=;
        b=ntOHzkiPtANZRZJwPLqe1A+Ohg2YBUxIY9WZosZs6fcs5692BHiJGbLfyZkVJ0GJ9Z
         Bg1LA9AXHiZAihP+aDbzHEhKXxAfYtAimgFPvL7TKrnEAbnuasiuUuTdGrVs4XEXxH4B
         2OuOcKCXUtZLahiiuXKvqtB01QjyZwzZGAw99fs7iQyhty9famSwLELB12qsdWgbR43i
         KOiRvo2ujymHHVZ00AhBjGnVmhtFDYL+DzSw04uaijt7wE1gx3xiFUqwofQa9DNrmyHu
         cyl5a0CTIAR+yzOB9hiKbpABtXFlM5HsrqIlEIxratsap/oa5iOVgzgChorNuaB8bWPJ
         6gGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdfU4M8RIrcEnVPsAA6JNmlaLwQBDR5QvpBQgGnMPvhIhpqMtpSiaSVo5crKszTeY/AEaq8+x0lw==@kvack.org
X-Gm-Message-State: AOJu0YxAIjFeRCaWrd2w75O3K8GUCY2vPIXHRCWfdWQUVvhl/M56BCQH
	Mf7DCTeZORa/na+6zOXnjeo1IfxCcP8vBpN4liERmZjkWdTC+/+mYVcG
X-Gm-Gg: AeBDiev+GW21JURqTPMVmmTJxGB8BZ/PCZEGciqryeuaqtbuAUXJ2WMtUak1zng8w3d
	87inXZBMvA+qo+9NRk/q4e0pOaaJsuWbbKWBgjZaC4rtMqzPnlbwQNv/Pbp9xkxvxjEYzLvSkJF
	syWHnC1O9GZhwSbptabZDnFaOhl7bnKUrSNvQfy8ypQFOiP8seimLbqSgWCVLMwGvLQQC/p0kbj
	F+kyJ7P62lg+01XCF0Zb2GaWSiactmstJobEK0yxcnAqJPumpBeQ/Y8x8tYvxf/fbVOdP3V7vz6
	8Oa1heEEPXpWcqbSQ0JJJPcU+qz9PD/eEDoU7Lvo1481K3rQOsj0nmJaEpREGMceMCi0DYNRPvU
	j2uSNhqmE8otqE5dBRICpa9cl2SfEBkWyL4tybZ9VTgS2RDpKx6bwpKIgGaZaTeGCtEgce/KZqW
	KB9urzPyw2C7V+QPrwXD89Gw==
X-Received: by 2002:a05:6820:6307:b0:685:c39e:583a with SMTP id 006d021491bc7-68be7ee7a15mr1487108eaf.30.1775855275568;
        Fri, 10 Apr 2026 14:07:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:43::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-68bc88c80a7sm1944727eaf.8.2026.04.10.14.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:07:55 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 7/8 RFC] mm/memcontrol: optimize stock usage for cgroup v2
Date: Fri, 10 Apr 2026 14:07:01 -0700
Message-ID: <20260410210742.550489-8-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
References: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 95AE5A0017
X-Stat-Signature: akwxx5y6356jzuozfggicrd95qd4bw3k
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775855276-768199
X-HE-Meta: U2FsdGVkX1+aHgoRuUMAD0Y0IXFHSeUB754iQh1C9PmLCNpGQLTA5mIFAC9uCOLx1RJULmPZkcC56utCox79ue5Q4e1jRHg25khdmNSwOX5MGYiFZQCPFr0mXnAjRd63Z/xnlfTf0WBZqnyl1ZiLO4pT19G59cfrgU5w2YBkI4DgTr0158P5xTNHjH0xj0rRtqORYML+pu8ujjUuuUYKuu4Wvrpwc+vf4cfkRWlvknKE9T6WdjfIxSDJ81NHvSCWDi0qVAdfPVVASPNW6vUL2Hrzn8a2wwwFydUSpiE6u2RtTq/hO1BW6yHBl9gVYEIdQwcghZaQwMN+n7mB1HAjUHmZ1OKJCkPhlnTuYYcTkY5dvE26QL43nbWBd5Cyn7ZzZ2zJRYsRdryHH+IgWFogkhkPCkJRHU/X6SSRlSPvG+FYOyqWwglHi7Mku9qbrVryXy53fMQS9/S8VLaZELbGNczqfRQ9JCMOckJGRZEcwF+inw0ENZ2WEjAHh+VW5rUGdaaMmcgaLCf9K/eIOc1/J9N0SYZwFMFh9kdKSKqunotDDxBVlVaAmfozUcVrMpjwMFCx7HeWorKrgopp8+RQCHTRux9qM7ykP37Ds84T/ejK5aqeKfQsavepBce/6A5FCYW4R9QvJI6Q528DxEesdUpwdV596bp7XM+cH1EW1J0PUc51tVYmBkam6d+hHo+kbibI44WZ8Lsp/xdd+8SvBjbus1wcjkZLK1aHtW7cq2jFKH2Z3eStWPOi8FEUnW5hnntpLM/8ZjR/10ZmCFBJJxOmLERk5NA9Xe+PF0haNugD89dYG2pTwVpdCLmNEoH1ice/MFrunR0Yho/0txkeNdACLc6HWi6htL4bcd8xpvihV2P5rkBGjG5JIKQygvKLjJZciKyJKSfpPp11YxerjFFQU+TGp02Rkv1TN3oLypqLRcEtOG7gZonayWKU6wa1PYDnW0IBYlUA24OpfmR
 TCxB5M/g
 kE+happd/NePNq1Nex6EoXQCajx9ufk1cmHWb9h3xX44m0ffpv/gxuovR0vzXAle5jFlCXktTMfa7+eU3ezPOOk/scwZnt6Y4uWngLz+vCqlZBdf3TRsRafhjM7C1AFHnkKhgyvvCFNaVFrYnP2DCZhfe+OC8pA/ZRAhN/BxcGwNZHFL40W1ERewGGC/uBPiT2UuZBkuAftSCsFmAWKWrkBecMlaAtKBbX25hwZ70iQTTykKlHEpj+mlgxM1sBZvOHzxXtZmL/zug45ijy+vxmcaLOtMopSnlLcvMBSN/DKjrh5/zhceIFVCiWdMJVUzjhBkkgbIX40CE2r69yVLOaDVaqa8mj+jyUP1vRkrnceahxdFsgyalKW3wgLCnLZCUjc2wnV/w44a9YckTrEe1QiI2BMOgLPhF7G1NYD3o0MoShVsFwvMYa/cjXnFB1bcDysGvfnN2s4bZD529Ne+8LrWT3DYCqD8uRVuW5XWbdaMK0Ok2pQq7FSKJ3EFPrPj4R5f/dWRIUTLGOmiqqR/WIWj9C0iuxwNuJlLUp8EItxZfnLvONeoI5BRGaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In cgroup v2, tasks can only belong to leaf cgroups, meaning non-leaf
cgroups never receive direct charges. Having stock remain in these
cgroups therefore, is wasted percpu memory that will never be consumed
unless all of its children are removed.

To avoid leaving unused but accounted charges from remaining in non-leaf
cgroups, drain the stock when leaf cgroups become parents.

There is one caveat, which is concurrent charging and child creation.
When a leaf cgroup becomes a parent at the same time it is still
charging a task, there can be a race condition where the parent's
stock is drained, then refilled by the charge.

Instead of adding expensive synchronization mechanisms, accept the
pages kept captive by parent page_counters which will not be able to use
the stock until all its children are offlined first. It is a rare
race condition, and is also bounded by MEMCG_CHARGE_BATCH = 64 pages.

This optimization is not for cgroup v1, where tasks can be attached to
any cgroup in the hierarchy, meaning stock can be consumed & refilled
for non-leaf cgroups as well.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6d50f5d667434..4be1638dde180 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4130,6 +4130,17 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 */
 	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
 
+	/*
+	 * On v2, non-leaf memcgs cannot directly be charged. This child's
+	 * parent is no longer a leaf, so drain the parent's stock.
+	 */
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+
+		if (parent)
+			page_counter_drain_stock(&parent->memory);
+	}
+
 	return 0;
 free_objcg:
 	for_each_node(nid) {
-- 
2.52.0


