Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC95F3D339
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 17:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BF896B0088; Thu,  5 Mar 2026 12:13:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1430B6B0096; Thu,  5 Mar 2026 12:13:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037CD6B0099; Thu,  5 Mar 2026 12:13:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E82166B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:13:06 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 912681C179
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:13:06 +0000 (UTC)
X-FDA: 84512654772.14.85CFD02
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id C3E3540011
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:13:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=laLU1s9U;
	spf=pass (imf07.hostedemail.com: domain of 3n7mpaQYKCA46so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3n7mpaQYKCA46so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772730784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tnolfb6uQBsYaAshkkXBLdzTSf21J1HsPObGa5E2rzU=;
	b=eTGPfS2GisA47YyThsOM8M3RmsBhqusG0SOUhSzfSb37yzokmNOcXkEewsHTCJ7yI3jD3C
	ccZv5gGW34DQJViu3yRA0gi/9rUbiK9o78KI4iXrhKl9KU9mZYdi7zhLC+OXvmEeQ3r0ry
	nDuiGCvLg5O/BsD+I0xQowATChqCLWI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=laLU1s9U;
	spf=pass (imf07.hostedemail.com: domain of 3n7mpaQYKCA46so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3n7mpaQYKCA46so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772730784; a=rsa-sha256;
	cv=none;
	b=2UkN7nCg2pxwxJB1DxP6AzwdhgERIYamOj6tOI4zCkWSdbmSJ1nUet+XDVxGoxv58CcQoX
	DNlLuVwzbnNsYZWjelF3ceNaocc7Iq2eRvkllzggqQizX9AhXfwspUUsXLjU4qTproHC12
	kDs1TggfKS5fkEsHC16ccMLIpwOrkyU=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c738f71723aso561223a12.2
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 09:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730784; x=1773335584; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tnolfb6uQBsYaAshkkXBLdzTSf21J1HsPObGa5E2rzU=;
        b=laLU1s9Uc9hZjn66/CmWYNzlz3ldZPfNUoJdU2tRqd0KJWm7CGJrF5hj+jswembenL
         1kOGVbcebL0yv0k89H8v+cKlFoMAWsySLNG8ZAi6GBdXd2ZnDvc/uLXrAbGZURXHds5W
         4KoY7looxUCKVcAuIC6iMn2v3ShLVQQcI9a6gIkD52juAU2yyBWJP0jKGY2eQx8Mfw66
         piCO9zSunhEAMsqBeRRLQnRO6yr71x229D98vkOw51XX+SBDaWG6AC6COGGLh+h0xsU2
         WjYztTD8nZo6e4AFihS/8yZPz3ApsZrp8v0xfeZ7tZ6ujSZa819T3UjnwABsqqPapHSd
         owLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730784; x=1773335584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tnolfb6uQBsYaAshkkXBLdzTSf21J1HsPObGa5E2rzU=;
        b=WIIc/l5xNuouxfPKxLheGMKqniGnVAwpOgzfkMaQcNPdbmkDYPw7yxNNXbG6LDg4A7
         niLzv2jfndwrta52Yn+w2Sz/wE+GXO/1JJMBrOnFeP6WO1TaK4Bt5Ko/gbttkOB8j54N
         zDzMpBD/thBxlcI7kuzYnE0VO9MPmu6SAORWLtq0xbYaHIdoCGrjNqr8XVhCI7GiR5ro
         Hl3FWECWfHKm+ZVVTF/QjaLyoip0uP/pWvB4PHvCW1e0jVYHxl6Kloj6zwbY33ubhRdn
         Ef0ORaGuObOEyiHX0Er57TnPrs8Gm7i9TAQtzdlcJj4lGQEpKBN3qs1R70iOdj3ca+AJ
         lTFA==
X-Forwarded-Encrypted: i=1; AJvYcCWA7Z0ddIIaU2Rjnw30gYej5e9MbRFReugNNktBwoyVc7KpQp+cgj67rUBot8t2xLIBibN6Rbd+jw==@kvack.org
X-Gm-Message-State: AOJu0YziFPU5kPJok4pvuom9gBMklJFlw9Emk4lEPd9QrFGLk5+y4ZNH
	5a5LhO+aO2miuI5wtgbIEfiGpLHUYkm/HUKzKeL9ABV3X1dI8z9C/wT/4G9KjV3ETks02pcLYuh
	5xJuHVQ==
X-Received: from pgix2.prod.google.com ([2002:a63:db42:0:b0:c6d:cc16:8cee])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6e8a:b0:38d:f2a1:a43f
 with SMTP id adf61e73a8af0-39854a814d6mr239546637.42.1772730783352; Thu, 05
 Mar 2026 09:13:03 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:27 -0800
In-Reply-To: <cover.1771630983.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771630983.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272511649.1531226.15957182226632150956.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] Test MADV_COLLAPSE on guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kartikey406@gmail.com, pbonzini@redhat.com, 
	shuah@kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Cc: vannapurve@google.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org, 
	dev.jain@arm.com, i@maskray.me, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, shy828301@gmail.com, 
	stable@vger.kernel.org, syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, 
	ziy@nvidia.com
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: C3E3540011
X-Stat-Signature: 53zfrgjtix7x9ixsto4mscb8fcxeudgf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772730784-15648
X-HE-Meta: U2FsdGVkX1/onZDefyieucK6AUUJsl1/eHp3kNPlmST4+8t60T5Y3hhHyCviPDOaDy34/Yxxsq4mUDauyOHcEBPyOAFA4UvPtPwMdgYHhvTk4BuM7lGRD9YzLslE80QGND24ZzBlqG+VGFsfcR65Q8/DTz/1yU0Ae7ghe3Usx63eitPFTdV94Jj5F1ya+PYsJwLvh3JpqJLdmkCSU2IB73yb7yxiZaF97zw2M/hd/kznncnpy6l+ycn+vd3BT3GXqRjlKbu/m/5z8jb14fDTR9dzfD+xDrZbn1+eV1Bk17XEKMpLjDhbwrl4ErSvCocleTMf5/CRt7OFs9Sbnc4Po7dJ6H1kEPyTttg6IZzJgidzQCJ5BnZnd426Bvza+bMzuTPAIMS5FDVpa3mVr4hFkOnyoULCnkcoS/GdTRq9iLuFaf0lE21iknNFo+pUE0JhtJCQhAQDteEBPjj8JStSJvWuwegGHPPKow4a+Y9DKgXTutoL2980RH3ZGnqxz80yN0ZNNmpWsujxfm3g3K0IxRlyWA6djjS7R/q6YbYUNQ52oTny8+T/UjmOxuO+ii5KpzJw2jEPnPCtN1t6OkXXdIL8XSJWISG3ta6ds1vf1ZvcIGfyujNCD1zciIfVGaMPpaGhIqQY0O21L9/HSfMdINdjSdjWa2tS9U25BJ9Yd5itJM/olg+meKuullumeGmjcznk4MYvy0C0Jz073Pnb0cQmE/nSVGkTxkU5ZMn3krIMZ2La2rQZuUzWun+v+Uq+HtqvqZZT3sXv0exNEICL3qmDa4ilGjYfvaZ9KhoTPCQ7kT0bT6fvxavgNjUEXqtUVo0pcyzyQo1YeZmUHGkYd7ygw6GCtDbMwsBF71BOPMUYM6yaBD+dNpJGZFbAZTXWkgJB4WIYAqZutSxUJ2wvKkALeROG0r2daVuewJhA5fZktD3rgED8pKkDKPXcqaW0/xmlzSR0y4gIgAJ9nsB
 iR+JJKEp
 xFYgwXPK+xqPPKYQgzBYugIuMXc63o93ggGOClrecWrCzZ1MWAmTnl9R8W315yIWmRlJ0zWVvW47pHqj4zSeOApmL0W0O+VnIC0qItzMM+r9FrvkEBHrjErtCFO9ylivFbXx2ldEdJUFObj3g+YbMtHeB0arMKG0AikUDxYqbdILtBESnv7UqsHtRFfKGdSJYP1qktCBBBA5vPYSe8BVQIjh1hRh94BwKMjAyvdKbSZ0nTK+ZnhJNxkm9RrePFbvLR7O8BMF9/OpTrAwMROCmEFE3jNWIjoCzJFI2HGP0Wsp3rm/0btft5LwDnGVr03fKnDslebaZ79aTw8GZEm82pNbuOyLYfzkU1FKwq5lmnaECOuhwEfaTB/XoMtLSJiDjhPa4KCza9lKScZ1fO3w/NM4LhxLQ5Ln52BR+IZa0dMU2G4O+N9cznYo6No3tG1+Z3N6H4wNGlFQ15IcS0LrabLwTbQIlbubE1NjL9vmQkDUydVWdJUYGEHQGK1sg82JxnQhV7X/XuDjNXCbI2wIh4lj2JsoAkQ0w1DnYVQFu3zZjVjVlbE8RiceCZlwnsbT9x5SHxYX2L4XyNAaMIhwty9u0xWxWoLNU+Mge7ntVoKdT/DB3nYwilZKuhaS5pS/mLyQaV/CZ44YCok/mXEaFmjxZGiRd0ZXyJh9k7zFuMSS3o5hWRC+bMOBmF83DZQzeeswzFyGE0/Cb+4Paze+qUaswTrhYGaHDxYlhJkGL2S2fWG9II0TA2RRAZcbXgObecZGcp1uOLrcE5Suo9w7iC59bWn55Pu1O7G/g6svWW4ffNy+2+ZUSY3t3FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Feb 2026 23:54:34 +0000, Ackerley Tng wrote:
> syzkaller identified that khugepaged, operating on guest_memfd memory,
> could cause guest_memfd folios to get collapsed, leading to a WARNing
> during fault [1].
> 
> Add selftest to guard against similar regressions.
> 
> Changes in v2:
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/2] KVM: selftests: Wrap madvise() to assert success
      https://github.com/kvm-x86/linux/commit/58f5d8eebd5c
[2/2] KVM: selftests: Test MADV_COLLAPSE on guest_memfd
      https://github.com/kvm-x86/linux/commit/9830209b4ae8

--
https://github.com/kvm-x86/linux/tree/next

