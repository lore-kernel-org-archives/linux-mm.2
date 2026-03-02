Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0118EA4E07
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00F236B0005; Mon,  2 Mar 2026 09:25:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF4C6B0089; Mon,  2 Mar 2026 09:25:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3B16B008A; Mon,  2 Mar 2026 09:25:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0E376B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:25:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 92F0356376
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:25:25 +0000 (UTC)
X-FDA: 84501345810.21.6DF10E7
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 98DEC1C0017
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:25:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=O5KJ3nGQ;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.52 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772461523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJvv+dHmg1dMk+zrpZ7EFL5nzk7Z7j7/n7g2yIloLCk=;
	b=vp7Im+wuOPQMd+5zvHpUHa9OY8ORi04jjQT5+wr0diHkd2aPm4Ob2I5sec0rkgpltZ9+2+
	3+8T3rxdxhwcH0tAHqMjYKBShIR7aXX8NlMLfNzqJld0ABHC8/+4x7eXMHyTyBJa4c4PkJ
	uz4eyEZsUYC/MoS4EvCZv0DeNJTG8Do=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=O5KJ3nGQ;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.52 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772461523; a=rsa-sha256;
	cv=none;
	b=lDzwi4vmQIn817EeLVMUb4lOAZyJO73eeOyhW2S+fCFCEGpY17i4u8rLnpFPHWTy7QEBdH
	h4kDZrrqRwP8IMI+t4SMsHLKP6GJWRZep6eVU9ZbMt2wR9gL+KxQ6pX3HJoOJRSjIL1Xmx
	24iuasPoO+S0M0+/78B6FP5IHgaCwNs=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-899ed41208fso29947026d6.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 06:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1772461523; x=1773066323; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TJvv+dHmg1dMk+zrpZ7EFL5nzk7Z7j7/n7g2yIloLCk=;
        b=O5KJ3nGQkFQ8ZDtZVVvF/7HdsbwO4yaf21b/BAMpKbFxPcAAkjvuwn07WKpV0CCPWE
         tnt8f4vqLwH18xYv2hz0Yt057m+JMySnm+L8Y8Lwu5BG2eIsh1Ls4Y6+yYh0NNDeggls
         +sJ06MFsK/1dvYaFvKX3nLqPhpWH2Sn+ENUVeBlXesuHAxzRhE3Xic0GfziidNLDlZab
         4VGRZgUIooAC3dT8zCScf0Fc1uP18QrATjVfgWJwV0RjuDqCVeL6GjWQq/zVtyMb66Y7
         GFg3KrIXHgR6lFwx2lKDmrzodQmtLU8XZ4M6Q0HDA3F1Di1y91EV1NsLce2U5Jed0NR9
         XuHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772461523; x=1773066323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TJvv+dHmg1dMk+zrpZ7EFL5nzk7Z7j7/n7g2yIloLCk=;
        b=HqkZA0ehYjkm6Fl78JfOPudA4YLXRORBSZs7n6xvoiTs2qxd5oY7ITljtbqbliMtMv
         XiM80Z/IXhJuOhgbFFF/bKK5rwGycuUXbwdwRUYC+/3jX/1ixRUQDT0pkEUBmzp4tYo+
         Wz0WbnWkQ+mQtMXU/l2kjwQZZCGzBG/TUBJ05NroEe7yUK0ybMLmTpBpHctG/G6BK1qv
         Em+1rMeNIliES2NJHBQZzDc7U8l/ogPBa90lgFIpjHt/9fFJgkdZAwG1/H/JUy3eN/YC
         TkZNWYR5TLQutgM0vtNT+iLSKcjY8fseVwdO6VYKAwoZFvlM8ySryifFCi+VNya+tJVx
         2YWg==
