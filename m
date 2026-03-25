Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7609C109C033
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6246B0089; Wed, 25 Mar 2026 11:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3FC36B008A; Wed, 25 Mar 2026 11:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C075A6B008C; Wed, 25 Mar 2026 11:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB5306B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:52:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53345C30E5
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:52:40 +0000 (UTC)
X-FDA: 84585028080.27.8CC824F
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4DAC0C0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:52:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=gvTVpj8F;
	spf=pass (imf28.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774453958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+OzSO0IWlJMDnZOc5tQIiXlFwu3Jx/5/svjrKhbwCZM=;
	b=Jn3CtDlzQFVUhrFVvy8/4okZQhLHhqEX95bNdjX6xT8x1qVNAXjq3H16UhwA9zZXJ8U3r+
	5cuGt2wBjxWBIdP4pMRKIR2gc5UsnxqdFYR/kuXjkez9D3Q3UOaQ9nmrkow/LqZ+2mA+m3
	CuS6LihlCX61TER/UaqRg216HLfjGLg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=gvTVpj8F;
	spf=pass (imf28.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774453958; a=rsa-sha256;
	cv=pass;
	b=KE8+biTnvS6y4W6SHYhtljzN7AIrNWrju2HKhwdIlfpuJCISpcBEHDWocteNy4uxbE7B0P
	jNeiNZochY7zesbKclOJAuWE3gkcfwJB9qiky4IpZ3N3hJwGuEo7KbpLUN5HyxoE/wLkLn
	IzLFSakNA+RhpQkR1kJlhlMkeFUTqbw=
ARC-Seal: i=1; a=rsa-sha256; t=1774453946; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=QdFFblBuAIkc6r/hP0G/80ZU7VKnIJtskTQLbHME4lRh/tygvBog4xcTtiUlLFzZU5rGd0A1gs2Fwm63WzcEKRZqhmEWoS0K5NkxgsfOPdoYI/gAdJSWuDjIH9G8xgpfFKFQ3fhFhUzdBOsPJKe6ZukaFNEdZRrB5Wkl+owup2g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774453946; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=+OzSO0IWlJMDnZOc5tQIiXlFwu3Jx/5/svjrKhbwCZM=; 
	b=cENAaHNeGLRRVYUam3qFB8h+BQvS/7Lcaop9gRCmEaN3bbW/+yK3HZszuXv2zc6Jn4un0df95S0fqObgtVcInWN3KrTug7C7Lbxvi3dSVzv4ZaGKRtvspCz58YEFu+t0wQECUiTBkIfCysdxmdYDFw8ayof3kJydbmYNk1ROCoU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774453946;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=+OzSO0IWlJMDnZOc5tQIiXlFwu3Jx/5/svjrKhbwCZM=;
	b=gvTVpj8F2f5gybCbW7aMb360K5/13wRUmPh06eJonIc5nItoMp4GzmVzkBxsEySi
	BPG7GZgT9akuW8c6ESR2uvBmLViiAdgaD1dB6VMjE00xeVuuljMwls5Im+A0ALk4GyV
	4DN4BezgucKGlEtdD7d3AKI7sknT0zwy55NT4ni4=
Received: by mx.zoho.eu with SMTPS id 1774453943350571.0589292966793;
	Wed, 25 Mar 2026 16:52:23 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH v2] mm/damon/core: validate goal nid before accessing node data
Date: Wed, 25 Mar 2026 15:52:21 +0000
Message-Id: <20260325155221.202700-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4DAC0C0005
X-Stat-Signature: 8jz9448nsmn5e1115zhezbo4ywxnrogc
X-Rspam-User: 
X-HE-Tag: 1774453958-160588
X-HE-Meta: U2FsdGVkX1/MvjL6oLkyUJNokVQ+ItwDXzbFJ1b2Ha0W7lkaeQeo8IzJ3jEdvDbOCiKYcPe96L01VJPw+s74gh0Gsg+HuTBIIRunImY4QRFSdgEGsZfYWOhSRaqxxUQfAmECC9T7B7F66B1DXFJ67uLFHIFBWuA9EPmE3bSFIqlI6UkpwinfqrbJEYANGQ3uBbJYyimfwxQtKKiO9haohH/4/qsdfdOcfDrsp030wuApJSDieV7pucwtWTlwCm2VSZy3NXBxNzsQcM9I+FnbTNHN2kBWgowoT4vfWEz41k6Vvc7hg/9iPRjYHtKe2ynZQ8N5hz6MpNY6MdTNkAyeLyi3BtqJzkIWjOAOwmx6QALRz7yKjhACIsrCoRxCTntlJl83A+xcMiJjO3UtFHhmtxKyIfJTp4avEyDR+tRYccbdY3rsz4Vq3F/dtxHBbP2Zj8eRyWba5tu+YdBdYUAT++HVQwFwTxeEnHsELYa7irVpp/2YLOXwjdJ6QvScnE1zGTv78Xm+hz+GizVLbRovXpvi+bF4Ql9NEE8jDFsEmDiaAJzU14nx5gP5oRYnczs8rL1slDDS1yVlhAnxQOWFxXTV3BYxM1dscgdqXxAxC2nch9q9HYDKBaYCDO9okwLhstqEQCuuVjP4O6qBnjIIpXZLtut2Gt0S4eMPgS6q673j7+nKtEPNPZR3vr75tj+825S+G40eB6FTWRGqTTwCV8DuredKoUA52ljvg9gvPbxRQrc2xPKbrk+EuKocg/UjYpZqWVDtLibYBzruiQICHlpt73g4xnWY9UQBY+XAT6Gdpv7P073tOLyPAjb44ejEtbgoHnCceb1ocvWGuwb07Larar9xejg81Gqx34logoG9Ri9IJPIIZDzTV3RGx88eTJraWsMdSzbbsMZUxvO3qV8m2oAtxzdVdCH7xt8upqrILiw7VVyI+Qrg84uB/g+6E7mGLZ4FjCLvpwMUsw1
 yUc7fMUC
 +FrPft9OKNF8r80LcOh762sHe+SRNWstdBwq7/1kZsLrSOilvVFQaaHXUauTVTPAOV4H9ukXJMKALRczsHUYbPsWKRzyUFnFQWpRs6AQpf1Lxwi8WZwAIcGJTUBsD1Z2WWt/oNiwDv+klvI0YcWbRsnKKFZJpygllU2tlchypIibPwGagMYYelFmrW9B2WiEjjVvTG8la2irNvbje23kogB0ElZ+ndXTonzDQsD3u0PvfN0yBlr9t6GkQpF3YtHxNoFr0b1IAzzhXKviuZgG1hEw3R7NeG65zsYlvDIW/8KaMp274C3/mLpy6gQfGpMHdqEfsMlbuq05xt4hG3eROCx4SbERMPo/YrRTSQnpdsEyLDjMoKK78wijTqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_get_node_mem_bp() and damos_get_node_memcg_used_bp() pass
goal->nid directly to si_meminfo_node() and NODE_DATA() without
checking that it refers to a valid, online NUMA node.  Since
goal->nid is set from userspace via sysfs with no validation, a
negative or out-of-range value causes an out-of-bounds access in
NODE_DATA(), and a valid but offline node gives undefined results.

Add bounds and node_state(N_MEMORY) checks before using the nid,
consistent with damon_migrate_pages().

Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Cc: stable@vger.kernel.org
Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 59b709f04975..112125b635d7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2227,6 +2227,10 @@ static __kernel_ulong_t damos_get_node_mem_bp(
 	struct sysinfo i;
 	__kernel_ulong_t numerator;
 
+	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
+	    !node_state(goal->nid, N_MEMORY))
+		return 0;
+
 	si_meminfo_node(&i, goal->nid);
 	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
 		numerator = i.totalram - i.freeram;
@@ -2243,6 +2247,10 @@ static unsigned long damos_get_node_memcg_used_bp(
 	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
+	if (goal->nid < 0 || goal->nid >= MAX_NUMNODES ||
+	    !node_state(goal->nid, N_MEMORY))
+		return 0;
+
 	memcg = mem_cgroup_get_from_id(goal->memcg_id);
 	if (!memcg) {
 		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
-- 
2.34.1


