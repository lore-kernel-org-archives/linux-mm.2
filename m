Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C05C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48EBB6B0096; Mon, 29 Jun 2026 12:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467016B0098; Mon, 29 Jun 2026 12:02:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CFC6B0099; Mon, 29 Jun 2026 12:02:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 039FA6B0096
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:02:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B79B8C212
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:02:14 +0000 (UTC)
X-FDA: 84933416988.03.6B1DB1D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf28.hostedemail.com (Postfix) with ESMTP id 15F3BC0019
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:02:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P+gIK+i2;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782748932;
	b=MGKop8gjOQCEJf+4WZOXYhnctXe9jRQ5GtX1rzl+T50UOqMD2VprLbbYHhxfT3/ihhtkvs
	qOm+S66N71J54KwQXAM/k9IvkHCaCYE4Wh8uY4k8OuBiBbSMJh+jKvqEtl3ghO1TTiRtEY
	T/xXU5o7DBNuNQaoEBKil14iSydgKK8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782748932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+RgAiv3iYYjQ3ZJYfnW9Ycj9L9Na/rFyKGgNtL3GQHo=;
	b=vCh2QZLdlguQPtjX11xpKIugF5hnwtmKi5UPM79asq0x1rj8IrIYVC7jKfZPxUOIe2isAl
	+CI9zTNP+CSU2+SqRqsnKlugROU0rTBZqG8+4UqHb/CQcSJJKjYuoCkWjr9Y9VE1o36+p6
	RBE478RbuBn7QM0dbyJLViJiUOaXtaM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P+gIK+i2;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782748932; x=1814284932;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+RgAiv3iYYjQ3ZJYfnW9Ycj9L9Na/rFyKGgNtL3GQHo=;
  b=P+gIK+i23iRN3V9s92CSaD3qRjuQj3NLeAGJPiQRxQ0Rtr7J2wWa8wJe
   7QiBQlW/NlpV3gQ9xSK/y9QurEzZJpuFeTWMnCPfccV5ngbd0vcK9FELY
   aU1JjcOfJ0SumfrLGTL395KLFIgBt5DLGcagfpa1zracrxZC0ZE8LfYkh
   0Mh9IyW1EPRICGoWGXc17XYq+0o0vN18BRxTjQ8h8/BTb9dpbdrovmJ/X
   7i2CzOVue5TGse5BLmQ7S8tkONUKrKXpidUm3R3GygPGxH5t34HiWsJmV
   e+1bfUWaBFGlKuyzkPTN/dJK3hUyvs+jdy6qhW2DKjuHeMi20vrAPKqzL
   w==;
X-CSE-ConnectionGUID: Ue0+M62VQY2GxxM0aUp7zw==
X-CSE-MsgGUID: h6/pnBLeSqqP7v/uJvUCNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="87136131"
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="87136131"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 09:02:10 -0700
X-CSE-ConnectionGUID: uPRe1df3TgaFGIEUBY3FPg==
X-CSE-MsgGUID: MJaM+8WMQRWH9v0nL3xaPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,232,1774335600"; 
   d="scan'208";a="290121384"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.109.197]) ([10.125.109.197])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 09:02:09 -0700
Message-ID: <5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
Date: Mon, 29 Jun 2026 09:02:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Thomas Gleixner <tglx@kernel.org>, Zach O'Keefe <zokeefe@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Stevens <stevensd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Linus Walleij <linus.walleij@linaro.org>, Will Deacon
 <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
 <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13>
 <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
 <87mrwon5uw.ffs@fw13>
 <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
 <87cxxgly12.ffs@fw13>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <87cxxgly12.ffs@fw13>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 15F3BC0019
