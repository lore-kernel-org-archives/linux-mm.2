Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA3AD1950F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 18:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3894B6B0005; Mon, 26 Jan 2026 13:15:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336D96B0089; Mon, 26 Jan 2026 13:15:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E8C6B008A; Mon, 26 Jan 2026 13:15:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F94D6B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:15:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B48691A0894
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:15:33 +0000 (UTC)
X-FDA: 84374917746.24.B7E8BED
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id C377340015
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:15:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tQh27Aqe;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769451331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vypNXdAlh9xtr/sInNFux3fIr3gyK1o+LAzNlNFXqsw=;
	b=UVmyX3gRECH+MRHlZDK9Kj08QlhGeVjwGvvq/72SNxyZF4TV6CYXtfDRSpoP+4XUk+05Vj
	5K8+JKQUWX4gtvUizw1NcF0mtKipMiV+Z/cGy9pVCl6Ps9nQ+g1GgHC0LI05XuNDluBlk4
	4TMVvhQ9BonWNwciENlQvYCR1FOIXv0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769451331; a=rsa-sha256;
	cv=pass;
	b=fMG7wfpgbl+X/RegeLynhfwF+YCTF/ld8dptGOSbGZzNdfEFxn35i82LzEM9KCZ1Oc28rW
	Q27FYkNQWuiF65AeMmLHUGwSBuRQDEBtvDQo4aX5gsWd7Meghu+YQh4+l3nYV+W2bv1WiJ
	CvBOEtHNF8MZgEteGUG7PFBU8m8oQ+o=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tQh27Aqe;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5014acad6f2so17191cf.1
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:15:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769451331; cv=none;
        d=google.com; s=arc-20240605;
        b=dbRxQip/uguCCAe1J4aqLlVglu0WA0eOdS1DyGtDu7oqsls25E62qIEwqqwhduGtDL
         Jfu0C7t5dF6HPw0nzvohqOgb5QKd/4DrDoBmcyWlapzmff7hHWAA1VZpRNAVXD7hdzAW
         foRPzE7QqTQuruDUUBOOU8WV0q2KmGZZRvkkmUCQxo8vFpBH3I4vbOzhBZejw92yOxjO
         YEVkSvia3zmiBkv8T8OCS7ngthILBVuWiokUObF4Y+HeWKFD/OnO+GsfWu+EkC02Ze74
         sEhmIgJfV5LE8Q8G8t6pKikkitkbh+HpZTG7RdRMvVmizcigouCt/ocio/lA4TZ0AODb
         3jew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vypNXdAlh9xtr/sInNFux3fIr3gyK1o+LAzNlNFXqsw=;
        fh=/pQ0HE0oYFt/0ljAGQiWtuL2FOi7/f/XeniN45hMYOU=;
        b=ai5SGStIMcDvNHjMX1Q7p4B2e8MCgyWBA/uhLJXlxiAwcz90bHncY1UBZtaNFMR8QH
         F95X54ISHMJMn3saX8mjB/5KHTBGvRhLvYUZ7iHbD9I3O8qoQgy5cnsONaLwdq0qO+N9
         VrcGvErawU40iSnu1TBMVVcloto1oVzeDoHQ9HSK8hFhAX+LFeVo6Swhv0n1Tpq8sEbm
         YqExLSCJOYYIDlvq+4fgxNKGfAjsD8sLA22Zl4eHhZlk0O7MzwfXBkR9bab1VsbkdU/g
         XEmcvOZBJCr9o030RRcP8DiZWKLDwgGGtFzHvaAuBzRGLXkR8JFp8kYVHzljLGgJHZrj
         Balw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769451331; x=1770056131; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vypNXdAlh9xtr/sInNFux3fIr3gyK1o+LAzNlNFXqsw=;
        b=tQh27AqeB2eSFay06TruHq279kAGNF8oJ4kjAQNPQsQbVKKTkwQugmNSW2l7KCoNr5
         YqPUhgNZxRsSvLcaJkqSEzPXQvoS/zBX9APm8fPhrCCSreI3CBORSz0zAGi8q8ns6uy7
         LPGx4eIJZFGLmEXjJgEF5j4wKkstj/90TtFtu98i4h6cmuFedBHndPasqeJRqnsH8DU5
         Mibqiym0dNbPM+hUaODGM2lGTAeD3KD/3PraUbZ8hMwFH39k3Ru8RJy+Fk0GsnKuVwm7
         2g+NMtHYlXk08xtLSYlbyrjFHhoKJjuNUwyCmjes63fS55QUtBGt49wiB7ZdQ1bPTYDZ
         jSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769451331; x=1770056131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vypNXdAlh9xtr/sInNFux3fIr3gyK1o+LAzNlNFXqsw=;
        b=hD+b7vVw+2fLpCsr1fpX4745pEfQdyFgx0ZdLwGsV2tKfRdOQhx9pTX2vkop2mdBJv
         oqlAPqmjceuwpob1ocxp4i8CeHeWUKEdIyNsqnfzYfffmZddePOrmMUAjfe64fmI9U9r
         79s9lt+AvoDH3HwKKmpMnlthhcoWf3jf1kPNhgBektcVsyfhiU7QvzOjW62LVcmlcgt5
         yzbkt7sQ3+fqA5Z44RGSorhq5SNxqcjAGOHAn4wgtBNFXaeZxCZ0wwOzNwwhILso5ymg
         HMJrsf4p38g8NXCLuAIgXeTZ2nrrKzuzQ5I06EIcvUXBSIRCWDy2d3/qLQoIG6TFRJQC
         s75g==
