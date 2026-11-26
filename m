Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A848606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 01:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xdD0KYnq
Received: by kanga.kvack.org (Postfix)
	id 077EB6B0B4E; Wed, 25 Nov 2026 20:58:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027536B0B4F; Wed, 25 Nov 2026 20:58:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E58CE6B0B50; Wed, 25 Nov 2026 20:58:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C1846B0B4E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 20:58:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9961AC0240
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:58:22 +0000 (UTC)
X-FDA: 85475610444.03.6E72250
Received: from mail-oi2-f11.google.com (mail-oi2-f11.google.com [74.125.231.203])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9691D140004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:58:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xdD0KYnq;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.203 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795658300;
	b=1B8SodKXXZvIaFYr+LpMNPguD86oQdyw6bAf3A4TmMvKJv05rNIRF1ZIjT9Fej5nYVf06F
	cs4xq/r339Tpfx4UvD3tQlSANrI4BvJgdQACLtESAbEPdgnfPxrnPd2yyoNWQ075XdyZY7
	ZLza4yxEWPBajJrhfYjN+Z0eE8zaI7c=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795658300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCGVdvTPZIhAz66YN5IUl8TOqz+MMSQeSPJRIWUDXgM=;
	b=Yj9qtbzf/bUBYFVQjMz0daK52BAe2jys5UbW6cf0yloiOcXmv+RoUP5HJnBs9X38C1nd2L
	Istvhv/orZcKK5iuWZtcanMEgja0VEeW8NU3IH518VlBsvpQ6BqHAL489jN0hGAwxr6J9P
	5+eDLdqD5nFbI+cVOgH9G/0+S3glzqM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xdD0KYnq;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.203 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-oi2-f11.google.com with SMTP id 5614622812f47-56820670d00so2192414b6e.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:58:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795658299; cv=none;
        d=google.com; s=arc-20260327;
        b=VrqWL7tmvGxqnv/UQVVYN4zIoFJHhOJaY/rbt/9jTwRpVUwdX0+lu0Rjs5wQ2sfcKz
         blQMvstxrISplBQW5LOzz/luFJeT6v6YtQvOYQQghlfI9214YFDZwtl8BRVhlvS3CT5H
         J4LJj5PvUT3XF4Ece128EUEJWPphSiPn9VpAE5jhuhJodQpTySZrTrEQXGAXCOQQgk2e
         9QU5IciJF/XWJRqKZ7wEQOw5L48qWuGz9I8+DQZ6ubh9tf9Q0wZG6PS+gKqfLY+bfAl/
         5yKmYxbc8o68J3Xm9c19LJe/JY3PWpePLsG8gJKjdppEzxB+No5O+b75XjU5l1qfU0G1
         K91g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:references
         :in-reply-to:from:mime-version:dkim-signature;
        bh=tCGVdvTPZIhAz66YN5IUl8TOqz+MMSQeSPJRIWUDXgM=;
        fh=0ow7ekenojhba7x23F8X+Rj93fMTazOxPc8UqotU/gU=;
        b=SixF55YRaeNIsU0WFHLfGskv6I50om93q+MYOK2og1VUXCzOQKmk5i6pGDyevEAjSq
         0EC7i0o7Im5E6zu3qcMODKFSeIhPr2BrM7tz803oWvQy2p5NhST+0jzB1VX+bNBx0u1F
         iP+Y0NiyOJTBz10jWT1aAdGeVBHMsP+V+uaWW1slxkYjYp2dLxQ2woGIFok4K0IKNIZl
         HpSWpm9EFoj3YygIu9yGkmIEwLgY4rjLDboA3KoPVBOC4nl9SbgIFnIsY/1x9A/eAFgp
         A8JyujDzTwDQ6tPWlx+ikxgKbI1jcxj4yyClbUBNe5pN1KG7RBgTtgIAS7/goHHcm6s1
         DfQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795658299; x=1796263099; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:references:in-reply-to:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tCGVdvTPZIhAz66YN5IUl8TOqz+MMSQeSPJRIWUDXgM=;
        b=xdD0KYnqkpb8/0C8CtOa/gU+UKa+HcfjZZmp9oRa1FD6rg8Jw65zWoIaChJ3XRAs1p
         vgvC9n6XL1te9u+3ylYoKEUr6wjcrTx9pV/XA26ry/HGaGfFbi1SYQhgDfNG3yO7T3OD
         VMVVyKmxuKdo1K4XlIMgZxfyXiImy/Ue4S9G5ta8aVwz4kr6RzlTWHga14tKl7gmbZMK
         k15z8yrTv5ykPinFtTlBq0aYso1fNrliH28jDDWc0s1abq5ck6WUnMTAcLuvfvyXU9sr
         oy/Pl2VyOCmL6C9joF6wVZbyJtW/Ow82WKRBFB2dBDooDITkmE8LL+ONgM9HTX5e5r4w
         Elew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795658299; x=1796263099;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:references:in-reply-to:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tCGVdvTPZIhAz66YN5IUl8TOqz+MMSQeSPJRIWUDXgM=;
        b=PD2s+Gpo8kwvx7r+g2R9sEx0g4HvdLA8qzwrY4Of+OhOJIW96lb8WheR3AhXAXHb1j
         TAvAshIiOqgQohDbH0KgT2M0gvW3Mpi0xGP6LzszamBjdrAD/vnAKfhlVfQQhUPSrwJ0
         aDSFAirqxVrxcXPyuBgBD+eCiOri2CzuYOU9ILLOYd6z43cNHR64WgzwV4bGvDSRQxi0
         KSyyjPgb7lqZVUq6vMuwo53Ts26ysRgxdU0qEiCb5yPN7FBCEUdDxzRyZhlq0UHgJW+1
         BI1DE3lO3PJNIue1EtLA1Nc43Gpm2UljBFmyWK4kTmuknqLbFpoHk4ftjX7wtwqD3hJg
         Dh7w==
