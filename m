Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09017CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65E9E8E0011; Mon,  8 Sep 2025 13:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636758E0001; Mon,  8 Sep 2025 13:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C318E0011; Mon,  8 Sep 2025 13:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41B528E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:51:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 175BE160232
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:51:46 +0000 (UTC)
X-FDA: 83866825812.27.B6F7EFA
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3BE34120003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:51:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VftsaFls;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757353904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4G8OjR9ssKy/HeocTqhx3l5d0C6Xda9h262DRWrvvKQ=;
	b=3D5j9Qjiuy/lfuGt6GvnKrF5QRwB60ixtvgm+TidHrXLiBjDo2RQawA8A8uv9nR755hkDQ
	m+DhmhFV2Cp55lbfB8t9vGWCDKvyB7z2dpgqCQS7P02cPnNTf0jhnuPfeUB200ZTB1bAd/
	wgrGyR1nxjT0vFizvIY6pgFMvhVQTqE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VftsaFls;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757353904; a=rsa-sha256;
	cv=none;
	b=s+D2tIQS3YKqgMaP/Fcyei4rqNOr0FmceHhK2ovZKM0ifEHPSvmECfWxG//xUN8SkF9yEj
	uE6PhCLqEW78+glVoB1e7z9FKfsxcBO+QmvNyCVFf8DRk4+HnPrY+O1biVLXVen63xp7SS
	e+uZBh6Kb3BYbXEq+S3zTlimOlBgwbg=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b4bcb9638aso1081621cf.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 10:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757353903; x=1757958703; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4G8OjR9ssKy/HeocTqhx3l5d0C6Xda9h262DRWrvvKQ=;
        b=VftsaFlsy+2tadKklR/WuXAvzlBmY2kpV969NznM1asN7uys07c5F5G71f2HpNEmdi
         DVgeWbZLPQZoO2vWPbIoQywedo/CN5MCXvIMjcWvAyxyyhI/j/5TVqzGiiaAtvkimQKs
         xa/GB4TJg2AtOmS1+zOsfYSw0ms0g3eHCrFpFerSAmXq06wMVnZ4DNiJpsuYSJ5dnR4X
         UWvkuY3yvA27o4LdcXMbF69Vm2YH5u2vfEjBKeNp3rYh7/EXRRLElYpD588UM2LYyh4L
         AF0hemvZxEZiitfA1UupljUrVr62F/JFAzBMtcVVyGYmMz9yVurVigwODiIGau6zp4h5
         ZjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757353903; x=1757958703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4G8OjR9ssKy/HeocTqhx3l5d0C6Xda9h262DRWrvvKQ=;
        b=a1z2FnMmbHKDTEKj8v1x5X50lk3M0eAfbCfi7TAkzt0+UUdHjjKmpJhHZ4LPyzVr/G
         SqHgShNb5TlT23BwJwo166OBEexJihseMVYX3SZFvVCSc6XUD47NehauU1atPn2L+b7e
         J6kbZthGNmbnHGWBMhFiGrdkgJaZNwnZFZ1hWDqTn6Cl09qhA01lRv3SOZBLIcEwmEu5
         GIqw+7qbuGrmpqyHpacA+BATRaM6OGDCDVhYJ35Zyk9Zbg3JEi7MiVE8+yqVp/A05ox8
         rqGIySlt4woshXeFp919UV5JgphocsssZPEM0dp8CrcFSgzI1ZEdVnULnO9/UvbcJYwQ
         YMSw==
X-Forwarded-Encrypted: i=1; AJvYcCW2YLBHqezuPtIfiOd3dA8tkhCLOND5OQgQlg8MQBMe1akAmdT32TcwR6U1tZvAymjpHs0eN3d5qg==@kvack.org
X-Gm-Message-State: AOJu0Yz5sntedyUOwYVp7gUmpEGQmXainnwQpLnfinT7oJVU86OSUGHu
	ccX7zHnaq0MMe5ij35VQPC8pvzOX4IdG7taPe2b8+0WwAJpKwtFqQMwxijiTSXZ0aak/HOmYuT+
	2Bi1DLjoVFq4w83TOsmQGnq+GaKDia5939yQoZCXI
X-Gm-Gg: ASbGnctu5v8GoxQIj1USUQ2QzZMM7cZNob7wOOEsBA1sSnk+9evoXM4e6HOv3pd0sn5
	xcEFzmpX+fzPCFqESnydtKxUqZ1ABnaPPuybcyY2lAesvVf9aUPhx38tQOAYLz3V3NOAWZhUc+A
	gUsWQCpXwJ951ZD8gQDW6jMzm9vkltSvoB5l5ammh5xQBborq2hiFSb4UMYq5TepTjYNUCtXToc
	rlTPqXXggRniipX9ol5Gpk=
