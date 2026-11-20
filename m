Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 097B5606A333
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ST/is2/a
Received: by kanga.kvack.org (Postfix)
	id 11BB76B05B1; Fri, 20 Nov 2026 04:30:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F55A6B05B2; Fri, 20 Nov 2026 04:30:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFD7D6B05B3; Fri, 20 Nov 2026 04:30:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE0966B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:30:14 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9B24140DBB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:30:13 +0000 (UTC)
X-FDA: 85454976306.21.D68BDA5
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id C3CB814000E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:30:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="ST/is2/a";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795167011;
	b=N4UY7ND41aJKwwDpidKqeeGJCPdaa5R/RcQqMJxk+w4EdxPd7RjZ+gdIhs7+fDoUswvHHI
	19DpRsyXbjXWumDzr757nwV1nnEuwMowCALHXS5JNQi07yCyHWL+N376EnGQ+23PFq+RrP
	Y0itHTqKB5i9djDu+zfKW8F9Vy9gA9s=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795167011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1LP11PvLTI43VOxCxt/momCmpYyjZj2ekQQAZOy1f8=;
	b=Y20GajI+MNOr9yCocA6nRREDuQD0gThHXp0q2LQffw5Z7Qf7v2pNqkwqpdjFOtmsRKMF5c
	ttt4FTqxP4/N9uKOcsbMx3+R70JVDhDCXVkFnSmyUBylmk7G6Hgcpi0DAFq1ollxNpgOmT
	290m9bMMnTMKmQ3wuTD6l25wQXLS+V4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="ST/is2/a";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso4307175e9.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:30:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795167010; cv=none;
        d=google.com; s=arc-20260327;
        b=KplbNfDnpzIdObJRn4sUd5j7F6eLQLsAy6VBlv6MP9yyVppa94KNQELQ1fAKVJFwvz
         r8tkWMO+4x5J4q9zDXi6uCN6MEVi89/dvh+wHWt49dGjHRwgfZKfWLmh60GRU58ut0np
         l0cDIwSbMxM8AufpBCPTHwgo6+L9mvJjaBmmWZ2Hx0KKYJRACRb0A8jDuAsmEwTbKZ3c
         YxWsQCGTOFXuRzeXMP+QGM+bWp7vyZX+V6PWF4v50gxBdZA38GK0B0BFGnoajdshpm0w
         lcKlLW2ktuHcmtisrUK74MiWweaf4iaXcUc48K/4khubdsrhhQcmImJk33G144OAHRWW
         ax9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l1LP11PvLTI43VOxCxt/momCmpYyjZj2ekQQAZOy1f8=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=LU4KHNll+SF3941Rdii0qS8E0Ty7qik0ZbCjqdqt9U7frE+H/sJu7AJzcpC1B7b6AL
         jdj3F03yU2r/ZaqffozLChAwenc4Jt7Pi5mUrBYX+SsMpMSFWRHBPoUxP1tFs/L5pArE
         XeQMpdl1r9FGTo6u+bY4Z9joBrFstqHkgkuCArwBEzh+Ro/2Iyydkt4VPa+k96eTxDcE
         akrgqMt8vJ1gsRd+v/j956nbI/se9e96w8+DFJoQ0rI7dGkqsg6yW9BQtlDRqyJDmjrS
         FCo/RUXkvLdLwSMj7EhB8QcHOm7vQz667yqLF1U5zlbjWMnejw/tUH83HueAPbJqJBdz
         H52Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795167010; x=1795771810; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l1LP11PvLTI43VOxCxt/momCmpYyjZj2ekQQAZOy1f8=;
        b=ST/is2/aNgaJo2u++Uvw/+oQwNpkNfRLSn1Lz6SkznvfAPxsS1nRnpJ1Zky8FXClT4
         5Vecp0LH5UjamatdcLfro6ctzqOwHi06wz639WBBCUyzYXorCR9L3LbRQj5wWEwDbTX9
         OLlmPwPARQtFm0E/yTG5G8HYlfcrDGWOqHKrlnrlL50lHnc9x6gvP/flV9S1uTNzf77i
         RXhmvqfearlKPQFF+74IdPFBqlcFXvTO+uepaKawweC6oNuT7I5l46tNjtdYByYUfx1L
         ZrwGGYerJPoNTdWBqzh/MjzjB7CfNK2oj3Htg7wrgQbqIUAd2926FbfTN76kD+EATGfQ
         bXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795167010; x=1795771810;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l1LP11PvLTI43VOxCxt/momCmpYyjZj2ekQQAZOy1f8=;
        b=zy5htSttgeXwEaL8yX2aC/LOFAu9M4nJL8AAQ42E3M6mbl3RCPiDHLkxNkJtpazd/y
         lFDp9rYgKqNzi7ShWKTiDAlnp4Wzj0DxQvX8TktHrn/MAZn0Wznx0EPMX6ue0xTej9iB
         jzlTzDOHXwo73JekPbg5kwozOLuBPuxHdDTknh4M0bx9AfjJqZtU9T2x5MT4qa6RJYi8
         J+wgsdZOO2OXh3I2XrSautt7WGu+NY/3a9oQOYbygiPUyy8Hs4ZEhMDStaZ4qm9blbrv
         0Ikdke3cIsD3f5B19LCZ/4aqgtaEef0Z0IKLEoQlP3pKAnB7iNEpHjJMjkWm6NKax1wn
         YHLw==
