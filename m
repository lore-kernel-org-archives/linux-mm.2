Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96845CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 23:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28058E000C; Mon, 15 Sep 2025 19:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8B48E0001; Mon, 15 Sep 2025 19:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8608E000C; Mon, 15 Sep 2025 19:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5CAE8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:09:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E28316079D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:09:20 +0000 (UTC)
X-FDA: 83893027680.16.3C91543
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 87E784000B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:09:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e/3SvV+p";
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.175 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757977758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLbWhAMesv4kKaa+6wyxIVlE3wCdaMoKHTTeB77fRpw=;
	b=z3CjqkYPqH5MUux0+JjyTfA5g6c2KuP1FzaJDFvvbIlTIZ+XGPPU72NVmbyzmeEZtCQSB+
	c3aN2Rxe1ERrvpcCwGUE2OiuX4onEWjE9gbFcHsAI+FpBDm1A4JZfJflLwrjo8OIo6PCci
	aqPyuxhMEMIKdpvLElX+2om4EEQq+Zs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e/3SvV+p";
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.175 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757977758; a=rsa-sha256;
	cv=none;
	b=C5btVlMYC2+nEUnizrH2HI3tcbi/RpNxqPo52u5jlU+bKArNARC9W8yL8weXNsLvN/FGeP
	+arXG9Ly/kW6C2IWZKbVB/D+vPr+JOtHXXc569Gg/7NuoYdSm2mnhLAwgbPxpaFB4DyCkm
	LRzlMaNYg32O40kQHtL3570qAfJ4hPo=
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-4240d243340so8464655ab.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757977757; x=1758582557; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLbWhAMesv4kKaa+6wyxIVlE3wCdaMoKHTTeB77fRpw=;
        b=e/3SvV+pFIEj8+Au+cGYLPIcFut/MNU4zRqIIhcvUDpRGKJFLBuWIh2I45FAQxJ456
         rApev8fA/Qcp3inSjzAOyvkV+/wBI/O+Yr402iH6EBXgYaqoP74xQvu+kiQTzR9S3bh/
         aKzRinwoyDLpevXHIuAPDfjbUPl17CmsSndvJWouyAlWdreu4jmvTIhZuyXVTsI0uiSb
         BwrpiWfiJbMvqFY8uiMYPQSd/3MqQNeEXDs92Lj+8V4OI97y3venJa8X8IGiusHrTWXp
         gEFQhTrkOO9yWgl9879ayKoHhTBQNwLfWPYKO5PSzZBXKkV7oaIbk+O7J1P68HPAVABV
         FaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757977757; x=1758582557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WLbWhAMesv4kKaa+6wyxIVlE3wCdaMoKHTTeB77fRpw=;
        b=U96hxuS8heQy11/axejlwzAZclOC2duOH6wKv+j6xLGqrljMC4AdJRZNlCBCY62koA
         kvssIdppKsZ5PTsJgPvsB3jHDeVKpR31RrLms1Jufz9/M9ZAqitMveXJlRlL0BZ4KU4+
         aONgQmhJXO1IAtFdZLYHahmZxL3XWN8ywHTQtk1ZgBR4XubvMcp9JdHs7JER0Ek5g+SI
         KUlGDx/XXDvoopP2OaCtMgBvNT08q01b1S9lhOsRUcHnwhk8xEbLmW2+tExiKf6SLGFu
         bKPAkdHmuud3tO/pWaOCvOVupCP1usxhF3H/fYOb3Qkf0/7e733aBbYM6HS6uWA+svQn
         pKhw==
X-Gm-Message-State: AOJu0Yxit4xq5DokcWFrLf29nzC0U9BgQ5TE6YXeR1Q0O87XVZmVvbX9
	ZhA0DRM8Z4KAJZYDt5cZsXsTxQxlLN54JTfpT0yTfmmAj5pOFyqPecZJDGKSbYxKnFS8fNhkOMw
	3YKFWJANyFwgals24BOCfFGzKvsPJIJY=
X-Gm-Gg: ASbGncsfLoDqgUoTUimmZQRz3w+6DU+TzNqB4egcWZVG5kuN7bF18EUTVx64gyv768G
	CcbFn0JIfHL5A3sSL3+nAwoOBve5xIuhdUGHUgJiF9BclGI2aTOxAYNHk8ofDIGkrh/L3WHjmk7
	37v0HVmRy5OTiRDYCin0+eI2yw7cyRXCxCFKfzPVfzlZOMoLe+KAugd4lizQDN4+52x65wgJp3v
	euExBu4ykBvqx7qqY0nLx4=
X-Google-Smtp-Source: AGHT+IFp3liNs3Z+nFgrEioDQId/p34S3BC+hmkTnRmQ4IrAAwtvqtnLQxqXEVQVeneOsYmUK/aEj62swSXyCr/2+Hs=
X-Received: by 2002:a05:6e02:19ce:b0:416:75eb:265e with SMTP id
 e9e14a558f8ab-420a4ee1eb0mr152917625ab.23.1757977757566; Mon, 15 Sep 2025
 16:09:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-1-ryncsn@gmail.com> <20250910160833.3464-6-ryncsn@gmail.com>
In-Reply-To: <20250910160833.3464-6-ryncsn@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 15 Sep 2025 16:09:06 -0700
X-Gm-Features: AS18NWAiTIOL-zvLV53DEWjgUqSxzatSBuQJjKN1Ir0R0nY_PrW4ch_NsTyGp2E
Message-ID: <CAKEwX=M6PpOQvqBK3hqfdVubdLE_hdnFHnsBMkxP3RJRmCZ3iw@mail.gmail.com>
Subject: Re: [PATCH v3 05/15] mm, swap: always lock and check the swap cache
 folio before use
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ozwsaytism3hi48hfietjmsgc3qc5ke8
X-Rspam-User: 
X-Rspamd-Queue-Id: 87E784000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1757977758-513467
X-HE-Meta: U2FsdGVkX1+clv1MFwRtJQDv57AQoCrQZvhTu+lA7pOwuj0x/jEDcbB42E2+ugr+yKguWfXetWjAynWE238X5MT5OHOwo3E5tD6cGmqJkQptL9KeDBnnCU4jNSG4ZzWpCfCKcDc0M9PjMqlERwMYIYSv9RMi2LU7a6QKbPGXdvqq+uI97S4hrYAYdVcnqIypLzzCPJwVW6/fVXiG4OwTO5bAcY9Gj36/L6ZoFZY0Zum13Qsk0LG3boi+AGBcqo+1yd30tcaWV3uEvyebc039xPKN5CEjcfwt864Frz74lI12FzTRgqradO+lnZ3JB1TvrGq4vEFBIr+ALE5ZT4ydoWOOCgR/M5MdmG2jfvBoHf5e9Gjn9R4xHC38QkdkDTRBrqYchqP+osGJA7s3NpqtuB70L9Qkhds+OX70Ct0qbwX//HJvj8L8KNUWVkJe+K4+QzaBbCzZkXwQs73D+DqZ9DtKtx/ut3BAZAGjcaKm8UjLA0ONWRyl5JYBdEl4CnMkSOtTYeVZZ3mGQULQ0xavAl4kyrNKpHeXQioA+jR/1C7HkzNos57GFXx7mwam/JNCWPpUuDwisW/IXPXFoKWIR2xzSo6sTYXIHIkJWvzFuuSMZ84ExGVN6v29ERTURW0SbYNJJf0tB5X9dU/daibOjsY2dCvKyyKUpbWw1fptq3r7s+eRnJ17J+B0hWiBCjMoWT3/2hs04hgRK9k6FVU+1sIqpMxV6M7wlh7xRxblAyD0JN4Hq2QzJ6XGGfJvA56OaEaan0lHkY5x7vkd+xXJEkQhB/qaIMPmgcCiq0ONaCYaUlMb4yf5+rNOzHORSrG9yxBVkwxffFnWcybLU9GHo75WWw5PIPIRIMNvi8iw/vctRayfifv1xAYb0h+GqCAc3iKdWlaOJ97Jp82kSOwfuZs5db2i6TTHJu5sZhBp3qRJANU0EI1vLIy7kvaO9VIakts4AELd88pOgZGNzP7
 EtX7Ohlr
 G7pVYvzge63IlRu3HXUjpeowyI9bkaByE9zMzCkKfIDd3ygGWRtlmZSUxJR4KW4On8PEP80htz6LFN2J+BxxpGZF1HcVmw2ByEmBbdmsjeBK6lXCEciNE6hvOcwqefSRm9ljoreO7M+WoqM6s1whT0dHBsbtu1OjCg9rIpfMB8zdxWzrpbjBTekG7LH02twfSG5jDBpPdzQwj4ARjvRwuEMFr7jDUvTeis08uCm2gLkHpKDJGT7tHQsfslnFGmgvV2l2SajL/ZFIZV4XFvq/EozOH25tSliMTNldoJ0FcRg7vpwFPvJXjCzMC2oi80pzWclxzQ9RTZTEjMjs6l85LKgXCw5734rcW0ceVit1k8GRQ31OURCKsoLsV8mfZh8rvF0c6H+Z8qTFCPvmgLLFPPf8mrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 9:09=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Swap cache lookup only increases the reference count of the returned
> folio. That's not enough to ensure a folio is stable in the swap
> cache, so the folio could be removed from the swap cache at any
> time. The caller should always lock and check the folio before using it.
>
> We have just documented this in kerneldoc, now introduce a helper for swa=
p
> cache folio verification with proper sanity checks.
>
> Also, sanitize a few current users to use this convention and the new
> helper for easier debugging. They were not having observable problems
> yet, only trivial issues like wasted CPU cycles on swapoff or
> reclaiming. They would fail in some other way, but it is still better to
> always follow this convention to make things robust and make later
> commits easier to do.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Apologies for the slow response. Swap code is dense, so it takes me
awhile to read each patch :(

Anyway, this LGTM!

Acked-by: Nhat Pham <nphamcs@gmail.com>

