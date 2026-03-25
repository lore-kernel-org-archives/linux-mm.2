Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3361C109C05B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BA406B0089; Wed, 25 Mar 2026 15:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691D36B008C; Wed, 25 Mar 2026 15:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7006B0092; Wed, 25 Mar 2026 15:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA466B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF5CE5C139
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:30:45 +0000 (UTC)
X-FDA: 84585577650.09.631ABE0
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 79D0F40015
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:30:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Au7sydVY;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774467043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qfY4Yey2B/8xRD7jk2HVXbmFsGdrb8gwFavo/knRp8=;
	b=0l3zQZWbudMiR8NiEWQyNmLmOyWnDocC2uRbTJSE5tqFZNGh8KNaAU8so+4K70ul7qvMYp
	6I8jeBOVwy1J9GuasIHOSQWzi6zn2w9fcfQ9IdaqwZDcPkDAJu7fUOV6mSTBwPiRF3HS7o
	r8tsViGADq8pDUmWMH9ccMYAtpL6o1Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Au7sydVY;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774467043; a=rsa-sha256;
	cv=none;
	b=YdHw5ttyxKr+FvnYDaZwWWbEcYLIBS0EHM6LJozPNQvgXLO010hw5J/ZmLSetumRfk0F06
	e9choE76K7FH8DHytPsNcf/a7efLZqnX9yHIzLnYheB5yoq7v7O4W8cNUG1XXxl0jwAsn7
	psn7dNjiJ9R/13/GuhTr371pXiZkYl8=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PDhTRE1628283
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=7qfY
	4Yey2B/8xRD7jk2HVXbmFsGdrb8gwFavo/knRp8=; b=Au7sydVYHJxfvhcGusjW
	FEbpn9GGkRrzgLrTHhOCMbptHSX/ALA6C88pzf3RJSXe3GRiSgydzJVOXWnM9VaY
	BNdVPii2y6i0oYq7y+9TO5mMxTct2pKIusyD79XPROlhYQeMKRNs87jKHrvyI0uw
	Wn8noKHIq4KB814b8F0P5FciGNk7ALGmCIX5JsU1y5+3ZOptL+6ahq1z3ywm2k1x
	MeMBSMQF62gu6jXDiXJrd/WT/tL/m6ciFKIBfAIwvo+/WigpyDrml510h3ho9m//
	h3PTLxppFUGY/IZ/ripHeVxqmM3JNsTeqGDbAUh4GSukZ/h2dod+qzk1+uc+2Tnd
	Ag==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4d3wxhswsv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:30:42 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50b878a8c07so10457191cf.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774467042; x=1775071842;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7qfY4Yey2B/8xRD7jk2HVXbmFsGdrb8gwFavo/knRp8=;
        b=nEdYQRkNxU4/cE2TrJxVzKNRJBAYaRuMbu/ox2S/PuK+HmNCQRnY04xveN3Po03BN7
         0otYu3ZGVmPA9AB7DyTZwYcMrKXX7wEboZ/IAmRms+ty/T05/N+scwZWQdgeMZzaAtmB
         YjKzN9nSR9OU3nOOhde3LEzJuInBa16saoOGo6P+H0/qxoiyNOE30rml3kXslo8ZGzeR
         bSHzcCKTHpQDF/VZcOYWt/OuVUrP7SrMHpojeor+XAuuzLmcO5hrR4B9fnQG6GmM3SOF
         ZvA6QSHDIFwm7P0fuiJGDpbO0Q8/3bsF+Qb3iUYCwO9GHcLRaqdx4vpvHOvSqoehqUWB
         vsqw==
X-Forwarded-Encrypted: i=1; AJvYcCWfUvIHYqRFp5VtVZXIZJzvzNtMElH0LrduaGuoIqQZKCYEoA51UlByBh1ovZ6CB1aIHZa46IiIiA==@kvack.org
X-Gm-Message-State: AOJu0YzvrBzXvjEHh8wzP8T69m83Q//imZgFCqZZqI8W/2ZcDgGe4JYS
	mqCJbFGj8QRH7pXbTIUmPdzrYHS0zjdXDk7YZzHJBFdQi4iE26FtJdelYWDk2xQZhhdUBWzR8fh
	juwAgIw7SmNFG90aiqSzITi+/H83aWERRtRY3MMo1oZJWgrdm
