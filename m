Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA5ACCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 06:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26A946B0155; Mon, 19 Oct 2026 02:58:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EDF56B0156; Mon, 19 Oct 2026 02:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DC576B0157; Mon, 19 Oct 2026 02:58:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E376B6B0155
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:58:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E40B1405DC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:58:52 +0000 (UTC)
X-FDA: 85338473304.21.A8F8354
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 876192000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:58:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=StlLDKq4;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792393130;
	b=twIH2lZprqZSrI4R0Ho46E2VeKcXpeWS7wJi79/QYPMN+Mqs9ked71aSIXWm+VBCH+YFP+
	9guqfMzgKlpp2tUl/UJT50x8VuDWNzDPKqEQIuX0gQ4XnyCTPz05NufRzl7l2ONaE17grj
	TXwthCZj9leFet7Ah/6rlMZdGglYOow=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=StlLDKq4;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792393130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+k7Fh9ZsdUdoxm+LzzQ1wpGUjIs9WC9S2HuufWwarJw=;
	b=zINeNGg3fY3YsX1zVp9/Uzbtp5c7CTq4lZ3stCTbTfRlp2gqG4A2NzchfXXm123OEahlcT
	f7Ng+fKc5Px8SSKqfyjBMp9YWqFFekyE0+fCCw2s3xPeNz4YNKsjkKrMBd8x11jdW3luTt
	VIyB0faq8ZG9hdfiutXwzd3eLSHkqu4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F4841477;
	Sun, 18 Oct 2026 23:58:46 -0700 (PDT)
Received: from [10.164.148.56] (MacBook-Pro-3.blr.arm.com [10.164.148.56])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 514DC3F673;
	Sun, 18 Oct 2026 23:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792393129; bh=jKcRI0F9aHnlKD651grREaBBW4xvRcUMzBlgAiHKlsU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=StlLDKq4P1yblYmcNUL/S2ln1AqLeYYRPcJPR+/GUUMAOs1w3CfSJYbdyEfSHULs+
	 yNXPO49brP9+UjPFeg1bY6f39wNxEV9GIf+ejuiDxy5qXrhRH/cH9ROgchLpwdaLtX
	 AYklqgynUtNpXJDDuA7feuEpCmp7LhrGsihDk9Ms=
Message-ID: <4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com>
Date: Mon, 19 Oct 2026 12:28:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
To: Kiryl Shutsemau <kas@kernel.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 kernel-team@meta.com
References: <20261009125503.126202-1-kas@kernel.org>
 <15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
 <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
 <as5q14OsbK2CmOrh@thinkstation> <20261014202936.GC371161@cmpxchg.org>
 <78238103-3a7f-432c-b1df-bd14d7cf4bb1@kernel.org>
 <atDMN5MoGrwJNpAj@thinkstation>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <atDMN5MoGrwJNpAj@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 876192000A
X-Rspam-User: 
X-Stat-Signature: mpdihd4dg4eqmb7qyo3eqt7w4sd8pzsk
X-HE-Tag: 1792393130-943905
X-HE-Meta: U2FsdGVkX1+Zma+vzqj2oFCV4Kk/wMONwPow0zQY1/3H31ajKXgyoldheZwHuXXRMzgQGUTcDo+Xh0zlS4DRQcL3kOMg5ue61pwVkq3fgt5upyi5pFQL4DHr7A90xCO/kJwZaXyofAsa9INSaMPBdWDfBjgbVcmiPCw4eRjVakUfaApNS7I9x1fbiqm77lE4NEKSMZnfwCwvndenAZr0JWbjv3MSxnyw5KWPy4Nw9pPWt3zNejyZNitUPFJNmbdlSs3tRa7S6KQcjbA4TQAmhrFCbt0yHUkCFrNPg+2FD9A5hb0B5r25KPEsp560PKfg0hnlNShf7utQg/T8iZjGDyGOtZFYGOtj8HQmNHYNsIi0L7exz461jlm22ZfxCuHiV399154zori60SqyiSZ4WBoFBw9tMXCjRrkEiFQCQ6lt4+8oN35FvOCwyats984u7irKcAvWMfHpC9kY6G41dM5cyt7HhtyiTvHkua0cqZObSO1Y/bN9VAQMLmP80Tsqgeslt3Lut4w8xPUaqALLiSZUUANNHTg5VAbLpzABg5p6yGOHDwoBuiD7zTxrr3aIrc/LZrWaqZ6M7A8iPjhKoZ2phWU6SXjQTELCwSIhhhcye5QjM0/tvkoR218OcL21O+vmTs5RkCglwzssMHpukfr1ccnVM2EEHaUM4NvVI1poU2reJWgSVogpGAto8EgLy10NSzM08ZqIwf4LPG6kUE8dAPqYaMawHNCWuQYzCSWW23J5O5y+H3AauJiLJoafJqfkYM7DXJ1/cBTZVEjZyJ0Dmgh7RxJWEa28wraVo5zY+Ek3hxb2bU/nzUdQihy0EVhWB6Su8SMegZtcM/WXYXx01DOHwZRyOwrWmDl4cMdHUKiG7tXaQqiUPMw4RF1Gq6QTaDg2PtiQb47rzM3nW6+6UBXq6p8a2+zq6DhRwYC6C+RqAYx4zmqqpTKgN0Y/31BqQTkGFZAIDTVuwJB
 hUSfauvS
 2/MNLZgRrQjxXWBDo6E5VUGoYLeeCHIdOCamluaGQ670W3L6YjVh39Re1GnONcOb3u8SLZC7MqlbmxDkD/pAcFYGvQMkeY4MPL8hrFQ/XOG9NFNzZUNMSsw4nI6iphFguc/GW99zOEJnWugm/e/Pn+SknMIvOeBBZa+81xL+TrrL6z15UMIoZdaXEFA1YPvkxFi1YZ5iqf5wkmi88LtJu03jClsaklytnhb3WTz9KwXz1dbxo+3jZfNXHheX7DENysYTr4Lt5jGbnE7W1I4f3Nl0ojGr+OzZuHnG6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/10/26 6:25 pm, Kiryl Shutsemau wrote:
> On Thu, Oct 15, 2026 at 09:16:36AM +0200, Vlastimil Babka (SUSE) wrote:
>>> And agree 7.4-rc1 with CC stable is fine. Sadly, not sure if anyone
>>> but Meta is using the feature right now.
>>
>> I thought it was there for a long time but it was only added in 2025 :) At
>> least the enterprise world is slow to adopt things, AFAICS.
> 
> I was thinking to propose a patch after merge window to make defrag_mode
> default. Do you think it is too early? I don't think it is ever going
> to be truly stabilized without wider exposure.

AFAIU defrag mode is not going to improve mTHP allocation success.

I ran a synthetic benchmark faulting in lots of 64k mTHP with swap enabled,
defrag mode caused me to enter a warn_alloc (and 8 times more compact_stalls),
which didn't happen without defrag.

So perhaps bundle the default with pageblock_order eagerness etc.


> 
> We also discussed with Johannes to make a stricter (defrag_mode=2?) mode
> that will not give up on fragmentation ever, but OOM instead.



> 


