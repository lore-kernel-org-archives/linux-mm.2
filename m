Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87815F34C5C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB07C6B0088; Mon, 13 Apr 2026 11:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87696B008A; Mon, 13 Apr 2026 11:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D3C6B0092; Mon, 13 Apr 2026 11:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC69A6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:21:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 677F2A5427
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:21:21 +0000 (UTC)
X-FDA: 84653896362.26.A75ECBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9DC9240002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:21:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M6z5tz8k;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776093679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZzuA0LtNPAg9xJHIemLOoyExiaAtI1G+8BkVeR5f48=;
	b=v1PZeqidWFHWVn+e83aONKtPqdPxhwDBOC33Wa5SdRawi8CXRkLrHeVPxiyT/QEnWxEGxF
	nrV8TjCWSAU6Xk5DJcu9EORHk161hYfSNLP6+NcUbF5uMMWG40Uv/h60HEg/U81teEhomI
	iKUlJIm2GMKv8kbEezNjinrr/c+IGrM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M6z5tz8k;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776093679; a=rsa-sha256;
	cv=none;
	b=OVh+QkRwj85DP5PGimab1JxT5Gv85iDFokgBKCPwELPHCP2Tzk393csNp1ld1EGnAloK46
	PaXaYZph32KngoMGr8U4lgKIeY6p00PzJ2BrWx6YTY50fixjKIqKuod1hbWxY7PV6qTvKH
	xcea/YHut+TBnRHF0SxuZrNhU3pdpwE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 168D760180;
	Mon, 13 Apr 2026 15:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EFBC2BCAF;
	Mon, 13 Apr 2026 15:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776093678;
	bh=0tDU+gJ0igRYGEMqvw+y8S5RV0mbZpxGXNcPCdzGa7M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M6z5tz8kY/PU01R6WlDxuIBLJ/bJKpoQAnN5/1qbP5spDN/iPHFfPzBLX8mkV9DDA
	 G3DkT5bVzg5U94Px2HUhWXhaFgUi7LQGLGjQ1MGNP2Hg7lQ00dASwHNXXyav63gc+O
	 QJw4wroV76SWun3igUHrJLnRhHd5ncUMOZRcUV7H57gEbsMQRAPHz0ozkufzm0xY7j
	 GLOQM9DkBLKmLeoBhWTfOczfcajffXg2kORKsS/ddCSJDfF4e+5gR9FvsqS1/3omX0
	 fLaDhmGnEfXD2Oms09iM24cDcFoNNVmfzLMASw49qqzsjfZ+0MssJoXaRE3ZQseoyK
	 oYUbhyfDTuhEA==
