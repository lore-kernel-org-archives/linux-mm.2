Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C72EA719C
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 14:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3856B030D; Sun, 19 Apr 2026 10:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6748A6B030E; Sun, 19 Apr 2026 10:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 563176B030F; Sun, 19 Apr 2026 10:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 448836B030D
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 10:34:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD0A31B8893
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 14:34:10 +0000 (UTC)
X-FDA: 84675550260.19.C190AB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C9154140005
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 14:34:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pd1kZ50h;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776609248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rbatdsvbbf574tsqJz6GypfVYqOrN1v7mJOzbc+2ycI=;
	b=FqKTwEI+tZDCIxl2DTJfOrim2BPOBF6ItTT8EZVI8KAyHVBWLVEFOYQkjeJwJht+SECW4L
	GomZAINs0pqa1GkINpom8uxJHUXU8XtS7uipWW4qCalHaGifrBBRUqmJNVlNTW4WpIfiSq
	6YitfyiPMFRcUKzleswtuX1nqUEf714=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776609248; a=rsa-sha256;
	cv=none;
	b=pef1YCn2dFWk/3pokeo8/mMKYFMqJJrBVuz2crfEf6iyZIjTorAE0M36/n49s61MD8Olwu
	rU2wk2hh7e7QQv2pkCtJSEzf/0l5mAJYcRwhyXfkyuXLEVSdN+K8JvV7uUvGCIvG95sZh/
	jT1RmeUk3+YjE2PkYdi5b2OLYX5IK8c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pd1kZ50h;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AB1960145;
	Sun, 19 Apr 2026 14:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F3BC4AF09;
	Sun, 19 Apr 2026 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776609247;
	bh=xyrHX70Q1m+sOti0Gvm/ACwhuTSLW/9mrS9U1Nf2k9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pd1kZ50hJX7/A2jyCWXq6YcFNQLFe2hvIWqmNU3N9hfijj50wvJSodc/5poif/bKH
	 Rv5l9p/gcgz3KzSq72j7K82T/VeQcjA87acvKd2Mxn9dyRijIRP6QmItwiJdC4c/t/
	 tHiFTQ56RzdmujzGWoLCrtwmwjzeRgHmBKXQ68SzXxYjiYogi1i/8Ea+QTBRye/h2O
	 GbK0Aq36zrbiHsIud+FU2EW1tSh87J7o8amwAbtkztODKQ44OvwrEFTlxVLX26MEjb
	 OK4Ff8AZTNs8V7MY9ofHlrU4TZIR4MNc3ew7qjk+jwZuDR4fzbjlvl184BvaiuVez7
	 iYK0bokJQllTQ==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 45AC7F40068;
	Sun, 19 Apr 2026 10:34:06 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Sun, 19 Apr 2026 10:34:06 -0400
X-ME-Sender: <xms:3ufkabhibwJSBoppqF2Pb8ObmHfkv5_Gen9487QmJ1GpS2Y2kSNDag>
    <xme:3ufkaXT5ugzyaKGgrd5Xj28F3EtlBqc44JB_fT3GItuDbtuq8Qdm4ys4HRAyEq4Dy
    hiMdFYGxd2GrkGPDw8Bd0R1pMCl7N64G-OhKMmqqMQRw3hPL1FBxQ>
X-ME-Received: <xmr:3ufkaXQDCzXpnAYVA-WToKC7ZZLFJhgfB97QG1lbwGQ17ZkMZ8AJ1QIEsAM_sA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdehheeklecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeffffekgeffjefgkedvjeeggedttdeljeekhffhudeiudfhiefgudeugffhheffuden
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvg
    hrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeei
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhg
    pdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopehljh
    hssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopehvsg
    grsghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhirghmrdhhohiflhgvthht
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:3ufkaTDpq90nRdz8qrD47__CsB4YVPIu20MV9CQqe9tvYlOAic_4fA>
    <xmx:3ufkabwVOGu9LVOovDfjmNcgym0KS9GgwnW5nmzTQXjt-yUn1gj50w>
    <xmx:3ufkaepH9zl5PRIt381RQa8fR-EPrbxi6sOQDpJklhnIAZe9LdOFiw>
    <xmx:3ufkaevgTj1J7S9XaTyA0Sfu90Qhvif0TCW6iAh5cgGN_ixj413S5g>
    <xmx:3ufkadQtuI6bYFEUM2v2bs_fnuNeQA9ruMrfuQkORBqRgiYbBj4DKKI1>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 19 Apr 2026 10:34:04 -0400 (EDT)
