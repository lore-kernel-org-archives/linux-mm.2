Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98C56D26D98
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 19:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8826B0005; Fri,  9 Jan 2026 14:22:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E76296B0089; Fri,  9 Jan 2026 14:22:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57BA6B008A; Fri,  9 Jan 2026 14:22:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5B2E6B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:22:58 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78E31BB760
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 19:22:58 +0000 (UTC)
X-FDA: 84313398036.11.780156E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D29C4140008
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 19:22:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rKkJ1pP+;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767986576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dmz9+2NrdkbPh4HuhBaBl3w7A0XsLAuyEM30qxYb1aw=;
	b=VxneBWAFTvRS2qoCDyfH8rCYLrI94jpokrISXcMV3Q/FH/FesxRHlzxw5e3fDXnSXSNqXp
	BuZviSuSuLRjYxBOjPYNVT40YOVfbqhnDsHpqYl7cgvvOppT7XznhzgrolNJ5ZDMqm0dd3
	99TuqZ3xMG28a+XCMOxFH7To/q7Viw0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rKkJ1pP+;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767986576; a=rsa-sha256;
	cv=none;
	b=tGedSfXpf2K0tqXTFfCrpIbnCgKCMrhHuWwfSGo3rlp8H2KCM5i5UZZkrezBVXm/Wsmh1d
	8dwGj1WvCe0zp9+84qwEgBNHWiby0s8U/khmFPXxoXS9ckAX3VOiKbLhn9boeklEgFpvsb
	dA1uO3Pf0XpMki+DaswR5m91+l/qyIU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B2BF60150;
	Fri,  9 Jan 2026 19:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EEAC4CEF1;
	Fri,  9 Jan 2026 19:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767986575;
	bh=ZeAEQhQExtiQtbODK1SLMrltdmBdVELv64P6A1sK9Z4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rKkJ1pP+KZkWVh7sdaCZwlcc/XvO4rCGsHk2kJX8XODV3x9Lv3ZZRDyY1kT9XzDfY
	 /80DgjZwjVPxJgWeM0U0vslpwnhN1gwTZKDWY0790fUVkPTietwm3vCdvERX1eqmMm
	 dh8O4OeHSaywQQsOQUX4iETerEM2c6PSm+/+HGCo=
Date: Fri, 9 Jan 2026 11:22:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Francois Dugast
 <francois.dugast@intel.com>, <intel-xe@lists.freedesktop.org>,
 <dri-devel@lists.freedesktop.org>, Balbir Singh <balbirs@nvidia.com>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Alistair Popple
 <apopple@nvidia.com>
Subject: Re: [PATCH v3 1/7] mm: Add folio_split_unref helper
Message-Id: <20260109112254.3d831aff9f27ebe986536a4d@linux-foundation.org>
In-Reply-To: <aWFMOvGldokHHgIn@lstrano-desk.jf.intel.com>
References: <20260109085605.443316-1-francois.dugast@intel.com>
	<20260109085605.443316-2-francois.dugast@intel.com>
	<59fb1669-2908-4cab-b3c0-b97479da3fb9@kernel.org>
	<20260109103741.533c1b807f3ccf9a6f0264de@linux-foundation.org>
	<aWFMOvGldokHHgIn@lstrano-desk.jf.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D29C4140008
X-Stat-Signature: d8p5x5memmwd5a8fft6t89i4q6fd7rh9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767986576-279272
X-HE-Meta: U2FsdGVkX18hWxu2xFuvlg77EGHnmS9a2olEeySrxTvrHrkmF6KzU4k4P4eSOTNxiCuxf7IU4kwwaXav/N1KEu7ZFad8ebotrrPC02+SCdzlZfB69q2ywXJP2Zd4J2u+Go99RRB0huBRlziyMyt1vREhn2gfwvvSGSMT2hisL44tzfIadf4Ytkvfqyxl9VypzI2eKcVdoHDBNYLsozhAlG5a785SAFYOADtjC5Wf89Dv2ChN/ZhkC/1ZPrh9c2zW9jTwVK7YMXzIsJx5eyMotQ9KAq73pSErpTrsbwvOuM+rmzy6Ma9KymhHeHQE2Ftng3Sg+x7cKgANWMb8/VXwzMJ2lreNslEIkosfcHvqR05VtL4PIesDq9bok5b26EwgeZSYXZS1HbytikNfPsjNXKbijENTNZ3i800uCtDOytyjaV9aSRtu3h7uZ/kLmll7Rk0l8nv1AKoGm7Izsg6NJQW/lKUMFL7WPsshVCQ2zXADf8XYYtYoQjlyVSi0d7rKRrHoT6X7XHTS7np+SQl3qRbRsWTFd2Gsr/aEbJiw+DmMFyVe+9LWf7UdGCdgaTA3NuE09LgA+G5gP1TLMcZkKG5t4bkAAyttq2wzWGQvu+MwCawXRhyjgWvyHVDUNPF781sWlhYAh7D2wKgtxasdjnmFU4Z+C2rWR1iWYqfjcds1CR3r4ZTMMROTXoCjrdKvwVYaM1ZWexGo7PGFa8hKXU12GAxbiwXQt3L/i0PXb8yTgOVU38HOE2QaFMoicszjJDNFxzZa6n4p2kW7hkE2URZiJ35SAC1LJVDfdv2rjplkONyorgjUFMSxcr14sY8jhF/bWqpqcgrtETXOJOPiMJmne8q/c1/aUp7dgKJWTfB9EcJg8EqPl4AEM4xrsyvVLUvoFFwWnzwDlHWA46NvXz1IpZ+07zcpsKl8+pIGdMhbEknS1gKqBPeit9k+ZHZSHxtOz18mZK3yISu2wz8
 Fc5uAX7O
 vRfx62hFBbvKLDRTo9DiE8QZo0YDWtFE7WQDxqfdMOvNmxuTlHmI1cVE8ZwdpOq2j/efmOzKczLCK2P2+SVv6ikq415n/6P/A6TMumRuDocS6tUB0jzJSDe8xiAHniC4lo+cwffZvJioI2ED9C7SqhMzV0sGNtkCt7uS5iTcsItBT/1mzaNnxJqVnzxJPej2KYAM466Qg+B6dS619eeduiqB+/r08DQ1erzUtnkQtpDKNlWqzT/qhk56mVi/eg8c5A/40ZzrtKCpgAy96KDn0RAhhJaiPum2k6RUsoDkJDLs3YwxTJYpPqeRB1zohV9gTQliWwAYq5y5o3FahBlGYXwK5CA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 9 Jan 2026 10:43:06 -0800 Matthew Brost <matthew.brost@intel.com> wrote:

> On Fri, Jan 09, 2026 at 10:37:41AM -0800, Andrew Morton wrote:
> > On Fri, 9 Jan 2026 14:19:16 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
> > 
> > > I'm not CCed on the other patches in the series or the cover letter, so 
> > > I don't see the context.
> > 
> > Both linux-mm and I received a random subset of this series.  Something
> > went wrong.
> 
> Apologies for the list workflow issues. Here is the link to the entire
> series [1].

Cool.  It might be best to spray it all out again, after any IT issues
are fixed.

> For future reference, when we submit core MM patches in a series, should
> we CC linux-mm plus MM maintainers on all patches in the series, even
> those that do not touch core MM?

I think that's best.  I personally don't like seeing just a subset,
although it's trivial to go find the rest on the list.  I've heard
others state that preference, I don't know where the consensus lies.


