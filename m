Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 316DBF36BAA
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 04:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996396B0089; Fri, 10 Apr 2026 00:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96D9B6B008A; Fri, 10 Apr 2026 00:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85CE46B008C; Fri, 10 Apr 2026 00:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75F196B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:43:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23B6613AA3E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:43:07 +0000 (UTC)
X-FDA: 84641401614.18.76006FD
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5B1D820003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:43:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tvip7exW;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775796185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NFMB1FxXIFFJF8R3xMlXqM+VGggoB7XxMGsR8vdRK1I=;
	b=krD3QojsDg6T8FzA2jpZDldQ7dq5rc+d/UIWHPTJ3jA5R6ISpyMz3H0QOVB+HHgVVoEMff
	lwOVjTCbcPZZPTHS3tvXsLI55qOwkNrz6flTx3FnjiCkE7p6ONQsP8GaYklO6p5cW3o/4C
	eK+DPRqAcf4w5SlxfXSnTNVpWjmaYLk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tvip7exW;
	spf=pass (imf13.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775796185; a=rsa-sha256;
	cv=none;
	b=8SrLSIF717IiHR2jBf7Y5mvnFhDaNJ2FCUn8ON7kZIIwsPF19XQidQAYXh6U/5qGcw9lta
	HfIyWbH9GVofmVrMfLycD41GzT5kvZR3rEP3y5FC8soalOn8FDGN74vy+dOfX3NHSBXMzO
	C53Mive7CX4kV7TYbdPVQ+Xdl5Zm/Gw=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82c68339cf0so948564b3a.0
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 21:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775796184; x=1776400984; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NFMB1FxXIFFJF8R3xMlXqM+VGggoB7XxMGsR8vdRK1I=;
        b=Tvip7exWBk6N5mrpbDZgUO35qkL2G6LjqTWX3sO7c36N1yzawCTSbN6xETwawKfXOJ
         NxVLX4vjF/YoNVyLnAptvj+AaDM+nHbC7PBszRJPxfNTrsZkalqFfV7yAPUqN3PgZEWU
         4xXeh/SNM2kFFwAci24iizVom/l+CuyLoDrLuntQdLk3dEQ6MPxOv3sE/caRKGV61w1q
         hJAGZfC/DnGL5ugFaExugihB/5gi6sIf6KQe8DI9lBCszRcXzhGrEVEV1nBHhDJMNFOg
         +pU91rGDV0n82xqyx79XYKX81d4FvioW+qc8yv3if5mr+DFPiM3TBygcnDdWb70aN2En
         /Y2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775796184; x=1776400984;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NFMB1FxXIFFJF8R3xMlXqM+VGggoB7XxMGsR8vdRK1I=;
        b=jxOZP2PQpkYV3eFTz56CZyW/r/RSxq3VGsQYYt/fHXocYzc5XEk8NtnjAxeX9M1pru
         xUUwi1YLS0joVDvkkVKfGXClhzUSplSJs+6rrlwDRUmi4k4EUQ0tHpL7Lula+sYpOxK1
         pOBZTSa6S+Vj9gK23iAZyHFh7xAOIgKey0xO5aI9ut/NVwHwbVSoCITnnjjbY5Z7uLjt
         /rjG/CDpe7S2eKEljUmq+vrxM1zzCvsv18+K19JP9QME81+9hz39ZZ0qqdsPDaYF6XKp
         wQyQQsCLPhDT0/HI7JCq3hXvUg9rn2WUy0gbPrxBrCGFNJTUphwUfYjiR8AeU7faajam
         WqHg==
X-Forwarded-Encrypted: i=1; AJvYcCVUeqy8Ac+MJv4mT9l9+lCRgoPbkaPD0Ql9gfywkhbQuqVyvlgcMb5nNcdQhYOHX1jee4Sdb3yVEQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2xnB2/gAKZWqvabeO394RC3FoSqCkXvNK0cxI1HOKfMIeZm3X
	9qQMTUQYu0B8XHukjV3VxLsBRmKHL2p0iceCcJ+6POMELFKOTzwTVyncPLxzCA==
X-Gm-Gg: AeBDiesIWccCWYUwHaMqI3qxXa3C/3gdpkEo+AG3cjhOAJCaYaQAPQD1xdhSV2Zn+e9
	+uKhJb3fU5fkFFNs4hJ8Hp4LpZFAugir3Nx8iqdM8IG3opXIAfuMMwDJShprJ4oK7r9anf3Q9nb
	G1mJZ23d5PnVmjjhqqOiOJK0hvBge98UHuPhm8efVNz+JY41qnUx6Tmb6rBYoriHgI7oArud1Pi
	CywxBZlFI9pbwAHPyTt0OVGCDgvcUvpAAUf6VMiRZNSS8tqFtnrJX3HZceqQ5sTnj0KPI3GHyUJ
	aXAM1eix2yEvcUDspU8pNsj4nVPmiLOsrQyOGoLLfAWxTk2QTlx9hQagg17tV25khV9i82+RZP7
	Qe9vaJ4jaxX9d7x1bV4zzX8vsqaHKrjhw2wSPagA3p+erNURWRxbPTv5Xo7QIiE1s+G3OMOHUQi
	pa88xAk+O/D+bxcy0C/8SlrbAtyPI=
X-Received: by 2002:a05:6a00:2e08:b0:82c:c390:ad77 with SMTP id d2e1a72fcca58-82dd8a1dbb5mr5459830b3a.7.1775796183969;
        Thu, 09 Apr 2026 21:43:03 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c30e7besm1200109b3a.5.2026.04.09.21.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 21:43:03 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v4 0/2] mm/damon: validate min_region_size to be power of 2
