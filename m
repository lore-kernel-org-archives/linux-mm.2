Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74282C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 11:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73528E0002; Thu,  7 Aug 2025 07:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24BC8E0001; Thu,  7 Aug 2025 07:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEBA98E0002; Thu,  7 Aug 2025 07:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BD0F68E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:01:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 66F15140A2E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:01:10 +0000 (UTC)
X-FDA: 83749669500.20.93C148E
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id A1103180008
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:01:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="l5N/v3x8";
	spf=pass (imf06.hostedemail.com: domain of elver@google.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754564468; a=rsa-sha256;
	cv=none;
	b=qI7Cu4PpirZRJuURO6F3E5kviwdlZm6U2eSjZhlednxQrd64SABdfHm5JLECoiz2wOqpcK
	OeOqqBMlxGPZK/r3YxjUgPuFe/HHbd1zWv2b+77/0BkhSuDZI2TzAqbKVtMDIGggeq5oGa
	V7uUNacFbEj26Mli7pYT6MVhE4IZGpg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="l5N/v3x8";
	spf=pass (imf06.hostedemail.com: domain of elver@google.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754564468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1LA4zLatdYQ3Y3OjAbWN8XrQew8n5n36uGhalyKn/8=;
	b=UxXFyeU0PYWiWqczxWBCL7jkTYQjoOBa3zxh8j4KVytEuBEOIAyB62ymoUtVbf7ZSAi+el
	DCyRKBUmzhjQ8GSPfdVzc83pHVdRmzFErazIukYxkOR2Lwe4p0VPmhHEjTKsAtyj1niWzl
	1RoYy/MZ27OeAztKzFed7fWSQ4JbyAc=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b78bca0890so392882f8f.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 04:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754564467; x=1755169267; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z1LA4zLatdYQ3Y3OjAbWN8XrQew8n5n36uGhalyKn/8=;
        b=l5N/v3x8qdtYrUIQxlGMym5c78XlAT3fEiDmtevBVVlUr3JwOZqiuT6ZB0gMERNgFi
         Ern2hDHOGCW8ISlFap+EdyAGzlPyuDgpMNfesgSGLWo1L8YdaJppyOqVROmGpkdPPMj2
         Yj4oPZaRi8Sunau1ifC5AmVhTCr/2cMPYYYI8nRX63l2UEUj1vKWp/k68jySVTROcaL3
         8getTKJfcyduYTL/OtISf1LN5SAfo0jxBYa0MJ+CNSq1Lqbk48992vwp+9ZjgbOL8/GI
         7lma9p6k0wqnRfWTDIiLTLXZdWLrBtX7T2eykIvCAob5X6PRXXpX7habOWrL0Lb0zLP7
         oIyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754564467; x=1755169267;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z1LA4zLatdYQ3Y3OjAbWN8XrQew8n5n36uGhalyKn/8=;
        b=RnULoBnJ2kod0+6/EHEzxEryrXmxGUIveP3MKGgiyZTf9PXW9andl0MzAVKmBg9W5F
         ZpARhLY7vpxhpRU4hb3/ojVXtr12gKJlYntYKSWU14sJDXjhPhmqZakGJP/qiff+wPhv
         ITSGl6/uA6RcqttP8Jl+jXZbQe9PefOsTshImUQvgBShkfYECjc+tvJzfm0drHa8bS0X
         DNTbpoGU3IO+GDWIZuRcCdzlzgvwKQf46BBl9n235l77KoKz13JYJmu7PAYAUlHiabyE
         LoCHK8j7+8jjBjEmCNFg68DnfEgxS8ZcJreifoRwblLDbBUWFRX+f1bYVHsJiAA3ogDA
         zdNA==
X-Gm-Message-State: AOJu0YxP24yYfi3B1KLWXE9pipdgxTFnvB7S4Jly/mONM/OuAQWIMb72
	XiGpWRlorowSWYD4DiOM5MvgL0T2+4CCC1w/KmvfnMNRQbF6/KDPe8SFk9UhX+W0fA==
X-Gm-Gg: ASbGnctvA83jEj2miH+aX3o4kphwejvanr90Em7tutopEcRwjn7E8OOJHLHhNtSW/U1
	BBNIkG7gc5G6vKswCbs2yzUqQ7VM7nnvQs4ZJGE/kpLhuuULbzr62HwWmBc7GbsJ7KS58LqJAcb
	GApPeJ26DuZjEOgC55qLGWJ8Gk3Iclr2lNrPHOAjHYOKJ5W0FQSZGHkKJvKGaJ80QL0wHXL4Z/T
	0u34T5GL/1EQU5L5rCp+xlGqNS+jyrFJdsnEppfLK8z12/1y6AGxnDKOEBScMmVjKAOuJdI4g1r
	mnCmf8Yxv1Ti+u0INEOoyU/wAapQhi2mit//EQlP178WxfGf4LoUTdbW9s1nJK/bmUAgVb7AnvJ
	tMLRvmPgUp0Ry0h+QpEJaFsCxUBGo2rsFBARa/U4p/cnf0/u8plSyKGKfPSQ=
X-Google-Smtp-Source: AGHT+IEwZ2Oq+pTGZgJFxX26wp+82jD3we8xi3/GH3Welww/bjc1k6gfMisY/v82jM9c/h7V+Z4+SA==
X-Received: by 2002:a05:6000:2489:b0:3a4:d6ed:8df8 with SMTP id ffacd0b85a97d-3b8f41b4ed8mr5599905f8f.39.1754564466804;
        Thu, 07 Aug 2025 04:01:06 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:2834:9:ad48:3e8a:43af:495d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c453aeasm27312698f8f.40.2025.08.07.04.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 04:01:05 -0700 (PDT)
Date: Thu, 7 Aug 2025 13:01:00 +0200
From: Marco Elver <elver@google.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH 0/8] __vmalloc() and no-block support
Message-ID: <aJSHbFviIiB2oN5G@elver.google.com>
References: <20250807075810.358714-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807075810.358714-1-urezki@gmail.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1103180008
X-Stat-Signature: gj6qfghcgo9wpju7osh5bwhkma9ym6se
X-HE-Tag: 1754564468-292906
X-HE-Meta: U2FsdGVkX1+tkhvWZL1Ayje9+7Xvdm0SlA0VqopSW0zym79eCJ75pCoEzujFEaLPIfPjw63DNRZO+2mVR3w/Od9nVNT5M7NEZHlE8K51scyuFRR2691raoVCkdNB9+nmui00tbikLbAZ4fmSZhA1/FRwE3cWgV/X16tAw51DH7RIfx9DGU9mhLmAt4MzdbdIK525UnJKkcq/+4mvfhptt/DbUpBYoz+0RVzP3bElYGI5oPC9dN0Lwb0N4pSA5qkRUaspe/q72MItRz8zmj33/FzWan9+6uDjOU45nrxDW/b0oyFxj7W0NgSHXeXhLeK+LM7kny3I6I7bnlZjbwccMBIJsdRFDkmMqfw7WRVfYELYc/DWrfZJQPD9OeDtr1KyMZ7oYQbjgPQ+phl5NShesecsK2FF6H2H5ZE6ng+XrWzVJBtLk68DYu6R10omC+tA3/cMkDcn1irkJpNKcmMcPTiVsQEMzL8Uj3B9m00YX4+xTneLUerLh3IIbqpItfyZNuZxZODYWCO93NZm+CdSByndpXsA5LnzpZdo3PaWdkr8FJVb8DtM7Et1pw5QDpcqWCfPITX2db3XkoLHYCvzZNOtz4a5fdD+gbiE5gf0mphhGEavAmQPcqm0k637bQQ0eiMBfpsDsTKKNgBo0C1o7NXIMqooqaRI/KiHEUmlR5a1611kOZoOpP+7AIWuU5Q0zzjW3jHgZElcxa8WayLGp2A39D0v2TbetmutVt0qyKpH7V6uE2Fa0N+DmbwYTvJiDLjXmfuxjMO5gzVgGez6rn6qInWMJvksjXU3+/1gp2WiAOc/8zJ7hfZP/66cMmsSeq/B7tl8710P7VJdIj8KHCVa001eo9GY3Q5S8fLYfu9hFmhM+oSDCJcniU0wxMfjx50/n/hlr9IOHSjM3J7CeTpF1mSqKZC9ZWSwmq/xEamYyxoD49/FcPC73SLcchy50X21phEyriIL4VGy+ko
 pVD5nNlF
 4YBJC6SlCFORsz0meqtTeTHPIgK6Z5kq3fLm5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 09:58AM +0200, Uladzislau Rezki (Sony) wrote:
> Hello.
> 
> This is a second series of making __vmalloc() to support GFP_ATOMIC and
> GFP_NOWAIT flags. It tends to improve the non-blocking behaviour.
> 
> The first one can be found here:
> 
> https://lore.kernel.org/all/20250704152537.55724-1-urezki@gmail.com/
> 
> that was an RFC. Using this series for testing i have not found more
> places which can trigger: scheduling during atomic. Though there is
> one which requires attention. I will explain in [1].
> 
> Please note, non-blocking gets improved in the __vmalloc() call only,
> i.e. vmalloc_huge() still contains in its paths many cond_resched()
> points and can not be used as non-blocking as of now.
> 
> [1] The vmap_pages_range_noflush() contains the kmsan_vmap_pages_range_noflush()
> external implementation for KCSAN specifically which is hard coded to GFP_KERNEL.
> The kernel should be built with CONFIG_KCSAN option. To me it looks like not
> straight forward to run such kernel on my box, therefore i need more time to
> investigate what is wrong with CONFIG_KCSAN and my env.

KMSAN or KCSAN?

[+Cc KMSAN maintainers]

