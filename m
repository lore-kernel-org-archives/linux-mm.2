Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCBCBCCD1AF
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258CD8E0019; Tue, 21 Oct 2025 11:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230868E0002; Tue, 21 Oct 2025 11:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8BE8E0019; Tue, 21 Oct 2025 11:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F37878E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:00:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA42711A78A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:00:51 +0000 (UTC)
X-FDA: 84022433502.07.98722DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 73F73A002C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:00:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SyGmGBJ2;
	spf=pass (imf15.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761058849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ky9IQ4YAsBLfeIwBY21tvLCKpQrC6NzvR2EdWfDbaQg=;
	b=7pdCWQCo/o8UxhjY+HoRZnPgF7xDjfq3Y7hsKV97Q3jnXJWmc2IjN9Zp5YvJDnRocjWA2h
	MeGwSkw7rYG4ZLf3ZfCPcu5iIkeGSxQr17jj39lfSGFLJoH1ao/gGLxi80xTQhLYNvrbMF
	UfATEO7WaSzwtpVDh7UYCR/jkFgZYjM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SyGmGBJ2;
	spf=pass (imf15.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761058849; a=rsa-sha256;
	cv=none;
	b=tT3c0rHz/6lFFk6CtHMYjIrKtYF4hKbRx0c5aBbP4Yq8WLTwdJyRgsFOSR6fPs0G73mtib
	wjMgxaTMcszTBc3Xo9rOea/x8InJtmbva0K5VLcTRyHPyR3iepq0pFcUuT4QyvuL7UrH7w
	6yRdXJ1TFExz57mvE5v4GUTiuBlysmg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761058848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ky9IQ4YAsBLfeIwBY21tvLCKpQrC6NzvR2EdWfDbaQg=;
	b=SyGmGBJ2Ix4W6W2fWue3yvoKNCxI9ITG43C0OVwTJH0AQBGlcR34vb4/3YeZWoV5F83wFq
	KOFRmXWaGVZz7K0XVv3nZ/ClEdsHQmwbIB4ph48MmDLwkN6oSqzJtO+2R/hbwT/P7TeoYT
	pEHu+oDrLZp3wzK37KYfl6tGlKZ0tlU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-237-c0m4iRuwOCKqZOSE_cLXGQ-1; Tue, 21 Oct 2025 11:00:47 -0400
X-MC-Unique: c0m4iRuwOCKqZOSE_cLXGQ-1
X-Mimecast-MFC-AGG-ID: c0m4iRuwOCKqZOSE_cLXGQ_1761058846
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-471168953bdso41189005e9.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:00:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761058846; x=1761663646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ky9IQ4YAsBLfeIwBY21tvLCKpQrC6NzvR2EdWfDbaQg=;
        b=K5rHENVv4KzVUIIS+U1QwqmBIy07auJf/VFQGJNGjpKWuX8olcRWkXrM+qIpWHnNHH
         AvcGpNB1jirQBOPlOKznKmmzNhc7kP6pCizliU3SOiov9aaHOl/CPb2UzANUNl3hwKe9
         Ow99yWU6Yd4AoHAyW4kDSFLgBkn9qYwrp8l3aRrT9gBb/BuEGV8gOvXFV3eFSHifyHxY
         YSCh3tqiMc2d7u3fwtmT4lCpMfr/Z4LXYajotUGfwmHuLSg+FToZrnm+GF8FA5Brovym
         IHVxa2bKUmUBH4KPgArJt6s8N3VX6G7FfH9UbUffRaAUdOA4KhJt1Wh1AbxVrdggl06G
         nkog==
X-Gm-Message-State: AOJu0YygW9Jatw1UAYXwkd2tCjmKypbijaLXJpA6vuXKR3JxNnonDgWd
	W5oVkyvMTsi4xr5bPUHA0QSPRLNCxO9XrMLAjQU+wfGBjMr2jpit5F0mabpm9Jpm6ffetVXou89
	wgE/PAIECuEND9lKx7bRGp/KDVkGHKJj3xOmlal3Hhgh/uHuyYEvf
X-Gm-Gg: ASbGnctQWJSL09gLE4Dm3+iUlY54Ab2IRgMuWx2d9JAfUvZYAXJzHWDDsVg7ulqly+Z
	C7qXzxyUROEKvNyBzxHJFwPe4ro+JsrUZvp4tYRrn2jNkQygSh6UZuLOxixfm5PODBAk6MNch5V
	lPU3APhFXEuHW368+icp6dHE/ob6CyeMBEs3DNf4MkO+RcJd7h3WvfLE0nOWPxp5SsgwUDjzWo6
	WoefV23SvAWRDagrijNpg7afUqXYqhXixJvC+WHlyReLgV5rarLWFSxaDVBhSirGFGvf32J1t6q
	ritvFs13WpK01Om8iYu2QHPrXm42Z7YEBZvCdK2FDzLVNc/+KbDHiewjCKOS5D5dpJvj6zfFw7j
	qBPVG61D0KiE8jY9gbaXnlsfiUYgBfSfUU/jyPtU/PHSChOHrKU/mDpAzCRJc
X-Received: by 2002:a05:600c:4856:b0:46e:6a3f:6c6 with SMTP id 5b1f17b1804b1-475c3ea4513mr292375e9.6.1761058845729;
        Tue, 21 Oct 2025 08:00:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcCb5n53mP5PF5MfJ9HO5RP4uaN8pdS2o1XXt/OVHNFMEn6HOLQj1RdbKKLXflQ72jgla+hg==
X-Received: by 2002:a05:600c:4856:b0:46e:6a3f:6c6 with SMTP id 5b1f17b1804b1-475c3ea4513mr292005e9.6.1761058845283;
        Tue, 21 Oct 2025 08:00:45 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47152959b55sm204336915e9.6.2025.10.21.08.00.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:00:44 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
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
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 18/23] mm/vmscan: drop inclusion of balloon_compaction.h
Date: Tue, 21 Oct 2025 17:00:35 +0200
Message-ID: <20251021150040.498160-2-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021150040.498160-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021150040.498160-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9AHr7oTXM3_E9-Smg4qRm2dMcAliXBMTfWqplkC0cVM_1761058846
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: w5rroi7pd6r5byj1erq7ziuczpe7fdus
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 73F73A002C
X-HE-Tag: 1761058849-941573
X-HE-Meta: U2FsdGVkX19Ur6FCDDLTt8zJ5Jw+kA7yZUwnXopI4TwxL7Gjmovr+/boghvBKddtikVlgZeQWCihdOIZEaezIL3oSilPm7j4TDqrEu9iV9JWhaVaZOWQVB0a+fEUL4S7yEBksv8lQhlojusIlDz+dMU6l0frf12QWVRpJpvuo5Rvsju2wRS9n6REbSE4bITHwgBXg+m2qYQ9RvPxuO3Xz+aMM3aGF60xpF7VTflowe524bMFPykUWkyQN4C5fX3xSLVlM51Gd5bzX9O9Ev7amiFX0Ls2uW9udKPag7bPZC8UU97cI0BkeybofMjsIgik2dFMetuhXspu6hVaqXW50fk/w3KaAB/Gczm6u1ikwEPG1rx8cmKLWprxFR+fANS4JnISnh/4CN8KOk3pKKx7K8/AD4s5xBq5kzOuTwZ5xoMqmk9hv4x52F02XDtOdJ3voWRw8Bz4vcD5FnrXazbvzpuR+QUbnkf9jdMrPyilmyVTy2pvwUEVHLGXhwf864zJV1ZlvLU8I3LJtto0vGx/4qgkY7542f1n1ATjNbpJ6nhgCWDRbl2QYgtG5SAgZcWKSvwJR+ldDzZZpeASTQPxzqv75E+7MoUti1EH6Fv9nPCO+mp6+2sv4CP8HNeQXzwieRVLJBLgiAVY7kjaEz4a33SrXZmAEIM7Weed3730Iyda+cdmZqN2g+yFRLpWKtwh1z7phyyRV6Sk4NWGS9Ixz0YadJwl7mrsd4Q2xjDIDadpXhUL4TYqSI0HDdRWS8hKWjGNS5WOFT5lHcbpYuYQV8JQhFWkD9iYQWuym5IYIdnPmiA9cFns8zjEywCi+rT8Z9ymwaus8pIg9QGBtHUcFrsidmsYb+GzeUtWaLgl01m2kDcLd3r6B9s3er0W9I09//bEpGFwn2uaRx2dmtE1uxyOvdBPwEvGXIu7XLGcvcYIt9aMQd81aeOloAi01vG8V5pTfCuX/1uoCwGmERJ
 5UQ7FFud
 vdTGKx6ol0Qp/Lv374LN+pa4Ywr9MazaLZQuVzWsJWwc8Chnew/M6c83i7oAOI45Z1GhOrRMCY3JLDRslHSLUaLEOD6byib7UN1IBE2tMWym59tFTGIU5bf/jjGrNPxkYTu4NcnZ16MwliRSprE2kW/6gF9dXyzbM4K+9kXsoLBeKtbYoTY6xPnRvKnDVr5kzYNym3Ht0VSIp5zhqGtIkCLtCfCng/TCBTybe36UD0ncjJnlpDodhf3SrW4AO6HoUSbPi9vzWpyHfmBK3Y1f/fAgqDEyMYQztzc+Fl2Dz1NDaVt/O6L3byh5ocWWhFF9RHrXwXyIf3sJoXlIVJe20xtyO9cUsl9OqQZ1OMPN1FmxSpSF21P+IYx3YDR8GrBer5rJffX9RqHawBk72hqghNMquKwarFTNR8Cksa4Ff/zYH9XGJevU7JIdAQftozrWS21yqFx024PsNFo33fkAWoRCtxuRVM3owyKQ6mmLs+R6N4j3ilVdmPZLtVZFe5MXTtXvmv/Jbc+u+GJ6Axxwi7H8I7aBRB8e5Orl6sFqU+DSFggoK/w6O5gsez/ajZawIu25VHZ7RkoR9Et8H0MRGlRuWBTH9SNjcZDbDDEAsMDAlgrsufQqi93J16bcygijV8RF6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before commit b1123ea6d3b3 ("mm: balloon: use general non-lru movable page
feature"), the include was required because of isolated_balloon_page().

It's no longer required, so let's remove it.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/vmscan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c922bad2b8fd4..b96448b562823 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -63,7 +63,6 @@
 #include <asm/div64.h>
 
 #include <linux/swapops.h>
-#include <linux/balloon_compaction.h>
 #include <linux/sched/sysctl.h>
 
 #include "internal.h"
-- 
2.51.0


