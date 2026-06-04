Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18726CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 12:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A79A6B0005; Thu,  4 Jun 2026 08:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67FAF6B0088; Thu,  4 Jun 2026 08:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5949C6B008A; Thu,  4 Jun 2026 08:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 469EA6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:17:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF220406F7
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:17:37 +0000 (UTC)
X-FDA: 84842130954.16.EF4E054
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 28E122000E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:17:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eJT1W+a7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780575456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tcDaEhePlIudWCcnW0SAhasLmYK5dwxdEw+RSf4P8c=;
	b=M1lOic9s8tnnx/eQENmjdXdpzweB8UOwaCP/ExJmVhPxVG85p58UQQ/NUDaMfFWSlwF9wm
	Fw2U3ivlYo2b0fDZvslVeaMk4KElQKsD9xCILBl1WAmYpMWq5fxwAv/ADrSr385fv9QXpL
	MuJm1Fl/SRz4hf52IDIAIbcrXjpYMx0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eJT1W+a7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780575456;
	b=Qdl0Yu7uvljdh6c6aqlTzE3z3ZlGYYEQ0+pcEBYkf3ToQH2UxWhEf+vjinKA/qnF4OdCJi
	tAXp+bvMddrsfqf6ZtcehyyGS8vwad2gWpPpWRtjc9+RGddulD72fBdD7iduCqSNoQLyv8
	BJo7wwvYZhO1j6NVpV/ZJ63tmOLsIoY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68D8E43FA4;
	Thu,  4 Jun 2026 12:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7A51F00893;
	Thu,  4 Jun 2026 12:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780575455;
	bh=6tcDaEhePlIudWCcnW0SAhasLmYK5dwxdEw+RSf4P8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eJT1W+a7yBFj5f0F08Rf3p+a5QNdyb2ZOlFDLriNmO2DidwrP1SwEKpexjiYGbXtI
	 mrg493otE2WPbKmxOLVcQEDVxAX81TPqkPR+YF4hP2pW2devqPit639cMGJgjtMQU2
	 AG5qUsLs7SRJ21lXhntgVzwUiRdBV+CiXRLXYlK6qyIFJt6HP6BjhjpLKcTCpN1C2j
	 MdccibZC2LGohJqgT2WVSxIER2+5wQcA79GHLyl16IhYbrBbCKfylMKEou3aoGT+1W
	 lAJpv/fbjL+hlGx0tzVtdTaV/qtZTay37HLuxRbIdBk7BuKOR6T5UqLLfSh4toAoP4
	 y4lbtqS/nGtOA==
Date: Thu, 4 Jun 2026 15:17:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jork Loeser <jloeser@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-mm@kvack.org,
	kexec@lists.infradead.org, "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>, Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Michael Kelley <mhklinux@outlook.com>
Subject: Re: [RFC PATCH 00/20] mshv: enable kexec with Hyper-V donated pages
 and partitions
Message-ID: <aiFs0OLJQWtIbJEF@kernel.org>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
 <ahxrc4pTvVU20RTX@kernel.org>
 <f9d95fb1-ef3-d4a-19e4-afe7cdde5d1f@linux.microsoft.com>
 <ah_z3GV55RY3ZnT-@kernel.org>
 <3197c9c9-9e4f-c592-bb7-ac422f89115@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3197c9c9-9e4f-c592-bb7-ac422f89115@linux.microsoft.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 28E122000E
