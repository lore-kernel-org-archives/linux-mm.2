Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F317CCD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 02:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DAD06B0092; Fri, 22 May 2026 22:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D7F6B0095; Fri, 22 May 2026 22:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C696B0096; Fri, 22 May 2026 22:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3206B0092
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:50:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2722140741
	for <linux-mm@kvack.org>; Sat, 23 May 2026 02:50:57 +0000 (UTC)
X-FDA: 84797157354.11.9679561
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 20F0D1A0002
	for <linux-mm@kvack.org>; Sat, 23 May 2026 02:50:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WvRhr+5L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779504656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRP7olD91HMgJfyrvvfbPN89rim5pXnnMPEr2Y7G/WQ=;
	b=RKx/oLcdPJ7arks40HRJBmSJcRRrLQopMiHsNwY138ENLrcieSmzkvfgrjRxaRxrC6TPzC
	Dgbm8bqDm8zdi4I7HWXjFPe9/t/bbNmSRzbdTdVkKPUFS1AzWXvOrvT1UvfPbuoADwa3SK
	Fx+orLm/DamwxwaP1sobw3VKwrdefw0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WvRhr+5L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779504656; a=rsa-sha256;
	cv=none;
	b=uJKvHsi7+YjjpUTl3sdLITlZWYUV8YnLYiNvThjT5yEf2C284HIbQOOlI2iYocgrmRNSM6
	E2Pd+IAbpvHDCmf6CAQLarLU/dT/C2xc2FEnkuyKCfz9DivyFG32ti8kkJC/dBe7ss4caP
	PEoJU+LWqR/oi1j0xsi76EKLcOVRB6I=
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-69d862236ddso717916eaf.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 19:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779504655; x=1780109455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RRP7olD91HMgJfyrvvfbPN89rim5pXnnMPEr2Y7G/WQ=;
        b=WvRhr+5LaoR94u3i9aj9JhuvpbqwfEXcC8JIOBPtMinLh5gXC/Vl1qnaxdufSeNDFx
         UcZjr/FAgR8FCWPhKzXGs70nAujONhaV5S6HVdEiUaPpYFtGSUJnbleqZP6Me8OKOrV4
         aUu9PQyD1jMuAs68Q1R6AdZotM5wyidC1FUN511cXtq6tmSumlewpqv8mn6Bu3vUgxEm
         clw9O6k225U5hFfzovcQtYsndHTgIGG4tazU0aRaKT6wO8j7W9zgGdRD5EL+Rq+9x93m
         Jlw+uuhicepdq7BVb5pCf+rwrsdaRixpvLbCQF9cpWY41TjXc9NSh5XETQKrtM4FxE7j
         jhuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779504655; x=1780109455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RRP7olD91HMgJfyrvvfbPN89rim5pXnnMPEr2Y7G/WQ=;
        b=FrFf4wynRMWKIEGswToSOXGxuq3Ce73+oe8ummdrMeZw5dAew3y80BKZY7J6gDJBRK
         hxntbwxP4U/lO9UD8gyynfNud14leiewlHl9FFSGhzS2ClYBrQIsSa2d8uG4ygUhM5i9
         m5xdMaeRWwCnx0+pRE6Ya3bZXIsh6rJFg2yIj1Na9cLQY26Ziv4J4thHP+Km/iUSMOUy
         LSADzy+bhkGXRUNmynv/1j0BDz4FfGYP77uFCnqHSnQbes6I5HgQ/J1Zxxi/8sH0gXOa
         uhqhfqkM4kVufpOje8AjzwlWaDVdblce7yJk7N2H0xMKi60SbZSfjfllMXI+7pw3Q76N
         moag==
X-Forwarded-Encrypted: i=1; AFNElJ9ZG0wT/eimqRqJGj+KELD4k0U4PlqenHbs8OYb7x1kKRftDhtzYs4ogJxxcedGeU3z0VjdPZcJaQ==@kvack.org
X-Gm-Message-State: AOJu0YxuPfuzKI5o7aEuqoGop+KcHVxhXltl/mdX/G7yct5C77E/xBaI
	JsAqKAP3Z4ZRmuYgy0BNaGvGXxxB0JOS0H3GjZZ3pboe3HL++DbMIg5A
X-Gm-Gg: Acq92OGe36wkHJ1L5PpWxR3zu6j5HIHtNryyokfB+VG8NdYsqo/Esl2XrYsIhNUH73F
	qtOilDkEzsTac4voKz+8SuaydC9+7Z+btYENXyYqylaMvfZhmP7weVTQ3QsLjcBppDTCXlToa3P
	WhhQ7RKJcSHS1g9Bq15MoeRXPw+6NOm8TPfdGDzcnt+S+BQ/7RxoBjbfWOirvDZHwVE4pYcov6x
	3nvgrWpidKyjGGBHPU7mTgrduopJp72c2rMIdtvhcrDTO+ZiQL9n0uKBKTvf2+ztfIbF1+XF9c8
	nsfWcTGz3Kw3ISy64p06R1d3uwJHauTwsSsBQzbGD7CK/vXsRMqa/NnJKH6fto6nxzYXJnLwLnJ
	QmTp1nlx15S2sjZS8/5U/loEDhHSQgVQ3tSnqyjjNUhHuwMevqRVpd5ff2DFEB4UF4av4pPk9VG
	83IS3CmlcAro+xgO3kMeHw6fJpH+vIFRsHCunBgtAtCNbE1btGYcg8cqd0Neeym9/RVR8fZxJcr
	Lg=
X-Received: by 2002:a05:6820:1c9a:b0:69d:7aa1:bd7 with SMTP id 006d021491bc7-69d7eb64572mr3483666eaf.21.1779504655191;
        Fri, 22 May 2026 19:50:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4c::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69d836c6f22sm1853403eaf.1.2026.05.22.19.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 19:50:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 0/7 v2] mm/memcontrol, page_counter: move stock from mem_cgroup to page_counter
Date: Fri, 22 May 2026 19:50:50 -0700
Message-ID: <20260523025051.170871-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20F0D1A0002
X-Stat-Signature: cwxj1h6rafa6cfmi5gzkf7ntrhsj63gk
X-Rspam-User: 
X-HE-Tag: 1779504655-203609
X-HE-Meta: U2FsdGVkX18QMnSVgwMpwbp5TbGYs1gsLESl9fSyXmUUmYcJyAL1xhvII5VcF9Dz7HgYrUbX5brMVPEKTyM+/xkeBYwP7HAPjR8foNLR69ErZgwGZ2tiYpH4iiDR1QAGjKiuDHWypVe3yCjTNguCsW6/miQf2JRd4gV43Ulgo723iKTJrP5sfSGCoWHcvEKsUVsw/GG4EcBuR0Nhk1IULv9jzNCOMkvnbxLiK7VrPVrnM6w//UAb+S635hbMU5x75mllQw4Ra0sFjo6AFTVxf7XpBr9aIkif/k7vFvuhsh/45aCSzzdV2sfq8uTdlZY/MkAENcOWXR1jC9tpF0MWQDKfl8kN/yd6Ynz2tjbCfhgPidrLYiaMDKQuzGNbj+MPz1vwlZktV0XR5pMWkm6In4fkrKWf6wovgfl8iz4qM21ul4QlX+FrILNYbv4KrzJtGaDpYgL5CUuD0AKIFuEqGSbx4WhMhRwHhvmjApbgPN7xmk7Ee+N/RRzavOM+4Fn1G8AFSOUsL3nCsdLwd+3QFaYwIT0e4P/CQZ+xc5k8y+n6q4tbqprOXn8Givron+DS8+GR4v2phyQ7QGZnZo1Ly9suYXihMEeDbwVnuDb4XCpCsfFBgKr5+cjhXlKZpJuRDAcpY1wNDfFiWEwBvbVdQHd5C9Sqpg4I1gRLydg8GDoHQM7vWlZz6HDG3Ho6RQ+r75C7sHtQVYarVErQTACDzDQIJ/38og3CeqCJzVlmWBH7lucktmRZZYe2zco9/lQIqNYCz5tRfGNhwsb4Q14yz2a1R4Y6z0GjARxJy93SuRpBWrCT/f3HOaRLswC9SzHa2A4a9GtqMnR4u082Ht1eGYkRH5Bkj8PSvg9uJIbz5u+jk1xguWgEgecy73lmExNGsrpDU2vyXO6cKSAz+a2dbOyZc80oqItfI0gsIZ7FBO/M3vzkhuaptuiZhh4EA/EuuqCTbi8I1FI8p1FkrBT
 41szHf/U
 cjOTxBDltHOuVmkoIt+gXADJSzjp98TiU97aOdKl2nd2QU440PiVpyWK7sBsLacU7SLi/kGC1vcblyl+wB8RQeKwxQfPpzx3stohArC2I7fPzi1EprCtM++Gp3ujXwSjvu1BwjeUn4/5I5dlwG/tpWGjinKkufX9KxsfFOpe2t6dOodKJkEB4Wo+KtQGFzb0UW30JcVXF3WibJ0CChtelsJprgdvtkf6mk1oE1CywQF+a4c6YxB2jdE8FwL/KcRcPF1fF9e3EgxpenBlHlXl8wNtTkh5a7ZrQBPIaggvPRHT+RPKJ/LDpnEOqQRWMn4IYOpIDSO43IHSkzA5fYRMtqLlWm6kmpqlJAT0NRmZm3vBoXvPieoSW+E9hh3DHsA5QfQQxV5+Qe8TsD4Xq/QSmRTmp83stJDi/AM0jmL7jgAZlIKh4wovG05ECdnae/rnQGpWMHWiFBiKxGdQsImajSkk1Zei3+B8W+NED8IcdpcPD7sfDJNt1kIipxVA4B8DFKOXRDWICtNGJ8Cu6bnignCz1jeectD2xNkQ1pV8qIPCgxLm339iHP1SgUvmrBKaiQX1NLLW5pnEMYZiCB4tN6/eadls0ki5iPmucL4I7Ipzfgc7KTQbXlOkMd2GhvyRGhK5Q8DnVApCPP/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 15:06:18 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
> allocations, allowing small allocations to avoid walking the expensive
> mem_cgroup hierarchy traversal and atomic operations on each charge.
> This design introduces a fastpath, but there is room for improvement:

This iteration was developed and tested on top of mm-stable.
I'm seeing now that Sashiko cannot apply this patch, and I think it expects
it to have been built on top of mm-new.

Reviewers -- would it make sense to rebase this on top of mm-new and
re-send this as a v3, or should I wait for feedback on this cycle
before sending out a new version?

In any case, this could have been avoided if I just developed on top of
mm-new. I'll be mindful to do that in the future.

Thank you everyone,
Joshua

