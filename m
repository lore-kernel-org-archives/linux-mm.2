Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EADA7E7DF0F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CD76B00BD; Mon,  2 Feb 2026 12:10:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0F66B00C4; Mon,  2 Feb 2026 12:10:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2DB6B00C5; Mon,  2 Feb 2026 12:10:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2BD6B00BD
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:10:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8716F57991
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:10:37 +0000 (UTC)
X-FDA: 84400155714.20.21B4D25
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf08.hostedemail.com (Postfix) with ESMTP id D6DF3160005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:10:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770052235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2KryDkBc0RtNfY7x0xkoCiOwiVZkeetqvmDcbmV9rh4=;
	b=QDHHvawhkwnhDDxoDIhSFfSQcOj2v3IY4GdNLtP+vgD2Cm96IRW7Nm6jwMu439dfHG59oC
	0zx8JMeSdU7zJ1tZJ/aYiV3qhx5hmRcqn2cXnEqFLrzevEvpyJbE+yL7JbTHmfbSqZq4nF
	22It1T2tM1swX1HEdbz+SeSQsEFs1ZQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770052235; a=rsa-sha256;
	cv=none;
	b=KQeM2eGjRoBe79asPdVoBI0qbvuCqNS1E4hl0Iyn6EhtVH27pdFOf7ugWp6oLJJ+JgU7+F
	PameYVgICdcTiQJY+UmBljVMdpr3bPlBBpFdIE1wySQ39PH/sk/1h0trPwxoj0QLJZiPe7
	sdDuiRzua7inpXrW112awdiB0oZcfeo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4Y4t15BnzHnGh6;
	Tue,  3 Feb 2026 01:09:34 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id DB47B40086;
	Tue,  3 Feb 2026 01:10:31 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 2 Feb
 2026 17:10:30 +0000
Date: Mon, 2 Feb 2026 17:10:29 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<kernel-team@meta.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <willy@infradead.org>,
	<jack@suse.cz>, <terry.bowman@amd.com>, <john@jagalactic.com>, Oscar Salvador
	<osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH 1/9] mm/memory_hotplug: pass online_type to
 online_memory_block() via arg
Message-ID: <20260202171029.00005e80@huawei.com>
In-Reply-To: <20260129210442.3951412-2-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
	<20260129210442.3951412-2-gourry@gourry.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Queue-Id: D6DF3160005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: arb5auwki1j6rk1a1e6iwafz4onfsygf
X-HE-Tag: 1770052234-522412
X-HE-Meta: U2FsdGVkX19/YYdU7w9u9vIh5FRKcAtvFYOrctERIW0gtIL6Uqqarrud0z7Uf+xVDY++EK9qUlgLK1YEZ3H8GFqpFhhGifSD+lia8cnf8lg+iO6gzlkg3Kqc/NAJBMIwi7/RIFw5FrAzyELyiJh+7B8J1ZoixLiANOBW00CNUMR6o4ler1UBQW/dWXiU//ccluyUzd8/J9F4FTWbRahCglJG8QcaW2gPsjXdKFEAzumP+cOK8zWRDuTsd5fDG4dW066hsFoPpxGUBIwwJqQGK8hUdvYzgO2/mD4/mlfkR0arhNLUu02XQGgvqAHt7bbQd2OfNV/q21JzmelVu6G9K2tTLVerd4iALXTfSKONS1Nk+rnpR6hi33eTFdtU4grI8OBXx/JvqAaTpVRgTfYMkZ9m5waYHuwMQhlSwmjdz8f0iIpxvCT+4RZ9Ec5NqoocGBqCz8DK5ysVwNzvj6V5Cl80s2JevjPm5iUs6k0cyO3Yi/h6aD8uNv9iS9yArz90xAD8zEOJlsjpi1SNgLVZb75m+tVMFYHTFCPmuVNoT3gaQqLyBSps5o5ShWSCgUsz86cTQg67qsqeOylxYrh/fCIda0bz6WMcaixihMHl271aNiwfJwB0r7E8iNmFS/nAXFfzxnnXuJEGg5eFQFrSZW7+u0RMD/82GMtcXuJbG77FeQPz6DYs50ZIts3tNrqIlmxeZ4QZ5W9vfn7X97+vku0vSuv9EnUXYBBDFW3Bvza1V9ObCTY98Fej1CJm2u2kMbOBas1axjGxWJf9JHG8KP8SoUPlEGQ+ttVlkZS5DM7uZaH61tdTwWvX9Tcxum/nK7lFNHZXKgJJdwf94CPENY733p6e6hYY0Pd1zJtN36D3T8edCoqf7uNHHrdLWAz6Pqs3LdlnvLxHgi+YCuFnUGInYIJjgokjzyBLr3pO6TA45IBpsqLp8p3SW/Qj/H1Z0DvcKLNo+JfUEegkUQP
 UGEvCAjs
 1cyLvIbaputrLrnBY95eFPmmF0bVnyZQoPZvqis/LIwKkEi7fXBlxS8MIHMYL8IratTzS9yWsmODKcCtDpEWg7dT9tssaJPg4duVUBHiG5x97Rt/ywJlW2UvGZ7Ba736EsXPpbJKOfDdCleDMovyRkYYa/V2Lysu9Gj9qfMvR2RYq0PjLRQwYFsatozFpsvAn3/QciwBTqPsSAzLApRrawxcn29fXxEOPpF7Rr2Pu2CJiK/RKkZto1CRlApnmNjtWxTMDJqrE8Q1DTfFDCpIxfSHFf8271qqFlFZJ1z9o3vZAkluHb80hMZX5vNOpIotl4Q37jgxwMmYRTVXxwONWAwMh1nJlZbYYYYe+Ghj4xmYHW0bZVjHUewCichNBOeyDnY8CniVVD6ohwtvLBxgaS1h6hH77Dw8/vyrTBnwiVP8UkJh1qivgmreVww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 16:04:34 -0500
Gregory Price <gourry@gourry.net> wrote:

> Modify online_memory_block() to accept the online type through its arg
> parameter rather than calling mhp_get_default_online_type() internally.
> This prepares for allowing callers to specify explicit online types.
> 
> Update the caller in add_memory_resource() to pass the default online
> type via a local variable.
> 
> No functional change.
> 
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>

Trivial comment inline. I don't really care either way.
Pushing the policy up to the caller and ensuring it's explicitly constant
for all the memory blocks (as opposed to relying on locks) seems sensible to me
even without anything else.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  mm/memory_hotplug.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index bc805029da51..87796b617d9e 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
>  
>  static int online_memory_block(struct memory_block *mem, void *arg)
>  {
> -	mem->online_type = mhp_get_default_online_type();
> +	int *online_type = arg;
> +
> +	mem->online_type = *online_type;
>  	return device_online(&mem->dev);
>  }
>  
> @@ -1578,8 +1580,12 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  		merge_system_ram_resource(res);
>  
>  	/* online pages if requested */
> -	if (mhp_get_default_online_type() != MMOP_OFFLINE)
> -		walk_memory_blocks(start, size, NULL, online_memory_block);
> +	if (mhp_get_default_online_type() != MMOP_OFFLINE) {
> +		int online_type = mhp_get_default_online_type();

Maybe move the local variable outside the loop to avoid the double call.

> +
> +		walk_memory_blocks(start, size, &online_type,
> +				   online_memory_block);
> +	}
>  
>  	return ret;
>  error:


