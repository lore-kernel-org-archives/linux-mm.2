Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA59F531C2
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8205E6B00A0; Mon, 13 Apr 2026 14:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1056B00A1; Mon, 13 Apr 2026 14:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E70E6B00A2; Mon, 13 Apr 2026 14:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA256B00A0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:48:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78AE157CAC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:48:43 +0000 (UTC)
X-FDA: 84654418926.16.0F52BEE
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9AF8D4000E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:48:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KHOc3x15;
	spf=pass (imf04.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0aREDMjRidCZcq4u4mnPv8wxvNLNH8eRVKWhe7k1qAs=;
	b=q4ybtQzwWepYD0/krUovTMwkvtgFbUOsEMNeW/WdQj00qGqvwTlxPSFUNKI8bKBAUawcUm
	Qd0zp4FwW2yiCM26jgmnebamVEhZY0MJCsSGy52rZ+uWX00Uk2SK9zlNXk1ukEMPptjzEW
	H9e+Gkggf+eKb+iliw3gIj6mirpqnqo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KHOc3x15;
	spf=pass (imf04.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106121; a=rsa-sha256;
	cv=none;
	b=ADTj7al7DTkxrpNchZaTMWZg/l+0qT63Ptj6rplznD9X+gHDdsbeOtWANhxcchZ8b4R1M2
	iBvP6O9CwxShtueK84tt9EedIe8bxaQw4QfKYbit+f+KUlIQ/is3Q22d4v3+gPLyW2zTkw
	vIOtnToaACAVRRMS4VUQ8Y/P1nehvEc=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b24fdac394so43178295ad.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776106120; x=1776710920; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0aREDMjRidCZcq4u4mnPv8wxvNLNH8eRVKWhe7k1qAs=;
        b=KHOc3x15E5EMXSHrSsiSfKfOZvJN6BeF7D1SIhpUi58Y1j5lj6ZH9Mj29YldO+30xB
         i7n6cww3uZ8fgJrESvaUfk1vVFgFNerrQ+oHn1AIJBgly9EXD4A7ISbFwj4quys8nFba
         QuvO6et/UO6fXWMSEtnjqzYuESczLKYGV+m/4fP2RaqpRbTZKLAhN7KzmbOaful+HXZ3
         f2KI1DcsP1mYCl1DVCmSUTMaCNK/RoS3koX0V2nUx91NplYaxCI00g25Yufwb3XP755t
         deJ188yUlwpK6pciz9yRj6oVPrCfAxKTWPlKiQMNWl+TPdUOwcvxPDk0rdBDvKvYPuyS
         JwkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106120; x=1776710920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0aREDMjRidCZcq4u4mnPv8wxvNLNH8eRVKWhe7k1qAs=;
        b=eHJJiJngJHsiZ/4AxjGX5sNNHO/YPFAxiJsfHdZ1MdmbTwj8+Izn07vxXuG3NzSAmB
         0yRJ9Emlz37k+CdgWAuzgf47KaXojW8eA0pbP6z/0onYSPomHrbajPFDTBTjUqgtNybE
         1WOAYr171s8KuKVGZPIVPLyQmMfVnVuArfbPJn6gvSmiCg4NJT7kMO6d+52V3jZ0nLrs
         e0zrnL0InoL2Gba6efIlMkueDU5R6xy1jVhyH1+P3LlESksZk/4cUwYORqDQjSBjO8os
         TyMdMJzOydoVdorTUL06XSVn6kKyLv1tRgn/A4UoKc6lYcdSKb+NqQm+fHxh5OpWuUgS
         o5ZA==
X-Forwarded-Encrypted: i=1; AFNElJ/FC4+p3XOvYNH8vCxOTb45vfjM2E6KYjCvQepjUR8yylyA/t/2DvTnBU0+lHMemwKJTjye8yb9xQ==@kvack.org
X-Gm-Message-State: AOJu0YyU/HtILx6nEGE38vT9E1i65iK6UDJ6A/dNAIEzSBxludLEGJeB
	8Hxxm5s/SLRsbvANj7Rjv4quZGG/DzVOz2kheJ/yuG86vZi27+LvoyoN
X-Gm-Gg: AeBDieusFtB5Q55uLkgCi0m2YesbrrmF8AiGc9vAHkHRXQ2KXux6PxvqnZI81t/Kvho
	m3BQvgHzilk8EzBgo4/3//TgOhHCRXGiIrc4p4sshWIkqyiakRlLw7UBwDNH/mNVZJ371v0+bGw
	oqkkiYwkPV8Z3uO8vx6dx/lazUkjqDgL+x0rUuaiS2dYakpqCOEK3m77DN5P3KcN261wRQx+bkd
	OLtce2Lps3cGkW18ht0+YZuRJBJzazbMNIYcBYB/iSY10ka5rnW1iHl9v2zKaZ3ItzA9k5Wv4jI
	jqvyA3ObfB5K8iA5cOnfip1x00ubzosNsfdMZWiFfweWL0MSCMeuZYhZUxlJ2FpYzVkjU4nb7K2
	bIJIhP3bPUN7omFBLkPiMb6opaAco6gIcd3+0k0h2eMf1wlqtpupQLI/sR88G4mLewkPCh8xx3K
	BheAHNUysUzP7xLSoAh15p1gx2mkDfANUBh5Lkne0l+aE3p+8QfGU=
X-Received: by 2002:a17:902:6942:b0:2b0:6e12:bb21 with SMTP id d9443c01a7336-2b2d5a9e7bemr101327845ad.41.1776106120273;
        Mon, 13 Apr 2026 11:48:40 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4dd5cfasm151072175ad.18.2026.04.13.11.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:48:39 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Tue, 14 Apr 2026 02:48:45 +0800
Message-ID: <20260413184845.5130-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260412213720.89145-1-sj@kernel.org>
References: <20260412213720.89145-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xwo8pd76o7t83k669d4znmr4ss4i7mru
X-Rspamd-Queue-Id: 9AF8D4000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1776106121-333750
X-HE-Meta: U2FsdGVkX1+apiiTJ6Z4qD6iTmYjVLDdYAW8IywK4MX+dZbFHSeUF97yL63d0aAiC7R+Sv41e6bHqxRgpRp2Op2IPrLjQsIjv1J9XZzbZLyyIYBlhTAb/fhMhCvyquKvzG54AXEW9PlUreJ9M9NHeO7eYzP0/ThgSpzK6b/ssZV8tYD+x5BgHWpxSfiA7dpPRNjOPxx0MGvj9Ci2Gw4sfnd3yjoIwHxWiU6mDxrfGZU9PpsMVxSQ8Qb0Hx6LJcuHu+POTQuEUnqh0FtQS5tDPf6FOic4TPmoG316yKo3fRlhW5OHX00SxBX1iej2+LkEbIatF7zfVP05Lo246u50UHWUyqtZfLReMADAL9HUb/F2QZ7u7RkUwSLEFAMXfJ7mo8LaHpkmhZutqxHrH6rXa/yJSXnbFiVcgnDq55g6HTeCz75v6fqgVD5qtJtqHaXnP02MEVVwzo/om1s+JDKyRPBpmpcbD91eop74JbmflUxtRjh8M2Ycg0RtgzCLFJR0kE2b5BjBHJGqfPR4KnZdNx0wHXx0dMblwhuY38d1PKX17CVQcR9g8nP7k93tovLDLvqd0XLIjO2OOWYxkdMXtI5Y7Quqxwi0bG4UviXDRgDtfdGLmF4ojhRDXqYZ1dPFzAQ6fXqmHbwVXCknyuvRn/Nr+jj2S66HRtiekYawTPXux0MmtC1t4pVrqj7GodFCf9/1b+OCHZA9tTIPfVWuVBsdZnaI51Bk9ZOaAxZPWNNsRpg5kkPgXpAW9J6CN1uh2JboDRt9ExuAJQj+M/JVjbSrb/EneWQFUAy0NB/WaqyRUHHqxucWZGQvvgog8OWipWbd4+vTFsWQt+O3tHWmLHGo6+bYTaYq9Q7vBqe12tDrlDvJbp5ifcoP9jS7cs353xzArxalqe78i7GzEYbFcBchQGvGXY/QUown1DGeoCxf0OP9LNe+k0MfTHnWljD4sddFv1VqKxy+lkf3VDh
 lX5/UgW/
 5ei0p94igKDIHW/cuW6LYaF3j67EVYkIvcHW54x0jl56bvX7Cz+iIru3se2uWqGm69t9WTCBpySGzUD05a5hBruqom1rouWdXXHa9XSK/NlmUc0ENnVBVXjWQCICAJaNT8nnpXpEgUNQk5YbFR7DOmHTEGeB2HykJI8yP8BDTHakIrLF3fLnY520dN42J7DLYfC3yHuYOouMTGCVP+661QTBlF7O8PkmyRW/7WIH08SgTYXUno1J+GpHOYekfLd7uB3bxq2SnWuu4wncEvFrfUOUmdZ8cwzKmcMUQcA1ta4BYUszyQThIdOtvAerTKWGZhdnxN6bz0PJEZM3WbGiHNTxo8YO3iP6dS4h9SAFobL0EGE2VTlpiFgjSY1w4U3KJFpBovWwG0cTLQdglyVVIn0Gxn/V8IpsRUnIMlpUH9L64699Ihzz+LZ5X13okd4QkCqKF25VMovpnSfe7FompzmIGPVxjJ7q5AdtuvFLq3CQUmyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 12 Apr 2026 14:37:19 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hi Liew,
> 
> On Mon, 13 Apr 2026 03:04:55 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> [...]
> > > Next Steps
> > > ----------
> > > 
> > > So, what to do?  Please prioritize series B, if you still willing to do.  It is
> > > ok to keep doing series A, but only as the minor user experience improvement.
> > > Clearly explain the whole context you are aware of.  Don't Cc stable@ for
> > > series A, as it is only an incomplete fix of it.  The fix of the one trigger
> > > point is just a side effect.
> > 
> > Yes, I absolutely want to continue contributing to DAMON.
> > 
> > I realize most of this confusion came from me misinterpreting your words
> > or making assumptions without asking. So this time, I want to be
> > explicit:
> > 1. I will remove the Cc stable@
> 
> Please also make the description of the patch clear.

I've been thinking about what you meant by "make the desciption of the
patch clear" for Series A.

Here's my current understanding:

"
This patch only fixes the case where kdamond terminates because
'min_region_sz' is not power-of-2. Other causes of unexpected
termination (e.g., memory allocation failures) are not fixed by this
patch. [Seires B] will address the general problem.
"

Is this what you had in mind? Or is there something else you think I
should add or change?

> I'd like to avoid delaying series B too long, though.  The bug is not very
> critical, but better to be fixed sooner than later.  If you have no enough
> capacity, please feel free to hand it over to me.

Yes, I have enough capacity. My exams are not until a couple of weeks
later, so I can focus on Series B now.

If my schedule gets too busy later, I will let you know and hand it over
as you suggested. Thank you for offering that.

> [...]

Best regards,
Rui Yan

