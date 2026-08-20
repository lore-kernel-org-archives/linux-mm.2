Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A54C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8C36B009B; Thu, 20 Aug 2026 15:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580826B009D; Thu, 20 Aug 2026 15:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 496616B009F; Thu, 20 Aug 2026 15:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25BE26B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:19:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A155CA0076
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:19:07 +0000 (UTC)
X-FDA: 85122610734.17.51ACB30
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0CED4C000A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:19:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q7pRMMpd;
	spf=pass (imf22.hostedemail.com: domain of 3KFOHaggKCEc1tqj5jsjpxxpun.lxvurw36-vvt4jlt.x0p@flex--skhawaja.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3KFOHaggKCEc1tqj5jsjpxxpun.lxvurw36-vvt4jlt.x0p@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787253546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JltQ6Mhzamu5iKOEvRgy+JKSzJMl+WcJVP1h+ocPhQo=;
	b=w1k11L6qSCrAgnowaVTg8kOkC334wtDTDnqu17PbdObNI/TQM/PNnK6VsXqxIyL6l1K6pt
	pOq9lbV9r2nFLrfqjVY81dZ+on2pPQ/R6KOpmVu68G14TfEh6RS+Sp2JZH3WZX0zcAKT5s
	s3tgZ5P+vY5IkwHXXg/f7fkhu5cJehg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787253546;
	b=y6UmzS7c8LvzfH0HM3PeVX/MctPXYvEaxE5Z5EsHT96gnOcMGjopWoq+linFXJUnPxeuBk
	1NviE1PIKnhYRDdEIZn9qOZ793Ekdo9/l5CAGeDvlfMPbwLN+o6b8ULEy+n5H/toocyaTB
	rDvZsZBBhLBIgoZhP2f3mU6Ln1sRejM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q7pRMMpd;
	spf=pass (imf22.hostedemail.com: domain of 3KFOHaggKCEc1tqj5jsjpxxpun.lxvurw36-vvt4jlt.x0p@flex--skhawaja.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3KFOHaggKCEc1tqj5jsjpxxpun.lxvurw36-vvt4jlt.x0p@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d5d00fd19bso3962265ad.1
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787253545; x=1787858345; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JltQ6Mhzamu5iKOEvRgy+JKSzJMl+WcJVP1h+ocPhQo=;
        b=Q7pRMMpdMiy83/hA3wQJaozW8eyQrQSpQpQ+aF5WpbCtshKrFBAtb9WdnzTcsVfMBx
         4ejHP+WFAKkAusycZm6RwM5dCMrGQeFY1vn5ZKyOQtmRVYQVLufGWiSTZ+XeqnfmGIsG
         9iGAH/TyF63lkpoXtz+4vwOEDdUiO3ZP8wDXIJPT31eAIp4zgt6Pz6p78dgC/9K+0EZk
         FebBTa2iLSm3vrMxfejHiL2PZsA4zioX0m82rF5pDKQhk/RuJQ2qsw9ihO8zEWSY1H33
         ImyO14r7bGYv4ZFVQfRgrS21yldQijiEOLtEQBtYXcvMfxgY7QQbxB0JNXb/VS8JGq8S
         wtwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787253545; x=1787858345;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JltQ6Mhzamu5iKOEvRgy+JKSzJMl+WcJVP1h+ocPhQo=;
        b=GNur2+Ub+rKDqE3R0aPtv3c2lO/aTRo9jQuR24ccoSmFmBjhcvJCCGfKkXBaX7Z90X
         zkIea4wyCInpO3/H7J1PQRjYY4rkIXRiN91rjFVNROj5HbaFanBCBQUjNgeTlwr3YdyN
         ISVV0n5Pp5ZNyD+pIBuhuzSKMpi1NN1IeML5xrWPYvFBnkXd/+bJwA+EapoMbchRmqoP
         4/qpEYv0PX2qTtu89QSh/qzOPh+SJOJD3RlnDSUvAGbmABS3oSa8VEuac7nSglz3EpKl
         xvinGvHBBR5HXsuF7yhB4hwvjJUOihYqmvzoJ1id/n8lHT4tLnEN4maKgWJN39vf7L7j
         Tugw==
X-Forwarded-Encrypted: i=1; AHgh+RrWMApE+dHhFlDTlv4pOFm/G0lpqHTWNUhP9RRSEGoKnd4if+8l6d5+hEp8jb97rJ72+rdNVKdTUg==@kvack.org
X-Gm-Message-State: AFuF++nIGbB7Rs9IKcfgqZeCEbfQu8Lu2FczTtBQO/vjy05rcJdR+BQk
	+6pqbBWYF1fAwTHnFsajXe9tHV2gDUsoeTik+x49gf725ihvxLqfXbWyHEsnB5RB0qRnc5trXS+
	xAahTw7jEWwGwkQ==
X-Received: from plox6.prod.google.com ([2002:a17:902:8ec6:b0:2ce:d12d:d6f5])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:32cc:b0:2cc:f5b8:4c2e with SMTP id d9443c01a7336-2d64b0cd474mr16550235ad.9.1787253544418;
 Thu, 20 Aug 2026 12:19:04 -0700 (PDT)
Date: Thu, 20 Aug 2026 19:18:53 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260820191854.1642931-1-skhawaja@google.com>
Subject: [PATCH v3 0/1] liveupdate: Add internal APIs for file preservation
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 1fbi3qs6zf3hdgu15ciun6dt7scjmd1t
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0CED4C000A
X-HE-Tag: 1787253545-290383
X-HE-Meta: U2FsdGVkX1+CpBGMA6YntPUE4KjBHtVjcvuuOQTmNaUBEF0gU5LuXu3lwz3gVCQtXSf43h6bq4ivG4sC1ERUqY1gKzv6M2OUAS880+mZKYrN8gi2+Zw5eL3pwVVbzXKlifJD6i0yuiTPKtH+40D82ud3NDVPuucyTghPUQqMNacVQXPagCHTfJ6fqi4wQdzPbKCTc8In6ooZ75ulOCIdh8l5Zl/JKKXECN88oblCi+GSynqhOBZq+iYje6ldN1dH8UYSR8AeaHJizPQyUCpTt2M9+OjwbMmf6uO2vQVt/3oVKU5EIBYOIWu3U+qjriHU9fkk0TXLL7+atTkoewiaNZVC//nZ1xJS3JswX1Le1NvkC4bTumt8haKcrBjzpy8oo6cqOYVxaGr2ER2UwKjd0AyE3RjAGNUb9PL5Nl6GGxy9vYVfUzC8ZKxK7+pQro0O/4DsjqF6fWftO7fbMM/KC2sjr0IQGZ+e+709v3ZrW48y889+nfuJk7rwNrokfaPKR59U1nlGqErXZPeZFBvhgDONTf0vU/TDc4THhj1qdJig0qeWdGymE+/iRPadq2rP1Nbf685ObwjeXbzdpYIWl797+WPuaMS86qgpm6Vac+m/YXlTd60MpQDYcqMa34KemgVAVTMAhvWqx/5Eqzq+ZllotYdI64Igr9CXSeocV/ZHmtQkEyGhY4vr+Spm1bbiRu4zFPNneXQeK6oHN1TV9CyKlwJc+Xuh7lD92gR73XbMIHkJcuUTa/GgmrD3lPyV56HxK349lf62UedwM1OL7qjcnvTOy1wyYZo1B0YiVFCuYAMowTk2GU6KGFwQLYSuCY5lJVtD3Iv5NwS9L7xQjwlfoIYpy5Qzfb7WWcVIo4n+6BvT+o7OHufKn8CpWhj9ckrL/I/yF5qe8ZZ/hluSQaD1QS84PP21q/D8JROOhZbpQpra2iEVKE132b4qabQ5t0uOwicKuxyjP6iMhla
 rP4HGbeS
 +NupR24V8lOQ1D0QsP3avXdTw+wj7OZ5obJpTxCdc1TulnrSFBio6IJjF16H6iBC0aO9DGH60GRAdrq7rO7+fxMZPXg+ExKfbAfQEP+D1K/3WRvmgoY4elmD7MOMNdYewdM5hzOt6J7EXMOcARE6XZii4pw/8tOmoCKkSwZOn2847mGJvc+CgaAWFSrudnstJZ5j1jBCLG7AhXPOw71VvgdbYzY4JUzLuxf5VzOwG2Crz9sFdh1/YrSNfTNKlBjemAUNAslXB/9Lp//t6mhLMSC70Di+gJCJu3p73zsfZP6gBcUsg/B1AJT71yaTK1/3RJ9OxTY0QLx66X/wEA96dzwz4tLomIXu3f/tTd6NMhuoiRd6eeCRRTZSVdqNEAuDfVrJ4I+dNCEgVk3WLmWRZrL+i4Pm2Mqv+1W2UZSyoxTz9z09D1kfBaTAom3ZwY+UN5sLQF968+bg/nWoT80IUreAHnS+kczweR8U5yiUI7L8MCxqrvcNtZZSAzcTAY7au74jJn4G/u4OyXvHQvP0yjmmnOLhiMDO9DQYSmixZlR8G/x0YbUjLgtexDTJNAqPOobtjoa/gPeNyshowloAPiIoSdYk8I0GPg3s+iR9L9zFuWog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Note: Sending v3 of this as it was requested to document some of the
discussion we had on the email.

Live update orchestrator file handlers depend on the preservation of
other files. To make sure that the dependency is preserved, the file
handlers needs to fetch the preservation token of the preserved
dependency. Similarly during restore, a file handler wants to fetch the
restored file of the dependency.

There are two known usecases of this,

- VFIO-Cdev preservation requires the preservation of iommufd. This is
  required by the IOMMU preservation series:
  https://lore.kernel.org/all/20260427175633.1978233-1-skhawaja@google.com/
- guest_memfd preservation requires the preservation of kvmfd. This is
  required by the guest_memfd preservation series:
  https://lore.kernel.org/all/20ae20f9d1a198b289444ebb4c824314cbba1bcf.1780676742.git.tarunsahu@google.com/

This patch was being sent as part of the IOMMU preservation series, but
now it is being sent separately.

v3:
- Add File Handler dependency documentation.

v2:
- rebased on liveupdate/next to resolve conflicts
- Added a note about resolution of dependencies based on offline
  discussion with Pasha and David.

Pasha Tatashin (1):
  liveupdate: luo_file: Add internal APIs for file preservation

 include/linux/liveupdate.h       | 22 +++++++++
 kernel/liveupdate/luo_file.c     | 84 ++++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h | 17 +++++++
 3 files changed, 123 insertions(+)


base-commit: 3a0b8fa2eb36afc88b62a95f33f0c77c71fa5ded
-- 
2.55.0.766.g2966f0265a-goog


