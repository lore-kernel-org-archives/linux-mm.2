Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61BE6C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8178D6B00D5; Tue,  4 Aug 2026 14:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8AC6B00D7; Tue,  4 Aug 2026 14:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691436B00D8; Tue,  4 Aug 2026 14:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD906B00D5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:52:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6AD3C02B4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:28 +0000 (UTC)
X-FDA: 85064482776.08.7BE8AFD
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id F1BC740011
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UowxIcw3;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785869546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7YfZUeIFW9TVPjgB6SoqKQpgS0HUMDYLvGLEC86SVCw=;
	b=sZy7rKumhxHBIZy/MrklYrorMJoWoOo4sqzqBdpS/pvQr3hg/yAqvC1ohxRNvswLOPtd2a
	yBg38BSyHeJZxvqaZUjCROmrNDnNC0K4OSSTI6FR8iYO0G5EJcdcvtSyj+1Y7aTKXCrtV1
	axNvlQj4jn1GtsXbaDsidzbqT/CPGEE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785869546;
	b=mfdWNQrMeT0GB2vgziMZHkM3IDjtFjxb9LXXHyknFOeTB1vf3R0jH+s5etBLT/iI5s3sRD
	xJWnlhhk7OlM3GPd/ve+7ufYP1hF/QQgXzx1nheUsnlxQ6S1BWBm7cH8+6YZGqZzj79/WV
	8FGHdlZvdbseZX6R4zvDIBEuf3lUORI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UowxIcw3;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674IYDNI2126308
	for <linux-mm@kvack.org>; Tue, 4 Aug 2026 14:52:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=7YfZUeIFW9TVPjgB6SoqKQpgS0
	HUMDYLvGLEC86SVCw=; b=UowxIcw3t3wlAFDlemaKlByrLPdlI2o72gL5wLyZGT
	3X+Plr2b9u0eN0d8sTL1eMoYEv3VOcAZriW+ZfL0uXbvwZobyV0CxBiillFFSlkF
	NKa7df5UgoioU5Jf3R6TXVK/fP5jURHOjiQuR2OL5l9MAnZYdO0ButMqwbYCadVg
	iNjDOR1V8U1JI3KwMVi3BFe7VLfiIzrXFRlKezajPClhIoISeYk8tTtsJGP1DqVI
	oEiL8Pq0LHbS1tGVSjS7MOtrQapJr37nUM97XJRHVq0x8GV/6GW6tG32UIf2k7JJ
	nSW0yHhQ2U9exk3fU+lP7jmykSyJ3jE3kRrNz8aIQLDw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fuj0et13f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:52:24 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c1d137a68so1643941cf.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869544; x=1786474344;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7YfZUeIFW9TVPjgB6SoqKQpgS0HUMDYLvGLEC86SVCw=;
        b=lSRzqn03jZpeCZv33+HgJKtGsmSsLawgmhxq+0wIGD962shC7RHvhd6nz8goIkgTIs
         yR1iSGgZ4YEHVCULECwVPDrC5t2eeYonzHvvWPmyOT8iNdkO6MMHiZy4C7NMUGHiMbM9
         +dOXIxs9csbibBE/tIhtADX1a/tOCZGcvEiV8kSaxA2/zOC5TGhUoGzjHNxKfv3BJU8a
         RiaPnsbAwAYxrKaCjrOtDRGa/14I1wKpBNpKlTfc77ElbgwLO/JqrGCGEh7myqP4RwCz
         gm0GNKTTRMoPJ0GUDWYlhpQURoYc5MUvfHNjSVOF7ZsqsLB/U1VGIfKoTpzqoFRqo/eA
         +MSA==
X-Forwarded-Encrypted: i=1; AHgh+RoHVSNPJPxE8PVM0XQpgyNEWAx3yFkTSy8y84UqwVLHQM3HDhIaOQadkTcxxoDC7TkGKO96Xak3pQ==@kvack.org
X-Gm-Message-State: AOJu0YxNYhAgjrgUApX4cCN62CaOH6Xvukc+uQrxBVmi0IG+oU/Pk24B
	QiUk+UOxQTtmwOdXFVNilq5w//t+JE+O2G4qeRoG7dpw0jOYkzcgzZlInGCgBIxI8QRmTnfKrHV
	O2wpDR6vTqLsRVjFRY3TxXtIf1/bfJ2pjZlOff34Acou+nLLKY7Y9XBiT
X-Gm-Gg: AR+sD10B4gRdPWMRC/I6wKeTnqh6IRC5WrjqwO8firw0UpVHIPvgng4XgI/+TJl3ZCv
	0nD0adf6YxGN8ybOxsIY4UCD3GKMJpiTDmJIZ2joj1Gjh6Qmftotp7QHaCYvCjsotHpo9Y/cIgx
	ctL6+ojHvDDPR1AT3QhiWJ3MksJA1Q2en4lgBSgb+Vn4jtZu1eHMRZUrU9JibjpAatl0xBbjUtc
	lOpOkF/RePUszp8oVYSNrUg3hzXLxCxYx6cIG6orrh1GzpTnqoPrYGZZLRrIjcj68I9crY1maQw
	4kiQ/MhfPa5CHGXnK/ot60pcJHcC/RnkOpJ0AgJw23+0SipchveNVNg5O0MzAnAx9ZMvc4NwQNu
	xxpCfkco/
