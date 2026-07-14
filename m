Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DFFEC44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 23:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EED1C6B0005; Tue, 14 Jul 2026 19:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E76886B0088; Tue, 14 Jul 2026 19:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3EA46B008C; Tue, 14 Jul 2026 19:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A57D06B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:57:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F1EB120564
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:57:00 +0000 (UTC)
X-FDA: 84989045400.14.9E2FA46
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf31.hostedemail.com (Postfix) with ESMTP id 87F2220003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:56:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SKFgMVXq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3yMxWagYKCBcF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3yMxWagYKCBcF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784073418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VbJLIL9gmItiz88QD6tsHYBCJRJFmibBVJcjTpkBGpU=;
	b=L+8YcNJGTsRe3IVgMpVIQQ0pkH8N8ORGWzzNnNtGDUeV0+/hwWmfayUdruS05i1JmfKUbK
	bU7EiaKXz3MkqswDmdxtItnAs9dgLnYL3NGNAyax8hQzpin+TLw6ivxZquNYDgI9HSs+ag
	khGV6/s7triD+2QkhEmZai9PvLfRkr0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SKFgMVXq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3yMxWagYKCBcF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3yMxWagYKCBcF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784073418;
	b=Q671DZ0KqEeHHl57ULsdD9eZYbWdcb/Z2PJpMSm+S2vfxBg2dPNoT1mW1fjDL5ee/LUyKd
	z58kf6sQn05FIV2rme1XT3Z+9ehJN8853bMQxtcRJHEIck1zphM9vCCDz3ASvQycLHn5Qc
	Dtp/vHeiBjFYL3T8cg0zr88ljhz/qqU=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8484b57b98bso9332760b3a.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784073417; x=1784678217; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VbJLIL9gmItiz88QD6tsHYBCJRJFmibBVJcjTpkBGpU=;
        b=SKFgMVXqc8xS5PX53dHo8nfVlTstbkoqFNFb78stUilLFJWQNrwYz7A363Q/X43YUy
         oW1PzP5DVlf4Hi8v9Mo47RGt5IdngE7+G70o3ygI6c/iOUAl345G/fkCb9/GymSm0NBm
         ldZsdqCK6JlA+WAHllGJmd0VsW73/kK2JwfFsb+YTj5uopMiv/fV+svumJKp5VR7Nkg8
         ghtHcRe2H2fpvRXxnrcTGY3hQkDQbpQ1t9aB/ESIxg/xD/VTL0fz1BuejtHHmY5y85aV
         Q3ULshU5iRMnWg0oI4+9H0GpdpBbXFA9O2IbAJ6wEfn17wKrS5OUBn1yZ6NtxGdYbhEo
         dBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784073417; x=1784678217;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VbJLIL9gmItiz88QD6tsHYBCJRJFmibBVJcjTpkBGpU=;
        b=X9IkhyU5JiN9IafmxJEXJCHFnSoM6Ze2lOpGdfFGUPrTcn0Zml8pv5t8KKAcB3xhHO
         7W1A0dSF/kxnPoUL9qadNFbEZagFWG+KacZaKGZznKmrlb6GyWqkPtt/QLkJ8pxOXQFT
         qTdQjPVOCj3kVIFYuxTDFfw5Agv5h5fsJkoKnIY1eoMBxYzmAGxOODN2+WLsMYHGaN8U
         zjghnc6OQLquw8Rk7J11tjE95LXwpbRi+FPhysL2H9Aib4r0Hh04P4XWnuTckRMhRsAE
         haBt6df7BJlcj9ET8hqY/HPe+J+488IqIGpzq03BfMhx8/x9xH2LyggZzREolS3AEDSx
         A3SA==
X-Forwarded-Encrypted: i=1; AHgh+Rrpx04qAMM9HGZunI5Ei3cbzlWF9SihUDYIZovS76D0zuy36X8W/4HRKDs50EMEUnTPHCdfldplUg==@kvack.org
X-Gm-Message-State: AOJu0YyLKQp46Qj232cKTQUTfRYhpC2Ddm0/XDzrEV6JKHfCVyl1UvEz
	Is/nsmLLFPUhKtdugG0WCU4SWoppvrpmphlFQ5Xrxg/I1Wkb6ZZlP5LMZ7ItLbhdSnRU7x4JPHT
	9U+TCHg==
X-Received: from pfbim8.prod.google.com ([2002:a05:6a00:8d88:b0:847:93d8:2813])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3e27:b0:848:87f0:ffab
 with SMTP id d2e1a72fcca58-84a5167760fmr5156585b3a.78.1784073416921; Tue, 14
 Jul 2026 16:56:56 -0700 (PDT)
