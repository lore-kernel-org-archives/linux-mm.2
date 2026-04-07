Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D5AAFB519B
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 06:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF7F6B0088; Tue,  7 Apr 2026 02:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A803F6B0089; Tue,  7 Apr 2026 02:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9963A6B008A; Tue,  7 Apr 2026 02:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8AFA06B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:23:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 300C41B86FD
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:23:46 +0000 (UTC)
X-FDA: 84630768852.02.F5DECEA
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf26.hostedemail.com (Postfix) with ESMTP id A3801140004
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:23:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OtsYY8iS;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775543024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6CMtQUtwLNCZO96qDPJxNdbEJ+SZVWz86MVqoqQUYgg=;
	b=KIZkXYc8IaKYu0+G7q65cpGxcfdfz9OsuL+W9lKlFpoRvyoTcxemB4s/kjZ/d2PTvpJcKv
	6R1dtPl9I7RdrNe54ru6fetRuL1Odn5jLV+ALgIoiwNV+FcdeTtJyo56Yxs8SfasKjqkOk
	39f6XOreVpvhkkA4vbDr1qoPtrz0ZEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775543024; a=rsa-sha256;
	cv=none;
	b=XacXgqa7RCVmv/wwnDRcfFkDUCWvABvkgxpTY6DvhY30O72CZiDI/9Q9kgvxzYKY0qzvro
	uW0+RS1ACHeMFzJtduwYwiB2lZFNGql0N9PihEHETB6ViGhnyJn5OlxdMayGiBJ3OFnG9a
	6elnuOBWfN/zwwGQmZDLyo+zlcw3xtI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OtsYY8iS;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775543015; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6CMtQUtwLNCZO96qDPJxNdbEJ+SZVWz86MVqoqQUYgg=;
	b=OtsYY8iSCktZ6nkGwyQ3WRIRW8I4LXH4ZmFykXVNK6AGhZzBIJ+NDxtS4VXbdRvgVIvKlZjtWP/gv4leEEvHG2kOG5CUmdglE4NCp6bR3SzCBRoufG2sisyS94fkdL/f3vLp0mdPzSYaGcWcpjNvv1hyByTsrTK+WW2zF+7M8WU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X0albEE_1775543013;
Received: from 30.74.144.138(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X0albEE_1775543013 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Apr 2026 14:23:34 +0800
Message-ID: <2a216ee2-aebb-42ba-b2aa-826488448bbe@linux.alibaba.com>
Date: Tue, 7 Apr 2026 14:23:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] mm: change to return bool for the MMU notifier's
 young flag check
To: Sean Christopherson <seanjc@google.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, akpm@linux-foundation.org,
 david@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <545847c132da5d957cfc74ab19e849b16127aa8f.1773890510.git.baolin.wang@linux.alibaba.com>
 <67c670e2-c98f-490b-bbb9-2960f8175b5a@lucifer.local>
 <66e78b59-f96c-4277-b7d7-473b68ed413f@linux.alibaba.com>
 <adBJTXeE6G2vQNKX@google.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <adBJTXeE6G2vQNKX@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: kqh44ke9riee4hcqmztd9dpuzn8kd3i9
