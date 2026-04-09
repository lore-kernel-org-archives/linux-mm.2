Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9890CE9DE41
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 07:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC11D6B0088; Thu,  9 Apr 2026 03:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98AA6B008A; Thu,  9 Apr 2026 03:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87076B008C; Thu,  9 Apr 2026 03:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF0506B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:06:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34FEE1B7E3A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:06:15 +0000 (UTC)
X-FDA: 84638133510.22.00E9657
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 24BB7C0006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:06:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XWZz7vnC;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775718372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dy5EeN9qSfn22BVboyr8Wmy0B7KXY6Q4JMGadQ6/5IE=;
	b=aFq33QmjZi1UOiWDwzz/hXXacTIaSfxCF60IpwrglWJoT+OAfpCqNl/Q8CmsluJaJvdinV
	diYwNjszRsw8pfvXWHfV98Zp5eSQsaKNo+o8SYw2aEShgwiq973mhGJx+j33I/BBk5RgLc
	2tPAnuDo2nGCj6jYHSJoXOcXw69mdug=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XWZz7vnC;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775718372; a=rsa-sha256;
	cv=none;
	b=5SdkgfKwgjr32sIuMmQ0f021gjlBvfukjooKxIGqvshaP36S7gWN+3WubBpuAO6e+kCgKY
	rOTyexTmkSz2Kw+LzXJk2TW/NWThnfeDkhukoUgiD90lVna1aPukoF6q5irmmcIo1QUFm9
	pt8xQsdrqnKsEv1tc+DsIPcq9UfYRlI=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43d04fc3bf2so249614f8f.3
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 00:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775718370; x=1776323170; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dy5EeN9qSfn22BVboyr8Wmy0B7KXY6Q4JMGadQ6/5IE=;
        b=XWZz7vnCmpEFsn8+nIMVWQ48XUXVCQBUZ+R673ApV1lvydvrB9geOUfB8EVEab6X69
         CF2m0WnwLpzmH3Vqaq+KFWqiwMT+ZhQGmF8+qD8jWCC9Er8qy18YhbOnApUdRxnI8q5g
         pPpH9iJygbYQpVg0WWJWqpOOR8zZ05YVBiQoDpAXSwBgUwaLRQy52IHSuFwB/cZoLBk9
         iaqB/U7sN2jViJqV9LMrCz1vBblHdcerzYsiisYefXYh/SV29GZkXSvmn17H8n5aMb5W
         CQ8VpkF+d3Zcy1hWzWN18Zgdutowctnq1Cbqex7l0U11XIXUAEck6JekQwc99gut9eeV
         p8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775718370; x=1776323170;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dy5EeN9qSfn22BVboyr8Wmy0B7KXY6Q4JMGadQ6/5IE=;
        b=GZcLj7edoDPdLdHynxWPBjaXSFxJU1CvvmxDRWnXNH3x7RN7SD2qS6o3h7AWXz8ugP
         VvyTDyxvUvzvvsXOy7pp6k5RnTp5XF3C86dd9nwuYEgKEHVmPsQBZnf+NvqCW3rDl78U
         EctSBvdbmmcgUOvJUpafu5482r3wnNn3fAVvZ5skdvoMKmPI9aiutq6s13+1KYDwxOPp
         vUEO3Ibe/SGQScF02Qq1obJt9iK9qFxkfayYbt+6pHurfu+30LCNgiVc1Im+OmF1MgW/
         hJxYlabGMhUMnN150Dg86KRoX7SY1eafQZL0uFA/kDsyncEpPrh+nfMhF0xChzzrwlxc
         126Q==
X-Forwarded-Encrypted: i=1; AJvYcCUCHzWtLqo1gi8+ERH9NjMlm+kCdXKAbwj9KtvR6GjvVsSwjiKIjirGalLyDqXUYSBF6xwfPuff/Q==@kvack.org
X-Gm-Message-State: AOJu0Yww3cFbV5OtOJotAk1ynO3avEDUK5ZAoJqj0iwd0oUouLFjqbVJ
	hZVy2QpIhmcOsEw3c/9p6PYpGgrRz+3g/VQupAZjsxajVT9KeCMQtR8mXO5rSYqlFpE=
X-Gm-Gg: AeBDiesPrPzrYeX6DBGP+o78Hj9hPtSdtGfyt2TdULlGw3bw5Q8HJU3rbTORvvc8DkW
	rhFdWJXw/s9v4JR3XpSWyLas++FERTrr3TOvu0NliNG6KctEodWgTNDRQEUBmU+fEvkJwMtythP
	EYqB0+GGG4koZgOdqbwAm9ypyb+L4+NeuwoNUGjpOhfZNp5Oq819JqCvmStZ8cVtP4ZvFgWbF+i
	jVuOG0phU30JfLoABeNyeHWm8gkXxs765KeVX50O9bD9hV0zw0TIXOF1mrQA8QUoFNISbQVgpJJ
	srC2gS7CiQceZ10sEHRXI5DwJ1PqM2LzT+4mINQ9QalkqzGxyCUBkrLo7UQKceIfhz95Ach16KK
	rX8e0zxqhzu72kalAxZ7XMLcC0oVDZEyAmlk7/Uu7vksz1buBkv/wgd7hhu4ZsEGHa/j8pk/gfs
	TmViJuHRNqvTMRHiwQiAynTaf7EMQC9G+MNw==
