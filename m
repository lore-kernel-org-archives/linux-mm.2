Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A15F506DA
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8AB96B02BB; Mon, 16 Mar 2026 10:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62666B02BC; Mon, 16 Mar 2026 10:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61786B02BD; Mon, 16 Mar 2026 10:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C39DF6B02BB
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:37:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A0801402B4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:37:30 +0000 (UTC)
X-FDA: 84552179460.06.DA81B33
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4D40DC0003
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:37:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ER9A1bQl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of glider@google.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773671848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rRCsSSAyWmAE2MLvbvaidov3aNy3rtI5UNpHjlkE4R0=;
	b=OGKV19ZGezP+vm2pyBR00YckGaG77EiNdzD0ZhvBUtc6WO7iJDXqgapxYrAN0u+mmGEMCb
	Nrdjew5sEBBVqvRaSVygGCiGo+wyPlSODblwzo3wNfCPTaoT0juLaX/o68IEP2Pa9CNyaF
	slEEQwsbu0l7T62fnHlVLpdrUyBtSGY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773671848; a=rsa-sha256;
	cv=pass;
	b=7Oo9DKX3HFp2EV98b1VsIm+C3g9u4Z4+KQ3cuv3HcSE+BA13TDtVIdVVgRFgiTHzZAj8Ch
	oK770VBZN9oqoKjAjmXOzkuXSNqRc1FFLuiMYhtx5TurhcozQrSm870ajlWen3cPf3iIN3
	J5G6ajysx5uV12Q96p31zN6E0iURW54=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ER9A1bQl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of glider@google.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8299f1ca894so2345158b3a.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:37:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773671847; cv=none;
        d=google.com; s=arc-20240605;
        b=c8NSPQQNU1gG7/Tgkm9Zp6JjGdypR5azbHvmJwhTQu84duQLtP99RGry00y/A8Teii
         Py6+FhLoIc6BPvyUQ9AvQ/6n6qmfeR45md0EOyZsuhaMfcsQtgSWgBUQOWSdCr0YhIIh
         xxlG7x/FeaSZJl9HZo92mbbT758k/kE1vnEpMxct8Gprg09s8PAortXgkG2IcXP5RXkm
         Chy/BQjSEetY7IL21d6+qE6PUrepe9CXcvakGyex+gzTSZLILBTGs1CYcfqiARilOMq4
         0GGTyH4eLUizHRaZYbbi1n6U3Eem4yx3KeJUctsacXI5Y8bzh0NHg2BMvyiK07INFTFT
         RJlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rRCsSSAyWmAE2MLvbvaidov3aNy3rtI5UNpHjlkE4R0=;
        fh=qvi3EhJUEk6P4Q0VOqmIBIeSgXVd3BJCyBlcpJmplUk=;
        b=hvI3iThDaINqi7lEfNNq5kbGlnNkjRI/+tRXqwa8YEcKAJcxST/2gRusTcDUFN+lBd
         8ah6LtpjExuyb8e+f5hgFtgzHnNS9FHZVU9eWtUv9YlQGhl50gfCa/OgbKH0tX/lsTqc
         ng7tiPifiOqeQChjjqJRCve5iRV22XfO2rNh9aab23PrsOfGPQNpdypuOhoxhE61La+d
         xRRcq9hVH2oxAiT8JUKqKxxzikb6eSqoNazU4UW9Cb9QqSHoBfVSEqKC/XNR7Z7rj74i
         Tdwx4nqmt31rKBZMV20s6547Qdhf30rUN7l+ZjHXVHEuPfX+o+ioxQ/0m6pDYEYfFgZP
         Zu0w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773671847; x=1774276647; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rRCsSSAyWmAE2MLvbvaidov3aNy3rtI5UNpHjlkE4R0=;
        b=ER9A1bQl71NlKTbK0n7AOd3tNZxmbe+aGLMbe/dJDWRPtHnj5O5XEKBh+Nltkdyu/I
         evzwoYtGyVhxntG7f8G5dWhx8l0QGhg/oTZjPJ8vmzu4tqv1bapOKRXOgiWT3DEhj0kZ
         SIkc8nV0hDIrSooGCMt7aALSZ4p4MgA+C8bXxqFv9ZfiDgNLKMpCQBgC9EauT6IdNdj7
         7/KFncjzJgoaz8BM+YJK5tA35oV/9Du7qthBUQSfZpABqyvlBrPMtIChsXNX2AgUDfWQ
         NNot5zlSxz+WFCOgN/HhE/VyIFZjSlmjiptS9Zmjtbi7LkJMtvJBS/dggk+zDh7ao2t7
         cZfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773671847; x=1774276647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rRCsSSAyWmAE2MLvbvaidov3aNy3rtI5UNpHjlkE4R0=;
        b=NdBG/tWLrPdlvPcKEynyuqhwuar4o3H4yz5V2KdsCgdL+bdRgC5bO/bsWyzrKhvo75
         tTpneq5OKPINjL7oEJMwA49UZ1Vm2NuXMYdgOKw6gFKi4SR3mfJMahUU7QnzILZYr1Wf
         ERbmE8X1aQ71/DiLj35NaBtE1wSEVat4ZrMvGlHPkGUQ9p55iNAkkwNmwWavOgLbmFPe
         1n3kyJkQ3x5QBIToS8jeZN3Yx9lVCBGgXplHtALCo4fDFu+6EkvzehcqJ7FJVHD7wC44
         lvf1jlh2OlA7K5fDD1+lai7PCTjLY6biXwLRC4cpS1Abad5E7riamXFnZonuCgUV0YoH
         ZQkw==
