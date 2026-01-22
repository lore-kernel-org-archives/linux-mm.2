Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4BDDC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCEB66B016B; Thu, 22 Jan 2026 07:08:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7CB26B016C; Thu, 22 Jan 2026 07:08:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C889F6B016D; Thu, 22 Jan 2026 07:08:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B59DD6B016B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:08:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61C511402EB
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:08:59 +0000 (UTC)
X-FDA: 84359478798.30.6E0C24E
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 524FC180007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:08:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PydYhJh2;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769083737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0WniyRiiurCuuasCidSwYbmBfTajQvRsR2qN3REFSig=;
	b=r3TZhgkxC5zeMwDUy35V+O1G/Knni68lv5vL7HYH3ge4hOexfM2DfPomt0fKnoQm6bbq92
	efcfY7LBsmlTHC+xAKK+HIOOTaNQrvnwU8zdW1MDFay8Vx6YUXc+BUguigSqfL+rSdWk7C
	FvYRqCYXrcRROpuDfRNQ7zvugX/XLjo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PydYhJh2;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769083737; a=rsa-sha256;
	cv=none;
	b=Ze4Vawb7nO4FbzCfc5qONcwYaVUf7U5JWIpFoDnm13MneGtjKHIvCR/FRj4/y0L0RgCCUW
	siq6A3q70y6WU1S6wlFcqA8zgOiBs1RbgQG6epNMaVGoDSouryEGnszVOW1iwE9MrSlhCU
	jm9Nba/rf8+cYF4BpX/s/G8dWifC4aU=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64c893f3a94so3270840a12.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769083735; x=1769688535; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0WniyRiiurCuuasCidSwYbmBfTajQvRsR2qN3REFSig=;
        b=PydYhJh27rcyWXpJZJQpXLlp+waqnXNCTQUWv7RMgaIAN9M9k4P0q/fx9t6H7YfrW5
         3dQHpAYpMrwf27qOVN7i4K5+mOYxt+rNT84Kd8adWa9cjGB5almAX6YOl1xzhHK2PPWL
         EVOjn99wX0I68Gmzscb7bcNB4ufQ8LNQw35JCeCjvsaLCh6z1EiuDeqSQoOInTY+ALli
         Mpw5QGEsDjm3E8Z68rbqpfqfP7BQNdKl6O7hq9ej5SrXdj0rJzdQG/hgpfj6gYXs7Noe
         M6jHAZ2L6CADFsIt2Mo2+uIm1f2hxcy/eOa7MD6KbpWB/c8OLquKgYJiu19Ulz585f0u
         QzRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769083735; x=1769688535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0WniyRiiurCuuasCidSwYbmBfTajQvRsR2qN3REFSig=;
        b=BRmGXlya255BZEXR8KzczH2JZvOpudi2UQwKvAp68gmrMWRkgv4UPAQT/CyEXV9fXu
         sw/a/bAj5GPCDUZ1RxtvB9GsB0zSej6c5YBH4djo7e3XadF0VyZh/JxzqhTYVa3MSwt+
         IbdU+ycd/CGmUHhxiX98Nhyv7gbd4yoFA7gRSrLBLKvEIeWbHyEmgRo3cxCzzwnUBlJW
         hEEL3TRgEoLYpbyZBClgpD16i/1C1ncl9YAJfGiYiz8Gv8gBYRwHN046pD0sEskaRbSS
         QDMAwUZ/DMV1W12nj2OCCzHxRj9R2urkfYjpnckyxj6fVSP/FF737yAKOcE3uc9780FI
         h/qQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYD/5VTLf1JgAiMDVq2tyriTk3G6XzZy4yaFlfwIoMz2B57/teY7A/7+07sCmRIRg97nZUXW93QQ==@kvack.org
X-Gm-Message-State: AOJu0YzpJYzgIEDUk1NUOe9pW8hs0xOXit1uCqufgLjy1mEzVuMHmQ0h
	5SuGYTs21nyery+L2UKkIlc39BxJkbDxyYJxw2dEeWAUOV0TC3IyU4QpdBH/Xg==
