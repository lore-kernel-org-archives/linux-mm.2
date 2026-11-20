Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0508C606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 02:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IOqpF8Ij
Received: by kanga.kvack.org (Postfix)
	id 053DB6B06CF; Thu, 19 Nov 2026 21:10:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0046F6B06D8; Thu, 19 Nov 2026 21:10:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34E66B0737; Thu, 19 Nov 2026 21:10:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB8E16B06CF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:10:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5AE20A0D1B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:10:39 +0000 (UTC)
X-FDA: 85453868598.05.BB068C3
Received: from mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 41C4F180003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:10:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IOqpF8Ij;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795140637;
	b=5D0ktwQsOcybfwWb2R6eRILgk0vidtF4Bwgq51/Wmo6AIWVg+9aqepuS6zqQbOXGCeI6Sz
	3Y8+YJW94OtPVaxmaJpd7yIZyirnuko2k3G8BpeMVY1p+zLHDanm6onndtRJatxm/OvPX/
	R6emfr/zuQGl+JaKURhZPaY4vmopDH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795140637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fAN/e6+U7sfa5OtMD1qxSRiG4GHIFoLO8PhOHIp2kek=;
	b=Hdp64gxqCZ9MQlKrkF3SGQT4GR+ytz0TmNwiOlskJAjRL2/zvG9VANMff2IIGwev3njSLm
	8NvjrMWuI//tqmyPujdgrrSEF1lGrekp+qvsAGvFUCgaspGzw6C03dk26UHDApPSg93phM
	+igYhVV2O8rP6YrHIS0MCCAeu55/KFY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IOqpF8Ij;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mrjM3E9XsGUjjvDzD2P9xBJ+Fbcg5ReTEU8nz9rmAso=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795140635; v=1; x=1795745435;
 b=IOqpF8IjwVAI8iVy3cj8+rNKynHO7knY3frnR/aNG9asmV41tp+ZpF0l5oGj4U1cv/yT1BQv
 +OGqbxAyZ8xdvlt/Ncih7uz0eg6OSHhokUapnpchPgYouhUBd1VlXK9rK2TbncpcmMmfWP2dZRg
 JYJo/yNV0QbtKAEbFDWh9Dvg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 4a30cbd97f47fc06;
	Fri, 20 Nov 2026 02:10:34 +0000