X-Gm-Message-State: APuU4Z/RjvE0GG7zx7hm4XebAV46edZQ5AFBhAgmJAm3DxGSKvXco23i
	60WvLo6WAV3hlnNLvuUsHaXQkHy01olV6SVOu44t7aP/ss0I3vrF7yZNxy47gqnMSSWPKZI39xU
	mPsiRDZGO1wz1zQzoV0GV9wZVohIOz5w=
X-Gm-Gg: AYBFou12YOMn4pXlvAzuCP0Pz0Vn6MysI2xxpcGhxngTEjAI78ycSGY0pfNF1l4EVxY
	z7GAms5w5yrYBNmHkT2/RsFPj5Dzoxokspvay+xid5ZfIhezMhZC3F3tTI4XbifgEIv36YKjCHE
	rr4Eade91QayIyxE+5AGdMu5L1ddDDhmf7jKkqmJVEBNWzMKCGox51L+1WghqzsQO1iiMltXliG
	C72ep6QCBtYBmzocrjbaP0SZXkIWdQw0NW2yRb3+1fPsj9GKpnUCbUfzs6b8URF0/o98pl3/+MD
	0j4mDKdxx3GxFYuAEe++SSHo9dutKtfTNLt1DYHM21UNNG6dr9uGfWRm5OQZW9zDlOQW6r5Fi+K
	XSq+wsiY4eduCLHh27GfhcXGbpDsqE6q5aTKicGU8F18=
X-Received: by 2002:a05:600c:b8a:b0:4bb:7007:4a5a with SMTP id
 5b1f17b1804b1-4bb88817772mr51604115e9.23.1795167009565; Fri, 20 Nov 2026
 01:30:09 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-15-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-15-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 17:29:56 +0800