X-Forwarded-Encrypted: i=1; AJvYcCX4pMEy9WH4wwLnasmsxN56ZB/gJeQD3nK9KBv6hQWDPMScXc+5VUPXyEylE+OzXP5hs+16JyjDJw==@kvack.org
X-Gm-Message-State: AOJu0YzD+gKskHPWRCrwsHK7p1Bv0HnmakE8UqaOfgOWns425eXoU/yg
	8KUfEp0N77Ix/aUE4dYx+3cmgqos401jzhCoRbAMDe52oC9cycFklTixmIxd4gGAaOO3OfW+Nxo
	U96FUTbMSF3a1II4Ok2hJxnreGOdz3BWgbxWUW1ls
X-Gm-Gg: AZuq6aI9vGnre9uJpvPYZfPkA4hMxPn4MMZ/wZjMVvIBFzclIXGgYL0nk2kM46cdXH2
	h/LRzFWqFEa6nAjV8X+v8kzWLvKni1xflalUgybqOEjQXkxXNu3GaReSKjeAirRonhbk7EqQNkA
	yeJVunS4MlvRpfKfZLUUvRQT3Fb9ivNzDBE6baY9vS/esvmeT4EOsYq4UHdjKibow6wcA5Xsvlu
	bhW90qweErfP85Lth7WU+elhmZkknxY8GpNZGk2Q3cGE91jeqK2Xlp0aprJjJM0vxDUrA==
X-Received: by 2002:ac8:7d55:0:b0:502:f1e0:dd3b with SMTP id
 d75a77b69052e-503142fd12bmr14244281cf.7.1769451330395; Mon, 26 Jan 2026
 10:15:30 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <7d3084d596c84da10dd374130a5055deba6439c0.1769198904.git.lorenzo.stoakes@oracle.com>
 <ba27d41a-2109-4c89-83ce-00ba8b78d249@suse.cz>
