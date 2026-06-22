Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85570CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58BD76B0095; Mon, 22 Jun 2026 06:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563B96B0096; Mon, 22 Jun 2026 06:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4542D6B0098; Mon, 22 Jun 2026 06:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 14C756B0095
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:33:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6888CA0620
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:33:51 +0000 (UTC)
X-FDA: 84907187862.09.DFBC5A8
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id BD92A140007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:33:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uPaN+F6o;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3iw85agkKCOYbIZcVaIPcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3iw85agkKCOYbIZcVaIPcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782124429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+N+IZZBBGfHHVcpbuDlZE6lMJRHVBCZgw8qCBfTHFu4=;
	b=mMid44D03rUPY3qMuivpNiZ3kH4P2m6VeqdabmM7mFpHVR/qWQ3/BbSD8AV0BuFIauMrCS
	6lDEYH7OCGRKuLqNy6TvipRJUPWQ7ftOAaYalzHj2UeRHH/KJEfhfhSKdVCczC9Ogdrm+3
	V+LRGDzHWdl+s+wjMr9ZEmoa9NDcSzU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uPaN+F6o;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3iw85agkKCOYbIZcVaIPcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3iw85agkKCOYbIZcVaIPcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782124429;
	b=OMvELvbLc0XSPG+nvvPIV3KqklR9rZomZVhEOI7VDZi++qHZTlrITmnCTkvDsUDCVtRDrG
	cYaDyXUyp4RaPrSdGmTcfFkZ8pEaVHMiyZQWSn1gxGhWgqIDXyWmZ99LpkZk56rAWKfvP2
	flsoDhayqaI5hdaLzSfbKxHImB77JEk=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c0bcdf949d5so257036866b.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782124428; x=1782729228; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+N+IZZBBGfHHVcpbuDlZE6lMJRHVBCZgw8qCBfTHFu4=;
        b=uPaN+F6orfgAH9hOsnEc17a6roSSu/wm9zMa5M24Kf9TMTxj7FMJ4/ObPCCtrLKA2m
         HLY1A6NgF0p5ZwiUgU4aPdomQuL7OZuENlNuxY/crQMXWWRpQLfXrCLrcfh21LHH36nv
         g6mE88C0x32dtvB4bL1eTtYpJsIv12f5RBzjf2LCLv3uoMjUe6uXJIwaRMVvnOLIN4XT
         mspN4m/G7W4HPsb/oOVHwxLaebL6NVD0/84uX9A64dW2MJWEKad5Xl+yaLaYN7mnNS4L
         +JtOircULQeu8zCOKKoKJG6fmVR4se+6HCLV5NdYg1HQP+cGQa7zNEOD9loN/LiTRpi4
         OEqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782124428; x=1782729228;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+N+IZZBBGfHHVcpbuDlZE6lMJRHVBCZgw8qCBfTHFu4=;
        b=Tq8SKdpm/mBAUfEMPAWbjo5x9pqb4S07B1fqL3qrJ4AgF3hOi9m6gcv0mtq7UAHUil
         kqJkXF91ojxeEeZXWQoO5pXUupGI8WAzrzTYh8Os0ROPezH+UBCFkfSvE98pwqqiFsLU
         +i9h2TkpUzOyjvsmeue32XTkzBssHR139Ml43XMQZNuDChU4uTjnW90al6ok6eVtFS9c
         wv88sg9RzhFVfE2UkEPQANmzTOqCRC/1DKxkFrQHCeXtFI98Pc7rZlH5z2VZhAXnqQdm
         ertv6WbNZhuj544xbXInhlpsZMswpjZ9J2m+tOnXoPTsZoKx3rNU9aA4vCaJeVS642Ax
         ma8A==
X-Gm-Message-State: AOJu0YzgV1mlpU+ANJcVlfw5BNTEQKs8FeiNU4ksW34hvHWEB/o5Hdhp
	40j3tDVH2GKyuhX+kPZGYX71EffGXo/UOjIx17YjRgnm1PzA+QMRbOnLizjeZzmbuQXoGw1jkiZ
	0bEcM+JuR1FYepL5CPA==
X-Received: from edvd21.prod.google.com ([2002:aa7:ce15:0:b0:68b:3197:253e])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6c0f:b0:c0d:9172:c8bc with SMTP id a640c23a62f3a-c0d9172cdd5mr322007166b.42.1782124427905;
 Mon, 22 Jun 2026 03:33:47 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:33:43 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <cover.1781863524.git.tarunsahu@google.com>