X-Stat-Signature: q1xn6sgfpkt1ebcemmdi4yxp88y8pdwx
X-Rspam-User: 
X-HE-Tag: 1780575456-196962
X-HE-Meta: U2FsdGVkX1+WgaZ/ny72DOsDXSxoLHW/WoLfr40/gGLMjKtU5vmwYvfgqAeKcdawFnvG8YhsNALlvymzrMXaFf64QxFfV81Sus5cDM8ljiWLwdYMlRWF0fXPNVRO7WbiShnM4kZovU+h3p9jNbhJKY0NZXUcykpj4NapfXGMyMg+DVJtmBL+0R19XWGy2B6EkUPpXZabIFaaa5VXZch8buv5lE4s/WaaBN8Hzd+kG28bUnaw6EFoG+veTTT1QUB8f+S307ksyg695mP0uikaj8gk6ngDNjB/Zw6HKl1si9vyruuzHvFTelu9Vw/qhalol0OHVGWCwadSOHUsvvblsnOcCtYw/6mgOCrmVlD6q+NSHNuVaWPXtzocdIoGvftlG+P0c8EqPGWH/9pP9TZ1zKsZCJZKl9EQkHllyvpavcZgDkzlnunmTnevX107JRJZDbXV78EK1kMFt2QqoMJTnOZ4BGzAOs4XWcwQ/0fNZsemtZvwW2nkM30a2ib2B79mgnc7MY88SfkP+4ocTm/K6AOEBUyVl61FEJCpiIA6W4fhEafYktuNVtYTjOj9Fup8FohT+jFcpfDBZCrrvCKea1FklLmLiCDkxruwwsokN/3HLE6scI+k4uCNVjhAuBqLbqowaPCro2YEFsR4OOQ/7SwKurVh/V7/Dd75FnMHAadKWWy+Ehuyga1CpV5TFw9VNUKKB+o1cRjJ27Mhu5pe4fyX88/uF/APwFpKyDf+tfqfUnsjfuD51cDx8omlYYI/xZp4Rpzi8fvjt1RNF+VKtMq7PU7vipDYrb9dZfCc8mcsRoylbTa2OM35jBZnX9LXYSfNZxxyEeNGc2pkZWVWv+VDPB7RDKklLqTu8mvX3UB+nYjooqVGGHGep62mZ8TlS0lXCKRl0uYAmbXpVxbLcmde4ohi5dkaIXmZAOv9NF4LNntplHVtVor+4ieAa/d47YCEKpChSe+yqIzOkLJ
 BvO6I9gB
 loQnWnIuxpnUiIlGBbmQPG5qyxVfLqTUcrXAiyIgTmrIL1H7UcP7fBLqRJwqqBJe/7rFTr28wn8n2CEQESz9hL2jB+5xAd/e9UjPfrNbTLkE0nq8ondcSFQoCjBCGSg9f4tHLDCH9BCRfrXaCxD7+K8w01gQGsBpIGvXDLK0wobL8WS2hOGU08KWCkIJTrIUPdxlXrHKpdyv5U1tKg9o/GsHWHFXLY01iQdbl9RPYl+MHpIZBnOVQBv2du0lzDTXgj/+fwYJXOfjXa9zSAg2o8uFbdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 10:25:58AM -0700, Jork Loeser wrote:
> 
> 
> On Wed, 3 Jun 2026, Mike Rapoport wrote:
> 
> > On Mon, Jun 01, 2026 at 01:09:41PM -0700, Jork Loeser wrote:
> > > On Sun, 31 May 2026, Mike Rapoport wrote:
> > > 
> > > > > Patch 19:      Export kexec_in_progress for modules
> > > > 
> > > > Isn't there another way to differentiate kexec reboot?
> > 
> > There's that "kexec reboot" string passed as the cmd to the reboot
> > notifier.
> > Maybe we can make it somehow more well defined API and use it?
> 
> A string? Dear my - the compiler won't flag it on an API change then, not
> ideal clearly. What's wrong with exporting kexec_in_progress()?

The policy in general is avoid exports unless strictly necessary.
A string can be declared as const char *KEXEC_REBOOT = "kexec reboot" and
used in both kexec and mshv. Not ideal, but still better.

No strong feelings from my side, just EXPORT_SYMBOL there felt a bit off.
 
> Best,
> Jork

-- 
Sincerely yours,
Mike.

