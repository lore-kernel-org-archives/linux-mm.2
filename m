Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CAC0606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AuMztE1T
Received: by kanga.kvack.org (Postfix)
	id 23ECB6B05B0; Thu, 26 Nov 2026 07:47:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EFCE6B05B1; Thu, 26 Nov 2026 07:47:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105666B05B2; Thu, 26 Nov 2026 07:47:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE7796B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:47:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D50A16041D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:47:48 +0000 (UTC)
X-FDA: 85477247016.03.F0BDE20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 965551C000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:47:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AuMztE1T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795697266;
	b=PC8AYOovN160bETYzH82aiifGqSTUE9zbwHNHlgmIKuy9dUNApIWHlmuFbFfNK8MxhWlNO
	vS6FJUWljFV9N64QR8wALODBxKmTy5FYaKmsFxq7hgtED0janMdG4h8N4jRTJurUd45Unk
	gpBGLrl78voCHDYN2257Ycxkkdsq0uM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795697266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tBAqiQiOxYCZoK9nCXRu+3dsu5raKc79b1ne4mUM0XY=;
	b=CoBfcKCQpzAg3Q6Y4IUwly9Vm1IAX+9tH3G96dZmCLHqIRUKbl6w3j8q/L6VwEzpwP1HSC
	jnSvyRzJAe6VupFvpf43Rl264hwbRoOhGtTpfuIvO903vXzFya2V1rxpakj8ZCJ4MjjAl5
	mpEATYpXnq6jvIyrFT6wqx4+5LP+dTg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AuMztE1T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1753A437D9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65C91F000EB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795697264;
	bh=tBAqiQiOxYCZoK9nCXRu+3dsu5raKc79b1ne4mUM0XY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AuMztE1T3A1Zo6C4Gh5kMMrh7yrbkofXiRKXLjg6PfKQUk2Mgf2hL6xUQtxA0o8Kv
	 cyggoOimF4DaoXewKg+tKMXxpWM9H4WNoD7iqZ6CUJ9DaLrwheU2wUa94LUVTGg8Ra
	 dGqQvFgCdHIR5S2chQGkJk8OoW2um5SZTU3YMNYjgWnk/jt51/t4fwB4AMmaV5baUB
	 aMu9+/3l6onU5LF3Y5aB5XswbKj0sNO5gEeQV6hCfYHod84mIXYULRBX2GEDbJkXIo
	 9jq0Pgcus92m50rE3OH7RE/ZlCiBMFHFgdY4fo0aPWczaw50q7ywmn06Ojriutvs72
	 3Nj/pKuACUnSw==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9495d543c42so695519785a.3
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:47:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFSxqBubxbooPgB2JxFOhYey6eyEzRxLuizBRkKSmZtpcQvpuPyFXNHfOTOuiVsP1DiN/ZEToo2jg==@kvack.org
X-Gm-Message-State: APuU4Z9fnoK4c9/VUFpay6CyGeYcXsht5m83AiIARsv/72/17+8nEMra
	cguFS8qkF4L9gTLu9/gXHe0zT1ub/4OnJWSsQuQBEgN7je2X4z0eUDz7gRJ0kCXP9BvxwEWSkoo
	tHuxHPt/mpPqxqrlzgJZEO4/wYa+yGH4=
X-Received: by 2002:a05:620a:130f:b0:949:7b40:5678 with SMTP id
 af79cd13be357-949ba9e19a8mr3686714285a.53.1795697264193; Thu, 26 Nov 2026
 04:47:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261125094056.3973331-1-ridong.chen@linux.dev>
 <20261125094056.3973331-2-ridong.chen@linux.dev> <CAGsJ_4x1k+-HtNU7zCPcsKwYyYfiW95+Jxrd-SvCWZm8Sq6B0A@mail.gmail.com>
 <d61f15b0-6546-4a11-a749-3c27d743df00@linux.dev>
