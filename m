Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0D2BCA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BFBB6B008A; Wed, 30 Sep 2026 10:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570B26B0092; Wed, 30 Sep 2026 10:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45F3F6B0093; Wed, 30 Sep 2026 10:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 185EA6B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:46:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18F7012083E
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:46:09 +0000 (UTC)
X-FDA: 85270703658.12.88B513F
Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42A4D140003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:46:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rXvcp5RK;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.99 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790779567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/F5K+TNyy2UgzuNElF3z3QNQRpGUcw1ZJkuRwiOyvlk=;
	b=znjO+Zddful7hXZ6oQ6PlpPEfaK6yI21Ad6QmOpYa0Eg6GIcM1tbeH9u4EFLNymT/Z9Uo8
	90eS3AQpeutUm1WrFuYRKGAJ5S2RXmf5p8nNhxpcShgiF/IppJE4t6zwdM3sp9A7XEkpIm
	j2IxEX3NwRFTW8u/zXN0OCNbKDZzEgI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790779567;
	b=pMUph9Yqg9V/Ze9EmJn0V/AI8R3VbIYZ10m2omX4DwalFyQgdnmKHEkvbu/byNDZttgHJa
	xes4o+CVfHer4j8K/HIBTKtkkDzeo+p1N+wmPdy65r0c7nz+ianXaDEDtXLWAS4xRZM4bR
	vaUYEAAIER1mSyv1wuc+97b/vhAm/gc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rXvcp5RK;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.99 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6a60591ae54so8700191a12.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790779566; x=1791384366; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/F5K+TNyy2UgzuNElF3z3QNQRpGUcw1ZJkuRwiOyvlk=;
        b=rXvcp5RKq2fJ1n03nKoqNMe5VqwpnbiBx2fOLc7egYBcYoC1nkGy6sqBcm2NC3Ngkw
         6rvT2WCdu2GVcZT42Bmo40aSewro+cwsI4F1DFV0zpg4s/fhG49md1V+hCPu+MBBV5QH
         qXN1akDyLOmHo8MTCtyGM9bKO+nGgW96ddttLbmOqIwUMf+r06FGq9CKhM3wDTLFEdak
         917gORvn93z/vzd7FoO0ruPz3LzsBfpYCtR/uzWSJ6+4szQwnf8I2vA1RMTs71oSp1BK
         0AkHei8vEohR4TDefqy+5Epbab8qOzRaVi0uo4wz+coDh4oIJ4JzVDJfabjrV8sXw36+
         XfWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790779566; x=1791384366;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/F5K+TNyy2UgzuNElF3z3QNQRpGUcw1ZJkuRwiOyvlk=;
        b=HibCPCZJw7Y1B1NAuaADUPHeex8ltxthe7sDkNwrTagmwYLOqQ+vyN2Gfe6MMU7kHS
         /1uIB1a06isiwc13FMAUICxRAWx7lPKnefhNTkteB82UHeWHrj8R9eW0A3VEgrBPh5Dd
         GFiEE/7uQbidwbpeuen/LxGBtOtAGQW/ScKBB+jydMdTCfT/UIJgUJL9VWSMrrgoDih4
         17Qa6nizckahs0VLegG3K8a7COtB8TX3PgEbGU3b2p6qpAePWW5tzEXWWcRDZBGp991U
         GOi3jP6tCaSzg+Tw57fldU1ypRDKVlUHNuLLFxFIrHuc4v/ONV39Tj4QCBDs6oyTJqDb
         hGhA==
X-Forwarded-Encrypted: i=1; AKwUvBzgrVHVc1Jc9S7SwhETd374oSMvNR6rs1dN6rtxZi+5vJ/gLp4XH51/naFwXrXSOS78rQb+fk/X4Q==@kvack.org
X-Gm-Message-State: AFq9FYIkQ1Et6jeDjb0UvpnhyFyvsbSQNUudGSH3C0wT3qGVbw0NUcNd
	n8qayNaFDbOb3wEXuA6KdJOUptpuVse5hZxRd2wabzL84DMfXcY0vqxX
X-Gm-Gg: AYBFou06VLzAeKJm4vz1xI3QsvS2cdmxvxUOQFu9qkNzkM3t8P7upyW7vWGk/aMGOnG
	Bi5QoPHQ6A68ySVLi4oqU1PF5wzwsfFuQiU42ZDauLYIMqqDFm3RCWR+WV8gZOoG60dVptiWFnJ
	0a3S2Mmnn9BduXc5ebxdr89NAojb00zKYo3mmU+/hUCHDyx4Y/Yb7hhO2sQQLO8gb6jm9GKATf3
	8cIfXqoDzF/hXqCxn0pw+/Q7muA6xzxhaMOkZ6tbmkxSvzY6GG4R5Iy9XvfqMmOthzizNxHReYP
	TONKuwJO0vn0KjLm59DY6wBA495kNUOf3b8tndBsRcFvwTztoaPkxHf5vPt17uaHzqVrsIUlHo2
	OhWgxYWrg6O7nEEEb34XDwsZyLMvSluniCedSDSr0yUlCHUFS5xgpSGwUmjVsMRDV6fV6jnqyNK
	ymZw8m/Zw3JSkSVF98gY3MvB/EXnMklZSaPCs+i585EREu0Q==
X-Received: by 2002:a05:6402:1d54:b0:6aa:734a:a084 with SMTP id 4fb4d7f45d1cf-6ae198f00d8mr1300841a12.27.1790779565320;
        Wed, 30 Sep 2026 07:46:05 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ae1569b42csm924295a12.24.2026.09.30.07.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 07:46:04 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 30 Sep 2026 16:46:01 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org,
	chleroy@kernel.org, david@kernel.org, dev.jain@arm.com,
	jiangwen6@xiaomi.com, leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com,
	mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v9 08/10] mm/vmalloc: extract vm_shift() to consolidate
 mapping shift selection
