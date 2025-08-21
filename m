Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A90D9CA0FE7
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9538E0030; Thu, 21 Aug 2025 16:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51DF8E0027; Thu, 21 Aug 2025 16:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C7E8E0030; Thu, 21 Aug 2025 16:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAEA38E0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4E1B140389
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:43 +0000 (UTC)
X-FDA: 83801850006.11.3B059DB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7ACFD14000F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e9xXcRIA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806861; a=rsa-sha256;
	cv=none;
	b=p/BIag7QePPGT1+lgmJN/LjqCzPOCpj3CYdQhy4IV7X/Ma4dkPRy00jJ+QY4yQSpJhPydX
	abetrMXdRclQJxIl7SeWEcoA6ZBkmYpesTL0XDDFdWukokZ33dStpBzm8aKxF9j55J9mQq
	Gks34Gw7PXfXtqq1Hm6z3ParEudg38I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e9xXcRIA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQ4Uu4zoWyKmYQrq0i4l3HgKr6VpAHaNUVdQgPTsBAE=;
	b=73EU9SNvChDhyS4NM9rR7BGfq69+prUPGaTrIBcF05rD4Fndf3Xs3s5fYjgctb2YGyoyim
	fangOlvtLvfyOAPPl7jyhTqUo6ajY0fKvqVr06Vt+eIc7o/foSkU46c6co7efNileUwU22
	ea+dMdxZhjbiyOYHsAJzTruUYkEtdDM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQ4Uu4zoWyKmYQrq0i4l3HgKr6VpAHaNUVdQgPTsBAE=;
	b=e9xXcRIAYwhSGs1JA+qKbx7lSD6GgGofF8d4PIU00Et9Aqu50Ag20HYpeE8ret2AcJP5SN
	n0gsnZzZJsYbOoxobXeuG4aAf2YAqJj9rMFJ8m+BQPZ+C2DEKlkmv6HZkPiBbRrSs8pNq5
	3fruU1+uaLB1iPOL0TqujwdbiPOYpyA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-08w1vnuqPPCUeL7zh6qb1A-1; Thu, 21 Aug 2025 16:07:39 -0400
X-MC-Unique: 08w1vnuqPPCUeL7zh6qb1A-1
X-Mimecast-MFC-AGG-ID: 08w1vnuqPPCUeL7zh6qb1A_1755806858
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0c5366so7717895e9.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806858; x=1756411658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QQ4Uu4zoWyKmYQrq0i4l3HgKr6VpAHaNUVdQgPTsBAE=;
        b=nLSUSpgIHYBhb8oYdbiHl0DwdUds+3Bkdst79AYfjOH3FBFwQxhqkv9iYhEvskksJf
         ksQlh0TpHcGO1DMiMP+JmGN4xWxAbHfgQgUDhHqmCAZ+Fcix1S+mIaXZfkz0o0qK6Xbm
         v3FgTx2pCwOZ3ReuPq/ngsb5W3QcfN71hxGSpkTA/q3gnsKMONtPcN/wWMkyMupd/byS
         XCpZ32Ckq3h2iay2Ag3HQik/afQCsv6IqM8a9e10jHmWTio8ojBBeAXv5LLOf+eXJ5/6
         ZtjzUYPyMibGl9C22+B8uKAJjohS3PelWLo7TVs28hVIzqSpCcQhzYwTP225l2VU8c0w
         xswA==
X-Forwarded-Encrypted: i=1; AJvYcCVqlNvLhDf2pCLohTypYZ83KMXJsoSIMnIXv9YkzlSVH9WEX1aW0xlqJ9H6OziEoqg75YuVf2IFNw==@kvack.org
X-Gm-Message-State: AOJu0YzGvhzFuX4DTm+XkQLLHY0/diSfvUxXl8n9n61wT8vE8SBeHNo1
	Z6u4M45MEP+MsyKl+KTXuUviZLn4E5pIdSNizddnVcZ/iXoe/d49Cr+YH5lVdkkgjRQcVlFpkKF
	ISb+1ZHd33LvNVfHyd5IuOJvUlhuBseQhww7aOp1uor+UF7znV38p
X-Gm-Gg: ASbGnctCZKM1NgtB7ZFgUNwkPO0ZkSH35zXzufHgVoYVuHI9cMaoGXAT0J12OTufFPy
	OQ5P+bT1XcAiyiGZoo2nLs6fwQwGNzk081KT/sERUo0G35C6fA7XocYsEeN6C5HCx+W37WbXkvF
	XNdqJHsvSzLbVgh1gq1uYT9eXpGg01w8faKPIjmXfycTxMfnPVe5jLMWFaKFl3xcq7ZQ/MEVQVr
	Fvmr0TXON6jW81rPkfsRC0Za2+9eO1Gtd7wkCgEvO/FaPSlz3r7bmi59N8MIVZOHdeMmKr8nnyc
	1/Fl1L9/qrObm4kmoRcC8gmhoRnVFw1XtguRMn1wPApcRCBOTLGTkUDkvekGTO5ns/ADaPnLpiH
	asudW11BD62qdEnh+UbNhmg==
