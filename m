Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3ADCA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 01:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D706B00D9; Mon, 18 Aug 2025 21:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E756B00E6; Mon, 18 Aug 2025 21:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CF18E0008; Mon, 18 Aug 2025 21:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E34C16B00D9
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 21:52:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D0E881C58
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 01:52:17 +0000 (UTC)
X-FDA: 83791831914.26.17A4430
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 66B7C120003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 01:52:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mSBwp3WW;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755568335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iy6uQBBJZOu90duUviYfM/tFuTR0b6VxvWeIO4FqXiA=;
	b=yatQeAxGuL3qEVAgrBsVHdXVh5D0LQ7thdcQGg3s+xGK52TXnYk1oHPCFU7y9xXc8UC3RG
	cPfFP4uSYm/wrMxYQRnaWlSA5nJAfGgG7mJE2JjBcJbd09NCNWZK1A3VutoRUv+Lyoa2YX
	Jf2V0AAI9lz4wu5mIIZOFa+kxUTMzk4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mSBwp3WW;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755568335; a=rsa-sha256;
	cv=none;
	b=H+w+XmPftV61tDwN+YnIISV3SSa1mekVOOxYBwP26v85ryveNP9Tiqx70C7DLZ94u5+VHT
	QSEd3f1WWwI/scA0Upg1USjW6x0/UXjZlm7Mn28goWjipPZ7Ktj42XYYxe/oQVu7ZccPIi
	7InPlGcfp06tcbwcyfXk0Bex29Kq52E=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-743749537caso5058468a34.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755568334; x=1756173134; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iy6uQBBJZOu90duUviYfM/tFuTR0b6VxvWeIO4FqXiA=;
        b=mSBwp3WWaMeBUZLOIjzWKui5GmgmpgCVYBTgxb68voBWR4HR86HutgexbXhvQ87uc1
         IR+K8V4BJZ0YEsX4Lk+jfRAxqAgrj3tvfptiWvcj881tLt2W+OseKL+fQumVIizE4rs7
         t+kgEpbWPUJUAmLZtRHoO0MDBx3i1LABinQ0iIOkMClLlPyOuDkzKzm4sSoJiQGc14SF
         kCCYArFpD9WN3YEA5+doEyU4QVhSZLNXMXR/Nlm1wTpYGTiMgy1UNl8M00kUoUnJjEuG
         Ox38+fddB7EWQSgcRQwclI5Aznz3IMCtWri0W0z56sTUPY+QS+77EEOjfc9uQ3TnHKpm
         8FXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755568334; x=1756173134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iy6uQBBJZOu90duUviYfM/tFuTR0b6VxvWeIO4FqXiA=;
        b=W5EBMRqDwie6oM/AKGxzp+A3fS3clcNpfznoa/4Fx4d5RdRzPYc2ZnAdFAWcNj+fCS
         yYvALxTuuYJ075yN+FoLXsPtCwsIryktmYbWYoy3gqHqZ8kVUgyOlWKTWa/LqU6ZZtsU
         u9U+rphI6C4PK+A9fy6XNCbU+g062PXglBaLo+TWS0pyIvtP+0ULeS1jUefA2Rk37reY
         FHGxNVWESC6RRmcP3Sv5QbIUEq9GbWY1sQN7tsbFCt3OF+WSrbkAMH3j2+1bMkCumY17
         q9YeN98I+WitClmN9WWCcKmV1DJeUAzfwbCf5Sl/yQ3XpqV4gOpsd4FHUWmQjxZ+prKU
         Bubw==
X-Forwarded-Encrypted: i=1; AJvYcCWHUbIm40KBgEdZdQqzH/XEJW+v3USkXA4WHtC50eDMYR34rxS+ZT5im1iKnvX3yKPB2+GI99KwiA==@kvack.org
X-Gm-Message-State: AOJu0YyQugXjEMlgX5CZ6PeEG24tRm4AMZHUYC7H5hpry0X94qYnjE2m
	k7EADpgNmik0FBqhd0kkC7tASz12vOohcawuRDAWxJgQ0zjkwQg4uywP31PphnrJQRN2zZx8Wd0
	56ioJJVRX59Zr2kjLxegoof2WTmoQy0A=
X-Gm-Gg: ASbGncuLn9SlOwWZn10H5PB1ttgQ74mOHaafHQgJp4nQLqEJRyxxn96AWHk3hFbQHip
	QvFKj6VoO12eUDl4HY/otoClNtBTHyQYg7zh7lXbkXHxNTFHmT5ss9NmaEJuRitSb55EmnGdzEw
	y7GFrs0y0IUyexXboNJvmDIqNA+ny+onEEGXGngrs/krgF8fiRpPI8HXDbw9Ivv/eGdadRQdK6E
	40n
X-Google-Smtp-Source: AGHT+IG9GhsS9CQPc9TayGTtEA1ZqeFFdhPJkEk/ZWx2MRBkIosH2hvOMBt/2DyXIa8r0bBGSnUCZ0gKGrkCBDmvp28=
X-Received: by 2002:a05:6808:5086:b0:431:5a87:9c69 with SMTP id
 5614622812f47-43726627f49mr381384b6e.1.1755568334293; Mon, 18 Aug 2025
 18:52:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250818183803.1450539-1-ekffu200098@gmail.com> <20250818230145.4056-1-sj@kernel.org>
