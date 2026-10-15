Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 963C4CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 13:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B726B008C; Thu, 15 Oct 2026 09:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC1E6B0092; Thu, 15 Oct 2026 09:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB2C6B0095; Thu, 15 Oct 2026 09:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46F796B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:34:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0EFFA87F9
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:34:03 +0000 (UTC)
X-FDA: 85324953966.21.524B71F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 189774000E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:34:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F0LxgPhN;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792071242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W2OTIlY3rqRxCOqXm2QKJNxsoQo8QQJBqBmwh6+SUNk=;
	b=kEqPYFAj1pXaVSrY+AEC/rS5iWUzaRD73ol+sj47fFJ3fqPiW9ONYLJyalFzzTSpTkRvE1
	r089n1AKpJrbnTccAC4wSIan8BxfV7BumWIezgjcmMQwL5EcEFZ+IsLw04+OsXa3DHzOcx
	p52Qi0kg0XYZ0LmbIA9drzZHHDV+etw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F0LxgPhN;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792071242;
	b=TCZVso8A8Dnw7wjtdEqwS+zm13CafaEmsL0+VYwrA/R6DvQkqkFDdGzk0xDoPubUS5DjLI
	qx1iCq366zjyZHphZlgSL6qT4sB6YP+1KGfeexAO52CUptDTR53FKzMqzOpT16DUGpg79m
	s84QF6zr0MUjpHEnqn80bNQC1Uv5JmI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D001760120;
	Thu, 15 Oct 2026 13:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EF11F000C4;
	Thu, 15 Oct 2026 13:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792071240;
	bh=W2OTIlY3rqRxCOqXm2QKJNxsoQo8QQJBqBmwh6+SUNk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=F0LxgPhNni919ThpzPj+Foc7LijuWTjbpuiYcHqGuGR+xJBN5S3ix0aHVf1w6XOEB
	 fG+hVID8BtLEFfnZAr73LGYSs3eF7hXFd6mJIqtuXQfYnGRSaKkq0NvARLXJeqr5Aq
	 onyu5SWoGIe0dKDILgDoYbVNo1qBLRQjfB52i68WeIk9G7kZcSAaF4MoXG+6zVij+e
	 TCyM9ZmqAkethyp0D07IODzTeXU6b0m9apO+RfbqqZ2bJdco/N0TdYNbV1ZmNUQfMA
	 OODykASHKZGTT3c+5ySYx1m6kn/e/SkPQT7OseMBM09lJVa6NSDs3SOI/QrqeiKXKm
	 kqyoe21v9Cozw==
Message-ID: <cac8067f-2687-457b-97d6-cdf05465fe67@kernel.org>
Date: Thu, 15 Oct 2026 15:33:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] khugepaged: hold invalidate_lock across
 collapse_file() readahead
To: Lance Yang <lance.yang@linux.dev>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, Jan Kara
 <jack@suse.cz>, Hugh Dickins <hughd@google.com>
References: <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
 <20260913163644.122133-1-ngocthang2710.1999@gmail.com>
 <20260913111700.6de78b5834842f7dd3f12d07@linux-foundation.org>
 <aqbvFtlXd3Jdnfbm@gremlin> <1fe4027a-6ad8-42a1-9943-cb3b8aad3fb6@kernel.org>
 <a36e9e99-f7c8-4aac-bc05-8a042cd9f438@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a36e9e99-f7c8-4aac-bc05-8a042cd9f438@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 189774000E