X-Gm-Features: AclHuK_6yXmPKisO2emCryLIHFK-JxkWQduG4AamvuG_bhbUWmcrrLBzH5IxNjE
Message-ID: <CAN_Opa8jGstV=s9S=c842XFJ_H8m5txc6eJDH2AF=KuJSHAe6Q@mail.gmail.com>
Subject: Re: [PATCH v5 15/17] mm/mglru: folio LRU refs based active/inactive
 number accounting
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: C3CB814000E
X-Stat-Signature: aipwbt6rhx85tgog6f9xrqq54usjbwru
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795167011-940321
X-HE-Meta: U2FsdGVkX19rYtV0pBfH/+y8UlgGQu9hu+DhcrEGYq0pzjcNoAAG5V1JP61UVY+JLPReRPaa7WQFErdAw0y2iJ9tTcrtMlxbStcjckYmY5LUi62qpDBNc47kXl1G6GLnttX1F1qIZ0wdbphEPzS0JQ2gDr8TpJ58oC17nRKmTPlinGXvQAj5SCfnJyfaAJHgTWjPvlUOHKKvZBD9blaoc0GcoQ3wqgAltr++a4vdLNNxnBnzchM8w3t5gDGs0W/uMOTziWPVgvdBpUBr2uCg5R5sHGoiVyJY1GI3jy9/5gr5FD9xXNfuHbktfGM03p0TKARkZ8QV/YmZbe/dF7RhTyKTtEtIRjGZPZ5DABOcNytuSuI8/eH6qg38D92aVEH/++rYlB3em16zZ8/WqWMPnMeMqpUJAZ7Hn/Ymi7TkoLtzVdxGRm4cohlHLvNyzffi3DrPAyFGXN0bT3laJn6enlO+rQK03ov44jKga5Old7azRSrFlZ+4G2+3Ob41WiTecRfx7eGGfJdYmdsF1TOch5DVHTqTWfIiQ2tFo4BjxqUM4J8rsVfUT+ilFNiEHbcze0iFy0USCqqxK5bB0rGGHzWWN7ZDnDP6B9p3Ga39ndDZjQkkD87C1hdKaHltMFkJbw2f5J5E6SRUJjqG8k2n8U6YiFq8/6CYnySXC/i0G90uoDdU+QXvJ1mVbZPCLjU39W4lrBoyGwjJ4K5uGTuvUj3lDPwuD2rDfEVgEvmNrZaMEzMH8QQToPAq+q9Y5A6bJfCC09kuYQfN5RMcDW97M5IEo59HLaYt9k5aWKkD7vp7ppNk0u4KbTp53QOIDvnP1T/G3oDamMCMsye0M63CvLBmYPnyjH3mqLAwjRoZvssrtoTg/6AUs2kOnVkxbAC2XYOFIHAsqEtD0aWhHVYT9ANOsbatIelLXbGkmY+k5mMQ7nqbQtH7yZmKBH5BeGq0ft3jt8dAVE8uB+vCEGo
 nZ8KVlZ2
 OIHh0nf6QorvGznJPBF6ylE0vhT4T5aZ3Ws5rsthX/7+uaVapHq2KM27UmH0jKDVy8GdDNirStY7VtDfynLX5/dBvo9Qm750kUi4Bio9WDykjpYe/z8cmNDOonzficzVxFS7scqbzOu9gYq6iNoFRd0kfsGDkkFamCe8X041gP14v4L8rVh68Vw2iys62WUQxRRCVwilCkBbDpKEnzbt50qNkM2skBWxNkAvv2Y/McnFLVgHeswIFD/YbBIgR/n9LnqsKB5sH75nvr8m7U1iMWtT/UrxCYFfth4Yvf6VaboodENel8Z5oiMgiWduQi8PAdTiTK7QPm4neTzFVdJNRiF0GyD6yE18gLQomhBIVllFbRFFa4T9uWHR5uacIKOMNQjGsFxyHXoajzplHQuWijoLmVGnVJIsWXsxK4WmO3WetUeD7po7qq07LOmWSYHyHhwhbuEptmSN1aZVGpBhfXVNgW+zMbXGTIsHd4duIff7TZMULTSaFFMgOEmp46mAI+z7LT/J1ri6J+J9F+0H6W2Q115RjYuqYdxOsAuatbVNYLOlkNOJhxBo1roDxKj85ur4wnyUGTeL59UO8bUJGaS/BpIREen63kqrt4t9FaSrBct/8/pfhBjv9EH2O8tOW65DNIi8Sy7YnbDqKSKdmp8FnAainY3G+7NxRfgUE5Ibj5xYaZL75Jq24EquElJxV7GG1dlfyBs9oEgo7vgbJ9JU5oS50sZiaui42r4nxp8AtREylc1xi2ZPsoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:04=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Currently the active/inactive LRU sizes exported through /proc/vmstat
