Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B6AFCCD184
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 01:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6CE8E0136; Tue, 14 Oct 2025 21:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93FC08E0005; Tue, 14 Oct 2025 21:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807058E0136; Tue, 14 Oct 2025 21:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A37A8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:07:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 149D611B291
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:07:08 +0000 (UTC)
X-FDA: 83998559736.09.7BEC99B
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2A7A540008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:07:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jYDkDNKo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760490426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5js9XrKJ8gf/jFCMXPOPzkESKIK+jrvyttaIfXdX08=;
	b=RcpNAEownIM0dnI+0gZ3TLWDS5NaUwTXs7vivpS6uua1NV52oFmst9kNYmrfLbQBNcz60u
	9971Mr4jKCGHwLC7CBFUMyWNoC67tC35T60MnokHHQrprbyFrSiHG5DwnoSLloRrCCMyoD
	OUh0RVauf45ycwM+GeANK06CXWgZvT8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jYDkDNKo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760490426; a=rsa-sha256;
	cv=none;
	b=MpB2PmEvW3CRZ06T7mq+2aSqyOkqM55wqLGH/w39fLbHTF+fuw9A2bHXgUdizROT4YQ860
	SE914fMmO5zIC1pI3GNeItY9PJ93FPL48nvWSHJ4DDvlTLNOEckWt7Gg4K6LibreoxfK6B
	gjUNmILPNTcflvu6FmtDc3dTVYZlghs=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3383ac4d130so5121934a91.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 18:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760490425; x=1761095225; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h5js9XrKJ8gf/jFCMXPOPzkESKIK+jrvyttaIfXdX08=;
        b=jYDkDNKoIz80bhY/9mvnxTNKA8ERFw+tji050udelUtXqhf7tWWEgwYrQkZdGWmCK4
         rG0OQHSFB3E13UiGqr/JbiO61obK6PWLVAw83oqc0pkOYyJWQJN510hjEcDuQ0/b34ei
         7C10PgSU4cxRYbnkPy1GtwAelcskiWDLD3svQsGYz0QhRK8ksEQvF5LFzYmpYOyBGNGx
         NBU21vCXTz1WAEBBbmEYnYen4sNhtV+J6hshNw0+5P2KWjorgUdvl+BuBcgZcuB0FWAp
         jPyd4MG6UZEDPAq/LJ3PL51ChA6DL9Mltq4H/sDfByQ9bmc6ddXGLPseYY4VDUbrVxU8
         I4NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760490425; x=1761095225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h5js9XrKJ8gf/jFCMXPOPzkESKIK+jrvyttaIfXdX08=;
        b=Ynlrkn/o9MVfpR67uLrdxJpH9T8927bgf5yaRlnTMh8c6+3S4NcYF3lpqtTjHW1imh
         ryXrIYqsoitRoUCi6fxc2rbEkBQSEbifE/fIB4nfqeiXekHbwtVwLpbGYL6OkckjKRhx
         4XNUATozm+H3muXojY+nwpK4IWkw+l3JvvdA24Faghl1HeRFFIPSrqFvMzPPFXNP/ezw
         MqGO7v2mCVBDKMHj34/mE+aU7uR2u1rFXnDr2ZOB88gRP3WfC5mmlHLx/EiXc0Bh/bsp
         qe7K9k6QaNxtFns1S0aPpC6aIiXbDobRGoSYFGwp2WylcGHNDvQfWnvuUDOmTA8kUTJR
         JGJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXuLmr77A0zWyQVYeYHhzZY2P9l4VO+XwKvUnpDXuaKIP6UkR33nmzQ74ZLpEZVYMK/pGitLxuMg==@kvack.org
X-Gm-Message-State: AOJu0YzF/DzH4q2BRCehukUp/e8/5HJoKgPWgwmGMkkUPyATVFnwQ1Ha
	qd2QnnCyjDn/810r3CEDPnIh9FvUtgl3eExB2PmZae1I9YZIowCQHCIg
X-Gm-Gg: ASbGncsztoHXRXd4i5meEMrZLfZ3709L9EyvMiNtwKP/k1iyU16V6pB9llDYgy3YlHM
	xPk9mr0Q2XaQCUGQta9oWywyyWyUy4dEO4n25HyUZwhsrLWPjKHjhnSUOMuZhpyS1d3BnrZvcqy
	Tz+wl7XyO8VgDTULvoFs1U/7ba2M588paksnM08W2sSHecDA8w8CJKQfiw2z+6hXLMvuxL1s0Cd
	j7R/q1iU4lTttscHYksH07M4wh7u7+NGUXqDuXoC6Ob0adePaW1isnQxNl+KcBaoP06lRxezL+p
	i9dmJ2V+fhY8QS+tVJzn+GSGihN28Ky5/Qzkvv8nbPXf3skoBN6Q6d8evZpYb7jWqjcZhQcHx+4
	PkWpRelX0S1gjabCBCVZATyFi6FLpOc880MpnDbjD4cEHiauyHJ1agMEXmdKZfX80BemUBBuKKe
	gJ2bSgFFHmvvx7kVM=
