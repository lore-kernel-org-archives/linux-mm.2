Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E527606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QMS+Vg9x
Received: by kanga.kvack.org (Postfix)
	id 929FE6B05B0; Mon,  9 Nov 2026 00:08:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901896B05B3; Mon,  9 Nov 2026 00:08:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC4E6B05B8; Mon,  9 Nov 2026 00:08:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED156B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:08:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C58151403E4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:08:44 +0000 (UTC)
X-FDA: 85414400568.16.7D3459C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D4654160003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:08:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QMS+Vg9x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794200923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1VQUJOWynNq5sMHvJ+1kD7yhDV7CogQ5mFVSZClhbSk=;
	b=p1tZnaM1ikTD+vTU5b1/FA08VVQSQ8P7zv6NLHlPCGL69tMJcfXWhePVVOuPcyNkZol+s1
	GmNlElrVG152uMuM0104RatWMcyspv9O4yob+CxYUzM+wyprS1oaIIF+pCIYXVy/e+xiz4
	LSbaj8cmexmqsvadWrQuXbr4nq9ZRjY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QMS+Vg9x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794200923;
	b=1Z5atZUmRoQ1jkzb0/EYUEdwTNjoThRb5QA6kctVMG4PnGVxdDkh0J18DLWL8LlzneZCVi
	SR8jhLFnlLz6rBVzYRtke8a7CcIwA99ikxBwqjuldX9DVadQtND3dFdna9ExRa+cFTxdfH
	J/5j7yXY064IOD8hlTZ9siUZwzQAXLA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A5D5450C0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58DA1F008AB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794200921;
	bh=1VQUJOWynNq5sMHvJ+1kD7yhDV7CogQ5mFVSZClhbSk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QMS+Vg9xdpgBDhPLGEssMzYSM988KndzsaE/KR9yNQvENxvPO/haJH3IspZZC/evX
	 A+M52B/CtUVEoczih/Qizdbna2azxoiUOqxNddof1TxmDT3dZzQFqwWJgv2BzUqJr0
	 O0oxGICkHyANFFqh1I4TOlBM4M6XHSE+zWgdunO3BEu9UHckWTmtjnfjoEteP3WL4Y
	 jH36EqkWwAu9ttXGtl4wtKxJqjh9quyB39WVd3BrGLUL3VtrNviyEBinWIQxXe5bXD
	 bNaNNgdgP7nZCmcdervDpA2hd31k5/XT9Z7qgLg6+yHqM/CQz3xidUo2Pc+hBs/N7n
	 Wd20H/4T2K7XQ==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93e635220b4so41455185a.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 21:08:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFPQOM+tGlUqYI1SOaDtn1IU92mnOKGaQFeWTrIgDjya24omkDKK4vahK3dMaPYnMp2WTNyxe8yGQ==@kvack.org
X-Gm-Message-State: APuU4Z+4s9TZ6uHaoXX2N2XuLdoeeM3gHnGtLClQANJvnok4wJZhibjg
	QuxbYx+iPBpz9Ln+Ism0j/ak4AGP17aT3Vu6RO84mbUBQk/5RkKkch+A2c8xSGGNu0LwTZazNqQ
	3NOugpVEvoRLHvhuV8J9wR9vKKg1L7r4=
X-Received: by 2002:a05:620a:404c:b0:93f:2ab9:7294 with SMTP id
 af79cd13be357-947841f6ddamr467417785a.29.1794200921126; Sun, 08 Nov 2026
 21:08:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109021611.22247-1-hui.zhu@linux.dev> <20261108205148.380c16c42bb21ed0e2c829fe@linux-foundation.org>
