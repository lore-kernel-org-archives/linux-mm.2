Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D351CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC6166B0093; Fri, 22 May 2026 11:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9D3F6B0096; Fri, 22 May 2026 11:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDA066B0098; Fri, 22 May 2026 11:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFC666B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:17:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C2A51C1A2C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:17:13 +0000 (UTC)
X-FDA: 84795409146.23.1FF5D8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 970F4A0017
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:17:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NPFVnJV2;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779463031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IBsvFhUx7DS38QNIm3xpHJAHnKglEvOlaw57vqv6PFs=;
	b=2Jgnhii9ymxVlUN4//lgjITvdbxrff1Hi6skM9L5jLECT9wewBr8QIf91IJ1fUPdkyqS23
	9BIlNBHBDINM6oU/bMrky9/OVdMEQ8JMpjhb/iq/F7yeodpoATNcDwWNLYeL6IdBHB+CF6
	0L9VQMa2DjJ6Vcu1LZIBJIDIH6SjW5E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NPFVnJV2;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779463031; a=rsa-sha256;
	cv=none;
	b=V43WFZRCDD+RmCwwA7DQCEmM3DKpLJrPtJyYmfI/aY3F3bGKdTWP217lMnnpiOelBdzM65
	s8Zn7kDu4T9ciycN+rDMrNWOgQyvXU9l4kt34mWAjuucRBP2aBp26UJEYhhsc78YDZKRuJ
	xQ/9FB8Sy0Vafz6EpFMAIJxINzkgbUo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCD0244328;
	Fri, 22 May 2026 15:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F5F1F000E9;
	Fri, 22 May 2026 15:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779463030;
	bh=IBsvFhUx7DS38QNIm3xpHJAHnKglEvOlaw57vqv6PFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NPFVnJV2aGaaQ7+gUElo5SjZoXRihKPy13sFa36i3fOouejoHK0Jj3X/OoG+3IKQB
	 w6PBonP+kRBXydLxpJX6HHG15vaVqRY5iES7/+nv42Dn4qnqgiuoGDULeX2ZOtEII7
	 HwTDUw3Ir73SHqdpMIZDCMU6/ngtdFjB3UEIWN5CJV4UdSZckRyaKuI/wEAkgUGcaA
	 PPqwJOKQ6N+k3PuIAjBeqwjUyNzYgyTPzFo4sZaHTiQFXeCWpqqAahpKXPiF1i47Wr
	 wRgxjS4N1mttbsjv6e0BTtBb25f4AxpKcxOtHjJISYWseXSvTGff3gYuTIMlIHllek
	 26357kKMZzdkA==
Date: Fri, 22 May 2026 16:16:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP
 collapse support
Message-ID: <ahByO_HWn6MB8z-u@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
X-Rspamd-Queue-Id: 970F4A0017
X-Stat-Signature: 7o8odb7ef53qrrjg6y7e4baarb6kzcsw
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779463031-537506
X-HE-Meta: U2FsdGVkX1/77fvbl+9Np+72I89egSjS6Rldy7mZM/rK0dohwglcK1d86NX2lrauhzxStpyrp8zlhXe5K42pSVNLHxMEngM8qJ55F8rdyZRDcB6S9OBohTIwOwp8YvEKPwMEY19vElAsKL48d3cxFBFdt6PA5kDQDiBXZ4k8uNsaQjmiIcsA2XEUltg740pyB1aAl/61SyRRnZAhkWqA4QcKN3CNAS2OU4ssjKptJzBU6LraxdI51zGFRkc6gp+AhLbwkrPuxMUsKcqjO2P2ksqNAGsALyi1DAO/Z66ofgV1RsxmWKaHpAm1LAAdMQzv5fPW2vfEh7hq5pbyauqj+bRlMLC6432vvcYrWPgRW0obKtRAAhwlxkIxLoFHCxGvGG23yGe7BGYyK69iieHb7XyraTF+VgBg88EuhcjgYZHiYeazYFKwXAZXWyCsqBoTHVRzQgKQ+7CXAfKgsRmsDm5NuY3ITxbYvBcNLulBqTQpiVBGyNfBH2VfwYM+7OPcUAckt/MnGKH8vCfVskOzKGLT6fpY6HXpyyv/UmTpGjyMlpWPepHZ8qgV+ZpBw0Y0BxnuScjLxePZGzoXBGJmwL0aXKcrP77J5PvwaQbNGmVaKDS8QFXhKDATC5jxqj5OQnmCHnLqM1RL+A+Wy012iXyf+Lw3NAFZ9+WsJBXgTso+VqowK00SKDD1KuEHjou15RsapU03+YSj7EaRfgkEpKjb0G6w7pjhg0pszxigDQDbwiFLTjG2e9TrtO+PF/P3SYnOX4mBmtgcAVMKyQOPFepvkQ8eX8uaRZh2D/1a2brY0nSSLTCZRXN7kvZzlWAE2gL7oFo17fiN4QteWCayhgA1t8Fc5Lq/RHjh45FayuS/docFRBKUoz3EWgM69aqqQyRs+tgiozO3fXppVU3r0u9MlqWOQdQPJ7PC/5PhqJp05pHzLxyesD3CeEmYyrigPqK5D4+9xMqcJBFn75Z
 vDZFhS2V
 FVtWY3PUWd+rlGtugsfgTYgoB8+T0rjz89IfXVyC0HEYCfYmzAlfam7wknC8mNT7oy8zHRvy985dkqaRTSwwtoAC/FmgAlXqueFtaLd4CpMQhZm7W5dCGPzvl9cGJTTOykHyx30Erw9hlayiPEKACd0lQenCTXfAjeR6XQU9flyRU/Qr9lNHxwHM3FyJI3eCIVybMNUzQJAf20Cm3wjPJu0edorNl48Ak8penhFcz0CCd5hXwGE+4k3zFGAqFyY2VP1ll/7I/9tSW5DaD/G8+IaHhOn0HSWc6vPnNo49a9KSWrjt7sqMJyw7qPRz0w+GQAehU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 09:07:29AM -0600, Nico Pache wrote:
> Whoops I manually changed the coverletter subject to reflect that this
> in on mm-hotfixes-unstable but never updated the others...
>
> Hopefully that is ok. Just a small mistake. Base commit is referenced here.

It's not ok, this isn't suitable for a hotfix in any way shape or form?

As you know, because we told you :) May has been difficult because of
conferences, holidays (and in my case burnout recovery).

And unfortunately the series seems to have needed quite a bit of review again
(my suggestion to you would be to ensure you don't make major changes, only
small incremental ones on the basis of review feedback).

So this isn't viable for 7.2, and we'll have to target 7.3. Therefore there
was no rush.

Also please don't spring a respin on this series on us without discussion
first, with people away and (frankly) the amount of work involved here,
you're going to have to accept the pace that workload/availability permits.

Adding spurious hotfixes tags doesn't help anything :) please don't do that
again.

Thanks, Lorenzo

