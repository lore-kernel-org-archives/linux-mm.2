Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3389D3CCA7
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF4C6B0088; Wed, 14 Jan 2026 22:56:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394F46B0089; Wed, 14 Jan 2026 22:56:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276FB6B008A; Wed, 14 Jan 2026 22:56:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 151186B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:56:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB2E188CFE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:56:28 +0000 (UTC)
X-FDA: 84332836056.06.93926DC
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id CE8D7120002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:56:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UPS+OBrP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768449386; a=rsa-sha256;
	cv=none;
	b=N1LfbyFOYp6pGqnreFPWQsGjh3RaVVO7dMQJ4jqn2lyZrYNYZ8nDa2O3e9y/NzUiAefQSA
	gTzVSHXDzFYIwhL/0ykeamQVxR1243GAKggGuC6rY+ndd03uD+l06gCN8Snp+y/VTZsuKW
	oCyY2gumsOsgeCXQoCZr2WYHvxeZXUo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UPS+OBrP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768449386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8h4CNT/vCdwT2WHgzViB1V6HoWHqUEOSKi1RhGen4M=;
	b=YkRcGr2midX5yREfCKlGjfQAxUmY/9byEUqNXwa5p67s3Rp+JMnj3iIlfU5FguOrCCa44G
	urEK05ilg4OD08eVNRYU6gXN8UxuaINW0bfKnhvgJfEshoimUCnO3pFBeV3zdkGPFtO5lH
	QabScQ8H9ghdzZq1ZZwdW2ltc6v/oMs=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43277900fb4so683142f8f.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768449385; x=1769054185; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z8h4CNT/vCdwT2WHgzViB1V6HoWHqUEOSKi1RhGen4M=;
        b=UPS+OBrPm35m6F2Zv9zaphSmkYLFjpbPyxyDwzWQr2q0FPGDdupzR8uExHRXgATsgH
         p2+u/PaX3nVQYvnQosii4+JcMAKjiro+jAdZV1uzt1s4Ngmd2p+Cjz7EwepSmz+e0awD
         eMx14ZuxzbVv9bcNocAlj6LitHDefZogLzeysLCsb8evGJdkj+8dClw7FYDtM0HcBnGL
         UGOTxdeFdvotmOEdLCcdapB464i97dXUbrKSQVmNw/k62f04SVJIh5mgKdKEBXnmUcPc
         oNvAHvwHTTHZBrmCe71Kw/3YJ15O93pZ2zwbr2bz5AhBCxk1r+wxjDix/u5Nwg2Cu2Cm
         7DMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768449385; x=1769054185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z8h4CNT/vCdwT2WHgzViB1V6HoWHqUEOSKi1RhGen4M=;
        b=N5TyWOxeZAUdx38EvC3Dhn4AfTK05DjNMBhei3A6PP5ys4B6bC5dYsyCX8Bd5EtFnj
         6cbtgjOZQf0dgQRRp4NPEK3A3qO5gyOXNsRNUf4hgdT/rmq6PH7JOmcPi/500mRRrj+u
         5LhMFX6mt9vvXgucSdXWeQML46Eh9b7+ivvUP1iYQPdhFa0iH01p6zBnFWqXAIDbn0ZV
         zfZ9AUDruL+ArtZWh2Yu/5VTA6QEq0seILnToNqsyIEF9wgxStiuMjE2pYhBpNAXfpLz
         zxRINWmAA0fEgfAQqmFPnU1iBxQib3C5TXey3qxSiNHPrQ7taHTScfsTlOyAxHui/kst
         kcEQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8q63ySbOy69AHDQTIIB9aegprLWIu2y3mWjo09ctaa4nObx58WwLiOFwgEpCjxas98MqoYN3D0g==@kvack.org
