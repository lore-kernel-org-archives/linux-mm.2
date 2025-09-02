Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D93CCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95E88E001E; Tue,  2 Sep 2025 08:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E473A8E001D; Tue,  2 Sep 2025 08:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5CF28E001E; Tue,  2 Sep 2025 08:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1CA48E001D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:50:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68EA21D9AFF
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:50:22 +0000 (UTC)
X-FDA: 83844293484.26.D09F36B
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7562FC000F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:50:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=jaZqhi2L;
	spf=pass (imf10.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OCLJ7IL81yMCm3CkgJ6YDqd5R6ee+khIMm++FZhsZD4=;
	b=1ILH1XhfZYAvyhLE+V4eUZwyJ3CeFi4tTHZlzyyw6V2B+1l39XHs88byd4f7yWDAik/C3A
	veJ1qVs845kTzovypo55TtPLErG+ML9cMJb7W8vJKQAJGeS8jZqoZA2ls3+fDEBEdhVnfZ
	nBlbXDaOPsyVz9MDop8sRzVoJlH9X6Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817420; a=rsa-sha256;
	cv=none;
	b=Anrxd6xeCzn1JwEtwb8pMncAM2SFQNUqb0IQoU3fOmuvlhPnDzo4URmgdpFCZunRbsrh74
	sP3bk9+jt4q+ggRlrKucMm8LCwQy5j6hC0Cebbqva2+Qr0U3QMxf8b5FtS/lhG4gCmdfWe
	thkNDV8xg24il7kuq6sX4i56gaWGVhQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=jaZqhi2L;
	spf=pass (imf10.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OCLJ7IL81yMCm3CkgJ6YDqd5R6ee+khIMm++FZhsZD4=; b=jaZqhi2Luu8YSodhuadft0VC/J
	Umw97nj2ZI8vabQRSvpDogs7pWcqH2MdDlg63NSePyMA3ZI70QaVZCYGamLBT5jWSelo5ds4gg/hg
	JUjy8aksdRxUVsIvai2AcRoFzG/meS+XuLJefRPov9ETVNmX7TzO6dbbb1ywAicOIus991UjeNVTs
	DAx9VHfEEDjOy+G0xQYfKFiE6iUs7b+R/DUk9GzDmMNRHUIj3+kgMORFkzIIiKwNN1E8DJnRnaVYP
	tzrTQzkV32QBUh9N8n//3sAgVqPz9/V1uCGztpRkTZsGKRM0kkHAmN4sVGNHhbUzhW8/K5MFAxe2+
	Sb5w6qag==;
Received: from 179-125-64-234-dinamico.pombonet.net.br ([179.125.64.234] helo=quatroqueijos.lan)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1utQST-005hVE-LJ; Tue, 02 Sep 2025 14:49:58 +0200
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH v2] mm: show_mem: show number of zspages in show_free_areas
Date: Tue,  2 Sep 2025 09:49:21 -0300
Message-ID: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20250902-show_mem_zspages-d090ea0bd1d4
X-Mailer: b4 0.14.2
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7562FC000F
X-Stat-Signature: zjk86hihdx1ajbzpya9rzxcujbbm37fe
X-HE-Tag: 1756817420-779692
X-HE-Meta: U2FsdGVkX198D06e4T3nW7Q+rfWsII8LKOjpK4iccHMYYlVNCkJO0wCqPuTYOm+a6138EhAv1xtCvTYSFoJTn5ZKEX6KOYIQGPYeruBkeMaMJBh4ONK9W7lLvSeFEqp4ryzIGdgDZqGCpj8u2lTg8Ch0ajhFJfcWh/qzmWFcwr/N9sHXOsdGz5F/83UMwz7A2GQGuU/OlHOATx04giROm5GtdGDh6U1mBdgct5SV3ntc3kaa1zEEOmc0ljt4RFqdZW7uLtgB1gHAeBrIrDYdUCF28ey2TpbnMSeP8KZ05sJnOjh9ilwZxej3+nsu5NH8G5Tfm7N4eOI7/8rfhw0zTHhe5NCUb7uunSRRwNxdOsGNiI2j3RBoeoJdZQo4BoPiiJNEy55nVWhtK+ZNYLF0Pg2DVZ82zmwO9FOHg5NNdUtj3fG1oEsKo+8zqMABg6wMujBvRZlRFJAqsqJiaiW47xFQEf0+8q8cAkEexoD3pvIIJqVBcrDZ4iGgZieEKGvaOGG3zmervmapa8zo3Iz+RRQ9E3Ih5VyCrAgfRZPc00sKxWgJGYKwv0HyI2Zv3apgPMs1EtNoamWmbHdSBIYHrF05LbIn8tfquzOBdLrFUDqUq9FZBrqMRdoNw8wULNnym86lX4THR+z+mFElYVZFQRVTg8TxwkzSUUS4+jo2Yo7u7mr/IXDXrz58X1951YzF3rmrYdswjM9oDfavBY0WXjgaG/R7ah2bY4JKtTOqvgif/TW0tpWbf1Ku4BOn6N7aewVhcO+bFWsR6KQIEdGJ8pYzhlp/xcfJT9MXLtsgbOUSvzDT8+7jmyJIbcoD5HVuOAjZMnsRFLdEn4Tvw89Ia5JBQLhOq7J+guiNtXkvl9xfUai3fuw+7cUmeoK7Z8YY3JSXuLYurfTOwWa42vSJ00LUmF7l2rW6xYQNDj2HhWl8N7wJ73z2AHuG3vPXlJGui+Vs/yUo2ibykgUwQ2O
 1Y/dSXxT
 87dw4gHUnWcVZ1y5bjg/Zu+pwLbJo/dFSsz1wsv9RIl+0JsavQ5rWdX8nJxT5KVOCA4vWNeazaiIK3+2BHhgtBnYgyx5hqWmkgFKDXY3hu9gasskYDsT5NTGEgsn13vLSFJCymhcMHe67rLCBi9lSrgSOh4Lli1qwgkI714g3send6zIJa8sMevzO8mCiXOM/GCHdGqzXW7TAFwB5tXPb7IsqATMAYxOX3w/7gdAQECyZ6cktHzQae0uxkpxCXnCzLKIGl/mJzFiIeismcgu54ae4h28tamOBxt+3z3wQoAv2rGdcQHVMvaWonVsybcHg+afZ0pW3u4M18SJBZbPUVWud2EfEoBQ55pidoFF0brE7W9Kk6BCx1YER4uTnRTTLHLBZ8GLA4EC+CoVJz14FfCnSg3R2gYlox7thTfqLeaX/u01zFryA1Hy2DHtcwPDfygct0jFKjGPK4Jw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When OOM is triggered, it will show where the pages might be for each zone.
When using zram or zswap, it might look like lots of pages are missing.
After this patch, zspages are shown as below.

[   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[   48.792962] lowmem_reserve[]: 0 956 956 956 956
[   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
[   48.793118] lowmem_reserve[]: 0 0 0 0 0

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
---
v2:
- fix build when CONFIG_ZSMALLOC is not enabled
---
 mm/show_mem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index 41999e94a56d623726ea92f3f38785e8b218afe5..c563d9adfa87765a8736e91c1f68d824b03eaea8 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -310,6 +310,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 			" inactive_file:%lukB"
 			" unevictable:%lukB"
 			" writepending:%lukB"
+			" zspages:%lukB"
 			" present:%lukB"
 			" managed:%lukB"
 			" mlocked:%lukB"
@@ -332,6 +333,11 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
 			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
 			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
+#if IS_ENABLED(CONFIG_ZSMALLOC)
+			K(zone_page_state(zone, NR_ZSPAGES)),
+#else
+			0UL,
+#endif
 			K(zone->present_pages),
 			K(zone_managed_pages(zone)),
 			K(zone_page_state(zone, NR_MLOCK)),

---
base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
change-id: 20250902-show_mem_zspages-d090ea0bd1d4

Best regards,
-- 
Thadeu Lima de Souza Cascardo <cascardo@igalia.com>