Message-ID: <dfb42983-e5b7-49cc-bfa3-7cd3d32c4a6d@kernel.org>
Date: Mon, 13 Apr 2026 17:21:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] mm/memory_hotplug: add __add_memory_driver_managed()
 with online_type arg
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 osalvador@suse.de
Cc: dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, kernel-team@meta.com
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321150404.3288786-6-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260321150404.3288786-6-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DC9240002
X-Stat-Signature: 5hp4rcsfure1hhiqk4jsofktbb4jsbt6
X-Rspamd-Server: rspam06
X-HE-Tag: 1776093679-186604
X-HE-Meta: U2FsdGVkX1+w3FA19mZlIejWjtMp7q7qb7t5TUEcya8wSI4vT0g1OnbThO65SuIs1NKJwWvY3XldM87FEIJ04o9iLiQ4l/yY63+rWIZwCN6jKSx9O+DjW0sJ0GxSBPp+Al4NWdZ7AeNZAiT5pPH+Yp8zQq+BVaLReUfEF0yp7jr/ZoeDhVzJV6T8aKiGz5YgG/fVVsPxDlmOgnRUMdcz2q8+UhwDAnJeHjkzb4wawSBLiFPYxj6Gup1fBx75wBPg+xBjvuELaamD1GjwZ6qo272+CHjcVoMisNGbN5nkmoxU+MC6OKjFwliaNp6Qf1WU3ocZmydzP3wkaNs340uxkwDEYODuAGA0TIQNJE2FYkAhuvGBDauNDRFbJTxrqinEuGg5ZEdZ7F79DC/fY3/GVgKX/F73zbs8Qy52mRXfiAXNReQ5UIIQmo2KJggX77qKfTxcYn4Y1RddMs6laSdh/s159ABIN49/L0DMsctxuamzT0cKKDnzxSL7dAORDHhg/2E9JK5J8WLLBX9XLvX30vy83QJTVPous/1kyaao4LqxexJd7Y8apc2hNLGUJtiW3rNpypl5j6cr9PPzLiAYgg7DVXNbWCzNxenbkvS8hn09B48yRcv3Nnm9W1hV4JqDKFCOSZohlxyH5l9C805eLO4u0/pH08nH2/cg0+aLx4PD/alH+XcEFWaCA7f+wq5BGCGeNatxJcRsd/TtaWLuxDoorK5oDQfBGXNM3yRojDOgd3M/coH4jD5N6Pdnaooxdrk8pqtWy6iLnAgXueFFHHtff3hnlwB8Z+E0jkVcXK8hogJzueTVGwSNtu4VG1VQs6+W6JbDtrRltXnzZ7s2jh2HUIQSZNXtxYado+15FYPTi7CeLVZCv57Max2VcKc9jq9qoFm6jeUcQz0zVKEFZFS8MYs9l5KZDg/M0Ogku108VXyNawlXqGNmZYV5cM/3Jx3aAfAaBIBQq7qpMRQ
 hQnQeyGx
 fIBsRLLI50DPjaurWyttXV5w2oXRSekxALDGdgae/EsQzDagW9jVsMGwpbamNCRGaVpu1KNf4a0PXqwm9yd+GrPvTVlMSEFVPVqG5TC8EL+CSaC6YbJKEKNZG5QJtfRxHkJLe6Xb4OJOOW5BmLNXAPUr+qgkYnSSxLhwQ9hWl/PTJTbbsPcY37Hul9CdP7x5JFssnrfCuNHJJWwf2dBAARSYwo0WAuUlcHfgU523jEAtY8dzLh68yndAWnUsZukOOtJgCz04NpU3Lxd2NfIlvUXKCBbzTwY2hmfNOYoB31yIWTvZ6pkQhFOryDNB3r0JkIv4h/E67o9sDFZ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/21/26 16:04, Gregory Price wrote:
> Existing callers of add_memory_driver_managed cannot select the
> preferred online type (ZONE_NORMAL vs ZONE_MOVABLE), requiring it to
> hot-add memory as offline blocks, and then follow up by onlining each
> memory block individually.
> 
> Most drivers prefer the system default, but the CXL driver wants to
> plumb a preferred policy through the dax kmem driver.
> 
> Refactor APIs to add a new interface which allows the dax kmem and
> cxl_core modules to select a preferred policy.  Only expose this
> interface to those modules to avoid confusion among existing API users
> and to limit usage in out-of-tree modules.
> 
> Refactor add_memory_driver_managed, extract __add_memory_driver_managed
> - Add proper kernel-doc for add_memory_driver_managed while refactoring
> - New helper accepts an explicit online_type.
> - New help validates online_type is between OFFLINE and ONLINE_MOVABLE
> 
> Refactor: add_memory_resource, extract __add_memory_resource
> - new helper accepts an explicit online_type
> 
> Original APIs now explicitly pass the system-default to new helpers.
> 
> No functional change for existing users.
> 

You should add here, that we only allow known in-tree modules to
overwrite the onlining policy (where we know that it's a different
user-requested policy), as we don't want arbitrary OOT drivers to
overwrite the configured system policy.

Therefore EXPORT_SYMBOL_FOR_MODULES().

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