X-Forwarded-Encrypted: i=1; AJvYcCVOM6O5XMuCWp4NpXoYnSJ2+x90JtgdzD7Lte4B4DJCu0vIqiKDVniw2ebm8pQzP6hf0sCmBRoskw==@kvack.org
X-Gm-Message-State: AOJu0YwhPR/JoXs3QbeGO2u72VJr+8N1UvX6yQ19zK5zLMG8WaKn1L76
	ZGgUoHNVAAHlprRtHyeAPAiwib1mIkX4zzpLHP/CAbe3eZvy7lu07noRH/532Eg9MFj11JvPOpe
	nGpL41vbv0yui/OcTQhQA+zHykXEfT0Z51Ac84HsZ
X-Gm-Gg: ATEYQzwP4rzRcqdiHE8VNOFREL3rMzfSsN6ybnXaP5Fq1FFEpveInKyv72uoIghxMEz
	8PKYIy4mCIlCzRrDwnOFyTZFi93dferViXB+1qHE5BZYAkbhnBGHjPDvMkOGsuisW4SWWX6Si1y
	Ufdz9q0xiJc9rWRMKyrwsOlZqtlRbrgIx+oY2xUotGtGdKrrPGXVYZb6JaXE4kUPR0yEz8jvrNC
	aYI5eiAwG4Cah3jix6PSo2d8n3eKBiY1B+SEUKbvtxs2qQw2Zl92hGlVTaIbwZfG7SzmQrM6WoE
	j7iahfbb/cRQwd9ZiUsXBK/x6yJPZSIcbDT/YOqS12oVVFwG
X-Received: by 2002:a05:6a00:1d86:b0:823:3fd0:7a08 with SMTP id
 d2e1a72fcca58-82a1991164dmr12625721b3a.49.1773671846415; Mon, 16 Mar 2026
 07:37:26 -0700 (PDT)
MIME-Version: 1.0
References: <69b7d9f6.050a0220.248e02.0112.GAE@google.com> <20260316-fachtagung-gelitten-17389c00b6c2@brauner>
 <12d8c91d-d839-4f3d-aca8-0c63e66354d7@kernel.org>
In-Reply-To: <12d8c91d-d839-4f3d-aca8-0c63e66354d7@kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 16 Mar 2026 15:36:48 +0100
X-Gm-Features: AaiRm50THutRvB0tBMPu1w8GRllpIcAp20YwbCOXMvc9a_yJYiukL-uAWBpQjro
Message-ID: <CAG_fn=Un6Yzz5NC1E83Tq--_WYdiH3F8DaaSXkc56uUzGMZSag@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KMSAN: uninit-value in copy_from_kernel_nofault
To: vbabka@kernel.org
Cc: Christian Brauner <brauner@kernel.org>, 
	syzbot <syzbot+c18de0ad13d62f18469d@syzkaller.appspotmail.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Liam.Howlett@oracle.com, 
	akpm@linux-foundation.org, david@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, 
	kasan-dev <kasan-dev@googlegroups.com>, Sabyrzhan Tasbolatov <snovitoll@gmail.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: bmcjeci9zfm3unqr94rxie95ucj77ypi
