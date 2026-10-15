Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8807FCC6B3C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81206B0092; Thu, 15 Oct 2026 07:24:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A54426B0095; Thu, 15 Oct 2026 07:24:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934FA6B0096; Thu, 15 Oct 2026 07:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 742A26B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:24:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 001901A09D6
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:24:15 +0000 (UTC)
X-FDA: 85324626912.07.8AA713D
Received: from mail-oi2-f0.google.com (mail-oi2-f0.google.com [74.125.231.192])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2772880008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:24:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IOxKhoZz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.192 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792063454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Y0ZwfiBQ3RpBcxHsrin1gDEfz7uV6dXypoeGwMb2TIw=;
	b=GLr3hTKYH8wo8A/XtuGHRKWAYU9MaoUtZuEakT+XTFYA1nyEN/VLNNZC+auyY6Ggasdc0H
	+0m3knhhXl28/MfhmCiC6qxNaTCx6v4HGUGvzBVDgKSGsOkpeU36I9+j+TQLdl3lEPV8C8
	7JimKWpg+ixaFqtSlQ/pSeRlc5LnHWw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IOxKhoZz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.192 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792063454;
	b=z5yYLISFg00cYaDWNwQPUN4zWncy3ybGJPe/SC91V6gNwktsEe0rLJwUJ5dHpRhF8E2U8P
	fiiXP2vpbAlJ5b1gQvH4IeAqBs2ZHbyrGAsuPQ6OykO6tClv2z4SqlMJZM5FLvBHtiZsUo
	ZUkDUTOErFq4nNO88kSTCoLBU1hLN2A=
Received: by mail-oi2-f0.google.com with SMTP id 5614622812f47-533fe730856so131748b6e.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:24:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792063453; cv=none;
        d=google.com; s=arc-20260327;
        b=jWi4zpobmZjGp27B1bp510Lo6WfTxZPcxX+SDsTRgoG0mx3aPDq34ayano8sTSTARR
         G8COfWKVO/Y4MwVQP2WIPaRI1cX1pP8VsDU/gtm7xwpx2RATKT4SYx8Z6iarwE3tByyo
         3nESmiAqS8JP/l6GZroUCwDxAUdHtX3dW0sXxHinVYIuM117MfOPyb0h47M0V/e+1QGW
         J2JMzbqtlRhvUOz/ZoI76iJKd3DQINr2kvflU8OGDARO0qPHS3XUYoV/edNeq8U6NQUk
         eiggFtm1DqfkRb2RnoeOAAFSyk8Yvbz0R+ExLCCRKQQtugN2XRNvIi+4l+Mm8NSpOdSW
         tzIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Y0ZwfiBQ3RpBcxHsrin1gDEfz7uV6dXypoeGwMb2TIw=;
        fh=pVHU5mDvMqyK0CXmDeOB0iZ9WNn8ffM+QTMiDEmRaNI=;
        b=s4xwsaJSO0jRPHyAApCI8ugJmmnk8KUg/h0jztYe5KQAOrSxRKMn4yurfZ9DE9daVa
         hEYzmy6Oh40/q5srTdP6PCeBkRnxYFD9GQb/Ykhi3wj/Y5Qsht2W1ScAbaGY2GNUMH3w
         u+mNKeyddzlch8oYjhPUta/uzzBvW7XmEu8KzBAg66DZLs3JqgGn7nKyB2m1lmTO+tCF
         BwN+y/SHj67fpuU4VpO/Xr0Xaei8VPYrE1HC01rb7KqHWHiqHfjBvdI7IQMrQlu7qJTl
         iH9nD+UJodtYYTAR4rqoJdA1NTS2VYDFODG97fOz1947OAr7jjkD8RSk59ASIn5NUk00
         7umw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792063453; x=1792668253; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y0ZwfiBQ3RpBcxHsrin1gDEfz7uV6dXypoeGwMb2TIw=;
        b=IOxKhoZzOHVPKfN0IiTPiuF4+fnaAoHXSboo5ABtVrN06YORljMopMqT0QufxqWBM/
         X6Zyq2HUbt92ykg/Hq9xKv19yjpqc141xUnBxW90NB1jXu87pyftz5F2gdPyK++H8X/G
         sMnj8wIEfluLRoan2VZ1STnwnkerseWcqDANnuYvSz1IJ2N+gJnIY5P6aYXhpautizML
         fOVQhVvapoBNCkbR5mZ0kXw0DSJBidK29wdL4YGTmC62Q8smZVUr4klYNAaxpMS8GPyL
         /lbUrZ9BeBdWu7tjnQJWHCVzWfoDbdCW+liqhCzBbMTkw0lYmiOeL0QfHPWch32B5VWm
         34pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792063453; x=1792668253;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Y0ZwfiBQ3RpBcxHsrin1gDEfz7uV6dXypoeGwMb2TIw=;
        b=PSJnLFYrepr0cQGDNbIpJP0i8bILaAYqCqPBmw+GSW9BXvh3jIbwLhAU9/92wipMfE
         T2DK/EJSTYj8AXeB+RlaI4NMX3Sa9pAARzKrw0od76Qb7jH667qMhtKXvrhM6dkBUnWf
         tPUyAd2NGe8bUtrs2kesPIVFB7i1J5RUoAIERlVV6gPVOEGd64G0rebzlSI1LN5qy+HI
         56tzyVluSds909QaSqh/DITI6eqxPH5e6NL4MWUOSPPprUDXXHEtalGiGuCHm4dTFC5O
         Oac67+qDYBCmrtKErDF+dR9bS0M8W5WnUl8b0+M/oo1YRC2G9kToUz5Mw8dpVgVbOsKs
         x8MA==
