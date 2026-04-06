Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3C61F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C42C46B00F0; Mon,  6 Apr 2026 10:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF3406B00F2; Mon,  6 Apr 2026 10:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09256B00FA; Mon,  6 Apr 2026 10:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9E73F6B00F0
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:32:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 425F214045E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:32:41 +0000 (UTC)
X-FDA: 84628372122.29.D6F525F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 089FE20008
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:32:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W8z0NGYY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of luyang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luyang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BB7ZzVFvKFtoUpkj9mTwdFiRZFNEpH/aMohX/LBLbM=;
	b=Day+8ywt0kWE4yifOtccivXF8DkFbu/fnFZcmCw3CxiLzKXFHVwDZES+vUznEHVczSUyqP
	A5onaw88m2JPXjAM9l2t66AhBeZGggslytzvyI5AP7dUwV7YduAYTyhf/a3maBsVPOT9yN
	0tDmaIHM8hxEWiQURr2NSiCAuyM+Ohk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485959; a=rsa-sha256;
	cv=none;
	b=azJrVtKLwBsiLZoxaMI3B36Z244Z5NKUOA1mF3nWpgWNGYheiGArelFGMsDxkjWyM4Yxw+
	nhuU2RVqq+oiHvZIcWcqMnwIa5zEuPwFWyYrsTlZLLsLJT7Hsrkq6vXMvCRnT4ovj3c4A4
	XF/Yy9YUkVONFl2dFTbkjpwjwuSTpf4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W8z0NGYY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of luyang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luyang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775485958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+BB7ZzVFvKFtoUpkj9mTwdFiRZFNEpH/aMohX/LBLbM=;
	b=W8z0NGYYrJT+5ZDUUkvRZDkRlC55zGPtCqps8usmFwNuEsZb/OtXuNVKOMQOYea7A6ieVV
	hIiHHvQVmEIfDTjXgAD8zn0WbDstDBn8tdDZcyVgz+mpXIUO+jyRxkk1lD3PGuxT+WKepZ
	u4EOfg4ha3uuhbCCxl/46B+0ON37c+s=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-miLzkPDFNFS1M4HgDPV_7Q-1; Mon, 06 Apr 2026 10:32:35 -0400
X-MC-Unique: miLzkPDFNFS1M4HgDPV_7Q-1
X-Mimecast-MFC-AGG-ID: miLzkPDFNFS1M4HgDPV_7Q_1775485954
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-794b240c0d3so101409347b3.0
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 07:32:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775485954; x=1776090754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+BB7ZzVFvKFtoUpkj9mTwdFiRZFNEpH/aMohX/LBLbM=;
        b=MPuwQ3Z0lgisgNdAB/F/VjwJn0VBikqYMPqei99kPSQ1G4yWnjZIzhqHsfnDLYbCzS
         az7gtb89fc3P2xXJJTwn10GoGUbG9ISz8+gRJzE5ABbs9VLgLbvK/7OlDsrXgtFSIIIj
         dz2QoXnRvrV07gAlY8neUfY4cXK7NYeVf/A6pksRpMmfGhK9bQEHHAigkynPQhjb+3Wv
         HENs/+5MSe1vtdss2k0DbQ0iPqj49olQjdbewjpj6kfBHDmTov53cBKOke6ZuY0qaJHr
         ReobKZRxN9od3+SqFKGJMBtBt8hhJreTfHAbuTv94dIco0Pqw9dH+RetRGlOFla8byM7
         qw9Q==
X-Forwarded-Encrypted: i=1; AJvYcCW0hQNf5CMTB9PHi0RvDU668JmLGZ2YV/1e8MW8bQ0n2iwo/fqWfKQExaXtXeMqxZLDVWFnc+XP/g==@kvack.org
X-Gm-Message-State: AOJu0Yy5KS757gpyci82GzFNxJf12UNIYUWLcyKyJ0QhE1v7D7dGn6PU
	exZpyLMSk1ozH1FvTMDDbg+rL3ceksOGSm1qufSxtD5aA4gmz73f03dvaXbbvv5qUF18MbmwaKr
	vpuSVWmoNqo5JchAsIZHjaTSOmje6HF6C0vMOkiz0Feq2mOOajP8d4N/2qWJTYW6QzUkkCBrqXS
	tYAkuokthukwNFE0nH2y6yt5f9vvI=
