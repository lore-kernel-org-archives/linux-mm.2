Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47405107BCF2
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F886B015D; Wed, 18 Mar 2026 06:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E09A6B015E; Wed, 18 Mar 2026 06:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F61F6B015F; Wed, 18 Mar 2026 06:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2ECD86B015D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:21:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFEC5C22E7
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:21:56 +0000 (UTC)
X-FDA: 84558793032.22.DA380EB
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id AE06312000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:21:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ZE6dykck;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773829314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qW/HtjzV8WdcLRBcHrmOTY12iTWbgQKE1pQl0yEikjc=;
	b=N1amRAjUk0vgZNyrouA6CJKmv3oTZB3jQ66KGQl+aFu4z3Eemu0cst0pGj67YVkxQ/h1Pl
	rRPcdh8wkuuZTFIaiCoJwO44B5dDhs5G2kUKx++2KOVi1Qq9C/CgtTZPtWqCmBHIO7xJ9s
	d+a4PyXIPjpjixD6CeG/BOkz5CXh+CU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773829314; a=rsa-sha256;
	cv=none;
	b=iZtLGLaCRs12fzrsIIPbnrW5sxNpUE67a39JSadMhn97BxXJQsFGEZfq+ZTzi+PMFrF7Yi
	hbfC0/deuO0ZIqz8zHV3PPsBlSdAqCrMXnhRS3FE9Pjxl4M2HwiScW8PwA7MmNQMjCfOOu
	HG89EAWLR/8drtOZvmKPOyqs2OxQUa8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ZE6dykck;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35a09e0dd63so7640644a91.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773829313; x=1774434113; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qW/HtjzV8WdcLRBcHrmOTY12iTWbgQKE1pQl0yEikjc=;
        b=ZE6dykckthghINUGKOCgPzPHTp9WzD7K/P7y8ugHOKjSF+QLBhkXM8Cn8CwtOtpZ3e
         WELks5/pz6aPUJ23I+PxELf5GKxhU1+/fNcSot3aJR5yXjn+n0NdohRGAKhvj83Jk2o4
         igtYsOZ0cvQ7vUC7mfjKgNZKyugFQocyTecYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773829313; x=1774434113;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qW/HtjzV8WdcLRBcHrmOTY12iTWbgQKE1pQl0yEikjc=;
        b=cHYQcf83Zid+QMgnUfCiyjE8mPkI3uvEtlej4yPyuongbivGxud6r4P0CWPIdicgCW
         tDKUPunDTZi9wR10Gz9mgxWgVx1KzYRZNRoQMWJe2hQFUi683pJE+N/yGpDbwP1A6IMf
         Ix8taUiKCVpobuokHZqix/4/xpY+oUihkO6aekqjtFBVdQ8CtMs9tC7H/AWtFIwuVT7Q
         RjRgQxdw6uq0FBP+2603dgqDt98NFV0inWNvnr1+CHDhY0IjppSGbEYRJXdpBGR1HQ2e
         3tEHwy28NPjW4G0JCE7o7fxvGZoNo0Wdrw2X+HOQ7zCK9C9eW+e/evLpvQksHQTZL2vW
         Tijg==
X-Forwarded-Encrypted: i=1; AJvYcCXfaKHUIMsB+a9ciN2pcANbYxICCVxLogBXnnYl03/CUsh7hhlAVMyMaog4SnbYUflSal+GfqlUSA==@kvack.org
X-Gm-Message-State: AOJu0Ywhd92GYrmzs2QDbiTipvFnR08mtB447WgYkLmsuBJvP0rPPbaS
	2ysMJK98qW9aBTf15+YwFqI+wOJSf1fUW9K8kVF/2yNp23pwga+NgpDsmUxA8BV+mQ==
X-Gm-Gg: ATEYQzz2+N8sE+wJFsphGqkb9swq8AS+fQ3kqIj9otGqyzbIXn9BRF4wPlEEoP6V9cp
	4d6RmGOe+ojlCKQL6ghjkwtT8xlktc9mB5kAIaCF7n/0Ml8s4/iBJaKVe8uqhl28PJZFMWRrpAf
	Ksb0ITUj8CKxeBbMLYsS5tLwgTx6ydsAYnqHnJ+FCd4Gkda3xVMj1YJbX7Ib0Pu9VjrcWlxjl/v
	fEfnnjA3AIWczyYXgZmPISdvDQNQtzj6mwcEIEUG29++DsbqVgpq8Uytyq9LEgFnm6e5E46/s74
	iTD85Qv+TGSdwuGUUCyzK/SduB8TegEFYSN/vaS+i+laSIkJegreRc9NoPfefTx44eOWyqv3xAo
	n5U3S5jv5Jrn423swVFfJHeRIjDWKYjreCskFzKKmRYxRjFtZaCS8b9a9mrl0vX/sSdDmDycKHX
	ePg+d/gOkZi2u8DofOc8RuPa5ukQkLKhMP8yHWWBad5BvZi8hnDZsq82RnGUP8mYo2pmvBwQ==
