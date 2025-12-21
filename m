Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 539D7E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 18:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B46426B0005; Sun, 21 Dec 2025 13:57:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE756B0089; Sun, 21 Dec 2025 13:57:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E326B008A; Sun, 21 Dec 2025 13:57:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92ADC6B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 13:57:13 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4108416094C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:57:13 +0000 (UTC)
X-FDA: 84244385946.27.4AEF986
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 86F69180008
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:57:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=g+GTEdc1;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766343431; a=rsa-sha256;
	cv=none;
	b=Nv84im9011rpmeqtyoF7pi2DPT2ZaEsMUHMmJ+ZD/j0o3T3woBPYuP1So7mn6JxlOOnxUp
	cWl+l99d5Amp4sXcvc+31qX1VVlIXgl+AJhWk6oRD94hx4L3NjUUITpBH4R8kb4x6xTbWm
	qOSeP7G6XxQJcSnV8b+5DoKKAzHAkD8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=g+GTEdc1;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766343431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNDsXY2EKpSGnUV4V1LdbUHoPfl1d6gEaa1EKGD594E=;
	b=DDPNyL7VIQ5hN8SipPCIvk3EqVQOFRfy1s873WATwH15zuKsaBE161Fa2CKP5hbrJHBVr0
	uHMCoUJtZxjPytIdzPRSPPBlHrjiwSCn4SOVmcUlSTXlszTn4ZGnClwCHH2OM3ynr+77jx
	E3EkimwU6pcWjvaW4xaheiAyHEH12tw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 68ABA43344;
	Sun, 21 Dec 2025 18:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CD1C4CEFB;
	Sun, 21 Dec 2025 18:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766343430;
	bh=hGQHHnPP2FAXKrHAOJzdAxZu07/LllOij9yDLMsdGM8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=g+GTEdc1y/9lf6gj0ixFdSdxktQF8rWsMKHsoSn6bcMfeHOG2y7LU0Y019TXF927J
	 kY4014nBSvXnSsvNdhZRS8fsy4JQyXJ7AwiD/cyD2cEQ1pMQSi55tztfyYpZFtdKYe
	 trjqvcQID3OtOjPEMBo0aOTBuLmzUPHXUAlHAeG8=
Date: Sun, 21 Dec 2025 10:57:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, Luiz Capitulino
 <luizcap@redhat.com>
Subject: Re: [PATCH v2 1/5] selftests/mm: fix va_high_addr_switch.sh return
 value
