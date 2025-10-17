Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA41CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747F68E0078; Fri, 17 Oct 2025 16:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0FD8E0092; Fri, 17 Oct 2025 16:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5968A8E0078; Fri, 17 Oct 2025 16:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB6B8E0078
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 057661A02FB
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:18 +0000 (UTC)
X-FDA: 84008705676.27.F3CC679
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6363B180006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=R8Qdlphd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3W6PyaAsKCLofhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3W6PyaAsKCLofhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731996; a=rsa-sha256;
	cv=none;
	b=AhfxL/nGmHmWifj9QRmEbh/jPtFXvQkKegsg7REbm0UsK5eOdo8/wQ6CBJLdJ+4p0kMYc8
	MsCSOAgArlax4Gar+wpiYPW0Hcli9sUyx/h3Fjl+yYyYwYGGRIQgFcbEvuCsIxr9UaTak/
	pwOuATkOhSl7PjyYBieps4EsqkxE2No=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=R8Qdlphd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3W6PyaAsKCLofhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3W6PyaAsKCLofhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCewMYqxXPuHiPBbi42+xYZpayTKmLgOBxtIOtY8RZ4=;
	b=HvTMcXEjFcZMV5mxWnP3rJFLFuMYGG1lkUvjuDbpRyp4U60mY1HzRUxsHnepdHdvKG8M8m
	BzPAP5/0ZTc1CRnPzY7CFT2Z6MZxyBp0fvIFhXtK+Ck8dvjb8lTIc3+8Gmom8iZ4/ooGyt
	YKGaO5SecZe1gmhlG09LgSThDRYbBPs=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3307af9b55eso2059506a91.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731995; x=1761336795; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rCewMYqxXPuHiPBbi42+xYZpayTKmLgOBxtIOtY8RZ4=;
        b=R8QdlphdOCbSGMRkweqCFNiLiSwbCL0AIFGrPlM9hJ8qEqxjwK0AuLY5Z1pvfabFGu
         7kNRQmDauAnoHYSb4H4l+jfyKn4RRic5+/FUXgXxXcj8ikfAe+KPgo/QnU4HSnj/WEsi
         E++odqhHd1h3bsg4f2DuYwuKzi79lGRmVqC8C8qH0SIQpIph1NbvgAj3l+WWXirmOpxY
         09rjZ6BhBvlKeMwle6hsuNjmr/xnBETHtnzYjw9iALbxm3fGsA47TieAmUT4JHuF5xeQ
         UvI0oFoyuFslaT4PBZgDg34HipHuSKIw/HODrxGIZ5+Ae3g6dlvR4cFelIL0EnK1W4FC
         xsbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731995; x=1761336795;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rCewMYqxXPuHiPBbi42+xYZpayTKmLgOBxtIOtY8RZ4=;
        b=vRpimAxLOGro7rDfJnqqhxGK31Brc+f1LvMBEQ6hHD1TZqMjfJjsxc5XZk8v7xkkP9
         mb1g5fkckt6gevjLubG3/jF251gwT3f7ABIfqoeODgSrAaYAjNLC28Pt3QzsEqMmQs18
         Y1ak3NBEhZo163Aak3uU/722CDgYMcVOMkIwULJ006XCHVgRbRB/s728Qzledomq8Mq5
         uZbuzEvC29OthAksdWR1skdeaWxotiQZ3ZGDWR4BSvz9qaLVs0peP1t2HBGCzxbNNxXr
         t0vGMmjrJ7vPYVCnUNtVo4hidKnbsTnIiVdNYHLvhcezOOiSSXxXZ2bzzuVu2pviiNMl
         ZE2A==
X-Forwarded-Encrypted: i=1; AJvYcCUDPbaHg4eH+lZvuQjS+MnrtHP76A9k172fDsrPuXzcnJkEMhWI+h/RJE9G9r7VEKldBJcf6BwsKQ==@kvack.org
X-Gm-Message-State: AOJu0YzmCKkwFZ4xpowXmmkusd1zHFjYHzcLkz+Ta3Y1kkTlIRcyHnBx
	IWAIn6g5YDlEaj12ddfyE2UlHroZyTbabHXJBItPfP8lg9p+XtBgeJcdS4W/V2JQMmJKMiBZeMk
	8uYumWfnG+XvmVS4VV0i/gYgD2Q==
