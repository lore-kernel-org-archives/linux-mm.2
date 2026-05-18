Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC2CCD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:17:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89E166B0099; Mon, 18 May 2026 14:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8159F6B0095; Mon, 18 May 2026 14:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604606B0095; Mon, 18 May 2026 14:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3766B0093
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:17:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1009A140A3B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:17:49 +0000 (UTC)
X-FDA: 84781349058.04.4A92E14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0AFB818000C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:17:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CaSA7KfQ;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779128267;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UrDv/FQiXz/uFJVYSYQ22pWjI76TUNxfYh7vOKFwKJ4=;
	b=DffFVmlD4adB6B97xsVziylcLl1R58oLvXgxliof5/d7wyrQkIHg7yMIoXsMpeMV8s0vfU
	hEYdkLi1jCTpkdTa6oMIhkPcOlHp9ERxQf9N/wVR6MKoio9uzj202EYVtQiRNiDhvH0pzS
	bT1nEN0Tm1/ImObx2UrmxdHYSYEGtt8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CaSA7KfQ;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779128267; a=rsa-sha256;
	cv=none;
	b=wez9ru503X6uPOY1c+MHLfMeqMAwgCx4xvH2tuhK5uPWs+tVKC+UjZEA1o7GQwm5Gs7/I6
	37F/Ch89zQI8rDNbzCp9SxOvedrvvbsA8Q8c+wCiqoBtNff7tYzSMX1pBHrcrHQWvZnYRT
	IfyBz/3rRPcSDJZRzig218j+Bfik8MU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 013F34455E;
	Mon, 18 May 2026 18:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6913C2BCFF;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779128265;
	bh=4CO55womEnBoPWCctzW+OpQftEjr2hhkfmJD62dJN44=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CaSA7KfQVyQtRv+yyn5br6OHX/yPIzATzUCHi1Eb/EZspFaXkpKymTJOMyR8d9M3b
	 jR+P8fhRKGpBlxdTRzAdg+IHe0u6ScPeT1mj2WJU8i29ZZTnbHeJJGAdF1mktLD9V5
	 Xy1fM0l2ZxnhJ3zkJZBdeMOSXTScHIuWNo7zZlDQTjwfS00oIxOlu+QoItCMmYUK4o
	 kBzoL18v7OEwvqn9n8gUma7GhpA9cYchtQQZfeH1wlAvA2aPq818oZvFlK7HGEwJZ5
	 xyya+ZVcgYi2qH8i0YUH0i1mEBpe1jbyV0Ce0d9FJXB+E7l3iHdK9Bin2/Kn75I2c2
	 93SbdK1aEZ1HA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE3DCD4F4A;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 18 May 2026 11:17:37 -0700
Subject: [PATCH RFC 5/5] mm: selftests: Port readback test logic from
 libhugetlbfs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260518-port-hugetlb-selftests-v1-5-d64ba3a785fe@google.com>
