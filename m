Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA219CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 20:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABCA56B0005; Thu, 28 May 2026 16:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6D4D6B0088; Thu, 28 May 2026 16:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982E26B008A; Thu, 28 May 2026 16:27:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89FF36B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 16:27:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28F1EA09D7
	for <linux-mm@kvack.org>; Thu, 28 May 2026 20:27:33 +0000 (UTC)
X-FDA: 84817963986.03.5B1A192
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 88A874000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 20:27:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1406wq47;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780000051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qbT0AxMHd2QIhEY5Y8KbM/8oDNJsPUw1xw7s/5tIMDk=;
	b=XCKUuNx8Puc9uwk9PSG/F5q6VUlYyp+LRBB76QFlAUplimYHCIgyOZbvAvAOyTtFUMR0Pp
	S7qwTC8OL31i2ltktknCwt/ade432SiWqd39Ho8Etr1tlpuTmPseb6qmRodcFvhcshamxD
	6vd26iaYgD7TGLA6V1bZvwFXls+NwLs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1406wq47;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780000051; a=rsa-sha256;
	cv=none;
	b=TCYjCZpF5sb2c68EeZwa+AFw5LXd+SSFXrubCAjjBUj3jd4bMAdQEIsMZa1R4KMXEjdmGV
	xhEG3OHtJ4o+Mdly8Qetxf+5N46WUo5ORG9/s76PQfQ7ze9+7lsY5/L8BC0Vm0+TpbyFaw
	/1GJCsWNcBsOy59D8QcO0+dq2sVkZbE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D1E7C6020A;
	Thu, 28 May 2026 20:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CF81F00A3A;
	Thu, 28 May 2026 20:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780000050;
	bh=qbT0AxMHd2QIhEY5Y8KbM/8oDNJsPUw1xw7s/5tIMDk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1406wq47Wcf6v+Jomv5SSsDRc9sK3PYzAg2jEi/qCqCBwndSK+M0IH8esUQRaSajU
	 IZjBlqJ0yuDguYb94FYgbWgCi2qWVBPpYjx+jDUO1JyPig1a59QYvPaCKh3e3bi5+e
	 655V9UOtGqlAqlXZi7itKsgs72CgC0PU2LKyJMSw=
Date: Thu, 28 May 2026 13:27:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: david@kernel.org, willy@infradead.org, ryan.roberts@arm.com,
 linux-mm@kvack.org, r@hev.cc, jack@suse.cz, Andrew Donnellan
 <andrew+kernel@donnellan.id.au>, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com,
 dev.jain@arm.com, kees@kernel.org, kevin.brodsky@arm.com,
 lance.yang@linux.dev, Liam R.Howlett <liam@infradead.org>,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org, Al Viro
 <viro@zeniv.linux.org.uk>, wilts.infradead.org@hp2.hsd1.ca.comcast.net,
 "linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
 hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
Subject: Re: [PATCH v6 0/2] mm: improve large folio readahead for exec
 memory
Message-Id: <20260528132728.c47a38e7506483d587f64eb7@linux-foundation.org>
In-Reply-To: <20260528165635.2068012-1-usama.arif@linux.dev>
References: <20260528165635.2068012-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8q6gsjrgp4ty1chho9x79385xb61ww9x
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 88A874000C
X-HE-Tag: 1780000051-623130
X-HE-Meta: U2FsdGVkX19/2H9gS4VQUA5JUwCLH0RsGJ3qq0g8cPeSSzb/6/JJiztNt6FvaY47iGjsD2SEgrYQ294U3YENwZ+0tdO4+xsfbSOFvkwXtUszCxmLMdi7+/hfZUG9Fcu3Js/b1rvAVqiy6iYjhstxJ3q6WUPvJeOlFaMEkaZyYeclpDY7rd9fSK5A5AkNWntv/TzsDK4p2ngHHsDi1QoLrwo2HeJ7+1l1UROYP1rhjkMevc1A1Rm90iVK5B5xu73ljkrPmmCIcghzd+RHsgVngm2vkiMBK7tjLY/7z575/LSsNdu6L25nwe4+vBDuqAgJn9DUGf8WVpzNjL6+utDCn59/DQiTboNugHe0o12Yw3tpBe3SPh4yuB6acklMMjJLRNu3eZHHDwD3AsIcZXl5eaJuGNViL2fj5hG/aJv/Nik8NlhJbK6XhBifxS4UO4OwBO84yI07MHjuRIjebZk/0Urg2BJPDI33ilo9X4NvhYLn6avzVci0jbIQFGuMw8Z1qXP88SVgbKdUgxkIRrPrmaehrlNH8KjfdZicNH8QlBf/PfAXvcfU6H19UCkI0DUho0THrbQvq0QiPeqQDq2N1d7e8BpQpuC3vTtKmSXV+pIwJ9/G+Cdj5vTz7cM9KRAjPLiEmYOoF+lNcoBL+siO6zq2tSCJET/5/Gn15QBE5APlZ3lCRRvPGbXR7VonvyX0Ya/TVj4s1PsZDElI/2jv13dUIKzXnDaZ9a1Ej42uDLWPoTx1Iu8BT6gVSqsFw4Vw9pDu4l7kxUJcQIOdrzjUKW0KyVeTJpYGnpq4qWup4S2ZIddkSPy6Q85tOj1rNo2XXrodjZO44yuZIdCSvGWEOZd6zOegYfnEqp28Bpyn8Dhv997MuVR7PdZ+/RJCC3j43XMqIFJz4ife/BmWUIckmrO538w8FheOLYSkjqE47NvLaJ4lhkhpnKoeF7f1GD9cgCtkeoyCiY2kJtJ3EcN
 fjwXEI41
 hqyCAkGRbdYL4CHAckmHa+tSGXVEhz007p9sKkJ0q7wL8CCGk7eAKGkSj5jbNAuhFqkM8inaNLrqkfXshDcoO9NkmVNkysplQ2RwMiqCXbl2KqD682sX7vUFW12drYTCtZfNRQa7ix2GU1O0aY0bkyT37W6j4LQuuxP15H+WTe7kG8pL5n4oCWf7OFoTCmsAdpoSCeWjnhIILbBSEUaewTuYKOET4GxozqLu/Z/+8ubpvIiJedq/S57T7qL4gMtS/VIT3waLsxmbI1zoAxfF5b7C9HvlEgScA33E/r7M7GSFmFejOgRIQyE4mbm6Tze/Ams1zJfJpoXeo0Lw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 09:55:18 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Two checks in do_sync_mmap_readahead() limit large-folio readahead:
> 
>   1. The mmap_miss heuristic is meant to throttle wasteful speculative
>      readahead. It is currently also applied to the VM_EXEC readahead
>      path, which is targeted rather than speculative. Once mmap_miss exceeds
>      MMAP_LOTSAMISS, exec readahead - including the large-folio
>      order requested by exec_folio_order() - is disabled. On
>      configurations where the mmap_miss decrement paths are not
>      active (see patch 1) the counter only grows, so exec readahead
>      is permanently disabled after the first 100 faults.
> 
>   2. The force_thp_readahead path is gated only on
>      HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always drives the
>      readahead at HPAGE_PMD_ORDER. Configurations where
>      HPAGE_PMD_ORDER exceeds MAX_PAGECACHE_ORDER never reach this
>      path, even when the mapping itself supports usefully large
>      folios well below the cap.
> 
> Both issues are most visible on arm64 with a 64K base page size,
> where HPAGE_PMD_ORDER is 13 (512MB) -- above MAX_PAGECACHE_ORDER
> (11) -- and where fault_around_pages collapses to 1 disabling
> should_fault_around() (one of the two mmap_miss decrement sites).
> However the fixes are architecture-agnostic: patch 1 reflects the
> nature of VM_EXEC readahead regardless of base page size, and
> patch 2 generalises the gate so any mapping advertising a usefully
> large maximum folio order can benefit.

OK, thanks, it's getting late and [2/2] hasn't yet been reviewed.  I'll
add it, just, because I'm a sucker for speedups.


