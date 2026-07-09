Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC42C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D676F6B00A2; Thu,  9 Jul 2026 10:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF0E36B00A3; Thu,  9 Jul 2026 10:45:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7AE6B00A5; Thu,  9 Jul 2026 10:45:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8F56B00A2
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:45:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE04B401BF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:45:17 +0000 (UTC)
X-FDA: 84969511074.29.4A1A785
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 06D2D40007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:45:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AFMeQZGi;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783608316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zd5VoNhWPJ5FEzML0KqVlaL2mS6uuL6nYiz9sQZLNME=;
	b=JQjjlwX7kQgW2A1d2KlllQIcEyr4AIUA1rOJ8owGm+hhyubuWJuCULBok6ADaticJBTWcx
	E5zxg91JZKndIXd4QKtRVf2y05uyZjKoG2ZEJKdN4B0olkFcJzxYqQGnEA+rn87GljMAA2
	REHwHST8zZNzn1Sl1ZQ08mDjoNhW1G8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783608316;
	b=P6jPORKn22i8lZj0eGJIDSZxicrbeF4qbt4Ip6Ot/nRYmBUjBJTzlbEzNHLHYrG2HmxFOg
	yRXVEhYoDkLpaE5a0lu+dw574gfqE4/nYM9U6l6RCOnqXU+cp+UOQUdCYxmIKiSgMFN7no
	r/Eem2ie+eEcr+SAqVKLlIjlMmFuMHs=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AFMeQZGi;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-698411099d6so13327a12.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 07:45:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783608314; cv=none;
        d=google.com; s=arc-20260327;
        b=YgOYwg3cNdBSB6YRdVe70DHeVGIyznMybP/dUr2dr1nSV+xswUX6axN/4uwhcSRSP1
         sxIl3Ef7TIxztK5hrja3VAhUElhtgbK2tX4BDRQyPLU9M3KCSL9xyHt622hY2STi01LI
         fsp+IxUuJ55Clq5afblUOcJLBnD3VrhYaCK/aACRJq7DboBfEbR2xYcw97J1w/CRCbiB
         kVYgBqzps2fWBSfzOc+IvDHNwZnXmrAQVLSUMCVDiJN7YPhVhP1bnl+Rp+bRRZ8AIjsL
         zhTZXZg84TgogNQ6bnbikmTPaV/HMyFHR/bALelw0YWnIpV4aHBolliHSNv15LiSe3yO
         FDrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zd5VoNhWPJ5FEzML0KqVlaL2mS6uuL6nYiz9sQZLNME=;
        fh=PmxqnVq53Df1T3X8/XCuurIvR7dbJp4wir+UGv9M7G4=;
        b=Ftwxo1/apo/TMtq8rmhXYpdhmuvPgoweHKlxVQeLvZGbmtvJ3GEvACgZk25g4/N80a
         5yrGb22e9Uyp5CytTyddckt/00pGpE8rmEX7VBoRjZBOI6kAMEc9ud5yh9bAvEGCsFFZ
         VJeL0SWdRakV/5oxmKtYxhnKzAUQlKkv1lgWQQsGRwXPKBMV+43MbWszry4XAsNQQhcz
         IUDe8oYYMeOn4hr9JTg3T4bUO+jfgzPkPKWMhnQJabur+8kT/P1kI1BukMd6igVoFyN/
         YEJi85Eq0zuTAH3zbBDLu2nWJswF9R9ucJbldJbIDbRhslNjyJgHGGHjbWGX11vn+b2X
         Snmw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783608314; x=1784213114; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zd5VoNhWPJ5FEzML0KqVlaL2mS6uuL6nYiz9sQZLNME=;
        b=AFMeQZGiDGPEBPN0N3fQwCMJ7g7ASgM43dnkA8pv0PO/hhRT0y71QdIbzY+QNSp0fq
         InsA2X3tMeC5RcCCrC+AVJGcq3F1KhVh1elBWq3rq2S8c3NBAMdeLBrsYWxYFF26cjmL
         UNnTqPqa4RRRUuTNuf9k6GYRuXjpM0RK9ey4BoU+fq6GxRiL2mjRi73vJSzAncSATnJR
         T8/27Blou6Us1zNyze9GhwD3iKDMho/tYM1NVn9DKEIPy7nDsjgaFN2I4GS5FK26LTbu
         HgCax6D4ZO8UtFaWHVctkm9smrS/l4MHpanQmXXUTE6ZTOWcsC36qFPKPlkiG6TKzdaQ
         wkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783608314; x=1784213114;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zd5VoNhWPJ5FEzML0KqVlaL2mS6uuL6nYiz9sQZLNME=;
        b=T4sHuVa23DKnzGXUxJHnw7RqpY0jEaclmpqWmURpjkVR+UIfWtmlzuLdjO72Ttzz53
         qZWlF3B5Y2iEyecJfSEeJdc5l72uly126CpVUCEd4eV4NtmxDFwUbJOKN6XyKiZC1gGk
         dabwIwD5aen+bCxIcbhYfP5ExzcpmZ9CAub5Xh4JJpLCGoZz/1QPjKg6kcUgpRjOhuTw
         oJ1FLL5IRdYUFvhCQfz9u7DxmQDc6F1UI0y4dnWFJYC/4yDwxGwuPvqiZdyVL535Z8sL
         Efe/fHtyug7lD1YvLVHdOfnUn17snKdyjG6BLMiXmiJvJN0GJlzBcCQuTJOFqWC9cjv4
         Iagw==
