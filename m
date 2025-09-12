Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7439FCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 16:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 930C08E0003; Fri, 12 Sep 2025 12:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2748E0002; Fri, 12 Sep 2025 12:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0728E0003; Fri, 12 Sep 2025 12:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 696858E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:39:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A23687240
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:39:26 +0000 (UTC)
X-FDA: 83881158732.20.1E0266F
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 13EF614000B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:39:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MinaiU58;
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757695164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0xh0UvEoHi2O7LGyNOcCCIeHeMOwroJteEEcZ04c6w=;
	b=p+LVpen3gFTDw6qEW+/MKZQ7lr1cUIHoanF40RS61/zNsWScTk/TUXbdUXyAIDmyUdOXCR
	ECwvMClyeqwVRi6Tms3LunTk8FrGA9XU3LFsR2XN97zK3WZnXikdta1tQiy3a0SaA1lT7P
	PD/geNtSybDCnqdAiSq6fQgUkaJ1E04=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MinaiU58;
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757695164; a=rsa-sha256;
	cv=none;
	b=AX4EaAKQkDH8k7ePvFoZpydPgYITmG9XjV6comZSKJFsQGABPx5D+JTTH5QQE764PuURmI
	afFj7WV5VkmbivgTJYebS0SZdvo286vX0CgOGKxHeVAhJGvfaYhrZpYoEswIesD5mT07zp
	0aVwwQ091eR9mu+/9T7DARtFhgSbeC0=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3e249a4d605so2327908f8f.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757695162; x=1758299962; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+0xh0UvEoHi2O7LGyNOcCCIeHeMOwroJteEEcZ04c6w=;
        b=MinaiU58bUOuf8zPx44h7Dr45tiqYJqD8QZS2tl3KwC/otd2fxl6XSTRSXEYtuPegq
         QWATvpsxZq7bubVun/6UDl4vG7Z2nEf5ard6c3jM1LDqY+lCw0Y/9q4QT4jkzHGOM2TB
         fmcF102HwZYuOnR2YY3bY9PF72Dnj77Yi101SvclrihY0ozliPZgsEUyiQ4TrgOtA+HY
         plnPXLY0c5lImokxcZPBDMidMVUYso5ccmxND/TF8vDiDsHg94cbicBoI89RxW5vpRv6
         MCIYyZxDTdcfJCrqTf5VRH8dmDOaoAnWx9SnTx08FckQfntaqhTvTDdRER6U8EV0PpAY
         LVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757695162; x=1758299962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+0xh0UvEoHi2O7LGyNOcCCIeHeMOwroJteEEcZ04c6w=;
        b=DnPi33d24IDDSpOilV5YurhejyX/pYC21e00oAuTnEf89KGEF8VRdiEdzmI5md3Sl9
         vMN1rIePxYg1jdzKE6YgU5qkZfsyMwJ3oSI8LGQ6eaq/EcCyQhtpouMJX9IgMN53S9JS
         zk2ggPk97ObSQimdmwJ3LMgrdUS1xXGAIhDhwMoVvjMIz3cbCmLj/Jefn4RhfCHf1nfi
         zcKCQGIJHj0nxbZzWcwnmIMoHfXcHGpi2mFxpdouhtJ2+zPXG7HX+P5m/aly9jVlkjP8
         SJcPJkG4lQDGbFrEdhWE1ZTQxvocouS07b4vNQ7KNalKAdzSeoZrSIqgLGUncharh6B3
         QyVA==
X-Forwarded-Encrypted: i=1; AJvYcCXeaR7feudAxdsi96RORs/Myl2TmAaxRWOHFzdBFQNsw0m8OdZ3dlgIeF4EY0H2jwIKQIBpB29/Fg==@kvack.org
X-Gm-Message-State: AOJu0Yxktm+CQygqlmHQLnHDR8AbAnu5f7wutpjXzTde5VH8L0P30WD/
	lmFelZzFTxYLtAEM8wLdm02+ynP0F890pvH7bya0ypHX/9nb0MBayNpOcO4t7rZ2P7vcuTT8+yR
	VQEHLH0Od/yHeAOxx4MuNgKPPB1d3U5dfT/Ns
