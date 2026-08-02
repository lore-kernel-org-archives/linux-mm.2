Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 935C2C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A17B6B007B; Sun,  2 Aug 2026 12:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651FC6B0088; Sun,  2 Aug 2026 12:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A286B008A; Sun,  2 Aug 2026 12:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4096B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:53:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8CBCE1A051C
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:53:35 +0000 (UTC)
X-FDA: 85056925590.17.213EF34
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id A384A1C0006
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:53:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=P+geTUad;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785689613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jdmVuzsAgoF8ZG4dTGff/k/Wwa0EKprHUxiw6VPwyFs=;
	b=y96P4vJ/VReBc09S2ZIECQRgGGFgHU6zm4sVfJPDQ2wZ8q1mJYHAp95Q8pj9K1UBjf9n9k
	8ps+axZhCWtVDenUerHgRUeY3PMFIo2iro2w0QNEzHkk9nkgAff2LDTfEnvrntGN8I1/5A
	KZLQ86txNd8QmLaL35TM2K/LeiNmnhY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785689613;
	b=h8hE6XVzgdIR2po6jUaJN/Dyqrw3nJ+PFO1qrZrJ2Q/S3QS20SMOXe56bbHNXS8v6f7FEF
	nE4ZVf9dbrFtrCzPKRKdYlGm5LqD+GSy/d3RpI/ER/TnNOq0PtQ8jnj2gW4vnfhff6KyYu
	wFyFDUzVWelIaHXCYd90oYt+MAAf7E8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=P+geTUad;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672Gdkw9107316
	for <linux-mm@kvack.org>; Sun, 2 Aug 2026 12:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=jdmVuzsAgoF8ZG4dTGff/k/Wwa
	0EKprHUxiw6VPwyFs=; b=P+geTUadJWXWXd0dA2+8ob4HxWiNc2WyVVpMG4hQSU
	qr95KBa3NoopgGnmbqtW2mmrseQbEcv+epsnSR9qfdWOapIld9M30o+ljxAGRkk/
	bM07HYlA2/D9rzTvymRtLeZV9VgC8sp0r6oPDhCcniV2oBfmbdHyS3VmKOGUizxq
	BzDW4xOpn7j1pJLc4d6yUQNf6FqMCgeBWJEz2d+cikXG3oOvMQLNFAvkrKUD38l5
	myDlDbQ5yLL9a5xEXQGQAaATwAC6dqd1mohF1RHOfEP4kYFKmQRpnjh4WmLrx+tM
	5STlCqtdwifU/iV9N3YP87mbWpUgj5A0+idRquIfzzqQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ft9m1r18c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 02 Aug 2026 12:53:31 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92ea24a2db9so249921485a.0
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 09:53:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785689610; x=1786294410;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jdmVuzsAgoF8ZG4dTGff/k/Wwa0EKprHUxiw6VPwyFs=;
        b=OQ4LFDct8sX003Lgks+8FbT6Komu34WpMK1FoLUp/fr3njBJRhlIkObFZMddFMw4Zw
         z7RTxfDmFSOBf9d27MXeFqwuoKJ2R6q6V5Xo6ItS9BqGd1AqubLSnLR3CAdCqAKScii1
         Yr/WQHEOS/43A+6HBsmvMOiKgaTvjoHoKEMdLjCijwf132R6G+Vqc4wbSPhir8rcIGch
         qiVmpjEixihStU1P/A9I2RFR3UO7HC7E2IUSfMKFOLrb86DkLxI2AHHo6QOD8La5YGiX
         sje0d3E9m9lEahqEIrqofrHP1p06W4Ru6l7s8crzWmQFKIrzinqvMl2VVqcJkLzLQYtV
         0QWQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpo3Yfn1ueTjoPjTqsD7hFpsHibg+1DP5cNvR1LNsq9gPDdMtK2Z51Fs90XCjyN5pa3zGb1X8I2sg==@kvack.org
X-Gm-Message-State: AOJu0Yw4RbiRPWPlDlZPiqAS6BdRjaqal7UpmO7WhmdwQLIsb7EqrBO2
	09TCuA5hR18OpRyfaxhc8ZYeuG6c+DEb82oJWh11tYzHvkzq2xDuK1GMRhXXkhWFMqaHt0ocxM7
	40+YM4BoDk036PRe4DNIP8YFKw2iiAM9RoA1qEFR3b3iK8Ows
