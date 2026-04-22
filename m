Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20592F94CDF
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757106B0088; Wed, 22 Apr 2026 04:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F136B008A; Wed, 22 Apr 2026 04:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644BF6B0092; Wed, 22 Apr 2026 04:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 549C66B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:00:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1CAA21A13F9
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:00:30 +0000 (UTC)
X-FDA: 84685444620.09.D18A724
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0A653A0017
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:00:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=syfFmQcN;
	spf=pass (imf15.hostedemail.com: domain of gality369@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=gality369@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776844828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0pm7G3tXhJg6RS638Z2+LWOI234qGmSSJFRNvCQL8s8=;
	b=nYGWEZIwnBY+1d1uI6sCnJdCG6+ZUAR0dC5YtqDIIDMNzqwFRpvm3qU1XK56inolifk79A
	BGwNxw8wd6vjpw7vnmXPKawAdRs12zEskE3xdgcuqRBuWEK778iiomH8AGgHfrTjbVbD8I
	qj7pCdk5QWhWxSIifl34L8eTs20sJtk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=syfFmQcN;
	spf=pass (imf15.hostedemail.com: domain of gality369@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=gality369@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776844828; a=rsa-sha256;
	cv=pass;
	b=o/mNtza5XaTVWYc5ZvXkM/Dfjy5otgtO18OslbZPKfDKxsxARcCGFGZLVF4Fs3HskIjFN0
	2BYWXPTVLbbvFM8C71nvOOOUnnagbn5PCkyT/iuZFxflWAJzdpoJmziqxYeAj7JMvGyqO3
	d5kLl2c8CAlyvB9INcgkC3Z0jnsc7R0=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b9382e59c0eso817315166b.0
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:00:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776844826; cv=none;
        d=google.com; s=arc-20240605;
        b=CbAd5CinoNrss8Zw9qDVV9bZMdwo1tJZoEgvESGhL3YCJiF1njiYz5vP43KXgNINJU
         GRDUppiK8FodvyK0tZ1Jpi+OJWBsRX28dS5KDbIJGFc/7M8L51RYGEMScvEF3mYfXSRi
         DZNdJ0QtfvhFxVNOgFHvjQR7KSg5gbXaLwj3WSGYbuyI1UgDqZd/LTN3cz69iqEzq12A
         VeSy6Zxf8aKNaKn5Ove899RPRfxUlBCDBqkKB0wpFDn1BApBz6EpvMwIlaGVC7x2P8BA
         R2VjugLx9bFBbWwC1E1Zj/MkdB3c7cViCl5SuyvC1EbfgxKjNjkB6MAFgeqeU3QYtVZr
         T2ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0pm7G3tXhJg6RS638Z2+LWOI234qGmSSJFRNvCQL8s8=;
        fh=1boRYbavWPnnggu49yZuxhyHTnR86ySVjyBXD9SIAHg=;
        b=CcPP9/QFi4V6/3z0JB1tMIF8R1VlH1XoFZ7wkyUvrWH2wC+5R+HZDzR9ippByoZ6Qz
         hTLOTMTD+WWs0OMItu0pDeh8cEGQNB5IoJvyYJwoIutNe1Gz0sWQX9k3lsdYrITn3+re
         q58RSBeMDnEw+7L9P2AJlQkyvfq5I7233Jny8CuK+Au0iblHBvtGHKi3lE4b4vHv/iXg
         2KSDFrjqid6fTPvdB8ZiYvb+t0UuxK21eXkwR2bQSak1zvnj6g9B8gl9pA5KFJ3LHMsW
         +mtq0iPYn/F0cEEjuGEcs0xUhijGQw+vlhq0x3V9tfYMBKdfo/WdBPpxN2deQYX6cGhd
         dlvw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776844826; x=1777449626; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0pm7G3tXhJg6RS638Z2+LWOI234qGmSSJFRNvCQL8s8=;
        b=syfFmQcNiJIn9N3a24NBSceJsYbyd+b7NBdSNWeHHin4zO/Ed/sc3ooBXB0DovprLO
         LD0NwaGWmgWY81mdPEtHnnqtUgYwsk3//3YJZm3RAy/YzVuSoZx7MSA/J80XeVzWZTtk
         madMa7DPZa/wSuIwS1r5Vyn5edXvO4w3Gl6Y99aUSzPA0NW6POKZYTMOaGo6ilG/ZBGh
         IVNbSjgbafn4QI3hEUmnTYKMAZWEuod6WD0hWVvGdIpf/iqlazbcv7UjhzMT/AsMmQm9
         7Fw0TGgTYA1EuDJAeooI/taRXCvrVR/VpxRNMfO+xe44pof27UwKo8mrCJ81ue/O39UE
         8y4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776844826; x=1777449626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0pm7G3tXhJg6RS638Z2+LWOI234qGmSSJFRNvCQL8s8=;
        b=HcFxlmad0Ombtgejw/j71wD6OmNRkF83x8sV65HwA1N96rmtqemuWJdPxRmwbKa/Up
         I1X7daEpLJ5fmQ//mRDT+eGGxpK12aFTQtywbwxtleT60i6N0m5al685j+gl4dmGRYFB
         GVhakvhki/gHrHctqpa3tBhBcP15o3eY1NHEwd+PYbETMF/acqDKil6BPyaA6Qd2PsAC
         EGI0QURWlXw1wn9fa5CWzYfh7RPMzCBIr7oIxXwYmqlaeXv8XHZ6cl3jL4KJFIXMBXyF
         tko1+wyn/Cz3llbEP1BnTOmfXuyhIIbQUNUhc/6t/+KO4k/P5AUMTdSCY13lkaZ/VUOw
         DcOg==
X-Forwarded-Encrypted: i=1; AFNElJ8uA14om4eiyMoy/ArTtXYlKrlcbztLO6NIkP1Ga30EjsFe2ueaHYv8i+T+j8syACkngyr+O+O1nQ==@kvack.org
X-Gm-Message-State: AOJu0YwpbY0/oazbEG+wwCTC/EeqdHWnVOEkYPMnFQa1jqqbbn0nLa7M
	VmIyaqQUbflcvVxvcTaTQDylJQKTdBER4eqXRdxmZPK4TS1VTmAey8tbgYXk32Hk8UgxzRw21SS
	GNi66BBPTReVlYG1lGgXp3jCYqRsmG28=
X-Gm-Gg: AeBDiesvVi2q2ELuVxw/ieoxpHfOrTfJ2oYGs+8qCPpX2jMTlK3d8an7cOfkGLtuons
	8qMkJ6TVPzzc8UIVr1QO9xLbYQDnPvDJc9iS3YeE8CfOh5Hv8h6iJHCG8MC37l7jCMXgusTtC2I
	GZWAB1gvd5bEmzftsuyp64WjfBjr99RUuzZ8TopYqtI97NW/CQXpEtej32wEMbq3luMnaN3AVp1
	GIdRUdcSiv8DduPx979U453N4/gomgdyblvTIXadJCiu93zYuGazih15+gVhjoRi0IF8cluYJRy
	UYxMc44Dj7wliwd/W8Up9kHAOYcyvpFl1fCGtsFlXkNOentO12lXDtjPriMfluZgmw==
X-Received: by 2002:a17:907:268c:b0:b9b:e4ea:93a9 with SMTP id
 a640c23a62f3a-ba41afe9d28mr1071289166b.24.1776844825224; Wed, 22 Apr 2026
 01:00:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260417011606.1089985-1-gality369@gmail.com> <66f67e51-819b-4c60-9f61-170db32362a2@kernel.org>
 <fb80d953-93de-4ce3-80c6-15cd53dd956f@kernel.org> <aeNP7mtx878gynXS@lucifer>
 <7b983108-4846-46ce-b9f5-2aef319c00dd@kernel.org> <aeTcdRL0PEg0y78s@lucifer>
In-Reply-To: <aeTcdRL0PEg0y78s@lucifer>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Wed, 22 Apr 2026 15:59:57 +0800
X-Gm-Features: AQROBzAQnd6fQm_0AX9PB7FoGOcVs_JigoJGga_0OB8c5jLDr8Q7qLkyQ_nymDw
Message-ID: <CAOmEq9XF0P-=QyStrCr0khCsGvPO5SCHdXShKNa3PeST3abw9g@mail.gmail.com>
Subject: Re: [PATCH] mm: prepare anon_vma before swapin rmap
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A653A0017
X-Stat-Signature: j7korpoh41s4morjtnmf76hrxbe1a3nw
X-Rspam-User: 
X-HE-Tag: 1776844827-837636
X-HE-Meta: U2FsdGVkX18u6hbZReCghyhMlK/yoN7JkZbHCZ/A2kHRefFeVKFxGg7EtIBwFoH0bFCGs+xJTDNc510+0lOOtiiGxM8y5/2Mbuw8tKZqBn/IT+81hCug4owttCL4rygF2Bz1U72auzvHLh3ovoE48e9/Hb0Fmb3CLMYlx3A8fMHSc2jk+JOTBSglKdgajkcMv5IQvsriZo3AZQKSmnlNEtVM91PY9VrDinodVQTOJM0aXf9bAEoO/JsWhHuRAmrdAQMxADg/6mVfq/Ufxc083p4/7QbM8QAtbT6klVOtufgfx32fM7l+HdJDGsxS+NXy7Tk99E6vJKjz9AARqvSgqHbNrlaGsM6c90DPVFaJF3uCNcAe0Kr/g7rzHVz0/BfT9Vnfcvs3BdjHSMSAl+6UjhJh3YzqEv8zTbd93hudvGy5rxZMVv7ZPzLEueCQ94D8rP8tDcuX0fOz/Txxh9uRaTHvDXSecdllRAvIMORXsdtz5sG5GZouNWOjw+ZKoW0lCL3tAcEjkPGBWKNZOWYo/FvWHSkHM5BHiE45KMu7gYNtEU0+wT4dWF4cWDfSt4PC91rqoUSoZPrd0ETiCe8+meShZFF4ZpXSN9z7x0jtUDaVWbkhe/zMTfnCUAiiJc7lHah+Aeit5YIRN91a+7eNxBRhYCSvaji7A9wiGpiTT7CWQklNmRwr4Z/J8JNUnqe2T82IFRfxcZtTBepSB1LZ9lOD4EJ1IHsMTyUShnoTwNG/q6SGwP4rMKQa9AFog80EwpYrYqu/xvzCyI9I/pE7kvFr+7wT6D+rNVXS12I1Ajaw0vraq3vW85PBJVeIZVVt1pmRfdjq9irMfdJZ5BAk/0/53ZBs42vxd36zKUPRHPEyJRXOc+zk/uwvsxykIGc2c6Dz13PbiudfAMDz0Il6TXKI1103dcvFpiWUCSbjhjuFKdWbWAipx+D9qolmKlcja18bJ+iayuxcAIkYj+O
 5FTlHwXe
 fpe6kxrZe7Zb7GkWs6LL/E9z6NxdHbP0U5x2KfVuu2qlAfkO82QVOoMIc2qx+Mb0JV5FqL8lxyVMsdBwzVHh3dZEFyzY19Uzj8d9RldXsUE6udT0EB4OVpTBhT7tHPQf7NNWV59T0PbWS2oX56ss7Vr3CWWfdsMeDVIEONJi00Kaetqs9nNsMDfcbZDNiPXIA4SI2y2HYsCqoiWK94HT8/+l0VorUGuW6cKynuyaPM6KpXK6biEN4YIVjET46bQM06jJ4xCh2NFLZVMMmaZqbnD6TJRemoSTmMeaYbt+J5G+nXvn2RRW1Cm2L0EOFf3CdFp33QApqxFV5FYaid6tZXGr4hCIXQQ8zjF2UBoKkg5zOK85cHkyvVNXYtipaHP/b2ouHMTO8O/4A5K5ThRjg9XyAgSZnKTB1HpMkDRUyQoRhIGPf0Ewh9E/WKsehCvtwuJkgRvjw6ceTfuZ6kxGSbjjU/1aiATG+BQdB/LqilY2+0OhykCPstF1F/vnnbDFDbdUzCI0aZowBjuaGntMHzV4NLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 19, 2026 at 10:21=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> w=
rote:
>
> On Sun, Apr 19, 2026 at 10:19:59AM +0200, David Hildenbrand (Arm) wrote:
> > On 4/18/26 11:35, Lorenzo Stoakes wrote:
> > > On Fri, Apr 17, 2026 at 01:57:59PM +0200, David Hildenbrand (Arm) wro=
te:
> > > > Maybe there was a scenario where we could have lost vma->anon_vma d=
uring
> > > > a merge, resulting in a swapped page in an anon_vma.
> > >
> > > Unless there's a bug (and correct me if I'm misinterpreting), VMA mer=
ge requires
> > > vma->anon_vma to either be equal for merged adjacent VMAs, or one or =
the other
> > > VMA to have NULL vma->anon_vma, in which case we set vma->anon_vma in=
 the merged
> > > VMA.
> >
> > I think you didn't understand what I was trying to say.
>
> Let me take more of a look then!
>
> >
> > The reporter claimed that it happened on 6.18. Nobody knows on which pa=
tch
> > version (stable tree?).
> >
> > I was wondering whether your fix
> >
> > commit 3b617fd3d317bf9dd7e2c233e56eafef05734c9d
> > Author: Lorenzo Stoakes <ljs@kernel.org>
> > Date:   Mon Jan 5 20:11:49 2026 +0000
> >
> >     mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge to=
o
> >
> > that went into 6.19 might have resolved this problem.
>
> Ahhh, no not that one (it affects merge of VMAs that have a CoW hierarchy=
 which
> we shouldn't allow) but 61f67c230a5e actually could cause this.
>
> Can see from https://kernel.dance/#61f67c230a5e it was backported to 6.18=
.7 I
> think.
>
> ZhengYuan - can you try seeing if it repro's with/without that?
>
> If you're testing literally at v6.18 in Linus's tree say and NOT on a sta=
ble
> tree, then that's your problem - you're essentially testing a known-buggy=
 kernel
> (we always find stuff later and send to stable, just how it is).

I can reproduce the issue on 6.18.7, but I can no longer reproduce it on 6.=
18.8.
So it does look like the problem has already been fixed by commit 61f67c230=
a5e.

Thanks everyone for the insights and pointers.

This issue was originally found by our fuzzing tool. Unfortunately,
our reproducer generation is still a bit unreliable, so I cannot
provide a standalone reproducer at the moment. However, given that the
issue appears to be fixed, I suppose that is no longer strictly
necessary.

Let me know if further testing is needed.

Thanks,
ZhengYuan Huang

