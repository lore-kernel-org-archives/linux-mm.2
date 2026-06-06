Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B82CD8C88
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 19:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30D246B008A; Sat,  6 Jun 2026 15:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4976B0092; Sat,  6 Jun 2026 15:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227826B008A; Sat,  6 Jun 2026 15:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13A986B008A
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 15:36:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B608F140545
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 19:36:40 +0000 (UTC)
X-FDA: 84850494960.24.EBBF889
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6A2DFA0002
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 19:36:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZJMrw5wv;
	spf=pass (imf15.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780774599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=No/xV3x9JOJgAL1c15ZIv+cOiIPQT3ioZC04jvxeT6A=;
	b=DOD2HKDJ2nThQ7B9WwVq/KpcOtGeajvc8+Fcrm5ziR+PznAxP+5ijto0mmWtsWkkHIKhaa
	8Z3cZ3PWVj9GlZh2Z5FzaIJ/7BEjRCU5fVF9uLXRv0Q/gjNbN/gGAMLEdG5XfSApp1ImUD
	TxmcgUCuGyq8qj346F2BPfNIvx31wrI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZJMrw5wv;
	spf=pass (imf15.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780774599;
	b=7WH3xRZLIl+cYNTSfaLfG9dU+Xb2ztvKIqv0Ic3wvmA1zBUrTuAdlWMtLgSDo2ODt6mo9D
	gaoOqLIUGTggMaseNKAtABtowdku6OSZXH+9z5RcG/MNkUK2ecSkAq2fmpLcNKvJDGxmbu
	n3PKvu8XfvON9ULP5vCdMP6iU5Z6UPs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=No/xV3x9JOJgAL1c15ZIv+cOiIPQT3ioZC04jvxeT6A=; b=ZJMrw5wvZzPJQdMEBjiDR+dur+
	5LRP/8nnMh44dHYngo3fb4CfBoHhr7w1+pSFIy5urgeT69Y80h68TdLWPQZi8wMZHwzPW93T2iHyY
	C/mSd1XzXEKdL3wFv6FwGYkSTi85ZXfGBQUQgTuWuleZ1zFXHULSi1ewLi+lmoTOy3QmtqqslSVQN
	f9MuMg9T/HfBb4H6iaJlEZC8GFWQLDfUL5aonI+ONxPhqAlCI+T+vFwoxZOHjE4sy31+icyUJT4NL
	2NkGFNuJL6c2lUgr61l5WucgtZkPDnfGIsn7acOBLBPviQBcAmWpQkWBTS9P+dxNTAvzjL2ZT3M0F
	JbgDqRvA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wVwot-00000001mpL-1tu3;
	Sat, 06 Jun 2026 19:36:35 +0000
Message-ID: <37fbe86b-b476-4d28-b8e6-5b8cb3808b42@infradead.org>
Date: Sat, 6 Jun 2026 12:36:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: memfd_preservation: fix rendering of ABI
 documentation
To: Pratyush Yadav <pratyush@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org
References: <20260605160645.3650271-1-pratyush@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260605160645.3650271-1-pratyush@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6A2DFA0002
X-Stat-Signature: f8x7h8i8xpxta1tgmazojkupo5mff4p4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780774598-775200
X-HE-Meta: U2FsdGVkX18ymoaZCtZd0KYP7K6oWyb1paVkqK0BeiUb+PJez61G3WCeRw7GDX/bLbsHdsIVxpWs9AMWhq08Z0D61VYnIEX8YX3JqRWzYs0YterRkmQqPdmUiyTMMYf2KEhumAL+/hGejBFRgzhG4cODdAkhw9tt874j8yja4LstItGGKdDaXPDj8DXCUkTJLjHrgP83haornysBgHGMKWUdvkScrdeK7ghMXAL9bFN3Swp1W5yBFN+c3lfFc9JRbf30qLYEGGj51eUBifgbNMFO3Fu7jEMNhFogqx9teW4RGdgLd8+jXH5jbcCNyTtV2x1M/JuEoh4pIHZZPqPvBidw+NKybubBRd5GD8U+lQdlmWAe2yww3zTgyPUyMtdLaWYYujCf0xfFE5ppW5VWHswW4jyHH2AoqveUH3s5xb0XjDHBw+hpEu8kZ1OpceUixIBROIMng5po1XhIX6cHGKaMkpWK9DFGlp9/ieMFyO6x/oiwh7S0mW0ZFKI2BD+860rI6tOjoHpOYGRgXmVVvZHwh5xcQcJoiSokVCgdYDp1Os9aVgZC6VFJqFxmD1k2Kaipu35BjS6QbyRJBGOaPDQPc2/9oljfd9WF7dM3VUghBqiTHb3/VAGcqBo0OKIEhpkCpWRtUzuN0Jft2iui5YOHZgWBZg4jFCpx2VMt91iVnCLj3y+H/gxBo1rW5/+KRVWQ/SWR552ncijUWeCbCDV4JDIm77+tYTNmQuj2Zy3vhU8g0Tc1ZYkY/rBgtpIVx/9mKM03HiZW/AmYqPSjjHY67Q1EK0i5CLtJGLaI8yvy/urvqNipqAYgbQu2qnes3t9hVu1xrqEHEr94aGaH0KlqIPJEcBupOE6+b/hzhbcetb9+3pVPdgHwW0rlMJ6heb7wskHeyUeUDSQ7UezSNGaGhSgTP4VS5hJtRj9xfZg4XZgrdSHbSVPGyenCtyksAAWe5hB8pCSnt8GuKcS
 peZo3dHi
 Nm0NB8v/qm9EHdPzNP4rD1gR/ndcUtU1DViHejuWq69pCyw2lYB0nK9e2VJpJVJgGohUsmYiobARRbPfmkCaZXs6TnFFSHVfyY9Km2adHxqFxMMsqAeioJlHWoaiDefR5mU92KOOYJ4ngSrD3uZGcUgjF7Ud4efUj1srXPsBrMSdahZDPkpdSSJCkIt0hBb3Gqb0ZGMpgjo+9i2hZ9Z/RIWsbm1eEXeRrwhRluhh5MOPU5a7tpwbVElssjP8UnXw7GUec88XGDxomesOM/rAHIj3Gvv4FeEbRY4/zqM5QYsnw2kst8yIifDGgXVob7W4ot/XYgCENFrr8vb+28s7RGom5sSvdNtDHEkr8LqfoqsuyoriSve5jsdaKuICBNyvhfpZvVpB5KwmJjVSU0dzgJAujHQ8M9kR6rOf3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/5/26 9:06 AM, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The "memfd Live Update ABI" section in include/linux/kho/abi/memfd.h
> currently does not render in the exported documentation. This is because
> it should not include the "DOC:" in its reference. Drop it to ensure
> correct rendering. Tested by running make htmldocs.
> 
> Fixes: 15fc11bb2cb6 ("docs: add documentation for memfd preservation via LUO")
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
> 
> Notes:
>     Mike/Pasha, I reckon this can still go in liveupdate/next. But if you
>     think it is too late, we can probably take it via -rc1 fixes as well.
> 
>  Documentation/mm/memfd_preservation.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/mm/memfd_preservation.rst b/Documentation/mm/memfd_preservation.rst
> index a8a5b476afd3..c908a12dffa7 100644
> --- a/Documentation/mm/memfd_preservation.rst
> +++ b/Documentation/mm/memfd_preservation.rst
> @@ -11,7 +11,7 @@ Memfd Preservation ABI
>  ======================
>  
>  .. kernel-doc:: include/linux/kho/abi/memfd.h
> -   :doc: DOC: memfd Live Update ABI
> +   :doc: memfd Live Update ABI
>  
>  .. kernel-doc:: include/linux/kho/abi/memfd.h
>     :internal:
> 
> base-commit: 2935777b418d2bfcbfe96705bb2c0fa6c0d94e18

-- 
~Randy

