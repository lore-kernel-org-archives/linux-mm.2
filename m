Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CCB2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 23:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27436B00BA; Mon, 29 Jun 2026 19:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1856B00BB; Mon, 29 Jun 2026 19:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78EF6B00BC; Mon, 29 Jun 2026 19:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4E56B00BA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:16:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E16401C6757
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:16:40 +0000 (UTC)
X-FDA: 84934511760.11.3BEE46F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9866D18000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:16:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hzbYVWzU;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782774998;
	b=s8a0zEeBuqJotXBAXq6dlsvCoDND+XTnzoOSRA1GCFS36xr86KwCUE/QYnvqjPs9a8knRp
	OQvqEUTFT/LMAv+LSXO5obC8VUjXMVU/cvdSlGJsHZRvLlnEPiog23U8PvlzSPYTmxKfRo
	/kci+aNFDeZIwdzSAutIsK/Jjm0JPn0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782774998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hC0X9bJ6J8UVZ393AJBN7jBUEho3jUulgQn9n8X4TM=;
	b=zfzCyvGq9Dfa1ooJEObIuc2r1JiHZolZS07bXcw1N+XishtjTmOnQ8fjDgyjMvavRT1oWc
	C+ZNzFJ5SyV0fu29p4YnoCQgAXfBHutRlmvOHATn81blqvq6UpQ17rFw8GH33BOmvvtSlQ
	G7xREsb3vAOia71T2oKzI229daL3mG0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hzbYVWzU;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AF8843E2E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4E31F00ACF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782774997;
	bh=5hC0X9bJ6J8UVZ393AJBN7jBUEho3jUulgQn9n8X4TM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hzbYVWzUEXW/HMHT8ZKayKHOoQjeXW55WYPqAB0KYFQscyQJgLajySVSL08sYvHPv
	 APmR7RDbRK9jKGDbVQz/UM/QpnL+AhzTS7L0j2EugmHtwefvUqae0m83iSpuBAg+dP
	 HIFuQOzzRL97m85UH8HN6KDftqYxyvPYqybdzvHYHK5XQx0EjlU7XEhc+Oo/HTgTzJ
	 53DkNldx5PDtD8jiEWjFJaCUblngEVmbjtEwyoNZ2+yEzPodrhbduwS3yYlXV2043D
	 uk+EU9994XdYkhi1SVKQ2DRl0HlmiazNI2R23Yg7h7QyJ+TJ7kIkNnWoIkKw6YR2cX
	 uEH1ZRbMIzB1A==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8f0e5e36912so9667636d6.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:16:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpChlJoLP48Vzo6CV9qM4iNhulpYIcjlgVBpZtwHEEFhy/xrNxfFewmwHNYdV/cL14mv5STue4qXA==@kvack.org
X-Gm-Message-State: AOJu0Yz6psjGnzxuoKKq1Qaq2eR88tyi8TarzBiRA1hbAoCCrv4Xzwmm
	gwAa5JSLMRiZ+l+4RhTB6ofpkzx3Aod5yBe/a0/4TuSblA9Qo+ewd+aC4DoH8zfliHTb0KVQc1D
	x0ZHCySeobes63oahT6nnjuftVHeE7Jg=
X-Received: by 2002:a05:6214:f61:b0:8df:10fd:93f with SMTP id
 6a1803df08f44-8f1b96231a1mr23810586d6.12.1782774996525; Mon, 29 Jun 2026
 16:16:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260623231635.43086-1-baohua@kernel.org> <20260623231635.43086-2-baohua@kernel.org>
 <bf2bbffa-dc68-4a3e-a8e6-1ad57c10255b@kernel.org> <CAGsJ_4wJ-2JFY4+ADf-Bn2PrbpvOnWeVwZY3unKnB=TZ71-hzQ@mail.gmail.com>
 <c4718e32-2baa-4dee-873c-7ab99f21ca4e@kernel.org> <aj83c5ix_YCFMU-M@linux.dev>
 <CAGsJ_4xbYOVvonZg6d8eeuKcY9SUic3zXLbWUvxJrbf=U9sQnw@mail.gmail.com> <3903def5-e823-4fe3-9784-b6bd63470516@kernel.org>
In-Reply-To: <3903def5-e823-4fe3-9784-b6bd63470516@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 30 Jun 2026 07:16:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yRKAhRqtC=ieGV=gQ0-x2aYPDV6QW8_akkGiJsmxkbfg@mail.gmail.com>
X-Gm-Features: AVVi8Cd_505qbOkAcy1kTaKFVxeIIoncNKknSMEiUclL8Mi6Dv6K1Ix7aCzLEOo
Message-ID: <CAGsJ_4yRKAhRqtC=ieGV=gQ0-x2aYPDV6QW8_akkGiJsmxkbfg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	baoquan.he@linux.dev, chrisl@kernel.org, jp.kobryn@linux.dev, 
	kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, 
	shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9866D18000B
