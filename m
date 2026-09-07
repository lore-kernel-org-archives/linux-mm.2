Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C659C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 07:27:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38BD06B009F; Mon,  7 Sep 2026 03:27:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363A86B00A1; Mon,  7 Sep 2026 03:27:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27AE56B00A2; Mon,  7 Sep 2026 03:27:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0969E6B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:27:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 948051A0646
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:27:23 +0000 (UTC)
X-FDA: 85186135566.28.9B76E15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0DAD9C000E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:27:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kaxCEAdx;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788766042;
	b=7j24Wasvm/TsT4A5SkNHq7TA1Tpg7ngTCsiXkPVFG08tFIAIb0vzzH7SdNrlvQYADmVJub
	H+gmZAQ9YC4Iga+AdbBBvPCESQ1PUSrKjfS1yJ1jMzDRInrfUPQQ0FMj1qwxyLXhMoyfIX
	3sO1BhJPLy3GwfFkv678tLF9Oa+o3XA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kaxCEAdx;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788766042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJZ2ds+Ren32Zxnv+Y2iOl0ccIRLQlyRg2ueg6Z/dX8=;
	b=AhcR2reHTpM/qgoMpMUnEZuWm4YdMpWu0ILa1LKgC+8irFbUr9VShPkTnr44+MITQ2aH1Z
	IyMIAVWrVUcPTiDlRmaL6jA8wi8dB31Xlbdz6UiutAtldkUdGisq/MA5ABgNg4+VKtAVxE
	yPLx7MEY55ovKYzut14FnviPSyca3qg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81458601F9;
	Mon,  7 Sep 2026 07:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61351F00A3A;
	Mon,  7 Sep 2026 07:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788766041;
	bh=DJZ2ds+Ren32Zxnv+Y2iOl0ccIRLQlyRg2ueg6Z/dX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kaxCEAdxYg9CRE8pfmp7dmb4yrOXZ0ZC0VXTl4O11IZ+vnzTAaLoQnEYBG8txsJd7
	 0egL71T1O2BcU6hLS/M/KYtDjOCrh0b87Q+9Kbj61wVyC2iOPMPCdzhaE0c0TAaWyY
	 u58yA8ZSSZz3aUxOesafDwytF8H5ivSl+ZGX/pcche0IbTsucjoNdxKsDBZGARFrdC
	 HQsMMdwfZnaubqShkZv3kCPIousAWG8qeWPtl3U/QHH/y8k+d22Onf6Bysru0Bx6t/
	 AirDXD9d0Q1nkCw+IoNjKrHpCRdC0RXTuKzCvB/9Z6l6vslhBzAXX6KLGxlHZZT4y3
	 q0Mva3MGcidjQ==
Date: Mon, 7 Sep 2026 08:27:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>, 
	Randy Dunlap <rdunlap@infradead.org>, SJ Park <sj@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] docs/core-api: memory-allocation: clarify when to use
 kzalloc_obj and kzalloc
Message-ID: <ap5nTcKoDyiybuxH@gremlin>
References: <20260907063654.2248617-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907063654.2248617-1-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0DAD9C000E
X-Stat-Signature: o7j145391mum19c9ckjq51xmetxau4wn
X-HE-Tag: 1788766041-547315
X-HE-Meta: U2FsdGVkX19PRuDhl9kF8T47hmRzcsBlJDvnVjnKq+gDtYWEx+rZBQw530Da6CnwKwd9h0lkfePhx1RmbsGSL32IiPn+uUYxzwabcV77tPeABavrFyKGHmedniF8JgQMqJd95Q7meQWlhzqPG0Ye9nmHfFgmRyOYdBuR1PPiIcAUMub92DUUfkHkRds17BWUFMr8lcSrBWXox1MobiCGDFsGdqSE/z9Pvdj8/zjBgyS/MQo2rQ0OFsqT18ksf0UqoLCXIUVbTLAJpT2AeCVVIyNl73UaEHXt8XJkffOtDNExNWAD1c+ZSmtmLeQLL0T6zUkvU1IOy6/jvqvHl9xiEwtF9NKOq/Hn4PXjNlxVjMjQIqMbEJ9MQWkFPrAFrUH9rrQ1qMztgQCL3psbwwyHggBnMK7kZ2LK8ELl2yDEpYfxp2JhNzGj6Yy+gfWb09hX5Un4Ap184245QC6VhQ9SrxT6r65F6/kGILavQ5en9GMNlkqy52PQWW6Qft0mrKQ/gInnCGTuNV2jsIEQeoP6aVhoR6FfswY/v/r5tUWshJlvcTNg35u+b3IrWvRrtWGqolw9bmhkj1MoI+2HuUso/F5H2JsKBkT7rv4ukpjXjaKZtZMOMyBRz0jIwD8BcrYNp/N1wQRhFTmYfzggJkoMYTYf4IcRT9NG6IaQDKj+8y18CKeXojAnRXGgDjgec9yTB7mlLNQF/EE2lkhVxZr2YwZbTOHkt/1d439RU7UvhUhKMamo6SRyghV3LJQQ0HVqWvxQpNmUrvYY5J8yWc5kG6hN12jxtpu4LGbkvLtmwDKSC+zB6NLChtwsT3bts/a5ZXwwwrXushxjTiJJPRRwa3hTf2gXBJrW2vWrC3Rx+EMkX15AirKyQQfoPri/T3zuVFy0i1bjC3yLy2iu8p6KZrpL4ZBXg4OpGpvfM1W5B3tdW+K57e4aR+nBQkWglpPGq5k2s6Lr3czmkCR/Nz5
 v5/yeHVp
 eb3mn1a3N4E9qWM6T0wVdp0BxPmYDOmSLQYaCv7/3SmJaWIR600efe4PPhL4auh8sGUrAxQ80vjRyGNt1vU5WnvUyZsSWoKyIRjTKAj1dhIX7yziMqkr7cTbSBo0bBOX2ZO5xnROcN9n/6Gv5nBuUx5Xbn4Df9ZeOZ4UqWPHhHq592W8wqtEpe1HSIThYDIlehNQc3UbGqn+Qll1dpooqhemVj0OYQ6GYbQbUZytkLCSwY5F+MvQY4YjdpJXlJVQoK5poK/HfwFwiITyVTyfc+fWwiZaANqeMWB0dpmwX4Fd87ygYq96Ri+jWZ1Pr1tgxspd9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 09:36:54AM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Make it abundantly clear that in the most cases objects should be
> allocated with kzalloc_obj() and buffers should be allocated with
> kzalloc().
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

LGTM so

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>
> This applies on top of "docs/core-api: memory-allocation: add
> k[mz]alloc_obj() and clarify kmalloc" series
>
> https://lore.kernel.org/all/20260902-docs-memalloc-guide-v2-0-218c1a4dcb80@kernel.org
>
>  Documentation/core-api/memory-allocation.rst | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
> index 823f7fa57429b..648222b6c8576 100644
> --- a/Documentation/core-api/memory-allocation.rst
> +++ b/Documentation/core-api/memory-allocation.rst
> @@ -23,12 +23,14 @@ answer, although very likely you should use
>
>    kzalloc_obj(<VAR_OR_TYPE>);
>
> -or
> +if you need memory for an object and
>
>  ::
>
>    kzalloc(<size>, GFP_KERNEL);
>
> +if you need memory for a buffer.
> +
>  Of course there are cases when other allocation APIs and different GFP
>  flags must be used.
>
>
> base-commit: d7dd88ed029164fe0a959e126d0ce18dd3719f89
> --
> 2.53.0
>

--
Cheers, Lorenzo

