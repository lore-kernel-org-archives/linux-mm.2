Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E80DD26D70
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 16:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61E6D6B0088; Fri,  9 Jan 2026 11:31:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC006B0089; Fri,  9 Jan 2026 11:31:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AEBD6B008A; Fri,  9 Jan 2026 11:31:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B07D6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:31:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B11DC16037D
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 16:31:44 +0000 (UTC)
X-FDA: 84312966528.28.E9B6D90
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id D8E5EA0008
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 16:31:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pbth3wfC;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767976302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1uI439zKpcFtAsnvu3BrxvMbrLeRQvyMGivmouue4U=;
	b=2ZRpwXTWBESYsju4TR46WePlOdPcfK12gTEqOk3CfoUdr1/Ak+490MbLtTBC9RxPFV8I4c
	CdThA7XVFhyU1uI/fm77ig4lIkTrz6viNqhACwyqaLx7mLe9nP0IAKdjKqqWu01bGON6jJ
	RFnl7Ar1WcVwad0LhJMe872t7YfpSZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767976302; a=rsa-sha256;
	cv=none;
	b=kZVlVbJKJuvVzNeGt5+EusYDyU3nq5GrMQlxK5LOzd245iEfEdmYgUZC/mo9j2mc5CPtzb
	ZGYifeA40DQ73DNZfGHW0hG0lnSQiar+Bkm12fSCkjQvV6qxugyzPUmYUnrdkk7nzzvBeX
	inaE3eFvDZSm+aFn5ixXnrI672dxXuM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pbth3wfC;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-79028cb7f92so42463877b3.2
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 08:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767976302; x=1768581102; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1uI439zKpcFtAsnvu3BrxvMbrLeRQvyMGivmouue4U=;
        b=Pbth3wfCVEB/udBnA5s6VwonHqglpN4YV7LGG0n5ZCQbNz1pi1+QE97GpAaCfKVgbv
         uZv7wmvWZdJkLQphZC/Dnb5hKiNnbh428elKsTfliaqqBSkg/OtVuglvuZ07V56eRa99
         LPN5d0dSZaCktdET6ENfN8piEB97auXRLyNe1dZRZLPRm6f0FMSPHzXULYmxQjkgzztC
         maPlPnjjrBxb7lbEmn+WqyqwwLjkwGjyLl4lMQC6lGMZiZBZI7Pv5DFaG5B9LkMKt2bn
         xfqdcj07iPneeZeQQiVY5Sf7kSH2H6fz2Sql8Y67RdokQB64YLkvZvZ3uvkMWanF6EH1
         hwCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767976302; x=1768581102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T1uI439zKpcFtAsnvu3BrxvMbrLeRQvyMGivmouue4U=;
        b=XCzzuxcAPZV6CnuHvHjfpwejJTfW95tU9OuAkJeSpFyTAeefDvpVxJ0a5RpqY9zv+V
         9bU505qhmWXuTVtl5kqY98x1Cwg89hYpGFhu+0ctf9tj3Sv0JBBR7NhNAwSi0xgl+day
         WdArltWv0s50B38grtcGjuHlVAM8xoPsyUhRey2FAaHMOhOxpyPst+pYA8s+GBJsBfji
         Dael3XTBkg3ZCux98BJBgUd5z00XHeZ+1qAdVevsN+WZ0I+/kJAO75ztD7XZ2prtyx50
         +dkGehc+MHnzrv2JOlkT9+Urn9pvKIumz6j+cCgbNoryuSdze9ftbLD7CxPLCAU+arNf
         8iaQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0qDNKDr2YYhTxZoE2VSFwVJ+Os7tqKOa+vP7z4veu25B2Su9TwEr5V57XdmX3e9G3xXMHOS22TA==@kvack.org
X-Gm-Message-State: AOJu0YxIKZYLBiuLTJtkTknojrUlycRVrVobizYOxqonO936ryeFaOLp
	la6FYuYeHubeUSWuik2CTQ1Se6C7kZIcX5/vOBAJdX/zRRFJS6wnNUpV
