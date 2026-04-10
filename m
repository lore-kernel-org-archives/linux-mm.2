Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D874F44873
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B8C6B00AA; Fri, 10 Apr 2026 10:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C486B00B3; Fri, 10 Apr 2026 10:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507B76B00AC; Fri, 10 Apr 2026 10:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 289B16B00AF
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:20:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8DDD160305
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:48 +0000 (UTC)
X-FDA: 84642857376.22.D87C9E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 69C66120006
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AK4nbONb;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775830847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTSjVLYPguBmCdyYoU8/p+4xBT6J/c20Yd4o4tKZLuM=;
	b=ve+16FWGl7OJ3eofurWKYGd8/kVHyOvX87xJt9jZzuoooR8P+iNy7bh9lnR/ee9zGHv/x6
	X1Bc+9LW9F+CKrcISKJVae6i+e1etqtfWSMRbn9niz0niGZK6cAgd4T6WlRb87jA9L7kG2
	VOLpzwZ0T7pHjtPwMcGq/cpSvyvYWYs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AK4nbONb;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775830847; a=rsa-sha256;
	cv=none;
	b=oiqlWAYT0wWjUK0uLuh4Hua61Q4I5YhStDPtxyrNsCzpNMDqWgD3/jPIrpucbWrPTtXMl4
	/D3ELcVFeqg3xwYp9xU7PyrgutN6x5YirWLl6X3ivoVTT6XHupAZL3Ub4LtlaaHzXg4Crz
	waH3J+wuvsibjyUlezBzlY4r0/2XgOk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C76B561331;
	Fri, 10 Apr 2026 14:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013D8C2BC87;
	Fri, 10 Apr 2026 14:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775830846;
	bh=x42u0yyujS0MNNJ5zIzlJ5WzcqjchBB5xjDhcoIlpNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AK4nbONbQb0eDIAbPTFWIGS7EmMnpU8NyFvBqyYlR77VQbb4whGmlf2GTSs/eoioc
	 8GmVmKGNwLdqZzBQSJk+/Wo03tVz09ZqiyzRTw4xe0LzyRqHx48YSUl86C1Kkr0/d0
	 hvDULEf8n/qQMEk6X/ob+4cfVK8MimyqHgv2ZsW2Vg1vezVGyZx3RGajYE023NwZVS
	 cc45eDOjjlG0EyBughQXD8UDMT3TN7YxPBIKukMdx796lochqj8tSJ88nGpbeb10S3
	 Esxyh1Kqi+T5hodbvor0MwQa9aTj65SNu7376Nj8Bl1cSI9fnV7vtjwGrdjfeXdqRE
	 TuvlKRz29LSVQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 05/11] Docs/mm/damon/design: document fail_charge_{num,denom}
Date: Fri, 10 Apr 2026 07:20:26 -0700
Message-ID: <20260410142034.83798-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-1-sj@kernel.org>
References: <20260410142034.83798-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69C66120006
X-Stat-Signature: ceyynuc83oh48dgsmehm1igai6tpq58d
X-Rspam-User: 
X-HE-Tag: 1775830847-724618
X-HE-Meta: U2FsdGVkX1/yY+wx5vTZQ36y5Cgf0E4JoLD5JpnSEYPrPlz1kL7vnqWPVxc1trXhdIYPsriAxWYaNBD+Zz1b3Zv7R1yhISfMzcB91wG99InIYqASmgVAOeh/aOiK+WbvgphOngWwP4JfEMq6iXvgTea6eSYNB58gtASaznjrNwiIaAX51PutPSsKtwWRXQsZd+mjA/hg3TqKoBE7svaZAlJFG880vmcjkNRbZF61xoGGC14OKtqDCJgti8pUGmouqNnqOJudguIYd3jN0lt+T0Jve2yxgEoPAwe7rbXJsxpMFAgYAee5mHgvwTPEMXreyWqBR/VOOrj2RcKwOOCNJCC2fsWVkpdcSXVUnqOg9JuiFFRKTdbsfvDwYHD3P59vIGp6wwXm6s6bNBpMlrYLj6QlNkrnNnNIc3F98y6lIgm7/5M72lc44AQPWMQD8rM/d7w81HYNh/IIGxTOOVcaT6nE+WaB3IRzoIVO8U7oBVzSEmLLqFCYcuthdIPg3xKwpW/KO7a3oFPK03W7V/oGoJHSe0nWk8RP++m/5s0wy79tzm1sSb853bg2GyfYC8MJ77ZvRI7PhyS+KnakK1cUcBEK0cvRpXY9RVMx0CzGd7qk8+rPXDityz2vxGtUhcAbgmF+rPAIRnXa94XoFR3JpeIf1LLkZMaHaDWY9hYYQtAtRycf7PENFBb8GpZhpr4PVj2AGxfb7wLnaxSO2tuJLjliVMjP4RGFSBW3BIDigZY9sd87B+J1D6he78M6qUV3/1MM7nPpjnfNMGONe2MIu5u4NMbbz51ZCU/uIh4Oun2C6Ju/1NsoS3cGQmydZBuoND2GJwhcnD8NQL2yVuhvA9a2rQatEHBFtCxqZolsGLdDAbaypMYuUEurt7BveLsHIV7uSxpSwazFCcVP3bpdKhseUaxC640eSu/kGdgQ02qJpaIWRriA+JQkRxgKNJr7lWQ1OgyRs+1KKQTTFK4
 mSSNGmIM
 K/uwP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the DAMOS action failed region quota
charge ratio.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 622d24e35961e..fa7392b5a331d 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -576,6 +576,28 @@ interface <sysfs_interface>`, refer to :ref:`weights <sysfs_quotas>` part of
 the documentation.
 
 
+.. _damon_design_damos_quotas_failed_memory_charging_ratio:
+
+Action-failed Memory Charging Ratio
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+DAMOS action to a given region can fail for some subsets of the memory of the
+region.  For example, if the action is ``pageout`` and the region has some
+unreclaimable pages, applying the action to the pages will fail.  The amount of
+system resource that is taken for such failed action applications is usually
+different from that for successful action applications.  For such cases, users
+can set different charging ratio for such failed memory.  The ratio can be
+specified using ``fail_charge_num`` and ``fail_charge_denom`` parameters.  The
+two parameters represent the numerator and denominator of the ratio.  The
+feature is enabled only if ``fail_charge_denom`` is not zero.
+
+For example, let's suppose a DAMOS action is applied to a region of 1,000 MiB
+size.  The action is successfully applied to only 700 MiB of the region.
+``fail_charge_num`` and ``fail_charge_denom`` are set to ``1`` and ``1024``,
+respectively.  Then only 700 MiB and 300 KiB of size (``700 MiB + 300 MiB * 1 /
+1024``) will be charged.
+
+
 .. _damon_design_damos_quotas_auto_tuning:
 
 Aim-oriented Feedback-driven Auto-tuning
-- 
2.47.3

