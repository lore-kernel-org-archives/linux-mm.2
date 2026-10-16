Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA119CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 10:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3D096B0088; Fri, 16 Oct 2026 06:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDAF6B008A; Fri, 16 Oct 2026 06:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDCA16B008C; Fri, 16 Oct 2026 06:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F8966B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:34:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3239D1A0380
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:34:58 +0000 (UTC)
X-FDA: 85328131476.06.5026AC9
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf24.hostedemail.com (Postfix) with ESMTP id 703FF180007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:34:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fbmIGd6W;
	spf=pass (imf24.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792146896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1UJk2cXtDpU5Tf17byKlHtWDaHy883nGoAa8Twsmlx4=;
	b=WTQJFNHX8ObsEofOMjRMs/0xGgZv04gDa4Hy8Yp/TKqVx1of9LluegPLIc7Upu3Xi6dscD
	/C2HNlqlT4t0GRoHh28B0qnY2N4QLcdHQuTt2KzS2iUJHNfmHxIfK7pJsV7KmMy2tK/mlQ
	PrDKt7oT8ifKNaKn78yP1sBSCt9F/Cg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fbmIGd6W;
	spf=pass (imf24.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792146896;
	b=OTN845h0XHngDoAyb5txlbOe1FicmhWN16IGxvWBIlYPRqyINZraE1LIL0efLzVOaRDJXj
	N21eKBoZVzqN4LQhzc++Dd+ufTxLad5GnS06TfLYh265AwbstmI4auvva7zbpxmSxA63qZ
	yMOJrHnPAWMjAHqXyBdGp+1b+K3vbCY=
Received: by mail-pj2-f10.google.com with SMTP id d9443c01a7336-2e934c6c20aso15620665ad.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792146895; x=1792751695; darn=kvack.org;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1UJk2cXtDpU5Tf17byKlHtWDaHy883nGoAa8Twsmlx4=;
        b=fbmIGd6WovXLHRdLglTZuvLug1Y3z9WYmxCuyp9MyEShbAqZZjsgnT8u815/wzNAk5
         slBAQ2ugmmYvfJZu+cUEvG6zmyVgMg3+m0aQlJA2aCjnoVsdE3tWrZBI+hA1hB8h6gmx
         C19mckP5xqd/7AkvHXOFQttcor3GtcchlZ7WrQ233zPR6kPNdXUvCpGva6AP/tM5w7Tg
         WubXd0OFrSNWxGy/MGjbHtbWpTC5uC+2DIIdjefXR1NQJ7y6IqrCP6lxKhNQ4t4jL4lI
         YfylmWumym8kvGr5pJlxK4Ekl0tfksvwKf9KF3wMh+Xb2GBSeKGYuyHJk0Oui81Obn4X
         +I9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792146895; x=1792751695;
        h=message-id:date:content-transfer-encoding:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1UJk2cXtDpU5Tf17byKlHtWDaHy883nGoAa8Twsmlx4=;
        b=gjS+X1kiom3H61+HLY6U7RgN2+MVzviqBRWbNdD/K/uPcgMdZxpKNtm+0i/qE1VgQS
         lo7AY+3YTYfiBejew5gU0YPu4fTIt0FkE9Qc9SkrSe81jHkit8YXJNkUL4O40Uq+Opoz
         OhS2O2pH8CbyBrluhYIUs4+GiFrWS27CIhKFXRIC2Gc3ze1tAXjrjE7eamT5pqrQKqf+
         KARTVh9nPJ0mGTfrwhjSlW7BQ+0kpdQLANvMphwDHI7p4BFulRFNrv83DmY8co/XWuoj
         dqXY/uIG7/IYYlwu49H2wyz2O5o9C/C+tiNKyuRY132M1HdttbVQuoa0mnXGVjafUuXE
         epQA==
X-Forwarded-Encrypted: i=1; AKwUvByUFUILjCKuIkrFOa7Qv92s1rboW9NsErAIv8RgOL7EdLtje33b3lDt9UNhnSatatEi+lSoNxwCgA==@kvack.org
X-Gm-Message-State: AFq9FYL9i135kc+I99r1h07oOjhnMk/4OP9bvYUOLbdBZUzwl8I8pw86
	FUCweyea+cUtcVOubDTfG1lHOxHigmM6/Nume/89rFdV3erK8UYUzSp+GVE6s+lY+pfGEK0g
X-Gm-Gg: AYBFou3p8FCoLV8i+cU3xHXWcJTpB1t47zHDHdAmL8b//eULaw84RY/DODjqDz/S+o9
	ajUcTOo8gYOEvN6jYB7cwaA9KA2cU4OiXLcMB1MCEPkq5hKXvAwV9+UiSltz3Xb7OWujJRNCCRP
	F9rjWOgUVx/MF8LCloInP4ZR1J/7NoDq2ynB9VhEIYTP0mfyxsL7ivc3VQaiHni6M/UXt/Q5Tf4
	41H5336WSJzXsqTP4/OJbhPip+9Mk4g+0mY/3LZDADYrp03/oMpHUYiSU2EXqtdchsuj1DU+G00
	2ME8D5QvKkyyKd3muauSZNJHkrAmHIvDpPateR3ypO3kFKx6cFUPwrE2mgdRbo/U73j5pbRvduK
	N9xquKjozCNfmrNcD12UQC2GIAX9GtBSWn/G/YGGraf5ktHYgKgqCL9jUXem+pKDi42e8GLg/IY
	5xY1V8MtDgiwyoANkQrDCYAYk1YJqTH1gVJIMOGc7X6uKoV8bgutPivM+Pc2sb1KLa72cHfAIO5
	zGlUmo9aNPTEdHKMiEYO5cJ3EndJtNH
X-Received: by 2002:a17:902:f601:b0:2e9:5772:9ab2 with SMTP id d9443c01a7336-2e95772a81fmr57548795ad.41.1792146895099;
        Fri, 16 Oct 2026 03:34:55 -0700 (PDT)
Received: from [172.20.10.4] ([183.137.20.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e87891bsm8239915ad.48.2026.10.16.03.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 03:34:54 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/stat: avoid 32-bit overflow in idle percentiles
In-Reply-To: <20261016002130.113813-1-sj@kernel.org>
References: <179207592479.3.11595453180868898703@gmail.com>
 <20261016002130.113813-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 16 Oct 2026 17:22:58 +0800
Message-ID: <179214257862.2.17756454862637555633@gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 703FF180007
X-Rspam-User: 
X-Stat-Signature: cm7msyg5ff6mk1zyatmgr9mjo1bnfnra
X-HE-Tag: 1792146896-440764
X-HE-Meta: U2FsdGVkX1+42HWxt6S6R4HsHI6sGiYOMhtCjGoLmnFGuBARYaT5FS6OJahUFCx+Vd6V0TViKpNwMkg34khvooZ6lp/jlyxJbwORArkZJG+05RbFQIFFgWxlC5a7JM4X+Vq85xFYYPPbZS2Q4RIKifzG49Y4TDDybS+nkorujwK08uhYIUpWWId0ljQ69pyQ5p2Jv0sWyThx6l8wNm7eCvsti8p/SeKvN1G6HWGFjyOiCtxMAfktJZmnrgUViQ0HL0z1Flvv2XDRX/3yI/Blqbuh1KBSu+Cb3F7vZzX8mAQFjRHHAjZm6vZtxPucGoxueIydE6jT50ZgwCO7rB97YaunR49fZy9c0pNY0bWu+DFzyzUL6PFOr49qWQSyT7ESSZm50YFIBEpQGC0U0GMWXumMmt5BlAPWX8Kwv8sLjOedaFCw1BgNZFF0Iwo4Z2iI5y0yBRDUgmyRBjeDz+ZBTdFhFonW+GZSXd+sdndyyy8CuRmyr/8OfZGUFhN+23RAvXzGEmmKZ2J1QrPYHk8GNyGZIbTcRKBo0KLyypjLJr7Dza9UQt383UHqPpvsYSTSNsrK9kw9cEPV9Tnnwhh2xvF6kNY6rXgu7XGv/dGqo73dRfGAToLLSwvlXl94la9FMrKpn8YfEflyo0JgyrkkZGuBXmiYp1hUADNhqX448Amq4XwZnRBYJn5KCfxcOJjzTisCsKx/329qWA3vAaautXBOPgTVS+4nVf75vOOW4Li+Xz0TDECKTxQ1EhP8rtELAl2go5kyTDbX4clQvjhOGoji6LB26t1deuQ1VSV1DQ7BXQ0GjPMW9iYugCiCqh7z8v34RWisLJDaIqYetEvDF30IRwtznKYImZxehMS4ustmSZxH8yKiSBKTHIJcbpV+DfRgshIYmDs1HTlC4gC9uWq/BbGX25QwmYVLXDyfQqJbCWtrht18sbiP9zQHh8VBOEF+n4wLq3TXFcoR8qP
 viumGIxc
 jCavfj9rBQJ5wvCiO5FhgY+3B6e5zedglwBmL/pp5wyvKLN/JPN+YODK6XaMrdG6XMcqg9poW4zjFPrhHk3PH3Zlr59XzRwlCoHO54zVA9Hq4agEJK9wkNgeDOQrxVrvvF/EEE0Ey2NwCoP/kdTgJniiZENc913D9ZNSqp0sKxXxhmdcgEKQDA4onq03y1nn7RRBU9QeCi/LFbPvdDfbrCnvG49i+BnvfFtyXgNuKyhj9RQaIC0rM5DGVpIUzaMAahdSfqwVpGrNIg50o2cVeg5gSX+Y/QK2XqFqHIZz9ZaeuMyg6NXpsuQSy5z1mKV7bhfDCBVO7a8apJZ2/EX8z30EtXzEtTxkVXasVS3eJsovU7auOsnK0mLeSC9eb2h1M+UgmraP+XfrqvxVXGAJigJJxWEjTe6t0Df14qLOPxztqQKntwwry9iozfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Thu, Oct 15, 2026 at 05:21:29PM -0700, SJ Park wrote:
> This patch is sent as a followup of your previous bug report, right?
> Unless it is very urgent, please make sure the previous discussion is
> completed before making a followup action like sending this patch. As a
> rule of thumb for DAMON, I'd suggest waiting for ~10 hours after the last
> comment on the thread.

The patch was already prepared and additional tests were underway when
your reply to the bug report arrived, so I went ahead and sent it.
I'll leave more time for discussion before sending follow-up patches.

> What is 38?

38 individual VM runs, forming 19 before/after pairs. The 20 same-image
runs formed 10 control pairs.

> Do you have a plan to run more tests to be able to tell that?

I've run longer VM tests, but even same-kernel runs vary substantially,
so the overall patch effect remains unclear. In a fixed-input 32-bit
userspace test with 10 regions over 256 MiB, the median increase was
227 ns/call (+42%). The old code updated 15 entries, versus 101 with the
fix. I haven't separated the extra updates from arithmetic cost.
Maybe we could record region counts and sizes alongside VM timings to
check whether both versions are doing comparable work.

> Any reason to use div64_ul() instead of div_u64()?

total_sz is unsigned long. div_u64() would truncate its divisor on 64-bit
systems if it exceeds U32_MAX. div64_ul() preserves that width and maps
to div_u64() on 32-bit.

Thanks,
Aveline Noir

