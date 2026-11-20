Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E57960A2620
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vliP/ho+
Received: by kanga.kvack.org (Postfix)
	id 5DBC96B05B2; Fri, 20 Nov 2026 04:53:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3546B05B3; Fri, 20 Nov 2026 04:53:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8C66B05B4; Fri, 20 Nov 2026 04:53:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21E0B6B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:53:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAEBE1C4720
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:53:52 +0000 (UTC)
X-FDA: 85455035904.01.0B7C052
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id C56E4120009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:53:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="vliP/ho+";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795168430;
	b=cs6F6KiTYSYIq8L0kPtPPhWJuuquyj/deJLE8O+kVsuVAWqIjTDL9Wp6xmV+3XC7MG6xRh
	+XZ8ws33b9VIkxV9++mONr5grG5f7Qj1F6nVMQkaThDWDqv4q5ESXevVSBKmoTPgju5cOT
	Z+HeGs6wIDClUQluNAYfCpt4eQZPCOk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795168430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HAfymCHccjaSnDwBzcAFu1I4f93kNUDtOAKH0uubUTk=;
	b=U9ct2P40wnrRpp1cAPOWqMuKt1K/AipYbUAdo+RdCADvcUt/P/ArkcAvEBJGem5IvcpBRy
	dBq+Is6b9eMW8DbM9XhglVhu2WpqNcJOfSBE1Kl+OCW0AawKZQlP5cLz/6nf/rEhYsjTng
	nWI3Q2mdbNJN6Xvd78PQsqFBE5kXKC8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="vliP/ho+";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb64c99d2fso7011045e9.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:53:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795168429; cv=none;
        d=google.com; s=arc-20260327;
        b=Z7tSAaN0fsYqLCnxT2XYtMKvK6GLk1SWgJO1ucXdiEQTy++ZzK1+BlWsFvdqFxYMYp
         l7LGSUEPWJHqnToeFthuk0A/QK8Db7NmWO3ljlUL8jAVZ1x7D0/augNQH/PXtYdmQMQd
         A4QYUWiN7GS4Jh3Qwkr8KxVIEnTPcz10LxPRUXfsW97JES7xrfN3EOnFYVVL88RMGrCM
         I4KdhE4+LudUOtUjXt2xi+7Wrq2ONfS3zdyaWyvnr1gVxINiZtnECaM2NA6O3YH9ZDyq
         KPHFxwkmp0J9QHOoNc8vFPw0BpF+h6i3nsTppfpxKgHvcQGHGnveRRuNG83Uqqt8sCfR
         yBzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HAfymCHccjaSnDwBzcAFu1I4f93kNUDtOAKH0uubUTk=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=oRTkv7ynAx95raBOYv61Nb1AR7NgZroLUy7Efkjfg+JBkuQTlZXWMr0AUW1g4rcCvy
         IYJqbBFTngaDaAio+2skNDM4yg8ITAi+KX9RUeWF+wVmzgDscDsQ4prDkuLTOxnlfkTe
         C357Z2izkkcJyzCVos8zm39Sv7VEndRm88x2w9BsfVbDcNgJRNJOR5rV9v8gqLOj/XPn
         Al6jJwnXyvggr0JRmSt06w4CTBjY08H9Oj6jJY1Fl+QgjiOT9NCOW3YkD4WbqvUOSzvl
         wxu3PL56Nlzl+JvLnYzMHZ3FZMogTESizS3gV1USRfJyy2DlJ5z8Ia9mfYjwrbbwV3IQ
         1OOQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795168429; x=1795773229; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HAfymCHccjaSnDwBzcAFu1I4f93kNUDtOAKH0uubUTk=;
        b=vliP/ho+oIm/cPEdx5mRXkmojAqndE4xto4ckvXSBjIfz2F5n2gF2jKKxFYNxKsUpv
         vPmESIVjF4FOI9CufuoYoBxKycls51/Z24IGagFoYC9lKzGkKr6XBYBKfIDNDadAIV6h
         zcmyqLS6b7NlAG9/uqypxktXfnJwE4uQ95coBWZMNgcd4vFSB2BRwSonVbXlPC4u0r3e
         pDL72F0K7N6KjTYf6CYkEisR0sp6BOsLmsU8V+RaV+UrPHOII8VCJ186/ysLRvEVCxhM
         xVyEM9xnZJurz0681yD6bz34d8zrbFjfDTBfaVCPVSYAmTL2Z1sFjj/YU5o7mVjKnXFq
         PdfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795168429; x=1795773229;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HAfymCHccjaSnDwBzcAFu1I4f93kNUDtOAKH0uubUTk=;
        b=G3jfsMOA5MmYX4M9wtXlcOiYUkAodfJ2Ct+cFkD/UzHJI6uez/1bC0f03T+eY/mBGB
         V+r1L5px3ynw41sQPtx5613P9HT/npkksaVDZnH2Pm+CY78kvcjIUSkWP8E6VJP5kq+a
         AMbyLw4Qs93nxPzvrd1qW7uxLt+kAce0qeUwMJAielR57affE3RcV8/L3dv6F5eUr+Fi
         WdG3NGs2SNSedaZVdqtNuKRedexoe2EacZPgXG4jjQYbAfWrQ80+HMN+mICYzG5phY8z
         GcnrHcsSkSAqMSc0hBr7L3b8o6K6pB9WTs9zKTRX/azMJbrCPsg2IIsK63+OH7QUeVwT
         Gmlg==
