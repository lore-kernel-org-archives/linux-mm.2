Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 476E6CAC587
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 01:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943848E0005; Sun, 14 Sep 2025 21:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920E58E0001; Sun, 14 Sep 2025 21:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8582A8E0005; Sun, 14 Sep 2025 21:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 734B08E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 21:48:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 503C5119ED8
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:48:03 +0000 (UTC)
X-FDA: 83889798846.30.601BB6B
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 43C0040005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:48:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="0/GiSBfZ";
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757900881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIXX03yHmfXV7hPctk1QY3phtIy2gG2kRyctwix/uK0=;
	b=zCZxhxRiEh3pwnr1gf/ioElGNFU0zMDNhgWOKVMpdIIZ2TSEX1h541OXUyNliTQ5XBFW3T
	iqVmuBugLa+hEHpVPgPmyeNqQUWyqH7YI7rtfErCywOROi2K7oOnPnWsj09QD/mVXOUwZH
	DM+nMPPKDD52SSHCtIIl9pvLcbIWvzQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="0/GiSBfZ";
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757900881; a=rsa-sha256;
	cv=none;
	b=oMiDdy7QW163jHPg9bu4LNrVhkTUV4Y4Wyt9BJboEKiLOIRR8PRp1J6lTySSkodOSbb7pZ
	9mxqlM0drPLELRswQWyrTJRyBgjKp7USptF4oIlIyyYajo2eLksb4pgH6nkneUkX3UIrlp
	Alb2mZh3soEhxpqbMkMqRZKXQiYbiHU=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b78657a35aso366141cf.0
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 18:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757900880; x=1758505680; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FIXX03yHmfXV7hPctk1QY3phtIy2gG2kRyctwix/uK0=;
        b=0/GiSBfZPjSOPiB+gxLfEj3vYHZyqUphxTI/OlgXegIHSrAXcIRAeuJ8xHsXkB2xVo
         sNXq1lYrC+jdwknRZNLIAXJxiLLkxN5ieuOMqqnGdn8d4UT7/IrlNuflv1J/L8idG7h9
         r5vEinN50GRMHp0kaKATCBdtquVprIG688QsKVqGmTN9x2WUWrXujnqCji6RdWXUMVfN
         P9CE29g0/yIzr7+A/7M7AipoeLMaiPWvkSpM2swOWRKDhDEPOVg/1gK9IcEPXbL+Qh2i
         Ak2oWFNPly61+imXNNIV9DgSKpT3fmeOoute09D+j5VueQNGjb6O8HLEvDFWnY5un2UL
         rE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757900880; x=1758505680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FIXX03yHmfXV7hPctk1QY3phtIy2gG2kRyctwix/uK0=;
        b=r+1fdPQ0tf+e0kBFXx1K9XeBtYSdWEb+2HJMJUfcwvxtsrloF6kyIUWrJXVsA5WGut
         NPEZ3TFqDAb72fQqYKMh43lLU4yLXr9uo/iFGMp8KwxlbR+9H3D5sN/EVtb8zdWmzQeI
         lOMij5PuKwaCb6ZkaKmI8TqvVfVsKC3zvOI+fM6uYDmjahZxdJqrizZ2yhmap810Na+j
         SwxkzSxHRrZzgkjnMqJp0T/meg/spZM3KdBDa1V8Ph9kmVwfJbDB8b3duiymxiNSDxkc
         F4NwZs1ESkeTWOScSqtI1AnQMA88v6dMUkih5HQ/1PzrN3Xg9BMrG4xrie8zJ2TXK8xT
         Mfog==
X-Forwarded-Encrypted: i=1; AJvYcCVl7sTOvwAv6A/zPtP7A42XGjSImQsw/oiP/HMSH+IKnV/21YCF50mucgxC4JlEdSa3SouYRzxnpw==@kvack.org
X-Gm-Message-State: AOJu0Yxh8zd8vamVGdqwhfTSpLL+2KSHC7lpWQugV5rJU+losCFbTVhz
	It4ryCjK0kmBVN8ofYqdY4ZltKHbeEUFcUhxUtb18Nd2kXuKcUEAy6IocUc6jhk5WZweGtyejnG
	5DoWWUTrQZA8hcZYoGyFnd3KepQOh397eL7UyoRT9
