Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD0DEC44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 17:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35386B00D5; Wed, 21 Jan 2026 12:05:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3156B00D6; Wed, 21 Jan 2026 12:05:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5DF6B00D9; Wed, 21 Jan 2026 12:05:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBB436B00D5
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:05:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70FF413BC51
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:05:35 +0000 (UTC)
X-FDA: 84356597430.08.F15B003
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 65C2D1C0008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:05:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LVsRSKgi;
	spf=pass (imf20.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769015133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jSywsaNq61h75Z1wzOoBhV8mE5CzphyKGUVeAGM9YLE=;
	b=yXFieqIIN/txltSVM7KKNH5M6LX882BjhQPDOVVfbdRzT7e6SRFUCcU4t0YKqxLHRS3sG7
	6tVZtX6lc/yoPDV+pEXQPq96deesxgj/wW9fczHInXRFyPg6kKyVEkwYdq19rTzBTchOw9
	Rv/G3FzuKFNC5zw13J0lkSIrSTWVDc0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LVsRSKgi;
	spf=pass (imf20.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769015133; a=rsa-sha256;
	cv=none;
	b=diL8swW/m1etD82+Awi/cH74Tj0nDN9A6unKxCnmNQLxEz0Jy027AOtRmcPpagXhYU6A4V
	Wx+GXEtcChi/Sn7F+J9x1Mj7uK/4Wkywc5cf33tx4MaAd6ow94c9HekaJHUEp8x2VnJtlw
	0rqqt8QVv2Vp5ETMzQDKUAN8/ITj2mg=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3831b6abed6so66051fa.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769015131; x=1769619931; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jSywsaNq61h75Z1wzOoBhV8mE5CzphyKGUVeAGM9YLE=;
        b=LVsRSKgiw/mJpnnMAKyBQUSdhnbivmXEIg5P8If+11PVbqYphN8KrwATKtjLjhBS4J
         YifBmXSby/2PtYmBogepxxDfs9jDFdVxUjxK91I89d+2ds7wa+S+9XWZCTQ8Jt+MRjWI
         q8o1NWhSOT9fgZy5bzhz8hJZp8zOYjf+QSjN+YuKd971RGzgFsv4Xkkx4dgVM6X8RW9q
         nIgEER3Vjkp7/a69/ggHJwC793BFARwkjXN6gelJ+I7sCB+DlLQckQrXmd8GQNSpZGUT
         js9YWPKicolChpOTQRj32XJfI3U0k2wjzCM083a5n7XanmjD4HmlsVj9tYzXTkjJGoT4
         kwkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769015131; x=1769619931;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jSywsaNq61h75Z1wzOoBhV8mE5CzphyKGUVeAGM9YLE=;
        b=hp4opzdsjsgRAL7aMYgd10eta093QCl+/5K5J2VF211okKzxrKhJeUb5SAXjs5HW79
         Nhm0ZRs3UeC3jr22G9ZEqvoJRWClwSw3DW1l/Vx11MJR8/Pj/Br5B4JHf/DgYDBcbxcr
         oBMSt89zkmaBOnzh1nJyB3EwHI+rrVFtKzxFK4+KJ8/U05VQKgfDO1ZVr3l6b9dTr0Vy
         m66KNSZGf7318NyUT9cS5M6jcBrif8bTF6cIcPMrU7T/Z6Zwa7fQ11IiJU6rP8uXgl6e
         hXjkmqXSOiBSsR3mzz1g/qpnt10IEEHR0GYqCo/3HWr1Lz1M+acuIhBu/p7uXEU4Bm4z
         kRmg==
X-Forwarded-Encrypted: i=1; AJvYcCXeawKA8fNt3xb2D2G1V3HHbY0owoOlSItSKE715D6nF4WObmxyUi2eFTpigDJDAukUHiGaQKZcrQ==@kvack.org
X-Gm-Message-State: AOJu0Yw3hz+AhriSPEJvx0iSEsvSSmaTzAIyBFe2Wt4f03P79RFdEhqD
	1WxMrbEo68p+1aNHOq27kLINkuHhNfp6w+lAgGrzQNhEmwK1rUaxSLoC
X-Gm-Gg: AZuq6aLcTLlNyzOSH4T2CyM2tcDiMCOHS5AQNweOEgvc2alRA+6owOZAYvxQRnKzunw
	jH9jKlpXKaLCF6qYC1f5wSwYy8dcRaXIKUQGhdUA5H0XhqiQXG89QCak85e2P6SZEuW8OTzEi3F
	GiDuWyMeiOK5PvSjnqFH1l7HuoV3avEfBmhydTUBrcHvEkqkBarkMB+8kCO9DHhGudr2EY7bcLI
	kL/ML2prdk4yfwDu3ngtvvsGmYhPB3buz8LwoeDQlJnWM0+BcHTNDryBaBmGGQoujF16R9Yz7lt
	/p3uXP9P9ZXM1I3eoKAeqzuBtcVErI4AXl+qw0oF4v3kpIeRE46iyEgepVAOS0iURoPswNYGvCN
	Wa/Ge0/JrwHSC+rSo0mKm6Pqoi+fR7UpXBSO+XUIDYYuPieMsX7lHJ2zKPtSm8T7LJ/0vdz8IJ+
	6QJ/EKRjrBOOpCrcVAyw==
X-Received: by 2002:a05:651c:547:b0:37a:9558:5bdd with SMTP id 38308e7fff4ca-383842ccf59mr39226381fa.3.1769015131133;
        Wed, 21 Jan 2026 09:05:31 -0800 (PST)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38384dbe6c1sm46902931fa.22.2026.01.21.09.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 09:05:30 -0800 (PST)
Message-ID: <8d5cea70-0e1d-4442-b761-e6589346d654@gmail.com>
Date: Wed, 21 Jan 2026 18:04:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master 7687/8302] ERROR: modpost:
 "vrealloc_node_align_noprof" [mm/kasan/kasan_test.ko] undefined!
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Andrey Konovalov <andreyknvl@gmail.com>
References: <202601211250.6uQzZrQp-lkp@intel.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <202601211250.6uQzZrQp-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 65C2D1C0008
X-Stat-Signature: aid5d7dzd6qntbabo1k6p1qxwyqqrzuh
X-Rspam-User: 
X-HE-Tag: 1769015133-155849
X-HE-Meta: U2FsdGVkX18H77Jthjk3UwfLXcaikevIg70oj2JeZgL48hnGmAG9txUCrO8DupDuUZ9l3fS78czJRTzWvJVdM13sD+fcNYNjFLxuao1DjhBfbK5XwEAg/gJ9Kalpy/hDSwp2II12dBtekW3T1Jl28umRM3kkOgYU2VgLk/mR1mYvIqWw/Uctbk/tRxfDDoDFqqz3SifE1lyHLQuVSCxY7LhIW6HPe1KVRxYFHeZYEk0XOVJSoqj7qh4F+QGXUd/V5Lww5C8ISbIaJeMQqKNLvsvTxf2o0HYDZHtXEPKAhdzcAKFLbcHcODdQb92sNSHS876uLBCl5cHbCz++9/zD3Rwp0FeXToT0IKpeMkSSLg2vcy/DZv3gk1iknA0KlMb6Ki0CtS6v7aAX1/e/BXxCIb4OwWel56YLLKMO6va7Q5NtEWFytIINmHoh0BwH8cf5L4nuHeVko1VoL4QO6AJWq9vsG57fVG97MC7cRd5EKSId8nZEEZuvyINoqT2GlTNhcXl0sb0ipj/a9JmIr83qgK20SD9/Azr2Kul7kyAv/M/kd9hnQWVI00PXCA5eXK5lEAOoSg8o0i5uimO/xAFsRl5dJAFmtm2gWs/DKWZ9lDebB1jAK/hAwjOqBeUOf3IQOh6m2q/e43dr1CBnofuFCAHICt2vvrkZFbolRi4z97z2sIq3a01P2lGetLuBVLH2kJiasBIbaehHEum0IfJI6F86JejGPnq2Frvy89zTyp3Y2UkILmNwR6NICuRxw1jnALteTHdqjWaX8xiSixzow/Yf4MxDEXbRjJl6kOhwQ+3kwhAWDXl/p6soj0U2M7//yZvYEanWKektNPwCGjwLBMdiPNj/oy1STPebthwjkpkawMyeaYFv4F3imTngQdBdWqQbv9EwfPO82VDFkza93H/QZ5BZyQDsmJEFObz0Hx7jghOiAeUKqVoEtfZNyeLBanwCK8pjZS4O7oyYQ3m
 ysoUlu8M
 1ZBe3psn1TiFuT9txrbWXKJA4mWOk8kZt/Floy2SRagJFjDXEGrPQk0d5Ke9VTz7PVYDucvWXDl3UO2jiKiWGqDizUPDoLsw5Bd3kBb6D3D1dGDdYHmxAhPI5MhH4cb0jrcwdHvrjd9IWGw9SbzPEW2FYIbSHNY9+t4av2y+uLzm4NbwoBwsitREvqTVhn7trDHt7CWdATxMkHXv3Ss9qu+aarCdHgn5a550CKTkLuxsh5fSKL9EkGmXOBkUFAZ8AHUs2cxCHU/eCgwjt7VCN3Ca5Ratvw3fJOxFK9lm70HCsIVx2k/d5hPk4T+SURJeswHu9iK6789E30BXW42+KxLcAdRYt/q2fWp5KfqpiiZBbSQiLbUh8AUkPyuo2XfOLkKYKYVXDxpyUPdfNpLERtzqvWa5LDPEiGrMpG2vK+qn0Pfuw/lTGN0/acE5GTPVe0gMeEQbbNqQj8pZ5dNMsXyOximq32i+IRzZ5FdlZHymTnGOnjKM2L9NIA2ouA7DqT9LIfILrecz1T3eDztWUi+ty616kgXn2CJquyvd5UzeFw8tYz1MeSdRTQJz7kwkFjnT4OS2/aryHK6Y9DXfhAefnFTossl6bsBjNbD1YOOK6Cf2MKoZLGecBkUoCAEK83f4LaYywlPMXLMfC5t+1NEUOXFXvKapddPFpjVbo3EtjavI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/21/26 5:57 AM, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   053966c344dbd346e71305f530e91ea77916189f
> commit: 22228c860d2633a22656cc506022c657fec15194 [7687/8302] mm/kasan/kunit: extend vmalloc OOB tests to cover vrealloc()
> config: x86_64-randconfig-121-20260120 (https://download.01.org/0day-ci/archive/20260121/202601211250.6uQzZrQp-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260121/202601211250.6uQzZrQp-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601211250.6uQzZrQp-lkp@intel.com/
> 
> Note: the linux-next/master HEAD 053966c344dbd346e71305f530e91ea77916189f builds fine.
>       It may have been fixed somewhere.
> 

Yep, this has been fixed independently by https://lkml.kernel.org/r/20260107-export-vrealloc_node_align_noprof-v1-1-a581bec13054@google.com
It would be nice to reorder the patches so that the fix is applied before the kunit patch.

> All errors (new ones prefixed by >>, old ones prefixed by <<):
> 
>>> ERROR: modpost: "vrealloc_node_align_noprof" [mm/kasan/kasan_test.ko] undefined!
> 



