Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D938DC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4E7C6B00C7; Fri,  3 Jul 2026 08:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB17B6B00C8; Fri,  3 Jul 2026 08:32:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0596B00C9; Fri,  3 Jul 2026 08:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A491B6B00C7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE8B81669D1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:36 +0000 (UTC)
X-FDA: 84947403912.01.1E96390
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3913840003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iWA+eiZz;
	spf=pass (imf17.hostedemail.com: domain of 34atHaggKCLAZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=34atHaggKCLAZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081955;
	b=vNbIKweqaDKEjBxXT/RCbnEQ9hUQ/6qGjKG9Ft10IwlF6crTDoC6DrNCUoyNH2Nz/1pN1+
	EACUC9Nta/++kTmFNwE23DoBGFXT/QJFNCl0BjE6sfQy9l60iONc0DTh65sqXc3ke2OgAi
	56DoUdoy4gpjpkykWKvSCJtQDZlGFxU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oi2WdNtyn6OBAE6+L/wDlXe84IAgE1icOUsCwlXzl0o=;
	b=M5DgBMhw7Cd8m6z+B7+fMqx0wtguwOh8ZD4PVYibUlkX/bIfwb4y7JKBacDKCvvju5FNvB
	b6qHf981BFnb9yqZNUSjbCf3XFvcBYkFOfORPVz15OpRm+wc7xWhGnwwgq/X7MKL7zy9P/
	KM375wbRGKhk+P/+OPiGVChPnak+3lc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iWA+eiZz;
	spf=pass (imf17.hostedemail.com: domain of 34atHaggKCLAZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=34atHaggKCLAZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c11f2b9f62fso47181566b.2
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081954; x=1783686754; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oi2WdNtyn6OBAE6+L/wDlXe84IAgE1icOUsCwlXzl0o=;
        b=iWA+eiZzkgK2H5bE2cTIm1mwF/ql3we6iUJCP1v7hV9JysCLVrw57otugHMn8Dt5Yt
         H5NjOVF3wtwJx9ZGdcLFzM0Mu7A9TTB06QIEJ1qssIvmTpoPCpHw3Gy3dPUij6btgljp
         FtBpR2bl9cRUQPhlBdp/KM+oAjyd50zDtVrU9YPrbIkqIRntlm7uqzKvQGqbiuSoH41E
         sAb17un4s3hWK07l3tnc4JvJwV7RIxM2F7Ap+hziu11wXW+xgW+X/ik6eIyjo18KvBTl
         DBiZ4ylKJ24LKBRW3HuyZ5v9ddA41BhYsWkcgXEsvF4s3xYYIIXU1VHTHBpH/5C5kJ3Z
         oJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081954; x=1783686754;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oi2WdNtyn6OBAE6+L/wDlXe84IAgE1icOUsCwlXzl0o=;
        b=rjehIV6k2uxb/Of+7g1tKrq8E5fcb5hJvFc69AOC5U0xuGw4qk4T0apKrykPdAv0wv
         +bwdpV1nz8rzS2uJgV2eiGTAS2cgshvlk9Zk44YDZDuuY2GMbbPxak0m1SiqQH/b3hMD
         tS5F2e6S10FksqSnWFK52wl9tbghr/fkUfZ7lklM8RD6FG8ebTcg0wq7DqQnf3RuBl1O
         pdxTf6tGD3KAGXfqTvvCBCpqaNCiFI4I7nkAOWvzY9926ri7tmSlU+illwyPgCZ61zxa
         3NRxUXcbR7xvzTjYPGD9JXGqAJQDbTvbzwHCaLkMo1n8Zty6V78ARALblxjnGugv5AMO
         l4Jw==
X-Forwarded-Encrypted: i=1; AHgh+RrvF9Nsi1zRs98WyUOiIYdzNI9HOjvilP89Fl3D322EbnI5TQiLPrwJER67BXqZWPajpsWXNHxO3A==@kvack.org
X-Gm-Message-State: AOJu0YzHpqdurnf0IdhCx1O4S/DSh8eyzNCHNEGyEcyCij86O5iuXVsL
	iTtvtPJftZ/JHFwJAdxah8SqL309+4+RoVIP9tgP2vnvomOxBnkgZyVZzPfZOqngn/ttq/gEX0O
	9gZxw3Mo6GCFYfQ==
X-Received: from ejbqk13.prod.google.com ([2002:a17:906:d9cd:b0:c12:75b1:2e99])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:22d6:b0:bd5:151d:2d31 with SMTP id a640c23a62f3a-c12ae45e66fmr436553266b.13.1783081953398;
 Fri, 03 Jul 2026 05:32:33 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:51 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-11-c87b714e19d3@google.com>
Subject: [PATCH v5 11/18] sgi-xp: Use higher-level allocator API
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
	Yosry Ahmed <yosry@kernel.org>, Robin Holt <robinmholt@gmail.com>, Steve Wahl <steve.wahl@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: xuuiecxfyfkoqgxuhfngtpmwb1b8w55u
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3913840003
X-HE-Tag: 1783081955-619584
X-HE-Meta: U2FsdGVkX18t+HfIeWTkoWu/lImD2RiFWAfiYO/NJVTNkWxd9VLTAW+2zHxkjnEWHxDkocv5er9B0sVuflUq8zCx8gsQkbExNYw1CjNf4s56LWl1ugR+shCyUHsnJ1YynLkfr4mETf/BvICyonJ86MK80qWUWuNXBJyP4Eobojx4wMG24wA93r/DgVLbpc4SAwS6XQCxrDt+yz+n67i+QifTEi4t6fFCQoVm+TGmP+Ye3m5hoNgKYLrw/9w7d0K/Rs/YEVXUd03kuQHgk9flWMWg6/v7mUakHbPohHYLMJWr/MIwqZLTOlwQPj3nPDER2jF5SO7TC4ZCIOg6nal0/XgIN98fHF7JCpudwAqPhS144vXnlW1wWrkcCys7ssF1hiMnp86w7a12FPEA5sF6wc4DRRqj84psjhuEb8hhW0r+tpQtaRdW70Yi5wagmeVYkHz1pGUDSE3loeQmEi2WcopC/nZTUpT8FZ2p2bY0RnWkS0YQwdJD+B4+GNJpTlOgBQjtoZOZcFqiqiWXxCaZU28luyDIlRNbbWAbruzDSb2n65IDVQvRfUI7Tizu3b6peF1k0tJK5oAaNHwvEXWYW7MFl3I327CmIXrmjdcxh+y5P2/1RfIrk/LmSDvpmAQ3P9U9jvJzWYInq5r3Mz5ilK9kAsieTjTYdFi5PS2IQXZgUydFI6fUvPokWVYd7HEJG0sgyTAhN5E/ZMkut9dDpELOiYr0Ed9U0mObFMc9qQO8FuZBK5vy4K+8+pDxBtPSD0FuurQ4u2UTS7Nua+ItifVWqgi43I8KWKhznHBx0PV0AcqvjV6hoR6gL96K+Xo7YSEmyjgjaDkPMHHaG95Nl0EEFwL7DVKZELxTa4L8LneLMF6uNeSLTogh4D4Ban+Crlt2xUQ5w2Ab24edxofjl8/V18ooFIFmef4zdE6/muRczHfYT+/yEC0F1eM+QasIzaOAk6zJXSxnRekrN4q
 zWfqAAKd
 +KHzZUfDdC4qknMUWjS/0wBGxWMBdRJ35/dE91otUIt0R5reN9omQft9Kpi5RDXuPE7+5GhUpdnbV2GrNyfMnFH2dX9aU3WAR8ddkTdLbCoA6oM5IiNatjpF6Gc3tvoe4jxMBwpg9dymh9uqPSD5GU/3SGzWA/jLaZYqGmbBShAefTtQ7LQ2XltEMOIjPFAE1fHA2EnqN+8BouNoRKuZr3rchZLepokmu6xUjjWfmh0p9PdVqhugoPVpYVctK/vV0I1ofvxQe6MsblmHpEelMyiC4nlCVcVrrzdL3SxOvm/wVy/7mo2kfTYYJl6WQSjHGHCs7cTMZ7hIK8kry9NZfjNInpDlLEY0ArXQ7jXeqVxZYHio5ThXjlHWxMxOACm59xD9uBeK7WhiPRSij556cMqkBl+4LK93AW/PN0q6Jx5yS/v4sHpmejsy9A7mUCCeJ/QLZ87GbfYe0EYCTE5ZuNQSjG05APIubH0T/yZHrjmp6bvgO/OJ+uOyAX8E8TLunxFPKzRkSw8TqShd8NzwLmy21XRN2RgAhHC5TLsT3ugHE11CxHz/rn3J/2UlwyG9oGNBqfahzPtWzDaqtvVM284u1GMV1JUkxVRpRjMszxR+enc8pZ7ot0qVrsLlCiIRzJZ81nbCNQY3vLoeDL3HQFUMc/xQGLOxq+diIjf5W/3iaxEDvo6hXLSytx4F9O9ISH/IXF1YjWvLVbVKtxtrpxyWPkOxseXGOvF108C9zrHPLlO+BUFUJn3X8MupguJx6KfsNSYjgjPOH2Q4=
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

Cc: Robin Holt <robinmholt@gmail.com>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Assisted-by: Gemini:unknown-model
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 drivers/misc/sgi-xp/xpc_uv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index 772c787268932..79c2f00ed4d70 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -170,9 +170,8 @@ xpc_create_gru_mq_uv(unsigned int mq_size, int cpu, char *irq_name,
 	mq->mmr_blade = uv_cpu_to_blade_id(cpu);
 
 	nid = cpu_to_node(cpu);
-	page = __alloc_pages_node(nid,
-				      GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
-				      pg_order);
+	page = alloc_pages_node(nid, GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
+				pg_order);
 	if (page == NULL) {
 		dev_err(xpc_part, "xpc_create_gru_mq_uv() failed to alloc %d "
 			"bytes of memory on nid=%d for GRU mq\n", mq_size, nid);

-- 
2.54.0


