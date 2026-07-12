Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A4FBC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 21:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7716B0005; Sun, 12 Jul 2026 17:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357FA6B0088; Sun, 12 Jul 2026 17:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21FE36B008A; Sun, 12 Jul 2026 17:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E62DB6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:23:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 118481C4275
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:23:12 +0000 (UTC)
X-FDA: 84981400224.25.C149868
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id DFB09100002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:23:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jq9TJGEV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783891388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0possHhbYWMvozQHF1jT+xcy8ymwyLPGUVqKNvmfdh8=;
	b=4t3ZsiimP64dQL+evOfJUEQWKob71SL5zMXRdyMh9RDucyZ2wk7rnKtJI3cNnn7nXkVAKu
	lMaUrZZwNTN6XKYAtMp0HzweeXRk5X8F/fiPbq7+BiZEbOlaIdgxsSpPvXCi+c2vRbRS17
	Cfrmf9JbAxxH3s2AJXM1mpdV3wG7il8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jq9TJGEV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783891388;
	b=VRTf3u72hjC30JDqvJVeDvsCfreM31GanS424GlrS/ZrLn3Y4vd5XekHSrh8MJfTbdyzxb
	3HMtnjdBub+VCC+0QQCxBMOeXvV58nmVCVdPkzDnmNwZiXzdpDMyOVH+oUljx3br46YBBQ
	aJGDm7nBA1RbI3fJ6401qJMvSspg4u8=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4758bd3731bso1667829f8f.0
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 14:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783891387; x=1784496187; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0possHhbYWMvozQHF1jT+xcy8ymwyLPGUVqKNvmfdh8=;
        b=jq9TJGEV66awOJL2OIOyiWMGBvUis3Ls7forefvLReq4KqIXJuRG3Cdfjr932lzPEB
         7yaNzl6uI6Ax6QeaJKIBakiDdD7lPGtiJAyKDTha3u9yEMbxn2MpasRzkEEX1vOozrv4
         7fk9lDhSQ27inurYRRz8ypWATUxFoHtw+6MRWk+K+haVirNVODBCvwYX8hE00j+WqrIY
         zR3p4nrAYfIXZXyCkzYZPTz/SDH2yK/yJVBBkFu5Iu93kDpU1ZYjvAu9QhPhSMf/1G0c
         fW3okaM/Fbvf9eqfI8yg2qiIRUnNAobShcEzB6tFeWxcwKkIibmjcKZYDSLhixncPl2y
         uO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783891387; x=1784496187;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0possHhbYWMvozQHF1jT+xcy8ymwyLPGUVqKNvmfdh8=;
        b=Ar4w8FL3zKlo5WP7AjdhF0ILAM//wB6NI+wTUGsDX10naziBcNHgnWW+4A6hz91M18
         j64rXDPfpi7McS+kgUB4MlY7qXGywCtOQxS9PPD5RzBj7Kud/9duXWgFFYC5hZACxTSd
         tEok4Q5BdR2pfPJhu5d0ze9UO0LuLRhXiMnsbKv10QbWZOxRLDk/OF0Ab+UnycRcQGC9
         0VXVdk2WZQQEslp3mQx4w/4vC2JLPqXz/d5utvs2dIO66p2suws5HkCOv2LhowXipA87
         NWlbPJ/uiiZm4aKkGRyT3vK4KmUsBUWzCgX7zO8iEGCPBPpv3U0n+2XgDZozMi/at56c
         zyZA==
X-Forwarded-Encrypted: i=1; AHgh+RrA02m4U72GR5UDuqnhZKJYnowvU2BBFXL3btFQ2EIzFc+aMLK/eth0nNj7hfcfPkhJWOP2oPU/lg==@kvack.org
X-Gm-Message-State: AOJu0YzHCUwp4CUjM6lY9ux9fpeMT3KBFZcsNs6keXCBPbIcA0/JevPd
	PBG7rm8rjZJG0/W4AtrpRYeWMnQdh3dYRpM5e3dt0OaiGKc0MrKlJ+un