Message-ID: <ar0gqTEf2flG1TQd@milan>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
 <20260923062832.479455-9-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923062832.479455-9-jiangwen6@xiaomi.com>
X-Rspam-User: 
X-Stat-Signature: s3oqxnk5n6th66p9xns54fuisicxwnx4
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 42A4D140003
X-HE-Tag: 1790779567-513151
X-HE-Meta: U2FsdGVkX1/sRih5tFnzQCRrsS154MA7lXJ7eqJmcmNgrJcUGf1eYPeTbTnmwOEm6f88OAT3RpUzH/S37fbp10zIBsa1VLGXIPeQ+YbjoLLpLUMUEVoH+INRQO7UMJyjM5nNpV7ssdc67ByOmGUiJ6DGVHom5HuORHer6SncSZD2faVkacU8gQD/YUghg1QOKWaHkuTmPpUQXHAED2CKNlvdLKzh6MncHd8Nob1phVO9WtQOWXyyM2+Zs711PD/fM7KmAWesLO5wttb3J5LV+hArb57YEfiHURySwuhwx9aqS+NgW0dTjkkc24Shpb8eC2/yD4rB5Uz86ve09SDIKR7owA9w0iLUFpi1S7f6BgN2ylTBTZjlCqCsuoRhUY84T+5WyRgAOcxp4DVTiKl2vjd30UjkMt8Q8iHpdJ6I+zxGELVc3JL/JwjuHqdtU85RHIJAn1VriKYT/iqOCT2n2z29QFaYOtjey03TgyTN6BeloX1iLWzYIhJG5kDB6EZoFoVdKTlMnUWPn/0ZKLhvm6+8XZasDLQPCDgc1+NPkB8QNwyDucodTd347kuSG5d5W3q7vUdBvsHxv3y2LCRNQMFm8dc2Ug2QpWzmdnuUSHMCMd9QqsK3twPMhB3Rc2hYathXtNWPqmbG4HU4IP3ogc64eChYsSNRpaC3VIsd9utTCLOzH1PTZrkUFAkD3bSWltTUpCJsdYqAeJAUIplEc2ykU/84Tpk8nXqmCQ4vdz7SNy8rWbxyz7KFP+JLfv1UxcKTUluhGuNDOAOGEKVzgYD071y1wtbGj1aW1mpB5C0mTF5gFiGNf/9xk6y9TKmzI59Ph5toBTapun0WyhVPOSsDGa/oJ18k/hdq7h+rv4eKvPoG4IGGZNmA/CUnzHkKxwl55RsFlpCJq+GT9CctZEHZAUqw999iVC6jATyTaOrbZQrvWMrDZLNsy9hDfB8jfH+eWSZx7QMW9dUMNbZ
 cV7TQ0Ia
 7GjBzObZ4D6xOWsaC5nbkvi8Y7Z2Aq6b36aX0szksMpRFuf/O1ksD01fNkce+m9vKYGKmqeqFqR7IwRsrAHil9vbvDiMZ+nH9cJ6gFZCgNmDXJC13XIt1KttGuWoQwtKImLJ21yVPia5PX1sp/Dc8R7aNQWVkx1z2uZg7t3Ht4btzFYGYh2zyIyvsWBdbf1t95e/q8zrGNaS8ZrrF2r1DG0RumwOshJhcD3DiA2VnlWqTiQGM9tGrsaa60JM3mQLkaWrCT4wmqWvxVDnz1Oy6EnvE6xwo1ogrSfi4CX/f30ZvUWfe/evHHG4F5HwN+7p76uIVaW72ocXlgIs72bSKScQhc5KMEbMAFaxPXDcEhkkgqnlbMt312+zxSkUCu2KxzMl/JdYBeZdM5seRPYCfP871thUYlog2xwkTxLu53yJgglu3KGZa7dIZoNFuGHJLtMbCljYpAQjsMz3lOohZ8BCH+irhViE4GFZYz+w9iOvmT9XIqJlyX8Nfh47s6Gn3yijxfbqOBuNgU5BLgSuGWMQHym5a17ow2Bh2XJXYDSkMVJldIvAxp797rlDFIzc4vP9kp6zwctRLUvmxqZKzXo5micqzbf73VbOMKRcZcoqd2Dhi/sw45lFLqGXB+tfSjXGA5XCHyeHPq08ov6W08uilpN1JP5lEoxz7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 02:28:30PM +0800, Wen Jiang wrote:
> Extract the vmalloc mapping shift selection from
> __vmalloc_node_range_noprof() into vm_shift(), preparing for reuse by the
> vmap batching path.
> 
> No functional change.
> 
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> ---
>  mm/vmalloc.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 6e0dec73107a7..a43965016eb4d 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3568,6 +3568,14 @@ void vunmap(const void *addr)
>  }
>  EXPORT_SYMBOL(vunmap);
>  
> +static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
> +{
> +	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
> +		return PMD_SHIFT;
> +
> +	return arch_vmap_pte_supported_shift(size);
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -4079,11 +4087,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  		 * supporting them.
>  		 */
>  
> -		if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
> -			shift = PMD_SHIFT;
> -		else
> -			shift = arch_vmap_pte_supported_shift(size);
> -
> +		shift = vm_shift(prot, size);
>  		align = max(original_align, 1UL << shift);
>  	}
>  
> -- 
> 2.34.1
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

