Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60F6DC88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 23:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECA9A6B00D9; Sat, 12 Sep 2026 19:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7CED6B00DA; Sat, 12 Sep 2026 19:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6B116B00DB; Sat, 12 Sep 2026 19:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6CFF6B00D9
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:46:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9154FA054E
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 23:46:42 +0000 (UTC)
X-FDA: 85206747444.08.6D6453A
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id D6351C0006
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 23:46:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q5YrKG5M;
	spf=pass (imf22.hostedemail.com: domain of hughd@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789256799;
	b=Cxzc8OM2x3Nw8x9lvygD1lMb1bXnUSFcH8llaQo3Td74zAgt5kPq82fCnS92hBJ0PNJs1n
	q0zffDvJa09QsuN9oWYGng/h70RPUWq23SOD5Alz0J1Moa06MocOvqc5HPm83fMferJu9/
	O5G0cn997f1MqRXL24AoC7OCBsfOo3E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q5YrKG5M;
	spf=pass (imf22.hostedemail.com: domain of hughd@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789256799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pVsvS8oPhpD7RsA/j/bC9uAynbPr4/hmIZdqzmX+oJs=;
	b=nHa3oVoVVrQ2zbdCosBrTTcsDMSn8ozLSclpelsrC27JugJ30K0D7oFXeYacI8L1mYlLqa
	H4sv0xX94bpOWliBPFw040Dfv+clYFVTvl5Tneo/bnuFTyc2aCkDdmTVnifCXQm+Nr2VFe
	C/5F+TSbEtZmw9XeiVdcMZVRzObleiM=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49e717c9841so3917035e9.0
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789256798; x=1789861598; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pVsvS8oPhpD7RsA/j/bC9uAynbPr4/hmIZdqzmX+oJs=;
        b=Q5YrKG5MWm4K9Tx10Wgjo32vIbVzuGd0G1+osB4LSmzjsdLSxqgm/42N0egpFWylWA
         uIuyqFHkD3vodyIymnWHXdUAqnacjRnB8qocLGkKITENS6AplUF3Mo1xsXrAg6SrE5KA
         nYnYLJPkN2qoBwwLGB/i3GY/ubNMIBqs+ff/3tB/A+4j+z38yMxQi49VzCp6ONiGWgDr
         ec+A/Rd/Ao2hbkHWOP+q0yPrM8e8tVA02CaaQoyI6sgXBbZ9z2f7PreNOlVtWaqxbO2W
         syuyWmDuAgQ/Z5iJZLpU78/rkRUYtCLxl8SRG0k4i/cxpqPG5vzWKls1A0dI88bT1ekT
         OClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789256798; x=1789861598;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pVsvS8oPhpD7RsA/j/bC9uAynbPr4/hmIZdqzmX+oJs=;
        b=lVFxi4rLO0qH3xgRTO+xWm2lBZuWvsb28I/sFzkf7+YzIX55xnW//+gkNjwnNc4gmq
         uQXhS/WhWuSWoNJcYMGCNc03kn4MR4IyhliaiD07eJifvYG3+WDgVeNEPlfTZzZDVh8R
         O9X0L3u3R/iacjrzzbqZmb4YKRd21E1cGKXAo/JQUuaKRcIGN2Rjs9rj7o8FHYNl86om
         /up3dYniSp57WCJKIeBk43BXRMGXaQPDmQ+eWvSjNqZ6ZTP6x96kPHu9VckozXl0OCNU
         j/rL3uPtdxPswIjeP8ok0VS2f6E4l2kYlCprRbPuP7CSSJxNemxZo4oWZlm5wqrxgBdc
         Cqiw==
X-Forwarded-Encrypted: i=1; AKwUvByebZ6avDKe69t7DALOaa/bowr6AoM7DvAYf3S0lFYIEuY7jC7TiGcC9rtOA0XXo/7gO+4T37A7jA==@kvack.org
X-Gm-Message-State: AFuF++ljUy7z7evvulcZTliGEPERFd1gjliO6urNoofNuL2mP+5Kmr/6
	YApyG7qGtlS7h4k4PIu42Ekj4M+tKPHF24GNgUIexXweGW8BVl6J1bqZoNdIusksgw==
X-Gm-Gg: AYBFou2gkdS6y/Pg5JTAYSHA7SRzWwUnVifJ87SeF3y2Z4/UpF+c5pCW2RSik1HxA7j
	HbFcycM1COUNkz+HQHXIhYbrRTkygoIXZAeBj/L/SrqgcoHPj319tLvDbX9/fAJZeMjmXMTszAC
	xyzS3Wa446gw1yn8QHW5kmEoXkoNmNuTWNWY9nhgDwWFgtYZJz2vOOLk3IJW9B6He4Uqvqm+aoG
	fxHR6Wg3+txFlYY4xH7IuOAqCvke0rJoXfN/vTlKEKWdx91UeJC/HaHeMxjGlQGeyW3FBHMTAcC
	DQSfbqxF5fHpq59U8XeeBCHLQG9wfwRriaCUIYZVV03IJJ4rhaiCed5EF/FQD0LGEAcAH8Vd+CB
	RpjSqLVFSM6rtw0hx7HwltjZLGO9IXZI+h8Rqa+grnaVk5jKZ3COy6vlWVRPmPp21DzPobFCXEL
	5zhDdYZOLwL2ZzVFgK5u787+pHY9LCKjeGOUgR5cVRVssFRekQmiZeK/LgG3QDTX63QAfz9rq6O
	JRJho+DLdd7XkV0j1g7
X-Received: by 2002:a05:600c:3b1f:b0:49c:fc89:59cb with SMTP id 5b1f17b1804b1-49e61983468mr118820705e9.5.1789256798142;
        Sat, 12 Sep 2026 16:46:38 -0700 (PDT)
Received: from darker.lan (104.157.125.91.dyn.plus.net. [91.125.157.104])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e6221ffb0sm139496775e9.3.2026.09.12.16.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 16:46:36 -0700 (PDT)
Date: Sat, 12 Sep 2026 16:46:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 09/26] mm/fbatch: restore mlock+munlock batching,
 without extra ref
In-Reply-To: <ce1e07aa-5600-46c1-b35a-d7df09a84521@kernel.org>
Message-ID: <96fa2371-8a9e-8fcb-08f0-2977320bbbe8@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com> <69ba633c-8fd5-1f4b-2e1e-b9b15b8946be@google.com> <ce1e07aa-5600-46c1-b35a-d7df09a84521@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D6351C0006
X-Stat-Signature: 5dgiacpjn7mam481nhoirmruru54q8h8
X-Rspam-User: 
X-HE-Tag: 1789256799-64265
X-HE-Meta: U2FsdGVkX18Cd/qBFCAg92VmYXBaMa14XFcJD89kkVftOXiPH3PO9f12rk07+QuSYYaH78sHGH3DboGH44TaF+eTLa0mSnuC8Iud1UQFTKpO62IpGQm+78+7DMKis0yDqhUWDNpj2DZIiQlG6SVG1DxIoV5hsZOUDy3Kw7PEixP/NU3FCxsXuVXHe2ejGXPYB7hUFf8NcXfoGKgUba2lqi2QbGHm6rK8W75Ms6F0/CoKk2VUM26GCpKNLpFGn7sRhAyV96kn1GfLCANjTW09stYl5GrDnxGwUNvV2AYVz0q3tNCFJOWiZwHJzUksbCXGrnSa3FkttEQiCV+x58eDQBAKZi4WyJW1v05s36KG4lskQ4ncBREkyXbMLqfDgDiNn9UwCzSLJMUb3u7ON1EV/cCJp2vVRr7nsh1YkFZkfc6Pll/9MdG0Yn9zjas4+4Dysl//wEPewGFI2YL8GaiKG+p+E5ShMgde4c1b7Ge1SFdqH77Vpz8BAqW4ncL4hlruYbeg0RXCxN0AWfhqmNYE7pRAd9AZ3pZvuZLc1R7yFk1dFxtGF3yNCLSyY0BZ9AKM7O/6k6gbwiPur6DfQzwACUBkjl4F1TviLvtMwrVJTXN17zxMSsKjO924VRY9eips26+Oa0dOGspjJi4pgnXR4qO5GMxREIwxBsh9KSldFVeeb+eo+GsuPMM/VH8h91j0X7qQIh3WqRcTHV3U6THh0rpusmmzhBuuPf+ICqD/aPaOgmzZSeXACfzyZ9dpkx1IrKVZtZDP4OntgV7NuB46kuYTQTIExQICbV+cmmeouDATZYCn+ardmTGrZLJT6BdAJrdyn8VDv1l5sO/BErqWIbKDup2yoblfbsF2d7AYSa4GUCPH/WbYe/vCzKTDGJRaY87TH91dXNdT0U1Syb79MfKrJ8K0V/grgEBDAvOk8TCR5aNWzBoIzEg5o1sPbAJrX1grvuZw7kDOCDYabyL
 IgY3Pu5v
 8vyu3mzQBAQx5q0Z+i+nNrUqlGfbiCg9q00qY6dHBQqDgNixqhIGlBstmImWeNDMLiXOyYHZFwNXnDNN/4QLhipatBC/t00FIJIlWGn0J9XCiOGMNTDrpJk+8OtUY+GLeYF0CBKl6Q+VZDZ/lP+xMi4ooRsK1BIKnAIk6ousqfLklRLIGDOEiZLW1cy2WLQyuseZzuDpUhBEEuNAL5tFYasSyQFAjMtwAHzoUEWe2XxqAjJvAAKixbRta8lHCoqsiS4kNtoqBB1rFwW8ws2Va1SahDCrNsnHp/3707Of9fJp5Y9K04CuVjgrvJUIobSr15whQrLnCniBYJ8ZDq3EErLIIYrhpJrSi4xcymFoYuHIvqAbOoKHgtleGtMgdr1YKMzAFEWm5cV49m2eMmD1oLf+MrGp/SrsbGGo8S57tMok3XXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026, Vlastimil Babka (SUSE) wrote:
> On 9/9/26 11:59, Hugh Dickins wrote:
> > Update mlock_folio(), munlock_folio() and their fbatch callouts and
> > helpers, to do folio_try_get()s at batch processing time, instead of
> > holding a folio reference all the while in mlock_fbatch: as in folio.c.
> > 
> > But more interesting is the use of mod_mlock_count(), using try_cmpxchg()
> > to update folio->mlock_count safely when possible (now when on lru_add
> > fbatch as well as when unevictable). While __mlock_folio() is as hard to
> > think about as before, __munlock_folio() simpler because munlock_folio()
> > can adjust mlock_count itself without clear_lru() or lruvec lock, and so
> > do the folio_test_clear_mlocked() immediately for itself (without which
> > unevictable_pgs_cleared was likely to appear high, when it should be 0
> > or low to indicate good mlock health).
> > 
> > __munlock_folio() is safe for use even when the unreferenced folio has
> > been freed and reused. It appears that __mlock_folio() could affect a
> > folio which has been freed and reused, but only if it is reused as an
> > mlocked folio, in which case its mlock_count is spuriously incremented
> > (but usually a spurious munlock decrement will follow).  How grave is
> > this? If unevictable_pgs_cleared remains low, not so bad.
> > 
> > I've gone back and forth on whether to move mlock_fbatch and these
> > functions into mm/folio.c: for now they stay here in mm/mlock.c.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > ---
> >  mm/mlock.c | 147 +++++++++++++++++++++++++++++++----------------------
> >  1 file changed, 86 insertions(+), 61 deletions(-)
> > 
> > diff --git a/mm/mlock.c b/mm/mlock.c
> > index 2c690f18031e..1050010bbe0b 100644
> > --- a/mm/mlock.c
> > +++ b/mm/mlock.c
> > @@ -58,6 +58,20 @@ EXPORT_SYMBOL(can_do_mlock);
> >   * indicate the unevictable state.
> >   */
> >  
> > +static long mod_mlock_count(struct folio *folio, long incdec)
> > +{
> > +	long mlock_count = READ_ONCE(folio->mlock_count);
> > +
> > +	while (mlock_count & MLOCK_COUNT_0) {
> > +		if (mlock_count + incdec < MLOCK_COUNT_0)
> > +			return MLOCK_COUNT_0;
> > +		if (try_cmpxchg(&folio->mlock_count, &mlock_count,
> > +				mlock_count + incdec))
> > +			return mlock_count + incdec;
> > +	}
> 
> This never rereads folio->mlock_count to mlock_count inside the loop, so it
> can spin forever?

You give me a nasty moment, have I misunderstood? Isn't it part of the
try_cmpxchg() contract, that it reads folio->mlock_count into mlock_count
when it fails? Hence the "&mlock_count" rather than just "mlock_count"?

> 
> (too late here for me to understand the rest today)

But that I understand very weil: thanks for all that you have managed.

Hugh