X-Google-Smtp-Source: AGHT+IFX5M5+t7hmlxY9Bks+Ly9Dc9jsstbdD0XJ6NCNG5zc5agHlOjwp6nPJ4I+6VcViwGGr1N8NMZ0XWuJy7AaxH4=
X-Received: by 2002:a05:622a:d0:b0:4b3:50ee:579e with SMTP id
 d75a77b69052e-4b5f839899fmr9996781cf.11.1757353902829; Mon, 08 Sep 2025
 10:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1755190013.git.pyyjason@gmail.com> <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com> <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <aK2/Vesgr9Xcl5gy@devbig569.cln6.facebook.com> <CAJuCfpHJMSd16j3ANrtJGVfLieHdeO_Epq=U9OKty3TV362ckQ@mail.gmail.com>
 <aLFKHGe2loD657fu@tiehlicka> <zerazodfo2uu5az4s6vuwsgnk7esgjptygh5kdgxnb74o2lzjm@fkziy4ggxrxc>
 <CAJuCfpFynEuwBSu28UiRDjWrayN-raX4Nqqh283MwRoJLi8bMQ@mail.gmail.com> <uoyjzkybkqd3wkvauofmorv72gnjisoq3owvijsezpt3wbrazz@at562ngtvszd>
In-Reply-To: <uoyjzkybkqd3wkvauofmorv72gnjisoq3owvijsezpt3wbrazz@at562ngtvszd>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 8 Sep 2025 10:51:30 -0700
X-Gm-Features: AS18NWDsU1J1RP4dbV6eRyI9elf2CPlWHKgnI901gTzxBYcnOYe7IoD0JikeTzY
Message-ID: <CAJuCfpG17E_yoZeqEDrN0PFn8UBKqiGT28KDwEDmBm6byFje-Q@mail.gmail.com>
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Yueyang Pan <pyyjason@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Sourav Panda <souravpanda@google.com>, 
	Pasha Tatashin <tatashin@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3BE34120003
X-Rspamd-Server: rspam05
X-Stat-Signature: 7t3gcfmyqem1q3j1c1tyw15fn1mzmg4o
X-Rspam-User: 
X-HE-Tag: 1757353904-672398
X-HE-Meta: U2FsdGVkX19cNAueBEy27434dtCZUrh1x4NozpFLWynswDXDuJ3iiTMAaUNR/uIXmPcf70fCpNUu6vdWx4hrDcbN625hKGgCxV3VOySPld/BEcXEuYJI91FQqkom1YnbctndWF9Z5FXGghigf8JWdTt6uCxTnMyWLLxIq3+XGLYmSN1d3U7p1CV1SWOAc6sCfG/+SWwYhUNb5F1fLXcpIskyElp7//Zl9cCH+VY3GohXcwkAxVPfAyAbykTZD/PL1Unp1fBAo3KzrLu0O8L8DXJCiv6+M939iweY2JKaBN7subTxz4wwlunFFRix42FrVjHct99rgd9a0E+6Y+I49rQQtiSJNkV8OXJCcLsH8HBRFtXfVFYlQi7ks+Da3KvYOVuo2qSyZ3y+Xp7OWQKoUeVUjyx4ARgDeTPaISkxJ95NY4RBLo0Cnez3Zm5iMKagi2sHYeWP4DqXjVxpwkfBPd2fzBzfA64TeDoVCG6K6dL3bMSPrvokXrC1nK+scWMykpWxe8dT0VPjFsGxRl1lVQwDIC449/Dyz2Ch/mfLS1FikpcalFUl3tYurN0r4ZXd+XqiJl1/rbYyHpbX+6y2HkRqzuBKfQCm3cJnKdZX/c+JUGnZFVRIBpEUrtsA9mf1KSZhCa5jpk8WuN6NBnKshzA6iyTD37xziME50u0w9ZHOdfhxjW5wHfCNmU9UlZ1zfdl5CPfr3Sy+OynIEgnpOgeLeyjWlzei05WQLE+cV37GgOMi9erG9JTOsEDjsTDsmQ6DFhXKqTUmQ9CRZEfRinKPUXIO6TKoKMHspqJK9dHL5tgvXosEZ5WzYHAiFKG64Y6k35DS1aen68J8vaWKEfVuDZdXRfotfiIJ677r92XpRjsjv37/rHqiSTGAKe97PdOWnY9t5VODEDqHWQKKnfRgj15CqPyJxazZnQkjrO0xuyPeyISjjQHMaXA6uzk2c5l9VGzBOeV+bln85EW
 y7rq5u4U
 JaFtikOXGYNDJvJOTOFobi5YSEfg0P8F3r53RRTAtz5e8DE6hzKJmimIU0VZMzvHVZYMVmoccS+znsWtxNHWHVcnvipztADZSssdQkNAeDKUbB26Pl8mtcOdYH1z06PsNsqR95LrdbJMrwd7b4s+qPQXomao0weWNEFJ82d+WeC/jFC9Q1EVLeFomVjXjfRKsCt+r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 10:49=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Mon, Sep 08, 2025 at 10:47:06AM -0700, Suren Baghdasaryan wrote:
> > On Mon, Sep 8, 2025 at 10:34=E2=80=AFAM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > >
> > > I think that got the memcg people looking at ways to make the account=
ing
> > > cheaper, but I'm not sure if anything landed from that.
> >
> > Yes, Roman landed a series of changes reducing the memcg accounting ove=
rhead.
>
> Do you know offhand how big that was?

I'll need to dig it up but it was still much higher than memory profiling.

