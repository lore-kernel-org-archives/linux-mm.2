Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1848CFED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553AC6B008C; Fri, 24 Apr 2026 14:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504A56B0095; Fri, 24 Apr 2026 14:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2926B0096; Fri, 24 Apr 2026 14:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3336B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:36:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2A05C16CF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:36:31 +0000 (UTC)
X-FDA: 84694304982.24.3D849E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2ACDD180003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:36:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rL1BpIwr;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777055790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V7mJO8UbhaUrFHsEF95AZIBG6a5ynIYZrhw8uopWdic=;
	b=Op88fla5ULQ0a+wNaWAKCIVGVaa/MFSDenHkXOJ7X3JD1zvy7GphyiIUeVvV6yxUcM1/ci
	DRKi16D0groV416oBWZBFblNoOR5YnoQxlH0jyOT7JX6KsUOROiejKTn4E92yf8+H4V7KK
	BcFlwGQZjxR5XEO2RcA1UsHTVYxIVv4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rL1BpIwr;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777055790; a=rsa-sha256;
	cv=none;
	b=jEHqulIVAezF77jgbknhBS7ofVrwNUYnng9RrdkDSCw5VW9HwB8QrJDyWVxv6VDXejdhRB
	jU8ttUD4UvXii8/HISVfySGfRIZ8Pvz82Q+CT+nQNMhp9u81sxl3a6Dvaj/97XV7r+D8mF
	U/pyGjslP2Dc41uaGAJNAIVT+IHMDm4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 764C1600AE;
	Fri, 24 Apr 2026 18:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AD4C19425;
	Fri, 24 Apr 2026 18:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777055789;
	bh=L4jbMDY27DDz6+DS6kI4Qsu8AZq31/9+/cVOm1CDF24=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rL1BpIwrTJNAvql1Vcp5x5Vv+xdwUtQ/JLUc71lzSiqRWO/R1/Sd2AzOoI2+qMGzz
	 qAp1pSPvHgAFPeeZGcoIj6VYUoHG6TqWMrHXiBb0xqdx1bfBQ0559ZX6TxoJ31FD2v
	 UXsObbvodX7PRYHBDe+Q1iG5pThWfqknVK6Dz2H03FAasVRv/640v+maaFx/sdGVbS
	 DQpJEpkLiOyeuP6v9X1WoKe2m/ciWY3uTuodtKnxLOO+OlC+uqjAZghf/KHYn1Xkvl
	 OujMFbWOYaPtf0W0etm++tRK65YxhknAEo0p2wcUrMqHAb6WZ1LjTXZGYcXhFMFwMX
	 NbYPyoSa9Tx7A==
Message-ID: <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
Date: Fri, 24 Apr 2026 20:36:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent
 them
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
 Lance Yang <lance.yang@linux.dev>, peterz@infradead.org,
 dave.hansen@intel.com, dave.hansen@linux.intel.com, ypodemsk@redhat.com,
 hughd@google.com, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 x86@kernel.org, hpa@zytor.com, arnd@arndb.de, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 jgross@suse.com, seanjc@google.com, pbonzini@redhat.com,
 boris.ostrovsky@oracle.com, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com, roman.gushchin@linux.dev
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex>
 <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
 <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8bezoj7runsbu3pcckujomhm484mz3oa
X-Rspamd-Queue-Id: 2ACDD180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777055789-861931
X-HE-Meta: U2FsdGVkX18t542MYImklKIj6Z3CzGikIhCEGpOPNnpmUeMhpaRcDA2/RqBAqrGmxceaDqWm0ZkI7oWxKgSWvGZHUbRFBVetq/e0m9/PzGTekQTdYxEBMGuB/gu7lDFk9wrXDtiPaVFU2FlRIcKnjzp9m7echRROViEA0LfKx0fz2Dt1bJcA4R2w6MdN7Jh3prssGH6D3LK+5wn0gQ2U1nXYbFjAfl2IMvEOVS4Ai7FEZFz6CKfSN6NwA7H4m7fm6PB1+wovXBc78EqLmhjUwikYlhzIFV+XWQl678yhZXqg5C6qEVkd17qJmqdcAKrO+SUPcMqp2dgDiuDdksieYmHLRgMXoR226tRopXNlIs4lkjvC14Sva6lqCl563t3uhrdeESZpZOYfKYqM5PZyBKjdwL5IXis6k/5kaELGVSFVdgNa9WB0nEE3MG742tEGbIvPgHsKf/wOAOmwv65OlX+Yyi33nHRjDd3StxP1u5l+tdxVmgoGHOKYgqYN32YdNI3jnaf0PRhrtV6RdOMwQuytu1uxdJK7+3pul8puIi8913HQZzO/mQcsBenbJlsOIoBUqJz4NMQCi32AkEmo60FcXMEgyr9Ezbnge/6dEYFF6rh4gZ8McVHqpI3Nk3decuRpjUbDoMjkSoEZ1v7i9M7JIjXm5KfMSBIVgk6MOyGmm8JoIkldwEJaDFIRaradJQfYSKl0ThzK3/RQk+QqwcpBTrlekIpcl2e5mdnSyh1rtD4cp39n9c/ozSf2agbaSWrJ8GkBLM6u/ZMNHa4qyIJPePN/cSxuk2hW1cQ+4zYJf3JMSB93Q7/n6DdxdCxNpbIF/i/wOhg/nGm04VtjDnecszlQMIZYQpyVAPmp7csPDlCZNB1/fvG3upEqOvumZOVtrTKQcF1OweS6+JIet/BwLZMNmhbv5wCVTKHxi5k6g3ueltC318GS1j1Zh3yFrKnPJsktgzQQhz5QMbB
 EArPuU1J
 ums0o1Pcwrvw/wOv7vpUjlZ8B81Qu8KVCkFCYUD20Q62i1Wqia1qzn8WmBZd6hfl076A424OpHbZw68XhuVen3DYLr1CxgjRaDedZ68tFJhGgH3JKYVBL9rU4vuhT1/7lLd8lx9hAkWLrcLcVYvQVtukknsojHZDS6x3qinYuK2XOIDWlHLdaosWOmb348AJKtFwgsRwrCYtpm76dbrLKS12L0NUw3jLVAL7vDZ6VYRSTQrks9CKr+Znf+P0obyyOcZN7gYBbe26eIs6MY8oeKMuscg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 16:31, Andrew Morton wrote:
> On Fri, 24 Apr 2026 16:20:55 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 4/24/26 16:15, Andrew Morton wrote:
>>>
>>>
>>> Yep.  I'd be OK with an automatic reply-to-all.  Maybe some won't like
>>> that.
>>>
>>> An alternative I've discussed with Roman is an automated
>>> reply-to-author with a cc to a dedicated list (we could use mm-commits
>>> for now).
>>>
>>> Preferences?
>>
>> Reply-to-author would likely be better as a first step.
> 
> Why do you think so?

The most important part for me is that authors are aware of the reports.

Sending them as a mail forces people to publicly reply to the feedback, and at
this point in time, I am not convinced that that is the right approach.

-- 
Cheers,

David

