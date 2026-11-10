Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8CE3606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AdR/iIal
Received: by kanga.kvack.org (Postfix)
	id F3C796B05B3; Tue, 10 Nov 2026 12:37:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED136B05C7; Tue, 10 Nov 2026 12:37:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2A326B05D1; Tue, 10 Nov 2026 12:37:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7C1D6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:37:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66F51160A05
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:37:36 +0000 (UTC)
X-FDA: 85419916512.13.3913B9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id D09EF80005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:37:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AdR/iIal";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794332254;
	b=hRWiNYkJq63lkHCtuBzHg28bFL3glwUSaeI/JzZL5o8NUlOcG2LAo00lbKdVOzxKiMMuSd
	Vhbhuoj1IAqxRaovMcC/fYud5JdOuFuZXqAva4luk+3hq5/ouJZhPevlleBOOa1rTyduPv
	AmJ1E/+R4hJVNVOpQLZCNsFEOYvCtWk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794332254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1RfyL/TcZ4ZTAYnZqeNVh51xKbXVpc1QnVP/NPBvRh4=;
	b=GDBQGyfxp2XujnC8zvajBZZHS9SocdEuNJRYTc7nu9UcpdEdyZHkMugm5QahzyCTfXXyNr
	Jrkp949FgRQkS9ZDuh3HPX/pzMxCRVJPz2COXSUrUcEEytd8lg74t1mIFmJTvzRFj1eAsV
	sdSzsqCoUHXXumURGnyE9UHvr28i/Iw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AdR/iIal";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 577F360218;
	Tue, 10 Nov 2026 17:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E101F0089F;
	Tue, 10 Nov 2026 17:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794332254;
	bh=1RfyL/TcZ4ZTAYnZqeNVh51xKbXVpc1QnVP/NPBvRh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AdR/iIal7CJ/v9yej9YNB2M0x4MKHjl8+kbhv5lSQTwpgvTjIm+3VQzyE4AQeTthP
	 kBgsagPvRR6i+pYNoNMLfB8qf7jOtLYQq9j1cAAIaYiM/NDG1ERgrHlDk1Dh0xsetm
	 ClWe4MuQ2pZXy57EhCpHOlOvXxW0yJg/9bHu9aX3jGBdpKOEQ2H0KE3Y4WUCwQ1E9p
	 3YTi6NMP9CC6z6Hq9dr1XiK42WuKUvOVHuimlRH1rgWQJ8utnMttYXuQeaYkUylb8/
	 tKxLG3+wWEJuCQo94ADRIwSibf/dNy/RF/LRft6LfWUq9ls70xAZbdeStvlL/XscxA
	 qk5tFvH7VTnyg==
Date: Tue, 10 Nov 2026 17:37:27 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Seunghyun An <san55@wisc.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Lance Yang <lance.yang@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/vma: predicate vma_assert_stabilised() on
 CONFIG_DEBUG_VM
Message-ID: <avNVoCWBhVQea7Vq@gremlin>
References: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
 <MN2PR06MB6639D846B30A3357B01BC61DD2722@MN2PR06MB6639.namprd06.prod.outlook.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR06MB6639D846B30A3357B01BC61DD2722@MN2PR06MB6639.namprd06.prod.outlook.com>
