Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C30CCD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94DDB6B0093; Mon, 25 May 2026 23:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925DB6B0095; Mon, 25 May 2026 23:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863AD6B0098; Mon, 25 May 2026 23:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77F456B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:12:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08FC61C0155
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:12:32 +0000 (UTC)
X-FDA: 84808098144.13.FBE1128
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8ABBEC0006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:12:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dnCSa+lf;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779765150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7fYZUv8jUz3LpuMJ3igYxrWXq5kDxizbxy8SIukcuk=;
	b=l9FEnKME9378i+O5ts1LqmOj8JS6l4zEhjud4qQxMsUezamupd6EEvebRH+CFW6AmUpoWV
	JqI3LQsVRxjMYp+PB82bQ8550SPy8WuhMjUM3fy3J1uq0qw/ImCxVwacPIr85SIVatofp5
	je2lhaLe0BjosgaLxX+oEwJIn+AEIGM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dnCSa+lf;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779765150; a=rsa-sha256;
	cv=none;
	b=VGup7ePPtlr1jfh9F3KqUuBCqlzSdQvgE58BXmcYThWQimooKZmsrcP+iKlfGyFCCC5DZW
	GnNMWNtTnMRTQmk2oJZDkKAr2HpqNhH+zVg/jFpg7Ymgc2WXxdzjhDzJlxwfqbNhGcofMG
	dPOZc/4PqHguuaVdnF/r+3aigSn+3m8=
Message-ID: <de0f2984-44ea-4098-9d19-c63ee035cdaf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779765145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B7fYZUv8jUz3LpuMJ3igYxrWXq5kDxizbxy8SIukcuk=;
	b=dnCSa+lf6J4YpqA1F/oml2kyJgci5cZ58eOEnYBqKE0UtgWMYCewjMuX5Z+cOmiiMRdC+9
	HkCk8E6c4jPBJNtZFv2okluKn9sW21bAQ4VTHqpbKD08ghX61T3uw/6VYB771obobAF0Nl
	u7fyjwW9XFiasnsecsX608hrWrHRG80=
Date: Tue, 26 May 2026 11:11:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/6] alloc_tag: add size-based filtering to ioctl
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>
References: <cover.1779471082.git.abhishekbapat@google.com>
 <c4b425d1f9192caca3cad830f322aa048ed26d45.1779471082.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <c4b425d1f9192caca3cad830f322aa048ed26d45.1779471082.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qibmeihdjwpji8mqqx37eeicaawex4bh