X-Gm-Message-State: AOJu0Yz7T9vqaxHfKNTBts+QLvGeOfBayxn7MRIe5zjuQjHmQl32X9nK
	jNzvRbvSEX2IesFqtkyrhJ5Eyp/k+t/8Qxz8nVVNb0FpaWdHapPUHlDdDN9Awdm5rbM++S3L13g
	SCuFnVzFLd9WXrtJXrDnx3MZlbCp9cEI=
X-Gm-Gg: AY/fxX6qt1Y+qLsLJVtDE05KVCOog1Wmr6Ei8pIj7CUrh4h3jfpKkpHeOkaFf92eIi9
	Uxz9jI3FXI4Aq9XSwaeN5cgbY40fNpKIrIn2/UFJzVyNtOZWXTu9tJNqQBcLFWd1nogOClssa1f
	lSVScPdK5xROysy6kUBBlCvw1ryrRpGPwUf9llbmPJPGXAMnejtqtF3RWVVS/GiwA6/f5dL8CwB
	PaLkrXGMS7CvxshIEPcY0S/BIxJdRcYHcnnQt4JC+MWKWPJGNPTS6PFcscLgRbXS4gHdZ9AXTay
	rkpLcipapqas3Y9k3VxxARd8AAf7uA==
X-Received: by 2002:a05:6000:2f82:b0:431:1c7:f967 with SMTP id
 ffacd0b85a97d-434d7580e3cmr1957942f8f.17.1768449384919; Wed, 14 Jan 2026
 19:56:24 -0800 (PST)
MIME-Version: 1.0
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
 <20260113191516.31015-1-ryabinin.a.a@gmail.com>
In-Reply-To: <20260113191516.31015-1-ryabinin.a.a@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 15 Jan 2026 04:56:14 +0100
X-Gm-Features: AZwV_Qj2HFEg_msWenRDyDr9jlnYYzEBrAIjJPlBfTu53BTl1ZMgAQjnko_IfdI
Message-ID: <CA+fCnZe0RQOv8gppvs7PoH2r4QazWs+PJTpw+S-Krj6cx22qbA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/kasan: Fix KASAN poisoning in vrealloc()
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>, 
	Maciej Wieczor-Retman <m.wieczorretman@pm.me>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, joonki.min@samsung-slsi.corp-partner.google.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE8D7120002
