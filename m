Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23D61CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 05:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 231F06B0005; Thu, 28 May 2026 01:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E29C6B0088; Thu, 28 May 2026 01:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8806B008A; Thu, 28 May 2026 01:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F14B46B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 01:45:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 538FF120752
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:45:33 +0000 (UTC)
X-FDA: 84815741346.29.433C021
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id AAF91100009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:45:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EomFiBJ6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779947131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfakfS8RRgOOidKTiKlmZXDO5zaiJlaw59yW5XZxCy4=;
	b=xfhf1yQoOKGKQkNHQsjgpnaXFPZyqPmTuYxe6fSCeOG5lq3yGSUaC5IOFooch2/oLaRi21
	YvgenTo2SfDsaPwuvWsEPmX7KedGI36g2rZA0o9g6W89lI/4tM9Jt4gIWftquPkgcciK3I
	Fb2SCgGO6iLk3SotF3wuS/LD9MRJVo4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EomFiBJ6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779947131; a=rsa-sha256;
	cv=none;
	b=Rbc3bKDw1gXxXROXCm4gmWwSLif7tWeisQnDBRajKxjC7q2X44SIRciyHrQ+arDLX2921p
	eoqbcLQHxAWHBy+saKxBtiSmNDryO4UrgmB176HJ0AjK17Qrcc00EBf034Evt9H9MpCow/
	xUOhEylBgIW/ww9zSia4QNyYA7VEFmw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9659D438AD;
	Thu, 28 May 2026 05:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479831F000E9;
	Thu, 28 May 2026 05:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779947130;
	bh=IfakfS8RRgOOidKTiKlmZXDO5zaiJlaw59yW5XZxCy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EomFiBJ6qMIKdaH51IJowVJb+LsJKhSgjpKTETpHiowkp4BhqAZ+WHVGn74vtjX8G
	 JTWeeUtFyXmS38J/PqmCnbmkB7ao6fXjrC1E37LQ5p09Kj055N0sBe/U6O0CkTw59m
	 HLfrSEW0cG1AMmW24RsMZ5VvwnXvsS4Ok//hVT3kcKaumx/4Kn6bpTrXJIjuC6cGqS
	 /7lWA3xwcto44YSIpr3Xd74XWELeKFMntXA/+XxJ7b43x03NCTAfHVLSrKZ1mLDa17
	 vir6Jvc+GnRzFMB1m3scmSTWWM2VFftrVDaI5Y+eZIUHDxu5ApokX6SzFSY/QBuEaW
	 6Ynj5PBEdIbYQ==
Date: Thu, 28 May 2026 07:45:24 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Karsten Desler <kdesler@soohrt.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [REGRESSION] x86/hugetlb: AMD F15h VA alignment offset breaks
 MAP_HUGETLB alignment
Message-ID: <ahfWdMdxX68ni4ZM@localhost.localdomain>
References: <20260527143643.GO31091@soohrt.org>
 <ahcTYufV7P5Cmotq@localhost.localdomain>
 <ahc31AChKqnfItHW@localhost.localdomain>
 <5f70e840-9d0e-4cef-8574-b355cf26e0c4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f70e840-9d0e-4cef-8574-b355cf26e0c4@intel.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AAF91100009