X-Forwarded-Encrypted: i=1; AKwUvBw6E/TgJBpyqDLUKuNQm8tSaR50IgQqUMjlEwz+8tuo+dCgFzqQEFNYu5e4LbAkfVRF8wKlQcv3tg==@kvack.org
X-Gm-Message-State: AFq9FYJFs6UYHyLM26/CHPI4nR9p9pUkaWqHvLRwM+VXHz88mkODGVrk
	Fm8dllWWCur1sJ8bLLu1fkdy1B0J5ytB6uWqvxHTz9ju+jhYnNA9yXaOYjrU0k5sztJiM9OG480
	zRqTm+4q5LJNcv6wty1BMfl5hmgra4LY=
X-Gm-Gg: AYBFou3d/P9Tm3jhLnkGPm/CgwZni4jejsjXt65P4RhYzP4QdMNzn8XTPlqkc7DRGyY
	RLl7OkuZzMmJc8+tKOlB4muJv8gMY9Nwp7+xfPmTi0nic1DeaSNvjiDufK9HZfUa43OVq2xg6gb
	M0wl9Bi3hCskSWHssBa3+owD5IRTxnclG25fVP1/AlXidIg4dvD136J5J3ECd3ts7zcP1Lqb7og
	i6Oklw7p6Zmgur3Up8YRDdHltl/tjIFZ7ywNbT/Ve2YQutbdoempRKn4o5+TXnmgSTMk+yj28Lg
	c8GHu1gDuZbeaU7UKNXNHs0RCK+O/88BRmlUegMlRLA3frCsTvDjHykl3kkE5dcMGCdE2ICeRwP
	m5PnwU0fHzZYK6+OHCYUY
X-Received: by 2002:a05:6808:138e:b0:4e8:bce4:993d with SMTP id
 5614622812f47-50c4e683baemr14333600b6e.11.1792063453079; Thu, 15 Oct 2026
 04:24:13 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 04:24:12 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 04:06:49 -0700
