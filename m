Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EC80CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 09:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CFB36B0005; Thu, 11 Jun 2026 05:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4807B6B0088; Thu, 11 Jun 2026 05:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396556B008C; Thu, 11 Jun 2026 05:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4856B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:38:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B220112052A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:38:36 +0000 (UTC)
X-FDA: 84867131832.16.B0B65E0
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf16.hostedemail.com (Postfix) with ESMTP id E139018000A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:38:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=JceRipBg;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781170715;
	b=mg45YnXoAGGiWzRrSGQXfSh5PqzBebmZ6TrCYkdwiLOGVjT9gUVcYDkJL7Hjtg6YT5eTPM
	ZjtavmlAQdQJiA8Km5LTrQco3triSXBMhxu6ZGDuk21B6ScdJt1cUyl0abOszKVFTbkG0l
	W1ProlzJpJCcO1kH9NXtf+q1ov0atp8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=JceRipBg;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781170715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9l8T6vuQd8ofYyGxx3NB8W3+1YzVxoYB7Bmx+2O71A=;
	b=S8qrZ8z9r3CDPCrNtD4cM00ddvqwhcweXflzkEJBGbtPIJSL9ubWkIaHvTIahyaeyhCWsZ
	JJkE2YiMAnmixdQ79Bxi08ydD2jlNCZ6i2oVEo+MvEeD0nVfXWsG6NZgIwTRnjJixJftrL
	fG4Of7rqGBthAUmUnbLzlLoshmFq8wQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1781170705; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=c9l8T6vuQd8ofYyGxx3NB8W3+1YzVxoYB7Bmx+2O71A=;
 b=JceRipBgMnyCRSncb1gLxnjk1tDDIUwYUSfCVm6p3SAF8MkXhHndETHQk+4e5cLPnD93C5
 GsPld2iGj6XCVhEn3+0+/gmsYTxLA5lOMKiNMbLyadk4zCp6Mi+sjHxHqr4vi6AcCEcyzu
 ACqFI1bvgsb03URfC02v/4u0frmXndutq+ep7SXNtP3tLodBI3f9y8DcFlCSdiSre2e09L
 CWkEtxFe2tpwk8OODH2NH1WsOJ1vWCmEGeSfWQ+S1KzcFW87OMay3NOcTNpTRo9MlyDJEs
 BdarHub4dXuqDyVMdWu3RHxT6j4PvnmAIJD4fpudFlrpIbroi1i1hv8lQ+OX/g==
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260610191920.GBaim4uMX3z6OqJwHr@fat_crate.local>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
Message-Id: <20260611093802.74707-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
To: <bp@alien8.de>
Date: Thu, 11 Jun 2026 17:38:02 +0800
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a2a820f+7870c8+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH v4 6/8] string: introduce memcpy_streaming() helpers
In-Reply-To: <20260610191920.GBaim4uMX3z6OqJwHr@fat_crate.local>
X-Mailer: git-send-email 2.45.2
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E139018000A
X-Rspam-User: 
X-Stat-Signature: jt67jjzy7cugzn5c7cta7yyipb844g8b
X-HE-Tag: 1781170712-705371
X-HE-Meta: U2FsdGVkX1/I8W47GU1lSH1yTFItPaxAklJQ1oYEXvL8WFQidozfsjLNqqRer15zAz5v+L9ySoVxNDf9wysjCaMLgd4vY3S/w/znSXEV+ZYR18LfOALbxnaP0ONQlvijn+Bl1jGv8pe6njQI2CCjxLFhRvhkxqn5cfht7bTZAGpyA/fFD5vhqQG3/BLWXXJ8WsdqP33ohPVjBy1gF/KmhFdjZZMcQO47ixVP2dMBbOOF9Gyt16ALXZlcvA1MTBJEcrEZM8QTKD/bq8WUqLCP85vtvM2yW6CrrEL/xhL4C6QDSlSVELSwtD6UPsW5ght6j+QyPROTKs2Tphbz7aAHV0bUrrBi6aGyFAfTtJcmsSK3B3D1M7U8x7Tmjwg+i20m76lrrfB0NchRuSaQWVQjOtwE72CKNYcNl77BctJBQLpvEo/Dqu5KaK9IzDBKPhDrhckyrRhG938A6ZRTFhbBsn1Ws7N2BXq80H8j9UztbgNajcX7446uTbJesArdHKIt1FONLfL3UUWo84cgBcjiJH7RmEqUu2wp4PQj0oH86owr4q/p7v2mfi+v0IT7woz8KvI/+mdyXATWwdN4zfFsI+pgOCY4xXlBqTPWDpcp+zmQM+RwondPB5vCPx8C1+8z5pWVqkRVPEUoJggtadwaleRM44LUNfz6Wpzd4PPu3LVtSJuTAr7wQ8LJ2ZM/MUVmWgLC2e/FFHffg40W8d9YK1Q1OQfPvy2G/JSl/oblmnABfvKjlTJZeYikQ+2e7NvDX6eDL0NJaz/z1uq0NXeWvzPJcNNWXJTa2l/NVsOoIw3CHDk2oKg6lL9fsAeesOBHD/DAstr8PW+NFUqYBrKbvCu6pZYTVxmtGytkWR5oPuWlYErkCAmwOZk2HZFtsyn2IkKN8SPggXJt3/fICLm3VNi3MbnwBOpCfs9uZu0fe1cDV/utPSI0Joo1anWpbqgddngzsPUlxOw2F5QyV68
 HkjzlPxM
 7SY28VvvG/5hnHleDichCFSxyBE3hPyXAuhc3d/shcA/R6EXUytGgpMk1r7EVrW7SQGV5b5cE3G59hIHEEVkfoLGNuXzZbOziRo3OZ8H1gupFaqmEgcsGw3T+deB7CYzqO9dqIuSPaC0u0Bg8hSjyBH/Rs4zQCVFnBP18QYBN1HDquwZq2aAi2eylxShYYqWnjp8gUBzWdqoYU9DMiGQTkmMK/YIxduREwDF2RJRJnpNpC98GAhdVKBb2JQ8rcVEAAzl5Yk3gxqB4rVx1Z6WVxDAKwcd+KnTXBSzZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 12:19:20 -0700, bp@alien8.de wrote:

