Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C04CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 13:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DEC38E0005; Thu,  6 Nov 2025 08:03:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6A48E0002; Thu,  6 Nov 2025 08:03:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC7B8E0005; Thu,  6 Nov 2025 08:03:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 764228E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:03:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC47B4A563
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 13:03:55 +0000 (UTC)
X-FDA: 84080199630.05.C7085B9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8A9C320018
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 13:03:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iTD75gVW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762434233; a=rsa-sha256;
	cv=none;
	b=FwYa6XJf7+5jrKmk3+M72Df+OhO7eNZeynkk00weZ3uJemoQsxjdIRJM8fTT1iLMltAoPe
	FDp9wXv/Znc85JVzw6z460o4sZ6W6O5ArKIsAegM3OU0U3iepWRM9mwt5i6X93/Bg2OwlB
	nsr50cv2MaN921LA40brpvmHbpfjFJQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iTD75gVW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762434233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bizzw1eY/sYaE2qZFBkce0cFEHI+eAygGrJfW35YF8M=;
	b=xuV8NSg8typFKWFavQeeKp5DYYy1NnsKlqToXvoRgclzyMV6y88YWVda0Fncx3TGMLD7D8
	J/bZARQ0mMIELH6f4UvraPEFnxN7eYSOeuD081Q0DmYP6JZu+ZHgh2dPfEkavNihIJxoWY
	uVTpmd+cbkgN5yAeiF7qDBV2V+nHTjI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762434232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bizzw1eY/sYaE2qZFBkce0cFEHI+eAygGrJfW35YF8M=;
	b=iTD75gVWvayK6V7Uqdbf8BNYTrAHjm5Uxf78Pro7Vyk3uHF2zQS7k06UCbsQzBCvrU3uzz
	K6M2HfiB8NGM9qxC43YeVclV+ARdW77QSAUVJnraFFecEUG3J81SMhasTxcyxWVy/HkEdA
	mGqL/axupe56m8udv9iWgRwwRrJYuyw=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-EM3eRDrKNp2KX6cpGci9IA-1; Thu, 06 Nov 2025 08:03:51 -0500
X-MC-Unique: EM3eRDrKNp2KX6cpGci9IA-1
X-Mimecast-MFC-AGG-ID: EM3eRDrKNp2KX6cpGci9IA_1762434231
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-78658266df1so3670927b3.1
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 05:03:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762434231; x=1763039031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bizzw1eY/sYaE2qZFBkce0cFEHI+eAygGrJfW35YF8M=;
        b=BFOOvfrelmCMuaz2dMIFexYLlSS1RzBaRqzAJmGvwzOnUX+MA6u1eGW2X/pJXTY6fH
         f7utGS2d9PkM8yI5gD4mfSliGjDfmAIV0ecb+cXLQK7mUe5jb4fFTd0X8g0cC9Wf4Ttz
         EH242EBwfc8QhAdR5V3E5vGDiSHEboWdF1WvMU/8/ZU+tHPQFVDKg31kdhEo8TijruWI
         EdUkbblFhGzNzGkjoAPSI5BIaXD7Tkqm/VtdqmBziV3LQ9fiKAPn9Jwikq/l697Lv7qA
         0fczJ6h7OjJiDk1LM+R/f4+CQtw1rMWIQoI3GFy5kq5AjCc6Dj22Pzub+LwRE3FUzfHL
         hTrg==
X-Forwarded-Encrypted: i=1; AJvYcCU7hMXryEjL2dRkO1GPotHNT69+UpIzf/mc+TdLqojQRv+rFK2ZBqLm2U7zdKb3X3iKG70DQ8Rk2A==@kvack.org
X-Gm-Message-State: AOJu0YwXO2+iperG9c2dQwJ78kP3ahQLUIols03wUJ3OaHUNyCIVZoEr
	CIvHyglHOpHKOvOK4O8HiJG0s3FuFQ2DOd3M01P+h41jTuephIDK7o300qr5wXfBVWdLVgIw4iJ
	3ap2cvg9n6tYVosLkB6p+6lF6EafWobZk/QxeYRf4hgk5wwkRk3KcILMdlDtXDPnxkW45KMBfpN
	O/4kPUxbg6AatAp3DuHfIbxi9IiW4=
