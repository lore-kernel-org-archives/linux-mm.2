Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC2E9C5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FEBE6B0088; Mon, 24 Aug 2026 08:45:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7036B009B; Mon, 24 Aug 2026 08:45:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC976B009D; Mon, 24 Aug 2026 08:45:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7196B0088
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:45:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D77CF14011B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:45:03 +0000 (UTC)
X-FDA: 85136132886.11.9CFE47E
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 13CBF40008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:45:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WootieIY;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787575502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2yHo0M2FJBuTCpqN8VZyJQ8Wot3WXvI786J1PIQoT0=;
	b=Qct758G+/GqDaj9n66Zh/NKQOh1U+H3CJ1FA2ZYMZGQlZNODymvV6jMqZ7kff12mHZFsVc
	xikJJLpB6ICiyLscKaAkyev8/NkwJGTClrUUKyr11Me5M1+ktsEJaB+57ZJt8yYqBdrUU0
	+Pl4pdZI39fNwtVRKWlPo23/3aj0FEQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WootieIY;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787575502;
	b=NHLQYeJq6FG9PwAl2X+5Z2KH+z8LWTFh2LJuDIkjGki+NKJJNgeNRBKgBA4RusKxHPNeWz
	s/6QJNlLytqf6ev8wFFiR1HknsdzMQjxHku8VVqQZ1rlJRvRrF6mCArLmTjJXXbvK6GbXk
	WjaJ7pxTyQ3qpPGxjcLcP5Rldh4kAdM=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso2401721b3a.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787575501; x=1788180301; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E2yHo0M2FJBuTCpqN8VZyJQ8Wot3WXvI786J1PIQoT0=;
        b=WootieIYZLqtsX5LA+Q14mnGD3pH2ZBuojN4pPon8ai8gKkjAyxVsgbChBWXXHAw5m
         IrWYMwv697T0uathiuYstUXoiTR2WwLKVHYVVGFNRtorVc8a1gxNBmMp9K/T0nEUP8n+
         S3liF4mW/qBNWNcg8gxs8XEMEbc8KsjeUE6NPFD/VXOAbNcHHhZBrJeZ2dv/9m7cE5n6
         bqGOvRXacAcm4kTyUykDXPUN1KN35ge47rTfkGP1OuynVX9dg1FgZw+bnFQWebpngoQT
         TFKPppYiUDW9xkpVwHwB7O4LGZMfiJM6/l5CekWmLphqUfpo3QVmQjLbT2lElDUbY9YW
         Iyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787575501; x=1788180301;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E2yHo0M2FJBuTCpqN8VZyJQ8Wot3WXvI786J1PIQoT0=;
        b=TK5vboo+TgHzjUckF/p5idvou1pM9LwntepejYJs3xRI7kOx6EqPY41H7Mmcclvy9h
         mr54PlJDvaiyTY44FhbMLdo1JcmwSOIhw8QYkct2tU0QxEL8gR5NJ0UOwx3orDPWa8wz
         lpAWhfn5fneyk0kDdXbAhVA5voa3uADPt0ld+G1u6KsjJplGeNnceiBZ7oFs5kMEBPC6
         rXbAbmHggqEIV66rkelHXXOiiD7eMRwhifEn3bwESFDKYnJZBEmYb5mx6j5EQOSNyArL
         peILp9T1Qe1auWyE8F8LhrT6kmwUrqLm6U1NZte7FQMAJr8QqXtf5YoXYMKkbmiy6OT1
         iP+w==
X-Forwarded-Encrypted: i=1; AHgh+RrtUOChbS0Ucp8/ZFYKkiUtqyiTxMkZ4O8DzY3Maqs4W7ImPhNdmuLS1q+/pDdjVro1xJmDT7/uEg==@kvack.org
X-Gm-Message-State: AFuF++mHKEdYqLWGw93imXBQe1oj4cCa+CSPSbdU1YA7HFy5T00iJxlB
	SzE4ywWwX1Wwli34XlolRP7Yclsgr02iQBXovT7akw7U+xH0SM8q8jND
X-Gm-Gg: AR+sD11hGRu+AFkvsK8Ku+o3wLw1EoCQ2WYXCWae8x7x1YFg51yUFUh7YSaEF9TCgMa
	LgiTyuz1FpF1+2kniF8w06XnipXNdnFN+LamZmyziForFR++/sHKe8PXsZWDNRs3BF9rQADJByi
	Dj+nD1/fa0gmXm49mlbcAxK1zvAhO4EavUGG/0GoHp6k+dPa5oBpDdDdABMtfa/UvPFjTqho8xr
	nYC9upcZLkw4I4A+w+cC1P/VAgusN+NUe0PYS8/EXymm0D0m9Qs+jxnRtlKnE0CRc3emYadl1GB
	3mVDhmdMyVuZTOIUw5fmNfO9iixaaJGiZWILOvEtmmTYSUV6LLVPkCJe2mm/2wbmiDQR0m6sdzM
	VpdM9a1SLlWVJxoa0VrYVZUNId4KNijNY7fVUFaC1bMhahId6DpZ782mXXwZUfd8vXAObw+CxpX
	sdbFUFeO/0aQTr8EMBIIb24kB/3ywTnWWHGVGo50UQ7urIn9XU5KM3JvAu9p/QvcQHKav7oddBe
	/CUn87SFvhiRp4PlbJoLDue
X-Received: by 2002:a05:6a00:2998:b0:848:2ab3:ddeb with SMTP id d2e1a72fcca58-851f9fc70e9mr45280869b3a.14.1787575500815;
        Mon, 24 Aug 2026 05:45:00 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8520f03b014sm1911847b3a.36.2026.08.24.05.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 05:45:00 -0700 (PDT)
