Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D342BCE8D7A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 02:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD158E002B; Fri, 14 Nov 2025 21:35:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4508E0005; Fri, 14 Nov 2025 21:35:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1528E002B; Fri, 14 Nov 2025 21:35:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC708E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:35:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9E66136DF1
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:35:07 +0000 (UTC)
X-FDA: 84111274254.06.3ABF13E
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id C9362C0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:35:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=T4Pwcv1C;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763174105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bvGwPC/29enE/uDNSsqwLmFNQ1QdSQel3u5hnxMC1QA=;
	b=sICutowrGBjZ40zJjh5uZV+9suqEvti0OE65t35VxqBbRDlr7khTyJEBwc7UQUjP4d40jR
	4IaDxY7HwwGdVpTxRJgN9B6sz6XS65Oj+eppPjhUBNYYLa0MvvLRf3Hdkplnm+Q4Abddj6
	9prRaPs+fTzk//IABl+oyO6JFDyeNe4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763174105; a=rsa-sha256;
	cv=none;
	b=sZKuOrkf/yV9fdyZBvMHFx0aikqkNSTd6Xo61TDNLgPJ3+H71eUzKVNjm8KvOK0UCLkp2w
	qZ7JKknMyn0dC3z1YNEs0TOn9zyJJe0kP31dWjqFJbQ/z+X+befJZgsM+MWwGDMNKJA1r2
	NueEcG09SBPkPvftcBDxvBA2BI/pO50=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=T4Pwcv1C;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-297f35be2ffso38376155ad.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 18:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763174105; x=1763778905; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bvGwPC/29enE/uDNSsqwLmFNQ1QdSQel3u5hnxMC1QA=;
        b=T4Pwcv1C3ua9WaEynb42NqCPKJ06nLKMCpIDCcT+IqZnjpmu27y7ahVCqBwPbU5Von
         9jD4Fk8YCFnruNCmh/W72ukbaVluTjEwOOgtDfASdejh6B9Yn+LRGGwynzTArxyavbgc
         /wHE7JbYJFlXe41epC81vPh/XF3H0mhRf5z4I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763174105; x=1763778905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvGwPC/29enE/uDNSsqwLmFNQ1QdSQel3u5hnxMC1QA=;
        b=hWJb76cnmAXdUOV9zB2comqjzfqiQZV64msxCl4cld2vL28Rv87yS6P7iGjMimL7Z1
         vIUkqK+edFd71WDcUo7Kek+zfrugl9lvmR6pqO45Vm4UIvOyNLe0zxBZxniuYgVla/TN
         gjwb09VTttZR5E1LBrkgylw9/7MtMtuU5HOMHtb0QxzaLNMPTOn6YWSgTDd0VE/j3iVw
         P73OYTxoA7DlHUngQ745WX1b86w9BUiZWfu95mWZIRoLhRzeaNjkD7FTKvdMpLI4IZ+d
         XdNHVDl5+aDvni6bgmHm/PEkDFHglpaOGMYqC7qsZC9zs/Y8pmzNEiMalifIh7gIO2nR
         223Q==
X-Forwarded-Encrypted: i=1; AJvYcCX8fcnW+S8sYJHQd+nS2K+kkDyl0UiENtY7ULDNXT9p/4hCKncW4mzyM2sYxED7T0YLC4EUcz41rg==@kvack.org
X-Gm-Message-State: AOJu0Yy7M7rnI146GQo+XiCGSiq4HpV6vvEQNtsI7Uj3O25m9psB6UdC
	jlQwWVljFdUfIESs8L8LxrUSn5EWqRshgJXnHoYXGr+IH60SCC2P/5/zkf8uZwQcor6tZlKJ4l5
	9vBM=
X-Gm-Gg: ASbGncs3YSqb6Mc7mG/G1gU+kwQ7brRANi5GQdiWm0/FnYIvOQ+N0ggwHWtzgfGlNR7
	Z+kY45ICYpczYvMx61SeJaoYApWOyMhr3IKdi0pvEBBnfqLxS3xUvTrEbuQ5+G4kDT7ZFSEnXw2
	R/Vi2afy2YWpGPVUT1KfnhOQINQ748eLeziE21gV+b+RHicD2N+ecfbGDn6w1SAdNeX3Jc42XnD
	HbANxKf4c72EUGOsd1EUMAHZZDJ5y2kX8b1rMmwfvjmUtqc+9GPPrS/5f9iZWB5HPtW/j0p/A84
	mPOIK13n/BzLMN8kqS12VZ4khkRanC0GI0QdavpIqIM5gCKgXrHkOSxYFgTrQywwJ3ERO8cHlk8
	IdtJazoGkUE0Yhd9667MevJMa1b6f56+DccNCMSIc1dDgFIxWJ8BII4h9MALiDAN581XpNjD/AG
	BDN2eL+bF8P9guUmuhBPFTAAqeWpTDNzkHpRqcrw==
