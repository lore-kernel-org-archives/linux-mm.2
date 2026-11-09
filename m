Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 211F6606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yk3s3d9f
Received: by kanga.kvack.org (Postfix)
	id 2D10B6B05B1; Mon,  9 Nov 2026 05:11:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281906B05B7; Mon,  9 Nov 2026 05:11:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1985E6B05B9; Mon,  9 Nov 2026 05:11:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F09D56B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:11:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97A1DA784A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:11:07 +0000 (UTC)
X-FDA: 85415162574.21.6391599
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id ECFB7180003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:11:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yk3s3d9f;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794219066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbzKLdeX4uvspnezn7DDebS2QYAphq0U5j3vCU9hkMY=;
	b=mHnE8pL3PwZd8GtbYKDRtyzltbe8tMhymZgxkDlIZvlzNHjIon74jtvmUNCsVCfDSKervz
	ITqjaRbtMjc6eIOAOhF/uEw7qqaWhCKl8ZqeH7yQ2zdDcYm/iga0n+jQGvMsWYY5SFFGuB
	6z9EtwJ/1peAOJhr/wORUHWZKWpon8E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794219066;
	b=CNqSBDP30WZCGPMVLM0kYV/LQs3ZyQ5si0w/lQDXznTUeqrYJbwfyM4SwZNm7tTY8m8EHm
	m0U8ZRYCqpTCIdmo3XsccZlwm6z5riEZ1S4v5oDilVm0/IuFvzCdQBMWLv1JPnOIFuj4s7
	uj9qJhNPRZpGkvH7l1RwiMOMRlnDGDA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yk3s3d9f;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8349D60D60;
	Mon,  9 Nov 2026 10:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB091F008A1;
	Mon,  9 Nov 2026 10:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794219065;
	bh=wbzKLdeX4uvspnezn7DDebS2QYAphq0U5j3vCU9hkMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yk3s3d9frEWJZPF2MxjOZchcesGfDugA5BuxyDVBmApifp1nrXdBpEzCpJH135Z6v
	 pGzHY0gQfwXYmSiHDmNGG3fWlgsrAVtTUjAgEKgTx+LSJq1LxyCnWmYQK598Fy7BNJ
	 mgdd5EvGuaW1u0OeZ1SxXFAJnBEWulBCMtEpZEE8NzIETSir8TkiU4PYPuX7zsN/cS
	 gvCwafWEipxdq2SZNqRTVIZMR4gtnUoPMtw8wUxI2SLTH0dYcSun490m/D2NhyjRMn
	 LUYAQV+T8Fotdet4iYmRu+ol0wEuPD/vicVi+vMhVpVwFJO7zx1mOW9LpqdhrBtznQ
	 HTzwwcKy85ODA==
Date: Mon, 9 Nov 2026 12:10:59 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/events: replace __get_free_pages() with kmalloc()
Message-ID: <avGcM7xJfGpOQpVV@kernel.org>
References: <20261108-b4-xen-v1-1-76095f25cbf4@kernel.org>
 <7af392b9-0cf9-46fe-a820-c994942893fe@suse.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7af392b9-0cf9-46fe-a820-c994942893fe@suse.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: xb9fcy1pe348pt87xia937ob4n33hxq8
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: ECFB7180003
X-Rspam-User: 
X-HE-Tag: 1794219065-154329
X-HE-Meta: U2FsdGVkX1+sG7weQe/vOkrnU9sn2UuG2vsqxCrohOmnIi7peRUDPAdHYbq7WhwzH3G391AFlzjOyHjZdt6Mve5hkHsHVFIP7AVwdYWmMof96tc1/r78lk9mUEONhTZ+3f4eHQcUZHMWy2FAfVefHIn0PKrvvazLGhIXIpM51/b36zN2Gx96XwlwNRU4wrgGTaNhY8ANFPZ48C+uuVkZ2ayZGhdpbrQ2HvCdqev07YIiNQzpArnYpil1ESVvARLrt/hGYQ4yVz4m2sXeZnhFU3yppqnpwOoaDWSOcR8Cmk80Cku51b7YNHsOC0dKSMagZcHrI4QDyG6mJQRggPOn85ht+XNpC1tzeXJHZtQMCk4CY8ncTnXyi8CHsdRFcElE00T8JRbIXMpSoDfDC4kOtKRitsU6EU+xMQHpJbDXG17L+7zIb6bvnSJPZC9w4QsKWMsuuwYGC9tM9W3+JzZxq+LhZRXs592nLagQAERXsVbU1vjsXD0XNiq+KZQ5HMcB1mW65gjoPhm13xxjrCODTbddNoltqsELPeZmu6TM1dHxFEWm/Ccwzzftx1WbWafNI3GuVVf5Bvp7TYV5ghkgcs3FahYBBZksSC2SsJmlsMtkQgTQwJcp9MDgG/Vv/Q7A80ol4KogOTyB9tNIrgCSxxpU3Hq1ei1rXv5QMhCR5N2vMEPMWybOc8vc/nCNFjhEbDm6rOd7hTeMQRJeYsDR3FXat9ZegNUvnnjeqBwgFksQ3dPRnnuoz07fESgTGupOrL9kxeF6ZboTM+l8NDtiEa3z2EtPzjLW2i8VMLzMY3iMrtIu57BVwvhDrh8ObXmJr2k7wsgHI1rY/KSeYJKWzrcEcjd4VAHuHhQdR+/mbS7BiwvxZuPJTY7PXBGDNafCAqXeiJS3iXf3aLwLxiF9oBVp5ExPXJeN/2yS9NVte19dJjzlTHcCnX7jpudqIr2Ono45xEY6axghiGR+otJ
 dHbGebuv
 U3fFQ5YLZ7ppOo7aYGbZjgS9UNB3X/LHSZIaN1TgxWrcV8iZDLFFl8dT/qjs5TIVP993V6aODERrgo4wP9Nd6XI5cDW88wp29M/FJ16y70oaBbiHCJPLFiQdDKDV2N8C0Hp+Pisb7LRwovOSiXFIMn/4gUvKfaYbePcQdC58GA0rBeV1MrdhZWRBWfL1dkSfHkWhH6WHitWet3R+WpgBh2TlFWGgEdFVNfTh4uHpM47ihFOf+OkkUJ/FT0R3Rc/dJDi+jXhRfgz6lCfNKezdjIp9QT9JJXOs+aM2KqweimWW3/PJwrGLSrQsMOct/muxD+RH/e1zPgHuuRIuWfLEMv/FFjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 08:53:18AM +0100, Juergen Gross wrote:
> On 08.11.26 09:42, Mike Rapoport (Microsoft) wrote:
> > set_evtchn_to_irq() allocates a page for the event channel to IRQ
> > number software lookup table.
> > 
> > This buffer can be allocated with kmalloc() as there's nothing special
> > about it to go directly to the page allocator.
> > 
> > kmalloc() provides a better API that does not require ugly casts and
> > kfree() does not need to know the size of the freed object.
> > 
> > Performance difference between kmalloc() and __get_free_pages() is not
> > measurable as both allocators take an object/page from a per-CPU list for
> > fast path allocations.
> > 
> > For the slow path the performance is anyway determined by the amount of
> > reclaim involved rather than by what allocator is used.
> > 
> > Replace use of __get_free_pages() with kmalloc() and free_pages() with
> > kfree().
> > 
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Shouldn't you also replace __get_free_page() in xen_init_IRQ()? I don't see
> why this is being omitted.

Just an overlook, will send v2 with this too. 
 
> Juergen

-- 
Sincerely yours,
Mike.

