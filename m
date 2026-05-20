Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 855E0CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1E8C6B0005; Wed, 20 May 2026 16:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6046B0088; Wed, 20 May 2026 16:50:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5286B008A; Wed, 20 May 2026 16:50:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1A36B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5ACCC1C0627
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:35 +0000 (UTC)
X-FDA: 84788991630.15.283A8BA
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E3EAA0009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=XGeFG2dq;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vWEqqBLqiHXKQCYkt4eI7nkTULjtzTI1duVNgJdotDw=;
	b=j7Kvf9loGF9SotvU2QyxoaxIPrLqo/kROdu3O9Wh4StcyEfWPp9VKeXXQUA7f21xOIvUhe
	6EZ1jcyDKgjgI/TxkPE5wGkAymKX1G09Ew8Y6MXXmLWoKP1WuecQbjA1dI7UnJlfny5QLE
	qOptSUjdl73tvnxD1j4zmrGpx9WBkDc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=XGeFG2dq;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310233; a=rsa-sha256;
	cv=none;
	b=1IgnyfkjUtU/MlZAGHwcYz2l1sLr04MtAkigWoec9bMOUwt70L8+uH3Caem0uRgkGVvsPH
	9EPevcFtHvLK6bQ0ohreWWbA4Npp/tAECnk0Q4YshqpV7ESpaUxmkd4GHqa2H6YynkCxav
	7/9am5WWS/dzlfK2e0al+SaQeGXZl5U=
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKO0St1270743
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=vWEqqBLqiHXKQCYkt4eI7nkTUL
	jtzTI1duVNgJdotDw=; b=XGeFG2dqy2N3gbIr20V1uslI7BA0Xd7pIYogyLnBlz
	qkv1ZoJ51iFNeUnZQ28voJfms3i4J/xG9Tvp1XEbqtuozNf5FBh3YiYb6elAwEOO
	+hCbUDddgCRJ/VR3ZMK5N43M8+5idUDk6gx4qOh8gFKwk8POVXOLDeSdcerGQURV
	FE/WTX+yuXoQMuVKi6wNqn11InNK3e2fr2M5xf3AXOmFjJQlgZmue0e4cGHQ2UIU
	5D2xKBrlIa6jswsRFLypsF5wkuPt20fND3ldlwfWHeQy84NvgjOjIpXsQMC9/se+
	N8MYZoxnljImx5MDYxvXHPblaSdThVHR1funfYxh9DXg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e98j6wc7k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:31 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-910469891f6so1330303385a.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:50:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310231; x=1779915031;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWEqqBLqiHXKQCYkt4eI7nkTULjtzTI1duVNgJdotDw=;
        b=DG7pOmCQ0XyvK8stsQmk6Sj8EJwM6DpCv4PxRXsD918WMHTD3VIHgJq04x7dg7ixrO
         Hbbx30wtQPb1xC5SErXM64H5p/cy8e7H7yGddKr8s5uJhW428xv+F8XuERycEYdLLIfJ
         QJ3mR/NoiGgDtI7E/SQ/nYbpUbxU3S+jxYgQVMCGktJjTGWQsBAhWI7RV48SKEidBKts
         wJqlOOQdaFiw6kYggDGGnxrjpmlXOhH1el7aaFXbW4VyVHujc6rsCmXUrJXAg6sQBS6H
         XeeaYBPqAO6iiAq3lAqxlHKM4Q6dKoPpqkrAB500WeT5Z4lh+MIyhzkLFy84ZkrALxH8
         z9dg==
X-Forwarded-Encrypted: i=1; AFNElJ8+l+o/qtJ/m4tCcVrS4kqGGDzIj+k7H2MSVpPUcPvlmC7dKY3IHeh1L8gTJsxmYPc+w+Xj+PgOQg==@kvack.org
X-Gm-Message-State: AOJu0Yw0msoeuN42tF5HVlkWZZvvEYst3pn30tw8lXXw2TSDzrY/ODgg
	0mtv6DbEuMXjxH2RLvUnYTdsJjB8r66wyX1wk/04t9rz0IllhoG1bnpxrMFKNIhEIQCzYANGDUZ
	MueaZtqfkxjDjlLMMf1hSCXSevSDA39YvPMpRhSR4euAj1DNS13Z07Bov
X-Gm-Gg: Acq92OHkr8ahqCZyn+lo2uV68VM8luoQOtxwWSWE963axIzE1xrRAFq9P00G6lbF3e5
	R292fOhnhKtrh7jbdeLyoGYgPOxtcfzn3udVKd2zi224IMAP3e6Aq8gCIEc9TEWwNGWDB3zyHab
	eIwE4ilPAz0YdQw7QclaujS2dUUJpkj4Ap74CKwYyUIaW7MCsZ919sf+I2F5onePq8Mwgmnvbu5
	8pHnFpqTEmn9Fc6F+NfMHr/kDMMzv6RhRyBki0m8hOFNpRm6mbKO/5KY9i2CjxOEAvm/tAM6+Y/
	K+My7PQThnbTx8dNfKCO8c9ouYHnKdNmrHiN2rf6ppGwR44a+BOLcd1eF+RTb+crWrrgBTHCWqA
	GWNiI/NntCxqf/c48gdoIiY0NNdeAlekbZxl+pECbsy7iOQozte1GvS+mh1fn4GEzQYk=
