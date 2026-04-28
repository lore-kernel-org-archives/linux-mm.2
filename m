Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C7EFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFC676B0088; Tue, 28 Apr 2026 04:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED43C6B008A; Tue, 28 Apr 2026 04:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE95D6B008C; Tue, 28 Apr 2026 04:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CCA4C6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:12:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52F15140450
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:12:24 +0000 (UTC)
X-FDA: 84707247408.23.E95774C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9A182140002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:12:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V1Qzz8ak;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777363942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTd1w+HxHrlfh65+PDYw4gWV6Vm3+knn9EDmVl65wVQ=;
	b=HEUPSDX9j5l7F4QfZlWpddJfIAdydcjb8NHhgOGau1xsDwjmaP0XxPziIvkN30OpKRwxQ4
	p9EPVsNZZm8SE4w2dOy5Gp8t/C9b57h7lznqnT2tL0RtXDFfJYzM71NvmKUBS3dOmmu7vF
	p6laCBU5FcPpIxYZJZU+kF5HETigS1k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V1Qzz8ak;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777363942; a=rsa-sha256;
	cv=none;
	b=4Zq7i40J8lcvYlBa0cfch+8in0s9yXSdTO3J0F2q4h7saZMGiLamZQCxS44LWFYPFeUy6z
	CBlx5Bqf0g9xZK+cuvuM0jS36bFw938IV/kOayYlqIw0QDdK1h1gkwvpuxKSh2RE2CVDQ3
	S6hI6C7kze4u8UyVeM3FoIPqh3jt6QE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DB0C960141;
	Tue, 28 Apr 2026 08:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776F0C2BCAF;
	Tue, 28 Apr 2026 08:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777363941;
	bh=wWWSdK4kqaTeuEWEsFP+Ws///SZc85DrBERApaGTlys=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V1Qzz8akwmKUrJKZDa3ABXy2/zDM4ePMvZenwIU0WMpcDE3Ch8xofqBUsbsYxkW1s
	 Y2sg/oP94KjlL6HMg1u4LE1RmXL416fCHXvqY7lpDWCYbhYAIL7vwD2cBYg4KEYaZ1
	 cbRPt+LVcun+IvD4lmPR1oQSMi/oM2NKGU1osgrH/+jMm/HC28tB3MJrVXzgqCQh/P
	 YOkcdjDVrNrq0KB21iVsuN+l2zEcf0Vkp+nLHMFFMLsKl6C/bfnzMOebIYNSgaQJhB
	 jKXI30eZVMXJu62cRwYI2dXU56Vr7RKjsLHziZHvQV4xJB/iasVz3Ji4dsuuf9y91Y
	 XS/CQ4jAWHIzg==
Message-ID: <014f3c0a-7c6f-4f64-95cd-b7b69d804880@kernel.org>
Date: Tue, 28 Apr 2026 10:12:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Using BPF in MM
To: Roman Gushchin <roman.gushchin@linux.dev>, bpf <bpf@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 lsf-pc <lsf-pc@lists.linux-foundation.org>,
 Daniel Borkmann <daniel@iogearbox.net>
