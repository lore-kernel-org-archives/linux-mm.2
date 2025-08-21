Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B343CA0FE4
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D42E8E0029; Thu, 21 Aug 2025 16:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765118E0027; Thu, 21 Aug 2025 16:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FE728E0029; Thu, 21 Aug 2025 16:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 492558E0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C30B51DDA41
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:21 +0000 (UTC)
X-FDA: 83801849082.21.C412487
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id BE27A100005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N/x7g2Gm";
	spf=pass (imf14.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zfh98TqNQqR9uCNr2hB5bEgIJ/15ql7Yv0zNbj5EC/8=;
	b=cEAFGYL8aGCOzfWfrcXEIFqXJWiEur17N3YHFIpxwH1yLIn7keyRI5l+S5M/R01KHveQih
	7/cFuNttrj4X7dmAS3Kn9yZndCHETrybNhFQAthErqXq+1Tq+k2q2ESjCnVjhsTemqwc10
	xnnDTtBgFV3nh9ubTd+gKqTjP+P73Nw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N/x7g2Gm";
	spf=pass (imf14.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806839; a=rsa-sha256;
	cv=none;
	b=2oaCjAk55LAzTTUHTumtcYptciBzUcwNLA9mQqiBqmBk1r03FQQsb++q+WRjVLfU+d3Jm5
	+r8+VOQyzuKbwYZlUzch0CFCtp6mgzZmSJ1RVDmZztL4d3zZsNp/WaX9zjOdOHIsTsEvh2
	vkrByMTiDgiTqS4DENJhQj8A7D+ZwXg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zfh98TqNQqR9uCNr2hB5bEgIJ/15ql7Yv0zNbj5EC/8=;
	b=N/x7g2GmM2Y+GNvXIudCJPlMxW6wb2pOQh0itTOdPgmVpr5bIiD/10Qgs0sEFtIJJ/Ionq
	y/oJ9m8uW5OgJVJRFYL6x90zADPzDhOnW5Cff8ALZ7yi2udqSNDaMe4Teseknt/jEeYZd2
	MR1bj7HBKjwsCepEt9I9fJIsGt9bgYw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-6VPUAW_BPdq-7cltMcKPJg-1; Thu, 21 Aug 2025 16:07:17 -0400
X-MC-Unique: 6VPUAW_BPdq-7cltMcKPJg-1
X-Mimecast-MFC-AGG-ID: 6VPUAW_BPdq-7cltMcKPJg_1755806836
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9edf41d07so651720f8f.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806836; x=1756411636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zfh98TqNQqR9uCNr2hB5bEgIJ/15ql7Yv0zNbj5EC/8=;
        b=n0o9GzStoit7yjQwSqxFRnSnKxfqhWeEE1FEe7PpQf04FbnI+WEjXHizIJqc96ixsp
         3TyZQjgdfkYJ+w+t43L0j5UY7JE3H9rQcHB4t93iU2saaBBPbvkvVC13BztO5wWvICMX
         bEA3W876p+krhGzcLpMtZBd+Y89/QP/bM2Gf9KJJ10JSczC7MIC8wEDnvZhZ9EaJEy8D
         MZyoh8J4GuefZcJFI3SVp/cbyy71jGgI3kbUIW29bq2yhtMykYGGoSoNwtbPWV6xHzbs
         sGwWcTg15jVTnvV6Bsxy8+nEjRDu1CFLzkxWlkOB4me+lcHCOzatp6zxdveAsH0nn02U
         6AVw==
X-Forwarded-Encrypted: i=1; AJvYcCWVahBWez2Pk7NlIpsne7/mRtY2lHsrvaF5GdTUj3q0v/j62m2RgkLvNDGfG8PkBysIQAmYKB+eBA==@kvack.org
X-Gm-Message-State: AOJu0YxYxrnikBeSHZcd9z9prPSzDqDeluFGtfeOsrPOCQlvpCGlmh94
	xe76GW05lm2hEgcX0FGKwXCzi3bmXyXvyz/peFHcPVlM5IHjchOJmodOKjKx3a40DrI1iBqB55z
	WekUrHl8zCSSyImAijFQpxYWxvUZTHixVISIIpW/HFsYVQKigQCQs
X-Gm-Gg: ASbGncsv9XKcwIcKVxjwmx6iz+vB+9a1Tx4Ir18aQYPtGcruM6+aS07u856pKLgHhzX
	oDRBG2+mOElu6iyaqPCSFybnB+WPEHrIAGbxa8HQT+uijZAnH/TLQMQZgaPA5qCWcCZ7xmL8CBp
	Xo/MgcfouSwLd19k7pWHsqMMHuCldLoWQfGniXPitlkJKfw4l11341Af9Y9Dpmzdo4XPjk+SGvQ
	cdH3aYcgiQZE6uuPH1Uw+A+ELXoAgWwkw+CwO+MF1vTZ3JdwMYV8HVcyqZbWthGZjfLaBuZaLK5
	GKeurTSP7nlZ+AjBqg7dVnm8urGBjrndmKyMK/XTSaEgKgBncRYEB9WKMMtjb9InP2Rg/0n5JWw
	8DDut0XL8AOYM2tJ622hVaA==
X-Received: by 2002:a05:6000:1445:b0:3a5:27ba:47c7 with SMTP id ffacd0b85a97d-3c5dcc0da36mr162974f8f.48.1755806836130;
        Thu, 21 Aug 2025 13:07:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpC+bUbLbCjHqucY3RiMYJPd72Xl9UYU3JmJwOiC1ZPXsKWXLLEiwWSHifO8HwGgrBWSbiEw==
X-Received: by 2002:a05:6000:1445:b0:3a5:27ba:47c7 with SMTP id ffacd0b85a97d-3c5dcc0da36mr162946f8f.48.1755806835650;
        Thu, 21 Aug 2025 13:07:15 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dc00a8sm10958175e9.1.2025.08.21.13.07.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:15 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH RFC 03/35] s390/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Thu, 21 Aug 2025 22:06:29 +0200
Message-ID: <20250821200701.1329277-4-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jaEmEL9L962cHiLEzcZwL4aakmOO_ZWA55zdwdohGP0_1755806836
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE27A100005
X-Stat-Signature: 49srn43dpsxrpdhk67r6bmoy7zar1ocj
X-Rspam-User: 
X-HE-Tag: 1755806839-937210
X-HE-Meta: U2FsdGVkX19Sb7qBw8b+2CF1MgrPc9ADhUrv0FCIIwMTibGvOgMJwnlO6lxkrCtqJMfq3+Tl2kwf6LaXcyaOI225Dnbmj/sl73XLcdjFXy73kzGfniL7sRaaIOkfOWp3wdTsaw65/BkB3+RVeVkm2dPCls4s2e2FWK4Rxht1BB7IbvJgPs2cZ2Jf8LcaIYGcR7RxojdIGJUwYCzU5eO0ZOKNoPWr+hHdhCXY/96lvU4MuunJstik2Bu7uJp4FmCjkaBwKKp1nAUzhzafrr/lbD3ickI7GdHVBLCLMrh52Gjt419+mUdh8wagfo9Y/HjZuWEJjBsRU+/7UdwHHw79gdG9xe/MvXtkipFAabxAf2FHtdKoZm/eCsFLsK1cYys1s5+u4RhVvpYr5IhvVzCA7xCQP7q9kyXayj6fqsJM1YoXxObiebLpqeutH/nIy2sNddng0H5RDVV+bdaLXk0WPsnxdWjzd1WhFgSd5HCTb2dGAJlcjQOcY71dMQanYI6hFxwqW9CaWkChJXdJaK4mfn+nQ1GgEmHk4Q0YyIPwxYhoNZpa0knvA8UiwxEFPqYdWGaWGqqPXMdnv4kJ05bonm0DaxSnk0Dx6O4wx50DjstevkkYV13ir4XL+FslayibZboUIq4vkJGJ8v/pbMJR1EIqtnDpET4QEB3tPpPE3rIb4SoK8xFnNrU7/7YL/ZsEXUJ1yMWms2SoNxbIB3IhEwvMEaprd+re5YrzfXp6sRhfsyii6PaQKuOOCh9YegP+Z5ZiSLu+P3xxWqs5vRmPhokE41XvVT1rqq79+BrxhZRspM09Ha5vIupJX0lObc5CY73lhdfu161h8vNpacJ824kg4AJdW9CAx4RPYKTcUG/1gdefQHzVufyREsrrFW2kAh0s18l19cLlgdgWhCeGTiNLk6RbUyNnun5zS9SkWcGz5pHonzpNpBBmT9DfvPDcMOCYw6LCuBeOZiB2cZJ
 /4Gj0U8h
 bUuYA+fg9mri9gXUoevdERnyuw4PJ0bflQdnnKy9IxxN162+qUuWlvs1N+foGqZptYDil7RH7WscCQt5fi/efS9rvnaOL0T7jM/8wmTR4WbjZ78xiRczdsQ4k22TTzL/augYkN+l607JBuG1+6fcN06nl92RFtrN2ALqwlFfujU4pNgQ4YhOLXgNIVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
is selected.

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


