Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A7DC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7636B0093; Tue, 28 Jul 2026 11:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1573E6B0095; Tue, 28 Jul 2026 11:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0465F6B00A5; Tue, 28 Jul 2026 11:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFE856B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:59:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42AB41C0312
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:59:17 +0000 (UTC)
X-FDA: 85038644754.20.CF0C380
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id 79A2E4000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:59:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NmnEhYwZ;
	spf=pass (imf04.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785254355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZyPtbojkew6N2Mpwl2cc8VXMxEGAS6GjV720XpOTZzA=;
	b=LdNfIxOElwcM7XBiGyp9vx9vdS4jjWKbVIlM54gHdFyRDNqjgvc6r2cGcmfTJp5pGFG62R
	aJnvOn1OWA8YyyfOIR+lP0gXc1AHJqAsV9gWTGPIqWXzTZ/Fi1bH3alR4al4aPPP+F11kz
	mv2L5CTYcXRCCpSoI1ch9pVWIIJD+qM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NmnEhYwZ;
	spf=pass (imf04.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785254355;
	b=bemigF7zAsB5QXu+cUz229i88FrW+2fsCGJslPD0Q+0VPiiD4tkk4e0p7+vloUijyO2IFc
	eCPXskzCYsc7gAnkrh4PLvCgnww1lEthlx0RX1mlPDsG1VakYqntV97qWxOYdjvWsHI2cc
	/UQKMZEEeWS1LNfN52GkbvFZEo2KDAg=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84a652535dcso2585004b3a.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785254354; x=1785859154; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZyPtbojkew6N2Mpwl2cc8VXMxEGAS6GjV720XpOTZzA=;
        b=NmnEhYwZSylmLiBYZJ52l1WrYpST31076uCBxAC1z4BeGKsPOYotJY21LeUNhTzchn
         sHIfTaIslyr4TusQVBOGZ7WslvhbQoJwidtdOTeihvNXFkt0TbtsReCvN59G+k5/VFYc
         FZMB1ZteTKVNggz8LGdN0MqnyWYCOm+dWjlIPq7yIlCs8p7/GJPjWkZ1HOd3eUPbj0EO
         GHT59KE+4igOQRTfAY3jwnNmLdAa8G5RyaLGDCYIrkc+8mAw6PcSfXTIdZ36eXfDhld8
         gCskRQK9gnrJt9aojXgVWBLW+FqEcBHy4VNmV1KG6gofYh4rRYe8aYbIWIrdFK8bPAGe
         TEuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785254354; x=1785859154;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZyPtbojkew6N2Mpwl2cc8VXMxEGAS6GjV720XpOTZzA=;
        b=jyQADgAcskoQU/4wytPOWnuGcPyuGCDvYei4q+lrnXW4Bz3K2OcjO3sBfm1w4yX0yF
         +riyc/cmFCbaZfB6iz36jHRtOiB5fcJWpn4sUmSSRiArR/L3uymrNULlxgJTJnE9fzvL
         Y44iJ1G+WuafoZjrWoi0VR+uVxITpPiOuGav3fSBib4c7Wr4wS/2iClE//OEAc9CWAHF
         ZLzhflllHrjTTmSsU3ofx5b9aBof3/2FzX+Uc3gj8/vE6y/WegcG0gkDnxvIO18S7eRl
         JftTRo0rakKR0eqId5tnjK8/Ug4LxLJL05Ol5b7QdtuMMZ0FZKL5us2280GxrDDpxcLQ
         Wc2w==
X-Forwarded-Encrypted: i=1; AHgh+RqYhKTY/R//FbCnRMsnalh438+mTP32Js/zM5PU0+GyBhG16dpv6GHKT51wAeaihQGNhszi1pfRWw==@kvack.org
X-Gm-Message-State: AOJu0Yy9V+MRgYWxN2Ym6khz7z68a4l3/ZY85gKbKmsjKw942w1C+iSI
	qtnc8HQFBfvsrp/qf2CmPb5xn6LD3oDip/JIR1RTEGo4ZWdpP5ZDFYBm
X-Gm-Gg: AR+sD134cCYAy1toe8nOM2drDIdAvSTBScAar7oGMflpv/OFOaqWDGYZkEfSHoVSOIx
	yl19Ep7Jvw3Sm6n6ySUt31oxWL+5wetVCdsKRwCkdV1ZsDiLD/8WaKdAYWqgFAj7Ytfz1STeB7V
	j4mmedfwLaVeLewr7laKQGT+ic4W0h+Kyz8HshcLCCCrrc7pRjldTJaymICN7X5eJXfuNq4ac5r
	08+wM/ncPQ+3NQjkHMWS8Et2lxIwzOT9q25LD6Bj9/YN6jEONVt0yOvwfMkQ5B3q/ovoBwzXFpW
	oEJTteYkTL4+CQhLqQrErukduIk9x6ioIW3qDc5GHSZXbFdMnVEW+al1yl1ma9UqZZ3pC4ZgDfb
	qPb7ZNzgSXU8ZNVNQ+745NjfvgFaxa6aVP7Oi9VNPb31ZWgMzMyafcaNWB54oSAD58JTkMJTa09
	0RxWoqVHY8HgKEBI4jPwbKbPF9sq5fhD8/k497wFLkqjiSY+OHWdu3Gk+jgiR4YuI=
X-Received: by 2002:a05:6a00:189b:b0:841:dca1:8b69 with SMTP id d2e1a72fcca58-84e93196934mr3246661b3a.5.1785254354266;
        Tue, 28 Jul 2026 08:59:14 -0700 (PDT)
Received: from localhost.localdomain ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe2393csm156441b3a.10.2026.07.28.08.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 08:59:13 -0700 (PDT)
From: Youngjun Park <her0gyugyu@gmail.com>
X-Google-Original-From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mm/swap: skip empty clusters in the swapoff scan
Date: Wed, 29 Jul 2026 00:59:05 +0900
Message-ID: <20260728155907.391820-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 79A2E4000D
X-Stat-Signature: 5759frdk8bf3xd5pd499nw1edg6387hh
X-HE-Tag: 1785254355-438508
X-HE-Meta: U2FsdGVkX1825aiYTEUbKdd5l3NQDw6ZMztvb+OHfRQPzFDHrUOXrdMPwpEzO7IDR3+HrWsRuVGlpWtxH2g1ZafcCf2si709IVXR6ipwwSFVbI/AYP19bwMNwmFjGY+5UyVbRxyHLSRLra7CBNlhbrAOq9js7zyPI925BFs+3u3FTwUyAUrgNBHvUPK49vNgPiPJwadWEm6+OyqoqH8lbUDiHKVUZcLkMKnUpr0RNyNHKW4QWQd9G1CHremyP57yy0V5xMbtLwJd8jeQB4HfZRiMTaUBXfZcYdlwJUMtQGABNMIbEdbAYawOVNA5oLPHVkvQ76nQq/gqO/eJItycTjJiqXlNoDRCcT6crQ3dnbgA/TOQvgfh5WwgwBm7kpoqzAlpmI92UpvkZ9Oxp02meQH67HiKYrC5MjvsjpNA0pC3DpDeYeLimeORhl76kgOuUrgbXT3RdtkOh4++cbocpEhDZftdZWo5S1XcBNPJbSkyWrTK01042PurKbM4sd6M9pAV4CWUnfuICHkLO5Yx46KpyZggNql2p3UnYyQj6yWBtNb0n87+slFP5jXVlHTXS83Tn0372XFchFh4+Wqe8M9AF4GtmejY2UtyAkM21/ImQILbge10kFONd0fMO0bq59EkYItC28Jf/7eYXRkW/FzHe6YoP5adFHLqYOYdeCjBa6eVjsnCTPtl4nYteqj99bolvTn6LU+PQxpzkLi6wnLvU+w49tKUDlXQ7pVvMG2hP7qGMMDOqO9E0GWubR1o4U7CWenj2VgiFSZYa2XYFBGQmoyHu5efL7UNPf3lwGOmTGVyugDT8kMDmBCAnM1yPfAS5U9Jnedlru1XgtWGF5z6wv31cQDLK8fK3qdxSWF4A2ZXM9MsGF74dfFeY/9iRKlunQwvGcN/tIW8P1I5KUyQF2Y/MJ4HyMcOVfeHVv5xmSaGjv2oCCfxiXvleYnqmp8cZWyYf6IsQKxE5Dv
 mVm2PJuz
 5PI+3j99ublg2FeMpWpOw+g91d8lANlSCGJ0xwfoCacqgvDQhaX3jiSAldY2aMYI65Vo/wSPVrSBqM5Ui0wSrdsXqx8uzI/wO6WOs/ny5GRZugKjWi2ZX+BWS0EtmGegiGALZkuqqLVqFG7o8r8cMqmLubYMrMxZf9hJvXwc5syfYJ+9g0SgktAno1R0avdcINo0YiE/s7ItmyNnWiS7hl3S147JSyqVV9jgnFAOip+yLabPVobm8B0oIwvimq2dsoeZKo2b0Fg6DzaKvuX+XcQwsdMNudzkkzdHJhF3wTt2JNHA6T1DRj+xc3bUA5yGAn1wlXiFJKYCzxZpLruBTnWAujtWLeGSKzQDKJ77OI+jVDA5C5KH/ULU7EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Youngjun Park <her0gyugyu@gmail.com>

find_next_to_unuse() walks a swap device one offset at a time.  Slot
state now lives in a per cluster swap table, so patch 2 dismisses an
empty cluster with one counter read instead of SWAPFILE_CLUSTER table
reads.

Patch 1 is an unrelated one line comment fix noticed on the way.

A counter in the skip branch confirmed it runs, and swapoff completed
with the device under load.  No DEBUG_VM or lockdep splats.

Youngjun Park (2):
  mm/swap: fix stale comment on swap_info_struct::cluster_info
  mm/swap: scan by cluster in find_next_to_unuse()

 include/linux/swap.h |  2 +-
 mm/swapfile.c        | 39 ++++++++++++++++++++++++++-------------
 2 files changed, 27 insertions(+), 14 deletions(-)


base-commit: 2a4faffc103297c4822bb269d521249b75cc2261
-- 
2.48.1


