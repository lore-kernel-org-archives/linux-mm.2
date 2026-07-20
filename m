Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFE3C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F42186B00A7; Mon, 20 Jul 2026 08:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA556B00A9; Mon, 20 Jul 2026 08:04:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB98E6B00AA; Mon, 20 Jul 2026 08:04:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A57B66B00A7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:04:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEEB880157
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:04:45 +0000 (UTC)
X-FDA: 85009023330.11.2224814
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0260C18000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:04:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kuWl0pF3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of richardycc@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784549084;
	b=YaqCva2xmmdqvc/dPXEkmeAIFjRYMIm0YA/OPo9VcbKyLaiLA4zPl0TAJuoCXSObkauaP6
	2w2bC9LIyrt7tsGo22JBhyYNEcVXJTORRyKIuVAGFSS2F24nyyBQ0dn4Yvmw78Xsubh+1C
	c2S7laijPdNlfbkDWXX6xH+P8dC/g+M=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kuWl0pF3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of richardycc@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=richardycc@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784549084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXy55DmkWOc0cnDtwa8GfoydZHKPJAbuF/VxXR3GWJE=;
	b=3Cp4t+X4y5wwxro2o6jj2cXgrvbwX4LB0DRS5Gkjnozd10ynG6brnpI7yvWB7pDYyecPoD
	RcETr2vS5OJ/Y2pqL+p2euaIcHT3BjHju+AWnbak6W/RyLeq1tz9eAxZ8U6IVJI7OOhDD0
	Wj06nisaPwBeiL82v5KxjFNCVYASrs8=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so20181e87.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:04:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784549082; cv=none;
        d=google.com; s=arc-20260327;
        b=Oc4jAt5W8PjSAEKzI/e4uZv1U3m+f9CDHoW658fRus7uZDHxLgaapckssTOwJyhFTh
         jY40ndNM/b0bfjk9jM42U/hcdCLT27ToyXfEsEcz4ygvqGSA8YQZJSdIQ0OJ9nHi42Bt
         ClLBJNeQMr3iPxG9++QwWqpyRHtlbmQCclzvqu4N1p6bf+e/UWVrAzwj3bVLxMBF+ouM
         Sr/9SG17Ya+bKHEirrioIywfzr/Gb3UzB43YwKa32RjPVSggYEzlGmIqiOkiGI7lt5E3
         V9vpXtvcyIIOpRRSrlEWdNYrkUIWOLLVUVT/2eU5IcmdjGM8JB8iExvaJ4jTvugMTBUE
         hHyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TXy55DmkWOc0cnDtwa8GfoydZHKPJAbuF/VxXR3GWJE=;
        fh=m5NFHth9E+hOEZe9djVu7q7tGQ47eiWqvbbel8kzqmg=;
        b=fP890ft+ptkatNUe/ntDnXUCrXBtIuJx+Dvh2V9K0Ubrq7htwNv/6o/jBnG7Qd+BLI
         urJjCPRI4ZXaUINUUJ/cqUL0BhWcU5TE0KpQNxDgMQAV+uTP5qk/LnNyndh2oS0sXQKG
         TuUhF9qmcBtlJaRxwnjY4jK3tzFcBzsmQI0rIyKrPONxgHmApYtev7RGMLCnIMqTq5jK
         vtpmswJq3kJCQ6MnrhAXq5Z+HntSoAIRari06rYWffIbiRD0GBdOLWdiq4fipgat8O7L
         Guyrna4xd+yhySXyk9CambPmtkSz53ZLMxJdEWerUbV5SmpA2RNigIF5Ezx82IJRHC/M
         ty+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784549082; x=1785153882; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TXy55DmkWOc0cnDtwa8GfoydZHKPJAbuF/VxXR3GWJE=;
        b=kuWl0pF3nAHaiDibFHiecbH5h51KXh+Qa/4Q1XZO3EUprqYhJK74hm0al1mq1W8n6Q
         o8jxzgfB6lCm/CMYXPn4Tp649L4g0tZbk5XZrvDy0fwpr9EwC+e/6O44Vwnl3e2D6q2/
         CI+o3bexsKauS59MAgrjxUgyjRfvhCyQyZQZGe9Y9+oYncZianRAFLpNs0HXUz4ngFAl
         gf8+vEFU8kn13QmwKLw7I8v6uqohCap7LgrstD7eeHVeIAPnHAZjLcfEGFgqcQgHwnbF
         o8YA8+gtRNW0vK0V5VGvA/IhHNF7zdVzGqKyi03JLJv6Gepg2AGjFE1I9H209ZM7BUbz
         hWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784549082; x=1785153882;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TXy55DmkWOc0cnDtwa8GfoydZHKPJAbuF/VxXR3GWJE=;
        b=HAtODjTlV56SIUd7KpCSqIZ7xnmeeXlmUSc+CjvmoaKiiyETdlodx2HG2xCRs0q1Og
         CY7msQ1E3BU9jB1ySxBPPqQrqPtAFyblLwMVkOgc9+lLRBHzQy0mSyiZy+CXnMcIblLH
         fVbFpNrEqCZlbSsiPeKykZNQQbRwlfgTlIMJ9Gnapto+bxf9vCZ4z0qDXcmkvljDCOp2
         dLXBcYXBpS+4x9bcqESFCEJCL7aL1FLInqvUNWZ9uCGSMTxMcTfHs61X6WsUiXwtz5P6
         ZwAsS8BSpB1ABnR+Y21hj5HT8xQqcPUuPQEkJQxXFTrPuHjar0XBZodLntkAyQprEmDa
         tz4Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqx+lvDlZVizVHFdQHSg3G+t7sZIGuYr98kUqXI/UZwjtlQoakYi8L4VwHlTtRvOiA9s6KKZOfjZw==@kvack.org