X-Gm-Gg: ASbGncvfIipYC1nGhmSLeo0tnIjtnisx2JCsD0Qt2K9gB1KLrgwBAB5PVn6SMAUkxxZ
	9NgPKlW56mAXRfKCGN0eoz7piV0wez0PmywwpaZyXV4FWg1c8Q0qZMGHMT0xkMsJy4O9RByyOZv
	QFwH7ZsPsjUp4ibNL6vL9AouC511H8Df1JueM77E5NPYtiebAxorAIWFSBox6gcaa0y39pn6EAR
	pBrBqwbmjJkiQPVhduyl+xUMUdH8T8YnkUGQ3NDXr94TRQ=
X-Google-Smtp-Source: AGHT+IHV1PvlYuf+XFcfwDj68QaEKHStgMJBQQVVA0MAE80vskWQUTNtIwoaXfzpqlGfo4C7abh1Y2609Ap85Dz11Is=
X-Received: by 2002:a05:6000:178e:b0:3e5:25c2:9637 with SMTP id
 ffacd0b85a97d-3e7657986b6mr3795843f8f.17.1757695162195; Fri, 12 Sep 2025
 09:39:22 -0700 (PDT)
MIME-Version: 1.0
References: <202509121822.aOV6H1ts-lkp@intel.com> <8fe99133-3322-4e39-9b58-80df547b8d1f@suse.cz>
In-Reply-To: <8fe99133-3322-4e39-9b58-80df547b8d1f@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 12 Sep 2025 09:39:11 -0700
X-Gm-Features: AS18NWC-ioE-NKfTIE_NGzGThSkiI0Gn4u0FeGkHnHauTm4TCVRXnQ1WFKRGfSE
Message-ID: <CAADnVQJWXk+Zzsf_oVTaJkpm4nO3iq34bGcUDQRarOVSX+tLbA@mail.gmail.com>
Subject: Re: [vbabka-slab:slab/for-6.18/kmalloc_nolock 14/14]
 mm/slub.c:3866:2: warning: variable 'flags' is used uninitialized whenever
 '&&' condition is false
To: Vlastimil Babka <vbabka@suse.cz>
Cc: kernel test robot <lkp@intel.com>, Alexei Starovoitov <ast@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, 
	clang-built-linux <llvm@lists.linux.dev>, oe-kbuild-all@lists.linux.dev, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 13EF614000B
