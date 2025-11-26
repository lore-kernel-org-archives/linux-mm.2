Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 553D6D11181
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 15:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3A36B000D; Wed, 26 Nov 2025 10:49:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAAA76B0026; Wed, 26 Nov 2025 10:49:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999B06B0027; Wed, 26 Nov 2025 10:49:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 881646B000D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:49:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42C6C1316D7
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:49:28 +0000 (UTC)
X-FDA: 84153192816.09.F377B40
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6A460C000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:49:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=arjNVP08;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764172166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BhCjfH8cWPyC7teJNjHJ9dg6IpRmGELhc4NFn7lNjCM=;
	b=PTgvp2aYl/WTrZQmgQ++64N8MauPyFROGjAV8AfmggINFX5jqinAmDT8QRUXwjEhg2k62L
	eEVzVDOmSb/LyiuW7Qu0t31lUx1lNdKi7erhPVhgbbE7HggGb/Og7yB9pJbDh7VUhnF/sB
	0F44Iuh5a1FzvhKMlS+yLExJ2lxp9zg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764172166; a=rsa-sha256;
	cv=none;
	b=Tnt4Y8ME5gqpfC0dAQAuSEtO4qI99ONviUz11a1ZGXZFxIf6hCbxDIPPbosKM3Xhcp999I
	taacMgjQBPK0JTkO2QfNSntFxW3Nymq9Jzl43qykLyD/hfpiCHTJoucMCnxulxWy2/9Wa3
	g+UK3NKv6Qvx2sfHZ71oYG3uWArsFKM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=arjNVP08;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4edb8d6e98aso426711cf.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 07:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764172165; x=1764776965; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BhCjfH8cWPyC7teJNjHJ9dg6IpRmGELhc4NFn7lNjCM=;
        b=arjNVP08tN62V2VMol6XGMJtRpYnoT5UQA2ZQnuGQUAdv0LEjzWhVc96+b3px8m6/s
         hzqVJcZvLfz/iHMnHNgVJi7KW93tg9+CyMKyELePlyQvOxjoH9HoiJ6+cmeOn8kAq/n6
         3f5adgPVHh7DbnaNj7w0Nrm+yo2AoqiGMmq5c6VfScSML9cx4Avm9juxI19b+tTZCbq0
         4jrEmbV3WnBAI2XIgWgXKdRV2Vc8ybR+UjFp/gzt4ifkyq3SAtsvyVxveVZKlS/wHIsb
         Q+JOe4GxtrIy+521CU7/wyam/dW+XHCRVub0tSELnHMc+lJQz+C6KsbSfa0cjTeEJJKM
         E9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764172165; x=1764776965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BhCjfH8cWPyC7teJNjHJ9dg6IpRmGELhc4NFn7lNjCM=;
        b=luYuregHbkMGjUs7IEm6Xz9r7NcbAD/zVh4mNY6K0gFskXRqS2zzMTGY8e6zM3cAoZ
         tAoETpfCsi2m3hn5lPdZI6jyKTXTCPFfapAnMLdahsGAj4D6B+q0UwGFjk5ffL9IktiO
         i5ItQGntoNZbmG/3LiFlTzEyWmvN5zKtrD3ta5eJGtRaHuKGtYULVCANlaTldsEdzZaa
         y1EjXmlZihT0rEN2Xs7VZq5AZlO5Cp/NrizE4NUiBIVmJqkU9UApdqqIMVev0q8Z1xqd
         X7fgUjePmXFJqpw09IlREe0SnjH3Tf5er/J1hHJYZXpdeJt4/bi7qdrHj+8crZ4hAU4V
         H1hw==
X-Forwarded-Encrypted: i=1; AJvYcCXvS2DWKtkpTOo5u81ZHOIvk21zQ1h6U1tpq4ys6Ic0JW1hTfCPqrfefw0KMc2+pk5mQu5CfQpG4Q==@kvack.org
X-Gm-Message-State: AOJu0YzdvLa9lvD35ZHPb6+7mpvkPI+kfcPXUbNkaI2jpgS63no7yMFq
	m5XjEwyheQ8a9+GBBdn6g4CjZjJBwIdiGr05DVrpf8wSKxqu1VDMPLqzpYX3jLzK2vv00qsCSfi
	TAt2WM/JxFY/dvBpgnj1btRntTaQwQbGvGMy6hjKf
