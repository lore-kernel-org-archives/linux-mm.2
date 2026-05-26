Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FEE1CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716EA6B00A3; Mon, 25 May 2026 22:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7D76B00A4; Mon, 25 May 2026 22:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6E46B00A5; Mon, 25 May 2026 22:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48C1D6B00A3
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:33:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9F038CF7B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:33:16 +0000 (UTC)
X-FDA: 84807999192.17.DDBBB28
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1764140007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:33:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="leWetf/P";
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779762795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hgah7sUqP/Avy6lg70DxS+/c9Cc04Sgu5AnlzeWxfNA=;
	b=XMvOG/VgRIjlgkSg7YlwiYn0g50/TrUOMwy4XSlaeJso4mxo682VDl7OzADQ2MGm8Fautm
	st9Xu1z6LCedp13WPWuT8HhFpmccX+lk7kdL/VCFnK89vshqm4EkfkcXy1XcNQ8tsq3Ssd
	5UXTmluQWbN3ead+m+ZmTZguks2Fhxk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="leWetf/P";
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779762795; a=rsa-sha256;
	cv=none;
	b=Lv6BUC9NPbW5CyLJjohiTB/17T61cM+qve8U0O2o5HKyYSsO17IdmJt7tvD+6WilX92SlF
	+LQNUKD1lRjUf0UyQw9vUHxAoXwn5K3WZa9nEourE8aGUZg9wCSS9qGG3MOIkkZovxnGT4
	VrkEufR0YPF/vdBhv+KPCr2sYHAMifk=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-36ac67f489aso1099999a91.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 19:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1779762794; x=1780367594; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hgah7sUqP/Avy6lg70DxS+/c9Cc04Sgu5AnlzeWxfNA=;
        b=leWetf/Pt3yIESEt4skqxOIiZjDjU+5Y6RYm0OtZN6+ys/Wu2tRZc6cgbH4sSb2yGn
         cmms4cd3m3AdDhZJhZKRmZUgSiben0XjZ64xZHO5M/hCV/EXXLu9JAip67ikFKhJJj6j
         uQcsmRcf17m4I4MUI8mZgQ6GcHTVLcAajUBlc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779762794; x=1780367594;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hgah7sUqP/Avy6lg70DxS+/c9Cc04Sgu5AnlzeWxfNA=;
        b=LMV6rIMuqGWJ543CTHtSo0WIwifn4H0GJ6Rhnv6B/x5vu9DjPO59ZvalwTmS+NRd58
         E5iZ0/ZJl/KCjozYtRIfylrOl+AQvyMc5szOqwBv4GMqmWc4NItsKKTQfXZdvyvjde3k
         UGys720RI5yVwp0oD3s8Tu7hkqYV+8f2kKdmAMcH/249bQlDG0kcvzK3IrkIcKlHAoMX
         f4oO5gsFuArl2jwUG7acgOKx/svXD8OpX+ry7V42pQMEQpLLHEYIC6jS8Z3adXQgaFaX
         IDxKo8zrds4jF2r8kX3RxrkgVv3LuxgHkaxMW0BQyt4ZxfdPSR60yLuSMFfxIh2mSL3V
         1F1A==
X-Forwarded-Encrypted: i=1; AFNElJ/HSGRvG7hHZo1Pdif8Sjt2ZFWIHChXZPpT6FlglWrreXH9K1BwsdiE/5fnQc2RdlVvACCJhBMlow==@kvack.org
X-Gm-Message-State: AOJu0YzTFm8f3H4VIoYwkukBsfR+wUPQLi88aRpzj/t4LrFbPwNbkHDy
	NtThLYSMdOKSa+A3IWQAsZ31GL/+i77sgF71TfheyFIKqU625A5DAye/P0OXrD2Zdw==
X-Gm-Gg: Acq92OEHIufHkxteKc5XQt9XuXRgQuTuQSZ/WuCKOXV2BnLwxzUsqGT0dxUhkzc9ZAU
	RtkQvcM1wBKxce0wYnmhgschVNMS3xJR14roAO6QtoOt++AewfFisjdpKpyo0RFikpNu0ennhxU
	/rCTFtpBas9jHIV9HFQWrCBTaRkceAOOOc9tURIRfDLxrqVLViCniG8+TlXiuUp2VVp8dEFqZFh
	c/ZlBiCf6ehYKm4fG7wkd3G6LzkfyL5VtxpVQnzwjSmwMaWvqo0RBurNmOqxUYfRdkaOl6d9wkj
	kqXAQGK9BDxMqYCBzGVpt493q/uKM5+X3TmxAu2888VsOcplqFrE7YoxW8A7zAFX61/wXeJRUn0
	hHnplrHhdKxW1lGUQIg5FwpLlYKoicwkNlE/Vic0RtYcMOCO0rLl7GOULHnnjPjMh9ZLaLPq9DD
	+TtiZ+uo4UdU+KfK31UcW8vMYj/SJt08OsxYfjeljS36VD0uI5dHJaHnJf4+k+TzRHgmqA0prj+
	w==
X-Received: by 2002:a17:90b:2712:b0:35f:b9f1:fded with SMTP id 98e67ed59e1d1-36a6c79dd38mr12381268a91.12.1779762793833;
        Mon, 25 May 2026 19:33:13 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:890b:1e07:dd0a:52d0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a723cee01sm10542213a91.14.2026.05.25.19.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 19:33:13 -0700 (PDT)
