Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A74B7CD8C84
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 033386B0093; Fri,  5 Jun 2026 14:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26CA6B0095; Fri,  5 Jun 2026 14:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E155C6B0096; Fri,  5 Jun 2026 14:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2E626B0093
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CA8140272
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:22 +0000 (UTC)
X-FDA: 84846711684.01.4AF9C8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id F27C11A000B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XfzK9R9w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6yDcpji1C+GYUKGpWyVAnr/m2Kie2TV2BOTVneeC1s=;
	b=u2W/+wHnZ+d+gd2AVmeH/IvanpS2jgM4sZJiGASwHGz/Oqr88LYaSbvQsDafA3EyIPQ33F
	6vATXt9z1ge3onhcboJ5/PjYo6SWMoNSRF8/7Pxs5EmBYiqe7cuMMiPE2K3zIwaKcHfsBF
	BkLE63CNf5j6f9U1YmAdFer86lFVvkw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XfzK9R9w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684521;
	b=L42BY3536InThKz0cxMdzMaeV7oNbDdTtpQBGAaJFFJWf6r/0aCgwGe0q0GaxBAoblFvkD
	fG6RXf/ntaep1xcWCUahf861XDY7A7NPwzGyZbZ3KDSioo7xVy7AYdnvR191xjZw1BXB9t
	GgmneX6DpsirjiFrRnv3Cqvlw1CScic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E750E4385C;
	Fri,  5 Jun 2026 18:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14F11F00898;
	Fri,  5 Jun 2026 18:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684519;
	bh=R6yDcpji1C+GYUKGpWyVAnr/m2Kie2TV2BOTVneeC1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XfzK9R9w/+8j97Px+AmChM/ZPMAXQowShQTxBd5VUEBg+YEwWjMWhB0B6YsyVkPO+
	 GjB/7x0yCdaGCzZ8sxAZ/EE/hxP8QlxBiOJJ+gwE8p+KWWB/VuK1lk07m0UZTjsWBq
	 cyHcRCjsUdF7+sZjLUA5E55RAgute94fLjtEcDtAbM7hQ1TM76OZEObpy+PL8+M66m
	 kHWBuG90PapNjA3UsFO8LNgzplcVXSfi45kX9pPIaZiK7SocUu9CDbiBCr5JQDEXIZ
	 OFbQtfkQS4PwE3ghGzotdfuDdTBG3uACNcT5bA+3546BO52jNNQK4scjWbvzP3++qY
	 swHEtglvX23lw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/18] kho: return virtual address of mem_map