In-Reply-To: <d61f15b0-6546-4a11-a749-3c27d743df00@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 26 Nov 2026 20:47:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wu7dXwcW3dyrqgugXR6uY86oaieprQq0RuDt+=1g55Cw@mail.gmail.com>
X-Gm-Features: Aa3M54rl8hefGIl9ATnsGgsWUNtXE6r7sZtBGXQinkEhRuGjw5tWjKPjh9TWARk
Message-ID: <CAGsJ_4wu7dXwcW3dyrqgugXR6uY86oaieprQq0RuDt+=1g55Cw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/mglru: pass a seq range to lru_gen_add_folio()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 965551C000A
X-Stat-Signature: 94eox3eeicizexhajqhgfbsw7yxfhzzy
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795697266-964024
X-HE-Meta: U2FsdGVkX1/2Bc5j4xz99ylEkFHy9uTyGXAncuUtAjtUe05+lCZbmN+ECWvMk9gEowwxoRtT7+RjaZ3P1Rpgq5J0bScP3udu1mo7FcdB7ahCWJNp2V/TVQSh+jKOur7rZiya18DqBHBSC2sDmLsXMv0NYJIHaKmRcWDyGF7UDdD6YslOiB9BayMyD67HJjNiDq00RHBMWusySNZC4yauBL+B5qUhy3jZtMlVyHN3W/7GPdZvX89uCN6hfz3T1jREctWK8wlZhJi+yX6Uvm7gzWWiMFhFcLygAVn3wxmPbh+qfpdv4vQd2zePXOwSKLJUaI/Sl0/Ol6h/BptPwhKfaC3XYOknf+mAKGv8ur0qT9cfwHkHYJl9OZXQWLPKbttYaaTwXqEROohUZtoOefpa39lVzdHiQGsbixX8wuVJUuj/cfxBNWrjK9tulTo0zldE7q12M+gvDOYWWvrT+Y4YSBN+NyO8im1NHZ33XJWMb7OlPGwd39e+np6C8752hpri3kUVqKD+YmAFuo1lzAuHz2vj9xP2wMFHnHmwU5UajkybNV4w4Ufw1lNfnHKt+HRAdTFXsA61DuHB2oz1J320J8HaG4ordc/Fx3eysVrpgl7wPXbbrV2K5W1fptxJQnmq3uCf9vfQ9jsVZRG0QlstRmvuAu7KJFGkZoDhx+zdh8+1RCQn6cL4uS+aFlutV5KKNe1eM2TSEKtGE1C8Y7iY4hDzzEPpXvENiOPprFE2IieaLgTh/0+6mPHp2wu8l4nwUkc4cdaU5U6YT/JgKOq33Mnv0F/SahMu9daxasBaoOimXFqTbtH2lvU5FP4Vstu9ngLDTw7j5OKOdIcSBiBEhoI2PztQ4hC8PN0YXljZpZwGJ2R3inCTpgQOgFzh8SelVYn3L+wo/sCLQWa0AJfl6MxbuJqEIDlSZC4n3c1p4fJqTlCSHCrWXuNsp1Htn/7GdB0yFUbRNnqwJ8StACf
 uZVjdajw
 YtlZr5TDfG0pNf/+7MFKFmLG5wtMMsn3f3Fw3tAbukjcMeqRHJCA/tiwM+rKBSBWO5SpNxNUe+s7mOmhy6YlnKRf39mHo/n/MAhzWs+AQnr6ZJ6VO9IqtCMF+bXal/oUqUxp6qnekOVif7BH6oxRVOmgZkm5IAWd0olv0FX/5nauEvUoBOwVOYfgqypjUZNKko7CnuuyQscNpCXoNPrmZfqMlzOJFzW5IWzZ35J4E87MA1Y6Lix4iTarsC4R421wAdFvp2yPAf9iSEg6t7rWTfuakZTwaWZYxOV1shRDnWNjFOE2/hgIq82jdIVqpxR5mYo+l0Y6W6KkYUDFCEzbkr9zRLym7tQKCcjc97U5VlVvuYfryUQqYOvrbJP1hLowIMhuCxjmkYkF5lv+pav77dWq8ztJKzlqNJfQOpoEaOgIQyEv6wD0JOAWCIkzxCLoyMQ6aM+GuTCmgA5Um5G8pMjDo8g3VUEAP2uxRKn3261hIphQMhUmtYD9OHlZfY2GvuGVrJ4TlQrhC+aP5+1Wl912bBl4kJCJgIUuHPMU/AbqFsFDT4EPmssQ/3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 10:16=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
>
>
> On 11/26/2026 7:57 AM, Barry Song wrote:
> >> +/*
> >> + * Cap the seq to [min_seq, max_seq], see MIN_SEQ_UNBOUNDED and
> >> + * MAX_SEQ_UNBOUNDED for no limit. With no limit and tail set, the fo=
lio is
> >> + * added to the tail of the oldest gen.
> >> + */
> >
> > Another option is to make tail and gen orthogonal, so that tail
> > isn't necessarily tied to the oldest gen. This would be similar
> > to the deactivate path, except that we would only need to set
> > tail here without changing gen.
> >
> > Would that approach work as well?
> >
>
> Yes, that works for me, and it is cleaner. tail will only pick the
> list end, and the two callers that pass tail=3Dtrue will pass
> min_seq[type] as max_seq to keep the folio in the oldest gen, like
> the deactivate path in patch 2. lru_gen_folio_seq() never returns a
> seq below min_seq[type], so this gives the same result as before.
>
> The changes on top of v3 would be something like:
>
> lru_gen_add_folio() drops the if/else:
>
>           seq =3D lru_gen_folio_seq(lruvec, folio);
>           seq =3D max(seq, min(min_seq, lrugen->max_seq));
>           seq =3D min(seq, max_seq);
>
> lruvec_add_folio_tail() is outside CONFIG_LRU_GEN, so it reads
> lrugen under the #ifdef:
>
> ```
> #ifdef CONFIG_LRU_GEN
>           int type =3D folio_is_file_lru(folio);
>           unsigned long seq =3D READ_ONCE(lruvec->lrugen.min_seq[type]);
>
>           if (lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED, seq,tru=
e))
>                 return;
> #endif
> ```
>
> fill_evictable() caps only the inactive folios:
>
> ```
>           max_seq =3D active ? MAX_SEQ_UNBOUNDED :
>                              READ_ONCE(lruvec->lrugen.min_seq[type]);
>           success =3D lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
>                                         max_seq, !active);
> ```
> Patch 2 stays the same.
>
> Does this look good to you? If so, I will send v4 with it.

Sounds good to me, thanks! I guess we can gradually move more code from
include/linux/mm_inline.h into mm/vmscan.h such as lruvec_add_folio,
lruvec_add_folio_tail etc.

Thanks,
Barry

