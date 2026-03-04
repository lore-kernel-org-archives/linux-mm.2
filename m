Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 737E3EF8FF9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C61BA6B00AA; Wed,  4 Mar 2026 10:35:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0D86B00AD; Wed,  4 Mar 2026 10:35:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADAEC6B00AA; Wed,  4 Mar 2026 10:35:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9DA4C6B00AA
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:35:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B7DB599D3
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:35:58 +0000 (UTC)
X-FDA: 84508781196.26.895F74F
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 64CA6100013
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:35:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20230601.gappssmtp.com header.s=20230601 header.b=eyrp3KYn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772638556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q1mkQWDrumj00DSD6vvqkqYaNr3+NM2VS5dFTF9kbFs=;
	b=yr/37pRfsgyRnSF53opW/xq7GkDcLHbhrEqBmUmgFcy+zyyCc3m0szHR2rrM1ToAPKOJY6
	UldZBz7IVcCrQegz4MosLEK4Pi9NLKcEp1FobO+76CNSzeAW+NJfNumk/bv8/yNMx3Rc+Q
	55Ny6krHcZGie6u+oxokZ9X4EXLzBHk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772638556; a=rsa-sha256;
	cv=none;
	b=h8SXXi7Lus0H0QJaDPaa+zyvFGY4h0NsdY4EWDzfHKVughGgsimiHGddKA0Ni8ZWhc04WT
	62QtTGsclyGWK0MQFp25oCIMKHbhJR3mZ8zd6fbkmJ+yf7/uUFGm5OGF18jC8kVZ5QgnTw
	v9ovMMxenRBqNaQMGvB9UroW7k2jQaI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20230601.gappssmtp.com header.s=20230601 header.b=eyrp3KYn;
	spf=none (imf05.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.128.48) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-483a233819aso69079985e9.3
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 07:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20230601.gappssmtp.com; s=20230601; t=1772638555; x=1773243355; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q1mkQWDrumj00DSD6vvqkqYaNr3+NM2VS5dFTF9kbFs=;
        b=eyrp3KYnu0pJ4O/RAIT47SqodkslQbh+Xvn+/4k4z5pKgzQFnqulxC73pRZMzPNTER
         YnFXakhPHPlDenyo+8+oyrQo+F3sJhHGCokcuCadoWninXF8sUj4Q1fztts6qx78zl0q
         nfEuAYnGOvSE8cw3YIKiMCRS9e5yibSL5ZbKtX4alQMTrQQslbMusYyT7RfYfkBmqh/0
         1LWtN8OnTo8Q5omsGDSYYNYKPxcJ4OVH4qfCJbjmP6sSE+AdvdIDjqlu/NDlI/WIWy1f
         aRD+OgiDJK6AdB9sV51n2bySo4eqamJyQzBIMXZqepEyI0AKYe1h0qeO1u1wygVuteAa
         an0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772638555; x=1773243355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q1mkQWDrumj00DSD6vvqkqYaNr3+NM2VS5dFTF9kbFs=;
        b=b7Ox8EEHIYhpWqfSaaWQr/Iq1FFUSpyTdMi5gK+WTfyLb1M1S1ILUZR3fjte4Nl9Bm
         K0KAGpLNVui5AEZsuYm2QTw1BRIVbH6aLc5inp/t/9+xlYCXmZWof0DftBvltvavIFb+
         BdopDii+pprvPdhDS7EE0nUQjDwhD51iTMeIBC1EV+smPWzpXoPfJBJa7xW/OwQa45qr
         kwZEsPR+KtdzatVbsCAlKGe2TcKwZIW8bNIrGiTjOe/Qx5CyATYT2DEAsgPaZzeeIth3
         SUzhD6wd0Qw9qZxNIdSNeTGrhiHSi7cxeLIr+I7a+oGpcgct4m9qTcNgk/fc4s1OgK4S
         kFPA==
X-Forwarded-Encrypted: i=1; AJvYcCWuoxoLcdlcz5p2gmrT1QNQDChQNpsT31wPG78UrVi06P0kuESFiETWJwh3eYpkHnVMf/gshVnNzQ==@kvack.org
X-Gm-Message-State: AOJu0YwWRRsDU6RO484ZJTgKVlq4phT/O5vQ5TSl/coFV7zqy6yOo0xI
	lGhzaaY/SoPRVkpoTkvLvqKrgoetbeo0vr0ekdSPAXKP7dNKkvQZzUtVyOF6xFKEFBc=
