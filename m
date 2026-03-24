Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B42DF54AD2
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51A036B0088; Tue, 24 Mar 2026 11:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CAB66B0098; Tue, 24 Mar 2026 11:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E02A6B0099; Tue, 24 Mar 2026 11:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EF9F6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:50:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D0A86E03E8
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:50:17 +0000 (UTC)
X-FDA: 84581393274.02.6F3C2BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0512FA0013
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:50:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ij2wdgor;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774367416; a=rsa-sha256;
	cv=none;
	b=v482x13O7I0BHcDaIpEWATyGOf9yZFDhUJCrh1x2L9HhkBQoI1jgQCQZi7QSu3nhEILY2V
	ShFvbUQL6VpiwnruBtWcUfLSrMZYU7ewm6l9IBDwr90yKCYMLgreWj7VhnM5q1kyfS5NdI
	bUt31yUZs+9Ld7+K07USonEH2VGDdY4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ij2wdgor;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774367416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d++b9aRi7n8oz4x45EWl5SSQfVWB65irQkZl3lZRrl8=;
	b=5VK1KcvNKQcy7u5aKIx4r6Ccskc/mOEOlUyjRPGh/WSSYZUYJGYVEo1MKlqjoCu0vRHYRz
	zkowfkOcL06/NxUmyouQrzJuLzf8CXw75GPsT/Lh1Yc2vkhY+mHYVI875MYIZt8l4z5FwM
	BW0+qMArjdaQ4g9mz8kx6diHHkT8wuI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E374F4449D;
	Tue, 24 Mar 2026 15:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3D9C19424;
	Tue, 24 Mar 2026 15:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774367414;
	bh=YkukKhbzpJINaS7Rb5+yLxVmW1c1mYjJlar0sxihcMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ij2wdgor9chgpl/CR2KId3KZ1TC5L839cZcR8yPfJkny/NsnMrogunAPyA46OIzdM
	 CklUZd/AVd15wPRJZeEYk59Qfr7x4LPLPvJ/gWau5TvH659kY5MnxZKtIwkomCZaYK
	 oj9jEKH7J7JzZcp/14wTfvUEacy1CsmHYHSS/ib33+i9dpUKPlso9zZ23wmsYUWT8B
	 QsJHtjEC0YbWbuFF9HAWyuzRIclXEzc1qidPgUVkmJsGljANkGpG7ysuW43U6b8DV7
	 Qw09uNnrWEegu9jLI62/9bciXrj2VXIwxvRnIWqnmfT54Hldx1ngey/xm+oscKbkk1
	 sxk3PTFtv/ihg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] memblock: move reserve_bootmem_range() to memblock.c and make it static
Date: Tue, 24 Mar 2026 17:50:08 +0200
Message-ID: <177436733629.229390.1905046883062103780.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323072042.3651061-1-rppt@kernel.org>
References: <20260323072042.3651061-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9sg7ubcuf7fhnk7i9gwuir47hu31qtbu
X-Rspamd-Queue-Id: 0512FA0013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774367415-767229
X-HE-Meta: U2FsdGVkX1/Peh7GWLE6/PYDL8MLaGaipOcfTgXr0MTbLb6p3SYLPvsDEmN8v2538knZFwtInipQZq/R+7gaCGVBsuoeLdzgJe7oTMYRfbrJtkC9mRd/89eDvZZqfJXXdJs7NEw6psMeqfE9lN5ockwoSqe4wGmQSnu0ckRGmRaU4vzWCnWjNnqK5vqR5v2/tO9AragspbxgmwZU0KIh1eRjbL+lv9xoM+fcXiSABfLa/MvBtKm+ddxFYohjYA6/jXOno5UHg3cauG+g14kA+/9Yehvpu9/OOSJNy+vsU/xherfXKDQQe/vZYh9GOtsQ7bNpx0i1SZD79YBqzllBAJopzwFymlFvC9XAesrBktxNhq5KTZXl8OSTIC6pGATTUdOU57qseLeJ9tq6YuvmIht2WUcDJpm90Xfa82uXBp7NA8EC7UZ5gUoDq81EKuqFUByMPtKU6MfRas5ZyJFx1VcVdRU9b9l8aOK2QRgzve0pBSjmpRqh+/kBXGB5X4A2fWKzfQgH/mClrkOkCkbflRuGctVxAP2iWvQZlIkZjVPGU9cXCyxmQyXzbDjg1L2O6YyMTrGZXLG67+30WA4ryklbYU/kWiXGFO9Z5vEZPkk/hoikELsWQ7wvznzzlJQ8w6oHu9bVJh10osJ8snDBDwYKflgjToJZfNzXzJm3p6nw/lNMLYAJhy3CeFDPcMFfqafqE32RJ6Wk10Yl33oNEwwTMKOaG8BsUuaUsap+LwcUfB7wiY1Od2839gqLsTWaHZqfPk9zaf8wrq/Et74Q/Xh1euLNkGZ+nq35kBnxpV+BPzKR9v96EoFBVkdrZc7hoMR7Yn+qajl9rKtbihLWuALk9/UaTgYlHCTLBepVQ5lNAs29+gsiqSTlnXlT5LQ5LkW+bDVFpKCyzGBTezHaTNLFslTNSUbOtGmknCMl+hb16QQrn2dkzOvpkl6Fd4DExH7D6nbFOczwX4obwYX
 /xVIpPvG
 exXK+UuiCgzk++d8J0LHxmLG9yYr7m0U8jXVYg4za/lo7eUywSL9qJHjyoCpY704i+Y/Sp+JLpJOXOlVojVS+jjJhm1DNLAh4nKTKRgnB9SoX6FKHWjSaq2W3CUGDwNH6y8wWvgx1/DCTWYqp1I3+G3VQR15CpGT0u5BwR+oCdPaUMRtc00K5xWurE8LVEMnPUDkqr9aMSRDgYrotU7I+sJjsJDXhDnMNO2EDMBrWbIdl3uFNSRItg6S/uVReKTYpJ6AFIIylaGKfB5UT3do4OvfPA6TUkHqk1B66
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 09:20:42 +0200, Mike Rapoport wrote:
> reserve_bootmem_region() is only called from
> memmap_init_reserved_pages() and it was in mm/mm_init.c because of its
> dependecies on static init_deferred_page().
> 
> Since init_deferred_page() is not static anymore, move
> reserve_bootmem_region(), rename it to memmap_init_reserved_range() and
> make it static.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/1] memblock: move reserve_bootmem_range() to memblock.c and make it static
      commit: 6e56179632b784109f11174d4c2bf9716fdb328f

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.


