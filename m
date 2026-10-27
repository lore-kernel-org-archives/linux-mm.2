Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1C43606A325
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fAX1JNaC
Received: by kanga.kvack.org (Postfix)
	id 6B4B26B0788; Tue, 27 Oct 2026 10:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68C506B0789; Tue, 27 Oct 2026 10:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A25C6B078A; Tue, 27 Oct 2026 10:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37A986B0788
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:24:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A475440A2C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:24:55 +0000 (UTC)
X-FDA: 85368627750.27.D20E343
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 946EE1C000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:24:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fAX1JNaC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793111093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yEWNUsKm7Qc1kCh6w8kIYNOu8KlZoqm6MpCK94ycMCQ=;
	b=qzKtarZC1W7bAji8TAIl5x3uCutAVKlK8Vq804Vdy+vOOaCtAICL7C4Jw0KJ3XeGLeCB36
	dRxoQMVRl29yyfahHwJay1H8iBKDVlEABPtUQlZczA7mhJCof7Qg0Kvdycen6zxIMcrSqg
	X8DXDGzWVG7pEFdgyhFx3KRimWc0i/M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fAX1JNaC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793111093;
	b=Z6TnYmLKUSY7t5t8FTi98pX6G/MjkB01ZAW59j2iYDbp4JRQDBhFjlTaW8G1ePcd4wUj1B
	pXUb1n1NFC2GO1+RNDZepJy62JAWqXjhEtxh9LlkuuyAmvs7EloDb1NmvOsoLBZIadZqW5
	gjnQbxYxzjfcWLE5uiF2YjjH449NRaM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B70EB43305;
	Tue, 27 Oct 2026 14:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A62A1F01825;
	Tue, 27 Oct 2026 14:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793111092;
	bh=yEWNUsKm7Qc1kCh6w8kIYNOu8KlZoqm6MpCK94ycMCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fAX1JNaCubrcsyleu5JKFAE8DVZpgxXVUYNn2Ftrdmin+Pji/mIbRMzmeXpQ6X+Dt
	 GiQlG4UjzjAX2RQJjvdSuBjWINtAivR46bYlRVZmePivZz31DHHty/dklPbB5Rfcdf
	 Y5j5wUmx2I+2y7frliw6sAmAlANp4VyGdlvLU3pxdFE/XCZIg9mTps0eGdmaR+7nmm
	 LUAPpflg3DQF/mufmw9/BZMJa+zr2vqHA/Of68S8yK8+I7KOuGjIPQkJHF+AdaJ8an
	 MtrWT/8TB45x7JSGXPUphbK3IS4vYPw5mpSnjtD5o+IIhwa4YTzB9ZxZc1ukVozk/x
	 v5E0Bl5UB+HiQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id EA8431980047;
	Tue, 27 Oct 2026 10:24:45 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 27 Oct 2026 10:24:50 -0400
X-ME-Sender: <xms:LbTgah0Y2zUPM-xl095OIMJHEEk1nZLl-Xwkwcr3ihWoTEXW7hhyKA>
    <xme:LbTgavcSnHTljp_qgS-o-aGa-RdYdxJx8almLF0RvrQDy82IxyAZM8QgP8aCesr3N
    i8Y_CPaqbelc9CSgeY7LKlahn6_GDfBCn_m4lXNKKymEDXmzM_GN9x7>
