Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A1460A2628
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=hqJUdxOS
Received: by kanga.kvack.org (Postfix)
	id 33EB66B05B0; Mon, 16 Nov 2026 18:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8106B05B3; Mon, 16 Nov 2026 18:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1423F6B05B6; Mon, 16 Nov 2026 18:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA0976B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:06:51 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A057401C3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:06:51 +0000 (UTC)
X-FDA: 85442519022.17.A210490
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id 61201C0003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:06:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hqJUdxOS;
	spf=pass (imf10.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.215.181 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGcgw87oL+/aayCG1LZRiyRs5ahRDiLzP62eRx4RAEM=;
	b=5c9BbbpPmYrqiYn8m7v6Djq8WX8AYAysJVaC2uMxuHNhJ4Ba2tErLAlS//JiqZtPkma74O
	u9tnaQbAv+vGVicK8yJWxb9wuXTmT1lt5EyU6B+OpBe5zZ8BaHGuArE3ZHxNhidnOPhvZy
	E//UenkkAEqYgpUir6cj7gYNbK6xy0I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870409;
	b=AZofZIoo4Gb23c0FjxB9WxSoHPQgnXzLt7eSNw5CBTkCqzZwiZ2w6IZCN8hgxNQOip8hyQ
	Xh3poqADyoShsMbV7kzveoA5X3DuDQWznAGbjk0X51PuOw0fs9toZWoIKP8DugZ+489qZA
	8SZBpSwDGD4UYKoOMARH969DBYKlmBQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hqJUdxOS;
	spf=pass (imf10.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.215.181 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdda6625e2aso221901a12.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794870408; x=1795475208; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jGcgw87oL+/aayCG1LZRiyRs5ahRDiLzP62eRx4RAEM=;
        b=hqJUdxOS6ZJjg4W3KAMTdMHPr8lZ3KZq4cB/atSbsnYYCUsOGdm0xRBbcnVqOjGSJr
         iPZ70V8f43eVUEYwRDdk4FYpIwOeQuYc0FHqyuFaQs6NodQSIGRACUwML9FIKWILbFfy
         XpMVYX2gcK7OlcjsAI2izSAb3Ro8Wqmor384A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870408; x=1795475208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jGcgw87oL+/aayCG1LZRiyRs5ahRDiLzP62eRx4RAEM=;
        b=vcbUSVPPrMV3A/VsxesbeIYe79HPrLs+c7Ja2Wqqk2hUtwlhIZrkY7XVeMohfRQYD2
         T9aDr9Nwoxhxhknemh2AOtAOLfUstNduEKL15ESt6Uw7ghY1npXlpzyJoHexlXxx9XaN
         f/QxWq01h7/qscKI2Zt8WP5Dhd1vIqaA+6PYh8bXJNBmvNcVnx/ii0OPkTMbazjdZV0m
         FHSRtUS4hiaSDQycCs+z62/Ym2dq9UZeK/SREoBcraAm8pNEtxHvXJr81dZBKQet2z9t
         lip/1pgZ6TLblFlNM6SKo0qMFR/aMyJrKO65gPAHp35aylm8rHGPie2NwIs1vjL415eV
         tpDA==
X-Forwarded-Encrypted: i=1; AL+hErG7VLCclKxDBYc0FEfWCszGBZunsqnYkCKgb6fyTTx/WvRcwi8gP197VaAMB0C3MAB0Bape2f9AjA==@kvack.org
X-Gm-Message-State: APuU4Z8q5edIIxZIgNKtjwcdDD9T9HqxsWZ5liP4JYGGfWwy9aRcxA4b
	D9eEG88zblJygRPzxCTK7PFCYqZrpcUyGySQMBGIcmnAkOZIihGPDel1piDYRQ4wRw==
X-Gm-Gg: AZFdTZeAK0evY5t69jgkMYJjtZ1L4T/U5GWfQYPnpjcy99Z9ihYhpAmT78KZYGIXOhC
	2c8VDy6/y6UkjFdpxRrJgE9U62N8MSsQWk8ESZLsKfX05ziHytozhWak/n5iYlKUBdTa5VB9MvQ
	ZTJMSLXSrJHRdhV9xVyY5QyRS3fxP2kLFOQNms/Ie8Yul0ZdTfxHMDvAltnG8ZFv1/7Ah0/7oFr
	xqcQq1i8wsskIVOae7PVatY7xMClN5RXN3GuzB/76ww6STlw9KLu5myZ0fLK7JVsxD4HRc74j74
	qkN85miI7eNiFMSazFHztoxXPpFTX+LUhVr1hG5uSCX+xky/5vewy0a8Y8IGQ9JoVokvgXWCGmv
	bcGE3IkqPiSvTBt9o+SiDb0Y3hMwVSl+3NT9Q8PDFLvYbLRb8ginNue8ackl3D98P+pVp5nLFbs
	2PC0fsD/d3ws5OwNvRxgow47dq6OVhFv/29k44GbgDyX7TtNl9JRGMXHs8tpDzrlIT1sMqMfo1B
	fIQ6ezKXJnAbmpLT8LDCbop4xsJUIEAuKQLiIclRYPelTyiwNBNb3NVOyptGJcACtGmibaohmBc
	0RyhvMfyDWa9MMpm/M2sw6Rom31doTpkro8UC7gR2kd+WCQ/pEKHGye6cmRJuZFjKrbXZwg=
X-Received: by 2002:a17:90a:9f98:b0:3b3:b15f:eb89 with SMTP id 98e67ed59e1d1-3b3b15feeb1mr321766a91.1.1794870408006;
        Mon, 16 Nov 2026 15:06:48 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3b3ab9f3c5dsm1108222a91.0.2026.11.16.15.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:06:47 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Evgenii Stepanov <eugenis@google.com>,
	Ian Rickards <ian.rickards@arm.com>,
	Jann Horn <jannh@google.com>,
	Jeff Vander Stoep <jeffv@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <peter@pcc.me.uk>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kexec@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/7] mm: add GFP_HIGHUSER_KASAN
Date: Mon, 16 Nov 2026 15:06:21 -0800
Message-ID: <20261116230627.3537051-2-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
In-Reply-To: <20261116230627.3537051-1-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mrsgicyyp317r3fgj6p96wawbmrw4euh
X-Rspam-User: 
X-Rspamd-Queue-Id: 61201C0003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794870409-447241
X-HE-Meta: U2FsdGVkX18YqgXkcnNDdpSmJqaS+R20EnttpfgJV91N4EbROmgec5FhecR+9BW2xp/8oMfSEOFhznoYqLFczKl038864fdkxeQ+zvhq3rYl3i0Y0sw8DE+SmaEjv8DEsfhxPMNZfJBdduhRld07pUxI3GsQ7oBBhOwGvgJaID0sr/4RiZc9YwX149Spaln+EM3fkMo8xSAGueU1VTjXi85Tk8QhTq4EtmoxGYvHiI3oWCyKJMpnN5/Rad1qv3hliNWjX+iMF9u4PNLQsdblepn+iNrnijOLvA35vZ0+qJ1XRceiozpDHnqtbNaRuji3Eu0I34BWOTLAGGAoJ/iIUz3Ha+r8erBeNBbbI8kjANIZgvg1IaYXIBGH5Zl+g8VQnTezKKst1SzIFXg6X/OxYtbp0vI6LP9LIQKlxoEqasZ/WYm/JaoyWA+bYeAFZAHBLQtGSZC5wm6blrCr/831Sc7P4AaE3bAl3H6Ge6TrhWzJ9c10gNtdwD+upU0gBmu1AeXOOPsEh9mHBu69FCaEfETdmP9Scu4ubfASH5Mlxej/zNKWQ5X2MNBo/25y18ZRH6Zk1w8HpUCWMeHzDGzy+NNKOiOy/RyxRIAqRv8fPByYqRVBbXCz/MUtYlY/ZPuL1WKKmd60BWFLUnrRlvgZX45URmiqiveraZ+QbAL9TD6PqZ13+KVPf7d6kP3ZTFdeNZqeGAoztltG0Fs1SunmVOnetx1mQsyHXkjQqS5kCsSeXBagRuC9gULK9TVbinAcP63e7SCNcvIsktCaAKpEJLvuO8MoBYqnr1wJUjdS75SQbOomdZ2Rsj8w7/O5zAJAvMtHt2Q4oTSPC8ArlBu8jz6bb8ezVZyTKnO9b/4XcgShxil7rG0rLqFkFxFOiRBohskC4/TkNjWPeD8CmBCncLRxGKbWjp/zGkXRxq/gJeDPBhzN5nN796HVLTmZWTo8H28n6DY8fmHYsJh+6pO
 NFnfzIZ+
 z9bG8//RtBEDxyRL604D35rsoqSShmOeeuynPJZw43e6YlNbBEpWg26QsrCDRnilF0rBRcdRt9FX5NH2rNUBr4IW4x3gApak9iUxGhnBXxzecOVTu0KgkBwqUrIhjkddW0QeBmw7stZ3lyiP31cTgADiVkVV4WHXc/95McazkvnryckdoxqcDRqGVyqhENR9Ik3NA4kwe1jLJ4BsoCc5iXvTqH1xgOmJXO6FM7a6z5x51c4BVCJVeY+fdki9N2fBwH3svfrLb04pQxUg7i121aVFqU0QwIHtyTWgHUfAZQxpsU3Q7LDDVZnwqBv1XpEcd1GMLFUYwegH9SsS0MguaMGGJ4GFkh0x5xk8L+vkR5SxgtKEzDA/Bucub6Tn5LmXyPNF7u4Yi4CCQ/3eocHcOT0brFnSG8ZDP/oSPbLaZc0idmcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A later patch in this series adds __GFP_SKIP_KASAN to GFP_HIGHUSER, so
that with CONFIG_KASAN_HW_TAGS its pages are neither tagged on
allocation nor poisoned on free. That suits pages whose contents belong
to userspace and are mapped there.

Some GFP_HIGHUSER users allocate buffers that the kernel itself fills
and drains through kmap_local_page(), such as pipe buffers. While such
pages are tagged, KASAN can report a linear overflow out of the page
and an access to it while it is free.

Add GFP_HIGHUSER_KASAN for these users, so that they can be converted
before GFP_HIGHUSER changes. It has the value GFP_HIGHUSER has today
and will not gain __GFP_SKIP_KASAN. The two stay identical without
CONFIG_KASAN_HW_TAGS, where __GFP_SKIP_KASAN is 0.

GFP_HIGHUSER_KASAN must not be used for memory that userspace can map
with PROT_MTE (anonymous, shmem and hugetlb pages). Userspace sets the
memory tags of such a page, while the kernel keeps accessing it through
page_address() with the KASAN tag from page->flags. The two do not
match, and kernel accesses are reported as KASAN faults. arm64 does not
reset the tag in page->flags when the page is mapped; it relies on the
page having been allocated with __GFP_SKIP_KASAN. Nothing checks for
misuse at allocation or mapping time.

No functional change. The kernel-doc describes GFP_HIGHUSER as it will
be once it skips KASAN tagging.

Assisted-by: LLM
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 include/linux/gfp_types.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index c1331bf0b239..567c93fc1cfb 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -356,6 +356,16 @@ enum {
  * move once in use. An example may be a hardware allocation that maps
  * data directly into userspace but has no addressing limitations.
  *
+ * %GFP_HIGHUSER_KASAN is %GFP_HIGHUSER for pages that the kernel itself reads
+ * and writes, such as pipe buffers. Unlike %GFP_HIGHUSER it does not skip
+ * KASAN tagging: with CONFIG_KASAN_HW_TAGS the pages get a KASAN tag, which
+ * page_address() and kmap_local_page() return in the pointer. It must not be
+ * used for memory that userspace can map with PROT_MTE (anonymous, shmem and
+ * hugetlb pages). Userspace sets the memory tags of such a page, so the
+ * kernel's tagged pointer no longer matches them and kernel accesses to the
+ * page are reported as KASAN faults. Nothing checks for this at allocation
+ * or mapping time; those reports are the only sign of misuse.
+ *
  * %GFP_HIGHUSER_MOVABLE is for userspace allocations that the kernel does not
  * need direct access to but can use kmap() when access is required. They
  * are expected to be movable via page reclaim or page migration. Typically,
@@ -377,6 +387,7 @@ enum {
 #define GFP_DMA		__GFP_DMA
 #define GFP_DMA32	__GFP_DMA32
 #define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
+#define GFP_HIGHUSER_KASAN	(GFP_USER | __GFP_HIGHMEM)
 #define GFP_HIGHUSER_MOVABLE	(GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)
 #define GFP_TRANSHUGE_LIGHT	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)

base-commit: 4b028d0cedf95f66b8c5294fde2d7d698bf830da
-- 
2.56.0.611.g1030f0b940-goog


