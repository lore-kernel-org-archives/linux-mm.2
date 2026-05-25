Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13FDCD5BCF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 567C36B0095; Mon, 25 May 2026 04:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517F76B0096; Mon, 25 May 2026 04:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DE26B0098; Mon, 25 May 2026 04:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30BF36B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:45:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6E931401BE
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:45:51 +0000 (UTC)
X-FDA: 84805309302.06.95B4D07
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id CA4EB120010
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:45:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZgzCLVmo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779698749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xl5SeCFAdc6WoqyWBYEluyvHLd+oZ4wSvK+mq+H5Z7o=;
	b=485OdCue0LRZyPVm2w4oEL5g1AvAE8Wb/hSBFHYWsVVZTOqwcLF1sJDjMBofplSMd9UvWR
	7xLGb2tCykXts1QWbpwXDWCkUVh4M9SsMpYXrZ9fIAMJJsoao+Qz+p/jOmmqutLyvzoovF
	FABs1H8PEjvI7ugWud/etp2jotox9c4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZgzCLVmo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779698749; a=rsa-sha256;
	cv=none;
	b=CqGSGLhS5v4bbzgxwBPfynysZ45Qzsv/AC44Z4PfyOt8I6jcJnt9S1AY2iB4VhmcTUcRvI
	c4ti7uupAaZZtK/au8oeLaB93rMEOXf7R8Ilu9AXwHOB4p8+fApU1IAyUDI/s+hKDbWi+B
	KldQwyztQOIZOKNlUAhVGCpjvZVcYYY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779698749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xl5SeCFAdc6WoqyWBYEluyvHLd+oZ4wSvK+mq+H5Z7o=;
	b=ZgzCLVmooVjUF1B8cLcPquxKBrYMv1BU0UOcMCtx+qs0J1KBLj4fmv+64kTokqiUHCw7DW
	QLSkyvobmpNTmqJ89Am0fV0zXQyGShq86Bf/1bSXwo3uSMXW7R0b7ai5SP0nLxlsXrOXEg
	WLmKizzUHiW84XmPtxMbMR36THUTrWc=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-Rxx6HCzsMMKcZGLz3Gw1HQ-1; Mon, 25 May 2026 04:45:45 -0400
X-MC-Unique: Rxx6HCzsMMKcZGLz3Gw1HQ-1
X-Mimecast-MFC-AGG-ID: Rxx6HCzsMMKcZGLz3Gw1HQ_1779698744
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-393a6ee3c75so42409061fa.3
        for <linux-mm@kvack.org>; Mon, 25 May 2026 01:45:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779698744; x=1780303544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xl5SeCFAdc6WoqyWBYEluyvHLd+oZ4wSvK+mq+H5Z7o=;
        b=YGd9gdmoOlwOLApah8FtoC42VEknl8XfjxcYvqLe5Un/tzbYveVwY4R57Eh/UjefL6
         m+7UcroO65F8kgHf0xwb4r/etHs5jyzivipgpHRP+/cWwlIjqY82O0X+Y60U3ainbH0b
         f90X7zSrFF/oMY038RdIH05sTJxW5+aA38YluT9dHVh9hdDj6xJvUAdcWz4FpBYtyEem
         dqz1WEavTNEiP6A557HXCjd9GUSozd+v67KtiuyKeRXWMOwifsIlRXa31/dqOXaNwwD4
         nAzFB3nN6haFA/UK1HKr+Zsqf5jdJJMtGgCm0NArdXcDiza1ktjtPQoXXzPuZIQ5wYmf
         78+Q==
X-Gm-Message-State: AOJu0YzerKLYaJssJx5BdoSfzAgEogY4JQO6G8CEzIOd8Csg3fVdPZnC
	rnHuk2nW88YxbcksphHQNsKIqLDOPOKOUGQ7RfUcNu1iRmCB3yhgl8WKBbjfn7DTg40m4n/ZsPH
	I0Lh1Xaf3D6K9N9KO4aCFOZFuZuPfGwNaQ7B5ureCd2kaU6idtdKswRVX9MdWdXBmkwDFA4IEHU
	sljkoFlbL4qCWhKykZZt+upGStFPEYCcPjbo65Fg==
X-Gm-Gg: Acq92OEQqCf6qzGSDHnCRbdUDJa/6I8fbpJR3PLgjmM3rg6hJHDLu4sLG0U/RYCcjpK
	QHfXQRxtRA4C18KyhRBLYBjGCMQ+SyiAtmAmrHYf7lDqOyko84ad/i/0hGeoWWNSj1AXPUQK5Ek
	tjjxeO4jziLMj3p5NMaZ9yrqARjeFXXGu2igEl+e+M72QLGK6W221CIl2PN9EkFeAGmkMec/fgc
	qoBANCs4jbdiZq29/C8M9pdd8rNenKuk2CVaB1FASYHAekE6+cbsPWI6sW+wU/N2KTfzY5FY9lP
	59YE1/Ep0PYoSZ+YmR9nz6OYoHpaGj4K3FLxXwm7raR1og7PTSZEFW0ivQ3W2bCtVkx3zUJRi3b
	tozvwn3+MCkhkpxIGZZx7FU1o4JqnX8oq57dq
