Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55170CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155CF6B009B; Thu, 25 Jun 2026 06:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A066B009D; Thu, 25 Jun 2026 06:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043646B00A1; Thu, 25 Jun 2026 06:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3C656B009B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:06:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6939140660
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:06:41 +0000 (UTC)
X-FDA: 84918005802.21.045A44D
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id DBB6F140002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:06:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VSassdhd;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782381999;
	b=S/g6XdP0/O5iuViRoTAdhq26G5+rjV/6vDlQfWlaGHH7hUmvfjDw4T5s2cuwDDmoR6MwK0
	wb476CHS9jKBtSrinKuOpDGeh3EFOSHwNOmlT+Q7mwdDAc18iMWgYdTeLAIG992ZG/o1YP
	VUpltjU6ZcFf26/EZ5bp1cVHVQm3rv0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782381999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWbZwk6nLyJmAjVVXNOjovGBWPmjhIM8DxEL4Q+fXdM=;
	b=hAjmZonxFszlgFj/gg3DixjvolmZJ/kNsqJsGW1Avc9kuJ53Jf4AN8fzxGsZ67Ii3YPcvD
	5kzs3F6Ig+o3IDq6S83djA5Qvz5eOx05SaHylrUfPXAK8s3itCt+fNxfw/X32QybCySZJs
	JT2EyaOarvZ4BIKKfcZx3IiNtftkKGs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VSassdhd;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <349795fa-79c4-4b52-af2d-293138fba4e0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782381995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWbZwk6nLyJmAjVVXNOjovGBWPmjhIM8DxEL4Q+fXdM=;
	b=VSassdhdo9VpoSveN5qZAucMqvhSECqhAg5f9HlNeegFbPE0T4mK47n9iMb2+Ows0FNStK
	Z1MlESkorg3vaF1eG99y7b7uzVMqbM6RigrW+nohma951GXy9Ln9TLIcqyv0k9A7Xh86WK
	3OB89JPjqP7ijJ5vZVir0F2eHc2x4Fw=
Date: Thu, 25 Jun 2026 11:06:06 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] mm/vmpressure: split v1 userspace eventfd code into
 vmpressure-v1.c
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org,
 shakeel.butt@linux.dev, roman.gushchin@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org, kernel-team@meta.com
References: <20260606114158.3126210-1-usama.arif@linux.dev>
 <20260606114158.3126210-3-usama.arif@linux.dev>
 <ajzsE9WMl84MeBOr@localhost.localdomain>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ajzsE9WMl84MeBOr@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4afwsednhs134rbo1173bowkxkc356x1
X-Rspamd-Queue-Id: DBB6F140002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782381997-552801
X-HE-Meta: U2FsdGVkX18xvsDFPObi22ckE0axmZIROyBIEauGrkdWXa0cR/ZQvcube1p+VtWMS8aQzKhU3N+DNs3oFJgv20s4eL9uI3H+d+Bx0Jlx4QoX7lErhglRfNIhc/DPWx/VKu4R6aoT2kUqGWltF+TjKUGQhRvNa2UZzt/dBO94/SQ4VOYVZfZLu5zPljBdLBTME6ieCA6r/B1URds4weVcQJ8PallTNnl6WDCD1wM6cIGpE+O9rP4jMRVTmOHewfqOYq6MSbUS1mm5WTLXxyoKWB00s49I00cyLxMfQNGpSu64XSVw++VucMsDoLRwdKYof9ccoULbRRD4NsH/7PWYwHFQEvJ9LZIIeKTvBg8LBEla7QXOYnwVw2PNhyixYTR06DkUBcz0KarpQi2cLROlhakAa2cSVSJm3tNClts2DrjMdOv27BavgQvJ4FhhDZkzj17MLpAHqLUUW5gHwvOG+6unLdA37HAzqUfWmUZqzBk72eMhJsDe+Uiap9h+hVi3sx95MlA3MBre3XHPfa4bBdT09xONabzuy412OUXLvPCDoq/ucQRPWDwtkCc3Zn8uFSip5zAU2eHS+/lIXnCKoY4sizROunz2MZ/yksQbkiIXIR0TPn8+6WSF/Xp0AhJ9H6gsFtePEZam/P7uuLNROEpqkJP0DPmH04TPeFiSRPoJP1w5YAF+TXtH3Mxy0IsQBXm3an8pjHEdL4iZ+QbSstQEPxhBRrVShRwkhkdjW1V1TVoRcTz7B0yh7UEzvA37gbb/Ahw3AlqxyiA0FMg9RYjxmkzkJKBeX4K9pvfV6k3/r6f2JNKGbAauJ2zbLjmHyVHV6otEMmg6DEKSka/JKt8oMXZOhzHb94mrP92BDF0ErYUOQ3kqwnUdX/aUI6i5P04hZjJCDy0bps/NUKoKoq+hkRHdbreKPmCKTZ72KttA7fvhPf5vhnjt4QS2gVqS9BaJoVotnqfarIy7G6r
 +JELJHEG
 fc9S6xyxt/0cbp8VgO1ojZisxQarEj7hVEJTuS9eIc+cHycec4ng1ohqRbt4VZqDTlIcC6ITykTsUvgyZO1rO/2+RkCEbvmxVCbnQBuHGepjHRnXqW8d1HohEwHQOXg+E+m707O7oWkK7P99NdGKeSi0vQBJCL38w9tpdozRe8baD8P6+g8RgLSlPrEud/izblPh76YHdgzzN+euFH5CZSrtrwYtdWr4jOy8gB4Ai3qiZD4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/06/2026 10:00, Michal Koutný wrote:
> On Sat, Jun 06, 2026 at 04:41:34AM -0700, Usama Arif <usama.arif@linux.dev> wrote:
>> Clean up mm/vmpressure.c by separating the cgroup v1 userspace eventfd
>> interface from the shared and v2 in-kernel code.
>>
>> Currently, almost half of mm/vmpressure.c exists to serve tree=true:
>> struct vmpressure_event, the events list and its mutex, the work_struct
>> and vmpressure_work_fn that drains tree_scanned/tree_reclaimed, the
>> parent walk, vmpressure_event(), vmpressure_register_event(),
>> vmpressure_unregister_event(), and vmpressure_prio() (which always
>> calls vmpressure() with tree=true).
>>
>> Move it all into a new mm/vmpressure-v1.c built only when
>> CONFIG_MEMCG_V1=y (following the existing memcontrol-v1.o pattern).
> 
> Thanks for this dissection.
> 
>> @@ -283,14 +152,8 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
>>  		return;
>>  
>>  	if (tree) {
>> -		spin_lock(&vmpr->sr_lock);
>> -		scanned = vmpr->tree_scanned += scanned;
>> -		vmpr->tree_reclaimed += reclaimed;
>> -		spin_unlock(&vmpr->sr_lock);
>> -
>> -		if (scanned < vmpressure_win)
>> -			return;
>> -		schedule_work(&vmpr->work);
>> +		vmpressure_v1_account_tree(vmpr, scanned, reclaimed);
>> +		return;
>>  	} else {
>>  		enum vmpressure_levels level;
>>  
> 
> This return; looks weird, I'd either
> a) drop it or 
> b) keep it + de-indent the rest of the vmpressure().

Thanks! Will do.

