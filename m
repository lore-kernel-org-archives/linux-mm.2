Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67391C87FD2
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 18:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07F3E6B00D1; Thu,  7 Aug 2025 14:07:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02FD36B00D2; Thu,  7 Aug 2025 14:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E880E6B00D3; Thu,  7 Aug 2025 14:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCC436B00D1
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:07:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7611B1A0AB7
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:07:58 +0000 (UTC)
X-FDA: 83750745036.05.793A27E
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 86FB040008
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 18:07:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=35Omjg71;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754590076; a=rsa-sha256;
	cv=none;
	b=Q2woXYCwlgQICwmE4oYrbZzVre31j4ehMKGISoQwbOfa95v9uc7gQVltJ8NPercg63Bw7o
	FDgWNoPQNxXYY2JejfaTw17qMgDBa6RzSt6tYkzzcPjV3c5p20L+GRgGseuC74jZJ3S0r6
	0PzU8VyoZq+ysV3cB+fyzCbnPILgT1k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=35Omjg71;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754590076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJjrlRJdnoSfaEsthcGrvehuO++RaWyGHz6KW+JMhbA=;
	b=Fa/cVZqFLJzqo2Ci3jnAfZ2bf5hXuWebI1D7Lahl1/WN1wkR7baxNdHe0QHMdlq7Lj0cmy
	mZXJhIt08AztdHRwlBL29o5x2bqJV1z/fhZ8PXqGHUornm8j5+EMgPIgu8D5GKD9w0Rnmo
	kdviDsnV4mjOQOJVNubWyof9lk/Ud78=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6154c7b3ee7so1588a12.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 11:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754590075; x=1755194875; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OJjrlRJdnoSfaEsthcGrvehuO++RaWyGHz6KW+JMhbA=;
        b=35Omjg71ZKhqiAnkP+vOehS5CkMcp2ftmi/GNKiGH/KjOJ+LpqPXH219f/VyZg1zUi
         mbftRKqvz2t6Nh/HZRiwo0CregcA0GGxg1VU/661+Xkb+y+nHz+zWg4ZSW+S6jq2m33t
         VR23pGx9BOSyas/OQW+m6u7Dbcc/bPYjs4fZ0wwCLzNFewBlR63SuXYBQMIOIZF07TOM
         baT9rBrFUliseEfQnsJHiRL/lqU1/f/JXwuO6UjbYc/iIchUxGK1vPnz6eaRewFEMMG4
         Hmr99jeXIYeKs2IlJjg3xbOZZt5jgHiXw3IFf3UFX1PnYr8vmWqa+Zh0dzpH+horD9tt
         nTQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754590075; x=1755194875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OJjrlRJdnoSfaEsthcGrvehuO++RaWyGHz6KW+JMhbA=;
        b=GEFXcQDh0Kbi1FaETq1T+nrgLnnk2U/VKPFHaM1Pla4lZ9O+qSg8/GIJreFlbIPtbU
         Jr7a1oBGIRJHuJSqwqhSie9nVs+elj+IsECFfyPlaC169H2vYnlbk814X9NYeXVymjJi
         Gtizts+wYBLJP16YnBwqrC3uWBo5lkdLCfB8K0uWmaZjpH2gkcopqL6DgFStUfq8ASgv
         9pCxzQJYbNNsqhdxL34/bADcIBoNnmGZNnWuq4On1tGnTjZEKuIDuGMaWQKXDtafCUnq
         dLBCGL34EBE8pQmrskWUNaXrUY0b/Utrc/ejU8mIOGZHsopV7oy1fFKjiQCSQ2tg7Nhv
         0Ezw==
X-Forwarded-Encrypted: i=1; AJvYcCWrLUYLBfXrmW0V79H1rk6XvF8qPqV+xJyQ6Uxj4axmVffklcr3uYymSpHADk8nozw8+h3I9h2Ueg==@kvack.org
X-Gm-Message-State: AOJu0YwIF6egCYQGsSXJ8kFLLa2wAnKBuLnuYpPVjqe0XIxPQ8ufjHVj
	n8b7UcKpWuZw3UQ3XEloxkuutIH4PuzSJ/VUt2xRKoM37ROuBwEnnBxQv3zP5K+y1MFGEaH3kBI
	TE9tzP3dBRZMXyRxX4K6vk+TyjJ5hRE3n/7BPslrL
X-Gm-Gg: ASbGncu2CMjkJl7fl6ad2IqhxvFw9iTo5b5ikxL3zKSAjJctgRzAYWbMF4lfBoN9n3i
	hEMEIRVkXSza5/H/i+XfojHYxIk0NdYLeZbSBL5mNdD73frZMah+8eIqTujxByATdA69mISg2x0
	Gtj9lYxK1h6UOZubTLEhoAgyzToY82j+XdG38+ZJo80RiCfhGhhi0BXt7SJG/5HwiPntQjF7d/V
	fpQh1yxoDlp7l12CMWoe3i/rRMRLS4CzC+aiBb+NciX3g==
X-Google-Smtp-Source: AGHT+IEvzSpesfYkgCCAObC0Xg+i6NHA/CnpVU4+05f2BuAcOX+avD3vpz0PZpZe3fpUS1se60bl8/syKu6NXlsQlSk=
X-Received: by 2002:aa7:c40b:0:b0:615:49c4:893f with SMTP id
 4fb4d7f45d1cf-617e1500d80mr6028a12.2.1754590074764; Thu, 07 Aug 2025 11:07:54
 -0700 (PDT)
