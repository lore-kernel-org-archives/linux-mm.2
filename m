Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBE67EED628
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 16:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E45B6B0089; Fri,  2 Jan 2026 11:43:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592366B008A; Fri,  2 Jan 2026 11:43:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49DE96B008C; Fri,  2 Jan 2026 11:43:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39B2B6B0089
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 11:43:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C27DA5A0BA
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:43:44 +0000 (UTC)
X-FDA: 84287595168.10.FB6245B
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 46FAF160002
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:43:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WMzmNr51;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767372223; a=rsa-sha256;
	cv=none;
	b=paN83CwEYjCqnBpN4TjXaJuA/qN+dyO8INle+n5iTYIvO7V8ECCVEw3ipCQYpste+BR0ua
	obLUYsUz+C6cuj+wxMWog8akZ9Py0OSCS9TLHC0ay/FUQI1SdQfNIgKHgjZwn/jagrMlZR
	SpmPAoMVzMQzGcKm8QZdEw1s+wF2G9k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WMzmNr51;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767372223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNfLrQjp/p3L3Sry3hdlByeYf8y53FPHj5UXmLcNYRI=;
	b=QdQgvB3XPW4bNqheDGPRJWRKpRq+wiGQwI0hGSElO53LwXjIr3kOokbMltg3fFDsZh//qD
	D07OzrHJXQjvDLTg9Uj/YyB/Pgj6Y3NtMGKeOlgiS3KXUofsPTrR37bPo9+W/wwAU6H2vQ
	V5bd0Du1ZgzDNUyE/POXz+kA5wo+yZY=
Date: Fri, 2 Jan 2026 16:43:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767372219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lNfLrQjp/p3L3Sry3hdlByeYf8y53FPHj5UXmLcNYRI=;
	b=WMzmNr51WTVi6ClJJ1cnbLSLvxkjGjvlz92q4TR8JTo1n+CYavpsdQ8AJQqa3u7jhJjXkS
	Jv51XdM0pk5CbMr9ItfHfOQqQmcQg1J5n2X00iax0n8cP43UAZGMh1t7Z4EgvZDBNGR56R
	rLVP5U4SnEYGUpnTQkXkV243NyyxQLI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Pavel Butsykin <pbutsykin@cloudlinux.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/zswap: fix error pointer free in
 zswap_cpu_comp_prepare()
Message-ID: <prkvck4d7m5tra7sbonygvd6mtmdqj7lyj5wps4mjwkvunpkol@lm5sefrcedgd>
References: <20251231074638.2564302-1-pbutsykin@cloudlinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231074638.2564302-1-pbutsykin@cloudlinux.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 46FAF160002
X-Stat-Signature: pmrg9kegdcjkxmqz849y8o3rojqpfmum
X-HE-Tag: 1767372221-360917
X-HE-Meta: U2FsdGVkX1+yo460mRhpvOJCr0yZfQNjVZjufC12TYkAwgjsPTXZVxVLgbKpIb5sPBjL6q6U1IYPl63aMVfAvPDiiurqE9TCbIe95fP7j2gPLpk0un/eXr5y3CN6+3eOZQZVxJOxfZa2WDVrF0lvdvJP199EHYrKEHDygQMBIeud0cvvrJXh9InuSq5nrZnoWDkhXjK+m4f98HCoMaKHgwWadHipOqsYbyiFbNmOdgWdWrtjpOupDrGBCnYjIEtwsFUZklVTZzgAQuROxVCC1AFX7FOArS2H/8yRq+07rinhgP264Ly85tEX5FXcChh9hc1YPRup+iy0hHV20uD8fJ+Vma/lB4uiRSy13+Yc8qI8EomKpclaMCU4hmmQDilhqIqB4yT72OO2yCesjJz8djwYY/cU1uVt3qji/yN5NFtQ9GK9qV9E5MSZOL6pbqapQo45k1pcQopNTCxeaIfGPNxMyUmuz4K1dyX2b4B/uQOPYc/dEXFXe1xjyxVbMaGw0vsecI6IXP57Kbs/T265KfbNjiP9Y7W7KmXwruyIIWL8zRtsy76edLH2vrP5hV8Y1pz+KIrd/CokN+DhMLIOLpW3m5WgZO7iva4HgKODIwFLIWVcVmYuL4B+94EX24mjn5R8gTz/xq/q5QyMHH2Q3xk/ob9NThUg77HWqZXpvuCpeU7OiThbhMEYCQOW5MUxcRO1qy57i6tm6EPcdoJ5619P2BMyF6S5gUSC97fFFkU03supjbM2ab2Cp0uMIwOn5+K8zTJ+0yx3Ft+rQmVRvtVrq5m0gGGQEcVUaFCkvroJprPGTmWrB6g7vqFMPIRxLRIOm4Oq18GqWFKBMNrqPKILh1gLKRr25yGMM1+wBwkqq89Mvbx+DbmFTJE3VF6ZkpB8cSOvTX03c39jL/Y1q6poppOmsPTJUafx0SXlE00bPX+GIbekKS4dMetut/cfSJg4bzj6p0/4XfQFK6J
 Uhj5i0uP
 OEuvk4ttOCXJld6x5oOKQ3tbb6dmVwe++1LgEwmQjqbHabJLCME3g3X8wsoLoCPu+Q56rv/gQb4CUVczqS0PL2rHu9ScAVQfYzWfyurrqKMjDuV9yMWho0o4GhdXqGPypFon25jH46i4GvB53rJfANCbBUzcOajQhBNgbdN3RnSzfEO6yQzRvnTx6QGO21CLjPGswI2GEvpEmNB2tVb14cQBpjipK1xndn51xZ2hht5+dMRu5Rp9lwNIazY5ZnB9w1vn7UQbhB/LIv+Vpk3Ru2/oYeyyFjanzWDi7TJRFTRLFt9zXZA+A53M8q88aID8yebKEaoms8i0R8VNjWsffTS/VGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 31, 2025 at 11:46:38AM +0400, Pavel Butsykin wrote:
> crypto_alloc_acomp_node() may return ERR_PTR(), but the fail path checks
> only for NULL and can pass an error pointer to crypto_free_acomp().
> Use IS_ERR_OR_NULL() to only free valid acomp instances.
> 
> Fixes: 779b9955f643 ("mm: zswap: move allocations during CPU init outside the lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pavel Butsykin <pbutsykin@cloudlinux.com>

Thanks for the fix!

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  mm/zswap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 5d0f8b13a958..ac9b7a60736b 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -787,7 +787,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  	return 0;
>  
>  fail:
> -	if (acomp)
> +	if (!IS_ERR_OR_NULL(acomp))
>  		crypto_free_acomp(acomp);
>  	kfree(buffer);
>  	return ret;
> -- 
> 2.52.0
> 

