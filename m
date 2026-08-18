Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE59C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1CF6B08B6; Tue, 18 Aug 2026 03:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154676B08C6; Tue, 18 Aug 2026 03:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0420A6B08CB; Tue, 18 Aug 2026 03:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D16C36B08B6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:05:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C060A3018
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:05:06 +0000 (UTC)
X-FDA: 85113503412.14.49D6A03
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id A40622000A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:05:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qJbv8fTF;
	spf=pass (imf03.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787036704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jqcogyCGg70wu1Q5vb1IMYop9IyLUdmqSQiNTAzefnQ=;
	b=47qNmyrrO9sZIyTo7Rr+pMmXD+C00JhSCYs8PQNUdhLy/zces9SExcTXMGfWCusnwXD8KI
	w6TMJiBTOsDw1NVqdzL15sanFYcgMU2oK7HwhmxW/p+soFJLKPXcWRoztZkerkSJhcZh7s
	M56HkGdnvdurz2/s5G5cPwrHLorYXIw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qJbv8fTF;
	spf=pass (imf03.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787036704;
	b=HYBXIuLuQYs4jvPjEWV4MLXgOeb1aTAF14TOPF3Sv6MjC1K/P5qeoQmia2JXCaZ/g9aQue
	2FQlfSZ3LgtL+noa5y3yp+E2Ey7S63oCzBNHrOSI2CGYBdziPDUyNuuEwTbwyoNZGotQUM
	HL9EafTXzlMP+PAFt9EkHjkpoZgymSg=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-46f88060e8dso144618f8f.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787036703; x=1787641503; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jqcogyCGg70wu1Q5vb1IMYop9IyLUdmqSQiNTAzefnQ=;
        b=qJbv8fTFM9FLk66HW+MgvU7NKkbFzn3M/5FWOpN3BAhRLzOw5/UyxPvBEozCbtg554
         RnSXx4ahlEToV3NUC+mj1oV7yXHVdj2xwzJC4doaGDhWPveO/gDujK5lKMMWgVmEw+JD
         8RKJys6R8VINnMch/R0HeMOe7fRbzXRzbEfXrxfdcU+lNsGrJga6RJTENxKO91cMFH/x
         B6e6ZGz7N3OvvzQDken4udhLBTKlA7Lt3lAZjhoyxzG04lBG3sMIu3gnv9c1elBVG6wa
         GLrFW93ZNBu2OS5zmnyP14zPwEm/LvSv/eLdDcg9OxxTVNEJyHFwKPhd54YiDr/Lm7tK
         1dYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787036703; x=1787641503;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jqcogyCGg70wu1Q5vb1IMYop9IyLUdmqSQiNTAzefnQ=;
        b=gF/Ti4IO2Oa4EqvxuQLuglCyowmfZX7IYxLXB1LBMkAb8QUZdCEiit8K+/Zqj/cOVJ
         du2IxOPtJUUzBqIpdQOmN1tXIkN6IbfT7b+rbkJ+KrqVuXxOVi56mXoy6D7KxL3ce01p
         /Nlwfr2pbFToePUmaLXqaNDimeSth6MwoGzY2K0rnoeb9/DWEltrWXP5oZvprGShgBJF
         cdSmzAQ45ZvSVFDcuukDexi9efI/+YRcFKb4/cD2N9YCBPqzi+5NGgwCGsQQyzPzZgD4
         tIT6e1uZFiBzaygUATbl6PIhN+E3NVjSQpg8jFj75amIncK8sPGVv6ViIBeBet9Bwtik
         3DRw==
X-Forwarded-Encrypted: i=1; AHgh+RoU5fqIdMZG+zNB/zEuz68lSjPOIyOimWcfI6sK0kYvWyI6dwJpcCsTOTlBYY49kKazO+++jofXXQ==@kvack.org
X-Gm-Message-State: AOJu0YyYhp1Z4zgBsTZMkzpEE2vgWNATn62qU+UeLB6bKv7/cIItBTHs
	lAXM3zxDsOLbZie+hwMyLhAt1U61M4Ui6HKWBU027mI4BY165YTUFrmE
X-Gm-Gg: AR+sD12bF2mwhZQPcuOkgdxMwog7MMy0hKSj8prhk9f0dXJ5PrpNALY3rGbc3GSiXH0
	aejWP11vsj4QTchj/CrkE0r/AxoYlOhrLaUjFvbyt1YRIo7m14snV+zjX7s1ELzfoqhEJlOBemR
	oapPxdTzRNn33wgQsdWtWQ5jBpwJ/LrV05gfI7aCVNm71yB+Ko59bW37bJ6AVc+vcoRCtchd8nw
	pAFLYOBw2Eo7Zw0wa8ga1eKaUGWCPqrsMHTfxqKI42L4OLHN8jlXuaRU6o1wbfrjlK6YHeeiuU9
	SWbG+fHu/Nb4xuAhUpJ+2Wm933yXN5liGgDfT2dTDAoWoJU682EHak5bnE9BS9jn/lQivrH12TS
	EjXpdPSzia2LNu+z/4mnX5qGIunFwH3QHCpW0BqOHvYQI+zi9e1F74fAZ0RDgCzGKoIDvRAn8+1
	leza7RlWn8ZtDCpJHphKkvgGMFRIMkfw8E1NEtbMdgnLB1A+3M0vL2LWCF6vd86eVboTG5eB2CV
	b1AEI3GoFJPoHCcjcPr/agkCMbB45M6PRcxbXVOjOhM41steHK60SYI3SgGewXBQTRhPlDp9W4y
	upIvrnEvgv6QixYQ0YfKgftBgCC3cXU2Fdh9H1+MyKJjfo4ZLGpevx0I
X-Received: by 2002:a05:600c:8b57:b0:499:8411:9e8d with SMTP id 5b1f17b1804b1-499878cb099mr229907745e9.0.1787036702721;
        Tue, 18 Aug 2026 00:05:02 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996188217sm495557495e9.13.2026.08.18.00.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 00:05:02 -0700 (PDT)
From: Doehyun Baek <doehyunbaek@gmail.com>
To: Alex Shi <alexs@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>
Cc: Doehyun Baek <doehyunbaek@gmail.com>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 0/7] docs/zh_CN: update DAMON documentation translation
Date: Tue, 18 Aug 2026 07:03:42 +0000
Message-ID: <20260818070358.455768-1-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A40622000A
X-Stat-Signature: 8gfimorjh9i4j5n78c3jo995jrkd8di3
X-Rspam-User: 
X-HE-Tag: 1787036704-171324
X-HE-Meta: U2FsdGVkX1/T/oYLxn7348urrzXPk8zFg+lHbBu0Ogl/DWHAWeAsa+ynJYfr+vqRZBqmRRnCEWoBYVXNpdlYHHwTe9N9nUm7MmTDOSU+LhK7GN+9qYewU+VVGrgaHeskSGRcMmgdTZgrD+An63z6+IUVOw6Tiq2Gw5BTCsif0RYwZNRY/dVGodjrONOGeNSST6zSlMN0OAOGkVn/Gfq8kgLdHPt+FMmSGwHnhAOIYtupvrYX16T7niLRZjTbpveSgis/giJ50/PzcgktO6/CxBms0U9uyGZxHHm1Lmnw2DIZ7wtH//WfB+VBwATLf9pG6jtnZ4TKkrbZSMWeHH/OMa32tcUh8G7Hxy0ARUxrYmM2T05RrpApUsIVBSzbsDyfwXHQ2yFLHld4li0LH62C6ufAyh8Iv9w7bGYL42xGNvCykQlSQFtPnu1O6tiKWBPafdcpXL/HOdJLf1B3q5XUk1FEY1FRnpQs5Tbo7PGxTKu3WVTxAiEsZI7Oa5KpabFVvRlOdNymz5gBg9jvcRmVJmY8JTqQ4SYtne+CQbiGClG2oyPrKeVKl0m/LNnmXYQQu1OUgWp5tcDQgtOPMN4c0u0q0RHyKJosgov1Kv0YYHmowDCSrXWAicaxd+LXMH8Lca6TyWjYlgWr9qJyPmCGDEY+9ED6AcFRL/edWE9Q8UDrtye7Hahl/P1HH+Wjrj+fV88hAnjffh/uKnxJ5xSJuDvDPyjonjVpEDzt6j2sQ4nihE+miaGp2y+yiUaxU9BfYdDoPa0WT/Y5xyKQFdhxDM/jaSPgk2S3eI1//vF94gXBRGQWbUVgDVouGreQHNrVnfkjoR5zmIYFDreRd4H75T8DQ3EMidh16OOC8tcvPkz8hl463Cu7kJEzEf4EfMIbAaAFO9szXahgAou/kgyk5AX92bAMa3QxvF1ARPtnP//Rn7JOV59NxgnXoAULk+xTXCQVEmJEkFGEpG6wcRs
 WcSaEu0C
 jlR+pH3/f5IcPywfjAp7mbeTtb7AIIXEE9KS7OnFG3yrKaKH43E8XgCxYV13xhyleh80XPNsMxtY4DEZU9lINVB6SCUM/fn52jHnZQwT+wguUUMaBZEYwMf2ZpybBYMWKjnbJhe3bpgAZHzCwf27pdpip//DInY49vgXlfiq1avVB5iB5r7b1Mq49pJXW5AJmnTqTHg9PZ8JByjihqXuZjsIkmsPZJtxZzmJtHuzAfPvw8bJO0YYJCNUoCpMiWhhj1F/rAeDvq/llS78Zz2rg5ykqxVcBLYdNAoOa8oDECzZFS5D8vp47Up6uxKOVukcMnmAPV3u6WSdfgDX48tYJkx6rfb/InMccuno2jzKhwOXSMaSQj2l5WAito1U94em6+91IPRRDKx7lkO3z8zVotVkNRxjDDjkNdMjtZqd9PpVEusP1zGZKpa5sZ94yxrHOrzBahpSyssvlHlMv6qgnncEYsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bring the Chinese DAMON documentation translations up to date.  Update the
DAMON design and administration-guide translations, and add the DAMON_STAT
usage translation.

Changes from v7:
- Use the suggested translations for the DAMOS quota goal ``nid`` and
  ``path`` descriptions.
- Replace the remaining "聚合间隔" with the consistent term
  "聚集间隔".

Changes from v6:
- Clarify the DAMOS quota goal ``nid`` and ``path`` parameter descriptions.
- Improve the translation of "offload" and fix the duplicated character in
  the non-access-pattern filter description.
- Consistently translate "tracepoint" as "跟踪点" throughout the series.
- Consistently use "监测上下文" and "聚集间隔" for DAMON terms.

The changes were suggested and clarified by Dongliang Mu.

Doehyun Baek (7):
  docs/zh_CN: update DAMON design translation
  docs/zh_CN: add DAMON_STAT usage translation
  docs/zh_CN: update DAMON index translation
  docs/zh_CN: update DAMON start translation
  docs/zh_CN: update DAMON usage translation
  docs/zh_CN: update DAMON reclaim translation
  docs/zh_CN: update DAMON LRU sort translation

 .../zh_CN/admin-guide/mm/damon/index.rst      |  15 +-
 .../zh_CN/admin-guide/mm/damon/lru_sort.rst   |  68 +-
 .../zh_CN/admin-guide/mm/damon/reclaim.rst    |  82 ++-
 .../zh_CN/admin-guide/mm/damon/start.rst      |  63 +-
 .../zh_CN/admin-guide/mm/damon/stat.rst       |  94 +++
 .../zh_CN/admin-guide/mm/damon/usage.rst      | 523 +++++++++++---
 .../translations/zh_CN/mm/damon/design.rst    | 667 +++++++++++++++++-
 7 files changed, 1345 insertions(+), 167 deletions(-)
 create mode 100644 Documentation/translations/zh_CN/admin-guide/mm/damon/stat.rst


base-commit: db6ed2a3d31068ca5577466591b2521dee0508ca
-- 
2.43.0