X-Gm-Gg: AY/fxX4dHCRAu481vNwML146Hrsai1HE9jjHMGrePEcYxLlhbsVZ2iu+8ff5iQVD5Av
	w4KzbW1bO5uUQe1VamC4S9nSTvL4xlIQMvQqXOfbzyp8BLUqeHhlDDiq+5TMFx3p4t9mLgGTKgF
	Te29PXjDiT6s4C+NDWWezcBEIzujCWwDqUGf5IUlFa25UAKOWEtKnTBHfGpY6M+FcbI5mxa8yuJ
	9NqvXR/oJt8C4jcfoBGl7ysLhggmW5BSqgK59lyBrgVeeaEeX2GlBNtwdWfj759v9qDaRgJZ+LU
	O96Qwb4g0tE7db0co9bMlShrsyCokJM8UAsSPzMNUexeDJTax7TRUOD5Qmshom74bXUKFtihSTs
	uoS+ZVq6DK6xQSlARmMRFhQ0vcl9FS1HKbVmjdcnMFQ3PhJeEPZV1r5POF/haNuyK2BykjlQusd
	7m3CIxLfex3Q==
X-Google-Smtp-Source: AGHT+IFYM2CqQn2qkG2rVjkAG9SVV9l/OpxHz7T/BLTZE8yDy2zADyCcW/4qbrIGO7NFyG/ckTrndQ==
X-Received: by 2002:a05:690c:490b:b0:784:8153:c61a with SMTP id 00721157ae682-790b57fdff2mr95118707b3.34.1767976301692;
        Fri, 09 Jan 2026 08:31:41 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:4a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-790aa672cafsm41972527b3.30.2026.01.09.08.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 08:31:41 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yajun Deng <yajun.deng@linux.dev>
