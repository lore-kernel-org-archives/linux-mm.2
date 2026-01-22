Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7603C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 103C76B016E; Thu, 22 Jan 2026 07:13:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE506B0170; Thu, 22 Jan 2026 07:13:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF3796B0171; Thu, 22 Jan 2026 07:13:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBD2B6B016E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:13:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3311B7C21
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:13:07 +0000 (UTC)
X-FDA: 84359489214.27.43AC7CA
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id BA5761C0003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:13:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kfUXVKW1;
	spf=pass (imf20.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769083985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UvVMyc7Izyekg4erNbUiI7MR1H3oQdShyZ4b768kWrQ=;
	b=3mwKaKCTPgjT0f99/TZ9fsm1vY8O1p9znHhhs5yIlWmN4TMO2X4lbztlfxZh8KA3KdAVbg
	IExOVJOQP+FYXiTomGT3MdL42rR+0U6MHyq2h5jLtgBYMPJVqhY2orh+LNDSj8GjNynNzw
	Jug/PWUn3j+6oLDdomudhYOHPFd3SFw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kfUXVKW1;
	spf=pass (imf20.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769083985; a=rsa-sha256;
	cv=none;
	b=V8pdJgsqwk6+4IqenTvVXeXD19AEwjIC+ASOXVLfSn5mfE5NXxF8p+ukvjldVUnY2LncV3
	RHQmm7MzKtClN4IXGxM/GSjuyeHt0qWwuqXHVKg0+XkEc5NFl1zLgO8hSUEY3oAA1vz5zs
	ZjcowbW9c1jRPuZ6sveJOGj0koVx3sg=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b87003e998bso348772266b.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769083984; x=1769688784; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UvVMyc7Izyekg4erNbUiI7MR1H3oQdShyZ4b768kWrQ=;
        b=kfUXVKW1vcD7Kubtmv7jj0GkHdPQaLgRrh9fadGJn98hS5coSx7rMQxZlmLCspT1JL
         YbvTtu9P5y9HzjLwvR0vhVTeyei5Tzy98gRseMxypty3FdhkpWTdXCsgE0xTy2HHLju+
         qaML7WxXQtnIQyzOskXgnCGTCsyWw8aEti9drqOdH3KXwZkeNCdXRKFrb+JgPKf9qkFG
         nW7H23IQn9yfvYN2AyUIFlA9FwpDxQ/grVy96+sBh+cg7rH4J8vmdqJ0aS7QN1w3c51c
         18oZuLVYrKt0vQunKcBP3ax0LkNNdUqYJGyGngnOWP5PWjeiX10+yrNANcU1llArocT9
         rIpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769083984; x=1769688784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UvVMyc7Izyekg4erNbUiI7MR1H3oQdShyZ4b768kWrQ=;
        b=gxmhsZuqYVG00+QQpWoYonBfurWbr2vxEhC7ktH944kX0ZOxB0j7G1Mulrhh10+/hf
         2k3XGCvIthqjYf6PSWDSLwalOsVRATOXdjaJfTXjVhgvKPF5Z1L4lO5lvzEVCq1qamui
         h0T25op5OV+UQJJbzc9LlEafFT+C/6g7aiA0dxC55ETozLGxVyx2yfQWEZayDkTgis1l
         Pi5ZkgjR6m5iU2wxwXNcaUWwmG3HSMKUqfcyYZkajCa5sDSL5qQH+eIAKY3w7oTTS8L2
         SUqcL/vPD/OeKCfv7wxqVMY1TVo3a0ne6vCnGdOSbkxaCKt6PsdBnWmI+9q5KMQWkFvO
         xwXA==
X-Forwarded-Encrypted: i=1; AJvYcCVRcQZkyQF47QQzvAtBI2qmdDbsqm4WCG4a2OWY+OHQJsFCZANEpIpbv0ooGohn2xGs2eEhZzFNAQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1fash8zt79tCxb6Rqonz99yF2xyoL25hAD15z0ZyEZB4JANp0
	Ujj7J4q8hmcSid1+U8lS5KWSI2mlkV/m82TT+vmR1bCS2tA+tXhhAVd/JB7a+Q==
X-Gm-Gg: AZuq6aIFzHv+dTkEnoizWWaCRADGxfuW7O3sFxztrnafk562E+NskYzJyVZAAIhta6g
	egWhKGF14ZE/kMrUXocLkRrurX0xpN4PT4EGex8ra62LBgOIHl0x0fP94WciFN+t33/tjWaWa5s
	mo+OrcMWGDYJ16qUL1BqfYSSOSwJVBlwjvqSk/oy/PQbV/kQo1Y0x0w/sDvIFVw/eVTsVvK97DC
	Sx8Ev8qgyOqPR0kHxUs7fPtsNjFjhjHKW1zeh7Qic1+UA8uXiOgUsSiRSihv+Fvp1SCGVOM8e/R
	apG49a5WLOpFS+Gl7RPsNPdUXIQwCjYD2wZ3t+W5nK/WU0enXx8LuXPii+aIzXNYS2b92cPhIQA
	1onlQGs+PhGeQPmfYEA90khbZal95huWcBDCXIAdRmqbx2/xm9rYEKdpRvnQKrRwrcYr7+wYRmA
	KJb8ebvaNagB5QHr1l1sqlMneC0PVW9Xz23rK+5IIYoLqJoDu//C/F
X-Received: by 2002:a05:6000:40c9:b0:3ea:6680:8fb9 with SMTP id ffacd0b85a97d-435a5f4da63mr4516285f8f.3.1769078019504;
        Thu, 22 Jan 2026 02:33:39 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356997e6dasm45262285f8f.32.2026.01.22.02.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 02:33:39 -0800 (PST)
Date: Thu, 22 Jan 2026 10:33:37 +0000
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
 Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH next 11/14] bit: Strengthen compile-time tests in
 GENMASK() and BIT()
Message-ID: <20260122103337.26473d1c@pumpkin>
In-Reply-To: <202601221237.soiAkwkN-lkp@intel.com>
References: <20260121145731.3623-12-david.laight.linux@gmail.com>
	<202601221237.soiAkwkN-lkp@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BA5761C0003
X-Stat-Signature: 51yndq1n3m7j565wdcikewn9his6iw3q
X-Rspam-User: 
X-HE-Tag: 1769083985-132678
X-HE-Meta: U2FsdGVkX183ca8pp2hq90bKfzzDV1x0iGC9H4WNs2Tu8YehlA0QElbU+ajWhNqsbcpVLemKIurFpTyHFRBwOAGlJaMbJHh9nKMhOAq3pQTBNR1t9c+qgpV6K+RpNCvDtDBDDo2u6MRAcpySnTpyppd3JcUHWXgbjTlIT9sMYkeXk1xEWqudO2B/QO3ohpjiRxSSYPYHKcZq1Du7GrbWmITvtOoUtYKQ8TB5xiYZjLn7ou88ePBUVdxhjkHmk6B8EDiNiATWYzktp94rx4/5Z09vMQggjdceWNoFCG1Zm50JvgWg+NKk9gfOK3dN9S1h4wROtbWgSecY8vVbrfLcB1DeKLWDjJYyz5DQV/ZunteExOKX5g3Hv7u3XbGtPH+XdD3MvhstNa63eUlpxqfjGKjGXkSdYRmEj9dxac1mejjetjH7FyRm/+/sYKoo7n0tMZy4pVhm3oxxG9gVPfSjG9MpR5noDe22dUy8REpTI6gww/f2b5blIvpLsI2mthQQJm8QuqxAhZVChrf/sO4Trz7u+mZG3hy8k0+VQFzB0M0uqG1RGimKpP0AAIQSzABL7BaGu6Sn1B7u+/YieZAsNTLmBwkSB0C+dinqEg0Tz4jdMbbTOM/Uq3xMZDKKDJenmwaI+Cw3iTX9ZktHw0QNEX0kiVB1UjjOEgGT3XeZCr+m4U5Zd+8aMy+S26FIRsLdGpWmO9eXWE8VY2UyfHZJLN6es+1jouj3X6yqwf8pQuAhEuM501chT7Fj1sJ8RlJ5ehn+4vexbHwZ3PjB8A1Nu33YAeBPxHy9JeMX0TKT69y7ASR6560yP7cHUL+cHEkNrBP8O+rS1Bka8xAffA/5udmld5oFKT7BQCwDNnR5vmidr/DOASPgNBCBPxFgNzHAQVXYxaLDoQAelpg92cJjrLTzFNk0dvOVHVyZ6au5RB7yqvYOCyEptydukO+4t0LBT5LmosVZc+6jk/JHQ1X
 tNUBbGrC
 Z8nNqUlMfQOgvKRy3zIyMWQVEmuWOqVz+yU+kuRbLq3km22Y1WvB6S3XR4WdhzpisTZA6zjgCZ5fXNsM5R9oOMQxwHYCoHWHKDa/mUp/Xbo46Ixl+BSLamiXmxIHnot5SCADx9BMXprVBq3HuglLqUelWBHZNQuMZ3ztMFyUt02pOSLzqNuQBFLWNM6QGtxHumGF3VhkctwE0lV0Pft6+h1CNvMsacu/KfIXGPkbuNme8nKaIIQC4Ma5dSHli/dgIKi2klFwhpKVJJUTnJXuPHGw/nzBnMZqdjUR2Q0ufDz+givfjtU8xYMHqaoYQYSn4Ux30h3z7mqXgXA/pxbWB++RXSG2cpoqz6/i8yiJfjD/6x00vterY+h9BkkzIMI+0NQWTMovDLkurMEDfuV2AbefBTmxzCUQoH1VL1Joyy84uaBepiKjzVwvM+tiRpZwKRLCm1/Ac36Bb2SwGTfapzSW0obi0FwqmnruBVE3lf12RjA7PiEGIGFoAdKJvDmZG2PUBOydtp1dX07KszbpjioC+/dXJ6b34tUIqYNnVjkEcIOMB9TskbSI5vvsIszCmt8FaCxtzdXuaew7gtTx20uRXtEPy9GMjdzAIBb67LJNmiKye+1iNybJ8PXi+k09NMBVrAGsaxHF0YolVvLZCV4xwMfJSG5lT5X1PhoGIos1B0QPbS2gN5y0NyIx56z6JUzDPd4Ar4d+dLZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 12:41:22 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on next-20260120]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/david-laight-linux-gmail-com/overflow-Reduce-expansion-of-__type_max/20260122-013456
> base:   next-20260120
> patch link:    https://lore.kernel.org/r/20260121145731.3623-12-david.laight.linux%40gmail.com
> patch subject: [PATCH next 11/14] bit: Strengthen compile-time tests in GENMASK() and BIT()
> config: mips-randconfig-r132-20260122 (https://download.01.org/0day-ci/archive/20260122/202601221237.soiAkwkN-lkp@intel.com/config)
> compiler: mips64-linux-gcc (GCC) 10.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601221237.soiAkwkN-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601221237.soiAkwkN-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
>    kernel/kthread.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):
> >> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.  

Can we stop sparse complaining about sizeof(VLA) ?

	David

