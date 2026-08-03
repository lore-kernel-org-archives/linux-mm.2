Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99196C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742746B009B; Mon,  3 Aug 2026 03:13:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719586B009D; Mon,  3 Aug 2026 03:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656796B009E; Mon,  3 Aug 2026 03:13:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 440B76B009B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:13:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5960A060A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:13:11 +0000 (UTC)
X-FDA: 85059091782.13.4865F1F
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf14.hostedemail.com (Postfix) with ESMTP id 98C6C100005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:13:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=a77cGzyh;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741190;
	b=YYV/FlQRYzA1fpAH5jPfEb4a+0tvJv2PKBSe0+KZ5WP7nigFLCi3s6ZFUV9ajO3pTw/QBc
	QtWb3WUtSgu0Ku6rdGh5UAO4rdKn8zz3z7xUaTxD8MF8JBLSgzAGWjqxy/IShdMKgtcnhC
	BA7Wms8N+sUOxQ0DLYfCJ7ArlTqlmbQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=a77cGzyh;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noN9zN1awgD10Dy4RdMcJEDTTzNu8MQNGVp8sfEJ5vA=;
	b=NF4IxBPjr/ChIzDapK1Q4jkWxVBtI9jtFc7gmlMmC2Vxn/0aHcLx4Atl34mUV3nHISM/q0
	vMIcBO3u4RWqNHc0AbbLpKjh1aHb6mMoXvMH7LFt0p0omDce31PagMl+yncRwAEn0Ze+iY
	/quL31Mm+gKVvvA26BZNGmcUVwAatAM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785741185; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=noN9zN1awgD10Dy4RdMcJEDTTzNu8MQNGVp8sfEJ5vA=;
 b=a77cGzyheUK5x4Qrks8+8wwwFHSPTGxXLt+pCCVcaxhQejz0d9e7FTyTBl55Xvnm4ta60k
 qI/LO4DuaPlzwdq+ZDQf6nuVRcvK6OmzUxYn1QARjQm0wx/OePC5Optox2CYYZ0VSXGFHP
 p7k/nUzVJKXs2VT4ZV1GsvHhYujz0D+pmyL6a7iYbjnACQiYaNft5bcWjBLbHDEQLxfKxF
 8ibykQJV0YqWsLi+dIKQuY2t5lTvObUO61KSn3OSmq6kFuGmn3N94T/kMIr+vYucD+D9Dg
 ppzz+WUUA7F+9bh86PEx/B/wi2HW1QfPMTNBXeLGO1HU06NQirRX4yiNuJ8Nfw==