X-Gm-Gg: AR+sD10+Fg9Qal+ikjuwSEFTH4PFAZMINqueQgzJwEtRqXe/J6h3r09MYOcKd+kH+CW
	prG/CpKcHy5ZWln03iqCkKrVCmhaVThjLA4vyeSuVmHAJ09ivcYOFcRjtD3xqk3JE4l32JtZI+X
	ahlF/2Qk2O73QxcCDAjhu1klZXCfuHOmeVdsY+7pIheiky1te2LUGL4kds72bGsZGbI8VVwCh+C
	wZHA7/0yFV9cm81ZsJ5EJZWN8oAraka5DcyuBUw04XRvB4b3y4N3OopzA6ufYLiDBD3EXvTId7S
	b5u99UbSUERp1KdYlio55hfnOUiQpKM6PNO79h5UZH8h9GZQ1qCgCqQfmeV8pKMviO6uZGT2FPU
	aTIowkoX7Nf/iEvcBF7CtKJ9cBLicLz/O+PhO8NN4E41sphw7QvI=
X-Received: by 2002:a05:622a:c07:b0:51c:17cd:1fd4 with SMTP id d75a77b69052e-52b56845401mr153860921cf.41.1785689610162;
        Sun, 02 Aug 2026 09:53:30 -0700 (PDT)
X-Received: by 2002:a05:622a:c07:b0:51c:17cd:1fd4 with SMTP id d75a77b69052e-52b56845401mr153860481cf.41.1785689609667;
        Sun, 02 Aug 2026 09:53:29 -0700 (PDT)
