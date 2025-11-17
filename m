Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1AB9CEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 14:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DD888E0011; Mon, 17 Nov 2025 09:10:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4AF8E0002; Mon, 17 Nov 2025 09:10:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1AA8E0011; Mon, 17 Nov 2025 09:10:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0559A8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:10:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD6DDAFDAD
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:10:57 +0000 (UTC)
X-FDA: 84120285354.23.768148A
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id AEC3220012
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:10:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=vjti.ac.in header.s=google header.b=MNkx+oZG;
	spf=none (imf03.hostedemail.com: domain of ssrane_b23@ee.vjti.ac.in has no SPF policy when checking 209.85.214.180) smtp.mailfrom=ssrane_b23@ee.vjti.ac.in;
	dmarc=pass (policy=quarantine) header.from=vjti.ac.in
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763388655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IGIlUhwcW4Oy871xAlA/Pf+rhr+iZnkvTchf2PcaDVU=;
	b=TLmAGnbMOTQmQRfSe5CeaKlAOHv8Xd9xYFgggtO8cVbI9BoxWGoO66L1IJaroi3UKlBLRp
	cmkv8CJ54XzuLsque/ON33Bfj5NdVj1jbbqXIGgNJzfmFjGYgPVXjQ2OfELA5d6g3AuF5S
	0LBr8Az4kT5zwlpzYpnm5SFXX3LC9Fo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=vjti.ac.in header.s=google header.b=MNkx+oZG;
	spf=none (imf03.hostedemail.com: domain of ssrane_b23@ee.vjti.ac.in has no SPF policy when checking 209.85.214.180) smtp.mailfrom=ssrane_b23@ee.vjti.ac.in;
	dmarc=pass (policy=quarantine) header.from=vjti.ac.in
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763388655; a=rsa-sha256;
	cv=none;
	b=YFz0zUSt9E1wF0LFMa1Tp8sq8j9o3LT1TvfC/rLqdDyz8RVDuqMznKxvfN4b9BMzyhxsG2
	LjH8311aWPtrbRzowFyGuw7iucX4gO96Qrq+wISQjxG6xtO8p4DKxS7fS73fdFx0DlMFOJ
	qm6H5h/Cq0/mD6sDTHZtP/Bd2VzE10w=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-298145fe27eso57073635ad.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vjti.ac.in; s=google; t=1763388654; x=1763993454; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IGIlUhwcW4Oy871xAlA/Pf+rhr+iZnkvTchf2PcaDVU=;
        b=MNkx+oZGGI1TkSN/lFXNM1H5LRBB389jk2zhqmzZpOR7OkKhZOXo9fwOXllPq/QaWd
         MGUmcIp5+dXHD7ie7jnt3ASnkhn3YFNB2QiFnTFCz1a6oOE9mTnmY2MbNC7A/OdjxT6t
         4IX9cFBdJwiMMdv8xeafAmnxhuc5Zk23PkPBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763388654; x=1763993454;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IGIlUhwcW4Oy871xAlA/Pf+rhr+iZnkvTchf2PcaDVU=;
        b=Ze69TK1dxXVckA/+eWmLWPeuqyj3m8NoSsw+WcJy/VEfHJUADFi6Q7oQAUL8CtRYaT
         p1AvA27YpHzQizFYq4lswXk5YCrZCMv4jpIzFxdvEFfCi/tDlUEtEkaCzt8CxYYO6NJj
         cByTYODyzpfO301tRY9McokYjqNDBwOvTUU214ZGZgnGHTgz0SoPa2CgM7dQ2nhC5MK2
         JKXfJ40f/9LyEQ2LXRFSk6nJzcydKwxv6cWrNDAzhinPKEq08XWT4wz29AIqvzi4Y2D7
         wvvgYBm7lK6X6YRVcPEPlLRekcNvV3nVUqAJaMoE1HnOJfdl0XmeQW1RK9R5FcVPmrUS
         GKuA==