Date: Mon, 24 Aug 2026 20:44:51 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
	Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] mm/mglru: move max_seq read into walk_update_folio
Message-ID: <aow8Z-fdVhy6mQ0x@KASONG-MC4>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-4-8dbbdac0d28c@tencent.com>
 <52215f41-9297-4197-982c-bec01b485bb7@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52215f41-9297-4197-982c-bec01b485bb7@linux.alibaba.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13CBF40008
X-Stat-Signature: dqwqgtmyzdw1w94cj64bfxwwzz3zhqc9
X-Rspam-User: 
X-HE-Tag: 1787575501-825284
X-HE-Meta: U2FsdGVkX1/K27nZqMVTpwFcPGCUP0qRFRMMlz46rsnoRaCBhEdYMwSm1bc95Op+qxibQ2PS8iyBeNey7YbqAQ1hK7ntTogRZ9GRLraW5D+jqXqlcIWuMufJE2kWarAdHnkwtR7Gxpi7b7VQtNNiPTadlyklBVmw8ywSjutMbSSvyMLCLFoDcsVuGMjeWlFtbe229sUc+sujOWQvf5ookIl4oYBzgHzzJKAgAdwium3nzW5e6SNE5l3eMTbLB8T6iG64DbvT5fDwLYF1ldNIUcpicHRyebA292spXbidkOT64EQIhuI5jbUD1pCLUlMDj+ph5YTSPcoBJZ8Mk0yvnbF4alxi9vhZpe88ZbuP6N9NwdQ/I4Goc7qFjOPXvyTcsi0NF8872Gc/ofu4P/QrhZXLOrAEEHl9kQtTBQFO36RjMvZ6451DOVhFne5yyBh+skXdONtsHatP6nF4/OsX1U/SJ2LB97Z9L+3eMpE0UK09NZEh5ThvabCCaqNrXWG2rjRGQzYXqJkeWvGsTGHDoUmJYMoa1r3Tk1OZxZEwxe73agSssJwfOWKGcnZYlmribSapuCsvNAI3tX21nOyOCEoDvXlJmd7TbgWO244muiXQdDEQqjVqTv2jWglZRW97zHVhXYJejqsZbCfnQnfs2ktiZo/o+zTUcvVx+K4oXE7ZO+z31ifTQdN410zhPkcb+vUnbxk8WpS6wcdNjcsTq6dIvIsgMSYfuSUNkZZ7iUZaK1XyfRAf/JVYLKEaE+ZlR1qzFF/qjp8M3IiedsnBY5VH6BXbyBJvVylInwqhPo5cH96oWxcYYRr+0wddNjzfNWMc0Jf4EVUelH2kqBq/DiirfoOhDeMFe1ajsz1EibS4sMgWipwpXynT1kMgQuj9DHvic7dvYeGAya+f43RDSUgbbwMS1PYjVxQrQEpfeyZHSUUm4BGdd+jH9L9TMC3PYRgncLfsoi0KSFX8Y3I
 mBeuyCub
 zD2SGz9S/w5nqRYcAhGCXD6Fiq4xl0B9h8aKagjDSXo0XaDVNaRlTzjmymBdhygWqEmJhtPdvh772DP9dcYE30CW8VuPSDrC0O1ZUqp1QkY+aI328XRkQCGCNyiY1FOVs31rBJjA8VmYBDVLF3/M+M/DdMCYqFlA9f1lAsTYJYmKf8GrUBLG7i4S2YLe2ScCJ9MrPSvmQ7DVeKTVa4OkT4DzJnEGyaTCYAA5R0eq5wglg5htCDxNOpIrHepB7so2W5htDHJfozJNGTByItA8Mx6eh0rZW2WamnXwhbIxpBs7PdZUTc7kh+uvb07LjoIsUBmMlAJiu3ZAP6v+Ht0aYVMV7LQKekiXtX+VJoO6mmS1phrK571cm+65VRBoQczvemzEvXzPTX48FtyGYZKH/5qCbwCT8xLilnLFQGvmRdveogR+N8wt0ujWDabjAMXUaMjmHAyy7BvrVhy4034o8JtXo+AmrhHfAUeFP0PjT6Svy3fBFLXft468UflbgD/QaOOk8Na2AHoPyiOI5DpkKF7c0CA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 05:18:51PM +0800, Baolin Wang wrote:
> 
> 
> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around()
> > each read lrugen->max_seq to compute the target generation used by
> > walk_update_folio(), then pass it as a parameter. Move the read into
> > walk_update_folio() itself so the callers no longer need to compute
> > or pass the value.
> > 
> > The max_seq read now happens once per folio update rather than once
> > per walk range, so folios always get promoted to the current youngest
> > generation.
> > 
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> > ---
> 
> LGTM. One nit below.
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> >   mm/vmscan.c | 29 ++++++++++++-----------------
> >   1 file changed, 12 insertions(+), 17 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 080132997d87..a819be6b7ae9 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3517,13 +3517,15 @@ static bool suitable_to_scan(int total, int young)
> >   }
> >   static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
> > -		struct folio *folio, int new_gen, bool dirty)
> > +			      struct lruvec *lruvec, struct folio *folio, bool dirty)
> 
> IIRC, MM maintainers prefer 2 tabs, which is why I changed this earlier:)

Thanks for the info! I'll keep this line untouched then, my editors auto
indent always align any code I touched to the open bracket that's why this
line is changed :)

