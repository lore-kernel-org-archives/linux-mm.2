Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1557EFCD77
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 09:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688F36B008A; Mon,  9 Mar 2026 05:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649F66B008C; Mon,  9 Mar 2026 05:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495B06B0092; Mon,  9 Mar 2026 05:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 339236B008A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 05:54:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4AAEC4142
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:54:16 +0000 (UTC)
X-FDA: 84526064112.13.210B744
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id F267F2000B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:54:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZHZjEC6d;
	spf=pass (imf03.hostedemail.com: domain of 3xZiuaQsKCAYgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3xZiuaQsKCAYgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773050055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsuu76no6Lr54/H9nY3kYs4+gfz0/Kb8kUE1FtvvYPw=;
	b=P20mbgALAsLMhptl8IVWz77MbnNGA4m1usLIpBFIQrnvp9In6zRfXLeUHOv1M5pfSuCkjI
	t53Vn4YfVmH+MTCMTpss9wfVvSZumK130SFmMyi5P6OhbAfvP5xAV2KGPJQu1uz675AmD/
	5t7WiiWLcTcX7s7q9sauzItE76Owx1c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773050055; a=rsa-sha256;
	cv=none;
	b=lJvjXkwKy3Z9e4O2MOqLbKX6cv6M6SxGqEsZJGiv4IP1UN9/WYqo3UNgX1iUbDHtR7nlW+
	kY0pkNZK5lpPsgthYOImV7mCCiZeOsuUgEBeikTfIj1HYmS1TU+XF/wN+rryGsuQ8yzeEa
	dhgEhGAS+9mSbhklDw/VC1Ulz3akQKU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZHZjEC6d;
	spf=pass (imf03.hostedemail.com: domain of 3xZiuaQsKCAYgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3xZiuaQsKCAYgiqkxrk4ztmmuumrk.iusrot03-ssq1giq.uxm@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3597b55adebso5761885a91.2
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 02:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773050054; x=1773654854; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wsuu76no6Lr54/H9nY3kYs4+gfz0/Kb8kUE1FtvvYPw=;
        b=ZHZjEC6d+zcKF7/2wfE+56NhpvvYVpPBAHXzjfJDyPDDYFfnB4guXCn/SxxlVOLvjC
         ZVoWQb7PuWS6GSkXscR9X43yoTxg2HT6+71ZEpjQINPmXsUKuNJYR0qCO5LpPNGQrn7E
         RrrK0Ggw+YQw3eN6I9Ze05hk8tKGJWRC35kSknc7wG5OW24c8tu12MKMiY644+8UV/Kx
         /70xDEns6LbTEBW4zTvuHKsRr6saNarVutHlQkYQHr628QTGbFkP74CO7Zj7IPn3dcMV
         eC3L+cOb6coyBqJ9WJOu0sRxtF5J1eZIM7An6mT26eepRXcIXMwrl/QCHZxeKUhSH7fl
         Fnvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773050054; x=1773654854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wsuu76no6Lr54/H9nY3kYs4+gfz0/Kb8kUE1FtvvYPw=;
        b=mvd9tHIagyT8v7Cpvu/K+/3Hh+N7U23ZnR0fyeh7OqgAUSo/dTr8pVaRPjRlKPQ7kW
         TB/NFJ9YMPvIhEVGm32j8jJ6UEay6idRkYHBIqpTqJNwWIwc0XUjM9hLktKIxOPJGmv2
         Q9VZM5Kv+2FxBdIipj1tgjYScADl+J5n+N0970XZErZsXqWkl/NGpDF2wbxHbOCEK3gM
         JvmLtROsgA52im2IP6xVdivoU7VIvD1KwjXzb1K6d+AlX/toQUJn3PhMzE8cst2v4ShU
         tJy2ySn4ajeccMYy3QPOgQbGuz2iQw4AsgC6kovU+V4XSZNQ/E4EHMdJQn2glIsab52L
         5k9A==
X-Forwarded-Encrypted: i=1; AJvYcCXD+JczXoNWOez3lBjQ7cgOm3EUfGCP0PGNR9xINiQZZ4dbxKvLCVrh6Iw//S95TzA+G7TpIXiXYg==@kvack.org
X-Gm-Message-State: AOJu0YyYoPwSYdZlXg7p8opGLM54w5+DbA94rO1uVNd1GeG9j3EoPPmg
	3WF9quYjDdfJWBfwwPTQIRHZwbQxY0kCiGxn1t8cPy3lcHRsqe/WlEJJpM4Dtu6J3y8SHpImoqP
	8RtEgfxNTI7Em31EXTLjsoGG6XQ==
X-Received: from pjbsc14.prod.google.com ([2002:a17:90b:510e:b0:359:78a3:a05b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3b4f:b0:359:9bad:13d2 with SMTP id 98e67ed59e1d1-359be38f4ffmr9958202a91.34.1773050053688;
 Mon, 09 Mar 2026 02:54:13 -0700 (PDT)
Date: Mon, 09 Mar 2026 09:53:52 +0000
In-Reply-To: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
Mime-Version: 1.0
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773050050; l=1845;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=3hqbGU4XpkQVr0yrtZKZ2iPK2V2wp+71XSAAxEJMNCM=; b=DckLr8OpAPU7XT4kC4r8g0ArtuhOV9Cd8i5iwr54rk/95ZsNn/2uGsEBnIng3J2LyzzE/zy8c
 rOJt/vT4O0iC7g4iNwrc8yjDe4BprQNGW/TkdtMSLCgbt5WlFYzydCO
X-Mailer: b4 0.14.3
Message-ID: <20260309-gmem-st-blocks-v3-1-815f03d9653e@google.com>
Subject: [PATCH RFC v3 1/4] KVM: guest_memfd: Track amount of memory allocated
 on inode
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F267F2000B
X-Stat-Signature: heipmkan3wzxgjc9sai3j4mo1benh743
X-HE-Tag: 1773050054-528876
X-HE-Meta: U2FsdGVkX1+Gn3EbeygW9g6mrBwpWi/mxAWD3u635rBlUyXTVtjRxFn9PFkQ64EhotlBvMmOf0PUGVffBHOkgcLN7o6jwvuVGEx5sZd0QG+Q5owU6GAgtdMFv8BLcWJlG6/HSei3lywlHs9PXGwAiWvP0qgErqXKGeR/96ljHxEOCOFoA3kZOBq9A5mQVEJ9hVVKFyujXJlCeQnWaxNi7BY8YTHqTzsvFspbDthJxeA5WBRjxdgwCUZNe/S608GSfaGIQyNmdjRHUXEBMBopHvC8GmAdxSQvq1LalOCar0eJEjyqfHbbsF9kKXzUtoWUUQw6yyBEkW3d8zR+hqVWgexCE0BlwtJcCak+mKfdU2jMwrbdtP0stXQKRGKATAZzhZ++f9wrmHmHiVwBf6TnG0IyH0eHzHUHIZP3PCI6gn8ct0l7VoTaH3Wv7sAr3p4nWnPh+52+dbf8KvaYsanEyA4Ng5qWuzt7pLxEVq8DTMX++imTln6h5KMdpjAqH1lqpIJUQNmakyearfTHX5ZWysPb8iBHpSkPmX7+fvRvNam0whfMKKpGXbPxcUmTU4Zpd7UNw30cBBc1XvVdnJdRQBLogKV5K52BJA7l0OQfSEDSHQFP3cHrNvcLjupAWZI8Mul6ENdkfhJSaGlm+e/Dck2sKXD9jhUmTM2Uysm3dPSQimd9DgGGAzvtDNmVFLveHdLjgSFa+v2vaVe8P34rh+MU8USUPo0IAYC5ZgD2MA2afNDKfc1zRKDfMDI/ZzZaYR1OvWOonrMXYN41WAlcq3eD+DBCNuUoCQK56GPouzrBpdchoZv0Mz2NYrLX+jSr0B/8YD6ia/akPgySJDOCx77Z2oJnLsPUrq2SQphy4q1vDZPM6KTX5mB+RGEir9Tnb9mCXa7UIXv/LgqE+lFMqJb7PTN3315ctQQZDjwMceE4C+37daVFgfnG9vizX1Z2eybtkffEAw/1gxnQ0rl
 /HS7LtWe
 5L3VOqZEjtN3dHwTkhUkzTYmu8jIcE3W6awZEKL0B6vpVhCrwuVE3+5kQU6hw8QgzXAFvIR5RccK31LzwNGdY17oh4/XZUkzXoctXcu7ZZnCDiz18An3XNAG82lZFEzuvdO5lhPm5GOdFMF/wvk9WGEIfewP/URxiXGBCc2C8JFhVbquw++UMl9Qu7imokHHMJ8QEODCvwTLh7AUWdjmvqF/x5dW2osW4Y5lMe/faKv3PxI943x6JpgGhsRTEbwhwPTwnPQTBlTE+I/C/h3KAKAAoPVT4hEmhhRSMP8pmiqoV4u2bJdsQI9KsGsmc9LNBK63k1feVdkNY/VjkXYMkMmA5MpdbgfaXyEmufO3XZUK+ZUHSceLLMwzGe60zgo9KGIQIKsY133kA7a2aRONmUE60dibKlnHJ2iH1L+kPTqIXOYsK3zltVMt5dgMDIHE9VzzYfmYLdDpQ1mLk3JoT77jGoxolhIfxIFv8Pi1Cur3y6/dTCQ4fxYcr2hSleNfD6EHCgV98eMSJWGbeiG3x81LhYEKsrNIDhtodUHC2C4DZ5etU+93qtSJPx7fVF6T9DnfsSMHbdEKS+mAL3GRFZPlX+QKdg+tQBY8YDKsNie8AxtFQ+QFDiuCG896QPnBebGc7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The guest memfd currently does not update the inode's i_blocks and i_bytes
count when memory is allocated or freed. Hence, st_blocks returned from
fstat() is always 0.

Introduce byte accounting for guest memfd inodes.  When a new folio is
added to the filemap, add the folio's size.  Use the .invalidate_folio()
callback to subtract the folio's size from inode fields when folios are
truncated and removed from the filemap.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 462c5c5cb602a..77219551056a7 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -136,6 +136,9 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 					 mapping_gfp_mask(inode->i_mapping), policy);
 	mpol_cond_put(policy);
 
+	if (!IS_ERR(folio))
+		inode_add_bytes(inode, folio_size(folio));
+
 	/*
 	 * External interfaces like kvm_gmem_get_pfn() support dealing
 	 * with hugepages to a degree, but internally, guest_memfd currently
@@ -532,10 +535,21 @@ static void kvm_gmem_free_folio(struct folio *folio)
 }
 #endif
 
+static void kvm_gmem_invalidate_folio(struct folio *folio, size_t offset, size_t len)
+{
+	size_t bytes = folio_size(folio);
+
+	WARN_ON_ONCE(offset);
+	WARN_ON_ONCE(len != bytes);
+
+	inode_sub_bytes(folio_inode(folio), bytes);
+}
+
 static const struct address_space_operations kvm_gmem_aops = {
 	.dirty_folio = noop_dirty_folio,
 	.migrate_folio	= kvm_gmem_migrate_folio,
 	.error_remove_folio = kvm_gmem_error_folio,
+	.invalidate_folio = kvm_gmem_invalidate_folio,
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
 	.free_folio = kvm_gmem_free_folio,
 #endif

-- 
2.53.0.473.g4a7958ca14-goog