X-Gm-Gg: ATEYQzxGeg2wQZsaQEOpxEL+uZkpWR+lL/n43q9ZBPL1OjAUSf6WplgcAJirPd+PeTh
	OGXmFYkKXf7TeJ4j6b9v7xOQEFEsp312u0B0hOMut7Y04hGwr0oCcOf5HRtSD6acqnQQFuKAiCM
	zReCHnC7eFWay/+FpC9jqCAK3uwZXIejdT+ZDOG+uoVkHfe33qgOntx30IjhBAKneHgTFRfMgBW
	0NkMB5KEZUoLzozJqpo5LgO9I7/Rl/SxEw5QhRAqXgkQEDMFbbiY3egs7LHgzNWgLVFMp/26aBZ
	FUaMy8KVHKVQr6FIa9N9T3D6u2+ktjHvBOt4hemKCtTYibzmzXfJJv8R8K5CSlLFcP2fh/9s4y1
	fiSHV0PvT1SQSkt2s11fX6vFCd7XXRhn5dSaq5Q==
X-Received: by 2002:a05:622a:9d7:10b0:4ff:c08a:52c4 with SMTP id d75a77b69052e-50b80ce31d4mr55571861cf.18.1774467041720;
        Wed, 25 Mar 2026 12:30:41 -0700 (PDT)
X-Received: by 2002:a05:622a:9d7:10b0:4ff:c08a:52c4 with SMTP id d75a77b69052e-50b80ce31d4mr55571251cf.18.1774467041146;
        Wed, 25 Mar 2026 12:30:41 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.226.199])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b9234e3a3sm5534221cf.19.2026.03.25.12.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 12:30:40 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Mar 2026 14:43:01 -0400
Subject: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
In-Reply-To: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774464193; l=1665;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=7zwsmyUip3CAkS6JVcgPiuvcXkqOuFIklXcl4CKLS7s=;
 b=L4CWzIK6kHXuFczj/fPjz2aWyUnS1OpJUL3M+esbeR43gMhMyjhAVsUMhpLPiY2zQSiPsjHza
 J5C73e08cUYBjjsRFhFa/ta9SjUn5dInI/J4XLjlsu/GNzv1JM0+xWE
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDE0MiBTYWx0ZWRfX0DSCDyymomDe
 3uq8I9ExctsW5V1qtSCGUqlDGAW0kLskepXvSA20KXtceufSVWtC46y/fHb4EipFijtqrglmNIW
 sF2iN+CFaQhKuZHtPP1FcutVUgMV1redJB0qN9xZIFTcNRVe2JQ/lBTxHtkhmU8rZGWQ0GR1oRX
 /BGKBLwaspP3uf6OTZM2ZXBUj0HixjpF4j8kgFv6PNmagvmEQu4Dckj9AKMmqmQa6qXT3RX8Tn3
 ubIc//Zb3k9KfZFxTOa0cF4bnLla+caM0FBq8hnHv1fyQEPrpeamzPwnUiFjMhpRQJyBWCMtVds
 JVOkUeG2bPvtB1Hu7ARNGXqxT8arvggmy2RH9R2sxbbpCKmEaelIJ9YAqlebpzR/5DQMvWZ7dYJ
 rWS/mlknCqwfnAuet2hwzl+WDsbY1MVQfwZS9EiiwDNyHh+Bh2SnEmJBVtD4u+p6sSz16PmnX3D
 ylxdpZBqfxEwMMO2tgw==