X-Stat-Signature: 7z48wasew4ghum84ey7cbyu1w4gjky6o
X-Rspam-User: 
X-HE-Tag: 1779947131-210961
X-HE-Meta: U2FsdGVkX18NQY1UGf2/zEz219HkaMv8OIz2sUKbM1lbAn7dOFjxrROfS5gs7oJrFbkdg4DlK3zGQgwicJW2nUGPqZNG/mTgsZkwEdQAKIQ0bhmdIbybOpGJk82RVUUmqsdDBWbdU9A8FE1Cib1hvbdkLRnXOO+0vOI2Wg7tvNG5Q/Hx+UhU0FLBucYc+CAqm4btb0H9TJg9gB93F5B1qQXPu//EFfftLQ8cVlZQz286jVuZU7HzHbLyBJV1q1u5tp/WwCG+4fu4KHFlM5xJ2JhTJItIwEH4RRLno0TqoXd6Km5Vy8pXIkpAXO4YbyBLNqNADmtO8B18LW1kshxvzJ0x0g5VLCSsJUxlkhiFy+mSYMR6n5CK9YDb329STQCPZNdVMbx/WAm5oBPms5FT/tX9FOtdHmsJb6kCsHJmsXkbwEQrl1aBPPA5XDVV85r1rvuKqc8dvEAsuwL9ecC5BJVRbR0Jb3RG7NSvMd+xM4wCNXo80+LZWLLYji32R4pajCX5KVyLtnraKx8UDkaMCoKlHvb62uYbrzxZILc1CkMHEqOHSIhbL59Z5qoUNQNjn2MchBeVt7Gjm1oS9mwqyiuMNfnALkM/JzhuEmmkCs8Ap0SEdfLEAXa0yskkVX0ap/kZrJoUSvQILlLoWjrp4D/c3VV6ByVdNnnwqY9VcOkZchxPaTwDIFS02Pf6CN5ZvmpMyGbyqBkX1kwDNNWAYec8IMh6vS5umEYRDXdizR5PEDlux2SFu9E7ndH8CdU8HoGQW7aOgGaQnFXWk3SE34A69DHDstAgB3qjmtf+HI04UxqTNzPuNWXL2dm6QxUReJ9Z3dfVBDmgImGj68JmNEgZPNIKQXndJ0uBarhCSnhxVT4kmOw2KW03b6jupYkuZMcD3YEMPZ6DRPkvJq+jHbFbep96t7xMKMf/I2KpGA0+OTmmWjvKJumos1MkMZ5C8qhFpu2ndELbu3LsFqv
 EYBP/lH+
 PHrAT2zvwuOYjM+jTNgytdHZk+xUGQXiqsQf06nHJRPUzIvgLERkgAhAUIskFDSkxcq7MBSEppzvgXkREK8L4McqtGCeOtHzssx48oQIYJanvDQrxlXydaolnwXwTJRfaOd4nBxWSEL3IGB4EAviUUwjecJ/uRg6ccqicG9bWJnaVHfk3VqeBz+6MBzqB3V8UZdd4/OBclR+aCWcwppfYXocBkBYoXZwQ7sTPZT2WjQT3GZSHszgCngcF4LBPkkwaZsKA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 02:04:10PM -0700, Dave Hansen wrote:
> On 5/27/26 11:28, Oscar Salvador (SUSE) wrote:
> >   	if (filp) {
> >   		info.align_mask = get_align_mask(filp);
> >  -		info.align_offset += get_align_bits();
> >  +		/*
> >  +		 * Hugepages must remain hugepage-aligned, so skip adding an offset
> >  +		 * in case we enabled 'align_va_addr'.
> >  +		 */
> >  +		if (!is_file_hugepages(filp))
> >  +			info.align_offset += get_align_bits();
> >   	}
> 
> That's a good hack to show the scope of the problem.

Haha, do not worry, I myself have 0 interestin spreading hugetlb-specific
code around (on the contrary), but I wanted to proof the point.

> 
> But I'd really rather this be dealt with in the arch-independent code,
> not by adding hugetlb hacks to arch code. It isn't even clear to me what
> exactly goes wrong when you set a tiny ->align_offset and have a larger
> ->align_mask. Shouldn't the tiny offset just get masked off?
> 
>         gap += (info->align_offset - gap) & info->align_mask;

I would assume so, but something is definitely going in with the calculation,
as I could reproduce this if I artificially set align_offset to 0x1000 for
hugetlb mappings.

I will find some time today to have a deep look.


-- 
Oscar Salvador
SUSE Labs