X-Gm-Gg: ASbGnct/SCwaEfV7uamWGBSmNXbX6U72mAIiRGYDVE9yKPP9uJDWBzb03431PrDVybD
	JdkFjeCUeowCK4XslNrAj4iJ961u4f45Qo3SCBkjnqANK80n/7MR6aDH8N12Lm22DdDNF2w8Zia
	K7VADjBb674oow6c1HuxGIMc96IMJKyp6CthKaAcSb88u6J8f8/lnEpqCsYPkIz8Gj9wbFYs8mV
	r5fSjqmozI1KLPqSy11QDKTr5b9PhkfW16wOJzaXLK14pP5i/c7OwOufvUoqBTqbQ1QB0zDQVga
	wnb6T6i5fR8aoiXeebUzvL7kQg==
X-Google-Smtp-Source: AGHT+IFb1OY2heNQaSmOtaCQNHNRqzXwrjG20ibk3G7WbPXLnM4lZgpMN1ZXmquwDmy8vmbLArc9azVwRrObCbRFQwM=
X-Received: by 2002:ac8:7e96:0:b0:4ed:b341:745f with SMTP id
 d75a77b69052e-4efc67e266fmr5295011cf.0.1764172165007; Wed, 26 Nov 2025
 07:49:25 -0800 (PST)
MIME-Version: 1.0
References: <20251126034404.2264317-1-willy@infradead.org> <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz> <aScXSEY7v7_fcEZF@casper.infradead.org>
 <44f4d9b7-45e3-4d2e-b1df-cab8e254e54e@lucifer.local>
In-Reply-To: <44f4d9b7-45e3-4d2e-b1df-cab8e254e54e@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 26 Nov 2025 07:49:13 -0800
X-Gm-Features: AWmQ_blE6gImdEwtMJO2JU2lSnNSOmZg8nujoTU02M3CkiZo59GpJ1eTWeLpnBk
Message-ID: <CAJuCfpExY2wYk=TuWEGGgyh3YOJyi2+4sPVd4XfNb7kZeRr2Rw@mail.gmail.com>
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6A460C000A
X-Stat-Signature: 489twyedzw76myjy4ik9jk9bbt45ohiz
X-Rspam-User: 
X-HE-Tag: 1764172166-310787
X-HE-Meta: U2FsdGVkX195dx2KUtT4WTmlNqAzSkxTRP6q9LGF7yoTbZjQXZZXWmAxb0fc9qgjsNK18puu37nSeF2XOLSbAk0e1RxbJX+P9IXlb3DTJIy/tOPqAJ3iwsk8Nw1RpSfA72HGtWMIADdM8MRtJTOdmdbC27xs8OsOeOEWVZyvqI0U+P5Ni9T8HKWo0TgkYdpTPiv8fz9NGo2et2iqbVRO6b3vhzMjMgn8xUpPUX6jjsEKm8WYSwxpsKf3OY+jr7lIBIbO9+qjlVI8YIt6y8dnazcahFocDbZwLIizunwB3VH2iNcfDP4XdCAyJ+/fTH4MhlpV1ZuUjatcduL39rAo8DLeyysZ4jgUeeP4WvP4tO9NQolKA48wAfOTq1Cd6S547pFQ/F/47Iil81EmqDNDPBWRZ15H9IOSUAJe0ZcTll0dEhoP2ryzAw6sClMF8FhY5XZAoMMkSF+bA64pHYbwG+L1dG5xOMkw39tYOh2onMDaxDZoF5eYxdkg50HU0doktt97mz0wzD0aMZvDpRM8yAZH/Y+72YkPDzx2n6bzOg3Rls3wrt1BzunV0g/Kl9MQjeA+iIeeTrh3HhoTJeU3T7PHAN4F9n6mKEkr8LGjJZD7k0SSQxhbjRcvY5iVPopwCmgWCc4PBdz1SP2xpFeoMq3/rvhAK4pFtGjTnRkQk3aZE/fQ1vuwRZJlGqCWStiGzDV9vkNrb34/I0YohSs97Z3NJUV1iHSeZItvKlXatWTX+lScnNdkk30/l/X+hx2vn4qNjva+q0sugl43ieCbgb80FOnbg7pd7lfUBx3gXTnDmVanZvCNxzPVlLIo505gvmyV/Ecm9MsLVgITUqkDCcsXmwrmUCommo+VGxTNcK6rvY2nje48gUgP8A2unm04qxYdPRra/EW5orzieL92WgmoK0CeZdh4kz22M6MPJGndlCcyYO3zVfrtkIH27O+eZJw0Gt9Eg19A8RPBnXo
 jyd9BX0q
 NcZPJzbs9CjWn5DrIUyANj5lB7MGaYt2dRcLe53iTH6Y7wGYtCTvA8Jwhed5qmlNvxgDLUuFxzV3lGXqz8eqWY3JQEtmc88yu8PcCjMyDo7kK2RcIXCbQzbzs0H4JGJEyqhPNT7rMH9Vkder2Iw+osYDso2LkVVofAdHsrVnivP8punHVGoCJqhKLnOlvSD8PBed0ViQ2yxRVR31MtFxVnR9IblTROvK8wCtVqNwiJaMTOVqUrAbgC6rxTeiqo5OyLnVxyrJ5MGuVqF91vup+Qh6oar6sUqDdUqaMu8vc/yjsxBtZBdcL8uxen8/xMBHXPoE/eeHqqe+clKKAnqs3zFOw94TynQZHwfXfvBFsfmvBBRUjACuSymKQ1lklZLPBXGR4VnImHGA7sZeycAe+KECYT6hGfLghaH4N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 7:20=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Nov 26, 2025 at 03:05:44PM +0000, Matthew Wilcox wrote:
