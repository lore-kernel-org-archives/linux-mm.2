Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F5BDCCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 23:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B2846B009E; Thu, 15 Oct 2026 19:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489E66B009F; Thu, 15 Oct 2026 19:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A6E6B00A0; Thu, 15 Oct 2026 19:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4CC36B009E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:33:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48219140209
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:19 +0000 (UTC)
X-FDA: 85326464118.28.8161DF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B872D120008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:33:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MHTk+M3E;
	spf=pass (imf29.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792107197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/aAWxJL1CcUB2j7lD6lXLnALpckGsLDOXNnExtYI2O8=;
	b=4QacvRH0QwYZ9BZ7Ywkg8b9Af+eLoEqs91mR0ffuIOwJkS9U+a/dNfPHd1bnFIj6IWFWNm
	HKWJ/i+NjsVGIi90tsyg+xdprhD+TeGB3OPDeF9Q3NaplRoa9/vrtNCnwoC9JPB3XxzdXG
	1CMiqYhMY5DgcRCpaGbJ6vmzihN8D6I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792107197;
	b=px/VXDWxp9eS7o5izkjMjspimx0eufYkl1c/s42M/7LY1mRVHDWifNEDC7SmeiBmEVkTNa
	mAin/2DjXqzf1TCBvF+JYoM6YI8zzD+Gu7stCdVTbQuRpZq3x75m65ai83IkH/YqCxsSR2
	8kCv8zMmLeORdbZ9fdJvuGg4S2mPt/U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MHTk+M3E;
	spf=pass (imf29.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B81B60A81;
	Thu, 15 Oct 2026 23:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58361F000C5;
	Thu, 15 Oct 2026 23:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792107197;
	bh=/aAWxJL1CcUB2j7lD6lXLnALpckGsLDOXNnExtYI2O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHTk+M3EVwUrKpBXxJvSHYX+M9wTAey7UijMzcDES+I5biYb3XkCPE/ZdzkkjTiOl
	 v64XRhs2xzTRNF8c98Tkt3iOkfRc4a1LKmKsj8F+6pD2QSs+/jTb8O0yJOL5WipwEo
	 j3oPFJ7UAeEmMcGEFr3/YGHE2U14LM9iJW+YJK/w2KcWob2P6nynSW1ZZWM6KY+JLS
	 NkZ73TpJSzlfe0vtMEU/P0AebahN6OvnRaf+VatOH4BpwpxdCp0Ce7HaGTLl+WgAK4
	 2EAYzXypzdiftroYv3iC11SWEQJ4HDF7khgXxxv7E6BejRzbLp+j0yZi1nvy5+N5q9
	 14BF9SkOL8TyQ==
From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH v4 05/10] NFSD: do not use direct I/O for a READ smaller than its alignment
Date: Thu, 15 Oct 2026 19:33:04 -0400
Message-ID: <20261015233309.42999-6-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261015233309.42999-1-snitzer@kernel.org>
References: <20261015233309.42999-1-snitzer@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B872D120008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: m73dyiyziyqgs1qbpdb117efcedj8mx8
X-HE-Tag: 1792107197-333723
X-HE-Meta: U2FsdGVkX1/gze00l1OpTBnQnaZFfRReb03Zpgl1l0Y5WHscKjrja7kbLJJWrqW7bfoPL86wrzF6bDHDwqMqBu1UVJnxCvH9hGloRH6gK5Z8Tcx2t1DLtPhOuR5qIP2NVf71cgEyEnrq/RWVKvmx+GRfyvThvDgDjiD0MrNg/O4auRYEC8u0tAfCPOGDB0UmWdGHB324wX0AsbSSyC26PObCZ1R53AmveO4FH/VNK+QNK21hHrNvDHUweek8u+JWBSjmRzERLUKCa69vUCWoyPK4dMjEs7GRUV5sk6lLt5Wtodf77w0x1HqpGukONFN9Li8EDMdAcgJYyctuUnMEmiuZ0t/SY0msVpdO0jMihT6If1KAL+aVdobCojSn52yibanRC7+mK3DkGJ+/KJEfhS/uvr/FjMbTjdWacZlh+YPKPdR9lx4KfKmCduIvb7+YsHlBDcylhOmueobYed12IchMZMOx55PHu8KCuW9YGjRNDDM9bW+IiXO1cgyIRGFsVvODq7ATXxo7w41mg3JQBZZaM5w8Oe+CBFWzuECnkMKH7K8InmZOK6C0qbT3jd4MW2Z8d4RHTdXIfgb3Dwd9w1noZ+eSImfSD5e+zCTqlrppRPMreMw1/FzZ2517SyWVSqJAqhMsmva1HEDuUS1+QaKHQkOsTTD9IvBaU2zRsWXb8S0ftdc/aG/0Ct0z8zhwtTgT9D/Tidt763oUda7NyP85dqVk1cQTP7S73139XQA7IeE1SMZBCsRvVQK2IPmK0mUmDXPG04KfLqMhwegjvRnGO5/pylgggFRQwel7LMMf6YcVvz7WV3JqP6lI2NA70hFh5lmVb/rSOdZM9+kUFVmoKk/oZAmuR0dwZ4bQhpSU/hGnG0y8kgu1kwCWKiXzZ3sChiIGthXpzBhlk45gV7G5FTjFAWgsH80f/Z08JM7x3lxLfd7YGDztE9l3GJl9pDVZcVbIfrPC+WV28qY
 JVXAoh3K
 1duE1KCflK/biQ9wiih6unXw5LdGIsP4+6kebt5h7DFQXQ5i1UpuJw4ypvcmokB9i10Vi/OcKlFtqiu3zofkZp4O8yQz/DxJ6WK35tZfmOORC4xFh4hgSM05y2xt1HRtYY9EuBLEM4TTjgupzEHx+tc1tVQn7yfSjpE9RVZIpLW+uEkyuRpcSPIc2MuTh7a7Yv+cqR4m4+SA+fl8mfAxmpENdNdsm3gbS0W8kDjHsmsvM6VDVKXx+uopHbaWd79ps25Z8AiwpD7UE3vkZIjqZpVHWdL39/vpuHe4RJ1Sq2n7Con9bzLwxCGocffl5u6TLxWtyr+OZrqTkcrue/+AaPWfEUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nfsd_direct_read() expands a misaligned READ out to DIO-aligned
boundaries: it reads from round_down(offset, dio_read_offset_align) to
round_up(offset + count, dio_read_offset_align) and returns only the
requested bytes from within that window.  When the READ is smaller than
the alignment, that window is always at least one full alignment unit,
and two when the READ straddles a boundary, so a few hundred bytes of
payload can cost a 4K or 64K device read.

Decline direct I/O for those.  A READ smaller than
dio_read_offset_align now falls through to the DONTCACHE path, which
issues DONTCACHE buffered I/O when the file system supports
FOP_DONTCACHE and normal buffered I/O otherwise.  This mirrors the
WRITE side, which already declines direct I/O for a WRITE smaller than
the larger of its offset and memory alignments.

Only dio_read_offset_align is consulted: nfsd_direct_read() lands the
data in whole rq_pages pages at offset zero, so dio_mem_align is always
satisfied and only the file offset and length can be misaligned.  The
threshold only bites when the file system advertises a large alignment;
where it reports 512 almost no READ is excluded.

Document it in the "Misaligned READ" section of nfsd-io-modes.rst.

Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 Documentation/filesystems/nfs/nfsd-io-modes.rst |  5 +++++
 fs/nfsd/vfs.c                                   | 11 +++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/nfs/nfsd-io-modes.rst b/Documentation/filesystems/nfs/nfsd-io-modes.rst
index 2679d85152dfc..90bf1038453cc 100644
--- a/Documentation/filesystems/nfs/nfsd-io-modes.rst
+++ b/Documentation/filesystems/nfs/nfsd-io-modes.rst
@@ -121,6 +121,11 @@ Misaligned READ:
     verified to have proper offset/len (logical_block_size) and
     dma_alignment checking.
 
+    A READ smaller than dio_read_offset_align is not expanded: it would
+    read one or two whole alignment units to return less than one unit
+    of data. It is issued as DONTCACHE buffered IO instead (normal
+    buffered IO if the filesystem lacks FOP_DONTCACHE).
+
 Misaligned WRITE:
     If NFSD_IO_DIRECT is used, split any misaligned WRITE into a start,
     middle and end as needed. The large middle segment is DIO-aligned
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index b596bd61f8cb7..7e65328de7c86 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1166,11 +1166,18 @@ nfsd_direct_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
 				eof, host_err);
 }
 
-static bool nfsd_direct_read_ok(struct svc_rqst *rqstp, struct nfsd_file *nf)
+static bool nfsd_direct_read_ok(struct svc_rqst *rqstp, struct nfsd_file *nf,
+				unsigned long count)
 {
 	/* When dio_read_offset_align is zero, dio is not supported */
 	if (!nf->nf_dio_read_offset_align)
 		return false;
+	/*
+	 * A READ smaller than that alignment is not worth expanding to one
+	 * or two whole alignment units.
+	 */
+	if (count < nf->nf_dio_read_offset_align)
+		return false;
 	if (rqstp->rq_res.page_len)
 		return false;
 #ifdef CONFIG_NFSD_V4
@@ -1222,7 +1229,7 @@ __be32 nfsd_iter_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	case NFSD_IO_BUFFERED:
 		break;
 	case NFSD_IO_DIRECT:
-		if (nfsd_direct_read_ok(rqstp, nf))
+		if (nfsd_direct_read_ok(rqstp, nf, *count))
 			return nfsd_direct_read(rqstp, fhp, nf, offset,
 						count, page, eof);
 		fallthrough;
-- 
2.52.0