X-Forwarded-Encrypted: i=1; AL+hErFBqm+F3IeS3xVJKtjZAaKSG0162slfZJtzZKuLp89E7UPNo7pkFtkChJPRRJVPGi0a3eWOEnGefg==@kvack.org
X-Gm-Message-State: APuU4Z/nFXkQf57xaGfnA3q7t1mZqudVVOq94YmpFTpi3WxhZBIzbND3
	oyNtsrtsJ8BpKqa7a3gp5KXAXAIc2AW0N+gq7whovq/7MWaR7uiECtwWX0EJ7KTX05qhVjy5Lr2
	LTIFSub2t5X4qckDwo1NRfDZivESqS7U=
X-Gm-Gg: AZFdTZeZn86aAqKrcPsuLMr2OkCAHjydJMYG1kf5TuENxZOElbILPYh/LZGWhunVfah
	s1Qso/kfInDq0mlgGceNxX4MLwaDySfjj7H4DrYF6mrCNDGwofHz1yfRYGAob7UvdgyW11Fhanm
	k5TVp/u3brjZ9y8PyuziBdjr8QNmpi0rTaILM2TdIbgPiT57CbdgS3C6WpRW+luQFimb+UTdXMB
	5txYfyrdOK2tp/6gaY6sYgFwXy+qzG2HIpDnzVUXhnOSLMzGrttFzWR3WGWN+wUDbuKKYj1t02V
	SR6K0DczPONrCzsAd7Zdvor74ojYi4nesdVVRGtP25x96oA+uW7PyU28JAl3Zc1HmGo4nDCbxoJ
	M4LqhMWCdiqv1maMd1SOd1OxZC4fh+ndZeD+FEN+1aDZzBg8HdqQNjbjl/WOXmG2pAO/1eDVTYt
	/WL7mTARTyK4ruzM9wuSTNYTc1BS8=
