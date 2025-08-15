Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD849CA0EE8
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 10:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2EE48E01EA; Fri, 15 Aug 2025 06:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D070B8E0002; Fri, 15 Aug 2025 06:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C0D8E01EA; Fri, 15 Aug 2025 06:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEFC18E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:11:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70752140905
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:11:38 +0000 (UTC)
X-FDA: 83778575076.06.7B996BC
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 979E440005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:11:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L3lEl4M7;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755252696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CrP1RqrQrE+CCMDK7L29Lp1vhVh6WWRUdC6cwnE/mfA=;
	b=F5svgKQrGYaEz9KcuHSwcjYNnlOBK4ZVUjRx5nhSZjMYMnxEIoUuw3ji/jOyt47oW9n3D7
	h/KUa7YU285L9kBQJjRWxk1Glg0tgrziaVeOZWdWRsmrbJ8pEiom7kpCPD6B4pwoPVd7An
	VDMo/ipVBWkkze1xK3lN6BljSBjF5xo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L3lEl4M7;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755252696; a=rsa-sha256;
	cv=none;
	b=hcxXNwuO2jQKXPOpgVS6QbkU8kGcDIoz5u2ua64Q98ZLEE4Zalc7aPhNSeOysryCxyesUy
	yV2lI9ip2VognyZev2OYFScVXIOq0TVGiQ+j17yaFpiRWBZrH1CD24zSgXRvybyJtS5tbn
	QlXidJROjuDUuqER4V0FtArGp55sCSo=
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-53b174f7cf0so1387281e0c.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 03:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755252696; x=1755857496; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CrP1RqrQrE+CCMDK7L29Lp1vhVh6WWRUdC6cwnE/mfA=;
        b=L3lEl4M7GW3etwVdyWFE2u8tv4BhmBvMFQWRQ/KNd9o0R2Q9IKtOrDhRGJ+MZ5aiVs
         W7xqt9wVBlW5hjRi36pQnxhVf+VMMlSrQj4PNSnoPQ9NMCSKt3vveCmKYzT16KzZkVc1
         sbjPZ2/GrSGQd1P/F3LgPeKKcWk2EoYD/hLElzklbqWGMOWJJNXS9XLzzOl5AqvkC0/M
         t004fxyAe8crYDJpkED3Xas5cKLj9Sk+6pay23TbCeefGxicAB7CCbVnspSrTkHhqrLD
         9z7XF/7c0z7vNRS32m/0ZZnviWKRiFSpb1wY8ekvgbuiD6SIyfquPU1iKha6WbqfvlG3
         vScQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755252696; x=1755857496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CrP1RqrQrE+CCMDK7L29Lp1vhVh6WWRUdC6cwnE/mfA=;
        b=DFc8A/XwUtlmVmenI5GvS7DDQay9iFr+DQFJt668E/IT1UljgDsMTNAAYJ1TU3Pr/4
         DSr03O3yl1tgvHddR1LTROzdwDdsYVHKqPeWXC/7XHFPS9ilMlyWx22xG2ylIJEGa8ov
         EVlgiHmGr4l/UTMwxJXLQN3JcYtyY3U0TWJoyzn5w+LsCdaQZycdtA+dmaIwVQidCxnJ
         kthPIhG7vMdn8lELt55owYHtNonhFxI9YzyBVPGKiGhf0MV8I04TXWd6y8OdNTghDda5
         t9/ynQzUBjZwBLIkpbgEmaoDTkxy9Bj9a88xPFFS4+yZ6v1WwfajoqtuLz8Tt49o2SAY
         Vwew==
X-Forwarded-Encrypted: i=1; AJvYcCU16u9aODQrU0Epprdtxv4cID/of/AuV3SHsHfpi/UCYLottLrXDotlDwuoCwaUDRvFkWLtFUTZEA==@kvack.org
X-Gm-Message-State: AOJu0YwoQjDrf1fMR3c02+9doyplqN4ZTCmvQvpvfA8wiTb10Bf+myOF
	SLq3LQS5l9F7/vTcpxAiKOjacakTBXvMyePsi7orFQEqjgSS/qhxtoeWb6Kr/gDjdjeLlUfcZH0
	a+lKeNSQq9ok3YqphYtRNbT+MMKDYPW0=
