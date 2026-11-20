Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67AB260A2604
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 17:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.de header.i=@amazon.de header.a=rsa-sha256 header.s=amazoncorp2 header.b=KiOMKkOF
Received: by kanga.kvack.org (Postfix)
	id 8BFBF6B05B4; Fri, 20 Nov 2026 12:48:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848FC6B05B5; Fri, 20 Nov 2026 12:48:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738F26B05B6; Fri, 20 Nov 2026 12:48:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 506DA6B05B4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:48:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE104C0131
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:48:38 +0000 (UTC)
X-FDA: 85456232316.22.BDB112A
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 834251C0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:48:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=KiOMKkOF;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf21.hostedemail.com: domain of "prvs=777ef8cfd=gyokhan@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=777ef8cfd=gyokhan@amazon.de"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795196916;
	b=2rbgu9QCYURoHkDFryAqsM+p7CYWuJZuV6U0wnDN+AapQGMiDVUQ0EQez9LE/eXRT8fmf/
	Jov6SSSeugrjHdpCODZgcEuPr9WW6aZlsqt7isBNWheethRp7TkcN9/BD2Ro+F7jvcQuXX
	JlGpT9PoDDRUd27YQYgv2VtCIdRakXc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795196916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsbggd7FVuUIcji1gpPFNhxZ64Ua/0KjzwIsAaYXXTg=;
	b=u/CqByeEaY06xTn4A1xmDXvRquxRlfsQrm1WsxH4qSwO4FgeCbQPCc/KR8D73TBEarRsEM
	5Og9VzvY1idgk32NT84Q5gIrR6XSnE8Mi6ro/YQnwUjsn1K6ldby1hx0Ch1fPYaoJ/J17d
	hWO3frrQgakqsJ72vS6b16quDIhZ7ds=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=KiOMKkOF;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf21.hostedemail.com: domain of "prvs=777ef8cfd=gyokhan@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=777ef8cfd=gyokhan@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1795196916; x=1826732916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wsbggd7FVuUIcji1gpPFNhxZ64Ua/0KjzwIsAaYXXTg=;
  b=KiOMKkOF1W5J5VOCfdK0fBcbidX5T+svz6mia1lDMa1/qLF1klIaV/uz
   PsMa/O6+5hRLF11JNqmgCFS1hYFB56ca50D5CWgcBzlgeYtjoDUm5Mmg9
   wLDKwRP6bAjIclrn6l2lTWq2JzKM9pczvrgTADJoUI7ouMx1HT/H4CZtf
   dl7R+9RYwJ4A/MB34WiABrkkj/lif7j9MbtxTLNz5/rqbYGVgrOgM0oBY
   dNeus8SAJ4Azfi1psVTZ99Rbre4W9Lv3KyvA1s4ntAml829y1aOv+KBnK
   uuVicZZyQEJxqYVfFoK2XAjld9k0tn/G4HflseqvWOifDby7anLwlMKqM
   g==;
X-CSE-ConnectionGUID: g8WOWWiNQ42Qc0P4cGAa/A==
X-CSE-MsgGUID: +0RKad1ERYiq6lA4Dwx1xg==
X-IronPort-AV: E=Sophos;i="6.27,223,1787011200"; 
   d="scan'208";a="34665757"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 17:48:33 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:14677]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.48:2525] with esmtp (Farcaster)
 id 9997a763-e53b-4569-9299-9fda4c6f95d3; Fri, 20 Nov 2026 17:48:32 +0000 (UTC)
X-Farcaster-Flow-ID: 9997a763-e53b-4569-9299-9fda4c6f95d3
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Fri, 20 Nov 2026 17:48:32 +0000
Received: from dev-dsk-gyokhan-1a-87ab81cc.eu-west-1.amazon.com
 (10.253.85.128) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57; Fri, 20 Nov 2026
 17:48:31 +0000
From: Gyokhan Kochmarla <gyokhan@amazon.de>
To: <stable@vger.kernel.org>
CC: Mike Rapoport <rppt@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>,
	<linux-mm@kvack.org>, Benjamin Tissoires <bentiss@kernel.org>, Jiri Kosina
	<jikos@kernel.org>, Luis Chamberalin <mcgrof@kernel.org>
