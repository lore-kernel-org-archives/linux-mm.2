Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E352AF8E4A7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 04:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D106B0005; Fri, 17 Apr 2026 00:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3E596B0089; Fri, 17 Apr 2026 00:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53A66B008A; Fri, 17 Apr 2026 00:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A5DE56B0005
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 00:27:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 735C5BC91D
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:27:00 +0000 (UTC)
X-FDA: 84666762600.08.4BDC442
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 997474000B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:26:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cHgTN7JI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776400018; a=rsa-sha256;
	cv=none;
	b=JY1J16BTJo3DzCujwgwEFoGPSn495vmH+m2dcBo9241gyQqlOWfkKKsDau70ZMAd46leb0
	ywm52lx7piiH8rX4XG/emebeGhi97Rs2rodyL5DJpVZrBS5TY/5rMUGyC9vSEct8S7I5cM
	/DiWnVsN0OAgijXqdPgV9gzSQOYNpIo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cHgTN7JI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776400018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sdZwKg7ZqT6fpMDssi0ujHMgVQlDq6enJyNYdZyrVCA=;
	b=lHCC7z1Qb1/Xeg9d7azjS75Z8IVhn5cnZBW2NExfWJgAPCLmH4VqCQgtmRParBBV0pppO1
	2RulWvTp8e9hOEdjDPPiZw3ds4KFb6IKLUzo4XJcuUOlRXsBwEyLoWkQmOJKMZn+yJGOuL
	BK24rCCkILcbbC0kSRAAuXezZNxmCK4=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c70fb6aa323so76752a12.3
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776400017; x=1777004817; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sdZwKg7ZqT6fpMDssi0ujHMgVQlDq6enJyNYdZyrVCA=;
        b=cHgTN7JIFkFqBk/BsUCoymINrDA/+W+titp3Nlr59mVL1qzKn0REJpN6S2ewsfivJ+
         Vo/3MQNA8lyYzzt0qx3loO5CKQLDzU8ibwBMg7HQ1q7AIcMzhYfYSwAQXrgWzC+NWY3I
         7xh7S0zIY0W8m2Ou9ZaqsqnSPi1QRbZFcaQ8S+aZKrVXpM7qpEZYMRBakoRUnuTVoS2L
         R91+iKhHd72DUZay0kUs6oB/58o9IpOw91OXmnm19nnaOnWIr7wVEHRu75hnzm1uIwOB
         KprLu2gwWvfdC/PU+1LXaOXJ3BhpuL/fmBX8Z7XpPIEK5ZqEPSVRYiK0jJGoVUHS1GmE
         SYWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776400017; x=1777004817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sdZwKg7ZqT6fpMDssi0ujHMgVQlDq6enJyNYdZyrVCA=;
        b=rYDjgvk3vv7RFLoCMWF7TMR22sqxEQi52Qq+RQyWOa7fCxIQDU+e0JTBTM/hO5olqF
         4icbUIrfcdjhfdMj8zFpGQQG2yGUs3bG/eDLTaKOcskcoSpfN2VFxv71sHtuMCCLn1PT
         2mI5bGx8YITnz+DyxgZULjbZnf/4MWmEg5itkrGaO4PHzt3aeMiFjIYTHBlq4vRKMNtZ
         9nrXwQXOpy5GtiaYk6+qH08ObokmRbchl5QkBfVkbMCIS8EnFnAZ2e7+Zc7LtXMh+2kl
         bi8kTntq9ijSpD13AAZ2nXS8w3SPTf2WVpsPqS6L/mQE6QHhamrQo5/gNM58hAFEjnOt
         NuWw==
X-Forwarded-Encrypted: i=1; AFNElJ8LbWhuS4zDzhvdSgyCB2zJKFk2uW0PPcCP+PujUSItComXXc3cNhr+etFerzoVqeUrfDmIwPiv4w==@kvack.org
X-Gm-Message-State: AOJu0YxQtq9Tx9S4/JZUcJl5ZWMexcKG4SZk5ajm3BCv+pMvJbflTPfO
	zy0DrlU1UD76yu/haj6rQps3qFvOC1qD40Ji1xpWgpO/urp7/EPtdSg8
X-Gm-Gg: AeBDiesGKkkw9rh1ZeU9HHAaolN6MAfXPedL24zNNEkEUUszYo3mTm/mORpxgkRC5SM
	sOXPLJS1e0s8tXu6yb3TDYIOl/WKUmlUjCjaK6Wbv5Z/QD8u0hcr1+/hl3IEuensc9G1Orc7+Mn
	1l/N1kUy4blcLpPKUNJ7uM7b3iNEv6H4vfXWa3HmjqGw2oS6lTxtcZLT5SJn8nOB0V7WnW4RtsI
	4nBCc28Y3KANcwyX3LKqfmpO/+n2DytKETwqzQtmRcu3H/91KsB4KDT0nnSK89tXImuvRScQIkR
	/W+2ClDJBRFf9AM0ykDCUYLkiMoiMN7cY11KuD6wrC3mPAnx1zJJxUWeJesR0g4jOnZJel2BJ4K
	KdKRlJdaIDD3GMFVVOBFVnADVuTZ7IH1bKJmeF6Dx6JKvpupDTlhbN04LY81hZ1vJVbbHnMUI78
	tekY+DCVez+AcjmElzt4J/G9ezOaLSzrLe+8wg46K0uggFwCK0i+L+gbellYcXSh60nQ==
