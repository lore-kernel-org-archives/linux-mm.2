Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35F6606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=hmBvVYl7
Received: by kanga.kvack.org (Postfix)
	id C6BF86B05B2; Thu, 12 Nov 2026 11:21:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42CD6B05BA; Thu, 12 Nov 2026 11:21:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B806E6B05BB; Thu, 12 Nov 2026 11:21:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89F096B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:21:38 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C9A5140657
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:21:37 +0000 (UTC)
X-FDA: 85426982634.14.EAD7CB9
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 514E3A000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:21:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hmBvVYl7;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794500495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvwIi9PGGXoQsiA6+EZQf2O4ZXu7pd1RUjro27vdlbw=;
	b=UiS9dwCYCfWmYZTeekP4dH6x8nIvR4GTZsGDmLQRAF7dyvys0aiyiesc6kAjv4ax0bteq8
	1nmS/tDcDCU1ipuSGckwFwtudUAX+ApEarfgYdMEw2Y9JpNA1xdAJeA59LRmKbOdiEIFzz
	qxVKzqL2usafx47E/6rI9kMhswZYqkk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hmBvVYl7;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794500495;
	b=lGrY63Bt8GbOZOOlB8BDfvFUkERFWAcs2d2k4TdgYFijnEQqvgJDg1U+1KtO6gb8z3VaxB
	sxhMugdpyX88qXrlnPLEs37lNGG7jZkeBA6SVUzA+XObEiLwKpx/NP2px3YMzwiOnF0Zkx
	n6u6AH4kWNo4il7P9QMWeIgp0jFjHqI=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8b0d126f631so481797b3.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794500494; x=1795105294; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FvwIi9PGGXoQsiA6+EZQf2O4ZXu7pd1RUjro27vdlbw=;
        b=hmBvVYl7wFCVFN05EKj60K7LXsD4GBcapQu3ZvCeceG5G1R2ysH/gWzi8C3kIU+Qef
         WpxSTbwTSrYD2xFW1fMXyqHbyUTb/WcY5hEKQ46Xqb3sVuWfEE/zWULX/RqmwnyJDAMM
         J402TzbMSj3j7tfGzD9ijkbpsN/L0nxeZVSAT+Sv/e3wqc7pliJPJBiU+mJMvG7qkFHC
         mgewttxpSISI/z8KKVxPus8c6hhIrnngBd5O/JObjEPtwSohdyYFK8Ke3ypgfU54kjzN
         IYT0nNK5fuWpDxE9lwir1qlL02YqbFaIigb3tzQOR5upHuF6d8pSsuzUTbb5NzkF/8zj
         eKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794500494; x=1795105294;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FvwIi9PGGXoQsiA6+EZQf2O4ZXu7pd1RUjro27vdlbw=;
        b=z3w9ugNmoXMqts5lVjBCInHa3T00gJFUleE406jOTuaezVyhmZZiluBJbgYeTPlDt2
         tYz4Zrh6zcSa/j6pMdXSwHHtutX50PE75PYxWy61pzDD7yxe+ym2o/nbmSJJihrg9syt
         oAE7ZxjkDIFmEKRgITEEZlWWtLqFZeq40OmRjnc4kd53KlHfaqaDcP4ryL2rslCbnA3m
         /81Zdag+Pb1bzgl8d+KIOw52qWmTZlLqXZE9wG68bKePciT7ItmRKROXRkMzddcMVn9w
         Or8pxu49/+L1C9CgQI8Jbzy6E39UEPF3KkiUqMt15sh1iieWJ6wIO/Pny8oS6rzyh/4v
         ufzg==
X-Forwarded-Encrypted: i=1; AL+hErHsV8njBEyWFbHK21HmF56dND7LkCa+3rPv4Hx7ckMCsMpV+DaAl/ijqdydEByHrLoSzSpuSD82Gw==@kvack.org
X-Gm-Message-State: APuU4Z9XzZb+zaeFk+s2J0CNWf4XSOnTV/zc9jWBu1vP4EwXhSBMrGlY
	OSsTO+eexewXZtgpFEzADXZtTjwcKQjyMOTf+hsZUK1jKygzy3kf7Z+TU2OlgOWCyfw=
X-Gm-Gg: AYBFou15AZMRL3kR0YXnFp1dNccgFfCgODeWOetmxn7v//I03YSSp7JDBeyFFsL2Pbj
	/y8HnD11Z6v//l6/UfnjKSah+cEPqEOVl6xJxMZAwAGrW041Z3pOdubfokdcjaU9lA+LgVLw06h
	1lIjfHRCjQztO2AOVMDFkAPmWMmIx5R4lxtxeztwNGh6AD5y/C6PW0q5nOw3lsu46D5+jgGSjMK
	07SmBObkOy29pNeONgllYtgl/ulzZ1S1Q+DQB5pYx3e5yN4yXRNCUu2zKElGmV7Q5nXsX7cg/wM
	B4xDOlRj89JZ5Yh28oGbUcKcd5sYbapXraLSO10zs+unzNkOl/0QY7NamsN47RwntwPaAHvE5Im
	vRyJ/VL9ohnnWZk9EHpX7vRxRzGYc0UKxFw4BDkFCZv85zkTYI77RMyZbFWyQUniSfaUtER4gNk
	s2/PkZgwXifi1cYNmxXohxkqTnO9Y+53YAbRe/J4iXZZMixckzT1PrV9h2V8H4xr7OZ0ZLXvI4g
	x6zKJr5m2lr2SaBNw5bnxKFtXrqqLa/IksAO4CVYNJQdJfPDOsDvyHGSQk5iLgyZQsrlBQuIDNr
	e5+78UaUj/4IWSUDZcBCF254Sltg
