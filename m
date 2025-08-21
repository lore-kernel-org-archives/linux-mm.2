Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB214CA0EFC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF5F16B00BE; Thu, 21 Aug 2025 12:32:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7126B00C0; Thu, 21 Aug 2025 12:32:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D959F6B00C1; Thu, 21 Aug 2025 12:32:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7E4E6B00BE
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:32:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77EB6B9895
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:32:51 +0000 (UTC)
X-FDA: 83801308542.12.1D13EC1
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7060020014
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:32:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b="w1JMf/3G";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755793969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJBIccdGfoJ7TBGZwMZmL6UTufIbSb7K8pHwnbZxKm8=;
	b=nKlDeYN7hRC0e0liJG3DmZIfRO6SJpDk8zxQSY+BxER90CpP3gElzupyJjHJBJCN99Isg/
	X33A71+7gkad4P7w6r7olN/S5AfdoyMbeQMNW3OEUvAMEv1BDIGzrezBk2Fj3JK+6ByNY0
	FUZC7idZVE03hbNHlCtct8jXvRhebks=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b="w1JMf/3G";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755793969; a=rsa-sha256;
	cv=none;
	b=Gs6CeBynjsAn7Gve/LAtpbLr2QdZ1wUDLQSe466m915tFvNPxES6m5iAlKaxZnByCWBHOI
	+jelSuUQq1BZ6FCuzloI5vK+vWjIv5C/Cp8uIfbm7wCojY92NlPsopj5XyIgrazfLQ71Ws
	o34hHk4QLKVIQNWGdle1Y4OjiNNX1s4=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b109c4af9eso10141971cf.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1755793968; x=1756398768; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AJBIccdGfoJ7TBGZwMZmL6UTufIbSb7K8pHwnbZxKm8=;
        b=w1JMf/3G0lbBybrBbSKaDdurylD8UIHbofNw0gTiB1Ah7JfhjTalIS408+pH4vVRqr
         uNXo2854gjajiC5nlnqCBOggMt07h751dENg2wUjVCBC0fHl+RztdbY/LH3rMHOffDsG
         68s/gpaFea2d5Gcvl6z9eFiPeoNVqGm9ShvT6HIwiYoWlZdjVa6hATGVS5DV4WihN2Mn
         fmIenp9aKLkd2y1NfyI7i7oVCxIlhmWaqwLfwPqLQjuoYjYfnEhuYPeLiI6ry2suRhfK
         Z+oIoYW++1FTN2CnDWpXzexg8GpaoOdNw8/gFh2QKXHi8zsomakHj9dXoqmb0E99XjRU
         4KTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755793968; x=1756398768;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJBIccdGfoJ7TBGZwMZmL6UTufIbSb7K8pHwnbZxKm8=;
        b=VdFMkIl9OIjnbt3s8Ifvl3QSCPyqXiig7MCPDYeIiTv3kQgRvkDNzEeT4XleI72wCO
         7szNJ48prBqp+Yj/BMdoqKyGI28JqOt9vetvlz57qkxUzpcer5Nr9+ToNbzXb0UV6MzX
         FrroUm4vwciqP9cMGylGutJWpaAe1NlWsApGUN/zUdRNk3aWyBA03ViKuoAB7NNYa82l
         N0J8BY1GoeujiJbGRaoCgJzu9OPsOGZ7AOtvQdSJ0N9RK8B+BTOFNF+cvgNXYSHmzwe3
         H19ThJyUKx2d2BOEEXpx5n9Eb431GbdP68UVCKgrmrsdYlxeo+x8Bl8oz16XXplRQPj9
         myRw==
X-Forwarded-Encrypted: i=1; AJvYcCUKuHjLI3Hd2u6obAkA76QyYO8D/RNuLMGH2uY01xdPpsSItFQ174grOfxoolxd5AhWzYDMclYcmw==@kvack.org
X-Gm-Message-State: AOJu0Yy37SlreGSLLfyokZ7wejO/TET97USU70k/xzkpdgt+aQ6iHoA2
	iNT8/mez22RNrnfxm5xoxsxFXG6joIvdltKYAy7if3AfZ+CSr9FHXXC0B5/brmacsHo=
X-Gm-Gg: ASbGncuwxR8l7fdKuY2bdmKi1Cj/Sx8HTtDhY6+Q6FOxCOdLKZMiOzsfq80laXYlhMI
	ocV3PKyRbGUYVUJWoEIL80/x/Cve59IHO8pMo5AIHs6viuJsqJmpuYieDt10emhXi+IaKQnA3gT
	d1kxntRy5R/W1cc6cvya28xtxF44cMi50BMHuKkFihJlxuoH+9N+qc4x4+r+u6kepVj3jcJu8nd
	Nl6PozC75zSxHfbII6EQNLmU4/sUrIuYo+L8MrixOMQ46nKurVeq0wojxRfDYefEMmyLOPz7sbs
	SNwsOh4QWvOnHuJXL9/1KtXbWIKFn1Xo4M2hrbnNdvSKQhquMqoIwFvCqWV7LatziDBvRjSMYmd
	Ilo34rG9X9JHFvIVm9rP0jg==
