Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67CABC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:40:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A3F76B087E; Mon, 17 Aug 2026 13:40:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7545F6B0882; Mon, 17 Aug 2026 13:40:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66AC46B0884; Mon, 17 Aug 2026 13:40:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44C1A6B087E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:40:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E754A120954
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:39:53 +0000 (UTC)
X-FDA: 85111474266.06.5F1EE99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1FA8B20003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:39:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uiu93YaO;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786988392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EldLsYcfZqfCW5hxzb5tOUJDz+gGEDI1z/tkTtJs2mE=;
	b=pjuz1isSH42GQLnVPjnMHga00GwtIm0ElrjMMAwLvHWGOxeEkAwvdDpFFKOYh/2qyQfCDo
	bYzoGYZ/y8vaz5unghLCtMP6x4Upd+gn5FwsbRkacuuanLQ1ldcWj1Cqm6fW72VK+Mou94
	RxBPBAH7kw8WYpEnoSSXnToKtP0z9Mw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uiu93YaO;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786988392;
	b=d+atKuZPGKKdqMiQ39qdHQZArJEyMrMG8FW/Ay3fP8s6CK6Fdtvyu6Zdf+EqJ8ODN86mkJ
	OijITXJmySHTjIqxMp8b09sukAv733Lm1XGKQAhmpQDFBou7+oGAzd1XJmrSIBoA344zRX
	IR5AqSwjpb3AUEZ7vvTxO/YylkZCwZI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EBC4600AE;
	Mon, 17 Aug 2026 17:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA511F000E9;
	Mon, 17 Aug 2026 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786988391;
	bh=EldLsYcfZqfCW5hxzb5tOUJDz+gGEDI1z/tkTtJs2mE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uiu93YaOjew7mOLo84HKnQddyWvyyyNomIDx6TMOcHvXfDf5Hr0qsINLC8oVt1LO9
	 +6mCdT3sP9qcuc1LI/TSrR9sIkWpI26014R49EWcYkv5XwVMOofMRo44q7f5aSQAqo
	 ZCXsJ3fyIA35kNh4on92A1QlnxIDCiB427Panfnk=
Date: Mon, 17 Aug 2026 10:39:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Narek Jilavyan <njilav@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb_cgroup: call page_counter_set_max() outside
 VM_BUG_ON()