X-Received: by 2002:a05:6808:19a8:b0:564:36f8:ee76 with SMTP id
 5614622812f47-57a06b269d2mr20161076b6e.7.1795658299340; Wed, 25 Nov 2026
 17:58:19 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 25 Nov 2026 20:58:18 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Aveline Noir <jm5905938@gmail.com>
In-Reply-To: <be640357-419b-4c78-8d96-3c698424ecd8@redhat.com>
References: <bae41f6fc4114357a8a74c8b958f2bdc.1@linux-foundation.org>
 <awbtZjtII9h1oJ5R@raptor> <CANOyQmGPHrHAzVW70Q8T3AYtzFi3C7jCQdd-QW0rQCPEf=ycyw@mail.gmail.com>
 <awb5agUP80qz8iss@raptor> <be640357-419b-4c78-8d96-3c698424ecd8@redhat.com>
Date: Wed, 25 Nov 2026 20:58:18 -0500
X-Gm-Features: Aa3M54qAXZ6qA4q_sbAfBxVmt8Cb0Xyz8Ds0vdPPeDkPy9UkzqtNX26VGzoRiOY
Message-ID: <CANOyQmHt=Q+JjcDjdkcv2RVzTDtiWZAmiBy8rEyhROmUK-uhEQ@mail.gmail.com>
Subject: Re: [PATCH] lib/test_hmm: invalidate all mirrors on device-private migration
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Ralph Campbell <rcampbell@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j4g7zif8gzce6odba1xkcahd4os6mi9e
X-Rspamd-Queue-Id: 9691D140004
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795658300-924182
X-HE-Meta: U2FsdGVkX19PYNCXLWwiSa+8luHjaSQYC2TXC3J5MVNgrdqIR/S77TD2BAD3LKhEDd+vnvWSUyrsMEf9URVoPT7TzWg0/AOioHoaTyvlTlRfG+guHrjy02qXQoDlWaO49Utp7mbo+UWJ+MJLZDTEEMOevPC6p2dXHZAobm31+xmZPBAwYsNUNeUQ89i7eATpwY9RX+XDDB+8vJ8ims7N9HOYINALIxEvFFFY1xpeFkAwFi5X8CNaowEXYt0nPfYmEI7JJEfQMoShWIo0b6Hz5enu98DiBoL4dsqhYNk1ePezG6JyZoOA91eowCGyt4HAVxs/yRC3YVHds0xCGxs11UpyMa22gtcTuA2RL5INguWSiIYViqewqWf5ITwiG6Aa3JQJR6kPGerFDzyqN4i0v0jigrS6m0tKHns1kNxCAKTj5jEDAZcy+p6xp4ghjhqKWqGmkdwWAkmAjm0o5cgEQKHQ4VOwqzK/2FhT8BxfRQ8Wqm/YC1mrtFgxfFRWiPSr7oKhng2XiCv9/Ng4wIOQDpkZQD9MzwIVCOvg5uJVHhkVh74rYPzQLuEwz4WEZsI4ieRCZIAYIBjHSW4cRl2TL78dosQ1NFIAy79pDksesj+NC4K7Ket6zMeZUEpBEeSSSsJ3Eb0eoZPAXtf6U6fLCqixnXi81bL8t30/GL2vyeKaqo/+JXyjJ/VCQsEoRsDRUayGDLKzN2CvNRVP8r9SJFeDK+RKD9Nz+oQDVLFhFF4F/KH6fjzZipTuJ2qiuHW7bqw440H+9ToEtNWAjEjXhYcq14ozySVzX7wKKqBoNjiKseqVwsncRPi88tMp/dsQ004ffkXcWYkUxv1IHLKEGRZG5PvyrkmiQ4y0QLu0Jdq9QpNTLpCvex4rea3K78QkkEqNo+kXbOHpWMfcI1mS0RkiXNedr/8HFxaCrgP1B/slsA1RBGTkilvZmeIxOEGdSc6q/CWEp/CrM5S6Ikc
 Jymqo04g
 lX2dH2F46ViY6tR0ov+UHb0JdIsGPVtnW9V85/Ko9wfaRB4krgDaWL3IdoEMVKfD5VznBnjCI7U/FkGD/l5UTuZPLArUHiuOsBJUwTZcN5z3Whg8D2n4CTLbEhNKO+hAHfc4DIXUJoULtC9tHjFISIshpKx//2TNt7DTnuZAMvl02CdF9bvpi3q+1HW6FJsmE+RV1YjSEwSN1REdUky+hR/EUTQGJC0KDpZdUsi3Q2ecC0dOjAvsI7zZKq9fmXQWPSsEGuhfIm4NAfwbKUfgTZT9uNZ9xs2Xj8YxZPQXBOS0NeEVBaoupWVEUx5LfBTGi9H7E5y/BOrw7C0ko3kzuKyXcAYV3uXol76rF51U9Tw2MHgmLQiVSBOUKGeTtfQrBwS7ITXGqa8Fgxe9ykjGUtvnnCHKmgcKB3q+3xdYyI0+0Svjx9HJ/+6YRKBh8H4QWvs9vEiDmtgWXBhwT27fMVm7u0gNRfrqEg7UgQ2BTV+KF/xVKOlS8edyM+DNWHrxz5CC8dXfmLxaorZzdVye0oNgzSIv0mddRRzXU6DgJc7dLJdg27UXnouUiBcLAOkw09qYkcuQjUtZYzg/QUC9KAQiA8lKUno+BPRdM7AlEMy71whKW1VjavbFXyf9s1kuOAM+L58IlnHjtZssImNmlH3qw+FvYv3+67pS3QCgsLerYm7mEUrhqkdc5zs8DWSIRX3ekSX26aebQtgJ9tGkONWa9cPlhaMzz2qjPEy5Q80Zkr5f07gRjcE8mnNQv8Mf7Eq6U8aqyIYl1DS52EUelxkZreGywEr7qKQI8WAa+ZmpXzBlRtOuavlUx1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mika,

