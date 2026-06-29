Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFAC8C44500
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC6B16B00AF; Mon, 29 Jun 2026 08:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B066B00B2; Mon, 29 Jun 2026 08:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914806B00AF; Mon, 29 Jun 2026 08:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6179B6B00AF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF888140699
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:27 +0000 (UTC)
X-FDA: 84932868174.30.14E1D01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4426B140006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Svf0cwGP;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735866;
	b=kA3Avrx919cTDU/WnSoD4Mdc2CKcCvmQO0IIfHO2GrC1i0WhEPVM0VJ4YVYHdJ+DRqWMrL
	WXxZA/pc+kV7f6tQG+8di+Ze1qGj9XqA/UZ6JFoKD5Sxxbj3v0W2odwxcpU4uZkBwQf/wH
	JOXPRyq9xGi+JO+XbYSdvYmXnUOYY4g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Ei3EUSCqZWfZOYLGcxa+N0JWy/qIc/OuIHRwuSzZmg=;
	b=Gq9lIaxdmX4qTRPjoiNlcfApAdkM7MbFXIyZua+w1nYtmkfaa6rYcGSyeK+p2pc+mYQtlb
	7pCmG53tTdSuSpPR3FAC8nfGK81jgTq5h+oEyJusSS0xBdA8t+QmaeVvAcglir/zb9tjoX
	PVVjOOOf7VDmFjhNts2F9jVGYRPj/H4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Svf0cwGP;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D7DAF600AF;
	Mon, 29 Jun 2026 12:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFABF1F00A3D;
	Mon, 29 Jun 2026 12:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735865;
	bh=1Ei3EUSCqZWfZOYLGcxa+N0JWy/qIc/OuIHRwuSzZmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Svf0cwGPe+0Yya4VFcXOl8r/WHS0AmORu3Nq1KprgekWtOOrGnU3DurFUXvd8IRlR
	 dX0Bn8XzAizI70EqxiKxIeoI4LasSRwbnP7z/Hctsa8TQZF0oo5a1lyhJPtL8WHi1L
	 wpDz1RHJ0qo8mL4vTWB6X9O36nhtZB3DddaCZDkdg9q2cZckkM82bWAiQIwDZ/3DaD
	 6tRDjLnl51gBPYa1nljEuWwTcL5QSBfBSTaHkzkPTAtoUWK99YNakvcmghRksQyIOs
	 5CRIMfr7kAvZMePisvMtTHxsHYccnqsfyNQSAq7/wQ+MHUqWFowzrecsjartpYIfXE
	 Wluj6yp1fiBpg==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 10/30] MAINTAINERS: Move mm/interval_tree.c to rmap section
Date: Mon, 29 Jun 2026 13:23:21 +0100
Message-ID: <91dde21e9084bd04b626a1f073c3b9b3a23cb663.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4426B140006
X-Stat-Signature: 9tsjz3g9kh355cuz75r16o98aige7bee
X-HE-Tag: 1782735866-35701
X-HE-Meta: U2FsdGVkX19FRK6H02FlIRE2tdPM/aY/+/ratnSuRlF1Sp3HdB5gDEcWWnasqFjkQWp9SdCM5Bn2cdZGyfJeZ7eNDPK2hmKt6nVFiBejLgOebc5cxj88KeB0MYpGh/H/eid123/5GXvUSAnNDTYFIdsbvm4ZUVZtu3GG/dGaG71KgDesU7PemCoCpqimxDuC8fYL03EpMtcGsbfxXUfZLk7HQlkLe6DuXQwohZVRDZCamIkbO4zIDsDjGERbsKE9jE/i1yReZ9OyHJzu3aYHz5takZuyyHDQJ/3DOnoLbSHiiD4rvTVQR6ZXly6h44Tc0VxbKU8gl4G1tHuTA8U0fopuGO/QXDCquI72OrUtCRpLu9+b3CPCZSue31iKorjNivS6MDhPR5NKGMKnOLgfnI21gA/TMhCAJmqbaZIJ/vdVQPEFcwbR2/2ttYf1/POKL/cO/bBV/6qd3SoXFS2j4y+Pxc8K13jR/baa2ZqelRv5jX15TBJXRqRL6BdF5uXRDHR619yunrzsAjwEuJb3/ZWDaUTfl8e0NrCkUr3oIPqLoyGMzufkwrVqiaKokQ02hOE3lZczvufGBB3w7O0oPjvlsLzKzvR79sxZdCdVsWUkuuP6TCCMbFUGLd628kkxFpQ1wYRpmR/aeoLYpu3LBZxiogjeeBvrbKnfW21NdmDjJqDWbX+e/zwFqsRURxXXVvasefPPPDK45drII3S1ZwlRkcs3oGoSsZ1QwojyDgPs1ng+ERuz4467CJgtO6vXwUa36DWhOOVlD2wh5hnjQAH2WAAZ1gfKnjcvR8oSV95/LLOfxpsblqNbiuqHjcZnz0QAaXGCTXKeI4LUIKxOI9ycsh56Vzxip3e6xG5kZIdd2TtjE6lSlcx+tPZuyIY0KEQKpPoYRsl2KWIZkE8gbmfpbmbMstpjwQpezIxDhemjCHs9j+sTKTijRxAcg+RRlDuxzb30lhvj7mlMF/A
 oBB5jgWm
 5gkbdoifdFm3V6Egb7Kyn9ddclyAlDLuW1SvMO4EOzSNWnYlSPXAq3hhtvKz+v65XXk1bFo7OuhQFEdQWzSwkBdQtrsBMK4ayNw88NlAbDQKF06Jzqll1nusWwQBFTOauD7UGoQe9/31W9C7teoxhXB4yEWeVEBwyDoXQiAa/97zwqMGqo3r8cNCI9mYyA0MBdIDfno3xBDzorvKsKCIN/Yui78qGaaZW5hQupsCItLNEr6qwoX0NyaNfsX5jR4JKkI9cLH9GiOGZirij8JSuJ9MH5TkhjrBLATbThWNDji5kTMgP4A7Q7l1QqOgBdGvzgMBoLPCihN2CnUZsN8Gl1H3A5INPgH7pIMleswROB476uQstYsY7ZFVWDW4ePpyqvSqdY4oF9DotR62dDLvsosthoZZ5hlVHNunt0c7z182+oTnoPCNpoT/LOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This file implements code for the interval trees used by the file and anon
rmap implementation, so belongs in the rmap section.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 15011f5752a9..c46fee04a516 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17208,6 +17208,7 @@ R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/rmap.h
+F:	mm/interval_tree.c
 F:	mm/page_vma_mapped.c
 F:	mm/rmap.c
 F:	tools/testing/selftests/mm/rmap.c
@@ -17313,7 +17314,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/trace/events/mmap.h
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c
-F:	mm/interval_tree.c
 F:	mm/mincore.c
 F:	mm/mlock.c
 F:	mm/mmap.c
-- 
2.54.0


