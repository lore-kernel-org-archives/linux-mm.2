Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96788C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 20:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522996B0088; Fri, 11 Sep 2026 16:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA4D6B008C; Fri, 11 Sep 2026 16:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410D26B0092; Fri, 11 Sep 2026 16:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF5D6B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:59:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79402C0365
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 20:59:14 +0000 (UTC)
X-FDA: 85202696628.23.51A0383
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7A9AF20005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 20:59:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iN3IgPB8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789160352;
	b=0qSywpfpLyAMFc8iAeocqK6HjnvUUiJWKlbHbxXG+iPY/GTwfC6MSHrsmiSAHtvpL8cWG8
	grJdfPLFf/YFgmeGG7KANO9b/1AluvZ92aO2Nx1wmzD6fqcRcRhwY2+Y1A2Nhf269OImhm
	cwrO82UclCIDaRw/+4UqX96KNPU3gpk=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iN3IgPB8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789160352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9mIQ6jM8juF2PvO8eUkaKKIYpJrRvH5Gc2fB112shtA=;
	b=CrE6XtJXvgjTEUZomEjQcBzTjCgfdYQl6Prbcc0fcCC5s4MAyHm3iYrL1fPx1buab1ELT3
	sEyRGl06wlEGv+OQmZxga9gDqYCJ3VNJwiUZwS5gsDZsM7xkwcAcj6D0BJ8Jlvz17ftn6m
	XZFVNp2MPoh7MV/bWgWT8jd3gv5iYcc=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-90e970f710cso14204446d6.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:59:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789160351; cv=none;
        d=google.com; s=arc-20260327;
        b=G+3QnXzeODU9QHBBQY6NDt6tVuF9XVjavDKYHclp3qaekdcrsj5GyKR4ibCDkxQW7r
         hOsR5j3PHwKverItsp0HHa1oi8M4LxZ7qQR+Q5d8y5t5TngeUmp7rVMCSUQemHDi7lXY
         8LizsnjDjQV16JmjN2+uPFc6Ld/53qFu0/OG2vvHx6gwE/DcqU+PGpiEXS05Eugfh/Jb
         Sd2CzQH5j5WjhDXK2Q3texgNzGLCM9cBNtIAmguUOpvdV8lwSeBB+mwghf7nhbzEDpOV
         iG6KEPcIA+nwiEbXVacD6fuy7UsrJ3uRBv1PCbswHFDz7EVIZ9E/bj1vsdKyKfkuBZae
         nhqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=9mIQ6jM8juF2PvO8eUkaKKIYpJrRvH5Gc2fB112shtA=;
        fh=VA51uWknzjBDJM/t/nzt1vR0LIh8OlW/YrN2Xqgb3hY=;
        b=A2NCJLlL3XIbLT4Ube+G4EP/lGl5zIh7tMJWdDjnqLT3Qb+sk16YhBPbcoIZW7fyxt
         2PNnwZYl6O7p5AQVdAW0nO1VlExq27lB3ul9wji6pwQcmi+nDZ+hCfB5oWAzXozQNnc1
         1oGFC8hkKSvh60qHrR9MwRsb+eglogNH1j1htpMPGX1cYoxvfeo89qPwGn9PWXS5L0iT
         y2rkYWKu7uO9d1WT3Q0arWaPhYxfGWnahLS0GLQeWg4gaSLEe1nQFYBlfW/UwVRI8Lbj
         73/l9Xbl5qCQDJJP3DTH1ddjjBgber+p00fGm5oqvbPed+l/xL2Lbusq4MGKjFACbUZQ
         VtsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789160351; x=1789765151; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9mIQ6jM8juF2PvO8eUkaKKIYpJrRvH5Gc2fB112shtA=;
        b=iN3IgPB8rWN4m40H5pjGcWn0YrC2MFuiF+0Ux9Sl1lYqj7ZzpgK1Mp6Sao85L8KGzZ
         utZPSMjsIIaAoj7UIJRC7VjbD5EK2FxKHZVWnjt0PfS/m8NVm26xODmvvVRPYuy7Umqx
         mRGi4HFFXIM+bue5smTBSzLdEk6bIfOIc7MPecMqlxppVlIxqlMW0dyjcVXmWEhAjdSJ
         FP316K/x4JG/ko7t4qh7C9ly6CAJw/EH1PH5pjLl7YVRbgbYQWAC3DjZ1ONyh6wC3Mjd
         yuziTSebtnQyg+eejZ0P3HXi7lKGMt9QaRdPEimyNmmOGVnL7iSrIsPKy2IonsIjgBXv
         N5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789160351; x=1789765151;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9mIQ6jM8juF2PvO8eUkaKKIYpJrRvH5Gc2fB112shtA=;
        b=cKltRUlDSMPJP02JhxHLHDDkJrLWyr7TpZUPe/ttfdQlbWDevk3G8VPqvdOnGS82D/
         oCKV532rgUlh6HMfD4Mi/Tv+170a3Xg2bzNU1CxrT8stGY3dELeef2qQabTwpXK3sAG+
         wm9fP6YSWE6Za6nPRgIbsIinWZWpCSToAPdL7XImopBVTitxfmt1JkmOZ08G6CqDYsnY
         uBH39pWoVIvc99wxrYkBP6uMP2cFfsULBtJ3qy6zKovv3GpPvvhfJxUabrFxXtGYrdo2
         T0dGh9/JzK8xbjtlHnXwuyjiIHXITZt8h8dBk4IR8Ta6Iu9ZIEHia453g1munwa6zliG
         9bvg==
