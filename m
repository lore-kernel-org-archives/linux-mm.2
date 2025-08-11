Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD32BC87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 14:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E21D6B009A; Mon, 11 Aug 2025 10:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493196B00A0; Mon, 11 Aug 2025 10:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A99A6B00A4; Mon, 11 Aug 2025 10:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9CC6B009A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:03:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DDDDC0197
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:03:16 +0000 (UTC)
X-FDA: 83764643592.07.093DDA0
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id AB0A6140008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:03:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dfd5geLU;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754920994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HLJeGvuklMP7ATFsRoiARoYLmPkcqCC9xvrYga8Pl0=;
	b=mTGxYDY7UIUdzMsqCMb7F7HX/QZE2QQdluOTuqu/dWkE+gS1RNF5jO/5m9gcmSQI7688rO
	Dua1hidj/h+qlSZk7S1HVETejVAUYw1R6VtQZscbD4NWQvquo2WLYgYivznuYGgCRdXse3
	4N5y7cp0+Sg0QV9s45IawQYfKw8dTKk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dfd5geLU;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754920994; a=rsa-sha256;
	cv=none;
	b=a9cGE5iLTmzYDz+lO8SpqKZgG1QI0WUu+mXuWW4gVsff5L62S6SNW0LofjC7e84uPG6ARg
	DCbr6WcCnh6jB1vgYsUjrUOPBY3pBhxCYoEZ5k9kLifGix/r2wEoN0KZPeq+2i3SmYeXfr
	o/YHbGsSW3HTavogiEgkpS0uYZUkPYY=
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e8fdbd45e10so3441535276.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754920994; x=1755525794; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5HLJeGvuklMP7ATFsRoiARoYLmPkcqCC9xvrYga8Pl0=;
        b=dfd5geLUE5GNqciXigRTEbgFmVctJRGVc6cm0oN6C+aWLVay2jeY6NxB56rwSVkSKP
         fHxx7FLRibE46yU7OsRXRxkl8gF7WSFx4cu6iGmfnowsfaOePWCrjRPFX9LKGrjFrhZF
         4K/m9wiiSLScmncun8ym60tI3GZnNTOhDQA7uDZIG+3p7AD1/nHBh0d5i6sqkf8sbsKr
         bFyCx4xGWyO+e7ppha/a+d8AOIgAc/DNyV+DgurkJ0roe147X3gCi4hqf7X7nrTfsfcQ
         Zr1+qcXBn/QJoysWASidZmFwNgfcDfeTIJkQ5Jy/VTUjmKGLop1TcNsKiIN4B7+lT2NG
         cooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754920994; x=1755525794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5HLJeGvuklMP7ATFsRoiARoYLmPkcqCC9xvrYga8Pl0=;
        b=VMN5NaYgUwOwiglp57fcDTDwysbs/zQi7AZJ7WPjrXpVGmxtFQt7bE8e3w+l4RhsTA
         2RaZaBdij4cnGH5lLZOo6dAlDwQxz/ViU3hfv2AwOg9eTJbGqWGkx/2MXo83bMsHiu2m
         pZ9hObsu5cevOAQHWt2KcZkvExJ+2Q/AGbffuzuXsey1ZWBJK/SVr60TcKtGA+4uYD7K
         +6P4yZax+GTPLybSWlgrp+CTT/xhkKIoqPesQcuOJrQarVK4m+r61t6lN1Jv6/CtLxgV
         Euxi2tb/1rAku10UNR4GTshwgXbVipHs/nCljXuthB2m84ZWbzwcGFlufvaEn+i3P3kz
         G4Rw==
X-Forwarded-Encrypted: i=1; AJvYcCXN46WnCRMk5RjME93/2iHUch+rexBi1PU2hXzYWVOF7mpW/1EM6gKE/XbY7A6rb2Rxr0XYhCqmEw==@kvack.org
X-Gm-Message-State: AOJu0YzZ3ebOKRRUzUPI9fmVNkBRXcuVWuWEHeEaOKTDXnIZ5xlMEmQ5
	DtYBkiH4DkR4IeHNOFYYh5yNLKtqPk4d4egb2er8Rp3TU1s6qieaTTUk
X-Gm-Gg: ASbGnct+KkccuYgslSzZ61Rbr/4wAeDCiuFUH4xewN7nSWeBjl/RTzET5jYLfv0E0En
	wlGhKztAHWQTmGcb1S6ZcJNXX1Bb9dzRg0K0FRE0YmTf1Be2luXwNgSZvh8RAS6QkpWID0fhikb
	SwevSAYPmVHMWLZ3OqHfilaAhrO1CfNNzqpN3TlwDyej6BYcG1BpwzRdweBP3C2lG06Z5zIZ6sG
	nNTzd6TNi0Dt0W7K5h1JMqBJ/e1XCiq85hd2VNtyL63SMIqU552li5PZFPsZUiK9XRVlywp9CIk
	EEHBISJVbYsmUn1qjUoVjx/akMx+mgrQUOqAIcpRaGql/C67BsI9ZAKy1gE+jneV9/WHMVvQdeC
	jcJHSaa+61ohilsBobLrp6A==
X-Google-Smtp-Source: AGHT+IFewBym46TYf2D5lfnQZS5KaqX6Do7GHSRbX+1k26Bp5AAhyfhZKfKCSKnYzeyr5076YpqTXw==
X-Received: by 2002:a05:690c:74c8:b0:71c:bf3:afc1 with SMTP id 00721157ae682-71c0bf3b6aamr93824817b3.17.1754920990350;
        Mon, 11 Aug 2025 07:03:10 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a59e9d9sm68953617b3.56.2025.08.11.07.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 07:03:09 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush.brahma@oss.qualcomm.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/numa_memblks: Use pr_debug instead of printk(KERN_DEBUG)
