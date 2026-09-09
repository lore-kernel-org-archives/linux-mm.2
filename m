Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A033CC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 06:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3ABA6B008A; Wed,  9 Sep 2026 02:45:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AECB76B008C; Wed,  9 Sep 2026 02:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DA6E6B0098; Wed,  9 Sep 2026 02:45:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 723926B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:45:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A99B1A0111
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:45:18 +0000 (UTC)
X-FDA: 85193287116.05.6475461
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4987F1C0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:45:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhLgczlC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788936316;
	b=2l5AKj7DXGitw15gjnpZt5ogJWwyD7QQB6VsMzuz3EzgbsWyD1OkmxXiWeLSY+mh1IwtBc
	n5+H5Bf5AN5+CXSUFOK3YD5PhAExnYsi72WfOGUhI8jHJKf+s7K15LcfZjbn5wa8uiVk8r
	0N87pidUPMWQpjNqqoqSTbn5Qp8/KbY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhLgczlC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788936316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXtI965ppSTiwbT7ipKM86YtHUyLj5gqRIWr+nTAhBA=;
	b=L4c24TSyx31eDQ2Qc9SdnYfeRVUxrz3Z/R6sWrHjCEIYUCwkMYDvTobo38uHVG4N7SKCc0
	h8V7Bz153StSI435U2TelESLfTpUhHzoJsNmTZy9KVXtycQx1CYnzPiM8JBwBARur1Sv8N
	SJGzA+KuB9mVdcA3NIYADwXPu4ML1Xg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE31D44791
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CA41F0155D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936314;
	bh=oXtI965ppSTiwbT7ipKM86YtHUyLj5gqRIWr+nTAhBA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IhLgczlCdWxFSegmkDizxcGCljjux3VJc/i0FEoY8gH2PXRUq4Ssn7Y30byvlShQN
	 gFCDQfZx7fm+duVZJvytrkcjU5b3C1wT8mzuIhcBd5/MFvOZQyvXERSN9mv0tAiSgL
	 5WRfo91cKBLXK0RSm9JXUt+1ypLzXGa+Hxid0r3sBUmNRgra8ny+lsL65oS3vB3jxA
	 uEJYCwVriFGytJVB5DZHLBxlxTvbZghw6a4Bnz3Pvg7GkJJXLdhx07aTck1sFxDWZw
	 4LFA6J5OxT6k7ridJrBHWXdlH9Ah/Ag33l3q6SpLU9s+DxJEMH8jlYgovnNHbGED7H
	 D9MjCaVN42fpA==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9399798cdd2so254795085a.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 23:45:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBymBiKzgsSHTeBWIIAYn8BdTPH5dBiYsz93MrRhV05ckDcQotUppZQllBZf6gJqt3U4b1AQC59F2w==@kvack.org
X-Gm-Message-State: AFuF++kZ53tCNgc6uINOUbCfYLh4CpdvITbF93si6WsQ4zkJ79a3yklz
	CT13T+99SYDs2zi11OowtNEvGj7qbPiaPXR6IAtwIfswFYHkjByZC9CDN+yAZrFacJBqhNlRwTY
	UXh2XojtZxeIxp64ldWz90lRcqxxe/C4=
X-Received: by 2002:a05:620a:811f:b0:939:6dea:374b with SMTP id
 af79cd13be357-939804f7c81mr2852075085a.47.1788936313658; Tue, 08 Sep 2026
 23:45:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260907042447.2450663-1-ridong.chen@linux.dev> <20260907042447.2450663-3-ridong.chen@linux.dev>
