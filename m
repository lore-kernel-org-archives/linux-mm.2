Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 978A6CA0FF0
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 23:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75C158E010D; Tue, 26 Aug 2025 19:16:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70AAF8E0105; Tue, 26 Aug 2025 19:16:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3BE8E010D; Tue, 26 Aug 2025 19:16:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4708C8E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:16:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 931C61A0375
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:16:42 +0000 (UTC)
X-FDA: 83820470244.05.6C5E377
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id A1940180011
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:16:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RHHAs0SD;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf06.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756250200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qetrqf3MczqPduYKizayxhW6O6ZOA8BdxBOfHLUC1/Q=;
	b=FA0gD6nYfTN9Dvx1yq2DttcQHFQ1kEiqqjSeM3smwaLcBj6L1If0lSkFhVkkpyAKw5EtXZ
	0EVz0Rvx9ksK6vDF2Sska/m3sn/nrBodiJMyRM/5hGb05evdjTdNmUqaRAUrejlWgjlOMQ
	/giyAWlT5CxRHEWwJZINFUItE24CgiY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RHHAs0SD;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf06.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756250200; a=rsa-sha256;
	cv=none;
	b=4tIlRBFFGBretAkPdJqDeUsJU7kXo01eBTOa8pHX0cSEMyykbh72mAJ5Nr1osQvFFfFDNg
	41i4Ru+EdSMhwQ5/+QbFaqBSe6LN36SaqT6eHBtSK8uZHSJYCyC1WKm3ua6yq+zaGChVAH
	ZuaiA+hivpdNIZNV+aYB/VHAcFCe7x4=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb73394b4so882998966b.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756250199; x=1756854999; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qetrqf3MczqPduYKizayxhW6O6ZOA8BdxBOfHLUC1/Q=;
        b=RHHAs0SD7yJOgsiPlX9x8IHGXoDO71rXML6hdSkHg00cIDQFu+Z9lExYwT+qvqovPL
         FB4kDXxP0ZVdcEhsACA4z3n2pyVE9JPW/dWCTLBmWdt8MfVr2LERD4IPV9qwy4n7R6Rw
         jYnfTe67lrfjZ2Jd3apXcfP7DNp6kuGHkz8dFUFy1jdB0PXsfGKnRXtwgaiBzxOiijv1
         iF9q6BZaOaQWvm1TxQ+H2wqC6b74VEzeAxaQv/Fql0gmgQLdtGGVWMvlxqDo/hk1L1D0
         Lgb+bXslgz9J3kadIVx3dhX2k+afNAEARI0IIUur89oBQqJRoqDldLF+oFJRREsPAW/W
         ha8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756250199; x=1756854999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qetrqf3MczqPduYKizayxhW6O6ZOA8BdxBOfHLUC1/Q=;
        b=vc3BGWNSHvclWDxY31X2dl0MYWWM5szLiH4Gjp0amIucTRk7NoDtM6dEY7uLoZmv4p
         avBvfQ/3gfRSIQYEPnH95dzvW15+CKBDfl5i9X3axbIbY4LgPEYzvLMKB9VexhfqpXIG
         j8VuUSeuK2xu7uB5yVUVNIu5qo5bOc8qzV7zQKSNb9sFF6OkrNdn0wNL4xzeRtTQvO+g
         +tffJdrArWmVgFy4snMxNVkK5LYtLaZGGLJbYJMyO6wAHWvAD45jJ0CksqcV8KP4ee7P
         1PHmEZpY1O7XpSe3wbSg+kMGAJZpeyCD8Ep3/JRhoqwx/wLYAVMj+B1baFER7/7xIUPs
         xYRA==
X-Forwarded-Encrypted: i=1; AJvYcCVwiHadPTJdH2KGHIo2Vdma3YHhH6MzA3qbxDXQhC8KSEQCHC65HkJhHW+4Wyo1aPSDmEqwWR0RFA==@kvack.org
X-Gm-Message-State: AOJu0Yx2lRczK0NfjT9fdcKnW48o+L7pXOfifncQmQeEKzmPEcYmJ6dY
	Gr05v6BduwRUzvEARSZCo/2IPC7j+ovvY7+Qv+LbymRrnzuyDNAg/w9dhm5d9PMO8X4=
X-Gm-Gg: ASbGncuvTwBcoKbMp/QwH21wTCrpQED9hDfunVWWmS9t92fK8KIaQ0eKceFsnQSdar/
	6+zGiEQy8Q5PgWu6bIiQ06bpS4HlcNDKofv6iAsLIO9DMRVQvuw6DI78ypMEihBxvRWQE1xXHNa
	b3WJ84fOaeqNkng0edeoewQAYq4p1ZYjKmOpztCk9MJxZhuRbjuYxWuWObu1arCkaK5pRt/Si9Q
	snpdSEFRRsFUpnu/5/SH6Nrjnds7flbCDa2oPqMNbuGpvf72DN99/wB0ZurCkJQ7JhJp6Ym9VSp
	3jpP+TM+FuY1zMRQv4cPJYXarHz7/JOJYxco1olPCnQkuBqUGSY1W9B4vJGChe5PrmM8I3VLXPJ
	gGVXTeUSXhhf4iv6tYbYacG826+GVpF+a2E6vc5RtorYm6yp/4pZY5jp7yzsdc6EhtEjPjUCbNF
	glIdk8qYFyZMwSS1TQpm+XsgR7LmOfFFt7
