Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0BD7606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BupYoFHe
Received: by kanga.kvack.org (Postfix)
	id 7BE6F6B039E; Mon, 19 Oct 2026 17:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7702A6B03A0; Mon, 19 Oct 2026 17:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E376B03A1; Mon, 19 Oct 2026 17:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 225976B039E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:39:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FF2FC07F8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:39:18 +0000 (UTC)
X-FDA: 85340691996.02.90DECA1
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9F67940007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:39:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BupYoFHe;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJzhe4nxpWYjnS1kUIijOLZjXGk5ZESjjcBmYE0t6m4=;
	b=L/2nH+c65Sa2kskqQBuph47cgc2PKGIAHEYR/EFSB+TmplV8vBM+Gph7rhBvrpf8Iwztct
	ZH+W9V9lkAY7iFH0OXLivDFSFW4IcH0TykU17r5RxPmdLcxvBFnksvNceUFlKEfauXew3l
	yhO8DC5jKUQW587QBcXJKbatk3CzEno=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BupYoFHe;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792445956;
	b=IsQR9qhp1ZLpksE4ifgB8vAV5Ay7V3FqasUvBgrHJ6lfeqi9bmATPB5S8CjKKhYwaM9rsx
	7Pr5fA8cVBs8xOkOQZnaZjL+GTjjzFHQZKT4VpKkCdvGHEQZ7MFYKUlzh8kyGHeDAkFugv
	82vz3hd0y9DGFOYRzsK+OpmQ8n+1flU=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a16af2a232so18582575e9.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:39:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792445955; cv=none;
        d=google.com; s=arc-20260327;
        b=l/4v2oOuxfjhehK8Zh6OInqdcynF6cULV5FNIuRJV8BZiKGzzJQ0oFqmGC8ifkQEtp
         Te0/sU99CbegObIFuV2PFyDIrn+eN+uNcjWrAoPXyTdzVemC37+gfIG7CudldrZKE4Re
         J5YujuS45iuSFqSIu62ybeAqmL6sEsuTjbrqc3Cav4/GA4GtXQ+eyK22JjOwucM5QWcd
         XoALK5QNgJHR8cz/R6eltdvTDZQe0pdlonILQRubTOMJe4WIu4mazs5Rw/1XhEuVF1VK
         7drY9E1t7ImzM3kIOCbg6S/hdr0GpOfkKGQ5JGSiSJn1ekJRUkksXjvI87NYe7VOXcQk
         5KQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WJzhe4nxpWYjnS1kUIijOLZjXGk5ZESjjcBmYE0t6m4=;
        fh=WurW8dHvbV8D/AxJ+1OyQhIYeW7svjekyOmb9AU+6kU=;
        b=pCvbvPZujPW3r83eXXO/+7LmJQ9oILhuIbmXM+mL3SDh+ADKfZz17k/XcnjFvgI06E
         2kIO8RHg7Et7f516HRxYQcSfTHU3FrrJtmcix8ocCdh8Ev8ondizYQye2po6B8Y54E1U
         8wyUVLOjzG4tUAXoNRQprVLajPFBwX18K27Hxm2+1auGYdiSz0h+XsPTNxyOvf4ontTq
         3BCbj+mdGQjClGcv9tibcj1BuAyU9xVRVca34Sl9vGAgO3lkPt+KXkfiNso/Av3pgPyI
         vQNPHWh1cOwx54w+XS3rvt6hN5jYj8HdI7JKN0SJz/g2R+9bi9jyoGbOX5Isvjc1VrSF
         itSA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792445955; x=1793050755; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WJzhe4nxpWYjnS1kUIijOLZjXGk5ZESjjcBmYE0t6m4=;
        b=BupYoFHe0nWeZUsPDG1pLMjR+/z8CqwQyOfDxXw4718wjmnjUAXR+0ViOmJ0tPgE7L
         fyUut8jW4VIGXqmKvdSFJdzKIUIdrHBWvtbYtZ40+kKe8D0jIODCovcYMVFcpBuqoYZP
         pxPL1OaIP0bKK76WcF5F+CDcJGdvlTvtgmzp2tDcFQWoL7APkIBklZ4IK4ohJtKnalSB
         d/mLThY1clu+DmCSvoua9L/ZG5d8md2SHN4cf8WU/o5v8iProxUrF9EqSpDjiuUWTRQ4
         yW4o1VVfY9d6LCK4iU0ox5kHv/wdrYSzCxyLXN6IZg2oG7UIGqzloCVxTqJcKiMvf53n
         g8eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445955; x=1793050755;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WJzhe4nxpWYjnS1kUIijOLZjXGk5ZESjjcBmYE0t6m4=;
        b=SgbxOV0zrGCpPmtXxDVjmLglafWz8Zg1diRZPsR4KyhetTyHOZnyk/wCeZynVi7CyT
         yj3AdDb0jG8mNXKwegNZ5Ml2FWgI46+Uf3bvKNI3Q3qbritxV9ewOmCjQkAXKDqjIFc1
         5d2k7phOELy8+8nWUv/lAjMsfoTBDZKSDFRvoOQn+iO+va5WehXME1Os2LOpPxcwmLqq
         vNn9M5AYO0VWYZ64nE9EsByfh5alLxBRXO0sU21c5n98ZF9ICaQzyQSqjQaPuyV2GXPD
         PbuDZB2e1Mgp1LIt8FDsoysyrhyffzfrWpWogaYiYPTgQdpZCnxaEqBZLVr6AIHvaidj
         bs9Q==