Date: Fri, 10 Apr 2026 12:42:57 +0800
Message-ID: <20260410044259.95877-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4w7fee9bkjdhmx78zyqdw6ocseixg816
X-Rspamd-Queue-Id: 5B1D820003
X-Rspamd-Server: rspam09
X-HE-Tag: 1775796185-637086
X-HE-Meta: U2FsdGVkX18sw7MPlqeQaioAhwWjI5RHPf50cnIXk00Z18OCATIL9hpYgs2QMS3trqmsBDB3LUmOgGdJt5aFuxKCk30NmrBR0yB1A7PEIoXTaApWZehoOv0ObDwHbDzHLH/oi7AOPoOphKQ0R7upPL4Xbw6wWE8aS7qh7vKQ7WfCrqK84pkxZ1aEJC+HEjL67IiSq9CmUw3+dtqmPFlbBDk0DtY8RMguKvQzqudH0siaDvTv4hVdVhf0HIpS9wB3uM2seFtfhcr4XCg1LjhzdNpe55+qQPB4bSTLD5v4A3k9Tx0Jrv954egryZk0W7Iw7l0klHi/M9v6Lg+220zii+MC5l5ApLBPQtYBWAUyfn4gRbtjn6vERfLnXIl7NsmPaJKyBP+ewQylqzJQQzzSRgjqneVO5S7gO3vEWEgSeDi/HmXgBSrMyOta4/6HFy7DjcC8/650Qob3hfKgLjqZIlDAq8ybS1txer28KBewl4ITEBGHxONngKdrz92JnW68Q9Zfb2CtyPGlHmPPx1SIb7qa5tdwXx6AempF4aA6OKOPeaAA8a5Lj6qg/KD6uCCrvstwf86hZ7R82dRfsrOvezuD+eaouHx8Gn+s8KD/gS91K0XCKpEamjkfcCG+fG1guuoDqvPq42xnZlxg3Jgt0sMcZv6xYqb7ZS+1tD6zdrpH+U7tu4NcOkXfJO5Dnau3SYXJD3AYOOotKAwUjYZZN6krfYEY9UBafmNPvBrP0U8XEuEmKmVfuzqHP1lqErli1fECSX+Njdwdh2exG0ysz+i7LIIEjdNngsTmn33M16NajnuJTuAlDWvoGNkAoc9BAsEV1/qi0wqbqTArGK5TWcAfu+371p7OHgLw7dShQn+JmkGXPUEewFNCjpYAQnW66IiPLyqItmSHhFAN/1Cyy2PcN8Dxcu1SF0gJ72ruiWrJICmf1yE7XSl5/oLGMkI4GOazuJfcnW1RkeARHwx
 XWZ6unAA
 2EP8nwWsKDLKcAkZ5UXlalhRiF9vP5SL96HAcXukpNZmfyDWENEzKE42bnDTqTtjOAhCHlC6UQJ4vAhFubjc71kstIj9qeywyU9G44LrA0KJP/PXXxNpLi9UCcG5vlTLF4MzlJ9un/Ae4T0qTfqC+82vM6TB/HQvY0OiaXs2glA/kmDoCDzdXF/Z5iVj71v9U2cEZcm5/MoBDmctO9exhUVPv0/x7Q0vL/VIztaVoSvGYwF/XNadJKj7N3Xs+F8VanmJgSsnCajlQL/ZgQXw/dVgsRqwdVDcc8Yl/a6ItMk4sJTjutzF/wx+hhoMJi0pvL8f69HpJoeQpCBLzdsmDhIUpwDFbacfmlXhzWBdNDEgVYM/RHnjperJV16q2sLuf2Cf6edwzMEoyL9d94tRuDaIto4/C82D/rf7qhXY1u0qoy2wmFBcpieXgryt893f4Tax08/ADfvnbjUqlDK+O4cchwGFkrHPqiQCHN5wtC5qdO4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
