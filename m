Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3C6EC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78156B007B; Wed,  5 Aug 2026 10:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28C96B0099; Wed,  5 Aug 2026 10:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17C96B009B; Wed,  5 Aug 2026 10:18:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA25C6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:18:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35B4412048D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:18:04 +0000 (UTC)
X-FDA: 85067420088.25.5729283
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0DF8320013
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:18:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lrMpnchs;
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785939482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s24Ux4wjwBAvtoHR2FA95iIi79nffodZBBurUTUJ1jE=;
	b=h35OtKXQhiddE30gKMx4hd3WmAL+98faDO+3NpI2I+xOK7015h979EluoHQlLMGGp9PKGg
	RUwRtG74fsfVyxonRcXXxKv9mVpBroSQINxKIG1CA6BU442q6dV1asBAzgGLkSkryfYni1
	S1PKqO2PGh8ChFzF34TzYSf+dp8EfVM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785939482;
	b=Tn8A+duqThGtpFJTDQ8X820guT6ZW7Hz1hH0hL27wEEKLqUNQhJiwEK7QZ7JsuFNDEK7qL
	US1dRHIVkA2HUFpyBz+25joIznfSde/xJRJQRa13VJDn/vAO/AhDPrw0eulFSpgtEu8fxD
	/BTmEndgVa5xrkzk0HFV5CgsTHLO5V8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lrMpnchs;
	spf=pass (imf31.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8ee43b3e5abso6903086d6.3
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 07:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785939481; x=1786544281; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s24Ux4wjwBAvtoHR2FA95iIi79nffodZBBurUTUJ1jE=;
        b=lrMpnchsZm11MYC6e2brsaghqZ7dHgaUnYFIJ7kqqEvdGf/6TSFUvvhXvHsBkuyyjq
         0VSaGPhbgGumoWiVMdGFxbHujhQI2Q8wCanvn0LpIK5Ga1WqJIQ16wf6cAvkVERLGCv2
         7fxD6RYf5Mm8Fs4FypDsjq3BNcmnKYNlE0wLo4nCLt/gX/1I28ayVtPJB7XBQ8b6/QtT
         5DN7CcFHrBpojx0UFpJXz4KUR2TomLTmow3VhLmvqWsDrZkqriiepnJg63QMwR1rulPY
         B6Hi/GX5bcNGVya46oWwprDgETN47P/0KAG9yVWHltETsITl4TELsqvYzf5g0kkIn1Rd
         MihA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785939481; x=1786544281;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s24Ux4wjwBAvtoHR2FA95iIi79nffodZBBurUTUJ1jE=;
        b=mvc7QD9jj/NsZl0uFlfttNcHlXdbJobuSIZvD5b9HxQ/YeOr824igCgieAu5N4oQTM
         qEGxlz1d6Zn4jt8qhQD0gvAGjnuQ3ey07AdGlEl/jjhXwS2lzSOJrtRpxBRzH8chaUm+
         ImU0HYWMo9/Ef3mGyi4mBBZ9JV7VUMbqNcSG6qX+PjWjQ3TWiPuKslLXXrjDbyCSzRp5
         svkkXPmtEJubENJPUO4DNXk9FuOvhUI5xzDi3ICu7cAkkMX0BVs1/OtQmE+sxe4unMi2
         7sOCVBJ7mNy1iLx1f4S29JtcE6l7R4/tr+Lwfkn8GQ2PuqeXRbqnFMgK8efFbTshaUdZ
         57+g==
X-Gm-Message-State: AOJu0YzmJ+4ykKVtUTNTxDEVwtkwNitU8dAx69L34xXcbaUQo30FrBGs
	56RgdE28ylMNY3ouHMp6zvO4nn6iXdLZifUcbNNn3SGugCXOCpJXc1d3ocBd/6KnAN4=
X-Gm-Gg: AR+sD11wPgekVVOZQUmWeI3GM09mNpO3HCShg4OxRvrWOk4DXQuMD67cO40sniZ7N5z
	uD5YW/5c8gm9YSwQV5nTMpVpyDgPxhOpLPgm0t87BP/EMavC77mG70jn0YdEZ2bSC9I/FjvaPpw
	loAC9wWHP8CWMgjb8AhwpdZUVFjigpkmOoNIuCBufRgdDxWyU2qajclG3o/Fgj/eZXC5SvAqtqo
	3oFKxYNuu469bYPLYrPDshZwJyZC4JWisvPpFCl8Dv1TyiYOtI1pYqrIxzsdV+2e2CeDsiqFmCH
	DGt1oH7ShBNmAmp6WnTnA5MZP79bBEcfZsKp+J75Jz+w+Nmar+4fMKDeq0ujP31HACmDaXJw5RI
	mL7G0qbiFoNCjtpIQwp/bPdktsA+9Lj+0FSot/xsQ35oUzLrROXvGRfFNG7K6pekaKKbHg9o5n9
	c3sg+c8kfURHkjUAkFYte2Kc2wJqrmCgz1F1v0iMQatlTNTFwZ9vm9kEf20pk=
X-Received: by 2002:ad4:4eeb:0:b0:908:7fce:f111 with SMTP id 6a1803df08f44-90881098aecmr79986046d6.6.1785939480863;
        Wed, 05 Aug 2026 07:18:00 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9087ff9d814sm26202096d6.10.2026.08.05.07.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 07:17:59 -0700 (PDT)
Date: Wed, 5 Aug 2026 10:17:55 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, chrisl@kernel.org, nphamcs@gmail.com,
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com,
	yosry@kernel.org, david@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] mm: xswap support for zswap
