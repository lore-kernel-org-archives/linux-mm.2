Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD8BCD8CA8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD566B00CF; Tue,  9 Jun 2026 21:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D376B00D1; Tue,  9 Jun 2026 21:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C2E6B00D2; Tue,  9 Jun 2026 21:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 841876B00CF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:50:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E7A21A081B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:50:00 +0000 (UTC)
X-FDA: 84862322160.26.2E50127
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6BB71140005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:49:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xAdWg7qm;
	spf=pass (imf26.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781056198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YdUOSbCjHz0ggGNKJqKyfd3B90NV6CdYw/nifUVVcrs=;
	b=R297lTxNuq5DnHn+Je/eIOAcucYkL7d4+UxGDQUt1JVRfgeofHrBRj/XcEnoYkrtPC7nsk
	lwJd5v5ExWP3lgww58GZ6Wo2bVwmDubiP3DGsBw7Sr9OFfhM8BcmDL1ww7pxziMZ3Vk7RO
	uV925cFneOiQCyRMpFG6LRKMiblhL7E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xAdWg7qm;
	spf=pass (imf26.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781056198;
	b=nEGXD3vVmAPihkmB6BhYm8Gr0K6srFdMcxVk5kai82meKKtELc7AWOb83eh/VOPfuRK7Q8
	bxgPLcAt80ZqtsiQMRAQxRQjXExs8CAAhL1F/uKuPNdruDq/3WcOAyH4iYwO5LDpTckKwd
	irPBcSdPgZHUAg8ujx7FaiTot3TJ61w=
Message-ID: <65926655-ab44-473f-b322-254f59769575@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781056196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YdUOSbCjHz0ggGNKJqKyfd3B90NV6CdYw/nifUVVcrs=;
	b=xAdWg7qmnV1kzmSJQzLQ1J2DVb+ReGV94fBwVoBi2vnY6KVhk60ylukGLL3Vv1jBD1N/iR
	CH6obf6pbUSFodRIOS4QPD4iGTd8tYrGKRFIOWHhjoRNXRKuFc0kwulW6kCUaNCcnd+GhZ
	HnvwkO6lbSnEqcgBSDFzAkLWixVrw+Q=
Date: Wed, 10 Jun 2026 09:49:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 3/6] alloc_tag: add size-based filtering to ioctl
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>
References: <cover.1781042698.git.abhishekbapat@google.com>
 <4e2a75c69fe350358e1fef3e4e25435f6a3d4e77.1781042698.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <4e2a75c69fe350358e1fef3e4e25435f6a3d4e77.1781042698.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6BB71140005
X-Stat-Signature: 5tfojs81mmmzsqf6k73rraw6w6hwkkt8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781056198-578855
X-HE-Meta: U2FsdGVkX1+1hOumgK3vpRDH3jTSn9ZwQVMDDKwi1T7AXXTFbuV1byI07/l8uQjG34IHT2Ak3Fbwj5McRpyOnB+wZjTMzNb6QeGQkNyt7X6zYlDUcI8vWA53kj64OeHZ2hMXff8OB4BG1szgJ3QNdoEb8TEgwp5E9tSX9e5ERGftzamr4JwpSu09YEMnmf+y8StkmCA4eRsnGIcPJb9Sdd3CbiS0WFMMpZRMhFHqf/GXlDs/e3WOJ4NxWRHvSm95/zbF0feRoFjyBOQLnV8QLbpKyiNnASAfL+vsDe7klOsKa2aHLAgM5Tn9Tm7AQGPdwkwAbZ1o5IuHhsmouqzOaOMNW7n1A+weSraVa/BUEpJtb+OidSg/cBIfQpiNUPHHMSfNccDjjcpplmTCFJ5w7F1LMQot/mCBYPHRUpE4FWsctAElMI+DqcQ2uriB1qcaQiixQiIWcFWRFJQWarx6bPJEHXOoWpwbXzt9PTbN8e7HxUiMF2OrDruL10ydobnOd4/Hb2cIL8NGUlbBr29tgJr1JvxmHfToS4mN/C2rTDQKOlUDMBo3vsaNom+hnkAT0uMYN/0EaOe6xfW4ReCdpji8yOpP+URaOkI3ZYF4G9hoRHx7JYXAww/YsC0q1OyAaAeF8qT/4NWfLnP8L6FM34Kbj9GFv7ypMHfHCWWRDhG+E+jbkwJvN0pxr2jWiW5tVoH79jR53Wf4obUcxHqqA3i9fy8aDsnuYTw9WXTSZAWIv98JrbR5Et3OepjNuRhhG8ToLJA4TZgdO6oiNYmDWLAw2I+wAaAe+hHB+YDorM8kwpTQb0vX/7AglqO+IjPOMTKG6tj5fb9tEFLXZ5AViABDMdvQ+oFL7CaehIPAoZAd4V8oH3hpYE0Z3WigcbX+meqDVCyxf41ebCnNQjQCEZfiL+NeedesQ1eVvSHg5RXLtX3Y7nkFjlnJXPBEIygBH9jV8EkEs97u9AK7UFD
 wDBv29lh
 9Itygmdje74WYSJQ6Gv9DRYNXVRTATtxb68hW+bgJSphiqReZLikdoVKsCeNXQDDi/a0nQEc20R4IkK3KvcnvwKOLJ78K84tlGL1fmuy6GQGs+YoEfdclj+C+48BEUq8t1O8WGh9QmmT8NE0kYFJoRX+fX9XdQxS06qjR5a9Ja1o5tH1LZ5ko4vDOI4Vjj/LeBxoGxd0PVg9Zjn1ufwcQseHLHDarsvxUBbk2Jw/RgzhKNnevd7R6v5FcQp7g/7iVcwXqaNRpM6UetMxRXlBDbmc9+yUFAHkBY0I3JmXU4jEB9Ds49fzdT5eJnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/6/10 08:12, Abhishek Bapat wrote:
> Extend the allocinfo filtering mechanism to allow users to filter tags
> based on the total number of bytes allocated [min_size, max_size]. The
> size range is inclusive.
>
> Filtering by size involves retrieving allocinfo per-CPU counters, which
> is an expensive operation. Hence, the performance of size-based
> filtering will be worse than other filters.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>


Acked-by: Hao Ge <hao.ge@linux.dev>


> ---
>   include/uapi/linux/alloc_tag.h |  8 ++++-
>   lib/alloc_tag.c                | 63 ++++++++++++++++++++++++++++------
>   2 files changed, 59 insertions(+), 12 deletions(-)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
> index 3b11877955b9..7f5acbb44c14 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -45,13 +45,17 @@ enum {
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
> @@ -59,6 +63,8 @@ enum {
>   struct allocinfo_filter {
>   	__u64 mask; /* bitmask of the filter fields used */
>   	struct allocinfo_tag fields;
> +	__u64 min_size;
> +	__u64 max_size;
>   };
>   
>   struct allocinfo_get_at {
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index 378fcd63b6c9..a936cf18611a 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -191,15 +191,26 @@ static int allocinfo_cmp_str(const char *str, const char *template)
>   	return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
>   }
>   
> +/* Fetch the per-CPU counters */
> +static inline struct alloc_tag_counters allocinfo_prefetch_counters(struct codetag *ct)
> +{
> +	return alloc_tag_read(ct_to_alloc_tag(ct));
> +}
> +
>   /*
>    * Populates the UAPI allocinfo_tag_data structure with active runtime
>    * profiling counters extracted from the given kernel codetag.
>    */
>   static void allocinfo_to_params(struct codetag *ct,
> -				struct allocinfo_tag_data *data)
> +				struct allocinfo_tag_data *data,
> +				struct alloc_tag_counters *counters)
>   {
> -	struct alloc_tag *tag = ct_to_alloc_tag(ct);
> -	struct alloc_tag_counters counter = alloc_tag_read(tag);
> +	struct alloc_tag_counters local_counters;
> +
> +	if (!counters) {
> +		local_counters = allocinfo_prefetch_counters(ct);
> +		counters = &local_counters;
> +	}
>   
>   	if (ct->modname)
>   		allocinfo_copy_str(data->tag.modname, ct->modname);
> @@ -208,9 +219,9 @@ static void allocinfo_to_params(struct codetag *ct,
>   	allocinfo_copy_str(data->tag.function, ct->function);
>   	allocinfo_copy_str(data->tag.filename, ct->filename);
>   	data->tag.lineno = ct->lineno;
> -	data->counter.bytes = counter.bytes;
> -	data->counter.calls = counter.calls;
> -	data->counter.accurate = !alloc_tag_is_inaccurate(tag);
> +	data->counter.bytes = counters->bytes;
> +	data->counter.calls = counters->calls;
> +	data->counter.accurate = !alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
>   }
>   
>   /*
> @@ -234,7 +245,9 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
>    * Verifies whether a given codetag satisfies the active filtering criteria by
>    * matching its characteristics against the specified filter.
>    */
> -static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
> +static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
> +			   struct alloc_tag_counters *counters,
> +			   bool *fetched_counters)
>   {
>   	if (!filter || !filter->mask)
>   		return true;
> @@ -261,6 +274,19 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
>   	    ct->lineno != filter->fields.lineno)
>   		return false;
>   
> +	if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
> +		if (!*fetched_counters) {
> +			*counters = allocinfo_prefetch_counters(ct);
> +			*fetched_counters = true;
> +		}
> +		if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> +		    counters->bytes < filter->min_size)
> +			return false;
> +		if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> +		    counters->bytes > filter->max_size)
> +			return false;
> +	}
> +
>   	return true;
>   }
>   
> @@ -274,6 +300,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>   	struct codetag *ct;
>   	struct allocinfo_get_at params = {0};
>   	__u64 skip_count;
> +	struct alloc_tag_counters counters;
> +	bool fetched_counters;
>   
>   	if (copy_from_user(&params, arg, sizeof(params)))
>   		return -EFAULT;
> @@ -281,6 +309,11 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>   	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
>   		return -EINVAL;
>   
> +	if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> +	    (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> +	    params.filter.min_size > params.filter.max_size)
> +		return -EINVAL;
> +
>   	priv = m->private;
>   
>   	mutex_lock(&priv->ioctl_lock);
> @@ -304,7 +337,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>   	ct = codetag_next_ct(&priv->ioctl_iter);
>   
>   	while (ct) {
> -		if (matches_filter(ct, &priv->filter)) {
> +		fetched_counters = false;
> +		if (matches_filter(ct, &priv->filter, &counters, &fetched_counters)) {
>   			if (skip_count == 0)
>   				break;
>   			skip_count--;
> @@ -313,7 +347,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>   	}
>   
>   	if (ct) {
> -		allocinfo_to_params(ct, &params.data);
> +		allocinfo_to_params(ct, &params.data, fetched_counters ? &counters : NULL);
>   		priv->positioned = true;
>   	}
>   
> @@ -339,6 +373,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
>   	struct codetag *ct;
>   	struct allocinfo_tag_data params;
>   	int ret = 0;
> +	struct alloc_tag_counters counters;
> +	bool fetched_counters;
>   
>   	memset(&params, 0, sizeof(params));
>   	priv = m->private;
> @@ -352,10 +388,15 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
>   	}
>   
>   	ct = codetag_next_ct(&priv->ioctl_iter);
> -	while (ct && !matches_filter(ct, &priv->filter))
> +	while (ct) {
> +		fetched_counters = false;
> +		if (matches_filter(ct, &priv->filter, &counters, &fetched_counters))
> +			break;
>   		ct = codetag_next_ct(&priv->ioctl_iter);
> +	}
> +
>   	if (ct)
> -		allocinfo_to_params(ct, &params);
> +		allocinfo_to_params(ct, &params, fetched_counters ? &counters : NULL);
>   
>   	if (!ct) {
>   		priv->positioned = false;

