Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 435A1FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 18:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145516B0088; Sat, 25 Apr 2026 14:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5ED6B008A; Sat, 25 Apr 2026 14:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B746B008C; Sat, 25 Apr 2026 14:33:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4EB46B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:33:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40CE01C0202
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 18:33:10 +0000 (UTC)
X-FDA: 84697925340.13.3B227A3
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 73864120005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 18:33:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EaI2ieGR;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777141988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJshWvcwsxjlIoj8Q3H1BefpMOAGiuUxUCuAhnCwz9k=;
	b=wxDQJsCJj+yrxHOhgx1Sr5roIMql7WmIGWSTKtU5rRYhGU2CN4cioxiJlVm/AgekfAUcsp
	8R/K6c+Sn0bNiKmWeMGi3NxqkgZtLrkx6T8HpXHPJwc2Uu7GTiiM+WVMJCxFifJ384p26s
	ONgseEDYFvZGO1WlREWbOku5mLksspk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EaI2ieGR;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777141988; a=rsa-sha256;
	cv=none;
	b=dGY8ANlFN4vldxfhTKZzoP2IdZTGi8B8Xr8do4De5fe9LBlnXilrct5NMA/vKR2AVLdvi7
	LHRu2En68mAllTy52aFzJvdW838qYbwh7GR9jXLBLgb1jEkP+cpjjL1ZgK7NrW9RJEIGcY
	EH9NiL9OFySKzGjiJVNvhJV9Xd9jQfw=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d1872504cbso7629112a34.0
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 11:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777141987; x=1777746787; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cJshWvcwsxjlIoj8Q3H1BefpMOAGiuUxUCuAhnCwz9k=;
        b=EaI2ieGRqUMj642VwP79RsX+uRHTxCrhs8aPxihbzA1fTPdVUU8KlYyihCLH0zgXYB
         cJHHbiOMGMjY08uRbAyHrFMrFR0UrhWVZkMl3HJLAKtT3+CWj89tMObZvHAqtuarFHTZ
         7xLOKPCaU2bZG6AS4Jc1J8A4CcQ7vmREpjx/08LmOxoq4+c0/TTqDRQfWwovATCKkrBY
         dd4buolMgv/+4Nny1yHTHjwildy3uGrk/ap5H9/97heILzYdRxPhz7FEfMKVPhd11AGk
         U+UEZ8+Kg960L7jHdPqG7eNoJOWu4+0qsYGNpjOnqNKfB07A4DkfQB6RDqU/qLbI7yDF
         lbSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777141987; x=1777746787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cJshWvcwsxjlIoj8Q3H1BefpMOAGiuUxUCuAhnCwz9k=;
        b=KY00j+YviyYvj82N8+Zjt9l7U25Ebx/N8/DK9x2LtbkpBrGempBxplBOSzFCu/9R0o
         OuEG8eYIbviHHxeoQFBVbS5CB3c4hUAg9KrGhvlj3+BXbG00q9X7EMR4yuIqX8IUUa2u
         gtkRmmsGGNP6R92gII52DnZTtO831NmOmaXF/SRWr30CNGW3QR0ZGNF9epz5lXmluhTr
         i22F4t3EVOPy8Xf9USLk11ROR2TMexS979kxcjEOVxh+rdQlSoFxH1Om4GGWa2RKCdk1
         05MMjTuZxAVWLnhkF6EUUyi/5bWH8zW1VnSUnB+HBcbVkyErlkLrwvTpBWf88EDLJuvx
         VIQQ==
X-Forwarded-Encrypted: i=1; AFNElJ8LGzhAf0nFDX1YER5W6cW1EjWtSbx+Cy5Sac6r//yr6tcF/zA/GaEdRuqcWMcotbco/JOQmC+uqQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4z0Mm5Sote4nSGxFaLHo7oNnc5ykWTv4mGz0iRO3HgLyWFI5l
	LDd3cE657NeoVVdNRSJK4F7pDuW6as7R+mzgXZ3Nn+qkpQSi+cC8mbhM
X-Gm-Gg: AeBDietamAZCRf1JXF1X4p3fMC3/URYswsRVBucnCJSrFXZBYqsCMOuSlwJYZfKBYLx
	9Z3255FLTG7bsRO5nJtnG+jPFXdBop9jyJ2+s95m1H50c86IlFd8Sfv/MnDbyDbHmh03KI/jJ0q
	5qWE8vKFAOiAtMyCq/iud+smY/8Eyk6xRbmF31cYi2TbsdBttXDubrarp0XPzJCcpooGOmS7AIc
	mP59JypqLh/8EhKj3G1V66NXMGW7zbDOzp4zBB3ioKx1C8tShOpQlJKK6hmCPc8jIxHWIvd2fZs
	RtlznGS6FZg6S1+Vv2Kn6IE52XimojEieVBWir4yk45HJVn8inddoDGTKWZDpVZZKC7Albm2+gb
	Pfef+UikcZHQsPArydC1kdwQbIpaPgYw90XjxA1d55JkwLCnq8Ha1AKFEZCUpuhlSmKx7Av4TQ3
	zQvDdpoIOS3onc3h1GX3oewc4NzKM0WU4P39uTVQzF8sXNOXSGiZWrfh5uq9WxT6Swzph4cVHg0
	LM=
X-Received: by 2002:a05:6830:f8c:b0:7dc:1bcd:43be with SMTP id 46e09a7af769-7dc954fcd8cmr17333646a34.5.1777141987475;
        Sat, 25 Apr 2026 11:33:07 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dcd63e4780sm13608401a34.14.2026.04.25.11.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 11:33:06 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org,
	Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm <linux-mm@kvack.org>,
	kernel-team@meta.com