X-Gm-Gg: ASbGnctxMZHBQ76yjj2RvbbjdgrIEg6S4Ucf06kxlYobWdlRHI6sEBP9vb4lelMXj8w
	lUdA9mPghnv3XdxgTOsp8bx+AEvOxBqDJSZZwEURlZYdoSF9ZtAV069A5pe15UFlit20H/3P16Y
	7V0zfYFxfnXjp/mllKVPEXc3FwRacI/SRwKcIlmdjQWJUMDrKnWVKNmhup+Xdt8VpiX9ZLCCSY8
	h33DMc=
X-Google-Smtp-Source: AGHT+IECBZnTmPM/nQEDW9y3twNaByBLA0nvasb656eSYR4D1TwoU4UEw/SNZt9fDLmfjZvtmjPsBcSSy+1Vk1LmRk4=
X-Received: by 2002:a05:6122:8c6:b0:534:765a:8c3c with SMTP id
 71dfb90a1353d-53b2b76a0afmr362427e0c.5.1755252695644; Fri, 15 Aug 2025
 03:11:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250813193024.2279805-1-lokeshgidra@google.com> <CAGsJ_4w5bAJHyBrwb5+n_EANqzhz4cFSX+9yZacmOiXVJZ_Dkw@mail.gmail.com>
In-Reply-To: <CAGsJ_4w5bAJHyBrwb5+n_EANqzhz4cFSX+9yZacmOiXVJZ_Dkw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 15 Aug 2025 22:11:24 +1200
X-Gm-Features: Ac12FXyaxQVPiABbs0kk2SIpgx7aAzdVcSx5eE7DyS2AoekcEk8ObJBnRsYHtE8
Message-ID: <CAGsJ_4wt_30C82B9_ZoOB2umBi-u_kE441ARvYoJVjkLtLqFCg@mail.gmail.com>
Subject: Re: [PATCH v5] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 979E440005
X-Stat-Signature: 3z1q73akdeqz4gx86pys3hj639mycz79
X-Rspam-User: 
X-HE-Tag: 1755252696-495990
X-HE-Meta: U2FsdGVkX1/Fyj69CQ2K7uvzkl1uARI80rMD+iNb0YNT8adWcVb4b4GpmMbO9nOWihQSrDvp0PeuEBQKqeZxl0/Zhf8/6GKWx2silqUaR6WYKwTcjH0MnMdWxRgXG6OZBQok4m5R6cqNrpj30o2E6wM+fU8blIRiGLtMDu5q0yZsnSlqUBdPzWAqVCtGlVT4n4Y/KjSynTnA0F1sQ6q6ramaEpcTZ6MLnf33MSZKBzbREQv20QEDn/0do49BhPTHpUcnhfaJlrggCJGbv0gxVV2tTZXkDujgSFdb2m/Xx0teBtB4UoNiIJiDfK45yNx/cNLbLK/MxfOWmkeM6z0emYB3PDKbOjCrzfjtBoj5NfRuB75qmacesJuxjwkO2tZ0j8UgSV0fgeclrrgTUSsxoJ4q+GvnQAPezlkTgYiaybMP7o9fjAqALZ9KVzFp/btReieXjSF0Xwzxg+g1uroxhQ9fK6+Ol41AHGVcr+dPzKPmzB9hV0LNb06bRcipz0YiR08U7RAxKToZuZjnu0C60CXe5pE+f7mtVZVG2dOAThuzHogS6hj08v97DffLoL9hfocLEWkmW8Ygo2LjUufzOWXdCBJTYRPw0gmeRj90VjMMp092qfVH+P19wMy7WjFfDXr+604p0o/wyLukIAtUwFg6QCj4zI8k5XQgxeUs5/Q5t24lD7g9WuFOPWKcNqZZ62dKzHPU7D8ESpYo4yTdAcGv6vXAiXHpIIhATv9KFWsp7NCxp7qFgn7D9SS1Syc8PbQRy+pNm5bI9x94ZEaI91R/X7ZDtnzKYiOcDZpiV5sJcthL0LfiFMYhce5P1n7Nq4znoySNc+/NhQOM/UIz4MyUpckemV+71nt2MGTntrrR83XjCxKENu9xRlTEzq5PVyioL310tMGqwIuw8ORN+MNIur40vHIIBaP1GIKdwQKuECa/wA2e3Sae1j19oCHEbnD8msAJ94R3ZOEtH7U
 IoIIm4Zq
 W/F8VP/gtGV2JpNVKXn5UGLyxSdGS9dLdXd6ES25NbvxF2kgByc0KnFv5aQuLAzVX3Qbu45YhQW5SfFXQ3InqzVB8v2FpSz9YHWw0bhr5OBoe62Y62BRRWdq/M5cO1rcHFFLCSPpRw5EzIzSUhL/TwNc0gSHn3PyFALKow8SLv9GhUQO3YlmWMlE4Dl2fYlmqlmWSlE3yK3ESxizaDTakmD2Wfa8wTefS9bdwfqxJnS+2UCwM6gaRm2+gEhSVbi47H0Yh9PbmKlNsqDm8PpwlOn3wwIJ9ep61k0F7PHAU0ficriOWlM/wdJuy9nw0QJb0YgD+w2YT2U3yPxfifgUWbux55YWMzMP6+3PxPCJgPR8CeLrdVXnTTAaNRCdaIhS6ibw6OHBJKHw4zEpWSCdJXobUNiVT3Y6y+x/znLQNtpArOdchI7Z04eCNllrvYSOJD95SEeCEhMnEmIFuNktd6Y7rZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 9:44=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Thu, Aug 14, 2025 at 7:30=E2=80=AFAM Lokesh Gidra <lokeshgidra@google.=
