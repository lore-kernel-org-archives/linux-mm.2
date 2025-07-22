Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE784C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 03:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496466B007B; Mon, 21 Jul 2025 23:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447006B0098; Mon, 21 Jul 2025 23:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335E26B00A3; Mon, 21 Jul 2025 23:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22BEC6B007B
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:37:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B38212F6D0
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:37:22 +0000 (UTC)
X-FDA: 83690490324.23.089C74A
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id 79CBD140004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:37:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H6nop8x1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753155440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVrKVkdiE3XI9rtU+WROK7PUvC79wNx/ZAhQmWdv0qU=;
	b=7Za3k68kaQWujx6430onXAdEt7Q0+m+jpAZ391jf/tW5xqvllvjLyuqq3IndKLXZtVtly1
	/sjQem3W2FX/mSNomaN5ody150hjuqtgLbLwlbZlq0GNb8vv+m/oT6eX2a/wNRMXUOQ+Cs
	TTxyQ+jbZrIUPAqUqUcltJ+FuhfnONo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753155440; a=rsa-sha256;
	cv=none;
	b=yzk9OBLk0elVFoFfVMKDBNzCQ/uIfIbkq9lksvQyj3ZM7usd02S4HR0J8N3ymYNmhab86i
	KsQWsKY2ASL1t9C9i1HmJ9YR8xrdaSZn1q8UZ7QgG1KrfGm+G8vzBRDx+Ct77VMsO+Awkf
	mKxDZZP2aceVBTbCUmrfDg70i2nOEYQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H6nop8x1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.53 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-87ec5e1cd4aso3075466241.0
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753155439; x=1753760239; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nVrKVkdiE3XI9rtU+WROK7PUvC79wNx/ZAhQmWdv0qU=;
        b=H6nop8x1F4ypsARbkkXDmJZrk4D0xsrfJ0mwlmdj6HF15hfeFlGGtzd5facZxIQ7ZP
         S0DAJFZPD/Ha4WR/YdXuCROI4H7o5CYeVuMqZhj8BgEXSM2BCF3ae3IMMZgD/sWM4I/2
         5C2R/OcyG/VlraBbujdy+HQfDmhcibrtR8Ke7CAofcEynhTNbIJTblzM7ixXzKYYXPVv
         cua9W4CBoQtf+lKJ0MwaUUcXZwx9GGtHEBt/r6QqjlCl8ES5ZzKSuf9DnrY/yUApqg1S
         ViBN6/GYM8B+Bkj6+5Nbkeh7ndwUtn+zfukapfiKWsOJqj4PkLi7ILDGPwhXS/x2HTE7
         Q9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753155439; x=1753760239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nVrKVkdiE3XI9rtU+WROK7PUvC79wNx/ZAhQmWdv0qU=;
        b=HasfeCam1qNz5jW3M8cpg/E/b92ltu5vvBMd3dn0SRIC3QBpVoMLRfK/ltdpev+omR
         OB+3vyrOM/uEfxW20PZxSoOWyAeeeOkbUTDEwpkFBmzfdWog502GumQ/G9DaCwto2vuR
         HfUWUd2dp/DSmFPcNA1YhBaW7a4696K3bzmAoNQhUDLAvaDYfvJ/BGtNuQwonDSD4BeW
         ULQnBc9A6yFuN3YYVb7/ysAQeZTD52KvxRUTgvEMWuy3rpi6QIx24Le3ga1Eyf9RG/qG
         6HE5lwqMMxDnHPkhALDKKD1/MllTAdNwyDAxmfPYJw/+kzuiXVmE+AAaS07QhqS3wkxj
         oZ7Q==
X-Forwarded-Encrypted: i=1; AJvYcCX9E6Fz6+mRS3rG9+BC7/Q2I7CsCawBAPGhlw7tJOJFV2HmNby+L96BAqdlmguGaPjkAHoO09rNdw==@kvack.org
X-Gm-Message-State: AOJu0YzUhj7Es3+b/g/3eelsETMJg6+3h90m+zk7szaBYa0tX8aGNRi2
	PpnNoDp8MqEuo72zvfIraRPVLFyuGOTIZ8XW/6/gdaT69wk1phKTR3tvmeQcN9txjm3MUAwjS5o
	8TNoPWAEVOpJW3T+vgh9zO1AZGjUxWd0=
X-Gm-Gg: ASbGnctGJCQMDItf7eoJ9zMLUGXzI1XkXxsLy5e0ChY3B/oI3MmuPAW4L+50pPpMB1J
	KxuUPs+0dDwbx336htOu5sG3XezTUcnlFgzyM4hLJPcIZzm09dzk8UYJjgtRnkzuf/uM8RGxV7M
	/wO/SE36g0GgnEP7+GZzqryxQt6qgATxAFIV6qpTJ+I1BQfq4RYYCuyHWNBJjdGWtltG/N50LMx
	P+ArMk=