Subject: Re: [LSF/MM/BPF TOPIC] Making memcg limits tier-aware
Date: Sat, 25 Apr 2026 11:32:55 -0700
Message-ID: <20260425183303.3749926-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <CAN+CAwNwpjRf9QhgAEhBQZD7r7sXCzLXqAKbNrPeMEq=7bX8Jg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: itqf5fuw3uuehoeqgtme18ok9zw66ub7
X-Rspamd-Queue-Id: 73864120005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777141988-190173
X-HE-Meta: U2FsdGVkX18wA4cu9mmWwlVpE8s1X2KWcehwYvU+Hx/wGypwJ6ixhPzrxr2N9hwqDXZNoSoHyg3JifB7gZ70II5WX/1og3CiUHKmIzSfXFuoiBUID9oksvu0fDYmVaOxyI/lLBKm/lqywl1hlFgt/QaViC3Elq9xclCSmBBVfolnilDkfznlQE4YtMrg+UIMJ9NhQHpesqAKS6gOmLawXKeP7Yzr/J3p1l79W04nfC6vImRcGMFE8F2c7R3pGDkxhHMQorbKWfj/5D8gb5LdnSIaHgf14awBhcMIpiF7eMd/ykJyP+dHKLayR1TqcvU+qMcOULyqDUovUbS2rjs+AAzRsXZD75BZE1+GGE28Nb+ysmAj/4N4lsMCccmUGF6NVRfFTA6TQyLRWH7k6slhMZJqJ+UciZ0Z1tAAe/UD1kryyTlOMxIqXOJFX+e7I6bHuEAKep5jl8cLz4wWNOD1AxZi5Vp8S+eecU5QgNKHUPhJynFrvRPZtjsgy1RTfxXwcLNW60aT8TeHUqb2177sva/IJljNI0rwvhfBv93ZUpEuzlsUBpWB16S0EDVJ9rbDyBpoTb8we2SSzfkZJhTM7zKiKoFYCUlJSXChhRcokEVMz+2FfFKSl6XZmIufAhCc3X4kaA86tDe2cij/L4dIivbPoQ96v3hF7uFrnuqbO0YGhNDxjCSOKr6kX2sFItakfecXNvhlHgXZXZYhRXrk1/R3VXXpQ2HoTRJyQI1BppBy9yUUaN76eWXmNkPeuIPBszDWHTQEabcmBkyViQc7p5bEXR0pP0tROuEHobYIWSSSsJl1TUg/XR6UVRrwr/a4c1N0QmxwbbucfLfyqHkxHcnZytc9GWzrCnxEmhFHmzkw0KzwlvMXQlGSc7yr5tjmvUxuA+mreBqna7gGBo+CyX/C0osHEmkcan9P3s9MHBnb9xqO002pSpvR0IbxjKIk5fuZ4DERoeGOz5t2dQX
 /Ymg1/7K
 m1w1oh8yW4BNGim5YyxFE1VyUgcakVE73OQIScq6D6hD0rcYGK5PgX/9isQlwNL9wj5dt/9vXdPN/wPteLEggB5qWld0s36aBgI+c/srNsG6BbgEEs0o/fq29FLg9hgpMgY8ZqqBM6NAfGnBiKeCAcxD/E4PlAwIpS3n6wsKmULmSRxpwBAh5qJ0SbGKe2Oad6xnW4vO1IWv0hFejLYZfNJgJB7vTW6pSbeUFr3Z9D+enliKelpetpHt7D9CzxJqc3OxtScH1WsQeJgB3Lx8CG9rgx0D2nvNrwjzXfpiniRsWs3PNcUHFc4nzdyFSfzJzIWty7o21bNM5JLdtt05BMHuGAvHOrqJVCbm1IeBqVCQdeRBWgIq+3ggbAXVfiSNGNx6nYPj4TAFlQ7mH720hBvH+oK1S2U9eDyYacP+HC9xCHSNVkdDZckK7g4MviXaMvuDlLry5RbhD9o/Ioaa2lbgek1U88VFGaj6BAmI6x7629XsJllO2WXzvDCJ5iAoVLATFJFasWRFxnPUh5haoIb4lTcIgC3L1m8TbYOGWzvuAcaVYIycWsHkWC0/Va4qv4i0ueu6+mBTzTtb4mGrFMGLTrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 10:44:21 -0500 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Introduction
> ======
> Memory cgroups provide an interface that allow multiple workloads on a
> host to co-exist, and establish both weak and strong memory isolation
> guarantees. For large servers and small embedded systems alike, memcgs
> provide an effective way to provide a baseline quality of service for
> protected workloads.
> 
> This works, because for the most part, all memory is equal (except for
> zram / zswap). Restricting a cgroup's memory footprint restricts how
> much it can hurt other workloads competing for memory. Likewise, setting
> memory.low or memory.min limits can provide weak and strong guarantees
> to the performance of a cgroup.
> 
> However, on systems with tiered memory (e.g. CXL / compressed memory),
> the quality of service guarantees that memcg limits enforced become less
> effective, as memcg has no awareness of the physical location of its
> charged memory. In other words, a workload that is well-behaved within
> its memcg limits may still be hurting the performance of other
> well-behaving workloads on the system by hogging more than its
> "fair share" of toptier memory.

Hello folks,

LSFMMBPF is coming up soon, and I've posted a second version of the code.
I've left some additional questions to discuss there, so if anybody is
interested in this topic and would like to see the it, it is available at [1].

Thank you everyone, see you soon!
Joshua

[1] https://lore.kernel.org/all/20260423203445.2914963-1-joshua.hahnjy@gmail.com/

