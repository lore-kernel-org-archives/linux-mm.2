Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5585DCA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D058E8E0031; Thu, 21 Aug 2025 16:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB6D58E0027; Thu, 21 Aug 2025 16:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57368E0031; Thu, 21 Aug 2025 16:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4D68E0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64A63140528
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:46 +0000 (UTC)
X-FDA: 83801850132.04.31D3279
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1DE8340010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gOheJs02;
	spf=pass (imf01.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+ehuLujhp6/6Ui8/ETipqTmnVB5w2txW2o3jJCUzuY=;
	b=zFQEk7U1MN9qbePIHq6XXgh2/CaC58L8J0/BuLIneuzaq3SIUcwEtWkFWTtmBuNBHvo4Rs
	BcEMUSyubUc9e865f8qRxkxsqGDUvtTZHI1aPfdUXs8TsW/L4HaMr8tdWQ0WLQoeiLcr8w
	j1xEFvWM0QxLUW2mDnsYW4xEqbQ+b6o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806864; a=rsa-sha256;
	cv=none;
	b=OyxUc41T7vjMNN2vk9ZVNXJTCvo75BpHD71zitZm0pT04maJJmRXlKPrJoHrEbVL0xQQcB
	rFnudtLh1J2Tt9FPOO1UdcF6UaN7nkGy+O2j6+x5Gu9Y3qfWwwrerAXAk77JmUo5gSpSZA
	H6x/AuwIFncDRCdntC69so4ESzdUITw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gOheJs02;
	spf=pass (imf01.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+ehuLujhp6/6Ui8/ETipqTmnVB5w2txW2o3jJCUzuY=;
	b=gOheJs02fDqciUYT9xRdPHn4FQhz9D1GLPBC/jCPs+FxVCuj1so1qPt8GKhV/aqc7VNZLn
	42u6asY68i8eUT/2vm8rY+hUeB8ikALDnIPKL94O/M0RI/ReSegS6V/kgQVoqSKujztwID
	ED+bwRBtIJbMefyqXbnyJV3cyyy3uho=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-EOT6KaH_MYeApIZFXNQ6pw-1; Thu, 21 Aug 2025 16:07:41 -0400
X-MC-Unique: EOT6KaH_MYeApIZFXNQ6pw-1
X-Mimecast-MFC-AGG-ID: EOT6KaH_MYeApIZFXNQ6pw_1755806861
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b00149cso6294625e9.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806861; x=1756411661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S+ehuLujhp6/6Ui8/ETipqTmnVB5w2txW2o3jJCUzuY=;
        b=shlryuWLbJABnnbE2M9edT/VdxHBH2ESOjz6Nyh/3igBwe4eZkk7Tvyfw6ZbIOz2Bh
         dRyIbalLAyNh77DmHgjG/jGsjyTe1nZBb33IAnrSlLgWzpETMmg7BrZlrHLo9YqE4Fpa
         F28x1D/8CQb9bc72IGaDrqaCvqeSFoQRZ3IRGDehFknuLHTJYD6/tv9HULSRzui6XbUJ
         V5zEAaCAd3IY9/ff2fUv1C6kop9A+1xRC4Vg7nOlpWXPQbAOkYMsh7p1LgAJNHVASJLj
         iiYmyieDAkqEEsmsv7fNP8a23jcQ47OCl0ybDXSxnOtW96kk3govDR/APq8ZxNlIfNiG
         TRww==
X-Forwarded-Encrypted: i=1; AJvYcCXIznZOzJcdnvFkDq2P6E6ZegohWkJUZzVFLOdW7yCdzjEwJoSpvwQUdtQEQXV0pelzNmFj5hIiDQ==@kvack.org
X-Gm-Message-State: AOJu0YyOHDLwXW6iD+7/3WVjYSXLkAq+PKQbpK/KROyhbuyW/Q4QbfIj
	Kj3VpvzlwNFOLQYuXflNyFqzqiy2/+A7iQYWKyiPWAG642GwEpVfXla6bj6CMsSxylfuuukWR+X
	ftHeayuMyjsOtAKbqZYiaqnSOa/xuhkyseOYG+YZ8rdVeLUdj0kep
X-Gm-Gg: ASbGncvR7w5q/fn12rAn+BHQX1wUXQpFtfm3WxMIZ3KrB20BAwok7Frmzm0EKFIY7lT
	68wYjE/PJpkPHjrDR6ZUxVOhM9GjFkAKMQZfbc/CEnazmNba1/KTYr0GMjK0w64keO3Jr2rAv9U
	Xg7Pmhe6N6JNdLVe8MyVFoBtOODiQgIZEcgSbKWMhxGMiU1naJneYXSlZrPrKAgeC/4bEzaO7qL
	P/ARMCLD1tlAL2dxrG9uLLfxIY6gNfsAo3fkhTLzB7CNpLFAvEgRA8AYWo+DKFlzJ/S4uIY/3gj
	VD4ZzOnnfh8EvwvAEViFyG/Wty/Nz7DdDa+dWuYvY2aMW8uLv93XTuYdxVfjl++2ra6avvOI00P
	O6dG9Pp1pByTR/kv1OOH3vA==
X-Received: by 2002:a05:600c:19cd:b0:458:be62:dcd3 with SMTP id 5b1f17b1804b1-45b517c2fc0mr3572955e9.17.1755806860551;
        Thu, 21 Aug 2025 13:07:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrtwXyk8M0MMGhBsDq6sn2/zjKB5pcui5JGSP2GUX5VAX4EhNVsrp5ZVJRMStvpa9W7AdEeg==
X-Received: by 2002:a05:600c:19cd:b0:458:be62:dcd3 with SMTP id 5b1f17b1804b1-45b517c2fc0mr3572545e9.17.1755806860106;
        Thu, 21 Aug 2025 13:07:40 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e3a52bsm8600375e9.21.2025.08.21.13.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:39 -0700 (PDT)
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
Subject: [PATCH RFC 12/35] mm: limit folio/compound page sizes in problematic kernel configs
Date: Thu, 21 Aug 2025 22:06:38 +0200
Message-ID: <20250821200701.1329277-13-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JQ5WcKBAYlB_ob_qZFmZ-_LpicXsbAFEd3LxLXUqSrU_1755806861
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1DE8340010
X-Stat-Signature: hqyh6qa9f5jiskayzi8nptp73uyid731
X-Rspam-User: 
X-HE-Tag: 1755806863-116047
X-HE-Meta: U2FsdGVkX1+yNmf2AkdTJOLdTjM0iOoCN1Fq7z+z7nkpMb6hinUUTX7yjTRsO7+ox5kg1kEp/K46dSadrHlWmYDEsX8iPtf9z3PqtZiHeYQSpnXZNt0oaZL/nUXtQCxf1KLYfgTB5Eh+7THauBjcxnVuzP7XARjaLtjwT0+m5QJW3p7ULQBLsOYKoHfiY7unO+ho0nN7VAtruyXnkQZvU0AcyaQ74P/iB/uXWAs1CCWw7kA7MKVA8s/lglqPKO2HE+Wxfl+LcegS1oyVI157Lz+ZK9p9pIEJx8K1uOt/cKpteC1ziaPkGLbenh8VaaxCAsu8OiTHLDv4YmeCYUx8luz7BIzb/hq5gxdEzPhaG0LbfkhLjc7SGgrGMPWBXOApbBCOTOnQlTcrztt7YhoTvSdW44wQr+W4uhpWiPK+XGQXBizjHo8u3QfgDfYtL2zJG5WY4JGnbKDMzykIW4KtZBEk+texM9QIt6At94/C+HtmnahR9/LRqOKxFP4SO5u7UeyETO9bdi2HHKAuVNS6vu+hht9vo7yPq4uN/tWZt26zWSo51im9qluvMlteEHPuOtB94Tn7RfTJgULpD1sMTGYeRn9gO3HxFR8fpk5o0amkTY/iRVII4U8yk/jvtTVP5YCfH4NBR1cJmboVA3LHNyJyt9Wfw3Qb6BVkf2Dgjn04xTOJUfsDY/GlKlpVVIHtzy8agvA2f0zsvrb8wFzegGVQ3eSZjrsy4fakavvHMfST8iAr7otfFByeigLhFWT28y5Dno/zqgwDkRo705oOR9JaB0lgr3HxWCeuqdtCiHhzBigAd7kqmWcuSP+n9LLHnUutVoW+YN9udgbfc045QoL7dHMUbPk4F+k+RrU/BFOTXS9kkJ5Wi5YwFVbvFO15VzO7v1tZffbMGkMnaPMeb7l5z68XEe5rGpbKuTxRg/xyYUP5ccN7aOW01vDAPaf8PEIaM/ilZVJYyhVCZnJ
 KluEGDqU
 AT3Er5mef/mFjhNkkUOduURKYIveQrt0MSydnTU9rRY7xvIcFBNC2Xtja/nCpVYS2NI87N3TRuhZFsab5qEBqFrh149Gh1p1Qh4Lr2AgUHSrXAc9YGXhf/ZCmxwUAr2UMVNtD1pXWC/onBc+h5M7IYh2VbSEooe8wZndi3qka68PM/AEIiUp2MkHmc6fBR9/8lB/DOvk/uXzc9rqadZVIl0dzuw7tU/KYwOpAdVHuZho6T2BD14hYyMB/wuiws//cfQgXuTwuZKG93Ao64vHz49ybn5S9etndc1CuB4TuGAFjdbb2AGHAKFV+GkkgUao0dBrejFfzwyS4U6pmPft2eBLb3XGZt6UHVmCOezdygpgltP3kk8hZvtyYhVmxhA4y29HkY8gobFsCzhOkT3U3/lkksorR4Lnzmuyx8Yn6hzVPcEav3Ob03NYFMYS/0m6fdxo5qSx/U61mSgvs3dJIa5oDtfxk3Od61vibqSZXtGut3hXxB5NZI3cVlCWsGOpT7bKrpMID902agPaU/pDPMjuxtX1XLuJD0V2kgeyEgObbbOs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's limit the maximum folio size in problematic kernel config where
the memmap is allocated per memory section (SPARSEMEM without
SPARSEMEM_VMEMMAP) to a single memory section.

Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
but not SPARSEMEM_VMEMMAP: sh.

Fortunately, the biggest hugetlb size sh supports is 64 MiB
(HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
(SECTION_SIZE_BITS == 26), so their use case is not degraded.

As folios and memory sections are naturally aligned to their order-2 size
in memory, consequently a single folio can no longer span multiple memory
sections on these problematic kernel configs.

nth_page() is no longer required when operating within a single compound
page / folio.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77737cbf2216a..48a985e17ef4e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2053,11 +2053,25 @@ static inline long folio_nr_pages(const struct folio *folio)
 	return folio_large_nr_pages(folio);
 }
 
-/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
-#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#define MAX_FOLIO_ORDER		PUD_ORDER
-#else
+#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
+/*
+ * We don't expect any folios that exceed buddy sizes (and consequently
+ * memory sections).
+ */
 #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
+#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+/*
+ * Only pages within a single memory section are guaranteed to be
+ * contiguous. By limiting folios to a single memory section, all folio
+ * pages are guaranteed to be contiguous.
+ */
+#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
+#else
+/*
+ * There is no real limit on the folio size. We limit them to the maximum we
+ * currently expect.
+ */
+#define MAX_FOLIO_ORDER		PUD_ORDER
 #endif
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
-- 
2.50.1


