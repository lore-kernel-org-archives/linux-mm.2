Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 488DEC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1B06B0088; Thu, 27 Aug 2026 09:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252666B008A; Thu, 27 Aug 2026 09:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143E46B0095; Thu, 27 Aug 2026 09:54:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E96D56B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:54:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78EE28043B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:54:14 +0000 (UTC)
X-FDA: 85147193628.25.1E25A2A
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id B17AA8000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:54:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="IiL/OVyt";
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787838852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2nphZWcnnMoex1B7yQ0ZRrX4XuphVKjyNPO6DvSBBE=;
	b=Jbfdti6r/fmC+hWOoZAiaQF6HQmWmrqy3rMqAfNLDFZX/s//tUrfdlIHOWtqQQOG2cmWjj
	Zf7Xd8u/JPOp9G7EfdXmMpzQ+kM4sDY95aZNqfMN7fxvqO+jxX0ALGGs5P6y0nwwKMVVlm
	MZZBRWrCX3G4IhaOjITg8+ymGS1C+SM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787838852;
	b=3hfRcQeGRZgpYF6WGA7nQHoO67sO4U91MvrY3q5tbWxY48EpXK8xVZ9745KW8pGX8NUF7P
	P4biLhMMtR0IMkhZR8BysaFxhiLg7aCqugSggGdKleyf4aFR8w+58pLoki0wu0DqBhvcUw
	b++8BQgaYQGXKi+CkA/peztrmwOJ2J0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="IiL/OVyt";
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc1cc97b84bso628219a12.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787838851; x=1788443651; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G2nphZWcnnMoex1B7yQ0ZRrX4XuphVKjyNPO6DvSBBE=;
        b=IiL/OVytETuagGGS13Z/d0xlddcLXJCxg6G18WFCy2FTyBpKRNMLF2/Z2Yu16toMRI
         CEnP06D+llt9B6DoVjnAy4I5yWJH+rwIwSXT7+j7NkMmzbt4+YEAIAtELGmljdQmRZxh
         yRpySAZDQYK9nf+uZElf/4KxmndNPw9UX6nbAIifz9rI0LF81xOLu3lIhATAAdn+l7X8
         MJE1Z+DmteC9mie0Q4zWfmKM3wYYymDmxqQ8CyqjSwxVPQElPibfgIu/0i3BRZmmR338
         YsoB956gSvVR5bDNkLJnQgVFcLBJD6cK4LHava4KuDt+qHK/uwBYHedDlX1enjLx10Sm
         cA7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787838851; x=1788443651;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G2nphZWcnnMoex1B7yQ0ZRrX4XuphVKjyNPO6DvSBBE=;
        b=NRgswhLSut85S/XPBZ0IKr4E+pacq81DgnSBkh7/1BF1ZCKVA0kwHuynmbxnZIEBQ0
         BvO5+zvJ/bmvpaDgxmXpqDBkMvGfmul7iN/buvazOxYtscu41bK0Qsc68YLuLcNDvhm3
         kGKEfcMdJeT5xwtDkQgfavLVZWxMlYps+BejmSRhh6NtUHO21i1pSsGWo3pyrCfv+Glr
         n3KgGI8AX36vyweJzT2hhFxFpBWm1kbG3/WqFwlqJTXLIHsCZn3xWimo9vTvog8ZnhiG
         1z+U93eE4JHAAVYRS5zUHRZEEzynOofj2uUCCDyUuDeQk7hz+lsEsM/KmkLTl41MaPfk
         xU8g==
X-Forwarded-Encrypted: i=1; AHgh+RqBQa3cIEFnwcdGTozXKvc4oyYTiEH08W5fK2BlSA8eFV2bIHxu5bJV03AVhV4F3IgzkZQnUdziLg==@kvack.org
X-Gm-Message-State: AFuF++nDvF5bc4WbK0PCLD3bvdvD4g0dFwEQp3SCPCLxRgDN7TLHm+SN
	W/pHXCf6iFN7PgfBV1zHqtYtIPEGX5K4/8MCO+UFguc7TuThaUXhKfX0
X-Gm-Gg: AR+sD13AQegPaoamUHIg8GjuJUy1aEWWmry8y0W2zRnCc7E5uNar8OhTkk2wQy5qUUy
	b10sEOkQOhoOl2BQyaElH7fRIOWV01mgLkLOm+j1suhU0HMp88cynqfHUPnLhQY1Zt14KQ27BX5
	7teLBMu//zeWucfx/HAnIHd+NBoRbJUlx+LXJ0X8kx6xDq1QNbFwnHn+3J55KY5a5CDXtsWHbMM
	jOnYMll+G2v+biuCk6yEwv6DBPJqObseaBfrFuvBGzFx8Wboy0gP8ibtBGrO8c/ddvzq5cZjreq
	I30VSjuBjoL4DxiIm9ZoG3LG+OqUKb4xvenhgUcKt2VTWk9qiY4vTUAna9RfYJBjg0xiah/Tn3C
	UKFh6qnWN6PgUZNAyS6n79M86IMSArWH/q5ewKIJ7aOJ690N0mXRHdzliH2YFMOMAgYtYzkh/78
	C2HTrVzf1YeTqgR3otnwjtLNLo3iGnoi21B4SEripraAnReMKNBNkyZ7tP3Jbe2BHTZmM3QXsCa
	tnFJQGWI2NzrjZ47kjUJyA/
X-Received: by 2002:a17:90b:5291:b0:38e:e9b:ffa4 with SMTP id 98e67ed59e1d1-3966d45a53dmr32189396a91.6.1787838851555;
        Thu, 27 Aug 2026 06:54:11 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0d3c9e4sm2935044a91.2.2026.08.27.06.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 06:54:11 -0700 (PDT)
Date: Thu, 27 Aug 2026 21:54:05 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm, swap: return early from
 swap_extend_table_try_free() on first non-zero entry
Message-ID: <apAsSRsJc1-pO0qK@KASONG-MC4>
References: <20260820115505.20027-1-shikemeng@huaweicloud.com>
 <20260820115505.20027-4-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820115505.20027-4-shikemeng@huaweicloud.com>
X-Stat-Signature: s93mp8fwntkdpjkbm3s975xkq5gct45f
X-Rspamd-Queue-Id: B17AA8000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787838852-441262
X-HE-Meta: U2FsdGVkX18e8L2AEhpgE1Ak6PYKdDHYvPd443myZJZqx8LGrF4QfkBkSBJFVXUat6+i36Tjx4Lg0AqiFkLpsvs/YpP64iwfff3nqSXqSi3SKEI6F9yqOWHGHxHH9Y39Hz9mpse/xfmrVkQqtzx8cDFANFM7WRHjhCkmI6hKKXh7XD36DZ0neFYoN3+U7DJhGwyY/dgd93UNi6jeJElbmgQOtyE6h4extKuqS4OWjVVRVdrI6z7ina9bRXiLFc76xlQEtZnDf4Qa81BRj+IVXMwkQ/KNOVGfgri+B/vlhTEKIxDYazOT6TDyRpZcYBbtyZb0jPiD1U+COhlC1uSnNS8E8BdA/O2vPCqQaHIMmYYjAkoIXRzBvIq+ajdJKjm8OKFyMcA7l+6Zd+1vUaR8S3MazvqoxSb4FEHpPigtezJUFp/IQ8e5k862tUMfmIAMtLbAQtAp25IGzBuGZNPceJ5e3+tnHjsd6VkMqqUvJqPd4lUN+dxjlyZkSgF727gZa/YTf4frxdCCyAHIH0WyVABOWqeXckfaq+SVGrZrn+cImDsxJc/bE0n32Kx3tUoQEV9r8vx6T/GHR6V1UXCvyH4acN6jQhvnvrPI0pPydTBSBhZkKcIuiaiaF24m6HalvtXTpjDDOs6VZUc0qlrxGZkl2b9/QyzoLNVG6s5vkWou2eC8YGtyYs+JnYcHns3LZ9cXzaElshZT48EQG7tl3fiIYdy8+X5YsLuXtTehnJPvsFn7zbp5ZKAqENUK2DZC4quvWDJPSO+a7UINBt7ovy84jeUKhqbdiahfs8LwW5u2MKjAOqRpgo5NFA1uiQNt7Z22cklGuRgw+lSSbP469TXqZJHnQGz3PDB9eZ7SHYz9zrSIbix6tyqZqkmjHO9PNzl5FLIC3BNzZY72WpFcFTVG53TQPfUg755P6lH2igm4THdWBwWIPdxVSNjw6w1uZcPEqik/4V+nwKYbztn
 AECXRJaF
 CKzUBxGJWdJKqCJ97KCOXSx8LKbK57XvWheKK8H9vXaLa5ri3fMZ+L9194Ui93rQJozgtyAglxEJjZlcR3d7gwhiy9RqDPuUv2pFmReG5vHqA37o97s2k1mOAPKx+NCMdeNm7w6soiwFmG6xHAUityRl77aUcsvCAa859FDoCljUeScOsbiLAvk0aveyEHRzaEy434q2kivF5Ib7bwSyfCEYEdxVlRj+Qv7CkXeYl9aSjdVbjlPa75R3KmZY8dlCZJ+xRKiNf0vmlumCmSSG0AFmhAqEsmn0/GlZhhqIoru+glxJZijlU0KfljHDrL2hEmyC1k1HpEya/3mHKvaDxRszUzOSaYUEq+N6+CNdKVbnhOvb9RlHFsqzhLFBrtdho+U+egzFxohKqBgFWPfMHFOy0dJa+jAqmSOCa0VHwbjv1Hl4j8y6IyCf3MeMeDKXC11Ce/hdA8qyn96mgcIP5cRdTL6gRVNv3ZFVeiOjBYuOtjs7bvS5KEdBifFw0NB5Oe4dU65i2QFqIflFDXE56lbN3MGFlKPTscG/1Y9dvLzpkjB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 07:55:04PM +0800, Kemeng Shi wrote:
> Return immediately when the first non-zero swap count is found as
> any non-zero swap count prevents freeing extend_table and further
> iteration is pointless.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
> Reviewed-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

Looks good, nice optimization.

Acked-by: Kairui Song <kasong@tencent.com>