In-Reply-To: <ba27d41a-2109-4c89-83ce-00ba8b78d249@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 26 Jan 2026 10:15:19 -0800
X-Gm-Features: AZwV_QgyKFOWHTjmvluDsVSs8ymtZTUXuwqayAi8HRabjZVKe2RBfgyVhhCTGtQ
Message-ID: <CAJuCfpEkmMT9Bi6=46pvpezb3xMNnJgEKdKSQEm6Ky=Ygb2hAw@mail.gmail.com>
Subject: Re: [PATCH v4 07/10] mm/vma: introduce helper struct + thread through
 exclusive lock fns
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C377340015
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: a637n6me7eycbin5kt4ro9p6mebs3a1p
X-HE-Tag: 1769451331-148753
X-HE-Meta: U2FsdGVkX1/em/iJSq91TX0/KqQKYiwFYOwQBrWF5rNIbLsvCEBAwxoDn+whm4OEGS2prScMlU8LsEQ77zp3P/AeMd+JejROYqyZkOgiL9CtMYTRQhk1BwZru2vlwu0fEhcnq9yhmn+LoMZuBTaihX38y2l65Rb8qyXpn+WgfqhxmlIYmkXGovVEBccfOBfgdApmow9g17WyQsutypIno0hHNzTSbCh4MXlB2XxufRlfBM5jjd03SZA0FgJAf61RNJ/rDNU/GMsRzCfdvkR3dIDIh+0ILFtScBDjlpOIKi3XjOoWv3Oi5vz0KuA+Of7TOLeuGFi4Pg0iMsoyjwe5/5BtmeV63//yzQDWJSAu3XcEfkqtLsGAfPbObRUp5mMHG1Lk0NwQX3eJzWosYlebRlZZjQV7TT0EZa9Hl9H6IUsq5yNFwiUYjGGPYeVBxMp7ZdwIGaMqddbN6bQ7O55xs7FPXtocfzFKKVWlxbTUyKJoEcU95e6B8K0ZeLASQ0+plUAe6HZftdju4LBiotXUC5rYvQc2UwkdAxP4n8eXdg0LEcg3QStvjKUUsZP9abcVDBNfSd5Nmv5X7virYTtcsT/Sqo7j/tYQEWMSCJmfD9s+nkLasRaeqH/mcT5Tna8jSuLsNuVvGT50T6N0tt9jo0fH4ncRPB1tWz+sFe0ePdoewrHYYr6QN7zubMHaFL7lRDvUQLUlBYcaIKBp2btdtiJLlbe2O4nZnNewRXrazTzvscx1fqqBJHa6hLqya58RDrQK8/7bKtRqVp0OHu+DUt2hsCIOgYDPwhWNJwtUrOwZEdq8sEcBARB8PXtuOUXj/bRqaYA7+tYm8q179QPOIQWohYfiipuCH7iW4wAllDQ9v4Aclo/ZlOmSImzlfCtGVB8Al+kNnhoNMeB7HqwapxVK1vQWLMX2JGJ8AB8Vz7wVMrjshAXGq8KoJGW2t8RizzFlNNe9JCsUnVxJyns
 yeGvUXVE
 lI/SEZZ5VYPWFKhVcop4z4hjF0m01HBdxi+mQN9Y6cutbF0JfjWQkX7U0QPZjbu7vfcZQ9ne9nKSKYjPJsnAZkl9yN7POdWT9lHA3e96HkgTbnDaXIbmjjuSjFdDgec/LllLDktDjQ0FZ5IRzVZIfWBCtMBSDJvdbaVpAYMGYHpbAxE+RWM5SCWFlS9aofotFU3tPlrX3TNVh2Td53Q9f/vvW3PK3SmBJkN+nlZAzTelb8PHXSApupyZqhRIRJ5ORVJ0B1nnGhgMOuIfytTC/07K3n2e8QJS1AqZ/2VSZIepW/4Ge3Y8nlk3N/uhItxnG9Jo4DNXk1OaCVQGKCgyip+L1uwHYXsjOFfrcgkcVWseaha4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 3:16=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 1/23/26 21:12, Lorenzo Stoakes wrote:
> > It is confusing to have __vma_enter_exclusive_locked() return 0, 1 or a=
n
>
> It's now __vma_start_exclude_readers()
>
> > error (but only when waiting for readers in TASK_KILLABLE state), and
> > having the return value be stored in a stack variable called 'locked' i=
s
> > further confusion.
> >
> > More generally, we are doing a lock of rather finnicky things during th=
e
>
>                                  ^ lot?
>
> > acquisition of a state in which readers are excluded and moving out of =
this
> > state, including tracking whether we are detached or not or whether an
> > error occurred.
> >
> > We are implementing logic in __vma_enter_exclusive_locked() that
>
> again __vma_start_exclude_readers()
>
> > effectively acts as if 'if one caller calls us do X, if another then do=
 Y',
