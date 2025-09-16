Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD18CAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 19:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E982B8E0003; Tue, 16 Sep 2025 15:11:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49D78E0001; Tue, 16 Sep 2025 15:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5EC38E0003; Tue, 16 Sep 2025 15:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3DE58E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:11:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83C49119857
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:11:17 +0000 (UTC)
X-FDA: 83896056594.18.7E9DB25
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9BA67140007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:11:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BDmJeHCR;
	spf=pass (imf26.hostedemail.com: domain of jthoughton@google.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758049875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gs+56ysiCZFYgg3G9GKTUnQNaEzLYxSJv3ZTQh1Qvxg=;
	b=mcL+B8V7THJ58gtWqJgUr72+gLkt2QGsd/n/ufpaOU93xSsoq/dFIhL/nhEtOzgn2TsV1U
	xaG6IlP8gculgj0+4QNWfbKm8/4We5t3TQ4bPT8snb4m3X1j2ZeXK+/nxznzaIP7xR4/HC
	4l/3aHUkyvcemE3A1FC4PvKTAS1JXAY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BDmJeHCR;
	spf=pass (imf26.hostedemail.com: domain of jthoughton@google.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758049875; a=rsa-sha256;
	cv=none;
	b=oJRq6b9jln1Da+X/b6+8BxI1GBW9lnzq5PIO30IdGjdIY7OBoBaCWGuIihAvJAVY+YuDL5
	xtUY/zHw4PclMTptqnmxAloiGq/DKL1p4lkYcea3luP+eOIkfQTzx97HA5zB6FrvifxfZD
	zDnhX/nDuq6WRkiI7Nje1Bk6UX3OpsI=
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-ea5b96d2488so437809276.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758049874; x=1758654674; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gs+56ysiCZFYgg3G9GKTUnQNaEzLYxSJv3ZTQh1Qvxg=;
        b=BDmJeHCRal3pUxO1Mizuh7cZsXywOTSv66JdMs/7miNgAlsNzt+z0+akrlsqccP3vy
         iS4nOoe9pAbVMqq0hn+AVKDCWWSqjj62vhbv9FhaWicD4TiDDJncQ+M22Szn0c59Yek/
         /b5OnI/Lph2eumURcrDKxgtMrXoocjDazaFz1PQmecCnXpj9XMBGTw2LZOXjYVTuQDCo
         J8Wguzzj/sKc9xkjZLYXloTpyvz+wOwDLir4VdkOJIe7Ue6PX2WZovHF7zEnRe2IGPCw
         kUsA7XvUtdhlbSFoCUbyeOQM/2pG79C69DbwVhrP0ikgy0mngth5gEnsx7BbB/CUgcNu
         vV3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758049874; x=1758654674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gs+56ysiCZFYgg3G9GKTUnQNaEzLYxSJv3ZTQh1Qvxg=;
        b=wysjFvsQSnC78kRpGxyd8tX6aK6gjHcx1L1j0GQjEvbabkuvv+amkKhCj4geVa2Xl6
         ze8c1DllCewJodDIgzUZw7Jy3rFoQ9FOr5BQTlI6Tn0F9kIS7AmxBPMibXN7EUuDOMX6
         fPu1Nb8A1TDUbrLAwc29xS2qIo3ntgD9xE/dxXLyI/ZIQznyXzhvXejXI7JCKh5KpvVT
         tqkUdRgSglbUFpUUgPRme18MJShgAxrW2nj1bET3PTYIEVKSI4s03cUm+9J9Zy2fYXNO
         +SsVMiK1rnbVC6XPqsHPRzT2W+EcGnESB4V0SsPf2W8TIwbMNEwyEWjT6idz4t/3bymz
         bvUw==
X-Forwarded-Encrypted: i=1; AJvYcCXtPuI7OBYyrI2fu2+ES/qdtUlWJjqFt6toXYDaEsy4v4DNUK9OZaXCDz9cbTCZMcXhKy4t3tYOng==@kvack.org
X-Gm-Message-State: AOJu0YwuY0X5t3GMWZZd5HJI3i/yCI+dr2TjAPM20TwfgD6e9zrNTtfP
	JNfMBxF4yG5BaLBr2jHkPnctYBtYtYru1danobxzgaT4KjnFcxJthL5iUtnNxZ4eSsf4YvcBd4/
	gawkRgqXkwaOHt0y/9lZNRm76BMs31fPs5xma00uajn4dRjg9IAuh7hhg
X-Gm-Gg: ASbGncu1ad+HzB/WiGutGSe4/tMZvd4MpWvGNnRXMQ2sMocJFBhcA6o63lXuRV+Ifzf
	NgzrNNkppLd8feBJgXgwx4n16xSHMjzli7HcZXScr4wK5EJ6Dvqs55Axd1wuTWPDXg2+7TrEg1k
	JSaqtElBdrY8Qxbor37AH77sIdjhoyPicTYgtwPPZnX9gwBTJG0AuCmG7T/JJFm11GwV1+WwsZf
	j4RhInZ7lS7WGcDq3U0cgl5aTHjiwVZBdOKCrG0BcKu
X-Google-Smtp-Source: AGHT+IEzOgfwOhaAhLFmnGX+ydVFDtCW3HVtVmqXwQ6iYv8i524jAEGpzpQjKkXChsfta0f1nraCNIGG77nLuN9TMic=
X-Received: by 2002:a05:6902:6c07:b0:e98:a4f5:4b8a with SMTP id
 3f1490d57ef6-ea3d9a7d052mr15330882276.22.1758049873083; Tue, 16 Sep 2025
 12:11:13 -0700 (PDT)
MIME-Version: 1.0
References: <1757967196.153116687@apps.rackspace.com> <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
 <1757977128.137610687@apps.rackspace.com> <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
 <aMl4qLyNovWHhty9@x1.local> <1758037938.96199037@apps.rackspace.com>
 <aMmMnfU-Koopc9mL@x1.local> <1758043654.112619688@apps.rackspace.com> <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com>
In-Reply-To: <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 16 Sep 2025 12:10:36 -0700
X-Gm-Features: AS18NWDfgmrcu-PkvCUoK-COLSstpI7kh3wZlyE-srp3r0L0RQtzRxSttGSQp9U
Message-ID: <CADrL8HWS7h0e0AcjbE0npoVwqvWK6c_aqML4T+MJnTkCz5AcNg@mail.gmail.com>
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range fails
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: "David P. Reed" <dpreed@deepplum.com>, Peter Xu <peterx@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9BA67140007
X-Stat-Signature: p7mseqxte74utds9dfsbqyxehpx8tp1p
X-HE-Tag: 1758049875-141570
X-HE-Meta: U2FsdGVkX1+JULeuvvZ6UCAdYQCe7mlfw73T/4t9imtdp35tBZzsaxjIH2akrYnUtAcTSELjEEsWvCKwuOV/bFbSUQH/2yFLQ2IMWvJ+xXozjYbFaQQkGrJdgD+yWdJRThjmupmN9B48vtOu9p1qvZ/bAubZCSScrok8+Qune8cZfDMdnO6ZscXq3SpbVdJPO8OoUABtwFOGwIJ68lsSVDi312acCnGHrjRw1N646eD5t/m+Df95+0NZfj9rBp9QoS2/3wXiZ3N5lpy/zgFu2m9AyC/186JSIVATVpRsHdEU/bhJI8jC+iUarEk4aYcpnBpp63k+aRWlpFleuDt6fKAxWVywAXfh4bVsoKtQbbUBxU5G+3EyKCHizl7tXO2wMgyHkIKTDIYLMgdW5X93mWkicpOyyMWCPmh5F/ZcTg1iENMt2w2DZSBfL1hDyh81g5Fpxm2MH7EIKxyMbjaIn/8QHhBW++DWVrhe96i3qfL/5n3U7gwgbXO7p5XzpVESOwBaZsOHotopKFeIdlOX6T9PU13na0Pzzu5pBrCKJskks2OW7dZp6HQkHLk6klmMFP7pG5zoaIPlnTsbRv97rBkPZPF283tDY4fkIH34x67fS/nC+eJbnAGDW2UkFVtpaHj5SvPCB7lyvNdfSGIo3O9zE9B9ouHA/uUgIFAfzIbSQpWtzkieJuRurY3JiqZo42Ox7FK3vKvqi/W1d7WRgUoyh2cg74SwbCFu9VuVANvQKF6OjFMMKkHpUAo2ic1Q2GVNvwSqAzRnai37GNBiRPqIy6ZahxS4ggyfzYk2afN+7qxdpByL3efTntDV3/DHtVcw5E+67jn1gfeI7+Rqlxl5S1+oH2c13QiedSH+03usp9WvMaE49LP8JjZd8l9aO9GX1YqHa+3OXN/kCOW7z5N0T9DR/HwpsjxMVqu24pELOPj3Itt0lXzyt+7xXQaNIZv8Z9lpLvojaYjWACK
 EHfB1zwk
 wXp7QYruLxuFuMdwVhp/IBV8gLB0zh5pmoT8qYCCEIRiNhv1bWocSttogxydLtfiQHT43qXwePAo1GjFv07pBRmDBY7+PP62tiRtiZ3LXaxNRh479T+hF6gxkDWftYPDZOMFSLOuuIInm7FiGyvWqLRXglKYK51bOVvRe0V4f5WAn2bTs0Sj6dGf1Aem1q9xLZBAxxNElKQZEs647nuGQ0XML6Yi8mRmCCMVrGSOap+j7i8yBPlYuPTpsxljMBqMzTvWB7n3AFckVnh3YsGkyub5wFBx5n1d1Srqdm22Iy6dU38wyaIwcOAsyhGsBfB9uPWML
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 11:35=E2=80=AFAM Axel Rasmussen
<axelrasmussen@google.com> wrote:
>
>
>
> On Tue, Sep 16, 2025 at 10:27=E2=80=AFAM David P. Reed <dpreed@deepplum.c=
om> wrote:
>>
>> Than -
>>
>> Just to clarify -
>> Looking at the man page for UFFDIO_API, there are two "feature bits" tha=
t indicate cases where "minor" handling is now supported, and can be enable=
d.
>> UFFD_FEATURE_MINOR_HUGETLBFS and UFFD_FEATURE_MINOR_SHMEM
>> In my reading of the documents, these seem to imply that before they wer=
e added as new features, that MAP_PRIVATE|MAP_ANONYMOUS mappings were suppo=
rted, and that the "new" additions to the MINOR mode were just for HUGETLBF=
S and MAP_SHARED cases.
>
>
> Actually minor fault support didn't exist at all before those two feature=
s were added. :)
>
> You are right that userfaultfd's use of "minor fault" is (unfortunately) =
slightly different from the meaning in other contexts. I think the more nor=
mal meaning is, faults which do not incur I/O (i.e., swap faults and file f=
aults [i.e., faults on non-swap-backed pages] are major, other faults are m=
inor).
>
> For userfaultfd, a minor fault is a fault where the page already exists i=
n the page cache, but the page table entry wasn't setup. I don't think that=
 scenario can ever happen for anonymous, private mappings, so it doesn't re=
ally make sense to be able to register such mappings in this mode. If you c=
reate a mapping with mmap(MAP_ANON|MAP_PRIVATE) and then access it (read or=
 write), that fault requires allocation of a new page, so userfaultfd does =
not consider that a "minor fault". My recollection though is if you make a =
file on tmpfs or hugetlbfs, fallocate() it or whatever, and you MAP_PRIVATE=
 that file, *that* registration will work.

Ah! You're right... MAP_PRIVATE *is* supported (for tmpfs and
hugetlbfs only), and UFFDIO_CONTINUE will, upon finding the page in
the page cache, install a RO PTE for it.

But what happens when the write comes after installing the RO PTE? My
reading of the code today makes me think that we'd get a minor
userfault and then be unable to continue...! (The only reasonable
behavior is that CoW is done without triggering a userfault... I
assumed/thought this was the behavior today. I wish I had time to test
this -- I hope I'm misreading it.)

:( Here I was thinking I understood how userfaultfd minor faults worked.

