Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9161CC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D78E6B00AC; Thu,  9 Jul 2026 13:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 460A36B00B9; Thu,  9 Jul 2026 13:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32BE06B00BA; Thu,  9 Jul 2026 13:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01FE26B00AC
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:51:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7ADCE1A0249
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:51:24 +0000 (UTC)
X-FDA: 84969980088.21.449F485
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 575F74000C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:51:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uSkARBtA;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783619482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zsrwC6Kq0RUJ8ahrgx8wvLWmUknec3ZbOovjEs7ytXY=;
	b=eQFJnMrYUk0l8sVJwTDL1elmlTC21526rVOYzsZlV7/DIIQrxUw+o2tFLJ1XgHZt01Rn9M
	H4CI0vTuvOkrKGZBSi4YFfy9mbL7RHPXYJgp4b0gdZamsgUj65TDSzLFHbHWMoDcNokdHI
	1k7e22YtUDnavSI8JE+DTbb0dJ5xRzY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uSkARBtA;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783619482;
	b=2OFMJFoUXP37YlTxmaxdICut8kKuUsYAGsQngKtg6JtdCRzuslEJDjt4IFtzXfFzI6FZFn
	ox09ogdHc7WtzVVDDC6Z6dyXzzCTD6QOuPuecpEZhhWY5TsqQPkBYbJWmlgbuA1PURO9iU
	VAOgG3xmA1dH0fJ/ZptdS4PVipEXgTI=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c22c61795so488611cf.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 10:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783619481; x=1784224281; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zsrwC6Kq0RUJ8ahrgx8wvLWmUknec3ZbOovjEs7ytXY=;
        b=uSkARBtAWSjR7Y6H5QeYP4u90UusJgH1230OdzOomcDyxTKgUDy6m5JAaXAZpXlaYQ
         7fZoTMu7XcHncIQo6eTLGzw50i5LvCXegERwRFxVtg+bpMc7Zx7hRnA9b5ZlNtjN4jJ4
         /iYcnhFhG44LnxePU31LTEphjuM4ZrkvuKf1YlFP1HhZizAFbusOSX4RyQBn3pn+2tjk
         PJXnzNbPEcC2zz33OG1vfSqYgcmNWcZOcWEXk39pSgLraoLhnB6zk+S9JnQJhIY2Zqor
         nczH6EApgfAdllN8JmRb4GVLUYHxp803k0OdESFiw/EyrxbenmYcKziyyHBNXy2i50yF
         jXDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783619481; x=1784224281;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zsrwC6Kq0RUJ8ahrgx8wvLWmUknec3ZbOovjEs7ytXY=;
        b=qjxgiuTml0t9I1DA5HDO5EuNTu5IqNzGk9B2mSsA7x+hoQRkZ5XiQda9PabR0oAMDO
         nwAP5bzW7Yzi+AoALSDumdwxfOxKOT9Dz5CBZxlA5XxKeuHFBQEDB6lUR2z15yJVyffd
         wo9xtOGqpleOTjwy/Hm/gimk8DNMISPXhfRpeq2khYmRgeDiylRfW8ERQKZK2ZQzR0oA
         ffGVPh6HThagWEFAPYdsGMPeABkmS0x+ziLKFEbf7JZz9rnkk3BELvyeSzWsBNmJ0A+J
         NvOaFRb+50BKU7UK6ry0dxk9E0Y8lva5kJOJHX3+eu0oJSojUoDFQSE+bi3QQsePc0ad
         Ez0w==
X-Forwarded-Encrypted: i=1; AHgh+RrTfn1lCsxVvePOOWUuN0kwFcKnNNARfL4EFcxZ+9JOb40NC3Mbnrkeechsnit+qRSQqlb2FWkp/w==@kvack.org
X-Gm-Message-State: AOJu0Yzlm8Vnp0ZIqTod8V7ffl3bObTkYQqO2AHc9weXPhI2+cuCr1cG
	HjehKAa30DqWITTSsMTF1j4s/1BU2EVaZvvtQBkwCZ5S2nevzk6Yciok1dEqoCdJOGo=
X-Gm-Gg: AfdE7cn8xhjBz1A24baFZf1lMaEKS4JKbBabRyJaSY7nCFfMMVxwdK4g3/PTUOtaZ6+
	ML95CoPcPtbuWZMWj3PxIBWHhBnaSCq4RolGsBgPRedsiUJmtwnwOEqeC/1HiYlpkw7ziQGMe2O
	8THHTRN5sov6IRzTA1VFSOx1g2eGNQPS+h8mYlBJyk3A2/xUyqG8CQKewDVXi9og/AdydDbp8xO
	2SEtc6/pnogsKXruzrcNDYHoqX0fmsmJxUgAEiROIuTW86N1iwhCeDGhaC7XQtv23HKigfW1dDR
	bGE2HWFm0Vbxkn0OObr771yIxfwuFWFvYU6h9U5f7EV+ymHjWbrTG0kUnvPvE1uYHMokWRg6YFn
	6i+cxZMOYkIN8BpNV8goKTw4KeDsojMhoOzOjx2mhwYPJFP7IyKrFDA/5SkL4BTUPFnv1ZS7mUl
	j63dRbr4eE/m1vAQPXEgk1yg==
X-Received: by 2002:a05:622a:4d05:b0:51c:7d0:7ed7 with SMTP id d75a77b69052e-51c8b31e045mr95887891cf.39.1783619481339;
        Thu, 09 Jul 2026 10:51:21 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caacdacf7sm104021cf.11.2026.07.09.10.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 10:51:19 -0700 (PDT)
