Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A14A5CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112E16B00C9; Tue,  9 Jun 2026 21:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EAAB6B00CB; Tue,  9 Jun 2026 21:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0276C6B00CC; Tue,  9 Jun 2026 21:45:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E837D6B00C9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:45:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7CCF40832
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:45:59 +0000 (UTC)
X-FDA: 84862312038.08.E5146F3
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf25.hostedemail.com (Postfix) with ESMTP id BB3DEA0006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:45:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="P/V6vWcP";
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781055958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MjK2AG/CmZHrXygvO+JBzz55qQ59KIIc0ieZs/MHmtw=;
	b=spnFz2pS7emfdyZieuwN+TW0uB1qh4Oh5iJN9Ox3mU5erQkXBmw38E8dVZbTwF4MWwy2Gm
	FbHY/3+OHazT8Ovx1jDgDY2H+s94tZTEn0sT8m0ELN1aO9WdfHSeZpWC5gjHo5Cy4pyE11
	NoNHT6rLL3FTamTt3sOWvT0VlvwVNk8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="P/V6vWcP";
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781055958;
	b=Rf+VKHp7o24DzjE5EMTg2zgW2yYAv0dySFpmDOzfVP45pj8kRhOZFcxTGEvhmV+Fj07wqC
	CmaJ81drTQNlvDPAkndab+tfByOY4sPddMDi9r8Fibu0Ue2mYnjLp+pvjn3cltpy4sYra+
	Y+1StPBb2w7LyA3VxVIyUY4Pczgqm0Y=
Message-ID: <bc5764b6-dac9-4db7-ad3a-b0fcc6259050@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781055955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MjK2AG/CmZHrXygvO+JBzz55qQ59KIIc0ieZs/MHmtw=;
	b=P/V6vWcPyd5ql3clSYWCYCykzEZisjLvbk9Jk3AfO0EGNuK17EiC9Dko/8oFkhJUF9D8hy
	0Tb4QKOIr5NipAeKf1YnCILLcCdE/XtzZF/92DV0u+3JUMBx8GLOu8yetLwp6tKl2Bo3+1
	1l/6KBNqDO+vRhkwB6aW4IFjycYgmxU=
Date: Wed, 10 Jun 2026 09:45:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>
References: <cover.1781042698.git.abhishekbapat@google.com>
 <8cd864b3bdbf89973e9a1fbd6e8ed1e9c08989b9.1781042698.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <8cd864b3bdbf89973e9a1fbd6e8ed1e9c08989b9.1781042698.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BB3DEA0006
X-Stat-Signature: ojoh98sa1q83psfxixy1715tfro3r8kc
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781055957-195707
X-HE-Meta: U2FsdGVkX188GiP4xWoZQQTs3DQIHFrp6ChI8oYLUK7nImdWXxoVy8Am1W/A6c5zL4OZvyrdXrFjf1DZ6WvKkfJiaeUXr/v6nLVXby5N+q4YWAphBaKpyBGWRMCVS5ChlOymm5zFxLmuy9Q0i+mWbVi9Hnjy06+ApDcOX1OHdIfGq9iavQzTykXpoASP81v/iuKVuIwybCPgwe4s+PDT5xuMp3doL4Oy+2uvEbxh8DqFGqHEwxwVMESiOeKmwFdS8RLphILkZb0gkP2ychtK2wG0wYWMAWdLTf20Ih9cwMbBdgr7vBsM5E4o4KTe8VrXEmzI4DsPeOTlfkMAXpVQVbcSJS12ll6pl8JtS+m+5st9T5Ststj0V2eiR8EPytiwQIvCZG2sSoHc2ddiWj9uMq3TzxEm1YnrWW4Xb4CWG7RSTe10UxiQBcEc++T68jcrjEQyZQ8QyxhWnRIOKKSXvwARb/FhedFoPr5RV+Gw4LhMOBzC6loGH16OG87EXdGoAvRZ1cOnvHugQfzltGevR5kCwHPQNzOui2QgxT5MIRBj8SmnOd4Od8NYQvoXMUH1M2qEF5GtL6Iy4YH1nCVW/znsuWqswbV37JT9cxxHU/+8a8oOWdsS1pZxw6aZL0NYHshtrIlPGfIPQpaMM0FfuoW+Z7GsuH+NbMsvfHPqVGdYbKKv8i9NXLorYuQImRg1wvEbsfqsSovd61Nrv/1FvdDgEiKskg0JqqDzu9xN2LXAxyVPLE96heVxDxf3svCsRcJi8Qti1d0PTcw5ahJrfa/t0xeYcyV2vSg6pdKr7q63VKmsfRTGoGlEqnz9rntoNX33rPed7rTXjvphbbOaPagTlAbbVXiO3JjFra1zbVJqNmltVjeNg6vyUdHcerLk0vnSvT1OMzB97mDIWpDGL/5XY93S0nzmMnN+8o3/i7hHSCxGGTSKEMu7EW46tPsUGkXsRUWyi39ehC0Uam/
 j0UeiAc7
 rJqK6er4wOmupelXwduNzjJ3VwfCEh06kIcUPo2zjkHLsm2MZCGjWZJAwaPXkuvTFXQbyWjBoob+pAzCwQgCglTGUcGYi894tWC0B6a/dtKB+1wQ3kq00blRKBEsQydJjBypujxeqhqFDGi9n6rgMILzoPXsmPRKaUcpfnr3o0UWVskOtNpKporoqgcGygRAxJEsgg/Ym1tZavF6RVnYI0lmpYqP3a6lUaeNTCTyChSeoWBJy7xqiM5LcPO86qQnvwJNYjDjQVImCD3/XWwB3vtCJp1S0cVKTH2MMPGAqLgg2aVCjsrcA1wQGNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/6/10 08:12, Abhishek Bapat wrote:
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
> index 0928e1a48d49..3b11877955b9 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -40,8 +40,32 @@ struct allocinfo_tag_data {
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
> index a0577215eb3d..378fcd63b6c9 100644
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
> + * matching its characteristics against the specified filter.
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
> +	    ct->function && allocinfo_cmp_str(ct->function, filter->fields.function))
> +		return false;
> +
> +	if ((filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) &&
> +	    ct->filename && allocinfo_cmp_str(ct->filename, filter->fields.filename))
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

