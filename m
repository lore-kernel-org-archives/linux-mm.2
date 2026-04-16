Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05182F8A145
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 08:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1FC6B0005; Thu, 16 Apr 2026 04:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 452036B008A; Thu, 16 Apr 2026 04:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319F06B008C; Thu, 16 Apr 2026 04:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8C86B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:55:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2D2D140798
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:55:54 +0000 (UTC)
X-FDA: 84663811428.08.876817C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C9793A0006
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:55:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/EWIteG";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776329753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOD5tX59IXhHCZv1zWXdKyfw26oghRJfbQqFR6LoD44=;
	b=fZxD+qZ4VWEsYJRrBzsgA2ZFLw4RODxQD47DeLvgS8SzOkAZMrvIKMvQSx0mlyXNWVF9Vh
	Wg4xnlb1u/+PUNmuoJQt63edNCQUfJYX260mJqA2bjuc69dz702UxqeAwp3adjJMXqfPb1
	phyZOjBrrBdAmKw7FoZJ8EVX3ThJ9aQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/EWIteG";
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776329753; a=rsa-sha256;
	cv=none;
	b=EpkyFaI/LKg/ZJI9A955B0PV8ixGuwKk0G5y0qskvtiiFiiPevkiWHJTSCMC2nxhk4Zrgj
	IryPhHGSWlpyjkQiL1sR4PfAxiM3fLpXS4zh6AP2Z4EjqCYO70tWUCOtL+DkEAW0tJ+zSJ
	KKfZc2/hWMWwKvLGfbLP+fdxZuLPb/o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D28A443B04;
	Thu, 16 Apr 2026 08:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE49C2BCAF;
	Thu, 16 Apr 2026 08:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776329751;
	bh=GSP0xdpLtfh+ShVRtbdWDherB8PF5rGv+/SkLctS+dw=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=M/EWIteGqXP5eb7n5mzxBJhl/Ai0b73YCo5rfNnCY03nyTfrxuAeTUTM5pBSEVsT7
	 CfcufnXOlw2FSLEY9VgiuIPW6Y99MEM86HFy70QPFYCSq4CV9qAInEmAGf+Gf2cd3R
	 MgJ1NNoiESY7ko1uVxE615YSbTykElKNz4Zz1bN22Ur7DuR80nKcUu2C3/5987JYfm
	 dHABSGAxTzsPURXVZJ/88oe1N3Mnv28uJzBQwBQrzKwFc8MRsNymvEgFE7EVBN6Ih4
	 lE84TpbkaP1EPcM9H+aWSN8C+pAKXPkCwqh40Z1DN7a/azpIBJXr1hVMXUzkDXOeq2
	 ossBLrJ7WQBJg==
Message-ID: <aa69f39a-4800-45fa-a0a5-002152f74b1a@kernel.org>
Date: Thu, 16 Apr 2026 10:55:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: skip KASAN tagging for page-allocated page
 tables
To: Muhammad Usama Anjum <usama.anjum@arm.com>, Arnd Bergmann
 <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
 Marco Elver <elver@google.com>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-4-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260324132631.482520-4-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C9793A0006
X-Stat-Signature: ztp5mikcsbxe1n5e6paaoqfg6iay5i7u
X-Rspam-User: 
X-HE-Tag: 1776329752-688853
X-HE-Meta: U2FsdGVkX1/6auhavBtt1hglEvzzRDrqcLi2aeVi4/J49i7unOmhPbGP9XyBQb9Ic43NfxLNIzM047FZMhjoqW1hcRNT42BIOwQxrm0z24svUrR3IP8xVtJa7YJ9WCALW/FTO3tvzEaLMqgMMADW0LcVt/0YlnzVc5stRfSojI443h7Kh/4RbsnuBZnkUGrpezfV0Oa80hAUPP+NiuCj8ly3VW8hAzhDan+wuHUmAArv/x8+r1v+n3cDIp6jAqQC0onDN8kxjOSDITjFYc2sCVIZg1FSctJjVoGqIRbJhn4Uqd9d4mZ+7NYl43uhqSvQx0GK6Si0Wpiec9d209G2qrZ2EohEyNBSBc0PQhbbUn1iFlPS9xlJrkfm3hWdn4jW+bpaxkogUiOFsqvJml+y/L2qBj+jquqMZEg/JGUKIAY2TK2rJZE+xwTP9SAk9LBlgtbDTkobJnJe95M7Gx9uZxE6wP9UQzRvKpfIQb2qFooxNgd3/tXrW+mu9M6bbxGLlYcTIUJETn/HlFHldFPbFZ+cbUcllKw/aj4yC5+2xMwoAhofZXfzP6CwbujC+tlIyZK35wx7jaHHRuYrNKLeV4fSGXxUyQaNh34I+aUcxjtYamdFaVUrz4Zq2opUTUlBYL2ps8yyA/RB/rn+dSsUM1HdszGvyf7suhCqiyjJ3D0zzof1yeuLQN2PObYSxWAnOFCMW5DMZlkSVVHs4ePNnVmf3NjX7d6N4jcQmkapm+OT2a/gQuiHf2ejPHzYUM7RPLsvIgrkUMqfH898+Zj6dmkKaQGf5o0WCobXHW7yw/NfXhtP90spjFuwQFQWjHtpvIz69ZAfq/MyBvVjlw3F5Ml3YMONfHyH1qxOX9DbVPyzci5Nt2ohry0w38EJ+2mk3LXKpuhoUkmw1i+9wgvgAaqHTwKS71LU03uQZ4xJOiyIYaWgfBm+zpyRSgPktCi4jwlXdIMEGP7VztcVdPE
 mE4iIkVJ
 SAWbQCO1m2N63hX4fUSkGcNyfLuqyrAOTb7RvEdlUYg8ofuIYPA+GPke30GqHeBl/c5g6LLq9mXa5S5rwWHWV/SM+8qWZCmnF0MMVzIjVzFXAVS/nu4kOtSsDLy2m9cQQpOD0FC+/ao+ggalBKnQH5cv5HCke+zCId+CLMk4j0AM+rjKjUD07C9/5gokkR0wY5HcDzmg2zyCXcBNqOC8bSGuf5NfolKHdM+O+RJ3XdDEn2JoPcOJ1rI3hywrJOzDToNybBEDg9D9jIYK68WtGp8vMq/oAC+e5sgwcbp6s6zQF44DJjSBDZk0H5tu+icFJ6U/oi29kK3PZVlKdLIUPjkVUFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 14:26, Muhammad Usama Anjum wrote:
> Page tables are always accessed via the linear mapping with a match-all
> tag, so HW-tag KASAN never checks them. For page-allocated tables (PTEs
> and PGDs etc), avoid the tag setup and poisoning overhead by using
> __GFP_SKIP_KASAN. SLUB-backed page tables are unchanged for now. (They
> aren't widely used and require more SLUB related skip logic. Leave it
> later.)
> 
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Update description to mention SLUB-backed page tables are unchanged
> ---
>  include/asm-generic/pgalloc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
> index 57137d3ac1592..051aa1331051c 100644
> --- a/include/asm-generic/pgalloc.h
> +++ b/include/asm-generic/pgalloc.h
> @@ -4,7 +4,7 @@
>  
>  #ifdef CONFIG_MMU
>  
> -#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
> +#define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
>  #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

