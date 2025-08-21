Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AA13CA0FE2
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789158E0040; Thu, 21 Aug 2025 16:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738FB8E003D; Thu, 21 Aug 2025 16:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DA8F8E0040; Thu, 21 Aug 2025 16:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 46A4B8E003D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19D135930A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:29 +0000 (UTC)
X-FDA: 83801851938.16.7ABC7C8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id D543840003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DpJ2gAzW;
	spf=pass (imf07.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yR/3u5W37RASrGsn/s3pQVQ78UUgH4ByCavV3b4UG3M=;
	b=715BfOIeqixjKoQ2LCbzn6t/F+55c6gmemc0fW+ZmK7+iFawyNyCImz7AXQ2icKpYZwybC
	Y7W6EIjbKI01qav+wFVu7HMQCOxu0xMJMsy5ye7wUDN82Brwk1NjHysZncZdZUNlVv6ASI
	9QrZ8Y5NKv3lt09qE2sAqEIJTWBB+Hc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DpJ2gAzW;
	spf=pass (imf07.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806906; a=rsa-sha256;
	cv=none;
	b=pTvkDw1OEIEoBEXEe+oyyl0AyppY/K9AfmAiVOSjJDY1Dwj1BRny8LGx12XqqBFevyq96d
	YkenrpAkmBvjdMv1U/aJ1xnZcsUN9DGsJQFox5KQXFRCeW5adYDCb0YlUqEtlrBvhh1Tg/
	5ysKqSlB4J/nKY7PqukzuNXTzEvOOsc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yR/3u5W37RASrGsn/s3pQVQ78UUgH4ByCavV3b4UG3M=;
	b=DpJ2gAzWYwi7Z9Viv2yUpZ7N1lD0RdYGI/sPgYXnlupS2AH6sXLySPpgMos2zuETN9W14L
	e0gW2avxc0iiw7xV8wOmW0OMUEJNoron21zFbawAq/1u6csGxhGbsjknuPmfMn3XsRsaCS
	2B3Tt+Fth9wJqNKKRa3Tchr1gEJuXtw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-BByiJPSkMkqSECIKNQgPdw-1; Thu, 21 Aug 2025 16:08:24 -0400
X-MC-Unique: BByiJPSkMkqSECIKNQgPdw-1
X-Mimecast-MFC-AGG-ID: BByiJPSkMkqSECIKNQgPdw_1755806904
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9a3471121so763874f8f.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806904; x=1756411704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yR/3u5W37RASrGsn/s3pQVQ78UUgH4ByCavV3b4UG3M=;
        b=G6e4GXQhdU28OQbAbwWuQfWSC6ECd47/dWhWPzsyl1ArBEYuRnojcvk+p/9OCsTk7L
         UmScGFxxYC/56Nzj78q0iL3PLWC686hTzki3Ebwr1om/PmaQdREJiOx8xhpHZTMhk1oV
         vC4TndnPg3ZYOz1X4xnq8O5mMWXfhqgm4uAqFB10rQbTPK/aBD+5AbVliATfyrRkMSh1
         R9JieWdsaKHVw8apWIrxiNv0fFpAd9wLYMeXwFxF+qiWT5e1qpgtCUnwplOTBXFxogtg
         ng4yme7yyzbASeByRckyR5Nt60fb+v/6VcQFJjZarqGcLEMoWiQBvHRH4wuf7jTkBNku
         NLdg==
X-Forwarded-Encrypted: i=1; AJvYcCXBT1t6uErRpZyr3Qm7CsGZf6KQeOehe/lCnkpLvEcEo0WyIijmSwyae2L/nmeg+HuhSY9KCP++4g==@kvack.org
X-Gm-Message-State: AOJu0Yxns9W/IAwnJMkTuZhbKwCaqtj9i4FKJhY4C0hv4sIGMfsFT8Kh
	oIxSy4EONfbVAxnQAy+dUHOxXUva4rOqrUDqyedq4mkw+W0BxO94Wt1WC2UYoA7FIn2Rd+UKbku
	3OaUBx1YMVk1zR5vm+jZuIcxax8ikRrvVGypkbva9vP5jfQRiLB1E
X-Gm-Gg: ASbGnctoiI2zzKnUikX77OTrbtgfzYspH6mINo2VPSJOvCSdIdh+iEFpCdAoOpkJBWg
	bJhEtU571oesLdHpe5oRi+Rl4X0GOD9tLfFWTkmNegIiTOTrp4BoaNsSIxAXHFMnr3RdfMOxiDT
	WODcVtJSHu/2UTfl2W115+wPY0Y85/mP5+dGFSzyqAGt47n9j6DT9XuRoD/NkkxloPDxX4eEhp5
	qwUUuKNmNcntIHwtWf7yq1qHLjrYd7KAPhDrrKLx846GdAfCEKO15QrLkGyQeut5d72CjrC2yjB
	L2CPWV/fZUPXDixGu1BhwKMJM+IUCfc9aQAHV9VS07/dNdEdzWs5CL8IMEDoYN6uEnfQcK5RBfP
	SK9qcLgn3nrSjUXDdDNLeig==
X-Received: by 2002:a05:6000:310e:b0:3c3:5406:12b0 with SMTP id ffacd0b85a97d-3c5d53b40abmr247283f8f.30.1755806903628;
        Thu, 21 Aug 2025 13:08:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+53ePp4gOBoZK5+aLlST4uu6G3xHtHBUa0vmdrbtPfJ4bf44S3Zn2IpCr0m84pAneAOD81g==
X-Received: by 2002:a05:6000:310e:b0:3c3:5406:12b0 with SMTP id ffacd0b85a97d-3c5d53b40abmr247245f8f.30.1755806903113;
        Thu, 21 Aug 2025 13:08:23 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c0771c1708sm13032145f8f.38.2025.08.21.13.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:22 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
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
Subject: [PATCH RFC 27/35] memstick: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:53 +0200
Message-ID: <20250821200701.1329277-28-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iLkLA9F1yYN6OhAZF6i-LAiQCFYaR8c780aFH6DyV0Y_1755806904
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D543840003
X-Stat-Signature: u3o8rfjoiu4sbjegyri38miarj3z6ngu
X-Rspam-User: 
X-HE-Tag: 1755806906-850868
X-HE-Meta: U2FsdGVkX180Zr/KzL6xbDQ0zLintZ+R2FdKCfrxtlYmbhuKYxYeMocaELCBSHW+SLtjGKJVw7/sNWsbiyqNjYyfE5IDpHXqNwisUe4kw16tHQptEttNIaAYppr4yx5GSCxY9fNt8BxwpqDmVOWUFfv7i/6lfWhSlbSDsBHTYcTVzQm96q+HheZsGNdlteakcpzhN09I/uWZHeXxRtG3zTCJky0ZNvaOc31Ks3A0XrFPffIxnqIdmGGQV9i2BKqZyd9vTsoIkDgoydyVZymen50DRFnR0iYuEbSW7nKNDukK7Wf9xLLTZp44o7+ubJ6fQ43zuEM69anTpCpfcnVkFa0pwQDXFN5RKkFGGbKk820+4sTtGArgA3vTowKDe/yeJoyoeZ623o8bpoEuxiTb8irDBMWyyzXIFoevxYDp6nnjiUlOU66aVAGFFrnXChUShwv9O1wDlmZlaFkcW+rxsJ8sp6MQaXmKn/nniaB3aMARASjoc6uOsBY2S8hfa6VmKqdeq3+uO9w+3smPBHT3SFkw0gYD8MTIzYts2ibhYjOz1lRNh3CoPSgJY6v7PK4Dsmv5xQxDFeyc/LJuWk1qr4Ap5I4ZQzVK5clD4c65Fk1b0gwX4sjab4HFfK9/6xFKn+kIkUQIdgL40ABicLUY+PmyaF1BT3vwBhyqjBBI/vOeLygwe5XLwVF2UkP3u+Bun6gW3D09mMX05s4BAI0XxxapuX5nuVCgzN0OGeuklEQVA4EXG/AtPeXpqy0vH7p4+dvfIS6blZ14FWTFabPBX4GPuFJF0LwWK6GWjxJ9UQsJiIGBegQb4dGYc90gZuIA3hasm+DK48YTKVJKdshuEr2TITtoLBibJXA+oNnXgWB7vBhBIWpj1wt7eY/BgmJjeY2LP0Z9e9noRRveG7ajFEt/+a1yS1ZyR+oyjgsbzWQO2rCZ4orAT4XA1pSZRqLbjxuD2elp+8FURkl+WTn
 oOANIUHI
 JI3zcFx56dg1ePGPywdy/kU1zw5t0G4VReiu4A6Iu6wm5Wkm5bJNhLjVc3EQYE6xAGozuOm27rTzVv4QxDCdO9KZV7xGewpQZdId3opuRM0LDNYG/hs/sLFNS7UIese2XyK6dMXsIlZeoB0ZbG5RSeBRok9YGfEMDi/rCt8iNQ7imiDJtMWtom/qrP7ywQsUqE4NvUDPE/iQPgqbcK/U9JPB7VF1D52Fs1Cu/04Fc+PaIxLhsQLlyzvOcsNijyV8I44p1MYaUpR/0cJSjZIrxDA5cn8jSIL2c+8qEdVh3SfFnRSRuPN+mjDO44Pnxr7ld3/AGeJGx3vBeM5xi6B7YeO0X4HiWAMK8GA4HNtE3v+QwvAklDK4e9xArgm+BiiJeIleXguGEo4e99sFaix+5tjfYJDXbZ8TnVncpwr2D2y6DYu81k5t9TRa9GtRCXBdwNspWCjbAP0ogwNTdzS2x2+VszkmFOtpVlKUpgcfRyfYJZAIJvklyN0Zu0uD63kreC3y8LUfoAIN6d+c2rk7dwsEFL13pcge3SogcfBur9jeZ0hC91JwSIJFXw49Cy9+bdsQvXsNlqRNH/5PR/DGLQGjAc0BZqzP53/PUwYD431Gz0Vw9TXspZDyqOt6dT8VSBthSHDbcG0vpLYzkqRPsV2j946pLDSAy9R9l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/memstick/host/jmb38x_ms.c | 3 +--
 drivers/memstick/host/tifm_ms.c   | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index cddddb3a5a27f..c5e71d39ffd51 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -317,8 +317,7 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 		unsigned int p_off;
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
+			pg = sg_page(&host->req->sg) + off / PAGE_SIZE;
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index db7f3a088fb09..0d64184ca10a9 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -201,8 +201,7 @@ static unsigned int tifm_ms_transfer_data(struct tifm_ms *host)
 		unsigned int p_off;
 
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
+			pg = sg_page(&host->req->sg) + off / PAGE_SIZE;
 			p_off = offset_in_page(off);
 			p_cnt = PAGE_SIZE - p_off;
 			p_cnt = min(p_cnt, length);
-- 
2.50.1


