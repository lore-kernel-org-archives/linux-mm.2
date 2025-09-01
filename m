Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97D7CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0AB08E0089; Mon,  1 Sep 2025 11:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94518E0084; Mon,  1 Sep 2025 11:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998AE8E0089; Mon,  1 Sep 2025 11:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7CD8E0084
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:11:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CB4D1608B4
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:11:27 +0000 (UTC)
X-FDA: 83841020214.20.1F55E07
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 80214100009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:11:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FZiMXx7r;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739485; a=rsa-sha256;
	cv=none;
	b=pJAx027s7g6FB2TtkrTJUyn16VbJwekfL6vUKePbjNSvG1/aMeZQh8wEmwj5oseiO2VxqP
	Pjobo4ANY34gIcLOGZvibUdN0w5AIMI6XqYQD+jME2Ho6VAEGHXT3T8nHnJ2+2LvIB5Dxr
	Re+29FIEYHKlvJ+cw3Z2WP4JyEo6sU4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FZiMXx7r;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAbURELJ45jcqE6eG2dah5q682UY9xPl8wQ2wDImPZA=;
	b=wenssv+OnAFrwcVhqFvhPoolsLS1a7G0RxzpaJwpX5ATgEcDyuYVrT4V4EsjA4pLg6bZik
	Oq4MPrGF2EFCH1dII9w3FefC+HtWRfNaXETDkadsRQ/uLA7vWCgqSYFz7I6N6xfZ82t2g0
	aFNHpCglcM1EhoCfKdVXODBHIFTtP38=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EAbURELJ45jcqE6eG2dah5q682UY9xPl8wQ2wDImPZA=;
	b=FZiMXx7rRShn9ylxscrOTIZ8FwhUX4cAZVK8CZ3i+KGmpe3KxJKwVJ8vL88J6Qfmol6yDc
	GktW9AKGUUHkYoZJ9iSGeqrj2yswV0g/y+yfo5xwPHVj1C1XHndq6T7DeyppaECnzR8ovr
	tJUhILbITcVVoeRZsaHb6UTHaoL1VgA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-33-LCEUb69uOTm7Rg26mamX5A-1; Mon,
 01 Sep 2025 11:11:22 -0400
X-MC-Unique: LCEUb69uOTm7Rg26mamX5A-1
X-Mimecast-MFC-AGG-ID: LCEUb69uOTm7Rg26mamX5A_1756739477
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6565919560B5;
	Mon,  1 Sep 2025 15:11:16 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A6BF518003FC;
	Mon,  1 Sep 2025 15:11:00 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: [PATCH v2 26/37] drm/i915/gem: drop nth_page() usage within SG entry
Date: Mon,  1 Sep 2025 17:03:47 +0200
Message-ID: <20250901150359.867252-27-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 80214100009
X-Stat-Signature: 3a856jmmo3ub7n8ma89ohhdkus4wnaek
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756739485-991448
X-HE-Meta: U2FsdGVkX183BGakg94vQOpMUUx6g9dOoQG1iUMSydyo4ajdJ23OLTG35cuj020hcf/HEyDaF2IJQ/kd06b5BENpdGAI071zYu7B2zl+Mw5Fpw1D+ST7rExj7ty1p2kytDqCl8tvUsXG90s8E19v2qmXdJeUDtcKA96DshyIimmHWP1uTuih7GEoqpc1K99I/rogBV9Xf/DdzFRvSrO7My2wDNNvUVBOJohGJADL8Xiib1jDuIoHXBFFnWPreAuPTZkzi96HNoH7yvfSwMFAPpIg5eAERyo7ZpeKDOdW5jPdq2NhxY6TJzJk9RGDfLqGT+6wNc40aczf7csG2fAgYMB27hhqcjgME63JOOi4OlUMB+BiT3wG0MsUOG0IHd3qWKspz/tLez/f8dDJu8futBgMmpl+28WmhSlHFAtM4uXRSdPIE4Yufm47wJvPG1ZuLewSLMaoWeWNgXOn/403tFC00LOVwcutrhgn2xc95KKWiSZXUAP+qT2I/QiBje3kn6ScAosnW65XbvHZRCQsUjNOWarT6lAAfSuw1ysvXXLYN5oeZ1/z1wPYNulvnjdyTSBmFNVm3qYInRRcBQIVdgbqOoaJdPbM5b4oOfLIpLOTFsNg8jKYpZlIpfPErzQOCjuUCu5gQqnPttat25BslTA7AQ0Sq2ThwOsW3ED+h5xJiVXClbjtzogDouVf1Qoa2Ff5fD6ba4wXZk1nz8QcZHaHQuZ2gs1Pw1Q73bP9/z/vq7hEi65css6He6/D0ErrNePNhddq9TAuw88psN1B4B/PdyCcrn6zG8PYnZfBD1B+nXMUlmhXKx53blwid3VjDGWbH3KzSifg67WElfU3sSFnsQAUS5N78L2S1No5R6u8kV1DN+0OKJl0pJO4FFbJPeHImaq7lgtSShS8f5RxuC0I0ULeq4MhF3TJbeOSdaD+u0gCI6XSWnzqfyTDR+HKkh0FAJJt0lrFC9q1WV5
 0o7CBkmJ
 J1XWsXkPzj2tGundx93G1UQBTUWuaub6ZmlDLdZRuKxfJJ1iTa9LBn5PzAyZLekJ44aD1eZDgtDLWuW/KobJQ8t4M49T8JlmZvT3YmJejqjpkut0LJUf0Y8eXUnJM/eJHrcO//ORz9TwKW9N3u+xibFNRLmaBpWNMnHekNYPHuM1FqdsviZHRgQF7+6dVrcBMmmThhWlxXaB8eW76FU/aqoAeDQ4flLxBxUSqTEtunfKwyzb5Eflys2FXoKfB/7ITLrGK+XRz3f7FY132d6xa94viYmJ8w5HpJBfMyPyLcclkMBoApFWhAH4nqPrFXIlzHPcwX7ZuYzbzfG4OGEXZjPvbU5GPA4yPfJLonxuc7EkfjXdNgCj4AopUoltdXGNo1sCXBKLEeVzxuxKQRchmne1m43GvFFiqeEMGrTgGerv7G+gD43WCM9gBnfwWTeU8R8C/gY+zWn+8GNVsytNHaCQsgu90PBqdYx5E/PdomY4og5JMkyyaphdoNDFDo/29Nrgm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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


