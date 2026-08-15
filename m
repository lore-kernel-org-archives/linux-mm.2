Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B766FC5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 05:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC1B6B078A; Sat, 15 Aug 2026 01:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A833C6B078B; Sat, 15 Aug 2026 01:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BFF16B078C; Sat, 15 Aug 2026 01:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7ADE56B078A
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:21:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12F5EC02B1
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:21:58 +0000 (UTC)
X-FDA: 85102357116.29.2638C3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 254A4180002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:21:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=illwoXrI;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786771316;
	b=MoOIncFHLiJEWmBTNKm+HbKNg0a3pCO9S99D9dSILjzOCj/FiQwu/RWtRfr77DPN5zoZox
	6W9Df3lZh1KdRi9QER6pa4XSPikDT41kEhOO7J7epmTaXDO9aOVRQ/BZ6kzVvRN5OBTg4W
	izW0hEQX8xoQaSsFvodQoYb9BLll5NQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=illwoXrI;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786771316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZVI/m7UgJ3v0xqpNRA2zDT/ATHaM18t9RcyA0virUM=;
	b=sPgZ2C92k1aAUwPv213X+sr6qP781oYTrew2Npv2WfOWgLy/5M8MqMzExunhZWHEB+jqGG
	c8SIskwjF16I6mQn6olLVcOGRyYWIBjEYeVUGXLCnoH2WTidgJaBX4Od+dCFfTv8/vwRgt
	nV2cCgympjhFqBWlYU18GxvuPaOBacE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07AB543F07
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC65C1F00ACF
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786771314;
	bh=AZVI/m7UgJ3v0xqpNRA2zDT/ATHaM18t9RcyA0virUM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=illwoXrIxwkckYGdF90qU7EPoBctU29sHfn5M5nNLvao7nc8WeeYVH0I+gDV7DOuq
	 o9MfClU1yBSfIKOyf4jd4xUYKNvvtD/PO+WmbvqxktL6reot1s66jvZRhCF7hN/rrB
	 ln9rMVcsX9Crl/d7q3ZthdD9emG4MmIvg+ad8bfEMvxKrMA9RB++/xrlPceookSQDb
	 17VWO7NGN9k4a4nau0Ru19HgWH8IgYznlZWdtv66E6gDftiKr97QcaCpqu5MFbdX4q
	 7VeYdTmg8nIH9DZUQeOsYIzPcwvZiS9CkPYh4fz52kp7qo43NVutHnIMl50u42AQVP
	 VOYSvKXT6Sp7Q==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-936dfd009d1so60505285a.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:21:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp+0caXDCtEe09euFpl0ya5hygcDsLvD0mt1xBs1JUy0WSwrDqI5DMHJoiVsBXsUSwVJHFStFG/vA==@kvack.org
X-Gm-Message-State: AOJu0YwDLjyyyrdWEH7i0YjXK/xu8mNTvT4AUYuTAx68dkSMOrHhMjdA
	lbR6R9p2hFg7s4kvUaKNoi9dqJvIM+SEgM0mSZZce8S/RDSuusZ15Tiam5Xqb6oBZWb7KXxH2JD
	VvTnD9G5QAtjDOSX3ZYAaAQoGkgBPpkw=
X-Received: by 2002:a05:620a:404d:b0:92e:e601:d238 with SMTP id
 af79cd13be357-936cfd69b06mr1261887085a.10.1786771314251; Fri, 14 Aug 2026
 22:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <OS7PR01MB139142FE16EC63B892559D40496DA2@OS7PR01MB13914.jpnprd01.prod.outlook.com>
