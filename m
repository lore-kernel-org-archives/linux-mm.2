Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F35606A33F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lYS9V1pB
Received: by kanga.kvack.org (Postfix)
	id 717F86B05B1; Fri, 13 Nov 2026 21:38:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8676B05B2; Fri, 13 Nov 2026 21:38:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DEA66B05B3; Fri, 13 Nov 2026 21:38:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0B96B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:38:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB32C12030D
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:38:03 +0000 (UTC)
X-FDA: 85432164846.13.8B9576E
Received: from mta0.migadu.com (out-148.mta0.migadu.com [91.218.175.148])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5E49080003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:38:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lYS9V1pB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794623882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fr+/kMFmCLsGicg9T6i0NCPKmoj+tnWS7HQ+lz/d99c=;
	b=oJdnQN4tbBx70aaYZHH5Xz388aaut6Z0oED2Jrr380NxzaiKB7moaOmoLZLhlJWgUd9B/G
	8Y0k/gt4G1xr7KtZN+GEROBhzqgVExMuhGPhGWhdn72Fu06855B2MGyZxHLm99ZTW+eGoY
	Q2q/cvvHqWNZalQofnTWEDNJwJyU8AQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lYS9V1pB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794623882;
	b=KS0jFDp3RiD1V6ARJ+o3AD6jY8fS3D6hzKbDCW6BsX2JSZeTdk1RrE9IvGHsUfK/j4SAov
	+eZmUaNMLkuAPFjId3/5xFOXy9PJ1nWvpulyx3E8yisAjnvhUzJfR5c7i8ILbw0uug/jHh
	8iDxsvPD1AJEN96exvkyP2AMoHgzr1I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LhWKw0hIjCAzkLgAvL9lXHI28yxzDvFvC+TmaniYtwk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794623879; v=1; x=1795228679;
 b=lYS9V1pBgRBdEL86Jb0hDCWN+xlxZHDRoQM5lC/+u9DSSJLBi5tsKmfTT4GGn4kfenE0Pu/o
 avTDRINzxymWiJnK0a8CdG6rdPiVhy1/pHBnFo02P23dEaI8WchVhHH7zyY/pbTrhAS6OPJnZi6
 Ag35eZsQ0eJFQLFXOFnHQnUM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 9baa0a0f2146f049;
	Sat, 14 Nov 2026 02:37:59 +0000
X-Mizu-Trace-ID: 9baa0a0f2146f049
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2] powerpc/mm: fix uninitialized ZONE_DEVICE struct pages
 with PMDs
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261030115326.1005755-1-songmuchun@bytedance.com>
Date: Sat, 14 Nov 2026 10:37:38 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Pavithra <pavrampu@linux.ibm.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DEAC0390-4347-401E-BB52-9D9BA3E93FDE@linux.dev>
References: <20261030115326.1005755-1-songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5E49080003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7wkx4whoaqkba8tydfdqtoy8ab5h8iny
X-HE-Tag: 1794623881-860810
X-HE-Meta: U2FsdGVkX1+D/DTFjFDxXrJePCw5FXA1DZjdFfEbNWyhFEXZYOTQH/ctmeFoKesqFkh7XX9KEmH3w9yY7Ufa+R4fGEwBqwWyKuvk8wvMuW4+a8Tirrm9DG0n6u7TubxzCa/iCvOrJoZ1dE4djclILVZxsVfc1xwxpZzy8sd22SOGqfmsMA/hM1PDrbYVB/xTzHBl2cO+yjd78IBsEi8F++Tym3rSuPpMC1psf8q8lYvbPQKgdqHa7/1vJgACBp/e9wIsUd1s774XbNLRnE+yTPzHOeOSlM+4gkbIMzuLCI7hOk12ReeXgHz1f1NwskmOy4o+I1auzRcGMYs6rFaGrWYNCcRDLcByOHtKPftnxrRZ4zQNdhCdJOJaVdr7tZUZ9/s8pXPTCxPMXniawLonbBDwny7OKktVdwWLDQz0IP/zv/Y7VDxSYe+aDILS7hMBJOy/gP8fZi72FevH1Kpt4c75ZYKEFg8+fZfGAMLnVV4VLzSt0aWte6OEQJ0lxxvthBdJjjTFNrQ1cO44Ukb/NAidpGAh3vASSoKD1TEiv8HGbPshRtbf6pJ5EhEV4QTsnHJVIjdLYkdYj9YlljIdL6QTagsOC58yasRPpjXGauJdHaD7hnlw2S24LPJ96/KTKArjtvvxWLDK7v3/22wpTzWzZy6oYlTISNwIzswBF5dZm0YIyhJx2hnKwk62MXQhcWpNVFcbrr3RJUy2sHrYhHSKPR64ekwX1C7ZLWsxGwO1ZT8a1gN6MY8hYzQOxlfUmbEg16WK/VkVkxsrLLlM0qTd+xCuwElGDHmJVlt236Czxd6S+aU4HVYg6LCDwC9YDEfjxRY7x53c0hnveIQsdxRwZq73JFK8Q4PxLw5GiImzTkJruFx+yFXY5Jd8ne4PyeVvefcybUhKMn96xa/tjPMfMaS5zKLofKZ5z8RGQt2t/OWYrxmLdVuVh1d0DvWpZeViWm9Vrj4Kvw1jPuJ
 cYBx0sQm
 w4WUAlH3+/g0nsPEVywcp2l33lxDYTxEKfqM/SJPaMcj71LW07bfZvtPvxTv1CaNTaLRmB7PJ3T/WWSuodeT9w5u8DDYQF5Ynp4ZdY0cZqU9BIvfYzx8g2kngLdKHMBv7m0/B9sYD2JJcYvZM+YXzHp/sM+HxVxtFc/Hbehr/NC08YqwzdINYUVr/3gQwM2O2Tt6hNS/XE8wn303sDUdQtin1o4YrJ3n4ZSlS+4gaCTLxrobSamUb/gGVsz08BHSFr8BOCtDhFOTTykwy/0JWiZuLJPBgfx6iP9v4O2RVwFKXAt/6S+Y8coBnk2T34C5rOEbYXhx6xpK7n/yhCFb7+thNChKpJFk44gdN/vLH63cNz0MSAezbubyUG3FtHf2VI0Qeh6wmW9s8z8+nnuOH8AOXc72R7i6fbBiDUVC3DwzOGU38282UDekhOD2L4EKVNj8WaQaL/V1tUWm6KDnE8NtJVLuby0xZaHnw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 30, 2026, at 19:53, Muchun Song <songmuchun@bytedance.com> =
wrote:
>=20
> PowerPC radix vmemmap population can reuse an existing PMD mapping for
> a device DAX range marked HVO-enabled. The reused mapping is ordinary:
> its tail struct pages are not remapped to the shared tail page.
>=20
> Leaving the section marked HVO-enabled makes memmap_init_zone_device()
> treat the range as optimized and skip initializing real tail struct =
pages
> that remain in use. This first triggers a zone mismatch warning, then
> faults while initializing the pageblock flags:
>=20
>  WARNING: mm/mm_init.c:600 at __init_single_page+0xd0/0xf4
>  Call Trace:
>    memmap_init_zone_device+0x164/0x430
>    memremap_pages+0x43c/0x93c
>    devm_memremap_pages+0x3c/0xa4
>    dev_dax_probe+0x264/0x3d0
>    dax_bus_probe+0x140/0x1c8
>=20
>  BUG: Kernel NULL pointer dereference on read at 0x00001400
>    __set_pfnblock_flags_mask.constprop.0+0x34/0x160
>    memmap_init_zone_device+0x358/0x430
>=20
> Without these diagnostics, the uninitialized metadata remains latent =
until
> userspace accesses the device DAX range and triggers a later panic.
>=20
> Mark the section non-HVO when reusing a PMD mapping so its state =
matches
> the actual vmemmap layout and core ZONE_DEVICE code initializes all =
real
> struct pages.
>=20
> The Fixes target predates the section-based vmemmap optimization
> infrastructure, so this patch cannot be applied directly to some older
> kernels. Older kernels instead need to pass the vmemmap bounds to a
> range-aware vmemmap_can_optimize() and reject optimization on PowerPC =
if
> a PMD leaf overlaps the range. This reuses the existing mapping =
normally
> and makes core ZONE_DEVICE code initialize all real tail entries.
>=20
> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap =
optimization for radix")
> Cc: <stable@vger.kernel.org> # see patch description, needs a =
different fix for <=3D 7.3
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reported-by: Pavithra <pavrampu@linux.ibm.com>
> Closes: =
https://lore.kernel.org/r/97f85592bb78a273be8519e6897e7f9b9bd31469.1793070=
429.git.ritesh.list@gmail.com
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Tested-by: Pavithra Prakash <pavrampu@linux.ibm.com>

Hi Andrew,

Could you pick up this?

Thanks,
Muchun



