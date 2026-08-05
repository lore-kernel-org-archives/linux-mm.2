Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1EA0C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A94D6B0095; Wed,  5 Aug 2026 12:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180836B0096; Wed,  5 Aug 2026 12:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096366B0098; Wed,  5 Aug 2026 12:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D44046B0095
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:50:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFDA81A054E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:50:11 +0000 (UTC)
X-FDA: 85067803422.12.B80A89B
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id DF34A180014
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:50:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CbasQwVr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785948609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SC/haMGSSO3JvkGSkvzj56vAhQvoqunq52zzzqNqxBQ=;
	b=i3lWzhrYg6rFJW8qv8a6X8Hx21ZyLGqO72a65FS4IYcSveGWpF1RkdDhixctpssse6Txc7
	CK40T5iOO54+d74C33+gDPQ1t56F4pu1uv5QMtsISBbht5MbfSSmUrCppJT6s5994eC428
	aRVY62PjSp7MZODj/QQPWH4mYjeI/Pk=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CbasQwVr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785948609;
	b=KNpj8b2yubpzjHicHSdbcdbFN06NO7XSTnHKc+cXEn4a+7Zw1LjQd/Wq22AGHm4Jfj23fE
	nbfeMnUbMSF8OwtM/lN5TtZWKKZ9zc+wsEIeY9Q/4+ZOJ77US5JAR3A9Vl4NsWQIUhHrKF
	pUrvSyOrTEkr8EP8HRIA+jcAQ9NoZuU=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c10e86e52so303161cf.1
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 09:50:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785948609; cv=none;
        d=google.com; s=arc-20260327;
        b=ZO6KoEbpyRc+FaXx8O3wDtXvvVSUFnwOTOltaMcJ0AiihgCk8geSUyZGV1/r3naWPp
         CM7/G4vyyfI6uFTkK4rgkdWS725ou11Dlef7isOvQiMbR3m/7iVkGHovC+DxOfBu9crK
         3IWxhtXpAxnS6fx2dje+BHUBMg/qfnsdEjiWA7SRPY/1gExwmSFdZX2TK08mNX8/JZTt
         GTlLJVwY9EVmaX8eAxCnBz1vOXcLZP9Is/u49d+kJukmIqCr99uGebwv2WFhZYZCQ4Ya
         8CS4bGz5wMuQlPNQwm+SyhLuVoZNhnt3QNW8nwM0k94ya6GVyK1dmYFZeNlYU6giedJa
         S/6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SC/haMGSSO3JvkGSkvzj56vAhQvoqunq52zzzqNqxBQ=;
        fh=si8weDJvGDl5LXfVWQ2NdT1ZR5Wx2iElb+WpQainqcc=;
        b=eUquroNmSlP0Pd62FPksBY2k0xM+jAHfqSxoXUHPGuaa2SiNaKTddYUx/zvA+IeaTq
         KCSK5eDFQGLWUHCXoiq+SX1rNdHs6ErUenG2vg24wcNZ0igzCKNYVEk4/pqarTZ5w7wQ
         zxk+TUPPEXyE9+saRdXAjJmGji7ffTuvOdEYo67sYmnv5wRwBHs9MGPruW2TztTEHsia
         IwneUcMNpoQslEHpP28TLPiTi2bZecMn/pziaqU36THNb43Y00lrTRBa4AigdGegPA1/
         OkDQEy3wWYpf5r9z6MwS7vqADiyioeSzc28GLJ/gHeUvo5CvKMM3hrP/mjFTFx8NPt9Q
         pOyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785948609; x=1786553409; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SC/haMGSSO3JvkGSkvzj56vAhQvoqunq52zzzqNqxBQ=;
        b=CbasQwVr45KtdwzDzs3MuAErTo5oeKxynDpak2bYUl016UMl7AvKBpcQXr4DwJ/kQI
         DZBFa1mLc1lOSa9VwCPsBP343cp03TU4W+9P4pZOXE0RZ4tEhxAiuGWc92bdEP1AZtsi
         jmUc0z3q47Yjr7aYlAPkiGNIgY+VXqZDAftf49LDdPYVE8Ev9N6fbBBFCkc2dFxR9g9r
         oha8uCUQ8OgwiLqs133k9y1g3G7pA0QgtFZj21/c1vtpQhEpZtn/5kmXUvRDvAJKUV3H
         nRYYlTkA64RjBQPJj5w8Fo/E2956YOEjpjgpLA/BIL/SUWlYEjU8ZGgE0CaMCCBhgmn0
         kjOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785948609; x=1786553409;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SC/haMGSSO3JvkGSkvzj56vAhQvoqunq52zzzqNqxBQ=;
        b=Ne7608tvmOv+y9cCHStVOFAePamfJscQE+aFo3jIcCJg0QU76dFDfB3MXPGmYDt6Se
         kOERmqjedr+N7IhMKKVuJSuU/DipKq2K1JR/oFbnRRSTi5GDPwb0uhL6pVZLh23fIAgF
         r3FEUfcjG3lOzISs5S70SSn+5xBLN5UfO2FSDk5fgMG3o4UbdzcazQ0Y4slzGVQWOdqa
         4KV/ECtWWCk/8isOvY6bZzHxas2lHi0fkqEAqsIfI5sCtfD624dHTe9CkA7pYfFwRck7
         hVpR4a4En2U7S6Tl9MSScRfUyOr1RB+eSxQDtHBZNDduEpBmJgxga+v/5jXn7T18uvt0
         F+FA==
