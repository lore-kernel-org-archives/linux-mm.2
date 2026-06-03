Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54320CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 14:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B899F6B009D; Wed,  3 Jun 2026 10:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61CB6B009E; Wed,  3 Jun 2026 10:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A77066B009F; Wed,  3 Jun 2026 10:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 960A16B009D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:59:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 615501C1974
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:59:19 +0000 (UTC)
X-FDA: 84838909638.04.43886AB
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6A06B80015
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:59:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=eAzBazXP;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780498757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8SQNydbT+nEO5+Q1vmeflzQPE43wUdjeoQe0VdYFo68=;
	b=AGznkJuieAkDcIIrkRiQLs7QgAf6x2tZh/MN5oezpcZmELqo3vty9j5SFmXpeyYEJwQYp7
	T7Q9bn513dpe33Py+hdmHdyvwSDqozSbK0OHado7HZbOw0kjvGgPpnjYXeqPNJJQ2RHB5b
	x3Jj/q5nL61wA50FuxNWKJ+K3VIegMA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=eAzBazXP;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780498757;
	b=YX0y+qS7qyNY0L6Tgq+tGU+wCZG1/bL75MbiiiUV6CjIgQ+T7W4w/c7lTlPZc6Ie7n9BIM
	b9zkpRC6dwJZyG4MhxLprh+swaGnZiKGnJnEmSBH46Ckxj4PzIMjNA47qO/8GMaHrUSWTT
	1YboVVQYTesJj5voCI4ZIgtzm4eP9MI=
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-96395a59ff6so1987074241.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 07:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1780498756; x=1781103556; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8SQNydbT+nEO5+Q1vmeflzQPE43wUdjeoQe0VdYFo68=;
        b=eAzBazXPdTJoKP6BLae3mUIxPk4W9/29nOLnTzymYR9X1bej0xhV6qBKv3lTNZbIhE
         L5P4h5pf1E5Bn2h0LhFqvmCbCGqGV8ymFY8O+8QFSsxEzORb2RSmfm+Z3hsQbnMFZbFF
         WtXEYLmufzXP66adw0gpk1fVhX6PeDc3YydKUxMyGxsjKW9alVlU3mJ2dfJ7xLrmHUaN
         O586WMtu7NOP5i9G/YdfCPJ2opVNugK+2X5IfOsnOXd0bV4Q30X3brPns64zkagU6w4f
         UgeqVYzGnCPRzlaGHvf5hMn3ECD2v+S0v2GLTRI0r5mnBdKTNKayVjzfBTaPLCnYQDoX
         JNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780498756; x=1781103556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8SQNydbT+nEO5+Q1vmeflzQPE43wUdjeoQe0VdYFo68=;
        b=bqlBsTFln2xsFzDcY914rpToMTktFPPh6hCfI/NenXtH2YrGy7ennlX4RZLmjFkzTZ
         3ikcFBHWlqmnBoR9psaXtAIc+QAYUQqXEuqpzxjZfCyhkxeOqzAFXQxNUZU8h/mpZRHo
         VcPvrc8+z3nlpm6mGQCLRcDvWnZj2Q+AHUVe5gYBriZ7F56Aiz+kF/0Q8l1WUEfOm3Gl
         zedIrItpRVTFIhP+uXlxGk5IT2Vl/swy9jAAsh8Ib0JorR88f5DPr2zGuVyn9nx5+BpL
         G1aIoaC8hh1XZ5turSa4Vz221GUxBULbkqzynJ4YRquNafZ4GJfCrnZEta9tUb1mLVTZ
         EPwA==
X-Forwarded-Encrypted: i=1; AFNElJ/cDaa7RxRWErQAJ0t7Ar0mopbV50KVBkfVp5uSU2gVD19hahooJmGBzdujGSV6Y1Kost8SPLNufA==@kvack.org
X-Gm-Message-State: AOJu0YzljEt8qQEKMkCUKozLfR1x36+ouV/RVhOhptr6feOzdIkeQukv
	Oam4GO4TZtpZN0HGJquR1H0+oSwcpwZESEv1VZarRLZomIsTj0jdbvCuCHLKtEZdoxA=
X-Gm-Gg: Acq92OGAtWwRL5TuYUcveORQIPvmB4s8jILuaRJ2UUfLG7/ChyyfBh/ot8onr7x84i6
	nkZvl74RRDJz30e1M/+Lh/OtdjKL0Wgt3xLUmEHFbpuk7bPXMDL0mgsYr+Yi/lSOU5v2NhgHd/v
	VNr2Kiu9Y1GnnGeSJXsZfbTmAySAZvVLAk+PCY5H1SNhF5gElNN4n4wrfUTlUmsR7p0zjNAsEFp
	p6OU07xXQatdH7Q26G2ilkCn1cvQZqK3kc77rRKRwkUlpMrvksOG2J7tfP5stcbG4o/btaYYwXW
	byaf2JjAYZ+erVBjM20stlRCvJ5/3z2vFehJVtop/OyOaqOV+1sALRp9ITeg0dJplJvD3LEEC+M
	0psklZRhsK4h/WUoQb04A5u/7XMcSjlvqDbJHfmPLv8raz703m9u+EJiCuYhcE7IHddU+JSiA/n
	6QiVsIs6eqhdR8RC8KjnsZ+nZY//HTlN4x
