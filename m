Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1258ECAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 20:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563DF8E0006; Tue, 16 Sep 2025 16:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53B808E0001; Tue, 16 Sep 2025 16:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 450C58E0006; Tue, 16 Sep 2025 16:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 344AF8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:50:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C910119899
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:50:56 +0000 (UTC)
X-FDA: 83896307712.23.8E3DB49
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9085E4000F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:50:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nsbURf3C;
	spf=pass (imf17.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758055854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UvbfcOQ83kSu2crutVh7QYmuTH9yOcGKqLy75e7Rd7s=;
	b=0gWgLCLeLMC67jXyviuc6dgJMu4RzdEbZ0Gd4FjbR1lrjZQ/KtDCXokINCdARyoSVSlO9h
	jTN1WC1mWMVsNF82A3OW2i/gbvbj8FvW2hXJFMGT4u1gfd12/NDP7wxDyQtXRIYZW58Qrp
	G+i9XNLa7ZYQ9dy7Z9emKsgkZ0LOUXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758055854; a=rsa-sha256;
	cv=none;
	b=F6y9cfTkLeOzt77Cq81hxpQc52dwZ6uiTeFywZ5WuPrJRoc4GRiYTi9+mhEVKUKjdiXkT9
	efdzMQ0sltb7PZF/2hwowjOgO+s5/kzzIwVHOv4r3VZCgJ/xq60DKib3F4s7XlHUO4qX4J
	/x30pgvtUC9v00sqOBhas3GFKCQTezw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nsbURf3C;
	spf=pass (imf17.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45f2f7ae386so19886855e9.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758055853; x=1758660653; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UvbfcOQ83kSu2crutVh7QYmuTH9yOcGKqLy75e7Rd7s=;
        b=nsbURf3Cqfm1B/bGPusx31Vchn46wAib1vlx78r9qKT2GpvkSbLLLFXxFMpSAFxRuo
         VWDbrqdz+rMP/wXC5xtsL380U8xeRu27c+i+3r9iHEAJ6sCi3j0STOwvjFBFuFYe635d
         PAWoPC5dnuC5zQqiHCgzI3QI182N9XOMiWS7njTg/qg5a5LFcmkC/83AqP3DM4i1AV5O
         4hfaPwS0LqQHe9Z2EZiwsSkGYWqHKKxYf6SrUtnAhrl1vxc4OmkQYiLws69TRvLRvm8u
         9Ra1++YScNEC4iMp0lywIDfdiyjzox3wiaPYLgai51MUDpJclh9kLC+wFdVMBeQ13rzh
         in3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758055853; x=1758660653;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UvbfcOQ83kSu2crutVh7QYmuTH9yOcGKqLy75e7Rd7s=;
        b=J8YmMJWQmFO1zAMzNRevwQlgNZ6q7kzc2SII/WZCbaou5w2S+mhiLyjd756hym5lpT
         XQ+JAxo7H3qQWn1QdpZ9Y/olAMGucO4bJ+6xsr9XoekQGMJCuyHVVOChA4+lMkIor9WD
         SFb91MnBiKZtpfrLAsILudw3LBD9JQ1DMNMKn/BJM3niFUPf4SoxBISjKq7VVdLkKTZK
         g3wNrl2gdnPlWv0cDsJCiZ7yoPwO1w0J0lasLu8BV3Rb/nwTEEAH8eoaAgCIX+4rqRZq
         njWLOZzOTU/WMlGnhSEFL12RpFH9wOJdSSDDFvvivRMb7pFSOPeAVlAxa9V1DC8CvPVx
         PUcg==
X-Forwarded-Encrypted: i=1; AJvYcCU6Hqw9EGch0Izl9JJiJ0L5nBa332t5qHFl4IkV+RFU0cymjn2L1Tk11UJv8bZXyb5VYl/hPO+Nng==@kvack.org
X-Gm-Message-State: AOJu0YxgyKDND783Zk5exu0behX3jmsfSmGhRZXnvh/UGfgTPt5a7ie8
	/Ahg4eptf0zhwUg2OjDaj+pRu1C0CVJVWxqdQof5oj+5vO3IhoeAerXk
X-Gm-Gg: ASbGnctc6wreZjPqhaMuUZneuILApSO43DvBMHi8zD6s+iPrHpala45FN0DmpglOty8
	vreG7n5PPlDFxvie8raZRP6Pqup6/No9gWq8ca/o+z8RNXJR6x9I27gRxC3NXQNAZRpyNMZtNkM
	FQOEx77fK2kABRku0AxVdRJu8kum+MqGCyNo+chFc0yadDIQDahm726CLZWHDrnAhG+bw1Fl83V
	SDJnl0quoHeJTSiWghu3j5HKxGUb5KAX5yL1KhTz3TSAH2uKT2ppjEzjVTGfk+LB2pCmtev6gV2
	ZkKzxlhVWNUzlQkJFz7XOcSafZIDJID/JfsJkzM6MFLQvgDkkBtn2UqalAag/h/W0MF3VFJ4tu2
	G8WKzb+n5/TagRe0hLP7opruQ7jSIbBhaHTlSani9m+iTy0DFehvE2+1GcR3cAW+FKOSrLDxn9m
	ZjM5OSa+IlJiksRf6XlQ==
X-Google-Smtp-Source: AGHT+IHjaMedUvutln+TjYg3sLFd6itsoE7Nvpt3KUzyJzf+b+6hQAzmwMYEn4kLYImnrBTnPQl7sA==
X-Received: by 2002:a05:600c:6c86:b0:45d:d2d2:f081 with SMTP id 5b1f17b1804b1-45f211f6b0amr115679015e9.20.1758055853080;
        Tue, 16 Sep 2025 13:50:53 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23? ([2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613930bdd8sm7809815e9.19.2025.09.16.13.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 13:50:52 -0700 (PDT)
Message-ID: <4c4e97c1-7f93-4c09-a235-ab169a998ef0@gmail.com>
Date: Tue, 16 Sep 2025 21:50:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] fixup: alloc_tag: mark inaccurate allocation counters
 in /proc/allocinfo output
Content-Language: en-GB
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org,
 rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
 shakeel.butt@linux.dev, 00107082@163.com, pyyjason@gmail.com,
 pasha.tatashin@soleen.com, souravpanda@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250916160110.266190-1-surenb@google.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250916160110.266190-1-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9085E4000F
X-Stat-Signature: zducdgj7jq17m63mg3nbxkj7usx1no3i
X-Rspam-User: 
X-HE-Tag: 1758055854-728683
X-HE-Meta: U2FsdGVkX1+OJtfxxE4djPXhUhR5c5TgI7YwVC48nXhYIhZ2SzGanRf1opgWOeOdDsVzKEi2ezLF2XBzp1VedqNQEPNcwW4nNDA0f8ZyYDlDmsHnRZMM1U+ga6QnSgEAkLidI5fkflsQ2iX1XusQ8fDBOwEDIIj22eAVHA3Z9nmgbUfW973D0ix48L0/1Jh+ThSkhxNJsiJA0GgJ8iA9MnWoG6x6d8C0/cz+gBdMtMhefea7VC2njYmkEaqv5aPPihYZsrk+8o8vdmBGjYetsiftDDpCRukXJHAElkxg5CPcexFf7xAIt6xdUSBxGx9/F6D08CALvEjxKIkdfitNWBPtEPp4l0c6THUAsYVMSbecNCtglTy+GT16ACKmfHRwkQEtG8RDAouCHPKpPO4rk1kqO0gzWnkv88WBzECYJWCUv6h7VQqDvshX8feqczaaQzmWC6DiysQc4GzVUyL1aQU+4aOvNDcrbD3ONmPSl/8ZAfJcFZ8fnl1158LXiNFJSoPC55SnHysd7+SVTW8CpEiK/y6aap8JLG08+x0XJTComv9hrGi95Xscm5WapA5K431pKinssn87+eEmNglfbOCJxsqcJu7LQfSSjCEv5xorRx58NeDrPTm8rakJCDUEpd8tgeNHuB/0UVXv4wb84AeaRBdOSwCmumG1h6Jks2gVPE9aH4sFKgDOIIaZTpXsMzCq7Db/GA/XoTI5nnqjq5QwRcgbEp4vFTxmqozgjTvaaSapFH0SS5q0Ky4wIN5OBXIKR+FRyZcJCmoN8EljZw5OVD9Rkp9n8+PerM9V/4D5sTuSRJuuH/2wxDdFrIfVJTvZZCR+3DZSlk8HUgs2MWW62ewnMSXDnPmVw9kb3Ub2sfYOnMooKhE05J83kXgKvM7noOxajTrBj5rU+yAMkNamiQvSQPBZZ/nAYs2MxRMZpft4w037bI5E9Z4vrGtv9fHI7gBZ9bz2Mrl/1PE
 MIvN4kz5
 vWCOBqbiUfvZVX/9ifaUYYHBYXriEHuKNIhcaLC/p0BUxTNjWy3VCz8b5nJas04uSUogyJrCIcAQlTqWlELfpaW9VTVGPpWmXaOOOMwpKew7xIT6H/2E11jCNdaUCTrNxqJ5pSERn7a6QHAvMB6729/mIzJUYNPdKjiB+e+Qq0A7GxKIKeR3kcaSRKxCf4EaR28sigOmhGgjYtka0cWTPJ6ads8c01pr8atu/hYbkxMkuaoQqbDh+XwgU6uD/qFoVansdBZ60x362BWdAS+6aAZM+M0Bjkbk4o3u4hV/yhGmA3JCz8x8Cs1L0IwZhVdAycExm83cIj1lCCClmL+SUkKs10kBNE+MDTjjwEpccvi1ZYu+K+CV9d0voJYLNHgbHee3Y6prMnunHqpyDPOPtPiCxk0Ojz8gL+BK2yStD8Vv+KIyCZzxqhj1gxnsuSi2O2yUNN69ZIkkKbOTsoUwiV498wqSleZRjDwFOPMWABQhGGnPYCvfXVG65IJhK0mrrGSfVQ3x9sfG4W7D5Y39xR1UNORi//AG7wiWpu+54YFCtn/t52nd89dwOyWjRRNPrl2CC9pQkmOgfZIZse9sXLjm3KtofliiH3yEAgWINt9Jx9bDfge/0SMIXsIRBa0sR6OSk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/09/2025 17:01, Suren Baghdasaryan wrote:
> Document new "accurate:no" marker.
> 
> Fixes: 39d117e04d15 ("alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output")
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
> Based on mm-new
> 
>  Documentation/filesystems/proc.rst | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index 1776a06571c2..17668f82ff1c 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -1014,6 +1014,14 @@ If file version is 2.0 or higher then each line may contain additional
>  For example if the counters are not accurate, the line will be appended with
>  "accurate:no" pair.
>  
> +Supported markers in v2:
> +accurate:no
> +              Absolute values of the counters in this line are not

s/values/value/ maybe? :)> +              accurate because of the failure to allocate storage required

s/storage required/memory/

> +              to track some of the allocations made at this location.
> +              Deltas in these counters are accurate, therefore counters
> +              can be used to track allocation size and count changes.
> +

>  Example output.
>  
>  ::
> 
> base-commit: 199236646ffd82b5a5bcf2bca1579ea06cb0ae74