X-Stat-Signature: gzmfddwebnitr9m8diwifzhzj7yiqube
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782774998-810420
X-HE-Meta: U2FsdGVkX1/l+HKOEtLHiHjzcqTQAnUItnveiVCV78meP5+Sh3I/fo+v3harib0cp69STIwk4URN+bT0x94RWObLMg5QrFYHEEGg0en6Jm+EyTmVCrCLh2TuhOVEONfsiYQE45uGMtNq6JchjaMOUY+yt/JDLkymaZV/N2ImB3oCX2spB9rnXhkuq8HBeYcyeF03BQUrQtOFEGe6ZDtGKzvWngKMZQCnyhuxZb65r3ukm+P+EvWmV/xCFC4XaLqm4fzyl423LNHJcep/p2udDx3Nlsi7aS43L4Br4txHiITHH0spm4IqDTAsG/yFQZnhPeHPlMy0L8/adTzBb1euJvhQFbkizwmPQ25/9gALpMt654KzSHT88MgN/cfL6xTq8wfrPrrR+SnZXn9/dPGk/spT+/ry3HC9FgDAaICuLeCHuyjGFrR6KfnfuYsUb47IlO8Q3VCk202rcX20JWy5tgFPPo2yTjYL2Wcj79JM6QlJ/K7o5VV7KgWB7GxZt3a4IsnVdfLZ0n2Bs1FYDZgF1LaU+j+6ZnxLMVsOwuF2qp0HAr9cry1kh3/ftZnr1JN0PVKL8qKgwsRBGH76RQq9U10/N170v8NC1mrqarlqZJzPRDMSCQo1GD8w/V97SfulXLy4e5rKfS96QviBkpxInoEKpIW2yKYcunMzpzL+xeIk07gjJDbC0hAphb3KWramZ6xGw/ILekCtIoWhHNB39oE/UF1hustMkKOD2TCgm8eOTLRXrgZHz1YvA7EKg/nEh9sXaJbLvCyVExB3an81leQUqTdLEYn5qWF9teuXc19IIVxQtvzDCWgr433yV33pPut4GFtCQXZdl7MBtQZbqg9qcvKgAfUEeH7gY4ASmfh6N/X8DfISfGqn21alCvY+bDMpz9w0gZwWcXIHlUvxEjeFtVcC0uE2kIUhUfBDe8KgJyXKMMNvWd/kxiRL2Fn7vTCwu0AUTEERPK2BlTg
 poYXFizT
 OXEYrcIwaVLUfVQbH+tnnfccrVjNztCAZrkmunJ8X2EMcfhd9gdT057WYr1DSAIHQQziuEi3cxvEOppmHNihtfMQzTuxEz5timJaGUkBlbNqExnvl+Iqylug2MTdOaKVLYRNwMzVqEV4LeBibf5n+bCyaB8fbRVulI9P5wc66rnLNFoK0oFa0Iz371Z5YK6Mspr4tM7oBssTFxBrmVIYWDrEkx0kyjBN3biY8nlRfzTKVDh5wiYWYlAXNm6kNfy4B0YkoloMu7sRz1W0qCGGd/Fp7GijgsRKu0yq/wKEReCPSm99pS+2yfxT/qGxC4SB8bBOO1v3ijYstnYOBbdaRj5Syyfm+gMBdqVk2tj9kEyMuVOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 3:52=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
[...]
>
> So yeah, if Nadav's reproducer works even without the drain (which I assu=
me), we
> could indeed think about just removing this optimization here.

Yet I think the problem is resolved with the exclusive flag.
Right now, we can still have cases where "exclusive" cannot
address it, such as:

#include <sys/mman.h>

int main(int argc, char *argv[])
{
    int i;
    #define SIZE 30*1024*1024
    while(1) {
        volatile int *p =3D mmap(0, SIZE, PROT_READ | PROT_WRITE,
             MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        volatile int q;

        for (int i =3D 0; i < SIZE/sizeof(int); i++)
              p[i] =3D  i;
        madvise((void *)p, SIZE, MADV_PAGEOUT);
        if (!fork())
             _exit(0);
        for (int i =3D 0; i < SIZE/sizeof(int); i++)
              q =3D p[i];
        for (int i =3D 0; i < SIZE/sizeof(int); i++)
              p[i] =3D  i;
        munmap(p, SIZE);
    }
    return 0;
}

I assume this is less frequent and less of a concern?

Thanks
Barry