X-Forwarded-Encrypted: i=1; AKwUvBwbH62x7TbgGuFkJkubcW/8zwjz18aBwTlZ01aCUXkMVY6pyhr287WuwXPtQMAdYQZdIUgkvB9nYw==@kvack.org
X-Gm-Message-State: AFuF++klco/E1VYKYQNjDjUBCYtP9jlnmMLkKh89p6Jm5MP2zlqfMJTF
	WAXeGrf4lSYxLYO/SVzrdNyHkfS+pAmOiu7i1PQCNdwmhMC9XE9m1fapx6WMcPRSRy60/Y3gZCy
	wxRfAg5qrqqA4ZrgJ2K/pedNK1mGKq6XnlLQG1AvH
X-Gm-Gg: AYBFou1yGGuKGiEZTgbL5/TWbd04+V3KA7/1ZfX09aTJs4dT+cx7BkYITW9FjzfJXjX
	EtYQ+tZKzjHk9ljQ9DzCMvSKKj2mRIxcPjUJZh9UyzdnfSBGBTU1swZSeZBHVRasOF1+PNXR0B9
	XxjMYloh6bg+MIyaohhjTsnin1cczWe12ydd4EGqo+x75JiOZg/dT4gO3HxUKs97L3uQNQuiSRZ
	5+0obT5ZS3pQwSP0RLHhOiudHNbENal06dYyRM+uh6zGulu0VlFtKulK0lNxDVMm54+K/4Bf8ZF
	nswVd29KDM73H/tm/QqwT49lPuW4QVyr0Uo3wIMRkic+W4OQBpIkp0Gt/zUSTzLX5BEjVvaP0bA
	ovq1LHX68obQjkAeTuKVF0FQZ3MZr2wkL/4BpCS5zVg==
X-Received: by 2002:ad4:5f8f:0:b0:910:4c56:76d8 with SMTP id
 6a1803df08f44-9121207d6d2mr79542346d6.1.1789160350811; Fri, 11 Sep 2026
 13:59:10 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 11 Sep 2026 13:59:09 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 11 Sep 2026 13:59:09 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aqRFSiicubfsw3N6@google.com>
References: <20260901180713.4185641-1-dmatlack@google.com> <CAEvNRgEs82CVTL_CUn=Ovrwvt86U1dxzr8psWGu=nk98ZH6Esw@mail.gmail.com>
 <aqRFSiicubfsw3N6@google.com>
