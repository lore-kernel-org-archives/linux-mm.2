Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C28BC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 23:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392596B00A4; Mon, 21 Sep 2026 19:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369996B00A5; Mon, 21 Sep 2026 19:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 258F66B00A6; Mon, 21 Sep 2026 19:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4F756B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:03:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55463C0313
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:03:56 +0000 (UTC)
X-FDA: 85239298872.13.9207324
Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5B9CBA000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:03:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B04qbAeO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B04qbAeO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790031834;
	b=U1XHlw29DjDn7BndSENC+6QHfC30nlwXuHhfHELxCy6gV+lMqHi/b0oyltk3//TJ6WPx28
	LT4g/6DeYiZrCClsMvYtsaRLn0u9wMHjB3zlXbGeShVEXxY4VybVqSTPLvS5ZLWCbetZer
	UB554eudWXhDmthJ3vNRgAPPDsti2E0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790031834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdbPBPyzaOM2wXlSY62pNAL0ZMKs+usFBD9FO5JbEdo=;
	b=ZQ+tcVsOwmUjN5h42+l/dJ77Tfw1nKri0Xm9qTPI8lmlGCjUmSoHN93ytFq4qEic4uGF+w
	yo67krrAqy12oP4o4GzAtvIwQI25UzNH9BV7TG2gTp3XDdVeMQRIp2xT4VRfm/fRgC1pEx
	UP/AtfZHSEKuLxuDG5OGu9oCPL2yh+0=
Received: by mail-oi2-f12.google.com with SMTP id 46e09a7af769-7fcb425fb68so2049035a34.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790031833; x=1790636633; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OdbPBPyzaOM2wXlSY62pNAL0ZMKs+usFBD9FO5JbEdo=;
        b=B04qbAeOSdwfGN9Bid6mnY4CDO1YIlu+Sz/AW1vEjvttGioCPrKouA/Ji+19CPoudD
         dP5XT/N/NrGkFyCQktmsG8ALP3lWK2pIGQOrUogRIvmAUWmPRFhjHecFKuN4eKTsLWr8
         XBYTsTvjjwLtLm5c4JR19dA85Kv2ZU1Bo852/rd858E71VWAsWmWixoq2TVqdHRxyn1v
         pYMDzBqIGKGLyxmsTa++8ddVSqAe5SBx+VE/+YnG7Of0NYNjo06sqEIrKxv76H80ve5N
         cl2dk0Ci390hDOMReT3YBTZr8svxM9t9/WCP/Tr1/q+h/RihVZWbTn5dMspYCklTXc82
         sGpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790031833; x=1790636633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OdbPBPyzaOM2wXlSY62pNAL0ZMKs+usFBD9FO5JbEdo=;
        b=1OcdWTxP2hDgIrPJSuozt9/GNd9bzgzm+p7Od7QC+6wgmnuQg0TnRwss4qoH+eSlk6
         F4IziEaCqP8wisP/IQmYMH+L254S7fvfG+QlXBshWWaYiSKh5zRs8btWArG+XWD7/6ZW
         CXvgwNCwzmuwzhir1YxIIGMrAZPnvkIEjwdJQdcw9/QjbWbpEft/MU2DCPverYchM4fR
         EQKg8RNvXf4l5leLy2QAlmX5yTMNEEABhrd1menTTpt4iDC9T6EszRMNaphfUildyEoI
         VUFCkw6oHCCBxJACPmFBdXT/wqiB422wY2P+kcQNEKcE8qOFy1SMFIl5qJ36I+rh9Tze
         RIkw==
X-Forwarded-Encrypted: i=1; AKwUvBzND5s7UnEsardFoQNcin7yXiMJFFBNl9FnKd7N2omfCPkPgWWjaNT9dzYYAGMC4sVmAfkE8lTXhA==@kvack.org
X-Gm-Message-State: AFuF++k7KfRHsWhyTkAp3EmQ0/j+ZBZU4BGC14+5IKSqbgFaZ3znwom0
	MjD4M6sSUeU9aNrEN6pg3rItyjzrRZ0jjnj3RgiAcT4AxHquEezNaT+/
X-Gm-Gg: AYBFou10iWvnWeoxmZXgXt6vgjZbSmxS0W6V9dMkYhhloCMr3QJRKf/l7wLs4aGRGrP
	ZF2B5qPYQ+qR5iTTNehnZUAtaFNPtuW8aILIerX5sAl9AezKsf32HKTiNhim2MbI5VtiR7Q5PqU
	2EFMsouJvPzCs21+rYC5k678X4oKqPy4plbiMca9MrYXbQbld0Q4gWBdK7o2l4qhoxzrFzWjbhy
	wlVV4zDhg62z2jhetbNWrZnDNe9abOxQ9AG3fEvzjKwbKja8ed7IlD3KUEbEA+qdzOdeDjOo1bq
	sGxKmprVn2kbQ5vcDUDm0MFq+2bNVjWEnKr+utFOhilvZC7ZzwBmPwNDBUF234zmzObt8yP0R70
	uK28vuPLzyIdp3DKDGfnjTZcnqlZExhIkIysDIJnnd1cY5DunBTSE6O67gUdEpaDhemGy3Um1Ct
	aT3cb/PVoGHp7E9KjUz1Nd7osAAB0mG14h2flvIVCjhmNE/ivniatWQ6jslxHJQZXvm5qdR7jYx
	Zg2K2szf+yteIwdMx08NPVFLzUm
X-Received: by 2002:a05:6830:610f:b0:806:e047:cd7d with SMTP id 46e09a7af769-80de045b1d3mr12860708a34.7.1790031833370;
        Mon, 21 Sep 2026 16:03:53 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:f::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-814e648bd3asm184805a34.17.2026.09.21.16.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 16:03:52 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio
Date: Mon, 21 Sep 2026 16:03:49 -0700
Message-ID: <20260921230350.3649114-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921-for-hugetlb_state-v1-2-8a6eec92661f@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B9CBA000C
X-Stat-Signature: 5kfb49jnrtxus3zns9uhppsk7c4fow57
X-Rspamd-Server: rspam01
X-HE-Tag: 1790031834-144264
X-HE-Meta: U2FsdGVkX19TwdUn4o5zqMrONSKlIOey7uw1sdhoIQIT4Qug1vvYJVdsf3jkf/Z8ME1xPRmcfPpoN25PUlNw2u6F8EucbdD1CQTFPrWgpKdOVwlhIv5THxqkf0ppc08SHcwcbzsJDLdrQbvbBx9WPRHQWG+WUWjm1npG21XI79N3sP7PAvv/c+/6atFqZfCRj0dJJp/JO/c62F9rooPcrA8B8mh5ceMNRGdZlKLXzAXexLOHRCn5UNdaYlzGVRO6n0at2PI/HRmfrO0LWTJHzkyfiAVJeEr7mquwg+w6Yo+TecmUdcbFgSzNYpL+PhjdFbJ53WNCz9WVznnGlwVhOA3oIf0fC010UpjBRbxHUioIAA+qWVpwr9g+jR5uGVaRvL6b6HWWMns1BCGmTWUGXQlIWrAvrASonco2y3wJY5liEnmjeN+o2GAJWgF9YTT4lVhHhXrlWur3Oiv1a5sCmm4mS55sz4XkK/gLi47AxxSCST6P5354Q10x2oLzBBx+xUuloAU77KTexYVJZfJaJ6Grl0vvxnYf+obi+BCVnqqDRcV4flJdCgktiE2NgPC05rnFsmIKdGQX/fw8CekzOeBTGU9xtKbIZxs6Put9IDtsKb4DAiJdSWAR9D9PeeXf1INrbk3IeTy6noiJrRb+kz4WCfLdX+Q7mopqm2p0BlvF5o6RYxceM4lWv6OLGw7DzLUr+CpdCib8yiNxbG81k88pwdu1cCYVZTQfMNJRueU6s9iKToCNXouH/S6xk6PP0ONcMR4XOOuitR+RuaYOaxHX2YyZKYw6fu1WH8DuNy2uCW7+DzipCWv8FcezJTZyjwVQjiqeEQRz2UQkzImb2hmudF5y7D3jlMzGA6mBNA3dpGFUxS7FYSyzn/4CWldnlW6HFeYHZD2L02VyvQJIR7u2bh38ixnsESBLAI3sNubEA6iQ/ga2a2QMwIuI9cEtYX93iXu5HgbwjkSOEk0
 0J15p38r
 COsgB/mVg87WKg5P8DgNWVN10psKV+I+zzOeKivY3mUlNIEbQSbzyhanL0CNE0FOrjdvR3ML6wp+imk7ZP3i0JSwnnqbBqR+zjyIbb8tXfIvsL4y3DSoSfUU4TdRRQLOd4srky6X38MW9WxEqywcEdb9W/5jJW55HZIJt7CjW+BxYY3vMr47I4EcTEsC1DKsVrDRXLQkz2cyWCC2ZqKgtOBuWOhZ8IejfIKmqfIzWJppiPRou9rX4P6I0wL9AEo/s1bQwUnGW4+kspyvOp7jpxd8DwvK9pkzrqdWDOLYrm2ka4LkbsVQ1rjRU8zB6tbnVgk2djJ8/B14kZ+gEwY8/o4qBQy4Y5NZ9dUnq+mqtffYxo8JmGF6CiM9OJXDFtT8XoFFQ58t3bweU7JURUzwO0EVk6xrapjoIxIEI6/znNH3gGw0cYHfBw+whiav/f1S0zOzS9ym5NVN4Yd6ELHpxVbXoVa+LfhAfkCetHXc9SpGa+WHqdXuIMEvfki3DEWz6wvVo+kc+j6R6O3qvTS+JpE43ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 17:12:35 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
> stats. These stats are accounted against folio_nid(): incremented on
> the folio's node when handed to a user, decremented when the folio is
> returned to the pool.
> 
> During hugetlb folio migration, mem_cgroup_migrate() moves the charge
> to the new folio and drops the memcg data of the old one, so the free
> of the old folio right after the migration skips the memcg per-node
> lruvec decrement. The hugetlb count stays attributed to the old node
> for the rest of the life of the charge, while the target folio gets no
> increment on the new node; its later free decrements a counter that
> was never incremented.
> 
> Migrate the per-node lruvec accounting alongside migration. Global
> memcg totals remain balanced because they track resource consumption,
> not node placement.

Hi Hongfu,

This is another great catch, thank you for working on the fix!
I was able to confirm that the issue exists and was fixed by this patch.

Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