X-Stat-Signature: rdzagp8sw8sq7pe9661he8bwg8trwc1s
X-HE-Tag: 1782748930-691687
X-HE-Meta: U2FsdGVkX1+9OtXyi2vhzNVTANqqUmiXQBO9AgIzAptAuU8RMRrmGTsbIpzsViUF3xe+bqR0VQB7FlZZBBA8irR9a7EGZH+cJt37BI4yrMGPwvo6jruHXzn9wQFMhtSn/8fXRWCI7de8pED/0RSNN8aWZwgIyHDaKcNU6AF/h2v2z8/XxBgcgiiWHm68x74hWFS01MAW73HMtmLKfRCAdJlOYbm0XDg9q/lSEgaLlE+xMHnPymHGGGO7tMPQqUO6FPwEkj1j48ACWWrdwJRFizQEq9ANvMuOoGfoB+Dluvc44SKkO2cnDlbnY76idQsVyyQtfRhcXcYMFDgc9G8KE6hFfJCadRogMUraVzqDmjRtnwo1s0r2mY1I53wQcf1QIyJC3MuDC1Qp9HLYyYCI1R/v+SrqK9uXq1jzSzMfH11iMlLn1mThpFeDZMkon15ZzGl2PYopAexJcVBFZAgF/BmKCkbQx/JE7aiKXZLaAQpnSdZ0qstnKuwW5xmnKvszQiBpL5PSGX70oydKVEyfnX3nlc0MNXoIzjFl15XWLZhPH2z2rjxjOnBh9HjhSZt86NfG8vu5VAilPwI0l7bqueXI5QYI4b1ZgZ97suBcxGCYxUQxwHol6Q8RhQss+7N/IQtkAnsQDShTJQxXViSPFXq3dqDwhCSxhHEq1J05dMLknZoxsKMwwDE4czA+owYAWxjiy9nI4y/thuPzUH/6dJFf8sc3jgCUuyAD022a70CbFXkUrXxIcgOZiDyZlBB2wWD066GVuHm+wkpKik2epczrCgdkpjA8DvjyvRyBeyIzO9R3IaWiNre+Z5by54/kBlj4XM6RFxeqyQ3ynIkpijB4vmIqFQ87o6zigMO7bX2LY3LNuZNOW7hxVTgXij1l3LB0NnErjROGKwH+4Lh7YuKc+scfHA866dUIR21YPH/jkqIbw/G5MlzZJpvEWa0Abo9avb/OXV+JSNlsVqz
 fLFxVP2d
 ufCLnK8PTh/SY4CheAS21v/4cXhBs7fOXcAiTHxuPmLMWx+TB+5/sypv+AZfz4JoBTIpLvZswsbapw013OJ0Ne0U28GwSP0LkQ4NLBQ1l8KZxy0+Z+Q+DOHG81Eb163fCdPvTOtpO9rolm7FIQGc4v0k1ULDgArMJHXZT7Or6ZojD2LCJusCbK+aLMbL1z8EIjx/VpCS8sZXaEYNuIriEtgJ5hslrvRzdAT2n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 14:58, Thomas Gleixner wrote:
> So as you already confirmed that the number of offenders is really low,
> it'd be definitely a worthwhile effort to fix that for everyone and also
> make the compiler people to get their act together 🙂

One other thing comes to mind...

We have debugging options for looking at max stack depth, like
CONFIG_DEBUG_STACK_USAGE. But no distros seem to turn that on. There's
also some ftrace stuff, but I assume none of that is used at runtime either.

Do we need some max stack depth instrumentation that folks will actually
turn on? It would be nice if we spat out warnings when folks went
through 12k (or 8k) of stack so there was a chance of closing the loop
and getting feedback from them.

It could be done with really little overhead if the vmalloc()'d stacks
set Accessed=0 on their PTEs and then checked them near vfree(). The
PTEs are already getting touched there, so the cachelines should be hot
anyway.

The granularity would only be 4k, but it would be so cheap that we could
turn it on universally. It would also be 100% deterministic.

There are, of course, more games that could be played with stack depth
checks on normal interrupts or NMIs. But those would be less deterministic.

Thoughts?

