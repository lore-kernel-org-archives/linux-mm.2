Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC72CF8875
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1626B009B; Thu, 20 Nov 2025 10:44:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89336B00D3; Thu, 20 Nov 2025 10:44:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6496B00D4; Thu, 20 Nov 2025 10:44:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB7B96B009B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:44:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E8A71601CF
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:44:18 +0000 (UTC)
X-FDA: 84131406996.02.2711DC3
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7DD5BC0003
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:44:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gycCBNCT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3TzcfaQkKCIoozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3TzcfaQkKCIoozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763653456; a=rsa-sha256;
	cv=none;
	b=Lryo/PBYuFY1hJG1iMKGToQgZH04Qmbvz0WVtRFXvTmDwmt4/EfRWuFZ7bAf4q9FFEQo87
	fhB7t1JKYVnjba0lydChPx4kpb1IMYigF6lRnVBbyrx55a/aUxd4VQXjSPvqPdQisrEaJ8
	bQ2pbPQQvWvSBOTgJo3unQO1fm3nEP8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gycCBNCT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3TzcfaQkKCIoozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3TzcfaQkKCIoozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763653456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7R/jcRhio/BOBSfmr70oitl3J9fEryzYjRsvPMYCQrI=;
	b=RHk2A8+fou/wKwbixlgLoc4BVK1V1MdkGSoCkd2ZUDjFu91jJX2z0IZbZq9VdeKSwqACF/
	nb5XlbXhzSNxZ8PwYKWcKPmJzy6yOPx7+MmmVdpagwBeYTUYWKNSh4thqMZBz0PBYqbjDX
	7fscuicODfMrifaea16I/gPoBCE/IUY=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477a60a23adso6920525e9.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763653455; x=1764258255; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7R/jcRhio/BOBSfmr70oitl3J9fEryzYjRsvPMYCQrI=;
        b=gycCBNCTUA0bD2n8OicK8tzyysbEGUpfk/0RSjHvqdPWCspLadenOHvewqklqkvjds
         n8y0TUb4uWs22sz7igGj1y5nbVgdRzQ7SfN7uHMb3nUQcG769u+1O6PfYppIpBuDrxQr
         EH0sUhKjOlyM03qeSA6TycdvXOUiA0oC4iGzwlrjJDeQa9wGSELtBuqWGe0HD4JH1LBR
         1aB17jDMjY0tpG7crQkMCumiofzvEuOFgXaIsxhSODx6SeR5QE+79atGbFWYVAdaK1a7
         7YKFjzqPOxS56mLZG6AKyBcBz3vx5fXiB1svOOCv1QIfhrbseko5Uu0cS98DzVi55oUD
         i0WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763653455; x=1764258255;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7R/jcRhio/BOBSfmr70oitl3J9fEryzYjRsvPMYCQrI=;
        b=XRcXgraHDYnD9ZZIDPc+AVNW5LSgDZcRVTJNZdqaU7M/YjXWEeDiA+bWLPIHLgham6
         91j8FqcXz59pdeEJK9b6SZyWts6E/YRKpZuwjTl6HCD9fWt0LEcQQsyL3dExYUZMvcuf
         15uNb/fldrp7YsoXwHJ/0bwcWPgnWwHj2QiaSe7FKnht+eYHUJ3MuxLanI2bCgaHqRde
         lT20KBFMGvZDl71XEU5PZ7tyEQ/BWxgobWZEe9N+3HDPyGKwEnrZQc3ZWuV3otTfhQon
         5d6H2T7grkTzY4gkYxoZRZldxSr1sUytyZh/p5LnkNNy8WX4n+u5OKK3yMDzRtV/nXP+
         nqrA==
X-Forwarded-Encrypted: i=1; AJvYcCUbSjrzGi5r98O0cR/4gC/8rnSiwLc56Gd8fDWXHeUP9EK3f9ZpreXeNX1XVZe9PLkPnBqr2PtpeA==@kvack.org
X-Gm-Message-State: AOJu0YzUgfSeU2gY7WBDw7rKTq1ATlWPaSbykp0tWFG+E8FPuuFmjYJL
	yXIhnxtcuz7Z1huRIuGpJZ1cAV798DOpeQ6kdRmLycncu3vTON/5y7P+jqTNRODL7a7w2bZeNnj
	+myLAkB3Sn71NXlsWWQ==
