Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D5CFB5EA5
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 02:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D99336B0005; Mon, 16 Mar 2026 22:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4A5D6B0088; Mon, 16 Mar 2026 22:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60E86B0089; Mon, 16 Mar 2026 22:16:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1DA76B0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:16:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DCC91A0455
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:16:45 +0000 (UTC)
X-FDA: 84553941570.25.911A13A
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 349EC1C0002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:16:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jHeZktnV;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773713802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nhjmtlMsBaQfrUE0dvJx/EvUUAm4KuyOEa9DhmDvV8=;
	b=vhg+zI+hEMo2FJ1I6Kgf2+ei/m3+WBhy1NV9pI7g+xCCxXzGI4O7G6UXQaaT9k0ERq5yKE
	vVKeZHyzKdkhIXWfHe5qjH/C7sru24/U+p6HyIFxhUZ2D9kx8vIWTLhIcopWSf+iVywjR3
	rxrQuq/sgO4lzF/iYUB46WhbXEfwSv4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773713802; a=rsa-sha256;
	cv=none;
	b=V6I9gOouC7PKeArFmYs78tmNy8RL/4Bl4QB6abkvmkp6gVJGWVQh9Q7FpclwpL0la9aSBe
	9lKfxeAyY1KCD+fzg8VrfkuovLUnYEOece+VptZ0oj72eSsAV6NqttDfDlKJ+0d+dgg8jG
	Ucw6ejSbkpeMQV20HhrHH8MWGuoL154=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jHeZktnV;
	spf=pass (imf20.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c736261ee8dso1731792a12.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773713801; x=1774318601; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/nhjmtlMsBaQfrUE0dvJx/EvUUAm4KuyOEa9DhmDvV8=;
        b=jHeZktnV8JO/0iCQE8IVFHz0ZP9Hy6xztLb+lsvh6ZhrM0oEMc4BlxtGsL9z5JcRiI
         KF4sJ/rjrIIT2RxpCuYA1oA5BUCv0C/guQbCokg4z9FtcglvGf20mv5uHxunlDuiMxGz
         XwiSrmwjc3MCQGQA8D1D1R/gKpSeE8bQ5CwWf6kF3Ka1dmMN1Crw8N8ez9jZdwZ3nErt
         nqEGgEizSjS+RzZyjy+UO7VpiI+ecuFRTHaf+w0HpSNzWwawikFiOGylaFMp1puJs4gd
         7TKElk8ehCDtA4putomk1Vl/W+BtYJbuxk6m3OYjoFJjFzZYgc8ujVSYcKM1y+AqHRHY
         TZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773713801; x=1774318601;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/nhjmtlMsBaQfrUE0dvJx/EvUUAm4KuyOEa9DhmDvV8=;
        b=ggn10DJd8TzIqCgb5hEatj+f3Yyf5PtzA8nCGq2GZLcGqGOno5zxuzrWXHpl4eeuR2
         Q3RbxxHsImtB9SnZv4h7YI1IF/DWSgDDTcDWuhR19RzS//QAzDzl3Fi/NMp/j2aRpatu
         +DnNxRDmow4as2IQCDLkFUP4WzavnYL1Be33oTtT0YxlITUqwQEEgtTbSjJGL9HDFuov
         CMOJfbXNn7I/mtr31sGkmqKmEMa/fsumLs7s+ZCK4Sva/wTG1MC+lXTAgP70VO4vZB/t
         Qt3QFM8IE0y++d/EOEYTbCmnRs0tG7tVnJFQ0+0yf04IYVAIGE/Bj4Q6w6bhx1rnAcM5
         AZng==
X-Forwarded-Encrypted: i=1; AJvYcCXSlN/OqhhHvIaLwCNhv76B4NJG1kKTlJzOkMhu2w4HgapMWG1HQeBK0ek+cPVc13CeUn2er89rng==@kvack.org
X-Gm-Message-State: AOJu0YzEA/yu1sjeIRGuvN5Jb0oOUGkA9B+0PVS55RDy6XOFRVSs8ROM
	E4GUIUdAYfMzOM0c6AFiG9KtbERNG2Bi9FSFoIVTY7jgPR8CmpQaGm8OYb0WhIIp
X-Gm-Gg: ATEYQzyyfryVB68tQoFNep3cWTK6ZUokFUEBCrdZfWWq1ltfozGHvt76gAxLBmUDS+N
	cyLhecx1RQ8ccoI1N3zDjHJDAJxmyVSeWdVCMr6It/9R5vyes10SXhFwTAIbWAkbkDZW2Ozu5+1
	MMYN7kpQ2iTsx/hlGE0xB7t8tRw5vszJwV9BcYVbA8dg5b7ZLzVqUixSwjtirLmeGRo2TgRKcng
	NonZesFVAmAMITdrfZTgvlWVcyg2A0Dg+yU6+miAVJm1DOU2CJJvXP9PFjN8K5eUjjJiZa9kJ8c
	R0Lu4nL0KtVY9gTz9ZdR4D5SSPpKQ9R25dd2N9aIh77dVsMbMrZZMTpDrrLB8bMFNbcZg4ZIoIR
	+SvdSUCjKUr8PmidBPPjId92xr6lc+c5nLZCLhGBvROG4SFh84/uHqycWypom1rQs4SEGzi9584
	SPUXYmC/0WXHRZRAkfeluZpH7mjug1+RLOCsYAr9uyoASQU7rUJWgaxpv6voSCEcdBj2oh8/vEy
	gQSAw==
X-Received: by 2002:a17:902:d542:b0:2aa:d60c:d48a with SMTP id d9443c01a7336-2aeca967d83mr165554365ad.7.1773713800873;
        Mon, 16 Mar 2026 19:16:40 -0700 (PDT)
Received: from localhost.localdomain (n058152022206.netvigator.com. [58.152.22.206])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece81cde8sm125397245ad.70.2026.03.16.19.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 19:16:40 -0700 (PDT)
Date: Tue, 17 Mar 2026 10:16:34 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Barry Song <21cnbao@gmail.com>, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 4/4] mm: khugepaged: skip lazy-free folios
Message-ID: <4d0f3f68-0549-476e-bdee-761045b5759f@gmail.com>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-5-vernon2gm@gmail.com>
 <CAGsJ_4z1twdSNrAVR_vZRnLW4xtsfi+vegNMCwht+RPCjy=E4w@mail.gmail.com>
 <xbej7d3uc3xzlx53djgg3to3ejcgrxotxwxvrdppqxfsgieife@5moeg6x2vutg>
 <CAGsJ_4ycodbcWHxFRacpzbxx4evQRJbuqJy3gfweAdHOtJg1Og@mail.gmail.com>
 <i4uowkt4h2ev47obm5h2vtd4zbk6fyw5g364up7kkjn2vmcikq@auepvqethj5r>
 <20260316124157.bfc7e00976c22bc028913945@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260316124157.bfc7e00976c22bc028913945@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: bnduizkukxk9ihq8p9q1zdagby6fgs7m
