Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF50BD37497
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 20:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D40BA6B02DC; Fri,  5 Dec 2025 15:15:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1D06B02DD; Fri,  5 Dec 2025 15:15:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06D16B02DE; Fri,  5 Dec 2025 15:15:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE21D6B02DC
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 15:15:05 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4ECA7139CCC
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:15:05 +0000 (UTC)
X-FDA: 84186521370.06.508A869
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7AD901C0010
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:15:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gm5rzkSR;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764965703; a=rsa-sha256;
	cv=none;
	b=baUMsFPTUkzqPaaSAitzwaD2hnJfayyRJ20x7eGPUsWeqG1jJ1cabxSZsdbrdloUrSeRAp
	Fr8Mvmq4fFAAvColOiTM9dsNBUOcgFQ/qm4e9h57Ntcw8fZU+Ehjgk1iVTN9Rk8adJmjp9
	/n+QqJ/N830aViAB1by5hMkV2PsgmfU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gm5rzkSR;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764965703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/sratM2j2+zT+D7+e0VxKe1/Q4qdRh0yBSC8HS65bX0=;
	b=pMSu1KEeAQGbY9iPW3CqgHbDG1wft1wHgAPO4vidvgxUR0vsZaOS0eICe7s4p2ElCcdueD
	tEjr0BwxcKukba2M54DpNkIOoVvabAzoNDOa5ySJ9/11Gu1aX3h8Fof54fMeXTyOTd29HX
	HtKdWMF67RVywHGBvEHa7fOyCi5wfQs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8517442AD1;
	Fri,  5 Dec 2025 20:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140B2C4CEF1;
	Fri,  5 Dec 2025 20:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764965702;
	bh=0fn1UiNC0mRB7naHeKuxyLyOMhIzaZBgB+o4/upettI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gm5rzkSRN986kBI2Nq2Pv98/LC63FI4qpEG3Y8VKWsDhuQP0Dy0m+YrTZ60ugsPOw
	 KQ34xJsPPG20q/AW/aV/nbhWcCatbOrRs9Qnezd350+uXNu8O8ZNeuWqVhUC9aFvl1
	 JvFOKL+aeMBbm+KZx1fIegQ7BylZJM7Z45C9/A+Q=
Date: Fri, 5 Dec 2025 12:15:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, oliver.sang@intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-Id: <20251205121501.bf47efd78d0a1a8f0370645c@linux-foundation.org>
In-Reply-To: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7AD901C0010
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: kojdc16kydd8qdkw8i433zn6ku6fae6d
X-HE-Tag: 1764965703-980055
X-HE-Meta: U2FsdGVkX185wfZIezGCgI4uoPdqv19hm3S8pLutoIncdTRRHTdu0RD1Q25l37Sn9dypg9reK2k4ZwjTInwlGYovhYcopRc1Rt+Zke2wbQEbWDYY8p6hznNBf7S5IKvS/fZK4VOgh8FEtNeFV23Tsfc6CKyXmY2z2B72XGILFq0I5ted1fC4RtDlXcfcfxE0rXFc66aC4kMul0oDrWQ6Y1OqX8kqhTN95rtYWRvyI+fK+I/aLjVv3ypPsdCt7v2AGykm2Cq6mhonyLa/frrDTxsWYhuBrzmsfn8CBfuIZ3qUDiXDwkbgWU6mTmwXqzypNT+c3QURlA4z42RKNfCdEbJZcFZi1zf+J2JALCYxNj6wtK+tlrqUhTs5+p3tNFnPio+AHE4dzKz97bwz+AKNBWSlqSyeLofwmmto9jadFwTXhYx7E0GF8/hk+vOuT+8ed5jUQ73/aaeKbkg34luLKW9hfEFiAKwMW54etW2R1+TLWDw/j7qGjM/YgRvbXD9Pe9sDn779IayJmIQXVi73LpTaTxum/zo6RWtLMJef7ZrybRpk2OVB/ZFiYW6FT94x15rLK8XbRWEhdaKx3aA3lPK6nHkhECoGLZqhrwNsEctQzcnsc4/XVaHsgGE/avbys+JRE+ydluugKSIa/0qoXMFAQBy4/4DfhUSNkDtMJv71mkrFEgiRgalxUK/VDb8YuFPMHJkszxn8vBFiq32koN+6Ex1yl49WJrED40eN1GhjVJBDMtsYs8hbSeWn+Zv738UY3x3+K4VYQhldhbXaW1FXq+nI5kAZ83BONIvU23i6N/g4KIUGg8xvOvfVnZ5uXSyWgQ6tfGnZdP1N60kPsPk5bdDPqIpjSHkgGbHNfT5pJCLUymM+t3JfhrJm88sGdHRcIUkQ554NjDnu0McT0JphgboWOoGu+Zu7Hzv1M/Eo1DG6Ummk3WMlU7Cf/ZyEbbRRT/BFnBNWd/pNufB
 vwTuuIyJ
 /TtbMKgeuEUvKu90eJF7WN5vcfsgR3DrvIAv53EZzMOc2kbUWjQHnlMUx/mkK2taUbjZKHcGKOMyrhzdvbBr9l7s37jidq7vfoCiGgu3JxCyptnNz0UNo+mPn2l5jJfX0UdsIKzQ64PTdqYxpKNRIYQUrvo09YylREIX4pBdVhtOSrSPte/0rUeSRwjyal1GKqetrLNoyOXuHFwsifL931mpEpnRksenrdGoxZRi/cVcx6Cn5iirAdHBpUmtCmp7x4k7cQdaNbG82/rGuIpPIP03Thw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  5 Dec 2025 17:50:37 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
>
> ...
>
> Andrew - note I've referenced the linux-next commit number above, could you
> replace with the upstream commit hash once your PR is taken? Thanks!

That's in mm-stable so the hash shouldn't be changing.


I'm not really sure what's the best way to determine this.  I use

hp2:/usr/src/mm> git tag --contains 2b6a3f061f11
mm-everything-2025-11-29-19-43
mm-everything-2025-12-01-19-02
mm-everything-2025-12-03-23-49
mm-everything-2025-12-05-00-55
mm-stable-2025-12-03-21-26

