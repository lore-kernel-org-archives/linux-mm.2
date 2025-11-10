Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6936CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F21F8E0008; Mon, 10 Nov 2025 08:18:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3288E0002; Mon, 10 Nov 2025 08:18:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED36F8E0008; Mon, 10 Nov 2025 08:18:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D80748E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:18:33 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7301E5D4D1
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:18:33 +0000 (UTC)
X-FDA: 84094751706.18.97C98D6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id B5581C0011
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:18:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762780711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e61PmBuBpKPW0kEFbYkXrje4f08ptI1Bgty+XwFb8EM=;
	b=6Bb/uvWcpAPRwY4/Wh6uJxgPierc2k5lJhhDDiWbweR1seEFLZ0iPlIEXbud676Skiq6Hu
	auul4xbMplUoag/HJkLumZNT3/scjfELREDMAUWLj6pr4kUxs4eDlQw7WWjr+znkBmBMW3
	9SE50hRyIgDoEL4ef06Vq3zPHeuK2Kk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762780711; a=rsa-sha256;
	cv=none;
	b=Ih4OgwxnkgJ/KLmWsPVuq834DYUpk3SvrWuiAMMSzNDhBk2vD2MNqjv4nlaLm3S8q2sd7U
	YAiiqmvzWErN9LeEMDwqhr9Lhz8AHBvyRCGlH6tDLHJ2JPPB3ge2uQJqFND5QnINRT7HmE
	kW4EO6Ze1EHeVKWPdTtEqjcw73PhgWM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E7B25497;
	Mon, 10 Nov 2025 05:18:22 -0800 (PST)
Received: from [10.57.39.147] (unknown [10.57.39.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D493F3F63F;
	Mon, 10 Nov 2025 05:18:22 -0800 (PST)
Message-ID: <d0ce35ad-bfcd-496b-996d-17e59a1d5a73@arm.com>
Date: Mon, 10 Nov 2025 14:18:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/12] powerpc/64s: Do not re-activate batched TLB
 flush
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-mm@kvack.org
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
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-2-kevin.brodsky@arm.com>
 <87qzud42n1.ritesh.list@gmail.com>
 <b3e4a92f-5b51-4eee-bfb8-c454add0f0d2@arm.com>
 <87cy5t4b0a.ritesh.list@gmail.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <87cy5t4b0a.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B5581C0011
X-Stat-Signature: bkdw93exxjcryg5nr868zs76qt7cmqf8
X-Rspam-User: 
X-HE-Tag: 1762780711-390322
X-HE-Meta: U2FsdGVkX1+EFpWKlHhuFabOWWr/Su4pisr8kOFvm3rbzVu24QaTguPkq0iTvwI/wNnLLWWbPb5eTmw1ShvErrRXmDkhARPR2JFf1n1yMKNBEo+oFgfBTWQi3fgy7TOxJU7cCDsOGqwvwU1aPa5u0/oL6uJYWfn9/ojCtFZ0KnR5PYKQ7yarrPP6fbP9iuBWtuAkFYHHzC1Qg7R4v/871JA81PnVmFmP5WDS9USj9QhHkzbsrsQIeWG45f1/fo58xMRmT8ZpQks1rUkQg41p5staSujYCCU/SRiQYl0d196kmez9A8lXWbnr+eAcitqOO+Xs7UXuNlD6OCnUl4DEFTWa/q+aIufkE9aJdWuws4rIDBq28pGDsxyqdaUESSR3Fih9k44H6StQ/kQuD9hytLXG0TMh/dQ6L4VTdYeHt9ukjW1hdQNVG2vFT4BRDxy+uSRkW+gbuF3TiOJIJsnZrnSZzcQEpqI4/LtdIqVnzrlDUqMrCMjMh/5ljNyVTBJsfzb+I5VTmzNL4p3IihDeDAGDsGW174tze2Mgr2tJd2DkuKqYfycrVjZTDqIszwwHy9U3DsZF4QBWcmckC1cUQSYwSF80a8Lx0X/b8szfEIdmyRT3X9TslpLU0NfA8r0sEoFw6ikLQjhIR2NWJ+1TtIi9RsATLw8yfS7xjvizZd/sXCHM2UIC3DTsRR5MWOkqn4IT5QlJnA9ER5QbUZN3GfnUHJV/v9AakyY5nDLk4evCVZv0JpizcEt4roXew3+YU/U5aet0vjm8uXz8hk1fD3Sh1DJd8khZxbyPLgb+75EUSGyrU9EvlU0zUhdrMC2cidg2wTDoGd0j6sBG49Y9W2ejrq0J3kzzLlOLpMwnoVAB9U1aHLjOP23LC49Rzs5eE9yQveMuiSl9jW6QVdrRDRPYkMF3KzAJlVby8KtTK1Xw5Ob/IWJeDtBSLAWTKD9I79OsezC1+YlJ64bqDwU
 EB9kf7c7
 mS4eFBMPzcVKecNP1Gs9lXT33UA/HeMQJF4DvRzlCGwnMsag8Y+AtbpVSWWdJI7uXgpyzQjy9YNsQQnZeXqMad2Rp6jsiQV3kztq2glnXhw3woJZ1vheog6RoXtee1xk/3lykgU94VL8hBcALcfj7rpWIAv12Eov5z8ai3DfiTi9xb7EKGh57oDGR4H58JJfFt6RABi6tciPWffPOeuL0kXNyMnjtKpCwx952Raoqnk2/sSFOnadxFuhWMZ00z6bwNZAzyhDhSWZ1QlEYdXaRb0T/mKGcoM6iA+lAWHsV1TqLus0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/11/2025 00:35, Ritesh Harjani (IBM) wrote:
> Kevin Brodsky <kevin.brodsky@arm.com> writes:
>
>> [...]
>>
>>> With this analysis - the patch looks good to me. I will give this entire
>>> patch series a try on Power HW with Hash mmu too (which uses lazy mmu and
>>> let you know the results of that)!
>> That'd be very appreciated, thanks a lot!
>>
> I did give this patch series a run on Power10 with Hash MMU. I ran the
> following stress-ng tests and didn't observe any issues (kernel warnings) so far.
>
> stress-ng --all 0 -t 60s --perf -v --verify \
> --tlb-shootdown 0 \
> --fault 0 \
> --userfaultfd 0 \
> --fork 0 \
> --exec 0 \
> --memfd 0 \
> --numa 0 \
> --pkey 0 \
> --remap 0 \
> --vm 0 \
> --rmap 0 \
> -x swap,pagemove
> (Note not all options shown here will work with --verify)

That's great, many thanks!

> Let me know what else I can run for validation?
> Do you know of any specific tests for validation of lazy mmu feature?

I don't think there is - lazy MMU is not supposed to have any observable
effect, all we can do is exercise the paths that use it and check that
nothing explodes.

That said it wouldn't hurt to run the mm kselftests:

    make -C tools/testing/selftests/ TARGETS=mm

Thanks!

- Kevin

