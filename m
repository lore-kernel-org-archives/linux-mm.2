Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CBFD606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a5gEbz0j
Received: by kanga.kvack.org (Postfix)
	id 961C16B05B0; Sat,  7 Nov 2026 12:16:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933196B05B1; Sat,  7 Nov 2026 12:16:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822286B05B2; Sat,  7 Nov 2026 12:16:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 609C96B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:16:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED8B21403C1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:16:31 +0000 (UTC)
X-FDA: 85408976982.01.3D50030
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 56841C0006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:16:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5gEbz0j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794071790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLQrysRtojRVCkoj2Wpy2cpXj05kr7eHKjA5uK2krN0=;
	b=nLbW6Yk8ckRgR0a/HPbPFvS/TSIiQXaURQqJZj3caf8hEjyJLAA3lNpR6iR8Ktsyj6f+cZ
	hQEFpFzFodL9ylDsb8IiFzMNogTdQdgGOPsX1OKWPpmKPzVbkxsJ+G/6Earpl0+XYubaoP
	SxA9YxskI/2PK89dlJmln/65Yn0FbKk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794071790;
	b=rbtXkPihyjiCKk4Vr0AvmXpfleDnZM9mobEFJVhrcwwb/s1FOFaGbgAuO+HXGAogtzArHB
	Aaa4jIc0iWItoR1/s1wVGrCGb0LN/tcq/iT1qraDG69ZHjuS6iux6z7QP3UojrOcDr/+BG
	kBFaGSPSnPfLFVG4NTdzWeiyUKqCH1E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5gEbz0j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 888F7438F1;
	Sat,  7 Nov 2026 17:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBA41F0089F;
	Sat,  7 Nov 2026 17:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794071788;
	bh=SLQrysRtojRVCkoj2Wpy2cpXj05kr7eHKjA5uK2krN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a5gEbz0j8dVKXdOoXU/YTycv8LQSGb69Wwrj/+MpFeKUEgZ3L3vpRrjMFI2zfPv8M
	 rBRcDXw7TJXpl+0nH2vgeenR595dU6DbW0Hj9bVEvt5Z5MeGroUdZMSCMsrTlGjdfd
	 a6gM6TrM4xunBHI35KTevz5nEpkJBnhhkO0PTZNfiD04SRHzo7iCZ62DzAyLhXJuJb
	 BjgLSCCSU0ZwhOrKvNtBm8Kauj16MY+mBm/BrYPL52sAR1EA8O50mN8JQRyYERvfHU
	 C3PrNw/2SWIGt+77ctam7Yw0FTqwLWENhkeLyvLQfERDUa9F/LvjztWYlKwlaGR9gw
	 pTi0/e8JmAVHg==
Date: Sat, 7 Nov 2026 18:16:22 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 01/13] mm: hugetlb_vmemmap: fix OOM during head page
 allocation
Message-ID: <au9c5jNwv2nhJdzD@localhost.localdomain>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
 <20261107022756.77731-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261107022756.77731-2-songmuchun@bytedance.com>
X-Stat-Signature: iof6exkdgh69br3temqa66gtox4ibz61
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 56841C0006
X-HE-Tag: 1794071790-968842
X-HE-Meta: U2FsdGVkX18v8CruVOUBIknT9jjZlp+9Pv7FRD3Z9l/qIrGu4clB4Jnv/DS14uHjZFKAFByqvdeIkwAvEf0p5hSdHegpdUq2U+PCdLztaIJKm7wbqoWGETsCOAI5asMZPiIVyvJgDLEMItgQpEzySZ5Kh82OtMcKAVAIZufSIx00V/1tV5mZ9q430vrWmyXPuF30SvsCG2vBK28p/l9D7HcL6+/7cWx8h/cLzsgp8m9+0j3aTzJ2WfQdl/KiCAVGpq0mFZcfA1e/KMY5eI8JZJVniYyLZ2epJGN19FmP4gi6BV0W7XYYETbMUMMZb6/TzDvBT0TAPNX+yRtof37pyQcCk7HTzTIx3zMsg2YctMxWmRPN6AyuITtOFT94jYNWd/uKWedqHOqj1daI1MAM5buVNHn6qoccsobUhDWbJgWszD//64goDiK1a6cwWI1PtBNGqKMMGSjdUf4xBgvGSk5rKtmcGc/AeyDZhFf5tGPeDQ0TH6GbokMZebxrKnIZgvUe+jOii6RsSc//gG3S3lrcQhPyirGA5CL3dI1XdG/e+DBepuC71D9Kl+C8PxpgjfwwYoAWiPkicp9naOJwbjgEAz68QwTTOWDGcEXtt1arbyqtVLUuS9JBA2xQBvwiMAQ3EPCZUg37yK46m6ANHzvYAcjZUwQzX6b968Qm/OHWYFBLII5jb3BdYiY/R95gKScm4Vy830YKDnwqn2sMT126aCJgm8pRH/Q9B6qb5sUIoRHEP5zrV3W9c8PeGxXasAGXBQ9M1XOzZrtexLd50rVjuvX6ZCL0v/mZ3TKmI+blsbuHtNAwtV2H+9c34HOugqmwTW9Axo9xb1d8UvkC0iBl1wDD5FQDGg1RfRWZyhNQXFLAnTcXgWpj2+a7fLgi/Tdiyo1RCCxE79qwEumBNKl/GzMiyi78I/457scN57WnGdueFWnPMLafxccKM28WNJ6KgoPM2YSLJodQGQC
 XVWCwqUw
 pEfuYLwHB4yGMiinq9Hi64AZgWs6aqe7ShS1I8OM1FLNJ52VoPoKa5qaxEBz/v4NFWSbKdjfKQP5hogvU4JyF51LX5RJ0mwi1VgD0n04a6Eyk5m5UH6uSDBoylXkM5wXpHOlV7w2spWdjHapHMPjcWGVb5LBy+DIP5agrHDl1YZJb+hMapjMq6N2VtmKn/w1quDuZyIe0TVNsm0ec2Re289HoEGGq6vttVRNvIKg1NfIr1XQNS7HXPTKtJRIXCifAG0/MTmHw07fDiKvQ82/+3SnRX+dZ5gjoj0syaQ/hCB1tfL2KPOitMn2NSA9nDHyq12BnVe782dtaYSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 10:27:44AM +0800, Muchun Song wrote:
> From: Yili Zhang <zhangyili01@baidu.com>
> 
> The head page used during HugeTLB vmemmap optimization is allocated with
> a bare GFP_KERNEL mask. When boot-time hugepage allocation drains free
> memory, parallel optimization workers can enter OOM handling before
> userspace exists, leaving the kernel with no killable process and causing
> a panic.
> 
> hugetlb_pages_alloc_boot_node() invokes HVO on the folios accumulated so
> far when available memory reaches zero, allowing the released vmemmap pages
> to support further hugepage allocations. If allocating the HVO head page
> returns -ENOMEM, the bulk HVO path frees any vmemmap pages it has already
> accumulated and retries, while callers can continue with an unoptimized
> folio if the retry still fails. Therefore, neither an allocation warning
> nor OOM handling helps this best-effort allocation. Use GFP_KERNEL |
> __GFP_NOWARN | __GFP_RETRY_MAYFAIL to allow reclaim retries while avoiding
> both.
> 
> Fixes: c0b495b91a47 ("mm/hugetlb: refactor code around vmemmap_walk")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yili Zhang <zhangyili01@baidu.com>
> Co-developed-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