When a user sets an invalid 'addr_unit' (e.g., 3) via
DAMON_LRU_SORT/DAMON_RECLAIM, 'min_region_sz' becomes a non-power-of-2
value. This value eventually reaches damon_commit_ctx(), which does:

    dst->maybe_corrupted = true;
    if (!is_power_of_2(src->min_region_sz))
        return -EINVAL;

Although -EINVAL is returned, 'maybe_corrupted' is already set. The
running kdamond observers this flag and terminates unexpectedly.

"Unexpected termination" here means the kdamond exits without any user
request (e.g., not by writing 'N' to 'enabled').

User Impact
===========
Once kdamond terminates this way, it cannot be restarted via sysfs
because:

1. DAMON_LRU_SORT/DAMON_RECLAIM is built into the kernel, so it cannot
   be unloaded and reloaded at runtime.
2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
   Writing 'Y' does nothing, as 'enabled' is already Y.

Solution
========
Add an early validation in damon_lru_sort_apply_parameters()
/damon_reclaim_apply_parameters() to check 'min_region_sz' before any
state change occurs. If it is non-power-of-2, return -EINVAL immediately,
preventing 'maybe_corrupted' from being set.

Patch 1 fixes the issue for DAMON_LRU_SORT.
Patch 2 fixes the issue for DAMON_RECLAIM.

Changes from v3
(https://lore.kernel.org/20260403052837.58063-1-aethernet65535@gmail.com)
- Improve commit message: clarify "unexpected termination".
- Add detailed User Impact with reason why kdamond cannot be restarted.
Changes from v2
(https://lore.kernel.org/20260402053756.26606-1-aethernet65535@gmail.com)
- Split the patch into two per-module patches.
- Add Fixes: and Cc: stable tags.
- Elaborate user impact and reproduction steps.
Changes from v1
(https://lore.kernel.org/20260331073231.30060-1-aethernet65535@gmail.com)
- Fix memory leak issue.
Changes from first attempt
(https://lore.kernel.org/20260327062627.66426-1-aethernet65535@gmail.com)
- Renamed the subject.
- Validate min_region_sz rather than addr_unit.

Liew Rui Yan (2):
  mm/damon/lru_sort: validate min_region_size to be power of 2
  mm/damon/reclaim: validate min_region_size to be power of 2

 mm/damon/lru_sort.c | 5 +++++
 mm/damon/reclaim.c  | 5 +++++
 2 files changed, 10 insertions(+)

-- 
2.53.0