X-Gm-Gg: AZuq6aKrper/yLUVZ90YeW3nC1wN25tQ9GhJ5OnQo7/+EABDIaNKA0kv5bPXIPx7x9L
	LnwH6pJM+Gkc6MBt/8TSXwkpgIvAya32NOim1Ipwj4I0mu/4o1GDDT/EXPHO43Q9slMD16QJjg2
	HGVNT1qVheIymstEKe82Dg2ZB9kX6TWAokkOT4XU0IAywCdbrygHnHjnxrAna+8Mnjq0UPMKrSa
	5oDpqTo2UU5KwrsP6YBHhC8/qoCoe/rah7vO/+MoBnBL5s0II9hgOeYjyJK2+fQJrnDDCrAY9aS
	aoBt+5H5QeTZxqb+nisyQ8AseGHBwcsKmwqE2F7E4oa0fknhnyDigyaqltIRjRCAPT78ooEP/JS
	eBvKoIRn4BTNgdJH6nIMMwiIc9FNmZrPcEzh7obR6sJaQqa07T/sH6+HLpwlE9KZDzQ9G/pqYpd
	juOyqA1ngk373RPdZn5T5QULrgJ7i1Jq2W8S58FPL3MeFbXb6ihkqg
X-Received: by 2002:a05:600c:2d92:b0:47d:87ac:73ef with SMTP id 5b1f17b1804b1-480470c7513mr21530765e9.13.1769077831210;
        Thu, 22 Jan 2026 02:30:31 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48048b49880sm44067865e9.11.2026.01.22.02.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 02:30:30 -0800 (PST)
Date: Thu, 22 Jan 2026 10:30:29 +0000
From: David Laight <david.laight.linux@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Arnd Bergmann <arnd@arndb.de>,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Yury Norov
 <yury.norov@gmail.com>, Jani Nikula <jani.nikula@intel.com>, Vincent
 Mailhol <mailhol.vincent@wanadoo.fr>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Kees Cook <keescook@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>
Subject: Re: [PATCH next 12/14] bits: move the defitions of BIT() and
 BIT_ULL() back to linux/bits.h
Message-ID: <20260122103029.255b3dd3@pumpkin>
In-Reply-To: <202601220951.7C4YG7hB-lkp@intel.com>
References: <20260121145731.3623-13-david.laight.linux@gmail.com>
	<202601220951.7C4YG7hB-lkp@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 524FC180007