X-Rspamd-Queue-Id: A3801140004
X-Rspam-User: 
X-HE-Tag: 1775543022-717853
X-HE-Meta: U2FsdGVkX1+kXY1JvmKMgg5gDRVI6CL2Ul8Lg3Xe7VbpueOoEWqfeGSmLZ9AoZav1ltGCykNG8CmLQz7BwM1ixWURkVnr3lgYBHwCcldEJzg9e6RZ31QqHY9L33gMsHmWcQDPbCLL9sX3w4Hkjfp+CXqIlkg0vvg04xDzjknaizApVvtSnd6+aBDBfOScpVcoJ1JIvr339cbApIrrkJD7YNk7d7WrwFJPnjL6uS/l99KIn4nR9jXT47xNe8vGm/eOc3MsyNiCwCwT4m6AzaOI6LKpKj+sbqXDgKsRepTm+PUWcxRvlHzF0BhL/1pS2SM2/wyegKy/ShDNbxLVXt9P8KzsNyZT5yxQbnwvcAMYZrRUcyUXlJ5Y0BZuN+xvP+MN38TObFdjfxU1PS7zbQTsc0fBjFNafc2S8/y4r2S5XRv1rKg+lKuyBAx7/oPp4Ndu61xI5kfDgVU5rVEbLokZDF77LIN0UNvV3axRzcpD0d8VvfkBgaegJXmXHbC8Z5l1tXJsjYIEW81Pf9i085EoNo5CtCGBDeqyWxaEufuShyENtv2fI3DR7+aXX7PGqj18MFP9arObGIoh4SQImclSa381hQ7atZt1lcxHHAwNA7mMgMH/3AAUNp3eKeQw6IFnh241yZa/px7X+SnfEHz6AjpJfrZmKViQcqQPVQ/LoidD0CO4gwLWPpUx1a1pydBMJi1jpBc/4SVidHbLdpY7MNWXjp7jgsgUXo85xe0AkeYyYeXJAELl3LECGHJGSLRRL8j0Q9GXCu3cE++nlA4oEVuKT8KZR2RMrpjXjMIoBtqkwQtabavfSZi4eK40RxIn4R9sBcVPzbb0btrUvNWDJ7hKcrvhCR6mpDo7UtMQPC3zJ9XE96V5L1zqChVCW36M81DIqnH8BXU7uhKbpGc2PdC1A+QKbCeO1etL4MJBrC2qGlWUN/kbJtJ0yZ0Mut77FE9BNxTQI0R3MDTAk8
 vbZrAsq5
 ibH4oBuuz3qYEuCXl09Q1rcDIEhW8l7s//Lp/TnAgs9PxD5Gtc8D/kZhhIn/gWUWvYlvY8C9NgWNsuZDq4Isow6KMv/9el8LFCTXEMG43AW83aW5fNr5zhIB+iY/ZiOJy41oprG4h/Sc4Skz3oR2zr9+9f1ORDCKl4sfS3dXK4wHnyBW9c0sobiwX4lR9qvjocwdmbEcnVCJIHZ5SYN9DEJPHqV+MR/NG7ufGoX0WQgazQaCg/2TaAVbENEY0HVSDrCDWMjDUVJg0b9VDgyuGj5PK996QIpn8Dkv5wXv+YFip+DpHutoL7Mo7MMpKFqFG54D1Vg+j/MRO346PC8mcSLx+PbfRmRA2g8JFfbpZReKFzIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/4/26 7:12 AM, Sean Christopherson wrote:
> On Fri, Mar 20, 2026, Baolin Wang wrote:
>>>> -static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
>>>> -						unsigned long start,
>>>> -						unsigned long end,
>>>> -						gfn_handler_t handler,
>>>> -						bool flush_on_ret)
>>>> +static __always_inline bool kvm_age_hva_range(struct mmu_notifier *mn,
>>>> +					      unsigned long start,
>>>> +					      unsigned long end,
>>>> +					      gfn_handler_t handler,
>>>> +					      bool flush_on_ret)
>>>
>>> Can we please fix this terrrible indentation while we're here :)?
>>>
>>> static __always_inline bool kvm_age_hva_range(struct mmu_notifier *mn,
>>> 		unsigned long start, unsigned long end, gfn_handler_t handler,
>>> 		bool flush_on_ret)
>>>
>>> Would be nicer, thanks!
> 
> No, please keep this as-is.  KVM's preferred style is exactly this (and I personally
> find mm's style much harder to parse).

Um, Andrew has already queued v2[1] into the mm-stable branch. Do you 
want me to send a follow-up patch to restore the original KVM coding style?

[1] 
https://lore.kernel.org/all/cover.1774075004.git.baolin.wang@linux.alibaba.com/T/#u