In-Reply-To: <20260907042447.2450663-3-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Wed, 9 Sep 2026 14:45:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zvJmdiicZAefUyjn4RjP=hBxE95fjpR9HM+SFJ8S_aCQ@mail.gmail.com>
X-Gm-Features: AcwNN1VgWoJtkBN10FObnIaNeshFsBlYP68mFG3ghCEpyRhlhxvLD1TMEuEii5k
Message-ID: <CAGsJ_4zvJmdiicZAefUyjn4RjP=hBxE95fjpR9HM+SFJ8S_aCQ@mail.gmail.com>
Subject: Re: [PATCH RFC 2/2] mm/mglru: add tracepoint for inc_max_seq
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4987F1C0002
X-Stat-Signature: xs3kewct8pnjdyjgi3sisw6j73dtboqg
X-HE-Tag: 1788936316-289089
X-HE-Meta: U2FsdGVkX18VOP0sPwE9SsOJwzMFTqHVqU/irJUKm3De+ok2Zw1Rpd21W4RmzhYrUxP+117xPHE7IHOCIfCeTcsqxtWQJowImiuhxy6eHqYUKV0VvteVyJ89Fvbc+tpmB18VvRFMpI4Y03JMLQtWCgG5s11E+UyPkC8HgeCoBjMwsnoBPyANTL+BEKRCa351LaNkJLOmxgFgPhpG9j5qLDH/02Wneecc9ftGK4I/z+ro277+f8//BK1pgwndic3ebQNfS0ZKPqIbnNgmQp2BBw+E/BmDwe5VAYZzWv3Pfr1KXSw2gt5HQAIdI94Uuvolpw7nDJMQK/vVgWULQLoEaxaDds/B93ErCvGslB8YekOFED9gvy+vzirCBs0DK1dByqEPaUXq0DwNion4ZfJFp0rlbR8jc4oni+V7yAQWJK9eZLk3hJT3d6YTPHsFjYqmsRhrR32csj3R89wsyUeYy3UAfUwQVLQiWB++HFrqrtVg9jXFBKD1TQScUZ3OxuzIhPzCHg7mt+a/VvH1fyICDABjf34fAAf0i7cEuitF71AVig/RIVQJNb9ta+mNPUQKSYki4pOvLN2UwfTJvpAeoDIdScUbtx6vAJthDVtviOxF6jT0hvWMMm6/O0nZ/wGqWiQ37gia1eQ965vilYBE5i56LWuzzLIXNiEe1ZzWHz0JCzyRr/UOlhE6Xsz5a3FEeL51wggMSmQCUZgYGbXQPa7wFIDmnJ9IUQiyOjQ48ISUj0PD/5roQd9P4n0BRCbwk114Os6+XUoTmOTRxt1nnj4vFJoGwSwvmJg7pg3vt0XnN1nbyD7LuxgXCR4F0tqR/vdlP2mpUIZnkmLtJxLFDH3SJeVJzSyE0OaSOIJUbHIKkLFVEn4hmynZ3dKgeX6sTya+isu+wC1k8dWo+HWqIon8P87bksAfDSjpp1mR98FOLXWJxprT2aUYCU1JUup0tdtTBG6Mmqm2cqcSKAD
 31QmlJkT
 muxyVZZxpqrvo//EAcqsVCVt5SBjyRaRCTGTsoh0mmE+BpWZHqyRzm8OMo3SZfzhNCx/ZQBmYCRictXsK1Vl+EJP9meA31sP0IJN/hiZkJNUC5SFIlHw0NQ8Ewdm2P57pqV0M7yJ99KVJcvOP4vslMpX6jpHjsEOZ31XWgkxw6f0oaCPNZu53/HgA29FKNS4nE+0Sz7Lg33vyg4CfW5hPTU9pPC5ecdYjNhRJw8nV5kVD96/+20vNMe8OtgTeetU54O86iVfkS01wFeC5S/043ndD9jrxKTW+bbof2Qw/h/lZwy6114Ct4ICNHyW2Y9vddZrdBn9846r72yGYM72CoiAyvrcAFvktMerAxoR4zOrY5Wg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 12:25=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
> youngest generation. There is currently no tracepoint on this path, so
> the moment a new generation is created, and how the min_seq of each type
> trails behind it, cannot be observed as it happens.
>
> Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped, with
> the memcg id and the new max_seq alongside the anon and file min_seq.
> Paired with the mm_mglru_isolate_folios tracepoint it makes the full
> aging-to-eviction window observable per memcg.
>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  include/trace/events/vmscan.h | 30 ++++++++++++++++++++++++++++++
>  mm/vmscan.c                   |  4 ++++
>  2 files changed, 34 insertions(+)
>
> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.=
h
> index a0e3cf75294b..ab93c2f4b318 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -439,6 +439,36 @@ TRACE_EVENT(mm_mglru_isolate_folios,
>                 __entry->max_seq)
>  );
>
> +TRACE_EVENT(mm_mglru_inc_max_seq,
> +
> +       TP_PROTO(u64 memcg_id,
> +               unsigned long max_seq,
> +               unsigned long anon_min_seq,
> +               unsigned long file_min_seq),
> +
> +       TP_ARGS(memcg_id, max_seq, anon_min_seq, file_min_seq),
> +
> +       TP_STRUCT__entry(
> +               __field(u64, memcg_id)
> +               __field(unsigned long, max_seq)
> +               __field(unsigned long, anon_min_seq)
> +               __field(unsigned long, file_min_seq)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->memcg_id =3D memcg_id;
> +               __entry->max_seq =3D max_seq;
> +               __entry->anon_min_seq =3D anon_min_seq;
> +               __entry->file_min_seq =3D file_min_seq;
> +       ),
> +
> +       TP_printk("memcg_id=3D%llu max_seq=3D%lu anon_min_seq=3D%lu file_=
min_seq=3D%lu",
> +               __entry->memcg_id,
> +               __entry->max_seq,
> +               __entry->anon_min_seq,
> +               __entry->file_min_seq)
> +);
> +
>  TRACE_EVENT(mm_vmscan_write_folio,
>
>         TP_PROTO(struct folio *folio),
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 771fe6827939..3c806a57d113 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4065,6 +4065,10 @@ static bool inc_max_seq(struct lruvec *lruvec, uns=
igned long seq, int swappiness
>         WRITE_ONCE(lrugen->timestamps[next], jiffies);
>         /* make sure preceding modifications appear */
>         smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
> +       trace_mm_mglru_inc_max_seq(mem_cgroup_id(lruvec_memcg(lruvec)),
> +                                  lrugen->max_seq,
> +                                  lrugen->min_seq[LRU_GEN_ANON],
> +                                  lrugen->min_seq[LRU_GEN_FILE]);

I suspect we also want to know the number of pages in each generation,
similar to:

/sys/kernel/debug # cat lru_gen
memcg 1 /
 node     0
          0      25672          0          85
          1      25672          0        4249
          2      25672         21           0
          3      25672          0           0
memcg 19 /A
 node     0
          0      23036          0           0
          1      23036          0           0
          2      23036          0           0
          3      23036          0           0

Best Regards
Barry

