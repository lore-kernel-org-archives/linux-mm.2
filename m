Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69AF3F364AF
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 20:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7C356B0089; Thu,  9 Apr 2026 16:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53E96B008A; Thu,  9 Apr 2026 16:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A106B008C; Thu,  9 Apr 2026 16:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA3EF6B0089
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:10:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D2621401FA
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:10:53 +0000 (UTC)
X-FDA: 84640110786.26.C9B46EA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id D5A09120007
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:10:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fsIhYY13;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775765451; a=rsa-sha256;
	cv=none;
	b=yGcFwnecjC6kZJNFcDAOM7299KBnIK94xd+D5Ro/sPLtsftAL7p9/PgHxP8PV+WzixWK70
	RoOwo6NvMSsf4jUt1+vcc4KNq9MDGPmJrrUS/c8N41eqiu/SCV7CbSFsDaaKaS2SIJAW1/
	S9A7WPJpuIVin/pBO9mFrrUvwo/GCyk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775765451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0mMDlLf0uFNcpYQrMCqmSXlOT7ksq+zKYYwBp0B3zE=;
	b=pVDS+OS2G41j2kwhCrYku+tqLTyW454f6ZRer1jydKHPuvWOQZV/UG4oDXTdiJ9s4016uD
	SVal/xoKFfxKzjbxGicQ4CcjOZT677jBmUl7Tea10gN+orLUdH1fHnMU+q1MEtcBYoUgeR
	dpG0Ichy/EIXSVzzd+iO7NR9C+M1cUc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fsIhYY13;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775765451; x=1807301451;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1CIaqHPQuaMkKF4qjpoqSpX+p88EQrJzNeqC9q/4T8Q=;
  b=fsIhYY13Mp7XtGABPqvYyaS2FRx22H7X5uuZPxR8G3JSDjj+RMZYZtTP
   QiNCLpAlh172pKKv72Tq60/JNd+CFJIn31HM5B3Iug/VPba3w5Ab+R2A5
   7D0GebK3/GD16g+G0Mc7UBzU/SGdLiPynyRaT8U92WCzOqwBpHEpwgDON
   xWdurlJjixbHXzDsuRqZUaUH36yrkybD0+HtpCJkMbCyPIWwkVz1g2ItO
   eUmPwgy1soTXZgJw8UFa1Uu52uVA02nFm2J2/sY71Qq+5E8etpTRP7ynH
   QDJsoo/OhUY52oHOc+8Nzs7ETF0ByC/wE1DKmOzCLvD8gVNftrDPRHnJ2
   Q==;
X-CSE-ConnectionGUID: 5rExiQzFQPC/MSnLua8H8Q==
X-CSE-MsgGUID: 0hMuMMASRVKmVOlLQDltKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11754"; a="76800909"
X-IronPort-AV: E=Sophos;i="6.23,170,1770624000"; 
   d="scan'208";a="76800909"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2026 13:10:50 -0700
X-CSE-ConnectionGUID: afiw+rXDTcCnMhPvEjc1ZA==
X-CSE-MsgGUID: Rht8fcv0SEyBGnk6fJ4FFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,170,1770624000"; 
   d="scan'208";a="266847968"
Received: from ray2.jf.intel.com (HELO [10.24.81.183]) ([10.24.81.183])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2026 13:10:49 -0700
Message-ID: <631bceef-d32b-475f-9d1a-644593aceddc@intel.com>
Date: Thu, 9 Apr 2026 13:10:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/10] mm: thp: x86: cleanup PSE feature bit usage
To: Zi Yan <ziy@nvidia.com>, Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>
References: <cover.1775679721.git.luizcap@redhat.com>
 <16fe2db0becab98db70f53e4ce1422450a9f40ee.1775679721.git.luizcap@redhat.com>
 <F9F90195-D89C-4DBF-BDFC-311A32D00B9D@nvidia.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <F9F90195-D89C-4DBF-BDFC-311A32D00B9D@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D5A09120007
X-Stat-Signature: 6k1md9ma9adsk33cj73j74bryrh457qf
X-HE-Tag: 1775765450-335818
X-HE-Meta: U2FsdGVkX1+v8JDVpUxH9R5OnSKbpyYZcCseIRs7g+utaXfdsQQ1FVP83BqAjmFdkT02nSkpkIUv6fq79jhY0OgdKNKeWbmYgLj+tUndFB/CUBTvxWOwo8SQZQY7kYnh4PubqAXQM1yrFcqvRdbAqezHBX2TmJ+TEQo7mRaSiLlc1cqP9+xAmW3+pB0p+oviT/2AWNy4qgy0YrndgrY7pLMtaWCZOFuqSLSS7W884jQSBq9uZ8EzcYPGmI+BkJtPsqdtDYrDLrgwXg8E9u6Skgus8AChgP9ko2ZfdaiCiD1h7Cr4viXMwUBJCwFvTcfivcvvU2TEcPN7mBRllP+cHAQY5zhy9wzbqAcG8lDOtU2HulTe5p99PWRi9mVCiXIXWwjGRKmx1oICVj1JbPBQTFTrFexJ9P5oJL84CcrrItnEVc5TCE8Peca1hcbKJmYtz6fFk5qbcR/JZUDKVcuora0PucGlcw0KEDYYYcmG9s1WFX0jMdxdOtcb9iNCLkCgLNIJ5uR18N5z7HuyYFZ3yLLCB5GJ8t8oWT6DLqxVYmdB7EQ9q+hOcMR8oe4xGLj9VIF26uIol/3wUdabslSn0t5q++hae6XdXTTAJ7bBqMdDk6M8rE5mdOEwwXApxscYIMz0X8biC5dwNKzEjKsP4iWV1zdxwOr+ST0c7hUH05nA+0JwRn5cMfYd4Ve/XhmjlHa7mmDxHAT+BZEwFzVTd7xee/QTPMrsRfpTq3kn8NF6cpM0+6zIwAMOCBjkaYEXSlK4A8ToPeclZSiPs2MjYrk1HBibURIx+EYtAy5QX9VBKL9C0X5upEHL8QWK6wirHpcYOT7KG30uIsVQjMbAY113OgVwenxmXmDP40/4uJ1LJzdtwqTXyCaJo7MoyyKe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 08:57, Zi Yan wrote:
> Historically, THP support on x86 checked the PSE feature bit to enable
> THP. On 64-bit, this check is redundant since PSE is always enabled by
> default for compatibility.

What do you mean by "PSE is always enabled by default"?

A hypervisor is completely free to not enumerate PSE support to a guest.
Any kernel can disable PSE with clearcpuid=3 on the command-line. PSE is
also disabled for at least one erratum (which I think includes some
64-bit CPUs).

Here's a snippet in a 64-bit VM of /proc/cpuinfo on a normal boot:

DirectMap4k:       83836 kB
DirectMap2M:     1939456 kB
DirectMap1G:     1048576 kB

and with clearcpuid=3:

DirectMap4k:     3071868 kB
DirectMap2M:           0 kB

Just to show that it's possible.

So perhaps I'm reading into the changelog too much, but this doesn't
quite seem right to me.

