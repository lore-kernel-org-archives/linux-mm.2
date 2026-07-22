Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCC0C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FF166B00A5; Wed, 22 Jul 2026 11:00:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7266B00A7; Wed, 22 Jul 2026 11:00:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F3C6B00A9; Wed, 22 Jul 2026 11:00:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 147A06B00A5
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:00:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72C321201DF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:00:15 +0000 (UTC)
X-FDA: 85016723190.28.834EC4E
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 508264000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:00:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HAeYTCW1;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784732413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HEuJeVpO7/an9TIgcv/7XS3Xju/554aT8fkPf9kxlBg=;
	b=Uo15RZXvXp76dIfI4t+3LSgFiUJ05ho5I9x6HVqz8oiOdAsvV9h10dXtoGrRoFiH7HhFqJ
	zNRfDGYiJzD2ipOUKOrEXGezvMfl4xGpeuBzA0glDUckI8I44CXBE40by55/6QEUP8fLUl
	9Czw9O2iPYH9ZZz3f/ReBVlvJSqDdeo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784732413;
	b=E+w10SLgVzDRhFKtGp2uA0Ad0nVW8nvPfHdojuYWh6zC+9f8Sc8BZzBi4T7hjF+hFzpVpE
	YsYSnYoTJ31Lj/wQ7maXdwrwDPKLGLPwrJHu0d4z9DM2kDcI8jtFCgWXkvin/i5B9spMax
	S+ob1j5Z8JsS8+uZytAjeQC6Fhy+ADc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HAeYTCW1;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c2a76536bso138305741cf.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784732412; x=1785337212; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HEuJeVpO7/an9TIgcv/7XS3Xju/554aT8fkPf9kxlBg=;
        b=HAeYTCW1iTwqS8+ERMc4V8wxvVsWgqLQFGqXDQEnjjI3UVM0rjoANTqtBnzvsvab++
         gDdISsLy3r4n12czI5wecEOA77VlMkOS/fvwmnOvj5z6AyCqoO70u5cF8iAT15aJ81TV
         GaLGDtSjOomIuOWoIHMUTHREKWmzZZsLVPiTEjSF2Gf3bWy1G81VXNTSc9MvwySb0f86
         hn7yX87S22W7eSdtuxw7qRJefvmOMc4/42JhjANxjJ93snyP2k5t6lcmfgp+NQEDIeBW
         hcfKCJxBZEbYM4VeDjaT65k3C8HwOXgH83aNsp1yXx/xbXEW6ykw0d61Z5W4MYX54UcY
         lRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784732412; x=1785337212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HEuJeVpO7/an9TIgcv/7XS3Xju/554aT8fkPf9kxlBg=;
        b=AKhOpCWmqCbckUcJ1HXDp1F3OwYYNfPQgqxjhcsscIFBBUmkAHDhKVw1pd0nn8fNEq
         K6qBtG7KeTmW0MPW2Ibp6unfrI08LS1dcoJ+O0vf6QF36qHCyILIapgUN0a9DVXWkUBJ
         ajY7vwGLfim2g0zMtafApf0WeMq0nnHlnNgalTMfyoDalmdIN7ehGINcVW2jqMYWQcDW
         ynQgo0WlZYbz2RAYhuYhF6hjzJcDmSltxwMkRImlWDpYVBvFw2xCM3VfHLAkmK26Ce22
         r8gnNalWJj51q1FQYCScY5J5t8Gd5koIkmwAPIWQwTa5zDdjHdFqohTFs1dTuTerHGKD
         AEuw==
X-Forwarded-Encrypted: i=1; AHgh+RoiCl49O0ryBOYpIXCVNnvXjboRjyViTfHJmscfOsQ3aurJKUhe9HNrRRvS/UX/gYNQCCl58y6cnw==@kvack.org
X-Gm-Message-State: AOJu0Yw86PdflK1+I2xDT6+VWfD58lXB4WktNY2wo2kT9rqjUPthRGlR
	mZ+y3SWaAtwr7+Y4k6ebiaTlOYAEZ4doNPEz6+wSWwpBk3zrPdPPH5ZekldTi6qd+Sw=
X-Gm-Gg: AR+sD12BnmFYwHhJhizs1mGhxTPCdb2VBt0pgkNkZvWHjyTU8JS7Bue5r8tgbwNe9E0
	iXh/2eprnLG8oZCvooimhyp/k6APg/22OHlxdjE6qovl4YIQ4Nni7MImyTKe+UKGb550CYsoCHZ
	uSy6OZde2OKfx26Om95LUzV/yaOlll7+530oys3uymBH63qFlud1/PYAcV3hvnank6F7jix/Oiz
	AB2rreihXfpx84xsmY3+RyJP8fW5qjLbSiWwjX3x8WdyHlxypNjeu6oO5KdCm7FLcboZbFdgq0l
	O93EqXltiTVMhPHI28HKx2EP3YwIdkMP67JInBGXHkQSYTpjTTe+gWkyUuRsjBUJ6WjljfCxJ4G
	njiW7+xMltZzOI3h3WCkrAe3IfH7kGz9PDaKbsb3T3a904BEH83VNCt2zeWNIq5CETC/88kc2AN
	YyJqhx0ghAHK0=
