Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78060606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QR7Qz9nr
Received: by kanga.kvack.org (Postfix)
	id 9877A6B05B1; Fri, 20 Nov 2026 06:15:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936FE6B05B3; Fri, 20 Nov 2026 06:15:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84CCC6B05B4; Fri, 20 Nov 2026 06:15:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 658286B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:15:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 082751C48A9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:15:19 +0000 (UTC)
X-FDA: 85455241158.06.20212BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 584C040011
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:15:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QR7Qz9nr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795173317;
	b=UmkK/mQqXDlKL6ooisvNJezvV56LUQsQoZ5KkwUiGhLPqTgjSjSVqiXkjVfXf3yQXky2Z4
	GaDaFbI+ijKIvDAW0Qg0ltnX04POKxtRH+clJrHTTCurkWuSKkdfoniVIGqeoNJroWFHRH
	Z24wDTvL/1rk+lZyhwn31nAGzifvFzQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795173317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylpOa03watBXcc8NuGp5fAH6bW4gLkgGFrVyqJKXvOY=;
	b=4OtinK6WNXdVkIs0WYgPzuk7ZIY1Mfege3tjfNkEr2cDL4V3hWxHmY6EiQjIfgmDSogGim
	3Cm5rOF/vZZQvpPr+drxJhd121dmlieGo6dv8Z1tqdjYOpG6+s4sMRczCQ1J2P3GhK4udA
	I2CFR7KW895t6A/yqwKPCkgOKApwAUE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QR7Qz9nr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 869B3437A4;
	Fri, 20 Nov 2026 11:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E96B1F000C4;
	Fri, 20 Nov 2026 11:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795173316;
	bh=ylpOa03watBXcc8NuGp5fAH6bW4gLkgGFrVyqJKXvOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QR7Qz9nrT3mwQcuGWuPsIQVvTEaFES6qe+LLNtfCgbhP8DLQkRda0r6SljCNcJIA3
	 RhQYSTjbGiOEZhy64F/bbWEvfIfHWvAnH0LyjB3Y2OfSAQnNa2q6fkRty/yXsRSyOK
	 dw8F9YBO4lv10Q7htcqHB5d75OQKKxtCyc9MuudR0XEZ1pvSfZyzhCzrJAY6AtFz4S
	 puA8yRNHt6Q2F1w3C696qsg1aGm8MA3rF4qBtFtXWRAwVOktguelOjDQPzpa8MmjKj
	 SndII2p+uYuQk57BJoum0VFsX9VeZo843XWERj2fWjIvndreLk37E+92GdyVMuGYm+
	 WuiU0vhNilhJw==
Date: Fri, 20 Nov 2026 11:15:12 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, 
	Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Wupeng Ma <mawupeng1@huawei.com>, Ding Feng <dingf3ng@gmail.com>, 
	Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH] mm/msync: return -ENOMEM if page-aligned length overflows
Message-ID: <awArh0Xnq2FlMM_x@lucifer>
References: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
 <5b916aaa-cc04-4ad2-8008-04a57d8e83a7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b916aaa-cc04-4ad2-8008-04a57d8e83a7@kernel.org>
