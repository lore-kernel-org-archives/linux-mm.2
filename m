Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67AF2C55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 15:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E92056B009E; Thu, 30 Jul 2026 11:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4366B00A1; Thu, 30 Jul 2026 11:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C470D6B00A2; Thu, 30 Jul 2026 11:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 885E06B009E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:03:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95BFD1A0180
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:03:26 +0000 (UTC)
X-FDA: 85045761612.20.0911706
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id B3F0180004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:03:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=StUNgnYK;
	spf=pass (imf30.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785423804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RepOlA7uegAkHRX0rdEAbivBLVoGLgApQvWSVyuj8bk=;
	b=lOtmdeODO6lc+JQ+ihVYtOHbUNOixqeUjbXPFmsSS66CYMl4GJExpSOAlj2zI0pqIxTbcj
	6aIgHhV/exIFK7RZ3ROqSC7MfR4b6VwXiNgWfenWVM4nD2nLikbtEisq9sLXziPv69SCBR
	3vN5LGNwhs3baJ/H/d2rbd4QWR/nJC8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785423804;
	b=k/PvRU8fb2GvONNybx2loOTZJ/Uzbh1VS/TD2HT3loAX7Nxdz0r2AVsokX82BrAYuzA9bB
	t2CELdYd/lEwk45ig+ARkSzzPeKJ11HxVRFMihPil5ZHc8mrfJyUjGJ1abnnM7b9hY5Uen
	FHXJvUFUtA9Rtig6dhu05+5Nil8AdW8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=StUNgnYK;
	spf=pass (imf30.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a0794669a6so1712718a12.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785423803; x=1786028603; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RepOlA7uegAkHRX0rdEAbivBLVoGLgApQvWSVyuj8bk=;
        b=StUNgnYKzbOXqMtsgpNUEejWh//cHOVaMDt6RU+Wh8JLePXwKq7sdTS1DGT5zKWtO0
         o8bWTYYWYmqBOZM0zgizu7GKIXGzDaE/NDI0MY0Gp4qsVx064n2VrFykKtccfcGBzAe/
         n0zVa5ycbc2ZaZNZP6pThLItamNk9WK9ZsgKDZBXzCK19zTRnJX3ZPK3wcjSlIUozHgN
         jBv1GggEvh747mLkzCca0WiO+TZVYFqC0mFgCNAlc8hngScXKRLjeNRjQt/j7jw8Y17x
         USyxJw0LKvAY7LxEvEfiDPaGhv8Ibj0sCwmbvUp67Ydb04R//MsaIN8teVec4PLVxy6g
         LoAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785423803; x=1786028603;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RepOlA7uegAkHRX0rdEAbivBLVoGLgApQvWSVyuj8bk=;
        b=eFRMd55qdqEpFvt+hGZofn1fOVqyRvfk5lU1WG/yMSz2wfTFzI7Jweh1dXuNv+n8Uc
         Xy+PoPefcAYkdVtqdAwECazGoA9edpMuYdf3tooWSa0nW/DzcDRi4f7684wuVF1r5beN
         kezvbmqD0d/K/ML+TGoxqqjB+JuJco1A2tAdPuyFWp/GxeKt0qdVxku9htDpral1hcAw
         7q6eg4Cz8Tr7Ny7cXOlpaS64oRf1wqsKLed+pNNAY8r5Wco+I6nUR9zDXk2/zKDOzeG5
         QnSzV0F+gmyASbUPlaGWunjDSkcdbLwDSsBk5oAUcRJl/cDq3Yf57femhzhBLkdkxK4O
         sacw==
X-Forwarded-Encrypted: i=1; AHgh+RpTaiQPSAdj4fI7SHTNf4QfF1IcHOhgnh4PLjKMDWBGBjgC+13vp3De4RM+hzi30ZzQz4YatLvDbA==@kvack.org
X-Gm-Message-State: AOJu0Yw9MtZo43mHKOS/q0wBA8cndrD/1t727o4njlaiQ0TUHmMGPf6y
	lGsXqK8toBXDuJNtQNcCvfBJR2H/1ugIjfLGQRQxJ0qU4vgqDzeeMyYV
X-Gm-Gg: AR+sD12785WFAEp/G1DAYY2rlkG8ao7pgB3oU7X9MPOuOnHfiRacY4b0U5YfPav8PVg
	scIs06uRtDJ0s07j9gJJLsgw88KYpbKqFC+0qf4YKwYyWfguqWxVpZHN1bo06TYfSXV7aWZzF7W
	iaGe8tfFb/9SwlESEuyiMYetJtgHiKSsuhzRQoJBZ3hHv5XQhkHGSJm2/fx2LcmIL9Z8YjGtzxp
	OjqfHUb1luDMz3vjNWKnP821soFdIgN9LW2Mk0H2+2N1qGjLU6mIshxxpysAxxEPBwLa65rpMY9
	uqseEUUsKWqcdagvUumHtAO3CDsdzpiNl/4mqna7CPPCClJWGmvgka40cJSPMGj5mauyYSPTSWc
	S+b2IJwKtnYJoY9ICLyxCQsKt4fFlzQgZ4uLB+PLWxIKa8RzQWGR0uKyFfUXWLW6GZqsosV2Y+s
	6rbZlosoDrReMY8Muy8d1OQvHAkiKSlLjz+EkCXzA82FmR3730+Gf+aRHM13s1dyJL85wC3OV5/
	OyvxTvmwNI2PSs9wECxZ3OCvrWRjj9dsw==
X-Received: by 2002:a17:906:ee87:b0:c16:318:34e3 with SMTP id a640c23a62f3a-c1fa5457a44mr140525966b.16.1785423803124;
        Thu, 30 Jul 2026 08:03:23 -0700 (PDT)
Received: from [127.0.1.1] (h-62-63-197-109.NA.cust.bahnhof.se. [62.63.197.109])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a07bf18ff8sm729116a12.0.2026.07.30.08.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 08:03:22 -0700 (PDT)
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Date: Thu, 30 Jul 2026 17:02:57 +0200
Subject: [PATCH RFC v2 1/3] mm, x86: support copying a folio using
 non-temporal stores
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-rfc-nt-demote-v2-1-452dbe3b5073@zptcorp.com>
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
In-Reply-To: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
 Frank van der Linden <fvdl@google.com>, Jonathan Cameron <jic23@kernel.org>, 
 Raghavendra K T <rkodsara@amd.com>, 
 "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
 Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
 Yiannis Nikolakopoulos <yiannis@zptcorp.com>, dimitrios@palyvos.net, 
 Ryan Roberts <ryan.roberts@arm.com>, Huan Nguyen <nhuhuan@google.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, 
 Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, 
 Alirad Malek <alirad.malek@zptcorp.com>
X-Mailer: b4 0.15.2
X-Stat-Signature: pcs4kkeyt8qq14rpfqa61ghb3dk4wgts
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3F0180004
X-HE-Tag: 1785423804-610512
X-HE-Meta: U2FsdGVkX19Q7uJl/fPrbVPtj4OvCghRY5rXWghs2mv8qSAMv/j7HCGMTC0Pv4Y2XdfzJfmK7r38OgwRNeGX5pkkQp8lHewxvPFC1m+XtpyNani1Ve8Jh7XI3G4ql9NOSedOHeIX+7GLvPxFBtePQG8WWC5wz2mZ50fd92gIJyvIxpqzDFlRQsM5Sn8VvCtE1egbhKpbi7lfVrSvKhwxOSCJc89Ph8cbPibjyqKQMfnj/E5uLbulasglykcJAtVQccvOkgGEspNdQ88VsTRg6flc1mwQsJ7gCaSQKYqDiZ5x3t9PqdAZcfNvxuEJXp/LVfUik9SpIiY1OB7mmKx9ZcQXNV8IYToeuDUdbAyQ+h15i3qfeZRiAfdech5OJncqJuCYaqvphcf2TfeIR0/Kl+FK8ca41a5nxdhQSsdIm73+OqL5xz3AOG/Ff/qCNRX0o8BzKpIqj3ObKRKg4v/Lfr+gP7pwrumd1p5YrPgRh+QGw8rwR8QtSwanm1RVS96LFtNzOHNAb8nc4ihLmt0qbUlhbMjxZNROPKOr2mgLQuL6FGdfg4lkp9qMwy9qW5ojxoyR+6KGOVSQCz4imBOVCScUb98CfPZ7oP+LYoTrRbZLWJ0eUJZ/rqpalT/FtQekpnRy4LezeJE8Jl563M83xP9qcV1uxNGYfNJ8mgcIm4LdO+SlAJo/hrY8CUL5jhoNApC8+IT0X3KLj6jfRQ2U6tkCKDwmexH/fjxLA5HtR1e3uwhWrpQ0Y240IoE01M4kBg6Voq7ydYLY87XfZZpqslmkhGuQCHgqSJeiV+z+9hC3jc6AdA7qZRw5Q0xTtBmdDbOdtbfWRdpdHLIqZ43yVgi4FZ1BMK1/Bm70Gdh/0qxMDjckPSCr5HXiwVeLK1oSx7+ab2XAMDsTLWk81+sMd3BncP9aErINRiDnxgZQ0vWdr271ioONIYeBJ2t3jjG0q4dqR3kpkjTwhxEw60x
 4UVfxFB7
 DvhhsAltRq0xJmE/kJJjZrb4dgity4XcH0pRbnOd4gfQa3pxfxaxpFISF14l90xec0NXxK1fDkDGltpQ2lrN00cuRwxROh8pwyZOHBJ0W83CINjj8bN2NFqtRhi5NZt40+yd5tRlTodFjJeytrf3x7tXhzBLnpL6DoiH15kz1RPNe8dWPnIzsEGcsKRZ+uktL39xfjE6eCKNB8EA7D/bZoQ28BZXy+mqFZlVxBzyRxWCvCWV6q0jiOBIEv6OF3a6aPWmm3Cbt1XBl4PY7wMtuz4TZKnm7LTwFmya9uOTKNZLBfaNzRECC8Cv9nYzb6sOtdmvtcCa6O8RDGhG0xe5HecJUJkxN0qFhQjAovOPpp/FGJyj9Rgani1HpSqCeTVQrxIjMX6FA7x+Oj47Ns+p/kJJpqDxssPBwsc8QipNS3sgzzh14+h9iqNo46jzrztuqcR3Hn+3kyFhGUzDqUgJXZ68ol1r25hkMn2WiDjoO+BGVeZe5g1TViga2dlgih1sXWNGa+ghZqQmwwJU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alirad Malek <alirad.malek@zptcorp.com>

In x86, use memcpy_flushcache (that uses non-temporal store
instructions) to copy a folio. To achieve that, starting from folio_mc_copy
down to copy_mc_to_kernel, create a series of helpers (named with an _nt
suffix) that have similar behavior to the original counterparts.

Signed-off-by: Alirad Malek <alirad.malek@zptcorp.com>
Co-developed-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Signed-off-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
---
 arch/x86/include/asm/uaccess.h |  4 ++++
 arch/x86/lib/copy_mc.c         | 26 ++++++++++++++++++++++++++
 include/linux/highmem.h        | 32 ++++++++++++++++++++++++++++++++
 include/linux/mm.h             |  1 +
 mm/util.c                      | 17 +++++++++++++++++
 5 files changed, 80 insertions(+)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 367297b188c3..2d0938d3e372 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -494,6 +494,10 @@ unsigned long __must_check
 copy_mc_to_kernel(void *to, const void *from, unsigned len);
 #define copy_mc_to_kernel copy_mc_to_kernel
 
+unsigned long __must_check
+copy_mc_to_kernel_nt(void *to, const void *from, unsigned len);
+#define copy_mc_to_kernel_nt copy_mc_to_kernel_nt
+
 unsigned long __must_check
 copy_mc_to_user(void __user *to, const void *from, unsigned len);
 #endif
diff --git a/arch/x86/lib/copy_mc.c b/arch/x86/lib/copy_mc.c
index 97e88e58567b..5a2ee5c2211e 100644
--- a/arch/x86/lib/copy_mc.c
+++ b/arch/x86/lib/copy_mc.c
@@ -81,6 +81,32 @@ unsigned long __must_check copy_mc_to_kernel(void *dst, const void *src, unsigne
 }
 EXPORT_SYMBOL_GPL(copy_mc_to_kernel);
 
+/**
+ * copy_mc_to_kernel_nt - memory copy that handles source exceptions
+ * if enabled, otherwise uses non-temporal stores
+ * @dst: destination address
+ * @src: source address
+ * @len: number of bytes to copy
+ *
+ * Return 0 for success, or number of bytes not copied if there was an
+ * exception.
+ */
+unsigned long __must_check copy_mc_to_kernel_nt(void *dst, const void *src, unsigned len)
+{
+	unsigned long ret;
+
+	if (copy_mc_fragile_enabled) {
+		instrument_memcpy_before(dst, src, len);
+		ret = copy_mc_fragile(dst, src, len);
+		instrument_memcpy_after(dst, src, len, ret);
+		return ret;
+	}
+
+	memcpy_flushcache(dst, src, len);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(copy_mc_to_kernel_nt);
+
 unsigned long __must_check copy_mc_to_user(void __user *dst, const void *src, unsigned len)
 {
 	unsigned long ret;
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index af03db851a1d..a5cb435b9ffe 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -468,6 +468,32 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
 
 	return ret;
 }
+
+#ifdef copy_mc_to_kernel_nt
+static inline int copy_mc_highpage_nt(struct page *to, struct page *from)
+{
+	unsigned long ret;
+	char *vfrom, *vto;
+
+	vfrom = kmap_local_page(from);
+	vto = kmap_local_page(to);
+	ret = copy_mc_to_kernel_nt(vto, vfrom, PAGE_SIZE);
+	if (!ret)
+		kmsan_copy_page_meta(to, from);
+	kunmap_local(vto);
+	kunmap_local(vfrom);
+
+	if (ret)
+		memory_failure_queue(page_to_pfn(from), 0);
+
+	return ret;
+}
+#else
+static inline int copy_mc_highpage_nt(struct page *to, struct page *from)
+{
+	return copy_mc_highpage(to, from);
+}
+#endif
 #else
 static inline int copy_mc_user_highpage(struct page *to, struct page *from,
 					unsigned long vaddr, struct vm_area_struct *vma)
@@ -481,6 +507,12 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
 	copy_highpage(to, from);
 	return 0;
 }
+
+static inline int copy_mc_highpage_nt(struct page *to, struct page *from)
+{
+	copy_highpage(to, from);
+	return 0;
+}
 #endif
 
 static inline void memcpy_page(struct page *dst_page, size_t dst_off,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..d07ce478582d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1644,6 +1644,7 @@ void __folio_put(struct folio *folio);
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
 int folio_mc_copy(struct folio *dst, struct folio *src);
+int folio_mc_copy_nt(struct folio *dst, struct folio *src);
 
 unsigned long nr_free_buffer_pages(void);
 
diff --git a/mm/util.c b/mm/util.c
index b05ab6f97e11..e09e9b5f8eee 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -749,6 +749,23 @@ int folio_mc_copy(struct folio *dst, struct folio *src)
 }
 EXPORT_SYMBOL(folio_mc_copy);
 
+int folio_mc_copy_nt(struct folio *dst, struct folio *src)
+{
+	long nr = folio_nr_pages(src);
+	long i = 0;
+
+	for (;;) {
+		if (copy_mc_highpage_nt(folio_page(dst, i), folio_page(src, i)))
+			return -EHWPOISON;
+		if (++i == nr)
+			break;
+		cond_resched();
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(folio_mc_copy_nt);
+
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 static int sysctl_overcommit_ratio __read_mostly = 50;
 static unsigned long sysctl_overcommit_kbytes __read_mostly;

-- 
2.43.0


