Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D2FD68BE4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:36:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647536B0088; Thu, 18 Dec 2025 08:36:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F57A6B0089; Thu, 18 Dec 2025 08:36:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5010F6B008A; Thu, 18 Dec 2025 08:36:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 435326B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:36:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECF811A0185
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:36:51 +0000 (UTC)
X-FDA: 84232692222.16.5913B92
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id 15E301C0010
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:36:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="HLDo/DpH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766065010; a=rsa-sha256;
	cv=none;
	b=DfYgKrOqyLMwRXEpDTuT1SaLowd2Z6z3Z+qyG5/MVwes+qWPEnUsOjDTmxlFwjB5/0fuoh
	ipURKCDaV0bsJlgVg1ajU06KF++H/x4dTGAB1iyKw6NZPPLCVirjdY/JndfLtQle+ISA/0
	8f/yaQnlRVveY73CpTYRq0rSSko5Us0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="HLDo/DpH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766065010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUwXVzNK4q6QfPc1DZoQYLQOHUNGJ3bwL7HXGimF9NU=;
	b=OU2hvqNk6gAzTeBXymm3WQocyloJgQvUgG/HIQ3lxfMWOe1BE3f2NAY/z+gLBGwuwbBLpj
	qGyia+XFp0TRSWTn9JNvgJQwM7b3im4b0WeslvDNDbWuKn4dWJ3SJYGhTaSvc72j+akk9R
	9iQDWL8FgWsvLtiDdyYceBARLqtU08U=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a0ac29fca1so5816725ad.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766065009; x=1766669809; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HUwXVzNK4q6QfPc1DZoQYLQOHUNGJ3bwL7HXGimF9NU=;
        b=HLDo/DpHzhC2XXxHaxDNJJ8fQUotFKJI/693UOdNQKkCu7LiCN+/j9pwiZm0xMYx5s
         otby0R+auz9sybOGEUycgTQWBxGYXc5P1gxa11MrOoQZnix9IVECltQq3vtVdE/gyle0
         iyQBJ5D8SPaWYPVv9MJHVu+QOOQrDj52eC5+YBkxTbZqaLqfek08ERYkLXHpBw58Ns3P
         JO4VvP1TnKEqO47F77+UfUTzE+vjVajza0C7rFAmJrdvO4GIsKx9VccR0rO/UDJFxbQ3
         HLlbJyEjmpv5DFTHHaY+TG5G3BZIWoOAssUDAq9xdZEvOy3vGrh5q1sojLVRwDN6PGx4
         n7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766065009; x=1766669809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HUwXVzNK4q6QfPc1DZoQYLQOHUNGJ3bwL7HXGimF9NU=;
        b=pp3EVhYuYkHESZJcGZ6TuEeUEUqgx/vU6B0GMVwMpVar1aX0lFWU8Ma1LkZhGqbZCy
         wSl1UlWu1e+ZRemRrq6hyot32TV+DmIyeNQ3hjgKCnicnWThPUFLWP1ycEEi5WbEk23T
         /F9va0X2vR0ppyK1zH54eXdiBC1HeFCfRu9Y8G2Rzx5K8kjsgKlefwq02blWMZHD6Kuq
         rxqaXkn5cFKlcnWA6iUnRdJUIZinPZEUX5SB5pd10N8QiQH/FnHPXVKRvCyGCrXv4Xwv
         MxGvsR7W5M1ETz78zEcJrNCzoTWbY7wrgYvscxLLUiprNsQ3OnSTI7OC+BvU8gQ4m2bh
         czwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyZm6H0j27hCK1sUTL/TuYF5u3gy1zTSrS1r2HCTQQqh9O3eV/r0aJRdGHDd+MXV0aXpNzIJnFoQ==@kvack.org
X-Gm-Message-State: AOJu0YxAtGvghiDwtgLhirGTnNGfEc+/OedDeiGW9Cv1/JYVttsOgs7Z
	zJHApcjhUJjKRylBQKtaphvexhexSOe2eB7/fkvpRRv76OGw6qSmQs6kdZ8/KSLM/8gXfQHyCQc
	3r1BtgjX8fuWQh5+osRjpfH8qKzYPONs=
