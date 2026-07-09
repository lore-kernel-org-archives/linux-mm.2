Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5921FC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 362B76B008A; Thu,  9 Jul 2026 13:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A226B0096; Thu,  9 Jul 2026 13:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22A326B009D; Thu,  9 Jul 2026 13:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF6216B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:59:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C2FB1C8055
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:59:23 +0000 (UTC)
X-FDA: 84970000206.09.4426F76
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf10.hostedemail.com (Postfix) with ESMTP id 93DA0C000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:59:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="U6MD/U0F";
	spf=pass (imf10.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783619961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKulFEz9cdUWQhxpyyaYh0WtUQAdFTZfh6V2ogl2tHs=;
	b=5z9+/1SExIBOA1Hp1tMqNVOkh49Q0/ZIPdS49VOT7qgnMqU0SvvL62Y7pztdCosnG4gfG+
	ZGXoFrX57aQ8ISI4BXUMsjgCoDXTGpIsu8HUUi+1B9fyjSDpceRqLxsv/eGS61qRfDMzTL
	OuLaNV2pEZPQcf0UekVwezS/lTkLXZ0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="U6MD/U0F";
	spf=pass (imf10.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783619961;
	b=BR5xsHjomgbckdOHkT8U1MKv/SO1Ya8iHYQmNgAEOH74laYBocBNGvBpocmmfYzqBKyI7q
	2cRWUo6yvUFXFk35/UHGG/0hTh3rUnbjZJCBkvEbYZyliDdgAZq71UklBUqHc+r4VjlH1l
	nSuZ7dFYzsCG+p9QgGyGc3wcCyShkFA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783619960; x=1815155960;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IeL1oxUC9sGqcnSkpWpKrEd+SnQglbBpUQgEgR4fVhc=;
  b=U6MD/U0F7Xb7wqiBtg+q9yO7uDjuU23dArzMyCtzO4bsL8rWyrIAtQya
   4p7KyG9G9SaeGJCIdJhgqBdvFSNaZp8gqoTypgrHIGzp6rrIC5jHBk+9S
   Q+yp+LLUNrkLGcdeNAS2lZaFXJF5QorcYd3ZS9jci4Y4oAHhsnWLxespa
   wLp3V0szug3T7euzxEZAzePfGIJ7OS3qMxxLwvI3XdBC2T7JaAPIclgZ0
   Y6Si2aypAMCCrBH6tQ+WmcxqJnZvVMiYoWUVrQ9KiNLdFgwxme2IJ/IWq
   bhil7uvWkpL0PgDbEzsxL9QpNdmxHa+EGwQg5KXYFIIR6Lsm5i8fJ+hgt
   A==;
X-CSE-ConnectionGUID: 3PTagjejRZq3DB0PbYPDEw==
X-CSE-MsgGUID: /VyeAvzdRE2NGjLBFK6yPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88139730"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88139730"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 10:59:06 -0700
X-CSE-ConnectionGUID: NTSX3/2GQH6HiLFnWbczgA==
X-CSE-MsgGUID: ot/6hvFVQieZNeL412g8ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252920873"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 10:59:05 -0700
Message-ID: <f8005e88-51d9-4cc4-8a7e-596347de5d84@intel.com>
Date: Thu, 9 Jul 2026 10:59:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/10] mm/memory_hotplug: add mhp_online_type_to_str()
 and export string helpers
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-3-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 93DA0C000A
X-Stat-Signature: du46qy9txfzzkygzz54j5aoqqkwuxp4d
X-HE-Tag: 1783619960-544632
X-HE-Meta: U2FsdGVkX1+85Ii4scX6ruO/MRtalyz6hyKZhPjUecpSQ1NrJYAyTEn9+5vOSuzQVAPCSNBjgVFIoRXIqtBGZ9Yfhx61fW2PVr/eJ/KmxMJa6/g1TEqAvlmAtMjikfg7yt58jxYpXtlpAztnSpDpEG7bvhxjfzYDQJGOQISyyRERk44umKSP2m5wV4SMh+oVOWKirHoTXh5S5SYMjiJtZ5mnERP3KwYwq+M7XBcIJolYOrJav9kZFnzwQKFDmc745BFNmlcakYUsG0OChSiwWGg1oKqiiA6U851Kp/XNNfESRic0OGuzjAJaG+wu6ZtLGwUOelB3LJJ7uCNKu8UsF9AxGSaG3TGkyeWLpA6K+QjWMraU0Eg3S2iOlsqML6IbCT25bwxCbLJpLF+yc5CnkJSa41L0PPw2DUVeww7yJcHGnUTDuAe6blCnOdDoo740DjmisORDtet9W+EppfVYSiom0RIaM4YCttHKJjoIAA+C5sm3kAJxCksaGaZ1T0hTAgMr0vht19E86e1PXXRPvqzgDnUPayZE6q+gcbRigEroLZRjFbYK46npMMHX2CHy2OKT0Um+cfrQCZinq19lxTsOeSbdrSRI8gLnuJC93RxrM+bSMWcHqt2FkemjUN1AHXbSkrJ39gPz+E1jxbgZUn+9VLmDpHhgVS1RTJaPsoGgiGNr9b8JIuowFNfZ7CXDFtdCiy7gLB1QH2EnBJnTKtBewq6pohDm/WivdAN94aFSK7NeaanNyiwRBK+E3yvTElQGHMpaPo5Sze+MhT8He3UQQTCmNbQUvwsPNPFZ+7+EJTfrSKbPpTeh6dBGX6SqMQtntB0XzaNgpK+9LC4N5etBiMdgDGafdia2LUKOZFJaLWICaJ9+mHVH1oFC5ERrZIkksv2U7KHnpeML2gmGxBAa0pKJb3/0P+HNKaPMf/lrYC78INTbc0phZbLu+EDd51U7ZCXXiw/2XIZs5Hg
 njcSEPyb
 eRudrBcMiaPnH7vqa5sfKTabUFjVT2K8un/hPcJSONJmcSvD828ry5B2S9auU0VBvU+ScNk8SzEoFZ4p843IWOSzThhIcXItsYnGH4u5WUV9kDcKAE3ddI8IDs/yL2gaTC0LvUhESsK930utViige95bxlyMeJ3ILLD6F9umWEFcBJY3vRUdO6B1uqApvy9jojPU943LUTntgxRZBWwjJA509DezTBKg7ziAKkxCmEqFtYv1lu99KLdydUpennRpySoioeBhToeIgRCjmmRCnbQ109wfHc0ZrlUxoUtMtrK8EzN8ufxUiDJUqkyu3Cwaa0x+mRa4zTgqMiNp9Zj8k1E+VrqHfD5Z0G5iSJPH+nU2+RLbkg8Ji572ug5NjcBXQLgEapG4PmGx2Sehd2VBzevFVBhEZX5apgJkx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/26 2:18 PM, Gregory Price wrote:
> Add mhp_online_type_to_str() as the inverse of mhp_online_type_from_str(),
> and export both so a driver can render and parse the memory online type
> through its own sysfs interface.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/base/memory.c          | 9 +++++++++
>  include/linux/memory_hotplug.h | 1 +
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index b318344426fa..3a2f69d3af7b 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -46,6 +46,15 @@ int mhp_online_type_from_str(const char *str)
>  	}
>  	return -EINVAL;
>  }
> +EXPORT_SYMBOL_GPL(mhp_online_type_from_str);
> +
> +const char *mhp_online_type_to_str(int online_type)
> +{
> +	if (online_type < 0 || online_type >= (int)ARRAY_SIZE(online_type_to_str))
> +		return NULL;
> +	return online_type_to_str[online_type];
> +}
> +EXPORT_SYMBOL_GPL(mhp_online_type_to_str);
>  
>  #define to_memory_block(dev) container_of(dev, struct memory_block, dev)
>  
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 7c9d66729c60..5d4b628c4a1f 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -127,6 +127,7 @@ extern int arch_add_memory(int nid, u64 start, u64 size,
>  extern u64 max_mem_size;
>  
>  extern int mhp_online_type_from_str(const char *str);
> +const char *mhp_online_type_to_str(int online_type);
>  
>  /* If movable_node boot option specified */
>  extern bool movable_node_enabled;


