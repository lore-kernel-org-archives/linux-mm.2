Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A73CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29EE26B0092; Wed, 13 May 2026 05:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2766B6B0093; Wed, 13 May 2026 05:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18CF36B0095; Wed, 13 May 2026 05:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE1F6B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:43:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AEE0AA0794
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:43:46 +0000 (UTC)
X-FDA: 84761909652.18.7D5EFD7
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id B13974000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:43:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OXj0ATuJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778665424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmMKtZcN/YKaHu46Up+XNuhQQ85wQ9nB2tV/Ne4eHcw=;
	b=iXQhixz2Lo9PqghaN1S1aGxwBDHQqXDBVCwFgFq7q+D4O09/CqKMxs2GxL2KgNuM6Xb0sA
	3xsgCnDv8EkXIAAFMZTJrW5mCknolppL6zPtzoHlDfGx0wvEVPk6v6skoOj4SfW9D/nr/w
	fXrbLG+cQKsDxr9xw+btxjcUAMevNuc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778665424; a=rsa-sha256;
	cv=pass;
	b=Y4xxHBflbeZhdwhQ8wvJ1MnyxgmmqvV9JbcNyjPSwNDflfZQ1HSDO6hAkAnLvdXQ/ROKaf
	BCkntDfnpUbIuHk9Q/4j+y6nhheYe+8LUC1JlDYJ6hqZd99GjIQeCwnXWeudGx4a5a8Wbd
	bHez7NKBvPDvhty7JlRtpF9Ba4HKynw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OXj0ATuJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-67cac5ece75so10627235a12.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 02:43:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778665423; cv=none;
        d=google.com; s=arc-20240605;
        b=Obt2Kqpv0keXJFPlcFkTCq5LyKjjIplIDpvowqtVfPMaC5QAVgu/qltXApBRY3KRm6
         nAZQgj5MubrVBnfn5ZlflPRKja5a2SuwE0fcRT54z+OnZGnIXgFlL7E6koJdUpBUNVXy
         M+0s6+BN+XMV5a5NBW8iM+oWgV0ZzzzQ1Shf7ckYFMSFCiV4/ZnX5kqsSKQ3KuqeZX6w
         qi17Wo+hXdB6eG0qMo5WxQmdCKIFx/S7jGskda6ah+lWCgrprCBRKl1uELOKYY/sy69K
         1ThDJ/0JKZRfVYBJnY8tYvx4y1DrSXGGT06VM3ofJs1MDz7a6Bl4WzQpSRn85SRvPKOF
         gVyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wmMKtZcN/YKaHu46Up+XNuhQQ85wQ9nB2tV/Ne4eHcw=;
        fh=HgvzTsTje9lnNmOaG67L9WazGxXHdaNiyuLClgLUnnw=;
        b=eBVE6H/oQw3tUi7UqT48hWg7lM1x0TZkxoPE+lxc+KXDwpyWHp0cuy28eN+eRcLew3
         6klT1ImZDKahD8z2pnxF0CjFdJwimajI6EIYbizzbtNUv+uyW42UzUzlIBL7cWNlHW1B
         3IYkzv9iR6eSqAOB42Xku78Othe6VgT0D3ApLmBQyNsXx/R65FSD2QKdTEUYZ8Qi/ilU
         8XtF8dTmPwqb+bffO3TwK8K2TGOOqm7Kgi4oRWyx+yz/o/HwWyh7bky3sVlu0b1OgMT9
         /qnvgCWkPLwU4Vky5cd8MtzMTi3tG2cbbr1A4MVb+lAnccqNpr8T9XHciFAciUG7s/yy
         Ut8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778665423; x=1779270223; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wmMKtZcN/YKaHu46Up+XNuhQQ85wQ9nB2tV/Ne4eHcw=;
        b=OXj0ATuJXLC1OmRMY0ae6FfNVibf9ptlr3mqAOQZaizAGHRomUa1yjjmWq4/8aYB6l
         UIIFiYkF/4VzD9N2LeGZ0slELFyYPgIfi7oitxnbCAkMhT3htcDKbaP5Z8oiam3lG+Ry
         bFndPfmwKPRPlL8vp09OiB8WLZt8CVo82AnAK8B1uevtCnuDzznIJWMVg8tgKSTaFMIr
         mvHe9s6FTc1tygSr2ULX4pc48x/VrwEW/8iRdYz5U2MxlIaSyC029PVV3I6UNrnptNzA
         G9QilSZ0lX44UucTVk45S1ncPkpR2dmgQh0iMWOiUyg0oB4vEZttd7K2aykIJdaQ1jtH
         A8QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778665423; x=1779270223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wmMKtZcN/YKaHu46Up+XNuhQQ85wQ9nB2tV/Ne4eHcw=;
        b=MUgH1ECJSfYcLW0D4lIcry4IHssTTPz3lzCC7xCYlIR7ZjdPRlHXy8rWNVaumljqpA
         +441YdXurngqKqsuWCjHsOC8VSxUCdQgSkl7wXhJxVy1kdZA5symr5ch9h3yuSSwEr99
         xTa6fpiQ9gkLbbX+lPEJSNIY+wJi6ZLK1SynVFz5O4OW7SpOyEwBsKgNsxLSqKCkRBmn
         XOa2Xg9EE8ZaPcfZuCDHbRW4QLQJ//prefzqeDM71N7QoYr14u1eUw6sgaiDSDTpx1HK
         hmrdxma6bC2sIyhK9RU6HVyv4E7HPf5job1vqsPbtmd2jsibj3lg6Bl24dNwF1cVJd7l
         i0GQ==
