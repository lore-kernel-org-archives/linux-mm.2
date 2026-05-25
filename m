Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C32CACD4F54
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 02:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B606B0093; Sun, 24 May 2026 22:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF23B6B0095; Sun, 24 May 2026 22:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07AF6B0096; Sun, 24 May 2026 22:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBA686B0093
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:17:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D9AA40E0E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:17:01 +0000 (UTC)
X-FDA: 84804329442.25.63D35AC
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 80719100008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:16:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IwUBR9AD;
	spf=pass (imf05.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779675419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfsAkAdU4PDOgxXu/2olDrWiHUvDAk/BhzLy0f6l/Ss=;
	b=VM8LyQjyL21zDEfxlHJSK5m/bNORJo9J6Q2fXfIfEodCULEvZ5QowOLJrFB5KFSSIq+WYo
	0r76aKCEEuzhFLSjZUc12XRvoxtTopaiuinLw+hA+Wv3I0lzBudy6VmVvadLLyy+cFepUG
	/NKlNgAmqcZ+Jev1uqrju5kA1OmRp/o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IwUBR9AD;
	spf=pass (imf05.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779675419; a=rsa-sha256;
	cv=none;
	b=RW0cZy1KLbYzGUt+h+ea9fkkOqgKVdoQSeo86/c46wBM+Ja8WbiWdQ4V7gMbCGcdD07Upz
	9WAFp4QCuu60ZDO8T6Z3y9k792MIVhKLJCskpoZafA1mpdgdWW8+gawSObafqHHXbfzzE6
	TVCVOcw58d6d35ynzbgxIKtxbOk17P8=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ba180a022dso805ad.1
        for <linux-mm@kvack.org>; Sun, 24 May 2026 19:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779675418; x=1780280218; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dfsAkAdU4PDOgxXu/2olDrWiHUvDAk/BhzLy0f6l/Ss=;
        b=IwUBR9ADdKc1HT99Z5Yi+XXz3JWvcYuHlIR11LstfYIHs33Ecsm6L3CBV1X47d/Lvf
         x0tH27YIcXQqZV+uMSFSJiSdSKuV0iWgAswUBUqTHth2k6tprgINC2/V5MBcjxLKoac+
         XVSclCUJlwx+yYrPVQvrjhTXUfwM6wv7G9rjF6NrrtMR5it+gZ82w3KB5HIYlihWT2p/
         eLEEbS6IVUjqSKpdwLpNYbbUizIvVNbs/dQaocpIbL4eiKeRxR3lPXJQALG9A+p6v6pO
         aDXuZKU2T/3HoH9BVK3ZHk2ZxlWg7nues60w3qg0u79r2vmJzHcLfZ7jPt6zvnjwPQE3
         kPAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779675418; x=1780280218;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dfsAkAdU4PDOgxXu/2olDrWiHUvDAk/BhzLy0f6l/Ss=;
        b=UWxsRR6IpEEMhVGlZcENbRLDW/+2IpfYMkqA7De9xsIaga1ZFEgMMyL+VqZ+5Sp2AB
         TWs7mro8+h9ZCGyk39rySpMQO/1qcyTNIjcigAViuz3tHjw8tjQd4oiD8QqTPknSJ0Us
         MVen9GtAXFV7sHnJRm76J30BKGHwfDRzBvDVUYFiEnx7nIiZgTeH7Ld/wqk0f9hW/bQ0
         mGJax6q5D+mL+tWUyEckhGHZFu9Ymh0n1kO4aTGpugJLTA4/7S53WKMdnoeeHbdV/o1I
         UDjqPznqPKdBsaHlFAosn0NaNNikFTdYeRN5J+gUM4DAHwpuq2soVzseIhd9jXSEqs1m
         e/7g==
X-Forwarded-Encrypted: i=1; AFNElJ8zViZ+snVGQOrg5eJrzDzcfSujQiy96IDt8VUtK8wPWWNLZlnOUBY11fTdqZVBPfqibI+FfmWPjw==@kvack.org
X-Gm-Message-State: AOJu0YxSZs62y0CeRMPRf/QWvaQlJ6B45j6QCjFCOzWVIsXl9MhJDxR+
	0ZYdAU9HHZyAePIrT22CjeiQulUG9jJeuof99pLHfFa6QtHcq1es1tZuI47osCeSTA==
X-Gm-Gg: Acq92OESck4ILKZnX0nFcyaKYVaZuMl5BLqB9R1fup+BnvXwQlnIhugi4r4F2OXaqnb
	3sbCDN8XUoeA/cGLZAHruuRC5ipNTlXHZBIr5jSXL1/ZCQeShoKdrOue9RYbUvTgbuhsTphysw2
	dvV5OtE3gbBkZT8N+1/Q+Av/Lf2I64nsHKnC7tXHYG7XUEtBrjBfncYxJC96MzGAfaWDy79H+3z
	JukUM3NmLIiBrknPOutyQjehQb4EvAele2u3DcywvkthqTqQ8tX34KhJ7+WfFY0IyLJjnD1ZZtz
	RejPhvcRanppPtoetjkZlRAFtiRpNpFOeRuanc/8FxUgcJ3dAKKB6dBTTSk90f7mkdRSfT/dAKX
	tVb5wd/WwhusIz9NttC69aMYC/RRvDFkbqaM/vqd4OMNT3KPe2G9/6erN6ct/IkPrKetRN+e+pg
	iqd9180hBxgAk5ERcN8hDiqtFRqcvYTmjQZY7UXvGQvO5HP6uiYlrFCXmG28PUTD3VsIedT6ibf
	PBrh+CLYfaLtkKHegBr/wuAZdNTK84M1JNR/cD0ZrsukL5IjlYLtWPTnIdxtQIf
X-Received: by 2002:a17:903:3c2b:b0:2bd:3c1b:3073 with SMTP id d9443c01a7336-2bebf41888cmr2832375ad.16.1779675417380;
        Sun, 24 May 2026 19:16:57 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:6235:ad35:aed6:8a48] ([2a00:79e0:2eb0:8:6235:ad35:aed6:8a48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a721c858csm8026039a91.11.2026.05.24.19.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 19:16:56 -0700 (PDT)
Date: Sun, 24 May 2026 19:16:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "Garg, Shivank" <shivankg@amd.com>
cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, 
    kinseyho@google.com, weixugc@google.com, ljs@kernel.org, 
    Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org, 
    rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com, 
    matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
    byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
    apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com, 
    rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org, 
    xuezhengchu@huawei.com, yiannis@zptcorp.com, dave.hansen@intel.com, 
    hannes@cmpxchg.org, jhubbard@nvidia.com, peterx@redhat.com, 
    riel@surriel.com, shakeel.butt@linux.dev, stalexan@redhat.com, 
    tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org, 
    aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com, 
    djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/7] mm/migrate: add copy offload registration
 infrastructure
In-Reply-To: <70ee3800-0469-4c3d-8a1c-bb6594c64f42@amd.com>
Message-ID: <f35bc7f9-c75f-e6d1-df3a-d536047e9461@google.com>
References: <20260428155043.39251-2-shivankg@amd.com> <20260428155043.39251-12-shivankg@amd.com> <9145ae5b-a33e-4092-8cb5-efa18ae61287@kernel.org> <70ee3800-0469-4c3d-8a1c-bb6594c64f42@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: x7czc8u1bewjup1kk9ruw16us7cq14z7
X-Rspamd-Queue-Id: 80719100008
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779675419-823653
X-HE-Meta: U2FsdGVkX19k9nu9tOR6GV1+6Xu+Cr2g1qgw1lNGNzVL4mK4YocK/ThvZmCsA4yJ63DUZYo2AOjuUUGd5rQYd3CRKb+oGCOxTNNUfevl98Q+zDOfLjkIXf1Fo5K6bCAL8O4QywyNJWxKthJvj25KV1kHGZwNvcr0VAfEJfbD3ZtDGlUi05iiYOnkOWRhQ6ZQakvU5hw7A10QmAIw+8NVIFd9/WEGt9iCZ6zU+VQPX9cW8hwW1hmF6IG2Fq49R1VuBC/uj5xJkwuI7L/B8D8ZSGWDD20m8Z8KTmYSgTL1RwyvrA0XRyVrnxufqcAqkqAilrnaV8SO7xECO6NRJNzrCTMzkXTCC4yuk0hDWjK7p4E3FoN7JxoaHImsTRBGrKBnVnxmPGJA53p5GYya7Wr1M8ojDP09IXQpoXP+CkJnZ5UxONsU7RS2Ri33JZYgyevJpiw2kH9IcGYSEwA7lOp+Q9K5z1c5gCCY5i8hUSHnNapXvaXlXiSQs538XMHByuQ4uSM5ZePbfp62DDg9n+CapIRhGY5hOCk7Ad0OdVRnV+umJJJgeeRieodPZOVRTHywybHzh8qkmytNmFxD+LhPtyn9jRCVAYp5zAvZbTNKh2dBD4H4HZfZr9o3nWYxwMBA90mFFudpDELu25vyfZ+GAQITvkq4ko0u5QJz9jEDlZTxQ6DP8izGY206sC5dalfDEuCIw+hVr9/qjWNPCuFCdYmWmz/P0eaK1hBvyLoiG6SKnBOOsyowWPZy6U8YesPAtTMVOSC6v91GoQcWUe0PjVbCH1H8SG7cCKIsmXxyhN3lM4uEcWJL4CjaBhRrVPeeh/xuAoU1Jgce7SIj9ZNJz6Tk7i5u/S0J8vUKEDP+DO7jzyHFJME8s1TTrVGPDrFqIkRa4BsLNNGYlDMo2yOao+ucPh4DeBKTBB35RMeF1K+wEs2hvPS4Pgc+egJJX+aALo4Zh3Yvx4tTw9IPbRL
 dZ3TpcGF
 5lMuRTiHCvX0fbReBC2tZRizW/jhUbMnM8EMuZ7ifYkD/8evIfDb80lkRgwcDmSf44XujugLloFji3U0AFLWSg5bqY9xXhE19YvR53clX72GlBfCL0Fj/xqCIZO0ypMXrxvaPNFTOCcmX/TSPXCyJmwdoZ4PiSwoyxG5D3FZBqcaZNUh5uiU2e1AZVSfS5JAzILNYNnsM9ln17EdG2peBe2PdFgnygP60Tb7hyCRJLR0BKJgSsabwkIrpjF1cYiqlYFgNngD+uJRXibZ9oaOj+eEBe8s8OSfjavlg1eLdtHz+7SDI8nbi1HPK1lOumhmaGAB7DSrmKibpZzlIA5B8+4dAdVxegQAf/jiTvukaJALiGkzuIzhhu0gX/KpwAaDqQhg7tinlB0Ca8bJLtNovz5WzkuCRCA9kPdgVofyUTpzgr+trfaVbKm3QzjE6ccyMJP7+yHw3sBzk9pMfDV0iYbXga5+kEAYz+fCDltBS93MBwtRRveCkbgt4GpgC2FhtS11CO31fp7i93XMr7MSqG/Wapg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026, Garg, Shivank wrote:

> >> +static bool migrate_offload_do_batch(int reason)
> >> +{
> >> +	if (!static_branch_unlikely(&migrate_offload_enabled))
> >> +		return false;
> >> +
> >> +	switch (reason) {
> >> +	case MR_COMPACTION:
> >> +	case MR_SYSCALL:
> >> +	case MR_DEMOTION:
> >> +	case MR_NUMA_MISPLACED:
> >> +		return true;
> >> +	default:
> >> +		return false;
> > 
> > 
> > What's the exact reason we don't do this for hotunplug etc? IOW, why do we make
> > this depend on a reason?
> 
> Reason-based filtering could be a requirement for some users who want only specific
> use cases to go through DMA offload.
> 

+1, I think this makes a lot of sense; not all DMA offloads are created 
equally and we may prefer to unburden them from being contended by 
migrations that they are not intending to accelerate.

> For the RFC, I introduced a placeholder to enable further discussion on which use cases
> should allow migration offload and whether offload users actually need this control?
> 
> Your other point also makes sense: "If someone migrates a handful of folios, latency is
> likely more important (and batching less beneficial)."
> Based on this, we could either fully rely on batch size. I'll think more about this.
> 

There are, or will be, some offloads that must be used for certain types 
of page migrations, like Confidential Computing.  That's for functional 
reasons, not a heuristic.

We want to use certain hardware assists solely for promotion and demotion 
of memory for tiering.  We certainly wouldn't want those hardware assists 
to be inundated by users doing tons of move_pages(2) on their own or by 
best effort memory compaction in the kernel.

I think the use cases should be configurable by the user if at all 
possible so we can control what has access to being offloaded.  These are 
often shared system resources and can be contended like any other 
resource, so configuring which migrations can use them vs not use them 
seems important.

