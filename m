Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E103CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C748D8E008B; Wed, 29 Oct 2025 11:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C808E0045; Wed, 29 Oct 2025 11:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B896D8E008B; Wed, 29 Oct 2025 11:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A91F98E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:30:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59D9912B1E1
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:30:42 +0000 (UTC)
X-FDA: 84051539124.01.BF03E5A
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 81F791A0013
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:30:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JQSPcrDv;
	spf=pass (imf19.hostedemail.com: domain of elver@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761751840; a=rsa-sha256;
	cv=none;
	b=MqZG7tE0wYU1vGGkT1VOMm31qU/0pHmkm1R1teKcx2gBH5XmFB+0mrBaKqknJAhjMv32Ni
	Hn61ANZEQZDby+U0Lt7ZwdfTvkEp9UsXTT9H2zGATkJyEjQMurnM2x1BTs9xWuc3C/fYjq
	WAWDb+eqLtw+ZUjpsYU000vV7HYDF7w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JQSPcrDv;
	spf=pass (imf19.hostedemail.com: domain of elver@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761751840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/Chhgm7KMivLaP7UfXKsNLQx2xR5ZnzWFQSYqKYSi8=;
	b=bQ7jqsxK19H1Zq1MUjltNGV8LH/1gBC7WwnxziJuRlHXyvdnOpiSbexHsxZqd9IjdiPoBp
	YeHHilGdV0jqkTHpyDH7ZF1wiFaHR0AmngHjPQvPcITp6WHyAjY+f+ek4+fiTWvK43bRvw
	LKvkb9p3OJ5ws7ZH5jKCo9CZ5hnfKnI=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b6cea3f34ebso5247781a12.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761751839; x=1762356639; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a/Chhgm7KMivLaP7UfXKsNLQx2xR5ZnzWFQSYqKYSi8=;
        b=JQSPcrDvLPIC0RzSawGC+e0XM34HM4MT1hTTIdHyZcp7fX3THjbk4cx7/eKz3ZE1Nx
         jIagh2XaNYVWCbvsoJU3nfbG4R6tyo+Kakdht4avo/vYjZtXzXNSNqA34lOEzuEqpePT
         Im9P+xvc8m3dDayJMwYa0by+bICZTLWJSO0gTy7sc2WSKbNHjq2hEexhaLJjMzdvrN3F
         LaqS5sHN+QInEMbk8bnI/EHdXTI9OYdtAudaB73qqFChHKJ8DznWLy0jbRDtHXdkG0Nw
         I6zxsii/WaYeQzjL5cPmdLeF6Px9+xhkke0KqQYs+fZA8MomL15OOb0Q5TvnTJQTPXj9
         fsQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761751839; x=1762356639;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a/Chhgm7KMivLaP7UfXKsNLQx2xR5ZnzWFQSYqKYSi8=;
        b=wjf/Se41tRWz3NTqTVBNTt+dg3csECkfgMy+2g7ur0q3rZuhQJltYMJGGAHSZk065+
         x3gsCnh1g5tyvnQsR63h8Eh3b4z/a0x4u5QHF+crrkmyRTLB+53NyhjTZti6JZWgFZW9
         HoADXEOIrbXycO3YbP8US/lqo2x0EAvbiOIucTUHNjX6w13vTTJ30CNYJhBDn71Ny2j/
         ENl/FcImPhjdAc40KQQKmS5/O7e5+IvJ/zGIw0OPFA9l9TDp8E4Msni2WYrVNYUaSm0D
         dghTJUOpGf58hks5IGR7ZBbl/zr9/jbx39fiHAh2YVTbVw0vrx2BxL3CWtJ0Mw/QEO4p
         LhhA==
X-Forwarded-Encrypted: i=1; AJvYcCUdv0oaJ2w2i7+lnR751zgCtd9BtolcSYWqUo6XfeRuurqecnyJk06dd53T5DfEmhqVTTDIj4JbAw==@kvack.org
X-Gm-Message-State: AOJu0YwuyrDjZuGwG/2+ARLxHdI3QU+c6F53PbQ5790eGX6JQmKs7B+f
	eQr4/DelOHGAqnYtSRbwv6ZpWJV8p1wLRXvbgFWmHNa8fDT865srQzymGZheoofYLnOl+ILXiTT
	RikVmSgaWKxHgB1m4PK/G/UILdhcDXBDb+NiHicZT
X-Gm-Gg: ASbGncv3/dkr78j8Fi25T1vUUEbRxUBF5Bx4PQ7zY3vkMiGPsxe0tBKrwP2pksnW1jN
	KvxO4LB9kmCqCpCkhucgxyet8qwQuceD5d0hEDFgdv6eiyY5rxnXesTf3piTrJhsohCISrO+lbI
	jolX65AA+0W9iv7YG5y7IggqMnXk/E3hZhvgxNALi2HUjO1OhAX28sx9b0ONnof4wwG82rbCrYl
	uz1chnTRj2Aqy6aTWJyRFPv5BGzgBBqqQsRTJWLc4Ua54eHJ538hEbhTIl5uiRcfObq+d+SvUef
	loHZWRLV0TbQhJrY+E54KUcr5w==
X-Google-Smtp-Source: AGHT+IH8xvowD+kYXQ7z5quxP2h2xDBqXwlebiin7tKEs9t726w7tT592s456fkeCdpk2YUZnOu4Up+XSy1ZFsm9bRU=
X-Received: by 2002:a17:902:d4ce:b0:28c:2db3:b9ab with SMTP id
 d9443c01a7336-294dee25ef7mr46936785ad.26.1761751838802; Wed, 29 Oct 2025
 08:30:38 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-1-6ffa2c9941c0@suse.cz> <CANpmjNM06dVYKrraAb-XfF02u8+Jnh-rA5rhCEws4XLqVxdfWg@mail.gmail.com>
 <0f630d2a-3057-49f7-a505-f16866e1ed08@suse.cz>
In-Reply-To: <0f630d2a-3057-49f7-a505-f16866e1ed08@suse.cz>
From: Marco Elver <elver@google.com>
Date: Wed, 29 Oct 2025 16:30:01 +0100
X-Gm-Features: AWmQ_bkcozjdjluUvttU4Roh8Mm8XDdSh0qCy1zW1YFReOaqG1YdYoXpHqK6R8Y
Message-ID: <CANpmjNOtocYUyX4HEB9GELeDVb1LbgESea98+UH5LCuYVoZbCw@mail.gmail.com>
Subject: Re: [PATCH RFC 01/19] slab: move kfence_alloc() out of internal bulk alloc
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: o1za8nt3ny6ypkp4tnfdz59m6xrxa97h
X-Rspamd-Queue-Id: 81F791A0013
X-Rspamd-Server: rspam09
X-HE-Tag: 1761751840-799579
X-HE-Meta: U2FsdGVkX1/eNWYoDMbAO/1EWf5gtifuHP0vsERTP4HQJup4cQx1zK+pHMfqH/d0QFg0LP9gD80OnZ3mw1bwQAEPtoMex8vj+W9jrysJ3L6JH0H+PaV2sdT4Gev9ur74VX8y6MtgHkuCyTtF74l5N8VLmDqF3Cd0qP6ESbGvvAFvpJJohsb6z+fPCzEHciZ/xGf8R+35YJ9RrJ6Aq9MLUsP0F4pfCBZK2eWz1ZGywOtroVzmeQjNo4LrsGQsiazavl58q2g5KMvjMtE6KqOU4jNNqtWFjzwhsFjLuvTcwal3siD351nWZQtoU6QpXssb2Ycr9XBPnTIG0r019qy2pqdvlYQRs4NZl/Gh8blDgnVCo+vIYazAO/sNzGwZ01Rk6w2SfZSrL/GdI8lmLvIQpK4QxqR+5yANhd84J1kmkwkl91tESWMypCRI8KreJl3l5vTdE9Jg2Oq/XISG2FpYwmHfT7oh29UJCMdSZcWIwUSGz3v+xf9dUzjWUwJbXZsYl3+YQRJNliFzbRXKXIbKQHisg9COhNlPolksLteW1BTiqmsf0hyLd1Ul57FPipI2ddWyDi8YTMNevlGaSsKvS+yuq1ZDhgNwr0rwXB9K+5l3gJHsbJD0vVty62QQZlTAS5HZxOZhvo/gB6s1LY/uhJiijumGJCEC86+oQASaTFx3f0wuqTx7dWrG4ARYg6aPsLuKWkZJQSxHbzqCpmfIzwRiyyzTxkTYzO7SJxmfu3ZKQiOPL8uZV4mPvSN+/S3KAIgV3xI9Y5UcNg4BZeN5xbBqx610hexaNoLsJNXGxMT9DNDxWnjyk45t4XxNK3+wa9oRK0PQ+bd1zbR/f6L/Z9g2IDDhFuS8aq1LcisEDvyMAJl/zPc8FoOuXTImVb3D+NnIEzutPX2BerG+1CgfS1R63s5rL40OsKhBG7kjEZz+ssN+SKp3PMZiPiYpvC8OObNtyMYOkfUHn+4xY0U
 YqSwOwUl
 W+JpaguD1UnEvzMaL9WBvOtmjfD6iDRN6pE73M1KK+sM2EidLXgWpbIJlAh84lvKeFeExWwdRvruc14PGKWEg0CRp0oCWIR8WEKQyNO8kO0nJpRR5YkCoNjswKNE9c/XMjV3T4yOXNE9Ef/wyualtkqJmUXpAQc+umTElDSQecb/x1r9OPnde4huodM4+JtKhakoRD9yD+KoFupKoihoMeLKVIfpu2Y0BNI1PVyQ3NF7KZ7Dqeel6elpUBk5XczFVvM7PoQXgXviFRBc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Oct 2025 at 15:38, Vlastimil Babka <vbabka@suse.cz> wrote:
>
> On 10/23/25 17:20, Marco Elver wrote:
> > On Thu, 23 Oct 2025 at 15:53, Vlastimil Babka <vbabka@suse.cz> wrote:
> >>
> >> SLUB's internal bulk allocation __kmem_cache_alloc_bulk() can currently
> >> allocate some objects from KFENCE, i.e. when refilling a sheaf. It works
> >> but it's conceptually the wrong layer, as KFENCE allocations should only
> >> happen when objects are actually handed out from slab to its users.
> >>
> >> Currently for sheaf-enabled caches, slab_alloc_node() can return KFENCE
> >> object via kfence_alloc(), but also via alloc_from_pcs() when a sheaf
> >> was refilled with KFENCE objects. Continuing like this would also
> >> complicate the upcoming sheaf refill changes.
> >>
> >> Thus remove KFENCE allocation from __kmem_cache_alloc_bulk() and move it
> >> to the places that return slab objects to users. slab_alloc_node() is
> >> already covered (see above). Add kfence_alloc() to
> >> kmem_cache_alloc_from_sheaf() to handle KFENCE allocations from
> >> prefilled sheafs, with a comment that the caller should not expect the
> >> sheaf size to decrease after every allocation because of this
> >> possibility.
> >>
> >> For kmem_cache_alloc_bulk() implement a different strategy to handle
> >> KFENCE upfront and rely on internal batched operations afterwards.
> >> Assume there will be at most once KFENCE allocation per bulk allocation
> >> and then assign its index in the array of objects randomly.
> >>
> >> Cc: Alexander Potapenko <glider@google.com>
> >> Cc: Marco Elver <elver@google.com>
> >> Cc: Dmitry Vyukov <dvyukov@google.com>
> >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >> ---
> >> @@ -7457,6 +7458,20 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
> >>         if (unlikely(!s))
> >>                 return 0;
> >>
> >> +       /*
> >> +        * to make things simpler, only assume at most once kfence allocated
> >> +        * object per bulk allocation and choose its index randomly
> >> +        */
>
> Here's a comment...
>
> >> +       kfence_obj = kfence_alloc(s, s->object_size, flags);
> >> +
> >> +       if (unlikely(kfence_obj)) {
> >> +               if (unlikely(size == 1)) {
> >> +                       p[0] = kfence_obj;
> >> +                       goto out;
> >> +               }
> >> +               size--;
> >> +       }
> >> +
> >>         if (s->cpu_sheaves)
> >>                 i = alloc_from_pcs_bulk(s, size, p);
> >>
> >> @@ -7468,10 +7483,23 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
> >>                 if (unlikely(__kmem_cache_alloc_bulk(s, flags, size - i, p + i) == 0)) {
> >>                         if (i > 0)
> >>                                 __kmem_cache_free_bulk(s, i, p);
> >> +                       if (kfence_obj)
> >> +                               __kfence_free(kfence_obj);
> >>                         return 0;
> >>                 }
> >>         }
> >>
> >> +       if (unlikely(kfence_obj)) {
> >
> > Might be nice to briefly write a comment here in code as well instead
> > of having to dig through the commit logs.
>
> ... is the one above enough? The commit log doesn't have much more on this
> aspect. Or what would you add?

Good enough - thanks.

> > The tests still pass? (CONFIG_KFENCE_KUNIT_TEST=y)
>
> They do.

Great.

Thanks,
-- Marco

