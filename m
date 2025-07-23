Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D055C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 17:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280326B0164; Wed, 23 Jul 2025 13:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22FB16B0166; Wed, 23 Jul 2025 13:55:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11F486B0168; Wed, 23 Jul 2025 13:55:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F40A66B0164
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:55:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3877D80170
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:55:20 +0000 (UTC)
X-FDA: 83696281200.11.DC57FF3
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5AD0DC0007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:55:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XHazUu7Z;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753293318; a=rsa-sha256;
	cv=none;
	b=0a6OmBEWiEdvrgXJ9U/38kKedtLdEmJHyleOxg3dRu/mhKzqxVaAWQassY2zjRdlTeuMQE
	VR/j7eC7VpSk3Gu+3n6fnv8sT6UBjNdNMTJ4exz5Wy3Xb0tiLA178rBgidpBxGvUVkfiPz
	vE5lzGYGswiiCH5kwv1Dl9XvPRoJp+c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XHazUu7Z;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753293318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lIGGRFfecz/Eoh8rfRoSoukLF8S9VnoZ3Vch/Zqav0=;
	b=ePpEMQ6pgD22por+3Pp5MnDN8T8CS+rT88mu+mZjXb+38XCnYiNcJOsashWlDBe/gnA4Y2
	mF7Igcr78pslvocOANPykTWMYc+l3oFAWhEGu16p6gt11AuKF++g0dJbegU67ULtHSxmsk
	6GgRtsMzqOt69SOtTdkrRcJfnsDmiq0=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ab86a29c98so42871cf.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753293317; x=1753898117; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5lIGGRFfecz/Eoh8rfRoSoukLF8S9VnoZ3Vch/Zqav0=;
        b=XHazUu7ZMma2eNgL23caLOjkhI/dlhVKUXf9xgrmB4U4xDJPU7DyVvsPadWIqTqIFH
         UD4E08vp2p4C8gc/RFdPIer5e5MVzsbRlMpxSmXUV0/3pRHTYbqwxmpHCHxCHPOiehGG
         Dt3KX+JDZ3SOeEyc+9Tsx2ZWUr25ereti7v+XqcBwRIJGg5pzGGPLaI7pEQFKtAErYFn
         GZ5QOf4GvyNHE+n3GSMAzEB6TuZq3zzwllpyE0sCybSl9+ug1EJ0DeYbafZZ4dGLx2Pz
         7MWxoUOvgF4qs1rd7zByWQstjmzfh82Z80oLK67OpLLtrY8xUDNckhr2zDCeg4fzkMr5
         ouIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753293317; x=1753898117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5lIGGRFfecz/Eoh8rfRoSoukLF8S9VnoZ3Vch/Zqav0=;
        b=fXz9MusrzfQdf6U8w7EIeEXJBDJM0VdGg52brpmIfgEqnWuK/waLtmNzMIZYvJSj2o
         FhEV/YJLNfQgPx0LSd19IVeSTBhCXgNFkelVa537KnYdAE3VDCvGVwHhFiDAUhcGcqeo
         3Zob1kEb/wHMaLJqu0MZ7LpQGzYrUZ/WdQxJlKkQP9uE9WB68gsGnTQSf5mGwIl8Zyw8
         uySzi9oLY9maMA3zM9Nb3bkgIFBxWHGfuwdigaCx6WdLn9HxvknkExMVzPJ4O5D4mbpU
         dQ2v0buePZFO09DoGAwlFVfXIemLutPECDF4qyFE98+j9itwVFFs0gxijByfB2SaUWsz
         nu7g==
X-Forwarded-Encrypted: i=1; AJvYcCWn23JI/RB+Jh/p6T4rl+0clNv9XvOIBCtBS/8c6pEU4nlkUEHwgyF0Wflq3IipLVW6i95lSpCYsg==@kvack.org
X-Gm-Message-State: AOJu0Yzw/7QsNeUqXpmhxeu0bKbLDgLyK0JgRXDsavbp/7pR6IVDs/Up
	DBRhBmUV09/YA6n5cLqYH+TKT6xwYFJXndMwee7W8mKDHR9lRpkqlRa3VDeLHx5DGnk/8nOruVX
	W/BOb7xJLptgTBsLanPLIITatErZMGppqsF0cGT9f
X-Gm-Gg: ASbGncv8T9zEhkWHuyEk5hzOadDS8T1WugWNhxVbKE9JoaDNWRrW4EcJS3ruA0kes9+
	bN7F+rpg/xQdibF6ZIz9hklls8aftYdPZBZAYCp34oQxRaHf3VFmukJos1PdZOw+5Q1yYSqc4lJ
	sfqR9vzuzq/0iczRxf+s+iB4Zds0yGW7iv0n6xk76kLDHB/4t997cX1hDmsvMQgYQ5SX8rEMHGC
	lG8uBo0lqw2jyiWic1O1w+UXLIrxeOZYwCv