X-Gm-Message-State: AOJu0YzdGCrW58w9+5z13uqhjMKd/WZqBBTjLbBoZzHu/SPm9uYSoW9k
	rdT8pFE/xbw1KBIzgE3M8PUEhYoMsF79Ip6JrOKO+9Urm9bzX7Ayip8ZKaP+1Wki8v6UCz0/EoY
	Ba0ndCLTOq7Wc7/lOe4z4SEJFR4bm8mE=
X-Gm-Gg: Acq92OFIF4vJX6D/j4NEeQqO7F+y9P1qOLbQF/G+rwlJCOCIGn5+f9uob9iCCdCbual
	YdtNZORne2I3NA/UaCdLWPwB2ZVF3AGH9m8XrzC6x1+oXOczuqExZoMNdQPA6I8klKjfRrBrNGi
	aZf4OsH9LdyXicYTh8I00O6vcZrBSXtXMWKBLIg9UYmRJUWF1iH2ZjYhIj7nBJs9QLfGrI/lNxv
	+KY30ouJD45t8jv7lTd3b6+jqY2Pd0j5ayKtLdzJg2i33v+tpPGLEmwG/IbGsx/m1LeGLRe/em0
	0KqP3Rpa471VIV/vVh6sRVmeWJQU+bXpnSUetx3j
X-Received: by 2002:a05:6402:6da:b0:673:1d30:29b4 with SMTP id
 4fb4d7f45d1cf-6825770fb1fmr936393a12.23.1778665422620; Wed, 13 May 2026
 02:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-7-2f23759a76bc@tencent.com> <CACePvbVnDrR6e7wvpF-nf1CWgoMdX4MTf7RSv2bCr28W6d8b2A@mail.gmail.com>