X-Gm-Gg: ATEYQzwBmOvzVDlpFywfC4LfBCi/ogPOFj/x7XsRQukC1dgBbgzNCRmH4p90vkmrl9O
	u/NlQ8l+8ZLzpIPZAx4AhA57FkWKex/XEADUkNhJ1UITGauGb5Gt8SHIofaguy40FuTEGDpRvIo
	lA2/Hf0WVLOWDddkwis7i3wipt6Ye3eK466QeDX/r/TclEqHOahOZKRJpy8cWsz6a9JG65a7h0v
	GSzo/Y7XiL1RB471flXL5y4EiXk8yJuK0NbBAQDvCZt63bgaDoWUWXgz6olYewxGwXlkILGmn3n
	4civstMhSWbguzmNWFXP3MEPlEBIq+kTPXHJCooIK+8fWQhcjiiG9T6DwUrO0NlfpitntRFWsQa
	5xv7jJIb+eNb6BxPHrNJnuIJ4iZuwhWvaCTtsKrYGcc37EOAienZ8mXy6vbItC1CL4U3loX7zmC
	tHIZpbqpRnXrpLYL5hCQ==
X-Received: by 2002:a05:600c:45c6:b0:483:c12b:fe4b with SMTP id 5b1f17b1804b1-4851984953emr39162205e9.9.1772638554307;
        Wed, 04 Mar 2026 07:35:54 -0800 (PST)
