Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41B5ECD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F5426B00BE; Wed, 13 May 2026 11:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD636B00C3; Wed, 13 May 2026 11:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609CB6B00C5; Wed, 13 May 2026 11:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 511776B00BE
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:34:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF33D16020C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:34:00 +0000 (UTC)
X-FDA: 84762792240.01.413C417
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 06F204000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:33:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uaOVvZVD;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d056Y3Cq6suaA/pOllX4Az81RQiajaWf0jULa062EJ8=;
	b=ZsfK9ZYfF1KwZgLO/tlD0ZDjgEaq125S5wfiEPaLhIAPDJmMma81SfTVQWUfC0B/Aq0aJZ
	R1Ym00skukxsDCM8Cp1yiHINnCCoYtewOMQuyHfZaVsGjdUhzifR9xeS3nCChMKMmAmEmf
	R8VzspVylv9KeJaYNWahiqq1OoXN0EY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uaOVvZVD;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686439; a=rsa-sha256;
	cv=none;
	b=VZmD10HSd+JVkzHQvKNB0IWa+j8UqC1pb9fUgp7ThETW3kc16XF5fwmSOjiYnD4dkB5nye
	YGm4i9WQEhC4nngoHfppFCbNBbJelv9C23TaYecJ8PRT6qiTEs2jTQGAWm6zP4YLSMJWNF
	Eg0PAonvLOLmOlAOY4CuwCyvC+YVbQ4=
Date: Wed, 13 May 2026 23:33:50 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778686436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d056Y3Cq6suaA/pOllX4Az81RQiajaWf0jULa062EJ8=;
	b=uaOVvZVD8ekjdiJoMztdeJnPg4XCOz2LitS06mcSACb15GNMk0YpJFUs7rAM6ApmoCRpDU
	ImYOquQ8dHNiZv+hvkUzvLHLB4SFgzBVcL0j1z1Lm9ibPALHP027rB5fLxhI/dTQJ5IVUs
	2MFAP0WkuqvBWtOEJ/pGJ0loeZiFRMA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, baohua@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <agSZ3hZJTBAjgVOn@MiWiFi-R3L-srv>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
 <20260512104201.716213-3-baoquan.he@linux.dev>
 <agQM8YJgiMxGlI34@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agQM8YJgiMxGlI34@infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: j4rgpjesqc77mfphqyzsx8ef1z9edmz5
X-Rspamd-Queue-Id: 06F204000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778686438-793839
X-HE-Meta: U2FsdGVkX1+rurMecjQmEcS04VTME+mRXzf2GjKxzigDx7vz2wOSzyXrMdQA2ak5DnmDl9ld4qA/qceqq26ue7hxe7etVVAAqAwVFK2oQJtjHewRnWs763lye+nspMe9uA7mwbHEWb/fhUNvqk3lAP3Y6MfHjKORRpyXvXXi4QBsSm2fRy0jPfTmYjnsKf6x/ik0qwNSlK5p8onRzGDNXJ0vlSN82Q1fhyf5zCUSgyweRS5MI3v4loKW94NPB4ihnTE0bHgZNCeHPYSL0X+gK8+ogpJe2pDXyaUw01wC9U2vKbHeZg4PhJfSIinPOp1+yT4N+FmxXgW1h2Wfcjrp7m/AWvkgTegsszlzgcLSdcq10pO93UXVrMed7ijIUsNNVT4N34YZox+Y2Xw/ra2apQkZTwLBAAb6o+MKMaldjt0w77GSi9cUHD9ncy0M4cXsxEexKQto7qvr9yADOTO6cyyIh2DWVWcwy/58OlDrV1eD/87ZmBtwJgpgmVkKBUWnxn5/wYJKeklIhg1TbaCvCefbS3gezM7kVlt0ydeiUJ7Uurbd7ghPqvKQB+U2zU2m/oPqP9ULv1Gd9iZFiC9FCC9JV8nnp+WSf5odL14z5DhyRgkGlcxdeOcaKyymcBcbl9nGlEc3JZeV/+GX7HgpXMiRtYnAiDFqQ/eUie+E7fXg5iRLJVkUhvznEBHRM55pvGwp4+DBH0juGp1bMxqUGj9OG9fpah1gzh8R3wO7KPsROKi1C7grEzXEPbNHwC0BJKCNCbGtvdQhgNLCtUmTlFaJmk8gqvy/99hn25vQSN4Px3AYyfd0Mv3hWIpnNKs9APwwV6WNbKuu6kZ0Sb+i4RNAXzaZs/HRUvwZd68KUN1E9HG2hy8RO6ptiLPqMBUcVGPQuBJh6XYp3m2fMP/ubcwJeRLIXpkL8Nu9oBE9j0bZCXx9eW9hiNMmvdtFBb/K43rzH1SgErv0pFqLre0
 YYL39hci
 sS4d2t4NGtIORyb66Wt67ZJK73NbK32MvEMesqQNSSjUADG2JaAXIg9NrPpfMtPhXOe41VctJEwtAz3mG9iZuv9Tx0adP5hbINbBkVt8pLnEJfbI5e1qfCDz3VR17Id/59LLCiD7/GoCpiPDk2PQ9Tun58jyn03R/HNpNvxD97x4NCm9ZzYfHiQKQovQz2kN4bpMkfPcffjUH2rGlCGfcVHswToCqy3eUh3hmPLWnnaBZTAhkbk67ttz7hrHyDv+lIFBFpIvSjkDWy45xTc8HghZxrvoBlgS83OWMPyJDb62DNpbet5Zjor+3eYXwZSf610uQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/12/26 at 10:32pm, Christoph Hellwig wrote:
> >  };
> >  
> > +struct swap_ops;
> >  /*
> 
> Please keep empty spaces before comments.  And keeping forward
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
I may not follow, I noticed that all the comments in the code use
tabs for indentation rather than spaces.

> declarations at the beginning of the file makes them much easier to
> organize (although the current swap.h is a complete mess not only in this
> regard).

Sure, will move it at the beginning of linux/swap.h. Thanks.

> 
> > +int init_swap_ops(struct swap_info_struct *sis)
> > +{
> > +	/*
> > +	 * ->flags can be updated non-atomically, but that will
> > +	 * never affect SWP_FS_OPS, so the data_race is safe.
> > +	 */
> > +	if (data_race(sis->flags & SWP_FS_OPS))
> > +		sis->ops = &bdev_fs_swap_ops;
> > +	/*
> > +	 * ->flags can be updated non-atomically, but that will
> > +	 * never affect SWP_SYNCHRONOUS_IO, so the data_race is safe.
> > +	 */
> > +	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> > +		sis->ops = &bdev_sync_swap_ops;
> > +	else
> > +		sis->ops = &bdev_async_swap_ops;
> > +
> > +	if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
> > +		return -EINVAL;
> 
> In the long run setting these from the helpers for ->swap_activate would
> make more sense.  Also as ls long as the ops are a small statically
> defined set these checks here are a bit odd.

In fact, except of your ->swap_activate, I have my ->swap_activate too
queued in my local branch. While from your comments, seems we don't have
conflict because we have different concerns.

Please see Youngjun's comment and my reply in this thread:
https://lore.kernel.org/linux-mm/aaWiBaeSCILBCzqd@yjaykim-PowerEdge-T330/

> 
> I guess we just need to land this ASAP, then my swap_activate series and
> then do a big round of cleanups for a coherent swap interface.

This patchset is part I. I posted v1 to collect suggestions, later I
took a leave, then people think the v1 can be merged firstly and helped
to post v2. I later came back and continue to push this part. If you
just found this patch series and come up with those cleanups, could you
wait a moment until we merge this part and part II is posted? I think
the split handling of block and fs in swap you mentioned is super cool,
and is beyond our plan.

> 
> > -	} else if (synchronous) {
> > -		swap_read_folio_bdev_sync(folio, sis);
> > -	} else {
> > -		swap_read_folio_bdev_async(folio, sis);
> > -	}
> > +	sis->ops->read_folio(sis, folio, plug);
> 
> This is a really annoying double-indirection for the SWP_FS_OPS
> case.  I think we should have one level of indirection here.  One
> way to do this would be to remove the swap_rw operation and
> implement the swap_ops directly in nfs and cifs.
> 
> 

