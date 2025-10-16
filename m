Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51E44CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 21:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB578E002A; Thu, 16 Oct 2025 17:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5E68E002F; Thu, 16 Oct 2025 17:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7357A8E0030; Thu, 16 Oct 2025 17:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 596DE8E002A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:47:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 255EB84FCA
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:47:46 +0000 (UTC)
X-FDA: 84005314932.21.4062495
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 855E9140011
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:47:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MZQnwU0h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760651264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhzEwW2E4iclg2x1oSprT3KbJDt9qOcYhbVUF/zEpvQ=;
	b=PbIT1Tx0isdUSVUWUEk0fGNEHpbtzVM7l0W5+bPAMxoau2j1ZkHSlDMotrF/lmMwaf6vLo
	AwztXhNxi1q31eiV1A4evtgGw3yudg1OTqvkBcj2ZHrcTR2x24BKTH1U6oSgxQWoWHJkCH
	iKTzu5fN0BrtiTWsaPC+UAhTycyFpP8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760651264; a=rsa-sha256;
	cv=none;
	b=5g7OKyxD+gY3KtNND5lbgF6GQRep9DHaGvYv+sg2o3xMmZjSbxd0NGDH2AW8KqCN80YUzv
	VJDuyEJ1DaqRxgOqB+p/1OaCzxk6k8qT6ApQiICXXvA2PHNIEvcTRi+WJD8bK7YUadOlfT
	8k0WcsQDauHGUrzvBdlmRdB+sskp1f4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MZQnwU0h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 94D7D4AC04;
	Thu, 16 Oct 2025 21:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F577C4CEFE;
	Thu, 16 Oct 2025 21:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760651263;
	bh=JpqRyISZ6HQ2mzWCEY5nbQa5reQxJ9kMpl3zJAQ2NZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZQnwU0hG4KqVdwBF+Mm4OdnOIU1ymk6yGpSBNIucrULJbtP+oSkhJ73HOt64U7aW
	 v6uTX0bPc4qLSb4vDTPbT+Pt+cwP/2r7kcGPvzRqxZwlcBMG6KZjrx+pGJ5/nenFgf
	 otrbPDRvx26SU3z4AhzsPsOfkyobHAd/WpzydRa5ndpTOoO/IUUAHWrIKCnQRwntKB
	 ayVSHLFjKugeVTI+9hG/ZELj6ja1ZcrS5gb016wSqjb7eisXhaTZaSYKxoQgcKjC34
	 ZAlVYYw10iFj2gy3TTv5oND+GQEJY2L1eSo1FeULh/Hee8FOwWkEaFMORk1afuDkX/
	 KJqjcEu9R+6zw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	bijan311@gmail.com,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/5] Docs/ABI/damon: document obsolete_target sysfs file
Date: Thu, 16 Oct 2025 14:47:32 -0700
Message-ID: <20251016214736.84286-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251016214736.84286-1-sj@kernel.org>
References: <20251016214736.84286-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 855E9140011
X-Rspamd-Server: rspam02
X-Stat-Signature: yhyfk4zcpx5j65x4x3ujxn8sa1o69gzh
X-HE-Tag: 1760651264-625652
X-HE-Meta: U2FsdGVkX1+k0ceAAhj9lKnLHqsbEi9rf74PUX7CTzP5ie+FSj0UR1C/Y3s4sAQf92p/l1Nc2t6f0HtflKkpaQv2FI7femuTQlBFsAqoBqK6wQjdOgBOUmPulrrVuBcoNmSyeFt0IzFD+fQg6QuBHF0J5otRiT+wlPzVbZTjMflt7ycat44LSuhsogr5OlTAo9NMupMVu2ch9HF8wrtNyb3LrCJcyAzOn52jU7KLPmLoBw1HcsXbBambjrVPql2wSE6HN+hMah1ZXtubtLecWIbfrbdEZRBgvD1O2879UoL134l0LgyxrWaRtGESZYt5AQ1aKZAG7WS1WbNpEehbJsTcxkhDCyRy+KGR00b4gPOL0IqDeqxfXLDgXBhM7Fh3WVDB7+pv4HeevtFIIUfO2obBGYiq8AUU2Z6iwZyCe78FG9aTebn5LTwahOWBEFb7x0ImP0ifBj5jc+WXvudSERNPRGuxrWRCvsUoNKV6hA2SUEab4dB+YDw7rCxVEZuNxw7WbCrHKX7i68neZIYv136aw1UM/KsH1JqGkHyldsq/PXVM+XTXFqc7N0wyUrNL18HgXeArqC9q+wEkUl6BuneN4DgNfCTvrhZ1i5dwAEUG24P4Yp4gLK1H8xcNL7WOw3k1ZFh9VyzLfBK3wJRmH+mWH4fjkL9/65f7r0AfnVCLjFbYu3qX/YmyUajLqqTwz4kr9n7H0qDgCYGoF3pmcPMPbtyuatdMwMvpc0QD/UV3RTTr7ev8pnbCCkMavGVaHxONAfypk57vaJupDXZkt61bIoRTBf6ZjXe4NaPVawdmIzHSBZiWzK7xHOfMaCnsvkwsAtdjS3ofBhwPjmhM6q604XbPa66zBdLUJqk4dY/q1C9w1+gDHE6z0KmRN6k+KZmJlCO5jcgI6wXpzVAR/Pukeex5psamp/dRZod7cD+oD4+h2BzMHo7WUNIabnmhMIIPOWNnjX0buteny/8
 SeNZC9ph
 jpztZFrrIv/X81079+loZKqZx744hpSqumlngAK8iK6dSW3kAnDqMD9cK853a/cqaNmLF6Jy6gyLrXD2+LoGadWcr1CFOmTXfO1W+55XFh9lG3hLNEPSP7bi9bc2HFo/BXtVR2mbF6VVS2flsgtEp6YFUe0F5VNvS1kmjU+9l3AK0O47xPlAXgjjHt6qQeYMuIn9iE+ge6Wj+pWLUjpI22OyndndnCofAckasfp9g6UaXnz8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added obsolete_target DAMON
sysfs file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index dce6c2cda4e8..4fb8b7a6d625 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -164,6 +164,13 @@ Description:	Writing to and reading from this file sets and gets the pid of
 		the target process if the context is for virtual address spaces
 		monitoring, respectively.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/obsolete_target
+Date:		Oct 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		obsoleteness of the matching parameters commit destination
+		target.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/<T>/regions/nr_regions
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

