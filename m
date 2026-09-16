Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCC74C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1136B0092; Wed, 16 Sep 2026 02:22:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7843C6B0093; Wed, 16 Sep 2026 02:22:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670C66B0095; Wed, 16 Sep 2026 02:22:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47C8E6B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:22:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B20451C2B0E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:22:16 +0000 (UTC)
X-FDA: 85218630672.28.DFFD259
Received: from mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
	by imf12.hostedemail.com (Postfix) with ESMTP id B9A5B40002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:22:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZWTIZf2T;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.60 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789539734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PvhEDF8P6tFeqHU0RqeNnpgGOa2R3R2jBwKZiJMYM68=;
	b=MBfXsUc4LD75H7HhxMcWzMpilcEDzWm9w1wHAwWaAAkmFnANHW2u8bkyw1Qj/6J7Sw5zEL
	FtprxCVjGjOh3UrLwbqy8aAmG8UwHd2G11bbg6PB81tE7YCzoA+VBYJAWNtldPOCYvhlb8
	IF9/sBLReUaHthHFOAg4cc2ByUw1AtA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZWTIZf2T;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.60 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789539734;
	b=pL+Jjk9KHtEY0GROhBBN1Iu3N9PJf/6BFmAC1nTsF9dKenTwmAw6HwFDR8vxHmtgSkjCdr
	HegqNZBZcI0tz9iQEI6ZNLiYDxWzr7WdAFb0rX+5VV1Leaw6pDd1h6aJ7XbCNxzC8CbADJ
	Gj+0deeJTNcoI+CtzRz5Er6xGlmrgLw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YlPmF24/qdfUtbjliorWHCseDb+NuqTVIkvqtyPqIG8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789539729; v=1; x=1790144529;
 b=ZWTIZf2TzlgZE9cyj9nuhjbV/vWcj4Xkc2GeEWp3V2bIvWWvzvJLrhyoLJXkK2Mxs7J05wSF
 s+nU1INAeAEXZghFcLAuol434rT/ensFGJmVIoRUDTXVY5EgPcoFQRdPhI9+za3uL1ofr5hDO76
 Ab00mVnmQatk3/yPRZZxoqww=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 749b150985699eb0;
	Wed, 16 Sep 2026 06:22:09 +0000
X-Mizu-Trace-ID: 749b150985699eb0
X-Migadu-Flow: FLOW_OUT
Message-ID: <4281b7ac-9778-4d5b-bcc5-aea42f4f1120@linux.dev>
Date: Wed, 16 Sep 2026 14:23:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] alloc_tag: avoid implicit padding in uapi
To: Arnd Bergmann <arnd@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260915202404.3568029-1-arnd@kernel.org>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260915202404.3568029-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B9A5B40002
X-Stat-Signature: rfu1brnqbwukrbdmkipj7arxe3ifgub7
X-Rspam-User: 
X-HE-Tag: 1789539732-568140
X-HE-Meta: U2FsdGVkX1/USrOoDHmPJpgDQV38vb0cxrP8aDIxvu1puWmFWwS5QhxbJynjccTjFRHvGP8PWmirT1SLkvwhPwnf1UGRru4OJnS/nJkK2hyvMFUgIllzXTgg0f4tpeqpaKLgKQDfpXIZ7IMZnfeFuF3S++G3P2fpirnKfmLCU9eq4TGhMeYPGU4S/8/ILELHUTVr/lmAS8OnE7rcSZDAaSLZDWxkDzFLNOUgTskaxXxIr1sIrod3RAFe2L7DnJ25ulQQfN/KUcNwtqNPwnNMd8KdIXiqAbra0FenayK5456GWcElHZpjIKJBxDtmJJVMt7Z3HoTNxC0o2ZjuTra2Zt84YxIRe8t7cd3wEG5e8S3zWP7AckS1xRAry9whGhyMMfbztRY+qXE6Fy7Xdh27Zo8yZOiP53izLXF7TKGp48agOS2DkdwU35BBb+mJd6HLw+JDEB80fRmA5cur1cLHXEhbG3CcOn5CfmTUHwnA73zw1wVw7AyVt/ZDJ9XACLmD84LvK/aRUoQTnjva1GxnmiF0Uk3K1+6g7LRhnl4tn+4JRvtQSoRYiGGSde81Hmt7tV5f61UAH0QnVUOBbwhD6+TYZ4JaDDZ4amCOxO1FIV9I8e+XmZ+YgmrdHGVHu1iuaAix8c3imwVayXhkn3IKfLMllWhgULalP/sB+8ueRmJNDH1bad2C4k9/WL5binIdpe6CnaW1/nkv9IQiviSE74ypnxUZthVBRgp1kK7cqTinbNQ6PWS3E/dufMtLzd3ljcohq+GMYRnepoJtE1MPwTpiRJP5mPS6wr30baoYpriUgyJWSSiNW30YeAl24RsnEXWnO5PCN0iJU6aekjp7wV9Pw5Te+X9iR+4haGtUPdDSekTOQCFGurJCNiwTGXQKPoUHO1qzR80r/BsaypGxFthOO98jfupqjT88snXS2zheB7Oj9S6ISilnI4N3u60bFJ0yrsjjXem7B2iIUVg
 HMIyrWkM
 n5J1yQeZZsxCjdY7vcwCbETOpjMWNnWuf4FeQZkLw92e8nukVD+RSb8xt/RRj5JOI6SZ+ooVACLxCZWZ02RJmbCjuksyY6sgCriIMb8IfgEziDllPwwMJpSScpE9WybxzE+AIxgIg/TlgqWLz8p7lUW/WVn8vH/7tE3QFoV5Sc5aHCMja+pfv7BWMSlm50MS/Ay/5MJQVsSbvArB51Gygff0BneJNiTQGrnq+UgfVFiYA4r2U8iuQGj+NlZfCK6MBmHZXb1EJGnogg07Z0zniElyjrCeXt7tFRAyBOPGDYOt7s9YvV1/7z+pbphnJ2pKMksoA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/16 04:23, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The impliied padding causes a harmless warning when testing the uapi
> headers with -Wpadded that could in theory indicate incompatibilies or
> data leaks:
> 
> ./usr/include/linux/alloc_tag.h:41:1: error: padding struct size to alignment boundary with 7 bytes [-Werror=padded]
> 
> The code here is fine, but it's better to make the padding explicit
> and avoid the warning here.
> 
> Fixes: 1d581ab2348c ("alloc_tag: add ioctl to /proc/allocinfo")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for the fix, with the nit from SJ.
Acked-by: Hao Ge <hao.ge@linux.dev>

Thanks
Best Regards
Hao

> ---
>  include/uapi/linux/alloc_tag.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
> index e3ad94444864..7d4618bea043 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -38,6 +38,7 @@ struct allocinfo_counter {
>  	__u64 bytes;
>  	__u64 calls;
>  	__u8 accurate;
> +	__u8 pad[7];
>  } __attribute__((aligned(8)));
>  
>  struct allocinfo_tag_data {

