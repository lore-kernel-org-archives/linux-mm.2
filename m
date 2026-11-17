Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB90606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J7Lr7h2H
Received: by kanga.kvack.org (Postfix)
	id 6EFE36B05B4; Tue, 17 Nov 2026 07:19:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0C26B05C3; Tue, 17 Nov 2026 07:19:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6836B05C4; Tue, 17 Nov 2026 07:19:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4018C6B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:19:47 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40831C03DF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:19:45 +0000 (UTC)
X-FDA: 85444517130.04.55EF3C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9C8D64000F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:19:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J7Lr7h2H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794917983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qHTsTGMbRUu4uHJjKWa8mMXyZqa434909JPIyvfASg=;
	b=gLGai9MqeeNUjief+cpNW9gBaauX/gfe3lxpIH39974M5/ibgPOADhPkss2rg5LDtHiFpn
	ZmV0M/XV3rOILaw/mlFFrkFH6Xscio9J0xtYkX4uTxJ5RpINLr/cKYfCX91d3xbAmf+28n
	WhfsnDNhwvA4CCKqFnXsJcDsZpF4DDQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J7Lr7h2H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794917983;
	b=kGNE/fGcnYIJsn47Oq7eDwpvi3GIKEwzcjMXKFFAUSvAgU+ofk6yybJ+DkYjkpGP0sDBwW
	568qSgb3oODyPpWtKR1TwsKAWCkSNk1ajFgPPKkQ+1nq2D1WY0q0JGJBHD/jwEDMdWbGe7
	FZEbWWCjvkPTL7SUGLAtNCi543k6y3Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30529429F2;
	Tue, 17 Nov 2026 12:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DB71F000C4;
	Tue, 17 Nov 2026 12:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794917982;
	bh=8qHTsTGMbRUu4uHJjKWa8mMXyZqa434909JPIyvfASg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=J7Lr7h2HCcgTuVQeG8fRdX1IORtvd+WG/QKrKgksiuuBAwy5PUrWttWaBgbQS4H8S
	 +EgMMP+IqOirMk9hGcIyY9WsoYaVKR0dIYN7CN65qdqCDdOQqVenj6SaYIGh3iXEv9
	 U+6Di/xavaw+hN85Ql0/4V6FUOGEPFsmDMcWMCC+wcDkXdAuxucNzfsGSW5rfi6Vo+
	 PHXlulLyptBwr4ni6mh56hYPqWO77XVkXAK4NMXl3X6siimEarGlGJVr7FogKDftmU
	 vkZMZLknl5jyFa6uP8mzNs8f3AWWO6MYFfTrD/3tElPEzr1KANCYN6qsP8TS8l+lcj
	 7xe/CNz6RyxGw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Alexander Graf
 <graf@amazon.com>,  Jonathan Corbet <corbet@lwn.net>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Andrew Morton <akpm@linux-foundation.org>,  Tarun Sahu
 <tarunsahu@google.com>,  David Matlack <dmatlack@google.com>,  Samiullah
 Khawaja <skhawaja@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] KHO map