X-Received: by 2002:a05:622a:1186:b0:517:6804:3732 with SMTP id d75a77b69052e-5213e77cf30mr202908201cf.55.1784732412231;
        Wed, 22 Jul 2026 08:00:12 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8d6180sm22721736d6.16.2026.07.22.08.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 08:00:11 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] mm: page_alloc: __GFP_FS lockdep annotation for direct compaction
Date: Wed, 22 Jul 2026 10:56:44 -0400
Message-ID: <20260722150006.3848560-2-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722150006.3848560-1-hannes@cmpxchg.org>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 508264000D
X-Stat-Signature: d6brng6fsaaa1wcoyzeaceoqtyigbymh
X-Rspam-User: 
X-HE-Tag: 1784732413-241238
X-HE-Meta: U2FsdGVkX1+7ZO1TirRP/Fr8rsN+QncP2lmG4owI2+U7smZ2/5rpWlrV/Ra7GEL62vGiVzSvxDaNFAOTotLLlGPsfNmHHRAgKhLRWG4yotKyv86yS4/cG2zRYDV+k0BMgB3Zs8+LpDEZAeLoDBV5vcZXKm5fmRFOWNJ2k+QpmeR3flCpdxyi0DPDdOS4TbmWC2CoLbR5hbazfXoLSmpT/XqT8OW5e1NOmGCyphf+2L6aFsIaPMqY1ziiZaxcDRKW+w26vduD0AkQdZc7UXwEQlw0a69ajiRgFBKCT5EFNaYSYWK724hH6EbdRAirdJxtFs0hCG9C+p+rE/5+AhcDxZMcnDCbxTAkg4VtBYscP3aG/z8EQz8rCLsn/ynoXrr4UIIE96TO+FlKtFelZIhy/CHSKXEZGmiG1X07zjAJ+ml8A2wyU7pMm8KJNCXtSMLzr0hxmdoeXLvQ4/M5Vac+WZE6ua+/AQmxyE1Q+xuvV1P4tupSJEZjg/MgRXA76ed/rToZIzyUpcC8RYrjtAU3QERV46ITjiqiTRFQWDXVks6CWGJUmfXlihzAkckHTaozVGWKQPaVfT+Tk9KWjuNHobd8CC3uPm+uCo0JV3OarsL2oQQPY8l1uKXXr3IMI0VNjJbopaSoRi36l2ZPFZsDkdOSjiExz3/L/ILXwNVv/tKUgwbenWEzh+YqnKFQfphmPKYNE3DOd0fh6BsHndK4c2tKh+ulbtVLTNJZ5r2znljlNRhvnaGcC9rWrtKfL1d1QJw5NiupzwaXgtA/RV+BKZMEGRd7uPebm9VsrQEPbZavxmdKWvWXv5PU17FZjyaX8/G3EDPTfsPDdmLXmNZnM7Mj3DFOHMHCFm3HUOUvx4zogCwNjaOlkpY6/+1A90rTdryiFpMNMdytIWRVxN7vzQm+3ywJHXQRtSKByRhJXEiN2Xdor1Hr4zVW6+eSZfCnXCOZpRChlHnT4D5+hR4
 z9qcNekX
 XBdnK2w/c9pTfv6VsEqL4xqgvQ9157wNSOCrtzrxSPtoMgitk4SAzKxp2EGXTV/OQSflSzY2WNPr2mmMoOuPuEMxD1qiIpoiobGNqdoSKNLjpSFiLNUPZc/PF192Xdk2sEaN9t4/GXzTFDkpmGD33v98j6A1xcjh1BA/rnPlaQ3GArZXsPZ2E1DbXfr8OvQKWKu9mWNiXwIMYBULKf0jPRG+kaM0OrS5UJyB/osDHgk9FvA1HSg2bU4BLXSLIEWjThSA3/7TClHl/8y7xviV0EDV68o6B6lFGLMb+/FrHxg768OiPDDAeX9Ac1Kd8b8bnn+0dNKGmbvNT3TLnC4226/wKcMdqTWqLqEzac8zxr1SO23NEP0nm8H65hNfWJolz4EWJPZslhp9qg4wdxgQMUOtEXIlpGeHwKuG5n0yvodc4tcxiYIgdc5P1lVLHlq14AM8bzszO5JZ4fPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A subsequent patch will have some order-0 allocations participate in
compaction under defrag_mode, to stave off extfrag events.

Since this is a sprawling expansion of entry points, and compaction
can enter filesystem paths, add lockdep annotations that catches
__GFP_FS passing errors.

Direct reclaim has had this annotation for a while, and since reclaim
and compaction are usually used in conjunction, this is unlikely to
unearth old bugs. It's more about future proofing and peace of mind.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f..cb422505c6ef 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4152,12 +4152,14 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 	psi_memstall_enter(&pflags);
 	delayacct_compact_start();
+	fs_reclaim_acquire(gfp_mask);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
 								prio, &page);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
+	fs_reclaim_release(gfp_mask);
 	psi_memstall_leave(&pflags);
 	delayacct_compact_end();
 
-- 
2.55.0


