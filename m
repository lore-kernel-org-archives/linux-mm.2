Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 628D7C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FAF86B0095; Wed,  2 Sep 2026 06:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AAE16B0096; Wed,  2 Sep 2026 06:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8738E6B0099; Wed,  2 Sep 2026 06:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59A9E6B0095
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:51:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF9C21C037B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:14 +0000 (UTC)
X-FDA: 85168505268.21.3BCFF9A
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf31.hostedemail.com (Postfix) with ESMTP id 22B8420005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BmJHCsvm;
	spf=pass (imf31.hostedemail.com: domain of 3n_-XagoKCFoN5GFF67GJL8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--vdonnefort.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3n_-XagoKCFoN5GFF67GJL8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788346273;
	b=Xs0k0rij1Dd2+se3+PLBPyVlY5U6xNJJ8JQe5MvUtxVJiaTgCkLVXbbA3sCMiV/GEecY1c
	oTsENWvu8MAUfwk3h0UGXYW61EDyPvi4/SiM98BcUA7dDfrp9WWguKa0cJAa4jzHQSlBjT
	mFQbD9LTwEY4eLS78rYa5aiChLP5/QE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BmJHCsvm;
	spf=pass (imf31.hostedemail.com: domain of 3n_-XagoKCFoN5GFF67GJL8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--vdonnefort.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3n_-XagoKCFoN5GFF67GJL8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9YJxK+goKseFQhyyU1kBZycBjFaImkJiX1HLmgsMgs=;
	b=W9sMlXI50jmZi0AG1HuuLe2OzfMozNO0GoDJIyWBP/1JoU7RXG/0S1R940x9uZnO8+HGKd
	ZNf4WnUb74ScVySds4saWn8O5QX7LilLYR1cVftNpON7GIwNz7tS4q2uwNpIu2X5W9iHDO
	FI4gNsaDXVz2SaFVqM/+j85hTjQXTcQ=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49545071724so6500785e9.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 03:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788346272; x=1788951072; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E9YJxK+goKseFQhyyU1kBZycBjFaImkJiX1HLmgsMgs=;
        b=BmJHCsvmiqfkm5Irs0suDcxQJD/tVFU2omO/t9Zg/0gzLEA31McrWKjQkXy7PUOLJm
         TpfbCpiFDjBBvTkwVRMOLlTlTYKdn2rfmoULT2/JkuUh8uaiW4yQZwh3Y9GmlR0BF3RU
         kfAp3mlpXdJdk/dYrpcESaLrNRfwn4pilWI/y8DjI+oneICupHSBBnP2ohGhpZZvWaK7
         0ZcuXxqDsgEjJq+lKDMqug/eqYVEq9eK6IVKAstuHeH55G863etQMXx5GTGKQhHyEeep
         2SZzOBjfRaCEDA3i2tCk91pEksUATynWh1mA4STwJ8eG6rdc/vNHw37+ZbSQmfxxDY7k
         hNwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788346272; x=1788951072;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E9YJxK+goKseFQhyyU1kBZycBjFaImkJiX1HLmgsMgs=;
        b=So8dZYUbR0CAi6JjW4UboTg4uqGcgScZgJQv9dH//E92OAgk+r0n624/KzlDB6FZgK
         JrC9XKpElRS2ZYi+2ALP5//Lm6fzFNY4lCYn8KMh6g1zIgvKV0CK3jWr+46i4UagNlkP
         zXyUdAjhGwrcnVymfplDz6S4fTJyoXHwGRGV2lu4ZcheuOaAL2b7OJo7QdsdNYR5E33e
         CvZ9sVkr0Brh8e4hCTmfQmpZ88rtN7iSVGNN7cC+rLJDr7DZkgFxbbfTmRFuzhwY8TDx
         ptWRbcT0mL3w6+xjUh/O5i1b2lIC/OdoXjNDx9pV0cGkX5IrXweQnrstoyOxSwz5FtzG
         QIMw==
X-Forwarded-Encrypted: i=1; AHgh+RpoCLnA4QnZnjXriRmD8O73h5TUOfjtcn9QiZS/YRvPnoz5VXL2MldFCRO7GdgxuUrEi1LlVOtwgQ==@kvack.org
X-Gm-Message-State: AFuF++llepTLVpeNNEUS52Qd+sJCPprRSwWpdQMA3+FEldMeZfMrCJE0
	DcAaDwOG7mhokVrii1OifBM0OtMc42dNR1XeDEzPrIjhRz0Ivv/ASvuXTewq8rU59TJ4I/O5sIi
	Wqa9TeDjA+rE5GA6k28k8+g==
X-Received: from wmik9.prod.google.com ([2002:a7b:c409:0:b0:49b:e83:a666])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e44:b0:49c:dcf8:5216 with SMTP id 5b1f17b1804b1-49ce57e7f55mr71897835e9.6.1788346271508;
 Wed, 02 Sep 2026 03:51:11 -0700 (PDT)
Date: Wed,  2 Sep 2026 11:47:06 +0100
In-Reply-To: <20260902104712.2399797-1-vdonnefort@google.com>
Mime-Version: 1.0
References: <20260902104712.2399797-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260902104712.2399797-5-vdonnefort@google.com>
Subject: [PATCH v9 04/10] set_memory.h: Introduce __set_direct_map*()
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22B8420005
X-Stat-Signature: p1jfrm3ip55kue88apmbph8ihjeu56bo
X-HE-Tag: 1788346272-960166
X-HE-Meta: U2FsdGVkX18Lwgn/KaAEEpg6tv5TV6l6BHXsCXqy2yYAjbdQLBm2M7DhAyYgLxPxKcrN1DSr/RXMERiY9hEta9I5qcFSoI62mZaK91njy7FvcC8HcdcsvtDTDNIl+nXXD0l9jf06Ulzw+IgH2hso/LgPNhjhpVnFz04+RHjP4GVZnW/roD+LUdV3T7KJgREsmDFINtJkwbMh7u/+45+rKING5xKDe8ChXgF7vR6j9l0js7BTj4f++9QiwfUapYK8WJQeKVvG5sf9a/DsOa4Uv2g1CUiGKN0MmJ5N0Hx5/SEmLlxZ+Wnf6jWqIUV4vGaw9m9lTO1ptyUJXCFyFdRz1HUjCn/KLR/3C4RkrT+tIyL+sT92pWUyEkYEEsfqS0EhJts/xm5Z0bs+aXGdFTx+AiGUHCJYKnSiL6iBN/iyUkJJ547Oo16/BIkBbZm4DpzS+LQUI+CM9p48/yZaHyryMKtvVvyvSyWOBjpMzeK0QUANHt36XO47+vX9JEtO5iuxUIzcKFoiXh6+8KRQOIx21hr7/7lRIpM5l8qXkPg1U+5BlktENt3ny0hPbKYk/trIuQqcLFHofth7AouFluUH6xuMtV4LLEpGUKtBOVmJfbK9NllNQ9ev/yzg+bdA3tcfLxdSuNSacFTSSZo225roFcqB7RZaaRjcExR7XIPUe02Tzwim29S1RBhQCNYkVD1/xQLNt/azvkoiMJj+5LraxXwMbU1j5KxvCkYqQc4UgcUfibPQknNkT/oTa6wSe541tl0EErMeGMDhqJN+ztdVbdtMJeTpCxVVFSYnP65e8iYw2uaHQJmW1pICn+fDHobRSHNfN4gTU19yh6+jZY7TrVFnI4YmoGH8qOUHYPfzdtAqYu/EcmZixSIV0+EsXM+AUt36ZeXlyD/4c4OcOaQOCvm7iYUYLIwJ1QqynwJMmgf2T+Okag4P4kiGHTzwrP+3m3sFFN6bJXpegAX8SRK
 /1CnAjwf
 icykEC5uXwrCDnj4UIpoKzvODVEmeWIeaVRqGsiGfBefiImwVObenA5fwyENmvGXJva1Jo6/eHnuJV88v5ji03AFI0EC06qkO3SrAUHQLzlZpx9cRNsYdxZdP4HQa2GD50nrNZ9rQ3fEeo64+lybpWzGD4FqbDmsFP5rSRi8285bdB36lIGmsLpm00Wr/wIbxlj6TCKGw1rVBKcs736QJ+r1ccMdtNFtgrlNgKRlpjc/fRlnwqdEaeGNA+dgWfaS2rtGXy5v5gS8bZYqWOPb3dFZ7q2qlPn+tnEkKLaBVFBv1CMLu+rMX4Yg17QiHTwvhfzvIaVDsfuENHU163e7jIifSXnYdIWHgXao0FFZubhwsQfs7u5JOaayvf2u2iBVKqpxN7jk6GrTa0GPkbEmuCqTmg4PQbe8eDYsBHByhGlIIJkoT0+uHto9zEONIhbbvLZOuZFuIylssbfl+dj1K+LqiyhWLYer+GynitxB+51O+ssLmiwmX/0W/ZABGR5NE8O+R85+esWX2nhvckQfsN4J2nAup8Q4AsR/TVpqNfENS/7z+cklTqyZJp+9vf6v7Lgv9AIEkDVpllzztA4Fk5XVnvHhLvQGIJYADDtB1ioQdwUCGqaijmW8/KrqMhYZgFgbTlZit8UsIPfX0CNUN85UCeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

set_direct_map_*() implementations verify wheter the direct map can be
effectively set. This verification can be costly. Add an "advanced" API
__set_direct_map_*() where the direct map is modified without any check.
The caller must have verified it is safe earlier with one of the
can_set_direct_map() or can_set_direct_map_range() functions.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 88175c3fa751..5a1917a3fd52 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -34,6 +34,15 @@ static inline int set_direct_map_default_noflush(struct page *page)
 	return 0;
 }
 
+static inline int __set_direct_map_invalid_noflush(struct page *page)
+{
+	return 0;
+}
+static inline int __set_direct_map_default_noflush(struct page *page)
+{
+	return 0;
+}
+
 static inline int set_direct_map_valid_noflush(struct page *page,
 					       unsigned nr, bool valid)
 {
@@ -70,6 +79,22 @@ static inline bool can_set_direct_map_range(struct page *page, unsigned long nr_
 }
 #define can_set_direct_map_range can_set_direct_map_range
 #endif
+
+#ifndef __set_direct_map_invalid_noflush
+static inline int __set_direct_map_invalid_noflush(struct page *page)
+{
+	return set_direct_map_invalid_noflush(page);
+}
+#define __set_direct_map_invalid_noflush __set_direct_map_invalid_noflush
+#endif
+
+#ifndef __set_direct_map_default_noflush
+static inline int __set_direct_map_default_noflush(struct page *page)
+{
+	return set_direct_map_default_noflush(page);
+}
+#define __set_direct_map_default_noflush __set_direct_map_default_noflush
+#endif
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
 #ifdef CONFIG_X86_64
-- 
2.55.0.970.g62bdec98f9-goog


