Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6FA3FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E89E6B008C; Mon, 27 Apr 2026 06:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BE056B0092; Mon, 27 Apr 2026 06:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4336B0093; Mon, 27 Apr 2026 06:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD726B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:52:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ACCA4C0114
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:52:42 +0000 (UTC)
X-FDA: 84704022564.30.13157DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9B9A840002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:52:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lq5x4RAc;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777287160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWW6Ur10Q3fVhY/gHZNGwsaZt0rvMQv5S8jfBdZ5rt4=;
	b=rBi41KOD2vI/OXBWlgJpWzB57T8/yFJXQvEzwFM9OLvh3T2rdxgYfFmGrSRWYZRalsgQVv
	2w9UP2EC1ZuR9MnY+oYIGjeCpioHaJWXkHevpN13rsOc27koy2Rr1fG1oM7CEU+l4X5iCy
	7Fo9vGtlw4aIK7IR1UX1tlt+iOo1EbA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777287160; a=rsa-sha256;
	cv=none;
	b=ciHVE8zw/OQf7oeqYTNB26Wjoy1s6TAiNrMo2Dek1eVrSCn67+O9gsaJz8b1QgZ3sOwLyD
	uyF4tBIbsljRguI48gPUVjSmQLkhnUUdD5L9qIElUBzLQkA0N85/ZCFkpF8+gtxasiznGZ
	nF2X4U0O3zX70o4d67u62Y52b98UKvw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lq5x4RAc;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 97450444C9;
	Mon, 27 Apr 2026 10:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F91C2BCB4;
	Mon, 27 Apr 2026 10:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777287159;
	bh=IDtaj8qDPCoKLn7FLT5h06j/NwN3NbNxb5XhN240DSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lq5x4RAcNGcgHRuSdZID8zUAfGXoRIuX3BWOQFyvrtUNcoDyDL7F02naaYVkPrZ7t
	 xGBB95QBpgtB7OP6mjMzBXd71/JvQzEbT+1wS0QRkVZozlmkkROCO7Xf78cCsoMROV
	 wYPbZt1Tq+J+2PvLdYpMEc46qkdjeAbQLXE2JvqvAQyJv3ygNl1ftJyAaRS9RbGgc9
	 Yc4ozuNPgRF5Z4Z+G0aHs0u+dcb8StB0C1dCtBZJeY5S6ISRUVfklMVBywjZUU+5Zk
	 DP+6hyITcXfswDoAXrs7BavzyK4kEpPkxIYo3U+35v8C/0Rc2mCAofHVg8nU0xqx7w
	 9pLcQMA3DribA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1727DF4007B;
	Mon, 27 Apr 2026 06:52:38 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 27 Apr 2026 06:52:38 -0400
X-ME-Sender: <xms:9j_vaRdJxmwAzlw3e7YRcdCjoKb-_iFJeqFWAZ8fjr4r4UILNlAOyw>
    <xme:9j_vaedpSCgjXb6sga0pwzEZOHlKqPy0a4P1RoTWuSseKRZHMNpfvVarTVh516RuO
    VR3QaHGmR8yaysX3QM0NjQqWicfyKjukLfficV3-L0lgKdwxvtBTTfg>
X-ME-Received: <xmr:9j_vaWs2T2cZxQgrpZHUVzdJu7WRmXEdhApgxHcUVNq3NDApwM7IzBPsoojzug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejkeehtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeeuieejieffkeehfeffffdtkeelfeelhefhfefhudehjeehvdffleeuvddufefgkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopegurghvihgusehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhi
    ohhnrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhg
    lhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohep
    iihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:9j_vaVuGM7jbRtmfRyu7XHUQQBiCllZBLkcJqM_pGtwmxX6PlNmeXQ>
    <xmx:9j_vaQujznu0OONSHzF7EKEFB7xUNcB6dk2WL1O5-rQ7v_QU7ft1_w>
    <xmx:9j_vaY1s2lM14MOre5Tojy0TPvzInCjzWhTU4N5W_l8V5fTMmoWYbA>
    <xmx:9j_vaVLsM3YeHltvz58F_FbLRQyC7AwKgg3jlJT1SVDLqkHjnIHlBQ>
    <xmx:9j_vaa-ScGWQp7fhQ-euoBy97V06vaqH2MA5y9H75sPO8ELbvcKAPCgb>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Apr 2026 06:52:37 -0400 (EDT)
Date: Mon, 27 Apr 2026 11:52:36 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <ae85cnYpuKT9lotn@thinkstation>
References: <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation>
 <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation>
 <aeprnnccJeyHB2rt@x1.local>
 <aes7b17nG0cXrtEd@thinkstation>
 <aetZUOINzfTXChLL@x1.local>
 <aetyhki-UD70dyRL@thinkstation>
 <aeuSe0PY-g10KNUF@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeuSe0PY-g10KNUF@x1.local>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9B9A840002
