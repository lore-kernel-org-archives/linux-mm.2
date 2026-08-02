Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14029C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B6246B0095; Sun,  2 Aug 2026 12:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540176B0096; Sun,  2 Aug 2026 12:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7066B0098; Sun,  2 Aug 2026 12:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0032E6B0095
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:53:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85F0012049E
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:53:43 +0000 (UTC)
X-FDA: 85056925926.19.F0487A3
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id C9C53180003
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:53:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ZiAxOXOQ;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785689621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXtHcoi8cVlKLUHZRCUmBtHXjzieXyTC4IDYVelJs2g=;
	b=ZXewa9mMIa4vr9VhfBZj5VZKzmiczUhezIMW/C63bm5i7uxuLFDXNLOG8YjJaFaGc28OCr
	HYVzaIVuZq2XT46i4aMJFfie3sBuFyVg2vFGwh8VGeJx2aT2gq43EDi6oe/uXo316DVtO2
	AvzTP3Vufk7I9yyZWkFyXleT8Uj5MWQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785689621;
	b=B0ute0Wipxr1jRZHzn16fGF22kx5mMA8jLfrcYK2KD+gGUjRM4q6kf2GgO5OdbBfHZi5TT
	Vw18wJlMCbcaz1rXjPobceqxjGpR8bW0hn5oY2A5fr0QAmYVSPPdann4qUIAW/TN4jgWhq
	2ONgPJsyQqvjgIjIjkAX5a9l6EEFN2c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ZiAxOXOQ;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672CYquF3407930
	for <linux-mm@kvack.org>; Sun, 2 Aug 2026 12:53:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=iXtH
	coi8cVlKLUHZRCUmBtHXjzieXyTC4IDYVelJs2g=; b=ZiAxOXOQ3C5l4e5uF4z6
	qf860eJMZ+uFHA/DGWEFHgkHs06bLW/WI9JvjPDgwqRmtv3akXM8M2t4dQ0d4sHZ
	LDwA9H8xKpBXfBZmHgdurZDBdVO9mZRSvjz14TBpcaPL7oUD/ZZ/Ha3YqSSCzk85
	HROLuAGoTH2MFGWls7o5GW6zZJossm0QmOkRvZxBjaQGrsgapg5dob+RAWPYjVKe
	I/DwPmS6nU2zRow2146FpSc0ywFMFlHtA1b+ZY8K3BzHzV+CVxDmUKbeipqony73
	tf33GiAkxC9ykvzGHcm/wbWM2UVmeXDSYhDgm5U9y9+QURrkhIJ0xuFI0v/nr32f
	rg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fsdrgneqe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 02 Aug 2026 12:53:39 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c1d7886cdso51983571cf.1
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 09:53:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785689618; x=1786294418;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iXtHcoi8cVlKLUHZRCUmBtHXjzieXyTC4IDYVelJs2g=;
        b=mYKGkl66eEapHUy+sY/LNkDm2UPQzqSTHQ9l7iGow/5omGzjLq/6IIj1wVbQrDthrm
         hkT4D7iXjTmrTCzpcJkQYTIhLNf2Orkt0T9vyZ1rjbrbWGiHhzdjc4OAoEKKAdXh5wFZ
         teEC0Hd+7OfUS2sSFPbjXCLa4u8hW4whqohIEN4WwU/32s5k2sxp2dvlMSgpjsY8GYMe
         LeZHgnSmtOmGz3xtrkcfczvJcV3zfLSKRxycxcVa70/VdgTTWLVs28Y+k0TH131KQJ/S
         cyzSxqFhX9Yldhl6IoNvNk8Xxs/cxJqNwAIJo9IMsCzDJfd+s/Uk3/+IvqGbOO2m9p7y
         Ci2Q==
X-Forwarded-Encrypted: i=1; AHgh+RpMAAaxqHtLwYnluBWoQuJRrA8UFahP9bOiKaYBTd3BknhzqsxOFQuqEMceYZtqmWdSr14tWNDlHA==@kvack.org
X-Gm-Message-State: AOJu0YwMzNqO8w62U6/1C7NDA8b5xkcCtLLyilPxhy95gQqtAm18RKOr
	ahj3E0/A0dPPVo3f1qYIM0xZSXjotyC4GUHh8srTQCtyoVbM2G/DyDUwb/AA5N+ZyHlwGjTV3Wy
	cclK/US8CqamomA2hdQrqFAy9a5DimnBchALkaAg6gkSUvto9