X-Rspamd-Server: rspam05
X-Stat-Signature: 5behy4ex6e7dibftj85axqt99dipcm5t
X-Rspam-User: 
X-HE-Tag: 1757695163-689784
X-HE-Meta: U2FsdGVkX18iHlbVI59tR70Ntcp7Mf5M0av+Yg9gaCsnaHd0ubcCvkKl2R8qmglkVDybgrrZBE/8LOuqxv+GuMKFTN0BWRUHtPBKGvBnZZPBOhqkyp6zZdZgmiJZU2WtgC8mAcu2IKGT33uCZ3ejkGzX7hWcVxyDp7br4mfR/z9U9N6nXdTWhsgo2oayJHkC5of1b2MyNmD9WyGC5mCNKzsuCGgV1k5vI8NapwBq89vA6iDirhlA1/Kv0kQ7kFgE34U4Bmh8SblW8Ks6w0nosaFu2vxKkshILKf7EA0CFmZLZtSUmnSW7F7FEHKDLxVwL0eF89VytJE6ZO0zPMu6bGO5JBkOuE3wqLXZbvjOsMaUDgBgA6Kz1bkpzPAM31eaVqwRpPYiB0hnGNs1lVqQX4Wl0/X1zDU4JmZVSSYCQ74Pbj8lMnAV54Xd5HVNlKivR5oq+zfcdhRKc+/OcOAhfA/Wy7cMag+b6sxn1Bg+NTLmNY/wqKwYdlIdyTec1757yHEbVnAOppoJW7PrF7aXihHhbDSSbqmGXygH1rK4puUeopy79uNcWUyON7xr/vEPM/JL7d9LMqns4YPadc1wbbjoNUEZnEUW5tsIiPagEcCiEDG26uiyPMejtJZ8ppAqtPAyxMQowAnv6u7oqgD8lg7EpUhC1YhuwRC/iP50GPKFkhhQc9rEVXnt4CSDk/Sen3DyNU2pq3z6kdB5Lg4n2k99aJxz4tn9kQ+vBBzYgJW5oZRyStug7j6ZlSCTBsKUCKQtVEmc5HhkFl+6zgtb7jCF5+kZVg7lHpQWddXhEWVBn9ktBNERsSTxXQ4DhkMu9jEz3IH1/Ts6DxhZWMRwiqIjO/RM4bE9vJWRAAnsm2/DcsaaJkE4paj966ZlV42F3iMqDsjBWUua4NW/pD5hqXgGCfbF2IJfyOTms6hz0GjxRaSMnchP2YJDz5gKpeQqwaJfU1KB+oETFnEQ6BO
 Vkbwp1Ly
 NQHcn2c/UdwtrzDksZm16ipHLsBZtRvj4jEut32JTVY3jIEpJzMRP/MwbOtrbcRH+A6qJq3ZB+x54pp5Aodrj4ijbjO7U+pqlbkj6Q1M+c5hNEVqkoWez6Q4SNGTL1gKin25/nltafYbdlq+D4BC7ZmEKIUbpZKBJRmHG5fjzADeL39PY23mpC/tHu6rkoMf1dBeiU4SRihUnTlW486XOlbGheZM6tZbsiPQwvTz8cYZU12mvjvmnye45OhEcfiDlV43LUiQNoqZ8Pf48/1g1VmJ7eM44OUMXNgTL/sTleoFxvKNdy3vhkGG+GoZ4HxQRnbvytykBn85WQX3/uj/j7OO/WoKCYIoUKi9DkqWKZtZ99+NLmOAiO/6qUQ14p46/D7HkBuaVBBwRg8jrXFjp8qxBTCZCGcHJWGw8fsRA75qUoNSqFAc4qmiBOuOdYHKIIZz5/QaR+aeqn7JS1CNi+PWkFhzrXBuDloUbX+40B6YsA5knK8OOV+n0O30V5AS4i25OxjEwH4Fqsjw6g/zt6A9rWj/I/qpMId1esN7Q8RjuHS9Fjyolfo4PIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 6:23=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 9/12/25 12:25, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git=
 slab/for-6.18/kmalloc_nolock
> > head:   8014922e0e72dde7684abebeab3404720401679f
> > commit: 8014922e0e72dde7684abebeab3404720401679f [14/14] slab: Introduc=
e kmalloc_nolock() and kfree_nolock().
> > config: x86_64-buildonly-randconfig-004-20250912 (https://download.01.o=
rg/0day-ci/archive/20250912/202509121822.aOV6H1ts-lkp@intel.com/config)
> > compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87=
f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20250912/202509121822.aOV6H1ts-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202509121822.aOV6H1ts-l=
kp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> >>> mm/slub.c:3866:2: warning: variable 'flags' is used uninitialized whe=
never '&&' condition is false [-Wsometimes-uninitialized]
> >     3866 |         local_lock_cpu_slab(s, flags);
> >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    mm/slub.c:3776:2: note: expanded from macro 'local_lock_cpu_slab'
> >     3776 |         lockdep_assert(local_trylock_irqsave(&(s)->cpu_slab-=
>lock, flags))
> >          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~
> >    include/linux/lockdep.h:279:15: note: expanded from macro 'lockdep_a=
ssert'
> >      279 |         do { WARN_ON(debug_locks && !(cond)); } while (0)
> >          |                      ^~~~~~~~~~~
> >    include/asm-generic/bug.h:171:25: note: expanded from macro 'WARN_ON=
'
> >      171 |         int __ret_warn_on =3D !!(condition);                =
              \
