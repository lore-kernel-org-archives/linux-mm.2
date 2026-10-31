Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D270606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 21:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nv0K1geW
Received: by kanga.kvack.org (Postfix)
	id 98D806B00EF; Sat, 31 Oct 2026 17:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917136B05B1; Sat, 31 Oct 2026 17:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DEB16B05B2; Sat, 31 Oct 2026 17:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4463B6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:21:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6A9D8030F
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:21:42 +0000 (UTC)
X-FDA: 85384193244.30.D333C48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CB4F8100005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:21:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nv0K1geW;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793481701;
	b=bvTerXmQQc584SPhX1YW4tChly/U9alc/frFQiLNVTFCGvyXwMKCsYsB4KwAYThCzmDS1u
	P9taCRbExQSuhZ1bEgzuklokf1EV6Z1cnkYn3DEmDb8WRhSLmV+m1BueSxDbwVDG+B0KDH
	BzxNaNa5tox9EjosZECqoSw3LIGxlMY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nv0K1geW;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793481701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ty94gSbhmDD5BIMgrsH4AK83dBi7LvnXvW0bmqOEn6Q=;
	b=7WZunN1DUhBY6gkwAuqrP2hqPk6BcdcpmVVOVojAoNBKI+XUzS5Wir8yi82qxgzqtOWQ4U
	SfTJcvjyaqU7Tdj5FhwjM6xi5ovRthZbgVaAeJQpFGT91py52hW7KyhEeDoPeUMiUsUAHA
	jHgBfyuarR74qVrZM+BshEbesx0BBE8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0606F43F29
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5E61F00A1E
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793481699;
	bh=ty94gSbhmDD5BIMgrsH4AK83dBi7LvnXvW0bmqOEn6Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Nv0K1geWEW21EP+164tZ9ZkJwnFe5As405lOGWO05ZYOg7Lx1i0lmjU6Jao8qCyQN
	 6kkf86pcNxo+ywvYPj/rGZsWRf2MvqsJhX0nC5iDudHzpU5LqtDe5A1F3HPiGUNfuA
	 JaYI205jkw6gNuzTRwyhonMiz41vd3QmhBZRPfMkgoPHlFN6SKGKDPF9Y28Se0elkA
	 8bFMZB5SOE/Ny2FWsDfPWdDLl5BjKKJilm6NBMqz966pnvFjTio5w0uqC2dtoMPEWT
	 ott9wyW7S7gZPTyupY7DCxiVQVwg6XHctY5+AOUqjVKUb+QGQwCNA7hxm5IKr/ulxd
	 zjgRTUm2h8X+w==
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5364c951da4so17792981cf.1
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 14:21:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBycyeYGFstwyXPOj2BJopAaak/DHKAoDG2ny5upQrs9zA7NUDT0q8K8shKICsutZ0b1vypdVhJeQg==@kvack.org
X-Gm-Message-State: AFq9FYKBS5HdJgCyOGz8ZmD/xg6TpVvQcjERpXPnVwyOwc54G2qZY7N6
	9MU2knh1PGTffOjeAB7YVUcmLrB1QbdsFzc/TujCJAWNydFh5qACtBJyH2Ij6miQM+zTEmyQDxd
	lZEwPYv9fooolz9tx+r7BJc4ES+pSw8U=
X-Received: by 2002:a05:620a:1a04:b0:93e:7939:acd0 with SMTP id
 af79cd13be357-944216bd289mr1066244785a.37.1793481699158; Sat, 31 Oct 2026
 14:21:39 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261031090041.58574-1-ridong.chen@linux.dev> <20261031090041.58574-7-ridong.chen@linux.dev>
