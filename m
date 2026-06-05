Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D95DCD6E7E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 21:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15F06B008C; Fri,  5 Jun 2026 17:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDFA6B0092; Fri,  5 Jun 2026 17:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A276B0093; Fri,  5 Jun 2026 17:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98A796B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:19:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E3D28D0B8
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:21 +0000 (UTC)
X-FDA: 84847124922.22.A7B1374
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 70E111A0009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SdJYrZSQ;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780694359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oucyR6ExWtK/Mt3ZHMUJ1XBxl0rtHFiWxfVOhnoVW3U=;
	b=bK5Gu5HXaU5obtB0866ilLazsqLjlpQdcNUtMsLDQPasVWQcG4xCXGPIuVd1rIMJIWuFhN
	6CRCg8Jf666QOzk3Ab5zOI+XIS2bdIo5VPWaq6rTSq1Z0a35vPUF7z902w/ARfFij6Bb7h
	1T9YjtfUhwTipXOL/3Y6eVt3lR/hiz4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SdJYrZSQ;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780694359;
	b=MHd/iN8cW7yT1GPtufuQTILmaMvtAJ62LDLyh4ipSLcZBkJDMg255wcFJhnUDpMf00F0YM
	qJIMGeSH4kSMQpRupwhvNTkvPWuTLoMSrM9RDb/ZS4TMfCK72WbkyCN/VFeAeYxUrlpPuz
	3B6H6ZQ6muyj7Xpiq8fWOUKqxPOiaHc=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8ccdf8d4ac5so26222466d6.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 14:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694358; x=1781299158; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oucyR6ExWtK/Mt3ZHMUJ1XBxl0rtHFiWxfVOhnoVW3U=;
        b=SdJYrZSQG6p/GktvDn7mdPQhRotXKkGhgbldvvyD7p5ymIrkLID8FPVjxqDb5JDjhJ
         /MdssCus0djFLMF0hmjmoja88dQUDR9g/mRTb+9JxlRFJppHQp4kvrhBFsgwwVdNZh80
         NRbnFXKkpmFJ0N1xfOH2WZPcUNGmH+1ZiGWvQ5TznKV9sF/c+N8kBfu80/rR2vdpiJaJ
         jQKP6Mup5FY/Tq5z9yRZz2MUBYdPgGHjwLFwGeVB2lYulWHf4rOVXZG3J5pjm+fHfYSz
         YBO/e83dbnw4iYC7aUK9TkxrngwIPmotTcM9AhGsZ2z9Ybk9OY9Cdc07uaOxwJykzw5m
         oarw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694358; x=1781299158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oucyR6ExWtK/Mt3ZHMUJ1XBxl0rtHFiWxfVOhnoVW3U=;
        b=ZW+r0bLzpkr3CqsKSd24WxtC18zZc0zH/fDQnr2++W0CMK8iXNZEO7wsVljZXql2fa
         hXMvHmVQypZAMC1xo3m4kDpj3O7D/uQ1KDuw5tf7q+Fkm3hnoZ6K26jkE7a2yLp0Jkqh
         YS3qRKlht8uHttVoB/iKfw6A99PzW+i8mJarb8mgANRXExtRCPtvs9TwdQAMbn9Qd3mY
         SPnTugq688fvScJmDhyaT59RYgJRZJJk2OlqLJiO/rCIgmls5IoRmgcrZAvPn0NVQQEP
         Yh1qVslFseHJ3E6QBn64d7OtFx5iPD0oadhXS24QXSzXbKg0y0rUCTnedRaiM2UTxsZZ
         ftJQ==
X-Gm-Message-State: AOJu0YynWIe/l+GvyQxNhthQylpSAPhlayvwFnYz3ka+PSAwapSMyhGt
	RPVYK0c2TOh4ixS2euHmW8tNEJTNVecBK/+Fvzt9X4Ps/F2aIbIkDkmLL03HpXpbUlViLMyPgGt
	Ki5vjqc61Nw==
X-Gm-Gg: Acq92OFpPMA8jfYa+XDP+CjC8sA84KTwpvAlp1UGUKVmg5bSM/VWkERnKHU2NEN0iWX
	JoWHO27ilnhoPvqMNVAQMKSgPXcFsm9NVfMUEv8+kPjvhZE1fiJGM8bFXlCycYe2Wub4qK3i21c
	KeqjmHYbrvkzQ2bud/jTm6hKqsRW72qWrRsrpiUHLBhrUZOHQ86k15AVO8z8x4nlUi8p66k2SqM
	JEx62M2JUPKCzK6qjBr90hrWc5lLfYtBG37kf2a6Lc1wMhEWup6vewfg0zP28gHk+hNuIogvMZ3
	h0412zsZYp93ZN4CnP1yJvMyWDGh3bPKnp7NFQt2xQ8a0Iqi4981/pW28O5exowH9FKCx3zym4D
	/FW3nTsxYloYiedvGJth4/8OSUWY0imVWtKyJdL9cU3hEVENAj/gg3nwIYlomAtcGTH6Taz6akP
	P/ziOcgZNEFEaiNYJPw0u9jXcc9YB9XzLpoRd7sKNg3/3mPYXeyP52/MqVf/s2r7sTUmnx6vUGB
	lFri5dxQWgeou0eXOnteRk=
X-Received: by 2002:a05:6214:2687:b0:8cc:d4fd:702c with SMTP id 6a1803df08f44-8cee62655c6mr91017826d6.43.1780694358540;
        Fri, 05 Jun 2026 14:19:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:18 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 2/9] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Fri,  5 Jun 2026 22:19:04 +0100
Message-ID: <20260605211911.2160954-3-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605211911.2160954-1-gourry@gourry.net>
References: <20260605211911.2160954-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 70E111A0009
X-Stat-Signature: 3g166shikap3sh9ms7fg55ztoist1qij
X-Rspam-User: 
X-HE-Tag: 1780694359-346613
X-HE-Meta: U2FsdGVkX19vEsgR/XrHib7pCE/AV7/rpZ9E9n57CQXGNg7U1w7D/9u08P8fZM0Unpdl/ilEuvlxcfTNIMkPZW3JMPrka5xjehshcv3BoMuYylDzX90vm5rjISuJRObP8f56RQ3Pa2VsZ5NGqAabKVv57bJriuTOMRPDmHAxBE5SuwtHhYm61rqY+JaEGYe8N5hg4z2dpdz4ZwzuxlL/TI2OVY6KwFP4Whl6KKXDCtwOTdNRt/9/9hBazS3asiZXBJCnQZaSHmbWmHXoEszW6UZZzi3NZqEoZOKGhFawFTRZpoZTHWLcATkpxnpM4UAspjpmmzUYdQblA++vTtdoCPjLQjpc7TbzXlI5JXbgtb8cldVWii0ODb8Bj+1V1MjoP/kPWkVhZJb+fVYO5jAL9HRY+pQ9me5NOChdLi456/+21SejLDSaTesi8AkUNMvGiOARBWhuDOluuTc5xn9dr54RxxEqShxCpes9kyxlFeAiD9mKQQ7miMDc8HNV/KpujTBcuiyoJ2e1VFN33DF5IUtf5asK4JESRJR9f7oj1quu5zK8APsHIbppmhHI0XLtNWFBXfFmZ6HjyKYSyb7/JAjer5YE7eDGgbRiNRMVgSugR1VuVYp9Y9/DfDRW69gj5t88qU2BxeBgbUx/h1QG8ZQS9JRLRaWzzMSx9HiZJ7CWRHXpXtOd7Qow82Mv2TXbWaPN39pDSCn9epQorBhMX/8CDleqZ/ZCxz90bRkRlmPgqvKXk+zJ1pucJQsO79KDn6B7MUXcVCC40r9ngHZ9T6Q4IeNTco+yt8XbBhBRdVaxJhwO92i919X26AZiPEl4ZVkjFsVjp5ZM/IjGUQRVlVzxOB9nM4+5XNNokSx7l2g5Uu+wpb3T7jKN8w8SmHQKhL9IjLBv7ctp5IcNobklCrTHc8z8MAhpafKZ2AyVBhdZbLxioOnJj0t4i4KphOXbbzejlEQqsJLpCxlpCj4
 8iBa+cN8
 xSSyo1LVhfZYCFnzKM4zrQXB9db9u2NBbhf6CqQpaTPqcXRtgKYPdfl0mbLT5K0dR0FsfDo4fYmPcJwXLtm2vq1lsRCYP6Rnr44vIydz/zqI5/tHpXasvw1I2y9OjaS5K/yXfqBqfl7hwbcbUhCsxJBmr9Mk3QdMCh6j/6Q3laR7hLHYT5M3HnDGOIbM34TFSycStZzJeFZom/v3ClszF517RuLDArPvzEWl5IXr7YOXZw+ToksuHJ9dcfW6dcalejTjGXxZW82uTFdYt+EIAe3kdCp7J1w+sfZ/NIQJpU45w1s8ax0PMFvE/wpG7reIFfUIh77VpLeTY8RCpTmB6WGXAzX8Lls7d5uJ+q/s+EEs1QegVbXbUFqAiCF8ELUL4+crBVOTyM3bPN+u1Cx/Yhzooq7lEgf81r19Ud2m9jNxREhVwGP0IhxgPCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.

This prepares for allowing callers to specify explicit online types.

Update the caller in add_memory_resource() to pass the default online
type via a local variable.

No functional change.

Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7ac19fab2263..6833208cc17c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	enum mmop *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1494,6 +1496,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	enum mmop online_type = mhp_get_default_online_type();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1582,7 +1585,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	/* online pages if requested */
 	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
 
 	return ret;
 error:
-- 
2.54.0


