Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57335606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 18:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZvyWXiQR
Received: by kanga.kvack.org (Postfix)
	id D59B36B05B4; Fri, 27 Nov 2026 13:54:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09666B05B5; Fri, 27 Nov 2026 13:54:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8B36B05B6; Fri, 27 Nov 2026 13:54:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98E0E6B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:53:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA436140473
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:53:56 +0000 (UTC)
X-FDA: 85481798472.22.3A7055C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E43E4140009
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:53:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZvyWXiQR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795805635;
	b=uqhQoI9kOvPNnpnZ+a36tNT6t6tvN8vqwxu2uZlfzVaaojb2QGpxVMclZqoQV40LojjpJf
	sX7pY27vr0I4yUKzUczGENS3YvxBooJvI+aI9ZTBLbw+7Ga0NUZY5L2N/wcUQ9BjKMo/aO
	/Uwi6qP6+V9RPxERe9xnbHBUaMQmxO8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795805635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vFPdeYCDHYXA0K3WZUWPBX5y/afVeGjWei3/s/A8/0=;
	b=EOekm1aiTbOxgTl7Nt3bx+IhEo3BJKehdtsUYTf5hQXb0SR4jSDpKbiiIUaNIZMDM8KnGR
	b18Znj3TikvzPGe6SocVAKgHD1+iZocQi+9Ec0UAHh+y7V8qWsMMK9kfC2wor19OKiAOzb
	05kmpNAFZdyLGLEgWzT2UagKnQYd4QM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZvyWXiQR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C8AA453F6;
	Fri, 27 Nov 2026 18:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D801F00893;
	Fri, 27 Nov 2026 18:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795805633;
	bh=2vFPdeYCDHYXA0K3WZUWPBX5y/afVeGjWei3/s/A8/0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZvyWXiQRMZa/gqLVKgsVnQM2hlVQq3DAgGmSxyDLLnGyZEv/h2aQVOVRk7QHuIPFT
	 vlPGQv7OkJneDW61+jg1VCeWKaDeTcN9NOZ4ixOvMHNJ/BKyU1PJWFLsN4Dy7To6LD
	 xwYEATMfcSpq98ULJ9Y5tXokPt31WcgJz8K3vF4UJdr1wE9peCbbJYM3Eo8aWo8L98
	 df9++bbs1CTdDMDQLARzY6WI3o333+CW4tn4k5JubJP5+HvkfjmAE21FB7XhaEowVa
	 O61teuJ9qTX1aCLDFhS770GgFaNjn9fkXzVi53D8MUyFquvuSTNKYURGl/BpXhvCnl
	 fdsYn05Y4Nu6A==
