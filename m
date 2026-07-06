Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5403DC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 07:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2794A6B00F9; Mon,  6 Jul 2026 03:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250C46B00FA; Mon,  6 Jul 2026 03:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1666A6B00FE; Mon,  6 Jul 2026 03:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0A566B00F7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 03:05:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B8488D0F9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:05:04 +0000 (UTC)
X-FDA: 84957464928.15.F26D0D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 644DD1A000A;
	Mon,  6 Jul 2026 07:05:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="feFpZYt/";
	spf=pass (imf19.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783321502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNbrr+7vMT7d+YXsU70gpKCnA0Dr+Mk7HOfp5wCYwZo=;
	b=zZ9Khi+VtOPvZ5xH3qmMdmx5HjmIAzAIV/uP0gUgos+GqwhaOTzNLYj8Ydzan2abp2QubB
	wdjp55Ii1aF8wwaKfWXAVpWCtNKtcCrFaqb7TZWTG4A3VfZjECMZFGIcuHuDenduZiNWxH
	wTEP1gqAvQHT/TmjGjDSQ494V87FhKE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="feFpZYt/";
	spf=pass (imf19.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783321502;
	b=WvRbLkW0wjs//xxf2bHvWU9lV4kk1RnBuiq6XQqkYOGiZ2m8pIQPGRf4awnjVFYf/wKU0D
	eSL49zJaQTiaOYFijhGsviZI2E57SUcZvpnc2tV7DIWrCUmOE+9sDZEfTPHx4QwrEJVVhh
	b1fSqYUvG/2KdGjNPevpYNurWWyUK0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E4A4414DF;
	Mon,  6 Jul 2026 07:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF3F1F000E9;
	Mon,  6 Jul 2026 07:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783321501;
	bh=pNbrr+7vMT7d+YXsU70gpKCnA0Dr+Mk7HOfp5wCYwZo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=feFpZYt/26Zu6oQDe8KTR4CsOLq8nbovv5veYlAR8oXbRmknryTnI6dTL06QDz2Km
	 4L6h0rGzbcCThuUWIGOgQuketk1b7E8jST5IYWRijP63cHmE20eeT4UbQlbzNyLqaa
	 UeKQac7FEP1jMX+JvUdMlhMBLPaObSXgf5poOROmGxLqeMlOSSHhgzWda0QALdh4Vc
	 xpRJmLCShiOArPmQULLXXNc9bieFXDIpHt691bECXrwOGqFrYZjo5NMrYOFggIxP6P
	 CTaO1Os/viUA2cwscR359cgFmNjbTJ8RMwPqMzDgUzcDaX5qV3cRc1QgSLwdoUew8/
	 94dRKMzW9DAAg==
Message-ID: <f389a101-2af1-4b18-a74b-031e6c1899bd@kernel.org>
Date: Mon, 6 Jul 2026 16:04:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: split out a new blk_plug.h helper
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-aio@kvack.org, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-mm@kvack.org
References: <20260706041125.642097-1-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260706041125.642097-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 644DD1A000A
X-Stat-Signature: zu83sqkxy3opihwgn6jqch9ma5mgcdzb
X-HE-Tag: 1783321502-980893
X-HE-Meta: U2FsdGVkX1/AOnjYILhKyCsIIhRQ0KP3FG7JW23ZmTzRwvGwaZFwmbYGedtpAE3qgkQttOSZCtf6zy7y9NmwRPBKNIBW20aQbPFe2utmhjGbBFK8o78vfLIxt6283mjBRcp5jT4ohINEiCHzjx/C/K5k/Mf4hFKLYSxgXWJjd0k5hVj+uHyBZtt6Cv44jYQ7QHRDSilfAQvg93X9zbHxOz2rjt2lPSM7oYr3j9G2wouZAAeDo2e5mshRxsTYLDIuvQ6QgSuSDFv0uYSpGm7s9PvCunBkFrrPFfLDKlPdWXqFngg+d7U/b/g2r4Dq4tqqk7GiMwldWIj1jESuFMCr74a0pNFoezhnnG5/xzdZFEgQBQdZFrndrMdSa29WnQsvXA1Kd1Y6o/F0C5vDbigM+5HwvMnU6YN2ET7Qk/lqwABVrOLClV+mKqzmfGmURzMq9tNTEk1Nt9lDMCOoLwiZkWvkOSV1dydaVRd0ivAr7/vVWL3O2NnUdDbSFuY2zQwPUu8aDkq6Al0bF976gcJLMwntVqyLeo+Ia2o0WesbDHXktZPNiVRUEO+R4CxO8ef72by/tEuGSW4i7KCVrPaM6L4nTe1b7ePDfyLZFT1IrKRc5ySzdNNUtDS7M14bY1LbEgR2Vrf8ga+ixYEfzII02VLFdRIYvKegHA2JtZNMCcATO1Qxch61eRdsp4d+K1u+4KFOsmkb2rKz6BxVN1LSrAn+RzmmB8ydbeicyik5cPCoLdQKh55ksn5HYEKYxgssMWmU2l7YCuxSxoKIvfwd6PoRxHcaCeT3eflsBakklieocWf8jizufXmnHXsU1IyczvnD2nn7MWQajE41cR169HXYILVkiA+QtCaxj9Y5ZC/D6qSJYmK6DhX6La4IOXwWW9Q6UA+M8SM0oBe1N6NAxBYP8eZw4K/6xaZFmX3JKbFST6I3/FbWBjrqaYXLb+S9RqZhqdlRd2wRgaDImdj
 1ewClfl7
 D9V1+rRfCG7xO/HeaBgS8CKrRZ8po6FjxX820aou7hgvTUzwjZ9fWQ14gCmV68K4LzmOf79j/aJlqGVXIwLS0TVeA3oKokynSQZ4R46DNB1Yt7RicGpswHFd125mIj+429OavrkWwo9BEfe5KIr0MmJTq234Yl2Eo4mDD0pgLOPJAairn3k9hIU2i440inn8P35W8nod7iKFxjFdAPNDOlvm+NGLzrUzwTZ5JXqq4m4INf3eUNAzmIQkRQnWTd+0wVF49cmisCFNGwllAcxqPYSwxADELRkWWvsaAVFFHmSuc91VJ+TjAJjz6LvtsxBr7JjVNnswmy622S8qwv0tKf3HuRCgFlDjVYcgWtf8GdX/lzCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 1:11 PM, Christoph Hellwig wrote:
> blkdev.h gets included in various places outside the block layer just
> for struct blk_plug and related plugging functions.
> 
> Split blk_plug into a separate helper to reduce the amount of code
> that needs to get rebuilt when blkdev.h changes and to slightly
> reduce compile times.
> 
> In io_uring this requires pulling in a few other headers explicitly that
> previously were implicitly included through blkdev.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

A couple of nits below (not entirely sure if they make sense).
But otherwise looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> diff --git a/include/linux/blk_plug.h b/include/linux/blk_plug.h
> new file mode 100644
> index 000000000000..2ac1265662ad
> --- /dev/null
> +++ b/include/linux/blk_plug.h
> @@ -0,0 +1,95 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_BLK_PLUG_H
> +#define _LINUX_BLK_PLUG_H
> +
> +#include <linux/sched.h>

struct blk_plug_cb has a list_head. So maybe also add

#include <linux/types.h>

?

> +
> +struct blk_plug_cb;

Maybe add "struct request;" here too ?

> +typedef void (*blk_plug_cb_fn)(struct blk_plug_cb *cb, bool from_schedule);
> +
> +struct rq_list {
> +	struct request *head;
> +	struct request *tail;
> +};


-- 
Damien Le Moal
Western Digital Research

