Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACB75C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 22:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16D686B0088; Fri, 26 Jun 2026 18:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E7B6B008A; Fri, 26 Jun 2026 18:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035166B0092; Fri, 26 Jun 2026 18:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3DEF6B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:46:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 201491205EC
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 22:46:41 +0000 (UTC)
X-FDA: 84923549802.08.E623CC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9B623A0002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 22:46:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqgdKMWA;
	spf=pass (imf25.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782513999;
	b=MR7Woa32Vq4N2T48vGws0zDyzx2dlI3YTt36zo9ruRiDahq6PxjYzjjFw4+kyKFuZnT0RM
	INMCcQPBOPbk0IiZ3tXLsmjb2Z6pcvVRC2qDJw+qU3E/Ct2qX9xA1KfxDlAUIty48rHF2H
	z3JsiK8rNyyEfV32LEhBKis9qWqO7HE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782513999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dk8o8TjgL8E5/MT1l+L2Njj6Dbt7XMOsztbpkarmT8g=;
	b=eBF3HklZIM7N7HdD/ZXNMg7avzcLTelWIardu/Ka6PfXPtaomSVySIv+LY2vlHSCVRbECn
	vcGP3UaiPxXp1xIGz6IP6nbhEeC96uwGSDCjuD+yOEDUEfD9nVV07dtL3UplpW0KL3LYfa
	Kw8DEekngUIISn4mJIrsSiHgHImIsr8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mqgdKMWA;
	spf=pass (imf25.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C078600AA;
	Fri, 26 Jun 2026 22:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276D91F000E9;
	Fri, 26 Jun 2026 22:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782513998;
	bh=Dk8o8TjgL8E5/MT1l+L2Njj6Dbt7XMOsztbpkarmT8g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=mqgdKMWA5L14HBYP/Txfanylf+NfH5G1eoR8JcyEfLVUZvQ0axgsYT7WXLVir5J6R
	 4ayNIhaNIVvw0YV0fJFYnBwDXcJmbVptRarN5EAA+ojbCCFNLtYt8VSd8TYgXwIE0v
	 t3E7ApCJr6d+Le/t8EjnoKncmqBNIrflpfe4eD75akldNRa22YsmCZUqUdDy9atMga
	 AeF0zRixvTKQ9JSRs3nyAHYZl4AUqEb+DZjfGsj2k28b+tehXVLywxwoQWpnG2LmNU
	 sYxksEvP5eQWkdk7GWQnuwK/jNfyzpL0s8g+i4X2asZmxFY2saZMWUfhwEbz7dww9d
	 uZX49qS5hagFQ==
From: Thomas Gleixner <tglx@kernel.org>
To: David Stevens <stevensd@google.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>,
 Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li
 <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 10/13] fork: Store task pointer in unpopulated stack
 ptes
In-Reply-To: <20260424191456.2679717-11-stevensd@google.com>
References: <20260424191456.2679717-1-stevensd@google.com>
 <20260424191456.2679717-11-stevensd@google.com>
Date: Sat, 27 Jun 2026 00:46:35 +0200
Message-ID: <87wlvkhqd0.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: n8h9ukwru7ox31kz3bsx94yt7uxn5opn
X-Rspamd-Queue-Id: 9B623A0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782513999-684191
X-HE-Meta: U2FsdGVkX18XqtFDlfaLVSrT2xLITvZudJOogor+kWQ6Jm/p4nbmp0TXUZNKoBeMV2U3cw+zYdVi7KvDd5vpZ9uUZit3meaOFEUYpMLbJvtz7nn+t3M3M9bUiBCVoWe4qHQ31qePOVhHdPTcJYrwAKzs7HCQGQSjsG9NBBJmrUpB0GyYRWzQk/twz8hMG+S6m1odbUSrKe0lBeeQ/5wgFLwG/alLSbYzClAAhPVDRbW5Bz1s97EpSpR2s32V53+b1CO/EKpmZaKPPuHxfXkD/dxtH9BgUppJdcCmqTz/W1lRtrQ3klLBdL3swW70Wk7+Cgi8ru2EgXnVDYMxNxIoQ1a2KIriivhxVkdiVfmNVnQ25FnFJMx/RGD6ZgVzZ0nnMy6UAb1bP9vvRdhkH1lDU1laJFdSuOz1sNQsjxAHOWPJCxKLXZjIUBWY3O+uig3dSKIoMlWPdfZbYqvrrXAWVhM6de/y6CraiWQ/f609mZi9nWgfAxV0DCQA8TNocQhwrO2JX4s+p7TOVCewNowepdMPPJBk1mft0w4xiMzdpa7Khy0pmOOERliG6kMeA2I5zpOSmdW6WfhG1OCE1HW+HLODOyDWCNuOIZN0XFI/WERu5+Os7/pxDHh6XeBNQSaQc7BvH3cxSF8SKMinil2dzvDPzmfu/J0eykeFFZFOOP81WaLfV9P4+2bAysp5/5n/GWceUZWDLtSuW3Hx+THmCHhajfr3J1Yh0vXFAUh4Mi+YUvbTqodlb1DW4fkVW4m2r6aAaSMZ9gJNRhxeHuBois2D1vu83/ntMn8hPkNsMn6uGkpJvgPPpNHiSgWQW9QFVaQHYk4FCNFks+t0i2q4c20hTg3hXkuDAX2dLw2k4y+2imkzLai1WC5QmKfz5Zhfv+wE8RziSIvboDAIcvmb6zHlKwwdCrgJlW8+d8UO1ykpyfGc9ryYu3ylZv4xLifBcAbBIS1bRH8Brzc/06M
 Oi3tXJFn
 0OIh60Q1o+BioHHAcBjGbihTVZGQA+tNe3wS1iBy8OysUeFy4lSxXzOeD1miSehgfLblPxh/JZnK9FmGv2UHsTXh/SC5KvW6vtBk4mc8fn572Lg9mleBs9Axc3reEbVBbMYtEPyq/LmWkqVnyQXh5DRhj7uAskxpUBhgqw7ah8gVoA0yBodOEOyVYqgfvywQ7lHwwLkm02C4UzpGts7aVcHoggEhc8PDUuZzMnx4Wk3kkB/aoNGlpZ/wxrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24 2026 at 12:14, David Stevens wrote:
> Store the task pointer in the ptes of the unpopulated pages of dynamic
> stacks, to allow the vm_struct pointer to be retrieved without relying
> on any locks or current.

You fail to explain why you can't use current. Changelogs have to
describe the WHY and not the WHAT.

>  
> -bool is_vmalloc_addr(const void *x)
> +noinstr bool is_vmalloc_addr(const void *x)
>  {
>  	unsigned long addr = (unsigned long)kasan_reset_tag(x);

noinstr is not enough here unless this depends on !KASAN because
kasan_reset_tag() is a 'static inline' which CLANG happily puts out of
line into the instrumentable section...