X-Gm-Gg: AeBDiesQ7PA3LQGz0pSJ56FNfBjDAXTuljYNa3eKK3U0Kpal0ELBDIDpwMO4Alz9Q9p
	+uUcEQ9Rb2FJbxRpRIdrnyu/0BOSx/4tn1VsrEGmJAahkDlti3haJ+0vv+mCB/tdq+0kJrQ0lNT
	W/aEZlx78UFrG062FI/mx84poHm/NjyEgbvROcN82fr016Y7wa2cG+Sd4FeTWvXuG+PQc8pZ0jB
	RP4boI=
X-Received: by 2002:a05:690c:4903:b0:79a:cc5c:23d0 with SMTP id 00721157ae682-7a4e1e31b2bmr97819807b3.27.1775485954447;
        Mon, 06 Apr 2026 07:32:34 -0700 (PDT)
X-Received: by 2002:a05:690c:4903:b0:79a:cc5c:23d0 with SMTP id
 00721157ae682-7a4e1e31b2bmr97819557b3.27.1775485954002; Mon, 06 Apr 2026
 07:32:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260324154342.156640-1-pfalcato@suse.de> <CAL2CeBxT4jtJ+LxYb6=BNxNMGinpgD_HYH5gGxOP-45Q2OncqQ@mail.gmail.com>
 <vss5mbyhbf756jieb227fh6yu6vvvsggagll3ru4cmlhbbwo25@xv54cwfx7klf> <CAL2CeBxOa8ETNw-uP7vX7dikCty0QrFSUpdTSrmF6oAKkLk-ZA@mail.gmail.com>