Received: from localhost ([2a09:bac1:2880:f0::3df:3d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485187db303sm63405395e9.0.2026.03.04.07.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 07:35:53 -0800 (PST)
Date: Wed, 4 Mar 2026 15:35:52 +0000
From: Matt Fleming <matt@readmodwrite.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@cloudflare.com, 
	Matt Fleming <mfleming@cloudflare.com>
Subject: Re: [RFC PATCH 0/1] mm: Reduce direct reclaim stalls with RAM-backed
 swap
Message-ID: <wqv7kbfipi5rk5nt2r4bjcqslvluz5mklyz7u33vhytgie7djx@vbjz5ndkaf53>
References: <20260303115358.1323188-1-matt@readmodwrite.com>
 <aac38JHJCRB0PbjJ@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aac38JHJCRB0PbjJ@cmpxchg.org>
X-Stat-Signature: rsjn1ucccy7gkjyifo3epid1iueocpar
X-Rspam-User: 
X-Rspamd-Queue-Id: 64CA6100013
X-Rspamd-Server: rspam12
X-HE-Tag: 1772638556-137644
X-HE-Meta: U2FsdGVkX1+hdwzBjoIcT8skh8gHEXUC+X1vLyzW2eOgb/TVYgUhMfkeh6RrRNEgqZK6xzwy3FaDEeRJHpfmfM3TXx40k8WpABsoz1Otl5fgcqFkCRVffybHRguANuZRm30uc2NifGgY+gbwai1Qong8kVeNq9Re1OlzomHoS5RasnxYoqeSfZ470YDMp65uDxav+h8/XHbMyHjbsi3TfFRKaMpUxVBkUuEj1ISqQp8DJm7WZk8acPFnk1pKeoLfS+0R1wtvmK6vNeJ2R/HJ2wpc1d1Od1hk0F6h1ddhXcOoWKstjPEW8gH8NcNcan12Ev79WYf5gXZ9a7pUl8j3xOWuIGo3AlDj3BuetNqxa8jE0FtVcqYIGHM7H1tmRrSVG0HhU+QfVjAVYyBPot9r4YMkVVRQcG52M2SvgSE+SrlMgeQLtKP1d0ryvDFxPL6vXeMYMHVxzMXaZmFMu/5Th2UI4vYItJ3e+d2t+cLVNxi8pdwRsXzpH89HhZiQM1vKjttPeU3Pt8pfSre8HPxoAFmRa/+pRbU4vPzMhhZOfdTCiQWY7o2OEWd5iqiq2uXWvito9j6c9buvbKiT2D1JLOHgU1pA8+1Y5xSFVbSGOz9LO1yFlhKR5uP3w0REj41H9CGkOcYzS0u4nOOsL4t9YS4dPZzEcMIlDkb8YYwpIfrkGCPGqvUiLD0r4/q/O5cSBmCgL0Ah8q8wvFwmrcAxN0KcxIhWEEAMiI43LVSkcybK1uhrtyga1BGVffvGICh2foPguvhUU+BeOunw0c/XQ6M1AaxRExJnjnR62/GEgXjTBtNACKU6XZipN/TO8LoNiFzMuTavOp1Fq1od2Y/ed7emq4QvQ4txx0YALpi7Uoh3rG2blN0gQNyuxDYmCSMmQAaroSpe9ocyzIh5QZQFIFC6siPa1F9iPcrZNH5SO6QNRtmhl+8JxRg7c5tPHmWR0jPDmIKsaXs2w6XL/Du
 w9RfcIIm
 1ktk2kPutZ60jJjzvu4qn/sgKX22Z9Kn34XL3AU0Qn3U8q6E4SJd7ajDRvLkopCSitRwzR7GCTX72Lf4HdOSGkCHypbtrGsgIfx7TUsya7ANx0NEkOU/VnvY9gq3GDWJU2h1qUNLygSkIh5SVvZnUhKd5Ov92WIDUDBgteBSOPYYBcb+BmgxkUgJKQixf9cGdNrGOpCcJcOlbMPU7JqITfTCUzS6aRWwIKZApU2TxSHCpjiM3MlwDfHcqEcS/hLw1qfI2P8htmvjvjNZWMZ2hcUmjE/3DFR9VOJnhmJSR9wn3E0hJ38UJMnntvNI242F322P1cPpkF7O5pjUUt88V80dQhyDJkPfTsVkQXSXwHC6TSafyA9MNhuKAzUYtVa3iD/9sFmMkrwm8018GLgzDQZxIjJF+KTu5asCH+4K+2eiuhCHiTlLb9o29ceGjCKaBdljf9GWQqDwrKOUsl1xgEQiJw4ByO5kOqPcXdcTDuS2OGwQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 02:35:12PM -0500, Johannes Weiner wrote:
> 
> What about when anon pages *are* reclaimable through compression,
> though? Then we'd declare OOM prematurely.
 
I agree this RFC is a rather blunt approach which is why I tried to
limit it to zram/brd specifically.

> You could make the case that what is reclaimable should have been
> reclaimed already by the time we get here. But then you could make the
> same case for file pages, and then there is nothing left.
> 
> The check is meant to be an optimization. The primary OOM cutoff is
> that we aren't able to reclaim anything. This reclaimable check is a
> shortcut that says, even if we are reclaiming some, there is not
> enough juice in that box to keep squeezing.
> 
> Have you looked at what exactly keeps resetting no_progress_loops when
> the system is in this state?
 
I pulled data for some of the worst offenders atm but I couldn't catch
any in this 20-30 min brownout situation. Still, I think this
illustrates the problem...

Across three machines, every reclaim_retry_zone event showed
no_progress_loops = 0 and wmark_check = pass. On the busiest node (141
retry events over 5 minutes), the reclaimable estimate ranged from 4.8M
to 5.3M pages (19-21 GiB). The counter never incremented once.

The reclaimable watermark check also always passes. The traced
reclaimable values (19-21 GiB per zone) trivially exceed the min
watermark (~68 MiB), so should_reclaim_retry() never falls through on
that path either.

Sample output from a bpftrace script [1] on the reclaim_retry_zone
tracepoint (LOOPS = no_progress_loops, WMARK = wmark_check):

  COMM             PID    NODE ORDER    RECLAIMABLE      AVAILABLE      MIN_WMARK LOOPS WMARK
  app1          2133536     4     0        4960156        5013010          17522     0     1
  app2          2337869     5     0        4845655        4901543          17521     0     1
  app3           339457     6     0        4823519        4838900          17522     0     1
  app4          2179800     6     0        4819201        4835085          17522     0     1
  app5          2299092     0     0        3566433        3595953          15821     0     1
  app6          2194373     7     0        5612347        5626651          17521     0     1

Here are the numbers from a 5-minute bpftrace session on a node under
memory pressure:

  should_reclaim_retry:
    141 calls, no_progress_loops = 0 every time, wmark_check = pass every time
    reclaimable estimate: 4.8M - 5.3M pages (19-21 GiB)

  shrink_folio_list (mm_vmscan_lru_shrink_inactive) [2]:
    anon:  52M pages reclaimed / 244M scanned  (21% hit rate)
           53% of scan events reclaimed zero pages
    file:  33M pages reclaimed / 42M scanned   (78% hit rate)
           21% of scan events reclaimed zero pages

    priority distribution peaked at 2-3 (most aggressive levels)

[1] https://gist.github.com/mfleming/167b00bef7e1f4e686a6d32833c42079
[2] https://gist.github.com/mfleming/e31c86d3ab0a883e9053e19010150a13

A second node showed the same pattern: 18% anon scan efficiency vs 90%
file, no_progress_loops = 0, wmark always passes.

> I could see an argument that the two checks are not properly aligned
> right now. We could be making nominal forward progress on a small,
> heavily thrashing cache position only; but we'll keep looping because,
> well, look at all this anon memory! (Which isn't being reclaimed.)
>
> If that's the case, a better solution might be to split
> did_some_progress into anon and file progress, and only consider the
> LRU pages for which reclaim is actually making headway. And ignore
> those where we fail to succeed - for whatever reason, really, not just
> this particular zram situation.

Right. The mm_vmscan_lru_shrink_inactive tracepoint shows the anon LRU
being scanned aggressively at priority 1-3, but only 21% of scanned
pages are reclaimed. Meanwhile file reclaim runs at 78-90% efficiency
but there aren't enough file pages to satisfy the allocation.

> And if that isn't enough, maybe pass did_some_progress as the actual
> page counts instead of a bool, and only consider an LRU type
> reclaimable if the last scan cycle reclaimed at least N% of it.

Nice idea. I'll work on a patch.

Thanks,
Matt

