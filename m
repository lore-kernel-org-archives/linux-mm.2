Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A49D0CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 08:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FD418E003C; Wed, 29 Oct 2025 04:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D51B8E0002; Wed, 29 Oct 2025 04:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712068E003C; Wed, 29 Oct 2025 04:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 617048E0002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 04:32:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBF1D88E3A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:32:08 +0000 (UTC)
X-FDA: 84050484336.21.67D51A1
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id F41C318000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:32:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="LYU8/o1D";
	spf=pass (imf16.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761726727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/EgblGubgbnW5Hgy0d7e6d/LE+Ic8+V16TSffZZqhU=;
	b=dtqnL4SLRjaIvAHtUyE+gLVmX/T+EUo+C3FN49Za2dPEuheps8b6uEwtCMuiYixnfCOfZv
	DxU2fVAHLr7U1ayfqmrX1lNaMy6UuZLpFWm9D8ltB7i0rKMBaMWVB+om3J6LWAv6pumUJB
	B9lLkEON/k5/04bd8d7MHkeILPi5TZs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="LYU8/o1D";
	spf=pass (imf16.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761726727; a=rsa-sha256;
	cv=none;
	b=wI9lce0wFuES7rNmTw8s8TWBCzXi3BmRtv0P4ez8uHBMSWgP5taeFQ2y7SpwZngAtrXGWO
	dzPadeG9W6y54n86PO4aeLtBYXJvHe+XZOTe7f0xWTzm6z5q0A6XEqWfernaglYTKUxUnO
	ueRC7VYdPUfg0kGFYJf+iB/zxkExzps=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7829fc3b7deso56656027b3.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761726726; x=1762331526; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j/EgblGubgbnW5Hgy0d7e6d/LE+Ic8+V16TSffZZqhU=;
        b=LYU8/o1DhJBAXAcJwPAjQfHOev/0KJd2LF5d4oRY2NrxShoLvUYtS4CfpfvQviOHto
         /pNMtlMb9pRtquo05QPNRYTzwemow3CSSdUf0pmmXma8jCMC2kmrYoPYold9lG/QxKkO
         mfkb6p7Xrg47XMiSsYWoER6JhmKrUpGtyy1ZOnUBnTL/GzQyQgeRrHPhzI74PTEd3mQB
         3cE5htlqo/i/ngkRHy6iw2NYvhMzc0VRv4RWfK4M2WH9kZwq2EXNph7XLYoXxRIA+6x1
         PxUX0mWYbKtt6ME5hrSsBNpxQJtjNijuFmYe/KSF1AtBnK+Z0upbvnKNDaN5unKAKV66
         BqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761726726; x=1762331526;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j/EgblGubgbnW5Hgy0d7e6d/LE+Ic8+V16TSffZZqhU=;
        b=KCiSYt19oZJUzmiTsd7D5H/VxTCOleQ5kpDOtyAV38kWPJaI5bYVWJNVQGsM2IwF2d
         Jlwvbluu1YuhkWYHropIHydarYa8CgJLShe1X1W06MusF/r6a6ci6q/OQ39AzPX1Eu2h
         aKEhYPXiRKjsx5IGL/IPchMy3FfeSXUrQSRCNmRWw5xl4WJt37xdBq5ukz3BlHLsg21W
         tOjmkmrzAPe1+6H9knw9aSADJTc/+T4s40bVlqvQNRSpBg28aCxm5HdATF+/otJ7HTcL
         tSgHYQnHl8P7Hk2zdSgNbat00rfhR3rgoXrpYMECWJ5bchMDR/XGOMvB4x414sWf6P9g
         mjkQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1J3t4UQz1hYi2Bw+P4Md7VIC/b3IBwDJ0A0Pe/8A5MXdYcY6sFiN8TB20c9iddvW24DrywwOS3g==@kvack.org
X-Gm-Message-State: AOJu0YzaU0DFTSlXTQ8/oAVCiUBvP3aGTSxCTUuzVEpYZhqOQfV/oZ6s
	PLMEFis6TAHgHtHBrLJMuYD0SXZd6jdH9+o7+oZdtJlmSJ24V0OWM0dNKU5OwSqyrg==
X-Gm-Gg: ASbGnctv/LHHpLvW8YkAYd5uZRx1t0KwZ1BC799hzWLC+SjH50BdIi2FBJSXCvG0Ejy
	AYMDVT/JDpekEVDOg7aueLpfyiBjrzMeDRhyAkNFlUp/1KSHgxBEll3EfodZBTiy9kx/PjbboPj
	lFaxDefW7tE6sTL2NK0BDQ6GymZWg9oXazkR6TbXFoC7j/cHzSmUcFbqk1ZvxbTBKYJRgEgtKcV
	5JyWBAAeFQzYvafH80ne75aPVBBfgfiznAHyxRWf/seqdiMIERe4tM3MKT/aeTUh4JkdDUSBcwH
	lUlrs8hLk7TgaFW7+qqSHTZw+evHRLICwDKEqSbi+EexqtCu5gbPsaU+cDkmC15wQ7qp57EIoCE
	4vtBENtCwgGw5MVQRsJ+VyqAmk9yzVRe1nmQkwpYB8bll2dxuWcK/SshIwm44gP6XmGzID+/Zvg
	P3uyhVFY7E5POEUuo0JNDOjjBWXrLd4mOC9r34u2SkZF71JNPYpbp6GUK/FMssBZrBAIYnEDg=
X-Google-Smtp-Source: AGHT+IFVcmXHrgxMeuEDR2XWr4vAoODDTaHWS/nA8ziQ2WO9nTasjsDjFaROIorfvY19NOZaSKeT+Q==
X-Received: by 2002:a05:690c:6f12:b0:785:caab:e660 with SMTP id 00721157ae682-78628e81678mr18542897b3.26.1761726725736;
        Wed, 29 Oct 2025 01:32:05 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-785ed13e443sm33974877b3.8.2025.10.29.01.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 01:32:03 -0700 (PDT)
Date: Wed, 29 Oct 2025 01:31:45 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: David Hildenbrand <david@redhat.com>
cc: Hugh Dickins <hughd@google.com>, Kiryl Shutsemau <kirill@shutemov.name>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Matthew Wilcox <willy@infradead.org>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Christian Brauner <brauner@kernel.org>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
    Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, 
    linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
In-Reply-To: <8fc01e1d-11b4-4f92-be43-ea21a06fcef1@redhat.com>
Message-ID: <9646894c-01ef-90b9-0c55-4bdfe3aabffd@google.com>
References: <20251023093251.54146-1-kirill@shutemov.name> <20251023093251.54146-2-kirill@shutemov.name> <96102837-402d-c671-1b29-527f2b5361bf@google.com> <8fc01e1d-11b4-4f92-be43-ea21a06fcef1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F41C318000A
X-Stat-Signature: sgwjfjant63tjxgqzioqruwg4xhfwxyw
X-Rspam-User: 
X-HE-Tag: 1761726726-539913
X-HE-Meta: U2FsdGVkX187y4iQ7AwS0Sb7xpeoOGLhK/Zlft1zyRJ7ynfF7/58F6TwS9/LvqTkK8bOOQ+Ri9ZfoqhnMLUXQ8BQsEkoUCPX4AOF18d8mu0zB8QuWwdVkq2uzSS766pbqejHIm01N+lpKV5PFDoNwsTdLr/E7g8FU0eh2s6lh0uBEUNZjTuvj1ppI28j0TyctiVgZ3Ngkz7dAVFwdX8YLzTSWSgnkUhe5cZaVQiEQk4rOdAdMJJu1jR7D9gghb3f8rAp21yttQTtG94XKFU4LyxsiKhk+KYl+ebjbjYuWOEltHwx1nQiUlAAV5KWs3uLPb078S12cOFnfEIXWX/CPYoSQA4j37vmXZOGIbUoJ6sgFQR0Vfv9JYr3SPnBuOdVdPalw72THWKAwNP7TrXlhrqMDxW3Iwgx5pR+Ko4sAcWnTXMSrVABoMdJNsQiiWPHmY3yn76TNucXNItrk9erOydljpGDEfoVFLT6ygQCNNrKZgV5u7LsngP1IgnHAcGwQev9ZzK/SLKGRW8ZyfDJGtlG3IfGNsJJYTRUJUo+07rBG5fClQ9bRzUEyyVTK8dOa8V8frdkU9ipIV+ljyWPPy7dxTUp0sL1NVg1YgKzqetaehHyCtrXXljMe26e967euQ2Wdd4vipKs9qCpYE3rofPkse+6SbbcskKQXpyAJmZH5h9p/Z6SxVH5XGp6YP7rExXIklEi5ujGqzli9kUPdTwFUtoxvHge0iYVg5uGbnnymep7QUgw4kCz1UYqgj6QLVtWgh+ljhf/jdkzPm4iGDJv6X4AzZbufMXj4VzJqpS3JsKgzBHp9tN23bSz1JHlYhuthZov9ni3hOEZNtA9A/A5UMU+8IfHLggiWDCTzOhP5KgvDbDjSdIvkaHty7wSM94egtGFpU4GDoR/A653Z5EyVMC4Hwu5lJ92oMiXYheHdbFERpbDb1A7t0LmyV58iguQAHICctkPRPbbQGw
 YwsUxKJW
 TdqODMfClqEEZVbqRcdDR1pjHt+ZaCmdcTVVKxIbagmvFZo0SMvpVaapCHWKiy4slzCZ9NMd93BXjfF+OT6UvuoVjQsxrN3ZznjfuhK2u6XG8YKKr9APTlaWxoDkobWFRpESZfeK8G6jSW/NOB72/ucuIBkLO+dX6MuRgRXY9AOpxpHwld5FWwj7v/np27S7cyqmjiYRx4GHJaLtkz6PuE4TP5YbAzZN0zxhDmI+mg5zNrC/KLIYP4+Sy5xERbf028IudyV6hRife6cL2bOciGHDAgwfHew01ExpbZ8DQUOxGvBCYU7cmfg2OjhXmpW2DdU0WPeeJcQM2uQ5DTApAGf3uGXTrqfItxar5fB+0IQXDsZ+2xwpvPc8PDYigmkRh/NoCML5Wzh68ZPesWAocUMQusQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Oct 2025, David Hildenbrand wrote:
...
> 
> Just so we are on the same page: this is not about which folio sizes we
> allocate (like what Baolin fixed) but what/how much to map.
> 
> I guess this patch here would imply the following changes
> 
> 1) A file with a size that is not PMD aligned will have the last (unaligned
> part) not mapped by PMDs.
> 
> 2) Once growing a file, the previously-last-part would not be mapped by PMDs.

Yes, the v2 patch was so, and the v3 patch fixes it.

khugepaged might have fixed it up later on, I suppose.

Hmm, does hpage_collapse_scan_file() or collapse_pte_mapped_thp()
want a modification, to prevent reinserting a PMD after a failed
non-shmem truncation folio_split?  And collapse_file() after a
successful non-shmem truncation folio_split?

Conversely, shouldn't MADV_COLLAPSE be happy to give you a PMD
if the map size permits, even when spanning EOF?

> 
> Of course, we would have only mapped the last part of the file by PMDs if the
> VMA would have been large enough in the first place. I'm curious, is that
> something that is commonly done by applications with shmem files (map beyond
> eof)?

Setting aside the very common case of mapping a fraction of PAGE_SIZE
beyond EOF...

I do not know whether it's common to map a >= PAGE_SIZE fraction of
HPAGE_PMD_SIZE beyond EOF, but it has often been sensible to do so.
For example, imagine (using x86_64 numbers) a 4MiB map of a 3MiB
file on huge tmpfs, requiring two TLB entries for the whole file.

Hugh

