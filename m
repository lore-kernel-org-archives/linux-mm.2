Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D3BCD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2126B0088; Wed, 17 Jun 2026 13:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71126B008C; Wed, 17 Jun 2026 13:26:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86F06B0092; Wed, 17 Jun 2026 13:26:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0E6C6B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:26:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B35C1403F2
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:05 +0000 (UTC)
X-FDA: 84890082690.28.2026682
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 48376120002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DXsuAiRq;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781717163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WSC/S/1eh03bECJM3bYZpz5IHDiPQT1yEFjxIIMxjqs=;
	b=xEoeA2JAcVtgCltfODYo3Aa/aXhh5DcZzEMoAnJgo1cAdEcs01CNVWtandraywzENmRpUC
	WF7ndXCGjH6uD8UXmQKPrdgnH7noeo+A3cBNJ2yyAjsbHWJWWcfhgHy2rtL+ZpAXuIrlHo
	D0Ue3Pb6K1R18oNApCHmQbgiXlwuxQg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DXsuAiRq;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781717163;
	b=W75n9aOTqX8mxkByrffXA1jKFWgm0fuEem/r2Q1ZGQHBh+h6/NtY8/3w4Hhdt9qcK1XVNg
	522Y84hV/hrdkbQ0564jgVOSAiC0lUOo6Wy3h24+hxtYPJNmk3XL1jbxiQHREpW6nE0NSj
	dbycTWNic/c42ZJobSDq1qd5qzyIP/s=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HErd3H2382316;
	Wed, 17 Jun 2026 17:25:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=WSC/S/1eh03bECJM3bYZpz5IHDiPQ
	T1yEFjxIIMxjqs=; b=DXsuAiRq0liddmwivN7pcDHYwuQu5v5gU5BGoJW95pvbw
	KVyGaO4T1BDL84X2ehQ30o3Sy70pd4y6T48/kogBJwmxdGhFLv1qULGANxzufKgx
	A+77IYbpZ04VLlrhU2Z/tjJjYyPx6ajwT5/dDKJk9MOnYFi02QwtNWrg///TMOov
	WAsp5sz6TBxI9GP9bpD5wG7nUf9MQPaRzJ3VRlYUJ6/ZIRobZR9IEo6vV8iLBaoi
	NTIzYHEAb9sXwRpxfQVrkMso/3ppkAFw7HqA28qaawTzoZkefcqZ7wAwCQ7mBu6c
	KKThHZlIKjxs7XB1adZMNg4H4NTc/WKCeICjU8uVA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4euege1c1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 17:25:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65HHNVOi003778;
	Wed, 17 Jun 2026 17:25:43 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4eudvc0wgy-1;
	Wed, 17 Jun 2026 17:25:43 +0000 (GMT)
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk,
        brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
        david@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
        linmiaohe@huawei.com, nao.horiguchi@gmail.com, lorenzo@kernel.org,
        rppt@kernel.org, peterx@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 00/11] hugetlb: Use PAGE granularity index in exported i/f and adopt the common read_iter 
