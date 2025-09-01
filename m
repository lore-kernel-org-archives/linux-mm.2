Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25221CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3FB8E0074; Mon,  1 Sep 2025 11:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98BD58E001F; Mon,  1 Sep 2025 11:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87AEB8E0074; Mon,  1 Sep 2025 11:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B69D8E001F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:06:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C2485BC33
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:06:00 +0000 (UTC)
X-FDA: 83841006480.26.14CCB20
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 73D53C000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:05:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BbYNFLR8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739158; a=rsa-sha256;
	cv=none;
	b=z+WQLtrCUaXTZ/e3YVlq0PI343qBErFTzZBHrW6I4U3yNCikiHX3Gc5RzbDHEW48FornPy
	IP1N/JMfXTFFA0+Dci+FL2WJka+rTWU6Iy/weZSaKeWEsOFWiApzs2o5OzdpjNDXYGeuI5
	g+asFTDi7ttz5WvcUz/RH11DAi5wNEE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BbYNFLR8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9ikJfv6RMgWpDoO/PrbRDajESXjomPX0LKmeM4ApTo=;
	b=by+Ij/QJbPI0snXui/FlEkvd0BJeWHW/wT1kdc9z4t/6pKvghDKD48o7sFx09TewgFnNTa
	fdXsiaW36abDHsiihesQMx8YsFJ/mzC8WzyW552Zd4FPqrX3fenpCbuEVOxG0TGuqPxFE6
	AbnD5So4Dt83D/O2O7Qx+fIGPmp+NNw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u9ikJfv6RMgWpDoO/PrbRDajESXjomPX0LKmeM4ApTo=;
	b=BbYNFLR8QGiCXGp1LSI8ErvcFT9mLzrtrWAccz+kxmVJ/JdbaNUXPjtGGeaJ5avZxo8d6B
	bTQ9ffy1NAKA85J9Zlr8aUVora6CZTdiIebfrNALV/j0juTmpgskOWNEStaAAdFZygLvDt
	UTxc6pd7BogIB2Rut6EyXJpSMeGmb08=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-321-BCH8lRQHM2i3AvlSIjWhRg-1; Mon,
 01 Sep 2025 11:05:54 -0400
X-MC-Unique: BCH8lRQHM2i3AvlSIjWhRg-1
X-Mimecast-MFC-AGG-ID: BCH8lRQHM2i3AvlSIjWhRg_1756739146
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6BF1118003FC;
	Mon,  1 Sep 2025 15:05:45 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0BD8C1800447;
	Mon,  1 Sep 2025 15:05:28 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
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
Subject: [PATCH v2 04/37] x86/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Mon,  1 Sep 2025 17:03:25 +0200
Message-ID: <20250901150359.867252-5-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 73D53C000D
X-Stat-Signature: wpjqo3fykwamncw8y988h7qcktjsxyca
X-HE-Tag: 1756739158-876746
X-HE-Meta: U2FsdGVkX1/osgu+UP8pRoZkgW8FwBeg4b/gQL6UsEwpIMRDIqE5BHURADZPhzOjXp4hUpZHmFs5HkEA3OKxPyJ6/p6t966A/CzvnkLmmq4bTm24ivUIN2qfLPvX+QPeqvILIrYeEDzQF/dFBXrGZCqDaIaurcQBwKiX7vY6Lhfy32jl3+QzNSLLUyvShGlvNDISvHsMlb+hiznBUy5dlUsOByIy8m/LqF4eOwjuLJQvP+0xoSgE/fcycE2/WPOVqcD179RFzovDCGfkhkSAzaRumBUx2K0Gu6/IGzNwjF/uPQkiiaIseTl6jGDKZH5IyBgZr6SAnSgjVqEai3PknnA8p2lBHeosD/zxu6F8zg6rjIf8QHrmclrn1FvklUa8HHFC8x1UMpRFrZvRG/M92AvW+ZGJbQTLXWU4lViKWoP7TJCqjXUJ0ClDvqrgIuMtaDZd/T1rAHxOLIYwRa2IZ5pY7julMcbYpoDnmFEHZ5x6CSnV/xsipT+VlAIuS38JFcF7YpSnRsx8mCsNPR43S0APuiBvlJL1zneMBli50gSLA3crdiBUsYsWOiSyHrbOzAjcvMcAcnaqjzznzEJF1wf/3wRI9JOOKyAMDvHiFk0AVe6CIaV+OCmC81yG1SjOSi9LNGlfCyRFBp9TGKRDEcdx/PxbqDHgcBHHD2Nud5be9xcBSeWvTjKDmW114DPH2aYNIlQxfXhwj/P/Obm2mha2yKpVkGqqpnc2g28A/r1MWjt+FfKgh4s5qBy4cEh+dKH/bIpSSkSG2FvWp8sPX6WzRY8EKtyv3l/ZxXREAYBOXhKJ7Lszm4PHJ5ux7q36d72+B8CYqKP+jps1ZJEOmwv2jtvL2uRQml9jzWxegTdFrnEkaKTxgnE3qZ1xbjGiVqobfo1WYD5IoAaf3kCXg8gkv953H5VGm/oy+JJOeVp7pywWu9gg4Zu63oEUQ8an/lmHP1DWbrL22S8SD6k
 BrAPnyqE
 si6IAktqsJySXKZFPJOFCkyg9BEDOa+fIwyViWRyljJFSSf1wc3YmFNzjfY9Xc3LbgCQFH6KAOxj1HVAVDfashbjOSlMAiGU1CWoDO1sFfGIH4gE=
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
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/x86/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58d890fe2100e..e431d1c06fecd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1552,7 +1552,6 @@ config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
-	select SPARSEMEM_VMEMMAP if X86_64
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool X86_64 || (NUMA && X86_32)
-- 
2.50.1