X-Forwarded-Encrypted: i=1; AJvYcCVVuWWAJeeP0QX5+1ekUvEgwsb6IPkKUu/Yanlz/vM3Vlb3zIOeMJ1A3TN2jQxt0GWKCHq8RB37zA==@kvack.org
X-Gm-Message-State: AOJu0YxfPDMLDl2IaFgWRLBngk/7ItMqobWF+LNQp7kMiLWzpy6xsv3L
	QkMeyniz/rhqkdwba+w2iAMuXYEIn41z1+EPDVMtVjINgfosPH0wESGbjB3L5GxHtGc=
X-Gm-Gg: ASbGncub3jvxWpBrbWYg7jhuwVvI6dfSsHEK4D/eOv4gvARBfwIL+aHtkcAt4C70RXu
	36qeG7D2dt3ck5AXpbyqsvoOKzuYw/Te8d+Pq2pD4RxhnYSvubIG5Fj/wrZjZ0Fk3AYOlui6mx0
	gIFBIIIKWkjn9H+BDbqCyWFDhvXl9TqVd58H4iNGnBAqU1WkwJpLSTeXPQhpXulzUbrQcv9UHeU
	DO6nxHSVOnYTnbBhwJzVMTD3rIx8npTUyZGWduIrvS+0Mqyj85qIpf/leow8itJT7IDvvt7/wFK
	+jQP2EzlLxSYcB3u0aXdK4SxhKHDUKTli41Lw4/RDAPfPGgxEYnDmb0uKYoE0VP63822KZTp0R/
	Ms1YJ2j+Wfig4InP2LbrdBj8FhxnTCUePxw8Lvry87J9K3ZK7cwvK6AJO1huNCqjN+4zx5WldCv
	6UtQ2TmDQQoYIQBImhQoqzUGdw8RDH+AkGlsTAkPPMVZrGF/m1
X-Google-Smtp-Source: AGHT+IGpmjetQdMYOQuuR7kG1GZkoPWMou40quIaqM1bcw0cREwgl582S5zRn/xRIwFNmTYkE5eDqQ==
X-Received: by 2002:a17:902:c405:b0:295:596f:8507 with SMTP id d9443c01a7336-2986a5fbf9fmr167840905ad.0.1763388654266;
        Mon, 17 Nov 2025 06:10:54 -0800 (PST)
Received: from ranegod-HP-ENVY-x360-Convertible-13-bd0xxx ([2405:201:31:d869:ee61:77ad:1f3e:2b12])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2568c1sm139768835ad.47.2025.11.17.06.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 06:10:53 -0800 (PST)
Date: Mon, 17 Nov 2025 19:40:45 +0530
From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, eddyz87@gmail.com,
	andrii@kernel.org, ast@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in
 do_read_cache_folio()
Message-ID: <aRsqwndQ459VN8I9@ranegod-HP-ENVY-x360-Convertible-13-bd0xxx>
References: <20251114193729.251892-1-ssranevjti@gmail.com>
 <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AEC3220012