X-ME-Received: <xmr:LbTgasMkIrRCiVWd4olqDjheZxCHlGu28Zg_-RduqHp4oo75tJbWsdNjsjo>
X-ME-Proxy-Cause: dmFkZTEY7jaHDxQTEHTExXmqATn3TLnQPFgZZSRP0UGVbFG61dzcxdwg1+6lqF/EbilMy8
    kGIUZu59aEs28drJOODW15kao7vxrYDqwJWwMD5qolD3GG5RJNK3YouzLlKD4P5N/+AnT/
    V+KB46kMbRC/tqkZ7JM/qFMTKwgFjdtx8NJuqp8whRVPFF/LABQe+3fjRdn8g8HHcwQWQ0
    /JIv4J9NBgrVmUFlnH/h+d+lra/nEXZZ6i72c+v7yPQ/0iN5IPmbKaFLVVqZqs/TCC+doQ
    NKK5Z8jg35RfRe1XoCKltDFCkiubplQ/n2C6OV5aNqtcGJKNis+aP3phFz4wOInMw6NHUZ
    oBxkpCoYzMXHT9otR7FxT3RKzIHyZDBPWEqfjYqxrAmY0kbhT+WCr9jk4x4n/ptOHxmBOI
    K7VN4ooTSjgriQG70UUfAvtbgY7whOPgODYDICVDtzBDDegIDa5x1061P0tRu7XDJnr4Ac
    01roTkEO7+e+nyRlPAXCyaaEDQ6IojvMMMtZ1G0pHZepYB29zVeTbzwsI+ZD/QKrsskd30
    sO7XbzjtRDPjp83vRAXtnLG9BOcbcLqA85OG4/w1e4HYBFIkaqQ1uzGj6+91RucfEjxNZg
    3TmZM5JelINSN2jKAecBHsE/BdpGGzW3wpBbodKNcSEotpAqHgYegXN90QXQ
X-ME-Proxy: <xmx:LbTgak0WwXqcogqRvas4QCxiGAPXeKPTd37Miz5AJK1hi1YjAK-J1A>
    <xmx:LbTgan1DufEsTFW9f2ItVSaUyEdhgCeqfAWV5ZMVZI5xtnd7-Tn3Ww>
    <xmx:LbTgaiULC2sV0jVr2uVPOMjZvUTfgMHSTqZBB4QZqi2AsNo7QkYTWg>
    <xmx:LbTgahiFu_fq0FMpKro8JZ7vva5k21ZPLUGrewRqjHdfFedeZq0dIA>
    <xmx:LbTgatJsqum3IFN3Q0rVKi8wl6c9tMliCODtpaMdX9s70a9rri26ZS3H>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 10:24:44 -0400 (EDT)
Date: Tue, 27 Oct 2026 14:24:43 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>, Alex Williamson <alex@shazbot.org>, 
	kvm@vger.kernel.org, =?utf-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v4 3/4] mm/huge_memory: read a special PMD under the lock
 in copy_huge_pmd()
