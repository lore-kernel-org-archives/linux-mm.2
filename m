Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7531BCCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80656B0092; Wed, 29 Apr 2026 10:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D318F6B00A2; Wed, 29 Apr 2026 10:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C478E6B00A4; Wed, 29 Apr 2026 10:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5A366B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:42:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70EFBC14DB
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:42:43 +0000 (UTC)
X-FDA: 84711859806.19.58D633D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6655F100016
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:42:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FNOpvnT2;
	spf=pass (imf14.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777473761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ae8k9/y4dcEidqj7mqSbdGlrkwqM+6pgwroBfIXn8i4=;
	b=15YlgGHT67Wp8UM2aG4VNPReEfd6ZENPTkNg7Xhs07BeQYQKGFPrBRs8FIHqEi/CpSLP1J
	xiMqEyO7jt7WMa8JXwtD8fSBD98UM0IGEj1yHArtTswB7omrhhehJ6C3Ca0qScKnjsmnHk
	lresEQnK/LsayTkI0vwLj1X4s19P06s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FNOpvnT2;
	spf=pass (imf14.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777473761; a=rsa-sha256;
	cv=none;
	b=KKedSpxgz3cpnbUpXaFeWyUqG5u8obDBoneH4/bcb7hAHxkWq45eY1M3IeF/TVVlPu/Bgj
	iz20gUlZK948A/uvxKyH3/1D2bswPzGi17SR7e/X3wAi06pvYt7TAwiVOymzrUuWtozC8Y
	HCD2IKdgdUP9BjV0GCy1zwS1yUXOv9s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0C721596;
	Wed, 29 Apr 2026 07:42:34 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5382F3F763;
	Wed, 29 Apr 2026 07:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777473760; bh=p++YllAgo3zKlnyl/JQIUjXXYurKVSfK85qEuqMWRv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FNOpvnT2UnIDLx7xLrJ9QrwaaYb4fg3fyxTc0TEQRFOMlUvuNl+1e8Ny4+tSZcY5P
	 7Xhzadyb/ODwynFJNTOFnI7gXLtYxd9vb+KM5pMPk/g1MWqS+8I+7rx2MpEaX/BN7e
	 O0UOeItO/ucZDQBINLlsJiv+AC75tqqWDSlu9kj8=
Date: Wed, 29 Apr 2026 15:42:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, urezki@gmail.com,
	kees@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org, arnd@arndb.de,
	Muhammad Usama Anjum <usama.anjum@arm.com>, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com, tglx@kernel.org,
	mathieu.desnoyers@efficios.com, linux-arch@vger.kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v4 1/3] vmalloc: add __GFP_SKIP_KASAN support
Message-ID: <afIY0OOqPezzTVBt@arm.com>
References: <20260429102704.680174-1-dev.jain@arm.com>
 <20260429102704.680174-2-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429102704.680174-2-dev.jain@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6655F100016
X-Stat-Signature: mj3j689dc4mi7zzu8yh183xzdnhmt99x
X-HE-Tag: 1777473761-802513
X-HE-Meta: U2FsdGVkX1+cCdPc44ZnjzbLw8/iJBDcekjopRk+olXhcElPdEqnA3T1rOU6TCdOlIml0u49Bmn8tIVSMojuiVWP52wMIR2AhA6svf/9/ITLqJ60l+LAVsagTEYVStqbRsLBUkMGW35TPa4mk4iJWqNpRu3ej00DmWY0nS0YXETkkQ+gcmGS140AnJW24XjbyqZXBJKDwQQvOtqUHm3Kmi7WXF5+LaACV0vesqU7SmK3+f4zGGeywIPN1TEXjWUMW51ASNuviTfKKUEzP5Nf0UreHvOLZOl1O27Yc9+lZIVelkbhmvdHh/umk6LC6mR5427AFXZEjPAj6XC6JM+jmDTS4dUz1QfXTNGPfbsF/rD82xy+9WWUfyvfLNdPGIYkZ685YfIp5nTLnYFRmdLwYTVNrid5Uu7rZaQMQSqzNZHM3TLlncQyH0wttAniOp6JpUEm0wSlJUmeFfk3cK4IOF0HWayy44vtlPtrD6HVaaVi6is8kYmo5VgczKqd9Pk269d9k5hAcqynJdSZT2ZLEZWKXvebCQpGhKJDisnFfZZ4Asm3ujCI7mNZMOf2fGzGAtho3PRK1uxpyCxopZ9TzmufdZ+vK+pCefDcD0tMhR28l9BAwT7so3IgTo/5Wsxt7CiUveJe1XUd3blwKnDPlZToypX2tL4FM2lXbYfzkv8CP/kXQn4kOMQTf5ePluX2+uJL0GVrtbDfq8Zk31oko/IFhnKR43CTmZ24QRcDyfXoIhbyl/hpdL7Wr1SMo2LErzssTmN373gbsGviY3EbW07c2cV4cokPPUHDtcM4OvZDQhwbD9nm/xgPPVlhN4vQlfImp8aYrYEOKAwZ9tnUqoaWSjaJVl5WEfSbD2Im/49e91pV516IaJ52D7XXtWv9+nLDxhMSxZfUDlOOpdKaiv2MrgOiePAQBev88seiyzFGYHORnUHU1mnb+ooxOXssDo5jfrIFKVSALDFPOO8
 ZTGP/XnO
 7ENsBmYxOfh5k396zIIl60sNoltjv0DsVS6rLCkYiNeaYSkn8SqnN0u1XUUILoimYMRKQC38bAof86iSOO6yXAXGz2Qv3BFmiuVm1eCwjAiCvc6dvCdaBV/QRFYeF4yv6K73cRSoVxonP2qu0mC88R9O7FWEsOhXdAIeyxYL7M8kmX4MqFnBg69JhrfvoAZmqci7XssWXcgZBCY7Yd+0ZIWELPgDd9h1dt9mfspXf3cwajU8v7RxefonMgBn2bHavwmntzCVIQK47iHBNQEmdBLNL0Ne1y3LViK+Sfr4jNFlQbIRjniZtko0BCEuKcxdoVWGTUURE0GBOUmMsBW4NF7AZUGjY8Ft9tQoAcThAqDc+Jfv2YZcnEpHYew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:57:02PM +0530, Dev Jain wrote:
> From: Muhammad Usama Anjum <usama.anjum@arm.com>
> 
> For allocations that will be accessed only with match-all pointers
> (e.g., kernel stacks), setting tags is wasted work. If the caller
> already set __GFP_SKIP_KASAN, skip tag setting of vmalloc pages.
> 
> Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
> APIs. So it wasn't being checked. Now its being checked and acted
> upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN is
> ignored for them in the page allocator, and in vmalloc too we ignore
> this flag for them.
> 
> This is a preparatory patch for optimizing kernel stack allocations.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Co-developed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/linux/gfp_types.h |  6 +++---
>  mm/vmalloc.c              | 13 +++++++++----
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 6c75df30a281d..c2bd723c8ec62 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -281,9 +281,9 @@ enum {
>   *
>   * %__GFP_SKIP_KASAN makes KASAN skip unpoisoning on page allocation.
>   * Used for userspace and vmalloc pages; the latter are unpoisoned by
> - * kasan_unpoison_vmalloc instead. For userspace pages, results in
> - * poisoning being skipped as well, see should_skip_kasan_poison for
> - * details. Only effective in HW_TAGS mode.
> + * kasan_unpoison_vmalloc instead. If passed to vmalloc, kasan_unpoison_vmalloc
> + * is skipped too. For userspace pages, results in poisoning being skipped as
> + * well, see should_skip_kasan_poison for details. Only effective in HW_TAGS mode.

Nit: keep the comment line length to less than 80, ideally close to the
comments above (for esthetic reasons).

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