Date: Sun, 19 Apr 2026 15:33:58 +0100
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
Message-ID: <aeTnlQUOOh-dHG8z@thinkstation>
References: <20260414142354.1465950-1-kas@kernel.org>
 <55019037-4f1c-4d9c-83ee-3a844d8f3d5e@kernel.org>
 <ad50rPOseVa-SP_s@thinkstation>
 <aeDoqFWPFxkkNB26@thinkstation>
 <1a499781-1115-44bc-adbf-2ac3769354ca@kernel.org>
 <aeFCuLJXT8VOkzH7@thinkstation>
 <4c635703-3d8d-4cfa-bb98-7f6f5fcbe547@kernel.org>
 <aeImfRrrvr3UoKtL@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeImfRrrvr3UoKtL@thinkstation>
X-Rspamd-Queue-Id: C9154140005
X-Rspamd-Server: rspam07
X-Stat-Signature: kh18cstw4icne5twyydz5agb61sdwj7q
X-Rspam-User: 
X-HE-Tag: 1776609248-469682
X-HE-Meta: U2FsdGVkX1+1Ex/98tgSui9HK3yazxB6T3TJP99/nArQHtrcnqHKC0XTe3kFKBwNPC1Z5nQAruMrp/dAuGOf7/Wff+EMJvLP0y0ZHgAL3fHwCr7mu01Z1kL3+DRMjL54hE6fysIhWY9kWZneznC1pEUW8YNh6tpzO/LPWCBLByuE84AlqpxS5lofkyMAaL9VvWsja9TfDwq5UGRSHu2USq5bgInPP2Ixbm6nryP2jNVqPGDhymYVaVFQu9mk6RYgrEocLp+VM8W1apMgZmozNe7r7ZQmiPF4EI44HvyGeCFH/1aZrNIhQ/LUojWJ6MqANuIZLqClpVARrP7Jdf7vhcShQ5RzGjiwtNNIHbxMXJsGTl10gXXExCxaJu7s6Z4yvuXIt/9bske9AfL55X5ldNpjnM5UYlYptzSo3NYqKur457dyBRoHIGQ7A01AuxhDlFIFyLYgNIgrDigxOi/s52+kztM+ZypKPl0EPbwAvsdCDzZIMQkNfx/jTXjS5esvjdDy+5Z5ZYukBH5suWNTbWO38CUF9H0drCcQpBnIxIup1jangyj51EjSLYBklsABf/k9wf/QEElCz84N1Qj7xzctyNcRFEFg5v55VZJI+sehqQGfeyQ1iaLvii0FDmuvk5omaAQg7AAV1GT/mwlJ+FpEtD0iQHRY3LFPJRnLpJQtN0BlesH6isdXzTkwNFCBsQthn/9WrusqRZoDj7JOJ1+SpOF8g8yg6n0kqF517CroybPsljWTv5wTxTNKUZOFqEKmIaLuYoFE4Q/NJ4BQYrSqtQ0tgeDhavNCWDHugpns3hJjtx99PucySQ4RRS+pEXpHTJWg/cd4VJlzwNaeik6c3/VHnLqoquIqUHoTa9sM0k4Pwyv21zS/cOOei92mcL2/lQfXDKQ1sMyB+WuiWGIoxE+gZzwGRfx6Lj1hAsIlEeMlN+uXYdqSyenBRjQ3ZEXr9m9n5g44UQnUqx3
 fdrI7y7k
 lt6mmSAHYGhcgyKLCmBAp1z1nLhb5GLql0hfcnYWeDcpg3GhJLxNHznBBbMU4a1zvaNU7G8Mz+t0FgdetoBC9UriVF20/cROcn0LLMHoubY/UqkbjGZ/BCf4azkxga6hO7Zd5Za2VHvet9lDPpw3LTG6Ypg5E6OCbeeTkeC3mCv2jl/hOMxX+Mxc4NSFy8KYeotxsVU49LIRCqUUryetP9H6x8SKF1I0/8EWFEpc1osE7efKxxYvA31tIk2Ze5WF99JJQ2SxYRZWe5b1CKR7qSRQoiERqvoOJvBVMec9/IzVdMXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 01:26:34PM +0100, Kiryl Shutsemau wrote:
> > Leaving NUMA-balancing aside, a simple
> > mprotect(PROT_NONE)+mprotect(PROT_READ) would already be problematic to
> > distinguish both cases.
> 
> Hm. I didn't consider this case (miss some uffd lore). Will rework to
> reuse existing PTE bit.

See https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git uffd/rfc-v3

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

