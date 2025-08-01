Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A500DC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 15:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48FEA8E0003; Fri,  1 Aug 2025 11:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440718E0001; Fri,  1 Aug 2025 11:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356B88E0003; Fri,  1 Aug 2025 11:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22D5F8E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:33:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7F07113BD7
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:33:38 +0000 (UTC)
X-FDA: 83728583316.07.8E9CBDD
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1BE5B1C0003
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:33:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=niSUZijf;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754062417; a=rsa-sha256;
	cv=none;
	b=I4+Y0bWVfKwB9cjvvgbYfKU79svqLwtk/jg7ksQVHSJMh2qZhQnABIzKCKXzZ1cL0tXrwJ
	KfSQCuhO8FGdPtxjz+/6N0E/PnJPOelg4G79/+O1vUUPC18SGRYXdxa3mQGCzuruRezoh9
	IQsmfL+l6fnrdoGUmvx3lt9pVgrE/Lw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=niSUZijf;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754062417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hlg5IiIUSg37cw8hEXFqC6WPT7GHYQIYrncw2fqeeFs=;
	b=UvarFTeHr2pb0Pz5m4Ot0rxdYgiptnaOtmYS5qSXVf15bzxTkTanKSF7DV3/I/ZTE2ncf1
	FERPNoIZy5/acOwNOtI8gdAlMzyuELxvYrpNHe+eRpmTKw8TADu7TaSl5o0zeA15+jGMq4
	C9CKdfh3f2ytKjspcNirNM1SINgLIt8=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso481771cf.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 08:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754062416; x=1754667216; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hlg5IiIUSg37cw8hEXFqC6WPT7GHYQIYrncw2fqeeFs=;
        b=niSUZijfYPYtR5f7G/23ZDiRngkAYg7QD2iusBIldGWtzwJOp5jQ+YbnnQZElfxsgd
         9U/wPCTroeuJM/+7BbeGKf51lphZQrUm6wnAGuA5ePAOGBgfr46p50iVuHHfiMwWemmo
         2gBQTBDR0fme5t7goxiH0/6ZCj0nXEVuPIqrtccf3+K0um01xRJWR26QbcThkbdaKqTf
         XdRxBUyD70A9uLLZ2oKczUsGGz8Dq699KmLoKPLKT/Rv+FKF55u4/MWvrTvjEE08cu0B
         0XNb2gk9QAvoIjJvW4828xRgccUxsNwRsgys5c7ttqB6DFnE03On3WOa566cgf+kczTh
         5hjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754062416; x=1754667216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hlg5IiIUSg37cw8hEXFqC6WPT7GHYQIYrncw2fqeeFs=;
        b=l6adR/xKuOSYben/AUvC2J2BvXM9jssuKV595GgvRGjL/OTSti1wH6pROFHz+rzWUb
         w4MCy4ET4SLcDjC+P0WPFhUTUE4LbG6wonl5P/C4dux0YYLTMlgA0WVZqcjEomMZDW53
         AgpXqHPx9CCfCbta1A8XSf3iK77hVnF/apta4OtWBYb1lPwx1xkojkxcfFm0HhYXOxHK
         E0EVa0sAsyrBLVy5pZDvuuNQSTZfLWU+CE6P+YUb95hLRuyxFmbC+Ws+RQ7CC4NhyWip
         RxotK5ObsvSPGduPhSlismUhzlbBzTpFJmvR99d7USU5jmd936qwgrqiRCAfrBct3nj4
         SZXw==
X-Forwarded-Encrypted: i=1; AJvYcCV3vcDRlyGKqSfFIf7qhC3Q0awH6BwhKAKuydphCXIMLL2sHPknl4gbV9h+V/ztHGZdOBsVdyTTTg==@kvack.org
X-Gm-Message-State: AOJu0Yw4W+FXXwHR7T/lgysG9RV56oz2E8k5lMSQFgW4RYCFQwN4aSMw
	S+GkltoQpDg0w9UujvHqq68n1mxS6m5NqLeC6W7ju4zNVbDjBQAk7A+bYuWHzEV5ajvfp3sav7R
	rhQMN0fFjtCi7EJcZFczQ3aptOobBHlIm41qfr9NH
X-Gm-Gg: ASbGnctvla9QkCdPQ0dbcy0QBW4jACXS/syKI6LFR9RtRiTQHptQEJz4QYlNevsiLxk
	rkImJTovObmnCFjLYk5pK27JghWOWhoVoWLqpxTX06tYVOET2LsGP6aC3Yuop36BmtITpTKZkAz
	a1iKYfdkNoeSTS9daQr63s3sgZqWf0mLFr4latKMcR+wB/9xQaOqCqPJLj9rSmFiUMjwo7Ej9I+
	LBGGA==
X-Google-Smtp-Source: AGHT+IEsz7cqbW/kEbKXp/wzbnkRSdJg8iPGlbcCDsMA3W/EALhw5TKX2XX+IJPal4VjoqUJ4+13OZd6BTyXLQ5Nvpk=
X-Received: by 2002:a05:622a:1652:b0:4ab:54d2:3666 with SMTP id
 d75a77b69052e-4af00896fccmr5243681cf.25.1754062415661; Fri, 01 Aug 2025
 08:33:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250731220024.702621-1-surenb@google.com> <20250731220024.702621-3-surenb@google.com>
 <7821b672-eae7-4730-afe4-b72b80ac6ea2@suse.cz>