Subject: [PATCH 7.3.y 1/2] mm/execmem: handle potential allocation errors in the maple tree
Date: Fri, 20 Nov 2026 17:47:44 +0000
Message-ID: <20261120174745.3785179-2-gyokhan@amazon.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261120174745.3785179-1-gyokhan@amazon.de>
References: <20261120174745.3785179-1-gyokhan@amazon.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 834251C0005
X-Stat-Signature: i14gqcxu889bpxgxk89dyyytnhs8j8qf
X-HE-Tag: 1795196916-187133
X-HE-Meta: U2FsdGVkX1+A/+34UQdq/0tdugFehnrukQ4IFkDOpps/Ibewdw9684qzKy/VNkAVyzw+p4rMWEV8FXpb7Lur/OKxzoi2CMTD0fMDPRtS7gvM/vlEQ9CBA9h+bL+S0vQTTEEcMHrpRy0mB797eUpwDo/UAC8djxPqTKJXMV7f0cSWRddtwBuk/By1cl0Pbp2KGhzEjT11icOs5fORQNZVYT2guwttRhpl2gp2Q/KPAXT+N8eU1F8CFat2EFYQPVnl5EMFrEOFlWrIlvK6MxCw2KD3VsFdxv0a53/Oka7BkxJYw22yG3pC2Sf0LQE+jsBpFP7QfwMj6kX73lASVqsNsOD+1Vl3YvjtmSUrDlZZsMiV2jLDy0RGVcO/PWhzp2FXlBzD3ibKwahSf3xNt/E0uD/53kN/F/GSMphy4UwhC5I/yTU8VUECjKWZEKI8gzO6Z0eP6KrNnxm/Ke0lbhRrBc0SO1DzvVNsK7hxi6NWc2GYj8sR6E+B686A9NX10RU37HocwnR8jHtNCmbl46WX+cJtpnhThNEWThgAvs/zDJW20nlyZG/rLNuLuP+0vIkC3fqK/IdhiQhAmdOFqTvr7giQYQVgJU1MsxGmCR5pV4yFVu4MzxNzEazHsOfBnRUEhjSXtRGPf1inathvEIsgb0VDOaltiLwTr7KWWYC1BL7qk+ZDf9MSAIHLtsCjJgTKoPPUlT7YUwzrhSgx0I5QhIR48ycsn7PzK3pibnZptpU7Ftoq6SHF+TuIVBTdqSwtaeiQjQDunhET+PWeS+CYHQa6vEFuqnwMnrdb9jkixNVI92LT/TMOqWoB8BTxfQg/PzNtgssx0z3PNGoljNzKdELgA2vAPunsWg3LGLvhPDsJdmfd4uEbBxxyrBEhqulhwjj/xpyPy17WkofliETUdRjDw8SamSrAfgKYe97e1T2HjSU3Y9HXFcOQcr9tCBniFTWdIhexugwwqgs/KY8
 A9pOgmGW
 0yYiPBYEzl2W+DkF/AYAikhqbUkMYk8zp5pOvp9FSE6AVcsiCMhJjJldMUegQrS2Oav+5Xvzvooo4xE/6zvA7cLNo7HotBgLJ3ZCKssNOUmkhXK6+m+9fX1pLK/Tv/hVHVyEJFgEqWMFdoY23EOFEVjZjVstqMC3cF18Af6+ahq4hcSWIraviAh1wWZEPzb7m1ppiELkMTUC1q3RCH3LU3Oz0B+50HotLeIN/qkbFDybBCZmbqia/+qKF0Ax4NS1VyJMzNHJIzETIFdIRNtLUH0YDgalaoMNHJVJltQacZlqryUdKfV2Y+cp3Z833pvEyEDD1tF3LV2BSdmCY1B2t9vmoxpGzJOJvQJX5NoQdEwNSeFuaKibc4azM6f7RZfcyp5mlcvXBgvwyH0z/puFrnPavE27ioGCtNjIV0dDIcdBvhJ328NTVMBdfiBTbgLk96HWBqzaEJCypkAUOeR06SwFzNqErTf/pCQHfXHUSU+BUUhkKEhaZaKcc1r8TFWcySY8My2SC6ensZI78ohresyattJmncsZ28izmNIgnTHVhpM59oV2O+AuqGHnf3fObEIsuzKLsXg02my80msarfqPXDWMZx2/49NNnANybrcZimJ52TCLlWzdzNG4k2dP/16kKWYHkdBq8dgTyM38wb6/RlGDMMWMMHOADx29eUEaZQElNBAUGkX2dvtG2fawDjhCkffT0V126ksd+LQCToj8ep67L0QkCIS+cAVKn78n7UmmYD/440IxRTKWHKNP1mdK6RkE5dTQUO5GhY5TxVer5RR6+/WgP/S7B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

