Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE0BC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8FD06B008C; Wed,  2 Sep 2026 03:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B67EB6B0092; Wed,  2 Sep 2026 03:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7DC36B0095; Wed,  2 Sep 2026 03:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73D736B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:31:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6CD0A4720
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:31:48 +0000 (UTC)
X-FDA: 85168002696.15.A8305D6
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0AADB140004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:31:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="NqpfN/Tf";
	spf=pass (imf09.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788334307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uqv+RTAI4cJSSsg2qdg0AwAoAqWKAsIT2FLXo2GNbW8=;
	b=2j/LDK89rKaCR7JHs9clUmO0vlo0Z6AesvG+8gI2z717/vEqm0Y574AHHJDOHG2oF0yps+
	4PSj6NHCSucuvkUEsosQSyybs6358aWeDf+02Pucd7YglJNxLrRmRnn+gUCA+nyYRuLJ3T
	wsivVIKn31iWSz8vfZtkCK5UAEryJfE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788334307;
	b=RtDQU4cMFfkOreGxLUOQvIeq4GEVLXhP9+krhlU60sNdvLMzYDgnbLqN+jPAB9Y8G4vqO1
	DURK9jQbMBZkS7Hkz+6yMmCBDNFd+8OvLJCNRFnoxDs8rFOOM+X05ZJVXsGNuAxGH46FPi
	lezzY74aXHsRRrY7PkZ6DCCyiUoyn9M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="NqpfN/Tf";
	spf=pass (imf09.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f2.google.com with SMTP id d9443c01a7336-2ccc2e84048so2638115ad.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 00:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788334306; x=1788939106; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uqv+RTAI4cJSSsg2qdg0AwAoAqWKAsIT2FLXo2GNbW8=;
        b=NqpfN/TfFBF7cwenBzF+6QIIeRPaQ7ULtx1iCZmGRr3M5RHuqPCELfDPRMWuGuKrzb
         Ntw4tbBa8xqjwaciUFh4vZUklntxGUaJEjQJeKzb3ulYgdmvrkZnT90RCFEo9SggY2wJ
         a1nIAluPCmoC0jPHgkAX8N4ZE8o9ww/NyaIbS6qoCuBqJLFus6+naXenEkb0RJtaOfEP
         LVLwHBjfAA37c0n1Kjm7ERcrmZsBYG8FnxxTPcTPbgbMrRp+ZWHwlMs0gfjKfHYAje+I
         OLaMuFyvPAAYNnrlVAxC8Gt5Sy0M/9ZLdyiBgA0ZgJPCbOOewoYpox/UfkHIpJKNn2M9
         Wu8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788334306; x=1788939106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uqv+RTAI4cJSSsg2qdg0AwAoAqWKAsIT2FLXo2GNbW8=;
        b=arPjFVi7yI/9rml1G8wZMmHzZkOt29W1HEJWlj0eAyEYpKolt/UmZw0IVAoANH/0wx
         b3wHCIZevV2hZCNR2RNccDGbDGTrtc4M9CnzlVYF8JusrhFzKZ4lPftw+1+30SWyD1yP
         y68WkoPFS8SI29Gy7XxiNkN1G6lNU6CeKoa+RfRmWrzsrjdF6+VyPT2MnQzhqiuTU+vX
         SU6JBKlR5YCZaAW9Hah5UCSI3b1l7X3524jN0BfWmBIxUU3fLtVOmKPUtB2TufOz279s
         dvFHkHr/6EbFXR8ph2UoqHDhUBpAe0icAob2BaDQpZlLdyQQQPnE8qxE6JLM+cFT/9Jj
         kueQ==
X-Forwarded-Encrypted: i=1; AHgh+RonXrIL8GZPJEyEXCX6Sfmu4Bv9d2SsVLFKTAa5isFMybWqm1YfBiVpmU95K1HrTjiuCOVInJVYbA==@kvack.org
X-Gm-Message-State: AFuF++kipJuZBKxVhA1nuQ0JSOPJNAtBojtOke/lxSreOFLV5CFm2jGo
	BGZ2DEgohDQJcciRH3rjv9xHvjFhL9VxFi0SM57NgCTt2Ok6x+Vyq/m/
X-Gm-Gg: AR+sD11cIfrnHEXuu9yknNlQ/uxLHscTWuy/9UtsT4J8k/M0qoeMUDbdwKUrQqR3E2D
	e/DmSOEo7Rshur/TAbB0tphobXrtYJPgnRCNoYQW+w+TuHNzyC3VjjRGbwFCjIwdxJN6wMpqEKL
	+qvnYrNIJHWWHiBraxh/ebPn4IdaL0CzUNOhtcFbFq/szQJ5PoZp/sqBW3npIEFv3xJyriHNhY5
	ZabRgj1YefTqUMS4VZiszDlnJhcrp9opxBC+I4I/ZxddiAwPjztiYAhfXDlRM76TJA6NtshmbCD
	FPwQpQTsxRk51m9L2ZZeQJfepPmBltI6TE1TQ1/dZVBTlJpE6QjX1nIIb/87sGUYigxXh2EEqr2
	yG86cJnsUhrPSzmQHaP9lE4sU0QwleSK1j/+qsTh5jWEGdN2+menM+afpam8gnAXUvAMYLWhaJK
	nBiDddbjqjroLfw7nYfxVDEuA4fTpbsNl+VvRqhbNPQH60Zy0J8LOgwWx8cc7+KAPAxEq2CbSA
X-Received: by 2002:a05:6a20:258e:b0:3d1:39e9:b261 with SMTP id adf61e73a8af0-3d9aa4ca9c0mr4530228637.0.1788334305736;
        Wed, 02 Sep 2026 00:31:45 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db2adcbedsm926914b3a.20.2026.09.02.00.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 00:31:44 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	robh@kernel.org,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com
Cc: mark.rutland@arm.com,
	kernel@xen0n.name,
	alex@ghiti.fr,
	hpa@zytor.com,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v6 01/10] mm: memblock: add missing HugeTLB flag name
Date: Wed,  2 Sep 2026 15:31:07 +0800
Message-ID: <20260902073116.802752-2-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902073116.802752-1-chenwandun1@gmail.com>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0AADB140004
X-Stat-Signature: 6i398jwbzqf5orofhqbp3wd6ntkrkdi3
X-HE-Tag: 1788334306-276061
X-HE-Meta: U2FsdGVkX1+PLeW9hUrhQKOEZh6FeTTJpDOZT45XoVaBRF2Zi27UQpgJI7kjg/QKOq1b2qnyPrWuMc9kdUKLbOJY64R7Bssd7KqAXejiWCRvHe4Syqya40FINrcp4PAwNUvUdZx1QqpZ01iZ1dScLgJBbfEVULI8kuXoCBhOLwmDMn5paHO+wADQhmLRBheo3aFY32CyMWoiXjirMhwFgf64CaU/Cm3BI8xSVxYMVlqCMRG/DMG7CWinJexJJmuCLrzyh1Z6uQVlyI1xNt19nSoIpy/V3kYNoZkcbw6hFcb70AbtQ/4TghZBOxO1oOiAJI5IwvFLl4Ny892k8D17TiIfidsPouM28cLc3EZk66rstgKHAiHRdM3xHYRDMlas9EXgb6lAsV8KVxx5dlJqQTh6XL5ZJjbaXmITkpzJAWTQAe8+UYvtMgRCGAR1WPS7DoLnpTwV0fs8zI/tKGzIvGZODPdsEpOZD82gNfzfC3anUzKXhsCEohH/PQfyNdF0cnofiLNVdYqGZe1SN37YhFJOyqYDs3v19s7+MTsWIOAPibvgTjZ5Py4uPu3v/aEitKGM5MtW8ikyB2Ok7B6Se6HaFQA+DXpbzCIj0zjrLc3kDHyBBItnatcUy61qnPZ650fc2muXPh9A1qQt7n/sn/AxB9fbWOYpnCqj96PNdbn2a2qbk+K+LDDV74JZXjIm4/pDjHljdJsbC3Oo1iaIkE43BSdKmnvZyQbNF5UITbpOTfXERqkTLIiFg1AMlDE23YBYEk4LgzKxdYdnyYWO4mKrtkT9vU4KrH8eRpa2/iQx5LmcS29sEt8kxS1SLm1YQ/ZoK67rzLrMVjrtLhaNISpkGrZowV9DITvYlKN3EaBtzZnqEYr+3zh5oIIUBZeZwh/wPZGP2IcFXEzGV32n9lgyxr7lmmLS9EYjQjI7PkcBD63hh8QLHRCMbLzoTHoAUEV6aGwJ546Wc2S9tHH
 zC+oR/Dy
 l/U9Yy5de/c6Fc0ZlfLpSbdW4VR5+4GQ3lbJI4z+J9/wx+0ch0yzqXI/FZzB55cLpFtiHZ7J3Pn9eJ5t5ocLN4muq4Z+0NLKj6dM1xr0G6YPUtBMiTfSafUBFas9HBKbYS2v2GsOGQhjfMUpiVFm5dLQVuU8IfMglaHM6Y+1QXsEJbPdFtyKLVFf25O/A7Jgjj+JUsL7GSEDNdcDASatwgPRh7aw3pSlPpdLdRn/M3zoKAAONPO+zi9+e25iaBv3GiNCUgIGykLrnVGxuoiQfdTSkO4aoBR9cAV9KtcJQzvk7HiV78lSbEdttH7zEdbYyx3MwhqDNFaf+tbvENmNww8WAM9wW2RDhKyQukAYZODBmCrvhANQKnE6lfeESy2p6iQ88dM9KwNd1abc3Reos90nwQXZfMJ3DVRuAfcF929Q8DZDXbSojRPUQy3DU8fsO9/SELhBdHeUpFbP82nDqoLYB88KA9fubnIVo6qnyXJb5rkA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

Commit 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work
with KHO") added MEMBLOCK_RSRV_HUGETLB but did not add the corresponding
entry to flagname[]. As a result, memblock debugfs cannot report the
flag by name.

Add the missing RSV_HUGETLB entry.

Fixes: 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work with KHO")
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://lore.kernel.org/lkml/20260821020910.3428585-2-zhaomeijing100@gmail.com/
---
 mm/memblock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memblock.c b/mm/memblock.c
index 9ce86349a29f..f2952d725c10 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2886,6 +2886,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
+	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.43.0


