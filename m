Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00680FE520C
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7456B0005; Fri, 24 Apr 2026 07:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258346B008A; Fri, 24 Apr 2026 07:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16DC76B008C; Fri, 24 Apr 2026 07:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F277A6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:26:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 879218C5A0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:26:45 +0000 (UTC)
X-FDA: 84693221970.27.D29963D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DECBC80006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:26:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wHC15HWJ;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777030004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZzoyRcQaU7uZ02RaxY8B3FbX1c8+lzty0EiRWmT1C/M=;
	b=CvyR+kGSBDVOcLLFMtWEpMMlUG3lKJ3K1cqP1rTvacFhZIIl7kaoe5/yjHeDwylBcWgeWw
	vFWaX3p4rizJPzzE1mZVC4urAPYqvn92ESfgqAOYHbIFJH51aZhZzK8Dm//xDOjfAaiiSG
	mvMEvDU/iFfar6oTPa/0JB3F8ft2wYw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wHC15HWJ;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777030004; a=rsa-sha256;
	cv=none;
	b=biA7L7mfud6142mVn3jiOj0f8y1RNI3IKdnU6JZITRZ9ZAlYeNVNWMgITUMKLpMQNq2w+1
	tIArEP7RrG/y2RBvCV2QsPSbcEYyDCMrCSMW28GinAZU3irOwGzXnHR4lUK0YgEgOuH61O
	uIUx7tldZOIyQYNFAV+QEDYSoJQ8rIQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A3266001A;
	Fri, 24 Apr 2026 11:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86105C19425;
	Fri, 24 Apr 2026 11:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777030002;
	bh=BLauuSDU9q2hNlHnwGzJsqz/KReSztervXoU1Q8mtdQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wHC15HWJH70pwZVT4mBhRwouJo6dUkrGPs8WSCHi+btdzTMV6hRori3PN9WacSL7H
	 i6wnbivYhphjMCko0pezCYFON1UdrkZ9ZGTr1I7iu/i5ZIm8CZLy3x36vEbH7tlHWh
	 Wqozdp5kmQH382gFcY/0iSclSbvAqFk80Ef6y0jw=
Date: Fri, 24 Apr 2026 04:26:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/page_owner: add NUMA node filter with
 nodelist support
Message-Id: <20260424042641.b2fbe039ffef2935326077ee@linux-foundation.org>
In-Reply-To: <20260419155540.376847-4-zhen.ni@easystack.cn>
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
	<20260419155540.376847-4-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: as7y4x1brnun3y8cfu5igaq7ne91s44y
X-Rspamd-Queue-Id: DECBC80006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1777030003-508732
X-HE-Meta: U2FsdGVkX1909ZkvY+NkUApnFpHDu6RY4xWAIZ8k/2BiufIy50vI61EH3Y03ZYbp5tn8aWHMcAv2UBrEmH3G0D065tKAc1mi14G7VnBV/35upA45LqC7YjHT1SAgcd0sLjv3Y/o2poxX6CRvXKCo+BiMyrf4145Zz8wA/Kk9Cyna4cjFxp/cdwoP9TDbzDwWG+kf1JjElGLqmsjuvG/zdNnRvqaJhfgSsheKEMrQBpBlnIERtLOEhdsDmEAfJuPteT1tlb9VUALSyfifDZyPxYOC3BIozt/IX/YW+Jft/I3XmeVhvLJg0goqAr4NtX9Y5Ny2F95/Tk/iICuUdy+xV4yZhL561TcHzBliCpECFyq1GKECm2HQbiP6HZwKGuXrFsH+egO2t1xDsjcdYDZ0JQ/j/8uJ5DS587S2KLtWD8B155Dp1qFyi6pAGoDSDgRAaJXxma3agDtlw92IeJCsd2bR6MuQbvaPc3uWHEXhKjhQJvebKJVrDKBUL5Eeb6zqHDqAeDmRXE98f3Xf+X+rPo0m8IDaaQhaKp1iP9I1FUKPxz2J0PR3oMnFr6Lfd9u5Fn+bkMemnFdp9PZbRhuRSD5Zpp0KRTkBOGJBDP9UWFt2f3zs4tc7XM4TYr9bUwllshoZyV0Bj0ZNZmU5EgAzswgiJH7tgNwru3Z1N4+BgfYYVQXEbHURRBOl4ttPDbuiuGSUIvM2X3MHw1ubTqsz40TEhPJWV8LHeaLd3q0eujSkw+PYzvqcA/xODxvwvtvrKQ/Ty77ReUTsvpPMw4LJUdPM+W+bD+7nU9KLQXLGFHxOEct86gAHcZ5pxcWiEjNh+HuAxeJh/+mIRx+ZNy9yC9pWPfes7J7nkaJQ+06gw+MRqb6aRHM5SrSfPU5dJ+HIym7AUXbsbl31Lbo0SSwXDPgy7ztbLs8gYtHlTzNmnAn3bhPQyNsA/urvMCGRWX7cds8HbrH1PdJDuigBx06
 m+Waerhc
 Z1Xz0n/EsicS/1hdeZRX9xt3N/l41OvZaTpZJ7kdLpAWILwwBqN5ppnvrDvB5BKrjRHQMDT37CvPfhvWBlYeEokpAznTGUZF9j+0yqLcGMMLhSAAcJF4ki9a+Uwm7bk7FEHijQvpfEY5n+zjRm6moW435bcRKv5cP//4W/BvyHX/GRpUwe9pApyXzRmJmcjJ06n5/tvrf6FAMTLO+0Y58P6Ql8WrIBvhWGcQgquANOizOKHFGzQWBTdgviga/eaucTT7TAsEKKWfwIhC0DCR5yuogXMJX1uY9dOiL8yt+6DQyNJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 23:55:40 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> Add NUMA node filtering functionality to page_owner to allow
