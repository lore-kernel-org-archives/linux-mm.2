Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5B64CAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 02:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C1498E000E; Mon, 15 Sep 2025 22:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172178E0001; Mon, 15 Sep 2025 22:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AF2B8E000E; Mon, 15 Sep 2025 22:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFB628E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:56:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AE781607D1
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:56:37 +0000 (UTC)
X-FDA: 83893600434.14.24C6484
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E344D80009
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:56:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="dSmG/y6Y";
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757991396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2Ixty/6l+VYgrRmRKFbkPmtgjojvuloU1W1ISW6pkk=;
	b=npm5egahMosg2SDSk95OgZqyo5xyxivuKjV2mpgzQLMJNbU3wWnr98QByLsbs9h9GB0tgk
	i8fmGBvqj/pYl5ZxLZvFdu2xVTEYvClSEAVGQYOhm7PxR8WzgWn7XIGQY1wv9252jO1Dwr
	CDmbA8fGtgx0hgfQUqMbxfNSDiqLCMQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="dSmG/y6Y";
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757991396; a=rsa-sha256;
	cv=none;
	b=k7IdT3KtV1Nz4nbckz3h+wBaWDWVkIiSl+/oIMJXz6dfBlyl7yBCmYhLCvtbjNqKROumYb
	KJeF78rZ8iyFA04GAz/SpSa4GXfIO+AWGS0JAw/O1mxRcuaogvGcfPuuT5PXhKI9WQ++p4
	q0WxNcsHKwavQedzAnBUNKNVaBd0uKY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA656404BC;
	Tue, 16 Sep 2025 02:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E00C4CEF1;
	Tue, 16 Sep 2025 02:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757991394;
	bh=Lqqfdc/Z88iITys6vH5nBM2MADoPKk2rVcW4PfRKyKs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dSmG/y6YhD5RgWhr6cymEzxGPDHaRKB1M5O9QzE6dUQ4IJsjHs8VyuB2adLQcOgf6
	 Fj64P01S/491B0OBeAzu+I6qcHfcXqzpkEaXgZT59os1J+LxvaNatQHG0h5OD+XLGL
	 zJuYij4mJ8NY1soUO+8BgDtHEYHFis2nAq54wUtw=
Date: Mon, 15 Sep 2025 19:56:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org,
 usamaarif642@gmail.com, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com,
 pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters
 in /proc/allocinfo output
Message-Id: <20250915195633.96236cecebd8777243a770bc@linux-foundation.org>
In-Reply-To: <CAJuCfpFQCgQLSrzfVjV+J4tkYbOx_W9v-kWmoo-rmh5hs9gEXA@mail.gmail.com>
References: <20250915230224.4115531-1-surenb@google.com>
	<20250915171112.f71a7606a7f9fd3054662bed@linux-foundation.org>
	<CAJuCfpFQCgQLSrzfVjV+J4tkYbOx_W9v-kWmoo-rmh5hs9gEXA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E344D80009
X-Stat-Signature: r4nt7utik1bauxqf83sttqxpysfexuj4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757991395-836748
X-HE-Meta: U2FsdGVkX19HXKGT+bjaVcbp7z+tAa3kp28Rfi/f1inHDNq6+sl1l6fos8kXrgy9JtpXrsO+aJ9k4Q46KlvO9H/Q5jqAPhu9ied1ber9dIrvb4DaXzPSjAGSTM8Eh0hbeua6dMvh/NW/Dr/8tFJ5VmTatrcwOi2GhR1zKuuo5rCpWbuGwPftyMrluey9LMRH10hRrbHFnJGv4rF7PO7fXg3//SN83IvuXrgjvg7g+2qvQISU4gIBNCr1+xRAsRtSUE/RTTbdKhqr2HkV2IbZKmZQVs6wlDsnQtrN0GuPKJd4sn3D4Nvyl0i5gDi9RYQXo6GSv3v+4yQeFjmnsLP4UhMo/JpROmXqXFBwofN3+cqoM7DIHg56t3LfJwjZLtJ6h53HMRbH7/s52zR03CO3+80mdN0rmqdNO3IoZnJIKnqhjeNVB7IiMcTidJ6ZX6goLmExRebhV7QGyBxsuNNls9zKSTVcutcPvDUhSMof/xVbc9U4cUH0wHDd4VeOw7rBzjZCzR8opx56vA3Ck7O7enQz2FcI0nBo9MSb+REhoB8Xy2yr+iVN/0pVoOpZJv5B3GlmZJGlAw9h7k3OYE1414QS6AbX5zOl9hVCZoSxZcRlic9IsGLeHHQJlbHNZSJF5EW+In9EhKEL8RRg2WoIfrC+MhsSX4O21ACE/d1OxX+1adzfLXUrCWnCcXve2y8aDY8mwKLSbFr08rAxY8/bsNRHqobD1keLIu+nKBz4+IQgUBiSIb4keG9HBwp1ffa9gHlMqTEPWR1M0bf2bmgxncoMr4JCFSiy2WMlq2bqfMupZQagtujRrC7fJ8AVHssQ/YQlWN9ZzEih8trIFpmSP7GcGTKKnce7Vrx2X+bpr/CV98nZ/yj3MJdI25rqVgclprsRzs0vxmzGtrqu5e6bHzcU22atgxTSGKAzTvudmtrp8AkDL+UrVFGwXmP++U997O5HfnkEMnlwqAEsIbK
 WaSmTaN5
 aUTKsk7Jdlfz9GHZPZCFCcK0T8WFK6w88imTOOhTE6M8AYczkVNXlLXTj0tvq0yxCCaM0Egz9ZZYmTtWqE1GXWADSrPB/nRNGsBphu6bp6700lnN3WP4MZAcvHdgqArWe14T8EsQ+Xwohcn2tFvAy03tgAKdP5rQg17oU9XtOmmflC7UyxHcxPjVV8tl41KnR3pCPqab39TICtaw4qwonTVcvsZPh1lFmwBOU1EvtVS2WKZ/DILEKg0uWjDOgXQdzIxldTetyorRTWUDDi1uQ7RsGVxR2S0JSx+psTknIbZuWfNbUeI+snzXMf74FJiKcXj2k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 19:48:14 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> 
> > Perhaps we can tell people what accurate:no actually means.  It is a
> > rather disturbing thing to see!  How worried should our users be about
> > it?
> 
> Right. How about adding a section like this:
> 
> Supported markers in v2:
> accurate:no
>               Absolute values of the counters in this line are not
>               accurate because of the failure to allocate storage required
>               to track some of the allocations made at this location.
>               Deltas in these counters are accurate, therefore counters
>               can be used to track allocation size and count changes.
> 
> 
> If this looks good,

looks awesome ;)

> could you fold it into the existing patch or
> should I respin?

A little fixlet would be preferred (by me, at least).

