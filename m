Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CF3ECEB2D2
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F3768E0008; Sat, 15 Nov 2025 18:20:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CBB88E0007; Sat, 15 Nov 2025 18:20:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808018E0008; Sat, 15 Nov 2025 18:20:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6FCF18E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:20:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8F4DC0853
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:20:21 +0000 (UTC)
X-FDA: 84114412242.13.A70C7AD
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id D03D1140003
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:20:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PwscUTmn;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763248820; a=rsa-sha256;
	cv=none;
	b=Ltl5QGt3ZNatLhiiC+CdxSTY6G42i0jmtWJsCxkdvmHwSOQYNUMIvUROaSjEI4O0TaI1BM
	ECNu+a1LC3debj4hFzUi63ZZ0cpBzaqVOVBuNvfC4xGvzUi0uaTviBO2X6tH05QNJe8TX6
	7p0sSPR9oUWkLp5w2aq0pSXsfaNi+5A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PwscUTmn;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763248820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1nG48T3PKR9DL3eRjQ/rPhDhCItZZXCtoC3T/QZzPjg=;
	b=sgRwHiTnFEUpw7Q1uQZtWeZW7rL+KY5Cy6c78bDBznfX2aMnim1pQHGeQNwctsVmq+sMVw
	CkEwZ/CDhLb2p1852b5E5bDXRuXNZUhgj2CaYhT6HFScNypyNE2WX74+r8AAPEqWb7Sx3v
	QA5e48Kk+uZo0nqfGPcHQHvh0+5gFCs=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64198771a9bso5959797a12.2
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763248818; x=1763853618; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1nG48T3PKR9DL3eRjQ/rPhDhCItZZXCtoC3T/QZzPjg=;
        b=PwscUTmnI+M76+KOtm7ZSK5/D2td1oUNdz1rFggidJdslfxgznfYPEnh/acbw9wOP+
         HX2t8VG5SLKJowQMDDXyHJWBCmklzDr9svjAH/4skk8MMdzj07uRAS7u47whbCQvm1Tq
         6gfpfdKNjNBUqQZrFv+J8FZltvzfc8PwGzpxMFDsc/Is7rMaXRysQ0hp8E8KTezNM73W
         c0Obbiwivzi3W91MCGDi6JUtbq2wJkJvY5G0nATC7h3cgDT9QGQqyvCbP2rNKQPMmfLu
         hKMjBPLnUTDfs6LOTgMvshnHBg+VpL0mN7gFRnMBDrzhYk+zQQ9AI905eT5QI+ncQoP8
         gppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763248818; x=1763853618;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1nG48T3PKR9DL3eRjQ/rPhDhCItZZXCtoC3T/QZzPjg=;
        b=d2LbJOyYJ3umyHeAX46LFrUsRv6K9M3rmOqb3gMEwbIsr/i1/aQnY0llQ0OHRkFxVQ
         0l8PTmw9HjjvJoVnSeNL5BbBBm1OjnX3CBF3R/TbD/YBMTyO07tNXaNWTC1dFcEfYAdJ
         ATsH1whEuGJKROomX5I6BCGyxDuWhQKBRfQK9rULq4HL82Vocl9nQ6bmGkVw7ZfypthO
         JuPhwVqZT1ur6clBBBxpMKfrpWXr6uRQBPBNBdXO+l0g6wUL8PRhLNlOHzDSBia/DcJj
         A2V3beQxc5wabjwXXtV+KhIbYfa5mmB05UX9a7xZ1+wSRT5Jru2quBLpzJ/rTZ2vZ0Pw
         L3cw==
X-Forwarded-Encrypted: i=1; AJvYcCXhFPAcPsjSzGz4fLQDU7T7HhonioWdWtJcf2AjCwG+dHuINF5vIt/UsBvMhrat3gMYIgQazCBtSw==@kvack.org
X-Gm-Message-State: AOJu0YwG8Hddd231ceV2lHS6gVz7VjTJFsB7V/aYlDYR5djnzPZ12vvi
	CR7hScdztX7nokbT3PzFj5HwZkxbzVD0DA7zK/sqKyWgJnsS+sTbjiY5EuF505Gc60ELl+2IJkT
	ffHlx19JQMHrf1Ex5eYqhtFO7KTQDZU8C+92LQRXaYg==
