Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0455C6369F
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 13:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776506B0088; Sun, 22 Feb 2026 08:58:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7240F6B0089; Sun, 22 Feb 2026 08:58:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6300F6B008A; Sun, 22 Feb 2026 08:58:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4326B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:58:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8C3D8C159
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 13:58:42 +0000 (UTC)
X-FDA: 84472248084.07.86699B2
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id EC44FA0009
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 13:58:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=UpWN701j;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771768721; a=rsa-sha256;
	cv=none;
	b=533BWD5uZ0uFveD4YbEszN7XTwwDJwUVqZBGraQAQijOH4JwMeYuV2sQGvMVojrg978F6r
	xry5RkRBsLXhpDz6jcIqPFBGyzAevG6AJkOpuNwtQHV5pcfeWsytcTh6f1cPMrY46Sx0YY
	GSysFnEroATtzzFWH/OLhUw1iKo/3v8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=UpWN701j;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771768721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJM8LbZ9bgwxU0IPPgSVzAbIOKSeYTx/H0HDf7oWGDc=;
	b=Bv7SnKrn9lF+uVBrNp7/MsoNEM3O6RyDWLSl2qKOKMl/a4v2kE/ezmUaEYzEGvgebxyR31
	GoAKX8+A9pe7M3VWLoP2dK0veXgO2/LI4g4HFBHd4p7E/wZKkFmkMVYWdPm4cREqwgoSfA
	4HOPoN3yYw0eVN3SE4oTH9QWSKrYtq4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CJM8LbZ9bgwxU0IPPgSVzAbIOKSeYTx/H0HDf7oWGDc=; b=UpWN701jvBOcd1H5YT1Hon1mag
	+u6dLOZCSNU1dEsozENuQalcFQfVXhQsvI+XuRz9733nLjSXr0lKST4ANJy034Mni5GVzEluADn5K
	zyWbeGaVBTQ5naFbiHXMLmi0OzaBF+Uf32bwftolJooOQWQH6KNJI9uZzWQNwNyOhWXaWbHF8WGGN
	SR1nJdVHanoMYJ1RK46eALilvlQvNhrMfv2lcawVEbHSnjrdQ9AYPOvsjBuHaVu9Me9GUB3dMuJaQ
	YTRoltieWJayWzGLRzOML/IU9PwsE4fZHkhaRdbc9IU/cIDC+n6SD2lMZEm0oPFUyVnfTjFm8E6y2
	k5zXlECA==;
Received: from [177.83.214.207] (helo=[192.168.0.51])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1vu9yk-003oBA-7Z; Sun, 22 Feb 2026 14:58:34 +0100
Message-ID: <20e28221-f9c7-47c0-43fa-72bb2e868386@igalia.com>
Date: Sun, 22 Feb 2026 10:58:27 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 2/2] mm/memblock: Add reserve_mem debugfs info
Content-Language: en-US
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-dev@igalia.com,
 kernel@gpiccoli.net, Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>
References: <20260217195816.861684-1-gpiccoli@igalia.com>
 <20260217195816.861684-3-gpiccoli@igalia.com> <aZlyVHwUdxg5WZBe@kernel.org>
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <aZlyVHwUdxg5WZBe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: du3ck3dpuy33ibo636oc8uapnapcp3fu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC44FA0009
X-HE-Tag: 1771768720-739251
X-HE-Meta: U2FsdGVkX194tuPYnIZsUh1sq/S4AgMGr4XeItlDnbUgC6KFCgDXgamM9t1/3IDpxP/bzoGF6jTuAx680Mp429HC42XAtARqEPPYoFA/pyPsQBqlgBVO97jh2aVfJ3wBDT6vKfCbeI82VgD+HMd4yMxNa1tuRuww85KeN4d/tT6N6KDafY4aaiv0MVWWz1g2dMVyCz5HkBpMzNLAt+bokueFQApoYOsb7XB8v5VMSrqenR70jCFsL39t0COC6V1vYkAWUhRKGEHOKOuGNSmFgxc7R+tO49bxODAf8DjisYrIYVSxi1C/vskFCko2VVzTD31eMC838C+FBTIIIAb+odhJVz7fyRqFTS46Uo+QCbU5G5UuBN6coauIoSI6km3BoH4pU9OeMIASrRvDAW+T1eJSug2UflgLm5KEWIo+GSmx3ogv/k/6eu5YDWv2KIrg4tuy6hSLyUVAhinpFJX7CWIPmROi3SR6+SfPp4P3XTVvbLe4CsBu58jWBJWC+rUAI3yRLylUAhm0B+zP4VmsMZHSK7duLKZBp/hUzOfSL/IVB80OEBVTOKiNkxgZ6HOINQ9SNw8ymemRG8ek69knX4IfNzsaSb8Q0AZxYug2XP8lsC0ypOIILqw0auPa/IpvCiU/aOARkq8J71RE0RH7acNRRPyGbd2JbOJOItQH5t1f3nPdNhcv9B6ypWKTviIMhoeZW5/8bs0L3koG8Gc5UKMe93dl4lHRuNAFQ0INdX6dVWgRy1tXOZBqoW4cqYQW6tbHV86G1tzibjv3EMCdIi5IlvzPQ927DII7mZFa9rODuMLyadakPZByNWWpLCXvie6Ic59aorDjSRMfGrSiTgihJVg+F/KwG7Cpzdk9XYshNRBfTTvfM8OWfhcRRUZ78N+qONfyTbKTs7zrn01xYj/DIaqGgQ6EZu0aE60hhc+FDgSwqvE+j1Jo4wJpQ6Je
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike, thanks a bunch for your review! Good ideas, I'll change the
implementation to follow the suggestions and improve the changelog, as
you suggested. I have some questions though, that I will comment inline,
below.

First of all, what should we do regarding patch 1? Should I resubmit as
part of V2, even with no changes - or pick it now and I only submit
patch 2 as V2, with changes?



On 21/02/2026 05:52, Mike Rapoport wrote:
> [...]
>> +			string_get_size((u64)(map->size), 1, STRING_UNITS_2, txtsz, 16);
> 
> phys_addr_t should be casted automatically to u64 IMO.
> And please, no magic numbers.

Specifically here, by magic number you mean my choice of 16, right? What
do you suggest me to pick? It's the length of the string carrying the
size of reserved_mem, some number must be selected for this
length...lemme know WDYT.



> [...] 
> You can define "reserve_mem" attribute separately, and leave the existing
> memblock_debug_show() as it was.
> 
>> +	} else
>> +		memblock_debugfs_files(m);
>> +
>>  	return 0;
>>  }
>>  DEFINE_SHOW_ATTRIBUTE(memblock_debug);
>> @@ -2762,6 +2791,9 @@ static int __init memblock_init_debugfs(void)
>>  {
>>  	struct dentry *root = debugfs_create_dir("memblock", NULL);
> 
> No need to create memblock directory in debugfs if there's nothing to show.
> Could be something like
> 
> 	if (i!(IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK) || reserved_mem_count))
> 		return;
> 
> 	root = debugfs_create_dir("memblock", NULL);

Very good suggestions here, but just let me clarify: so I could continue
showing the "reserved_mem_param" inside the "<debugfs>/memblock" folder,
just using a different function for that attribute?

I understood that, based on your (good) suggestion to hide the memblock
folder if ARCH_KEEP_MEMBLOCK is not defined and there is no reserved_mem
set ... just want to confirm to follow-up the implementation.
Cheers,


Guilherme

