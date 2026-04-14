Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3FD3F9D0EB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 17:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 283FA6B0089; Tue, 14 Apr 2026 13:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25AF66B0093; Tue, 14 Apr 2026 13:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171666B0095; Tue, 14 Apr 2026 13:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 050416B0089
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:54:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AEAB3E0BB5
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:54:27 +0000 (UTC)
X-FDA: 84657910974.09.A1288CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CF40240010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:54:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p9UsAxCC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776189266; a=rsa-sha256;
	cv=none;
	b=B9KcHoTjra9bbC6lLcK6eIKhs5CJyr10FbDpJXC7hq0w7Ur5YIjJmatpCbY78o5rP17OFQ
	zEC4XIHhgi618skt1FTI2GnpU/IMxWGaUuJ9D/6l4WHPMjnXbac5I6vytUGFzTh2se/LC8
	DHGvLvLeqzfSqDg0HyQ81D21axDsQrI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p9UsAxCC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776189266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o0oitkRaPlhxEvrLUvQee5Y375xtYhMjN9dXeQ5U3AQ=;
	b=X2rcaFoK0qVF+CbUJSHKvo3/+hwdXG5w5JTybfQ2c2KBAy98qcb5k82be/xQbF/8NNys+d
	DqS4hnkpldHpx1jrIN0uhb/k72155oTyyvp9mXfMt7k3EIrV8P1ErbXh8lUnKs+YvcK2fD
	T210+zZQEAvTNfFVM4Ro846z0xxTlHM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2BDA41A29;
	Tue, 14 Apr 2026 17:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C40C19425;
	Tue, 14 Apr 2026 17:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776189264;
	bh=jDAi4hxOBuKCdZsMTGr0ClpmAouBxMWURvjoq8hDpcI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p9UsAxCC0f3S7z2S+/ETxVZHJlHzFEZrxRXdOohy1WfdoZuR8Vze96U0stZl28euq
	 wrlQSxUSUpzdHMXt+XcdskPrSEtT0wF+yTPEs5+bSING+vJPbkhLmGBvzaN6IayrdZ
	 J7hL8wkSC8aLR2nlAiY4FDYHiq091w+2YdYKDXgaSoN6x1lBBa9dpHStqlAin3qUb5
	 YXpeQGbwKFMvVFE1u/smyCTLSQCCI4u/B3hcuoK9fGxAQGCNwJqwXDhYmsK3dv2RWd
	 Wz/tUfJVOz8CezhJ4KUkdHEKXbUWi4lPBjtiKW6hO8Yto+pr5DltFf0ogfKsHDf3UM
	 /zpfCAnJO5o1g==
Message-ID: <5b906d22-50bc-474c-ab12-4253781cbadd@kernel.org>
Date: Tue, 14 Apr 2026 19:54:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] MAINTAINERS: drop include/linux/liveupdate from LIVE
 UPDATE
To: Pratyush Yadav <pratyush@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf
 <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260414121752.1912847-1-pratyush@kernel.org>
 <20260414121752.1912847-4-pratyush@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260414121752.1912847-4-pratyush@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF40240010
X-Stat-Signature: 8qmn1gozsat9mttjqwoc9gnbzypn3wiq
X-HE-Tag: 1776189265-578454
X-HE-Meta: U2FsdGVkX1+Sjk6QZDQSz2pAWfPdmpESUQ5zoHyvolx2sVpsXfTAm4Un1ukQuRjuOFpXVkzy8XLkynStSIYBTfg6RXyfqHgK7Ph7IycOSTOrievs+Gge0LLW7685D4RFDrDhiA6enjAb108SnkM8M2Pssr/WLFRuT0vjxYn8gFDaFbMHnaSbyscoB/A0Sh1p/a9Uit5tmw2FMMBmjts+vDRNCOQBfm3lCA41rBYiKofg7KS0l2Vn2m0nnn3PTk42oJMrvTcOX+amwPzOSZ8tngX5h2ve/cE9mvjWw1SfkPi2x0Ijk4SsAwp2+VzXKCu6/B9SQARWXDuud1QfR6EMDcbCujV9wraccCBnVXUcibDSsE+QQbQgpsF2y6zsSIMUogvbyhqkpMLrZU+/2MF3Wlxftv8/RezfaAYeIO4gl+Lmoyy4fRJgTGb9wq/Xw8Yk4B/pT63DOHxUkF78pVI3beDS8pjFHkWNos/E2/gUdgtwL+6Um2pxjSSiizo/lxVMCXmGkwiJLmEWIDbOOzxnJTvNq53CtQbGfjRPCUDUX3HxZFKrq11BZlN76YqEVSM8bTGRhlB0ijtVOrmld/WqoAb2erSqyil55EmWSPac7Ysq6roeGfsorw2Nnwalfb5QqQSC7UyY9exof2QEwqG3qI8ZK8RsGSRnaMiCcf6uvrxAUHyFG51sysjtSs9xmuZL6aF5Ajyx/C9mc5/yJWiq7dyy9+wXVUh/VxyxQJWLE1ewJFHafO61yxigySaeUQ7vWyX/nfJ3VW3rKS17XZP7qtVAO6bNwDJcUB/iwJs6fZM7o9GPjpYzD3ubpjmfNuylvFzdgzhkqlyvmgoCE15e/Y53X8DbCcwwpsLx7GyGYglllYJLKyeS38lZuyLJnnfePic2YVZH4xMQCcPQwmu/2l5Pg0FdYROw1rnzR9sTGQFaogViKZFswctEynFOo8WeikD9vi8ockwO39H9hzd
 owG9batg
 Lko8/q293ofOcDCFpFpJK9udnDiOKlQab0dvgdt8npWoQNJhsjhgi7BOOWHwiu7o3nPDT/l84qpOCpDXH/NGAs1R+vSmNIFw+7zSKiMC3q5hRxoN8Bn9sefx0ch+wlWFqJ6cFfBhD49wto62h6sRPAKKWtvVM9zC4664v0Nf+7qQp0fu615MFkJ2aJiO15J+E6XvQXrNIpjAgo77batEhsnzNZU0T++S6ojiQFoxTHKCvc1/WQzlWlDNYdFw7l4iuJc+Kov74aS20wqeKh+euDfWvaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 14:17, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The directory does not exist any more.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c1e2cefb4493..bb588928533f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14811,7 +14811,6 @@ F:	Documentation/mm/memfd_preservation.rst
>  F:	Documentation/userspace-api/liveupdate.rst
>  F:	include/linux/kho/abi/
>  F:	include/linux/liveupdate.h
> -F:	include/linux/liveupdate/
>  F:	include/uapi/linux/liveupdate.h
>  F:	kernel/liveupdate/
>  F:	lib/tests/liveupdate.c

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

