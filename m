Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 667D1CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 07:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4D1B8E0005; Mon, 13 Oct 2025 03:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C255A8E0002; Mon, 13 Oct 2025 03:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61898E0005; Mon, 13 Oct 2025 03:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A68288E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:27:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B40413A68F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:27:48 +0000 (UTC)
X-FDA: 83992261416.19.92E9371
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8797E14000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:27:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="HieK/1Aj";
	spf=none (imf23.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760340466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4/i6Yo0DlavHvIyOPm6rSuHPtcfvBwYubd7udQWUQmQ=;
	b=Shc72645vbN5IWTojmTdYc0NIwcKfd+cO26In93Lp3qgUI/Hh1ec2AkjFCni0VY7uOiAQn
	4ynBVu3YEaAvvtQiFNp24ahNgH2YMv18zfq3HTaQL+XImeiJgUj6kx3ghDBDTmBsIknstL
	01+Af4TAY86dXbQV1ZnZ1/jSaXCC1ow=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="HieK/1Aj";
	spf=none (imf23.hostedemail.com: domain of BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+429c5dd7f65f3a144064+8086+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760340466; a=rsa-sha256;
	cv=none;
	b=M6OVfnfSHvQbR/YgMQ9X75jqnGQZXJhGW3SkshJSG2HKPihulUG5WpA0I2xGirCCYw1aaE
	YfPsHv3AKN52qMGvaj+XFFJv2mfPP+PnrJ5fUfxBoI3kXIiJXG+1UDORBDIoYkA4pskg3Z
	8FX8pFf08CT7fHI6G+tICDpVSyhWC+o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=4/i6Yo0DlavHvIyOPm6rSuHPtcfvBwYubd7udQWUQmQ=; b=HieK/1AjETnFbyPypM9vJViuqg
	SRNPd77JSXoda8B1rp+WFEYqCrKqUmvraiWGmg4PcPq6ANQICDS/CD2hgEY1Pw6kkbOeBCb2axRAi
	69pZZOtzAMJaebM79s6ixL5K23P4JgeKkkKKpiq/UilH56UnMPOz/jC+t7zBCcb4Njf8EiZCnPZmh
	IbcVkFQBybIpirM19Sst24gUjjkw5agH61uB01fhnlPiTgLS+s2pQb3ldct1WkmJFtMgs8CNdj1ML
	VZcqaGdFE+oki6oPlsIkDvO0uyah5FiT01tAvdGgx3sdMaZr51G2ghi2XMx3+z7Z86C+guaJnpcSe
	3EIYJWyA==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8Cy8-0000000CUF2-1DDD;
	Mon, 13 Oct 2025 07:27:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: jack@suse.cz,
	willy@infradead.org
Cc: akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	dlemoal@kernel.org,
	linux-xfs@vger.kernel.org,
	hans.holmberg@wdc.com
Subject: [PATCH, RFC] limit per-inode writeback size considered harmful
Date: Mon, 13 Oct 2025 16:21:42 +0900
Message-ID: <20251013072738.4125498-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 8797E14000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: o4rp871kn9nouyxo33gefoc1omnazgmw
X-HE-Tag: 1760340466-87263
X-HE-Meta: U2FsdGVkX1+XlW6/GsVgFXtH4aCah4vShFDs9TpqLTPBp9BZVA1qYMo+Yj52DTE/ZOfaUEzLYGH/JElV8vkijHeZ5JsAsVBfNzT6NHZwwO8NKlqTbm+zleD4KymQ4t/pZDy5BmlEk/BQNhWvwoP4XLtgVFb/e6iDTlx0FQZG/A3XAdTRe+5OGZ6n/wxGgmNXohW9ozdkWgr2mSE1/EFna6p618LfvkbCwB7hMQ+VGxR9+LWVdN1n3EE9FdF814lkxF2MbFeNk5no5Iy9lrYWWuWOGUXV60Py2C85BtNSk4rRhpSuLS4hE9sdWqsPKhAfDu9PCOy+e9ZHdv28XHQCF9z0NXG0hDjQ4CQoTOY1Ss1JNStxGGCf505u+9WozWOzT5AQ1GDFS3a4tgl25Im20o3/6FpO7MiHNQhJL8NKHZAPp83LpLshEmgGO05ve1gOn7+KM27ss3GFUdryOktxuBL9iXyPLegElpe7IMPG/G7JIX3Dvq7zNOBS/sc4Ns7667rYD8k0xGmZclXHhiXQ1NTFHoeuqgB4wUJVoxU5hsXSXZgmNaTYoAtWAsijn9Jir5PgSID4jRdx3/mqGw8Y7U1R3Cag8sB1X08O9q+2cRbhmR4m3OgxSmYLyOop/Vhmsd2FnoEo628EvDY+egXh7prsI4WZdLLVpAqlynvGuaiTfpuZS5wiCbUjA2Ou3IlbGpz+dKIAVR36Er8xnqc+aq6oAa/7yweVXORfSiIjXP/5BVjWaYoFWHfRNW4xN712AqNqyV1s53Lye6/eho5SOpSXCDElPsU2DxUafrGZQvePEv6ozxEy51KI1COV64K7czb7FJdxyHXEbznbpVeXWZbO6PKqMfSKDwHZpcQnAUK6aYJ+x8s4CY+XNL8zq6bUNNnXYDz7GhW11mxAyHRpcwdEf2MzRUAKEBbXSBAY4uQar3xlSHsqL1XwA+CDqwTqzuQF0eQIjr3Ocu5k4Ai
 s/PXDhLU
 mgQqFCphTjrxRghDt7Hkj8fWY5qiuz86wEs15dDmAMCUurmd3DJ7Ck7GouxJSsTkaGqXMokdRPMwJFLJqiyRJgVlEhmF3mbMoAab/OYC46Il9/pC7rOODAEmKKjVTq4l5PS6ggHQ01LCpuE09tdHrH/TPxkErdb6CdcYMJUUdNgYCU7ExxSvaaw8cMIoFZNa8LHc6+/Cqt8ipyOLsm/mkPjcJAIFcIV5AKehL5m4mOpFFiYDKOdatn46ik0cmXSs0eJGji0FAE6hJVpUOXyHv2CokWlUiqo18mwx/k0ETDhMKDFMFjkPfCIFU4zp37KD/TdQ+yeXLvxQQVdDfDc9IEfsElrtUnS+QHz7d415RKJfmIYEbfawpKQcbVgBn0gEtyKV4VrWxusfapaOwYNLbwziGyazlsZ5PpkSSCoejKUIlTzusLTgUt9Kr6my8u+TxvtLWDKn0gf2uTaBjGYGyyzTzWT2aks2OjpGEa6sTKN1pBi2L4TRYRXMdmore4XcoLQvPAAEEQkcfQoNHs7REB82WsomWzLd9RUg1GkcEnZ7a53k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

we have a customer workload where the current core writeback behavior
causes severe fragmentation on zoned XFS despite a friendly write pattern
from the application.  We tracked this down to writeback_chunk_size only
giving about 30-40MBs to each inode before switching to a new inode,
which will cause files that are aligned to the zone size (256MB on HDD)
to be fragmented into usually 5-7 extents spread over different zones.
Using the hack below makes this problem go away entirely by always
writing an inode fully up to the zone size.  Damien came up with a
heuristic here:

  https://lore.kernel.org/linux-xfs/20251013070945.GA2446@lst.de/T/#t

that also papers over this, but it falls apart on larger memory
systems where we can cache more of these files in the page cache
than we open zones.

Does anyone remember the reason for this limit writeback size?  I
looked at git history and the code touched comes from a refactoring in
2011, and before that it's really hard to figure out where the original
even worse behavior came from.   At least for zoned devices based
on a flag or something similar we'd love to avoid switching between
inodes during writeback, as that would drastically reduce the
potential for self-induced fragmentation.

---
 fs/fs-writeback.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2b35e80037fe..9dd9c5f4d86b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1892,9 +1892,11 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
 	 *                   (quickly) tag currently dirty pages
 	 *                   (maybe slowly) sync all tagged pages
 	 */
-	if (work->sync_mode == WB_SYNC_ALL || work->tagged_writepages)
+	if (1) { /* XXX: check flag */
+		pages = SZ_256M; /* Don't hard code? */
+	} else if (work->sync_mode == WB_SYNC_ALL || work->tagged_writepages) {
 		pages = LONG_MAX;
-	else {
+	} else {
 		pages = min(wb->avg_write_bandwidth / 2,
 			    global_wb_domain.dirty_limit / DIRTY_SCOPE);
 		pages = min(pages, work->nr_pages);
-- 
2.47.3