References: <7ia4o6j4c5y1.fsf@castle.c.googlers.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7ia4o6j4c5y1.fsf@castle.c.googlers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1nc3uu5596uuxpruigg9mk1hb8dx8tda
X-Rspamd-Queue-Id: 9A182140002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777363942-545118
X-HE-Meta: U2FsdGVkX18yOW8PUwiREqwE6ls04lFCDhnTQIJDZX8MhR2DwuK+krFfPTAegt/MH9NtUEd+4DNzzf4F9Yqcf9npcn+uLo4qNj5lGQ56nMqdJz7bBzv18/As0oWlCL+EoGK+J3gC8k/Q/N5XRjL+M0OlGXSAvO7cJDiCtcxlPCPjN1s0d272UzyVsM//enVRnMQoAdLO+MNiwLF/pdQQ+yM6ADm+QPXsfCwSmR5S/1q1pBHarsvaUZGue03MMwvWvtnIkbBBpidoW2lhPcMp7bvmxMOkUQnGLKuFYBEMIfKse/8eas+cqApUF1F+jDetSt8sRt7pNUlRJmL6MQjq5IIdoGC/QubCWKH+6dA/o+ADpm8n0tf+GrIoPQWXZ2Jq6avO2eka5yGEylyRAcXN4w4r/+7Ne99+3clUizn5ZBR6udBSWm2hxw7ZP/BvpFw0zHfMtS989V/z4+uQJjqD9hfTlAY6jeHOub6o849mG768g4erQ/7+87aWY90TJHEWu4Ql37NGSMia8ER4zCuOD9peFU3iWBz8+Vw73PEaN63nj89dDft+WIoGjlRf3HuwKIwwdLPW5CVB6MtbMiiJPl7TbElLokb+y3XWgPb3EFaRfaO3Ec59e28UIFOIBq3SZy9JfgYH+D2AfarFt+ecjip3F3rODx7mSiIT+uhf1LlzeoLGPd+JntIIDZM4w7g9asaz+fUqhJ1xNUXyfAqHf99Jyn2erwss6mHeF8UQnhJc/EXnNq/IBndA0EOIeZqlqAhwzwk6WeUaYPWcPbi4htWjclxsjPt+VCm/59u6ymTmd8P3Ms3FrOKx345pRGCNwkZtisCgK+X9Bowa67u9+G0BCnlZFcWP/v2XOazx28ZlUFvA64Ft7juWeTa8z+9xCQrC0WmVD7uy099+kZKDJBumuqEou2hq+QAruhTJwnUzK0dp2SiucsmC4PORCgkN0sR88P28H3xg23/yCuP
 mYn3o+y2
 VQj7CLq4NZ0NxMxRTRtGpRWXGqmj9T+k4qUfT6DFaeKcpuSCDhK/7igirlt+OW0GtVz5MIORvsepBgq77kQ3Pia+7RekCZfcqJ2I9tz8oHh6tBM6VezY1E6rX/rytnq74pN763T/uGnTke6OILdlJFS6902Fh9OeyZt3+dbNh1LkmVEGeZ5GJ86o7SCNguJcb5Zk97NfAuEEaWITYN0Ycf1brxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 01:57, Roman Gushchin wrote:
> [LSF/MM/BPF TOPIC] Using BPF in MM
> ----------------------------------
> 
> Over the last decade, BPF successfully penetrated into multiple kernel
> subsystems: started as a feature to filter (out) networking packets,
> it captured its place in networking, tracing, security, HID drivers,
> and scheduling. Memory management is a logical next step, and recently
> we saw a growing number of proposals in this area.
> 
> In (approximately) historical order:
>   - BPF OOM
>   - BPF-based memcg stats access (landed)
>   - BPF-based NUMA balancing
>   - eBPF-mm
>   - cache_ext (BPF Page Cache)
>   - memcg_ext

There was also the BPF THP control.

> 
> There are some obvious target which haven't been covered yet:
>   - BPF-driven readahead control
>   - BPF-driven KSM
>   - BPF-driven guest memory control
> 
> Despite a large number of suggestions only a relatively small feature
> (query memcg statistics from BPF) made it to upstream.
> 
> It looks like using BPF in the MM subsystem comes with a set of somewhat
> unique challenges and questions to be answered.

[...]

I think you are missing one of the most important points: Unclear ABI stability
guarantees.

One the one hand, we are told that there are no ABI stability guarantees, and
that we can change hooks (add/remove/modify) any time we want.

On the other hand, as soon as there is some ebpf program out there that we
break, you can rest assured that there will be trouble.

In the area of THP, where we don't even know which hooks we will need long term
and how they would look like, that was one of the reasons why the BPF THP
control was rejected.

-- 
Cheers,

David

