Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 796B5CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 21:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F52B6B0294; Fri,  8 May 2026 17:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5EA6B0295; Fri,  8 May 2026 17:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBAC6B0296; Fri,  8 May 2026 17:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5ABBA6B0294
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:13:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F1C8E1C0D31
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:13:54 +0000 (UTC)
X-FDA: 84745504788.10.A44D0E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 318C21A0014
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:13:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1ycYUPCU;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778274833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Dq4GUo3IlOX/4nGSCf8IYNc0apMU22MVqZGXpSXNkM=;
	b=1DmcEGNeFL/qrTN+SwewrU0psfmWxBARgKxNoyXKusbPcqyzfdZy/1P15zluBwo6gR1mfg
	RVSfXS89pIQ+yxTufHvZFTXvfSEMuiL/HrvWzNt7f1b4g2g7ZpsDHMXOiVjil1Un9qGo/I
	Tfr5ClLqeOPGDcacNK6fj7ciG24uZO8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1ycYUPCU;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778274833; a=rsa-sha256;
	cv=none;
	b=ssDSq/O+p54QbdnVx7DZNeh1cntFyXsbvmeNu+aST3GUHf7DgxRff35J7emUQYNHMs+UeK
	aqcMJA82Yt++5RYeQ7VO/PR2355e72TlbrEK5Y9eD3c5B3ousf8HI16druO2SelIYMXdJR
	5JLjLrGFYx7zTnkXDbljKA13wboi7Hk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6204460181;
	Fri,  8 May 2026 21:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9DBC2BCB0;
	Fri,  8 May 2026 21:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778274832;
	bh=k+LoqhXRgaCkxxZ37Q+HKM6NnjKl7YimWBWMstuJfkE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1ycYUPCUHF7AXdO+gyTeYy+0qnC9Bi84CPCc4m49leg7TM8fvXEPJ7/2LGZJGEFLm
	 URgygYZAuF8LXlC4rlFQDauCSyPc/T5qXxM3zXBdcu96nFrLDZwImErvp8fVDY1tha
	 K1HCAEvJkWWlBu1y0cpMSpXeI/Z0rTdLLwARASFY=
Date: Fri, 8 May 2026 14:13:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] mm/page_owner: add print_mode filter
Message-Id: <20260508141351.00cb6e81cf547ab2cff655c7@linux-foundation.org>
In-Reply-To: <20260507064643.179187-2-zhen.ni@easystack.cn>
References: <20260507064643.179187-1-zhen.ni@easystack.cn>
	<20260507064643.179187-2-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 318C21A0014
X-Rspamd-Server: rspam06
X-Stat-Signature: akueh8bhm4qsuamac5ejcfmdyfp1hh5h
X-HE-Tag: 1778274833-542995
X-HE-Meta: U2FsdGVkX19tlTymJxoVo1IIG+R7KTF6CIgLwAIFeDZwvleQMSHsSla8MIrMTEhWUzhBzBipS7w7ZOB/kk6zvvsiYIpCbBfXD4dIb9t52mrERfyKm6dI0iTpHb0BEMxiXmlkEdlhlayqYyTjEd/01jhpj7IeeEZZ62IVKdXytmpdd1yHdm8QBhNH6VjgiY2xjBkMhTKAdKcosoFCloDP4vUyx1fvihspvTMOX941uCGCWKac06IXLqLZ7KvGc6quiA4xw7+rk1eP/jlVaBavGYyq/P08lD9NQS73qWnj2MNJHqSaAO8aNXQ+MP9oekkmLar8+g7KvMfzlsvnFLgmA/oiNKLJYzaw562kv9ZezylMr8HwCWsh/53UnoP44P6yc866qb3y086ZMIhS3N6ZIcZvDfqSorys/dYiGcWCkXwnWwkLhBcS7kC0+5ffgVPF6wcu4qlMNIPMwOv6Kw4iWROnjmKQqA87YCmFbYsEmpik1jopCS3b7kB0UVqihAgIRJcvOUQf4V7y6S24xktkHJTqrN28U+WG/ep+O9yekkOex0lCnKGx1nhHD4dgEG6brHNjVhF0919gb7H972+SNCnO0mN1r7tOjY2AlHGXmdx/ilNruy7Xp/BmL6FWFd1uXTD53PMIiXNtkp9bdCdZluAW4IxvnfBfyczNqNRynu3iRuzOXQ8PY90CHGUKR4BxzPD4LTIyiSKw+v0FJKJ8xbkId4qRKpl0GkliOZ9+Os7LZvwZn6Bz4eYZ/LrN6KdaF2z6YrtWXEW/sIACnXDzGV2VvCWVsINO0QUO/5L3Z9K9jfLIvwfJx6X4m2Kr6E+n5F7e8GsX+fycEL++bHXirPOghuGz3hLhlMTapDqhfisRe71//OBCOGIOu5/BOg8eAHj0ZCL7K2FQfAMvddQqN8ZhMW6Ru0bhk8pPqf+i3BZ9LSD1E3rDF9L9to5UYmyMQNdMrjHcXl25I2kmX6a
 b9Lwl+G1
 ZGqwTDsPYfpJBFJC0IPWs8DH+T8yJA7VBYpZFd7Iu8ICPpK27POeW5a7nHrfSaS0AedGUossHj48BRZ9hDBYLSDxG3I2kXZwt7FLIcjpjR+jl7DHlm3kMjLwvpv8jp9IfMTGrS8mHrB8hFB+j4xjWEJwBJ6dp05aLiFAyai6tmJJITxq5pvnlhovzgeLsmL64QTbSvbAfnX1jDIR3Xx9uLbHr4z4cwFaiBw+FPXYkia60RltWWqQIyMviynXfhA6CRirkVWIxxCHkBrWW452KFn/S/8Ekic8XQEeAV7dcd/w0Ejw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  7 May 2026 14:46:41 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> Add a print_mode filter to page_owner that allows users to choose between
