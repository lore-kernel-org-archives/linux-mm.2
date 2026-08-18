Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCC9AC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 05:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A30546B08CD; Tue, 18 Aug 2026 01:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DFA46B08CF; Tue, 18 Aug 2026 01:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8C96B08D1; Tue, 18 Aug 2026 01:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 55E766B08CD
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:20:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E613120A7D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:20:30 +0000 (UTC)
X-FDA: 85113239820.22.68CB743
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7308B20004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:20:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XuCWCfRg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787030428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guhfkRusufvBWD8H2or6jNYjgUQNUVh/3Ni9l2mmIoM=;
	b=xcO12supQKmbXnnVgkaHJpLxLIohHgWSw/Y8T4wRwuRk3DetynbLguqHwqtgS3Vxh7JaWy
	7Eujr/w7johofAJiixjF7SqHrlKvY62dFCxtySgjoLku6/9DYBFSVzStFnj4HI3yMdGHxf
	FQFCxQoydV1uoW/JVMn5f4ohvWqcdfc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XuCWCfRg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787030428;
	b=oE+OpD7sbDsj+0BULbARcxmP5ZJLauMlSfe+V+GGSsbqhoYyk5kq6xgGUaoZAsyn6m9ltX
	7sYM7Y5GdSxNMsj+Y4g8VifAbCbL5v0X2KsULb0RVpdpnjCotsMNNbVkGTFncIOZCisGlQ
	weoB52OJUw4tBJP2KQHQlpVEMDpQefA=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84874b52eabso5635764b3a.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787030427; x=1787635227; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=guhfkRusufvBWD8H2or6jNYjgUQNUVh/3Ni9l2mmIoM=;
        b=XuCWCfRg10vf+RJm4ibGBHkjDmJugELCPXA/kRmNPKR+63dXQpRZJdDQiAjzf8cBs6
         6oyr5gqYtV92X5cqBpAC5humaqUJskY3Dh/I6tTBfosyFOZb4N0YstzsOroWK8Ofrunk
         D/0rQbmsu8TN83ze5QhWgN07L94eMpvfGkLc+7S28G7AhGtGR/d3hZc/7NtVWoxQEEPk
         kWkEtDLSsmVIKjvd1dSXLZnwOnGLZyRug70oT0vREeQYzxWhh6JAsMdYs0sFqmGzWXnu
         DictgR4O5aANfhLxiXxOo/MWisgW8kLgfi3+wLa7b0cB2e3BrPPzlRSSxeHk739Skwip
         ZbHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787030427; x=1787635227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=guhfkRusufvBWD8H2or6jNYjgUQNUVh/3Ni9l2mmIoM=;
        b=mkQLodvpMT4pgL1eEudX42jl6nvlc0wCs7Gff3USSVwmLMFHBSxnZc8Zu+gw3WADWP
         WbLGldrYn8/zO8WHu8NWNPSHzV5Ga7HlGEQMIDm2Neh0aWZdXdFEhmaCVkCaIHT2vlWO
         QKitsol+1p42N3MjXGHE9tgwvDGtUvcorTBCyOO4MtV5pGO1fRZHEI01jI4eqD6zOLGf
         Zz4Y8JhfhDdDZkuc5BHVYg6KEvCGOSHS4h1m4hj3inEPGpR+Y9JuBEh8rTKmCg1OGNEn
         ombIBAGPg0/OHdp8FId55bgJza5pl1AAR9fnMH879Hqeie8N7L6amsUTh7G1V0avbzaM
         Z8VQ==
X-Forwarded-Encrypted: i=1; AHgh+RpTmwJGHHhRBiQ/H81vDCJuMl02yefOHxC6FKb8bzzPhNrmxx7/3IQ0Z/zyNeU6mSgDIemdnKoDzA==@kvack.org
X-Gm-Message-State: AOJu0YyiNKQeb+HEnIp98Gy6WFz1mzFO01LCp7Zd5OlKMr6sAGh49Pjw
	F2b4FKnqHfM62YMtTXGS26Y5sr30f5222oS+BbuIdU2pqNuQgUqEXEVN
X-Gm-Gg: AR+sD10Ud5/osHwMhCntt308WHVoPyw3whz+aUk7/qxKaSketMRAxiVdz6tTJJ22xEv
	4Tax2UBdcIjwMtA7BVQkuJ85kX792QE3rx0nJU4Qqn8iRpTvIPgBJMhrM7maZA6u2mK+9nBcjbS
	uy33vWK1At8J8LbSogshyddDV9JLAHHSkxsyQ80RExVFNzXjx3YMburmOFKq9Qd597pU+Ga9/+j
	NnWRfzK5B1IYdIfJFpbl+5BcbSNco8jHD+QEviH9xWqKURySQqq1TAk4+ta5UVOZx67EtttxpJk
	w/k0XqagDZsZ5kZD55Qijh3bMDNmyN4ZJLdXwuP19jDE5RZZPeeHPGMlAWV/5Mc4uF34TroCKBz
	SehtL+p83oeixk97KmrqvFJyv0J6Ro1PwBe9ShQgL+W1vlOiVyoFqnEYvU0tJk2P+jcfTrr9NSy
	Nr3nrUe+xIx6uVFmSWIuq4fAaqM97O3O8+SRY1HbOMaQS+qxDeciE4WnD0ndNA1+f6BLazGLpUg
	w==