X-Rspamd-Queue-Id: 349EC1C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773713802-8587
X-HE-Meta: U2FsdGVkX1/+SD/QeXsM/gJbLoHmctoQml4n6lV7jSXaZbfOqcgqmp1Aea/YzlirYGcmTR3W/rS/jAUcUcRdCz+6ePv0k5gtTUugI7llpWAI9xAKRWyJiCbR5O1pH8oSiiFv5PS7c1JziF1olGABy/pU6ZYLJju2IGBnvzYoYR4ok3kB2Xu4etPEpxxS6cTnB3GyBzfHfVTfXwuu/CD1ZQS0THnEqcjR6DlYWRJ2po1lsz8ARZtXJT0w1tABrYirxJdGzgyUe0h3oxeAeN8hxfzF3/SONX9K/c4uw9+0UW7/2069ggKZIoMZGVW5IgV+HWxGOltL0UcpPPeMJgSKkBBePV7jRpLKukQYNXdmc47Y6SWiQOwWvdvoxxHMJHcRIZmj2i4C3HdSmmKL3tqy7BgTplfs+dKkJr8B+mv5lPmJaRNsXEbjKT2QVN6W9io13j8nOvgAyl7k6Cv9CwXs+TKADSzUuyMbxa24XlQQ81UZGP5rOpYw0XRVB6Z+sPmW99vGdxt/ValMsM9BwCgzCzdFkOfg8ZLrpm+QUBOIQ3HfIGkSubWvPrYWNpbHUkENdu7lpre6V4Ly+GQ4dOC7d0dqWHTsgu+gLht3uKLSChKZhQEZk1pjFr2BVk8wr2099PotYf37anEdvfCnK3vOhTVkr3G7rXBYsxMYs2ymwS5tQpkEcj+5zgVai7MjicwlHlgQNuFvXtHrnMeTbBYXHev/JQm2esMTAUsQa8JHQ1WcPIAQETTq0wlCVIULyQawRY1eZEQ8zgbcYJ6U+KKCBGU5RKnzxC8y+B+ETZZ0xt2g0yljegaRZcxq/MZDy1BTrkolBcng5ka4cYndNAK+35gOe7XXNjRAxuGIckiu6N1o9lB1VuwIo0axXWHA3MoTIuPLLK8tDf5HFnQvjy2baf2PUqqPQITOvIL/l8gycpcpXe0EWcA3UsvIrBSL4JmZLySc1Zvqpe98z0M9WW5
 K9y1vxk5
 otSgZ5MBmDa62SWaWA+Rkljy75L32bFa5pRXzbr5FvSOPXtIa93qoHys8HiwpkuA3fwdDGyo9RhhLJe11ov8VuoGioNpkCiKdhsoyOIn7s1fEsZAy5x6Ynrv/2PKJL063y6Fu5Bm2VUXQK/WNL/DV/Nnca1/GfL3z+iLwHIpHVRY5d8MjiJf64Pyoxm2i6dWRqDwomImTn3y1dCm1CqloemVmcKDPhvzVgDrreGdnhKiLq2ch7eqwWIzhXbeEylugsu4pWLIDVkkbkEg2EZNwhZiLqH4PY0vXiUi3sZSj1hWwt+ISPuSbkffvmBKGoWlv2KJnHsCl3RQ7LgXhCfDQUs4B6bLouKQZ+7ZbbgZANtoe58ZDW+kZTZHbPUsY+vtdlg0b+6fSQ6tYqCBagGmq9VgViP/vEm1uvNZJNcJlMW/rlWHwmrQYmUIWFADXuCJkEPHMxPvwnaWih1feQmrXxb78dToDukaZyaLFfnnU4C7j2t8YZpq+qn4sqL/xEWZJSOnALHvBbEDrOVJOzwxOMQ/yJ7wg+EvbRL94IeJn+kKr2tHAX8L7adwU83SZFibQn5DT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:41:57PM -0700, Andrew Morton wrote:
> On Thu, 26 Feb 2026 15:55:45 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:
>
> > Hi Andrew, could you please squash the following fix into this patch?
>
> yup.
>
> > also remove "if" in the changelog above.
>
> So you want it like this?

Yes, we should remove the "if"; otherwise, it’s misleading.

> : All folios in VM_DROPPABLE are lazyfree, Collapsing maintains that
> : property, so we can just collapse and memory pressure in the future will
> : free it up.  In contrast, collapsing in !VM_DROPPABLE does not maintain
> : that property, the collapsed folio will not be lazyfree and memory
> : pressure in the future will not be able to free it up.
>

LGTM, Thanks!

--
Cheers,
Vernon