Message-ID: <auCz5LKkNatuoIxM@thinkstation>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-3-66f00b7a564c@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-3-66f00b7a564c@virtuozzo.com>
X-Rspamd-Queue-Id: 946EE1C000B
X-Stat-Signature: hn55grrpo97atmz1wsbmpsfwftw1yn68
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793111093-435158
X-HE-Meta: U2FsdGVkX1/DVfN86UbHuzld4ZYIkJ1SbUQDJC2vJ/+FoRy1eMtJgywMkhW7RKC5A0LX0ZohZdtqHMiiF3FCfU++7W4A/UsGhMX3x1HDznJFK9Km7tvTs1Hk1E7hqQ+pcO4m7YdwncBvU50rMVS6RX+irU8Qse+3pvELc3daLW/u5qbwFRTQZswTlmwrA63ZADDcjAziAmIIguL2ghiOpcCYtBc5KLbceUWOo471DAjhBiQm+9Cg58IVdP2JERBv5iqEFrd4pOQUUJTQk5k7eNWvzYSVkZFn2s5K9vnKRe+hSYLuv4by4nNOoa4xQ7SWXjzilMn0e1qP8JcSO5wWyL9NfGZuJXzRFZH0hlpT6T5Yc/qgCIjYQnkXzD/Mx28+mSf6nQ1++JCVeIebiKsJPuUWDGUBpw6CVHZChamBcaErRuFs0VA+G2VnbnuxeN8kjTA0ky/p5E2juQLV2b6xBDcHM6CSP4XTF2Q6qxzrvIt5OJ4WU19rjWKaCS6jrN7lm2ZvT+fTJTYG+fXwTRjMoLwaV2HvgkvMBN/i2plctNOe4Te7bC6NCGR9ZcRiEphSiuuo+6yt/IGBvLf+uQie5PhAbiBfEUc3q6P3QhrtfPM/5zmuAAl4ESlMtsj7GHEVp579hGQCuZkqCJrYsYqt90rUXKE3vbnamGFx8xvM42n0vFZCnOEqAxLiKqmwZq6xxXmFhE+oJwF/ulSI7J6BMbcHqwHKm96Nzt73vIBfU7VmnysU0y9sBPtMu63N33jSnqI+bs0XidyErJoHk+ZGueLc+meigq6UZuyNurfUAC1vwpJoEbuvZ9nbk9U2ym0wEd8m3i4AcQN71opqiJlYO8S5tw8o1lsHxhirGZMWLcaAzByBzoCDmEzyUmLMidEPpM6H9+rbjBZhCgWCE29/YoSe4Dmx2lyWgxhMdr2auUChqziES46AEZhNWOlbJvgfuKJnvNVoit597yMCwhm
 RCStrpsF
 50l5a0zoCnaxWzRaZKepUTS1GPHqI02Zw16sZnxkDikxZRHBlj8SqM89w+Hk+UULAVGNthP5bGlhB02140yCFnbflDSa0a0HMeMrE8o7aS9Rr463QBslKQW5iARtLDZTGM4ayMcfyg/T5mqzVVUNfmGPNcaTSV3iAF0I5tojfGc2SJkO279Gw11APa9olK100gKFUx2BuKpK4l6/trQADhmkhiMcrCdET/h6uEoaW9aTqm0+4GYygwfTqugtyFfpulNrFTK8QmQtyucv33hJgeFtAnVebAs+mUsVC08FXC6gLorZ0rkdP0xTG2zfxszyGu9C3SH4OoWG7OaJEJ+VRgwILV6Ytrj7iihfVMF6+cu9fk3ObxZ7HFEg35pNwIdrpnJJIqWI5B/gNuYCDWBARFBU+kYZg/a4C45LWifDYQXKS5CcPdK2Z9L5mDzotzWkid5l2YZH3jxx7EnBfMPyyI3o6SXE2/u/VDtbRQ4/U7mfBHIFl00QPqqdjFTQFLRVRlHN6zZWWQpeWbNlA8281jAfb93k66DY8wFYcuGVNa4LzYvm0ZZg6PwXzlFt0T5GGPbD2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 10:36:02PM +0200, Konstantin Khorenko wrote:
> copy_huge_pmd() reads a special PMD without the page table lock and
> copies that value to the child. The mmap write lock held by fork does
> not stop unmap_mapping_range(): it zaps under i_mmap_rwsem and the PMD
> lock.
> 
> The zap visits the parent VMA before the child's, as dup_mmap() links
> the child right after the parent in i_mmap. If it clears the parent PMD
> after fork has read it, and passes the child before fork copies it, the
> child keeps a mapping the driver has revoked, for example:
> 
> - vfio-pci: the child reaches the BAR after the device memory was
>   disabled or the device was reset, instead of getting SIGBUS;
> - panthor: the child maps the pages of an evicted buffer object after
>   the driver has released them.
> 
> The same branch deposits no page table under the copy. ppc64 in hash
> mode keeps the hash slot array of every huge PMD in that table, so the
> child dereferences a NULL table on the first hash fault, in
> __hash_page_thp(), and on the zap, in hash__pmdp_huge_get_and_clear().
> 
> Take the locks first and let vm_normal_page_pmd() tell a PFN mapping
> from a folio under them, as copy_present_ptes() does with
> vm_normal_page(). The zap clears the parent PMD under the same lock, so
> either fork finds it none and skips it, or the copy is in place before
> the zap reaches the child.
> 
> The copy of a PFN mapping then goes through the same tail as a folio:
> 
> - it gets a page table where the architecture needs one;
> - in a shared mapping it is marked clean in the child, as a PTE is;
> - in a CoW mapping, which only VM_MIXEDMAP allows, both sides are write
>   protected instead of a warning being printed.
> 
> Fixes: bc02afbd4d73 ("mm/fork: accept huge pfnmap entries")
> Fixes: d1503aa9ab80 ("powerpc/64s: Add support for huge pfnmaps")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com?part=1
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>

I have limited understating of VM_PFNMAP/VM_MIXEDMAP, but looks okay to
me:

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