Date: Wed, 17 Jun 2026 11:25:21 -0600
Message-ID: <20260617172534.1740152-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 phishscore=0 bulkscore=0 mlxlogscore=655 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606150000 definitions=main-2606170167
X-Proofpoint-ORIG-GUID: 7GPwT-0Ew2andlyZJYf8MJINAhbPzD_Q
X-Authority-Analysis: v=2.4 cv=d7jFDxjE c=1 sm=1 tr=0 ts=6a32d898 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=9UlV6ym-Jy44mWKTLegA:9 a=1CNFftbPRP8L7MoqJWF3:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Proofpoint-GUID: 7GPwT-0Ew2andlyZJYf8MJINAhbPzD_Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE2NyBTYWx0ZWRfX/8AzIDRH1q8H
 sJRSnAZbxXI7cHA5FW0E+MoZ5QZV/+biwdnJKrHVNK5Wvzu/zqJnjS08mX2WHwp/zBsVGGQUt1S
 etmWAZeFxVZtMGYWzcZ8UFplWyiQgkqkHfWOrIOg5FfrgIudQ27aBIgCXboKAot2AToWx1GSkUW
 FMHEPQtw4f/nUeYmMWRzKIxSeNk1GGyajfUuPoeYK7sD7MYjHvCDa1TLjeu4pvHeouWv8m4INzZ
 hAuDsWgfhwo6To2d2QKAtHnEragFg/rFERxf6CyJJWrDZnZBeOlEQa2heSK6kc45fcJSB3EWMDr
 o88GXlJiMOXDnbrfhNDwRT+IF0JKvvOUYtFHAty9m/mOwBs+UQY5khP2Apas2eHGghuv78KNy+x
 y+E5O2wG7Z8n12OfTvp6k3yTm3jWx2SbYKrBL4ezXhUPGCj35hroPEh2v+W151dWRxkqJQtpxpF
 6LrAOOZ2eKAf8kiBRWsVL5N6yRtPHmpVaqjVlb/E=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE2NyBTYWx0ZWRfXwBL8ZJ1g2Uyn
 /DGqmdYV3qiIiHbBCXHylPg8GG+cO6GKUl7moKVd8YL/eYvlMYh0qmj6g1dikFwgzhyQzApRV5B
 k8fVJIfKh560KadelgZgJEwS9sJjQnjYEKCCggWGatwNwOkL99eu
X-Rspamd-Queue-Id: 48376120002
X-Rspam-User: 
X-Stat-Signature: 87j3gs1f71us4cj9919f5g15j7gxnnke
X-Rspamd-Server: rspam09
X-HE-Tag: 1781717163-128587
X-HE-Meta: U2FsdGVkX187b3E2p4SRXGXX4HXaDBy6BP9ieqU9KmnseN5VDD0cJtPqr6llcBzxpYf48ZLaKhN5DLV1q+NZGwkNP6elynOFwKVXni1nIX3YhIxgGLqqC/0B4pYoC1bDx0UGCnAuw5FKe8d2urndaM5KYRG3hjdE5GDxx8TLPfTfxNO1ch8GnHZp+ngQI9b9rpSTYF8ncyc4hYo+LzmtA0vdKzSMOLG6PrMFJYXddeBJBbviimbrsNpGKVJa0YNMyz9Jr9uB7PqbVXKcH62jR81/ATsBrmJ8arv7Lpqhyh0ntoc6U7MzE1uLDtCeMvVnrwhOktkdqAo5sN/siT4eHP9ZDcYA/PhZD8OGVW2Nk8mBA71Irk83120jW4BqjAknFq0J6UnZ9XdBr6NJPMYUzeuQKuidICRAMQnIbDfk80HBXwQtVSfm06iWYfbGk9ZDh1nwZ0dhpxrr8f7cT2vFEkIw18fa5rW1JxtlkdrUOCWC5LDO9O0RLtkKLO/l4SgzVLZ4dFMrDUOF973Asc8J+3Inx1clU9VTZ46T//85A2adkYnNkvQ7FHuwFWS9R0TOTmAa7wY0kOAH8VogO7WUs51NA2wPS1xIsn2fiM7fd937Ec64vgl+4sZvWpNSfEYGZMHx6CGfphkhyqtBqvVlEEz5DF4NS74MpkmJow4g9/wbO65DHAUfauwBUzmT4ghAGYZ0LmU5hymIg21SbDLlbjME32Tw617ZrpKf9DJqqBSUBn0nzqYhmRImM0grNVF1o/hGUDkmDqtkeUrG4GozL8dCuCZnyKhOirlXlbqU0CAVEi545SqV7tggBn9OOqREks4SkICRQUHbgFZ+M6SxzTVFpAePZDK7L5lEMuCHY7jItC/ZetLNWp06yl283p0iyjhQ6aQ/nrjS3dGMHrp+ntPHH3Qkp57phiixni8KLN9zppXkg5YEaOmbklXVq18gA8k2lhfSJRJ/1aGo1OD
 /neaUr60
 VpjISWo1T3JwrSPudo5okRpzeXbNZqZqfdpd7ZG+MdWP2TMNqurT4XV6PoQyZeIv9BVEmYq7ckYcPWKVoy1iGq14Dc7uFXRTxAN8+wxp5AINqcs8fmvsjl3cLb/SPxv3w0rT5Ip8oiw23pkAqpZtvD7Eafse+qLYd7tFVokL4tfrUiRxKLBaKpPFrYz5FMBRCz2cTUJQpjzeIMSdA+GevINivi4rgvgzn+UwKWogkK0+4WIty2ohe1Cq/HjjzqbZDEBwLJtyH5Y+cVeX+A1Vqjc/NnjDpBP6pakSVpmFPu/GeWxDtf0nrt28BhcsiaKyWb9Qc/w1tLCS6GavjPm+MKk3MveYuuvF9gWsyvBIHRsg5IbflQEx/WBbcGvRhyXqAQnHqrA9Cw9aKyJBQsLiAdls2ABRwVej1RCxPFHsDMiGSaN4yTD6WXQGWUdwMmBUZLDoDd8EpRrvQ4U1l2K/DKMrKhkYOVWeA72sJmc1JdOXA0NE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

