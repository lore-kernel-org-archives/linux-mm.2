Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE22C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC6F6B00CE; Wed, 12 Aug 2026 06:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAD366B00CF; Wed, 12 Aug 2026 06:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B8A6B00D0; Wed, 12 Aug 2026 06:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 788DD6B00CE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:40:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F97E1C0D3F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:40:08 +0000 (UTC)
X-FDA: 85092272496.07.57107A0
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 61494120003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:40:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SZ1sxRZS;
	spf=pass (imf29.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786531206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CySejvRkZl+O/T2betXJvXb5NuBv/ihH/Yp2vgUVu+0=;
	b=v6gPT98svzaZ2/ClAMf1EgQ5ZWF3R/l2N301owFyJ59az/156Nf4I2/HyPR85TWdXS5X3r
	aui1g6olIyXqAy6zpdJIxqQQ1rLokRtSIq3cPtfvfugs4xsLj+npfcyzA4zqIg4Y1buAcv
	PAfyY+/jcroj4ccaCHqIrxM1lzZvvos=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SZ1sxRZS;
	spf=pass (imf29.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786531206;
	b=ZtqvIpI/AFzcdhuA9Sr7U1alOAZ83Iumhd5uQPKpbwtn3dP3xjW1BN+to5uz3SDgtKX/Eu
	0/FBKOXS5LXHaThz1xd7q07yqwd/3lc7ryEQM/2Ry68KXi5yY3cfgpBls3+e8kK3/UCjt0
	+b2oS+Ac+UCPIpMWhZCYfG3S38RIago=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so1017649a91.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786531205; x=1787136005; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CySejvRkZl+O/T2betXJvXb5NuBv/ihH/Yp2vgUVu+0=;
        b=SZ1sxRZSyRF13exKoBG11Q68YOpy+6fVf2SNC8jVFN+nDGmASqkOoNde5y6sn0uOyP
         8cARbDPbtCb2BjFdOfWEbo/Rhrmg8Z/vXsVMyTTWjPADx8vOZ4QVeYPs0ZJ73moGsgGq
         thB0csTNf2gY2ywTkmyjeSpiwVuWZNAF6nNenIr+oLCLAAmANxCDbXuBG3WA5ZFx09mR
         AfHFzYHSsLx51S9pOMfJ03VpQEsqs0O/t34O/zFPG+PpQpycsAQqznvKSx+97S8Qtjzt
         Sd5d/w84X2jpubk9H0l9jfOKv4XALe8t+mwQTbbDnKMGRm55+XRSz5fL0VPrHDVNhA2O
         cIJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786531205; x=1787136005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CySejvRkZl+O/T2betXJvXb5NuBv/ihH/Yp2vgUVu+0=;
        b=Tj7qcPCqs/GmYXvUqUqfXKSgdQbOeUBqNGgL/qMutolnOvrAwnTV+1xhy87ZpB1ZFG
         KoPYbX+5rII/xwKzY2OxK4I+zgXRa7twpdpp9izMCF+eQXQBFkwR8EG3L6L5pwVJS5rJ
         5XOnueKOBeJydLhDbDtfo+0Z2MMb352E3H2oK3GgYidzGeFdFuLzlSxZzXx3ybqi8/PP
         qRoAf+iPN5ObXkDjT6UC5Uk+OL6t03HJ6XkuAvupjv6GZBFHEd67Piiu0J7f815vVtw9
         GEm4WrRMsGeIKNS0chQby8cVKNRvdfBjzUHPXU+CGq1Ka5i79vQN8qGmYWNEtaDLtxzY
         yGKg==
X-Forwarded-Encrypted: i=1; AHgh+Rq0BkneaVbuMpM7b+uC/Lv+hZ7epeNu4h+McLnryev2gcA2bhJQgclXUbfXuv4iH9+ZPu/yzBToMg==@kvack.org
X-Gm-Message-State: AOJu0Yz5KvyLSH50CRNdUAlcLpyocAlY+egStCXMyteJ89wQaHLLJAiL
	fCeQoLg+hkcFF2X2zMmd6HdcY9pivfgsQlzG2nxkCioDhGqyRWOVNV9y
X-Gm-Gg: AR+sD113NJik+tTyR+y7ZI9FX9ojsOMoHaNkbSc55eBIFGpZMBwTkDkIQaz9FBTKTtn
	Zq4ZkeXM9FaT3iOro6KMsn9RHGmDAMjPeVHlD8wuvB9Q1R88oNTUohPKyxanYnEEGqlNknojBy4
	E3xVq3cqlau1RW3l6lBPHX2/kCW2ZFob1lPGLMsZV9U5rTpU5nsenCybfklxVE30d5FUrUSTfHw
	JjGwtmNLXuVETDF6udtuPPPKA87GIA76UDo3zqsdt6s9r/Pr+9GzKs9IDdMQfmA093eJa/r9EUE
	jjW1m6zu3Zsj2zQw8MBvAWjjVVKU8NisPYwBLI+A4Vqvbu33X4glibr2XV6ulnpZQXDyVx71kG4
	hcMEjDsqM9+ngb70DqrhWe0vLe9zMMOZcSfQESXFvEjWTRgzhDXSBEEzkhRSXWzYKo+pP5oG01/
	WG6vezeZGg8rQkwxm/cDLCPXMueB2ynr9kvB9FEOIocg3XX+B2jF8KGP57nSyU2zRRR0W13BMuu
	YCjeXv0tKi8snI=
X-Received: by 2002:a17:90b:398c:b0:385:393e:7124 with SMTP id 98e67ed59e1d1-39301433f18mr3789699a91.14.1786531205162;
        Wed, 12 Aug 2026 03:40:05 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:85a:5c46:85a5:ec7:8aa8:72be])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31cf3d0b432sm9931990eec.8.2026.08.12.03.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 03:40:04 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v2 1/3] docs/mm/damon/design: accurate semantics of nr_snapshots
