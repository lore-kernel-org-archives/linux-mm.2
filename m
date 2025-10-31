Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E81ACCF9FE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 23:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B3A8E0098; Fri, 31 Oct 2025 19:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCAAE8E0068; Fri, 31 Oct 2025 19:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA6D8E0098; Fri, 31 Oct 2025 19:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A50188E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:13:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B16B1A0663
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 23:13:05 +0000 (UTC)
X-FDA: 84059961930.14.2ADA7EC
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6419740006
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 23:13:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t5XTkVeW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761952383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gY82JgAv1A8rYj9MCaiZVHVrEMWrbrCoiDwppP0oGWg=;
	b=KcMv46VY6gAVEoBM3pegMNXFM/YDxkZHbk3XkMyIN9QahqVsBlX4k/3O+mqrWdru0poSSu
	G6QRuXMGWJ3NpgTE2v1JDCdpLJkEnJHOKimpzVH+XsL6YBp3sHclPi311E7RW/+SkYcph0
	YbBHhzGqzN+mVfgBQr1o4H/M46toq4U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t5XTkVeW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761952383; a=rsa-sha256;
	cv=none;
	b=699iDDp9aD34py7IKwZ8HQzIKtyp9WaLrdLdp2wTujVg/5SXBeviEVelooQt81nVx8iXsE
	SRy84WUgDNayzNi673qCN9lk1c6jPDVyW4b5ykC66csa5v+C3ZTA9Aw8FWj/LKhTSHbp+V
	0vqyRxEIYF2fmxRU0XKv/i/nCGGsEZY=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ea12242d2eso82051cf.1
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761952382; x=1762557182; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gY82JgAv1A8rYj9MCaiZVHVrEMWrbrCoiDwppP0oGWg=;
        b=t5XTkVeW+o6OWiZ4NdDzsjF96UDdY0LyenFhp671Pf18uMAI1Gojzz/r5vyWYgE4b6
         bcRFEnbbBMIqAgiopLqP3n7a0FO7v1ZsRfWTZroaq8oXLlfV2qyxbYdrOoxSNE+b6fAP
         kB2hGTX30OBVciJUN8Wed9aR5WqrrURXZ8B8PKGLmTD1LXVSgryxXJrm7WJKGKkFGAQb
         EFO3I2oVdo6Yp24/OMdSl89c1t0lGza/qvCx5f/ao+GnM2tATDATO8yxnz96eFZBs1hd
         poAsbLnev/gLSZBWK327B47VCmMROy/5SBAWFOzpDjqpmZNkIC87wRPCygdH9TEolmU6
         yzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761952382; x=1762557182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gY82JgAv1A8rYj9MCaiZVHVrEMWrbrCoiDwppP0oGWg=;
        b=kz67Ic5AHTzCqG8hIHBTOEzjIEqg6KrVbE24Uoe7djwsRvIVEyATw4DzOlNKlM3VH0
         n2N0LOh8x3NNuramnQQGWqYnL7XDiewgQZ21xrM/0ZkGhxxIthH7wpv/5sos7G/VNU/p
         MLQlsds5qVljQDvbl6nQq57mG5M2ZkVi6jmSUuSudPc+Q3PGObqdl+g92isoLL1HVWsM
         KkCzNsO9lSROrrWSG8hg95jqvl7MaAPjI6atKd7w8CELuQegpljgfzTZekduo1bf4/bM
         SQWqLpDzZMnHoBK11zbxjZsC3lKkPzvZLOM6SkwQZrxprabSOcOjs+dmPPhErO5NoYKb
         R5Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWUFDUJXOGC8mnBddBm5UH6qyonc8jQ8BXeb0jvb2o+HKrSxgay89zoSoxRnQPDQIyyuG7B3sRHSw==@kvack.org
X-Gm-Message-State: AOJu0Yypy0Qjo2A95QJPYZNnfKY75vAYmCaJmTjAexSyX6KeKE0BTW7Y
	5RShUWInVwllThRHduHFca8B0HOqd72QE4M2S6g8RxEo1E1e/OemYnTuIAsd+HWKk2ISH8+lSbg
	Yds84v10pJFA73BVmSB9R1kNsq2VyMyXHwVdCJm/N
X-Gm-Gg: ASbGncsX9yWK9LWpUHMOHVmGe0OVlxmg1Zbvz5ZEMPyh3kByYAcBtJ2A+nxpfTGQQnC
	XPRHGT0z/iTvtWx6OlQobJtroxGOyu79+ChUz4fTeyb/nuseuE7j2Y7eD6uusqqOdMg9blI4PGi
	O03sFRIok++cXgQf1gyRgXjf7+uZML9Eh8EdRq/fjjMbNfznzms9C73CKyhkmAcSbSNuNR8w/Gx
	/JpD3xHCwsSrWv/ACTgDwYoKCSPTUEcDx9raBWvFVztNXlC9lWyQaUmv6I=
X-Google-Smtp-Source: AGHT+IENbX2I9QLWCzbGqCz+aeN8c925eFyi708BVOjF22TIfxJHEaH3VCvZrnHqn6i5au9Z3HH9DEYcpuxXzSR6lhg=
X-Received: by 2002:a05:622a:1991:b0:4b3:1617:e617 with SMTP id
 d75a77b69052e-4ed424d7c14mr1098221cf.11.1761952382100; Fri, 31 Oct 2025
 16:13:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1761756437.git.lorenzo.stoakes@oracle.com>
 <7de40603015dee82970f5d37332a6d5af7532063.1761756437.git.lorenzo.stoakes@oracle.com>
 <xnsn5rfqigbm5ryjtbf2rtfotneiwygzesvyfdxiqrzlyzljdr@tmbht4ggnjcv>
 <61ae955e-310d-488e-b350-59bb809f06e1@lucifer.local> <c736tssdw3z57kamh6eqc23gr575q375n2o2nnszih64afnaf7@zwbqremsbhwf>
 <053f3a04-9195-4f8d-8959-42e0c3ba077b@lucifer.local> <72ee2324-d599-44b6-92ce-ed0afafed78f@suse.cz>
 <3ae457cd-6c18-4870-a617-7f937b107cb4@suse.cz> <88b72728-fa3f-4a70-9ea2-40ff50673047@lucifer.local>
 <a3bcac19-78b7-4918-81b3-641a65a19a9d@suse.cz>
In-Reply-To: <a3bcac19-78b7-4918-81b3-641a65a19a9d@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 31 Oct 2025 16:12:51 -0700
X-Gm-Features: AWmQ_bnVgpHA3Q0hYHvJgIIm_FpBFlpB9mdVzh6mL8zZeBp2jS4PiSvnDoBUG6c
Message-ID: <CAJuCfpEs1JTywfZNPrVmeTHUUyK+7waCU9fqfur2Q_xxx7hacw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: introduce VM_MAYBE_GUARD and make visible for
 guard regions
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	David Hildenbrand <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Andrei Vagin <avagin@gmail.com>, Barry Song <21cnbao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 6419740006
X-Rspamd-Server: rspam03
X-Stat-Signature: qrf3irwsg64ngz1n9ziw7r1fwbhu9st5
X-HE-Tag: 1761952383-507373
X-HE-Meta: U2FsdGVkX1+ffy89MnQQv2lMHSjSEZttmZ8emHWIhiK5lgDsSsdsiSD56k2kw+llQUGUErol0wPwLvZ6EV+HACIosuDE6yyj0rJjTcc6rDKFOhr/u0V/O5M/wyhnXoudTNWHnmJdMKIIQuXBuPojl4A2xDXgTzcqzAXqSEH0IFQB0Y4CwVwB2RqQPSfEh6VhinQrzvSJYhdYSa5qe2/ze+6m8yK1zhK2odFsp2aIyw+yvUizGqqoWTQnEaf1wTlijK8ZQzY39CvSiz2/Yz8LNuys0iZ33wd9VHy8daa0RA3DYb4yYGsYMG+SkzMDPKXTw+KVUFFOS4MKmp5Q1jjJn3vR+PwQ858/+M4/ZfQUisnms1fSXPPBDn20iLuCcaubx/fXfPQHPdl3bsITEY9Nd9FJlHt6WhwXfJRmNBxkMZG1IyVklQTbgGIGGJB/njAdLuA1ZCEgu8E1+wpn8dL1wz26/lFU+keOE4TdQQGtYhUwiAmqDQkDubmLSxwCCUvQcweXqQ4tak6WN/6hbAFm2wobaVc9ugqajTqsP2JsaIhrRUEA1H9sXUuO8W0Y4Hgvz0XP+2H7Sw29EOUIZrxg5NrOoE5s17gA7tUwsUeAm0nfoZQh92E7VbMdfRnPchYrMWMCBnrjbIobHk30SFk5NATWRDolFz+Xl/NoC5ddd8RVnZ5DSblX+xJ6RwGVyohCWqnOzWI++VO9uTIzheF2PtdKj9Bw6/vQZYH/eoanORWkvIS6Ov+ACnzSqmL50mNx32lPSbqKQbz3tKZI6Xmpu0x4KT0E0ak6g/2oXLKuGLTnPAnTuMs//qtIxqk7+yveWOtb3x6r1oIHSAXxVf5UHNOqnRoa6u1FCFwOcHbpuOyiR/WX0N3T0t8OWIB9kd7xqXkQUuz2x2gYQL3DHqS9OWYAfpxYwAWROVy5csxL03ZUJ+62KmefqK6L2utN/96FyENyuCZV8Yxsu/6mKh1
 0QK6J9te
 jYDRyYMaKoHBKmp8mSnHaqVwgPNGTXCHlOm1y/D6Qz2kwstXpvhrU/DWtADvY38eqAfEn/+rmOgX0WPA8RntduEjvH/GD4vUMx+SWV4o31qAcJWQbAV8mJ1muVIHhkJrGslusgVk9Zv8EpTXKy60/CCRqVWj2DDtefuYoPd8vvvs73vGZeRcQ5zpNDp8qL0baW19C0OJ+FmAj7zg8V4jyMFa3cu2lcOF39uj8npbXQOWOtaxc/LUErapJhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 2:48=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 10/30/25 20:47, Lorenzo Stoakes wrote:
> > On Thu, Oct 30, 2025 at 07:47:34PM +0100, Vlastimil Babka wrote:
> >> >
> >> > Could we use MADVISE_VMA_READ_LOCK mode (would be actually an improv=
ement
> >> > over the current MADVISE_MMAP_READ_LOCK), together with the atomic f=
lag
> >> > setting? I think the places that could race with us to cause RMW use=
 vma
> >> > write lock so that would be excluded. Fork AFAICS unfortunately does=
n't (for
> >> > the oldmm) and it probably would't make sense to start doing it. May=
be we
> >> > could think of something to deal with this special case...
> >>
> >> During discussion with Pedro off-list I realized fork takes mmap lock =
for
> >> write on the old mm, so if we kept taking mmap sem for read, then vma =
lock
> >> for read in addition (which should be cheap enough, also we'd only nee=
d it
> >> in case VM_MAYBE_GUARD is not yet set), and set the flag atomicaly, pe=
rhaps
> >> that would cover all non-bening races?
> >>
> >>
> >
> > We take VMA write lock in dup_mmap() on each mpnt (old VMA).
>
> Ah yes I thought it was the new one.
>
> > We take the VMA write lock (vma_start_write()) for each mpnt.
> >
> > We then vm_area_dup() the mpnt to the new VMA before calling:
> >
> > copy_page_range()
> > -> vma_needs_copy()
> >
> > Which is where the check is done.
> >
> > So we are holding the VMA write lock, so a VMA read lock should suffice=
 no?
>
> Yeah, even better!
>
> > For belts + braces we could atomically read the flag in vma_needs_copy(=
),
> > though note it's intended VM_COPY_ON_FORK could have more than one flag=
.
> >
> > We could drop that for now and be explicit.
>
> Great!

Overall, I think it should be possible to set this flag atomically
under VMA read-lock. However, if you introduce new vm_flags
manipulation functions, please make sure they can't be used for other
vm_flags. In Android I've seen several "interesting" attempts to
update vm_flags under a read-lock (specifically in the page-fault
path) and had to explain why that's a bad idea.

