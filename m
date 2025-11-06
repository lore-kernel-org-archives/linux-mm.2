Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93127CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13338E0009; Thu,  6 Nov 2025 05:30:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEAD48E0002; Thu,  6 Nov 2025 05:30:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27E88E0009; Thu,  6 Nov 2025 05:30:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D41BB8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:30:03 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87039BA763
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:30:03 +0000 (UTC)
X-FDA: 84079811886.22.69BE247
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id C372D4000F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:30:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762425001; a=rsa-sha256;
	cv=none;
	b=Kr7yykFU/fXEa1Jq0BzGYduw81162u45Hhik59LfaQ7S+YQsQHcz2P1Qol+brJ4MNtSZGb
	LnYdW81dOncZvsj8kixcR09TQg9C6vPalzZmDnqJYGK26bTzSLJ4UIuwKXYrwoVjzuKpsA
	hjzUgTeAYIMu4Ek6t5Q65FqIu6bFX9w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762425001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kXPFrNUNPhhkMe5rhwtRP1Qi03luuYdSthxJanNeerc=;
	b=hz38MN3aMBTAs8sEbhvRZYuG1DXvXkmlu3+JS02zsCgdkLqZoVTDxKcx/dbUfMqOAgSPF0
	R1NBnoeiTkE7b9HIJyscLUmtA/I5m9aaSIezC1LlXtcm61vRsUSS0Uqx7eY6NjC6oNtDth
	IR8BhkNJIu8pJ1U8CwUi2O/Xgyl7V9Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B85731596;
	Thu,  6 Nov 2025 02:29:52 -0800 (PST)
Received: from [10.1.34.75] (unknown [10.1.34.75])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB9A53F66E;
	Thu,  6 Nov 2025 02:29:53 -0800 (PST)
Message-ID: <b3e4a92f-5b51-4eee-bfb8-c454add0f0d2@arm.com>
Date: Thu, 6 Nov 2025 10:29:50 +0000
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
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <87qzud42n1.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C372D4000F
X-Stat-Signature: 5eskhmn6pfj3hjthpcuia7ku5wacuo7d
X-HE-Tag: 1762425001-75779
X-HE-Meta: U2FsdGVkX19y0f1elz7jvmJWLcEPnVNyZNR8rMXRj+JHFYpSVoGvJjl4Sh+H598s2+gbW4iQCiiCv4dP7Ov9PsstuEeDUG/JwADjFij6fUzJOh3m7vgc4BTx8etIPYunRfbaGXdMfg06uZdpS8yz6Xug1JN3BESYBtILiQYIvvVI7QoE4YxNYgvNFLjDdy/BF7gu5J53pk/Ir7Vl/fKSpCLk4FU1YooM6cAkQzSHR+bTMly0CpA+8AJ3hPdxa0+G2Q4uUphkmNRiCASIHFSRojbVzlOhn8rtCRWn+btL95uekPxosgT5AOSYKxr1OdOQSxtaiRj4JAMZ+cKIbrqYJWKVOkdS3IBwOWgl5Grb3gM2ZCjhn5BP+A/l6HZskeO3c2PBLwbCnmvLbSfbb9VKNYJDLkW9Er2tO3P/sJhVs1PstDefJL+zQEpi5uEyVjhZLs7cp/iYOAZdE48ApqoQqQLhEh13Ol/3Q7rogIMWo+bCK8fTieeHbtXMTQJSIzcG5cD4TFUQYYklvATUYBYEykBnuc7f4DCAAfSw+jcHxdZVK0t2XiYX8wGOOpiFzcPAMuHlG3tG1hFzelEQy17ZQs88bpisF7hAwSqw+rtwWHHTcPy4tdcb4DrNyJ9GdvLnmMmzqUz/+MHl0PQkgv0RmRmHyvfE0CZWEqzgQcrRDwALTBM7yRyuIO51wf7a00LaFiakGFZGhP7MMkU6jtTu6K2M39LKOWyx5ocj4yKeDwwisn+bkEF1xluWgiaPmvw5oKrD95Lv1x2c3J5VCJq/Uq0lOEYVe1tH1pwT+7VuqMdypl2OcyWnRjGtCdNN7usIwM0O+ai2ErOcZ7uMpbnIB1wFThv0Bh/JwVTcMJA9AUAeXb931CAEezcHxrarc/UIHtFVP/VuW+ibQHzGVn3CNhTqFpxs1QPKgShstGRDfgufeBswNXB8GjWlPnlfiTPvh1s5/ezkPXOqVAxka0m
 ffe51KF/
 Fa57h92rYQg+kw/1FAOJZLkSr/9kxIbJwX8eVlBJHq0/6rjsuW3484IOWPy0jk3SU3kpp4mn4wo2TI5jnpxlzmo+Qo4zoQMA1vm6MJoo5C8RZAtaBKZplY6MjLEc/njohhNPV/C851v2IodYPVahMSVCTQwOulDssSvM7UIsikNkcrOJxf5S61Py8vK3tGgsrP/M3jremIzAg7padrDA5b5olAeQu8RHv4jba4F/DJc82qMPk13dzhfhaFH06tFrsjycG+GakF/JZY4hL18mPs+QCB8j8Cq96kd+EjY1yPCYP9CmPGzG8UFhNKoru3gHpmr/f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/11/2025 02:46, Ritesh Harjani (IBM) wrote:
> Kevin Brodsky <kevin.brodsky@arm.com> writes:
>
>> From: Alexander Gordeev <agordeev@linux.ibm.com>
>>
>> Since commit b9ef323ea168 ("powerpc/64s: Disable preemption in hash
>> lazy mmu mode") a task can not be preempted while in lazy MMU mode.
>> Therefore, the batch re-activation code is never called, so remove it.
>>
>> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  arch/powerpc/include/asm/thread_info.h |  2 --
>>  arch/powerpc/kernel/process.c          | 25 -------------------------
>>  2 files changed, 27 deletions(-)
>>
> Since the commit referenced in above disables the preemption in
> arch_enter_lazy_mmu(), so the expectation is that we will never be
> context switched while in lazy_mmu, hence the code changes in
> switch_to() around __flush_tlb_pending() should ideally never be called.

Correct, that's the idea.

> With this analysis - the patch looks good to me. I will give this entire
> patch series a try on Power HW with Hash mmu too (which uses lazy mmu and
> let you know the results of that)!

That'd be very appreciated, thanks a lot!

> For this patch please feel free to add:
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>
>
> CC: Venkat who also runs CI on linux Power HW for upstream testing :)

Ack, will Cc you both in the next version.

- Kevin

