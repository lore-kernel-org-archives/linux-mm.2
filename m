Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BE2EC624A6
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF9A6B0093; Sun, 22 Feb 2026 03:49:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4296B0095; Sun, 22 Feb 2026 03:49:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AEB56B0096; Sun, 22 Feb 2026 03:49:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56FDC6B0093
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0AC3616054A
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:17 +0000 (UTC)
X-FDA: 84471468354.16.25338B6
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3ED8C4000D
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jpWRzsfG;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AivjDh5huKNjDD2xsREV6Gpi4uqBqXwxpevrEGioofI=;
	b=k0unZUDkC3aseuR0c4+wjXrZOu1lT/mjgnv6s43sGxG38xns6lnuwnERfvkMahcBnHfzRi
	SR1/nJa1WwAJPHGG1k/BW7e4NCbhtEJjJAxd+LIFfHvF0ECRlos4Eud0wW4balw1p2w8cS
	8Av5UHpSfaJfR5oYDzUe45cDd1gMFpY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jpWRzsfG;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750154; a=rsa-sha256;
	cv=none;
	b=4nSsdLsHGnClpJolNuxwObLQrX6MqzrNiYeI4sURjhSI9k5U4Xn6f45FTEL6dLc1TS2Mzd
	3mMKzJDCVgyQ0xxfB8z5w9YbIVSywoMVhRqia0IFbF4odBC5Ex5XlbaPlGoJGn9Yx6MB9Y
	YWaX4FJimRh00RTgxiZiuAH1KCCQ+zY=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5069ad750b7so30020671cf.2
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750153; x=1772354953; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AivjDh5huKNjDD2xsREV6Gpi4uqBqXwxpevrEGioofI=;
        b=jpWRzsfGoW8buEhYdrB5e+5fkyJ7/LaOHRHFNTRDCnTKxNqBiKE8OFVUfvPswCVUAJ
         aXZ4y/ZCLN5shapXz/iEriFzOmwI09XWJryY9kp0R2err++r+YvUUynLAaGD4Y1STjDr
         gVp5V0TJq7lBqOH1I4tVeD71swkb8T2lIo7c2U8R9MF5FGDwbB0Qecw7C18lZinRGCA+
         10Vws1iThuPvtfVYyvOzXuKlGpPNoPyGdpVgAnaRIuraKMvjP3SaT8l0po7hw9LiUsKk
         Rymzpl+TDwdptscXy2hetbfRMjtlC6niKsdD4JXHwrZOR0bFp0hdiopghwoV8q1t0867
         LGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750153; x=1772354953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AivjDh5huKNjDD2xsREV6Gpi4uqBqXwxpevrEGioofI=;
        b=YJgHCEOLFAOn0XOjGp/GlsuINF4KuOkfSlO5AOm0CETftcfLmY4N82+BH35JMA+IzY
         S9Mwng6X9RFvv8OYTLlDCaynaOfez3o2q3sOhcaoVXus0A+IuB5U/OBdgyvFDwS6rUJS
         9jI4fj+OCR+oPzGPMIihkFLP5KyOj9Ymgym2sjZHWXWUV6vCi86wZR19lI6ka/u+Ah+p
         WwHxylaCKZmHwCg1dIv7a9Hvl3u+RUn1DbjuZj6TNSEbY4mjnQmuaMW523TAOpf8+O8t
         XyxsJr+bUWxpMwjU1SAU1eLbOJg86iMsssMg1HItBuqhEPmaWdKKi90E+JKejD8eUdyO
         0uYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSDLeUlPT7nUw5zPYmg66kHPKYe9lyGJ+SKQ1WVpxs5OfQNvQlNPubfWiSq75r7lfs6Ijh5wOz4w==@kvack.org
X-Gm-Message-State: AOJu0YwNP7iN4W3cgY3PGPoRwmoFsmlGlDfmpqj4xFl3CgLTaSlJ89OG
	63zR+SiKQ4avZa2/vWZ6IN9nhmvlZkQQKJoTg635EukDoZbOr2B3LTy9Fb0WemBfVRg=
X-Gm-Gg: AZuq6aLeSizYLEMZh4XgwUZ/ZRyjsrIe7q+ru9D4ur5DKQcOiE07ErfFWfcvhrFg040
	UMhky5T4hlcHawtFtau+ynmSbVzZQBXayWvBWg6iOZqPjHiQb1MlByZNDVNx6hWZ7paUomTapgK
	ij811AF/+GOMFWfObLHWjNYRn64CQDzBLp/BTPVuJ//Gib1orq2uB3OK8uOHPpsfPkmfbCgL4tY
	K+iy5uCEXEaUlrl6+MLLBMcqZDC/V2B77y/47Mb562Pikg+nj8+iGbHM4+TDKXq/AcjEEZ/OS0/
	iyiB8j2YuAZBSHdmqppGnlsexxZAFvB02K71n59GFMAPKunAtZAzijCCHJtPiTXul4wi/lmDe9e
	ykheu7TU/72r+K2u9igUQ5Yx3zlkTLiFOt4t+Biezgai2amsYdvWYPUxZmLqOPGHpEHYxPW4rRA
	ORUPEKeNKh6Tk1zQq8NZyR9QtMz2ZEb5FxV3VZp6K5XazxsSaJu7DN5gWc/UbJOw+FfDNXauJ9P
	3db2l8qwWTVpdIp6nnJVai3Tw==
X-Received: by 2002:ac8:5d0e:0:b0:501:4f3d:1469 with SMTP id d75a77b69052e-5070bca9b16mr59670661cf.52.1771750153314;
        Sun, 22 Feb 2026 00:49:13 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:12 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 05/27] mm: introduce folio_is_private_managed() unified predicate
