Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDBDDFE5205
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 10:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6296B008A; Fri, 24 Apr 2026 06:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7486B008C; Fri, 24 Apr 2026 06:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395D16B0092; Fri, 24 Apr 2026 06:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD176B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:34:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D72CA140803
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:34:54 +0000 (UTC)
X-FDA: 84693091308.21.3E975E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id BB5AE1C0007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:34:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AzPE19aI;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777026892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TUuqo4OADWLXlmLPLReiK9q3RPRN1JQLEtYhsdKuqIg=;
	b=Uvv2IHXorjZ+UjqHfhRw1SmX/gfMRMCQqinVRB7dKOTScYZpsJ+Y3alUaLYGIw9ntEp7f7
	xbn2cfWmLacM5nhXrY3Pq8GwU5kSHGwHZL/2kAvr226iFG1CcUdp2SBMNk78GZ1NqyRHVJ
	jmqtblSfuhogiWHNEM5i+8siL6E3HTs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AzPE19aI;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777026892; a=rsa-sha256;
	cv=none;
	b=Eb3horJQWcwGmZ97CunV95iNIWkNMztHiMbEQs2LSH0rhcgU7oOROEOi8ZjAmkutE5eJgi
	QDhpbgjj8LUiSybAEVO9tUO20CicwQ0Wc3M9RgaQI0wHo0whAhfkya0XT1xvqA2QK39OMs
	ACBkC1ftcl8/xhuxVb691g7uUqHxKOI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1FFB4073C;
	Fri, 24 Apr 2026 10:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24938C19425;
	Fri, 24 Apr 2026 10:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777026891;
	bh=PEyb6FtGbI/y7wrR0DER3IIKFWzjINJX60KL18Yzo7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AzPE19aIZMgleOj/9Q7vqfwN9bsj9eXevrDOI8GRSdwxw+lk6cdJetqiieBdiQveT
	 vyjhKFYAWIx0OboZGTxjR7SxzElRboGrqBA7wyqsAfh/A2rzelHLROqcleYL3Mrkt+
	 YNmCNLzcKDtYT1Rax37fg649Gx74TdctTD1h6EGbXlEuJ/Xyi9uQZXbVbA+RADYK0c
	 UwpFbbq8bpY7D21KSX5uN4EkXkTAg7SsT8YLRmg7y7HJ47lL1HYnUvyhTeU4ZWmPeG
	 /TM3uIQvoOg5FY4QfhVQdAwCo8tSgVEmXMkkgr9tOXhduJeHAT7oP4UoFJb/JzORLv
	 6y8HrPtoEzLQA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 38E5CF40068;
	Fri, 24 Apr 2026 06:34:50 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 24 Apr 2026 06:34:50 -0400
X-ME-Sender: <xms:Skfrac-9Tfj0ayWIBJIyngPd4UlMGsnZuiY2Oelqutif3fZ89iuzgw>
    <xme:SkfraTNg1kxr5_buB3DEXyDvBCKG4GgTfo0nWqyAN6dyJ9vDnG1M4d2_CcatbFkHf
    uC8G8SDCtNyHrsZb0n-pTk_58d3N0hdZ5Zueu8mn01R4yd_aXmCjM0>
X-ME-Received: <xmr:SkfraYMAqtZJXSqD1tnl6ecYoMkMELXZiL5l-qals8ZbGO6s1wuIwfBVKC0ypA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeileektdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepiefgvddtkeevjefhhedtudeuueeikeejkedvgffgtdekgeeiveejvdegtedvhefg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurght
    ihhonhdrohhrghdprhgtphhtthhopehljhhssehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    peiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:SkfraROW4DK729VqpkvKr_9pXjP4KoM5f2Ijx0pGvl9ajs3wr547_w>
    <xmx:SkfrafUWOGIT00cIGKIOwesTuYnJ7J989uaVVotDzWIgsw5j_hZNsw>
    <xmx:SkfraZrqDgPEAmJatscUh4DMeUJmyMI_-RQaPUOMUT-77ArD7thZGA>
    <xmx:SkfraVeHg_mWZ1zZqHIOmbwfIE1rZc8UvSJL51nsn7j2yohQ9UZJxw>
    <xmx:SkfraVC1daTB8U6MHmddnRPSUtC-87Qe-I1RWKoYXacKv5v0ffkmLpEm>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Apr 2026 06:34:49 -0400 (EDT)
Date: Fri, 24 Apr 2026 11:34:48 +0100
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
Message-ID: <aes7b17nG0cXrtEd@thinkstation>
References: <4c635703-3d8d-4cfa-bb98-7f6f5fcbe547@kernel.org>
 <aeImfRrrvr3UoKtL@thinkstation>
 <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation>
 <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation>
 <aeprnnccJeyHB2rt@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aeprnnccJeyHB2rt@x1.local>
