Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B379CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 09:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BC7B8E0049; Wed, 29 Oct 2025 05:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5945D8E0045; Wed, 29 Oct 2025 05:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA808E0049; Wed, 29 Oct 2025 05:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35A498E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 05:46:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F31D5B698
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:45:59 +0000 (UTC)
X-FDA: 84050670438.14.A661382
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id AAEB640005
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:45:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZYWlO6L8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761731157; a=rsa-sha256;
	cv=none;
	b=CSWL04Wt4QH5Ke/5Bdr7plibrmaqP10oisMZHOxmx0nmjCfNl4NC9HxA9O3KFb/lHP63Vh
	ROX5gE7hOOn2rGm4JrjBGO27HkM/d+w5mOK3vFDDchsCrknyJGXcO5gKTk0HbzzwYlKWYL
	HjWpSgVzwMlpJDNdnC4y8/UHt/t7hic=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZYWlO6L8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761731157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/9ZZO0rhubaMghlPDWYbVAhM+q6Jydtc36d3XX5xX8=;
	b=Z8PNhaG8oPz/8GYuYEXT0U/G6FQWG312pZD9oe+mW4M+avQmjfS8T5ngg5YdbAhLFMhS7k
	RPzUxdl5ny8a89iA5yF+n+QZ1Wtg8vLX2yj8zOTptvpPVYYJOJYqLtYbrRxHDF+sR+ug4P
	dRsj6RkiRFngg6VQ0a+ulrPzH7rDxHQ=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-780fe76f457so70725417b3.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761731157; x=1762335957; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7/9ZZO0rhubaMghlPDWYbVAhM+q6Jydtc36d3XX5xX8=;
        b=ZYWlO6L8AEfsPRhJEI2B5n21jsePg0qJ0tKObnv3FLHt0nNT3frGXpNRwiC+Nqx8cs
         auymkD7HVD1EMwFpkSO/mDfPZiek36THplhEdILB7WFr0TYtbwgJVuUF2IbzKWOYPwFG
         t5+Ixe5zBM6cUfi4/kvnEAsaBoe3UH9fYxnrICcm+UDPisvTAXiPF1/wEJUhDbJZKWu5
         0m2/qBPahBVnKPkeyAAJ7eDzeTIxH7R4XB6dW2pf1R4al3UDKQshG4qP9h+YFfV4dPDY
         eT6QrFsBFnycLpB3OaTqYmOL9D/+iniM2AP7PlA/dTcM6PZ0nA4jrswGIRQnAlD7QiSZ
         qhxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761731157; x=1762335957;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7/9ZZO0rhubaMghlPDWYbVAhM+q6Jydtc36d3XX5xX8=;
        b=pYfDz8rPW/yBQyjvGpjc71l8LYme0Vu1eBMXJdcA8KrhlcJPC01xFQjCQPWbGISTdN
         qqOlYjZMaL+Dgl0XKk9A1Nj1wfuk5Kco8YmxEqMbM08KhLWepv/jIh+lraiAq5FPO+vT
         pUV02G8FTn8ejuolGZeloEGFtWsx9LyQntgzQcmQyV1YHMKevWPbBbofLwIwSs9sZkZO
         FQBN0NQN0HaUKJYTgCUV7InG3PosxUGpBav/IckauxGqvd0QRCPzLlbzFb3AHAgm9cho
         MaLW334wXz7EaeFNHEign0nHpg5i1zJa9OJrFbN8HEqpLJgNcqCHkux9U2CXREB4DQXq
         96WA==
X-Forwarded-Encrypted: i=1; AJvYcCWSdOCrOasTsMPaAO4NIS1zGah7vyvlXT4hFyAc6c8SRyGlBR4Ctm6N0hxbLJMKdXCnWR15gbOkGA==@kvack.org
X-Gm-Message-State: AOJu0Yz/ja0qhiN5o0PFKZEaMg+tjvWoHP9K+1pflbem0rFBj2HJJgbE
	hnJV/w7YvWJEj0Q+B508Vdu7hJiL95+b2WxqiBZmJLSSaB48kmomJyHtzl04ve0LVQ==
