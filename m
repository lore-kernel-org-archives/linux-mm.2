Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2EC606A32C
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 16:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lVZ+sydb
Received: by kanga.kvack.org (Postfix)
	id 976076B05B3; Sun,  1 Nov 2026 11:35:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926A76B05B4; Sun,  1 Nov 2026 11:35:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83CDE6B05B5; Sun,  1 Nov 2026 11:35:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 466186B05B3
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 11:35:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF197C0A8F
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 16:35:33 +0000 (UTC)
X-FDA: 85387100946.17.AE7432F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0714640006
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 16:35:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lVZ+sydb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793550932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YpxeTkJB1bA2U9lceP4MrjPGCxxWE+eVAqMF4TwyDY8=;
	b=JidFlzJ1e0J2ymXzIUj/SYlbwl8mpK7kvQab2FDsMMd1iF9LSO/nNjH9DNgAKgvo/3F9SW
	Qqx10ayj8eXI4cjnspmxvg3rjBzVYaLjGljJBA2VuIUX6Kjt8ru49sK9p1YU5VHOfVVo+f
	cy+ZOAS5INDMbrE+/pr5x/z1L0sm3IM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lVZ+sydb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793550932;
	b=nRxS3IDQnLg3IH/XjciJV8HRg9yNMQwAHy0lx3mO7YXPRWblIccmq17fBhwDS/t/2yKAyg
	tn1kL7dxzUSQh22IRdjTXwbOdz6TCTzjRld4aDwVxNGMA7fSBNU6pXm9DufBQpLo9omlsV
	04dnqlk0bZOjv2Fq1G7GHHwChyB2zPI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 302AC60252;
	Sun,  1 Nov 2026 16:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D241F0093A;
	Sun,  1 Nov 2026 16:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793550930;
	bh=YpxeTkJB1bA2U9lceP4MrjPGCxxWE+eVAqMF4TwyDY8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lVZ+sydbX4IaalU9rxb8FWIjpvdImbXKLH5nmSn1TvKoHrCByGAdOlIHSgPGu0ujg
	 YWFdM9diqbkgFrSdYdbOKRMdULyhOXXNUGzpWXSeSeXA3uTJ5r+X2PEPdGcvmV9eCQ
	 JXinML6jFJpyK0fuE0V5q4UiEO2L6ovIsJKFc9VX1dTmSSxvsISoSgcvkU4gG+ruS/
	 RPqxN7J/Mi5WxoKltitvI9NDusqY6VaE4IjeUiAwnjI+63r4WGYSxLuIViegZyhki3
	 ecfoM+omSd71pWITyCEvJnoe+ROliHfGpBvENV4Oh0WhMVWUI7OA2A0rEBVJguwyy0
	 KP1sF/5V3O0/g==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Sun, 01 Nov 2026 17:34:49 +0100
