Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49EACCD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 02:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38B66B0088; Sun, 10 May 2026 22:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8AE6B008A; Sun, 10 May 2026 22:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26A06B008C; Sun, 10 May 2026 22:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9390F6B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 22:47:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B8E7120583
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:47:24 +0000 (UTC)
X-FDA: 84753602808.02.1E62BB9
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8ED1F40003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:47:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mcK52oTj;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778467642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3SwfQTRstxGAWJOQrDfplfV/r0dJnk93kn46PHmRmA=;
	b=4+SwWO/W5L9UXebgTCkJZ5AvRAdrukLIBZDR90eQ87z5y7LcPT9Tp8o/czWravD2JOPtFj
	21/wmff60K7q3b+PyJn0TtOJeGanEGe0ZD59vsD1Gl7Fd0ZT4wKOIX9snTFcyvQTU0ZIlZ
	7nH1AwWlCdD2VfE2iyAgeYsUkdxGK8E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mcK52oTj;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778467642; a=rsa-sha256;
	cv=none;
	b=FYp3GmNIiQPcMhYjV/3APU2wxSSwOySItugcHjc/bngeAyMMglT+mAWphUqvUVLd/wsOBJ
	aQUtEadeep3jRfiuF2gUSHsKC4xcm8isnCrtfK8oHFd/Eb8nLoxbB9gXRDF3QOdY+5u4+e
	0+AF6zwgjhq8b+3L2tRcBibFUe0CxnY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778467639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j3SwfQTRstxGAWJOQrDfplfV/r0dJnk93kn46PHmRmA=;
	b=mcK52oTjOdqXICVU/+QRzwUY2kZ+/hvTdAxifTWyazCwjrZEWyA8b5xvPXfYUQ/1ourdEF
	UPJ3X5zZbgmrUwqqfEyU3Z6d5YEQe8yDj7X6zAjwoh933/j0IyezeAHfMD0jDxNj6B9jAz
	OM+nDZ+/GRW2zuUl61Bb0tU9pBgf1hw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] selftests/cgroup: check malloc return value in alloc_anon
 functions
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260511021615.1768623-1-lihongfu@kylinos.cn>
Date: Mon, 11 May 2026 10:46:41 +0800
Cc: hannes@cmpxchg.org,
 mhocko@kernel.org,
 roman.gushchin@linux.dev,
 shakeel.butt@linux.dev,
 tj@kernel.org,
 mkoutny@suse.com,
 shuah@kernel.org,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <EA4FB6D8-52F0-4135-8EBE-0B26BBA9D303@linux.dev>
References: <20260511021615.1768623-1-lihongfu@kylinos.cn>
To: Hongfu Li <lihongfu@kylinos.cn>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: j3mmu3j8ziduhxwiabzfmcxcbwghw34z
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8ED1F40003
X-Rspam-User: 
X-HE-Tag: 1778467642-782782
X-HE-Meta: U2FsdGVkX181n/5QvR39I8Nt4AgurNS5tV529x0MlYfM1KabrbClXrXyfGacLyoODJ6Iz+OUHSU/w5O7vy48Fq02dypA0xx1VMD7DmmusoMma7CPAABizE1Fz2DJFPPMtahzEh5WKDKmAq1e1Jbam97ytc8sNtfMZvyZY0ktw2otHIyXDurXnzqNVyl6D7iUEBf3DrbgRe8Pvw+Sz4FTLuQpwcjJq4f6DPglOVqnMdr9lCCNA5qioRvyTQUKUwuDwRSLLn1HT0WYy4sCij6MCFoWJvz74ZixZDfgsuz7wom8ezLxeOcJgvjA6IGeAiO/o3cmk1TwAJTmCVP/RkhRkTu7GcFIMKmssQN5+vyeiPOAeGQoC4Ndi8++nHF8Zqs9X0rfb96JXcxUF475QVHn9XFJwdgszokbGyLwsRBqyBp42qNB1tsQPAzq/Cc/3PPsvcNbje5+PAuOfUM71Z8pmm99GL3sgW6EPGNB6mum+Z/31u0oA5q0zmAUSUlBSJ7i6dsFRKHunRpWM+UyhPuUYrzEz8xIl7u8wZCRqklkWWeaWD0z75ZwKMnWo0kVG6hwhOnvtQMIX0JTW3EinS3Pfvvp+QBPPg+Y8/6G9jUNqZUZKy7lBxGkkg83OLexMM85W3kJmkkqunPQ6MozE+UBaXO5jOrRRj2NnwGVzpKAEoJckam4Mqmdqha9GJ8p/9BZqv/Ths7+r93yEE4FwT/4N1GfUGPJLMHj1dNex/7YVpChYZgXTQNWQ61OFsL0j8Mf1Vor9i4JRStE/YktdQC//UmNihGWXcVF2lTnyCZfbKqDOx7DRw6ggQbNZmbeTBG67ldzFObpyje4qHke07HtlyqcVhlQy6mtIDwAyBQN5PROLsWj/Tw/GF2tpTJwC684gryV8hmAwgM0F7WHjgcTXuGS+EIk+59vYBSe4IW/xKfBep1OwdhOd0nd1Vc0/1oGWMd9FLmwWyfLRrsgBkp
 q0gG3etm
 GjjmiSLQSyULqg/PgEBffO/Vzg/mgTzKSDPPJnopR6vEVbODVpeJbPSgPRI4tHxub1umCIHLYyl/i9QJgU6pk7DOnSBOE/gSBekPYd3Xis/VvasMth4YmB5D86Qv/pxVkj8f62/8LQ90C7KOM1iyrTOhACrl4MI2/ep7jKMoeL8eyIowFn2TurER+5KthSa3Jk8G6It2j93Qk4J3MEZ3U69LMl2Z4ZeF3rQyIsk+OrV4e1u6gaCkGmmPFJw2grwKUjWVXQxX4mEcdlZKwz59YjSRu9YDm5mS320x0g82RM6Ywoq5fleREhWylmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 11, 2026, at 10:16, Hongfu Li <lihongfu@kylinos.cn> wrote:
> 
> The alloc_anon() function calls malloc() without checking for a NULL
> return. If memory allocation fails, a NULL pointer dereference will
> occur when accessing the buffer.
> 
> Add proper error handling to return -1 when malloc() fails in all
> four alloc_anon variants:
> - alloc_anon()
> - alloc_anon_50M_check()
> - alloc_anon_noexit()
> - alloc_anon_50M_check_swap()
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


