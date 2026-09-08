Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70DE9C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D736B0092; Tue,  8 Sep 2026 02:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEBE6B009B; Tue,  8 Sep 2026 02:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BFA66B00BE; Tue,  8 Sep 2026 02:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 178D56B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:49:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A90EDA0052
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:49:04 +0000 (UTC)
X-FDA: 85189667808.11.D5CF6B3
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id ED7FD140002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:49:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jgy6JOUx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788850142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ieHVtiuPPdzHJk3HRFuoVkUtejOuBjTV0evlYx/E0iY=;
	b=jCofDe5Dn59PBS+X13wi1C2uoWhg5Lh7adSI7JBKUSwYS2HbAO3RyWIRAkaykHRV5zvMvh
	oLZxh4CVbfAZ/Ibjf1quHq/eIQogR0UdnpUpYap0N2lfkaxy30HXQVgoIwvJgvBAa4edr7
	ivFvcrX8CLkrfP8aMiHZGv8ldvxG80k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jgy6JOUx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788850142;
	b=D5aVA3auRapJX9RKXC1VGUdZSNn/MC5H1Y6XwQpSWOLh1Xk16XGEOcoycjlPSi3c0nNKQe
	imBPf5ifLj61BP2wk3Lu4ZIJdMuDnXzTpg3OWfY/sv3QRwPi8nM4Bd3JQlM715Yr+p68YF
	4rrebBzGMKPXTzu1Xx4EZS3UJOwlZqs=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cbb8b54fcf8so4434461a12.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 23:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788850142; x=1789454942; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ieHVtiuPPdzHJk3HRFuoVkUtejOuBjTV0evlYx/E0iY=;
        b=Jgy6JOUxs4YTA4ckP03nnQVhNtKQkuJFlemmEfTK8CpY2DSxfRmfXE220TclgWWZC5
         oijDMtQ8Wt7kp0KhiI5gQedjcmNe+PiRxrEdBUzyQVqnC3fIg8OEswxhTbEJW27pJGQD
         y0ExT6Rb/krhFEfzNv+PMNImNrl1X66SXlOg1uDb6x7iNhINO5k5jzxKpzlqzWC1EXgz
         OtaixP+uK2jt5z869cH/b1t6exhzTpHIJloIZypznY4d4SUhI/B5DKD3adNzN3oGm3ms
         y3JRL/6rz8Gh05ncB75uYwRE9UBsfIJqHgtCODq70WqdpWa9lR2bwg1g/tBurGMvzQVc
         Hkwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788850142; x=1789454942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ieHVtiuPPdzHJk3HRFuoVkUtejOuBjTV0evlYx/E0iY=;
        b=qM6paLsyYY03x6jO8ccCrGfpdEmcgEekvurOyLb/dMcUfnGOUEYagsVS0DXYN24gSs
         YKTNrM+uhpPDhizNkmCTqiJYhvBX6vp1DE3XELLpVXQVnPYQpqAN9H4rd989pm4UU/Cl
         rCGRcnhGqhTqF8gqtGJewJsEVwWaVKWViVLw/Yn+xnstxjwFWhLoud8yqAkS+SJkzf/O
         O4qBZX3xsbKOMnYGu8B04o/KAgIRwaqzLxpGCS3MSB4v4wg8cZ50CtzoKJw8KRSHYHS+
         +um4hEdxUSb49sslZJng9uTiiFZc45PU3x0FCSdLZ2vimlxxi1bUlyT4/N4JQw80AbCm
         7rlw==
X-Forwarded-Encrypted: i=1; AKwUvBwCjPTyeuGURgK7y4DXyJlA+sRz8C0wQ4KWI9kG/JjZiEdjC2LFHdrrd7t1wjcFtb9z8G8k+AH35Q==@kvack.org
X-Gm-Message-State: AFuF++n/p9LWTO4uw3L7a95wLNTli0/Hr2xmRWrxZ2fJ3fvYBP1IuYRD
	zeB+8HhP0jZO87sBtL4lObaOGXHyx7783dajfqnDXpSc8asVastH770w
X-Gm-Gg: AYBFou2FhoOgF1XO3xVfUbxGs4bDF1hrK5XBEzwJGEYM6e867xMZyMGSf3rG9yzosbc
	yYpdmoQIwceyajNrjf9itLZii4pEjgu23UaLlHa7JrrTerz/pGncG+b7QI6PLsU24oSWI3P2LRk
	sLYnl6onDF3NpIUQn9tEnA+Z7SkjKG9xpQWVvBpm3gP819pO5yj48b1tuzCR/NEYumNf/6mE+cD
	dqOfrZ35nCcYWKghQq/QNKw4U5Qja3Txjmv9u3IkUC5ITdw1Qu5ykToQEKXYKQIYbsnnBUSUErx
	dp9qhJRwrA/k7DDfhLPhxDOYen8bmHBrUSjqpP8AhfChv15Jv68sHpptxgqmqCuZr2hSbLQRakH
	BpLSRe88aX/G1ub18wTUexl8CfsMhp18nCAcdQ/9OYJMJ41eF7oWDYGTi8Bzuh4rjLrnG7It3mV
	dsaQHx43d3NF3yKwi0SPFKjFhFcqSISY4HV/4sgHYZ1VR1Ter6xGEtrZzAMjEC9nSHgFZAqKs=