X-Google-Smtp-Source: AGHT+IHmU9BLDuNTWW1AqTuCXcIgwbDH1e0RCZ9YZOWiqio3t/RtoA6HYEwkpAGgObOQi93T/yGQuZXZ1+5bE/o=
X-Received: from wmna5.prod.google.com ([2002:a05:600c:685:b0:477:a0cb:7165])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4507:b0:475:da1a:53f9 with SMTP id 5b1f17b1804b1-477b9dec15amr30352945e9.14.1763653455202;
 Thu, 20 Nov 2025 07:44:15 -0800 (PST)
Date: Thu, 20 Nov 2025 15:44:14 +0000
In-Reply-To: <202511202005.7GzetV3D-lkp@intel.com>
Mime-Version: 1.0
References: <202511202005.7GzetV3D-lkp@intel.com>
Message-ID: <aR83TotAs7G-o5Pf@google.com>
Subject: Re: [linux-next:master 7315/10599] ld.lld: error: undefined symbol: _copy_from_user
From: Alice Ryhl <aliceryhl@google.com>
To: kernel test robot <lkp@intel.com>
Cc: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7DD5BC0003
X-Stat-Signature: 6j9s1osrfg6ukykbs737snn3pqx9p61a
X-HE-Tag: 1763653456-42559
X-HE-Meta: U2FsdGVkX19GYWUGRvUIuGfYoUC4yP1DpUHgEPBKd48qND52CFmoMqh0LDmTJpATsZlk7rKA9ilp0eyA6KN2uTJG+WSneB9U2ycAGKfD705Y79zehePAZ1+DRq786rr8c9Es4fz1Cq71cptL/iNlI4D+iX3oNa2nWruiBP1j469XD+Rq2xlDbRBaPQW9g6X2gamtKEdSdcAQN8DzYzdkLhizQt5xUGF8jdWu+vL/dKQa+d88NFy95qLy9CfD1kao6KBZ628AJtsGIbZQ9Qkl5YBYpjlSPpjs4yuAgVUig/ApHvthkPOE7jaX5MGEk61Rp8GmJxdSzOlFRuwjnK2n/x2uS6RdZPvHeXzczPgpoSxdvFDxNf9nSYvs/lbNeaiXWpvBdtO3mVm3ULf1fU/yx1NGbaJzx0pLPUtm+NaBvbb4j4yX3wrA9wU4onZjAY8A1stnCwQeHvObtMbe3GBpMP5IaXtJHr6mDB/wy5gQ7Yq7PuxP4ZV/MWreGulHvCpskk0izKsx+xT6C4YVF4OgMWz+Ef1TZZro7WcSa4oftBgR6SkwT4CNKM7wFRhGRY28k3DBX3hU/w4ItH3zBHBOi+ALde8mptHhK2x8VmTZ+1/uTDWmhv5jBV31uRgxav0oWIGitTOSre5NJ2egs5qlghWl+t9NGned9QwsxOCxahGm5G2exzOIPhg4HmkqN4p1LaID/GZeHsLlaQ4nhiWNInBoYF6LSZ/EoU2gcIymv9HcDbe1UEFB0J2RTq8NGT2USan4l4lkSyFJoFpUIqXDqPbEoVycsW17Gw+TBPP3ceFyuZo+OT9cvt8fOF8nKkkcBKZrC7BwwQYLSilsl6LtzTPEqVuREzX6jtKQvMk+HNtMOYqMPlUvGR/17H6Kasm78TfKkABDbuRT7arM9yocBNNGzidwoxy07YaUqJXFIM1gQzko4AJl8mcb7Dzr3gquCEFh9r3PuTXQcZ6e5rD
 T+FL/TEN
 mRhfmfW/GLzOeFbvjd0hrfGpgMpo4NtwzqJ8oNoGtYH4/1Lxv9/qet3y4g6adnIA5voHA0g4PCioGOgn0eWRE+l7oOud2045F/qLMhZ6n6EGwP/UrCaPMUnGl8avCzJe6brVI7KAz3DXZNTmZxxkZ/IvXuRUJRkIrtRIVj35P0HAX80LhZ1O2je4n5RRt40VuOp5iWK64UPVEyS4xky2C+rURUlkJxOYSqMbl6kyg6HrdNemFYi5Vgdt05xufbzey4Ql2dEr2qVkiZT5vX/gn5SdLMm5gWTpEm5O2ffevFvfvox+aKGiJYp0tdfvocsz1Xhk8Qg6y/ETr2K5VqTRq/hUw11atH4/CXyGSb87+3iJ+PCR9z0g2W0DhYrqgeUBe1mBrzBydyHp84+Aj1frUvzXtaf+gtdIUx5YbzNsw2TI4YlKr1p+/moh2Bcm0cXVYmGJpJUcaQU/NnVUQRsoOBfWgv4q5QWpJIArFoxlIYDdtx3MDD+3L2KsIm6AoFM2Ap9XPA4DKYlFrZCTfbF7qaZ/epBnbJd8DMSK50zFSwh1eZ67iU6Mzksx6yXn4Oo+Bualplnu12SgStk6iMCEYnDzgsx8RDyFGc0qapaFOI1Te1kzWyw7YL8+jM1XbQImWUkFDNupY3DUpy/uzzgw5nR1b8GCJe78i9WCLndFyrLRAWdtVh//eqe/ZYua8H447GUVsc8ygFCaFNWgI62SGXIm9CbMckhNDfRdIpqLzfNqrbC1aMzr/5ApWKOnO/vd1zHwaMU3qSEYeVsZAPBjt0v9ok6QezlB7PYXowuBbnaZwUDVaL0wdg6jQakitTFvq9rFPPYTAWjniwOmDuFELA2h4FiTczI0LafAiBpF7U8V55rp5ZWjxw6ovNu62ZoYM4N/bPjWT8JEnAZxpbHlKDVqcmx7Xce7kUPpYwp0dOkxBfDEEnun+u1yRjnrSoulkGYPmLxamlbfVXBM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 08:52:07PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   88cbd8ac379cf5ce68b7efcfd4d1484a6871ee0b
