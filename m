Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B0FCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 10:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05438E0006; Wed, 22 Oct 2025 06:22:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8E518E0002; Wed, 22 Oct 2025 06:22:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955EC8E0006; Wed, 22 Oct 2025 06:22:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA1D8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:22:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BBF248B66
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:22:17 +0000 (UTC)
X-FDA: 84025360314.27.6233C0D
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7751640003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:22:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="kYhjlJ/w";
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761128535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tg5CSyFuy1gjgzwuVzeNqzr1hqLjP8/oZVMupaN2ME4=;
	b=Vp2+dKhrF2yr/0o0tnpTv7WgNK4UkScjdUEHupMDTPTud82bRuw+TQmBqMs1XQKge/9dD3
	zXo5gxD8keA4Kv8FE1lb4htqSxh2hua5/60r2AaM22UtIbXN5BuK7MqH2f8JDrDxQMVOqf
	Fv38tw0AYllsEeQLvunQ1klQMV4tRns=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="kYhjlJ/w";
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761128535; a=rsa-sha256;
	cv=none;
	b=CT0dV0O4mpvMZ3zmiUvYPcrMPtu86rCaGCl4MAl4biHpvd73QkqDkpo33XVy1bpPEiCujd
	eA7tTHJY/hjcoCF122NDDUhmyuNH3Fr4BAkcYS6SxMHPq/TvRYwbylil3rF5DD3zW3PiFx
	SQ63dkukoDFwXg2dnEjI8HEJUOLzHCA=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-88f239686f2so847047785a.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761128534; x=1761733334; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tg5CSyFuy1gjgzwuVzeNqzr1hqLjP8/oZVMupaN2ME4=;
        b=kYhjlJ/wwiBw/XYGx/BgFEusrlgoX4Jc2C6Uk2fyrK4KsAXSQVBsIj9z6mCX9QO43i
         EfVwS86Q8qzYPQPnIhN6W9RemgtX8TkZHi0pYIk2/CnVM7CsvhrL/hfmN6OuOPpPmWv9
         Z7gph+weFuw76KBzA1kqokuOOHgtsvpzcxhiGq8b+aggs3pu5mlIPg2MJf2hvYZ/orvA
         F/J+q41m/L2B5OYlndGPAVtBsSr4Sc/MHw/kJ4BUlwFB5snUId37vb5gSUdio1oBSkHp
         GXRFcn4HY0gKovVO4/Y9qhWAg/VBPF7w75H5JRD8eXsq+lYIpaAVxmIe9tSktIPjNDSQ
         Uu7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761128534; x=1761733334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tg5CSyFuy1gjgzwuVzeNqzr1hqLjP8/oZVMupaN2ME4=;
        b=Q21zCBA2SYt5Gu72fI5t60tOsPb5lxJOc6XN6TJ0j4gu09milr8Qp1sG5wKw8Qh/xP
         VeHD8MSKvwatE3JuQxCEmBPsT7u4FLfIs6oE3hTwqEhSg5WU/chKFIarOdmzLt8BiQtI
         B6BLggqJgmYix0j+ECYC228Nd/HM+qGNgYhTepfoBMisH07wCpITld2vfwtACAfvnBYR
         OXfBqbrFmzUa/DNnaL2p5e/wBWcukb3XT/9EPlTrGxOPYBvluSem+qrrtAM0+/NOJYvO
         hsytU3Upi1xNeIDalOFk8fMxvhJuzJHYSwEXW5EvswOktfYRiTaRrO0aSjKXNmqS4Ke3
         k50Q==
X-Forwarded-Encrypted: i=1; AJvYcCUyFU/z7RrasMGux86TdkItbwOfyIdcbZXKFbYAPM0Ok9nsGmii9ttGdz5auGo+XuvZcObHzUC/XA==@kvack.org
X-Gm-Message-State: AOJu0Yz8zZrlBNDXtNI2aHMP9jky4zRTaRRdtKiH7EtQy7qeQFvhMjjU
	UIRx/FaCX5RVI7vNRPr/KBu8yeB7EifiYbKCx/p2OIFivGlkni/Wc/9HwT2bkbVnXOgWOzXVW7z
	E/2NFTQ0b3kKGiARnq9VWUfQyUZ3so1Q=
X-Gm-Gg: ASbGncuwJUG488VHE+1GWudHuWIO9hh7Apa3qLyJMmMqdHq06uTa0iDsTU24NgHYJOy
	MzcaYhRAVf4GOllKzmfrrJVuLzEH01LYsfl1f6mg74vY3KtHezPZf8jYsmOIU0yEWOgTT/DSN3v
	GWM6B9swHkITl0t6PmT5Vn0g7vPvQSnuOLV3f9x9pU8lp5o+jo3jAroBw32hl1H7n4IDuKnJnLZ
	zY76X3Ic8rueuPMyQQFkjzKWZNC02iNnINqLuOJyd2gbCPfZOxeJnDF9iQk4qqlzpJ2wNjkv9uv
	2Mt5EWT8zkh1voV2
X-Google-Smtp-Source: AGHT+IHgh/2ue5XLoiEIIP3qVcbBgpSwlGUDyMrIbpcYgXG8Fb2NWv4YHZCQZ79f1++pVClCNC7jVN49zC4Kgu6WL3s=
X-Received: by 2002:a05:620a:8083:b0:890:cfbb:f9a3 with SMTP id
 af79cd13be357-890cfbc03a5mr1867383185a.87.1761128534358; Wed, 22 Oct 2025
 03:22:14 -0700 (PDT)
