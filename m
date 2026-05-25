Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B04CD5BAB
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 03:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB15C6B0093; Sun, 24 May 2026 23:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62836B0095; Sun, 24 May 2026 23:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F176B0096; Sun, 24 May 2026 23:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8953C6B0093
	for <linux-mm@kvack.org>; Sun, 24 May 2026 23:00:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30BADC3E72
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:00:49 +0000 (UTC)
X-FDA: 84804439818.03.AB92E7F
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6373180009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:00:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PADIikT6;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779678047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/vfFUAUvvzoN2lU2+u7hA3dbwyNyJR1IImbRDNj9+w=;
	b=vcHuK8NLNgR+v5AhZSfNuf4p7oB5SZljnrYt8UZ1qaGIKIccgN9aRhJJ2f/wkLZVSDChAh
	EtqynQsH2xWxGk+j7zgLHQkyOdwIiaN67fUXfdt0Qx3hUajAtwa5peE+Bb06rOH924BGER
	HIRUPqjYeOz/8rUhQFjTWeX7rJkj/ME=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PADIikT6;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779678047; a=rsa-sha256;
	cv=none;
	b=YvKsrnf4f53FqpW0ij69G5M8QVAX1wYTRo1oLRonGRXs9deyeyHkbeQVNnlBiim7mgE9gD
	7ClXHr3/EJ2Sl6kmnkLOkFFsCJvyKDwNKkEVn9uGLHqj9IJCd9WMB04gAaJsHQf6qUtpKU
	+pTXcFdGnWAlZqs4c9b5Yowyw5qBjYo=
Message-ID: <aba73999-dc29-45c1-b6cd-54a7c1b824fa@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779678043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L/vfFUAUvvzoN2lU2+u7hA3dbwyNyJR1IImbRDNj9+w=;
	b=PADIikT6imgTJUGlmhoiLnsI4UwjhCyANuEDOb9Or4Ke1HY1P0qsbbsC6qUNRsSFdEPm4t
	VA8ZAt94OfjHC/RqK+Intb/zt++crwxRFOyp045rVGCMehtteMs6/I3J8Swmwu9BNgpUP7
	q/nejSFaamNfADN24GqeVw2wD+y4k3Q=
Date: Mon, 25 May 2026 10:59:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>
References: <cover.1779471082.git.abhishekbapat@google.com>
 <f177efebdfda5c2a179d7cd6768e0c6f37efb9c4.1779471082.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <f177efebdfda5c2a179d7cd6768e0c6f37efb9c4.1779471082.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6373180009
