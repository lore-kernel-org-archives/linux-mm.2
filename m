Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A93DD25028
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 00:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA6956B008A; Sat, 10 Jan 2026 19:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B546F6B00A0; Sat, 10 Jan 2026 19:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55D76B00A1; Sat, 10 Jan 2026 19:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1C96B008A
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 19:37:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40ABE140317
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 00:37:08 +0000 (UTC)
X-FDA: 84317818536.13.967D125
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A6983180004
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 00:37:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VkHIdnuq;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768091826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ed77fT0jWqn7aNCaUtA/CjbWE3seiVpdrCE+vdQ4nG0=;
	b=W6JTS6c4rPnS2mkdbdvdtuRaL0PBjyRTKp1KpvAzTDODMvLQyQJpxWwMpk7HoZKUlo9VS/
	lQMwJYq6TUQA63adW92bUBj2ieeEnQqeWmOUNTWfg88BcUT3P+RWRd4RJTpLMp+/dFf+hk
	j/1X3Q3vRLi/FK4r/0KEKzKvV9qycpI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VkHIdnuq;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768091826; a=rsa-sha256;
	cv=none;
	b=4JB2t5poRUUEF+VDxxJaBIZR6+tbgkpcqHWMrCmwM5CAvEHsXXFU/gdrrXqshfx8jV0lE2
	QHzaQRmcgPgBSDRTNjYH3XrIZvqR1msiiyMQ8JYvJlnlapFgovIGrvsa0lxRG3tXroFe0x
	fqj6ZT30JC6vNdTmSvpjKKD+5nbfqZ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F011360010;
	Sun, 11 Jan 2026 00:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166B3C4CEF1;
	Sun, 11 Jan 2026 00:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768091825;
	bh=RP/QQUt3xOSF4p4BUNnPlwK6BDXZRjUEGy8pztaa+OM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VkHIdnuqbLB+mjbkjrPTaSTMAZDlBdV8QV5FamIkRBGy5iTcGOjTs6O+y5OxQne4v
	 dFr/obRcQ3BwaD8droZfw9DOzQUXclknXRiRFod0uOAlam2QhHqZw4QK5s/2DiyA+M
	 4V5MEJOh7e7MJXYxNQkxgVCRAUX+tA4a3EXdluuo=
Date: Sat, 10 Jan 2026 16:37:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sun Jian <sun.jian.kdev@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, SeongJae Park
 <sj@kernel.org>
Subject: Re: [PATCH] selftests/mm: ksm_tests: skip when not run as root
Message-Id: <20260110163704.7b5e1e10735113baa23f42ef@linux-foundation.org>
In-Reply-To: <20260109094313.52307-1-sun.jian.kdev@gmail.com>
References: <20260109094313.52307-1-sun.jian.kdev@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7utoj7poqe7xkkswa54djgj9ndjdahi7
X-Rspamd-Queue-Id: A6983180004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768091826-27730
X-HE-Meta: U2FsdGVkX1/lLbVrOgmYUwj2inAapFjIbSU+K+WKe082WiMgi7EsSB61Dfc4zeWrj+9bosVdNTm5X9wx/5X4jGdkuwNJV7W0B+U9RUUz5cmw1kRHOyrJYvdi1qRfBuB+i6mBRvxeTk1pZ/CMeEZ2LkfXd5w9eiEwGuy4h9cr4lFuyQbFVjNzX6/ka8tJlEQJqxzidasQ7KToOiQuHE0ft8d7ECE8U/pEPmngQb3Sz70WBmrhMqYuJSnoQvs2X6Av5XjYq6j7SStifwvoPm45s1qeQeJWs6Wf61insd2o5dkRDMsjMgqw1+az3IsgbbqpYmyig80c06FRhI7Y2VRmWCGFNMngHXv062U8gN1sg0fYTyXhfsLqu5Q7X9C4QJI4sCIKpWdtnmHKyMA7rHX0Bld3btmSw+6aOU0vLQSPLNkIc7DiBOELH/dhFC0woPXJP5C7iaHOqxeq82iSGkKRKo3QkpalBzVDZQw48anmf4iWdYtBc/C3QdI2YvnO907nj1kDSTJJujXcIzlBKy1xbiuQtImx45rafs3IGpKjc8J1gh3tp78ACUuM01iPAlTiOvZHZGHHPD9X/pR2Rq4/DCfd2jdaQ+cR5/Iw4kqYjkLN79hsDDwgUuUXd/th6A0ojaF+lN2Hw943aqQnT5yHko5ZHRBYZ77/OiUq391GKruXYGyrhnOmXKvDeZBRozx3Bnwq3HwNTmoHQ4Im0OcYErjX9rCf+10BFoAYIpTU/jn6I83HfIcCtF38Y9teNCnRNpiGN45VlGSPZKy+7HJtEFKPxiLKWe/qe7ILvSyVDF1+QhkYQhLgDahhy6ieQB7o5z8Cg559Br3Cx7rBUlXx30pgw05WegE/pxUB17xbmZD7DQkHO1N/J8zOn8t1vI/+Y0KNgLS8hx8oNNfCpTgDfVzljDHipEm8bEjGXfNQFHzrT84DOXqWq3CG486TC4jh0z5dDig4Q3ZmZ4x768j
 sQwYmwqP
 mNw6WgcpUr/CSrwIRLGuHyOfmcxVj1d9iBVqhLgHcCu+JqIMMaheyKDAGQw4Go5r15lTW1FtiyLvzxz08x8GOr8x1K7DeNIhG8sH1E/ARG9iRRmHQ0mTXrejdFx+jRbAAoWX4E1gTHwZYdl2AYDil+kT5TUWABm9AIOM5yiLuvX8MFByqNuXj1HkBd/F07WPNkL+O41nMJzZXh/1CndDEetV4tkZLDoVmSxfn5vc5uE05mYpuFgPJWD7rej5VJ09jpfGgvKWU0wiw6UdkzJoLkknsB+2LMMB0WOCbtcRWd28rulukxApifdf212zuQGsoZ66hJHY/sMzdWj57kC7UPwN5ItBi5Ik8WViN
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

Thanks.

When reissuing a patch it's nice to cc those individuals who commented
on previous versions.

> --- a/tools/testing/selftests/mm/ksm_tests.c
> +++ b/tools/testing/selftests/mm/ksm_tests.c
> @@ -766,6 +766,11 @@ int main(int argc, char *argv[])
>  	bool merge_across_nodes = KSM_MERGE_ACROSS_NODES_DEFAULT;
>  	long size_MB = 0;
>  
> +	if (geteuid() != 0) {
> +		printf("# SKIP ksm_tests requires root privileges\n");
> +		return KSFT_SKIP;
> +	}
> +

lgtm.  selftests/ code performs this test in about 20 places already,
all different.  In the interests of consistency and code cleanliness,
perhaps some kind person will centralize this check in some fashion!

