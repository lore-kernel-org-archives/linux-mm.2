Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBEDC606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 16:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MW7y6eVm
Received: by kanga.kvack.org (Postfix)
	id E09F06B05B1; Sun,  1 Nov 2026 11:35:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE18E6B05B2; Sun,  1 Nov 2026 11:35:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0516B05B3; Sun,  1 Nov 2026 11:35:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB7C26B05B1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 11:35:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA4E51209D5
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 16:35:28 +0000 (UTC)
X-FDA: 85387100736.18.A906169
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id ED5BD20005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 16:35:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MW7y6eVm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793550927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3x8oCRFRszEq/Mgj7LYVJrisRBnIHOK0MAHeiUidi/U=;
	b=Ir/+NoIWGvKnzsXjZbuPTtPyu/PDfBdear5cOOt8jTowXbJdBJBBqJva2iBFzmCBvLbrYd
	4DmIi//tvvUTY+Wpsj5SsDJ0N0c1TrXaAPuJkajOFPK3ZxK8k+Vfz/b2F10PE94PjVE0Bs
	q6OoZPF6+7U0CSdFFCG90r3wOzgyKaQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MW7y6eVm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793550927;
	b=rmnKbo0HlW0ZMalIteAiNFxjbiPGCmas+Z5AfcarSpeuOROwhmrDZbIk/sX9Ov5KKeznIL
	1gKG7NKprqdLcbnAlHbX7sTRFH+MeN/pHStocKwX2k207ojw9KkgyqvdFeAFyVkgQs1m+Q
	9ZXCLMMhdpcvzr3v9isUqFtYHkO7+Dw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4379843F86;
	Sun,  1 Nov 2026 16:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2021F00919;
	Sun,  1 Nov 2026 16:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793550926;
	bh=3x8oCRFRszEq/Mgj7LYVJrisRBnIHOK0MAHeiUidi/U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MW7y6eVmJ/5BQ2b6bdHTHfO68F/8BO7ev4sibK7Mfs8jCUEbSemQgDc0mTspF1mJ/
	 7KP20anDE+Z6Nnl+9gkUVS8XzZmSPrnVA2gYhl8TCBEjhMZHKs+drq1mv6MLeYQQhC
	 j2XRX/q/tFJBpSbjLhwU8y5Tf8stdsxQ44Rn/F4GdEXqq6dSR0E0HdkG9Tv0Sge/E/
	 LUciTRMA9J9ZXmWpIkcF9RhokZd5R1s+sB4IywUSGEbnEiiG7RHG12AkBNuw8ho4wZ
	 fkUPTJFIF92M3wRHhfVn5z+8Oao4mvUQCZhfnStstzluEa/X7qYIEtGSQK+ENp6hpT
	 O9BKIGXuxrdRA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Sun, 01 Nov 2026 17:34:48 +0100
