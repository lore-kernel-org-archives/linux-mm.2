Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D40BFCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 04:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1507D80012; Mon, 27 Oct 2025 00:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA848000A; Mon, 27 Oct 2025 00:08:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03E080012; Mon, 27 Oct 2025 00:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D83198000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 00:08:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39373B8CBE
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 04:08:00 +0000 (UTC)
X-FDA: 84042561120.06.51C6766
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 61AA68000E
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 04:07:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=abXmGMrf;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761538078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ibO/MfxDLcDBhKW6DTcsagfs6zgnKHMHLzVm/Gfs7jw=;
	b=AfUsfz90610T7IbqJD+37CE8iCNmJWi+R7521STb5bDqoR7TkS5VZrp4W8hfVzAvyjbATZ
	12tWC/fRZXBnQ7GQsOjCW5HqmOXVnasLkFV9Et7PfjLbYtEKert5FtlqmNvY39O3BvScOU
	AZIbgw2nAn1mm8fCyh6Pbbw62fiGFWg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=abXmGMrf;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761538078; a=rsa-sha256;
	cv=none;
	b=j4ZF5Sfz/Fa/vO3CRQNaPWj0VSgP/jVUaPrLWab63ANPArCocOFo/BbvpE4wHKMIj5y06Q
	q+GkiWHJ56iAr6nMLqcohBb78aJMtHwWZ1o/qL4fQQUAO7qIh8Jd4iug+IYuCM2BMzeFdJ
	Ua3VYWnExLcMK6q/VW4vzm3DNlJWqds=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-89f54569415so206659485a.1
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 21:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761538077; x=1762142877; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibO/MfxDLcDBhKW6DTcsagfs6zgnKHMHLzVm/Gfs7jw=;
        b=abXmGMrf9Gv3bHERyirW+qvbFhYlEJzhVYVDbO7g2iBL0kTJ4aBntQUtT2Kj9UwMPc
         keKq7BfShmtt95rwC9awGtgY1fq6iEZp0EeDUxzFOkOseeb5Tj/DTy0zG9Jliv4l6pHJ
         rISEAEEoqY1BFpbhqF3HTRW2+XTQ9wd64IX2znZUh9zvVmWTVr7wuQ2pVLDgPM8uomBi
         tVMh36LIaYZrTyXHK6koAB4IQdSXMWFUS8AISy3uSyVsbiRlZ7H5ZluyA8ZtwmnQBCeE
         cf6pOf6KbBFSYTE4ByEkhpyurVhhLLf/cybAwBrpWteRFT5ihHdjE3urBdSNR0Y+yY9Q
         mrSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761538077; x=1762142877;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ibO/MfxDLcDBhKW6DTcsagfs6zgnKHMHLzVm/Gfs7jw=;
        b=MYDPAHpFUBfK2Qc63HUVHJ+o9V94s9F8QmAGAbX2RP9zY3whdDBtFG6l+rSx0/esAK
         ALw/2CkYmMqYpnZCIbFVNsQ2Fr8SUnmiMyzSHFwhGn3lRlpOkgcZE7SnfaOvGx9cXj+I
         UbA21zn6muzk6K2z2fSMjC69dm+qh9gvZZyjWAinEZZX5OobVhw6EfCBraTQQrhxTQgk
         S4jVo1jcjngSVv/QY4+uZ/POQ6Wx6BPUpsfN+KdyIwuHz3kVWP6J4thUyY8r40hY1Vb+
         diacG/xMr+3/uS0ZMwzS9bgnjP+3iNTDhqJwFuawQeGX6zyyWm4aZpsMPtjUt/BnmtAM
         uHzA==
X-Forwarded-Encrypted: i=1; AJvYcCXJg23XP+Y/lDhKVJE78CPRsLLvFEvdres1z340zYHeVAq3yopQ2LMIRqX1YrDrOi+4Q8yZePyV/Q==@kvack.org
X-Gm-Message-State: AOJu0Yy3LAtFC/v/Jx+LjAOD5LAHrMxra3xSeLJmwXF9nTVBE67whNYV
	6FUeYOVmYQ14vzf9Lh1e8mBkKwJwAz5bGGUPP9RDiKS46qq1YvLXu/9X/zyzwYmasfb/sBdJEuK
	U/fbIQ8FaB14yR7aYYyx0qSEzEiK4NrM=
X-Gm-Gg: ASbGncvOkmGE7TkBNSfm1tRbjxKY/d4sr4x0sgOTmlrB73QqnM49Q0wTgQJAc0wx9lG
	uyojVSCWCb02FjbLUBBqe/Nu0NylIGJqpLP23fPcjM8SdUz+Jbv+Jg2v5BZduBjvua5Qwt1zvqA
	bG+5rAEOzET3D5MUeDWFNQU9c1y4a8dsyEZCOeIOYUoCFhY2L4CGQSOwsbdD9WtCDKOyy54mxw1
	FvPIVceeywdjwNEv5SyvwknjmhgdB2nQZ7AwNHc09pHp5ESmSwQmvET6VUkMWxEx4Y48hh+rFOQ
	xH3bzVk/SnGWU9Vh
X-Google-Smtp-Source: AGHT+IGefw2r8nKdqOS0SwKxCjvapqhvhgaNjigQHwL9BSMI9Uj9YevfnjblAyLG9nJZtA6yZ5tJ9nPfP/17o5LX1lo=
X-Received: by 2002:a05:620a:4556:b0:8a4:e7f6:bf57 with SMTP id
 af79cd13be357-8a4e7f6e1a2mr122937585a.5.1761538077288; Sun, 26 Oct 2025
 21:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <20251026100159.6103-1-laoar.shao@gmail.com> <20251026100159.6103-5-laoar.shao@gmail.com>