> > On Wed, Nov 26, 2025 at 03:36:46PM +0100, Vlastimil Babka wrote:
> > > On 11/26/25 5:28 AM, Suren Baghdasaryan wrote:
> > > >> Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.
> > > >
> > > > Doh! This is embarassing...
> > >
> > > Hand-rolled synchronization primitives are wonderful, aren't they?
> >
> > That's why I liked the original approach of just using rwsems.  I
> > mst admit to having not paid attention to this recently so I don't
> > know what motivated the change.

That made it simpler to add SLAB_TYPESAFE_BY_RCU for vm_area_structs
which improved the performance of allocating these structs during
calls like mmap and fork.

> >
> > > > Wait, why do we consider this as a successful acquisition? The
> > > > vm_refcnt is 0, so this is similar situation to an earlier:
> > > >
> > > > if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> > > >         return 0;
> > >
> > > But this means "vma is not attached" not "we failed to lock it".
> > >
> > > > IOW, the vma is not referenced, so we failed to lock it. I think th=
e
> > > > fix should be:
> > > >
> > > >         if (err) {
> > > > +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm=
_refcnt)) {
> > > > +                       /* Oh cobblers.  While we got a fatal signa=
l, we
> > > > +                        * raced with the last user.  VMA is not re=
ferenced,
> > > > +                        * fail to lock it.
> > > > +                        */
> > > > +                       err =3D 0;
> > >
> > > Returning 0 in this situation therefore wouldn't be correct.
> > >
> > > AFAIU since we started with attached vma above, it's not possible tha=
t
> > > the refcount_sub_and_test here will drop the refcnt to zero. We could
> > > just WARN_ON_ONCE() on the result (in a way to make also the
> > > __must_check happy) and then can return err below.
> >
> > But how do we know that we started with an attached VMA?  Maybe the VMA
> > was in the process of being detached and still has readers?
>
> So we're talking about:
>
> vma_mark_deteched()
> -> refcount_dec_and_test() [ ref count is zero ]
> -> __vma_enter_locked()
>
> (meanwhile...)
>
> -> reader attempts to read
>   -> optimistic check doesn't successfully find write locked VMA
>   -> __refcount_inc_not_zero_limited_acqure() somehow doesn't notice 0 re=
fcount and increments
>     (??? how)
>
> (back to vma_mark_attached() -> __vma_enter_locked())
>
> -> refcount_add_not_zero() returns true
>
> [ process gets fatal signal ]
>
> -> rcuwait_wait_event() errors out
> -> oopsies need to do something, maybe [VM_]WARN_ON() not right?
>
> Correct me if the above is wrong.
>
> I mean is any of this actually possible...?
>
> Seems dubious. But I guess right now we assume it _is_ possible. What a m=
ess!
>
> (Again I wonder why we made our lives so difficult here)
>
> Anyway even if we are midway through a detach, the detach is ostensibly w=
aiting
> for the readers to go away, and our reader is about to go away anyway, bu=
t the
> process has a fatal signal so do we even care?
>
> I actually wonder if a WARN_ON() is warranted to see if this even ever
> happens...
>
> OK just going to reattach... my head which just exploded from the above :=
P

We are overthinking this. Vlastimil is right. If we entered with an
attached VMA (which is the case due to this check:
https://elixir.bootlin.com/linux/v6.18-rc7/source/mm/mmap_lock.c#L60)
then the only function that can detach the VMA from under us is
vma_mark_detached() but that function can't race with
__vma_enter_locked() because both functions are required to hold
mmap_write_lock. vma_mark_detached() has an explicit
vma_assert_write_locked(vma) check (which implies mmap_write_lock) and
vma_start_write() calls __is_vma_write_locked() which does
mmap_assert_write_locked(vma->vm_mm). We can add a comment here or an
mmap_assert_write_locked(vma->vm_mm); at the beginning of the
__vma_enter_locked() to make that obvious.

> Cheers, Lorenzo

