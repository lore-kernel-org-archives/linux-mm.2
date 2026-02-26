Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE77FD9E0A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472CF6B017E; Thu, 26 Feb 2026 16:37:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44AC66B0184; Thu, 26 Feb 2026 16:37:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380DD6B0188; Thu, 26 Feb 2026 16:37:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2064E6B017E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:37:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C00DF1B6E9A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:37:53 +0000 (UTC)
X-FDA: 84487920426.09.B4F4ED0
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id D528716000E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:37:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gkT6Ulij;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772141872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DcdznLUrOcDmYG/a2OAhCexa8EAGJv2HXxaM916vS+4=;
	b=uWGxGphbI4YWUqRLUmanoqeytg6+USGp7I+vvUnw/9zNqpp5Vi50pcReEybuhGqKxYm8Qe
	D1HLOw5Z8KgyCf7/Ia6eX3NVq1GwTPO0fN0Mqc4cho7HxFPE2NNw/3YkCPdk0eDeayKpwa
	ug5HbdOnAkAMMzjEi9ZSJ5WaEgKgPxc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gkT6Ulij;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772141872; a=rsa-sha256;
	cv=none;
	b=THGr/qtgSTxPa3L6Zz9Zleukd7kT+QJZtJCghBwfVOUttRE+lSPM433/aRMP2ugZ8vEiEy
	S7PCYoOUg6KMCaE5+STlOTSz70sh+4WL5FniIpXgGSMdzh6+Q6o2ixNFUvFDDoJaXRIX54
	bHoVaSArn1TGUQvb/moSBJDOPnZbUIg=
Date: Thu, 26 Feb 2026 13:37:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772141869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DcdznLUrOcDmYG/a2OAhCexa8EAGJv2HXxaM916vS+4=;
	b=gkT6UlijS0Kh4njOGpNrZHm+ANe8rI2Cfxg81HEL5UhvGGvUPTXaIXh3IrTkVbBbG9NWJj
	68Jj9R6Hw6VPjJ9g3PxxpSnXd0NymJ8vQQwW+MZKFEEzZ52nGcpYQI/r9l/TJ31Tt7PL27
	x7gwr5+lsU0JMaAUQ8VduP7e9/YsZL4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jens Axboe <axboe@kernel.dk>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <hoangnhat.pham@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 3/8] mm/zsmalloc: Introduce objcgs pointer in struct
 zpdesc
Message-ID: <aaC80TsqmKpwFzQf@linux.dev>
References: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
 <20260226192936.3190275-4-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226192936.3190275-4-joshua.hahnjy@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5pqt48s6ojytxrugi15ehhw5bn7wuy46
X-Rspamd-Queue-Id: D528716000E
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772141871-40213
X-HE-Meta: U2FsdGVkX19wYQybjJAToO/zs/jMps8u+X0vvG9bcAn4vTXzqukGXcGb6QdTlCg1Y57R10TNV+yGeDgKIClHJJX7N8zVn4T/GMvtSRhXSo78SGuQDfX/lethPvCD+cdrNJgFwyQiZoBInURM0KJIvH67Mj1NJgMnVG8FaO+lXY//klzTcWKKhsbAI7P4NuNtoEdcLMXT7/Sb87oM0FBWUXe7poOxiT8R1hSlQ07KvnHZyvMgWOMDHQJ3giltJ+OkQA5j71RBKumnq1A4hllpSDIhwtg3o2tpSaQaNatj35isWjkTvDywqSHNn8/hJvOK/51zKshRpEhJ5pkHk6BV3QdaAz/mb+Zh5VfJ7+r36URzTxo54fANCY6wffCC+qg8d/g7MbKRl7ailIlHWyk8Mj9JtF3qvShZoz/SApMrCUdAZyuQ5aUBD7FNUFL/GWJJ1LCOTAAds+OgeNQ7NtXvYJWYf02m9e1tjxgXvdpySM3Im0ID5U8F9dT1S5Njd5iHnzI7I/X8C9blYrfVDXliY32AXclOfFge0oiohTo7Hou26L8F5HB7nwS6mOsdcFE19QV9hbQC6QFopQBzEuH9HpSoQYtQKgCGFLQ09djsVs9vjPjZllKzTI+YBPLdm/P9ggARwWqicjJkFhHlqjP3tFzktNHEiXjLFXFoF56bidrHng5mxlLFTZbhqwftL22c/wEH/xZjSTV+if0+lquyyzi493/UEuO+XbU2SPcTtA0KCjtg1IiFcZGfNtegEei7QyTMO8PjMEpA4KH0HKkGFUfjrTCLW+cNdd+JwfuJUCBv1WwbO162CB9UqEKMCXmh/vqgsZU1M7xlBLsqY6ajgCemB58yUrDYekcUsGogDHtcxFr+VRFP8HNs3tDleYgRrij4wgQzAAmnKxIZFSf21SuMuDgDYrqQhzxcmLSiXyvUdkgRSfEQh40MEvnEdzDyqslB8V//+N+eDBNR72/
 Hwiwb6gd
 B3MFulTjE4UrfqHP4YSHPGI2Oe+GLPzatENPwmY7EGGBqRmD/FBEw0bZ4rnNQ4tkDXBtpUYOqVnaKjPB9bg/fyGzAa3kmwADSfC5No/toY56HdOZ3CaMDaXZMiRUCS5ZL4lQXgT5byXH6lwop7w7XGRDzz7HQVEk3gW53raIl3u9zkfkvoCoFKzvGWfzK3ZlESBdX4RPUxijqKlJgdxOFxoWS6hTq4+IpN7OzNa3Bg/LMf+GxTYKRSRSmwLw7+yptkzJPm3CDR3bcPyJv1RBix7JQcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 11:29:26AM -0800, Joshua Hahn wrote:
> --- a/mm/zpdesc.h
> +++ b/mm/zpdesc.h
> @@ -20,10 +20,12 @@
>   * @zspage:		Points to the zspage this zpdesc is a part of.
>   * @first_obj_offset:	First object offset in zsmalloc pool.
>   * @_refcount:		The number of references to this zpdesc.
> + * @objcgs:		Array of objcgs pointers that the stored objs
> + *			belong to. Overlayed on top of page->memcg_data, and
> + *			will always have first bit set if it is a valid pointer.
>   *
>   * This struct overlays struct page for now. Do not modify without a good
> - * understanding of the issues. In particular, do not expand into the overlap
> - * with memcg_data.
> + * understanding of the issues.
>   *
>   * Page flags used:
>   * * PG_private identifies the first component page.
> @@ -47,6 +49,9 @@ struct zpdesc {
>  	 */
>  	unsigned int first_obj_offset;
>  	atomic_t _refcount;
> +#ifdef CONFIG_MEMCG
> +	unsigned long objcgs;

Why not just strore struct obj_cgroup ** instead of unsigned long? You will not
need to do conversions when storing or accessing. 


