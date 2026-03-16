Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36BA8F013E6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 08:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F4B6B0165; Mon, 16 Mar 2026 04:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625CF6B0166; Mon, 16 Mar 2026 04:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531996B0167; Mon, 16 Mar 2026 04:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40DD66B0165
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:52:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEC63C017E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:52:56 +0000 (UTC)
X-FDA: 84551311152.29.225C8F8
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 063DC20007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:52:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="DTVfgl/n";
	spf=pass (imf13.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773651175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQaSu+BjQS/9yOvHvEB6hQChFTLVczOI9UX4qDJfUaQ=;
	b=B+KFFotehIRycirAzgMVu2+Dix6uvrwqYCFUNdmu+7M9NMynVVCd2VXI0grFa9Ajyilw9A
	rKpMexK2PRuzVkkQCUnl4gJYHt4TyCNFutxE/VOYEIuZbAyjBIzEqwrimdJwLuDX5dIaMh
	1+c3RJ8ky7CcxNDS8sLzhKFzEWweq4E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773651175; a=rsa-sha256;
	cv=pass;
	b=I59gVhR9zK+ESxpgamW6duZdSQcxb7ynEJ0N5zdeg+W2/tP+QqyjspYBGXOEmqqCsvknnn
	EgcVErZH0pDIryu5zOXbhz3NeDTxX75AKvJ4n7K4m1VQT9IFjwyHJw2kYPLIg+z3+lWflr
	YJDMyhtLxbPJBaXEAxK+4GrdDX+H8KQ=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="DTVfgl/n";
	spf=pass (imf13.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-79a535e7c00so4351627b3.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 01:52:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773651174; cv=none;
        d=google.com; s=arc-20240605;
        b=Kw+Fd/zpu3TtqOWcEmsPdULgoyNsOeIuvzOaoxxxQQbwqF91n4hPmP0uKk12ahtpA/
         qLWQzRizA1+xdc3MqVmNtaO9vYoUjGBv9ulv2NQCK6hFb26PdszkPOFAFOQVikzzm3ow
         uYvfDQOqx4Pm006zaaLpmCWUClxVWAvkGUpKvSjSpQCj3ysK7MuieeiwWN8BKcNMxXID
         k3YJieV8QoBvbgcFFbjpJQ+7MRkp6ODBVlcRI2BvlDLelYyN7e6qTWGYLd7oOwe8ihCI
         kt/KPPeIaB1t/2VY5G4pU7UUsmVK8eYF3Urd+fhBA48d2upu2IjkrwBceEPW3BzHiyu6
         0tyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zQaSu+BjQS/9yOvHvEB6hQChFTLVczOI9UX4qDJfUaQ=;
        fh=Jt/DOvo8LcMJl5LB9Mw+pqPT06grHi1pD0jpAaoNsfk=;
        b=BJKzqoifKRQxVBA0wNf3QtJPQrcoikCWGwTP5UPbXPIllgYLzlXnpu4wZYGWNLY91W
         HEYU2EDV0O5z/3NG95wsr68Qsedmmtima+RorIcpTNlprfbu6HCypu6LEb/ksfNsnOeD
         8ca8myxXEU+bbjpE/uATkbfDPsQgJ6mItqiTHMbGqhOxRbrKCDLIAGbCOEne2HVMQAe3
         sQZS5iPuaPy1JkIPD+nXlOFREbBVQRZnNNBlP4rS3COXK9AZ6faWCYuBzQXHVBpBk9XK
         vrZyejp/dKUlu/EwXwdIv/fuQokmOHY/WAfhWXs3cVe+HAoSBlou713hjpxC4NOInXzX
         4HbQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773651174; x=1774255974; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zQaSu+BjQS/9yOvHvEB6hQChFTLVczOI9UX4qDJfUaQ=;
        b=DTVfgl/n406+ZF9xRovJIr9E+HuVzlK0936kQRyJjpYgECvBetswKAs3+HvIL0JquA
         H33bKGMqkeCCYc+0vw7FvkttBovBQ9KtnpyvZLGO4owBl++lE20PRlOmqGFhIwWN/pHf
         sfalvkpSbw5WjVP9mTNzUKWZvfV+yhQOPKkSPg3259Qu6e4fNdgk6LJDriOwUUZyxq+P
         VCbnzJxUdthfRKL2O6zVdyECSo9FYmRoDunxGmtQSRQ3t3xObwG2jQQWR0YAhmgk08nP
         2sadZn+TMadI/iEkxTfMKtzyQKew0imgczUi8bsEu5Ufp3PGxFZe7RB7YQEPRt+hafry
         O/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773651174; x=1774255974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zQaSu+BjQS/9yOvHvEB6hQChFTLVczOI9UX4qDJfUaQ=;
        b=sfccwIj/V9QDdAarGsK3Ab1NBkj8CVNz3HfhWDxKuAAS511rUZJFQIvRHvfjjRE0S6
         eJJ2QwpF5o+eMRTWjypT7cNZEd6EawlvFwYbUHTrc63vUAVC7vADuBJU+8CsnwvkVLfZ
         t9GgPMliYmuIc9bnFnSvA7/Vj+0exDbHmDW1GIBvN9/0G6W/DZEh/MMMjUnXPuHZ/Hm8
         fMX9FnHa/Vh0xx2jm0x8MT2/Lv+5l/OwnSnYOzsBXqYFP194mD1Wn9ygNNn9XUBcAY73
         YXH4GYoHuLeudgk+dqZ4FCgGZbI7NvvvU0gEsRG5fJMil8Bo4c+MwutGkHQLHOrxq0CB
         qylQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqJO5U3I95Q591Dq2Q0Iq9O+6LO7TqyBH1NC5ZL4qtGjkJmwBzRavVlvXWAbjq+icutWFSfgeT1w==@kvack.org
X-Gm-Message-State: AOJu0YxJ7+ntAG7+6pdvI6KN6K7OcbwtZikm7cnHERyVXdMDz7ImHRVQ
	qmvh0n3WU3LJmY5rA1GM00QoIH60fbPALm+VPx+GdjE0ydN/LOKOEtSwXsip9sSWXraQtoPegcK
	gMLPWDowGqD3gfKZYr75ko0SwY6r8j4w=
X-Gm-Gg: ATEYQzxya438zouJx5P+F6wCyIR8WUXst9a1t8X5O4Iiv0YP/PNsmaElqB+ESNlZzFI
	DPIVCwoly556HNCkWe79JFRz6hyJDLgXNIpry1esVgqtQJ4NAGSnSpHCy1fz0LK6sYiGstGjMJs
	7aY/ELlplBwvvxtKUiiDDiwFeJozuoXZP1xKa70/shCrPtdAdb8PjsrZ2Hl8pJ8RT1XiyJGgmxY
	Z7xJf9n1//40h21iZUjqwJp1mr/eFfSx3XWT1hE6mgLfS2GiuuuPo1bmYyjMQ7kIZSBKi5LQo6S
	MoihvsUF7B2Mqusv37NW5ztgfwLufjzHBX40My7NXeurjLOZCffRlsXPpRM+4djKWIbx/lY5hKo
	DGSHWQ8w=
X-Received: by 2002:a05:690c:13:b0:798:6756:31cd with SMTP id
 00721157ae682-79a1c1dd661mr125880507b3.53.1773651174047; Mon, 16 Mar 2026
 01:52:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260306171815.3160826-5-rppt@kernel.org> <abe1FHyYinvfLYnw@hyeyoo>
 <abe15T7cA1B9lG4F@hyeyoo> <CADhLXY5ydBZL5gUQZCJnSTgc=8U0Xhaj_BtvgdBtPSmWh3NTEA@mail.gmail.com>
 <abfA-AR--cvpcz5v@hyeyoo>
In-Reply-To: <abfA-AR--cvpcz5v@hyeyoo>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 16 Mar 2026 14:22:43 +0530
X-Gm-Features: AaiRm518IFBKe3PCGNQ5k_DQwitYZlzdh5gs0YPek1tk1O9KIu8wqr_ZBBDSHBM
Message-ID: <CADhLXY5h4fNVXbxP7ZU3Jq+Yjwtm8t9mkSyRC-uOwRvSdQYJ7A@mail.gmail.com>
Subject: Re: [PATCH v2 4/15] userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	James Houghton <jthoughton@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Oscar Salvador <osalvador@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Edward Adam Davis <eadavis@qq.com>, 
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7fqoxh5gn9shk7iigjjm7p48e4s8tinb
X-Rspam-User: 
X-Rspamd-Queue-Id: 063DC20007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773651174-413538
X-HE-Meta: U2FsdGVkX18BvaFhOwJgQ/o/87ajIwI1N8ozFhYvPjKeUcUHusxzQPOlGBrD2fJzAY4MYe2UJ7kSJc1YBPO0uFVjn9k0joX5DgcpAgd6a6Ylx5KEdgpufjgW1QeLdo3Yk4l0ZWPgLUKDPPJ7zA14mYJi01fIelVJSZWy1JNA0/tbHHCFUu4VqtJQv+IpoyDgqRwAxHfqlZxUUcuLAKyTn8DaabvQZ/NovzqhGR6QhZNJDuS35eBnffPhLrvvQym1wbiVl8AKMU1FtZdLWsPG1n/Ua3epFk8QJyctpu4a5WIQkApVzQD1Bh49mz5/QITMKlR4tRCSp+7mR2FeQxpnwdD3HFZZG4F9N8UOnb+zTImrPBIRdWCeHX8taKk8/ABXgSkxncgh4OpiDdqz3R0HN5mG+fXEwlPHr7LwG8yDEJAyYo514GAK9LtyuiPmFU/E16OpBLH4uS2n8rE/5A2UzAZaMEdCJ3nv5eqmg9ga2+ZfPqVDzgEkM+P1cUoVZTxv+IOvQOSfOA40vkGJ770FsU0fZgjH6orf+bLBhpnbWD2ISIpY3KBx+N2wGSv/Lp8/FvsoUeT79UxEpDofZzrGo7Xzs1V6cd8RSq7kYJVhvhTci9sXh1hA1RN4wOUweux62rOXeQfd3j0nRwqy4BWFAjpRMkfezIbsMdzKgrZh0CPuORU89m82vreexN5gC7BpA/iexqew7E0XDT58axo7ujexuDRhll3fkbldW63yctmqMUcq3rcPt0gRtrjga1/AI1jxn0cOSXa4y72oTRHWUxCs0ROIBBnNdk1v7G7/cOxu3cmIFBJdvEOID8SoC/V5LPemlX+9otjv1AKZ9RwO7dJYnV6c4sw+pYGLMRlfFU7M5s+jdmfpbfu5gzl4yOIICrRFTentN6lGrbLijB9EMagp5B3xAWS0R3o69LnR27AdEYdgybsQ5Ff/xXE2wPs+nT6/Uz36VH8c43cleoa
 hhstnVMR
 0YamA7mFWVue8iLD+UqzzIWd5p7/2RGPvVLvrWxa6FAvEqpc/MW27fH+YaWJoiAjj02byId1heKJglZTGSrtPl5VzGy/uwi6z6m2gW8AQP9GsfDI7pTZ4AUG3wd9DTiaQD8SKsv8GWX2GV5YqOU8387zIECgGNi5MR9r/3NUcxFK35zZpJ8ONMO9PkdX+n6gLmnlbDGeXt2SO71YbaDpODBOS3x6dh2BFadPq6XvfqnLfpSUjEbRgd9mMpesE0NaXKPzpFSgS4VinufLqUDL7bb4kxncxU3wizUmkld4lCcNLYa7ZkOqnJiEMjRaVE1ZiPHzp6TjB57bQXV8yZST+Y13mE/fnVup1Bgg5zIeUf/g7x95uKF15c6Ghywfl3qYsc5dLuSy0e4Q68afBp0nMTYavVrGUXQQVHWx0W9RmKbI649oJv07dwnk6WaCYf0qExY90IhaD/sQXltVBkmc1hbI2NTMDLC8Mo1U6YGmtB/sjc5QdafiqsDBHs0L6ScbCFwD5iFhZ5HLPW7dfwqxMan6wv7IPJM9tU+HC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 2:06=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Mon, Mar 16, 2026 at 01:35:38PM +0530, Deepanshu Kartikey wrote:
> > On Mon, Mar 16, 2026 at 1:19=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com=
> wrote:
> > >
> > > > It seems there's another attempt to fix the syzbot report from
> > > > Deepanshu Kartikey [2], which I didn't take a deeper look.
> > > >
> > > > At first look [2] looks a bit wrong way to fix to me though,
> > > > because it allows operating only on a single VMA nothing should rea=
lly split
> > > > or shrink the VMA if somebody is holding the VMA lock in read mode
> > > > (and the validation of the range is done while holding the lock).
> > > >
> > > > [2] https://lore.kernel.org/linux-mm/20260316070039.549506-1-kartik=
ey406@gmail.com
> > > >
> >
> > Harry,
> >
> > You are correct that once vm_refcnt > 0, nobody can split the VMA.
> > However the split can happen in the race window BEFORE vm_refcnt++
> > in vma_start_read(), and CHECK 2 can miss this if mmap_write_unlock()
> > completes before CHECK 2 runs.
> >
> > Here is the exact race:
> >
> > vma_start_read():
> >
> >     /* CHECK 1 */
> >     if (READ_ONCE(vma->vm_lock_seq) =3D=3D READ_ONCE(mm->mm_lock_seq.se=
quence))
> >         goto err;
> >
> >     /*
> >      * RACE WINDOW: vm_refcnt is still 0 here!
> >      * UFFDIO_UNREGISTER can run:
> >      *
> >      *   mmap_write_lock()    -> mm_lock_seq =3D 11
> >      *   vma_start_write(vma) -> vm_lock_seq =3D 11
> >      *   __split_vma()        -> vma->vm_end =3D 0x4ca000
> >      *   mmap_write_unlock()  -> mm_lock_seq =3D 12
> >      *
> >      * writer completes entirely before vm_refcnt++!
> >      */
> >
> >     __refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, ...);
> >     /* vm_refcnt =3D 1 now, but vma->vm_end already modified! */
>
> It is true that vma->vm_end might have changed before acquiring the vma l=
ock,
> but it doesn't matter as long as you verify the range after acquiring
> the lock, no? (that's what uffd_mfill_lock() does)
>
> You're not really supposed to read vma->vm_end before acquiring
> the vma lock and use the value because nothing guarantees that
> the VMA is stable until the lock is acquired.
>
> Or am I still missing something?
>

Harry, you are right. The real bug is state.len =3D 0.
I withdraw my fix.
Thank you for the explanation