X-Gm-Gg: AfdE7cksZ0Oon6RHkb5ttKeMgOVgwarZTrAyTxvunbp95TydGMFbIABppvS2ut92DCB
	lycI0waGOzHpbn4MDKUtfzXRqpOmCgIPD2I0QL1WDF38a1/Ws9u6y5nzDOzrrr45cVitAzFRO5+
	uc+M4+LhhAu+aVETrowrR0zEPLIh6hnPzmqBIJYemyb5M5AH5t6F4MEefwblTteurZr6XuvtOCV
	FZI0Ojnq8BA72nP/JAvVlwpyEWCabdQWIic2WdxtWqUgqgnDBB5O6JtuvDoMUObbI6fUjTx1woN
	ZhAvPab0iqnp/3N0s0XAiUBlQArBYfLv4vldC33zhrhvXjWFvQQ9Ei7s9vUIW8JdOIwHXETpEn8
	VTbTKoyP+9LSPpNzUvS5y1KSitDTZR6TQx3p0J+abFy39F3n1LhmUZkYwjRUSsr1LxfmF4NyxZf
	SJT/soCEjnPYNQyuY6QpvqqA==
X-Received: by 2002:a05:6000:22ca:b0:47e:4379:a4ed with SMTP id ffacd0b85a97d-47f2dcd9e36mr7905011f8f.30.1783891387132;
        Sun, 12 Jul 2026 14:23:07 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960634sm80813963f8f.26.2026.07.12.14.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 14:23:06 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 1/4] Introducing pw_lock() and per-cpu queue & flush work
