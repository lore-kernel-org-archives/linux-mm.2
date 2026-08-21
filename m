Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF3ADC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 08:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD1D56B008C; Fri, 21 Aug 2026 04:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83A56B0092; Fri, 21 Aug 2026 04:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72C26B00A0; Fri, 21 Aug 2026 04:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6C76B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:35:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1462A403E1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:35:35 +0000 (UTC)
X-FDA: 85124617830.03.925F667
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3D4CA40006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:35:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rUNlZ28j;
	spf=pass (imf01.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787301333;
	b=itE+ZX27u234qNLPdi7/6j80ZixTrli1uXWzim0YP94VEPWdPlAYtd9e5BUvaeTHa52/al
	jiZ0rOlSgoefJSJiZG5vQUaFFz5JjSkXJOYKGNHAf3WFej058dOZIJkOD5zbo/bGRTUeV/
	MuIQ/ykufYNE+L6wsUpJy5SHoeoEzJA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rUNlZ28j;
	spf=pass (imf01.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787301333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJo+VFODNoZcuVrRZgNruXYVosZL9AlBhzltP1KWSy4=;
	b=n4HIhJUZctg9vqArMtsHvNRgvIdv7JG5Mt1R2Ysv8ZqhfEVb6H5dmJnuWFizHvnxu1hqGu
	+TZrF+d07/WlMo4jSfqw9AfYMit1IeyxbBssew43RQOlSv/xM2xdxD1DS4Adl2Hmd7hEut
	rNQh1Jm1IRKd0hnz7w+sbVXzKtOC6Fw=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cc891373e0so9015205ad.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787301332; x=1787906132; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LJo+VFODNoZcuVrRZgNruXYVosZL9AlBhzltP1KWSy4=;
        b=rUNlZ28jc6/s4I0ec5BK2aaROdZFN4HCv4KuhR9V5/ytqOzAS1Lq8cEmKzQE0PLZQv
         oLTnzxcxXPx92mIVpvb1mPyFES+kUehWM8rdkXDQhapC6VnUnQ9Xc6l4YFQ+g6ottBUh
         ggw/NAEze/X2NtFIArpiYp0L7hpYrHBxZu+y2X0pt0LSMO8TpdeA34AFErKprppEbKkS
         ZewbEyV7rtraUkmeC0wR951D1MQFo+12WWsQVcZHImWMLJuuvu19ufJjAdQXcZ+agkOU
         CO9KCXTvNuab/cnyoSvAgqEcFW6C79YFQq/mMCsEoaqHTKrQO4QB/REqx5zSqMtKnfXK
         3uOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787301332; x=1787906132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LJo+VFODNoZcuVrRZgNruXYVosZL9AlBhzltP1KWSy4=;
        b=AuH7qt1LTK53SUDDExozkWR6JdDrAf46MtvyeRni7GP/4XRgcBAoHqYfyrbwK+Ki+7
         nXpKCCCZvx9BR+tWvzkQqYwm7mdMG0NY/itigDtUQUikkZU5vLLk63cU/gL8FyuQ6FZH
         urpyrfuMfWqTBT7dkBOBVWTgYDFLz6kzqhhPf0B2BkenDndomxlInMxfZSR2jcmUczYC
         j2Gyd6RruY5UiUO6/kwlPOd5uyyn2n3nzKyHDFE8tik0PKs1+WPF1L/XslttjQsIJfpM
         1oD9JN/1eANi2PFYTvtwjfoyfzf2u5oooPe16Qzk0uWBrcU+IzyFMsiKO+UvgFRpP5Fm
         UQvg==
X-Forwarded-Encrypted: i=1; AHgh+RrRmqTarYg1dLu6LCr+OYv5I4maszX1lRy68ThcfXKDzYhl5B2y0Znn/g0MV0RCNo3WXOLw8A7qGw==@kvack.org
X-Gm-Message-State: AFuF++loKaF+mvN/iJftREilCNXtYHG7KeRpYvktmGNQsOJRni3h0f/T
	P4TuvFsGQgubqaeBNaITtxG8XJjnP1cLw8iXq7Nfa+6WU+h/pUssN55c
X-Gm-Gg: AR+sD119LeW0odExNjc2nSXhpFCsEN6bE1nGLcWW0vKowUmzfNrB5NzG5jHTU8DxrWl
	aPx0Ld04QcPuiFFj2e56wwDT6dd5OCZ3uuc81r5J8efjsvm5H4QWDuD5X6OQRsxtKdqo0QShBtV
	nN/6Q3vXRssiF4LD/AWheZOJk0ECGRS5+R7FIXnmczw8QU0TjKR75uGj5HEdNM5+k8cND1PJEXe
	+l7nzye4LjtrKLLAfU8PY2LpDmD72EXFjJbHYxMFq2q5Aobd8YCN+f2WmMgogr/dyszrQuZlWgc
	BdD9mF9xupD7ZNhyhu4wgMDUlMBmTraqPhoQ7jE39hig5UInFRzD+IqZsIdFMEpVfuvLfO8SwM9
	r9MwfB73L16k4zGcc1QzQWrN9F/s2h6bab20bwFalK+JDR1lPTvh6HfAxJ3qGwxeytBKR+DWnyR
	z6ZBAUtblY0KuEDGa9XyK0/ddcgSRE8ZK4OCBVE2rPSZNKPgFAqtI1F8XBIhD+quu3bpTeAPYKg
	GaDKr0=
X-Received: by 2002:a17:90b:2f0d:b0:381:cef1:11ac with SMTP id 98e67ed59e1d1-395c3561a6dmr9048161a91.10.1787301331934;
        Fri, 21 Aug 2026 01:35:31 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395c8fd34d9sm599575a91.1.2026.08.21.01.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 01:35:31 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm: swap: drop dropbehind swap cache folios on writeback completion
Date: Fri, 21 Aug 2026 16:34:50 +0800
Message-ID: <20260821083500.856970-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818163221.589352-3-alex@ghiti.fr>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D4CA40006
X-Stat-Signature: mweue41dfxiq4r6jiwrxuxxp8pc7ik3h
X-HE-Tag: 1787301333-713378
X-HE-Meta: U2FsdGVkX1+oRPfaU9ol/GiTMDAjQoV1ViWXVyCSOLAjkQLeFEfw5+KVRd2gFW5baJSYtn2oRsFkv2vq3CnSgys1P0fx1mYIW9s2XOnnPiAV4HNuDqXefOCz4uii6ZjQkZTVS9cSme0pM3Tui2ZC0sLU9aS1L+3eHXhmZ4nuUtCKiTyqFoI2KGbg05n5cMWwFQPVsZClJzyUj/mPxvSvlmr/3Seetxz8NT42FFZgsnMA5G8M41VZwTd1CTsHLXoJJOxg3XCzuCnAwJ6dlPP1jrLJJNJDJgTwABFHWr4nDzPR1cTjEhMKEOVQ0Z798KQsN0fcjFuK0PZoRRWHaZdKJ+q/1E5qM/UvfENc8KFU4FFzf6tfDd6jNufllT652qdjLqS0Bt2u+9nvAjafpQApBSc4OeqqNNKPVE/Henwx5827lM3Kep/8AfdsmRmt2H2DWfGlUcRn+/gf2v40o66MkNoGUGJYhkugpCWSMw1O883bc43T16AQWplJtie7X1wC0rj7QYZ81SS66I9k3jbFmRkT6ToyAUpx0fYQMOi0Q2qmPCCCZseY8oZlLCYB/NBfiAl578hNTXRCgEwqwNMk5cbNiKV/E9JI933TnEndRZuCAaIwNk35TpoW3DB+0HURVV1t2VRYzxt7F0ZQ8z4CAqJd1hcjEUe4MYjKYJ3j7F2hmzoC5PGXhvSRjppKmsdQfHCtz8T9OsLqhQl0FQ+Iuf1Oaos0lSkJHrg05yyIt0Zec3BKOXowYzAgTU8phqoLGej52yyv3uVfuQ8UZo9+63mp0mzw08NgbUPEq7TszXG89SIoKr1uadEzxCp4hFzcPDXDdCijWc2EecJtoNIq1Z7PSsie1u0yijC78BFCsKy4PKLHjAKp5uhj/mnvqzkV+QGb/rtv0RhuRMk9jYXt1p0APG667nILTFZVa1tRAxBlBXlgE88jdyTjVevxZikSDLDaT2oOvspRDP2phV6
 v3Y3lD/t
 c3rk2gqYh/Pui6BJHeBp2KrOZj3Yjv9xPp86XYzKl23OrkMA/rmPosZNIBYpHySH4HrEXZ64+PH3nK9w4hsrL0HWuJIi+RqnGkYrHUV+z94SpeIcGVzISP9QPZSFpi+ciVzi2lF7Mm7OlbnOIs8CwfEXkEPK4loy9y8yR2+DF2NvryUJ0pZE+2oduXGlKVIKHDkQ+dq1pH5QnSiW8nk/RkU8rkNlATuVFRj3jcC6MbfQYxaAkNtJuvLAt8PeXRY4ae7K2i6LWqLGBHs0+hp3SwpjecBvFBAkQwG4sh+qeYk2SuHT3dEZwBw6EN6ovE26VwD3uBYXC6irw1mNZcRu9eM9Jie6srhrw8okkZo95wAxluZYgjghWoScDmFe2mV/m+Nse
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Alexandre,

I have a question about the reference ownership/lifetime model in the
synchronous-IO case.

Consider the synchronous writeback path in Patch 3:

  zswap_writeback_entry()
    folio = __swap_cache_alloc_folio(...);
    ...
    __swap_writepage(folio, NULL);
    folio_put(folio);

During writeback completion, Patch 2 does:

  folio_end_writeback(folio)
    folio_get(folio);
    ...
    swap_writeback_dropbehind_folio(folio);
      llist_add()
      queue_work()

With synchronous I/O, is it possible for the dropbehind worker to run
before zswap_writeback_entry() drops its reference after
__swap_writepage() returns?

If so, the worker will attempt:

  swap_dropbehind_drop_folio(folio)
    ...
    remove_mapping(swap_address_space(folio->swap), folio, true, memcg)

while the caller's reference is still held.  Looking at
__remove_mapping() in mm/vmscan.c, it expects a refcount of
1 + folio_nr_pages(folio), but the extra reference still held by
zswap_writeback_entry() would make the actual refcount one higher.
It therefore looks like folio_ref_freeze() will fail in this case.
Is that the intended behavior here?

If the removal can fail, the fallback is:

    folio_clear_dropbehind(folio);
    folio_add_lru(folio);

This appears semantically safe, but it means that the dropbehind
optimization is lost for that writeback: the cold folio goes back onto
the LRU and has to be found by reclaim later.

This seems particularly worth checking because v3 intentionally removes
the synchronous-I/O special case from v2.  The cover letter describes
that special case as an optimization that was not worth the extra code,
which I agree is a reasonable direction if the generic path is
sufficiently effective.

Could you measure the corresponding fallback rate on a synchronous
backend (e.g. zram)?  The 99.996% success rate in the cover letter is for
asynchronous NVMe, so it does not tell us how often this particular race
occurs with synchronous completion.

More generally, I'd like the reference ownership across
__swap_writepage(), folio_end_writeback(), and the deferred worker to be
made explicit.  If the caller's reference can overlap with the worker's
reference, I'd also like to understand whether that is an intentional
and acceptable trade-off, or whether the overlap can be avoided without
reintroducing the synchronous-I/O special case that v3 is trying to
remove.

Thanks,
KunWu