Date: Mon, 11 Aug 2025 07:02:45 -0700
Message-ID: <20250811140246.3264034-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aJmjXABrInqumY1-@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r95w5gfcpz513az1u45ecat7dwr9u9rr
X-Rspam-User: 
X-Rspamd-Queue-Id: AB0A6140008
X-Rspamd-Server: rspam05
X-HE-Tag: 1754920994-800491
X-HE-Meta: U2FsdGVkX1+Xqyz8HIGg7Wtv9eZ+sI9DrdWTAE+jv/h9KAitSH33p5+RQODAvIlblvX7CPnA7/6bYn51fhVCE1kxvUcD468YI4frhrppJXoc2zVamGgVG6VxSwRY1ZrGr9ATDBjx84GM81lFADlTc2cx6BAVphyDyl1BfnC3wB46TFxZdNGVpAbmYrk62JVx0YLp0FRrFeZ7nJkFmDWUNyJCNHw+JHQ7c18gZ6ay5Yv3rpJ0wYxjO+hMfPDjo4gkMKvs7ceBpjpMZw0KcfC6CjnQP/HwqhW9JVjlWIbQ9qZ70xzWHEl3gWyPRgO6x/9lOGyMr1wpWKVP0G155zDww95s4/RiXSi/2AWvraajb81ebIwX5tsP8oBg5mYrkyqQazuBtTFol+JMo22VDhI147Ql7iWa/pQ/acuY7wa+FUG4F/I4uKoYVVIrMvKxtE74aPXuMwmy+v7eU+IghR+IIqoL2+XUtoa41GJIoAjwP+W+lwBkLAba4plF6/sili44ti+GD0FexODXYBV4rabubWQNPULlUrAwhcgcoQsK5qBXEuqmsp4PH8ip7o2KUVgIkWzriwStddlw9053aMRhYq6v2ncJQmRfyr2ztj/OhvnsKRhPQZVEQTJXS5tO2+Q6NnkyakDjxMbmNPEwGvaF2ZnqiSDdqUUiUfE/Ju3ScSjcN2tx1o9TlseGAr+smfwvy5qMIIGx1ndR2ZfH3Ir7nhybO73hA9UgSlCzAh9EZq4fzjfYXRb9NuVX9MLVXYTpLfsM7Eltm6TFslYwBgEZxln3/s7epnxoD42N4Hid7N/QB5iUn2iGDwNnKu5Oa2topsDkyxijhT3OhSPeGBorapsWOn0d1eSMjQwG6PtCgLtSun3XzFDAmBme75/oGciygx+sRvBUD4OTIGTiIn8K5y4BrFqfeiw1tmcdAQvDJbmyk/LTP0zMfcI4V2NqAELacrzp+QEF4YKKGZTIi1c
 sAgWNZrg
 9pIQgsH6S4OuTejvpuwFlDoPJbWuGrC8CFgZ2T83rE/Dy7uPOJ11w18gS4gxdLbTslYVSYrgg5Z3AnRDqtppFNs0jNn1yptJ+bvKqTVfjhxs9UkoSXKyfdjA1Bfdg+ftphEiPmmSRdTInn9AUfXZz0Tbw6EYXZHFEnn+cEUFOv5WkJlIUSgF66iBJhIWWJQaBLOFMiSrt+e2u5GLnCOrUgA3LrXRkYHaGH2SwAA8ZdU5gnqrgp2PbOv4bpPAkRZZgTMswTVh9M5bI6C3UeAfy64WDf8ZKW/WVySOSLKIsldXVpi1nSnGao3oJZQj8Ih89rRHAtHWeOlJdOb2pnB2goOxtH1S7GGmvxoRKf2qFlChCPrzzph6qhLXICwgE2A8X5/W3TGrtPSfd1I0VPYDk1GEn2XZy9pJTBf9RI2jF+k7ijCuRT4z+6viYtqnwDJd5xxduaZfCiN6anJaGWcAYe1W2vpKzRynRRGiK4e1WdYaKcflePlYEtvJfKUU2WZhQpG60d8Raw8qVJIpofXaFqkoqNAOvIdNqPE+uBiqTaelkHo4frWxANMtRjDu2/bWtRFJy7GipF3BNdOjgjChWr8vI9I4WfK1gOebIJFg+4OBZD/s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 Aug 2025 11:01:32 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> On Mon, Aug 11, 2025 at 12:13:54PM +0530, pratyush.brahma@oss.qualcomm.com wrote:
> > From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> > 
> > Replace the direct usage of printk(KERN_DEBUG ...) with pr_debug(...) to
> > align with the consistent `pr_*` API usage within the file.
> > 
> > Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> > ---
> > Changes in v2:
> > - Removed printk header as suggested by Joshua.
> > - Link to v1: https://lore.kernel.org/r/20250808-numa-dbg-v1-1-2ddd1ec634aa@oss.qualcomm.com
> > ---
> >  mm/numa_memblks.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> > index 541a99c4071a67e5b0ef66f4136dee268a880003..ed6fcfca057ab4c9a8aa26cd1929551b4ded4a5b 100644
> > --- a/mm/numa_memblks.c
> > +++ b/mm/numa_memblks.c
> > @@ -2,7 +2,6 @@
> >  
> >  #include <linux/array_size.h>
> >  #include <linux/sort.h>
> > -#include <linux/printk.h>
> 
> Please don't, pr_debug is defined there.

Hello Mike, you're totally right, sorry about the incorrect feedback.
For some reason I completely missed this dependency when reviewing.
Joshua

Sent using hkml (https://github.com/sjp38/hackermail)