X-Rspamd-Queue-Id: 4D40DC0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1773671848-939907
X-HE-Meta: U2FsdGVkX19pFo/zB3lOpUzbl2t+f6/7sw3n7Xts3OqgFqvYPmvqE4b85luqy7xo9xv3TizYPdC7I+2AzoPQM7K6tu9hOjpCqeJLFlZJxWDfQV76+SY5sjt1uzXLm1SnS8TUy1H03hhAV2ZL5DlUfYKA/LDc8sCD3BNtlOczflfMcgATU9u5oeMKkHBsQEaG75kYeFKHZ9K21vfa8JYfXV3LRzCCjET0xOh5dK4P5isb6JR2/fUJTFJM4zR2VlOUggzUoV0zjAxGLxj4aDnFFf+b6SRzuDWj+xONCEvFGARrKT9Slw0Zn3W8+gKM5b5iljYAPUIHoy/RYxSlbeHBQXEhz+R9OcBvwVl5bXUq1a98OMxUfXX+jFwzrxLIPUStJ2/FBxQB9+aOrq9fEv59PF29DCYR9PqyKIpGw4NtyuiRmU/FqrOM0K6EmBQfGAu+yugyTPgyrbQ+ft//SWtzZ5ItexNbK8ir7cMH72fPhKd4VkKD0/8X1IJKrdUrTwfg4VOHEMQZjmKgbIm4uaP01oJes66op94CpWdIBWYjwkcP/QCfqzyhWGG+dSbeKymvAegpI45Qfi5BX8e/HZaX5dHIfnumQSdNqNjk7x3H9oyKI5IULAKkoWBmEFpW6ZIiScL3j3urZJTiSpS5ZhMRdb89elK5nIA+chur/JQsZQvNreTBMk3m2wJb0VsXnAjI38CQN46zs5v3NdFddNqr0iWWx3V2HpGEI+I1bqsUYKyBZFh6fLhpuL3pf6A2zBd1ehj+etJQVFQKQyNRnA1vhaBtsJVF9wDyo1dFtIfsuwXFO0pvNZGRiGGMiFxidXVCYiY2L8pbCVA/djhjz3mTQVVcYiHbTaAwfcg29JW60BDgd0mo4F1uWu8H+ju5q306tR5OvdkcQBrTkPbf5oxo65IBoHMEqOj0MjsRdArRp4u4aEdbpUauQRPZGG6wkTW3KvHaRtacSj6sTSiu0y4
 PO0zyxd7
 nolihbbaY5/OarGEyMOuEn8su+UGx9CW/1Q8BSkfdQHf/ksvIk3sa5vtrtoudmTdP04Q6CUOL3OnXY/8TpvLarC5StOtVoiy3+2MHKMX4kSVZSAHhh4reeI4Q7BWHQXO5s52asmWDcw9OhamomyBHd3liE3AujJ4BUuUkZf6q0hc6oMOjI6+Sx1/BmAdd6QAZ2KRE7MDwMNmCUM/6YJSH/Ez8nCbAMWz5nPRK8rLShEpQxLhNGNvovlXzi67s9yUZRhuS7CMmLhMGGwdwn57xkBBaG2wJu23KxAHHeaJGJLLgz8kz55dhoRhlK9V2LiwOpbktruJBmFVNMiJYnsTOKNCnUBQOyDVBKxkyFxUzrSWiUVb34wrXD6pTf4Ns4odYogLSn4wM6Be5WrMDPgfJxWR/CKWefJz0koE9UIxL0TzIfs+Y6D4HNwbeVoHSUi2ZjnjvGPBBZ71Ap1o5XYao48k3w//E11eW0Bg1sHzs+Bdmg21hskSJWC/z7f594wuKTkzfqx8KjiEqpjiVjwcHsf/HCDiWzDwNdHk9JDegvYVsdqG7MTONV5jJQj7acxI6PWj7KezueEEJPjrrp9KlYJ+k6K3mTSBhiHTp3U/zs4iEAm0c46+uUIvIcp89s0RefBaFs08HOKoEIGcEyvH/PHoFZFevBddypm61DChSqNnrYZuLwzGZwH9cGKgEP0eMbZAMq9EzGZlS1kPEtrB3LEEBzH1RCcDlyapDjSZpEuaBOKAg4vxuhD0Ot4rKh0JdzX5oL2reyOBP96oHBerxDID9LelFOqdSwQN4bE21polEKHDoxmaHqiy/jt0oG+CjHsWbWFzu4csQiXblxwPJavmFKIQVnLmhBgVQ7KamP4KDKbIgyhpgG1UnuQShuMrzQeV/NsOzZyS5FzM4kJ3Hq0qSHtlF6qmu/Srqx6tKfZcGDqL4lhZX78NAo8KF/97K54e1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 1:44=E2=80=AFPM <vbabka@kernel.org> wrote:
>
> On 3/16/26 12:58, Christian Brauner wrote:
> > On Mon, Mar 16, 2026 at 03:22:46AM -0700, syzbot wrote:
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    80234b5ab240 Merge tag 'rproc-v7.0-fixes' of git://git=
.ker..
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1474cd5258=
0000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D242f02fcd3=
fbc8f3
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dc18de0ad13d6=
2f18469d
> >> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43=
e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> >> userspace arch: i386
> >>
> >> Unfortunately, I don't have any reproducer for this issue yet.
> >>
> >> Downloadable assets:
> >> disk image: https://storage.googleapis.com/syzbot-assets/a0d037332dff/=
disk-80234b5a.raw.xz
> >> vmlinux: https://storage.googleapis.com/syzbot-assets/0a1f7f8b54f8/vml=
inux-80234b5a.xz
> >> kernel image: https://storage.googleapis.com/syzbot-assets/83eb68ee642=
1/bzImage-80234b5a.xz
> >>
> >> IMPORTANT: if you fix the issue, please add the following tag to the c=
ommit:
> >> Reported-by: syzbot+c18de0ad13d62f18469d@syzkaller.appspotmail.com
> >>
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >> BUG: KMSAN: uninit-value in copy_from_kernel_nofault+0x15f/0x570 mm/ma=
ccess.c:41
> >>  copy_from_kernel_nofault+0x15f/0x570 mm/maccess.c:41
> >>  prepend_copy fs/d_path.c:50 [inline]
> >>  prepend fs/d_path.c:76 [inline]
> >>  prepend_name fs/d_path.c:101 [inline]
> >>  __prepend_path fs/d_path.c:133 [inline]
> >>  prepend_path+0x64e/0x1090 fs/d_path.c:172
> >
> > I think this might just be KMSAN not being able to deal with seqlocks
> > appropriately?

I think KMSAN correctly points out that the data is uninitialized at
the point when copy_from_kernel_nofault executes.
KMSAN actually knows nothing about seqlocks or any other
synchronization primitives, it just tracks the state of every
uninitialized bit in the kernel, and reports an error if the data is
uninitialized when a check is requested.
It's a good question whether we need the aggressive KMSAN check in
copy_from_kernel() (are there cases in which this function copies data
out of the kernel?)
If we do, the following patch should fix the report in question:

diff --git a/fs/dcache.c b/fs/dcache.c
index 9ceab142896f..923e32e6a2d4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -32,6 +32,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/rculist_bl.h>
 #include <linux/list_lru.h>
+#include <linux/kmsan-checks.h>
 #include "internal.h"
 #include "mount.h"

@@ -1749,6 +1750,7 @@ static struct dentry *__d_alloc(struct
super_block *sb, const struct qstr *name)
         * be overwriting an internal NUL character
         */
        dentry->d_shortname.string[DNAME_INLINE_LEN-1] =3D 0;
+       kmsan_unpoison_memory(&dentry->d_shortname,
sizeof(dentry->d_shortname));
        if (unlikely(!name)) {
                name =3D &slash_name;
                dname =3D dentry->d_shortname.string;

