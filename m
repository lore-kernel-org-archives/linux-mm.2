Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E53EC624A6
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06466B0092; Sun, 22 Feb 2026 03:49:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDADC6B0093; Sun, 22 Feb 2026 03:49:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9EF6B0095; Sun, 22 Feb 2026 03:49:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B97FD6B0092
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80BC014062B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:11 +0000 (UTC)
X-FDA: 84471468102.05.7E4E678
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id BD9E4160005
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Q6ACNd4k;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750149; a=rsa-sha256;
	cv=none;
	b=nT+hRexv2HCJyUUYPByS4kzKWTxsPpwmTpQImqBRs05yBXJ8Y7JKU9+zm+NtvakZNIu5Dx
	WH3WWfSmRUQyGzWG0THBlFPfBRTCj5Pu9rsJUo8yrmGUOo1EUn/AcS7MmAWDK8sCS3HtZD
	sg7K6SXHbV0TGDrB1KYJb7H+Rz3HfUU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Q6ACNd4k;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xGcIZ9Wm+WSSeosg9CDJTkTmHYD7k8AbIJs84ojn3vM=;
	b=XfnxDfB2AxaREmNDrhW15//SBk02k4rdzbPTYYM2LizWodU/zlCV0j01pgvXOx5H+dQw14
	i7CkZhrMmhRMUyrwcpQkCsNFDGxmjBPRk0yFxXAZGSBC3VaypGYQEFhoTkDgwj9RNtmwe2
	7FxywUC3FdivmLUUAhJSNgrBwBN/Ojs=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-506a747448dso28328811cf.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750149; x=1772354949; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xGcIZ9Wm+WSSeosg9CDJTkTmHYD7k8AbIJs84ojn3vM=;
        b=Q6ACNd4k4TH3EPh5W47FxxukGhwP0lkfYVPdW4ejUm/C9x9sgmPMJTF9cv1FKAcBJS
         SDpeqxBhIrxa6C3yFigaBPTULq+tMjPS5yi6cG4+cuEngB/aay4EY8WkqX3vzDX+Vnrw
         TTCxr1E/bB+zyFl/yBsilDzmkcxIqSr5vik1jkyH/VpepSMbH8T3wjkVOsa0h6scLkfq
         TEqkkfH4fjanmn0PHvyOXd1wjc2gvRdrWK492yT4PXajBZpzMC2O6mHw8J2MZXJM1bKb
         RKbIF9vmIcZcrBBWMrqHt+7sUPNtrTN7C3NmIMPcTT7SabBJ2zIAS9SZyPRro4bYvgzA
         I9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750149; x=1772354949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xGcIZ9Wm+WSSeosg9CDJTkTmHYD7k8AbIJs84ojn3vM=;
        b=i9po6apbJMpgeDlgjm2lZijmcQQGVCM8qpDlDAJyye6rCZyNEGJz1mfvQEPZ6+KMvA
         QEA4hk6p0i/BBN8fU1GFOtY0T0QH4HNbBI0w0C+UL8svwUQqky+rR1ZnWnF3eRsBJaHG
         ygD0GNaRnX399C+mrsSLQoagYdOj+0kamIDYDtcLzy209QpQy74pR7IIoxbAY8cMwh7W
         K+2c5QZkCdaNUBBbfXP8UHShMw/vBdmcmJPGswCEUcm1bRrf7tMCWZabg2zU+usDaBLD
         UmY5/Q6EzAlMZ2EhpWxkC6WPfCGBrY0zU0PG5cDFJzQtVvy1ohVa1qB9Er23sESCwsEX
         I7rQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQS+WYm7EphkNArNN1lwiCQLBL8PG/QQDhOqDPxQulpwYnSPgO8FQ6/Hkev/HWd7nevJd8AgYyUA==@kvack.org
X-Gm-Message-State: AOJu0Yz3Nh7+bwA10BEzRCMspIh6AaTo3T6eaC8sNOTkUSZrKigs0FWk
	vwqXwZhiUDE4c3sJbvS35Crcaicpn4j3u5MI8zsxyHbOC3ZSoRxsXvgBMQOb9NStwcw=
X-Gm-Gg: AZuq6aK+kJApp1myVB0t0JwSFn8PA/IxiprI55n4kijH+QgOTU+wf70j0pjr3qgS++H
	5QxCK1s8Yv2GCbyiOkMp7/t3TXNzQwxtFPkhqtApUsbeRmM11ZgR4fFBdJ+6Du4dOi4lR00hmiw
	TVHJ6pI55vnl1SBxNV0pl3lYFqbls0nRBzveopt3w71Arj2eUpfLJ7d6A2lXYt2rU8G+wLA+She
	Ko59AHfoIaj48FoqgXxCzZdzSoOT3CiTr+2AhGxBVyw1GWGhlzG2XWZeQVaIbdlc/mEwcJ/OM3Z
	7hhvZuBipYkAIPCSiVY2ONINogg+CqK2tza/nzX9Ad1SxD4zL+QGfHAoPnxIQiEB9eLGhG5XTCn
	2UhDPpjuTjud/duphAEMYDHZpZ/23fdWXK+J3J3SAyIBYRAU6YHBsTTY83QI5tJBjq7QTIX648R
	C7yX3CQWyVst85KEz4VMqUBpC/9HKZubMR2BL6/XeSBS+5f4pHS7pCHSuzp48RFGlDnVKAQ5oNb
	PIjUKTB/w5QLx0=
