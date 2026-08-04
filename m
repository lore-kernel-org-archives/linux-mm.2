Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 974B3C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2D16B0116; Tue,  4 Aug 2026 10:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A996B0118; Tue,  4 Aug 2026 10:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C81A6B0119; Tue,  4 Aug 2026 10:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 791496B0116
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:48:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F5AA1C0043
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:48:25 +0000 (UTC)
X-FDA: 85063867770.21.DEF5B17
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5823E120011
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:48:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h7BXmdEL;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854903;
	b=yjaS+NtJajbpZwm7CwqldtLYjtHzo8fysQiEhFH38BrXPHX4gJGoKHDDjim7OalByd6ZHs
	yiWyZdqK9VacNr2BwQDB3hd211/QLgSHODYFauuBZksCVLCLpkAfOdMBmO45QNqWi3G27Z
	2Sz3NlJ//470NNXp9GErMdKG9x7vO68=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h7BXmdEL;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ne4iCXF0YtRkqqNh9FG2OYoOQc5wnzoZA33q3lwGV7M=;
	b=PDfCyJP8RtO3m8lHsQL1vLwZjanOw9ZEVgdDPr0ZLiWHJifx792ZpJM07fflrOB7dWwY1T
	woMN+WsRcyLWhTWgrnh4ZQuCZMkiEJsoMV3Hy4v60s3hBTJ0zDdXQxiyGLc/oG3ykwuOVk
	cNTk0QTUVUYpDpQrusOEa7mKi9gfqpQ=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cc61541f8cso13103985ad.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 07:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785854902; x=1786459702; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ne4iCXF0YtRkqqNh9FG2OYoOQc5wnzoZA33q3lwGV7M=;
        b=h7BXmdELGGBUCPHc4FXLh5FaCyYkmBiHhLiYEalHSVjLOXJeX/dVSsrmQ+4j0rguxp
         g1Bel5mshT3ObFD/Qn1UjTkrlbNUE4nWeQlem2QXO2QSjuO7ck4UZgDSvELAbT8GTf6b
         TkgdMswHJ+l5Lapk/bE6YtQCI/grOC1DsWUc/SmnoDNX7VpCWrBrD/HEMwqICIabGeij
         XEJFE0IZeLQRYvBqF24degDvJhivBFvDj+36vMgUYTzG8BtL/XbdajtIFPkNGz2CoYuU
         s/G+MzzX5nx8nE8FqDXQ2hynYGSUDgnBykoI4h3Dx1BKIV3eggKqPFaitUS6XE7/qFiM
         wiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785854902; x=1786459702;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ne4iCXF0YtRkqqNh9FG2OYoOQc5wnzoZA33q3lwGV7M=;
        b=a3Vctu54XGr2eDUeHPIzpwz4GCFdniGqTTWSLEmAxQg+knZ/ddhaY1nutNOllljvfO
         TP6yUvdCMdrrhAXMfeztlzD1iD1lXyH7nl8m2IjzJP4YWflwrQWWC1PbEM9KLu8Gv2VR
         ePoCkmQ9kdjxNVxQ/cy/2y8t1vpfgs7qSrWmKmG0sUMfU2oRgydNScq3OifFijynvmok
         7hb7BItdA49gnry4ojI7D0ie1VN3InSkf+Re8PPzZAKuluUwW9E4L5jIPndSEQPyCWXR
         NwEBJ61x1icAGHIwJ9oIcYUogpQl+we1qQ8cttRRLwy4hkUXEnPeUH4+13QZkpwcq4L4
         2RvQ==
X-Forwarded-Encrypted: i=1; AHgh+RprBEq9PkAgHaXDqhGpcNimFQ5HOuTvijHUY3nOJnrEGhMLMlxeWgDqe1kkTTcko9rr8mdh56USkA==@kvack.org
X-Gm-Message-State: AOJu0YyAVzgArDIvYw9mIAASPZw/BQ3K5IK+otxNGzyccmTq/VveBsIe
	LejtK1BltMk6EL5/nU5W/x8+8clhzuUEFsit2IUwN5y3Hv2gZqQMRAfo
X-Gm-Gg: AR+sD10BN023AZNWdZiot2vg+MA0IGZuTTQeZ2+6wi/DkXx5AM8dYyv5K8CHL4BCHki
	eJGzW2uf8S2eBHJ8jiDFbIazmNZ3/2OG3xXrnCZpvQ9aanvW0iyquvKHlJdXR8Ghqou/ka4eDwo
	jvJAom1XH5tgjQv9nISIW/b6l/2n3tDmomYEZ7yY3NDLzkVxpJ3vQZ7W8DljyUgHHGq5tcf5uQP
	RWM9+A4gFuunaa58G5LVX6ToOA+ycU8nH2xbn24FzOIOumNFnSf2CpdY397nIKMZCU6ZXq9tK9z
	Z3EI0EFhkJt+avH9OLi4gRPHKs1kIY958Ney8e85/F3lOBathiwkLkJ/A19Na7lPsiAAhTjebmJ
	osbk1C30M6cjRKXBwQHybjt1SLIHWbR5OiOwLTVSD+PizhMKemzuyW8SX7NEc0msLV1sBKPvOBy
	qdlAhqi1iy6mOUqXgf5hmS53qaoupyUG7ROCiea0QW0wJURNuEGwin9FY=