In-Reply-To: <20261108205148.380c16c42bb21ed0e2c829fe@linux-foundation.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 9 Nov 2026 13:08:29 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ybXskWKDLHkeeuVGirGaaZ8TdPEDX+xQXZcYmPMSjS=A@mail.gmail.com>
X-Gm-Features: AclHuK-KqoamP3B_-9VY_9GUttMMzxUHXdmfnhKj_CfyY5ItADfd9JoacLqR554
Message-ID: <CAGsJ_4ybXskWKDLHkeeuVGirGaaZ8TdPEDX+xQXZcYmPMSjS=A@mail.gmail.com>
Subject: Re: [PATCH v3] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Zhu <hui.zhu@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Yu Zhao <yuzhao@google.com>, Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D4654160003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 36gtas3tjsnam63y1qjexq3rubzrx16f
X-HE-Tag: 1794200922-237889
X-HE-Meta: U2FsdGVkX19wtsKdT8CptyFNo6F4rTBGJJ2+yGXQ5kgnF6/iBJx0EDxcoNgVBT48eK6YBECSW+BImN7jHMJzcSVBCDOLpqrna7lVvpSfVeZ4dSVmSMWTzp/PySj/8/srxCBtymrpogm/0PZUWLEO2qg60VuFA/ICXUm1AyhdYbAGgnrxJtStCOo3RKqc7gFvBAGMiqu81Xub/8HETMjTDdXzy1UvmNVDH0kfW786civJf3cpTqaLKGVJIsutOSp1sPmK/uae0KQ7S3ZfrczWuWBz19oldODM1fVf4qhbpbQIiiacfg0X6lv7EYSmFJ1iRGcopFTZriTMFm8cVwDwhItXKcmFykxkpOgJcrlQa29f/25IK4scKmW8EN3bueR69smuNoSnvD59mhCu9vIZbiWd/sHSQDUCVBSIhzsMmMkoJtokO3loQdOcn7UERi889+vsOe/MTllaff9ZIipNn2o57nmj/T98lUNxTLQJzCZAsYw4W8MVxtYse91rr4oNwCaN6uQhy3pzeIyFEO1B6VprOgmH4E6jx0q+c0kCCC9Zr1iwYYgj1YlQE8IaKg+B6j3b0UhlrUgmPuwl1m5n6ZiQBMApEwF6gMNuaeLjNNlwtclGqO0UI6L2lAfHgjH5vHWO/tDQpfioqWQ+VXGAzRuEKEnvMxwr6vhswXyp+n3MIjgHA2PzNZpNUXAbP3yAi3uB1LQCMzs2sRi+CHLRaWh8NWJw9jp4xrBl8qVrvRIBtVBr1YdcnTMZG80wz4yZVM8gZkvUzS/3IS6aRaeiUyX1FPe/QGRjbIepasJ/ROyna+D+1KqsbenSgpXjZ+rijs7+P5h8bsO0k++7ytzE5s2y2xky7mrkQiViyMMg5bpmt9w3LmqL6GOI3msc4fuQpoQQk9KT+UC9gR8Obzbxo0JR9vynEr2GHHzzXFRasnTUkzBr5gGu0nO6g7Z/Ohg36x4ydbZIEL+C2WHjbke
 69ScfpXe
 xuKqeQXKFCmIEoP4ZVu+gc56Kf72WDi8xBpGVAj9+f/JhnTy1efLyclfawhhkCuDxktgORl+I9cqFWx7sXH17qOGzM0VMzgTjgiXkrDDAHbWXhbYpBxARtteDD+GpEwi3CWgflHWWXKKw8CK4rseWlPtFthZ09Tb1Kh8lhaYua0Iewa2wdkH67Ecisq6bcBpBKFh4QITJOkfEuQTPvqKZiXx9K4y0hYO0K5ePodRjwFtOxtxTa17LkDsI0nyQ7AMI2gUTYBfsIHJeVq3LI36iJVmJuiewahxR7euhcVXM5WhaZWX/9/iuey0QAfTFcpsccMG7wdpENFburGh/I+odbYJmoGrJM44mIE4BJjLg0pFc8OcoyjwZjuYZDniAUq5iU96blC7xZJn2Xo6JxB26pQffQo/x7dKgIyGneH8WFUmsCoWk+i8/fRAGnRM6tZlJyWDjbT/qip04TP6uJh3egMReQpLBc/jAGM6JXZhXhn73JU8R/31d+WUrLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 12:51=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon,  9 Nov 2026 10:16:11 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:
>
> > From: Hui Zhu <zhuhui@kylinos.cn>
> >
> > lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(), but
> > lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_gen(=
)
> > returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check withou=
t
> > clearing the refs or PG_workingset.
> >
> > A MADV_FREE folio therefore keeps the state it had before madvise(2),
> > even though madvise_free_pte_range() has already cleared the accessed a=
nd
> > dirty bits of its PTEs.  lru_gen_folio_seq() places it one generation
> > younger, and PG_workingset puts it in the last tier, so sort_folio()
> > promotes and protects it instead of evicting it and charges it to
> > lrugen->protected[], which read_ctrl_pos() uses to balance anon against
> > file reclaim.  __folio_inc_gen() clears the refs but not PG_workingset,
> > so this repeats every time the folio reaches the oldest generation.  If
> > the folio is redirtied first, ttu_anon_lazyfree_folio() keeps it and
> > lru_gen_eviction() packs the stale state into the shadow entry, so a
> > later refault is promoted to the youngest generation.
> >
> > Call lru_gen_clear_refs() while the folio is still on the generation
> > list, as deactivate_file_folio() and folio_deactivate() already do.  It=
s
> > return value only says whether the folio is in the oldest generation,
> > which lru_lazyfree() does not need because it re-adds the folio below.
> > Keep folio_clear_referenced() unconditional: the classic LRU needs it,
> > and it also covers the folios that lru_gen_clear_refs() skips.
>
> Thanks.
>
> > Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
> > Cc: stable@vger.kernel.org
>
> I'm not really understanding why a cc:stable is proposed.  Seems that
> cc8ec7be78ff's changes can lead to MADV_FREE folios hanging around for
> too long, but what is the runtime-visible effect of this upon our
> users?

For folios in a MADV_FREE VMA, userspace has
explicitly indicated that they are cold and can be
reclaimed without being swapped out, unless they are
re-dirtied before the reclaim path encounters them.

Therefore, these folios should ideally be placed at the
tail of the LRU so that they are reclaimed first when
memory pressure arises.

The problem right now is that they are protected, so
some potentially warmer folios may be reclaimed instead,
which could lead to more refaults.

I once proposed something similar, although more
aggressive:

https://lore.kernel.org/linux-mm/20240914063746.46290-1-21cnbao@gmail.com/

According to Gao Xu, this can have a visible performance
impact:

https://lore.kernel.org/linux-mm/7dcd3446cd8c4da69242e5d6680c1429@honor.com=
/

I would expect Hui's patch to provide a similar
performance benefit by addressing this issue. I believe
commit cc8ec7be78ff introduced a regression for
workloads with MADV_FREE.

However, real-world workload data would be helpful
to demonstrate the actual performance impact and make
the case more convincing.

The patch itself makes a lot of sense in theory, though.

I'll arrange some tests with Android workloads and report
back once the data is available. If Hui already has some
data, it would be great if he could share it as well.

Thanks,
Barry