> printing full stack traces or only stack handles, significantly reducing
> output size for debugging and analysis.
> 
> The filter provides a string-based interface under
> /sys/kernel/debug/page_owner_filter/:
> - Reading shows the current mode with [] brackets around active option
> - Writing accepts "full_stack" or "stack_handle" strings
> 
> The default full_stack mode maintains backward compatibility with existing
> usage, displaying complete stack traces for each page allocation.
> 
> The stack_handle mode dramatically reduces log size by showing only
> the handle number instead of the full stack trace. The mapping from
> handles to actual stack traces can be obtained via the
> show_stacks_handles interface.
> 
> Example usage:
>   # echo stack_handle > /sys/kernel/debug/page_owner_filter/print_mode
>   # cat /sys/kernel/debug/page_owner_filter/print_mode
>   full_stack [stack_handle]
>   # cat /sys/kernel/debug/page_owner
>   Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
>   pid 1, tgid 1 (systemd), ts 123456789 ns
>   PFN 0x1000 type Unmovable Block 1 type Unmovable
>   Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
>   handle: 17432583
>   ...

I like the example.  But what is the user to do with `handle'?  Perhaps
expand this example to cover looking up that stack in
/sys/kernel/debug/page_owner_stacks/show_stacks_handles?

> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
>
> ...
>
> +static ssize_t print_mode_write(struct file *file,
> +				 const char __user *buf,
> +				 size_t count, loff_t *ppos)
> +{
> +	char *kbuf;
> +	int mode;
> +	int ret = count;
> +
> +	/*
> +	 * Limit input size. Maximum valid input is "stack_handle" (12 chars)
> +	 * plus newline and null terminator. Use 32 bytes as a reasonable limit.
> +	 */
> +	if (count > 32)
> +		return -EINVAL;
> +
> +	kbuf = kmalloc(count + 1, GFP_KERNEL);

This is bikeshedding, but...

Why kmalloc this when we know it's <= 32 bytes?  A local array...

> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	if (strncpy_from_user(kbuf, buf, count) < 0) {
> +		ret = -EFAULT;
> +		goto out_free;
> +	}
> +	kbuf[count] = '\0';
> +
> +	mode = sysfs_match_string(page_owner_print_mode_strings, kbuf);
> +	if (mode < 0) {
> +		ret = -EINVAL;
> +		goto out_free;
> +	}
> +
> +	WRITE_ONCE(owner_filter.print_mode, mode);
> +
> +out_free:
> +	kfree(kbuf);
> +	return ret;
> +}

print_mode_write() seems a lot of work to get a simple string from
userspace!

> 
> ...
>

