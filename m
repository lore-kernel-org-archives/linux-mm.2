Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C511DF588C2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82FD96B008A; Mon, 20 Apr 2026 08:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7926D6B008C; Mon, 20 Apr 2026 08:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E4B6B0093; Mon, 20 Apr 2026 08:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 429AC6B008C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:50:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E59C3E5672
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:39 +0000 (UTC)
X-FDA: 84678918198.11.D2D0BA5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id A3D27100007
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z8Pmygb6;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lC9qQY7bzQ6V7tm8vX9AgtgL5Xqe3kB5rW8A2PJPlKk=;
	b=LNcipDmEEfJZj96bWfoX5+TWMW7JnJcmV14qzUkjRX52bDgUvUQLCsSerWjF2UEE0XtUOR
	fezqk2j6kOQGxpHJeFrM4m9N0vm/TfutBEow3dwr+R6pTr5JACA3lU1+/547cCJj/R4zeS
	znpYsX0SY/ROVoGuqSgTs7d1swuYxl4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z8Pmygb6;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689437; a=rsa-sha256;
	cv=none;
	b=6uWlCuyzilwlF5gGWGbkGXhvvkDUmWXgkCYz41PHmVo7vWpwZ+cHojpcxMZfmZ5wT0ocYm
	PYcx+ckXyfTU6IzGTLEJeY0yw7pYAhGpACMBjv/Cj6nZ7+L4S6VqPBkMI/c0YAOvjyu9Xh
	QB5hYiXPmvj1DaBVxGgG4+t+kzXraPA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lC9qQY7bzQ6V7tm8vX9AgtgL5Xqe3kB5rW8A2PJPlKk=;
	b=Z8Pmygb6Mblj35v/4TfSfopzqBS88Iyd2MYudbE2FKvOHbKjR6+Ab8W3HjVTpI58HpSnxl
	p2v3cspfZcgP/Q3dYZWpIj8ldv7SiidaqSqV/HWb4isPWpoxX85FD8nxpjoQ7n96qUpGN8
	9M8JL/tsWQaluZfJdPPDSZ2gt4tqZNs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-yH85c4HLNf60f41YVQnJGw-1; Mon, 20 Apr 2026 08:50:33 -0400
X-MC-Unique: yH85c4HLNf60f41YVQnJGw-1
X-Mimecast-MFC-AGG-ID: yH85c4HLNf60f41YVQnJGw_1776689431
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4411a572dc5so650987f8f.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:50:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689431; x=1777294231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lC9qQY7bzQ6V7tm8vX9AgtgL5Xqe3kB5rW8A2PJPlKk=;
        b=WINsAm3i5ZtQLWbzUTABzYgrr40Zw0WIVgJ8cxNy5w7s1uDzykBXkyWojKRADdhGQ/
         asrzZbUFiF8I4VNT0G/w45da2cfBA/2Afixspk5Lt6L9u84N8uOc0k2TLbmZMJFociSQ
         arT4Vvx6cMt0dfLhULwlWSbHYW30okCo167rU4jSo4ETSZIIAKFd5rxxT+J5aXr/cj2t
         TbBeG1FSyuYEzHER8zaOsEgufFq4E9PqSLZHZnjRULiURsdGgOqzCHqw+6o3X7nxp3uH
         4baSHfpZSn3y2UeHZaVmq6NVfd9zrIm1ZVYwHRasXBfl7e8vxehWvARgaKFMI/WmKPih
         M1jg==
X-Forwarded-Encrypted: i=1; AFNElJ8HHA7kwYpQ1hCFG5YN6ugcSzLuIj/rpR7C7o7yZFmLm/D4Nv8pzv6XKSpRdHILu3A9fiazZFmwFQ==@kvack.org
X-Gm-Message-State: AOJu0YwaiWVgY+PYKeZQATuEZ5XU+f0BH83r8R7jjbZGa+jZ+L+ur1ZO
	AYui5XxhyiDv7F0RlYzYLKqkj7kXukr/i1rz9XxbTsUuG34fa3IVB6JmEvQVZzCExFuy2xynSue
	C1JOc+p66mqZH6LBmBnuSKSFpZUk9osrZlMK3c7dVuCHT6PMzYhbO
X-Gm-Gg: AeBDieuH/C7p9WXRg3XRjKqHQP1Ykc4My45hW9hZXILbCbOF9Dtsgb4Ljftm1WvCvHq
	sQOv3BEPLp4CJl/5XdCciQPMtNi4VKRUA0g1IAEpLHKmYEvuFDxFQGzKP23R7/fQ4mEGo9Ca5sZ
	Sd7M7vjjsEHvG1DuSJv3ln5AGYiR8dRp1oYZpVri/TUUiuv8kwyou9xfC8JVYSr/k6N3hAlJwB+
	AaonnlZNhww49j2ueW5ZwWZiKX2jEAO4hg5Q4IacyrUdgm8jIYLem4thmUWWAE9O5EwoCQlHULk
	QqxUdixWHI8RfZ16fg7yV9batpoIFw/Hcc+JvuzAzPZxWigxnmWxfUOVpCs9ArDqR0sKi29+Mkv
	eyU3SYMnZahR99ut6mzuDlT2yfys6R4QTdswQRnjSmIKDBnJC65FHag==
X-Received: by 2002:a05:6000:2c0b:b0:439:beb9:5a96 with SMTP id ffacd0b85a97d-43fe3dfbff5mr21175534f8f.31.1776689430918;
        Mon, 20 Apr 2026 05:50:30 -0700 (PDT)
X-Received: by 2002:a05:6000:2c0b:b0:439:beb9:5a96 with SMTP id ffacd0b85a97d-43fe3dfbff5mr21175410f8f.31.1776689429964;
        Mon, 20 Apr 2026 05:50:29 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb13a0sm29092510f8f.8.2026.04.20.05.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:50:29 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:27 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC v2 03/18] mm: add PG_zeroed page flag for known-zero pages