X-Received: by 2002:a05:620a:1994:b0:90f:9cde:9781 with SMTP id af79cd13be357-911cdf4e848mr3838243885a.14.1779310230861;
        Wed, 20 May 2026 13:50:30 -0700 (PDT)
X-Received: by 2002:a05:620a:1994:b0:90f:9cde:9781 with SMTP id af79cd13be357-911cdf4e848mr3838238585a.14.1779310230349;
        Wed, 20 May 2026 13:50:30 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:29 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH RFC 00/11] mm/filemap: split out folio wait and VFS code
Date: Wed, 20 May 2026 16:48:51 -0400
Message-Id: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADMeDmoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDU0ND3bTMnNTcxALd4oKczBJdC3PDJNNkQ4tUS4tkJaCegqLUtMwKsHn
 RSkFuzkqxtbUAjO/UHWQAAAA=
X-Change-ID: 20260511-filemap-split-871b5c18e98c
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=3123;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=0hEAxH6OSygPLgsPWvuM0zul/qd7ww1B3y3E3CXvzOo=;
 b=NI+xM1sj15FzhmwcsYKgafgGq17ATxKLg9pL8kkBXvje15rDxNOFgGPrNNnyq8u4PLDHh0Ztz
 uvcMqRkQw3SDEKwQl4Xi/ayhWnIis5Q4rM7dUmjykLQ6nMy3iE8z/p8
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX1JeDFddlZ9Om
 plGSwZWjNkqBmvVpYgCmy6/a0d83pd5kfKCDxXMqqkEJpndZPXMe4SL45VhZMhx2wx2K7JIQnr8
 N+mSFpO8qVXvspjM8cV9fw7kKPDhiKyFd3LgFS+NhpYoCELp5rDqvQqjb7uL4PwLx0SPGR5gNgh
 MHIzI3+THzCoElSSfmW08BpwzibbrbHl08KRhWdKmeq3R0XEeppvn88uJwbUERKeOgxCSNqNRUZ
 XZKc7NAL59J02lbW8oe8Ke4rNduB0/LsH2MJFsLR+HKa4BqUejxXua7ZTn2VObrNT7Wh+P/3+7w
 kmWEcCNcYc3nNy1/kblelLcMr6kbdHTJqzejxRUaPjSLecXE0WwpVD2nSpwqR+5a7qm9yMQnZ7n
 H4+QzI2QlBZAmaOdSREXg8jiBYmGrav5Qg00nk7vKP7Us72hVqH6MqdKIYn7jcYEenip8/wrSnS
 dCL8MhDxahl4skMSVNA==
X-Authority-Analysis: v=2.4 cv=TsDWQjXh c=1 sm=1 tr=0 ts=6a0e1e97 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=5qPNtsZOevHdRsu6XPgA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: YQYaE3yzXvQNN4PZjj2R7EpfFVt_u-Lm
X-Proofpoint-ORIG-GUID: YQYaE3yzXvQNN4PZjj2R7EpfFVt_u-Lm
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 phishscore=0 lowpriorityscore=10 adultscore=0
 spamscore=0 clxscore=1015 malwarescore=0 priorityscore=1501 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200203
