Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63EE6C5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE496B0093; Mon, 10 Aug 2026 10:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695A86B0095; Mon, 10 Aug 2026 10:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 583E96B0096; Mon, 10 Aug 2026 10:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 266986B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FC69140178
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:05 +0000 (UTC)
X-FDA: 85085571690.05.6D396B2
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id D9491140011
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=PFXqVoxS;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5w6GJ667Z7vMoCNVVHReYDBKGn+cpEFhQPr1lMRr49E=;
	b=FowHKzGVV4K5Eb/emHpfWXN9BDe3bvx80Sq4sm+tYMZRAl9O1VpbqpZyy9EB4uj4YEN4iS
	Eo8SZe185EfRgfND7f7lPjJttILIfg+XDGIfXIi3TgxyddURxZQ/UFcvoiUyYzHrnO+pcI
	CCfujaZRqSCMABSksFSbUWowitxD7Oo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371663;
	b=AsIMLDcBZsRDIw9ydpvQADPf8ZlPNvMF2zbfWOreRBwOMRfAI13rD9vIJiCAvtelmtcTdk
	6e8BRLaEcbSsNhgKbBRJRFi55BaPoQ/S+tsVBFM+/JL1Tay5OInlDSQ9NuDOjqZcCo8q4N
	UkXK2rpVTFXOaW8Rq/8fcF0fFBwdmOc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=PFXqVoxS;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACaBcL3194266
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=5w6GJ667Z7vMoCNVVHReYDBKGn
	+cpEFhQPr1lMRr49E=; b=PFXqVoxS+NOl9bmIXYL3YIp2hY8Bjy5yDN2e7AC1jg
	r8i/Wj8J/qOLiN3StNd39ijLtyyDukVv86U1RplHd0TW1M+Zdkpz3NZd1wdYoYkg
	Ab0T5odyxBIPPPo+Gfp+hLqeRvvWluGZWKSPdlPZXBcQq1lhU4mNQ8Skv0YLMWKq
	xv1X20KCU3KM1J+K4iQSCU+iQ2ONlTN0HOk3Enq72FkrqHY5TDKl6oLbiumAkksX
	L/RQJI0R/QrkRzOljF5COvH/SOPTetdOovvi6sXTiPD3EjXFxisKgOB9h/hY3qcX
	+ntMji3V/MA33Ackbre4+AGuO1C2gylF+J6nzgVXobMA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fy29132ag-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:00 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c1d7886cdso37999291cf.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:21:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371659; x=1786976459;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5w6GJ667Z7vMoCNVVHReYDBKGn+cpEFhQPr1lMRr49E=;
        b=VFA7AS7R8TbmpBVW1JJbeVgdmGgV95gk26WJo8GUPU2trKd/1ASBsu/aXK/MbCA7sq
         SpsEtXPDNPxRWdPe7r9aPvv0Olti+kdcikLaVqT+XphX8IAbV3uJTux/mJso4YEmPeIW
         11Y9MU8sgzM33+SYMoRAAzxCoZbu+KkVmL2sveLcy3aN3mIXGjhCOUkmi6ZKmxesPYyj
         5suL97MfGWgCB3axwS+xDiHMKRwCSmTYbGSPdN1wmjKV75BZrXiomNi0wk/x9bfPjqoi
         ED53iOZTeu7Y2/KOnxoqfeGJnKz3IdgqNIHd6YhPPGugjtajpHR6Vsur+TuTNwqvT8+/
         g2Kg==
X-Forwarded-Encrypted: i=1; AHgh+RrLW6IbRSdhc7ifJ1NsHKhtyU4FE3ZQX9kDFRUcSc0Chp7oAwsRGt29v74szBCJR/ETA4BklT6c6g==@kvack.org
X-Gm-Message-State: AOJu0YwAakRs+xDZ7bK7rgyksEGNfsavja7zfDMLRkndBXRjAJJLCwEE
	SnVvig3e8mPeMk66RKTXBtGWpRYDzV2zIS9/LDMkW9oFKfxKYhtilbvg9B3wDQnC9TPgk+OnyzH
	vKF8KdgGj0l0nfI8DVKVmaBSLv5oPNd8AnnRWgayKKYaLz0AA
