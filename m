Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA33C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 04:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20FBB6B03A6; Thu, 13 Aug 2026 00:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF966B03A7; Thu, 13 Aug 2026 00:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B19D6B03A8; Thu, 13 Aug 2026 00:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8CA66B03A6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:48:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 286C5140534
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:48:07 +0000 (UTC)
X-FDA: 85095014214.17.3BC5A7D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 73E56180006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:48:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=aPVQTkzV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786596485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X47MPVqgH2j7yjBZtNKgYko3YnkfVy3n7gkaPS/96cQ=;
	b=mqtgCbVv2xqbDbttYNxAobJKUsPiwrdtUB30NXvZHn7KSOYgBBG+s5X958GTw5rng2b+AM
	seRYaxIFCE+PwUrQ2CZB4IlWYcHWdGWlBWlpw+AUAu94IcPU9oZ7yZjgka+SkrPH0jBdAr
	e3MhLGUW5/ZEXiFbcksOv4E90BCOZVQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=aPVQTkzV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786596485;
	b=skAfQ2JzL/9x5msiW2YmlwlrhYHuzUzv1zkmbVqK28B4Ouozy+5OUVT8/dWNlL5HZlQ0cx
	5wxFo/Aw6u66IZOUgYWw4/ieHUDKcvfviJ3TxNVityYgsTf4VnLby0f6EYgE+rCrBJPpGd
	4Q4jTTBhiqFJOlhRXQPXVBmXUOJ1xBE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=X47MPVqgH2j7yjBZtNKgYko3YnkfVy3n7gkaPS/96cQ=; b=aPVQTkzVS7E6M9/5/2lfJV4m2q
	Gu0rh6frlDfMcSnfCfzfJxPlCvhCnRWvytHDe2MvJV7aFy+/iw78mYWkbRuj0Et2uLkVfWNPYwFjt
	7MX4olLDVkLGSALLckY3nBCfH9OxyK7Cgp14IvTP+QFhviqU5fHrHvo4CYWuSswAiCwkQx7foVSfn
	2M5vihwXhFVUwLWmAMHdQUkgWdxxNoRdwVhBfarGenWyUvDVeDBQc/izhD8SJBQA+ZuNSOKxmI/x2
	GSsJ96EoPM2xk5+HFi42U+OetuCC8wjGZhsk0yXIgpTvkIFp7XNFipP1fQV5qUFfa6M5+VJvi0IYz
	kBu/GUrg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuNMB-0000000HNTC-3HH2;
	Thu, 13 Aug 2026 04:47:55 +0000
Message-ID: <892cc7cb-20ea-4d63-80ab-043538fdd7fa@infradead.org>
Date: Wed, 12 Aug 2026 21:47:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] docs: ksm: fix typos in sysfs knob names
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 david@kernel.org, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, corbet@lwn.net,
 skhan@linuxfoundation.org, shr@devkernel.io, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260813031722.569983-1-tujinjiang@huawei.com>
 <20260813031722.569983-2-tujinjiang@huawei.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260813031722.569983-2-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1f1ass6rjo5osz17cbftipdkay5axsud
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 73E56180006
X-HE-Tag: 1786596484-567733
X-HE-Meta: U2FsdGVkX191SxSsjyrCLRmtfqbfRS9mT/tZfU3Q1jJ9T7M6brJXpuGXrz/TeIrAiSMiB9goRaHP6XcLdvQpfHcqJAyrtYg1yW9m4emGb8kZf+1gDlhOdW6rj5+1Y07ZCG3dHGL20kBXrR7QubVwJWKeImHc79WREvOPeLAb08Tj1r5CAJMjL1mE8PV/jTU+JVB213viL/+Cx9T/WXge210sUJI8VQSkC6q6rZKrvEBFpWiz56k1EVZ+UVisovOv05i+tYgq+chp1EQP+CSxhqsM1SWI3Z7dX5l5vj3BpuOWCC9LJUf2u5pTwMBEQ1AH1WPsaHfEmPz7WEuDEb9JPdphR/g/L4xH7i8C7brenjHsN3NBwpM7OvGIcWsMIMmLXVqR4ubvO2TC3lVILDAXVTe6XsHep8Jvbtio/ktoxGC4evbwjoculav+5w27aJwCjAHzxsPJQv+CcTIJFjmZfUVGY5swiyndY6NIGV+rpSDyUK1OvkHI7PmRlJPlMCwklJIGUx0pn37AiidE0ZRrcU7N7m3A9sXMKi76Csd5WUSLEGSKy781XhOJqbd8ZtlD4tnqVqdVOYauCoaP5QglvQvWBqqb4IAB0YEVI05U083Hk5513GPeQieQWuQ9lOK6QxoB94mgwF5325+ZPsloma19ZWl5AyCoNVM4H92aVU3k3H1Y63tyy89083qLSj80+s/n1SZouske36VfnuUoWYG73tEhO2tHqevDYsbdkPqtOaQK1xtMLX/Z0jOFlKvwfzqn14I2v6/E0S16H+TYdT3u8k16m0I/iRu0cRNLxYhbb+7t3kfATJdQQ3DrwnIuqNHiynibSo9qIiQK1OZzROeSCK72CnLQRSiKuU78SFTV/+E3JRurEzY8fPBZl1e2iIoktOYkVtnwPcaIXonlOL8zd28GzJ95Jp+wilsYZtwZtlouABI5X5NvEAF/dIHwNn/fm/Ild9S20S7P9fz
 SBlOlt8q
 IdUCyWCwgq/egrFtDAhAcn6d5rX1/PqrXrZEj0sqLjdUREs2j4XxIH18sCiyefHL9CoqoMo9ERJ5IjIRSAT3mrowHqKHAWnt5QLZjIijJ8RfQd0G6ok3qxNjlMjrfRurfSjzn0+ErygWxYvNGO25l5l5p+YAvSoml/47/apnzRJ0T7/YfTNGF9ATemUJJG6t3ft0vQXkNzFQKfzx6L8LJigPq3fh/uP5w2TRU7VtVDuAzZxGkQLJpAv8OnrG1goOYaAHg2T7MIXvESk5A/xziYq9UvP0fCBCGVha/9HOKDA+146FfzdAJpExF/yqvervCrgaHVsN77dbx/O/YM67hzHThH8T/aG5r3mZzpZTxs7W+s7TkqNiHReL4pPBpGhJCuSQXGTAph6fCqxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/12/26 8:17 PM, Jinjiang Tu wrote:
> The sysfs knob names in mm/ksm.c are "advisor_max_cpu" and
> "advisor_max_pages_to_scan", but the ksm.rst documentation spelled
> both as "adivsor_*", fix the two typos.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/admin-guide/mm/ksm.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
> index ad8e7a41f3b5..c9f533b10f6f 100644
> --- a/Documentation/admin-guide/mm/ksm.rst
> +++ b/Documentation/admin-guide/mm/ksm.rst
> @@ -174,7 +174,7 @@ advisor_mode
>          The section about ``advisor`` explains in detail how the scan time
>          advisor works.
>  
> -adivsor_max_cpu
> +advisor_max_cpu
>          specifies the upper limit of the cpu percent usage of the ksmd
>          background thread. The default is 70.
>  
> @@ -186,7 +186,7 @@ advisor_min_pages_to_scan
>          specifies the lower limit of the ``pages_to_scan`` parameter of the
>          scan time advisor. The default is 500.
>  
> -adivsor_max_pages_to_scan
> +advisor_max_pages_to_scan
>          specifies the upper limit of the ``pages_to_scan`` parameter of the
>          scan time advisor. The default is 30000.
>  

-- 
~Randy

