Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 258DFE6F086
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 19:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64FF56B008A; Tue, 23 Dec 2025 14:25:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD506B008C; Tue, 23 Dec 2025 14:25:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6066B0092; Tue, 23 Dec 2025 14:25:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6E26B008A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 14:25:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E00C71A0539
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:25:49 +0000 (UTC)
X-FDA: 84251715618.10.8883F78
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id EEA66A0017
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:25:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W6MJ+hxf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766517948; a=rsa-sha256;
	cv=none;
	b=hJONakleI2rkQ6c6wywdxYU9Ggbcn2vMQxaQBJUT35zqoQjfZv/clRaMbD+6R8cJtuxQwk
	vz4NujCEONfyN4XDju4V3pPNI0KqlVnPLpVn04iTzPn6rrf0fBMSqzt0bgUE22dN9Lr1AJ
	9hv8z6DB6nu4JqbaDrdAy22nJjudm+s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W6MJ+hxf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766517948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KK2yALWFi3DSDt3i2r+xoSVTyoCJ+oh5Wz+q62D7I+o=;
	b=z8g0HDiat0OONTsPY5y4PoCVsGkapWAErLeUZuRA+TVtatjNjDhA3KMUdPpg7gBRVN66wV
	jBCCdsmDrERlCL/NPaEMsi5YHkTzl+fuct+y9i/eGSChQKoO43oMG2k5njsXKL5inex9Gh
	JHJRRCuDHeC3ZpHGFEByIl3j8vyK6iE=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4779cb0a33fso53799825e9.0
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766517946; x=1767122746; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KK2yALWFi3DSDt3i2r+xoSVTyoCJ+oh5Wz+q62D7I+o=;
        b=W6MJ+hxfSu9jS3noW8Z2oswI1yqrK9Nkt96PgpdNweK2jS8U55zLbiXy60u+AsOwda
         tQW+H0QrdED2gSVe04gnMXz2vmqDixS0RauDkosz0YQwywr+ubSXUsEci3ntIEFLN7st
         NVjG7L8zb4AdUwlEcYYCC8pszBRX1Ing7YRPNLi3dN5t56xVepjSJOR8Ry5QwBagxoCR
         SAGge8Jxb4K1v2+RuudzFM0TwERFwj69Dzr0Y6fJlPJ1Vg0lLLH2LtV3eRAaGwLMbLQ9
         +5bZMIHU5dx64G7yRBZHHo71VvOYAFxqSHCSj5d0r0xoYipI1bVvSOWSzaQGXMNQ0j9Y
         mPQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766517946; x=1767122746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KK2yALWFi3DSDt3i2r+xoSVTyoCJ+oh5Wz+q62D7I+o=;
        b=c9kL+tKGET8wuFTcoc/pf+9uttXSplXahv+qZQyVkZrGKRz1tpNj3vqmPIY4v+0LKB
         nJw4JYR51uQDOoZG3iYMzH7CNRSbekKF7fRrMhwcve/gZE5ke/ZUAedjs31kAfbL5Owx
         8H7BMApjFMhVwlTtAUetLVXhxO1ac2GEryPWWmz/+MvJD/uEAmemb0Td9oIyydyaeK+k
         hddKt63X+oq/KsM4MlvcxUpnsU2RArnfEO8FyVhlCyOa14eZFpd72t+GDdpyqVLfOTtj
         enSkEIhCYvPy4Sf0A9Soz49Gy36mnEfl0v3Np69j88M1EsisgWoJ/WezY3SO/IkarMsA
         uAjg==
X-Forwarded-Encrypted: i=1; AJvYcCWssAIjpPqN6VzrTlrSNtcmFleVa7kDEiF8pWkG4xre+83HaaQxiQDkfPawbMFANyFexSnx4++TlA==@kvack.org
X-Gm-Message-State: AOJu0Yy2GlEY0lz0V7KQhcZR1lOOUvL9r14yqzX1dugcagoZ969nIxHx
	20frxxmkpQFvtl3AQgZTYRLQTV+F+ARhX8XV7zMihFdoI2CmVOK1qD/SWeSTzIe4tqeCCF+CERu
	fIXM38tvZh885PkzFkFf/UG6tjGNhpkA=
X-Gm-Gg: AY/fxX4W5Xz+7CxPD7ZKQaBwMQ4lctXWH2aeCQXRUE0NWFoL4saHd4WpkBtcwezx5YV
	qUwLoAopN2svvi7phWauJlkIFj6oc/lV+poUUyiXVT35uavaUo/r7sVOJ4/kj6rJmS4if/6oIL9
	nfQwIIV/Apg+uZX/+dCoSSmyFAWVsdAqyKrvQ1EeYQyDDbh164gIWiDOxuTsN3A+FnAe/1FVPe9
	kPhrJNR/I2DNC4Rqn44VbLIv2vL8KxYpkInOMY1p+1I1NVkZmMHusK0+p6CJBqWKbXoJtoG
