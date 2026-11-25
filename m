Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773FE606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cZp6GShA
Received: by kanga.kvack.org (Postfix)
	id 89B6D6B0A00; Wed, 25 Nov 2026 08:04:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C626B0A03; Wed, 25 Nov 2026 08:04:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7671D6B0A04; Wed, 25 Nov 2026 08:04:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5201C6B0A00
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:04:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC9C4A0EF4
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:04:06 +0000 (UTC)
X-FDA: 85473659292.24.D3EDE67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 26E5720013
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:04:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cZp6GShA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795611845;
	b=X+IZ0Z49qFwZM+lnTgFxqnU44XUmvuvcdFuXl/Y0cPSFhcnXoYvkp0KLbIUZf4WtOocfKc
	fT3+9AdJkeReHl0ZR04XwBHKvxqCjN7VrktmVjyBXlkWnpWwJVm7xVuFFGc3FwWjyDANGz
	EeqaXbiCl5qfNPPjwedWrI4nzEB/7hw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795611845;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4prIyRPy5nGftAUD+uKP5ZczaFX6lXld3SnzOObjAw4=;
	b=L808FgLS3ujPvcaNiZcS4nktDDq+mGfPNz3V183JnXu5FJRz+dsCCrRiIV2RMOj6/CB2cX
	YsIKyWkZG3qnKf53w7CSc6nZHJcJ1dip0Z8oHQguNwJus01U3HBNi+4n8hBV+sPZmNkyWV
	xSCworYwZ5MbLDNAadynuOq3nrnVcFw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cZp6GShA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F195F44399;
	Wed, 25 Nov 2026 13:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AD81F000C0;
	Wed, 25 Nov 2026 13:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795611843;
	bh=4prIyRPy5nGftAUD+uKP5ZczaFX6lXld3SnzOObjAw4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cZp6GShA8YHVnayThs1JVdhNPwtN8Yah8dnGWNEDltm9+AsxBMn7A23McyKTfomSJ
	 H7VLPS2QW5voiv8R8tBeL6G7jJhZjkYNKsD3on2eM6OaWtQsoGd3NWWIu7DE3gz1md
	 rBx4Oq4FqbkBqnDeMyd/hnc2vctgJurSo72GOVKh0XNaU+qrhjxIUugqJz3jDhS9hD
	 ML66CNAxXLorT50vNzLbSOgKuMnM7MmdavvFylxp7D7IUFbXT2Lg2ZArILKafeS47r
	 JHxq8baDrRNMsmKtYwiwRNR5KZXllXV5o+lY8atF3xM2KU4uRxkKjZmkBnVqnKE62e
	 YCP78InWnzhIg==
Message-ID: <sashiko-outbox-233438@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/3] selftests/mm: fix false-positive and racy KSM
 fork test
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?WHUgWGluICh2aXZvKQ==?= <xu.xin@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, david@kernel.org, donettom@linux.ibm.com, linux-mm@kvack.org
In-Reply-To: <20261124130327.131410-1-xu.xin@linux.dev>
References: <20261124130143.128411-1-xu.xin@linux.dev>
 <20261124130327.131410-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 13:04:03 +0000