X-Forwarded-Encrypted: i=1; AKwUvBxeWS08s/TyOIwvGXRjuKQnCBdo0ny4gTobl4Ka2H29FxUJtSCd8KbaclvH59UMw+NN0Xe+/TbzRA==@kvack.org
X-Gm-Message-State: AFq9FYJGpW01nxmTplNHlAxDO5XpZBSHiQWrlwSJesqL7DhXYSExi6PB
	e6CF0HgWMSdpkBszM0dSbIpyTNwhG+2jNY0VKMAcWa5Ftgetufqjz0G07MW1giqku6JJv6Gntb8
	cM5TrcuQQvdK0aOtG42H/fuV4gnMMoYc=
X-Gm-Gg: AYBFou22ertn5JNo8S+18CajjUCh82j4ue2pukqSDn9rEXRnXvBsZ5UQ42X7H4tJVO+
	1zDwP/YQyB57IhBa1DcNvaeygmLVGjKEYkyAf95Yd/NQ7tObqd4ez090k9zOb/TdhzSGCqbfWnJ
	gQkaH6NuTbCizqlT3YMGBY1u5gth24VeMG3ook0PIPZ0gUIqOa5jsb4ZL0HbgQUo8oNECIf+bCj
	TO3oYXy331y/CVFJWNVqlY8frdZ+4WzEQaYTt5BVo7ejgJtdytNVQUOrPk+XA6EoqrG3P3MpT7Z
	B6Lx4XFU0v0TkbX/NYnecQ9swTxiZCjd6FvL4BC1qDHokyP72/2itDVIobErL/f+rDuX6G7b8/s
	WOwroYoPowO3dfokwVtiAwh4Gnl/nWgBFtd42HQ==
X-Received: by 2002:a05:600c:1395:b0:4a1:d73d:4137 with SMTP id
 5b1f17b1804b1-4a1d760f94dmr205124495e9.28.1792445955038; Mon, 19 Oct 2026
 14:39:15 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261017004555.2890038-1-joannelkoong@gmail.com>
 <19d5b7cc-782f-44b1-8ec9-a1764484f10f@linux.dev> <CAGsJ_4yME1gdFCq4jXCK7tYiQKiV-CsRMLM7vz9L_69OkMaZ0w@mail.gmail.com>
In-Reply-To: <CAGsJ_4yME1gdFCq4jXCK7tYiQKiV-CsRMLM7vz9L_69OkMaZ0w@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 19 Oct 2026 14:39:02 -0700
X-Gm-Features: AclHuK8aR4AtoU9dfoB9QBTZ-6L98biucHkBCR_qOSkgIeSz2RTpj2-_dZ9c85I
Message-ID: <CAJnrk1at_8WWjyc5FXcZ_DbSn4-V7CAYEs4GOH+8Lrws0iE0CQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm: unqueue deferred split folios outside the lruvec lock
To: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9F67940007
X-Stat-Signature: hg6armd4p5uac7fg9wtnppmcr93dpm7u
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792445956-991989
X-HE-Meta: U2FsdGVkX18BB04sFHHkzszuYiVdMmXgq+004vPQU4LbaabcknKrUmSMZBr0wJEJrJkpTwcYGqt9L3hu6zOOgulUwD6M9Exo+8PfPBtVtqilBt1yCbSqWsaXLD6uS7lS7lvb5AcWYm3K2wwxm1HTzrz0aFqh50kGiUoxaqE2YJk57Vb6sdI9e1DEodMpmBb5/LNVtpQdrssTPz7IvQ6TKWUqFqAlsMrO/pohC+nG+CLqzaOh6/7NXy0E9qpUENxUT9VkiBocxNZAXj7q1d6t6mxdUrAv9IoMzByf3TzTB70T7d4vA/1wR6+o5seDA8yWmfUlXJ2ZsH+tI6DfQMsOVAOy2A9cAoijVBxQciNubnlPretoBMEVy/sGvSAIExk9bsOPzLWl4yc0nRL6V8jPu5U5ZsKp2oMjalpB/Y0qgi6uQbWdWHX5M0wJaWVwzB+146e6mZJmuFZZCG3Jjs7dvT2k7JTuH3ssgkPNzDIobn0CnIeMNCER9aVxWGxczhG4pBJq6MFGUnWAu3LOC29tpSs3SQ4TRs8Bh1TKstrReKOoqaSgYZwKMmHAxkcA6zdi8MGj/gTlh4wzKDWX2wKOYdp0VaWGjFLqL40PF0QWZ920Qn79drPzuecXuUS9BhhvbjGWotLSFZ495p7AjurItAO6rVLDkox5t1R3+0c+4LwwJbbkkr9PcnXCy03JPAGXk35XiwP4yaMC+zjh5/bzs6q2d3A2j8zLPiojfYB0tK+kob7lAp2uLVRUmui1ZYYsYXenibKDVkymTwZHtpQVjVwUqpAJq8iyawi2m3RqJfi0B+aqfa6aPhdSE60uXhx5u3I3wBJ2L9GVAg40ti3XFHK8gud5442Bq4mxWRuK6+gFH2jA3Kmf6jtaz748imJUrxea4A27yyrx/v8IIYtPSfS2ChnLCw56hJmYcHiEHHehVOjKwz59FmXxpnL2NTs880AIX3Y/sjXjAp1q5j4
 TS2JY9hU
 goFqqtzy7X4GbMfLAhUtCnSRJU3MVs6v+EjljN8C2otNtVgNHKY+OFWXOxPcSDCzV2BPcZQtLvmMm5EOg53hrcwsrI1/oX5vD60RMN06X5fakL/QNV+xg9fiNNG0cIk7IyzczD2uBH4MG09Lw5hCQQdK5vLnHakxEIn5NRKoOWGe2WSLf51U3sLR3IcVy5bdbhbod3jrh0WSolmYHIIKYvvtZ0LVNMkWqhVT0ZPh4f9+JYv2JPwa1lfyQTtaOSyW7ozTQYBoC53bsd9kSOuUyCsAlgk+Ws82POflDNlXuYP2isutfYLePBvnjPgfyD1PdqlSc/rlV1GiWYljZq8GxGSDIA9QOfHlLnNPAbw2D70/jwPnGBYtTIS/kPc4ExYeKAen15NNhjZlh+JUb0m5hJU85+6cB7FeBoTkZhLzDpGHq98QJofWRT45NAJ+i9ltLwDvj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 18, 2026 at 10:56=E2=80=AFPM Barry Song <baohua@kernel.org> wro=
