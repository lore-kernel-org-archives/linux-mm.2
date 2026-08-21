Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA93C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D916B00A2; Fri, 21 Aug 2026 14:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DE356B00A3; Fri, 21 Aug 2026 14:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3FE6B00A4; Fri, 21 Aug 2026 14:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D69266B00A2
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:58:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68DE4A0242
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:00 +0000 (UTC)
X-FDA: 85126186320.15.E33C86C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 27AD01C000B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:57:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OeoTMPEa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2V2mpWvyYuIz7GKVVHxUcELAybMhQQsAX/9av2OZxM=;
	b=UM/xdqcEtp7m8LKAc3en0X4Vy2/2fCTdEhBvd6M0JqNHkUHu+kdW378LBo75ByeSz8tv/k
	OMCFp5Y6likUU9/CVHGJjN5Wq2dy8WHMeWbVk0hdtumeBotGecUqCCDjRyMMzWH4kZ4+QP
	h7QQogINIKAh4rxLejYr1PzcsAPyvXI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OeoTMPEa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338678;
	b=o6Fh9WzVEjiFU5vs2DdqkbfV6T5qvBMAieps4X0qyW+ZWiY9o1/nb+Nnl7psLyc7PXJVYJ
	P91UrYfWlI7qVSAXbGs/JJFU8w6a+ff+SrpyXYUCb8cAP/e0T0CXH+HjZ/f3kQV0ZgEOmp
	xqUB658iiblm1Zm1jlL9nRTDwSYCAzM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e2V2mpWvyYuIz7GKVVHxUcELAybMhQQsAX/9av2OZxM=;
	b=OeoTMPEaRaxz1wIpZAFP/kZRL4p2RUWzLz52yLNe2pYK5zLJJ77vdvBUoC5bsvFaZjTj7+
	o4J9bwfwbl6OMAlCB5/O3nfUB+MSYj19hFZiJHdwZ/QPKcDMJ85B1Mr0oNWJxcMvQyy8mN
	eF6MUeBvoCZ6aVBz2ZIsAHT1hudwHRs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-I-s3mIWeP0uYmHJFpF6pjw-1; Fri, 21 Aug 2026 14:57:56 -0400
X-MC-Unique: I-s3mIWeP0uYmHJFpF6pjw-1
X-Mimecast-MFC-AGG-ID: I-s3mIWeP0uYmHJFpF6pjw_1787338676
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e52306621so105788885a.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:57:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338676; x=1787943476;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e2V2mpWvyYuIz7GKVVHxUcELAybMhQQsAX/9av2OZxM=;
        b=tNlz2fLsCOEGKngME+6xi1Zf+lu3qXYCf+gvkviuiud7Hm6WL6Sg7XiyRkVOjBKTSy
         hGWTrPwI275sveqKbuT72iZ7wGTkz3baYjTM3pG+Kq43nZzqPRAaq21kspONeZeFgirY
         nYqMAZsw0NuMGhBc+VL7Li3WYaJG95M+G0oCrFcwqFJ4H4dtv1omOjXYRN1n+jU7XseF
         Iiytw6Ae9Y08v58RwxIvwtnjEWDPtO5QtQ/lh8sWp+BxtMOZJvI1S0oDRvQaVo+ORjbC
         o/iRV4VMbg7nJW9ga0sTEISEYMjyaW9G3eh18y0/e9Zi35Q8ISoNxr1jk5y9+aLdQLJZ
         K/4Q==
X-Gm-Message-State: AFuF++neeZnfS55WGCFy5UVaw/PwMxd5h7rb1dNw7QruCeus4olJ4qMy
	iWoX7H0dqjvS4DXF5P9KxgXhwm1i3ZrrRSAwTZzR3DlOu8VSxQtTgW1Ii6y+2V+7IVpXEIMmi/k
	e/Tp/BelcOJHXsHYTQeHghXFoeSOALP+xD5j9C6AfVQyCnIGA6aC+
X-Gm-Gg: AR+sD13iD+jmYalfi1tsOHbwcwpiWCrn6Yd0ESxgvrMUKUBma02K0g9tiq/dlezFB8G
	brFiFATw4vKhtmQ+GMZIAooflfYbNLHVva2BeNNDsuHDeirAbJWwdWQRMLrduIehy3PrvRM0FcE
	zhItGpQiv97Rk+mVh0Oy/JHZy5EP0T1DRqEtglpaxSo3/VU+B21YjM2FHEoAT2YAiOB0Wmrk87r
	bKq7K8P/8MFirNl7OL5K+SH/J27d1qerE3E+Lyw3E6mIwQOC43HC7tThZ5h1fgRg1AKRYg37K/r
	UM6B5tuwPO09qdTx2XyQzjv78EPzWGvtbj9RdrfmE8n0XOwA/Pd1HMcwFClseeK/2gmpxlMTsh1
	aLRoI2UgTgc63s6E48T0d8EAD/RX4KaHhLsS4v7iYvN05
X-Received: by 2002:a05:620a:29d6:b0:914:bd3f:b6db with SMTP id af79cd13be357-937394278e8mr807011085a.10.1787338675677;
        Fri, 21 Aug 2026 11:57:55 -0700 (PDT)
X-Received: by 2002:a05:620a:29d6:b0:914:bd3f:b6db with SMTP id af79cd13be357-937394278e8mr807005485a.10.1787338675183;
        Fri, 21 Aug 2026 11:57:55 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93720586ea5sm655734185a.38.2026.08.21.11.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:57:52 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:56:54 -0400
