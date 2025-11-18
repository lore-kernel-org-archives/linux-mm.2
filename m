Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03518CEE350
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 19:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5356B00A0; Tue, 18 Nov 2025 14:28:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BD666B00A1; Tue, 18 Nov 2025 14:28:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3E66B00A3; Tue, 18 Nov 2025 14:28:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4C46B00A0
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:28:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E80401A01C3
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:28:02 +0000 (UTC)
X-FDA: 84124713204.03.CA4B1B3
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id 04BB2140008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:28:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SCNTL63H;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763494081; a=rsa-sha256;
	cv=none;
	b=uVBNZzdOJBD4Wy3D3jZiSL6YLX1nJ8jEHfSBBYdvkczXN+ZMpGnpryLZe35UeolymxjAnV
	DdaJsWe+4/UXMNIIpwsvHe7Se5WZ4Mg9XlcIoA+dwUSsPv/4a6UruyRHltwQkbSDNeTMq/
	J3/rYsQ52h7HoeI/Se9HleCokjhTefI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SCNTL63H;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763494081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=doC9uXNUqoKejMIunGd/jGTKolDii5Qguk+TBihyyxM=;
	b=eQd9qp6SmJHiu6rHwPjUS4Lj1ZNSMFnsUmLxbJ2jjuMdEtAkFm0u5/XDqPXq71mtpBM2OE
	m7C9oa+Xzq7SabFyRMYEY3KWcXxdyibE1BHVvG0JyxrBVU76m8HE+M0h3aeXCcRv+oNSlc
	Bp6BJscCgiSnBWwjQfzGxYrZLTwP5Xc=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-343dd5aa6e7so6548521a91.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763494080; x=1764098880; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=doC9uXNUqoKejMIunGd/jGTKolDii5Qguk+TBihyyxM=;
        b=SCNTL63HZQ9z2qcZGT56Mt8USMLKh0F3g/FYXUyYBnCM4SyjZl8HDmTUnUltu2HcDb
         9S1p9OzSX9vDMSI8HvQkdllI/oFn9O90yOIBEIq0E7Vk/Q/3+zo7DmrqA+ZHY3yFVp0O
         ra9ZxtluDwcnjKF8S+0lE7OKRSYkvKCJsEAkm4nfFfd14xrW3DkjOqCNPe4eoceHVErW
         qdOkDeVXXutBHmejZFz+P/j9DsATErHx5VGFuRFvzBukZNlVEh9BvEnVOnH993AZpDUW
         ArEQ707EUUeBm3wJ0JtyUcp07pVRqZE92+JL8eY5DYcA6v9kvCOvm+oTc/KKYr3OOeCW
         EaMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763494080; x=1764098880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=doC9uXNUqoKejMIunGd/jGTKolDii5Qguk+TBihyyxM=;
        b=snQoS7++A6vVYS53Q3tsJkDt0+5IftDwp0z/P0cyftoY+0LnOqBaeRURJq0r2NW89L
         O/9i6qRW3lNiH/qtshDWTHOXdAlP8DkI8/G3gsJHzp6wwOO2IVSvj9HmI3JPfdoMX55s
         usRPHs+M+DyvQh3cgNq124eHie1bPp2kDECsJWk1ZyZ06lWxeAGdsazS3ZsbmSEZMqzC
         25sK7R0rud475puoN7ZHvCxF3IL4bdXV01j+EVGMT7UzZ0QDmbYG4HuhSxJINgJ5eVvS
         F8ih5EKmXKpcPou0L0/kJMJ97U+LgK49kIBDtZ6WFFVwhQkTJQV80OvY2S50v7Sla3d9
         aZtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcfRRXxx3zOk2HXsKYoao/X8DdbH0gpuLO1N3AGDn/RzqW7P+Zw59l27uKTt1k+fqtqe/CsBz7uA==@kvack.org
X-Gm-Message-State: AOJu0YzWw1j+DkpU3zhkQU+CqBQ7CdBZjY0cHk73b7QcZEJzTjG4Jo8R
	27mvDbx6iPOR9+W29tiPRJKD4bIUoTrOFQmCHBPmT2yGFSVLZphicDgVUPvr4jeJ1WNjfHjSoxG
	Ae15TfJjZIv0FZ1bhqh3F0n3DQIXoFYo=
