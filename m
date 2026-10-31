Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A497606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 04:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R4EQdXBN
Received: by kanga.kvack.org (Postfix)
	id 493B36B00EF; Sat, 31 Oct 2026 00:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443226B05B1; Sat, 31 Oct 2026 00:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 358F36B05B2; Sat, 31 Oct 2026 00:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15F5E6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:13:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90101A043C
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:13:33 +0000 (UTC)
X-FDA: 85381602306.22.901F069
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1051E20002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:13:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R4EQdXBN;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793420012;
	b=EHvcYhheGU0y8ZXwg2ie8e1iH0u3+G6ro4uQJaqglVHeLlRdP0af53CsURq2EwRfm4FrGw
	97UBeFShh42mJPH1JSgc4OM61eNxUQQ05xLinS9sSlWCpC8n0ywV86418VHn3dNaMjq4cV
	Za1GIAbJiKuHDcO8MBJO5bRlyg7ReGM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R4EQdXBN;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793420012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hdblefE6S5tAiJMj8KJmoICUKdholikSnOmEf5tzMU=;
	b=CEd37D9rQG36c5p+RROQWf2Fq7xg6EbaLMwqeYXpqIJ8LBjIKfohqS8sR21wu//AS3haQR
	jPQKYyP9SJJBy8w9dNejy3BXRi/PWjQk7M3qdxryewajD1L3hJ4WGRAJ6q2MgiWThnAMEs
	aIYJ/sFJWfZ4g5eeGwMGg/eXfMFx3Ss=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 520B6600C8;
	Sat, 31 Oct 2026 04:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F601F000C1;
	Sat, 31 Oct 2026 04:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793420011;
	bh=3hdblefE6S5tAiJMj8KJmoICUKdholikSnOmEf5tzMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R4EQdXBNX8QLXGc0X8TmBH9Fb9wWbqf+Oyh7f7jwj4AQpxv0TaRTM+7oBwtj9pXcT
	 kufcOzg4jPz6GRNP+iX6tFOWBfsU1mAYaGgqHYG2KRsiM14/+4ZLjO7CJBikdSMBpJ
	 wVkiA3Y5wG7dEInpGmZFZ2JLXRYrEJFIGjxAMD5eqBw8yBcxEEyJxPAfr+XSZE/98X
	 0AwNwjGi479VRMBjZkIVFsZ8kiCCML/MQmWVQtHlS9ylY4ZS1f21kzS1cLumk073Lw
	 Ve0mbW/MPWGakjeHzDS4YCtvvKb4rP50KyXWyYkP0gtn7AIbRYA/mJFlm4a2Soau1B
	 EBx8vWbmq8Zmg==
Date: Fri, 30 Oct 2026 21:13:30 -0700
From: Kees Cook <kees@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/6] mm/slab: Enable SLAB_FREELIST_HARDENED by default
Message-ID: <202610302112.453CE16119@keescook>
References: <cover.1793253633.git.chris@chrisdown.name>
 <2ba9dc862607d70050bbc86fce0091de2e23c023.1793253633.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ba9dc862607d70050bbc86fce0091de2e23c023.1793253633.git.chris@chrisdown.name>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1051E20002
X-Stat-Signature: s76ae7zisif6sxdrg949uyeeh9ndiomg
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793420011-770814
X-HE-Meta: U2FsdGVkX1+QpoSt5BjcVchnLGpmbToy2Lilll3+dztCsTZ7UPPjFiHrJaEG5PhVczpjaXAcQ1cUBY7gnm1C18HoO0acEdvZJTDrl+2hJ7XrVUfgmBvCQmMFZPM4VQhymdBtiAwJ1rGRNqWF6pvLEvcTUO+9pGAHbiAoi4CWara95j3jZwnGC9ZtyFEhGWA1Okd8qbwVFrninD051C8bwk1jd30WvAl3UdZmvJUmkOsbFRz2HVFsJdoLpYSPs0pfFHsFJxEEp7akryPSAOd001OjDXr+HKrjaX6gyaGImREj7u7fx76Oc3sPVcEfKXqYwB1kf1RTtiZhoD10H1zoKeGQ/EptoPHo/LyKkf1isZ/CcHCPyYm6POGLRbpuivQEGAekIn9w8DIcJLqXeHvV/bWMcBHhfAr1KYpyxQ0OdIP0OdRlWQr5yHBtL5WyZrpoHQf934aQV/ZH/5XlRJXf441CBqHETOlF0vpH+oVizwGf+eYdytvdsRM2+R7rlMrxwSpXBzdeeXIKS2F18vvESGQaXC2w02gdleyxUmC7P/64sYtBCEf86dlMTrGe4a+w6ahkLgGQalPVtiokabliz0pFQRHhYSlAzUVZN0jhC7a9FIp6ZnP43Ky+QfmZod687S2gwaLs6aBEm0cvKyWvIFeX5hBoDFbd7fEeIGC4yM7AkyH6VqX3mclOA9Cre+ZrldSfpykaCg5N8xrskVZ7r/fwSziX3s1vKTLDvEQeatkgrcKRjZFaoT/SNOzy1QhBuvYsmjzTTf/O8uD4NUssvg/IAVp15rRHiVGZBR4fi/HvZge1IHrD0D2nhQ+0HtT2sFW+mcd+l8fOWHcUPtTHH86Tdbih5WWWg89CB2H0MJcbXlP5YMY2RR0sJm8MVFF/xoUac66TT49Kbdusbuwb9Vpq/Zr+aZy144GohBGrlzuPji1kqShvv22f+HbQ2WC4eEMfEJmUaWHkMbWql2u
 usyBAQrd
 HK1sT+pAV29bovdiaNwX1SUdtJFIc3btWufdpNiFyLSLscH7GoNy9/T73XWpUMF4jLYt2R2AdNe8zTJPQt78WUjEYm32cmcXrjvC8LW8Cr/D9TNLrd4aQMcYPSpw3lTVOUX+pBPh83Fsh+lPeEUIWgA515wTyrJpYkeaZ1f7/Gg7yI8EHJ5r1Q6fk527nK2cS8/h6HZeB068M/1XR3FElWnHKZJcBuVdZbByKjYtoXheIPkWrVBWILb0eZ/ZMZVtRYVebtJhWOhjC4ySWsiU2mdxdM3VJF4DVJPwPtBC2h7me1tWu8X5hKBpZSVBJesVE6GDI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 02:07:22PM +0800, Chris Down wrote:
> SLAB_FREELIST_HARDENED obfuscates the free pointers stored in free
> objects, and catches naive double frees and frees to the wrong cache.
> Most distros already enable it, and with sheaves its cost is small,
> since the per-cpu fast paths don't touch freelists. Measurements also
> show this quite clearly [1][2].
> 
> So let's just enable it by default. SLAB_BUCKETS defaults to
> SLAB_FREELIST_HARDENED, so it's now enabled by default too.
> 
> Link: https://lore.kernel.org/all/auITixAJMfLtfa7i@chrisdown.name/ [1]
> Link: https://lore.kernel.org/all/179312451613.474906.1475329637924619088@kernel.org/ [2]
> Suggested-by: Vlastimil Babka <vbabka@kernel.org>
> Signed-off-by: Chris Down <chris@chrisdown.name>

Like I've always wanted it. :)

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook

