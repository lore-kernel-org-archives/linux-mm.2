Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EECE7CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BFC08E0018; Wed, 27 Aug 2025 18:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496D38E0001; Wed, 27 Aug 2025 18:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD308E0018; Wed, 27 Aug 2025 18:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29C138E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:10:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1E9C1606DD
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:10:51 +0000 (UTC)
X-FDA: 83823933102.30.1B9B237
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 160051A0003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:10:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BZANU+85;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YpVNTL/msyfj4quk+zG5idx/zOSmESitaXX9oJyyDlo=;
	b=4rQOYvk1Q0j2zHpujD7TwvXEpHVI1fqaIH1n+koHwQVA1zKWZ6r0xjtAUyXy9GYUfGExjw
	+7au1vP62hBZFU2viXjsRJicSXByJ+cAFPdOW/dFhBVjsKydmtF9DoYEKLmSDu6EkFdi75
	mC0IbSvjL2upd/nUhYooO8bwseaNzQw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BZANU+85;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332650; a=rsa-sha256;
	cv=none;
	b=DMoXv4wrT376fy6vPF/PX6Q1ND4BXz1mgJt+N7zHl4kEfbAGSG6tGjl9bONot8upTxUPtP
	DBOpXgk/q0EMhfQnVgPDEPJ9ZH9FpJ/d0Y638ES8EuMewjGcKoe3NmfhNqC/3cl1MHxrKY
	c187d2PwQ8QViBAenFsLCmD1UJvL3i0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YpVNTL/msyfj4quk+zG5idx/zOSmESitaXX9oJyyDlo=;
	b=BZANU+85yB7tncPYN+YM40dTTsFwGWz1MbbHv6KfK82f3hAJ7qHAATi6b9tst0N6VcSqon
	7UgfHw5uxhB4quho9m14oG//1ktqnK+uRrGDin8jQaQwcpFX6Ah5EgsCMSOMiBmdR16pGz
	VIZAffm7Ssvnct6KuYXevzajzpISQBw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-sl5k46szNKGimV3zS5dDew-1; Wed,
 27 Aug 2025 18:10:45 -0400
X-MC-Unique: sl5k46szNKGimV3zS5dDew-1
X-Mimecast-MFC-AGG-ID: sl5k46szNKGimV3zS5dDew_1756332640
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 75B6D180034F;
	Wed, 27 Aug 2025 22:10:40 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A20E430001A1;
	Wed, 27 Aug 2025 22:10:24 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
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
Subject: [PATCH v1 30/36] scsi: sg: drop nth_page() usage within SG entry
Date: Thu, 28 Aug 2025 00:01:34 +0200
Message-ID: <20250827220141.262669-31-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: 4qiqm5rf88ngmjocfmj3utesxcabxpj7
X-Rspam-User: 
X-Rspamd-Queue-Id: 160051A0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756332649-650857
X-HE-Meta: U2FsdGVkX18tQXZF6JraBAJMWbQZaljivU7huNvGnf+RME//caydOSnsqjuTSSr3JcP3l8JJsxGjFX7GBeg9XRZf8BnE+fxCO6W8R0gxM+mtPrTU1b6UXpI3g2BtVlKWwWFZ32K+8Q8A/k3XLp+J4njmMqSD87NyhKRhEUV0sZMf0sNv+Uv66lgLMxgAYgRFIG2PKRpWhztYUrKYlzU8vVP5BhvfghG+vBmVwJYAP8yavjU03GpL+Wx0Uuren5E8ADRntlB9+/BtT3RdYiQQ2SKGGmqGecVvUIaOvmCHL7XHXuIT3AiyX4JOYnUYsHw/+frK8+864cEXDozcwN0Zv1pw0oHuRqI83HAlEz7GfMf0XHhaVqLsgXXBYPWqH3mWBW/vxPzDd3MCntBQli4Kes0s3OjBNkWmkuEyq3g4tRQnOU/6vgU0NQEARonInqaO9wlMkvqQkCBpzkh6FcMjiacrmCO+6GdYB1gACiHOh0SB/n9Kx3iIGcnv0cAT2r8KqyVy80rymLz9L9a7GQa2nb2IVd3z3ftnJdERygsWyZP3xLTUivLeqpWkLwrHnADo53fAamPkZNAEuKyepA3xZa8WSr35SF0IbvJ9eFaahJ2ExqxFPovSNBd5OSqGNBrfjC6kWs8kycoafh+oeGF/bku6J9lCGQmoJcVaEQUqlRvwU+NdTA5g6D/8mIayEMo36lRUvPWNIcVOM3E7aCev4SZBtKziz9NSEOYOB5B0KRZj6RxLbM+kX+OftuewYVMETNpy9MuebVdx2C9wPvrp4lpWDHgegErf07gT7YNb72203e9+7cPquHl+q1YeHPJwcanQGbn+y+U2HyuGFf8seaf/UqnfJAfoalTq9s92kut66BIWCdNsP3c56InQdRV/goA3bWmXEzc2i71quonyigxC5zGNhnAzI7nQvKvS7GTVaEwBaQ50jtbcdnPmSQolZRixofT2oT4flBBVZI6
 Gcrgl+s3
 0n+cyX2qY3l1Zk2XXH/angmOJmJ20KG3om5uisjbrNS5Nz9LkACBTEgBPSt9eBX7udqiF5E6ti1beBQLWcp6mOYOMPz9aSZPzkVKIAXaE8LZTdSwJK8XLnp2h9ZVZFQoEwEdtatt+I3RR2mV1ONM/jchhzbpjo2NzQX2dFkSa4qGw2ZxUEplGpPSTM/oSZXbqkeOocDkP6JMeJUzMeMNFbI8LgpgfbWB32MWIXCQ61H02E4RZ0tFXhKSGUQyl2AEQ4d+9Q8p35Lp+X+QoQGKyBdUlsXr/hitFZX2DVLkk7i+kVjiwh+NO0gYJ/z3xEeGn+1/Q/eOgIa3dnnCLCalgWcvI27jrs0u3yw2274x8mv4GQVdOLWTbRpTRRGv6uUsz4g/EVBtTUrnJQ7+yEeI9v/qWehFgbR481FIbjoikYy6eTh6x2tNY7nqzTnuAmzZdd4GjZ5e63mCRb+dCdgddakO0ULXifYJYKaravvbillmp1pYhneKFhS4Tamm4CaY0rNeYWrDohjVQawB7cKhUJXJN+fHI0xm9doj0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/scsi/sg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3c02a5f7b5f39..4c62c597c7be9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1235,8 +1235,7 @@ sg_vma_fault(struct vm_fault *vmf)
 		len = vma->vm_end - sa;
 		len = (len < length) ? len : length;
 		if (offset < len) {
-			struct page *page = nth_page(rsv_schp->pages[k],
-						     offset >> PAGE_SHIFT);
+			struct page *page = rsv_schp->pages[k] + (offset >> PAGE_SHIFT);
 			get_page(page);	/* increment page count */
 			vmf->page = page;
 			return 0; /* success */
-- 
2.50.1


