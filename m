Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4984CD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 12:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F5956B0092; Sun, 24 May 2026 08:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6996B0095; Sun, 24 May 2026 08:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794B16B0096; Sun, 24 May 2026 08:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64A986B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 08:51:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00FB98F661
	for <linux-mm@kvack.org>; Sun, 24 May 2026 12:51:38 +0000 (UTC)
X-FDA: 84802299918.14.F18F466
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 49398100014
	for <linux-mm@kvack.org>; Sun, 24 May 2026 12:51:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N3V2OGq+;
	spf=pass (imf14.hostedemail.com: domain of mattsva.kernel@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mattsva.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779627097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zaac+q2wcXPmSLkezcHQ4SREpixOUlTlhddu9awVmSo=;
	b=aOuYVaxbyKbS3NanJSocchZ8tmSTWqmCYzmjQcBQ7Cd5BElt4WHh6RYn7Exo677Y/GNWTS
	EyceioLYa2sd9nvjjexmZZjkLurCN9djtnM3DnJyoI9KOKAa/9IpXC+xDgzF9tz2miXsJW
	E8GayS30JBfAf0nDlQ2gI+mwKN/Aak4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N3V2OGq+;
	spf=pass (imf14.hostedemail.com: domain of mattsva.kernel@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mattsva.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779627097; a=rsa-sha256;
	cv=none;
	b=ry7aU8h8Tk3rTxeWi03qNrAQpGKDYjyIe0/mly0XKBuPVQ/fSlZwUB8JGIrTud5OfJrZnG
	w/gUGHEpvOQRgQPY2UVkLKyxb/p+Cwjud1HVORPendwRhceF4sl5e9xas0x2dD+2Jikt4p
	eio7chb/Z2MaZExV2wvqWJKAyMkseUk=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-67da63ae541so2593003a12.0
        for <linux-mm@kvack.org>; Sun, 24 May 2026 05:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779627096; x=1780231896; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zaac+q2wcXPmSLkezcHQ4SREpixOUlTlhddu9awVmSo=;
        b=N3V2OGq+xikGEUPTpzjq0TCNfM96xHd6SACeQWEY6+/MofKkzbxNl1F1IrouedAFyx
         SY90Df+pSL5P1zOuDXZ7mSAj6KngU6FbctkjJLUeuA7UFQtnF2rLl7+mmnuYIJRZbT4v
         /ectIXy+JfN4nQik1pGKdapb602wrqu0+mWMj21RY8aP7LAiWQTcs5xW5oq6MnmAlaTd
         NvOvNIF63KJZwU7A2ZWTkaOjltDiuj3pBptLOdUp6A4RSDvtyi6/PXfhV7+ROee5spr0
         5H9qPaKmmDHLei4gcpTZLk1O6zg3eHWdjsiv2kknEefGPVxucR8wLgo8Ubwb/pbeEqzz
         +bdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779627096; x=1780231896;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zaac+q2wcXPmSLkezcHQ4SREpixOUlTlhddu9awVmSo=;
        b=aYjfy1KJFwdcEEi/6xm9bt1Z18WUvRuQsK9BV/T6OP9iv1xBG9BPSWUopAYSIcosS0
         7ow1c4n1CiBFmHXjn5KYPbIHTVQXdVxCnYv0+zEYE8dgkkeK29pQj1sEUpr2O8tu0ZGB
         62gney3WHJF3H5qnsl/bN985TG4Rz87nEJQMRuUFVTmxmvbcNQKtyHY1F44pLxmIpaxB
         idApvSLUK4FON0elhTzvUky1pXehJ047yWuDshFIwI/+PfCQoWzaEuNXiewvpMw1MXdE
         hXTZLzQmQv8lUaWbFM1g4L6LXTKf13QyEdxPgt5BJZhjb4/AOVVG1sW2e7lS+N+BL3ro
         +KtQ==
X-Gm-Message-State: AOJu0YzRtBIHwbJB4k3lsXmeNp/UeUs9oOhqZhm71hxgMdnqoIvGAiAV
	qEog5r4q70VJH6xZF2lpKVd03u99Aul2QdaQWsL7LJyBzGnGGj826ZMfaey9GzqcLVAJkg==
X-Gm-Gg: Acq92OFALlQoQQQ29KYoRhMxvj4GBKf2VSiVTfTmHHdhhs6M2iMQEpzG1U7uc95eRif
	LlqOJ5lKQ8CSGwZ2SDNr/va1cgFYsiF4sFX+ap1rA8sjVrjuVFSkPQppcALbhyLnvbfay+cz4Bj
	XxQ+JyWxmFY51dqu5iSQ4s01TU4esK0Uru2D8n8Kdd5IPebOOnbFpfXGqm8T2B6Sa2yWbL6x2qI
	bH5ZYSSHASj3884vx6JevQw7dxQSrBIrWlcQA/qm12uMmiyEDMMmtWsCY5Xl/QP6fR65+4pgYAn
	8Kk6ixfzj357bDXHRevCAQNz3Dk6HrOvMHDzTZ/WKa7nXKG/xFbo2ZfjIFY/3WllQuc+R/zxAcE
	9V4gJgUD80FBTvG8QOwB7scc7QYkN0H/D7eNLEvVl07vwNn6Ka1Hq5bfEOooD5ObVkTrGUP1JGR
	4ntIMClKVvXJvCWeYGmV47WDETiHJmfdp3DwCpqlKNZd4/Hi5zaSWPlYd+uYCOOJ8Kxuw=
X-Received: by 2002:a05:6402:370a:b0:680:c843:a1d0 with SMTP id 4fb4d7f45d1cf-6889c432224mr5618565a12.3.1779627095441;
        Sun, 24 May 2026 05:51:35 -0700 (PDT)
Received: from nixos.tail35a60b.ts.net (86-103-11-136.ip.tng.de. [86.103.11.136])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-688b9f6084fsm3042930a12.11.2026.05.24.05.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 05:51:34 -0700 (PDT)
From: mattsva <mattsva.kernel@gmail.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: mattsva <mattsva.kernel@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	damon@lists.linux.dev (open list:DAMON),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] docs/mm: fix spelling mistakes in memory management docs
Date: Sun, 24 May 2026 14:49:21 +0200
Message-ID: <20260524124924.405071-1-mattsva.kernel@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 49398100014
X-Stat-Signature: 4hzi3zjcywta35736iik5cf78ap8g9ux
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779627097-99511
X-HE-Meta: U2FsdGVkX199JsMfHp4Ci1fN+AGPm2tG7zRKtZSpaJhv/Z9e+/07IMJ/a2S2STDeNTf4m3JzL4eezuLXv1otDFmWs9VtbAXAsVbZ2u0aqBzOwonLn10CRjXF0eR6hl41aDkrOQtOiHSkO8Xc5iZjb1Cv7QRXhig/0uAkBJmR7dIAqWnPSHEWxKHD8x8WrnksoUoiIRcvxwBbc2ivtnfRFFgp8jHYD6oBuxjZizeURfyULvSGYFJG2hUbQCkn/cSoPdD1ZBuNbY+1SgRD5eQpJ50K4zFl8q61bsbfZj6JkGVUDprR9tnAJqeKYqZIqMO+g0QluOaF2Wjmx1NlWea1/HEcYfkKtkW3NHwk38xBAToki1qDa3qB2vNpntKG6Y62bMhxGthpUXWsz6R+1d11+as5rCsYr0ap7VX1CaXFIUvPm49prPq72o6Dq77YvcXMLOADzKJrGBqjU6HiXEojml3f4sxC3ns19HFlielf66/WAkAtn0I5eCtk9ZLkaO9J3n3bh1B1mPTPP9aZxeO3Kov8OoDSFMAf/sRm4DpNc2DaCH0r8Bs4veWYuUtr5gpadnJ+H6FrMjmUbvhQlWyBUsPik5seLe3HTHooPczg5DK+P7pgiREwlVVR8lGgQWjslzK+/uDHlq4NZ2iXI0pde/fDiJozKnAdok6/h6Bpm1YIDtNcdghBNmB1JK8/LSGBmVyAfSE+Wxqh+j5oGeM+8StOkEIYkfN3F+f0jzB3zC+KwIGLQnfgYwot+M3P8beO347Vo+nqubK/byoKPsgwYfkRepfdb/iGYJXcAROhma39IyKdwpcKN6c78aQzBS5zKNRckWE64p70GAbjWwB9kvB8TsuoqGCB0uoiBbMpH+do1qFbb4YyQqI2+Q9ty2KbuJBQxFdy8EoFu+PN7ovJlC57Wygkv9ESlmEXDxD0YUlbVdzl3FG+xSRY0w8cd89WEtnR9lvEgo3dv8dc2Dw
 nhx+m5fO
 hC6v7uvFG7fd/cXnojkcYic/RWd63zapFO1JJv362pDtBO2DpJpqxEbn8yYAeR9SskV/UXUmezFRUjQWUyOIPult1KaScUmVH4Ua+uZntoUjbAr5Gt3xx8vWRB1ea47onf2UH8jOIcSgZxSRJAC96OkEIHrjUExaiSWVcl1Z3kWSkMYeCG3ju7+XOUy0qlRsDnWe0nSlz1ngTC1VDOO6SyLbbYpCLbsOabsFZcWFySsG+pWqWqGgT6LUP8FDp4GpYAgXfUyntw5/AzTKsXmaW3swkL34OMNY81SJaFoDcKsAT616Px9zDBjxT+YAjtwsARz1NGGaUTk6l6uN+vEULhO8PPLuhUq8fd3E4QLzTJhify/rfWVLEobhv7sfRkVw/+xVkOjDz3Tz5s/5cxqrooicFS/zEJyFcrjINGmwCtrwRETYcgn7277LgsCTD9BikHOJVMNdJqcF8fnRej8shpbr4/W7uSkMg5a2PlZc8zqhuZ/SATZiJjvrkD9D2GD9WFjuPyJpngUzuXOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: mattsva <mattsva.kernel@gmail.com>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 2 +-
 Documentation/admin-guide/mm/damon/reclaim.rst  | 2 +-
 Documentation/admin-guide/mm/transhuge.rst      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 14cc6b2db897..25e2f042a383 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -75,7 +75,7 @@ Make DAMON_LRU_SORT reads the input parameters again, except ``enabled``.
 
 Input parameters that updated while DAMON_LRU_SORT is running are not applied
 by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT reads values
-of parametrs except ``enabled`` again.  Once the re-reading is done, this
+of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index d7a0225b4950..01a34c215b66 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -67,7 +67,7 @@ Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
 
 Input parameters that updated while DAMON_RECLAIM is running are not applied
 by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
-of parametrs except ``enabled`` again.  Once the re-reading is done, this
+of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 5fbc3d89bb07..5d08a2a1c15f 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -210,7 +210,7 @@ PMD-mappable transparent hugepage::
 	cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size
 
 All THPs at fault and collapse time will be added to _deferred_list,
-and will therefore be split under memory presure if they are considered
+and will therefore be split under memory pressure if they are considered
 "underused". A THP is underused if the number of zero-filled pages in
 the THP is above max_ptes_none (see below). It is possible to disable
 this behaviour by writing 0 to shrink_underused, and enable it by writing
-- 
2.54.0


