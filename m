Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995CED78797
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 00:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7CE66B0088; Fri, 19 Dec 2025 19:02:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54866B0089; Fri, 19 Dec 2025 19:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53BF6B008A; Fri, 19 Dec 2025 19:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 939326B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:02:47 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CCB0569A7
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:02:47 +0000 (UTC)
X-FDA: 84237898374.16.F05EA0A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf14.hostedemail.com (Postfix) with ESMTP id 35722100003
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:02:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VOgrW77Q;
	spf=pass (imf14.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766188965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=76P357GKLseaAavWY90mvS2jw7NFVzdOZcsZQJD/rVo=;
	b=XQtQxVPJeKR5lyfGmFZv46hUOuJqdSo6Wsy6uYOqA05yXgC/qrhUJvOa1q2fJRLsLQGtGb
	6/EyzcmRFMpFdAykJBdxoTnymgHEKxDvfoKHwQlWR1ZLIHBxRIgRMdKoc0T3wYqA4rSxnh
	b/wJn8IFnSGIJnGQ48vtD3KOCy2hsrQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VOgrW77Q;
	spf=pass (imf14.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766188965; a=rsa-sha256;
	cv=none;
	b=T4OaHLAXIWU+XEUivZUhqN5QhY17otIKmRPt8ozIkpx+wLR0PW56cvn0XNcyQyb3/ijtIg
	Z7Hpt2uxcVcr/r+vzrano0ceMngVh1/MGkkYkZA+JSAnfliqoRDxy040PUduT1sfAlItvj
	rruv5Ustj43zGZHCNK1korKpaJj36d8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766188964; x=1797724964;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vc+XxLwHeHijZjTHWLK3bfvxAqVVeHaAZAFFzRoBPHg=;
  b=VOgrW77QyOzfLIKng8o0fQZDA/noSg9+P0/bqpkle4p/f65Sj8Tsd9LC
   AJYqLOXzKEiQtva6wjzBAmIlK5sEQ8Xo07Xi35n6Nd0Zi0xSCskH4VKAV
   bjR6nn7VquKQya16zmYSvXQ1SHePdsgc3RTKqnW5M66BF7mWJSoWPxR+S
   rMeRlHkBz50Gh5qmk4B3wQyEtCohVgNU25xwHVcP6yhtEkkyYPuVRfjSO
   c7KfoQrxSLVL9NkCXmWOg5zOccm3/oiso+u7ZFh88W/M3bByTpK62+Xlf
   +ygMwY7Mi+XqSWwcBUhFg8VkfhpSrBKH1MV9HZV7lQ0zieIwRXryasOe0
   g==;
X-CSE-ConnectionGUID: sqE+RbSBRxSkpcAIahQNSg==
X-CSE-MsgGUID: j+kZKI4wQF+Je9k0v5OpQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11647"; a="72011084"
X-IronPort-AV: E=Sophos;i="6.21,162,1763452800"; 
   d="scan'208";a="72011084"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2025 16:02:43 -0800
X-CSE-ConnectionGUID: t6+gLKB7S9SdlyizljaHAg==
X-CSE-MsgGUID: Z2883YGqTfKX0tfEpDL3tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,162,1763452800"; 
   d="scan'208";a="203518335"
Received: from dwillia2-desk.jf.intel.com ([10.88.27.145])
  by orviesa004.jf.intel.com with ESMTP; 19 Dec 2025 16:02:42 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	John Groves <John@Groves.net>
Subject: [PATCH] MAINTAINERS: Notify the "Device Memory" community of memory hotplug changes
Date: Fri, 19 Dec 2025 16:03:27 -0800
Message-ID: <20251220000327.3502994-1-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35722100003
X-Stat-Signature: sshap7jo43bnzc53n9s44p9pr9fcjrfr
X-HE-Tag: 1766188963-732258
X-HE-Meta: U2FsdGVkX18QYgzM/CXhblF+OjXYgqm5QtWndJO5qu3oYrQY0x2vEc6ez1wygF+D9ndDYsC2WFqW2scp5m3BK6EWLqzfYx3DtmTq3F3hz/iE/FKBTE20rgfZj3anmREfyYZQL3OeLp3jerlmI24xadSG9NsobnYSu21+4BjM+JUyCAaqLsvDl9a0iMEPkT/K9NdFC+cEeMEYnqo5CbZVIptuDb8qmMy1IF5Zh1JNjv2eWFmdmv6Qu2ovIYk977uFcwmPX/Spq4v5M+pLg8J7AoliyYtjnIGVW/BHdE+yALWxfw8cMZv55tnGhp2Tylx5uTckyvD0Jm9n7hPnxWgZ7nffPHCBsAoF/Hn97pwvQx1zdRIP4F+Jc65DEup4/KJEH1BRPofLTeVH07v6CfzcpqThKG1I9FvS3XUoUB0k9wkjm2+zvexobz3cKurOAr3YzPzhP1/arC8jCq49piVANQw82edD/oNWQymBDf+2LEZzairXuW03rDoR7CW0/ApThMdwOin0VhaA9L7LsrtIKpqhBw7VVXFLN3wbvtGHmT/a2qjcZ6UT/PjRaMS2nV4FQ5cSKSLzJ2dV9NlTvxDNwSbwgXU1MCOXsCr/1CrWV+jvhoFizcMNz9aZPu52CLCfHCjpHHLAD4KYIRxyVPGacYDyzleOaRUQMA5HteX3ivqyuKnd24z4D7efE6f04InZVMjV1M7BXoMhrzcdgvWLMjxvEAD7QGITcgi8GwNDK8W5Q9DhA2YkzQO9xaUG0Jx35n9VUU2t2hkv0upTNcyNHAoQfxDQzJ7Qq3uOYin02mnLmOZOJ3CwbGMrSWYBmHIKaHeTfSrc3xwjlZzRfkTy1S3r1KOaoenAtftBjenXHgi3jDi48al49D46JBwld+OSCGOdWVOZARrJYGIgKZL4QWJ6IyyCeIb2+5s5wSiPjHtUaX+suK3HHemAqe++ReaQAD8Ut4wPfBBe9tHUvad
 5SMzANQN
 MsFTk5a7tGzW7gnefc3O24wJcVEqiPLozYeS7YoCktpn9OpBVID6fG6Pk2K/4e6cuaPuxTw6giuEwlxnPUgO8v0ijMnr0FtVVwzPuKvq8gcJfRRdQeTdL5+uk4kbzCsnq7JK9PhgEXVTiAjGzbNJoI0YduH09Kzr2PL/b9/IOVvYwE3fDmJsZAAetx/seTI6SWmX5Ri0MYazrpaSfSmkwsOdUoIOeJU4Y9R5iWl7UdPzTedU25/bnyT/GCar70qzjcZo0ezRS6523SE6Mlp0eI4m60MSL1K7n1XGk2s9jeH24OAOmOssamh1pl0eR2LEjTaAhvBNdv0lVklO9QN6alYXsZFxn0/XHbE2aSTY03xGCWNPhWNwIOz3820JKPl+XxnM/EAC/qBV0mOnUktqzFj6VUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The recent episode of a warning regression in memremap_pages() [1]
highlights that relevant updates are being missed by folks that care about
core ZONE_DEVICE changes. Yes, CXL folks should pay more attention to
linux-mm@, but it also would not hurt to copy linux-cxl@, where most Device
Memory folks hang out, on memory hotplug changes by default.

Link: http://lore.kernel.org/20251219123717.39330-1-john@groves.net [1]
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: John Groves <John@Groves.net>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b11839cba9d..076322fe91de 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16426,6 +16426,7 @@ MEMORY HOT(UN)PLUG
 M:	David Hildenbrand <david@kernel.org>
 M:	Oscar Salvador <osalvador@suse.de>
 L:	linux-mm@kvack.org
+L:	linux-cxl@vger.kernel.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/memory-hotplug.rst
 F:	Documentation/core-api/memory-hotplug.rst

base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.51.1


