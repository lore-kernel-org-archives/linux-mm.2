Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 856EFCA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6128E002A; Thu, 21 Aug 2025 16:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68518E0027; Thu, 21 Aug 2025 16:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92088E002A; Thu, 21 Aug 2025 16:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 877648E0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 315A61DDA20
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:25 +0000 (UTC)
X-FDA: 83801849250.07.A37ADA6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0B8B3C000A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="euR0TV4/";
	spf=pass (imf10.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iU84NUWejaBSUFBs/T0/O04YrYLlq1RcxZMywEFGjU0=;
	b=jvug27IRVAlvqxNu2txvMVlO/Iz36keOj4xyNl4RvBgo1/eleP5iSAqVqKPOgxi6+uTfdC
	OAd5lT7HzV4htvbeRETfIxf7Tjgn7BX99EKWOMqFxBVZFZwgrHcxPS/kvXBr5Kl9ECPjjU
	X0k7Kocq0OHKdX8/aGBq7Zu4lzThr6c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="euR0TV4/";
	spf=pass (imf10.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806843; a=rsa-sha256;
	cv=none;
	b=vnUTR3+3dfcqen9F8OC4YmCGo9azehfey6F70VFIgLFSBVrz2eTAugVpoL8R1f851oB18W
	l5kcvnk9qY4T838YIvlefQzHnZMEgBOvWJF2ziTbBs/cYe4fVJHXzcITNQV7mLCNfS99g6
	wIVSvY2a2bLKiqBORGvBTiAqvFZquxk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iU84NUWejaBSUFBs/T0/O04YrYLlq1RcxZMywEFGjU0=;
	b=euR0TV4/QOfXNjZ0/3jsSIeNXiPdXyd/DH+lA2mGxDI3Xs97h4gbizPzmUEQc7YigPlncj
	QhaXEn/fx/+9jw+Qcx8Jevq1dn+O+8TLjFhDGH1vMSRt84axaskmXKfQpTUwClLajPEX4N
	F4/NUBkRfFYLTKfHkyoh2ip0UN9GfnU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-xePeGuBLOlGguEp_-Jjxig-1; Thu, 21 Aug 2025 16:07:20 -0400
X-MC-Unique: xePeGuBLOlGguEp_-Jjxig-1
X-Mimecast-MFC-AGG-ID: xePeGuBLOlGguEp_-Jjxig_1755806839
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05b15eso10515275e9.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806839; x=1756411639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iU84NUWejaBSUFBs/T0/O04YrYLlq1RcxZMywEFGjU0=;
        b=pDDSe896zGJ3dm6zA4O8RYANzrV8tD3FZXapuDXA357tq5AvzRxhlJFRlK0miDGnXd
         OX8l2WLwbSgHJACa8YA2CvCTpv4j2DJlykY5mMubwyvJu5aRuzju3FNWFhFbTi157Xyu
         njMJDKeVUr5hHQztNO9cZGW/TxnoairE7JyKQNLQt/X+UiJN2oGucvkWiIagP7rcwLS4
         6jw+a9jNfP7KPXFrES+i5Z8/04XGqh5WuGrlsdsCJSeZ6icnPCas07cbjWnYlr0pWs7B
         kB/uE3ZiaKhbRzFSHNp0A1msMJxv9AIU6dwQEE9+qrDfdgJ1KV2M5V9B1IO4mJ+1Z5A+
         P1TQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwGp4h8Vrapx97YdnTRlDx4WddDm7FVCmjkU1hDE5yi3YPNddWS8o5jr3F0eBs0PdnO/K92F1N7g==@kvack.org
X-Gm-Message-State: AOJu0YyGX8HdThhKYNZu6oAmARH9euykA9ZoyW11qVYFeUR+VHmzl7ss
	BAwYfwsIGYSPbE5ZuI2esMiTyG30GCGeBlknI5bEMlVdbNtuSgjX+NV380oSyiE1cPh744ojQfB
	Spxr+mTMGQ+Z7DCYyL+RzdnsctWe81QhkBOUQOsDZvHp3hbal1ahR
X-Gm-Gg: ASbGncs1rvqZZYPFNcs305MJwg4JGugjR5/Db4jH6Th7FySP6a+rR7RZgomfuYh5TCC
	RxzEjZzw+ZHv8LIdUJ2wP3dfjYu7MySTYiCXEx7UIvqD1JQUSqiI4jJ7Lw7tfkNSSQfM7naopy8
	rVK2XzFd0ujCS5mboLlJClgswciPNBx+kBH9pJlyl7Vh9hcqzd8I9ieWuIEmtvrUuYYTMwhk59q
	N0Vtu+OIBVHcn/Fu2DdbbmuB4C7bnohjw8B3Y6D0Qn8gCf4cMkfpxFoNQYiRBDzTAOzhj6IZ7UX
	kK6sQKjc7oDYs6Qd9r4y2oVFaknDQE7WWmhTB9i+iwoy0/OHUSK2/oY2/kbO5ahQAzq+tjQW4kv
	GzoYwjM99kDZsuUmwLeNzyA==
X-Received: by 2002:a05:600c:1f95:b0:459:db80:c2ce with SMTP id 5b1f17b1804b1-45b51799428mr2845525e9.7.1755806838960;
        Thu, 21 Aug 2025 13:07:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMhnqxttMNkrL8PAxIX9Mfq64uKkvY2MjzJ39LtAH2Yg7PxwVl8kOZ6CXLaaMF5rYTxrWwyA==
X-Received: by 2002:a05:600c:1f95:b0:459:db80:c2ce with SMTP id 5b1f17b1804b1-45b51799428mr2845125e9.7.1755806838506;
        Thu, 21 Aug 2025 13:07:18 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dea2b9sm8988005e9.15.2025.08.21.13.07.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:18 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH RFC 04/35] x86/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Thu, 21 Aug 2025 22:06:30 +0200
Message-ID: <20250821200701.1329277-5-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CSzb_5NkjVLHrjQMtG1wIuqXe19kWAozUWP1NQYfdsc_1755806839
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0B8B3C000A
X-Stat-Signature: 7zcmxmzfd41ra6pgq8b1ct143f1oc9ed
X-Rspam-User: 
X-HE-Tag: 1755806842-692805
X-HE-Meta: U2FsdGVkX1/gfd0WiAPHobI+alsxLMGwF8sjimT2COeri4qqltxm1Ykt9Rqxn0Z3uTsgBcO7VbU7++qF22YD3TnxLLNUHovks6FRxzVA0hISpZYjhBGeBe6hkEupYTg6uEXNJ/Np+Al4Hf93p7j2cBrb9ypIORRVQ+oE4Ds6vX6d3qX4QN8B5LYl5dOLOuz6h0GSgNngtGLnbbUS6IctUUNNej+GFwSrBdNJtwIfDncjw+P1pr4GaNVTN1W64EII+3EaGa1b9f9M3kFLBBhp4okBhnZAtXNBucK7Yxeu7sdYVXt9NIeAg/X/1ym//LRoiWO+7f3eaiMEN5l35bBGRm1cl0e11oW8vMV94ogmGH8xxXHJIukF1w85ef92kkOsbf4z4ViZK6jbOjZgPfPRrRPyOPko5U4bmxhsV8qHtbCJTQ8Qjhuij9+BE6MQ0Lj1O5VuJqn72WHOGu/OdL+k6YIjVUroAJP7J/DqZZYz/f3s1meRF2joT/gh2yn5JPCpJMkYgxaXJ1PuubjH0JjPtj8y4gb/dXW5TecwuXsTJbpQa1/SblePVrSx21ldZrgg2U4P29YhwfFy5gcx26BAm8yVYQK0b7BgrcHj9KiYfUyNMhrbvtR50vpFfDXA0qOpzTQqbRJKMg02inaXNt2oiRfSnedFUCHtSPAX5c24BU4haHlYoVozPftQUJf5EUjzs5BsfnJPk/uExdeYTGDi+zsDUFBNwJlw6OKV2lcX0k1kJk8JYTYMsDTVnpKvy2mjVOG+N0t05Rz2/iHIZ0sSzBja9n4tptyHm50efPDAUzuOD5nO0Jdk0CvD59JUnXuFErCCqqnQgXLqZ+F971ZD3o4TbfY4OE944MWNqGUmkFNmCBF64i06VcHefbiAYG5mnAUL2fFM4pYjbfpLBbMrY/gCJO78OWklbjUiY86eTXRnkUVPuYGCYSkGe3g7DzqUCs1JbobNxUP7Q8CIKVD
 Xd4KbAG7
 OyT9eX6w2wX3IpawCwXod70ZXFUh1caf+PIaeITjX4HRWNCq0zUFX0oQ33SOJHujAnqRlky37++HZuX4ki7kUprRoKRWDNClTxNMzPCC6QldLxaykeMl2BHM9ApJSuf2rZOooYgHcY/hlScav+OUS1bUish1DqIB6fWqQ+QX41PgUQW9dg4CfcSUh9tax8H4pU7OnNXOjDYgv67WjwpC4e9K0jIbkOjPH1LM/t5qwNXZWJQ1KOqUdbXQbjDYCZpHwveovkzWeJ7wdtKtS6xBSueZmgtY23FNFOVua1M+Cds5zRJsb9nTtbye0zDDoPEvb+KNXDtsDP4+9T5r16L9MYsSereO45rTZ3Zy36gLYt1nA4viCiYvjwdlNXeBpChag3zh1dUYvVBEw+eS77nHJ19UsvuS/jJItgvx+4ppxAkgmHkVsOOfg1qJkEL+LA7BtY8HfVb2OLO7s1I7Blw1JF6LmBst9UxYXv5eUGQmazO3+/hh3drjmrWQyXlxDP1YSMLzkj/xfN/rbPymfb5CUyiJDmZK0PmRuoJqZot+tFM/J7+l9fLhxNY5D/wK9iuQDP3SDeVYMp5t1p7w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
is selected.

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