X-Gm-Gg: ASbGncuqktu+jxuFmWQwy7CG+QfUUL+sFgC66JlaY8yC5uHJNSSjXo6HcCRqDbac8uS
	kFL4NfuT3K1oIz4MBR0kf/kFWWmJlwZbBpG220/X57XLNLWvv6vXJ0KFT7iyqxYBQm32+mqfttF
	H3lpnqd5nOQvbB6nHj0yuLSuEYpOe8ErNi6Hf7ZHRbU6WTMqdfdr0yi8gNp99LJTpDsSGjFw==
X-Received: by 2002:a53:acdc:0:20b0:63f:abf6:1cc with SMTP id 956f58d0204a3-63fd34a9b9fmr5235615d50.13.1762434230929;
        Thu, 06 Nov 2025 05:03:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEpM27qMKWP5kpbGDiF2b/f4sLGs5D3inRXd3HbmlPqqsA/ZAGOkpTYQR3sOmWapf3I6dH4KtY5KHTahLsbspU=
X-Received: by 2002:a53:acdc:0:20b0:63f:abf6:1cc with SMTP id
 956f58d0204a3-63fd34a9b9fmr5235565d50.13.1762434230418; Thu, 06 Nov 2025
 05:03:50 -0800 (PST)
MIME-Version: 1.0
References: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com> <1783f8fc-6b9b-422e-999e-2a6f58d90807@linux.dev>
In-Reply-To: <1783f8fc-6b9b-422e-999e-2a6f58d90807@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Thu, 6 Nov 2025 06:03:24 -0700
X-Gm-Features: AWmQ_blkN6_bT3f71yyauBn3GKS8W7N_lgYx52d35GSxs7M-3nPJr-0AzuRSBm0
Message-ID: <CAA1CXcBktafjRFyD8JD-akVutzS-jQEFFC=kJtO3ewLg0Kk0zw@mail.gmail.com>
Subject: Re: madvise(MADV_COLLAPSE) fails with EINVAL on dirty file-backed
 text pages
