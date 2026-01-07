Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D3C0CF6BF2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B426B009D; Wed,  7 Jan 2026 02:28:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011886B009F; Wed,  7 Jan 2026 02:28:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1946B00A0; Wed,  7 Jan 2026 02:28:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA8906B009D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:28:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 871A8B6855
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:28:41 +0000 (UTC)
X-FDA: 84304340442.25.7DBEC6E
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id D12AEC0003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:28:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1ZL2gx0R;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3JgteaQgKCAcipunqphvnvvnsl.jvtspu14-ttr2hjr.vyn@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3JgteaQgKCAcipunqphvnvvnsl.jvtspu14-ttr2hjr.vyn@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767770919; a=rsa-sha256;
	cv=none;
	b=Qj6q9fLlPgGBhN0EZ2h3pVtearMFbPv1Mp8LDary7zZvKdEnugT47btVx+R9Qb8TLJpN4D
	cGU+gwYLsZtHidqKaDMx4AV9k6ARO3WBjAaC6qpzWEWz3aGOT7lMVCCBVsJL6Fwtcbo4el
	9PrwS2ndFIw+vnCIo/diAvjLhlg1tnc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1ZL2gx0R;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3JgteaQgKCAcipunqphvnvvnsl.jvtspu14-ttr2hjr.vyn@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3JgteaQgKCAcipunqphvnvvnsl.jvtspu14-ttr2hjr.vyn@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767770919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZsdM3yNb3T+HIuMdwl9qQggHhqQbJEHsMkRZMl/CR0=;
	b=3txmw6HQ2Mx7Aot+mqudtD7uXB+5Bs0GrFbXK8LO/qsaw6MF040aRPxZFJDx+rGBURQhIc
	mgHkWYqu6ozROv6bnTfoF2jIOetXFSBYHFtSgWZOkhsBRpD1HIPMK2CiD/aiX5Z1Zfqjyf
	KqR+LSzOmIflRoG1NWPW1/RnoTChDNw=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-11b7dbce216so1616868c88.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 23:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767770918; x=1768375718; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xZsdM3yNb3T+HIuMdwl9qQggHhqQbJEHsMkRZMl/CR0=;
        b=1ZL2gx0Riy6Rg/27FR53GKDsTGmeIBNsWI2PEJa5AEZdcNDzZcrq3tcAhjLOzHPUm6
         rvgdpJkgghfg9wzayDuJY2UpMYueAIEh7sTPgW4pou7NsQUrF0FI7CuJyy4TLCWZE/Vh
         qnKKZnUJu2Gvwy7ij7Q3Z/mZfxUkNQjpYq81+OvV8YxeMD8VWfKhbsir3b8ylGN8EGvV
         uEbNpFLFJFRdmhvyG18UA/XHNnnnShDJtFtMp9foF4qxo3SHYz1c2jp1NBVJ3P0QNz4M
         0L0ehgbofK1M5t5uzlKUjf/OJjp4A7c65RH0LeQgzliMn6MJvz/h+ASktOTAIbzmPCGw
         0bdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767770918; x=1768375718;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZsdM3yNb3T+HIuMdwl9qQggHhqQbJEHsMkRZMl/CR0=;
        b=Esn5Cs38secybFPNbb1ouIBo42lpX2258DHFlwmYW3r3R+LbJl5O/Eqj2E9zwsHzsi
         WunBD1VOQTJJlaUfCGx06XM17MAz/Ry/+z99NNrdnzTI/+X7bsnLIDMempHCXX3/SyLn
         yL5jhxM+KOXZAQChRRWOuYtN3+WbxhPp+vnb2/WGkkKAFXDD58ynI9gBLCBzwmP1WP1h
         u7WIarSErIFYkiKp6Qcqh2xqAboaY8UzfozoLKE68LF1qeIogegKH1oYeIzzrKkL/Y+8
         +kIYaHOQJUzXIwtR6DWa4ie7vUrOQAMVopCVRSEsnPMUXCl0mJ/vy0q0NcduKf/CNtlv
         C+Rw==
X-Gm-Message-State: AOJu0YyAH1YNwnjnOoJd/jcIpbo49d6DfVcrOgLTxzTLd+q9E7sjOPhO
	u61wQf2iJcF1y18kYkJ0WuI3NdVp/bg0wZSlcq84XZDMoNmasdotcORfbL0PATYb3ep0oBZ89Nf
	88Cw75Kvz1JQd+nfITIq2kfZ6FV7PLYL9f14tDbTZ4rfzml3+iRw7sny/knQZxgTaGBMbFMfave
	ap1i//efZlqA/o1EJ4rSXsEm65JyjiMzvD8xGCSChk6A==
X-Google-Smtp-Source: AGHT+IEnSu4SokYnEoOy1GYAc6KpMrqgiubRKJ54xg88A7PHQ7qAFtcBGxkS/pNhE4AjQ+N/NbqrwuAqVAwzRA==
X-Received: from dlbrb22.prod.google.com ([2002:a05:7022:f016:b0:120:5f06:210a])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2391:b0:11e:3e9:3ea0 with SMTP id a92af1059eb24-121f8b777b3mr1532979c88.49.1767770918357;
 Tue, 06 Jan 2026 23:28:38 -0800 (PST)
Date: Wed,  7 Jan 2026 07:28:13 +0000
In-Reply-To: <20260107072814.2324646-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260107072814.2324646-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.358.g0dd7633a29-goog
Message-ID: <20260107072814.2324646-2-bingjiao@google.com>
Subject: [PATCH v1 1/2] mm/vmscan: balance demotion allocation in alloc_demote_folio()
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: Bing Jiao <bingjiao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D12AEC0003
X-Rspamd-Server: rspam03
X-Stat-Signature: b5fheym3dephuzuhrt8hs6w4wirfrgn9
X-Rspam-User: 
X-HE-Tag: 1767770919-866049
X-HE-Meta: U2FsdGVkX1/kpLE4gUwJUEho8c4OQbiT7AHS9bJHP1ZjP2d8dlUVzB28F+d43igGkUnYKAdm1ioh13EtNzgWgGX/HJBGq9r9MkFgS4Bw2KZ4jj6wqIIrXP9TCq3uQ1PUrpxEC97qbI70zoJLPGMI7V00nJbH61uNaElY7eL6AHPYl1oc546c0F4aXK09fx/gv1EMiVHlZ8JlEvV7mwV+X0ny9oOlYIuq6uv3Tnrs5omYOTsx7kkVrUSI2H389XudX6feyM76H/g1Bc/WVevAuli4nwtiFtbJKAjg4L8mu7/ynQoQ1ayTuuQFJC8DxNa1dAiKDJDjxA/vfhqclNh8Ye2a3KNoM4YTL1gFNXfVFeFPjprC8U3CYLjGatXI31J7myD1q2qckMplKJVrBQZj3+fx8xx7k62zV95pWqnn6yFTP9si6Taz73mGIj6z9mriFAKPinXDHGOqWSNGQRG77i17kF5qjc8kzYvebG0KtP7RBC7AjyGmhts6M+r4n2OESJOzchP/7iX7jFLtI5m161FRJeHxmdmPJwSgdsIz4m/AgDvhdrtNORHgQGfSqvgtJ7hfVm2/NCGnLTzhqipmG2ITOBNO9AlJFLO7+tMTAxqU0HRr7obJaUxJRmTAFsx5Cq8CShTcg7UqAmQ49mSa7HfiAH5eI0l3AvNPP8vlPi5GcB8Z0ELOHZn3oWp+sRys47cnnCrQihm+iEovcyzwBp44BLJDzYCAmPt9HrwHqemYzXt3mt43tUpeEFAp/9M1YdXt6Y5rWqIQjGHVLUckVva4dyxrx2tRvvjXeI1ELhzmY6GcKeyQmgANXDi2wkPMaLs2FeYNTKy9GfyTHG5Es3qUXdSxWMGB6vrzXifUXop1ECEeoQbwz684tC6zUsgWmjZWKpnYgEi5ypxAUe0+3z9x8PCCpnTwp5+sDcpQuDUxYsrsIQPv0UwWBzunHaKRi8VK6vXZXRquwHfhInR
 U6HPVjQD
 /WSfMHQ03ELtAKbBJnGHshMMNZVZJaeqgnWNsoMxrxCvgo17ivIPMr1/kFVM3zdBUk/XpfYJLl9OciTCOaqTtDJ2XYj7S0Wno70boobwVNLnq407psOd6tIVudBRzA6SKlKuXNSxKuXJqYhwlZpaV3VakarrO4IG7BBSWLKZVOexoQk795rzOgp/dcQm7ZYu0ceE37NOTLZDvZwqpT1V7APF1YliThEdbxe+UZWzXfaMqdjmZlECXRbqhztATiBkG1aJb4tMDXC9ZchlytVSl8dMA8HkhUDMg5pWWYBBcOtB3XLDWLc29Pmf9TcV5CRFQcYoDj6CUssYnsih7rZXqHI1jyNiMoKorG4L7fV6/gPgmoTCRgSz5kuV0RHpJIF48oNXP+/ah48iUGVQOX8lh+4OMLQtL258GTwcvPLT6x9m0kBBanjf7K0/JpYsx95/VFY+Af31KpknNIAGDQm85l8+nFyLPLRRK+C031IU9VigejKxNKoPTMA7DXZTqZBiCxvGc5eChinpzlUi73OUzIwLQAljjUKEwIT7AHJROeNSJsd5UcadSaglhi9e3IP1Dpr0SndB/oX6xe32T5S1ZjdPTazyZA0wE27pI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the preferred demotion node does not have enough free space,
alloc_demote_folio() attempts to allocate from fallback nodes.
Currently, it lacks a mechanism to distribute these fallback allocations,
which can lead to unbalanced memory pressure across fallback nodes.

Balance the allocation by randomly selecting a new preferred node from
the fallback nodes if the initial allocation from the old preferred
node fails.

Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 mm/vmscan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 81828fa625ed..db2413c4bd26 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1009,6 +1009,11 @@ static struct folio *alloc_demote_folio(struct folio *src,
 	if (dst)
 		return dst;

+	/* Randomly select a node from fallback nodes for balanced allocation */
+	if (allowed_mask) {
+		mtc->nid = node_random(allowed_mask);
+		node_clear(mtc->nid, *allowed_mask);
+	}
 	mtc->gfp_mask &= ~__GFP_THISNODE;
 	mtc->nmask = allowed_mask;

--
2.52.0.358.g0dd7633a29-goog


