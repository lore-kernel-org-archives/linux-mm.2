Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE8DECD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 04:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 161126B0088; Mon,  8 Jun 2026 00:10:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112766B008A; Mon,  8 Jun 2026 00:10:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027D36B008C; Mon,  8 Jun 2026 00:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8A036B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 00:10:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 860E49293C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:10:22 +0000 (UTC)
X-FDA: 84855418284.15.0365E99
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8F932180005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:10:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PhJQmJ4C;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780891820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQr+FS5WTq4T7wFBMSLf3go6FakMkvtgbNGjQKWlmw8=;
	b=mXcNbUytlFfiIKalirksHXzo9q+9Ab5idE4RYuOImr0++9zb0Kubm00CYEF5YbmfGAOs+6
	PUq6aQDualLr8Fymkdv7DGomYprHFQkUCN3QFiTx9KThg729i0qhlcFRNJR85as0bt+Uqr
	AnsRfP7ZsPg5i2KQyIkIitYcA6BreuY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780891820;
	b=nMcmzpe06bVHFBIQ7g9qd1c2E0mx5HSHUicAF2InlMpW1EADkbI3+uDVKF/yZmAmgH3e3N
	aNCTFoj+KvVDIaaRI3gNzE+xe4zFBllyRIhJVRjDU6+HnnWV2hhksTlGn4INsZUS3aXGSh
	Y+sZDaA93WaA54UZmD9QV/Gu4jaw3Cg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PhJQmJ4C;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <5d77fadd-13a9-40ed-a8e8-2982ceb69af2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780891818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RQr+FS5WTq4T7wFBMSLf3go6FakMkvtgbNGjQKWlmw8=;
	b=PhJQmJ4C/cVE3UbVc5wYGTEjz2tdfRoaX48ehWPeZGWP7Nl/U5dlWYmpKB1nM2j5tvtc1F
	TO+/1SxF/Rg2fTp6M1SiLweIkGXWaSsWgQCzz3tFTWcWSg8Oqo4qT8Zv9umC7GkENoV4QC
	MLD6Yv9D6n9IuOrQPo76T96avYRGiaA=
Date: Mon, 8 Jun 2026 12:09:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 3/6] alloc_tag: add size-based filtering to ioctl
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>
References: <cover.1780701922.git.abhishekbapat@google.com>
 <ef88e52368463e312086a966f10287a29d0edeca.1780701922.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <ef88e52368463e312086a966f10287a29d0edeca.1780701922.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8F932180005
X-Rspam-User: 
X-Stat-Signature: n9s3s1ws34ff6h714co99z15k54a4tjy
X-Rspamd-Server: rspam08
X-HE-Tag: 1780891820-718607
X-HE-Meta: U2FsdGVkX1/mDUfmst7wynSEQRlSZVDaPmGIPXjgTRWdavuTa8nQ1wMnbqHAovigtuhWNqfeIwBvFXSegh6N1vd829R7vTTbOq6X+gVbFjCf03q1M3CBjxJvm3KucEz58EKZT/1GEDQnife/b836+sckO4jvU8U14DSaoakL67iSCPKBL6vZD1PxVRk6zCDk4H0OuAWgQxsw8Uu9qW4ESBXOE8PDwnvZbYNh/garVgd0aUPha40wtDqTo63RaIPsmcv62KuqxJgTrCzD6qLFThDhEFAA7cHbBScm39WGgikZopEdsGyBjB0lpZFRxsQwVDNE21KpYvJq03L/iFE9CtQOQcCcPwHp5etauHKfoGFEIGd0ntBLpNIf1IOkYofIqiu1yXpu156eX+JMWzyV1MDulbETVTdK9xccKzclg/mkG9YS42wlhJxXGdGwGZxQF6OEE/r4ywOwwbxd5H2gzInRexJ21PGmfDh40uIOghXLUdgkafCfd+rUugUuzMRokZTgz0r+9Bg1yQdyYuWKjUam8xhQiLJeJu18euYsbkdJ5Fl071b0LDhijXWFysTE7Pbj3vcJksGL725dQe7VUeqFNf8r7BECoRNrrJ8Qw0RQv9Jtsjyc8V0WKAKC8K70yGwWVY7zqwYI6uxY7xPHiBKU30BcVBz+mvcFN3C0Sf6DEhKnkNMUtKztJu+aPLiL+w8mRQ7A2wb8BlnZ/tu4nZvcHmwtrF0bBTjBe0zwwNiUdI6SF1JNr23u+iB8IKxqZ0JaW/peYm4QO9V2ULc9wbRCaOxva3di01pqa+ayaqPCdRiMGvoQnxoOKOxHj36usVjDk9HeRUFL/t7YolniDDT1HaHOGJJVWEfCvuONPRU8v7d3YdzcXmkONSoLCNFlnwL8fN6nIYVng7cxx9uaXR1oKWlbVvp21fKBTrkUUrIWc18/zgwl1t3ImEUDLLHEvs2ed0Chc9Dql519iN7
 EfPlqTl1
 8OsK/9+WWgodyW71V6Exz+9k4N+kOG9+RzY5IH80FNX48wmH+VshoUF9MT+uYewQ0YeZnOVzJtyCXAjj2DWKiyT3a+TpFx+x18eenouyRwQT1S29nuwX3QK45WdsaqsIdXiIure4ekoez+FirUpasydAjlKGIzrbFqRrZ5kNI4ZW67OJJT/oUvgYmFENDpC8GwXLW4dkuvtZcEzpaf5baBMGILYSsF6U0dLV9fOPuMUAP3hbgFVv1Twpe4CYHuuIjiSeLsFN/4xjmuVzB4s2YiKm765uNi+4adrqqRrwwHjnb2gua8XwXP7VWJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