To: Lance Yang <lance.yang@linux.dev>
Cc: "Garg, Shivank" <shivankg@amd.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>, Dev Jain <dev.jain@arm.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, 
	David Hildenbrand <david@redhat.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, zokeefe@google.com, 
	Vlastimil Babka <vbabka@suse.cz>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Flg59WfwJzfo_kiqqf2avILIvedym8qffPcNrqAmrgc_1762434231
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8A9C320018
X-Rspamd-Server: rspam07
X-Stat-Signature: gnp44zqpk9uxdpbe3xnmqkahpgoy3deu
X-Rspam-User: 
X-HE-Tag: 1762434233-694893
X-HE-Meta: U2FsdGVkX19mMliBnGolOtjqU/2UefJJhJxVzxRKnOn/mPBZthvfrWO6zEmvcTj0Mre7CCwHR//JEKmxTqHE5p38LNtDfCIu8NHOyNKUdY+nQcz25daAaqcLyX81xOTKZ5zV4keCLTa3chC/FZfTT0H0tI46vc99Xj1WlE1CiTNREqaONxHEB91ch2+YlUxhhcoREGzUL4TmnzntHOtkjl0y7l+Tr0R5pDmDqCxxT3lSdg1RGMw/GGR/GLP37jfCwZ+c8SrT3CITEeRg41g3tpjxPyyldLFpa6miAZPu28TAqK9+KZv61IAJKLYIyrZilDWPh/e+9ydy4AuoYN3YiTJEVe6U6NLVmKY+LKi4nPXkAlaARVRF7olnxeATb+xB7X+lAoP2Q9claA45UehHsVhzCVSsFprjIb22+eD5YXBq43JiA0eI+Jge8N6Q/rXC9SeU+CsRR//xjxSG5YY1KTG2wsSDWu9gqT9f7vPxLvdiByK2LjRnEzdOeBMrtEGVodSb9JKD0k3HTj6NqHMkgW++44yDjJLUzXJlmX1AFaVPx3j/+m/GOa9obj3Yb6W69uqmAucWlJFaI7GjHhVmmLeZ/ZkybFTPgFI9jlcI/7hJat2By4WUmIQ++LJyr6JRHZY7pDF/tZxViu9MSXQs/yil4pwUpmpR22DDeZIXZKNtLf1BfCYoBwPcn/gGmBR2doL8dCZPL8HLl0EDoHKSbIpqb/M9JByLbYDpsvlipHu5l/bpZ4IhVXnRpdwNmgZNR2smjJHz1SXj0aMiCnq6DueABdQ4hfA+DElS2k89/IX0yYnRn4cgrs1Y1xaWHHPy6WLAm9SlgfUukg5NZHOtotdhIfVPrzj+oQQPY7lSGNGl2A9mJPcfz96PzO6JTH9DkFbyQyRN0epNZcalKcDOrODvXyv61gUAedmb1kZk8ymMsLSkQpLpxwpswKkjGtCYQjdJZ58VVK9Al15M86A
 gFpon0Vb
 7BsG141B6M2nzI5OObL2UkZf5H40DxVIG7OPh8fiDpkhYsdVsHYIImw0b6SJFTg7qzSQetII0SrKRZxPcw4VS4PJXXsbGVdgvOiAvo7EMiMjhB5PTMcRfTH51P2zc4dDOm9u+X0ujUyBhoM/GkLYc2mMktRK2AK1RwLLc1vjJU2YVbO/f3fYG6WEmGhwrb+ibPKWkA6AMiWaracCwQ2QTfrJdHEwQEVPkZc1TwjFaaE/xKT+kb+/juBGnvfsCZKELjHbiBN293LyNDbvCTu+dDe0mBK1eSL6Y69YRG+eLZjTu+gtLl6RQ4z+Xtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 6, 2025 at 5:55=E2=80=AFAM Lance Yang <lance.yang@linux.dev> wr=
ote:
>
>
>
> On 2025/11/6 20:16, Garg, Shivank wrote:
> > Hi All,
>
> Hi Shivank,
>
> Good catch and a really clear analysis - thanks!
+1!
> >
> > I've been investigating an issue with madvise(MADV_COLLAPSE) for TEXT p=
ages
> > when CONFIG_READ_ONLY_THP_FOR_FS=3Dy is enabled, and would like to disc=
uss the
> > current behavior and improvements.
> >
> > Problem:
> > When attempting to collapse read-only file-backed TEXT sections into TH=
Ps
> > using madvise(MADV_COLLAPSE), the operation fails with EINVAL if the pa=
ges
> > are marked dirty.
> > madvise(aligned_start, aligned_size, MADV_COLLAPSE) -> returns -1 and e=
rrno =3D -22
> >
> > Subsequent calls to madvise(MADV_COLLAPSE) succeed because the first ma=
dvise
> > attempt triggers filemap_flush() which initiates async writeback of the=
 dirty folios.
> >
> > Root Cause:
> > The failure occurs in mm/khugepaged.c:collapse_file():
> > } else if (folio_test_dirty(folio)) {
> >      /*
> >       * khugepaged only works on read-only fd,
> >       * so this page is dirty because it hasn't
> >       * been flushed since first write. There
> >       * won't be new dirty pages.
> >       *
> >       * Trigger async flush here and hope the
> >       * writeback is done when khugepaged
> >       * revisits this page.
> >       */
> >      xas_unlock_irq(&xas);
> >      filemap_flush(mapping);
> >      result =3D SCAN_FAIL;
> >      goto xa_unlocked;
> > }
> >
> > Why the text pages are dirty?
> > It initially seemed unusual for a read-only text section to be marked a=
s dirty, but
> > this was actually confirmed by /proc/pid/smaps.
> >
> > 55bc90200000-55bc91200000 r-xp 00400000 07:00 133                      =
  /mnt/xfs-mnt/large_binary_thp
