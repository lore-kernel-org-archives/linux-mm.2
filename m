Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A612CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 06:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AE686B0006; Thu, 28 Aug 2025 02:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F4B6B0007; Thu, 28 Aug 2025 02:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C196B000C; Thu, 28 Aug 2025 02:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78EA96B0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:57:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF4FFC09E6
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:57:42 +0000 (UTC)
X-FDA: 83825260764.18.B28C222
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2119CA0004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:57:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A9VfgrSz;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756364261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNqgn+C2x+n8djesjxQXU7WZdkg9QWFo3iy0GNcvuv8=;
	b=qfWxFM07/Wmed60SmJIl4VC2q6K/jRHuhwFawSpFUcEj7jsGKMNmim7Y04nJjhHAJRrD5S
	1E+Ct8GKfrd/6FQdkFDprMz5sNPYucpxdLmyCWR+ZHHZG53+M2sZyhLGOhgbvNiKFSL7rP
	e1XAskOkHdySyP7q5B109VXmfnMRyz0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A9VfgrSz;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756364261; a=rsa-sha256;
	cv=none;
	b=lL7K2QgZfpu8wBDk/FLfSiCzfgM1YpEhTe0O8GAeybaeWtD6bcOmM7gpmnYSgYw8IZJy7L
	9cQPw26Luijzh7Kj4ndzzYSici/E3ZsDGqdwwalvliuyUsdcyokUFiLFAKQ48jQiwkTUd2
	60mhkqGuQwv6JZJ+M6YuQ/coNcYfnDU=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-70ddadde494so6496476d6.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756364260; x=1756969060; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iNqgn+C2x+n8djesjxQXU7WZdkg9QWFo3iy0GNcvuv8=;
        b=A9VfgrSzRGIbXd4Yc8X4fZEv7t1wtK4536wf78k2L9Yqii79Xq5XH09zpYucImllis
         KXKkS9HD5acEmEQ9wlSrGc7AQwZSRx4wpquaYlSNmlAimqZ0C3mW3DQDs8nWTHn5JJrr
         SNTmkb5R9pZua7CSPeEDjYC5a+ngyt8C6E+oo9su8G30ns6qcgHY2Y3DVEd7ChQgIkaO
         TJ/1txkpqEa9rc5cOZNGbqkOcK7o99BUQDT7x9ncmFPwgWHIXk7thVwY92yW5/2hgqbT
         hoRfozu9t0PqagI/HfHQcks7/13xrdIHpxS+vWioX40meZAE78r90DLgWqsNRfP55QfG
         6G4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756364260; x=1756969060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iNqgn+C2x+n8djesjxQXU7WZdkg9QWFo3iy0GNcvuv8=;
        b=NIwt0rj1Cgoa4qF2Kw1++mAZkleczHuKLBFJOPYYr2YaIsOisgxSblDQFLMkcYYdx6
         Tgtd801qbOakgONzf4Vf+eFgCAkCHsyvIDeiIXFPpojMnvVkezEbWVtZF7z3VI4gcb+1
         KU4UGEs/30ASDA+dAClsRAdqzNeh9v6Qs8R3M/Hg/1ZTofmgsKXqjkjLILQLFBJoBAkL
         Qvlkg/YHOVpMVqbUOkoFz20TY29wcWiEqtBchdnIPWaOY0tAMMmhit2Yj7jjuvByNfdb
         mlo9E86AWJ09jLo0DEWuhKxmPslBKJ306al7tGaOQH4E5dbFAMko3voxwRJNNxlbJzkN
         JWMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUe8PkpwoKQCJMWeiefuLjO1XrXqlKOsIIJ2Ui4ogU/ZT5Iy0ivnoGMBvQQFED5jjp+uhfwdh/LMg==@kvack.org
X-Gm-Message-State: AOJu0YxY9eZ/RowmA4DQkxGp9VJt+u1ILK8BCLZ6pPxHtGLR/P99H8f0
	+AUcV29xKoLMnjplHLSYAZ4DWjzfCgPwZTla16M+5PGboRhNM+5MyZob1RlzX99zyvoPme8RC4q
	S22wRdSmdM+mtTpfIEJhxjXuNNEyHgGM=
X-Gm-Gg: ASbGncuV/RlPdGaoJYkhx+Qwq54P36LJDFHi76EEhJXxdpEeU2Ei0ycqLZmJeTjLLmx
	AGUxAFAbKhyLSVdpoz6393UBuCmXCdeNs/8aCCEsVy0ZEUWaADZCoC//nuT/AESA1cOX7wiGNWa
	jMrY/RLi7B58NDuaSZfZY3vNhDK4Y4n5Qigo+wNLAoAX+mjIwKEtprc7ql4PVvEMfiFy2/fhfE5
	VNiRfhTtiK2h47SKLRG4qXtEAMsDEJUSyPwpfTlZDMEDzbJdw==
X-Google-Smtp-Source: AGHT+IEgzfyRzIDdVSfflhJR2fRudWG/oyg9t6JnrRbhCUhwPMrXZs7quUS9aKCLkTeL2HaPSd72LAiCFh0pxOebMdM=
X-Received: by 2002:a05:6214:ca9:b0:705:c148:26a0 with SMTP id
 6a1803df08f44-70d971e4c3cmr251105156d6.31.1756364260071; Wed, 27 Aug 2025
 23:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-3-laoar.shao@gmail.com>
 <299e12dc-259b-45c2-8662-2f3863479939@lucifer.local>
