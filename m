Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3579EF9D0E9
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 17:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2496B0088; Tue, 14 Apr 2026 13:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882186B0089; Tue, 14 Apr 2026 13:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770F46B0092; Tue, 14 Apr 2026 13:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65B956B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:10:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04481B6AC1
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:10:47 +0000 (UTC)
X-FDA: 84657800976.19.52108A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BB95218000D
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:10:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vc83Ub+g;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776186645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TxKx5WJc+9osEMgKCMc2Mj0zliXJ2fmGyDaxscJXbnY=;
	b=BADHvGndoxU9FueHT+N7aDrzseIHlJrsxLqfIV1YdPSoAZifIth68rXSvwvAZJsLADm7c/
	O9WIbGoYVzSC573iqqnfMJSYzrWEok5hWwpsCK2XbNWraEmsGfHKU+zodGTk0ff+3Y+9C5
	AZll8tDhD3IozwtFYQOwSt/IAq/v72M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vc83Ub+g;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776186645; a=rsa-sha256;
	cv=none;
	b=tezA1d+dAdXAc6en6smnegeSIs6NP+ppt5RfdT0EZtVcb/bh6szAxuP8aATfZKzmag0zPG
	+3c+ehAQgqfVtVmz4qbB4Ww7TIeF8j9Otqe3nwVhgyyoId7GNOP/+cEcmhm3i8fl+Eg88H
	/9n4+DEfPfkCQbLQ5KEyjv+2B088zHw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D0BF044182;
	Tue, 14 Apr 2026 17:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37938C2BCB4;
	Tue, 14 Apr 2026 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776186644;
	bh=s+QTe/HNNToEvnbjZtLRr7wE8J02Yjv4qBKvWU9mj5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vc83Ub+g+fxbkXM9UT9gsGjGiQ5Ew4laYT/Xisg9xvz9lrO+kquxrkCw/2mxw4RDf
	 KUnL23Usknw2gscy25a0LBhRrWVEN0fhmbY1PSLDhyaUApW6GbsHdNzRTBMqNvSrPT
	 Um9tUqXcPVKm9wnwkdWQYqQiwIEwS4nXMQP8iFG/l2F1JYzAWaua92O6jgYj9XaPCD
	 KFP12+hafmqDwSugEHadJ4D48AumOpXQ7c86Z6tEk20zqUC0+gdW6DJRcYY+7h+9qp
	 MhMGAdI6Vn5S4UehtI3WChotYnx2gDCjOkKl5zkGhIoeGcaxKVsfpI+U+bPm+dj7DE
	 7X24HRKoJHVWg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 60742F40069;
	Tue, 14 Apr 2026 13:10:43 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 14 Apr 2026 13:10:43 -0400
X-ME-Sender: <xms:E3XeaclU1hOUQVScQjcFL_wMZCO0EPk_hn-zmthT-QgwpfIJv5Rsjg>
    <xme:E3XeabFQt9jPiH84YamCrBopt0yMXjeqIqqK_3We_NbhrwfouzbzixGo-vSVDiTlS
    RvA7_1-teAZp-78CFnoYvjEjSWLulzJhTg-korgqTTQekkeeX_H_Q>
X-ME-Received: <xmr:E3XeaW32GBhscU1pZcTOa17a6W4EZrK2zmb4vYpgcTvybuOOtRNwdz1AWtrdhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegudejvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepiefgvddtkeevjefhhedtudeuueeikeejkedvgffgtdekgeeiveejvdegtedvhefg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinh
    hugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvggu
    hhgrthdrtghomhdprhgtphhtthhopehljhhssehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    peiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:E3XeaTUTdP55Go8VslarUZuoqPZz4YL8as_sP6mXkhr5yXhya2C90A>
    <xmx:E3Xead13zkizWwxD7-gYrYiQv3a1rHEFbkshVNwKQ7jOkYUL3zeMyg>
    <xmx:E3Xeafe1lMPPzmmITOqd1yg1UzrDo56nDeKqrucMispG9u1-o4O3jg>
    <xmx:E3XeaXRqMgCQWib69_21sotjZiw0kuyhhzwcRcJLx2K31nF6_aSefg>
    <xmx:E3XeaSnTdo9l6Ht8KS523XOzLkNK992JU69CjdoVw-Ys0-M2RLdkY9dy>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 13:10:40 -0400 (EDT)
Date: Tue, 14 Apr 2026 18:10:35 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <ad50rPOseVa-SP_s@thinkstation>
References: <20260414142354.1465950-1-kas@kernel.org>
 <55019037-4f1c-4d9c-83ee-3a844d8f3d5e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55019037-4f1c-4d9c-83ee-3a844d8f3d5e@kernel.org>