Message-Id: <20260817103950.5ff58d6ebe536e6ed6e7098c@linux-foundation.org>
In-Reply-To: <20260817103433.191266-1-njilav@gmail.com>
References: <20260817103433.191266-1-njilav@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: zdhmay5ixix8dorgcpjfjfccsnn8g4mx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1FA8B20003
X-HE-Tag: 1786988391-122398
X-HE-Meta: U2FsdGVkX1+wdo36X4S7iCGyx1Snb/nPLWhpa8tvaGUVF9SVulU7BP33ODa7zo2rJHB0yVN1LZKchMGdlwnV1Exk4Xnm0Uq9Ka3D7n1i7Jd1Mn79zBNGyJJqdk+vobuf975Rt2QMxKDd6gCUWSvQsBD60bAbQeUB+OS6ILg2o+WW69QFjlX1Esb9jboCLczdB4f2Tlporj8s/EAxzwE+HPsvn5rkg/kT2BC4aM+SOXxAY9t3j56pxgoGjCxBxFCGS57b3nYZiR2TSj79Y33J7nYDsJCpHhH/Ud2pLDeI0pHh6ACxz+D/hcALRtS0JBPx8iwiv5htIYg2hIU/g7vHaaMYfG1wsRo+zt7WmxAz3F5gQSf+SqL3hvvrUWvxoxR8MvrryqrPrV1KBAJGR35EnZQrJKotooc58+Gbo+5u+wQphBWq22xBRV+xhsQOhTsmTCKge1hrpK5c1YO9HMJfiDKrkzC9Y/SMhh14ZG9OJltxYorjQTV1hrjSELdvLKaGlTG79KHTRZJ2DYPvDPEPf/w4LQ3iu/lR/9PQ+5zZLTM/cdq4LmCkf947qoGRZASLP8Gxufg/vB3k9rwnvIAX58SL4GeusCpkm79dO0rOAA5bPxAc5ANDpiYXj7hg0dr5AK899yU+UT3FDNgf9AEe8I4egdJ1BIWVPRJst5RhhbYLXpRcHRMohW2MiM+2tR7mC+2i/OYR4RQhnEYcVaE1lEnbG95Dp4q6oTfXA5qO5HGy8ZMAXqu2+Ddmwx9dnoC9s9OdSywYK2hSMm0gHI0v70uA98GeIL6CM/yr3JigEUZqOIaoWOTNzRFfouR9bK0bn/k/cminXPfU27QDEvhfBpJmff8swdbpJBMUoGPRER7ovH8iJgoXFvvxKl4Vx8GDtYpHg1D7CYdfDlT6vQifndtgyCFdEqsaH6IYdNnW4ezg789oHHWe2qB4mCDeSGnO5svnU+mk6Y/0ivd719t
 p1ODSfGc
 UW3ExA3Au2UHAivJWL9HBlJoocahQ20btLwhErbs6eWDmSOebx7aTKJ/XeXkKwEyJR/FRH9guQudhE/Ca35SujuGzsk9XMz27RlTskNhDK4qAGiPs/a5qjzBCuZDP7Zy0jJ9k8r+D6u8+yIhTgCm3S4kpA7RWyKb7CNDcr9e15orFer2DvT9JCSF/Z4N2d2QNZcAY2L4Lb6MdtgaETYpuh1DPlXReSshnP3jRjmNypant3+0AR8v0e8VTe/vTtMYnojFHKFdTg34oy6BnLj4dzYBvrshYOThfoQsyzB3PD5rNYWlDtIIqBTzVFpfGC+SiokOO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 10:34:33 +0000 Narek Jilavyan <njilav@gmail.com> wrote:

> hugetlb_cgroup_css_alloc() rounds the counter limit down to a multiple of
> the huge page size and then applies it inside an assertion:
> 
> 	VM_BUG_ON(page_counter_set_max(fault, limit));
> 	VM_BUG_ON(page_counter_set_max(rsvd, limit));
> 
> With CONFIG_DEBUG_VM=n, VM_BUG_ON(cond) is BUILD_BUG_ON_INVALID(cond),
> i.e. ((void)(sizeof((__force long)(cond)))), whose operand is never
> evaluated.  page_counter_set_max() is not a predicate - it performs
> xchg(&counter->max, nr_pages) - so on every non-debug kernel the limit is
> never applied and the counters keep page_counter_init()'s
> PAGE_COUNTER_MAX.
> 
> That is user-visible, because hugetlb_cgroup_read_u64_max() recomputes
> the same rounded value and uses equality as its "unlimited" sentinel.
> PAGE_COUNTER_MAX is LONG_MAX / PAGE_SIZE = 2251799813685247, which is
> odd, so round_down() really does change it and the two sides disagree.
> With CONFIG_DEBUG_VM=n:
> 
> 	$ cat /sys/fs/cgroup/t/hugetlb.2MB.max
> 	9223372036854771712
> 
> and with this patch:
> 
> 	$ cat /sys/fs/cgroup/t/hugetlb.2MB.max
> 	max
> 
> A debug option should not change cgroup output.
> 
> Call the function, then assert the result, as v6.12 did.  Use
> VM_WARN_ON_ONCE() rather than restoring VM_BUG_ON(): the two are
> identical under CONFIG_DEBUG_VM=n, and checkpatch asks that new code not
> use BUG() variants.

Nice, thanks, I'll add cc:stable to this, to help ensure that users of
earlier kernels get to enjoy it.