X-Received: by 2002:a05:6a00:4ac3:b0:82f:50cd:e586 with SMTP id d2e1a72fcca58-84fde001affmr34125452b3a.13.1787030427076;
        Mon, 17 Aug 2026 22:20:27 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6ff0e3csm1046621b3a.60.2026.08.17.22.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:20:26 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Hagen Paul Pfeifer <hagen@jauu.net>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: properly account locked pages
Date: Tue, 18 Aug 2026 14:20:06 +0900
Message-ID: <20260818052006.2387242-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814-secretmem-accounting-v1-1-d2f8c677980b@kernel.org>
References: <20260814-secretmem-accounting-v1-1-d2f8c677980b@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: rjwmedwqfc3isrnr4guwm6h3tbcoz54e
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7308B20004
X-HE-Tag: 1787030428-32242
X-HE-Meta: U2FsdGVkX1/wcBMelNmwL4sPv7wRJ2ByLQf5K9F8PKP5+Hj2yyiOcm9l8N79qoG64hrw80kbWGebndBlaH13Np0OpEtE5gmLSi0nI4T96OWyeiBMsBemxs/XHXawh3BEtNS0vJcl+5V15sS6BslxPaEA8rwMcm/1IlI3gnww0hnITMzAU8Y9UEhj/YlwoDTvxCLpZBcnCeecEzApRhMFfpYgUeX+qXa6AIBTDV+/R382aFcjpaf7NaKLIW5UuadP5Fc3ZTKkBkwc+bRIZbmDTQe5POZNTk+bxJNaQEhURTVolobQDdJmTl1QaWni91SVE/qvXIch+nXE8RxYYoBB/kjSFxjDnrWLYtc6IJZN5hhDQP/htAhMC4+SDOQUcbSeesgrlnsymmr6R5pHjGgiXgvuGisKU4wEIruQdiwTbSdefCJxxqEVO/ZwMFLfar7tBxCVWsV/69+F3t+4vTLvVlh0vvNFzbA/VD5O/SKbLeIcWIzYUiGD3pS5LSebFBETSQ6snLoxmY2UP2VBjCXtrzF3tA8BWicDRgjIlkChCVf7eN7FlV+V7wEAXFOdfW4KWqlThSH8/cYoGCPwQmcRp8YqkY7J9fZRsfvvTP39Lr0OVaFyP0tKcxspr/wTwupL6VoMStrDcSAStaa/M6woRvyBnj4c8izAEy+nNl2Te+5gt3Z+qpEKGmXWF7XgZpv/q3bEsEHRL6HHaDM+vwKjJfuZKwizb/lwuEjAQhvmLfyi7LXhjFD9ozW9vGjo4BPW4sUmCXjhoTqL4yXXvmPtywbJEZAsqPUxxXlfDHQjBrVsR9MIj6AUXuiJcA3gIalFbw81in3Cpq4lJc4p57EkAgYD9KtFqcIDE22I37tDozYzmDqomzYgGhJdEhbpJCGLZmM6GNVt8/UdLDz0VRH6Y2fpFZVTXosmuW+E6vc5xPukCKLUOvewkYl+qE3QJSv5V21OfyWRR80IuSoOW8R
 /Wx3A5hF
 jzgvLsBB2llBglqyQ6GSsl7uVdOUrAGJrIEwygNWW4qXiZ/VSeKlQWWOTYrDqdCrDCfAn/sRCuXppUqpH/LYLTFLIJK97eG69thezenzZPCMO9vWqQjmRfbmHOTpP0LNFUvy0Mi6n6N8Vb+5A1DVq22s+1BAEJOO+J1PWp8RD2s4pbZjBVm3E7LQZyf/kzgVTnN5gEq8isKeTLr2P4qJRyryXX9FAo9uld2A3jI3OgmrnXb50QxsCR74w7OAkLOXbTRiA5Iek29IJZjYeIl5PMgwsJDgV8yzf+VkG/IdZ/+HpydIW/ZfoHCNf7kxE32Djc7Rs8cQ40ap92hHNfIlhtk5gF95pA4gfumGD+TB8sfJryCUQDeTQcWhgvq4ubWDaK5MJhCZP24u9rsgtNZVSsFtQiDCu/r19oeEX8P7S/qr9rH9NZezm0b5qb1hSmmuYeR/9rvMi368hgNkXGX8NsUr69tNAmqlhTjrwQrB1Fe1g/bU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the patch.

I tested this v1 on its stated base with an x86_64 KASAN kernel. The supplied
selftest passed 6/6 in three boots. Additional fork/unmap and inherited-VMA
mremap tests also passed.

One question: the inode stores the creator's user_struct, but the fault path
uses the current task's RLIMIT_MEMLOCK.

  secretmem_init_inode_priv():
    state->user = get_uid(current_user());
  __secretmem_account_pages():
    page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;

With A limited to one page and B to four, A created the fd and passed it to B.
B faulted four pages, after which A got SIGBUS faulting one page on a new fd:

  CROSS_PRINCIPAL receiver_pages=4 creator_fresh_page=0

This seems to charge A's locked_vm using B's limit. Is that intended?

Thanks,
Daehyeon