X-Stat-Signature: uh1jik3qund3sy7ij5izjgtbxhd43cbw
X-Rspam-User: 
X-HE-Tag: 1768449386-227957
X-HE-Meta: U2FsdGVkX1+S6WE5B3NeNPhoffndP5W1deRFIFa65bcnneEXCFLiSPaZPx3PdBDnbg2IXOrIDNVl4+/a/sixiXWNuOwIMCpGDb8ATplDTs7zjdi28XWYUi8wNrGzTsQYthFRxAaAPfWZcbHWyDcwdjF9jZwtcPAd7Tllr1d/rKSJvzDQJ4gUEpAT8OFxwk5FHGB5/u7I4Dlob7z6zlUb13gcZv4rZXFHarzYLlHoMMpZMCXUEBPVEf5iOCsVXr+syFYcbnpo8dIjjqfg6JBCfOZRSJV9U2JdcrDDyNx019IoUvVD+7bm4xAKNaAFZSL5vEeiGq/M4w8O2fQQxRdeQDvYHcYQmQhOnBR7V0z5PvbEonx1S9CU6Y/ENvoPPHIeJhqEcR5IfUIzKbz7EeWei8Vov3WG2t0QJVoFdQbvw9b+6pD83vMrQDz8B3SkIPVXuhfbGtfbOzSqdIjmlalw9fpImdoPUPxQTvCH0AZsU4JnH45YG4hOuoIDqMqJhTBywfJzFxz9VuLcXhfVeKGOQAdeAlA6/y9Dvlq6s50vlEFLLmkC7o6jQTOrJGmHjk9+qUl2dMeMqaJoywEGObg/90Yrip4YixOlcy/m9dtSHokSMw+g98LJckQHPFsIGLFir017ohBM3Ti6OghfNCeNT3fL5wCc24+olce8wKgb7Kq09w2s2wKuH0aY6wZq9nWyESkzr6coK6x/ui4nA88z+PFuNgS1TE1ZyIjdk/VIRTBfL/KE7E1LwnkDmxiUPdoNN5aVvwZvEdxYfVeL8jHJCO06q53anapw2k7Og7PaHDiDbmlvGg763a6s0+nUaPc0EXYRZCcMw2XeLp1AReMLZanQQ6Hbs5yFptLu7/85nduxKEjWZpVmtepkolEMwntGDor+c5YssYaea07j9luEjCudewZMa9mogy65HPfyTDEsGLRSqCRyr965bzssFDlbCbAjyyntkI+WhTwPryh
 3H0gmasJ
 2smhrFEwK8eZXeRgHEt4JliyeHtaHLO3qYTYedL2x3T6r9JIX59wG4rsjnhc6H0fhWXms4RPrZ0ypRL5UusEDWXOAVBBileYk60Bwe+qGBC5NPzvSj/6b0idOoSUDrGIaT6GKFZbqr1VrM/PLHu6gFqlwgSGxZa/f5y3NTkyGjLk4m9lHvWTQJ8crKtWh/dYDpyty5ItMKWzFnqDeQ+Y3mCt/CuojQ740iIYZnk22VXxiXkvLafO+bbUVeNI5meYmLGPdO66yKGWrGSXUHxJY+B9NQT4oMKsvIS8HK/QRE2WLaHh4DUHDQzQSN0TDlnWK9U47eSjKUKUzQcF6rE9xdIJ20RLL1bwHSsj6v8L3YEhuAQ8rrsxcvOtVuCs4EV6x3/S0rcDKykN2zdENE9mITFo/4TUrQomT/bZ4mGJxMiogNX1iALMfC0fCwL/ilAXbAe7n708IfBLhTdgqkdjRZ5kvINcQlZcK0rMGffjznF4mnPp2M+ibosvqXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 8:16=E2=80=AFPM Andrey Ryabinin <ryabinin.a.a@gmail=
.com> wrote:
>
> A KASAN warning can be triggered when vrealloc() changes the requested
> size to a value that is not aligned to KASAN_GRANULE_SIZE.
>
>     ------------[ cut here ]------------
>     WARNING: CPU: 2 PID: 1 at mm/kasan/shadow.c:174 kasan_unpoison+0x40/0=
x48
>     ...
>     pc : kasan_unpoison+0x40/0x48
>     lr : __kasan_unpoison_vmalloc+0x40/0x68
>     Call trace:
>      kasan_unpoison+0x40/0x48 (P)
>      vrealloc_node_align_noprof+0x200/0x320
>      bpf_patch_insn_data+0x90/0x2f0
>      convert_ctx_accesses+0x8c0/0x1158
>      bpf_check+0x1488/0x1900
>      bpf_prog_load+0xd20/0x1258
>      __sys_bpf+0x96c/0xdf0
>      __arm64_sys_bpf+0x50/0xa0
>      invoke_syscall+0x90/0x160
>
> Introduce a dedicated kasan_vrealloc() helper that centralizes
> KASAN handling for vmalloc reallocations. The helper accounts for KASAN
> granule alignment when growing or shrinking an allocation and ensures
> that partial granules are handled correctly.
>
> Use this helper from vrealloc_node_align_noprof() to fix poisoning
> logic.
>
> Reported-by: Maciej =C5=BBenczykowski <maze@google.com>
> Reported-by: <joonki.min@samsung-slsi.corp-partner.google.com>
> Closes: https://lkml.kernel.org/r/CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm=
08oLO3odYFrA@mail.gmail.com
> Fixes: d699440f58ce ("mm: fix vrealloc()'s KASAN poisoning logic")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> ---
>  include/linux/kasan.h |  6 ++++++
>  mm/kasan/shadow.c     | 24 ++++++++++++++++++++++++
>  mm/vmalloc.c          |  7 ++-----
>  3 files changed, 32 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 9c6ac4b62eb9..ff27712dd3c8 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -641,6 +641,9 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, int=
 nr_vms,
