Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9426CA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57C46B0007; Sun, 31 Aug 2025 05:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D094F6B000C; Sun, 31 Aug 2025 05:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF73D6B000D; Sun, 31 Aug 2025 05:01:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A96906B0007
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:01:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4DC21194E5
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:01:23 +0000 (UTC)
X-FDA: 83836458846.06.D399CC4
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 21CD8C0004
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:01:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gjxiGuro;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 209.85.219.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756630882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xzarj1jXPwwihpFc52AKHrUnyJlvNlaBP1cTsUIn51w=;
	b=h0zKnjChIVl3MUi9PheHFP5aSp++dCSwhgaKnw9NBWEyVTgE1Tr6/uZeQz4QWWnPZUrFgU
	l/KT9V7qo87vKXvJFo3LUFjOEtQGaGZH+nap5aT5wHbcp6quswMDHpAuDFd3GF0Nhu7QZ/
	aJ8dr7dUSbxd5g8LIK335JyWHfrnTFQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gjxiGuro;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 209.85.219.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756630882; a=rsa-sha256;
	cv=none;
	b=NDCWisRT/47hj3oOZprpjRn33C6CBfZZR3+b8vyxhQXaAP9vyJstG1vovZDqi/QEtQ6CYl
	7b7SQvlXilAMqUTBpXnksnr+xI2IEM32LPxi9yo8iLC3Ywn1U8mjHFhex04Q66Q/Hk0is5
	sjE4PhMnNJqJxiuamkqmDR5H/dnhy7c=
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e970acf352fso2726688276.2
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756630881; x=1757235681; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xzarj1jXPwwihpFc52AKHrUnyJlvNlaBP1cTsUIn51w=;
        b=gjxiGuroZ9cSgysOKv4dkiphSh/mAumoExELwiTn7qhCHC4ykDP15kbkem3bSjRvt9
         ie9xnDBS8ZIDkLWlvobjd4w/7XuGfRYyhb9mCcKl4RedwjxfVntqYnqjX5IgJ2UZsXTQ
         NXn+vBRGlIrjF0QGkD+NbUtkLS/jnoW0QzRIpM4cSeF38iTTs0Z3WdZ2AVLj+m5lrkz+
         zlK2Ag1Jz1dZHmZGzxdKRRP8sIh3nJbQ6iYe3MOE+TB4BYwoX1v/NqKV2MGLJZjFOh2/
         ZjqAh4MMoQYgQ6dCIdf+myd5smY4C1Fu3XFFTnJfc4AaqW/xrLjEm0QUsLz2Fp0IyLbT
         XPSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756630881; x=1757235681;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xzarj1jXPwwihpFc52AKHrUnyJlvNlaBP1cTsUIn51w=;
        b=tIxDWMu1L2XrTCNXpA+t967ZVbmJ9cRvwjyOaBxGScRmVkiOuOzpKKGEH6c3s8RKsH
         Br9LXvvqf/tzz+la/Dqsz5G4sdx6CnOyMp386VOMrmWy5ibxHlTOi3pjgKN+ALq9iIGP
         Bic81pfgzOlk9gvZQOR3kEfXKBrvHxurOXdE8WsB/M6mvlaGiDhEML2F0l9LkN0xpEtU
         hysk3gQSxk05gP1lEvNqv2Lf3fM/PTFPH0ILCN9EhKA6i7QqPgePS/WpxEWlY/t+CAsO
         ZaVjzC0igJwe7/ZyKKXACPRN/YocRTsHmhj3/0tJfw4XaMzixc4DpRu+dTkbCJXq1xk/
         jmaA==
X-Forwarded-Encrypted: i=1; AJvYcCVOrFolfwcOccfyRMc5E7UPCkVBlL0dgRCPvjqZIVgkKuVbBjh/jJKViCA3/qIyDHqJbFJ3iRbFwg==@kvack.org
X-Gm-Message-State: AOJu0Yyl7w2QOdW+X0A5HFK6IefobineC20YrpdulnWUsLCiuT2CcM9P
	MSHw0BNGcYYGhUtEdPD4uB31bPDy3Xy9xp/h0B22qh8feHFYaeMvFEaTzxIOIe9aXw==
X-Gm-Gg: ASbGncs2l4WUQmxry3NOY0ul6hb9CeIfDDDnsdg/Nsg1CivMUo12sEjRznrlDp4KLHJ
	7wQmbGiv95NnJhoupeTn5HYzAKEPn2goa/uzLlffoPZr4nOELgUlg8/OBId8/2/MN/+tQQyEvTV
	KpF2egPHHXodoQzawWzAylOP9JW3WvxHUAITsEkrSrV6JFdXiRDop1lJy9fUM4HZqkN18rrBYKq
	anMLCILDyPurHP9Z1UvhRwWW+P+wyPopLS6c/cLnIzf/L2C8tNt/RGK/qa+2wxjTVucGZMIaR9S
	M9uGaNZnrlaG59nWzrMNXHlRXhY0V44b5Ccocj+5/PBm4koE/RxCgbxVX6Ji4NgInmvzmaIEjkX
	xGTMX5DVwQVgmXvyh2jZRFHCa0rDvkyu73b0eto/KtGxQXh7bZ8iUXA0ZwQxa9tOrukiOZ4pjRn
	7QKW/vZ+sTmNa2Cw==
X-Google-Smtp-Source: AGHT+IGpRZTOsrv6OWnEdL6eZ2XWJIrkP0gSOahOzxZcUPGdu6xAkpdJXXS2GNMzOEVXcPVlQWvbAQ==
X-Received: by 2002:a05:6902:158f:b0:e97:276:400d with SMTP id 3f1490d57ef6-e98a583baf1mr5704848276.36.1756630880977;
        Sun, 31 Aug 2025 02:01:20 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e98ac4458c7sm985933276.8.2025.08.31.02.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:01:19 -0700 (PDT)
