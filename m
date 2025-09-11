Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C9DCA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 07:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDC208E0006; Thu, 11 Sep 2025 03:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB38B8E0001; Thu, 11 Sep 2025 03:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF07F8E0006; Thu, 11 Sep 2025 03:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC9948E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:17:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A10C1DE553
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:17:16 +0000 (UTC)
X-FDA: 83876113272.02.9E3B80B
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id A16C610000E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:17:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N6IpGL4M;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757575034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sYkSB5viOZ/dIcL7ssUZZBReKmqWdcvScKxD2Zeclvw=;
	b=p0cLcZiEJiEosVmzzx6IGgNesEyg2CxI3t1/VMESsZoxKfgEcOlmpxqSPgOZy2wFJQdOOF
	I8q0+PeY1uYx1iE+NABKuxErrMPZEb+4QDy/ueGumNesnpwlUo9G3RsZVxDcC0U5Tm2qSL
	ud/ddLDxURAq1MaS3/J9M93IyhSOIwM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757575034; a=rsa-sha256;
	cv=none;
	b=wqfTpv9eZkY6A0FKJ13sSzNEs+d5dgkUezh0xqTJzo2r+f81P9WoM+k0NqiEKqJ0wXNENX
	C4WSlvSoZw4kl8GG+YHE9yT7oecAAb16QztBiXoMEJWPEYhXp9+hZrN3NUlR/VOtEiTFpD
	T1NJTfmu752QmuM+bg9CN4z9IEBDbyA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N6IpGL4M;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-544a2339775so97873e0c.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 00:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757575034; x=1758179834; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sYkSB5viOZ/dIcL7ssUZZBReKmqWdcvScKxD2Zeclvw=;
        b=N6IpGL4MbdsQ9FiuhLO3opgYxT+ylr4G+/k46BcoXvgLf0U/mwFB53yee+EgzfWItZ
         gEG4Nt4jIWMzArYNgBsIr0leBMAXLisgMHnQgF+/zwMiJuFnewEeFbxepLt1IisrG3NW
         l2vKgb6Ujkm8kBkcpO2ai0wWaNu0xeuTFrlPK6o6VD4CSz+Xo8afkjYhArRLdP0b+lfs
         rYNHTybNHZz6dAb1BmxhbFfjrFcTnlHF0hDpBrR3yuNtlbW+yafWx0pRYkIwwnmoj2d4
         InLtXzUvnfsORFaJaM4oi5juiCz6slGeXIK9jA8gtGS1GEpj+xV3lHEIxP9oUSiFH8bE
         /p7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757575034; x=1758179834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sYkSB5viOZ/dIcL7ssUZZBReKmqWdcvScKxD2Zeclvw=;
        b=MOViRi0zTvw6N+kF7dx2DYjFx2TvF5FE24a4ly/C8lDxuC0Ui1FZgDyQpzG/imxgrO
         tQkC4HLbGuRa3reRyawnxaXSF3JYiGkCWxKscO4wkWsfcziqnCbTqC4I9MnKnnZy/x1l
         m7MPVHyePn6Roj5S1t2QgH+toZveBQ/2islue2OzFHgzHlnUoj9jxzt0TW+UO4ZSr0MF
         Qjwf/P/pfBwvwYUnpyhEpF4Z4YVaBEWWXSoXj6ORcxzllZI8KGsTF2zU/KNZpRxKAcH1
         Gtmpv0WI2riUc+4240Rr4w0s+viSVWRR5sf+UrHEGE7/SRJ1vT7aqrVtzuRvX19ZlbwN
         /36w==
X-Gm-Message-State: AOJu0YxxgXkfWvMbwN7qBYz744ry8gm5laxsvKxf83xdUDIZGRF3XJqE
	UwoicpF6ByKoWUUceLvS34eydtESGhf6wgkzXRX7D7FHQF0PAFhOe3vs5z/XLLWP6F7K5Vapdd2
	MC6DKclW6RMdVnk+fLONFLi6ojYIsIOM=
X-Gm-Gg: ASbGnctykAaNwXmerVs9ri2Nn91ktZBLvxnn4QBND/0ji3E0VNLlQXV7VxHsJjen+Wp
	Qdp1Ud3LLEsb80wpqCL7k+wiwMVHXN8fcM95KGTtIQ2IqzP/02tBrNllQtMJJDIrzhvo+kBCJcT
	IeiGZlRUeAxzGuGtbXP+VmclavUs8FeOSVhdQzUGag/6SHAFr44NLIFC04rLpYsL7LAa1NrjO1j
	IDaxGT5+k7f6M4VLBHygCDeTuedGPJ1a3EuQO3HcM21lhYoxA==
X-Google-Smtp-Source: AGHT+IGPZQ1irFp8jFnSLsunIq3/Z1ypSmgC9uRW7anISnxdg+jGbU/Q5Xnr0NXuB27NXdj93H94s/fmAwn2WNkQSP4=
X-Received: by 2002:a05:6122:169a:b0:545:eb6c:c6bb with SMTP id
 71dfb90a1353d-5473cda49dbmr5197429e0c.12.1757575033607; Thu, 11 Sep 2025
 00:17:13 -0700 (PDT)
MIME-Version: 1.0
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 11 Sep 2025 19:17:01 +1200
X-Gm-Features: AS18NWAwF6RJVHgNXF6pntX3uV6Sv6gmL6DmBZQhfEdvX5ZADacwdRqrQ1Szf1k
Message-ID: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
Subject: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
To: Nicolas Geoffray <ngeoffray@google.com>, Lokesh Gidra <lokeshgidra@google.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
Cc: Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>, 
	SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: m1ihh5gpxh16kjwe6x4cnhinuz7iw9ww
