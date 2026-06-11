Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B3EFCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 06:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55AD6B0098; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDDDB6B0096; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF09B6B0099; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA6C6B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0CEBC164FCC
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:39:41 +0000 (UTC)
X-FDA: 84866680962.16.F072824
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf29.hostedemail.com (Postfix) with ESMTP id B325C120005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:39:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781159979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=3hsms+uwiBM0YtXvLTanLWxtOe636bEMJOHovnVcTRw=;
	b=b04JmXwi4U5Cd0UhvUAtr2PhJhuCttutBu17DuyOMQ+1ZgT4ZlSG2DpnOwu/8e/1CzDceI
	MXwecwuylMwU/wX5myj4+hVgVtxrxoHUqxauPm6vJ28CJLMUmL+g2GQgR+TSJKDFhTs7R9
	h7P2p0ChuGe2/JiqKUZalyWGCfn7WyQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781159979;
	b=Qt8+QaL8YGBPt82paHNWGC6oNk3gEO0O3RhJhCN4DC9k8yi1UAvY3YWpaNMUcFctaBREpg
	I9CxkSns59VduGgJ5PtvQYOD1cYx6IQo5yjKlId2O4XA9WOcFFCyHRw/nCTipJIUMczVdh
	kaaHigNU8Yu5w2rbwwiyJs9sx4e0hvk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn;
	dmarc=none
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-01 (Coremail) with SMTP id qwCowADHbdYgWCpqYOJFAQ--.1790S2;
	Thu, 11 Jun 2026 14:39:28 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [RFC PATCH 0/5] mm/slub: preserve previous object lifetime
Date: Thu, 11 Jun 2026 14:39:21 +0800
Message-ID: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADHbdYgWCpqYOJFAQ--.1790S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tFy3WFWxuFy8ZF4rGFW3Wrg_yoW8tr13pr
	43Kr4ftFnrJrWSkwsxC34kXrn5Zw4rW3y8WFyagr4Uur4rWr1FyFn7KFWYv3Wxury7CFy2
	vrZYgasxCryDZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjTRNJ5oDUUUU
X-Originating-IP: [111.196.245.140]
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/
X-Rspamd-Queue-Id: B325C120005
X-Rspam-User: 
X-Stat-Signature: 8jk44hjjxpnyoeypaz1dod4ugq6oacxc
X-Rspamd-Server: rspam08
X-HE-Tag: 1781159977-596670
X-HE-Meta: U2FsdGVkX1+x8suWTZUObr5dZ16lLpAhI1mpTNXGIFp9NPtvdpOxjx3z5RoJAEPqCVZ2ukBsQkPRx+s1QX3tD3vS5/fba5yN8GYsELnVLYJ6myLo3jv7RvWZLTTZECB8+njID38FyM3eeyrz2eS/pAMWdomOpfS6dt1GlFVekqJIAmwUZH6EcDeVaSfTOJCrs85NVLRc0tsnY+UgLLUlmDeNpVtisUqrpR3WEZBaMY85HyRt65HaHKUnrxf+8OhudRwAywKoRlml49xuJN1LXVeswAMa2LUHQqz3Pa4ujNWXF8jo3ptmHMAjuMasvgnVrwvpSVYC2RBGFV3jmrynbA+C3X2ZWDNPOxIEyru9bOdQztLiJSesdegAYjZ4oGR0VueZBJswHD+iHsy6PdHAisii1sEXiX02YUv2ZcZ7dZVNlCxyFqnYqLbk8ru4j29FDQMmcB9rc1jl22P3F1cp6UwuLFeU6uNKlNhyyvjbAb97Bs36XIC+Lp+QeHWeKv19V+IPAamOGB2G7ExBms3wLjljyFcAeKcbq1bCciSJgt+xqUrmhV6Hzuy0upJjtxGaSUcAKCufRksGPgR0Ai/IueiLZPM087MSxp1Bu2qgYlL8Yxgtsd4bEqwicllSQgL1Rc7ScIIe+eIuNQRgtc3ltDzeGgmQRS+E7zJH1rj0/YddjZ2AY7yvvqD0/IJGFGxHiK3tjowq4CGTBVscMo9/8GZ/BWbN/RlZ+G38/RAw+hZEa5RdZcD6xM2tvavrzgcUtbRII8rzRlCjVQS618crmZWcrOaPqqfelus/S58bz1iLE9FnqzFlGbWXZEJvpo1QcfzmSL4/CfRI4CtQpCYy9rsYGnLlZZdPxrAWunkkUV24oDYLj1q4a/I1PLE+1zqonm0J//bhiGHSsyvz3XdGMZ7muy4e/3qcv4gksz8QvgxcUPQ8u3xIUrZ5eY5G0pNyh0rcY73farK6YfZWYJh
 SvByEWK3
 ZvtOBZhnh6DG+CNBinXZJSqme4PPHR8Vl+WLcuKwCmSrUMHsvyqVSkyDUIrTT05eCw3+HxznkEnaKxVsjJfcjRn+0ytp8Dtgmbz644kZsRoG5gddIABwnm9jJCw/sccFxBr6Myt4CjHtRgjljPha7GE1elzHoq5Iw452E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SLAB_STORE_USER currently stores one allocation track and one free track
for an object. This is useful, but it loses part of the previous lifetime
when the object is reused: the new allocation overwrites the allocation
track, and a later stale free can overwrite the free track.

For free-after-reuse bugs, the report can therefore contain the victim
allocation and the stale free, while the earlier alloc/free pair that
explains where the stale pointer came from is no longer available.

This RFC adds an opt-in SLUB debug option to keep one previous completed
object lifetime. The option is disabled by default, is not part of the
default debug flags, and only takes effect when user tracking is already
enabled:

  slab_debug=UH,kmalloc-128

The series intentionally does not attempt to infer semantic ownership or
identify the root cause of a use-after-free. It only preserves and prints
additional track records that SLUB already knows how to collect.

This is sent as RFC because the user-visible interface and the cost/benefit
tradeoff should be agreed on before this becomes a normal patch series.
In particular, feedback would be useful on:

- whether a separate H option is preferable to extending U directly
- whether H should require U, as implemented here, or imply U
- whether the extra per-object metadata is useful enough for this debug path

Not included yet:

- KUnit coverage or a standalone reproducer
- object-size/order comparison data for representative caches
- runtime benchmark data for slab_debug=U vs slab_debug=UH

Those should be added before a non-RFC submission if the direction looks
acceptable.

Pengpeng Hou (5):
  mm/slub: factor user tracking metadata size calculation
  mm/slub: add optional previous lifetime user tracking
  mm/slub: print previous object lifetime in debug reports
  Documentation/mm: document SLUB previous lifetime tracking
  mm/slub: sanitize previous lifetime tracking flags

 Documentation/admin-guide/mm/slab.rst |  22 ++++-
 include/linux/slab.h                  |   3 +
 mm/slab.h                             |   3 +-
 mm/slub.c                             | 118 ++++++++++++++++++++++----
 4 files changed, 128 insertions(+), 18 deletions(-)

-- 
2.50.1 (Apple Git-155)


