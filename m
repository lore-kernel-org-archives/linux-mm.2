Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D284C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2E286B00BB; Fri, 17 Jul 2026 14:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05FC6B00BD; Fri, 17 Jul 2026 14:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1C0B6B00BE; Fri, 17 Jul 2026 14:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8B0C6B00BB
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:11:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34BAFA0443
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:11:08 +0000 (UTC)
X-FDA: 84999060216.01.C7C7535
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id AF08D20004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:11:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=IqJrUL7c;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784311866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPmbqf9uyCcKnQQHBZ8qJ6WEarZSzlfc3+zUiESAp+U=;
	b=qpHMcGGR2vnaJBxS8C5yWe259jQdB0Ce+UB2khm24jWgKn5oolEui9WtyDGwKMgUUWJQh7
	hvgkkiOhnaFysTneDyx1wGutdXUt8pOFGW5ogqijNMHLaU6slnA9pFDBkOlp0LzjqdTQ0m
	iugpw+gl761gsBiFXZvrmYHEVP6Zj1A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=IqJrUL7c;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784311866;
	b=haTYFq1tVfkWjh/oYK56FphSGWIPphhFa2i68qBVVDQjW0lNddCFt+I07ErjtAzq2+6VXM
	FmdXSvLsAmxQcjOFNtY7kDOuuzA7lD1qUxav1cm1gXeXl6oLJmCGBLDjWpDWMaylN5qZ+d
	jll0UHe2ThxolUCuDlqtvLqnGsd/cdk=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5AA9440E019E;
	Fri, 17 Jul 2026 18:11:02 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id u8fFbPN4AXBQ; Fri, 17 Jul 2026 18:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784311852; bh=bPmbqf9uyCcKnQQHBZ8qJ6WEarZSzlfc3+zUiESAp+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IqJrUL7cP7mIgpNONmTCu4WcE4TxmRVaFAl4dPpyzG+oV0TNzjMUDTrgieox7AbQ0
	 BERvJrvSZK0HWtYOEbcvaH96YVV6j2mVMSozgcdwxNMWH1a39vphGkb98//AXYO3+y
	 zu4Vc1XbDz2CiMLluP0tFABdFhidZpw99WP95WYs67lGgY8Xya+spL7kw4h8KNIDQ7
	 Z8iGse3DNUXlVOj4b61XN+YhlR+gs5Qw1G2f9cSgHRnAou0MJoCEI6C2AoJtBzmaKw
	 nkH+4fv8UqOInOt9toWCHKhYSLC0+58MScyBC3ITb42SMkHykE8oDYd/34I5e0wJbd
	 ZUetXFu9XjWMYtpojw3F1B5xEjX4Rb+asflz6f+Jvizt2fRNotw3Dt8CYOc7TT/kxu
	 uHQCnKviymZrUS+U/L478dk9CKDXl2jzEKgszWaY9y4TF79jDoFt+P1dovW3C1ZEWm
	 i8X6BfckPOqBmKWq4o+B8Ihv6fsAfGhsFqwGAQ4U0Hlg53LJDFoDfGOvjMvIlikhoG
	 mxdbxTqK8+IoL9FbzcA+p8KLtVvMX1LYhF9HgSD/u5t2bIZVEmjzDB0qUzJCXs0kCY
	 qoEpjNMo7X3+jlCLAnsJKndoPJXOHKA3fSgpSgF+DdRZ0nIaTUI7M6ItOwneKTfCDP
	 /3zT5ryLd6YHw269x00DqZc0=
