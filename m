Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F51C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 21:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B276B0092; Tue, 11 Aug 2026 17:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0BD66B0096; Tue, 11 Aug 2026 17:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D227B6B009B; Tue, 11 Aug 2026 17:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B6FCD6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:58:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45F6FC01ED
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:58:00 +0000 (UTC)
X-FDA: 85090351920.08.B8F6EBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4465840004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:57:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VmpzmsHA;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786485478;
	b=d2WyWp/lgwIekOHfGYASiI6R6nYhQGBAD2Hnz3fTtMawxDPfP+KUtwmYSv9VkOeA3vw2Yb
	QmBDvjxpv8wJtE35tDCM4/G8qFimUs3uHJSJ44bipe4GtR1UMXu4se+oIqP80bioKuaeFj
	Q5FayY+FNccyC32bDYzXRfF6FgCBH5c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VmpzmsHA;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786485478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyqevDNjsJZverOYk+emEjJn1/V3eS41pms2qKDvjNg=;
	b=LBR8fImZTCUg4oOe07dapCB4VsgHCQbvOhzYA0yane4FHkthyjrycX7qxuKvKQVh1hffrx
	bokeIwe0wKdVkcUOY5Lq4kE+IWc/c8lQ43Ejl3j2K/OZf9RDDUn27f3sZR0Hm/BPGsA6Mt
	53BcwSrtKMKW881nNf+TlQDci96+1oQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19D4F41096;
	Tue, 11 Aug 2026 21:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A721F000E9;
	Tue, 11 Aug 2026 21:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786485477;
	bh=GyqevDNjsJZverOYk+emEjJn1/V3eS41pms2qKDvjNg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VmpzmsHAmQHSyoV0C7c4aOxavkL7BoFzwFL9KJhsqUwI9BCiNZdC7FQeiW765pIET
	 0UK0pAQ489an6CfMgI7dR9Rs0C0dU6NMYudt/7FYTFPFh+gojk0B+DJv+WwLwiV7de
	 PteOqFh8Jp2Rh3YRv+dFEKPMRhMRaJc94dUa1u6Y=
Date: Tue, 11 Aug 2026 14:57:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, Max Boone
 <mboone@akamai.com>
Subject: Re: [PATCH v2 1/2] mm/pagewalk: fix stale walk->action escaping
 walk_pmd_range()
Message-Id: <20260811145756.6a9af6f7d3d04c8b00a0f3ee@linux-foundation.org>
In-Reply-To: <anuDYOPa0kTD9bul@v4bel>
References: <20260811161949.3879321-1-imv4bel@gmail.com>
	<20260811161949.3879321-2-imv4bel@gmail.com>
	<20260811123702.f3c60a3573e148c53ad35b97@linux-foundation.org>
	<anuDYOPa0kTD9bul@v4bel>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4465840004