X-Gm-Message-State: AOJu0YxwrrqBcD5HGCR8hHj0OPxMz0cYT0HftPp7TA65iPZKHCB0lfej
	XV1L6WOIWe11mf+IOHDE+r51W9Auxp9oLsZZ5LeFzqfjJEBQ5Kee6wSSGompz519WQOguX3oR35
	+h0f6vw5g8vLQY3FNcdHuUER7k8eZaFxeifg+T2M=
X-Gm-Gg: AfdE7ckNwzEFu8mVeAK4eqmAH1nCK4sB6wzmZ82hOEvtifpSnVbHjIQvebe5mS7y8bS
	h6DpJfiBVnbInbvhxFUNy4l7FO0Pog5L1DLViw5vjMlT5IkSr/zwPU1i2MItHOUgbqfbgbH2dp3
	LzKE95YjbplwGxx04ZKbzUfX60HQi7eVry5Z0eGuG3HuNpQMd8Adzxhsih4fK7NmU5F8DLkXt/l
	GlP2+zZiB8V4PF+TDOwHzBDhDT++KIwTJjR7Yp7S5vQkTdlEWzGZc7wBxq7EhOiis/oGdKPqB51
	oXf91m8qXl6AKEU5T2E=
X-Received: by 2002:a05:6512:138e:b0:5ae:b726:5f1f with SMTP id
 2adb3069b0e04-5b2a31c18bemr17328e87.8.1784549081895; Mon, 20 Jul 2026
 05:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <CALC_0q8rz7U-8x+syTFcWS6Nihxvzd00ruzOThb90P+cDqi=TA@mail.gmail.com>
 <20260720044103.905191-1-richardycc@google.com> <20260719222306.540829de219e12e21396d260@linux-foundation.org>