In-Reply-To: <20251026100159.6103-5-laoar.shao@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 27 Oct 2025 12:07:45 +0800
X-Gm-Features: AWmQ_bnqDQ_nqt4D6_uisIDfd46Kja53Wh7oCLWwA2TUqJRp3ILNLRZozn7IGYE
Message-ID: <CAGsJ_4y+fW1wdvZzfRWbWQT24rvA6vGJ4-oxhJBxXMr9m_d7HA@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 04/10] mm: thp: decouple THP allocation between
 swap and page fault paths
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	martin.lau@linux.dev, eddyz87@gmail.com, song@kernel.org, 
	yonghong.song@linux.dev, john.fastabend@gmail.com, kpsingh@kernel.org, 
	sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org, ziy@nvidia.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, shakeel.butt@linux.dev, tj@kernel.org, 
	lance.yang@linux.dev, rdunlap@infradead.org, clm@meta.com, 
	bpf@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: n441zqoqg77e7wtuxi4oiphq463k4d6x
X-Rspamd-Queue-Id: 61AA68000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761538078-571139
X-HE-Meta: U2FsdGVkX1+HDZ8IdKwrI7ENbIlK0ya/V//uZhvPEW8EGcM8O6foO/gLPUtWfhg/1tTJzs6eYQhEGrkAoSx9D5NRC/5yCwF9G3cs0dJweWcUT0CqpHdjvUeClwCEbh7Ps1We5vBSllCw/SGO0YEtxAvkk2Bcx2uHkCp4g5ML0pnEA0tQ2ZXTpuTK8lmHgEcy7V2B8QHiH8AD3B/htBdYPPx56CQJMBj3JXi1LcK5kY27HpGR6s5wELpTxejVZWYcaa/XCFwwkvhgSpCvRuf9OTU9f9lxCDCWI6Fy9XhThz2Quco7UaibmQGuBob2UUMGx5tlixPEZnjmpbuLFV8g3edQzROTdMz1coN9e+igTRqFUX2bwRYnSiO7bw7LymaB2om6pvhroWuGtPyfM0iS2JBnuuK4lkrXcL85ipdbAbyVTP9Nv6bIfyYnPLM8l9YqVdW0uPBFLO+Mxja//cyOf49z+JH5YnEIzjvYvkmZqoXFVqtymu1CYFUlO52id0E42G5dt5zm6BaM9KgSS53TOHF9JtOpnF0pEhN3RRxY6wsekKRGvXeUgjAQE2z/l8eCeaCCtfdYpiWf2u5X7UE14fClks6Dickw1Ewav2YEzvzRjYa/hJzavAKgIu9vEaz3fwRN+FfTTfqCo3PCnfiBN72r6OwT1koruONGtLBR9CLgGXvP9IjpKi75gGVvdYzBHexWTESM26V+kgKNBSlI8IfKzPjqMUR8nrQRJ7A/EX8/+zQJmh8EjNoNLUldPL1tcQDUhgNBSdNHHgzTRwRssYPczj+GmL88Uq3pj61Ig3KO9MXzeXauUnfE1IPujpy/7B4F8E1T9DFrJZpoyrEA6pnrYaWDKxr72xLv+IGkhDLG5d4o6kJMZ3yCdSujsyTzDThrkkXhX2OWZXHNPXufOmpgpPrcNkPdueEjg5klbaDXZChlbso2Y+KsKawAD/X38VZpYnHNCFyl8axCMEQ
 Q2HQGTFM
 SMPeJdo9dm1wQw5Z7/LvzLC52jfQZiFHOSpQnPZpqUjEK8GeJKqmiGFmi/O7vD906qum85lJr7VQUTyj+dK5yDpqp0pzIcfEMjaDlUtfhPycKja8cibEFQZcYw4HID93lgEOgtcHmsyKfrek4+Cqxjv5Cd9T7D6DJgDsqsaI3R8w3slNVvNdY5T4yjCEs/rWUSKssWG5n3JkcxD8HpYQ34TBU7GkB9RyEnglijym9Bz8rDktmXcKg+Wzh9l6Pp5n36XFvld0KqBeSSV+DmpbwtbCPJzqS2tSNG5Q2jGc5r4WpNgWHa+qfu6swvVQkbIUzMTG38MyDvfIdAyBQlXou5bDKSWZ6Ah7JRnuKjD6jL/PUFaSwsATRzbgrxV9grZj9+bT9rXZIDzRkog1wgbvQAVAxrjacZ/Koa79xRAs3dyV3y9ALrqsLx97w4C2PlweGLIbQSfxNkADUrRwn2iyzc+rSaIq5VKGQrpa+joN+2vI1DOq4lEwETRJ5fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 26, 2025 at 6:02=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> The new BPF capability enables finer-grained THP policy decisions by
> introducing separate handling for swap faults versus normal page faults.
>
> As highlighted by Barry:
>
>   We=E2=80=99ve observed that swapping in large folios can lead to more
>   swap thrashing for some workloads- e.g. kernel build. Consequently,
>   some workloads might prefer swapping in smaller folios than those
>   allocated by alloc_anon_folio().
>
> While prtcl() could potentially be extended to leverage this new policy,
> doing so would require modifications to the uAPI.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: Usama Arif <usamaarif642@gmail.com>
> Cc: Barry Song <21cnbao@gmail.com>

Thanks for addressing this.
Acked-by: Barry Song <baohua@kernel.org>

Thanks
Barry