Date: Fri,  5 Jun 2026 20:34:36 +0200
Message-ID: <20260605183501.3884950-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: c59o3tkfyn4pmh8n5769rkn3zmy81r4p
X-Rspamd-Queue-Id: F27C11A000B
X-HE-Tag: 1780684520-59222
X-HE-Meta: U2FsdGVkX1/bGY7yeNP+Y4WqPKvmDdurG7agh9C7nR58Qevdk7j4PyNZVtnoLyKiuCICQt/li3J5HyH36aBUrE2Uvguwyzt7CFRCKGtvvKkBWaBciTZIoXAdc60gUVQBFIm9idoe+n34fubLrbBvGPtF8MPI6NCr4qEHflsZBEkfSEoIZ4ytY4Foy679qvvRDzy9b1f4RhcFKCMro7Wl+yWNmuIcx+JfHlQygO7WbH3g0krkmMLd4OlmBrBkHEZ+RA4tZDYETLHVfzbW95rJuCwgv/48an1JS3X+rDwh90ol3iVKX8jmVS9f+5S/wtvlhvnyvq5/6j47fCynIGesoIZQxhFc/uZUutycsiF0EWzhYfjcb1t9YmhtI9rbNd2xg/Kk3VwTovjbSaBrB0bSTJ2vNnP/A5/uPtLRR/anUnxFmiq7DptPz+m2F2wcvh1hG2D2esIgfNBDUnBPVEbh+fDVA5XSr/Ac+WrDE1HnOrLCkkOzgVpz8q27DMU6a1yWmfrEo7/Jv5KxQAdW+PlC9NOpc3WYd/0q2Fy3APqSfRWH+Vcww/FkA93sP9TN9zY14QJzzteEAPOCOF8s83KBIRUGLmxIDq7tSuzcLfUlbocifrdYW9QlEqWqYTrM+sdtxX299gsf0jw3tliKGPUY4pxa/ENwYGnxNtJBhgObAGX/ZCWMA2ZSJsF8iOG2u5TopPYGAmwNdFxCD9YXq+wAeFGuOGZ278cQ/67xzE938GiwmtchckZFbyOU53Q1d4v8xxTAH0wA6J7R7A2qOMW6TleWaA7B+lUwi6RTUPc0XJ+GyXLWdzFzI6AfRRPF4LbIoUcOk2VsICLfQmhQkp4Q3H65sP4SJvYSejQrWO0vM8CGx3xI6/O+fk5uSATdfcjzHND95QZjj/YTy1Ira7PGY4AdKGNCxYkps+oIUwHQMJti4Ho9IP2RJphtKuXmxfNOdDyZfRcqA1GWpmL8Uyi
 12q3yj86
 lbQ/dt4Xrzb2N6cy7TNC7lCTmLZxW32c0K0OCGDXBbT4VJDPkZeRL94EiYM5WALcDtx3dSXKLEO0RveCTnoCx1rSmpiq3KazO6lXffCa9dndBkEdH7Yok14NzWr4wbO8wbtvzmag2ynVLOq5jTlM/KDDllC6pWGoUJC8eZdfBn9eZvuugm/4gOBOsIyt0H3jttl8Tnz9xMFZfo1WyIP/VrsOjDdh7m3bKSTJRq8WBrWNqbLH0GLT3u3JuPh8+3CoP5vwe9TRzYCSzjEWwLZ1q0Ov1sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Currently it is only used by kho_populate(), which doesn't care whether
the address is virtual or physical and only cares that it exists and is
valid. In coming patches, more callers will be added, all of which will
need the virtual address.

Make things simpler by directly returning the virtual address. Rename
kho_get_mem_map_phys() to kho_get_mem_map() to accurately reflect what
it returns.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index e8454dc5b489..d8dd0ede4f87 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -509,10 +509,11 @@ static int __init kho_preserved_memory_reserve(unsigned long key)
 	return 0;
 }
 
-/* Returns physical address of the preserved memory map from FDT */
-static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
+/* Returns virtual address of the preserved memory map from FDT */
+static __init void *kho_get_mem_map(const void *fdt)
 {
 	const void *mem_ptr;
+	phys_addr_t mem_map_phys;
 	int len;
 
 	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
@@ -521,7 +522,11 @@ static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
 		return 0;
 	}
 
-	return get_unaligned((const u64 *)mem_ptr);
+	mem_map_phys = get_unaligned((const u64 *)mem_ptr);
+	if (!mem_map_phys)
+		return NULL;
+
+	return phys_to_virt(mem_map_phys);
 }
 
 /*
@@ -1644,8 +1649,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 {
 	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 	struct kho_scratch *scratch = NULL;
-	phys_addr_t mem_map_phys;
-	void *fdt = NULL;
+	void *fdt = NULL, *mem_map;
 	bool populated = false;
 	int err;
 
@@ -1668,8 +1672,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto unmap_fdt;
 	}
 
-	mem_map_phys = kho_get_mem_map_phys(fdt);
-	if (!mem_map_phys)
+	mem_map = kho_get_mem_map(fdt);
+	if (!mem_map)
 		goto unmap_fdt;
 
 	scratch = early_memremap(scratch_phys, scratch_len);
-- 
2.54.0.1032.g2f8565e1d1-goog


