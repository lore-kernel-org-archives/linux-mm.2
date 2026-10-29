Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47EB6606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 11:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ail9VJBd
Received: by kanga.kvack.org (Postfix)
	id 66F366B05B5; Thu, 29 Oct 2026 07:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646A76B05B6; Thu, 29 Oct 2026 07:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5367F6B05B7; Thu, 29 Oct 2026 07:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31A026B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:38:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFCDEC0361
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:38:05 +0000 (UTC)
X-FDA: 85375464930.23.C1015ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A617A1C000E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:38:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ail9VJBd;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793273883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNCQwk1kVwwDQd6YdP9bn0F2tzwSBJGnMYrpsz+xroI=;
	b=6YFdHUHYheprN0wsbumT2aI5FV7s2K1CEGXXYZS0dlQdGwXEtkZnexCt7MoGsRNcK0E5ra
	qqw3ik1L7tMq0VWt7GeWLFYDVgnzoRIqJ/HRU2wgSTORdj3AWqJyxQy+RLQDGPgGFbwhWW
	JYlhLyH9kubNc+ohl1Adwc9KScht/VI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ail9VJBd;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793273883;
	b=r9Mr5HpsVio3toMVqoIs66UXTfhIeqOanVllv6NhwKrbKnNmgkBgyNdL5YH3AhictJzysd
	HKpUN55JPZlWIST+m8lRA5pOEFXcIyTJj9oFLF5heMzzhPMCqrWv0aAwyKwWfnDw1sTUia
	YUaV6X9L8PMRTF3UCv+ajkENi6ZHpLE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9B6A4382D;
	Thu, 29 Oct 2026 11:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E101F01829;
	Thu, 29 Oct 2026 11:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793273882;
	bh=hNCQwk1kVwwDQd6YdP9bn0F2tzwSBJGnMYrpsz+xroI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ail9VJBdWbIaFY6FctxLtUgYRHgBXtvqpup5RxHjX8Kun5bgSmdWKaIGvUbl/H67D
	 EtchMfmh++7c58rAzzIcOZJlh7lU068ve+224x/vgneSfQv01jqM2Wo4b1vgV5PkQV
	 p1wGA6vLiXNJvxW4IlD096ZyNX3LzYYrCECa15A67f/Y3MyckPpiJSZQCM9WofsF1h
	 dNLVrxG6X+4vXWm3hjvcfoKWjvFUJFbtcZd9TwphSLT6L7gTvVao+jRJGI2iJ7TQ6k
	 Iqx3OJ8IZ43B5gnVKp4CY6HGbSbA7r7q2m7qWPekZSqeQFYt6ZRDde2QXdTZrHksaG
	 hRFiEsxBGnmWw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 61199198003A;
	Thu, 29 Oct 2026 07:37:47 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 29 Oct 2026 07:37:57 -0400
X-ME-Sender: <xms:CjDjajshZPeHtuir7v6mreGhAT4TgwhDFbd67W8lqX6eL1H1h2Hveg>
    <xme:CjDjapxTdjr1qMNJTi5jiBAbPeUL8WNi-rLAE_SEgVpbUTGclmUKEQ760n5h0fqeV
    hy4NTYi59RMULuyZS8aZ2YEk4SsTRY2j-0YZqzoSiY2c-6zrTJ_WiZa>
X-ME-Received: <xmr:CjDjah4JZaAhw-Fk9PScSG2a10e8jvqhDX8C23W0UBFCIs08u9qC86Fq1ss>
X-ME-Proxy-Cause: dmFkZTEJDAstCk+7zNgejakM4nNk+p9JZpQkZ6Wp/ORPY45DYJ9sLHFzb2OSqjFNCrREyO
    88yfN6Bm2PU/BZ+n9uLJeM8IQCx6gh4dmoBjtrR/gRMQnW1vav0T4U3R0wWLGH7ILSJz0U
    jdMa6OkiVebfbkVm5JCCWeL4Bgmn1pDydwYsJOPck3Qdns4HPrCASx59vSMT+/j+yF0qvX
    G2BRvU5cIsoY70+iA26gBsYSOUUpx4hNQp6J+87EVccCZ9Ae0yLIol7hi0rblFUAevpiPd
    uHrIkD9QzQyn3BgarrdLD501N6XdbeMUSrCRkW1q1L/F8zcqlxf0OSCgggqIu+bFPdnmVK
    NcNYxpSkwWOCwZcLOuaYHRTsxYx6D85JDsOHrpKL1vEhmUAKDtUhCnUAlLFqot1DM9q/eV
    ZTIcjPJqq14fF0zy0HGkF60Z4NFN+bSz/WNKQw6f5WcVzsXmI0zvI1J66w/XqmME697OXQ
    zERHpQf1f2P1KpVc8eIXbHuzD/SOd6B+KE+lUnfFtKDQN9VNcFcye2oj8ZEx6A7qEAQffs
    IUWqlyPo0fg/2eaM6xeJ2DOITKhJqU9srQCSgILo9WyD2HhperaR62DEVqvtfMq6CL02UO
    uYQhCBNO5b6ROgC+/K/MpQZdw9fNc5YCZUTnJbGBtnaHKfxJROTOsVpYwzvA
