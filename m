Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E450CCD1B9
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 13:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780198E0033; Tue, 21 Oct 2025 08:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5618E002F; Tue, 21 Oct 2025 08:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538058E0033; Tue, 21 Oct 2025 08:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7068E002F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:59:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D3C91877F2
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:57 +0000 (UTC)
X-FDA: 84022128834.01.7EFF5F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id D2B168000E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CUSdMlwb;
	spf=pass (imf30.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051595; a=rsa-sha256;
	cv=none;
	b=kks1wY4HVhEW/8d1ASht5kNDklFiX70GY1w/OlEIrZ9NrC84QEgJTrVRmq2IP2sy4iL+tu
	ttRqjEVhUA4hb0vvXRqMY5AFxniQylFsSgk3j69xdIdNz7UvSO/wFZn67WIVBtruza1MqA
	eVkeL6/l9Ozw+OeQyOhRgPJJCAsXIjc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CUSdMlwb;
	spf=pass (imf30.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pex3TSD4VopdNGhgViIupu2qOIUkRM48nNF7NdH4ZpQ=;
	b=7ABs474toWBmV4tDoPPPbdR1kCM5/ukC3dYNHil00zPGpzFDiZQiRJybuMWZSVsD5wKrGQ
	yXQ5+pW23MbZxpML70QgjBrAtXaGd1gKYdFWnFQq8vgbQKbk6Yv2UuYaTqN32cGxK59g/m
	lP6KpK59y7Xj4vzx2CeVAgipZarXapk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pex3TSD4VopdNGhgViIupu2qOIUkRM48nNF7NdH4ZpQ=;
	b=CUSdMlwbA1fkANl7LncePrQAv7niXgA2I7RVJxLLTbDWGzTb8LJO6p232QqEaO+b1foqQ1
	PK0ptEuKsfyz8Dnx3xg0qJj2IHIX7YsEWjX5jKDWYm0wP3qqyNgQUJa5y3Y32kR43blWo5
	C+gfGlqZ+iGBm8K/pQdIx+w9u6jotlM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-oIB4EWcfObSXO5rr5kV5Ew-1; Tue, 21 Oct 2025 08:59:54 -0400
X-MC-Unique: oIB4EWcfObSXO5rr5kV5Ew-1
X-Mimecast-MFC-AGG-ID: oIB4EWcfObSXO5rr5kV5Ew_1761051593
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-471144baa6bso32647615e9.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:59:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051593; x=1761656393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pex3TSD4VopdNGhgViIupu2qOIUkRM48nNF7NdH4ZpQ=;
        b=KyFHaSM1AmRZPmMP9Pvvsq7E/gZzqu1u5H+yvd+YW8v5H2GAtuxqcpAiMDZmnwBvdE
         qIwSTu/8+58C/GPngW2jhGrcQiYFFnLIm0gRXvZdWuOQAQf0u8nfHokPGVDUOmIiE5g6
         tLSUX4hAGX95CAtjoGCsZhb6zRthLRlk2TWvt4W6FKB2hkqvhJkXgZSd5dRsDrjxvHQu
         qzvw5K56A9Stb8QGeGuXgZnN//RmY0ODuYXgnGg5VQlFuqFc9kLDHQIialS4PO3OkQkB
         nVRJPhWsdwKAHRx9Til2gqzNlnJG3+GbBGr+CckzHbX7MBd2IUY61y5rn+bfUwMcU0G7
         AFgw==
X-Gm-Message-State: AOJu0YybNWbsKdl4oWh23VVdLg1lm4JsSmzBNb1nroQU02xm7dz8FISP
	h3xEf7Ns9pVUXxjyJBpXxEsW6aWUk9EOIv7lBCbsS/fKq/l34V9ovK7cKnbjdtdDHQPKTXvyAoL
	o43bcz9gzqeS83u9X6UPobb685uZ5AMBRDbe4T0XLTLr9MSB5NMRW
X-Gm-Gg: ASbGncuO3fwcM+eUl/l+TTBghBkg6yEOIxAXouLcROl6Z6/iWHy4Gi+NeBuFMwoO4eO
	6XeC8kIk+ht2liJbjS8pXf8u4rpP9al4iG8dLMRgqazfhhwcfa5hI29g6GcpSlA43TmkxxirG1F
	9wiOx6kMPbgz6HnaAtXIL0Q6p325HQSS+qn89T43Okn9msZrPDV6/ilcfgKh2akxE9fEdAchDsK
	AyN4jlEcupQ9bSRqVaQonoZWPBNYEDpvcNGKC3TSR2N4DTSa92jDZE3wykznrCndnbs6EnyrW2W
	rdHjn7dN60Chjnzqb2vPOtpsm+w94aJSLj8TlQvUKn5PJ+rPTNW22lgK7caXksD1OaBy4aNdV40
	ArFruTJYz876f7Vr+X/3Wf3S+4Y9q9FIS0sMYK/DadczzW6fRkyLl0cBOGhkD
X-Received: by 2002:a05:600c:3581:b0:45d:d5df:ab2d with SMTP id 5b1f17b1804b1-4711790bf23mr118755725e9.26.1761051592811;
        Tue, 21 Oct 2025 05:59:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEA4wZ2YHHfGwBY+P4joTOmyMCpMPrDXxQSxjIfhLQThHNmEp/4Y/9hLtnfofL7CHt5koNYrw==
X-Received: by 2002:a05:600c:3581:b0:45d:d5df:ab2d with SMTP id 5b1f17b1804b1-4711790bf23mr118755415e9.26.1761051592292;
        Tue, 21 Oct 2025 05:59:52 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-427f00ce178sm20202274f8f.46.2025.10.21.05.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:59:51 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 09/23] mm/balloon_compaction: make balloon_mops static
Date: Tue, 21 Oct 2025 14:59:14 +0200
Message-ID: <20251021125929.377194-10-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Vxx8fxDAqV0bkzUGdkpbD_ngpAWU_MtmqoeaY29RrNA_1761051593
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: au6y9cxe8gusos4kzpur5nc6okzpw8xp
X-Rspamd-Queue-Id: D2B168000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1761051595-224307
X-HE-Meta: U2FsdGVkX18RzMmtiwlE98eezy4cbllSL8KiZ6KLceO7B9lWvjJOuYbFaWr7nm0VKoZEzBWwU51PX4+qTkuBozEx25p8X5BMXVdE4E6FFwovaTWKKukuK95V0KsOQZyP9dVdGme+ZZtPUnmqeAsNrXpnpfceL0qBRwJ/xTLUFM6bibNtTe+Wc/ItcVdwZPYKjXu15Xr/L9BGrUtFANMSVV5VyDkRHbDRPWLMNot9nRtwYSmEGLHnmlBv+Wer0VEsKyBMQ5BpflWSE31DIKiCguFQ+B82J07Iv9OP2QmFIWYSCaGwGCINBm3jBp75eS03oRj0CQSyYFe9uDLmh+jzjzUPQtmghCHACoxWExBbEPS2oKWeyZdZ69sFFGVlPsEDN4sB+hBdT1knHT6qRvNt/Nc7bROAnv8M3J/Z2eu6xM8bN17Bj9CMFdwQMZ8NenNwBIQYjJR01YXMdGYbgZv7O/p5XvUa4sk33DNGFY/OSHrQaEmP3U9xMRX3217suT7mlpDDL35x11IN4sBzUzCFbHei9jhSAh+ntsclvetSzmCdYyMXZLZFwCs9ZwtzATiHBTsajSKxnDjs2byLL8GQM9z58MQRMDSHCbQLimTwE28eytPBvB86eJTyVUfGA0oZXqYUx1MQEei9uWULFU/Xzgn4374c7st3/G7nKEQnHcaQAyYgXbTsmeR+QTnAu1+n8NbI9nff8TXAJyNIe1Pddb/RbGndizZMrJS8oa8OFQp159gGFd2rBknBUmW7/xc7i0GjzvncKM8EUo25eEN27mVJPvTzMW04lGxUw0z3NDtDizH80Cldk8SzEIhB5rFwsLec2UCcwSAfHJHwjIwQ4T3euwzQt9oUmLCPQJQpRJwkd+Fj09gjXm40w18OnQfkm0eNir0VTyvPXsZm+P42HwBdTsM4aViKwiiFmJFNg0qjjt9Sh513xVwOh9GpecaU2aQTDiVVQq5TpIZgL6/
 HMLTtUi5
 4jLXBdBu6JpcdP18+dJKm/bfOM+hmdXm2jZqRBY9PwZc3qfAEOsPeC6p+SWo3M0SNQodDO2+0bKW4J4bvYNm4lRo6Npj5szxkbBj7BJdqZDYXUWDPZhKvIkSRMfrpqmuztcdVpmiTxGreNyRhPH7YeLEBGjG/dOD/mBZn14S+8O0kpBysJwW7EOyeJz1sgoKZjbxmofdEN58+CgF9BwPM9PXTimA08gvUe82fTPNUiqoYGFF5Hlo4BdAdl+HvBPNDwNqDa4b3Gao5jr8cM2Iq+0vIJWBov+tdxDAC4YnwGXpWTg9NNYfKuPSX+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no need to expose this anymore, so let's just make it static.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/balloon_compaction.h | 1 -
 mm/balloon_compaction.c            | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index ad594af6ed100..7db66c2c86cdc 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -78,7 +78,6 @@ static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 }
 
 #ifdef CONFIG_BALLOON_COMPACTION
-extern const struct movable_operations balloon_mops;
 /*
  * balloon_page_device - get the b_dev_info descriptor for the balloon device
  *			 that enqueues the given page.
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index 28ef0cb6b3bbc..c44e0b62203cc 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -286,7 +286,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	return 0;
 }
 
-const struct movable_operations balloon_mops = {
+static const struct movable_operations balloon_mops = {
 	.migrate_page = balloon_page_migrate,
 	.isolate_page = balloon_page_isolate,
 	.putback_page = balloon_page_putback,
-- 
2.51.0