X-Rspamd-Queue-Id: 8ABBEC0006
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779765148-367291
X-HE-Meta: U2FsdGVkX1+Eq76YfORZTa/ktJOsEaod8taiiw09gw2mhBeONX0eUTLSAE5OSfGTZwOhE4t0q/ODq70En2jUm61VJoWgw5Mi7t0pOy+/8l2Wq1X0IGmhSjrUQ1CdwexNjvmFUfH2dFa+5NLzKt5o+isBeVe3+mFxirgtTBg8a6WdEp+SdHgpzccWuLy5EK4cMHN9e4Zxgiv/0oYAx/wt0EcUIbhzYTQVihj7dssi17Aa5dFLLkye6cEP5hrf9r3lw/8q9yUXbpVO22eN+ipCZ8SHREwUqDYV1z7jRCtKuoLtorMrwWyIMYligpphoWZPCDcBY1wYc9Bye1ewqleYLLRKtDI3YQZcvEEQ31JeDWWru/8l+HX9bvdbZ1G1J/Y6jv5NnVIZRS9yxd6HbdGOa86ucOP0T3U+VXcRBnL6wTk8mPAODCSHCZ25UytjqFXL518BI8nFSs4r2LVfqxs6NjWbRgHVnRsGug22Oqh7YrBwjR2PiG7OE0HEJ8gJZqxwVY/kAjtEOTuGQnjml7EQATghTFHmv6ZjZz8XMVpq/93Bh/yyHkgl7AVyvTRV+bXdCI/UB911qv0WWxwLjae0jRZC7xcqjXL+SO0ICl12OzfVqMkJQk5aLT9SHhzlHkLL/JpEJNNs25KJp0mFqh9cIflr4+TgN01OucGbgA9eb62ZmC+DBgkmPdrWQG34/AutGMXhgvnn37z5A/VUnHzxghgrfd+OCGiZRFoB83AhTXsPSdt+7EhmSGQ1JtMnYFZsTMJT2zU3F4WGueash6WKQE7+dgvTEPL3eLAFuHk5RIks0E+/CBDuPkF7aTHfJH4h6FrgjfZs063SKqqxadvC37+vtUTgHWBbicU+XGLLIPEAJzvKKy5uHdkIGhEQznqMVtXOIpjIIEQHDTvQeDutINhPqbpeX0bCgK8qD97LlizxVr/dweihl/8vmYEJRx8XzA2r2vDz8Z7GEIb1lbm
 x2LaWT2q
 9xfukoLiFMhp7iwsMP+jKsajnfG6ZOA0JT9hJ3Ih2FGLUxTW58CyvZ6LCSmhpnK7ndiOB0nXzJaWreTJWFlj4ZteEyTdcyWsDYvLk4CE18LtZWhUwv9HFbcP3FXfiuVfdn38WzZpRY77e8vXgP2A5kyDQjtLPhfs9pZBJRiyUu3t49uxivJ3kTPF3AZSgulboTZQbc748HmOi2BaYBWkbZ75Gl9ujbAKoE0HvWxlXDZQHPqd92Iuf4zU9ZZV86v7pJXRb0UFc/ORblWROIljMQqxd7oL9YBD26iKKYKaXsIlnWT8pZD7QbM5kSXORLEzF7D5T9wEe2xR9E1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