Subject: [PATCH 02/11] mm/cma: include linux/cma.h in cma.h
MIME-Version: 1.0
Message-Id: <20260821-cma-memcg-regions-v1-2-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oleuUScetpxuIshy2aom0tC_skJhdLEaxykAaUZND0o_1787338676
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ajko3bicmko9nc34owkfzsdfmfchh3h7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 27AD01C000B
X-HE-Tag: 1787338677-57996
X-HE-Meta: U2FsdGVkX19VyL1QrgoR4GKSaLydFLzSqExFIb13TM2HmVa9CbqZadEASU+nqioJ10CX8vna5x7gV2JX6+sAuqQ1VMDG+MS0/XM32woNtjMMUmLpgotDuC5fvJi8yNUNHs1t1ZvZZfIDUCbiFkGz02o4LtlZ4S5KqfHWuUcBnusjbjyaraWLYY9DbKvw8O0JKW4jZRb196CYMfcX/u6639Pc+G3XqjCGyI54Ja379hwXeut0FJAQJZzAbOLoXAEhmymG4TIE9GRnXlwfOwBFx90ROupDxqDOmlSHHCtE+e+rVjSJAxx/5zPiJOY4bsSEUJDtVDP9TVu6o387IIhy8xIB7++9PppzkW79TR9HOlKhS9d6twkOtwHyhdjfSt9wc11hIbA+3tVRZCw81FG5QfgJfdOHg0SvKxF8frRsqJBAbzc+3WBnHGMRSoBKb3z21IGpjhmHbXvo1+0Ej5+rcTrH8obzm3y2KuF4j04EuDvlW65h9yLrv7fkJznvGOV1fn95Zm6Mrl7W9jHsiAtCnpMC4w1j2tLNTmO2JXljce07I0jHQhaxTd82I8xH5205mwvIYQlDoTutWxeHJXNi8ZgVW6aHdS+PWJ/MPLAO43FzprgTtIWXJcvVcNl280sHyUcq9odR/R1VoW/ZJQx9GGNfLukk7paxbPTl3rbRnXO42TvCXsxngxDZnpfN3D86aNNE70GkknQKWXBG+8YF8mDLTM6nij/B/Jwimv5CowSTu7PrayyS/1NhcxTR2KZE/llupFYOInatVus9c5GlQWUiHvOWl24KCb5kEE8lOpzYXJLqdy3rdOEDhbCUr6ypy1EhiXMK3h8XpQ9YsWonZ8gNXLyS244x4bWmmBNMn8Jkc6MuA9Y/StQ4aiXYi7e/Y2Yn2JmTgbqNhEop1Gn1W/X9N36MOsxIXxe2aqWR6IGfKqh6tQ3aEhPh4y+D978DOBvNxLJgHp27aFQKQkU
 wznTBP13
 9I+32ahrlMvtO1cY2U4QbOilFH+eEXIa/k1UrIXM6yRfu445acyvmGEqd2fFLdxhdSRRiw8kEOC+N/H1LrB3A+Yy7WqMIW2AsrJAJ+Pk/kmF89w3vdbjEDvZFqu0gX76qLy8FcQzgZleq7Cd6YpBuauiRM/l72Dil0wiBGWY8chmwejLfRxGZEl35uLbFPi4XHu+GSJtVaHetKuX7JAZfHYjOWEJtrvAXqBT05tD05zhbS7Tmj/0dTe+dJ31mbKDTGb1SrWyssNCTaeRRmXx9ZkWM75KXnOJmL24NYsh33VkuDJ6p/PUUqlIb+/kNV39LenRfXuXrGy1LJdWFx3/EFSBfE8kwyQu08u4JQigSQZYUikkuOMXFTGUtANJ9gj3iYHOwFsmR5s7jH+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cma.h needs definitions from linux/cma.h (e.g, MAX_CMA_AREAS,
CMA_MAX_NAME), so including mm/cma.h requires including linux/cma.h.
Make the dependency explicit by including the header directly.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 mm/cma.c       | 1 -
 mm/cma.h       | 1 +
 mm/cma_debug.c | 1 -
 mm/cma_sysfs.c | 1 -
 4 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index e1820fb451e4..03f98f6d45a5 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -25,7 +25,6 @@
 #include <linux/string.h>
 #include <linux/string_choices.h>
 #include <linux/log2.h>
-#include <linux/cma.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/kmemleak.h>
diff --git a/mm/cma.h b/mm/cma.h
index c70180c36559..0c9de38d6bff 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -4,6 +4,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/kobject.h>
+#include <linux/cma.h>
 
 struct cma_kobject {
 	struct kobject kobj;
diff --git a/mm/cma_debug.c b/mm/cma_debug.c
index 523ba4a0f9f7..70bfc6fbeeca 100644
--- a/mm/cma_debug.c
+++ b/mm/cma_debug.c
@@ -7,7 +7,6 @@
 
 
 #include <linux/debugfs.h>
-#include <linux/cma.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff --git a/mm/cma_sysfs.c b/mm/cma_sysfs.c
index d5bf792c6245..e4ee35bc682b 100644
--- a/mm/cma_sysfs.c
+++ b/mm/cma_sysfs.c
@@ -5,7 +5,6 @@
  * Copyright (c) 2021 Minchan Kim <minchan@kernel.org>
  */
 
-#include <linux/cma.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 

-- 
2.53.0


