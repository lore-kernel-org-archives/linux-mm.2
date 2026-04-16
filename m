Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84042F433DF
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 03:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BDBE6B0005; Wed, 15 Apr 2026 23:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E546B0089; Wed, 15 Apr 2026 23:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784806B008A; Wed, 15 Apr 2026 23:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A18C6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:17:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06C5D1606CD
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:17:20 +0000 (UTC)
X-FDA: 84662958282.23.D19978F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 102CEA000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:17:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DXqBnryB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776309439; a=rsa-sha256;
	cv=none;
	b=FKXDb3KqEyNPqbwxACakpDtjDrrTvNQtsI4UmAMfxV/RLqaU6wOf4f0l8kKOLLWujeQHBl
	Qskii8eFBatlx1P9TeD9HE/BNfftAMW/bE5KHMfQcD6S3YP1TWji403pOghBhHXeEglKsE
	TSsUwC509yNaG4aIGt8FqLhaZDknVtw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DXqBnryB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776309439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nBmGGsm4iwgSKnnJppEfzKhl4wyO4jRpckQgWh7jPY=;
	b=loHh007DH78PbUa116O4f32oHpNqMR6QCnmS96tYY8srzk+O/TprmF6k5jbnhODFBz8sjx
	AuietZwTs1ZsJHy3zAszqObMR/ngCC663XKJddPdKKAJTsFih778a+VgFtdrLtr6cN+iyI
	PgdNUT1l2khltObfI21SzwWosTUu8PA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D947944437
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD44CC2BCC6
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776309437;
	bh=/nBmGGsm4iwgSKnnJppEfzKhl4wyO4jRpckQgWh7jPY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DXqBnryBwVf0Y9R9eXg9pqlQAopV3JbbcK86rEWD6Ksu7JCeJRIWT6CCv+vAls6e5
	 uBEv3t5AbP7n4Zrq0t4151lduMVTv0T6Htpv5rJUO7Y4AWkBFEmjEopQBV/Tp36n53
	 mx/+lXqJzRlmqJxuaQQxXegYCqmSrVtTg6QHXuUdYUBYkKluWm5Lnu8q5bbJ6ysyDV
	 HUDepyfxiUr30uMQ+wscmH91m5o0Y+CnnrcRKfNlXNfxkDxJIG+MTHRyhfr4J+tX3r
	 bAEB426IOCZnLsSvTHBCL2OipKkwT8R7sl6tJpo/rCGk22qhYzza9dOkBFY5uMts6B
	 A+3aMysKTetMQ==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-79885f4a8ffso79880607b3.3
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:17:17 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz3HAd26dubOpNyYSeQrbDhbRwl0a3sAUMh8+7QNqe9X25fET9P
	+5CWV8e8U3LW4sY1tJUUTMLQxKn/ooS4qzBgCfFLrxav3PqUhOPt0NpFdfqQAzlKxrSKuKSEKyA
	a8A4/YcrrhoQZuqHFAu1qyUasqi/arDGqA1YIYWDnYA==
X-Received: by 2002:a05:690c:d91:b0:7b3:b0a6:2c5b with SMTP id
 00721157ae682-7b3b0a632f6mr150410167b3.12.1776309436995; Wed, 15 Apr 2026
 20:17:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260415085658.993859-1-baoquan.he@linux.dev> <20260415085658.993859-2-baoquan.he@linux.dev>
In-Reply-To: <20260415085658.993859-2-baoquan.he@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 15 Apr 2026 20:17:06 -0700
X-Gmail-Original-Message-ID: <CACePvbXra-aXHf-N9btoCHAAaVGrVdJPzdeZVcsR0or7kLfF0A@mail.gmail.com>
X-Gm-Features: AQROBzBUSYuzJxADs3MMAhnlRX8eZx_cofZToGgTxu2tuiC0nx8YJfCO8q0OOcU
Message-ID: <CACePvbXra-aXHf-N9btoCHAAaVGrVdJPzdeZVcsR0or7kLfF0A@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, baohua@kernel.org, 
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: nrndozijqt6rj1aqbg3ibwqde1aqj4pp
X-Rspam-User: 
X-Rspamd-Queue-Id: 102CEA000B
X-HE-Tag: 1776309438-368591
X-HE-Meta: U2FsdGVkX1+aRKm9akSwc4vEYwnj6smTlHTUiT23LgaA/f2jra5G8q2iv6yUioxhrQrjWVEUida+B3B0UUH+0jQVHry7XHBVxy21/kbRZ28hithrIH19/mTdB6oXQyE73+YzP3mT8VXoyyTAUij7H31ftXmbaAtxVIKw0Njcwlx/RiKq9kq6ymc4bk+6/3jtnZDkGiRKGWQxYHc92dqljcrsDqgM1UwyFmNRl5xPCvcWwEIKp+Z95CK+PmRIUWafSofUHQg4Erl1LCJB8MkIxZUfhTQ9tLRmppEg72yGcfLgl9HvhlCR4THBAk+n/21kPZGLhJo2oJ7gZhaQ59QuDZxBf4xE6ScCAi8QZuRaPvWHznXV6V+RicjOz8br7td+LM8SGgkzS3EXUyjIzGJ6P+39PBwqiI5W9MyD4aY05jQbsEohavDGCe816jZSyCSGK9F6v7G6k4sKWWTsCxLU3YRmL3r5sSpHESnjTD9gMYgTmmUsKjsmRNrNV28P4/ZXb4sMoMbeKiM2+3cwvW49pNwsSubtpHgGaBvN/8K4M6T+i+SUfyJSvkp0K42UJnAreh1h/fdgvPxrfP8MHVicgQHt77+NMXVusFIrB6b14eg/QH06Is7NIR2DP0tDHajxJSwkhnSbAX+SD2fszbfWp0HOGBXUhYsyrmWf4bBnITutORkUlaXtZ44vl6nWz8QYl71pj6dTkC4wcRC/MGc8kBBRpaDW3VMw3AF4za02THh1MyMeHgv42QcmP1ZOqfmG1SRHAseSVihfwDecbpz5txs6oVOZ/PRo7BSdZcB2ImeGbEJbMznaYixb24uwPm152JIR5aUu/hBYqnuyFLfOOBG8Etz8L5freE5lULXG8OwTT0BvI4hGFPFULr6vtU0Gg5aB/W9m+VtYV7naXFJ8XOI1Z8/WkKW06z6ifI8REBrZkZKDz1oRjfPuOxGia40ShSA2I8iNnS0EIkGOaYR
 YYIQ7Rtk
 RL9FGOQD20+MBt27FPjAfIQJtQqNoN+zlg/DU+QXYc04+TNeyR8EHB+3JxVZS/vhwqHQPdMxnHz7d50s+Pa+xnaQrHZxObgC9CRzsVDy6g6dJY0o5GXe4yH/H9Nu6DoSgdwzPQ0rnaxaChG/d9wBMKjXtPTG89JDEc+sGQeYv8ITY2Ua4QQqaJ6IdtWOyzIBormncWtffH4VsNo93+4R8jpJhIvAYtq0mr9ygVemajayPMO6g7r129jlKpf4MKQQ3SdKupzEY5k4rBnJjTMC1M+bF9YVVWOngwZL1Tb3M891RD9zKAvMZ3oRaXpueb2LJ/zbU8Ws5EAVAQER7/ngOQg/d15QEugaR1hbDCw+oe0lOXotaHN2rzC4meyKd+0BVoG76Ex27rQm+IlaWvswOZkNw/UTzkfbToiscB4E8Dw06Rio=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 1:57=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> Codes in mm/page_io.c are only related to swap io, it has
> nothing to do with other page io.
>
> Rename it to avoid confusion.
>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>


Acked-by: Chris Li <chrisl@kernel.org>

Chris