MIME-Version: 1.0
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-3-ying.huang@linux.alibaba.com> <CAGsJ_4xaA8QRjP9H=n1hQfEfGop7vOd5Y=J+KQzuOyfa8GK-kQ@mail.gmail.com>
 <87a51jfl44.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zPH0fwBOLQwh1y6jG3tCXHLGRCTyVVSCWb+NfLCEMV0Q@mail.gmail.com>
 <871pmv9unr.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zW6ogVdi=t9JCuvGD9N21mA_ORXRCakw4Av68d9n+DDw@mail.gmail.com>
 <875xc78es0.fsf@DESKTOP-5N7EMDA> <CAGsJ_4zKGS-Xd-58ufXGoyRfaZWd8wTgv0b6ibHJ2aS14mQqtw@mail.gmail.com>
 <87a51j6zg7.fsf@DESKTOP-5N7EMDA> <CAGsJ_4y32i3aNYPum=8J3_Kt6vOSisr_jg6btB-YG1uQBqHG7Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4y32i3aNYPum=8J3_Kt6vOSisr_jg6btB-YG1uQBqHG7Q@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 22 Oct 2025 23:22:02 +1300
X-Gm-Features: AS18NWBircPFuACNmjNln0NVeJ5pMiUTEtaKbz7xy8k3SeBdgLEYQqjplgyUxCM
Message-ID: <CAGsJ_4yeygfzna6SRG3poD9cXhFNz21-he9psiKvMTMG8WBgmg@mail.gmail.com>
Subject: Re: [PATCH -v2 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Yang Shi <yang@os.amperecomputing.com>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Yin Fengwei <fengwei_yin@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7751640003
X-Stat-Signature: dmdww5yzc3u4rufzw4qd44bzdpw4xnqb
X-Rspam-User: 
X-HE-Tag: 1761128535-953161
X-HE-Meta: U2FsdGVkX1+vTgNnQJiP2tUh99NvduFEraCwbjZ38eMngul7IuuiAHe4A3BGOQAfoFHQFcvRVrOt8/CrJ+rLjmJA8MuKtlbbhVKJKPPB4L+4U9JXn3Au+g5S0U0hBforHyo3xUtCpoRD/9TXYpcFbXh/AX0nKf4q3pGXe81BBdDa+jJOhaVwOjJu/LcOb12g4jqyd9eTt0BCT8zNX8SKm9n7mYEtarwpWaqyS6vMFvOZxbwI3eGf3qyUJxB+Xrp7c0TdLfY08IBJq1bVMzqTffT9T0Oo0Hw0Czl1IhSKn5iNtwG/BCSfAzfLTTPluGv/tRR0JOeEqC9ArJL7G+8NKX40Cy/gBGhhslaIxLfSsI6M0EHglQjMSdodVVyOuhHj0mpzf38+PYMDW29bL3UDhkF4DfZ3C9eAhLehDXF6eek4YSiIrdl458TsW+wVNYz80v+9ux4mV3+6t1aZynAmiJhhj8xb3PGcNJLO00e1SZYKL2jagkObVh0y8tSUlX9sfeUtHl4hxKpU1jxv9EwyB/vOzkTbhoQAZA6Xh6ayCKvt8SwNuaq8FwwurnTF4Ni8iBU1d/54mTcoRklLe5+O8XsZvNjZG5zQakduNx47BRefJ+8kR7tS0JXjrgsNU4GO8yC+qTBJ+VZJ6g4WcZm6ID4n6NuKgDoWIBtnoEqqR5YM+0nXsye2U5KpAdy7ZZ+eFnu8RfBd2rGHYRgpB3Idnpgf6SGROjCty5Ugc1x90i2yhGkN5/bx4gXjxQUV5Cb504+aNtuN3k8/E9bDv3lz7mXiScZ02CC2KwfPCOMmSRcTb2kks04F0L485B7oWY4wW4OrAvdNAZnu6Tur5tiSOYjGH9zXX5xrDQ3v22U0ziY7aQfuCWRiYraTOuEDFyS0Za6O7RnlBUrxNzOTLZZO9IWiONOg/NjK5Tmra2oCOEttC+fdTczA4crlb26bNdFPkQP/ZozL9KUahJNtEcs
 Z2xBz8bk
 oMeGaLjt160ZiIM8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 10:55=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
>
> On Wed, Oct 22, 2025 at 10:46=E2=80=AFPM Huang, Ying
> <ying.huang@linux.alibaba.com> wrote:
>
> > >
> > > I agree. Yet the ish barrier can still avoid the page faults during C=
PU0's PTL.
> >
> > IIUC, you think that dsb(ish) compared with dsb(nsh) can accelerate
> > memory writing (visible to other CPUs).  TBH, I suspect that this is th=
e
> > case.
>
> Why? In any case, nsh is not a smp domain.
>
> I believe a dmb(ishst) is sufficient to ensure that the new PTE writes
> are visible
> to other CPUs. I=E2=80=99m not quite sure why the current flush code uses=
 dsb(ish);
> it seems like overkill.

On second thought, the PTE/page table walker might not be a typical
SMP sync case,
so a dmb may not be sufficient=E2=80=94we are not dealing with standard loa=
d/store
instruction sequences across multiple threads. In any case, my point is tha=
t
dsb(ish) might be slightly slower than your dsb(nsh), but it makes the PTE
visible to other CPUs earlier and helps avoid some page faults after we=E2=
=80=99ve
written the PTE. However, if your current nsh version actually provides bet=
ter
performance=E2=80=94even when multiple threads may access the data simultan=
eously=E2=80=94
It should be completely fine.

Now you are

write pte
don't broadcast pte
tlbi
don't broadcast tlbi

we might be:

write pte
broadcast pte
tlbi
don't broadcast tlbi

Thanks
Barry

