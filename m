Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CACAC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 17:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1E66B007B; Fri,  7 Aug 2026 13:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7837E6B0088; Fri,  7 Aug 2026 13:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671C56B008C; Fri,  7 Aug 2026 13:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4735E6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 13:21:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 393A912013A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:21:30 +0000 (UTC)
X-FDA: 85075139940.20.4A3ECCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 83B4740005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:21:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AIyozzzf;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786123288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Tr+OngTsfD5qeav2e6UkiPEYssc25+AtnzcNKlmI2I=;
	b=XVbjVgh9hfMGOGg3+9AyddocYwxDJCbe2XPBVD3vPXNYppALAFlmnGaSplPDPIslVHtlFG
	I0b0EnpYrWzfBKBA+H5rFGD1VK8wbCIpZGxj41MIGejSePk3dAMVwEHxie9nVTZMlKLm2f
	DwNXJ3A8kfq6ggHUwWHFMOWmqb+mrwQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786123288;
	b=sswBUUXdDDjLFyCJWEnkF7v5YN+BoGMJiBhuBO81V+7Rb7lLwuo6NQsJm2pz/HAqqFj174
	7YbWnhqr32alYYH7tZOhQdxOpjKxcMTaucdeORY/iO08X70XY9oymI7XaYeb0xDHY/vrHP
	eIZgMwAyQ23nmKKHvZRPD93VTZbb+vc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AIyozzzf;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FF0840050;
	Fri,  7 Aug 2026 17:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EEE1F000E9;
	Fri,  7 Aug 2026 17:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786123287;
	bh=8Tr+OngTsfD5qeav2e6UkiPEYssc25+AtnzcNKlmI2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AIyozzzfr+dQp2H8Mss1vFkruLckMYEvnGMbRVHglJzy5VD/RU9ZDhgtqIjlONLSR
	 UZpH3eqdl620lb0P0EquTotgm3yd+yvX7k4ublIX19kaPHwQgaC4t4yfKovRK+PNv3
	 8Nh6GKt9OxflFKRAyamwGHe0LPi1/nM19HjjwC8h1i4ZiqPcMV+alLurohiW70h7UE
	 DfyxjUbc4U+Cvf902vkF7SJEvAwIxpIeAnGIrwdwslKZmet8o+V9eT+vq40W2ncHln
	 ezysQ7WD0Dk2j/HDgFaqXfxxKfnWygMlNnk5+e7zvJHy23Av4gKrVIKaYHI2/wsycj
	 bMH9z0ZRBbL7w==
Date: Fri, 7 Aug 2026 18:21:10 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] mm: Make VM_FAULT_RESULT_TRACE compatible with sparse
Message-ID: <anYSxm7GHV-bymDQ@lucifer>
References: <e56c9e2aead04f79192c3110de80d846e41e3791.1786122711.git.bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e56c9e2aead04f79192c3110de80d846e41e3791.1786122711.git.bvanassche@acm.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: k71jqa3s8x411bbpwx76opohrxz56a3k
X-Rspamd-Queue-Id: 83B4740005
X-HE-Tag: 1786123288-252531
X-HE-Meta: U2FsdGVkX19Go6qIhtw1/Wm0ON/s9Kt5gx2qIV5DSqU378R1Y92Rc7hGyHqDhC8bzP0+aOGuVMHQMtq+f/TAGQ7A4QB55/M56mq1yHlvH20mL9P901WzKmh0E3dzQigkus6swBAZZY/lZOD0v9dSlfT+6fi6/QauQ14LBbLSiGNkho9j7nF3te4UZM+7YsQEO3VPZrk7OQfd6JNIr/3hSH2bliRBLenwljgS2g4DVfTw6w5m77RrvDWR0+M6tT9y8KAUO+RDR3kRVVUOdg3fFeqSP+5mQzvlQkIqFFQMIG8r15+f6jLXEczlC0R6smKxwS0kLWeb+WKy8hLp9v/BZHaRZkh0PMX/CgOe06rHKU0l7nIYReqtyyYwWmyVstl6cPmwStDTAZNQlxpDgl/6kfRGw/Z7kL+8VqyxDGk1ospAsvxdsFVSt10zkLOtI81VZ89A4V0Tu8tvIr2A0crEbfmiCD1u5U26ldbOZw71BbVhl8c7RsfCYgCcTcvqeFlcBUCO5P3EphTaSc1bFoGAMRRkz7MHLDrrXcusU7k/5AT2joogdp3Ts/z+qTArFsUDMTMYGlwmpfzDublwZrDyi/68CTBCCmf6wsjznf5CcPfczzZUe+G9Up798H/kRX+2+n3XWjirM8I+BPfH+dgkruYi8uKHsmnBCXgy+KVVMGxMvByoYykSfJsEQNipdaupkMHxTi9SfShLRwCcsahSuk7DHMwz76Vu/fmiNhSQCwlGrEQY9ca4roTe48dWd2VVppr48keHEv4ap5JNEcRmrRX0HScdbdb2PdEBPjyW3WvNbauUaigyA51Zslydea8Y13LuiVeVtuXb0OrfimuTvyvhSoB0lo6neqY86NVCAK4mr6wiuXEIZRlEUwys2TTZ9O7i8G/ClRgJa+rstGUq5eQygiDA/thxcyR506SGmJFkMwjDhDa4xbR8UcQmCksi5SiqWfLuhvux/PlKEuz
 kC/tnOt8
 TOiilhDuwo15LwcPx+Cq7nbiXoPL8GRdKTyf5fFqvoGzb/IwLwOAHSKom/5dei6Yfk0HjhMqyB6/F46Ma/raLF/Xcu27/zA71RXCY90t+O4zn4H9k3Lj9F2D4pfxgBcKKznD1fkjmM0EKzFy6L6mVk3jubkb/ERABYxtXSspiITbyZOYXskLRIcNjKIYA8Au1n8+ZCNsttCbsd0LJ9iMPQ7k3Q3Y78zpVkBHT+T8RsXRvsb7DcyL1AlXa2CyYrtuyFbiaAP8lIEUJ/C1rauQbOPWbsQMXRVi9A/soGZpKiyZ5hvwty3XjrgDuDSt6j8K/Kyhsm27XkGgrFuduHjFy5l4tIMet4DvuBvkIYR21g81TSvIrvYFSXj3qOKm21cBcS+yTXVNjw079LBf569UGclLUjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 10:13:10AM -0700, Bart Van Assche wrote:
> Fix the following sparse warnings that appear while building f2fs:
>
> ./include/trace/events/f2fs.h:1469:1: warning: incorrect type in initializer (different base types)
> ./include/trace/events/f2fs.h:1469:1:    expected unsigned long mask
> ./include/trace/events/f2fs.h:1469:1:    got restricted vm_fault_t
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

I no longer work at Oracle ;)

> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

This seems reasonable to me, AFAICT.

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/mm_types.h | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index b18c2b2e7d2c..fcd7d6cfce0f 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1703,20 +1703,20 @@ enum vm_fault_reason {
>  			VM_FAULT_SIGSEGV | VM_FAULT_HWPOISON |	\
>  			VM_FAULT_HWPOISON_LARGE | VM_FAULT_FALLBACK)
>
> -#define VM_FAULT_RESULT_TRACE \
> -	{ VM_FAULT_OOM,                 "OOM" },	\
> -	{ VM_FAULT_SIGBUS,              "SIGBUS" },	\
> -	{ VM_FAULT_MAJOR,               "MAJOR" },	\
> -	{ VM_FAULT_HWPOISON,            "HWPOISON" },	\
> -	{ VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" },	\
> -	{ VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
> -	{ VM_FAULT_NOPAGE,              "NOPAGE" },	\
> -	{ VM_FAULT_LOCKED,              "LOCKED" },	\
> -	{ VM_FAULT_RETRY,               "RETRY" },	\
> -	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
> -	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
> -	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
> -	{ VM_FAULT_COMPLETED,           "COMPLETED" }
> +#define VM_FAULT_RESULT_TRACE						\
> +	{ (__force u32)VM_FAULT_OOM,                 "OOM" },		\
> +	{ (__force u32)VM_FAULT_SIGBUS,              "SIGBUS" },	\
> +	{ (__force u32)VM_FAULT_MAJOR,               "MAJOR" },		\
> +	{ (__force u32)VM_FAULT_HWPOISON,            "HWPOISON" },	\
> +	{ (__force u32)VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" }, \
> +	{ (__force u32)VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
> +	{ (__force u32)VM_FAULT_NOPAGE,              "NOPAGE" },	\
> +	{ (__force u32)VM_FAULT_LOCKED,              "LOCKED" },	\
> +	{ (__force u32)VM_FAULT_RETRY,               "RETRY" },		\
> +	{ (__force u32)VM_FAULT_FALLBACK,            "FALLBACK" },	\
> +	{ (__force u32)VM_FAULT_DONE_COW,            "DONE_COW" },	\
> +	{ (__force u32)VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
> +	{ (__force u32)VM_FAULT_COMPLETED,           "COMPLETED" }
>
>  struct vm_special_mapping {
>  	const char *name;	/* The name, e.g. "[vdso]". */

--
Cheers, Lorenzo

