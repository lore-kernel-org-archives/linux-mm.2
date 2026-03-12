Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52101106ACD2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 18:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5466B0005; Thu, 12 Mar 2026 14:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2DF6B0088; Thu, 12 Mar 2026 14:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008386B008C; Thu, 12 Mar 2026 14:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E00486B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:19:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 335721A03DE
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:19:53 +0000 (UTC)
X-FDA: 84538224666.10.59B1FF3
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5C5781C0010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:19:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZAHQki56;
	spf=pass (imf20.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773339591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BJeTY5HtximJl4H/EK6OxpSJa7GUKH2OzkM4yI7+cig=;
	b=bJQHoTiJrUn383SMHG280bBRdXwwiCw79LTOLOYTnNWG0sfEBkmmLbW1/j+fR6/XgLiTTy
	jlX/3ikx/FOz0c4/4wgGLJegB7QU1LXcD0B+hJEiwpBh/c9xnH1WW12ZntJbIOAnNv21Vt
	KvG4cGijTdEEo28TKAoguYqp1mKceWI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZAHQki56;
	spf=pass (imf20.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773339591; a=rsa-sha256;
	cv=none;
	b=zBCbh4pCnezlfY0bSUPTSoXfOsXbuKaIucgCQ+a/pClPBOB7KIgvAltGno6eSwCQOi3DgM
	XP4SeY/Po+rWlt1GozTpS70IyDcPgFbhGr/oPfdhC7onnPML1Uv/2fCwp/XSf9KTbZa5Xm
	C0IEeOyPVDElQgNX5p0qALAfzp/oivk=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5a1362c9a3cso1425899e87.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773339589; x=1773944389; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BJeTY5HtximJl4H/EK6OxpSJa7GUKH2OzkM4yI7+cig=;
        b=ZAHQki56GAGzMzc8RhnmYCNSdben9oAw7KaWHJA9UMTDbhEMRTuimAW6LPJb0zj7PE
         vmoZ6OnvEZGFYu2x46P1ueJCvy3494aea262snJRWGYVYl6neJQF3HeDoHh84+mSw4Gq
         +9zMD8UoWNxmY1Ch43dX7bgXv8qIG3+O63/0ZjxzDC15qPvjbigZmFGv7ds34mKzCn03
         /m05H2jDyIgsiY93PE/huou/fSyL9Id0wFcZYhq39CEwYRICFDuOkmoDp6fzGMjIVvSS
         kzIENu58B4PGMnqcdIzJav0BlE1IxSKTpphxuoAdaMkaZcTRqTpCJzRMdJ3FlZhO4b01
         LeoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773339589; x=1773944389;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BJeTY5HtximJl4H/EK6OxpSJa7GUKH2OzkM4yI7+cig=;
        b=nYPPpuAlafKks7qxzXNihorTdYIjANrTp3YepmohbFBjvFKGtPZXjhtDilcizsyJsg
         V1nVMQIEHjSxwA5mL+P858LgL8ksShsX1Ux89Un/3kJ230xiPBnJBRkX+mYA09DWrnEl
         8eXhG6soS0YyA492UpghsXcdsBL0EvKi5HAL8unto/pneRocMQ6fn17bO4OV08SoWMTs
         hR6uGHoMIKCIw2pD8eph/m7JS1YqiYYveSw90CpIUtyBNApEfjPi3v/7NqVS9c3eFHVN
         UVjHy/R4LvLhtM41zoagYAH/KZuoMNf3d6XzYtRNcRHQs96hsvL0v5FEmC+C2MolBz+9
         yqeg==
X-Forwarded-Encrypted: i=1; AJvYcCXym7Hbv6PrE4xtU8BM16pmBeH/qZoPo1PITcad4lQAn3+XLux0c1fzZ+PoIBq4YVXq6jS1mRUB9w==@kvack.org
X-Gm-Message-State: AOJu0Yxj8AoRSb5ccPnwoZrNmLBy7ca4pBPwbT0qb7C/h1d+2L3HwZ4y
	FW4bjAfXU4RDwlaNz1Fwz28ddyvcJ7BaOqvnSaFOxKp+DTbBp05+dD2/
X-Gm-Gg: ATEYQzwLNWsBwihl4UuvOcS9sVxYrvruOggDP+ndfEblO76Cvm/tvMjiIJIQsNWuZ8W
	D8hDIFVHesnFlSvIulmQdud/pk4Fkmk6i141vUUpU/jsWZCoAOfLgcABfPrNGnUH2ZERtjx/geD
	AOwC+p4Wzv5J2X6BBY6mJHuGQ2blODNPdByFZLUPEI4gfGI0MHfds1Q8LELCaeCFy8IvM6BHzid
	iJIVznPc5hz5ARTK1glFpdMIo18S6n1GQmEyHRNUtOLsW7hfcjBTmN+JyHhEEz9JSNSohGQBeuD
	W2N5OFcUTJjBNnCOaV1QWQuhWwIbus9zljIhPL0JWA4N2YapKuqZP1Da33SqLNIPXw4Gq6BTeld
	KIeR4QMJXEoVc3GXGo0at7o/VcOXsSuJ0F3wsijsFgjRPZ2dknqSAGS2mihZYdGfE2slwx9866I
	kLN4ZUbInVZ3cIskrzoqK/QY4gvZZyrINRiORKDxIklTic/80tiAurE2+OMHGgz7WXDPG0LDFze
	3fmja2BNw==
X-Received: by 2002:a05:6512:158f:b0:5a1:27e9:3472 with SMTP id 2adb3069b0e04-5a1626a318amr226128e87.0.1773339589089;
        Thu, 12 Mar 2026 11:19:49 -0700 (PDT)
Received: from ubuntu.. (static.159.107.27.37.clients.your-server.de. [37.27.107.159])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15602e7d9sm1085336e87.35.2026.03.12.11.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 11:19:48 -0700 (PDT)
From: Josh Law <hlcj1234567@gmail.com>
X-Google-Original-From: Josh Law <objecting@objecting.org>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH v3 0/2] lib/idr: Fixes for infinite loop and memory leak
Date: Thu, 12 Mar 2026 18:19:46 +0000
Message-Id: <20260312181948.20020-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5sddk74r86qcemtbe1y1s3tpo83tzw51
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C5781C0010
X-HE-Tag: 1773339591-601060
X-HE-Meta: U2FsdGVkX1/InAQ6S30gx1ODp8AzkPZYAdjPex4dwqiLN06CAXS5FBVdAV0fTzTTpo9tMe+ARpkS0mAQPN6EBPPhkG5SxggcI1AyzOsnhvj6QfnV7w8AkmevOJBc9YMkyu4V0QagGnXZD6B7LsQBPPA3m0jr6cfu3au8RrXTvNmbcY7ZemdomIO3woPGq+kws1niRjaHgJuExbddClzh9Kf5lENclto+kWDDNWjKJrFgq3+yTJRcSx8XZ2kAfdTp/LCw1KGvsklW1SYw5i/UZs0Xme/8p5jxpr197YPGzZu/UxeBuyd1bvq6Gt1eLBUtJuuc0kcckEOTTW10Y7tDVwnhxgdGE4hg8qfZKOFIufnvRz8KsC0ovKe4XbZVzzB+0FgqZuHM6BA9EEp+ytXlaxDWNyNQRpGiJ3C1P1PDrFsXn9Vgc9bp3xMCoQwHKwoV3N+rUBo5twjvqGTx6FyaSai+V/vka+d85/E9ksNhDBmd+gRZqspgMliDU0SP2myWkd9mJ+/orhdyDzwtPxPyLuldUtbbGnL2SEeAX8ixIGtWRosoMVDsHNEbDsvVJliIc8AmuQc7mljcdHILp+gHF4I0QTomGeeEGNlpzXroF5/+oKbngLv0OEvcT2hNqwgDusTG+V1AOKQCHKLEUANKLedpFvMpb5JWDmUIy2GNqjZheXmPp0K0Z/RLdLM5yI0lPRtWVLML9uY9jNUlqRYvKB1PBG4K5zvXPZbanl5I2uHSLkL/Kj0eKrkkzurO4A4SbeFR2rJHZItdTfNTsxLunKMP69SInGc+18ZE7RLZN0g5M6C9sC8iC9ryv6SmOtQLmzwnbvOs67Y98O1UwgFE9vAIt6PEciQslc1qfdwjQtBoYkksxW3qEL6gV/0FKiJ6Q1F5Yvjkx1UHDriDDlUEAOZ1bZGEV+s3j+BbKONAaqydKGb1IEb8Ss4rfGkwTnCd6kK+Atkkz+iAMWe+ieA
 QK9vf2Xe
 ENylWa5Z26sAS/yYyKiC8+jKPHjAZviMNkTISZv3YC4EJ8CLuMk+1pHL+nnBEO/uKnKglJlE5d00/qGlJ7qBoiQfESjSNUtH4v7NMSTWLmjGSXcdtSAuqz70q8fWzwcqdKCCHMXK8QxcfR9jiqgj7gXKh/iUfaXIB+Spt2OTusFcSaicMO9KkcQZdC/IhJhutL8OYadMbIcxBuXuUlt3+S96bOr839mSSKoeELBS59BS5gDdIVAHTKZgrOLRrEROjvyP3JEuKAuxbpHaLynWtCz7l28pNXV2UHCJuy8XN8pag3eR2JtEBTWBvDxeXiD4KXofpmGncB5zDKyPf1xBdllfkGpIJ6kbua6wl0touHBp2qsc4JSoHpWH4PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series includes two fixes for the IDR and IDA APIs, along with
their corresponding test cases as requested by reviewers.

1. Fix an infinite loop condition in idr_get_next() that occurs when
   iterating over an ID > INT_MAX.
2. Fix a memory leak in ida_alloc_range() where an intermediate
   allocated bitmap is not freed if a subsequent XArray insertion fails.

Both fixes update tools/testing/radix-tree/idr-test.c to ensure the
error paths are covered by the test suite.

Changes since v2:
- Added `idr-test.c` updates to both commits to formally test the fix conditions.

Josh Law (2):
  lib/idr: fix infinite loop in idr_get_next()
  lib/idr: fix memory leak in ida_alloc_range() error path

 lib/idr.c                           |  4 +++-
 tools/testing/radix-tree/idr-test.c | 19 ++++++++++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

-- 
2.34.1