Cc: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: Avoid duplicate NR_FREE_PAGES updates in move_to_free_list()
Date: Fri,  9 Jan 2026 08:31:39 -0800
Message-ID: <20260109163140.1605599-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109105121.328780-1-yajun.deng@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D8E5EA0008
X-Rspam-User: 
X-Stat-Signature: mj96heetu58n1p8im5psn6ykofysrqyk
X-HE-Tag: 1767976302-506742
X-HE-Meta: U2FsdGVkX183Gj8uW4SHwXXW+c1JpfyAs2Lu+DFPNnZ22LeFSo6CFarZEHimtEsGohxxbBX9DVlKurLL4LMyKsP0vkHHhHW0yqu8ipBeVDj25ad3JRk01esi/RgdNBgs5PrjBFqjPHSD9FbEo9bvKcaOyfL8ow6gkZ1tIX1nRinIewPnOdKg3gc36lqL1dYPNyJxTlxE5bJYT1k9JEMm68Hk/hYBgk56siOWciy+gB5op+2HcFSUlkLQy7T42dldvKrHbbcGOUFVuF0kCC3478U47ldn7jmHgzxRNYM9m+bEpmttd0JfDERw4qX2OuoEacp62ULccKQlz0hqw7gAsKSOLY7sE2DNcx98bhuqLNfpiId6xnTRfCtzCxTZAqHckO2SD/qRFrYaa0Qp9WqpU5oWxnzRS88x9CjyxgbvkmZ03KqrAX1vyuUGF2nDBmSAtQsifyYqq7wauB2Gj4TTeo85WuZDjujV+PtG/VHUq9RHl5IW9YlcH3tv+hNjGk3RCy1+8ltQcoNtFxuxGvKUdawglBth8RP8ILAoMtmPCZkYa5C7XAdRS4jh50iy2FK4d4vEcH2g6Xoqxfa2y5HIT5w2u+BeXAO1NtK0yX7FLAZjMuYNCdutVZjrEy6S7sbKt0a+SpvWlliFpB9Q2ZKzSNHKDGsSJeymQWU0LtPRs2cMayteY7/8rCQmiccnO7dqAj6/N2h7zC0Apoj1E4+Y9mnbnV4VLBHgPnxmWhnRFFEraYcoCJ1pRF3gvr0Eo9QoSEbsUIRAQoM6POieRYorS/uxJg+NtIbQJ8eP5IjAwjbkQliFn7GoJuqe/TfNXtHV/Q+TjJ6eaS96fiDmXsC/zW6WCzfKA8FZe1ddUkYv+w1Gj1D1ty8pXESf7OR6oHg5+SLxIojiZI05I+y3Mick8xNPlDQqekmo+VOEmLmZ0rgTMUPZBkqv2KsTiwcZrEw+OqUVBirPl4ljJY8VWtD
 YB16pPyz
 D6i6z8+xyBa0EDhmcuHzwA+NdjijdN58P3jL2bC4/iLkTHo8IoJWUcFr2XXyLuDvQ/ijCQ15/N41IUsrfzMbwpq+gLzO7K77PU8/S5jVzKFt6gqC+voP1oiizpt/l0x8d8eBDxqzst86DtdjllRJu3mDt1dwzMVHJq/AVbEvR2t1a5F9RnhlIcwlVgBl0e/7t4+NDl73GxJ4ZN0IlzVRlfcp/w48hPl7iazCKG8QBYfRmHniGPMlF6MIyso85wj9C83r+aLdFkoKncvxMOQBW2FLxLDBWyZE6XCw/2s41U+VE9lUBMh1MPRPqZraJiaqrBTW4wOUqt+xPAvjtyF3ItHe5K9j2yG5lwBBvYR/Lk+uLZCWZkOye2Re5G4aeAzjoqgHHzeL1dWG+bROoHljDHQXZpTTYEIpmahaI4OosDQQERmnYKQOUg/2gRMQugvYaTMcVXk7ZwLH7Ysluu1tRcVmml3nOzb0EE1KVoScwVJdGNKaxhYVG7pmZ9z/lnTKqPLySjclmplk+5Dfw2HH0MRLo9MuMj289B+EPA6jD/HvO8H1EANSv+pT14w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  9 Jan 2026 18:51:21 +0800 Yajun Deng <yajun.deng@linux.dev> wrote:

> In move_to_free_list(), when a page block changes its migration type,
> we need to update free page counts for both the old and new types.
> Originally, this was done by two calls to account_freepages(), which
> updates NR_FREE_PAGES and also type-specific counters. However, this
> causes NR_FREE_PAGES to be updated twice, while the net change is zero
> in most cases.
> 
> This patch introduces a new function account_freepages_both() that
> updates the statistics for both old and new migration types in one go.
> It avoids the double update of NR_FREE_PAGES by computing the net change
> only when the isolation status changes.
> 
> The optimization avoid duplicate NR_FREE_PAGES updates in
> move_to_free_list().

Hi Yajun,

I hope you are doing well, thank you for the patch! I was hoping to better
understand the motivation behind this patch.

From my perspective, I believe that the current state of the code is
not optimal, but it is also not problematic. account_freepages seems like
a relatively cheap function (at the core, it's just some atomic operations).
Personally I also think that semantically, the code currently makes sense;
we are doing the accounting for the old mounttype, then for the new mounttype,
in a way that cancels out. And given that there is still some cases where
the work doesn't end up canceling out due to one of the mounttypes being
MIGRATE_ISOLATE, I think that there is enough purpose in making the two
calls to do the accounting twice.

On the other hand I think there is only one place in the codebase that
will use account_freepages_both, so it might make the burden to understand
the code a bit higher.

What do you think? I don't have a strong stance on whether the performance
effects are big here (if this change indeed has a big performance implication,
then we should definitely go forth with this!) but I do believe the current
code is quite semantically sound and more readable. 

Thank you again for the patch. I hope you have a great day!
Joshua

