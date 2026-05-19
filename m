Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A963CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 23:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB19B6B0005; Tue, 19 May 2026 19:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40476B0088; Tue, 19 May 2026 19:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03556B008A; Tue, 19 May 2026 19:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A802B6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:05:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4217F1C2309
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:05:10 +0000 (UTC)
X-FDA: 84785701980.29.884DC78
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5DE88A0002
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:05:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l2rRKWff;
	spf=pass (imf15.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779231908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BL0u1dhtcx4RdNvWcLeas7d26YUbe0kObwGLJD5YkoQ=;
	b=4Ee4rDoFhHBwaZzhA9AqhKTSerxjscu9eJdqI7sDCFMZiH0OM/fvwHVT6ZXuzc2Y1gyCHb
	CHGv8GX40CPxPZc68ztLMAzRR+UffllMTlCkHj5ZbliFTxoK44yykAkMsCLiQKCNH90IwU
	6hdG4TLajqtReJOg3KwRO75t+hfYVzc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l2rRKWff;
	spf=pass (imf15.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779231908; a=rsa-sha256;
	cv=none;
	b=fIQZCN5M3r0f5A5CrPVMDuDWrqWVlywu9gzQPr2K8XuzuTiEzj/XX5z4DbFIpnht+O4cE1
	gD06vo4SFKrRHUGnyAe6SitVQd34Lsr+awF2rt32YmYaR28t56ZKA8pXm+tAcD4n2mEnmu
	y+YpQ/i5N9jyBIYViOJSSl4ihUqVAGw=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so49626675e9.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 16:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779231907; x=1779836707; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BL0u1dhtcx4RdNvWcLeas7d26YUbe0kObwGLJD5YkoQ=;
        b=l2rRKWffBKmtMyb6GmE5g5ewidvgoYlAmICHg54O3BYJtxhMmVpv5HMLhgfxcPSJ49
         36kQW7w81exQmT8XYUOHdwK55uDrLJ0gjssLzes2ZVgnuVbihsBcd2pJyb8VroLmQ+i1
         r8dp35QtoX6HFxJpkHLeTTu3v4zsfu8CZTWYf/6bQ/303elRYd10h48xPDI1J4alVcxh
         vKN+dci7ENL7EoJaVdMkJ/v+gwxxlcwXcPgtuve/qpQXi6Bx+vh/1cLIKbVY/gcyT6Qb
         Vz5yXHBJhQHmIvd3tboW+j6Li1CZjKoBEAmWgjwBppAdwjwE6JyooXRgcly2LRQJpE3Z
         GtfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779231907; x=1779836707;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BL0u1dhtcx4RdNvWcLeas7d26YUbe0kObwGLJD5YkoQ=;
        b=npmfOqIvhTJe94NvUNJYZPb8qGo6ponbBoU4Troy0h/GFVOH/dS19VWSuI+viOuRwY
         hdFyDVrszmbNHLmmkda5IPewYQRyF7SCD6pyyZHkNL/pZ7/MJAGw+XV2gYn45sR8NmJK
         Eb/BAw05Y+iqI0nDybzC2Ufx7o/yphM5s7DlsH/Z00wbBjdhni526OBq9wZPaWkOZQCG
         f5D5lGSs5YJmuSOm8n/KYHUoDAXIT5qWGWxpLKrYL04CqQMa9yH9VAvGfa4afUlGlLKe
         TTxbgVYtkWBm71cObruwf3rAi1jWE7baDZ+Vl5W3PtxqOBxk47XREj5JWJcQcbDmTV0Z
         9hFA==
X-Forwarded-Encrypted: i=1; AFNElJ8Y0y0VKw6IS/5s6vZzsB4BObXbZ8XCvRZU5YiyKPa4f0BhYERzoyHW1g1Yib83DHO4zSGo1Dho7w==@kvack.org
X-Gm-Message-State: AOJu0YyyBkpr3MWmzXH6WTNfUR8yG9xylEIGRB78VG10hqxnrAwtTVKf
	UntF9S9/9ixphZ8GA+vrDv/KvdPOMJMrEeBVnrQKvsOZW1cGtn7+fvqk
X-Gm-Gg: Acq92OE9pS5pbgjCpFo//YWfzr2JiCVVGp0dtXO5NfNzeVtgGfZ7bK9B2TqPXgA4qxf
	tdMDtq/300XArdkeO27P6OkbTBbzkp6zfKK6ku9DRblYZnVWYM/fL4pEkKnIIYX4FbJLibuUWCz
	bsPdNOjAvLa0gPpiuSvTU+ijsdUiI0LkHW97VLyvwkll/GDjo3l6xGY3P0KLoZYJ4/ZzICplq30
	Jd0S1Sm+aQ8T+CwZk0rSC1dHc1MLhPGy2VjBqHekHHw41X206nh1DM/0w3CDoYumrwZ/b3hKZd1
	1f9AjkOZaZBWeM67ZWge/RToMBwgK6/iwTRmz8t+eQz7LznHlI6CBxle8dR7FCjfQQUtd0qeUtg
	/IjjwbWHRhj3sNlykC3LEwIe1tCXyDl7AGrBA1bMqxmBNsWwJqq1lD0ouCYk9OOBgRw7CYQvaz/
	F51PbEI73KqDV+3TLUD3Kv5ep1bRv1VOq6yfrTJa4EB+gDUdSNag+baa4ok6PkOU8LeGFa1Tmm7
	R8QE20Ypuc=
X-Received: by 2002:a05:600c:3506:b0:485:40db:d40c with SMTP id 5b1f17b1804b1-48fe60e13d1mr327492765e9.3.1779231906632;
        Tue, 19 May 2026 16:05:06 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe0fecsm45197684f8f.26.2026.05.19.16.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 16:05:05 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: akpm@linux-foundation.org
Cc: muchun.song@linux.dev,
	david@kernel.org,
	almasrymina@google.com,
	osalvador@suse.de,
	yuehaibing@huawei.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v2] mm/hugetlb: restore reservation on error in hugetlb_mfill_atomic_pte() resubmission path
Date: Wed, 20 May 2026 00:05:03 +0100
Message-ID: <20260519230503.121293-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DE88A0002
X-Rspamd-Server: rspam06
X-Stat-Signature: 3uizwt8awsmt7y3kuyf1aucmapwo6z7q
X-HE-Tag: 1779231908-730688
X-HE-Meta: U2FsdGVkX1/s0jxjwC6vZa3564m41hdj+gI1v+lF1Y/LQkuyAG/tX8JIPTeJl26IRIRYSd0mPR/W+rsmWg/LKSnJJgZZUeS2L6nYyElyzb2z/uS5AKeXYRnys9U2K35he8y2+CDepqu5QtUn4Gc/b5eSGMCmPUL0tPpxCydlXR8JFakP3XGfX9+7MfC3fZCu+PYU6ubfAkWtP5pgk8yGDzq3lHBwDeWy6qluzJXQblZ/p1hVmtkwHa6xKYdw9rQlJd7IWlJG5LClXp51c7B3WvM3BByqkOS6c406uJ7P4Xz5wJqcDW2jihTSicP5eMc0fC9iF2ejDcHovn8nzRUovnlSJKW17RoOuC8PaKflJFrESSC6zGrQrRyMRksjjbHR0JnEwhJEthSd6B3StoKmdextItymS91l9/FOxbqRUe1zoe1Hx7vQ6Lyatakpe+h/r3fef4gIo5cRkTs3T81pNN/gWvAgZgjmWLwQI9YJgSiecafuU/YzsvunMNi0YTKLMXrbUnXDg1lZ+E45k30RTLG0An/6Z43PCszBEU9O7RO7MTh1j4xoJ97DyKbTNEWQ6hETz136oX3zBIjDKzeQnJUnSqNWaSDollTwDDzPr+J3Hkt/2pYfc7U4MovJr/zB1tO8H5O67CknXny3F1Qi6FCSnT+N578xf1acYghv6onxV7nN2GXP1riEUM6kr6rumSBwlIhJYWqvqXZQoohBcsM02cVyBQnQEf9iBvFaZZ3crsofF8aVsaH7kBDEMMEw96fXsZDgLQUjE7lf2/s0rBsHEv1/oQtJ3i8zGHB9VcG83CMddzq7AIxNNnRL/IVdfPifjgbmGzqucYJbbTqhMVTeP2yEwBvQuZUYmUlGNMKgRKrbo/TIzcPo2hY/fUDp3sIdBFI6csUrPc6b6L5V8ygHbIrgRkIhnOREG4gbY1Fa/CyQxeVr6wOpG90LEog8VagB17v3MI1qG0PE2Zi
 48psr/v9
 i0V2WJOU6d3td23GxJphAjTCz7Yjuxx5aLQ3lxD7Pm942GSWm1giPj0H+iUCBXltVJOTGdCaHgkyDtAj95eJ3CIGMLmxStwHLQpSe64vYGkfRoPgfb2erIOsKYDmZpzJvPDdlnXGJDS+B89vCLUVcvK09mMa31hcTFh9DbB9zpKkZ4AxWxOpuKXIL56u9rP4ygIE183ZEq6fcd4ISW20l1DU6t28AseHmvHfatyc4MTQ93ItG+tKNuzq9cqsHYowqlmgWjUvpe0AKYBQcr3LuhnPidr9t2jOt9PF5d2jJ017PeDcr63yodEwFweQTVYumh8TWExAc9WLmAl/UOuSdCj9B02Gl1e9njit7v5jNNVck0k7u4zMx9JzZdMIxgWikEp/kvI5dyJZVkBdFXuJco+LYVnB2vYfgNGQHOZVnPyQVcCOosvP0yaF9yK/l5UHszWYzMHMB5QdiRumUAmKXFt/pB+V9RjrUoO7wjqMz8hwcEfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the resubmission path in hugetlb_mfill_atomic_pte() allocates a new
hugetlb folio via alloc_hugetlb_folio(), a VMA reservation is consumed.
If copy_user_large_folio() subsequently fails (e.g. -EHWPOISON when the
source page is hwpoisoned), folio_put() restores the global hugetlb pool
count through free_huge_folio(), but the per-VMA reservation map entry
is left marked consumed.

User-visible effect: on a UFFDIO_COPY into a private hugetlb VMA where
the resubmission path's copy fails, the reservation for that address is
leaked from the VMA's reserve map. A subsequent fault at the same
address takes the no-reservation path, and under hugetlb pool pressure
the task is SIGBUSed at an address it had previously reserved. One map
entry is leaked per occurrence.

Add the missing restore_reserve_on_error() call before folio_put(),
matching the first-attempt error path which already handles this
correctly.

Fixes: 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage copy-on-write faults")
Cc: <stable@vger.kernel.org>
Signed-off-by: David Carlier <devnexen@gmail.com>
---
v2:
  - Add user-visible effects paragraph in changelog (per akpm,
    required for Cc: stable).
  - Correct Fixes: tag to 1cb9dc4b475c (per Muchun) -- the failing
    arm only exists since copy_user_large_folio() became int-returning.

Andrew, please drop the v1 currently queued as 270157aef0d1 in
mm-unstable.

v1: https://lore.kernel.org/all/20260322052120.14021-1-devnexen@gmail.com/

 mm/hugetlb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4b80b167cc9c..c6dee98840db 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6270,6 +6270,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 		folio_put(*foliop);
 		*foliop = NULL;
 		if (ret) {
+			restore_reserve_on_error(h, dst_vma, dst_addr, folio);
 			folio_put(folio);
 			goto out;
 		}
-- 
2.53.0