X-ME-Proxy: <xmx:CjDjanSS7Mx8TZPiU7heer_Q9SPTwHVFNB-SMCwAJ9aut0b1vRFrUw>
    <xmx:CjDjag-PYdm5Aer_OhpqtOoZx_SwLxAY07eLDmtLNEeq-uTx5hq8eg>
    <xmx:CjDjauzsU80bWiXzCsXzA_QbCjiGNW-gGh7_khHqQIP9Mv30v0qhhg>
    <xmx:CjDjaqzuB5gcDCgx7-WAvZUa70Eg8YXQlUPcy8ONATKcSf71OQuvVg>
    <xmx:CjDjah0f_57xCcmxZRGSyxLW9vwtr4aZedU-FEl-YETeEd7d6gRBRj2j>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Oct 2026 07:37:45 -0400 (EDT)
Date: Thu, 29 Oct 2026 11:37:44 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 05/46] mm/truncate: look again if a folio left the mapping
Message-ID: <auMvYdTd_e9O9kDj@thinkstation>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-5-6f74bec9a5bb@kernel.org>
 <auIniV8YSpA4_oxg@thinkstation>
 <2f2ef336-2186-4f20-b7f5-565e60471bda@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f2ef336-2186-4f20-b7f5-565e60471bda@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A617A1C000E
X-Stat-Signature: xbnm4nm17hxpsnuu84n56n1taf95e66f
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793273883-782138
X-HE-Meta: U2FsdGVkX19UNiZlPIE7ogQyXy9AoYGv3q3F+hb/oCyoUb3MAo+QrTLSp3S4l6yn2rCfjU8Vgp2YW/bmN9rR6pDeRGpT2ScuHmQR+G60HeVwFwwyYPCyQrbkNcXXgY80Mp5Ft1THV8eFxWQwTwyTBmRptRqWqOorTKbXRtciR/gmX2+XTcpgASMhgwyagzgMZ13hdFSSs2QuuSXbX48IkneK8vFZqUihS4i/ppWdWbCRpZaslxPqQhVPP0S93L0eLkjSdDY3OwMhQI/TpONTdKxEpuLQ10NjJIahgwuJ/bv81VomZQtf/icuBSGHeVStbDR/qUknDySYJS9kd2KGIQNb+MSat7gIYh+uI/97AYmXgxIYi6w9IVbE6oVc9IwFHT1Fe95uZS2i86sOhMQfx1rFVhwo3k4zNZdqTz48QBOhRD1Ya7GI5BvfEP2rsoewPJZLxIxawKwt2hxxPZsrt6LPa85f2JVMoOh9JEHn96KboH2OaR0m+75OYZlJr9/NRHPZ9MXELaJfva2NRWetKE182aYMKCYtqgK0M5qyUdI2E1Wz85B5nkkWMqglgSTApDuBL3uW0dg9mSZgE7Op4fRb3TKl6yHqFcqfv1FqgTVH9+zMVU+Dct8QPZIyFToDPxVNVmaZaviaWHTFBCqKEPAzkxkpgLWRMvSJIgut5D7VJ2Q9maG1sDIsswRZ7BY6uIgCKFtoOgXD/UgKlSlagXFZ4h7SzOBPMCjesFR/NP8fkEfzz6gfkh/zF0OOiu6g9gNzQeWvbAtG61EBFHf+rp9P4NJ38FkdMmhf217ooyhBxLkZBxN34PkGWOjlx53BgOTHlkgxwDnInWOJqtWaMTc0bAwihmxwmrkm87H74xO49VseudkoLXx1hQCa7wxsMDpt2Kc0eXdQSS/FcVU3YkW1FYrsgOrmYdW17fdDxQ5P94To/uK7YD5/R2bloZWz1vJTjfWrZvoUaFSn41T
 acSmQpJQ
 T4FkQzt55/dhj7oBbm0Y1cUuAfiKCPmhjFQOIbwPdAegcNEAQHoxsLA02rb/VvuB8l0kEmbm1v45uaimfwT5VQ+MGGHN1n0gRVap2/9Ea3JsYbVLceblWLMJVfUFQw2EQvwwG36k6USbQLqq4FROTx7+wsbqSh4finpClrIMXC15KRY0JxaUN9Z8jjEdHQIUdMFwHEt9RhqIKL2M45cWl6My8L5BN8CQzpPDvvuNyy7+wP6/xY0LZ2tLWMTSB9gZvFe5nVvQZbh1RdZ3+dVCrOg63pZqbQxcRTv5RkKEFGxjvOGakjZZ92lel4QE5F7kbsf5yrD1TPlwgQgCcSBqQ30KkEH7CKnZn3bdXKjq/b7Fsii1+fVnSF/GA+/5RI4YlImnA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 10:45:34PM +0100, David Hildenbrand (Arm) wrote:
> My brain hurts, does the above make sense?

Yes, I missed that the loop only goes back to start when a lookup
comes back empty below end. When the last batch reaches end, it exits
without another look. It doesn't need the split either: any punch hole
whose last page is in the page cache gets there.

That exit looks unintended to me. b9a8a4195c7d ("truncate,shmem: Handle
truncates that split large folios") turned the "if (start >= end) goto
out" early exit into the loop condition. Before it, the loop went back
to start until a lookup from start found nothing; Hugh kept that on
purpose for hole punch in 792ceaefe621 ("mm/fs: fix pessimization in
hole-punching pagecache").

Restoring it is enough, and makes the "restart to make sure all gone"
comment true again:

+       if (start >= end)
+               return;
+
        index = start;
-       while (index < end) {
+       for (;;) {

Then a replaced folio is found on the next round, and truncate needs no
special case for it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