X-Gm-Gg: AY/fxX7iXaGwMf03CoUXI7DBA/6m+hudsjU+PxWjQ7vU6UQk23e2RhyMBKkOXuDOacr
	2X4nvqtdTv8IHgx/vZgS8Knoilu/gBG9BATuuSRdx8GZPUPS9eJhWixGDRzj2PT2HAPns4lMJSu
	ueZXBLgvM23VKZLGIarUxVow6a0V0m3Zj0zo6/ECk+CTFs+zHQ5tzxOAbucRhW2kzQ+uSrJPPM5
	YbrXZV3c9SQXUs0DoYNTLr+J0Jlbed4EkF+8SWzrKYeo6HF29eWBlZW4se+OuM5w7KBpA==
X-Google-Smtp-Source: AGHT+IEtiV9gJa6n03OtIVg2EUyEuXyuvyJY5GYWeTWXbjFNC/3KngqUaCsS6lNADFSzK7UYNQWwRqhYLx+nywedns0=
X-Received: by 2002:a17:902:ce8b:b0:2a0:a92c:2cb6 with SMTP id
 d9443c01a7336-2a0a92c2eedmr158564655ad.36.1766065008626; Thu, 18 Dec 2025
 05:36:48 -0800 (PST)
MIME-Version: 1.0
References: <20251217120858.18713-1-pilgrimtao@gmail.com> <aUPiFbuaglcjqiB1@kernel.org>
 <CAAWJmAaxtKY50BEm3N8V1QTwpyCgQLfLFarrVfPVVpXg9ftmcw@mail.gmail.com>
 <aUPvecgVj8XXBcw5@kernel.org> <CAAWJmAa44SF=dj+FTiXn0aZwLLGbSTAieb8Cy73RE0sGAkAYLQ@mail.gmail.com>
 <aUP--JzrvOm1-Q2P@kernel.org>
In-Reply-To: <aUP--JzrvOm1-Q2P@kernel.org>
From: Tao pilgrim <pilgrimtao@gmail.com>
Date: Thu, 18 Dec 2025 21:36:36 +0800
X-Gm-Features: AQt7F2rzVE3Pu_pRYVaxkScyvBNFF6tJv11hZDClKsnLEh-eiK-sudCotGdrHL0
Message-ID: <CAAWJmAbxdBfjGtF1zwqNWwyKxfkw6Vdjwf9dEB3qDnkr5mEHkg@mail.gmail.com>
Subject: Re: [PATCH] sparc: Use vmemmap_populate_hugepages for vmemmap_populate
To: Mike Rapoport <rppt@kernel.org>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org, 
	david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com, kevin.brodsky@arm.com, 
	dave.hansen@linux.intel.com, ziy@nvidia.com, chengkaitao@kylinos.cn, 
	willy@infradead.org, zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 15E301C0010
