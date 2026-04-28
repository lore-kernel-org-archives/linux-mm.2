Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE30FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4ACE6B0092; Tue, 28 Apr 2026 04:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB8B6B0093; Tue, 28 Apr 2026 04:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9391F6B0095; Tue, 28 Apr 2026 04:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 872376B0092
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:19:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2DA041C0290
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:17 +0000 (UTC)
X-FDA: 84707264754.30.6ABF705
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 57F8E2000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=W8CmbgIx;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777364355; a=rsa-sha256;
	cv=none;
	b=qX1i7p69FbfuLRj06lrRFL+F4bH668ZqZHCC3SrY2A0L/VqHmjJ4NNh21Dry7BfJOMcxmq
	21zh9zbsRHC8VEItvowadUuCi4dzzV6k3epXCIF4L0h5/uXueQ/oKDGheEWTF6u89qZib7
	JLfw1Bq/CzXsAx57N1KIu1HPfcMyF8U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=W8CmbgIx;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777364355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HM345nkBQh5gaxmYsV6Qr69X0RaLtEwieY1kCbsL1/U=;
	b=YU1wyJ/nL9v5d3PvvzTwbsEqEn2hYVHm124mEtuvNo16CmvDKcSUCwt/UsjAeAb7mVH6Cm
	m0abk6rvI9CIVGXyrlnIT/2d8ZZyjanqLns4Bgb7yTr3PBSoY3ThZGrYYI4NTebwAhzPut
	bRR1NeyupGuakO6m3Mhz+4gBBsXx6AM=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35e563b0ee7so5314349a91.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777364354; x=1777969154; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HM345nkBQh5gaxmYsV6Qr69X0RaLtEwieY1kCbsL1/U=;
        b=W8CmbgIxMqdbuRcAUkClo/oQVdp+RO/afrn8s3J2ki3LIILE6WWpJVli+G8DUXrD97
         Ax3LNIxoarKQOa99gPeQzBrGawIYxxL7KhadCQS+xvCy5d1Ku34dT70x9tEtfNxop5BO
         T0/VoqAIVTUFUte5/OKHJ7Ph3pCURSwl2vFezoxtwiWbcThbSx5zZyqD5yJJSuIgZZJR
         Yjl75DG2e+iax7YDqt13HuUIva2thWrWGNa3Jo0h8yEDWXelDe7R/t3ZPL/jA0MmITBp
         JMLpmoz/PtN7YVTaSfMlhFO88U6kaM2PSdWyKx9RiHoGtyruc3WSzThVAl+Dhgwss1wg
         mBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777364354; x=1777969154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HM345nkBQh5gaxmYsV6Qr69X0RaLtEwieY1kCbsL1/U=;
        b=sLKQDcZtiv5YtoAj+Hi++5nsJHbrJ90Fe59waVSUt4BjR6tK49L/GbTjFtJQG82Pf0
         +IE872f5g69/eWzzvQSdgOI1YLwdXfxDCSXbbkSpmwmEqCnV7eAOcCmPY1ZFyavAark/
         FcXW8a8vda2Jgt6W3OiP8Zq4XOtEGMRVs7OZ9Hfj6YcNUT1GL6TxyKOqj8K5ZynQbV6m
         eGCUfvmu+ixFQN5hcwJLvfqIEjK5k2VYDVbzJASjvUYsBpRhmDjzW3JfY518+yQIJt8a
         4pGffVGH4vyk+bpOezW7IQVDE2eDI9vMJRIhHlm2cFT8UQtzlROnspsPQryiDY4R/Wxz
         gwmQ==
X-Forwarded-Encrypted: i=1; AFNElJ9lR3uC4XPILRrHptuATI+C+Ahg/6+H4qYdpXbrMMnHYBXg5hIi1Z8iPAm78SJcRr9RjYLDdWSb7w==@kvack.org
X-Gm-Message-State: AOJu0YzAVkhrURkFVfcuRlN2SyA5YzO1QhNNNHbV7ZfFTJd/OnbLKRp7
	Mu2bBvyZUMptvYQJqSwIkV6uN2AnLabHm/UhWsu2+p7iel+BGt4a1/S6LBt6HasvjUI=
X-Gm-Gg: AeBDieu2PpdiK6PMeb2twzc4wLv1FaHswDQUU+C25meiOswA2FCJSB1YfEoh4/8PkNu
	b1f/tuvx01qj2gPO9QXbuBD5PRuUruQq2T4FF53/rVogRxR/macpBdyuuzxarEq5oVpSSdhlWMV
	IHkaRtTniz6G87BoMt1L/sSC4aRlhRoCyB1lU+eTeXgcqNRBGYDXDjjzIGBfuNPvzV7YUQbMmfV
	NpuTkWnDxyWOjJWxw9tloG3sKRq0tWgrImKqGVk+PiUFUsr6Pxnda8Q0v5B4ef12DbKIuQFj1ZH
	hyt/4G785gT8ryXAuNtiHm0MfxSdLLwmZR+PHWEXbvpBpKUADGGUCmWy+8hjtG40PhEkKGrAgsS
	dumviJtRvhRvCA8hW6Lpx0tpXOVLnXL7W1dkwTZHVE7xWFTiDwtTPCAqelmK8CJj54Gx8OtjrAg
	mZhDSP6VV/StQiaSCe/W8ml9ztSRa94EwvBphK10kb4OrxAvsxI/1lWXY=
