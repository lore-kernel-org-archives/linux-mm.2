Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA53FF494B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 07:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604466B0092; Mon, 30 Mar 2026 03:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E12F6B0095; Mon, 30 Mar 2026 03:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517FD6B0096; Mon, 30 Mar 2026 03:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 43F996B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:12:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAE1214056A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:12:39 +0000 (UTC)
X-FDA: 84601861638.13.E375A3B
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id F2C0140012
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:12:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q5a+UU7R;
	spf=pass (imf11.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774854758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3Kvy/oAbDLA+l15BCHFb8YavWVhfw8+2oSg1bGG605I=;
	b=ZQdX87ek5rRlFW9zJda3SrimV9gtlYWYrYgVYGZq8WJmL8gIIXVK8Zdhh+CzUXfELB0TWS
	OSe20z+3XXje2y414bSYb54buSQCIFQ4dI9UGMwvg/ov1pJyjmRIAK7+RGVHwHgfmhUty8
	4k/mm1kEdQXQFJlo5fVIQWpGPDvRiJE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q5a+UU7R;
	spf=pass (imf11.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774854758; a=rsa-sha256;
	cv=none;
	b=vX+k5lP6r0e367l+vF2eFhiOvVIq23DqHOmqfL8fL7hpQj9XHFm0OXDQlWKfD4n/kxrSiN
	8nXdJh1UHcxF7K3BGvjYYZvj2p8KLPyK4tNKV+6WGF921oHqzDfswt3lJQIfXasu4fg8xb
	gis3qYFDF31HQg6Om+vfbb2L4oGumv4=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43cfd96354aso393986f8f.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774854756; x=1775459556; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3Kvy/oAbDLA+l15BCHFb8YavWVhfw8+2oSg1bGG605I=;
        b=q5a+UU7RO13A/tnpQEGxzThDL5t7+kQvMWrlJRoh016LK0ZWHW3iVb2KvEC58TA9UO
         cWD6Yq41vyg+tTh7GR5m+XqtEA+s0ONtkK9lCKNd0DDg0OX0I5Da5KVxGqcFkC+KMvZq
         hPag4Pz7dqYbugKecpRPdbDeTbs0whFAJ1uHPYSMWv0nb0ACsjrlJoV9CcFWjKwDF7i3
         Ks7dplOXQ3/G9iICUtSVaTTvcbQB2TU3u6zGLK55njD0WRH64ZIeSBmBzS8XFhRtNP1k
         CD6/Lzbez2bVTTwLPpxqmHDyJKb8YjirzsBx5PH5djtglisob5T57mn4dYwon/Z8Ekoj
         pRNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774854756; x=1775459556;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Kvy/oAbDLA+l15BCHFb8YavWVhfw8+2oSg1bGG605I=;
        b=r5wNW5Iz0ZEU5airZYnIBGW3pkqf6dcB5+/1+GNHCoDEAj8dvH02vjBVbCXGlk/MNI
         Gc1CBEY38s+hyTiJ9X4YugXQ6yO90oek3moAgxb9vIhWthWibaQiGWVPtyEV/W5w14CT
         mk2+e/4DtEE2JfTYDv4UeIboTcaLkzJv4WlWri09FkYYFBlpA77onSnHOvPr1r0p3vSr
         wG4qAyVoQ8gVZUXn1ehmNNEdqnS1ktXhtLqycmCKEnBs+El4zPAl+OvdGt2s07a4hauf
         TKWkqxbynq3rcB+2zLZT5IpGBFtBpkTMD1uwVAVK+87ax084logR1OLL7TSXmQGZ6ko+
         mW/w==
X-Forwarded-Encrypted: i=1; AJvYcCUGAS0oToWyjm0Udjx8u0r2RifLwhmqyDTmF+/5/FcgIlCKn/4emdB0wIh8tNH/FX6yJk6pvNWXeg==@kvack.org
X-Gm-Message-State: AOJu0YyVIrAB8Mjqu3h6toagB9plYQRenPyLnzDz3/xGanvqvisf1nmL
	AHaRff7imENyPL/vxZLDpUyi+hJVUPKi2gkn2nyrr9z4bS30JjLGirpe
X-Gm-Gg: ATEYQzw5hCAL7lu+/SEmSh4kBYWBjqndjQURDVopkCoEGdwqUkb5O/ahSK1LZ7XzkFd
	r4gLnNy9uznIv4IJir/cPzlw7svMjS1Le/nYEa2YXunDNM+8ufbUq65inArc4wDYrndLrN0/Lhd
	5vbNlVwYV/RA+uDw+/BUf38W6KNADdD8W+PubyGe4B7cZ90HBIV6wGIzj72MFSTYzpl/YUeHJ9w
	U0LtjOGrY8xPsemd5UPZkxuX6cHnLFs1ipdQgNU4duDCrRLXoNpPjo9gWMmoPROKto1k1mdt8oF
	ohaURHwyoXwOZS9V3V91mfsjGA1vm3+DjYIOex9MThVYwvdQpAA21l8H0BWqtAEOLElubhZk5bj
	CCiimZDrBp5qEAwzXucSNjSS58jSBtFErTECctABAv+TklmH6j8hVfPkXJqM8IRZrJoiBjhjhIp
	I0DLzy/J6b0JXhP2RUdVuVt3sEGux6AjcIwQGXr1hLkKxkdoaHQtqXD0gpDZeii9RokcZdsSbDT
	rEj7/EoDt5s
X-Received: by 2002:a05:6000:3105:b0:43b:43ae:8c2e with SMTP id ffacd0b85a97d-43b9ea779d6mr16500509f8f.51.1774854755953;
        Mon, 30 Mar 2026 00:12:35 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf90424fcsm11516290f8f.32.2026.03.30.00.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 00:12:35 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	NeilBrown <neil@brown.name>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v2] mm/page_io: fix PSWPIN undercount for large folios in sio_read_complete()
Date: Mon, 30 Mar 2026 08:12:29 +0100
Message-ID: <20260330071229.14614-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hxyq5gkror5a4pr1hwe7gomc9emsz1w6
X-Rspamd-Queue-Id: F2C0140012
X-Rspamd-Server: rspam09
X-HE-Tag: 1774854757-329808
X-HE-Meta: U2FsdGVkX18qQxh15f1ITIBJI3uhScgXGjrmrSM1eNR1pNDjALazqxmrrZ+fb6CEFwqy2R3H0VMO4Yzu7z9APzV+6Picf2XWKcxkk6cKd4ZG5OaCqDdjwRXw3U7sbO470JOn96ci9gTrIyaz8ZcZ+6EQ0tc7PfrHlcsD7sVedeY3wNuvWggPY0hq/a4+auiOXHE52ZIu5kB2M4jQtlJP/OshzGFu9X4/ffSdPK6e2alhOmzI0hr3igtv/mXHf1Kk34vtRGex9Je54daKFIZ5BiUlQx74FTNmKNO1W9kZQXuCxq+Y29PciqI0EE2rEa6V8uguPh6zq4Ev4fzX/mxGbykY6UlERiQ1XEq0Z86ZvvXN70hFnWt4KEBZ5KV9H+GidIGq/RWgVgjzhQStg44fwiGNsIavkvyDrkVm+57+dz8ynaOiMG0F6xxpv6SGdnsK+SCz9GS2+cgti4X7EOiKofa8DVprpFkLMFMSrFZSMPLkzBXPJ5FSimlOFq8/c7HvOn1S3IgxPHk6E0dvE1ABql2kTeVE0w+EJKByF52aCsYJG2hhX9tAmOXCpdyKs0ahivGZeC6gGWJ4DM7NPCe8L5qQjegfLzpKgi9zJfRenNmPb3P/1R/fbf/MHXP39OHH+WGQCMUkonP39sP9+zFpy/rsPzwIW/fE6/qOHn38DcRZvGq87hUyVUfX7QSgor54PMq8ecpNFLHHaSjDNC9TpEOPtiizIFOGt5p5zUj6Hco+cOAnLYu2dfhZ15bNSb5dvUNfCagnMRA5e4kvhqAlY1hOv7SH8W5CYsMMyBFB67ixP5uI+JeysMuOjB0MoMLeo1nK6HBIk2RhnGO+tXiAsDmKfa9iARtwLjLjuue44Jt8xGGUoJb2M/fKPI+5WzSI+RJPZrt2L0lk6lOQ4NAoXhU+LTJaKiCcufljisFDVi/ZCZMNiR/Dijdua10c2v36LePgro+NyFJDS40Hni9
 PwxkFh6s
 QsCCehrnfHxwzKlZmocyQrhJWH7UXc6pKjXUhZCiU13z80F9A8W/yab8MUTEmwoR2Zy5hNjz/GWFGpVws12s+n6liAbXB2IwQynZpgiXKx9eSgP3vk+MOBrCmP1iTtznod9/ftlCnFB8t3I3KyzuqzaO5T8RAciWY11fQUdWJg1dUcBlkiL6VX3aKZvV9veYapeSNslt5Abj6eGSjL7f8ubkNgsxXvNZVCIZ4eBz7/5oVkAT/LU3cFMgd1tCDI1VZsovCaV83kYcb30DbUX45IF/V8FnY64bGPo29OdxkdWzKXALG4fVYIOnFYAkHWx5zXptE8hYGNH4jg620aex6nlpqPwUfRj6XOgWGK06yt+n1slcyXtpQMDbhMImE/+6TVM5QY2hMTNlXzT7msAFOxSS9cglRAR/tRf06W+BPefX3rid0D88SHnicd9p66YtqGBPbd6wCMWiRx/w3asg0EeHXZ3x+ogFlyu52Vn72r14ZhvSqXu1bxJQa3Y/Dst74Vix+5WiDiUFvQf6wbmZgRJmMV8an6lvPKtjXzpY7/hwmsPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sio_read_complete() uses sio->pages to account global PSWPIN vm events,
but sio->pages tracks the number of bvec entries (folios), not base
pages. For large folios this undercounts compared to the per-memcg path
which correctly uses folio_nr_pages(), and compared to the bdev read
paths which also use folio_nr_pages().

Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
count since sio->len is accumulated via folio_size(folio).

Fixes: a1a0dfd56f97 ("mm: handle THP in swap_*page_fs()")
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/page_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 63b262f4c5a9..1389cd57ca88 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -497,7 +497,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
 			folio_mark_uptodate(folio);
 			folio_unlock(folio);
 		}
-		count_vm_events(PSWPIN, sio->pages);
+		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
 	} else {
 		for (p = 0; p < sio->pages; p++) {
 			struct folio *folio = page_folio(sio->bvec[p].bv_page);
-- 
2.53.0


