Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CDCDCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A8C6B0099; Wed, 27 Aug 2025 18:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB1D6B009D; Wed, 27 Aug 2025 18:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382476B009E; Wed, 27 Aug 2025 18:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 236E46B0099
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:09:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB3A01192A6
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:09:26 +0000 (UTC)
X-FDA: 83823929532.07.E1725EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 513294000E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:09:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hKzGHx2a;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332565; a=rsa-sha256;
	cv=none;
	b=tTgU0u+LZpwGbZGfc6nbSzjHPVeWKkiFHbeV3uxgR68FXbDZtEdnhHkI6TBT3VzKn9GeoG
	LyJkVtcvhi5/X/ZBPzpK1d2xT3xMRuftMGDYOU9/nAmeqFjYvHKuHO2/LaX/z1frOT+eht
	MnKYP8JCTYENuhavKTRMglOj7gWrdXY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hKzGHx2a;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
	b=EAMmJDNHu0h+0ZEHZDNqghilEU+z8c3hBHonvwKcDoVHf01Uc36BtsosUxBvfqQ16zLyrh
	MpvrQzNXprFKFj2isOPHxQO2GIyWWeqx4xwLYipP+rD/LVUn2ELaHc+cANRbtUfDEJScNH
	1tzH5ibGZ5KhpyyQHZRLToFURwcTBNA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5INZuVEW8ZoCVRVHt0CSLhpT4h786L9PUsnD4NVlnkc=;
	b=hKzGHx2a113C4ilxVbZoPIZe8NOxX/6WDsZaNeiflelIv4RYct2k0UHU/H5tfv9hvl1+wk
	C01g/oZA0B1TEmcMYl0UcbAz/gdSDfg8WN895Kt8ESC4xxbYsNxnMDZ4hIT4u0iXujUeJ5
	9LQXUQWbXeSC4Zm1U3vg91S1IYccyiA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-xy2DE7SVOeOfWFxJcT2kQA-1; Wed,
 27 Aug 2025 18:09:22 -0400
X-MC-Unique: xy2DE7SVOeOfWFxJcT2kQA-1
X-Mimecast-MFC-AGG-ID: xy2DE7SVOeOfWFxJcT2kQA_1756332556
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3265C1956087;
	Wed, 27 Aug 2025 22:09:16 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8A03F30001A1;
	Wed, 27 Aug 2025 22:08:58 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
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
Subject: [PATCH v1 25/36] drm/i915/gem: drop nth_page() usage within SG entry
Date: Thu, 28 Aug 2025 00:01:29 +0200
Message-ID: <20250827220141.262669-26-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 513294000E
X-Stat-Signature: ftruuqipt4b9j349ns46zupytgae55ee
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756332565-134041
X-HE-Meta: U2FsdGVkX19AUyfWaVEfy2E/L66j5fpvq8KcEcdVRVbCLmGbBg6JCOHk3l3Byvv92y6G2MEKYajuPubEgSQ6kc7BFsxE+3/imyQgmSwnlDcsvfWZazj1gBJ+/mDVyNPR89+2FNX7k8D+jcpHpbdihO7EKzqKQilYXAck4+h5vE4+SLYpAXXw5O6Qsw5SQbBtm1bEKCCZ3rMYElJyoMekyr4gXlCEtURlJqZoRrHnkUE/+t2VQ6y9bKAO88n0KoNzx9dPaYSmgnuiqSEirejLKBy0q0f2t/iCoQZtGX7eU6nR2EFIRzVhKPAqOMUC3QvRxBInkLG+xFRsB8LKmZDuOXWhgj06chfKvPoGXOdlhAGTP3gqbrvr/LkwXFYn3wPd6yorSk5MpCchPFh/8+ae6X1orvSkGlotZcC2rdZHDn4re3q/yGZjlXNW0hWBOSu/JmXrqxfeCt+46cdY2wLgZe9Rafm6WgxCywR68atRpwrzaZbpVenN3pgGPa2kJVci13/b3cmXFJxcF1zAiLsKyHx0/2ckJwFKNSDDgpDLxxz5YP4wSTuw3DawFaH4++fMu7d/eidV7F4I8M9zSpGjEU//6YdECCu4EXT3kN844LFKHSGmKPn5x3e6bJlyHeDwCB5XSI2eUg/KzPEx3gz98GXrfvuxV/75WlbslrJZyuOEZHIE2ngKBbnl02vL+qqjE4PXTMvdSmSu7t75zTk9wETwAtMVoCP4NlZosz6i6318hMzJyprODcND23iQ/Cq0efwNSjIwtoxOa9uOzK5P4AuO4hcf7kLTki5RgFJdCQqjozG55WHuMdZsa5wrGnHSSyqgflpbC+rKZMyF2IBhdvZtNsw4HcYcFaZef+jan6rNDOdoTiuq9QqWf1KO7ymbrukecLD4YZ9biGi/CunMEgtH6ckzJbDjx7QY8Hf9h3x9oFYpvCCwApIJltQzCZsq+ReE+OHMF1E1CknEIjv
 37VpohH6
 EOoguZTCY4ncevbtf9OBrYwDu32IeNCTYF+c2svCzh2xYVqzR1/PmrOgu6GCrdbmHQbbgRjFWSVIILmAHz+ceSAGOnoepnzGrc/m3k9l7hoygpmr/29ITKvtZXdQ/yW0a8QpMuoe7Bd3odVPZiuRG8fEdLL/pJXmzSEFbYzX1+6fviR3LsTRXRc9eMTFampFhMLJrX9qZDmbWadfR7jpkfe4lMa1jpyBRl/IL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index c16a57160b262..031d7acc16142 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -779,7 +779,7 @@ __i915_gem_object_get_page(struct drm_i915_gem_object *obj, pgoff_t n)
 	GEM_BUG_ON(!i915_gem_object_has_struct_page(obj));
 
 	sg = i915_gem_object_get_sg(obj, n, &offset);
-	return nth_page(sg_page(sg), offset);
+	return sg_page(sg) + offset;
 }
 
 /* Like i915_gem_object_get_page(), but mark the returned page dirty */
-- 
2.50.1