MIME-Version: 1.0
From: Aveline Noir <jm5905938@gmail.com>
Date: Thu, 15 Oct 2026 04:24:12 -0700
X-Gm-Features: AclHuK-Z1dKLpbNU8M1HVDhdDlGkqdOlUqMA7Se8cYihkhi6OUAS2FWVbX7zVVg
Message-ID: <CANOyQmHad1vamnZT12M5yPrJ69==Pt1U0+MGw6u0MuNtr-DRCw@mail.gmail.com>
Subject: [BUG] DAMON_STAT: idle percentiles out of order on 32-bit
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2772880008
X-Rspam-User: 
X-Stat-Signature: 85qysxi4fysp6pta8xk37ennsddhnx8g
X-HE-Tag: 1792063454-484771
X-HE-Meta: U2FsdGVkX19gSkHSO+v4Vng9YbHWgi987toZlpGnalxPUKSXCjH90Pxym9FOL+MZDDZ9o3+yJSciaAA4NbVTO2dKn96QykHreeUS683EBYzHDp0bXzEZtfQ86HdYHthAjP103Bh+MtHATKyNGP20Vi1tgYer8FahDyN6dSGEQrBg6qWn53CoiXJxKOltUD2cvblcbmLo5/oTsEjv9OBZ5hUrkNUwHRcYc+8LneVrYzVxEE6AwKucbIWX57z6e54WJ9hWnLw+U1U6TOHxRRKFhNdy3ys8i39R0kH1q0rlnALEpVE0S4cz92yoWtJ+QT7t9uDWjvI4cnn3x0tstCupuZKGlVea3UVAKx01Ad7TceTfL3WOmImaDZg2VwOp7RkZ5u3wSXvqzMZW2uegbV4L/p+X14yTrwVzAQC+WUx/hEnzAjvDjHihLH0Sdc6gM59/JWkxDQiOHCTgpd7gpsTZd1WljTmKHqjXfP/RsjkyZL3gSTAqqMdyHLWx9mIpFrLqlrHTfriNf/vPFkFWa2Bc0hr/eXW+6dN0p3MWalWfF9pEhEhqfi58zaV7X3vO/Y0EvstVfnsseXvc919YFnjlMtrCa0UdAV9gxVkz49eyocF+OIxE3DW44wB6vA93LNVP3o8RyN7yYCVPFx2M8f2H5ssl/C2CbHi3xzyHdlTjtOT3KF8Tw4eYxXxLjo3xPtOlKDkk8YzlC/rdsWVVXapL93py2Ck06uzoiA4+CE9PlmMveaMAy0/d/2HTu94iIicGiKuhTeKMADZwCicAN3GEm3hvIUqSzUHMTQcBwTssbRjWu9DbwGGjQwwxHfoF59C5u+uktI2+90bgQL04dvO7cWhsgjGgB74H97VWfjtLnP+Y8ohH4zIeNxUnJrjKObYdbE6B7pV2U3/x11xuiT6bmxp+YFPRZ4AG3uzvCiUfeH1jWZFnHIPrvcR5rBi/nd6/k2QDnS9jyJIDJ3HmGSd
 zSXpRBzb
 NgNZevtebI/26VkKtSDzLk/HFw4YAfvKrohV95n+GgcgEAYPyIJ4pNVmtc8Rco8/NuIsrKks+zqpUKdgdfbRZv/Ygv8rI5r7jXlJE16qm2o7eyUdrQ4StE/bDTWCkhWC3hnwfWOoXKCO8Z9Ibk6WXeJSRDcoY/NZnhh6FIOoxkHrObdmA7DcFm6OXxS1p7jqWiF+tTfeVX24eqOi4IbVBn2LFfc5v6RBHYTLZkffK6zAGpUkVJwSXDsqYwh12y2QMfOrWJZg0QDqPBo0kWPyROLInKGGtEAk4Rm9BTSn8+b3DzOdAPt4SKxJWFSzuBikCtzaz/qbhbngEjtnShb5WSt/tzAbE+RETmXdfL9vFFL58s5c0BbNP6GTZCWKBu35NoDj37/nBuCMMmVu5AQNuXkoXZmKU9TWDMXvDyNR71GmVJIDPyZpBOO61G/QhnQX4BjYjojpcVCrf6t+UBypmunsCfJnOKE/paW0FzQz1ARZg7r+I+KpqnjpEhWEVLB1aq2Ieh5sE9Ms3IqR+lSVo95DguQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

In an i386 QEMU guest built from mm-new commit ad9f2d463666,
DAMON_STAT reported these memory_idle_ms_percentiles values after a
statistics update:

  guest uptime:       22.51 s
  aggr_interval_us:   3200000
  percentile 0:      19200 ms
  percentile 50:         0 ms
  percentile 100:        0 ms

The 0th percentile is greater than the 50th and 100th.  The guest had
256 MiB of RAM (MemTotal: 254216 kB), a running kdamond,
CONFIG_X86_32=y, CONFIG_DAMON_STAT=y,
CONFIG_DAMON_STAT_ENABLED_DEFAULT=y, and CONFIG_COMPAT_32BIT_TIME=y.
aggr_interval_us changed from 0 to 1600000 and then 3200000, showing
that statistics updates ran before the final read.

In damon_stat_set_idletime_percentiles(), the loop compares

  next_percentile <= accounted_bytes * 100 / total_sz

where accounted_bytes and total_sz are unsigned long.  On 32-bit, when
total_sz exceeds 42,949,672 bytes, the wrapped product cannot yield
100%, even after all bytes are accounted for.  Upper entries in
memory_idle_ms_percentiles then retain an earlier value or remain zero
on first use.  DAMON_STAT monitors the system RAM address range, which
exceeds that threshold in this guest.  I did not capture a per-region
trace in this run.

The guest init read the module parameters after 22 seconds of uptime;
it did not write to them.  The i386 config, guest init, serial log, and
build/run steps:

  https://github.com/jm5905938/kernel-mail/tree/195d7017352a3d0f4a0475b98f3b03650f5c14ea/cases/2026/damon/2026-10-15-bug-reports/03-stat-percentiles-32bit-overflow

Thanks,
Aveline Noir

