Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AB7CFEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757B46B009B; Fri, 27 Feb 2026 12:21:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F56C6B00A1; Fri, 27 Feb 2026 12:21:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621DB6B00A2; Fri, 27 Feb 2026 12:21:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8726B009B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:21:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D47D59587
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:21:26 +0000 (UTC)
X-FDA: 84490902972.27.C1D0F13
Received: from sender-pp-o92.zoho.in (sender-pp-o92.zoho.in [103.117.158.92])
	by imf28.hostedemail.com (Postfix) with ESMTP id C8F24C0008
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:21:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=DPIqCyVR;
	spf=pass (imf28.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.92 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772212884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/PXgNtx4T2EDcNsJJyYBmD4sC1UQhRcm7AytyAKVWw=;
	b=UO23xk2NqL16Aq1tHVQXW02/PPmBKJ+p/9El5MB2X4StMJyeKT9ipXjynNUA6/rPkuMPvl
	Zg9fzZ27zfCIHzTqqn/KoyU6QAZAl4iFtKlqYfljMuo1AzZPvK8OjVQcD0uVliJ1aGmLh4
	u5UI3TpmeFG/KhYybtP57McOAn7U92I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772212884; a=rsa-sha256;
	cv=pass;
	b=2TfUAXRKUsCHCPedi4mzQxK05Zn0Q/fYkNEv77CUbvccXW77sXAdqFNN0ZsOLj9nChirlt
	WDEG673e+a8EQj3FsV1yBAGNHHBHhNapTyyWbB2lvJjh4AtC3J3ogdMvz8GqixRH+a4TX+
	iDgb0NNtvgedILkDV18aI1BTh3yHxOc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=DPIqCyVR;
	spf=pass (imf28.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.92 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Seal: i=1; a=rsa-sha256; t=1772212863; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=fupTqDv6G2R8UyDNa0HIF8BQSZDdjqUa2JqAb7YTeGUZL4q3wybv9olJp8gk+tprHtESOQWhDmB0i6XiOIvyxR6PTF1HBdtMOZDJ7a4IGxyFFjiOFGzApBlL9/0kRIkNdxD24Q6LOhsNcvAlYzMiNf7kVrWIL8mA+t+oiGN62Yc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1772212863; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=d/PXgNtx4T2EDcNsJJyYBmD4sC1UQhRcm7AytyAKVWw=; 
	b=GQhVh80b746kA5gIk0dzyNnBn02DE6Enj1T/QfXJT92eIOpSfi1f6vMUYAL6vO/9+Yf07IgzDqHud1in6DT3dy3KLjJbR0cvziPzIu9a4jYFG5PWCRpnrIsuZUItwwXr+duzW5fYcWvFzhSChx+eZIKpSvcXydLHOUAdFUKd4vM=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772212863;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=d/PXgNtx4T2EDcNsJJyYBmD4sC1UQhRcm7AytyAKVWw=;
	b=DPIqCyVRzm6yz9mH39+yBly/Pc1qJ5QtHQvQDTzvsB2Z9rbtjTDucuP4O/GJDXNu
	VvAXM99Wtndef3P9KypHC8zXj5HSWRLdTDAKXQ3PswJAekcs9Egg6RySlJELYtkM+62
	q0B7btuLipyp/ajcknNOPdfzpZAG+3Jb1WhAMJnw=
Received: by mx.zoho.in with SMTPS id 177221285910125.312785977067733;
	Fri, 27 Feb 2026 22:50:59 +0530 (IST)
Message-ID: <7d65b7a0-9bc3-4fb6-b25f-58b0e07c2ad8@zohomail.in>
Date: Fri, 27 Feb 2026 22:50:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm/vmalloc: vrealloc() shrink TODO - seeking direction
 before implementing
To: Danilo Krummrich <dakr@kernel.org>, Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, aliceryhl@google.com
References: <29e454bc-5a46-43b2-80b0-4d8d93e3feae@zohomail.in>
 <aZdBDOPUccXa85O2@pc636> <DGJ3LPUDBDTK.1TK1DXXFNXYPN@kernel.org>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <DGJ3LPUDBDTK.1TK1DXXFNXYPN@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8F24C0008
X-Stat-Signature: mcuqsdaedrbbnmyytqfua8jttzsnwt9q
X-HE-Tag: 1772212883-544535
X-HE-Meta: U2FsdGVkX1/olS8VE2wiSrM6Ooam8IybxdHY7a46bpj38mKg4Qixys9IJVFJ3x98LbOlqMFxiP/DWH9Vod87V2V3IvZ+USiBd2FCg/aYzIxV7SkK6uaI1CPd4a3NAgmffnFYz3IZgBqzqT2p6Fr9waPBK+aOfqasiIQvy/5it0FkpzT0rVg7gM0pg6I/g7Ir9nLc7+HjUGkOMdGttkQUfYxddQlyTzenCFE74zAf1ZDlAtYVLftpP6KPE/ChqXxGGUe+WMEoi9uIZC9cfCjFl/c518ehniipSiuloGz5VHjjnN1ekgTkMamu2kGG7zC+NNKos0urZJ6idU2XRGnSE3uGRvVuHL6C+iLEmH1D6IydJrXqKLKL2u3lUzsFVg9hnkRVFYBd0LzBNkxO91aRFLXrmMnO6VV+g+dT+HjKODCAz5wDDqPRwlrCpgccbSzTT3hK+dZi6Empuad6gQUPPL4SK6486STSfkRRP2U6qsXh0/eNIZwTgQuyZT4OXNb5/R0Nh7NXeJrNuIXbQ64ciYN3GCZ6klt0mBV3QQAlhjzHNbOWHKuuqcEWkOk+aRdhR4xDq1aKg2zOBk39spgI6ODW9qSLCSGktl5CMCXmOA2SoCRqKUCU1Ri6i6aX2yCGe05lEOXHiVyimMr+4HE17mNh11QIgnXOq3T1kTQ2BsDSXlGPjz/VFTpi99ZGLKlz3P46xg5NPIaML9MuuCKgx/tXS4VsdcNOToMKRUNV9DEV452b9Kbp4Yu422VdoQgcx/5hOZNqzl/zmGg/zek+vIyefH0KOAbsj0LcAEHAN9fcTWtwPvuRUhb9OoM+OrZmq32LtSKAJf5WGICIKHAroMkFOSwoFeGvMzc/LASfm8dnAnmp4KJtvXNeZIRABnDiHK3erKIOpsxg7SPTSnNAc4VY2D3FuwFZmPWiFcFrqcAIaLFQTjAfRjmmVHTB+SzD0JYbmplLCgE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/02/26 22:31, Danilo Krummrich wrote:
> (Cc: Alice)
> 
> On Thu Feb 19, 2026 at 5:57 PM CET, Uladzislau Rezki wrote:
>> I think we have 0 users of vrealloc(). It was added because of Rust folk
>> wanted this.
> 
> We just gained a user with the Rust binder driver.
Hi Uladzislau,

You mentioned concerns about there being no users and added complexity.
The Rust binder driver has a user of kvrealloc for long-lived resizable
arrays. I also have a patch series adding shrink_to support for these
allocations, which is now in char-misc-testing [1].

Given that there's now an active use case, I'd like to go ahead with
implementing the vrealloc shrink as described in the RFC- in-place tail
page freeing, skipping huge-page allocations. Happy to adjust the
approach based on your input.

[1]
https://lore.kernel.org/all/20260216-binder-shrink-vec-v3-v6-0-ece8e8593e53@zohomail.in/

Shivam

