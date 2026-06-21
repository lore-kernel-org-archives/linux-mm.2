Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 678DACD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1825E6B0092; Sun, 21 Jun 2026 11:00:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1330F6B0093; Sun, 21 Jun 2026 11:00:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 070036B0095; Sun, 21 Jun 2026 11:00:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D446D6B0092
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:00:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 375AB166CFB
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:00:08 +0000 (UTC)
X-FDA: 84904230096.24.5E82D78
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 58757140003
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:00:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q74T+Zl4;
	spf=pass (imf26.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782054006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1blrS4WOer0X3LUUXBUR34lRHsvWbpN8RbzJbSX9afE=;
	b=7HG+rt+f+DMGyTgxxiUUZtirjBDAsRdbEhHt3RZcoyiBP46n5DQea2XnHt9kAlMEYRshCb
	no380Xh/d3T36pOL4Pon3NFbl3aPrDpzsch1FyuDSp16GRZCMfJidBUBjURbI9uo2TOG+n
	uoKFY3Wy9TIhDZySKY5xJzj+XPjaZQo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782054006;
	b=QfDEM4fVwHOZpiBIhRnDdc+zk5FHGcy9Febllvt8MNh3mhlhXHkPDpUqiV+VllSeS2Od3U
	TsZxytr2J4RuNLn3vxL3oTaFsLGqO0QxJAd0wDo7be4ERJvD41CIpso3qn9wpn+YiXLZbZ
	RN9hJQcfYnEcUZRYtyQukir8K6mE+zk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q74T+Zl4;
	spf=pass (imf26.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-37c867bd3e0so1664017a91.0
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 08:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782054005; x=1782658805; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1blrS4WOer0X3LUUXBUR34lRHsvWbpN8RbzJbSX9afE=;
        b=q74T+Zl4ZPD94M5i4kQb+k7D5olWwgJ/Ie1pn/aZgU588aQ6wYQSiIqRzMobxvkVMx
         UHqu2MSzibXlyMoeMW+IKzV+UJ6KwyndAi//uLbXRuho5K4vY1iCPiHY9Qn9x1Z+ApDi
         3pOU+58JCYMLCbXHRBXv45hp8u2h7j4fWIHJT6AXHjE8pee7LD1Osk5sHPN/dQ1q6/1P
         unjOGbqPFryLyqtkdEP2GThfFAgvWG+Dsaa1r8iaGIHNyPsXGMfIa+dCmEJEtzoobUFw
         Fv23SiGHjpWQCP0NN1M21CS/Fy4HV1JJ6wkUduWiHO689NJT22XV1SK82TWkVMxl20XZ
         kYng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782054005; x=1782658805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1blrS4WOer0X3LUUXBUR34lRHsvWbpN8RbzJbSX9afE=;
        b=OcYaSa+/onHGCKf3lktwhv97JKd7Kgj7Cgz4TIGIUnU9NOzISr457N1N6akrve1pZ9
         Id5WOCPLnxhijM33QRLI2W8sqY4C3XNZNDS64Mlqwggm2OARupBdgiO0lil0ozeNcMrS
         HqCBpBOWiitMj+iy1fEkiZlJdG8In6bD3UFmvlrA+9DC3dDwRcc9M0FqYSTToir+rTcD
         wM+kXMY/gDwOA+qF45XnidG12nKIcRhsZJGqS0dITyrLcqJYU+WjfbtDkS+kLEi+aX6U
         y1jdmT2IQXJzrLLe5LVyv5DOHbAvOmLzfhcktlk/ZoFamp6rkderBB8Jr+MNlA2wmydM
         7sKA==
X-Forwarded-Encrypted: i=1; AHgh+RpAOhBJaZjWzMTFLl3VixHyCdr55/bsSm59BOLaGRHCNnRk6Xr6kpaV3CXP0mwGEUtC5JMzPw8qZw==@kvack.org
X-Gm-Message-State: AOJu0Yy57mwa6QWywMh2qYxfXPPXizPCkhlGwiQq8eTSVAf2hwKs89IB
	Oa4qIRJpP72RjZf/+kuctnHiuPdesEzHTWMN5cRTZr8CtuxSOz5pt2JQ
X-Gm-Gg: AfdE7cmwJ/QZIdn2rMPi9KKHc4Zi9cS8fPkm6VgOvtpsjUGBhoVDNS+77Ns8QYpu+99
	KSn5ffN91TFQ+p5WZnepFpvmFKiQRInvqhQTRp6ONXfz/N4TQMg7jy0ZvibME3sPZugD+Vp6+st
	w3z81SeEFc/VPGfsPJv8Hgdlj+DJgeMlkWjBH52JcNSJ00Q6yCefqKU7oG/dB2D5MjyVR0oBe0X
	rnbvYd75KbQN/P9AenyLpczpP2UGOgt2cfMdRRQagG7vSa0/ncKqbkGxXIHPPcSwokgTUPpMoHs
	0zaDjl4qpJ+jpdwhISEVyzPgr4qEvbQbkJv40oVUfGGXfI0UNIF9aydg18snmEvwhoQxx/vFt1I
	ZVXAKEvvpw8ApLfv0pheWvdHyflbct6tK1f7CEkIUOoPoORtNjMzoZlw428Pb+h1YKZBbv33YZT
	7w6lW81WA=
X-Received: by 2002:a17:90b:4a51:b0:377:424b:59e3 with SMTP id 98e67ed59e1d1-37d15ed439cmr12328153a91.24.1782054005191;
        Sun, 21 Jun 2026 08:00:05 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37d4f225870sm4544896a91.8.2026.06.21.08.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 08:00:04 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org
Subject: [PATCH 6/6] mm/hugetlb: remove unnecessary empty range check in hugetlb_bootmem_set_nodes()
Date: Sun, 21 Jun 2026 23:59:16 +0900
Message-ID: <20260621145919.1453-7-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260621145919.1453-1-ekffu200098@gmail.com>
References: <20260621145919.1453-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fsft1tdcoqbfrjqroku9hfr85fxk3nte
X-Rspamd-Queue-Id: 58757140003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782054006-422656
X-HE-Meta: U2FsdGVkX18zDvB1f+UGSdz/1TIvoje+siFiT/woH+4D6DkZ+oCeLffk2zdThCEO/g39SPi67Q0jLYxouHZsfdWaZ+OO84X+OOHKITDaj9CZaaDo7p1LEHuNv4uEy0vjDEPJpAJw+Q5qMnO9CDzGinx4rt1sUgMzSMPH/xPWZWrGIv7bd/MQ61F/fO0QEi4/4+a1MsgEA3tokxeofWsPt1jlCm84UNZcooAf+/mKfatEfOjrJLUwyjJFfQFtpsIDzp6dsRjuiaKPmviXLQ7MJUfxKFj5Tyw3Us8SRpDHuJfmHw2LI8KqLzm/e3+IwH3PNqOpK4hqIliV+srqyEr3JTX2rT6Zv8z9kXrOQmF5j1lMm71b4DhBxOlv8PzQToOkf66mmcwsSQ3mhOlITn4sy8nyo9ZK00orQ0nNR0+JhzjCbeLkfodM/nYIdoMEBIE7ald40dNL4XWd/G0ruv44Fprl7DSzoMVlDjyu8yC9Ts55yG4RnQ53jr+hsnMdtw3HQa/dj6a5gt+qN7ZCnIpovmjdiVLbBtTU5b2YCy1KZzGFU1/OXgZtOo+RZEqib5B0eM0KAKeM/KP/0vXyD7ssvTNtCtcxqsm/zub5ipd2vESru4+M3dze51cYO4Bdatp6pvZy/yq6euUcs6e2/kKFXKqkS5vkDn8rtr3uvIZqojBRIuQps2Ds9QTuZfDG5IhVruY+onSpcGlCU9vfh06rQSvfEGYWQvUauMGG6EIUfRB5cDWW+XyosSB20P/2F2lxsqxs8Qn4V/hlny1RCJ9s8CwHDPZX2iAPyMaK8A4efnBbl24Z9y5+nGKm0+JLzd+8bp2MdF210XQhOHlzC87m/prKhmrD7TYDzTpyGBA4MWTwJxSw9ctSWJ0TCgmLTpkxYx5dQa5ei+AOlFRsea1gYfl59VEjeX4ENDgb/pwempP42CYoPnJp4HP17Bt5L/zj8uPsI/u732SsHVXJVmk
 tvgcFaWY
 V2BNXQo4OISw8CHFzrW236XItxL//XVZt9HtKgn+Heo4sZHppqvJdTfpkf7NlBWzrQ9SAGEHuwAF2Iz2a20ZGrTuFWYyuSEeUMuIAeAZPnMQWUzgjEYWyxBgGJl91C7Qr/qCXsRy/6Xihqycsv1iS+pdANr1Lo2HtMmKF7UOQ7qumZDBGIkaZmQ810PYpR8kmE6Qt6RquOo8hCjceoh53fJcNp4IaOC1NEjl9axTqMToMceV4OvtJgmF34fz5QB55o4a7HZhoIfKa8VBG39sx2GO7QnXKfO7nDPS8lRgjXZ02XS0fm1j8LiJjpXGhwZvVNFxUXCXLn1vRswAiyU8k0Hjd3XXa5FYpPes5Y18yoSydNHV5Q9qYC7HjaKVNIYDwSuU3Znp0r8RhnQ1nYIW3mMO12gv78ycBHfQ4Q/fva14dR5/X0r8IGFC1uvTXucfCy5L/ZTVpO0P8zYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_bootmem_set_nodes() iterates the memory ranges with
for_each_mem_pfn_range() and calls node_set(nid, hugetlb_bootmem_nodes)
only when end_pfn > start_pfn. for_each_mem_pfn_range() never returns an
empty range, so start_pfn < end_pfn always.

Therefore the check is unnecessary, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/hugetlb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..d4d4c9df5f51 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4450,8 +4450,7 @@ void __init hugetlb_bootmem_set_nodes(void)
 		return;
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
-		if (end_pfn > start_pfn)
-			node_set(nid, hugetlb_bootmem_nodes);
+		node_set(nid, hugetlb_bootmem_nodes);
 	}
 }
 
-- 
2.43.0