X-Received: by 2002:a17:90b:5804:b0:35f:b230:5889 with SMTP id 98e67ed59e1d1-36491ccd608mr1594024a91.6.1777364354086;
        Tue, 28 Apr 2026 01:19:14 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3649003650esm2181356a91.8.2026.04.28.01.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 01:19:13 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v8 2/6] mm/memory_hotplug: Fix incorrect altmap passing in error path
Date: Tue, 28 Apr 2026 16:18:51 +0800
Message-Id: <20260428081855.1249045-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260428081855.1249045-1-songmuchun@bytedance.com>
References: <20260428081855.1249045-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: padfem9chusi8wszqtzesdni91mcwrm8
X-Rspam-User: 
X-Rspamd-Queue-Id: 57F8E2000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1777364355-405273
X-HE-Meta: U2FsdGVkX1+IHxOzIle+ie0cMP69of2yDvKRJ1rUYxArEI9cuy217rkc5iBZy7ctSKUO2lu/xgqtttFcsvqM1zgnEv/IS4ZT3h95I5r+Zp+w0egigkwSVwi7rHoLq1iidLAs3pRezbM/P4zzV/y4NE5ElRMtHHaodddX1mz6S+48be0c3vA41H5yyGNtD+wE5qg409guPwDNuegze05Lx1jZ8+SgGvaeHaM12HsJqGs09Lb0tUrd/FCfIXajc45VMsmY2Mpfe3zS+w5WrykHKjp2FjeAZQ39RHez0HdozlQck/GxLoPqR2HPtoHC+N+Jml1wq0MObKr1KwmsV8diaFE37q3vcJnL129CIusC5PuzzvB12FqrXPcw+fEKaJoOwbiVtIjo09rdXH3Jq+JgNlJLfFxguXPaw9sSU81qS5gcWTAJsSsBGYRdEk/W+glGANbQ2dxAF8ID/Oo3xN2NCQb9fpqfukBrKADMVTJIsJWrMON3g/kduLVoXP92EqlxyY15+I4BLkoZEG2DxiwriGiw54dP30Gz1sLF4JC0QvlYudgDgm4F23/Bpq52qeBbhKgAvCiEU884pt9dW2ssxJ53MRcOI6aqixD4bd78R79778hZkgySqWLIIQ6oMZ4vsKMwoNmX+q+tBmEgsa1GR97No/zrZ52o4887NgCVUEteXZORYUjJyuRC1TyS7vMNCCYw8mQP5sEWKX0Fd+5tmiS6brZHnpReE8+ZIgOmZXz3TKis3TpD6AXlCPMxMc4Dx4lsIKoHclL0omqirQNzZY6Bplr2iO9UQ1UBS4zFo5/nW7XhRuTKANhVEbUwbCC4rivaUFUwHXCOuVaH037o6Bzp56Pb8itCifaXNRTof/FJ/CY9jP/x/3h1+AuWrwpv8FRyHmIQAdWn+iabfP0JwbIbZtUMLyk1u6kTqncuezXoBuaEUOARuCgPE1lCY2JzZw46/sRj8l2Z1bUhNjw
 BxvcI85a
 KsAlLzORf48HrcCcwh3yvoVssnxR24vHNl+GjNWEe/IDn9Su9hyjhfBySWQs3nL9KK/WVJU2gBtpw/R4L00nPZn6wQHZB6N1WjiXXoiDaByHTlfNRxygQzdBAjo/94j/o9SyLpTug5mzJ3BcJ3v2zu6uKAoyaerQQHjF+RqP16c/cYGoU4a4vDKE7CvmnUEy3uqKGdLpRLzVtpeQXR6kWGZCaJkWNm7emzZfANk7wyAXVoM2x3+SylVy5s6eU/23ajmwafkU/+foMk6f8ISm8Sm9XoCNfX1E79kuyo6ExtkqGPLGNEGdPNeMcWs97JQbgco9e53XItF8jFsF2wOAMm1xR6vUygIN3ku347H62KfW1pyjFLmjZEXAEqDcpECrGNj41
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In create_altmaps_and_memory_blocks(), when arch_add_memory() succeeds
with memmap_on_memory enabled, the vmemmap pages are allocated from
params.altmap. If create_memory_block_devices() subsequently fails, the
error path calls arch_remove_memory() with a NULL altmap instead of
params.altmap.

This is a bug that could lead to memory corruption. Since altmap is
NULL, vmemmap_free() falls back to freeing the vmemmap pages into the
system buddy allocator via free_pages() instead of the altmap.
arch_remove_memory() then immediately destroys the physical linear
mapping for this memory. This injects unowned pages into the buddy
allocator, causing machine checks or memory corruption if the system
later attempts to allocate and use those freed pages.

Fix this by passing params.altmap to arch_remove_memory() in the error
path.

Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory_hotplug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 4426abb05655..e3352284f635 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1469,7 +1469,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, NULL);
+			arch_remove_memory(cur_start, memblock_size, params.altmap);
 			kfree(params.altmap);
 			goto out;
 		}
-- 
2.20.1