In-Reply-To: <7821b672-eae7-4730-afe4-b72b80ac6ea2@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 1 Aug 2025 08:33:24 -0700
X-Gm-Features: Ac12FXwW-ZHVyxPhLTgiyxybxi8oKVAlrLZn75JD6yLNdxGMHYIyQEgr1Szxvd0
Message-ID: <CAJuCfpEhC77ZD7Zvg+9nqb=DAj2kufnLGpD72gXFbQ5Bbp-ayQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] fs/proc/task_mmu: factor out proc_maps_private fields
 used by PROCMAP_QUERY
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, david@redhat.com, peterx@redhat.com, 
	jannh@google.com, hannes@cmpxchg.org, mhocko@kernel.org, paulmck@kernel.org, 
	shuah@kernel.org, adobriyan@gmail.com, brauner@kernel.org, 
	josef@toxicpanda.com, yebin10@huawei.com, linux@weissschuh.net, 
	willy@infradead.org, osalvador@suse.de, andrii@kernel.org, 
	ryan.roberts@arm.com, christophe.leroy@csgroup.eu, tjmercier@google.com, 
	kaleshsingh@google.com, aha310510@gmail.com, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1BE5B1C0003
X-Stat-Signature: bx8eb3izbqbx44uwfiymhjrsdhd3zexx
X-HE-Tag: 1754062416-879192
X-HE-Meta: U2FsdGVkX1/jNefyBi1kP48VD3HRvz7DcrJTc1Eys7wctvvjyIeD5uK5Qykhiel4L+7NDkgQjmWiMMcUyBAaevk66JG/a5iAWIOuJ/0NwKAMnX3yUtaE9pD/GFaz3IoJ/aJIWWvxLAsUZPPnx6wKvQ+6ZC6fb9FvE2w74YZLupkWdKEuo2BXMfuYQD0amyXMroTF+n2YC6FuJamibzA7D7kRiKvEPjNMB12sXUEUC4fCN03t9N1DC01SUFVSYPMAMVgjFeFGws0r4mAPZTLidoLKUqiPnc+8rGtrOKKSWpU67a8c2GsK2ePC4t7kC1vKCOpVHWj/rCEtVtE/3ogcX2wPL6a1VrCtySCX0myUYTNNnyGQex8h2JZrKTbReh32VfJ0pdPGZTbNz/2rXXC1VpNvgA1cHH7x6xxMl++UMPfnCHochF3Azzlxi6380041Hwf8V/Ln0Y7Iu1pOtaqEvd8LiDqN232Z4l3095vCkftcSTP7fDit6tidhjLBxZzgBOFVbkMe8KTcesd6L5Wm0D6k5rdRGB8Gj2tVb6ugIDNccGftaTxTo8vbFc5OeCdwSszvsUuDIVytmn+TLZ6SeZKMKeV4FXl6Qo3I1NgfuYRjCPrcCPpeOVWkp9QEUSE+/W1axkaHHkeSf9k1lBwhAb7q4b3xHzHDcF2U1iQNiFkgq0GOXrLPieGX9q3/ZtIe3Mn1JxzyFQPSrTn460DYbf0M3+jXOw9UdhU62AZ2VcVS6Ag9wORrRmQ/Z9Zt/08wLrltHkK23/Qd/IgtbgUDAmdoIVH690AGSt70qY7rrRsUweYsNrdoSwrCzxFuMvwMJZ/hz6ZsE/fCELwPyvW+98bnelKtlB5n5OhZHLnKqXhJjXh7Fw7jelMY9abG2FFtdC234tE3WGFJ3DOB2JW8v88nhkvBFy5odJ1S2gGX7ktm/oV6g5lZN3UukSzhminaF0D4S6whKobv4p3OeH9
 WICcs3Au
 eXm+rI95yJKYRyfahhSAOQn6M23yjqkmIzBBWmWgBDspKaZZAzc1KUPlwWA0p8/tm5gu/KG52rYyiJCP6VBeknAewPV6KnewofYDzQ6lpDWoDKubM/QU3zjFpvT5SbeAp/tsub8M0plk8gqqqOQNeqPxgWXbRusaNTDqxYegA9/bkda1I47wYkVkW2tIn5kJAggq1GP7RgQEBXci1TGQ34GOJi2ydKkQ2Lcy4lKTxCWbM1Ec=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 3:55=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> On 8/1/25 00:00, Suren Baghdasaryan wrote:
> > Refactor struct proc_maps_private so that the fields used by PROCMAP_QU=
ERY
> > ioctl are moved into a separate structure. In the next patch this allow=
s
> > ioctl to reuse some of the functions used for reading /proc/pid/maps
> > without using file->private_data. This prevents concurrent modification
> > of file->private_data members by ioctl and /proc/pid/maps readers.
> >
> > The change is pure code refactoring and has no functional changes.
>
> I think you'll need to adjust task_nommu.c as well, minimally I see it al=
so
> has m_start() acceding priv->mm directly so it won't compile now?

Ugh, yes, you are right. I'll need to adjust NOMMU code as well. And
kernel test bot seems to be complaining already :)

>
> Also not sure about the naming, struct is named "proc_maps_query_data" an=
d
> priv field named "query" but the read() implementation uses it too, via
> priv->query, although it does no PROCMAP_QUERY.
>
> Seems to me it's actually something like a mm+vma locking context? Which =
can
> be either stored in proc_maps_private for read() operations, or local
> on-stack for ioctl().

Yes, I struggled with the naming of this structure. Any help with this
is highly appreciated.

