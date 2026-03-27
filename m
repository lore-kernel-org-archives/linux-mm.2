Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 548D610F2859
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 17:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782286B008C; Fri, 27 Mar 2026 13:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732DD6B0095; Fri, 27 Mar 2026 13:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649826B0096; Fri, 27 Mar 2026 13:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 509136B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:03:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4EDA5B9A7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:03:26 +0000 (UTC)
X-FDA: 84592464012.18.15C89D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 65CAA180021
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:03:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oq9Nujey;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774631005; a=rsa-sha256;
	cv=none;
	b=GKrWCh1coyPdRctVUhVWqcwRqAEccvaBz/QgbKYBDX6VXhCdWWqfNmGggY7iBdg2L6ZWJS
	V9OY0hmyX73ZIpmnpMUXAdIlO5FGypV6QawZbB2D0GjMNFuZ1FVP9pALDvgA5o/RQ090Hm
	p3hWqWwwbj5hRwIVfWwT73CCvcBRn6Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oq9Nujey;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774631005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jlgvlIx2lZLy/yw0VsiYcAtefj+7HLiDE86xWPu3bn0=;
	b=qyzAlA/UskB9likLcrws0KInWgzxuW6qSvGjCMVDJRxKds2bJ5KG+Jl5J/m9Z87NPFKuOO
	ZZG1A91dPmXyI8B+4GbnhWi2ZQ7MrJOorsVopYb8Q07s2BGoyPUEIs0PadW0E/lVh1eX5w
	U7MOaOTyFl1WYCEO6QsGNmj0M7Ur+9Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C912360127;
	Fri, 27 Mar 2026 17:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F22BC19423;
	Fri, 27 Mar 2026 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774631004;
	bh=jlgvlIx2lZLy/yw0VsiYcAtefj+7HLiDE86xWPu3bn0=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=oq9Nujeyhp7Zx6NT/DmAKRTTx7w3723Jfsgcrx2JTII8ccXAVeunav2gzmNtcCWt4
	 g+b2onmd9YBtHJ7AgnnAAq/NWR4pHj2kIgRzkSL3306j4h3HOUuTBYP0MQBBSLDCLr
	 YLaYJ9G1El1MIqjFKuWcT5xV6/7jTsovIMJ3/INw=
Date: Fri, 27 Mar 2026 10:03:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>, willy@infradead.org,
 david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz,
 jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de,
 kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com,
 mpe@ellerman.id.au, chleroy@kernel.org, borntraeger@linux.ibm.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
 gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v5 0/6] Use killable vma write locking in most places
Message-Id: <20260327100322.b539f1a9f3662a0a4c080cce@linux-foundation.org>
In-Reply-To: <20260327094738.7150efc3b0619e6ccf095c23@linux-foundation.org>
References: <20260326080836.695207-1-surenb@google.com>
	<20260327094738.7150efc3b0619e6ccf095c23@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 65CAA180021
X-Stat-Signature: j7xhrij4o8znpyq63xs4s89ihttrtdmh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774631005-918757
X-HE-Meta: U2FsdGVkX19dyNXzKLIfmZOfDJu5k45IJizEHWcYBFeQ0fVpIv4lKqHXOVWeex8mI5BDZwUs8YKTBpwcDyUHFglPY6uqcu0H5ujY7rLHU5KxJyApSlIL+/j5jpeN6eDS3w5Okw6eLktH0barJ13X1Npj95HWXbeuOIRxiCB3lBxcjyV4IkhNvAfSK+v8nM9Vq7U2qdDoADwv3QnBlfa5Vl0Zcr0p0boIfxEyw8J+AZjV/ScJN7ZCKZQ7f6JD40hWjIBzDy0NK6DoxkTd2qJmPYc7T8IFqZgkHonFTceID5hdY8nPoOcamHnSTYWCpIGQb/Ox/Baybu8q1znuZVXZ6jxRQCdxRuJBz9g8AJtQR7h4fTTqzgLGqrs2ZZf0Zm1Kf2maTS1PuhkX1YOQ5bmWkvtoXaGUznOLtNtjvot+Q4EaUqoU6fnDnICl8Zs/2dVQujb1/Bzxlr8I7sIE9E6ArJXAyPjBEPYTJiuETz6JoIYMdSz+DiaC1a9SHWUyXrOyAeRbQ/OaNiHHXKWTO15DDaugpM5dmysm0IYgbqi0nXNA3jWJeE3sjyE6V+RlaRqBGH0fPT6mGHqwd4SxG8D2ALmrq3lKPmIu4gGki3b7OoL2YqvMfJB1K5Ybrhqm8OLhc8yWCgen27L5hrWocmu69pJJf2S8VB7vrB12+GYr0OYu+zD6oSuQUrqhHyiJIcuSt649zXHIZi03hZp9u97AC8jGPC1nSC9MxQyhJMCyiU2QZ3aJAcLLP+wri+GfKDSHriq6s27k0y19vw1B7gFZ7yHflTgM3FkbAOUPI2p8ixVhBgMn90S32dmfnrM2orp7ZOrwnbJIcbDsr74xH0tYC1VR1p6ge7eKIoJYlDWyEGHw2LF4eMbjz79Tgz+k7Vf5RAMT+ISADsuprY/p7CUMBfKM83qU+v3ZJuV6ANb6Vj1SdRZUG363kgeRRBD1RgxH0jcvmGC6A67mS71HQOC
 vJWCAulI
 wn+ruiknGVgCc+/jlk74RQ4knJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 09:47:38 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> Three of your patches lack review tags so now it's 65!

Three is now zero, thanks Lorenzo.