X-Gm-Gg: ASbGncs1kevE+DlKtRMjLmpEeQhPCscyQP7XlLJWFa+YK4q46cYsSu4BJ4MeUi/n+ds
	f6UTM1YlDZbzNDzASHfRyQnej6AkJEy+2Y/MysXzk/1dTq/B77VV1UoEdOuE6BZ6FmVhefccVhi
	tRm0t2rRTSRj24wKq5kSTHVKntV0ODoCBaOqnR7afLgKJZMQzGGcZt09znqjK5Wr6srg7HQhnle
	jYU9z8vEzB/FFh3KrawI/X4ZbnETu48Dc2zCM5b6BgnI1KU352WcrNdFl0Z80D4nbVM0Vqtr1XW
	7z8egqwEOvwonxVrRn3sSm5jO+BVJ5SZFPpJcIxG7eJNKFs2zUtf2lJVaw5lot/ZX+XPzdb64fd
	AB36XdLBzJ08WtqXcfCFqOjiH2u3ZZWPOOotFuM5rl9GJZRREEPjYnIP7As7k/ddNhxRYkrI4fq
	vPeit0Fx22Ex+D2+DlFBFl7wGLELnyZrMTSSmTTwCQWancYMekQpzvt43DtcjB
X-Google-Smtp-Source: AGHT+IEeP09fuX5a6/tVT4haAmvdF3K7vyTy354JjeQP1tfCemInfRx1yyo5g0HaztI92HwXX6vV3g==
X-Received: by 2002:a05:690c:4a05:b0:783:7081:c479 with SMTP id 00721157ae682-786293b13admr37307107b3.65.1761731156381;
        Wed, 29 Oct 2025 02:45:56 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-785ed199f95sm34481207b3.28.2025.10.29.02.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 02:45:55 -0700 (PDT)
Date: Wed, 29 Oct 2025 02:45:52 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
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
    linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] mm/memory: Do not populate page table entries
 beyond i_size
In-Reply-To: <hw5hjbmt65aefgfz5cqsodpduvlkc6fmlbmwemvoknuehhgml2@orbho2mz52sv>
Message-ID: <9e2750bf-7945-cc71-b9b3-632f03d89a55@google.com>
References: <20251027115636.82382-1-kirill@shutemov.name> <20251027115636.82382-2-kirill@shutemov.name> <20251027153323.5eb2d97a791112f730e74a21@linux-foundation.org> <hw5hjbmt65aefgfz5cqsodpduvlkc6fmlbmwemvoknuehhgml2@orbho2mz52sv>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: pw5dnyrz9u84ddtjnnixhhue1qz3mt41
X-Rspamd-Queue-Id: AAEB640005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761731157-290614
X-HE-Meta: U2FsdGVkX1/8WPGPMu9e1NR9tuFk1VcZXAV9PhqaWASlETwRQKTMhlv0Lt1wE2jxFDLzIkKIMPmB4kIM9Fcrz4UOJzcq99aWgRPR620YtQflmANLRdpybdIycE8Se01Gvi5cpQx1LUr4YYwisP5K2ZPhoN8C0mf3POOlqMM0w2HlmesaqHI34LYMBNpEF8Cju3hAu5Ah1geh56TtbnRUruqbmALGQWai69GYru3wt+YfVEGvPX66T3FRud4R0diKsOLfYGUxVW8dGYOuWTb/nZw7iqregbB55HFEQHxEdLYWvXUTX0nO/7/JxYaRtVpuwCpxw7tuBoOv/r9fH45Sche7QtbJQAklX3m4eiswrDs1YYvexcEGNzo8/Xh/F1E+/qcDfnG30gzJXjIXMcRk2+y8GXRMUKJc1ZSG+18Q3IrVR2eMHYA78vo2tTNMa7eFD4bBAWXKeuEbbAY4KgQe6vz64hfnvNffYFFTh8uEeFUOD01d6uzchHyiW6a04ZXeshImLVtPY5v5VttxvkLsGyPqPUcfunH9Q0OfTAkOREUMOCksfxn4btF5dfgJ0ERkZ0N7yf/+jELQX0geCpvV7tSQvHnK6fxvVjXyMwR5BnoOx73zH0cPf3UMC8kCwitcM2DMObF2DqHNKmkBTqAmkkoeIuGrFu1kg6vfaBo3j9CVEPS0F380tBTghvV0YtGf1SgTaG6wBU7YOoo+2RihLofmi247A3annhp8W0vlOeOrvIA5rzA2uyKrg9jpFFCIEI0xa3VS3ytnhBENarEgaJC++qVP3hfYjUk9pAMg2h3HUVCfMX1NoTSWfIpBRWfQo+T2BIcKkXyjfX95XntpTCfith5KbKN+TTWbgIpBKWSCQLfQs5KqLhJ9r9Nn2GBkv+wHUfLaj+UvF98Xf9GdIgoVimif3XP3lMWv+ndkgYp9yO1kHNE45H3V7ejW5YvKvWid+RwzMN2titmzzFL
 doH0J2CV
 I9e1p9TZcEIF/3JVOhjJKnQHUoSQCd/E9GCj4jkzSwe6RGnI6ZAWIpOzf+GfCnH+yxWF1NNZ6pbdh+Y91iWuKPt9TWZ4Gx8SPVTE3l4hqCpBhuNTeLNurgDECGM3MVifFTpd33joOJo2QsXMLBeKXQEyRhj/aTbI/cYkdkZte4OJ+uKApmm1SZNmTUUZ2euRBpC2+hnI34mfFF6FvgFNtYHO3QAhJuHcK657jHfV5E3+p87WpJXkmM5powzf5AA4mlA55RI4nIM69bVHvK7KkVwaPaYpHdaQMpsxyYA0Y1iiFRH7RHh208siO7UAoXAqO+IviyMaWVDJ8TA9CWsinaXT9499ZQXaOUs5LibdBd5Z7z8lKG+J4qg5DbC1ZwJ1m4zNMnseIyCoLl9YOR+/HDsKCofzbkDx68iVhkxF0QCawSY60Rxc8kaA+Tw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Oct 2025, Kiryl Shutsemau wrote:
> On Mon, Oct 27, 2025 at 03:33:23PM -0700, Andrew Morton wrote:
> > On Mon, 27 Oct 2025 11:56:35 +0000 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> > 
> > > From: Kiryl Shutsemau <kas@kernel.org>
> > > 
> > > Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> > > supposed to generate SIGBUS.
> > > 
> > > Recent changes attempted to fault in full folio where possible. They did
> > > not respect i_size, which led to populating PTEs beyond i_size and
> > > breaking SIGBUS semantics.
> > > 
> > > Darrick reported generic/749 breakage because of this.
> > > 
> > > However, the problem existed before the recent changes. With huge=always
> > > tmpfs, any write to a file leads to PMD-size allocation. Following the
> > > fault-in of the folio will install PMD mapping regardless of i_size.
> > > 
> > > Fix filemap_map_pages() and finish_fault() to not install:
> > >   - PTEs beyond i_size;
> > >   - PMD mappings across i_size;
> > > 
> > > Make an exception for shmem/tmpfs that for long time intentionally
> > > mapped with PMDs across i_size.

Thanks for the v3 patches, which do now suit huge tmpfs.
Not beautiful, but no longer regressing.

> > > 
> > > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > > Fixes: 19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
> > > Fixes: 357b92761d94 ("mm/filemap: map entire large folio faultaround")
> > > Fixes: 01c70267053d ("fs: add a filesystem flag for THPs")
> > 
> > Multiple Fixes: are confusing.
> > 
> > We have two 6.18-rcX targets and one from 2020.  Are we asking people
> > to backport this all the way back to 2020?  If so I'd suggest the
> > removal of the more recent Fixes: targets.
> 
> Okay, fair enough.
> 
> > Also, is [2/2] to be backported?  The changelog makes it sound that way,
> > but no Fixes: was identified?
> 
> Looking at split-on-truncate history, looks like this is the right
> commit to point to:
> 
> Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")

I agree that's the right Fixee for 2/2: the one which introduced
splitting a large folio to non-shmem filesystems in 5.17.

But you're giving yourself too hard a time of backporting with your
5.10 Fixee 01c70267053d for 1/2: the only filesystem which set the
flag then was tmpfs, which you're now excepting.  The flag got
renamed later (in 5.16) and then in 5.17 at last there was another
filesystem to set it.  So, this 1/2 would be

Fixes: 6795801366da ("xfs: Support large folios")

> 
> It moves split logic from shmem-specific to generic truncate.
> 
> As with the first patch, it will not be a trivial backport, but I am
> around to help with this.
> 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

