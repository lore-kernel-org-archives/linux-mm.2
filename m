Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2450AF55434
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 01:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37EE56B0088; Tue, 24 Feb 2026 20:54:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C6E6B0089; Tue, 24 Feb 2026 20:54:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E3F6B008A; Tue, 24 Feb 2026 20:54:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF986B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:54:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB7861C366
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:54:38 +0000 (UTC)
X-FDA: 84481309836.21.D9885C6
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id AF856140004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:54:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JZuv4zJ+;
	spf=pass (imf26.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771984476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9fk4HjE9WzW3ynLGF+SH7gNYcU4+9bXvKwvDoOble0=;
	b=Ws38G1FeHquhGhTuczED1fW4kNX7m4BM0oX1pDdTbF2tSn++H6lUIe6iuPI7UArRL6Ks2R
	+eWffHOYx9rvluI0hkjEWMv2U/hIOBXlD6of1o6usSzL5WZVnu3tid3Lf4jX7hVi5fjOpr
	y8FJFR+v3GcwD80JLP4iGvFsQCb5zpk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771984476; a=rsa-sha256;
	cv=none;
	b=A606tMLNxVP3GXjzkxwA3jkcFvZtZWdAGS5cCBr0yDiKInvbubIgoxnbUXWsGyNsP/uaS9
	tlpyA+luNvq0dyJ1FclrJzGU+8sFGTR2uk/KpGXO/l6Y2glnwVTyYTeG9SjoMLoWIjufnp
	RKBjGLuEp8disLPNQMgiIophWsmhJac=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JZuv4zJ+;
	spf=pass (imf26.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59e64657f0cso6685652e87.2
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771984475; x=1772589275; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9fk4HjE9WzW3ynLGF+SH7gNYcU4+9bXvKwvDoOble0=;
        b=JZuv4zJ+9qnkKcfDEFW7aFn5Tck4FsL3BRSiv6AzMprFCjw3bgA1T4ks5nU466uEw/
         TbtqBTxVQSnlyGNHBK4yOlj+cIfpBIVwqMLzLu6RiXqbgoQBpsrB+mIRCDSAatKGMP8y
         mb8eDs9hsyRUr3RD3Bu5+1QObw9yjeVPy1Yn2/Wg8d6iBMCyM+5KByYCs+1uSLHj+Dnh
         8zH43rCXbw/2hbdGvHxdBp8Cpb5Dl2J7M3Z3UqOFRy+eXddYnBFvSSVoV9Z1kiVPCO/T
         g+/DXep5zTO1HZaOPTfg4R1uTP4L4EpWwntAUhl1Tur+ZInhVNKvjvCQycGA7EpvyS/7
         NZ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771984475; x=1772589275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y9fk4HjE9WzW3ynLGF+SH7gNYcU4+9bXvKwvDoOble0=;
        b=gaWrmxmT2g6V7qXCfjeTH+qE4hTiAh2vBrXQYep8HjF5C536RSK9fzlRdJ3WivR2Ml
         L8QUV7ytlUYXjL8VjZk8S3kZqo/dVwGLEC+ycu8lcieE53Hsp8hjghcbxJodYziFfFdu
         huYmzsP3c7tWrdWgTxQNdp4ao1MhEGgH0ezeJZqsK4+5B08pFja9RNz6jNJhlMqpQyZS
         ZrBnyg9TX96phFG3YKdXauJAZzdD64BxeHGwyddSNoVFEWggftYjXCZwgakNvlI04duW
         yKUl93FeyadRkhRnYD84Exu3wHcIPGiAwbmW/vP6x8857K1W8DQ6DWSzC8qMoGJhDNcX
         nLqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCopWSYrZ8yedR19aZn5oPh/1RxyfMDZAP63m/xo2wJ7TyvYkX6+ce07YIo9sEz1b58XEG98OSPg==@kvack.org
X-Gm-Message-State: AOJu0YwvFbiMy10Uru4yI/u68Mnp6cTWNSQUeDtMQSH7U+Ig5QifssU4
	VI8oIc2aW8SoYLHfkxkxksMMhv8hkFEEyYWXvLHn4nODba+vYiDwumIL
X-Gm-Gg: ATEYQzwY7VZc24XbHzVtbAFc7kcjVsWg+MmnYPqBmbyZr8i3tfIkbnegJYfYR2sMaVD
	pX/ONrx+gJo7CeNbaaSh4H81svEHIKI4KHHQAhWVb32TPPFt8LMeT0aNt42Zik0vq5IWqYcziZP
	CrIjybPuJe/DsMwyrk1G5kOaxiHX6XBLHwNTpCyojSt09pveJIEnq7MctKSV4KoKNHRPxy+6cnf
	K/nNX0PvCkdBdWT8DIlU1AlwbgAZESk8K1fTwrdZTvUFLV6EISHvdx5JMi0WkmkRDJhiCqBlPVA
	heDYd5rOWX322BlnpLCExicizPc4ERl4g4Ac9zuCQpe0wh3H/gPodaXrU4YLl8pbFdXHY7L4YfA
	AgfoDTf3XO4R5nDawXfdILrJZSGJtOAxvP9Mn2XNN0GjdEu4uKeyZcTfA6Jv+G2S6DVHw9t5Tuq
	ocpQRp7qEQMJS0GEmntQM99H4kwMRRLBh4NEtdtzWZHYk0
X-Received: by 2002:a05:6512:3e02:b0:59c:b819:1c13 with SMTP id 2adb3069b0e04-5a1026e0328mr162412e87.26.1771984474519;
        Tue, 24 Feb 2026 17:54:34 -0800 (PST)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a0eeb3ea71sm2569037e87.60.2026.02.24.17.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 17:54:33 -0800 (PST)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: chris.bainbridge@gmail.com,
	harry.yoo@oracle.com
Cc: vbabka@suse.cz,
	surenb@google.com,
	dsterba@suse.cz,
	hao.li@linux.dev,
	leitao@debian.org,
	Liam.Howlett@oracle.com,
	zhao1.liu@intel.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-btrfs@vger.kernel.org,
	regressions@lists.linux.dev,
	mikhail.v.gavrilov@gmail.com
Subject: Re: [REGRESSION] kswapd0: page allocation failure (bisected to "slab: add sheaves to most caches")
Date: Wed, 25 Feb 2026 06:53:59 +0500
Message-ID: <20260225015359.1495283-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aZw2LyOjxMc-c3dl@debian.local>
References: <aZw2LyOjxMc-c3dl@debian.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AF856140004
X-Stat-Signature: fdsgbsd697pdhexo66ztwcdqxxunzjt8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771984476-705363
X-HE-Meta: U2FsdGVkX19cgl9NrFH58JsZW2OWVkUze5Q3Il2TewErnDQDT1TFcQjmX2WJVldtjgmdn/qC/AiUCWI9qejVZnr/xGW4t+RhDmMbps945eUNTpF8NIeiCI4FJjdZmMSYIQWHIfVM9CXWlkoAj1i7HOQWZ+GnunxV4APhjq+Pg9rWJceSCYs3NG82jMXko7yr0jaX8qlmIlreRd8Sy1hVWDDh0Cd30k4eJCQ7jKrMzPN+sGK5iQN754cnrtO21XmNlON0k5dHt8RYVOiX+/4OMmBWAxwNJ1qahYgfWjgPfYbokHc/gwFli9apKyDeSUVgIHjKHFkuUKByUol4OEKoZtLSgEEnRUpcfHoxYS7ZTjgo93foj8PRpoQRyr+u6QbJtu/lix6BvZdOB02mxPYkp8aiShTd5FvRKTKrjYSBzXzZMPzE9lkoCvFAi9G4ugwg2hkDyGJfPxp3rrCdC3yE38bipQ+3IymiKTiWk1prxkfCwTkFU2ihGsTleDdQKmOnGnbGbFozWAbnE5g/qVwRzt/ap5exW5ZZ6TQ80LIINKYHrvUvK59joB1ch1b2zw9ebfx/ft1mpW1LyKqkXASI0oV7p24k4A421EUWhvd8Ju+DarAwyQUK20Ze87qTIInN5fhcdyLG19eVA8cUi8kzJAbfPzZen8ruNYqknraF86Xcn82U+SbonT9J9PtYErFa859YN0kLLOb8xwvUNMbOvUzD44QnZPkUsWBEN4m6l7V1ezC7IPAQorun/l//rMx2VAIXujXeDQ818Eo39kcg0Nce1zsNJQWMqwd6glLCUMYc3inmjX5+MacaRgnh+4hly8PXIIdmpDgSylDTP0OvdxUh8s9c6T2cG5uJHRg6hi3dp8XqKliGph5x1GDZe9WWHyoEqqb69wq7s72nGaDAl13mDI8rhfD4WIRNaOcsMOBBslwfXcWBnDYZyKxuuu4Ju2mBdylhMxQcTZobJ+s
 RhkwlBdT
 m3d2wJu4y0HbKpjJuz1d5C12sXbYr4BSC9npYAIxAgE/N/C3khc8R1HBVCQkozunTCzz6O1Iz2uUo5xS2yvmhlsnFoQxNcA+oC73+YTzo9jdpua7DgpRtkifv3JXS+aNdwWDXk+/UWr2hHvAszQJF94RPrLmpr3j3Rj0qtFoABLQ/hDbZmfMoOzggCVODdnG23h3bubrUlyZrPt91pPREiUz9JxhXKY5QmPsjUvOqbmO7kRAQZo9KE0t5OYbLnw4of/I48cAmL0BW4SC89Sq8qjggP1sO6i4qbqc8toGcA+L0Ng1058Btoa4WxnmOq0MgtqP+qvzLyqIGhdQFgFHAurxjZtGj227NxJ5/utk47aOKHxsPHCOce7xhBrKzrLA93p7cuLyoIxPhvRO4r/yP1SDF60idEIGaKAAEtF5ywCoje/ixy18Bfc5oVANlfLcLVXyiaPFnsJBPdwFX6u7KdeIRCSlDa70IRbhudMY1OtfnUoNv1/dyG2FnJaXN/qlMk6N0Rupl3EfZw8luALWnu6Yrhho1DnJ6iD5QOusKNMhDDRrnB/ElZfUwZAFUesYeMJI0PtNHHizBExrlmb+zI+2lwAehQDqsi4A1RJf7BckDjYAKSoR4f7qlN17z7+qkQ0KHdvdOBLVHd7FfX+qK6Bgsunt5ie4WSVRk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I can confirm this issue on my system:

  Hardware: ASUS ROG STRIX B650E-I (AMD Ryzen), 64GB RAM
  Storage: btrfs with zram swap
  Kernel: 7.0.0-rc1 (commit 6de23f81a5e0+)

I was seeing the same kswapd0 page allocation failures periodically
under memory pressure with the identical call trace through
alloc_from_pcs -> __pcs_replace_empty_main -> refill_objects ->
allocate_slab.

Chris's btrfs __GFP_NOWARN patch suppresses the btrfs-originated
warnings, but after ~10 hours I hit the same sheaf refill failure
from a different caller -- amdgpu via kmalloc:

  chrome: page allocation failure: order:0,
  mode:0xc0cc0(GFP_KERNEL|__GFP_COMP|__GFP_NOMEMALLOC)

  allocate_slab
  refill_objects
  __pcs_replace_empty_main
  __kmalloc_cache_noprof
  drm_suballoc_new
  amdgpu_sa_bo_new

This confirms the fix needs to be on the slab side as Harry
suggested -- adding __GFP_NOWARN to sheaf refill when there's
a fallback path -- rather than patching individual callers.

Happy to test any slab-side fix.

Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

