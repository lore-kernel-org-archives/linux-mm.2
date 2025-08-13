Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECB1CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0228E01C4; Wed, 13 Aug 2025 02:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960C08E01B6; Wed, 13 Aug 2025 02:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850178E01C4; Wed, 13 Aug 2025 02:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 737108E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:59:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2046B14022D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:59:28 +0000 (UTC)
X-FDA: 83770833216.18.5940C58
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 77D564000A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:59:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mysfgMxq;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 209.85.219.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755068366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4c2Exxn9N8GOxJ4EP0dbpK/kCpIo2tAYpKzr78hu7S8=;
	b=o/cXVEKbKlLN6EgO0dWOkEPcIQSdAFk6nNKv6ExJMvTmmwMVEy9RdTACSwQ/fbUzfri847
	fcRab6RPrefvHHSF5lpJ2KQb8Yq2QxjoKhfqEXveSlr/9+vX5KYM/St8ds0H5MYYWDw6Qs
	Gesp+HxhN/IFXQLfaDCRIb6fjUhoKtQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755068366; a=rsa-sha256;
	cv=none;
	b=4FbR06txEwdmXvQ142+hNO35Pb4pLCMcUati2T5lAMUrTK72o0o2It4yAdwQj90aay2PlT
	rrcYrtamatKhpTuhuI82i6Fy8R+TpRtUnbXq99h6/tthoeIK/EUxF5p8E22X4Fk475J2G7
	Irs2tD2yAbmnpSWRY5UzdaQJUvPAWbw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mysfgMxq;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 209.85.219.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e8fd38cb2abso5138005276.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755068365; x=1755673165; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4c2Exxn9N8GOxJ4EP0dbpK/kCpIo2tAYpKzr78hu7S8=;
        b=mysfgMxqtAbP8VHsPl+xayKn0I9EN8YL8jLtAQbMXcHpgkshgV8JaNBLPutP9+AiYw
         Vh7V+FMNpkSKUNzFqrjdtBcO+oQZ03v8ysyG8QFjNGNe/7Fz6ykOFS7EIQ1jCrGX9OJt
         1GMaccY6wYkUtaopRi+BFkiWx1qQhiZu85mj/yreDXamN9G0HE2fWWLBpfuWq21KinpB
         nvnt7kYE82BikAn+PveYewDIO/eDqPM1qLTLD7+D8FWUgAE1PPlyR8k+g12Q3+D04xex
         +Wb8aYmouA+++LAkugRMykkss3dYPT9ta04JCu6Skgm0Mqma6HijkUjJFzwSTT4uBPt2
         rv6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755068365; x=1755673165;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4c2Exxn9N8GOxJ4EP0dbpK/kCpIo2tAYpKzr78hu7S8=;
        b=Malvi+pv2uv7HnCCCo5ALa1jeG6ismOe28yflqTRgU/NcZ+um1pr5PK/4DcDyGxee/
         E5nH/h2ak/WaKrdW+2R57uHHq1YT9pivd0J0ys55T9pMEuTqz271yGLIugA6dPZUJ6oG
         dGKqFfoob97yQne42i93IqmS2Wtnsdcu7cEnRFs4EvMEF6L9pp9JwFQ5OR1LN83bhB/w
         elhhLwGEPzuWn4eCRHzZZQUURPG7oc7g2YrE2hdQAtYzD2QiUB83cOTIo+ifQjv5n4z1
         tIRjsW1WgLs9409Ms/wENDxRwVMIHpKyLD7XAndr8Y1AAYiCEKPchIexiO6Mv0q/27CL
         2Zjg==
X-Forwarded-Encrypted: i=1; AJvYcCU52O/Ivw9/YYpRbadcYMBXkkxowmg/mL/zjetTJNay+5blXY7VAto/p7hla6bXGYuAoutyTiwmzA==@kvack.org
X-Gm-Message-State: AOJu0Yxx5zJffIkuoxn5PWxfXgSFbqI+cEvvAECAnvK/rS0cBQZ48+Rn
	eY9V9BNFQCdJZgDTAiaxcnJIs4apkQ2dg/tvMuFWRUGQHj/bCpflyUN/NonzcEGztg==
