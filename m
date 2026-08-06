Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 756A0C5AC7C
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F056B007B; Thu,  6 Aug 2026 18:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22A06B0088; Thu,  6 Aug 2026 18:41:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B5D6B008A; Thu,  6 Aug 2026 18:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFA706B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:41:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF6311C11E2
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:41:17 +0000 (UTC)
X-FDA: 85072316994.06.F88B22A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 00AA514000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:41:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EdRhmhnN;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786056076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QyVFKzEEV0m1xTiYCgvkDr7qDlasrLsKgh36Es2GFLM=;
	b=OYE40CK7ES4W4HJyVtiEvk8LijfOgDfulmWHjxTevI4X5BE52FKBhZvexxUGsJzr12AIl3
	VYT8c/6P6xDOqsZmvBzAby35HJVePfAip4C+UVhH0YILuQfPye38XB/rh2IOXu5TYE39Qc
	8xDs0ehUVYldNl2LqlInPAe4iHq0nRc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EdRhmhnN;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786056076;
	b=7FqOFVcfYht9akNHwkMwh4798Xd487CfdFMFFsW8W9hJFOtYv6OWHns4HhxxW8pygie6r4
	PXiok48VnYE/aczU7M/jkAjDBi6bxllN7TIFR9wLlmcfZYRjIw0fDB1xIC/pzMn2bINUYA
	a18XQdXPh/tW4RI0CbOgLnNJLZbVyok=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 19D8D6004E;
	Thu,  6 Aug 2026 22:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566D31F000E9;
	Thu,  6 Aug 2026 22:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786056074;
	bh=QyVFKzEEV0m1xTiYCgvkDr7qDlasrLsKgh36Es2GFLM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EdRhmhnNGveD80x3N/aymifmjnRSyksCcgJfwSWgvwFWpvzJFXMOHlmMv9eTs/ony
	 X1SWWIWJ7MGNz0WtUqoLkPP965XlBkvf8qMptQV7eyIXYCzgyYnLxMjdLLmXxsRZ0c
	 AZk7xhMEJwbTZR+s5JSjTJhbR9vgIIB871rwuCnE=
Date: Thu, 6 Aug 2026 15:41:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, nphamcs@gmail.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v4 0/2] mm/zswap: Fixes and improves the zswap shrink
Message-Id: <20260806154113.fd52c4c6207c6945dc77cf79@linux-foundation.org>
In-Reply-To: <20260806070943.95542-1-jiahao.kernel@gmail.com>
References: <20260806070943.95542-1-jiahao.kernel@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oda81pjcmqyjzt7kwza3gsnp6i9j338m
X-Rspamd-Queue-Id: 00AA514000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786056075-395272
X-HE-Meta: U2FsdGVkX19tYrgLl5M/tT9Ke+loGoXJ5nYVBwrd21a6GWmd+aLX/5nv+2VJWFqGv56ujKG0qzSyUmxiXdh5c5V1gL2EccyhgYQBY4/UAtatjqbRjyUjE9EBaddRuipWescP4UDEtx7OyrIq4QdiWICy2TprtunDmoPRw4QQjx2mJoC4SoWWIkfgFo1fUGAltycHT8VbrDxxCt6B9KMqARy/m0gQ4xI6fWEPRTvDr96rZEFu9+ngINuh8ap0BGcF70DFUTJgS8rlmP9LeFw7lHy6jYYnFtZn993Q+tU7bKPCrntBalFH4s/dfLF5VMB3zWWkpeCiLkCD0Yfsxe+QSfAv3vVKEyUb3IWP3jVGCu8cjmatYOF+q6PtV8dknn2h9iM6oY4nFx4OQBTISual8K18Y9v5AzYDUxThLRHYuE/enH8oqg9oYfE/coGQiVOe9RMj3mru/THo64c9d+N1bO9dWysuf7py5+T+ZAHBCyxvxktLqUXRvRkO4myAgZwHy8/UXrz2HJdpqs64IhwoVy11fdROAeCRf4cc4GH2RNlwDUQtMgrJc2zaSKv1wBDv/8AwzXU+BfPcYWWThkp1zDjc6U3MpSAPfCRFg7nVbUmPRL+eK/VT612YUb5/leSSfB3i/dncXs3cTxNU2DC3ZVNObeoVxrf/wYxWH+DdwqBDaKTPx4/zMS9kQ4dflUWYA5adEvf5gOy2bbgy2OzpRvjpM0kQ3P2b4ZyGLjnhx1HE39ytF4HEJl2k2MDwrRGsbXXm3ds5XmQSmc7oCiVooDGuJmkAENB+ABvnHlFQVRNbR+hI78T0Ol0jNm2mF3Ysr7cTaCiYWYVvfMVgrns5yWBnhL70jWwtvz0/Cb/rrv4zRir8lHdXymRE68jFFi8f8T27rAFOFR+9+bHZE+O6ejh0Elj7TOSypEN4cHxJO2Lo/InwzajZiwS/w7WTScdGDD4AkO68HdV9IZWySjx
 uzZ1eAYh
 /3mnOeB+KkpXSUANJ6Wj5t4y/jENG6nGEHwf1Hx1x2436hFuBYISNzl+pdQkfZXQcgtUcVGjHL3MvR6wuJ0IWVS7H8c6eym5lJOyZRLWYrA5qz8rJ+zLSDxkdUDJj5MT/bpyAi0J+G37Z3cWbZp6e3IoSGKnLMq+5i0ujbUOwLkKyTGCAoqCcoFg+woM3n9xRwNyl28SF8JEMXJXHMG0k7UdQXd2lNO3sdvYVWN3cTZirDWoh+DUjasuFbqR+1mjshm2riR5EVhJmUtFKquBZ2sfD4qIfd3Y323XRokh9P5WIA5KHZwMDX9Y+l4mUm4jZ9E3FV3M2Cd+LgpguEIIXLBs5XUQsccKk3gBKa+CDmkJx4P7O4X/LElNuEkSE9hPe6XpSlwsgDXqmhggDBdLdrIXfkGHZJvz3Fw2FbIhiOpbcHJDnS/pZnbihJrhG2UMAwYQhcV5tIK0MHCzfDgNKGxs3bZY4Sb/CQGvUcmQXuoXzBVVwai93JD84AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  6 Aug 2026 15:09:41 +0800 Hao Jia <jiahao.kernel@gmail.com> wrote:

> From: Hao Jia <jiahao1@lixiang.com>
> 
> This series fixes and improves the zswap global shrinker (shrink_worker()):
> Patch 1: Fix missing global shrinker when memory cgroup is disabled.
> Patch 2: Extend shrink_memcg() to support batch writeback and thereby improving
>          the writeback efficiency in the shrink_worker() and zswap_store() paths.

Thanks.

Why is a -stable backport proposed for [1/2]?  Its changelog should
describe the effect of the bug upon our users so that others can
understand why this was requested.

AI review suggests there may be an issue in [1/2].  Please check?
	https://sashiko.dev/#/patchset/20260806070943.95542-1-jiahao.kernel@gmail.com



