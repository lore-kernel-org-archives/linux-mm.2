Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A94FA0C26
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 05:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6F0F6B0092; Wed, 15 Apr 2026 01:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B467F6B0093; Wed, 15 Apr 2026 01:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83A96B0095; Wed, 15 Apr 2026 01:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CCCF6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:23:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 26BAF1603B6
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:23:08 +0000 (UTC)
X-FDA: 84659646456.10.C86F39A
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id 548F740008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:23:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IDODRyD0;
	spf=pass (imf12.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776230586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ahvhNnnqb7Kgkx1NCZ5CBW0y21V8G4hdByGJdydbTqM=;
	b=JaJL9EF6hsaJ+25HHvlNuQRJAK1WvAD1Jg6S4FMEgujEOcWFluT2n2NunzDfn7AcinqSOq
	1M2tltTnCjjVf4HKTrwoKJ2bvdunyeDblqwc5I1xo7ZIQvCjST2nvzFtXJLVVORaFtI6o7
	UyjxTo9p0CR03N9NlUpMIRt6pWZvxeY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IDODRyD0;
	spf=pass (imf12.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776230586; a=rsa-sha256;
	cv=none;
	b=ThcwOQKAnZ6GhfAro83ZnGPWAFxM2tZGr8x3YKG/PBk0Qd3JLBFW2Cu883IkakOT+/e2Oq
	49fpiIyBj9pqmzhY9UDBn73jXoxAIeWZNNXsBCIKc0WgvTVoNEjVkcFk7AtqTeqnrtXRsa
	gVwP8cCa4djtKFKWKk5XdnFC5achoBs=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43cfd96354aso3779989f8f.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 22:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776230585; x=1776835385; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ahvhNnnqb7Kgkx1NCZ5CBW0y21V8G4hdByGJdydbTqM=;
        b=IDODRyD07Txi7KMXjCqK9je1zf/A3bcQNmnCwHjJwt4U8Vjlpg1uOuVBDCcQVy1g/D
         l4LVq0Wpp5z+cMjywfwjaT9ZCqjvkFnoqQpcKEL3ypr/ccvdJyu9C2DO3oeyVs/0rAGm
         kGbo636xv7CtcLyiBCEv07guVL/NGRA4JzwP5pC2aEMEmQ0IOP1cWUjpIB93vj8t+Os5
         Oew8gknJg3Mdy7dcANgD98s9/33//ukTGReZeUPXSf89UiQzuVAY0RsDKoxnyElpwUWw
         Wkuw8qa6HbfPZsNKsizLkcqqAz3o3ait77tIWD+EbqZRvt5WjNYxz/aBXBZHgOnJiRZe
         /OBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776230585; x=1776835385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahvhNnnqb7Kgkx1NCZ5CBW0y21V8G4hdByGJdydbTqM=;
        b=WwBk5tCpz5Q+WcwMgwekj97YSMWaZBq3fNKdMINxEHqS6pPcX1m+bhgbRjVoOcxx23
         VAdcgfG6KFBuYQjrtq2UxhPyEGkZoE13uI5itbpKyD53Ab7zo9xF9GTAnF1b48eFaQy9
         4mkHthiT70T1gW2yMhCWwAbcMaALIyrDh3OLl6UXC8hJtbJSdDuusvK+2PgcpjepBkD6
         uhBHLarQrj27smF7OBLmR/C39OVlAjE1wTVSleaTIaU43Q/TQ3mQcgIsAho2DHUXNu8y
         2NjvJY1mhr3KlKjmJrNcFyiiHLSWCYOf0lN3yoV0zYgi+JxlcRG1XBs3lXC9PkNdLWbL
         TvGQ==
X-Forwarded-Encrypted: i=1; AFNElJ9jSVnpRqixYwTA96Rpj0J07dpl1aTk90gqJj0IS2BKEGcSYvvbsUJoXe66Hxp07PhiH8pXBhn6Rw==@kvack.org
X-Gm-Message-State: AOJu0Yy58Tkv9Q5OhdkfSHgIirEnJbVaFb+A0XaaNJsucs7XBkNWKml6
	HN/FR4lPPVcI242JVRKLKMOmdeauXn2nqbrjjRf2nLoribmfmuS2Ctwe
X-Gm-Gg: AeBDiet2gEEp01lt97KqMmqBB7r1jrL1twbP/kI3P/3yQyG+LpbYZgMHKQBykU6gnWM
	Xhm7mGi/r3xaKP9HBLQoT5aVAoMieq1m49e4zaImddiKQM4HVmPevX/tD7nEddfGsdN9m5xBTPP
	nKuOddqEDIv+hbpfdrjEsHssntD49MOGBIYBopdZpApOvCqG5fCoK23x6P3qicwcY2S3E14MKuy
	SrPclVDbK5RAGMX93hdhrjuFMwj6o6HZbZw5TWEpBT4INIF5YWbDwAws4fl1uR3+6o9/al9a8vs
	arVWjw28+xaDQPDcVTn6wtZlAr9LwZvvTmWPlBbODJdGgqY1hwIDFWvv9F5nj1rvNowfbWhYxMH
	dX6tkrhUgR8OkLZ2ga0WWFvN+lzTEBljab1aCXF/QB73OauwGWc5GypI0sPIh4pc55H/cl3rBQQ
	/TWW5ovRWi+q9xHj9wonpoU+g0LxJf2KpLw0M4I6ArrLl7a81Zd11+PHudgoW1x45GEQTxi128B
	Nh3AtlfObb3DAvd7jJqdrQ=
X-Received: by 2002:a05:6000:2082:b0:43e:a70d:763d with SMTP id ffacd0b85a97d-43ea70d79a4mr7652684f8f.46.1776230584485;
        Tue, 14 Apr 2026 22:23:04 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3ebaaasm1851925f8f.32.2026.04.14.22.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 22:23:04 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Chenghao Duan <duanchenghao@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH] mm/memfd_luo: report error when restoring a folio fails mid-loop
Date: Wed, 15 Apr 2026 06:23:00 +0100
Message-ID: <20260415052300.362539-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 548F740008
X-Stat-Signature: auk5ugr4zzfoco989jc5b69ciez8prsy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776230586-490087
X-HE-Meta: U2FsdGVkX1+s7bwXxPDwHVHlH59mVpfCVwo1pHhJ882MuMUqbDZd3U7uvx2Gj9kV8cryiFZfF39aoDyll6UONj5B5mkPM8yu2hYzTJs4cmX5RwYUVfwXj6QbkuL9NKdr67G5pWYW718XTd/B9paVOYBXmtWciUkE74Twj8l17scEMhrURHfYKw9ROClr1WfIZkDgMUoRsC0DNV+SoupMDYM84OSaoL/n0hJ9q6jd3YDnr5QA6BUuCVkVadT7XHRz2JoZxalHdBQWXDRvlac6XgCG2gQBxtAa8O14DWuNYWRSmgO0z3navJz4jeAElatROUVqc8fKQVFeME3SzHI+ta3ChOYZnlZOE7yXM1Ir2OrsArZPPiX/mYNSCAZjNDMobI6GqATEfQ+y0kCgty8swwPahOZe58pZliRwllxIVuvMu7sEJxUn/FFEAKLjU+HtWyllujEEaPfKw5axc2XE5D580Bbm4x6REi/54Im9k7nurs1pHIipDD8lR7FhkIWuewXMLSsAjf8GwBR+3ShXyqALfs9CYVxNSOCp5FNZI0hpHPLO60LBOqWCUX0/zgknDIPf8aksl/b67ocOiW3/u0paMOOvBA1zqYkOaTzL17SmBUdPBt9co+mOVl33HlAoevoxWKxL0UQYIqYbBoj338UruNNp6GWhdinicy3zm7H6ITw3u4VIqn7lQetAZLEWXGlKLxS0kUJHhRSS7VI2hZfUC570zFgZTGaaTDNJCjArV4zwSp1C7C5BFH+i5jYLE2PeaVIfj1GC5dNBDviXwnrIse23NOux0tgGg9WnZG4xc3EELT0puTDu0RBUJrvbZl7mYKbeSqOFpAGX8N5l9S+no7SwyTWAsbqiVDokM6tWacK04D0RYzah++ym4XEJ93z7eOtS9wmEJ1pJZ7JfPQMWD6t/ZeMfoQeyGumOvfLgwv7LYmGEaQY//CneP9jRFR9pmgTBP7pW5eejV2C
 F6KAH0YD
 c7VTNeE+9amQukMsusPVVJ4UVGTqfswdZy23Vl7I27U3F+7NgA4PWolebgeS2fJSsC0SXCm7P7z4S/ULt+9oT2IGal3sNnMZ9VePNa6Hsl4OQ1eFGFzVLA56eTTlMcBhuAAmiwFoZczFMKVwJnk+QzEwfrAdDs005FJCUZh+TAE4OgWOaB+0CYUgF2Hii2U805THhzY2ZVorWi2sQMDsyXBP7w69RxhYLaCU2BcjHFirHgrJvX9QLQ2vgAWcnEC5CpvBHyCPu0VcbNl3le089wQptVuXyi3rM/8BFngKkSrBUWggXKpT3Jhql6E6GUjagvbphhHRTdMK4JaA6j38Pg0Me4ppOSh+I3dRiVuEg9GNH2o79YvCRHCDXUXt7N2UQssKsUfAvbeFtV8BvyfTx0hGB9hux/lykb8PPXc0ZEITy/WXlwUHEIzjErJgKp9QSrV9+SjmOfb2EMrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memfd_luo_retrieve_folios() initialises err to -EIO, but the per-iteration
calls to mem_cgroup_charge(), shmem_add_to_page_cache() and
shmem_inode_acct_blocks() reuse and overwrite err.  Once any iteration
completes successfully, err becomes zero.

If a later iteration's kho_restore_folio() returns NULL, the failure path
jumps to put_folios without resetting err, so the function returns 0.
The caller memfd_luo_retrieve() then takes the success path, sets
args->file and reports the restore as successful, leaving userspace with
a partially populated memfd and no indication that anything went wrong.

Set err to -EIO in the kho_restore_folio() failure branch so the error
is propagated to the caller.

Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/memfd_luo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index b02b503c750d..35d1247281e0 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -427,6 +427,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 		if (!folio) {
 			pr_err("Unable to restore folio at physical address: %llx\n",
 			       phys);
+			err = -EIO;
 			goto put_folios;
 		}
 		index = pfolio->index;
-- 
2.53.0