X-Rspam-User: 
X-Stat-Signature: ybdfh35436yfhnhs614ixtz44zmn5kfm
X-HE-Tag: 1792071241-186265
X-HE-Meta: U2FsdGVkX18tt6IFbvPYD3baSTyc1GCNYn3vNSiBx6+UphhGWxef9ot5qFYTav2Hne55FzOAL5AxIwQlgdSFkEw6FkFehkdPhdwX8RTrnEaB2k78d6Jmvr3iQRmPr48pZmgG+JSrUCIGqIhrfSZYHYQjoB835zC45IhA8YBN+0thzYzK3hOMUCOhlNjUOHTLczdCQNCSGchHpYFNmzKf4d3g3mwHwSC3Z3JcpvPNhHMBIszGnLPbGTj5SV2GaVfMk5lstG+Tq8vVCocIOPU1sclDlFLlBALxpJf348t6RQlwetC1rj0velY2Bt841ntvFP6VNkVhpSj8uXzBlZU0ErncnCOFg1aoZc+z46UYcwMv/kFhT9NYM2DymlLIE8wht+V/OcMaS0v+CFqZez7vmiq4dIlILKCecbctcD74w+m4gJNy54kUuVJCBieBq2gbawQ/yCmZihBWmoTOv2ZfoUx9/UCYJ0aiR0FB4bZWJWsB6JsMapGTtauHKcbGBs+LFNsYtmMzSH6sjXeomcyb8ENwTJvHGrOTlEhpnHayGEfwgHxGUEI4BYAEbTMNY9ZKqb04w2PoA801lRKhpIu5RK5y3bHK4IW97z1ZC3IPF0HzJHdYWNFsLTLkc4X7GcgIR4j1KVIYPzFY6uppl9s057BzkSrVxbFg3qYxItGqySM8sdJZtAXQq1e18QLRzgMzHmJiLaOxk8Omzn59uXPNimtzX1KmMAPiCTbxJFxHrnp4VGfqqe3jIwOdzc3CadchwyGaOYH8hH/HXOxUPA3AvToRJmL3F+fAwsqngiQCDDYKB84OiNcL1OKtV6shbTWqowG4Ije34VU6fyNt4FK9cYigIsR0zElo+eODMU4pHd5E7UJuhrU/nVHpK62/MzrwzPtmbUyexyObuoYaAQV0meapafyZX+2FeWFgdrRsxsJqReIga2rVZLgC7d6oWFPX9fcWvi++mN/fexcZPfI
 nRmoDtjV
 hCV2ex0o+qYGNrbvEvp89/vfVi7G6uANA7DIAfLy71DuTbOxF3KCRrD1eTfAIYXkNtwcaQLfBxlSDCM2rsW1d+5kQfra2AhdSmCdlgixX2S/0VvFvr6uKoOLeVWhwcZYRYuMXAx47O9wkbJ2gWv095s7L1waIdxEhVfaX9q3LVxMJfzonD5guYhjsPMPdY+09CwPEZ/mO1ZVPjs2cPBx9GGZRNzg1c+mXL/blWqTAB+HAlxSHD6dxvGwb4Odq+Xfq2n+5AL+q5mMfsaEd0hSiFKJsxAOIlFVCnW1fnEy9ky3BVPMXF+8cWyNLadN8nv7JuSxcBVd8LmnGOfYrCBqAC6CvQon3C9BiTGNkS1eLHI5HEaLJcbryLQKA5v989Gggn9iTOTt8a+EibzJR0uF68Q4BWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/26 15:17, Lance Yang wrote:
> 
> 
> On 2026/10/15 20:26, David Hildenbrand (Arm) wrote:
>> On 9/13/26 20:48, Lorenzo Stoakes (ARM) wrote:
>>> (Nguyen - do not send v2 in reply to v1, look across mm and see how things are
>>> done here).
>>>
>>> somebody who has a
>>>
>>>
>>> Also a change log, and that mm doesn't like sending a respin in-reply-to a
>>> previous version. Which is all consistent with somebody using e.g. openclaw to
>>> pepper generated patches across the kernel...
>>>
>>>
>>> See https://lore.kernel.org/linux-mm/aqbtfms0_2ULBIT7@gremlin/
>>>
>>> I am not really entirely happy with somebody who has sent a flurry of patches
>>> across disparate subsystems with no previous track record being in charge of a
>>> potentially backported fix.
>>>
>>> It's David's decision but I think this fix should be taken over by somebody
>>> else.
>>
>> So what's the status of this? Any volunteers? Otherwise I'll polish this up.
> 
> I can take this over if no one else volunteers :D
> 

Thanks!

-- 
Cheers,

David

