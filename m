Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30164D1118E
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 18:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A916B0093; Wed, 26 Nov 2025 13:06:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41AA46B0096; Wed, 26 Nov 2025 13:06:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308EA6B0099; Wed, 26 Nov 2025 13:06:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 202CD6B0093
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:06:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D147F12FD83
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:06:43 +0000 (UTC)
X-FDA: 84153538686.03.5143D5B
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id EFC3014000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:06:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l43hdfxW;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764180402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAyP+GZjcrXvv4C/l5qvAnbZqTo1yiTRqNA9G7zMJtA=;
	b=gOxU6bzStqSU5prdvrrgGOtRehnJal/1hmGktXv9dBNpTrg+z8RW4ObpaYAcmo94uyCCaX
	ecaMNvkNb9+u9rssR5OahRBQWlMAannT54uffABUnicmvqNu8L6U1S/5uCympqSV+2DmxG
	nhCVeH41JPzGtEc+VR1RRg3tPy5dmzI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l43hdfxW;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764180402; a=rsa-sha256;
	cv=none;
	b=oy5E1ZfknK9caBg2C0jZgrQfjDZpEeO1/vPNwJMp4aw+KsR+5+YSx5JGz7iae8go5aBgOy
	MJ4xQvyeVGRbi1+PlEZeDus5gXUoc5GawvdGG+qZPw2qPsS39nV5hPXZd6G2Q9O22yloR0
	CIWpAAK+2SRcWAbz4hzZ2yuXGrvkNi8=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee243b98caso9421cf.1
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764180401; x=1764785201; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAyP+GZjcrXvv4C/l5qvAnbZqTo1yiTRqNA9G7zMJtA=;
        b=l43hdfxWJn1kItcgIhEXJDtrz4qHdoyeNtIuF4x+iK0+q5NrXSZajsJl6gyYu6yoV5
         foBkNqdxbH+3QEZrsFj/Y+7VSPdz441AkXU23/wJZz88/R8hKGvr/LKax5NJwx/MFwwE
         HwOl5rsolpMlExs7QwfNtB7T3RiVu4SG3hOPEktP4H5iVKQfL4nF+2i4vP4pXON5s81e
         CcZMhJIRfz0lymZNZsmHaljUSrkPdHQHz22Rae3B126RVYq0mXD5mwPfx73T9EMGdNGn
         lQp5JxiUwTAtm5/Y1wV5fTJwtCI34PNVHtLhfL7Obgrgc6RvqfTQlD+VZH3z490e3Ikt
         fMmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764180401; x=1764785201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uAyP+GZjcrXvv4C/l5qvAnbZqTo1yiTRqNA9G7zMJtA=;
        b=s4VITpLhdz/MBpjgM3ER2+nYG5o0nSbXoPQINUl2Rw/dW38F2pwB1adkiDAc2N2eYu
         rUkzF0N8JFfvcQ8QHoTk9ZX/gCWZgjWfBRaebXNBfwDxS9+bv3YKl4xTj/UpnnWsjzIi
         qPBqCcNiGjOQj4p603L1Mz5D0At2X33a8aqb4GTAkOwtVjsTyla2QwT+yl5VKABY8SEn
         3F5k8uEXYSfFEfkUSXZCcSA1NtKt7ce+2lSVLnyoLS1ySw24jlXv5sl+yuwiRhu2mC1u
         jlduGqEbLum9lLIxD1ICYJrrIBNl7gA5VGEjF5F0MjQSLirvkYBWlQWIPo0bVKa4q+Td
         fTUw==
X-Forwarded-Encrypted: i=1; AJvYcCWMLjb2Xvst6xKHNyAF6/b+r42pSHEOJRkCmnP0TM9wvyxGWZ3sMPaUtInZSBgcqyk20l0/xCr34Q==@kvack.org
X-Gm-Message-State: AOJu0YzOHSSiXmkmS/uNaWtypV4tZ6pcT5YBSADjrs/yKHALi02khPdf
	/SINAbaAwPqeFSsNJsi9gmh7I1v2PkbKhcD8sX92cVJ65NyWUVdNjeA6zi29gijhfV1a8MI7rFa
	erGizCatVks6UxqfVzcAfXCKcoXKPTO449QX+/ndE
X-Gm-Gg: ASbGncs1ZHjncTMQPJFpyvC4zyiKhnLhP4P67qv6+b66MG4uGqKvImR+w229wM1tMS6
	pqAuoBkYUE0bwNFjk8Dgx5csw4/sDVoiIB/2YXZnv43f67tmzeR7lWyk23JZ41+q+yO15SS6XO3
	XElffwfSHqKmIJcldmvd/qe+AdeKG1WtDetRqN6YnspBATZMiwbiGYuRTbTJ7kD3mk1+BSERCZn
	FD+eniW0T21/3ZjLsn0R0s2OTeNwL0SCTJH/NEDWdD0/KX4/RhKJLnFbnUG7Oo3BikRC/GNP3AO
	5VjzB98TsAoVDFJg8EuZ98hI8w==
X-Google-Smtp-Source: AGHT+IGUojaoGZQyAGuy5Lmn36LI1SITwBgE9fGL7CwvuZ4lI/DbZ0o5geHZpx6JommLnVU8ybWqaSh8nWSVSkao+wY=
X-Received: by 2002:a05:622a:198e:b0:4b7:9b06:ca9f with SMTP id
 d75a77b69052e-4efd0c63439mr89091cf.2.1764180400572; Wed, 26 Nov 2025 10:06:40
 -0800 (PST)
MIME-Version: 1.0
References: <20251126034404.2264317-1-willy@infradead.org> <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz> <aScXSEY7v7_fcEZF@casper.infradead.org>
 <44f4d9b7-45e3-4d2e-b1df-cab8e254e54e@lucifer.local> <058f5858-f508-40f8-adfe-e5de78621d64@suse.cz>
 <a03aa1c8-b54a-4ac6-82f1-40a06dcd7150@lucifer.local>
In-Reply-To: <a03aa1c8-b54a-4ac6-82f1-40a06dcd7150@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 26 Nov 2025 10:06:28 -0800
X-Gm-Features: AWmQ_bky4yF88jH3J1960H6CySXwKP0MJgycj0K7smDquDXBwBgDB7zXZ-HljnQ
Message-ID: <CAJuCfpFMt6P2cjgb7xfWVz5fhgK67=TQod8HZfJknLYSvZ5EgA@mail.gmail.com>
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fc133ee47cfobayke3o773eibicjuckd
X-Rspam-User: 
X-Rspamd-Queue-Id: EFC3014000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1764180401-917522
X-HE-Meta: U2FsdGVkX19+NDt4nQfopQMgzhTXiAEOE7LdPY4gLv/tqtjpNk3Ttx2+qtGsBk1+yzTAu8/ljH8wqhUnUXIT/ZmwXkohBefgNhhrGZS6bhmuVIurwDNf4igJpvDdWOFWUOlBRRj/IGW0ouexlQ1llvmTjZtzXk5LW2klKjWI+nZDgLG4hqcjVVcNLmL+ZWYcLIllfB86W3y6Ki6imx6zRGm+LyQQ6+npgoWY4/IDwZHPeichnt0h9uQGekfiqjhGd54gus8Hrti0KyIPES7xn/i37qoi+iYEthohciw2sxjIOFZksNsKwH4s82mFBPAH/IOKVeNwRJSEFOMPVwTe40WtpcdG4VUz6VTKsmHp4QKJvw5fvv/xWEgILRldmiyA1Y0BHDyB8R/+cdVVyb87+Lp+JDnrzccQE8+8gXHVm5g7YykvTeJE4a+C14Evse2kEssGhyoroRB5gzl9+/bubpPb9z37+LZ3iUsnaugkUjtwo2WB/Kin0H2uv4zTxj/VGblQrqOiCUufxCftOeIUjc7AMl3nu33+85m+NRiYKsifxX0n9rPL0xGxcUb4o1OpJOMC2VGXvneZvG9M30SJlO8YwB+WQpCqENho72EdqUbFT888Kc9SnpWnZXSbnT5chSICFmAv6qjsEuPvzEIriQvuWIzXIrj8qAHt0WLl2lkUDFEAE5tkja5xRe3k3bkhWz86pcHBdxKd6eOTQ75viuTproNaTxN8WGDQv5HL7+JxKD+h31h2yNEa5dIwqeWTU+9RrNfnPhFQlzgPe52yEv/G233W4VZDtftcOM8ZX/uWef38A9ahMlDxfzfdo0qaFzwRUD6CFhb8AHvwGNGVT9zmWs6JwQ0r57Zhz6fNkKKXq95WSl0OuLRe2h/WV32r87nn6o15XMbq0dtraj6j/d6LD4s10l4Te0RJxOF/SyqtoOG8OQn408AQEcz70sEbUdbIMNq4RMUne5OLR3K
 HrIJ9e2u
 Zml92m8wCwf9FivkHciU76Q3r/hIW4pSuxcax0+cYKiQt4dwzM2x7SwcLxh1Y77iZSR0kAYruWaslWAYwCnJr3GoIkQ5EaPhgtVdItzm7fWi/hEVA3R3Uk9n+WUPpNDdK7rKddAjSm8O3xza6nazbT/lzc7xga8j+XfNFdUkiBIYtPeqDopNqp9PxTSoEVjvw2Jkgx+xuDc0Sezg4ZG7OCJPTIkdpsPGd6e/UJf0k/GHXG1vqNwzR4Yi3r2OnHcmKAaR6vnOsrEkNkzWZ7SKdAWUW//F9Yc6HQVDRP1mFq2mo2QulcHG9hD+vY5RNLqoD57GNXGky2LBYiRpYQZg+//p2muEBnUoPgJJ2ZPsMreYClCY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 8:18=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Nov 26, 2025 at 05:04:09PM +0100, Vlastimil Babka wrote:
