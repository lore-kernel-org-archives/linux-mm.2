Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1242CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 14:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EE2F6B0088; Thu, 28 May 2026 10:17:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09EA06B008A; Thu, 28 May 2026 10:17:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6566B0092; Thu, 28 May 2026 10:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF7B26B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:17:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84F6C1A0892
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:17:28 +0000 (UTC)
X-FDA: 84817031376.28.FBAAB02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id CA02B40013
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:17:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cEan6pKT;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779977846; a=rsa-sha256;
	cv=none;
	b=jWQdhnfXgfho5FI+ouzR5f9b3AMtlmil/aKG3jbIkBSZiBcSlJqDrVRuWFWNqRI+wydM4U
	7yH8HgFKntVssTjumYjV+EoPs8ZyXcu9/FbmumCDv1CRcUh63pN4gLVF2cGOnDGZGOgwni
	QwNlfglhKpnRjX7zAnrOQnmC2pN+vtc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cEan6pKT;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779977846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDZzB76imM/ZyTMHaFDecVIOSjwi40sCkc2kKFTlUbM=;
	b=jh23MRYMtITusL5/aN+uaj1iFT01tsWzWOH2fUPXzLKgVzNpFUjqvYcCFNx0SotxQxwIjE
	sWXRTvHgjO4GvC//IYAfznXkXeDVt/eDQ3iJbKLsppxccL2Q1Kt3r1ev6NHlMvJg3OXffA
	rsxEdF6odUGKr1F2TWV014xfLo1Svfg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE9F3402B0;
	Thu, 28 May 2026 14:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906DD1F000E9;
	Thu, 28 May 2026 14:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779977845;
	bh=CDZzB76imM/ZyTMHaFDecVIOSjwi40sCkc2kKFTlUbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEan6pKTVEyYv/2jgbMmSn+yoVd9ZbqtgdScRIZ1HCpcGSMtYDCTuHudDHp/bHRge
	 aUYIYUUd0HfXkKWaYFkhqKSPVdUWgy+Pkr/FptqtAwNZrZHNm0/TAslcF6wUQwlyuq
	 SyRzj7qelEkEsnpSdlnXJpLNohpmi/MaOrVJYSVVuaBB5XrTyUVCNJcj1ADXvEj2c/
	 Vn9X1tykdcbaeo5noSJ9gz0OR3Dl0W8Zpj+1hhMUBLBDWiVyWcrxOw+z/yvIMZGGno
	 WfF55DTaiyni/oaqkrd5zLw748ncTOBb/oc9YckuGLaqHmMsD3BelL8yNHvCisn2Dy
	 y/+NyG+lxqsCg==
