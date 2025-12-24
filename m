Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B559E7490D
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 04:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA91A6B0005; Tue, 23 Dec 2025 23:06:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56996B0088; Tue, 23 Dec 2025 23:06:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958F06B008A; Tue, 23 Dec 2025 23:06:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 868CF6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:06:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 333161404EB
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:06:32 +0000 (UTC)
X-FDA: 84253027824.19.69AADA7
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6ED2C100007
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:06:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=On4OwG1f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766549190; a=rsa-sha256;
	cv=none;
	b=cxrFVLfi9e9jB4Yj8WFzTkWdgytyE2tQw7TeFpNsZWOPRQUuJ2lH8DueNSD84QdSiOHG9s
	Hosvp/SN35gZNieRNrJBoElEFoOfKSvLs8I823kjvGBK4Jj/cpb9kz3VjiHL74Mo9iWB5D
	8ymUx/ZEmhRuTbRy8AdDWrhzpOrlVF0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=On4OwG1f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766549190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXrYLXPtyADbkpCPhye6vwcYC3MDDrqUQyT/zKh32iM=;
	b=Sa6ssIlU7bBWac9/Vr2zgmh8dWjCrrdwB6Efy3aHck5+s1gyhZ/1aR+aMKw3GeY8ernJ7V
	YNK8GgnuHUzuXeejjIhm3WrnKNJc4k4lrNMPwqjvhMMdt8bWO+Cnwffl8EuJkOhR0fbx55
	Lu0Ev9tv6weGNzFvEI2F/tQ6UzuRJeM=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4f1ab2ea5c1so74052341cf.3
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766549189; x=1767153989; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hXrYLXPtyADbkpCPhye6vwcYC3MDDrqUQyT/zKh32iM=;
        b=On4OwG1fPFm7IlhTyJ3sVLhRxLaaXbvgR0+m4Fd9Ps435JY45ynjg3YHU1QVsYBURO
         pkX7H+OCFi/3UJlhP3PZwDKzvm95dgOGm8ut3lwMI1NpSEcY4GtRjWWieVOF5Lq07a6m
         O1TYluuOyIfgyzA2MT8FdpmPUt5nMyhbpFJ5TLzMM54/nPA4uURWP8GkDGPv82m4loGw
         jGv/7EYZSegbXWZ4OPzPFtTEnjCRYLTf1n7bTtJctY3Mt4Jtjohn3iYfPVdvHp7uY4BC
         +1+URKxtr1f5Wbj4g/Bp67ryVPbxwpYPjZ2nFtjG4n4I1I1c650+WK+MepLeC3rWeQHI
         gy2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766549189; x=1767153989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hXrYLXPtyADbkpCPhye6vwcYC3MDDrqUQyT/zKh32iM=;
        b=u43kyhJASqA5kcGuIxVW0I8qW1AXD6kqWFfzyEVdPEv+cDYyzLeQv4lW7LRFmsHfCf
         XU+KcmeNW1X1dcMbyjiciPWq+uQgnOXmMA6qV6gpZdhe8hfCk/Y+Ypd7EInL5tI+uAR8
         GtkMHMzFyzsc4iLQSsgtJMUdpjXRVjr+OooKOP93Gl15aXBf6Y6kuTi8DoZenotI8hgY
         FdanoXTWjDJRHn8e0sSghYisGbnpWZUqBRP7bt63rWTKg2g+42WfSe6IZXpIx1gXMNCW
         x5Hw69cu0RDkk8zkKBsQOPcJ9VdzFKHXi3E8dVMZewKUm7yplDB/LFNysYUo02mY/FFR
         eAbA==
X-Forwarded-Encrypted: i=1; AJvYcCWzMAc+Wy0Z3Th5Z4jRC8lScljGNGpt/STLjV5Jdrh8lfct4lagMMtz1fRXRB1Sya5IV4zaVkh3tQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3j69I0tz2kuxfQoi8pCFm0w8jbivxaUKk2yBpzNErG0CDTzF6
	Zuc9VhTAq0CoszF8pjhrfAPbsTDbE+P+q1Cr7KugAZn5PH3V99VREw2EapEeo/pB
