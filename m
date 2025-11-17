Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9441DCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 22:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD17E8E0011; Mon, 17 Nov 2025 17:47:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9B08E0002; Mon, 17 Nov 2025 17:47:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6648E0011; Mon, 17 Nov 2025 17:47:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC59E8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:47:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A8E0160251
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:47:18 +0000 (UTC)
X-FDA: 84121586556.21.2E9D048
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9AFA616000F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:47:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KglGifxK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 386UbaQsKCPwegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=386UbaQsKCPwegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763419636; a=rsa-sha256;
	cv=none;
	b=VrMkzMwBgfZBf1ksb5kQNy3QGgI/yDABwcbyklORYEcKOz2wtsYHy59Hc+fbJ2LjmOYJcy
	+wV/FLC6y9N6CzhyDPQMLogxMXhPkn0wnR/Sjey0rfV/gRocQlzlBEgQ8okf0fFW7qa3md
	N+XO2AexIx7CAz/Js2SKrT2Ra17rdO4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KglGifxK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 386UbaQsKCPwegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=386UbaQsKCPwegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763419636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lad1asYiF8cA2ZLix/TncpNgjY0XYbNhIlYI0rkVv5A=;
	b=YsJZRO1yDdLk0yHpbL2JARGHC0OkIT1ECUhV6A2KUJQ0AkVJvwOhHHgjkpDt1vJRihCPfm
	Wexqh/k2V+MRYP4uiD2V7uQVIT7iaq1QboP8Xi2ImmEyeCWIccALqmq4EYgHA8fVbCL++z
	zkVmHj6CswF68S0GWbFxbvNwzHFnFxY=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343fb64cea6so7263310a91.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763419635; x=1764024435; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lad1asYiF8cA2ZLix/TncpNgjY0XYbNhIlYI0rkVv5A=;
        b=KglGifxKNXoikY+m8vycdfH4eJLup9m9Fmpj1+IrpmW8Nexp+xsNNQ+5NEb7MkPiLa
         3KpYkigtOrnZ/gBWQLjNcha+lM+4pVjzK0PALWRHbpEyPzrcHGizfS7rv63mYPV/J7jR
         9UPLgI71yO2qCvAbzLsPY7Okn83pQjY4d3DoPVjm422BD++LHFjszqXuZKI9wVGAZp8l
         ppe2Nja5y8ORyw1mQ5VbjyoSdyDFF7T3D5z8SfkOI8PSBuyxBFgI2YZZxr1w36+GlDwh
         XR1pw9xvA8CXAIKtL3SMy1yVR0xz5bH/pgp2BuCMuS6Y7/retNRu3AIbbUwq4EJfKLeN
         yPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763419635; x=1764024435;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lad1asYiF8cA2ZLix/TncpNgjY0XYbNhIlYI0rkVv5A=;
        b=qsy5Ywc6M0xlJD3RUtq5E19/lSVwgeSIuPu68rUPzOrvJtIt3c2EceSUxw0CH0CnH0
         9sk4OkpjLj4y2Emsd15MjkAR/eEVCXbLVzRdU5ilPty4RxMoXZ7IKped1DcQ2hSLZjLI
         Bq2g2FnEP/G8+LyZS2VKk/urO3kHKzPMUD6hhytsf7CZAW+27GHrqBZe9OS8HnVoyPuM
         hmjA76g9oJUIhkxe7xI6CaVcUZjodIGbzQ1wpfn2DvDknAeASaGpM7rSRNj9iEeqtBAa
         22IM2wkkz+cz3rvqHbkHZG6mSFrQ8YvDyrKeWe8IvizVljNJg5MKX0utE/1Fr5vxre/U
         0h6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWi6lRFPo3P3OS5eoDEs4As34/rWIcqTNql9hT8qv+IV2OjhzIyXQ2OcOCUpOIpH7q1sNhz9Bbmpg==@kvack.org
X-Gm-Message-State: AOJu0YyGBfo4gFed7QTg6Ed1NdcBSd64ZujuCDF9HgMRHYAnGMOi1r3f
	/P7lXE1it2sqxaJJ0OJe1LJPZqgXdkk5GuKT69uRLKPG+/yA3YCRoa7/ZgcYFq8SMDCEW4By+K/
	U+PU7jnFdv6IeUzJ0MUOKBEGFjg==
X-Google-Smtp-Source: AGHT+IHY//5/zSbJ96y0G1CVtIuXJVFgzUswEPddLr7yG1C8L/6rE6jUZ9/sELe1ezgM/wYNnndev+VmhVo67HX+sA==
X-Received: from pjboc6.prod.google.com ([2002:a17:90b:1c06:b0:343:387b:f2fb])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:350c:b0:340:b06f:7134 with SMTP id 98e67ed59e1d1-343fa62bcf6mr15075381a91.20.1763419635363;
 Mon, 17 Nov 2025 14:47:15 -0800 (PST)