X-Received: by 2002:a05:6a21:8887:b0:3da:9f19:bf2 with SMTP id adf61e73a8af0-3da9f1918a1mr7504014637.18.1788850141767;
        Mon, 07 Sep 2026 23:49:01 -0700 (PDT)
Received: from localhost.localdomain ([104.28.254.47])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243bfbe3sm31139468c88.11.2026.09.07.23.48.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 23:49:01 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	lianux.mm@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/tests/core-kunit: improve nr_samples_per_aggr test isolation
Date: Tue,  8 Sep 2026 14:48:23 +0800
Message-ID: <20260908064843.32067-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908063635.2208922-1-kunwu.chan@gmail.com>
References: <20260908063635.2208922-1-kunwu.chan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: b13twyt65mwu7gcgym3su3nmk1yck35c
X-Rspamd-Queue-Id: ED7FD140002
X-HE-Tag: 1788850142-29305
X-HE-Meta: U2FsdGVkX1+GAYOSznXg0RZ/hqOdK9bLJYr7PqayKj5TVHpsgZ4yVfXOyfQpLaeitBKPJ5peZMblxGw037gMnYaiAAe7r2eR/xMBWAhEXIc9Re/uPA4xUs1XdgtF2gMyjCLo/XTzwN/wj/HwZcIZkA33LYTVTpGl5vsL8lwp9HZe3QGiNqf3wSp0hpt1yWV60gjVx1froSdqg73vWwGI/icATDfzHbtk7O8WwzOZDGwJ2LPKNYOt+hZAHy5oFTdeYJTZJGV+H68HW8o2DKADoW66WfeXjmeRz2hgBzRxvDEKBkYlmTfTW6UTkB6JIlwBV8qPQ3IQVEGWpnCsk1v4AHudx7iekPxbcwPW/PmJe2B2nYZ1vLGqbVnfC6XDRBZQ3ZoDhxvMtjpyf03hDubAuylhwc/KXbWCDLgjIU0Zb1S4dwyQr7NVyi3wtEa7ks24g1eYqKo3qfMd2jeE+MdUaIjHnydlRZiuPHMaFTn12CiMWZrv6swDEPWzRbC6l3JH2t7CYxqP777QnL6WFmf/r7Aj5akrr4ap8Vcdvh7OmX1WgEXp5DRJkQ1zJkGxL2PlHWZwW1adgIT8Sh/mrDMISApJAcaMawSFfaCEtHyVbFMejaVtlDfZOEyF0fRhlW/yCvbBv76QE3Y2fObI/KXaZdRKUjfe2ocwOaF9ixMOEOe8/NyfAgGP3uZZUfl/TNfTiUTPOhrUwkmZK8Glm7i+Wjdeif1v9BiSR7hXKmZezMP+/KHh9UvCx5cPNiNp9wfPYOJXBC9woo4uMgg474bIcxrOPx5EyYdfrEzAk1ZBiF/GxHA1UEDzFRZ9JlqFleGTJjp4G3aL5zVPZ7rHvRWx0K6ECStEoo/ksz13QCRyJhgxQsBhKrLKyp3PMoPmToxT4lyIffpukxk08gD+L69g7pN8lJTcM1o1DOqcBknOlSLj6OApN+Jtbql3ERLrrPRdkxu0OD2VZPbIRCQzm6q
 ztBQTTUp
 Zg3TLJOiVn3vN49JlSN+SXjLeMw3CuSqqx3cbDIt8H3OE+Px97npQbqqWoi+Nyi0j1BTku90fhvfDvvu4uk/2Vyx2cvWCZoz3Txhne16IJNMGKjwXq75tUxGLpB0S4LLKYbsMBTXwzEeGf42kv90Bk5eMPu1xoCkzGZF+5/2uxqezWlAxZPP4EAnajIojtPVCR1vHXfjgZ7FyDs4cSwYtjBXe56L+x3dmML8aJwG4FjXDwE+chwMFIBPRd+tEgsR4LtKHO6HlGTOwPKGt3sRtz6xlik1PJSoedde8/8HQUhfqNbhg1jpkxmc5PWefLFIYTH03AYy43mRUnqeeW8+qDxq6q9VosroBgvstkbox+DNuZi3jQfQEb8qqsVOjVkbgeup52BL6SL9s2piI7DziXoR/y/VrYv1yGVH1ATH3jTSenc2RzeFMlRMMh6OUXM6TPZNRV1UeWbuooZauAE2EBnEXEEsLZb8wp+8IlCn5Ktu+6y4IHjpPuTkTmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  8 Sep 2026 14:36:35 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:

> The damon_nr_samples_per_aggr() test sets both intervals to zero,
> which exercises two different fallback paths at once.
>
> Use separate compound initializers for each case so that each case
> tests one fallback path independently. Also make the overflow case
> use an explicit non-zero sample interval so that it does not depend
> on the zero sample interval fallback.

Hi Kunwu,

The separate initializers now exercise the zero sample-interval fallback,
the zero samples-per-aggregation fallback, and the 64-bit UINT_MAX saturation
path independently.  Using a sample interval of one for the last case also
keeps it independent from the zero sample-interval fallback.

Looks good to me.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

Thanks,
Lian