MIME-Version: 1.0
References: <202508071609.4e743d7c-lkp@intel.com> <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com>
 <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local> <CAG48ez3=kLL4wBxAVSa2Ugrws+-RFQMdNY9jx5FAdbhpNt8fGg@mail.gmail.com>
 <e4f5faea-ccec-4cc7-83de-1a3c7013b81b@lucifer.local> <cbc2e23d-69ab-4820-9942-c7abf2066ff7@redhat.com>
In-Reply-To: <cbc2e23d-69ab-4820-9942-c7abf2066ff7@redhat.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 7 Aug 2025 20:07:18 +0200
X-Gm-Features: Ac12FXzrdHLe93hwXByTP7b5qoMtUlDB28KMIEXNNyEkjC99e8lIwwa1vdl72oo
Message-ID: <CAG48ez1vM35DZ=kTSd4+ndgR6y33AodLLC2KbfbhGrkDaqdnNQ@mail.gmail.com>
Subject: Re: [linus:master] [mm] f822a9a81a: stress-ng.bigheap.realloc_calls_per_sec
 37.3% regression
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, kernel test robot <oliver.sang@intel.com>, 
	Dev Jain <dev.jain@arm.com>, oe-lkp@lists.linux.dev, lkp@intel.com, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Bang Li <libang.li@antgroup.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, bibo mao <maobibo@loongson.cn>, 
	Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>, Lance Yang <ioworker0@gmail.com>, 
	Liam Howlett <liam.howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Peter Xu <peterx@redhat.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Yang Shi <yang@os.amperecomputing.com>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 86FB040008
X-Stat-Signature: cqk77ig3npde6ckg5emsizuqa3618mph
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754590076-75107
X-HE-Meta: U2FsdGVkX1/wU6cv8kePg6YKFpVo9heVy9id+5ju9Bs6uE7fHZpEXGazBhFWpNeK2Ot8pr2/Xw1mp+W4B2Ftf2OzZel7ELQX6gwP/qtTutgDo4mnd1Ce1WLGoln1quoWQn8Rs/p9h9tYVFqvgbFECd/FyClqoJpTx1naF3Ofhy6N881XBHUQ1YZSS/+4pDJpn12IWXgmutyGG39GX9Hk/mezQ8NgssZ1GMuFBerDfMO+WwFdGe5cLRjsbY38BR9j/GXRDaUNKpaa13bUNf8lMJ6VXU4DBnOUQS/q2/ULPm2JAkHg2rp7NH12yujACPQJ4IT/u0WckBZR0W/eHP8angEtbmYDENhRj3d5nXtpDh0kQLMCupZLeXYRQIhmhU14fnkRp6UcQ/9d1MM0EyhRTaismdjVvoI5WXkuRME3xVRWDd2Nv8a2y5Jr+aqcK6h+3yz87/H9OZBcZwi4iBWAaw+Jgmk8byUDcNLRy3BlIHCcw7SvIpGsOHxS8lXeCFbXEWdF/m6FeWhikB45+rAFCJDYU4JixN7pe0e4Z6jahO1Md4Q4vgNGBuCuUffmLsOdwu2/WHhO9wokb8HejnFCc6ZVnnsHVDQAsroJqEO5/JBenVjFkX7y3io0Y6xLtLKEYzLg7Fm+1O7a+uDHn9r/5Fa9XuXbYJuaAcbMEk2tTkIKpXfApJWhDJDK5iNKOqPo1MDY6k+BpQ3E+okZCAqZfzIdOIN1y+lZvdutO556/C3KEV8BknUuIl0R3h9GpcYyE2ZXIYYhP4Pzm/BlWMquW+xCN8h5b/J5gWlkfMoG4CfWihwJDMbnJC6p9SP+G7WIdvCFBQ+jlj40soybsHMIe6dn9PcQlBoxEL+fvfGX8ph4yycgl00pdWy73k0aApvy1H5zBRgwc5xYRbzC48onW6D8YzZ26bEWB3iNhKHiTnhRpxS8knpHKI1t7n8LrdMv6nbhcKT9VME8jQd1Cr0
 xlEpG16p
 czjxdl99NHQOumDQgIdTrho8YS4MDZERx5MXunn8bx8t/g846B6cK+DOLpmAhnLXYLPumxjBKlB0ekylgcEMCJPyRbQVToVCiiK5uv21sYpDghU65UhAMlaoewNzg//zgYmg2jPcAq3rb7MeY4iOvRcbhqsBKJlO79gpyCIgeA5QJGbOekHj9IcJEMJlfAgPb/nTbG0eyb4kLfeBqjohXTG4aL/wNc9btcKuTmFPbJAeB4pQtdnvuBgiYKeb4bbqA+0T11ZO4zDH3X2Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 8:02=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
> Sure, we could use pte_batch_hint(), but I'm curious if x86 would also
> benefit with larger folios (e.g., 64K, 128K) with this patch.

Where would you expect such a benefit to come from? This function is
more or less a memcpy(), except it has to read PTEs with xchg(), write
them atomically, and set softdirty flags. For x86, what the associated
folios look like and whether the PTEs are contiguous shouldn't matter.