X-Gm-Gg: AY/fxX4428VQ4XaIBU+pxe2uQ9mlDv0MKaNmMMCkJ/XkYvUDRmYsesuLp43g0SkBYAu
	4fa3tdsbXINbjuwstY5KhUNkl06WpOhBchroOIxiejny7woR5DOiWLYsu/jRYyygPRvpL/wz/sm
	7p4t8DgVwReHcYQai7KwwJXa1ycpDWxDrEZyNgBE6RxfPSVGGpZGTRG0gFQOudbFfRsqS638cgp
	ANEOq2g7H7uPbQYFPW0KR6a4pT06icFE5x9LVuaAM8gsIivECgqD5mJXJqV0JV4ZKNB6eVkr3Ri
	t7x4vpz8FgRiIB8icSfotII8a9/U+0m2CsUJr8Dlg+ScCKXfAuWRJDBJXMk/fi6HO6fYMSRILWw
	ZkK5I+mz0L7Kl8G+pl6nnpvjOUdmHzfTLgdTGWbHhi9RpyvB4De5rfPpLNTaMpifzM4llc9Bk1P
	M4xGOlNfgnMATc
X-Google-Smtp-Source: AGHT+IGpzSIvzsx58mdl/niocf1lry49aUnkUvSKw/smczxKOj5NW9s7CL7SDZBEFPmEs/fVAONFmQ==
X-Received: by 2002:a17:903:b90:b0:29f:301a:f6da with SMTP id d9443c01a7336-2a2f2a34f54mr156498915ad.43.1766541873732;
        Tue, 23 Dec 2025 18:04:33 -0800 (PST)
Received: from barry-desktop.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c8279esm136373295ad.28.2025.12.23.18.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 18:04:33 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: baolin.wang@linux.alibaba.com,
	syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
Cc: 21cnbao@gmail.com,
	akpm@linux-foundation.org,
	bhe@redhat.com,
	chrisl@kernel.org,
	hughd@google.com,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	pfalcato@suse.de,
	shikemeng@huaweicloud.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] KMSAN: uninit-value in swap_writeout
Date: Wed, 24 Dec 2025 15:04:21 +1300
Message-ID: <20251224020424.52976-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <9bbc1962-5f6f-4e3c-a672-d80565aa5157@linux.alibaba.com>
References: <9bbc1962-5f6f-4e3c-a672-d80565aa5157@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6ED2C100007
X-Rspamd-Server: rspam10
X-Stat-Signature: b35hysnr1rtfk585fmp87tacrtsi13ty
X-HE-Tag: 1766549190-261493
X-HE-Meta: U2FsdGVkX1+qqyntxJ66NrDZ5ScJrDtMFNUcHR0iWrbHFBNjEm4mxBx75s/TPMUtqpY3kRZ0YSVPPrawgX8hQlJ0e5YsidJPytHqHwgGU2/xGxuXqkTjdEkNTRf9W4kSD8bXhpDPfwn4+aw+bzHeuck8G1QygH2BvrqhlL9jHqSAFyx4olm8b9ksW1IwE79AndoGcl2r49P4oC77tq0zORCWodoSfUDhd5zwRHPzXgM7bsaGiaZDbEx+59JVpv2ZJCl4SEHkyBpahGXeeoSFE2/hH3EphxcLGMFA6HPPrffa8Bs23mD2W9Q4UVD61E7Tnstwq6bLrF7GyoIboKllppmF51SAGvHJMPaN1+OJb6ISJbHQuU1jEmsrTkXjGlRZTiGO0bTtlJnzksjNAMKml+YKi5vxjmGCKT0okZyMKzp3Rto1Fl8s20Hay3ea5tfGmpSK4ggiol2YWd0XBgMjh5VpCa7smg+inAp2RdsSIwWR9NcV4Kk0vYRPFA7eLqkrJz1LgMV7M4GVOLU+bWR1+XwqH2u1KviEx6Rtw+XErSGst3gKxs9cBmEegV5pPvnEU+uijDmZGDB1Oq90ARj8wsKbwNy5Vsw6TjMoGu0ji6aZFkVk9qmMnJVcF1NVG5M0LkBRF32PzNMZ626PTnL29pHd+hkQzfBuuczSQ/w5wwxBsGDbJorkOlspBpnrbbgEU/6N53LRIX6v39ONwj3XDueHDe1CiElxzo2532a66gnyC9K2vz6ppwyVzlPLR+nvntuPEz7XxGuKH/lCxj3CCGskShrl6ZLL94FdPLnplzcbqXWMzy6tfiEz/HQMviIQ2JjeqKVEygrvw7GVp/P2YjG7avxUJlh6c/SD12DAwa6G6JO+888kKtJOt8XD0s3isyjUbekIrTR6Fz65b1Dvsq7vZzgzWe+6M+cbPKyKTI7oy0xR7VCe5VYtSx3g+0z6gfmN62rWZvbfiHfwKP4
 sH31eUAN
 xro8Z4XScrDoxNv8/3E61Yh3yxptMgAdGGDVA9bOLqKJomQP61ac6TlfrAZmo9M49K1jVE3aiRdPeTelwMzrSq8mYCtRCevVQRy33K5G5M9ai+ov4xQFGEJ3XmIWy4+Kps2WGAX9PWE7U0YdYB6CywLaDm7gBGXlkFB30+6BHWmM+CLNpaFGB1DoK1EQxY1jPcxvoVQBEZU6qEJ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 2:43 PM Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 2025/12/24 08:16, Barry Song wrote:
> > On Wed, Dec 24, 2025 at 12:43 PM Pedro Falcato <pfalcato@suse.de> wrote:
> >>
> >> On Wed, Dec 24, 2025 at 11:46:44AM +1300, Barry Song wrote:
> >>>>
> >>>> Uninit was created at:
> >>>>   __alloc_frozen_pages_noprof+0x421/0xab0 mm/page_alloc.c:5233
> >>>>   alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2486
> >>>>   folio_alloc_mpol_noprof+0x56/0x1d0 mm/mempolicy.c:2505
> >>>>   shmem_alloc_folio mm/shmem.c:1890 [inline]
> >>>>   shmem_alloc_and_add_folio+0xc56/0x1bd0 mm/shmem.c:1932
> >>>>   shmem_get_folio_gfp+0xad3/0x1fc0 mm/shmem.c:2556
> >>>>   shmem_get_folio mm/shmem.c:2662 [inline]
> >>>>   shmem_symlink+0x562/0xad0 mm/shmem.c:4129
> >>>>   vfs_symlink+0x42f/0x4c0 fs/namei.c:5514
> >>>>   do_symlinkat+0x2ae/0xbb0 fs/namei.c:5541
> >>>
> >>> +Hugh and Baolin.
>
> Thanks for CCing me.
>
> >>>
> >>> This happens in the shmem symlink path, where newly allocated
> >>> folios are not cleared for some reason. As a result,
> >>> is_folio_zero_filled() ends up reading uninitialized data.
> >>>
> >>
> >> I'm not Hugh nor Baolin, but I would guess that letting
> >> is_folio_zero_filled() skip/disable KMSAN would also work. Since all we want
> >> is to skip writeout if the folio is zero, whether it is incidentally zero, or not,
> >> does not really matter, I think.
> >
> > Hi Pedro, thanks! You’re always welcome to chime in.
> >
> > You are probably right. However, I still prefer the remaining
> > data to be zeroed, as it may be more compression-friendly.
> >
> > Random data could potentially lead to larger compressed output,
> > whereas a large area of zeros would likely result in much smaller
> > compressed data.
>
> Thanks Pedro and Barry. I remember Hugh raised a similar issue before
> (See [1], but I did not investigate further:(). I agree with Hugh's
> point that the uninitialized parts should be zeroed before going the
> outside world.
>
> [1]
> https://lore.kernel.org/all/02a21a55-8fe3-a9eb-f54b-051d75ae8335@google.com/
>
> > Not quite sure if the below can fix the issue:
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index ec6c01378e9d..0ca2d4bffdb4 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -4131,6 +4131,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
> >                       goto out_remove_offset;
> >               inode->i_op = &shmem_symlink_inode_operations;
> >               memcpy(folio_address(folio), symname, len);
> > +             memset(folio_address(folio) + len, 0, folio_size(folio) - len);
> >               folio_mark_uptodate(folio);
> >               folio_mark_dirty(folio);
> >               folio_unlock(folio);
>
> That looks reasonable to me, though I prefer to use the more readable
> helper: folio_zero_range(). Barry, could you send out a formal patch？
> Thanks.

Thanks, Baolin. Let me request a bot test first.

#syz test

diff --git a/mm/shmem.c b/mm/shmem.c
index ec6c01378e9d..835900a08f51 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4131,6 +4131,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
 			goto out_remove_offset;
 		inode->i_op = &shmem_symlink_inode_operations;
 		memcpy(folio_address(folio), symname, len);
+		folio_zero_range(folio, len, folio_size(folio) - len);
 		folio_mark_uptodate(folio);
 		folio_mark_dirty(folio);
 		folio_unlock(folio);
-- 
2.48.1

