Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD229C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDDDD6B0092; Wed, 16 Sep 2026 04:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB45A6B0093; Wed, 16 Sep 2026 04:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF0F96B0095; Wed, 16 Sep 2026 04:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 935746B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:25:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2EED41C2BD3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:25:43 +0000 (UTC)
X-FDA: 85218941766.02.FB3A0BB
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	by imf10.hostedemail.com (Postfix) with ESMTP id ED36DC0009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:25:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HSKlUC3v;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789547141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5tMqaAm4Vat788vnwkjqZZ+Ay8oZLrYHMHI3wadeE7A=;
	b=8YaY0N1a5A7JId5wEKEtAWuR/RJ8TfEmfTWdedNv9JkOn5XIy+ye2Sb3FXUHP/ffG/Paz/
	yXafseJf0K61iYfZbY4zCW6N4KDV5DkM87aDtcWqs6iI8w9pTC0xCio3in5YNbpcuLMn/Z
	UHf1e5yhbt0bf+4j7F3iC44ucT8rOSU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HSKlUC3v;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789547141;
	b=RdSI22ZuPFpJ4E41KJB+dJyP91aCEylSwL5QYx8sjM588VnhflG1tApONBUcwW/hpC86Tu
	vTQiWAl+OV9TH74R6hqt6bCcZQX7I9crMKCyKM8jlFdHOSZWUH4Pu092e+MFcWkyRicJGE
	HV92tXDx2gApbd48oX/8hZLtqQuqj8U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kNCKnxPk9v3DaY2WfnoXeL4xOEmkLUhpLWZ4wNgVPAU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789547139; v=1; x=1790151939;
 b=HSKlUC3vTO1y6ucWWzeCU6AP9bK/soEJojPuOYBpsfqUS9INZMcPQNCsZu5npC+q3vh5w1p6
 JjfQSoJeJpoA8pvuHg8lNuraNxyO3ab+SrBM5IkVz3WgtWEnLADEbt9O3J8p4bJyXhGCIkYcNd9
 V0fae/XMrCFuBbpwsKujfGZU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 857b1b379797ed2c;
	Wed, 16 Sep 2026 08:25:37 +0000
X-Mizu-Trace-ID: 857b1b379797ed2c
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Subject: [PATCH 0/3] mm/vmalloc: fix vmalloc_dump_obj VA lookup
Date: Wed, 16 Sep 2026 16:25:27 +0800
Message-Id: <20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHdSqmoC/zXMQQqDMBBA0avIrBuIVlLTqxSRSTKtUzSRCRVBv
 Ltpocu3+H+HTMKU4V7tILRy5hQL6ksFfsT4IsWhGBrdGG1ro9YZpyn5IXzmZUjurUKnre7a9nY
 1Fkq2CD15+y0ffbHDTMoJRj9+R/9eCAMcxwnAqmN/gQAAAA==
X-Change-ID: 20260916-vmalloc_dump_obj-d80908447369
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ED36DC0009
X-Stat-Signature: xcwcapohzx6to5qk7d4ebt779qryoujh
X-Rspam-User: 
X-HE-Tag: 1789547140-685961
X-HE-Meta: U2FsdGVkX19cEsoz+cN+xdg6bY5CZaIJk027OluR2lBcYAgyjwPPDFNGnUroPNZcKvvoAVXF6vcsHH2KEraFknwnH41A8RmWcd0jM3NvsBuvr7+f4y9PPFdJX1S28UuGajiHSv6wwb+vRyouZNBDbFrmyAuP7bcVro/xWTUlXqDEq8iJ/ktDhKCnTlxYTIjCn0YA5t4t2/94iPFeZGO2qJGVvo3E1Mqidx05NIXXLXEzzx0Hmw00eQ06Eq8qc1Cw38QAgHDY6Xt5pkSw3o1peZOIcV82KzC+id37YsbWqigQTvVT9H2h/sZWqV858UBUrBCeHGaEZsTuhv6KUWPT23bhphDMpsJs/Z1kG8SKvGECe65dq9mGQPyzHw1ZIJpM0pzmSCvMOreX83JqpxZr0S+5/N0qNmdC8DuPuTKBOIDycKVcZ/g5SVAp15ZLtREYPtwNKfnn8kIpLqldMxzosNWwZ1nwOcnosqcgQpmKr4z0HQrtbtmKBgg5OaGr5kz2eIR2wbHr1G66jTOyTqVyeWVzqiPEoN1ksDk7zqmXF5eSSrvPfVBLeSl7XkGtfjPjZr4nAAmiEVpeIWk/n2hX/oq5k3o0aAUM2qwCo/RC+Lnh/LcXYed+7yhXKQsdwM76zNg2Us8n9Bhx24g843E6hmN95vodSiivUD8sL0YsLQcX17r873FHPoZ2XNAzzdtr+Q9aMS4EyRrnFogJvKUCRCEkvOWGI0L2EUSGop8xzo16hEKPG18iPM2ONNgH5lGORTyFzrWYRl6jpUS7JOaMOp6DFSwOsrQ0p7TxvbRc++mzyxbYBQy0XGfA+EX2Z/i+GckTokjLoMvojPk5cfeJd+5Em+PJ9LcLIg71VSOySVu1qrkRrsug2MH1DqAT6NaZEcZCJf9vBSrHRJeaGDaWsJWP7aSczyxi/moXx1c6GPO9iQ7/aMJitTiseqvlsZAjzynCie5ZSL/m18xRTwG
 ukP0sTH7
 oNYrYJ5HWWhxWORFeDKP2KaCByWuuwJkNZbPFi9i+4ZX2sT4eFEf1ZsXOZFM0fQ41kWnivsX4QH4l2Wzjjzf85X7UMsGwDQokBiC1DOY4K+qgd3bBV/V/tVlWoIaO3rUQGKz714Cedav6+5Ujf8TEBNpjkitVPIMiMqOCZOqrD+FaJdccepeE9l3pYQpG9n19BE9bmG7BvTd28Ti6RhKfN7LuzLLU8mfMQICi0cvXGCi3bSuS3YiZcksRKQ3OzcsV1I+yE45JuAmn4MtNDSx6ukDVTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmalloc_dump_obj() has two bugs that cause it to miss vmalloc
allocations, plus a minor optimization opportunity:

  1. PAGE_ALIGN() rounds up, pushing last-page addresses to va_end
     and outside the VA lookup range.

  2. The function searches only one vmap node, but allocations
     larger than 64 KiB may span multiple vmap zones whose VA
     is stored in a different node's rb-tree.

Patch 1 fixes the alignment, patch 2 fixes the cross-zone search,
patch 3 adds an early is_vmalloc_addr() check to skip non-vmalloc
addresses without traversing all nodes.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
Ye Liu (3):
      mm/vmalloc: fix vmalloc_dump_obj address alignment for last-page lookups
      mm/vmalloc: fix vmalloc_dump_obj cross-zone VA lookup
      mm/vmalloc: skip vmalloc_dump_obj for non-vmalloc addresses

 mm/vmalloc.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)
---
base-commit: e6e35979777d646fe3c7c94dca7dd32fb25d45f4
change-id: 20260916-vmalloc_dump_obj-d80908447369

Best regards,
-- 
Ye Liu <ye.liu@linux.dev>