Subject: [PATCH 1/2] MAINTAINERS: add Johannes as the page allocator
 co-maintainer
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org>
References: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
In-Reply-To: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1599; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=ZGfKSf7whFZ9UN/85d/sfF5g2ZOOiNMW9NElTJJp5oA=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWQ9z7KXP2x4Sv6Snu8ln4zbZ07XXS/oevDk1K8LqyIeP
 2J8o6VT3snoz8LAyMFgKabIUr37hKPoTGWPaR6+H2EGsTKBTJEWaWAAAhYGvtzEvFIjHSM9U21D
 PUMgQ8eIgYtTAKY6ei/7//QGvquMAmxXX/tsZhS4bLVxBetFQ6/PR1utO6em8zRY3F+83DemNfD
 c/AM+j1a/F8j+yiZpZLpGasPBo0Fbz19p6Xs0u+KNctctpayFJ1k2cdlqxK1OLw6rfTdN4V/Lug
 tTi+UfTiid6Ciylrl0nrn3nyod2XNPn2YcP1qxxcRXwkXusKCGX+A5yWgtba2+VVNiA5uNt/d7p
 9l5PtwwY/0M02qf2H/e+1/NKjD9x8y5ZPXXH8J1Z+bLXJ69Snfzh8ut9/LfxB5v7px3P+vIutcG
 oRHFDoG/re3af5T9+bfJOWD+pYlFarftuNmeu22PrRXkySk9F+XGdekWX/3n/pXdv+694Kvuco3
 okDYWAAA=
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Queue-Id: ED5BD20005
X-Stat-Signature: kgsbgx64xb9paf9zs8w65xahy9ifdtix
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793550926-782660
X-HE-Meta: U2FsdGVkX19BOp+QP1BK5ECiuOCeZHWHFU9dH2z2Avf8elp3oBCXG1xVOw631EQU3bP+fkjy5wIfj3PpTF2lxMfcrtglPNZeL8r0a/UYsBnSQW0piyZLIZ7EU6el+8V9STdmwSSPQcfGx7eSVpg4xyzIuax+uxKK5QwqcUpZJdT2uympoe2qp4WnPQXJXNtjp/xCwC3OvCfH3xH7+K5/YLxgqJxzkz5eok2os+hnn07IZbsmGlvvglwpDedXYo1I3RZazsvxWz2Sr71viEPG0Rx5KS56aMVsVK1O2HjAM2UJBQ90MoC7nyj/Troacbb1EWE1WVZ7F/RTtCvHFu58Q19+ncOg/7v8XRQWzlMy2mQgrO/lSBZD2UZoWxM8xvBuXeDPIaGFUY2ko10dWjkG8wsC4k2qHf0iswF8/rt9hON148mDYhrkasJD1cGpcW7uBtQi8GuL3mnjFXud4le7O7RNE8nVKBL6gCNARA7TccahtWnVmaDFgqQHA2ZradLgGCsACoxadUIKisN4wcXVsmJztDA67xeLDyE97hqoDLPVYJ41wdpHO3KjrIi8ilEMDsT8YS90nZutgh2+/Mo6RD67CNLCyEKxZgmOLG0MNiKeB8Su06vngnGKydQlbw10e7c0PUXdYKCv3Hxw4MO9nunhbmnqzt+BnC5QfBs+iwJ3eY7Sf9sdGAgjdX1BtOEpURMmNQ3pdQY4QT7kfQbzrYdPIvsCgOxFH4kpfH5i0KbjXHtgMOdVhOxQuT3Cby2EuPdQLBeVpIgvJEm8UtWwzbT1NxSVliymaAkdgT5Uv1RaS9t/rviuvAxPBIJ5wAtSG0JaCjAiAD9cUeOSE6oyBMigAlPhqz7Vv2EhhDl8VzENagmI7arkXs9zb3vUfoEOaCGDIBeTeuzXNV+7xzbR1qGBNruE5JUSdimq27ZoSDH3ypZnoY4rhzI7CGwb7OCS3SZVpZqyLa23XsR7/1+
 0jO+WsNm
 khydnLNBbQGsyMm34r+EeYtfkPukmkQKQfo7Pk13hliPG1Wagt7xCMzLPj/+6E2C2dwBxZOe53d2rdmuTnJF0X1DWNp3fgR6fcJReUa+yGiwkdGu+U2rPgSBuacokbKDVgB8G0KZ/pBeL6t7pGyggB2XvguE2yZziEyCYIlR4HjsgK4gM0KWCalpLIiSdElMEj4XQJxKiJd74WzYVJZSNddFZD3Yr4U1ZjLV98N8NWh+WfqeUbKZPMvi0b0jqIWwA7rVcpM+B6xfs2hkDOdngVfGwJV0VQvCO00frI7f6sHMYX6IarwefSKohVo2cdh9J/11Cu8g3jSIOqC/pCHy4Wq5G2rnF+dTpMi0tOcvJO+bAH+LEzzJmO8h35bbh5gpqXkGjWlJim69Cs2ztYODIkdI/YY4+6RnFX8AdZ25M1AbSDJhTOI4ZoU5wfN904b1ZnbD3Kmvk5hJWyaDULrjr/sIdpQcsGH9/MYugCg8BUiW0H9g3q//Vpn+MlZm95n1rE6XxRMqcmWgnF/6BVpCbhklA7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Johannes is a long-time expert and reviewer for the page allocator and
has agreed to step up to a co-maintainer role, so do that. Thanks!

Additionally, page allocator is joining the MM transition, following the
MM core updates from David [1].

Patches will be collected in the mm/page_alloc git tree and integrated
via the mm/linux integration tree. To signify the change from Andrew's
mm tree, remove Andrew as M: - get_maintainers will continue CCing him
on most patches via the catch-all MM entry. David prefers not being
added for mail volume reasons.

[1] https://lore.kernel.org/all/20261030-maintainers-v1-7-97278f8a5f54@kernel.org/

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b68bc3626709..d7cfb28a9029 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17720,15 +17720,15 @@ F:	include/uapi/linux/oom.h
 F:	mm/oom_kill.c
 
 MEMORY MANAGEMENT - PAGE ALLOCATOR
-M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Vlastimil Babka <vbabka@kernel.org>
+M:	Johannes Weiner <hannes@cmpxchg.org>
 R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 R:	Brendan Jackman <brendan.jackman@linux.dev>
-R:	Johannes Weiner <hannes@cmpxchg.org>
 R:	Zi Yan <ziy@nvidia.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/page_alloc.git page_alloc/for-next
 F:	include/linux/compaction.h
 F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h

-- 
2.56.0


