Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9D6CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF9C6B00A3; Wed, 27 Aug 2025 18:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAFEC6B00A4; Wed, 27 Aug 2025 18:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F086B00A5; Wed, 27 Aug 2025 18:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 866FB6B00A3
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:10:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4EBBF1608B1
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:10:04 +0000 (UTC)
X-FDA: 83823931128.24.6C237DD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 94C90180011
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:10:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S/qT4fum";
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXg5sKb3LQ8Ovlzb+xXgvQsFzOeAfDPZ/pDh6HDj700=;
	b=I6AVeZcOKN4uC7jCwI0AHmM1na4+Ye4LPnVTihJ2+7canW5hQcDqd5RpDRRGTdAnMnbBIq
	BGu4d+Iv53AMJlfdv32WW5U7tB3oKs0/9XYyZhqHfD6y8ZjYA+LRjLClQahSoxpVfoGjpt
	0q/K3eVSglfbITXJBwgcWvqNkIWbh7o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332602; a=rsa-sha256;
	cv=none;
	b=0eXRVIEOLH3XH8XWyJssklep4pMa/vRTv51Hx5TlGVqSatAdqzjv5Y/tfR7BmG6IcaCI9k
	+oBAZpdb+0hAnPnR1jqNbOQgOOc0kjRVNWrWXTsweaUwm6FPYTKblOByQZSfTXVNaiaWyq
	2HYonxHeltNzdxZeXkkQajrpOBB5QV4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S/qT4fum";
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GXg5sKb3LQ8Ovlzb+xXgvQsFzOeAfDPZ/pDh6HDj700=;
	b=S/qT4fumBilNv2Ob1YIaYYjcLBtgVxgAjzuSMH98IYjUqKaSdPiay8k6+H5XwLco+OcpjJ
	zB3INAbjL26H1HgChloi9MTDXCY0S/NEKF7yp7t5miAPCaP1QNr2d36fr8CuZAiyRPgRFv
	I70zYxFPLrvsEGSOiPL6ID+boPRsB6U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-6glRl4KNPgiaFeNg7_zkYg-1; Wed,
 27 Aug 2025 18:09:55 -0400
X-MC-Unique: 6glRl4KNPgiaFeNg7_zkYg-1
X-Mimecast-MFC-AGG-ID: 6glRl4KNPgiaFeNg7_zkYg_1756332590
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F370918002C4;
	Wed, 27 Aug 2025 22:09:49 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9186830001A1;
	Wed, 27 Aug 2025 22:09:33 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>,
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
Subject: [PATCH v1 27/36] memstick: drop nth_page() usage within SG entry
Date: Thu, 28 Aug 2025 00:01:31 +0200
Message-ID: <20250827220141.262669-28-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 94C90180011
X-Stat-Signature: kihwgwf1wkyzipttnynxe1x8n767x56e
X-HE-Tag: 1756332602-670775
X-HE-Meta: U2FsdGVkX1/VX3q4YtZPblbUptDWSpRd1Eq8ma1vMwxy8C9S8k/JL2I09TiZHafwMWLcRh5SBJp/Cd+eWkn9OfNWJRRIJ4Fq2bxjlKHBfJGzHg5b2PwAVU3GvMJSEwu0q9pO2Fdreo/dC9rqaofOxnwJqRLYw4wrJI++iojEjJ+9NE0zQzlBdCcfTAfHc8XM0qem7S2bxi4QFLRh1xfrd5oXpIjQkfjbwPl+MIT8YMw2WcbkNBRGnOtNxsKuNThn9QJyFFkOiYC9uPoLtJRMZ1ZtkegOJkxsRkx8OZE5phNKUroUxeQGA30vWK/YXEzwOqd0TAzbpsE9umkrJTM0nWbRztQFiF49wNz2MPhtyU0r0XX5uGaqjhS6DEXQ55H9gPNa4ZtrGLEO+D8B7ftdzlBY1QM82Bfyo/dhX7ixn85cVz/TnUn+afnuLCvtllX3BoBXoySTMR/KVtN81QTB8hjkbmeThnGbx0FArrfe0lSzmNQzsxEeXafKeS2PMQwKtmznYboA5S53468Nhr9t8hyOIzL7ESatL3tAuTPBPKTqQs5/zYgw0fCi8gHqiyCNrMp+z+KfJBE+biXfGCldsLG4I4aoriGHTCQUxzXx+Ri9DdwsIVXt3dd3iGjbSTzcyI/nNzBQOFV/4GLp7nfQpIP2VNQAgQrwBTlVj6mDNOliSi4g4Um4V23r5e4LyrRRcrKu4R2T98axTfXlhWdnG4AK/Y6QmiCu3IME0OU00Asinyxz2emkG4ykGgBOrukpqKnuJtfRlpwKVsFOBjCd8K6NBHSRZwO0JN6bmuAbGRBW9LOkDH6Kv9lRAkVFBLhHcKEIlO0V99LYWF3GCVHNCxRZgew8S8xMTjnGxbX42ITSoOpFvbf2MTUTDsiYNhcPYqLvfXHn0QIN83zkSthfq1Y96T1hbeZf/19PgzENhmFoTYiPJoc2Ew2ylkJJ22CWCUNS0W9WZjMqx16Jqts
 6Q9XzwPI
 7jxSab9+1AeNC3k03oeVaOBFxw2MLwkLnSwQECM4pT4554qzEnhFMLOMSQl4g6BpRHCLRhy3/JH3g02auEovYyW0QzLTZ66fWZQV+DS0bwEGB3P0ZAOTqCX1aJ2TFdL0dlneLBbTgcKdvRDVXutZkeY5y0KGWLeEYUKqsnhwCnJHV4dzNGOxOWKI2tyttzUn/TO5Ogs0iyOlTQainniEFf0qwMgLxtoCAuFe0dv0ZHsQSD4qd8Tfb3AjLTAK8otwGIami4We3vfHccXQhsSpnVhViNCNts9O+F0VWeAIwfm0geoUr2sanPab+FX4tRuPG6Da63Iob4vjQVYmw1ep6Au35jA4NsaU+qnsRN6wYx3laIjK0wAyBHHrkHFeBf17NX4wNvBLylYjfJr7BHGN5+Rxn8QDEjnMVEQNDEDuBG0cslFXFa+3SrmCOxoFHV/bjAE8Vvtg+wVOxynwgzLqWzZGcEEEB6J9gx5KsIwdgRZKA9bwOMBmNCPApbuwlM+GiFxwrTQd4Zjdr6J7+9RzWR94uYRG/KCBQ52wl94hUzglx0D+JapxOk0gDcT/w7di5WWAcvJWn9RimW02wNbY8eb8HS4SY/y2aPleI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/memstick/host/jmb38x_ms.c | 3 +--
 drivers/memstick/host/tifm_ms.c   | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index cddddb3a5a27f..79e66e30417c1 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -317,8 +317,7 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 		unsigned int p_off;
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
+			pg = sg_page(&host->req->sg) + (off >> PAGE_SHIFT);
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index db7f3a088fb09..0b6a90661eee5 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -201,8 +201,7 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 		unsigned int p_off;
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
+			pg = sg_page(&host->req->sg) + (off >> PAGE_SHIFT);
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
-- 
2.50.1