Received: from stx.tnic (unknown [165.204.77.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8ABD040E02B0;
	Fri, 17 Jul 2026 18:10:23 +0000 (UTC)
Date: Fri, 17 Jul 2026 11:10:04 -0700
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Jinchao Wang <wangjinchao600@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Randy Dunlap <rdunlap@infradead.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/13] mm/kwatch: dynamic hardware watchpoints for
 hunting memory corruption
Message-ID: <20260717181004.GBalpv_MOaAflgFxgh@fat_crate.local>
References: <20260717125023.1895892-1-wangjinchao600@gmail.com>
 <91f3486b-3b85-4b43-b099-0a5325643352@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <91f3486b-3b85-4b43-b099-0a5325643352@intel.com>
X-Stat-Signature: rtwbiwwazxf6hxpqebdwbf8hr8aiqs9m
X-Rspamd-Queue-Id: AF08D20004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784311865-110744
X-HE-Meta: U2FsdGVkX191VTSVHDL4F8x5hD1+mMU2ET+39KxYvewSiTklgkHIMb6akGpdaaPgWSECw16efur3Gsc/ihKtxL8JxNjWdpRS0ENpgqL9fyGdAYp6g4li7m7QkbTNEkrURM1ci4EqcyRWheuS+h28SvD5GUkZwzKrmouCH9c8Go8uDMclNacizHYeXAbKbyPTBwLWSz1oPBU3hIdrcHtxtwAh1AEewkXRaU0AFa45PBbhYST79Ix5nHvlThpJtBBeQdvZXehWz1SqjqWunGpj6xBlLnpduFB+7Z9vP5dmw3upTlkgNDWheoqT/hYtKViVZN3MZc/BXv4I8RcX+jp6Ina7Lbmou+yjPbbvPfVsYn+8YJLtbTUaMVr7Gt8U1RpmABu+ICMJEPzWD4N4miQzpKJ4nRVjuO9tAnvik+8tMDMob9XGSFwEvwGf/fpLoeC1S0JT1lInKXiuBcyOQIHwYyy45an/aV+D5H6SmO3g5OZvm6eUS9n/CigUwpftmy9F/ZBKGAFLmtRGPLQiVe1ehTI/6PZBUCO/KrSJ5NWZX8rVhwvrfUBnPJAlHChuRNV35HHa6EseW0WqJGsDHmSERj39dfeEczm9/4xstjU8Y5FcXJQ7ofkdGsOSALgNWGtYCnXlUqRFET/VhOxKK/rbpZpZheV3pves4xlurSdWhArQBrjvIqESi71TGxsqBcyw94JBiL31QJaoqL7QCjB0inM/2Iq8N6JtLT8+aBdVrW58bCYCHxX9yb9Hk5erncMLAodOmpyrb7SgyP+mv9B+/Isevgk3i2u9eFaCfP8yKaWXUKgOV9AXiFNYI3XecbPnT+oBsZZZJHwat/Xp7n9TNG44+cWNt9nGYXzNEjghrb5+GM38gQgFkLXIwYqs8cfDDpEgflEtq1C/6uXZ10KJM6oVR1953KYnr4uJH7dwUSUzfCmdoVRLF1chizEyluKbxRumokRV5CCm1tCe1UX
 sFYAd9kT
 ImAxNnmi1QoDUj6qt74zbw2Tf4nkDCUgwsWSQx2Fx93pFVTA1gZpOtzna1mPEQCRGtcyQLl8ra9xID9PXKtms5YYxAlDHjbQ2Bwk6TQzLhRvyPXgd2uBZtFTAXpKrh9tKALayu+uiGT8mYZjzOz4YQcMrlu9ZqhLXtAybIgda4mZLICy6CnMz6FK9SoPAyBe+VKxPAIYOqiYsPymGcSpvBWDJ0lgj47b06jcKPjfz6LfWqL/gu1wywRK/eyQQdmj+EqH+i8f8/O05DzND3Te7S4dCVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 06:41:49AM -0700, Dave Hansen wrote:
> On 7/17/26 05:50, Jinchao Wang wrote:
> >  24 files changed, 2115 insertions(+), 63 deletions(-)
> Reading this, I wonder how many kernel debugging features we need. I
> don't even think we have a centralized list of them. They all just live
> in their own silos.
> 
> This one really seems like a super specialized tool. It has to be
> enabled at compile time and specifically aimed at a specific function.
> 
> Maybe this should live off on the side for a while. If folks end up
> actually needing it, they can point their friendly LLM over to its tree.

Right, and in my mbox right under this mail thread there's a

https://lore.kernel.org/all/178429796992.157981.3393977217853767915.stgit@devnote2/

which Masami has been blasting almost every day this week which contains two
of the patches from this set here...

Looks to me like folks need to sit down and agree on strategy first.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