> >          |                                ^~~~~~~~~
> >    mm/slub.c:3891:27: note: uninitialized use occurs here
> >     3891 |         local_unlock_cpu_slab(s, flags);
> >          |                                  ^~~~~
> >    mm/slub.c:3780:48: note: expanded from macro 'local_unlock_cpu_slab'
> >     3780 |         local_unlock_irqrestore(&(s)->cpu_slab->lock, flags)
> >          |                                                       ^~~~~
> >    include/linux/local_lock.h:52:48: note: expanded from macro 'local_u=
nlock_irqrestore'
> >       52 |         __local_unlock_irqrestore(this_cpu_ptr(lock), flags)
> >          |                                                       ^~~~~
> >    include/linux/local_lock_internal.h:202:21: note: expanded from macr=
o '__local_unlock_irqrestore'
> >      202 |                 local_irq_restore(flags);                   =
    \
> >          |                                   ^~~~~
> >    include/linux/irqflags.h:240:61: note: expanded from macro 'local_ir=
q_restore'
> >      240 | #define local_irq_restore(flags) do { raw_local_irq_restore(=
flags); } while (0)
> >          |                                                             =
^~~~~
> >    include/linux/irqflags.h:179:26: note: expanded from macro 'raw_loca=
l_irq_restore'
> >      179 |                 arch_local_irq_restore(flags);          \
> >          |                                        ^~~~~
> >    mm/slub.c:3866:2: note: remove the '&&' if its condition is always t=
rue
> >     3866 |         local_lock_cpu_slab(s, flags);
> >          |         ^
> >    mm/slub.c:3776:2: note: expanded from macro 'local_lock_cpu_slab'
> >     3776 |         lockdep_assert(local_trylock_irqsave(&(s)->cpu_slab-=
>lock, flags))
> >          |         ^
> >    include/linux/lockdep.h:279:15: note: expanded from macro 'lockdep_a=
ssert'
> >      279 |         do { WARN_ON(debug_locks && !(cond)); } while (0)
> >          |                      ^
> >    mm/slub.c:3863:21: note: initialize the variable 'flags' to silence =
this warning
> >     3863 |         unsigned long flags;
> >          |                            ^
> >          |                             =3D 0
> >    1 warning generated.
> >
> >
> > vim +3866 mm/slub.c
>
> >   3852
> >   3853        /*
> >   3854         * Put a slab into a partial slab slot if available.
> >   3855         *
> >   3856         * If we did not find a slot then simply move all the par=
tials to the
> >   3857         * per node partial list.
> >   3858         */
> >   3859        static void put_cpu_partial(struct kmem_cache *s, struct =
slab *slab, int drain)
> >   3860        {
> >   3861                struct slab *oldslab;
> >   3862                struct slab *slab_to_put =3D NULL;
> >   3863                unsigned long flags;
> >   3864                int slabs =3D 0;
> >   3865
> >> 3866         local_lock_cpu_slab(s, flags);
>
> I guess this?
>
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3772,8 +3772,11 @@ static void deactivate_slab(struct kmem_cache *s, =
struct slab *slab,
>  #define local_lock_cpu_slab(s, flags)  \
>         local_lock_irqsave(&(s)->cpu_slab->lock, flags)
>  #else
> -#define local_lock_cpu_slab(s, flags)  \
> -       lockdep_assert(local_trylock_irqsave(&(s)->cpu_slab->lock, flags)=
)
> +#define gg(s, flags)                                         \
> +       do {                                                             =
      \
> +               bool __l =3D local_trylock_irqsave(&(s)->cpu_slab->lock, =
flags); \
> +               lockdep_assert(__l);

That works, but would raise questions for anyone looking at
these two lines as-is, since it's an implementation
detail of lockdep_assert() and combination of .config flags.

what clang warning suggested is imo cleaner:

diff --git a/mm/slub.c b/mm/slub.c
index 4079abb5d0e1..a6b50cd1d95f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3865,7 +3865,7 @@ static void put_cpu_partial(struct kmem_cache
*s, struct slab *slab, int drain)
 {
        struct slab *oldslab;
        struct slab *slab_to_put =3D NULL;
-       unsigned long flags;
+       unsigned long flags =3D 0;
        int slabs =3D 0;

Could you fold one of them in?