In-Reply-To: <avwoBj5ceKYjcS9G@chrisdown.name> (Chris Down's message of "Tue,
	17 Nov 2026 02:10:14 -0800")
References: <20261116134013.1636689-1-pratyush@kernel.org>
	<avwoBj5ceKYjcS9G@chrisdown.name>
Date: Tue, 17 Nov 2026 13:19:38 +0100
Message-ID: <2vxz1p8jhcpx.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 9C8D64000F
X-Stat-Signature: 8e1gisxo33813x3px91xr56n3ykh4wky
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794917983-929529
X-HE-Meta: U2FsdGVkX18w7pgk42jZYI0wSTaJBIlerPNiDz/qVnerMb+ja7II4PMtIaAgK1xVEhsDOtfHQHG+b7hf9GtuikPwFCFiWnEXfsC3cE8FdNLcYpskyfCmb9sGnaxLGlsg7Txl2fjVvicHJEhvUgeMkqaNkv16BJlCUJTRwxWAsJ1IMzeyCizqMOWETNWTC5RlZMxYiKjjZO7ZjjFjWd4JCADi9RuW4RVpGjuLvuU7Mu84NcWmI+GHi9fIJNoItpabsL6GHpTJo+EPxp0VgFXIzzDPWY5Ou+davU1zeboCMPYvTbNbgXCIDROzQb/8raqs3alqRSWrx8v75qvfcecLtaVm3H/2iJ5P4II11yZNEF3QKdeMgsYqAhxDNsyu47SJIWbsBQSFoHHsHfMyE9pM+cHV8K5iz8hbjl2/bg4uGwIMsSx1sawubRLDGcwCv5AUeKA1XuAYjEc9502maOWA4nWmDEqhYoIpXPhvouHbJ2kjlj7P31MqHVNe43S68lLYu+U7hTY9WEll7fzV1oej/gMZwqpx9sW9UTg2MaV0jcPzatfRj7l3MufkI5GafMxaOqeRKrpCQQCVuL/ycfFhtiwtLn+VftXy7CO2Zqg6ZgKc1kV2CJt7USlEaldO5kX/QGbIwhWD2VxbUthybhGBZZuSI9ZKWlWqtHtQDbe7y3Z0L7eL2GBrq5foVY6f41e6bkVksRrzkl/5/+Cb6p/oZM47p2DNtZKNRGU8IrBTu5b6xQgDgFNjgEyMYYRjz0VUpxxNbRGvS1YxqgZ5t4Ex+DlbihzSWUAYPj6zJj3QQjb5QODgC2V+z5h1KsoGb6qhgGs0YzsOvEDWvZHMGfs6eScgy6RNHieFyDcpebA9h43mFA6ZsjRHkLANEpIvrI5aK6jx7oH3DjHrcpidEJwGEnWnMOAPFdyAGFy4eYzlvew95TS0dYQNH0eBtOmCSUdPk4qk5+pSP23kCIXHCVV
 5UXjp4Yu
 HP1C0qW8kg4SQpdXdlpYLeoulEKZrEhdDcPCBYg+a9hZPGUk/vxNGE66ubq30y0K5tyKY/mP/SxWDm4f5IMYVT9fJ6oW0lTysDGznNb09bBLfQrVM/2QFyVL/7ZWV7PPlrneNdEc7ZlDPur5+cHRNIiTkMD52aWby+RKyOtKJzxeVNkEZWt0Qlq8mz6H9tWPvyEaEJpLfjA2Bo3RDbMgTkZVixA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Chris,

On Tue, Nov 17 2026, Chris Down wrote:

> Hi Pratyush,
>
> Pratyush Yadav writes:
>>The main user of the map is memfd. Currently memfd uses a vmalloc buffer
>>that has a pair of {index,pfn} to track the folios in the file. That
>>uses 16 bytes per page. The KHO map uses only 8 bytes per page with some
>>overhead. So for a 1 GiB memfd, it uses roughly half the memory.
>
> That only holds for order-0 folios though. A leaf covers 512 indices, so
> a populated memfd needs one leaf page for every 2M of file whatever the
> folio size, while the array needs 16 bytes per folio. Per 2M of file,
> that works out as:
>
>     folio size   array    map     map/array
>     4K (o0)      8K       4K      0.5x
>     8K (o1)      4K       4K      1x
>     16K (o2)     2K       4K      2x
>     64K (o4)     512      4K      8x
>     2M (o9)      16       4K      256x

Right.

>
>>- Multi-index entry support: currently, while the map is very efficient
>>  with 4k folios, it is horribly inefficient with 2M folios. Each folio
>>  in the memfd takes up a full page to track. Multi-index entry support
>>  can fix this by tracking entries that cover a whole page in the
>>  previous level, similar to page tables.
>
> Since patch 5 makes things worse for memfds with large folios, I agree
> with Pasha that this needs fixing before memfd switches over. Storing

Right, I agree as well.

> PMD-sized entries at L1 fixes the 2M case, but mTHP sizes between 4K and
> 2M would still take a full leaf for every 2M of file. Do you expect
> mTHP-backed memfds to be preserved? If so, it's probably worth handling
> them in the format before it becomes ABI.

mTHP will still work, it will just be less space efficient than 2M THPs.
Even then, the overhead is around 2M for every 1G, which is roughly
0.2%. Even then, I don't think that is too bad. If you want to be more
space efficient, use 2M THPs, or hugetlb[*]. I think that is a fair
tradeoff. Using larger page sizes also makes KHO more efficient.

We _can_ make mTHPs fairly efficient, but that comes at the cost of a
more complicated ABI. For example, we can have a per-order KHO map in
the memfd, and shift the keys by the order. That should improve the
density. We could also do some other tricks like the shifted key
encoding scheme that KHO preserved memory map uses (see
kho_encode_radix_key()) to improve density.

So unless someone can explain why mTHP memfds are important to optimize
for, I'd say mTHP users can either take the 0.2% preservation overhead,
or use 2M THPs.

[*] I sent an RFC for that some time ago, but it's been blocked on
    pending infrastructure rework like extended bootmem. I plan to send
    out a refreshed version soon.

-- 
Regards,
Pratyush Yadav