X-Google-Smtp-Source: AGHT+IGzFmxFGgD1qjjvDRMkuysEk61zJdizJHSCops/dSlcfNFa5m9ubk3r2HMYPciXBSNmvq0umg==
X-Received: by 2002:a05:622a:2:b0:4b1:fa5:c5f6 with SMTP id d75a77b69052e-4b29fa3c13fmr31056661cf.25.1755793968196;
        Thu, 21 Aug 2025 09:32:48 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-4b11dc584cfsm100798581cf.14.2025.08.21.09.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 09:32:47 -0700 (PDT)
Date: Thu, 21 Aug 2025 12:32:46 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Remove is_migrate_highatomic()
Message-ID: <20250821163246.GA133370@cmpxchg.org>
References: <20250821-is-migrate-highatomic-v1-1-ddb6e5d7c566@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821-is-migrate-highatomic-v1-1-ddb6e5d7c566@google.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7060020014
X-Stat-Signature: xt6rnmprjhuap5xn4jk9asy99n89nsit
X-Rspam-User: 
X-HE-Tag: 1755793969-456117
X-HE-Meta: U2FsdGVkX18HzeTzKRIHzNJMHvZ1iS0lYaQVXC8LzqLj8cGbjP5abt4y2//JcPcfUPWKN8LWH1NkVf4qVCXdKIswsSofkvqkBbSapOSw0LX8h5DR1Sd5mxiivNPD+sZsRnOzP6RKhM4obqvAi4HOyZNsRi4XUJg2MB4srSBnUz4QAxgMOzwpeEjIg+I2y6PjYfh5XN4qEQM1EmgHr6R6SV/KGVYzD42+FBa6tD4sUdCW3U9iD6fxIYa78GMbwEOYuL8mGrwOJSZjKlLVmEPtm78Sl4ZvX0HAItijSR4jbQeMO3S5jSFfJzahrQtYz/cYCfZKyQ8xOFiUICmDDdFVWmXxR/Mi0ZhsOu8pXvbt516g9epclF9JaMV6Nnb0gKC5OgaIVFQP/3bJoUTRSU+shItkgAgR0udNgj3ohwB4I2JBURYKgUaM16SEr7iyVQnWpnh/JEehUYrv2g0I2HHoGCe+ngo8qJUSbo4sFL9kbZ73QDMlxKCDFZGmIMoT2NT6l3xvcAMrO7BkDlhRcxpaRtumkTdWuu4TxRPIzhfjLW7rHuqMr0UblM/sSX9/Gpv+yDeRQLrzXjjQ4tAaoKqUMZGLwgFjALtC3nmztDOUodizLrjuH4G5p7HcVwovCYafUbsP7vM7pBXlvXtAClzM8kxsWHTwUDKiSr5aSXScKt2tD47l3Vv0CvRtWYa+eM2taKxXvJSKI5ZcCs4BRr+5HOmEZdBxdEnZO9PEVYfCkuojG4pdZCyen9rEYUSFWhNF3tUXiSsg3RTJrd77lmVccs3p2KkdIJs47eZWI1TPZhH9o+Q8UMo0FJLHRgTq7vZ1UQtkaWQGFYH+B7C73xsUkexQILek5Ez9w9d87010gK7E6n8EteMhlf9EM0gjB6FQvKDWEaBl/2x6y1grcy9m0IlSsXKPht+TqQhucMrp//ihOcwAp9voYcoL6auJw9ZY02x4iR4tBxcHc+We2mQ
 RMJaWmj9
 /sqGSznN+gwSAF3a7YoRkXaBYuiMRczkhcy8eRX/0bgwo4QgCUxooWdyV0t9AitH5f/IU83NnLpwxnVWwGBX4sAVYSPBj3KFQLjZLEu3PgmSWeCYWoDmC4zIhBEvBpVCrev7KVmX7P76XpmvsjubpS8IiBtCTRL8+Dyuv/IbTbcZjEw6z1e0ZVI3i+SawuzN13FcfQ8Yj8L96nmYAjfTPOzewd/9ptGM+xVwdeh4a1+Z/zRLqMPWpCygOL5BwTyd3h0mEwYeLHCVkLlZr3TvTwOywrhHb3pXbtF1JcOrF+IpXMsEFb/HgzAgh+mG7M7vIcBybh2XPEl9xgLMF9mI/Y7PJW8Nk5dchvO4/xAYQ+2zZexPHDoUzryYdiXzia1VpkCOfkABu2lXjVWtb6Zj3DY0MAp4XRi0QsKAOJLu11htgHp5nxnmSnxZjvzFxTD5jt2pJflY6keNWH2gaH6NA4xYEOQyQ8GD5VyMuBxc9njSe1yuaaZo7BpbA0CoPrQ2yiF/3JZgwezFBM411w2AmOgRtpBXD9oz+CfZcRIPkHOO+wkcuw7TghaUe1OKpNkprdOsxnPveWjyK40w0mcGm/PMQSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 01:29:47PM +0000, Brendan Jackman wrote:
> There are 3 potential reasons for is_migrate_*() helpers:
> 
> 1. They represent higher-level attributes of migratetypes, like
>    is_migrate_movable()
> 
> 2. They are ifdef'd, like is_migrate_isolate().
> 
> 3. For consistency with an is_migrate_*_page() helper, also like
>    is_migrate_isolate().
> 
> It looks like is_migrate_highatomic() was for case 3, but that was
> removed in commit e0932b6c1f94 ("mm: page_alloc: consolidate free page
> accounting").
> 
> So remove the indirection and go back to a simple comparison.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Oops! Thanks.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