X-Rspamd-Queue-Id: 9E3EAA0009
X-Stat-Signature: kmywzxzng6a374e4w98rfqmajb74kqh5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779310232-186014
X-HE-Meta: U2FsdGVkX1/u2QNckxjax0IpiiUvBZRxzGSth+ZZGWdtDUxWDmfBsgAETWzEPJhlp0udC8Ksj34buOpk0y8dLnlUjOjp1wD2KSvgmnMb0JDEk3zjcWrAXMjAKLAFLYPZUS4oPaSIOJgFKkzyFE1WymWOh9SUEkxZrzA46ESVFoGH7172iq0CkuWOvuFOWo6EyocTSJaphdbpr4kfYgKCKV4xLK4FpsKRzO5GxjJn4apys+FjB1sTMK3S87izaU7frWJQJlQPkgsp0O/bX2hXBxlMI5QfqDgrj9I5FOrpNmh2kBx0JlHTybxmwaUTKGKL2UIdzUJaCB55uIHL9c2AfnmT0Dki+bV05qECK3/en4U9wVKhlNc0uxPFmquT6jyyBmZMbdcwuE+a4dWJhYltMdx35G9PN8E7nBcGDRWy5bsf6N+4WpKGWAdGzfaWcCAb47wlSUfdaQJmXH9B0W93LAwKNRvO1284vwYv2XBYndac+DRNy7rY/RFNIOHaDM95cQSvgdMroYQysjiOO0AzDFhCOK1oVG4SGv8pzH025zAcvardv/KWB5MK56smMBqnU7at/Yzyl77/OSAbfYqMQevh57GuXqH6La2W0FrF1DrHYhOubtXmfvDQLBUkyjeWvWFyHISH3f7m1mQDzBoGwEfz0U3fDezLv/keetU0xV8u4A2iNJy8efuUybeIfeebRwkPKZaNMSx2Nlae5hiJa7mMnoeWT4g+W/DsGLyZW/SdiomSadwq7PV72yLNg59mqO+pMEsdRrAtCOYRUoBZWlzwqN+GxeeCxKzqR4TrD2dW7Qhxj9OLx4Rw9TR9dYePCwLDXL4qO2XRCdyiaB71yxLMn5XquZ7IiSom28YhLWJp3zhtqdhogkrO8VlK0FkotJueioiIsybstjF10Mxs2xe7PnL9d9Gbff0J4NhelzhD+HZmv9f9k36dOGE799qRbRaZTGdt1Y7B3x+VuSm
 5dgjxxGx
 c5gUh/EQ32vKFbkzQ1rBW/fulD78QzBKhlFqidc3+t9f93Conj2FAo3xP1tsDrhjqtBiv7d1WmNWUZpVG4THAEkwVv4F4GvHxGiAeU4VNQoGgFBMjQZv0513VgstbDCa9l9hZ7sIRQKGNvNcS5XWg1J+i1HxoZidVfUBWHBdFJkx7PNX9Em8JvcA1bacJMWeclN/ZjSg8UVyzZ087XxwFxDCOCbowX6QakV30tESWx4ILTSl+t1KPkSrEa5rkv/9WG50sGF4Ta9yN6US9vwsseqB5BD7+NUUgwB1Xr4SnwLokyIU1l0RPFBpPvEViX/0n9aTBU5628/cnCaXE/TgXoPzrpVvkTtNmmHQEwbxWN39LFmEkxUt+c41OgObp3UWT6/am9jjP0KZ2hY4r62GzWKlkbNVidY7BN84V/82P50g+cMGH1NmlKwilQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/filemap.c has accumulated additional infrastructure over the years
that is not directly related to the page cache. It is currently nearly
5000 lines long. This series splits out the folio bit-lock and wait
queue code into separate files, and moves the VFS-level
generic_file_{read,write}_iter() family of files to fs/read_write.c, in
order to provide better separation of concerns. This also slims down
mm/filemap.c by ~1000 lines.

The folio wait infrastructure is centralized in mm/folio_wait.c and
include/linux/folio_wait.h, with functions moved from mm/filemap.c,
mm/page-writeback.c, and include/linux/pagemap.h. Afterwards, the code
is cleaned up a little, with functions and data types renamed to refer
to folios rather than pages.

generic_file_{read,write}_iter() implement the VFS-level read/write path
for filesystems, including support for direct I/O. These functions and
their helpers are moved to fs/read_write.c, along with other VFS-level
read/write functions. dir_pages() is also moved to include/linux/fs.h.
i_blocks_per_folio() is not moved from include/linux/pagemap.h, as it
requires folio_size(), which is not currently available in
include/linux/fs.h.

No functional change is intended.

Note: I have additional cleanups to mm/filemap.c ready to go, foremost
among them centralizing on the filemap_*() naming convention and making
the exposed page cache API clearer and more consistent, but I've split
these patches off from that in order to avoid sending these logically
separate patches to ~60 maintainers.

---
Tal Zussman (11):
      mm: add folio_wake_writeback() helper
      folio_wait: move folio bit-lock and wait implementation to mm/folio_wait.c
      folio_wait: move folio bit-lock and wait declarations to include/linux/folio_wait.h
      folio_wait: move folio_wait_writeback() family to mm/folio_wait.c
      folio_wait: reformat comments and fix alignment
      folio_wait: rename wait_page_* infrastructure to wait_folio_*
      folio_wait: convert VM_BUG_ON_FOLIO() to VM_WARN_ON_ONCE_FOLIO()
      MAINTAINERS: add folio_wait files to MEMORY MANAGEMENT - CORE
      fs: move dir_pages() from <linux/pagemap.h> to <linux/fs.h>
      fs: move generic_file_read_iter() to fs/read_write.c
      fs: move generic_file_write_iter() family to fs/read_write.c

 MAINTAINERS                |   2 +
 fs/read_write.c            | 358 ++++++++++++++++
 include/linux/folio_wait.h | 183 +++++++++
 include/linux/fs.h         |  19 +-
 include/linux/pagemap.h    | 184 +--------
 io_uring/rw.c              |  14 +-
 io_uring/rw.h              |   6 +-
 mm/Makefile                |   2 +-
 mm/filemap.c               | 993 +--------------------------------------------
 mm/folio_wait.c            | 710 ++++++++++++++++++++++++++++++++
 mm/internal.h              |   4 +
 mm/page-writeback.c        |  66 ---
 12 files changed, 1285 insertions(+), 1256 deletions(-)
---
base-commit: e9add7501ad3297dad9b90ce201266830a68ab47
change-id: 20260511-filemap-split-871b5c18e98c

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