commit d80773cedde2eb66e5702d383b5eff0190e7693d upstream.

execmem_cache_clean() and execmem_cache_alloc_locked() ignore potential
allocation failures in mas_store_gfp().

While in practice they are unlikely to happen, it's better to handle those
errors and ensure the integrity of the ROX cache.

Preallocate the maple tree nodes for the stores that must not fail and
order the maple tree updates so that there won't be any failures once a
tree has been modified.

Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-2-11beb2a3d249@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: copilot:claude-opus-5
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
[ 7.3: 4c4b2ed5b783 ("mm/execmem: use VM_FLUSH_RESET_PERMS for ROX cache
  allocations") is not in 7.3.y, so execmem_cache_clean() still calls
  execmem_set_direct_map_valid(). Keep the call and move it after the new
  mas_preallocate() check, so a failed preallocation leaves the chunk
  unchanged. ]
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.de>
---
 mm/execmem.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 33e4e68f655f..3857955e701b 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -173,8 +173,16 @@ static void execmem_cache_clean(struct work_struct *work)
 		    IS_ALIGNED(mas.index, PMD_SIZE)) {
 			struct vm_struct *vm = find_vm_area(area);
 
+			/*
+			 * Preallocate to ensure mas_store does not fail
+			 * If there is no memory for the tree update, bail out,
+			 * next execmem_free() might be more lucky
+			 */
+			if (mas_preallocate(&mas, NULL, GFP_KERNEL))
+				break;
+
 			execmem_set_direct_map_valid(vm, true);
-			mas_store_gfp(&mas, NULL, GFP_KERNEL);
+			mas_store_prealloc(&mas, NULL);
 			vfree(area);
 		}
 	}
@@ -244,30 +252,34 @@ static void *execmem_cache_alloc_locked(struct execmem_range *range, size_t size
 	addr = mas_free.index;
 	last = mas_free.last;
 
+	mas_set_range(&mas_free, addr, addr + size - 1);
+	if (mas_preallocate(&mas_free, NULL, GFP_KERNEL))
+		return NULL;
+
 	/* insert allocated size to busy_areas at range [addr, addr + size) */
 	mas_set_range(&mas_busy, addr, addr + size - 1);
 	err = mas_store_gfp(&mas_busy, (void *)addr, GFP_KERNEL);
 	if (err)
-		return NULL;
+		goto err_destroy_mas_free;
 
-	mas_store_gfp(&mas_free, NULL, GFP_KERNEL);
+	mas_store_prealloc(&mas_free, NULL);
 	if (area_size > size) {
-		void *ptr = (void *)(addr + size);
-
 		/*
 		 * re-insert remaining free size to free_areas at range
 		 * [addr + size, last]
+		 * the range matches an existing entry, so this cannot allocate
 		 */
+		ptr = (void *)(addr + size);
 		mas_set_range(&mas_free, addr + size, last);
-		err = mas_store_gfp(&mas_free, ptr, GFP_KERNEL);
-		if (err) {
-			mas_store_gfp(&mas_busy, NULL, GFP_KERNEL);
-			return NULL;
-		}
+		mas_store_gfp(&mas_free, ptr, GFP_KERNEL);
 	}
 	ptr = (void *)addr;
 
 	return ptr;
+
+err_destroy_mas_free:
+	mas_destroy(&mas_free);
+	return NULL;
 }
 
 static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
-- 
2.50.1