Message-ID: <48c5f902f03a72e4337979f5193c64017675f72e.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Bx9RCrUvWMkgkE4tFO9HSBr-Awv8bVrK4MJYahXS9Xg_1776689431
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3D27100007
X-Stat-Signature: damyznmhddagd86u56ipkc494epqjzk6
X-Rspam-User: 
X-HE-Tag: 1776689437-542889
X-HE-Meta: U2FsdGVkX18u+jbU9EEqWkH5uFWXVVy7DQam7rSOFDAHv23bMPBRsdg+wZrOe9PiJFQa1aSVrPWZyXMWBdZMmb/itpO1OOm12eS+RpcuFI7Ro7YioQeU1FXWalGlsGg98/O6LD98N4/TxhP8h7rdhJ9fqTsEFUVdrztnncEBNZGYBxnvVW94zP3RZ9QMqYlDQbapWEojNiyr72VzvxUILQi2cbyfnDCAseuYBHODygv9olFWlE1MaQHriCvuSPOLL8bmWTCfWnUoL0IQaCisUx3Qq4Yo9L4zDtjmTKMJFlx43PZ9CMGqM2prwqAX7n0M1CUSl31O5aykkZQ+ZJeZQDvcJRpEXR5vy2L5LPzaSdNNP889R1ehdgkOWJVOU5WCJSZ3Z9BFu3qiqxwOd+ODQBdlgkoIpa5EuoK/0Nhu2T7hUFsebfYgyeuP5k62dHTeARfeEbKUOnOo1MkouRTI41EwAkD0PQhrLI3WsdtKEqh1Hmxdp8G9rSwiWRz/A3IBv/giVMAmgAbuQRzRkNRdfjgAZW+0TJf1POBDhVYn3iigag8kFiGT3QwZpo+ngNS1BGFjAXXp6eRnGInPrUp68g0agVK/7vKEtzuI+MaJSemRx9XfU0Qll3A33YazXJoNUU3Ah3svYHN4IOY8Sw18bLbrjvHeY6qI0XxR08V5GjimSgD3VGT7N9ZSK80S0CYv3e2PBxWVmtpw+JCwlUk4FsnGrNHuJwHXpfoYhcPoTJwnGkAbnWtHqtbvCooTSf+3L25qmFD42I5SyQc40FWDI1JQ74ZnUKK/Mf0w9GRTymZx0QUucbjUZNYk3pMeahHmR9Yww7EKpixlw6VX1JBGtpSKqXqHD7obKeG/8gSG9Gn8U50Ck1kIzxR4ckHOSpqJselXbOz8g/Q2dWTfULlkChs9LdJGd+Etop5MrX+oBUA7k8UdHL/uSCLXAIr1JSKv8nZxt+ciewHi5/AzRGI
 yOWP5Fof
 +JJG2fGlWSPWkByFYEBYqmnaE7gYsZG9fHnhrbFETWYnhQt/6ASOp9rRc3KCLIMvlHLjp7Tk1DQh1GxEfz1oRNr01xFPpzJMInYsz8VO3UvlXrNoFzvDxc+LislXP1Asn71Bqb+7d7amrz2DqZtq/V1jor9ery9MI5RpDxjJ4m03u35Vc5FzmxnKUI7twGqkI4c7Tuw1mvG5LhOwcJV2/hmDNAs//Th56f18PE1aHZs2EXHXOilSjPQAdBdr2IV4pbKceVdWpLFesSteCrKsLQVYzwzUqJCTE3qeppsiKBkdhSuuKXfSUvtqsRcTc3/ILcxM0tDDrqaV6dY+/ganbbSTjUcYM8bjUKAa7Wju6PjzUcuVuTJjRvWWenQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add PG_zeroed (aliased to PG_private) to track pages whose contents
are known to be zero.  Exclude __PG_ZEROED from PAGE_FLAGS_CHECK_AT_PREP
so the allocator does not BUG when encountering zeroed pages on the
free list.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/page-flags.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c73..f87ecb740e7f 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -157,6 +157,9 @@ enum pageflags {
 	 */
 	PG_fscache = PG_private_2,	/* page backed by cache */
 
+	/* Page contents are known to be zero (host-zeroed or balloon) */
+	PG_zeroed = PG_private,
+
 	/* XEN */
 	/* Pinned in Xen as a read-only pagetable page. */
 	PG_pinned = PG_owner_priv_1,
@@ -687,6 +690,14 @@ FOLIO_FLAG_FALSE(idle)
  */
 __PAGEFLAG(Reported, reported, PF_NO_COMPOUND)
 
+/*
+ * PageZeroed() tracks pages whose contents are known to be zero.
+ * Set on free-list pages by the balloon driver or page reporting.
+ * The allocator uses this to skip redundant zeroing.
+ */
+__PAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
+#define __PG_ZEROED (1UL << PG_zeroed)
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 PAGEFLAG(VmemmapSelfHosted, vmemmap_self_hosted, PF_ANY)
 #else
@@ -1209,7 +1220,7 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
  * alloc-free cycle to prevent from reusing the page.
  */
 #define PAGE_FLAGS_CHECK_AT_PREP	\
-	((PAGEFLAGS_MASK & ~__PG_HWPOISON) | LRU_GEN_MASK | LRU_REFS_MASK)
+	((PAGEFLAGS_MASK & ~(__PG_HWPOISON | __PG_ZEROED)) | LRU_GEN_MASK | LRU_REFS_MASK)
 
 /*
  * Flags stored in the second page of a compound page.  They may overlap
-- 
MST


