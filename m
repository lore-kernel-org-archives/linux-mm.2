Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A369CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 12:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91448E0089; Fri, 24 Oct 2025 08:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41C38E0042; Fri, 24 Oct 2025 08:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A308B8E0089; Fri, 24 Oct 2025 08:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88ADD8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:17:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49704140E55
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:17:33 +0000 (UTC)
X-FDA: 84032908386.06.1D525D1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8A49E40007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:17:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761308251; a=rsa-sha256;
	cv=none;
	b=Igy0rJYDjhBeKAE52BfD2UXRTSW7ELvBL1rhnFFc0MCi27XEJe9cPiv0TBKJVADCSoMMan
	qef0dHXn/esvrBq3yx6Pu5+UEFChccWw6mx9hSIjCmtKede50sMmfmHPIcKNgLZPhhm/ho
	azxmYAGYdLGwOgKi9OxwNPl+niSLTj8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761308251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0pqn941rf59LOhvD/M25wUPoVRtPWVt8BoEPjLcQaZk=;
	b=cIgJHWhhjfkCnuCDdrUxHRrAP1tHdsQS9pj987KIww7UUBq1bTGP9TDooJkHB/UjExgXmB
	DQWOpHcAWwsSJUGJiPfvPlhhTEuYsSB6R68utwCMP2UO8nvhtEn9FQPknz/GqrURF7oXHY
	bIVCm7nRjPa0y0Mwn78/if7d9JU0+zg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA3FF1515;
	Fri, 24 Oct 2025 05:17:22 -0700 (PDT)
Received: from [10.44.160.74] (e126510-lin.lund.arm.com [10.44.160.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 38C343F66E;
	Fri, 24 Oct 2025 05:17:23 -0700 (PDT)
Message-ID: <35df96ba-a004-4eb4-8d26-5935892a852c@arm.com>
Date: Fri, 24 Oct 2025 14:17:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/13] mm: introduce arch_wants_lazy_mmu_mode()
To: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-14-kevin.brodsky@arm.com>
 <3d6bba2d-9739-41d0-8f3a-f8b11620c33f@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <3d6bba2d-9739-41d0-8f3a-f8b11620c33f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: whkhw68gbjc14ii4urdokdkq1j85jqtj
X-Rspamd-Queue-Id: 8A49E40007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761308251-305657
X-HE-Meta: U2FsdGVkX1+vQl5KYEs/evNv2ICrefS9jQPLIJbKPqJfLXzqDOkP53UBFSr5nBuYB7771uDgVEaSQbLduoq9HRyfZ39XEPg5BYXoVU/Wsi+7hOugZVM3NkqAciZhjGVupliunEzYkJY3xNcsqdyxS9QVUQHQJfJUq/D3kj+qsy1/f6L2uz4Y4WFXciYOps7a85oMnImenHk9fW4Lp2oaKyMcXVTELYrGs2RANkGlUQ7UgRBlPMahcdvZ9RJR4EizT/30qlzEHmBMQMUhe8PlsCi/x1I+Ci6PAU6ChbbVJ84gY7kWNvkFR4AEfYSAyrmgzhwOE+LjcxGAqgFYx3HpmkZwawJHui9f7bOOC+aqPelRAL3eNwvJVyZErYo/J3m9Trvn9IVVcComz/dgYebABZz6e3H+QJLLNYbb3CXfARsOzfYLUSPa6GVwQeboD6URjV7l2tMIX1N+NuQDu7CP5rDtv1/yaCdgWKJo6XxP07tjL6glESzkQcJdxo5pOA3mvZC/WtHfsvRd+adOZjebcMgWPgNl5cSuEPP0oSDlkYQJ9pvwpn8x7A3t6TCv4QoGZX1JXWwo9VR7eXErSzd+7UBH6omBAsMt9k7jH/VmIvDHIECy/VAXW0t3TOINs5+mjgTrj1FmrPbpqXJR8pmC++MqAW/0gTY3NuyR6U9z9XOIaSId0XJFLP3r+hDwVDvOYPmGdKcmkcG2Jk+IwNhauIPxBMukyCWbL/g9Xg+Eu9VfOLH+JQ8zPUa2GSM2wvAisH4ow8m0zSGyR0nPoHGkeLPR55/NjdiCn46YsPxZWLW7MrUc15okUc6AMwWPcD6MwKgUBJ2sguW0DnR/qX+VbpIXAWCQXAyPb8uz2dKMwxLjuqypiyjaqEOkcYj/8VNpuhZEOXMuAWYLue44utwAavGPkgubpNhy4/7VriCxO9Y0vvclyX/659RvI35wVF2QwgZlCfg9dkJKTOubq3b
 vv3XxW9q
 BttFZqGSuthZNMuF7H0SGZSYs8BDVgKTJkb8KQ8/oBYTJVeBp/ejANqI2HkZ0l1OHo6oWcyimIHWXhGXST2rLUn8/NfM5W8VC+0fvlxWmOJGJLOHq0YUI1Rhf/QoHZLguBAnjS/vjhvxNrXWJ0+rU4ohrbTAMFyZ2mQB0A2wAIIAPy12vpGk5+ptF6E5lHMNpHPb/owZdCr7R7JuUtO+7fpzvb1pbaR8Izw5Ga3RQDWVhZwg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/10/2025 22:10, David Hildenbrand wrote:
> On 15.10.25 10:27, Kevin Brodsky wrote:
>> powerpc decides at runtime whether the lazy MMU mode should be used.
>>
>> To avoid the overhead associated with managing
>> task_struct::lazy_mmu_state if the mode isn't used, introduce
>> arch_wants_lazy_mmu_mode() and bail out of lazy_mmu_mode_* if it
>> returns false. Add a default definition returning true, and an
>> appropriate implementation for powerpc.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>> This patch seemed like a good idea to start with, but now I'm not so
>> sure that the churn added to the generic layer is worth it.
>
> Exactly my thoughts :)
>
> I think we need evidence that this is really worth it for optimizing
> out basically a counter update on powerpc.

Ack, I'll drop that patch in v4 unless someone sees a better
justification for it.

- Kevin

