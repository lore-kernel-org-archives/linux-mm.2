Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0D51CA1006
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7689E8E0062; Mon,  1 Sep 2025 11:05:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7408D8E001F; Mon,  1 Sep 2025 11:05:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6568A8E0062; Mon,  1 Sep 2025 11:05:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4CF5A8E001F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:05:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F3801608E1
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:05:24 +0000 (UTC)
X-FDA: 83841004968.02.A994F2E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3B34080011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:05:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VoSi5aky;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lga6UMMa0aQahAKpa9DbBvj6lFfUW2++fx2DNoNdxSA=;
	b=QhWb2OeFwG63nDfIpLOE6IT566I3X5//gB388c+ij5b9aeZzAn/QIiJVdicApgL6cQDm0Y
	C34pE8GzYwuG6Ex4zfpM0Z8zAcSBDJIcVipNm7UB9xmixgnn1uf6TcngcFEIGbu2Tn4Mx7
	M9w2ZkI5RVU3GZh0B9aLJYpp0j/scAg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VoSi5aky;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739122; a=rsa-sha256;
	cv=none;
	b=zznifv7U3kjk5s3BskBn09WwqWWO9NXEpy7VaU/EV6lRdIiGvBuuKJnRXcJCniOLIr3gIk
	bRLMDk16mkCxkhPcBfHEDK7+qtmOBle27cruhW1k/C0+f1R8QeuxEOxovx2QPinh++hOTi
	l+RqJvUeKtBbhxdV9EqwkzJ+oMt6Wpo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lga6UMMa0aQahAKpa9DbBvj6lFfUW2++fx2DNoNdxSA=;
	b=VoSi5akyWi0y93C4d9KgBplUVYIdZR8R9EKsNCXfObhFpf8f8/n4ttcrSiTdgf5pslHYYg
	7IOA+VnxyEWeShUWa52Kl7Sncq3FB6zkK00wvBiHZh/H/A+Gmi5PCUERaJJOo0GP/l68/g
	T7hkgML1ZzqKLcjvNqC6El7Uu94ZcJs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-357-kjaS4mfWPCWoOwPIngtDKg-1; Mon,
 01 Sep 2025 11:05:17 -0400
X-MC-Unique: kjaS4mfWPCWoOwPIngtDKg-1
X-Mimecast-MFC-AGG-ID: kjaS4mfWPCWoOwPIngtDKg_1756739112
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E3B8180028C;
	Mon,  1 Sep 2025 15:05:11 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 418001800447;
	Mon,  1 Sep 2025 15:04:56 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Will Deacon <will@kernel.org>,
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
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
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
Subject: [PATCH v2 02/37] arm64: Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Mon,  1 Sep 2025 17:03:23 +0200
Message-ID: <20250901150359.867252-3-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3B34080011
X-Stat-Signature: ynszi4j4q9qmqg519stditsnwauc1n4f
X-Rspam-User: 
X-HE-Tag: 1756739122-400562
X-HE-Meta: U2FsdGVkX19OX0it+6dc1iiJxqoddasAa0qMop9iuijxu98NOtmfeDOTreC6t+Qm+/tUo3JuYu+lMbyA/nlkXdU4HkLiKbkLQ6PLxDdADA/teN+uFgynFoMkaHxQNoDFuhlMNibymsU7HFI8H+hslnU8ciLHEbuJRU1r4a2P7E65BAYbRXtEd9X2RYm2W9pQVl4S7QYOF4eKqc+QRPJrYYNODwbA2+2KgJaGONCyNCfJilgLVkuNkfSD3DbgOY1ErAh9Rhb/ubrtwGG0wf13cCmR1DDrEUxBRAKm5qArWgr3fQcfa3BNhbzD72Af3E9e4KNeZssS50SVBpGiciaJXzm9ZdQ9iyUgWGt/6pvv/eYE1hLe9R7FyE0aE1Vrklgv/CZ/1dNBaDXyLCDNg7ZVcBflsK02FQhdob3otXlztgBeP7yehzj3ISOvOtCuJjQeoSud4Um2AN7pMlyhCH3OJj/gNwErQrP2QoiAbqseTX+kh2QOzp8TWWkGHIm3x4kSH1Wt6ONA51Qajund+TbFfzCpTHA8RWBb7l7f+iXQ6GJJzl/6iVmav8ZV4/vCFfRdu8QmtCoP+LDCRhp1mBoF62wJWwRKkd/DRYUqkS1qqOSfSjz6WDhjUiIewiBk6cH1TRz/tLGEVXzO1b5wkeZZoZ00b4kXfrQFdL9kAmDdlsOJcWGjJcKfVnETX3FgIaEHBbCmXySF7u0bi2/tbwSvEy2r2hfzjPmEBn6YsWfvP4cG6eyQUFBW+XAMpoWtnt0geySCuP8nlOdz22Iha9ZiASb/4ZQIGczQ0xnqVRM/VJ3LLkbCIEzODBv0M2ZbANmedaVy5zoPZDfFDMPFSmo53Jx62e+x7iKxyLk0RrT7iq7M1i708IPjShqVUKhztVG1Gwxm0GOnjbPD677Dirm+rGoPQ1d6U/y2kgS6hmKA9O9KjHr2q0T1a/LMpMkO3OJOXk7WM/597e7LYlGVcHn
 fLt5fTRo
 yXlkWtUlEiN4k6w4hQPsJd6eM8DuSZI/x6uKQqDjGw4w+2xZJbdwLMEf0STDqATKzJiU4tVemyXvUZkitQVUEg4XM5eUGogRPXSM0IRMsJTY2huY8a1DsNZPQ9I1ncSe7GsO8KmkvMQRonrtjFdX0I89tUxhYRthFfADGPBytlhAIJs13qEOdeDZns/bLEm/kCkh89it8y0iCLAlYlGOPDpWgE5qvTzFTB1XcC2b58ZvfpzpZ/XuvBBnUfrbKf++8EAnDWi8HeFuZqMSzB3wr50TaHmN68FT80GCxAU4tcruBecLr4/PFu1dfh2eDX5jvmzqjg/7oo6mMq94UNuTTDFCn34YJcU90u2CPQ2+06TN3/Y301JyxLD6n9GNfpbHMdCEjgsvl4s+jRvznGoxjcdLCuZrz+esivafVwaP8UwdZcfgEwBSrnKr9Zkq3lbR1IvUYNBGBQtj12jxhadHsRLRIMdl/mSr0vfExcYuHmcxKiRQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
is selected.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/arm64/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e9bbfacc35a64..b1d1f2ff2493b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1570,7 +1570,6 @@ source "kernel/Kconfig.hz"
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_VMEMMAP_ENABLE
-	select SPARSEMEM_VMEMMAP
 
 config HW_PERF_EVENTS
 	def_bool y
-- 
2.50.1


