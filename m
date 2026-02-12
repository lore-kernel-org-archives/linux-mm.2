Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59DE8EE36AE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06446B0088; Thu, 12 Feb 2026 12:45:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0656B0089; Thu, 12 Feb 2026 12:45:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88BF6B008A; Thu, 12 Feb 2026 12:45:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9AB266B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:45:19 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6386C13A074
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:45:19 +0000 (UTC)
X-FDA: 84436531158.27.7479C3A
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6482EA000F
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:45:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R8tpChrm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770918317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/EHFFOB0IIr1DJv5VOrfT4oZYq8P3Ee1hiCpoYhkvA=;
	b=8LV1MZmZYMOp2S7twYtp+XXSLBaXAQZyunLvxCNgKd2BFqExxBl770FEEIoU1MysYlw+yz
	NRrXgvSuPsyMJlDimSyjkln4RvmamVTlJg0Z7qR9OZBmurjSN5+6rvcDfrWhiDyer6dXQC
	wRNvtqRTts7kFOzGPdLqOXekVg/AgyM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770918317; a=rsa-sha256;
	cv=pass;
	b=OSSULaLefjL1lQm3e4k9TdUuCqZfJ9/1VShuE5vtIXSqKyCNm3fZ/GT5SOtACT9ecMb8oT
	cpSDv0ZdVBnCME3mCkBikN+RnayxiHmmRClHcVVieh9bPGZE0qQZK66qlTmP1Xch5E0oXP
	px8LhAa0XnbQpUhA6jbdGOzyzNgNZM0=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R8tpChrm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4806f3fc50bso1402865e9.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:45:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770918316; cv=none;
        d=google.com; s=arc-20240605;
        b=WTmWV0egzBGhb+Uh3mkvmIGk5tmKx0jPfMaStkIEm1tpkKG0fifelYsm8SOD1Ed8ez
         1+vNqtkYEQgkG7r7nSxsiM+Yo9DR9l5+nFQGKQ2r9jZiEZ1BK6FVGyRWGVMo5XU00slz
         murEwGSAjkEPOcagKXmYlJ2Y11M5h6YUqLNoBTdbwSFP/HvpSfzAC/ZaiyhLcnAwBnpf
         2jhVDbYhY6xgYcWOaPwr2rPWLOhfaCBvF3Esn94sFQYerFuAYilsRJUP+Yo4DulhtI7r
         h6A1sCZ8Nu2cT7VnwY4RPeSO2e92HlIrb9bEuy2D41O1mHIIzCJQZ5ftGqerUMdIrfOM
         k/yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w/EHFFOB0IIr1DJv5VOrfT4oZYq8P3Ee1hiCpoYhkvA=;
        fh=BunrjKy5p+HOXa1v1BhdB83GBr1Pco1u4QHhWR15jOM=;
        b=kkwo83IVXtfpNUjur+98am6O7qw4gEX8sN9EfZO0EEjtLn19UGNrcoFSMG18Qe6Pok
         eJXEGLZi9x+2mBCds3D9PVocp6z1EsZqk8Beq0IqTfPDkFECh4ynAszTa94YHH053CXY
         IELoJXHLq3CQKlbp9dfguxF7/2jyNahwmGJZg3v4M8G+YeamVllBeARgrkyps6ToeTRF
         RnHfInQcmdjV/bk9vSV8DId2GZzTZKd43pbUSI7k4aSz1xmQD1wrDPg74NEjevXSPN6F
         1SjHhOYTAJ3dx4p6iXaNsXCZbzJq2Jj1lmCMCxRpZr8GZBwU7+ViAmh2Ogt3tIH8Rrds
         +oNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770918316; x=1771523116; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w/EHFFOB0IIr1DJv5VOrfT4oZYq8P3Ee1hiCpoYhkvA=;
        b=R8tpChrmuQ3Gam4ojMoKv9Rn0dINDp9HTOYXfOqxoYqVF+LyqM3ubXwOXM2ldljOkL
         NvvPBJ7ktMMd+e+5rsAJMxfCJj/0U8+eVAC/LrMWlB0ZN9FmgjFDleN2wtzif975NmCS
         c4dH+DFVedY1dmiHrrkdsFFR5zGSwzi6FPD1b26XExr5Db+jkjHOkqGL7s17EQ3IFi4W
         8trfIGpHAYqkY3HFRwYhoyPg2USSRit8d7aBVh3ToojSigjE1+U0HgnazfU3T3wTByRk
         PwIvvBRWs6K6xQ0BZrnr8YBWpopSaIJWEwzqsOKks5tzs5bn1qjofAb65tNnSc5MffYa
         cMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770918316; x=1771523116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w/EHFFOB0IIr1DJv5VOrfT4oZYq8P3Ee1hiCpoYhkvA=;
        b=CaXrmwJ2xdok62w58ojwAjzAbfIqblyaWfLR6uREeuMSF50LTM4b8qzw/1Mdr2Zqcs
         wswt3OpT1xP/NGKKBkZmQ6yXqWVeykVbnpMVjHN5MwzgAu4llUgj88EoTIME1yEsHjBx
         uDmwznHwO65kp1ihKWw9C+Ov2QMzKZE1uFUczY2WMxKuM8m4pRsP3EgzSzdmGh9ADdnb
         Mpn3/SVemlt6BEQoSzZ1DhoW4J5X65n6IqulamRVTaLHsqVkwqR/po95QmSW3CdBBMqQ
         4bS7QBK2pEsCc/2iCa7kJdq6HAtiTYh3ceWtXRgc5JwjcSFadtG+hwxDzXRztBfo56PK
         ttHA==
