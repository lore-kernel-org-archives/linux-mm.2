Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 945AECD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 16:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09B256B00BC; Wed, 13 May 2026 12:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C206B00C0; Wed, 13 May 2026 12:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECAF26B00C2; Wed, 13 May 2026 12:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DB7DB6B00BC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:35:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BE078C096
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:35:51 +0000 (UTC)
X-FDA: 84762948102.04.4896A63
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id 83920120009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:35:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wcDssgb0;
	spf=pass (imf29.hostedemail.com: domain of 3Y6gEagYKCB4M84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3Y6gEagYKCB4M84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778690149;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GAYyGAhx/G5yeNlKv4U0gQfTAFJGGiM57dE+Hbf9su0=;
	b=Xb23ebMOsHjBQT9257OaGbsVfzY9Ywj157I8MVa676uAQe9VDTaEoOO4/2i2RKpURjvWCV
	E7vWI6l3ToVUZV7QhuHBI0CqrfX8O3Hm9SUknhE1WNZbd6SMLYf4stX/ZndywZk1xpKukO
	zdUBZDTpnvthFugc+/XAb4adDjIJQZE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wcDssgb0;
	spf=pass (imf29.hostedemail.com: domain of 3Y6gEagYKCB4M84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3Y6gEagYKCB4M84HD6AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778690149; a=rsa-sha256;
	cv=none;
	b=0yaDIxjNzGuYOc/4jY6MI58xBMNHRM1S5iyE2SfQOTx2/rZKteQ1myG5OJ+S18shWD9fFL
	+17rOeaKNeafMnHco3N39v1DsmQk2hRIEQIfFyXUwHd+l/27qzRJw1V6xaPjfD89R6FUz8
	t6wjjBSLjTKCnu7Rv9NUXvoLE4TKA30=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b4530a90fdso166982275ad.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 09:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778690148; x=1779294948; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAYyGAhx/G5yeNlKv4U0gQfTAFJGGiM57dE+Hbf9su0=;
        b=wcDssgb0VA85+4EAKmPKdzZA5eO0OHDVg9VH3GV08KoMtY2muKnvtlshaArDG5fKZG
         UhHwYUjxJemX9nvzryOZhLjOl8WVTgpdfhJbwAc5Ly3Z0SKMr6Z8Ak1KN82XbEj8qbsA
         njODURw/lUQfVTJ7PEPrCHGEl+Jv/uMhGffnPV32X5uD+JsjoZCULinx5zGoKv0S/lei
         Y3+8rWNBpb28d/wcXKY6jkBQ73BbEQB+dqbq6EIgkFgojSaq4TYL8L82g8gMX7Nc8NyT
         OSiADJgRijIFYRKuEsNB9p9sbayPkAu7Ddph8boc2hFHUhc/i95rxvPVVVSekFBrS5tK
         J5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778690148; x=1779294948;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GAYyGAhx/G5yeNlKv4U0gQfTAFJGGiM57dE+Hbf9su0=;
        b=e1YOxu2h4RA3lu25NeWnLT1/6Ym50qk3/KdyVRF55iFC8/9PZRh57V/5/EWajWpaJB
         7krVbHBSIGDGDnCzsRbpJlJ0LrTUkjiVOzQsyRnWcTOpUdEqmeUfWihwh6bVPTBcl6a+
         PAvWDRO9bhgcd8HfnkXFry4chhlj1WlX1hjoRxNm+vtlaGJQV1JpwvSvBGwgDCZOvgPv
         tFHfhxyrRxJyU9VoHfBQbcm3F0xvZmOwShHzac7JkFu96USZv35ltui+zBYWviG2WYN4
         uolwumtlfhlQqpQ0wCOhFdSQGMhSkz6d/523ZCjEcLjft/C8zkOYTJyTcK3cWXYgP+Ks
         ztXA==
X-Forwarded-Encrypted: i=1; AFNElJ8kmjcfaxAjiKzRKPQKeGVJefeiIvikvK2cULl316FfCyQY1yh3YKw4mv1KRol+cAnfKYvsxq0scg==@kvack.org
X-Gm-Message-State: AOJu0YwGlhu8Qqy1B5mL2gPkAsEpV/actGIQ4oVfGruGcXiGJgSBKdNk
	zfAq3pqluC+2Bfl5x9o6fgfePN+odThGyx7hw3WpCg8voImQQk9apaeA52xfBT9WL8b3SyFbSWG
	1y5hgSQ==
X-Received: from pllm8.prod.google.com ([2002:a17:902:7688:b0:2b6:417:db8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:8a91:b0:2b2:42da:25c4
 with SMTP id d9443c01a7336-2bd2f7116b2mr27191125ad.14.1778690147859; Wed, 13
 May 2026 09:35:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 13 May 2026 09:35:46 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260513163546.1176742-1-seanjc@google.com>
Subject: [PATCH] mm/mmu_notifier: Fix a begin vs. start typo in the invalidate
 range comment
From: Sean Christopherson <seanjc@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Takahiro Itazuri <itazur@amazon.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9gg1pj57tpk65fuw4j7cqu3p1re7m1am
X-Rspamd-Queue-Id: 83920120009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778690149-531335
X-HE-Meta: U2FsdGVkX18VPnvw34ELoNTfijq7GaBgy4R+G1DBReXeu6bnpmsGT6+MtBhq+UuZu9U9e22CMAJEG0xrd66bUHCav9kOW2BKmbGzWWIfkmFRRhGK3n6GdOZmaaXZq3AKe9dnOb+WF761mXJELXqr5aFauXoRwbCsB9+DEZ1bBesy6V1RP32JdMZWG00VU4VWDZ/54Ah8fcsDeE3QB2BGy6RFi6uQq5orQbQBSoaMkUKYTjqBpG0PfktqGEup7xKEnINNHx3Im9Vr6eAjZAc0TQmoWOWEBKs/k1f2ZbeOtB/EPOiNBA718twYTJxkFJSmQgTsWvBpFQmFfxb2WFLuncmOweIBu03uQBhYhz/r68V8C4s2gHMGdRJi5ISFDMQ7s9PgpghUzJTHfKA+sPTLGOOXlJoOYTFuR0S+y22L//92Im1dwKtiVGyUe5HmyM78IE1H5WUgR/7BawvT94nea9aZE9OB52JZS/Cg1AhrKW6WbtZE16OJe/a13mYkwC9OFB9bSWKe3xHShxW+77v8IHwhuRN3VMZC6bP8eTqLKLciJ7fr55EIBcWWb67d4+JyzdFiAJqXKoWqUWgdp5vwZo+0QVt0NjpqkgdED8sv4EHMaaz2usO8fcaTlFtl5yyuYoLi3ZxKVy2BjOUFAv6BBciacob3sxx/9Un4rDKQe5nuFj2Qj7I4hnLXDgy+C5wQGQTb8BAxDsKRZKS2BElpObsIAAkgewp5x1dOBAlzat69s6Yc+aizCW6ikEiRCPE7Q/Hd+YyVvGw+VzbGZGl9GnCpvTX7AADyP9Fo+d9sQs/MTMtrIIxPtG8RK4U/qvXkRwDAC55ZyRRoUwZKfp+7mhKLvgpNY7Ahc9sd3FDctsoUwV5jIE58rX5xsebGk0YNiSin/3wTSQ0Rvoqul8kwasYm9MDGQy2wCVH2hbhTcvR2hc2DuX0s2vHLZ2ch95Hu8JKbHB5as1BbJbuyxyw
 aDvkCYi+
 jH5lTJx4/b2paMEHp6OM6Eehze4Iwc9H6deaB9NXCKTjv21UST3yCLiNbP8egXxaX7TmP6iTQCqE7zndwVMvki+BrDQtEdBpHICYNpiT8thXM1f543vkdh+j3IZAdndp3UAQP5THeG1m6qAbnA46Thm2tOk3LwHAjz8EprAR/BspYGdo0z/OxF/255XuqxbDtVx6wWKIxZGb3aAIjktAQqpszwi4Q/o2VTvs58Jv3HfzR2h7llX+tiJJtXuQ+Bphtk4TFUS3DPyX8/2X1fx9IBIn0Xm/FFNl1igUxFCeoCFiRfq6+FL/vXX7NAH19i6k1JEl7jvErRv8dYFZlRxE0XzbObLomKru2WeupJBtxBPNSBNbyrLD44EFPAgZc2SaVYo3JnMCoLKwbM+DGZnDW5JViLNngrLsJdSMZtb/koFlymDfnrKMVoTPAPTUdTSWOT1cR4wqXp3d0yGjOH3K4l0YmcpE8cz1fe/izpYV5uT73kBKNTufmlXym7XngKFB/WS/RJN6YAeSZ71Der9lKb2jPASqIKU/uYikIKaIxww+Tu06nUt/o/tdzykiAcA19PcJDiAVDXFVH2RR4Q0kp2fmAKVUQw4zTqJUC/fGiPju+7/G25B6EuLke8rh444tm5s/p7/MNaXuZhaklb6HQYODDJXf8LNrnS1FU3qmBd2ssSrtiLOLYhV8D4FpkK7XiuavD04CloPSvf4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Takahiro Itazuri <itazur@amazon.com>

Fix a goof in the block comment for invalidate_range_{start,end}() where
start() is incorrectly referred to as begin().

No functional change intended.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
[sean: split to separate patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/mmu_notifier.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 69c304b467df..a11a44eef521 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -134,8 +134,8 @@ struct mmu_notifier_ops {
 	 * Invalidation of multiple concurrent ranges may be
 	 * optionally permitted by the driver. Either way the
 	 * establishment of sptes is forbidden in the range passed to
-	 * invalidate_range_begin/end for the whole duration of the
-	 * invalidate_range_begin/end critical section.
+	 * invalidate_range_start/end for the whole duration of the
+	 * invalidate_range_start/end critical section.
 	 *
 	 * invalidate_range_start() is called when all pages in the
 	 * range are still mapped and have at least a refcount of one.

base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
2.54.0.563.g4f69b47b94-goog