X-Forwarded-Encrypted: i=1; AHgh+RravJJFd3Sb/r00He0Co+0ikjqabNV9WyBW/1kepNgQRk/f0rlW2/XVQjIL8WbA8Lz+ha8E8tUmbQ==@kvack.org
X-Gm-Message-State: AOJu0YxVQyWth7LsFxLro+td4h2f77beJ2N1cYYp1CpJEk8ma7zFX8Uu
	rCHR3ryFoSdqi8ciJDM/ceMBNkX84ETBcQQ0yLHWvaVwDMlHE5HG+B3ckI3m+4hmfC/t3HoCVhy
	BCvvliul1ukI3jhDhP8IfHoHBCrFtXUiDnKqFgOa8
X-Gm-Gg: AfdE7cnFPuj3jCGgIkjPmduUvLXylBFTSedKtkFSUfb43PN1UWoUfTlXHF0pmWq9dxw
	sMuhB3G9FqSq5FEeFbxJvFYlrQhnHBLo9qN+ir8zsFp//HIOlK9IJu33rjyxrp+wU+Biyp/RJpz
	caGgZm0vs9mJ2T9RviC7rv6N5fcVNfjaN6/6ejZcmbYrVFA/a9UxWnq+GrmQUp8sa6Rh6F2RO1V
	5HO4aevbNTzsn9xQCAKw7lPrTkV3jQRvGnfEHh7rCiiAOx2vDPAzqvgZbOTL7Sou9irK4FwGfIT
	ZRuc3OPAsHKGs2rYNMXUhiSZOOo=
X-Received: by 2002:aa7:d50f:0:b0:69a:fb2d:e84b with SMTP id
 4fb4d7f45d1cf-69c0702dbf7mr41178a12.9.1783608313884; Thu, 09 Jul 2026
 07:45:13 -0700 (PDT)
MIME-Version: 1.0
References: <202607091820.qbjlGhKK-lkp@intel.com>
In-Reply-To: <202607091820.qbjlGhKK-lkp@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 9 Jul 2026 07:44:59 -0700
X-Gm-Features: AUfX_mxdaahI1V6-jyyKE3lUbvW_nBZksjAKzczctwG_EjEihAxbOStFVHjycmM
Message-ID: <CAJuCfpHjUij9kkD6QiWxYvsYD3iKga9rzJZWnN9vCf3bhp-dXA@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 344/369] mm/alloc_tag.c:356:58: error: implicit
 declaration of function 'compat_ptr'
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org, 
	Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06D2D40007