X-Gm-Gg: ASbGncuYSukJMVTXE49hQdUIMRv5UY0MsUr1iF9df4AHdhEVTqSSqYSFCQ7ka2/AXaf
	LY0/aGfj502ZOyP3aeZk126DQRMaBefezIUaSAxJUxUVEhU1IHEPgQm8XdF0UxDZH5+7CfWzdsR
	mEl41TTUnfVpW31V9flh2SPDtgM1rvQK/OIM+CKSQYz6Qoc5IPrQJFbxNE3rwYiw0RIaygBaHkb
	d+sheHrsWkWPWgEVyYFiuLyFZAEwgYod1KlN7r3CZuDvg6Y9B7mWu6tXCHcV7r3+6rwPujvBOHp
	/2hwkoL+8qdldbOrGginjA==
X-Google-Smtp-Source: AGHT+IG58zG+XluUaIiZAZv9m1uRF7fwmOmXIq4KeWpc40NILlovsL0nA2fYLe6y5JHtEDDylDzt5ytVO+jnJ5EKrZo=
X-Received: by 2002:a17:90b:2788:b0:340:ad5e:cb with SMTP id
 98e67ed59e1d1-343f9eaa41dmr17041894a91.8.1763494079727; Tue, 18 Nov 2025
 11:27:59 -0800 (PST)
MIME-Version: 1.0
References: <20251114193729.251892-1-ssranevjti@gmail.com> <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org> <20251117164155.GB196362@frogsfrogsfrogs>
 <aRtjfN7sC6_Bv4bx@casper.infradead.org> <CAEf4BzZu+u-F9SjhcY5GN5vumOi6X=3AwUom+KJXeCpvC+-ppQ@mail.gmail.com>
 <aRxunCkc4VomEUdo@infradead.org> <aRySpQbNuw3Y5DN-@casper.infradead.org>
In-Reply-To: <aRySpQbNuw3Y5DN-@casper.infradead.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Tue, 18 Nov 2025 11:27:47 -0800
X-Gm-Features: AWmQ_bn356VQg7AFLndJgLd27HF_zQfgIMoqrhbk6mAt-2PXr32Xi9lJz8Nh9GM
Message-ID: <CAEf4BzY1fu+7pqotaW6DxH_vvwCY8rTuX=+0RO96-baKJDeB_Q@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in do_read_cache_folio()
To: Matthew Wilcox <willy@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, akpm@linux-foundation.org, 
	shakeel.butt@linux.dev, eddyz87@gmail.com, andrii@kernel.org, ast@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com, khalid@kernel.org, 
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com, 
	bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04BB2140008
X-Stat-Signature: u9gtt3bnowdj7extkb4zosx95u5b36j3
X-HE-Tag: 1763494080-602748
X-HE-Meta: U2FsdGVkX1/cXu8RaUJpSDzjNFMSo054Givwa3LmPf9WfjMVUxfDEIocBOSLuEMz8NHJY1DIcjW+PcmQTIrNANrfyoXXm9WFQecRprbJjjrJUJzuagqBL+qumDUki6Qdy0rNCNyGmOD+NyE+Z87A34FhfNGg/NjJqtfqOu/HrLKNbDRAOOClDQKxL41mt7da1fIfjSd+rSzKTaU/RZzfoNSNOxyr/t8xuBey4U7nUbUJ3RAI0VxM6R/BLP+vwOcPyx+GQfsf6BNas1p4inhDEDq11jGTv+42rCzVM5GUgcC0UasjakPCZv9fcqY+/7XjMTZCLceyIuMk0e459i+Cf7YvoMhtG7hTz/zAIkH7RDPyamfAvRzRJd50c4g4YbEYFwniMRzVUEahIDT5MrwmzAkCpslIHIFqMvTv0raZFcZ/TKhDTvX8+GqDu0uv9B5aWHAWRyoEX4irKsL0rx3Ie5YO56irEGk7O8oOGl6Mc3ZcNH3n51M9208pbg7GM3OZ/ZyPOGHXqgENfpcDfgWYv6wMp6+XHr1FZgBx2nait20G57fhSBFpjhxa+oMHrU6LxzkO0lSZUM0Gar82/RScYGeT62cQpl77RM1/Sckbh7/QR0XkYbIlja+OHWR00XtnOqPqM8Vub1haSCd4aWQOQNGLeTkpuERi4TDVhWQ2ehzKk1m1d6EfoxR3QCq7xN9yVhv8B0fiA1tm3Uurc2zpLiVp65kVORAw31/VZ1oOJJL32eEvNx/V6rOGVyqckxxWs9Mu2ujNawdye1xTM/794eidMrM3dTgpiey/I9Z69WEPrMD2IcmnPL5x3V4O/KlCjuIcYoo6rzgAvNqVOx4nF02oIgnIcrWaj19p63fOtX77RANnMemKhykQyAy3RWpeTuIivuc0DLfWFtb/ssNGooG5AIkFWfe1tgNoKTpHB3RRoFls7yDJd37HJeE27eg5vPP18iU3nl7Lutw78CB
 k+ZkmtRh
 cel6i5Gdr8CFNXBVG8grJGBze3g3p17eiCEzKNVFGzSYQKec82ooMLEXtMyCgfDC/LNxZKAfKox7Yb3sknQwyaCjANUfmPZxCYfJ8uJWRhm4yKGMOz8Knm6FraGWgW9KZt2qUI2+/HmqJX6PfRWFqRgwa1JG/PnbA4r/hPFB2Y9Z2uQUVj6VwEchWx3CciigkCYU+MN+cdkdHvLOHlUVmMZ/ptGegK7aFonmOMd5ZvCtG3Y1DqYIlmtU6Pyh/G+Ws+px+kt1q3AxQIitrSzON2mPu08zRkwMFNabT5ZJPdu5J1XprUT1S7vMZcSbkAJrErJOPFsSRGJLmAn4+OGHDvHUgPRBRKfZJLo18Jrouc8fVooUYg5m2vuTNx89R/vppHAOCt09CWSfwqbaJcu5biFXxczTJwBAkoDp3L43KRmElO7P0UUxk4vh5HkEER9K3Kapf3gddxGiWYWc9sne5njA8deOpTcExZMOOwWzgiwTKVaBs5TwBVaqxbskz9UnOMYQnYk+YBHOBZHHoWbTq2P3LlHyD7Pu67ZRLGIzn08tOuRHTRHQaL1ZyA5XoMVqdvrEbQNSvt02Fepg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 7:37=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Tue, Nov 18, 2025 at 05:03:24AM -0800, Christoph Hellwig wrote:
> > On Mon, Nov 17, 2025 at 10:45:31AM -0800, Andrii Nakryiko wrote:
> > > As I replied on another email, ideally we'd have some low-level file
> > > reading interface where we wouldn't have to know about secretmem, or
> > > XFS+DAX, or whatever other unusual combination of conditions where
> > > exposed internal APIs like filemap_get_folio() + read_cache_folio()
> > > can crash.
> >
> > The problem is that you did something totally insane and it kinda works
> > most of the time.
>
> ... on 64-bit systems.  The HIGHMEM handling is screwed up too.
>
> > But bpf or any other file system consumer has
> > absolutely not business poking into the page cache to start with.
>
> Agreed.

Then please help make it better, give us interfaces you think are
appropriate. People do use this functionality in production, it's
important and we are not going to drop it. In non-sleepable mode it's
best-effort, if the requested part of the file is paged in, we'll
successfully read data (such as ELF's build ID), and if not, we'll
report that to the BPF program as -EFAULT. In sleepable mode, we'll
wait for that part of the file to be paged in before proceeding.
PROCMAP_QUERY ioctl() is always in sleepable mode, so it will wait for
file data to be read.

If you don't like the implementation, please help improve it, don't
just request dropping it "because BPF folks" or anything like that.

>
> > And I'm really pissed off that you wrote and merged this code without
> > ever bothering to talk to a FS or MM person who have immediately told
> > you so.  Let's just rip out this buildid junk for now and restart
> > because the problem isn't actually that easy.
>
> Oh, they did talk to fs & mm people originally and were told NO, so they
> sneaked it in through the BPF tree.

This patch set was never landed and has *NO* relation to the
lib/buildid.c stuff we are discussing. There was no sneaking anything
in. The patch set in question that added folio-based reading logic was
developed in the open with both mm and fsdevel in CC. Matthew himself
looked at it, he NAKed page-based initial implementation but suggested
folio-based one ([0]). Shakeel did review this (the patch set went
through 10 revisions, plenty of time to object).

  [0] https://lore.kernel.org/bpf/ZrOStYOrlFr21jRc@casper.infradead.org/

>
> https://lore.kernel.org/all/20230316170149.4106586-1-jolsa@kernel.org/
>
> > > The only real limitation is that we'd like to be able to control
> > > whether we are ok sleeping or not, as this code can be called from
> > > pretty much anywhere BPF might run, which includes NMI context.
> > >
> > > Would this kiocb_read() approach work under those circumstances?
> >
> > No.  IOCB_NOWAIT is just a hint to avoid blocking function calls.
> > It is not guarantee and a guarantee is basically impossible.
>
> I'm not sure I'd go that far -- I think we're pretty good about not
> sleeping when IOCB_NOWAIT is specified and any remaining places can
> be fixed up.
>
> But I am inclined to rip out the buildid code, just because the
> authors have been so rude.

Can you please elaborate on "authors have been so rude" a bit more?
Besides that link to an absolutely unrelated patch set?..

