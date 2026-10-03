Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F68CCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D0D6B00A9; Fri,  2 Oct 2026 20:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E0C6B00AA; Fri,  2 Oct 2026 20:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034C26B00AB; Fri,  2 Oct 2026 20:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D07A66B00A9
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A3C5140820
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:46 +0000 (UTC)
X-FDA: 85279411812.22.EBA6F42
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf17.hostedemail.com (Postfix) with ESMTP id B0A234000B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Zux8H80m;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3l0rAagoKCIox7v28uv721u22uzs.q20zw18B-00y9oqy.25u@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3l0rAagoKCIox7v28uv721u22uzs.q20zw18B-00y9oqy.25u@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTGwDHpLhUzAsXa7WFBlG6P/g0gt4zDPf57eK2yB0Jg=;
	b=IO18cMA+F8hKeN568WPEBri3RLAyFy+JWxlXMN6yhCUcsoEbaI1DhOPYT3NRuAUIMBdAR4
	68+FKo0AMPksJAo8YloChJYTeK+iF3CL0jfpfxA76lAWSpZ4bo4oeMIyk4QZKggPp3BqnY
	lbK6qf0qOOlQS6vW3IXgrn9H0IfoHUU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Zux8H80m;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3l0rAagoKCIox7v28uv721u22uzs.q20zw18B-00y9oqy.25u@flex--jthoughton.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3l0rAagoKCIox7v28uv721u22uzs.q20zw18B-00y9oqy.25u@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986904;
	b=TIIFkUFTJdG/UjgHVaWsU1HUU/X5MCwCUmvW1KAtId6faHzYmhsaRe+IBYjB+ptd3bG70P
	Bl7SNL9qmL5qHsI2eUrAssv5yKs9ZC3mtnaTvV/P+oLpFT56UdcqBiVPPs0Z5kgcyIaqgz
	7FAP7zd3yyKyZM7A4lgmG7icxZKr2qU=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc4ac5feaa4so98225a12.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986903; x=1791591703; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RTGwDHpLhUzAsXa7WFBlG6P/g0gt4zDPf57eK2yB0Jg=;
        b=Zux8H80mLCYfUC+4hYiRPncuhu8eVGb2inqauWLkqOofBRBEhxSCBMccyC5/FPiRAy
         HZaInjS7ulCAXg3QCkZWRqs/WSBcEra+I2IQSasyQ35XDDtt1nwZLbTcprYVa4funz4L
         ZSSDmpGcWosT8mI9v/kw2i/Z815XiR+WHwnw5MV2AXlv6T2rB9E3s4kTiW4Dgrvd+jZd
         QWtrj3xNhVO/LxVz0QEViUibguN6whPRXd3Z1HedVpZRb0v/cOxu4qTs2xgnurpOGG/B
         OprjSEUU/zzb4pQe+K1Kn1sXUN+46EKLJnMrG7XZEASZrF55BbF/co7eiowR0BjzJGV5
         O4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986903; x=1791591703;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RTGwDHpLhUzAsXa7WFBlG6P/g0gt4zDPf57eK2yB0Jg=;
        b=Tk29NSb0NfVJ7q92VKFv6o+X3we5rajj6tcRKmtR+8xEc4Qd/KVQs+RCXAPq66IyuN
         pnSzi6QJeID6oHqLXAlN4qLfw9UVVKCEgUQZsItA5SgSFFTfHZvHDbl7qzYwutisYC2I
         vVnXBn850GsXTZbySErffkoPJD6ZX2kizeiWipNiv0mh+8ij2N96Dhe5z7M2l7vw57sL
         C6CEzXX3s4Jf7nD/bV+xz12rqtNVwiGp7f4FkEZ2q8jstW4rY/Yvp2I0NjVQObJSGVXc
         Ckw5i7FmUuCst470RvYCsZoyOYWGICRpNrT78HMNqGi+xv71OpbThYG87NTuNKT0aX7y
         PXfg==
X-Forwarded-Encrypted: i=1; AKwUvBy4Ab7moyZBwvuni/isIE9egMCp9xFBINpb3T8Hak0+/+qdEfOgr0SaBjk2f50SI/Pp/bD1zDWBnQ==@kvack.org
X-Gm-Message-State: AFuF++lWlQVWvXDjI8H2Vmg+kkIliDSJ1ArRZLJGhrGP4i/kICLs1CZC
	SPbzA0i28fmlGKuo8+7XBlUFmDKJMYO697RM7GgD8YYyERshXmONFnJU9cp6+mxMqj1qb82ttuw
	vdUDa0tFEOXJEZq/jSt8Q6Q==