X-Rspamd-Queue-Id: BB95218000D
X-Stat-Signature: rw8im3bnc77838dyqs6685m49g8ig1es
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776186645-560252
X-HE-Meta: U2FsdGVkX1/CL2sLPf0a+XToURY0pqCs9Q/WWFwGhjiWhnnBudGaim4EbfSVtNTRUtsgFw/P/eTX9C6yF+tff80+VVwL5zFUDOUdlvU08fX1e6bOyQyPt0EPOh1uloz8oLFg3+Ryf9W3hp7CGeDOBrVSw2nBPlTYPQ8xA+sxrsIPHGgsPjL71t3ALu8Ay79B0M4rTs7K0enofFzKT5OLW5OfOIWVUo/2PkCdT1kBpqEFNcRKEKKeDv4OesQZmvXHNLCnoEgP2d44H33QMYeQjebWfTv5ApMLneji77OvX0gOG+ED/DegfFWOvBy2L8uBB9L7HP+uQzHiU9q2+6lncSOFf52WxyMgcwjKyMJqNMH2w/i/62ds69//I/omD2IfauC9l1L/OflfAcC2wt0a7dGDUBafxxitjeoINz99nPkq9mXPJVk+mDfVw0MWiiLzSLHz5Mv9DxHepdQd+XKaF9vOl56YDQWnkF9TiPUnIt5ILKOc87BVGeH2HdgymbjZdGAVpi1UCR6bEOodXd7+AMsDiFCwqKz/0anYYjv3vR7qZzpAfjJUyKS///BOAHLSCzmYrok3CPP3eyfRhjzsn08mHKeOpx4XM2tSRC1F9ckY1DeUXOkL91ELqBVvcIdIQ+5cvHhNthXy3dJmtGs4rhsNaGbXdCwXG/mVTeUiGRr1ohr6k5DdUnRw2qL/Ogg2Xy1RvKOe6LvegQjCAKr0JKgd79cgiBflaXfgoeQDutpD4GYy5a8KnK7HFHx1XsT1yjfJHsREaorXGJ/iIcefktZFD/iLljtgsGy3NCMBikWwSgThuBb6mMT+jG1gtNIj29EBnBQ04gKP4QPWzulmRETjGAwda1Jkx2Orx9O4MYc+Lh3yx+u6cVNZqftq7/R+3kYOd0vAhO8jk388F47vzR3VCfPxymTMlG/LXJu4ImTBgqc7OY0hzsczuCS0pTROIgYwBA5chmiE5Yebf3W
 TuZq/0Qc
 pah5H+7L7YkgEO7yn22zA0H0WXg1urq40MysnII101dSNuF5BdhBtj6Lfy7uOL0DipQNXRDR2OUNacTtQa+UrlhlSCAxGGOfOlMOKQOWQk9ze+lYAqieLarRemDfGspcluf36WERLEGsvLzeB6v2/JrBOtQzefQeKt06O+EkF66KrtPbZyaihkU7CqGoqUhmlbAR8F+CbYBr35mX1bQ1dKVUhP9KP4N/aHaY0PUazkdEp3Fms93uXLFwSQ3EygZKDjA2fhOzxKxhRs9TfZ4PfBLlf6/cA28lfOVxkgg+q6S8LZPc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 05:37:50PM +0200, David Hildenbrand (Arm) wrote:
> On 4/14/26 16:23, Kiryl Shutsemau (Meta) wrote:
> > This series adds userfaultfd support for tracking the working set of
> > VM guest memory, enabling VMMs to identify cold pages and evict them
> > to tiered or remote storage.
> > 
> > == Problem ==
> > 
> > VMMs managing guest memory need to:
> > 1. Track which pages are actively used (working set detection)
> > 2. Safely evict cold pages to slower storage
> > 3. Fetch pages back on demand when accessed again
> > 
> > For shmem-backed guest memory, working set tracking partially works
> > today: MADV_DONTNEED zaps PTEs while pages stay in page cache, and
> > re-access auto-resolves from cache. But safe eviction still requires
> > synchronous fault interception to prevent data loss races.
> > 
> > For anonymous guest memory (needed for KSM cross-VM deduplication),
> > there is no mechanism at all — clearing a PTE loses the page.
> > 
> > == Solution ==
> > 
> > The series introduces a unified userfaultfd interface that works
> > across both anonymous and shmem-backed memory:
> > 
> > UFFD_FEATURE_MINOR_ANON: extends MODE_MINOR registration to anonymous
> > private memory. Uses the PROT_NONE hinting mechanism (same as NUMA
> > balancing) to make pages inaccessible without freeing them.
> 
> I would rather tackle this from the other direction: it's another form
> of protection (like WP), not really a "minor" mode.
> 
> Could we add a UFFDIO_REGISTER_MODE_RWP (or however we would call it)
> and support it for anon+shmem, avoiding the zapping for shmem completely?

I like this idea.

It should be functionally equivalent, but your interface idea fits
better with the rest.

Thanks! Will give it a try.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

