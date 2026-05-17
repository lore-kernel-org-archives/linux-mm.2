Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A13CD4F21
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 12:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40B3D6B0005; Sun, 17 May 2026 08:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BC506B0088; Sun, 17 May 2026 08:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2B86B008C; Sun, 17 May 2026 08:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1EF346B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:49:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB5361C17D4
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:49:30 +0000 (UTC)
X-FDA: 84776892900.28.246BF7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1A38B20005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 12:49:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kHdmnBUq;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779022169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FV1kbr7iD5Kj5G8AUE3qIveW0pHBebqZpIUuxOHk5dM=;
	b=Gr1f7EdYZzQx+7t+DenK37TlGOxs3pW8bCjYVRRc7qTql0FMFFzDkapscwkaksn9yKBqoc
	hjvuv2+o9jzj9VYQRwXRi/qt1sOEKyiK3qoRNA4UWcdafbe1KOHdanbTrzppcEumhT2Er8
	QJ+ZpbLtUNUbKuzX5jczo0hKBWry9Uk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kHdmnBUq;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779022169; a=rsa-sha256;
	cv=none;
	b=pTRcvk0LhAO5hDh9b+2P8tGASpetLGX04uPaz5yvlcQxbP6CLIzN3w/f9jhq3nCsl6aVA5
	53M6TEhrS6VFUDdNr7AyZVpLrQZk2RwMt2MD1BMNvmy14TEiUhsAw/35kkSreC7koYfmJm
	UgSwgfP0GYO9O0ZavWoydfVfJasCeRo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C42760125;
	Sun, 17 May 2026 12:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2FDC2BCB0;
	Sun, 17 May 2026 12:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779022168;
	bh=sNJA/jl/EaDa7BUPvNrKysqcuzfpWIeFwy2KukIxd1w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kHdmnBUq2HUAUw2yA6cNnuMiyct6GNtvNpwIr/CtRdT3wET6mJyyIqwPejjecJ8jY
	 +c4cksP/kqExL0fk7pZ6xGhgEmEfRO8+WgoE8OIC4tmCpe4vGrvmJwbxYvHY1jinin
	 YkMniLUmrQe6tE2kM51/FILiI/hyiEDsGGLmhrBFcRIXP6s0Eosy7kLuSUGfKV/D55
	 qfK0yf+tFFRpofU8HyQWEe7aSoUwSWmPDsq755k3eB4iRqJ8hJYDakmOLBSDV3xJPC
	 NpaOqwkwj6E3h9YVbRTEhY0G/+jQ7SzWzIe3BCbcNhreD2DoDgrUsIaApWXxBen2EH
	 T/suDzpgT6i1Q==
Content-Type: multipart/alternative;
 boundary="------------J4Cjmrg0gCRpglcMOtKILyWJ"
Message-ID: <35bc8518-27ee-4c6d-8e62-208b35e62c80@kernel.org>
Date: Sun, 17 May 2026 21:49:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
Content-Language: en-US
To: Zhen Ni <zhen.ni@easystack.cn>, akpm@linux-foundation.org,
 vbabka@kernel.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260515091942.1535677-1-zhen.ni@easystack.cn>
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260515091942.1535677-1-zhen.ni@easystack.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1A38B20005
X-Stat-Signature: x1pkof84gjabkoexteh6xou4zh98oriz
X-HE-Tag: 1779022168-420430
X-HE-Meta: U2FsdGVkX1+MukiH+6yO6Zks0gwYjnzsDhv+rOpNWCbn8TUndoSLLHBIXFi9Rf9bBEthUWHag/AdYyvHWNOo47qosLYdyPGyzK/hMTR7z0JYeb/FdhKb/zaT0mu5/H2zvCDu1a7A74L8C3KgFdykdzgbQV9O4vGmAte0ufriav9r3AkgN0cp/5/SNcI1ZVOW8qnMAYH5qdq6idjv9FtahqNZaDU8z6I9NodG06iP7XW3qsIOQAVBwG7Lt2ZolbkgbGREr3qcpZMQwigrF/qYYAu9mCzUCwtlV8MZv+w+HyYTYlDHQRNH8utGR3k561k1ybvf+NOexRkMtIaUOGLU/+/Fi9S68KffwvwZvLDyUCcGz4g1LKxByXIfWBp+2ijq3kw0ov1kVHUjMpby61pVM+ZU32T88gcC+nW9jqcuATwye5FbPRJSeuHaZxL6Ubopsq6p/CiUFtJHEzCZedzxiA8ZaugAq7oZEbxVyiLlxPPN4Bo55+iNl1lTWb3Wd8I54n7M7Xsbj52WtMK/E6v2m1DFqCp3Fkj+OdG3t1Vii0UhESfetLq8uWlRzn97QdI877Ygn9KnMU0gUfcGvQ1y+jkyLb/S/Uzy0vNax0rmg1B7Xuc2vHJ3aKvn7J28ODwQEN7K9ZK+EmCiFRQvp9vpqtUeop7fDaiQRXGqotFEEevbBuB98NmpxPT/l5NMU+RGsy/oV2YX8y2PWmgohTPD+IMBoR23k+B4Yw7JOc08u5bPgAruk88VS60aOE2LLGQgn1O3NfjbRH2xraT9ZVS3OJn6A4keYym+Ot/nriMI0eJBl2S5y/58tISx+Wx/3ktczZAHKA7dQr9Tw1nm918gde2xbdolmcUuh3+g8pEHWfwKwQ766+7HvIvS0Q4l8OZR7h6GRfEtBK/O4iKwlQ1xaMdKBflZJ3thiu3W2oSzE7QqlLMNo952nIpqxnxdV0iSvDCM1Aev9B7SOeixo36
 GGvPa2RQ
 SGPYoVHGWxLicPQ0za86QPhkRqjfwhUt+RhWTpmHUDfiUvALwYjiWn6J4IOfCirroS6SjaK7NER8fT0u/WhqGYt8N0w6G67JKywRtJBSIDbYf3PBOBd5g5eaaKZzNQKv/XXYbr+vCzNmn6hCXKCbtCET1wrgNr7NHHW2lXoY8PaqDz9IhlpMnjNuSTqBjpeJl4gCA/LASdE65z1754i5DPIKzOhHzPN3Ng3ZpLRXezq3h/hUnUR7WBawqZpeB+K0pT3Uj64aXtSQ32vQ7XD0/yDt/vtOJgzPuXLAwawlRH2f1BacMsmUZalsPPHIoANUD841WRnIYGyFhJ+JvtUUN6TEOFwD6tUcwmyecPrMH8OI1MwXFKqUdbRmY4QPjxPy247CbiX+ASOlFaB62a7O8vfiAmWS8ywxAaBefGEfjPMMzhyjbTny/ikXo3ueHj6khQWiG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------J4Cjmrg0gCRpglcMOtKILyWJ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 5/15/26 6:19 PM, Zhen Ni wrote:
