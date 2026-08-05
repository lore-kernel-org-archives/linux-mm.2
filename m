Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ABFAC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 15:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844106B0088; Wed,  5 Aug 2026 11:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C706B0092; Wed,  5 Aug 2026 11:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731226B0093; Wed,  5 Aug 2026 11:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9646B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:03:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D3E2A804BC
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:03:10 +0000 (UTC)
X-FDA: 85067533740.29.DD6F701
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id B727612000B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:03:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=CCEub3ia;
	spf=pass (imf29.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785942188;
	b=iUUbJn6R09QWDK1IxlSQz+Ju2UIO/2bTq0yx0IX401j7XAositkuK15mwYYwCD5St3IAqc
	Dl8LnjEsajCdUfCJzc8zMxXxMdRtpUiI06tbqi0iSuh6JkjHwci5dyPBmbkkeOIOCbiFBm
	TQ+NFqby5uwEHmBA/WORJf6CyeR6Tlc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=CCEub3ia;
	spf=pass (imf29.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785942188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fweq2q9N+GbrkbN8984aDLyx40KVYsi1455vY8kKwdc=;
	b=SyNEMFLz96xT1rkQGKrqalMkFGXtLpMBP9RAIg/toyd+1O5Sg5HjCrPFzUPykfMjpvSgOj
	q+NtadHhU2ZcFC0dfb2PqjxpzyY+ZwhjRevay7q0Nz/SDsD9mf8mlEmCHYNzmri447uNwy
	dUoYGt6gQ5zbt6Vun4oJx0zRrBUSiWI=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15cb6f5c12so182104766b.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 08:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1785942187; x=1786546987; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fweq2q9N+GbrkbN8984aDLyx40KVYsi1455vY8kKwdc=;
        b=CCEub3iaNpookpdi/f8Kk5aO5DaUwX6AnI9piTdL8JObLgR+04tENIEp01TEb0LHC3
         BPwErwOlcefmgkjF1ZX4uQaS+4Gj/gFLGobgtghAE4LFDP3mMveTvo/O6C4B1UbCRyh0
         Z4816fjPQwbj1oXQfo372V4K3JKAzjGJzaM0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785942187; x=1786546987;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Fweq2q9N+GbrkbN8984aDLyx40KVYsi1455vY8kKwdc=;
        b=abPc1RJA1CO+S2HyvNeQHkOXFGJQKuzdAKkkRbFzwLPHVZrYB1vPPrYqgxUP0XExU6
         7HZgY+kxOPt7rJVsTIoHIBT3v17OP1GSUt2Qpwd25tOraSYe4akez2CfvUK2J+7M8gaq
         vG77W1Nt/pkft6K5gDvM8seQeRpDVj0uAcwbszJQEFbWz/vGduoc3+xsNRt9Ui1OFdzR
         THJCVXT21sVWNM0AcEgyVTRq0Gxa/LgGwWbDJydkIRgx6lF6d5x1bXM3k4UgSO+221UN
         pOjry4cORe4EUfNCd9b7nXXUz0egsQdZUOj8gh0MAzaOVna07kcbOVCy07xtBvUj9BtD
         FkJQ==
X-Forwarded-Encrypted: i=1; AHgh+RpSAY8ADZBboPPE75cSkcTMMyKD7t1OIPvX4V6D1B5x/0CJQk2i2zdwgEtFbgMJO0yerntNZyQFkQ==@kvack.org
X-Gm-Message-State: AOJu0YyecZEf51WJxQPuBOupR/dNg/915/ocJw6pVoFaM9N+QEyyxedC
	pRpMgIj7mXxFp1QJybxIdue1mg1s4u3h7GULnfTBEJBH1lOdJgtxDi146tV+YcUv12AitJu6B7F
	G3eShWI05YQ==
X-Gm-Gg: AR+sD13USqdLmRNJpS9gc8JVAou0Cz+ydHfiuN6wZiJvwDcLjd1kD3aVic0ZJcJfxCZ
	em8EqUM4N6v0pRB7Umwf3r7SFtCJhXl2wKt3f8SlAH05ETCD3idcAybCowFA+YonYblUyuqDwhJ
	DrrczU7ah/Q0aA67GmJCGSAZH3lT+v5Y7JlCBvZS9qVR1LJBIwe3Qqfe4oRW33M9FwbEaU4a5Hw
	zsug2X1r3xosDYmXcDzar4EWZt4/4NJnECqL7Rw0/j+niMN4zp/YX0Q/1IvG7VpuauqDeMTz1Ti
	r21w9wQVzpDq1+H5c0a6+fyNEBksZsnf6T/FPdMneZqi3ojHa/t3vCqFVkCKHMC/JLC0DJ5uf4y
	NzkHUTVvXJ69HRXe2RnTOhsjpoAT6Jlcff1wDskgK1IPXABSUmOEQOKPP/0NwDjywME3dH/i+I1
	xfkI6h5Z+QCkqEJq7/Oywh8OsLpqHRA0Dm5G0GMkYTPCp5qXrpTpEdLZu6qGjOr7IauFTqZeZFP
	lBHgqpvxrvPQNlWMqd0YEbycxoZpo91eW7FYg==
X-Received: by 2002:a17:907:3e8d:b0:c20:2d38:e518 with SMTP id a640c23a62f3a-c2039ce5eafmr375763966b.2.1785942186989;
        Wed, 05 Aug 2026 08:03:06 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2056b8c0e9sm15550766b.31.2026.08.05.08.03.05
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 08:03:05 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c15cb6f5c12so182096866b.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 08:03:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqirNdB4tIX7pmHyJ6l3MxVBR1DnQkTKK1/lz5xklcMuFZoODOgROewAoXRQM0mT+YyDnQURb4sgw==@kvack.org
X-Received: by 2002:a17:907:a648:b0:c16:72ba:d352 with SMTP id
 a640c23a62f3a-c2039f27638mr367831866b.31.1785942185481; Wed, 05 Aug 2026
 08:03:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260804003708.49830-1-luto@kernel.org> <0adaae9e-7086-4213-811e-ba6e4181e145@kernel.org>
 <CAHk-=wiO8NDCyBYrDMpjh8zMKnzgD2XuPYo0nk4Hwgq44R_jKg@mail.gmail.com> <5130d601-84b4-49c5-a9f7-454d54a7412e@kernel.org>
In-Reply-To: <5130d601-84b4-49c5-a9f7-454d54a7412e@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 5 Aug 2026 08:02:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjDfNV9BfW0r8c7PG+hBtDothP-9OROcanTLKDtujmBfA@mail.gmail.com>
X-Gm-Features: AUfX_mwvh3hDYxWJBrQyH8medqHq7XML4QZ1n7h1D8u6_NtrvueYHTrBQclTEqs
Message-ID: <CAHk-=wjDfNV9BfW0r8c7PG+hBtDothP-9OROcanTLKDtujmBfA@mail.gmail.com>
Subject: Re: [PATCH] Fix incorrect flush address in direct page table reclaim
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, luto@kernel.org, linux-mm@kvack.org, 
	luto@amacapital.net, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Liam Howlett <liam.howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B727612000B
X-Stat-Signature: 96gnkrjjosfw6jgx7otweww7aebgt655
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785942188-17401
X-HE-Meta: U2FsdGVkX1/HD0ugVI3OvnneSnThglj6GgwdOdf0Sf1366Jal12MqY6mNBKvnCHcGix3oh9HCaUqXfQoSPNkptYlu3AP7lVhQGTtq3rxFoGmrGKv21XHX5lAFDSqD/+4eqCwJlmLJVc6UCYteB9STtW+db5t6jgGwbNh29fQZR9RpEG3+Sg1mf1IHVbZB5HZZu6YjttIsYkJ0B846GCs/0p6KjMbOS/cm7keCDyv/S0gGVgOBSOEr3TjAuZOL1BGUzaOJzZWc+JpQnQLUb/FMZShCxDUEGCPaCoehDe/fQlxK6OZjwg7hrhNIBknP/5PMiI3rE/bPn0jAVIUDOZYNkOxdgiXj52Qc7d4G7rRaUYXw052rXsrazWps0YYt3LxfiZjzAY1Wiy6MUxs+hvhvz25liS04HVrGguCNvkSvASItdMIfzjhY6CWu8ejDA3XR9G70oH45Q30wF0tsuiEBaXAy9tsKVGyyUMILduupFHDnUvv6AWaWm9odYrnJix5h2rl6TmlDg8yeoYjbCOYiIFQvvx3IkXQ/5ZbIOAb0mf+LvD8rBXHagR2qJ3yxZb9YN8zBbrG8y+9s386Nxnx9lZ+QoJrFvQ8LU4KQLlKNmtBt3GNGDk2a1gltNDxT5nyKM90Wd7+VAX3yXFp+3NGt65a36/TKEBSURH5gS2U2mkx/wuehxjoFH3qJRayw2Q2uxXkmEoNmH4QIM+kg7cAaLMhhopjMbibQfTmwnfvXbXFwqBGk9L0tD8CpiYPDQa8MeMAJdWbdMDXYHwo8H4Wz+pdF4CcaULIM05s/l0SuwD5IWvo0mm/maTBT8pr3bGrU4jwdHphombTx/63nalizK95N7YZukfCdlIEqLh0NJhqQ/eq7aQYFpDV5OfycE9LrGF3LS2KyeEJn0FH0KhcH/yXKkCWw1+l9i/TOb+InJcr33lyVEkjVA3VsSOlrOKH7LEQHe1nzPV+MV1LUwR
 ycY/vMZ8
 FWVOWT2jgtkYK2YJOzpzXxmy/MSmxjzc7fSMrFdJlMXUgDRQ/u2XTOk8gBz/YCZ636foIXgFIuiYJNWtJwEJ233VXHStuL0mkLREreSq/lBPJCg6s5JzDTxVmj83imzoYF1ettW+R2edDI5De8P71g4dSRFZ5rfRWZcQHono7szSWYXy/8p4R80w/aCyMJvk7IpYkRSK/xoEP0jrxeF/w4cNLwyvQ5E1JE/sz+iVVl6ICs477FeHyklJxxgKztKJKPwnmImB114wB0qlq1bogpYBq7wo9jTUHwMsoFnyzd4Yxfbw6CkYbSFQOa9Z5zWyj+qA09qYD1rrn35e4zyfZM5y4o8Mbsz3h2I8hDMSpKuCacUOdilzcGTMoFK5TJghxXH6eWEj1MWATD3TgjL7v7eeyEPAkA/t1lgl2e9WtLTQHkG1SWOxzZZh5RsRQrSpps5iGvdpfl1SvTM7vzbS5wCNiAyxcruEEbvH4bSYmhfsKJU1q51gc91idAKAL8rkHItfH7qP6iKZgHaeVDatKZ081wN9t57+iu+xf6IK7iu5cInF8gFneDO63rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026 at 23:04, David Hildenbrand (Arm) <david@kernel.org> wrote:
>
> Can we get that fix into 7.2?

Applied to my tree - everybody seems to agree it's obviously the correct fix.

           Linus

