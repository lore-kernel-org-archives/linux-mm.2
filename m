Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D06EE6B46
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF896B0005; Fri,  6 Feb 2026 14:07:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 388776B0088; Fri,  6 Feb 2026 14:07:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2646B6B0089; Fri,  6 Feb 2026 14:07:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 12D956B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:07:28 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCD2A139BD0
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:07:27 +0000 (UTC)
X-FDA: 84414965334.26.4156C4D
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id D832620010
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:07:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xqWhYCJz;
	spf=pass (imf03.hostedemail.com: domain of maze@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=maze@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770404845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZeVqPtO/zKV/ZDsrHlH8qzY+FDNnYt0+6eW+GIKJENk=;
	b=qQ+Bqzl0QY36XkpJCqzIXbEDzTy770CqR7zvYg0Bx7nR1RqqNtWZwzqLgag1AvUIoLK1Ak
	6QzDg26NnmzvqnzbAWDnjMqcUzup7XJGnyX5/bNN26QqE2dDuANhXFVsLzfhg2ZB2IgCad
	sly5N3rH6wRkUf+AMRpabKH/y5s5obM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xqWhYCJz;
	spf=pass (imf03.hostedemail.com: domain of maze@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=maze@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770404845; a=rsa-sha256;
	cv=pass;
	b=Wh2rz+tWXw5PsDQ0h/FWHCrW5T3jPHqZPJ4sFP0WXXrc9jghmA8MHe7WBfgLBWQvSFgc9h
	leaEPmZnckZiPPVJC2F6okHgn+P6Bha+/wRiYnSzm39JKcGAnM+LqKD+vDXe22NwEp/nSI
	k365JGQewbSOBkEoycDUxhs1K5oT/Os=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5014b5d8551so42221cf.0
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 11:07:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770404845; cv=none;
        d=google.com; s=arc-20240605;
        b=BwjWsuHvAvsOR4v/nfcawzFA6p79YIu9/LYNBvQJqv+U6oUvgeSWFVpLFRvSd8zory
         33HvTUISMJyvd4/ZuFQ6n5I7DMZQOnbSwNjPfBgnuaAyuWQhvQTcvxjlQOjIwphSRLdL
         bRcfgGIcHPmYpLYCg6RXfuudgf3Z+Ilx2EBkctt1HEzFuoxs/G0Q+rpLcyj1oIDramkQ
         f6k9YoZ6LKD1YBdK30uB/YSCubIG0K+xN82zqv8XXedYUZnNDrawN4CVD0EGlJAvky33
         wDFRa2TwnhnXaenNXq8TGy0Lz2/XfbOhYPIWZ0uTecAXyh9+5p4+3YEou+utQVHmDGcQ
         5XQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ZeVqPtO/zKV/ZDsrHlH8qzY+FDNnYt0+6eW+GIKJENk=;
        fh=Yi8WIBW45WqppxljVOijoHZ1i8PCGo0YNROsWIbfa08=;
        b=H0Kcgm4V1hxEHLBR+oJNu/VfM0RMxBLYeKZbDRPc9MIpNl7+3Myj4hexvzCgDjNYkk
         0pWSk6vt/CQInzPgBeAJbeKPCFZKBVVuYKdd6zMTDOiYaYYdGbVGAkC1fNYDsFGgOZqf
         Bk3BzPRMnvRjm6BG6/oPuOUJcQreUIIA1RezspI3CLcfisqbu+ujUsaZ47wfbhtS7lra
         FWL69BJi+T6HUDfkztLKas1KgGSF2bSTZGJIO8voMs3ffYfYhxz4KWJ4yT/iZUmsp1el
         khTDJ7lVbs6mLDDNl3978P+XdDFd8ZLcEm3VCEIz30Q4R/78EFKwCZEs55C0GkXwk9JR
         Jx4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770404845; x=1771009645; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZeVqPtO/zKV/ZDsrHlH8qzY+FDNnYt0+6eW+GIKJENk=;
        b=xqWhYCJz4HlbxImjHMVIjZ5Utr/dSGKrALENQiCAPy3QvtMKYBkvQ/FQBCIUaqmqEz
         nsr5ZPzuLqOyf5S5Y/J0pFztBBZCo/ZlFbi0n3BJW4rL4VU2nD8s+fTJGG2HoZZZxwKk
         5Akdz7sfzlPduemntzaPQ2oFVFL/6HzqWHYoHi8ZosmA1ccLarHlBV4+/t4IyZ2GI1Wo
         787O+6kt0V2tBQCom3N6DNe/uTSh0GLpXHjhMdwxf3E+Tktj/yU8Riy2xOdUYxHlZMwQ
         wMGVGF2X2Bn559LJsVGABmYihNVnVAsUobNXPkx7EoAx8mUkB7ozjkaStixXVsPDT79y
         92Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770404845; x=1771009645;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZeVqPtO/zKV/ZDsrHlH8qzY+FDNnYt0+6eW+GIKJENk=;
        b=wXyyNpKPxdGLC8A16ydX1dul5iOusZH/V9P6L+CXAWGsE/CZ0qwHiNUvq1ez+KFzzO
         FZhmtLcydm9C8JUjGDgzrS5cYGpOe0+IYfuAq1cul/Uu8K/RDxYK+biaHttH//BVcK+c
         xjl7Fw2pkbJl9EOkspRgIzHEZf1irg8c6PlJvstkWjVfLZVcIFYeahLvt7Qp9VmR4vm7
         TvLw5lzxS8LJxBygaiUZ2fAhWYTCKw5Pt1GyAeiaynyu9BmztXshABc0x7PDTTlPafeJ
         4tCbFHUO4rO6QFRCdqbVSp9+Mbv9JcrnDNXPSz0IQJ2wIdvM3VrxjoJRXFCE0AqBGz3D
         EOXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHkYt10AmJCpSxNTgesFc9yE/3Ws9RQS1KGy/quWaWgoeLFOn0mhP14Ii47CymZW+dPZEB1YRgaQ==@kvack.org
X-Gm-Message-State: AOJu0Yxbr6gtxEPFl6NJNHN/vOSikBOFAue4P1zYSu7vAZtLTvb+Ay28
	WfAh4tzOGO/f5s7hQU9fcvGt1CLGWbgsG8WsV6BHAA0RKm4+lO4KUQUjDBIkQAdhIXUbRjb0oTO
	OcFTYw/Km3U8awPkkKL7rOuYF4QtUkzcTHVB1KGZJ
X-Gm-Gg: AZuq6aLLgTuNGvSNJkS/IKdIlCxBUckF0vG/8BqPk7WJ4i91YVfYqdX8NpiRV30ekoI
	bwtM2aozdYe9dv0P/kJW2dtDWZDHiXUxrQ5ovY7njh8pYpoZ029XtWqgNW+yzbyZm1aj3DO3Lta
	wiiOad+Fi7EvfF/tZIJUZq2QVoqdOg+FT/bgjrsyNzjnrKCkc+XoxH376seQ4vhvvmN9VRsUl0C
	7TkOz6YsEPnIIsjga69ikUd4Ys0kOomp+xXdXBmzaynh+i9nIk6ZLABcTR0xWXE8Ms3XrVSUXQI
	LzHT7cREmYKpEy2c5hbLfAOODtZqpYUTpheYOp7oNg==
X-Received: by 2002:ac8:51c2:0:b0:4ff:cb75:2a22 with SMTP id
 d75a77b69052e-50649ca8c6bmr598641cf.3.1770404844843; Fri, 06 Feb 2026
 11:07:24 -0800 (PST)
MIME-Version: 1.0
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
 <202601071226.8DF7C63@keescook> <btracv3snpi6l4b5upqvag6qz3j4d2k7l7qgzj665ft5m7bn22@m3y73eir2tnt>
 <CANP3RGfLXptZp6widUEyvVzicAB=dwcSx3k7MLtQozhO0NuxZw@mail.gmail.com>
 <CANP3RGeaEQipgRvk2FedpN54Rrq=fKdLs3PN4_+DThpeqQmTXA@mail.gmail.com>
 <CANP3RGcNFgLSgKYPjmro2s1Es04Pnhf+4wHpnSwRX4M8bLDW9g@mail.gmail.com>
 <aWFKEDwwihxGIbQA@wieczorr-mobl1.localdomain> <CANP3RGeWLMQEMnC03pUr8=1+e27vma1ggiWGWcpX+PcZ=SsxUg@mail.gmail.com>
In-Reply-To: <CANP3RGeWLMQEMnC03pUr8=1+e27vma1ggiWGWcpX+PcZ=SsxUg@mail.gmail.com>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date: Fri, 6 Feb 2026 11:07:12 -0800
X-Gm-Features: AZwV_QhSTkSJ_KynPb24QBIc0N9LtzMU3n-qIIiw27uPu35C6AHY-mN4QWU-75A
Message-ID: <CANP3RGeHnhufYyc0P2OiKJbXdZjPW41TP=JS6nYk9xGRU8UuKQ@mail.gmail.com>
Subject: Re: KASAN vs realloc
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Kees Cook <kees@kernel.org>, joonki.min@samsung-slsi.corp-partner.google.com, 
	Andrew Morton <akpm@google.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver <elver@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Danilo Krummrich <dakr@kernel.org>, jiayuan.chen@linux.dev, 
	syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	Kernel hackers <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D832620010
X-Stat-Signature: swbmxkdgwwu5mnapwhgmwfxcs9zsdjfb
X-Rspam-User: 
X-HE-Tag: 1770404845-66547
X-HE-Meta: U2FsdGVkX19fATSullxsc1lov/cYO6+WVGkfTRnaK8VD2eB+cnGaSTlngRD4tWUtRIUWuCRUYdlFLT7kNgQogwpsHhsF2a3CeOCtNeeA55MF4QVXgIjlyMjRVy6CGiYzD5mNJ/XrqfC3AyoYTI42dzlZmEzVYSuPy57qUnzLW5qKbEtvMHa0A7W1CHGyh12hL+DfZhMIt/DJpY4JVL7PFRXtcqLySztduiAaY+n4NFYBiojcidW+Yd/sVL1SaKjYJfohhSsO6R36eCIcvia30JPtBD06y/2QY9BUqqpGlVUU2shDZDBxuyZ4WiyAr+We2LwiPOydcuVtgPA53M53wrzBKFASlkGulmPhueMSX9gx5sWOvwg9KPahCBeFs5kadTe2Ry3hq017GGM5LBXAIqjQh/Jg49Firh+BWc4Y38FC4SeACHNPvPyiI6g6TfNq/ADMS6Iey13mI6hc2fVWBwONss6119zmrVoe2eSIg0avVJxdZozGI6aqEIkkfWmbS62/ikkTRMFZI/k9qBiCWhjopC/J+/RCTl9y/sGJBx5ZsO25KhDOfR2kN7Q0U2VC/OdUW1WOGKJI1dIAsspK7pYLLgasy9QHDwWuEHAUWURoMLcqZv9Ls/4AZ3fPHecHzbv7rJRlV6mjRU1a3qRadl2BR3aXtzB07AuYEMbGvLHfqJLFTCYbJul44ixi+M3E1ofOAu0PEtOgeaIzATu38fegd5o397IO+6d35bVrx0W7mgmWDlUIx4QEjsV/N1d4NACWANSRHxH7/JIBo7zoZCxg7m/TibnJVxVaDp/y5TZLfU1WnlDW6xC95IIoUXb4i1M4VAxvOUQnqgbVuoxE/oPpgCHSkcSbbkNWqku5OV0hj4Y9kg1H4NAHrxsZyoc8sKpJT32taGs5D7oUzJwlUZV5ZvAv4jRWc4CbL6/di8Y/cam9yWpqkJL1Tyg/N3WpZFZiJFMhq0oBrO6VBTi
 yfPvSafe
 kE/xaITqP0/yVlqZATUSZ6kn7Al+xXf6N/j2UybEtJSar7t7nvziLOoMXNeE6CYtL6Ho9o6zZF5zVBAV/YomkwmudT7muPB6oTcUtQ7z3/h58Gh62TvbLr9KakGLB2MXMn04EdqWT2mdCY2S0iWBIpCZsKT35c9UBaLdno+kMBlxiVzO0QQhGKJXBOPzMfQOUtFTJqbgc5NNzXsFzjpX4nfbrj4P6XTzEpGDWNq73smSqoEk2lq9+4lFlQ2C0X2QRt5yHPHQDuw56WrDUusFQ3ZAjh8rwv8PV8smUFe9CscqbgQvU039LHZw8a0qrsK7dIGxNS0+xBp95CgpOMB5ziBHZJjyiwH7sHRmhU91ZG5ilCva12mu/pyCRPAahDDC7xmrG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While looking at:
  https://android-review.git.corp.google.com/c/kernel/common/+/3939998
  UPSTREAM: mm/kasan: fix KASAN poisoning in vrealloc()

I noticed a lack of symmetry - I'm not sure if it's a problem or not...
but I'd have expected kasan_poison_last_granule() to be called
regardless of whether the size shrunk or increased.

It is of course possible this is handled automatically by
__kasan_unpoison_vmalloc() - I haven't traced that deep,
in general these functions seem to have a terrible api surface full of
razors... with hidden assumptions about what is and is not granule
aligned.

