Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BABB7C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 03:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A593C6B008A; Thu,  9 Jul 2026 23:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09636B008C; Thu,  9 Jul 2026 23:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FC16B0092; Thu,  9 Jul 2026 23:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5FD6B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:13:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0993A0292
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:13:05 +0000 (UTC)
X-FDA: 84971395530.16.2ECFDEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 315FE4000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:13:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ApP0SeYW;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783653184;
	b=tekIzGna+G9AsOdprFQmtO9w4iNpYqOy5wt3CelJi95vWvCPk+lkJBZElihAFgLzySOntd
	MgZ9y8ZYS3cSW9aWEfB8oW/Nc4vGCSAKX+mnN0dT3/WTNWiv/1EKhA7n2CRla60NWpS1Nv
	F4Ckbgrn0LAdZMepuiEBqw6Ae+XxvA8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ApP0SeYW;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783653184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbHaVsaTwyP/6PLrtHwV2B05KJtv8UaJpsbVL8wi2eA=;
	b=YORfrSyU71wqIHPMxhrwDYhAfAU7JmBpQff0NA0UsOlBfv3H9Jq3gVSjQggkUDSqECq76h
	As64yp+kfZM4EjEWCYsjULkSfZOfbqRPsksw/IFHct1Y/oU8NVgu0KeZD6eNs8pYud8S6H
	XcQT7WV9S91Ve5MlwEWxBqV3GvIqwP0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 856636001A;
	Fri, 10 Jul 2026 03:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E841F000E9;
	Fri, 10 Jul 2026 03:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783653183;
	bh=zbHaVsaTwyP/6PLrtHwV2B05KJtv8UaJpsbVL8wi2eA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ApP0SeYWgK/fb+hUNWApFldDRqoVoZWnQdYp+98Eoot66+GQ/gZq0cnbbDL/XwvgE
	 V3W1g9IjjTYwLb3QcQeVGTy5qEjGi6EvCW676uRYlp4bbbITuIEuQ0F1C5S1YAO6ej
	 1wByCOxQX/KIo/QAyip+SmkItJm8arBhWSgt7ZL0=
Date: Thu, 9 Jul 2026 20:13:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: leitao@debian.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: kmemleak: confirm suspected leaks with a second
 scan
Message-Id: <20260709201302.fb87e3bc6b2822c56856e455@linux-foundation.org>
In-Reply-To: <20260709173347.689607-1-catalin.marinas@arm.com>
References: <20260709173347.689607-1-catalin.marinas@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 315FE4000D
X-Stat-Signature: cob6hjz4zoyf8exhsb7hu3d8nuf8hkmx
X-HE-Tag: 1783653184-718468
X-HE-Meta: U2FsdGVkX1/cnld+awtzCmwEemPdy0ga/hJxuAkKq5AyHhnDo43rALYI+DPrCpoK7oSl2b1o5I27xKsDonxQMNMoIaPTC2FTRPNOPah5qbiImBOQFg6+SqRw2AZrJVQkwCuxeiD5qUux0iAEyZs6q0lHt1CUsZkUvXH42IvQurvHtEwdArgpgyflKF311QR/PVdcdy9K4wSV0DBwG9GzmkDOiELO/Uu1Um9O25++ldvBBB/SFf/CMD7JVyegpOeE8h7MCEPa5qPAufkPuSbV6ZGeKVGvobGZi81pjDTQ1u1NQFi/4vZN23Jv3Q+HkrEYfSmvEz6VUglrSfdwIwN62pR41nkXWT8dKRBesmyOaOkkdSTj0HUkPjd1PbldZMT5mRzfhH8ZtdaAf6Mtxaj32tK4tDFK+d+8GvKSZzWvPaZ8/XkU3mJDbsrJeZe/hyiILOK5dnAE91B/4wrS059i8zRXIRaLZ0e560x87kTUKQr3pawmexnBrjhb6KSvZyoM/xS28IV+gxEhEQiNk2tHB3O29HpVAp2+gvrCBq3rj4YTHVRVFAiEZJDm7eyQ+XYhbMvOta6uOOZYQxhv3eAWaZkItw1+zVQxT38LhZdiU9lAy0ukqUtOdWd3Avh/fYUiNvu0cgemfeeEtryL64jyCu6LrpP7PKh6j0NKISarWyiFg+aFYHERIT8g7x1xBvwrQ2c8BNUPkMpRHFoWteoX5JGQrsyzB7GsEnZApIOxq27RBaX9AytOvnEcElbsdBQQRXLfGwM44hB4o8kII9IPnez74YmitNWr3boQYmbKTtvCPxiH4wT/lM6OpQPiCeCJpEvzlWzu7+Md9jo1+HnVw9fnv+GL6Rg8eYeBOVJrnKUb2y1fB0Ql0VhdYltDs365d2rqCNbMAKxDi063WG1exuzJFv1GY9FjSCQIV8BprZ/myLmN2Ev6kt2abyrzUw/qXjFgDVh49IF2vgKiJMU
 cyZb4nH2
 ZHOWkv7SsddQKO9u9ws28cloUzsxvtPsX0mLSiDOagwAO2tf5YdsEEtDSQi9LdNqndStE85giVraIcpzpUr0N3EHVphQ7VQCZ66CIvqO5P1LlzBBNG3oI8BRgGSKMT5dHEPDESq3JuRjTeYxL3/odJKgiwGaMM6sR5L8QCvy6D3DSgoCsfWOm3tyzSaLtTZh7JuHWwZkJ32wnmwKw6acCSea82LAoZ+cMBYwedskbczdLtpfff9zRHUNy9U+KOWn7ttI+fB5E9Mo3bd339+ZXQR0Z9TzZuYznE/lzUALRlL9l6N9Q3ClKFF2T3yy1iq4wDpblEPxSr3RmnIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Jul 2026 18:24:47 +0100 Catalin Marinas <catalin.marinas@arm.com> wrote:

> The kmemleak marking phase is not atomic. While the object graph is
> traversed, the kernel can modify pointers, free objects or allocate new
> ones. If a reference to an object is moved from one location to another,
> kmemleak scanning may miss it. We have explicit annotations like
> kmemleak_transient_leak() but identifying and maintaining them is not
> trivial.
> 
> Given that such transient leaks are short-lived, rather than just
> reporting such objects as leaks, do another scan to confirm the
> suspected objects. If no new leaks are found during the first scan, skip
> the confirmation one.

All sort of build errors here due to other changes which are queued in
mm.git.

> BTW, I'll be away from Saturday for three weeks. I may reply
> occasionally but won't be able to test anything.

Have a great time - we'll be here when you get back.

