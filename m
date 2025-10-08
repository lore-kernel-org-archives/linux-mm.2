Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4EDBCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 18:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4758E000C; Wed,  8 Oct 2025 14:06:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174DA8E0002; Wed,  8 Oct 2025 14:06:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064458E000C; Wed,  8 Oct 2025 14:06:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E56678E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:06:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8193287FB1
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 18:06:15 +0000 (UTC)
X-FDA: 83975726310.28.BFD3258
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf21.hostedemail.com (Postfix) with ESMTP id 96EEA1C0006
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 18:06:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=1tmZCK1x;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759946774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16JmNkh/L9J4E7GX4fUjY6xQHv/dDmWkutKst5l0AuI=;
	b=ecdjv1YCikindt94VpRvakke27V7S5PVRLkjmNtMxDcqpePz+Opwr/dpcivVJwibKoX0ed
	pBUqYTZiN7R1QIOHpu1WFm7NnktSMqgMLp2zfdfBiVsgRYIawbH94vraL117AM6wN+KzTH
	5zi9BAb6nSKBU2jXBhj/Z5pCkXKcgC0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=1tmZCK1x;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759946774; a=rsa-sha256;
	cv=none;
	b=bLC/CRxVu3kwftBlGbeuyi7Kmy5agzG0VP3cZxOMlWJz4ADqZmGlNekC/YIDNzHMX2Jisp
	6/ENMCZ3U0t9Q2JwcP1F4hEfylSyUnp2y1X1D/uM3wJqVeI/m8SUQyKBmKi8R20k6wi7ED
	u1ikPQeshnu3nCnKyoAuWvEZ5Yo81EE=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 9E6F29305A;
	Wed, 08 Oct 2025 18:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1759946771;
	bh=16JmNkh/L9J4E7GX4fUjY6xQHv/dDmWkutKst5l0AuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=1tmZCK1xDLJY1mwyn5+k+gXAM/CsAd+zcMYGvjqdJ4HUf9aOb/PgympVIgtUtxGut
	 ObW3bpDePslTWcJRn49K67MSfNylKstPsmlPZjy6W3wxa9gat59jREPBBMIo3M6JFg
	 XtZGrjt65SQ/0jW/Ua0H25O4Vfwkw5222rJqKzlY=
Date: Wed, 8 Oct 2025 18:06:07 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	hughd@google.com, yangge1116@126.com, david@redhat.com
Subject: Re: [PATCH v2] mm: skip folio_activate() for mlocked folios
Message-ID: <aOaoD0HQk7YPeLkE@shell.ilvokhin.com>
References: <aOPDRmk2Zd20qxfk@shell.ilvokhin.com>
 <ltvv3v4vibvlglpch6urayotenavpzxc7klbcyowjb4wrv3e7z@pzovtvtbmnsp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ltvv3v4vibvlglpch6urayotenavpzxc7klbcyowjb4wrv3e7z@pzovtvtbmnsp>
X-Rspam-User: 
X-Rspamd-Queue-Id: 96EEA1C0006
X-Rspamd-Server: rspam03
X-Stat-Signature: im4kk4fc4bspogy4yudhtb3dc6otadsw
X-HE-Tag: 1759946773-449446
X-HE-Meta: U2FsdGVkX1/s/H49EWlCVzsUAgnJn2pmno2E8IhkhWG0dlclf6KM3SvJlZqNQsgVRc/wMk0fR7ybkYBuQPk4M3MDFv5oyvdjN4KL6lsFvKijYSb6/Ke4fAB0ra/mDoDaaaF3/9e4/ZlJTylJSlOi1ViZufuFdoN1hUWIJPDgFMcLG0HU3HqbbjM9bihBKv4UH4Yc+Zxwqbuy7Y9G3NyqLlFUhPKSmWL3R0pRzCRdRwR03Je6HvolmQHA1Tof+KO1vZkpZcC1cb6+1w1/yu1IGVmwkQZIJObpiOW3F3vglAEEZ9m3Q3wbJipxJ2gaCH2wzbuU5QSfFZ0RyxUi3tCOhx12CjZulOUnLQcPFIiWwqnXS41ctr4y/pO16finyTwzQPCsdN/CX0lTOgB3IJy1qX5NpjpKU/srT8Mz4LePdGzh/I2FhY2lnHRpeFcah2AIVWakqQnqwCMP1PS+JmvNgDtW0DTXtSVO4jJ3qHY/27WvFjQq5kUODsey+mQ3U7ewkyStEuYWdQjq0F4cuzNu7PyFOvfMJVvs0CEMMrQmGdiIPPqh/YJ+F9324eH0rjTA1Tk/5bUqj/hi2H2MnHlGbLfRq3L7EDkWi/4PJCA5HVFh5rNz2HJYA6HBdM0gX4zpPFdjebVJImjqupY1kNMEPF4RmON4KMV9kLVMhkpeuYns9FHdqgQF8HwRQPIqjC2QWaZODqBHQ4SrUSYCGGedBBt6nJ21g7nHoNiOXkbbjQoATrcjDVFMkNzzjHqUnV6bFJRjuhkXTPDOcZcOyR+aLyuQfhUcbIwg7/ekjSc9bOx4096PlN6egz0ntCJEjsQQblQJVNNVNnf6HzmbhvTvMOUDadMxGVRohfVcyFdHSkdLszKZp8aPmP6PTDgV9L3nAe/Br9+kv0X8P7TS4QBQ6LdJcCDx+uvPxZB9s4m2nFdscFbrCIYgG/Siy8OO8eOKWxmJlVNE9FehcbwhHSe
 qbAgY2kz
 P9e9kQAbsH+sta2ulBMt68l/Rq4YgnoMDumvkgElvDU+S6KbgqWWXccEbDkZwVTjAWF+37tAbtMDX/THeCtLuFrsTZ3pSR6cvRdNx7ns0SPJbwn2kdJoY5Jr5eo/C4hptlNEa8gm6vphaF52wb2JxlFm0vYqg4FSY5P1pan8UDeeZAJjNWKbGXQG16gHHnsna0yW0Cri7Xeau/cP8NI9v9GUZ4bV8xBUAQ7InDloHG0aOWTpza/u9I2pxLMTyHIUVxev1UPiaLEYHURo/YNW/hidlFYng20ZOwgXBsL7ZprVHNzNyffGCRbMpADexaJg6PeKBKf3ftW2/nBzFM84mGqZbVw3lpFX3iPNDCapYFvySGKqLwqYZxkimCzzLMCZ4jzZvdg3f3/seGj+vDuEl1pE+prb+SzuW/bRTJH/dNugWGYqpwltzW/l/xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 09:17:49AM -0700, Shakeel Butt wrote:
