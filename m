Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C92AECD37AC
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 23:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF076B02B8; Fri,  8 May 2026 19:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D64A6B02B9; Fri,  8 May 2026 19:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECB26B02BA; Fri,  8 May 2026 19:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 109B86B02B8
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:36:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8905340410
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:36:45 +0000 (UTC)
X-FDA: 84745864770.20.EE5E98A
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8AC35A0002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:36:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="AFqGTk/N";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778283403; a=rsa-sha256;
	cv=pass;
	b=OgUVzBfDHNdrvRcOdJZ31dT1AjNVPQhCw7oVcZA5HlTIL1D15xNZiiH4bjCxHBCUjEFER4
	keYJtBAcKd50yFRsEN6IX2PtSzEJwa5iMdYE6Nqz/FfT0kd+obZe0TUiKn4VCwv/ynOURr
	n7Io793Q3WuzWNDiw/FHksWtB1+B6vc=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="AFqGTk/N";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778283403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10imNO/dPWbMThTpLIZ3BPvS8U4RD3Gbc9CIOJSztJQ=;
	b=fZcA+U0RuXoPk4dYHowEhMO1dLQCQvzwQIftA9O4uoMB2frLVF8gxR88rgF3TIbyhzcpfw
	35+SxNF+mT5yGhNdH07me46OUxPdimEiqOLIk/HWjQbDOGLg0l/cnaaoDGRtxl0JQlbdds
	vK49n3rgEyhgWIY4FyAUO+YeHxKlX6I=
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-95cc3522c40so1651191241.2
        for <linux-mm@kvack.org>; Fri, 08 May 2026 16:36:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778283402; cv=none;
        d=google.com; s=arc-20240605;
        b=Oyqn/t35bOEibri4syb4dy9IMlUD7RD50i5tLiIA3XIqSHH4R+FvCHSLcA44oJk9vN
         uN9ajG1eTAaKoJ3OlFgrfyxR6ABNggy1hp86JUzc+Yo7k7phgWPT19Algcc/ALl/xcO1
         BkQuY7frM+z6gcNPP+YvotKzGrl2gqh59BDMVrOYJBSvzhDdrJmgoS9DTciHm/bADBEj
         TxkLVjNjnXh8SucnxqiEUShSBA9LZ7PL/4zvBVaC4UymAk5yR9qw3pEc8+BwlMDn/gRT
         B27h5PPOVXXK9gIEqtt0Fv8fPnS39DX98usEk13FpoUyFus+/mwoEKHF7dKAkkbmbaVr
         Xv/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=10imNO/dPWbMThTpLIZ3BPvS8U4RD3Gbc9CIOJSztJQ=;
        fh=SK4GdV6Dj5AMAoFS+dW+VLKjuk5kl52aHA5Fi9D1rE8=;
        b=eZ7NtE6mtUQp5ChQBmGbUeZTz02ylXSloKt8jhyQoSFighl8UvFSgMvFr9gk+qFx+K
         nOl6LvhV26kURhuQzSbLEu4OkJt+lBDDYtO6hpJZ2o1EN5oCwsYreZ8FR6hOw0XhK6Gd
         H1SVJ9j3hbChxSN0TYjbqTmU79TWZC2eYOOMhYPOiYDSn4H/np1aOjam2rzEWSyRU8Je
         NI2W92agmmUno5zqAU2rHRyUHPKuldzZvXos/xJ9wdnorOQLA4ssyN8OZEWpLTcPvp3h
         BAK9bXkkUco/sZcytHEbhzhcf3ey31n1dv4ohLuj4pxLUYgDQY8OGWxDiVuqbqOJW8ce
         vMXg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778283402; x=1778888202; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=10imNO/dPWbMThTpLIZ3BPvS8U4RD3Gbc9CIOJSztJQ=;
        b=AFqGTk/NZMK9VCV4BACAvNQvUY6h5fxw4V7mT2bMFdsmylTZb9HGzLxkNqWIzzTrIU
         mjjVhKysAk6/kpyejt82clRAz1ef/GJ5mNMHlZC4a/cJE43V2/ShsW3UpHgZL8zRrNEl
         KSMviqX4woaEsAM0mmpa/297FYBYJQa+ZGxSWGpdIsm3YZ7EBja6ZvcCxZAG4vuHEuJ4
         h1BhWWa+fEj3yx/bVj8nSr4MzeEa4IXYF15ZfuH1V94THA3yAfJbwBiBhe4aS/9/dcg9
         wnulup9F+SaYslM9wFn0lCjxc3u+wATulBKNDGozWcIv96yMFnf9c2cFOI2jdKDX3KUI
         vmUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778283402; x=1778888202;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=10imNO/dPWbMThTpLIZ3BPvS8U4RD3Gbc9CIOJSztJQ=;
        b=c2hc6uI8XeGpbT6br1dyoAAYjIya/MQhI3pVWTbM11mLrur9xFtTg2Flq3Y/toX2Te
         i4SQfW2rNXmrgkfl7ltg3d324iYSKd6uZ7OZYiAWM4SAPscoGRDy725UTABLLH3Zlups
         1PuhrlR0qeaV+YHd7fx3nKinhR6PYxtmURgG2gkkOpq14rAmCQK4DL83D0jZmQoWGjk6
         8407AhL23EgTC/uj0wchM6WTzn7bD2iZLT9Zirisvm86XRa7XARpSPfBZHod9OhjwqAP
         ccWf+QauEBQvS5w5Ct3BZkYV8/vo+Zelcw4sBMRzjoXU0xT2ST9ZDUB5VN7Hra/hPHa3
         tNjA==
X-Forwarded-Encrypted: i=1; AFNElJ8cIVp/v8ofRYz+/kXclYm3bx9xO+JW9dzD5xcyIUeouZl7Ol+YzYcsKilkrlQ1DxmethQ9k0cUjA==@kvack.org
X-Gm-Message-State: AOJu0YzquL7kbYhwPJskgtWEipomO1DhIxWVKHVr15TJZgDNJ3qE661v
	Q83FJ74pPQw2RI7T5YrP5uYYwLLYoLn1n200HRhtUAOjHKiOjw6T/a6MON1ywBXmH5JDK2HqdwJ
	C4Wku4JVWkaB3KU7EdCmA2UAxuT6pmzo4x7CS7ddf
X-Gm-Gg: Acq92OEBB+JBuKAFqZ37Bifbgvbp8BchLb5zkBUbCLBdwFJE6dv8ZlXeKQXn1KIAMZ0
	KfX2njoejgzTD/0di+cIwNy5+ttyDOn5d8OuApKnQ77FNzLrTbafIlIafS7zrm9mxbYR347eaeS
	cLFUUHnpTOgpJ/NLHw5OTU25xApC8dr4tZpu8cfvoNICycSKi0fhVUFF+QNEyGBcVvVbJ7icI1T
	mIQxK3SAcDOW/JIgzoysoZLM4sc7wM3PvuU1mGx28xNGIv6LxtTC9aT/iftzn9icyRB+VH7UWuF
	bMx5+s8hI0FxMgkNK3P4Pyd6anDa1f8Y9imL9OL5pz4fuP5Hr8vk61Wc0kkALf6ujZwZLJHl83r
	hw20yKpFCodjl134=
X-Received: by 2002:a05:6122:3208:b0:56e:e80c:bb25 with SMTP id
 71dfb90a1353d-5755963576bmr9165277e0c.13.1778283402011; Fri, 08 May 2026
 16:36:42 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 8 May 2026 16:36:41 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 8 May 2026 16:36:41 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-1-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-1-91ab5a8b19a4@google.com>
