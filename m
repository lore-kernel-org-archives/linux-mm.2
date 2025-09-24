Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C05A0CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 21:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288DB8E001D; Wed, 24 Sep 2025 17:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260C18E0018; Wed, 24 Sep 2025 17:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177048E001D; Wed, 24 Sep 2025 17:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02DB48E0018
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:07:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83676118572
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:07:45 +0000 (UTC)
X-FDA: 83925380490.17.BAC1658
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9469A140009
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:07:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lbVmDC9g;
	spf=pass (imf26.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758748063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gE7xr797IjE97kDTlx6kiGCJ5AYi5oF7DWAxEs64oWE=;
	b=0Bu4j7s3yPSLTUPFUwSPDKGjqbbI9uLDKk54A0b//FviuFQJS18dqbXDbmORksknP67UKR
	p+9sB9H0IHvxxRBTV+RMLQs/Sj0zOXWMxzyc8whrx/M6VpW+ZPHlUYw9u3LnWx60KNvQA+
	dDZyNGIk3xOzF95jQs3jz75WZwzuUL4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758748063; a=rsa-sha256;
	cv=none;
	b=rb2itWyIn9gKKlsN0slot6Mbyzb0ZtiuYaLhQzopXqzzHPWyhxAbedMKwLvy7LKupGhxMa
	mDH6BCuzRXyWqSHT2ChsP8Rew6U0ymiVqynrTkVZCvZK0wzKqgC/AU7+BHlD7yMErsj9IE
	jPbJHInmnpFCVoU0ngAaKiPRWKNtXh8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lbVmDC9g;
	spf=pass (imf26.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-36c0b946cb5so2066951fa.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758748062; x=1759352862; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gE7xr797IjE97kDTlx6kiGCJ5AYi5oF7DWAxEs64oWE=;
        b=lbVmDC9g5sFLQ/Maa11Jd+EKEOhK6rKVLWH9bYeshIvxbRiPMpQ+97b2NbSSuGT3g8
         v+AZvhGPnTLWCrWBamzfeBXIQ8ZGNp+feJvU9Czx0geeUhM9IFowR4oIBjbvJfaYWSJm
         9iJvjtD2W/S6h84IJIoDW3ILlQGWTAlSSqvlXnsMtEc5fVe8bHmpE5YobHIenpYHbh8d
         HF7yiGXs1MnqwdL60p4jgO4x3hVWNcXf0WDrybNZFa//ebkW42TQF9EwAGZ2kkR1Hjnd
         fUpq5eId3O+HDLwfI++8qnHeVwxJGEweNSzqv4sgNk5Dkq7pLChWj4soakdf9fPYnGyD
         Jv4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758748062; x=1759352862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gE7xr797IjE97kDTlx6kiGCJ5AYi5oF7DWAxEs64oWE=;
        b=f8qnLEmNb0f2nX3vjZBIu7ZRgSzcErK1o35kVgljNlzlIM1uQxernDVNHrnfomJslg
         X9vQLzqlrguzxWszq/LXodiiLQ6A5wG3+XkpWPOIw7X2xIYTVz9IQTC3ax2xyGLgXO1X
         TBCCnLtDreyPW63D8RS1qs6gxEAkmH5hiZkIGY2RpToGBIcR/OSae/k5jvJINS5DbXO2
         49z43GRJda+EtG1MDZIGF+eoqor78bJQZyHImAMX6Bw8+pOW63L3u39/54dXd+2JST4m
         VYB1dDnTb2XGkE7uqJsaiTk7k/L5t1ceLLsQzGfS8zK1uh8bjRyudqqmywLu3dyC5Th3
         udJg==
X-Forwarded-Encrypted: i=1; AJvYcCVTPBcdEVrxBweNUwkDj2e4LQY7uTiBlfwTYSf/0NrwCx6g/1lJVRUz3IuMaQqFxXJ4+wdwWhJETw==@kvack.org
X-Gm-Message-State: AOJu0YzHv+kOdev2wjB9Qgu3XrGDp93B1qnX/wiAnwzfRXxYZbCLKa/o
	rSZunva5s2FWbg2qIUKcMZkGe1oiNWrucTRsuC0K5hB0fAm3Evou94c1XJvGH9MyKwnKpahVfG7
	ArqstfvVlOxTaes+39+ZYW2+lOfIrB8w=
X-Gm-Gg: ASbGnct1mEbL816IdnbrZmFq85Q2uAui8x2iZUzC93Kwt21pmmH+U8pCDhrXyX+BrLp
	fHLjpstdDqZS9plgI5vF85c009nUS3MOlO9sVycpQkyit+4nm7ExYvwp5LJi9TnOkYwsZ5rS3Cg
	4d1G62Pt5n5v98RqpuqUricws03liL/EDSzRtrvBgUtoGi9JeWG9W1aL9SLWDQnQLtLhZVvJk+c
	N0F8M8=
X-Google-Smtp-Source: AGHT+IFJPiaImNUPooT24I4Y2aFWPRjLkZZydE30bY2itAhlYNr+0vlA+AsyScyy1wD17a1jFkKVooka8O95a0ZzO/Q=
X-Received: by 2002:a2e:9a12:0:b0:333:e590:1bc9 with SMTP id
 38308e7fff4ca-36f7f2481d7mr2143301fa.24.1758748061412; Wed, 24 Sep 2025
 14:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250820053459.164825-1-bhe@redhat.com> <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
 <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv> <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
 <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com> <CA+fCnZf7jYPUyqHqonWhDKVi9eeN6aaaByMTBYCQrv2-8+hngQ@mail.gmail.com>
 <aMfWz4gwFNMx7x82@MiWiFi-R3L-srv> <CA+fCnZcWEuBerMeS4RCXQtged06MJhY=55KsYeJEOJn3K0psXQ@mail.gmail.com>
 <aNNY1AzfGua3Kk3S@MiWiFi-R3L-srv>
In-Reply-To: <aNNY1AzfGua3Kk3S@MiWiFi-R3L-srv>
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date: Thu, 25 Sep 2025 00:07:24 +0300
X-Gm-Features: AS18NWAbw-7uGsKJ0oGYd7zu1yq2_988Moths_iRDqX3j-B6KBGWgGPm02szRx4
Message-ID: <CACzwLxh10=H5LE0p86xKqfvObqq+6ZN5Cs0hJ9i1MKJHWnNx2w@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, glider@google.com, 
	dvyukov@google.com, elver@google.com, linux-mm@kvack.org, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, sj@kernel.org, lorenzo.stoakes@oracle.com, 
	christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9469A140009
X-Stat-Signature: 1f4x8tw8jh8bayosg1e4mxu4ugkz9ume
X-Rspam-User: 
X-HE-Tag: 1758748063-824371
X-HE-Meta: U2FsdGVkX19D/KTO1oGIZ0TrATLeKy1bgjH5IaC3bLUZlvjPzGm1kSq43vlu2xuzqVyl03gBO/DGHSEl1cfXFPQxERPqJDmDqq2ELzR6SJ3HSDPz7f9Q7UFDwoXBteVcW1JBsa1SxBRaRVO+7Y9IHeTwB1yanlYW8uPo0sJR4dPqQmmHnx9oO5W8KBSqYElS7BI0pO1ATnZy4XWN98ux8DTy1q4ZZVw0a8afUi2Q/nnYxWXAstsU4euLPIWTPwCAg9jvXClredcXwINBbkBjkNsAjmztfYlFEEsRAHiqGpit4yyf3AmprSVSrKQ3TYN3mgxTc6Gqz+xVNREF+GFNnIEzwaChU0pIGXGXW/B7ADKxMCbfPBBnRZwrzgHDSJxV4GkjxGLJUwWOUDK5gTk35/bQtUL2BAiFAWsigj3A0GzSNdeEnfirCnbPgAQcZ4HFtpWrV7QBQaYQIdMVa6sySnI/l6/MPTgEiqR1vCUqS9F8OpYcM0+lPF1lZ7+gqYRiQLyrtQmushnAr3RWaSQWdFCSqpbBls4RtBf6L2VrmndLbQZ6uZiQbNfmOctgHDa8oMlhutvY6AE/8MSMnxGybTFQsoH8t+HJ/GcyZdud2mCaCHIR3WNUhGc1/cIi+w/HzfNmmQZEi+Fu+V5SUHe6zWUZOPYl6Yig1g9jfg90K8vVwpXPOINDUf/ARZdtoSEqHm1+5+KfC/6p9QXoxEQmC7Y+ipAcMTTzCl0H1jAbgEV3a0n+dCprc5R5zmNNlpohpBcKAEQjUXmNFxyLRLzo7UrVIWu4MwW+KbF4J0hf9dZaEiund0MRCbvNtPPg0KkRXrF0O1D506CGmk5iH5iyOIjGbIx/14dzeZdrJ7iB+mFttEfbIb9UTekNXSy4Zl+J48F//hyatsono66lW8cOp2f+qM2Z8QXVmA6eR5bSf+QGs5GsTqNI+wkUq/zmRepF3enaWYsBvbVlarMf5wg
 tBvsdRUs
 M0cahkl28WDeqFQrdVgIY4TvvHbh/nOVxWB76/Y1N8ACCQNSHSXtIki3h5GJqKmNeXy+ANqfLz6YCocy0xW7BeJgq9D02q7qYDQziOSywHiBW6/YWs6NeiUTgQEwGXywqEze67YsSTmFfW2klPzt1niDZjy3crEDjkRlyECZDke0rhOA00cMXmk32VtCxCazb+3SWVogjr6MjZDWhp1RXeOya8MYwMIm9V4zknq5Ex5GLPO1Sxmsuz4NXyb1XTJHea9SpXqwhs2qQ0iRpqVUm3c4sPPyVsoBXQARXrbhvvWwBu4cPCHLik9y9H/i2/BKmXk/qUnitbiuF9GiYUNvZFSe4I3b6JNvsxfUlwD02ZwPLj+cEdCa5ZjZjF5mHS1Urvgm8C985pSjW4lYZbYLWc9FRk1ZIYfCkmcqZXDWs8bgZYS1LSJSFFiFJtQK9gfrpuLe/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 5:35=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> On 09/23/25 at 07:49pm, Andrey Konovalov wrote:
> > Since the Sabyrzhan's patches are already in mm-stable (and I assume
> > will be merged during the next merge window), just rebase your changes
> > on top.
>
> That's fine, I will rebase.
>
> >
> > But also note that Sabyrzhan is planning to move out the
> > kasan_enabled() checks into include/linux/kasan.h (which is a clean-up
> > I would have also asked you to do with the kasan=3Doff patches), so
> > maybe you should sync up with him wrt these changes.
>
> Hi Sabyrzhan,
>
> What's your thought? You want to do the cleanup after my rebasing on
> your merged patches or you prefer to do it ahead of time? Please let me
> know so that I can adjust my posting accordingly. Thanks.
>

Hello,

I can make all necessary changes only next week. Currently, traveling.
I will send the fix-up patch Andrey has described somewhere next week.
Please let me know if it's ok.

> Thanks
> Baoquan
>