References: <20260803070929.86075-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <20260803070929.86075-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a703f7f+1f1e37+kvack.org+lizhe.67@bytedance.com>
Mime-Version: 1.0
Message-Id: <20260803070929.86075-8-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v9 7/8] mm: use memcpy_nontemporal() in zone-device template copies
Date: Mon,  3 Aug 2026 15:09:28 +0800
X-Stat-Signature: 9yyam7xkp6z4e4gy3hjjb56azfkysopu
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 98C6C100005
X-Rspam-User: 
X-HE-Tag: 1785741189-719642
X-HE-Meta: U2FsdGVkX19jRzGSqwU1CZH86cw2fcqZWoGBX1rYxORzeiSVCx9XXAPEQbsN40FbEtwLyttSFp9+NwOqVtH1jc7rP/iIJ1aKqeP40f+47xtYDJKmVYZ1iBrG2q12M12/GOAP8712fUaw3kaP1MY/IEstDnK/LJe+zG2Vt4DMR0rLvV0rIJMmmDmjVPn9x91EWiYIgGOkWsDKNDYMl4biZtl8DHKZtjIqH1yv9epjdA952cDoxpDIpaX4j/G2w473WsWfswt+KOk8o7DPb+nyU9/WBR/N7ECXJryN5Bhvw5jV8lu1Ohgm81MPubHzlIP6L87gi4958c24q2jEjWiIv8W3Tz6Aeh2uN7tF5nmFoJF0Vpp3lyd+bVhOsHTT7SAkaTIkYsbKYNLbkHzA1K8t69Di0oj2f7GR6P+uO0Q2CgcCzEyNcZTyceOZaQ+HBT+cmO7UnAaCes9lGRk9cfIYBWNrWwhmjYyw/MDwk9A6eOq8b6nKCAdRzgx/MqDPXtVh7uiQ99YxDRs2faSjH1f45Qyk9GEtrOO5wsyDhueMSJoEHB17/QDp2v1kh19LQPg8tgVEPkKIOszrZU3DmdHg+UEe7d2hv63DZpAGUDAavPirSn0g5Ep22oktRx9YOehNVhUicY2IDyuxRvVhvRnqsTdk76ZTQd95bpfbc+Ye/yPvWlmtMV8chf2n0wxiQ3zPIuLACdgwC+E6gJFoW8ZDYBrtpjKGitBMCk2ry8sYmM6CaHljuTvkJz3JUGWiPwTUTxE+nznSSobOuWiZk1fwbCk+zVd3sDCtxM08iNMBBgrPtHv3FsmLQQGqBIPefoU7C8wvh0rDLNedVihtp4n/L7TJYYZ/iTAQiL+8kwI/LIIwcfm+BDEVJpF/pkUbwzK0Hto6fagWjw9XhQDoBb6BF2kmcO1XpVE6qTDT4E+/CXV1vbh1/FjBUYpPhlHisKORdrGgvAzO3pb9qDsj4Jl
 PgU71DEj
 VSy4HXOULZZI0WK8TYFp3cPib7hKiF9alJ+hepbAEKwIcTkdfJ7gsolr3eim1dcaeJCteyaGj8GkNqT/KTe/yjngZmUEcHKTAJzEWOa0YSfAhGb/0E4f2+FAJRYPjj1g1YcN92ODZUpOfORwmdGhP+Im+BeSb57BIXPTLvHeTrCPHWVLVhlEvff+kiwb6iq2qIa0v/QP+ayf2ivstyowMp58yETkHsy+oRIShs1VTLjoonyhD2q/4bYb97cVd1wXyHewCF5vXG3PCqauNevKojFvHvXaLd1PtL5xPi6K1IMoNEvnt3Qux+d/xXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template fast path currently uses memcpy() for the actual struct
page copy. Switch zone_device_page_init_from_template() to
memcpy_nontemporal().

ZONE_DEVICE memmap initialization is largely write-once: each struct
page is populated once, and most destination cachelines are not expected
to be reused immediately afterwards. On x86, a regular cached memcpy()
can therefore incur write-allocate traffic by pulling destination
cachelines into the cache before writeback, and can populate the cache
with data that has little near-term reuse. Using memcpy_nontemporal()
lets this path request nontemporal stores for that copy pattern, which
can reduce cache pollution and avoid part of the associated
write-allocate overhead, while architectures without a specialized
backend still fall back to memcpy().

Do not add a KASAN/KMSAN-specific fallback around this call site. As
Muchun pointed out, special KASAN handling for memcpy_flushcache() or
memcpy_nontemporal(), if needed, belongs in the low-level helper rather
than in this ZONE_DEVICE caller.

No separate drain is added here. memcpy_nontemporal() is used only as
the copy primitive while memmap_init_zone_device() is still initializing
the struct page array. The ordinary stores that follow in this path,
such as compound-page setup, are part of the same CPU's initialization
sequence; they are not used as a publication store that tells another CPU
or device to consume data written by the non-temporal copy.

Therefore this call site does not need a helper-level drain for
correctness. Callers that use memcpy_nontemporal() as part of a
producer-consumer or device-visible handoff must add the required
ordering themselves.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.2-rc1):
  Average of rebinds for nd_pmem driver: 244.28 ms
  Average of rebinds for dax_pmem driver: 273.31 ms

With this patch and its prerequisites applied:
  Average of rebinds for nd_pmem driver: 150.83 ms
  Average of rebinds for dax_pmem driver: 153.55 ms

This reduces the average memmap initialization time measured during rebind
by about 38.3% for nd_pmem and 43.8% for dax_pmem.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 9691fa2a060d..bb2007806a28 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1101,7 +1101,7 @@ static void zone_device_page_init_from_template(struct page *page,
 	 * to the destination page.
 	 */
 	zone_device_page_update_template(template, pfn);
-	memcpy(page, template, sizeof(*page));
+	memcpy_nontemporal(page, template, sizeof(*page));
 }
 
 /*
-- 
2.20.1