In-Reply-To: <20261031090041.58574-7-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 1 Nov 2026 05:21:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zUbkFXBhAesVV74-Ndga5f6xEbestK7Qinqddip8xBrw@mail.gmail.com>
X-Gm-Features: AclHuK9WNH9aLICSgSeVZV5too_5MSDmgtyvPVk6Q01fvL_ZF8MPvPlJAdKgm4w
Message-ID: <CAGsJ_4zUbkFXBhAesVV74-Ndga5f6xEbestK7Qinqddip8xBrw@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] mm/mglru: add tracepoint for inc_max_seq()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: CB4F8100005
X-Stat-Signature: 5761mia36yrqob9wky6hum84z6yxp7no
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793481700-705191
X-HE-Meta: U2FsdGVkX19AgTmdLTqKaY8a5+vciGXmgT6OU/+dQmfduhiHFmIqDg7fW5N7AVf55ONlBc3OrdyjjqFZcigWrgJOPXmefwOncwNwvnMf8ksIEJdB/kOGTWTBTE/juxe5tQUjyeYYpRKyfTJpXtK63DFBBzEFAF8DQFr+jYLv2x34s3hLyN1pkTdt6x0/1hTkJYrVF5AkXvdu0DLga4QNnlxsVDQsK+YkklFNuy48oJ4MYpuNqRxOtA8Pa6uQ3d+ETMXQdZYgMEaEo6bACuVPDSbz3d8Yby+8tDLe/2SIp+XjPPvGgGZHLpOYX+ycNiOZvMi1PE33ICGQ9xugRIVTVNOi/0HYRAHbmK81tkmr9HVqMHh1AKEd5JMe0SHSVYPR0f5geQE92I0AlZ0vYBjVn4tUw7OSFjnSOOfPFruk+EmDoGd3FAxLtXPGZgDSGm8v5rGU+SinAUvYJncxlHKqCl68GUVFgjwsUFSQfb+xh6jpedUqFbywQzNCxbF/jy+vZfS9ylM1NufCp/XmXTll4xRw+nsdp/r6dQP8tVrzkvdf7X+nJx17ucNUcuOtZVHyynwbg1xp9ksXaxW5yfZ/iFQ1RmqEZmhK5vB/Igx0y5/gI79xCNcagOJFjdcZSYBf8Kc2KFrV/fUUEWk7Z4gCd8ITsnuXqZqOgR9yihNprwkpSMWw6y1b6NxZKmlTw5nE05ZEPmm5XLdSQEt27naQE0yIDb5CopJ7MEay32ke4Vlz+KbBRzjugg3pCC3bFHEHCST046P48K+x/j+BBC+1NZ3OPBF4IL9vFZ+E4DM+qPZrZf3/dDQLHdjpZTQsCtDWMKAd16SD/us1UA21+DalaCiP+pY1tVhJHo6US5P7p4ONcNJlCwR53DcxgId5GcCSFnRhEsM6AxRCQ93k5deUZq8CY3y9jBEQUulNtK0Cb2mcalhopA3ioobDE+oN0ExxsMt6iMdmULl26JGFyGx
 HGmgb2xV
 S5om7B0IdGPS2k3dLq7ul+NddWW6c/zrrC4hUTReNk5JTF9JJt1HBYCG4sZ81kytTu6M+8cs1HBtb2TNMZlUY3+I5F+LDeQZqD1O8rrCS8OtBnKzkpNq+MTDD05F8h6KO6eM+IxeUulih/rKGAf2FkvSGES4k60T/+0/YWbifOUUa9KZG9NO6w7PVFaPt7pna4xKKJYpr1VS9O6J807ToXB5EiNgOqOqqaoHM8atTejPcdZvUvHDCn8qojodZNarFpa6gNGVB13S80YvXUHPAYfGrNnywVDmZ2V/xPF9O0P6j7gEsnCzl/vPBV7mtgNysv9PBs5GYDpff/b/rEsJ1nHA4IqVBBGYWdXAtocWisCWZuA2OlMRdHWyT41dtf/X/5EwQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 5:02=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
