Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB90CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3126B000D; Tue,  9 Sep 2025 12:16:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362398E0014; Tue,  9 Sep 2025 12:16:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252CA8E0003; Tue,  9 Sep 2025 12:16:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1089E6B000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:16:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B372DC0699
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:16:13 +0000 (UTC)
X-FDA: 83870213826.30.F1A7E4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id F2C611C0018
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:16:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iy7RwoZU;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757434571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4S/2PWud6uaivwOFJdaiD4JLSiZfB9BQWrwdGwnEqnY=;
	b=xv675bU4mFodQk3lJ7PvZcshte0sZPxxU4WhQ81Qwti8GAUfwTgYhVVHhl55Hlg88X0tBW
	YSM8zni5kDrIyXKhDm58Gl4tghttGRRYmLNsAWbcS0gnVFT2/h7Uee2P6XPj9twoWQ8kio
	F5/EIwfVe0f4mCiV9VOkoW0QMar3vL0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iy7RwoZU;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757434571; a=rsa-sha256;
	cv=none;
	b=rTNubrirqZKMEILgejM/eIJLeQKLxex4jA+28OX3AizVMJ5gMdsrHiq3Hjqiy8S5q4/DnM
	qBUZBVB863ncJzLZkC2MRKDefPZRYYvxklw5nbw6sTK3uamp+FJqqrr4SKKy5SNMG0IJ9P
	LZcflqhjU1RMyBygJX9hRoBQSS6yWlw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE42244CC0
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C25C4CEF9
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757434569;
	bh=8geU/4eOv326mQPYUdjPgngUOLm52LnzgVlD/ZKGCJ8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iy7RwoZUOuHaHDwhCnkwu25fWid4iYX9PGWsJrqfwgxcJzQI9Rd47ZorKtQKlS8Nu
	 /IkKUxmHH1Bnp+d5NvxoHp20wb7r+JdzZkDR9URf57060p/3nCqfcPh5rjR7FGE7+A
	 mQhVqaGXmbYq4853FAs6l9sFNjqk6hiKmhVplojvOgzidesfqDDakcwxxowEqmxkaR
	 4vP0q8QZL0FmUFno698wjpDnb5xA7TXwFfjzC865KikVkkNKtWwsUaK4ghu4rtOpl6
	 6P30ml3NFeEsbjrfRH+mJEQl1JfstN+W233sPZULF8IM9NwxZz92mht11OREoqYNqu
	 w0qxf4DIJCdMA==
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45ddca76f22so193285e9.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 09:16:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVPPFhTNaPxkezV1Mm2KxiosUgAVvWw8d7PuyZVFVNLNpUH06+RJZ1ncbFA/E4sx7gb8c/jkxjf1A==@kvack.org
X-Gm-Message-State: AOJu0Yx794Ns45dTzNBzkJox8ua98edqqxyoCt8tH9R/2QFxbdFr7FUw
	bhPPYXOmiCnVU7jSynMVzHokdoLM6A5JqyHZbd8aXP3bUxLmjNCVjaT84Hns6v1dY6pDVd/ioMO
	2sVhKVLDvj0LmGj0bReW+nkOB4oUjUncxtfcITqwP
X-Google-Smtp-Source: AGHT+IEQ+bGwDzJ/J01xdKe3jrA92uUbIJQmvkt4fuP43jYqEZst7Tgop0RCxlHErtb1OaBKkRPPTuXg/R540vh9nm4=
X-Received: by 2002:a05:600c:c082:b0:45d:f6a6:a13e with SMTP id
 5b1f17b1804b1-45df6a6a1famr173355e9.1.1757434567985; Tue, 09 Sep 2025
 09:16:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250909065349.574894-1-liulei.rjpt@vivo.com> <CAMgjq7Ca6zOozixPot3j5FP_6A8h=DFc7yjHKp2Lg+qu7gNwMA@mail.gmail.com>
 <CAGsJ_4xiTteQECtUNBo+eC9uu8R3CgVT2rpvGCGdFqc3psSnWQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4xiTteQECtUNBo+eC9uu8R3CgVT2rpvGCGdFqc3psSnWQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 9 Sep 2025 09:15:56 -0700