X-Forwarded-Encrypted: i=1; AJvYcCUB07CJ6/fD6euTR/QzZz00HUzDgpiVrRbMfIuIe2fxIuKuuoas7whTQTp7KIzrKbuzRY6vPr0Nyw==@kvack.org
X-Gm-Message-State: AOJu0YxmhEpJ1ucz6j7DrF9+ZOW6oZbZ/QwAa7TXSNyDP2n2/wFnzSDe
	eQbJj6pxhoxii2for4GWh0bpL9AkRVDXm7GUtadkylTMhqR9ZXrrY5RQCmUWY2v2HVg=
X-Gm-Gg: ATEYQzwdPWTg7+9CBRB1eQnB+1J8Tz8vm2BjKw35vqckZEzIPD4M1bThV1WsIYgdr/h
	6SQoYce8m/G+1Vd0P3LdE235LLji00RKTaG+yEltiE9EfHQfyiOfCJh+6hUYmCRqsJlw+QRr6le
	zKdbUbSi3ki5xasK/7TyCSNMUSNqB1/858+e3Wqqq5VLU42WCz6YCxb8gGfXI5HTgES3RKSEct9
	fa0MDFKJBs+qlGOMHg3Sz9mCLDa62cRDb8voT8iyd25wIJiq54w5QvsvUhNWedwvez5SiVXesOw
	rg7dXVwD4HGd/E8AoTJvmf0d3fRMQPjZEUThDb8ZqLhN/iZBObTDauJDcs26V5Tj2WP3UFWDdqA
	79iuZcia7t9LRjA55DaNw8qTj4/WfldAmTjUPXZ86Em+8uwqoqrIoGsBBbuwKnBVaC5+Wdkli0Q
	gpO6GENKs6afyeybXsN8CiLBy2oFHMrOM+DqOyulSOo+3tYmovcz5Wf9L6C3VYosY9dWm3XKzYH
	OA2zAu8
X-Received: by 2002:ad4:5bc7:0:b0:899:f50a:6d15 with SMTP id 6a1803df08f44-899f50a7244mr66650266d6.6.1772461522653;
        Mon, 02 Mar 2026 06:25:22 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf6f9261sm1158810485a.26.2026.03.02.06.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 06:25:22 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vx4D3-00000003gVp-1im1;
	Mon, 02 Mar 2026 10:25:21 -0400
