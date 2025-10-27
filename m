Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64605CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 18:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B121280084; Mon, 27 Oct 2025 14:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9DE8000A; Mon, 27 Oct 2025 14:18:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A003A80084; Mon, 27 Oct 2025 14:18:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8AA718000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:18:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32805139FAC
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:18:34 +0000 (UTC)
X-FDA: 84044704548.04.01C14DD
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 46BFF8000F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:18:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=osandov-com.20230601.gappssmtp.com header.s=20230601 header.b=MmBQCWuq
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761589112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hHHPAlRJEB1JX0GbzKMa+2xxx7G+tpWaRTFldiRkSo=;
	b=pdCPoWV6m3IVITcvDEQ0yxzRq7Z3r6cbVTmMi+rZs8Ifzdv1/CU6GWuI3jvc7DjPvyaAlc
	FDqwdcQdueNUqLLEK/dmoHDDLT3ybI67B/NX122mMubL9PzK77H2RSIEbWc/640MmXNmP2
	TSq88zpaOGIvGXnCunYiMTjh9s5Sk0A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=osandov-com.20230601.gappssmtp.com header.s=20230601 header.b=MmBQCWuq;
	spf=none (imf02.hostedemail.com: domain of osandov@osandov.com has no SPF policy when checking 209.85.210.170) smtp.mailfrom=osandov@osandov.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761589112; a=rsa-sha256;
	cv=none;
	b=ELvAMLLn79uHI+2BhTHZKSyQnWAAyaF2Qe0bdga98bcNzRM5hdrUg6VG0CmlO3WI2pyIY2
	jbV4srXmd9/oUkogFagg94t1rEEvvuWpIdO66dD6X/yWFoXEUoBxTH9hkVfaEk7XN2LuYN
	WJol9XitHHm3GcSFSWh3Mx6P+0YEJMk=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7a2687cb882so648316b3a.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1761589111; x=1762193911; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8hHHPAlRJEB1JX0GbzKMa+2xxx7G+tpWaRTFldiRkSo=;
        b=MmBQCWuqri+u3yOW8Ti0Cvp2TBGOt8Sozb3Zu1qw9De6vwanHe/Hrg6rNJkHGZD3q4
         g7Bf2afQP/Gic+qFzHRz/L29ryoFsZIZ7e0/2pqQ8N1SCXLx8Ue9B68ys34OgFqbeqvk
         lazwFVWcAGwQsAlBYXJStMFzPSCKikESvhfaZMHYDFIlb5wrzMdEiSdwCH5Pw/yuebaz
         r4xBa+YNBy987Fq579+UB+CJg0qgzQFgj6TwZpt18AGY1aBwkutEGPkFNpvL/PvCJSnz
         /mz7jJKcmK+i3b4CrHrA8TKcHeeFyZLEsoYc3r98+rwZ6XhkzW0zRi8/5XYhxM/YvnEd
         I1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761589111; x=1762193911;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8hHHPAlRJEB1JX0GbzKMa+2xxx7G+tpWaRTFldiRkSo=;
        b=nsZc6yqFAGK7VSuewWNt7RVnUr77uroluy8sHRuh0Js9xzqJABaEQShfA1LwYNwDut
         c5sIePplPMi2WO4/HVYtA14C5MvcODRvfTU0Eb/B1gKTuUKX6p7GOZ7REjsFd2cVCRkO
         rc/xDZdp1EiuLAcI5lVQcS3VZrcKaeXhA40WLl6++RP6FRrjTqAq9aw0rJCuwpD3FyjZ
         IPPZx2UiCBtoSGNroOAZs+VBN98YI3mz8iHA/XV8aL1E21PoyTtvGjqY6kft8YFhUb/j
         0o/RMZcRf+qDVgwg3yrDBXZ48nfuXKTLOTEpaNirz6QRXpGy9c4QiDcQhNtwuDV1xfhB
         kYXQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3P8D37XuGcZ27NotLLYNi4HUfYMZgqG6MDN7VHLswJzhjlmGgF151XHxrPi5Au0HJGLvPcCsFFw==@kvack.org