In-Reply-To: <CAL2CeBxOa8ETNw-uP7vX7dikCty0QrFSUpdTSrmF6oAKkLk-ZA@mail.gmail.com>
From: Luke Yang <luyang@redhat.com>
Date: Mon, 6 Apr 2026 10:32:22 -0400
X-Gm-Features: AQROBzDw8K6DwnKzwMUtKNPatLfRZ1ihy1Fdhyk-H1KQHhTn5ciCPdBwIbK2aXE
Message-ID: <CAL2CeBxH+9=_vwfChs3w7af2_8iy8Kzrjx+fmy+Y6=9inBuFyg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mm/mprotect: micro-optimization work
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Nico Pache <npache@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Stn5UpSqjscVFZPi2npjt0gRLoyCb9x1zg4y8Hdyxok_1775485954
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 089FE20008
X-Stat-Signature: j61f9s68g1rqabjfr6r6itrjbte3qd4q
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775485958-959162
X-HE-Meta: U2FsdGVkX18nDA3P81jdMU6ZkbRydM2cDAvtS7vCIV5B8m8hcHFTNlLlmbQQ6uezevTQLOW6oIl3ld6iiuU0VYLe/j/rrUzQGCW6V+1Cxd3rDwc27GGRZy4r4dIiJLnnQwZEuZmjrXCkukw7EybEnIcgaypzzNS1L44ezPAjbW8kbBu2yWqsf+EAvRaQARy25w5jPGLUL3aJeKC6jX89Qt8yplLNjdS2GPF/0ixJl37lAqjA4D/hdPOhmrwuYK7Q6xtoXCnK/PFoRueVXjWaF0ikSKGO3az9JPH639b31o0XwxkagNTO3JwKADAaQRMhtue0zBQ4CkeIUcd7dWQcfFeFT4acnITGzEvs1JT2yz5E9OZmSYG9OZ4WNvJeP/WxerzJIxt3JEt6t5RG/DvLhe/Y3TVvkX1jhFaMz6NUuUCxMxjAQJBiEIk9sijQmY2CN0dCVI6LKrjSLQZl/HVSu+yyDrPddy9hTWZMRhyQekpBtgyMGUO7eL2+WtXbLnzIeVRBttfKxCiZYHbYxFTLTbVHqzOVJi/3ILzhxX3/HWkHx4eVTyn0XbXa8+p95tX8xnl+hBwz/KnWcj1/FhKGEeOoLPvladcyNNPnms7kYCTnN/2+hChXAQLvCeAR2tZyD0p5yvDunEH+JB8wRF7iGeruFpMwOV02wD9WEL5YlnfWx9sZx1Mij+UouG8R58IQxDKUTiQuncwfWTpUCpX8FlHn5l7ZGTG4bX1tBMMEolRCH4MbeeaOdsrKy0MhHC+wAdvoBOR6DgE7udPSLC/fQj/cy6NLxfg7yfudZ+uMhIxapUV1tzlxZMoPCDHi4GJEfOp6+5AEeXBzLTCc4mAiJa7Q7B89YQx3zGAX0EQUdNlO/eXTUi2ut3cXtMLkYpPAMmz8O2NTlaFp5tXZeuxu/Zkd/1xDkDFLBTXP+nLOvjrgYfcjPH5bmJa3D9Ia+w94llrgoeGJgHejL396JUN
 JI3EY9PB
 CSi5f7yOlqN6kUAZqDLQO7VmrlcosURuF34wzxEG18pUHvdacmqeECjzc8uWrl6vfsNQNhGhBpQpHm/QA47Qwclkf8aEMD96M3+d9bT1lspdtUtBgep7RaSWSKR0l3Y0FyOpxjBX7WpqNdQ6xxd+B7cDVHUz9XWCvv+DiVnB5digBPBI06Sor4F3orre8D5A7j04rQPpihWLn64DW5b7kUPY6AbFnwtVz8TrAe+TDvD+4nvl76przvb+HHRQuJjxWvUmI4MdnESXvkFhOCbJ6WZgWB+IljBc7CB6I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 2, 2026 at 9:55=E2=80=AFAM Luke Yang <luyang@redhat.com> wrote:
>
> On Wed, Apr 1, 2026 at 10:11=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> =
wrote:
> >
> > On Mon, Mar 30, 2026 at 03:55:51PM -0400, Luke Yang wrote:
> > > Hi Pedro,
> > >
> > > Thanks for working on this. I just wanted to share that we've created=
 a
> > > test kernel with your patches and tested on the following CPUs:
> > >
> > > --- aarch64 ---
> > > Ampere Altra
> > > Ampere Altra Max
> > >
> > > --- x86_64 ---
> > > AMD EPYC 7713
> > > AMD EPYC 7351
> > > AMD EPYC 7542
> > > AMD EPYC 7573X
> > > AMD EPYC 7702
> > > AMD EPYC 9754
> > > Intel Xeon Gold 6126
> > > Into Xeon Gold 6330
> > > Intel Xeon Gold 6530
> > > Intel Xeon Platinum 8351N
> > > Intel Core i7-6820HQ
> > >
> > > --- ppc64le ---
> > > IBM Power 10
> > >
> > > On average, we see improvements ranging from a minimum of 5% to a
> > > maximum of 55%, with most improvements showing around a 25% speed up =
in
> > > the libmicro/mprot_tw4m micro benchmark.
> >
> > Nice! Thanks for the tests. I'm wondering, what CPU saw 5% and what CPU
> > saw 55%? Or was it just inter-run variance?
> >
> > --
> > Pedro
> >
>
> 5% -> Ampere Altra Max
> 55% -> Ampere Altra
>
> Personally, I can't conclude at the moment if this is just inter-run
> variance. However, let me re-run the tests a few times on these two
> machines to see if this is consistent.
>
> Luke

Ampere Altra Max seems to consistently report ~5%.  Ampere Altra seems
to exhibit more test variance. I now have some test runs that report a
5% or 10% gain.

Luke


