Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6B37FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90F36B0095; Thu, 30 Apr 2026 12:54:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67F66B0096; Thu, 30 Apr 2026 12:54:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7EBC6B0098; Thu, 30 Apr 2026 12:54:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5C926B0095
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:54:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A25C11C079A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:51:30 +0000 (UTC)
X-FDA: 84715813140.25.79E9F0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B251340012
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:51:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PBPkUyvL;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777567888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=579UMGbIG7AqF477ZfG9vyhpp+DUIN0yVnlw4O25dOw=;
	b=t47WeSJLnL3Ly42pqMG7/MVIhsmJvZiX7jxfY+wJc6Rftszd0ESODuPHaPIRylpaPCuuoO
	FJKaGoCxrezgcV5p53One12qXMrvHLqL6eIVNsaoqb/qrtEYo+w1Z+IA5Vk9rAByRMi6u/
	lNu82M2tTF7M1WobZLyqOYibquwGl3s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PBPkUyvL;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777567888; a=rsa-sha256;
	cv=none;
	b=XCd3ZiF/YAVHzNCrJjC17qKje8PCMHsFHkbYw0HSJvMXvcAHSgGwfWA42ezd1uN0u4tYNI
	77BWhlSGJzSRZYzoU8bFBKxVi5DFuElMzdm9KWAqnWQMFgBk65Bz74zSOdI8o+ZEfqDEeN
	e+M3xH8HZYkDE2I8X0lrilvhNmRfPwQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 122F76014C;
	Thu, 30 Apr 2026 16:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14194C2BCB3;
	Thu, 30 Apr 2026 16:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777567887;
	bh=/g7iUC9W4a+mffEw3evLoqTN1V514LaQU/s16UD5sPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PBPkUyvLYR756gEO2WpuJW9zXVKKNA3SRFPhNqgJFaSnVEWbwi3KrDXlwwT0KPh+k
	 o7tyQSjw2kZ1lVN3NIV+tJF2Sdxtw/F7963iCG+j67W4Eyw3qJrmbnSC4t++6DP6gj
	 W2xKsZuBKYNKG/hgkhml1CXyHADyNsH0v83vnx/BSFz5BVNwnVgMxnxdawQGjIrIRF
	 rk4DJU4nQZVoJwn0m7Zq7EsU+PxwY7xnbhSspw0S4DfZtzeen9iUsBuD4HYqPq+trR
	 IDGtWsH1wN15fhlh4stwU+V8CKqKONrEkogSOtZ16VO27MUk6YCdDfFc2Yif3UjBTp
	 wJuPBvIcUY3Zg==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3BA3EF4007B;
	Thu, 30 Apr 2026 12:51:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 30 Apr 2026 12:51:26 -0400
X-ME-Sender: <xms:jojzaU-mFio1b7NAEO1SjmmVALuvKJecJDxtthHhA11m2dS3RcyuZQ>
    <xme:jojzaaVUmTThplgMRevXK_ENjGL9SWnFSahk8zrA4wjQL4iL7itwy9GLrdXhUK0uh
    Vs0g8h19xty30eOs7jZEi_wyfbgUlGIiOiqhqsDmPh86tdZlei4DQc>
X-ME-Received: <xmr:jojzafkN6JwnZ24-eM9ny6rsxX2a9snWBRih4qEUNnAj-SQms3NobFHrrPRdIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekjeekhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgv
    lhdrohhrgheqnecuggftrfgrthhtvghrnhepgeetuedtjefhkeeuiefgudduvdfgvdeiue
    eigeehheehudetuedtkeelhfeihedunecuffhomhgrihhnpehsrghshhhikhhordguvghv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepgeeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughh
    rghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    peiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:jojzaYG8xNEfH5VrYQyYe3VXnfi_k3Q1yVPJ_O6RjrSWzXfBP9xJkA>
    <xmx:jojzaYR4WNsnfR3Cc5nJwWWchsmrv3qTNGN364ozZeUd4aXQZMoJBQ>
    <xmx:jojzaXQEaTRs3ODUIa8fiT_z0FgxE82Tol7wHHeOG19Z-Xo9DgweQA>
    <xmx:jojzaeervxLiCfO1LPq2TicKubhmUq3jHKqkA4Vn1u0T0u-_yt9LHw>
    <xmx:jojzaeDNWkAfBqpy4DpdvZlSxRtlbwS3CzZwWpzXDDjBiKzXmIgbPV7O>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Apr 2026 12:51:25 -0400 (EDT)
Date: Thu, 30 Apr 2026 17:51:24 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org
Cc: ljs@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 09/14] mm/userfaultfd: add RWP fault delivery and expose
 UFFDIO_REGISTER_MODE_RWP
Message-ID: <afOH-MzZVT8Kuk-6@thinkstation>
References: <20260427114607.4068647-1-kas@kernel.org>
 <20260427114607.4068647-10-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427114607.4068647-10-kas@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B251340012