X-Stat-Signature: fc9e6u8xkxsffa5tskqrakxq4s8t7hst
X-Rspam-User: 
X-HE-Tag: 1763388655-471971
X-HE-Meta: U2FsdGVkX18j7ipL5iiOBAo2u5I+ep6Y+5dOs6+1PSTxy5bViERKTB53L5Etg77g0qbNebQDcEBKWiwYoHktE4ou9oIwEHuWta6gwDyOoVXBhOZQsGPpxKzafsBXbsnVgUQOGL0jAW/pDSWoXxL/kDj4libymYXrJeRn9aM76uDpcNj1rL7KFcT5FBHueqMnO6lDowAehpS36TOUB0r/QFmXix4m1PSxoLi53Te104GorOo+g6odqo/5lOQupyq0bcpdaoNC+UAMMIAoOmdU+Wo6mvfrybD66u5LPl9LSLKbYlKu5jLz6BpS+wcHidGKPSjUdWnZt9UsDlM99vObt9wZl1iOu3h4n49bWlEALMmyO9uHxvAvSdRSthC75WVQ6TTI7XTqv0YeWk3nEdhZY37VRTcys+X+Zphr/qw6SeSDXOrumX+QNIovVLBgvCBWsWKDTnC1beGr3O42CiITm7igfNM9SDvdt5KwS4w1Xcbr3Y1EW/CFW/k1FIZHoi2YFHG0cOJfOlq2Iu+dnNPcbPf7gAFcsFMVPpWCcxyVaWbLlp4CfsFgfCFffrYR9OecdchxGykGrakVSXP/qj2vXypq+sr/ivC+gaGVeY6nJ0McaClY1CkOLwUqAdqcrGEVAkEZyD/SdEEZ2LJTRFuoPte3T3lhODAhyGV11Fg25JEivfiLuiEovUMz8bnfsfckO7ekg0qFA6V4XKGtJQWlBO+nfHbBdVgKN/137inWUxGZnI5M8LOhqb+OYwtN2KYM99pCehbkkgLs/PAfS6JATVsiEPiJyDm+Pnz3E/6Mx6D1hXyajBHFgNRzcMfSCpTDcfxEbmNdFlISIHpyWGBBE2zxwIoxeBgXhASZsxTMlwEUKcNNMym9R8nwLq1/H07STkz1Gn5hd9JWe6oakPEftWnWF3YnnFrKryvVmQf6HKfQanX9ggcYgoSloO2Fal6rXD8SWApGVEMDjlcB0Id
 4QZVT8K5
 O5jMxKtu8gFdNBUUqpPgXw026yZSp+csHEU2FTXUUzBW0Sm9a+USeUe3TGgJl8nwkiPAtmuSD0fHGCDrcTo+HPRIIWjiC5ynHCe5WuOaZEniAzQvksBopPjDMkcI4+xsbaRARY+O2VHNsgJ9eMXHWDkD3hJGqaQdiE90kRVjsLYL8KNWakXG5yelP1alYQWpQNbaEyLHsR92IGCCVOx10QLrbceZCkFZVSfAbD9QV6u/PqBGuLsOBFMTESdZjNBdp9uW7nqkdYuaGMu13agIB1uMpSNJQ1m0Fn4L8tvoHCnYuYwiIGIvRgWGyjC/6LnjFiUggs86FycpLkeSokhKnrTFVfATZQHflI56usgBdgCQMpll/v5Wy3pV2ELBeolwj9OZyiG/MtOdXjhES6uNedc4MLusFLaEy+7Le6lPxS7iQYHG8ZX/keBRo/RbYpgwa3KCRsEHVwdI2trU602gzth2W16CtPc/kkLlXnkzxKW21rlmD7Q+iIK8HIheZO5ADyDnTKNqu4/XAMciuUxabPEYdzPBYuduBcaOmMLoDHsnILJfkKlXT6MvtUi24BPMWVaHAyt6tXFRUMJA6eUc361QXN21F1KLOhJKH7moEMrQMneg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 10:32:12PM +0000, Matthew Wilcox wrote:
> First, some process things ;-)
> 
> 1. Thank you for working on this.  Andrii has been ignoring it since
> August, which is bad.  So thank you for picking it up.
> 
> 2. Sending a v2 while we're having a discussion is generally a bad idea.
> It's fine to send a patch as a reply, but going as far as a v2 isn't
> necessary.  If conversation has died down, then a v2 is definitely
> warranted, but you and I are still having a discussion ;-)
> 
> 3. When you do send a v2 (or, now that you've sent a v2, send a v3),
> do it as a new thread rather then in reply to the v1 thread.  That plays
> better with the tooling we have like b4 which will pull in all patches
> in a thread.
>
Apologies for the process errors regarding the v2 submission. I appreciate the guidance on the workflow and threading; I will ensure the next version is sent as a clean, new thread once we have agreed on the technical solution.
> With that over with, on to the fun technical stuff.
> 
> On Sun, Nov 16, 2025 at 11:13:42AM +0530, SHAURYA RANE wrote:
> > On Sat, Nov 15, 2025 at 2:14 AM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Sat, Nov 15, 2025 at 01:07:29AM +0530, ssrane_b23@ee.vjti.ac.in wrote:
> > > > When read_cache_folio() is called with a NULL filler function on a
> > > > mapping that does not implement read_folio, a NULL pointer
> > > > dereference occurs in filemap_read_folio().
> > > >
> > > > The crash occurs when:
> > > >
> > > > build_id_parse() is called on a VMA backed by a file from a
> > > > filesystem that does not implement ->read_folio() (e.g. procfs,
> > > > sysfs, or other virtual filesystems).
> > >
> > > Not a fan of this approach, to be honest.  This should be caught at
> > > a higher level.  In __build_id_parse(), there's already a check:
> > >
> > >         /* only works for page backed storage  */
> > >         if (!vma->vm_file)
> > >                 return -EINVAL;
> > >
> > > which is funny because the comment is correct, but the code is not.
> > > I suspect the right answer is to add right after it:
> > >
> > > +       if (vma->vm_file->f_mapping->a_ops == &empty_aops)
> > > +               return -EINVAL;
> > >
> > > Want to test that out?
> > Thanks for the suggestion.
> > Checking for
> >     a_ops == &empty_aops
> > is not enough. Certain filesystems for example XFS with DAX use
> > their own a_ops table (not empty_aops) but still do not implement
> > ->read_folio(). In those cases read_cache_folio() still ends up with
> > filler = NULL and filemap_read_folio(NULL) crashes.
> 
> Ah, right.  I had assumed that the only problem was synthetic
> filesystems like sysfs and procfs which can't have buildids because
> buildids only exist in executables.  And neither procfs nor sysfs
> contain executables.
> 
> But DAX is different.  You can absolutely put executables on a DAX
> filesystem.  So we shouldn't filter out DAX here.  And we definitely
> shouldn't *silently* fail for DAX.  Otherwise nobody will ever realise
> that the buildid people just couldn't be bothered to make DAX work.
> 
> I don't think it's necessarily all that hard to make buildid work
> for DAX.  It's probably something like:
> 
> 	if (IS_DAX(file_inode(file)))
> 		kernel_read(file, buf, count, &pos);
> 
> but that's just off the top of my head.
> 
> 
I agree that DAX needs proper support rather than silent filtering.
However, investigating the actual syzbot reproducer revealed that the issue extends beyond just DAX. The crash is actually triggering on tmpfs (shmem).I verified via debug logging that the crashing VMA is backed by `shmem_aops`. Looking at `mm/shmem.c`, tmpfs legitimately lacks a `.read_folio` implementation by design.
It seems there are several "real" filesystems that can contain executables/libraries but lack `.read_folio`:
1. tmpfs/shmem
2. OverlayFS (delegates I/O)
3. DAX filesystems
Given that this affects multiple filesystem types, handling them all correctly via `kernel_read` might be a larger scope than fixing the immediate crash. I worry about missing edge cases in tmpfs or OverlayFS if we try to implement the fallback immediately in this patch.
> I really don't want the check for filler being NULL in read_cache_folio().
> I want it to crash noisily if callers are doing something stupid.
I propose the following approach for v3. It avoids the silent failure you are concerned about, but prevents the kernel panic:

1. Silent reject for `empty_aops` (procfs/sysfs), as they legitimately can't contain build IDs.
2. Loud warning + Error for other cases (DAX, tmpfs, OverlayFS).

The code would look like this:

    /* pseudo-filesystems */
    if (vma->vm_file->f_mapping->a_ops == &empty_aops)
        return -EINVAL;

    /* Real filesystems missing read_folio (DAX, tmpfs, OverlayFS, etc.) */
    if (!vma->vm_file->f_mapping->a_ops->read_folio) {
        /*
         * TODO: Implement kernel_read() fallback for DAX/tmpfs.
         * For now, fail loudly so we know what we are missing.
         */
        pr_warn_once("build_id_parse: filesystem %s lacks read_folio support\n",
                     vma->vm_file->f_path.dentry->d_sb->s_type->name);
        return -EOPNOTSUPP;
    }

This highlights exactly which filesystems are missing support in the logs without crashing the machine
Thanks,
Shaurya

