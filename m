Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D69FCA0FFB
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB9B6B002B; Wed, 27 Aug 2025 18:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 793496B002C; Wed, 27 Aug 2025 18:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9296B002D; Wed, 27 Aug 2025 18:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59E8C6B002B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:03:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 032DE119449
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:03:06 +0000 (UTC)
X-FDA: 83823913614.20.BD41BAD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5931540005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:03:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hPZoyu9O;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DykevL+FF0TVTnCIKFrimPfVjOwsHIDZG+ZjBK1smY=;
	b=fhyBDxat5Z8pS+J3UHuMg0PJhVZxN4kepA624hktaX8BP3ogHseF0cnGQd0KbuGpK8WwQZ
	l19VoG5+B5BgTAnoPOfj8hQR4J5QclpiK9MxdssZ5b6R3vNhhqq9OyYsY+utqqQoTF31VW
	YHK4M5w18GDEmxSGIMn8ZabVHMuZWKU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hPZoyu9O;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332185; a=rsa-sha256;
	cv=none;
	b=4xQO4aAhROnVFZV9Fjuf/LWZZ3ixghHijG7XqpMPGUJ371zAGMyH40JwCOHoX0HFShIFAZ
	sPMYUbhnJAY2QwwF6bEdY09E6pOIGQTQfkKXHD6Ejf3WS8lr/GThqhMlYtn3yvTERIiiIR
	Baxny0UKmBioV+Rex7OrIPhjjTIwLvw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5DykevL+FF0TVTnCIKFrimPfVjOwsHIDZG+ZjBK1smY=;
	b=hPZoyu9OtCgVCULnXHohMbkH46ltt0I2mh50xypXVDFoNtHFjnYz555TB/JZligpa4n7aB
	7zKC/xN4l7Mjv+HCdDy5pJ6KtDYNdLtt6rt3zb8/KIjKlmsTy68XJQjxV6cuFbauwdELvW
	AivoGgSkl0S211qN76Mfuu3toP1f0SU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-18-QHoxSYI_OH-QMUQwo98hZg-1; Wed,
 27 Aug 2025 18:03:02 -0400
X-MC-Unique: QHoxSYI_OH-QMUQwo98hZg-1
X-Mimecast-MFC-AGG-ID: QHoxSYI_OH-QMUQwo98hZg_1756332177
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 050E619560A2;
	Wed, 27 Aug 2025 22:02:56 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F159030001A5;
	Wed, 27 Aug 2025 22:02:39 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: [PATCH v1 02/36] arm64: Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Thu, 28 Aug 2025 00:01:06 +0200
Message-ID: <20250827220141.262669-3-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 5931540005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: sbdqotea3s3ffcu96kr7wf89jdh4tr1g
X-HE-Tag: 1756332185-431787
X-HE-Meta: U2FsdGVkX186NqS3xUliulDjtFFKqbHygDiYuE+pY2fcS8KYIh4NcegxycDI7wOJTKlAHzYbdbL5gO88QX2qJOAZa1I1p/UfTJNG3wzzZvQbe1dVH3+qovJi50ahnaX9AmylAuPiej7xtQzQOMahEPQMBYCLJzY4Ncz1LQDPDQsY3YoKUhJT88GFGerNEWSAu1HTxtUj7ZPOWefQj5ovkCAy+2GNuqYeFMxqPcq1iyX4+1ksVgmpPdVFb58hY5NOE+WwCv5zQFRIpilVFbgP6zh0OTJ1/QGTohGTY2kmS27IjULuekVStobfiapD911cPP1p+Z5k0O25ds37HXcPNhhuelObcalh0hIhioCR1Sgv3u6u67Sfdh+qlVFY8x+AL7vqcayg4xEQUdglVCZWQmRwgJ47mOFhqg9A1hXt1P4zkRK4UquN4w0hxWKanNjcfAXF09fPM6XfHYqh6eFjSFBiMSBpB6W99XeKGUc2RrQXqpfCOEDDHBQdCajjdwI5/Bp3C6YeEq1zRgiWnVhSb4DHKwIBm1Cx4z2+nYLgAJeihNuAvs/dT6vGVE9REUOKokkmjjlHBaF4TVb208zM0ALdbtn+c2BG+LcpqITi+wmlzoYyyifF0o7VGHYL+XyGri787B/pZ2AWHl0QpyN/f2hu1csgVaq53SShTPDpDe4/dnPzZRJzojxIjvi8c0d1lOwocHJThMDRi3TFARKKzZqUDWMoDEka4GSP3+yGLjLn5UP7aiimze0q0OiRYbB/dSXELyFrTj+NfZzO3aC1ZfapshWImAScGh/RreDKAWiEZmBQUbjjepkgzMgp54wtuAiZS0ecnJ9KQJE2iOKwMgEWfaB8wA8vahenBQRacxfGnTpDLb40F0hhrtQPo5psrnEzeGW8ylkmHdgkTtg26ovBmzSMXxGIO8KLRk3w+7d7EQ1VGfcAf+UDtWbHXdxfboivhZt5ZZu47La0I/c
 0R+5NA2n
 yunuqPfsNe23nnr4Asl9eXL0EVft3Aq44CaBzmpGejZRiiutqH1KEBcdyy2z7eIx/2Wbz97z2YbbflvjsJN+O2uCxSlNuBT3Tr1/jss3Ny8Q/nsAkUt9+FJl/H4Kag3aAZKiJEtCYtN4UO17NUo7NJKQvR+RNUC3bq6zjXmgNzgs/HDm8SCaHOexw0G+b7xA8+8ZW1WfkECpbRMeGc+RKSZVQgalDV3CxcMdv
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
Cc: Catalin Marinas <catalin.marinas@arm.com>
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