X-Gmail-Original-Message-ID: <CAF8kJuM4BEeHnkhw5bSM6ap23paChMBZtqCY6ksie+8EghYb8g@mail.gmail.com>
X-Gm-Features: AS18NWD8Bdipbsrc2Xnoz893tOcQg79yI5VZd6lbFZnJZu1va_aTGBEbLnomork
Message-ID: <CAF8kJuM4BEeHnkhw5bSM6ap23paChMBZtqCY6ksie+8EghYb8g@mail.gmail.com>
Subject: Re: [PATCH v0 0/2] mm: swap: Gather swap entries and batch async release
To: Barry Song <21cnbao@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, Lei Liu <liulei.rjpt@vivo.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Chen Yu <yu.c.chen@intel.com>, 
	Hao Jia <jiahao1@lixiang.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>, Oleg Nesterov <oleg@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Fushuai Wang <wangfushuai@baidu.com>, 
	"open list:MEMORY MANAGEMENT - OOM KILLER" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: F2C611C0018
X-Rspamd-Server: rspam05
X-Stat-Signature: 5834zd46j5khk9grr81fx3josxxhd34d
X-Rspam-User: 
X-HE-Tag: 1757434570-81638
X-HE-Meta: U2FsdGVkX18U0AHYconyz6oh7MBAWDKZwMf05NT16ReuRf9FGTd4ktcB2uM10TAnXJlgGQ09Lv6UW3yWii5B7FCer97cs1Ol8l1+sFVZiN390XArZ7HFkH6jcuGfToXYMg1XTVRZbsjRC6Fz1Q6JUYyHbyIAMm4eZj8iVz8NgUPE4JR+WKyptTdkYT5xcB2fzPV+ft9cs4ru05XZAYdfzBWqP5tgcbtz5gD4nbmIH6h2I27UTlOELWegeVGFx09waAtwT4R+zPKadiWVfnbvuo1DRsywWJ6S56/aYrceSfuYgLwMROOo09AeoEOSDVlqQBFEvmGjLn1ZOQ1uwjNdm3XgH6g3NehlhNj8MeN78aQQhpRojaqgnfBzrNHl8c/XkZpPT4urN32VgpKl/a0IFm2vIKlBvZPWpr4P/oVxhzr8rLC4mDSzsKU1Rz26VqkJofzIzInxQT2MOIjrkYz3gPliLprw5pSyuUruQcYNoSWx5lnifsNI7sUjoQWrlpSC27kfiXy9FVS5C3OmhB2bSEAIjB58+r8pYBHRmdc1Xl3gmgSdlISjgbgUO3t+h+hvML8MMHJ8ZgUGRAzXLzmu5Q25DxEnpU2UVx+V2faDTssfIi/QqVst1BJ0U7yvgRe7tlH6yC5PAzVPNCpC+cDSxiA95OH5+q4PRGDzaf/zrvlo24DVN1kNlDzp6erGHafbNtuZol0UWKdtxS0hvk3zgoHL9w0qaVHUuNM59IFkJtofYqf4Jddxyf3+VS1cwiO3U/BjWJU3IEXiQFQe/7VDdTdKl8XhmeR3ZLIu1Asi+aZSGqWfToaexxsl1XcG6d6+sO8NvpbI61AFm/2zHgolK6m1bqpGt2GhuDvFzGlhnDZXcM2kTUmXkhJ+hCkZCzU6oqomMIN2DS4EyGulGeUqplH7rINxAcFyKPj5rKR8qvT+nnVVUJCR97BEXI5s5B8A7IxHcMSdiZUo/R+DSDc
 irYSRBh3
 omshyXoMGG7Jj2ytsZUe4APsqiv2MC2C0/fMUOEQU8HMMwwAhw2ybpvvbHKsEQHp7q6DMoC705BWGwMLCmZ6Nlesk8MsURiouvp6DSTIVkQo9+b4eQztsOM9Fg0NApoxwrokzo0PzAO8piseuXzo5KL4g2cpA7X82W1Umfgq4HrXtulJDRfCG24siS1R9fhMH9mt2mQpMqaK2tBP5od7IuBYcpsNsLlaIle4+bTRHQqaWd8LtL8lj6IUrCoA4k+AnZHc/9VIKu+vkEr5X0bMpSGTRufkQSB2wSY+6QpauYmEAnxng8368lCa4jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 2:24=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrote=
:
> I feel the cover letter does not clearly describe where the bottleneck
> occurs or where the performance gains originate. To be honest, even
> the versions submitted last year did not present the bottleneck clearly.
>
> For example, is this due to lock contention (in which case we would
> need performance data to see how much CPU time is spent waiting for
> locks), or simply because we can simultaneously zap present and
> non-present PTEs?

I have done some long tail analysis of the zswap page fault a while
back, before zswap converting to xarray. For the zswap page fault, in
the long tail a good chunk is a bath free swap slot. The breakdown
inside  shows a huge chunk is the clear_shadow() followed by
memsw_uncharge(). I will post the link to the breakdown image once it
is available.

Chris