X-Rspamd-Queue-Id: 584C040011
X-Stat-Signature: eaw85z1h1z5hunyk4q5ifu8o8ig6bgsa
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795173317-309633
X-HE-Meta: U2FsdGVkX1+6ERETW80xMA58FYs2iVEHeQEkVLS3ZaI7TRkyEYEE5fZkAPrGKf+ihrvFrG3DP9Q069v2i9EjDto/rbtx/udG+ceAO0VNMWvbvLKn2Acbbak7OfjG3Y2P+SgF1wge2H5TrrbGzccxL1+rdqwS2jX1iGEe9j/v0ej5GLwy9h1Df7EhdIcBRxmb6nGYTN7eC0ghjEqAtTlSFNRpUNLxw4qVoWaIrE74C4ACNxkOqDFAglHH+OyCUR5LAopiF46X22LpwXuWYv9o0AAcMzNUl/JMQlukJZ7DhCXqhqkijyVjX8ydEFSuUFZaQMQDKw/MpgsG8bDxbhTTfS1klycBRv13pXk17OnAgeaZo13oCkue9L18uaDRFWOQCGqJegGFHbpJhlM0i6cfPWLoNEF9TpMLuYZvqtxPv3LGYHlp4OlciaaDOY4Tgg7IsVBFml3WkOZEGt3FhPO9ObbpZV5H316jh5x/kbC8YeMCQGVXZuohAxrXoV06WxoLkII1Vr5scpHALLCaHFvgKfKfe9Z6CLtypyMQD5IXypJ1xCL/1Jp1LADSkF58ZTe6/jseyQ+3aW9yEKsbpNEG4a9+NLJoUXSxNDhWDL7ln9bizxIl2tenSxRvTxCFUBJVahwwRclCJUE8JevcXwfs1j6Ca0sAt4tDHG269sLayTm5WgyHjcfZsV4LGzPRgYZ9otV2WPT3MOY1ult8rYN4uEWhXzRp+6USGOxnvzh3LQ0LSqm6c6ZhlnU0xFUUJG890d4PlkEOs7E7dj4RkY4G8XfH/dfgfsU0V9vLlUaf3Gwh6QIXrBrAwHdk+JFodAajyX9NVD7FsIBf86NyZDO4z7xyY8FbMtnAsbp5cECeeEAq3D+0za9b01TsL+dKGpNKI5stlGH77ngul21AcAMRUeVRznYDPOlKGzfzaqzhOLamZioWfut+xybGQ5mLrq5UDZIDqXF+3HCGvwZOTxZ
 MNCyhI4Y
 AeiSIKdwOIg0rOCBOuuEvvW+2a+i9uLqeBJL8kr6QlqWG4k4Yd/9Gwh3FT5yFka6x9NlAHjTqMfx8CLv0u/A4z9MIbTQg1hqBkcPCobGsd2X618l3NoxJTgPKiYy4kuF/ZSftTUenhWReZVtkYR2FjPFeMq8ZiY0B2/lGZJCiota8Qqw/xDJgGqwpLM7kAjtEuXirYdXVkvQmowQRRRrTOLtZZavtBU5vIM6fhMFJsZbKOug/2zIll/MnOTNP0sIyXCcuToWVwddmF6mZtLJU/9Qkcn6lJ1bO29cX/l2qKfgpHSu77jBVj0SlCMq2DO5UDNr6iUQD2HhITq6wX+Jbis0SWugBECSBc74g4yGuSsiAdaRW2kuaLDWuBZ9WHVe+f8ZPc1x3SBo8cgjLUxR+AMr914MtOW+JHQkPB+ai2SD2oByikw2I0T2m6aFrykKBpreQaJFI9rxDDGcH9KdKj9v/ow9TxXummBAEQpn+FD852J6qCbIgO9TcrdmqR3XFBrM5Xib3Ls+uVfB0Mnbn/Oir0B9YGvidHEJaPUZjaGL7bEQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 12:09:07PM +0100, Vlastimil Babka (SUSE) wrote:
> +cc linux-api
>
> On 11/20/26 11:59, Lorenzo Stoakes (ARM) wrote:
> > Currently the msync() system call will simply return 0 if you provide a
> > length parameter which, when page-aligned (rounding up) overflows (i.e.
> > SIZE_MAX - n, where n is in the range [0, PAGE_SIZE - 1).)
>
> Weird, as if it was intended, but seems to be pre-git, so who knows why.

Yeah, likely unintended but doesn't really matter.

I'd like us to completely centralise these kinds of checks for mm syscalls
but on the laterbase...

>
> > This requires broken input, and nobody has complained about this, but for
> > correctness this should really return -ENOMEM, so do so.
>
> Right.
>
> > Also, since error is assigned within the following loop, remove the
> > unnecessary assignments prior to it.
> >
> > Link: https://lore.kernel.org/linux-mm/20230321074035.1526157-5-mawupeng1@huawei.com/
> > Reported-by: Ding Feng <dingf3ng@gmail.com>
> > Closes: https://lore.kernel.org/linux-mm/20261120051413.46167-1-dingf3ng@gmail.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

>
> > ---
> >  mm/msync.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/msync.c b/mm/msync.c
> > index 90b491a27a14..ced41d3c2903 100644
> > --- a/mm/msync.c
> > +++ b/mm/msync.c
> > @@ -46,14 +46,12 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
> >  		goto out;
> >  	if ((flags & MS_ASYNC) && (flags & MS_SYNC))
> >  		goto out;
> > -	error = -ENOMEM;
> > +	if (!len)
> > +		return 0;
> >  	len = (len + ~PAGE_MASK) & PAGE_MASK;
>
> ALIGN(PAGE_SIZE) or something?
> But fair if out of scope.

Yeah can do on respin if needed, but right now I have more deletions than
insertions which is rare for me so :P (maybe not the best reasoning, but
still ;)

>
> >  	end = start + len;
> > -	if (end < start)
> > -		goto out;
> > -	error = 0;
> > -	if (end == start)
> > -		goto out;
> > +	if (end <= start)
> > +		return -ENOMEM;
> >  	/*
> >  	 * If the interval [start,end) covers some unmapped address ranges,
> >  	 * just ignore them, but return -ENOMEM at the end. Besides, if the
> >
> > ---
> > base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
> > change-id: 20261120-msync-enomem-fix-95f830e305dd
> >
> > Cheers,
>

--
Cheers, Lorenzo

