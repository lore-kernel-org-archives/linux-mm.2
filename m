Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F44BCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 11:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 749198E0007; Mon, 10 Nov 2025 06:05:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720D68E0002; Mon, 10 Nov 2025 06:05:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D168E0007; Mon, 10 Nov 2025 06:05:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 55CB38E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:05:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1527212DBA0
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:05:05 +0000 (UTC)
X-FDA: 84094415370.17.F255C78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 30953180015
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:05:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sa6AQQ73;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762772703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57vcXoVaGnG9l4Hdh9tDUE5rwfPZ24UgvbT3aVj/BUk=;
	b=muKOBZoMnqDI4FMDiWSLrc4ueEml7S6JyL+a9j3B4xTXtPGJKajAWYgMyRtdQCwCA3gTzd
	3gjg0o/oAlfyI7iqjKTHY+9PcUR/9cvfAj8EvqzZOGFABNlnRyGBpB+mEryQ0ttcoJMllp
	cU1gf+wYpLa/n6USShokTZLFbxRCANM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762772703; a=rsa-sha256;
	cv=none;
	b=rbzpL1CXaNwhLNjDZt8nVdlEJpsIPgTsgggV/OMXj/ItiYtIfWsFRKQTfslFdtbH7U/ICG
	gVhSQRYwYPZ0hjdNsu/6zKAh2VC8pCTWcm0MtD0ChMQHXg3FhXI+H1yfXk6dPFaIu8OMuk
	4dz7S89mDe/lz9FPVWI4mmJfJSzv/sc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sa6AQQ73;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 159B2446CE
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE85DC2BCC4
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762772701;
	bh=57vcXoVaGnG9l4Hdh9tDUE5rwfPZ24UgvbT3aVj/BUk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sa6AQQ73O01w64nwho5tib1IxlyUdIJGtdtZ9Hkgxafn61iopBLbXLDF1Ba5V2i27
	 WD6YFYVerjMnAIO9/muIJYDdpv8clNUqhwoewQ/kI6xBSZ7jVC6JHroti+9tXdEs20
	 5EKZAMf9l+SFPX7I9+FCSHrvUm+bOAkz1wYS9nveGAjwkbxnr4Nd7GtPj5xjzuo5O4
	 Fc7gKbOMrlamMfMeSGiNycyH/4IkhNBrCVvNpqk+BQzuNmMhCTvf5IxMmj7iK+EaLs
	 ETWg/vuyz4jZTP7O28TnvbQhzcLZpoWBPH2g2qFYB1KLl4zsm3zT9ooSaICIThBSgK
	 PLzO/EzPnjooQ==
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-63fc6d9fde5so2594833d50.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:05:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWQqCh47jE6mDIYwNn3Nr/XtbANndYpjWKqthO2yrvskxwErIR5jo+1gAAT7I5tzxOvXGbLA7M3Yg==@kvack.org
X-Gm-Message-State: AOJu0YyieND8xYQnYWxNA47egyrs0seATgZKXEwQ8ffb/MuOwx4iHnMh
	vy1tgwT9cwavjyQzWZDQ5+5HOHighK0Qb2xV4DlJmaJ4mNemR7eZJmZEVopEfc7agkZqJ5UV/VM
	rP7NlpCyNDoja+0bh57eOS4mcKZD/fVUZMbJaFvqz+w==
X-Google-Smtp-Source: AGHT+IGb5xn+sWB6zhZvawlKpKaY52jteK/NuAWw2b6kNJUT3KOwS3xUtwezxnsh77APdSOaFVEz79TEZy9y4Ini9II=
X-Received: by 2002:a05:690e:2598:b0:63f:a089:ad11 with SMTP id
 956f58d0204a3-640d45e57f4mr5199456d50.47.1762772699777; Mon, 10 Nov 2025
 03:04:59 -0800 (PST)
