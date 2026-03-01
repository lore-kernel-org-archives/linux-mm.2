Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFBF2FD0058
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 16:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86B46B0088; Sun,  1 Mar 2026 11:31:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26A06B0089; Sun,  1 Mar 2026 11:31:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966B46B008A; Sun,  1 Mar 2026 11:31:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 852C36B0088
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 11:31:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F392DBA154
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 16:31:26 +0000 (UTC)
X-FDA: 84498034572.03.FCC3C1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 622641C0006
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 16:31:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oiT1p+0r;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772382685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CUzhzhI7kXEDqdwgVxdYfcxQ4jryfr0+zhRuia5eFQ=;
	b=AheHInO4y+mHGq+/RTzlVZ5YthvqNAHL6Ch5MSRKztAsPk7mnoJix5q+913AcsqYU7ZaOd
	vF3EBr27a2uRNfPpMm2Dr0oG4nijmYcAanMrrRFMp8H7t8SfLtBVsbZ3LEmV8F/zDb5iJa
	iF5hWNWboDMNv9oyNj15zRT3IW4Gpbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772382685; a=rsa-sha256;
	cv=none;
	b=GyJHg+7Ci9gnBJnN0id9RtynFlwAyniPaxs+vnRogX9192PYvJIqDXk7c4zrEMtJIUL2Ji
	fGmJEVkNtEwt3RsyjcSLywwlVgCEGtjipx6u59Bk+diDxzxaubwoNlyp/aVSz0In6TzwFX
	eGsXfMK80xnSoaiv0La7bB+p3WuXU8I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oiT1p+0r;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 428A6432A5;
	Sun,  1 Mar 2026 16:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D659C116C6;
	Sun,  1 Mar 2026 16:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772382684;
	bh=22aGZdkZxgr1mCxPhMwaGp7yN1QNCk/YN9RyhwQlTzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiT1p+0rswZ3TqaFfijT5eXhTCa6zXXaZN1Xfq9/TIqLQ+0Lg8uZDi5BjTrbjCPsB
	 YOCZLUm8321oCAKOnSXSnyXUDLx0HULdqO/i5U4PlI6OCZBI2Tm+09pQnxYmBdIy0c
	 rjmqjI1Ze1RBpJGRHfmacOIO9kspSPcITgWX9FTFvwQOePM1e9LnBOWF5pyRIk2CJR
	 NO9cVyapDCJQRKLk1KNeh/4f6LCdKPMkWGrx0vnuDRwdWchiT8P+xhyNzSVuchhant
	 BTZh2MNTkO7T8QCDUphwatMl1INqvcEibwsAw5ZGMiMynPeZpazR1UxJeu9a/qx/q+
	 CxuFwAuhVafGQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 01/10] mm/damon: add CONFIG_DAMON_DEBUG_SANITY
Date: Sun,  1 Mar 2026 08:31:20 -0800
Message-ID: <20260301163120.92436-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 622641C0006
X-Stat-Signature: b5ook4ngrjzya4hmhksr5dyhxn4stg8u
X-HE-Tag: 1772382685-484248
X-HE-Meta: U2FsdGVkX191XGdJWXG+GqTWecYSVHnKl6SCKRWjlrcsGdO5gkuHqhAZ+uDG/LGE9o2yzkHtvlqilXD0TbyNIMNkrwll/eaQUnR0nkVCI2mxzTCn6xMirSlJsfPkHfMqIltk1Tep752XwV5eCYpo0azbcAMW5BrbtUqpp900gVj+bnnbPUs2f5yL8Gj6yanRkZ0n9oLamCi4yrsLH0XZrwJQ5zS+nwsEQ+KLxOXK3lwTqdqgGuBxkWfMb+r1xU8tmHR6XiLvpPgqK5NmbYJdIvYg03eQ287BhCmn9ISAokPUcUuD5zpVv1tA2j8jt+HoiC/NTb7tZV020ft38QhWa5RTb9Zizqu4W1zPCpafIpiNrYAuI8MHvCNUVZbQ88HrFQ88PyMQob5FPkuKcavJXvFm2Y2NDf6bvnDMVmLe+HbKAoPQjDDlORUFjRlCwEZQaddP3QvMMoHPGJG+9k8hdVPi76ZKILJGF71lLov6IRfW13naQ4ubN94fgxOtVbpTzc/BN7Gl6vQA6UI8JMFGYbJTashkgPn/JcI0SXm2CFBNic5P1yww0PFwrY5TPptkpLdqnG4Pt+M2XU1lhBTKwjBAgqBd1i3tGPFSEAT/SKcaRhVepYEB5pBXGsD539JUETI7OCRfICQSuSxclEmPSoM2Su3teDO1IQITNdpulFeU1GkwIHliTildTxpO6JaIdqAs19MSfbzPXMnlJ3XFry9HGJmLfsg8WqfCNt1La4hxODlcERgWIG5TYHh4g3pr8PzULt8OWE60ze8tO/5gtVJexTyg1QpoRlx6u8SYoaY0C90KCK9vqpmXDr//zKTjhu9/L72k9J3Vlclsv0aYUuOa7oqROlcPckYSvQrPb89dqnKT7rEknN3bFiOFZ2Lso4nk+Pmw7QLWh4n+ck5+n6viOz8+BLMmgOOIjFuWsfOuZhh3zDZSkpN5v2xUIfcxuoFVtD+i1g/E8TWkXj8
 Gpo5uRzA
 foJOGtJD+qeML6wjdHvysAhv6cw8eNV5/i+0ZMMKhzZidAID/0KNeVTB41iAqSW+E5Z6+td+bFqGB58IiUac3KXkQa0HQXPfpFDdR7DYB0S8VhLBxeJu+IeL1h5QMFqwvWvsSiaEswZUkgjJ0hzG+N8jmQuZvMdjtBDXExVcp2oHLZe78vmQI2N9u6reRGE7NmPWXbRW8bWoNeaqvDq/xhqMWAslE7cfZ+PjWSZBeHesObwNCxoFVFI5e7/GCzSERT/OhK7M3elHvXw8XYtQmRqdGQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Feb 2026 11:36:18 -0800 SeongJae Park <sj@kernel.org> wrote:

> Add a new build config that will enable additional DAMON sanity checks.
> It is recommended to be enabled on only development and test setups,
> since it can impose additional overhead.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/Kconfig | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
> index 8c868f7035fce..413adbd8e4089 100644
> --- a/mm/damon/Kconfig
> +++ b/mm/damon/Kconfig
> @@ -12,6 +12,17 @@ config DAMON
>  	  See https://www.kernel.org/doc/html/latest/mm/damon/index.html for
>  	  more information.
>  
> +config DAMON_DEBUG_SANITY
> +	bool "Check sanity of DAMON code"
> +	depends on DAMON
> +	help
> +	  This enables additional DAMON debugging-purpose sanity checks in
> +	  DAMON code.  This can be useful for finding bugs, but impose
> +	  additional overhead.  This is therefore recommended to be enable on

I will s/enable/enabled/ above in the next spin.

> +	  only development and test setups.
> +
> +	  If unsure, say N.
> +
>  config DAMON_KUNIT_TEST
>  	bool "Test for damon" if !KUNIT_ALL_TESTS
>  	depends on DAMON && KUNIT=y
> -- 
> 2.47.3


Thanks,
SJ

