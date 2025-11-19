Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 110DFCF258C
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 09:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B3366B0062; Wed, 19 Nov 2025 04:07:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563476B007B; Wed, 19 Nov 2025 04:07:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451FB6B0089; Wed, 19 Nov 2025 04:07:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F84B6B0062
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:07:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3C8188C5B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:07:16 +0000 (UTC)
X-FDA: 84126777672.20.DA8D2AE
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 13B4F180019
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:07:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=evdWqf9d;
	spf=pass (imf24.hostedemail.com: domain of wangxianying546@gmail.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=wangxianying546@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763543235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=31EDKsi+GMiwsjeXqRgGco1DDBU69yUzSOddtHE5Qmc=;
	b=Mp4/RanUpscmdKtye9byxDOtBOG5vI+j8nWHCyRAUVz8SFKWQeIl9FT88BF1JSEJ6hnECs
	EdePogbxMSfl6Ng5ga22Eg9IXV51Lp1coMBdSBFJPDILminK7TTyUUGJJBXqs1U+Y8AJq8
	RBB9Li6sZDz+IqMZKp5bfLT6VNnjrJs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=evdWqf9d;
	spf=pass (imf24.hostedemail.com: domain of wangxianying546@gmail.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=wangxianying546@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763543235; a=rsa-sha256;
	cv=none;
	b=T5dLMDPZhb9xYIDG1aDmDfr8Ga0GtZQRi282fYC8Rm4IGmcwak0flP85FT74KGTj3XV3CX
	+W1Mf0pfIOIJoN/P2yzYURnBdn7Lnsu2qz77+5dw4jlZLKnnzab8zk7fqBt+u7HLwYEaaR
	LD1jnLZBHTArnnWQzvUdCeAxgqbdG8s=
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-937262a397eso1772237241.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763543234; x=1764148034; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=31EDKsi+GMiwsjeXqRgGco1DDBU69yUzSOddtHE5Qmc=;
        b=evdWqf9du7qKFUb3HPwKBHbu9ltXVu+ELLkZPIxXa2A6zpynOzz7zu9aLKoi4AS8O1
         yIOJ2rBRQL13LwTEFjAbT5RM1afW4ISuvLwRSkfbrcnhMoI5VFPBDy7PCV8puuAbUiES
         Qup1bgxPhfAM6prVbhtlRshlNF9CNW5zgVVEfPkT2pdLf27sVNAX18/merM6n5Vl4tOG
         k1RMcp1zPnpI1FVJkyiESRY4w3tZm/donV6GW3Rl26lhFjHm7PElOJIWeChCl7nf/bio
         yNNSy68DSBLeTRHWdd9zArod4tWj6hY3NOEEDXKaQqh345whHJqbIKtUsraBJFJ62qQy
         wKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763543234; x=1764148034;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=31EDKsi+GMiwsjeXqRgGco1DDBU69yUzSOddtHE5Qmc=;
        b=D3of7c5ZY3z67yJLwDC3VLCxTKsLUiN31Xw458XhyvjSNpt+1YCm1WsJAyVZ+k1+vq
         gGqRRia+TV0VWPmIr7D3/fCldol472SJE8jDcVLTbyIVx5JCUr3dzkqmRbKelzmUI1TR
         dFh3dWN96njvAaL1WjNR2V/Ckz0UQOk9Rd8UCXRnEyK8filFySQaplpXsksxHp3HnWpV
         AC1v3brDTUJDX3MgRUXh4ipYvV0iPw3i3z7frzSJBFc3ltPcXw8tEa96Fli4JlE+vDO2
         BoGH0X3KBKIQKQpH+8KYoM4n2KWvDv0pic6FgzYBBs6zQMlzo90U4H4p31W53zxes9kk
         +EeA==
X-Forwarded-Encrypted: i=1; AJvYcCWJPYUQNSJ4runbkmL/qWM41VWjq+4MBxXpaBovgjHXSLyRI5SnzCB9pPGwkEG71AkBZw3fOgzJJA==@kvack.org
X-Gm-Message-State: AOJu0YwJDiS6hFlzyChzB1utstFIvimz3BAAjueDHGhii72Vs6mf0AKm
	kx/LsiarFIjny+XxE5fmg5K+O7lzA0VY0hPSn7cOZP5p47J/o4oZO2km4vGItEimpkSmA3xe1+j
	qhyev3gPcQljb8yx6WVHkh3l905USm7k=
X-Gm-Gg: ASbGncv6CgtXc+fV3/meX6deHDHSDFmNHJn+AJMA7/q3K2iqzjwvUN5hyVi0AxvqYVv
	yyqs8CBx0hnF8OhU5tyeIYzf6tJSuDhdv6wK86YM2RFOCB4djVCGDLegnloJ2nOdVDYAe0u4wlz
	1cgUjH4mJ4spbmZ512kQnhyXPawQ0wEiVGjL4CJ2jYI4nBmYHwmcwwRcegT4ESvz71JyxCifpWG
	/yqD+kb9xsPQqMNctPfcCVrq0NrSXtnTQA+bFxpnZc525LpnjLuF+0ik2wk7a0CpDaB6hkoe4ZR
	N+zPqz9x2muzHAr2aweyLIuK80ppk85o7xOE38LTLn0D
X-Google-Smtp-Source: AGHT+IGIfeYL4yq8M/r9q0KPoFAa+v9cAjo/BAnvYRTPWqiY1deO74+eGtHIYu3LT+6cU3ClCVOUFhVlaY7Iv8zndfU=
X-Received: by 2002:a05:6102:330a:b0:5dd:b5a2:b590 with SMTP id
 ada2fe7eead31-5dfc554bb29mr6482801137.16.1763543233929; Wed, 19 Nov 2025
 01:07:13 -0800 (PST)
MIME-Version: 1.0
From: Xianying Wang <wangxianying546@gmail.com>
Date: Wed, 19 Nov 2025 17:07:02 +0800
X-Gm-Features: AWmQ_bn4dBgFMZQY_as9wLGWJ8jJBGbJRt6-HDZNmkFRaPNrjhLf6XosXuAUje0
Message-ID: <CAOU40uAHO9-59HB2VmCBfC5OiNg3BZBd-32jphtRd-nkvhD6Dg@mail.gmail.com>
Subject: [BUG] WARNING in __alloc_frozen_pages_noprof
To: akpm@linux-foundation.org
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 13B4F180019
X-Stat-Signature: a5kahhq9o93bdfy1wq7gjfnahekyzqku
X-Rspam-User: 
X-HE-Tag: 1763543234-841318
X-HE-Meta: U2FsdGVkX18IaZlw68+Uxdn0CAxpkqUIdykYLxVhfI1b7lKslXX50A49tI+bmJzSI3nfyM6iz/yhmkGWne9tf56Bezhsto1J7gKyKBeUlhfK/unV4i540LAisI6/CtdKtWE39zNiMPfz1SFafBsCGvvBRSCfnfx1IYqkg4MqOVgHzt3Zm4+RiARhdwGgC7nhtawK5Mzn3aqTlcBtFcrmBYcSw0fg4N4sBeySHjgr8/aJlggqQBJ5Wk0vdo0mKk2pJ/iqGwzX7RO4N3lEZsSgOtTP0rcF919Gbvn0W6zqkC6u5uHwOhnLUuzZOvo1v3ccxubk4GvGJsw5ki4TVMuT/uc5C19Pb1Pjbl7hZh1uoIHiT0QrcXvC4KhX7IEbr8w3w4gTwWEIlyiAk9eKeiwWkep3MVYhDbL/WrnoUT5mMrcAYqrvKRNUfFsYJGhgnA3mGtSNCsWa9RSdj3W7bm/iMPQ5dUtzyxmbI8Llk64UQSZSfvdmxJeNxcVQrDPjv749dzkb9q+IPNiCxZCM8cqMGZWp7xv5yBZohSF6wqSSqQLi17DqRe+o9y5/0oQaRcKRGeap03q5Q14h08ZKESqt6UHAdpzWkGUZU2xMcPALJWKb9J533wJVbfX+JsvYcjLe7tyA6lQEWj1MqWPYSjdouwQ/79gbJAqe+pj73YnaVxajhLNm3astEB4A/aUA2blEXbM5nK4NWKmUK2wrDny3jH3BuzTzZcO8TzWmVqZYoC/tL48M7lKzJQrpMkFms/zzvKBEYf59O7oouTeDvFwkZv5R6Tfa8lTWSVdhjtgj1YfPRyVN3/gjJ7BcltlLNmA5l+T/UiaSPQ2qG4Y8P1utbx0mhB/mv+/5g5t+fFTibs5S+otpfQjkQryM27uVfLjpZX2Ak30ImG5E+5/sPfn99mQbF/qHx36V88jN8fX/d6IWWTfXXPG0ZAZAre8Em56WJICeB+fyJwdVglCjXKz
 2X8I21ve
 vFjP2V5xS0VJvN90z/hAgr/4DsguZ2HNS7IE92cHL8mu1hyProe7P/ZcoRsw0XbFix4ixB6jGG/VjSDRZGoD+VZ2DexJ0PRjkoLAJZ7al5PPDj4SAsagxAPe3lTY+OlWZTYyMl23cKiIb06LuYg+mqXUz7dc/mfWldQI9rDsLLoDwHXMfF6h68l1/qEONiMgmqvhSwqg+aJHVVWYZ/y88yj+hN4e+K8TbmmsUztXDRyU/hd3BRzBFIcgOYDaVdOW2LBZJ1IfBGybMAJyQqA4YaI98U9WR5N5HIYvQKAbSIzlPsiyF43cbWJHecizTg1veMpwP9QshCbvOJzFROXLv62ho4/DRW733qVlEIEafKmcwUOhgTxqSEaxwsmbdKsVFrXEyJmCreRKxDYW6Rija0r2foJ1mq1anx8BHNL6Pjb9M9jiZWSTt2jMH+DRzPuT6AYUJs9HHlSWwu22hggxZHq+rXoee79QaBxC60VZr+8vyn9frRrITqeIQ0qtjjNXPNVVloqIt1mRSiy8cQ2Yr4OiiSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I hit the following warning in the page allocator when opening a perf
event with callchain sampling after increasing
kernel.perf_event_max_stack.This warning can be triggered by first
writing a large value into kernel.perf_event_max_stack and then
opening a perf event with callchain sampling enabled.

The reproducer does two things:

1) It writes a large (but still accepted) value to the sysctl:

echo 0x40132 > /proc/sys/kernel/perf_event_max_stack

(0x40132 = 262450 in decimal. This is below the current upper bound

enforced by perf_event_max_stack_handler(), which uses 640 * 1024

as extra2.)

2) It calls perf_event_open() with callchain sampling:

struct perf_event_attr attr = {

.type = PERF_TYPE_HARDWARE,

.size = sizeof(attr),

.config = PERF_COUNT_HW_CPU_CYCLES,

.sample_type = PERF_SAMPLE_CALLCHAIN,

.sample_period = 1,

.disabled = 1,

};

fd = syscall(__NR_perf_event_open, &attr, -1, 0, -1, 0);

The same warning is reproducible on both v6.17.0 and v6.18-rc2
(6.18.0-rc2-00120 g6fab32bb6508), only the line numbers in
__alloc_frozen_pages_noprof() differ slightly.

The suspected cause is that alloc_callchain_buffers() uses
sysctl_perf_event_max_stack directly when computing the size of the
per-CPU callchain buffers. For large but valid values of
kernel.perf_event_max_stack, perf_callchain_entry__sizeof() grows to
several megabytes, and alloc_callchain_buffers() ends up doing a very
large contiguous kmalloc_node() per CPU. This high-order allocation
then triggers the warning in __alloc_frozen_pages_noprof() in the page
allocator.

This can be reproduced on:

HEAD commit:

e5f0a698b34ed76002dc5cff3804a61c80233a7a

6fab32bb6508abbb8b7b1c5498e44f0c32320ed5

report: https://pastebin.com/raw/bCq3d4KR

console output : https://pastebin.com/raw/5hfk57Vd

kernel config : https://pastebin.com/raw/1grwrT16

C reproducer :https://pastebin.com/raw/GADWbwKN

Let me know if you need more details or testing.

Best regards,

Xianying