Thanks for the new version.


On 2026/6/6 07:36, Abhishek Bapat wrote:
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
>   lib/alloc_tag.c                | 68 +++++++++++++++++++++++++++-------
>   2 files changed, 62 insertions(+), 14 deletions(-)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
> index cffb0c46e0b1..0e648192df4d 100644
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
> index 93bc976ac505..ddc6946f56ab 100644
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
>    * matching it's characteristics against the specified filter.
>    */
> -static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
> +static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
> +			   struct alloc_tag_counters *counters,
> +			   bool *fetched_counters)
>   {
>   	if (!filter || !filter->mask)
>   		return true;
> @@ -247,20 +260,34 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
>   				return false;
>   		} else if (allocinfo_cmp_str(ct->modname, filter->fields.modname))
>   			return false;
> +		}
It seems an extra } was accidentally added here
>   	}
>   
>   	if ((filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) &&
> -	    ct->function && (allocinfo_cmp_str(ct->function, filter->fields.function)))
> +	    ct->function && allocinfo_cmp_str(ct->function, filter->fields.function))
>   		return false;
>   
This should be fixed in the second patch; it's unrelated to current 
functionality.
>   	if ((filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) &&
> -	    ct->filename && (allocinfo_cmp_str(ct->filename, filter->fields.filename)))
> +	    ct->filename && allocinfo_cmp_str(ct->filename, filter->fields.filename))
>   		return false;

Ditto


Thanks

Best Regards

Hao

>   	if ((filter->mask & ALLOCINFO_FILTER_MASK_LINENO) &&
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
> @@ -274,6 +301,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>   	struct codetag *ct;
>   	struct allocinfo_get_at params = {0};
>   	__u64 skip_count;
> +	struct alloc_tag_counters counters;
> +	bool fetched_counters;
>   
>   	if (copy_from_user(&params, arg, sizeof(params)))
>   		return -EFAULT;
> @@ -281,6 +310,11 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
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
> @@ -304,7 +338,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>   	ct = codetag_next_ct(&priv->ioctl_iter);
>   
>   	while (ct) {
> -		if (matches_filter(ct, &priv->filter)) {
> +		fetched_counters = false;
> +		if (matches_filter(ct, &priv->filter, &counters, &fetched_counters)) {
>   			if (skip_count == 0)
>   				break;
>   			skip_count--;
> @@ -313,7 +348,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>   	}
>   
>   	if (ct) {
> -		allocinfo_to_params(ct, &params.data);
> +		allocinfo_to_params(ct, &params.data, fetched_counters ? &counters : NULL);
>   		priv->positioned = true;
>   	}
>   
> @@ -339,6 +374,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
>   	struct codetag *ct;
>   	struct allocinfo_tag_data params;
>   	int ret = 0;
> +	struct alloc_tag_counters counters;
> +	bool fetched_counters;
>   
>   	memset(&params, 0, sizeof(params));
>   	priv = m->private;
> @@ -352,10 +389,15 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
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

