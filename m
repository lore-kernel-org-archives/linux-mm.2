Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E82AC60A262A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OUXVGGxw
Received: by kanga.kvack.org (Postfix)
	id 161886B05B1; Wed, 11 Nov 2026 05:00:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138646B05BD; Wed, 11 Nov 2026 05:00:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04EF86B05CB; Wed, 11 Nov 2026 05:00:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD42D6B05BD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:00:33 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 547191A01B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:00:33 +0000 (UTC)
X-FDA: 85422393546.15.3886D7A
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4500D180008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:00:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OUXVGGxw;
	spf=pass (imf16.hostedemail.com: domain of elver@google.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794391231;
	b=NFqwGywo66uo0uEUKa/NJEm3fMMDVZHTSnLYjDvmmL8Pf72n+KL3gybIxFzsUdklIN5Rlr
	gQi+7itTVO4hfH+b1xvDrbtE21Kben79sB73xzNdjSH5bScXO4Gd/hu8LJuNK8MKlbpzCS
	XKRLA33huATxUUW8WQz7u5MS/dn5cO8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OUXVGGxw;
	spf=pass (imf16.hostedemail.com: domain of elver@google.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794391231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0snpShHvjoBSXjJ0hmmIC0sdwMSEV+1aJlZlq/yq2c4=;
	b=IEEVkB2ednJ0yvmTUbGbUDbG8bC/Okff/N0c+RExgrTYo44RCbyXpOeFMVE/Q3rKvsWhpR
	PIHH/RfSOJoSSAkOq9AykAPscvmqYrFG0cnXBTeq0RqRe/5sYIKyyshGU2x8YlJgqIKlvj
	eXfSkqZ8UYs97Icf7tznjfWA8mDcOHo=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-67c0bd676eeso2932808d50.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:00:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794391230; cv=none;
        d=google.com; s=arc-20260327;
        b=bLCqqjrrcWZTVIKsQGcqq0d/ttcVo6USScfK6jVKvSf3P6I624ubCr3/hEljxuK9o1
         IgnrNpldCx0G0GRGhA45ovCrXJ+XW3fnwbYwSqsNh8C711x/r6+HO0+fRZoUvrmTLL4s
         y7fPhcBbjlVN1cPKTNrQa7F+Xywj67lOxfKdWDMeJiRzzfMks0NGVBoZNM67IwnElcSw
         /J7vjmGxywwsK66ZzocU9jDXHNHikYzn+hflp5XTNlxjSMVfg05YycBxcZBH8iF4Tkb2
         azQF9E1A6PRlxOnSNyLGdWYp8hwbh7HGqITnAkuwuyqlGz+zQo2ls+kHFRCxfiogwVQf
         CzLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=0snpShHvjoBSXjJ0hmmIC0sdwMSEV+1aJlZlq/yq2c4=;
        fh=b8jdRW0nHvYLAgfWx8j9qu311bXhJfh6fTqrgWctAKU=;
        b=SfW3U9hJ3qVVT22P52uX1de9sWS9MaSOkMV+4dM+HgrD2vUE1tuxCsRw1M+TySfsbs
         TPF1bkaPxGLE9hEqcjFcvfYCcWPsdurofnYrbk4/uvE5+75dutOdRIfzHXgpiEPPvh0A
         IrxhLGUGB++7OeJwlkpKVoENm0eDArCCzB2mq/8/ALZn2w/gI410g3W5Np2+CHw6W2C0
         o0NYV1CfHcdm0e5R78cBX+bK2hrIC1TapkyI0YxtJvkYBQD5fJ1Ci1HCE6O+rLM+WFt7
         Q6XoBcLVIh/JMtlvbRUZm+g4pnaarZtDdX9cMmlUbfxc9K2s+1VDyTDtiUfJ35Jekuni
         vGyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794391230; x=1794996030; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0snpShHvjoBSXjJ0hmmIC0sdwMSEV+1aJlZlq/yq2c4=;
        b=OUXVGGxw+sU0JvU5XteqoGeBP5yx/4GpFfP+wWvXUG7eLaqJxRIomus4IxWlViPi69
         qHnJ19ZuYmK41TXWtXRgQ8IQqNTSsb0NVqWWtnH37l+g1i+Lj1srTEusxs+ugYAO7ldt
         D39exBU8YxyVn9soyTKsBk06Sg02P9WtWDOgDVuKv2Irw9m36gzwOXJRmy4N9j9TlmPe
         9aomfBjbARfFZwfAIp/jR1ywa+lDcyZl6ynSk27Mmn3nwWvscdsOiAlz6oODyWqOVTk3
         6xMMR7zGu/0kD6ySGmcpwirPyvPF2UiTZvd1gBqDPHuWijarVFr3myZCcrA8l+YUJQJk
         AowA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794391230; x=1794996030;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0snpShHvjoBSXjJ0hmmIC0sdwMSEV+1aJlZlq/yq2c4=;
        b=mw8PIIlwKXdpFeI5ImQVD15p8EceplAAkXCc+4V7OjOFkIFlq4P7L/E4nSutK0MVpr
         TG5lU/7CzFPaLcJ4/RpHkxeU+FtbVeTYkvNOJZSYQgcFvNyh38I/gTUjdBRCn/b5xeqj
         Gwda6F/PlXLUEMqDZ/sL3w1mGCa6zP5Zn+AS3CCQyXncRmTiWt+BILbPAbkT8DobPyLy
         xCr/scraDXsJLKHDvFxVBKICOTv11AaUO1qTp5xBTMuiU2AawOW5MvhjdQ3w05KpU7hY
         m2dZcMwCVFyXs/QDyBU3TnOoc2Btu4l4DKSt7DqKXGDDEU6DO7NEWSy9uy9S4vbO0txT
         zcjA==
X-Forwarded-Encrypted: i=1; AL+hErHOOWa8k0T1hghvuO4kCwY13WjEDdXviImy8OvvJiaSqRwCvCr+5pLZB5wwX0z5pwYHEYGi2iNYKg==@kvack.org
X-Gm-Message-State: APuU4Z9xBTVWUXa/QnWazRHWJ4VjRku5vrPaGgrVUL8bfR7DrkbTMgMa
	cyxgLQZIk+5V6KXu5Qd7idoKbwWlOrJNutr3pJUhj/F2CxhU5wZpaRLQSq5LCClObCz5lYpDdb2
	kwYdDVQWXFkJkVcGovGXN0aG5JHaOMm8IdV30O69x
X-Gm-Gg: AYBFou0y5UI6O2vLTKGnvSQtXWfRTTG33n4Gx+8w590n0OyfY7PNMnFNfqrV67wpQAu
	cPBJls3a24Kossg6DYQQ1mC+ZDtk/2S8cmWev5+Wo+PatOa8PGEIKCPy38T4A3otNpcBbpfpZXl
	Mzj/bw4ObPEXR1QDdjGUi0YdDbXJTdyOllKfXmmHLgU3enuKMNqC6IRSy5DZoWUQHcKzKV715zW
	ZLc4GvdtpHFfrgD9LAGuLFXOwUTbg6ZPNoy8HHTq++XWa38jDaBWrbn0YDDUxC/B/QQVXWY7zqm
	v0AiE3OHXftm9f34IFfEYL4XubzEXsaAjixQuXcbzvkoQ1c5rpyusKiqzR2iJP6XZbUQTa/LQC8
	vJb3AXq3VH+NtVZ6T068KD1JeCoVdeL1Xmc676o9SSg3ChRFXdDs8LEs+QdrmIZCofgyD4l58Qu
	6ZCz63mcDZoiu8cw==
X-Received: by 2002:a05:690e:439b:b0:67c:2fdb:9419 with SMTP id
 956f58d0204a3-67c67f97140mr1094112d50.57.1794391229421; Wed, 11 Nov 2026
 02:00:29 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111092231.2027735-1-arnd@kernel.org>
In-Reply-To: <20261111092231.2027735-1-arnd@kernel.org>
From: Marco Elver <elver@google.com>
Date: Wed, 11 Nov 2026 10:59:51 +0100
X-Gm-Features: AclHuK_qP5L8F_RmiE0XH87_imZfKgz52BAPUVzydYBM3OwPM4hCNb5eu8txhc4
Message-ID: <CANpmjNP5p-N6v=GiETYQMxgRMsOgKOdUjDCxSHj-6=pa4NkA8w@mail.gmail.com>
Subject: Re: [PATCH] [RFC] instrumented.h: mark instrument_write non-const
To: Arnd Bergmann <arnd@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>, Andreas Grapentin <gra@linux.ibm.com>, 
	Finn Thain <fthain@linux-m68k.org>, Peter Zijlstra <peterz@infradead.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, David Hildenbrand <david@kernel.org>, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: k8zt6d3edbbtzty85o9zgmktb6eu1mgo
X-Rspamd-Queue-Id: 4500D180008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794391231-364785
X-HE-Meta: U2FsdGVkX1/yTtLh6/6Q7Qbvp8efEMzGmEtWPQ5NXzscGw5KxH3EeTZ5cQFr6DAZLfhzT4kJbqcPddC1TbUwYI1G+58fLJ6iBWCYa/s/5tXlWdVbnZGIkj7+A4ntaencdEjFhiV6v8dL71qVgA3WFVHE9G+46oGX3Vr/IUQAFkTWXu6CbqIw5r+TQZ/fZleAWP5Snc+/M9OfA+pjsQorwndkgYVCPdXGBKKHGy0HeB+EgO3YBSDfYbOBNPzHOHjmcscyvTaa8bDA2n4v1FVmuxC81r47tbcbs2foUx6iI0RvGX9J2acRJQoToBlA01S/kFAsUFFtEMVJqt3m0OxJfjt52Kv38Vr/8YHltZgvPc20m0ZhLdcJ0olAqPwhLYVNUDwpIvvzvSn1X1lhz2ZVP5W2iBhS6y4h6w+4e6KrSiFGTxEBDPVFyyU64r//w9myg0VWgjzxO9Lx1+cN/PtjbG0MuSz2An99wuMZSJ05qiOORkkcVTvrLez9+f/0jEiBdU4yPIg0b5Tath7bMYtvHcmlz653EZQQx11fE2FeXILyJR8bTQolN+YpQAc6TKf5A0+QAxCElC8DyNz7Uqzp8qbGbqThmup4Mk6H84mwov7CiEis8RBApGty2uJEJo3MSVPw82n0Yk9W9DMTL+WvpqfxNf+3GXUB9H5pnc042AiE4Dht3SrVBcnNzfipxtEKeZSaoT54R8FG7qlYId719Vb2Oycq6+wCJol7dnUcBYfTmhmsBfYriyTb7jb1RxE8uUxlKZs3Axn5M54UFDEBbkErrFARFcacNjwd44hS85eSVciHxbEEjgHq+Rgxm8Xm+Xbcpnv9k4wqwcdn4253jxEaR4JXTcFrLNc6E9PGGFEgeSRsKSyLgrAlPvZgu28VjpPPDdS6/+4ozQY7HVHCsMlbCy1NE7oBwR/EwkxKkwLu2p29gT5Bobspb9tpTst6km131hzmpRD/frSoxLc
 rbMHEwLn
 IuBoF+ApvysUJTV82Y9Ki4/fg5PEV5zbO4xdlfhGDHBkQv+/t1bnkCO9Ox+DA2op+7/m/kDi74zDRFS5KkCUwOeARXlDKilYJeyFYso+asLjHz+k2AtUnPI7T9jMU6rYl0G10Rxf90T62XIJZHc0HYuLg1Gq8Chk98aKW4m3XpAFTOk/tMl/LRJBtJfUK2igxYgKT46ecnkiujMsVDEwv62iinCPBSUPLjcZiYE8nx6BIv1Q5iFJwv25rH75X/68RMFnoOiehFLBH/xyErEaCVnWbcMkThzKP2+QGasVylhn6M12/H7X9ewftexc0ryBpl9RYlJxM+XchVc1L/ZLGz4wxzSK5xE1lp6QPWOWHQ254H1sBDCITRxs61mrojkmDEUHgE5vElB7yb3SmZGyl6OBLRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 at 10:22, Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> I got another instance of a -Wmaybe-uninitialized in ntfs, as this is
> the only place that enables the warning:
>
> In file included from include/asm-generic/rwonce.h:26,
>                  from fs/ntfs3/file.c:10:
> In function 'instrument_copy_from_user_before',
>     inlined from '_inline_copy_from_user' at include/linux/uaccess.h:184:2,
>     inlined from 'copy_from_user' at include/linux/uaccess.h:222:9,
>     inlined from 'ntfs_ioctl_fitrim' at fs/ntfs3/file.c:78:6,
>     inlined from 'ntfs_ioctl' at fs/ntfs3/file.c:246:10:
> include/linux/kasan-checks.h:38:27: error: 'range' may be used uninitialized [-Werror=maybe-uninitialized]
>    38 | #define kasan_check_write __kasan_check_write
> include/linux/instrumented.h:146:9: note: in expansion of macro 'kasan_check_write'
>   146 |         kasan_check_write(to, n);
>       |         ^~~~~~~~~~~~~~~~~
> include/linux/kasan-checks.h: In function 'ntfs_ioctl':
> include/linux/kasan-checks.h:20:6: note: by argument 1 of type 'const volatile void *' to '__kasan_check_write' declared here
>    20 | bool __kasan_check_write(const volatile void *p, unsigned int size);
>       |      ^~~~~~~~~~~~~~~~~~~
> fs/ntfs3/file.c:66:29: note: 'range' declared here
>    66 |         struct fstrim_range range;
>       |                             ^~~~~
>
> The problem here is that copy_from_user() is called on an uninitialized
> object, but the instrumentation passes the pointer into a function that
> takes a const object. gcc deduces that any access to that object is
> undefined behavior and warns about it.
>
> The only workaround I could come up with is to remove the 'const' keyword
> from these annotations, which of course is not great either, as the
> functions do not actually access the data at all.

Agree, but the code where a real 'write' happens ought to never pass
in a const-qualified variable or pointer anyway, so I think it's fine.

> This also found incorrect 'const' annotations in
> arch/s390/include/asm/fpu-insn.h, which writes to those pointers.

That looks like a bug. Maybe split it into a separate patch.

> Any ideas?
>
> Fixes: 33b75c1d884e ("instrumented.h: allow instrumenting both sides of copy_from_user()")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

If there are no warnings that appear because of this elsewhere, then:

Acked-by: Marco Elver <elver@google.com>

> ---
>  arch/s390/include/asm/fpu-insn.h |  8 ++++----
>  include/linux/instrumented.h     | 10 +++++-----
>  include/linux/kasan-checks.h     |  6 +++---
>  mm/kasan/shadow.c                |  2 +-
>  4 files changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/arch/s390/include/asm/fpu-insn.h b/arch/s390/include/asm/fpu-insn.h
> index aaf1faeb3dc5..7cd6e9f30485 100644
> --- a/arch/s390/include/asm/fpu-insn.h
> +++ b/arch/s390/include/asm/fpu-insn.h
> @@ -359,7 +359,7 @@ static __always_inline void fpu_vsrlb(u8 v1, u8 v2, u8 v3)
>
>  #ifdef CONFIG_CC_HAS_ASM_AOR_FORMAT_FLAGS
>
> -static __always_inline void fpu_vst(u8 v1, const void *vxr)
> +static __always_inline void fpu_vst(u8 v1, void *vxr)
>  {
>         instrument_write(vxr, sizeof(__vector128));
>         asm volatile("VST       %[v1],%O[vxr],,%R[vxr]"
> @@ -370,7 +370,7 @@ static __always_inline void fpu_vst(u8 v1, const void *vxr)
>
>  #else /* CONFIG_CC_HAS_ASM_AOR_FORMAT_FLAGS */
>
> -static __always_inline void fpu_vst(u8 v1, const void *vxr)
> +static __always_inline void fpu_vst(u8 v1, void *vxr)
>  {
>         instrument_write(vxr, sizeof(__vector128));
>         asm volatile(
> @@ -385,7 +385,7 @@ static __always_inline void fpu_vst(u8 v1, const void *vxr)
>
>  #ifdef CONFIG_CC_HAS_ASM_AOR_FORMAT_FLAGS
>
> -static __always_inline void fpu_vstl(u8 v1, u32 index, const void *vxr)
> +static __always_inline void fpu_vstl(u8 v1, u32 index, void *vxr)
>  {
>         unsigned int size;
>
> @@ -400,7 +400,7 @@ static __always_inline void fpu_vstl(u8 v1, u32 index, const void *vxr)
>
>  #else /* CONFIG_CC_HAS_ASM_AOR_FORMAT_FLAGS */
>
> -static __always_inline void fpu_vstl(u8 v1, u32 index, const void *vxr)
> +static __always_inline void fpu_vstl(u8 v1, u32 index, void *vxr)
>  {
>         unsigned int size;
>
> diff --git a/include/linux/instrumented.h b/include/linux/instrumented.h
> index a1b4cf81adc2..d28aa6b0aeb8 100644
> --- a/include/linux/instrumented.h
> +++ b/include/linux/instrumented.h
> @@ -36,7 +36,7 @@ static __always_inline void instrument_read(const volatile void *v, size_t size)
>   * Instrument a regular write access. The instrumentation should be inserted
>   * before the actual write happens.
>   */
> -static __always_inline void instrument_write(const volatile void *v, size_t size)
> +static __always_inline void instrument_write(volatile void *v, size_t size)
>  {
>         kasan_check_write(v, size);
>         kcsan_check_write(v, size);
> @@ -50,7 +50,7 @@ static __always_inline void instrument_write(const volatile void *v, size_t size
>   * Instrument a regular write access. The instrumentation should be inserted
>   * before the actual write happens.
>   */
> -static __always_inline void instrument_read_write(const volatile void *v, size_t size)
> +static __always_inline void instrument_read_write(volatile void *v, size_t size)
>  {
>         kasan_check_write(v, size);
>         kcsan_check_read_write(v, size);
> @@ -92,7 +92,7 @@ static __always_inline void instrument_atomic_read(const volatile void *v, size_
>   * Instrument an atomic write access. The instrumentation should be inserted
>   * before the actual write happens.
>   */
> -static __always_inline void instrument_atomic_write(const volatile void *v, size_t size)
> +static __always_inline void instrument_atomic_write(volatile void *v, size_t size)
>  {
>         kasan_check_write(v, size);
>         kcsan_check_atomic_write(v, size);
> @@ -107,7 +107,7 @@ static __always_inline void instrument_atomic_write(const volatile void *v, size
>   * Instrument an atomic read-write access. The instrumentation should be
>   * inserted before the actual write happens.
>   */
> -static __always_inline void instrument_atomic_read_write(const volatile void *v, size_t size)
> +static __always_inline void instrument_atomic_read_write(volatile void *v, size_t size)
>  {
>         kasan_check_write(v, size);
>         kcsan_check_atomic_read_write(v, size);
> @@ -141,7 +141,7 @@ instrument_copy_to_user(void __user *to, const void *from, unsigned long n)
>   * variants). The instrumentation should be inserted before the accesses.
>   */
>  static __always_inline void
> -instrument_copy_from_user_before(const void *to, const void __user *from, unsigned long n)
> +instrument_copy_from_user_before(void *to, const void __user *from, unsigned long n)
>  {
>         kasan_check_write(to, n);
>         kcsan_check_write(to, n);
> diff --git a/include/linux/kasan-checks.h b/include/linux/kasan-checks.h
> index 3d6d22a25bdc..90b878b876f5 100644
> --- a/include/linux/kasan-checks.h
> +++ b/include/linux/kasan-checks.h
> @@ -17,13 +17,13 @@
>   */
>  #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
>  bool __kasan_check_read(const volatile void *p, unsigned int size);
> -bool __kasan_check_write(const volatile void *p, unsigned int size);
> +bool __kasan_check_write(volatile void *p, unsigned int size);
>  #else
>  static inline bool __kasan_check_read(const volatile void *p, unsigned int size)
>  {
>         return true;
>  }
> -static inline bool __kasan_check_write(const volatile void *p, unsigned int size)
> +static inline bool __kasan_check_write(volatile void *p, unsigned int size)
>  {
>         return true;
>  }
> @@ -41,7 +41,7 @@ static inline bool kasan_check_read(const volatile void *p, unsigned int size)
>  {
>         return true;
>  }
> -static inline bool kasan_check_write(const volatile void *p, unsigned int size)
> +static inline bool kasan_check_write(volatile void *p, unsigned int size)
>  {
>         return true;
>  }
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index d286e0a04543..591c179164af 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -32,7 +32,7 @@ bool __kasan_check_read(const volatile void *p, unsigned int size)
>  }
>  EXPORT_SYMBOL(__kasan_check_read);
>
> -bool __kasan_check_write(const volatile void *p, unsigned int size)
> +bool __kasan_check_write(volatile void *p, unsigned int size)
>  {
>         return kasan_check_range((void *)p, size, true, _RET_IP_);
>  }
> --
> 2.53.0
>