X-Stat-Signature: dkt6d6ozwqogygu39cpzp73iiw766ntj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766065009-612329
X-HE-Meta: U2FsdGVkX19/beBhYWFNwKF89a3LhNUIWjSMkP/5qRluRxdwATRFvMhoEVLWDleGKevSaOFRbx5X1l3pfdz0z01gde/3RMHkDcGmyVAVOOnHlClLC2/Bm0VGwC678maAewIyhZJTsbKr/gW3LOK9IfHGNSbeIfLAklWAdu0b+pTDa2ZhgXnch07erOK1g5OyLavZ8t+jMfQ3mHjMHAayTIJc0yeNjaYS4SZrqKf89wJMNnbZAWJ1V6jd/THqLy7n0OGNYAh19fnALJfzEYSW3rKapy9SNQ8Talhmy9G18t5fPd20tVCryqVtJXE9mTsF7ikkASos93boDZzM3CtNIjEW+i0UuDd02/qgKI6q8USroMn0AFDdoHz6pv3PKNps8SlO80zrmR5hAywjd9KQOotXbEqHBREI5mSEdXkeLvlR0FEwN8odiPOn9zDksiAnPrmlaOx8TRNsnQj9gdH5Vtit/ImwRFzIkAR0hDRusfh/xsIasD+m6MQi35Rd+sD4cl+ZxlHxBSJJ+HdWNcTSy/6YtF4TMIzCSIsNhi2UPeEGfi1l3SyaIx+giH2cGmIV4xbfw5s5iiYTAXPHn1Si1BdNUCviIwLxQQvvPFNUFa0JDLx4wTAlYYGvn1x5i+3rm8CGY0W/rz1/KpnGjekVEhOMSdpsUGFffB+k3yniHqTll1dbOe0SNCwJurqScXXzzAjifi0p+4mtmgRoTFYD4PvThAkpTNctGMaA5yfxcD5rDrPb8wwEC0Xe20n1F2BJt+xNO4XP2ee9HlW9ykwAT6PQCloEjrAQzBCyQqaq5+aRrSL2HUlhqY7LLxHJNpSNNq3uMPrGEA+gyxPVokCwOaRRvSphpYXInYM4yFr+IumPFSFbgy+/LT1IvFJ9Z6jbRo+5HG2YM+TUSe9Pezu6sCF/L/3+thrU0DnRQSZbrq4Lgand6K2wmgNm088UBbn4P8YlZwFdklEzP3vhm0Y
 MeKE3gFZ
 MOLslI0ftov3LH3bY5Z+ua+c0tsIsWz7VGOB5Qsil9/p7pZacvXQPrd5/ww7Zi/1Kn+6bn5xbAAueq6bZ2mRnl7fCIRIa3z8X36oCCtQsl0zcqMDKRGHWyeF+iJEgLb9TGBRhsc+Jy5PvggAXMnkEMpNXVeGcwU87hbrt2NI+5cjeqYUQPyvkLTvKPpPIhQzIKBjrujSEToj77yrsVRmj27wQA15GfGahLybFnZ6sR8cj9eTzJ6Oxpb2merlg3xJ7h/r71OhObhL7SAWPrhZ+Fumxor2VdTBnorNnTlNYbeornjrx32MTxqZ9fZL2YqRuqctc9ZkCIyaAb/T41SsLYhLODZkmecm/cdI/oQdJ/IgOK4zVLHtkg/RB3/yfHzu1eWj+D69SfeDGzBANAO7b68kAqtcBzzuQDKpRTCiQaxyqqHPTDTPSuwOLbzDpXl/7mZZ7sfFWZmz/S0QQD6nSXea0Qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 9:17=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Thu, Dec 18, 2025 at 08:29:27PM +0800, Tao pilgrim wrote:
> > On Thu, Dec 18, 2025 at 8:11=E2=80=AFPM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > >
> > > On Thu, Dec 18, 2025 at 07:45:52PM +0800, Tao pilgrim wrote:
> > > > On Thu, Dec 18, 2025 at 7:14=E2=80=AFPM Mike Rapoport <rppt@kernel.=
org> wrote:
> > > > >
> > > > > On Wed, Dec 17, 2025 at 08:08:58PM +0800, chengkaitao wrote:
> > > > > > From: Chengkaitao <chengkaitao@kylinos.cn>
> > > > > >
> > > > > > 1. Added the vmemmap_false_pmd function to accommodate architec=
tures
> > > > > > that do not support basepages.
> > > > > > 2. In the SPARC architecture, reimplemented vmemmap_populate us=
ing
> > > > > > vmemmap_populate_hugepages.
> > > > >
> > > > > What problem this patch is trying to solve?
> > > >
> > > > Following the pattern established by other architectures, vmemmap_p=
opulate
> > > > is reimplemented using vmemmap_populate_hugepages in the SPARC arch=
itecture,
> > > > which fulfills the intended purpose of vmemmap_populate_hugepages.
> > >
> > > But what's wrong with the current sparc::vmemmap_populate()?
> >
> > The current implementation of sparc::vmemmap_populate() is correct
> > and functional.
> >
> > However, I believe that generalizing vmemmap_populate_hugepages()
> > still results in certain architectures requiring special-case handling
> > branches, which is contrary to our goal of a unified implementation.
> >
> > Another benefit is that it allows us to eliminate the external
> > declarations of vmemmap_p?d_populate functions and convert
> > them to static functions.
>
> If the goals are to provide a unified implementation and eliminate the
> external declarations of vmemmap_p?d_populate() functions, I'd suggest to
> send all this a single series rather than a single patch that updates spa=
rc
> implementation.
>
> Regarding the ability of sparc to fallback to vmemmap_populate_basepages(=
),
> it does not seem to me that this is an architectural limitation. sparc us=
es
> base pages in the kernel page tables, so it should be able to use them in
> vmemmap as well.

If SPARC can use base pages in vmemmap, I might remove the
vmemmap_false_pmd implementation. Thanks for your review.

> > > > The functional logic remains unchanged.
> > > >
> > > > > > Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> > > > > > ---
> >

--=20
Yours,
Kaitao Cheng