X-Gm-Message-State: AOJu0Yzar242uiR4f41SqXEOZ/87POK5hZoUrUgb9HcIICjGProSBSHv
	EUeZvrS6ed/1dO9OaNZPrIuS/HS7aHez2fvMNcI0FHzfXzk/p1V8IV0KWZUx8GeHhOM=
X-Gm-Gg: ASbGncueaOlkztq+fUZU7rXTF25kZ9ek/DYtV5bLy/ri/Q668+yAZ1/1RBJDcBnE22v
	cv6+ceZ6lvfJ+wP8NH59Obbln6HbJnhZE4c97ysM50UaQxqSq76VHsUyetxz4XDxr3yKFZfWI3W
	kQ3aJaZJUoRND/n/UGpDcqWkY7Rz06qkFxxlWbUyrOn5HwcJna1bBjWLhOFIDEG+NYndYNAlArx
	3D7K4lW7+aFM1cBWd2gnuslmyc0PMFFnonkR3S94pl63qpTj0lHKCXCiXBTbNi6VOhyDsEKvOHX
	J9JAGEo/4wwuNvCyYt3Ru6h0459hs7jHZvhxtuDbNS+LJW6qVGEJYI00jv2DWdu5Nlz38VYMor5
	FLk4t5YdtMOdEZqJW6PNpJTtYcMHsITQa5ke4czrZKSIgETemCvogvhi9RBh4T90PB4k=
X-Google-Smtp-Source: AGHT+IH+WOVT11S4sntBjYZgzee8qptVn9rhiLytdeFJhaeg0WjK0KUKG+IPmyVHCRZ/+efgBvP/aQ==
X-Received: by 2002:a05:6a00:4b01:b0:742:94fe:c844 with SMTP id d2e1a72fcca58-7a441c09940mr515843b3a.4.1761589111082;
        Mon, 27 Oct 2025 11:18:31 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:500::4:c4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414068f0fsm9053188b3a.46.2025.10.27.11.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 11:18:30 -0700 (PDT)
Date: Mon, 27 Oct 2025 11:18:29 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Israel Batista <linux@israelbatista.dev.br>
Cc: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
	linux-debuggers@vger.kernel.org
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
Message-ID: <aP-3dauwpc-Kq5Kh@telecaster>
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251026162156.12141-1-linux@israelbatista.dev.br>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 46BFF8000F
X-Stat-Signature: trhsxgc3whjqdr1z79znaa4nh7niswmi
X-Rspam-User: 
X-HE-Tag: 1761589112-893678
X-HE-Meta: U2FsdGVkX1/g8b+DA6TZXev7Yhou3VRQH/OceQQwMQp2jewc6VDmWtNiZ0yr8qltI1Vb3XPdY5z159lUEX4drhg3bXi4YUVCCnyjccR6hlO041RekbuKWwy4xJHi54Q6wHswG/43ftv5qKN+MPYA9Do+bH659YQbXWDtHzKwtmlHXx7+NXUxrAmf7FGFIWO9VeI+Vral4DF8R9GVAKhMFqHNdgNfB5Q6CR0QQWdUMnurQze0qZF2gdNfyW+xkksUkBBjegolaXGG5SyA7MGnsPkPB20AdvoiqzD+RjjaklaXPcAvmlAfO0+Pqyg3T7kn/xVBOYgz9c8CmeZRdWfePtvkua+0bh7RGQDrPme0jyenU7keRxX/7eCrOkg123VbMFHdQCFFhO2zEUqdobqSjPVSywGraMDZDAtZ7EB+09MTc1e9ameIJc4AYWuxOKNXvu8WaW6Cp3+LvTkpazMm/6pRx0zhyfzWLFutupW5W+aLdWW6Sr2CSMB8bvXiDM8NA6FGXup314/d+d0HqCYIOfOJEGi0NZ8CFmb0xZo93xwRGKxFPiiC3E6hpCI9b7SxVDD1sHNRUffIISwl7cFjqkbzITtuf3hSmN6T3hQOesYklVWCSQ9QR8dGN45qRIdEolDMq02JZVBnK/Z6oNgmz/svKE4Gc7GrMpbNVepJIPHwKjOkZ95JrGQ+nO17QlPA3P/XEtsAl+YItZvvmsM3OjRl0RUN1R6Go42nk5cycYjjSeK8QyEaJILX3Xg0n80uq18g5h1aACy09+7fr7nOcXcHInPpOhIcJDsLnrtOnIa8Wbkukz4ejDPymc8uOEHqE2I86rCSjLtGXqu5a1+ND2lLeFigR0THXwkdryHQkAWeRS9gzYwj50ETCZrq45Fb+60jhZI/oO6qu2Z+dJxX0aF4b5qbIfScRqJFNf8faBR18KU2K9SyDJD02w7BPIOJ8NNofdjGo2t+edUxIby
 KcwWUGx+
 SVRfcQKe2WZyHjPGvbZlE13Y+Op6GvY26u+f5Ix3+2j7RsuYsSRTCevVvLGx7DQa7v4T25CRGPkX3Lrj+AarLjNclcmouzFcu2CZgZoQcygOUEKUrqgtBlMhZVqr+/wPIB9mkpeQE0EBC1Yx9OvvLZ/GerQuUauwnEtYTK86PtQWlqoHtdacPuz+3bzKDWayksxqDGF1Jx3Rt/TcbZ6axP1hOG/FNlZkxZ9kbIbTYQLoJs6Em1H2OLpsBuq6NodY7gRFrtKaoCs3RdzzXqf45wT7zE8l0XAfT/W+AcuvggOUZL6l2HLGbRNrLg9RGfkMrjd5PFmEsLwPFwZ+g8q/KndWLZTHzi9gXaWpDBS6PVIMVBiE9B5UMxfqDdaKFWRObqXaYIDUaGKo7+Ab/peK2jNzf0WUWBb/BiAPS3KvYPz5PGPIkNIUp9opcU80eDqKBfaU1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 26, 2025 at 04:22:05PM +0000, Israel Batista wrote:
