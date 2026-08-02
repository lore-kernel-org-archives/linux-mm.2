Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C82C0C55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C146B0099; Sun,  2 Aug 2026 12:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4FF6B009B; Sun,  2 Aug 2026 12:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12376B009D; Sun,  2 Aug 2026 12:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B6D16B0099
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:26:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2609CA0508
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:43 +0000 (UTC)
X-FDA: 85056857886.26.DA92053
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 94298A0003
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LkusKe2F;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785688001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccJR9KUzvn7k6BzhoDEjN3sQrL1C2MxY/yOiNOzvC90=;
	b=7AiqPufq7wybOYICkRQ8w95KVASL04EbzZRg6rb/mYZyYTjz0c8+PoTFg7KItV7SEYZ8mm
	y4bazTFuiYV+qvca6iNrqS1nxfrRTc4qRV4PBcZ1AcYcD7Z1cOsoSopLconNNAxwx2F/bR
	p/BjRNGroXgOZx1Z5GWwCTFOU8CnbLY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785688001;
	b=zMqwwB4uM3Y2lgQLTz6rEp8f4wmo1naF36SA4qhRU6EQGfDBWYwZ07vSgvMK/DIWgzYDab
	fgiHCtoe5rHw42JcqRyBUr5LjBYdJdyzkvr71UMs3c2ic9IHoEUobWzWfVCsmYQW7bjqBZ
	AfFlogM3C2gDdcVHck3BcnuZP2WaedQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LkusKe2F;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0853C60AA3;
	Sun,  2 Aug 2026 16:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855FE1F00A3D;
	Sun,  2 Aug 2026 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785688000;
	bh=ccJR9KUzvn7k6BzhoDEjN3sQrL1C2MxY/yOiNOzvC90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkusKe2FMzJBDbjcyry/6L7Ye17EKtbUrBNtIWUra74cYtqsGpoMI1PdIeeRkUdEL
	 r987uAJiH9MyvCSbP98srQXmYFaUswDAUdc/hsiDePQU3Y29gfH9Fj7oXiZTARPOW6
	 In1y/bOdVU6eyO3IRSF0OyfhXWg+YUQuhC+/uTw7zUgrBuE+Pq9uS3TQqmqXZkvtWC
	 AucarmJsSQLIo84mQyoUlunXNC4Ybinv2sVSsDY1Z2B6o9dJNcGhGIc6rd1bNh82jV
	 4XH4xoGZAK4gkqph6/Cp4QC+cVo65fR7fhiSNCZxaeiLZfivlcm7GwCPDxrUMnBUU0
	 KXOiOI6k92L6A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 1/9] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sun,  2 Aug 2026 09:26:22 -0700
Message-ID: <20260802162631.90304-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802162631.90304-1-sj@kernel.org>
References: <20260802162631.90304-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94298A0003
X-Stat-Signature: mkoba5u3kmqy5nzx43s53qjw11tagozw
X-Rspam-User: 
X-HE-Tag: 1785688001-948317
X-HE-Meta: U2FsdGVkX1/WXOD6f85T0DZGJgrC0xm5JlMki4JHIFpl/VPihkg1KhX09WcDuqM32lKe1kddyEc3lREHRBhpbO2nuvBv+9NFZMv3DXmu2mnozWRgei6tNLT1LEkzOlEIcn7/b8w6355rI89MNdkrlhTdR8cYWC8YG318uRV6b3hPNp3sxqNpTsMwsFuv/F60EGjQF9JotK5ixGxGLuSvBwQ2a+js1V9ZTruIZj3rjo6/Jra87qHd9yxv4MhJ86iJWtlLPItkI0YoXFpbgbPlvuHthpwN6r2yglPtIB21PJQWYoxKpjng05fpP5cogUKAmzjEqDbDjYK/ALKvmyZLzghhTtRIBFGhkH4TKNltXOoMbllYatiga/y96g5qh1EQycEY3sHcrpDZBjGbmd3GWY2lRFlREIlmrirmqKvdj9JzRswN10q7Wqaak/uEUrU1P8cp6Ni0jvCnOe9dX6Gj3Fl8C2MPCe66CyZEe1N9ZUnXCQijRvtSDGqPFuwEFzWUK7DdJsUgBOkB/7g4YUiNn2AMOehCNAvJXlBS2DwbThNBNao+w4cAGrlO8/sAlShhuCYsvh1K9+g+fqR6JS5jgZ5k6Ci5w+fgzVD+j+0qKaxCfSA2F07lMLGSeezDOjByJna5iyWWp5rC0o6lahrKZrLADnBn0itQknt4UXNHqEY2GcJU5ZQe++eSO85NLIcD7qwLsk0QdW+M2uL5K69bIeileoY5EJUdQE4KgHOURHDrrWyVsRLM04nyE73Gn1mDF5d8us0020uUacbvVfXz+W2udbjX6yiUuNIUQNgR88Uo9myJfr+zfoRkFUlrxeMRsJVkYnn2UsFNkpjd/spB6Xld9kn/Xn3Km7LOzM6QHVDg3X0MGP5TcbSB55QF/jIOzUo7D+fayu+A+hgabIUvYkKIzMCFe7wioHbeYLJyL/IC5v62M+hTfX3HlnBp3VUpBelMwh87HhEUUD/Kz8o
 s34bwiD9
 QqRPABbP2hqnaYemybc8YtykBTe20ltnuforPSBmEosb9D3keM9RY65AJnQQtJA5dQHIU++wfs6XTPOrKYdVLGHhH0p6kwugDXn2KgWhXBzicSScEizkRKzg4pDXU5F7XyYq7jbAG1bMulupDcUSsZ0sgw1kx/yv78ylPmnU8jDMQgC0IkrHXzcCdblT4SZw84UyKscJfv/uSuZxbAwrWYEZoBDxR5DdwVB8eAftXNF9JEGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_apply_scheme() splits a region and apply the action to the
subregion if it is needed for not violating the quota.  The split
operation (damon_split_region_at()) could fail for allocation failure.
In the case, the quota could be violated.  From the user's perspective,
DAMOS becomes more aggressive than expected under the extreme situation.
Handle the failure.

The user impact is not critical.  The failure of damon_split_region_at()
is unlikely since it is arguably too small to fail.  Also DAMOS being
aggressive is limited to the single region.  Users can set
min_nr_regions to set the maximum size of each region.  If it is
reasonably set, the transient overhead shouldn't be critical.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org

Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a16560..e2900d0c984c9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2613,7 +2613,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					c->min_region_sz);
 			if (!sz)
 				goto update_stat;
-			damon_split_region_at(t, r, sz);
+			if (damon_split_region_at(t, r, sz))
+				goto update_stat;
 		}
 		if (damos_core_filter_out(c, t, r, s))
 			return;
-- 
2.47.3