X-Received: by 2002:ac8:7fc9:0:b0:4ed:1948:a8a2 with SMTP id d75a77b69052e-5070bc68c0cmr70819951cf.40.1771750148853;
        Sun, 22 Feb 2026 00:49:08 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:08 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 04/27] mm/page_alloc: Add private node handling to build_zonelists
Date: Sun, 22 Feb 2026 03:48:19 -0500
Message-ID: <20260222084842.1824063-5-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BD9E4160005
X-Stat-Signature: g7ygpjfr3y9sg45794xrscig1j63gd63
X-HE-Tag: 1771750149-214309
X-HE-Meta: U2FsdGVkX1+AghxcVSbFgDgaAmmMMjuGQmgPnxua//PPrMg0Akdd0oszG0g6yBxsZz1eqFvQD/6aGt0QEeejRluQw2JY2E7EuQgIVi3gNglmbtg1g0tWpHO91R2dGftOzfV8dXmN4pus0xwLJxoKNMrBhYoCm00oncisIVwsSSUJs1VQQW5pouAR9mi41oS4z9iulNSDU/cnIssOlpoSlR7J8175BRqHvXlrfHDTVwCHq+WKITJUXIcEAAP0DNPPP6fIQc3RF/Nh1yrButknugpcQTy60mP6SAmlwLtfD02j7+9GMLXPn7PhMXcR5z4ygfnBrZFkY8GmuULFEATKQRM1fhwm0cDe+raY4rM/l5+467T/5ukHcMiV0A0I2zTAQB2T0w7ZhV22vRT106slwQGlswNuV/dHfEGhSvZQ63HZiPanUAtOX3fJbjTJyG/Mdana1HlGLEcYMIj78FPaWerC8uE3x6mtdKP0qFEZ1WFfMR3lqUTOrdxJ8d9DWxmYDZe1743LnH3MetbmD/wcoPBEOnqGcAPr+zh/AYBzL1Fl7zFWR7u3KLoYxZGVeHh6cvw3BA88iszImyzHec1T5PvsJ4XEHKxs18c/6C5q4TCZ1cMwIZx75CDjHD/VKuBegh73zWz1X6CGtTuwASkUQZRO+Egp/YKhoftCivpmBua7tTRe9VaJIGsB/JLTxXMK8moR0/Ur5Vc3O63X7jkcXPn7QJMPiwLcaUPk+cbW+OpJFrzUSBos2gPa3n8UtA+UTPHbF4BseEDMkSzY1DRo0KIqDEn3WmGZVz8cFCUtOyL1CbDuc5T9ZAJ0IXa1bH6ElPyvdiIY8sfUg3+CHHJ8xmozz64tppz6didYpDUtkI9eITdhyj6+umBzcMesa2vxFYtX4GBZO3ID0oQQpTx2N8WSH7QBX4Cv2A3UjrFrEU7eb6HQTmsPcQJk6/We1GJUZZ8mLJBx6i0ISH/uCmb
 j52i/d7T
 GME+qDyJDuqjwmJ/HA/6/ph94GE7wl+GrCLwqshVV+CLVSK/uWTVpqzrKWbuexEryTGbJYlkt7JyPYLCKT8cvKna5c2FOmRquqH8xnvLPLnI+KNGfxhJ31RrbIQlNDLFN9cPM7r5fTBBWH0U6BH9BwhTP+l6gpHljHZftyFA3gfYMzR7CSFl15eycST/739fqnSma9/aBNvoOOCOnG03OtZM3LsXqS5fupToTzHL78j8oTE+h5PR04LEOwI1zJApkgNyJPajuE3zbYWenFKrqlW9ys1aZtBb33cyd78zzJSSTdI13gG+cluiyWc32qVrFM2SI0ZAK0foK+mSrrW12wTxp24UX+As/iQZ7URdiWsuhthS2xNcr5JvAEFe408/nlObkcQThzxnIBkz8/wGQ9A4hGQLKwkdYqrsza1GLbq/5Csk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

N_MEMORY fallback lists should not include N_MEMORY_PRIVATE nodes, at
worst this would allow allocation from them in some scenarios, and at
best it causes iterations over nodes that aren't eligible.

Private node primary fallback lists do include N_MEMORY nodes so
kernel/slab allocations made on behalf of the private node can
fall back to DRAM when __GFP_PRIVATE is not set.

The nofallback list contains only the node's own zones, restricting
__GFP_THISNODE allocations to the private node.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 47f2619d3840..5a1b35421d78 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5683,6 +5683,26 @@ static void build_zonelists(pg_data_t *pgdat)
 	local_node = pgdat->node_id;
 	prev_node = local_node;
 
+	/*
+	 * Private nodes need N_MEMORY nodes as fallback for kernel allocations
+	 * (e.g., slab objects allocated on behalf of this node).
+	 */
+	if (node_state(local_node, N_MEMORY_PRIVATE)) {
+		node_order[nr_nodes++] = local_node;
+		node_set(local_node, used_mask);
+
+		while ((node = find_next_best_node(local_node, &used_mask)) >= 0)
+			node_order[nr_nodes++] = node;
+
+		build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
+		build_thisnode_zonelists(pgdat);
+		pr_info("Fallback order for Node %d (private):", local_node);
+		for (node = 0; node < nr_nodes; node++)
+			pr_cont(" %d", node_order[node]);
+		pr_cont("\n");
+		return;
+	}
+
 	memset(node_order, 0, sizeof(node_order));
 	while ((node = find_next_best_node(local_node, &used_mask)) >= 0) {
 		/*
-- 
2.53.0