X-Stat-Signature: hwf1bzkarb7qehf48fi4uiybitwugih7
X-Rspam-User: 
X-HE-Tag: 1769083737-545984
X-HE-Meta: U2FsdGVkX1+XjLKFSCIj0isoRLmso3wPj5hGdyjZ711KrCFmv7/Dms3ymunmaFPA4n63Tz0EocwEZq7YehrbhF6JZiLxJqIT4ajNEpfAeMquGNkzab8JwcCYEd0hFmUwzse3PU2zk/QNw6OohX0nbSFd+97AXfxbKsK47Z4IQLS7MIjpGDpK5p3Jhls5jeNFinocaPKC9l0VZE9Rb0iT3zkr/JI4TWbWrXFXZSOshH9SXTH2EI+heneU4XLOSoPCApMJFxbI/Rp1kWrBxDezo1Zgftm9vCArybvyllMUeihi2JpqiVBbnBH+qQWtJWj71S3TuZw6TOUrKBFpAnfVhKg9WTCR9WQhs00q0h7KYoMLSCIxwNFKeofuXKR4+m/fcXJRovXaKJgJLRFgLwffeVsTa9SGmVJ9bCQ4H+kFffjc8pWdufXLIEECJ2/nxRr9oKigOgybweWNU853BNdFce7vDLOei52F4cf0LbLGdIwuF6AC4aeZGUG9wFpX/k21KhNSptyiTEJQbrYY13mGSMzju+qItdzY4sny+Cg4jcNBb8pFNup66JpOFtbvTD4C5iZbt2Opzucz1At4WSDoEPjqc85CXZYeu5t3HnKeFhIRxJytcooDTZyx/O9TuUHNsXhyPGV9MU6W8bDuoeAvKhivnjhT3V+FHkAycsvho9fcdKeCz1MOWTRLsXSTdVPngMVPoU2Dli5Tvo2QyQhhA5tx3qyWtSQmzwbVi0/9ytUvYhXmBQA3zHKPieADXOLnCWPJeHOKmz42rteCQxmVcCB9NAjGgpeuDiOCAkbqfPp/lYy41PJHvI6QlspQCSBW1gSY42jG8CEFgbXRuGS7A1BntfIfTqAHT1dUk3p0uOkYYzJAlJ24S2HNLc6ZLWb2eeBZP3N4h6wMEX+TRMe2n1PFr3l+crpxt2PUmdpt33H5ZBP1Pj2DXiTIPB4fVXgSv9M3NaSZvuXQD4LUxb3
 2IShlFlp
 oax8WKCT6aaV/ohZq4EdG0g2RpMLGui07DqbNiFMiCsRu3Lsg6xYOWvJ2un4iSsx+ZYfpJg9o5kMg6XQoHxCDU/X/8IHnITosCvyYqNwhdju00PVSyu5pa6CQZvLZoBjPGe0Piw93/zJ0FVtKgMod3X/X2Dd1Kl75MVSSndak8JyKEnYr2KHrJJBWgqjsc/gxHs7/5zb37Kxv4eB51YMs+xdeFwS/JmgX8SxlttfKmqbPyAvahy/zFogX1S9CGPvUCjlSJohMi77IIIyk/i8ST7OWdwvb4bHyqYYsTCCtJnSYnG3zJkitbsl8oYAqB0v5FVkVGz2nF4HjrOYUH4HC6aKHg6kHOs04ynoFwFHTSJ0iMOP8s/QnEGmJtSZ63nYWMo6jkvItCMS7j/mQWE/6o+IbeHv2iJRIJNkJepDwnBf9hAY+OO3QsmZkJ86aOtRQwofWH3y87Df3Hu0kG8G6+y7XhqsOu/mH6ATN2hlAnKtHcX1REcswS8mdCbsoxaAcHTVA9Kmt09nzJzXtnBk8mDoLAzJ01sEx1NEA0oKyLA7pH9Cf7kVzCpVKq3F94nqUhxmu54sG1T2Sh7qHL+56DfdZfhfIr7ckq60PWjzRDLAs5X6yXxUkK/T3Sx3yYeTeKxTGqTlg9c8g0o0Tk0tHHUjPwngzpBxIrCDfH/bbqczHN3ww+gdKoOfRxxvqqHZoiqwkq5OFb8VNO9pV1Zai3u0o5PxmUQD38AAQStpVrChXqG/2s4CAer0Tjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 09:23:16 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on next-20260120]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/david-laight-linux-gmail-com/overflow-Reduce-expansion-of-__type_max/20260122-013456
> base:   next-20260120
> patch link:    https://lore.kernel.org/r/20260121145731.3623-13-david.laight.linux%40gmail.com
> patch subject: [PATCH next 12/14] bits: move the defitions of BIT() and BIT_ULL() back to linux/bits.h
> config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20260122/202601220951.7C4YG7hB-lkp@intel.com/config)
> compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601220951.7C4YG7hB-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601220951.7C4YG7hB-lkp@intel.com/
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from kernel/bounds.c:14:
>    In file included from include/linux/log2.h:12:
>    In file included from include/linux/bitops.h:28:
>    In file included from include/asm-generic/bitops/generic-non-atomic.h:7:
>    In file included from arch/arm64/include/asm/barrier.h:14:
> >> arch/arm64/include/asm/alternative-macros.h:18:20: warning: 'unsigned' is not defined, evaluates to 0 [-Wundef]  
>       18 | #if ARM64_NCAPS >= ARM64_CB_BIT
...
> 
> 4c0bd995d73ed8 Mark Rutland 2022-09-12  17  
> 4c0bd995d73ed8 Mark Rutland 2022-09-12 @18  #if ARM64_NCAPS >= ARM64_CB_BIT
> 4c0bd995d73ed8 Mark Rutland 2022-09-12  19  #error "cpucaps have overflown ARM64_CB_BIT"
> 4c0bd995d73ed8 Mark Rutland 2022-09-12  20  #endif
> 7cda23da52ad79 Will Deacon  2020-06-30  21  

Unless I change BIT() back I'll change that to a static_assert().

	David