Message-ID: <anNGE_FOoupPtOhj@cmpxchg.org>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
 <20260805075336.3579395-2-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805075336.3579395-2-baoquan.he@linux.dev>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ne9egaiij8bep3x33fjxoaconpog1a9q
X-Rspamd-Queue-Id: 0DF8320013
X-HE-Tag: 1785939481-306170
X-HE-Meta: U2FsdGVkX1/uDHTsIg2wLOKFSfng3WV47McRQGoM2pRav3SibKwe0F9qFmQ1EY+Q+1BugN+MOXy6Yqroq7TkbRgSP5r5Jr72hvGARW8W8kzXQTrV84AHZwtlz0BzqtODnlDJ3defqExqZab9paj6PcbxO1bEuU8mdfCudwmTpxWE5F2EOYpBN8XlpE5KZP0Mn/61KhH1qz7oLF2ACmEwoBeS1YJzApO6OsWagjoSo/L3AZ1gG6bj3bu92oUW6IOYm7oyT/hpQt+S7C/MS21YcBc4Mj63UiYfhdq90rnlldDYeNjEIOx5dfxTUPqzYvFOb95xmcmvMc4EDijYiBcB6FnjfMOY1+QDxWcE5RrGB8sIlB69cE/RwDI0pZ+ByUOX0XbsQeVaKcGC3CI2NWYt4OGUQaVe20O7qIja/cD4WCUQTY4rmjbNEo24iIn6y1xFW8CnwiAYy3H3P2moELKffnyjIywFQuHh9f3qgNTX/avERywdbg2DX0jXriqmzus0owAlf0SbIueEZZFzm10qENdtDPRR/jR1MvXsg6q+gjwEdZiJTIH+CSZ0QPawzRyW/q9k4APZAFHEGzCh6anLLcAOy0xErQT4ZSzRisxMxIAGDKEN54x39aDlB7uCuunX43vhWqX+a9jzr6jfX5J8hO87YlbKREd7WG9CteSEAU9jPZANhg7grZsYmmB+e88disBzHOQAOWfwFgx45NPIq4TWGUdE+F3ee3E60bCp2QYH81ZMubovG5SqHVtSOgRchv993X6Nq4VZy1pi5NJCPpvz5wZtiKXlnVGyDQZgivcJSMH3BhvpL9N6PsrNMGfLHvKUqPiw4XwIUy8FtdnDNBG/uM418ld8gU1bONu0gq4AaPLo+r4de20Gj3vy4Pd2YMOupx17fgAyr5FleB+s913reHLiro8W8W0gGPcSvCkoiK15s5lzADVsEDIHwzesHEX/Oc4H61Oz4dG5CEW
 J2bcim3I
 2svg8pmLM9oXnbUdBRu1PhZMR673IQTIGeg3hTigxqUtlLVgSFlge1qttclJHayVcxPXw13AjVkUzREXSAm96YJwhSeZsGwcr9snClceNQJBrFR33vVYAO8i2ZOZHlG50cJBocm2m9+Vn5EBq5eTT9nmnmFbNE5vS27NKoRg/w0MRNALRdJpYkkdfbKBZUzwOc07Yc5x7Fc9RwC2Mk9napChtUhXVLz9zNSoDkis7h0fLMdlnzt4ZiDFtlNIKido+yJ51xS4+J9ubq6nQHMgz0Al3g51gIRnYlHH1aHz+GkiY4fqxEFQ9lKcyo0PEvnybl3ZWDOf3ANRndyZX4TUGqWCddTxSOMbln5Of+C+IUEjlB+13VQ5RlHBBvEIkIt/9fv3xkIpsmms4uByhT0pVxERZaYOOWF3JJ/m/28aivLc1maM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 03:53:24PM +0800, Baoquan He wrote:
> From: Chris Li <chrisl@kernel.org>
> 
> Introduce extendable (virtual) swap device support ??? xswap.
> 
> The current zswap requires a backing swapfile. The swap slot used
> by zswap is not able to be used by the swapfile, wasting swapfile
> space.
> 
> An xswap device is a swapfile that only contains the swap header,
> with the header indicating the size of the virtual swap space. There
> is no swap data section, therefore no waste of swapfile space. Any
> write to an xswap device will fail. To prevent accidental read or
> write, bdev of swap_info_struct is set to NULL. Xswap devices set
> the SSD flag because there is no rotational disk access when using
> zswap.
> 
> Zswap writeback is disabled if all swapfiles in the system are
> xswap devices (tracked via nr_real_swapfiles).
> 
> How to create an xswap device:
>   touch swap.1G
>   truncate -s 1G swap.1G
>   mkswap swap.1G
>   dd if=swap.1G of=xswap.1G bs=4096 count=1
>   # xswap.1G is 4K on disk but reports 1G capacity
>   swapon xswap.1G

Sigh.

Why does the user have to go through this dance?

Why does the user have to decide in advance what size the space needs
to be?

You point out no inherent limit to how much can be compressed, so
there is no reason to make userspace decide on an arbitrary one.

There is no reason to tie an address space that can be managed
transparently inside the kernel to TWO named files on disk.

There are plenty of past discussions on this very topic. I don't see
the point in resubmitting the same thing under different names,
without even a reference to previous discussions.

As a side note: if you have to add "(virtual)" after every instance of
"extendable", then maybe "extendable" is a terrible name and you
should just call it "virtual".