X-Received: by 2002:a17:903:bd2:b0:2b2:ccfb:8387 with SMTP id d9443c01a7336-2b5f9f534d9mr10448305ad.28.1776400017244;
        Thu, 16 Apr 2026 21:26:57 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:889a:1f39:d795:a77d:4309:e1bb])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0c17esm4928985ad.41.2026.04.16.21.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 21:26:56 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] mm/damon: reset thread status parameters upon kdamond termination
Date: Fri, 17 Apr 2026 12:27:01 +0800
Message-ID: <20260417042701.4077-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260417011229.75947-1-sj@kernel.org>
References: <20260417011229.75947-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: 1mgwkcxk9gsqgjksmoh6tgp3s57pc4hn
X-Rspam-User: 
X-Rspamd-Queue-Id: 997474000B
X-HE-Tag: 1776400018-925135
X-HE-Meta: U2FsdGVkX1+qJyGcfLfXIIHjklFCIGns0+ss4C41IbzOCvzGT7DWEUtod3C7E2F6kIgJwR/cMzg2bV33gDr0852PucwBM86DqHFmWv442RRXf1ciRlrZO1j7+LU3Ll3Xegz3ebNrbJXcioBpuFlWU6oCJ7/DJKkzAzHrj4zoRjTvrihr5+0qb3lJ7g5/VfItbutpCHXLyb8UKi53LMuTVJF2D3oJyZOP0b+lnIJZ40VbpmEDWgn/y1nK/FOD0WS+3RAr27l32EaNCPfmXxXZ+lh56LPJ0a4//LvGsG9EVljvvJO4AF7rQ6LtsUE0pVwuZ+xn6ZTfaWpBlQbCpWj0HCNjIK3MKGrNb/TFjuUyOrcaJi7jHDz5I9zG8qzundwcchRyfIyLwjNOpBBDUpV4m3SegAC/uTN1DYwzOidAjZomnLCD1Y+Zqoi0RpVfzQwpJMjUKqe8Af3pesRrfh3Z7q9nUIU4dZkz/yQqcCF/dJ8VegsrSE7zzVFXmZW6M/fURCNjIxA0kcNfvz0ezkBFX5cbJcCxCbdS8dXKMVqG5CpWUWChgxjtG97l5R3RxAezxwBQGeK6e3/B79w9VvffaNXxRWlYWLB8XMjfsksnfyr7WrSpoF7zTnAtjU+nanL7XL89YOUAYMJhBFiC/SfBF7yrpxibu6zAtBM8s7MCnwgGP0oAzEWxlGb4FjyWlfZeX88oJQV+beTTx77d0wqzuGDGo09hToBsj29Xx4Crohfpu6voJAuDWmh0iosLD+B2hm1QYcDjliz8n3hta3WSVcNNcSuP14UJdxYJI165oVOql8XlJTQBRpLbkffeWesIKZWCuzo8ngVbc/2aq3AUSlHHFB6tFOhpW7KAwrtrEREYXI3kRqqSyIqu88OzDSsiFRkIZiOnWJZfNMHi0sAuDIOT+jMKXsNDy5DNjGFe4FAGZhuhT6gskBnFqElSnlRGDUuiNNM4q8xcEYbXUna
 RHrFwqqB
 iDA7bj63T8Nkk3OyIOEtSNNJzpl8tt3BH+ut/bpCiuLVX1V8//T81ESBv35C80dCW/xKYwmXbkfDZ7dnWQSn1Nm38GYc2HuW634CixxvEUe8oH/XcbgHaGPN+PFi4tHiJefhOuSKQSOFcISmKvcmQOm0Byxp5v3Pn0jHNAXi1OfvazZV8OOgo5p+sGj7a+n9uFzOvL/f9/oCHHtK56Dbba0NN0ZZatAIoxSLSH4BzPNpXFcSXYzCwHkDQU4SymrK++I2+RRMxAWMOc8yPkSB1ZITNXY8kuOMvhMi2dPaplORZDOxCALbZqZVvfmK+TFCxaKSAw3Kpf60plGQkgA7HeKsW/uQEJVB4wzxJt+tq5Oi/GtuwV1Cgbdref3BkWpp5bukcYMft1jj/gsoaVZqATLDymvr+CExJGGO0/jfZPj1Aw8itCO/9PlJNrOlcMVTEH+grjwOKf8/QP1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Apr 2026 18:12:28 -0700 SeongJae Park <sj@kernel.org> wrote:

> Maybe I suggested too much...  If we decide to take both my suggested commit
> description and the above change direction, maybe it is difficult to say you
> are the main author who should be primarily responsible for any followup issues
> on the patch.  Of course you will still deserve to have credits.  Maybe
> 'Co-developed-by:'?

Yes, I've decide to adopt both your suggested commit description and the
implementation. Therefore, since you've done the most of the work, you
should be the main author of this patch.

> 
> Meanwhile, I feel like the fix of this bug is taking bit unnecessarily long
> time...

My apologies. I have had limited bandwidth recently.

> 
> If you agree, hence, I'd like to take this over from this point, and finish up
> the remaining works for this patch.  If you also agree, I will also take the
> responsibility (authorship) from you, while keeping keep your credits with
> 'Co-developed-by:' tag.  What do you think?

I agree to hand over this patch to you. Thank you for your help.

> 
> By the way, I hope I'm not making you to get me wrong.  I'm not trying to steal
> your credit (authorship).  In my opinion the authorship means the
> responsibility (or, who to blame) more than the credit.  Putting right name to
> the place for the responsibility is important for the long term maintenance and
> evolvement of the community and the product (Linux) in my opinion, so I have to
> say this.

Thank you for your explanation. I understand your point that authorship
implies responsibility, and since most of the core ideas for this patch
came from you, I fully agree that you should be the main author.

Best regards,
Rui Yan

