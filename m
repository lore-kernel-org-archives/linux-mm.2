Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28045D2CDF5
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 00:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4D3A6B0005; Thu,  4 Dec 2025 19:38:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD67E6B0023; Thu,  4 Dec 2025 19:38:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B774B6B0026; Thu,  4 Dec 2025 19:38:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3B6F6B0005
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:38:58 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26F011330EC
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 00:38:58 +0000 (UTC)
X-FDA: 84183557556.19.F5EF5F9
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6FF734000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 00:38:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fMDTkzEb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3nykyaQsKCAwmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3nykyaQsKCAwmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764895136; a=rsa-sha256;
	cv=none;
	b=oWbasVUVTGeTr8JZdibOHHlc1v0OVDOMs71yxtJfCkukM11W8X72d8uxy8hGU9YbdUbCUM
	YgHsbsjWR2scDTdKYyvXcyOj504amwyxxgphLkRB1EVWzgp5+zbHG1PH0SvU7q76b1UPKp
	DYQlfuCMTdfshFePbktrjw5MFhRhuFo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fMDTkzEb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3nykyaQsKCAwmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3nykyaQsKCAwmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764895136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRGGucjhuVnCsCWM106TPSms/6ZdG6m5JJbmww1ag3Y=;
	b=26y2oNEV+Qg1Scedmu0PFtvoD/clg8ANVRv8cOcHMNDSCKqqHr5Pza02yzGW3GYH73K5aq
	xJkSIvAT6g62jULm4wuqS0m4h7fPkwK/blmC+9ua0kbOP/rjiviPdlDxn3AiVT3H4fK84b
	872PZy8CE294sjOVOPZo8LrfOZfKzoE=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7aa9f595688so2426653b3a.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 16:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764895135; x=1765499935; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jRGGucjhuVnCsCWM106TPSms/6ZdG6m5JJbmww1ag3Y=;
        b=fMDTkzEbMsFsrkGoIcEwnwrgskbtL2ExrBObPj/SdEzKxt73MerNo39Pr51NhiFrNT
         zHLlT9KKYKgqKTHT1R1h4zugLcqcUeEZmD+l+3oNQ/YCpWjKTqyGkX86XcJ30+5YX3cy
         9L+2n7KFdDGNxrJCuEc1Cttm+YBKhd0P2iDmRpy3+4LrF2Z64ujBhBXroXBW+BcrPwtk
         MGq6mqYAOl5d9LjaUEoGmDa9Bf7KkqZ/fzp+CEeTY8HE368oOB9zYGwwt1ZdNn77IMTc
         fqJ6DDwDlsnIGgZUBSa0BZHVc6+abxUUKJ9Oo3+l03I3tAnQwJ9HIESgcXrzHSij+sSN
         w0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764895135; x=1765499935;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jRGGucjhuVnCsCWM106TPSms/6ZdG6m5JJbmww1ag3Y=;
        b=sWM/ds5l2VC+zNLY343lGtKxsHB21Gn3v7HzDbf6ipuB20El4RURDOl8ZrK35k6vnZ
         WEROzrIRPan9IF+1AO787dByBNW6sZDwfA+wzBXMf3qt0DU1vO4X0TSadrYz3KUTVXTH
         gm7BOZ5LoXDxeBU1sI5G7wxDoE86VQtDPGj0BuRFSiYvNTdI9xgTMLzVM59OMTEUP6AH
         DSCkI//91kXu0nMpmT2pwSJvVtcxkF+3UHywsI4BgB1vu2B4SIhinUkEZsTmmutCZ2Wp
         SV0o2jSvR+r44F1yR0KmZwjkIcY0+m8OxAz2NA3JPFDqjyNaURlN6FfjswlbdBxpBfqb
         L4CQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhQXNGQEfHdFpWwye3HaFWjhtdtEMSwBM/iLHgYoL5NIFzSknYuUvvso1dr890Q7+l5S67qyvrSA==@kvack.org