In-Reply-To: <299e12dc-259b-45c2-8662-2f3863479939@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 28 Aug 2025 14:57:03 +0800
X-Gm-Features: Ac12FXygvU0PTDWHH1nV9Tdj3y453lXYUAzGekUvEJHvbRAb7PUlo_2hu--qJCI
Message-ID: <CALOAHbAwTZQViuZQZpor9iMHr8w8AvptQTb5TEHrekN6FSjLxw@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 02/10] mm: thp: add a new kfunc bpf_mm_get_mem_cgroup()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2119CA0004
X-Rspam-User: 
X-Stat-Signature: m7u7ycxaotwbrd39rgpnykaq5ira45wj
X-Rspamd-Server: rspam09
X-HE-Tag: 1756364261-586247
X-HE-Meta: U2FsdGVkX19s5mSvl6RZWzLZFyWh5i401MpUufzm6r4b2pAhWEisrSDU0JHNn6ZFc9FO4GRW5iYKGSVsGMK0AL3mHYRnkxHM0f2pxA+RKCSWJIcKiFtnK5FB/56E1EwFBD+kNyseGMP7KqyVOPGhyFomXo+92WzU8DbsFnfOJoQK7sTm8Uni1w47mnc+kYGZ1D80hxDp4w/0cpFvt/JN3SH/6DmzSqEFuJzp4m2SDyo2chIfMYgwoJFzXmRrnNCt2PFP8BBx2iWZo3eTvCS4oPemVpoQzMLFIVUkFeisFZbVFBAlchS5Hlj2rYYbcZjKoS/swRnzUM4YZ5BfOXmNFDLJ54YuaDhCiCTjM7yB/66pt7Z+uERy9nLyP/Dj3oTw6aKoOZyXMXeNfbpOJNIuox9lcN5bLzycpoCMAyZrqDcouGbXQVMF8OjSyn97rWjJgxk7/fG1sShy8aK2ETZWq3ZmdmeuSY/tofurVnXeq8EEBhybsrZ35z2rGqPoSLK515g8NCsRH2e35PzwHJdTFQP2kdKd51g1TzZJKG6MVVbeJR25MWcl0wEkeb3u9GQhQDSXhslVYnvUJus4dwBtZyV6ZineqVF9ON0TFBIX/LzirzL8CiB8cknZxKn9B5iZafDwu00yaDOcE8e/1W9Q2vfNe/TkgyC4MxI2PsA1XDcxRfyxEiDrvh9sIEjSxw4PHiNM/hbSx4HqdUW6r1zSTSkbk+9XwjMassoSfs0ftYCo27RTtrpfHlbbHLXy5CS+L9a3d3BSE4nH0mFpFPxQRqsXz+A7bEOSsz0264wHCb7rkVM3XGnwot3zjggn0iv2SsJr5+F2ZX6U3PVLeG1FYvhqQQFQtvNLUlx65asJs4sXG/3ZzgVDI7IgjlEBF6V3WRKzcMejGy24o9ldmCnrbwzfVGzCTWjv+4yHiDBytCuLYwXmMBW2vJ0myuvxUK3x77CPfGbI8uLQGgrYXz9
 NPELcMHZ
 7Tj6uKavrywCx1v5H9OGYFI70vNw3TXXIkzkMEda6XF/zSXF9j21ercKL44/1cWfYB8hvJdpfkK4Q3XJLXaZwkY49ckUZVF7jT8546ydTNjKGifN1gNRTSqRphBfBpR3taX6O2z8qJ/lOX6lFmQ8DpyOjTDLSCJmdW3YZ5sQH2Ad8MWX3ngJWpLFPg/4OSRGvX3wFmUxNHqpL+kkxvei9igNmHOBBn4wPzkbtZjsQAyvuge+6nK9b66LT1Kq6OqqWQURgJ35bScZl17Sp/q301Cdg8wfaZVjbiK+H/S7ikRU2AGbLQa3UqWzz07gteUxeuOnCW8hAFJmzI2lmo1/l+HUJ7k5t53XeToXa3q1NA4FqZbA1P3aoNd1qkMpOzvzN/I3ZWbDLiHCGrYKkCt6SlR+C73LbKahPIBlj2gLDxMhv7prn0m5yaG+FufRyMt7MZPQ1opl+a4BHQRtTsQ/PTd3IXL7TCbVkawE/x7ATmwDenpE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:34=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> +cc cgroup people, please do include them on this stuff.

sure.

>
> BTW I see there is a BPF [STORAGE & CGROUPS] section in MAINTAINERS and
> kernel/bpf/cgroup.c etc. anything useful there for us?

BPF local storage can assist in implementing this feature. However, we
still need to introduce a new helper, bpf_mm_get_mem_cgroup(), to
retrieve the mem_cgroup from an mm_struct.

>
> On Tue, Aug 26, 2025 at 03:19:40PM +0800, Yafang Shao wrote:
> > We will utilize this new kfunc bpf_mm_get_mem_cgroup() to retrieve the
> > associated mem_cgroup from the given @mm. The obtained mem_cgroup must
> > be released by calling bpf_put_mem_cgroup() as a paired operation.
>
> What locking guarantees do we have that this is all fine?

As explained by Shakeel,  no locking is needed for this stuff.

>
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  mm/bpf_thp.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>
> Also not to be nitty (but I'm going to be anyway :P) but I'm not in love =
with
> the filename here.
>
> So now we have
>
> - khugepaged.c
> - huge_memory.c
> - bpf_thp.c
>
> Let's maybe call it huge_memory_bpf.c for consistency?

makes sense.

> And obv as mentioned
> before, add it to the MAINTAINERS in the THP section plz.

will do it.


--=20
Regards
Yafang