Subject: [PATCH 2/2] MAINTAINERS: move SLAB ALLOCATOR under MEMORY
 MANAGEMENT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261101-maint-page_alloc-update-v1-2-27e8c246b13d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3248; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=Yj97FLTqxQQ/XjojdX3j7TfC2CQw8jz0GMpF5tBgTkk=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWQ9z3JaK9ifkLU39plOR/VDcS7ZZXvEBN1+v9f5zBETf
 MTkaIZ1J6M/CwMjB4OlmCJL9e4TjqIzlT2mefh+hBnEygQyRVqkgQEIWBj4chPzSo10jPRMtQ31
 DIEMHSMGLk4BmOpLJez/A+aL1+Tn+yxVDl0ty9N/l61VaFrm5tLMORNTJnAmi65ap/KCJWnPGoa
 DDZOfFwkIaj1RNa14GqZ5YHnf29U7YqxnBV639//Q5H7u4IE6l9dpjz6nxzCzHn198NIC/wdr5a
 UPr3LPFjHxnaZr+JJ71Zy9AfF9QVx7r+cd2N6l1uGldjrgwtyT56Ye1dvv6ae7wWLyBf3G24eeP
 0xoKJldnr6c9+07gXdtCyfevJGt81g0bxHLvz1XqlZOO2U++6x251M3ec6UglMXJ6dGx3kKSFs8
 q/n8r9w6xE9xteBG3h0ty7ec3L5Mrb5rJtPc12s4mkqFzi4TDDhyc83ktVI8/JrPAk7sSfRYpzn
 v6YeAfQA=
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Queue-Id: 0714640006
X-Rspam-User: 
X-Stat-Signature: 7mpyt4uhjr1hwynmumj9znf76owsenht
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793550931-419942
X-HE-Meta: U2FsdGVkX1+udalgqtOfUERn50p2cJvevOhxjc9dIJEuKSiTWlv98taSY8ockyGE68p2AnsN5FA2gvS1xc+Xvemzy62S4TGnZ+SdMxLIggSBEV+q7W+So0FUTvDnR8fss2wG3lrE69GWeGYcNLFPs/6ylm/UvYpMZnjmKJtFTVtj42V2947Y3cjmXv6aUi9exp2nSHExmNiyCZYpeFAOLw2jdVyR1TpvcxH0lskLElelbaE6PYBj0xvowkQd5FwfMUY+uO5faloWLERhYSScVBtTLsH2iC4mkEofmXRo8ac1tqx6zYEWaq/RWSb8lpR1Mc7mUyN/cA/SwVncSHqpCyE86bnIC4Z080D2XM0FqjmFb/zRarHLkH/gTC0YklZUEaoVHIHAojU96+UgYe3qeepSUv/u0mQ1EFP+ItFNfblL4Wxx86AP6KZu5IXmYG/JtFgE5yRSYT/A3ugrqEmUFFRHpWf6EpMaJD3BXSoRQc+7+pIvx3D/8NRq5JwKn2lzA5FHH0hG3YKMPBNjfwEONo3jtNatTeWCrTAa4bk3gJdHWVUxHUvnsCfltWU5VXdgRSmsaBQiBgHASOM4jXEUf/E7a8Js0vS6rnMwYaygWGjzMEb3BkI1cfc8LTUFVT4c9k3ASSmX8Uvd5F0fZyLSajDXuE2BNzbyAaTvcEUQ7sLrqSyRNBGZGsYem1agMjA1wUPuK44B59UyGDzA3VXSEFBZ4cY5ndjOMeseSwb64WYSc/pCpqR0W6nx5BQlevOjyn/I4ORKiRr7MmyNpPM8KRAuw6Cow4ecCBZu1VsboTpFJ3pxgbGWA+Ua65Jga1VvQ0Ie8iXiH32r6mbkeY6LMTEDE3KoIbRF3ObtojxMix3X0CeTtrEVxUz2V3aViJOjTJaeZq6JQS2ALcw1MfjLmtMbB0b+rq+uWqkhIbxzdu1mToRFqi/6ihdbAWBQpqdetBdW8YPChEGUxc4LLR0
 j3gERt82
 J39TXNmBEuaql9rFmsP0LCnwKuQ3nGfO98MkwEqQlf1t6udK7kewYD8St9neWHfwA07GqizmcIln68gXFznjkiCBDkGb0RUhSfoUP+rEIdi/XuBDPDXBxZz8BhcLX2WG9ZbNt1TnZ2TqdtMjHh37s2x+asRivUPnJbNMvDgG8oiY0OnIX6CWD31tTs3LWf3Rzk0cdKvqO2fElxUhkclzIJE9MCStTyZUXhjImnoJsk3HdkqKywyHugXw2PRLCoH33S23gGtnKqEaUIqfFL1P/FVgKKaPzsZD1EUmOEYLMXirSRoCuoxcuaAbnpwA4ytvQVl4p3qUqN9sOpI2kRjSwB6svapzMONbcOtez+EsTtgZ6RG20GS5aeG4qFh1vTw9azhqIcgzQhd97QD/wyzd820h9HkxifHjtN3meiMyWjL0ZQwLCJRRulztDRlRMJy9zHYr2Q7n3zYF/6sSE8msnWYNnw1xPcwTIpU0mKjC5NZXnwrEkRN6QUv8npwSgqnKqsotM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Following David's consolidation of several other MM subcomponents, do