> [Somehow I messed up the subject, so resending]
> 
> Cc Hugh, yangge, David
> 
> On Mon, Oct 06, 2025 at 01:25:26PM +0000, Dmitry Ilvokhin wrote:
> > __mlock_folio() does not move folio to unevicable LRU, when
> > folio_activate() removes folio from LRU.
> > 
> > To prevent this case also check for folio_test_mlocked() in
> > folio_mark_accessed(). If folio is not yet marked as unevictable, but
> > already marked as mlocked, then skip folio_activate() call to allow
> > __mlock_folio() to make all necessary updates. It should be safe to skip
> > folio_activate() here, because mlocked folio should end up in
> > unevictable LRU eventually anyway.
> > 
> > To observe the problem mmap() and mlock() big file and check Unevictable
> > and Mlocked values from /proc/meminfo. On freshly booted system without
> > any other mlocked memory we expect them to match or be quite close.
> > 
> > See below for more detailed reproduction steps. Source code of stat.c is
> > available at [1].
> > 
> >   $ head -c 8G < /dev/urandom > /tmp/random.bin
> > 
> >   $ cc -pedantic -Wall -std=c99 stat.c -O3 -o /tmp/stat
> >   $ /tmp/stat
> >   Unevictable:     8389668 kB
> >   Mlocked:         8389700 kB
> > 
> >   Need to run binary twice. Problem does not reproduce on the first run,
> >   but always reproduces on the second run.
> > 
> >   $ /tmp/stat
> >   Unevictable:     5374676 kB
> >   Mlocked:         8389332 kB
> > 
> > [1]: https://gist.github.com/ilvokhin/e50c3d2ff5d9f70dcbb378c6695386dd
> > 
> > Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > Acked-by: Usama Arif <usamaarif642@gmail.com>
> > ---
> > Changes in v2:
> >   - Rephrase commit message: frame it in terms of unevicable LRU, not stat
> >     accounting.
> > 
> >  mm/swap.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 2260dcd2775e..f682f070160b 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -469,6 +469,16 @@ void folio_mark_accessed(struct folio *folio)
> >  		 * this list is never rotated or maintained, so marking an
> >  		 * unevictable page accessed has no effect.
> >  		 */
> > +	} else if (folio_test_mlocked(folio)) {
> > +		/*
> > +		 * Pages that are mlocked, but not yet on unevictable LRU.
> > +		 * They might be still in mlock_fbatch waiting to be processed
> > +		 * and activating it here might interfere with
> > +		 * mlock_folio_batch(). __mlock_folio() will fail
> > +		 * folio_test_clear_lru() check and give up. It happens because
> > +		 * __folio_batch_add_and_move() clears LRU flag, when adding
> > +		 * folio to activate batch.
> > +		 */
> 
> This makes sense as activating an mlocked folio should be a noop but I
> am wondering why we are seeing this now. By this, I mean mlock()ed
> memory being delayed to get to unevictable LRU. Also I remember Hugh
> recently [1] removed the difference betwen mlock percpu cache and other
> percpu caches of clearing LRU bit on entry. Does you repro work even
> with Hugh's changes or without it?
>

Thanks Shakeel for mentioning Hugh's patch, I was not aware of it.
Indeed, I could not reproduce problem on top of Hugh's patch anymore,
which totally make sense, because folio_test_clear_lru() is gone from
__folio_batch_add_and_move().

Now I wonder does folio_test_mlocked() check still make sense in the
current codebase?

> [1] https://lore.kernel.org/all/05905d7b-ed14-68b1-79d8-bdec30367eba@google.com/