X-Rspam-User: 
X-Rspamd-Queue-Id: A16C610000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1757575034-760578
X-HE-Meta: U2FsdGVkX1+jboaAB1dnqebJwAL2iFRE/CWT+CH258HUze2i8Il/YjXsKVGw03+f/xKkldaZaexzsgOTC+Vh790KNMqdIY/wXmomI7IHlXP3qx+7g0gYmiIkytJ4eAs3lx1Cu3ln2hpvx/6cMF6f4w3yyK0AdYZBqTEVFs3aXbo7v9/Og3NgFOs8zulNM+EMfNSO5r7M58zGNxcKwdVgQkS2YCiJRqZr4jXXjJodVLZAE4qcBK8kuRwPZBu/RkWglYIPdBpunERL/joqx4X3qkN1I2bnpP4WpA/D0ptv2pmRf5VfoTTiEfm3pAB409C8shBoshQSzlxNqL8dqN6VcJKfsa0ltQzi1iRqjdwTahDu7l3E6RVckCDsV6rdnuieyESZz6z+D1QBRIvgtLIu2ec1niOUQwZrDy0FnPbEFaWOay5z5rAdQ8PiDWSqni1gnnr826mX/jfIY1SvxAG2f4k/CtqWXsoWVCHD8dcM02r8qxLhpOMZCcxEBX7O74I6csf2zukq01zJlesc4TRb4AkaCk1aYZbPUtQpVX4PBuZM7QHSyQvgr+ALzMoJWICeVwHiqj2ngH5xO3vdZAzShqp9S8UZ7/9m7tg4HQPdHhHTXPO2KSNe8an87rzS7/ha3BhuNg7uz/58dA0Xj2woruP27m4MjPyFE2evqmHYr/FFcFKn1BP0UdeFWnun6o8q20xkzTSsoDUWAU7p+Vfa73nMU214Mu2GFto5MucOq/58Bc7/i3S3xMawLQjSo9q6yx9tNJ+vonbYMhLswD6+oIsB57pahzxyGgde3MezRnWQPAkLRhIRefM5cQ+rqXFLKR1M3ZEo+uYiOvwm2EwSFb8b8cvuKPuGmoCPMdLyYjEwL5fYVCLP7m6ToKtvAJIu7RR48ipEOotwpl8pXu0KiHXRv9hVFRKVQt27dSQ2R38cgxb846zP5qUzeCiizVfwsb6HlRtSwn3SBKCXAGl
 ASBihl9S
 vw6NEmV1uHuWR0oK/+uf1iReqeQYgDcrC1E8uNe5hjDxTUjvi1HH7zUYSgIcdReYCeVvNJ1nyema9uLlYrhJk1Yl2BudEWyfi/tUpW9jjqXtvmNAdeQnjB8DjBVkbWlP5X/XOEnrysVuM+CtfW505zzQHshSAq5vd7sCjcfH7Gr0lfBt59KTsa3Ew1G/+0P6aKtlpnL6o9atmnigGK69XlMOrCYC0YYMi2obZBuGfYeyzwCib8bLBROZpsCk8vEKyH/YG4GSx39txrJXCqvrwGrBBegWSGQ6tx9Hf7aL5+hJuRaehwA1lErSBAk9d7xPms3ci6e0Y9eYG8+a3XPMbAi1yLDz85I5S7o5CkFU+dfm+GKc9QWRyE+SUpgsu3TojU0/edpvtbyLChRjOTJfnB2FlLu5Fj1RrZRVkm41DAzcWm0w0aakFOqojv6ohJxwDfb+142rfYP8SYuMLj+yFw6W8eF0hnqne9H1bTEE4x9C5kJk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

I=E2=80=99m aware that Lokesh started a discussion on the concurrency issue
between usefaultfd_move and memory reclamation [1]. However, my
concern is different, so I=E2=80=99m starting a separate discussion.

In the process tree, many processes may share anon_vma->root, even if
they don=E2=80=99t share the anon_vma itself. This causes serious lock cont=
ention
between memory reclamation (which calls folio_referenced and try_to_unmap)
and other processes calling fork(), exit(), mprotect(), etc.

On Android, this issue becomes more severe since many processes are
descendants of zygote.

Memory reclamation path:
  folio_lock_anon_vma_read

mprotect path:
  mprotect
    split_vma
      anon_vma_clone

fork / copy_process path:
  copy_process
    dup_mmap
      anon_vma_fork

exit path:
  exit_mmap
    free_pgtables
      unlink_anon_vmas

To be honest, memory reclamation=E2=80=94especially folio_referenced()=E2=
=80=94is a
problem. It is called very frequently and can block other important
user threads waiting for the anon_vma root lock, causing UI lag.

I have a rough idea: since the vast majority of anon folios are actually
exclusive (I observed almost 98% of Android anon folios fall into this
category), they don=E2=80=99t need to iterate the anon_vma tree. They belon=
g to
a single process, and even for rmap, it is per-process.

I propose introducing a per-anon_vma lock. For exclusive folios whose
anon_vma is not shared, we could use this per-anon_vma lock.
folio_referenced declares that it will begin reading, and Lokesh=E2=80=99s
folio_lock may also help maintain folios as exclusive, so I am
somewhat in favor of his RFC. Any thread writing to such an anon_vma
would take the per-vma write lock, and possibly also the anon_vma
root write lock. If folio_referenced fails to declare the per-vma lock,
it can fall back to the global anon_vma->root read mutex, similar to
mmap_lock.

I haven=E2=80=99t carefully considered this or written any code yet=E2=80=
=94just a
very rough idea. Sorry if it comes across as too naive.

[1] https://lore.kernel.org/linux-mm/CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4a=
Dx5jh2DvY6UHg@mail.gmail.com/

Thanks
Barry