the same for the slab allocator.

Rename the section to MEMORY MANAGEMENT - SLAB ALLOCATOR and move it to
remain in alphabetical order.

Remove Andrew as M: to signify he's not the primary person for picking
patches in this subcomponent. get_maintainers will continue CCing him on
most patches via the catch-all MM entry. David prefers not being added
for mail volume reasons.

Indicate the primary integration branch (slab/for-next) in the T: entry.
It will now be integrrated via the mm/linux integration tree.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 MAINTAINERS | 59 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d7cfb28a9029..e449ee3009ac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17815,6 +17815,35 @@ F:	mm/shmem_quota.c
 F:	tools/testing/selftests/memfd/
 F:	tools/testing/selftests/tmpfs/
 
+MEMORY MANAGEMENT - SLAB ALLOCATOR
+M:	Vlastimil Babka <vbabka@kernel.org>
+M:	Harry Yoo <harry@kernel.org>
+R:	Hao Li <hao.li@linux.dev>
+R:	Christoph Lameter <cl@gentwo.org>
+R:	David Rientjes <rientjes@google.com>
+R:	Roman Gushchin <roman.gushchin@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git slab/for-next
+F:	Documentation/ABI/testing/sysfs-kernel-slab
+F:	Documentation/admin-guide/mm/slab.rst
+F:	Documentation/mm/slab.rst
+F:	include/linux/mempool.h
+F:	include/linux/slab.h
+F:	include/trace/events/kmem.h
+F:	lib/tests/slub_kunit.c
+F:	mm/failslab.c
+F:	mm/mempool.c
+F:	mm/slab.h
+F:	mm/slab_common.c
+F:	mm/slub.c
+F:	scripts/gdb/linux/slab.py
+F:	tools/cgroup/memcg_slabinfo.py
+F:	tools/include/linux/slab.h
+F:	tools/lib/slab.c
+F:	tools/mm/slabinfo-gnuplot.sh
+F:	tools/mm/slabinfo.c
+
 MEMORY MANAGEMENT - SWAP
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Chris Li <chrisl@kernel.org>
@@ -25809,36 +25838,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
 F:	drivers/nvmem/layouts/sl28vpd.c
 
-SLAB ALLOCATOR
-M:	Vlastimil Babka <vbabka@kernel.org>
-M:	Harry Yoo <harry@kernel.org>
-M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Hao Li <hao.li@linux.dev>
-R:	Christoph Lameter <cl@gentwo.org>
-R:	David Rientjes <rientjes@google.com>
-R:	Roman Gushchin <roman.gushchin@linux.dev>
-L:	linux-mm@kvack.org
-S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git
-F:	Documentation/ABI/testing/sysfs-kernel-slab
-F:	Documentation/admin-guide/mm/slab.rst
-F:	Documentation/mm/slab.rst
-F:	include/linux/mempool.h
-F:	include/linux/slab.h
-F:	include/trace/events/kmem.h
-F:	lib/tests/slub_kunit.c
-F:	mm/failslab.c
-F:	mm/mempool.c
-F:	mm/slab.h
-F:	mm/slab_common.c
-F:	mm/slub.c
-F:	scripts/gdb/linux/slab.py
-F:	tools/cgroup/memcg_slabinfo.py
-F:	tools/include/linux/slab.h
-F:	tools/lib/slab.c
-F:	tools/mm/slabinfo-gnuplot.sh
-F:	tools/mm/slabinfo.c
-
 SLCAN CAN NETWORK DRIVER
 M:	Dario Binacchi <dario.binacchi@amarulasolutions.com>
 L:	linux-can@vger.kernel.org

-- 
2.56.0


