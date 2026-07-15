Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93695C4450E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0736B00BB; Wed, 15 Jul 2026 14:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C85D6B00BC; Wed, 15 Jul 2026 14:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B77E6B00BD; Wed, 15 Jul 2026 14:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D27B06B00BB
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:16:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 630B514028A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:35 +0000 (UTC)
X-FDA: 84991816350.01.EA97A77
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8880FC0004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DadA3J5U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784139393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IcjMhwypTXX14WXh1GVYxiUX1ayGU/csb6g5Y2UiV8=;
	b=5P5iCsivUeVJhOkpoN6+rfcP085js2O7Kl99LimAEubqw0a2oztzOlHOwFIK/l2kc/FPE4
	OUM7n15HX3kAjEfeUdTCQejhjB/6LEdQnSClVhH0e1ek+zShG8R0HJpSv+SSHRwoi29C55
	fR/nCqOzdZRZCu/FuEe8Xb3/4eAgTv8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DadA3J5U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784139393;
	b=t8ICTzmiuYWMGUhI6txZ08KGasGAr7LOT5Yc3zZEhd2CnLNlp8pAKR6ggrvWIyLL7NqaW0
	oT8yRPPLZMZVEgmYqYMq/Txt/8AhpBjT7uKmgz4RsBTdoUDqAxUrmYzUshfqOjYM06k4xl
	wFOygbUIfovRe6iIcOHYnSVWsgW/PrI=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c7c61b5292so34908895ad.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784139392; x=1784744192; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=4IcjMhwypTXX14WXh1GVYxiUX1ayGU/csb6g5Y2UiV8=;
        b=DadA3J5UnXbbkWLU/+UiiWHQD9BOvsjPbYCsdLl/1vKya/BUC4IQMTO11EMYNcoF7U
         PEpJIO/KtrfmcoJ/FkVz3PQA7uKHQeUvhm3Jo+geMqEkSPaLmJU42+oXkcAp8pREcy6V
         5pkDBiv4Kg8Ttgj8zggaqsDbk5kDGS111lMveEPjI8wjdDV1cFPw2812mtxVVIHWajAG
         81ZFSMvgqH8NgW/APmFSxoZqznZlC30neiVkBIGEV1DOEAzyOQv+x682vDQxTk3gWEET
         vKHslRHsMKo7lcLAcSR3l+u4O4w5/T4uLsEeuJAjTAT8udCGwBYMZU+OiDkRrX7JD1V9
         KqhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784139392; x=1784744192;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4IcjMhwypTXX14WXh1GVYxiUX1ayGU/csb6g5Y2UiV8=;
        b=IhugQfQhgUteWtI9n/lunghJ/3Rlhub1YjQYugPdLaaOQdZt/QQIJHsz3Dyv12d3gd
         1XFvy24VbhzWVpIrzr1z4SzaIfRcJIsEnb1ufuXho4wwhKzifR0JBE5WGFpBL1UBSE5q
         yRure00z2MXKB7R3YEHLvMt9TzI8dPcDnP01Z4yvOz2fsCA5wXI+DQhhmlmjY1rZg8sf
         Y18qatC0JGruM9xR8N7Ku/A2ZT2EUWfDp3Ku3eGGM9FU5INLz/4Rz+kDHjdv23Ot0j/M
         dUa7GZpegvw/nrexedsOzD/RbB0uEOBs1ghXPhi72QGpEGaHTlX9djh9M+m8/3zkfBkP
         sQug==
X-Forwarded-Encrypted: i=1; AHgh+Rr79D5pJH31SfdL4oi65gp81MvNEorTj/QqXE5svZE/sT09UmNrP62q4aydkOD3pxm/ZMS+jaqEzQ==@kvack.org
X-Gm-Message-State: AOJu0YxvW8FQOG1w7sxCSvuicz92RZEAFH9fzx5mdiH3Bb/TsXeSNAKZ
	nJTTCzUujvHW+yJ6omEfEm3OQhKGSOrSb+TvU7FMaEJqXhkHthNAT+z7
X-Gm-Gg: AfdE7cmrU6gpWDSImBn/H1jCbVeeuwIK7xYQzkomLiH4CW0cGCJKOW9RMaoDHkBIpaE
	U9hYU1P/rm3TiVEIBMGJQ9USuzfXJE5hWgFi0KeSrdxz59vWJg8jMH7wEfCPf9ww3v3h0sesv15
	4DfGGW0Q8x2drhC+4pF3TwB4CZKuXqiQraV3O/92hDGdp6H98/bjRG4JY7aLdEM5m4CN0H300KF
	nD+8DRxEV2calAST+EuEdCYo4WdhdvX0XI+5NJb2ScSSaerjYSTr2nzrb7Vu/eqzOR4lQgby2Up
	Znev+2ay778IpxumGab6kvA9IBcmbKQnOpKJfrGgiXzDvNE6Bm6GI97yZ1pUQ39ecDlc3q5/Psy
	q5zxhDQUShFdW1Rw1VXUgCRQcaS1G4sILjlFfZfcKY8QowH8HJGCkp12vUV3u/JuU1H+EZhwwUl
	A+BSeEEdK/miX4aMGOAXhtZvyd8qspMzg2/COXnX6pvriNrJ+Ke8zW+uCICWs=
X-Received: by 2002:a17:902:f645:b0:2c9:fc14:588f with SMTP id d9443c01a7336-2ce9ec0f95fmr181359435ad.29.1784139392357;
        Wed, 15 Jul 2026 11:16:32 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf100e3946sm6817295ad.4.2026.07.15.11.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:16:31 -0700 (PDT)
Subject: [PATCH v9 5/8] drm/nouveau: Use hmm_range_fault_unlocked_timeout()
 for SVM faults
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org, wei.liu@kernel.org,
 skinsburskii@gmail.com
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Wed, 15 Jul 2026 11:16:30 -0700
Message-ID: <178413939024.1155966.6246787744253724390.stgit@skinsburskii>
In-Reply-To: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8880FC0004
X-Stat-Signature: m6gft9tmeirni88ridtx8ixiww4rmrpb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784139393-982857
X-HE-Meta: U2FsdGVkX19uLIdXLi8FTTQo4rF7OirvieiW9ehWa89fmIFzsjeV3UYbZ+a/GR1Uin57djlFdNRDypszZpKOp4UoUhZvJm6TemXhD5CE26eJEIKJbekEsR8UrwXLgUSnyZ7vGgSiP+/9QXIFmZKH3u7hcg1zY527Og7sAzU6l2BMpCUkq4zaJqXcDdX92juii7yUkezpGBbxvuFtNwczwok9mECXvVGOmeQAuS+wGPKI5/ofPss5X1HQqsatN9o5Yvkhf8wW/gvvjAR74LxjJZYayN6E9ncuzZUDIV/K6pn3EsGrxM1GRgQ73jpIlzRFRYA/B5fendcczUPVIiyH44cnBe/yf2kQ0lC4VSEtx5kmxiR9ujzDTNoztkkMbsPRtG2SVbcTULtM3WkihJWw76T8KzSQFQ9OPPvME0iDZcOPzz7/XqjhdGhAkUap4iMOID1LgxP0ofATNviK9NvVF9TAJOo29ububPi0hpcrlCU/JOBxCdcvXhQ3/rXVXzILZepYg/6dMUpcWNgC6bRpcxxPELYQ4zPj075dP1z8vaJ5oebiZu1OWuP8VNUvLg1S3D34F3fP20sMAFtFd/mgWdm2zWw/B2X7VjakZ2EqB5pOIvTIRxv/nAMtiipUbNUaUMoEFQFfN6+8istwByi0g0MKBAlPfTmh0wgurnMlbsmYwS+AMBEfCcDCFnNIv0zdU+J58fPzQv6cXXXaHo0qx7QtHFn297YRpDRk6lOl0mitj6I7ogtOBmWVhc1mFrSvlKv2EeAhxcPBV2u2lwHIdHVs1Zm4R49gybbJ92lUeJGuqrCEp9qlrcQDuXBUe+P+OJDq9UIMdVSUBfQKEIl6mGTIlKAuCUVWtQkk2IGHJpm4BUyyAULuk0h29oP1vxGAkG4BsUw7RMLbLcKQK3E9FuKPv5gW2ULdkVjPm+BLBgkd/ARa4crCC+raZ/4u+DHyCZlssTFOJa6wPQBCW41
 +jsHOHHP
 A7FXcANu27WOEWPeou0q5Oen59P1kfjMhyOWzGlzJCyeJtPFST/H6wzTZw4ok6V9SLwutUcya+0ToZ8q7fWAsvsFStcngD5hxv/kWQC/VEJf0bqPy6B8hK2zWQnwVETiQHyVr84b89FhSuQs9PLSoRSJExen0hgHVsbqCAHpEqm46ILujuPUvqBCsFOmaTvFsLzKrcqMAG3IjZg0iYdXL4iisxilCNcwezYwAj05JRwPKpyFRaJ2k4Qc3AptXVOfjBQhwkf7xfgNdDJZryC8PwBH3/RGkUdtWdmJLaZTw5IME1WijVNbMopqZR2s3r6VwMut8IvFA7Fv0ZQC9BOUG4g5x69mKdPMok+H8OfRGFXPddDHCbgy0FOK0ylpuLSGMjY//otEKJnueWH2Sz6fCmizuReDKy2Bb7svQcjKtYZJkV9JD9w8LEy3pTB8CRg48orPlmWpk6P3rgeFy3XKjEKG8gPWaVSyoVe8BtWMtZquhZWWI4kl2OHBSVmj+oJUyUNtW7BzXpZjhwJz7gaYoBtKXIr2+TcDCuvE1zCh8An/yzTccJ357dpdYAoi2N7dqJ74LLHWkMzBXRlw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nouveau_range_fault() takes mmap_read_lock() only to call