X-Google-Smtp-Source: AGHT+IHIKb31VYdVn/B6IVZUU3PWhb2/5MfZYxh690PVLsXGE19hQzPxB6Xh1gdfAV/1uPW5r9M8TtfzZfISYoj9Mso=
X-Received: by 2002:a05:622a:111:b0:48a:ba32:370 with SMTP id
 d75a77b69052e-4ae7ca859bcmr114781cf.10.1753293317052; Wed, 23 Jul 2025
 10:55:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz> <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
In-Reply-To: <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 23 Jul 2025 10:55:06 -0700
X-Gm-Features: Ac12FXzYuz8rR2OGf5wlGnp-T-d0ODjwT1WWx2V0IdyNNVzpMhdL1wsVFoFEQ-Y
Message-ID: <CAJuCfpG5VeW5+GdceeRCLDgX4CuFm2xQUG6UAAoLwF7oW8aU_g@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5AD0DC0007
X-Stat-Signature: zx9qxyzq1wpioc7wo7pxxqtanya1ehho
X-HE-Tag: 1753293318-789110
X-HE-Meta: U2FsdGVkX18mJX9LaDQGmSg443Yqps1QCKW7tMWS8fJH0V4Drv62Bffoi/vy1AXFDTqc6wF+Ft7VTMvkVTsfd3saWE3NbfLSmzgbmlacCn3OrgMfagnLEbOlGSJfJqXdYT+w0ulUCITLasNDLFQYJidPZvwyM6mHmrGY38IcvdK8r6hEnR21aI111gRUKvFI5tiRq2GmcbZtoX11lCoLAkfdMUtb5egqWtO3futuxfd5J6txXzOneRDFOih7R13D8kAEfUhDvOtb+Z4w4v94KJ8qMRBxMrWR2moLyeh0NgTd2/kEYRMXLEZ2IGlnkoAzzFq1ZMri8RFY3F0uJGtBIMTO8k1mLsWxV/vamMCsdEWHyeL50KAFuKHSQMjcIYq7a+SvdDvHuqceGMvVwQT+/dz9mtFKL4wtiE8zRYFu9hFQ2UkEMXsoVZLmuskH0fMQUjb01xaEy7Tzl0PtFVq/L8A3w31+9YtN9YNX3oGZKjx8rdOu38jNICncly2wRBAfK7WzXDHVXzA2VftgeaUYABB3akLqfnBzzxUsywNu/rLXJtCtClnu+FsN1Cp8x4ClTwi7eWhs7oR9R4SNF0aHNK56JoXsdat4dk/wfkc0F2IUO7sr0DzhVQ7af2cQGqav6Nm+5wnjbca4ADaNYEVWjcpIqXqWDSRkjlL28czs7w70tf0KFw29bOVurJQuLXUsGCHylvbaCsR0JTckKD5szCeQSOzZYFr5q6shrg3EMnLz9TdwWTbeFUk+S3vC31Z32zzQaBckxqeFg9ALbrK2w/eJc5+W8TXA3+lRYESFlNWcIVhcy7wMdD/HNPjbjBx9TajEX6RrCaB7EV2ebVTbifs3sv+02rcs79SBtkV871J8ZRLqHZ0fPDvf1+4zIL+ulkXFbednWWzm/qElUFPrzv2Metz7bwjyJIBzlMWw/QgQI5oowT4btcwpVCdbAYwCaCv6LlgImYrQ29UteS5
 sV8mz7P8
 m/YeB/Q4ebsjrb5Jge7aHZBgxUrmacoePkX5sYQxEMZj43JvpNOTEFbrRlKQ/yeXNRY7KtA9NQVKtIXCwhvKYt3N29+9g6xENXEDOspHwYOG0Y4k2PbuQWodu29/6I86xz3broSjRUU+cZiUvMGiq3kJ/Moy1AxsWK9qMzR5cLL2Hm+RBQ7mA1q9e57VKl3xGMxEmUDr7gCkK77ksXT6eEEiwSHvE3X3FJCuvmYD2TY7cATQkxlluoZy6mMseJub54umsHKwUvQqe29k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 10:50=E2=80=AFAM Jann Horn <jannh@google.com> wrote=
:
>
> On Wed, Jul 23, 2025 at 7:32=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> =
wrote:
> > On 7/23/25 18:26, Jann Horn wrote:
> > > There's a racy UAF in `vma_refcount_put()` when called on the
> > > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
> > > without sufficient protection against concurrent object reuse:
> >
> > Oof.

Thanks for analyzing this Jann. Yeah, I missed the fact that
vma_refcount_put() uses vma->vm_mm.

> >
> > > I'm not sure what the right fix is; I guess one approach would be to
> > > have a special version of vma_refcount_put() for cases where the VMA
> > > has been recycled by another MM that grabs an extra reference to the
> > > MM? But then dropping a reference to the MM afterwards might be a bit
> > > annoying and might require something like mmdrop_async()...
> >
> > Would we need mmdrop_async()? Isn't this the case for mmget_not_zero() =
and
> > mmput_async()?
>
> Now I'm not sure anymore if either of those approaches would work,
> because they rely on the task that's removing the VMA to wait until we
> do __refcount_dec_and_test() before deleting the MM... but I don't
> think we have any such guarantee...

This is tricky. Let me look into it some more before suggesting any fixes.