From: SeongJae Park <sj@kernel.org>
To: niecheng <niecheng1@uniontech.com>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com
Subject: Re: [PATCH 1/2] selftests/damon: fix DamosFilter memcg_path assignment
Date: Thu, 28 May 2026 07:17:17 -0700
Message-ID: <20260528141718.153376-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <9B7A70233DF773F5+20260528081039.1192194-2-niecheng1@uniontech.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CA02B40013
X-Stat-Signature: ndgqofjqxnxna6qiqtzrp9ysszibm7m4
X-HE-Tag: 1779977846-5108
X-HE-Meta: U2FsdGVkX1+9bJKxNRantH64R8tmxDeLRe0HbNDglDf4KM2e4dcR5z1Y+g88a8eqbXdkQZPNnu9txYzAxeQJ4nlp3kcURThhhymZ6DSn5e4CxVGoAylo/Y5e1qVWO7ctVVra9c46ItAH6zQYUM+1WSboM7AH4dgHoxUktfyBAzpNKDQvmRk6Zf27ATOHC4erOHTm8ORcu8hrnMaMfQtNLPpCzzeJQSv/TC0zheUNu2arMr5DaOFn5riNzKnk/7MHEOwqmZqgkq0imsC/hAxH7wut3RpdUJ5OJzuKVDT/DxzTewPRUlTVh1QfSyx4KcvyJZpWsAbBr8kzGtJ7wCBgTIAKlRVH1ltWfN1JtmoNkIZNzsWJaXSnCLwXIsJqlPSJI5xdvJogq0Ds1PgAoTJIEfy0to87usVsJS5TJL9GU28Cyii/ImNPMWYgS3nCWozSD6hK7w66Mm4qZxo+kfFHPJlz6Hpfz0diUOTjm5LToJYU5jjFtHcYgqFFrDpUIz5OPoznpDnJckdj27mdKoIEQzlSCeJcRNoLRz24s3FogbOHx5zNI4l8rZXFyfQ7vPL6+h5i9CyM7EL7IhtQA2sXdy5L79rGn/ux9WbOAim3LEdrbpPcVsXGoDKllKNcLmT601ly6SAYEC+TGidpkpjw+gw8rhxw/GyulgTE1GQbhFhwrwmE15PyYRTZjNYH2cZIgy8zeI514PRlcP6CYpuJC3TzgWOwSiA26mDzy8y5ATdg3lXlnZPJbMeFqf0oNqlodrpvRV9Sc8Ek2MUtJje+4luXeXOErGaixmHAlhlvQpwIeZJsUpPE3X8jTx7yNo9Uluohd5n2uiJyOdvnou+wo8ed2TIoqASlE0DcdHJqwt/v4RNBia3Ig4fgfnferFTVmBZq9o8lgT5Nt9iH7/LKTT4YmBcE7I3+GaA2eUoAXXhfWmvYWCOzTyM6PbGX94+ZVXdVTSJbORY6WQWZmeP
 3Du6peYq
 0JvKJmK9eqJbCjp2aZKtTXTZlBARhwvsVs3dy2hNJ6yScHaJlHHFJOtBp0luTXD+rGBfuKQQVQ3f4E4tE6E9/LnHUgTQiNGpZ0fMv2fVT7ybUKLFQJ3ek0V2mnoCRLP2IUMsyFizbOZIYCFV3/VLbdztttQdgtaONKalFUMZpzSEeC3yrMto/EfL1WUAy3MsKaG2bYzt5X/Crpau3jqWN+GPDotX4fJKJKWVEDTq9HMcPvGkX2EV34Gf5zC/FpzUx84B++ReWpEfwXRLYyXyxo7Ki0RRO8KjMoIHFAzW4VB45itKVN7j6GcOlkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello nicheng,


Could you please update the subject to 'selftets/ddamon/_damon_sysfs.py'?

On Thu, 28 May 2026 16:10:38 +0800 niecheng <niecheng1@uniontech.com> wrote:

> DamosFilter stores memcg_path for sysfs staging, but the constructor
> assigns it with a trailing comma and therefore turns it into a tuple.

Nice catch!

> 
> Fix the assignment so memcg_path is stored as the intended string.
> This makes memcg filter staging and follow-up validation use the
> written path correctly.
> 
> Signed-off-by: niecheng <niecheng1@uniontech.com>

From the git log, I found it seems you also use 'Cheng Nie' as your name.  Are
you intentionally use 'niecheng' as your identity?  We disallow anonymous but
allow using known identity, so I'm just checking if this is an unintended
mistake.  Some of us (mm community) prefer real name, though.

> ---
>  tools/testing/selftests/damon/_damon_sysfs.py | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
> index 2b4df655d9fd..022f0d392204 100644
> --- a/tools/testing/selftests/damon/_damon_sysfs.py
> +++ b/tools/testing/selftests/damon/_damon_sysfs.py
> @@ -254,7 +254,7 @@ class DamosFilter:
>          self.type_ = type_
>          self.matching = matching
>          self.allow = allow
> -        self.memcg_path = memcg_path,
> +        self.memcg_path = memcg_path
>          self.addr_start = addr_start
>          self.addr_end = addr_end
>          self.target_idx = target_idx
> -- 
> 2.51.0


The change looks good!


Thanks,
SJ

