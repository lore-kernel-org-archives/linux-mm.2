Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A0FCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B5B6B0030; Wed, 27 Aug 2025 18:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A436B0032; Wed, 27 Aug 2025 18:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2996B007B; Wed, 27 Aug 2025 18:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6656B0030
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:03:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 027B01DE9F8
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:03:29 +0000 (UTC)
X-FDA: 83823914580.26.C1FF666
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 493F52000E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:03:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IMBUmo2L;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wE/qMBAOI7UvFOFlFaewQkiF5uwI4kbjc+EesVZbC4=;
	b=uDSiz5TE6TaJbYgq230U/snmgSnmmWeE22V40VSFDZo0feCNhBLRv4hNkHqtROvt3yhjGr
	diNLaoKlLidn24g7xK2HGvxw7/gzBPXs+6Iv4kjspNJDwSctUmibtSoOjt0b+no7lrMfh8
	QdoEqwITpzTPHEHyquSYEWdTu+AKooo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IMBUmo2L;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332208; a=rsa-sha256;
	cv=none;
	b=LkUGGmhS7gR45PQw3WXFs2Hl5TsoscYbJ6DdVJm+vKnSA2CSMmCdXiSZ2XtXRZG0dg+QWK
	9SrMP0r1D1okv+DuiOuv90iBgA/d07fzhd5o3HbGFLfnTDNKtUnvuWne9XyBoCLn6rVfFn
	I3hHrhQ7AoqFs8OQHl1bax6K+y0Pxwk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3wE/qMBAOI7UvFOFlFaewQkiF5uwI4kbjc+EesVZbC4=;
	b=IMBUmo2LlpXyveIhg0016FK/l69vP4AKnkXCC2XYeNTX2e8zNa7XUBNVR8IfABOGWSEGUK
	DefxBc9zk/Kb6ScSUA08+Q9atzjF1H5p4XaBHN4WmtlinxX+qWC8x4v1SavLpJoWsYhZyQ
	eofvAVZYuCkxrDYjl3U9mx5wG1/WxMI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-48-aWxloNfqN1GfaKF83zeK5A-1; Wed,
 27 Aug 2025 18:03:23 -0400
X-MC-Unique: aWxloNfqN1GfaKF83zeK5A-1
X-Mimecast-MFC-AGG-ID: aWxloNfqN1GfaKF83zeK5A_1756332194
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 931F81800352;
	Wed, 27 Aug 2025 22:03:13 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8DC1330001A1;
	Wed, 27 Aug 2025 22:02:56 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
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
Subject: [PATCH v1 03/36] s390/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Thu, 28 Aug 2025 00:01:07 +0200
Message-ID: <20250827220141.262669-4-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: pk4s5gty7cmwjkppf8q5oxfimuucz4h3
X-Rspam-User: 
X-Rspamd-Queue-Id: 493F52000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1756332208-28597
X-HE-Meta: U2FsdGVkX197b5wAiJBOVzL3B+aVTSWAwaq0JmALgJTuMWBygBer7Esvvdw4u6zLLXJLwpB0PQkGEQClu5sJKo0Ta5MMu0l2iJQ3OPRlyvq+0BSQ+5MvBJYya0478XB1XXXm1WbFlb/ulp7NXYew3GWd98rZq79lAJZnaDdJLiAP1H6UtOvbIxBBYPcSJaNe6pKwng/Jhmvb/U6aM7jI1QCWmqkcqB80tE4a+gGUMHzcwwLB81KRBLxgY3l3zjl9YoLcXVdQlPta3JMe0bheAusbeQXIE42XLYm8niLsSP/+1bg7+QZxnl17eYAjQm673oov6P5EwTlB61mjzlimoJSZgLLSk1sQ41c+gcf+1i0FzOwHcrXuJkLBx3uaw3iaDxMj2hxCeu2N4t42Bpqu5J9WWABXYmyLetkNJPew3ab95j17LFTQO4aZ8afXRBLT7KUvQ5mmOwXD/NCUWVh+T86cFcFdfyh+fMelYGtWQinlWtErVydlvOIzGHFoO32lh0ymJ8SUz4aDJJVdLg8+hqQ8LpQmRgRgoGoR2EdUe4d7P2mUFXhez4bTae25TaPYMXD+nknGS0ntD2rjLEk/BPGhxyDoHGx3Tp+jJrRvJBLwoRNQV1wB/8JqYcuPC2KG7rlCV7LAmDe/bMcQjP44RQ4NsrP9RF7IuMh1sM+z5YVWB6shYtvp1bwBqSSriPqhWMzHUweRZS1czroeQoJyFwPEbdL8bsB81FJVBAYcIn5v/YOWaD9KmMezxiyG9rI7lo4n7utEUGRfIjpgIoWuO2bruHS0Yq04Yic9v5Qzru3YSmg9acbX1c398zzUvAqX9BHERIwDsiYvWVdvda9EpFUPNKP872CzRy0Dcc5GUhBWe2msC1DXcJIPh9uIRrtQ+lgtHYpvjq88EhAp1bGakSnJ6aWuXVs21SO3Ae/t2V/JxVUvS3V155MMSTw9i6hu2assm1RY7RZWrDQcQo6
 BuA+Zche
 CJOnPfIiMbAu7sF+ckKb8YbTgqa55Xf46gO9nU8yq5uH4EmvF/RIUWQXZCg0nElXc8qLge14vWEz8KRSVgc8cTSsF9mJCeGG83Y6vDcAt2mcjWBKGJsNVCoASVHCBcRBAOH7JhXYxSvhJKaKfzbXxx/R14JHbwY4xAwIyzdKgqU6zBymB+41TmaGOLdoYuvHCtTDT4L/+w0mwGH6QnLIH8kxoJffwpRo5BbK/qXj5N7Xoe+4VmIY2jw25P1qsDG7ASrAGMv9lYKcQIiREVYQymBXNUOfhQx0q9JbcMdKd0DI/vA5qX4sEpc/HSV/udwmxXDKetVm8nxsZHxr8clKhWGAJnTJ5R3cLjSU2VUeRMBVBLS+mjqWM/MTXldHl8TleaxDr7Y1M5cTB0ALzhk5YlP1w+8OR2ob8f4qCo2Otei7ZmzutDyNRQhkM4WcIeg9Ubjmk/9Z9qBCbjx5R33DMAJIxDXNYeptGTi5KNSz3DfzLh+CeRxuEFQDHy+AVB/ZbuM2L5kZ9GJb9f+FI3/3xsiVpDBTf036k8/XU
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
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index bf680c26a33cf..145ca23c2fff6 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -710,7 +710,6 @@ menu "Memory setup"
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_VMEMMAP_ENABLE
-	select SPARSEMEM_VMEMMAP
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
-- 
2.50.1