Date: Sun, 12 Jul 2026 18:23:04 -0300
Message-ID: <alQFuIPKRjQ_vjmg@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <fec6554d-3639-4c27-9a14-3d3914c51588@infradead.org>
References: <20260519012754.240804-1-leobras.c@gmail.com> <20260519012754.240804-2-leobras.c@gmail.com> <fec6554d-3639-4c27-9a14-3d3914c51588@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DFB09100002
X-Stat-Signature: 7yfyp65wowygkf6h3q3zp6pk9d5xrdzc
X-Rspam-User: 
X-HE-Tag: 1783891388-854217
X-HE-Meta: U2FsdGVkX1+b+TaK+EualeIiptTDSI96nxOlk4OijPwozaSw1max48h4sUTgcgpy9KH3C1/dPeT7tnKvM/ANEMAyGFlr7tU06eyeKLKRXNa+KUNpI0s5ci3R+A69bDn5TSgDkJ5Cncy/HR0QD8Ov00wqDDRdFZliS5TZopgGEt6w9fDYsjgqXPKhbNhc5omYacT/tvIBv6M3FCRG4tcQluf+ee5naHb5cQdB6a6/vo6hpKcLzebaFxkHLI5W05XkwaqBIuoGGmLZB/ctOTh/IKyCF+nhL7h+YFJv8THt6Gq4IEihloNnCKhfZaGx3SCxpKDAsW1Mp5JggamCEjpcXBXxFbspoJl/4UOfMJoJKWJ19KnrJitXpVilv6mbjNvuIl0xl9nCPCW/DDdq1OlWaXlqYTOJJzz3PFCROMIHjVEL2rnRNZoPfHep5iiZb9sLPx06yZzMvtwCh8kCShRLNQifY+HZdbsYVls48f6R8dKHRtrxrnJG2tO7Lgx6xE8+nNB2keN8AUPCUdDKyfd4WvUn76weQR+sarNgB8/WEJjCFYTM4kO22jpuj9F/sKA9VX4ZBeFZ3+VZKZODfx008FBBjsZwmdZcpQxqU4IvW4smDdjVjopiHz6f/4hifcaj9FtIbUcYN8iFn6jrmsNH6Dt9DXlis08TdyFrOQ5NwmXG/pPi4/xT2RbnJSVI7ve1p5NqSgvNMJBGETn/5vfL9KFEbzEB9NmOi+jI1qHEfUI8XgcXGcPYJeYvcRaYZoHrUKfHDyGOl8cD5KaN2vLnPtCIRL6yQfSs0uXOtbJBXLphmd+uGWyiWrMC3QalWGnnuIn3G8GMnOdmCTvl4UEu4SrgBraV9NX4S635SaQRTdP3abbRA9PAIoMOoa3QM2ykGX5179MKlP/m12SV4GbGiegiaWMw4nNb3MvgHiTS2u7JaAbFHaW0rnwbL97FXIfaMDpQ1VL9eqYF1ftPtKZ
 FqTsfHm2
 t+EwdVLGo9Pn3AuE3WWuncBuWOIRZkoD3zHWuxf0sKJy4DELReozisz2WPreL7h3HJmspFJia5dEWetMHAfz5VYGrmpOD7Xgy5t8D17zVXJSbDiJIJiradEnVSJaoGOgcPCODeBuGGJvHWFeCN+wWdzw6WExQZw31TuudElhknyEz337ZA64fPBLnkiW9LLIF2drFvDkT9VApK0fp/Jl4HqCP3ZdfngaIELvTq5qy/LAcr5Kj/9rOaoeJeNEObNsD4P+QvWvCgub6l3i3+NJcDje7KS5tKb/I9jaWHE6Fe8UCJwqEmKI1WsavuoEAnRucl56oeBopsi7aP1oOO5PUIGTTp2CMaFogXoLQK/PqdM7SSHRAtW+8wT9pctlBt/eTe1gZDW1jH0uygj0NAA7TBJQS11ATZQ984Ds8F2jpAOYL4d6xZ/VDP7/hedvxXrnOXMfDRS99x8uCAdqxNe44etmnwc3q3BBaUwHlbq9z8uqrEqL+YQYIlOIspjNOZyTAACwXYupkICySZSdr0aztw4NnBy5rmBLzX1Cj2ux6n+wRzLY4XTM0VNdfsxhSrz5jS2r2vWpJ9PmQTorrHztjf0M/U7NAsPRBazRKh1ET/MxyoBniKyJn9Y9QcqHSkIcohFMXBPJkg0oUToRCCaAo1wyJiS9LpasjGDsgGPtX4l3QkFPdpa+dFClzP410SAmSR+p5Q3zPnJVm8VFvZ99Upnv3PipQxLuCLlzfauvbRFuxJSbwakpbZ3ImDyGlmB+wWpxE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 03:06:30PM -0700, Randy Dunlap wrote:
> 
> 
> On 5/18/26 6:27 PM, Leonardo Bras wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index c2c6d79275c6..7102031207c9 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -21775,20 +21775,27 @@ QORIQ DPAA2 FSL-MC BUS DRIVER
> >  M:	Ioana Ciornei <ioana.ciornei@nxp.com>
> >  L:	linuxppc-dev@lists.ozlabs.org
> >  L:	linux-kernel@vger.kernel.org
> >  S:	Maintained
> >  F:	Documentation/ABI/stable/sysfs-bus-fsl-mc
> >  F:	Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
> >  F:	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst
> >  F:	drivers/bus/fsl-mc/
> >  F:	include/uapi/linux/fsl_mc.h
> >  
> > +PW Locks
> > +M:	Leonardo Bras <leobras.c@gmail.com>
> > +S:	Supported
> > +F:	Documentation/locking/pwlocks.rst
> > +F:	include/linux/pwlocks.h
> > +F:	kernel/pwlocks.c
> 
> MAINTAINERS entries should be in alphabetical order: PW is not in the
> middle of the Q entries.

Hi Randy, thank you for reviewing!

Argh, sorry, it used to be called QPW. I renamed and forgot to reorder.

