Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D3C9C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CAE76B012E; Mon, 29 Jun 2026 12:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77BAC6B0132; Mon, 29 Jun 2026 12:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66AA66B0133; Mon, 29 Jun 2026 12:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BB846B012E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:38:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B8C551C07A3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:28 +0000 (UTC)
X-FDA: 84933508296.18.3B5C366
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id E390C40011
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:38:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J+IkbCXk;
	spf=pass (imf01.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751106;
	b=Awis2ijM7XyvBj3LQOXqV5LsND80y5DrUhnLsV1l47Ejgs4+nDdKMy5JS5Pq4SjnNRDmGi
	jD4wkLZHrrJpPHmyf5KPJkWzGgWIitmJPfWkRwUlmZdeF+G/e8uCJFz/K7EkHmwxdcDps9
	TDHMaWcMdDe+NissS7NkgvYU+FTVYTE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eOlG97Uwj+vcAWyz61FNiTd47EpTHp6kS1XDYGWjK/k=;
	b=BUMuBfY33fFVE5gn0QK4F/jzsFBg/b4WY7t0YV10xJQ0ZttRbZzW1mVq5v7Krwx78s7Cjv
	zfA+SZzLXY7jtJYdqMOY/skMfsOm8CTZ+THKYHFZlX5YuJbzcq9H3IZ7pc2mHilVBhCFPg
	hRZwK1kgDshza53pNTxULPk4bpaOLjQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J+IkbCXk;
	spf=pass (imf01.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-845ea8924fdso864006b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782751106; x=1783355906; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eOlG97Uwj+vcAWyz61FNiTd47EpTHp6kS1XDYGWjK/k=;
        b=J+IkbCXkxuiTZ4+tHZ72kDHJWqtEPc7jtvdNQQs0IQk2A+Q4pVofcoluuKO7vu5Fl5
         Gl8b9ww7AIruUVSTGRfwDt0dM3SOGNkCYQojF68BhoJRmbVHj1MdZEs2pU9/pijhAtY+
         kWfC2CwRZllZtBC476CpDcCPrH/Qtge2YkhXHomiHR+RJ4VLLkIPYCCzyNqUZmw9LcDN
         ZmoQYTVFcs7BVxx7Gr+SHlLfd2+sdJoP8swBTkfwVD4q0/QLxbR1wo2hN8aw4FaY4VIf
         xcQBaxGeat9LzAMcp8G5HbWgGepLLPi8dmownGRwmp20VtI3ayFZ6hPrt2F2wRyrirKF
         fPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782751106; x=1783355906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eOlG97Uwj+vcAWyz61FNiTd47EpTHp6kS1XDYGWjK/k=;
        b=O0d0mNAAmojDdkFkt5GfiQcBTUtoNTGdGXFERI210odrvPgLNsUu1LnlRQRSsxTjkZ
         EXB2/7TccQERvHJBqDJvEN0+ZzaGs6SFtxqsM7nMcgQMDxsfTY8QU8VtH4/Yn3yWLqz+
         8PU3hEgYn/x93lGl3+cDc7Yhxmqz03HsjRiDbJfY9hS9HTp1snJZsA69tJ5cUCmwz4aC
         W3A7LidjnczIwcG+Q1YF2U4hKI5R0k3zfs0lh7o78+YvTbZK93qrDKy4zkDFDRJyQwYG
         qJim48QBWW9h34be1aNPxraquswAdqKhn6JkVwLx+9WfM4CocfSTypKLNQiIhTrPq0FA
         XnHA==
X-Gm-Message-State: AOJu0Yw7QEtvkEps7cE6PArL71+/wZhbzj/KKR/wQpNWXMyfAWjofCcQ
	WLQ3xd4zRs8p9o9lLXPTkNHa2T8i47PXCso+9Kx6dpB77r3b0aTszbHc
X-Gm-Gg: AfdE7cl2WualuKNZlabkHwd+oStt2xIMpKhlaePLegn3AVw/4lzUnrBNpNXj076aV9D
	Ftv31zm9xuS+MxvEShucRF1NoBZR/r6R7HaKgmkGwafWlKZdXNnKk3ghIaZK3ZPLp7I7oG+xaeA
	n8G0HM/GcFmLnOSD0RiaNYj8M1EnJNQ0RLQCKfjpabIrBHHA1o0963yuQFxPLoteenxE3sEggES
	FUPx3d+on2aiDhDT3e0pDAMAxFbvZLlNGVFQrJh5430QdR7O5SS476B541SUGD3u6Yr/65f0QZF
	T/gj/5aek6lKYhRjMS33LPHA3U0s00fcqGJFdmowzlNwiu//Vd9/F3l0FhdMlJqg3yhqEJ4rv63
	Arl+w+JHPnhNSlaQBxnmjK6ySOquWCJSaQbNgTTsP5ZRKSTrcPONlpwfoxU2b7H+VFmOPw+Bihu
	SnsWI2Sbg=
X-Received: by 2002:a05:6a00:2d22:b0:845:e703:3c with SMTP id d2e1a72fcca58-8479f25a6cemr192278b3a.44.1782751105833;
        Mon, 29 Jun 2026 09:38:25 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847a02d41c0sm18474b3a.33.2026.06.29.09.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:38:25 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/8] mm/hugetlb: remove unnecessary empty range check in hugetlb_bootmem_set_nodes()
Date: Tue, 30 Jun 2026 01:37:36 +0900
Message-ID: <20260629163736.1606688-9-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260629163736.1606688-1-ekffu200098@gmail.com>
References: <20260629163736.1606688-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: f9sbr71b85w7p15ubmrryprf3ko3twrw
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E390C40011
X-HE-Tag: 1782751106-513350
X-HE-Meta: U2FsdGVkX196832K5peYCSSkClHzd11OpTG2dIoK7t0lXWReSj91bPDZZQsxb4ECz0T4Qlb3pRK94USSk5OU2xKQX5CDT5nJ5mN43uwBOVkP4FpU4LlKsv0X9BsanX8pr3qc5n/MF4gIZNPRqTNpo9xrhGgITS9C5oYhaz3L0uG5I0sIz5M+Sa3qoTGmgty7IleXcJobln1XmlV36JAA3+hKHgN3j1cSauKyve1pJ1NbTb1mReJT/dcdyMPr3KmE9YksDnPzI87JJ4NoXi8qkSDX70vjaCV8J8auKfmjIbnGoCuqHD5MQF5DxS9ap3VUi78VqgCwHs/27WURBH7wPy9Y91XdOZeKK2HJkWbyL38bQv2FZcgUsSlo2bNx8wzj8IwK4C6418cRrdlUh6a+vG2ywulOYKk+fjkqJFTSSCOQMILQRh170GRQ03QOqSD9Z9nM7ykcUwQy0wlUDKps3ccIbF7S7MRpAezwBY0kD/Be61HY9Oh7T2+N1cJZCh2/Qs5Iqh5nUh3GouBvHR1GX2/pPfJUHVXIH+5z/2hcDS5rrVGqlBcQEqpbGb594fLgdYMnWpw1F72xXSJV2avj+C+ZccAPju2vDNdMcvLAzpal765TuwdwLLZo6JDPg33DX5CDurXNEdofU84ENZeQauY1gg8mng55rBIpHyy3MqULgIJ8IEcu7fk7zF+gegG9Yqa5a0pUDcSbuzkNEf0OzrtPxOJ4xQPCnvy6jnmNrTcuqKHD+5p1wJp3LLqiCuDEgte4TIc1C8RMOE6co4pUiZC9wgU6Y+oodu0ru6NFser83Wh0GgZ0uM+ukl5SCJXiJGRxtnXdb8UKKj+XO5fEdNc3dWeAINFLKMLRHwDBJFmCQCU6h0hkp8+/+W1AD33YkIw8zNVG4PJqf75WUcZdJIrOpyNtz0gjkphBEqU4GqFRJo1bd4WSNn1kb5Bpi6wdMJy6+e3RSCTrUBOBJGR
 4Rasg7bq
 9YvjoBz+GHR90hRpjSdZpgy/ShFQI6zW6i8tprWB8Z2pxQGlHvy66lzjgOpq1Duzws+6wuTjx6930mDLTBUvlT5IYK3xmcHPNWkl1neH29xGlXD/qS7OzHDqvWeDugextfwrDnbcYMYIAL9s9K5087eio4m+56Sw1Owt545vSUHsuR5WMkwzytMVAZG6n5ii93qfBUQMQJdcohj8MoOoQ58bgzF4u/qogUVbHl4Aaf8M06jYIuNB0JbsMgpKgTpQCiI/UOQg5iy7jPQAsKqY0KrW4sUyI4wGo6k19m9aXA01MVF6Gj/9dbJCpf8QYRhWyvbufsRoPFNyMq3NFvCr3pM/MnOmLyj1e7X3BpD9qvqkNhEfKf4v7vv46kF2gB1e9gLyoPmQdpv7LJ7mUdZXormOFhZ1aLUNC3opjtddr0flbTfxW3awn1ySRU5sEIZKa+Yjch3iHq/VEf0+f7QBAmQeRalFIk/3I7ZqEz6tJTfQF9J8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_bootmem_set_nodes() iterates the memory ranges with
for_each_mem_pfn_range() and calls node_set(nid, hugetlb_bootmem_nodes)
only when end_pfn > start_pfn. for_each_mem_pfn_range() never returns an
empty range, so start_pfn < end_pfn always.

Therefore the check is unnecessary, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..d4d4c9df5f51 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4450,8 +4450,7 @@ void __init hugetlb_bootmem_set_nodes(void)
 		return;
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
-		if (end_pfn > start_pfn)
-			node_set(nid, hugetlb_bootmem_nodes);
+		node_set(nid, hugetlb_bootmem_nodes);
 	}
 }
 
-- 
2.43.0


