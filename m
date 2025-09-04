Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3FAECA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 17:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0228E0006; Thu,  4 Sep 2025 13:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059558E0003; Thu,  4 Sep 2025 13:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89AC8E0006; Thu,  4 Sep 2025 13:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D30308E0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 13:43:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76973160312
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:43:54 +0000 (UTC)
X-FDA: 83852290788.06.90ABFF5
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 92B2F180009
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:43:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FIaF0Tto;
	spf=pass (imf16.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757007832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wWbc1gScFbVDYqIT9xFJKpu1PWDgbhL6vhmg/aRJGY=;
	b=VaOBU059OmkUP7d8Q77/9rbTwfvUcFPbIO60uu/jmKKwZmrMVlnbn6rlRe7jIUPctbtZ8M
	wn8KS9+4+39HnNaPjobMWK7ggLxZx2NKe2lBwbHwkyBNEBO8Z5/Or49DDztL4XDt4K/0wN
	fk86CT2Jmno61yHQVTHpWIfBlIYughM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FIaF0Tto;
	spf=pass (imf16.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757007832; a=rsa-sha256;
	cv=none;
	b=UZeRelIY27mZIOBY10lZapBMB3tKXHSA8es9RnuaQKd9uqUl9r7JhHIktalpOhjmdeStKJ
	zW86/u/R7jLn7URF4wWkoAz+Cc6FpMlLT9tGaYoKuyd00veyKWQOK6GqCdYla1nAn+ERYY
	M5MddxhKSI5JMEegYMDBGP5FkD/M6Vk=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-24b2337d1bfso19455ad.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 10:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757007831; x=1757612631; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1wWbc1gScFbVDYqIT9xFJKpu1PWDgbhL6vhmg/aRJGY=;
        b=FIaF0Ttoblw2mmnRqyGLjnUmyLb7xh5wVuYsKGnM1KxG6KnxlaX9eSjhJIa+oqNv/t
         VncjM9ubtGBZw60KDozBMJ5lGupRTPi0K+LljLrwqTp7l4QEKdJkhQUWXYt1PopwMjE4
         OWABnaIHD4VKo+9a2F92Fv4nNusIxCEO5vUFKxHGcWufEeLaUDnG6LV98TaxgnrPSmhO
         bbG2pZJXbqWGrZv23GBbkIthVyaVDHt9aUZ86cL6+kIUNjlAVDQ75OvGJsYy6c5WLeyJ
         akcYNDrYipS5iAsvUHUi7qoryPKJ78pIsWULMXVMfl/DuvRTmj4xBP+CWP0U4tSX3/9S
         nyog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757007831; x=1757612631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1wWbc1gScFbVDYqIT9xFJKpu1PWDgbhL6vhmg/aRJGY=;
        b=lIrMxm/qURDz7NV3pmc5BbhsG+qEgRwO9Tr/fX34GVM0dHrPxeA8RGOLaOW7y8w3P9
         2/mc0HSjXtRIGM+o+K52+dCMRLR1vAOmD43VUSSUlxpNbqmy/Yy4n3B2W8PverYGZgLJ
         Wfy/KllWE1RH00HgHm7N8zmaHEAKV8t5eiS43F+ih0IsKhgNQsNGrx8E+/sKfuCuDh+c
         r0xdLiK3BYYgSFP430L4jD+A9GLtJLGwJ6DBxtKGGCAPQMZnij+p2ooN7INiz0rYvA3z
         mtUvIsqN3Ob3B/vKNqX9U/1VkVsUzufsmPIDFVEqBJLzGTavp76nY/iM+J4KIHsXGTD2
         NCXA==
X-Forwarded-Encrypted: i=1; AJvYcCVOmQa/WIG6w6EV2pBNlv8M5lY9bhArBbajovOlOYcigYRLrsmha4fIEMqPnvLvZjBviTS9EX0SQA==@kvack.org
X-Gm-Message-State: AOJu0Yz+l0R1F3oYoKFhFIhGDlA4qMDaQAyzZz0EFRL8g+KZzgeUcP6o
	YE6oW1IqCvBi45z6qFCleoKxLLG+4oP9Yf9RzFK+pbfJdc/LC+fUiX0DB+tkc+7+Tmhxj8bXcd6
	8ct/FhhfSw/b2a5o/EbPpdqsTjsmw/Ix3z9Jt6jO9
X-Gm-Gg: ASbGncucLAHe3/3q9xOh/LM1EbNr+fxMQDwvQ0VHv4Fz66I+MfrRvZWgaijL8EkOuvC
	1Lr3HchioMYJRMCVymAaz1Cf2z49Z4nZ+oAtpw44rqx0tBqswfHEcRPDsu3N/0YAFlwJghZKNT4
	qtTkDqy6p0HR7AFzNp2U7Nawo/lRzZMj8muuY0qUlS8sO8o7xsih7q5c+XkZ50lr26XyZjjfTS0
	q4tiJGuw+Kciqz5/lC2ceNC5euYRT29v9hSdyVusOZwa8Uvh3UlQNc=
X-Google-Smtp-Source: AGHT+IFroDM4Brfkdoh6XHD17Mw5Q+wL7QsYilpxVXqgsw9AcRCm8Y2S/sHTZ0sspf0CyKz9yiAXKqbgpVOuuSHbKe4=
X-Received: by 2002:a17:902:f693:b0:248:9d28:fca with SMTP id
 d9443c01a7336-24cf5c4af03mr42785ad.14.1757007830996; Thu, 04 Sep 2025
 10:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250903232437.1454293-1-kaleshsingh@google.com>
 <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local> <43ryds7hzhs5bpaxznco7fppmakdb4f46agwtsc5erudqfoz2x@7y4jgbtft7jj>
 <413ee338-1795-433c-b3d4-72c870488d95@lucifer.local>
In-Reply-To: <413ee338-1795-433c-b3d4-72c870488d95@lucifer.local>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 4 Sep 2025 10:43:39 -0700
X-Gm-Features: Ac12FXwMuBbeKLTnzz-vrMqaDdYeAL1AnUaDmDRhybzWNwdrA2CKosvm7364eLA
Message-ID: <CAC_TJvcCW003ef3=RCXTbC7daSS2+tiS24-7JdTLn3QVJX3Bgg@mail.gmail.com>
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, akpm@linux-foundation.org, minchan@kernel.org, 
	kernel-team@android.com, android-mm@google.com, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1dx1b41hhrs76bbfkbezgcnk3wg6h8uj
X-Rspam-User: 
X-Rspamd-Queue-Id: 92B2F180009
X-Rspamd-Server: rspam05
X-HE-Tag: 1757007832-426311
X-HE-Meta: U2FsdGVkX19JL6SaoN91rZ4idZnuq0MWvy74P+Ga5yU6rua+qRZrM5VoM5iZDlOnZBsJP6z6k6woqJd/WCkfuYcNp3MiSZKSIuc/KLdIT6QZU8LbPjt65FQXaMRd9V95KUgSS9uw2yDJg250G/d2k47HNeCk2ycelhC0nqtgCPqXalpYCR50n7/ynSo5rd34dlZvsjoN7hhcS8M91TyPL3ViXiXv369nMALnm6QI1XYv0Fx4Dfx6Xs/prQqEAlrPsEPB4RmiypAteYXbfsOcbZjwZ/2QUBL3yNkI89EiQotiU0uvAXhc2jJClnEOPiVx7IJJx2JJNDZcRdWdNqPBa74Ay5Pn3lpCXLShQBvcH1Z4fGa1TTkUScLzDXyykOwK7JaGxc1HTjb++a32MTSHRXZyVNT9KoCZ7HNP0zpQXFkFHAjYr3YwtfSdb//dOwgFt51cgk6EkfaZZ3WjvuRofsSrJPaQxXkjItSiSxOtP26k4VmGEHSEuc5A9BhBWzvAVpPjECku65L7hqnlTOIzc+I/eZXT/AdJHlC6TtJYCqlR3yk5bXk1tkdnrujJV9dIn8qomaFTWMeOKvDTS3uX5CvGERSL/kfnDOl+etPZ8okioLE1+cJfy/v6sVmLI0WEMrZt8a1y6vNzihk/J5XIN5QnHQCINevUexhWY/kAPWw1mataUj9nrG+8r6BbRSJfqJjEW+mT3TKxSZrl8eN/xTuC1p4krS8WZxvIvpmK4TyuCr5urcD0SJ1ypf5gG2amIUBS28bCWUczSufCZutYdOIbIjFe2gWdAYKVO4cs2ECWPRXbsmUMNaaI4zt4NOSqb7R2lygX1wQO73uV+XfmAWNNnGf76EEFzCLaqtPV5DiZLzQ3HRhj56oa6oSKjrxczkUzcid2GdswM4JiTiC5t7soCZqzmg5ZG2otUixzE7ofvmjA+P3kJGdS+7111uU9b/p3vd1RIbGJoS3BAdW
 Z1LmLRbC
 svclzTnWrX+ah6ouZYwTRa3d9mx/XGHu7kx1iG/SBONnavBg6WTzFHpnGLcmVzxrmXLg5VfmO17IuZqibu2leNVRGjRXxHJ8K2NM63ofs5WMPdi7HmbDPJG/Qldrgq1RtqVWh/S9aqPhD+sy1uSZWXtyj0n/pDcDGzIwiRpDGR8gvsUBmqAqHRxz2d93yDZLyCoOjn00pbXzqvfMn5uA3Y29KvpFW6VMOfIAe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 10:33=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Sep 04, 2025 at 01:22:51PM -0400, Liam R. Howlett wrote:
> > > > diff --git a/mm/mremap.c b/mm/mremap.c
> > > > index e618a706aff5..793fad58302c 100644
> > > > --- a/mm/mremap.c
> > > > +++ b/mm/mremap.c
> > > > @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma=
_remap_struct *vrm)
> > > >    * We'd prefer to avoid failure later on in do_munmap:
> > > >    * which may split one vma into three before unmapping.
> > > >    */
> > > > - if (current->mm->map_count >=3D sysctl_max_map_count - 3)
> > > > + if (exceeds_max_map_count(current->mm, 4))
> > > >           return -ENOMEM;
> > >
> > > In my version this would be:
> > >
> > >     if (map_count_capacity(current->mm) < 4)
> > >             return -ENOMEM;
> > >
> >
> > Someone could write map_count_capacity(current->mm) <=3D 4 and reintrod=
uce
> > what this is trying to solve.  And with the way it is written in this
> > patch, someone could pass in the wrong number.

Hi Liam,

I still think there is value to this as it's lot less likely to get
the common case incorrectly:

if (!map_count_capacity(mm))
        return -ENOMEM;

It also facilitate us adding the asserts as Pedro suggested (excluding
the munmap() case.

>
> Right, but I think 'capacity' is pretty clear here, if the caller does so=
mething
> silly then that's on them...
>
> >
> > I'm not sure this is worth doing.  There are places we allow the count
> > to go higher.
>
> ...But yeah, it's kinda borderline as to how useful this is.
>
> I _do_ however like the 'put map count in one place statically' rather th=
an
> having a global, so a minimal version of this could be to just have a hel=
per
> function that gets the sysctl_max_map_count, e.g.:
>
> if (current->mm->mmap_count >=3D max_map_count() - 3)
>
> etc. etc.
>
> >
> > Certainly fix the brk < to be <=3D and any other calculations, but the
> > rest seem okay as-is to me.  The only real way to be sure we don't caus=
e
> > a bug in the future is to have better testing.
>
> Speaking of testing - Kalesh - do make sure to test the VMA tests to make=
 sure
> this doesn't break those - they live in tools/testing/vma and you just ha=
ve to
> do make && ./vma

Thanks Lorenzo, will do.

-- Kalesh

>
> Cheers!
>
> >
> > Thanks,
> > Liam

