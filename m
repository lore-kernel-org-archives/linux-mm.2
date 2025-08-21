Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C97A4CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4071A8E0043; Thu, 21 Aug 2025 16:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B74F8E0045; Thu, 21 Aug 2025 16:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16FA48E0043; Thu, 21 Aug 2025 16:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED5148E0045
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B73D71A054F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:41 +0000 (UTC)
X-FDA: 83801852442.06.36B606B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8867DC001D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ym6Nf6oU;
	spf=pass (imf28.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kuJ+10C4pYxyWPcGDJkWqMBAcRGmXje5KFYns7NWu0=;
	b=59fSZd/zF6p2K68ZORDd2fjoS4H0T/7MOeY5TWGy7qj5uQG44SGVSE/j2eCDnfIpJQZCC9
	I02awFWIznJZ1jjBFU2PuC9sRLqx+EJM/kam29Sl5trZJ2nf2t7zPe6yEdB2Y9H7ZLECCt
	qCrjpEF4uR9SQshyYNONPuorUV0M62s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ym6Nf6oU;
	spf=pass (imf28.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806919; a=rsa-sha256;
	cv=none;
	b=m8HWjunTfU4khPK47/6ILFukiMaFNtgYRvHkcLWgTTmgVo2wa9tBbfCXdSRwAeLG2kJ/Fw
	vdffHXMeRtUYL+tiB14vGRyGcIM4ymnNtCN+6Mf0CK/rcPDE2zhLhaSUziQZULh48c22G2
	Gbcj+CSIRaItf+akQmTdiCmNMLHUUK0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6kuJ+10C4pYxyWPcGDJkWqMBAcRGmXje5KFYns7NWu0=;
	b=Ym6Nf6oUgfwl5XHpidZRmZsMMngCIRPvHQz2HPSb2k6xACkO0zPGIWni96caHL09Rv2UIW
	1p/IqEqcaQLHLr51EpCeaeW6RWml/cyjEO1uy9vtavoFtG7QDnQu5gZaKBytx5riY7OZLP
	c7q9VF+3UtLq8m4zoal+B3YCZtAOA30=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-dIwycWg7NvGP0SjHv5Xt3g-1; Thu, 21 Aug 2025 16:08:34 -0400
X-MC-Unique: dIwycWg7NvGP0SjHv5Xt3g-1
X-Mimecast-MFC-AGG-ID: dIwycWg7NvGP0SjHv5Xt3g_1755806909
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3c380aa19c1so770633f8f.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806909; x=1756411709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6kuJ+10C4pYxyWPcGDJkWqMBAcRGmXje5KFYns7NWu0=;
        b=cUCu9vgcEPXE/ror6qs6Za67KqXum6JfeyzITi8HOSnra1ssiMdp3x74DJOP6GcWZO
         rEP2pbBT6T1q4NN9lVllzzgCZQHGH2YW/vhNRaQm+UklQdhuUiosghTzA9ZFjJ9aWSTg
         4DpffjXfjj1fMSVpcBKyVXnw7FEc2mKoT5jWeB6xjfX2NZRw8/k+1SkTb4OpRB0131qP
         5+W/pYsRgYqORlpEVkaakDrI7yPkIGH1Wg3/McShwLL5rfChtWvCRzRIi9zpiP2t8+0G
         e4f4AOoegtQBoadRFV7c4FN5Pcu1JOQ+m888SmHl8Ozmr8JBIbUxpgbGGTX7VcH/rNnq
         o0GA==
X-Forwarded-Encrypted: i=1; AJvYcCWc+il2PX0W9E0cF9g0JaAXE8GLj2s+uNmCNnuh0jiq/5ghqQmboC6w0UWxOKEdF9ywO75FT97dFQ==@kvack.org
X-Gm-Message-State: AOJu0Yxxr9Zt33F6iLibQ5dQbPVeZsHlIwbtTuwc8t9NY33naNlrwjDR
	U6mGbAqaqIMIAgQoJXfm1W/PT9pisJOOW0eGl1j26lXRlt3upD1fO2xfJsOJUv8R9Bjn6J0Aqgc
	IEIeeFIwPEFF/Mg4DLhdKQQskab00lZm8sGuFJ8HJx/t8UXJIBRrC
X-Gm-Gg: ASbGncu7yWSV3v58c+dMy5DqGGGqyZCbts1TCRLbWFkNwXlIhfMlCvjip0ctVOD9yKd
	+cZ+s9HCNRYH5yaWT6aoy8Gp+7BUFByYH8YurIoXuQ3S0/cTkcZFYlFrYenFbzsVYOZspnl0aRp
	mkkJpQa5caLWUEf9e/4lxKH2GoHxf19UOirM8cms+6uPWG1M7sKSxB6KeKusop7YUe1tVrGA6c2
	Sm6aQ0jiCroJMuvo2zNNzsO70Q1xxj7eWjObACiesx9l5fnvJkKOF1cc+szKZPZ//ZkYJeGGyL5
	Pq2xo0zioDH6zfTC9OvPU7s9kF/UlzFhw3Pih1GKSUhWBQboEi7sUi6gWU5Wj3VEqr3+AIoIaMv
	sjQZg5Z+RiUZKBsmXOLbQ6w==
X-Received: by 2002:a05:6000:18a6:b0:3b9:48f:4967 with SMTP id ffacd0b85a97d-3c5dd6bbb33mr155490f8f.56.1755806909386;
        Thu, 21 Aug 2025 13:08:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRykwWh31JVJGBkobbD9YNZEskJV981iF0h0FASAg1XfgxaqZA4MQnDyPntA4/emfIOpWurA==
X-Received: by 2002:a05:6000:18a6:b0:3b9:48f:4967 with SMTP id ffacd0b85a97d-3c5dd6bbb33mr155476f8f.56.1755806908930;
        Thu, 21 Aug 2025 13:08:28 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c5317abe83sm2432791f8f.40.2025.08.21.13.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:28 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Doug Gilbert <dgilbert@interlog.com>,
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
Subject: [PATCH RFC 29/35] scsi: core: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:55 +0200
Message-ID: <20250821200701.1329277-30-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CkcaHygO2mw0KgYzxqPSDDp4iUnRkHZLgxcS3J3mtqs_1755806909
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8867DC001D
X-Stat-Signature: mrib5k7qihfs9q1aktsyoebjfmpegd4x
X-Rspam-User: 
X-HE-Tag: 1755806919-669928
X-HE-Meta: U2FsdGVkX1/x/jVrCnB+lA9GL2zXZM5bnChjKMLj5mZI5PE12nkIXheqhe1vnwDyzM/8JtqY8g4ScvjMlV8WzFag6UEgKzAGsP9alPWBWvHrHqbCKAmHySNxI4Oy8kkqMMMoWCwhO58cMm3nwtXs0+RkC/RoZhHjddZ+IpzltgzRaWvrBZhZwSdKB/7xyGqYDi1CZ74eggJJgCnVm+1jqCLYetBbRIqyaAa0nxwEiKhVJSyIIP9Bia8ofZjVobVNQmqlWZ3PGliepAoaGT0YSFNpQtZULK1VMME6cxcfoX7PXKkVyODjjtOGtpUoi0BIfz08ff6Pnlwry/eGGnq/+zRCsSsrx2eByU9CcUQjWjTaE60332qNZtE1djRVH7IKqZ9TLb6Gamhi96YGQjawRjoGRvYShqWSXTGZdaPu9cQNbN9z11hSazygf9tbQKlyHcLIHBEtm3jOuJ6c8QdOlopR2m48hAYnkIOAGWtcbyu4sgq1vR5K7nOW/xLQukiCUl11h0XYs97b+JECc0jpJx3+OcBYOI78fTrhR2VbFk9ez9iH5QHhTpi6rCJzNtCbkbfiPSrR3JOL/2lCj0rk1iBOe0rfP8gnZTj2v3bSenDuyEE4hNi7x5HV7uJNuL8EFIg8mlh/m6EvlaalLdKTynpgpVm7VafLMlrj/Zh6hafMYOBfLJ6mGqU2dimM7F+BiJtJ+Ec+SMiyPvEgsR9j9LOqFywjZzzsys3qRoXnI1BqkaNQXB4wryu3UN8cjiEhNu8oRpoinbosqtKWfYpE+YsfMFBQTCwGmtW6/z3OrMSi9b3+vxxcwpQ71i9E/1sza+VMIg5WN9lOWN+SRxaa44uHb14bmtIT2p+FnDrig6n5RMXOiknWATjedvxs0ROhbZKCiGC0DWEbxYN548NjKLi9J33IaocYaidP+t/VR0j1ZILlPd7yZ0Ilg/bqP8Lu+HxQwURnokWzu3R0nh9
 jAWOd/ID
 h2YwnA3VobtyW49RuX1PLpDmVXgxWS1AvX27hlFR8t0v0QQ8Nnnmn4/97Yrw42W4nONkp10MUYXL2yvfZKzCGg8KJin3AMoIz6gQ97vG0HJVmZ0/do47Qs381pBocLThMDXNvnTxr8cN/9yzoj+4Nc5Lu5WDC0I/eD7v/8m13M4w1sTmrQofES13BV9o8FwE3pDgigqzMnCyOzj6JiIm9lmC+zI3FPitFefwr2E2aQm258tgxc6tOrdwPrNy7ROjo/2mToj2fmKUfnI918DcCQw4iD+0MZPbmKyOzkDFd5gtjph++W3uj7hoqrdVTZZfBhUqrXzC8/+ToO1Krbb8CTEATUBPOxt5s9bjZ90W+nqGzvKHfRg58DgAnEsxkx0plm1Yx7UFJc0K6JduPA53z8xKZzxmrSj7d03s1w4tTalPaJC3QlqXwtvVM9KRNmbx1Y0Rba9JwCTwJowahiwSUeb5xcBJZ+PhPE1DBIfTjfS8PosfJlkt1KB04sLIxXxfU2xAodBS91uKQdpRngSVdqWn2RDuw9KfX++N8/8//f5SjDxZPKU0zyyD23qS9OQN0QhYbWx6Zr9smGG9b6C4SeXiQRdi2PrG2JISUPIJ7o243MTu8MEqCYFrIQIS/t4V8IlAZcOW6BlzyhvvDtmtHMjK2XqdwAn6pAMB8ym2HHi2XLHcI2jRh1JYx1EPv365su6O+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/scsi/scsi_lib.c | 3 +--
 drivers/scsi/sg.c       | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0c65ecfedfbd6..f523f85828b89 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3148,8 +3148,7 @@ void *scsi_kmap_atomic_sg(struct scatterlist *sgl, int sg_count,
 	/* Offset starting from the beginning of first page in this sg-entry */
 	*offset = *offset - len_complete + sg->offset;
 
-	/* Assumption: contiguous pages can be accessed as "page + i" */
-	page = nth_page(sg_page(sg), (*offset >> PAGE_SHIFT));
+	page = sg_page(sg) + *offset / PAGE_SIZE;
 	*offset &= ~PAGE_MASK;
 
 	/* Bytes in this sg-entry from *offset to the end of the page */
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3c02a5f7b5f39..2c653f2b21133 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1235,8 +1235,7 @@ sg_vma_fault(struct vm_fault *vmf)
 		len = vma->vm_end - sa;
 		len = (len < length) ? len : length;
 		if (offset < len) {
-			struct page *page = nth_page(rsv_schp->pages[k],
-						     offset >> PAGE_SHIFT);
+			struct page *page = rsv_schp->pages[k] + offset / PAGE_SIZE;
 			get_page(page);	/* increment page count */
 			vmf->page = page;
 			return 0; /* success */
-- 
2.50.1