changes in v2:
 - new patches 1-4: add hwpoison handling to filemap_read(),
   thus replace hugetlbfs_read_iter() with generic_file_read_iter(),
   suggested by Matthew [2];
 - new patch 5: convert hugetlb fault handler's vmf->pgoff to PAGE_SIZE
   granularity like the rest of mm fault handling convention, suggested
   by Matthew [2];
 - patch 6: fixed a bug in v1 pointed out by Usama Arif, also by syzbot;
 - patch 8: did not pick the Acked-by from Oscar (for 5/6 in v1) due to
   updates to the patch;
 - patch 11: add VM_WARN_ON in hugetlb_unreserve_pages(), per Oscar;
  
v1:
This series stems from a discussion with David. [1]
The series makes a small cleanup to a few hugetlb interfaces used
outside the subsystem by standardizing them on base-page indices.
Hopefully this makes the interface semantics a bit more coherent with
the rest of mm, while the internal hugetlb code continue to use hugepage
indices where that remains the more natural fit.

[1] https://lore.kernel.org/linux-mm/9ec9edd1-0f4c-4da2-ae78-0e7b251a9e25@kernel.org/
[2] https://lore.kernel.org/linux-mm/aeZwAz6PcdlqSnJ2@casper.infradead.org/


Jane Chu (11):
  mm/memory-failure: make is_raw_hwpoison_page_in_hugepage() general
    purpose
  mm: factor out adjust_range_hwpoison() from hugetlbfs
  mm/filemap: add hwpoison handling to filemap_read()
  hugetlbfs,filemap: replace hugetlbfs_read_iter() with
    generic_file_read_iter()
  hugetlb: Convert the vmf->pgoff to PAGE_SIZE granularity
  hugetlb: make hugetlb_fault_mutex_hash() to take PAGE_SIZE index
  hugetlb: replace filemap_lock_hugetlb_folio with filemap_lock_folio
  hugetlb: make hugetlb_add_to_page_cache() to take PAGE_SIZE
    granularity index
  hugetlb: remove the hugetlb_linear_page_index() helper
  hugetlb: drop vma_hugecache_offset() in favor of linear_page_index()
  hugetlb: make hugetlb_[un]reserve_pages() to take PAGE granularity
    index

 Documentation/mm/hugetlbfs_reserv.rst |  19 ++--
 fs/hugetlbfs/inode.c                  | 155 ++++----------------------
 include/linux/fs.h                    |   2 +
 include/linux/hugetlb.h               |  36 +-----
 mm/filemap.c                          |  62 ++++++++++-
 mm/hugetlb.c                          |  87 ++++++++-------
 mm/memfd.c                            |  25 ++---
 mm/memory-failure.c                   |  12 +-
 mm/userfaultfd.c                      |   6 +-
 9 files changed, 164 insertions(+), 240 deletions(-)

-- 
2.43.5


