Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FFFCFC27B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 13:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7E66B00A4; Fri, 21 Nov 2025 08:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659176B00A5; Fri, 21 Nov 2025 08:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547A96B00A6; Fri, 21 Nov 2025 08:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40D8B6B00A4
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:37:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42F2F4EF9E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:37:00 +0000 (UTC)
X-FDA: 84134715000.27.5AA70DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8E0122000F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:36:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i35emxhE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763732218; a=rsa-sha256;
	cv=none;
	b=ArtOMdOzD1BJ1uKJe5f6GCOKAH2Nl3+V7Hc2WyVvFrE0oZqaiA2aMbYwOmx3RDDbOteUfs
	cZqvnLyDuDKmZBK6TGqB2kJDN4rYyL1f9BdXkH0yHYfrSMyYBk3Oso7axS84+NXkOsaCt0
	bJykQNKX5Sk4q/vhu85JdQ6BD30hEag=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i35emxhE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763732218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ps/C03GrU73xa5Wp33M/88ikT+6aQd9rzr+y25IqkQU=;
	b=TabiZsbyT02HF0gNVTs7As56/HO3cAnT0U1BvAoX59ESme8XXNBVBF2IZBMa4RIIgLkqmV
	zh1KuuhbV2UjttfMFpRhVtB1WMCTPx6xo6FRQ70XLI4Ne1FbSHLLZTzgoZDylkAcPnLDLc
	vDnY5gqZHy/VE01G96SYZoDObeh/r+Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2257943A82;
	Fri, 21 Nov 2025 13:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BB4C4CEF1;
	Fri, 21 Nov 2025 13:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763732217;
	bh=gmNU8aO4a+0cyi6R2ypDeco/WZeysrGhC1fhSvHHEmw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i35emxhE/HumLeVdn4T2hbgV1EKis8USH5PMwPQqjrJdbEVdFlICaKV9t9pBQ+C8w
	 4/9EyDK39Bq0/57mVEfXnqWsU37JKELSoqWnt7XoDdpnYvuY0KNAnJw9qBgjXgNREn
	 uaL0NQvZGiCJatDvarteEp9av6uL4Kp3uUMVuZSc8wXsDOSt7vKdazpwMpJG6wLuDa
	 aF8pRoZIfy/vEjJvxuHacilp9Qj9eK/cwK6RKwZPUSP+MwF19AV7P4RVAbvdVR8c9w
	 +C4YmPGo8rAvlE3OyvHUS1Kkm8Wbm+Kugv1+hpPRQZKHYKYmnqsTCL+Y3c3RLpt0a9
	 pB0TVKRohObWw==
Date: Fri, 21 Nov 2025 15:36:49 +0200
From: Mike Rapoport <rppt@kernel.org>
To: ranxiaokai627@163.com
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, graf@amazon.com,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	changyuanl@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kexec@lists.infradead.org,
	ran.xiaokai@zte.com.cn
Subject: Re: [PATCH 2/2] liveupdate: Fix boot failure due to kmemleak access
 to unmapped pages
Message-ID: <aSBq8T8ETc3zjBf6@kernel.org>
References: <20251120144147.90508-1-ranxiaokai627@163.com>
 <20251120144147.90508-3-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120144147.90508-3-ranxiaokai627@163.com>