X-Mizu-Trace-ID: 4a30cbd97f47fc06
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	donettom@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	xu.xin@linux.dev
Subject: Re: [PATCH] mm/ksm: do not inherit ksm_zero_pages counter or PTE markers on fork
Date: Fri, 20 Nov 2026 10:10:27 +0800
Message-Id: <20261120021027.398507-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <41242382-1cfc-4dd1-8f8f-f9486f80b424@kernel.org>
References: <41242382-1cfc-4dd1-8f8f-f9486f80b424@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: m5hsgb4suexwyumi544kiz677hc8armk
X-Rspamd-Queue-Id: 41C4F180003
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795140637-779212
X-HE-Meta: U2FsdGVkX18kVjxq3f/x9N+hObYoS59NkgCcty2A2JpcMwmHmZ9slNutaw1QFoaSMVbkjb+cG9Nlf0gUGIlb7jcWFepej0GrnMrJFCChjN5W6gvUZNnb+LYx/5GhHHn/nUiEOFLlsYhFS3NxyP2bt3AitSj9tvTBM2lni84RMZHl8oC3T2SkXPKSwipVVAFCPnwFee/p6YAojjgdHBVOT3ijsWJBH9VAK5Hbfr7XQD0meDqBcFZFTB6J5N65HUf4Sm1FII2drNnaH1mXAOAVAqQKuuWGtKhtOxLNF/9Sl6uMZIFpoUTSWFuHjDGkO34N7SrnB1bh0mHJ7tcxwAcItcXGUqeM+gLJKxRR1rWMo6nORIsdYpot1stNg7Y1omgMlPZfn7c7NOOS5HISoZYThqrgMD0B5s7Zi/zbtzJ0kW5sSSpD7k6adAqWbXTY6IPIC/7dLv0r/njpdTrt8fxYopR82QYcAYEcnEKHCQ6QvAZ9SkRIylNKJHMaMSuhG0dfoN5asf863utxkMLGmNTgkjoEYl6we+R+tuQQDjVR22eNnA4mkAZFiPxtmoBEcg2XKLR/9qEtZU3HujZqvz8eKFOjePKnGVMwla9bSpo7pzZvX69kxIrVS2rcxlIqgUSd8N2XjB0id/m1px8T6p2wd45SQHeN2jE8Jh0CqBtE8Nog46XEvi5+vX3HFd29UQyBJ13mWHcn7hVDHjiCLk0Ez3VlihTEBNlznVPqnz3HqR3d8SLlDFGtnLX3TXwYgcpw0mOhGVFLC88KPxna8hjLMYIX3JfRCO4EEmdPo8CGc8MV+tLF5GCS+DDXT80Py6VmLadcKHIDUxA0GLLspm0QQF7oJK5+HMMGyiCqHV0r6iuwy33ggT1oHH/Vypqgz1XO2ZxFIEmTFKTbznYD0YdsepbvxadFzto5hDetil0ZGO7aIQ5S9dwuDBPS1iqO3lkxDoT0oVf4USTRR4zUKzR
 G481CeYZ
 VvScENKt45J6N7EbBXyw84zMxowspW3ivVW0DauS8+n2Ch1TnxBwtsnPN/SoAOU6TkFIVHqYB9vbVj7nRXGZRGW1h3g63CKj++wCcbMyhdD6gVYlLgfm3CmVADncrrWna0dtS6GirKKQqVDGgV1OPtguR8Me0rfowhl+JMpkUX09PDT7M5z6OCdTYsV+ZSc0CbyPQwTUAa7f22Ex3pWD2F7YiYw9/dA2lX4MsDRiVm4F/kH2nHOdfiKvhJwso+NVUAJmAD2qiOwibUWUUi7NIIAVeiGieeWPudNXG/kbgkRXc12bT7S3MF2Pd5Kdhzng4qGbTFBDV+wadw8Rqx4bKWC0bk/mXS8JhEv3VC9/oB1449axTe/1xIIrUHBRoryH57ple2GYiGD3uC0Kge2I8+ac2nPpd/NwFbJ1wyN79Z7WZUqSueDxtDU96QsMsfple9JyKWErXlIRnNqHUCCnkvUTYx7iw4rUTigAy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> >> But ... they were placed by KSM?
> >>
> >> Just like any other KSM folios deduplicated before fork and then shared with the
> >> child?
> > 
> > I see your point, but in practice, people evaluating use_zero_pages=1 often
> > look at ksm_zero_pages to gauge how much memory KSM actually saved. Since
> > forked pages already share the same physical frame via COW even without KSM,
> > counting them across many forked children can give a somewhat misleading
> > impression of KSM's actual savings.
> > 
> > Also, ksm_merging_pages right next to it is already reset to 0 on fork (even
> > when regular KSM folios are shared with the child), so resetting ksm_zero_pages
> > keeps the two counters consistent. 
> > 
> >>
> >> So won't there be an inconsistency when MADV_UNMERGEABLE?
> >>
> > 
> > As for MADV_UNMERGEABLE, leaving the child's mapping as a normal read-only shared
> > zero page is safe and avoids extra allocations. Plus it naturally avoids the
> > skipped-VMA (MADV_DONTFORK) accounting bug you spotted, and does so
> > without extra per-PTE overhead.
> > 
> > What do you think?
> 
> We should then definitely document the behavioral change, and how ksm_zero_pages
> interacts with fork.

Agreed, I'll update these changes into documents.

> 
> For clearing the dirty bit we should have a dedicated helper, such the handling
> is hidden like in is_ksm_zero_pte().
> 
> 
> So clean up that code (reducing the code comment drastically) and properly
> document all that for ksm_zero_pages.

Ok, Will do it in v2 together with the fix of building error when CONFIG_KSM is not set.