X-Received: by 2002:a2e:93c9:0:b0:38e:4810:4f36 with SMTP id 38308e7fff4ca-395d8c93098mr29703841fa.9.1779698744310;
        Mon, 25 May 2026 01:45:44 -0700 (PDT)
X-Received: by 2002:a2e:93c9:0:b0:38e:4810:4f36 with SMTP id 38308e7fff4ca-395d8c93098mr29703571fa.9.1779698743730;
        Mon, 25 May 2026 01:45:43 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dca7bcddsm21679061fa.16.2026.05.25.01.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 01:45:43 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v12 1/5] mm/Kconfig: changes for migrate on fault for device pages
Date: Mon, 25 May 2026 11:45:20 +0300
Message-ID: <20260525084524.139868-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260525084524.139868-1-mpenttil@redhat.com>
References: <20260525084524.139868-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KEnrlhY6nPSTl2TiG5PAQnlDOKSPpWYNx1xLmgxfK0s_1779698744
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CA4EB120010
X-Stat-Signature: 198key8q5kudb77g4uyh7nkcsp5ca9uz
X-Rspam-User: 
X-HE-Tag: 1779698749-742331
X-HE-Meta: U2FsdGVkX19kSNHj/uFvwAP/t2SDbnNG3OH9WKw+HdPhZB1+rfaI5A5kBstVIrG7lG9v3lEVLhJ7UpDRsapV18y3Ddl4HmP9Slfcza+puFcpo5URK6FlAwk8CrTelDYQwsiH1rh2P9ZTuvDn4suPBMFmKfR8KNgCxOAG1IKXlypg/LCpkBgLmiUSM4zXrKIOZLWkTwNvsqnE4ghB2OUEHzyt9hRr+URI34g3wJlVhcxrlmY2PqGw/TFKgbggatdSEzM4Qzw/af+FRCPZRhID8x2VUe1fMQdzGEfaCh5iOVpelclbaCMU4MdMssZzFQqpzV4MsNmnn0dZkDm/O1HnFShqLQR1tf4Sg5hSIagT6wDDoyVuUbeKZVux/X97bC4b7fXeyIx5h1c5r5l+7cUGocThrQn8FnTji0UV+lYxjBi3AJIibro57Ep5uQqDNkCxCVzPxOnYQ8WYIAgQNTCiYZDBIjhGYXgjeAlsoaHpjxk+cDFW3PRVa6YDrMv259ccS6/LEObB6KZ6HG5ES3wVbG+g8tk//OE0pb9BPb1+DJxuOve4aV45EG4JkpAQRp7I0/x3GYaWptd9GI7wgwjWsjT1xUt8GK+nTjxj+6CF3mXdSoM2Dxht066AKFg+4v9Oq51+n0O1qDkhzITuGb8IckERvFvaDFy2XvnMiILFv6qkwh7z37LT69XF7ffwjG6LtuohaUYrUEZJS7APKcFNqwkENHczKjJyVbE7xk+1eLsfGEpYG0EkUUviBWbLpnB95i5sK1mrDYp9CjHyNy0+tneHXca9lo8fPziXBcROukmlNkqRCPZAdeHMov8/6sR27X+F4Y1Yy/E1mrE2xQCSLTsyKOBZjkbwraDAZjE89oVe/yGUnTNUvDB6a2NBQpVoe0iWSsFk6cXC/t91zpR2MdWKRsFPzcQuEjPpbOt0D4NsLlidCzbMHAKGciHMUTuCKJEta69/I4AS5XVw3XW
 MguuDJRa
 6QUVmFK+AGT/dL5Y1HH0YoEu89fpIvqvwC7KfJGJEVqSg7C70+WvPRippICaFb9kjYJAK95G+fJ4IGF1+gDJ4PNK85vsqzp7YKroVAYV5AFKJKY2Qj6ZvqOQmRrBS0DCD6KKrsbUWp1kCx5xucoaCi2z+23rZpI90kMVLDIoXrH850i2bV6pHYL8eyzMseULitIIcN9I+9uJeVcPDZq0WKN6Rrl1WOpgjrOXN+q0L9thtqcjMcu48xN3WMyYY985rdJeeYrYW3Ax/hG6TMum00uf0KBp9iYwRS+Sm1oHBEzl84k7YnrklGrjbY5f2QlkoaIWXHs+IuXYmpyiGV1BOMUPE40g/4sGCRtsg+2t3aPttNDnncTQjSdY9TkWadm4DesBuAKpoT1VM/Fbo+LTyKXPO3eO63hswd1hzMHRz05Jen40LLpgvQXj+Qex+dpo9Hhj42ztUBAPx45eYukNuRaTWPU/KpAQqIL1dJWz9wuQdmrMoO5nFqkKPAuYeGunZnikhjt+48jpzywNqWzf2fROeKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

HMM depends on MMU notifiers. With the unified HMM/migrate_device
page table walk migrate_device needs HMM enabled.
Enable them explicitly to avoid breaking random configs.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index e8bf1e9e6ad9..0d8db75ffc23 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -646,6 +646,7 @@ config MIGRATION
 
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
+	select HMM_MIRROR
 
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
@@ -1221,6 +1222,7 @@ config ZONE_DEVICE
 config HMM_MIRROR
 	bool
 	depends on MMU
+	select MMU_NOTIFIER
 
 config GET_FREE_REGION
 	bool
-- 
2.50.0