X-Google-Smtp-Source: AGHT+IFclDmfRZMBfgkRo+vyKsonZXTN77cM0X+Su+luJY37jRTemshTbwfhPv2FeuLITlw1fo3isL2Cssdeh3MP1Bo=
X-Received: by 2002:a05:6102:3f52:b0:4e9:b0d4:1133 with SMTP id
 ada2fe7eead31-4f95f410c3cmr11992642137.20.1753155439176; Mon, 21 Jul 2025
 20:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250721155530.75944-1-lorenzo.stoakes@oracle.com>
 <35df32ae-dc95-48e1-bdb1-90f17bfd4d5c@linux.alibaba.com> <CAGsJ_4yMLi_+yxJYebTbEALujcVmeqbfHh=ArkZRxMwE+OBWgQ@mail.gmail.com>
 <a7062d0d-804f-4b9a-ba7f-62d67064c584@linux.alibaba.com>
In-Reply-To: <a7062d0d-804f-4b9a-ba7f-62d67064c584@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 22 Jul 2025 11:37:07 +0800
X-Gm-Features: Ac12FXxqTKKk2Dd1pvj17lLGUdPMo1rMsVF70mOgS6Fje2FH4DvbmpyAcqvjEpY
Message-ID: <CAGsJ_4wvWZwG6agXOzDoYBD_vnN6k4TRJjhFfR5dw5pQrk2mwQ@mail.gmail.com>
Subject: Re: [PATCH] docs: update THP documentation to clarify sysfs "never" setting
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 79CBD140004
X-Stat-Signature: mfz53wrw16bu6zhn7r6b67c7misduc5b
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753155440-583412
X-HE-Meta: U2FsdGVkX18vPb9/v6X6J97BUxT6rejFXA4WOMJLcZoeQ+EPQY3L2nBzBKyjnRmJbi1WyaGIa3DTbHu74yiRbmaXpIqSpt/fy/AJ1RzDMv9uCD4BImNxzCt5h6neTLhk64w8qKSB0xN+NYjzbWb/OSIod9vyIx7voe/J/WDYCo7vEUKahUXe7sHRKzIBxZaq7h5gq5BJhOlTYfjsPEJ+ZOwlrjkWYhUCjNxtDphsINBQQMV2Lo9Z7KzdGr7060FmLW9BwEvFpMMxz/UdjG30IrfcrBk01qXIxdyLSbOPcPTt2AgXGSEtPZNy9UQbm2Y9g+oML9kTq4b4wPt0CVblgLAGsqt6BnPymJiDfaIE6DURZg8egmTgWrSrCT2amsCDxHYkG/4taZ/K8j28JjJIkw80mzMGGsaQ3CNqbvibTpqdTLPCJYil5Shd8j5zti/xGYq2ma/H+UhdgR4VlJQTd/nMXAm0SkQhKe+5tCE9M/isV4E4BKUhjHp06EP7hJC6afM/QqPwg5p90Pb5kWiP3g9A8D5DkTwRuGCWOmW+O+0kw0Vw9lk3raOQuk7gfegDZxDAbyN21hz86vGwtIPM3anGZL6f3WmlQ9tV3J7RKP3F1G7epdcD+wo0lsXQkBSDe4oJUcQTbMbUjAM/PU303YFZCe3LdFWRLOgVVd/Ru6jtvdcgJ8mnYEHbNxmuELzcqdyAlESx4IPVpBW5Seoi0EdSzAstiBYOu2epUcNUS9MNWwBG0Bq+TEiOVzQ1WoiYiaZuIB6Oj6wx1eBE6IPOEicri8DEBRWKmWRuSyeu56rHSGXghYErtlAlXds3qF4gy1NwxojQWk3fup5TcLNYNZSr9Bmv4hSwIm9VwIqzKp5LyKS8U2niMb2lzCgUJvtZGLvpNonPe8YqOj4LklABvU5Mu8SshjGb6Mkc4iBA77xwKaEl8tuCBZgExTSsiCRTxisSSkljSm+Pukr8aLj
 oMjM0m/F
 KdGyyIYhwaOOSJd3OzLjcSDrFwjCFYHszXNmk1MC2Jv2ZLo/McbdcIy7jAhSGekDXfWWyPuvDoGax4vWG9bF4sEUAEMaIAmsfM6CUCyk2kPbeYlettSNCOBuxs+GkjBIRWW9kSk+VFgfGQMcMQ2kdS/pb2o6Q0XHox2kyBgj6Bml0pIA+qpPmfDnuc2oWoOqtQ0pzcwqm6db3EmU4HTKOFEii0mMuN1oKX2TiE3wu2moHiqPLNfgfN9o7l90uCRT6hny+m07UMV/3XgiQx7UcU+ai1cjEbzA3EiR5P5yvrsStGNHkK9yWMbN6NRhaoOj0ccBmCuxe4bp3MRYnO4fgX2uWG1WAfzTHMf7MwXruqU1fAbwe3+YTOVSnSWdw9QcRGJSZWeyh/moytK4KpWFLXEfi0RgWOE/DBSX07W32VgRWuE5U+aZQdffAG8ME+xO3txBQgvdWSK/AYUA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 10:33=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 2025/7/22 10:23, Barry Song wrote:
> > On Tue, Jul 22, 2025 at 9:30=E2=80=AFAM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> >>
> >>
> >>
> >> On 2025/7/21 23:55, Lorenzo Stoakes wrote:
> >>> Rather confusingly, setting all Transparent Huge Page sysfs settings =
to
> >>> "never" does not in fact result in THP being globally disabled.
> >>>
> >>> Rather, it results in khugepaged being disabled, but one can still ob=
tain
> >>> THP pages using madvise(..., MADV_COLLAPSE).
> >>>
> >>> This is something that has remained poorly documented for some time, =
and it
> >>> is likely the received wisdom of most users of THP that never does, i=
n
> >>> fact, mean never.
> >>>
> >>> It is therefore important to highlight, very clearly, that this is no=
t the
> >>> ase.
> >>>
> >>> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >>> ---
> >>>    Documentation/admin-guide/mm/transhuge.rst | 11 +++++++++--
> >>>    1 file changed, 9 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentati=
on/admin-guide/mm/transhuge.rst
> >>> index dff8d5985f0f..182519197ef7 100644
> >>> --- a/Documentation/admin-guide/mm/transhuge.rst
> >>> +++ b/Documentation/admin-guide/mm/transhuge.rst
> >>> @@ -107,7 +107,7 @@ sysfs
> >>>    Global THP controls
> >>>    -------------------
> >>>
> >>> -Transparent Hugepage Support for anonymous memory can be entirely di=
sabled
> >>> +Transparent Hugepage Support for anonymous memory can be disabled
> >>>    (mostly for debugging purposes) or only enabled inside MADV_HUGEPA=
GE
> >>>    regions (to avoid the risk of consuming more memory resources) or =
enabled
> >>>    system wide. This can be achieved per-supported-THP-size with one =
of::
> >>> @@ -119,6 +119,11 @@ system wide. This can be achieved per-supported-=
THP-size with one of::
> >>>    where <size> is the hugepage size being addressed, the available s=
izes
> >>>    for which vary by system.
> >>>
> >>> +.. note:: Setting "never" in all sysfs THP controls does **not** dis=
able
> >>> +          Transparent Huge Pages globally. This is because ``madvise=
(...,
> >>> +          MADV_COLLAPSE)`` ignores these settings and collapses rang=
es to
> >>> +          PMD-sized huge pages unconditionally.
> >>> +
> >>>    For example::
> >>>
> >>>        echo always >/sys/kernel/mm/transparent_hugepage/hugepages-204=
8kB/enabled
> >>> @@ -187,7 +192,9 @@ madvise
> >>>        behaviour.
> >>>
> >>>    never
> >>> -     should be self-explanatory.
> >>> +     should be self-explanatory. Note that ``madvise(...,
> >>> +     MADV_COLLAPSE)`` can still cause transparent huge pages to be
> >>> +     obtained even if this mode is specified everywhere.
> >>
> >> I hope this part of the explanation is also copy-pasted into the
> >> 'Hugepages in tmpfs/shmem' section. Otherwise look good to me. Thanks.
> >
> > Apologies if this is a silly question, but regarding this patchset:
> > https://lore.kernel.org/linux-mm/cover.1750815384.git.baolin.wang@linux=
.alibaba.com/
> >
> > It looks like the intention is to disable hugepages even for
> > `MADV_COLLAPSE` when the user has set the policy to 'never'. However,
> > based on Lorenzo's documentation update, it seems we still want to allo=
w
> > hugepages for `MADV_COLLAPSE` even if 'never' is set?
> >
> > Could you clarify what the intended behavior is? It seems we've decided
> > to keep the existing behavior unchanged=E2=80=94am I understanding that
> > correctly?
>
> Yes, Hugh has already explicitly opposed the current changes to the
> MADV_COLLAPSE logic[1], although there are still some disagreements that
> cannot be resolved.
>
> At least we reached the consensus to update the documentation to reflect
> the current sysfs THP control logic first, to avoid the misunderstanding
> that 'sysfs THP controls can disable Transparent Huge Pages globally'.

Nice, thanks! Personally, I prefer this approach as well. Updating the
man page feels a bit odd, since it's something people are already
familiar with and may have memorized.

>
> [1]
> https://lore.kernel.org/linux-mm/75c02dbf-4189-958d-515e-fa80bb2187fc@goo=
gle.com/

Best regards
Barry