X-Stat-Signature: pj477zauypuk47n6h44y1ofmkh7f8e8o
X-HE-Tag: 1783608315-114719
X-HE-Meta: U2FsdGVkX1+34j65FRdWIM2wvmnmro02iexJa7zTdk+2gUH++rtuw58kP5/axzek+Lx0aNKb4qLJEXFTiMotjjcibhWKitzuZw3AthadK+m4wU9cgByRtwhVCOwEILuBOWjzg5ZS47Z0JvzjXCt3cnHvO/G98B5fRLi0Hv/JR3m3uQU2l67yEQhgng2DXuOz0Gg69MD1vq2whOCZij5AvyT0LN43C95iDnUTO1enBmY45fFPNcwpIdV/fOwZCE6o5CMMXMx7xbiIbBoYKwO5vigZYUTowB24DkzIK02VZtV3DChtE++79NY319tx4nKkGA8pbm3DY+Zxx6idunsTeDiQguw4ITZV4sg/Tu900q8a0LKEJEJVWZjt4mAMqWHKY7JEhlX5HCOcci0FZR83wuZkve9CkVg/Ku1z9GZum/myToeQ2DzlNjlZFdpCFWVIVSHxcWPQNUCF1LBeaHeApc4YjP/u1fdG+1xePEHLGgeXIMBvYg4lW2Rt0h3AW85aKEOi6oCeoNbexE66+S2QH12fDMaJbLEGji+oqj660MN2JKiL7Jo2OaxbBwE4NPXBbETeKaCfEsIV8EDcdL1RVf+Xyv7dftt3TaEi+aN+wrV4fraC8uc6Cr7EP4v83ASP9Nhsvq0HM7WAKcvhb+2B7lsLq80SrAyWZDm7M2a2wcQzAssi57J5ant/iAn4b7IROsJmcSYqyHeC3eAVjGjUbT2gxOB0hNI+r2MCE0E1Z4mj+g3Hz+rCdzGXKeoQD5DxEkWjw9CVUzQ6p8758JmSgpl2Bva44s8/lYpgr8d7Ge2X1TPbjTImWWmssWQ4/hvNfRvj2/FLcem4R/6QuC5d8z/cRL28/Girl4j6CHoOl6sQRjwtsztYUR0yuO8tDBMQpripg0HUOr+CMDgAC/HlhlTmfb4+T0b+7mH6bQtSUYaWQEJ5narpKloH2rxN7RniKIbEgALo1fKglRpKEnq
 eYXotEET
 CQvlB0/7jh2MO97oZB9TTTqTNahAN+2TbnGgYRbkQrmqsEYCVrTnhUEabxLTgyoj08Rp1c9yMIrBbSxgKX8/1/SU8F6D/9G+kBQKK0MU0sHeZx2XRroLo9IH6SYABpsuh+t7fJdQ5WbYfAHzv5lF5mtewdXKAxmZhfI7KINAKchQzFC5IvYw3OEwQ5QKENnRN4WI96ybW1ODTJsFOR9VmX7qaE6hi6KWyFfXuQWNpH5UT/lLsQBrrrR8DfX6OjJbYmGcCrKYHvGEKW19klVdZjotLawzaVGvCOtI/6olxfZVq5t/vDqmsDrzqVCKPIGL9k7xYHG13RPwfBpmfvdU3PwCBBz6i3/c5irGCyCHl27geEM9VRlaB45gWzeamrrKBD8FjRPad9g2Ws1mcNYe+jhqc9KHXjOV7tOba
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 9, 2026 at 3:00=E2=80=AFAM kernel test robot <lkp@intel.com> wr=
ote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-ne=
w
> head:   59e34180e138a293260301c139cf7ee800978533
> commit: 27ace96bf8195484c9e9e1a08eb5af5a4e81f9f0 [344/369] alloc_tag: add=
 ioctl to /proc/allocinfo
> config: sparc64-randconfig-001-20260709 (https://download.01.org/0day-ci/=
archive/20260709/202607091820.qbjlGhKK-lkp@intel.com/config)
> compiler: sparc64-linux-gcc (GCC) 15.2.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260709/202607091820.qbjlGhKK-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202607091820.qbjlGhKK-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    mm/alloc_tag.c: In function 'allocinfo_compat_ioctl':
> >> mm/alloc_tag.c:356:58: error: implicit declaration of function 'compat=
_ptr' [-Wimplicit-function-declaration]
>      356 |         return allocinfo_ioctl(file, cmd, (unsigned long)compa=
t_ptr(arg));
>          |                                                          ^~~~~=
~~~~~
>
>
> vim +/compat_ptr +356 mm/alloc_tag.c

Missing #include <linux/compat.h>
After adding it the error goes away.

>
>    351
>    352  #ifdef CONFIG_COMPAT
>    353  static long allocinfo_compat_ioctl(struct file *file, unsigned in=
t cmd,
>    354                                     unsigned long arg)
>    355  {
>  > 356          return allocinfo_ioctl(file, cmd, (unsigned long)compat_p=
tr(arg));
>    357  }
>    358  #endif
>    359
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

