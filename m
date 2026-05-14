Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6310CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 06:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D00D6B0088; Thu, 14 May 2026 02:15:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2594F6B008A; Thu, 14 May 2026 02:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121646B008C; Thu, 14 May 2026 02:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F19796B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:15:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 715C012032F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:15:52 +0000 (UTC)
X-FDA: 84765014544.29.218CA58
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 73D2C40005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:15:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HUqgbeGo;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778739350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8w6MPzA/h1sN1RH63AkkshacZX+EDpu8/E4H7LtmUQ=;
	b=ZO+4+1xhaRRZYguskkWhA0IkuzHSkqYTs2ynI9drOMFx2G6qgQvC1RbWDb4O+Fknh913aW
	X9LWX1sKxPSkagYe6X31qonTxkmgsFmv3JaxYwGRVuMAaoVrLo+748wEQK0SkMMlZYz0J5
	oKPqwgTbntw+efHABtvoxpe/kE3OR5g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HUqgbeGo;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778739350; a=rsa-sha256;
	cv=none;
	b=y4Ie6Zsf3jHygV/hxXEP3T57qiKPYVUXPdhr3HvGRNP3ET8LmFi4g+3Rc27bIWk7eCTYYF
	Z/kivCws11coGH6hJ5HchxcM4pW9Xi3i98Q2xDJ5spo3zRYewHs/XrAOfXiS6nA4qfhzRy
	OTQ/tU6f7AMwAZ1SVvON93RGi/7ghUo=
Message-ID: <7e4881af-3fca-474a-abb7-daa75986e3ad@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778739348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t8w6MPzA/h1sN1RH63AkkshacZX+EDpu8/E4H7LtmUQ=;
	b=HUqgbeGoKgH9eKrPki0bzHX/ThkrCPokSGe0ZMwxWcPfxruZXDEscAwskg75PywEvfXr4T
	6PEXQJtAB5lcDXtlyT/bInVU4kVhpZoZTVXT7Uv1RNCQDAeeycK0q8fVFsED8VnmykzGHB
	sIQk/PfOvBKoF+Om728f0N/qnDmX3V4=
Date: Thu, 14 May 2026 14:15:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <cover.1777936301.git.abhishekbapat@google.com>
 <2d1cbd93b987198d9569ff54b7fee4ae6aad5ff6.1777936301.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <2d1cbd93b987198d9569ff54b7fee4ae6aad5ff6.1777936301.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 73D2C40005
X-Stat-Signature: zbs16cd8ubhbipxk1w9zpb77ifmqpoe1
X-HE-Tag: 1778739350-251528
X-HE-Meta: U2FsdGVkX1/UAtx38kC/eyFW2gDtBsFBvtTvrzjumnYDB9Lv10APPc8MSqu7PzoatNfbqrSDFZ1FG22eR/HubOaaer3EIWmbIDYwCQWai+9HJtYNdt4BjQlC5Z+feK1B4utBRy4k1NLNGpCHYB1Jq17Pm7Zr/yzmuYMklrvmi+HJWUiZNTtpYCplqbvVU9LDiGdArTtOjmrJo0SIUmH7VC+d0voSDPYTbS84ZIB16CgwLDg6d5OtTr1Dbb0t9rjblpaoSX8fLjYM6BRugdup9htzP47SK94kXT1RocbMBzFCPF+AoHS/RGJQ1NpUCbx6UD3nWOCoeoiAGOp3hpwCWGP7gD+eTj8D602xuuOGQhF+qo1EDDIDr4jphcPnBlrGWKU2P/Bhg54P6BnxxsSXNUQnjJrN3/leWIBvFkgqKzOLuzljDdz265HpDJTNx7KVrSPqeGTIvcJqK9b1LAf9TvTu7ORl3+UuQIIxXz8k0c3hIpHuIXiOKaMG1mKpyHchd6fj9sB7pZJFfwPPk2wWE2UcT0YTfpg9ts17fm65DYpg7dVJqm2U/fGHMazv2Zuej2AyYqCsGXvlY6/m7SpH6nQ8i3zW/DmkMdAN5TqR1FEz3mhgFSbM2NKbbuBnAZGaAmvHqsbv1U7fixmXegHQ5JD24VmV6muG/JxBZ+CspIfQYLicC7gKmQv2WPRe+yg5b+DSEB9b/KsBIWT4guAvNdDIn1klEEnL12HvG2pIRE13DIS9E0sUXg6QB7CHiTRnZVoNv/gOYMLb9DvqjcJjLpc1QboL+BRjZ83ckaCUvity+1ARaxGj7HclH9uiCfzzUo1MYNezkkAdDZ+GdEpYaCE8yvjl7fDGn7ojczKFLsRWwQvzsnFC48gUHgyGorQ7mBNys3nHkqt+dspvWC05OfcStZOwztGiNGuaGg+QdYuDxLT6gKQ+f22yaZSmaFeOb7cnYTPoISDf7M1pkt/
 BUywlnzW
 HPW13u/YWF32V+89GWJxBybLeqIe4aqX0UeV3UkFqemfZey2Bl1mayG8ibtOsUJkAnoUwDhQzibG8vIu8fioNYLC4IF3/xkyUoVOhX/eRl1gjSe2rBnpstqRcnktAEZloI21dEfe4p2wlFZqkU6ghc4qtgKgxQFkacPw5QcXNe3IDGG+0nkm0Vu2PAn5qMyS4m527pGj4T/UWdKLZiv/5pvY1pE6Ibd6p3nVQr6lYWKB9VeWYSXXrw+caKFeEOZp0qL7RCe/bHYvLH3zMKHMc/dKfA8v0Chvx7R6z+DXo0INJfW6qrcERuYwTv+od27pl9Q34M4PyUqQI/5Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek

On 2026/5/5 07:36, Abhishek Bapat wrote:
> Extend the capability of the IOCTL mechanism to filter allocations based
> on tag's module name, function name, file name and line number.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>   include/uapi/linux/alloc_tag.h | 26 +++++++++++++++-
>   lib/alloc_tag.c                | 55 ++++++++++++++++++++++++++++++++--
>   2 files changed, 77 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
> index e9a5b55fcc7a..0cc9db5298c6 100644
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
> index 5c24d2f954d4..7ff936e15e97 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -47,6 +47,7 @@ int alloc_tag_ref_offs;
>   struct allocinfo_private {
>   	struct codetag_iterator iter;
>   	bool print_header;
> +	struct allocinfo_filter filter;
>   	/* ioctl uses a separate iterator not to interfere with reads */
>   	struct codetag_iterator ioctl_iter;
>   	bool positioned; /* seq_open_private() sets to 0 */
> @@ -156,6 +157,11 @@ static void allocinfo_copy_str(char *dest, const char *src)
>   	strscpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
>   }
>   
> +static int allocinfo_cmp_str(const char *str, const char *template)
> +{
> +	return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
> +}
> +
>   static void allocinfo_to_params(struct codetag *ct,
>   				struct allocinfo_tag_data *data)
>   {
> @@ -187,26 +193,67 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
>   	return 0;
>   }
>   
> +static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
> +{
> +	if (!ct || !filter || !filter->mask)
> +		return true;
> +

Minor: in matches_filter(), returning true when ct is NULL seems

semantically odd since both callers already check for ct != NULL

before calling this function. Not a real issue though.

> +	if ((filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) &&
> +	    ct->modname && (allocinfo_cmp_str(ct->modname, filter->fields.modname)))
> +		return false;
> +

In matches_filter(), when ct->modname is NULL (built-in kernel code),

the modname filter is skipped due to

ct->modname && (allocinfo_cmp_str(...))

This means built-in allocations always pass the modname filter. Since

built-in code doesn't belong to any module, maybe it should not match

when a modname filter is set:

if (filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) {

     if (!ct->modname)

         return false;

if (allocinfo_cmp_str(ct->modname, filter->fields.modname))

     return false;

}

Thanks

Best Regards

Hao

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
>   static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
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
>   	priv = (struct allocinfo_private *)m->private;
> -	pos = params.pos;
> +
> +	skip_count = params.pos;
>   
>   	codetag_lock_module_list(alloc_tag_cttype, true);
>   
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
> @@ -240,6 +287,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
>   	}
>   
>   	ct = codetag_next_ct(&priv->ioctl_iter);
> +	while (ct && !matches_filter(ct, &priv->filter))
> +		ct = codetag_next_ct(&priv->ioctl_iter);
>   	if (ct)
>   		allocinfo_to_params(ct, &params);
>   

