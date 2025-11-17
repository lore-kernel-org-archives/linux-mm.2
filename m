Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE44CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC998E001D; Mon, 17 Nov 2025 13:42:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D0B8E0002; Mon, 17 Nov 2025 13:42:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345338E001D; Mon, 17 Nov 2025 13:42:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 207A68E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:42:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E05D4B7701
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:42:30 +0000 (UTC)
X-FDA: 84120969660.12.CD24D3F
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id EDB5440016
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:42:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jUtbaNey;
	spf=pass (imf17.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763404949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+GT+Mvcn48BVfqy5/WD1n2ZA/hN2dz1BCZmhQdhw608=;
	b=UXerHQEt/A5DXdk3iEJfGlZZOF7lXv/5Nlsz8EhQ6e+qF4jiqrJmtHPzVteeywkHnq/vnj
	NtJrzeFOdPTQksQW0HC05bBYFL/S+uHD4MoUCF/GgKc4uXFgx2LT2rJDnunB5WX7V/YniT
	lfGwuxlwmhLgUYaot2x921yRjBdpGco=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jUtbaNey;
	spf=pass (imf17.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763404949; a=rsa-sha256;
	cv=none;
	b=mOtlpcFjUgZFsumKEGX19BtEULAamivJgItNyktxFt4zuaoPQ6IsqN6asGRZrrHZ8quYej
	y5K0FviWzuJmxi3zL+YqGN6mEyI44vPB6zCM9+cE6PQKlCH7F7cwpiqEYovPh8bH+7pfhd
	Jo8udP8f94n1CqolHMoGO0fikl6MG2U=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-297dd95ffe4so42056045ad.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763404948; x=1764009748; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+GT+Mvcn48BVfqy5/WD1n2ZA/hN2dz1BCZmhQdhw608=;
        b=jUtbaNeyHGKc3vISYaVCk952ooNuu3veCqCgmn5Feb0qfOqA6eQowHElI0MqD6/FYk
         oInBK3qD6wpvRiA4wOfmpBPSRT7naYp7UenQn/Kh8SGaTZQV0xsJ+2C7rr5eBkldfzOk
         qeri6B7DL0Lr3DsZpwKNAqY8iqSYA4x7bsmTegYZ5Qwy5wI0Ah1AKr62Oisdeb6C5PYv
         N9E7lXVlSw7o77JCyMrowVBGyyL2djfaOcAvCp/dA/4ldJXvQUdHLE1fTPzfqDCrVkOs
         Y0RvjlS1MEbSVMuDf4VaPZalEq1tuPJDm1DbbUJH2CPFNfasia45XFV06NGyjhv7qFpn
         FyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763404948; x=1764009748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+GT+Mvcn48BVfqy5/WD1n2ZA/hN2dz1BCZmhQdhw608=;
        b=k2SkRil61/gwo3vgsUJfcHAeoptxNyBaTDatrJUQXEdfpCmfmwIYr+r/AkaGuZ+5Sz
         S/dTBOKOwvV2f7wn5x/g6MbkM3Q1w4WmxJxOJ4YBzhyO66o6K42766hCwIEc1SojqnaB
         jQhKxLtUJ6lx438GrDCkFNHBq7YaANkazjpvCGzRVZUtnXJNf/2uBuYJwxWpjk6OdKeF
         xdicnboL4wjMBi02IKKtNVy22FutoMndo4KRcjUVC9u+8nBrZm9c3q+GGfw2rN7sjik3
         30zMBzMYNBQw2TwwEouXQf3oLFb09mCbSOTswyDVdh9HZfrZzKY+dJK1iUEIN1PrxNlc
         H9lQ==
X-Forwarded-Encrypted: i=1; AJvYcCVc7v6fLzkbuV5rK7uuL97UAtNZ4J1J8sTIKmfnRr0nZl4tGgw9wCE7ATHCGoJkaCZB3zwrCDFAFA==@kvack.org
X-Gm-Message-State: AOJu0Yy/HLmsAX5lSyJ2dwx8HL370reXvqyMUrNXQ5d7iix7XOx6a1sx
	eHXz8ZfPr/gKzH9GwCcLtF4Ni2PmbPLVGh9heUboCHvaUUhAVMucaGa98m6I8MBdiWGeQOY4Z8S
	Di0INjZfjGgEDT0cYX/mWbxEY40a3GbM=
X-Gm-Gg: ASbGncu+D3HLy81cc8E9npMeG+SAIOvqpjqF5KSAkPSgFz0DFALhaQWXIrrI9GLAxBR
	ORRrGjQ/rPn7FMCQaQYA9HSjBFDj4uQAThSAT7vKf+3vTzz5/qBC/UR39nGWtkWYfomoIxJNOz+
	rie1RuQ8FB69kF54jKdznPMH8xK05KRaFQVyU0rTtbXgu96TrxXTQESgS+S8PplH93Ik8Y5t2wv
	XIzIS9oTItAHLfr97GGoYS3eGMxxdwTWu39Vf9TdhjDbbClkkEf0qoVR8NxkJChgREpEhW0XIwA
X-Google-Smtp-Source: AGHT+IGlCOta17/ddsZWnD9v3ffWOGOnFpGs6oqmTfDQtnnrJ2sc9E7ozUdVinCK+4CGR9Q0e/Sf5CFPt1dugRYiBPM=
X-Received: by 2002:a17:903:1aed:b0:297:d764:9874 with SMTP id
 d9443c01a7336-2986a6cbe5cmr156328205ad.21.1763404947533; Mon, 17 Nov 2025
 10:42:27 -0800 (PST)
MIME-Version: 1.0
References: <20251114193729.251892-1-ssranevjti@gmail.com> <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org> <aRsqwndQ459VN8I9@ranegod-HP-ENVY-x360-Convertible-13-bd0xxx>
In-Reply-To: <aRsqwndQ459VN8I9@ranegod-HP-ENVY-x360-Convertible-13-bd0xxx>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 17 Nov 2025 10:42:15 -0800
X-Gm-Features: AWmQ_blI9jblEa7JMJ2vTFmsIQ2D6lp_5HRLH235a5mwf0VK6MfqNFE0M2tzyYY
Message-ID: <CAEf4Bzboqf+1KUZCb2fBnLZUkzi5X4zOk+wy72eTu3VLB+z7RQ@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in do_read_cache_folio()
To: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, shakeel.butt@linux.dev, 
	eddyz87@gmail.com, andrii@kernel.org, ast@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com, khalid@kernel.org, 
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com, 
	bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EDB5440016
X-Stat-Signature: yt133goofnankxskff574ofujjhemtii
X-Rspam-User: 
X-HE-Tag: 1763404948-718063
X-HE-Meta: U2FsdGVkX1+yTzIG2aFmGjysRvaFzWkOtd7PIjCaqx1CRRYbwpzAoBCRi60aJyJ+vp7FlvBhw/OzwVapXGWKctHWo77oc+0FVzdcfLH5PQoHzz/SP+IK6Tui+Xda99UIfrXB3LjHRA8r5JlR19rTZghK6976zuvPBlWcvYr8mzX1JEfqX4lt/wYkFiCJFOqXT4wbcYYBxGJjB4H7WLQ0B/PfXN+GGQas1xap9POEANkiQYazgiPgc9ZTbItIgaDSFRWqX3GQR5sokgiKKGr7PXesmpMUfxxdNkReJ60HqNkEIC+vpy9MnxwFC3NKRsdCTBRGl1nkg5ASEqRTiISMTS+s+PyVaMLnTH0IGigbOHeJHIY6/hiVw22TYkVOXLbSaMUnyzVlJSQveHE6Y2FIKBK6AFiutheIr2ydItcrDS2WpOrRLNssUe5jP4FT6d0CZZ9dsg3F5+K3ZB5MH/jdQa9wF1n1XuPfKgaXp/0tTSfyrJW3JSK+yYvW43I7YkA2P8dWQdVwUeEP11Q4xbhvKcs8GVol/koqB8dGKInXlqfzUJu/XPug2GTHVCXLG7gHWGJ90pjX4CxBK9RvJProQU74lY2ZzvXe5LebU53hMt9D7uN3pTZEsvurUmuVAS5md4Hu7KskeCgfih45RL0nskGOXcf5hDN5QNdA1JBppo0BINTPNWMrWUi93/sOn3y0sj1RpJyj6Ibai9qRlZ1p80v3MK9uK4jQ6QJfRh1ks1a2GhmMp6WsPf122dbafxr7zL1DWYsZLKc43IdM8RgVQ5Pn95st2WsTcB/R6rSZZHOIf9bun1FGnD7MQD1kuRuMcof0ls2pLgKmi6/TFV79fBreRoyxfHOHX5rg/+W65dccppbtgpnGwE85P9Z0y0yIeDmxknOes1nD+uKvLvO+VbgzGkywp7KbCFT6Dz0SjpdDDKm360Il9GPYMQ1JCB/hUq0cTGIxBfXuKRKuwMk
 pXYE/vub
 8VX9oindpMUxShxeV01vv/fhO+pj6D3Dws+1C4p0zIM4LpNWPCDyJQbuTo1wmw+1NrwTnNElCgq1epc31ekGRlS1RscVigMmmB08L0ufUvNaRVR68zThAMl0tt7n7WX9k6GcRsRxsRkE9siL7bVwgBthq3RI2/o9PB/nKjITmFR6m6ykPe3Jgjpsgf5PmVfY+OA6jyBkVoiX2XC+WzQI5YXxzPZR3NhOrscp+DpxrIUD6johezw/N84KRIJM+X2KtamS1iuEyah5qe+lZUM4cjxEfefHrIuOU4xrDkIqHTP/Wknxd0skTvAWUJh+NeHIkYw6LUbHgMZ+PK/vlpM/dJPt7xHMfl1LBKrIU3/u1qzqyF4LK92b0u8BNAsP0yRZhXm0qkm3DJw6vvxjZdh5GNrZcyrfRmXzjrNRm+LL70ae9Scd2m3oIV+NQUocpzCqxu/lVbI7SSdve1nPeOh7Qxg0K9BTXs/CnJVyHYRJNYr6YneC0q2tHo9hON852aGjni8QhrkkI2Y3ggOAnBoDag4ZYMFcoc9cOOFUIGEjaz4OUbM31K4930msbscmcw05pC0GMSUMSGyYiGrC+Vt6C5wh6kQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ bpf@

On Mon, Nov 17, 2025 at 6:10=E2=80=AFAM Shaurya Rane <ssrane_b23@ee.vjti.ac=
.in> wrote:
>
> On Sun, Nov 16, 2025 at 10:32:12PM +0000, Matthew Wilcox wrote:
> > First, some process things ;-)
> >
> > 1. Thank you for working on this.  Andrii has been ignoring it since
> > August, which is bad.  So thank you for picking it up.

It is bad, I'm sorry for this. I was surprised to read this, though,
as I was not aware of any bug related to build ID parsing code, so I
went looking at syzbot history of the issue. August timeframe you are
referring to implies those "Monthly fs report" emails, which
unfortunately I didn't receive as I'm not subscribed to linux-fsdevel,
but I do see that there was earlier report back in April, which I did
get in my inbox, apparently. So I'm sorry again for dropping the ball.
Please feel free to ping me or BPF mailing list next time when you see
something not being addressed in a timely manner.

> >
> > 2. Sending a v2 while we're having a discussion is generally a bad idea=
.
> > It's fine to send a patch as a reply, but going as far as a v2 isn't
> > necessary.  If conversation has died down, then a v2 is definitely
> > warranted, but you and I are still having a discussion ;-)
> >
> > 3. When you do send a v2 (or, now that you've sent a v2, send a v3),
> > do it as a new thread rather then in reply to the v1 thread.  That play=
s
> > better with the tooling we have like b4 which will pull in all patches
> > in a thread.
> >
> Apologies for the process errors regarding the v2 submission. I appreciat=
e the guidance on the workflow and threading; I will ensure the next versio=
n is sent as a clean, new thread once we have agreed on the technical solut=
ion.
> > With that over with, on to the fun technical stuff.
> >
> > On Sun, Nov 16, 2025 at 11:13:42AM +0530, SHAURYA RANE wrote:
> > > On Sat, Nov 15, 2025 at 2:14=E2=80=AFAM Matthew Wilcox <willy@infrade=
ad.org> wrote:
> > > >
> > > > On Sat, Nov 15, 2025 at 01:07:29AM +0530, ssrane_b23@ee.vjti.ac.in =
wrote:
> > > > > When read_cache_folio() is called with a NULL filler function on =
a
> > > > > mapping that does not implement read_folio, a NULL pointer
> > > > > dereference occurs in filemap_read_folio().
> > > > >
> > > > > The crash occurs when:
> > > > >
> > > > > build_id_parse() is called on a VMA backed by a file from a
> > > > > filesystem that does not implement ->read_folio() (e.g. procfs,
> > > > > sysfs, or other virtual filesystems).
> > > >
> > > > Not a fan of this approach, to be honest.  This should be caught at
> > > > a higher level.  In __build_id_parse(), there's already a check:
> > > >
> > > >         /* only works for page backed storage  */
> > > >         if (!vma->vm_file)
> > > >                 return -EINVAL;
> > > >
> > > > which is funny because the comment is correct, but the code is not.
> > > > I suspect the right answer is to add right after it:
> > > >
> > > > +       if (vma->vm_file->f_mapping->a_ops =3D=3D &empty_aops)
> > > > +               return -EINVAL;
> > > >
> > > > Want to test that out?
> > > Thanks for the suggestion.
> > > Checking for
> > >     a_ops =3D=3D &empty_aops
> > > is not enough. Certain filesystems for example XFS with DAX use
> > > their own a_ops table (not empty_aops) but still do not implement
> > > ->read_folio(). In those cases read_cache_folio() still ends up with
> > > filler =3D NULL and filemap_read_folio(NULL) crashes.
> >
> > Ah, right.  I had assumed that the only problem was synthetic
> > filesystems like sysfs and procfs which can't have buildids because
> > buildids only exist in executables.  And neither procfs nor sysfs
> > contain executables.
> >
> > But DAX is different.  You can absolutely put executables on a DAX
> > filesystem.  So we shouldn't filter out DAX here.  And we definitely
> > shouldn't *silently* fail for DAX.  Otherwise nobody will ever realise
> > that the buildid people just couldn't be bothered to make DAX work.
> >
> > I don't think it's necessarily all that hard to make buildid work
> > for DAX.  It's probably something like:
> >
> >       if (IS_DAX(file_inode(file)))
> >               kernel_read(file, buf, count, &pos);
> >
> > but that's just off the top of my head.
> >
> >
> I agree that DAX needs proper support rather than silent filtering.
> However, investigating the actual syzbot reproducer revealed that the iss=
ue extends beyond just DAX. The crash is actually triggering on tmpfs (shme=
m).I verified via debug logging that the crashing VMA is backed by `shmem_a=
ops`. Looking at `mm/shmem.c`, tmpfs legitimately lacks a `.read_folio` imp=
lementation by design.
> It seems there are several "real" filesystems that can contain executable=
s/libraries but lack `.read_folio`:
> 1. tmpfs/shmem
> 2. OverlayFS (delegates I/O)
> 3. DAX filesystems
> Given that this affects multiple filesystem types, handling them all corr=
ectly via `kernel_read` might be a larger scope than fixing the immediate c=
rash. I worry about missing edge cases in tmpfs or OverlayFS if we try to i=
mplement the fallback immediately in this patch.
> > I really don't want the check for filler being NULL in read_cache_folio=
().
> > I want it to crash noisily if callers are doing something stupid.
> I propose the following approach for v3. It avoids the silent failure you=
 are concerned about, but prevents the kernel panic:
>
> 1. Silent reject for `empty_aops` (procfs/sysfs), as they legitimately ca=
n't contain build IDs.
> 2. Loud warning + Error for other cases (DAX, tmpfs, OverlayFS).
>

Tbh, it seems a bit fragile to have to hard-code such file
system-specific logic in higher-level build ID fetching logic, where
all we really ask for from filemap_get_folio() + read_cache_folio()
combo is to give us requested piece of file or let us know (without
crashing) that this was not possible.

But if there is no way to abstract this away, then I think Shaurya
proposed with failing known-not-supported cases and warning on
unexpected ones would be a reasonable solution, I suppose. I see that
Matthew is discussing generalizing kernel_read, so maybe that will be
a better solution, let's see.


> The code would look like this:
>
>     /* pseudo-filesystems */
>     if (vma->vm_file->f_mapping->a_ops =3D=3D &empty_aops)
>         return -EINVAL;
>
>     /* Real filesystems missing read_folio (DAX, tmpfs, OverlayFS, etc.) =
*/
>     if (!vma->vm_file->f_mapping->a_ops->read_folio) {
>         /*
>          * TODO: Implement kernel_read() fallback for DAX/tmpfs.
>          * For now, fail loudly so we know what we are missing.
>          */
>         pr_warn_once("build_id_parse: filesystem %s lacks read_folio supp=
ort\n",
>                      vma->vm_file->f_path.dentry->d_sb->s_type->name);
>         return -EOPNOTSUPP;
>     }
>
> This highlights exactly which filesystems are missing support in the logs=
 without crashing the machine
> Thanks,
> Shaurya