Message-Id: <20251221105709.d2e44cf1bb05bd9669e76d0c@linux-foundation.org>
In-Reply-To: <20251221040025.3159990-1-chuhu@redhat.com>
References: <20251221040025.3159990-1-chuhu@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 86F69180008
X-Stat-Signature: e1awzp1i1xfdjwfu1ej41kgigxdcdu8g
X-HE-Tag: 1766343431-328755
X-HE-Meta: U2FsdGVkX18OUAftXGCG9HqD0ph+uNzeMACUH6akNvJ36wEnDDo8vu8SaddvDWHgYjuMIpZHpnrQWwfTBXnIPYOCObz4rZMQc4Ghvr6uZIwPk4RlHylAaUL6yFELhcwnn37I4yEyHSp8msnwlZm0PBuW/qOVpK+XBkdAkQLlDHwk3PIgmVCIO52r/T1bcMBHz0OiPM0jLc3CV67N3sCaJoUaRjj1IV5vB92HCE7UhC6oJSqhrpd4v4cM/LfSUVIMIQeDE75/zsLoLWYDaKKE1cbrrsJFRspbwZwolQp0PtqASdBOZAittpmGUrUBcjb7cC2rleplyV3rR7YnjWgowIrCzHtV5jy8aw1vAoNoOTIkQfDZ57Yep3sM0Q7kFAGY+AS/dgFGm6R/qnRuNcmt0CKJHy4WO5fM3n8OMAJAEAVyRP6h2Uf43AQmyZB+CIMnpRDznbXqoFQsVzZUnKcqk4pCK2OpoObrGZH6n1CN7+uVfPzJiP3mtcddFlGY6qyrKcJ3ZHCWMzsDY7pxw2yX+VkOOteZe6nVG6DApiGFZqPGBohS8OVPMKEtICoiWFe+Yja6iWu66mfj9ODWgJmHA12EPf41VGLftirArKS8xUD+eMzic2f9bQyxBGPnWBoZSsbHICmQ8DyrphbSd3k5gyLNC9UiQsezmvhJ3L/aegeG9gWz6CkuEznm23qwVTrNdF7wuGh2NSa4bGukUug6Mpk/1G+G0rmo7wQB7iGXukAYav6ya1Hj4oU8y1PLhrmb2ii17Bgp1Q5F8f1TKsIMGc3WmnltDmYfhvt99y+XC7b8ATGzq9hLgIREiCw6dkrkZDoF5ur2L6Q7HiQ6cU26l5wUIebaJyfBQx54rkEjnLLmxaBxyA8I05f16M+BJZdurC1kwOPtrn8jjjV42kKiY0MPdOD0CHX7Gz2sUsMI70FlzwuP9//cKi1oVehes9Lvgy/glTpYj1MpwltWOey
 r69YMDNX
 hpggecbW1WMREZOd128ePbbYgrg+bokV/mKsv3aGVjIE0pfyyOVshK+dXJvTfyJ087Eg0hobmJcsOPwWxEI8LDw0PXLqBltx/QcVr3Mxf+dDHNJOEbQbbVOO1TzKQIIOLZiSHBEXc/3iwGqVL1ZzZcJGSByjqullRofW4lTIhIHyqboV6X005h545Ld/8mui9gDU0U0rBPmmW/hc8os5KtFIrWEGhJyxiB129hptS7lcAlwuxX5sQ4FvZSeCuIX49+tfTNhfcTrjHisx4hWj3pJnU6+3DTlTwLHydA9xnL6zdZ8M0VBKZIL9gRTjjaHYb8vGYu0cYWx3TVzlZZQvEVqWJbSAUeU/kmjf7AKlOGAWmCFA1hR/Tuc+9VmLwFHEPRj1T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Dec 2025 12:00:21 +0800 Chunyu Hu <chuhu@redhat.com> wrote:

> Patch series "Fix va_high_addr_switch.sh test failure - again", v2.
> 
> The series address several issues exist for the va_high_addr_switch test:
> 1) the test return value is ignored in va_high_addr_switch.sh.
> 2) the va_high_addr_switch test requires 6 hugepages not 5.
> 3) the reurn value of the first test in va_high_addr_switch.c can be
>    overridden by the second test.
> 4) the nr_hugepages setup in run_vmtests.sh for arm64 can be done in
>    va_high_addr_switch.sh too.
> 5) update a comment for check_test_requirements.
> 
> Changes in v2:
>  - shorten the comment in for hugepages setup in v1
>  - add a new patch to fix the return value overridden issue in
>    va_high_addr_switch.c
>  - fix a code comment for check_test_requirements.
>  - update the series summary in patch 1
>  - add reviewed-by from Luiz Capitulino on patch 1 and patch 3

The "Changes in v2" material is best placed below the "---" separator -
I prefer not to capture such short-term development-time info within
the permanent kernel record.

> This patch: (of 5)
> 
> The return value should be return value of va_high_addr_switch, otherwise
> a test failure would be silently ignored.
> 
> Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
> Fixes: d9d957bd7b61 ("selftests/mm: alloc hugepages in va_high_addr_switch test")
> CC: Luiz Capitulino <luizcap@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> 
> ...
>
> According to the doc below, I don't add the cover letter, not sure if cover
> letter is preferred, and if that's the case, the doc need an update.

Funnily enough, your series was in the exact format which I use when
committing patch series.  Usually people put the cover letter in a
separate [0/N] email and I move that into the [1/N] patch's changelog,
as you've done here.

> https://www.ozlabs.org/~akpm/stuff/tpp.txt

God does that still exist?  Pretty soon it will be able to legally
drink in bars.

I think its content got absorbed into a Documentation/ file a long time
ago!



