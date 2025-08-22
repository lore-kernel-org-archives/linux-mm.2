Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 976C4CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8CE08E007A; Fri, 22 Aug 2025 04:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3D218E0056; Fri, 22 Aug 2025 04:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2CCA8E007A; Fri, 22 Aug 2025 04:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC5088E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:23:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6EA031406BB
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:19 +0000 (UTC)
X-FDA: 83803703718.03.D51D7BE
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4FD9E20002
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="Aw86Od/f";
	spf=pass (imf03.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755850997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qBDTGA5AhhNQonv3AdRNARJFN46vJFSfeKE1m0Pq6NA=;
	b=FFsOhHWZlwd33HQs91mbinPGHoAZE+rdOaiK3KrD3cPe5ut+/oYRKRyoYcWuNAfYbJSuw0
	uhdWyobr3Kov1nAwuNg7hMdqIfLcglwy95c9G56uFvx804op1mvXLgi4zLucA9h5iqaLAu
	MHop7yhA0VTIXql83vrvQhaZIkKz5wE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="Aw86Od/f";
	spf=pass (imf03.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755850997; a=rsa-sha256;
	cv=none;
	b=Rm0uORlX0dc4wn+Wex/4/osOcDwj/qKIBdOptqEshyt9VcW5MERyTdl0Qt8mtuZd1Sokhc
	feh8ZOVmyECDXwsZIVJdPW3Ypp4Vk4N+/EYlzTbqZrUbzkQqvO4dFzb5nwXTQ1E8J/VJSx
	rKp7ARiaVtsLhSr2FsSPd4rMn5nfQxQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1755850995;
	bh=5GRdMvMknEDtQxLhJ0PglmBblpugxYHK0GugaJg1PIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aw86Od/fsjrieQijnYclqM5PWDqAiTAmVQaTrMwbtNwhSwuvHfvm2DJgYvL7eHoAw
	 YUILuEv70EPIlE1MAO+a4o5sCE6kzXSboqmQRZqjnRh/5byudc5X95/piGi6Nuyut9
	 YDEVbJPbaoi5PP6RD/OELr36M52nYsclRJ8MVcuRG/q1OVNls0yCS3zpUd79Fz6/pF
	 VOc6XGOYfSeCrlzMvStb3gfh+v2HDL5+3mVhwTkX+0p2Ut3FpXDmgYsrL+27E1287C
	 yHQxkFKOkkA07d+oWmY+C4K+kd+v5bSh2BuFO4mpj8bJasMALBOQnYKClV8llxNPXl
	 uWP6fHLdsqynw==
Received: from mt.tail9873f4.ts.net (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 810C417E12FF;
	Fri, 22 Aug 2025 10:23:10 +0200 (CEST)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	kevin.brodsky@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v3 3/8] selftests: kselftest.h: Add unused macro
Date: Fri, 22 Aug 2025 13:21:00 +0500
Message-ID: <20250822082145.4145617-4-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250822082145.4145617-1-usama.anjum@collabora.com>
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8nggohyp5xjf6jy7imtoxpxd8qrhbpy3
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FD9E20002
X-Rspamd-Server: rspam05
X-HE-Tag: 1755850997-565605
X-HE-Meta: U2FsdGVkX18ALRLSlYjCTwhO25r9jxa70AbPnMOb2mCClDsSixA24L/cz6pkxuxKwIqOLIZ/1oGS2+HY06FWktCL13LBLgV0cviTiG0INTWDofE2suxcnatEdWUYoZGg/kjGFMCNj7Z+RMotO4CNaT8PYAPQH5Z5fAdhL/H40osWqKMX2k7le89l+vgzkHvww9j0JfrGfWl9bY0Zf0XgDasZrGTwkvys2YgbI+aRdv5jHutrPl98SZx3xojm1CUrg/mJUhiyM6WyHjyCIJzRn08xqmerkZMNwoVpdVUAopKP1QBMEfpz8C8zcbsLsSDsudtWAfQqMapELGTp2vvUA2eYH6jtrwzafNrJQmfA+jALrLKMiwRBv8EOtPGcFAalnU5dh7E3HCHh5CsiIb9uGz8I2CZGWJHh3+c9P1G4V7EVlCwL3FgSpwrO/UO2hcr9Yvu1cUTSJ5wIzlte8TDMMzVfjEsHYDA5Krp/fIXNpFHEtyxvpVK5wXDuLpS4dsKlsNOz5lhzvtj4RKXEWfiG6ufnP9hqKpj+L2eoQglhYAM48d0AsXvuO9gIXkIR7tQ+1iHgaC4zit4aUKo6WRkojOiDcVYclWAdpUJ41kFdhNfUKfwLeMvelA2mPsS2XTQ/+yEpLcu8UTLJR6+HS0n1UShdi7hjrkw8VW1kSSaVHmQwreP7m4IsQfCX/pLDGmoM9G1YRKWP/jYYZEE1BM9ijc3GhcYRRM/72ZFLu10c5Mt92eadGouJm0iry3/Log6d9gz1sn8W6JjWqOKurJtIjKYwUDXQAu63INzeXt6YTdAwvQpKeJoXD7IFvvu2YxfGyxwOaIwYP/2SOAAsMuTQvAe1H1okNge+7WB+SiIboOSKA229x4G0cBcrKEQi2RLbJPKotRlquA6P8ie2pE2Rz0LJ7hHc5OYJFPK2UJtk60RI7skg/tmRSyvFsGDxFV4TnMCnQbxZzhOhhCS6Ses
 tMyBSoVe
 T4Bic0iQHpVhVX65vM60r32M+I56cgVZxIxzcq/eMKtxDOhNuLIvflEWbkXrlbJvy/b6ecw8aicNNeQC4vgTQFySJT2gq3vdw3mria9sSx7XAGfHSrzRqwY5dAN14ipBBZ4ivi/IaN+wibKMIQouVQx9BJKD1+JkKbygCYRrFqaG7A8VuKtlulmePzvuFK/yMPQ88cwE17c8K6eBYGkJamPsTdYJhizzOMi8IiZNl3h6/8DNMbGky5nPHsE76auvfhHoLi7MgSb1buvtZdmPY+kVd9agSXhivCFXLEbTjR5IiUFGn5GeTCo9jrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add unused macro instead of using the complete verbose unused compiler
attribute. The raw __attribute__((__unused__)) is quite long and makes
code too much verbose to the kernel developer's taste.

Add always_unused and maybe_unused variants just like kernel itself
have.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
Changes since v2:
- Add always_unused and maybe_unused instead of __unused macro
---
 tools/testing/selftests/kselftest.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
index c3b6d2604b1e4..274480e3573ab 100644
--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -92,6 +92,14 @@
 #endif
 #define __printf(a, b)   __attribute__((format(printf, a, b)))
 
+#ifndef __always_unused
+#define __always_unused __attribute__((__unused__))
+#endif
+
+#ifndef __maybe_unused
+#define __maybe_unused __attribute__((__unused__))
+#endif
+
 /* counters */
 struct ksft_count {
 	unsigned int ksft_pass;
-- 
2.47.2