> youngest generation. There is currently no tracepoint on this path, so
> the moment a new generation is created, and how the min_seq of each type
> trails behind it, cannot be observed as it happens.
>
> Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped while
> the lruvec lock is still held, with the node id, memcg id, the new
> max_seq, the anon and file min_seq, and the number of pages in each
> generation for both types, summed over zones and clamped to >=3D 0 the
> same way the debugfs lru_gen file reports them. The nr_anon/nr_file
> arrays are indexed by generation slot, so the emitted max_seq/min_seq
> say which slot holds which seq. They are printed with __print_array(),
> so the output is hex and its length follows MAX_NR_GENS automatically.
>
> Only the lruvec is passed in; all of the above is collected in
> TP_fast_assign(), so inc_max_seq() does no extra work when the event is
> disabled. Paired with mm_mglru_scan_folios it makes the full
> aging-to-eviction window observable per memcg.
>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/trace_vmscan.h | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c       |  2 ++
>  2 files changed, 49 insertions(+)
>
> diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
> index 8148b8224422..cddf42b5849a 100644
> --- a/mm/trace_vmscan.h
> +++ b/mm/trace_vmscan.h
> @@ -456,6 +456,53 @@ TRACE_EVENT(mm_mglru_scan_folios,
>                 __entry->min_seq)
>  );
>
> +TRACE_EVENT(mm_mglru_inc_max_seq,
> +
> +       TP_PROTO(struct lruvec *lruvec),
> +
> +       TP_ARGS(lruvec),
> +
> +       TP_STRUCT__entry(
> +               __field(u64, memcg_id)
> +               __field(unsigned long, max_seq)
> +               __field(unsigned long, anon_min_seq)
> +               __field(unsigned long, file_min_seq)
> +               __array(unsigned long, nr_anon, MAX_NR_GENS)
> +               __array(unsigned long, nr_file, MAX_NR_GENS)
> +               __field(int, nid)
> +       ),
> +
> +       TP_fast_assign(
> +               struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
> +               int gen, zone;
> +
> +               __entry->memcg_id =3D mem_cgroup_id(lruvec_memcg(lruvec))=
;
> +               __entry->max_seq =3D lrugen->max_seq;
> +               __entry->anon_min_seq =3D lrugen->min_seq[LRU_GEN_ANON];
> +               __entry->file_min_seq =3D lrugen->min_seq[LRU_GEN_FILE];
> +               /* summed over zones and clamped to >=3D 0, as debugfs lr=
u_gen does */
> +               for (gen =3D 0; gen < MAX_NR_GENS; gen++) {
> +                       __entry->nr_anon[gen] =3D 0;
> +                       __entry->nr_file[gen] =3D 0;
> +                       for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> +                               __entry->nr_anon[gen] +=3D
> +                                       max(lrugen->nr_pages[gen][LRU_GEN=
_ANON][zone], 0L);
> +                               __entry->nr_file[gen] +=3D
> +                                       max(lrugen->nr_pages[gen][LRU_GEN=
_FILE][zone], 0L);
> +                       }
> +               }

I feel this is wrong. Can we calculate the newest and
oldest generations from seq, then print them in order
from newest to oldest?

The nr_pages[] array isn't ordered from newest to
oldest or vice versa, as we have:

static inline int lru_gen_from_seq(unsigned long seq)
{
        return seq % MAX_NR_GENS;
}

And I added a helper here:
https://lore.kernel.org/linux-mm/20261022220203.91911-11-baohua@kernel.org/

+static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
+ int type, unsigned long seq)
+{
+     int gen =3D lru_gen_from_seq(seq);
+     unsigned long size =3D 0;
+
+     for (int zone =3D 0; zone < MAX_NR_ZONES; zone++)
+          size +=3D max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+     return size;
+}

Maybe you could port it here as a separate patch so it
can land earlier as part of your tracepoints series. We
could then use it in the next version of the swappiness
series.

Best,
Barry