Date: Sun, 31 Aug 2025 02:01:16 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Hildenbrand <david@redhat.com>, Shivank Garg <shivankg@amd.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: [PATCH 1/7] mm: fix folio_expected_ref_count() when PG_private_2
In-Reply-To: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
Message-ID: <f91ee36e-a8cb-e3a4-c23b-524ff3848da7@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 21CD8C0004
X-Rspam-User: 
X-Stat-Signature: 3dn9ahm6i9dr9qp37884ixjwqnz5kt5x
X-Rspamd-Server: rspam09
X-HE-Tag: 1756630881-774881
X-HE-Meta: U2FsdGVkX1/qw/VwccdjNMBOkLJIfH+IJE+Z0PO4aDqVApVA46GQR8PPoUD4h7xJXfOFd8uyb5eLAUQKmKW5wUMis5nmyNy8yHdA4NHc5WIajFeM4owOeBlN8FuqDUc9dpAQpBP42XhPU5AJkJyTai7KIw1Lph/K3a29/tgApViZpxl0WNON67T8rmjwJ+LUf7duuchb0log3DDKAtdBFSBMq0ENGgaS4sW6yZK+Lf/4KpJRQRBVDgPmA4p9bpZZEiBKyDwGMewimmV41UJP8FIAw0Icio5YV0yC4CvI6YDqqG3W9O/dxFILNBwDler32H8mroocakP2jSut8sJYWvzRjFCNDrbjN1R+jAJuuKziX+ppEUWNs+w0Co3Rpv2QRNT0mHuGAsdg/EimPcDZBryRJEe+tmPeTfuMZ4WkXW5pFXji/s37nnv03gNhPH5gtBdGpQb6QpHkVaHH6ayubPLrN8ZLksSx6H0I5K3ljxkCnAE2mf3p9cU4z4PRPDdniE5JO0+6hTzOBhcq1OSx3DSzj0Dwo4H8bzKICXKhmuyf9XXkTMJ8XirWRNxNB8AMDhNo8Ai1/cqVubkDSFnZ8Cs4rqujW1n+vPjzBkfYsf4eznImMgxkBxxibt3mLUFSlAYvcMTLi9fI1bF+mgVGfXbxBDctm8+uZaqgjNGNV1ykjK4GYfqR6RE+ilhmxepyKKsVqxkyMgbIqhYvvibrbHJngXfLvT8L2n+v3+UWm42MPRsuOJnzjSIntHt2z2gD1MXoeTbnwjcOJriKoolFJEjcnfKvjUm23g6AT0dvB5LUD/M3IKH5e8wXK13eayhfAytLm9Fu1kMY0RVSMCxmwolCkXw1t9I2kIn/z3ozav4MdwEz6bIthpVGZgsIg+tvoSyvdU/S8AFWRNy5BRi8CFKiz/G4u4HzKgyGZP4ySbnS/WnHuFsXKc9WxvmUQijduRQYoZBKe72+Dx0SrRs
 qCQcNgFS
 4F+cxBsV9cGPH40mzx08OyuWCOXjwSnVK5rx1m7Ltn8T9IWeIUn2PrARoaR2yVJSU35xQzVeGJhSAjcW0FMJRWjZD+rkc3Kv+dqTnz+s+mHb5tjjEN7BRK+WAXPc+UsSH6g0oVC3naZbIRcgcJokadAPseu/5ZfwcrF4Ocw5w5HmmvV6iBooV+KgVrPWPL2RK8Vv8nNRVgnbehE6DgFOqT47Qiz347PG+NXr05RTOkW+ar20qo3z0jK5Wsg1DTiXgtOqmCl6OXbAzecw4XUp/2Ux4K2f6clIKUY/HW6sObU9nZWi5s0xQrvpZBjqpaA6aos8dfwJZZ66NISG8HRnusM+43dYTQkj6X8VyIDijQeyM4TP7ltIIYy2oYTLLhp6kM/tiQuXhmQHtRNn2GhGwmU+yIxZJzoh3V/4LP0JIUUnPv2BVIIsqpTsZ3Y1PH9YKj825/X1tNghpblU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

6.16's folio_expected_ref_count() is forgetting the PG_private_2 flag,
which (like PG_private, but not in addition to PG_private) counts for
1 more reference: it needs to be using folio_has_private() in place of
folio_test_private().

But this went wrong earlier: folio_expected_ref_count() was based on
(and replaced) mm/migrate.c's folio_expected_refs(), which has been
using folio_test_private() since 6.0 converted to folios(): before
that, expected_page_refs() was correctly using page_has_private().

Just a few filesystems are still using PG_private_2 a.k.a. PG_fscache.
Potentially, this fix re-enables page migration on their folios; but
it would not be surprising to learn that in practice those folios are
not migratable for other reasons.

Fixes: 86ebd50224c0 ("mm: add folio_expected_ref_count() for reference count calculation")
Fixes: 108ca8358139 ("mm/migrate: Convert expected_page_refs() to folio_expected_refs()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/mm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..ee8e535eadac 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2180,8 +2180,8 @@ static inline int folio_expected_ref_count(const struct folio *folio)
 	} else {
 		/* One reference per page from the pagecache. */
 		ref_count += !!folio->mapping << order;
-		/* One reference from PG_private. */
-		ref_count += folio_test_private(folio);
+		/* One reference from PG_private or PG_private_2. */
+		ref_count += folio_has_private(folio);
 	}
 
 	/* One reference per page table mapping. */
-- 
2.51.0


