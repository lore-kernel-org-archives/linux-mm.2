Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF00D0D142
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1405E6B0092; Wed,  7 Jan 2026 11:54:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EDFE6B0093; Wed,  7 Jan 2026 11:54:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3BDB6B0099; Wed,  7 Jan 2026 11:54:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFD986B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:54:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8FC998BA02
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:54:02 +0000 (UTC)
X-FDA: 84305765124.03.1E15A8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C8D43C001A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:54:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIC026HR;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767804840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eXe5T45PWeFE4Slkc8bfTsXrqAd/nIKT+miT7WS5drg=;
	b=X+j9iRniFDEyrbYHz36sMz7HBl4G7Wv3B4ubEFUGHCWqzqJtnTlP/zw4pIEEGjrgQrX+wQ
	AMWZPrzW8OrdubGrojZajmg4FJBZsQd4tA7PAzdNjM12r2VEDDyXagpLHeBFshjeWbTv7R
	b1Xx9YPLARkqHhW2JNvbMvjJ7qQna1I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIC026HR;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767804840; a=rsa-sha256;
	cv=none;
	b=esoo+syRMLo81VCL9ffiUGTA1jrzHm78vgd01jZE9Zk5a80DP4TbRKiOGgVvoPuTwQsq8U
	c6GpctgqIWpSMNZg20xhchPNBQVn6wKJ93SE8cspV4QFcGGavbajfUj45Ylh48MNje98Hz
	ZSAA6nQS7sDblPYcPHed93Y4J+XBvzU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D86FD60018;
	Wed,  7 Jan 2026 16:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93191C4CEF1;
	Wed,  7 Jan 2026 16:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767804839;
	bh=igcM/mbFCK5S5KFQ8zrsNmn+iGbAx0HVWfuQ0JlSRE0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VIC026HRBah3/LsXLaAE3th9gYPyUI7/UJ+HecNvUect9qSGHiQUG+MPv+IJV7zNf
	 9gdYifVQKJVPagLEqwd7OXb5JZBYyuFjakGvlHbX8fi/uIcHPYCQxk4oc2W97goHeG
	 +Gay3ZH8tcIuXzGTIt51ZglUY2UPYKRU/fSXEUofKwu36OAgr6NuQ2EqlBzkPfGorn
	 gmv7QFaki6yYwOxL6U7x5GawqWLqNANBUX1/uux1igWZwjohPmBxMedZ0RmidJXedK
	 A1+Tg++rJ4Oxt+hSlMfq/RPmElqRzrLHi0khAyQ6m3DGxSob9Sp6uCt9xSdS3/7EG9
	 GvTpxHuW80Jhw==
Message-ID: <1a6aedcd-34c2-4e26-b07e-6eb8d423b759@kernel.org>
Date: Wed, 7 Jan 2026 17:53:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org
References: <20260106162200.2223655-1-smostafa@google.com>
 <20260106162200.2223655-2-smostafa@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260106162200.2223655-2-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: wz3yotjbnk5g1htj5iydezdkuxdc7dsp
X-Rspam-User: 
X-Rspamd-Queue-Id: C8D43C001A
X-HE-Tag: 1767804840-393313
X-HE-Meta: U2FsdGVkX1/b2oKSUBaqdjFCfsZLMKs950I+WXJYn2JTifxMO7SM6T15y6fzjs0zfogv9fAJtUFSvd/fjxFvH+1OpKs8dj6kpgdoZNWSOBCEzUlNZm2nTyIYQTy2pgsmoSWw9zfq7mSS1IpG3pArIQybUc5l1BHF270AX0laXanLDC6DVYuwispKOYD2PKgSeX0wCbxw6x9VMMRy2QpAWUlSi9q8a62tCfAPzGCJV6zjbzrvRG71mnQboPIF36OAOkb+0e7fCS766Y8AjDs+ELP+dH0DTVXGXfWu2jyFd6RFXzP+Y8oI/3uv2Aws2RWF1Ep/zXfJZdkYcnMuJz0yv6iUHTpKi1WKuaU/lB4NOYBGJ8LxpeDQU24HyeTk4nvRCHqkMNKSuttn7l33yLTF/e4O39y9MoLuQxiTFQ1uMtclDabyGz9+NDGY0VXhhqCOttqoLjPV9pJsHorJFa8kCIEmJXsi1zPaFqI4tqWslxcHenm6jTGFWiz7QbJfVXCv2O1zIIJd+iOpJK5MLyZlBdJrbuDalhw44JInluHw+iXRyabFMf2Zv2PTtZBxKuhx/ESQYbW5dDMgFWOgNB99c+brUqSS1wAa7rumRUepwp5eEBq5z0r91wk3l9x2oq2/xRvFOCDnCgRK8U9FpKOgNppxNj08SeMJWe06INLvjWqbVZXBQDUOKbW8Jp1GDHmTtNoY8guWmyTn6ZW7RZ1JYXByOwrehLtKbVv1BwJn8C2goDcOM0H9j8+HtZJIvLJswq7LDTF3b4LcMFCwZAA8Vh4TCphvFFocT2TcQHB2DtJVikUQ83RrDGQD5eQcBcfJ7b8pZ69nrGIXNFI+z/lFqO69AjM9eDc+oQvyAgfFCXC/hRmeAf2oLANWUSTqWfIWWTW5UqfwHXgwTTIfEW2RMwN397gMHV+bxir7bCp8D2ZNG+x4uak/jbkMPc4fvflIeSU/zMZYtUF/T5G6G9T
 Q/fppVJZ
 CDFd3rupXMub6j2NkkvgsMhL1NTQU/R/fyN7O6N7HRYjr1nlOwkMExiEZS+PffJ5MY3O4PnGN/0A8q3J2z5JanlBzWvkI+9GbV5mRVa4oI/8dqnsMv0mj9qc+bFTxmdb49xEM3CHxTucZW/a0JjrnuB2+k7ymOiDwlmlEOREaQZwuq2CgFor+QDM6RUPf8epUqDq02nL17QtQJ+YTdWa66sE8ySUE017IhYo4pM0GKjDsoF7295yYUXaPUIiIqjMSLyrWOu/rIU83EfGMDnMTV91rV7EkzD7oEhkK20uxZp7KIl60Q13DcLa4v4YXM5ClQ6Z+ycSNase24C8KZVySXHE5f5IxtcPWy8IPKgXNtw6QRsXbGmtqMRftvGsjO/LSNh1o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 17:21, Mostafa Saleh wrote:
> Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
> page_ext.
> 
> This config will be used by the IOMMU API to track pages mapped in
> the IOMMU to catch drivers trying to free kernel memory that they
> still map in their domains, causing all types of memory corruption.
> 
> This behaviour is disabled by default and can be enabled using
> kernel cmdline iommu.debug_pagealloc.
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---

I think I acked it, but maybe too late for you to spot it

for the MM bits

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

