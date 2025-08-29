Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92AFDCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 20:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAFDF8E0005; Fri, 29 Aug 2025 16:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86FF8E0001; Fri, 29 Aug 2025 16:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CB18E0005; Fri, 29 Aug 2025 16:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7EB88E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:44:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EC74160893
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 20:44:32 +0000 (UTC)
X-FDA: 83830973184.07.1F189C5
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D8A440006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 20:44:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="2/ID0mp7";
	spf=pass (imf04.hostedemail.com: domain of yuanchu@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756500270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2q9phwNdrBTTHrc7DTMMS0l8waI+fDO2xGwQQOv6Ao=;
	b=3Pzg2SdHknx5BJfdHVdS1IgbTglsaYGa/LVdlq9v/dnT5+LOTTtXAXLAsC7GGJpIRCbIut
	44Alx4ihNWOBXeO5lApzN1AmvmSfUAvyz6TV7oKdIApAINeZOkpbYLhGKx114x58RdECSb
	rewrPGnUQHm79dcClKRY4WDQGhcszls=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="2/ID0mp7";
	spf=pass (imf04.hostedemail.com: domain of yuanchu@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756500270; a=rsa-sha256;
	cv=none;
	b=G5mJL446wSH49hPtZAoSV1D+zlZ/Y5REcXu/bsaz/esL4i09qKEBgt0dAgMWi8CWAvgYMO
	upgavaLShHKxfRLhE3kThQ9Tr3ehx1eJuN0q1j1DJTn9X96EabjIUB4QYSkD4Hz3JSQLPf
	NBmY59kiDXmIvuQP1PeIVsUyuIRn0U8=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-248f08d31dcso51925ad.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756500269; x=1757105069; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r2q9phwNdrBTTHrc7DTMMS0l8waI+fDO2xGwQQOv6Ao=;
        b=2/ID0mp7qBaLfadRYdH81IhowBjPjk4eKzfSMNznSQuZxjkkOfKk00NEB3zIc4gEDb
         tXqZNlQV7wWfUpXvUl4kPdtODT4VGK22AFNejwuDmmlHl6M8enlQx41x6V1gOmZikqrV
         vyOxiiLrwjGX6P2ryINi71bD8MPAPAySZ1e/cljScNuTVZOPzm3gWJHG9LxMXs9ZzhEt
         kzZbosNNmOECazNv07ZIx8nFFfjdJM5/6bHAkXpR5q6HMsj0aIIOY+ZxAn1itqt/zZ1Q
         utgxhH3mT9/Jh9yWNdRR7jWBFMKEIRtVwBdtyUzQH2FSnukCZ4Fb2bwznaR8lmLbA0l6
         a40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756500269; x=1757105069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r2q9phwNdrBTTHrc7DTMMS0l8waI+fDO2xGwQQOv6Ao=;
        b=bn6wFz1PxajqDz0cH+aViNee7sKZsWX8B9bkxcAXVIb/7F6UuPWaeaETYiQeJgOYYs
         ymKRN32QX8yeQWkbWuEceIlEIn6lCVI/ovaV5ZQzo4JqQpqO4Kfi5Sa+G5cNP59s56yW
         NAUM+4iheNxB/qljAGoS5llzIz7389lvxNyiOyYnRE3wiVjm+Y5aScU/H0vCLmG1qGiu
         IDy5qxy5qhPXBBCjq5mI/dgvhsIJbvo+YOF3YmtTwx7CySoiJLn8bRUp8H36CdlZpHIT
         PtMuRrvwjCIg+OaEuatB3W3MuA0X3HOVogw2Z5EN2F94vH0d++qA98YmT1nI9EV1nCAp
         2Cuw==
X-Forwarded-Encrypted: i=1; AJvYcCVtNw39NiJM1Vq94/XjwhZv/3Qpq1WJ8LcdFY+QH9y/TqLWFRJI/dMarRpJrcPs2cRhA2bMMo8GfQ==@kvack.org
X-Gm-Message-State: AOJu0YytFdYAgj/OfrAQYWusDFRK+KCTBPyRQuGhAhKM8uvYjW31Pz/r
	xOZuW59k2AW/z8Fn1l1BhKSfanOqRlYYa5WiSbusVDqVNUKA9lUaJS7sg2W1xLpV90iA6m86LbK
	4mZIosiKR1quzi/Igm7VZgf4ua9W+hpY8FJxwz/NVi89HyK3OqYn1Ibi//ys=
X-Gm-Gg: ASbGncuSjzXWOysq1lRiqFiMr9mII8CIrWKA2ejhbtc2+WGUW0b+Rf4tUZm7CFSmg3h
	Z48Tf6nm7RF4h+AadtSVqTfF6s9ONiO7rP2D8huDMNF8Jj/oFyfpuDKsWOmnxXwq6eiwRGyPKL4
	l6c4f+bUWnMth836JliXdnnVICJqLg5Ni5LSWdxrtsK+waOaFqqjrWM5mdPNLmpXGK49hW+d/+8
	jziIGIMoa0bx/O2fRVWRO9nIOaBEK1UfkDTHwFCKPYhzor/iyrwoqpGx7oUCoEGOf2vsdTzrLCQ
	qZDdM9O6kUw=
X-Google-Smtp-Source: AGHT+IF7k5lVtyim7FCdwKqIzS5FoMCKjb2sruw0NCU2My2KQyK5XacP05klsD3NAciNeqowwygvolVtflHAMPwPYZI=
X-Received: by 2002:a17:903:2307:b0:240:5c75:4d29 with SMTP id
 d9443c01a7336-2493e35ff71mr1048425ad.0.1756500269098; Fri, 29 Aug 2025
 13:44:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250829183159.2223948-1-max.kellermann@ionos.com> <20250829183159.2223948-2-max.kellermann@ionos.com>
In-Reply-To: <20250829183159.2223948-2-max.kellermann@ionos.com>
From: Yuanchu Xie <yuanchu@google.com>
Date: Fri, 29 Aug 2025 15:44:12 -0500
X-Gm-Features: Ac12FXyYeG72ntDgrzYOawZxMxaNyzRltRlGWQdp6qpO4b3XGq1I9z-x_Z4E9jA
Message-ID: <CAJj2-QHVC0QW_4X95LLAnM=1g6apH==-OXZu65SVeBj0tSUcBg@mail.gmail.com>
Subject: Re: [PATCH 01/12] mm/shmem: add `const` to lots of pointer parameters
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7D8A440006
X-Rspam-User: 
X-Stat-Signature: crw11khbpowpewzi3cb9j3d4kox187yn
X-Rspamd-Server: rspam09
X-HE-Tag: 1756500270-102013
X-HE-Meta: U2FsdGVkX1/zPWz9UJ1jnczRwU8ELI4HTH26cgVg/GzrXdvof3s7kaikAIG87eD2WVfH2r/P0qUYWScVUdAv6qm30mYJBxAj5qyKEJsi7enXrqNzSX+Xb66x+ELDd0Dcnyhg6hytLahXDIhP4eKqii3i4UM18XQ7rnsZZNuuihzv63Cff2/A/NC4y0DCcX0LgFLxoPIvyoRy6zjLPtUwjXmtrltIzpMmSM1FmEKpiG8pCrhY3C+tezpt1h+8UGDVR3sbbACoVpPHp1eDa176EIcdgyjnmp2S3JXltU/3O7doonMw3eyxfT2W9STUGnyOGA8j8ooxI+4dIl1m21bHZMCkSvSa7uVIaFWAZSmeI+USRD0B2pQSkbOodrTp1HvRM1aUzoiVVUYLeD96v9TMU8ZjYCviglCvPgmXjye/0uLEdMYyOjKVzW0B3UIhTk9GOFoq9jhm1bUwpUihx2hUP+o1O+/3Bv5l6L0bHq5jyDLK28VDHk/xa04WwNynmiUdA5xcphPqOh9pSJ6LySeI2MvPOM2hfzmcAnf7mMbgGkEieLwn3BFra/kDyAflTKfeTtXsjxiqTkFsrAK4RKthVDBQWx/zetXhfWTF5DDjuME/J6YqRQjFCMgCpHjv99YWmZ140Qole+ux3jG1B56E33UuRmU7eZrBVI07EH/M5XiH/swFUq9VvQtmz7BGK1kfxFIoUfY+gZUDTLOAFyBzQ1A2HNLLhooQYLnOdKmwoWcxyJxSX1VgcPYmo56YzKbK8dj/RUc5viS1t4q5N6rHCuPFIgYm6bbEYa1BuZgKUkHNbsnZGFSuYO3LMn4SRTxB1GXskhj6rm6FXHDH3PTSHoXo2J96KitYpVq3dd87X6N2xPGzAr6CvIAaQswcQNPcfPe1WzpSvs2AzSpWeuMxQpjw/n7MTGTmuyo07oXz5PFsx+1q5C5F7X6mCuK97I3mgurlqCr/chmZKIgUYWU
 WHU1dVp0
 DrbXk6lK+qOVptdUMOJgENqAXH3ifc9/KVUKYt65NndoVQJrnSvnZKRrXlKNOZCMi5aWbGcfKPFn7eC9QMDfWgGdzLyPv1lX5hgc1z0ZOPC5S/iteU4gNFG432wdtrwdoPXpXaQsofjtslTK9nM278Dag1Mhoo58SznMyNLKdW7mDqgFqGfPCL9QlAzvE0K7/aV3u2rJyQIUz7E5YymbhRNIkMv6Z1DCL7q+j/jgRdkjziublyCPRnY1mBUzfwXEpFk7yxfQ6Fd1f/CdR+yVSyN5cTL7sPaAuWbRhJ0dwK1XOPDrh4fFIvxiY70yvdbpYzBDLIgqJL3lSswpTZDqgqJ54vtpQCJ6HSZlvyxwjn4NRNt8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 1:32=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> For improved const-correctness.
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Yuanchu Xie <yuanchu@google.com>

> ...
>-bool shmem_mapping(struct address_space *mapping)
>+bool shmem_mapping(const struct address_space *mapping)
>{
>       return mapping->a_ops =3D=3D &shmem_aops;
>}
>EXPORT_SYMBOL_GPL(shmem_mapping);
The exported symbol is being changed, but this doesn't seem like it
would break anything.

Appreciate the work. On a side note, Andrew previously mentioned[1]
making the actual parameter value const (which is different from
adding the const qualifier to the pointer). Longer function
readability would benefit from that, but it's IMO infeasible to do so
everywhere.

[1] https://lore.kernel.org/lkml/20250827144832.87d2f1692fe61325628710f4@li=
nux-foundation.org/#r
Yuanchu