Received: from [127.0.1.1] (CBL217-132-158-98.bb.netvision.net.il. [217.132.158.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd45a0c8bsm24064574f8f.34.2026.08.02.09.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 09:53:28 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 0/4] mm, ceph: remove wait_on_page_writeback()
Date: Sun, 02 Aug 2026 12:50:01 -0400
Message-Id: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADl1b2oC/yXMQQrCMBBG4auUWTsQg6TFq4iLJP3VUUzKJLZC6
 d2Nuvzg8VYqUEGhY7eSYpYiOTXsdx3Fm09XsIzNZI11ZjCWFc88gxcvlXPiybdkUakIPj54gIm
 hd248xJ7aY1Jc5P37n85/l1e4I9bvlLbtA85vU1uBAAAA
X-Change-ID: 20260802-remove-wait-on-page-writeback-8e0cb766d4c7
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785689606; l=1390;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=4gWj9P/Tx5A8TCUYXaCRC+u4Ad2C15i9Z4yoGnfAAOA=;
 b=pNASrzhNLQvlvnBF+sfz/L5yPNAba9F0lNWjDHJrGgXdSZk5xP0Zq2QRt9cBu7U85CTudE8Ym
 7MEugh8NiYDB/Q5bk5LCgMuVuLJcddMU/E9la85P5BX0kzWs6U2bS8O
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAyMDE1MyBTYWx0ZWRfX0QeKFma10usA
 1QHTOz3wEhSLA2Eervn4S/CzfaYUbKlSrKgxtIwVX159WMteBDxK0wZT8Y6yxRxQv3X2NQm83pg
 HzHS5HN0fcf4TSqislDlDhiSlNiC8czjbWNSVbiKqsVH4MyxzuVw
X-Proofpoint-ORIG-GUID: nb_axCcsROJefkgXbz_9QxiKDDLIQ4n5
X-Proofpoint-GUID: nb_axCcsROJefkgXbz_9QxiKDDLIQ4n5
X-Authority-Analysis: v=2.4 cv=FdsHAp+6 c=1 sm=1 tr=0 ts=6a6f760b cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=C4zMR0+CEq2lM/mtmjScOA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=VNIlXpW_hWjJ5J6HzMUA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAyMDE1MyBTYWx0ZWRfX5LzfWG5i9V+n
 iy6KLno7RuiXpshyWUPhXpVUDXlMk7kNO99aEzr7LlF3TEL6y1oZk4C99bisYVN+JDtltims/Lo
 5CR+/XP2B9RcS2BeN9NB4C0MPDRplIynXXHZ6vBi04V1c2DKkefF4NZochKiR/HD4td2DxKjB3x
 bPMrwLCXsuSvgAGociyzyW3sHQHnKNSrkV3GhTxt1ifvP3uanvcMGXSALHRl7HSMqgymaZ1g2yi
 jgTVjYSedrAjh0RvzpmC4/b6r5kCQ4k7HaNCbMDjjXg5hQ5p986kxcBmcRWlKknxz78Oocm1yLE
 ckkoc0/b4t8IQazDnoBpI7fVfkrNZukvlVL8uTgenaRK6ZwgXobYNm3EUBzO3Nrfyi7wtzVvyED
 /y2sH0LKKeSygP3jTP3hiGpBDEiupljzKYVNkNsMNu3DNb8GTjABKWLSqeuVvisovOtfL2LFXdI
 2n2vz4aJIozRtrhW0uw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11863
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=10 spamscore=0 adultscore=0 bulkscore=10
 clxscore=1015 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608020153
X-Rspamd-Queue-Id: A384A1C0006
X-Stat-Signature: fejjfchyg7fmbk8w6qo8qcszze5wafio
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785689612-637619
X-HE-Meta: U2FsdGVkX18r0giYKk+jAeQnEqSqZJTNaKXOJvK03LhHOvP2ontyYazK3Q+ZdM4FybUFAYMgbBzWFvVzEkgu4fYgQwhRO34WcT+U091Ow8kDaJOkTGdWdbp5LuQjPBnvbrR/8Z1kX0MfvjYM36yU68nLtINpHLFLGelry49CnOkDFm9219gVryKOoRkHu1FVUTO2FhQGxt7/dSRMqvF8m8kPaLE6tK58mCtbShAROnHmP9pZUxGp4xYDkxNfGfsvxbFAGazFr+er2O7PWTTBmXvMIZ2I3619Gyvt+kl45SxSk26xSai3j8WeZjitLOFRy2ucqCoDSbxU5HsaK8MV7hKDCIkzyzaj+pAJOo5D8RUgQ0P0JO3/D9jTe49K6qWHUN+EP2v8DhdsyfZg/wVK12FV1bkLKFYKC+yx/uTXc2bh+CPGQIXv0uMAKjQwtlc6Yg+nIgn2aSZN9aw0D0h3UgZTU000ji804QgFoJjIRYInuP5t9ByArMDnAHcjqzHxgkEL4wqj6IVwTE5XHsYGSh/4ZCIuVftB8fTqiwPyx+/VwU5gH+1106Sb5V4SX/nDnu/eOQLVgWeeF6DaermJ/DuMGO/hT3934C+aoTXG+B3K3UUwK4QzVbwSNfkB8gatvg/gby7VhDUxS+q9GafrogchLAsjjurbRuLuVsY5FUDRLnm4th0R3RI2A96Q66EGuvTc5+AWT4jnhye4HfOo+JOImDp9oE5NcyclA+pfN0P6rYST8cly3UikXY6UNnw2ao8agvGrkkKX3x641bLPxdONHutDgl6LU9jh7zjOs3J/qqBWh359MI6rgwMAs/wQnZW2P3jZiBPEcwgP0oZyXNoUTpXsStWQ5YRqIltx+8/a4+oMdyfjg7A9xSbDyO/IQC5Jry+mYd5IkTAmInkCRLbeAz9Dak5MRp6rbfeqfrpxtDQydU1uIAbRn2TXzRV5VEO1DHqrYcu2BbSDgjr
 YcSqhmwY
 b4Oe13Myz25p+AI8oFRZCqn4VAU2hx2ysh/tPyOs12nxK/NtnudKCzeqUXiBaOMWTf1emss0Ha2Y+SphoYJLeTUmeo0Y8+kYY7EzjmPW8hq6siE+44wje04alTAzmK+ZdMhEXvz2EWqOgwF90nPPL+ahj/fvchyDKzD/rDEnMN/Z1/jhIbtGX+DFKIfHV1hMXMGpFdYH4lzg5ZtkSZMZaiXLduxV+lmcmmWAB4W9DyNwIoLMzS3TgVkquBTSp0yWidD3EgTNbmYLuoCsOZe4qF/tovzqDqPCoCSHwEZhk1zQPgc9iIxcrJEYgvbn9CAeX/vbfxNkLDEERIogDHbFfJOKoNtsfT5kr+QzcsCvU9UvNa+1y05bVPwzgqhJq4i6ajsgKvmovHCZ4dO6ipb8mVD8/ZKIEiyzl+yBcjsT5F0dycxemvPvLBsQJHPPOIw9vSY0D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

wait_on_page_writeback() is a compatibility wrapper for
folio_wait_writeback() and has a single remaining caller in ceph's
writeback path. Convert that caller to use folios and remove the
wrapper.

Along the way, replace ceph's page_snap_context(), which uses
page->private, with a folio-based ceph_folio_snap_context(), dropping
three &folio->page conversions at its call sites.

No functional change intended.

Note: This is currently based on mm-new. It may conflict slightly with
Zi Yan's series "Remove PG_private by using page/folio->private checks
instead" [1], which should allow simplifying ceph_folio_snap_context()
further.

[1] https://lore.kernel.org/linux-mm/20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com/T/

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
Tal Zussman (4):
      ceph: add ceph_folio_snap_context()
      ceph: convert ceph_wait_until_current_writes_complete() to folios
      mm: remove wait_on_page_writeback()
      ceph: remove page_snap_context()

 fs/ceph/addr.c          | 28 ++++++++++++++--------------
 include/linux/pagemap.h |  1 -
 mm/folio-compat.c       |  6 ------
 3 files changed, 14 insertions(+), 21 deletions(-)
---
base-commit: 1dbd7c34bb92dd9c0b0363b75f6ec444299af108
change-id: 20260802-remove-wait-on-page-writeback-8e0cb766d4c7

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


