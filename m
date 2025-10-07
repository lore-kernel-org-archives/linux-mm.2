Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D88E9CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 11:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD198E000C; Tue,  7 Oct 2025 07:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4CC8E0005; Tue,  7 Oct 2025 07:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA2B8E000C; Tue,  7 Oct 2025 07:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8928E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:08:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23911C08D7
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 11:08:26 +0000 (UTC)
X-FDA: 83971044612.01.83E1593
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 23094A0010
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 11:08:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m4BWn022;
	spf=pass (imf25.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759835304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYjxP2t5m3TSDV72mhr1AaddvxDwKD3qqqOjv0SKlxI=;
	b=wealsHF3rlZZWW+gA09daKK+HEdwo7msFMmCZtGnI3LbIezze6kMRFIRXymOmv9vbp3CEe
	JYvtJdKKGbhjZkUQfgFLbUdCqkjaJfgmeO1HQibXTaPhdsJNxtouj4cNRbHLja3JHExi0u
	PpKgWdYCv339qdrwB3fUR+3BrW8OSxw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759835304; a=rsa-sha256;
	cv=none;
	b=0cVvacQFY53MBiOJY8A/lXgc1SEaYWXZ+szFqFszhnvsMjFLazAYrXz5YUBr+DmhhN6utY
	F7Se8i4e18+/zZZZUJe9qbR0lZ/TG/b2FANbvUQCH84d7KdmdxrEpt5JI0Z3GlDoCtwt1z
	/uqzabttwHYv9jT8T159IGN0ohocb2U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m4BWn022;
	spf=pass (imf25.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b3d50882cc2so1152387766b.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 04:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759835302; x=1760440102; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UYjxP2t5m3TSDV72mhr1AaddvxDwKD3qqqOjv0SKlxI=;
        b=m4BWn022qL/nbNj09wh4BdLIm43ITVG0PiL7W0AKq7zn/90O1f3aaxVaed6uyt8B23
         kHF4VuYUg/kZMDJ6TtGnZnPJkJauYRheWJbwQQDB9vjQbjUJ1++nJM4MnnGIbLX7xWPN
         VDAFpLkmzzJphnhe2nwoLl7zE8JVh92RKBgPMu0ElEWoOeO+Swtx5M7UujutBMjpQ3ft
         +IGrHQOhQqNFY29JyVKMPqkyTAuuA1O2Es5y48qbCoLVH6rIdL7vKs1N3M13UDdSnj4b
         Udd2s7lGNaflUOzSRC5okr2n2en/OY9Pk83f9sbBFv6T/6k007xV4EdtlPcIWWDgdqD/
         6NjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759835302; x=1760440102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UYjxP2t5m3TSDV72mhr1AaddvxDwKD3qqqOjv0SKlxI=;
        b=KziUK1ixTzv/e51VC4elNvbXd00HO+apYEbgtEhz9nDUpougf5Ut3XpC3+QsDDmk+3
         O3qHV6bMaMItiDp+Yih4BIiRFu000QmG9fsU0nvmzk2ifjNn4XqnvkGmFIEaiwXsW63N
         FVgvsQMLE2nKgRZuybrmRv0QBEGMx3p8eJOg67vl9lCitJKgkPnOutQANHhgOGBBzWee
         X+SyEapoiUUCS8F1jnvty9oVz3jxTRD4xiVK10UuBFqCB6qIyiyWuaxCB/FTkC1M0d7X
         Q5mOEefTamBdUC/ZkYsE5Bage3dPRWD5wPGd5uFTwfcpwju4TrPSGcaRIs5Ruiit9u8w
         +N8A==
X-Forwarded-Encrypted: i=1; AJvYcCWnCehJc5nBfjajWUaSlvpcvV65u6ck6do0+zGjZjVD1ZBSRZVP6cNze6jPdDzo6ZZamYhq5BQseg==@kvack.org
X-Gm-Message-State: AOJu0YwbAJV3tMAM9sDybs6+xvntY0mlO2TehQI/ZAp7B9vbMz9p1hzu
	6b+EqHZRBAGTjl6tt1kEo6EcnXDxseMAtGKJYiIjUFueI8xEE76N1CK8h3dpaogvUZtioQP3nkM
	eVLf37jDjidN7x3SB8qBUitFAg/+TvJg=
X-Gm-Gg: ASbGncu064tR9NPUsTCJV+20fpFRFLItC13+SBRAlVEwpSLTYEwDzujMylhPudHb/SD
	6RA0B+J9KW+nYzGCmD/cF6qKWcaKcWXzU9pO9hyBqTXNjckW2xVDaR3KBD5V4tGXp4ync7/Rbqx
	KDvv3neOQte8G1ePtlgAboBM88GVTyQJPMHSlwsABzzqwK8qqZ6/oGZVGzgcaP03aT5uoN7E2+h
	MsOiWvXzsHJP5XniNoOik0zLwwzgAiX9qzfUt67n6n4+KIojK3BBAnwC9lo1bc2WA==
X-Google-Smtp-Source: AGHT+IHTIee9up7m92yTA0Zsk+7eOEOmCuPn1i2HEpHrFMMVIsPmZ/Ha7QPfPMEmx8EgOfImzZOVCi5jgu6WcAE+r2M=
X-Received: by 2002:a17:906:4fce:b0:b40:98b1:7457 with SMTP id
 a640c23a62f3a-b49c4cde268mr1621336566b.47.1759835301952; Tue, 07 Oct 2025
 04:08:21 -0700 (PDT)
MIME-Version: 1.0
References: <20251003155238.2147410-1-ryan.roberts@arm.com>
 <edc832b4-5f4c-4f26-a306-954d65ec2e85@redhat.com> <66251c3e-4970-4cac-a1fc-46749d2a727a@arm.com>
 <989c49fc-1f6f-4674-96e7-9f987ec490db@redhat.com> <CAOQ4uxh+Mho71c93FNqcw=crw2H3yEs-uecWf4b6JMKYDTBCWQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxh+Mho71c93FNqcw=crw2H3yEs-uecWf4b6JMKYDTBCWQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 7 Oct 2025 13:08:10 +0200
X-Gm-Features: AS18NWAe14dfNSbsR0j5kwg1mzZpCKRfTUR5zwp4QxEyNvIbDN-ZzhaGc85_2tM
Message-ID: <CAOQ4uxh-FJMtpyDrZpRQcWV6ScranQWUia4yz+rb82yQSdjSUQ@mail.gmail.com>
Subject: Re: [PATCH v1] fsnotify: Pass correct offset to fsnotify_mmap_perm()
To: Jan Kara <jack@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: qnxwgqijxy4hsn6bri1em8ypf5p8pann
X-Rspam-User: 
X-Rspamd-Queue-Id: 23094A0010
X-HE-Tag: 1759835303-977791
X-HE-Meta: U2FsdGVkX19IdhbWTN2G4mx7c5WyB3PbL0h93AiVe62FR/LzqNk43BrvC+ONOasc+iRAaJyFMVaTFh5rcI+BKU0Z3sH3OcvuMOMhVE/ce34tSWxTTbPEbqFXQg1IysWY/yIOM3xyporfSJBRKTToQZYVEgDpl5XzpJS5XF98flaFvCmDAZ2qIUzJrKR81ZadOClkeI9p2Ypdp6CxtwR4Ss0RX9cRFfwGiqfMbItfawnmqYfpAnGDcXw2kF8kWeYZM4ceGtAzQo0Ckxw4SB5ArHOyp/57HjVKOXDTqm3dR6cVbwT7TQ0Ct3pDFAYd2Ry3CoIbHPIuVmfiv5OC6RpXazZ8EzlMwjm9oOdoUkMA0xIdRL+FRrpyecgyRpgWlwGgfwrEuyr+wB/Ka4etswZxIwq9jGuqRhRejnp8njiinNxSYlc47GnEFH0YFA0JgAMDTRG7wpnfk/U3Sy6MiwbOXxfVkfRD4SALyp7DKajikQM4q/gUr0PuGWY83EeOVHd+tcL4uucPMzaLWuWuLqtr1emCvAJWA3yHnpLugSkGd/GyNCkeAVK50n3jcBhg7UOPnJWokjiypcZgRtpJLmCK9h8S+YPgCNQaBwwFAbCsR5CHoXiyahhI2Evv3pnn2VXq2QMSn4WhIqt3kk0MTPFBTQmX+RnKTPQIvsi1yVeuI5nOq+G0oiRHhQ3D0cRs+JVKby+4jJqXy+oApnr3RFsrC9yoe3XD6XDA3zs8UDokA0S3bjm7gWuieoQudNGDXuDYvsuxeRyp4unI49otoOtSxFDuxzZJK+w0BU2rpEXAMno41hqatq4V4ZmtX7u6ANAxnIuybB7AcFbXm/aiKmviBFlpiw8BN/456TnC/TfhKVftR0sdP+zWFKpU5USoRcerMwiMlBC1iJ9fPQwz/Ml967pgVGJbxbGz5zvDMhsWE6iajR411LPutQevG+lv4djesK7rDd88tgtlq9CiZzC
 9281LzOw
 GM4VuqI3Dh9bRAHN1uq/3Pjdv4ahoSZfg6SxwaHbiF6SFDRSUoLypekv9PDOSw7Ad5/dJdg35r4Qzvhr3/EFPD0Qr8X8vMav56oWykeSYRgP0qrImUo/HZX3YjcCRW2Gona0gf3vHjunCNWqVkRIK+YsxUgXy1SGHTaYTYF6041+8SbaBbnoPbvywTWAIsR0dn2YB718BcNO2LK2bfJmbRSoqbUQ2eq2PIA/voSTJJrjfDC4jyUEs9KYQGUMA8RCGaP+I6agHfQzFpDfz2u4Ls7g5OadZWnS3GnJuATgJBasZR4nxh78/LhmeUdeR5aBRRl/JLhgqIuXwS3TwCXn3QC8w5eQ0VjjDpDchi68oyV7fSM/KGXgjpjo4VKeO0TokTHvaVtOeqzbK64O7+I4NqNnvo+ZTjDU7tCy9QmEI3eA2CVGR5bgEU8yj/XPAwukihoW0LkgpT3yoJcKJ/gO1HtAhNRFeD4TWkLyWbY5ys57hkM2qm6Jk+FZ2W/Br9yiQoN3MmABCSfZzI2B8wjouG5VaOI9rrhMJp24A24um3/jRfc8Ckz8Iy9gYhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 4:40=E2=80=AFPM Amir Goldstein <amir73il@gmail.com> =
wrote:
>
> On Mon, Oct 6, 2025 at 3:53=E2=80=AFPM David Hildenbrand <david@redhat.co=
m> wrote:
> >
> > On 06.10.25 14:14, Ryan Roberts wrote:
> > > On 06/10/2025 12:36, David Hildenbrand wrote:
> > >> On 03.10.25 17:52, Ryan Roberts wrote:
> > >>> fsnotify_mmap_perm() requires a byte offset for the file about to b=
e
> > >>> mmap'ed. But it is called from vm_mmap_pgoff(), which has a page of=
fset.
> > >>> Previously the conversion was done incorrectly so let's fix it, bei=
ng
> > >>> careful not to overflow on 32-bit platforms.
> > >>>
> > >>> Discovered during code review.
> > >>>
> > >>> Cc: <stable@vger.kernel.org>
> > >>> Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
> > >>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> > >>> ---
> > >>> Applies against today's mm-unstable (aa05a436eca8).
> > >>>
> > >>
> > >> Curious: is there some easy way to write a reproducer? Did you look =
into that?
> > >
> > > I didn't; this was just a drive-by discovery.
> > >
> > > It looks like there are some fanotify tests in the filesystems selfte=
sts; I
> > > guess they could be extended to add a regression test?
> > >
> > > But FWIW, I think the kernel is just passing the ofset/length info of=
f to user
> > > space and isn't acting on it itself. So there is no kernel vulnerabil=
ity here.
> >
> > Right, I'm rather wondering if this could have been caught earlier and
> > how we could have caught it earlier :)
>
> Ha! you would have thought we either have no test for it or we test
> only mmap with offset 0.
>
> But we have LTP test fanotify24 which does mmap with offset page_sz*100
> and indeed it prints the info and info says offset 0, only we do not veri=
fy the
> offset info in this test...
>
> Will be fixed.

Jan,

FYI test enhanced and verified the bug and the fix:
https://github.com/amir73il/ltp/commits/fsnotify-fixes/

Will wait with posting the test until you merge the fix to make sure that t=
he
commit id is not changed.

Thanks,
Amir.

