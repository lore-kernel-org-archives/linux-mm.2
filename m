Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9C7CC982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FB46B00A4; Tue, 22 Sep 2026 04:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF07E6B00A5; Tue, 22 Sep 2026 04:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E00E6B00A6; Tue, 22 Sep 2026 04:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7727D6B00A4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:44:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B25DEA0407
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:44:01 +0000 (UTC)
X-FDA: 85240760682.07.0047D44
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf23.hostedemail.com (Postfix) with ESMTP id E8572140006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:43:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I8I5kRfk;
	spf=pass (imf23.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790066639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQZ6M9cJvbnCelbC8h/SiM2wDn1buqTcsR+O1dmHqTM=;
	b=i899KfcJ2qKlTzVN+mh1yCEu43rQSDdGuSmXlehO9OsMPIujGonuakPuta38OMn5kIK6B5
	V9YYvjymcMAr5vjl8a2aRDh1I1z11hvnyb4M4nRSoxtnBihm9Z7ugzRBNTMj5vPxV8muwF
	IgVczFOoHrxK2WeqoRxRBPxjI9RrB84=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I8I5kRfk;
	spf=pass (imf23.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790066639;
	b=GvXmRC7eh5bgGCMLZ03yPmridsAR6GtuRsTorxR+mvXJtxxW3bcmkT6oE+opENmYKBfvFo
	NEQ+U9/gX5WP5x1d7rNmANE9HZn8JWZnLY216RS7it2Skd8XAR5opjR6916pFt+EktA/O3
	0hG00x+6NetMK2IXHRflQdCXnN/ou6o=
Received: by mail-pj2-f10.google.com with SMTP id 98e67ed59e1d1-39e249c766bso1632787a91.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790066639; x=1790671439; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BQZ6M9cJvbnCelbC8h/SiM2wDn1buqTcsR+O1dmHqTM=;
        b=I8I5kRfkrohe3ivQeZBsfv/dWbvwdNdFv/lwnor4zuoUKMUlLZBhh1lo34n4VmIpx7
         htmZQjD82WMb7rXALxc9JMkP4uBdkrFQjfzmXDbhZLVAUhOSnIC+a70j5HmWlUS/3EjJ
         IAwU5LYAkCDAXGvt8BzZx9NqgTVJrdv+TMBFb696Dcpk1bi9YiDvfxKDuvv3UXcUDL1D
         BNkabZQ+/ZMka5NE+7DgdiTEVy4WpDX+rfHFxcL7CXc+Shgfc4IakDW9PEylT60LaePy
         ga9C2pbWhR5OLsbD7cIGwCwgHC+0GVtlYvJQ5GZPZBKI/UNbd841daXM+1xBmDctBDgO
         fmFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790066639; x=1790671439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BQZ6M9cJvbnCelbC8h/SiM2wDn1buqTcsR+O1dmHqTM=;
        b=yt9LMAmb8FP4WnGEf2eqso9xI1YPK5Z7mpV7r1j51p6eGueBWklmJYStEqEZkpUxk4
         nASE4rcCf70MHOcxT2ud+sr4acu5cxIOw/4SMhlJIq36RkHUuojr1E3zJ15xwCMkN4BZ
         cJLsLZ/EQa7s3D8wNHbtQp2KMfwHMCo070HG2a6pjSrk5eGFG/R+krOznqJZKejbVun9
         68oyCUjvaqezVJtkinx3m25FdpgAJ7i+G4fzizts+VEkwboBjP2B8tS0guMubSL2UMVU
         5w9R+DTKFgwxn61MkZmGg2mDZtb71cXucMZI+79N0zK8yQevtI5EfnGkniXi8C/3+lus
         dSFA==
X-Forwarded-Encrypted: i=1; AKwUvBxxAOG/LwSncpqfw2ZMPtsAmgX9bLdDT4XwGS47+3VyDcZSPH0K2yptmfqo00B4QcPXLy47ajH6+Q==@kvack.org
X-Gm-Message-State: AFuF++lASW3sbgdeSf3ulsDD3HoP8iLJkDMzPR227gmhEO9YmSHIQgDs
	9rTqSouTYhSuSDTjJUAuQUHCwctBlm6+wwTXejD+YeoFVQB0MyVdJ9Yk
X-Gm-Gg: AYBFou0KMwJzQhNnWnE3O0e+94iuVOrxkV5MqJhjeruv3nIio+KGp6OrUQVszKSs8w5
	B+7NhXcYZ+HDvex3hLOorcMzTueYTVFPx1mQ4YmIJb1R7JjVB/1KWdbW8/ym716jY/39aC1uMb7
	Rj/95auzH+A855ao69MxwpkQnwB0cQ7AAy9NaI+ZkKwvMHHfFePHKqgh/mf7BoOaDLT/Ttlojbv
	HzJFIXK96y3ucnOOidRQL5MuMfB+FSKJoSRa8AQpxesk8k+jAfsE4AzKZ2t3EXptAMd0p5RkDZo
	voIoYE2N9dDDpHmBql/ujYnc+LQBnwwbtrvWdJxWw4Ou5wpMonrS9ieyxKOGcaIJp88WjFRd/pO
	o0iEpajKZBD59YNfOoRirvRS3m7YGDw6OEHLVLUm7oo/1uSxB4JSBFMdeL9TJWwmx/9H7ldK3KC
	UbzaczEfv4fMvM/BE2Kh5cw3ad9NNDDQd8jErSrhe2ghAKvpyKmqhJutBQY7UEWHPZgnFdIz10o
	z4chfh3s50=
X-Received: by 2002:a17:90b:35c5:b0:39e:6a80:dd9b with SMTP id 98e67ed59e1d1-3a0731f9793mr476673a91.34.1790066638632;
        Tue, 22 Sep 2026 01:43:58 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0674a5ae4sm3670016a91.12.2026.09.22.01.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:43:58 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
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
Subject: [PATCH v7 4/9] crash_core: replace for_each_mem_range() with for_each_mem_region()
Date: Tue, 22 Sep 2026 16:42:51 +0800
Message-ID: <20260922084256.1515554-5-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922084256.1515554-1-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E8572140006
X-Stat-Signature: tunyyrgfesubn7wmehznnznutkhbo5fb
X-Rspam-User: 
X-HE-Tag: 1790066639-316161
X-HE-Meta: U2FsdGVkX1+heHXUfCYa7ExQLq3eIvZ3VaEObdCW3MzbP/tKbspxVwBf610Cd5CObt20MXZCe6G6N7ruXxNZhgqSy1Z46KMETWcSgdCBzkokqaMX24VLrcMFXsygn6O45l2O25NrrsF4TDIeM9qyHClXPw1LuuiKVA79ng61w4HmMeMcx/jGNLH0v7+q/jDLg6JmTAMIB1om9YD5xNQnAMqJ20i4nqJuBFcQSE4PrFrWVZygPZBeGQG1DKSd7EGjqliM461hsTY8bpjCVHP1KoXdOGPOzkJ3l+i6XdZLH90kNNxpyQzgE6lvKc+s0dFC6fmeKb9MPkdee1SdQrbSWK2LIapDjD1IX92ZLxB9lpmwHLLQ7l/XIqJntybgBAgGlQLej7d37/BeAhJYLjMrgn5QK5grtVa/AnXp7MKR3+XcVJCDnYQlEpIa5ECrJfSzyY3LdwbJHKm8pRU1cM2k+vbTzD63mSra+6NpTAjfCX2vNc5w4lSRsIcl70D59WawlNDNQIGNd24ZQZcGYEfHcEzkT5+6F4n/In5nbpkdbbrKhoqY4OkoZXBQpRlZQO47jp3Xyg8b3ZVz0MHZ01GM1ROy5CTAWP6g/5RwDklb5D+c09NYBrgyhLSwSlIBD79D3T3yahtmMRV6AXRse5O83NNKOBNHfK/xsuGdHgmVXbIo4xt3robnhWHDHgCJHBnu1CGlLrpopozHFHGbDetz8reEoNlIv/4P9OO1UaS2lMQb6PWalY/zNlhVkKB8FIgKgjc42kQPCQfTIvIrr6rxUn1nQNli881EtjNAi/m4ZwvRfX7yDYAmTf22nbLiz+bIxz3d3t7YId5izEkFehPnefSeTjfOx1EokVbItRGOSNzhMWq0Ijr2DrHnfensnRXmWuAKNfelxsneaaKoOmS403eh5m9DW2pVcQfxcYD2nZVBktiMy5ED1H0oII1yPoE3rKfhWbx2K+F+wjyEeXI
 Z6J30o88
 73fb07kw/A9Uh20HbHAFlDp8oIRFzB+rxN5zpr1ZNiBRlhTf/o3RY2yHT0kG+RWjRipXcqKWkUThgYgVbEHyXEvQJPbLytqjAkEfhDZJ1/cRbM8+JEXMM4FFzdthixIyfR+KIPMdcY3BZzm5mMTaGASj6TYdJf/6+hzObTo7jIGpko7nKdHyG8wJ6i3l1SqeDipBl28DqBTpOKBB5EvM+Gn+K7xXnntnyHlIaRVTyY93KcJrKNv7G92sGJlOsbNmZMOhw3SsBVuorpPp+D/BAWwqCiX/AGtjV/zx9sLxJqarhh/1ylZDWaO66RmIPSF7VEVCFxXr3svwbB5FiFJUq+ebcQ4Q5U7jehjIlG+q2Q2uJPn5fV42WRkJHj/brbj0Wk9KPOZAbWLpQAXrYtbfKhFZjwEPM+6VheDQVOBKldH0HTrzTIVd21Dy5g/WWEJ3AcLBnclvd1IV7unvSj5oBVPB9I8FMI6XhEZ621x74mYZfY/I1hUR9Bo+MaKhNOgEUiTkIyEdM/wklh4h5yC8n1veNtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

for_each_mem_range() skips MEMBLOCK_NOMAP regions implicitly. Switch the
weak defaults to for_each_mem_region(), which exposes struct
memblock_region and per-region flags, and filter NOMAP regions explicitly
via the new crash_should_skip_region() helper. This prepares for a
subsequent patch to extend the skip filter.

No functional change.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 kernel/crash_core.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index d0cc2496dc09..c7acb2e449df 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -270,6 +270,12 @@ int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 	return 0;
 }
 
+/* Exclude NOMAP regions from the vmcore. */
+static bool crash_should_skip_region(struct memblock_region *reg)
+{
+	return memblock_is_nomap(reg);
+}
+
 static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 {
 	struct crash_mem *cmem;
@@ -285,22 +291,25 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 unsigned int __weak arch_get_system_nr_ranges(void)
 {
 	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* crashk_res + crashk_low_res, +CMA splits */
-	phys_addr_t start, end;
-	u64 i;
+	struct memblock_region *reg;
 
-	for_each_mem_range(i, &start, &end)
+	for_each_mem_region(reg) {
+		if (crash_should_skip_region(reg))
+			continue;
 		nr_ranges++;
+	}
 	return nr_ranges;
 }
 
 int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
 {
-	phys_addr_t start, end;
-	u64 i;
+	struct memblock_region *reg;
 
-	for_each_mem_range(i, &start, &end) {
-		cmem->ranges[cmem->nr_ranges].start = start;
-		cmem->ranges[cmem->nr_ranges].end = end - 1;
+	for_each_mem_region(reg) {
+		if (crash_should_skip_region(reg))
+			continue;
+		cmem->ranges[cmem->nr_ranges].start = reg->base;
+		cmem->ranges[cmem->nr_ranges].end = reg->base + reg->size - 1;
 		cmem->nr_ranges++;
 	}
 	return 0;
-- 
2.43.0