X-Gm-Gg: AR+sD11zShrt5tl5rY5MYoVhF/+zrnQVsfuAK6NVoUDRxkq4Pz41UnS9ttgMB6lUX/R
	KTodKItLP864AN23NUvpB9QCK0Oq4Mn2BOZUyg+vY97SSEsfrKDH7vNZAABTb5QE6fKl+nYULOS
	1qao0AomHXA5pt+i3Rj3muL6fss1PtmFR4kJ43OheIiPm5SwzK4KnKmEI6QwAdfvzMms/Qi2y7d
	luxvWr3yepZjbdd9w/QJVMf7rjrUzSLC2cTMyZtN9fZ67yZqdyC60GL9UAuqBVteZrDoL0QHvs2
	j07TVvu141v3qiAs8/KbE8RbyyJNpyQWKR4ULt38LDpOuH1/KX+728B+aVdZP+3mSjEX/7ThK9e
	VNzCs9eKRefCULwtzI/7zLX5a+g2nKnomviZi7l6vGhGHhMV7K6A=
X-Received: by 2002:a05:622b:89:10b0:52b:6543:d8a with SMTP id d75a77b69052e-52b654316e8mr58751401cf.26.1785689618609;
        Sun, 02 Aug 2026 09:53:38 -0700 (PDT)
X-Received: by 2002:a05:622b:89:10b0:52b:6543:d8a with SMTP id d75a77b69052e-52b654316e8mr58751081cf.26.1785689618191;
        Sun, 02 Aug 2026 09:53:38 -0700 (PDT)
