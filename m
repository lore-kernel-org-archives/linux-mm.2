Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DBC9C5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 03:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40C8B6B08F6; Sun, 16 Aug 2026 23:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BCBE6B08F7; Sun, 16 Aug 2026 23:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3B56B08F8; Sun, 16 Aug 2026 23:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDB306B08F6
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:57:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6007D1C1944
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:57:16 +0000 (UTC)
X-FDA: 85109401272.29.222900A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 645E3A0003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:57:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NWNOBjND;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786939034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9rFHTgmrlKHpeZuAIR9zfpEsn8vyTPZqtjpwvr8fkJU=;
	b=VjQmQ2ivA8z//ca2OREGVJU1+LQVGmZywPyikrD2IiZ6exhxDOOEQx9mqcAsEN2eTgDzxN
	zbmJj0ozKd7s4wYWekzwC6h6o6Sp4RrabURljpdUN8q5J96Dd3or66UyuPa8awOwv8vxaP
	XRlKlaf1F0FUQ/0gVJzg/T44dnt5et4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786939034;
	b=HYFm9MbXNEjCQKsR5bAPCKDg/43UEpHdQV9QzlQrxSdZMu/QEK6gwgQkV070LoA/bH+Aps
	lzXs1zNh63/tk3XZDi0dURrNqsGGhAsws9DzFxt+nNdbWaV5ac9pLzgBmHGOo4dbRrg0Vs
	NlnTVgjzMgrkYQKQv6cgxt9Unmm0R7c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NWNOBjND;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 466A943EE4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD211F00AC4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786939033;
	bh=9rFHTgmrlKHpeZuAIR9zfpEsn8vyTPZqtjpwvr8fkJU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NWNOBjNDomfZMZy4DJ2eQWa0KQlUiUC3OaKzhrIezMKARX4iUmQj1ehHtB67R4gtY
	 S31oz0D83srsSNaQAFvsQk/O/WaR25HpMjCUpFeGeTpSOrMFG/QS8gkdoNcDDz6Uux
	 xuOFBBaUQ1KEC2TipDjZFXbI1YpXhxwVfLQ/YJAuBs7bKbZ9o9Ah8lVRQpHvLEfyu5
	 L6AkFvUMV/NCPLdwsSrF3/x6eq8KW0wC3qUEYiY6AriRtCd69v31oN1zBfAbNL+Dmb
	 Anlpmm2y4goy/Cf4vpt68tmLYseOEkD1qS5jlnZmRRA5xCArlC/7IFBl8+joTRDfKW
	 axJPaWgcFJIbA==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8f186025973so27355936d6.0
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 20:57:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoL07+jmkbbeWQtdZtsU/dHl8VBMUXfuEZDy+GhN+yMfAVQ5aqtRKWzHQ56xea89J3tminL+33L/A==@kvack.org
X-Gm-Message-State: AOJu0YzoJYP1kSjzRvqkztrTaColYSaW+Cn3QV3n9wDr3JmkyjZDSEaW
	B/FzVvg09n7H2L4YUAHi0Bfx5ZgSyB6UtJsDN2sT+oeZ18/+3V5CYlg85JaG4K/o2lvyVmnjYe2
	cBprwVxnSzlWue6tf0GetAaIyEw8I7i0=
X-Received: by 2002:a05:620a:7103:b0:92e:6122:130c with SMTP id
 af79cd13be357-936d236d3admr2151237685a.34.1786939032406; Sun, 16 Aug 2026
 20:57:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260814085300.399107-1-zhanghongru@xiaomi.com>
 <20260814115100.24a6be0cd0e672cc3c051f86@linux-foundation.org> <CAF3qr_LC_UFcUtQrqnVvzD8LHD_YzCBcw4ndCxD28Wqs-F-kTA@mail.gmail.com>