X-Received: by 2002:a17:90b:3c85:b0:359:fd9a:c513 with SMTP id 98e67ed59e1d1-35bb9f0f6b8mr2541663a91.24.1773829313412;
        Wed, 18 Mar 2026 03:21:53 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:2eae:ed87:1d:8a5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c741e545d38sm2039576a12.19.2026.03.18.03.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 03:21:52 -0700 (PDT)
Date: Wed, 18 Mar 2026 19:21:48 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, teawater <zhuhui@kylinos.cn>
Subject: Re: [PATCH] zsmalloc: return -EAGAIN for zspage migration lock
 contention
Message-ID: <abp7HJRZQi35wHn-@google.com>
References: <20260318073114.34858-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318073114.34858-1-hui.zhu@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AE06312000C
X-Stat-Signature: 85qyprzrnswpugybcb193tnm1f4pekie
X-Rspam-User: 
X-HE-Tag: 1773829314-909799
X-HE-Meta: U2FsdGVkX1+T5t5XYpcIlVzUMzsnBe0TIPvGWPRXCs0zruwUyBaArEkkD9V8uILYoaytZUFXmuIOU6vAPFpRti2L6o1wRO3UAxMd2swDgV2lx4dAOR+BVyFJnTxN7d3n2YoZKul325uWQl8HP7XBoI1MK7VXzKBu6DKmZOM8DMbGacvtSL9xqEptHnx4/xHNh/nlO4YzaJfLeFaFAN7nJkjeS8XB2tM9OPh222KCqE3Ovx/V/pzP5/yvogwVYer9OEttUPmeNDzJRzT6oC2BtD3vypjfei6cvftCPQ3ak1BsMfpF58rHKqitRqa1l1ERebDr7lPjIjcSfuRJNwKXXHhzyJx1MejhpX5WJxEUQpTvwYuoVM9eLnoiT4YOQ6Yx2/jjoR/roicfoijDhiDADo83q7tN+PXDsTXSt4hy4IPTAQjC1iHxuTYuUIt2zAKaoQiMEnGkmXae4yl622CxhMrMUPBtN+yfEq0SfePSutP978uCPY2kL70GbQVRtnbllpGtxW1oxHp34MPm17/s6UuVWWkaJ5DckAV9FeI61s52w890mpW/0XMIq8zCsIwDHmlfkuPob+SqDVwflgozpaVCybfgYCFKQzjikT2K+2XhSag7rMQ6kTMl+7m0NvvCrFUV5adIxTAK644BEjINxffwvjsL3qIYmNWNbHQfKUllvoREG6RIMc6uQWn8b4+saVeSIsj1V65Lp1kQ83N0zbU77Q3AZ5JmyYw+cw/zANUgnP0j6aEzijF5QBTFLraALPKEQBVtCskLNcTfcWZvQ3A8ZmKzP8e+klMjGzzW1BrfRB2fqQhVuRgqKt93tNu0sRUGLJCG5Ok/59BCUpUzkj3NLHSMuPXpO/aZraudTXmKBCk5Pfq1BcivwfnUCNWN44F7LN6pEoMZgqY8DOz5olqqDfo4NZCh4ub46mN4OR1bX1LTLbAtrQrVTx39PeyG6zFKtWigWrNOF2zZWHx
 WF8ZoVl1
 dmM0o0nXsODdlIWdyR8hsQrRNDQ+9HKP3GD1tVANPW/52dq9udEAgf7WJf1X6nm4tYgzh30ajBrPCZLzOEQMvQUXFpKq8SL4nzYLE2DwYG+mHPlV89n3b6uCk7C9av8Ilsd2PsSdzKUPs968cCotiKqlJjE04cXWLJO8sN8QurhTo7cA0XKhIUn0kQC3hyB4VDOkPqSn4wz/9DSfWOYAycs9AWxv7lL+7ufsgLRZCCNWT25/FzxR8EliZv3SrQYbVVYxUuvdcTqA57QGZcvAAJzpxPVZSJfcHkVGhp8v+QoWLgsO0a7oQzBnymJXRpXrKubI77Bw1bHUjZaWeieA22AdU1RTvmBPdlD1n9msAjuc2fUM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/03/18 15:31), Hui Zhu wrote:
> movable_operations::migrate_page() should return -EAGAIN for temporary
> migration failures so the migration core can retry. Other negative
> errors are treated as permanent failures.
> 
> zs_page_migrate() currently returns -EINVAL when zspage_write_trylock()
> fails. That path reflects transient lock contention, not invalid input.
> Returning -EINVAL misclassifies the failure and can reduce migration
> success under contention.

The zspage's reader-lock owner can be preempted for unknown duration,
so I don't know if returning -EAGAIN is safe.  On one hand, migration
attempts are limited by NR_MAX_MIGRATE_PAGES_RETRY, on the other hand,
those attempts are performed basically immediately (?), I'm not sure
if we have good chances for preempted reader-lock owner to get scheduled
and release the lock in time.

