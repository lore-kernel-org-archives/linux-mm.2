Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D05DCA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCBFF6B0119; Thu, 21 Aug 2025 16:07:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57238E0027; Thu, 21 Aug 2025 16:07:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7AB6B011B; Thu, 21 Aug 2025 16:07:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 857A56B0119
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 178C014055D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:15 +0000 (UTC)
X-FDA: 83801848830.17.C643D27
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id BBF481C0006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I6549wKT;
	spf=pass (imf18.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XmvTcrL5C0dM7rPtm73IEcsYc8PUVzmaMdzwCc2EnvI=;
	b=mPVeSMgPslRozHLQCjyAWSPT1xIco1nag46HRaiBBXqWlayRMflisbcUAiXFOBNkMhBnl7
	mEX0fLy7abPeXbQt4Ui495jRZJIFHtCuT49UmMt2aGwDKEs/8gwx4u47aBe/Jx+ZXd6bwI
	4pyZGT6lco67c3mvlyQfBQcWoP1Si5Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I6549wKT;
	spf=pass (imf18.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806832; a=rsa-sha256;
	cv=none;
	b=f6A7/YDblNmU0lrW820yJl/YvkhcPfEr4WV4AhODdSwO28AyTkD1PVceoIPdynZuee7czE
	YktTi5jlCLsY+pPONxjHZgH45P13AzIZ/eQ001HUiD+zFAsbGzTNFHySAxyUMkKfB5kpu1
	c/VkqbH+O5bnLBqVY1o/Fqs630ZNzHA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XmvTcrL5C0dM7rPtm73IEcsYc8PUVzmaMdzwCc2EnvI=;
	b=I6549wKTnM8zsqtSAt9EqBib0pAKlsIve5pXzkcRe9D52AF0sZDHqksZY9TmI/r9GkPjOC
	HnJHEDGwC1GCkp5NhIl/Hv8PnhUbQE3dfBffAoGXTv+D0MkRReq/L5UjeH0uTyO7R5aI38
	6uccE7mvE/M6aNjik0WbTBM6nJH+P/E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-3veLd95uNm2uKmtsEwm0Xw-1; Thu, 21 Aug 2025 16:07:10 -0400
X-MC-Unique: 3veLd95uNm2uKmtsEwm0Xw-1
X-Mimecast-MFC-AGG-ID: 3veLd95uNm2uKmtsEwm0Xw_1755806830
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0098c0so8404335e9.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806829; x=1756411629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XmvTcrL5C0dM7rPtm73IEcsYc8PUVzmaMdzwCc2EnvI=;
        b=G2+IV1Utg55RipOFU1FuqAAj4BNM9k7XFy25d7RAKrmfTZsYbtnLI4qLnX/rOfvjCB
         jpLtdCUM+ZTGHADZw6qDarBcTJKQKUHYUQY02n7QTxjWR5Q+5N3VKUonJROQNQ7uFPaf
         /DBBWEZKXREsMaYFct1BummLMtuxV+bNhXoRwKodT1n+SzgzflE/qoryBy7hCLfySlNt
         N7NEtGVJ0GCBvIXhEH4Q3ZZ9M6m6okTvZJBx3afUWwlC2gmw9+UT9+rMF9ehsz1GExgj
         eBMklPa9/V8tTVcohr1JBPO8FYlwhAzzPF+mxdR9ZHdt6GTzEhNHe9w6IdP5WwZ/20B5
         7SeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCRf/dcGrW6tiDAj1CMS6EMXEQLM3T4pvd0rO+NO49Bny46ORfxDaV3WoNm0dA6MgBJFdSbbPAbg==@kvack.org
X-Gm-Message-State: AOJu0YyoWdz7y7TicFKNgiyThS14JhbNbuf2axAS0yOCznx+7C0PdFVr
	JhtMD4YKVXNv8ogGI1ivVxLubJ2oBCza0P6NueWCnF5CtmnoEAxP9z4YFqxstsCaIHPiU2uyph4
	zYOZvXKUoldxQ/9SJfnzoR6UHLvjYFF/vNzxftIPV+G+Aiu1u88NL
X-Gm-Gg: ASbGncupLqnXpCW7rzN5iFnvgOBU3blwsJ4DcU12QiGvmBLVBqQ7VfE5dfGLFq5csxO
	xnlV8oMVpeiwoqlp1C6yCaLz2+8QHHwFhhT0kFg/pXeQtDelQrcO+CjUw72VIk/9Y+brXChdioQ
	+ieDsOLf9MxK9+VR7CdjqHy66XWo3BQsByK25x6D3//S4E/gFvk4g2FAlXHSILM9eNDlvNiFqpY
	DoCi9DXQAXCHzhr9litJkov9Bv1JJrSLXQ3NfG9B2JH8mvD4NIyj7b8waEfAfpzH87x64qlsdSG
	FLbddEDdSO6PwcVlkCn1Ig0mp6As8V1Cyk7TzhozpHDxa4cG0VBsVvD6NqN49v+WNb8hUlQ2YU/
	SPJZqCssYeTaJmbQ7xqlcRg==
X-Received: by 2002:a05:600c:4506:b0:456:eab:633e with SMTP id 5b1f17b1804b1-45b517c5f34mr3673725e9.17.1755806829501;
        Thu, 21 Aug 2025 13:07:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvYkVaGxfZdplMxnR9eu9+L8mDJqjqWM2enq3Cze2cE8zEp05huuco+bDpuuERUQ/1xaOAqQ==
X-Received: by 2002:a05:600c:4506:b0:456:eab:633e with SMTP id 5b1f17b1804b1-45b517c5f34mr3673145e9.17.1755806828996;
        Thu, 21 Aug 2025 13:07:08 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e1852asm8722665e9.25.2025.08.21.13.07.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:08 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
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
Subject: [PATCH RFC 01/35] mm: stop making SPARSEMEM_VMEMMAP user-selectable
Date: Thu, 21 Aug 2025 22:06:27 +0200
Message-ID: <20250821200701.1329277-2-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a0_6231qEdB9xtXnTx4YEf3ZG6S6_FFxmBRcai3sgUk_1755806830
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: BBF481C0006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7ac98bs6ewsi1g58p6f8muagbsrspxjg
X-HE-Tag: 1755806832-744244
X-HE-Meta: U2FsdGVkX19w7hPeDiU67mTh4lRKrWmcBal/ZIHGNya5ztZyE3gYxajNiAbVrHWBDdlJzMvebmiVV2aBBZgi0jg6MmVs4IXG/w4LQHHSraOo7zgVtq6PoGYkCisOeK5HH1hPIYDcHsQ9SPyZ55+ogzkTsgpR+tPs+4cItln8vbjlsDj/oKDPiLK7LOfB0aB1QwtAD5zkaxzJCMe2LRxqn6QQ+xAYWladfbnZYkeubYeC/lgyh8OuBB2RhdsXmxX/+WyfWbBKjD52y+DRZAwLUcQtxZdogZaRiRuCwjv3UbL+zdrxXO7gXwF4IOI9b+0sRU/zjSZ32Hyoro9oWZFdrFPa3I8U9q6mhpy68PctuIVO7UfPWrnVjzNYeKsXXsIyB0gZA7AkaEqz0VGqw7c76Wav6mYsbdMrasd/pJZzTOcqa2z1gte8gf7LFUYO6yD4HlmGDmIhEyHLV/VnvMrCsYGf7MRox9ZA28z6kURsEmR80XZpHWOXOMZHuhvEkA85GcL+bsCdLBEQ6oOEgLvfihutn875HAbi43bNMnD5QwCPV5sgvd8sU+It/2UgpYG1TOSO6IMjgQ+49K3et56+Sel77RiqsI3Fbxd9d7riLdfXtndKHVUBxZ+yx3QuQD1ThaKCpZX010V+JHkGlh4SQCqDIfUkmeDIMoDKVkXka9IhdKOutbdBXbBlYV7o4tzpww3pa1l3Kvsq//x2+aNquLY0XC6yDfxl8FIY1XVCQi3v74NeXnCYjOC4THRhUyV2tGF4l0wg+Tpll1bpcOfic+ryrGG/pEqFKpEvp+TyqfG1ofYHFaPM0qUJddzTlc0+8XZH1MjUIfTnjZNEwB4xHGvUpzvSkgUvaWm7RwhGP071ZQ9aayAkw8bb5JEpvRMPWKwajFTJ0wZcI7rVYs/u2w7DXy4XmGaInJ/by16a8Sq178LO3b2JL5tpzsWPxW1q8kEokpxkcLI/R80WSiu
 a4rJwmwx
 nNtNVvYWZMAkn3MVbC3vLyEQOc5FuAdPrmc3UV+AzesgHOPuCSfqdcoSi0S56/aCfBeMLlW+iGo4HAQrdxGuDqkZyN4C+TkfMxLiAhOEQh1jNmeQat4/YJd3xNrLUprN8wNI3VMGPORKjHeHD+gfUqtgGMq2TvVBbXQFd2oiOls6tI4fdxnEFy67M6Z4poQZAhItaXkVpSFVFb9JfJQAv8BNgBGkbzZUew8pz13SYMgkOHajy1h4Bru6sq8xTszfeb6/aa/a+CKkluVz2SfY1cucKBvPhixtsiCcLwqV9Vb4u5E9ktq/hlnlFVYDsY8QP6y5URgni/RjtXxojZpckJo0fFGQBjTvMkHZmzSNAnAUr4LEwv813AMqel5FKLRcJwVIvDQMBy1AfWDLfF3Es1xRbbLYUL3UJlfIRfIx58abuF2b66kNmVdZWAUeqd31oncQm44DBcMzEQH5VZ2LXttWzmggaAjVPhBx6+AnrHaEEbeFEWAJuwH5VlvGuNHU5WHQJ0dce9LTz/9LUkcpX6+VvU3p3qiEYXOYFuHrg95ctzwH+uvGr9oNmgKdU2WBhBYBNshnoOI74/loZ47zjYcHdF5p8czxf53KF20fu0OKq3g8Y6cNIltcuZrAqdgEXmrQ4wZv9nu0VFGolaKQKcXBk7dN8Qhb26wGvprP565+uk6giX9/RT6ucuNU1Wu65L2jUawb7MnEkDqbHNT8QZfimJL/2TUhy+btbeznYj8bL5Iw2bpEeDOwMIpn+fdN59i24gafpC7zANylq7zUuddm0ARWFH/NM9dbNDuZIafpeQRBo1GNF3r6bHnk7wj9vSKi+otTbgyXnxRkqBWJ07HuOm1VxWdQgwN230mSoGp6toKcwlF62ZbGBoVvJ8d5jFExQMvB6gurUdP8v2vnNzs0795GulLXpO4uvErWxUblW854=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In an ideal world, we wouldn't have to deal with SPARSEMEM without
SPARSEMEM_VMEMMAP, but in particular for 32bit SPARSEMEM_VMEMMAP is
considered too costly and consequently not supported.

However, if an architecture does support SPARSEMEM with
SPARSEMEM_VMEMMAP, let's forbid the user to disable VMEMMAP: just
like we already do for arm64, s390 and x86.

So if SPARSEMEM_VMEMMAP is supported, don't allow to use SPARSEMEM without
SPARSEMEM_VMEMMAP.

This implies that the option to not use SPARSEMEM_VMEMMAP will now be
gone for loongarch, powerpc, riscv and sparc. All architectures only
enable SPARSEMEM_VMEMMAP with 64bit support, so there should not really
be a big downside to using the VMEMMAP (quite the contrary).

This is a preparation for not supporting

(1) folio sizes that exceed a single memory section
(2) CMA allocations of non-contiguous page ranges

in SPARSEMEM without SPARSEMEM_VMEMMAP configs, whereby we
want to limit possible impact as much as possible (e.g., gigantic hugetlb
page allocations suddenly fails).

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 4108bcd967848..330d0e698ef96 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -439,9 +439,8 @@ config SPARSEMEM_VMEMMAP_ENABLE
 	bool
 
 config SPARSEMEM_VMEMMAP
-	bool "Sparse Memory virtual memmap"
+	def_bool y
 	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
-	default y
 	help
 	  SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
 	  pfn_to_page and page_to_pfn operations.  This is the most
-- 
2.50.1