X-Proofpoint-GUID: hEHqZ8nCgdAdXnzWINmmotOKsQRtt17L
X-Authority-Analysis: v=2.4 cv=V7NwEOni c=1 sm=1 tr=0 ts=69c437e2 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=QOUmeeuX5y9IvSxXHa6D2A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=wJ0dTj9p17mGQU10CegA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-ORIG-GUID: hEHqZ8nCgdAdXnzWINmmotOKsQRtt17L
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11740
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 phishscore=0 impostorscore=10 adultscore=0
 bulkscore=10 spamscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603250142
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79D0F40015
X-Stat-Signature: 3kitsrsws98bix679uyhxqchryau6kx8
X-Rspam-User: 
X-HE-Tag: 1774467043-745630
X-HE-Meta: U2FsdGVkX1+v9f4x0hQjqZ+kO8piR6FEXQYmk17y5+DsialfSym+ecSONhreUsz4CuZw+6xnbLTjta5O5msX/ygJGDxORPJacAuZIt1S92DK0U7k5BxFYQZYKIsS/Fc5vQQrsaDh4W0s22+4ZdVjLVZflZR+2heS27sBS66JPLl+FLhrePVzMwgQUWGt9tt9TP1RAzrfeswr79IvzEA3AfDfQkaXyVkXTdpD/8PDInyUhPaAvgTgAdNG5xOWIqNed3qiQQSNZ9XKLW6O1jlgxwGg3RUyrw6FIWkjJkdTCOxL0tvbguijfwQ7q5sH8OAghBIDLQqWspTBmbwvMJBe9XFQQuZWy3pGUZnuD2tdXLmSEa0ufOqEJIS8zPeiRhfv63O/1tX4G6VIpWlP7d8syBcp+LBoSykNfjhplHaGp21lVzGxZNNVNcA/+p8SchbjRkXPSatrNvtlfvppQF8kCm7qyhz8538vf6cpXcnFKOuBZOBwp5HjTlE0wjgNHy+3eiVXxJ25QX1oNkY0940OT5MaYNGMKSP5pOHIEYWIq2z0ynmgUcWAkOcGgw/3Jr2khmH+4e+tH4h7A0QpA9pF3spJhOXi/6VrRSqAq9Go/iuMYwA0l2Ou/TKnV/p/UGlrznYdRN3+k3zuxyKRvVwszC+pxt7pykQ9WU2vuzgl48uKa81JIAZhHJ/j7HX26c1vlSHyFe1tSVRj3YImCiWahcb1xONMBnuhRFFg/D5Kb27XnMk8//SdsmKGmJbFoFK9P6gxFKMtsD0B7TJFEuujDqQSUeipDHrEib6G40ZQUDb/akVjdz90l30ecUk0jD1yVjkbAbpnTfNV+gOFQq5oc6aSR8/orKupkkFeuFdDKOwkNO6iIZix4FS0Gco7PKwEbHIxkep7qXcXo2K3AUCMvZ2u8PXeAfLsEWviofapvezbL5Ya/vot6k/vh6pqf6sB2P+3sApok/WopDzl7Bq
 8S0wn45e
 6SUWSo7c1iS5wXMgA/orPh96LD+cJU3cjqJaemijrV+cmVbxURH6KIS6vnIyizyMuedQKL/X4KIEdvQMUvL979WeUed3ZwdIR87RbZwqnqLPbvR+D4xIVAyeRJGjhjZPu1UL9YqICMin5P0qbCz3xPSAd6WjU8sT1Uz7d7Rdmf06T1sbgvXZO5bKVC6nDBPLQPiZ81EQTaFKZGiMMEw9Kt7lmy0GdO7zMk1gyTFOU+gRJwxoy/2BB807VAHXNCam6FE3DEMJ+/4vm9Mepe1xqAu6dg1IgZJ8S4jrl6gBBvsBaE+f+8zZpMqMQc38tBE/wXDwktNkcXhWGj2jIFJ3dJmauLN3z/eyaOwDiG4/RAfOpQAXDB7LEuPKyWnWcpm8RpG5VnVRlJcd0HBbiGr8qYW+Zsrb7L+GRt0x2+jukZNFgQ+6KBNB0+2Xn4WT762uCEOGUwWl/tADxdhwmKgFBIMhO8pX7NSCwg7xgL1Sp5FmhSEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set BIO_COMPLETE_IN_TASK on iomap writeback bios when
IOMAP_IOEND_DONTCACHE is set. This ensures that bi_end_io runs in task
context, where folio_end_dropbehind() can safely invalidate folios.

With the bio layer now handling task-context deferral generically, XFS
no longer needs to route DONTCACHE ioends through its completion
workqueue for page cache invalidation. Remove the DONTCACHE check from
xfs_ioend_needs_wq_completion().

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/iomap/ioend.c  | 2 ++
 fs/xfs/xfs_aops.c | 4 ----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index e4d57cb969f1..6b8375d11cc0 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -113,6 +113,8 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
 			       GFP_NOFS, &iomap_ioend_bioset);
 	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
 	bio->bi_write_hint = wpc->inode->i_write_hint;
+	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
 	wbc_init_bio(wpc->wbc, bio);
 	wpc->nr_folios = 0;
 	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 76678814f46f..0d469b91377d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -510,10 +510,6 @@ xfs_ioend_needs_wq_completion(
 	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
 		return true;
 
-	/* Page cache invalidation cannot be done in irq context. */
-	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
-		return true;
-
 	return false;
 }
 

-- 
2.39.5