X-Gm-Message-State: AOJu0Yxl7KL3Gfqfi53GG69mLAyaFZUtTxbMH6N2r/xvbwcuBhYlXhX1
	ale1p7fWXhu5M0iqFf85NoloHFh/t06OKyPSD4NzYOzFRpkDrvM1iRYYqV4r3kYaZpkSEmfdYqR
	oB1lH41vN1dboIG+uvPikW4ggyb+2HrI=
X-Gm-Gg: AZuq6aLDEO2HOgFc21BuJgQXe1euQCRue/wHRXJitmiedtfjCcwgaXmW9srWMPR2Jea
	KwDyMvGojcHLDQHDwads0cRgvwwGKdjnukandGFO87NnOL6fKcM8wSqrScnz2kbWq8vs+oVgbwr
	yr59iyolmU4SVJjVXSZpMkU8nARUfdNwPRA+hTsGEJOfNS09nzzdAwUvbDNgMxPKdipncksRPO8
	89ZdzTbt1zHNaMRNmYyEiXBwrXaDxt0Xpcarug4IxME+VYvm/GFJNrlKZ+vc04Eqa2CWn4YTYA+
	9EkfeIYi77g4XUVLBtxEWW0egpv2scAre8slpUI=
X-Received: by 2002:a05:600c:5288:b0:477:b734:8c53 with SMTP id
 5b1f17b1804b1-483656c6081mr56278375e9.12.1770918315882; Thu, 12 Feb 2026
 09:45:15 -0800 (PST)
MIME-Version: 1.0
References: <20260208215839.87595-1-nphamcs@gmail.com> <CAKEwX=OvuVPJzQsSQm8F+zsRgJFnbMmW2JMJbGebp=U8+jMRYA@mail.gmail.com>
 <13e3cada-60a3-4451-ab7e-16dfbab3c352@kernel.org> <CAKEwX=Pww3ZNw=VGZBa46NhKuvefRM7wnVuZy0aADoCoE1KSzA@mail.gmail.com>
 <3eaa8d64-cc64-4e49-aa80-a3f029d63993@kernel.org>
In-Reply-To: <3eaa8d64-cc64-4e49-aa80-a3f029d63993@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 12 Feb 2026 09:45:04 -0800
X-Gm-Features: AZwV_Qi1_EMWOI-fIh6ISU_nJsN6lXES6EF4dy1h7AM5-pJ3Hm0yGMueZCnJCfU
Message-ID: <CAKEwX=MHx8rabQEBLMrP4-AfyCNYNi5XAi7mWeK1aKgF8y92=Q@mail.gmail.com>
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	hughd@google.com, yosry.ahmed@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	len.brown@intel.com, chengming.zhou@linux.dev, kasong@tencent.com, 
	chrisl@kernel.org, huang.ying.caritas@gmail.com, ryan.roberts@arm.com, 
	shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk, baohua@kernel.org, 
	bhe@redhat.com, osalvador@suse.de, lorenzo.stoakes@oracle.com, 
	christophe.leroy@csgroup.eu, pavel@kernel.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com, 
	joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	rafael@kernel.org, jannh@google.com, pfalcato@suse.de, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6482EA000F