> commit: d99dc586ca7c7729450af2ed39ca1483c0eb7b5c [7315/10599] uaccess: decouple INLINE_COPY_FROM_USER and CONFIG_RUST
> config: loongarch-randconfig-6002-20251120 (https://download.01.org/0day-ci/archive/20251120/202511202005.7GzetV3D-lkp@intel.com/config)
> compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
> rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251120/202511202005.7GzetV3D-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511202005.7GzetV3D-lkp@intel.com/
> 
> Note: the linux-next/master HEAD 88cbd8ac379cf5ce68b7efcfd4d1484a6871ee0b builds fine.
>       It may have been fixed somewhere.
> 
> All errors (new ones prefixed by >>):
> 
> >> ld.lld: error: undefined symbol: _copy_from_user
>    >>> referenced by uaccess.rs:306 (rust/kernel/uaccess.rs:306)
>    >>>               samples/rust/rust_misc_device.o:(<kernel::uaccess::UserSliceReader>::read::<i32>) in archive vmlinux.a
>    >>> referenced by uaccess.rs:306 (rust/kernel/uaccess.rs:306)
>    >>>               drivers/android/binder/rust_binder_main.o:(<kernel::uaccess::UserSliceReader>::read::<rust_binder_main::defs::BinderWriteRead>) in archive vmlinux.a
>    >>> referenced by uaccess.rs:306 (rust/kernel/uaccess.rs:306)
>    >>>               drivers/android/binder/rust_binder_main.o:(<kernel::uaccess::UserSliceReader>::read::<rust_binder_main::defs::BinderFreezeInfo>) in archive vmlinux.a
>    >>> referenced 24 more times
> --
> >> ld.lld: error: undefined symbol: _copy_to_user
>    >>> referenced by uaccess.rs:458 (rust/kernel/uaccess.rs:458)
>    >>>               samples/rust/rust_misc_device.o:(<kernel::uaccess::UserSliceWriter>::write::<i32>) in archive vmlinux.a
>    >>> referenced by uaccess.rs:458 (rust/kernel/uaccess.rs:458)
>    >>>               samples/rust/rust_misc_device.o:(<rust_misc_device::RustMiscDevice as kernel::miscdevice::MiscDevice>::ioctl) in archive vmlinux.a
>    >>> referenced by uaccess.rs:458 (rust/kernel/uaccess.rs:458)
>    >>>               drivers/android/binder/rust_binder_main.o:(<kernel::uaccess::UserSliceWriter>::write::<rust_binder_main::defs::BinderVersion>) in archive vmlinux.a
>    >>> referenced 15 more times
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

This is a known issue:
https://lore.kernel.org/all/20251118173250.2821388-1-aliceryhl@google.com/

