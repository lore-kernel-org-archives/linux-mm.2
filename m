Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA63AD3B7DD
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 07:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15BF6B0005; Mon,  8 Dec 2025 02:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6FD6B0007; Mon,  8 Dec 2025 02:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDCCF6B0008; Mon,  8 Dec 2025 02:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC0BD6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:58:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5FA75C09F4
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 07:58:51 +0000 (UTC)
X-FDA: 84195552462.24.3DF639B
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 41B5A40003
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 07:58:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=G1wJTsmz;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf01.hostedemail.com: domain of heming.zhao@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=heming.zhao@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765180729; a=rsa-sha256;
	cv=none;
	b=71NpF6hWiBx+oCHIP8oa5CU3gVlicyoK2qKCqr9a3FQo8/xo88RciAcMKIZwETcQuv8DDp
	ZtriYBysDBVZlvGHnzHBqw3ExlKLjyQg3dd7UPAIkKHqX5/IA4eD9gU+Z/hLTo0TJZCzdP
	A77gp3UvjPizBumB2VbCWhdM6G7nbp4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=G1wJTsmz;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf01.hostedemail.com: domain of heming.zhao@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=heming.zhao@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765180729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZZgm3oSeHU0QU+gl2ilJ5MHbkqFnJ8nXr5Y2ViBPGg=;
	b=xM+Wramx7jrQJNfa/xD+eu+lEjVnuZnX48RQk0pDm42EzK2/pzY1AjQmCNOS8Uh9sl2mez
	c/Z4PrI2JpL7jK7zMJDAo7qvDmtQhsEFzquRsYBoFgxbY56IXJ7zmNqyg+CyLNYiOEkBwg
	ogzMPW0npXRdGBeajS3KCT6uPihPHbc=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4779ebfa91aso4104875e9.3
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 23:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765180728; x=1765785528; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1ZZgm3oSeHU0QU+gl2ilJ5MHbkqFnJ8nXr5Y2ViBPGg=;
        b=G1wJTsmzLJlEu7ey4C/ljmUQrl5zXMCvQRcfkZrg077/hAvDpA33bm6JhzuKdrTQvU
         S8dS0LPemlE3GTFHAL0j0+EJVu/rRSSAWOCGMmcfg5C1wrtVyBBbI08KGIcK6zwvH6F4
         vWUSnueAVOuNdSjmcDM83/sB/ULuBlhUhpZrnsnhmkdplLLFYXJMrsUn+/9lCgpGyEyg
         buN/sA2bmta1FvGvUd0t5dBlcS8SsKj5eW4fKbrdw9M+PXeXma44hhXQ7T2+BPg8gX7c
         J/IjgACnAHEEgukJOvy7V9sg9tfQqV3FlehXxwmj5/81bnaYaTHRO8kqKGUwDHU4BgBT
         dtzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765180728; x=1765785528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ZZgm3oSeHU0QU+gl2ilJ5MHbkqFnJ8nXr5Y2ViBPGg=;
        b=hrxvfztlxvFbgYjBaprRsSGJ5GIpMEUh7dubYDB8r86YSXI9khpVR+k1NefXwuNJnF
         n6XDBGek31PPrJQy3m0iubGck9Y5DUTq1oRVFk9fatJ6GqS1ocnCpf13QJgAyL4VMYj/
         3IpwuE1wX3eSHo1MVS/0Yp7GSt5s21sv31/bTiO+q6oHCzynlsntjAo6Vcpzb6QjevOl
         PXKyGbwJhaWhZZTLTTwT65oilGLbCCW8sw/vfVxnb//h+xPOJpCchZ6FWBzZ98qOFKcb
         tsSHyWaOZ02aRlittWv9gD+YYJQFkxPdgSI6irDyPM5iM75xAkOBDmKRE79esGNnKQXF
         EohQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4f4+sLK9V296ZP/DjMyPdIzkux4vV2+Sd4XZw+tm5gkOkMxred2lzzonqEiYen23vAggUeJ5Z+w==@kvack.org
X-Gm-Message-State: AOJu0YyRADxrwalU7Jlj5snjZtfS3KY8S2S+opHUSfc25OP4F30S9Fgi
	ceDGVMHAkl5UW3ERSj9wxwD4mJ//6vPR7DTbf0YlXpVDgXrwT3ZSqdgyelgtrej9Obs=