On 2026/5/23 01:45, Abhishek Bapat wrote:
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
>   include/uapi/linux/alloc_tag.h |  8 +++-
>   lib/alloc_tag.c                | 72 ++++++++++++++++++++++++++++------
>   2 files changed, 68 insertions(+), 12 deletions(-)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
> index 0cc9db5298c6..45f158bee0a6 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -39,13 +39,17 @@ enum {
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
> @@ -53,6 +57,8 @@ enum {
>   struct allocinfo_filter {
>   	__u64 mask; /* bitmask of the filter fields used */
>   	struct allocinfo_tag fields;
> +	__u64 min_size;
> +	__u64 max_size;
>   };
>   
>   struct allocinfo_get_at {
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index 56c394ef721f..6c8743eead2d 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -173,11 +173,21 @@ static int allocinfo_cmp_str(const char *str, const char *template)
>   	return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
>   }
>   
> +static inline struct alloc_tag_counters allocinfo_prefetch_counters(struct codetag *ct)
> +{
> +	return alloc_tag_read(ct_to_alloc_tag(ct));
> +}
> +
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
> @@ -186,9 +196,9 @@ static void allocinfo_to_params(struct codetag *ct,
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
>   static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
> @@ -204,7 +214,8 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
>   	return 0;
>   }
>   
> -static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
> +static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
> +			   struct alloc_tag_counters *counters)
>   {
>   	if (!filter || !filter->mask)
>   		return true;
> @@ -228,6 +239,17 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
>   	    ct->lineno != filter->fields.lineno)
>   		return false;
>   
> +	if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) ||
> +	    (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
> +		/* We assume counters is not NULL here as per caller logic */
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
> @@ -237,6 +259,9 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>   	struct codetag *ct;
>   	struct allocinfo_get_at params = {0};
>   	__u64 skip_count;
> +	bool sizes_set;
> +	struct alloc_tag_counters counters;
> +	struct alloc_tag_counters *counters_ptr = NULL;
>   
>   	if (copy_from_user(&params, arg, sizeof(params)))
>   		return -EFAULT;
> @@ -244,9 +269,16 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>   	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
>   		return -EINVAL;
>   
> +	if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> +	    (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> +	    params.filter.min_size > params.filter.max_size)
> +		return -EINVAL;
> +
>   	priv = (struct allocinfo_private *)m->private;
>   
>   	skip_count = params.pos;
> +	sizes_set = (params.filter.mask &
> +		     (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE));
>   
>   	mutex_lock(&priv->ioctl_lock);
>   	codetag_lock_module_list(alloc_tag_cttype, true);
> @@ -261,7 +293,11 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>   	ct = codetag_next_ct(&priv->ioctl_iter);
>   
>   	while (ct) {
> -		if (matches_filter(ct, &priv->filter)) {
> +		if (sizes_set) {
> +			counters = allocinfo_prefetch_counters(ct);
> +			counters_ptr = &counters;
> +		}
> +		if (matches_filter(ct, &priv->filter, counters_ptr)) {

alloc_tag_read() walks all per-CPU counters which is not cheap, but here

it's called for every codetag unconditionally when sizes_set is true,

even when the tag would be rejected by modname/function/filename checks

that are plain string comparisons.

For example, say the user filters with MODNAME | MIN_SIZE on a system

with 10000 tags, 100 of which belong to the target module. Today the

code would call alloc_tag_read() 10000 times (once per tag), but only

100 of those tags pass the modname check — the other 9900 per-CPU walks

are wasted.

Would it make sense to split the filter check so that per-CPU counter reads

only happen after tag-based checks pass? Something like:

static bool allocinfo_match_tag(struct codetag *ct,

                         struct allocinfo_filter *filter) { ... }

static bool allocinfo_match_size(struct alloc_tag_counters *counters,

                                    struct allocinfo_filter *filter) { ... }

And in the caller:

bool match = allocinfo_match_tag(ct, &priv->filter);

/* Add comments to help subsequent developers understand the purpose of 
this modification. */

if (match && sizes_set) {

            counters = allocinfo_prefetch_counters(ct);

            counters_ptr = &counters;

             match = allocinfo_match_size(counters_ptr, &priv->filter);

}

You may find a more elegant approach to resolve this issue.

Thanks

Best Regards

Hao

>   			if (skip_count == 0)
>   				break;
>   			skip_count--;
> @@ -270,7 +306,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>   	}
>   
>   	if (ct) {
> -		allocinfo_to_params(ct, &params.data);
> +		allocinfo_to_params(ct, &params.data, counters_ptr);
>   		priv->positioned = true;
>   	}
>   
> @@ -292,9 +328,15 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
>   	struct codetag *ct;
>   	struct allocinfo_tag_data params = {0};
>   	int ret = 0;
> +	bool sizes_set;
> +	struct alloc_tag_counters counters;
> +	struct alloc_tag_counters *counters_ptr = NULL;
>   
>   	priv = (struct allocinfo_private *)m->private;
>   
> +	sizes_set = (priv->filter.mask &
> +		     (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE));
> +
>   	mutex_lock(&priv->ioctl_lock);
>   	codetag_lock_module_list(alloc_tag_cttype, true);
>   
> @@ -304,10 +346,18 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
>   	}
>   
>   	ct = codetag_next_ct(&priv->ioctl_iter);
> -	while (ct && !matches_filter(ct, &priv->filter))
> +	while (ct) {
> +		if (sizes_set) {
> +			counters = allocinfo_prefetch_counters(ct);
> +			counters_ptr = &counters;
> +		}
> +		if (matches_filter(ct, &priv->filter, counters_ptr))
> +			break;
>   		ct = codetag_next_ct(&priv->ioctl_iter);
> +	}
> +
>   	if (ct)
> -		allocinfo_to_params(ct, &params);
> +		allocinfo_to_params(ct, &params, counters_ptr);
>   
>   	if (!ct) {
>   		priv->positioned = false;

