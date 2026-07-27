Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03502C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 23:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80CDE6B007B; Mon, 27 Jul 2026 19:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD136B0088; Mon, 27 Jul 2026 19:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ACE56B008A; Mon, 27 Jul 2026 19:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 471316B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:59:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5C2016025E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:59:32 +0000 (UTC)
X-FDA: 85036226184.30.59FEFB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0BD7B20006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:59:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j7CVbejW;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785196771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CflxV47qfVfUx0JJR1VtbTQOpBhDDaq8i8LFF5znoYg=;
	b=tjAqy7dq9wro03mnXOIH8EQf8bFjepmKLtkSmYiVZIEg6Zg1OZ+ZQSmTIyKf/NSybKzcVD
	aJHsYk/jwUGonaKQjyJbGfzc7MAc2TIdGUd4XCgnTohIqAprUNhRxiqrp92rftvrA2CXMy
	RRDlKT0YBI1+/+i8culWHOrVm5hm9MQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785196771;
	b=bQz4ltDQRGLzfehRviKplUMspSeAw/q4fFr9anWO7N0c4d7k4c7IqICSArAYOBHVomjv4q
	4CULfQijBJ1WuVvcM6keiFcLw1N5HAValmHDpgWb39xJzh9Mg+4U+16FW3dzEjuHH9FBNT
	iUcVjU8/+Ypl3ElD8PjlzosQGv296L4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j7CVbejW;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D8D5E434FC;
	Mon, 27 Jul 2026 23:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F031F000E9;
	Mon, 27 Jul 2026 23:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785196769;
	bh=CflxV47qfVfUx0JJR1VtbTQOpBhDDaq8i8LFF5znoYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7CVbejWrjp2jr+HvQnk4xenwKqlsl0ldDmXYG87J0qTxQu5UJuaBmrxz58dSHjJd
	 3ybZDF1mgWEnAUl3OjButj8RpXIixKfh+jSJiYxviGVwTtLqfpLeju19VTmJUIeytv
	 mj5Bf1yTzjYQUDX2LKHOwt0Kt3W0if5Fq8rh+ZOfceIbCRnikmZHg3G3La+aFaj2zs
	 y2VlcPEw/mJGYZLWgP/wZTSKJBGgCT61l1LAtWmjLjqucSVMa002t9US2Ad8uxMzO3
	 3INU7qQhv7J8ZONvMYuvFI19a9JK0eMB6Dk/gsW5WHnp0L/PUDWgHhvctVx4hUZe/V
	 4hpxF0KTlx1Dw==
From: SJ Park <sj@kernel.org>
To: pratmal@google.com
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	anshuman.khandual@arm.com,
	gthelen@google.com,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_reporting: Add page_reporting_delay_ms module parameter
Date: Mon, 27 Jul 2026 16:59:25 -0700
Message-ID: <20260727235925.93406-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727230545.262579-1-pratmal@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0BD7B20006
X-Stat-Signature: abmkeyi7as4pghcmigx4863wezwh39wq
X-HE-Tag: 1785196770-422894
X-HE-Meta: U2FsdGVkX18tWzJ7WX7aE8clMtej8cqAw2DOECmK6CYBCueUa6I4l4dgDHzCPH6l+stcSyZKl7ZPNM+JFQAQcCr71VIAIMpn/u+VfihZLQiG+H0ZsMj/ytwUip7h0mSztoghwjQC7XVFkOYWZEIJdsFW+NhB6s7cG5yGnjxNszdl41Opz2V7CCabIUq8ZfX5j+4Y5qlKwWdDpsruf10UnSZISxglZ3PrcVqR+kN9Sd3j28iJancy6aFYtrbmtWszshZpt7sOY5rUSAYXZ9o8ZL4ZosZZUhncbSWMS2HKF9wtJyXGymCm+stUTtb3vTCLokOd+I3g/1AlZ+VqH1Wv6P/VM8RxsknSC34QREp3aoh8wsrghEVj6hxb0v9rzjY9nScF8/UUrP8JYrOjtmXmDEYPAztrYp3CWLzDj8dWtbCOyBv7yuv6LDVl1Vzb9TOcfMmQ+rCb/KVNqpo7WSgZTt3nMd4sfpmobApuxbkmGDxHed2kRUAUBkaINHV3YluMOrZt0UNCG6zDzZDVEOQdkggeiiXbvOBpGhy16zWlBFq3yCe0Vp1RSVbAweP3bkpnAo2l3v+mgCC0iMljZUTd3uJ054Mho0KSI3jQ9u5Bfv9CZI3IqPi6VYonfp9qaTOGg1o7Vsq1vIPDLit9ivYGcOns9A0wUpD1B20Nzjd6byvxTwau+Y+qWBcD4ghOLrT2vmnbW49+7JLPNm1WUB+bCfdrnFgVsNz6MJXpchAm8AIc+UMDwFNuch6FhPWZaHDnJimxc5CEy76MZkH9z0AhreVRBZrq+wkBnC+TKN0JjC7CyW0yddzhTJUyfpQDPtC+46pEMz4468XDrRGWggjbBblOfeFS57452x1c7PodeGoAO/9EIPNl3BRR7sq3mbBI+NOygywgmmi6D/1mgOohAEdXuDrjcJRjQX5u5AWpJk1ezznGJyHJfJqM9vITDBEE2eMJWz7rCL/0hS7WkuK
 6WLoXh+7
 vwPVDIDdNTOlsRLfZTULK6MCMKS5msf3wyKL+eVDNzcYOb4RnFsT9o3JvN/cmkicI/niHkXVLoDXBz23leHX06tmeNy8LFFCrw4rrpzOOgkSkASWoz1GrEJPjJoOcc3fGFFCKti1H9I+pC2LeOq2iFLEchn26QDghempSKRDpQsMhmE0F6NLLpBXrt/XwZfILTYr/7DDcsBSUOR+x7+mawz7UmqRjqRKdthAMg9oOWxi/P84g48ERqLxa/6Jny2l3gtsmifPu87vjy2l+iXJ0DjilD0mBcIqNTdlg5yait0w4ybzHepHLUSHFCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 23:05:45 +0000 pratmal@google.com wrote:

> From: Pratyush Mallick <pratmal@google.com>
> 
> Currently, the free page reporting uses a hardcoded delay of
> (2 HZ) between reporting intervals. While this is a reasonable
> default, it lacks the flexibility to adapt to varying guest workloads.
> 
> A low delay allows aggressive memory reclamation, returning unused
> pages to the host as quickly as possible. However, during spiky
> allocation/free churn, this immediate reporting can lead to a severe
> performance penalty (nested page faults) as the guest re-allocates memory
> that the host has just unmapped. In these scenarios, there is benefit
> from increasing the delay to batch free pages over a longer window,
> absorbing the churn without hypercall and re-fault overhead.
> 
> This patch exposes the delay as a module parameter:
> /sys/module/page_reporting/parameters/page_reporting_delay_ms, measured
> in milliseconds and defaults to 2000ms.

Makes sense to me.

> 
> Signed-off-by: Pratyush Mallick <pratmal@google.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