X-Google-Smtp-Source: AGHT+IEtm5GlISBRItBssRqjjMdpT5JTRyYu+xENZW+2fV+/0mSOGCmWTuVBcIzHooQpUVRS/VwIXw==
X-Received: by 2002:a17:903:1aed:b0:295:3eb5:6de1 with SMTP id d9443c01a7336-2986a7414d6mr53788275ad.34.1763174104609;
        Fri, 14 Nov 2025 18:35:04 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:b069:973b:b865:16a1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b1088sm68641555ad.57.2025.11.14.18.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 18:35:04 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv3 0/4] zram: introduce writeback bio batching
Date: Sat, 15 Nov 2025 11:34:43 +0900
Message-ID: <20251115023447.495417-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C9362C0005
X-Stat-Signature: kzypqp3xfr5a6yzhgib4jtfxqy1sqom6
X-HE-Tag: 1763174105-852813
X-HE-Meta: U2FsdGVkX1/bJ6djbMPKRokq8WBWh9u76O7Nck+8vvqxOrfE3r1nzxZC37bIooPiGGc8s/+Apfpw+ch96EYZ0hswhtTdVpJoxTvDezPS0u49DcA8T+Yh0EBYHsaQqooJZ0HdOo62LVO6upQXFMyUgcSiSNU4dxpUN6M3CF2j8+7uhWCkwxpEDZCcoX1jtt6Vs7+AoSlbprUuztNZlTbCg2S3KWWjchYiqN5d5QI6JTF85NPRbooGzTW1lMpetSrd5lx+xlcpPIHevtCgVIykHupLr3SaJdEp8pn4u99z02XzODTJ2Obb5+CzHm1nrY5Q67KaE9IuIZ+50+GxUFVuz7xbVxTWiYrFYjnywG0+om/zUN7mZZ9qAgCcGGLKuwa3BUP1lywh6E3UknBgAdEuHbxtD5nIU3/yhgWpk0BE5dkTXko9gHIVioi9WRi5N48dlSGgeoNOSyOvARd/jr/DjunlLOe+a5rmP4JvmTbsOdnNpn5dqF1+Ur0m7e8QM2vIQ0rCcqbAGG8dTC2wucOutpOKcHuo9JrhriuQZUAn6OgGnLR1UUVQ1g+CTdxkF3D3hcsuYlbVi3z3qzbOxMN2tp0dz2+FmeVWbV3qI9Y/RQCvhFH+qddwbzNu2CI58aIZKbWGvpVj+KWUU6eyTXqGZgu0JA+BNdMWccKJ66sy+YiCNe/Zfb4K9B7e+unO4lEkLg5dd9fBPC8JQRqF2pLAwLS/XYbfX7zU3qv7ol6VS8FKgVfED8ueBmDlm7k/oCE+/sTI9QIzlsukQzLfjn7iBkI0/zrx8eh3OCXYAQz/CZ7qtfXqnIw7qTULarYRHpp34Ye/+fRHym1vVnpiarF7Yr0+/Ppc2AcwfjUCtb5OTRFFQYu191v9COzOJ1+yjennQS2b/tMDMTmTuJYen6zBIuoM2ZDBd8QxxFBeCcnK8dnhVdy6Dqk12wO1FoSCat4FMsu31NrZVZQRJF4je4y
 EFz56nSE
 Sj/Cl8SWC/PfuSqXIvR5/p1alOWHzGsMUYZX1YQ3VjKYXiafNwQ9vlzg3LVPYkF5I5ukFuIXNaneCsd20dMa1FK6hO3GO88zv2cPF4nkFMzocpnYMsV8gsUPZHJFZ8XTghNG118euO5J9/yqzgSu14guY3kET2mO3h3X6v1pEtXWFDHfP4XLUBPB8vU26B1wSJZp/vymQumYWjJvYxuIqV6qvfF79CQtdtcy+8aiAVcSC04CiFgkQqi6q+BegST70QnpEyb/i6jKPDzrMeK4eQ0KDVzftiU+v95pvCRyIOMuAg21E7YpbS42UfZU9KCze4urTWkDd0YML9HMf1iTjkq56todx70OdsKQYZTBxZyHyf7E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a rework of Yuwen's patch [1] that adds writeback bio
batching support to zram, which can improve throughput of
writeback operation.

[1] https://lore.kernel.org/linux-block/tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com/

v2->v3:
- addressed Minchan's feedback
  - changed GFP flags, dropped SYNC req, minor code tweaks.

Sergey Senozhatsky (3):
  zram: add writeback batch size device attr
  zram: take write lock in wb limit store handlers
  zram: drop wb_limit_lock

Yuwen Chen (1):
  zram: introduce writeback bio batching support

 drivers/block/zram/zram_drv.c | 410 +++++++++++++++++++++++++++-------
 drivers/block/zram/zram_drv.h |   2 +-
 2 files changed, 325 insertions(+), 87 deletions(-)

--
2.52.0.rc1.455.g30608eb744-goog


