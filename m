Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE23ACD37AC
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 23:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8EDF6B02BF; Fri,  8 May 2026 19:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66806B02C1; Fri,  8 May 2026 19:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3716B02C2; Fri,  8 May 2026 19:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABE9D6B02BF
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:53:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E13040423
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:53:48 +0000 (UTC)
X-FDA: 84745907736.08.B6B273B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id A2169A0002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:53:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FyXfE1Bw;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778284426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtERP+6axMTYS4b6V07rZTRptsgU9hi1uWfhKjMa5ew=;
	b=tbC+N4P/F+WauyRb6LNADSJtjqN7MbMeXU0ilZUDVn1OvricOZFTacqnfKQd+gW8Ap36SF
	gRr7/0oUYAeJJwCRmd5a3OeGahRZtSptfn4dBcLcLP9a3jj9ZEIgOgUV8zjJobjFCcnKIF
	QHrecwLdIGrRbo7eMfe8Zip1w7UOs8I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778284426; a=rsa-sha256;
	cv=none;
	b=O7Q9ZU8y05CD5QjpRd/0+wfgQ6cPNzjOcmW7+PDeHzYgLOH046l6LXpIkbd8Yuk5zrES+Y
	1dDDSIv92dGXxjWNrpAz86TeVgVPkKFQZFTn1P8hKiQRZbJbMqzX9EiZEWYHS4/7pnpAN5
	pJmVJcylGDoo68iVWMXkFKAh0+tqtxU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FyXfE1Bw;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D4296024D;
	Fri,  8 May 2026 23:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A107C2BCB0;
	Fri,  8 May 2026 23:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778284425;
	bh=VWosNBs3YnxgmEDyU8/Ih9kX3QO9bATo1LcNhVdrsvc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FyXfE1Bw17tGd84Y1nB23Z4B842vomjgd0qwV5ygZ3GLhlA47c6eItIXl4WWJDTdN
	 s+U4YbcPMwY4QUDuBJwcHVVV8x89mBrzJTtzzv+f2R/Fo1rc4wnG3wUFzhx7NZlrGC
	 pB6Vh+khkAmXJXplPLimbtqRIox/coQg0jO2CrRg=
Date: Fri, 8 May 2026 16:53:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederick Mayle <fmayle@google.com>
Cc: android-mm@google.com, kernel-team@android.com, Kalesh Singh
 <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/readahead: no PG_readahead on EOF
Message-Id: <20260508165345.b40a73da1dbb45a95c55c0c1@linux-foundation.org>
In-Reply-To: <20260508181237.670645-1-fmayle@google.com>
References: <20260508181237.670645-1-fmayle@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A2169A0002
X-Stat-Signature: chtsk38o4cequmnntimnsh94tmiizjtk
X-Rspam-User: 
X-HE-Tag: 1778284426-215201
X-HE-Meta: U2FsdGVkX1/Mx45V0kN8VphghYl7Jr4J2157zVyeq2wb2hogsAjb1pkGJWM9dzSmSjPsSi7VaZ63YJyY71m7r1JjaGirpUVugisooZMbN7oFZUwx9aLiMcgAiKczIXW0EyFRrSTOtjXSGBx528FrtOAHWt1OqPxZn5VCtScxXCP6Rq6gyCNwh9zprq38n8AfmJQ9XtGhXrD20ozwm8w7fVLadO+3440QtpOSTEmIvLBYcajqq6NR1lCU8CChpl6RdSfRG9UuTZAKHsEl+2nq0kiGNl3PWTRAKmCKTC9QG3BnWIHwtnSccfVGNcl+j9fL8m2+PDyXPrrDNY+gWIkIdvBTlAYEHkzgf6k0nOIVthyG/Limj2qvetb7NLod0JhDh9QbUaxKSomN2tWGwEQtVxtHM1wC2ZIDC327N2+XE7iETDdjzHS9Kr8ti1PP5slcu+sJzsyvd4T7+fLTkNrnEBVJePMCqokfdnpk77FzTPy1u8tUjF6qk20fl3TNR3SYTaAqo2z4cLteDTFTFx9xQHSI2nAij6WynJfQBywhGjQWIyFnMBAsV4pU54vln1/s8xAiaMANquJ4Ocomt0t2F2/602MLFeiAZ98x5IiOuVy0CX2RMe95EYNFUUqAdTl8AoH3RTtL9qhWXTeGMEfUTxIbqF2Tf2HOWA703pTZqwzqw1Xb/NukDQbRLBZAQJwY3hQiv6SmcUnM0F8q5ZNUtUCk28TJvKx9i+TdxiOSSnuNGEW+WUXX3iZgb+Enbk1/g4EtVYz3GfE3+xA6118xazrki1W7o8rXLO7q5g3zHB7UVIoEA1gOIa2moO2P5csq83cIN0m57YovJj9OOfuWp6kN/Uivz3k+uXYWYOja/uccplKrgpsSl9RSWQLRJJX2Eky1yxGS8h8IXJ/TYGfsj3fq06S8dQKbiLvkGE/+F3LufegS+4ce3bsMygRw7D6CiLveEiwrFN2ZIBigMVL
 rj16DWkl
 sMzzwRUvXRvUTWa2CjV9ARnkD4NVf6s8ulFd+7QFE7JYITzwp/8PoFSAQDEbGsGRV1VWydnL7Yz1G+WO5wZt0Xfuaqg+VIHQGJ35FfeI04NPWgwMnJMI2XhFCTj420VUaYZebNJmfF3kXkoLVf/1ikCHZK140Zzfwv23j2n0kmXAdDfwDgMk9pv6jVEuiFLS5FQ3eMaVM+/C7A5M6O3E3qMqxr6tGdYskHPiaXMplHRX38YB5zmJ1VnAPpljlfN6twnbS8Gq93fTKwlAQF7PPjEtjXycl3iWqR+GuhTZBM7ZpEqhq5e848PDzheflu5L3bnzoC2xOyHO4NfzwoHOh6S7X5A8diGazpA63uLsC+J9USCZyyVu6/Cay6IbhMR6BiSvsmmaGNkq43Ot3Db4GFn1M/mWLhJf5qWClYEHfT49OjAUtzOhZz+eooQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  8 May 2026 11:12:31 -0700 Frederick Mayle <fmayle@google.com> wrote:

> When readahead pulls in all the remaining pages for a file, setting the
> readahead bit is counter productive. The async readahead it would
> trigger would almost certainly be a no-op. Additionally, for mmap'd file
> IO, the readahead bit limits the fault around [0],

There is no "[0]".

> causing an extra
> minor fault when the page is accessed.
> 
> This was discovered when looking at /sys/kernel/tracing/events/readahead
> traces for a simple program. With the patch applied, fewer
> page_cache_ra_unbounded calls are observed.
> 
> [1] do_fault_around calls filemap_map_pages, which finds eligible pages
>     by calling next_uptodate_folio [2]. next_uptodate_folio skips pages
>     with PG_readahead set [3].
> 
> Link: https://github.com/torvalds/linux/blob/v7.0/mm/filemap.c#L3921-L3939 [2]
> Link: https://github.com/torvalds/linux/blob/v7.0/mm/filemap.c#L3721-L3722 [3]
> Cc: Kalesh Singh <kaleshsingh@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Frederick Mayle <fmayle@google.com>

AI review found a little race:
	https://sashiko.dev/#/patchset/20260508181237.670645-1-fmayle@google.com

