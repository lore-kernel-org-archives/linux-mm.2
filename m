Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A10CA5FE6
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B8786B00A4; Fri,  2 Oct 2026 20:21:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3910D6B00A5; Fri,  2 Oct 2026 20:21:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BCAF6B00A6; Fri,  2 Oct 2026 20:21:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E60DE6B00A4
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76C5E805A1
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:43 +0000 (UTC)
X-FDA: 85279411686.22.9E64294
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB4FC180002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DR6jh/60";
	spf=pass (imf16.hostedemail.com: domain of 3lErAagoKCIcu4sz5rs4zyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jthoughton.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3lErAagoKCIcu4sz5rs4zyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6sUnq9x/HmG0ptNu1GvY9h8+SRbclY/ESrYb+ZqWXI=;
	b=qMhaPSyUfDUGs3lneRHoshtT715HTiGY51mDCRbGWxkoebHKk66aoPr+txUI1dnkXl1laj
	q8A/3XsP60LpcplrSUEyxA+P1wtfOsTu6JM7zytqCU3dzqB+6TAOsw0ekV+FoqcGGyMm1r
	T8cyz+JKvJDiD99LGbzkrV2/fSebs3E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986901;
	b=mXIkSbchZ4M4aYD1fev80e9llfRqOR4NT2RqsqFab5ZKR+qH4JMVZDogCYGzo9oV6az3bB
	DOgMwyGgV3TY1NsGBh+jvwpg8xKXcs4u6b4wy64g2BA93RnTD4nVw1epqIDWlnoIGa9XXP
	07AEWErO533pUCicUsEYOnjf1Y5D1dk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DR6jh/60";
	spf=pass (imf16.hostedemail.com: domain of 3lErAagoKCIcu4sz5rs4zyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jthoughton.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3lErAagoKCIcu4sz5rs4zyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e2c785aa62so1145ad.3
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986901; x=1791591701; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f6sUnq9x/HmG0ptNu1GvY9h8+SRbclY/ESrYb+ZqWXI=;
        b=DR6jh/60YVpQck4TYys9qZ8TP6t1vBhdpjG+K1/p7EGUOAwLb7BQ+u8LWKCo41/ZaA
         r2rkKR60L7sa/MBLdy7yScpZBIY2RxySup6yXzaSiqJUgadmjY1r/hnYRy/YYJrvYNkk
         IA0w9ZLGV176MQ8kRmbLz23mZNkwMfzuJsx7KDvAAKX3Hw5gzQ6OaLrJOzhEVO79HOJW
         WrwPGUPgo0PA4a8orYdTgsQrZeJhYTD/CFMUt4In35FBKI4wFR6N/LQwyJ4sWPT7nqg8
         UbrAbRgTfiKvOiUVY9rx/QJ21KJGG3SEnrorMMMKFL2mkUN0Jk0C/Ntws36ncjj6mGT/
         2ZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986901; x=1791591701;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f6sUnq9x/HmG0ptNu1GvY9h8+SRbclY/ESrYb+ZqWXI=;
        b=Z/bqkhreN/cIsvzOyKqD75duLkElt93IJ76r48ydImTULLNUdFXBC3Nm5AQH5nLND5
         MMSeN+xO6EIdCJMi3IKotQqS0GbpIIny5D+e6kz2gz0MpeV0ZkvYw7PhsiEvwTJzTcT7
         yocqXTlqe9JS0MpPU05QsXhIk9gg6g9Z7Zr44tWoFQxgEdZNYuoH+M+Ruz3aklcaO+Mp
         lMXdTY7LaLoROfwol6HS5zAOTnPoARgna4GcyC9+3qgFG3bJPpO4msUV3IKJ/Eh6AzT3
         o7vsF6LcdPI0AN2Iv4kRJj7Owlr68TMWtZJxjZS5LvK7yaGFZWvbxgVnH+oVWMTRhRRq
         Z0ng==
X-Forwarded-Encrypted: i=1; AKwUvBwUYr5TAnPqBkSO88YCvhQmdVVx3gHLN+wrjQ5L2KGiZwZtwpjpItmZU9zJj71bk1SxGrGpM74+xA==@kvack.org
X-Gm-Message-State: AFq9FYLK1dW3uBQZUSiCEbbJoqaXQOsUurBfLGGMs5h4aZcZ8ItTibTl
	NR1hlcixGznU8yUX5b4YJw3v4kkjf00L237nzZ/dz7HOjdMgp2G2uC7LEc4Xxau6xbAJq0Godz0
	17mFJ9qjEUna9RJsRzeO+yg==
X-Received: from pjbie11.prod.google.com ([2002:a17:90b:400b:b0:3a6:fc34:663f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:548f:b0:3a0:2662:815a with SMTP id 98e67ed59e1d1-3a6ce827284mr4162203a91.43.1790986900455;
 Fri, 02 Oct 2026 17:21:40 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:10 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-8-jthoughton@google.com>
Subject: [PATCH v2 07/20] hugetlb_vmemmap: Disable HVO sysctl if arch doesn't
 support HVO
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB4FC180002
X-Stat-Signature: 1uxg847m99q4wsixx9ducn3i74bjrpou
X-HE-Tag: 1790986901-538497
X-HE-Meta: U2FsdGVkX19QXuy7CfuN0GetaKDdJN1jr2luO6DoX7Rspe3leQdhIYrfcfPCHyfprFfV17C1zD282RdhVPcHHQWOukU5RdG+6xPBQzQESBvQRJW0MMH5g+DmZXpKPFnPhX5n3PKzxW0Sga4mOCcrZTx/I1hq5lN8gyrdcsH4f1/05p1JFHE8Gjq+7A14EyzUqxZMaSwb4zzYUJFz/GIgKYqOHmznE8omm2UxCZPTk5HO3dg6cS7YD6VpuFZNaCtzVpYOvZjAns9L733S/5sMhqDzAvxpwxuIwoeFeEDJxaCZsHfDVjp64xb8xlqFfM2cSOUPgcJ5wdopPghnsu8IPljkwyeO55XRjNqa48CDZArbcd3MxqV01a28k2Tuqdn/dCuRwpyjaZgtVvrKuu6VZVgeASlSTnptySa7r0CTYAjnNrKolAm4c/3Ec28V5Rk71ofKgNx/GETq5QdTqBk8xREcxyfL3+eW+fl8kFS0JW2RNzIGpGPLBo1myfhgNRNIPsULDyWGMj+W+1KBKouN1rlG+wCtcgKgNecj1aH31/EEX22qQbdPHzpXVHV/K79n1FGt3Z/6nLfGGiB+MyS7apTiydOSHKkosOUqhwD7TlIIvvdNOuEayKm5gbN0Lf2yX9DzWr9eJf8py7IIy8GC4ZBeb5gqv/29ZYUfTdobUGx59d+4VE7Wp3uL1dTZ0QBC6p7e/Aq4a8AO3qZxnS2+dHNOC72+lwDBZi5ixXW60exWpMY4DxkWdnx+Til1FgVMfxNA5ALcZkxdWtoYDLY/G95nSYcl+/6Uwa1yHwos7/m2liq+xj1dtLtcPVXsdzKhcVDLegwHf0QM/m7G3kE5jHMR6JENkBGXWxNvasBbWQ7j6RJVk3WAF5HoV8jDdkpoO92hOqLNbElA2own5xV/eVFC7c6yEq6tdRKLphoukYHyLzEgcEuCmYteSFYDb9mBgwt1qi7TutSP6oMBiTC
 TxLHiKM+
 AcmbNmNjld1j2swcTyjh3uydS/x+OKPVtH+2C5qO1B7n3jHwVjr6BX2cSS4v0q3lAXa4oZYx20jmY/FgHq/skOQ2u3jN4brzHvhQoJGjXld8qKpKSdjiO1TTuoscHHn8blbF1hRQUoiwgY7ugwCuQ75FVSr+ad3TUg7ceg4BDKc5L0S5dgm+fgoBQ+RsjOtwtnVrC1NZwayzfYN/AiJLon87Yv3Dej+wcUtiEJ/fHOelN6EZmT4TYNtG/pmvVeqFxC+h7d0uBdcVlNVa+WECBYwteG/CLfBOZoLXXasC8ptAF/PHHlX5nYSPe9pqdTbsrohb5OVUX+wOSGvo/p/sKpyqp28S5aYRnq1bqXZsFI3Pg9s8356Vklg6rnjcFwnMn4+jj0OhJ14+9XrL7pf+BFEXdsreySEN7j+alm7Igt1tSmA8+quMP5ZRPlv2mKQBHs/l82FXaJ+ysDbBn8yc85te6bb3p11T5JDoFDEmOhNXXhdLFu+a72UeDx6mtvrjhdu1E6EvSAQdIOlDvNDN9E/XEUvEn8dAJaFHjfjQ7iYskOIXKV3L6JDzj10/19VCLKh6t7THbKLaNEX3l06+TvtMHEK3T6ZWBB2hZdTvpUk76aqtkl2XPdo3r5h49WdJVHQIrQLfFQpzoD7JHyI0JERu4zQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not create the vm.hugetlb_optimize_vmemmap sysctl when the
architecture lacks support. This serves only to avoid confusion for
users.

arm64 support for HVO is conditional on certain hardware features being
enabled for all online CPUs. By the time hugetlb_vmemmap_init() runs,
all secondary CPUs will have started, and the system feature set will
have stabilized, including HVO-through-BBM, which
arch_hugetlb_vmemmap_optimization_supported() checks for.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 mm/hugetlb_vmemmap.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 8596a462fee6..817ce39d4cf3 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -763,6 +763,21 @@ static int __init hugetlb_vmemmap_init(void)
 	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
 	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
 
+	/*
+	 * Architectures that need to probe CPU support for HVO have done
+	 * such probing now. arch_hugetlb_vmemmap_optimization_supported()
+	 * will return the correct value.
+	 */
+	if (!arch_hugetlb_vmemmap_optimization_supported()) {
+		if (vmemmap_optimize_enabled)
+			pr_info("vmemmap optimization not supported by hardware\n");
+		/*
+		 * Return early to avoid setting up the hugetlb vmemmap
+		 * sysctls; HVO is not usable.
+		 */
+		return 0;
+	}
+
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
 			register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


