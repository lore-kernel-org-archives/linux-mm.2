Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BB8C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3056B008C; Thu, 17 Sep 2026 10:39:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D92276B009D; Thu, 17 Sep 2026 10:39:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF4E6B009E; Thu, 17 Sep 2026 10:39:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7BFA6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:39:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E1101A034E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:39:03 +0000 (UTC)
X-FDA: 85223511366.04.0990EB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E6ADD14000E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:39:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CR5jnixh;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789655941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lHHjKoaSq2HBbTkAbPc3XRp+rX0Hl+xsP4u5uRKYsz8=;
	b=SG8IROXFc/lGQOTUc1yPWkU8oRksehkr7bYJ3OSBR8DPT3apXaDTQ6K4c+K+u38X0S5YZk
	MR99EpSsJrfJalOhHE0vs/r5JhnQQybw4zC/7XWe3x6FfWtBcwHSVhyK3NYP1URA8s2MVz
	cCA4mE6OBnasnS89wmunsp0twcIhGR4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CR5jnixh;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789655941;
	b=WTUFlIO2SOGm/QWeAEd7bxVAGhAJQFxGeavwlXGZUmoUVJ1J81y8NqVNeY4FmcCjlhq/5G
	d7M9fPoxxTuVrlS5YqzryYARc259EO3Kytp2gevDh938+TwQuilmLuEtCjfuK/O44m7hJm
	mvlFfkgxfu779ncK/3O6qXYm+ZkJsIQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7BA4660204;
	Thu, 17 Sep 2026 14:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01931F000FF;
	Thu, 17 Sep 2026 14:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789655941;
	bh=lHHjKoaSq2HBbTkAbPc3XRp+rX0Hl+xsP4u5uRKYsz8=;
	h=From:Date:Subject:To:Cc;
	b=CR5jnixhvVW0se6uYO+n+x2GwSIu0n/GIaOJF+mTfqkmcPVcd+rLF69JIu7HY3B18
	 RIVaNvCXQgmOG0Mec4NQByb7wNDy8WcGyn9U1C6RB4VLAQH50tPX+yuz/alyvFQL3+
	 UCB0uy6+zddIOLZxjafgGfSyeRQV4CnMpxeHxIvpQHsTWACfduaM1o8Q7dGLjBFF7n
	 RhyH3WfowaQvA0jpG4gbDQ+fLk24fbkdEBcbtgNqobkOwgUz8IzQeZpBh4izWI2E8X
	 PKvGy/emMi6AjVmthPZVdWB4AByMib+yTQX0eHrPPH+lievwYFGgCO6L+XuPcKZZ8N
	 pTw5py5FOnrhA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 17 Sep 2026 16:38:37 +0200
Subject: [PATCH slab/for-next-fixes] MAINTAINERS: update slab.git URL
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-maint-slab-git-v1-1-d21a5210aec9@kernel.org>
X-B4-Tracking: v=1; b=H4sIAGz7q2oC/yWMQQqDMBBFryKz7lATidJepbiIcaJT2lgyUQTx7
 sa6fJ/33wZCkUngWWwQaWHhKWRQtwLcaMNAyH1m0KWuy4dq8Gs5JJSP7XDghEYp5ypTV0Z7yKd
 fJM/rP/iC07r7KWKgNeG1t5ckc/cml8407PsB1vpVC4cAAAA=