MIME-Version: 1.0
Date: Fri, 11 Sep 2026 13:59:09 -0700
X-Gm-Features: AcwNN1VXiGYQy4JW0rBuiz4KjYly49Wx8Xl5G5ezJF-9TY2IawBLiOKUcfGow4s
Message-ID: <CAEvNRgFCrcyk6F0vJ11pgj2EDSUAXj6Zw-oEdZpfj2SrH1Cv9g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] liveupdate: LIVEUPDATE_SESSION_RETRIEVE_INTO_FD
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A9AF20005
X-Stat-Signature: gw9zi6csx9crg84d83hunsywd4an9q5u
X-HE-Tag: 1789160352-139846
X-HE-Meta: U2FsdGVkX1/t7krxbQyBIXYeCENX79HcesHUgAdkyI218h17qEPYFhiY7rwXCEqvBTql5jQV5U0ernH3zs2tOPG+ja3AShWb8iqjusF//rsIZZ2K6e0WGiddHIAMpyi7uwnuYteWP98sU7c5xpOIJF94IA2vFRBrljJtZRUY56Tm0tK4ZvE3/A4D77BMxRyXdM86U2xdXPRemhiYFyaYOOonA9YtZFazHug9360ZN0NbX9GJGD1eNc7TDtLQgWMFpukiNVD6yc+7IFM0UfavMmJncpN/nWiir9r0VQiIFb9hHS1OY79OGud9Xb1iJRe+zETNvCxVRS20QUoTZLxxzngSrlW8fxNTw7+5SFVUwVEvv4MwV72xxeSE9qSd05dYEq+oUJReqDS2RlAcGEcPkO3PtqIr8OLaGh3JX7hDFm15MoTcHKbaz4H1d0xH83XocupItUqA528NgqhKfaXwtqVzhEA9ZzflV/u7xJf2qvKA0L24B1F9JlOn+E5MQHRKN5Y/3gro7BfTe+D6PhiZQyvon1yg+4Jt0m0TDVitBw11wM8uMpsqV74nQedRqEChaO33Jiwhfpfm5qbveTQfr6fFhCQsWu8w3a/n75y/wwu3uCc9N5DMth9bxSTyk2nd6WtzwjgBJ7+jS8uGGRYM0+MxPwMtsAd3AYESQgqjabgBXKlXjRUIoMEID9Gl6vPISL6FtH+a4vSqfSTtgwn9vqdk5lsOqrGhDDkxpRAorMYV9HCa6OPpZhp697fEq7FRHqHfcrlftq6sKYD/sDmnBgtavLfhhDWqbnnfhCmfrTcHBQN9mxyBnZeRfkGQMP5pN6A2AaqrXUpUDWd+DJs6qav2NRlmT4tl6xDXmnBDJrHKWIW76pPdIXrPiSopeUyGL7RsKAqxt6o+fEsZd47TQJpeVabON8beDXrYYBQxvu/0KFKk5TG+6xDLhK+YzVWdrB/NM1lgTozTn6SpJUE
 UbB/+kbw
 vfPsb7j2EzoIbDXHiN9Jks8VzLeenCrVQC5k1gMAs3Z6nJBdwq0jIRUUFSlnTuboXWTUQccfBTzrLs3ZnLLSO1vjgadg0+Cn3vQruirH7qb8Ceg++prq4N+HFwu0NU6cv1xyLKdsuUoVUqCLyOmFB1Xv0bNeDRpHUQWCs3z6USz7ADpJ8IADo1jjWSIY4xyM0rW2H8bnKwuckfFvf90IFjO8+m+SFCWOXuDqdZzvN8RmAQOLqNdDeMIB2Mg8WFUDot91wt+w1vuhTbY6SCshr4Siji2lsX+Dd3nVLeMsQ2S1DasucRI1kuL08VOjYLOhcdhJFqS689d/DSaQoMp+hdgb5XCYT3nbZB5/FmWp1QpiUyZCjNPdlvOB50w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Matlack <dmatlack@google.com> writes:

> On 2026-09-11 11:04 AM, Ackerley Tng wrote:
>> David Matlack <dmatlack@google.com> writes:
>>
>> > This series adds support for LIVEUPDATE_SESSION_RETRIEVE_INTO_FD, a new
>> > UAPI to enable preserved files to be restored into a userspace-provided
>> > file instead of a kernel-allocated file, and uses this to support
>> > preserving tmpfs files in-place without any changes to the LUO ABI.
>> >
>>
>> I'm interested in the idea of retrieving folios into an fd for a
>> different reason, I'm exploring handling over ownership physical memory
>> to a guest_memfd.
>>
>> > The Live Update Orchestrator (LUO) API currently explicitly returns a
>> > new struct file for every preserved file during retrieve() (e.g. via
>> > memfd_alloc_file()). This then forces userspace to use anonymous memfds
>> > for all in-memory files it wants to preserve. This works reasonably well
>> > for VM guest memory but does not work well for other types of files that
>> > userspace may want to preserve (e.g. in-memory logs, binaries,
>> > configuration files, etc.).
>> >
>>
>> Does this assume that VM guest memory is usually provided using
>> anonymous memfds?
>>
>> More generally, is the problem that there isn't a simple way to
>> implement retrieval into anything other than anonymous memfds?
>
> Roughly, yes.
>
>> > Preserving entire tmpfs mounts in-place would require a large amount of
>> > kernel support and would effectively make tmpfs an ABI, which is a
>> > non-starter (or so I hear). Instead, we can delegate the reconstruction
>> > of the tmpfs mounts (directory structure, permissions, etc.) post-kexec
>> > to userspace. The kernel just needs to preserve the contents of tmpfs
>> > files and provide userspace a mechanism to restore those contents back
>> > into a specific file on the filesystem after the kexec. Hence,
>> > LIVEUPDATE_SESSION_RETRIEVE_INTO_FD.
>> >
>>
>> Suppose pre-kexec, the data was in a tmpfs file (and fd), how would the
>> preservation work? Would the user have to
>>
>> 1. Transfer the data from tmpfs fd -> anonymous fd
>> 2. Preserve from anonymous fd
>> 3. kexec
>> 4. Set up the tmpfs fd
>> 5. Retrieve into the tmpfs fd
>
> No, the proposal in this series is to support:
>
> 1. ioctl(LIVEUPDATE_SESSION_PRESERVE_FD, {TOKEN, tmpfs_fd})
> 2. kexec
> 3. tmpfs_fd = open(..., O_CREAT)
> 4. ioctl(LIVEUPDATE_SESSION_RETRIEVE_INTO_FD, {TOKEN, tmpfs_fd})
>
> No transfering to or from an anonymous fd is required.
>