> >
> >
> > On 11/26/25 4:20 PM, Lorenzo Stoakes wrote:
> > > On Wed, Nov 26, 2025 at 03:05:44PM +0000, Matthew Wilcox wrote:
> > >> On Wed, Nov 26, 2025 at 03:36:46PM +0100, Vlastimil Babka wrote:
> > >>> On 11/26/25 5:28 AM, Suren Baghdasaryan wrote:
> > >>>>> Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.
> > >>>>
> > >>>> Doh! This is embarassing...
> > >>>
> > >>> Hand-rolled synchronization primitives are wonderful, aren't they?
> > >>
> > >> That's why I liked the original approach of just using rwsems.  I
> > >> mst admit to having not paid attention to this recently so I don't
> > >> know what motivated the change.
> > >>
> > >>>> Wait, why do we consider this as a successful acquisition? The
> > >>>> vm_refcnt is 0, so this is similar situation to an earlier:
> > >>>>
> > >>>> if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> > >>>>         return 0;
> > >>>
> > >>> But this means "vma is not attached" not "we failed to lock it".
> > >>>
> > >>>> IOW, the vma is not referenced, so we failed to lock it. I think t=
he
> > >>>> fix should be:
> > >>>>
> > >>>>         if (err) {
> > >>>> +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->v=
m_refcnt)) {
> > >>>> +                       /* Oh cobblers.  While we got a fatal sign=
al, we
> > >>>> +                        * raced with the last user.  VMA is not r=
eferenced,
> > >>>> +                        * fail to lock it.
> > >>>> +                        */
> > >>>> +                       err =3D 0;
> > >>>
> > >>> Returning 0 in this situation therefore wouldn't be correct.
> > >>>
> > >>> AFAIU since we started with attached vma above, it's not possible t=
hat
> > >>> the refcount_sub_and_test here will drop the refcnt to zero. We cou=
ld
> > >>> just WARN_ON_ONCE() on the result (in a way to make also the
> > >>> __must_check happy) and then can return err below.
> > >>
> > >> But how do we know that we started with an attached VMA?  Maybe the =
VMA
> > >> was in the process of being detached and still has readers?
> > >
> > > So we're talking about:
> > >
> > > vma_mark_deteched()
> > > -> refcount_dec_and_test() [ ref count is zero ]
> > > -> __vma_enter_locked()
> >
> > I think it's refcount is NOT zero to continue with __vma_enter_locked()=
.
>
> Yup sorry, misread the ! clearly...
>
> Which makes a lot more sense when it comes to picking up spurious reader
> refcount increases :)
>
> >
> > > (meanwhile...)
> > >
> > > -> reader attempts to read
> > >   -> optimistic check doesn't successfully find write locked VMA
> > >   -> __refcount_inc_not_zero_limited_acqure() somehow doesn't notice =
0 refcount and increments
> > >     (??? how)
> >
> > That shouldn't be possible, yeah. But per above, it's actually not zero=
.
>
> Yup so this just makes it more likely to happen...
>
> >
> > > (back to vma_mark_attached() -> __vma_enter_locked())
> >
> > Back to _attached()? but it's _detached() above? You mean _detached()
> > right? Just to be sure
>
> Yup, I typed this all a bit too quick...
>
> >
> > > -> refcount_add_not_zero() returns true
> >
> > Ack.
> >
> > > [ process gets fatal signal ]
> > >
> > > -> rcuwait_wait_event() errors out
> > > -> oopsies need to do something, maybe [VM_]WARN_ON() not right?
> >
> > AFAICS from vma_mark_detached() we use the TASK_UNINTERRUPTIBLE variant
> > so this path can't error due to the fatal signal.
>
> Right good point.
>
> I hate that we make this so 'gosh darned' implicit.
>
> We are now assuming that:
>
> 1. the only way that RCU wait can fail is due to pending fatal signal
> 2. and that we're fine here because it's uninterruptible.
>
> I mean very doubtful we'll ever change that but it's still gross.
>
> And as Willy says we're paving the road with good intent^Wlandmines.
>
> >
> > > Correct me if the above is wrong.
>
> Yeah I was wrong thankfully :)
>
> The TASK_UNINTERRUPTIBLE saves us, but it's all still a bit ugh.

