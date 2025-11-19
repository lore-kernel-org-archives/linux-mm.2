Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 496D8CF31AF
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 11:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A62D56B0012; Wed, 19 Nov 2025 06:41:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12DA6B0027; Wed, 19 Nov 2025 06:41:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928806B0029; Wed, 19 Nov 2025 06:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2496B0012
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 06:41:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0650A891EF
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:41:33 +0000 (UTC)
X-FDA: 84127166466.20.8182AA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 52EF520009
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:41:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dJbIHiQr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763552491; a=rsa-sha256;
	cv=none;
	b=rATa//G0Y39Rl4qc13lXMpcxtGAgOE0VCKES9QBSS1CL5893CksVOBcf8a+N98LO8c8diU
	RIDeQnYmjp4vQGHrfLnrxkKSSBX8uQRFhUpUsTo9gRAsNDfgR0kTcrhRismy/RAGUeAPvU
	hqs4yLtAjsPLHbS4U9WxTiizCsQ/ceQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dJbIHiQr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763552491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eq4WscAyZwt7xa5/w9xC/NYo57RAulVfgxORylBgydM=;
	b=tCySVmc6ldGgMmvaMuTKVMAEoNyOjJ29b8noBv8zIUlKvSvA2K6L/mr+tS8VuYFl+Gg7wn
	fYKTl9ol0Ms541cxeYVwJDBQrBG3TEUVEfGEcom9k4guJwGk6ukfq9FbJjVOu777BSgchC
	y6M0DRLQR/BBZtNrwDyjoV0rzhBMBWU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 86D1C60126;
	Wed, 19 Nov 2025 11:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F382FC116B1;
	Wed, 19 Nov 2025 11:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763552490;
	bh=HXpQLGEYTPYES14JBHZvvFK44MSIkNFIzwcCwSjsouc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dJbIHiQryWS5vtNu02vTmwBFqXplLmDlrRF3Oj/Hv8Rl3ZpPg4lfks4k8cE/XqwR9
	 V9MAm853Im7SAdK7OXzlQw1hc6tyKLDgzb0uKjIo0GCzMjAqscZ2owxQPDp1CdEz7a
	 7usbZ/LyHrmIBFSRl4TInJY6BMkNTTqpwNiRaRzl4++4YCRK4dWRMoJoh2WkvIkdYZ
	 xgI0cA9TTcO8KXj59OYrhJ5G/eM4nqANztmks5pHkQqHorWXCFHTgtIibsN3o8GESg
	 KcvLEYucw41mQLZuYbSRCwcgj/tdWLOnihNqvwOfKxarPLIBUMfK6lvxodlvk9eBbF
	 XeSn8dvhB6NSg==
Message-ID: <e539179f-668e-452d-a08e-6143392dae6a@kernel.org>
Date: Wed, 19 Nov 2025 12:41:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] mm: change mm/pt_reclaim.c to use asm/tlb.h
 instead of asm-generic/tlb.h
To: Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
 akpm@linux-foundation.org, ioworker0@gmail.com, linmag7@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1763537007.git.zhengqi.arch@bytedance.com>
 <e9d510106b5bf72a9b577b8c5ad161fd3c29c2b6.1763537007.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <e9d510106b5bf72a9b577b8c5ad161fd3c29c2b6.1763537007.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 52EF520009
X-Stat-Signature: g67m83p7ptfnd1j5hwxrqkqnuqb19b75
X-HE-Tag: 1763552491-384089
X-HE-Meta: U2FsdGVkX1/yGsRPBC0opW9x5N58eQKc8eT9qodQIu42oBs72tlIDwTVpU6hw7AV4882iRUQ7ZpveCrpNFzzQqUwEQb1Ar3hBG9vJz7hzCZ6TsDMkD1z24TsePnHN7ekifrbMxnTCyAbZM2t0NnhhxWBuIfuqqxSRv16miLNFP/Ovbtr1DxtveLstJ35fT9XuXVKgs+r8CL9o3hp5XlPI+CmGTYaXoiIK/GX2PSCMsUrb+qpi/hkJ1CxnFXMS7aKoZd8CSYM60eIEu2mm2kpopirQJrIKmwPf0nEOad/kpFrBm/hE0YQhrAcECrzU8xdSVoxU6moYIERVp8TWXad2wcTM1y8pZxxHCmPyHpIWz4HxBp3LfLczyD/mcc1OFJyee7mklwR8Z1EnPXtc2yxJv79lbc4Ea5iAzd6OYD2OJDs+MLF6q0mDa2bpDOAJpvyGBWjsczlJRVc+5On+bQ5vcxYBH4yRzxlkHU/SNYiVO0jHXtDvXPh7XCmSne2Cshx4IAd8E6q0RVI2KIZRbBYmOBpG093Br3R3Ci1nz04VQkpeJrFcGMqjo+e/XYqzVP4N1uR0kpvKppBIbasAKAualxShmAatybbBFaPqUueknXW+jCo8sBYffR4l0fpaVx146JK2zwKNe5i6d6MjYPo5I64ivAfSsaBLELYxtb3Rb695ZNv87jbe53rlDS2IinfWoqOyLs1ZX/hXtCAvj1cEoBvetNGNT8YUD/23Hoj5focju3LYw4VPGW/VDTYa7K8IWMRivLhS1XUfHs9AvsCKiTMmLK8mEuE2nj/z3/uUv378KpV46nJet6K4frf2OxZ3KdGJeNQKw6pR1l/e8C/dAzmaZsFAR2Xoz6206VjIq5mF75dLDYNiK/zDGZuLT4UuEx2yTHSnIX5bxfBuNbzQtEj45x2GqtA/pyIzUQYL7TafYF0EDaNAHuAjrqvNWKgNj2djJuj7D15xu4oJSK
 OpN07CwL
 v4oEuqN0aT7OIC6M1RGRyvOvwyDY73EF2QcApHUfqo1vtvONll4ngZXx6rssewIWFJNY1LEWU1aQkwpOKqKv2dNzOKrdjKpPcNcpTsmNDHYTC7mCGUzSUAm15ga+BGALihbpYneAR5sC6REK4ggtlvkaGOQoxiPDy4EFvD+rBlXHNgQ4Hmi6gcXJxlC5Tevpl72j6+A2FPIZvtUBzo0TFLA2Fgn6XHX5QcEr4LJBWdj9juAReEoI6rPPwFbOUmtO+XGQMUDnM7nkGQ2+OszfJN6j5YU7W02B5YKYPmAyt9WWmLxPmEVqEthXcg1BsmKnH6FbfN8IYtzfLOm2L5ne3+2CORnEBZvy+d9fECTzFsC91NepvwWCewDWEl2wbHQYJh01p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.11.25 08:31, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Generally, the asm/tlb.h will include asm-generic/tlb.h, so change
> mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h. This can
> also fix compilation errors on some architecture when CONFIG_PT_RECLAIM
> is enabled (such as alpha).

"This is a preparation for enabling CONFIG_PT_RECLAIM on other 
architectures, such as alpha."

> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>   mm/pt_reclaim.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
> index 0d9cfbf4fe5d8..46771cfff8239 100644
> --- a/mm/pt_reclaim.c
> +++ b/mm/pt_reclaim.c
> @@ -2,7 +2,7 @@
>   #include <linux/hugetlb.h>
>   #include <linux/pgalloc.h>
>   
> -#include <asm-generic/tlb.h>
> +#include <asm/tlb.h>
>   
>   #include "internal.h"
>   

Right, we're using pte_free_tlb(), and the default lives in 
include/asm-generic/tlb.h.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

