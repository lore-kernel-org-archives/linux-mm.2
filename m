Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3000DCDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171256B008C; Wed, 24 Jun 2026 09:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122876B0092; Wed, 24 Jun 2026 09:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039636B0093; Wed, 24 Jun 2026 09:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D49D56B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:46:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5EBC5A0342
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:46:20 +0000 (UTC)
X-FDA: 84914930520.21.A5EC8A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C1F488001A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:46:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mCcRCXHC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782308778;
	b=ML1S7UqXgEQcUC67qBKOWXLS9+zcRvkvMx+3HwzDVjwPep8lu5+FjFqWhBO6ao6hQT7RSq
	uyj+xQSXS+FRUmM6zezXdrU1jThxtKPGv103enwTbkupHf2to0I603Nkyn4HSwVJMYIPwT
	KD0TJ1jdv8SMR3PY0TTIRbnBl96XwF4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782308778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYlbsNCB5Y7k7wf7H2fvFo08C54gNtYTSRX/Cm+qbWM=;
	b=pyk7rIFhYapFanSmHu4PLCDpSJ1GKnK/C79EQ1HJdx3AdKH9IBtGGCIRp8+cEmXmP6/O8z
	HmUCASb2bBrgfIdI7ZdbF3uT3uQJKz2XmQWT8xSX4oGcjq8mhKHfg6NF8b8N8gjhN8v7FC
	V0VSITRPhQH4GPlLQH8Wt10Pc0kDQWQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mCcRCXHC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C9EC60216;
	Wed, 24 Jun 2026 13:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620DE1F000E9;
	Wed, 24 Jun 2026 13:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782308778;
	bh=kYlbsNCB5Y7k7wf7H2fvFo08C54gNtYTSRX/Cm+qbWM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=mCcRCXHCV98flmEkeWGULIwa4FVuqjTSq4bqGMhm/vXUFQXnkNWbuNJNcBO2Yk9kC
	 0p1sXX/+mkrw1YH/9PISPObfmwjI2m3/Qu3oqAQQ750KlKEg0eYoDwaO22NpiH4dgU
	 GsdoZ+rf2iNqO3J8CKWNPn0yE7ba6Pw+FjxO9A2K3SeKp8NX1DHNXFa8ZYbKGYEyW/
	 CYAqsZhSWSWNgvyWoyV/IDww4ErBNhVyREsECfBdDPT4qFoYyKNbZTOWJZxCqXe/EO
	 W7Llaeb5g6Seg6K+ItPs3sZK+YKPgECOQacgbR38FmeRQ2jeXvqEmiLfQqLa7WqKXj
	 NrKfq4C4OuiYw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Breno Leitao <leitao@debian.org>,  Ard Biesheuvel <ardb@kernel.org>,
  nao.horiguchi@gmail.com,  linmiaohe@huawei.com,  david@kernel.org,
  lance.yang@linux.dev,  akpm@linux-foundation.org,  baoquan.he@linux.dev,
  rppt@kernel.org,  pratyush@kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  rneu@meta.com,  riel@surriel.com,  caggio@meta.com
Subject: Re: mm/hwpoison: persist poisoned PFN list across kexec via KHO [RFC]
In-Reply-To: <aju5_WjBtagTOSJw@thinkstation> (Kiryl Shutsemau's message of
	"Wed, 24 Jun 2026 13:04:19 +0100")
