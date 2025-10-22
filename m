Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAB5FCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360B68E0005; Wed, 22 Oct 2025 04:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311748E0002; Wed, 22 Oct 2025 04:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227748E0005; Wed, 22 Oct 2025 04:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12A5E8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:00:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C57CEBAFBB
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:00:35 +0000 (UTC)
X-FDA: 84025003230.09.3652B1B
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id BF21D80007
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:00:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=hsgzNtAA;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf02.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=david@fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761120033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vi75g88dnn+ezywzRSA2gvfzEVMFz+4qzKUpyRCo3Yc=;
	b=CWuIwg7+N/fL3TYuu3GmsCe2YXbDdg6FHtFHspxokkVsv7VU73qdhIIqVFwpq1bykyIAJx
	0ow8Np0yKhYnZq7ZpL0ko+wvUusqlLi1TG/JLjQ0rdX1MTwhZnt8Sm9D+q1/DmvwJGhuhh
	tnVK5aORGSj8EYxeYGSZq1e+qRnMlOo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761120033; a=rsa-sha256;
	cv=none;
	b=j65gTpib5WJxvh2zZz6pi6ivWzMCYWCwnVs1rBrH5XUK+9dAdistqbYNoCTCIyUuy1YVme
	UAoEKJIUmVClGWBSuIILfS+AAN8Ye40QNaZos+qf2V5YAn3YcoK5YVGDy6qUq48eRTXhaO
	td+KbAAH8dZfiyD+VrU4tAx/4mqAzuU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=hsgzNtAA;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf02.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=david@fromorbit.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-273a0aeed57so8506525ad.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1761120032; x=1761724832; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vi75g88dnn+ezywzRSA2gvfzEVMFz+4qzKUpyRCo3Yc=;
        b=hsgzNtAA1sXojSZn9pY26x5VblQDX4GF2o/l627PCNJpabPbVTfWGcZeENWjYVfUpz
         UzN4YJfVqqZwy7r8FvVG7jCSebF3Wz3u6VaIEBNKZUxHdTASlovnJicuUYW42hfeTOvY
         ZeCkTduNbtbNwD3i3JizOnQjGsDJtRbH4QTb5c9bxLHN1TuWI+yMytQI/eQAbBoDezVf
         QTG9tDkDKkHZT47P5VleMi9AGKVBS5q8S7Eocpq32qd1qGAPmnKr3dDWUyOZuSP4Tut2
         FzXDin+V9jKIHF+2p9XOuW9NMCEsj7UnBXKlOypypyEMVaVbC1v665mAZ7aZulpJHSAS
         izOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761120032; x=1761724832;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vi75g88dnn+ezywzRSA2gvfzEVMFz+4qzKUpyRCo3Yc=;
        b=tFnTnPaGi1tNs9sQdIJTb13XfmCOSUMjHe+PQKpvk656JYRraeruvs6n98Y1hYOlK0
         3YS+g8x1MUEBnu8TJrQsBFnCQVIRQo7C3psiVvAGkSlBFsgly1SI8qgqJQTyWVMEgYwK
         rn4ydFx0GEuFZRpwTUTDC1y1n2ziAuP+gUKfL/vxTOu15IFJ2ea3tgfBKUl1vyO8yloM
         Behlkssg0LaSvq1vqczkXjDhXQgi4BZs/yqKQFmpxU56qFPwDzA4UNR7r1D5K7GQM/g8
         zdaCohb91J4gJw1ZXMU2epiTsAk6DIcpln9HwpSo7hBB/Mwoy0qirXCF8AEz7HIa1xSe
         ejHg==
X-Forwarded-Encrypted: i=1; AJvYcCV5ayonhro71XzETOIPwBaNm317gtYN8I8LhArriNMdMF/0DMGJDdgRIocQIyL5k+cLViQnDgkeBA==@kvack.org
X-Gm-Message-State: AOJu0YwWRLbxHQfZC3vkXpDCWmZFMR83Dh34z++DpWGZuUztaRBaL5Rr
	wRrLG8HilLhnSkGmLbCdNYmbGlxDaxfiVrqXfgZYJXh0snrbD/UmX6bApzHIrr2NaqQ=
