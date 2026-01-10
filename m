Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C1A9D277CA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 01:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742B86B0088; Fri,  9 Jan 2026 20:16:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71A846B0089; Fri,  9 Jan 2026 20:16:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647C96B008A; Fri,  9 Jan 2026 20:16:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 521056B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:16:53 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B749413C574
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:16:52 +0000 (UTC)
X-FDA: 84314289864.25.3E16CA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0CFD618000C
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:16:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZsyTwe/z";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768007811; a=rsa-sha256;
	cv=none;
	b=s/KmB1cMPkN9pgnaSZ8Agcy8tq/57cYIhYd/RF3cPAjF8b+7P6c2B8bwZ7faovv58aFlGL
	SgII/s1NQqciSe6sa5cQFaDHONUPeJH/7NKhQoY5fHNpKLQzCGLKrzpw0OV6t2ImGKJROG
	GPLNrTFBzAUJlt36S4meNsmeNpvcJjU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZsyTwe/z";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768007811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNwrfv93yNM5Mf+/QZ5yYprIsysA3544XDewzLBkcpU=;
	b=347zy7/NjUIrOmiuq3ki6QvGesQQVNFv1iQ2Bv9JDQVAARzephW64o9FKS8G4i01H9kRKx
	G//BjFBn1Xn/pWReX4YV/Y2I8UXtxfTS00lLHKHGohDDHyd8l8QWIusDVUbEH6B5+zAdcZ
	hLNuU3lLgsu5CXc8OZdNFQmNDTeOjX0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CEC2E43A13;
	Sat, 10 Jan 2026 01:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE73C4CEF1;
	Sat, 10 Jan 2026 01:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768007809;
	bh=1yqAuwPlUfRbkywsOHYeC8zQzYiMnx9T0dqkU24ak7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsyTwe/zSpke6a9XZ6AKLa6ZQ3ADLRwY8NzsYMoo9vtCM3McMX3RZNQR+YG/YJvjR
	 +Kojk+cRQFG/GZcRFeJ3+4dRApBG4Q9p1BQWOcS0lpfCb5Kv8bB2c/GXgr+TXFa+R6
	 Ho0hzcKyk6cAA/6uifqZ0/bE/wR/EMwh98DG/nk3KFRkzUc5JJQ1uvFFsZ9Ybfs9fB
	 PBXZi2e60iSAjHuQryLCZ025oRuwIf7gLFgOHEwVxAcMyC+QpDFzMfI6GZOap9rXZ7
	 pwCARKTqLLedq/a7gA6X06GdaXr9Kr9bAEaSMNC55mAdfRzhfk5OX+QW21X87BYV2u
	 SZbtvQNv34LXg==
From: SeongJae Park <sj@kernel.org>
To: Sun Jian <sun.jian.kdev@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: ksm_tests: skip when not run as root
Date: Fri,  9 Jan 2026 17:16:40 -0800
Message-ID: <20260110011641.81278-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109094313.52307-1-sun.jian.kdev@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: czgquc94q6z89dw71cajughhuhh38ze5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0CFD618000C
X-HE-Tag: 1768007810-961538
X-HE-Meta: U2FsdGVkX19G/RyZDV9JahdGsczSbjw18WLU3ulTVaVEr4tYHLQkJ1c9hkCFBTNqK23x7y/yTBBcqilZUAlPMRxeUAX1Mr8AQL1sC0X613inJpjdu8/DSu8DSPuT36T7KJ2OV1/dfle2K75KDIQ6SqnX2kFlXyidB1+41t4hmxm1dqxlUU/6NVgX+5UF74FgnhsfrYRNs3a8YYn4Sb4hH4WcD7BEpB8/jM/EVrYIPuhoWioemEimojWIiAcrqXLxOGJFdge6Tt9M7eA5LN2UayToUxiqYwyDYmHk+fNKrZPcNn11YKQgQXq/71biUSqoZ5NSWnrh+fG6RKLDDS+ktNJM1UHrXrzhX66GAbAkHijFpTSsxfe1hDljYRp7JMrg4s0Vwot3tLK6ySysJk8CCPhrPAq5HzfS33zMxjbdrwWRA+NmaMj8DJ3qPICdkHggSrhrfFBIoY5aIpoBPw22vVRkDPb+RbirSPQVmciBACICAPiL4v5sgL2lA3tgqibXS5A0wp2WpQ/RPgD2f0UiflYWFkFtrGSDh4VBAPliKzf28kWDpHqyoBN5Z17QB9hqOdzHVjm6iA/k1mhtC0OMA/EUQ/r9cj3TRYCTO2rplZzIKB8jBb2EJEikd03hGHbKKdf1ileQon9wX1aaVbjwKECNaD6F+l9Q+sA3zvksQwXxARL+DoKYIVb/fvON3Nb4dCEacUCTAEVhYjccVcCAluWpynsR5qqNbDg2lLB9/UaOxeLpi8UlgHw+i/1N9xt8+0dvvtPnV/oyEENa8/3MEb+6f6qtiq5BINNAZDp4K6I7+WcryoXwg3DW/IhFTWleTQmSGnp9N8E4ALwU4DLs/75VOUR/3IupyYn1c9ybKhG2m6N4b1Y8+HhAC4Q69yiiSDSYK5IMEBMjxCwIEtVC32fVby3a/qw1pslPH5U0e5q5WUfNT/6+sJqriSvxQnHLdhwqs6hPWA47OkdWIr8
 U/WkAKqX
 zSJ5amI+lZaOEDmfO1gFijc7wOnD0L/B90ncCOgkqiOdArFYmY/qGKqUJnCYEJHt9+Apc8re3x4kKJNy1XSCyyRkx9bQnc3eErbc9jYJwalCjM2jM0nHxqfdHcFTgQBTdwRE+hw60fv3q4GLH/uRrEw6i10FNedLzvVL44e4yANXhQ1rLLK0eeCD8hs0tPrematzyAMYphdMy4dd5Xe8h/NQhz0p7upI5+bff+3T8PJ9lUIrkQLOezK1DHAihMwRJcPdGu2TL8HjYnZmXBLXRtFsoxSIa/oaljv10+LJt9BQZ5t8hNmWrpaq4Yb8q60hAtF0fAKmr0N9ul/QgCjqwyzhL8zBsr4ADmegx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  9 Jan 2026 17:43:13 +0800 Sun Jian <sun.jian.kdev@gmail.com> wrote:

> ksm_tests writes KSM sysfs knobs under /sys/kernel/mm/ksm, which requires
> root privileges. When run unprivileged, it fails with permission errors
> and reports FAIL, which is misleading.
> 
> Skip the test early when not run as root to avoid false failures.
> 
> Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
> ---
>  tools/testing/selftests/mm/ksm_tests.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
> index a0b48b839d54..c22cd9c61711 100644
> --- a/tools/testing/selftests/mm/ksm_tests.c
> +++ b/tools/testing/selftests/mm/ksm_tests.c
> @@ -766,6 +766,11 @@ int main(int argc, char *argv[])
>  	bool merge_across_nodes = KSM_MERGE_ACROSS_NODES_DEFAULT;
>  	long size_MB = 0;
>  
> +	if (geteuid() != 0) {
> +		printf("# SKIP ksm_tests requires root privileges\n");
> +		return KSFT_SKIP;

What about using ksft_exit_skip() instead, like compaction_test.c does?


Thanks,
SJ

[...]

