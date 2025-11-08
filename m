Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD9CCCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 01:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762958E0010; Fri,  7 Nov 2025 20:42:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713508E0006; Fri,  7 Nov 2025 20:42:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629438E0010; Fri,  7 Nov 2025 20:42:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CD328E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 20:42:27 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E234C12CC22
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 01:42:26 +0000 (UTC)
X-FDA: 84085739892.27.2BA9B91
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id E9E1580004
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 01:42:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OK75WIjy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762566145; a=rsa-sha256;
	cv=none;
	b=O/RuzFTa2y9ynB9WGabrKznhxdl/Iqbp+vh3khzXAEGH/vT8VErA82sax65xf6+nPIHAeC
	2syxgXoc/SkbYJZtQB+dUiRWyza/Rmn7MmR4HgQcr04xRZ8HYfulH5vqPv+blAN6gy3Kz4
	JROKEXQzu6gj1/cgxsIAKqznGyolKwM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OK75WIjy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762566145;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txzBDkuu6HQXRdAmWeqGcCpUJ0ARUbkkBrAd0TRurdY=;
	b=K4fZz61M5OheyqKH2qy9C+4MoB3+rZ2ksIeu8zun1CUVVvA6Pb5kN/rhv9CihbgoqecB9e
	YB9JP6hBA41o32MfJWcO/GYSsN8++6cuYBHfMoNW2A1yS7Ky0FbEoxNS9JByksgz3DQq/H
	UuHPe0JibtyajxiHKa+YVXSZxlvEmbE=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b626a4cd9d6so210896366b.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 17:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762566143; x=1763170943; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=txzBDkuu6HQXRdAmWeqGcCpUJ0ARUbkkBrAd0TRurdY=;
        b=OK75WIjyMexM8CB90XvxAEs9+3uG/d4TH7GS711casyQpJhFUA5eVi7/5pB2c7zNSH
         sENsxogD/vrNQlpppBNfMVtKeTLWCOxtJCzg1yHTIEm76qDft7Zp4aL6DIB19a9PCNbq
         tUaIKhY2Z9qV3nBkcp4fbuxHW0cIImL7l6jKNFHT5D+AyVLlfinvmk9bCDoBdNxqY89H
         sjJvNJgQapvKNBN0TWk+v3MKaGkk5znMqb9/gr0eBHxfiyKWgqwLz6A0PLJSf5Q5SFu3
         xg/0+ZAsxoim8U7CQwDTium1N6/dfQ15QVgIZCVY5Ww7tykJ+kBXK6qMgCW0ZJsY8TXr
         8QDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762566143; x=1763170943;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=txzBDkuu6HQXRdAmWeqGcCpUJ0ARUbkkBrAd0TRurdY=;
        b=GRx38599PPxnmOYFR6YknnXm5b3C/V3COHU2D86XakhkKRrlSuhYPEUGqsN00HeVJf
         z/VYGW9+IWVJD+TRlXNAZf1iWHST6s0gPwHkhDJx+53GykTTtsWkJpMUQa7DdHi00GX/
         kDqNsb7HMpC7V1DoFq1M8LZxEUJTr6oCJWG7iJStpFSs2TmSJaC0p2tUeY3Xq6bjJ6oE
         WdT/7W1Ht2TcR1YCuJtDfeDuGAK7zh2D3NlMQbbuXdXkLAROZypcP/UcOvX/B3Cd4THl
         sKqeDMVQZtdh3Auf+9qIpTDasxoqo5A5OtMn69LSmLyYYa9P4d3XekyylGbK45pTsPTS
         jwKw==
X-Forwarded-Encrypted: i=1; AJvYcCUiLarCDUKEFEaU5vDHv2UTO8cso22lm8xKMr3ZgqhuUbYGxBT9wALThAxTU75tW2O9uJmbw+uF4Q==@kvack.org
X-Gm-Message-State: AOJu0YzuqWDhipCvDNRg8/t3Ty/G6DzF46X5dFRrXderVrHdavd2suXP
	FiSqMIW35qREglrKmpl31zYlSCkWn2VZztmy8t+WaLfwIQRXgLGhApUD
X-Gm-Gg: ASbGncuY5tMLUULl5iW2iBfrMI9GtAux9Pnyxx9aILLFzIEwmRHG9c5sb9wWwsUZYG3
	WK1ZrkHW4qpJLBN2GPlVGt3z9oAKnQ++CDW7ycsXj8NNFky8IITl4k9Wbdlbj1o/Mk4xdaOTcpY
	/165pkp0G6onprYbd6BLFDDEXsJNpHrs9UG8xIaz/BdhrmKfuiaWL9q3cof6TITFNasXNegX84X
	pWqZmDZFyNm1NEC7Nh5o2FxJLh0smNUDQUZnorBoy6ONMOR5MwbXl5MO5GG29PKM4MmGbILZ9lF
	ALHaFKUJ10Rg8MCi4DNGFY0c2InRSHW/4pZBx63ZM3m+8Msi6aecQnBJb1uH6ZfkCeeEk8+4p1U
	mBwcYiwWgx6VFx32WbpBrhDq4Xs8c5dmRNmMahjD5tAyjSbBG6147+kgNkrNn73nBRyfXSPc5xv
	pkRP54L+PzDg==
X-Google-Smtp-Source: AGHT+IE6lrXy8Q8tj4IT56byqhqDOcFo2Ljy91kXlQBEAHGBuKzDKR+fUlhhjwifft9Xb8qZcgHL3A==
X-Received: by 2002:a17:906:6a19:b0:b72:9d56:ab52 with SMTP id a640c23a62f3a-b72e02d20c7mr117552366b.8.1762566143114;
        Fri, 07 Nov 2025 17:42:23 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf97d0ffsm406996266b.46.2025.11.07.17.42.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Nov 2025 17:42:21 -0800 (PST)