Subject: [PATCH v3 0/2] luo: migrate serialized_data to KHOSER_PTR
From: Tarun Sahu <tarunsahu@google.com>
To: Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD92A140007
X-Stat-Signature: r33h7s888gzz1ud6b9538dp1fft1e44g
X-Rspam-User: 
X-HE-Tag: 1782124429-289823
X-HE-Meta: U2FsdGVkX1+5ZSCE1AoRGSKuzCpsx5l0BFg0Uza8azp9SMK778Sy4+ZWUqRVraNW1cDJiVqAYXWo2eboeZCXyVreDO/kzUd014TKmfyyXXbcHT2HbuKggLWjtColhpg1hiSnFC7w1Gp4cEjC3pA5kroIW28MLGxFDmBD1zsxu4Rtk/GC+tt3rd0HcVebEUxERYi9bv1NX/frNCwzniPdBsTUGok0rejmeD3ThfalCMrU1NEA6le8j/ND8mtgXuD9WhZ+O9iumuPBZH6E6ptCPCgSsTLG2EF8Uppi0CI/AgI6+514/TgJwoqgqgW1KIhYq0LnwWctZr24rowcN+hm2KvpeX8R8SG3aDsZUUiNCrxx5g102O0V4YNi6lsRDb+7EHaLC17MeVRuJYiecKXYOIoBHaJ77TNdyoj2kr1bIWD+KffF0vePT3DeiC00UbcX+wa8EAefUEdaX+bzkpPydBVB2qOI9SAlnKxG3eY/f0z8cIhNHoJf72i9pz7DKgVhbWNFkpKTl/pPlj6EtMJ9QvC2ul+ookfL2sEeWTJTNEh9uw0k5gEOnWui9qOtXdbIjXkaCyEBnGLt0JZa+HzPY/0/SoSYvFFBnXBX0TTEf8Pb8ErLD3bFuLMQrousicymuV7ifHeIGm5CVLK28pRt4A5OvkkKiyf3blNbFqGPmhwAaz7AmbzoNoYIZuDq/XbptQZQDiUGDefShG/K2zTF5I0umBXFLWqVtwV2VwXF/rtGlxegGntSMfKpqdsr+bzZIRkheU3U5Q8kYNbk2uBW1+aBDe0x8sLTOBRCl1ENkzqkxs2vCAdflA87RGIRP/Jzsm0H6QaBF3+qTejYooyTPjdkADe76H31t7bTB5TzgnZ6Vqb2eSSZJSWwoQopy5ncD2sCxAzH1EQTD64YfokKiLOzWHhzBFA5EXmdd6hWPshYK/Vt0MlzOznDD3Y1gmucc8cSmQikfAFo1yMkPlD
 z9ejl/PI
 zh8VmKZ49bvEylJc/i2+7knicZBHF4EH2vUty4ZlwJYvl0eJoVYhy4/pOgz21wcFOl+O/ZbJGMEaX8ShBjQFmBrnoX2V9OZLBrOTU8TN9wKMphOEuEjSRaeAZ62XjBHTTAxK2ZO9gMf6Fmzy6BZEwCyF+xzf8cMEAFM7vxZ7L3Rw9tFE3Zmgyp2LfNw4HNSDz2TXcWoXxOsmS6NLdcDf6EItmO3ELhBosMDKUV9+Nk8YmPF2+mw879EsRZd6MsD7iaK+FeIGvmV3DItKHOtzbS9u3MW3Vfu8TZjFwzimknjaIgAdgHc2FAca/RQjBIXM7DxJzPJxxjhUsG5owk2R2MUd2Mr2bjTk0HIaeshQ6xV7V7d61Olo5ntlaXivbqlq7ti24Oqj2uY5e+JYNI5bmK9JaFlCINwIqseqE6/lF20dj78jP3YDdcss2pemM7aAq6m+M2/Hn6zLzlz6gIuQm01I2569vo1/RZ1rsQvwfmC06RNCtTZa1YRQkZC6/VoyHUIedPShAVa53khrlJsPJWFXDXI+l0Cs6nPyDOBx5nuQL4WlPkmyTEEZ2ae2/ncpDKDAOIcNSp6X4oZ+Nz4vntKigTqyoo1q3DZzrilB+miHMicUhZ3C3tkf3wrljZHnS98TOYtjPR3kJDAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Covvert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
This series also takes care of resolving the bug with memfd preservation
of using phys_to_virt before checking the args->serialized_data value.

REBASED on top of liveupdate/next.

Tarun Sahu (2):
  kho: add KHOSER_COPY_TYPE(UN)SAFE for phys copy
  luo: Update serialized data to use KHOSER_PTR

 include/linux/kho/abi/kexec_handover.h | 12 ++++++++++++
 include/linux/kho/abi/luo.h            |  4 ++--
 include/linux/liveupdate.h             |  4 ++--
 kernel/liveupdate/luo_file.c           | 24 ++++++++++++------------
 mm/memfd_luo.c                         | 18 +++++++++---------
 5 files changed, 37 insertions(+), 25 deletions(-)


base-commit: e98a9c61721c14bcd29f11f4802e52e908701f7a
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog


