Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3AC3C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 21:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845AD6B008A; Wed, 19 Aug 2026 17:31:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F69B6B0092; Wed, 19 Aug 2026 17:31:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E736B0095; Wed, 19 Aug 2026 17:31:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A71C6B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 17:31:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6244160620
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:31:10 +0000 (UTC)
X-FDA: 85119314700.10.CEC8D2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C723A80005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:31:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BYQfE0qB;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787175068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghs6iPSRrZGeJwUGIyYt5eVaUbmSLLAA1KH//Wk5utk=;
	b=jgSMb3PKksuqzpl1/or6NaV/bQ9tqTc6SdyMrM1ACQqdhDGR7AVB+cTUeTYVOqN7amA73S
	jkPnTFZ3VVnFjtSk8rkS+dIHyh/+C3M/WSUXz0zXLC8APEyEQB4KsRQGTyZvVN9Iu77A3E
	kFffA7vlehEuiTnDbuwdyziZ+yRZBOo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BYQfE0qB;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787175068;
	b=ccRWrPo43tMYHQCe+GeeFBq8n8I14oxUFSukrzTNHR78piRe72UG5kuzDo1JjM3qQBEDIL
	PBxOPeTkqbdyrFqWdHQ0an7XadrHHGNvi3QkevBRRI7V79ijcfnK3n8KFyUl6Tl2sJ9E2I
	6o1gi/wezu+/ehjBpjhMYXshSLeHmAg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E459F40558
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FF01F000E9
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787175067;
	bh=ghs6iPSRrZGeJwUGIyYt5eVaUbmSLLAA1KH//Wk5utk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BYQfE0qBn6RQTOJEi/H5ED7wk4DSJu3aU94pOT1Ga3wT9ZlVjFXZz66cHn/I6HI6U
	 gXkI80jZOhcbS8ofV9XsokHHtoW6uK5HUpY+WeC+3clBY5wAd/SP38zgm9C/0o0O8e
	 zhkVBzKH3CbLe9ZQgK+JfaIGSbG47BlPa58qgl6EmMCbBfp6j6d+3ckmn2h0TxXRiv
	 r2kM2SeSfWg91KwMSWTothUM68f6KEbl7atEnG5y3bW8ypnzzJ2jxqInVGZs+vKvT+
	 eQnk3S0AeDx6HynmdtoB8lq1KdAmFkOJaw5Ai4CPzw/hG3nP1+3hMCMKfb2bcsDEG+
	 R3K70Ysw19s4A==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e6391b114so132186585a.3
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:31:07 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw72xm/AOhc5YH+/qaRdeBFw4MWqf0Vud9fii2SV+iYtPisVzJR
	+K3C4BeQFJuYYFSTQci9lxGBtTew1W+EWl2nU/8vWmjABRJWQLHXaJbsMx6dysmHC7V8Af+OGEH
	C1/AhMukNkTBwllXY7zAupH27NxstzA0=
X-Received: by 2002:a05:620a:404a:b0:932:d9c4:3bec with SMTP id
 af79cd13be357-9371e74b03cmr764971685a.38.1787175067210; Wed, 19 Aug 2026
 14:31:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com> <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 20 Aug 2026 05:30:55 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zNZLOs_w1XazV471d66BVaNq9bVj5=2ZjT2u_NX=XmAg@mail.gmail.com>
X-Gm-Features: AcwNN1WZoGwAs-dfgWVX34j6qNueiuUcgi24sPh1f1Z4XRF1e7IHP_M-JHHISY4
Message-ID: <CAGsJ_4zNZLOs_w1XazV471d66BVaNq9bVj5=2ZjT2u_NX=XmAg@mail.gmail.com>
Subject: Re: [PATCH 7/7] mm/mglru: improve code readability and harden folio_inc_gen
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C723A80005
X-Stat-Signature: s34p81gogs4ukuk7r8461djapkgt4wq9
X-Rspam-User: 
X-HE-Tag: 1787175068-439332
X-HE-Meta: U2FsdGVkX18NtdxxMhuoRCQvysV+VLrA2Xjt2XqXbkbifkpC4fLhQPRW+8F1MIz5p1VbSgCcJO/StjHQZTG/5f+HZchmJszkDqxBT/eqnInxoVip7rbUJvA0YzRsMcfUVpdacqAmBmMxAnnjaMSGJxdGGhaF9CLAyQyehFWkhtyN4l6b4c40eC6Z0KFAYsfHVSkdztzutomAGJLUXsurnXCVyZlFeF9pXMx2/TInPXCvfZrDrRs6Fk4XWvTzyff9TH7ZcxbL53WH6V31BhmvFtj5p05pqDmeQvdUBitXtjzkK/dTInjkKx7nzHTmWTjTWrGr3Yyw4j7P2il9A2q3LVsVegGM1X9HRBmOrOzRtQQNn1qfvPSqpiox4jctSljbd+FlGSAmmqLRkNXzjBWvzdiqFWOwa7Aj0QfQ/amYT1ifBPHtS9XJ+vWU95JxnUdiAnY0Rjk2uGuOI7mW6X3X6/JS3HE23wxy5C6OBSLM8XJrjTVYE39mToFh+hLRAGYWPkj0o3qTjz+bHzCtWLpYatzdrm80iIKfQ/CqDxSKmEvbXzyd1gmCattjaQy3e/RH6u4AUxpLk+PWVJ8H2yd97B9NNQ0MlvHOE9xxK1xXL0E6ygR2YCe5dqQfONs33oV5GeciNEL0O5Ddc6VqZb4lCjYOzkFu+ziyG/P7jKJoMSSYtIKJJqC7BBJI0LPUII2OJ//4+Axlsixv0I9a/ay5p093xyu/tFrxxwjzbFe+qcPXG5xWQ1arYUrcUwUZ1Ben1KVNqBQnj8hiEjbHj2OPjushISaG8xCbkQGdV1JQyAUzjMQXNId+SHbxZ/BjZApoQkk2efeB5i1DpkeHuMcWUWa0IIotkOaQTaWrDgRZQwzTXiwQtc+dGM3FfYhZtUzJW+0wXe5+4ij0g4iq7kREzXyiLTTYNDftk6X76Jah/d6r2tNyR5em3BN/YGghQfuAm2Khspa/C1FEjU7IHvc
 QtBDvXTM
 ecLudC40KFF1RIQJFrkFysP28DizcKiTlfm1fLZQZBiZgNIs657dwM4nj/B1tt488jVolE2o8YDt+uHq1pLyFz0zaan/5jV7F4lD8FpGdWWemFDGVbCzNaGkyd1ndb9WTXXiKJUQKYIKM/iBGcFDHyjlMe4d8qyTQg/0VCJtaio3ZgCcWr0vLAIscebIwudSAVQIu8eqN0XYixYnG2++PMbKyrsIy1QsvziSuM3Vssd4fjcUtTHS4POR9lkN7H0JkgqYjybVxHoTRIlP37qwrOenzb/js63F6/rzT/nQkHAIxKwT9Dc7bJEe/bAaEFit72PVNVbGXKPf+KBpJjJVaMhaUoRLjthBjJhZZrcB9FnG4RlUx0ynIJ6uk3pH3vOMRTtx3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 1:38=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The helper should never be called for an off-list folio, and it always
> expects the folio to be in the oldest generation before doing any

I'm really not sure whether that's true. Could the folios have been
found to be young more than once during the last two or three (or more)
aging cycles?

> cmpxchg. Add a sanity check for the off-list case: if it is ever
> violated, bail out and keep the folio flags untouched to minimize the
> damage, instead of silently treating the folio as if it were in the
> oldest generation and promoting it updating the flags to an unexpected
> status.

My printk shows that a folio can be promoted two or three times.
If a folio is promoted too many times, is that the cold/hot inversion
you are trying to fix?

>
> Also rename the variables to clearly distinguish the folio's current
> gen from the oldest gen.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Best Regards
Barry