X-Gm-Gg: ASbGncu98Kpgyu8XRE+XAJEyDoDCN0ATZ+40L0cfke2poZNQsgChuDigqrbz/lT28Hr
	NffTWL+CTI8mqkLVlVOlgxUjjxt+AYkxS12VgDlZC+m4qgx3LYL7tiDX01iVyXmFdK0R33tY3KG
	LZI59/kJwhNSbsBfgKk0ns7EGFK67gAxbqoXdBSJF77PklpWfEV4vCx9FMbNL6h1bs3PhbBohi6
	721sxlpfBxKVrCDx7h34nUqCiwR2Lg7iQX10cAg3DKfXKECWvOJ2mlWzzWT9qzzhmdLKFgxkzLD
	B8zV1LfjCKisHM2hiFvbTGkFQn9+IlGiA3VbsMFvLxJiX8xrdsElWxwQcBqQQ3YD3FPeguDTbAR
	cd9aDpKVOSMJ5ndXkL5xD4yU6OlvaPkx8PppeBaVTPOvICn3c24gC2xwUUS7GfZlyGH6quxbGFO
	zMPqSpHoFgJEGtSVrlU2rEnXtUYeMYFactWcohfAtEDsEQ5uzzLP5u0VfoTfhFVP7oTAP6m4YQ
X-Google-Smtp-Source: AGHT+IGduvry/wYzrkfuxXUxa8wdplbLIidGYgQBi3n47WTXCWsmsGQK5w2XtRr8wN1GQkSurJM/mw==
X-Received: by 2002:a17:903:245:b0:279:373b:407f with SMTP id d9443c01a7336-2935b50852amr7825425ad.5.1761120032249;
        Wed, 22 Oct 2025 01:00:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471fdee2sm131384155ad.92.2025.10.22.01.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 01:00:30 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vBTlj-00000000Wcc-3XuP;
	Wed, 22 Oct 2025 19:00:27 +1100
Date: Wed, 22 Oct 2025 19:00:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <aPiPG1-VDV7ZV2_F@dread.disaster.area>
References: <20251017141536.577466-1-kirill@shutemov.name>
 <20251019215328.3b529dc78222787226bd4ffe@linux-foundation.org>
 <44ubh4cybuwsb4b6na3m4h3yrjbweiso5pafzgf57a4wgzd235@pgl54elpqgxa>
 <aPgZthYaP7Flda0z@dread.disaster.area>
 <CAHk-=wjaR_v5Gc_SUGkiz39_hiRHb-AEChknoAu9BUrQRSznAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjaR_v5Gc_SUGkiz39_hiRHb-AEChknoAu9BUrQRSznAw@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: iqidc13tj4ifh8rwbn4yg5jidmx4k5ea
X-Rspam-User: 
X-Rspamd-Queue-Id: BF21D80007
X-HE-Tag: 1761120033-509682
X-HE-Meta: U2FsdGVkX1//Z+H0GUJCiz6dU+Rx1QOYsNCV5Z1E9NFjaOugcXSXQo0jR/gRMeEgABcpMiR5dayMAWMVh3kWzz1kr+umU41UfXXKRb605X/G/wyxxI14Kb+ObrGcGU+CpP0tUqX9/ojuLR0iQx9LjdACidbtp36F96ExsKo+ZFyc6sYhALgfrfreaXKUmrdKO9AdYIs+kOSeFBaayQPQbPjjn086a9+JGfzbEC5lqt0DmmGeyrQCbEZA3fboCISTZQQxP6p4YHXAUdNZO/pCl8VmZhz9pWLhDIDANqBKmxWcmHA8GW0JPiJbETgjoZUWH3uRD8U9m/Ng5crXQnAr7Tc0HqciAtt1ZEE8H0S88uW+ZcH0uahuHBQZ1QCt/mkzPOtY+XUerrGpsFYvWjuo3Gtog/s8s0z0Fh1Xql14M2m6UVTqNRDYXxotNqXJoawwrX2dM+dcJYcmHRRHMbV+ULcen8pj9QY1Oga7gPTk8mbd1evP2fWVaAjdQeM9q+0jOuAQc0RTfaF3l3+lS6iPlinfw07DMvMNSRYnfpdwvW6E6BD2BOUCdAz0V+LfUZChrq9EpWaf/wAdKFypeUQaB1MzJWevs6hgLhUBjaPNeBfe7jveAuYOZs84qa1Z1rOHzYkfTO8BY8vm8SAXkAgjQrPlLGEDHktxX7NyiP6H44k27kNsmp/KdjgzTpKdVWsFecu00wwaGjfE9CKydEWyWLKwspWuucvqGtsdSzHPqV9LIosbQqndhtDf5DJ/Y8ZH7qG762rJWL364c8IrgS8simHEvq8Eqcj+tLCuxAXUqm/cyWNCsmhPYJGDFDTjYuL/nhMXa45iwjJAasf3UmDzf4IiV/fadlMp2T4ZoVOuM5KcaXQHkk4LkE0eVNVHAguU+dbHbSM/JROF1nVNvAoVukiWr6XpFSOB2R2kFF8ORoS13f28pArjJRT03IdP+KomgmkpZc1vs2TBbKMs+n
 5dnrqLxq
 NnI/9ACbETX6EUodStO/wA5StfqEmVq0WBFz9/rh1Y56zQsK7AKJ0/NjWNJaedBY2J8q9mZTHExQ9DbJOF379OZA2GAbRt2Kpvt5fW+4M9yk98C/i38t0BDwaAGw4xvECfC9eq0NqDf3zSMGDo8n7oiPk0Dz1VtlP5stuyHbXocwI+ClnSLJL24TP3P9A/+xgLzRnHVgu788S+cTfddMyktSEaItEcc7sbqYO/W+x0yNyRWHje/YaY7I5cMLIZExfQHMuEBac3xGVrV6aRjEqqpbC4IoQhkEFl/ST8h+f/8ubZ8nh6qwBMocsTh+qxRGi5Pgjxr8BF9ULWN876FGWHHQlABPajdWhgasoYSI6OodTus1Y+AhRXETCqJ5JwersoBVwYyZdd1r2AMT3skhAysyJLmwLHsMn4T2P+sQ/Q3vZBhmklI9jIhnlQw4PK3B/NsLGpz6dPFMbwPM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 06:25:30PM -1000, Linus Torvalds wrote:
> On Tue, 21 Oct 2025 at 13:39, Dave Chinner <david@fromorbit.com> wrote:
> >
> > > > >   1. Locate a folio in XArray.
> > > > >   2. Obtain a reference on the folio using folio_try_get().
> > > > >   3. If successful, verify that the folio still belongs to
> > > > >      the mapping and has not been truncated or reclaimed.
> >
> > What about if it has been hole-punched?
> 
> The sequence number check should take care of anything like that. Do
> you have any reason to believe it doesn't?

Invalidation doing partial folio zeroing isn't covered by the page
cache delete sequence number.

> Yes, you can get the "before or after or between" behavior, but you
> can get that with perfectly regular reads that take the refcount on
> the page.

Yes, and it is the "in between" behaviour that is the problem here.

Hole punching (and all the other fallocate() operations) are
supposed to be atomic w.r.t. user IO. i.e. you should see either the
non-punched data or the punched data, never a mix of the two. A mix
of the two is a transient data corruption event....

This invalidation race does not exist on XFS, even on this
new fast path.  We protect all buffered reads with the
inode->i_rwsem, so we guarantee they can't race
with fallocate() operations performing invalidations because
fallocate() takes the i_rwsem exclusively. This IO exclusion model
was baked into the XFS locking architecture over 30 years ago.

The problem is the other filesystems don't use this sort of IO
exclusion model (ext4, btrfs, etc) but instead use the page cache
folio locking to only avoid concurrent modification to the same file
range.

Hence they are exposed to this transient state because they rely on
folio locks for arbitrating concurrent access to the page cache and
buffered reads run completely unlocked. i.e. because....

> Reads have never taken the page lock, and have never been serialized that way.

... they are exposed to transient data states in the page cache
during invalidation operations. The i_size checks avoid these
transient states for truncation, but there are no checks that can be
made to avoid them for other sources of invalidation operations.


The mapping->invalidate_lock only prevents page cache instantiation
from occurring, allowing filesystems to create a barrier that
prevents page cache repopulation after invalidation until the
invalidate lock is dropped. This allows them to complete the
fallocate() operation before exposing the result to users.

However, it does not prevent buffered read cache hits racing with
overlapping invalidation operations, and that's the problem I'm
pointing out that this new fast path will still hit, even though it
tries to bounce-buffer it's way around transient states.

So, yes, you are right when you say:

> So the fast case changes absolutely nothing in this respect that I can see.

But that does not make the existing page cache behaviour desirable.
Reading corrupt data faster is still reading corrupt data :/

Really, though, I'm only mentioning this stuff beacuse both the
author of the patch and the reviewer did not seem to know how i_size
is used in this code to avoid truncate races. truncate races are the
simple part of the problem, hole punching is a lot harder to get
right.  If the author hasn't thought about it, it is likely there
are subtle bugs lurking....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

