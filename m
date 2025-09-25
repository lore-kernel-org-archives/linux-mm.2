Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C04A4CAC5B5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 22:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117E88E0003; Thu, 25 Sep 2025 18:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9578E0001; Thu, 25 Sep 2025 18:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20AD8E0003; Thu, 25 Sep 2025 18:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E31C68E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:26:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DD421DFE02
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:26:14 +0000 (UTC)
X-FDA: 83929207068.19.39B69A6
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2C542180008
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:26:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=GXdEBbxB;
	spf=pass (imf06.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758839172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYqXCwQWRl1v5mvc0PqGxp32U7oTfoGl3dZTYyV2InM=;
	b=TTPk66OHmMLXusSTghOixfyzFrbVplAQdsFBShI+KHqvOQ4pAf3JyNvU+zC316kpdqfS/F
	7BKphv4wACNIQE/ZMA4FtuT9qytcEcdlH7CyuRL5JmrNf/oY9KB6VE4A4qy/1GIJNL7OHo
	Ik3y4QSSli2qTrGYOhfohf0Fu4Q88Zg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758839172; a=rsa-sha256;
	cv=none;
	b=bmpTvhkPJIfObfmptwIMRoyNoAo5F2AKtE6+EQGQQqfxkhPshLROlCwZgiSwQAQBmq+8Nd
	P5oBaGRs9Yj5DtiQb1RmDaq+VhzehaxTbN9PTIyiUWNYWp7E9yG0rZXldIaVHx4uf/yI4O
	yQYt3xAPGLavKXnMiqgtKe7u6mr6Sdg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=GXdEBbxB;
	spf=pass (imf06.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
	In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YYqXCwQWRl1v5mvc0PqGxp32U7oTfoGl3dZTYyV2InM=; b=GXdEBbxBNwjLB0z/eTfkbQ92sO
	uPDNPCJ+qJP8BT9qX5RTyBSWDT3M87lQlTUrRDh5G8SunIxNw1CBNq37Zb1kXuxwqS6A/raQtuzd6
	3mCr7BOSgputcxoch3j27pFdAA7IRDGotL5aJrZ81L6qfZnwFwr0AXWU4qfIvhFPvAR2+3GstJzLE
	bh8JbmLctN/rgjSbRNaz4Ja0GbUjN3LeUh17EeuufiNMM7eYHhcUGCvzBSXsH3UaaDutzLo/6oVmv
	gJX3wV4XDBpMl/7bdIxaomtxuw68Yr2qCYktIpQO4urdq1+pmPWpwHvSB/uX+s18t4pI6Ttn6Vvs+
	EZh7r+LQ==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v1uPZ-000LnT-JT; Fri, 26 Sep 2025 00:26:01 +0200
Received: from webmail.service.igalia.com ([192.168.21.45])
	by mail.igalia.com with esmtp (Exim)
	id 1v1uPX-00ENcu-H2; Fri, 26 Sep 2025 00:26:01 +0200
Received: from localhost ([127.0.0.1] helo=webmail.igalia.com)
	by webmail with esmtp (Exim 4.96)
	(envelope-from <mfo@igalia.com>)
	id 1v1uPW-00BoW8-32;
	Fri, 26 Sep 2025 00:25:59 +0200
MIME-Version: 1.0
Date: Thu, 25 Sep 2025 19:25:59 -0300
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
 <vbabka@suse.cz>, Oscar Salvador <osalvador@suse.de>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-dev@igalia.com
Subject: Re: [PATCH 1/3] mm/page_owner: add option 'print_handle' for
 'show_stacks'
In-Reply-To: <20250925202817.795114-1-joshua.hahnjy@gmail.com>
References: <20250925202817.795114-1-joshua.hahnjy@gmail.com>
Message-ID: <d05a76ffe2969b8542db961ef1f41a0e@igalia.com>
X-Sender: mfo@igalia.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2C542180008
X-Stat-Signature: dhwnuef4wdcs17byniwxxuo4m7cycufu
X-Rspam-User: 
X-HE-Tag: 1758839171-350040
X-HE-Meta: U2FsdGVkX195gsJN1+Dkc1ZioTlSaMOiUROAwmQvOstP7YcgqAm+sxH24YMsr7h/htErjNMtYDXmGujl2pCkKGZvVQz7lvlPFKdeiqvr67zRsmm6O9HUkot9BNw+SLoXKuDQHVMD4FijVJVD+KPtfIrt6GB6TBv6v3MmvkEyHb6cgXvF8VS90HhuonB3qOJ6pVBKXmkZ84P+X7Bg5xVh1giUfEfjnFuFLwoek3oihECUy5cjAYYYWEPprpyCft0ILiU0dEbYjYGZNdLgMoryQJnr+qWcn9sl5XCIPQ8k1PNPM3su+s5A4d9LvOMuKKTXtvi2DJlcu6SqcXSGa2eNW3Ea+TO0Fztz//g28dGt4Kfh5dAzI5Ihp29LJuHhcjkh2ItthxVRqsbrriwmSqCvHGkwBNDRa4bpGTo1P23CS2X/Rh/RVZU3LGDkh3Fr4GzVMehC9p5TdpR+VNQ4lSZVlIbccA6zuqqi0pvd9Bo90YisX7/cZTESGeEsNrn3uvZzDcuaJadZFoIoA/Epdy10SU8NR4CFOwZeREHaTm7uy4CThLS+EZ6cMpgo6hTscqUMdL6HW0ZVY152Oh4jDsIdgqc0Kq4Uq8L+YkmkzQiHnQjVvZGDyhBVyMcXqZsc6itl8kGA5644B2kbZO9RAQfdv4p7s9eAcW3hetdJvPR9r/wVZrppL29qY/0gcxIJmm5FcphntYkzmPISxUp/Vz+HCgUbuEQWe0LfQm2xlJNn9F3hlWOv9AZY523bJslTXdQG76Er5c0Yb4BDgoEBgg+iS9DtPEvoAwzqSho1mU5pcFBNMJ5S8PHzLKSp2SMNX1SxDmF/1aE7vD45Ty9e4YvJXAEzWiMT/JSIj9CZo98wJfObjmraJ0bGOU+XM7AsZvJelipldIChRwhrvyzIFY33r7stJn8OPL7VYW/T4G0J2XNrJXDqPQAuLvvq5L1jJUgWnCeWp65xXj6nStLkub0
 lpVn2AIB
 V40jiT4X/Wk53cor0ACdV1Ez9h9ZaNsfYqc02fD55Qs1lGw3tej5Fblx8Vl6mbVWFeVXV+QNUq9r3cYgP43NZdFhShKyo22lwf6ghKWTz3za6SDs/h+xEkp/Hm0eZCDKqAzoSAxvy+ORwde5IElI61Pj3zlXRQXzUQI9ruiF8j3jMj+fCXVpUSABy/GoafRyrQT9/vNtvOQqreGgVYaTnz/xmZ/CYMMZ7ueTMFz9xy5AwqBUmGLdG1JP22W4SVbhhRrVvXW8d8TteJwklC7VstmcFkEwC7yrL7IUZ7G67sXh8u2kxNU0Z7ZMddJyZmXeCtOXJaIXzPxgdl8XNhR+Gq0+cQjhN+fj6zx2NhxrTwefTefNziZBgzFSSs5z8AhWcSu5wGNCcvIVVX4ct1NCmAJsHeFzGer3aRLsm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-25 17:28, Joshua Hahn wrote:
> On Wed, 24 Sep 2025 14:40:21 -0300 Mauricio Faria de Oliveira <mfo@igalia.com> wrote:
> 
>> For monitoring the memory usage per stack trace, it is more efficient to
>> use the handle number as unique identifier of a stack trace than to, for
>> example, read/hash all stack traces to uniquely identify them everytime.
>> 
>> The handle number is a unique identifier for stack traces in stackdepot.
>> 
>> This patch adds the option 'print_handle' to print the handle number of
>> stack traces in 'show_stacks'.
> 
>> @@ -887,6 +887,7 @@ static void *stack_next(struct seq_file *m, void *v, loff_t *ppos)
>>  }
>>  
>>  static unsigned long page_owner_pages_threshold;
>> +static bool page_owner_print_handle;
> 
> Hi Mauricio,
> 
> Quick nit -- If I understand your cover letter correctly, you want
> page_owner_print_handle to be false by default, should we initialize this
> to false?

Hey Joshua,

In this case, it is not needed, as static variables don't need to be
initialized to false/0. This is handled as an error in checkpatch.pl,
so it should not be added even for completeness.

Thanks for checking this.

-- 
Mauricio