X-Gm-Gg: ASbGncs16WWBgxCIrAKElVzeciWA2QIckY6pmOb8pM8/mgQ9DpicFDQoaH00NYt52F6
	pEvIihrI0dWKRKdRgQJBXVLTk63LsKdKCpnfBYoLDBVtw2y12YZK4cjr56eiDeYy1PhF+nN/rL5
	7VVgk2eeH7ntXRBICaMwFcC0+ITjnX+pxgAw3iTd1Yw4v2kflildvIqjoUT85zfOChvVLQXm1sS
	4pXwNIzxaX3HS7LDAK6rJJ3TlQhkNxsnkOplFex4LpNlNOJ2auM09r+Bz9Zg0fMYYM18CaCiYQF
	H4r0Jnw8nQGFHCpXz4ShCK1JYtdQGa7o7wVyQrF4LsUxa7s1LApjCzs1tiQDdUuC+FnoXoGMBpb
	L7HnQ08CitoQGRXBn559Xd3de/JFVlUahAltuYHmJv1WeYaWsoTyxMQJFqPYL8PSOe7P9Yn8I84
	Ch+HWEio2aXA==
X-Google-Smtp-Source: AGHT+IFiE6r8sOKdpr/PzomB+sS+fM2rhbxC9kfkfyW0JiKMdyTzkMS5gaIPaG2/bO3ewHWaTbl4rA==
X-Received: by 2002:a05:600c:35d1:b0:477:aed0:f402 with SMTP id 5b1f17b1804b1-47939e882c3mr39326995e9.8.1765180727657;
        Sun, 07 Dec 2025 23:58:47 -0800 (PST)
Received: from localhost ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3bad4sm11393921a12.10.2025.12.07.23.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 23:58:46 -0800 (PST)
Date: Mon, 8 Dec 2025 15:58:44 +0800
From: Heming Zhao <heming.zhao@suse.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Dmitry Antipov <dmantipov@yandex.ru>, 
	Mark Fasheh <mark@fasheh.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
Message-ID: <nrgonfemkkz2bnwfkpzycfbz3luspjm65dakyjt4e4nuawklbw@cw3jqnedbyjf>
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
 <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
 <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com>
 <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
 <f72b8316-ddae-466e-a72d-0df9960d6c82@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f72b8316-ddae-466e-a72d-0df9960d6c82@linux.alibaba.com>
X-Stat-Signature: jxmganqu4edz7dunzu9314rxofsasobq
X-Rspam-User: 
X-Rspamd-Queue-Id: 41B5A40003
X-Rspamd-Server: rspam01
X-HE-Tag: 1765180729-782160
X-HE-Meta: U2FsdGVkX18QCd2EzZzyHvBmdvJSCPfxSkVw2K/4VerB8sRLjrjtq4AM5/uWQ9MbNlrKeMK6UrqXv/k2GpkqlA7EalUbDymxtUbsmg3V9RGUcv1o5SX/gkieSjk/E8yNVqafBZqpZAJu6AB6OzV4Kb2ynCec/KIFrWEMe6xUpYPUi+srqvCGkeacpwJMs1455mzNDFwmBbn7WsbSxQnRXP5PqU2pPBlItK5j80oO8YemUc+HThC/tanvQA/3DbIZfuu7lOvkln7xhLo4Cl81gwmeIDrGtQgk40KA+DWhZsNuKLcyU0vRs8MiY/bWMT6QdXNvNFBw0L+I7Jbx56Brg1nJ2juE/Ytd6bj4ct0uWmbz9g818BG9PGUr6lFn/R+oKU7w5cJ50vRUR2mrAL/+bvvct1NMR7dA3TOWj9d+IKvXt40Xxxm/SVDduvU8PW1OUQK64F2GVI4V7JTLDEhWD2rhHTQADejP0doQnya3BlAHlEigWbbi28F/eYHPjXuRSniv0Dy3UmImQCS5wP+ZvohXVW7LLaAzTq3S0p6R+E8GV2Lda4JERvl4k9qPwLWGaw5p5MUtbEdnKvQO75wMdR/i+ZN74YgelHp5jISrhn+nvnlQYP2n5YogLiX8FjXpbIdwscQkR6t00HiM5eFY2xVdaALfPwsbJ7Wk/mrYz7quA6Uy2XDmezswz6YOdEfkA4A1ADCf7NgSE7TAhkMHKkhBx7+MOjsDRL7tlejPnsWVcs4UGbPdms6oYfuih0J9JawvsT2+d90G4++hlkYCxgdp0SSdIoNEGcsIDVK/iJH1I2N+J+0D6CDDvjYPPuhfssf6hBqmBUtW1EOR/pZOuK172I2bYVnX3b7YMd7hTYG1tPQRzv591TIIIfmvt/vlVF+XActUO8SeTZ4KBr3NqAXdFY1etJIaYsO2D9zrwJVWbBkVHYJ0TVZRPwY0711lBMiSuElTWmmn0xPQtx2
 pkAUzY9m
 hblvaDZtJjeadFa2ZuukTqYWyHImz4Hvg5UOq22BoPoQowxU/Rspf3BGfYB35VJjqsugUYe9MczxiPRnkJ/7kDBppqzqbwpO6Zn/wTwUh4TUmzKftdl7TK5OxvaONv2RMlI5JtMA4PVT1ciO62SPd2QIOMw+KOw5+Ls257zT5EMhIpVWiljSW2F7guDarBJNIRMO5ZeH2e23aXE2YIVcWt/vAqAKkVRGUuz7gyUELs1RffKN93lnWYeKaGIicxlNtCLHo4rCr3Fu9MHUFhiTIJSkkfU44KEJo9ylDYicnzCvpGqTRUVegUR6BlEM6Wt+jmuZ4hsK72O8SMzo4RJIo/RVstS7Uhh1G9sekkbQko+44dF1dX3a/tQVMqDGgArXmrpWc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 12:01:09PM +0800, Joseph Qi wrote:
> 
> 
> On 2025/12/8 10:21, Linus Torvalds wrote:
> > On Mon, 8 Dec 2025 at 10:11, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> >>
> >> On 2025/12/7 07:40, Linus Torvalds wrote:
> >>>
> >>> See commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by
> >>> error") which simply makes the 'last' pointer point to the actual last
> >>> entry, rather than point to one _past_ the last entry.
> >>
> >> It looks fine to me.
> >> Sorry for the noise and thank you for pointing out my mistake.
> > 
> > Note that if my fix is correct, the mistake is most certainly not
> > yours and goes all the way back to 2009, and commit 0fe9b66c65f3
> > ("ocfs2: Add preserve to reflink").
> > 
> > But I would really love to have somebody who knows that code go
> > through it, and see if my fix actually is the right thing to do.
> > 
> 
> Go through the code logic again, maybe I'm wrong before.
> 
> Take the following flow for example:
> 
> ocfs2_reflink_xattr_in_block
>   ocfs2_create_empty_xattr_block
>     ocfs2_create_xattr_block
>       memset(xblk, 0, inode->i_sb->s_blocksize);
>   ocfs2_reflink_xattr_block
>     ocfs2_reflink_xattr_header

In ocfs2_reflink_xattr_block(), the call to memcpy(new_blk_bh->.., blk_bh->.., ...)
occurs before ocfs2_reflink_xattr_header(). Therefore, the new_xh->xh_count is
very likely not ZERO.

> 
> It seems now new_xh->xh_count is 0. That's means, it is trying to add a
> new entry and here 'last' is pointing the next free entry.
> If so, the original code seems right.
> 
> Heming, could you please verify this? I'm not familiar with this logic...
> 
> Thanks,
> Joseph

In ocfs2_reflink_xattrs(), when preserve_security is false, the function sets
'args.xattr_reflinked'. IMUC, it means that if users want to preserve security
xattr items, the args.xattr_reflinked is NULL, this then results in
ocfs2_reflink_xattr_header() not executing the cleanup jobs, (in the code area
defined by "if (args->xattr_reflinked && !args->xattr_reflinked(xe))").

Regarding the clean jobs:
- by default, it only handles three types:
  OCFS2_XATTR_INDEX_[SECURITY|POSIX_ACL_ACCESS|POSIX_ACL_DEFAULT]
- it cleans the first item and shifts forward the remaining items.

It seems Linus' patch does not handle all cases. If new_xh->xh_count is 1,
le16_add_cpu(&new_xh->xh_count, -1) makes it to 0, and it will miss the cleanup
job.

Thanks,
Heming