Date: Tue, 14 Jul 2026 16:56:56 -0700
In-Reply-To: <20260703-alloc-trylock-v5-9-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com> <20260703-alloc-trylock-v5-9-c87b714e19d3@google.com>
Message-ID: <albMyH4scTHvEM0C@google.com>
Subject: Re: [PATCH v5 09/18] KVM: VMX: Use higher-level allocator API
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
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
	Steven Rostedt <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>, 
	Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, derkling@google.com, reijiw@google.com, 
	Yosry Ahmed <yosry@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: xa6ea3dcfrcdgw1co4acoo8fge8u5rbh
X-Rspamd-Queue-Id: 87F2220003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784073418-339069
X-HE-Meta: U2FsdGVkX1+LQKHqF+0HESScv8nJXxheDRtH33CmrGZUWsxGPMCdeJzI92Y6gXTnOWLVIAVGEd4ncz+YhzSk+vtpeK1u4BmC8EOAKmRQhfYkG6lz5+vELwuF2GogN3aR0EIoFDYlZB5gJ7YbeJIR96pa7L0Ca3jSt2UeywT6rdSZshNL9nk63EB3TMWbzh5IKvpUqjG0loHcrWE6P91jdEyZLpkTeT9Ip5P9lZh+IJOspSDL4lgYtc/oCieGY+zDJ2r/9gEKXFCxWZpVFncZskrcYFIQWuj4jQ23baPGiM9fEnYhG5LWEYhwE8sN+PT+H0npeIYsIbrPwsdsmwY6HFfGaKdIQLjF55qgNth173K0gz9uNnkjtGmOpd67XFe4ZpkdgXqLh5VT43XEo65PrQykNI8kJ+277LVQqVTIqp/aTaQJqWsvoMgvlca0ziTcLNdh7fZpEJeo9ia+tO2JAtZQ/zi6RRwk/QenmbFLzVgxpncLUeuXSrLBPG2hJzM4Z44NDPYc4larceW6vGh1bRvd3DfwCxSPATRZgoopUxTr5g/k37DpLUJ+6tDUg+Oey1FuXzsLn8pMRgPzuvo96hjkgLqpHcCMrtVxp6PJbvC1veILJm//uYKRjSRQEKe+M96w6Fygwz9NQ/U7muFdv+n5fkYe9l02+LxIS38TSDAebxcGgMyE1ajrtJBqwpo504o71AgpZiy1wJaRUtzTnTv18+fRWTuNnIKlreSmtfX3Wod3zjODtpEf8mWKnNtrW//o42DP9ziGV0HHC2KIDvQfwAywFacuwJXLXOOwOvqwVeLOqcDT6SSidAWLlhr1OTJZK0PpWZlastBIrB/clNfMxdEeLmUWs//xz7+UznS6eE7R5JVL4dCgjPQz9CUkIxEkHj9JCW2gs63HlRcA7MVvk/joDPvez4ML+ixlj0nS3NTiNCAT+36juX2qZyBi52MM2ZciP7xh0mxsPQ4
 1EY+BYQ5
 KwuYMTesPGPBzoDt8+8XNVP4Ct4fjXbRwgu5A0hWeoBtkfMU5P746TYZWgE/vRo3COE1DmdAoMNhKjcxWFD9cld8h1eLZ6oLuUkEnu7zBR4ISfGnWClFSRLVsDf9Bh0GBkp0qH9MQUQ9i8cgBxc8p/98dlncvPHAE10qCVDn9PJTjXIjfXBI4XijXj1+mtLMHxFOO091FGH+5Ncqa9rQhysmX/KfRYHaT88ajx6NHmZ0ySyTEqqcH2BGJh7ifVcQ1YhxWPtMk+FOr7d36NlsoGWZBNyfcc1dsvOscICchE1LrUUGLrwPFF+QirGxnk8h1kXMeQPHlojSU4xovfizkEB/IWsuZ/PBq0cG5QXhZwDT8e+ZAeus+adW7zQfR3w1lIprg0bdKVcXCrU2sN9TmyjJP4FjcZJ9Q0WXUrHYzYKj6MX5SEio17u2i5yMzcYmuugXyUh5q/tVYvoysq3HqWGkEss8X3u6U7fLAa+g7/keDN4jz+q1NU8put8iRULw4wuc6bXxBdu3/h9XwWzn84qJttmfd6/zqwSC5OutMGQQVwqotTq1yqAK7zt1rOPKOzq8jqxZNuvumo4s6BZh7VsgqQzXlaoibZacYlg8HEHbwdNu/b81g6HQOdM8dfB/Vl02dzXPf7FkF2FwPeYDcwUCYniYd+PLqvUk0ST9CaIoPjuspoYISDLnW3S62SJUwql8n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026, Brendan Jackman wrote:
> The difference between __alloc_pages_node() and alloc_pages_node() is
> that the latter allows you to pass NUMA_NO_NODE.
> 
> The former is going away and the latter works fine here so switch over.
> 
> No functional change intended.
> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Assisted-by: Gemini:unknown-version
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

Feel free to take this through mm/, I can't imagine this will conflict with
anything going through the KVM tree.  Or, holler at me if you want me to take
this through KVM x86.

