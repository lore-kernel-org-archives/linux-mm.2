Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA6CCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 02:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01C06B0088; Sun,  7 Jun 2026 22:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2026B008A; Sun,  7 Jun 2026 22:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C84D6B008C; Sun,  7 Jun 2026 22:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB9F6B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 22:40:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F145408EF
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 02:40:16 +0000 (UTC)
X-FDA: 84855191232.27.CF7F196
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2622520004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 02:40:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PZONv3Sx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780886414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v0gpJDAKgCFuGUDHr03K+7t/mGqVQAiRsAIfHMMh5/E=;
	b=ISOceAKZgVxgZd5YVc6Wtnb1DZrmQ7RsqvZBD2Ln94yNTK5YPskcicqI9QmigxVaKzUmhg
	/UH28C4g8xrGrOsq65gSarqmD6xphk3NfuPJJfM9bjMUj7TtKqa1tpQqg6r2q8hYHW0U/E
	VSoE6sNmRfjphJQ+cxjaGR6Lb+0FVUU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PZONv3Sx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780886414;
	b=O6izUrAS8Rk6p34/o7nua6UGUmbo9IoD5w0kGWx4goKD07LNGT1qw7OTw8nv8wuQCQOdza
	mx8pBn5R0AaKp0sL8vDZ4XmG9rIJRvxNf07JcFL5an5hNUfx5vMhNdCIxQX8rgVlqRNyb4
	1qzhUJe3YTFesYSXrl0PIQidx+amLjk=
Message-ID: <d22d73ab-c519-4a50-b564-5d7299a3c3bd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780886412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v0gpJDAKgCFuGUDHr03K+7t/mGqVQAiRsAIfHMMh5/E=;
	b=PZONv3SxcPf4VhOuIPPWT8godfsZtgOX655I5MPm5mRsFV81qLuS1wFRBcyCPtuM4ERIRn
	zC5CBIPlWDFgzHMu0CYUhE8UnXXghr+CPuSlDSHsagHJZZ1eRA9/oquoUQf+sOGeJnnmxC
	HtLjhmWlWIitWCYcQ3n4O/gwECegJQM=
Date: Mon, 8 Jun 2026 10:39:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>
References: <cover.1780701922.git.abhishekbapat@google.com>
 <6f3b4aa0aa294cd56a73854c631de3ab7c0c5e01.1780701922.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <6f3b4aa0aa294cd56a73854c631de3ab7c0c5e01.1780701922.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2622520004
