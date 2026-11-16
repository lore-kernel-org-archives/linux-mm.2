Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEFD960A3836
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VNtdmOa5
Received: by kanga.kvack.org (Postfix)
	id 886B16B00EF; Mon, 16 Nov 2026 14:10:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865C16B05B2; Mon, 16 Nov 2026 14:10:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726B46B05B1; Mon, 16 Nov 2026 14:10:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 421146B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:10:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A22F8A7D39
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:10:24 +0000 (UTC)
X-FDA: 85441923168.12.A4A3B32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7DF134000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:10:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VNtdmOa5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794856222;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SEJOx53H1+kOAfB5X/d1gIgUhchGzcrN8DF1l4byjXc=;
	b=Vf8CWKnzVfLcFtp3spD18vqvppJ1K6gLktwuhumOCmwfttjUdSwgM+wzEDFABX/COauLVE
	4RWczZ1anS3usWItVL/dE2JBKNBVCVHDTl2wlTVmDyxNFlcb9AVfwG7QfYVfOA+cKiKo+z
	EyemXMQUAZrutqmEYcFH9DfoKjYvogg=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VNtdmOa5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794856222;
	b=dJEnsfbloFhHXWMmSt2SSWWfIwONXCHo9hXwan8EJZHyjfRJlNIWioQ2uLAGuduzzhYY0L
	V7I6rZS7k7Hth2YSqs+jUbtXH2eANh2GAGuNef2h1bHId6x99nxbKmxl706ZYJZ20q4Veo
	bI2Ev1ZqFKWdEyC7Dy+tafd8ocuhrNk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DCF344CF6;
	Mon, 16 Nov 2026 19:10:21 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794856221;
	b=vBsUM3xKGizhRwS51I+qzF7uz8WpkSRfXR+C8R986NSMBzTSSADixQFsb7Y28eFZpeOe
	 HyyFpENPpzPTO4X121/eYcrjyq5mTSfjrUwTEJXmvn/YjOIHK3kqHIUZmLfZwLMvAMiQL
	 NZN29ZMcs3Eg8comiCfDyGtA1Qeufsj5wv0dZEXcybOHLFHZn9gbCvpWFS3vf3LK5s8JQ
	 YKeJ6K3xUn8+Owe/W4q3XNpkeObouV2yO4cvl+jheFYe2yhuzdc1ZXEahW44gkFgByWJF
	 9puO4ainDb4HuxL8ndq1k6sTIFH2wrP+9ZaYhfgdyyx1h9R1FhQvK3EAHH6XXLeQO3Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794856221;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=SEJOx53H1+kOAfB5X/d1gIgUhchGzcrN8DF1l4byjXc=;
	b=QD+Rz0lDF1tXhL3nJGkuBzPUaXlX4g4pjwl5WhTtivDOKqFtvLa1FmpDPcydlDFGS9lw
	 gzEpuEwBabDg8d1gkxOSy9j9qAHW+uIJNFpmgdF2jxMM4TAM5jLOHlRHZs1/Bl+QT5+uq
	 JED7972rfGlVQQG8mJiM3cwBXZ3XN7MmAq5wng32Ati8S3L86OYs9kutranjAmLat0r/d
	 buPTsYMhplf3VDdIt5IqGFuiihUYrUZrfahfmCSOpoK0Km8eIZ35zdmLysPuD+ertRqMg
	 act0ovJS7gw6Yyij0QNTzX+sYyXHkBWIjvfCQZnlRYgzwTTuMzCm4ArKKFQ1Xkndpnw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E0CC31F000C7;
	Mon, 16 Nov 2026 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794856221;
	bh=SEJOx53H1+kOAfB5X/d1gIgUhchGzcrN8DF1l4byjXc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=VNtdmOa5Bv0ZFaxb2XTUipyEydDyWvdVgAreLr4Y0Kb9QmniLCGusvauvooTXu70V
	 Req91qAXtK7zzhZrAv5sMT/pqEqJzh5dEWuYlTbLz12aFXfNF5vnIM5AN6nM57hCuO
	 0+B45VFu0/gmMdb+xoo430xETiFEZmcKbdy1kMBzrdKl98EOCFjrDdWkjfk5q/NPi6
	 +pve/LJboiuaDpWG21AMLoAdnDtFQur1fOb/3vTaR170opL6CX5MyNmhTi/uWQERXO
	 zJ84jGYVJIQLsp0b3Hip4IGlMCPROORE4FF19zcSKPBgA+DeVeVbwa9ikRFTNoL4Nc
	 LT8odP4A+O0jA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 693AD4A599;
	Mon, 16 Nov 2026 19:10:20 +0000 (UTC)