com> wrote:
> >
> > MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> > for moving present pages. Mitigate this cost by opportunistically
> > batching present contiguous pages for TLB flushing.
> >
> > Without batching, in our testing on an arm64 Android device with UFFD G=
C,
> > which uses MOVE ioctl for compaction, we observed that out of the total
> > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> > ~20% in vm_normal_folio().
> >
> > With batching, the proportion of vm_normal_folio() increases to over
> > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > includes TLB-flush overhead.
> >
> > When the GC intensive benchmark, which was used to gather the above
> > numbers, is run on cuttlefish (qemu android instance on x86_64), the
> > completion time of the benchmark went down from ~45mins to ~20mins.
> >
> > Furthermore, system_server, one of the most performance critical system
> > processes on android, saw over 50% reduction in GC compaction time on a=
n
> > arm64 android device.
> >
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Kalesh Singh <kaleshsingh@google.com>
> > Cc: Barry Song <v-songbaohua@oppo.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
>
> Reviewed-by: Barry Song <baohua@kernel.org>
>
> [...]
> > +static long move_present_ptes(struct mm_struct *mm,
> > +                             struct vm_area_struct *dst_vma,
> > +                             struct vm_area_struct *src_vma,
> > +                             unsigned long dst_addr, unsigned long src=
_addr,
> > +                             pte_t *dst_pte, pte_t *src_pte,
> > +                             pte_t orig_dst_pte, pte_t orig_src_pte,
> > +                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> > +                             spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > +                             struct folio **first_src_folio, unsigned =
long len,
> > +                             struct anon_vma *src_anon_vma)
> > +{
> > +       int err =3D 0;
> > +       struct folio *src_folio =3D *first_src_folio;
> > +       unsigned long src_start =3D src_addr;
> > +       unsigned long src_end;
> > +
> > +       if (len > PAGE_SIZE) {
> > +               len =3D pmd_addr_end(dst_addr, dst_addr + len) - dst_ad=
dr;
> > +               src_end =3D pmd_addr_end(src_addr, src_addr + len);
> > +       } else
> > +               src_end =3D src_addr + len;
>
> Nit:
>
> Look at Documentation/process/coding-style.rst.
>
> This does not apply if only one branch of a conditional statement is a si=
ngle
> statement; in the latter case use braces in both branches:
>
> .. code-block:: c
>
>     if (condition) {
>         do_this();
>         do_that();
>     } else {
>         otherwise();
>     }
>
> By the way, what about the following for both cases? Would it impact
> performance in the `PAGE_SIZE` cases?
>
> len =3D pmd_addr_end(dst_addr, dst_addr + len) - dst_addr;
> src_end =3D pmd_addr_end(src_addr, src_addr + len);

By the way, do src and dst always have the same offset within a
single PMD? I don=E2=80=99t think so. If not, how can we verify that if
src=E2=80=99s PMD is not overflowing, dst is safe as well?

Have you only checked src? And for src, since you are already using
pmd_addr_end(), is src_end =3D src_addr + len fine? Why are you calling
pmd_addr_end twice after your first pmd_addr_end has already limited
the range?

Thanks
Barry