X-Rspam-User: 
X-Stat-Signature: p695qa389f9577pe71ng5bys7ekgepw8
X-Rspamd-Server: rspam06
X-HE-Tag: 1786485478-432602
X-HE-Meta: U2FsdGVkX1/OgjHtqB1Gr0EBupTGofmLeXKkGYouTOo4nqQh4TP+tYlcNfAoKV9LLXHn9Es2D+TlXndqulMS1PUxWwRQJ7uJEQ81iEDwfJEhXAxI8z3B+3V4+KAihALQg/PKz+FMlTceq7sgXhr19mvgjfv/IYd2AD6Wi6QyZn4LBqnwq5iRMew31OmiXkySEtW4PARCTVYVSIeeuR3qqa/rgSvNQjbXoOM9F5GPHcJjeSM/UpMCy3tKSltMpADuwMXliO6rrMep0yxQubySzLcI+8egeV05qL+tZ81qM6tvn+kifjo0CtmZBCEparGz13v1hmIWSlWYHYrq4PRJUFMx+6unhFYqXFfnb5248Tv771Oe62g/2bPQMKa2WLENZVkGyw6OBqAb5RRvsn2dIuz89S+FQFOeY/54IDyogatrFZ+O5t8+KKNJ4L9uDgwMkTvz6pN4bwfMAJVioCxjhaseG89M2PMa5+gbj/jzj6tUBDbMdLrPceeMQ05G6hLeKQH6nioXITIPyrLYkso2lwiMD5feY5/L2v0mzR3yDoETMgeqKdOMblm6YSvqqUcvBdYTTQbLFwUvrhP6UchfXOR3bZMushnDZpTvZ+zTBsUyreVQChVou3b3Qnu3zEHq0DuPAjgY0HYP978q8ZLT51E7+zYMCJOuR8k3YNQYyh4l3E6wYELJHzJAOuw4tVTgnec2hnWHYZi8LPZdeGKPHx1l3uHkQlQ58s7yW3sofHsrlNy/xp9075nfIdMRBFaShe3FHH7YP3ksyuoHjqELzwtPId08GWHJLZdBT6O0gye8NXNkFm2K3Sqn9S45Iq2l57xJhnDs01wem72w3zfxCqCY2jx0XlD0bvksgeqcc/a13JLvwDGapU7CoOZnISdQpYr/C4JgebYh8vOUJINmecHUH4hK6CpjIIEXmCoQkMDJkHqzFeTGKauwFs3MSuwSCO+gs2ALBgES0uZHc1c
 jMDsKlHz
 iKQOhCcP5dLEUr9gdpLc0twroJcHxBcJ81WV73daD1Q9bAhbQFPAAZRMB36t89407XBLqbX+/4YyGU8rQRKYq4kxKCE6H1KQwF0S6eNL4fXvp7Av8fZNFysRyNCx9YvgPuS/WFCL3aJNM9XedubUxjtfyAYjWVlr2wWaBIYxAlPLCbOia3WmwTbIwsZbNpocLb1thhhrKEv2HOpLyPi6w3BVo/MI+dX/ycp2rzUF1Y3P4OrhYyZik/nquQ2odW0ten3exjFsAcNCJrHSVdGr4Mgtlmvnoi+yqGPmmYjcs9Ywpt42+lyV3L8MPxnKVXfV5v8BD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 05:17:36 +0900 Hyunwoo Kim <imv4bel@gmail.com> wrote:

> On Tue, Aug 11, 2026 at 12:37:02PM -0700, Andrew Morton wrote:
> > On Wed, 12 Aug 2026 01:18:57 +0900 Hyunwoo Kim <imv4bel@gmail.com> wrote:
> > 
> > > If ->pmd_entry() sets walk->action = ACTION_AGAIN, the pmd_none()
> > > check is retried. The PMD entry may be cleared at the point of retry.
> > > 
> > > In this case, if walk->ops->install_pte is not specified, the code
> > > continues to the next PMD entry in the range without resetting
> > > walk->action to ACTION_SUBTREE.
> > > 
> > > This leaves walk->action erroneously set to ACTION_AGAIN, which is
> > > incorrect.
> > > 
> > > This was incorrect but not problematic up until commit 3b89863c3fa4
> > > ("mm/pagewalk: fix race between concurrent split and refault")
> > > which updated walk_pud_range() to check for walk->action ==
> > > ACTION_AGAIN upon walk_pmd_range()'s return, causing the PUD walk
> > > to be retried.
> > > 
> > > In this case this results in duplicate walk callbacks being
> > > invoked, which is erroneous and will break any caller that is not
> > > idempotent with respect to this (and waste time for those which
> > > are).
> > 
> > "break".  Please describe the breakage completely.  It's really the
> > most important information in the whole effort.
> > 
> > IOW, when fixing a bug please describe the userspace-visible runtime
> > effects of that bug.
> > 
> > eg, what were the results of the fuzzer?  
> 
> To be precise, this is an out-of-bounds write.
> 
> > Is there a Link:?  
> 
> This came from a local fuzzer, so there is no Link:

OK, thanks.

> 
> > A stack trace?
> 
> ...
> 
> Should I send a v3 with the changelog fixed? (in 24 hours, I guess?)
> 

That's OK, I pasted it in there.

