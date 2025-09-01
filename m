Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D4D2CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329528E0072; Mon,  1 Sep 2025 10:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D98F8E0071; Mon,  1 Sep 2025 10:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C92F8E0072; Mon,  1 Sep 2025 10:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1AAB8E0071
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:51:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFBAE11A436
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:51:07 +0000 (UTC)
X-FDA: 83840968974.23.C625DF8
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6D6C920004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:51:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=b9eL4nq3;
	spf=pass (imf03.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756738265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ou2wtlN8PDWTGj+LZ1aCRhABiZ7uTVFHZhzB51NR+RA=;
	b=7Q/P4VSUMC3XKXhGTS+bH0IqrSgjo06o7ejpnoY823chmlGHLsu6dJQgVFaLTbGfULHoMV
	fZ0rGCBQ0jYMtDKkr/ISVZzqcarzqMPAmnF98MdmAzfrjb3UQU2LSvGJjiZI35y6XNZaLF
	jJyc3h32YRdoS6yYAkf2jJyhnqVGvT8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=b9eL4nq3;
	spf=pass (imf03.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756738265; a=rsa-sha256;
	cv=none;
	b=df8ZxsFtI+1KjbYh5FF0OAmjz7OuFxCM5fhhV6W45fdRspuPoXP6r2frUmHEU04Cj1B1bX
	KkCtR4IOudHAe14FQESAE04KnVWCAHZeZ6uK7OGcjZ0QFCCZ6ydDQGnr6keZc32DfRNViw
	SoeVc/i1LwWpoRRyXx1jtghCWALh35M=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-afedbb49c26so678387566b.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 07:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756738263; x=1757343063; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ou2wtlN8PDWTGj+LZ1aCRhABiZ7uTVFHZhzB51NR+RA=;
        b=b9eL4nq3bq2LFHqMNVpeSFX+hiiuKK4N/bN81Yci0jfXiurWRoMHH0L3PSnEltXteT
         eohTuktNChnP1GH7TwczSnhq0qw5TG1CDdSyVOwC3bOeA2oeQlo+VsVcY0zYGWDHhv7V
         fhMQwYFgmCzBz/oPWwCmQdoi9t/ive86o0jyCFJgWkMS/gwziqFKXXzfMMgzeTjm+cq+
         7wg9pgHRXZGJ67nM8x6OHds4KLTcrBGOWffGMJXDVs3stFRF9l3XLp6iM/T9bJ1sUYia
         stULxAVp3DyUmzk5zXaMUHHK8bX/6Iuq3VYGfuGbBSA1vh3B6+dax/6qQfBJbpOo+l/G
         TEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756738263; x=1757343063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ou2wtlN8PDWTGj+LZ1aCRhABiZ7uTVFHZhzB51NR+RA=;
        b=wuZgqmmC+CfAmHLsxarjt/M6CEePxcrqKAT8TdDkxsGFHOXUFkfsMvtkc83dt3XK7E
         rEg7PwB1ot4n1ud2c8t+wSNfKOQWK92Yj1gEm3AJC4GkAL674201lzB1Po2zkLyQOr39
         voE6K8h1cZJmCJN2tFgKyRaM8NpPvvlPLd/gaRyAZikwaamII4CCNlw/olqfU6Xud1gc
         mZwMuOcDh1M+qn5XBRSUGXBzHptCAcuWUNBJ8TX83RMONqD5ZaU+j9VyqjbxsUkSjzGM
         zjMVDLy1kGljEL/Uhf/1kT8bWYAm3JkvLnn34kXdmtgE2iClKZmFbqaY3znCezvLpN6e
         BSGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVTBASogvKJyowIp0DF4ietF/AII9CzwmI71ZcNgC+alIgmQiTVICseILMos1Rh/1LLiFmukGUjA==@kvack.org
X-Gm-Message-State: AOJu0YykX3O4kwoatjNg64qQuCus8O3iXvOypUfNMt0Np9WhqANcedlQ
	U4tdiQdLh03puNirm/yRYHeVsquFilk83A4NKiZvqCRGVwgkY/URS9M6FjUHBQi08Y1/RrivVZR
	uhCkfwbJntuAsy48wSyRSlCsKiL5gUEQETNWOWP+30w==
X-Gm-Gg: ASbGnctIAhtv3cumClIjZJ/hbICorw+Uy3nmj9h+PBWluJn3StagakqT7ko+fYZfWPF
	o6VMbxs7R/LvzpP6pvIPrZr/8+YCSS9m3WW10GBUY+d0oaMCIrNnBeKIawkdUQhtX1uATFaTiVh
	+wbBI7h5w0zaEi/Lpe9UPHJVtbVfK0f1SVNO4GfR7IVvbj/P/RJmdP9TjD+k5bkaYMfe52o+1IL
	lYOw/iOhqn5Sse9kI1YivWk38ntsCTTEXs+Wb15h2jPBw==
X-Google-Smtp-Source: AGHT+IFqo0rWyO2Tzcdh9OXq9LZuz+iBrgY4hQc2106202QGZ76zZ9E9VZRcm0Gdr2Fju1hLpDpwI4qcelZS2+NEezM=
X-Received: by 2002:a17:907:60d3:b0:afe:8d25:770f with SMTP id
 a640c23a62f3a-b01d8a26de5mr847287566b.3.1756738262736; Mon, 01 Sep 2025
 07:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-3-max.kellermann@ionos.com> <26cb47bb-df98-4bda-a101-3c27298e4452@lucifer.local>
In-Reply-To: <26cb47bb-df98-4bda-a101-3c27298e4452@lucifer.local>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 16:50:50 +0200
X-Gm-Features: Ac12FXzHZvMcadklQ3Hi-QaCR2-dPItzNryZ7uqKCm4rMw8McLpdl959UlJ37Wg
Message-ID: <CAKPOu+_aj3wA14VaZo8_k+ukw0OafsSz_Bxa120SQbYi4SqR7g@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] mm: constify pagemap related test functions for
 improved const-correctness
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com, 
	linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, deller@gmx.de, 
	agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, 
	davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com, 
	luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net, 
	jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	weixugc@google.com, baolin.wang@linux.alibaba.com, rientjes@google.com, 
	shakeel.butt@linux.dev, thuth@redhat.com, broonie@kernel.org, 
	osalvador@suse.de, jfalempe@redhat.com, mpe@ellerman.id.au, 
	nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D6C920004
X-Stat-Signature: 8hgdmbhmq39bijs6x6tmqyy9qttusdfu
X-Rspam-User: 
X-HE-Tag: 1756738264-375301
X-HE-Meta: U2FsdGVkX19YWIXYqe/raOD1v5IglKRU72lRlwU53xnvvcC6K4My4DaQCI4kH38HLLp2TXcTYQq6btToEEhhR6herTiIiTZkXLa481C5Df8CoBN7YmnCERKlyW6TblXcD3TL9g97qZlwfcTFiPulsRq0dveS1+trFr6U+sfN5+Zcb/RfO4eMh7kqPYpbPf91IMMbgxl5483U/UJGPi/961UEIIM0tCYOfKDuKdGh9yTt4LjadL1jpNihRSWVLITfKGPQH8nbuKV0nJYon9uWzTbk9Qb9+uasgFc+ryA5AyZhXinOX5gFW3vH1Jp5lIkAUL6g9S3Lzzro5OougtuFagQ9y5EILyv0r+NWFhw8G8M6vG+MAWgrKdrRhMp9KR1r3PIOEPJnbS8sAz3wSOTtkg9n4Ocb7nQUw8mBC4lzLdCkuB24dtNTz6bRqrZxobqi948D0zV5Lsbs6Ut/WY37Rkq22H2yKnPLAIKoKt+QNLTc7djaz99hIXkGPZHDC1i6Sqn7K6FKSGgn5qv028ZCjfDGaqOphv4mq8rdz7NYMNIIHbwFnngEBhD+rQr7Q2sm1fUoECmPW7n1Gp666j3aL/tT1RCM3W3y6tIK9OceqfteU37icrhZep5HUsE0sKU6XKYZH5HqTie3WZiWOY0KBLlvzaceMB2wxGDYo1LQRvtPljIJ8dmDJAPJg6IHsmNeMy0hinu1BWtbGnvvmUNzfzn875kXoqpCvCMwX/XnHtYnx7NlvOpQcy6I49JGssT/sqI859+ExfLcG7pr7qYlLO6lDbzg4Y9KsEHMydSk3MXJVyOoT7/zpB5VRen4Dmv9APOn0Jgrc78i2HpPFGalpI35kzvADXe2K41gFtByBMRy5adZTXewl2EA6CeTouATiB2p/S4y4i1EOJ2UeFMcu8Y33C+XbZd1Cr+2THbGihWF09rUFc/bRxucXCAu8N7eWzZTvc5btULmDpJsegD
 rYaiKoQJ
 Ah8hjn//b3s2gF13nqCjYFte+/LOxi1mTKCbyIaK/9Zo+pL7MF7veyKdHrW7Oy3/PGoiNBYq1TR5ySNCX/NAol/tBH2lwnoBxhqbe+wMwnDxgo5K8lt2cswj8UQBWHnpciA6qKTaUUFrBSIRjpM4XXD+OWjw/XNKgFOaNTJ7f6M4DvtnKtA82gVXzTc38OpH+Ia+DhO9OZqUKgzGs1EvNvmy0ABuXpVYUfsrOtSO9+9tMOrboy/t4ur58Dfqq8rpqz4HIQtQ/RLXCNm3w9gfCnP+AMaavD88D4uEE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 4:25=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> 1. (most useful) Const pointer (const <type> *<param>) means that the der=
effed
>    value is const, so *<param> =3D <val> or <param>-><field> =3D <val> ar=
e prohibited.

Only this was what my initial patch was about.

> 2. (less useful) We can't modify the actual pointer value either, so
>    e.g. <param> =3D <new param> is prohibited.

This wasn't my idea, it was Andrew Morton's idea, supported by Yuanchu Xie:
 https://lore.kernel.org/lkml/CAJj2-QHVC0QW_4X95LLAnM=3D1g6apH=3D=3D-OXZu65=
SVeBj0tSUcBg@mail.gmail.com/
You know that because you participated in the discussion. In that
thread, nobody objected, so I took the time and adjusted all of my
patches.
There is some value, but of course it's very small.

Note that I added the value-level "const" only to the implementation,
never to prototypes, because it would have no effect there.