Cool that preserving a tmpfs_fd is supported. How is that done without
preserving the rest of the tmpfs stuff?

Why is it possible to preserve the fd without the rest of the tmpfs
stuff but not retrieve without the rest of the tmpfs stuff?

Is retrieving into an fd a bit too much of a shortcut? Would preserving
the rest of the tmpfs eventually be required, and hence retrieval of the
rest of tmpfs should also be eventually supported symmetrically?

>> > An alternative approach to restoring data to a named file would be
>> > supporting a zero-copy sendfile() that can be used to convert named
>> > tmpfs files to/from memfds across the kexec. But this poses significant
>> > challenges on the *preserve* side since the preserved file might still
>> > be actively in use. The benefit of the retrieve-into approach introduced
>> > in this series is that it does not require dealing with two different
>> > files. There is only ever one file that owns the preserved memory.
>> >
>>
>> Would it be more symmetric if the process is
>>
>> 1. Transfer the data from tmpfs fd -> anonymous fd
>> 2. Preserve from anonymous fd
>> 3. kexec
>> 4. Retrieve into anonymous fd
>> 5. Transfer the data from anonymous fd -> tmpfs fd
>>
>> As to the exact details of "transfer", I think the best we could do
>> would be some kind of move from one fd's page cache to the other fd's
>> page cache?
>>
>> Is the goal of the transfer to avoid any memcpy and fully transfer
>> ownership (so, not just by increasing folio refcounts?)
>
> Yes this is the alternative proposal that has been proposed and
> discussed a little bit off list, with sendfile() and copy_file_range()
> being the possible mechanisms to do the "transfer". I think there are a
> few fundamental problems with that approach on the pre-kexec side.
>
>  1. iommufd requires that fds mapped into it are preserved. If the file
>     mapped into iommufd is tmpfs, but then we transfer that file to memfd
>     for preservation, iommufd will fail to preserve because the tmpfs file
>     is not preserved.
>
>  2. Even if you only use this feature for files not mapped into an
>     iommufd, transfering the contents in a zero-copy way seems
>     challenging. What do you do if the tmpfs file is still in use when
>     you want to transfer it?
>

When you say in-use, I suppose you mean folio is in-use by some IO and
is mapped in IO page tables, and that the IO must continue while the
folio is transferred?

Are you expecting guests (as in stage 2 mappings) to continue to be
functional while the folio is transferred?

I'll have to think a bit more, I was initially thinking of just
transferring folios where I could unmap from everywhere (processes,
stage 2, IO page tables) for the transfer.

>> > By leaving file and metadata allocation purely in the purview of
>> > userspace, programs can create the target files where they want, with
>> > the names and security permissions they desire, before directing the
>> > kernel to restore the preserved folios into them.
>> >
>> > Currently, only tmpfs shmem files are allowed as valid target receptors.
>> > Attempting to target populated files, or anything other than an empty
>> > shmem file, will trigger -EINVAL. HugeTLBfs files could be supported in
>> > the future.
>> >
>>
>> Is this basically that at some point, all in-memory filesystems' fds can
>> support transfers?
>
> Yes, theoretically.
>
>>
>> >
>> > [...snip...]
>> >