X-Google-Smtp-Source: AGHT+IFk3Hw62d7/r96Jo38iwe7JLO3gBGrZmfcJ9SUMrFMKpoodh3do4Odo5xum34HLvYJfnprfSWfSqL0bHUBCCw==
X-Received: from pjtf14.prod.google.com ([2002:a17:90a:c28e:b0:33b:51fe:1a85])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d06:b0:336:b563:993f with SMTP id 98e67ed59e1d1-33bcf9486cemr5545688a91.34.1760731995171;
 Fri, 17 Oct 2025 13:13:15 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:09 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <e1889532e84ec5cb4d93b10a982ea99608c26419.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 28/37] KVM: selftests: Reset shared memory after hole-punching
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6363B180006
X-Stat-Signature: t46rpqpqyu3issuq4erhbggs8o61bie5
X-HE-Tag: 1760731996-558598
X-HE-Meta: U2FsdGVkX1+cVAs9TS7I9NSC0W5zIYXSRPUYH0q3A3lk29L65n53pQyB2GPWQW7SQenNmh/HBfPIWGmVRw6BkX303CYy8n8jSEsH/DhY70ESSgAkuCkwI+YJL7kue/qdQmsG18wvy1lUEilzGTKk1rvEozuDPt+cfbMNOODsymiUgDItTZJ06h4OugNZUYcW+mNZx6HaxY56unRTUrcqzqSNF4xQCqkP0aDexep4GHD6CXCg5ZC2KWeEDk3r1pKaKUN8IECYOkua8mq3quNvHDGd09/OpOG3Dmsa1/0pdXYBj855BRgrlhoAmVjpUdVyUEYy9iEtyWP1gPc+/w0NfmHQ402mIzADcW8zxfmyL331qB0oZ5okC61YTUH8C48/7KyRuQhbepKp11p5kRtjgeyDRCLC3/ZxwsRlImXqvq8vP1O94xcr3UINkuOJb1LsKPSU9x6QW3WuCbFnvKsSJFxLSzCPFNNUlbSZ9dTv0JHbd+yU4/m/loSHntglAQC6k2XI/zvV819IUYQdgx4QqopRr1siUQr0BEQBWkY4N8zCdogxGJ8FoZlYAV3+B56Ja/x852tVJ4WGtvWtjnjqFtmu9gEksFFkNwMH0aTr/05dBhtk/kmdJneC1ojKUaTDHsPoPmHUXaF2UqwR8Qrulib7GZKrr7rAYY6msNcllua2POqu/+RxJYRB0+kS/9c4uzb8+43gGGSEuiJy5Dp72DWHT5oFdfT7E4iI0YhfzpDy6Bs2kD2xxUu7BYQtBeUdjPytKCN8//Byvk+PokBdSOoNvfOpxhQOD4lszmx4eQpX6TiO3fOI1BsUZrb46gveRoZSK66UO116pojaBTPBmNgHtwiNh6ltD0gdSdix+rHiYPi+yzKr+8stYtgn0Qu0Z7tkZ449BOHMJTbo85ssaPob87KmxQIOO4v0XTH2HP/cE0Jy2tvOU7EJcs7ikTRuC5qZdMAYoYBIg/N2d5s
 lnZyiebm
 UOHvnCuA9EbHEVqwCe/do2OFxNUS5KwYghVLChiw4JK4uvGQOd0o30CUMtlmlryj+oIYAsLwRt+oFCxqp7r7gSef+ex84oLGdy2xcklYZbqkQd8ctjBSbGW1WRjmO3c8dXhBKgQkRYt5UcrLMj9YQuqlh2A67PDtB+gK/DfoykOZoj3EtYQJRef53dhJkgy8rzCvNRx/+eH0azamhi8PJDR6ylmduGiSTyjyfnVe0mKO5Ee/bmOnQYuaEpo+keAQqPir7EItRDSjpPYTeLYRAxkSqcUPV4ouMWGTsKB3HmhqQWG1raUi3CPnHCX8lqXmP62yB0fqMcYFoWQw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The private_mem_conversions_test resets shared memory to an initial
pattern at the end of each test iteration. This reset is currently
performed before the (re)mapping pages as shared.

FALLOC_FL_PUNCH_HOLE indirectly zeroes memory, since old folios were
released and new folios are zeroed. This "clobbers" the intended
initial pattern, leaving the memory as all-zeroes for the next
iteration.

Move the memset() to occur after the hole-punch operation to ensure
the memory is correctly re-initialized with the desired pattern. While
at it, update the memset() to reset the entire data region, not just
the portion used in the last loop, to provide a fully clean slate for
the next iteration.

This was not observed before because guest_memfd was only used for
private memory, hence shared memory contents were not zeroed by the
hole punch operation.

Opportunistically add a test/check that truncation zeroes memory.

Fixes: 43f623f350ce1 ("KVM: selftests: Add x86-only selftest for private memory conversions")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/private_mem_conversions_test.c  | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 41f6b38f04071..814187d06fcca 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -202,15 +202,20 @@ static void guest_test_explicit_conversion(uint64_t base_gpa, bool do_fallocate)
 		guest_sync_shared(gpa, size, p3, p4);
 		memcmp_g(gpa, p4, size);
 
-		/* Reset the shared memory back to the initial pattern. */
-		memset((void *)gpa, init_p, size);
-
 		/*
 		 * Free (via PUNCH_HOLE) *all* private memory so that the next
 		 * iteration starts from a clean slate, e.g. with respect to
 		 * whether or not there are pages/folios in guest_mem.
 		 */
 		guest_map_shared(base_gpa, PER_CPU_DATA_SIZE, true);
+
+		/*
+		 * Test that fallocate(PUNCH_HOLE) because hole-punching zeroes
+		 * memory, then reset the entire block back to the initial
+		 * pattern for the next GUEST_STAGE.
+		 */
+		memcmp_g(base_gpa, 0, PER_CPU_DATA_SIZE);
+		memset((void *)base_gpa, init_p, PER_CPU_DATA_SIZE);
 	}
 }
 
-- 
2.51.0.858.gf9c4a03a3a-goog