From: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Date: Mon, 16 Nov 2026 19:10:05 +0000
Subject: [PATCH 2/6] mm/damon/sysfs-schemes: add sz_ops_filter_passed_last
 file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261116-damon-sz-ops-b4-v1-2-1cffe7227e6d@uber.com>
References: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
In-Reply-To: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 Mattathias Pinchover <mattathias.pinchover@uber.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794856219; l=2837;
 i=mattathias.pinchover@uber.com; s=20261113; h=from:subject:message-id;
 bh=3d72KQenPLZSAMPasN1wih5Lo/g59JndfypEpkGmhZ0=;
 b=ob0NIrM5E36+IU946sP/gerNGtsB6G1jMaVz6CIklTsO1XmSuRtfAXavsk4EJgGhR524xNXNa
 hh61Cn/ziZCB+eAEWSGpjAOTt7YsPgURlFwJy7Fs8cvWMw+RQF3ZHXP
X-Developer-Key: i=mattathias.pinchover@uber.com; a=ed25519;
 pk=6Bh6OEwWiU6dpON0CVcoipq8fXtEgvhsM1Tmm9CTmtY=
X-Endpoint-Received: by B4 Relay for mattathias.pinchover@uber.com/20261113
 with auth_id=1515
X-Original-From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reply-To: mattathias.pinchover@uber.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7DF134000B
X-Stat-Signature: s9tgj1g13arhum991uwkm4s6z8hg7r8b
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794856222-158144
X-HE-Meta: U2FsdGVkX19vtJWS+2JRwAeHEzP+pscbjZuHsc4C7UxY3tGbAZu6zqCnV4EbSQUqTFQEv8KrJ+PkZaEQOtbJzBZoE1XDjsAMNzZPPz/qSEdGSAafG7kOKg4Pk72/5HjZPIf9RmR3+Q8WNK3l1wrdjY2p8Y9hwbakCZwd0g+dbUJFDBPon7xYo20IzoxidH2l4iXHhzhc8x2kATDNhMlqqchMrZ3pH3PxG1JXAqU7EDwSxjUXBIKdKKG2uywJGA9vPbEFIMyf8g0S6ThpvkvJhMcE7tcizTqAoDOrIIWNpRR1xdJOSl92KUTDpd+wON7JT8fC0U9xTGv1KZGIkXtGWIM5EKuMwdVLqlws+D6nFQMEEY/1EzK2stPmZr+GpNUX9a4qo8hKnYtGAfenf71WCQlj76p+1tCa5petICUVIjipENlf2qnmL8i4Urzj9pfIoW6vK4cUET2vD+oeWf+AIiEQF6yzSuHqujAjO2AVfJJtAYWJJ5rkXH1/4DVH2jtAtlDsKS7YKh0p1z/LQ9kFJMg8crzTSPbkcdG7PnHdPnwKnYRiusIEUS31iojxA+bOTDY6HJ2GSCYJ450onhH9aW/+pEPZc0ZbP/AKqLMZP1ZIvmC9yRRUo0zXexB3ZaSr0GLRwP9ZP1T5bnnZrlq3GiZ4Nihuu4hv0llwPK0oBnO6fOua9YbOoiAF6sqp0FOSuCbsCwbcNL417mocrjwpCc9wrfeV41Ougf09SiiuLlM4hU3Mn0pCzQo4v5z/lbXGdg/6i8M41BkGPOH/x/W2yk2Vo/4iWwFKRf/DBWYI/24bfXe9Ywke72BTYKxVxUl2jmw44flQTwdSQsbF9uFr1G+UtaQ9H+L6k94HpfUqdPHvfRq9bftHEWQ6aQCGUK/HAUE7LALhVoGjmO1L0RRZNdiSUoRyTYyik5IZ5w70HVTb0XzbbfiqEBjvfh2Fvb3DIj0mX24EIoKMtv91CWW
 wiq/F4uT
 kS67l73zABFNFThkKvJn2b++GQhnulWWpOdHyAm6mzbpoOuabTZ6ranfELcQIepxf9LihtPFWvXYoEFm+lwsxvUUpr15XdB5+ZnXwLVsAzqNQZDkGV3Cz6iMcJPBTIjRbMsJfAmFKorNbYrWNq7DGNTfnCKqgtGWm22LaAppyYa3WWAkcrR7CalhMOVIse/1EnDrgT33jn38vRqUhg9jhcavUZmZH8/l806Dyl15HTvm7AYbd+JXBCUGryjyjV3X9YyCpOKkddKRgG++KJHq998PrrSpnKJnpouEg4pF6JXKaMyF8tjQIDdE+ZmQM0Ep0MxtnZ8NH6wRKCxoW3OKFpl5mYIITQrisLU/iT/sap1IpUucJNVbLxFeXPQQ+9b2J0Qhi8GDx440amvRc/i0fM7SA7WRF8/hFweS9okMkQquqFJOlMjkjEUAO5X3/phppop2YDNUuezyiH5On4OU/2/8kjso2qjCuYGF8UMFfH5LRrk7zXPQmbTO7fA85BMuijB5QWobP1MdjE+phwddYfzfFCDSA5xnVB85V3u7CawQfOZTdGemSmNwJkenv1vUY4r6vPs1rpPEhZ4HbnXfXWCSajw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

