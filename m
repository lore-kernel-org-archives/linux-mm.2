Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6F06C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858C26B00A6; Tue, 22 Sep 2026 04:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830156B00A7; Tue, 22 Sep 2026 04:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA806B00A9; Tue, 22 Sep 2026 04:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2306B00A6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:22:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B0958040A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:22:25 +0000 (UTC)
X-FDA: 85240706250.28.A43E48A
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf17.hostedemail.com (Postfix) with ESMTP id E078040009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:22:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=okv37IBh;
	spf=pass (imf17.hostedemail.com: domain of hanzhijian1991@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=hanzhijian1991@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790065343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oUr3HAAwa4UvQWi/4k8Tfe5hK+C7gkHWvU1DdGzSu+0=;
	b=eEAjmqqNBr9EqeP/Xf57tTkZviPVO0KrphTiNkFZEKjhk5pdLhvk3FvcqvNYNx3Idx3bRV
	s+4vkfSp5atoxHMJVm8nv/paUNwY8jgrth2H3/5wDiw+wPZAHsQxiI88leUsQrhjA3dr22
	iu/1WquLyCSCtJHteM6IQKLy2q6jF4M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790065343;
	b=gyviz27C8D5VNzPM2+TjNkyXBVPqCKinsR0rvbaIqBmFJS9YOQK0u/5lfZFpdaV4AilOdo
	PpAph0/1zEYqkqKXjholo/nsZB2JX3FrI8vvySs+aJxvyVH1hZIYRzApG+kvq+FEQpPyQF
	8LjFCbMYeAxAvknMduFuuCNu1XWOTp0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=okv37IBh;
	spf=pass (imf17.hostedemail.com: domain of hanzhijian1991@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=hanzhijian1991@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea50dc0so1680371a12.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790065343; x=1790670143; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oUr3HAAwa4UvQWi/4k8Tfe5hK+C7gkHWvU1DdGzSu+0=;
        b=okv37IBh+sG4VqTzHIfzUnRwxFMqKl2nLpQ4DonBV0s7wA+hl8/rgcEb6NVm//u8KW
         uM7an2manfuTXU8pMshtXV2S4rDmUYdlQEh99VNXeWb5h7/nToxtAfeKwYeOXkCrvZhC
         3PT4ttm3qLC3dYffoyAPMktY8pQFg0RjvL5NiEUxQFgcUVRlpoN73nmvI3Ro5sXk1vn5
         4eY9QOqc00UcF43FzZHTAgXGFwJ9fQ+41zh7/I7fImIj9dNmpCL1cQmPastSMLbIMTfo
         1ODhEKnwaHLDbYGiX7FrJ05nmCk8zRh3tg/qnyWw5PmtNI+lIoEAjvPnKuNrv6c9gYAx
         Y5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790065343; x=1790670143;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oUr3HAAwa4UvQWi/4k8Tfe5hK+C7gkHWvU1DdGzSu+0=;
        b=X5nO+R30ebGFF3vlf1s26reE6SjV0lG9EwYrcIaPajsXgjNduYZEP8bZQ/IDFbuovA
         nuqgqDx+x82ozzTR1oO52XUkE+BwkkieWRx2EadNR5DrN2Hlq4R9nN6DkHCPzg/YbRGA
         I72w9cCzGa7sQTwCjKMDX0z5u6XLFkVEdnNMei+6hiV04gNV7Fd8+6umCJZuLtLaw9jy
         lcR3nUt1h3c3jKsYXD4UTRL+NxC+vYshrr9jmOmX7sipN+QZtyi0+OVMvCIEEDVauuhX
         5GlBtgEbQFK9fSj+Zdq2kGypt+0WcRiojS03Ov7NzXFmzTKd1J79rFdMTcw0Y2aB62N0
         Iq+w==
X-Gm-Message-State: AFuF++kilB7tI8fU9TWjEa9iYm+1tevn5KZX+T97EufwDLEObITykSZa
	owxT/sueZO+ycRcU5aMaMPKy3HAnYOBHsISiIdkktrARYcI/WYU58EMG
X-Gm-Gg: AYBFou3SW8lc8CxWigyNbkHnXIAUgB7XWzg4BrrlsWZIrYcENwoSeKKZmthyO51A3aq
	ZteOHWXfcNmr4l1+jE7bm3fmLbu2W/LzgnCImwNk+flXehAFTh0CbdR9dwevm7v05cWAkpFscEL
	pEA5pXfsWGRHnqSW8/nSyRmzIfUA3fKj+oQMHgGE/eObWJdohb4ahqJcYTzpDddUkuXyCc3d1JF
	U5uh6u88zLJXxTKwcLGLbJTN9M7AhMvDKvR8GfE0qJWu2PzYXu5o8oud9NNVIP3ozei6482JCdV
	UdBeK9P63bS62OWaz45RmM/Y+aZFmkgBrI64sdqIe4xHS2JhXzm4a3zFopblgpdzMxIxtISwhl+
	QGxBpAaWnyhu/HataMDBLcSVOgoXoDXCOd+n5Xl4Kq359jRECRqBBkcnqQbCkKtfAn6G1tPkosY
	pbD7ILjl7pW7DG/ln5PRZ7d81rD+qeCvP3rqOkmyW1m/pWei+u83IWkRqhOnYyQOzVk1je4lLKs
	/8vsx19fVUAgkAX4+MNtlvQLuw7EJzyKxrGvZAgyvT38E3cifuvAAuvg4fbtBk=
X-Received: by 2002:a17:90a:da8c:b0:39e:6a7e:ee19 with SMTP id 98e67ed59e1d1-3a07320242cmr409438a91.37.1790065342365;
        Tue, 22 Sep 2026 01:22:22 -0700 (PDT)
Received: from hanzj-mi.. (ec2-99-79-140-187.ca-central-1.compute.amazonaws.com. [99.79.140.187])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144f29d88afsm3218679c88.4.2026.09.22.01.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:22:22 -0700 (PDT)
From: Zhijian Han <hanzhijian1991@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memory_hotplug: cache zone stats for "auto-movable" online policy
Date: Tue, 22 Sep 2026 16:22:07 +0800
Message-ID: <20260922082207.3224897-1-hanzhijian1991@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zkgssf4xgnksh1opwxzbzztkh9hhb5c1
X-Rspam-User: 
X-Rspamd-Queue-Id: E078040009
X-Rspamd-Server: rspam03
X-HE-Tag: 1790065343-770883
X-HE-Meta: U2FsdGVkX1+1rm9p0Zvr2B0/ut66T19unxwpmz741liPDgjBq0tsZSozOABtWbDsjrMwC3tENSRLw0WKRMmB0DuiIt/gXXlmjcrkiRf4w9IvFymg2aFleVUshIDCs+HOz5loo1VL+c2P4eO7N1HZqFTDfhUgeS+JLQH64O+PshgMqUp0S/cjVYchCgrRUM5EM/5P+/pNPZYf6JdecbrWP3En4Z2SSNe4mw0Xf4tFXkImZVs0CzwK6xprFRwpGqfC49IaxlD6nWJK2IwMabl8Mh+TwGRaoyGcIHDq91l8c8c4AE8cHVFnH+KI3gvBF5IcOrCAk7aNqytXSpm+KkQj3PPF7pO/gCz6rMUd87bd1IOEg99cO3rltSnmCF5mx43av+nGxwpCkA1aMbpxNHnQVq8msI+y8YwYrw47N6SpM2uKKPKZdDCbq6fiOTanorv8pLqbR1ReQ8YTqUnX44Oq/+HS9hoRcEgd4o3UUV+G0kDsDTRlMjVIL+nGUc4hiEane6XOeaXH+TPLzZn6RD24QrFfYOkWSuEgSZsMIDcJFjsn6rRi7OvlpZXxn1ZFye2/9cOq0p4ZlhUYz5k6c9tye2C6OR/z8N2co+rdVy300ZTocquWRI0EYGKslDI1uRVTadMyvuRGTu7BSQtukA4hD48kPQcewgojsCyBDNb/3UkEVkpBF8fOwJoopaAOj1P/lISoL8hAQhxK2293u6QSPWw4j/5EAR95os17IWjuktSRaaGlg6l86IcfRfzdL0sq3w4Th+eeljtQKMo6KEI3F19KeD+63jKozzXHxHwOR5yoOm2WI6bVf+apnIQibCBAZxnsqV+zxkod2wZLCtucModNZ8y0+jYzlPqcypop4iz/8SOavlyfe4ldp6EmiEOtWhmSvaxBC3FwcWNr1tK9Sy3D3FQE/6qiDIUAqUDQ+UvWm6rY4i11YIPeK/RxGMsP2Ik/if1U8wKeOPwxnj5
 DX4yu4RD
 45eXJzSWBJ9ogNKKKRdS/YtOrXaax0irQ41sdcEzeE87ERCFjJAKU9ji97+a65ncRgXT1v/LgBRMjG/j2wWsFFUymGIyZfxqTl4bF6gyYbKvHnLE1BgLUY50bHM/hMuVEAVPWhaJGl1dvJo0+MCMQ/OVKRVYNCcozz4gydFoIzqO3Mk6gDAt4abs96MEXgknc5wyA6YJ7PXor3f8RzwKcFFBqFz77QKEGaiJS1A/bD+9xDWaQcjV/vP2Nzc7gyq3RZkz/mjBA56ucxXKx5b4XMcKVJJKsMuE0s8y0AtujYd3TYBNuEnvXLMqxzFUXQXiY5PXhPemx0v6ZiB5Pfym0ZXZcY6KAp8y3rgPo8+qDZsMcFRNIzThhCiUOlJC/qtvm4yvFNsBWI2hlhLsX5LXcdQJ2g7MwNi1wjIc2e9F4E+BLeiAPpQQv0vwoLDbSOne8LI5dMq/4oJkuGZ+KWfXRS2111+XgqOGMenU+KKc7Os8tlF1nlFeC7xWE2rtvqftK9uN3XcGLWnkczAtD9CYcbeNvNB4yKr1qeKkajubqK00gg7P/kFd66L0dq5fL8kjxN9brIezB7m+JpxM7pHwub5fyZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When onlining memory using the "auto-movable" online policy with
nid == NUMA_NO_NODE, auto_movable_can_online_movable() walks all
populated zones across all nodes on each invocation to collect the
MOVABLE vs. KERNEL_EARLY stats.  This walk happens twice for every
memory block onlining decision (global check and, with NUMA awareness
enabled, per-node check) and is repeated for every single memory block
that gets onlined, although the underlying zone counters rarely change.

Cache the stats for nid == NUMA_NO_NODE and only recalculate them when
a zone counter actually changes.  All modifications of the relevant
zone counters (present_pages, present_early_pages) funnel through
adjust_present_page_count(), which is only called while holding the
mem_hotplug_lock in write mode and the device_lock() of the memory
block device.  Invalidate the cache there, such that the next
auto-movable onlining decision recalculates the stats from scratch.

CMA adjustments (zone->cma_pages) only happen during boot (via
init_cma_reserved_pageblock()/init_cma_pageblock(), both __init) and
cannot race with memory onlining.  Boot-time zone initialization
happens before any memory block can be onlined.

The per-node path (nid != NUMA_NO_NODE) is left uncached; it only
walks a single node's zones.

Resolve a TODO that was left when the "auto-movable" online policy was
introduced.

Tested on QEMU (x86_64, 512M boot + 256M hotplugged pc-dimm,
online_policy=auto-movable): hotplugged memory blocks get onlined to
ZONE_MOVABLE as expected, and an offline/online cycle of a hotplugged
block shows the correct zone counters after cache invalidation, with
no kernel warnings.

Link: https://lore.kernel.org/r/20210806124715.17090-3-david@redhat.com
Signed-off-by: Zhijian Han <hanzhijian1991@gmail.com>
---
 mm/memory_hotplug.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index d7a59167bec4..dfac59739a6d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -789,6 +789,19 @@ struct auto_movable_stats {
 	unsigned long movable_pages;
 };
 
+/*
+ * Cached stats for all populated zones across all nodes. Modified (incl.
+ * invalidation) only while holding the mem_hotplug_lock in write mode and
+ * the device_lock() of the memory block device.
+ */
+static struct auto_movable_stats auto_movable_zone_stats;
+static bool auto_movable_zone_stats_valid;
+
+static void auto_movable_zone_stats_invalidate(void)
+{
+	auto_movable_zone_stats_valid = false;
+}
+
 static void auto_movable_stats_account_zone(struct auto_movable_stats *stats,
 					    struct zone *zone)
 {
@@ -849,9 +862,14 @@ static bool auto_movable_can_online_movable(int nid, struct memory_group *group,
 
 	/* Walk all relevant zones and collect MOVABLE vs. KERNEL stats. */
 	if (nid == NUMA_NO_NODE) {
-		/* TODO: cache values */
-		for_each_populated_zone(zone)
-			auto_movable_stats_account_zone(&stats, zone);
+		if (auto_movable_zone_stats_valid) {
+			stats = auto_movable_zone_stats;
+		} else {
+			for_each_populated_zone(zone)
+				auto_movable_stats_account_zone(&stats, zone);
+			auto_movable_zone_stats = stats;
+			auto_movable_zone_stats_valid = true;
+		}
 	} else {
 		for (i = 0; i < MAX_NR_ZONES; i++) {
 			pg_data_t *pgdat = NODE_DATA(nid);
@@ -1079,6 +1097,8 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
 	zone->present_pages += nr_pages;
 	zone->zone_pgdat->node_present_pages += nr_pages;
 
+	auto_movable_zone_stats_invalidate();
+
 	if (group && movable)
 		group->present_movable_pages += nr_pages;
 	else if (group && !movable)
-- 
2.43.0


