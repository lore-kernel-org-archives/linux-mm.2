Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 318FBC4450A
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 04:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4EC56B013B; Sat, 18 Jul 2026 00:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25F76B013C; Sat, 18 Jul 2026 00:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3EE56B013D; Sat, 18 Jul 2026 00:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 972126B013B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:40:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 01439160336
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 04:40:34 +0000 (UTC)
X-FDA: 85000646430.10.937F7AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id F123AA0003
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 04:40:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S3jQTGJ7;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784349633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7UwZwxfQIvF7dO45hR25SAXUiD5MyJStLQfF4eDcfik=;
	b=4qMH024kkkN5AeEzXWvZkNx9zyYz0sW1+3WcDhlW+Ab8VPbQGs9FvmG0gamFE114/oNp2/
	6MzkZaImGApTOm/ghrFwo5nHLg765vKB+sPFYCdNRxQ2lXhSFLtaCWdu9eDGvxytErOPBv
	hiwYO9WG42gigYyjTKM/DV+6Hq1RHZM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S3jQTGJ7;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784349633;
	b=mfCZ+PL6vUId1EwsYC36QEnPgaBpiZIXnjQAECpTzSF/oldNMpRL89F4Cj0Nv6VlorwjYV
	a1cqHvb9FAieMVxP6ioH1VXYXDPP3jQcDV6eF7FPsvbaHI0W+AXE6iQf9pI9snu7SdjG4C
	nkXmXNfr6IEMJXadqT2/+reSrK42pW8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F9ED60A68;
	Sat, 18 Jul 2026 04:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3E81F000E9;
	Sat, 18 Jul 2026 04:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784349632;
	bh=7UwZwxfQIvF7dO45hR25SAXUiD5MyJStLQfF4eDcfik=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=S3jQTGJ7zouDEB1NTgPIkXFpQ70d9aGhVnHD2ckK1/Wz+T44mndburaP7EQWzQLlm
	 SVFNIo+iUguCnmZtsmy35Xk85Ij7ASBe1remrOIyRX12uTKi7y1g2KD/hPpiNyIHBW
	 aUtG3twcnC1vl4+h4EY11swlOSYHdFLEMUmuc+Dg=
Date: Fri, 17 Jul 2026 21:40:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v2 0/2] mm/zswap: Fixes and improves the zswap global
 shrinker
Message-Id: <20260717214031.8b22e9a37ea3b0c564b466f0@linux-foundation.org>
In-Reply-To: <CAO9r8zOrXqsEaCEJUUAxbAhhN_OQb8ejogeUa6k8hX_JV8hxxw@mail.gmail.com>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
	<20260717181839.c94d0335ccef0084707d3d85@linux-foundation.org>
	<CAO9r8zOrXqsEaCEJUUAxbAhhN_OQb8ejogeUa6k8hX_JV8hxxw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F123AA0003
X-Stat-Signature: o8az4hmt3wg75h5qb85cabnb31qfbwcn
X-HE-Tag: 1784349632-572897
X-HE-Meta: U2FsdGVkX1+RhmAT5W11w7caeyKSqR5mk/i3sZvoLIoQ0M9sDFckE8e2cG5T6evsxon0mPff41wznudg9uDEYAv0s5F9NlyFG/hdyC//Orax0X7UpiE1nFJR216pt+G+NvsGMjeBLvRF4APVWAdkZKRSMQEfjmVksLw/c2DnP2ZoqK6B1K4Qp8ZyqXbOPqAiW6oOBOTAS1iMRv3Uas2Sl38fBTb67HI98Sk59yiRzWKSfOUZT0nmPe34hMd8NI0uCFehZyTk6pd4Q5+0Eij6F4Cu5wfZQCLWyfdSwdniI1EL0M5t11Ah87Vwu+9FflLP7T9rP0XseZnaq6udqg6ccNKLi8vOAz0bx/N1X8cAkNEtdU/ggIeSZ6BEa/xtqW9T71DksRE4gcwSTUxnbscx0giWesvMzYGQukY+DHyhdB6l7O7cZjgx6KEZlgvsYBM9G5uM7BGt9KUtGS916KlQwKZ1oRixPHxnoWNM1suaN5/RUb65rBLxJdJCOUA0zUMOuQHQCvyRnSIA4OfXpMhZ+Iea/Hr+vbeeYXL2RA7EVLJsZ4iyXK4OzXOa4zIGIHB9voNWlUAlwAivylVP9AeViQOv0Bqfsq7JVePJn2zVLM8LzzzCurEKfqijOhHhb+N32Vc+Yf14wPdAcFoSB2YnaZjSUFG8LxOuaTdOAdelEolxZeE6ETBKNwbfDxp7XptFy8LlZiORPFd9Ga6G26NDQBtxnaVHDIPNC/qecsFH0yq+t9QBnVX0AF10Z+2BwL97ZIPrm+Y1YJDI/LFPlZ636SkE5r8entvDkVmKteiCo93KqWU/klVqXLqc3Ghn9cZgn0JeN2eNc89ozQHPdqgszsOAiDZL75LP4YFqxJg8jahYbOYrCGe4HXA/mQqACPIK1QfhxICPEwv7S9OxCxlxGchIgur1eSvhcbiFXU7hdEOUg+kuqG8mjykaxGxgA5lYfpEfQyMnFllT6YsdJ3W
 c+3ColtY
 MxbTkR/yQL0R71hAuWoj8etodgo3O3PTy+MMp1Lq0bH8F5tJVC9hUXcwY+dKFcszExN88/YlXXG1xFDgwv4qyjM/f5nbrMKOf3e3KLqzwWyev8kG3UQt0BEhQT2x650CZdcZdPJpBXE6st8kicKNYwyQTHsMHXQtkWNMS+PfBHJ0Bv8j1uJfxs9+TvgOpMaN2sfsXtjvwpXQFvFxKT9sO12eeKzODLkcPZJqd1cus/r8BSUp4csX5CKAvdXkqu0pJBGi+XlhzOymigq0XNv3iYVBC1hYD1fgnVuIeuGnV7jlPPkkqCznfz+G/8aCXUCeDJPvf4AoHIxtmOAZh1B8v5NOjTBVCTrIpvUvB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 18:28:04 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> >
> > The [1/2] changelog lacks a description of how the flaw impacts users.
> > Please describe this fully and maintain that info within the
> > changelogging.  This info helps -stable maintainers and others
> > understand why we're proposing a backport and helps myself and others
> > with timing decisions.
> 
> The first line in the changelog should be sufficient imo: "Zswap
> writeback on hitting the pool limit is broken when memory cgroup is
> disabled"

"broken"?  Perhaps this means "fails to occur".

But what is the userspace-visible impact?  IOW, why are we proposing a
backport?


