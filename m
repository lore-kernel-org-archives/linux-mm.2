Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 214F0CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D1026B0093; Thu, 25 Jun 2026 10:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8B76B0095; Thu, 25 Jun 2026 10:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEC36B0096; Thu, 25 Jun 2026 10:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D83076B0093
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:24:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F84F120166
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:42 +0000 (UTC)
X-FDA: 84918656004.23.E90D052
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B5A18140004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ifoY/AOk";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397480;
	b=felh83K1zNLQKTPHWMMdN0m5H3E0ycnlfrDmi7H+S1W11ITdOnYq5E+D9vEXUBujQz9+Oi
	9v8Qxfegvm1C3SAfNKHqqNX+mC8+J4a1mFfa+HgeBvcFFaGVhjCERu83DhFDvCUkYyFuc/
	/iUGMBexxhHf01RRKLM5V8hNjE5gV8Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5OttG5aZqvfe3QoWDGJ8CJoxJmlu+HgiCPFZDVymoA=;
	b=ZDBSueff8SzQtKW2g9IvCdYpdQMQ6jbxm+7DewhF02qKGRWAK0q66Rt9I2KwAf8TydReBZ
	ODUDGqNXioHEafMPiZPRIrWbtc/EgExuZDFKtdXUrngQXuS7nwksMI4BTFNrFtFWdrtYSk
	Agv+axt+NGym6RcNsGGWGtkKJLQwSWE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ifoY/AOk";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07F5E41943;
	Thu, 25 Jun 2026 14:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD671F00A3A;
	Thu, 25 Jun 2026 14:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397479;
	bh=o5OttG5aZqvfe3QoWDGJ8CJoxJmlu+HgiCPFZDVymoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ifoY/AOkapZewhih6Vu73IuNk+uEivXTeN1YPTEAQEGYR/rqaJlGEECgu6iooE/2j
	 8tWaIQl3ovBmvnCpWbOuDQC1sOKXWNDDtzTi7RBDQtWLMVQuHkMrTtvSrm51XZd9nO
	 6j9fV855ih+uLpDSOG3Eptw4EQ6fdrt1KUZauZBqj3a01ASI2mhWPTqL83Q8LBgAm1
	 SZp6LC3z0/2l1an4Z/eb7McQjhDHh0GiARmWEAeDgG5Ik1dCbq1Xx3Jm4GNKVKaZj6
	 ebaG/WJzflLBqjVRGo27uDJTtwluGNjEndR3eH9H+iquTin3ftqNgPg4yeIxY3c071
	 nbBMcWYqh1ozw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 02/11] Docs/ABI/damon: document probe files
Date: Thu, 25 Jun 2026 07:23:47 -0700
Message-ID: <20260625142357.103500-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625142357.103500-1-sj@kernel.org>
References: <20260625142357.103500-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B5A18140004
X-Stat-Signature: nqqi7qcwycb3ekwh3iszxhu5kq7xr67r
X-HE-Tag: 1782397480-474982
X-HE-Meta: U2FsdGVkX19esh6Pb/CeshAXajqZY/0ve8CYOG/teBJcbse1Rzi/piTcpuXACgOFFfdG48DpmBKD2VW2YnYMA+BhexPlRMv9H6hBml0AQMDVJjCj7onRl7n78s2zP6+f27gSAXv3UpkoPLqAMXKTA2McHwQgjqi57GH9hz6sVHMIGIz9UmAManb+bsfexiHi4Um0W4m5XL3y4QG/8v0U4e9DOrQs2eFEmyRje3DL2AGravuwS7x/ecIuuoksje9cfnZG28MOH7bgeqaHjZzgf82GhQqU4DheqY4TsZVg83af1bdDhFK3iRQZAL/tu/3v2nnFOwvwY+VEirnFxeffFNGj+nsjnlSLMKIw72GIjnDF/4Y4GlCD/tuWJVUJUa5QAZXy1vJnlYYh0v85mHY6+YFIrkn4/YSmnhyL21R29I/sLQTI1eXivb90H2nsCyN3x0AYER4NVbFRKEvgzxu1K1dpvCwz+c0A1k6aZOQ7HvaBdGCTEC2oSC84JKhwzZdpyXHtP9Z9QlNtjCi1B0Pd7wPqO3dH+bCQdPBb1nCDYNpW4OSA/vxX6KSkyGLs1QZPTeM2uwoVLLTmM7jYjFQXfVwSQpMlkeb77q92z8QqI8AFtWzMythQsBD/g5N/EcR1p3Fped+/sMxJQgFvgFoM7pByscTSQsfwqcLMHw7gcxL5Sjaps5MBJTvK9EXZcwqxA6T3+H65dOuGa6/UmbrXpK9w2xHfdl/DYM2GAGcROKmuGg2C5CNyvM6/dWo6eu9v4jLSVgURiEoC6F6b2RFspAGQVlrcgmSk6JD06Pudw9WSAeJQAP7I5QR+1hfCY+lfzQxWC+2MEojbzvg0OJ3jciNAMAM31a8R5WI/xPqD9uDQa9Z9dK+4d8gTPvxrzMpM8PTLvxola82JKdVY5Ybhrzcy5mKgYvA6Zpgt8qSDG3vHiKHKp+9J5RVAe4dl9EiaW1Cyu+t9cW4ki/E4B9M
 n1PEFsRH
 V9zA6C5jFzvZhiPrnPC6n6m+wP4iZympxYoeDdLmSsVaR8vfsnZogCYfaMnwyJxaQKUP1rk6J1AlYZM4/Sg178H1bVk1E4miROdRN4UfYDSq5R/RK8QHkVQcRfuXKpBpoNoq8w0PK27AjMBvDxDUNm9FCaQT7KWGFyy7G+YptyXwaqW10zdnQREw+J1ZZ+XKnopFLeC3z+ogtz9+GvORU6MSiJAFcm1Ap9t5zugjz4TV89RQK4+cwRG5lM1tbjvUd8jfg+tgkSsQPsPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON ABI document is not updated for the DAMON probe sysfs files.
Update.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 .../ABI/testing/sysfs-kernel-mm-damon         | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index b73e6bc28ea5f..f914aab79fced 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -157,6 +157,46 @@ Description:	Writing a value to this file sets the maximum number of
 		monitoring regions of the DAMON context as the value.  Reading
 		this file returns the value.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/nr_probes
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for each DAMON probe named '0' to 'N-1' under the
+		probes/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for each DAMON probe filter named '0' to 'N-1'
+		under the filters/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/type
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the type of
+		the memory of the interest.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/path
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	If 'memcg' is written to the 'type' file, writing to and
+		reading from this file sets and gets the path to the memory
+		cgroup of the interest.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/matching
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing 'Y' or 'N' to this file sets whether the filter is for
+		the memory of the 'type', or all except the 'type'.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/allow
+Date:		May 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing 'Y' or 'N' to this file sets whether to allow or reject
+		hitting the probe for the memory that satisfies the 'type' and
+		the 'matching' of the directory.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/nr_targets
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

