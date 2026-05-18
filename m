Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8378CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 21:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3992C6B0005; Mon, 18 May 2026 17:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3713A6B0088; Mon, 18 May 2026 17:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260336B008C; Mon, 18 May 2026 17:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11C3C6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 17:26:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4AA11C1FAE
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:26:29 +0000 (UTC)
X-FDA: 84781824498.14.8A8944D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2D80160011
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:26:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rzeeeH/B";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779139588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=k1aIAJ/7/DZpu5dxHvfaewY+yZ73lpXbx8QPnkbRleQ=;
	b=UKZ97B1wvL3dMSyTkjJBRReZirPS2WeVR4IfCHjVLS74Umte4D+bsQGa93dqhRm+inGwC3
	uo+KN4yLVuZH+oD/G2Ehfz51IjIoGXv78zAtlZPqPNBQ4R+OlXs4MfagltvAtVTf9VtMO8
	PW7jeLHvgkS6xFuYkyWU4f4gMp2ikXo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779139588; a=rsa-sha256;
	cv=none;
	b=L7t+yn0rsFjACkXwHFjhSw4c8BEBPj/oB3C2SniuXOgKpE1RZ5LFA8GxdHCiU/3O1PSHHe
	jO/4gk5vh1aMubYazvWj8Yl8PCQOMeHSCBO480ppVHBOmS3hFcjIRmfiID+ey98iVmCtq2
	U07kZED20jgOm6ehotvYXwNo5e0O5DY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rzeeeH/B";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C1DAA4417D;
	Mon, 18 May 2026 21:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547ECC2BCB7;
	Mon, 18 May 2026 21:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779139586;
	bh=craoMH9LKPZzGLbdZd4GcmZZRCr46NEKaE9rY3LvhZY=;
	h=Date:From:To:Cc:Subject:From;
	b=rzeeeH/Bnc4B85UElGc2hKOamaIGMmB+copbixUZlouZJwnq8MGJAqC2Mgtp0Ti/u
	 /hh5gdR6/c+NY5d5nzB42isKzYkNAxwZBK2AlUCgwPfh1301Sfs9VATk37EBZA8Vjl
	 a1Xihf0vm6mA/o0ix3phOj38cM1nK0C7UTrWs5XubodLdm12Xn9TSkolb1662EyyWP
	 RrgwiynIrR6soJO2wOWiyCYhUOPZ0D3Q6KeKeq+kzCZSE+ljn1qsRNirNk3Q1npscg
	 mre2KKK5j5N8fKXs7Kc9tDGZTzMQk9q6pThzl0kgX7ShntCYmaiCOAcq9dsHZW4nxm
	 bvXciMWwXDqRw==
