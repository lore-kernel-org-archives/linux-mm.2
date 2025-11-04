Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE8BCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 16:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2628E0006; Tue,  4 Nov 2025 11:28:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9F78E0002; Tue,  4 Nov 2025 11:28:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7058E0006; Tue,  4 Nov 2025 11:28:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4738E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:28:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9202C05C7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 16:28:23 +0000 (UTC)
X-FDA: 84073457286.15.05A6EC3
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id A286C1C000F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 16:28:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eF8n+WLv;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762273701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3//+jTHpFI9d8cfB0MZWvkTOZ6oCdVcw3sYJzM//mw=;
	b=simqhYH6a2nwsT/tJ9Cqex1HAZbL7W5D1NHrd5efHCohKbaa6Sr2y7qRrAkUjCkQLD72dO
	+L7yIsPt47u5wAJ0/NcB5KFDJuh5ZUvBjOx+hC9w6L22y6FqYHj84QRQUoGToRvKgGD8hx
	30Iwo3ZOZwSBie2stBkA1w5xs58ynLk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eF8n+WLv;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762273701; a=rsa-sha256;
	cv=none;
	b=2j7aTFVPwJjIIzd/kZWOMpCJ0FGdnx7ZY3mrylPgBCjm3efF0y57Ug+s8IcxNpUpYTAWWF
	D1VvfXH/tyL0sJI4S+Aq7K8g1hH0T6PmDE342e6RxMyKNGnQXshnsH3xaMtDulKmLnD5xK
	yxQb0z/msDKqRHju2y6hhBXKNZNTIqU=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-375eff817a3so58277051fa.1
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 08:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762273700; x=1762878500; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D3//+jTHpFI9d8cfB0MZWvkTOZ6oCdVcw3sYJzM//mw=;
        b=eF8n+WLvs0FgEIf++PVaafsljiomZsxC4u/5cZbLYv1SpwE6AeRzyzk4bTmeN35zud
         7IkLbsGWfKW1OQqPdzKBbfZknVcZuYnY3UdX6ANixROmCKuAIT1GpmevpXEm84zTG66m
         1f9R7JKdKPUfNmFdJOgC/FNLrW4Xhxrv2YJDKOVurFxrRno1wzFMMpoUppwI7rrxBzVn
         9uvyRFkmbKPWEEBvqFZv113E+ByxlFNgazIMQRO9qUjUOozffGYbDqamsr0H4xw15TxV
         TJ0ExAkZip6IRha4/hvuKtOlBKK4r9sOvv+sRfaoyKTO4IbXtLt4TV3LwGIarFJQRWA6
         nNnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762273700; x=1762878500;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D3//+jTHpFI9d8cfB0MZWvkTOZ6oCdVcw3sYJzM//mw=;
        b=kriyE0+UA+NZTV8+iFqrhkY2/7TZJbacgI7dRNH+AIsPRjgyxOKX8DfjyQphyZRgvP
         cB5soTceBxGRzdnFOllY5PicCWzFtbIq/LlSFIyBmcaOi/EYMyJJCILEm6CD2bH8slZM
         3Kb0r+bYA2uXmYK0qIZvf/AiQArISQhRE1pvcpZWM80YictqCXtpMlRbKBu+F1o0hb8U
         Yw+0/PeR6iZuzTpploK6V2+SVJH0/4zD/nTBGa7tqBzkaKmBkWjxZqnLEgCUz7UX3m1z
         lf2SNWuZMIju5EeIhh1IxX1mEBWw7I+1fhXQ9UmFwrzul13ukC1AfVf0Ac53VzI3zmSO
         zlFw==
X-Forwarded-Encrypted: i=1; AJvYcCWvE1VKsipxXvu5BtcoSKSNcRajaPHjFOOn17r908zZiJ8ysHwibjWkSjJWFDL3LdXDU8tNFANYYA==@kvack.org
X-Gm-Message-State: AOJu0YyqNKjonMFXI4z2bJuW51G3VJMa0kt84OOMtXgGODlHAQRKNAgN
	mpOChFowWvzQuejslvUMDX1e6GaqwBdpdfQuw/khakEEZQKIW38r87rJ
