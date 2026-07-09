Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC67C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 21:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668496B0092; Thu,  9 Jul 2026 17:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F516B0095; Thu,  9 Jul 2026 17:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555FA6B0096; Thu,  9 Jul 2026 17:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB016B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:08:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE8431402AE
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:08:50 +0000 (UTC)
X-FDA: 84970477620.10.9568157
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf27.hostedemail.com (Postfix) with ESMTP id 65C0240004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:08:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EIBeEhe0;
	spf=pass (imf27.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783631328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/Yjl5ENjc8xyh0J+AjUg3HCsXpfLxkcN+l8HpgwHQI=;
	b=XP3jSotPCQljyuzEmTdmf9pO7sf510AUheobMW2H4oWNBI8rSFIfXjtoWfjYP+xamt0l1/
	Qc2lRul5Z2mvFeLi+i8MTr6bDUtUr3TEWvYCYXqWphW6isGwl3NU/hODYauVNoOrptqpXD
	6Gg8gjZMvgemDc2mr64NIxECjlsVGjA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EIBeEhe0;
	spf=pass (imf27.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783631328;
	b=uXcUxOgsggz1YYyHcuDbfNYaeaqJHY4+ywf5J/cGXV1zqm3R5eUPKlve+j5Zsgt9bR96+C
	v2gBAvGGNvATBxYgw2LQZBGz6wJnLOFaEe4KvX81UKXqVXlMmKG11oVcsBn9JHoPS9PHGq
	LVNufoGU/SEm+coBZ4ycuvjz3zpt7Hs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783631328; x=1815167328;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3SV4lrq6dVZ9n9ZqVkK5eNZjHSMb6uBLOemepmuqFw8=;
  b=EIBeEhe05c7TSEqbusDY7RMFOTuk3VT1hccoPBr3WCkoeJLpBPWMD7F8
   0uMzknyzuNuqu0H4gKOFNO1kvPwflFsQFy1VJ1qpoiwEw4/MIyfVeaZ1O
   c2SN1Xi1ZAgYm4a+JKi4gQMlwFFkUTzxy/M7hL4A6t47hkaHbir9oXuxE
   gt2keI0tEFRbwjVkN0aZcn745RDjZvITqgOVwFMsGwWzqfQuZl9opYk+y
   OIu/mDducrOZz7Ao1GedbWXVUJrYKIMEY+V51c1mK5p5cbsiUp5plDuLd
   lgCl38ibbnWc8LlnJ+aKfQk9d+b5EJXyw/jKUB69JS9r3wN03Y68Uvikv
   w==;
X-CSE-ConnectionGUID: 6v7hmjNRSYK6N+aoX+ahkw==
X-CSE-MsgGUID: 8K2/tDjPRcSouVol7o2U3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="71854509"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="71854509"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 14:08:47 -0700
X-CSE-ConnectionGUID: tylC+NrwTFaXq228GvGp9Q==
X-CSE-MsgGUID: XmQDIsM8ScqT30l8CVHh2g==
X-ExtLoop1: 1
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 14:08:44 -0700
Message-ID: <bdf0ca14-eec4-43b6-93aa-310e77660d95@intel.com>
Date: Thu, 9 Jul 2026 14:08:43 -0700
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 65C0240004
X-Stat-Signature: csosn3kshcskb53xqkhkweczddm5fpia
X-HE-Tag: 1783631328-970586
X-HE-Meta: U2FsdGVkX1+lhuxDos+D0jLNX2ZEKIZ93acD2j0Xi9EqDJX4seqRcJopJszTV2ngjeyJpJJFeLLadiNptFhUbpDpAmdNb46l/5z0bo7S+DVDxzgb+c9W14XjnnqCIcKIDt+/Rl7PtZteCJYp+Vn9e8XWLclpfpVpGKDgP/jQsJD9sqoNKBp5W/HCuKIZ5dobfQc++568+d6GISHGEZzPKP44NY1xpPljo+p2dd737C1YPR9TNMwIUkodptprGjVMK6gNKB58sZ4qkdYzCufe+xqTqtYtwwHfARTFbcrtWNuvQa0zn4Kv4idtXu/dxmTmmojKMN6iCfwfwiSfvlyeFyz8G3EPYJ/sehUy6byei7GRF4YB1Ug/5Nn6TK+kzBDZGR4+Tfsx5tDThBXg3U77Gp5H6H9h1AIstIJQzxYkiZgVYXtqV1CVoxGe5xfVqD1Dv6c8PeRchHIczLfqXacaj1h3EFdeB9CFGsegPkd3wPglv65k9+U/bQaCYoXvMUIDPvbPtITqkUwz47cNjNfu6QU5wco76kpI5GT9WxLJHTOlU++uJ8By+Yv5Wfh4BfLUlxvwqXCGeYvWsYFlrR3Rjzm5GhqNv60FIznqmUDgUDVKqjBIN1QItmolDPNIlL/jjjewG6NgMdxymsoB5gXzLSl+fI3yAdbP3EQgbcjCxci316XTp8EQbIsMYCFoxo5KO5tMWNc586LrJmZp+IQY0Ns10+zTyHgKtT7F4aiapS5XehGIwM8QgGmBNGZNS5Mq9aJMJFfN1TpMlJCbhDpm7XDUm6AjYEIc0stWo7SjGuFHi0r5MUCnvFNmtrbn6QqTm9QPx3agCvLskBLSJq4T30mF/qhiH+SHD7TSzylbtlK2Kbxfwp10xgl/+SzBoZ4SIJkIFBQIWPFTebasHBCKmt/eXnu8tub7tP2fZnAP7s/ZJRgs1PLcpCF9bK0eTQujO+1uwotIpv6BSpmUqn/
 RAY1EG8x
 xuhhmqpGTV/fEUwAt49IMa0TEElFbz8s/7DnwnTmM0bBOf3LjrmhXigVI9MxI+Xty+xsemVh16srAZKBDSqSGqyjBaCjjhDl+e/Ehdowe4+eF/fPAtg9c0Au+lo5cWR5U9WHGvHSI7hEp7PuTCQGQnek1/Yy1enM5HukYxsAE6lVThB897cl8YRLVLB4NXQpGWa84jMPW60m7ihUsvMSQHCIYgKqMtAAymKUqmMk3NOGcEmaihfZ01oTCEK8hajCd1DkTK/y6KgunlGt3/GR4qv7yWnt/rs81NKojhVktapW14n9ouDK+kuQSyLoVdduM9nTL9+Ox8fgnUcw2xaEgrgGvv4/fnQiQrw2Ha9JpT4tzAx6j0QCnB64zyYLHs4zD4/c4
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

Does this need to also be 'extern'?

DJ

>  
>  /* If movable_node boot option specified */
>  extern bool movable_node_enabled;