> filtering pages by specific NUMA node(s) using nodelist format.
> 
> The filter allows users to focus on pages from specific NUMA nodes,
> which is useful for NUMA-aware memory allocation analysis and debugging.
> 
> Supported input formats:
> - Single node: echo "2" > nid
> - Multiple nodes: echo "0,2,3" > nid
> - Node range: echo "0-3" > nid
> - Mixed format: echo "0,2-4,7" > nid
> - Disable filter: echo "-1" > nid
> 
> ...
>
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -707,6 +707,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  		 * user through copy_to_user() or GFP_KERNEL allocations.
>  		 */
>  		struct page_owner page_owner_tmp;
> +		nodemask_t mask;
>  
>  		/*
>  		 * If the new page is in a new MAX_ORDER_NR_PAGES area,
> @@ -730,6 +731,15 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  		if (unlikely(!page_ext))
>  			continue;
>  
> +		/* NUMA node filter using bitmask */
> +		mask = READ_ONCE(owner_filter.nid_mask);
> +		if (!nodes_empty(mask)) {
> +			int nid = page_to_nid(page);
> +
> +			if (!node_isset(nid, mask))
> +				goto ext_put_continue;
> +		}
> +
>  		/*
>  		 * Some pages could be missed by concurrent allocation or free,
>  		 * because we don't hold the zone lock.
> @@ -1009,6 +1019,70 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_print_mode_fops,
>  			&page_owner_print_mode_get,
>  			&page_owner_print_mode_set, "%lld");
>  
> +static ssize_t nid_filter_write(struct file *file,
> +				 const char __user *buf,
> +				 size_t count, loff_t *ppos)
> +{
> +	char *kbuf;
> +	nodemask_t mask;
> +	int ret;
> +
> +	/* Limit input size to handle worst-case nodelist (all nodes) */
> +	if (count > (100 + 6 * MAX_NUMNODES))
> +		return -EINVAL;

I'm wondering how that expression was arrived at ;) Perhaps a little
comment explaining?  Or can we simply use strnlen_user() here?

> +	kbuf = kmalloc(count + 1, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(kbuf, buf, count)) {
> +		ret = -EFAULT;
> +		goto out_free;
> +	}
> +	kbuf[count] = '\0';

Can we use strncpy_from_user() here?

In fact I thought that we had a strdup_from_user() thing which does the
kmalloc also, but maybe I dreamed it.

And memdup_user_nul() could perhaps be used in here.

Nothing really fits.  We need a

	char *strdup_user(const void __user *src);

(Probably it's OK to assume GFP_KERNEL)
(Maybe needs a size_t max_len arg)

> +	/* Support: "-1" to clear, or nodelist format like "0", "0,2", "0-3" */
> +	if (strcmp(kbuf, "-1\n") == 0 || strcmp(kbuf, "-1") == 0)

Maybe

	if (kstrtoll(kbuf) == -1)

(we have lots of goodies in /lib!)