References: <ajut_LDQGYCShApx@gmail.com> <aju5_WjBtagTOSJw@thinkstation>
Date: Wed, 24 Jun 2026 15:46:14 +0200
Message-ID: <2vxzo6h0kq55.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1F488001A
X-Stat-Signature: 1mtocchzdf7u7q4k7wbreihaa5hjptxs
X-HE-Tag: 1782308778-40211
X-HE-Meta: U2FsdGVkX1+uQ7ANVBrHblFs4YZZlfJjyBcca9ogom6FPpDO3pWz1rS8H8H8RjSQ+ihE9OwcSFG/HpTXlLKfxOn9wh5qawy4e6GORYnrRUmy/0Tw6JwN2NGv5NKwG2yPB97MrS2acRDx71AsogM4U8WUbz5rPxDb/0VT/f1hCnMYpfPCSluIp2bmiJc4lNLc2GQKlGhJLyVRtGbr1lf5KZvWDq8UF4Xvqn03+pJoqBq6SnpdEa4qEYXoAC+PAIblCc9bDzHySOK7v1TiQ4EGNnU8P9rvPpNKFMDnfaGOjhf8XNQeqtjhdBm/J/DSz3LvaAFjSiuZ9pwaeyBCI8q1csG8H6fjf//KO2UnnbSbtjBbuQy/iSYGIfw1nlgljzvOunippjruJQcby8Jw719Ek8wJzOLGWPeELAWAlyk9w4Rm/MEKs1ZoEqq4xr5Re5w/wPvh5iD7QLFb3ieRbYhHlPnudSeStZ3naLsnKLfzCmoCPOtECVs+nPteZ1i71pIxUZiOLsx9Ok7t8saJhfMCcsUTcdqHoupQOyhFdNtgkst/uJyuZMeJMbuRRpcvhfj6ilXMNgjCuk+h+cpUOezJb9XyIKyOqmcxoy98ZkPx8zUMY84p6MVAarVXbi+Er/kk2V1QJ/iv0ZtFEyCUj+aFhIYbByZcrfqVPMTOJUY3qoZS8Ha8nQWnEu1bXdsmx+qUqB5a8tiQ0sMxvQL34svC0dDRPWaQtwcPDW2z7gGe8QuN/BxXPcwM7asAG2zgkYxGHiMn+d3FgE9g+6NIn8tcMgyw4jt0FD9BuXlD0mqQo0IbHeCGARPfxxcTEYnt1cJgOJ9FjBU42PC/Yra4/KvqCew48d/cK/0uOYhhvdqWGKJ7G2I15GGKcAGPqHt9lqPyDRd4L0GSk91jJsRG3RkWZROFVO5QivTuVDP5vnSvf1RpWv3xIUU2nQCPf5X+tr3jT70DwmH5S394tNiub5c
 /ubpHn6A
 DS/Dd1mSSLSFN38Wq1SmS3bEVyox7HvIyeUnK79yV2U8v7aif5p6SiuJhehHC4u8VnDhWFrUzSGta7EAkkHZ9ZrL/zOjb/6537ThFjK4mXhz/sneUXe1T3iUPtnt5DEREV/yOb2z40Z3UCPvdYNiAv7iuR48kLGzMFvqZRxPJREeX5P9QcylWkiJT4cAmIU9GlWXXmPQba9q0jAOSTRw8zqKGkGZPBc+tZt53oIspNXqbbcGKF6IDKn4TSYpAXzYrFEiYfdfK+bZJdmxzYICnfFnS+L0WZCx9puTjVw01TjZi07GLxy+BVDnRLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24 2026, Kiryl Shutsemau wrote:

> On Wed, Jun 24, 2026 at 03:39:38AM -0700, Breno Leitao wrote:
>>   * Consumer: early in the next boot (fs_initcall_sync, before the
>>     buddy allocator has handed anything out) it restores that array
>>     and re-runs memory_failure() on each PFN, re-offlining the frame
>>     and rebuilding the full hwpoison state (PG_hwpoison, counters,
>>     HardwareCorrupted).
>
> fs_initcall_sync is not before buddy hands anything out - buddy has been
> live since memblock_free_all() in start_kernel(), and every initcall before
> this one has allocated freely. So this is recovery, not prevention: you may
> be running memory_failure() against a frame already in use, possibly by a
> kernel allocation.
>
> Two windows are missed entirely:
>
>   - memblock allocations between setup_arch() and memblock_free_all()
>     (page tables, mem_map[], percpu) can land on the bad frame.
>
>   - The kernel image itself: KASLR picks its location in the
>     decompressor/stub, long before any initcall. The next kernel can end
>     up running *on* the bad frame.

With KHO, you have "scratch memory", a pre-reserved area of memory on
cold boot. The kernel image is always in this area when KHO is used. I
think it would be a fair idea to deny kexec if any of the pages in this
scratch area are poisoned. Because at that point you can't reliably boot
anyway.

Normally, all allocations between setup_arch() and memblock_free_all()
_also_ happen from scratch memory, so this check would solve the first
problem too... but I recently added patches [0] to change this. So I
think we do need to identify the poisoned pages early in boot.

[0] https://lore.kernel.org/kexec/20260605183501.3884950-16-pratyush@kernel.org/

[...]

-- 
Regards,
Pratyush Yadav