X-Gm-Gg: ASbGncs2eKDq00LqHt7hpeXNfqS3Qiub9UC1NLFfdXPojgljnaVz8S3Z+bxeP9enCGy
	HCqlflE7RhuD3JhqOR8jHtAz1kPLEi+8eDA/gr6/1b1qQjmvjyZwASCdzP4wVPvfQic3NDzIKel
	hreN26u9V/vSUHDZFyAPZaDhYkQkzF/2acCMa4wW9OMCp9qQfjcqNr/jKtQx8dUQPGiUOj/lEf1
	m9zEeZfskTg
X-Google-Smtp-Source: AGHT+IGDStSCrDGIkYi6IBxzwcIRB3/ZX1YMHfaP+6xZGT7Z/qilK9xJ3n0aXQvoLpi+zVKoffQnExVOt+6U9nbESss=
X-Received: by 2002:a05:622a:c5:b0:4b7:9a9e:833f with SMTP id
 d75a77b69052e-4b79a9e86f7mr4747141cf.7.1757900879867; Sun, 14 Sep 2025
 18:47:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <aMdVcH7KCXBvLtFP@casper.infradead.org> <CAGsJ_4xDRB_F-T42WnhqpmwLyiZRwLGqx9vDf_d5TFALsCRX4A@mail.gmail.com>
In-Reply-To: <CAGsJ_4xDRB_F-T42WnhqpmwLyiZRwLGqx9vDf_d5TFALsCRX4A@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Sep 2025 18:47:48 -0700
X-Gm-Features: AS18NWCJdJ-ZvvU3DQc-AbjElHYpRhDtbtyHuV8mCqxji2O65VfpejGAAIaTPtc
Message-ID: <CAJuCfpG1DHeLtsTcD3A46vDV5BwBDAD7B-EVG4TQEY-GSvzfeg@mail.gmail.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
To: Barry Song <21cnbao@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Nicolas Geoffray <ngeoffray@google.com>, 
	Lokesh Gidra <lokeshgidra@google.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>, 
	SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 43C0040005
X-Stat-Signature: i9ib1ob53bbwmwdrfqtei8j67zzn6333
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757900881-911561
X-HE-Meta: U2FsdGVkX1/hZt/D9Ovh0iUKr4NyPYw9Kp4xkDQzK3Tc36WdnKtE/vc9gqFexFHdphwrelq9qPfBov67pbKZXkflaBjuwj7oOu1YSSIwMCJlLsn6HwI6U2QYZnvFxzIhbl8Ohvd5Yx/AFsG9VqNflu+uGFfPnAOhH9Er0FzUTbzz9prCWW1GdGYqn6Vha+q2fiSQqXpKP4IhAY6KW86sm3bCG4TaVq6a3urjaf5ACcMESVB/hUs2c/TgBO02SNvbvHCtZDwGxU9p84JI2U9aan+a+UFCvy6TnQxR3YEbUNXbPBzmQTZr0nLS4xbH7ay8DPqlcuvuMiTn6Bd5WSWJxNry1zZiO9DfQ61QWB2rJvd+DYMbYy1kn/NOEImh9/hjanHYLYxodniE6A+qY0UzUi9I42PiCyf0QlHX12wQuv3UzbCwiy1n52aLbt+GB9wbU6OBi6kY6gXr6IWcZ23JIQPUylXO43yEeTjPltKadEHdDlcOtfIsRPzsbkc6bcuVfgwieAcJFafCkXd6h1A/cia+2DyJ2f4fekj3hjSs4Kulbh0hxyIaXW8ryx4yxy/ucck0mdCUJRN1IT0V7hPRvSvVUhPGSr31/Zfzpc+1347NGa/lZkld+o2vAXtYiK8JDi7wCrJEshUGz+czgLBxXQ2LzQAl1Hfea8mDQLY4YV4b7ayLbCz5IR8RyytRmOpk0vIXNTV2Ua7GsZV+Ew4NJ5vzf6A7iTeNmCxf9JQD8L1jmESO1JQivM8iSFgdZ8I3tqfHM2WXPQ7m8mT7Guy4r3W1VTFXO32+az7pvoDEe9YPu9/vS7mbZEn7Q1VebioxMXMqn1MPNkIevBoDJoPFvCtMjYHzuai3dIqnOWcneq6GoVkL7k1sF6/16nnG2RoemXvdz3Q1dS7JqbpFAoIoJ+fYIHcA4d0fmyGw9zD6Y4jnmoV8kglatWRcDd8xFi6YlLKuf2LdWcxVs7hRa5n
 7Dz8l0l7
 bPjpMee0GL7Kl8qXkoTUVul8sPPSbxcMHH9c2HF6ERIvMW0nxweiegRlaKTMNVTfwIQVYSOYeg1oU3BA9A1hvfqCbRXUCRIRIpZrXwmoC8BIJl1JEpwYE06hmFsqhC+WTVYik2aVvQZOicfZZOzvRiZ8lKhm2Mr50HZWrx0HbY7QoLuH+i24IdnExJizW7NBK1DPSp7/YcblgGYFgVz9vn+8gxHlgpH2wIFbIUfjpGT4NXUl3pH57GHgbsmqGBgOfhmm+CkXbqfAUeaD8yF7vt1l4hg5KYpirAfbEIFXRWUtvwF+55yhCjoVl9uUFXZrmn7rx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 14, 2025 at 5:23=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Mon, Sep 15, 2025 at 7:53=E2=80=AFAM Matthew Wilcox <willy@infradead.o=