X-Gm-Gg: ASbGncvqqCdPel5JWeUv6j8W6JiUQGaIHXotA4ibYDmHljeEY1D7Nf7m9JuSPsHpe1a
	Hlt2IXnmXEHMdFi4nKF4itMUQDaYaWr6KdOkb0DTKfvxQ1ZBYU4eloIvqIdP7KeuozL5iAdfe+z
	fFhNK7dE5Liw58z5uJxV+cwGZ70k43NaBnzQjtIjjBYlZPMMQvhyFS0TNKMIEyYwKeQaY2wRuEt
	yyNRODgkwAKLGPxRYIoCj9BpeMKwc0STbDrkcTWMdZ9fATbNX5TRt4O3fiTmoBiMYV3pmps5sYO
	IKbOewQQ2FfF5u7YbBrZ4KntozC6aBz4b/KI3mzz9hgBsxIaJqNmxH8U7Qwh7xqbkCQhhkZXVpr
	ZF071RGDisI9NvrJDZDTb6PspnvHlSbZvH4j/0an4xsB63FnV9aAkwTNWQVPaVAGKzLcNFpbXWk
	S7c800P+Kw6ZnrpHm61A==
X-Google-Smtp-Source: AGHT+IGB8+DtY8l2es3xfQ1AnhxzKizng1sEXEebwAXM8umoPlukJ8aYL7FjuHimETfAZ2KECwCAgA==
X-Received: by 2002:a05:6902:2a8d:b0:e90:6e1f:56b3 with SMTP id 3f1490d57ef6-e930bf3ea4emr2208666276.7.1755068365140;
        Tue, 12 Aug 2025 23:59:25 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e905a067e86sm3927980276.7.2025.08.12.23.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 23:59:23 -0700 (PDT)
Date: Tue, 12 Aug 2025 23:59:11 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
cc: akpm@linux-foundation.org, hughd@google.com, willy@infradead.org, 
    david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
    Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
    dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: shmem: fix the strategy for the tmpfs 'huge='
 options
In-Reply-To: <e6898dca-d6c6-465c-a373-8298858839ab@linux.alibaba.com>
Message-ID: <3705f034-808a-4afe-5dde-4b4e9815a8d0@google.com>
References: <701271092af74c2d969b195321c2c22e15e3c694.1753863013.git.baolin.wang@linux.alibaba.com> <e6898dca-d6c6-465c-a373-8298858839ab@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 77D564000A
X-Stat-Signature: k8fmybjqroj33bx9trifcqe95gkcfo79
X-Rspam-User: 
X-HE-Tag: 1755068366-490154
X-HE-Meta: U2FsdGVkX1+Zg/Z3Un/XYq5+Il0YjXjJVqZdELuZamPw4a86YiN0VrO+Vk61pKOiSmzeQp6BPl4jybk+TIlOE2gTAMjIKCufKvYR6jlgUUOBqoBNzizm15s1UyCs01LJvu8PG5h7R/KVMDNtftWmrCUYlyzqWimvgNFjMPmncrUf81hS80R/X/zw8A49oBY6vQDYyqGsxXNke2ofEwv3KemoqUEEtdiYuPs/XHlxAmfdZxr881T+iIfNy3qn76QO4o2Y6sqOJyIJgloCXxJU7zJXoKqDl7wqgR0vBoVK092YKITNeofiCb7ZPjbf57FMrVYGD8Tw7Ys5hi/ZQ16Kb/2FWmfXtKPN3iXHg+TmAazaWE8GItBOBfVa0jOuuu52GLXsrLY4Z4jycMP7iT6SuAJO9m+AQHtNk7GtgWBnthWLc3lGO8JBaLlM8RpVSdT8/oEQ4Wj8QmzXAXY7CC/9ScNSo6yJGENVu9iCEQwbwOHOhrjGoZOt0bJNPrgHg42VhQaDfB8HdPQZD234iVwOmMAZzXPst2Q4eD5sDd06yDbDRf681kXMcLU4ZEw/Tsv5ZKvuXwrRXAjz/KhBxFKQNjlDaPuAjDX8qYk0yDH+qbIKQj/ZHUBUdya4HqSw2m6Al+STk0Lxyj7ukZp4D2DuqC3nbqwTZ9lKN5IbwYYmH6KgWQE9Y8roUAu9nid0dyciHc45QEOIQlLi8ZwDyP12P9MIQ5lCEhMxljQxj7WE1gISaS1dZ9Ve5ipUrjZNguL6XkP2+LBZpV7BqyFeFVwudZj5EjbnvR8lPdNNVJVRqqfkwz3i17C217B6gQzNCbUChB5bMMuIFvxo+vPoQgTJxiPIZ4ZZXeH/rcJho+LLnWSsBBTdL+qPCe8d2NNkNjbYnjnuAm3rQrLKXWwYn5L7/+tJAqhQJQm1vQQ7QA0Chh+PhRFb2YrGwJsfv+WF6NoqtGf/e4WMyVtwVhAFLGq
 DXI683YE
 okmmDRGJTnSzMsfUVzdRuVikFyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025, Baolin Wang wrote:
> On 2025/7/30 16:14, Baolin Wang wrote:
> > After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"),
> > we have extended tmpfs to allow any sized large folios, rather than just
> > PMD-sized large folios.
> > 
> > The strategy discussed previously was:
> > 
> > "
> > Considering that tmpfs already has the 'huge=' option to control the
> > PMD-sized large folios allocation, we can extend the 'huge=' option to
> > allow any sized large folios.  The semantics of the 'huge=' mount option
> > are:
> > 
> >      huge=never: no any sized large folios
> >      huge=always: any sized large folios
> >      huge=within_size: like 'always' but respect the i_size
> >      huge=advise: like 'always' if requested with madvise()
> > 
> > Note: for tmpfs mmap() faults, due to the lack of a write size hint, still
> > allocate the PMD-sized huge folios if huge=always/within_size/advise is
> > set.
> > 
> > Moreover, the 'deny' and 'force' testing options controlled by
> > '/sys/kernel/mm/transparent_hugepage/shmem_enabled', still retain the same
> > semantics.  The 'deny' can disable any sized large folios for tmpfs, while
> > the 'force' can enable PMD sized large folios for tmpfs.
> > "
> > 
> > This means that when tmpfs is mounted with 'huge=always' or
> > 'huge=within_size',
> > tmpfs will allow getting a highest order hint based on the size of write()
> > and
> > fallocate() paths. It will then try each allowable large order, rather than
> > continually attempting to allocate PMD-sized large folios as before.
> > 
> > However, this might break some user scenarios for those who want to use
> > PMD-sized large folios, such as the i915 driver which did not supply a write
> > size hint when allocating shmem [1].
> > 
> > Moreover, Hugh also complained that this will cause a regression in
> > userspace
> > with 'huge=always' or 'huge=within_size'.
> > 
> > So, let's revisit the strategy for tmpfs large page allocation. A simple fix
> > would be to always try PMD-sized large folios first, and if that fails, fall
> > back to smaller large folios. However, this approach differs from the
> > strategy
> > for large folio allocation used by other file systems. Is this acceptable?
> > 
> > [1]
> > https://lore.kernel.org/lkml/0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com/
> > Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
> > Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > ---
> > Note: this is just an RFC patch. I would like to hear others' opinions or
> > see if there is a better way to address Hugh's concern.

Sorry, I am still evaluating this RFC patch.

Certainly I observe it taking us in the right direction, giving PMD-sized
pages on tmpfs huge=always, as 6.13 and earlier releases did - thank you.

But the explosion of combinations which mTHP and FS large folios bring,
the amount that needs checking, is close to defeating me; and I've had
to spend a lot of the time re-educating myself on the background -
not looking to see whether this particular patch is right or not.
Still working on it.

> > ---
> 
> Hi Hugh,
> 
> If we use this approach to fix the PMD large folio regression, should we also
> change tmpfs mmap() to allow allocating any sized large folios, but always try
> to allocate PMD-sized large folios first? What do you think? Thanks.

Probably: I would like the mmap allocations to follow the same rules.

But finding it a bit odd how the current implementation limits tmpfs
large folios to when huge=notnever (is that a fair statement?), whereas
other filesystems are now being freely given large folios - using
different GFP flags from what MM uses (closest to defrag=always I think),
and with no limitation - whereas MM folks are off devising ever newer
ways to restrict access to huge pages.

And (conversely) I am unhappy with the way write and fallocate (and split
and collapse? in flight I think) are following the FS approach of allowing
every fractal, when mTHP/shmem_enabled is (or can be) more limiting.  I
think it less surprising (and more efficient when fragmented) for shmem
FS operations to be restricted to the same subset as "shared anon".

Hugh