In-Reply-To: <CACePvbVnDrR6e7wvpF-nf1CWgoMdX4MTf7RSv2bCr28W6d8b2A@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 13 May 2026 17:43:05 +0800
X-Gm-Features: AVHnY4KF1TVWaerUh5LwgFhK1-31OyeB_KdLMQWvEcFWc1KpjNwa0lsVGQJryeY
Message-ID: <CAMgjq7BBQf62PuUG-=rX5T50PLb7WQW2QuSj=+n5eNcMZS080A@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] mm, swap: support flexible batch freeing of
 slots in different memcgs
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B13974000D
X-Stat-Signature: sptpo5a1ruf8ygrxxfqirkn3p3z834ho
X-Rspam-User: 
X-HE-Tag: 1778665424-676208
X-HE-Meta: U2FsdGVkX18rObOf4Lj3ie8vJhDgUIAGhax+l8ewVFKd8H3/zdU+NbwMaxE5t3SKqO6r50uphFwYyx5Tpo1HpBErELKAs17NzScSNrcFlqLVb1AdExJfyNGwBLNLAL3PPPMz75fZvgWfq3U4IoHaAFaRlA2KVKdh7kdk/DsibJA+zV+TKSa5EQVFP9gwy6XUXcTAdDOBncjOdEhkdnJRsHbsuppcNTiKNkzDxW8nLuGWl9rllZbhSo0a7TwcKdgDD6GeK4qGUqChmOBslVQnBeAWAZ8+85lhXndMy6HgukeSkvnnnrmyQFnREZaWEdHhIYw4PBmt07j0IogOMBCSm1jiktkf+YAYt52+fSOmafSIV256V+FPY8jeDkCJj/0AhWafCYNBZ5tg9IQhyHgd4M4mpLdmtEvHH9x5SZV/tVjaL+O0yPlEP2L8fn8U0sQDO1NWSOGM4vOgs4nm5+dCHb39ioZlBKh4eVAw7JqvqxJUaa9sPV9OigU5Yva+Rx/7jDHMANZlPE/m2z/Mu3ZqSL1ZkRDYqDKf+QH015yab7ELM0TQtVujQ0jcq5aO1+DGKPYHJJbm222alwnu0hIL6lGhcUpAASXd3s/c8mb/urlBXMHtVGMYhykbmkPVac3fdkhvHbfAZnPx5vpylhc8Ozn8QpGvfjSoX+7x83XWzKaRNMRjO8alIE7gchnoFHCP9Wf1HkQ8fP8x+5Ue66M/0KyIYzuSiPPyTqNhvQAloXZ9YsW+3SQ+JOaUrZ6lLwr+9YTGRhEPF8zK97Si9lvptbLNdWZw+2Pw4Q/JGglfi+XWo/NPNFMKirlRCNg/+6EW3TvgvdSWOo4wwL37qOT3uCbnmeLVoQVgkVlicJDx0u8AkckYGmANKCKiMGDRYHAQaguI2pd2KMSqDS38PdoW0mQ1hhMrzBuCyRyzP9IdwA3qdvxAUloonmnrZlzv4MYyWbs5RBkCdT6jPvCKoOv
 O0B7TNRB
 bvqu/+zI6lg5b6mSls+0RmlBYi0GTCohyHp3blMNJGqg5TGZZobYinOsId1SuJL29OZjU1gHW3jl71XVegdDqwF1MKIYttCUiRBx85XH4zJt4Ov3iJRxD1KcimyJoPys91Rkrnb4ir1e7+3wFIxZkA3BfN5wGK6cAJpfJNWgwvMhMaTa+2rqr3wLq9kyNjY3/76Cb+onW+Zz2QQ0chmdNolfJGGyOZCxC7cl5EKANpZzZa88auHoMhOOsb1ySV69EIECPP73s3P8NCEMxNQWdlW0gQrOanuOD2tO3+/ShX2YK0UlvpmCaZGRRON5YXMkuSC0XcJdbIkCHfMdfB3M+4e7So7+ZrWAk8RuhQvFc5FdpcLWF3sSjO3hvlpW0yes8yI34M9mYu4qJ9jbclSuCjO16+cNd9rLG4NWkgTq5RC6rSgZbdePiTqB+V5qJLWnhOUDh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 12:01=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Apr 21, 2026 at 7:16=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Instead of requiring the caller to ensure all slots are in the same
> > memcg, make the function handle different memcgs at once.
> >
> > This is both a micro optimization and required for removing the memcg
> > lookup in the page table layer, so it can be unified at the swap layer.
> >
> > We are not removing the memcg lookup in the page table in this commit.
> > It has to be done after the memcg lookup is deferred to the swap layer.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> Overall, it looks good. Some nitpicks follow.
>
> Acked-by: Chris Li <chrisl@kernel.org>
>
> > ---
> >  mm/swapfile.c | 33 +++++++++++++++++++++++++++++----
> >  1 file changed, 29 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index e1ad77a69e54..8d3d22c463f3 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1872,21 +1872,46 @@ void __swap_cluster_free_entries(struct swap_in=
fo_struct *si,
> >                                  unsigned int ci_start, unsigned int nr=
_pages)
> >  {
> >         unsigned long old_tb;
> > +       unsigned int type =3D si->type;
> > +       unsigned short id =3D 0, id_cur;
>
> Nitpick: I'm tempted to rename a few variables to improve my
> understanding. Feel free to keep it as it is.
>
> id -> batch_id

Good idea.

>
> Nitpick: This line confused me a bit. Two offsets are mentioned here:
> "offset + ci_offset". One would assume that ci_offset is the offset of
> the ci, and the offset is the incremental one. It is the other way
> around.

This intermediate swap entry usage will be gone soon in a next commit
so I think it should be fine either way.

>
> > +               id_cur =3D lookup_swap_cgroup_id(entry);
> > +               if (id !=3D id_cur) {
> > +                       if (id)
> > +                               mem_cgroup_uncharge_swap(swp_entry(type=
, offset + ci_batch),
> > +                                                        ci_off - ci_ba=
tch);
>
> With the above rename, this become:
> "... swp_entry(type, ci_offset + batch_off)," ; This combined the
> offset turn into the swap entry.
> "ci_off - batch_off". That is the running length from the beginning of ba=
tch.
>
> > +                       id =3D id_cur;
> > +                       ci_batch =3D ci_off;
> > +               }
> >         } while (++ci_off < ci_end);
> >
> > -       mem_cgroup_uncharge_swap(swp_entry(si->type, offset), nr_pages)=
;
> > -       swap_range_free(si, offset, nr_pages);
> > +       if (id) {
>
> This becomes `if (batch_id)`, meaning if we have pending batching, we
> flush the current batch.

This part does look better. Thnaks!

>
> Chris
>