X-Received: by 2002:a05:622a:2487:b0:517:a7ff:935f with SMTP id d75a77b69052e-52ce5fa471emr14549131cf.9.1785869544305;
        Tue, 04 Aug 2026 11:52:24 -0700 (PDT)
X-Received: by 2002:a05:622a:2487:b0:517:a7ff:935f with SMTP id d75a77b69052e-52ce5fa471emr14548641cf.9.1785869543831;
        Tue, 04 Aug 2026 11:52:23 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d7fsm2313275f8f.20.2026.08.04.11.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:52:22 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v2 00/10] ceph: convert writeback path to folios
Date: Tue, 04 Aug 2026 14:52:08 -0400
Message-Id: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANg0cmoC/42OSw6CMBRFt2I69plStBBH7sMw6OcpT4WSthQNY
 e8W3IDDk5yce2cW0BMGdt7NzGOiQK7PIPY7ZlrV3xHIZmaCC8lrLsBj5xLCpCiC62FQWZk8RdT
 KPKFGbnQlpT2aiuXG4PFG761/bX4cRv1AE9foarQUovOf7UAqVu/frVQAB2nKk5W6VLaUF+NeY
 6dJHdCOrFmW5QvsOSvR3wAAAA==
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785869541; l=2554;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=zWM2+49jEMwBQwNik+CFCtiOiR0VjtZ6SxoPtniyer0=;
 b=fEDv7IHpkI8eMWnAST4q4BAmT9PhWrien1UJlpvi3iP8NJEIOvrTfVJt2EbDPSyKLSLZeHGWS
 jpYM3a1TgRsCm5MC1re6zBif6kyMG+VfIUTLjNCYLi3vuoSxRq6czKk
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=ePIjSnp1 c=1 sm=1 tr=0 ts=6a7234e8 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=j1J1DEHOHTVaJYOjuVnKiw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=CvbYRxD_FV8rGtwQpYYA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX3h3DK0LJ23D4
 +wivMQVyZmqBfXgQ4e1NtXjyWqprpt2Sdz8irU/sO+d0o42xNa3lAWufiyXrMm4dscv64ocrpqB
 2Eg8hEXJu1uLDf6Ve6ESuQLfrx+vIVffk6iYWd8W4TVWxAK1RwOu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX6MLo6w425Q/7
 Nrd/ALZTcFfrLzoJ+rU2P3aUd8j2QA/X4hCSXXyNsF/jlJc/zTBjRCD8hchcx6+8kqmfSjbitF9
 mJrXoAzOOI7ZnexSHNpkDBD9xch3lk05/GF6ss1UsWUdnlPCZEsXh60/2E7Zsmqxz7PKIl9Q30l
 DK0oIQ9MkEKj/k7il0KwVClSv1eFOSPLDhXs0dyb/r9qu20x/q3eS4AgxvMl0D9L8tfpRSPCJVp
 jNq3fNVvYoEmnk5AhAU9eG0LEATHiRygmOOKAawBB07w7DTUxLoeKa/RoivzEyGTl4jKtffyhMG
 MtAzeBfxy4Dfxx4UgzOlwHJ3Sq+MO614H6OM9BzGrUGA1dkFWLv6KOwT1jmMqj6Y5d3nXI+PL+U
 V1ZY6WQJmxENi5WoEI+HnCIdDIIPnYqRwhjNtivobNgB+TrQE486Nig3l0x/rG9xT6O/1hHVg/M
 R2E25KyfI1GZynh9KJg==
X-Proofpoint-GUID: hVq8huta63UZjGCLaVj7e_CBv7mIWEKV
X-Proofpoint-ORIG-GUID: hVq8huta63UZjGCLaVj7e_CBv7mIWEKV
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11865
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 adultscore=0 spamscore=0 priorityscore=1501
 impostorscore=10 lowpriorityscore=10 bulkscore=10 suspectscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040152
