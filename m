Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52853D3EE74
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 15:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21D436B0213; Thu, 22 Jan 2026 10:19:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7A16B0248; Thu, 22 Jan 2026 10:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDA1B6B0249; Thu, 22 Jan 2026 10:19:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D19A26B0213
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:19:05 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B2531A040E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:19:05 +0000 (UTC)
X-FDA: 84359957850.24.13B1666
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E8B7E1C0007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:19:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F27+4tl9;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769095144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VB+p4X/6O7lyQXyxXdNT3yH+siBd2aPoaQGnE6TKcZ8=;
	b=tHHr1rwAXd63xOuIruwWD/Oc4i2NTj+or/Icd7H1tmyqHiy/mQ8UFp9g/urFAVGYXTUDD+
	BhbgAuTi2TA+Q/OMVP0VxtVkIkVUIBMUfr4MN2Sk7N1G26iXECL63HJjboeMkFlfWSXgp/
	b1Hh5XLlv+jPcYKw6yT5DQE7c7ccZdE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769095144; a=rsa-sha256;
	cv=none;
	b=YkXXrmhMc5fQKUYAmvX40Ub301wJ5zgHRwqnDPev2bsXd/MiSZXDl+55acTpw6oCKhHQ0F
	HJZX9cXG/Zm97m1Wv/OtMO2omH9DFVOW13DhlLMKmrZtkRE301s0jxoPcs6nn/5pGHKNAO
	pNRYTKLQx6QXt5XQOolFeMNZIga7dN8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F27+4tl9;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 292044422E;
	Thu, 22 Jan 2026 15:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96069C116C6;
	Thu, 22 Jan 2026 15:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769095143;
	bh=Nt47UFsOfhU+/Sa/WsYZT61v6HKZPeC+3cKH72ng46Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F27+4tl9g5ai8OC/CPoK5ZI5qEZbkL/ZYyabatTcmWCRlJZ+qSU5GhSWXfbluvDRt
	 BtQ+mSG8+NomVY0I+YeTgZzKOwsCH3AGiYmurkdawxOpWRfxqBSEZQJFMQ4yXLWcAA
	 f8ZdIs2pxZB3n6LL5N8Z4sRLXFpYdb0aMJMIDLVAUuyWorLkLC46xxtiOaE+WCK4VG
	 vmFsGllHJ3JKNKcCksAYjlTOPftjQ14TqnI4z7BTYC8B1SW4ffjXFAMEpvezN0OxEs
	 uuDfpz/yOOnqxVWefmXGAyMjoIOKjzFSKmLG31gmByZ+njmcOPWOS2ogmYq0gQGWFP
	 MQmcyahrNeGvA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mm: memfd_luo: restore and free memfd_luo_ser on failure
Date: Thu, 22 Jan 2026 16:18:41 +0100
Message-ID: <20260122151842.4069702-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260122151842.4069702-1-pratyush@kernel.org>
References: <20260122151842.4069702-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E8B7E1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: nscikaae1569qrer5ekaa8uzf81s1rwr
X-HE-Tag: 1769095143-20234
X-HE-Meta: U2FsdGVkX1+6kf5q2NwJsRMR3d7EY6c7Xk7Bagt7xvXWXUo2wADHNlGvhgffVdIxUSpGcYD3SAiTBW0Iq9sOUIaPdEkj4hYMwiUTIMbl3GAztApUyazqskIYOuhCRokOGyBf7BYHxwarO+LnJhD0OY3/JYNl4PIbt5CZ2SpumSCvEAWcN7+NarFAROEo4bFpLrmXElFt7AHAwNWxFzEbzRgEQLOxBhffjzUJgYJX9bknZAG+HQkWkLrj+QvSriiOKPyONDM2OmL4OP7fTBbHXI3KvkdNfzx1z4wVJAy/peDupfnHHUh3mZF2h/avYSBIkmpy/GQDabaR334ynlrJuAoGS4bvO23pliP1M0k0HkiRqYU9vlFyVkkp0NQspuBXejtaVKx9EifhAFS98Sf606SOGF/iYTYboeWrBuWyJb0ST3DGggCVUBCi7Or+v6hV+D0wXlrtVvMxDSpaD8Z/tcsBM7sViTx04TSu23gGzJHYyNH0fK0bGcOAogyrR1u4+dvaqPNkULoh6rYGet+wtCTRbg4Sk8iWGK7C79sG7Rx5Rugq1q8JX+fi2d8srHBUXXtEmqT2/gobpE+kLUOI+yPVY0MqdIHcghF2v6whUUD5vfjujrEOYOe+bklv6pXm3811PBUDOYpKHIl6alqqYsBCzK1V/H9csajm4UoAiW6k2DSj5ROFm2jK5BXIvgfQukSuCnsdYfAvuxGRLak46TRCXjp/crb2U89Br1RW+iT9hcTNuuwPxqMbktbsmqtPDkPEeHdiupaEetKeILt2Wg5EF2n6L4Dsi6DcvVpC5EqDJGJ1oc7XbukKFMqQJY/r4tuzsne6DgWIPeQYvX5wz64eAHqnbGT/f1/sfxrKzpBXsJs6bZQKsP3t3IAjko3vZatZA9h6RnKjZ8UFNWodXgHZP+mAUihAj5LAh0RgytN0qPKV2JoIj5b61p6TtqGJLrY8JLpO9wXeCPsKDpW
 1CFc6Cmi
 P4FYNON3c7xmQkC0UEo9ZyC8oFHF1jmqpbLdQ3NnycApa+izPHmf8HDeQeSnynyNZT7x2tNLXWWJM3hQYGMsahu6dMxXTSN4m5zNsEQsTt8kuFwpfzIlYakw2Q/VN4Tdn5dHcjvHM8pDOW/D8oiI+jzts3g2XpGBoBXceHHZjnO4wu1rEeY/Jn2cS4HpXM8uznlu+4zzuA4SdBNRH4LrtHi1qYDJNZhwvRyNUGLufc7Y66ZaeSFJZU+91qX1sfhodl8CZvc3cRKZvQqiij6ZvkmkU2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

memfd_luo_ser has the serialization metadata. It is of no use once
restoration fails. Free it on failure.

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/memfd_luo.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 01a72e4d3ef6..a34fccc23b6a 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -447,7 +447,8 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	file = memfd_alloc_file("", 0);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
-		return PTR_ERR(file);
+		err = PTR_ERR(file);
+		goto free_ser;
 	}
 
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
@@ -473,7 +474,8 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 
 put_file:
 	fput(file);
-
+free_ser:
+	kho_restore_free(ser);
 	return err;
 }
 
-- 
2.52.0.457.g6b5491de43-goog