X-Received: from pgaa6-n2.prod.google.com ([2002:a05:6a02:6486:20b0:cca:bb35:aa9c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:7103:b0:3dd:a006:7b3b with SMTP id adf61e73a8af0-3e0bd4133a8mr4176550637.58.1790986903290;
 Fri, 02 Oct 2026 17:21:43 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:13 +0000
In-Reply-To: <20261003002123.505555-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-11-jthoughton@google.com>
Subject: [PATCH v2 10/20] hugetlb_vmemmap: Expose whether HVO is enabled to
 architecture code
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
X-Rspamd-Queue-Id: B0A234000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: mscm14agh13snti44xyqknyuuonmtwmk
X-HE-Tag: 1790986904-562489
X-HE-Meta: U2FsdGVkX1+wDbkKlVyVZG1aalUJ9PXe/e6Jx9NTY5FB1BokQaDvD+pMQ8uqmdANGUu+9oMLfflpfHOm7zCMOKGZTJToiA0XKIEsrEARtILf2V45yIiaLxzmXNTVb7FSyeYGg6Dvj65QYakZEFgceSx/o8ODB2H1j+Eh/s+Ies0uwEjhMcICXiUoz6SdklZBKXwGJYOVQ4gNIlBNNQuiVwhDHH4oJqgqj6Qa+P0slknb6xs7nD/FAPwskwmP2T3rWK3shv7uUuHBFLKasCllhIxybOYGeZltQ8vgFhbCy0EVoP2WjSeZLGxxDZJrf6CFMml5J09bysKL4ylQPxygiVbKbrlfpup0/VLoKWbppI6hIWUWKMOPctZObWeWhreX7eGYIP5+tSpgaLMk7pM8pQgvb4qOMxN8/tJYhErc/6F8IHuZQI/muv3PSR0iQrPDCrQ5yBr+z622XxuMT/X3NxAWaXE31TqhvACHboYu8aeoRTRWEIGLvZWQwomQE0Ao3SsEHLFYDCigTgZFxHNCloBNStTxFCZ0k2Qfwekutt3C669iV28WGzKyUnt5sD8bJK25yMwvqEZMYusrmd/hYJdminOj/fj5cIeiWsEIaCusGVzGC+6B+p1sIBLjrw646EA3r0QVNAs4SpQPebPOw3oMfRcIMVhVJov370hIqCtA99b/SqYw49NaZYeUePtH9gSFSQ7vujujmd/Kon4Alnn/eXMiAC8Y64jpugfwgAE6BfqKetwX1+hNFMSIGWtviQe56mNGWEOd5XrFvNqR+1lwPl8mCwQjH0IbxQjUmM/cMLeGrJhSkB4bTbzWDeGIOK+Z3JfO3OOEIj6zk++eJLtjo53IIeFHIyNEZ+Gt3ZAC67EFQMBPPaUb7jy1Ty5zpnvP6avDKJOtRWBEkw5OhPJcyPc5sPT9lkkVXChiuxyOLfYYYR+iWQe7asMKO7h4ti7c71HsyRQmADKz103
 VbWZg0Oq
 PGDbSdU1LQZncOV9+c8TQjwO9zPHUwWOOA2RxRsbwuKTip0YpDSNrzOXKLxSfo1bXp2FDckM1qDay572jlE1qoSI6aW30PDLa65ExkohNILmSrb+ldPlwOlVq+aDJ2WwGACdX8XRXIIGt76vVfzcWu5d+ifAew0EAyA0/lMgOqsXVi3J0fShJQ8v3XVV84I2KO+v2GGvlWvUnSlO3LKihQmAMEVri0gWT6JOZ3MMSTva3L7f91L45dcFFCX8okArU2eomBEfn7s4f9N7xK/VR11BSuIiVQ5+UXeLPs8185VpvoW6aN6wRNs8B5q8y4g+9EU8VB+XBHVgwekWvTk7jXRCDhVUoFrJ0s8j/CydMDdIhqfBCZli0DxTpmO7P6XY7HofYBLFXGAxEvutuPrhz4xcSNMknLeGA4sKZNvR8kDxXEuT8TS6jKrwS5EXcaAsxdCc+JRJrWtc1WbKibXYZrNwCd4n+9iIJ5u4wNcg0TZtxGttPg4odyYSAGx6Lcdm0xRSftJTHczDVGtt9BZbRsIli/KA2RAePkS5/Ah9BdIOpV5GF+PK1twaVarROIdXLHbymi+CpegFPXCc7sQZB2IGtejIPosPavHGZGMJfUMgGQMJ1dCk+Vy9XwtuRB8PuKHOhoxj67RClXUN2KQypO5WI7kdZPJkQU0Ln
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Architectures that select CONFIG_ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT
may configure the system at boot depending on whether HVO is enabled,
e.g. arm64 requires all CPUs to support hardware access flag updates
only if HVO is enabled.

Add hugetlb_vmemmap_optimize_enabled() so that they can check. It is
declared before <asm/hugetlb.h> is included, so that it can also be used
from inline helpers there.

It only reflects the hugetlb_free_vmemmap= kernel command line parameter
(and the sysctl, when writable), not whether the architecture supports
HVO.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/hugetlb.h |  9 +++++++++
 mm/hugetlb_vmemmap.c    | 18 ++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 5029c7241863..1ef73b5da664 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -22,6 +22,15 @@ struct node;
 
 void free_huge_folio(struct folio *folio);
 
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+bool hugetlb_vmemmap_optimize_enabled(void);
+#else
+static inline bool hugetlb_vmemmap_optimize_enabled(void)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_HUGETLB_PAGE
 
 #include <linux/pagemap.h>
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index de4148a8aabf..c1c736dd08b9 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -448,6 +448,24 @@ static int __init hugetlb_vmemmap_optimize_param(char *buf)
 }
 early_param("hugetlb_free_vmemmap", hugetlb_vmemmap_optimize_param);
 
+/**
+ * hugetlb_vmemmap_optimize_enabled - whether HVO is enabled
+ *
+ * This only reflects the hugetlb_free_vmemmap= kernel command line parameter
+ * and the vm.hugetlb_optimize_vmemmap sysctl, not whether the architecture
+ * supports HVO (see arch_hugetlb_vmemmap_optimization_supported()).
+ *
+ * The value is final once early parameters have been parsed only if the
+ * architecture selects CONFIG_ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT;
+ * otherwise it may change at any time through the sysctl.
+ *
+ * Return: true if HVO is enabled.
+ */
+bool hugetlb_vmemmap_optimize_enabled(void)
+{
+	return READ_ONCE(vmemmap_optimize_enabled);
+}
+
 static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 					   struct folio *folio, unsigned long flags)
 {
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