X-Rspamd-Queue-Id: F1BC740011
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 4w3w48faoqsby8e685te4j6pufhug4z1
X-HE-Tag: 1785869545-772691
X-HE-Meta: U2FsdGVkX18FR/WAsnzVWiaBFLr0m8I6hLEnCKXLkSDhBgJxTPyJo8pGX9t/8bV1C0Ns6ZeA2mYyz9EjVsIRjTh6DM52/85JuSKX6VjVve3CUzJuyNK4kGDmo61+llgXF70TqRw6ym7ox7kCAWJTO1GmOT5qtU+MMtuyVW695vKJC9c7Ee91tiuNnXd2ghds3POGncoEHOKmMCOAu44VacyytnOgzX+dXpMApDV0zfnLDgCdTHSIy3K88lNq3EH4o+t/USndoe8leEaKFY8lvYfhSAIOIcG8KdE0s81ktqfZZBVgzve8lMS3zwpAFXmPdhET92BLkr0qh3QMrTkrYi1VxqUsdcTjT5pbArM5bD7pCr+gLc3TRLb+CujmBZgI1FN745yC89Po+Dr0PsZcrABrm21C4KoaW4zGtWGE7b1eXnMzWq3YjPTLWP8xJrs6T/Pme+onz2Q7vM5SlFjzyUNImvjPKl/qgg1Z0tj9NSOkgVu+JruaAWjSxgQtyGX+MTWkQfmAQiunpmfODaZRGaB+s1CZhRI+RO3LU4mLPfod1aJC5MrNuPMx/9u8Pj3HokVlVYV47wxSeYCgq2vJMgWO5guZZzlQsJY3bTnee7l2WM6HNx2qeiciSqlfkkyCmLFg5agKIjI7Rq3ub7bigtAfAZgy6FXyfpgffsCIaUW11TWszrIMP73tw8iRMG4ZXonnapx8bkPIKwhXpBhd56QhwPo4+m6j3XbWIlyyamgZgv/83DownKrtWKWl5QJgMyvIt/3skLqzdMCOVIPukFU/xnRfw8Zw1QL6C66S1xASWezx8khuL8fUJd/bCZL9XgKH9IdfbnUt6XFquhDqSDFB33ntE4uGFmrgUhpYAhZU5xKXvipj5llbBbgKa5O+gS090Nqo+f4aKgJQhwKncX9Q5Nm6poEL02yOU9pNMUE1qjJrTXcAyqU924BZoXpngnmZilvXJlb9BcgTDOE
 WSfeNidh
 aeVcNoXG/yV0jgL2BNmQbUzxOPZmLL9fJfh1K34PbcV/PPYnvKxqNieuBa6LRjA/B+2j+wvIcR0jH27zl2+E3MNPg35ovmkV4exq24a39n9mV9zG2XB1Bro6PRArhRQ6B49TnonJYLiHFsGyYFw2p4gUkkpTx4NkR8A7lqELE3KEtK4bDC3qvduqAE6ZKqheEJAvNPH+0ojydjHSmWLM7iHF20RM9AbrPRZyFbUU6i0oiEkVCRp4iswjiVHOeautEjFBs5JAE+CFH5yxolQ0kEqPM8C7pO/L2UQihIV6ndmh5/AbvE5HTKszNjx97X2pLZ4VUVeMmzoNYHpvYc4pk8gqy/jLFyOCYJftfXvX/3s5qh2wnZ71JEgTc0EArsOgOC5EBG7yIxsp2ZQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert ceph's writeback path to work on folios. With these
conversions, remove three mm compatibility APIs whose last callers are
eliminated: wait_on_page_writeback(), thp_size(), and thp_order().

Some page <-> folio boundaries are deliberately left in place where
ceph borders on some gnarlier page-based APIs:

- libceph's OSD data plane is page-array based, so ceph_writeback_ctl's
  pages[] and osd_data->pages[] remain struct page arrays. Folios are
  converted at the array/libceph boundary.

- fscrypt's bounce page API remains page-based for some functions
  (fscrypt_encrypt_pagecache_blocks(), fscrypt_finalize_bounce_page()).
  Possibly-bounce array entries are unwrapped to their pagecache folios
  via fscrypt_pagecache_folio().

This series is based on the ceph-client testing branch [1].

[1] https://github.com/ceph/ceph-client/tree/testing

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
Changes in v2:
- Propagate tags (thanks David and Matthew!)
- Rebase onto ceph-client.git testing
- Rename the series to "ceph: convert writeback path to folios"
- Patch 1: Drop the folio_test_private() check in
  ceph_folio_snap_context(), per Matthew and Zi.
- Patch 4: Introduce ceph_fscrypt folio helpers and use them in
  get_writepages_data_length(), per Matthew.
- Patches 5-10: new
- Link to v1: https://lore.kernel.org/r/20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu

---
Tal Zussman (10):
      ceph: add ceph_folio_snap_context()
      ceph: convert ceph_wait_until_current_writes_complete() to folios
      mm: remove wait_on_page_writeback()
      ceph: convert get_writepages_data_length() to folios
      ceph: convert ceph_submit_write() to folios
      mm: remove thp_size() and thp_order()
      ceph: remove page remnants from write_folio_nounlock()
      ceph: convert page cleanup loop in writepages_finish() to folios
      ceph: remove ceph_fscrypt_pagecache_page() and ceph_fscrypt_page_offset()
      ceph: rename ceph_check_page_before_write() to ceph_check_folio_before_write()

 fs/ceph/addr.c          | 120 ++++++++++++++++++++++++------------------------
 fs/ceph/crypto.h        |  12 ++---
 include/linux/mm.h      |  21 ---------
 include/linux/pagemap.h |   1 -
 mm/folio-compat.c       |   6 ---
 5 files changed, 65 insertions(+), 95 deletions(-)
---
base-commit: 30c0913a2b44a66dc17283a88489b3f3e12f4327
change-id: 20260802-remove-wait-on-page-writeback-8e0cb766d4c7

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