X-Gm-Gg: AR+sD13padq0oZdotAz/XTWCMLNXBmZSLDFh5qlBnMYAk6qmCejkxUJmYEloVIRjlW/
	EBW8vEQrgZ1k7XncUKuV0/Hb6TGvnVg4q3hXcCHaIxfIDVuE1SF6L004cNvbYJBLVD0vS94E1eZ
	UEzBlHYnrtX8x0Lhflwp1DiPPyGGGvwmrStpiNJ2D3c3ALIl/CN0bFzo1BUrOOkYWkzI9DVUlTE
	4HIiY2Eac1lT3McXZN7AckxD/1WFI92DCy0CLp9NjxR+X6kB1uDx0bVjsdvxR3nsScOpA9OqdDz
	xyJTy/ffMHw4BnJQXbkOq6KgRYH2C/M4dtWwhaLBoXJ3LWfb1pmKMUQmEVXw60i/tPA1ag60BIi
	QZML6HPfk
X-Received: by 2002:a05:622a:292:b0:51b:f98f:ea5e with SMTP id d75a77b69052e-52d4bc69834mr23278581cf.22.1786371659552;
        Mon, 10 Aug 2026 07:20:59 -0700 (PDT)
X-Received: by 2002:a05:622a:292:b0:51b:f98f:ea5e with SMTP id d75a77b69052e-52d4bc69834mr23277461cf.22.1786371658878;
        Mon, 10 Aug 2026 07:20:58 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145589sm37383983f8f.1.2026.08.10.07.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:20:57 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v3 00/12] ceph: convert writeback path to folios
Date: Mon, 10 Aug 2026 10:20:11 -0400
Message-Id: <20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABveeWoC/43OTQ6CMBQE4KuQrq0pBQpx5T2Mi/485KlQ0kLRE
 O5uwY1xo8tJJt/MTDw4BE8OyUwcBPRouxiyXUJ0I7sLUDQxE864YBXj1EFrA9BJ4kBtR3sZK5P
 DAZTUN1oB06oUwuS6JNHoHdT42PzT+Z39qK6ghxVdGw36wbrndiCka+/frZBSRoXOCiNUJk0mj
 trex1ah3IMZyToX+CeY/wJ5BKu0ZlIxUfAq/wKXZXkB6bzJcjABAAA=
