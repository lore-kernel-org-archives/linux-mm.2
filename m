Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 045EACD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 18:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42FC46B0005; Wed, 13 May 2026 14:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407426B0088; Wed, 13 May 2026 14:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 344586B008A; Wed, 13 May 2026 14:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 219336B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 14:59:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C25DA4025F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:59:02 +0000 (UTC)
X-FDA: 84763308924.01.A7C1C42
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id F2B93C000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 18:58:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=orlkbFi+;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf28.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778698740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hLDHDw6L2XoumT6hL0NwUBbydY/pK2g/zR84qPtzVV8=;
	b=XJZxaPnQh0ur2pCAyezKYS59Ia2jWxIxbiQEePcjT0A/5xHCWA6PzB/9ZgKEfBHhw4a8RH
	gwzWd4OJ5iFjfky3uP2URalfNLr947vVmOmwLrUyFtfcBjr3pYEPdqI77+X9EQG5sLLcTo
	Gn33paWO39J12L7ssg0Y0gQuU/MCPyk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778698740; a=rsa-sha256;
	cv=none;
	b=7NYd4TrXl+pyOfs2UYWYn+BZTA/db6MdWp8VQkgL1aHXRpnYFiHAM2UhXYA/iJVLxWr3yc
	y9p8jg9SsA4kWy/FxDGmErsql3BwPpuOjZ28159c/xvHQDgZw7OMW+K6pVS256d2VDRPZd
	G3GvKlldfgPmMF3ubMRxVEIbyTi6ye4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=orlkbFi+;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf28.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:Sender:Reply-To:Content-ID:Content-Description
	:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hLDHDw6L2XoumT6hL0NwUBbydY/pK2g/zR84qPtzVV8=; b=orlkbFi+CfrTOJx71uAU8+bYfM
	JPsP2pe1y/uO1CMN/16vVmCBmOctgZMP/PYiEHuF/djxfy2oaokqktP2wIOEzcls7T/9pt55+cflz
	gPV893jmQDhGrvkXpAxwfYGrhIJMjKLg2Jhjg5BUbRqxrtzmpisDMD7e6jJyGT6XcRw49Zrto3YtX
	600LJNkANS23l9ZpCnUe4Gesh5dtELWtWmSDON2GF4JvMmkf6FqvdxHaChDrkA5jMkKbV+yebaq8X
	ZPqKodOldA9vSDAM99OdORWiw7dtcUM/cGjC+QJPEN8ngToe4mb1rXD6JgexBHYbpUYgCbKnLKdDI
	WndYMfwQ==;
Received: from 179-125-79-241-dinamico.pombonet.net.br ([179.125.79.241] helo=[127.0.0.1])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wNEn4-00A6HS-Qv; Wed, 13 May 2026 20:58:43 +0200
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Date: Wed, 13 May 2026 15:58:16 -0300
Subject: [PATCH v2] cgroup/dmem: introduce a peak file
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260513-dmem_peak-v2-1-dac06999db9e@igalia.com>
X-B4-Tracking: v=1; b=H4sIAMjJBGoC/03Myw6CMBCF4Vchs7ZmKBcpK9/DENPLCBMtkNYQD
 eHdrbhx+Z+cfCtECkwR2myFQAtHnsYU8pCBHfTYk2CXGiTKGktUwnny15n0XRTa2NyQqvAkIf3
 nQDd+7dalSz1wfE7hvdNL/l1/SoX1n7LkAkXjGizIFGWp7Jl7/WB9tJOHbtu2D8g3jGWjAAAA
