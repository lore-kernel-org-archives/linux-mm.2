Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE894C61DDE
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC9B6B008A; Sun, 30 Aug 2026 00:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A0C6B008C; Sun, 30 Aug 2026 00:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A14F6B0092; Sun, 30 Aug 2026 00:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE676B008A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:19:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0B5B160252
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:17 +0000 (UTC)
X-FDA: 85156631154.25.DF94B5B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id CA026C0004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TisMTFuh;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788063556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17KDooFJoYeOcgqtwlU5ofiBDQP57dVuWi84LFJRoDU=;
	b=NgWQrCUbdn+duelfV2azXZZ7kM641e5qw7snE05LHLtHqoWTFM7WUq8CYk05pEQCdzqYiW
	Dcb5VA3T5A8o8RSgi+6USCj6ntW/TC9xM6pHD8qRdg4/dSnU7BCmlZKfMBWCACMzhQp1E+
	YFuE0rwQSwUPTTuiK9gB08VdrKE0nUo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788063556;
	b=TfMqFD8E2yoVWUca1CDSqfqvBTZwYOwFRoth0urTNk/j6KK86zC+aIvs3dtQvQ4C77HlFz
	PyUmTV5SGflsVLHX5AmpvsGoC2xYHwI5My7Nq1IFHL2kXp3UNkwo1rQA2/HbEgC3+5F4lw
	zmYifQN+84t3Vm+pa4fVD6lc9JcctMY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TisMTFuh;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=17KDooFJoYeOcgqtwlU5ofiBDQP57dVuWi84LFJRoDU=; b=TisMTFuhPCehbA7/9nutMd5vZd
	dGAVseYx9yVTpk//u4fNFf54zujpuIxBHFGc46tKpAUpq1GZxXRPYSn7FYTAklF/bfAtpWBCIi0oC
	1J3BDbE+FEpcCaXt3JF9blBGINHRtNtYhss61eG4phR8MkG4W5HyPetKV9dWjA59icSHtWvcNRJGN
	GiKLqnHuePZ0aPQJE7gGK8fblo+0p7PB2bv+IKL2GOeSR7hWHlnEOEqpTCSnX98Tgprf0NJ7dTnYt
	1ZXY+Z4uZeCw3nVDigJ0ICzRwqLlMVt5EZEKarX+tOuSAxr98ZRt2QwuDcnBtoKP22oJ8qCVci5uH
	unmVDQ0g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000hO-0BzY;
	Sun, 30 Aug 2026 04:19:03 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <christian@brauner.io>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Theodore Tso" <tytso@mit.edu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/9] ext4: Remove uses of FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:49 +0100
Message-ID: <20260830041901.2668-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830041901.2668-1-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CA026C0004
X-Stat-Signature: kpoxcpi6z539mah3jxqafbukh1udxnan
X-HE-Tag: 1788063555-524589
X-HE-Meta: U2FsdGVkX18VyrK/ylSKBZtK7gIN2fee2o35nnADwbw+buqfQ7NRxkGhHn/NITUcWOSHJcjXoO3zbRsLJVlrgh2z7sYrwOZS1XQfMKOvPRbFm/CuGIw5LWL6TAq0y+G7CxSNLeD2Bw+OE1f9XyW+Lcq24q5d3+wCPkZqOf/GinWSIdd9yh50yhcmExAS8m6snjHjpLW0F7DmOQzXTZbzmddLT1eET0rdtffmaE7U4t8y2VJ2EBCW4+NELWlgp4gU2zvkVb9S0Of6VVuG7h2VYuG8KQ8jHrT2Ggc/HBIy3zA0z6FPp0rL1G6pQ+uacZTGqjWYm8bJO/4jAWmt5SIuxdEblT8rspCEGySMNw5OwGy59djMiwO7LCiEuLrBfIiTkP9EIpIAFciXuieofv/VLKmjQx40q5XX4ur92JOge99D6kq23HphjguuK39+jfJGmwkhEtSeBNRnFhpnBlQJ3CTrKbIF9FP5AXL0PJ56zboF1THHZzV70tEiyp3nz0g6W+vg5xnU8TjOJpdn8+FXojjZXv889CU3z9DnP036fy+BC+gAM2RjGVkVkRsYmJE1xSZEHaVcJr8blK3gD9qwAxO9KXJ8ZNI5QGGFaEae9Unpyt2NsC3PjACbi1x2ecKgGKWl6SYyzbHAetZDd2a07AzaeLyZy6qu4hHnLmY5lBvE1pYslvVMWVeyU81O5LA54KQK210CPq7Bzx9H+0bgh6I3zP8b5bS/7qkfIXYml/pQFQIXU1bHuFGTdmKPxrOcxeVVKjI7gwfZzW4gUd9Gdg3o16B3eFNPzIy7JVKy+58CNo8myFFyGLCoXqTNlhGVeNVVI44eUbmYlLYGWlwQzjSI6sM+/tBfBEMwRZdf1rJPvt0qU7qrmMv1IHHeVo7aCNkvxhaoIN3GEOi371fxXLlh16Bp7dzgJA/QR3oNQJugLEEzoFTkq36Hu1LSlfEn6EBsrVhdQmBODb/rUhX
 5r4C/IQo
 9wqrD6ovGrtvi50TSTMYk+8zmt5V0kmKIWMx7XgXUeEK2I1uFIqMxugufQZInqCefhsgDW61fYWxSfClu96+zGUTtnkTEcK91AR+JKb4gNDiOuYyTKJNTltx/7puuXPp5iUVNcMmM2ATPhH9yxv2tvTqDQSxsVO4hfBSKA4iSk9Ev+VkVRH3n8ntt03zUGSrB8BenfEoYIBlgNB5oNCZPXry4SaLw5M2zw0OQmnCvQx2et80/e4WIdVtiP2TzYyGtiavgu138JxoyfoPk3DsphLMy+NLMVsP6tuBObtZkZe51XOJTXBP9gOiXZAsxgSl6fGnTcPRwwYceySoSOhnq5yW+s8WAFx9S2t0UrpjyHuRbqqEMH2mtRyauM/4kTdefpchmzxmLrO/S0aBbY0e6aecM8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both of these locations are called while a transaction is in progress.
Starting a transaction uses memalloc_nofs_save(), so we are already
prevented from recursing into the filesystem and using GFP_NOFS was
unnecessary.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/ext4/inline.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index ceee69a66482..1884abb09614 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -601,9 +601,7 @@ static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
 		goto out;
 	}
 
-	/* We cannot recurse into the filesystem as the transaction is already
-	 * started */
-	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
+	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
 			mapping_gfp_mask(mapping));
 	if (IS_ERR(folio)) {
 		ret = PTR_ERR(folio);
@@ -734,7 +732,7 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
 		goto out_release_bh;
 	}
 
-	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN | FGP_NOFS,
+	folio = __filemap_get_folio(mapping, 0, FGP_WRITEBEGIN,
 					mapping_gfp_mask(mapping));
 	if (IS_ERR(folio)) {
 		ret = PTR_ERR(folio);
-- 
2.47.3