> > Size:              16384 kB
> > KernelPageSize:        4 kB
> > MMUPageSize:           4 kB
> > Rss:                 256 kB
> > Pss:                 256 kB
> > Pss_Dirty:           256 kB
> > Shared_Clean:          0 kB
> > Shared_Dirty:          0 kB
> > Private_Clean:         0 kB
> > Private_Dirty:       256 kB
> >
> > /proc/pid/smaps (before calling MADV_COLLAPSE) showing Private_Dirty pa=
ges in r-xp mappings.
> > This may be due to dynamic linker and relocations that occurred during =
program loading.
> >
> > Reproduction using XFS/EXT4:
> >
> > 1. Compile a test binary with madvise(MADV_COLLAPSE), ensuring the load=
 TEXT segment is
> >     2MB-aligned and sized to a multiple of 2MB.
> >    Type           Offset   VirtAddr           PhysAddr           FileSi=
z  MemSiz   Flg Align
> > LOAD           0x400000 0x0000000000400000 0x0000000000400000 0x1000000=
 0x1000000 R E 0x200000
> >
> > 2. Create and mount the XFS/EXT4 fs:
> >     dd if=3D/dev/zero of=3D/tmp/xfs-test.img bs=3D1M count=3D1024
> >     losetup -f --show /tmp/xfs-test.img  # output: /dev/loop0
> >     mkfs.xfs -f /dev/loop0
> >     mkdir -p /mnt/xfs-mnt
> >     mount /dev/loop0 /mnt/xfs-mnt
> > 3. Copy the binaries to /mnt/xfs-mnt and execute.
> > 4. Returns -EINVAL on first run, then run successfully on subsequent ru=
n. (100% reproducible)
> > 5. To reproduce again; reboot/kexec and repeat from step 2.
> >
> > Workaround:
> > 1. Manually flush dirty pages before calling madvise(MADV_COLLAPSE):
> >       int fd =3D open("/proc/self/exe", O_RDONLY);
> >       if (fd >=3D 0) {
> >               fsync(fd);
> >               close(fd);
> >       }
> >       // Now madvise(MADV_COLLAPSE) succeeds
> > 2. Alternatively, retrying madvise_collapse on EINVAL failure also work=
.
> >
> > Problems with Current Behavior:
> > 1. Confusing Error Code: The syscall returns EINVAL which typically ind=
icates invalid arguments
> >     rather than a transient condition that could succeed on retry.
> >
> > 2. Non-Transparent Handling: Users are unaware they need to flush dirty=
 pages manually. Current
> >     madvise_collapse assumes the caller is khugepaged (as per code snip=
pet comment) which will revisit
> >     the page. However, when called via madvise(MADV_COLLAPSE), the user=
space program typically don't
> >     retry, making the async flush ineffective. Should we differentiate =
between madvise and khugepaged
> >     behavior for MADV_COLLAPSE?
> >
> > Would appreciate thoughts on the best approach to address this issue.
>
> Just throwing out a couple of ideas ...
>
> We could just switch the return code to EAGAIN in the MADV_COLLAPSE
> path. At least that
> gives the right hint that retrying is an option ;)

Hey! I agree with Lance here, it seems the solution would be to return
something other than SCAN_FAIL in collapse_file(), then in
madvise_collapse_errno() catch this error and return EAGAIN. We could
use SCAN_PAGE_COUNT which will cause a EAGAIN, or we could create a
new result enum.

Cheers,
-- Nico
>
> Or, what if we just handle it inside the syscall? When we hit a dirty
> page, we wait for
> the writeback to finish and then try again right away. The call might be
> a little slower,
> but MADV_COLLAPSE is best effort, right? That seems worth the trouble ...
>
> Cheers,
> Lance
>