Date: Tue, 26 May 2026 11:33:09 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] zram: writeback fixes
Message-ID: <ahUFMBcjHlhJMF8p@google.com>
References: <20260525044639.1888561-1-senozhatsky@chromium.org>
 <20260525143127.9f8ff15e31df71bdb494ab61@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525143127.9f8ff15e31df71bdb494ab61@linux-foundation.org>
X-Stat-Signature: gq7okwkcaq1cdso81k3eer86bw7ghz7s
X-Rspamd-Queue-Id: 1764140007
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779762794-15423
X-HE-Meta: U2FsdGVkX18jGHL7tJOeRVvd2lCALqeR4zhiHH/P9DOGOjPfcXBliLIa4rJLj0XxU/sMHfAQ7BiYD/CZSPuwx399L0AFQR+3nIlTmrvwleW5T2KvR2/Fk8ImQmKTn7UsFIbI2rYYxrQq7ebnq/hO12CeHTApzDOARfHBQfYTIzenFAGBcRK+Jcgs4NKXMsmfYdgcXIT51m+B+H/fSikDGqHPtFOri8gzZ57UFTKGw3JqraYuFNybiTqr0l9UlgVXcFM3wEhtcmXYI+gUYLTP4euREHFeXA1bgpnri5C/aGc9JcFt9lQlttMU4vQl2NDZVBmCbinqVz0jUkySRp6s1SP/GHYZA1XyRZzzQcPB+atq0HLGk0hQfny03DSKLjQWmi0BB2pRMoeJCvz1aWOruVicnM/7M1D+VcCE2dT7Nq4UR46C8SbFCFJc95bHb3nZ8tRJwYtfAB0EQoRYT8C0tb7Mmz6MDQlLR6e2nfsXaKkuA1ovxXnlgficZZUZriMoYNgEeIM/1qcV0ak0+h0jGstPNOriPc3/PJ97VroDDczawg58AS2e+KXrTwj1w8vVvbakPBg/ya4SpKN3/yzS+/1yswpiJF+knrVnAg+8ZHHiyIPyLlU1AEmlQjkDdKlyLsWE+kCx/rnFfgn0bTgP4TXbwrObk/v5SRWaNh3QY04eCfPpXRArLGjOydctIs5pp4JoawQm5zxuvnxLV+6pH0ysFHRnP+8oTfNHB+8UiXbuIwF9/RnH/3gtD3a7mV8a/GQlSjGC5OMg3lGaq8z6KI6CHi0SHZUy2/PEBCnit/WOw6S6zQyYoAfb0iS+BAXtP116riyQDP1AXi3tVMQTTHhEgb3RLeznqqAYjobJVWHE94zI7AAESKslI5cwVFMrsi0D4yCN/XU2eEVDAQuVWqPtImWT/eO82kKajOjNjaDMokWqUrPRUefrUcX7+0LchlY0k9aKoqqe0KKgsH4
 WKD/mow2
 TivYVSCEyJbjJnX9QrqcSL5H5IBdWRYZ6xbrg69L5+GswZ3v4wPVZn/+7oKZtJAnZjLsN9X+Cixs5o/as1fyaRIv/ZUN0dfNn7LFZK5LolbHqb3mIisYmVwgxBeHzU6k8IlG7pZ1+wBWLyBFyOLroE0VothCsgEM7s5rJjulOgGRfZ2CLS4UoDchZLQE6SLUciuAtBU97sgaSmAqcZGQ4FhpBK5bt0u7C6e05J7hvMZhSqhTub7BM1t8qAW+R0q2MhWLaCzxIkzYKUKT1sU7UUXavYth17OAD/PqRNt5seMqcG8JBREAPfhgIfYRzmJDZJ1vUriH39li+Hg5LheYn/8O6xaJ6MlzlA2O4PFwKAMee719dbYBEDbp9UwjrhjjtXnQ5YaXzCxTlPLuyhCCrH8JyrrvtelUhKSYQFwAbiEXpvWuQsdJTZ0HnOarIKs+JT04BRexQ7tnY6lmgWLaqjFHa2+aoV5nqh8pGdYgkzHpeEJY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/05/25 14:31), Andrew Morton wrote:
> > Brian reported several issues with zram's writeback implementation.
> > This small series addresses those issues.
> 
> I hate to go all bureaucratic, but there's quite a lot missing here,
> and it's rather important, to some.  It's all about taking care of
> people who are using kernels prior to 7.2 (or 7.1).

Sorry, Andrew, it was just me being lazy.

> - Link: to Brian's reports?
> 
> - Description of user-visible runtime effects of the bugs?
> 
> - Fixes: targets?
> 
> - Decision on whether we should backport the fixes into earlier kernels?

I updated commit messages and sent out v2.  The reports are private,
so on public links.  Both issues are low risk.

[..]

> Also, AI review didn't find anything to complain about with these
> changes, but it might have found a pre-existing issue:
> 
> 	https://sashiko.dev/#/patchset/20260525044639.1888561-1-senozhatsky@chromium.org

Correct, a pre-existing issue (first appeared in v6.19), we fix it in this
series.  The theoretical data leak issue first appeared in v7.0.