Date: Thu, 9 Jul 2026 13:51:19 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mm: fix reclaim storms in defrag_mode
Message-ID: <ak_fl7Nq0DHmQd2K@cmpxchg.org>
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <akWwg0irlanA_y1i@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akWwg0irlanA_y1i@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 575F74000C
X-Stat-Signature: ohsijgdmocdm8egkii8icxmwtbpewuu4
X-HE-Tag: 1783619482-236430
X-HE-Meta: U2FsdGVkX18nDXJ2zhDTTQ/KxWmFUY6YckaFlvaJDvvx6YuRFxOF5wocHLMfyhNSl4s2cG2hhfqH1KBcCGFho7alg45AXQmCLrolLl6qNvTxjTHgxhd5m1JiOGHqRVuDozbbixOKS3O14TYxjC/xwUkKPxs/GHR0G4V0amswo37mTazx73YbrCDW2w3D+6l5fdtsx7xBn/jVHC6ldTHMK0HwWvyM/dR8M2OI1BJBizoOdl5PsVe0u+qW/DCkE8KYfIQBzHYvrKPfV0F58G/ZUjuIEyLteSI32Sby1etgw6jC56nfolOmch+tflJlfsYkyKlt7uaVOKDBfxbY9nDDT+g5hFf1/9k/Qv/1M+JlmRqFkhDuAvFRLXdWFEXBZWiv5SX/gP3QPx1l3lGog9wwXWTIH7zuKdBWNdlGFDyOoPPyTBP1omwVc0sa31OJ3Qwc5JCfc4MWpi0ARfkYN1kRaAc0IN2B+vOlZwVVTNliu+LR2mHRJQ0PBvDNrZHLnjDNVPwvdFCDG5nSmvmNTPzU0bDim35wjZ5zy3AMI96irMSUKXl2mkogvrrNXxm665i88iEoXZ7vFDnw9cVrr5pEMMeLzj7CzjksDWRagVQexq/KZddv1nM2/NVhWLJ6f2Cpa5NX+tpvj/Z4mCEMCgkCNRAiWUEdmGtRPWrl5vr2NTHARAhYeAiVkeMpqEi1VLRVYVZPKLZbxAlDoYUPb14+4qklHpB+6kZMDqKxe7rPRIb0/Iq+Z7nnXRuUh4EdcGJbvd3L7RCRJCh0NutVMb1RJ8moghJAWMrRhp22KQJBwk9YsLnbvAsD2SrCxu5H6FLPpa9mruP7DVMjY62GSQfEHukjI429l7kxioEJw5IA8PmthSeuLOsBf4zzLaXCUoiAHhakzG9vo6VBTci1T+naLrERIZYJ6KK746eth58yrmVoTKmnG2ycB5lwvp3oAP8ppoK6HyB33J9KHIQPw8D
 BanxgaIz
 qpId+Vi5OQpRY01WrFQWJ2A1tgsliv0tyE6HjL1zeNUwrvNuYjpRjCwCxsNpE3UaAdb0rGsQdEj+ZrJmxfxJQBwhhJlZUiq+dIrECeTR3SV+s89cylzRK8CQXGc+K78gO61qF989av8rElmFcTHy1ZPXgORZQsaYRURZS/xJ83dgzmXgW8yCZeIvy9ep6JtAxqbhtkHUDJWc6bhllomXafGSpcNYvXaYJmMtjcgXUhtBqAsh9ilS3pFDJF6/8wbTMRutLRDXLknpOuS4LJutsfhglerQvzzEFLUJXCPn8YMg/Bq4se1ta2ar5ZTcVe5cC53rn2WYNTn/V/1W4XswRD6FEy5+ZMhCQz54rXBBcg46EmgzHH8Yu8rZX2bhXjOmCwOMXvXiVT+7oZEYaebBTPaSTahiehE87lpEhYjh62jN62U61Ewj5XtJNH0yAIsNMBMfZQOVzVHXH2Lo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 05:31:11PM -0700, Shakeel Butt wrote:
> On Fri, Jun 26, 2026 at 02:21:16PM -0400, Johannes Weiner wrote:
> > As we deployed vm.defrag_mode=1 into Meta production, some workloads
> > regressed with recurring pressure spikes and swap storms (which in turn
> > triggered userspace OOM rules on pressure and swap utilization levels).
> > 
> > Tracing pinned this to non-movable 
> 
> allocation?
> 
> > requests spinning and reclaiming

    ^^^

non-movable requests :)

> > unproductively when kswapd/kcompactd are overwhelmed. Direct reclaim
> > predominantly frees up pages in movable blocks, but those requests
> > cannot use that space under defrag_mode rules; 
> 
> Do we have these rules documented somewhere?

Kind of. The crux is that defrag_mode enforces ALLOC_NOFRAGMENT in the
slowpath as well (whereas vanilla just does it in the fastpath). So
it's documented to the extent that ALLOC_NOFRAGMENT is.

> > and it is unlikely to
> > free up whole blocks incidentally for __rmqueue_claim() to work.
> > 
> > This series fixes it by making non-movable requests participate in
> > pageblock production in the allocator slowpath.
> 
> Sorry after reading above sentence I didn't get what those allocators will do
> things differently after the series (I still have to go through the series).

Let me add:

[...] - meaning, they will invoke direct reclaim and direct compaction
with pageblock_order.

Does that clarify it a bit?