MIME-Version: 1.0
References: <cover.1762621567.git.lorenzo.stoakes@oracle.com>
 <CACePvbVq3kFtrue2smXRSZ86+EuNVf6q+awQnU-n7=Q4x7U9Lw@mail.gmail.com> <5b60f6e8-7eab-4518-808a-b34331662da5@lucifer.local>
In-Reply-To: <5b60f6e8-7eab-4518-808a-b34331662da5@lucifer.local>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 10 Nov 2025 03:04:48 -0800
X-Gmail-Original-Message-ID: <CACePvbUvQu+So7OoUbJTMLODz8YDAOgWaM8A-RXFj2U_Qc-dng@mail.gmail.com>
X-Gm-Features: AWmQ_bl_ugrcb7Xqm2Eobi_WepJs_DP4Kj2CRqbuSy5_pOEO8kL68WELcSVKV30
Message-ID: <CACePvbUvQu+So7OoUbJTMLODz8YDAOgWaM8A-RXFj2U_Qc-dng@mail.gmail.com>
Subject: Re: [PATCH v2 00/16] mm: remove is_swap_[pte, pmd]() + non-swap
 entries, introduce leaf entries
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Pedro Falcato <pfalcato@suse.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 30953180015
X-Stat-Signature: azgem3ugn3aymqsa1s5fp8tkkynd7re8
X-HE-Tag: 1762772702-190116
X-HE-Meta: U2FsdGVkX19yAGzMt1DFTWJMzXJDsuFjY3K927g1CU9pMKNchH8ZafBu9Vn+Hg0jpBMNVlXfarCcrCSdR2+qxytlcbiezWnxa36X3Pgr6gJdl3+tqQMV0xXMOPNHQjO+kfCMquUshP+wAXm3q4llEYrfR0oHpzTNWUjMqbbi9v1G6iK+Ulcu4P0lh6wiekQkO/P8jrQsH0hMFMP2eBlGS1Vk+INzb4xzgCmv2JkQoBH5qAJoccgH3OxeaMWLl5Pj1x677jkxsn79R0cEBVAqImJfP9ob6FrpJCys2232EITRMVJZ/TXdSaCEioTcR3XgHselCkASw13Ah4A1VnhjlRhPXZVTK08LiO3WYoHSmyBRy023AXdoSSPW8B4nLCcMNc0GJMwIo3HrEXxWdl7UV4kWrwLZ9IlzepU3hfJIPFS5m/ofvykyFaWxbeIKF4tjPi7y8657y17xAM1F3lFck7DFhR1FWeUH1bOS3C8b3hTRDuWRxTbnPdJXNEuAWuYmQQNYB5E9mnt+v1J7EK3K8id+PhmbEWN2JarXGk8zLKs8GM+ibhRNeMo+ZZ4gbbiC2fUEaDQPjpzu8OPdQszvJp20WWAUCZcSvC5EplW8fyaH3khrvYMhynSPGMhZ/T/IJD3SdF79TT6UybivStSa8p0ZdsVoOIduEb+7NN9EShKVOq7UPDHwfSYFOycJcr1IuSVQvCj4z6N3PMl9Z/26lwCaARm5EBs9TpltaG0DtccVAqXmIfjOCHkxIS9gpOokLp9GiBjE+Lf1xkwC27653FMI73HlhAT6QcegVsg6UNYLwHGAx4pFVP7EsrqmXYcbZMGG5PnIC84abMHHc5lK61CJfcrqzzJvFk3tF7Tpzhh2CC7zauhvkJldKMLnyNf7jQqzj3M/iUHgIU0tCUr4TLLTDPYYkSkAv+Fj4iUGpqGfJ5ApX3hL5rVSEoQTaHyaNXXjbsMavf2x+u/GM8R
 x+KrZuFw
 ds9xpiwF2xTV/lFaJl2kMys0qKC9SmR76t/HpnLvHt3v2czhoIkMII4nFHuqSws1WQuhEsT8Denk59QKjk8zlhgyZ9ERc0Ob7vcxwR+xKUg5UkfQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 2:18=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Sun, Nov 09, 2025 at 11:32:09PM -0800, Chris Li wrote:
> > Hi Lorenzo,
> >
> > Sorry I was late to the party. Can you clarify that you intend to
> > remove swp_entry_t completely to softleaf_t?
> > I think for the traditional usage of the swp_entry_t, which is made up
> > of swap device type and swap device offset. Can we please keep the
> > swp_entry_t for the traditional swap system usage? The mix type can
> > stay in softleaf_t in the pte level.
>
> Ultimately it doesn't really matter - if we do entirely eliminate
> swp_entry_t, the type that we are left with for genuine swap entries will
> be _identical_ to swp_entry_t. As in bit-by-bit identical.

In that case you might just as well leave it as swp_entry_t for the
_actual_ swap code.

>
> But I did think perhaps we could maintain this type explicitly for the
> _actual_ swap code.

Exactly. Please do consider impact the actual swap

> > I kind of wish the swap system could still use swp_entry_t. At least I
> > don't see any complete reason to massively rename all the swap system
> > code if we already know the entry is the limited meaning of swap entry
> > (device + offset).
>
> Well the reason would be because we are trying to keep things consistent
> and viewing a swap entry as merely being one of the modes of a softleaf.

Your reason applies to the multi-personality non-present pte entries.
I am fine with those as softleaf. However the reasoning does not apply
to the swap entry where we already know it is for actual swap. The
multi-personality does not apply there. I see no conflict with the
swp_entry type there. I argue that it is even cleaner that the swap
codes only refer to those as swp_entry rather than softleaf because
there is no possibility that the swap entry has multi-personality.

> However I am empathetic to not wanting to create _entirely_ unnecessary
> churn here.
>
> I will actively keep you in the loop on follow up series and obviously wi=
ll
> absolutely take your opinion seriously on this.

Thank you for your consideration.

>
> I think this series overall hugely improves clarity and additionally avoi=
ds
> a bunch of unnecessary, duplicative logic that previously was required, s=
o
> is well worth the slightly-annoying-churn cost here.
>
> But when it comes to the swap code itself I will try to avoid any
> unnecessary noise.

Ack.

> One thing we were considering (discussions on previous iteration of serie=
s)
> was to have a union of different softleaf types - one of which could simp=
ly
> be swp_entry_t, meaning we get the best of both worlds, or at least
> absolutely minimal changes.

If you have a patch I would take a look and comment on it.

> > Timing is not great either. We have the swap table phase II on review
> > now. There is also phase III and phase IV on the backlog pipeline. All
> > this renaming can create unnecessary conflicts. I am pleading please
> > reduce the renaming in the swap system code for now until we can
> > figure out what is the impact to the rest of the swap table series,
> > which is the heavy lifting for swap right now. I want to draw a line
> > in the sand that, on the PTE entry side, having multiple meanings, we
> > can call it softleaft_t whatever. If we know it is the traditional
> > swap entry meaning. Keep it swp_entry_t for now until we figure out
> > the real impact.
>
> I really do empathise, having dealt with multiple conflicts and races in
> series, however I don't think it's really sensible to delay one series
> based on unmerged follow ups.

If you leave the actual swap entry (single personality) alone, I think
we can deal with the merge conflicts.

> So this series will proceed as it is.

Please clarify the "proceed as it is" regarding the actual swap code.
I hope you mean you are continuing your series, maybe with
modifications also consider my feedback. After all, you just say " But
I did think perhaps we could maintain this type explicitly for the
_actual_ swap code."

> However I'm more than happy to help resolve conflicts - if you want to se=
nd
> me any of these series off list etc. I can rebase to mm-new myself if
> that'd be helpful?

As I said above, leaving the actual swap code alone is more helpful
and I consider it cleaner as well. We can also look into incremental
change on your V2 to crave out the swap code.

>
> >
> > Does this renaming have any behavior change in the produced machine cod=
e?
>
> It shouldn't result in any meaningful change no.

That is actually the reason to give the swap table change more
priority. Just saying.

Chris