hmm_range_fault(). It also keeps a single HMM_RANGE_DEFAULT_TIMEOUT
deadline across both HMM -EBUSY retries and post-fault
mmu_interval_read_retry() retries.

Use hmm_range_fault_unlocked_timeout() instead. The HMM helper now owns
the mmap lock and refreshes range->notifier_seq for its internal retries.
Nouveau keeps its existing absolute deadline in the outer loop and passes
the remaining jiffies to the helper for each fault attempt, so retries
caused by mmu_interval_read_retry() do not reset the overall retry budget.

Nouveau still validates the interval notifier sequence while holding
svmm->mutex before programming the GPU mapping.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index dcc92131488e..58735446d783 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -678,20 +678,22 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 	range.end = notifier->notifier.interval_tree.last + 1;
 
 	while (true) {
-		if (time_after(jiffies, timeout)) {
+		long remaining = timeout - jiffies;
+
+		/*
+		 * The HMM timeout only bounds retries while HMM is walking and
+		 * faulting the range. This fault is handled by a kernel worker,
+		 * so fatal signals from the faulting process cannot stop an
+		 * endless stream of invalidations here.
+		 */
+		if (time_after_eq(jiffies, timeout)) {
 			ret = -EBUSY;
 			goto out;
 		}
 
-		range.notifier_seq = mmu_interval_read_begin(range.notifier);
-		mmap_read_lock(mm);
-		ret = hmm_range_fault(&range);
-		mmap_read_unlock(mm);
-		if (ret) {
-			if (ret == -EBUSY)
-				continue;
+		ret = hmm_range_fault_unlocked_timeout(&range, remaining);
+		if (ret)
 			goto out;
-		}
 
 		mutex_lock(&svmm->mutex);
 		if (mmu_interval_read_retry(range.notifier,