X-Rspam-User: 
X-Stat-Signature: physqwzmfneshkrezyetubgsbc8wdseb
X-Rspamd-Server: rspam09
X-HE-Tag: 1780886413-629434
X-HE-Meta: U2FsdGVkX181yuMQNRZWBBxh8hzmZCUyA8CgFhcHyC4Xy7VQFegXkb9e6+LIRPS1gtwbmOqyvAdiryIJtuYtxNqugV3qUKwHNIZ00yOwTdfadbGq57dkleyJNQAjxiHo4dara2IDamp2fp6k5YcLZmO+3usHAdMDbbs5G+NNcxgv0cMtlzLvKwC6rbxtzWpXeAWDMf+//5UD4W7KSEXZJjXn3VTPbIIuP97GnA/s2O6bURS0KrwU6h2FeTPR8KDnXvmWpgUu+ecpRdUwDvYcG7Qme17+TJQ6BbUfyc5CXI5ufHwzSeOqJ2o9zUv+SOTppvRSP5WjrPDzls7jm9eJbePONk0bRWwyeGP2tU025kh8t27mQM/Z9l5+vIBTqnFvnr7+neZv1Qm+FemH704QCpnjw019nFd/ssurX0C/EPPVBH+qI7wM7TUAjondOFYermDbHOCC0HJXhOqE712k0vw+LoAWlZLois8PbD9lz0qRhR65ZJwnz9+NK9umtxWmTeADbGOTndAbjZTQHICSS2SaXJ2MV4ARD8UWhzDFSoatLDkZ2AURVCMdojnPPn+WySZYyqkyj5Ocj11b/aGm/5u6jTt//37BdOK/xywRRXNH/dFx8ZgZQLlMokl6hcVdFa2SWgHnSKItt2S4F65t8ZypJekCMCiwhOkjFbuPO8nAhkMcPDiJDPK8ONcCH5uwCLcLJJW2vkUzPRUBXFzJZVEIo7LlQq0SW0k4ZNRPtKueMHkuXcPc1or6eH2SUvWiwwW80Ipmh7DJwiwz4BVkB/PiW/RSebkivugqXT/5+HuOnmx6UEI1A43FLZwz+WkaqL01XrTeqBkWsH7TTAmF42oC6o+zmCer9TCZHfg2gypPeg+sUQQWrycRy0jgYMs0ttTZWp+m2QAwHxo7H2iPGxuaNq1OXUFrU8Bya/3XqxKJCRSZeZUekiOdv8V2w2BtKsoBweOIvd/Fs/AWcsM
 3kHZYbKt
 ooPPNDCkttnDwoCmnHZJSUQpMdQkTaPF9vJtmfmxreFKV9x+UC9pQjtc2EokOZWPmfqTwjwiqJ+UUWG/D+l6FcUVXeclN3BrcoP95buGxepxeXRxvhW5jzt7vLQ638T7BYenwb3kQYAqW01fm7KF0eQf1bmXkkTaEyMYlG/iO2qR7QeVKQG7gsmO/tCqcmx7frQAQfRIG7AXkWRVWL65lH70QMTRsguGOv9kUckCIrAiqoEWwIQEX85qBq1GRmOgTrqi1jcO8VunAcGVgmd7T0lp1LgybZL27UU+qPlNI+jsHIvo1S9nvzMkHtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


Thanks for the new version.


On 2026/6/6 07:36, Abhishek Bapat wrote:
> Extend the capability of the IOCTL mechanism to filter allocations based
> on tag's module name, function name, file name and line number.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>


Acked-by: Hao Ge <hao.ge@linux.dev>


