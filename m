Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43BC7C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36F6A6B0108; Mon, 29 Jun 2026 12:45:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348166B010C; Mon, 29 Jun 2026 12:45:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211276B010E; Mon, 29 Jun 2026 12:45:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E714B6B0108
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:45:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76E69140205
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:45:36 +0000 (UTC)
X-FDA: 84933526272.30.C369043
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C1533100006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:45:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lmn4qK3g;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751534;
	b=fBiL1yecMQ89YbVNbC8rt7gzpPOfLEJTNB4wbd4DuJaHsk26IEZKx9sQRv+I553xPps9ur
	VPUXyO0cCBstEvFtRYSdAjicgYOtArsr0wAbjtYJ/nWfSN9q70vxo1SNWHcwz2rBKnZ8vY
	ItnOCZ7OMlLH0gFc3EFAk4Be7WCO2L4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xcjVTGjAJE+I7o68X7PqqKi8r93qpsaE24acBtIWCzU=;
	b=pJG6hcMUuAr/PEB0tJ9qOFOXQfcRhDTAJ0lqpGlO/TRhIh9rYY9WJ9o9RKFCfsSbYiE5Mg
	UGo2etz4wxRFUdwFpX/OlbOgMZgEvlu3x3DRHR+XqS/UwDg2bWRnFQ8dVRdxWQOgJAApoU
	qlCGyXHTB1zJL71epWD2U0BS/WUC0pw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lmn4qK3g;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D61C740DE3;
	Mon, 29 Jun 2026 16:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4B31F000E9;
	Mon, 29 Jun 2026 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782751533;
	bh=xcjVTGjAJE+I7o68X7PqqKi8r93qpsaE24acBtIWCzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lmn4qK3gZL8FI01KVbpmGZnH3S6ngM9jaoe2ZOPWkRG6jz1A3D1LukNUy8uVkZeSy
	 nQ1IYmQORVGHOUlXofB0DEWa/yweWnETjgOhQlNAk7XsDdUtgv6z53oviBDaK+xsMK
	 XI8vbUn4d+d8dDjYr9gMnG/qPZe51jDqnToAo2fJ0hA8mi8gz5T9B0JlVVKVAqrK/8
	 2poqo2uGHw17WyZ/IX6qLYaugoG7SrFMZffvru3LrYRp+QiXhToC5SvGC8LNABuw6m
	 ihDwdWEDLO5dNH8cA3yj0g2lGnkFh3W4v1xXGR67UZrrHLGMyxTl8muAMoudW7LfIx
	 XQREl8mVYlgtQ==
Date: Mon, 29 Jun 2026 17:45:22 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Xuewen Wang <wangxuewen@kylinos.cn>, liam@infradead.org, vbabka@kernel.org, jannh@google.com, 
	pfalcato@suse.de, chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: annotate data-race in cpu_needs_drain()
Message-ID: <akKgikoi2dFKqmaG@lucifer>
References: <20260626053700.2036899-1-wangxuewen@kylinos.cn>
 <04ea3e05-5b83-4c2d-8759-67c544a7b484@kernel.org>
 <akJHit8BV-hWRXYk@lucifer>
 <20260629093402.a4d14d4f95ccde7d4c804115@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629093402.a4d14d4f95ccde7d4c804115@linux-foundation.org>
X-Rspamd-Queue-Id: C1533100006
X-Stat-Signature: c7s6w8xah1gr5pc7op3canss7o8bs448
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782751534-371410
X-HE-Meta: U2FsdGVkX1+D0TAJJlYGgKCJX0L5Za9IQ9UOUCyiT1heihdpKzPN+nzmN4J4O0HzcrO5QpbAGSRFW9l88R0Vhl9Xwgcp71AjawfRprTxuXqRj+YhVeri6O8iaDIMy0JlxQbxeL/24YxfUaIG6SZgN07udM4Xg6cPI/roc4PkKugqhP1jkhAoRrf5QSFPimIAcV09i/Fd0hlVHdHyodP1OGz1kFzZFFETqscepg415oN5FB1cYAiJcpikZH8ungludk9gRNdFSIjfPdz0iMb13TP/hiQF3Uo+P1iUIMi84QbUwWxVJT5e5DqsM6dlqPQOUnpeQIAsFHpbUhCJxAv1gwp3sSiM1xPu1dDv8n9mVp6N3sFqti2p6LEkAncU2CUTy+Ka6chhJDYcxRAsTN69754jYj25VdSrvqCSKJuWdVrr/z9xQBnn4upZNJrK9X8oOJtDR2pYdAM/0J9PmB9BFSKkGXnViNN5vo77qutaBoqyhTCdOC6EbyXEleA2WFPFt4WsIzr6XGgu/ouYayIxPchZXT98643NTj9Dc+SlLiebFMLUsH05AKwL1cgkMKR/jSrIiV5qy37GteQCflyV6+GTlEbB3geUevgCqOzbOY8RGFZZJo61T1pCvhDu0FJKBYhVZglHGlWq+xUWOf2gfyzVxwk8+iD9A9iAxDVs8L92NN+NRMyzwVdG+nPap6Hyr37Cm9b71ab07wHBuXr5DYCSvfOrlDYzYom3j4Kux/YLnsusGCOwdLt42jNNASHhkqZCN1B4EV9LFl5ETczbkxooaRrTFYA5YLhFWoF+U3yPVnc1VrCLY16W0TamWjIiOF1UqTQ+xPrhriLyJXxvsGW8JVIhbe42g3CI6OgTvTO+r9mmx5ByjtJJozzQdIbPS7kRnrGYoGrXFyC/DCD4hr4fo/IRVOBzoZEZtnvDOXy5bTsG3MrLBN9M3CGuR7WVnE7mgJ9YY9pJHe5zfHw
 JYiIYk7a
 79oirMcXuX5pr5TU2T8YBL5QSrjgwL8xoxdyMysnfGmVelnSRpkTJhMKdiIMFxoM6gjWdue+VPAPMBGspRqQ+kDrQm7bsxYxU9JRQADJqFUzegZiElX9Tr5lahdmTyLhXAHoUD6ARw3XXDH8ntRtZ31CvuVcFp3wrrJTWbNZmKltE0fuFIS+a9Acy9Xc7ezITNrG4VoEc5kF7tqFRPSChlQsJJ4g2mPa89NQpGFu+T2ZWCQ+Re8LOu8rFLT6ucCZ0Jc2HkwROV5Li/ISz4wSxoPDzid3fKAYPCytkJr9eUGM6Qxv5FwWV0Hgir33nI/MTgX9EUSNxokb4j80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 09:34:02AM -0700, Andrew Morton wrote:
> On Mon, 29 Jun 2026 11:23:26 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
>
> > > >  		folio_batch_count(&fbatches->lru_lazyfree) ||
> > > >  		folio_batch_count(&fbatches->lru_activate) ||
> > > > -		need_mlock_drain(cpu) ||
> > > > +		need_mlock_drain(cpu)) ||
> > >
> > > The indentation is a bit suboptimal now.
> > >
> > > Would read nicer as
> > >
> > > diff --git a/mm/swap.c b/mm/swap.c
> > > index 588f50d8f1a8c..5958e6fdd3593 100644
> > > --- a/mm/swap.c
> > > +++ b/mm/swap.c
> > > @@ -828,13 +828,13 @@ static bool cpu_needs_drain(unsigned int cpu)
> > >         struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
> > >
> > >         /* Check these in order of likelihood that they're not zero */
> > > -       return folio_batch_count(&fbatches->lru_add) ||
> > > -               folio_batch_count(&fbatches->lru_move_tail) ||
> > > -               folio_batch_count(&fbatches->lru_deactivate_file) ||
> > > -               folio_batch_count(&fbatches->lru_deactivate) ||
> > > -               folio_batch_count(&fbatches->lru_lazyfree) ||
> > > -               folio_batch_count(&fbatches->lru_activate) ||
> > > -               need_mlock_drain(cpu) ||
> > > +       return data_race(folio_batch_count(&fbatches->lru_add) ||
> > > +                        folio_batch_count(&fbatches->lru_move_tail) ||
> > > +                        folio_batch_count(&fbatches->lru_deactivate_file) ||
> > > +                        folio_batch_count(&fbatches->lru_deactivate) ||
> > > +                        folio_batch_count(&fbatches->lru_lazyfree) ||
> > > +                        folio_batch_count(&fbatches->lru_activate) ||
> > > +                        need_mlock_drain(cpu)) ||
> > >                 has_bh_in_lru(cpu, NULL);
> >
> > Yeah that works for me.
> >
> > Andrew - maybe easier if you fix that up? :)
> >
>
> Sure.
>
> --- a/mm/swap.c~mm-annotate-data-race-in-cpu_needs_drain-fix
> +++ a/mm/swap.c
> @@ -832,12 +832,12 @@ static bool cpu_needs_drain(unsigned int
>
>  	/* Check these in order of likelihood that they're not zero */
>  	return data_race(folio_batch_count(&fbatches->lru_add) ||
> -		folio_batch_count(&fbatches->lru_move_tail) ||
> -		folio_batch_count(&fbatches->lru_deactivate_file) ||
> -		folio_batch_count(&fbatches->lru_deactivate) ||
> -		folio_batch_count(&fbatches->lru_lazyfree) ||
> -		folio_batch_count(&fbatches->lru_activate) ||
> -		need_mlock_drain(cpu)) ||
> +			 folio_batch_count(&fbatches->lru_move_tail) ||
> +			 folio_batch_count(&fbatches->lru_deactivate_file) ||
> +			 folio_batch_count(&fbatches->lru_deactivate) ||
> +			 folio_batch_count(&fbatches->lru_lazyfree) ||
> +			 folio_batch_count(&fbatches->lru_activate) ||
> +			 need_mlock_drain(cpu)) ||
>  		has_bh_in_lru(cpu, NULL);
>  }
>
>
> The removal of data_race() in need_mlock_drain() is a little worrisome
> - perhaps any future callers would have needed it?
>
> need_mlock_drain() has only a single caller.  How about I remove it and
> open-code it within cpu_needs_drain()?

That references a static per-CPU variable (mlock_fbatch) in mlock.c's
compilation unit so I think it has to stay as it us unfortunately.

And it's better I think to only use the data_race() here where we definitely
know we need it (and as the only instance of that).

Cheers, Lorenzo