> This patch series introduces per-file-descriptor filtering capabilities to the
> page_owner feature.
>
>
> Problem Statement
> =================
>
> In production environments with large memory configurations (e.g., 250GB+),
> collecting page_owner information often results in files ranging from
> several gigabytes to over 10GB. This creates significant challenges:


Just out of curiosity...

What are you trying to do with this data on production servers, and why 
the existing

per-NUMA statistics don't work for you?


> 1. Storage pressure on production systems
> 2. Difficulty transferring large files from production environments
> 3. Post-processing overhead with tools/mm/page_owner_sort.c
>
> The primary contributor to file size is redundant stack trace
> information. While the kernel already deduplicates stacks via
> stackdepot, page_owner retrieves and stores full stack traces for
> each page, only to deduplicate them again during post-processing.
>
> Additionally, in NUMA-aware environments (e.g., DPDK-based cloud
> deployments where QEMU processes are bound to specific NUMA nodes),
> OOM events are often node-specific rather than system-wide.
> Previously, page_owner could not filter by NUMA node, forcing users to
> collect and analyze data for all nodes.

-- 
Cheers,
Harry / Hyeonggon

--------------J4Cjmrg0gCRpglcMOtKILyWJ
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html data-lt-installed="true">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body style="padding-bottom: 1px;">
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 5/15/26 6:19 PM, Zhen Ni wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20260515091942.1535677-1-zhen.ni@easystack.cn">
      <pre wrap="" class="moz-quote-pre">This patch series introduces per-file-descriptor filtering capabilities to the
page_owner feature.


Problem Statement
=================

In production environments with large memory configurations (e.g., 250GB+),
collecting page_owner information often results in files ranging from
several gigabytes to over 10GB. This creates significant challenges:
</pre>
    </blockquote>
    <p><br>
    </p>
    <p>Just out of curiosity...</p>
    <p>What are you trying to do with this data on production servers,
      and why the existing</p>
    <p>per-NUMA statistics don't work for you?</p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:20260515091942.1535677-1-zhen.ni@easystack.cn">
      <pre wrap="" class="moz-quote-pre">
1. Storage pressure on production systems
2. Difficulty transferring large files from production environments
3. Post-processing overhead with tools/mm/page_owner_sort.c

The primary contributor to file size is redundant stack trace
information. While the kernel already deduplicates stacks via
stackdepot, page_owner retrieves and stores full stack traces for
each page, only to deduplicate them again during post-processing.

Additionally, in NUMA-aware environments (e.g., DPDK-based cloud
deployments where QEMU processes are bound to specific NUMA nodes),
OOM events are often node-specific rather than system-wide.
Previously, page_owner could not filter by NUMA node, forcing users to
collect and analyze data for all nodes.</pre>
    </blockquote>
    <br>
    <pre class="moz-signature" cols="72">-- 
Cheers,
Harry / Hyeonggon</pre>
  </body>
  <lt-container></lt-container>
</html>

--------------J4Cjmrg0gCRpglcMOtKILyWJ--