X-Forwarded-Encrypted: i=1; AHgh+Rrd3BKGBHvb4KzvI9iGbRzXV7dvac+cRGP+haO7ygpAQPAIb46kDcQE1TwjPwyK/E+sZ+caVnCAsw==@kvack.org
X-Gm-Message-State: AOJu0YyB4+kzLtV+2E6TcHp9mzY6VSWt527qHyuGUu7nmdcFu8eGXSAZ
	J4rkrEGIEIWh3dm2CPX/dvg4EjK9e45w/bAOoQlvK5TNq3roUSn+m26PjpSBBMay6GibLrBmiAf
	8YepCHPSGXUo7nZRE9bgP69Ut+lSwEl/HpJjrbpDu
X-Gm-Gg: AR+sD122NV4skBDyFEAV5kse1SE4hxwH8wfiCxI4nln9AJT1Bxpn0VRF5VpNcF5tvZO
	KyUsO6HwEDAiuF6CxHpfvE5NUSD1MAo8y21NdaXEjNesk4BiuMJKhAx8qGBdTDlIFLegwbtL0Y+
	rBmAwpdzv7KZm+rwQ8AeoMsKwNr28JgrvQUxKwvTTCHdpu3FHbWxfFQKViOpg4k8HcJK/CwpBXw
	OsVMJGlASAOnHH7DJekoYoRaFj5Io3KGrNr5HbfIJzBVYSyWJkXM/8HZKtr2HQ0woVp/PU5QKD5
	ZGYp8cDP2BGyaBNOdwvotp+x+25xxgoS0bjNa3cAzhYWtopOglGjHXl3KI2Kao1n0x0iEC0R74I
	=
X-Received: by 2002:ac8:5c8c:0:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-52cfbb84d67mr91921cf.0.1785948608282; Wed, 05 Aug 2026 09:50:08
 -0700 (PDT)
MIME-Version: 1.0
References: <alG_1bhH5aqQCNEh@casper.infradead.org> <20260712132759.2030823-1-zhanghongru@xiaomi.com>
 <CAGsJ_4x3HiRP7QU=N-oPiWuxuTG1VvzCCdHPqr3Trdk_8WMUGw@mail.gmail.com>
In-Reply-To: <CAGsJ_4x3HiRP7QU=N-oPiWuxuTG1VvzCCdHPqr3Trdk_8WMUGw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 5 Aug 2026 09:49:57 -0700
X-Gm-Features: AUfX_mxD7V9wYmX0FlUu-1jaJ03MF3SoN5V9kr2Iw8s-v8Uwi6Wkb_XMaHnwciA
Message-ID: <CAJuCfpFYu3_u0j_pB8DoqsoMsMhP2dpzmBVp6a7Bq_CJC=Jhjg@mail.gmail.com>
Subject: Re: [RFC PATCH v3] mm: retry page faults under per-VMA lock when
 mmap_lock is not required
To: Barry Song <baohua@kernel.org>
Cc: Hongru Zhang <zhanghongru06@gmail.com>, willy@infradead.org, akpm@linux-foundation.org, 
	david@kernel.org, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, zhanghongru@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DF34A180014
X-Stat-Signature: 95esrs68pw7oi6p65ckpk7yfzbm8tjj3
X-HE-Tag: 1785948609-357147
X-HE-Meta: U2FsdGVkX1/fErlhrDayERgr4R9lYr8JVJQQUZIc6mUlxALWglxUi5t746THtgZ5jtCQ+6sLlaZZyZ8Fnm7XcGsVDFYfs6TYLArVewjI+vvz9eyYjUdEtixKveMMMKJS6S2xLj19p+Qd8YEOWAI+QVxonN8q125s1fDTeww6qFPY5b4DvxaUWE+epV/VRRdB2rq1MVouQjlhaui014ivO3c4J4gv6qtVynVF+Rm8lmBo1zXEX1xRkld+IBM4F60UMSRr/Ux8d6C/DR3QBTXCOwAtq7YKifH99nMAx2z/41Vhr9UnOSbx0MYzxsbaaMUCWBt6pfUC0J+5/YtVMNstVObUT2xKxlEIz0tlm75Xqlmy9wXUhud7rZCbXOzOazZRqXKt9U10vNTDEKndy8Li6krU5Y8g20MoNJBZgKkyhISI+OzWrNqiPDxC6kQA6HulrsEBIU5/KmsZhX4RW6f3UpJwVRNvynu8zq+BEdk7wwgSILlBWBhVn0fcsPrL4XmwPTeoPCGUL8xoPu7ZYN7xNPnDRuQUgzhroBg7OOt9w/bUva3kaKnlphsGS7cKSzB4QZwoKTbkvQioO1V1MW86hELRrKECMhfy1eVP1a4ZmbuTtyXHDZYZeFuqs5hZrYnK92KmdE5OX0KuB9cH+2q7IFhZmtqdMROiko3UNcauw+DSKatN44dwcljns/42Rnvms4WlNscYZOqJJ6AsJZM8vFrBkDObcLOhPPZ6Uhm7a++TjI//13dYJg2NBtRnSMuc0SJ0sRk2sHsuSM+qoXJ3Zaax9YRUVmTi/r18JtAMipg6cXe3lviOfZy/6fCosLiOo7k5scvqLT0trEXd8TZ6bjbo9ATv2j5afcOdDNX70C3TZSZimchJggJYg4YRdDL5a+XfH+k7/QPGmYppikZAFEPqmQHIt97xBYZ51dSpkri7rKUbZXEJSRNMLBC/o04OZxRiuHL39p8VAt791TM
 T2xwG77C
 /oFca/UyWKXnN3rvXs+QY7HgqViUaeIxUCDgl++7KSpunGvHeGYCsntY3a/scvSflhgSRei3ratXFhRYRBj4f1asywZDoZEd9meMeEjbL797g0/CSy5A6drNgwJTvWMISbCUNHd/S/0QTo3ZWigfImEt/29rfDa3nn2yVq7IgFg9B/N/+P/TWTNDUOrP5p0s8/mYcukQ5Q7/L+HiZrLJEboKj8c3+hrAATtUsMlCqUs9t9pKlzSEBbD6AWpoRRr+oYAX4XM6L5wJ1HudnX/HK2hPJfd8jHF6TKMGuViX8vXY4dbgIThi5DenKcFn4oekIT82Bn1f9iWgZdpj9wQDjt6qNaE6MNUAKtCI744ThxwXwsC+ygs/ppJxJF/9kxLLQ2IhI/ZCfIgMT3ScpSqvXIIMaBYJtSpk/96ZS8mt5c6DmYWwsmy8kH3XRcQrWBgM8/YYLmo3NnPEcFNU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 3:48=E2=80=AFPM Barry Song <baohua@kernel.org> wrote=
