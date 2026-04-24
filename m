Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E655EFED3EA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 16:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252326B0005; Fri, 24 Apr 2026 12:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203396B008A; Fri, 24 Apr 2026 12:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119026B008C; Fri, 24 Apr 2026 12:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 016E86B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:30:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E01E1A0256
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:30:54 +0000 (UTC)
X-FDA: 84693988428.14.CE907B0
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8339AC0009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:30:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HFc9Ume2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777048253; a=rsa-sha256;
	cv=none;
	b=mWVaT8r8Sj6LNYBq/cE0AgNuMTvuADzdiZLMv1y+0B8OtOzCjDoWBiyZ8BTdAMm4xzN6GJ
	lcFCXscr0VJbvLcaCdx0ViZa0Yqv9vzZ6OWvTG7ZSmEYQ8i2WwwKhcD817tPzG9/KgXmJm
	/G7WDIEFDQyYxOisB4JPQDoetU7nf0s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HFc9Ume2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777048253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/YH7h+Li/H8wtRR61SCvMhb9XCC3pTiwSDwdPJ4NTU=;
	b=on2uF/7FbBfa9LwsVjJdhrHoP0JaowAihwrPEnfMsQstDYabbWWM6gmu1XLqJLp9LvmH2D
	y6gTpGxL95oboTi60iYFaSxrPYoISVTTFqwJCHj1YAItV00tOjr31/aGljlYonWrJm74uc
	RF8S7usx8fNU4haaoenFlYkz8cGUUUU=
Date: Fri, 24 Apr 2026 09:30:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777048250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+/YH7h+Li/H8wtRR61SCvMhb9XCC3pTiwSDwdPJ4NTU=;
	b=HFc9Ume2JHJ6D4d+CzhnvNmVdhJHHM1z8TmUMIVfFO50MiOdU4ivze6f1Xqw4l0C4RtZDp
	CkOJLkQMDHErxLa+Rk8xSIkJjWdLdlbPBM0tyhc9Q2P/Rxy1q1s3DOk0vNQEqtXzovdqwM
	hg+B7C4mcTmDdc2TFQm4DWwa5Uq7HCE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, mhocko@suse.com, willy@infradead.org, 
	hannes@cmpxchg.org, riel@surriel.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/lruvec: preemptively free dead folios during lru_add
 drain
Message-ID: <aeuagwXAvLFVS1iI@linux.dev>
References: <20260423164307.29805-1-jp.kobryn@linux.dev>
 <CAGsJ_4ygEvptQy662tTiPm-k+E4cbfvUKGGg3w7NaaALO-F4ig@mail.gmail.com>
 <aequK2ZM3O_7NM1M@linux.dev>
 <CAGsJ_4xy+kGktiePL28DP3PAcVsdnz8Noann2UGhD=EV+3xjqA@mail.gmail.com>
 <a4c8a792-7256-4e4c-9f8e-5539a8f93459@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4c8a792-7256-4e4c-9f8e-5539a8f93459@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8339AC0009
X-Rspamd-Server: rspam12
X-Stat-Signature: f9fcpgk893ghtqqu8tqw9uoe1ba7dj3i
X-Rspam-User: 
X-HE-Tag: 1777048252-699425
X-HE-Meta: U2FsdGVkX1/la4pIq9PnWU9jegDGBV/ABWH8fdn3y5TiuL9wiGfo+KdxMqzCFrGhAy5fhX/RUkYz6C5QZja9rWSNjAW2Q5xY6XKh9X4MUvprW9NGupjm2VJvNWh4FLqQP4nM1Nzq1/x37wRwul461CO8Io8C/OxVmSm+VosRPa8cWohNA5Ipp5jagjAEl0wSFwjzfNbuyQIJIDJY1YXocddBpiH/D48aOtiJ2GkeavP0G39MkG/fCqgzBaZ45hMBl2pKrXvTCpdjMmTbqiu05zGrwy7IWpqI/kyEsibRxWLAG/rVeUtsw3y8ERVqjjbLMjxa0x5MfwTLBKEpzDHPf4/yLRSLcc66qpoLx+iXAX5zhg5wePVh38cF+ZTexHdSlR2n3XCQdhOCJLQkqDKq5KPakz19UfrVmoFvijdFYpbpKCxYZF/Bl/D2NufydUMtAEitwKzmoZs/JEeGmLhaOAcNcLVxyEAQyRJt/bgt5sgmYtWWvcHVmgQCcq+wLYr5Mqij5mfrapx8aL0d+i/KYhjFYaMu7p3+/UyLGWZ1buqUnnULULXSKjUGz7J8yiB5ak20A+D5FsqKirFlggq52/0wTR2KBMb7I/NIfxNMmq8TxEx6kvWfLZ8BwkEe/bPtDfeKVzbgwfLyltxV1QuLHK8ZvpmPcQeGYWSMzTmvroJ7laDqG6v7/asgNgwTWLLVFGdevg0TB+24gKP13Du0kij2Ad28jjo/mVOkTSw45PggJfA2gqVq34hCNTeYrOR4Kv+bEWbKvZcGxPYfTWuJgZ/Ulgv00Kn8Cus6c98vRrQcdPpbN58Ti6px6KIBy6+JQjTPfqDR1CRT+cM/BBc1UlO371sUCfQgrePKjmCaN91uNVsEvynDsx0dmJ//PdmEztBP3+U8gFbRry52n5v7Wa+UIUhRh5ttR64oHWHcV4NNsSjlY4ygatlOEKqigCEjPfmUCHTpCf0M7+4pHs6
 sRnVTU7f
 WhGjyuPJJ1j0CFMZOhm+zr4CoLg2tsJ1j/2urqn/R8w2pYTSx6jyfow0In8h61Km7Xf/XR5Cg+0Uxu+eZEGGW7gelFBb0Gia3SsO51m+EVNiye1O2NEtbgpoHKY5j/osQB1I3VGGbmsZ3UyQtnuRA+HM7YbnBWEPRv9MZ2so26DbDFmw4qp+6Xud49IPcIeIlRV+YvAnrASUJf/cQVhJOS8rFM3Wjh94rtvypYqdjpGomqp60v0VQ8t2cWzyMJacPGKE8s+VYQAGpdZeQc5KmLiuwnuvCbTubvcFubfzHc2FYWBbbdzUbfdQVBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 08:38:06AM -0700, JP Kobryn (Meta) wrote:
> On 4/23/26 4:53 PM, Barry Song wrote:
> > On Fri, Apr 24, 2026 at 7:46 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > 
> > > On Fri, Apr 24, 2026 at 07:22:30AM +0800, Barry Song wrote:
> > > > On Fri, Apr 24, 2026 at 12:43 AM JP Kobryn (Meta) <jp.kobryn@linux.dev> wrote:
> > > > > 
> > > > > Of all observable lruvec lock contention in our fleet, we find that ~24%
> > > > > occurs when dead folios are present in lru_add batches at drain time. This
> > > > > is wasteful in the sense that the folio is added to the LRU just to be
> > > > > immediately removed via folios_put_refs(), incurring two unnecessary lock
> > > > > acquisitions.
> > > > > 
> > > > > Eliminate this overhead by preemptively cleaning up dead folios before they
> > > > > make it into the LRU. Use folio_ref_freeze() to filter folios whose only
> > > > > remaining refcount is the batch ref. When dead folios are found, move them
> > > > > off the add batch and onto a temporary batch to be freed.
> > > > > 
> > > > > During A/B testing on one of our prod instagram workloads (high-frequency
> > > > > short-lived requests), the patch intercepted almost all dead folios before
> > > > > they entered the LRU. Data collected using the mm_lru_insertion tracepoint
> > > > > shows the effectiveness of the patch:
> > > > > 
> > > > > Per-host LRU add averages at 95% CPU load
> > > > > (60 hosts each side, 3 x 60s intervals)
> > > > > 
> > > > >              dead folios/min  total folios/min   dead %
> > > > > unpatched:        1,297,785        19,341,986  6.7097%
> > > > > patched:                 14        19,039,996  0.0001%
> > > > > 
> > > > > Within this workload, we save ~2.6M lock acquisitions per minute per host
> > > > > as a result.
> > > > > 
> > > > > System-wide memory stats improved on the patched side also at 95% CPU load:
> > > > >   - direct reclaim scanning reduced 7%
> > > > >   - allocation stalls reduced 5.2%
> > > > >   - compaction stalls reduced 12.3%
> > > > >   - page frees reduced 4.9%
> > > > > 
> > > > > No regressions were observed in requests served per second or request tail
> > > > > latency (p99). Both metrics showed directional improvement at higher CPU
> > > > > utilization (comparing 85% to 95%).
> > > > > 
> > > > > Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> > > > 
> > > > Hi JP,
> > > > I’m seeing a large number of "BAD page" bugs.
> > > > Not sure if it’s related, but reverting this patch
> > > > seems to fix the issue.
> > > > 
> > > > [ 2869.365978] BUG: Bad page state in process uname  pfn:3a5417
> > > > [ 2869.365981] page: refcount:0 mapcount:0 mapping:0000000000000000
> > > > index:0x724884c20 pfn:0x3a5417
> > > > [ 2869.365983] flags:
> > > > 0x17ffffc0020908(uptodate|active|owner_2|swapbacked|node=0|zone=2|lastcpupid=0x1fffff)
> > > 
> > > Hi Barry, are you using MGLRU? It seems like MGLRU set active flag in
> > > folio_add_lru().
> > 
> > Yes. If you are referring to this set_active, I think it is
> > incorrect, so I have fixed it here and am waiting for review:
> > 
> > https://lore.kernel.org/linux-mm/20260418120233.7162-1-baohua@kernel.org/
> > 
> > > 
> > > JP, we need to clean active flag but let's check what else can be set before
> > > folio_add_lru().
> 
> Barry/Shakeel,
> 
> We can do something like this as a special case for MGLRU:
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 71607b0ce3d18..68ea929f65031 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -185,6 +185,8 @@ static void folio_batch_move_lru(struct folio_batch
> *fbatch, move_fn_t move_fn)
>  		 * deferred split list to avoid a dangling list entry.
>  		 */
>  		if (is_lru_add && folio_ref_freeze(folio, 1)) {
> +			if (lru_gen_enabled())
> +				__folio_clear_active(folio);
>  			folio_unqueue_deferred_split(folio);
>  			fbatch->folios[i] = NULL;
>  			folio_batch_add(&free_fbatch, folio);
> 
> Unless Barry's patch works out... Any thoughts?

I think this is fine. We can remove this later when Barry's patch is settled in
a followup path.

> 