X-Gm-Message-State: APuU4Z8wBZHyU5zvCxh3ZeBSXAMLQsOhXPqcfjwFHGuVOjQ0+MlrG3aU
	Hyb3fLFf7BbFUlD2V74F0ek9DAINuQmIJ6df3gmPRJVb2RAUbpOWa9P+p/eVHw+tomMZpdQ6Yac
	jsLLgicwsLGt1VCG+ClX9N8ryMfmSYyI=
X-Gm-Gg: AYBFou1iEXdf82no0bmlW7jCEFcO6R8kYevwa74ykmM4FqLoKtB76ZmmVMeWArPwGgZ
	aZgS3g9wHS97m7WWVuaqevxz9Wx7jfPMr80/dqbMKQkIjn+Qnp3YqtmmZfKMtA8jqwpBWH+Ly05
	gW/1WuQCmjJ3llPYIBF/QKSr7kCiWKE7UugebqF4D1sidbfhGUADwIoVdOIScnRsND8dKajjH4a
	5lm+auuaQ0325b8UzSzN7uEftYlZcNgqeUr7Vqo/U+h2lIXCfJYoJadX8aud/5HXXykquwzViCT
	QFqMO5BNBpVWhK3Zf+gpUSnZoJTYLyVz539q9dEU0fF8kIhi5HefXAbW3aT1sf6hqhPd23kA1LH
	ygGP94+MDsVa8ZGb6Je4TmP7Cd2mu1w+KqMD6vtAI5IvD5+TzdVxO6VQiJvxpqYjD
X-Received: by 2002:a05:600c:45d4:b0:4bb:6994:abf0 with SMTP id
 5b1f17b1804b1-4bb88817d91mr55598215e9.23.1795168428776; Fri, 20 Nov 2026
 01:53:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-17-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-17-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 17:53:36 +0800