> and memory.stat are derived from the generation window: folios in the
> two newest generations are accounted as active, the rest as inactive.
> This causes several problems:
>
> - Unmapped file folios can stay in older gens despite repeated use,
>   so active files can be under-reported, unlike classical LRU.
>
> - The reading is jumpy: on aging, the second-newest gen, previously
>   active, becomes inactive all at once, causing a huge drop of active
>   folios without any change in use.
>
> - The reading is reversed on swapless machines. When swapping is
>   disabled or unavailable, MGLRU ages anon by moving the gens directly
>   without walking or touching any folio, to reduce the overhead. So
>   inactive anon folios can suddenly count as active, or vice versa,
>   despite no change in their hotness.
>
> With frequency guided promotion, hotness is already tracked per folio by
> its referenced count, so we can do folio level accounting instead: a
> folio is active once its refs reach LRU_REFS_ACTIVATED (currently
> LRU_REFS_PROTECTED).
>
> On reaching this threshold, folios are accounted to the active part.
> On forced per-folio aging or PID protection, refs are capped at
> LRU_REFS_WORKINGSET, dropping active folios to the inactive part.
> Note that on swapless machines anon refs are not reset by aging (the
> shortcut skips the per-folio walk), but the counts no longer oscillate
> as the generation indices wrap.
>
> The accounting is now per folio and lruvec independent, so no size
> adjustment is needed when reparenting a dying memcg: the hierarchical
> stats keep the counts in the parent automatically.
>
> folio_migrate_lru_refs() also gains off-LRU VM_WARN_ON_ONCE checks and
> __folio_set_lru_refs() warns when the folio is still on an LRU list.
>
> The latter uses lru_get_gen_flags(), so that helper now has to move out o=
f
> the CONFIG_LRU_GEN block and is built with the option off, where
> LRU_GEN_WIDTH is 0 and LRU_GEN_MASK is zero.  Keep the decoded value in
> int so the subtraction of the one-off encoding cannot fold to ULONG_MAX
> before it happens: that is -Woverflow, and fatal with CONFIG_WERROR.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  Documentation/admin-guide/mm/multigen_lru.rst |   4 +-
>  include/linux/mm_inline.h                     | 118 +++++++-------
>  include/linux/mmzone.h                        |  23 ++-
>  mm/folio.c                                    |  39 +----
>  mm/madvise.c                                  |   2 +-
>  mm/vmscan.c                                   | 218 +++++++++++++++++---=
------
>  mm/workingset.c                               |   2 +-
>  7 files changed, 230 insertions(+), 176 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/multigen_lru.rst b/Documentatio=
n/admin-guide/mm/multigen_lru.rst
> index 9cb54b4ff5d9..808d2e97b3f3 100644
> --- a/Documentation/admin-guide/mm/multigen_lru.rst
> +++ b/Documentation/admin-guide/mm/multigen_lru.rst
> @@ -149,8 +149,8 @@ generations less than or equal to ``min_gen_nr``.
>      ``- memcg_id node_id min_gen_nr [swappiness [nr_to_reclaim]]``
>
>  ``min_gen_nr`` should be less than ``max_gen_nr-1``, since
> -``max_gen_nr`` and ``max_gen_nr-1`` are not fully aged (equivalent to
> -the active list) and therefore cannot be evicted. ``swappiness``
> +``max_gen_nr`` and ``max_gen_nr-1`` are not fully aged and therefore
> +cannot be evicted. ``swappiness``
>  overrides the default value in ``/proc/sys/vm/swappiness`` and the valid
>  range is [0-200, max], with max being exclusively used for the reclamati=
on
>  of anonymous memory. ``nr_to_reclaim`` limits the number of pages to evi=
ct.
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 14aab2b1ed08..77f514143266 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -105,6 +105,22 @@ static __always_inline enum lru_list folio_lru_list(=
const struct folio *folio)
>         return lru;
>  }
>
> +/**
> + * lru_get_gen_flags - Return the LRU generation number from folio flags=
.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> + * -1 if the flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_get_gen_flags(unsigned long flags)
> +{
> +       int gen =3D (int)((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> +
> +       /* The gen is stored offset by one, so zero means off-list */
> +       VM_WARN_ON_ONCE(gen > MAX_NR_GENS);
> +       return gen - 1;
> +}
> +
>  #ifdef CONFIG_LRU_GEN
>
>  static inline bool lru_gen_switching(void)
> @@ -168,22 +184,6 @@ static inline void lru_set_gen_flags(unsigned long *=
flags, int gen)
>         *flags |=3D (gen + 1UL) << LRU_GEN_PGOFF;
>  }
>
> -/**
> - * lru_get_gen_flags - Return the LRU generation number from folio flags=
.
> - * @flags: folio flags
> - *
> - * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> - * -1 if the flags indicate the folio is off the list (e.g., isolated).
> - */
> -static inline int lru_get_gen_flags(unsigned long flags)
> -{
> -       int gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> -
> -       /* Exclude the legal -1 from the unsigned MAX_NR_GENS comparison =
*/
> -       VM_WARN_ON_ONCE(gen !=3D -1 && gen >=3D MAX_NR_GENS);
> -       return gen;
> -}
> -
>  static inline int folio_lru_gen(const struct folio *folio)
>  {
>         return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)))=
;
> @@ -247,12 +247,21 @@ static inline bool lru_refs_is_workingset(unsigned =
int refs)
>         return refs >=3D LRU_REFS_WORKINGSET;
>  }
>
> -static inline void folio_set_lru_refs(struct folio *folio, unsigned int =
refs)
> +/**
> + * __folio_set_lru_refs - Set a folio's LRU refs.
> + * @folio: the folio
> + * @refs: the new referenced count (0 .. LRU_REFS_MAX)
> + *
> + * Set the folio's LRU refs.  The folio must be off the LRU list (e.g.,
> + * isolated), or use folio_inc_lru_refs or folio_reset_lru_refs instead.
> + */
> +static inline void __folio_set_lru_refs(struct folio *folio, unsigned in=
t refs)
>  {
>         unsigned long new_flags, old_flags =3D READ_ONCE(*folio_flags(fol=
io, 0));
>
>         do {
>                 new_flags =3D old_flags;
> +               VM_WARN_ON_ONCE(lru_get_gen_flags(old_flags) !=3D -1);
>                 lru_set_refs_flags(&new_flags, refs);
>                 if (new_flags =3D=3D old_flags)
>                         break;
> @@ -261,12 +270,18 @@ static inline void folio_set_lru_refs(struct folio =
*folio, unsigned int refs)
>
>  #ifdef CONFIG_LRU_GEN
>  void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
> +bool folio_reset_lru_refs(struct folio *folio);
>  #else
>  static inline void folio_inc_lru_refs(struct folio *folio, unsigned int =
flags)
>  {
>         /* Should not be called with !CONFIG_LRU_GEN */
>         WARN_ON_ONCE(1);
>  }
> +
> +static inline bool folio_reset_lru_refs(struct folio *folio)
> +{
> +       return false;
> +}
>  #endif
>
>  /**
> @@ -280,10 +295,18 @@ static inline void folio_inc_lru_refs(struct folio =
*folio, unsigned int flags)
>   */
>  static inline void folio_migrate_lru_refs(struct folio *new, const struc=
t folio *old)
>  {
> -       folio_set_lru_refs(new, folio_lru_refs(old));
> +       VM_WARN_ON_ONCE_FOLIO(folio_test_lru(old), old);
> +       VM_WARN_ON_ONCE_FOLIO(folio_test_lru(new), new);
> +       __folio_set_lru_refs(new, folio_lru_refs(old));
>  }
>
>  #ifdef CONFIG_LRU_GEN
> +static inline bool lru_refs_is_active(unsigned int refs)
> +{
> +       VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> +       return refs >=3D LRU_REFS_ACTIVATED;
> +}
> +
>  static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int g=
en)
>  {
>         unsigned long min_seq =3D READ_ONCE(lruvec->lrugen.min_seq[type])=
;
> @@ -294,23 +317,12 @@ static inline bool lru_gen_is_old(struct lruvec *lr=
uvec, int type, int gen)
>                gen =3D=3D lru_gen_from_seq(min_seq + 1);
>  }
>
> -static inline bool lru_gen_is_active(const struct lruvec *lruvec, int ge=
n)
> -{
> -       unsigned long max_seq =3D READ_ONCE(lruvec->lrugen.max_seq);
> -
> -       VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS);
> -
> -       /* see the comment on MIN_NR_GENS */
> -       return gen =3D=3D lru_gen_from_seq(max_seq) || gen =3D=3D lru_gen=
_from_seq(max_seq - 1);
> -}
> -
>  static inline void lru_gen_update_size(struct lruvec *lruvec, struct fol=
io *folio,
>                                        int old_gen, int new_gen)
>  {
>         int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
> -       enum lru_list lru =3D type * LRU_INACTIVE_FILE;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
>         VM_WARN_ON_ONCE(old_gen !=3D -1 && old_gen >=3D MAX_NR_GENS);
> @@ -321,19 +333,6 @@ static inline void lru_gen_update_size(struct lruvec=
 *lruvec, struct folio *foli
>                 atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][z=
one]);
>         if (new_gen >=3D 0)
>                 atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][z=
one]);
> -
> -       /* return now if not a promotion */
> -       if (old_gen < 0 || new_gen < 0)
> -               return;
> -
> -       /* promotion */
> -       if (!lru_gen_is_active(lruvec, old_gen) && lru_gen_is_active(lruv=
ec, new_gen)) {
> -               __update_lru_size(lruvec, lru, zone, -delta);
> -               __update_lru_size(lruvec, lru + LRU_ACTIVE, zone, delta);
> -       }
> -
> -       /* demotion requires isolation, e.g., lru_deactivate_fn() */
> -       VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) && !lru_gen_is=
_active(lruvec, new_gen));
>  }
>
>  static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruve=
c,
> @@ -376,7 +375,8 @@ static inline bool __lru_gen_add_folio(struct lruvec =
*lruvec, struct folio *foli
>  {
>         unsigned long seq;
>         unsigned long flags;
> -       int gen =3D folio_lru_gen(folio);
> +       unsigned int refs;
> +       int gen;
>         int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
> @@ -384,7 +384,7 @@ static inline bool __lru_gen_add_folio(struct lruvec =
*lruvec, struct folio *foli
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
>         BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) !=3D MAX_NR_GENS);
> -       VM_WARN_ON_ONCE_FOLIO(gen !=3D -1, folio);
> +       VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) !=3D -1, folio);
>
>         if (folio_test_unevictable(folio) || !lrugen->enabled)
>                 return false;
> @@ -395,10 +395,12 @@ static inline bool __lru_gen_add_folio(struct lruve=
c *lruvec, struct folio *foli
>         gen =3D lru_gen_from_seq(seq);
>         flags =3D (gen + 1UL) << LRU_GEN_PGOFF;
>         /* see the comment on MIN_NR_GENS about PG_active */
> -       set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active=
), flags);
> +       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT=
(PG_active), flags);
> +       /* use the refs from the atomic snapshot to avoid raced update */
> +       refs =3D lru_get_refs_flags(flags);
>
>         lru_gen_update_size(lruvec, folio, -1, gen);
> -       if (lru_gen_is_active(lruvec, gen))
> +       if (lru_refs_is_active(refs))
>                 lru +=3D LRU_ACTIVE;
>         __update_lru_size(lruvec, lru, zone, delta);
>
> @@ -425,24 +427,33 @@ static inline bool lru_gen_add_rejected_folio(struc=
t lruvec *lruvec, struct foli
>  static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio=
 *folio, bool reclaiming)