X-Received: by 2002:a05:6102:8027:b0:633:75d3:3545 with SMTP id ada2fe7eead31-6ec4c6a8669mr2031336137.30.1780498756426;
        Wed, 03 Jun 2026 07:59:16 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277070sm21553296d6.48.2026.06.03.07.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 07:59:15 -0700 (PDT)
Date: Wed, 3 Jun 2026 10:59:15 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 2/3] mm: rename swap.c to folio_lru.c
Message-ID: <aiBBQwwbzBxlGelY@cmpxchg.org>
References: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
 <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-2-ce0219e100d9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-2-ce0219e100d9@gmail.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: rnio7scw4hjkokd8s3knq4q3g4wo3wxm
X-Rspamd-Queue-Id: 6A06B80015
X-HE-Tag: 1780498757-467800
X-HE-Meta: U2FsdGVkX19tVQtLmpd50NabOV/Xo2Hoq3dRvP/OfuBpWwYMYNJmcBtBexL9IoK8YGkxBwLwu9qYMQxOxiRtPrbDGQVsxo9Kl54Gq9vXeCKlwjhzjqScXVr8r7CfcT2sLBq/3nGPsjA6Otwk9Khp9kG8Fxxj2AxyABf/1SHA8ynY98LLuInn869AS4v9AczCm8N8eDmZ7cC3qiZSnBGYVV35nY6CkKdcSOActOh6VG+gxRLjpQGlU5tRwopoV9Ez5BWi9YEUTkUgFeXEfDTQbkUCTqZpkBKQkET3G0hIxHgt/2d0+HB+4CUbrqQaa1PS8R7umyp4I1gYj367JlBsSIrosHtEKvDHq6yPTM0ll6iF7YCSYNzzYGmSH733AuQLrTxslO5XK3kInigzEYtP1Ymbx6PiehFRNvwshVJFzW/Mf2PEZs5iJzq6JsJhwfvS8WnnBahaSbU5fsZtQ0+20ScWTu/6zZZKMKXTgA+2LCoRqWd8Bw5jEFEOL9FpWe8hnKPD31xqDTX0NDN+OG7WphMZmRjEwXvQmQOElnh3taBKTUhJ7rqvK4yxJtxaXAPBaDxRuoE5uCF03QbvS2vu9s4zRFl0PPokUukaGYkYLU2fmMPp6AfM63cXYF0jmBwwYLLi3BlqRdU+f9/NAALbIxC6aZ34gAOJ2JF5MTEz7tWPmbBpZfc1pYNLXWUhe4jRfO8QMVQ/P5s31QDJEclgGX0Y0t73PS7e6jV+b0LP8JVdsbdMkXUojRHakdEaOtzUyKqTTcUJS4F05CiieDCU5Zla2NPIiJ0Mlmj078xwkJ/TdozsNUyIbyp/xKFfyYMZGACmCvvSv/LFaFHpeGS0Mt52AMVKYo5FkX6oiJ1HKSPHGy+OcUy2neopGPUZFYoVEwfdSSvWNADA86MwnLqowz/OQ7ZSm/p/p75OIiLUMOLON5l4MLrtCVuFTUkmoPz+0oV7EnZCYuCCOVk5x7x
 hRAqJCHX
 ooa2JNCBbvML50+IxAn6ZYKj7e4xt1w+OihQhvIDOaIELIPE/xvmAV+GSCpw3rkzlf6yzufBbcQtmLrZRMui3nV3Rw9FjqPAU86ybYh6/qGH0O8OqHOJsAGI7q5SUz/M1j4dDupTrqmgxvwIWL3ufzMG2yo+FBCXNtzI58bOpf9IdhVm4nQl/7U7tOGid3V5XaccuoME2Zi2J4vVzlkFJJNHS1lmg17KlToH8nT7TDa4rIWUzjnqV2uDmtyFoWEy3xctXeH3PmiuhdEkFqriBS9H+6wv3f2tQ0q/EOch4SpA7dfvkjJKPGFdE8GJXqDlDgcQw67KZPTFD1vzaQbWlj/1ap/QeueG7UKd07r9WgcQaRzBReHfI6TvibdiXDzAsyce3Nz92PRFSQthv5EEa4aNRf8n4q4yWNQgavvDL2UWhjKop5NoQlUKlSRJz44FVJyrxgtgSi6Oz4MPtMfBJJHZWMLD57sfcSZLTgqW70UtM8+y5c3TOUZd7Cpf96tCitqosBk7eh+9xdG9D6cK1wk3BbSlf6JAxv8j2jxXmiS7KR3o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 09:05:33PM +0800, Jianyue Wu wrote:
> Rename mm/swap.c to mm/folio_lru.c so the filename better matches
> the code's main responsibility.
> 
> This keeps the implementation split from swap-specific code without
> changing the published LRU helper interfaces.
> 
> Update MAINTAINERS and the remaining mm/swap.c documentation references
> after the rename.
> 
> Suggested-by: Baoquan He <bhe@redhat.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