In-Reply-To: <CAF3qr_LC_UFcUtQrqnVvzD8LHD_YzCBcw4ndCxD28Wqs-F-kTA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 17 Aug 2026 11:57:01 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xt+OfZP40WVnJK9wnPwOP6tFf7QEaXyB4ZozsWuWRk8Q@mail.gmail.com>
X-Gm-Features: AcwNN1XBwuRkFy3--vqQLii9jd0-9snfZ4Ce8JXy-bHSkD7zO9ilkpWQCo0jFTQ
Message-ID: <CAGsJ_4xt+OfZP40WVnJK9wnPwOP6tFf7QEaXyB4ZozsWuWRk8Q@mail.gmail.com>
Subject: Re: [RFC PATCH v5] mm: retry page faults once under the per-VMA lock
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, david@kernel.org, 
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, 
	vbabka@kernel.org, willy@infradead.org, zhanghongru@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: xwpbictdzbu9oxatdmp1mxxze7941c99
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 645E3A0003
X-HE-Tag: 1786939034-637370
X-HE-Meta: U2FsdGVkX1/nrC2IkWA8DEsjMJsEGFYu3IxIm7/Q3k3huSRSG9vVGI2dV9bt509X6z9gGypoC5vzRs1FFkc9Hd4NkYZZvgnh/DYqYoY9lWRI6SWOqGCC5/OTPiUBn1ct4ZF22mI3zmA7ZKrYQuhXnndAlUA68NdKlZHbbUDP3xp5jEy1y4nEASKVy9wcL+pIO1sUT88q9qLxAR7wlHWyWXL0P4HCIbNNhG0c3r3kbXPPFm2F4C0me+RjiMf4tSz7s9/VEMV0rYewCFHiyLtW710x5dQCYRhwpUVAwXw5ZfGEUsgE9d97Xzx2xHF0pRMFLsR3qQAf9PrHSJglxDkIlWJbwfjCW8W7/3HgGM1jwTWsC8g4n882BfoJTkkbZez3ORTfPpmHS1Ep9UZ4jS77652EPcjluijAW3tPegrQf2vMczO4HO5OLvJPxz3bdlYc0fBR+Oe2gBuKraMybU5T7mnR0UxGsCFFjdKcoiBwqBQ1SoEGIjJsqhho4qEeeYGGlsnWl58nCPXBndnjo0ZyVkd4tALEUdHFYbqKlQczDAbz7RPQM0ph/CJ+CIjDPuxGJozy7SAfVVA3s/hOZgIOs1LUmJK7z40NsXJHiXLopDbpv7ITyllgeGJxODveD0TCZiQpUw6TsFZTx2+ijXgpd7Rg2mZ05XRqB3l+WJJZ1HeHETFzXuc2XigHs3DRWFHVpPESsv3pAw5l36xdQ2SKIgFNxC7xKrSl4/IPYJkTMx8LRNwRyCFCBpMcn7Nd/xVxSVGtPkUkAhchxsn1E4vK/cVM34lUGjyOU44VyxzbD1nUbc+tZIIY08wADVSQHcBiJtQN38ec+yZ3cybCE9f1pIzL0KvjiAsDVU6H+BmSK98N5Fon3GHCmuIutupGFN1pvypsHbMNKdsPBHNO3E3CsnnUvKK5upsnRklMF5JD6oO13tfllocpfm2FSzn1fYXQd8Th4yx+8E+hpT+/pNc
 BG05finq
 SnMyeIk999XLEXlo/VNsou78v0cXzxA6ic8fbMhFewvnbdI/KPwPuhFWFlDUQ6nsBS6xb7D/2Sua+qZB7taFNHJbeDIPxHlz15F+0XQ6+MDcDeu2LHMd0yd8S7A8ERnm75Bo/Vs/SoI0/HvZnjqM22801Nn30RamjLbm//qugNzjrdmtSd2JTtZPT2KNgegM0BKjys3QniV9y/RldayPDzWorUIk25sNI1wTgJKyq0ABHjNlttgZHT+21r7hpf4go0LO9gs6FTYcoR8DQb/c8LJ7TGNpqROJhxLagfnmnTBIyDC2p2GyYOA81VNNDLx8vm7Y+BDUG5Ly8GF14HbMh6Pm1d3kuV5IlhmrN6ZUYubKz9H1XaYp78yDHkCr3RJSKjV4mDZJtS/6qw8XsB5wxeIUKE5SHVsHo6Cay
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 11:02=E2=80=AFAM Hongru Zhang <zhanghongru06@gmail.=
com> wrote:
>
> On Sat, Aug 15, 2026 at 2:51=E2=80=AFAM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Fri, 14 Aug 2026 16:53:00 +0800 Hongru Zhang <zhanghongru06@gmail.co=
m> wrote:
> >
> > > From: Hongru Zhang <zhanghongru@xiaomi.com>
> > >
> > > The per-VMA lock fault path falls back to mmap_lock on VM_FAULT_RETRY=
.
> > > When mmap_lock is write-contended, the fallback can reduce page-fault
> > > throughput.
> > >
> > > Add a single retry under the per-VMA lock in the arch fault handler
> > > instead of adding a new VM_FAULT_* flag.
> > >
> > > ...
> > >
> > > Swap Throughput (higher is better):
> > > +--------------+-------------+---------------------------+
> > > | mmap writers |   Vanilla   |          Patched          |
> > > +--------------+-------------+---------------------------+
> > > |      0       | 17303.09 /s | 17899.48 /s       (+3.4%) |
> > > +--------------+-------------+---------------------------+
> > > |      4       | 12596.23 /s | 16095.20 /s      (+27.8%) |
> > > +--------------+-------------+---------------------------+
> > > |      8       |     0.58 /s | 15420.57 /s (+2658619.0%) |
> > > +--------------+-------------+---------------------------+
> >
> > Well.
> >
> > > With increasing mmap_lock write pressure, Vanilla degrades sharply an=
d
> > > drops to near zero at eight writers. Patched kernel holds up much bet=
ter.
> >
> > Thanks for working on this.
> >
> > Are you able to help us understand how much effect this change will
> > have upon any real-world workloads?
>
> Thanks for raising this.
>
> I'll run some real-world workload tests and follow up with the results.

I guess you just mean double-checking the data with the latest code.

Note that this is a real issue observed with a real workload. In an
earlier version, we had the following data from Douyin (the Chinese
version of TikTok). Oven=E2=80=99s data from the earlier version is shown b=
elow
[1].

"The dramatically reduced mmap_lock contention leads to a
significant improvement in Douyin performance.

Douyin (the Chinese version of TikTok) warm start on a smartphone with
8GB RAM."

=3D=3D mmap_lock Acquisitions And Wait Time =3D=3D

Metric                    Before (Avg)    After (Avg)    Change
------------------------------------------------------------------------
Read Lock Count           20,010          5,719          -71.42%
Read Total Wait (us)      10,695,877     408,436        -96.18%
Read Avg Wait (us)        534.00         71.00           -86.70%
Write Lock Count          838             909            +8.47%
Write Total Wait (us)     501,293        97,633          -80.52%
Write Avg Wait (us)       598.00         107.00          -82.11%


=3D=3D Read Lock Waiting Time Distribution of mmap_lock =3D=3D

Range (us)                 Before (Avg)    After (Avg)    Change
------------------------------------------------------------------------
[0, 1)                     9,927           4,286          -56.82%
[1, 10)                    9,179           1,327          -85.54%
[10, 100)                  191             88             -53.93%
[100, 1000)                57              6              -89.47%
[1000, 10000)              328             9              -97.26%
[10000, 100000)            328             6              -98.17%
[100000, 1000000)          0               0              N/A
[1000000, +)               0               0              N/A

=3D=3D Write Lock Waiting Time Distribution of mmap_lock =3D=3D

Range (us)                 Before (Avg)    After (Avg)    Change
------------------------------------------------------------------------
[0, 1)                     250             300            +20.00%
[1, 10)                    483             556            +15.11%
[10, 100)                  52              41             -21.15%
[100, 1000)                12              5              -58.33%
[1000, 10000)              22              4              -81.82%
[10000, 100000)            16              1              -93.75%
[100000, 1000000)          0               0              N/A
[1000000, +)               0               0              N/A


You also have the Pixel 6 data showing that `mmap_lock` is a major
source of frame drops.
I guess you may just want to re-test those Android cases with the latest
code from this version.

[1] https://lore.kernel.org/all/20260430040427.4672-1-baohua@kernel.org/

Thanks
Barry

