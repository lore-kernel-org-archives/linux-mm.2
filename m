Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B019BC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 18:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BEF36B017B; Wed, 23 Jul 2025 14:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396AD6B017C; Wed, 23 Jul 2025 14:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AC696B017D; Wed, 23 Jul 2025 14:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD2F6B017B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:19:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A353C0168
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:19:50 +0000 (UTC)
X-FDA: 83696342940.04.B153027
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9514540007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:19:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=g3cMLpvU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753294788; a=rsa-sha256;
	cv=none;
	b=cO/SapwgWrTCP8v1Ot7eQvK5BXTt4FUvlAfE/egdHbUQKd4BmNen9XxnIJduHtgAIaExuW
	0PZfg/rbiyo9WN//tDHunxTXXO8oxmz+usqh+KOhAhh6Qc1Nt4x/Mcu/t+orPh+0CVTYlD
	teS7i2pxdVQ2+OYtsQMnmtVcjG1MYSk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=g3cMLpvU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753294788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpAEpgDWHeGIH7ss8Nvzd4+y/2+jfURtt3DlfE0yh8U=;
	b=EHxSIbRu02317iDsqFwPYdsxmBee3MbVirfpj0je35JCUVkRx6zZotD8N6JapfrSbcPhuC
	pn/kq6MPMCCG2pTBFb1/9KU91ajF1AjhV9YUb2DJdQoB/QNIXt6dHCF5SmkQqECUlocezO
	tCFA3i2L3OxGt09JVdOL9HwqNrIY6aU=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-611d32903d5so1392a12.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753294787; x=1753899587; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KpAEpgDWHeGIH7ss8Nvzd4+y/2+jfURtt3DlfE0yh8U=;
        b=g3cMLpvU0V9/5EEHwfcaHKZZSJq88JHDuwrcA6abwC6+Uy3qfTc6/y72ZJMUpZIXGX
         1++gDA0LGtn76Bw+A1VUzSc7jc3Zec1BfA+nE6jTnEQuzjPoYoS5hyHs+Yw+gxESoosq
         E+eB+n0c2hZSrDc3R12+kOSBBRRgIt2xNtLpsdDFf8LLabUsLcyPcwQrisfl6gt8EWQH
         KHeW2n8Xmgws/F7XRS+4c+F7CJwd4dwlqiaCAb8rR+DbLmbOUDCcHIRWYf8t6zg4Wd1o
         Ic/yxhw0GMFZNva2iVarsVvXTWvvpqIpHwG4hh1ZVWQOm/H/deWA6g1F98B6WYGQEumZ
         Tq3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753294787; x=1753899587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KpAEpgDWHeGIH7ss8Nvzd4+y/2+jfURtt3DlfE0yh8U=;
        b=PUuG0YexaqNgd5kizdyTwkiaMiSnHThKf1dS7u+a8q5S9wJpwotIJedZ94JRNdYwQb
         WLQ8xrZBQUMLJX5ViURyUCHo3Q1j8qqZUjXP/WgmogcoaOxKPbZbSfYtNx61R+zRulea
         +QyQePGgxth5T3ZWf7/zHMCk0hstAjquixWL3midupWDTb6NVgU4Utb/jtaiNREDiDw2
         IKSP9UZ/6BYB/AOobT/JubJFSd6dn2q5kAbe/HiBIDnwIwfB8aUNDW0Lv6gwv/idhuqk
         vMFonu2JskXNvOC/PE7YE5rQbdT2k5YllDQmTowVP2FqUwh0oSvL4u3wX5MetKLhwgzj
         4CSA==
X-Forwarded-Encrypted: i=1; AJvYcCUaQmRXwuo5xOM3NJ09o8u4Ewm4UWMLXZ5ct2W7acdiHgwmvvDfbLo+M+s4C/AX1vY+mHpTExFtwg==@kvack.org
X-Gm-Message-State: AOJu0YwgHtFQUUnZcKLCOG08Y9QK0+hyy4XHS9jhfIAJGHePmGiEyWe8
	9S8CmtbGVPBdzWPod5KKhaFPKNZnidaiLRRwlJrgQODICQXKSO9eaubxg75rMwvCMCKM/eoAXWp
	DW6WraKLDF1J2dLgBbEC011J1b2FRE/ymE59BuWEE
X-Gm-Gg: ASbGnctzcrMaj3yPpWHT1RCKUOT5Z5B0sg7SO0kJldoDnV88FMqMJ9TFo9wW8oSFQX8
	/haVuC1d6G9Vq8ZRkCOQPvQoE24OKQQVYs37tIUU9yJc8TosUQ2yHPU+gtweTXmNWWgr5sbWKtY
	lo9xslWyMgA6o/bn71AjZ0c+DQ/SS313l+pq5yZxZZSxR3sG0KbfQT6Szv39kiW1wZGRqRxXkxU
	UolVPZNNOPJBzARioJP/31QwBuhva+Bhbg=
X-Google-Smtp-Source: AGHT+IHwTkwUxwmYJznW+JoSJ51XwKQLHjaGqTtI67K+dfaGKw+YkDZZvw+WbR1Q0In1LKGZVLGLErdnUgjne9ZVvMs=
X-Received: by 2002:a05:6402:3135:b0:612:ce4f:3c5 with SMTP id
 4fb4d7f45d1cf-614c4521044mr8154a12.0.1753294786700; Wed, 23 Jul 2025 11:19:46
 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz> <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz>
