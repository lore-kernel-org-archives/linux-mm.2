Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163DACCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 10:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CE068E000E; Mon, 10 Nov 2025 05:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5FF8E0002; Mon, 10 Nov 2025 05:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2F38E000E; Mon, 10 Nov 2025 05:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4A08E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:37:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C910CBDF8F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:37:23 +0000 (UTC)
X-FDA: 84094345566.03.01BC743
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id A7ADF2000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:37:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762771042; a=rsa-sha256;
	cv=none;
	b=j4fUMw3mc98St350zdgXKd2ickXsn1ZCu48si6qwpvGTirmg+Cudz/QokeulIdvIsBFSFa
	xu5BADr0EP7mIWjGtK0AHzl4mxoLUeSq85UTqQ3Tw+MV0fJyblF4Vnw88nE/1tYGtxLSfe
	oMGMWaKDZNPKWJaEfTtkBG8IpQToSE8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762771042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wwdS1VB3vgYSOM1P254K506c5LfSj/vi1RAI9w6ktio=;
	b=lDj2i6uJVh96Gd6Qxc11jQBK7JOZgD8/qZ6MEmCuuKe7lQEhdxdIj3oUlZvVGRO4kjKgEv
	dYm95j2FKWeGUASeGRm4qynL63ZZk9IZ8kOGLiJibMCWV/JdfihqT8gFeQby0mhT2ZdPDu
	yHi+pdiyCTOUYAQEIhlYnmE7yk4QpWs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CEEFE497;
	Mon, 10 Nov 2025 02:37:12 -0800 (PST)
Received: from [10.57.39.147] (unknown [10.57.39.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E4913F66E;
	Mon, 10 Nov 2025 02:37:12 -0800 (PST)
Message-ID: <b21fb5b9-2e7f-4cbc-ae62-015b1317a9bd@arm.com>
Date: Mon, 10 Nov 2025 11:36:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] x86/xen: simplify flush_lazy_mmu()
To: Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-3-kevin.brodsky@arm.com>
 <b165098a-8164-4664-aaaf-1e8c4391d797@arm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <b165098a-8164-4664-aaaf-1e8c4391d797@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A7ADF2000A
X-Stat-Signature: rmwbfnwz8oksoruig94cneezusw3qiko
X-Rspam-User: 
X-HE-Tag: 1762771041-398327
X-HE-Meta: U2FsdGVkX19jTq6KXUVHAYUeQWuAV8DHetQqBC+oRZlqWfUnbTQmoGjks6tEckL4nCNTFzWro+q7ptUMhzDDlrEYdOUFqUTvSsUsH7E4pZboHMrkjchbpBrNRTj6PVZRhBHejZlVIXCNYJqUt1hwgJLwQyNQx3q1yiWI50HJE0q5GkjG+FgMg3apisgL154cvL4wlcZjnScHmIvZFLzA7l4jjjTrqBZXWKtA69Z2NPTOSy+uHheIZ3OvjpJtZtZMbeZ3MabcGrcd72OTG1fmrKUDVtIw5rZ5JlQ8yVSPWHzAkkxqrZ3WwbyqmQBcFMvMzZYUVO+GN9QJtYaS1KoOQehVU/bJrCzhDp04q8AL0bj/31qnjyX+e26eUaaoF7ZcyAoYWfnaDJIC+ery+4U9KzKQcDt2AghLONdy2lpmlobxrIced6gl6lTUrh7x8GKWRzPy87t7OC1tHqWvtodH57uq9+/lZCXqZfMEe+8adNBcfVqOqim+ofWl1I2PVkDxwRuB/JPEYBB0MOp60Ufwog05h/jHW/jyq53OZopUdtVJHAYxx5iLZiKJnzGQpz6oYgTIjHIyYG70gOTltkyWLrXehLKqTiGjcZvU6dq1g2HHg7y+/A0xlCKgcJ1Wq4HwwfchvwIHG9N0/r6QPSrT4EM6a/iqQ2+MPhP6128fctGbRhh2swt5pribVfoMBDuh2+Ov55AKFWh/Fhzjm10ZRZ/8XxfNcOuz3LK/xZtBjEk901H4rCEFJ3DCInQV2shxfNB1rYMWXRLVS2E5AiiqhE0rR7H8WeAR4F6Y1vpnjXsGJYcYGiyx74knbRKVxlaRNQp/YotjyUUsllWCAt0/XSjgS364E87DZQ5c5i8czAZEDU9wsi6EVSmllPX3kmY+H2qvGJXG6a3fxpunZnkk+Acx9UB5wplykku8zElx0Gn3sBn8A6jiXYWY6ZRPtTonGv96TLCmcKLxenzH79c
 SKK/Z9BB
 fkaws6EtjxfPvSZBAiQVlR+hPrpTVgtEXHhVG4PsnRB9w+HJwwyIUa6p/8/A+36Ce2LeJV6dB8g+10BI8h+ngselF09OxlUroG+8Og0oUq296th/2AmaBe+yr9HPubvqRFj3myLOJeCm107Z2Mam58jcEbDD8EzubEikh+BIJuO6/QyJ0ISJdx+f3v2+/yAsMmykAr5ZUqmsNf0R6ZkDPMJbx9rv18pX3fth9drsKBva0Bwx+ICW5ALPYBAK+ooob+OBnyRgabdk/xmk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/11/2025 12:31, Ryan Roberts wrote:
> On 29/10/2025 10:08, Kevin Brodsky wrote:
>> arch_flush_lazy_mmu_mode() is called when outstanding batched
>> pgtable operations must be completed immediately. There should
>> however be no need to leave and re-enter lazy MMU completely. The
>> only part of that sequence that we really need is xen_mc_flush();
>> call it directly.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> This looks functionally equivalent to me, so:
>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>
> But I don't think this tidy up is strictly necessary for your series to work?
> (perhaps I'll change my mind on that as I go through it).

I initially thought it might be, but in the end I think you're right -
it should still work fine without this patch.

Still, I'd rather avoid unnecessary calls to arch_enter() and
arch_leave() as it makes it harder to reason about what is called where.
Namely, keeping them here means that a nested call to
lazy_mmu_mode_disable() would cause arch_leave() then arch_enter() to be
called - rather unexpected.

The only calls to arch_enter() and arch_leave() that are left after this
series are the ones in <linux/pgtable.h> and the Xen context-switching
logic (the one case where calling arch hooks directly is justified, see
discussion on v3 [1]).

- Kevin

[1]
https://lore.kernel.org/all/390e41ae-4b66-40c1-935f-7a1794ba0b71@arm.com/

