Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B704CAC582
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 10:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DAD08E0006; Sun, 14 Sep 2025 06:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B948E0001; Sun, 14 Sep 2025 06:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8B98E0006; Sun, 14 Sep 2025 06:09:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 59B0D8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 06:09:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F5A71DDC4D
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:09:32 +0000 (UTC)
X-FDA: 83887433784.01.EB817B4
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf26.hostedemail.com (Postfix) with ESMTP id 595D4140006
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:09:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757844570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uFLEOCzcpZhNeqPyMXHEYmEtu6NLHOQa5aHDLbifaTw=;
	b=l6+pG5V52H0a9YMb/K8zxN6paYYaSzMQKkT0s55GARqCtTJ7F+VJZcj+5jEGKWmMSjbdJW
	/zFJmnLt4QRYgNrLf+ifxQvMjQlFBWOskTPpgNIQtNe6QO0Igz5mB07iA8SthcHfe1iOv3
	kLLasr7tfGWqgEOW6eI4IDVR7MODc2A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757844570; a=rsa-sha256;
	cv=none;
	b=fYQt9xiaWNUx8L+pSfyMNRofa/JVsHgz3GVUfNdOP8ZSpIcryaP3FvqRhLx5VJ2AFK3pNJ
	JonzCgsic/snHmnm8HheuB/WWGsb2iqoowQNTnMKDNlvQ0bOrVA5hdROu84vORujx2HRvu
	xQvabhIaAe3nQHjhvvIylY8iR74g+4Q=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4cPkRB344fz8Xs6y;
	Sun, 14 Sep 2025 18:09:26 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 58EA9Mnv094684;
	Sun, 14 Sep 2025 18:09:22 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 14 Sep 2025 18:09:23 +0800 (CST)
Date: Sun, 14 Sep 2025 18:09:23 +0800 (CST)
X-Zmail-TransId: 2af968c69453eea-683f6
X-Mailer: Zmail v1.0
Message-ID: <202509141809235737ZDUkOKaORJCGqQOQhM9q@zte.com.cn>
In-Reply-To: <20250914180031197jk6ngo5pQjpXkNtNsjzSo@zte.com.cn>
References: 20250914180031197jk6ngo5pQjpXkNtNsjzSo@zte.com.cn
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <akpm@linux-foundation.org>, <shakeel.butt@linux.dev>,
        <hannes@cmpxchg.org>, <mhocko@kernel.org>, <roman.gushchin@linux.dev>,
        <david@redhat.com>, <chengming.zhou@linux.dev>,
        <muchun.song@linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyIDUvNV0gRG9jdW1lbnRhdGlvbjogYWRkIEtTTSBzdGF0aXN0aWMgY291bnRlcnMgZGVzY3JpcHRpb24gaW4gY2dyb3VwLXYyLnJzdA==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 58EA9Mnv094684
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Sun, 14 Sep 2025 18:09:26 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68C69456.000/4cPkRB344fz8Xs6y
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 595D4140006
X-Stat-Signature: keofqox6n97ig1u5gdrwcyg85tr1c3n4
X-HE-Tag: 1757844568-576869
X-HE-Meta: U2FsdGVkX183EdvrlDrN2ffe52jgrX4h55tOIYvjYJnS+qCK5GyNnyOZo41qmbPpXveqQy5vtx1zWqhKJIWnL+TyuKV8cvXz6PGGEZxbXtVTaRA4FUAkIfWC7tg313fFMXsWC4hEfKdxsjgRcPhwSbto6bvBaKblYYwA3T31ZBNlLXpbssignxKM4FhGQJqcKvJSnbDuNmJaD/CnCSpBPljn2Up3IPcCAFWZbWwgdyATmdzvrH3u5TOmUKG+ofqAdoeOyIHur1MbYw8vRYQuut6F7Las6EwClxpmmKZ5ZCq/O0ZRrWs/iklvI8Y3VCoHX9tygS6FLYXBBKpvWJOEtMOtNcvMSifu4qZ9/NLcodJz1wTgc8YcNkpVzOD2PwPR5BxQZMrgyAKsDr8O4rNdt4MtgRKV6gC5DpsrasXU30WGHyEq8N/YsrWQyprl21iJpkBEQEfCEqfzvquO57mkyYTIkENvEJ186OBi/Mu2vkOpUfSfSvPcWjic1jsM07wXoL056Xxx0V3OBuOp19Iz/XkKIsqE3nN3snrNvRIvfdoca2bDn14UMTZ4l1K4xjDJqZZw3YqOxWtW8TZ4MbuxP+IDzY5yN5SWeWPf+voi23KhsgfY6HghjohJauBdeRS4tfoCxlGkLcUTRwLVHxyI/2wmNuzvLlxn6N+/InW/Kh0eY8ubP0FQDtTBrPzIuiPHdGlLDZ9GsQeLP4DY/cX6f0vGOXdOWjrY5dl4z4IUMh0P5DbWoZX85TmfK8of5oxC4LzB6Ix1XhLR5oEBlPr85TsFgT1OJeqSy8PjIoxjdBRcfXMw8Ss6wAeTPBETF4yYAjZj2ENRhwuXiak6nqL52sgjY3967xKXiYS32I+bCfiTzIMiMJHvAKmRhqFqYOhSmm0PQ9R+2QdK4bEksjw0Md/psBJBl5Gty3uO27oQRn1pTSplFj00E8qZwnMleZzjNOsPmQI0Vsr6XD1J++C
 kQvIuhKl
 B2aUNTPt8JtS+KojFBJq8EmjSbr6618o5k1QmMy6zVG2/A7VXprlNKkZmF1AI2VJrh0aIqibC53Ec5i/MsZsUh1BBepsgdneVoPjH8jXMcpZDVPeFqPeweS4kFUUPY9/8h74zoqIVkCj6cxWJIQZimyIaZbhB3tL4JpAe1fJslJvja2c4erTuZdjVD/uU8p//iAfyO4uiRGnituWU+pKwrPL3kA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

This add KSM-related statistic counters description in cgroup-v2.rst,
including "ksm_rmap_items", "ksm_zero_pages", "ksm_merging_pages" and
"ksm_profit".

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 Documentation/admin-guide/cgroup-v2.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index a1e3d431974c..c8c4faa4e3fd 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1776,6 +1776,23 @@ The following nested keys are defined.
 		up if hugetlb usage is accounted for in memory.current (i.e.
 		cgroup is mounted with the memory_hugetlb_accounting option).

+	  ksm_rmap_items
+		Number of ksm_rmap_item structures in use. The structure
+		ksm_rmap_item stores the reverse mapping information for virtual
+		addresses.  KSM will generate a ksm_rmap_item for each
+		ksm-scanned page of the process.
+
+	  ksm_zero_pages
+		Number of empty pages are merged with kernel zero pages by KSM,
+		which is only useful when /sys/kernel/mm/ksm/use_zero_pages.
+
+	  ksm_merging_pages
+		Number of pages of this process are involved in KSM merging
+		(not including ksm_zero_pages).
+
+	  ksm_profit
+		Amount of profitable memory that KSM brings (Saved bytes).
+
   memory.numa_stat
 	A read-only nested-keyed file which exists on non-root cgroups.

-- 
2.25.1