Date: Sat, 8 Nov 2025 01:42:20 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
	rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
	baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
	sunnanyong@huawei.com, vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
	kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
	cl@gentwo.org, jglisse@google.com, surenb@google.com,
	zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
	mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 01/15] khugepaged: rename hpage_collapse_* to
 collapse_*
Message-ID: <20251108014220.wpstoj3kqxxnes26@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-2-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-2-npache@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: E9E1580004
X-Rspamd-Server: rspam07
X-Stat-Signature: 37374crdscu9ro4xkmnzg9pktp1i81bt
X-Rspam-User: 
X-HE-Tag: 1762566144-741067
X-HE-Meta: U2FsdGVkX19pnyHgTa/btrPY0gDU2LlHkRyvtwavSPcaa/oScPx2ZSAOwaSd8AJfGeyJVDE0iw2OTa+Pdro7vE1zXyNWbiMLmFODSvl0kXs+6OOUQz1pSD88bxnqgqF84c31/WF8++ZnPAfSLPMXuhKqEVYZrlPgjf49USJuYDQ8M1BQQpdx3zI2TjmYdxI2MhrXTvvByLXR5+4GxyGbBihStj8CbDu+i51iuUb4uX6K9u+b/Wq05dMN1qMj8UeITQsjNyRPXKeiEkXK8HwbwRmh5AN6d/+ZRz9TgbQInf4O1LwleWhhn4pS8drgrVP41wB9HLAEe4S3k62h/fT5GVBwMovVonyeZOorsqWy5VdtR39Uixyo5P/cA936/m3O5q9ozJ97hbbiT9v7HTT3UBLAU6cJ5h39a4R3jWJXIzIglLNd6Cp1dcdYBAlgFSs4TeP0V7uxdTV9dElXPcZCymaItWW+Hhkin5WLjeSR/5AOBLABrVJ3m+7nOKSA9adLH1ILFHuFUA0+RU8DUvzc78qtoxVDiu1A2/oO76gQHdH7kTX/QPlCF3EWn+Xj724PZlrx0+PMzcawoyPuA/aQeV6RSDPhExikvxgtIerlQ1BGMXLxCNAZibbWQWB5umNVZTq5OfDmz6a45WFMIUWnEduP8MImChvKzgCO5hXl1XRKQ/YBxdWJBpEDZkWNDeHDF/Pg2fT0uPiVUECf/InDOflsgGadtx7Hz8mbZIxTtK+/tgaw5tUEtooQQn3MByiyzLSDMzuNWMbPSh+1PQJAHHohp/uJEZXO/j/Cztf6rbe2wBzJXbKck1RWiNeXTVYzpWGvHkq/r5TNPnHXtR8ZVzX9YjRA628KuXcso2sFPfo640fOV0dAPDuZiFuHcuJYUURUCa1W3vwmtEBOfu5dgaT+sPOtD2VULwjMlKB6DAGCTXwQneAdsVhfhkEsVTpp2252jUWy3yX+U4cSI3u
 SAUS0b7u
 KghshiP3pQoTrsKdGqObUcDEgNTdApngyNsvzqtlgXug/nSefurQhfN2QTO9Ynb1qXkm+ZqaluExAqjZRQR4IInHe3GIbjgrv/yWzkk7M+tU+lXBt3f248WCaxCQpkyJxA5MX3wR4GE2kdVr2qxbAEYAPfWh9gny0816zb2pZMVOmfXuVnldULYE1f/UlpSVanWbZ/vlfgJuDwZ2OMgxRGibQoSQu7GFrnIXsMa3czahMDjlPQfy0/z0ywQZsOvlYHJnxjhX/RWeuDwZASLQRirzw9JZg83A6bRxCaBpceDhLrj1Dpm41Yks2ehUVVk5BHgbjFBoLAewovtpTUvuZckDba3B93QDOkrYksLS3XK4ejeB75h9a9lVgXGOIR1ylELhwiQoasY9jgQ1LP8SXudLzohwaXDJKYBVKGSC5jqVcfoNTsC2IU3sgRz3qtQV0fChn5nc4o78uoBl912tetY7TOXpky9/MBAV9HWIWcxWizmN+QnB0AhKZOEw0H502lz4RvCBwwS57zrsfnCkcWuvq4o0l8hanpR4r9H2VX0zeNTy1K83aXay9Ro6PlrcofzuR8eOea6ZQeBYJiV+OC6hKrQ8LBQoLwKiLdYhpwqpY2EpNXGnhWRq0tNl7wTVztfZwHrnKa/rHuVBGupYzcc8puRjoCIb6mQXepYTb+d8emzQebDoS4KyUbd/mX94KhUMT6h3TbvLzxTIuh24dzfthylIeYMvOKIrYSkxB5Zx/Elk4xsSRKh3tMcLydo/i/CCBCjJHMmrlMJcSQmmPyCsnZ6fFTGtgjeqnjjhM0ZZMb+wygUUEs+k4+nRw9fAgOc3t77FL0CxzNN+hUN7AnkX+ntN2Z75pJ90kGIr0Si2ZYbE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:03PM -0600, Nico Pache wrote:
>The hpage_collapse functions describe functions used by madvise_collapse
>and khugepaged. remove the unnecessary hpage prefix to shorten the
>function name.
>
>Reviewed-by: Lance Yang <lance.yang@linux.dev>
>Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Signed-off-by: Nico Pache <npache@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