Message-ID: <59221fee-1318-4014-bdbb-50cdec0d7283@kernel.org>
Date: Fri, 27 Nov 2026 19:53:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kfence: use a nofault store to zero the guard page
To: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Chris Mason <mason@kernel.org>
References: <20261127-kfence_guard_zero-v1-1-cb33d3ee653b@kernel.org>
 <CANpmjNNTOc0h3yG8n3CHLsmqNH-+Y454=9cATn6rM0dXA-nYFw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CANpmjNNTOc0h3yG8n3CHLsmqNH-+Y454=9cATn6rM0dXA-nYFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E43E4140009
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: t5um9k3rxtdbxq89urzusfz19u7pj7uu
X-HE-Tag: 1795805634-189278
X-HE-Meta: U2FsdGVkX18V9vYsOlMfFa6P2+UvY+g47SLrC0um9395rjPrzTUiPUmU5WUK832rGSZbXN3Q+n5EdGb/XquLhKmmyrpw8/icl3z30U2mJQWDfx+0RjQlcP2jXWji2gvXKnG+mwaDATczcye1RA84NzMesXj7eLGNwNJRyAMNcUUWCDxHs3hOyVRJXva6NMyEpDECvcNwWM8IaQh3yxU80T2FWuOimk4R1ZXioO0Mn2M6Vys9UTJ3EqQr3U4QEYramylkfJKm8Wx27yEn9EJ/C2vCJ5Iztc/ZVqP3KQqO3NilmVhV2Z2QMCsGWWl6lsapmWlYwIXo/Wbrttz6egJuN3eNxS/FH2BquNtH/FggKfJhBMV3eMzFLgR2kcc3112eNpjpmXTp3GZWTnGeJs5bQ5mU8LQWG1ptWy1Xlzvg1BnKomnoM0DBVvGA8uZQ35G1PyrqpgwckC1nH8B4IRlqIoCyveU1akKdmVn1joE2jDrK8eg1ihbaiRR6dlE4pQBOY4XHPJ2VwvgM7YYTwbkEcV2A7QptDLAzWuJFtBseaaStwAySJ27FQ5rYzEwjEAiaR6mHzOsjaIOOGZ5msSiLrDzUgR/+/c50/4Yg86SLj3TUqPTj7/ukoh5hzXwW+E5MFRAUd1HxzEulzYN9fX/il+8FTl3zEPKh8wYSWqiz3LRnQMkjxf5HcjBTyQHNnkIJNz9y3x5RXCpSkxGhAnDu+oRKBA+PNv7NP6ZyhH832mpVJbKEfVohfaB/GMNUBE+ajEFZ0D1HSF5hd8/5JVgXtAdTfmsXuvXGIZM5Tv9w6hZAfUxT45wsGDZOIbaMKNU6gLyOAo7P0m27a0F9ir7DqGRHG5XQi/iUD+AhBSC/jfhJ4WBd07aNLCvk/E9h55E3rGn78rCopP6Owk7IVX6tvxZBXFjZ+H6+KVT5PqK0XZtWSqlr+ina7wztiU2desX5NDL4OWJVowjJigM0pI4
 BCARbX6r
 3563KUa3fdP9LjsN3TZWU/Gxo6MVGs2zAVYzp6cZvmWRhzHQATgmo6x+eAaldJid9mzeX0kbEOdx9NI5Xeg9Wgj84HPd9XeSzSUDnpHeI9BnTsqFRkduHv9WyyH4HgpUjwC9KFCzKcl8Kx364JBUyzehtmX44k1OTphZRR/AIzvBWVLXB01qAjlmqo7ormZYjr7pmLDRyBkHYqiCrsE24XH6VTlEcwSNncygQvX11+k74B1tHBZbWEg76G6mW8gpigCSbt6BtzjwBfRvOD5MdU/zNkuSqwUlTYsvNBxAIE3EDJlGnjduJLqCxZZx+yfoUe1HIJ7b1LHlSxHFz9MzNggxJ1FqvU7UbyQa9V9P4O7WtkZIVMSe+smgNmX7u5PiUgEzy8/VA4vct4MOEY6yvxqw5Im5gc1eX8V2J9NApOWpX4Crf1hgahuzW9RjbcGQcK5j/71adtRuo9xKbq7mxtvcr6U4o4415CFV6ERQ/DlV4fXUhg7DBy5GFL5lR/DxPU6pp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/27/26 15:44, Marco Elver wrote:
> On Fri, 27 Nov 2026 at 11:04, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> From: Chris Mason <mason@kernel.org>
>>
>> After an out-of-bounds report, freeing the reported object can deadlock
>> on its own meta->lock with interrupts disabled, or trigger a false
>> out-of-bounds report on a neighbouring object.
>>
>> With kfence.fault=oops, this can happen more reliably, without races.
>>
>> kfence_guarded_free() zeroes the guard page that meta->unprotected_page
>> points at while holding meta->lock, assuming that the page is
>> unprotected. However, the page might still be protected:
>>
>>  - kfence_handle_page_fault() calls kfence_unprotect() only after
>>    dropping the lock, so a concurrent free is possible.
>>
>>  - With kfence.fault=oops, kfence_handle_fault() calls BUG(), so we
>>    never get to kfence_unprotect().
>>
>>  - If both neighbours of a guard page recorded it, freeing the first one
>>    protects it again.
>>
>> The store then faults, and kfence_handle_page_fault() either tries to
>> take the meta->lock we are holding, or reports a bogus out-of-bounds
>> access on the other neighbour.
>>
>> Let's fix it by zeroing the page with copy_to_kernel_nofault(), so that
>> a store to a protected page simply fails. All architectures that
>> support KFENCE try exception fixups before they call
>> kfence_handle_page_fault().
>>
>> Skipping the zeroing is fine: either the other neighbour zeroed the page
>> before protecting it, or it was never unprotected.
>>
>> This is a quick fix: nothing serializes the protection of a guard page
>> against the fault handler, so after a racing free the page can stay
>> unprotected and we will not report later out-of-bounds accesses to it.
>> Add a TODO as a reminder to sort that out properly.
> 
> If an OOB occurred, the kernel is already in a bad state, and any
> recovery attempts are best-effort, so this fix here is "good enough"
> for this intent. You could drop the TODO and just leave the comment.

Ack, makes sense in that case. I'll send a v2 with the TODO removed.

Thanks!

-- 
Cheers,

David

