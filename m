Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B40F7CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A6A6B0006; Wed, 27 Aug 2025 18:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041C96B007B; Wed, 27 Aug 2025 18:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99F56B0088; Wed, 27 Aug 2025 18:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D805D6B0006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:03:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 890161A087B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:03:42 +0000 (UTC)
X-FDA: 83823915084.29.37F5915
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 94E1E14000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:03:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A9QSC4g0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332220; a=rsa-sha256;
	cv=none;
	b=fVXXljCKCTlSPgzY/At1sanh654rNNF5iLbldLr9esaomX/EALcS69kGDqzMt/hy3dtjme
	YUIJ3WcnWA22MGye5N6plswSzkNIT124K0cjzG5/6DMHwDjtpde5myhChuUIZRWoDABiFh
	FiaxgW51xX6NjYvP/6U8fcdSXYll5rw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A9QSC4g0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoCigziN+sd3886gtncwVGrOobwk0eDvjUtVkuDjFuc=;
	b=AD0czLm3ZGkySWmOsO1OygGSISV88cQsEXCj3N/wCZd6a4sKaWisMsqbaKqDsN1cGCJj5T
	EHBuUpz0N5qGwl2/NWs+J3E1uTMpKUQf2v+5h17Zr+Trzds60k1EXRGDTpngsmGTnjjzxx
	xmPIFnwhZL4KbbH9wlTUxSCezBSgFO8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BoCigziN+sd3886gtncwVGrOobwk0eDvjUtVkuDjFuc=;
	b=A9QSC4g0CGzrVfvhtWAEcGT6ZhURCbFxtuCW34qMtP+EPwfb4wGA3PF//rDA2fy8UXX7KI
	Z/uY05xT9TlLHbEY9uu11nB4Dqaeb9AlHsnpxVSyifBidIkzQ+4wx3kqgM/fuujNyxFo41
	X3+n0lUb4kel2uDwn8I9ffNrMQavl+M=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-389-k0g0ERAQMDW3c6U23kRavw-1; Wed,
 27 Aug 2025 18:03:37 -0400
X-MC-Unique: k0g0ERAQMDW3c6U23kRavw-1
X-Mimecast-MFC-AGG-ID: k0g0ERAQMDW3c6U23kRavw_1756332211
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACA3A195608E;
	Wed, 27 Aug 2025 22:03:30 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2E8CE30001A5;
	Wed, 27 Aug 2025 22:03:13 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
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
Subject: [PATCH v1 04/36] x86/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Thu, 28 Aug 2025 00:01:08 +0200
Message-ID: <20250827220141.262669-5-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 94E1E14000D
X-Stat-Signature: sxgi8rhnj4mw7fg6as4nm3g4td9qytm6
X-HE-Tag: 1756332220-753669
X-HE-Meta: U2FsdGVkX1/ejsQV1GswnqB2fiRBPGSr3c/lWVcs9Gh9wQkO1u1dcZQ5gB4Qm0hJgV/gPPW6lZZfDMRGLMRQMUDSUZBDIs8MrdiC1kVek3Qfx0XFDRK6979kNg5ATBq7ob+s/XmgrsFwgCC8rQiJjLK7PbU7KNEKskWnN9bxknfynChWIACDIwc5C/+wYtFmfLwG6ukumyRcauwh0tEC2eu0ndV/NViFv3S9shYKrd8AoWetH+56IVBcmBMN0N/eXBXOq6EiIetUKAH5q+4aaCE9A3tkg5TL9eY+v6qC+HFYG14VGRDA26MUm302sc3GzU4t5XuaqGWidF9ejDBmcKE9v2c7EeWZjy5B04rueoxXjIp8Rok87rhr8HL1Nc4QGfaKDlST+Zx3QcjY+qPipg2efaksnaHqQag5a2qDAlUPqQ2AvLBsQtRhxwIz57vqUPJuuM99fW7czgzGHFuaJZiQxD1QpzWa5QZW4HD+WxSQW2geIHXfpkL0STNmoa1RbcLDtKjdiR8kRq3LyOW7WQmzocxGOyt8TqQEcFKmbaIuSn3z7ZxSOoBtW8O/FT7S/5FXr1gIuuMbyzG9NRN4zyelNuPUL0E+fSkkuW88vlUHX+S7tnBdNVpPRxV+Sn7LglZH/vXC2GQMIZLr0hXP9+II3xEIL/3G6RhEY73fZnJvgefxRpu0nUB99XJUtrBqnDb7wxiM1nwq7UXDcll0X1+dNq3qbQPFFHYp1WkzguAGcZB0/vqU7atS6spkKnZcQZPP0zlmY0yqS7zlr7ILHDZ8BUYY4sGI87RFVkBBnvKcSi8iPE72Ff0yLo6cUphdH5fU+biilnX6VxdBmjfLRKk6DLPQEGaCBVPbwzVLd+0/ntwnYwWPjfXoxFKueS7SZPJCKo0esB+LEIRR+m2/dJm7wqSnEDcVk3OGPOQO0g59F6mLVJJlpb8Kcs7Wvp1Va89Y2BWYR5X+2OwEXEb
 E5725FA5
 oifKIflBffc5VCRr++jFSO/VDGSDJqv+Md7Mplbv3IiFGG2dYMNnYKsqLXtEDYdAjlYNZz1wCin7ckJ7AWJ3WkgWiGPCkYdB0eUx32jcRUGNGhRdlooyi/ycRqmu9m0Hveex8tURB8dw+zNcz0+0l/LYl4HhNbn/10+CH0zJ7H3L13/JDZ8n5foQopD1+hpfb3YYa51QdLjI8RxKCC5xkRacizVafiLitGqUnzDr6WbV7f7SX3FtLg5tI/HdCMroAIIX93leXJIuy1+KBMTc9MZDKUUUeyZ8qJzOBraTG0Kz708qNNM0MwrxaeilAodVFV/Ol/pM+850IKpfSjIx/UPLy5ZbDcpABnjGuS9LQZ/QS3fMcWHPeI6nmwcjM9J8oLp+JkIIQnGclkvvSeOcN2DXBk8VGxsVfb3c9ELRkHtA8HjuBT8vyUEZhJtiWDfefbWYYSFYomIj899UeI2DpKG+Nf1jGhOzLGy6SVEptpfIU2zdYyzKNBMtWq6s6nOQ+xOkRlkz1R/mnRNSRaGLFpHTwa9w04tVXSpfW
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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
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