> 
> > +
> >  QT1010 MEDIA DRIVER
> >  L:	linux-media@vger.kernel.org
> >  S:	Orphan
> >  W:	https://linuxtv.org
> >  Q:	http://patchwork.linuxtv.org/project/linux-media/list/
> >  F:	drivers/media/tuners/qt1010*
> >  
> >  QUALCOMM ATH12K WIRELESS DRIVER
> >  M:	Jeff Johnson <jjohnson@kernel.org>
> >  L:	linux-wireless@vger.kernel.org
> 
> 
> > diff --git a/Documentation/locking/pwlocks.rst b/Documentation/locking/pwlocks.rst
> > new file mode 100644
> > index 000000000000..09f4a5417bc1
> > --- /dev/null
> > +++ b/Documentation/locking/pwlocks.rst
> > @@ -0,0 +1,76 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +=========
> > +PW (Per-CPU Work) locks
> > +=========
> 
> Overline and underline should be at least as long as the heading text.
>

Noted!
 
> > +
> > +Some places in the kernel implement a parallel programming strategy
> > +consisting on local_locks() for most of the work, and some rare remote
> > +operations are scheduled on target cpu. This keeps cache bouncing low since
> 
>                             on a target CPU.

Right

> 
> > +cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> > +kernels, even though the very few remote operations will be expensive due
> > +to scheduling overhead.
> > +
> > +On the other hand, for RT workloads this can represent a problem:
> > +scheduling work on remote cpu that are executing low latency tasks
> 
>                              CPUs

Will fix


> 
> > +is undesired and can introduce unexpected deadline misses.
> 
>       undesirable
> ?

Yes

> 
> > +
> > +PW locks help to convert sites that use local_locks (for cpu local operations)
> > +and queue_work_on (for queueing work remotely, to be executed
> > +locally on the owner cpu of the lock) to a spinlocks.
> 
>                                          to spinlocks.
> 

Right

> > +
> > +The lock is declared pw_lock_t type.
> > +The lock is initialized with pw_lock_init.
> > +The lock is locked with pw_lock (takes a lock and cpu as a parameter).
> > +The lock is unlocked with pw_unlock (takes a lock and cpu as a parameter).
> > +
> > +The pw_lock_irqsave function disables interrupts and saves current interrupt state,
> > +cpu as a parameter.
> > +
> > +For trylock variant, there is the pw_trylock_t type, initialized with
> > +pw_trylock_init. Then the corresponding pw_trylock and pw_trylock_irqsave.
> > +
> > +work_struct should be replaced by pw_struct, which contains a cpu parameter
> > +(owner cpu of the lock), initialized by INIT_PW.
> > +
> > +The queue work related functions (analogous to queue_work_on and flush_work) are:
> > +pw_queue_on and pw_flush.
> > +
> > +The behaviour of the PW lock functions is as follows:
> > +
> > +* !CONFIG_PWLOCKS (or CONFIG_PWLOCKS and pwlocks=off kernel boot parameter):
> > +        - pw_lock:			local_lock
> > +        - pw_lock_irqsave:		local_lock_irqsave
> > +        - pw_trylock:			local_trylock
> > +        - pw_trylock_irqsave:		local_trylock_irqsave
> > +        - pw_unlock:			local_unlock
> > +        - pw_lock_local:		local_lock
> > +        - pw_trylock_local:		local_trylock
> > +        - pw_unlock_local:		local_unlock
> > +        - pw_queue_on:         		queue_work_on
> > +        - pw_flush:	            	flush_work
> > +
> > +* CONFIG_PWLOCKS (and CONFIG_PWLOCKS_DEFAULT=y or pwlocks=on kernel boot parameter),
> > +        - pw_lock:			spin_lock
> > +        - pw_lock_irqsave:		spin_lock_irqsave
> > +        - pw_trylock:			spin_trylock
> > +        - pw_trylock_irqsave:		spin_trylock_irqsave
> > +        - pw_unlock:			spin_unlock
> > +        - pw_lock_local:		preempt_disable OR migrate_disable + spin_lock
> > +        - pw_trylock_local:		preempt_disable OR migrate_disable + spin_trylock
> > +        - pw_unlock_local:		preempt_enable OR migrate_enable + spin_unlock
> > +        - pw_queue_on:         		executes work function on caller cpu
> > +        - pw_flush:            		empty
> > +
> > +pw_get_cpu(work_struct), to be called from within per-cpu work function,
> > +returns the target cpu.
> 
>                       CPU.
> 