X-Change-ID: 20260802-remove-wait-on-page-writeback-8e0cb766d4c7
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786371655; l=3170;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ACXOp9y+JHYQJ0ReTJpnKp8/uZY8YUAMptYnBA8kvCo=;
 b=8yxS8/k/8Cj60JPuVMLbUBeRarDFhQ1QH80zzwBEKGFXjioIAwlZi8hiDozO/ZJoisfXCPyN8
 7RI3oF8PRwxDA1BkhE/62IJtccGWJ7YxQstqvtfv0K4kxK4IRrerTaI
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: lCC6A76QA1BtNrDzfmhlut3I4_bH5YR4
X-Authority-Analysis: v=2.4 cv=aMTAb79m c=1 sm=1 tr=0 ts=6a79de4c cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=zHmcO6jMd5r4EZ4U0P0LQg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=K5e0w50Y35hYhEYsqgEA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: lCC6A76QA1BtNrDzfmhlut3I4_bH5YR4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX5VmAhNwrUnXt
 xNp0B/WCJyfFihXIN3/ywZZ8NEEo1U6DhXtfn7nz1LLpuyUzdwFZufMAhPhfP790gQ+/OdhWFtU
 4YzRpdX2VDpj/4WjYxBWdQQ7EgRa0gbcRqeBdfsHDpvy2qjR8dUYC9bZ1Av+S3gkr3K4Y65jJ4K
 e/Ootcj59hHtHZPl0udN5aQTT25xH/oyyVkatTmI2/n98/yJ5LDyekNTe/wIrLvJscF8dW9MsD1
 tBFLpV2Kvnt2qtO9Zdpibayhum6qWWP0ozuRnA7ZI0gaQoLkXYmSFBNQk1p9BZzWOCq7LdyLhu8
 8cmQOW3CrsODeD0qBOy1vKIIAQmdJajSsb6tcxT2e03Jdgw6fU9ZHEgq+Dps6AIU/7dlsalrqFO
 EPKQ/zMSrqviGMeAkE05javIoJm5Gq1nPLyZKPIRSVL2sI8g+7UhbLtBSc7pz9evdNA4TByfcUg
 vyM6wTvL+8uqf/LfPUg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX264FAcxPZMON
 9anaUkBdrlhd4KRty05JdoOdoZB5CxqE5Xw1Ymc2kFstX1L5mUC3NCNBNzJgTNQ+tTG5CsZZhI7
 R2jiUfxiyOra1LMUfhA7oQBZLFfsKao38MUCBxnXToG4m/xo2sx5
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 spamscore=0 priorityscore=1501 bulkscore=10
 adultscore=0 phishscore=0 lowpriorityscore=10 suspectscore=0 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100123
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: zhtuwgun5ntq9abec8y69cr4hp4hxk1y
X-Rspamd-Queue-Id: D9491140011
X-HE-Tag: 1786371662-964092
X-HE-Meta: U2FsdGVkX18jDHIE2nGeAo6jteKzVQEZ0qJh+6ns77qkw9mSKCRx+N/JRkvrt9zCwCQA1vVaObuDrDKDogO7BD0llK/WUVsSr0X/0ZesaaInC33/Es3x9RL870DKScNJ94vhv5B7MtYKo/YWtXTQ61FNoWztF5cJwggm16FuwFJTLZpljCpKCE+7+XUK8gtFJfgvRP2Qan7UdmLeBkTQReYWOfaEO3u1urRhpN5QO4utk/jQtMdNjy+A+cqjcFcVILxiabVDvqIl1FgvMgQ9YnFdUxsoYT33AvQcLhAJL7gzUWi1oiorS25Ubh+GjlbQenWjdC78EUXcodddXBFvkrPBW245czORVM//WRjypWIdxvBho94YlM1rsm//sp0ouloZ72yfk9LPfxDemL2+3KvvWxgpZWYOZhfWe9aBwWQYdmmsOGCENk2EODbbddmSQ/PxCriNGV34Onh+D0eBvmaF1teN6OR6GWtk91WN0Km4sImoRSTWQctZ4WiYWoXcS6GJEoc1F8p2tbYRvkLetlVRocFXwwRYFiTuXaSruTNFq5+XONe2d1k8cEvi5Mr5ZWa0zYiJUnWRPutZJSV84HF0jc217qeUjJ1eyn72FBHEc9MALE8H1JJ3YFOPli8VMmONaPEBqtUv7b9KN4jUPMHLvbHpOZhykTJ6EIFr9jFIv9yevmHNAlwuxHAxsdLor3yV7bZOFcnPSAjKAw+CEmjGbHu6mVEFK0arJDVW5UxzkUCVjtsSl2tNS5+0fXgGlveYe4mELMWS5RwF4WOMph8JfmB9VQecpLUdsKdw3hKyiBrsDRI51HQdSLFgvz3E1T20MvVD3RLRCyAd/x6EaD0DbSJFprWtuxUUhIX7MF+/WWPS5IZCPzRUwvtEx8JxoCHilwwKl46r6quQ8qDJ5tdCEwo4xb+dsIfm9RJ3XqQlPGp5XzHYXu6/SIBBpwXnt+DMbX3QJSPwlD+lpgK
 etOLu0j5
 OiFffzo0iQJ8wFA9jdc67W3eod/O/qTthXOsXsEsggyryRW+DSr50+r4tY8nCd6vf+w2JgjzRI76LmvVZ5WLG2lSacJjdBq7qq7tTTabdchC7FopxuPfDDvIXCjwc1avqCRWisYEO6P1DGs2/hefAqEx4CpnmvsyVSjDO5B+YhsmGIT4a2C8V+hZIdmv6TOAD0iJR/WLnxYVOF11jyGCeWNtqfGgc6hwPUPESUym5gjom/fuyHayGoGflP/CorGhvFys0kBv6qJ6B08qou57Ss3TWDFB3Y19q0XTJMTMc7ktZNQcHKuTwSrjcaLXKnTOXmePEma4/GP1iPT4NWoZBYDdnml6ctiiCG1Ss1GSO/NhscUoOCyh8NAVVy26ShtuQbJCNoBGkqlZLIq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert ceph's writeback path to work on folios. With these
conversions, remove three mm compatibility APIs whose last callers are
eliminated: wait_on_page_writeback(), thp_size(), and thp_order().

This also fixes a couple pre-existing issues discovered by Sashiko
along the way.

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
Changes in v3:
- Add patches 1 and 2, fixing a couple pre-existing bugs found by Sashiko
- Patch 7 (was patch 5): Rework the ceph_submit_write() error path
  conversion on top of patch 1
- Patch 10 (was patch 8): Remove the BUG_ON(), per Sashiko and Matthew
- Link to v2: https://lore.kernel.org/r/20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu

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
Tal Zussman (12):
      ceph: fix error handling when the OSD client is stopping in ceph_submit_write()
      ceph: wait for pending fscache write in write_folio_nounlock()
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

 fs/ceph/addr.c          | 154 ++++++++++++++++++++++++++----------------------
 fs/ceph/crypto.h        |  12 ++--
 include/linux/mm.h      |  21 -------
 include/linux/pagemap.h |   1 -
 mm/folio-compat.c       |   6 --
 5 files changed, 90 insertions(+), 104 deletions(-)
---
base-commit: 30c0913a2b44a66dc17283a88489b3f3e12f4327
change-id: 20260802-remove-wait-on-page-writeback-8e0cb766d4c7

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


