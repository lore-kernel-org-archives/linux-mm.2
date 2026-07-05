Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE955C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 16:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802646B00A2; Sun,  5 Jul 2026 12:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B37F6B00A3; Sun,  5 Jul 2026 12:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2026B00A4; Sun,  5 Jul 2026 12:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40C9D6B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:46:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A37E3167387
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:46:19 +0000 (UTC)
X-FDA: 84955300878.14.3310638
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 17DDF10000A
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:46:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUGvEzOQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783269978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FESRrFcEtdwNqKL1s9XBnIxVyPUQKtn6yOvnf578D+8=;
	b=rFudHtZbZliWEjGslZRxGLkBFlrxrB3FyYe0A5wg45ESAm1J5Hr3i0kC/cBCduHOq7xN1r
	AHLhYbdqBZvDbRHmDhoZvVH+VP/Ss7ZAuIxxLAXxgxJOl9SXLs9/rX1bg/uZ4S7twJ244e
	Ajf1PrSLk/U2Ii/ZvLyvGIx+XaVZ/6M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUGvEzOQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783269978;
	b=T6obO5Z7eST8i3EqFADLT/Z99Yh25x//Fw0fH7pjBcnmIjuMQXVNVukhheYOdKIuG7hz/x
	xWcUrINKijsn1ozY6A9o8v8K4arEMHZOvEAWfX04Ko2ggC/nKmwv+MVewsc2eNlbr3Cnbt
	RrMpZxPuPeLKWTEFfa+0taHuxATwpFg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 114A843930;
	Sun,  5 Jul 2026 16:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA641F000E9;
	Sun,  5 Jul 2026 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783269976;
	bh=FESRrFcEtdwNqKL1s9XBnIxVyPUQKtn6yOvnf578D+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kUGvEzOQVo4/k4asBm1+I2+tQ9SWJ3LTarop3/OlvP702vTOm6szEP3SJvZToZRVP
	 bisQ8f/T8gKqGLgD89ZoVl9j9nVfyhhRfo/6nmlDJYo0sFNFt9YGRzjSc7NW1uIMES
	 jfCByLy8QFfLuLNelNgPZzLu7H9zZvSJYaOC3WasPrEOYJ65REy0f10yLmPX/MiHeT
	 vCOQxXK/01G+2OVkLAJTLnUdrxouSW+luhuDBnBJdfBkTEWzo602htJw/LCsYi0CUE
	 yrQobQ6AO7Hp0FYraj4PNKCfs8sEjoZkH0IhxC8K76gamRU2hU7iVW1dFMIRv0+cBa
	 0R2t8ZtQkEFPA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/8] mm/damon: validate all parameters in the core
Date: Sun,  5 Jul 2026 09:46:08 -0700
Message-ID: <20260705164609.101994-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705155600.96555-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 17DDF10000A
X-Stat-Signature: egx9tbzihkrnemd6howakxzipd1bpor6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783269977-943756
X-HE-Meta: U2FsdGVkX1/YHD1yfQEafaQ/l3n86bOlvsv9q+6FtZDE9sEdzEkorr1ZECl8DpYQSZ0ALeHy6IzFreZK6QTDTtCXfeI4G+5/7HSBNRQ386K4vnDpI+nYv12uYPhN3/445aSARLH99CtBru6O/CRpZKpd0QLTe1MAozwIm5wWRs6z4GYSiZHSB2+0QoHZRmBr1W7eDvifyY0T49MoRADXb4zM9Ap2vMpdhhwstxZEY6NbCsn8kiPJ0pcCdrN6HQdpBq80DLiL05h88J6KaS4SxrD3nCnjrrMkLv9/y980GpS0shyBhfHiYwx/7Vwu8JK006qpbrTzsmZYyRw5OhiTjwdf7QyTt2YtYy+dZUbt/KRVOui+PUwZ/pqlU6WBKtdt6ZGy0VUyc2egBLq8UTEvUJkHishoePPpnWln2I02zgOSGDtEcehZzCRo0aTthQGT19ETEg76/Wd+xV2DaHfE4CIsWZfNucZZpdTAvtuyOmErq5J9JeKVRrAhMeiYQNfy6cJuInem9aDSFnAsnk4bQucWzAIGdMz8HOAP1vuJyQoLJtVrhksNi7gQtgAfhtdNHyx4DsNLqGRi764TcEqmd1aLrky/PttR5U/t1PNk50WLe+vKQiL0ssuNxqSvBPA8DlL0TtyYXKo6Q08iaY8uxQynhS0VxJsEthKA7xz/TR65s5mIKal5//lBC1COgVito+kzS9v1jRLvJPDrKZeC+eOdsroFXRDyOg5CE8jxXXrieTXC3eIzBRti+JldtUXs149moUwHGiES59k2RSxmaOOOPnNM7lH+fAu3f2xaWA4SmIFjanVY8bN8RFl09a44Fr+Ocxd/gWaKu6qycSbnVcc0Nx+a79QapYtQvKm3nezAiIUphXua2z8pY9sa1icz7SHbJR+A976vS2XLjXl4dhaMeTSdw5RGXbd97q9dyEs/MLUgHGUH1lkpae/l7ctwJXsKWvRAeTAJtIUULLL
 pkWK2whV
 5IgAlhVbKc0kK+wvT1pvbwuDI9nOwEKg5a9S6RwoYElrHctOntEV2yJSVmo5fF9kUBOg/iBhcMeaUdTFoKA8pLiQsr1hSpy8Hy1a5+AY+mHYxj09sqyWV+jkDZM0flkEFRvQJsnmbLUSIkVQEP34HkWJfr2MJvoKRu+Qztl5nhVCSj5iWwIZMropW3RWNm1+6o006deJD/f6Sj7XDswTlbSmtqLv1lO7+CNE9naeD5PuwNAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  5 Jul 2026 08:55:51 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON has a number of parameters.  Some of the parameters are validated
> by DAMON, while some are validated by DAMON API callers.  Each caller
> has their own set of parameters that are exposed to users.  Hence each
> caller has their own ways to do the validation.  There is no clear lines
> for the responsibilities.  It is confusing and easy to make mistakes at
> validations.  Actually we found a few bugs in the class.
> 
> Define DAMON core as the place to do all the validations and implement
> those.  damon_set_regions(), damon_start() and damon_commit_ctx() are
> the three main DAMON core API functions for setup of DAMON parameters.
> Make the three functions to do safe and holistic parameter checks.  The
> first one is already providing the validation, so changes are only for
> the last two functions.
> 
> This might add unnecessary validations for some use cases.  The overhead
> should be negligible as parameters update is expected to only rarely
> happen.  It reduces the number of places to check and fix for bugs of
> the class from all callers to the single component.  The maintenance
> efficiency gain is obvious.
> 
> Further cleanup documents and caller code.  Make the lines of validation
> duties clearer.  Remove validations that are no more needed owing to the
> core validations.

Sashiko found a few things but those are not real issues in my opinion.  Please
read my replies to Sashiko comments on DAMON mailing list thread [1].

DAMON mailing list is opted in to Sashiko finding mail delivery to the author
and the mailing list.  I record my opinions to those by replying to the thread.  
Hence you can show the detailed opinions from DAMON mailing list thread.

[1] https://lore.kernel.org/damon/20260705155600.96555-1-sj@kernel.org/


Thanks,
SJ

[...]