te:
>
> On Mon, Oct 19, 2026 at 1:38=E2=80=AFPM Lance Yang <lance.yang@linux.dev>=
 wrote:
> >
> >
> >
> > On 2026/10/17 08:45, Joanne Koong wrote:
> > > move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() ca=
ll
> > > folio_unqueue_deferred_split() on folios where the refcount has dropp=
ed
> > > to zero. In these paths, folio_unqueue_deferred_split() is called wit=
h
> > > the lruvec lock often held (move_folios_to_lru() always holds it and
> > > folio_batch_move_lru()/folios_put_refs() usually hold it for every fo=
lio
> > > in the batch except the first). However, it's not needed to hold the
> > > lruvec lock.
> > >
> > > The lruvec lock protects folio->lru and the reclaim LRU lists whereas
> > > the deferred split queue lives on folio->_deferred_list in
> > > deferred_split_lru. The deferred_split_lru is a list_lru with its own
> > > per-memcg per-node lock.
> > >
> > > There are already other existing callers that call
> > > folio_unqueue_deferred_split() without holding the lruvec lock (eg
> > > __folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
> > >
> > > Add folio_batch_unqueue_deferred_split() and use it in
> > > move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() t=
o
> > > unqueue each batch of zero-refcount folios from the deferred split li=
st
> > > after the lruvec lock is released and before
> > > mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
> > > critical sections, which run with IRQs disabled and are highly
> > > contended.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > > This patch came out of a discussion about splitting underused mTHP fo=
lios [1],
> > > where queueing small mTHP folios on the deferred split list was found=
 to
> > > regress Barry's fault microbenchmark. The cost turned out to be the u=
nqueue
> > > running under the lruvec lock rather than contention on the deferred =
split
> > > queue itself. Testing this patch on top of the series in [1] with the=
 same
> > > microbenchmark, queueing every 16k folio went from a 15% runtime cost=
 to
> > > noise, with lruvec lock wait dropping from 491 seconds to 38 seconds =
(most of
> > > that contention then moves to the deferred split list_lru lock, but r=
untime
> > > still drops back to the unqueued baseline).
> >
> > Looks great :) Could you also keep the benchmark results above the '---=
'?
> > They'd be useful to have in the changelog, along with the test setup.
>
> +1. I guess Joanne didn't include it in the changelog because the benchma=
rk
> depends on her patchset, which hasn't been merged into mainline yet. But =
it
> should be fine to include the relevant details in the changelog since the=
re
> is already a link to Joanne's patchset.
>
> Joanne, could you also link your patchset and explain which patchset you
> used to collect the data?

Thanks for taking a look at this patch, Lance and Barry!

I will move this whole paragraph up into the commit message along with
the link to that discussion thread.

The benchmarks were for the scenario where any folio down to 16k was
queued onto the deferred split list to stress the unqueue path, but
this will not be what happens in actuality (there will be an enforced
minimum folio size of >=3D 2 MB for queueing folios onto the deferred
split list).

Thanks,
Joanne
>
> >
> > With that, LGTM!
> >
> > Reviewed-by: Lance Yang <lance.yang@linux.dev>