Date: Sun, 22 Feb 2026 03:48:20 -0500
Message-ID: <20260222084842.1824063-6-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 3ED8C4000D
X-Stat-Signature: zfdjghmmsao5foier5gof6z4ngfopd77
X-HE-Tag: 1771750154-399335
X-HE-Meta: U2FsdGVkX1+sd0vM9B73UaYU8jJc56smiRbB9gmNq8nf6AufXc0XYriQBI/xryGrBWteCyT0z1n+hw5jat6zpu3CkeG81OFSQBFTvSZ1VjyVLK5W+0MTzdw+CHazvOn+jBlJYmiwZLp3/gpla0swZ1xjQsc5b0DIUQZY1rL8zRYxz7I5pfRu34bdvqMN9S1akQLzIcHBexWtuTfneydLU0f8ZLy1McJgyGWK6s6Q2fRRENgDuNArm2rR85SrGIXoRmoptQ0uH0Cfuyshk6xg0dqgQUdev9AWFHWZzJ5PtqqjZS83PnmZhFMBaqqy2UM9+s+BdAojU4xg4ZshCQxZ+xw/h36QvPAMnrpq3PpaBjO0qDtzwk4QVhP4ZTF6BXnPZyMFUEcmVv9ZpqzwKmMPH6bkuJbSIjg4PzMldL/b8cWPWwU4PHMhhi6jRfYc7KdZ0ay1c3jcBZHCFk/dJootqmXc8+m0K+O4n78TFhMP83ApEoV8y7Fr8Jo3f4NxieNeJcq1BrtqlISAf/5FSLoU2iWYDSTftbIkJxixlao1Z0aCfOPlce+bBf0QAE1CB/Q51rcXy6o5F2qhtl/+tAk8XOuFjFyxnrBOnEaxYJzJGqv2EiOuAgRpbv/y5CLXX2vLRUZlyBzUpND5KhFyLE5D+SxuojSfF6J+5vwEA0CAqZrBKO2PpFndQLXiRhI9VcWPmi3PoAg+gHZsYTcYz2mtiQGXV33OWhE9pxgsnH8PmZ2O0MsP/tfLGOSdsLufKQf6tPKr+5CLAtcNmT3g9/8zuhON5vm01hbb6UEDtESyEQSTVyUZV/xswZTbUMEdbAt2FrjZ0xWps7901r2PvQeq4ZwzEPtK52XGGiWVPgIqaXvo2mkBL1LpML2Rl9uGbaaoKFvJ2ey+WSEVPf2YYJgOSCEucmtkE47iy/DtPOuWZGUJ/Ffj5JCnCVUBHzEtxt3oLCK0fiOvNDjfmESL61i
 eufQDy1u
 /Rxg5X6bJ8ouTPTdbAORCDl3Y2NIGMdETlXW/zWZIO07aFmRt/nrl9SiwESUO0pZDHA/SWlvhYTopgevF0rCi01FX87uZqmPr/Oa32Srq5WmNBhmSXNf1PLy31iknYOnb4Px5M6h8QKZKzLr0l9a3iKHA1/FNvGIjmY3TPXaBE8t31wBtHhnbBuPNlyce6Bn6F2EZAdu9h6lhobWByCu30omhy7fZylMGv3znfbRsNq/oPMlMtMOx38CSNqrLhhRUDUOsKdYLp9wZM2lB+KF2FLE4zQn0MyRw2WomBj0dBD7QY1U6frTTXQjApq5SI8c3Rs6nGbGptuyqhu5Bw4D1s7cwQk8CehpYZp4zHZmEmBqIBH7Hsqb71EG8lQmfiChF/qIo5jy7ZXIpfT7Kq8x1uu5fmTejIwnU8rjui2mFhtWW+5g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Multiple mm/ subsystems already skip operations for ZONE_DEVICE folios,
and N_MEMORY_PRIVATE folios share the checkpoints for ZONE_DEVICE pages.

Add folio_is_private_managed() as a unified predicate that returns true
for folios on N_MEMORY_PRIVATE nodes or in ZONE_DEVICE.

This predicate replaces folio_is_zone_device at skip sites where both
folio types should be excluded from an MM operation.

At some locations, explicit zone_device vs private_node checks are more
appropriate when the operations between the two fundamentally differ.

The !CONFIG_NUMA stubs fall through to folio_is_zone_device() only,
preserving existing behavior when NUMA is disabled.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/node_private.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 6a70ec39d569..7687a4cf990c 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -92,6 +92,16 @@ static inline bool page_is_private_node(struct page *page)
 	return node_state(page_to_nid(page), N_MEMORY_PRIVATE);
 }
 
+static inline bool folio_is_private_managed(struct folio *folio)
+{
+	return folio_is_zone_device(folio) || folio_is_private_node(folio);
+}
+
+static inline bool page_is_private_managed(struct page *page)
+{
+	return folio_is_private_managed(page_folio(page));
+}
+
 static inline const struct node_private_ops *
 folio_node_private_ops(struct folio *folio)
 {
@@ -146,6 +156,16 @@ static inline bool page_is_private_node(struct page *page)
 	return false;
 }
 
+static inline bool folio_is_private_managed(struct folio *folio)
+{
+	return folio_is_zone_device(folio);
+}
+
+static inline bool page_is_private_managed(struct page *page)
+{
+	return folio_is_private_managed(page_folio(page));
+}
+
 static inline const struct node_private_ops *
 folio_node_private_ops(struct folio *folio)
 {
-- 
2.53.0