X-Received: by 2002:a05:690c:9e:b0:8b3:37e1:9263 with SMTP id 00721157ae682-8b4aa3ae8demr296007b3.46.1794500493993;
        Thu, 12 Nov 2026 08:21:33 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b393426f13sm73450137b3.34.2026.11.12.08.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:21:32 -0800 (PST)
Date: Thu, 12 Nov 2026 11:21:31 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	terrelln@fb.com, dsterba@suse.com, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, riel@surriel.com,
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH 1/2] crypto: zstd - use vmalloc() for stream workspaces
Message-ID: <avXni0bS7twguZdt@cmpxchg.org>
References: <20261111153532.1036709-1-usama.arif@linux.dev>
 <20261111153532.1036709-2-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111153532.1036709-2-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 514E3A000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: z4tceb1cfwjaccu4fmcf97k5mnxhe763
X-HE-Tag: 1794500495-284861
X-HE-Meta: U2FsdGVkX18fPeNIGmBC1M5l6xF+/dcrpqTvxlWv81EB8Rt3Bn7SB/AzlYgjh/LOAr0r5Ybp8ekfZVVEQJVrjfaVwz0eff2zaV4QfnekpFsp7JRoOd7Erp60FP7X1TWqm+YyKXdy40vfR8ioVe9hMVDW2+OZ2zX36zkVZ+AtjdCjTqaS1tJK3cUTFeSormlAgTMLTLgQa8dbT6qE8n41RJgJjDRuGR6U8U8qSJpRwM7Xl8pZGJy1KiSHS028vnH7ZXTGuV0/HIJRTse14Ls1zW/XTFyeNofhAL4ChnHxMKsXZgOluC82PZMjXc84yPze3ixumTa5bCXT8SuELJojOQXLmU6Nqv5HK3QemO+nj6wdzlGX+F25H/ZHBPlneNjxjhgcChYDJdpaUIdnrMxEJIv7piZu1IzSpsW4rN7tzNV8JN8w2HNO6Tt7AIQw0RH8TmzJevgRS7DsGq4cUglPbdMFACJl4uwKviC8qvMtQhXdjTQb1KvERo+Ytexj40zheD2T2sXlzlRl8rGQRHBqhj7xFpncsqWHmyBqfrtxlFtSWYNIOPM3R1MDn1gKnfAMZFcQ/cESd+eVfUirRQuQMsDPED9NsI9VYWjnak0ElJgCizr2KLfEqq7p76w0O7XIpXbTX+WBreWSX8XrPtZJ370KB1NJ+VZwkCesDZodSn1rviesvkTxcDRGTv0XRAWqwFKvxNNN4WscKlyigD1yRpXPcenjn/l1KsuCYDg+ZF9vF8dVjwGgclcRIe7zC7YY07Yva4OwBSU0uErCXo5NghE+n5y8yeCv5ey97Yu35wdcGIhY7U5fQXwGP/6BAhe0ddOChckSJL0OdU7zaybQEEXnlI6kU5TobEeYngF+3s1tTDr6o29SF6bshPAF3lJ1PLqCCRnbl1fmVHJqb2I+RTcTQaZyo+SgV3HX+OKxHwxBgx9Cxq6OTfxXckSyJrQ5L7GGS25STC4E1tlJKmS
 lB56w9xs
 NB+939YXH+vDH2Pa8CfwY06PVrONHjmjfBTpN8gRSae3H1QjIN70ryni2q5IxBPKqillt1aQtSOFJckWs1S0Yima8DfkRyiRtisPry+WHuQz2L75dMwrCdxjTyTevGmLni2FfyNTsdriU18PqzuOkTYf9lGABtyy8tRvNVPx/BS3IP9o6mivtfG1R7TAuFcxkMl44xHlyoyokGeCdN2wq4XuYQIAlELb5d63d8gu+8pR4Yz9SnWVe7wdRzHQSjzi6LAExVUQYN0xEggzUUG55k+QuJgnFZ/owo+z28LUDNpzGvmj0DkKiwieIht7HsRHw28M+nodaCM67nfEXWVv+NGektMApPGr7LSKRaPIOIYxV8t0lB0XBfkBeBDGRn3SURUhMRuQ7FcVNGOOPYPeMxxwKx0ob5qrdIw949ff1Ogb1zvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 07:07:39AM -0800, Usama Arif wrote:
> The zstd acomp streams retain their workspaces after the last transform
> has been freed. The first is allocated during transform initialization;
> additional per-CPU streams are allocated on demand. They are released
> when the algorithm is unregistered.
> 
> In a 4 KiB-page x86-64 build, each stream requests 1,566,281 bytes.
> If kvmalloc() succeeds via kmalloc(), it occupies an order-9 block
> (2 MiB). vmalloc() needs 383 backing pages (1,532 KiB), 516 KiB fewer
> per stream. Across 384 populated streams, that is 193.5 MiB less
> workspace backing if all would have used kmalloc(). There is no such
> gain when kvmalloc() already falls back to vmalloc().
> 
> Use vmalloc() and vfree() directly to avoid the high-order allocation.
> This uses vmalloc address space, page tables and bookkeeping; the
> figures above compare workspace backing only.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Nice catch. Given the lifetime of these streams, there really isn't
enough turnover to justify the kmalloc optimization to begin with.

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

