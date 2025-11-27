Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1A4AD11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 13:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CC06B0012; Thu, 27 Nov 2025 08:38:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206776B0023; Thu, 27 Nov 2025 08:38:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11C2A6B0027; Thu, 27 Nov 2025 08:38:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0BD86B0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:38:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 940151A017B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 13:38:12 +0000 (UTC)
X-FDA: 84156490824.04.FFAC8B5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id DBCAFC000D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 13:38:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CYQmgCUv;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764250690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXTayqT+jWC2OgM/D+gkYwRW+R7pRP8DmuGQlMggZQc=;
	b=YZLZHcykc59stEs3GsADjsaRuIj7wFoUZ4we3jna8kRCtUXomQfwmal7sj33o7uzCGBReV
	lLPvHfff0PN3fefnOLHgYnFA6Lk5HwLXlQVEKS5HQZlA7lOBxZ9+0vq7RDBbuzOQ2ATyUh
	o8tqkwIBuLRgEo7CXeHIw1DthASVFc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764250690; a=rsa-sha256;
	cv=none;
	b=EKlSFkjXDNL9moEZlYgSt1mLOKGu5mGnBqWpYdoLiWG9hhd35vNuunV1dPFuPSFiOTDujX
	Y2D31QmkWrTJlmfRNXgNre3bmMcXV9QNgwO2bTY/q1XydwtXMuQRJp4PecRTzViuEXiKle
	kOkzBg0DUAkiD2zMJZ4QVAI/sbInf10=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CYQmgCUv;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hXTayqT+jWC2OgM/D+gkYwRW+R7pRP8DmuGQlMggZQc=; b=CYQmgCUvV3s7sDVVXn6jnlyHJK
	tp3nf4E0tS2EK9cGXAh4jWdxwhgMyeUAaCERWDTPY80RC4MgmsR6bDEfa41goO1al4Up8kezWmzmR
	jBeoqtJURsmRakBPyRWvGdgAMMpAJhNnkQAGGhZ8rLfW3c4rgKaoFjQh5GknE8Z3gzNCuhfqByMHj
	Mxe5nfXIRW+HuXw5PHKZvfRTJLMaL62mi41dBf1iJj+NmmqmYlXJJJ62IeALQPZLI7V7j7v2cYoFj
	tTQBnqzQxmEPWXhjES5zcZEl/XO5a186Zo4rWekftkgWlhQgBCwSjmW3VNk3vlJi+E/+QJMmjF+Jk
	24QY9O5A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOcCD-0000000Bn0y-3rnR;
	Thu, 27 Nov 2025 13:38:05 +0000
Date: Thu, 27 Nov 2025 13:38:05 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jan Sokolowski <jan.sokolowski@intel.com>
Cc: linux-kernel@vger.kernel.org,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/1] idr: do not create idr if new id would be
 outside given range
Message-ID: <aShUPdV18CIxvV-G@casper.infradead.org>
References: <20251127092732.684959-1-jan.sokolowski@intel.com>
 <20251127092732.684959-2-jan.sokolowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127092732.684959-2-jan.sokolowski@intel.com>
X-Rspam-User: 
X-Stat-Signature: pify8k9b4yz3yj3uyi6egzyxegs6yfue
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DBCAFC000D
X-HE-Tag: 1764250689-192344
X-HE-Meta: U2FsdGVkX18C/+KnUiKqwC9h+j1Go1FvQuxQwe887lJQhFTRmOYUeEu4MlocZYP6ybsmLiQPaFO25guylxxYusAiTf9NFppC8nNFTRI1+SQdKbdQQN+hNIFoZg4lFW0vBRBcgetQ9Up0hDanbfFJGUCDcGddv/rp2JPwwlyMNypzC+cluavdMck3qkczrbfM+pO2IykspKX24QF/8fbGIfEcj1B7TpkUgI/7rdo996P9IkH29swsmS1wG7pPvmRyIjpzqx+gn+EpscDV7+sl/h51dShzPj+nZGellPA2a2jS0Y8NhXmNFKota/hTZtprUEEKJlFSZDy1ynXrq8SaYzcZBh9yf8lGA9t1h2SbvIV+0nyefDgZiGL2+LAPPX604F9KAYcSBHXy2HsROTDJrojaW5jKeBaO3gRnhV/ScwP4mA25XYNoQ/BRRRE8P9Jxbt8bIe7ZSaQ+UwCgYUGzNhi2z/OXWI92YfeGudYXTInOq/Hd81kFyGa1n10TqQ/eAVElhiinx21A9akjYIfNTg2xgz1wv/f+Q6IAjh+aeTpPbWYGw7wT7kd7cQoOSrpKuX/wow5t6GMqkmdJpzE8PaFWUq68CEh3xcyIC36cpvG+dPg/YuUmJ7YIbCiq8CgrrXOOwKbgEcEScb9SodWrFTbzmPJoUMz/+L8n3l036f8YvIPbIuwDlWo57BGXmlvuj/jcm/gj7JAAywNYW2RiswYH4yTo6teIIIPMMeviQQ4HR5qFtMs18YI8+BaLwuS+R84vLFXOBMbt84QgpG8BYZVmTTf7cxNy0ALHgsXyCatmunuvr5Pu3BkzOv4XeWi/GHILnjXYRPIqXEIxPQXDzqaY7hOfbiaLEypjaS41tCDvRAcz4Q3S306jx+xVlkDFFb9P+vHOoama8yP2dsSye7QMsfk/GN/1Lepb3WnyggADoiMrBGs5mWn5AfK+9WZ7Hxtv64Y8tzRob1KgPgm
 dbTb5Ly9
 uoZclsELr6BUGOZjCPbB7pvimuBuRKBv51I1mswmiTpFYHIAB08i1EcPPiyznNdljeXrDKzlzWSqSqzMq93CGIhwefRWUAA52Fnpsv81s4FejlZHY555KHFRHzk7gxyqKANQqRCZT90t0+dhZKjqT3CWkw83bi4EW3sFen22f4eti0zWm/nmIf6XhSRV202huMwsgpmHSSls9LPI3zdknx8lpNWk6lV0PLA5uGBSco9wHDF1enA3DH5QeDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 10:27:32AM +0100, Jan Sokolowski wrote:
> @@ -88,6 +89,11 @@ int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp)
>  	if (ret)
>  		return ret;
>  
> +	if (WARN_ON_ONCE(id < start || (id >= end && end != 0))) {
> +		idr_remove(idr, id);
> +		return -EINVAL;
> +	}

This is certainly the wrong way to fix any problem that does exist.
And it should return -ENOSPC, not -EINVAL.  -EINVAL is "the arguments
are wrong", not "the data structure is full".

I'll go read the thread now.