X-Gm-Gg: ASbGncvjecP+EynIN0VWhgGV+dxUdcOZKACs97+cLvkWGXUFk0/MCa+SrvYcn7CnBht
	J9QqIjYpUzkP/kUZuQbPg5pLhD0y5DWqJDPNg+gkZjqg3hkr3bViW+FN7BI1SomvkhU0R9xG1MQ
	+rybiygvfAEszSFOR/Scyu3rwGCGmsfJxaJO1mD+TCQnIfBcYtzSalakye1RPRalCOjklURPwom
	hAFfFkiBPYmsMO9Wp2gb8unFGJTRwPXwWw3QG5iDShOwIQGZA44eucHETbNzVJsIwydjisprKiV
	4BuTh3h+pA7cOwQM0/WI3iiNEZV9xXxw+mVU33Sn1uChFjXPvZXAk8dRuIv6Ls4xohb1nEYaCht
	VZRDaaTBzBTLgs14NwMdB3TioCyAeahj8ypKkNbEq6tNxDx3DKT6vHTR+z0FmiK57HjuQnwjDuU
	SbDqAWObt7ETlZohrFlcjyrRadlvrSvLJ8HbNA/eo0
X-Google-Smtp-Source: AGHT+IFpPJW0EL8mv4XB+dj+NnYnvkCKGwdjuuEaBQ7yJRBm0XScezCAYmN9KpJk43TOeRccgj7dAA==
X-Received: by 2002:a05:6512:6c4:b0:592:f441:928a with SMTP id 2adb3069b0e04-5941d4f5466mr5684183e87.3.1762273699325;
        Tue, 04 Nov 2025 08:28:19 -0800 (PST)
Received: from pc636 (host-90-233-197-228.mobileonline.telia.com. [90.233.197.228])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59434454841sm844491e87.101.2025.11.04.08.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 08:28:18 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 4 Nov 2025 17:28:16 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Message-ID: <aQopoAj3i2jdIX6V@pc636>
References: <20251103190429.104747-1-vishal.moola@gmail.com>
 <20251103190429.104747-2-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103190429.104747-2-vishal.moola@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A286C1C000F
X-Stat-Signature: pwomg9so4kzyiam84ogzey5cx6jkcfo3
X-Rspam-User: 
X-HE-Tag: 1762273701-634402
X-HE-Meta: U2FsdGVkX19NcccvnyjLYAEF7idYC5J48p6oOgKRbKcrW8j1E6BA98UC9zCjNkO724EkTKve2iT90SmDu1jp/U0UwWD2mWLke6USn3OIPVtBJrJZ3cANbsD05NJ4Xohoyg6XC0pegobmV7lK2r9GTLv2Yrb5TDdrIwBIb+kahiVsXsblK6VMosuQ/pgmBZ9CYCfgSzI+cbClrsIkQEfrE61BznDE/koSh66dw67YD2ljvUxwWmTSaG3qVgeJBKlrT2XtJZB4+YfFDxv7pLy5d1v5JRegguM+vlFl0FFeOgVYJTLnVunFZQGrRtFfnFZRLOFMMbXU8G6Kb/zMPqYfngkaWZhzgaW3cZTnyjZzKJEV3d9qZ5umW4eXEKUhiTO9JCN4mmSQUWbvx2JX7ze4udhHo6evVRJ2pcP+jUs8+cDohhkI2Y6JJVes7FRRR30XHho9exJefkAqH3b7Eb7q86sEE6+WiHAtFiys2eYsuuJjCEdCJgrIAlrvWEvRaRfC5OYhcE2nmLoA2VHivNrQYvYMUFTOz6fBL0R5BOKkP+aWhWto+eeUy5NUkUPIPGIGLczXP1rDuERyhpo+Nmeh+icnV2CPn32ilXGJ2VsnXMk+pN48kyYaGknrxaxBcYbLNhAo8SdtQNzH+vBtbOL5W3eTgApquhjzH3+KEBeeoU6n4PBLpNF7xmzTC+CQTs+si4nGgQeD9FZroyL601uUvGKthoF7bMRKzWSeiXxMswRtpmFKjVFO+lCZGsGzidU20VuLgxmFz5VWdqYrjcQpLgWkE6hC5HeH1iOel3DHon7hcxIAwKinWH9ttcHJNwpVoJNgI8LOOqL5D4EXdMUThE20LoIRK8sobpC6wCERkGPMuvEYOEWoH+tB+0du8x/N2riVSQnLJeZijkYiIpP6Bs3Sw+wRTB/RQCbCrKE5dUJ1L4srxk1jp55xTY6q98hGcPXrSLClnrbQ5mVRhTO
 eSUC/MzV
 qc0yTQ2tulVBhWKZwahnfGjnwMtJpsw/O+lyiSnsy1gO+0VZRKDrE5vHGjQUO+N5J4AoxJFoUaZ9mXhMMDz8tXRRxkEL5lV152zLb/79o/+RYbWPQ4qBvy0avb3TwpIO4wVl0/md7K/AirWrDDxb+VzSzyUTtRJEoit4DUdpvUIF0w09LfsJSNZ0jexTrt+EOg5NLJAbglY6hLr+E4aV6XcYE72GuLI8vUG9AJVFNC2hyBBGQhsABMr6KkOts0jAKkLeXPPfc1u6laam3H93ChMF1kWUSvn389IErIMnxlDOgKup+cGKXcHQHiUT8WRuTnOBFimWsjqFDOK4ME023jgCsE+IqwTq8x+LswxDCRy8Bdj12nr3Ir5TGLk4On2xID7r+P8jXApFi7Xb6W3NVIZeolh4bJKRJE0UJYyxR5ZWFs30b4BYM0C8gvNcgP01fJsEqsHDFm2Iu9HQRpz4WH3agel+k6jA3i54R5aWc8I/36Vp1KrLL1xtSrWf2DIFz5QQ1jQeVKjYL0WXDRVm6HjkS0M8kSIGfEfn9CYi/wUOjuI/FA0/xqNrgfHQk5+HgExdJa12uSVoajWr8ppZgLZTW6deyw6kmr/NMqc9/QLVzEpE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 11:04:26AM -0800, Vishal Moola (Oracle) wrote:
> Vmalloc explicitly supports a list of flags, but we never enforce them.
> vmalloc has been trying to handle unsupported flags by clearing and
> setting flags wherever necessary. This is messy and makes the code
> harder to understand, when we could simply check for a supported input
> immediately instead.
> 
> Define a helper mask and function telling callers they have passed in
> invalid flags, and clear those unsupported vmalloc flags.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  mm/vmalloc.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 0832f944544c..290016c7fb58 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3911,6 +3911,26 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	return NULL;
>  }
>  
> +/*
> + * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
> + * This gfp lists all flags currently passed through vmalloc. Currently,
> + * __GFP_ZERO is used by BFP and __GFP_NORETRY is used by percpu.
> + */
> +#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> +				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY)
> +
> +static gfp_t vmalloc_fix_flags(gfp_t flags)
> +{
> +	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
> +
> +	flags &= GFP_VMALLOC_SUPPORTED;
> +	pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
> +			invalid_mask, &invalid_mask, flags, &flags);
> +	dump_stack();
>
WARN_ON() or friends? It prints the stack.

> +
> +	return flags;
> +}
> +
>  /**
>   * __vmalloc_node_range - allocate virtually contiguous memory
>   * @size:		  allocation size
> @@ -4092,6 +4112,8 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_noprof);
>  
>  void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
>  {
> +	if (gfp_mask & ~GFP_VMALLOC_SUPPORTED)
> +		gfp_mask = vmalloc_fix_flags(gfp_mask);
>  	return __vmalloc_node_noprof(size, 1, gfp_mask, NUMA_NO_NODE,
>  				__builtin_return_address(0));
>  }
> @@ -4131,6 +4153,8 @@ EXPORT_SYMBOL(vmalloc_noprof);
>   */
>  void *vmalloc_huge_node_noprof(unsigned long size, gfp_t gfp_mask, int node)
>  {
> +	if (gfp_mask & ~GFP_VMALLOC_SUPPORTED)
> +		gfp_mask = vmalloc_fix_flags(gfp_mask);
>
gfp_mask = check_and_fix_flags()? 

--
Uladzislau Rezki