X-Google-Smtp-Source: AGHT+IHmbdehsTMhWLssjldnFNH++fTjADR70kJcuX3gmJPL/85z4DU6sj2s5TO+oqphYvRmuLCZyPnRKN8SeBRFQ3M=
X-Received: by 2002:a05:6000:2889:b0:430:fb00:108f with SMTP id
 ffacd0b85a97d-4324e4c9eefmr16764898f8f.18.1766517946354; Tue, 23 Dec 2025
 11:25:46 -0800 (PST)
MIME-Version: 1.0
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
In-Reply-To: <20251223044156.208250-1-roman.gushchin@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 23 Dec 2025 09:25:35 -1000
X-Gm-Features: AQt7F2qyhh02kqVtVRibcEKEsFoYW4v0aNMLzxihbL5R7BN5gAyR5u72cVLxIOM
Message-ID: <CAADnVQLAFav8czDjCYPyjDK6Bj7X_L70WQ0eSFTwvsxxEXDzCw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/6] mm: bpf kfuncs to access memcg data
To: Roman Gushchin <roman.gushchin@linux.dev>, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EEA66A0017
X-Stat-Signature: u74o73wj89hb7c8eco9rq1s9cegbze4s
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766517947-518621
X-HE-Meta: U2FsdGVkX18yWiNJ0oi/q4NznkeZd6pMIHexQxDgwf/CxFTzCVSxH2/L278D2hONqMvYrSgnNfamjAjM6NSWtaPe1Nmzn770e1pWK1gtOkLZ9R1JiFEKzZWc8YOCJFoBcquP4I8nwcwS12J+CducY1gv6sOMWvxTk9MTPvZpTYu7dA3juaAMojMUsF6pepc2v4yiHCKpBgd/XQ6zyVCLj0hN5ffefuuDlYqYa6tB97g766+nZrCuClJG4PUJNpX24N4UtOGwQtbtTPxgDI7D481fN6+eBw55vUfj/dzai3RqAwEVbBTO+xL5S8cXBmORaXDs2JRaFfAzXZKBdgxX8mZCD0nSm/MJVj/pj42Ez+EL9i69tFajGfWHc3esywmvJH0oWs5QO5ajqUBUKu3zTdGnX2H1QypxhVw8aWMloR5JK6+9/jFP5gwwYUnN7xxrutrs0ZwLnjyDhJLgB0fEin5nkMqeyUUAhKoK2hVZHD0Y5pcvCj+Si8Z/qgXn3mjd0ZQDxGf+7vUwxc4gnBWaKrjlpBXBHXbS/Z2JlMtJRi5qaaKx9QylHdHoSVqiERKku/1at8FcpZ/vd0KRKFRBkT6gDHA6KJofb51k2jWzeGwvRxi4xKFs2D0yy+kE5LAHo8UxOVhaWMFZSctS8093cWBhJALQYHmIB8ou7OrHp/qV/4/FUIYySj43yhY/1hls7eYhAg58PgdF99E990kRIMeE0auuplJc8zNN6KR0YhV3NLbWoUOBT4tb4wH/ZcpIjanOOq31wyjK6ZoI20SHkWb7vHQVwpKGm7VR6NtVpQsPV3Byj9ZSAAIhiDc09InyRVyEmMGIPGxv0/pgah4BVnI0+OUMN0BpMUj3ljJkNPu/ww04AhlPbHsab+Rn0zqYQuqOxYJmy3Sm8Vhy+pz0yPsxgc5xkxhVFEmpPaL8k10ATD6Dmx1iJBFaCPwcKRWDmzuZ76Os2hQpqsGx3k7
 zuZqjkdW
 RVMlGqSTFplWB8CJ8cYH/eKJIVqxSsRFWYe613w7WyLUuHyyKqli2OH/QbvK2Y3eTqusWsSpljm9bEZwJ5UdM7Ue5IfvBSUsSK6J98BYekOH9DWc+m0iNfSzzosL8oSs13H4U/k/e9fYeHR/no+TLusN19WMURDbksaYd9JDTCa+A1P1E4LE6/KcFoDX4ifupLKQHKuAqUYopk0uFfb/rONmhpypI721MExaKuZCVieYCWqTrZf+Rg2rryD0ah0xEtwONPxXC7GpXa6OG1q9iAae3+Qg0GvlpabOjkKDI6E+GtzgecITwblMqXLD5WyRuQapEvoGvsvAUMmwXHBNKNApkXh6Ol4Gj4HSa4Ye35Gqf/qUoaCvwMDT75UaMvs/+ppPaWH/ro4jFlZ1KbOj44zD549Moi6Va8wim
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 6:42=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Introduce kfuncs to simplify the access to the memcg data.
> These kfuncs can be used to accelerate monitoring use cases and
> for implementing custom OOM policies once BPF OOM is landed.
>
> This patchset was separated out from the BPF OOM patchset to simplify
> the logistics and accelerate the landing of the part which is useful
> by itself. No functional changes since BPF OOM v2.
>
> v4:
>   - refactored memcg vm event and stat item idx checks (by Alexei)

Applied yesterday.

pw-bot seems to be completely broken. No notifications for the last few day=
s.