X-Rspamd-Queue-Id: 26E5720013
X-Stat-Signature: zpdd6kctaetkceiz7qggd9dtzdescj57
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795611844-335041
X-HE-Meta: U2FsdGVkX1+USCUStL+cnCIqczr0pnyk8XiuE2VsJNuxYhiH/jr+748gerNQAkrytV59LPq0kqg6Vc0I1yr3BbdEzgUFYXAkV4vMZQodgRp/0dFDO0ruLRQleI03mZWH/9S2iL+udccafzX4U+v0CacHDSZ4ZG2Cgjbz+iUT0gABHhVzAhuNEz2N3OkY7a+f9/4AWIg/Zueu0dRClX+bRaiemIvndZ8MFIG4WqG2G+sVmie5GURelqJtsWPs3RYvFfX/Ien8CBMxk/NL5FPZRZArH/sirvYmZyk4cJqcUnnrFQGRVElUqEG/h03vTS0Op53Mn7zsWEfa2ZVuzLLa7Naxt4q/3VLDEOpjz8V8Rr72EF868UZgkQMioIbtf7JbgEkCfiG0M6nV3Lvh1qVZPJWEezgMETD9D3dJlUE8/31uF9wa5isiv8P9itpBPiL6IRJUft7gvSiySCtukEP/wHeT3cReyXMSQl6MfSYbsXdzbVIg3XRBBtWsRiZ0M14Qx6RVo3uFaxTEJDK8IsHXTBtVViMyOhc924cWgzFnDPaCIyugO7FaNu1/Goo/W9rbkoQErQVLnBV0CpgLPTfMzOj95Kea/cGZFXjIJsJ9Xax+3CXQQUhUlhcbbCBDvUqpFEYx4K4rM/ZozXdpGvztr01tyZ7fZuw6kMm1dMZL66Da7f7bphv6noaRJ0zTnDFzef6vcYmicrZ02FRT/5RhaSMr42VmPFXY0tbiG5tqUiOmKNPYiG1iRym2YYjtHo/YYksiy4mRwQz3LH67gZPUkZe6+k2Jba/lRiIZoaI9si0LIFtart5nFmTfTzE/JsAaZkylFZh8y6e5q1gi3wrvOEtyR1OChEfBX8hBWgtcDRgbB1GQZefvV1WX772t5OzlN1p1tbkYoDihS0I5zWvHKBwLKUx4VYA+Ult3bI8JH7di6Fe9kt3gMSrsFm1zi5RrndtzJZ3JlfBWC662a75
 x3SQzq22
 hLXDwldrHlBImnnmV/fIulfRjK87gU4kpzBaTAH7nonVoknPMfFRzf4xtnXNua0/s0+I75YwliCHFB1dOdowIvipX4Rrltts1WhpqtXzea5bUwIyAM/JGD3XOx8BQOOGWFavb9XebpuDoMa3tW4HDefRzDlKy5RfqZRFu0oNGOfBvDMmTPWxIJAOlF5DIfUE3sCqtdlcUfPXEzU9FqKSFQ/Zhar49m5li/Hd/YPDA6ASR9MszvK7QLoMVDYFhQWdKRMZQKnwp0904V9EYPBOreiRAoWawhVeSG4NNVLI+E3W0aNbOA2aatdpOI5FTIt+wI5njUprlLJEomWsU3JfzivMA5FLEFWBbm9Z9glFxbpT+WFDMo90SlQUOd1WcjeFBxraIvF9KK5XQEbCEQPmTC1+8T5VbDxjE09avWpbtsEFhkmrDMTSYaRLW0FAnhRDW2xqiUgeHzj3ntTdhg+xdW57w85EZYItNJPpp/SWYy2C3IaVYN/lQEampHQJKZMcwpw8bkif7ZKQfpdjc0q22d/3vo3UkV+CuqnbXtp6h/8STEf7pekqEM5t0HASoXpL0pAmYIPGOgodu/t29SIAYdsOuADn/lXhkmYLmq95eE++9gD0gcbKJAe9LuwfBxPSIxxEc+xCUDJbcBZZHeTRYKAqHoJBj5CwTpTxZC/0tNem3TE5RI7+aJt/XT5suSxbzRdnHUUp096tf3RN2f/FimrKHF3GCWYfShayVJPlZz2SSiPXnLg/gwrqI6042mmHcX+KU91+aHqi+OCvTdfIzCcorbSMX5C3FG8UHwc5p9oFpQ8hh1Qu2H7YBCirin1go17ZBAUonmIOaBQ5KcUBQWs798qJje2AAi3e3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] selftests/mm: missing Fixes trailer for
  test_fork_ksm_merging_page_count() fix
--

commit 9f91c40f8740268fa4e48f24e3a50d43177b045b
Author: Xu Xin (vivo) <xu.xin@linux.dev>

> selftests/mm: fix false-positive and racy KSM fork test
>
> Currently, test_fork_ksm_merging_page_count() passes wrongly even if
> fork() fails to reset mm->ksm_merging_pages, because the child process
> calls init_global_file_handles() -> ksm_stop(), which unmerges all KSM
> pages across the system before reading its counters.
>
> Fix three issues in test_fork_ksm_merging_page_count():
>
> - Drop init_global_file_handles() in the child process so it does not
>   call ksm_stop() and mutate global KSM sysfs state (unmerging all KSM
>   pages across the system) before reading its counters.
>
> - Use '!!' in exit(!!ksm_get_self_merging_pages()) to avoid 8-bit exit
>   status truncation (e.g., 512 pages on 4 KiB systems truncating to 0).
>
> - Introduce ksm_pause() to pause ksmd (write "0" to /sys/kernel/mm/ksm/ru=
n)
>   before fork(), preventing ksmd from scanning the child and incrementing
>   its counter before it is read.
>
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

[Severity: Low]
Since this fixes defects in test_fork_ksm_merging_page_count(), should it
include a Fixes: tag for the commit that introduced the test?

  Fixes: 08ff89b5659d ("selftests/mm: add fork inheritance test for ksm_mer=
ging_pages counter")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124130143.1284=
11-1-xu.xin@linux.dev?part=3D2