X-Google-Smtp-Source: AGHT+IE74yfqVMKiPyh0C08W2ABt3qXIpU354P0qAPryu5ETmoDrG7LlzRcdx7ZJnXUVlOl7635fBw==
X-Received: by 2002:a17:907:7e9c:b0:af9:8c1f:b290 with SMTP id a640c23a62f3a-afe28f6a866mr1381335366b.29.1756250199096;
        Tue, 26 Aug 2025 16:16:39 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afec3251fdesm23170666b.77.2025.08.26.16.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 16:16:38 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	chrisl@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 2/2] mm/swap: add BUG_ON(folio==NULL) to folios_put_refs()
Date: Wed, 27 Aug 2025 01:16:25 +0200
Message-ID: <20250826231626.218675-2-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250826231626.218675-1-max.kellermann@ionos.com>
References: <20250826231626.218675-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A1940180011
X-Stat-Signature: 19dg53mto77d3swwo5k1xnsfk4ht4egr
X-Rspam-User: 
X-HE-Tag: 1756250200-581870
X-HE-Meta: U2FsdGVkX1/3rVvbY6kCbtoe9enEKPtlqG0ktnvSDwN6j0b2DyHuz30YMTFqdM1ClhSXdxuDV6UC5FWzsGTJmrf2oWF9TZIn6Lmu1uL6JqkmpYVAsb+NGHYNwTvPMzEaSPNFKHD0PAqlz968l4WSGTSCoVZMPgXteL765pjwUwC+AuvYEdajVhouoU0ppyRjre9njmKF53W6d73xMKLz4LkfEPV5h7NE2eVsV15Ou8DVJ/2KGb96AMqct8ZwZkVTYlYA6fwm2yn9QC9ZCijL//JOLC9LuO7l5ydSe+kbEWMjw6zU7Y8xyfs8GjMZzuuu5rDFW5Pmy5ies0DAUTO+Np35MR5Z0q4NbtAsBZT5GskCOFUFawjkcMYZDKdRjF9u7tNA4oQksHfdaa5dSQSiquBAr4aex6mM44rmBbTwcRHJ/qPf/FrZhaG34fTJNFbGV2/7+49NxvNGR+ubAA3njaZWSxQfU1rrnoolj690uKPgYxCy8H6RLhu9otnlTCaqzkqTw8bKiKAawDDbjZYCkeE4kM3fTAFhrP76VtYraEmIQ2tp2t3InzmiESJCuZclIWBsb0yUxqhNnSUmkAPV8zwBbKa5YB5H+c4cy6MTdxeH9gqRCi2SaCb38ueXxY5n7mIkzFNdpy0wkAaBP7p05QBv4d3p4O9ueYGeONFSjcdQRUgsCtpsY4lW2/q8kE2o0fmR86GXTjlb4j6nw9zKdu2QvBkGwS+v0I0kAGUKVXE5TAHhiRP/1h5fa9P1aZIAVkgkSmaEY5j+AkR9+WSuaIxeXo5y5WKUdz3a/C9uvfP5z7IUpEyqW0t8C4Rq4SLvzcime5YYPyE4VuLt5O42CwjTmCd6PcjcqEPYuVDk9z/X1KgmFG57SjY7JLiB7bAEehBfHYgf+PgeIhUDyiHuCsQpUzpR8Y9Lr4svZe9pS3rj/GNb+TcONSGUK7hPd/w98Cb9VJEld6Nym60uD23
 yafCW3Rq
 MGfBN45e+iyyKP7Dxb3lZ1M9qqJnqQxcEgyyZ+z7TvC+UYdBmcWk5GoywEiB4yhPF2zpa4WNRUuvZbRYrao5/ikZ2h5KfA9goieswJGKpTWji+YTtmpqCzRHu4SNibIDFHIY98DTCASUZoL/hTHbOt8cfUYw4LFjQo5eIgSW8YSKBL4DK1dFFQS/QYdKmMkBntB5YU5jlkHv8Iwq/fQqt1WyQzrFbiRlcBVwOsZNmkuKKxSPx+NlQTJ6a+QhgMSE8wadiMpoygDpObuqixuUDy6mj0mNfSn+IrXztrwR7pLbnzt1x//yc816PkZiH2BdyUQ0RlkUlSUsrGzKcp9t3EAKmVgTuu9ML+QXRYEon+Pvdd2TFRY2fVCAhrZep6rtCBwhuSTrVpD3LlIHcqUhSzsJO0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is not legal to have NULL pointers in a folio_batch.

However, the Ceph code does exactly this, and a refactoring patch gone
wrong has exposed this to folios_put_refs(), see
https://lore.kernel.org/ceph-devel/aK4v548CId5GIKG1@swift.blarg.de/

I believe this should Oops instead of crashing due to NULL pointer
reference (guarded by is_huge_zero_folio(), which may silently hide
the bug).

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 mm/swap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/swap.c b/mm/swap.c
index 3632dd061beb..07ccda00e7ee 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -952,6 +952,7 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 	for (i = 0, j = 0; i < folios->nr; i++) {
 		struct folio *folio = folios->folios[i];
 		unsigned int nr_refs = refs ? refs[i] : 1;
+		BUG_ON(folio == NULL);
 
 		if (is_huge_zero_folio(folio))
 			continue;
-- 
2.47.2