> > which is very confusing from a control flow perspective.
> >
> > Introducing the shared helper object state helps us avoid this, as we c=
an
> > now handle the 'an error arose but we're detached' condition correctly =
in
> > both callers - a warning if not detaching, and treating the situation a=
s if
> > no error arose in the case of a VMA detaching.
> >
> > This also acts to help document what's going on and allows us to add so=
me
> > more logical debug asserts.
> >
> > Also update vma_mark_detached() to add a guard clause for the likely
> > 'already detached' state (given we hold the mmap write lock), and add a
> > comment about ephemeral VMA read lock reference count increments to cla=
rify
> > why we are entering/exiting an exclusive locked state here.
> >
> > Finally, separate vma_mark_detached() into its fast-path component and =
make
> > it inline, then place the slow path for excluding readers in mmap_lock.=
c.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

With Vlastimil's nits fixed,

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> Great improvement, thanks.

Indeed, looks very clean now. Thanks!

>
> Just some more nits wrt naming.
>
> > ---
> >  include/linux/mm_types.h  |  14 ++--
> >  include/linux/mmap_lock.h |  23 +++++-
> >  mm/mmap_lock.c            | 152 +++++++++++++++++++++-----------------
> >  3 files changed, 112 insertions(+), 77 deletions(-)
> >
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 12281a1128c9..ca47a5d3d71e 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -1011,15 +1011,15 @@ struct vm_area_struct {
> >        * decrementing it again.
> >        *
> >        * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
> > -      * __vma_exit_locked() completion which will decrement the refere=
nce
> > -      * count to zero. IMPORTANT - at this stage no further readers ca=
n
> > -      * increment the reference count. It can only be reduced.
> > +      * __vma_exit_exclusive_locked() completion which will decrement =
the
>
> __vma_end_exclude_readers()
>
> > +      * reference count to zero. IMPORTANT - at this stage no further =
readers
> > +      * can increment the reference count. It can only be reduced.
> >        *
> >        * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either write-=
locking
> > -      * an attached VMA and has yet to invoke __vma_exit_locked(), OR =
a
> > -      * thread is detaching a VMA and is waiting on a single spurious =
reader
> > -      * in order to decrement the reference count. IMPORTANT - as abov=
e, no
> > -      * further readers can increment the reference count.
> > +      * an attached VMA and has yet to invoke __vma_exit_exclusive_loc=
ked(),
>
> __vma_end_exclude_readers()
>
> (also strictly speaking, these would belong to the previous patch, but no=
t
> worth the trouble moving)
>
> > +      * OR a thread is detaching a VMA and is waiting on a single spur=
ious
> > +      * reader in order to decrement the reference count. IMPORTANT - =
as
> > +      * above, no further readers can increment the reference count.
> >        *
> >        * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either
> >        * write-locking or detaching a VMA is waiting on readers to
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index d6df6aad3e24..678f90080fa6 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -358,7 +358,28 @@ static inline void vma_mark_attached(struct vm_are=
a_struct *vma)
> >       refcount_set_release(&vma->vm_refcnt, 1);
> >  }
> >
> > -void vma_mark_detached(struct vm_area_struct *vma);
> > +void __vma_exclude_readers_for_detach(struct vm_area_struct *vma);
> > +
> > +static inline void vma_mark_detached(struct vm_area_struct *vma)
> > +{
> > +     vma_assert_write_locked(vma);
> > +     vma_assert_attached(vma);
> > +
> > +     /*
> > +      * The VMA still being attached (refcnt > 0) - is unlikely, becau=
se the
> > +      * vma has been already write-locked and readers can increment vm=
_refcnt
> > +      * only temporarily before they check vm_lock_seq, realize the vm=
a is
> > +      * locked and drop back the vm_refcnt. That is a narrow window fo=
r
> > +      * observing a raised vm_refcnt.
> > +      *
> > +      * See the comment describing the vm_area_struct->vm_refcnt field=
 for
> > +      * details of possible refcnt values.
> > +      */
> > +     if (likely(!__vma_refcount_put_return(vma)))
> > +             return;
> > +
> > +     __vma_exclude_readers_for_detach(vma);
> > +}
> >
> >  struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
> >                                         unsigned long address);
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index 72f15f606093..b523a3fe110c 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -46,20 +46,38 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
> >  #ifdef CONFIG_MMU
> >  #ifdef CONFIG_PER_VMA_LOCK
> >
> > +/* State shared across __vma_[enter, exit]_exclusive_locked(). */
>
> __vma_[start,end]_exclude_readers
>
> > +struct vma_exclude_readers_state {
> > +     /* Input parameters. */
> > +     struct vm_area_struct *vma;
> > +     int state; /* TASK_KILLABLE or TASK_UNINTERRUPTIBLE. */
> > +     bool detaching;
> > +
> > +     /* Output parameters. */
> > +     bool detached;
> > +     bool exclusive; /* Are we exclusively locked? */
> > +};
> > +
> >  /*
> >   * Now that all readers have been evicted, mark the VMA as being out o=
f the
> >   * 'exclude readers' state.
> > - *
> > - * Returns true if the VMA is now detached, otherwise false.
> >   */
> > -static bool __must_check __vma_end_exclude_readers(struct vm_area_stru=
ct *vma)
> > +static void __vma_end_exclude_readers(struct vma_exclude_readers_state=
 *ves)
> >  {
> > -     bool detached;
> > +     struct vm_area_struct *vma =3D ves->vma;
> >
> > -     detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG=
,
> > -                                      &vma->vm_refcnt);
> > +     VM_WARN_ON_ONCE(ves->detached);
> > +
> > +     ves->detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS=
_FLAG,
> > +                                           &vma->vm_refcnt);
> >       __vma_lockdep_release_exclusive(vma);
> > -     return detached;
> > +}
> > +
> > +static unsigned int get_target_refcnt(struct vma_exclude_readers_state=
 *ves)
> > +{
> > +     const unsigned int tgt =3D ves->detaching ? 0 : 1;
> > +
> > +     return tgt | VM_REFCNT_EXCLUDE_READERS_FLAG;
> >  }
> >
> >  /*
> > @@ -69,32 +87,29 @@ static bool __must_check __vma_end_exclude_readers(=
struct vm_area_struct *vma)
> >   * Note that this function pairs with vma_refcount_put() which will wa=
ke up this
> >   * thread when it detects that the last reader has released its lock.
> >   *
> > - * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in case=
s where we
> > - * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fata=
l signal
> > - * is permitted to kill it.
> > + * The ves->state parameter ought to be set to TASK_UNINTERRUPTIBLE in=
 cases
> > + * where we wish the thread to sleep uninterruptibly or TASK_KILLABLE =
if a fatal
> > + * signal is permitted to kill it.
> >   *
> > - * The function will return 0 immediately if the VMA is detached, or w=
ait for
> > - * readers and return 1 once they have all exited, leaving the VMA exc=
lusively
> > - * locked.
> > + * The function sets the ves->exclusive parameter to true if readers w=
ere
> > + * excluded, or false if the VMA was detached or an error arose on wai=
t.
> >   *
> > - * If the function returns 1, the caller is required to invoke
> > - * __vma_end_exclude_readers() once the exclusive state is no longer r=
equired.
> > + * If the function indicates an exclusive lock was acquired via ves->e=
xclusive
> > + * the caller is required to invoke __vma_end_exclude_readers() once t=
he
> > + * exclusive state is no longer required.
> >   *
> > - * If state is set to something other than TASK_UNINTERRUPTIBLE, the f=
unction
> > - * may also return -EINTR to indicate a fatal signal was received whil=
e waiting.
> > + * If ves->state is set to something other than TASK_UNINTERRUPTIBLE, =
the
> > + * function may also return -EINTR to indicate a fatal signal was rece=
ived while
> > + * waiting.
>
> It says "may also return..." but now doesn't say anywhere that otherwise
> it's always 0.
>
> >   */
> > -static int __vma_start_exclude_readers(struct vm_area_struct *vma,
> > -             bool detaching, int state)
> > +static int __vma_start_exclude_readers(struct vma_exclude_readers_stat=
e *ves)