X-Rspamd-Queue-Id: 8E0122000F
X-Rspamd-Server: rspam07
X-Stat-Signature: b767cz14zjkiyxwni3oabjfwyx4wyutr
X-Rspam-User: 
X-HE-Tag: 1763732218-466622
X-HE-Meta: U2FsdGVkX1+o4qfLSfo5w0O3wAhiNdMSwG9ghPgs12+AtHGOO9OCetLaGNX/CmKr+lIiTFBbBiF6u5acbcapEPW7zwyNMOWS0KdoIh/UljoZhhY6E+/mFOS7g6vIKpn5P+a+/M8sRUkC5fj7d/qGaJL4VgR5UTZ0fOslBe3O6u19vXEi90ZvHLRHU//UNyed4TP3hiU4y2XsP/zy+G/meH77AQwkPpe1JP56NMEKx54m+uugK4uMHGHNSOJ5wNal1UE0fK3L2KCakt3ZhmVVaY1W3fPcDCe2TutrzIO7FyNVjbEFYsYH/0bQ6QlqQ0hglllun4xilhBFe+6w+JyCRdusqTfRKpqG1Mmf+n+H4BMgWdsWmfRpLl2/zXpKAxAJ+cRev2Oyyt6cj+x/uf3jXxNUonnHGi4pxMCi5vHzg27L5RmZTlw446ruqPHpWYqr8Ff5KEGhvW3cQuiwOcU7C9jrUKNlQVNxD9mkNYAfeT4keLdmaD8hxEO7f0fhYAG8NL/8twsou0Skdaph0DT8wjGKsOdhhFE66KIxAm5AW5vqMlkglS1UflXv7BTogUXPd9H6Y2o4/nnhJzEzJ88ze0QAXvaCmRqQoycP8WfuDJlViLntxsUiWBJ3eVbMI778rUssFKhIRRewU1f6bEnmJuFsUxFOmDDsn8vuaebOgRyTfXwcBHz7Y8UYL9DRLdJJZJVGJ5I+DVLPE3fPFSScl6BwwzQMIQoe+w2ZLraPhLeISHeIuwtO/qVxRaDlOCm6iO59tfnvdthCjfKYzPFnKPeQ15Ef03R2tW/Y2OlhkacQTi58DZNu7Zae2vBT+TMOhn9xLlJgM3bH1oMxxklsNerEIia4dC1tnguTwM1WY3gj1Sih/JaaeZpIZpNIglQb/rtcgYCnRfhhRFCMFyLMO/JsxMZTL1aFaiEQovpbZfiojzMQq6y5qFLPjGKRra6O7N1aF8YH8mZ/pq/ChMZ
 nXfcldfG
 QOCf1Ceuj4eLIAqx0EytLoLzoYR6mG1N5RAkfw6eZXQVEAv3jvdogjDwP03vBq2fPvCpDn/11GtSapiKA7J6Ct6S81PEyL8/ZBuPrgBgiTOWKI0DEzNA6/LcW3JmHlVJXoDVSm9t/0B97ACPiOAidimExv7JlmTHmtFAxevyxokCnFxYXpMwMhFKDT4LIq6Lvqn/RYTHKQxbUv7JnK/BIOkG02aPSHxDEidGeBj4209zjRroBOjvjbYHeDDLMZdSABwBpuovO/gr7JMLCchwwX3bpyvwDcnK4cAvZ+X6Hkm2TH/wNmZqieZdSh+d5Xk/eKr3YgA5B/H8fEJQKqLjaEB8E/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 02:41:47PM +0000, ranxiaokai627@163.com wrote:
> Subject: liveupdate: Fix boot failure due to kmemleak access to unmapped pages

Please prefix kexec handover patches with kho: rather than liveupdate.

> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> When booting with debug_pagealloc=on while having:
> CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
> CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
> the system fails to boot due to page faults during kmemleak scanning.
> 
> This occurs because:
> With debug_pagealloc enabled, __free_pages() invokes
> debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for
> freed pages in the direct mapping.
> Commit 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> releases the KHO scratch region via init_cma_reserved_pageblock(),
> unmapping its physical pages. Subsequent kmemleak scanning accesses
> these unmapped pages, triggering fatal page faults.
> 
> Call kmemleak_no_scan_phys() from kho_reserve_scratch() to
> exclude the reserved region from scanning before
> it is released to the buddy allocator.
> 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---
>  kernel/liveupdate/kexec_handover.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 224bdf5becb6..dd4942d1d76c 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -11,6 +11,7 @@
>  
>  #include <linux/cleanup.h>
>  #include <linux/cma.h>
> +#include <linux/kmemleak.h>
>  #include <linux/count_zeros.h>
>  #include <linux/kexec.h>
>  #include <linux/kexec_handover.h>
> @@ -654,6 +655,7 @@ static void __init kho_reserve_scratch(void)
>  	if (!addr)
>  		goto err_free_scratch_desc;
>  
> +	kmemleak_no_scan_phys(addr);

There's kmemleak_ignore_phys() that can be called after the scratch areas
allocated from memblock and with that kmemleak should not access them.

Take a look at __cma_declare_contiguous_nid().

>  	kho_scratch[i].addr = addr;
>  	kho_scratch[i].size = size;
>  	i++;

-- 
Sincerely yours,
Mike.

