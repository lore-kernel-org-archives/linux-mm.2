Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE10CED25C
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2726B008C; Tue, 18 Nov 2025 04:34:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B739A6B0093; Tue, 18 Nov 2025 04:34:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0156B00A4; Tue, 18 Nov 2025 04:34:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D5806B008C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:34:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77FE816019A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:34:43 +0000 (UTC)
X-FDA: 84123218046.26.8CB25E5
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6399BC000C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:34:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Mdlu/5aT";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763458481; a=rsa-sha256;
	cv=none;
	b=B+N2TF4JqMqIqRB/7Bss5JcifImSaZPKf3sZQqGzdWfb7DnVwJBaBA30wb2IgRSb4aOyrr
	U+O8YiRmZXV/bDeIytSqTamjqp6qXQyMDao7XPYeIj7l9bu75G30XSQXhKBeR5yBSvKeSw
	sMrbGwAiLgMahqyiXZw5OOvdP9LQuW4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Mdlu/5aT";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763458481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqcgtmKu36yGOEI8Pko6WxzeIhQjSBh9Rhu3pqJUFvQ=;
	b=wu+xuWkjAO22svwTQcOFzxAg0ZipRuTL+l7vcHHcLpicyUmUqYY5kNyOBqnAanp6LAsDZJ
	Zf9WJeA3dVdtQpRR0WTv9IJVSes+0Clp9DYDQpZPSiheYxxZqsAXesUrrEoeIKZC7v/Vuh
	FX87Q6iP/az4d53Ji8+3EGg24huWkjc=
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-37b996f6b28so49469281fa.3
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763458479; x=1764063279; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SqcgtmKu36yGOEI8Pko6WxzeIhQjSBh9Rhu3pqJUFvQ=;
        b=Mdlu/5aThZwWJOi+WreqQzI2jEfDyGjUtNu71Pe8WnEzn0GbhzfeyQcidJogp7HrE+
         FLbyMmjv118xdd+ONsSTBZp6JV+5kezNU9BtloriEZObITVjUltuRwwBe+ndeVLz8F5/
         nx6FowxZApDcAP4Ys7GEZviRC6D6B7IUvFaq0FxJALi627M8xsmc2yv+XJPbxOiaiRJO
         d9slTRhoXXY7+ltSktCFb0FKbBncpNes2UZTXtXTDAqr8O8+X6rOa85rrTXcwMCFxeok
         9Q66NrnWOzUUYIC6oRBC5lRkXxBXaqRpHK0sBcSIcDy01jyb5oSbZr07yRjknQ3kxuDc
         9xqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763458479; x=1764063279;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SqcgtmKu36yGOEI8Pko6WxzeIhQjSBh9Rhu3pqJUFvQ=;
        b=HndpK6bfhL9yzULIVHrlTov+rG8mjrBmE+muzDCQ5SrdafwhRb1zwkw460r+ISdRYe
         P9JTUC0BcWYd1NiYWml3B/deBqZ9ia0+Uu4Klf1TZC2ZFNLoZOkL7F4D2D6ocJbG1ehR
         sDzx1kB98MvMk998dECn+fbxg9tqTbe68az+lqBivjYvtQ3MlG/660e4R3Ueuiw8w6bv
         4zs2QHVb/1g0rR82idyA8jBrtKpyiyqcKd+rSGh0th76VT6ou3hHjkgXFIcgCPC99JIe
         X/ysO7Pf+xTDee+NH9wWQh9HgaT8fI0l1eV4ta5yKthNUvzxFDCfMDSgz0kUhWkpY8yh
         eLOg==
X-Forwarded-Encrypted: i=1; AJvYcCXxJIBclY866MNUUmICrr2/u91AnaYSVLblAGcFSGgPeWAl3wLkcKkCeuc0RpyBKpv1IEB7kiLHrA==@kvack.org
X-Gm-Message-State: AOJu0Yx/94dXJrxTj5BjTZymC8jkV9Fn/FI005K7o3ZAYUA5xiG5w+n/
	uKAEZLiGYey8X1OQn6X6E7Dhnd74mmIj9e0QkP7wdSmt1NLvjEu+DNzq