:
>
> On Sun, Jul 12, 2026 at 9:28=E2=80=AFPM Hongru Zhang <zhanghongru06@gmail=
.com> wrote:
> >
> > > On Tue, Jul 07, 2026 at 05:52:31PM +0100, Lorenzo Stoakes wrote:
> > > > +cc Vlata, the only one from the MEMORY MAPPING - LOCKING people ex=
cluded,
> > > > and Willy as he's been heavily involved. But see below you need to =
cc- way
> > > > more.
> > >
> > > Ugh, I hadn't seen this.
> > >
> > > No.
> > >
> > > I've been looking into this problem, and as usual it has turned into =
a
> > > yak-shaving exercise.  I think I'm five yaks deep at this point:
> > >
> > >  - Need to start by simplifying filemap_fault
> > >    https://lore.kernel.org/linux-mm/20260625195040.2508362-1-willy@in=
fradead.org/
> >
> > Hi Matthew,
> >
> > Thanks for looking at this.
> >
> > I understand your concern about adding more complexity to an already
> > complicated fault path.
> >
> > However, I tested the RFC patch [1] on Android workloads and observed
> > lock-wait regressions. The common pattern is that filemap_fault() can p=
erform
> > file-backed I/O while holding either mmap_lock or a per-VMA lock. The t=
races
> > show three representative classes of lock-wait regressions: GUP faults,
> > kernel uaccess faults, and per-VMA-lock faults blocking fork / copy_mm(=
).
> >
> > 1) GUP faults under mmap_lock
> >
> >   APP: com.xs.fm.lite
> >   lock type: mmap_lock
> >   holder: Thread-77
> >   faulted file: libbytehook.so
> >   lock-held filemap fault time: 95.606ms
> >   blocked writer: NetDownload#15 (blocked 218.971ms)
> >
> >   Holder stack:
> >     filemap_fault+0x0
> >     __do_fault+0xdc
> >     do_pte_missing+0x2c8
> >     handle_mm_fault+0x4c8
> >     __get_user_pages+0x618
> >     __gup_longterm_locked+0xac
> >     pin_user_pages_remote+0x88
> >     process_vm_rw+0x2cc
> >     __arm64_sys_process_vm_readv+0x28
> >     invoke_syscall+0x58
> >     el0_svc_common+0x80
> >     do_el0_svc+0x1c
> >     el0_svc+0x48
> >     el0t_64_sync_handler+0x70
> >     el0t_64_sync+0x1bc
> >
> >   Blocked writer stack:
> >     vm_mmap_pgoff+0x168
> >     ksys_mmap_pgoff+0xa4
> >     __arm64_sys_mmap+0x34
> >     invoke_syscall+0x58
> >     el0_svc_common+0x80
> >     do_el0_svc+0x1c
> >     el0_svc+0x48
> >     el0t_64_sync_handler+0x70
> >     el0t_64_sync+0x1bc
> >
> > 2) kernel uaccess faults under mmap_lock
> >
> >   APP: com.xingin.xhs
> >   lock type: mmap_lock
> >   holder: Thread-2531
> >   faulted file: libtiny.so
> >   lock-held filemap fault time: 172.375ms
> >   blocked writer count: 5
> >   writer wait range: 152.766ms - 172.006ms
> >   representative blocked writer: com.xingin.xhs (main thread, blocked 1=
72.006ms)
> >
> >   Holder stack:
> >     filemap_fault+0x0
> >     __do_fault+0xdc
> >     do_pte_missing+0x2c8
> >     handle_mm_fault+0x4c8
> >     do_page_fault+0x39c
> >     do_translation_fault+0x4c
> >     do_mem_abort+0x54
> >     el1_abort+0x3c
> >     el1h_64_sync_handler+0x80
> >     el1h_64_sync+0x7c
> >     __arch_copy_from_user+0x1b4
> >     copy_page_from_iter+0xd0
> >     pipe_write+0x1ec
> >     vfs_write+0x368
> >     ksys_write+0x78
> >     __arm64_sys_write+0x1c
> >     invoke_syscall+0x58
> >     el0_svc_common+0x80
> >     do_el0_svc+0x1c
> >     el0_svc+0x48
> >     el0t_64_sync_handler+0x70
> >     el0t_64_sync+0x1bc
> >
> >   Blocked writer stack:
> >     vm_mmap_pgoff+0x168
> >     ksys_mmap_pgoff+0xa4
> >     __arm64_sys_mmap+0x34
> >     invoke_syscall+0x58
> >     el0_svc_common+0x80
> >     do_el0_svc+0x1c
> >     el0_svc+0x48
> >     el0t_64_sync_handler+0x70
> >     el0t_64_sync+0x1bc
> >
> > 3) filemap faults under per-VMA lock blocking fork / copy_mm()
> >
> > Other testing also reported similar per-VMA-lock blocking data [2], whe=
re
> > filemap faults under a VMA read lock can block fork / copy_mm(). One ex=
ample
> > from my trace is:
> >
> >   APP: com.xingin.xhs
> >   lock type: per-VMA lock
> >   holder: xylog_thread_po
> >   faulted file: 2026-07-07-11-51-46.203.log
> >   lock-held filemap fault time: 10.518ms
> >   blocked writer: com.xingin.xhs (blocked 1.583ms)
> >
> >   Holder stack:
> >     filemap_fault+0x0
> >     __do_fault+0xdc
> >     do_pte_missing+0x2c8
> >     handle_mm_fault+0x4c8
> >     do_page_fault+0x30c
> >     do_translation_fault+0x4c
> >     do_mem_abort+0x54
> >     el0_da+0x54
> >     el0t_64_sync_handler+0x50
> >     el0t_64_sync+0x1bc
> >
> >   Blocked writer stack:
> >     copy_mm+0x2a4
> >     copy_process+0x4ec
> >     kernel_clone+0xb0
> >     __arm64_sys_clone+0x60
> >     invoke_syscall+0x58
> >     el0_svc_common+0x80
> >     do_el0_svc+0x1c
> >     el0_svc+0x48
> >     el0t_64_sync_handler+0x70
> >     el0t_64_sync+0x1bc
> >
>
> Thanks, Hongru. It seems these stacks clearly expose paths such as
> GUP and copy_from/to_user() where I/O may be performed after
> Matthew's approach is adopted.
>
> I am putting together a list of paths that would perform I/O under
> mmap_lock, along with possible ways to address them.
>
> Performing I/O while holding mmap_lock may result in unpredictable
> and potentially long mmap_lock hold times, so we need to address
> these issues at least.
>
> 1. GUP doesn't support vma lock
>
> Maybe this can be addressed by Rik van Riel's patchset? I haven't
> looked into it in detail yet, so I'm not entirely sure.
>
> mm: use per-VMA lock in __access_remote_vm for improved monitoring reliab=
ility
>
> https://lore.kernel.org/linux-mm/20260724222934.1463812-1-riel@surriel.co=
m/
>
> 2. copy_from/to_user doesn't support vma lock
>
> Maybe this can be addressed by the topic currently under
> discussion?
>
> mm: use VMA lock for kernel faults on user addresses
>
> https://lore.kernel.org/linux-mm/20260802074018.73887-1-baohua@kernel.org=
/
>
> 3. first PF before retry might have been mmap_lock:
>
> Maybe this can be addressed by `vma_start_read_unlocked()`, as we
> discussed here:
>
> mm: Unconditional per-VMA locks and cleanups
>
> https://lore.kernel.org/linux-mm/CAJuCfpEF6SjKhRW33AuboAuUbQz5zv+QKr2eD=
=3D52Qd_POL18Kg@mail.gmail.com/
>
> 4. The last one is the fork regression, which is unrelated to
> I/O under mmap_lock.
>
> - No approach yet. Perhaps Android could enforce some rules to
>   prevent apps from calling fork() in the future?

That would be quite hard, as you might know. We have to support
existing apps which might be using fork() and forcing developers to
change their apps is difficult and sometimes impossible (app is using
a 3rd party library that calls fork() and the library vendor does not
exist anymore).

>
> Thanks
> Barry