>  {
>         unsigned long flags;
> -       int gen =3D folio_lru_gen(folio);
> +       unsigned int refs;
> +       int gen;
>         int zone =3D folio_zonenum(folio);
>         int delta =3D folio_nr_pages(folio);
>         enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE_FIL=
E;
> +       unsigned long max_seq =3D READ_ONCE(lruvec->lrugen.max_seq);
>
> +       /* Keep LRU_REFS_FLAGS: refs carry access history across isolatio=
n */
> +       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, 0);
> +       gen =3D lru_get_gen_flags(flags);
> +       refs =3D lru_get_refs_flags(flags);
>         if (gen < 0)
>                 return false;
>
>         VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
>         VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
>
> -       /* for folio_migrate_flags() */
> -       flags =3D !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_=
active) : 0;
> -       flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flag=
s);
> -       gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> +       /*
> +        * See the comment in lru_gen_folio_seq.  For migration, compacti=
on,
> +        * or any other isolation of a hot folio, try best to retain its =
gen
> +        * info. Ideally we would keep the full gen info.
> +        */
> +       if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
> +               folio_set_active(folio);
>
>         lru_gen_update_size(lruvec, folio, gen, -1);
> -       if (lru_gen_is_active(lruvec, gen))
> +       if (lru_refs_is_active(refs))
>                 lru +=3D LRU_ACTIVE;
>         __update_lru_size(lruvec, lru, zone, -delta);
>         list_del(&folio->lru);
> @@ -499,6 +510,7 @@ static __always_inline void folio_inc_lru_refs_fast(s=
truct folio *folio)
>                 return;
>         }
>
> +       BUILD_BUG_ON(LRU_REFS_REFERENCED >=3D LRU_REFS_ACTIVATED);
>         old_flags =3D READ_ONCE(*folio_flags(folio, 0));
>         do {
>                 if (lru_get_refs_flags(old_flags))
> @@ -534,7 +546,7 @@ static inline bool folio_check_lru_refs(const struct =
folio *folio)
>  static inline void folio_clear_lru_refs(struct folio *folio)
>  {
>         if (lru_gen_enabled())
> -               folio_set_lru_refs(folio, 0);
> +               folio_reset_lru_refs(folio);
>         else
>                 folio_clear_referenced(folio);
>  }

Can clear_refs race with disabling MGLRU? Once the static key is
off, it can drop refs from 3 to 2 on a folio still on a gen list.
The drain then subtracts it from inactive, though it was counted
as active.

Thanks,
Kunwu