rg> wrote:
> >
> > On Thu, Sep 11, 2025 at 07:17:01PM +1200, Barry Song wrote:
> > > In the process tree, many processes may share anon_vma->root, even if
> > > they don=E2=80=99t share the anon_vma itself. This causes serious loc=
k contention
> > > between memory reclamation (which calls folio_referenced and try_to_u=
nmap)
> > > and other processes calling fork(), exit(), mprotect(), etc.
> > >
> > > On Android, this issue becomes more severe since many processes are
> > > descendants of zygote.
> >
> > I'm not nearly as familiar with anon_vma as, well, the rest of you
> > are.  As I understand this situation, usually after fork(), a process
> > calls exec() and the VMAs evaporate.  Android is different in that afte=
r
> > the zygotecalls fork(), there is no exec() and so the VMAs stay COW.
> >
> > I wonder if we could fix this by adding a new syscall:
> >
> >         mremap(addr, size, size, MREMAP_COW_NOW);
> >
> > That would create a new VMA that contains the COWed pages from the
> > old VMA, but crucially no longer attached to the anon_vma root of
> > the zygote.  You wouldn't want to call this for every VMA, of course.
> > Just the ones which are likely to be fully COWed.
> >
> > Maybe this isn't practical, but I thought it worth suggesting.
>
> Thank you for the suggestion, Matthew.
>
> Lorenzo suggested possibly unlinking the child anon_vma from the root onc=
e all
> folios have been CoW-ed:
>
> "Right now, even if you entirely CoW everything in a VMA, we are still
> attached to parents with all the overhead. That's something I can look at=
.
> "
>
> My concern is that it=E2=80=99s difficult to determine whether a VMA has =
been completely
> CoW-ed, and a single shared folio would prevent the unlink.
> So I=E2=80=99m not sure this approach would work.
>
> You seem to be proposing a forced CoW as a way to safely unlink from the =
root.
>
> A side effect is the potential for sudden, heavy memory allocation,
> whereas CoW lets asynchronous tasks such as kswap work concurrently.
>
> Another issue is the extra memory use from folios that could have been
> shared but aren=E2=80=99t=E2=80=94likely minor on Android, since only a s=
mall portion
> of memory is actually shared, based on our observations.
>
> Calling mremap for each VMA might be difficult. Something applied to the
> whole process could be more practical=E2=80=94similar to exec, but only
> performing CoW and unlinking the anon_vma root.
>
> On the other hand, most anon folios are not actually shared, yet
> folio_referenced and try_to_unmap still take the entire root lock.
> In reality, they only care about their own node=E2=80=94no need to iterat=
e
> the whole tree.
>
> I still think optimizing from that angle could be a better entry point :-=
)

Hi Barry,
Thanks for raising this issue. I think technically the optimization
you are suggesting is possible and it does look similar to per-vma
locking in that:
- The reader tries to read-lock a specific interval and on failure
falls back to locking the entire tree (root);
- The writer write-locks the root first and then one or more
individual nodes in the tree. Once the writer is done it unlocks all
the nodes it locked and then the root.
But as Lorenzo pointed out, this will not be pretty, as it adds yet
another lock and more locking/unlocking into the writer path.
In the case of the pagefault path, improving its performance at the
expense of the writers was not questioned due to pagefault being such
a hot path. I'm not sure reclaim will be given the same benefit...
Something to consider.
In any case, I'm very interested in continuing this discussion and
would love to test a POC or discuss this at LPC.
Thanks,
Suren.

>
> Thanks
> Barry