Will fix

> > +
> > +On the locking functions above, there are the local locking functions
> > +(pw_lock_local, pw_trylock_local and pw_unlock_local) that must only
> > +be used to access per-CPU data from the CPU that owns that data,
> > +and never remotely. They disable preemption/migration and don't require
> > +a cpu parameter, making them a replacement for local_lock functions that
> > +does not introduce overhead.
> > +
> > +These should only be used when accessing per-CPU data of the local CPU.
> > +
> 
> Running "make htmldocs" with this patch says:
> 
> Documentation/locking/pwlocks.rst: WARNING: document isn't included in any toctree [toc.not_included]
> 

Humm, I will figure out a way of including it in a relevant toctree.

> > diff --git a/init/Kconfig b/init/Kconfig
> > index 2937c4d308ae..3fb751dc4530 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -764,20 +764,55 @@ config CPU_ISOLATION
> >  	depends on SMP
> >  	default y
> >  	help
> >  	  Make sure that CPUs running critical tasks are not disturbed by
> >  	  any source of "noise" such as unbound workqueues, timers, kthreads...
> >  	  Unbound jobs get offloaded to housekeeping CPUs. This is driven by
> >  	  the "isolcpus=" boot parameter.
> >  
> >  	  Say Y if unsure.
> >  
> > +config PWLOCKS
> > +	bool "Per-CPU Work locks"
> > +	depends on SMP || COMPILE_TEST
> > +	default n
> > +	help
> > +	  Allow changing the behavior on per-CPU resource sharing with cache,
> > +	  from the regular local_locks() + queue_work_on(remote_cpu) to using
> > +	  per-CPU spinlocks on both local and remote operations.
> > +
> > +	  This is useful to give user the option on reducing IPIs to CPUs, and
> 
> 	                 to give the user

Right

> 
> > +	  thus reduce interruptions and context switches. On the other hand, it
> > +	  increases generated code and will use atomic operations if spinlocks
> > +	  are selected.
> > +
> > +	  If set, will use the default behavior set in PWLOCKS_DEFAULT unless boot
> 
> 	                                                               unless the boot
> 

Correct

> > +	  parameter pwlocks is passed with a different behavior.
> > +
> > +	  If unset, will use the local_lock() + queue_work_on() strategy,
> > +	  regardless of the boot parameter or PWLOCKS_DEFAULT.
> > +
> > +	  Say N if unsure.
> > +
> > +config PWLOCKS_DEFAULT
> > +	bool "Use per-CPU spinlocks by default on PWLOCKS"
> > +	depends on PWLOCKS
> > +	default n
> > +	help
> > +	  If set, will use per-CPU spinlocks as default behavior for per-CPU
> > +	  remote operations.
> > +
> > +	  If unset, will use local_lock() + queue_work_on(cpu) as default
> > +	  behavior for remote operations.
> > +
> > +	  Say N if unsure
> 
> 	           unsure.
> 

Yeap :)

> > +
> >  source "kernel/rcu/Kconfig"
> >  
> >  config IKCONFIG
> >  	tristate "Kernel .config support"
> >  	help
> >  	  This option enables the complete Linux kernel ".config" file
> >  	  contents to be saved in the kernel. It provides documentation
> >  	  of which kernel options are used in a running kernel or in an
> >  	  on-disk kernel.  This information can be extracted from the kernel
> >  	  image file with the script scripts/extract-ikconfig and used as
> 
> -- 
> ~Randy
> 


Thanks!
Leo

