Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 753C6C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 10:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2CC56B008C; Mon, 10 Aug 2026 06:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD726B0092; Mon, 10 Aug 2026 06:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCBF56B0093; Mon, 10 Aug 2026 06:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF786B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:52:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F330A0050
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:52:48 +0000 (UTC)
X-FDA: 85085046816.18.2AA39A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6060840008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:52:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XFB1dv/E";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786359166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xd7uYlI3wnjsUpJNqV8hMKDPnzd4/RrOMCkHIu6ecco=;
	b=uCXXgIc9d1XEk2cB46NR9Aa/Wr8uVpFXxuslggvoALMU6VCKSQRj6nYA1ZkzFXTYqa3tGf
	TVakZsrxmpmghdAItsBAaz7B79Xr4bXdPUOINtbWcz5P0CaSjjPayYwDAMZ3Er4V6T2wYN
	tEfVVoshNpaqI+7bFhgmxv0hsYsVD/I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786359166;
	b=DPXxCVgBTO0XH2vEtdPdVKR1itnTMBBqUzVRMesGLsh7qpB+dzXnbMIELzHSkGBgbklP75
	bTSoEbv69wPdLi8k6E0CRz7i2V2UdIBMj9xIrxUHROYhT+yTkeuBn8LKaHVu/hDv51Aup0
	StzhW+A3kY2GRt5iik6cpKNkLQyTWok=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XFB1dv/E";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1C44600AB;
	Mon, 10 Aug 2026 10:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1DB1F000E9;
	Mon, 10 Aug 2026 10:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786359165;
	bh=xd7uYlI3wnjsUpJNqV8hMKDPnzd4/RrOMCkHIu6ecco=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XFB1dv/E1xORbGmgRjDNX1HyLkdZhUvti4vokmTBUS5WWoC/8aCtfNGix+ti0ljCQ
	 tRmjUfaRtN+omFlttkw8IpYh28r9q3lmEmeUXzmOUuLu2Eyvdx+zy/B4ydniOmloSK
	 oYSlKhZ15KK1hFX8mnzA9zDKeK9t5zGWfn6+tIf5q1uv7AxB96UEMB5P3KDWN3vrsC
	 7tppJGXbcW97ZkA58zyFlln2hVOEFJITZHnJwP1zVCQIIXI6YvKwazQrrTXSSvS3UT
	 hw0E2yTZyuey76B98vwPO3doBlVa6TVfPwv/0+Mh+oMBM+E2JIxiLBNeVcb2sImMnv
	 sg+CtjYVoEycQ==
Message-ID: <69df3080-a719-4131-a247-62bf47bda8a6@kernel.org>
Date: Mon, 10 Aug 2026 12:52:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tracing: report buffer memory in /proc/meminfo
To: Xiang Gao <gxxa03070307@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lorenzo Stoakes <ljs@kernel.org>, liam@infradead.org,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Xiang Gao <gaoxiang17@xiaomi.com>
References: <20260810094025.136705-1-gaoxiang17@xiaomi.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260810094025.136705-1-gaoxiang17@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6060840008
X-Rspam-User: 
X-Stat-Signature: xydxgf8dmj1csqszypts3zacocmpgexu
X-HE-Tag: 1786359166-326863
X-HE-Meta: U2FsdGVkX1/7cWxqdpfdPdxF9KKsvpoPgG2xMXOpskJqLKmf8ONO795ZZhbtxB8RnFOC5Aq6xLAlBH3JmqBMXaBo3VYRVujEQLPHipIHwlKS2mSs8vyEVBXf5xwgXyaxWUfy0blARZIHHek2bbjFRvewqTgkCLDdohLMTNs+lxTJxjslaWbIR3n+FoJdrPjKaAKqWObfTwh7SxXro8GSECJucmr9nVtdJKV4YcgULALVz02LLTrFoUKeUC3NjGLO+5xgRLu8DV4BTxmoA96pQrpbVwatmcblTDFQCowvCv8co98nhoYciUyB/rhNVzFw99/n71/4Dxd8ZKbWaFvPcuKAYlmhZrH28074e37zg45tJ1pe8IFh7+qyQc+IgdpIXHEuFeMz4URL9fItfTuWNW+gx4NTsrHC6iivhDQfv1kEe4x1ulIBntz8CCtf41+8bT7mpDTzGtX3YrmganQEvOAcVofEMwvYunixXetjjVZgJZx7dBZtsRuoPhU3IwqtK0I2sNKKvU+npoqdyKl95jgET6RpUoVAXyGxRjCJBd4aoAxNb1nkV3/+b6fu+2qG6VhU/EZcjvSFpBSoKila++6gy/W1PDogwqnW+Ih0jUerh/fwhuRhR8OLV2AOR6w1x90+oSMdRtP1cURFcEDvcwBq5Hj0Vf0chNt9zHcDHg8OSqTuBQSUycayzqFgVgFYL0EKdEv1swpHU3xQz4RQy+AeEYD0vkEBf5gy/C6BR6eCF8p5ljEWxCv+yLNrt+nO3x0nVOfc6s8UcdyShApzQJMM1YhGzBQY0/rA/aIfyUk0Tr095273ID0u1ZGmy4iEty3Aw3MQ2mACYBu4wzpWJIp3PQvzgcCj6NYt3V6kMmHATNHVYSUSlWxjo/Dczi8ZmvW5DfksxNUPPH4u3PnixdOtx7Hi+oJViwAveWMsJp6VgIksb6IyuemO2ss5n6ziSitzgIPa1RWfpw3Wsvp
 ecCkU95p
 z9Jy4tsIWUnUk9MubiXOKogW59iHXbj+yUvObujtXuRtK+CjRJmC02jzP4EBtvl90GrnIJW8KjlnWMSoVaXsZldDIMJUsH6TBZFJNNtgG97xUU36p+UcV4ggGFWy254HpfVsjFRu87VlZr6CBMVKJbHyeQjcaU7FmYCUtG0D5ZXU3oms0Odelo4wak1V9BM4LT2zwWc4m/GHRPhtpejdtEA41b4bfwAWAXdbAAruW6L1FU29s8Nxw42OJ8zQBdrIHquHN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 11:40, Xiang Gao wrote:
> Report the data capacity of all ftrace ring buffers through a new Ftrace
> field in /proc/meminfo. Include the main and snapshot buffers of the
> global trace array and all tracing instances, while leaving ring-buffer
> metadata accounted for by Slab.

why? :)

To report a handful of KiB as in your example below? Doesn't sound super helpful
TBH.

-- 
Cheers,

David

