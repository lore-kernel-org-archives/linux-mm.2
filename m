Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01264CDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 03:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D826B0088; Wed, 24 Jun 2026 23:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74D66B008A; Wed, 24 Jun 2026 23:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB28F6B0092; Wed, 24 Jun 2026 23:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B8DDE6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 23:15:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43A88A04FB
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:15:30 +0000 (UTC)
X-FDA: 84916969620.18.C089AB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98A06100007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:15:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DAcfShUt;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782357328;
	b=LMOu/kRjkYIdhggzhasHhGG5G5l+tHMv5T5YRiCel05lj5PhwoY0rmM6gc+dSUJ2iZb0Cf
	nrN5gZ85uipAoJce2aEpyHbVuy1W6XGTPd/C1bxaUEJv09Et0l6ui4VDl4B9gHIn+Yk0hY
	CulmkThjq+tKA6eyGa6U351vc98D6m4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782357328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEOAwLmZP/LnIX3/it4KwigCVy1k/SZzC1kMpM28RzM=;
	b=02xrrm7PVqBZLq32dHgA7lBaxlJsvQw0FxlBUsxz97IDmLpYVtM/GefHoH4bZdZ8WZSUdv
	YWSscJSxqakJjefXkP+mQFGNZL3RvkyphXcS7OULVEqqJcQdOzexHiuIjc1NkufXLoPbTq
	+FuuW9GzQLU6HWcMu2pfKeZv6UX0Crg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DAcfShUt;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74E4A40986;
	Thu, 25 Jun 2026 03:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0695D1F000E9;
	Thu, 25 Jun 2026 03:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782357327;
	bh=pEOAwLmZP/LnIX3/it4KwigCVy1k/SZzC1kMpM28RzM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DAcfShUtTLdye3oAlto0zTYdF9Gp1ZsGAfpfxVcFYRpuuOFeq+vHzPotrzKYRSw0r
	 8WEM7gKymBD7myijm8UrgQq2+QxIcaacBe4OOgr7H7aWOaCDvnfZFP6yTqVIG/sCHV
	 mtrTaZ/D0s+4IqxzJg5IhfZ0Iuvg8pEMaT3tOBa4=
Date: Wed, 24 Jun 2026 20:15:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Ye Liu <ye.liu@linux.dev>
Subject: Re: [PATCH v10 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
Message-Id: <20260624201526.d96ff165f09f361ad128cea0@linux-foundation.org>
In-Reply-To: <20260618035750.3724613-1-zhen.ni@easystack.cn>
References: <20260618035750.3724613-1-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ncqkoxojo4dk8igjwtow7j111arm7ijt
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 98A06100007
X-HE-Tag: 1782357328-723755
X-HE-Meta: U2FsdGVkX19m64lIV7W6IJs7y2QXenxRG8bEMmBYVTYv44UgQClJc8ofBVlnjODxRLAv8J8Rwba4MSIOHFHyWCiG17p2rPiVB9FItMJTmdF1u90UplkjNVg+tHnAu0zLApl8MgxDsklOI3mTCtBYDpXIUs9ZpQArxUk/3qJU9HXXZ2RvgNfhy6i0QUJIMwYl0+Tq7ICfm8mSIqVmDQpKpFFUO5bSc4MMGkPkk+GAUVhEwsleXf4SSnrsvrDINDVLLbYzsj1xmf/0OzV8NXtO4sTwfy9tK1wqLkCSEKbsUK9E533ut3VKrpJEcZyhD8GYTHq0R0r+tlCeHvhMwMhsdpLMSCANZlbaPIykngTVKEbHuGbbXlgTgFZVQoT9OGaKqwG6xugHoZ84k0c8qOmiNaErdXy29b9KFqWW3zy1EvurkrIRo+LOu/sqlbXlm/bx9o6Ahkp5NsI8WTjxj2sjLcuRQmpXZE/nb0YRUseH+3u5ghmSKYhlTFo3yqqmPohGeTgxEidkndw74ZoHbZH4rIkOON1s9tKvEDJQdTIdPmYUnff8yqM8ekSotqqvPNUBsQBZXsDnDxPrLSDk88kuyoBX8GmT4vsPNzGaESGBeP3wqc3rDDy0wvXo443KK3zK8CzkKSptJudh3wui63XijaDsm5vio8xbV6OLfbZdJPhFDgu9Zxzio0I/aj4H29hx+8IL0VKJ+EoTKF+HjCyPB61mMfDI1Kfw9mvjaClJftin7s7aqVtC/sWEgAKl/6AdIo22q2Iolb3U0dFII3aIuwi8vjPAJP63mJfvzP6bVPb8H9OqRnQPBpVGAKSN+BGUdGiLCpV0NnU3Op5ChanNUxoh2mu8CKRyvL4MFaKDQkyVG4NrYxKXyvmJ74qQUsoavQM7LHPEeozG3sUilYTEjUaWKmr765Rk/F0fQY2ttTRs0qQpVXPQMPFxv7hgqapdPajYC2BGvNAXf7NFPtl
 xMO1L9yD
 xHs/sQ6a8Utn5P74RYo28sUGl2jo7ZeoSMI6R2+ZtFJIAaBgIhHWeaHIZzFoZMVzfoHMcm/PzbgyYGwkrB1v2Ut2l4Ym3EsISwqbPaQpdLrvoSFKaFhsr2zXjnPz5LjVb98elWWkvQfTHKV4g+reKYmkMgrViekeChbRhnFUvoDX0HbbIviNwFNB8jeKqu/zDL0lJMcwZw2FcrJPYaStmJba0RmooBihYxsmKNkDoyJug9ipPR3iwfDjkP1xQtXFw7pgKYoLS0mMxDNSV8Mt0OUWhc9VEqVmxduiuUFVv8VaMK+WVuL7pJMKWoUXbNvPRS7t7pdsFNsapxkXwrbmReS2hage3u/oamhvkv8TgbMVlYqiXDFxQfu5N+rdjPdqSz3fP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Jun 2026 11:57:46 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> This patch series introduces per-file-descriptor filtering capabilities to the
> page_owner feature.

Thanks.  Ye Liu has been working on page_owner recently
(https://lore.kernel.org/20260623065234.31866-2-ye.liu@linux.dev
https://lore.kernel.org/20260625014708.87386-1-ye.liu@linux.dev), so
perhaps he can help review these changes?

Sashiko found a few things to ask about:
	https://sashiko.dev/#/patchset/20260618035750.3724613-1-zhen.ni@easystack.cn


