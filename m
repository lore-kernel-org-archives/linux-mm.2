Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A98DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 17:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7116B008A; Mon, 29 Jun 2026 13:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78EF6B0093; Mon, 29 Jun 2026 13:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C196A6B0096; Mon, 29 Jun 2026 13:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2E76B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:30:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B4251A01F0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:30:42 +0000 (UTC)
X-FDA: 84933639924.07.081E9A8
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2E180140011
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:30:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XOr8mvIr;
	spf=pass (imf26.hostedemail.com: domain of zokeefe@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782754240;
	b=yuzig1hSoa5fgb/K1CZgD4NxyU8F5gvzkoAWV1uHStyBe5EscOUtCoghyxLv7ztcDRk4bM
	Uqjv2R+AEO5VPfhFjXNXgSVwEjeqwUccK3TIC1PY16xFxKSKAuUfUhORvX7l9mIXfuwYrg
	XFrrytz5pVk44B9RpCrisMSggHMmXUM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782754240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipvS03ZS6zD9C+jw9UTBHld6tTEzju3UmczGXg47CFY=;
	b=jn/ai9g5zPxxpSGCwOl6axrmWGXngsDjw8vF/ICXF0DyWsJfiuuyf8jMCYxzw/N7UDPXQw
	ifMuvQKfVuqaMOVnAwamDzVFkBdUBT0lgU+5iVo4Q7tXAltMM0obUg9iIqc4Hx8U2sRjjI
	wIZ8JjF0jcYlW3mwJ+czr0CRL/CyvXk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XOr8mvIr;
	spf=pass (imf26.hostedemail.com: domain of zokeefe@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-133362c30cfso473c88.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:30:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782754239; cv=none;
        d=google.com; s=arc-20260327;
        b=J4Sp76sjVymUE/1LlLKgZacEh5iBl/uJWhUEbM66HNbbf2FGJxWKJLMVu6v22CeTYz
         u02MVLZqvdP8iZAFRHOLhSS06Sv/yP/J+wPFzGDZVd29E/JqVnRl5z7Y83BPvtQilSFT
         JBhwjmLCvmxOwtYyk0q9BpwyOOHbxRGKLB8XXvliT1LzsyfnkYCwdDgPHdmKGg7v7nHu
         /3ellSLVClby0hQPdwZ3848EFzw5wxrkj7T+t0ixk4UXd3jUBPZ5Qe+K/MbF6/xGg1Tq
         HaQypZoYhoD/mJNxVhqZPiGhuOcdBXvv0O3LYPavRjTSC8JId/2YXYizWpKyK+tpmNzK
         GGMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ipvS03ZS6zD9C+jw9UTBHld6tTEzju3UmczGXg47CFY=;
        fh=1VLgCdFDxSQZfD2FTAaK6h2rhX5o6xjz3igBd3JUGro=;
        b=en1wxtRNeHu8ASRn5iAS+nUv0we2TZl+0mcY4bO/TI5+Nk6I6RQhBWG6uhZZO+fSmy
         63dEWhYvj9/w3udsXNPSZiFJjxH6yXTS6EU/xF2Xo9Nt4ZWZ4ytxBasXGiqVUTm51uCg
         LQSqRnBE7nJWjSl6thAhDDNcxtpLz9846eEwmxeAQUHtAlA1EbAX4pfbvO/7CXDAhb4v
         yJB7YbI/zMPYiPvQfWFbfWWHjX+Hesg53+Pnpv6gDG/0gyXO4GNXb0YNJztxZnBZbVNQ
         yeW9Ctl0qXIXCFe2oHjBvvGXF6N6GQzEqWI44BMJ+rUNcf/TAPJm+iwltYUce3FWxdtn
         I4zg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782754239; x=1783359039; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ipvS03ZS6zD9C+jw9UTBHld6tTEzju3UmczGXg47CFY=;
        b=XOr8mvIrE/q59X0zZmcAY2PqeuIlcn8ZX+UYZQsSDtUCMJafysd8FPNPon3RpUzin3
         Nrd4fV/2rGGqp4mKjzbUmSn4vckvzGHFeRkyunQ3y15yjWsFfcuZVZebLX0iI+hsKQE2
         xs9tFe6ETZEdZDTMERs4Bbvz74e79Euv3iNAJid+QUj7gstN2JxlN5duadXQDy9YtH6u
         VHd2DuF6tdqkM0unl7N3CCIMAWE2foRbCJB42BqJPfbucDfXAX5QxuFqxjSx4exTuYhu
         hDjAvSoL3O8PC9KZfdDduGgrK3g0WAkAaTcKoI6bHvDhtBtqE38ataVijKb5rA1XAj5c
         xrfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782754239; x=1783359039;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ipvS03ZS6zD9C+jw9UTBHld6tTEzju3UmczGXg47CFY=;
        b=enWIFtKiZjcp6H4hIFnn/pTbZyA10LXHywYJ1dsEpLMqUhqbRdkVreC4g95Tg3aRmU
         GeY8cxDVs9GDSNoxOr41QT0AVh1Ez+jkk/BaV3VErPKXHqoCr+TY9YKSITiZbRCMlR84
         bksFZ8tn3pv5zddJLF9X76qtQ5CDCjX9L3MdfZ0wfA/Eu1SGkNliErhK9EcvfaVGKWcs
         B341jQu0i8RJQYikGG3LDIX3O+ErAieNJjEcja39o19yNw5KV5Hv7Q/5pkbhvOHN37N9
         1wDCvrlhBWTMkb3wYXH2EC9E1a9WqLVz8jj6AHY6zU4iH2zjAIwT/c6/3d1CcoU/A4S/
         GyfQ==
X-Forwarded-Encrypted: i=1; AFNElJ+/8TWj84W7bGSXxjDgbvBxHchB8j8qwYFJF/1N7LvD0lE09d/iFQUEqh+MA2TvjAN4lg0x3k4KSg==@kvack.org
X-Gm-Message-State: AOJu0YxYOqFG/2YH5aETtLyI25wyld9EQhHfb/5bR48VKCX4ltB+Jqh3
	5V1ZDzbfHGbHArT1O3CTuXkSf4UXBb6R4+hQ2t3e0ShRktoOvyIKlvI/w0DAglh4wWVQncWnWKA
	TrydwSsm6/1ZcirGHesQ/TpWjWHRgSnOeouWdQZJv
X-Gm-Gg: AfdE7ckuQ+2od57UvVfdwCC/rD1RPmNhQoBcoL9bszsuGS3gBsA6JTXo2St3yAMDSiC
	y7FDSiEklKd6xacl5FwkqZgMYo2KtjS8SqAsnmVmZrsKGu/KC2FsnWn6hW6OgwA5kFZGucACq7H
	aVg7zaRi28NlJwMPfcwwPbypC1gNmjBid3hG9Rn4xMEVP5+XB2oHdw2YraBEhO/ehFUccM3/cFI
	7pRMW7u6GUnK5R2SMt4AeSgAYlpv9RqKUTV3Gy039sJ4Qj6tlNE8Yii9zigFetFjI2uIYLkqw==
X-Received: by 2002:a05:7022:309:b0:139:7532:5a81 with SMTP id
 a92af1059eb24-13b2a80e4d5mr9748c88.24.1782754237804; Mon, 29 Jun 2026
 10:30:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com> <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com> <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13> <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
 <87mrwon5uw.ffs@fw13> <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
 <87cxxgly12.ffs@fw13> <5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
 <a1b4b0ba-45c5-4de5-855f-7474918b52ff@kernel.org> <37a630ef-1574-4415-b42c-1d23993c6084@zytor.com>
In-Reply-To: <37a630ef-1574-4415-b42c-1d23993c6084@zytor.com>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Mon, 29 Jun 2026 10:29:53 -0700
X-Gm-Features: AVVi8CfjnR4dyOEC2B5_T26Hjemgkp0VOq3IA8MPRL5bqzn8we_WqG7NxzJ6vik
Message-ID: <CAAa6QmQme+d1rOCEMF_ySwCANsUEbq0mHoq8ijVELBU=d+qPrQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Dave Hansen <dave.hansen@intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, David Stevens <stevensd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 5o76rz8hkpim6z73zi4zyimdmdf38nu9
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2E180140011
X-HE-Tag: 1782754240-983904
X-HE-Meta: U2FsdGVkX1+BPUgEU6xK9AaEvur7jyd7JMVnVJ9mYEUyEGLaFPL4XTECoE/ZQMGEiRe9rpFy7RT18dADvn9s04oehXfCniIuFF28jFcL3D/5zdjVBA/64q8EH3PUlwnW0E+aEn1NTkCwLQ6wPUCNH4Sde99RnG9Y3iQuVctrGpdcGj6fJ28GW5Af3sqEjalKYsJM5c1e4j58geb8i3T6j/k6Db5FrfsIcFaYiXbF+whrlPQetuL7PXuVSvQelrv7xgTYx9v6WC9l1/PhRTbPnnJjLXgSSxSlib1nI9RB7vRw+7uT/RRBIwdbOdtBPjsWo+Qu8LQIs4c/W8gky2o7R8EJ7KU9CPLIWwk1+6d27shKfa7Rhw3egAL+apMWoZ7OG/dzZuZF4iE/TvueRDaA5zkMzcxzOx4XZUcwf14cg2v9uU7W0IUZSPLKSIFIcbwUrbfSuq6wl1vwBZngsZGFWCS/5vSfD8EdF/fte6yEWug7wq682E0aQrJZRFaQjSZM5Etyg2q2fmBWrZMtxdISAYdv3bUFJrXM8K71QeUmamLX38t/oMDerHTDUGZra1w+guXtvZA8+WipaZY02bFDIgrkiPmc/dMBCNjTFSTehxMG90V2CWuOBtBKWphTZgkDPf7/CL4Md5LEtxvXk0t4OgF76GQGsOVdhZXxa2Zq2YgCf11DRRNgqYUscQZUySLcSoXIqcUddvO+HdYQH180ZpLE7jGyynf1dludgM+LBJ0y8gWT+o3LeRZVYVrV7DZYw25xNZn6NA7JCeGXSsNugzdHoVP6vEv6Z+yhKCgqrpZuGQ4TChXujTjTrqaTiasTUxy//VEk1gkuHSaSk1v/5S6w3VcySk5jNIj5xutwOMJSUzs+2LvF126thQ+Oc23sSHBtfg0ESwNZ3GW9LYHOwV0jPw258KxCXSEeFxAx7pPINV5FozhXk59kN6BPhmGnArcJO77B9GOV12CXCyc
 uOJyNaMP
 ZFSHeN1ZcczsBgD0oeGxtxr1kJsR1Scgs05pEIgKHCPHA+2s0eR12b48GIvqwjr9cd59vypQ3G6kd2H24ZlxyHvSgZcNeTwT7mLj8zrBhXj5BhJAm7lc1ShFYb0fIkoJP33uYZSa9fnV1n7JGyNBywwUAmIX1l10YV4/d5znFPLwYJrUT/UBUcm4ZAlBhzR0nA2zcJ50BCUqrZzKa6e4esBml2jbESHiWgR/7cbFphZ1Fi4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks All.

Yes, we run with CONFIG_DEBUG_STACK_USAGE -- which allows us to put
together information on max stack depth usage per host/task.

I'd like to create an upstream recipe for finding deep stacks
statically by combining per-frame sizes from --fstack-usage with
callgraphs generated using Dan Carpenter's smatch utility. In
particular, smatch's selling point is the ability to track indirect
calls (i.e., calls through vm_operations, super_operations, etc).
While easy to set up, and working well out-of-the-box, this currently
results in many false-positive callstack possibilities, so I'm trying
to pare down the graph to get to some useable data. Additionally will
need to know what exception-originating stacks can possibly be
superimposed on the base callstack, for the given configuration -- for
example, today, only a few places we'd expect to see #PF stack.
Lastly, I've been analyzing perf-like data to authoritatively
construct the call graphs as well -- or at least to use for
seeding/filtering the static call graph.

Thanks,
Zach

