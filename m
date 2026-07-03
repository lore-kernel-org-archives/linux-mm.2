Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E70CEC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E005A6B00C9; Fri,  3 Jul 2026 08:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89E26B00CA; Fri,  3 Jul 2026 08:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA07E6B00CB; Fri,  3 Jul 2026 08:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99BB56B00C9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27C0E1404BB
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:38 +0000 (UTC)
X-FDA: 84947403996.26.88DAEC1
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7D74940009
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h+1d63JS;
	spf=pass (imf12.hostedemail.com: domain of 34qtHaggKCLEaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=34qtHaggKCLEaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081956;
	b=JWr6l6MgJwCOFBM3gD7c1pGpHaEE6OzHdjdeOgoxmKrQm2CjYy6iSJdbnH9JuXk8gfPMMl
	MQry83qSTP7GZd2q3HAM37TnlHgsmI1bGcRScCU2sq3Uw8ZHj8QDmC0C/70I4TG6+x2HZb
	+nObSrTHnsGfkl8LWW56xRC0phaVG34=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrjGnXdjo/8AidhzqQZNVSKN71a7xjQgfBXFiB4gebQ=;
	b=LMo7e7QlfkhSWhkNjRGzBPohKnO7uRNOkG5oErLOUsh64FjYlOxXEcTn/s0pmSIuB+uLJJ
	JNSWxMdGEdTwdkdX9SF6pyYd6L+w6VYcmZbjDON7+y/+6nC3Z2ysj6NVVmQ/8FhVm2kAIP
	iZzSVdf6saau2vFZOh/qOoM5m2nMouY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h+1d63JS;
	spf=pass (imf12.hostedemail.com: domain of 34qtHaggKCLEaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=34qtHaggKCLEaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c125bdd01cbso63260766b.0
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081955; x=1783686755; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yrjGnXdjo/8AidhzqQZNVSKN71a7xjQgfBXFiB4gebQ=;
        b=h+1d63JSKTYyolovid3u3gwMOx85Vcb10CkTyFaXs7kUY7iAV0sRaBTNPvQuOQXuyQ
         J0dMcOSOuGOavWEruSB4rveQgKkGkd1k2W06U3sVVdw2h9P6tdOrWgtOMRF3rvTTy++K
         fG8aLw72uT8FF1ArpHIiT7YGFoIm98bH2lQthFxmzkqQazEhiOWGyaPKCikEi4gDIuJt
         nWRteoQitIH+YPxWs4UbJ2NwxrvVZ1O+W6f1XzBEiqOwcz/Odlsz2biQ6WudJtOnq822
         zVS1itHE6AHMS2G9O62xl9LHoVMaf8CDx4lHNGrlyIMKpnZ9H+4OFIE7b/Opui664kjY
         Z6Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081955; x=1783686755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yrjGnXdjo/8AidhzqQZNVSKN71a7xjQgfBXFiB4gebQ=;
        b=j1TUwf6H4M3lQWNVN0CZL7W+LEGWKRC3ftfZ12kD2F7HHzc+5FLN0Z1Ql7m2jirxwN
         lwpaO7mBzdmfBIBEB0jvL4htVsa5KMYcwMCbiPPxrGoaAiPkss/PWW/zQUOSRnJNYJPP
         ATCox9d3Dz7zdWu4bqQmIOL2gx6b+U1Av4cs0O/+z7kgue9AAWprMHkEPvIeuvNjM+jT
         fhRdMpbLm/p4/NsL5zpgFg5kMoZkUnAbKiDxoCkp4vr8CkMQfmm6H0fTKMwozbCGuuZS
         FhR9618dqWi8Yndt4v6McPpLCo1xDZbJiPqHplHtxoC1qAsHNU02xm8mu2I0NG1RU001
         1tFw==
X-Forwarded-Encrypted: i=1; AHgh+RqnVwM5HfHTrT7h/qK1/gLV20bSgqXophXB0QDAySTVwxLf1oL9Gbr0Qwmphyx2yVkyGqEV9OCSmg==@kvack.org
X-Gm-Message-State: AOJu0YyL6Kg8j1NUPLUiNK1KD3AZt2sU5QDnsclnYVs3bo4BuZELBK1X
	YmV2D8VUpA2AWT49AX8UpS6bruiVEpylnvlb9bgZ7YadqIs7SnZVfTTTSvPxj4xRlmWFDL/Z9mH
	zEjVltro53ph9lw==
X-Received: from ejbc12.prod.google.com ([2002:a17:906:340c:b0:c12:dc59:3d56])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c1e:b0:c12:d971:1c2d with SMTP id a640c23a62f3a-c12d97142d4mr91013266b.59.1783081954713;
 Fri, 03 Jul 2026 05:32:34 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:52 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-12-c87b714e19d3@google.com>
Subject: [PATCH v5 12/18] net/funeth: Switch to higher-level allocator API
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>, Dimitris Michailidis <dmichail@fungible.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7D74940009
X-Rspam-User: 
X-Stat-Signature: 6fnb5fm5eb4kmfkjzh6w817gjbu5ksn4
X-HE-Tag: 1783081956-196787
X-HE-Meta: U2FsdGVkX1/YBPWOqm2QidaJZdMQltEXyvo98Vh9ccq9mIh8/SeUHJKEo5KsikrrZ4NCHBRaEn36Q2vmN9Pb9XzaAEUYJM0Ig3YsJYESkk5NmKcFiyGoQbiKk5+WgJGkAFkt5yzpx4cvsL6I1B+qX97eM5mrdDb7NTV0dKfn36UlJW2uxM5G/YSbOhuoa5LtTULUGG4Mm1XXLUnOXm7Hhl7KGzWfn7zJgW+x1Q17vzOREEfWqdiTM1S2gQfZoY90j2Pwhvc2j8x3YTJB7yLjV/iD1urXhkm/pPvK97p0X1M3fda4bjgUYkbFHDR+7wk4yJ48DOLfjE8sTmN3c4+pXU8TeAj26X6v5AiaAsI2oHce40k7xI+a69A/8Mk4tz5Olo7ekQyqcGBARdz0CobdMmepwoNzXzjKxdenNhDRKy9pFaZn0f74YchJNF+Gc442dxcG//LFwwaVfkwrx0fuNq5x1GpCZVa9Tn+HzLGb8YRZ85eBpw7iUrhpz5R+KrFpWUf3L/Ao2B9hRAV+vuRnia3/z+3Wu0zeyZb0BzYyfqZeOtLm4cW28TMhXtQMXZpVGSwjTBWri0HfjNXTz9IlV6kL4/H/dxeXTEmDQvMXG09QdWzZsJLhwO26w4QiW9pwQ8wK7YKJxSfv8yxQhBWm+CEBd9iYIWTdOJYFumFyrCsGIDnLNm9x+GZWLKKS9tCQ1O25gno87VGlUN3GhdpXyxIIrVZ+q8hVnjfEr/ReAY1VKWVeBEr+8518gHlmdhF2nMOYA1Zd8oirKdD1FkXG7KwwArV+LOQT6qXYEFqFIEC0O3dW7kfMGvNG9U7d8EvFcSYYLas5XBy0gI03hidbi/RCG/eqilQtk6rSgYA7Jd2s/puAlOfKS55rvUiLKv+DVyfR8BJmLAJ+cAXQsaY0wQg6qLayf3ZmdIdJjvUe/DY/Q0yL8RUAi/gUur6ykIdamX/tN7JlJySUUrbbh9x
 thyy5sR9
 y5oCIBzXTpPxmV8VwiX3hJCqDUzVNwaWbyFVI34K+gjGHX9M5xd8oqOg0QSF8oaoEf5spEGLuBdd3NeIb4DiPCiOW8Otfqi4XP9df6caxQZr6h6x5CTRX+/LM+ATSubxLSJS6BVXh8RplnUG/jIKa/wwfvbLTQ3BzYG34W1GM1+d6WdslHecyWueCr78mZFQV1MR1qVHB9Q6MVJq1DaV0/THG9wf14X3zQlS8CzIw8YWayRXnJNarb5ZWeuka01f4txUVYZXVUddnKAoIZHVjzP+lZhW1CMe3IExMlijeg70INVosr1ZTxvnxmKxC8sIZRMuOljcI+URlLDl7+T0BcICvEwI54HqXVcv1FCBPt6IWDRgmwpfkX3Ru9f5P/PXdhD9A1SINEaTjkmrSiLTdu6S+yXIP9hX8Ic/+laV/jonv8nkTNUl6CSrTsmnk/V8NHdhs8mSKpqR1lvQQh4tKqHVPWJkVtVHwdJWXktks7r9Sw3t6o6aARRb6M6iwqdxfNqw9M6MWzS/CBSEU2RlpI7eux/Z5fT9pGuNJrDb8+ouwQmTFq0sVEyjVGVk09KFNAY9YF2uvkHVdaqXJt9p3uOJgjUEOWKbJ8+HxGMsYy5DBY20Z74GGcO3iIhJ2scW5oYY82Krjkldt8He/++ItvhiJL4AEYQWsnaI+78049dSdLebCeFK4eKwfXzL3G34rYow+cyLKKR3Xr97n94f3m207ZbPRDuoFipY7LqnhuiRcUiuBDejhcXa982P9pSlbYpnVZcKBE10Jwudc9YATIi5H6ocoxWql9O0nDUoLEhBYx/vw/H0nmimz4cU+gUrExi4jDzpU01YTGgC7u3N1ExFA7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The difference between __alloc_pages_node() and alloc_pages_node() is
that the latter allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

No functional change intended.

Cc: Dimitris Michailidis <dmichail@fungible.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Assisted-by: Gemini:unknown-version
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 drivers/net/ethernet/fungible/funeth/funeth_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_rx.c b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
index 7e2584895de39..d7000017ac2bd 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_rx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
@@ -103,7 +103,7 @@ static int funeth_alloc_page(struct funeth_rxq *q, struct funeth_rxbuf *rb,
 	if (cache_get(q, rb))
 		return 0;
 
-	p = __alloc_pages_node(node, gfp | __GFP_NOWARN, 0);
+	p = alloc_pages_node(node, gfp | __GFP_NOWARN, 0);
 	if (unlikely(!p))
 		return -ENOMEM;
 

-- 
2.54.0