X-Received: by 2002:a17:902:ef4e:b0:2c9:d8c5:d55d with SMTP id d9443c01a7336-2d0c277f6f8mr1193185ad.16.1785854901885;
        Tue, 04 Aug 2026 07:48:21 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4930e1sm8784175ad.41.2026.08.04.07.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 07:48:21 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/4] mm/mm_init: simplify zone_spanned_pages_in_node()
Date: Tue,  4 Aug 2026 23:47:57 +0900
Message-ID: <20260804144803.3290255-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z7tieuo7gj5dnwy9m77f5bcqnh9d6feu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5823E120011
X-HE-Tag: 1785854903-870723
X-HE-Meta: U2FsdGVkX18gMW/2XZMh58/e2bjzGlp0JwgDtc9qbjFTKftxSsLuH1HuC1JqbzGFakEzQufs/oxAxMiA4HCaPg5kuK7wTQWgjk/N/V5AH2gQv2V8oFo+33xoG82vkJQIQAmOl6ccwctKcBUJxxnsJIeTKmM8mdL44wI+MxRF6ErWZG00RmBWFcjh7gwessIqkZ3kjf2NjKUWL6NYn0pAe127xDbug7iOo9kJww+AQG9iMbnacPrI1LLy74Yu2FpIpIGjH0ds+uxHFA+/dPNiLa412bvOqNSRVLiId9rH8wxhgw2UJhYRyQLL3H1rGQd5i13AdSsxKM98Sv0Q2pewX87fcWHv+oNCOVBWE81WKFYMZwdXG4m3jhkyAkDvoiYSrDkhqYQsv69i3hMtt2gMXQ2IiPXKeRkQmwJGb8VnqBoov2Kqy+YQdERhuYW4ky2CjOW1oVcE0/VE/eoyoJuafX1oim/Q7ENGx1X0oqjszqtDwZD7ws4VuK/L7cg94kqcn7V0ePOGVd/Vly2r95QgQbFnbIFdKeZGht37yIdoqvRFahuV7H/NUnhXEXgmO2jsMr3EhoYTokZ7Rdd7rhRfIshxQELml80+DQfpfbNZCJqpSYlwMbmSuQnpf/0U2xm8p0vZPEPKgTW83uHjFkFmB7RDC4Mzqf077kv6DGVtif7V6aTaQrgzy6NnurmHxvZd+WlIx4nw/V0Q41cfdyjW0vvMfHBCUwuXn5QVeS8HKvX4Mlqvw59j7NHOWHmjjdABcHthko9G5JcWPCjN0RdDcbWXHQoQNzKfJHXrEYKvPhu6dcvRYAE4Yplhy0cRJYpxwcEniPHRKRvx7VauEpxCPIktgPsONUmZgtzGJgd7UM/+NsGkX/Mi5rO/L3kIc8us9dg8fkuWjCAShxITn4oWy31GfD3ajDx5F0wj4wkyUaag1BJ+durP2yO3FrfCu2XvJvhx9tlOi6LQLVSdNo0
 WVgebTar
 TUVrv1s6ue12D1GuFL8RSWHujZ5xKnagn79R4ASiALWvJWtfGgO/yPsBu9Z/zpA47FJKjyF+Uaga4X46n1SwbkmIMWHVarFoHg7o7G2fede2Zr4ejQevef15tgacolBlvdrsdHAYodz+R/k/tNzUEUi1y1PUP8/0ac7KsCEsmKHrOaI/fVwTrmgt2RnLpQdEslnyjMPLShXuWaqkLkZw+mRiG4X1tWmCxrk44Lyk7TlnUYcFrmlfjHZGkAS1NHdsbuUcJnQJ9tjzfQ4554kyxLPgR1uY93fCoEyymttCDy2qcXsm/S/oTsJ35bbtW7nx4Nx8aLo7+9PoeC4ivSq+DTd8hpgEJIprBxSTOW5d3KMPnL5TibY6/t75Hw4Z8uwZoLiVgzMoqCOdgW5Rkxd9GF1AwhMDCy92dcNV5CbPMuZFtsQYkGHKTNplJaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This series simplifies zone_spanned_pages_in_node(), which adjusts
*zone_start_pfn and *zone_end_pfn before and after calling
adjust_zone_range_for_zone_movable(). The helper adjusts the same two
values, which makes the code harder to follow.

Split into four patches for easier review. Squashing them into one
patch when applying is also fine.

Patch 1 folds adjust_zone_range_for_zone_movable() into the caller.

Patch 2 removes the clamping to node_end_pfn, which has no effect.

Patch 3 moves the check and the clamping to node_start_pfn into the
ZONE_MOVABLE branch, which is the only place they have an effect.

Patch 4 extracts a local variable and reduces the indentation level.

No functional change.

Sang-Heon Jeon (4):
  mm/mm_init: fold adjust_zone_range_for_zone_movable() into its sole
    caller
  mm/mm_init: remove redundant clamping in zone_spanned_pages_in_node()
  mm/mm_init: move the range check and clamping inside ZONE_MOVABLE
    branch
  mm/mm_init: clean up zone_spanned_pages_in_node()

 mm/mm_init.c | 81 ++++++++++++++++++++++++----------------------------
 1 file changed, 37 insertions(+), 44 deletions(-)

-- 
2.43.0