X-Received: by 2002:a05:6000:2282:b0:43d:6e0:9458 with SMTP id ffacd0b85a97d-43d292e2734mr34408893f8f.39.1775718370368;
        Thu, 09 Apr 2026 00:06:10 -0700 (PDT)
Received: from localhost (109-81-92-28.rct.o2.cz. [109.81.92.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4d282esm64612996f8f.18.2026.04.09.00.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 00:06:09 -0700 (PDT)
Date: Thu, 9 Apr 2026 09:06:08 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
Message-ID: <addP4MKmA8zfSN1o@tiehlicka>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
X-Rspam-User: 
X-Stat-Signature: n953efacyc3h33jia3is57ziccbdrn83
X-Rspamd-Queue-Id: 24BB7C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1775718371-14177
X-HE-Meta: U2FsdGVkX197WVP3QRZKnvejmQUsH6KMQnxBQ33T1hDz8hOnUDi9QuAfDNjy84SJT2ORCQkKA4EfrSHlZtTJLT58IozbNgup7PkgA1MtPeIEBGeJUHrEcS8ge5GdVCJQ2NZHsa57btJU1IaYk/nKGYf2UiGTvb8okcgMoURsV/SQQDi4hbud9VWF5dmq+SIA0zEk/IITwymo5vi8sDeX961aMbSZUU2iGEwHncDXJDftBR6hMENRQOSOli/VE9Xv+KxOiryj+/QQxCaA9kIqrve80PlQlAAwRmhZbJVZi/rHxNmqsVNCRqREXG87ym61y2OIi+XRw8JfbVv+r/w7WXhidf4fJi1uY32OPTOMpHuLgTkxcJdwtbGnrXWYqQjlqJQeb3bmNmrWJfMNbkKdL8MXKPLsldnKIg5qykzbfAaJrU5T5nrOE5U34jyWdusrcctTL1dNyyDssSr/xmWI5tIyzJkNeebMR3n6DEgcUoZE3kvoYBMWxUiCalBvCcQV2z/EN/OWAKPY/3zW+RKJxoYH8XRNyGiRE1arg1V4q6iobRYL+DwuYQiXpkSiQhvUBrBzXwLG19JVqDvf73i5F4cAN5hFE0AqOkUlJEUQ5mUaz3CImtS7rQlQg5D3LK5yCCpnbTueAsHs4VclNSs5/T1098yCgW3I7RdFdJpYxTs8/D2upeJUoYe1ZdrJUHvuJzQUOsy9ySwIlkJ0Eaz3hLf26yw3Yr+aOrxWKSe/MMfzyA60EnuSDQtYTEwDbAVQV1u8QWCTa1bZddpaa+DMd+XqQ2qttxcvdbddKu0t57K4RZlreyn8upariuLPIxnB7y3uV84+FfaTsYxLprg35p/eHEm4HdlPEotubkjlE9kb8TVVTj+hzQqtV4FXKT94IqOObDzdNqjLUG4fbppS3ZTf0EE+saaPTZSrxRfeOipr92yzPq7JaPIE0RVYo+1XTGm1okS4MxO76UIcycT
 JFT6cgdy
 OnFYYwBrDc5De8GO7P6OM0BoS8M6NMtzJkcu5ls2C57mbA3MaH1njVifVNmp1aqqdbfP4gGO98VXOYlMsGDYBbNBao79deRerVfH5Zlie0elzPRoEurvRlTphS3lblbJ1yVSDUkXX2FZhsiPrm8nB02ayVE1wAW2tNZ15+S6FJ+e9qupsm28C/zJvtWQQUEh53hM+Pxh5lP9vxFSPu3oQP/DeNXIKzj3fcb1ZbR2cDVqAXyA0usxNrB4+VwDLPYLGPBvU6u+1T3xKkfb4y63R57tFQmSVH4mqfbUqj/2Rcnp8nsqyiFmta7eQXaJvLIU7xXHg6eScze5yNeDMMHYavt+qFl6fbDE+4IU0bihJiO9WS7nRbx8lIXH8MK0tBkT1pHEiToIefNCtZkzahYpqFb4kpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-04-26 14:35:03, Kefeng Wang wrote:
> Add a sysfs interface at /sys/devices/system/node/nodeX/drop_caches
> to allow dropping caches on a specific NUMA node.
> 
> The existing global drop_caches mechanism (/proc/sys/vm/drop_caches)
> operates across all NUMA nodes indiscriminately, causing,
> - Unnecessary eviction of hot cache on some nodes
> - Performance degradation for applications with NUMA affinity
> - Long times spent on large systems with lots of memory
> 
> By exposing a per-node interface, admistrator can,
> - Target specific nodes experiencing memory pressure
> - Preserve cache on unaffected nodes
> - Perform reclamation with finer granularity

Quite honestly drop_caches is not the best interface to build any new
functionality on top of. It has backfired a lot in the past and we have
tried to make it extra clear that this should be used for debugging
purposes only. Extending it further sounds like a bad step.

> One use cases is hot-pluggable NUMA nodes, during hot-remove, simply
> dropping pagecache is far more efficient than migrating large amounts
> of pages to other nodes, which also eliminating the risk of accessing
> potentially faulty memory.

Does the per-node reclaim interface can help with this by
any means?

-- 
Michal Hocko
SUSE Labs

