Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23CFB606A331
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E9dNbIMv
Received: by kanga.kvack.org (Postfix)
	id 2E8F66B05B1; Fri,  6 Nov 2026 10:24:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BFF06B05B6; Fri,  6 Nov 2026 10:24:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7106B05B7; Fri,  6 Nov 2026 10:24:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF8E16B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:24:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80376A8D5E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:24:28 +0000 (UTC)
X-FDA: 85405065816.20.D12AF2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E1A012000E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:24:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9dNbIMv;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793978667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLgNyXFrGS0TryALTyECIzzY5cEQxpys9ixb+i595LQ=;
	b=yYulm/M5NSF4Mq0lKDLvWkU3UnoiIKBFWB+NBU4phEGCUbVpQLSKb6JEGMdoCtleZWmuMD
	00p4UAwoSPii+Hheose/EdEafMhklIaWXqEW1Pwk0Boit7bQ8HpI9Im1k0bHMcEppT9Gxe
	OpxfxO5+X0iyXwxJoMmTRBwU6bpsCLA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793978667;
	b=CWg53+5gdgrDP+l/iQr7mw7+ffjadkzvghv8uZ2+YuN29NdrHiyMtuXdEZwO6BV0LAwCWG
	c/He/ZyTwD6GF35qeHYUdb5XxF+eVTwyrVSiDCCJqxOc9fVFBYBS3tA4FsMyogofx+yPpv
	msRMl2sUfXtvjqrxINIJpMAIwOIqIM4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9dNbIMv;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D0D160213;
	Fri,  6 Nov 2026 15:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D538B1F0089F;
	Fri,  6 Nov 2026 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793978666;
	bh=TLgNyXFrGS0TryALTyECIzzY5cEQxpys9ixb+i595LQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E9dNbIMvKrV4r7KYAGyHcAcgMkbVi7NVeGv74QZS6YsZpCAawM3rJyKrzu0kGUmoR
	 Bj/DAcnTvVZR1djvBU9Lg3QVTY5LCV5uAawidByHA+Ke5JNXq5LeZ6zopldNKKlpKo
	 QZKc90oVLJgkOm0eDLkALAvGz2ocxyqEugxe5zKZc550TuDT6jOZBCOdFNbPijdy+f
	 HJris1dK2k20jvpzqMEVCuPzLq3CWHKZYiqMDQvvlOhke4+5fCFu8sT++gBEPE6aj8
	 tCdFDNSeX2ABRCxwuoO3Pm/1oR9uq4MerdTgx8flrWHgSzBy7gvU6RusFUM85qyq0D
	 Z0TJT2KFPERkw==
Date: Fri, 6 Nov 2026 15:24:20 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <au3xEVu-SGXZYfyi@gremlin>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <au3CUJO9zBMHLx-B@gremlin>
 <798cd192-9ec2-4f37-9cba-44db275a269c@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <798cd192-9ec2-4f37-9cba-44db275a269c@gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 9b3d7ntmz8qgfajzwhthzrnmytetee48
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E1A012000E
X-Rspam-User: 
X-HE-Tag: 1793978666-258360
X-HE-Meta: U2FsdGVkX1+UBWTemeO4IZdHeiq/JXLoIbInb88leMAzEz1IFkOxXN0EOhhHMqKpbKMYaaL5mFdFs9rSbLZ+2pPduCDfaT1uuZxnTxFdUIewP1igKsmAVWNwbTAZ4qYzjXzycZZLx07uLkw/u8tapHr5OoRA4Xy+LaP6IWcAT59NX51WaqTRgStFuMtzOvOUMzJm51fGJAIRbVt5WKT0Ff1kClJ3F211t34jzMXznIsv/TSsun3/sXRTUff9M5sGZp3ZtAPNzXAuMAilnzzIbkS4Rhzn3wsUcloLcMs+9DlTutTiOWIh2IRScLBxQtTUIi2mr3dqnyGuXvNEgcRkFOVWvr2qRHeyIleyyk/8sxxn8Zg58+xAodO4XbbawmGNgcaeqb5dZZpvTJvOp4UgcJq9rbsUNNdGQQDI99bjidqxUmYu2pei3mP114xwYm0W/V/GWjt2sz6pL0hPxO3+X9RBn+9W3P8ONdA0MjWXyLLKSOzkx/1TOCagvtGJ3NKHCsHSX5uoBznyxIF11BfpKnba5HmrLWzpXN7MWb1aT1gJhQVlCNPdnujQFrKz5T6XRWyNQEIdpky8OEQVrScCVNH9Nds5mvj+osWPfmN6XOQsMHVgMEueymwJdleyHEYU+2Sa1qm01lH/hXKPQHcjTjce6nAQSakOnJqkY4mIrMY29WWPFhifNDPN8nIWfjaORiCcuyg3Cxri/uRQ0dJANHzwwl9Pg5p99x/oFOY1geDfFLUSyl4L6CDZ2zDBhc4y5qlxr6NLrQy8DO74vH0ckGtvlOkQ2NehfpN2w6n9Wz+O13WLoCxzILJZ5/LzwBC0yjY7MQ/DFx/fHcEbbC8jQZKBF/GK0fYGEuaaKgrhmdIj6bdLWiQcEW6+U59CL1h9+ovYDJhaC8/uuyBWzB0/kjm5lHU05D5WlzTDKO00EGk8GzKYlonGBdQevoZrJqhxX0ncDf5Hjruxt0XS9bS
 yNZqoBAz
 qtMQ0tnUacy9+pfNp7J0F/W5xYm3qRoYWWZBhBvfQBYhUpRaipf3HNYfeKqafmSPHsJeToj/t25FldkmXFPiwzdurLGvBWiKn4X58nXMCBkWe9ma8TxhLygAEuJ3QKy1u7gjCKwaYgMZqf8cVIgmy4wAEsPinrl1oEs9gBZTHHF5G5/hl8jRedqGrylwmW7gmB4r3bIs+LbbRbLpn7O7P37XXyTNLjwnK4I8fqxXC+6dkiJG9iyACO3ymZDdlYw8iMN/b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 09:26:01PM +0800, Vernon Yang wrote:
> On Fri, Nov 06, 2026 at 12:07:53PM +0000, Lorenzo Stoakes (ARM) wrote:
> > On reflection, I think this would be better implemented as something like:
> >
> > static void collapse_scan_mm_slot(unsigned int progress_max, ...)
> > {
> > 	unsigned int long lock_start = jiffies;
> > 	...
> >   	for_each_vma(vmi, vma) {
> > 		...
> >                 if (time_after(jiffies, lock_start) && mmap_lock_is_contended(mm)) {
> >                         mmap_read_unlock(mm);
> >                         cond_resched();
> >                         mmap_read_lock(mm);
> >                         lock_start = jiffies;
> >                         vma_iter_set(&vmi, mm_slot->address);
> >                         continue;
> >                 }
> > 	}
> > }
> >
> > Which avoids magic numbers, and means if we hold the lock for 1-10ms (depending
> > on HZ), which is a long time in the kernel to hold a lock, AND the lock is
> > contended, we drop/reacquire.
>
> Looks good to me. Is the test result of this solution the same as the
> current one?

Thanks! I will update the commit to reflect the changes.

>
> --
> Cheers,
> Vernon

--
Cheers, Lorenzo