> On Tue, Jun 09, 2026 at 08:01:32PM +0800, Li Zhe wrote:
> > That said, I see your layering point. If arch/x86/include/asm/string.h
> > is the preferred place for the arch-visible wrapper, I can move the
> > wrapper there in the next revision while keeping the x86_64-specific
> > implementation details in string_64.h.
> 
> No, 64-bit only's fine. We don't put any new features into 32-bit already
> anyway but that wasn't clear from the commit message what your goal is.

Thanks, that makes sense.

> > Thinking about it more, I agree that this is hard to justify for a
> > generic helper. For this series, what really matters is that the
> > struct page copies in patch 8 can use the existing x86
> > memcpy_flushcache() fastpaths where that is beneficial; I do not need
> > patch 6 to impose extra selection policy on unrelated callers.
> 
> What I am asking is, you need to show numbers why those helpers exist.
> 
> Your 0th message is talking about measuring this in VMs. If this workload is
> not VM-specific, then those numbers don't matter. They're just handwaving.
> 
> So I'd need a good justification why we need the changes before we go any
> further.

Understood.

I do not currently have access to physical PMEM hardware on my side, so
the numbers I posted so far were all from a VM-based setup. I agree that
this is not sufficient justification for introducing the helper / x86 nt
part of the series.

For the next resend, I will first split out and resend the mm-only
subset, and drop the helper / x86 nt part for now.

If anyone  has access to real PMEM hardware and is willing to test
whether that part shows a measurable benefit there, I would greatly
appreciate it.

Otherwise, is there a preferred way to justify or validate that part
without physical PMEM measurements, or is the right approach simply to
keep it out of the series until such data is available?

Thanks,
Zhe