In-Reply-To: <OS7PR01MB139142FE16EC63B892559D40496DA2@OS7PR01MB13914.jpnprd01.prod.outlook.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 15 Aug 2026 13:21:43 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wNPeSYHe_-UZnNRF1i1yWOxdbOiqsuVXVtLU7BDOBbJg@mail.gmail.com>
X-Gm-Features: AUfX_mzxThzDf7wveK1UMPYQ2Np1KIdfQnk17P5laxVPc4Mk8oZKemtD04RWTw0
Message-ID: <CAGsJ_4wNPeSYHe_-UZnNRF1i1yWOxdbOiqsuVXVtLU7BDOBbJg@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: synchronize lock and unlock target in anon_vma_clone
To: seohyun.kim@outlook.kr
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 254A4180002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ckc1bpwe8hupzne6tzcf8whr45u3fnme
X-HE-Tag: 1786771316-310560
X-HE-Meta: U2FsdGVkX18Kr+R4l6QGZ6QCbQ2+MvWHWn+vTOzpmdWPZy6B2Za7HSahOxvTatx4NirDzRNSZZtaDddQttayvJYOco4F4CM76kE/ch2ZP9Wht5hxjMsSmlpyn0yztag3vscAlFVaT2npWPGd3H/dfQD1/9V+GD2nX+/luOUPb1l4fips9zIDxe/+0FTsjASpu0tQgC+NVf7GcS9sit0eAyspDuFqQgh5RgG6r3DyS5w3d42gRb3Zyd+Yw9i2MvWz740lqhUEWvEoj5SUx/fcveTsHKiVBCEgm9YnHykpc+O2UARKePAEg4m61JzFiVE81Wosf69xgVh+cZ4hBMVC0qUsyYLIt22qf5mAKv5SwpTbnePYE88dqKcLxwpR8ogkRy+lTLnxHfAIUN8GSLFebYVIpya6YvoSGtV45WKTyl5c3vc/t7OkKloGkyWQlfUlNpElPNVICx0+BdMovO9u+cqXKYSQgN3t/w/rsVlTkPTDjQlcIG9ZPKDvXGmWwfzAfCCDJtxyjSswuH9X3Ai0fw23Yla8eXrwT3Wqkvs4GiDe/XFcUG2ys+Mt1pnu0zNpHklxWkAn//oomLI0HEyAjcoljsVC+mynyBI4E28DkqVx+E8oZqtHuzWZtDGxZ8/M7iI4y1r1IMwQtDYiLba12QVm7C0+UzCHxi6mXNWp0SEfZC7Hd6mkvChkDaRFXYQoFbIcF0Kop08H5XyQaraWR3doGDEGc99JeXjBUx4UWGS+I3Eq8IfRPwsR3iaXfWkof3KSUSqoEVx7aiJfY3f+VP2M22WvO8cHRgY/XVjuTRsF+bVxLIw8cQBvzlU+2ju3GbFlAaNnk9r9f0/KD1W1cTlPwze8HnjJkVHdZ8Xoa5rkkyf5AfVMZgSGGrXnqJZs8/pfBBvTkZXWQ6W3XZVDGOJPODpY05G52NoNr+MgEPGoK8tqvrduOyPC0h3VY1snpsxlee6ZHuWm5f4aFiF
 o1UQWrem
 GvUI1im1WOTwuW4Xvw6NKQeF0rlE0i0F0CyJPZmQKeuhArcTplV8IqJOqrNc0omSwae21AiAa5WFrkXcdeKvMPoT7qoBz+Tx5rVQxvrPBTWLP4yRkbrS/52wMLL3Xa+hI3v1Py++lDgok8zXq6O6PE1Mj6WGshXzWN+cP5yN/fx5ybOruhte19w/fiuOGn3Y+elxIMl0i1ur2XGi8b1TgK3t0xMo9lGhBd4PArPbYvMO8INZb/NA7oGpZVZcHOIOy0dmrc9eK8otQkXAyuCX9HqWlH1dmlhkZYUmHM/IfHIZqHg+65JkDOuMOInNJgZkKMVTbTyjFGoT07acovH8znG0LiCE584yDDaqyQ4H4PaWvowY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 2:33=E2=80=AFPM Eric Kim <seohyun.kim@outlook.kr> w=
rote:
>
> Currently, in anon_vma_clone(), src vma's anon_vma is assigned to
> active_anon_vma and is used when unlocking anon_vma after linking new
> AVCs. However, the anon_vma is locked using src->anon_vma, instead of
> active_anon_vma, making the lock and unlock target inconsistent.

I'm not a native speaker, but I feel the lock and unlock are actually
consistent and operate on the same anon_vma. The code just looks
unpaired: one uses src->anon_vma, while the other uses
active_anon_vma. But aren't they actually the same thing?

Not an objection to the patch; I just find the changelog a bit
confusing.

>
> Use active_anon_vma for both locking and unlocking.
>
> Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>

Best Regards
Barry

