Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C58CC624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1596B0088; Mon, 31 Aug 2026 11:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192236B008A; Mon, 31 Aug 2026 11:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081D86B008C; Mon, 31 Aug 2026 11:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D71F96B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:45:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F83A80173
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:45:11 +0000 (UTC)
X-FDA: 85161988422.11.1C9DE7F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id D7651C0006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:45:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=If5PZsid;
	spf=pass (imf28.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788191109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+ozKP2hZTv9niFnVaruRiYppqsUd5pv1oHMpzqQ8/k=;
	b=LbE6A3g1oXufG4AN/eIBdhxbTUAiBPFEWHkBGzxVp8ioY8+34g9kQgsxIEs8Pi1bj3BSgQ
	G8/0uhePKfv/aEkgj7santqzzXxtfnn0zJoBToD+wZj2dTXRDUd87FyF1P2ZYP4bSTGgMl
	cg26jwXU4WwQL5txuEmybyIIRVsakoA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788191109;
	b=CDuS7RPRnHM4s4GxLyyaXtpq75q52f2AKeXrJoCIwCWR6tQ4rLPXtWBzYaazYFapNkU2fP
	K8JN/9nl1VyYHKVq+BleHFQYi18A+B6VTBdgP4nT2sB0TpJDXgW0CmWuTHuftVMVgRUEYS
	78Me2d8EE/M/japGipGmsiq5OezdEv8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=If5PZsid;
	spf=pass (imf28.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=N+ozKP2hZTv9niFnVaruRiYppqsUd5pv1oHMpzqQ8/k=; b=If5PZsid3cVdrDrjcSN5KO7Wcw
	FJVve4GhzTiIekZvsysa7UiZ1zmzOE86kvHxzKxtBJ6JOUpWiT+GD14OzCPvVOKNWHmrcMeAUcXHc
	uzzm7oGdJz/T3L7r9N+/32jGa+siIIhDpSJ2kI7JRil6uOsonUDYJEG42Cgv4YQgODy7g5w7L0Zjq
	9aL7ew46uc0EzYN5qNBeLjsUomCJqr5gOpeogYA+DE2VN/2oQgYpp9ExpfODe9U+Qp2g6aXfVlwoh
	+sjltxOqUJezGD6R7dAw0skpYsKl2oV+W7yVg/QSz4KH6cdghLTwWCeX4b4uIEURIckRCsjLHML6P
	6yulnspQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x14Bz-00000009uuz-1oVn;
	Mon, 31 Aug 2026 15:45:03 +0000
Message-ID: <f06ca3de-1cd9-4082-8c66-f6a26e417824@infradead.org>
Date: Mon, 31 Aug 2026 08:45:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] Docs/mm/damon/design: Document hugepage_mem_bp
 target metric
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260831144732.80910-1-sj@kernel.org>
 <20260831144732.80910-4-sj@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260831144732.80910-4-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: brkuy5ps7zhksg179mbejj1d5cykhejq
X-Rspamd-Queue-Id: D7651C0006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788191108-993047
X-HE-Meta: U2FsdGVkX1/ay8A1pvoJwuoJh/o5MBGMJg+d6nqXZoTPMlKEHOdJXbNiy/WBIXsGs6PID88B7Ky4Kiy65uDSy0eDMf7gIB1+rIUjy56ypm3Y7j7ohr8IG/kp2M38qsrzmc8zSDD1ZwGHwuaYz8Zz4vmIytNIgcg6n8CqzvzDKIvgGHGAgX+UQbdSP6qj5oFoqJybvI86lptaDrGJlu2EPTDj91FuNkMj5FJqZ00ev7JP60cyaIlSoXGmQC8/sltSfTinOdlcN7MYcWPDoPNtaICPZLkDjMHVlc8yslGZviP03YOJlP5LZ1WRk2bhrdBABHMK/8Zs+00XTrpINVSorBWxNrwdN1iXiV5ow2rRcxXsDTnqkZvz6KsMElOcCMlg5O4Lx59EAWFgPTHkQO4tDxN4yDSyGGHCcIUyivWelQNLRmD1miO5MR9GklsBqqPixUJXuFgpJknWmAYHbn3jhAOEAl6ll9PrT0RG7LZRCpLz7kKRPB+yNzPu9XxnvZa71xxV0bvrWFGy4Tb22GxaRmXZMP9dx6Hlv6t3Rcc4mNl15ft5QdyA0XAQ2VyVRYG0NtfnCyMgGFOMcmLYDa8+TRPSPbDcgdsVN9G0QSvjm3LCc7IIVJvtlppYvZmWBghE1oWdZixH/iNRN8Y1MlkZ2h14+LvBc5axcSEYcgm6D+WtftLndEzH3Dcu+pLOZIhpX5tawlf9sNEkMMc0ToQ0FcSyK7FMmjIbeZZwTG0tCTdtBIh3eZgA/VL3beSfPu4VYUZ3ubulkduW9OZUeV8qdLW5JeJSBymj4Ep/pcltg0ZElxM9LIeK9gX+TFnJD6knPRR8AjPI2mtvHKLgCM4kke0obuZiANpXV29RuHIEFEXXmPfI9Mwvu5mIOgrI9VmD89cA0+2aLEkVhTsSeEGnAdNZxSPbzTmQAF9GG+DtN1NJTtQRHvMND0o/mJHmO41aQgXCchPk308f5BTjTpN
 xLIip1YZ
 XF5DkYYSHQpEYMbIaCzFwV0oGSIAQFgQx6NTYtggearZqhQf+434olB8HKrnl1pog7v3JrPdOQtbzYYyeMstBPA5UbomSGNDgJVdJcn6nDMbBR/bdpHRA7zuMUq60lGank8eA97XVROquyO2i7ry1qNw9oFyk7W97tislJpTqB7nv9ZxXIxyBWgR4vXbH2JJoHY5L2p3/DGKAWx/K9ekJ7VdyHYPYNkF4pv9f1zU4tV0BPt4IkFdPBHMb1RC3UsatZFx44hSfQ/Q5mMr68xBzJxRHfLJ0viigZGHgyskv1dYBnezzKwaEU97sU92L2HXaVXgSUyCutHSSp0vrhJ2yMwH5efMeEJx8hC6eqirS69+V3R55RiPDI30I5aHvJ2ANfRmMttCuLtYLoKNqZ2i06ljzEp/sUTojhQj4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 8/31/26 7:47 AM, SJ Park wrote:
> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Document hugepage_mem_bp metric exposed by sysfs.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> Reviewed-by: SJ Park <sj@kernel.org>
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  Documentation/mm/damon/design.rst | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index aed6cb1cf4831..a8c163475ef2b 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -713,6 +713,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
>    bp (1/10,000).
>  - ``node_eligible_mem_bp``: Scheme target access pattern-eligible memory ratio
>    of a node in bp (1/10,000).
> +- ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
> +  (1/10,000).
>  
>  ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
>  ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to

I've looked thru the entire design.rst file and cannot find anything telling
me (or anyone) what "bp" means.  Explain??

thanks.
-- 
~Randy