Date: Mon, 2 Mar 2026 10:25:21 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/mmu_notifier: clean up mmu_notifier.h kernel-doc
Message-ID: <20260302142521.GX44359@ziepe.ca>
References: <20260302005222.3470783-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302005222.3470783-1-rdunlap@infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98DEC1C0017
X-Stat-Signature: rpxnafqcgbap3i7sp17fpy4y6eqjc5am
X-Rspam-User: 
X-HE-Tag: 1772461523-266436
X-HE-Meta: U2FsdGVkX19QXM2RmBCbUkz5f3emSKdIC7LLa6EmpO9SwZjI1k/xwUaWvYVmBtWH2Y8A0rhhRyzKHfE6ZXy7A861UrfcOekGs7Ir4Hm4MEJnP66DnSjXJrd1NrL3sid9v6zRPCwvMcsEBcHvl5zBRXqJ52+tw3VM3/ulLWlmDmENG7vqnjqbD49emHilvoPL+iA0miRtGoND0w/prkeOmYlsUfeMNMF8TpSetHidxUpUihGrbyMruXdLf4D1TEWefOfU9QpHthH0vj5lDLsLYf8YAW7P1B1fdVXG24V1RhB6qa1NqJNlvJodUWIWH6SY6g40HGuWH7yVYnGCIGa8JOnB3lih6xgkB8FL76NV0kypJn7YM6s6iR82zfzfUpm92OJQAeIs67C1C2grR9i0ifDh++dfmBkMIwiGiwid6oBOYgMrLoaf5LhDFkZBJ65FBRbdJqaCKlJ0JhQpNPp81vW3/cQYprs0R4FJHYJd5rA4CL3Kobo2WDldRxqlNr/4ND/j1w1t8UZkk/GV2Q6kN3ibhebxIXwbtuX5kM5JM88VijU1urWi9dV1Q1RXX+Sqf1iywy1GxKJ0VjKfey7KRJ2Xj9ZpI+4SGgpgoe4GDM8AHDmDIC6dUfM+eSyOd29I0nUeFS+AydpAadwCtf5RJmBn8v8oIS/umVDj6DNgx/GZIRrYz9L+nFPoXkSbWquFdcHxPPh30l8SiCJXB2KSf8Fwrueqz/zINTy9GnyjxP6frwWF2Bg/dCBasF8dzEK3dqVxQkkNzuBxoZrLsr4T4WLa+OFrJ00bSXP0lTwFca/Oaz5FmGxutpSolpK9+ZJS2VyIJHZOkm4WctgY/rOCZpVaXqtSeIuXU5c/ZPOy7Dbaf08Cr6slBmKI+2iPz/k8je1iKmokK3igxhBPH/z+DGRwt/shq9tTtyTYveZ7tHGZfYWd4z0ykM1/ShwLTL+Kr7/j9mo31oQ/DpRqxiT
 tn1NIHtK
 N6BAawze/BvneNekV4xkBD0usMtbQfHeVl+SCSSgQtGKf5vm7+RbWAIj6WusJG6RrW5o9aTsojUimdhU3PBtXbVuDogXa+N22HfP4/1D52WKsEdQ07QOeD9YHho8N6C4Q5zfP63VL8vcqexpoCUaGGOrbA7g/3tRbD4zUDX/+6gPl9f9Uq2P16RfF0ohjSORPoFcyPbJJqCkGf5TfMIQAoGWRJCrR0HIFA+ZG3UNGqJ8yE12UB+QEurhhMV9JXA3SO3VKqHdqv9YsVdA7F3oK/ozCIzGDtm/9kmYAZYlSpUhiTDMMZr7CBzSBrzupfHUHIRcr/JXrSNyOG0aefDlBYuvHlId5eOjJHytHsWV7ZqE4g++5D3HyPW+6fQZPDidi5VMNgec+YVhVAE7wneAO8mtOTEoc6SxiiwFIAhqisYqahFsNeGi8+HDwYx0rlZwr/bwWSUOVFS+xamE4JmpftLwFOxk+2/FWrNTF3gsx8NEkNn8ecRYOSgIw7eHEcAxGH4/UAxGXm1AGMJ3nuwMwlOB5kLX6iJlj3MmystKVPa/HezmMTS91kwziiaxTr0gCuSPfTRHaIR74okFjHjUmiR7Ckg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 01, 2026 at 04:52:22PM -0800, Randy Dunlap wrote:
> Eliminate kernel-doc warnings in mmu_notifier.h:
> - add a missing struct short description
> - use the correct format for function parameters
> - add missing function return comment sections
> 
> Warning: include/linux/mmu_notifier.h:236 missing initial short
>  description on line: * struct mmu_interval_notifier_ops
> Warning: include/linux/mmu_notifier.h:325 function parameter 'interval_sub'
>  not described in 'mmu_interval_set_seq'
> Warning: include/linux/mmu_notifier.h:325 function parameter 'cur_seq'
>  not described in 'mmu_interval_set_seq'
> Warning: include/linux/mmu_notifier.h:346 function parameter 'interval_sub'
>  not described in 'mmu_interval_read_retry'
> Warning: include/linux/mmu_notifier.h:346 function parameter 'seq' not
>  described in 'mmu_interval_read_retry'
> Warning: include/linux/mmu_notifier.h:346 No description found for return
>  value of 'mmu_interval_read_retry'
> Warning: include/linux/mmu_notifier.h:370 function parameter 'interval_sub'
>  not described in 'mmu_interval_check_retry'
> Warning: include/linux/mmu_notifier.h:370 function parameter 'seq' not
>  described in 'mmu_interval_check_retry'
> Warning: include/linux/mmu_notifier.h:370 No description found for return
>  value of 'mmu_interval_check_retry'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> 
>  include/linux/mmu_notifier.h |   31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