X-Received: by 2002:a05:600c:5251:b0:455:f380:32e2 with SMTP id 5b1f17b1804b1-45b517ca54cmr2646895e9.18.1755806857913;
        Thu, 21 Aug 2025 13:07:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlSU80KqPPviGOLp6CI40u/NjPujjG4FLCG6NoakJIlvY80lRDOTTm20w50mEKFuk0YjVSLQ==
X-Received: by 2002:a05:600c:5251:b0:455:f380:32e2 with SMTP id 5b1f17b1804b1-45b517ca54cmr2646245e9.18.1755806857378;
        Thu, 21 Aug 2025 13:07:37 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b4e87858asm18672185e9.3.2025.08.21.13.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:36 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 11/35] mm: sanity-check maximum folio size in folio_set_order()
Date: Thu, 21 Aug 2025 22:06:37 +0200
Message-ID: <20250821200701.1329277-12-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iV7b-bwGXALpbLHY5-MuBETS9vPLyBYvAWivCyJBvus_1755806858
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 7ACFD14000F
X-Stat-Signature: e8giiwujxeg7gm68se4mjjk85xxfn8bt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755806861-166925
X-HE-Meta: U2FsdGVkX1/MZF3DQ8s2Ktv6VbcOl6t5j/tG9Y5YWAggJApDzxlszjJI+YO/EduBmw0EiJDbKhUagNNtI0GAMTwzfQFZ2xaJzJ+aXtYgpdxDyG5qNCSo8TpxoHqx3wn2dS3biEH3Fi4ArVuFc5Ptvb89lpXQtHFQBwHrOx+4PFkMUEkmct5OhL/7vBsoKW+3uj/CLfGVtG8e+2/5gPlU11/itFyBkQ/g45QjTIuP0xgHzZWmI2tf1Nc1n8u2iknOFIxa7hNVa3CLMpUH4XZB9nP+hahRumCBs/c2nIdFi/aNk9RIMl5beD1E4qhcZxiMANRqrQW3jlUIuTg43mLWaiioh4nGOvoFnoN9z7kXxcjzopXgWjcPB9X9pBZnBIWKQ5kV71tmYoZnOL7/CBCr1h9BETDGt/vbycy6eoK1SjAziZYbUdrlFNAcPq0n7mLh/jnss5HUfnAl2Zpv0Z0IeXe6wgpBnxixVjIJbtsGxigvUFXpHP33+cElGog/PD9snaL+JsAUsHcTe7w67tbDW7JjjWyM/1AhAo+GVlRqaZaTWxEaDhlGF1RJ/F+cQM5cUaccynV4yRYMJ9Lisir5QTOEO6IJa0+cfymRS0aQZjTAQC41s91i6twGlKo5uMEeoBDHlp33Ncj4ztAC/bQj60bbWnt/pgp3bwdhxoU5beed4Q/MC47OQ0l6txMX6DhOWNLZR5BQowkfhzn4L0aaiImpwze0iIX+C0IuAD9DGVJiS1WEoPFZgbk6bH3nLP0IbjcK9PVF3EkN2N/8Womn7AGoT581CV2E/CRKJ8ZYLQnxhB2R++RZ9UJaAcozabWyY1DHbYFR92EqCzQn9fZMWO65fB5kKmXFnEsJWQqi5buLbaaOyUc45dwhQkZW6w0BxypLte+sXY6xakumeOsG4VPOhh/1fGvtYZeUiCPFZanRISrU1Q9aCdX0MHEc9TH5bAA8AUBP8HVq8LeE/3n
 K3OmXL7Z
 ZQ1p8ZGi+WiNkPCtByimiKptgUMVBGb/k2fuh3XytDDzG0B0fb5b+sORfWqTtftV7i2OAuhvnKxnIKCu7mYWAI6VDrgZyX42h9SUTC36GqmzUUkUi+BjJLau1O8nX23NTMfOPyRyaxADgJdnrg19VcEGUwJGiK0kqSzQUyeAPu5Noavqy1ym1zPWYTD5AR2zKLwf42LjPFR0AzZtJbm23O+r1EnxE+Gi6HZZRDqteE+FaoAVDxwuVbvlfMtT2vbF2x/JWf6IwuNztDhDlAFptdf9J9+6UOYxPB0KkaVKbaROj35FbtogANMuX5/Yms2YpDLnVQOleHmRJcBPw1Nvt3I1AemSRNVqO2w3vNYqdn1lwPHnIF2Gmi1OIVXO+z++7DY9uZDIQTaMwmieAXp0i5lEH/vMYBtCGkGmgyncEYz1WC8Gzv/m5ISjFrnAewdFDsFO1mmeysP7DjCONuE52u7rBEcSilVykEeoKG7k7FI77kf3nuCwXCl9yLK5sioKz8YgSgKTRh1z8V63B+74xeoJWVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's sanity-check in folio_set_order() whether we would be trying to
create a folio with an order that would make it exceed MAX_FOLIO_ORDER.

This will enable the check whenever a folio/compound page is initialized
through prepare_compound_head() / prepare_compound_page().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/internal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc030..946ce97036d67 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -755,6 +755,7 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
 {
 	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
 		return;
+	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
 
 	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
 #ifdef NR_PAGES_IN_LARGE_FOLIO
-- 
2.50.1