Message-ID: <e3dc73df-0032-4e71-ab80-21b29c6efb46@kernel.org>
Date: Mon, 18 May 2026 23:26:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [ANNOUNCE/CFP] LPC 2026 Kernel Memory Management Microconference
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D2D80160011
X-Rspam-User: 
X-Stat-Signature: besdtrzfjkrs6s5zrh3n193yeqpdqjwg
X-HE-Tag: 1779139587-864637
X-HE-Meta: U2FsdGVkX181x9jjUYVWCRytYjpkjpBbsbM26cauGMqoRTYRHUSzQANtwQWp1RA4JsSP7oeZvatTgveYn8pNp205GymvbDtqiOQeun9NcJniYuYW9yM3slANO2R+pq6ZRU6VO4KMhBX/OuGw9QIf29ZFOtMhe94VdrZBL7eKSOAV3IIMdonZ5w/vLI8qzmmI6DLdLTJSghS2E00DTj4q7IKVD1QbvYnsPQkcFE3Gljtix5jg89NX8syFRoPfxMgNu8SWEF840KPQeVItZhuhbWM3MOBuRtviINYBKCJlqmLjXQDZ6K15OQepHHzUBeLlNVcs9eT0/S7rAwBEWTjCYSg7NN4nUwrN+qWuoexyeC9aKF7PHOemv97+DgjXEhfRUMfUsi6UFY3Aph8txovF7qdw3GjNL1+2CCVmA2L52EI7UIckGsrHToWp9wIb2CUzxZ4dVhw2BOhXW8df5YAQFK8UWM6uyFUnTGkioZtxy/o5+gjQn50O/v58YWFcaVW4cioqcBpuNW3ZYHh5Dl+SJz0WeJtlEzP4I/cMZbWK31gm7RWUauTC4H8lBKArAWNTLr8RaHBBPZDJRAmh4HlNqzEF8ml2ZKHU1JIerzToKk4GHU1R6zCXjrdO2lwQ1+15xOnBy+Ghl+fRyzMnV/6VKP79lACJR6NP5D6S7AGXTZeJ4s5GKZ1pA7tRy69hjOmBxzQPpLNiGpalYAPToH3wil8mrGdjOokmDq4x9SfS19XJpEwfOj7KnsKtMrx57nbgeship0lHHbdj0hzblrIXppEZFkzPePcaxX7PCz2TDhRp82IHjdCpVmNKIqOnL6+osll77e2mzHmvokADUeE/3MJNR4v+UcFn04c6PN9kgAIKrM8tE7ClkKSpgoqLMnVd5MqA8sOsxA3C0oeZAb0BgtPF5I07aKwJW3nNORTuTBVzmCsPrrhvLSju9sGn8Pzkf7Efhn9RsZMs+IEaAry
 S4U0aWPH
 DIfO6CJCkpAKTRksdftIgZRU+dJNrZBwYS6PlFzPE5s7p8+sgbQdjJQWzGrrnnmpLXNpPr+NE5YQyL6olExzr91AxdT/ZURykcpb47MYZBXPCIHdgrxaEFiNvohkF24inac9l/XIU4V2UlpPKh/sjVjEFvtAxTewmwGNoQafctB+KGa+ypCzcBxKiHotf58c6d4sU3blZVhm0gA12BNto+15No+zmx8aP2rbc3DxeWQSe5jx5gckrjyJXK7HqrZ6HisYdMRjqaGGxmTy5SU1HCW9liyZ7BBd8B4Yxh85wO/MOT/YntGdHsXj1XVu0rJLei+sxps9x5jsdnF3QoQtslXNXhcf1wenewDl/ielxSzusLNkIBU/LcJc01eSPWN3rYlAf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

We are happy to announce yet another instance of the

	Kernel Memory Management Microconference [1]

Co-lead by Lorenzo Stoakes and myself at the Linux Plumbers Conference
(LPC), October 5-7, Prague, Czechia [2].

Due to our past experience with remote presentations, we will only
accept in-person talks, unfortunately.

We are looking for topics that would be of interest to the kernel
memory-management community.

We are also interested in topic suggestion from outside the core kernel
community - if you have something interesting to present related to memory
management in userspace, driver code, architectural code or anywhere else that
touches kernel memory management we'd love to hear from you!

Examples of topics that might be worth discussing this year include:

 * Making (m)THP/large folios first-class citizens
 * Supporting gigabyte THPs: allocators, compaction, policies
 * Better policies: applying eBPF and friends sensibly in MM
 * Polishing memory reclaim: making MGLRU less special
 * Ongoing challenges with memdescs conversion
 * Can we make device memory less special?
 * Letting the kernel manage special-purpose memory
 * Improving page promotion/demotion for memory tiering
 * Challenges with hypervisor live-update integration
 * Towards deprecating hugetlb: mshare, memory reserves
 * The future of swap: missing pieces, cleanups, and do we still need zram?
 * The future of memcg: new resources, optimizations, and cleanups
 * Doing more with less memory (RAM is getting expensive ...)

Please submit your proposals at:

	https://lpc.events/event/20/abstracts/

and select "Kernel Memory Management MC" as the track.

Please submit your proposals by July 24th to give us time to schedule talks in
advance of the conference.

We greatly value interaction - talks are meant to be dialogues between the
speaker and the audience. Therefore, plan to leave AT LEAST 1/3 of your slot
(likely 30min, tbd) open for discussion. We intend to be strict about enforcing
this :)

Please ensure your slides aren't too dense - people take away more when you use
fewer words, and that also helps the discussion!

We are looking forward to your proposals and seeing you in Prague!


Note: make sure to register early, ideally before the announcement of topics.
Usually the conference organizers ensure that all speakers are able to
register, but the conference is very popular and it's been a close run thing in
the past, so registering early is the safest option.

[1] https://lpc.events/event/20/contributions/2337/
[2] https://lpc.events/

-- 
Cheers,

David