Date: Wed, 12 Aug 2026 18:40:00 +0800
Message-ID: <20260812104002.15225-2-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812104002.15225-1-aethernet65535@gmail.com>
References: <20260812104002.15225-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 61494120003
X-Stat-Signature: zs658d6f45jprz8ts4kobhg3d66xibkd
X-Rspam-User: 
X-HE-Tag: 1786531206-822571
X-HE-Meta: U2FsdGVkX19QkEOh9OTnnBZ9rQtJ/X0w5IrEJTKUF7FLmN7ebuNhzxzJnazXxw+GmTTV0JVzrNOFLQ19qpcXJ51Hj4Ds2XFXGN4RU6y3k+eD0Zx+cyGhMWn+b1t0sxCdR0R59ZP9BTqLl2/K3kCW0SmQX7vIy6i2wvOYoBpv8O+NGY4et3j5daoqR4jOctGb1pDaBbaffuXXm6CoEteOQe13Cbiw70YuVQG0oAzl7qL12sYioqJq/uBwtz5ORY2szk0Zf0q+x9OtdRsONqKt0nBgEy5A42RnKo2Rq9t8/t0tJvgTfpAbuVh33yT8RCx9B2LmIO1Pmf41zg+D/ylkFKSbppDJvvhdAy61Q08Zu947hRXhfrxnaMjqLy2xDgNzbVJiojK1FnO/xo3soH05jHrboGxZQBsm6KPmCVi3vxb9Z0sRiESfB1BGe8M7hwQ8aSi3JRdwRMPuv211HHJ0KELVA2Mc5LoFZ5os59JXu2cGGX2LVID/RxTYFImvy/bfRZ9V8Sib1eawPLIWMegHuWBTG+FIsm9f/f/5D7K0/bjI/bFmhGl4J/CYy+K5Hm6tqjJL5g3hGfAb2q2WGwQ3kaoCWU0lDfdCGYAit6twf5/UWpUpo6EhOnxe5NqxFWhjB3uZZBVRtefkrzj8DcCBDg/8OZ6yZRLiuxjHtL//6t/kLkOae2k2JXp/mVRAm04rX5Bn55tP2bhbsz+F8nuu5DdanwtAMOsEGj1XsQUONjEdKgmqfG5NnfbexN3jUjVtue9cF5z8yoni+TY2etvhXGjA/wPf9O+vj2memRm4RCRGmX3krpcGTNmaVd4fPpAQnI09jEHUhdnDDMHaXUxJjwna+orN6AQr6/aD5yJnmv79CMNRYeE1hAzHDDwbkQXVS3B25YIhOGDGy2Z28DAEd4B2K1Z0xecIZ3Yb5MQD8sEhjkbgL9Xtva2dhduRfTIHa447iL/rh6axqwrGtr0
 hj4VDOvF
 0vME3/WfsKcha7HjVJz+NYhYwG0gDgDa0yGnk8T29MqHk0aBanhLRIub8C51zWRAj7lVTZZ81taAXhA8qTxaNc3V8/wesd8ndvxWWE5bBNEYjFhq6iTMK/9amPUzw468cFNqbXqLREJykmw1JAzZHGFxKZoUoTKlPu8nhuw5tyAaQ7/OkDwzOQdXfBvy/ewtIxYcHOmdA3b4TLsjcQFY5mW0kzRhA9OnuyLw712n7NZzVyzagSObHAMXFTHPTandJyPWU48LS0crfCnuwZZfWKch8rB79S4NOxlLLMv+HQx3xPDnJV7wYCj+p7uSx9MkBtqfR7YIKnSiLBR4Oo9bewrj07QyyaDyjg4BoCdgxeykTU56SGVlPmKBapOgQX29aNPlgqsN2IFE+V0Apnv7P7ghBrwuLiRIzMdKcq4Hu0ASuB9+YVveBUeMok+2tW/6wOfl1izq6y6WkpjPHoJmTiwJUqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change "tried to be applied" -> "completely tried to be applied" to
maintain consistency between the documentation and the code.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 Documentation/mm/damon/design.rst | 4 ++--
 include/linux/damon.h             | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index aed6cb1cf483..1739aeec6eb9 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -846,8 +846,8 @@ scheme's execution.
 - ``nr_applied``: Total number of regions that the scheme is applied.
 - ``sz_applied``: Total size of regions that the scheme is applied.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
-- ``nr_snapshots``: Total number of DAMON snapshots that the scheme is tried to
-  be applied.
+- ``nr_snapshots``: Total number of DAMON snapshots that the scheme is
+  completely tried to be applied.
 - ``max_nr_snapshots``: Upper limit of ``nr_snapshots``.
 
 "A scheme is tried to be applied to a region" means DAMOS core logic determined
diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0c8b7ddef9ab..33914594fb48 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -357,7 +357,8 @@ struct damos_watermarks {
  *		Total bytes that passed ops layer-handled DAMOS filters.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  * @nr_snapshots:
- *		Total number of DAMON snapshots that the scheme has tried.
+ *		Total number of DAMON snapshots that the scheme is completely
+ *		tried to be applied.
  *
  * "Tried an action to a region" in this context means the DAMOS core logic
  * determined the region as eligible to apply the action.  The access pattern
-- 
2.55.0