X-Gm-Gg: ASbGncvgqgoMSaqlsE1eaWB6vOx5HaRJTIOygYJr8n014gk8Uy3CXH0Yyy0pJxdLSzy
	uzjp19O4bWjMCcYUPsIk0qszTFl7WBn/GtqSQDURa4DxdPkaJ6q24oXbbHyS47J2U6A/A7ef2/V
	czIlgxKm5OHClp9If6i69WBtoul6+t5mBZ3MpByG5wP6oZUYiz6IsxKCAXI/4JqFd+ZvWhpxfxy
	i/LP8Yb3Gi6kHmytPRtNQk/6rRvBgOdcEuwXGELZcIbu/JvA5mUyinA04eaA2oPuybIlmE4YKLF
	se74j+js3h1oybKrSS/an2hIVS/OaBmqcO3DMUCzFTPM4x/DLh9Ji+iMhguDCmNayAnwPmyq/hs
	gwldGzo1sjxFCTUyF6PTZA7ZWiVV2umhFnGASgITavzDQdYAbcX1jELN9I1d33LdqV4a0kNLy22
	eeMk8NONnrOiK6S971Vnj8so+KOJ5sXQSHtGu0mSdX
X-Google-Smtp-Source: AGHT+IGkdRAnCzdans0QSjjqeWINwfYXF9anLqr0LKbujqMjX6imLeve1k1SvIKyWvJPxmfqbrqEhg==
X-Received: by 2002:a05:6512:3d1e:b0:593:4a:a5d3 with SMTP id 2adb3069b0e04-595841ff545mr5445493e87.22.1763458479117;
        Tue, 18 Nov 2025 01:34:39 -0800 (PST)
Received: from pc636 (host-90-233-212-127.mobileonline.telia.com. [90.233.212.127])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-595804004aasm3859270e87.60.2025.11.18.01.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 01:34:38 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 18 Nov 2025 10:34:36 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Message-ID: <aRw9rJ5hx2Wrtq_Y@pc636>
References: <20251117173530.43293-1-vishal.moola@gmail.com>
 <20251117173530.43293-2-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117173530.43293-2-vishal.moola@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6399BC000C