X-Stat-Signature: gdb8gxjc9n6gtzaur8hcxx7189o5c4h1
X-HE-Tag: 1777567888-89687
X-HE-Meta: U2FsdGVkX1/vPOcjIu7LcnY5cSlN4GKAwavrzGPOQrhojCcm5tg7VyIb+Ai3KUmBFtHvjiTHs+F06m1gthsKpbkcGSGeBjWWMq1r9ZUxCbGuZsyxCetVieB6+/4/JK42SkzlxhyggkQIoWpkho3/KvHI1hwFReuxjtXlAz3q8NcqiBRZsT0rUcugqIetMfQzTn5vrZs6ZdmWggdHelPLpFrc2/maWaFypC7w2YFzgSQ929MpD2W48RYyM34eQ/f/4LzeiwtQ5jtl0w3R4Dqg1uI8VEmWVcO+NDSLTY3S6XWISUVrxaImGInUUrHwYmzP2WT0q7bLCJq5OpX3aofe/3uRu0s8/AIOWJpT2ugBZjFzLyh/5TFz+2xrs0oXRtmLuQW1UdnhXsibr+YGJbZ0npwLuUkqDUwRGZtG5Ng6YToDQJ9GR/HhHe8OT1MtwO8naPv9Lwa/1/1gdagMfjm9YhW8aDm/ngUTJn/gKgMO3BmZ07Cw69nSOgZPqewvZQNyFaf3T9W+iemUzwoVElT07FlU7BAMh/ExslbsDUkbOisT4EtZecUhrI0aeP8UDgf+tgQDMb+x/tobPmUV7Vd2h94ZdTU9v1CskOSvqPv4f18y3yuQCIcODvycD2dJA0wun2WlUpyS+p/OTljt5vuelRHCHhpG0JSdtNopFwv7wiTvKLSnVZ3gv2EAU2eD9oEN/dvHPKUC8fhRqrfCRVuoumo8OUiWnvIJH3Yxk45iV8zD3TE3irXZttP3xguP+sbR7yV4SaqfrjC8OEFyYgaOKrHninVLu5dFzfTBmeQarNWsSbcgd81/n47mJ1HqGDV0GnEJlw17Q8BCGt3GRVrYl8mcSFBxFXrBG0DO2YEJo1jrTi7YXpI1gCoG5bOAMj7QsMrue4SmtXuY2ee5ANxKpOVANjzr9TtDVvNQu6WW17k29W+wVLKX9GuF175TQoopsZ9cKhquKlHc0zupRk2
 6HKF0nTI
 XYGRaJ6e1D+MMrWRsvS8DajBCD+TVXz6i+7fzeZVBwo2vafmacTrfnMyYFpme/OWbvZr5qqYB6HsFXKRWZ2b++qaxL6Cy3L4+QntV40kb3clu+lrfMzALZ0sEBb+BpapaDfGcEmRpeWa+8Iqb8n0GRwZsb+JaPOztac7Q8TIBFXfr7GCJr1LltvwNAhrFAaXtrs5onfAAfp8Cb9BxLQZxJP1XXtGXNEE7WISFr2Hwa7Fra4vYJmzc/c1PBbrPAioqXK9UpYvB3T80mxC776j3SblfJ0NxWQPx+lZjGxDqqf1KjDhQKDJfSIaiDIHuobGNcjgMP9Db0NzFcpVUDP6zvsw+DPlJYXwWXDjVAwVQ7/3CEhOS42+EJn0qMAllwVRxwE9bFPUf5/25No9HuC3zWnmyFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sashiko.dev -- https://sashiko.dev/#/patchset/20260427114607.4068647-1-kas@kernel.org -- wrote:
> Does this code lose the RWP read protection after a page is swapped out
> and back in?
> [ ... ]
> The restored PTE will be PROT_READ with the uffd bit set, instead of
> PROT_NONE. Will this silently allow subsequent read accesses to succeed
> without triggering the required RWP userfault?

The PROT_NONE restoration on swap-in is performed two commits earlier,
in patch 6/14 "mm: preserve RWP marker across PTE rewrites", which
adds to do_swap_page():

        if (pte_swp_uffd(vmf->orig_pte) && userfaultfd_rwp(vma))
                pte = pte_modify(pte, PAGE_NONE);

so a swapped-in RWP page comes back as PAGE_NONE | _PAGE_UFFD, not
PROT_READ | _PAGE_UFFD. The same patch covers unuse_pte() (the
swapoff(2) path), restore_exclusive_pte(), and the migration-entry
resolvers; each gates on userfaultfd_rwp(vma) and the swap-pte uffd
bit before re-applying PAGE_NONE.

> Can this sequence cause a state collision between RWP and NUMA-hinted
> UFFD_WP pages?
> If a VMA has both VM_UFFD_WP and VM_UFFD_RWP enabled, [ ... ]

No. VM_UFFD_WP and VM_UFFD_RWP are mutually exclusive.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