X-Stat-Signature: 5rz8tjx9p1on1zg3fq713jkyqmjh5q91
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770918317-91002
X-HE-Meta: U2FsdGVkX1934ZXexHuy4R/usWjhgFr+6Ek2XurThWPDww9lX8hR8MKwUDDjiw4kjc0y/WUdqpYA+qyb9znnuLfLyONxdS5bqmKtbATIjWl3lgO/eHQ+Z3DL23T5NiDCMx3YLMvuMEZZhXWgbnu6ZoS2LfXo1I7REppYERiB9V7sPKZOEeLAxcUpHiVcKWrNCxQijUlX8Xk83i3cRvrxD/5zJBuULlAoWoHKuOb68tDx2bwTs2K26Z8mrN1nH3lWEXwpxrQW1udkcUxnuelKvgGzwEdDOOLlteaSFFt6blBZZ6mrI+FR1KmpQ0eRm5l1tsfI521ZdwKe6SoAun37A3PkvMa2bQXjzS3Sa1vZolo15zoZYDw4scNXLRHJktncII0yjRafHM7XeHI7MH5h0fWH/mvruRvs3f7A/tGDpbaVd/HdHBqGyywndjMzFBHK2az8rqzurao7o9zvWMvP5FCxope/uFIy1SmPPNZBfOuplVZyR+qwnoAetoiaiWzpX95YVGwV1sinKykWtH9HHo6AQY7lKXTurzpKSvlRBTzLqJ47KPsnRjGtVYgNQINHyKjEYWXQE6kGSAGGhSibpCLPaNC3W1qSUUhIrLJieHyrXXf4m4HaIu8DqY+q+oxEDyCROE1jQwzu2GX196CiyVlU/qnrEoCZARZ/4wFB3lLUzWyEKEUGtoxr9tbt7lR4CSGu7OInEzagMET8FnEo/OYPeBXzwJFyT3nxHkdtP15F0qU/c2Tv4Pg8gvPER08BV+NELnD789BIHNpPVs+Qr+ko6un3BZCrEENzFP5kGfvnaBb6NSEJuLhEdW8bPbYcV+Dwep3Yjc2T/5XsrHrf6ZSU+whhQrdtM2SdpdcC7vrF10LbROYEETIAbDRgIb5pUkRRotVarTK0ZtVyXtcZAvSnKzuax4kfKxc+IsmBVM2mWNNWhMzNPIbzdJh+pDa0TfQ145FlHFTARj3TrIl
 7SdI8PCJ
 i2VCkDwrXqKIhE2lintOqfn8TAjGZ2iw/V7dOrQsJfxOxjXRUL5QLB4HTPjQPSqj/rZ9d2hfZ6ar6bY0llQGe3WvC9hBJsTbLtHLgD7kxtMvfDHAAa3ExlKZp8csWSTz8Ai7LYN5Q3EmklY1ET8N+ujtyl42h/pUkOsAL89xQpRWM9y/tWbPtaUEL6e/Nyo1l3OJBc5Pq+K5/N9HaP2DLA+TVdeLcbNp4taXgQcO2BdJyqanOeNKvLpadGkEeA0TQKCLTeQTSY+dMmBXDUO4MndsZLwPZ4/obSWoeJ6gmpMK4Jq+j+93Kn/19/dMq+4YsAqOdahcGlzOX4Xw62ZdFeZ0dtVLsJgWcKE6lXpV4XUbqyx9ZRPxwO0L7Ffu/oKr65an7MoLkbiQEn/BzbgbKFyhXPx+MKTHMcHJHTOcL9vyPjjL42RBtGZKwwucwmMg23/T6D7Oy1GIjHf4gj9fCQ0Ei99jB5f7quDNni+xuR/c5vMAQTQ/TRbkkuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 9:41=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/12/26 18:29, Nhat Pham wrote:
> > On Thu, Feb 12, 2026 at 4:23=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>>
> >> Are you CCing all maintainers that get_maintainers.pl suggests you to =
cc?
> >>
> >> --
> >> Cheers,
> >>
> >> David
> >
> > I hope so... did I miss someone? If so, my apologies - I manually add
> > them one at a time to be completely honest. The list is huge...
> >
>
> I stumbled over this patch set while scrolling through the mailing list
> after a while (now that my inbox is "mostly" cleaned up) and wondered
> why no revision ended in my inbox :)
>
> > I'll probably use a script to convert that huge output next time into "=
--cc".
>
> I usually add them as
>
> Cc:
>
> to the cover letter and then use something like "--cc-cover " with git
> send-email.

Oh TIL. Thanks, David!

Yeah this is the biggest patch series I've ever sent out. Most of my
past patches are contained in one or two files, so usually only the
maintainers and contributors are pulled in, and the cc list never
exceeds 15-20 cc's. So I've been getting away with just manually
preparing a send command, do a quick eyeball check, then send things
out.

That system breaks down hard this case (the email debacle aside, which
I still haven't figured out - still looking at gmail as the prime
suspect...).