MIME-Version: 1.0
Date: Fri, 8 May 2026 16:36:41 -0700
X-Gm-Features: AVHnY4LvPjVICPzN5-_CJPHTIx7ocT885vUY-RO5A-DcMZDUx5r_5g4UegbM0fM
Message-ID: <CAEvNRgGF-n5gmTR5G7wZqH5gBZsOp6WMR-RSws+=g9tcCkfSiA@mail.gmail.com>
Subject: Re: [PATCH v6 01/43] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, ira.weiny@intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: iw3th4mcyqk6mx3afm4i8acfa7mbf1o8
X-Rspam-User: 
X-Rspamd-Queue-Id: 8AC35A0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778283403-409746
X-HE-Meta: U2FsdGVkX1/fCwJdMWO5nDf21NhRWR5A8UZKdo3V/Fm4pZzUnhDz6UP/Y3GTdEPVWio1I6jXewXOlaqvtSNtE6kGIi0Glgln0YMzfdSsSQS6PeN4oiw7+0YLGSAhayZU9I1d2htPwxKeG2KfADQGSWCOA4YNj6MgUNg8IRI6a2WqCq3IGdc/prZ7s/LU47bP/p5LSQSRZDPxXn+Mf6tLySjrx1HEnjwXXZNtX0MkOw/46qWBEUksq4sfVHQ/p2t+CAHPrHpaSu6+qqzR6JIX4e4TutsrX+Rr6SFSbzmd9ycRssmiTEFZTYob3DaQP4GO4jRvVZ+1McnM/Odx8mLOqFnoziZ9k/Ss666mknimxcCqY7k+0gYlmhTwBshoMIUzxLKMYp8QxbzFmXtruz4SE5aWYKaGPfLN7UsfzD88ZKkM0gsXqBQpYgY0Or9ZB+B146z4ZbZi/IIUMuiunApdiWv3huMcWhMGY/pbsdfRIzLR4fz6l+6dmke02ELeLonxPjja4Ka9KlW1gPxagQ4qUdCLtDfeR6Iz+nvL6fW75vPQZEnMsaFbPl5FW4figOS7Ta0Ool7gxg/fLQS8cWddc8h2ANezzW/ZumrVC/HC/JkeQdFXGpzxHaQgGKoFME50A98MHkyrVJCB++coi2jpQ9Q5/vDPwQ5jwLk5v1W0PaxVIo65YPDNSPqaeDmN4GUEf3fjBXpgDvLFRfdtw/yu/glUMODQ2NRbSJ5wyO4C+/vHPVawVd2B0Rww/ycyvhoGf9/0JJ2BlteFohGxOnQQDIm81pymzMFXK5BSVDBxkNrtvyNV33VoJCKbaDaT/nRDSpJNT8dkCbtRh9SbmzOfHyUtE/XmFVlTMFuDGAldvdGIxHuXR0Alj9IwahnKSutmoNzdutYyxtpTRwuJFI46WJQfAhmIFj4IH9ZQIDfWWILw7rc6tRull2ngeIaTKqk8KvLzHLLDSKMLNVvT41R
 8V6mQCvP
 uQG1vAoTY0HpimHerxtJ2IE1S6FDh/rXJ2QdTctOVPdzH9bPxmFvAGzG3kS7wMM2PnOM0qF31e1Q1yrgDlnGXQiiK0+kAn0KS2sbyiLEIoHoLZDelCIdfof0k+mqy+SaxOQyBjTYmAwAhXxVY365dR28CcuTh2es77dg8TW42JpQLhx2SzuNLjmpSazylDOnJTrbaWci1XyJM9/qvAq8z77dsdS/l7QaTzv00KZ/uWlwThE9QR9Ouow1WyG53uHgXFozh864SZEVZ0WTVJnkxSgIrzNvZncsxtmGOnEPBOkXKJfqDxGID18IdqRd2J/Ht5iIE9B7ndfIDLReLvtu0NJgz9+K2RAUMaZWBZaGsCEP3evA2LLaTZoqGhW6wNQ4LjsJhgTuC7PLbeys8t7O0Bkpg6eQTXHQdB5Ha5nTD3skG28qcrNBBfU6B+rctcV8rwDlMjKHPq6V7qE+pMABuBAaUu1nNribEHbiW0ehI5xCKb4/OGoAwK7ww4H7w1nTBmpjT3ajAhx/miB+Rqfv8RZfLfAEpZs+8XBOE+2g3w5LqPUgTNU4dIOCjeEG3Jxu0jgWR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

>
> [...snip...]
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 69c9d6d546b28..5011d38820d0d 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -4,6 +4,7 @@
>  #include <linux/falloc.h>
>  #include <linux/fs.h>
>  #include <linux/kvm_host.h>
> +#include <linux/maple_tree.h>
>  #include <linux/mempolicy.h>
>  #include <linux/pseudo_fs.h>
>  #include <linux/pagemap.h>
> @@ -33,6 +34,13 @@ struct gmem_inode {
>  	struct list_head gmem_file_list;
>
>  	u64 flags;
> +	/*
> +	 * Every index in this inode, whether memory is populated or
> +	 * not, is tracked in attributes. The entire range of indices,
> +	 * corresponding to the size of this inode, is represented in
> +	 * this maple tree.

Concretely, if the entire guest_memfd is 2M in size, indices [0, 511] is
represented with some value, either 0 (SHARED) or
KVM_MEMORY_ATTRIBUTE_PRIVATE. [512, ULONG_MAX] is also defined in the
tree, as NULL.

Since guest_memfd uses xa_mk_value(0) to store the value 0 ("SHARED"),
that makes 0 distinct from NULL, which works for guest_memfd.


(Liam and I discussed this off-list due to a email configuration issue)

> +	 */
> +	struct maple_tree attributes;
>  };
>
>
> [...snip...]
>