X-Gm-Gg: ASbGncsI4pquQc7A9wtcNSu3pGtTrjHXeVtAvw4fTQM1HZTdOC4ZfALLrdAw3omq5cB
	CJSQo8GCNmk2M9f0bsWG/f0rmvS1fECpXXU8ZxO1r02bo5JFJZdfbwMg2CQYGlaRC1EeFQAiban
	c2bub938o1nt5jsBm1JKyJexvjGa+MU8Msel8vpSfRy3lU0LAJGBNIQVWRnmQchlwM3ujmmXKtq
	I6KM5WSKhpxBxWcqI/2PdHkTqTx9JdM+jLapLSaZHkvTFItWdroXd278a5U/j7MscM6
X-Google-Smtp-Source: AGHT+IGTBT8Fzma+3yYPpDFd+DD3iOx1Wb7+8bSARIoAOt6jXrmqBo207u3iTo22/gyCM7A/fxHKf2NFI2kGEtC+N6w=
X-Received: by 2002:a05:6402:144d:b0:63c:533f:4b25 with SMTP id
 4fb4d7f45d1cf-64350e2091cmr7747458a12.15.1763248817815; Sat, 15 Nov 2025
 15:20:17 -0800 (PST)
MIME-Version: 1.0
References: <202511160314.OK0OGRXl-lkp@intel.com>
In-Reply-To: <202511160314.OK0OGRXl-lkp@intel.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 15 Nov 2025 18:19:41 -0500
X-Gm-Features: AWmQ_bkBBHTdU9EPBD3bJZ0OQv8SlD-WQo6FALKyAXAkJ9Vd56KVKAMzZ43naZo
Message-ID: <CA+CK2bBgXDhrHwTVgxrw7YTQ-0=LgW0t66CwPCgG=C85ftz4zw@mail.gmail.com>
Subject: Re: [akpm-mm:mm-nonmm-unstable 82/133] include/linux/kexec_handover.h:108:7:
 warning: no previous prototype for function 'kho_alloc_preserve'
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D03D1140003
X-Stat-Signature: efti5bzhzyewymtajk6wn8remi93yhfx
X-HE-Tag: 1763248819-878016
X-HE-Meta: U2FsdGVkX188ON34Y2LCe7clJK4RR3WFA/BkAlRzGntH2/I9XCYTZRiePXibTRpYX9DA8wm8g8tLmj0LbRRope6zmMIQFomYHjyyF3/fW0dnUbyfCdEPcL1wxa8qVciIsutKOodsolMbQM0el75TnbQblXp/9pfXHgT0dGh1aqdfXt5kRw2F35nAHVwvZmzYJ8OiC7oVEaGXyalxI3a9sbWjG/kiO/SG+RVe/IhheExSiFInjmrPWudWGYDg2ddYmrM0G0Y4yUDODqheM5z10gQ3ifpIoxEYpeAdXMR8L1qhoRCGkt2gE6yThOV23e9UEuUyIcGmsasukP0ECzXGc4gQQrUgsbvt6vDzqYjmf7vbvKDU9e3CFEERgrORdcWS3FFWPKGQXh3x12kjg+FXbrDEKr901ZXRFyXxwqby5O5pl85W/CV3f8l0ZKJBnT9sya0tr3LB4U2qmYZpLl5H/a+bXb2/Rczouoe4h2t0qMJ2bKTIdM6pIfggjz5zCKkUREEb7SKj/ld25FGdT7ZrLpy5FGn4iSNxPiJGeekBXHfQdNGlRoXj8GSPeCeBPcKsZ6CHwo5ufttXwfpYwO6lYvJyrz1BHE+VGOHy0nUIjskog65xXS/8+okHceg3fw/JkR3Afn0Rp70pORbgu2b2Mbcsm70iwEND0hVBJ7KpShi1nXNIYPwLSU9TwRW8RdYOPupDVfU3QmH9pvpHxi0zC26lg8bcDoW52yQypUYTTd9iw2WJDNa8uAfxMildLBdZr0UME5+11p+3BIf3jxQcFmAOtYhPhZpdK3TY4WfeCpHorX8t9PzWHvK0eLnBhIm81Il4QD2zXWWqN6k1/TKH7mO4bjMFFOy0XRrD8dgpaiR9ggTefgKptKRoLhCnAJJAzu3zKW5hFQ3BtWMjhfuwDGI2Q8gCMvfk1k7wc6jMC95pSVLF8/KdY8LFcuQlFzMGscDY0rJolKqfVnS3lEA
 ddw7S3n6
 ToVvMuTPdifN1C0ft72ud9cE5HnT4SpmmmKhuzJ0McS2irSXEe5zV5zNeKkOODfjlDIq2APMMCOcwtjwURxNKhfx0Ky4TST+XexADBSoYFvUAJE+i29HfNsOQH6e2Er+YwvUnT6lUQVSpo6T/WRd69uu1t/SWuJ957hhHzBgT8nNLsFSu6fr4huovP51TZV2Ra9rBpD8ZM/DyK/h57srKuL7l7XdIhVAaOmzByzke5cfEJVv3wa1T94PrHNrsMa/KKHlsTc2kD2eMywBvm74q9n9+rFon+VuXNl9IecoMLQYB6LddxqTEK+6f/34zRbNAG3I16y62cgS4ymnZsupr5wPpbFpfY5WLWsIU3tw/GOSWNVMir/jD/j20J5/jeDyNmPuCwvoAE5T+dZi9f4SDM7elIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 2:06=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-no=
