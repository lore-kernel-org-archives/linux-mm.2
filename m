Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29213CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 06:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503EE6B0088; Thu, 14 May 2026 02:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B4CD6B008A; Thu, 14 May 2026 02:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB1C6B008C; Thu, 14 May 2026 02:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27EBC6B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:54:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B97E88BBF4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:54:40 +0000 (UTC)
X-FDA: 84765112320.20.5AD4EE1
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 645734000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:54:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X6Wi76qT;
	spf=pass (imf17.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778741678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kij2xOO3qtTmYfkoE+CYJd5YmiCf+9U/Mw+qhSKp5qo=;
	b=U+x8rjMFF88BOf6kybWLs9fKM8iukzVkLBMUtLcp61grpTmzI/dUIS95Y4IECXrUfknspK
	ggoV13c2y3VTNUFCnvLcsRx74KvVmvzWuop73TNCIxrpLnNNo6jmOIyK038p02wprNehvM
	KgVj+OSi+GsjOcYaRSjf7Kl6HAYOK6c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X6Wi76qT;
	spf=pass (imf17.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778741678; a=rsa-sha256;
	cv=none;
	b=Y/thnzAg8cfLEBpxXCSpclP2IyXk0MXYpGBmk/KbcJ+HWvNbU9RFfgdgX+6frYDX26/y4y
	ZEneSY5/cMuou4M4R6WfyLL9tW5YJSjBjg5GD8HjZhqvp9/GZzBPjqoep5Wc9/hmQQOvzU
	PzGyxWp9lHCKQSfy68Ejm9R+kXJ5DOA=
Message-ID: <b681fad1-1a27-47fa-b58a-1f639eb3f3d9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778741676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kij2xOO3qtTmYfkoE+CYJd5YmiCf+9U/Mw+qhSKp5qo=;
	b=X6Wi76qTXoS3Rz71tK3B1xmR2vWuhPuLMH2oZxhvhV3dMwUYATyJOmRRxzSeEqW1sWZaq2
	Gk8Q146afLxCkqun/eAO8VKrhsrt4PIM/hmnYqLXaLnUzUOcidHp4NTOrnNtZ0+9nyNHvm
	8L1XkK9V+PTogJsthV0vrCszTFfSeQI=
Date: Thu, 14 May 2026 14:53:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/6] alloc_tag: add size-based filtering to ioctl
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>
References: <cover.1777936301.git.abhishekbapat@google.com>
 <06b4fc2457fb4b75eb1ef18320a8722ddb5a850f.1777936301.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <06b4fc2457fb4b75eb1ef18320a8722ddb5a850f.1777936301.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 645734000A
X-Stat-Signature: syzkktqbu3gp17e9yeud9p39acaqykh3
X-HE-Tag: 1778741678-480993
X-HE-Meta: U2FsdGVkX187NYpJaT59SrzLty5WUP8AvsweGY6e6NCj0EOkRM9uV5QOf/Nec9rDJ+Em39cQH+bKUt30mFqYBOiKbNlcZwpB+pAS0OtWGtFnrGSCrzkDrS4sP0gfWnmCrw9rK2MxoDArjbjTTFO7A1zi5qjoglVgFGDJpLFG/YsfXmcDG7jAQPIH/XcJr4h5dCMHHAJf+c6Xll18NmeObb1t4dFSBOQGUYhw+1h5kwq/pVGNSWqrPW94r3fYM9Bp2UzJBvLafKyxqPvZQKhXhLvUXtNyQ0GbpG6SqvVz0CMxo5wky6/zNad1N9+TKef70VEcELegHEaIGYv/dSZ6PfSPp1mjOwrn2Xo6OwpH1VLXAIRof/sS44bFbImrcbrnFb3SAZJcKzCeC5T29sBaYAX9iByI2aCrFe3kNEaB4qoe8cULT8mCMpwLlWOdDXL8JhxioDGwxYO+URau3ogeRcDkMHCwW/3eE5DtiugAo7g79EWRzlDBDnTKoGENAh76W6FyxNqgkqXYp2CF741WnK2VJ/rEUA2daZZgPN1jz8+DxXLbxz/1M0sIWrPd1PuN6WRNt3PdCl93o+hk/BL0w19NT6Hg1RQlxhxOZp8amCufnSAndsVRHAxI+vYNEb/KSpB2fwXiY6p0w4HqDTbo9ulICBuW+6lk5qK6G6CwRlBrSNhLRBhpCoHgzxRF2rUEsjmM11urVWM76vv5zBKHAU92gp9EcF9KwBgyQ0Gt6NClE5b2g7YmACuPQdgdy3P+bpc/FzL5gBx+sbu/W8gccGtLYAHySMzu9ui8ISObk4LvLvdc6Ka1OnZFx8SFvBWYLBt6s6HGm/lIPgZVvJUD7EHJdwiezlaw0MTm9X2Y6fgLoWNW5i/9dWZ+hPOJ0LM249h4JWfEwxSXYZACALnZvc8fFxvO/2KTU8Y/7XdMna6FWN5Ymy6cB4D0Tn5gzAGY/13WhP/rjbk+C5hkDby
 Uen7IkO3
 /WhJZF9SWDYzssk/7DpIp5mxHn8PZDGQvmrND9zC+kx1gNqMSY5LBUL4ZgrUk3O6jVjk0IJIwR0nrv1gDiVWHimZyygdgGWHlTWsPIPzY6TTS6WPU5qkf65Be4bwSpUSJ+pC8qs+vaXYNtqmbrnQqGK+8xY7tF8r0Q4iLSGFpPGUGmyLV+h9WIgjB76XKSGY9C6/4TheQPicc9AqbNioQmAE/nTRYzEITqushzlRoc0tCHRPSLVTrtQeuBTsX5nTlJGZGfwLtW/1rA/JiHhmBwXiIn+bCqmU68EVPZP8GamluJ2FOEVlY/GJOfYmvqDrbqMx9CjLyf0la4VM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


On 2026/5/5 07:36, Abhishek Bapat wrote:
> Extend the allocinfo filtering mechanism to allow users to filter tags
> based on the total number of bytes allocated [min_size, max_size]. The
> size range is inclusive.
>
> Filtering by size involves retrieving allocinfo per-CPU counters, which
> is an expensive operation. Hence, the performance of size-based
> filtering will be worse than other filters.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>   include/uapi/linux/alloc_tag.h |  8 +++++++-
>   lib/alloc_tag.c                | 15 +++++++++++++++
>   2 files changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
> index 0cc9db5298c6..229068efd24c 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -20,6 +20,8 @@ struct allocinfo_tag {
>   	char function[ALLOCINFO_STR_SIZE];
>   	char filename[ALLOCINFO_STR_SIZE];
>   	__u64 lineno;
> +	__u64 min_size;
> +	__u64 max_size;
>   };

allocinfo_tag is used both as a tag identifier in the output data

(allocinfo_tag_data.tag) and as filter criteria

(allocinfo_filter.fields). min_size and max_size are filter

parameters, not tag identity. Also, allocinfo_to_params() does not

fill these fields, so userspace gets zeros in the output, which is

a bit confusing. Might be cleaner to separate filter parameters

from tag identity.

>   struct allocinfo_counter {
> @@ -39,13 +41,17 @@ enum {
>   	ALLOCINFO_FILTER_FUNCTION,
>   	ALLOCINFO_FILTER_FILENAME,
>   	ALLOCINFO_FILTER_LINENO,
> -	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_LINENO
> +	ALLOCINFO_FILTER_MIN_SIZE,
> +	ALLOCINFO_FILTER_MAX_SIZE,
> +	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
>   };
>   
>   #define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
>   #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
>   #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
>   #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
> +#define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
> +#define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
>   
>   #define ALLOCINFO_FILTER_MASKS \
>   	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index 7ff936e15e97..98a27c302928 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -195,6 +195,9 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
>   
>   static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
>   {
> +	struct alloc_tag *tag;
> +	struct alloc_tag_counters counters;
> +
>   	if (!ct || !filter || !filter->mask)
>   		return true;
>   
> @@ -214,6 +217,18 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
>   	    ct->lineno != filter->fields.lineno)
>   		return false;
>   
> +	if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) ||
> +	    (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
> +		tag = ct_to_alloc_tag(ct);
> +		counters = alloc_tag_read(tag);

alloc_tag_read() is called twice for matching tags

When size filtering is enabled, matches_filter() calls alloc_tag_read()

to check the size, and then allocinfo_to_params() calls it again to

fill the output data:

matches_filter():

     counters = alloc_tag_read(tag);        // 1st read

     if (counters.bytes < min_size)

         return false;

allocinfo_to_params():

     counter = alloc_tag_read(tag);         // 2nd read (same tag)

     data->counter.bytes = counter.bytes;

For matching tags, the same per-CPU counter aggregation is done twice.

On large machines this is not trivial. Would it make sense to cache

the counters from matches_filter() and reuse them in allocinfo_to_params()?


> +		if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> +		    counters.bytes < filter->fields.min_size)
> +			return false;
> +		if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> +		    counters.bytes > filter->fields.max_size)
> +			return false;
> +	}
> +

No validation for min_size > max_size.

If both MIN_SIZE and MAX_SIZE are set but min_size > max_size,

no records will match and the user gets no indication of the

invalid input. This could be checked alongside the existing

mask validation in allocinfo_ioctl_get_at():

     if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)

         return -EINVAL;

     +   if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&

     +       (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&

     +       params.filter.fields.min_size > params.filter.fields.max_size)

     +            return -EINVAL;

Thanks

Best Regards

Hao

>   	return true;
>   }
>   