> The MEM_* constants indicating the state of the memory block are
> currently defined as macros, meaning their definitions will be omitted
> from the debuginfo on most kernel builds. This makes it harder for
> debuggers to correctly map the block state at runtime, which can be
> quite useful when analysing errors related to memory hot plugging and
> unplugging with tools such as drgn and eBPF.
> 
> Converting the constants to an enum will ensure the correct information
> is emitted by the compiler and available for the debugger, without needing
> to hard-code them into the debugger and track their changes.
> 
> Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
> ---
>  include/linux/memory.h | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index ba1515160894..8feba3bfcd18 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -89,13 +89,15 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
>  unsigned long memory_block_size_bytes(void);
>  int set_memory_block_size_order(unsigned int order);
>  
> -/* These states are exposed to userspace as text strings in sysfs */
> -#define	MEM_ONLINE		(1<<0) /* exposed to userspace */
> -#define	MEM_GOING_OFFLINE	(1<<1) /* exposed to userspace */
> -#define	MEM_OFFLINE		(1<<2) /* exposed to userspace */
> -#define	MEM_GOING_ONLINE	(1<<3)
> -#define	MEM_CANCEL_ONLINE	(1<<4)
> -#define	MEM_CANCEL_OFFLINE	(1<<5)

What kernel version is this patch based on? It doesn't apply on mainline
because it is missing a couple of definitions added in 6.9 by commit
c5f1e2d18909 ("mm/memory_hotplug: introduce
MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers").

> +enum mem_states {

mem_state is very vague. enum memory_block_state might be a more
appropriate name.

Thanks for sending this!

Omar

> +	/* These states are exposed to userspace as text strings in sysfs */
> +	MEM_ONLINE		 = (1<<0), /* exposed to userspace */
> +	MEM_GOING_OFFLINE	 = (1<<1), /* exposed to userspace */
> +	MEM_OFFLINE		 = (1<<2), /* exposed to userspace */
> +	MEM_GOING_ONLINE	 = (1<<3),
> +	MEM_CANCEL_ONLINE	 = (1<<4),
> +	MEM_CANCEL_OFFLINE	 = (1<<5),
> +};
>  
>  struct memory_notify {
>  	unsigned long start_pfn;
> -- 
> 2.51.0
> 
> 