>                 __kasan_unpoison_vmap_areas(vms, nr_vms, flags);
>  }
>
> +void kasan_vrealloc(const void *start, unsigned long old_size,
> +               unsigned long new_size);
> +
>  #else /* CONFIG_KASAN_VMALLOC */
>
>  static inline void kasan_populate_early_vm_area_shadow(void *start,
> @@ -670,6 +673,9 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, int=
 nr_vms,
>                           kasan_vmalloc_flags_t flags)
>  { }
>
> +static inline void kasan_vrealloc(const void *start, unsigned long old_s=
ize,
> +                               unsigned long new_size) { }
> +
>  #endif /* CONFIG_KASAN_VMALLOC */
>
>  #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && =
\
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index 32fbdf759ea2..e9b6b2d8e651 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -651,6 +651,30 @@ void __kasan_poison_vmalloc(const void *start, unsig=
ned long size)
>         kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
>  }
>
> +void kasan_vrealloc(const void *addr, unsigned long old_size,
> +               unsigned long new_size)
> +{
> +       if (!kasan_enabled())
> +               return;

Please move this check to include/linux/kasan.h and add
__kasan_vrealloc, similar to other hooks.

Otherwise, these kasan_enabled() checks eventually start creeping into
lower-level KASAN functions, and this makes the logic hard to follow.
We recently cleaned up most of these checks.

> +
> +       if (new_size < old_size) {
> +               kasan_poison_last_granule(addr, new_size);
> +
> +               new_size =3D round_up(new_size, KASAN_GRANULE_SIZE);
> +               old_size =3D round_up(old_size, KASAN_GRANULE_SIZE);
> +               if (new_size < old_size)
> +                       __kasan_poison_vmalloc(addr + new_size,
> +                                       old_size - new_size);
> +       } else if (new_size > old_size) {
> +               old_size =3D round_down(old_size, KASAN_GRANULE_SIZE);
> +               __kasan_unpoison_vmalloc(addr + old_size,
> +                                       new_size - old_size,
> +                                       KASAN_VMALLOC_PROT_NORMAL |
> +                                       KASAN_VMALLOC_VM_ALLOC |
> +                                       KASAN_VMALLOC_KEEP_TAG);
> +       }
> +}
> +
>  #else /* CONFIG_KASAN_VMALLOC */
>
>  int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 41dd01e8430c..2536d34df058 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4322,7 +4322,7 @@ void *vrealloc_node_align_noprof(const void *p, siz=
e_t size, unsigned long align
>                 if (want_init_on_free() || want_init_on_alloc(flags))
>                         memset((void *)p + size, 0, old_size - size);
>                 vm->requested_size =3D size;
> -               kasan_poison_vmalloc(p + size, old_size - size);
> +               kasan_vrealloc(p, old_size, size);
>                 return (void *)p;
>         }
>
> @@ -4330,16 +4330,13 @@ void *vrealloc_node_align_noprof(const void *p, s=
ize_t size, unsigned long align
>          * We already have the bytes available in the allocation; use the=
m.
>          */
>         if (size <=3D alloced_size) {
> -               kasan_unpoison_vmalloc(p + old_size, size - old_size,
> -                                      KASAN_VMALLOC_PROT_NORMAL |
> -                                      KASAN_VMALLOC_VM_ALLOC |
> -                                      KASAN_VMALLOC_KEEP_TAG);
>                 /*
>                  * No need to zero memory here, as unused memory will hav=
e
>                  * already been zeroed at initial allocation time or duri=
ng
>                  * realloc shrink time.
>                  */
>                 vm->requested_size =3D size;
> +               kasan_vrealloc(p, old_size, size);
>                 return (void *)p;
>         }
>
> --
> 2.52.0
>

With the change mentioned above:

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

Thank you!

