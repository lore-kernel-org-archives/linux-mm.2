Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26503C43327
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7EE76B00EA; Fri, 26 Jun 2026 12:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F7A6B00EC; Fri, 26 Jun 2026 12:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46CF6B00ED; Fri, 26 Jun 2026 12:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97BAC6B00EA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:04:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 119551C6479
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:04:21 +0000 (UTC)
X-FDA: 84922535922.04.5BB3A99
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2EA01160015
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:04:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XbkSfxlg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782489859;
	b=3iklsEH6e/t79R0RyCTgc1S4Iv+vBxNBECqzNFych/O8qJMDNCR3H5z1hT5KZn0BJzcTfh
	YcrFVPz0zvK5FlbCUBWHJ4HLWlyqZU+2KBFpBSXrp5s7cJ/7xjngk5IfeQup+LKfovomBV
	OlDfjT4j3tM/vAGMpVcN2dlkP27wXdo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782489859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64G3Xshtq4ElK9GIOS9bT9tey898+7R6heARU/+ATwI=;
	b=YXnsdjvVATyVhyx/5mFFprXTj4woXh8myrcnbCCLJI4jFOYMUCSPSs7VxI1vUuJIck8VUo
	a0foQlItVaxegK93NUpkziRd81wt9maf28erjh1UtFFkiFUjUGb1rPe/o/v8Xy7zg2msn+
	qFNxvb0xGK8N54gVREZ6JOENCjHEn2Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XbkSfxlg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
Message-ID: <cf3abe7b-686a-462c-9203-02187ced058b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782489856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=64G3Xshtq4ElK9GIOS9bT9tey898+7R6heARU/+ATwI=;
	b=XbkSfxlg5ZCVqWCy26EzEW1bn/QwhxYqdhK/mTeyKANKVhoYUhzWoQvgP9pjOE+eAADvda
	Kbzp0N96xllhqThbZM/d5BGzthHxQAM9VqbeJOG9/FNFybOGCnbE3XRjdZ1cQq2giHWasA
	5s5fc4Q3GSJ9MnbvGEMoaJ/VXu4Cjxg=
Date: Sat, 27 Jun 2026 00:03:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] docs: pagemap: fix flags location, member name and sample
 code
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org
References: <20260625174447.24292-1-zenghui.yu@linux.dev>
 <511c2e7c-0305-4917-a639-e8e9e8710903@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <511c2e7c-0305-4917-a639-e8e9e8710903@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2EA01160015
X-Stat-Signature: dejs3hk4ek5oskkd1orzhy4w7t319c5s
X-HE-Tag: 1782489859-243569
X-HE-Meta: U2FsdGVkX1/iMYB0NOfC/uPfRty2nyO7IgNfEFbioYPCKUvuAlYV31R2xT3prLLXT+y/MVj13M07YAAo1Rl5jJdN06WQlN8b+SUrNHS3vJjmGQeYLei5fjd79JGV1E6QG5O/PTnJvYUh/7dd+e3PXtvWqIQel9fQv1sRN+HgS62dtusHMigNEsIjTXLT1Gq5Zn9Oyn0Bzh4o/gPL4eZ+3KujQ4jZIB7AEh6zadDb33lCxbMa/2GjpKl40QxA/J5/yN0SPWsvxM0/0934NQOUCSkkt9WIO0ZdpO2BNg9zKA9Yv38/pETu1DNNzlFRLmCqJ/Oesu/6I4FVSt5oYN88xchKgGqgYh7xVO/fq+r8CYVs7ZuEJl73OuU7Dnnev3DUv7mOGFjhUMYNdFKjcvSSRh8NsiZGzRj1RTX3k+/8MOkds31XrRKQfPgx/lJgkmSriPIg4Xug/dzybZPzdjzGd81sKdL4DxhwzE3e7I9lkpGzp2wZYtcldKsszb7gJESKm+VyseFBLg/736YnO3gvV9CFZ50rBvBiFw2KZgAfG195F66m6+BdHFwgeLeUdpkWF7uyqxF47A3/InetVZRTeLxaEbIX2aop6fuc3TbsPwvM+sffr+vZ8B9bYWUem95Rl1eY8sdU/vXlDGM5g7fvqfU14gZnQdjqjb++tWNiFZJDQiWtadUzhx1gTrBRWEKqIvW0t6xZSQcGaHzkWOneLgATDmR2pErSWECiWSsIv/WwQdrA9nAzCimvphhyDqsjpB7Yld9Gjwh+F+FA/i4l/wGqBMPiFo5JLuSLAT046Q862XLwQZOkK7YD1ENSZdaZ2UopNbmk2hJtLVOF+HcoRjuzNHZmGVuXfkSHkRpWObAxiIsHsXdb+OfuXj0Q5d0JAxeI1tQfQt5RICRnMw39TNoBAGYTPqLC0y4jMZ++v4RDcQXNLhs5cUH0IR52wz7J3igKSdBt1aXTRDLvnzh
 t/wss14g
 PJJFLAmsvFv85+6OJQlJ7h+wZnjU+ckUhs6ayxu+G1cFKmetuLA2rVWt5kITa1NV3JjHVx5neFGxP7vuNclr7rhuavCxGwAh8G/x/Oc9qR84TE8Yhm0aRL1XTuD2Gawu8nSgLxCmrBQ9iP97Sun0rE1+K3ZD87B1H9kWsmCADNIcCv+Twl6FCFl6h0UxnuqLoAeDUNndtmiKbk3urjLqQ/fIraA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 10:47 PM, David Hildenbrand (Arm) wrote:
> On 6/25/26 19:44, Zenghui Yu wrote:
> > The userland visible page flags (KPF_*) were initially moved to
> > include/linux/kernel-page-flags.h in commit 1a9b5b7fe0c5 ("mm: export
> > stable page flags"), and later moved to
> > include/uapi/linux/kernel-page-flags.h in commit 607ca46e97a1 ("UAPI:
> > (Scripted) Disintegrate include/linux"). Upadte the doc to reflect the
> 
> s/Upadte/Update/
> 
> > current location of these flags.
> 
> Ack
> 
> >
> > The member @walk_end of struct pm_scan_arg {} was wrongly written as
> > "end_walk".
> 
> Ack
> 
> >
> > The first sample code of the PAGEMAP_SCAN ioctl wrongly used the
> > PM_SCAN_CHECK_WPASYNC flag twice, instead of the PM_SCAN_WP_MATCHING flag.
> 
> That makes sense.
> 
> > The second one missed PAGE_IS_FILE in the required mask.
> 
> Hm. The description says: "Find pages which have been written, are file backed,
> not swapped and either present or huge".
> 
> But doesn't that mean that
> 
> it should actually be
> 
> 	.category_mask = PAGE_IS_WRITTEN | PAGE_IS_FILE,
> 
> Because
> 
> 	.category_inverted = PAGE_IS_SWAPPED,

Ah! Thanks for pointing it out. I'll fix it soon.

Thanks,
Zenghui

