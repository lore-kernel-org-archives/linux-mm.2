Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EE0DC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B556B0098; Fri, 11 Sep 2026 12:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912E06B0099; Fri, 11 Sep 2026 12:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802D16B009B; Fri, 11 Sep 2026 12:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DB256B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:24:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC60CC02F9
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:24:09 +0000 (UTC)
X-FDA: 85202003418.11.4244C10
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id C93A68000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:24:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OHwxFymQ;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789143848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRrGcGHqSlZzFKEDyzW/AQCwZxj3rMYweY7tHcKxeTc=;
	b=VsPRazfK4EBbS3lS8U0L8zwju5retX8CkCYp6YXO7+Ps+Agoq2niFElvBecjUSLb9AYpch
	eL2Wm46uP9QAr8wqwjx3XYTW/wetSIm/AJhDEfU3DgBcTdKG+JGfgFrsWKfhNaTjofXDhf
	HxxoASWwf6w3hpzxeYO44ccuc/gCW4w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OHwxFymQ;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789143848;
	b=bi3lW73CEODERbgm/U2hOY7RVwY4H2JuJP1JCPX+oxOxXvwUO6wS+xZUQ+iqt3dF/bdbDw
	YUJ/KVguWu8gvPNR+gXGK56viUx3CCtRlI73oK0udHtALim2vZ9yoG2Vg5n/Az0GKMDkEV
	uC23PUTOMYErvguTa3xfjMAFkbtlE7A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2084316F2;
	Fri, 11 Sep 2026 09:24:03 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E80A73F7B4;
	Fri, 11 Sep 2026 09:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789143846; bh=OAC/+t+zOxm3qX+0sYXiY/CHafOFrJAYbJ+ZXlb/zvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OHwxFymQN1CZmSj6KzKrDt49fRNk5weOzIW7NYzxiKWEgg10ZMDJsC77fZ2boQ10u
	 yF2KB+PjklYu3mro3DMk2Agd+4GakPF2QCvegJmi8MQBWj5Z22jKKEFt5O/AP9/Ikg
	 WRKiBqt3cZEqmWE/qZ4Z+xrYuqMtBKAM1anuaYYk=
Date: Fri, 11 Sep 2026 17:24:02 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH] kselftest: mm: remove exclusion of building soft-dirty
 test in arm64
Message-ID: <aqQrIkcPf6uMlouk@e129823.arm.com>
References: <20260911125028.1268274-1-yeoreum.yun@arm.com>
 <0e419abb-71ce-4b97-b189-da86a4891920@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e419abb-71ce-4b97-b189-da86a4891920@kernel.org>
X-Rspam-User: 
X-Stat-Signature: oqnonjqcxuwiiwg5pkjirifmdkcgu45w
X-Rspamd-Queue-Id: C93A68000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1789143847-778184
X-HE-Meta: U2FsdGVkX1/2tf4k3LYdpLu/7qsMeNvXA+I1g3t+QNk6fG9rKAspArlgblomyIos/oXMORIW5WaiSMSN5AqmVwDwe/Sm2MorwcsqUat7EeGECzu4Olx+dPoKAcdL21uabPKuGup6vKOSLAwZaN6EN2FhSk5oWWIPeVwsFa9hNWhnBPYu5fBY9pI7ZtKjgAYrYlqT36U+EYCitRv+8qtt4aUTQ9HlgoHsDok/l1By4ZiN+ky1ZfP4oxTIWosNYouP5FjuChziKRN3qIheTa/pzeIcjB4TxeLNGr1t4HZJxw5jaea6AtuHUxBYZj+/nELHVw4ehQJloTvtFbxZ9pYWCkLRMvxZc+5NXlUC78QyAm8OdB3SqC79sCw3goO/o2M9oTQm5A05OqbziZjRVUzGpkxiyO/tWVtYN6hFGO+IGViVUjiQ8NO7GQ3epdUNeZF9KMR6dzKb3oII+qCPrxjeKbYJty9TE3XIrNfn1gVFEyzceAIJAqIqC/Cw/JcxZ3CHsiGO97VeRUyGgz64gPW/UxSylVk+rDQExdz7Qp3pUQm8CHOmxxOCjxQIzNge/lMfBGcrvpZtqfRLOkEESgxpA+d4g5zYZpQ/790bQdG8TasH40YgiBKEhjO5pGQ3foXjBzb+TO/zl2BJ6d01mHkTBg70Y1x3n/rDzV2+IALTUIt7nzRk6efTRttGC7UFWZ5eRUbVqIQ35EimHPThvfS4T7oAQdZ2/e6TKw8VpyN/bjepAaNEj1aLX8xxBB7b3dGP6pKkosv35gqdP9T2H0DhtUjVrwxPYBjYPlQTmdce7YyyK4v0TYztrpHS6z1KyLzESXI33BZI9hTQl9xRmWCNabY4hpP8RzOkR0NqlfzSbrcDERwb/EbaoLNnUzrwCVeOH5Hc3u65ZaXmwdvXyyarcvOjpSA5KDh5cIpdnj1k77eJFppy2qIU/ZdKoxxMsKSsDjTon7Q3G//jMzwseXR
 hjjUWcn1
 L+8MuNunwbwacZBYvEtooQ1i6NNrEEXMKJnNrn2mCnrOXQ0KInXmiT7pOgi4QFH4IvLSW6tJvij44dKDlhBUftLYrmMQSkvBGde+eqeHS/UBousiZ8k5Dp5xoAe9ejodsSmv8Y0ZHmGUBNnys7VcCp6a2DP8WgJ8dOjPxnAllcdlf7NQBWMm7Vb+lf4M4HCTPLLLk+aHoJOwZst6g0m3N5JeZBkPK1SbNSbEYMXmWasRwO0bwjibPdUfqDMXtRtfqBohhJdEwxRyn1keHHNHQ/UejE5RujcmWnOaPVBt3nD9Y7OB35eDuzOGnje7VFHIrybT+YJgttDHJJqRG9hPN7dv1ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 9/11/26 14:50, Yeoreum Yun wrote:
> > Since commit 0389c305ef56 (“selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled”),
> > the soft-dirty test is skipped when soft-dirty is not supported.
> > 
> > There is therefore no reason to exclude the test from being built on
> > arm64. Remove the arm64-specific exclusion.
> > 
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  tools/testing/selftests/mm/Makefile | 3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> > index 2d5366196e30..d3e9bd67904a 100644
> > --- a/tools/testing/selftests/mm/Makefile
> > +++ b/tools/testing/selftests/mm/Makefile
> > @@ -104,10 +104,7 @@ TEST_GEN_FILES += guard-regions
> >  TEST_GEN_FILES += merge
> >  TEST_GEN_FILES += rmap
> >  TEST_GEN_FILES += folio_split_race_test
> > -
> > -ifneq ($(ARCH),arm64)
> >  TEST_GEN_FILES += soft-dirty
> > -endif
> >  
> >  ifeq ($(ARCH),x86_64)
> >  CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_program.c -m32)
> 
> Does that mean we can also the following?
> 
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index d09f9f6a384ee..33963535616b2 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -390,10 +390,7 @@ then
>         CATEGORY="pkey" run_test ./protection_keys_64
>  fi
> 
> -if [ -x ./soft-dirty ]
> -then
> -       CATEGORY="soft_dirty" run_test ./soft-dirty
> -fi
> +CATEGORY="soft_dirty" run_test ./soft-dirty
> 
>  CATEGORY="pagemap" run_test ./pagemap_ioctl

Ah right. since all archs have the soft-dirty, we can remove the if
condition.

Thanks!

-- 
Sincerely,
Yeoreum Yun

