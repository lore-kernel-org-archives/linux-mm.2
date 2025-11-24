Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F18ACFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 14:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3AAB6B0024; Mon, 24 Nov 2025 09:11:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B119D6B0026; Mon, 24 Nov 2025 09:11:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F676B0027; Mon, 24 Nov 2025 09:11:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9464E6B0024
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:11:04 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C0741603EA
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:11:04 +0000 (UTC)
X-FDA: 84145687248.02.26F6D97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9137840013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:11:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ToE45XUa;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763993462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jSkF3ZRD0txUuUowRzgmTMI1fvINIcu6kZL0IrYQPWs=;
	b=go1plRHfpyyov/ixzNsbrnt0MmMcqHqYPoPl/U7Tlb88tMHlDqvc0lQwL4X+da8pjb1LcY
	T2YPiRI4ym3UAamJOm5DlQPCQgyzKVOb94cIAQGiEHthi7BSSUNRBSFg8tj8rBB4GJVyGT
	bgb/2GYYwx5yjgQ0NKQ5IpQjo3ZuKvw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ToE45XUa;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763993462; a=rsa-sha256;
	cv=none;
	b=fBDJRHMpiC/8D1G50zR/ryrn3OxT6k9tqLBqctbqQ31xFrK7CbPD9f6atCXFIXB2miM0VJ
	qRttV34FfVRZJjigY3XuX8V3uDQTVhJDWu3iTr1jCSNJ9QpxrWNhq2NE/g/xgkmoBVZsEM
	K/NoJYhmC0oQ5D/U89SdEuWrKq28SB4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C0786601DF;
	Mon, 24 Nov 2025 14:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6DAC4CEF1;
	Mon, 24 Nov 2025 14:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763993461;
	bh=9kXuey4j1iyNfngrjmnOHDtQji8gClrywMZaIofSoSs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ToE45XUaNEKKgD2WXInctkwlv3+HBQ1TWbbC/9sEmPQZUN1wYevCeBRVBAV0rozFL
	 I7wUvi5bxWcACKzxrEjR9VQMVUyaT8qQ5kFVhrVVlB89kgJUI6qWdrkHnaxN18F/OQ
	 mF0tJs2Sp8oYTUiLgE5alNCnrBVLa6AKCyHt+H//u0eb1VNFNAFg7+La3UkcsIK7YK
	 bQXVkMezHzr95Qf3Ef+lnUif4ZyWCABBRpSmPiFrnUGowf1Rr2Xo8pRrZ38LeAit4M
	 dcuirEqLwFTeqTAFHiWTbkf/ytXN0PIulzMPv+dkinYGeRr/hIAHNbLek15LEi+dsr
	 2rHEM1RGj8ISg==
Message-ID: <ef07b0f4-1f77-4c6b-9c67-8228632b1fec@kernel.org>
Date: Mon, 24 Nov 2025 15:10:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/12] arm64: mm: replace TIF_LAZY_MMU with
 in_lazy_mmu_mode()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-10-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251124132228.622678-10-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9137840013
X-Stat-Signature: 9hnzndszxnketjso8udehwk3zzq5qsrf
X-Rspam-User: 
X-HE-Tag: 1763993462-961678
X-HE-Meta: U2FsdGVkX18FOgAAAebmXHZTzws8v0CI51i/GfM9LL2k8w3IvxLb9hLWaKH9L8gBcwqEjyU88C3wl9ytG4Sg5h1lWd6My21oEc7JcZKKOLBiWfX24o6vVt3i0z2HYa/+yu8DZKHKLF4gmurxuvERrVOARweXQOr+oY6qKUqqsd+97m+PEKMBWeZuWUU5iZg4nTPVmjL7eVxTsyqZNZiQfzK/dXiEcJqccPjksztAT8RE4ZT5Y7YTJNETTb2a+byY6ZVUDx55KcvGwHDAc4KJAdZ2HRw3zsY0mi9iBk52rGX5ouf80JsAqXccZgn/FqLtL8woUvTcjn2ggMDXuWQFVPyKQ8lwG2dh8UhbGJy562JG4+ZLW7Pn9WXcOo1gu+7L315V0NRn3/Xdu9V6pGSaOqHSpjZiowdTtoM5REExTuVr1eg4QSAQ9FIhgNB3l0CF6JUL9ezRoeJHBVnLZHOONcZBWVgntszszCe5kyH/FaSZcvl7Zpm9GXZMd+Aph21BrD/jpPcHPE0DnImv+pMQIbbjX2mBZELZlnokszSTlWpjRlQ6Qe0fJe7U2DCMmdfbNJzRZgqGmmeUwSwUVs4suQNtp/gr+2XABxTvoeFeb7mJP9DkyjsEqLS1WhaymdKbRJH7WsUC1IeeLoAQi/LY8hDDAILSQmEx+8uFt7dicNcMmfP9KCadr2+VaPsTUWvuXJLqhzB/vAIy9DnYEg/qsF+sogOBWcVPmDmlSxEjbwnv7qJ/GfNZ6K4tXuidYcUk3B0vohXxgu8kXC1uTG5T1gO72xOivRzXa4KExD/MgGQs0mXzr6GMnXDLsJmWZDDFSsOi0rcVMNz8Wn2BMgXZS7b0CVBQRwTBSyTGYcjetHkmIC7fqseqdlI2P+ZUze0kqCFAYLsezRF85WZKb7fOfUp4F/7v2nNCzDNlU/tquajJEshChUQki0FNy5gwRiMQAXINyAk+NSfThwEZmhY
 fgSNinX3
 xTFQuRlni78Uydumm1aEYn6cyY6OgRtKQTu6yf8HlO3ii7hbzifT7mVqJZYYso8Isc+MPVTXGyc+DG1ZH9arkLaYMTst+3RpI5Xao0Am+hRvrPAvRlVgdVHPnKu9sl3e/MAMncGmThHl6U4Eki6UY04UM0k8Ve8U3lIVljZNegeWCuifGZab0oLtVhT2WKI0mYt2+OzQAUQ32O6YteGDmxXlZ+EZ+3QE8fGeYGqvKcCvqyWd+/FNmyD30mSPbaUHsMhvDGbb52QJAx/P7ih88bHvew6pe4DH493Pn+HOZjMCZF3cLVWJEZtMbijad20AEGTs2huuwgjbE8D/vOrJktKsLD1UpWDtQZJnmkHlV4RU3NSUq/pMQ0h2rWQbXT5VW8azSicZqAerqiRtlnOUcdbVvpZR9vD7JL2PwY/BNrVZyoJY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/24/25 14:22, Kevin Brodsky wrote:
> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> mode. As a result we no longer need a TIF flag for that purpose -
> let's use the new in_lazy_mmu_mode() helper instead.
> 
> The explicit check for in_interrupt() is no longer necessary either
> as in_lazy_mmu_mode() always returns false in interrupt context.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Nothing jumped at me

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