In-Reply-To: <20260719222306.540829de219e12e21396d260@linux-foundation.org>
From: Richard Chang <richardycc@google.com>
Date: Mon, 20 Jul 2026 20:04:30 +0800
X-Gm-Features: AUfX_my09NS_xm5OKHRlizZ_1UguAfn6-JyWEfZ8Wu8DmFLW57L-_oV4BAdJCNI
Message-ID: <CALC_0q_cap88s5JBzU=bEkN+66VvMi=e+2M1b_JsiTYmV2t21A@mail.gmail.com>
Subject: Re: [PATCH v4] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Martin Liu <liumartin@google.com>, 
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3jx1n6zuibanj3cz83tkmbxc3zyfwbsp
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0260C18000D
X-Rspam-User: 
X-HE-Tag: 1784549083-620129
X-HE-Meta: U2FsdGVkX1/efUzVwx5VLHmgi/FF+VPs3ft7iAMF+SYgsiYvmQ+Y43nGsp6jghDLboYeKAc1dAEUNPzsjUvK00u6Mvf0eF1WvbGUcbSd8czNh1HKjSycjJuPdTaqANdKhRdvmJYni3VpOP1niS1RvnJUQi31vin2dYguxnwHkfaJo5TyUPaq3vlQe8XxSczLjgXzNpaAId8slGqbUeZ9XGzL32UlVJvm+dI+4QReXE9AvM4G4Kfi3IJIyEyzhUIOVO+OZsOlGUe51wXziZGW34Uvy9zYd15fLW/nBR8CXgfKNcnR8ou3Fni+tvGhZcvLPg1r6nPLYiChdTKXozD8qtUngPjCAQQ7cFXv8G+8ldJkDEe/CRiicB3ADIy5ffHwe7GPdt56uJcxh8r0Vz4v3hh1hYEOt4qvG+efnlRO/QNoFwjRY6xhKD+oneE83jvIwo5gmffmrqkP8i7pE8CmdZlruMSmJbbuL6fINe4hvFm8ta0jxBXT/0I3E83AELGzcsD1gc/WNtoA3gHGKGhChdX/Pud4Zhf50MmXFT5ds0AxiBk1RDbXImFTy1FsF8/Yz3JvL1Hy08pfl/h+O5pKHoRwyDN8/PNLqRbOYNP+TCTeXPH6T0+69NySJK1ffYciW+Arg8FfFcahskfOpwCASmeufABNvIG4Q+1G40JrqAykod6aXZIpInuVNg7zZmCVFCnYvqV7MmORC7RkR4JWBAY2f2mMamGY3UM9qhsW3UkDdxORtarVKPEeX/zPLo4iqECbXprOKSkHuFM/EuUZ/AXR7a+3SSxJdNATc8z2+hfnONSCe1XUN69wLBK20QApDbZtUU7vii7gKH/iZAV7184x8KPDtbbtBQ8PTf95L6W6sQ3d9SU8EYePQR/0SgxHwEM/e2MXHfhW9fVSrnFnzLZrS9Zb7xQVTnNUPdPmSKrcYSFIcNxq6+0TKpmQ18IrxCnUhG+IooYmsMyxw9I
 jRdkqDJQ
 N02tvHgTl6REc7lxAXinwXT53qYztS7cXxBMFPOVon6BV6hPT6G4OdsSAJ7tD6HgvMZxqPJmRKp4ZNcIbhaOXo5y9LozqVtS9E04DNUUNqUoZzxm1Iax+QKKi82ACmzxmp6UhjYHZpWuX9qrDUO//lJYq1AQyjrHhvhi8sKFuvma+d/dcZYAG9GIsZewEgxYb5rz+yIcEPbUGUdQBg8o1r6MUxjoREvgd30GeaSZ+0kSnLNVC5sA8ktSR4257b7XYyqOTmRi5nykuLyPT2d4rF63qAGzXQoe3o6VUdlBGO86srydlzpSRvPtQ1m09KBDCygs0YDVjYl3Yc2Dhdo1JBd/Lm7B3P8TgWnjHBqNtXn1fQqU8zURP4LasDtX62LcZWzCO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,
Thanks for pointing that out.

On Mon, Jul 20, 2026 at 1:23=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> So 287d5fedb377 led to suspend failures on MGLRU-using kernels.
>
> That's a regression which justifies a Fixes: and a cc:stable, don't
> people agree?
>
> AI review asked a couple of serious-sounding questions:
>         https://sashiko.dev/#/patchset/20260720044103.905191-1-richardycc=
@google.com
>

Hi Michal and Oleg,

The -ERESTARTSYS concern raised during the AI review seems reasonable:
1. Over-Reclaim: If a task has already reclaimed 900MB of a 1GB
request before being interrupted by a suspend, an -ERESTARTSYS would
attempt to reclaim another 1GB when resuming, resulting in up to 1.9GB
of over-reclaim.
2. Incompatibility Node-Reclaim: Since reclaim_store() unconditionally
converts any non-zero return value from user_proactive_reclaim() into
-EAGAIN, it will not restart the syscall for node reclaim.
Given these constraints, do you think we should keep -EINTR in
user_proactive_reclaim()?