In-Reply-To: <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz>
From: Jann Horn <jannh@google.com>
Date: Wed, 23 Jul 2025 20:19:09 +0200
X-Gm-Features: Ac12FXz9_i6SxLpXiajqVAiG94JEsCjfzLCX1gvk2m4O6lVv_x28mnHa_UAhCLM
Message-ID: <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bht9omkgcq1q95qdzqdfx7naxsjg5f5x
X-Rspam-User: 
X-Rspamd-Queue-Id: 9514540007
X-Rspamd-Server: rspam02
X-HE-Tag: 1753294788-113058
X-HE-Meta: U2FsdGVkX1/MVMhMGiYBP4IJpx767clUHFvOe+9vuNmb1k437HSCiQg8YEfH88kkvnlz4nNdZyFM74b8oQY1tSwZmMGebexfRoiSxGUuEYf7gEfSI6jda99R+BUXPQufb9Y2CFcHPQ/LXuAetXvoGcEIhBYD1G1e3QI/VoKB43FNCK2CXwddBTFgi8/i3aiARaI5YEYvC9PP4ZsMFgQ5VYHBpZm3bDfftoY+8GMbrJ+mIe6te6OUma1h7s3cLhTC4FA5zWPD34ZSaU+cS4Ad2Wu3ZjnkvXI3vv0x5v/rt15a/y1NKJYu+pCe5o8XaJHNoCkw981JqabDJvZr+RQX3awOG6bZ0e909KdaT+7ZaGh9SYZgARzpe7gsDDbsDqOcjCOuYXXsRx8v8LKZH8dMCymnwzEim6DRhuL0qnQrtwglBunuHbW4uAu1zZtRk73cLVLXciDW1sVJRy4Kd7in8sVXR7dGws8uZiuvh7p0LWQtKqaSVGd4N0XQ2ngA05ZlimUYAZUdqIA8yx24arquB3lEilvFVrUIFRttio48s2fv85ioIbROtK2HFMoz/px6WYz4OhbOTRwvRdV4Us2WYNemU5sG0oVKk/uO4xCjE9J63EF7Svnv6/dMcQEaZSp7fVFH1lI163kbqZZA+mCG/HHjotM7FITyq+kYp0sSh7kKhye8jzGO257sjizIk16RkGMJYJ6rXTAx3+p7+iTPZF0erVuLDZP1w3K8TfDCetTfIroJ69M1WmWsi0kOvE+gkinIEY16RMIubw7OFi53ncdwvH+ngBgtdN/YFz+Rs1oYONhZA6pyAIYsMsblnkVvE6MI9qxsT0AUu3jgaYUap4ng7Obeui2HAIWz3f5uuzicpb0qD2CFg96uBd4wKmipbATez3ufEF/1nLyBFs4iwzWrUwITf9uYomAT1yjB6W58EuW/paqx0FE2dFidhTqFH/H7axwniKYkEpj/Kfw
 6JFH5LEf
 9kA0hLYwfIqxhGxro66huw1YQiazeQwRoc7QLJ76UfT4ireWsPlRCDsj8q00rhgD+5JdTlzWwrkzS7Sg6vU9yz1p8EdlNOLYdA817p8cP7eJmpYUPIgmiBoXR1N8ne5/95H6msnDIxWIPzkeTghbLDyf6pFnKfixOPHyfW9vq+ZLj4wiygGXCj8brjpXHy/ro2cMvrsdHIHv7glY3hwnBVdfZj5r3eMtmR4Zcmb5Wasfj9Ux9I+PhW25kH3DrrzR06I5cD46WvCQyPLtchORnGpAxhDimwcSrJbxDLdrja5Dy4iMbFthj66Uh6jFmqqYy3sobHD6ZnJ7/VHrb9a/4kz+Kz7+9JIR12KY6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 8:10=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
> On 7/23/25 19:49, Jann Horn wrote:
> > On Wed, Jul 23, 2025 at 7:32=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> >> On 7/23/25 18:26, Jann Horn wrote:
> >> > There's a racy UAF in `vma_refcount_put()` when called on the
> >> > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
> >> > without sufficient protection against concurrent object reuse:
> >>
> >> Oof.
> >>
> >> > I'm not sure what the right fix is; I guess one approach would be to
> >> > have a special version of vma_refcount_put() for cases where the VMA
> >> > has been recycled by another MM that grabs an extra reference to the
> >> > MM? But then dropping a reference to the MM afterwards might be a bi=
t
> >> > annoying and might require something like mmdrop_async()...
> >>
> >> Would we need mmdrop_async()? Isn't this the case for mmget_not_zero()=
 and
> >> mmput_async()?
> >
> > Now I'm not sure anymore if either of those approaches would work,
> > because they rely on the task that's removing the VMA to wait until we
> > do __refcount_dec_and_test() before deleting the MM... but I don't
> > think we have any such guarantee...
>
> I think it would be waiting in exit_mmap->vma_mark_detached(), but then
> AFAIU you're right and we'd really need to work with mmgrab/mmdrop becaus=
e
> at that point the  mmget_not_zero() would already be failing...

Ah, I see! vma_mark_detached() drops its reference, then does
__vma_enter_locked() to bump the refcount by VMA_LOCK_OFFSET again
(after which the reader path can't acquire it anymore), then waits
until the refcount drops to VMA_LOCK_OFFSET, and then decrements it
down to 0 from there. Makes sense.