X-Gm-Message-State: AOJu0YzbCj/hDk+39ANTbW08/eXHhPqXqyW8MRTG1vkP9QuxUPO5i0cz
	gggKg4/tuT86ftZkWK99Yv4fHQ3LgdMjSHIN3KsBdqeeoTMgZxpTloWP6o1SjMTMMD7kvCwm0P+
	oF8/JxxB0e4FDPoeN8uGYTl3CYw==
X-Google-Smtp-Source: AGHT+IEI+4QWSaT65yNp/2TgxcZCaFaqgv6I/9Ib9/x1qCnTFXLErIvauCddCu2q9NT77PNc/mruEXOJV7Fmqs3GVw==
X-Received: from pgjr9.prod.google.com ([2002:a63:ec49:0:b0:bac:a20:5f05])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3387:b0:342:352c:77e5 with SMTP id adf61e73a8af0-363f5ea890bmr9279671637.54.1764895135064;
 Thu, 04 Dec 2025 16:38:55 -0800 (PST)
Date: Thu, 04 Dec 2025 16:38:53 -0800
In-Reply-To: <diqztsysb4zc.fsf@google.com>
Mime-Version: 1.0
References: <20251117224701.1279139-1-ackerleytng@google.com>
 <aRuuRGxw2vuXcVv6@casper.infradead.org> <diqztsysb4zc.fsf@google.com>
Message-ID: <diqz8qfh69uq.fsf@google.com>
Subject: Re: [RFC PATCH 0/4] Extend xas_split* to support splitting
 arbitrarily large entries
From: Ackerley Tng <ackerleytng@google.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, david@redhat.com, 
	michael.roth@amd.com, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6FF734000A
X-Stat-Signature: meyyookqg4hca7z3n1o98xkgpn3n9uwq
X-Rspam-User: 
X-HE-Tag: 1764895136-825375
X-HE-Meta: U2FsdGVkX18wb7dFedsFsnp5vfa27IF6dbUsZcEyQ/DHSsluefos0U23a8JohrWG0UPq7+g1gOsuytRrA1FmvJj0IFYyZCrdnXfM3MA5+UYDkx6rVaJjhkUxGekrgjlsrzQvxsQcU9nVGr4OG0b7ZtCuC0VFZiUfQWEw5g8l5ckrdE9Ujgrh1giO5ThKUX7tib058jFyePlGPRaJIPzaUTpqY8sctbj45cwKTDqbl6sR4AmE9Nejiy8TpkpXVnbP673KdPZYxOvJuRx6KfUf4BQNdZSf2rpG+ufgLnb+OmkZct1B5tv2mIp8xzf3CJlTiVuTaxmWg1NUY6/u3Bu+82xgmw6+8WAfOG25K8ADPDbSLWfk6cNT8MHVwFGA+yXarmM4h6FlRjxNfuDagKurm5f0uwDYNrtMYayyzAW06/Kh9y4b/5V4cy0AN2IvcwqyM8KS8Nqs9ixrvFXWlY2vMwd4q4CfucQSH/uynDa3AqOP3SxYPKCbX0nco8DdZaLghgEb6RQdbe9uh0hcIscYX6jo1U8PnERmY9UO6Gvo3NP3Mi4ALoqcqFkfOmOknW/BRGoe38D7DTdEOHpkfE7fTMDPQgnsxTIIh0M8e6A9tPbe3KdS0LzzM4izu/vs1piXWeDHsB3T3/q6kUYC6tZlCirk9egLY7pXm7PEpsA3zVTgUUOXp+xoYSP285QbphytYXMdQ1w0gBvKxOmx2Q2OVcv59+k58+opLpQaQt92QPjLTVtKx5dITUlVuohRo4x4tbHL+d/UhBI9yp7Etd4ODM063T/b0vHHWZm3W17Q8jcRPWPBwVUWtTnWOCtzXjn8hm6bVTYk8NaPJrNuJZQgjJDb/hhBmJv89s/BHv9OuU/TSjH+oVfGSyVYoRf5Wpc+egwaIdAW6ZKX2vSQk00rtQwy6sfXZcfmAsc58SceDRpwQ2YxjtvsRg5NameAeJxjOuGcm0JIhBwvwZgHQZ4
 z5fXOjQd
 SHeqIQYFy2m6Znxb8dWHMIqYVx74q+WzSaPjGAZlrmauHD5PlYEJlR4uR3VV2w48V7Raxilb7F0TdQXhYovAcnDpnduCKIJ23AnuUOvmvX5tYmlLoCaIfZFaf05bMZlrecFD/+nyaQHG0UG+fpXY8+rObgn05gNVSY3Yo9RHq4C8vmRiU8UqEGShCUPis5MlRGrJMd0oSVumzIB7F+sauy512C40wxvzj4jow6QmNWoYbmTKJMjuC/n03ACkFrGc7/qpRWfmHTy5nKn5kqjsS62aE5UhkXsXD7adJCRGurd8lEgUdpRBv9+Hi/qrrvReA+A5bp6KQVcys8om4kQoRPjFEwtdtKUJ38U+HbyGRtK0yBVlPBB9Q+z7xpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Matthew Wilcox <willy@infradead.org> writes:
>
>> On Mon, Nov 17, 2025 at 02:46:57PM -0800, Ackerley Tng wrote:
>>> guest_memfd is planning to store huge pages in the filemap, and
>>> guest_memfd's use of huge pages involves splitting of huge pages into
>>> individual pages. Splitting of huge pages also involves splitting of
>>> the filemap entries for the pages being split.
>
>>
>> Hm, I'm not most concerned about the number of nodes you're allocating.
>
> Thanks for reminding me, I left this out of the original message.
>
> Splitting the xarray entry for a 1G folio (in a shift-18 node for
> order=18 on x86), assuming XA_CHUNK_SHIFT is 6, would involve
>
> + shift-18 node (the original node will be reused - no new allocations)
> + shift-12 node: 1 node allocated
> + shift-6 node : 64 nodes allocated
> + shift-0 node : 64 * 64 = 4096 nodes allocated
>
> This brings the total number of allocated nodes to 4161 nodes. struct
> xa_node is 576 bytes, so that's 2396736 bytes or 2.28 MB, so splitting a
> 1G folio to 4K pages costs ~2.5 MB just in filemap (XArray) entry
> splitting. The other large memory cost would be from undoing HVO for the
> HugeTLB folio.
>

At the guest_memfd biweekly call this morning, we touched on this topic
again. David pointed out that the ~2MB overhead to store a 1G folio in
the filemap seems a little high.

IIUC the above is correct, so even if we put aside splitting, without
multi-index XArrays, storing a 1G folio in the filemap would incur this
number of nodes in overheads. (Hence multi-index XArrays are great :))

>> I'm most concerned that, once we have memdescs, splitting a 1GB page
>> into 512 * 512 4kB pages is going to involve allocating about 20MB
>> of memory (80 bytes * 512 * 512).
>
> I definitely need to catch up on memdescs. What's the best place for me
> to learn/get an overview of how memdescs will describe memory/replace
> struct folios?
>
> I think there might be a better way to solve the original problem of
> usage tracking with memdesc support, but this was intended to make
> progress before memdescs.
>
>> Is this necessary to do all at once?
>
> The plan for guest_memfd was to first split from 1G to 4K, then optimize
> on that by splitting in stages, from 1G to 2M as much as possible, then
> to 4K only for the page ranges that the guest shared with the host.

David asked if splitting from 1G to 2M would remove the need for this
extension patch series. On the call, I wrongly agreed - looking at the
code again, even though the existing code kind of takes input for the
target order of the split though xas, it actually still does not split
to the requested order.

I think some workarounds could be possible, but for the introduction of
guest_memfd HugeTLB with folio restructuring, taking a dependency on
non-uniform splits (splitting 1G to 511 2M folios and 512 4K folios) is
significant complexity for a single series. It is significant because in
addition to having to deal with non-uniform splits of the folios, we'd
also have to deal with non-uniform HugeTLB vmemmap optimization.

Hence I'm hoping that I could get help reviewing these changes, so that
guest_memfd HugeTLB with non-uniform splits could be handled in a later
stage as an optimization. Besides, David says generalizing this could
help unblock other things (I forgot the detail, maybe David can chime in
here) :)

Thanks!

