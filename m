Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE2810ED679
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4196B0096; Fri, 27 Mar 2026 09:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5544C6B0098; Fri, 27 Mar 2026 09:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442CD6B0099; Fri, 27 Mar 2026 09:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 303ED6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:28:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD078BD691
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:28:14 +0000 (UTC)
X-FDA: 84591921708.24.1561B73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 13BABC0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:28:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tgrKpze0;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774618093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9E2RIt8Jwl2ayOiSZdyQkptXGhUYEZZl1BldzCpWPog=;
	b=Qd9si/0dbuBO0lZd5UEEmB4/3xW7s17zsYhsalK0EDB24Yv8/KY6eiSexGztZleCdz9oTi
	ByDBIndt14aYwkSuRisn0DJZCHVr0byje0zQySTK3M2ipgbVY7i8iCIlKlYK8Ld2L8RufN
	dcc8yb4CFSmsVgPoaRcFhCu5BOkHO+Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tgrKpze0;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774618093; a=rsa-sha256;
	cv=none;
	b=MXejCphpizEnyfNSLupz8rq2l3NeKT3ltSc+imC52N3mxiyGHvP9F43MazybYlY5JqSeK5
	M3b/Ppesbljd7/ACVzy/3iRR9HnqX/QlVT02ChNC8UF/OSbRr1gDYw0Ex4rXRvyJigihUg
	Dmm9Ef+1/pHD83uERYCog/Y+qP/gTEc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3ED7E60132;
	Fri, 27 Mar 2026 13:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE8BC2BCB1;
	Fri, 27 Mar 2026 13:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774618091;
	bh=r/tUcr+DkmKRuSoOmSbqzMlOOVTDeN+O6HtHU+Chplw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tgrKpze0AXBEQbD7udKzYR1/j6AEhWlQrKBma1DiYfButx4464/hyCJcpP+ANo9Ap
	 by/AS0qYxcLqBUSypREH+SHXOKATURaX0us8v4dfKQqXxPoButyOG+KhsuWNRvIeUu
	 OT9CiE1BJhUnl6+SEPyLb7rKdCHDRBxPXMjA0DrJamezzubk415mrPedbFHfjZqGzC
	 WAikLjxtn6QB+XzNf1gAfc3zcEHDvFYphLENXO0NWxG/whC/a3SsCFy4iU7xdizwV+
	 Fd9Nkb17vBj+XSEUZMAIgu5KYakuf0xy9AC3zv8wEWxsEuZC8T/dDcIgvobE8Ac+JG
	 PHIaX9JpLlSeA==
Message-ID: <2266e9af-ce5b-401a-8364-0fe2fc3d68a6@kernel.org>
Date: Fri, 27 Mar 2026 14:28:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/6] change young flag check functions to return bool
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
References: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cover.1774075004.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13BABC0005
X-Stat-Signature: usg8qha6ga8jyiumtunf5km8ht83ik8k
X-Rspam-User: 
X-HE-Tag: 1774618092-643014
X-HE-Meta: U2FsdGVkX1/5Kxtkqri9id6Ne6SQnkA0SAJZCLIORiAwJBHpfMXv/XMFHyroeiV131xXnbdBiqb4/fSoVes26mj6HE6ui3iLhq6TH8Aht/ghV4cHb1qt971b84aT5XqtKuhYC6r93BXERUkPjH0ld8dL2PeBOiB0JbGRJrj7QfX8h3bCnzcBeu5FpHGgyFLtnhcRwarUMsqrxa31JrUQ0nQp1jTliEJawWBTbgBTnDLf6kIE5sUUh+t+T7DiYj5Mo1lpcAhXLSrV8vKGZGotg5lh4AYDFLs6ru4+9pcvcHJKP7QCdzcv5ulm/HRXUVZjRZOYLEQul8k6ylXjZRfUXODJb7yvduNuMdoVv6IS/GGtFoph1nAgynNTnHNQ9hGd3DVb7lA8ny63n/hzwOTOUnWtFJXEOZEhhDuZM4dCZjDuRFdBy/XVcX9If3cJjSOMOWfXicriDSAWozMIdM+uYhQQ6HI8XLboqPhZuOixn1HcbGko57EYRNgkJhUWo8plsm52GMkeoGmcLWCmJOaCuuIM8kEeonMFdJjgOnJo+V3+QTH0LmICG1/oEvkWm4ZqVPhHp4kfoSbBMYYb+Kw4MOcnIhXGMGkvJU9koC84XaSmg6RvwVW2ubx2PnmqTVHmVXK+fXlYWGQncembZUGKYUdUcXUv6xL2sqoNl7hL5Fds88vz8q4tcHiXdHOn59ptJIXR5MIfWT99AIoXhEKB0exHJwEnDGC/LuCAqugAiZjPlEdxafQbFnqSjHJ1hGew7sxC8HRDAOUAMSUT592IKpLU/LNAi4p1aQX6xMr1GgixfXuPEk0tm1f8WTao5PYJFTwIsdlPU38kHCWeEYySXheoENNDvgrJtypN89nbpzz6/W0gDWwvl6tzGtt3Ao5Fx0WOcnOlESmeh0lGgHyTLBtot1kP57El2KVXnoF5m2ClhbkTcMeAguvTr8lxQUsZuAvdK1XQ1l35QPDZo3m
 8cvdXk39
 9bfnAB1O9csE3XcD+FxWBCe62HluEO4CD9mnGQg+mV4MMlpL8Lt/Fg2ZAVc+8DMzcy2k1VNtFxN57Hji0N41our7Ldc4I4fkOxvbmmZLGIsNPAipSZpvhjDXbofDrzoi9+MEVxz9mbjRCFAX6udjb/ltpOJ+iYNxgN5sa0nAB5aqu2uKZp/Rsq9B6sqWvM3DP3UAYyvi5f6b57TdJA/5gDR2Qi7tSewPTtwygKEc8dS8BioPI6rEyr9Rml00tQ74uL4mapfvA3lPIpcZ3mUldUZZzaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/21/26 07:42, Baolin Wang wrote:
> This is a cleanup patchset to change all young flag check functions to
> return bool, as discussed with David in the previous thread[1]. Since
> callers only care about whether the young flag was set, returning bool
> makes the intention clearer. No functional changes intended.
> 
> Ran mm selftests on Arm64 and x86 machines, and no issues were found.

Thanks!

For the whole series:

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