X-Stat-Signature: 79gur4nc1849ytg9h4ffy6eskb4dkjh3
X-HE-Tag: 1763458481-149419
X-HE-Meta: U2FsdGVkX1+o14WY/xitYv7B3DwrZUmXqqPeEr3GyPJABXDncxpYhyUPuRwvvKMmYY/bS3g9BqQUguTyE3MkLUSdCGlinRKMP3jFm+hVyUIdvkRRVei9LfhWRg992cCKZSvs1HfNAV+bkZ9OiQJqttSv1iH8XDnaSssZze/8+vpSBBXgYRLqSQGDpvn1OQJ6Hfs0OQJraaangmihdRY69hqtLpY6IXIXuUC8yNIAEcAppNWvlnykiiqWYbPbustz7xp3Z1+4sID7YL8cWbdUpim2CueYkl6Qt1cW+8tNIgxtjXTm2wst5iNPIYKTHVs8zXgZ3u2ue8O3XcV2+8rX7+LGoG9XSae9TWPQUl+qPbUYkLxWcIO6EVd3PFMPzA3PlZ0xqwT3evKAvhB6QliBQthTcG4PS1pRcGNFPdXg5rivl934HZNXXUrMnms8fAtyFyeFzKE9GIpsMxZI5qjpV1nbCzdqedTBh7H94a/gVT0Jw9KO4X4QHuNVnBnR8jd8nziiBpXoeQNVDVZ1bxxv6d5ZMYevTIsOhfNXNOTr9QIcYe/peWkzTaVzrDJxT01r2byc/qlTGFVizZLlzdeyFKfCcjifwxKONUj1TooD7wjm3HLDgcZxhtm0NcM0Wqwecb4ngM7MbRsRPN354340mIb/SZSJUMS959bQEQo9y+c7dWaK08dOSM2b1ZwLxK3R8JX6cCBqBoZcRQOXtaSkf3fBDLk+0EQKsOmbHQDxbj6MI1bNdG9BtjyJam+PwRj9Br/zwnWEFi+Pe0qoTAQ0pvHkwO5/eeifvSKHt34XiTR2rcAHBMoKUrc4EW0zUuc9M4OTrwrowjMhxRpKzudNjCL0aYng0IM8+g13f7ebxavg5FSMQbIQo4qCoDebVXW45mjlTGivUigWvUR2ckZFFeS9yI3s55t4KNwv6JSXMv1M/eiGBy/cGtS6NApcRE8pDXgnUDYChKBzkN7JVE/
 20Tbob+E
 NQPNfg1c1lbE+/mNO1Z7BwaIXSfFif3XorcjFfUevwHoVbIW/VZm75Dv18ljRX4Iq+p2Rgn8diZFBrVHA1AD/B3Y7Klm6XUL/o9ESi4diOTkZ3YN5O5vp7OoEXf65bvUumWIDj+SVaoctMix9uriKzbK4cEkbYMIe+QYUsnLSK4QrXuDLE73E5vumBtUxof+YWJutI+LjcYGikyIHRJe49hD1Ey2jLMN0LJq1SfwzEFb+j7CfFSOLXboGIrKDIjcz70gLGahSEGl6kZAGrgAHKY16tc6Ix5eMk8hpfaZQsc6QZ9/dyy0dirU2AwbDM8WJcVTyr3XiBYV5YLV26cayrRO1hDNrWGNMiRmgpXxubTNx+eMeSv8hzu+CqkTHMTeBIIhM2/t1DidDK6kCO7IDUG4qocFbCW0wpNXBexYzVvd/G7yVdfiAGeVP/ydAmes+T0I/d70M8mREC4U0aq78ekfKxuS9C6o182twvmmB0fute/1hxKUQln8qic6x7zp3kBzahK3LVygjgMfxHx4CC1sfdTucbDYRXxTqsJ33AmVwPyI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 09:35:27AM -0800, Vishal Moola (Oracle) wrote:
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
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/vmalloc.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 0832f944544c..5dc467c6cab4 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3911,6 +3911,28 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	return NULL;
>  }
>  
> +/*
> + * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
> + * This gfp lists all flags currently passed through vmalloc. Currently,
> + * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Both drm
> + * and BPF also use GFP_USER. Additionally, various users pass
> + * GFP_KERNEL_ACCOUNT.
> + */
> +#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> +				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
> +				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
> +				GFP_USER)
> +
> +static gfp_t vmalloc_fix_flags(gfp_t flags)
> +{
> +	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
> +
> +	flags &= GFP_VMALLOC_SUPPORTED;
> +	WARN(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
> +			invalid_mask, &invalid_mask, flags, &flags);
> +	return flags;
> +}
> +
>  /**
>   * __vmalloc_node_range - allocate virtually contiguous memory
>   * @size:		  allocation size
> @@ -4092,6 +4114,8 @@ EXPORT_SYMBOL_GPL(__vmalloc_node_noprof);
>  
>  void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
>  {
> +	if (unlikely(gfp_mask & ~GFP_VMALLOC_SUPPORTED))
> +		gfp_mask = vmalloc_fix_flags(gfp_mask);
>  	return __vmalloc_node_noprof(size, 1, gfp_mask, NUMA_NO_NODE,
>  				__builtin_return_address(0));
>  }
> @@ -4131,6 +4155,8 @@ EXPORT_SYMBOL(vmalloc_noprof);
>   */
>  void *vmalloc_huge_node_noprof(unsigned long size, gfp_t gfp_mask, int node)
>  {
> +	if (unlikely(gfp_mask & ~GFP_VMALLOC_SUPPORTED))
> +		gfp_mask = vmalloc_fix_flags(gfp_mask);
>  	return __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
>  					   gfp_mask, PAGE_KERNEL, VM_ALLOW_HUGE_VMAP,
>  					   node, __builtin_return_address(0));
> -- 
> 2.51.1
> 
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>

--
Uladzislau Rezki

