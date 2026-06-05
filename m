Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A4C4CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539166B0088; Fri,  5 Jun 2026 11:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510326B0092; Fri,  5 Jun 2026 11:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426156B0093; Fri,  5 Jun 2026 11:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3472A6B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:53:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E63934019B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:53:27 +0000 (UTC)
X-FDA: 84846303654.14.2D3DBF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1F4AF40013
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:53:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FTVlKQyS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780674806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCx7E8Saqsm4dUn7ZhmhHh+wGg3mmDyGspPFKlQt0wg=;
	b=xU2Fo7uuKPEGmRDXpzmmTLS/Itto9wBKK/lJrhUc6N5IYClMzcXzAq7TVgzPDlGxdi3v84
	gbsTqa7xnGgopwbnoOpwY/kGZx73Q8eTb/Bvn/OG5Z0ekPyYJd8HMiltktLqPoktXb4oyU
	qkyOEZFJKb5EI4MWTg7Kt0k5blO5eSM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FTVlKQyS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780674806;
	b=gdSfOXtT5Rz9pS3wOAkUhcDCmZuI+Bgc/otHvgcW0Qwjtqv1gCWKVs0lKXQdvwAAmqPIQG
	Qy9ffsNc2ez6GP7n4Htlu7Q6Ule8Ua4msYZY35++3rsBQT7QBHuYtg1HrHb06tdpNUSAwR
	f2nGYZWSSKc4LPwF7+bcsJTk2cICvk8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73C80601F5;
	Fri,  5 Jun 2026 15:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02741F00893;
	Fri,  5 Jun 2026 15:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780674805;
	bh=UCx7E8Saqsm4dUn7ZhmhHh+wGg3mmDyGspPFKlQt0wg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FTVlKQySSMbp2NN1U/7TLYk0uxNkzvK0wb4StT2P8Es7lkMvj5KtyrsK5m0JSX6SD
	 s+5ztxBBVIdNyDeC1k37kBfI8Odqv2lxXjj4Sw8x4KTXMajUOY914AS0STksfn/mUk
	 yO3CuuSRZx1sVJZckvh7GbhdbdmTS0aiFdl5NsNjX6fVDgxr3s+ZzjkSnjH04MAf48
	 X+ls/5IlezKQNR2sZzRceVPymEsZrUhI2ZU5ifDcvCiCwRY1g8SjoOogqqJjdYadkQ
	 b/bwC7kFyl+FyYQal3xRKU/Csk6lKlV0eDUmwirzRM2KKXtHd+afc1KEbKLFaGwa9W
	 Cb/ORGFWkXDuw==
Message-ID: <041ba9b4-305e-49b1-affd-079fe4220e48@kernel.org>
Date: Fri, 5 Jun 2026 17:53:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] mm/rmap: add tracepoint for rmap_walk
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
 corbet@lwn.net
References: <202605301703094695zmVgcSC27BNR0rH0N8_x@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <202605301703094695zmVgcSC27BNR0rH0N8_x@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9c3r3m1e76n9ja16815gx545ckiqksg3
X-Rspamd-Queue-Id: 1F4AF40013
X-HE-Tag: 1780674805-833596
X-HE-Meta: U2FsdGVkX19UnQWOPyh/9sVPK1pkVAXGMm8DpZZEdeYNmE2ZHSJ3hmYouRnNQdffsl7J1BHO5HMDSPUxzMZh+4MpJyWBsoIkWwHq2o6qiCzD9lvoKLddasU4BWEaIQTbXW749SVn8xotHBK93xnVYepZTwyZroLrSOppwHC+Yn1ebgxEa5n9ReH+0DXMXRGVfpGChbsJwmm1Zo99knDhBaM+JSSWD1VewgYZOo+DcYwMdBFm3qibwriUDWRPUB1UEn6Sj7eTES+6tWje8A0ZWx1ZNOa+8EmO11mVRV7kYypnzfHuQN8nc1/GuRudejGmb9KxCucAC+U3ErTFrAGerx291AaLliGZjkW7Kh1c0oinjCPH/D+nBd+5CJi+ut3cyOWIysYtLTE0DCmsN0P6idN6mYISQ5GgpQgnmwZkVo5Dy1KaRmo4/sp17WjzBx7nEwlhQ3WqGie7CEd9g+olwWjA6fWEhd87LJBWpE00mkGa2D+98slhkEvpQWJbFTzYiQhDAf9mUomcKQ5/ID6QVa6id4GZEiSHvNVghO7dza/r5sF848C1pCt1MgrmHqVOX9wN0dfzlmb9LmyqGrXhodZMY0uxmdRu4ONIQPrx40OyEyd+51PuFmuJ1w8NgqKF31ALadDOAXxOkTZdSLWet+zfQLskXTbivD1WZLwv1u/89AIFbwt5S8hC6PotvwQAb2/otneZQtV71UaZQPk1TuPtLtoUp8Rpy25Nqcg/pbxZ8BRgxZUzEOyBe6z+DypCp5h703WdQx0i19I9Knhu8HLTM33kjoR1ON0Ol3HOcFJWtdp2nk1If8rXaH7OhMe6jIPfQb7O3LimsHPSOm3nRi5U4knY2VE4o9hF0lGpD4s91lPp1m3FypoDZwKrAesj1mjPHVF/L09RSUGnomc+9hXmPV6XilH1e+4igUsTewIGP2mf2MElv4DfnEJ8/iPC0tyFj67ph8LLWEnSOGt
 hcdfxEMU
 hI9wK/KDb0CNS6m8Vj21SIZQ9IYwBwfUEX7XDuqRk2Xk5V+w6MOEF0xbp4z1pE+On7HmNdEkaWMWbufdPYS7JYtaPJKLJV8zTYHqOYzUtXwUhaFNhdEBUk0Hokma7J4ysMPymPJIOnLsjjudXXffElTaLgAEbj4KU0eoz22pYpIMbDHhk1WKhL5Tc03/XGZL64Pzd8n7999mLmV+KL9x9Z909Xj/+H+Zxv0d/ttP9gu83T0QrVMc87c/SNGjtmIe8bjumI3woI6/viaJDA7A/rsEGQg2t1TGJbMLim+4uiJKOrLnct5vt3ZuZKCaA5MzzPUYnroeBv3tyJFLdif/wawzde5QDKMqOyu/wZjrCChW5mDJu7BbKmheyQQydZicAyQom
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/30/26 11:03, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Add trace_rmap_walk_start() and trace_rmap_walk_end() to bracket
> reverse mapping walks.  Unlike manual clock sampling, these
> tracepoints record no timestamp; latency can be computed offline
> by tools (e.g., perf, trace-cmd) using the event timestamps.
> 
> When tracepoints are disabled, the only cost is a static branch
> check (no clock read, no duration calculation), making them
> suitable for production use.
> 
> The information (folio type, locked state) helps diagnose
> performance issues in KSM, anonymous, and file-backed rmap walks.
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---

Learning that trace events can easily become stable ABI, we should consider
dropping this patch or switching to DECLARE_TRACE().

See Steve's explanation:

https://lore.kernel.org/r/20260603130006.7d2c4a62@gandalf.local.home

I assume this could be carried as an OOT patch when really working debugging
scenarios?

-- 
Cheers,

David

