Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6FBCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 14:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1FD88E00E5; Tue, 12 Aug 2025 10:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8238E00B0; Tue, 12 Aug 2025 10:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35068E00E5; Tue, 12 Aug 2025 10:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B49168E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:02:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D1DC823DF
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:02:17 +0000 (UTC)
X-FDA: 83768269914.27.38FE7AC
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2626714000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:02:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ISKeMKwK;
	spf=pass (imf09.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755007335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgHrp6O0mzVGMq4/kwlF2j6V91Xq20REHoK3R4NBnWY=;
	b=Eug7Gi9J+UxKL8hqfm8SRn8uen5vV+fRLWeCCdJUvenSWc7awUPr3Ba+zyVBCl6LWEWmaJ
	msjupzGLTLEr0JVcJH9W+WnvoqD2H70VAhSu8J8vrUe+6Jj5gYrfVxWKL6PczYfTRWk3I/
	ypXbuKQkxWwevWhgZVqg1lbFZTBe3HA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ISKeMKwK;
	spf=pass (imf09.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755007335; a=rsa-sha256;
	cv=none;
	b=f8lixDXKsBQ8nitfUdTXerPUSgRz8AJYF9xw0yyS1WdfgvnsTp5dyE1mYCdHDyXItU/97B
	q4EhDRpPFd4GrMW4ltBTaUqPCmwQ18Nb964qtne9y2Qx8uYr6WhrIryyVhLNADUd4Apmk0
	rlJvynjKnXM8AbC1xKwJGXTmQ8KQ2cM=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-618660b684fso866a12.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755007333; x=1755612133; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgHrp6O0mzVGMq4/kwlF2j6V91Xq20REHoK3R4NBnWY=;
        b=ISKeMKwKej+EfE5wcTO7oltE8nC59M5paanMuMUrI1OtUK69pd6QBGBbU4OSYr9+cc
         maW7ZTVDiAo3lOof6CQqxwdFi0cOJp84hwHV1+e0XYReyBbDpeHqTecNNuSkjC6Kd5fT
         xxT88tWpFGATnQoa1jU/hOHu99ScJz3HqJ1+WsJzruax4qr5kO5ewsNTm2Be3QNpQ7MS
         eUWK5cEJ+SvxZL+h/tqC3Nuq0F86BN5e64uXPi5XNM1xZGrmjq7PWS2/+BBWTXqQ0yIz
         EXfxer5wosVIUGpRNlKU3Hi97gETDQs5ezs9XCcHggn++J3ydLU0HdHrSxsXNnr1tiGD
         tKTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755007333; x=1755612133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bgHrp6O0mzVGMq4/kwlF2j6V91Xq20REHoK3R4NBnWY=;
        b=iCMtcL8Gh8ZMu5hwitSUST2CcgivNwEEuZCRStiztW05KFCBA0EVoj0NSkz8hKYmXw
         hGqLe2uPv+mb/q1mQJK3x6qcMUi8HLMArFdNwhMwkLRqmPAXxwVKmlKBH5wKyFHjWtro
         OQQRSefbx7NrN+M9TV6D2WPWkm5E0RVwhWN7xtu+yKvxsyVMPzgUkvWj/3cCyd644N6H
         ifTYYGkdq0rqWvu8a/RJgjdCXlOLq8kNHQxkU8PbCtfgEnv3W/Q3KnC6Fyw17wWsAeby
         KFzHtKpwiL9Czi4hIX/T0/dEbXVbb5JiZlg4Bs01T3CMWESDFu0zv14dL7j6w/fY/QBT
         73ag==
X-Forwarded-Encrypted: i=1; AJvYcCU+IN+YUQ3WM4eZR0P0N3oo69GhxxDM5BiI8wk5iLYBxv7OWgcnicN2tZ6Fcjqrij9M5HrW3wFNzA==@kvack.org
X-Gm-Message-State: AOJu0YzcubNml6jjUD/KARYrMn1biOlLqUiAIS0xbfqRVNooodGW9yzZ
	JVr2ZmHv+RyhceRHQ8Iyh9C5wvwkFV9j+SJVM0L1qg1EP2rrvMf7Wke0M8ATI5FDObRNOCuYHrx
	1Stky9RHqHBQ7s+EnyCWX6nMo9fpd55fx6TacAXcO
X-Gm-Gg: ASbGnct52b4au0eMyHK+m2aXCiEFYdH2Nle6ck547twIbvWt05e4c9yL1hWyxdy3LEX
	A1yxhzZ7OTl8gSmu5p24pGbWM5e70e7TdSG930hE07fFeeXWPJGkR9DLdjLUx03n3HVXUV3v847
	L/hjvJB8ArQrDVyYWrjppVAAcxg/QgNM3kl8VO68Nfy8qB6ntpMZrJ6F9D72XSAouHRuEVJj/gL
	Tv8z+tpbdt5SWfejy5Wxu22mH7hldp7u/mfkSsy
X-Google-Smtp-Source: AGHT+IGeVXfDi+GOeKEOGwGKfuGKlGjEf7ZPtGH8NAet/PE11DWKQCepuum1A6pr1DfJRUVQTFJrixrJo9wirRpXH3Y=
X-Received: by 2002:aa7:c68f:0:b0:617:e6b2:1fda with SMTP id
 4fb4d7f45d1cf-6184ef93123mr96944a12.0.1755007333014; Tue, 12 Aug 2025
 07:02:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250807103902.2242717-1-lokeshgidra@google.com>
 <aJT7qQzEs_p36yfI@x1.local> <CA+EESO64MOZaJHyY_mTy6Gqvaz=CkPLHgc-UZ1rg8FXcPyh0aA@mail.gmail.com>
 <aJn3Z3q_kZl4Nob2@x1.local>
In-Reply-To: <aJn3Z3q_kZl4Nob2@x1.local>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Tue, 12 Aug 2025 07:01:59 -0700
X-Gm-Features: Ac12FXzRyXJqfak0AaNtuxx8F0LqwDc8XieRTyx4WZgakbpJYqJSaaF7hnoQRlc
Message-ID: <CA+EESO7vtVBUdppuUVTazaK0Aaxy6=FCWX-7YrWvg1Y93oqdOw@mail.gmail.com>
Subject: Re: [PATCH v3] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Peter Xu <peterx@redhat.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 21cnbao@gmail.com, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2626714000D
X-Rspam-User: 
X-Stat-Signature: jm5hdk85wnpejekntqsawpj9cno4gf9e
X-Rspamd-Server: rspam09
X-HE-Tag: 1755007334-826426
X-HE-Meta: U2FsdGVkX1+h1WS6/tQDwmyjEAaKYx2BGOhAVpQzaOALgss2EST/PUwMFHr2cbYdAdMTEpji8xV04XIsAp/R0gghMLz2ftfMxC7jLTbIl8JOIu3oOTP7uy4wGCLjDsc6FDqOBjjqxqn0H2UPYUGcVIheI2js2PZ29mNIVnIVMe6TkPEhfK4pb/UqYrnrAYGShcP+scW6fQNluj4gqpGnFivjbh8T/5XwO+5rO6mXSfzVELOzh8DR9hv0aNAyoQfXkZc8dq3LEIfz+7cH+cbmqro3/tO7z6rfYSuJYg0GZT0pETzudZxU/Nc1Ty913ab+Pr1xw+xZEjUi7FCouXvZxDRje7b/ZSOlU6+inalojwSsSmlD/tWnWmJrsFCbqSnumjyzkD0FdsVvaQWP3G9Ugx2LXg9vYdHoHZBJw3V3MiCEFqj7iim8ryI2pTWJvV4RJDcFNFTAaYYsCKxqvLmb29Vj6lMy7ArdBa5MAi3L9D+rqBSeN82Q6bxfg1sEH+SM+qyl95fjTA5GqQ492oWGfZSkYcblrxK/AH8qt3MFvmx4U/tJ7Mu19yrFhGaYfNgJ4URSgcLQguzNpFhiDNjZ2vdJT8euPA90FOwJvH3Y4j/t1IlI28P0freoR/vWQvv3vTk8IypXkp41o8e4SZaMDI+CBwAI2WZMVg9CG/UC7N8uxYC6x9C3vWJzEXfE0vV7rSynj1vyxy4NMLRxcTYAvXvasHJWJ/7NEq81k3+DjcEE5WQjFBBRrlH40Pn+zciF3YFDBDKEw4tSqSkWdjm9cH/EY7cDYf8eWTxIdTPJC34MNhLgX/a2yl3Ly7SdAAO9Z6Y7g0AQHkjLMCkEyyB1g9731lsG7OTMNIbvcttQtp6zOF66wss6aB911XgYr/9goAtDQuMU9KAiLGBwzvz5iXl9nrOZMXg80R33AxR1e6Za/JlTqS+gHTiDroYV0QXOWALftAdpfWVAeMIfOX+
 imMZwzDo
 LV3el1GxcvoOzsjJ90KoWrzLdNgSZLe6puR5+SPBFUhM8czm0xvC2o9qbm49PfU1LJzwoLdyd8oFrexdzt1FklpzWaY5O231vrMlcpvW3C6PPup2wo6vC6qkwkGavKXFfYchPotxz5yyBCC0aVHpkowxEjRKfy/88q8DNL4K/4nIN4sfyx5MGW78I+Vz3WPp+fyDIVPv9YxuYQXZLjLYGV9ZdnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 7:00=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Aug 08, 2025 at 09:29:58AM -0700, Lokesh Gidra wrote:
> > On Thu, Aug 7, 2025 at 12:17=E2=80=AFPM Peter Xu <peterx@redhat.com> wr=
ote:
> > >
> > > Hi, Lokesh,
> > >
> > > On Thu, Aug 07, 2025 at 03:39:02AM -0700, Lokesh Gidra wrote:
> > > > MOVE ioctl's runtime is dominated by TLB-flush cost, which is requi=
red
> > > > for moving present pages. Mitigate this cost by opportunistically
> > > > batching present contiguous pages for TLB flushing.
> > > >
> > > > Without batching, in our testing on an arm64 Android device with UF=
FD GC,
> > > > which uses MOVE ioctl for compaction, we observed that out of the t=
otal
> > > > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), =
and
> > > > ~20% in vm_normal_folio().
> > > >
> > > > With batching, the proportion of vm_normal_folio() increases to ove=
r
> > > > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > >
> > > Do you know why vm_normal_folio() could be expensive? I still see qui=
te
> > > some other things this path needs to do.
> > >
> > Let's discuss this in Andrew's reply thread.
>
> Sorry to get back to this late.  Thanks for the link, Andrew!
>
> >
> > > > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > > > includes TLB-flush overhead.
> > >
> > > Indeed this should already prove the optimization, I'm just curious w=
hether
> > > you've run some benchmark on the GC app to show the real world benefi=
t.
> > >
> > I did! The same benchmark through which I gathered these numbers, when
> > run on cuttlefish (qemu android instance on x86_64), the completion
> > time of the benchmark went down from ~45mins to ~20mins. The benchmark
> > is very GC intensive and the overhead of IPI on vCPUs seems to be
> > enormous leading to this drastic improvement.
> >
> > In another instance, system_server, one of the most critical system
> > processes on android, saw over 50% reduction in GC compaction time on
> > an arm64 android device.
>
> Would you mind add some of these numbers into the commit message when you
> repost?

I can certainly do that in v5. But I already sent v4 addressing all
your other feedback. I'll incorporate these numbers as well as any
additional changes suggested in v4 in v5.
>
> Thanks,
>
> --
> Peter Xu
>