X-Google-Smtp-Source: AGHT+IGlDIwdrvJdMOHOQpE2iK6rkjqM9WfbmJ7ohrr/kc9vjbkArOh18KbVwi2FDCS86MoCq3oBfQ==
X-Received: by 2002:a17:90b:1809:b0:335:2934:e217 with SMTP id 98e67ed59e1d1-33b511150f4mr36065857a91.10.1760490424525;
        Tue, 14 Oct 2025 18:07:04 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:1896:1396:cce6:9f32:ae57:f39c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b978537a5sm226622a91.3.2025.10.14.18.07.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Oct 2025 18:07:04 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: richard.weiyang@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@redhat.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH 1/5] mm/huge_memory: cache folio attribute in __split_unmapped_folio()
Date: Wed, 15 Oct 2025 09:06:28 +0800
Message-ID: <20251015010628.10217-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251014134606.22543-2-richard.weiyang@gmail.com>
References: <20251014134606.22543-2-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A7A540008
X-Rspamd-Server: rspam03
X-Stat-Signature: 5zbsmu1ng6nj3x51pbnedrwstbak16gx
X-HE-Tag: 1760490425-365024
X-HE-Meta: U2FsdGVkX18t3lzqToldqlrD9lovfUNijUKt2AU2c8WJVvjE2bwi+UU5CJJ2Hj6ZDjpmlosMz8ELyL+idaQD6tJOBoFoZwYicFi6vIEtQGL3wteiS998TN/ehUyfgdlt/jnEpyinA7R+qtSKumf8M0vvm7cp+aPOmKDG2WbRg4zo1m8xnbhICvGNgYU4BXczKYu7LDvWkqyMzvxm4rDeCy3UyfM5arIeDZncmKtmc3JkQQqDXLvoNoBkm2Yq9t8fyoHszgILpXF5mZr6ynPmRMb9HQ9Bhwtv1ekN5BwHsUOIrgEtN/+krm3l5DMaGuOkmAfCffP/0ScfISXtpKRnl0SU5/L2KHPqWAM6HcQbDcv0bksmMrwYI3GsoAWbG3EeHCTynBRRMLRNgLMsirfdtGDsXOlYvxlTdAjzeASCZ1Io5DoS2DaUNBgvsJerML9Iz+3kvNl5/JtjguwmguU86WxGhce+hAtafH5+XdmeIqAjgx7ED1QOOAQnI7LkN7qmv2uzXTyq+DJBpLOq+e+DfbxqPD+OHyXedQoaKIqeMDmKnrKZZiAPLnFKIVzb5pVsNadgzsICciG9wiA9Rcagax707lJUChFIasmgl+VQ13ZjSZ89ln8QB7UxRAWprE6XCsZ07oXDIxAtk5xRHpENN1FYycMf1PboudY481TdnH7pS0mhGjjwvwpEg9iprDPI2kskt0LkfJ7W/Gys8Q3JgZrUpxYHnz3q3uosBDi0dc265xBxTaciIbxfqir70kBi3ZkiuG+/tIlBkTckeOD7oL/PnEK5HbsjEFKfahGeYHzaFzFYwXAY5578oW+B5amroe1QT8STlXCBKTfN2FM2R8Mxf9zS6MlSaerSzYTAaffzSw2rGm3p/4TwLHOD36Ycx1cBvPhe6nwJLc4vjcWjXWnUQQd90HFYj/yRQWFqzTHc5FTUHh+5ngWx0MKfMVWn3ligoD8f+XozErii6nb
 flszSgvz
 aiL3bllTNrhlSqH3mF3uplsoM0wyJN1KaGNI38q0idW+kPuTq0a8efJxXwAXbJTWLpYhVWzrlCTIgTPbhZzhUx6Kg2tnorYcIgQ5k7Tf4z7vhxVzMELCiocLfo5GGSBW66SNlDjbbtCvIhOwNT8WMPXDtVcgLeOcnk8ht9814g38tAvhQBW2y7QgJQJUxu9/KLGNjFPGHGAdads2wGBQIxOHQC+6jeSt29xYC0tkX+d2xHgmGw04AXO3vx8bDtI/hhLfoTLEzMnJ+UI6qx74ke1WzoYVVFc8iDQhOFL7z1eJoX4QtjxqyRqbF2VkwiNfK881LmUVhwn6fgU6Kv5dnQTabMWqiWbU+0SWKEtwLzoHKMNaYht1OfYWlCStJcxG77XoHSElJ1iFE/yLw0Hajzk73knv/STM6ssdesS/6sVrSMa7jyRp5JdFaphF7SPbygl3S/DOsckOvGjZ54rwqQzi1s/IcrkCL4GialGfh11Y59cRXSIJCKUVemxUjoLo2IeDWuj4HaCwD+fulgrMEN2BWYUYeOF/xPXyLlSpbswshcfmKlXFNlgxz7H+WJGlVgvCeOJKACUt0Rb7tW1QppHH5/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> During the execution of __split_unmapped_folio(), the folio's anon/!anon
> attribute is invariant (not expected to change).
>
> Therefore, it is safe and more efficient to retrieve this attribute once
> at the start and reuse it throughout the function.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> ---
>  mm/huge_memory.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
Reviewed-by: wang lian <lianux.mm@gmail.com>


--
Best Regards,
wang lian