> As told I will be sending a proper fix for the two fds invalidation case
> as a follow up to my other changes to test.hmm.c

I only ran the selftest that Alexandru mentioned.

Thanks for the clarification! Looking forward to your patch. :)


On Wed, 25 Nov 2026 18:40:12 +0200, Mika Penttil=C3=A4 <mpenttil@redhat.com=
> wrote:
> Hi,
>
> On 11/25/26 17:06, Alexandru Elisei wrote:
> > Hi,
> >
> > On Thu, Nov 26, 2026 at 01:25:41AM +1100, Aveline Noir wrote:
> >> Hi Alex
> >>
> >> On Thu, Nov 26, 2026 at 1:15=E2=80=AFAM Alexandru Elisei
> >> <alexandru.elisei@arm.com> wrote:
> >>
> >>> Might be something on my side? I'll investigate further, but I'm not =
very
> >>> familiar with the code.
> >>
> >> I reproduced the same 0 versus 523264 assertion on x86-64 when the sep=
arate
> >> mm/hmm: account for subpage offsets in device-private PMDs fix was abs=
ent.
> >> With that fix, the test passed. May you check whether it is in your te=
st tree?
> >
> > Indeed, I didn't have the patch in my tree, now the test passes!
> >
> > Tested on a Radxa Orion O6 board (arm64 architecture):
> >
> > Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >
> > Thanks,
> > Alex
> >
> Did you run the full selftest?
>
> Without skipping own invalidations the normal migrate to device test fail=
s
> ( With no skip, migrate_vma_setup()'s invalidation erases the caller's ow=
n entries) :
>
> #  RUN           hmm.hmm_device_private.migrate_fault ...
> # hmm-tests.c:1023:migrate_fault:Expected ret (-2) =3D=3D 0 (0)
> # migrate_fault: Test terminated by assertion
> #          FAIL  hmm.hmm_device_private.migrate_fault
> not ok 14 hmm.hmm_device_private.migrate_fault
>
>
> As told I will be sending a proper fix for the two fds invalidaton case a=
s a follow up to my other changes to test.hmm.c
>
> --Mika