X-Change-ID: 20260409-dmem_peak-3abc1be95072
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <natalie.vock@gmx.de>, 
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, kernel-dev@igalia.com, 
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
X-Mailer: b4 0.16-dev-62088
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F2B93C000D
X-Stat-Signature: iy1c6y8xppiz1ssiytquaqynkwcpcx7w
X-Rspam-User: 
X-HE-Tag: 1778698739-198082
X-HE-Meta: U2FsdGVkX1+fmwCyUpirmiL7aKDnZG6tYb1vJeCCeEany1rsjBNDm/XqKGKUa7GVSMuHDfZT1I+bhj7XMmTotWLN1ehyRrcQ3P2Q/4kf3GuVXHtepz7oCk7IcJVyetUkgAoqnZvanRkLKMIFSHHqLKPurMUw0zpYoLKU19t7zamdOnubDSS01J8esIJsgK/mVYy3hrD/0oqpJ+yE7SE81F8+kRHPMCpSZZf1zERJvX4KhyY3s/drxyUUDQ119E0OwScbmv2ucZwLwFbw9GegXbha0pAigIoHCynrwIPS4QDGYHgjbBWC8PrviGtc6olgm9A9D16eshCn2AUrbCPj/ElFM4oquUy1bQyP5eEnhz1YWJliBour6Lj+aK0vBkkZhK5pKRnJG/zlQZCttdyIdWGO7IB1vs5EeEPcNyO/o13suZzX+/+XKbWUtxH8a1K/UgzDuLAHk9YyuV6e8WYrbUIAYsNCEGQwwjIi3BDq8Jh/1y4dlp6Z+qrxPfrm2v26W6n+jNS1CReEROXrnEXoEbvVdfEYJ9o5H8Yi5oSjs4WXVHqJMuJWAskAQMO3nRaB1sE0kBHgfcH7QloCBx/vYCdgqJ0kKYkroPd9Sb+FI0KyfseNUJpxfWUyrtt7frBaz6PT2g2++FVUDQt5hHtTrYF/LwOcdrxRrz47QfWIhSGU/2ZJydTw93AtG1Jx8M4qSWeG29Rg36iE5vKoaF8den+XPmn9c3narLujVSNqyRZrREJpp6eWrsdUMve2dNuEEeSQK984xCgQLSBsRX2r2CBWlUb5zOomUaNnsr3AeMZ6iJVtudZ57kCJXlqkh1usAdDoVPqnUPsQyiyb/ZgOB1fm9yyaE3BmfZEOsY8tXugcg1tcd93SXZ68Ae15GhY7IyzyIX0eUBm2W01KWCKHPHPcXMwx2uDBa5J0BqUX97d5T3yEdl4W2x9D2pnvnpErE77jPwEGQ+oQ3LMtjj9
 PITKP8Z2
 E9IEgEHx91ClMqRdvmRhCJGmvVSYCwgJ7NsGGzdeNDYEg5Go+MPRz0GOEUbgtopGN5OivZKpfunnp6YWmc81Ajio1sjxwlHRHWN27Cpi0OLLZFH+YBOvLDZ7g8Vk5J9EHHNudagsDhCKqGf990IioZew70dyI1FpFUkhba6IBklsxuHEZSsjvOOXuCEL8bz6uzJQ6hh8BZE0MOhQkUINzuKe/79BBxjrL0hrG/CB7VXur+3LLYumt5jMLJte0J2GPURnoz4RPcjtjR7z1FICh6+SW52ERSS42oE/FDCWQWqZ0mcPz1ESx+0M8QUkzqjQIuWB42ESzCo6K5Jd5WSVhogunqqQ62KSC5VhL9JKqCuwGtJkw8FDT3uOa8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just like we have memory.peak, introduce a dmem.peak, which uses the
page_counter support for that.

For now, make it read-only.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
---
Changes in v2:
- Make it read-only for now and adjust documentation accordingly.
- Link to v1: https://patch.msgid.link/20260506-dmem_peak-v1-0-8d803eb3449c@igalia.com
---
 Documentation/admin-guide/cgroup-v2.rst |  6 ++++++
 kernel/cgroup/dmem.c                    | 15 +++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6efd0095ed99..d103623b2be4 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2808,6 +2808,12 @@ DMEM Interface Files
 	The semantics are the same as for the memory cgroup controller, and are
 	calculated in the same way.
 
+  dmem.peak
+	A read-only nested-keyed file that exists on non-root cgroups.
+
+	The max device memory usage recorded for the cgroup and its
+	descendants since the creation of the cgroup for each region.
+
   dmem.capacity
 	A read-only file that describes maximum region capacity.
 	It only exists on the root cgroup. Not all memory can be
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 4753a67d0f0f..6430c7ce1e03 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -182,6 +182,11 @@ static u64 get_resource_current(struct dmem_cgroup_pool_state *pool)
 	return pool ? page_counter_read(&pool->cnt) : 0;
 }
 
+static u64 get_resource_peak(struct dmem_cgroup_pool_state *pool)
+{
+	return pool ? READ_ONCE(pool->cnt.watermark) : 0;
+}
+
 static void reset_all_resource_limits(struct dmem_cgroup_pool_state *rpool)
 {
 	set_resource_min(rpool, 0);
@@ -808,6 +813,11 @@ static int dmemcg_limit_show(struct seq_file *sf, void *v,
 	return 0;
 }
 
+static int dmem_cgroup_region_peak_show(struct seq_file *sf, void *v)
+{
+	return dmemcg_limit_show(sf, v, get_resource_peak);
+}
+
 static int dmem_cgroup_region_current_show(struct seq_file *sf, void *v)
 {
 	return dmemcg_limit_show(sf, v, get_resource_current);
@@ -856,6 +866,11 @@ static struct cftype files[] = {
 		.name = "current",
 		.seq_show = dmem_cgroup_region_current_show,
 	},
+	{
+		.name = "peak",
+		.seq_show = dmem_cgroup_region_peak_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
 	{
 		.name = "min",
 		.write = dmem_cgroup_region_min_write,

---
base-commit: d3b0a7f21119f5a66cb76aa28fb8cc13206aaf7d
change-id: 20260409-dmem_peak-3abc1be95072

Best regards,
--  
Thadeu Lima de Souza Cascardo <cascardo@igalia.com>


