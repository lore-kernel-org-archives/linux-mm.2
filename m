Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFDE0D5B86D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095956B0092; Mon, 15 Dec 2025 16:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1FC46B0093; Mon, 15 Dec 2025 16:17:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40A06B0095; Mon, 15 Dec 2025 16:17:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5BA06B0092
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:17:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9338FB8292
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:16 +0000 (UTC)
X-FDA: 84222966072.22.FC02727
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id D87F240008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eiYYWmaY;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERLBqkSCsiAT2a8lrpPaYWFSekwg89Uo0SE97BBpI8w=;
	b=GROo+kHx59z+ZEtwsQXEUF9hOb5mmpg6vh+XGttSFzaxVlNvzfFZvH1NS/ETyS1yYHFf0J
	+6cbYyiySPkrpgMDJn8v5vZ7y1K/oSGqzpQ4PGst4S5CtpK8IbgmFqaWRwj7c/f6Sy9wlp
	kJka7YINv3CcbtEbhl72wufXPSywg/g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eiYYWmaY;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833434; a=rsa-sha256;
	cv=none;
	b=hywZkBoO8PJ6Pi8Ks/i6Qy5HWACd+5m+XwpKgI0rWHaYfMWo/gnDk6W4fpPf7GhAwcJzfK
	GRanVuSUQIOpEEB7fbq6ccHe6WXzjT3ex66+BEQT9EXzHp0EEaiKh6yPj06shDj8hdV+KN
	ndFAdADwi9rYDDNsWp7wTsQJyMTt6aI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765833434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ERLBqkSCsiAT2a8lrpPaYWFSekwg89Uo0SE97BBpI8w=;
	b=eiYYWmaYVxSu7i3rnTMpcm+RIr4ZDSNfp1xb0QLLJBnjaWcd3XkJWCFH4jjjmfD828xyOW
	Z83O+xA36jobt+0qPUr8v/LketwP4XZJt7EBbKOlgkDf9xyJxvIXJB9up2fcyQvBlulPSd
	+bNoHd0r45ln3nu905k77n94b0UkMt8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-LjBqv_h-PmqjiskxPdjVxw-1; Mon,
 15 Dec 2025 16:17:12 -0500
X-MC-Unique: LjBqv_h-PmqjiskxPdjVxw-1
X-Mimecast-MFC-AGG-ID: LjBqv_h-PmqjiskxPdjVxw_1765833431
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73A7B195DE49;
	Mon, 15 Dec 2025 21:17:11 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 54A5F1955F21;
	Mon, 15 Dec 2025 21:17:10 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH 04/11] drivers: i915 selftest: use pgtable_has_pmd_leaves()
Date: Mon, 15 Dec 2025 16:16:46 -0500
Message-ID: <db6f2106e8925fd3e037ae95c2eebe9b3410d7d7.1765833318.git.luizcap@redhat.com>
In-Reply-To: <cover.1765833318.git.luizcap@redhat.com>
References: <cover.1765833318.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Stat-Signature: t1r41nnzoxnpyomwep3ez3ihyobmdaw5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D87F240008
X-HE-Tag: 1765833434-299006
X-HE-Meta: U2FsdGVkX18ZNJrQZCgcitVConmdXU4dRBAJiPyTIrV9bCp4aGm+l49PcEa3Wp2Dulz5N98F/nVNvZrmHRW5wnPMxBCDDUL8b0VP5vSkP8mL6CRZYjv0NF0ygeX8GTw6m6qC+r0dSeiDPYI3NLMmqq3i/qAHVclpp1Tl8XHFzVtOBy61QzYG7xDRq21CNsiQez7eQBtruEm8xn7Qs3Z9Ez5+kjhm8ju7ymDyOgDc+8r6lweQIqfPzYrPFwk6pazutpSIA+g5c5FwbPXnuRMr94tzhMuJRdmjc229cftoCzemuLGuC6DXUOEBzf76++MUUK0bOdlGnX57yYPDZsPJGu3Zt96tWRxSb9YXnSAHmq6ji9fSP8hVWV/wnwA70Zj/3CfY1NZKiP7e8spZC92oIo7BJW5FZt0fRA/FOsrwl27fF5w98aYoaJlFYvO0cFTM5aHdrSgL0D4/9duhCx6l0Gb8/iUlcw5i30O1JlN0COe8oEmqAebEmHgo4FVX40vWdPvQQh8/educeX/rf18iU9JSUrZDYXmIShmtgDTQVxlwBY6NRSsV+Py/pTCAJuTNhR0el03QVHbyz7QrPPQV3IVnmybBqEXC5TyWCZu5yM3ND38zTlAxdzevSBO20EtrOR26mvWFb0HcnukYlnY5GdxnFkoKFowqfnv41PA3XoWq3gPauNPxXojYLRI+B+3InZo/6Ot5jIOCjeOWz11esgQfCnFX0Vu6Nj3zjLzlAv7rwSg2vgLqGKxV6t6ILgB/wViogdZX1/APJHQo4eqhGXqgFXELl+2OSWZg+atWaj6XeygiDwdMg+UNIUrFQiK1Bis2HeVhLQd8lPQaEIHaDuIKxX9Q/DdB6YDmPxlFs3+ZBPN0sa6mSk6wlqtAmt4F9M2UXvK0hdQqgykPM5mUM/8F1Wql5eMIL9DLAwSvrWdSdkUo6Yq1onfYKbaA5ga6wLemRUQAFylReGAU1IX
 dutGZ9hm
 L3cOCu4Y6TSJOR6rXT94fKrOL22W40sZ0tBehc+23AoIELQPHtKWc70suSNkkSFTCx3zmXU4VVnC0r9SK3n2LtItrOEDQCQdEv2F5qzYIvjCXmhuyXTIk+KiZQdIsfvzj5PuI8vOqwcoCbsiECgUjmzktxFJEWzEQf53I1hYeqc4k7iXqbL0wQDwRngf2PjysqLCdpZ+2N/V/y0ZTQz8+juj0umbdULVlJcbtaAJYicSeizlWI8UjfYq3a4XS3+l6bfZSSKhxPWFBwSz9pVxHw1RF18sgnIl7PlX68UdpUpuPV8EWWSHeKtLj02wS1CC2N0qii+A67fns4aNONC8ySSEyqRmiLqEmdrdUGFQm8i4U2EZldnianfks7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

igt_can_allocate_thp() uses has_transparent_hugepage() to check if
PMD-sized pages are supported, use pgtable_has_pmd_leaves() instead.

Since igt_can_allocate_thp() wants to use PMD-sized pages with THP,
also check if THP is built-in with IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE).

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 drivers/gpu/drm/i915/gem/selftests/huge_pages.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
index bd08605a1611..dcd1f1141513 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1316,7 +1316,9 @@ typedef struct drm_i915_gem_object *
 
 static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
 {
-	return i915->mm.gemfs && has_transparent_hugepage();
+	return i915->mm.gemfs &&
+		IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		pgtable_has_pmd_leaves();
 }
 
 static struct drm_i915_gem_object *
-- 
2.52.0


