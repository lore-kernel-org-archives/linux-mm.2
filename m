Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 816BBC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DBE06B00D6; Fri, 17 Jul 2026 14:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D426B00DA; Fri, 17 Jul 2026 14:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CA156B00DC; Fri, 17 Jul 2026 14:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D07CC6B00D6
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:37:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D702140207
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:37:34 +0000 (UTC)
X-FDA: 84999126828.24.ED2C7EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 94BED1C0005
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:37:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hCfe3OjW;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784313452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=THypN7sBajrN11WinYD29s8FZFx1TY39ImlyNCXePlQ=;
	b=cpA6LvfCv6HpAafYgVfCG5JXfG5JqaN9Jc9sMVHAgLPqw/ofZa0BiYyul30W520NWAqE1T
	MHiCLZ/yerDqIytIiAD2mAkMQKEQwJ9oRRATCJlwlUPtVdcms331nZx9TQg6A6lmFFyOcU
	6+n8ol5RP0Lzr36X5N87f4QhLCYC15g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784313452;
	b=fHtZ0xO8Zw0aoWZs7cizojlU5Lc/S5bmUHQpcLcyrXdoDL/lmSzAJfk4vxBTXKI2CD9kY3
	8x54eRkEgkXWPkgdUtrKnipTQzMSywfOv/vrv0exb5A8x9D7Yk6w/4ef9D/40BNeBOSCtV
	K85ftbOD+mfnIa+VVsR28VgHo9ANI/I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hCfe3OjW;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8576401DC;
	Fri, 17 Jul 2026 18:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7CE1F000E9;
	Fri, 17 Jul 2026 18:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784313451;
	bh=THypN7sBajrN11WinYD29s8FZFx1TY39ImlyNCXePlQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hCfe3OjW/NqtOug/QPf3IPtV/80bZRqy4YqNjEOnU/z8XU+bMkM9hSHfNrI6ZWC69
	 NFiYnjY9AznpvT08PI8bHmdybdhBo/3003FW+2zMpi81TEeaguEIRJV68tUEcHzkla
	 cRVUCwAgMhH6c6QqwezewMdcEM4zX78mMS6D325w=
Date: Fri, 17 Jul 2026 11:37:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Mike Rapoport <rppt@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 linux-mm@kvack.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/execmem: Print size, align and caller on
 allocation failure
Message-Id: <20260717113730.787867964b1c3a7c645bb0e0@linux-foundation.org>
In-Reply-To: <20260717075715.25513-2-yangtiezhu@loongson.cn>
References: <20260717075715.25513-1-yangtiezhu@loongson.cn>
	<20260717075715.25513-2-yangtiezhu@loongson.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94BED1C0005
X-Stat-Signature: 6yyj16m1e6xykdodg96han3wqmx3jzqc
X-HE-Tag: 1784313452-222650
X-HE-Meta: U2FsdGVkX18Dejkmh5LlcIrsppme9UvMWOsu6PfZGDr0B4Wt2TrrKuEBgtdi9nxfaus+10oHJUUQGjKflFOSY9NhfqgmRKZFXi3VIbTV2IG4VAENjV3vvh2Zu689dsIX/m/pXCmGelK9hGAnKXbzMV63f0XA36YQqtEYK5T/wIWlsY4JV4zCnb3Tq/KbVC7RcCQMz1HI+uK4Pjhjxmb+gGuwYSQuWdhr1ZF+FZhuUiNCp8iLD7JO3Gs9HBB70oZZf9LX5AGhQ4oBlRchLRqYa2kGJU2aJ1WcSj3qpWycs2vozXj+KkvmoiZShFtuhGcMwI8yj8119MnDkOrDNCQhrhcEPwbltFA9UStcgjn5G3yiw4v7dIIJLksKDhAjXyoz2kqZ6x83na9pHsJDh60uMS2rmwPP2ewQulNepq7DHu+NF2PRYPDTCufGBGTFFOq6qj+q0cQucdwThy+tAJmfZ9Gzy4F1EJ7yXYdepFQ6h8dHe7aDzddGtkLBNRRuGY5vtYmKGxFLmqoy/sarHQ29iOR4HJotAJw8Ip2u2JrXdeZo4zeYz/PqXhNvjLGguSCA6ukef49CJMIjV0dexHU/OtDf0PbjF1bJu0JZNEugnH68hqxLfhtAvDEefSdxMPZXGcE30C331e972uQpjUp78waNX9ivACeDBEdSlvVE0IuAOTN0VEg1VdAHEJoFmet6H+H289IX6UjuNuN1qg3ZvLBsjwvm7op8c6cgNtwCTq/RIid7AVa+JeAS2wtE90twqwpWAK2/eGRZVjP8Xxmz4NOTTi0LhxH9nRiC3q+lO+mZWNqAOSzs7AtyaBWg5K9duzqfW4eooK/RATkScLR9F5NDoxLCsG/VA9vjKSn9WB5PBJjyEI2KMLwlZWCogDuTjNYReXAgI+hg54mVSi0rQQSI9m5kPdWM+fQOVOGWmTQFYLdIz+nZTSl27XpFXWRH5Kmj1dPA+Xxn1uREIRU
 mvZ7SjYb
 vfZCvnZ0YFxFMI9wQWSpAes3LML04uPfAiL+NhHDqJE4gla2pzXRZ8teMicVxg27fcmG23jSShNoPxmB2BSmlgk30FQCIqTYHCA7deeDkEjq8rZYPNKxBmRlZnWulzCQJl/9e1CPNqHH+8mUMLwwQC13vTwl9sG0Ga+syL2kJsOX2+QUekej1T8rkaAT03PphkKhcA+2fdpLNXIW8HyCW7wlDvWwK/IKqhtDPmdRjRNDuZY3WyWXPHJYXGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 15:57:14 +0800 Tiezhu Yang <yangtiezhu@loongson.cn> wrote:

> The current execmem_vmalloc() function reports an allocation failure
> with a simplistic "unable to allocate memory" message. This notifies
> the user that an error occurred, but it acts as a black box during
> debugging.
> 
> Enhance pr_warn_ratelimited() within execmem_vmalloc() to explicitly
> print the requested allocation size, alignment constraints, and the
> symbolic caller.
> 
> This diagnostic visibility is valuable for analyzing the root cause
> of allocation failures and tracking misbehaving subsystems without
> inducing log pollution.

Have you actually encountered this?  GFP_KERNEL allocation failures are
supposed to be very rare.

> ...
>
> --- a/mm/execmem.c
> +++ b/mm/execmem.c
> @@ -50,7 +50,9 @@ static void *execmem_vmalloc(struct execmem_range *range, size_t size,
>  	}
>  
>  	if (!p) {
> -		pr_warn_ratelimited("unable to allocate memory\n");
> +		pr_warn_ratelimited("unable to allocate memory, "
> +				    "size=%zu, align=%u, caller is %pS\n",
> +				     size, align, __builtin_return_address(0));
>  		return NULL;
>  	}

This seems to be duplicating the information which the page allocator
can emit.  Perhaps we should remove the __GFP_NOWARN in there?