X-Stat-Signature: omtqm5k3mnx6167jr6sfec9jnz81q1g6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BB5AE1C0007
X-HE-Tag: 1777026892-735886
X-HE-Meta: U2FsdGVkX1+Ecj5PiCX4Kxxm+/eInO3wTKu/r97XYGf9gZnUWYMK2hQiRxY3JCbD9cibYZvnrUl77zorl8YTsLYhcv/nNIt7xsB4eG1u/K9XSZ7mjpW9C88pdAEg6wlW/wVymuam5tXAY6lQ4GUpUeIwF+cum9O2YjjvCzvcnYGJCo+LpiZPR5sJSRFF49RoKZpFEzacscoswraWEN+ds1KL3KeOo3d6bo0TPKC+/246Cr7dp1hVaa1p+0oPXjqrCujINtr22C8JbXYNii0bxVtvMKKukOtZHQwodnLxKaGQCKBswZVfSwr12KTxZv6XOMNrQrBOPZzRzmTLIAG0wy+b4+mYOcIdtY4EjX1d1/9+OXiyXpi6hqKLtPeZRAZwcBr/fr4QtYEk3QdzkIFQCa3qXvP0U5mmoouTo9dzAdB2P1bvQJeru0pax3gWnu9jAbkiOrahOUi4SjBqAKT/EhauraVeHlG0uxexcUQZBO3S6zIMWD/ChAC2lfRueHZmlJPjw/+FXDP8/8COcYSXSHMAJynjQKPnhWmG+qcsBQWCQSzrpY7NDzCCAXU8NAGR98L0btQ7onUtBI+eKDq+mVEEsDqRHaU4VSubDik268dhSM2iigzzXa3m2LO81Yys8bUzPvm6TjEAGLp2m3kJxcy5tQ/rRCi21/qDgq6ZhPqALyt0w30sr3jwI9qz7EX5uLhEoPSi9Y827FmOtixGsxdD7+EWgjki3zKg14E1CLF9CBUffg3VprDcyIOJKUG1a4iQEhjiqvpxwS1vqGZYMZ5UXEgDLfW3sPErkTnDgxL4J2d8czkEe60pxABZi/2A7mvOH2xAk1LlmfJ0MAvSiHEqQo0NacNfkbl5minOXnnP5Lr13jK9rpasRAb7pZR9PQadrJOP+oLRrLQuT/GvqPHup2CiNCwlTYFOSLfC9Ti5/uvN8QzljX6Wy+1j7XMzK33BypcSef8KvfWnSVb
 WC8wma+B
 FmTAF/iTCo1RwU3HIDeZ1tzlIsxv40AmKPtY7svDyGGC7SUmfjI++6davQ8GdOxko2lwq5DDNTPzTkxTQdXkwSyEYMoWYW7KymOAegPykKxGi7U9pcR/rCUeE72tAdAm3HQbzsGN1GVyksYysUMwj6Q+t5mxgEFol8MS0ToSFBHqg0/dWvNx8q95gP4G0nT2QabcfkPOSlCZlGz/CwOLXHxWMBJZlILWtXbXqhLyiuKYXJAi9gxHERaYI/Lam8iVpRTQx2KhXlBxLoOu/hocJ6+F1bBlu8GxDJ6vw2aBR69QyC6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 02:57:34PM -0400, Peter Xu wrote:
> On Thu, Apr 23, 2026 at 07:08:00PM +0100, Kiryl Shutsemau wrote:
> > > - Whether read protection is required for an userspace swap system
> > >   (e.g. did you get time to have a look at umap?)
> > 
> > I looked at it briefly, so I can miss details.
> > 
> > IIUC, in absence of read tracking it doesn't collect hotness information
> > at all. The eviction is based on fault-in time: the oldest faulted-in
> 
> For example, let's imagine if we can have a per-mm idle page tracker, would
> it work for you to collect hotness info?
>
> The other idea is, no matter whether we use MGLRU or legacy LRU, if we can
> expose a better interface to share hotness info from kernel to userspace,
> would it be possible?

I don't see how either fits our problem.

Both page_idle and the LRUs (legacy or MGLRU) track accesses on physical
memory. We need visibility in the virtual address space domain.

We don't care which physical page backs a given guest address at any
moment. We want to know which piece of the user's dataset is cold, and
the answer has to be indifferent to kernel actions underneath: the
tracking must survive migration and swap-out. RWP gives us that — the
uffd-wp bit is preserved across swap PTEs and migration entries, so the
"this VA was declared cold" marker stays attached to the VA. A
physical-side tracker loses its state the moment the folio is freed or
replaced: a refaulted folio is a fresh object with no history.

Scaling goes the same way. Per-mm tracking of the form RWP does can
scale with the working set. A physical-side tracker scales with all folios
on the LRU/memcg, then needs an rmap walk per folio to map back to a
VA — which is exactly the reason page_idle doesn't scale for this use
case today.

There is also a cgroup-level confound: memcg hotness mixes guest memory
with the VMM's own (worker threads, I/O buffers, vhost-user rings).
VMA-scoped tracking is the natural unit regardless of the migration
story.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