Introduce a new DAMON sysfs interface file for exposing the newly added
DAMOS stat, sz_ops_filter_passed_last.  The file has the same
name as the stat and is placed under the DAMOS stats directory.  Like
other stats files, it is updated when the stats are refreshed via
refresh_ms or the update_schemes_stats command.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
---
 mm/damon/sysfs-schemes.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 230987efac3a..fe33189e8802 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -370,6 +370,7 @@ struct damon_sysfs_stats {
 	unsigned long nr_applied;
 	unsigned long sz_applied;
 	unsigned long sz_ops_filter_passed;
+	unsigned long sz_ops_filter_passed_last;
 	unsigned long qt_exceeds;
 	unsigned long nr_snapshots;
 	unsigned long max_nr_snapshots;
@@ -425,6 +426,15 @@ static ssize_t sz_ops_filter_passed_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%lu\n", stats->sz_ops_filter_passed);
 }
 
+static ssize_t sz_ops_filter_passed_last_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->sz_ops_filter_passed_last);
+}
+
 static ssize_t qt_exceeds_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -485,6 +495,10 @@ static struct kobj_attribute damon_sysfs_stats_sz_applied_attr =
 static struct kobj_attribute damon_sysfs_stats_sz_ops_filter_passed_attr =
 		__ATTR_RO_MODE(sz_ops_filter_passed, 0400);
 
+static struct kobj_attribute
+damon_sysfs_stats_sz_ops_filter_passed_last_attr =
+		__ATTR_RO_MODE(sz_ops_filter_passed_last, 0400);
+
 static struct kobj_attribute damon_sysfs_stats_qt_exceeds_attr =
 		__ATTR_RO_MODE(qt_exceeds, 0400);
 
@@ -500,6 +514,7 @@ static struct attribute *damon_sysfs_stats_attrs[] = {
 	&damon_sysfs_stats_nr_applied_attr.attr,
 	&damon_sysfs_stats_sz_applied_attr.attr,
 	&damon_sysfs_stats_sz_ops_filter_passed_attr.attr,
+	&damon_sysfs_stats_sz_ops_filter_passed_last_attr.attr,
 	&damon_sysfs_stats_qt_exceeds_attr.attr,
 	&damon_sysfs_stats_nr_snapshots_attr.attr,
 	&damon_sysfs_stats_max_nr_snapshots_attr.attr,
@@ -3130,6 +3145,8 @@ void damon_sysfs_schemes_update_stats(
 		sysfs_stats->sz_applied = scheme->stat.sz_applied;
 		sysfs_stats->sz_ops_filter_passed =
 			scheme->stat.sz_ops_filter_passed;
+		sysfs_stats->sz_ops_filter_passed_last =
+			scheme->stat.sz_ops_filter_passed_last;
 		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
 		sysfs_stats->nr_snapshots = scheme->stat.nr_snapshots;
 	}

-- 
2.54.0-uber3