nmm-unstable
> head:   4fc88c237bfe11bde443e104428aac56e63a997f
> commit: 88316955b5b1b4cb0cb2fad416f7e8dde9b246a0 [82/133] kho: introduce =
high-level memory allocation API
> config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20251116=
/202511160314.OK0OGRXl-lkp@intel.com/config)
> compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0=
bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251116/202511160314.OK0OGRXl-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511160314.OK0OGRXl-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    In file included from mm/mm_init.c:33:
> >> include/linux/kexec_handover.h:108:7: warning: no previous prototype f=
or function 'kho_alloc_preserve' [-Wmissing-prototypes]
>      108 | void *kho_alloc_preserve(size_t size)
>          |       ^
>    include/linux/kexec_handover.h:108:1: note: declare 'static' if the fu=
nction is not intended to be used outside of this translation unit
>      108 | void *kho_alloc_preserve(size_t size)
>          | ^
>          | static
> >> include/linux/kexec_handover.h:113:6: warning: no previous prototype f=
or function 'kho_unpreserve_free' [-Wmissing-prototypes]
>      113 | void kho_unpreserve_free(void *mem) { }
>          |      ^
>    include/linux/kexec_handover.h:113:1: note: declare 'static' if the fu=
nction is not intended to be used outside of this translation unit
>      113 | void kho_unpreserve_free(void *mem) { }
>          | ^
>          | static
> >> include/linux/kexec_handover.h:114:6: warning: no previous prototype f=
or function 'kho_restore_free' [-Wmissing-prototypes]
>      114 | void kho_restore_free(void *mem) { }
>          |      ^
>    include/linux/kexec_handover.h:114:1: note: declare 'static' if the fu=
nction is not intended to be used outside of this translation unit
>      114 | void kho_restore_free(void *mem) { }
>          | ^
>          | static
>    3 warnings generated.
>
>
> vim +/kho_alloc_preserve +108 include/linux/kexec_handover.h
>
>    107
>  > 108  void *kho_alloc_preserve(size_t size)
>    109  {
>    110          return ERR_PTR(-EOPNOTSUPP);
>    111  }
>    112
>  > 113  void kho_unpreserve_free(void *mem) { }
>  > 114  void kho_restore_free(void *mem) { }
>    115
>

Sorry, missed "static inline"

For, this another warnings:

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.=
h
index 38a9487a1a00..dde952227b88 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -105,13 +105,13 @@ static inline int kho_unpreserve_vmalloc(struct
kho_vmalloc *preservation)
        return -EOPNOTSUPP;
 }

-void *kho_alloc_preserve(size_t size)
+static inline void *kho_alloc_preserve(size_t size)
 {
        return ERR_PTR(-EOPNOTSUPP);
 }

-void kho_unpreserve_free(void *mem) { }
-void kho_restore_free(void *mem) { }
+static inline void kho_unpreserve_free(void *mem) { }
+static inline void kho_restore_free(void *mem) { }

 static inline struct folio *kho_restore_folio(phys_addr_t phys)
 {



> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