X-Rspamd-Queue-Id: D09EF80005
X-Rspamd-Server: rspam12
X-Stat-Signature: ozw538xf5aonjhufiwub8r4n6ofn89we
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794332254-932211
X-HE-Meta: U2FsdGVkX1+TMUkJYPUHF4P47mUtkvq6LabR9PXehy4MSnnbykEeD6lg3xtSTIxU6loPjnhjZqcDl2FjyV7VI5THYbCm7/+2D7NdJDmhxCD3eLpMbsvxJhca7xKpOXZMI4fXP1YwCvXnGaXb5Qw1MO4SZS29mpnwFldKUkbcNyHIyzazFIod8OsB8VXaGuoMoxXtXQ9pXPwFNKJMr06l580D3v8XpcIHBa0kvWxlgQhV1B5u8rm6vkVj2Kg0S9kI3tv/3NxB9QK9p2l72wz5oU1p3b/6V+P/yoFj+vx8EAOR3KDfPAocnHRyNOUvr2aO34Xh9fq338VGfXzXJrLWV9VwWJUXsEF8hOGW9Er1KACpz0mnlM/ydbyQYxPugxWhi7wlxxuyKyxprCOFgoAc44MYaRtrnFxPqLQW7GAxKlZ3pzl7F1QNIvPyJJG49CfCTTNDwxPs5hau4hzsbQUG+0jopfba1DkUM80KeCtu/Y0WldXStMQKB91wMU/WGF74YQfvA+BdwWRj7MWlmJEUvnWoDZsN2sHl/4HzDAlf/hCFkdXiFThB71eKnmL18RA5XV+s71087t62BMZQ2XNXi8SL5SQ1MmYRpwpIzyI2du6yNe+aqR3Mo1AIPJPUEvrcNLvZNFqoaAY04zPIVBMRcfai1N8JHpOslG2+sC66SEaO9nEu6a1hilgzGYOIej1j0NhkCp+3A0h/8kg/5dpqXfhFEE4mCykv6JrHBX0eRAdZQ64cjktvF8uYe6fvR4DwT5xjhOHFcaGqzd8IdxKepTq6hINYKshykImCJARxkZUCTfXP8m6uBhg781SUnNqd48fFFhWDjCsjdSUnuzYLasUZCSR+bqKGsD9xYRtO9JEFgq3/E62SEwzWrc0tXkBKYaSjsgI+zThIJ2cWTL0XLll/OjY6lj/zyGi+R6XkrRjeV4O8KRGoKWnWVx0buupX+TB1s7md0UesbyPcAOR
 4UG6QZ7D
 ZsIZW0LSRpTL8jSSKkUAqVDzLc/6YEOC3COhuXpyh9XRCjhF1kZ1Nqu8O6yGz8/Hr+yAJrmf272NYHP4hPVWSJeEk5lhsvZiCFZNTk+9hx2+grznL0NgW4+9YhuKCZjlYI4s90xln8ipJxvvDKfiCR6TbHGwILjAhRJmlvKYi7ufQ9oH31HiEMYUesbrt+yV7JPgZNFKuVOGl8gM4JjFF2VMsWYJXmL5HvMenAKyBaWK6jQs8YXNMO9ySFxsfR0MVYHsyhh/6+ldIVHKA1nIj01HaWtOQnFbP14hAUqbDhyXvQRwyoTTC6ZMleeuG/Nb2V0YuEJVNVhtkLFTOcxizFRSZHZMi2ghYxQft+jIBEr3tJ7+OiLi2WXzmqeaqCfEwYKabf3bQOgEJ2xHoecyW5CAo/0r4SfrtPZuAqHz54Th2u021gFxb+0cwleBW8MJfNTTQ3kgxwq2ZpAChQIjsoYBh7ROwdvJWR0VxMLzyR0uJtyFX9WxvRWlqVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 05:32:17PM +0000, Seunghyun An wrote:
> On Tue, Nov 10, 2026 at 03:10:40PM +0000, Lorenzo Stoakes (ARM) wrote:
> > I introduced commit 17fd82c3abe0 ("mm/vma: add and use
> > vma_assert_stabilised()") with the intent of picking up programmatic bugs
>
> Tested on an AMD EPYC 9634 (84 cores, 12 CCDs), CONFIG_DEBUG_VM=n.
> Applied on d48723711bae; base and patched were measured on the same day.
> Throughput figures are in faults/s; JVM pretouch time is in ms.
>
>                               base      patched
>   shared-VMA faults, 7 CCDs   1.776M    1.917M   +7.9%
>   shared-VMA faults, 12 CCDs  2.303M    2.431M   +5.6%
>   pft, 7 CCDs                 1.910M    2.126M  +11.3%
>   pft, 84 cores               4.201M    5.028M  +19.7%
>   JVM G1 pretouch (32G)       1877 ms   1672 ms -10.9%
>
> Tested-by: Seunghyun An <san55@wisc.edu>

Thanks!

>
> As a follow-up, I also checked whether avoiding the __vm_anon_pgoff_hi
> read in __folio_set_anon() provides any further benefit. For comparison,
> I tested my earlier patch 1 on top, which computes the index from
> vm_pgoff for anonymous VMAs and avoids that read:
>
>                               this patch  + patch 1
>   shared-VMA faults, 12 CCDs  2.431M      2.941M   +21%
>   pft, 12 CCDs                2.434M      3.474M   +43%
>
> With pft on 12 CCDs, this patch alone is essentially unchanged from
> base (2.442M faults/s). The additional improvement with patch 1 suggests
> that avoiding the __vm_anon_pgoff_hi read may be worth investigating on
> CPUs with high coherency costs between L3 cache domains.

OK that suggests there are cases other than the one you mentioned that have
an issue.

I'm disinclined to do something like that patch, as it's rather a hack.

Cna you give me the workload you're actually exercising here? Ideally
something that's easy for me to run + analyse locally.

I have a zen 5 with 8 CCDs so can probably exercise some stuff over here.

>
> Happy to run anything you'd like to try.

Thanks!

>
> Thanks,
> Seunghyun

--
Cheers, Lorenzo