X-Stat-Signature: y61egh8r5pdpxjyb814ixb91mkq49buc
X-Rspam-User: 
X-HE-Tag: 1777287160-342566
X-HE-Meta: U2FsdGVkX1+s2hY/YPX3024HhG41qVKu/7YVJBn7+7njgx2YgXll8SiUndVQoqUlgWBK0UqhLSobEeBRkO0yxQSaOasL4DVr8UbhOey247s+8c0n5ZAYItYczU9Dx/4VFfTkutILAo6jTPkOi2gIa68k9sFB0COMV1Ubmqtc8bdLYyMHqe/wkA0YdknU0dimMnP7UY2aGv+mrcSZBy/THGdfaPkLZ5edRucbEO7DcX6EElnHtncquDGbOjynjS37abg1KRMwSy+9U5mcSmKpws6biecNxvI7udTiUI1C3ZIb8s/zKYGjiFxXRvzZsK1t3FVqL/aUziYh51ZV+ZOGSDXzJZH4cGw+gmIjxHtCS4uUdBbRat/m+cr1FsOCIfhUb1hQa9Pm/yp9eJaotA116rIEWOJmThDU4rWe51aN52bOLGOdqi3Q1ORK+kOSLICJnIeC7ESobs8Vs8ej42OdcZqtdEb/pz2L/dd1+Qo7r2IIs8/ChhgAlHaQxliR8kZC81Cr88VNFRiydiCXBS8SlvTdcPjXZ7CmSYtkk+59mfXoKDBjKMC7atflywzAT3lkiPD9gXFmp17w466jZ3zvRhcCGul5yNbrpgdiOHXeyaocyR0qrzQqIaiNHQ7aXkgyyKHsEyReOBxc20M9TpCcYsnI/zrw1iiVeVhYBzYCgvyAl0Y9KmlNBrxut32b1zIScnbTKW7bhYrk2X7xuLaimB/nQQJp3340LUwRCeoMTuTl82bR4J+vd6rQb0A02D+TrN4q3Arohh+4LJblYA5NKEzmE647SfDbzwNGyEj9e+/ldw8NRes9wvDPFbqLwhaQ/N6CvEMMuCwbFgEv7IK3chhTf85yq7s8M8vNmOvCA4pAEsIbhGgvq5osG/YM2tPUc1SYkQKWgISC30XUe9PAxRsqPG/BigBd+un++QPyrh5tt1SfADlGs2nDjJ6lFuM0Q6jrJkA/umSV3RokOSn
 frXeUr5q
 X40AB0i/EiWLAp9FO+dBVKLU092teIHB3wRD+oggvOimn3DQkjN4aVAikupxef+sKWkf41X3Md835G/Ti0JHU1Ffb0kMvtDM5wrCaDW16GwlWc04jkP+MAzFMcZ6+b1ao2mDMGz749p4939OoD5tTCvCJ51rWdWmSyeGQjkArhfWX4LfDlv0V0l8zrtvOoatmA2OK/r2C/pnLXcGsAnKXMnVJ4i4Zf8DSnN8NG7rbgBXm2a27CPCIm4whbnCswctNkUxZT8EubwF+gru+5TJ4qUgwmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 11:55:39AM -0400, Peter Xu wrote:
> On Fri, Apr 24, 2026 at 02:49:58PM +0100, Kiryl Shutsemau wrote:
> > On Fri, Apr 24, 2026 at 07:51:44AM -0400, Peter Xu wrote:
> > > On Fri, Apr 24, 2026 at 11:34:48AM +0100, Kiryl Shutsemau wrote:
> > > > Both page_idle and the LRUs (legacy or MGLRU) track accesses on physical
> > > > memory. We need visibility in the virtual address space domain.
> > > 
> > > Yes they are, but ACCESS bit isn't.
> > 
> > A-bit is not a reliable signal for userspace working-set tracking
> > because the kernel itself is a concurrent consumer. It is exactly why
> > page_idle needs PG_young on top of the A-bit: PG_young is the "kernel
> 
> I assume you meant PG_idle.  I actually don't know whether PG_young is
> still actively used anywhere in the current code base.
> 
> > ate the A-bit but the page was actually touched" escape hatch. And
> > bringing PG_young into the picture puts us right back into physical-side
> > tracking.
> > 
> > > For migration, see e.g. remove_migration_pte() has:
> > > 
> > > 		if (!softleaf_is_migration_young(entry))
> > > 			pte = pte_mkold(pte);
> > 
> > remove_migration_pte() only propagates young-at-unmap. It does not
> > cover the common case: A-bit cleared by reclaim before migration
> > started. The concurrent-consumer problem is what breaks the signal,
> > not the migration boundary.
> 
> IMHO it's a separate problem, and AFAIU it was well solved at least with
> old LRUs with PG_idle. It's just slightly unfortunate it doesn't yet work
> with MGLRU.  Also, when the extra bit is in folio->flags, it only works if
> both the consumers are reporting per-folio, not per-mm.
> 
> I'm actually curious whether there're numbers or solid proof showing that
> in your case the per-folio perf is too bad already to justify a new per-mm
> API, like RWP. 

Fair ask, and I don't have numbers I can point to right now. But I'd
flag that the case for RWP doesn't rest only on cost:

  - LRU-agnostic. Per-folio approaches are bound to the current
    reclaim backend (legacy, MGLRU, whatever is next);
  - Race-free against reclaim's A-bit consumption;
  - Deterministic preservation across swap and migration.

Numbers would strengthen the cost story but they don't change those
structural points.

> I want to explore if there's something that can still be generic and work
> for per-mm tracking.  I believe if we can have some bit in the ptes, then
> when mm reclaim code walks clearing ACCESS bit and sees some vma is being
> tracked, then instead of setting PG_idle, it can just move the access bit
> over to that special pte bit, and only to this vma this pte.  IIUC that'll
> benefit from both worlds: fast HW-accelerated access bit, and no minor
> faults.
> 
> Would something like that worth exploring?

This can be interesting. But a spare pte bit is high ask.

And when you start tracking, you need to clear A-bit. Where do you move
it? Activate folio?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