In-Reply-To: <20250818230145.4056-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 19 Aug 2025 10:52:02 +0900
X-Gm-Features: Ac12FXx-lHCpra_72VeklX3c1NYMJwWZcvBHmF-nFaASawfI22MuxutaIrrNiQk
Message-ID: <CABFDxMGRO_Mh-c1RvB3-SWAN2SJZK64qb==sOqb-MhtX56_E-Q@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/core: set initial quota->charged_from to INITIAL_JIFFIES
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 66B7C120003
X-Stat-Signature: 6bf1ediymei1ipqf1bpeuyzycmk3om37
X-Rspam-User: 
X-HE-Tag: 1755568335-918641
X-HE-Meta: U2FsdGVkX19XA3XSy5lMu5Q8N7Z8alorJMx7CwTwUdMEsAeaoobjvp8KChdVZk5JjAXBubUiR2JnD3XVk22AuT8s3w54vO8yf29HzhWGgiR5YIIh3RnhP3TeFdFOtKBt3Hbr+eXeA80bvChwxBZ5S6EItjV9E66L11VXrGTbIqa9YBKw0JctuPsmgiQluF+yf+EHKmNxSqmBDlzm08Ee5qnfLxeIanEJmr2+exMAX1K9xS7iBGUUzvW5M9pIWEXRQ+Hwh3/bgPDVPnUSLd5qFkECg8qmHK/ezKIOTBGs1GSwiOTZaNTMrU8BlKUaLbtQ3iFVCEQTk8HyvJSZIMD1AkyC8KJtxyv/3pLFMMoaHJFKFQL0eRoqgW2FQNtoiGASdRUJ3DRzMCHX4bhMZ5l3RX/a+IKFlCBF6OW1zbGnGDL3Z09uwJCp3XRYMahbgJbABhBLa4QOFFaNmAaY0iWI/Dq5POqB2pyjqE6Dner/143+WezNMGo3gEIgYx7Wwi/Vky4n64d+JGwcm1gsemLF29TQtvx3tbw28PcF0FEFaFVaxch38A0/yQ00sslOV4OLLz7UcXx3zsiRaVzYd9Y/gkUdRjsz2OtwyHykn//GYOIW3alHIZXleDLcwNqiJhlKmLGpQzBOD3bOcKVPsGhcykHzHcKtwn4JX3lPCf5fZG8Cm77Ifbv4W9HRNcZ4LMT5TUhExxaZs8xCpPs6HO6Ik3WOLr9R7xXgwCwj7/Mgn5BmFudSUjmQS6WoiGgtcv/RG6JYk5n8BK1qgpI1lZQIEbhWIFInRdx86uEKiOjUJJ0f6lhhDkCN8d1QDkPRLR3FaIMp+pITl1LL3T70zCQIH0R25K9KQIAGYO1pXxjZUMy6c8TjC5Pq9+OgkVU/+nVtXepyxL7uZNZdgC1psohSVOozf3tX4JwD+9b99OO2ozHO3xj3E6nzEYahRT8/nj3RdLrWu4Pg5yB67/Nu8iA
 IrZft5Me
 AAtS6jM3xzEG+GX4PoSqhOog8tYyNfwgEOi7ilnCRcxhrVrc6MIbR8jTOpg3aO2kd+0eg1pnNc8hhxeIhO/MblXnGmizSzPL0/gUS54HnE9obrY+LIE45LdtrJAXBG7oHp0e+ALz7eQJXAXFkkxyXlUGvm+TJjqs+vTgE92vUgrrWtR2h5N0+3SFoEA0U1Aor7Muhotio8AxSvLfN0GFGTXQ7nbQgJqMWv9MYbmSvLYZyKYMy584SUDaHSXCArEUT3LZkD9zF4wGu5xQdGTJdQJibTqTVd8Ul930sjBqrqivK2DPirhYh0n8akiAZOby4W2vPbHWWc4IjzvgnGizl5FpAlRSpjB9rUdyknCaQhOS2ItB4iH49PVj6pcIPwcfpwlRWL4c0zcHQir1foknKQq99RfnbDn/PhXu157kCsYWDnkWv5GHvhAiEIJO5klUhb2ld
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, SeongJae

On Tue, Aug 19, 2025 at 8:01=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> Hello Sang-Heon,
>
> On Tue, 19 Aug 2025 03:38:03 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> > include/linux/jiffies.h
> >
> >  /*
> >   * Have the 32 bit jiffies value wrap 5 minutes after boot
> >   * so jiffies wrap bugs show up earlier.
> >   */
> >   #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> >
> > In 32bit system, if quota->charged_from is initialized to 0 as it now,
> > it will not adjust event if reset_interval_ms passes for the first 5
> > minutes.
>
> jiffies is unsigned.  Hence the initial invocation of time_after_eq() in
> damos_adjust_quota(), which is the only place reading quota->charged_from=
, will
> return 'true' and the quota adjustment would be done without delay, unles=
s the
> scheme apply interval is unrealistically big.

Yeah, jiffies is unsigned but to cover wraparound in 32bit,
`time_after_eq` casts intermediate value to signed value.

#define time_after_eq(a,b)    \
    (typecheck(unsigned long, a) && \
     typecheck(unsigned long, b) && \
     ((long)((a) - (b)) >=3D 0))

Here is an example with INITIAL_JIFFIES(HZ is assumed 1000); a =3D
INITIAL_JIFFIES =3D 0xFFFB6C20, b =3D charged_from + interval =3D 0 + 1000
(just assumed value) =3D 0x000003E8 and a-b =3D 0xFFFB6C20 - 0x00003E8 =3D
0xFFFB6838; (long)((a) - (b)) is interpreted negative value in 32 bit
system.

> In 32bit system, if quota->charged_from is initialized to 0 as it now,
> it will not adjust event if reset_interval_ms passes for the first 5
> minutes.

Also, you can easily reproduce the above situation on a 32bit system.
If my explanation is insufficient, please let me know. I'll try to
find another explanation.

> Please let me know if I'm missing something.
>
>
> Thanks,
> SJ
>
> [...]