X-Change-ID: 20260917-maint-slab-git-511cc356352f
To: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1085; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=JaFCtyi9VkweTcGW28w5rCbbcG6JSGToPKStPEdMDG4=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWSt/l2/3vTwzJD1Eo9UVRXqdi50PdXG3xWekujqtfTa+
 QnzTj907mT0Z2Fg5GCwFFNkqd59wlF0prLHNA/fjzCDWJlApkiLNDAAAQsDX25iXqmRjpGeqbah
 niGQoWPEwMUpAFM9TZWDYeL68CqZL8vFD3ioyjx7u8cq9v7rl8pTTL8tOH9QMWj6hG2uT94mThL
 SiwnonjXdP/7dEeuydY9eJtrfNHPqdbo/qeRp3KRDfCwlO3Pe9td/c6/t2VNbw1W1d43I51sPep
 LTb8z+cJOps6rRzaFx8+/NjqqhaXzP+zf3rlR51KHfcE9B5vGnLpnGVbonf2nKbiyNqX6Z+1+o9
 oKetOZZMfctzn8+S1jVTj1sspnzezXrpj37JnvkNorUNe2frRphKiMscHHGasa76ZI+Vyy27O/k
 7koTvJ3xZu75zB+ma+MEep7d3P+av8GicIteh8DVsMVBEwTqlSW0pl3yuHvJ/0P2ip3v9dlO73U
 9GxDJBwA=
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspam-User: 
X-Stat-Signature: rujebmig9xcumhh4bxqiudkb59opytis
X-Rspamd-Queue-Id: E6ADD14000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1789655941-114621
X-HE-Meta: U2FsdGVkX18JI+jPEPWNA9UoZcq+M6BHE1uj6pDFPq05Q/GC7fxGXWjqTcbSgb+NOUn+ZCs+wVAPaJI4cz2e0BJTOQnR6UxXvEvRmMcLvslPEGXGAreW2eeDOl7w0nVt7RykdgMFQvfmHg4wyINndyI/3HsYtZIDqjzX0OyuOwN4CINoCfzyK7HIeqOMYZBEQs2gXZuzzNknRLKE199y72fWiryI/Rx+x52jSE/tzXbQ9xTxG6ecdLmFcH97tkawyRnekPi2z+Q5nlBvh4VJHfEV3W4yu9/LbDQpSIC2nnTpGwpeK+0TOfBxL4aZ4cEv9Cz4JRyqyfOfXwZyfpT0tGGREnNkwpjr6162S4dZTs3HnsijN5zCrzgMx0NkWXaT5XNL4+SA2SzV5rLO6ZosaR4UNP0NQRtm+sijm3rI39YqJqgC/C6ckZAaYvSNe6GanCMdW+rolfbHpMGAIvvSB0m5il65uQB631LJ/Mb9qnYY79m3dQwBon4mSOipitcR7oPtQP/RnMB3lvs6e+kZ0OjgG8fme6GlkTkXaGq98nTts8LWus3phIj/kzybcawSKYq4Gz5CGH7m0OyDp5AFymbgJ0ufnC8jkf8QytocqJc6QrnCiuDF876/anI/ljJVVMeJ4/uudayShActvLI5D/haIhFF4BAF74I0M9Oxz+JH+NVsiWtVjLtk2HaBFyfhK6IKC9dlnzH24tROXKN20c6HZdeRvu46DDutpwpDxSjOWd4kHUG6v0y7FGUo9gChWfUkyiS2Boy6t3MOVtWEpKEq96/hES+3v5fR8Jgi9vjc5HZ6Mrhl8UDQV/AmqkOXhw6bpCqlQllSVdh68Dd5MQ7X+KH9wANsOIElnOfh7s16p+791Mrop/DNVVjkZSKvdjnJutSLhqpprAGHgwds6ddVYhOQM0/7sROeFPHPaF8lDChuyIImQSk8CL8hG0koJgCDel6zl39sdNQMvg7
 dpSDQC/b
 nz19Hh8lYASjsSh4sf2O/0rXOrm1TUr8pCmYWk0pTNEllVClajcsaQ8XUrGnk24Kv0657v1+xPQqNQ7V7qo5AM7oZ6acQUxvB8srrEuoRpLTi9jkYRpc52HN9N/yxpPneH7Ov3bTYKCW2h4joWZ4yacUC8XE7+hfRXJJ/2UqML4LqvK4y5f7mxSXSB5IYL4PNRuonnz/fjiR5A5z57AA65nl+R/ryCSY+oqSctUCqTdhlA2mR525OQJ7rbvUrnsGlAmSQN7Jgh1a+WyAFz5DfGW2q3FJcqEHPVrRiSlz3n2BSonP+iKWqDqaEmOlA/CWz8WTz1RByFrzV50M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The slab.git tree has been moved to a new URL as part of the mm-next
integration. Reflect this in MAINTAINERS as well. The old URL will stay
around with historical branches and tags.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Since Harry as a co-maintainer now also has RW access to the new tree,
we agreed that he would apply this patch to test the access.
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a19da74d00c..f9c1aa1df9b9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25186,7 +25186,7 @@ R:	David Rientjes <rientjes@google.com>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git
 F:	Documentation/admin-guide/mm/slab.rst
 F:	Documentation/mm/slab.rst
 F:	include/linux/mempool.h

---
base-commit: 4a724bcf5d703e18957397914d79156fa2cf1174
change-id: 20260917-maint-slab-git-511cc356352f


