Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E7C5C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 04:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC696B0088; Fri, 28 Aug 2026 00:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8BA76B0092; Fri, 28 Aug 2026 00:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4DAF6B0095; Fri, 28 Aug 2026 00:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 770A06B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:13:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0108C0389
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:13:45 +0000 (UTC)
X-FDA: 85149359610.11.422A37F
Received: from mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf31.hostedemail.com (Postfix) with ESMTP id AF8C220002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:13:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AD5kw1eX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787890424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vaHAeHZAubbAg7IGdTvet+qeZCha9Fi5yv4MaDDiDTI=;
	b=mUYaQz3UgYQf+sccSButB/EJCZJmQPiKbtOMfkzW9pCToql/X/XLtyDd/wYX3X/mOvvdmc
	xq4S97NsAJX75rqTkkQU/QHoJPhqMQbxPyuQdfrZ+yMa7eFypAaht6BF2guh+HPOXoWD5J
	CbIVfm5bAUtVehsH4ZkOlpcckag4iyI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AD5kw1eX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787890424;
	b=yZ7bOBEgNUp7UytP7eYNklWYp/j2gSd9QhCz+f3RB1vptH2U3q6P3bswH74WEAhA68GQZn
	PXAZwVGHxXZOvWZflnXPhVMzlau0fNXZRxM/86EgfEmMsfK51Svq6kJMBm0DH2QoZdCHDN
	I8ltoHq8P1VEzkZjlZUwbrSB7Motuao=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/UeMi+JaZA3u+VpJfUjNutnV4evOAW5IF6lj0AjVMqs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787890422; v=1; x=1788495222;
 b=AD5kw1eXxJl8neo2OF9VN1B7HPwm/QbvdLYuIsNsJdUTXgJ+QrdjYYoijRykkZG/SFyHMl7v
 pzcetuM8TIN2g8YFhL7hh06uSla700DLGK2Fsc6qdEdyKUcCkHFzKcjagEN/4rWOlE2/uS3lE12
 pWphzs3/eOMiaZN3qvCo8Z+M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8e322e2d7171c530;
	Fri, 28 Aug 2026 04:13:42 +0000
X-Mizu-Trace-ID: 8e322e2d7171c530
X-Migadu-Flow: FLOW_OUT
Message-ID: <88698ac7-3a60-45b7-908a-7f1521c021aa@linux.dev>
Date: Fri, 28 Aug 2026 12:13:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 25/37] Docs/admin-guide/mm/damon/usage: document
 sample filters dir
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 damon@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251208062943.68824-1-sj@kernel.org>
 <20251208062943.68824-26-sj@kernel.org>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20251208062943.68824-26-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF8C220002
X-Stat-Signature: u3zhwc79opgm9x6j768bdr1wr6no7tcu
X-Rspam-User: 
X-HE-Tag: 1787890423-524045
X-HE-Meta: U2FsdGVkX1+2wjRwWgXPtyC+FELMEAtc7TL9C9HWPvGOtBA9FDcDl/dPsjjvfxJBoPwoMTL4wCaNgbg4f4ZtVoHTgm+/lKAn7xVoAmNCs1VO4HJd1NvNwKJ4lHb7CkTKtOxdy0o30GBd0bIng3s2TEpAUoHc/Uk+db1UsYQ+EQc48CxR8Y1/4HnOlgXO6OHwG3sBrRwWNi8v2BVxSee5P9LIUYl8cIytqH1IlBfxYt85aoIROxQCEMxrFjA78nBkezr3IhyjjsbJyysTdxgw8W+/pz+87rC3XCUWbIdh+3AvBT07tlrw0Hw1q8Rm4cCg9vuXMVn6Y1n+mV6LZzux9mG/0TzfCRu60EgNHLuP0iVfWGs9x6Oy3v3VGNkFghRwG7fjoK0Q5wwm+MVST/S9dGLIRg1YXLF3Wz0CDja7EN/p//cNMGcXCko+U35ZqGPZFzP/dzF3+QyX8aZsfmL/yY5rDgm1CjA3rMgN2+yni5bXbSz5HT0kEx5JNqZQekgXhlpuxOHhA58H0oxRYB58xmBxsavJi2uO+i+EoZf6U6Pi7EhTVlEhad97pWeLWjfu4HEhM3M+Z5KqNl2yhlkk1jbUAWHoNyxMMc8onGmHQLv6QZGpOtnzKi3oMAVX7zmksNBywl+4VTOG27cta1ZBov1bgTCR4Js77J52GNNqevTx6G7jxP6HMZdedFqA6f8HzOt5BjVTjnyFwG0TQ1Y1Nge8vD7JWsQ8Zl4BEIpNs+ZCcIKChXH7Nvlb5kJXJ1bO/K5KX9/Rq13BjqqnLtdJ37ys8s7s6JRDMirURT3DATfmzsmMjXX6i26jRBMrhJeJxzGVsfBKgkcuGd/8XSr/qi2N6e4AksEIAOaC5PoBrm1Eub8M1AyQUSo454NLSmMML81+1hqYBK85U2Zxr9TwTP28uqRXlIyOlY4HZu8M4EhKyvXf5O7jqpWYPHUKq+BAWcA/GWslF/HLWnDuHmW
 1Ggk07/W
 akI6koMmRVLbUz304ny1RWo6RclLzPvVFib/j2XOUyJdHinc+hMooam2TKii1OdhaKVh/BQ/YbgeoEkaFgGkMHx0KBXzauZol6smKqv6H/aWnZwWBX8fFDei4vyZHaP74woKfyQAc9s2GPDpBiTy0G3mkIRYuT/ilD4z94oWyVKl1QcDjaNoSsJKue4VHdu6/+JPom6FBlYF5Vekc/Bi0kJvzMfDiPrwNWl14u4u+edb4mH3W1YBnAtY1bdq3AD8W44/bN079pe3Doex32/04CXxO/V8ITMjwhVBoN94DuRnj10PX/c2TXKH0aNDCb30yU3XKtz0xgnaw5n9NIurzFUcwzc+VA4KLFR3E7ofntV4bHAWQqU7Aru9iJ77k1/q5IRUyyNTUDOF/bA95kv2aKLLSJerALFcVYsx8tmxulukax4GRoe25DN9U/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/8/25 2:29 PM, SeongJae Park wrote:
> Update DAMON usage document for the added DAMON sysfs files for
> installing and setting the access sample results filtering.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  Documentation/admin-guide/mm/damon/usage.rst | 25 +++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
> index 897a89950351..365a4548a5ba 100644
> --- a/Documentation/admin-guide/mm/damon/usage.rst
> +++ b/Documentation/admin-guide/mm/damon/usage.rst
> @@ -66,6 +66,8 @@ comma (",").
>      │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
>      │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
>      │ │ │ │ │ │ sample/primitives/page_table,page_faults
> +    │ │ │ │ │ │ sample/filters/nr_filters
> +    │ │ │ │ │ │ │ 0/type,matching,allow,cpumask
>      │ │ │ │ │ │ nr_regions/min,max
>      │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
>      │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
> @@ -233,7 +235,8 @@ writing to and rading from the files.
>  For more details about the intervals and monitoring regions range, please refer
>  to the Design document (:doc:`/mm/damon/design`).
>  
> -Under ``sample`` directory, a directory, ``primitives`` exists.
> +Under ``sample`` directory, two directories, ``primitives`` and ``filters``
> +exist.
>  
>  contexts/<N>/monitoring_attrs/sample/primitives/
>  ------------------------------------------------
> @@ -245,6 +248,26 @@ to these files, users can select whether to use the :ref:`page table accessed
>  bit <damon_design_pte_accessed_bit_access_check>` and :ref:`page fault events
>  <damon_design_page_fault_access_check>`, respectively.
>  
> +contexts/<N>/monitoring_attrs/sample/filters/
> +---------------------------------------------
> +
> +This directory is for control of the :ref:`access sampling results filters
> +<damon_design_sampling_results_filters>`.  At the beginning, this directory has
> +only one file, ``nr_filters``.  Writing a positive integer ``<n>`` to the file
> +generates directories of the number, named ``0`` to ``<n - 1>``.  The generated
> +directories represent the sampling result filters to install to the DAMON
> +context, in the order of the directory names.  Writing ``0`` to ``nr_filters``
> +removes the directories.
> +
> +Under the individual filter directory, five files, ``type``, ``matching``,

nitpick: "four files" in this patch and "five files" in patch #32.

> +``allow``, and ``cpumask`` exist.  The first three files are same to the
> +properties of the filter specified on the :ref:`design doc
> +<damon_design_sampling_results_filters>`.
> +
> +Users can specify the cpumask of the filter by writing it to ``cpumask``.  The
> +format for ``cpumask`` input is same to that for other cpumask inputs like that
> +for cgroup cpusets.
> +
>  .. _damon_usage_sysfs_monitoring_intervals_goal:
>  
>  contexts/<N>/monitoring_attrs/intervals/intervals_goal/

Thanks,
Zenghui