References: <20260518-port-hugetlb-selftests-v1-0-d64ba3a785fe@google.com>
In-Reply-To: <20260518-port-hugetlb-selftests-v1-0-d64ba3a785fe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 muchun.song@linux.dev, osalvador@suse.de
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779128265; l=1602;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=89off7URPXKpNOqQZuCiXrCqLPNnXfaicuty8kmghyM=;
 b=2EmdrC/gCQ3MioA72AfovP0JnhYZTfmTmBwAMfNu2EP7oCwZxCKgxIPZaCXufUhQE+ZEiaPpM
 EdlNF/U6uRBBLfpGgRNE33I/AxPAC835iYY/3i4b0CTZgeAgV36UEn3
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: k7wp7gd954aeqks6qm7sz48wgaqtk4m3
X-Rspamd-Queue-Id: 0AFB818000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779128266-890541
X-HE-Meta: U2FsdGVkX1+sZNBb3Ri7TrNslJwrxcuCDmnOyDAnSyTXpEaOH6F2ExXHePdCVap4ZRDrHbtsg5dBVUGiYzdydsr6S/eTobCkpo7QD3s9gxd8TK7B8RcuebljOmAyCRHOPpLyJttf1kJ7y5pb31WMKWOGTNLYFQg3hvvJ56ytb3st7jzgE6OFepyS/+JM488KDLqOML0fs8kQj9fTSOLGiQNL1Wz5pCSJzEezY3/oqECUJWN/XiJIFq0OFZqx8RLbIZCglT5NPs2WOSIvGg971X0d1ttM5t5Xwh62aDPVjWjSOnxlkwPwleRfC41KaLOqnjaQvTVyZD1tL50uSEi+DmTwsFszl4S6/za1yn3koT/AFVi8o/19v4w0UyIapWbvyVOsY38y2HiYpLxtDJE1r9jFaNiGKK8y3FkFVr7wQKKgabJfmwGKUXil4TUHjx5t31Ya6A+hVkkFXqosRYdbHwyRcqRBPMoCi9oGEmRn4PfoSvGkasz/oALituDI3oyiY1i/gJL6a6MK/ZpHKm0xISNCxlPPZCGBX9dTADCiXFAE2hOrcsA1d2ycVWRS8YHHohCPZ+4+B2IyNVZ/kcUXTf0mb1kOEMMW9rJBkRDwAkb8XHXz6Nab3FpbMaw2PQkORYdp7CdWkrfHRYx0zVCsTiUBZkawC8xM1x/1/WNKiZ4nKQuK927JDKxploc/IU/JXDb6rzre38sbHUytJH1/5/bD3fWq5HpMxLKTYM3HxTlmduZH9gdCaCmBKsu8vdFavctChtqQprmzWj2tobvQ5jvZT5RzJcFBJeRXk2SyLgk+GlZhMMy/C8bYwbeXQOfLhwYetvJ/fL+3lxLFAqaiAs3O405KbAiyqdlHiO4G4QUa7K+uMaFHpD98J8/laOYdAo7rlKHeE4PsLb9InhYgf3VnFIK6uqejOg+J7AnMgL9QOdrvy5DtU75gh/hyo330SujFydtclN8qVfewlqE
 s+JyVOSY
 jysfvbwgxlQJAuWNt7ndwZL5Z+uQLQP18dAa88TngpNMwyJr2fMztv6pFB0ptIPXKo9IcSamU0YvXsKkTbwUqn7Gzk/GRDF3JFBH0Pt97KeXobMYgJo5OdVPLjrwLG9KqrrsYXcXpOhrjzyycgcmUK/w9p3UqrHWy7UFHJAevODX/TQSw5Si5trMCYvPzMbDauuioqRiIByaSRhGiWnoqsQpUAM4bxOihBB3QLUn1pGojjvteXyVeb6R1szvqE41vk8WVREh+9BQIma5rpX06+jNhxiq1GzkJ9/8I2UEnIWI2Bx66W4MXYHJqv+12HfiQpRJZ8gOxW+o1mMISOko2Dgj5bqT/dJlNhwaqj2C/Mpt7zjVGBjDc2SPkjg5XZYDdsBiD99XgLu/tQXgxryVwfGNV2nsSVEiPtpE3wsDVLzDPR3f+tkyUIazGF1FlpMuXv+RFPpeiNzePCQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Port verification logic from libhugetlbfs' tests/readback.c.

Iterate using an unsigned int pointer instead of a char pointer, which
enables testing against a greater range of stored values beyond [0, 255].

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/mm/hugepage-mmap.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugepage-mmap.c
index dd9fccb209b10..a7d4a3eba3dd7 100644
--- a/tools/testing/selftests/mm/hugepage-mmap.c
+++ b/tools/testing/selftests/mm/hugepage-mmap.c
@@ -45,7 +45,7 @@ enum fd_kind {
 FIXTURE(hugepage_mmap)
 {
 	int fd;
-	char *addr;
+	unsigned int *addr;
 	char mount_dir[PATH_MAX];
 };
 
@@ -122,19 +122,21 @@ FIXTURE_TEARDOWN(hugepage_mmap)
 	}
 }
 
+#define RANDOM_CONSTANT 0x1234ABCD
+
 TEST_F(hugepage_mmap, read_write)
 {
 	unsigned long i;
 
-	TH_LOG("First hex is %x", *((unsigned int *)self->addr));
+	TH_LOG("First hex is %x", *self->addr);
 
-	for (i = 0; i < LENGTH; i++)
-		self->addr[i] = (char)i;
+	for (i = 0; i < LENGTH / sizeof(*self->addr); i++)
+		self->addr[i] = RANDOM_CONSTANT ^ i;
 
-	TH_LOG("First hex is %x", *((unsigned int *)self->addr));
+	TH_LOG("First hex is %x", *self->addr);
 
-	for (i = 0; i < LENGTH; i++) {
-		ASSERT_EQ(self->addr[i], (char)i) {
+	for (i = 0; i < LENGTH / sizeof(*self->addr); i++) {
+		ASSERT_EQ(self->addr[i], RANDOM_CONSTANT ^ i) {
 			TH_LOG("Error: Mismatch at %lu\n", i);
 		};
 	}

-- 
2.54.0.563.g4f69b47b94-goog