Date: Mon, 17 Nov 2025 14:46:57 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117224701.1279139-1-ackerleytng@google.com>
Subject: [RFC PATCH 0/4] Extend xas_split* to support splitting arbitrarily
 large entries
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@redhat.com, michael.roth@amd.com, vannapurve@google.com, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9AFA616000F
X-Stat-Signature: 16oi5jr366nfwbeheszbwykmnyj43bik
X-HE-Tag: 1763419636-24831
X-HE-Meta: U2FsdGVkX1/djxSzJNB7Og7VUWSUB3ZTuhv15KgE+BZu+a6UoOgynTYyAtOnz6uX4+mLT8w3mBcxHCqaIbfSxcitm6TwrqxrdsiQt64HHYM7kekyHdymqvhsoGKr8Y3QEWnfoDY6WxTSL5Uc1nY88vCYkaWM0ZqxGU/BMt+4pAzVJMeBp9XVyzqfgh5lkrJWbA7bv1CioyyXj8rQw1ZmsAnS4B3uinBHEXx80HUZW+QeaD9CE/MxaH0PMcx5OhlBnHJYwC3H3AHyIOd0R8d3DHwABHRv8h0Y80ytkvdhxAXfqUldqW1TLkQ+TlFx3CWLoPRAFzxUdoCDi2h2u5Ggj/Ur4gm91ZYSgCO6dr3e4FyNVBJRxl4hxsVC5L1aoa0OW7TP+4ZvPeUD/UGebgSe3B7/UBsXAxrUid98E4Uabc1+WZ0VAEEgTRYY1PW81phLK5yV1fjOuHhz0dsDiT4uS2OwYtacG5OAPnotcUpN73trTgE2nw4DVutlME9s4/OakHS8EDNDjCLhTZA9Ng0kYxrAHucjCqUrIMZtl0whbKYgYvAPcNsmgxX49jtv6CFf8wwhFHrfFN77z9Y3h2ciAGxZMwK8MyhtzVw6lEB4TqEVlmNDIMcZozBv1AaB+Ja2EgkWWkY1ch3wr1LaLMgLgvAxBjXe/U8eIyJWp5PQP/Sz+PdxwqvpIVLSbZ/6SmbOTryXcET2vpFKl2wFyy3T61HvEQaamJGZHyYc/XmOXJI4ELuox1BZ4nDNr8ZsZRbOo01jmdJkZBT9u4EOHyFQagDlV4bkTaqnUGGtEX5k6yIf6AZMEx6oF17fERtGJnAyS519i30k6JK2yvJz9mh2bwFl2LJVU5Yrg970JHUwMKeDPjLSapYdBZbi56w9zZdfOrNVcU3RBcmXp9oQFYekwR63sC0ivhp9oPt2Opw6LrpDAcNC3m5fHKhx/wEm8GZ3DJb2QrP33hIMUXxQPzV
 oWjv2byU
 tiKX6yswTiV7UJFfxBSxjX4SPB7PgAGDEg1TT3seHzrbJ6+qOe3d7Z2vgerVdlAVp2FVZR2D8rAeaWAStbLoanNeCb0eq5L6ztDq/Zc1jpiNwjRAFk3stNlUUvc4r/Y16cD1rQgGmWSxCVi8slp1MBnB7VM9GuehB0QH567/dyabRnnJ1j+83RtrTkBpm7ZcLFZlm6DtAu2Wjp4vMhf1an25sC39kKblWFfNq8TQtyfiGQRInxdqSd7S9x83+zsBPxYFE53O3Yik7ZPejNfM7nDTX0hy8S0hrbfFpdgWwYrpbcre4Vk1sRoC+ioJ0TNcQXL2WL4LN+UJEXb4IEMC9vTIw6DpwfghDLhk9CmVqC633FrWpB9qe8zXlrMvJxW9YoobDfUhHcStinuEmuzv6dliWXnnmgAG0YJcZZqLJ0ChsaMpVKXOq13QShXQruEOsFVOmgAKWxscGCECRh9ff72alJBwR6bWVJ57E5nXDmW0KiqFqXatc58NI2uebtxJPZed2BFY7AaJycmQZEaHWB2t+FOxIo91WP94EXl3g15EWsXWFpYg6/6D/k5Y6d1ZV0LDYJvT6d9/r37Y69kQtPTvitHierg0qovjCdpVteiYDQBEV//hvQgl3L56l4+NvY/wnUIT7kh/zkGMf/kvOjuomB7YKDDkOF/Q3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd is planning to store huge pages in the filemap, and
guest_memfd's use of huge pages involves splitting of huge pages into
individual pages. Splitting of huge pages also involves splitting of
the filemap entries for the pages being split.

To summarize the context of how these patches will be used,

+ guest_memfd stores huge pages (up to 1G pages) in the filemap.
+ During folio splitting, guest_memfd needs split the folios, and
  approaches that by first splitting the filemap (XArray) entries that
  the folio occupies, and then splitting the struct folios themselves.
+ Splitting from a 1G to 4K folio requires splitting an entry in a
  shift-18 XArray node to a shift-0 node in the xarray, which goes
  beyond 2 levels of XArray nodes, and is currently not supported.

This work-in-progress series at [1] shows the context of how these
patches for XArray entry splitting will be used.

[1] https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversions-hugetlb-restructuring

This patch series extends xas_split_alloc() to allocate enough nodes
for splitting an XArray node beyond 2 levels, and extends xas_split()
to use the allocated nodes in a split beyond 2 levels.

Merging of XArray entries can be performed with xa_store_order() at
the original order, and hence no change to the XArray library is
required.

xas_destroy() cleans up any allocated and unused nodes in struct
xa_state, and so no further changes are necessary there.

Please let me know

+ If this extension is welcome
+ Your thoughts on the approach: is it too many nodes to allocate at
  once? Would a recursive implementation be preferred?
+ If there are any bugs, particularly around how xas_split() interacts
  with LRU


Thank you!


Ackerley Tng (4):
  XArray: Initialize nodes while splitting instead of while allocating
  XArray: Update xas_split_alloc() to allocate enough nodes to split
    large entries
  XArray: Support splitting for arbitrarily large entries
  XArray: test: Increase split order test range in check_split()

 lib/test_xarray.c |   6 +-
 lib/xarray.c      | 210 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 162 insertions(+), 54 deletions(-)

--
2.52.0.rc1.455.g30608eb744-goog