X-Gm-Features: Aa3M54qdUFU2sI5bnRLRApKXsgxmqqGXoOIYcRvpBXntBh5ayMnUgKn48bYdX08
Message-ID: <CAN_Opa9APLNic4cnohrtZ4-HcdoNvSFvnAKiC6nn+C=thbTAAA@mail.gmail.com>
Subject: Re: [PATCH v5 17/17] mm/mglru: make folio_test_workingset() work
 based on folio LRU refs
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
X-Rspamd-Queue-Id: C56E4120009
X-Stat-Signature: tnca7m7rs4f9niibqjs37xz7zpcj63a7
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795168430-555485
X-HE-Meta: U2FsdGVkX1/Qqhl85pbFpMaC0QdjCH8lp7Nklh40P4NDzGGUvXuXLmRncNEhPP3YZKadPSkKuP7nzZLbYQbdW+se5r+fs1UrGgbo24uO8+xdFHMdPAt6wrpC/hemT9cYFP51h/spzHz9HuO2wfhtUbNaBvygUyXSAjFwT/vzBPUZfRFUI1x7dNQjh5jl0R5v74lbbNvU031981DJMw3ci4UoP4MiNBtZcfH/K4GXW2KXSAoVUXVfKur2/z98OPqx8zCD1Or3L2BSdSx5mhvsykvzgw5KI1u05GgiThs4vCfe7YFRjf81xFMffITTBd9WWAQ0zuAIWTRCi14Hhb8HiIMjuSqnjuXASD+aNipxxe6aIoBT3G2fvsmsiHXFwsCE57lMEqnWkwfLNb1yQVAL7Ccqxkf1kea+XZcD6xhx9J/rn/FEAsY4opByKIXEva3QodAyrrQbyfhef1C97Cu6IKo5Qq/Yh1VEiSY3h1AQ2AMYtV79xdlU/wd2KcFATjkgYKyj303FVnQzVYY4cgTkOHalSCNlmeWlrjSQ69AebJVHoWUZioK1+KBoECtAYIfjz4/JYRTUHteZ4IQIvMCzW5FzI4V2vVupKQ4wYUP4q4ak8n57nDqJU35lAORxE61v5bHdsyLzFhn7Mys73/KCFyikpZwc+++46lKYMuao0z9MIpdKLvx6Et4BEXQalUqgfY0iKCGNYTHEv5ueROUqw1PGlP7phlltyfPLnMTQ91gJgECe2PA4I+4e+GR2udoWjpehtlcCn+t8JAkuMWsNzaHv2EyyB93ddHHXHqq5jU9P5R1Du+6oeicwndl+0Ka4SeX6yHJ5hkw4jp0JrWj7nNqQWnrwZoi1uxzAQfvruRONX4GEpFCGHsznEBmjZin4ObIO74bB3V6qxvAAq6sQ8WT+QBKCmXNdE9Xcc3B8T4dhy7q+NhOANsp1SNpCfbqV4a2bNS1XroKjoCZAUsn
 FZj0NbSr
 tTTCEhLjc1F9JFCxQk/WiJime4xbHDgczv+NuidVsPgNH0PezbT7TVTw7d+PmC3AD+prRmxWGveXDdbjqZz1mukIIVEC7+Ui3FUObnfJytgcA/4RlZUhx43jtyXmDexXCzwp7bbJBXLXzx8gYhWpJUFmkgA4OMd5q/s9XAQ5+RNGgo0+vFRE5vM08ApkFAsVUjqXEnD1ceYB/RVq91xGFWk3RChic2YqexZdh3RJxlldHvDSxYGMC4HtlF4efx580PDA703B4nkB8ExC3hgeHeUDBFZJrVoyECGRiGdSqpAK3J4WvLlmWN0jzpGC5E7X9T3dNBN5X+YnyiU45zUhYCbNwmdx3qEByD7fTCKNB+hRp2OjzKuWS47NCWoDOlMSXfz04P3jLpP/LzfoRFYL8KlzTDpROcOU2GMhOmqOmZ3Cz6ttkQkP+yqptm14kh8Dnn2uOwudBBt2WlTOSMuXJ2Uf6zk/d+7xBXc6NJiVme1+4bwYYug9WEyrZgrDkLioM6peYhq5XS2wSsBNVA7BhcQ7Rta5VtvJCwdcm0hiN2ucej9Zg+wtkRxb2qG4lc9czAMTXYpUAWsuTd0VyfgqCeXCR5I+YsjfmBSy83Jb+uz8jUjef+IGDOetBVtTddVy59+lVWMfMMn4xPVNQSQsLp1g9UAxAIP8g/f/b0TEtT+eue4BgcMLYHTph1nhx+rlbaALTordad1RI3I32CcgZ/+A+TvJEF6eVnuLHDPlSrzsXNsxuDMXtWUCw35u81fg5C1jFCKygT2FE1he/99rbXmFYHc2Qt691ZrN7w0jICIVw1bgy+vbFXUFnaYLjWrviWTeAd5EAPq/RKltCtQFwgRMMyg==
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
> folio_test_workingset() currently tests the PG_workingset bit, which
> is only the second lowest access bit of the folio LRU refs count now.
> Folios with refs 4 or 5 carry it in the LRU_REFS_MASK field
> and no longer have PG_workingset set, so the bit test misses them.
>
> folio_set_workingset() currently sets the PG_workingset bit with a
> plain set_bit(), which also over-promotes folios at a higher refs
> count: e.g. a folio at refs 4 is bumped to refs 6, advancing it
> toward LRU_REFS_MAX and an earlier generation promotion.
>
> Move the test into mm_inline.h as an inline helper based on
> folio_lru_refs(), checking refs >=3D LRU_REFS_WORKINGSET.  The set
> stays a plain PG_workingset bit operation reserved for the
> classical LRU: under MGLRU the refs count is maintained by
> folio_inc_lru_refs(), and now triggers a debug WARN when called
> while MGLRU is fully on (the switching window is exempt, as the
> classical paths legitimately run alongside MGLRU then).  The one
> PageWorkingset() user in erofs is converted to the folio helper.
>
> Under the classical LRU the refs count is not maintained, so the
> test is equivalent to the PG_workingset bit test, which is the old
> behavior.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  fs/btrfs/compression.c     |  1 +
>  fs/erofs/zdata.c           |  3 ++-
>  include/linux/mm_inline.h  | 29 +++++++++++++++++++++++++++++
>  include/linux/page-flags.h |  2 --
>  mm/filemap.c               |  1 +
>  mm/page_io.c               |  1 +
>  6 files changed, 34 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index ad90e14032db..127c5ee38979 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -8,6 +8,7 @@
>  #include <linux/file.h>
>  #include <linux/fs.h>
>  #include <linux/pagemap.h>
> +#include <linux/mm_inline.h>
>  #include <linux/folio_batch.h>
>  #include <linux/highmem.h>
>  #include <linux/kthread.h>
> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> index e981e371d6c2..34ee41e1ccdc 100644
> --- a/fs/erofs/zdata.c
> +++ b/fs/erofs/zdata.c
> @@ -6,6 +6,7 @@
>   */
>  #include "compress.h"
>  #include <linux/psi.h>
> +#include <linux/mm_inline.h>
>  #include <linux/cpuhotplug.h>
>  #include <trace/events/erofs.h>
>
> @@ -1713,7 +1714,7 @@ static void z_erofs_submit_queue(struct z_erofs_fro=
ntend *f,
>                                 DBG_BUGON(bvec.bv_len < sb->s_blocksize);
>                         }
>
> -                       if (unlikely(PageWorkingset(bvec.bv_page)) &&
> +                       if (unlikely(folio_test_workingset(page_folio(bve=
c.bv_page))) &&
>                             !memstall) {
>                                 psi_memstall_enter(&pflags);
>                                 memstall =3D 1;
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 2c6cbd0df686..a2442e49aca2 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -300,6 +300,23 @@ static inline void folio_migrate_lru_refs(struct fol=
io *new, const struct folio
>         __folio_set_lru_refs(new, folio_lru_refs(old));
>  }
>
> +/**
> + * folio_test_workingset - Test if a folio is in the workingset.
> + * @folio: the folio
> + *
> + * A folio is workingset when its LRU refs count reaches
> + * LRU_REFS_WORKINGSET. Under the classical LRU flag encoding,
> + * this is just testing the PG_workingset bit.
> + * NOTE: folio_set_workingset() must not be used under MGLRU, as the
> + * folio refs are tracked by folio_inc_lru_refs() with rules.
> + *
> + * Return: true if the folio is workingset.
> + */
> +static __always_inline bool folio_test_workingset(const struct folio *fo=
lio)
> +{
> +       return lru_refs_is_workingset(folio_lru_refs(folio));
> +}
> +
>  #ifdef CONFIG_LRU_GEN
>  static inline bool lru_refs_is_active(unsigned int refs)
>  {
> @@ -551,6 +568,18 @@ static inline void folio_clear_lru_refs(struct folio=
 *folio)
>                 folio_clear_referenced(folio);
>  }
>
> +/*
> + * For the classical LRU only: with MGLRU the PG_workingset bit is
> + * part of the folio refs count maintained by folio_inc_lru_refs(),
> + * and a raw set would corrupt it.  The switching window is exempt
> + * because the classical paths legitimately run alongside MGLRU then.
> + */
> +static __always_inline void folio_set_workingset(struct folio *folio)
> +{
> +       VM_WARN_ON_ONCE(lru_gen_enabled() && !lru_gen_switching());

Could shrink_active_list() still hit this WARN after the switch
to MGLRU completes? It can reschedule after isolating folios and
reach this setter after lru_switch is cleared.

Thanks,
Kunwu

> +       set_bit(PG_workingset, folio_flags(folio, FOLIO_HEAD_PAGE));
> +}
> +
>  static __always_inline
>  void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
>  {
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index b0ddc652e76c..f6625dc042da 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -549,8 +549,6 @@ PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru,=
 PF_HEAD)
>  FOLIO_FLAG(active, FOLIO_HEAD_PAGE)
>         __FOLIO_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
>         FOLIO_TEST_CLEAR_FLAG(active, FOLIO_HEAD_PAGE)
> -PAGEFLAG(Workingset, workingset, PF_HEAD)
> -       TESTCLEARFLAG(Workingset, workingset, PF_HEAD)
>  PAGEFLAG(Checked, checked, PF_NO_COMPOUND)        /* Used by some filesy=
stems */
>
>  /* Xen */
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 648f783454c3..2939647940c1 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -21,6 +21,7 @@
>  #include <linux/gfp.h>
>  #include <linux/mm.h>
>  #include <linux/swap.h>
> +#include <linux/mm_inline.h>
>  #include <linux/leafops.h>
>  #include <linux/syscalls.h>
>  #include <linux/mman.h>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index a57cdcf2892d..12deab296718 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -16,6 +16,7 @@
>  #include <linux/gfp.h>
>  #include <linux/pagemap.h>
>  #include <linux/swap.h>
> +#include <linux/mm_inline.h>
>  #include <linux/bio.h>
>  #include <linux/swapops.h>
>  #include <linux/writeback.h>
>
> --
> 2.56.1
>
>