> ---
>   include/uapi/linux/alloc_tag.h | 26 ++++++++++++-
>   lib/alloc_tag.c                | 68 ++++++++++++++++++++++++++++++++--
>   2 files changed, 89 insertions(+), 5 deletions(-)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
> index 901199bad514..cffb0c46e0b1 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -34,8 +34,32 @@ struct allocinfo_tag_data {
>   	struct allocinfo_counter counter;
>   };
>   
> +enum {
> +	ALLOCINFO_FILTER_MODNAME,
> +	ALLOCINFO_FILTER_FUNCTION,
> +	ALLOCINFO_FILTER_FILENAME,
> +	ALLOCINFO_FILTER_LINENO,
> +	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_LINENO
> +};
> +
> +#define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
> +#define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
> +#define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
> +#define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
> +
> +#define ALLOCINFO_FILTER_MASKS \
> +	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> +
> +struct allocinfo_filter {
> +	__u64 mask; /* bitmask of the filter fields used */
> +	struct allocinfo_tag fields;
> +};
> +
>   struct allocinfo_get_at {
> -	__u64 pos;	/* input */
> +	/* inputs */
> +	__u64 pos;
> +	struct allocinfo_filter filter;
> +	/* output */
>   	struct allocinfo_tag_data data;
>   };
>   
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index a0577215eb3d..93bc976ac505 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -49,6 +49,7 @@ struct allocinfo_private {
>   	struct codetag_iterator iter;
>   	struct codetag_iterator reported_iter;
>   	bool print_header;
> +	struct allocinfo_filter filter;
>   	/* ioctl uses a separate iterator not to interfere with reads */
>   	struct codetag_iterator ioctl_iter;
>   	bool positioned; /* seq_open_private() sets to 0 */
> @@ -184,6 +185,12 @@ static void allocinfo_copy_str(char *dest, const char *src)
>   	strscpy_pad(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
>   }
>   
> +/* Compare two strings and only consider the trimmed suffix if s1 is too long */
> +static int allocinfo_cmp_str(const char *str, const char *template)
> +{
> +	return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
> +}
> +
>   /*
>    * Populates the UAPI allocinfo_tag_data structure with active runtime
>    * profiling counters extracted from the given kernel codetag.
> @@ -223,6 +230,40 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
>   	return 0;
>   }
>   
> +/*
> + * Verifies whether a given codetag satisfies the active filtering criteria by
> + * matching it's characteristics against the specified filter.


nit: s/it's/its/


> + */
> +static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
> +{
> +	if (!filter || !filter->mask)
> +		return true;
> +
> +	if (filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) {
> +		/* user wants to filter by modname but ct->modname is NULL */
> +		if (!ct->modname) {
> +			/* validate if user was attempting to filter for built-in allocations */
> +			if (filter->fields.modname[0] != '\0')
> +				return false;
> +		} else if (allocinfo_cmp_str(ct->modname, filter->fields.modname))
> +			return false;
> +	}
> +
> +	if ((filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) &&
> +	    ct->function && (allocinfo_cmp_str(ct->function, filter->fields.function)))
> +		return false;
> +
> +	if ((filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) &&
> +	    ct->filename && (allocinfo_cmp_str(ct->filename, filter->fields.filename)))
> +		return false;
> +
> +	if ((filter->mask & ALLOCINFO_FILTER_MASK_LINENO) &&
> +	    ct->lineno != filter->fields.lineno)
> +		return false;
> +
> +	return true;
> +}
> +
>   /*
>    * Seeks the ioctl iterator to the specified 0-indexed tag position, reads its
>    * profiling data and returns it to userspace.
> @@ -231,29 +272,46 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>   {
>   	struct allocinfo_private *priv;
>   	struct codetag *ct;
> -	__u64 pos;
>   	struct allocinfo_get_at params = {0};
> +	__u64 skip_count;
>   
>   	if (copy_from_user(&params, arg, sizeof(params)))
>   		return -EFAULT;
>   
> +	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> +		return -EINVAL;
> +
>   	priv = m->private;
> -	pos = params.pos;
>   
>   	mutex_lock(&priv->ioctl_lock);
>   	codetag_lock_module_list(alloc_tag_cttype);
>   
> -	if (pos >= codetag_get_count(alloc_tag_cttype)) {
> +	if (params.pos >= codetag_get_count(alloc_tag_cttype)) {
>   		codetag_unlock_module_list(alloc_tag_cttype);
>   		mutex_unlock(&priv->ioctl_lock);
>   		return -ENOENT;
>   	}
>   
> +	skip_count = params.pos;
> +
> +	if (params.filter.mask)
> +		priv->filter = params.filter;
> +	else
> +		priv->filter.mask = 0;
> +
>   	/* Find the codetag */
>   	priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
>   	ct = codetag_next_ct(&priv->ioctl_iter);
> -	while (ct && pos--)
> +
> +	while (ct) {
> +		if (matches_filter(ct, &priv->filter)) {
> +			if (skip_count == 0)
> +				break;
> +			skip_count--;
> +		}
>   		ct = codetag_next_ct(&priv->ioctl_iter);
> +	}
> +
>   	if (ct) {
>   		allocinfo_to_params(ct, &params.data);
>   		priv->positioned = true;
> @@ -294,6 +352,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
>   	}
>   
>   	ct = codetag_next_ct(&priv->ioctl_iter);
> +	while (ct && !matches_filter(ct, &priv->filter))
> +		ct = codetag_next_ct(&priv->ioctl_iter);
>   	if (ct)
>   		allocinfo_to_params(ct, &params);
>   