X-Rspam-User: 
X-Stat-Signature: z5mi47efcxi4aw3g4dwtwywkddi4bnmw
X-HE-Tag: 1779678047-534453
X-HE-Meta: U2FsdGVkX1/Cxh9tzww6eclzU+fn+3Dd4QlRZE4Py69MsHt68Vb5vuoj66aLkr+21GIiezeJuasfbSKd1NrY982rpYup5ouSYj5dv0e4qHnDMS5c+No1Cm3Uh1jWN8PmVsEKXklFJ8A8/eDqViIwH8iDh3UGYrQEKde7G55X9a1ezf7zUO5zEMgUa2k8ypihhWeIP7w4xzbTszp+JgxPNaITSLKQLwKsJbw8Kj5BuiEuHBO4KKTAhsdAB70cX2vTWFeSH7uBmPyqHAdRDJHxrJjWpskxE5CqsG0cGhSL051iun3cncmwlAuHz8L/tWg05/mlvF9heb4Rxz4sORO2zk05f0y91qxxUGkzVvbEj3VFdNbJ1yCkWABV4FCmCYnPD5b7FrpE1Z4vk8BJuK7QhW75ud34Y/jGtB8FvKVGoOh+Vgb9iho02/yJobk9j3zopoKW4RiQ5h957Z9V3l2laCPaW2aBkWNB+lQpXfXygtqLNPpDR+iWaHiLHFqsHai2IVy+xGZLx2QZFVJWZee/GboQ/iMpyKok7iUFegZ24vU4mhwjNOiyHwym9c5PL470XOlQWjxNsRk2d1ByVGWquVq0PvMwTKR8UUD5Ub2go71p+pKQLnUPfzGJIuz/LhFtKFanqUSeaPVpKz3dymPbX9tyQn5S36e/gv01k+inHrxJGizxY4l39FoanHI4v2LjaAaQRJVtgiMrCLxWI9J2/KyH90g8I1CIFcbdKdOl3Cqb5UY4EBzoSplp3xCtKWjVaflrXI7jHoaztRBymvYDelASapcY45ih5KKZuyoq0NSeowhpoYVWcSLtfsej/YGDagSCR4cINzhNHmfMcQBU1LasK6jMezLa8zdqt0Hn9CgUI1RABsILZRX31WWpaO0lCjDDtM8VJWe0qROxthXnipQeOsBbAUvx1JNPDMVWgeu4K0sipKSKEku4nL4H5kYtiK4kl3ikJqTvAYvGOdy
 QKiRbCnV
 uiLCVEecGqcG8rbTOyRKkO/ao4Obnd3adULJEkh0yob7aI1o5eDaaHBYip2evv8/AcVbEB+XS8F4zHVlVcdW6qptKZH2BVs4fFqyvxhOo/MgdlvdVwkfVm+q8v9z9NgDIpkjJr1RejvEggSjnt+T9ABFN0DCd4iP6uwvTGrOjHf/7HM9wQZUp/BPG+MNGKxtMaPh12eTDWTVZ2Q8z8Ys0kNiGy2kTkDHW6GaWKDGADIYAxx+XgD2Da602EkGELTZq/Aux46kGa3yAl1wUWKIz75583jLqmt6q4sNZ4EGjiFfcztlJWcVe+FVcAQ0tsF3X0g5XafgweK0vt1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


On 2026/5/23 01:45, Abhishek Bapat wrote:
> Extend the capability of the IOCTL mechanism to filter allocations based
> on tag's module name, function name, file name and line number.
>
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>   include/uapi/linux/alloc_tag.h | 26 ++++++++++++++-
>   lib/alloc_tag.c                | 58 ++++++++++++++++++++++++++++++++--
>   2 files changed, 80 insertions(+), 4 deletions(-)
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
> index 3598735b6c93..56c394ef721f 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -48,6 +48,7 @@ int alloc_tag_ref_offs;
>   struct allocinfo_private {
>   	struct codetag_iterator iter;
>   	bool print_header;
> +	struct allocinfo_filter filter;
>   	/* ioctl uses a separate iterator not to interfere with reads */
>   	struct codetag_iterator ioctl_iter;
>   	bool positioned; /* seq_open_private() sets to 0 */
> @@ -167,6 +168,11 @@ static void allocinfo_copy_str(char *dest, const char *src)
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
> @@ -198,27 +204,71 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
>   	return 0;
>   }
>   
> +static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
> +{
> +	if (!filter || !filter->mask)
> +		return true;
> +
> +	if (filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) {
> +		if (!ct->modname)
> +			return false;
> +		if (allocinfo_cmp_str(ct->modname, filter->fields.modname))
> +			return false;
> +	}
> +

Apologies -- I previously suggested the "!ct->modname ->

return false" approach, but I realized we broke the ability to

filter for built-in allocations.  allocinfo_to_params() returns

modname="" for those, so a user would naturally try to filter

by modname="" -- except it never matches because ct->modname is

NULL, not an empty string.

Maybe something like this instead?

if (filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) {

     if (ct->modname) {

         if (allocinfo_cmp_str(ct->modname, filter->fields.modname))

             return false;

         } else if (filter->fields.modname[0] != '\0') {

             return false;

         }

}

That way modname="" matches built-in tags, which lines up with

what the API actually returns.

Thanks

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
>   	mutex_lock(&priv->ioctl_lock);
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
> @@ -254,6 +304,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
>   	}
>   
>   	ct = codetag_next_ct(&priv->ioctl_iter);
> +	while (ct && !matches_filter(ct, &priv->filter))
> +		ct = codetag_next_ct(&priv->ioctl_iter);
>   	if (ct)
>   		allocinfo_to_params(ct, &params);
>   