I went through different scenaros and I think the race Lorenzo
described would look something like this:

READER             WRITER
//recnt=3D1 (attached, no readers, not write-locked)
vma_start_read()
//vma->vm_lock_seq !=3D mm->mm_lock_seq
                           vma_start_write()
                             __vma_enter_locked(TASK_INTERRUPTIBLE)
                               refcount_add_not_zero(VMA_LOCK_OFFSET)
//refcnt=3D1+VMA_LOCK_OFFSET
                             WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
//vma->vm_lock_seq =3D=3D mm->mm_lock_seq
                             __vma_exit_locked()
                                 refcount_sub_and_test(VMA_LOCK_OFFSET)
//refcnt=3D1
  __refcount_inc_not_zero_limited_acquire()
//refcnt =3D 2
                           vma_mark_detached()
                             if (!refcount_dec_and_test())
//refcnt=3D1
                               __vma_enter_locked(TASK_UNINTERRUPTIBLE)
                                 if (refcount_add_not_zero(VMA_LOCK_OFFSET)=
)
//refcnt=3D1+VMA_LOCK_OFFSET
                                   rcuwait_wait_event(TASK_UNINTERRUPTIBLE)
  if (vma->vm_lock_seq =3D=3D mm->mm_lock_seq)
    vma_refcount_put(vma);
      __refcount_dec_and_test()
//refcnt=3DVMA_LOCK_OFFSET
      rcuwait_wake_up()
                           __vma_exit_locked()
                             refcount_sub_and_test(VMA_LOCK_OFFSET)
//refcnt=3D0 (detached)

This seems to be fine with vma_mark_detached() using
TASK_UNINTERRUPTIBLE. If we decide to change vma_mark_detached() to
use TASK_INTERRUPTIBLE I think we need to handle the possible error
from __vma_enter_locked() inside vma_mark_detached() and allow for the
fact that refcnt can drop to 0 after the wait.


>
> > >
> > > I mean is any of this actually possible...?
> > >
> > > Seems dubious. But I guess right now we assume it _is_ possible. What=
 a mess!
> > >
> > > (Again I wonder why we made our lives so difficult here)
> > >
> > > Anyway even if we are midway through a detach, the detach is ostensib=
ly waiting
> > > for the readers to go away, and our reader is about to go away anyway=
, but the
> > > process has a fatal signal so do we even care?
> >
> > Yeah I guess it's for the best to keep vma_mark_detached() use the
> > TASK_UNINTERRUPTIBLE variant, maybe document why. Aborting the detachin=
g
> > would be counter productive.
> >
> > > I actually wonder if a WARN_ON() is warranted to see if this even eve=
r
> > > happens...
> >
> > Not for this path, but for vma_start_write_killable -> __vma_start_writ=
e
> > -> __vma_enter_locked(... TASK_KILLABLE). I think it still can't
>
> Well if it's impossible for TASK_UNINTERRUPTIBLE no harm in adding it rig=
ht? Can
> add a comment.
>
> > trigger, but since we need to check result of the
> > refcount_sub_and_test() anyway, we might as well WARN_ON it.
>
> Probably it can't no.
>
> >
> > > OK just going to reattach... my head which just exploded from the abo=
ve :P
> > >
> > > Cheers, Lorenzo
> >
> >
>
> Thanks, Lorenzo