Received: from [127.0.1.1] (CBL217-132-158-98.bb.netvision.net.il. [217.132.158.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd45a0c8bsm24064574f8f.34.2026.08.02.09.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 09:53:37 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 02 Aug 2026 12:50:04 -0400
Subject: [PATCH 3/4] mm: remove wait_on_page_writeback()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260802-remove-wait-on-page-writeback-v1-3-6c35d6b3ad36@columbia.edu>
References: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
In-Reply-To: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785689606; l=1337;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=2VkgDhoLJZc2rtRUaEo1H+FE+H647yEoceZpR1wCk5A=;
 b=7I8Fp8rUC2g3MzaZ+Eu5F/2t4vVqj+514clw9LyKXp/jE+0VmFnNxeE1hGpUOS8CgVyOCh1FG
 mTjLIEvkVwqBiGVtq5g14hyqpkS2MRwjm6LTEH52tIQWJPW6dN55Ram
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: iSuW8kP07RXga7LJaONNNiNM_sv3DtUm
X-Authority-Analysis: v=2.4 cv=WMxPmHsR c=1 sm=1 tr=0 ts=6a6f7613 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=C4zMR0+CEq2lM/mtmjScOA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=mRZAEA7ckj0XMcVDBXoA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAyMDE1MyBTYWx0ZWRfXzMu4+8xffYIe
 tRgLR9SST0PIN0iPvsSuI0YsNhqaqlzSZGIYiRPPBLkebYGcT1urgpNDJBkrfLg5Go8SofQzW5V
 iy/nSU42wba1ne7zgIL/KlbRhEW5o9Tvyo14Cos9ckTeEZOPIktkGAKnW17HKspmkfy0daKfT/8
 76MCd/zvRdPYYp5KeReTo5RhV0NbiSzQdXfjhsc6OplM6Xoq6uaI4g05ed/pfUR1ZSJ/VB+cTAt
 /wEPNg8653vdL/8fkeBCnKsFOqKMAeyiDgGX/7HbAGQ019a/cazrVKXqPwiez0Ns1x56A3FFaCp
 mra1I2x487QsL+wWL6tZT4hGMYsmunLfYwUemuWY/QaP0WIHTI74Q5BmtAiyJJ8oebuHtoSKOaL
 eeK6bWcYExZ+IBHNTV/Fj9UMdvH1Upv9XVUQ9CID4kipP8dzOaz3OqpxebxoxpVlzRPrDk1bYn6
 gmIS5KkR526ON63lx1g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAyMDE1MyBTYWx0ZWRfX/EsnekF5VCpy
 5U5lSFD+/34PSs4WJB9YXm+RQ5F8xUlUti6sMRP3jU9pd6mLN9gFviGn04Wp7xhCOpOpMKR+QkO
 2CAMeCF++pbhd4DGo9ajF2BFq4kNll4XeZ8EWZdDAzSmrKZrARqS
X-Proofpoint-ORIG-GUID: iSuW8kP07RXga7LJaONNNiNM_sv3DtUm
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11863
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 impostorscore=10 malwarescore=0 adultscore=0
 lowpriorityscore=10 clxscore=1015 bulkscore=10 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608020153
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C9C53180003
X-Stat-Signature: 7x8duff4136qayt7urhz6iwk8k6gxm47
X-HE-Tag: 1785689620-680338
X-HE-Meta: U2FsdGVkX19kjyM0crdwBB1Nuo10Sib2a/xAihdUh7kEkYAyB5ANc4RMHzup1/DY1ze47YZGMUiAWG4KLvnrfI6ZirSVhITpLWtq4TMMqRVQ33Kfku/iWn7GEe86zbJNVAx/k+CwYt0yQVOvv7DNVL53WJvWy9wPVAsMH+/S0ufY53m0un40bL9VYoeaDoOJz65oflOGUjGmjtgauMAfC2vbYGbMFoOBrhclux4jcLiL1Muocji2H/JtEUI/FqhtbRFtu1mk9d3DaUkGW6LJ6USE18/TCIf6qkqHTfWMQTcOyXqv1zOeBTcXOu2DGzmJ56tLTbCu+F+/1srY6c1RcOkklCxKC7NKHA38OwNZInCawy6thvwtaLrEgWZ7g0M1snFGI5mbG+hYKrzDhSYGL+pGY4ERb2TqjrBsioxFsF8PH0eu8g8cqbfYNeuxq/hQlZL0dBa9DelLtRXI2eZkJtMc9h2QaJ0xDnqogP0aBIbIJ9R7I24elOCeAP1q55VBefSwd6bnabv2FTdAq3KkhkI646/iVUH5CfLdyjj/EZtuImDHrUMj73ld7akRO1HXYCf/fTcxEBngFZu+jHmedGMnO71iZLuIAsAPtDh6FgrlzGhvBB5jYx/oGOccQbhHRvZzit11ELFk13yJyQWvgiu396d4PVT5pPvyj4SUX9I/XLoBl9thZOnPEE4eehqrUVxkZwY9mWBpnGjaHy4KKfcyFYRMCD37fqdB1giQuW3YsXD1g6mx/18hB4DrM1HzUJxHsNFsdNDAUtitQsNanVA3S3NsYKavCwS3fZ3XiJWUymQ0mjCbqU4nZfMroVzifWUkxIEB+mcM7mJpf/y8YBwuzQxd5FpFSCetFYljk10ubM8m47mvJZIcsRwEtT/pwHkpk43GVeFggVBKZIZ63KVSYKzbeoociFqCD//gWxIl4bGnFEDBrdMmN+uonKy0qmLQz2rKzd+MRmgGiTX
 O7dbXfAl
 KoEJdep2y1eUdfTjDaxZLLtfbroxRMDeN2StA7qPrNgcQf2Djbr26z5xaEpxnl4lb1+b78Pgm+L25dUElSzeAr7UizjoYpLEWO3TICrfnzWm36B4S30o0e8vtsws1F8tmo3GnNu0SU98BSLampfFjg6UNbG9iO/N9bkidGbugK/y/6VtHDJ6gZ9cs6vhBQ9ybDjXkkLpIirE39g7WSFm4YFYLTHjQhMAVDCxkuOOsoYjt/cJNNbwH0vxgWDvuNQSip3cDIZnj24gkK16MaHSbD8msn/TeE49VdsPXW2muzgQy41j1x52Lri4llp0GVGGnN8C2nfk0tcF+3E84Zpxq9eLncm/CMeDkQcmngaqdGs/6eoHt0FLZYAfT/PAeZt5GG6pie1dz9eSZi+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last caller was converted to folio_wait_writeback(), so drop the
wait_on_page_writeback() compatibility wrapper and its declaration.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/pagemap.h | 1 -
 mm/folio-compat.c       | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 4e8b2b29f6d3..c8666fd14d3d 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1335,7 +1335,6 @@ static inline int folio_wait_locked_killable(struct folio *folio)
 }
 
 void folio_end_read(struct folio *folio, bool success);
-void wait_on_page_writeback(struct page *page);
 void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
 void end_page_writeback(struct page *page);
diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index a02179a0bded..ae0271591d37 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -23,12 +23,6 @@ void end_page_writeback(struct page *page)
 }
 EXPORT_SYMBOL(end_page_writeback);
 
-void wait_on_page_writeback(struct page *page)
-{
-	return folio_wait_writeback(page_folio(page));
-}
-EXPORT_SYMBOL_GPL(wait_on_page_writeback);
-
 void mark_page_accessed(struct page *page)
 {
 	folio_mark_accessed(page_folio(page));

-- 
2.39.5


