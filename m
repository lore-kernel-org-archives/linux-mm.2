Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB937CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AFF56B008C; Thu, 14 May 2026 05:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487B06B0092; Thu, 14 May 2026 05:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39E416B0093; Thu, 14 May 2026 05:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2CC176B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:25:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3374C103D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:25:52 +0000 (UTC)
X-FDA: 84765493344.10.D3CA8A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 39AF340005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:25:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bm4lvvxQ;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778750751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fqx5WNbiZARo+ij1w8G0uiR7YL8weU90vFsKpruey6c=;
	b=ceC0nZbbc4SRMiTv9Rz34ZZTS2AMdVnFfKC8ggqamGGf5WCTz1mdzTTUc/RIAURjXfhgVK
	E8VHjdt0qNT1zPEldn+TXi4oxxaQ7X/kVF5SRJi8GjmcOWjBk+yDQbuZko6+Ku8WRTWh5W
	WmHAzAmINuU2eTfVB+PqvwgDPeXPyV0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778750751; a=rsa-sha256;
	cv=none;
	b=ZDJ5kXj+cdANoanDZHUWZyRS3Il9/Iaxej+NGvMW9/+Lh32idhdKGFXDSn7eXq81uG8RcX
	FUKYTX84XHsO78N1nXIRKYT6q4MoCc4BYkD63N4tG/uPhQNiA00hsEGMLtJV/MkQuXHWQZ
	MHu96AsXrLkCvuCGK2Zpatk2eg+ZPGs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bm4lvvxQ;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 18D5343A11;
	Thu, 14 May 2026 09:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE81C2BCB3;
	Thu, 14 May 2026 09:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778750750;
	bh=M4WVs7iBLmP4pE2MrA1L5Ry/mhmsTAqWHCyv7F6kDE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bm4lvvxQYFKUIbFeIz8z5QsUYZlNiTLDN0fTlrC3hi+xEmVMeo/kNl6101yz4VKJZ
	 r8v0iNrK14k5XvhE5Jy7ouxv3NDdOsDHptrWTf52a29T0+WJbixavx9sy4NHLYfw2L
	 lP1vmOgFj6U3X55Iq44Yillywj+W53k7w/77ihzhEAIhuU+FUJhugRiND9ecNCU7Xb
	 Bz15FhLvemp6sFehnokb18RIHrumIW/tM1mgudrygY/H/HBelEwBbKAE/aoRec+ft4
	 QJpE2BrsibF3oJwfWFk9LA4JNl1TBfWNmxnwYmoXWeK0mB0yFxo/FcxwM5QzocDoqc
	 1GHegVmZ8XCiw==
Date: Thu, 14 May 2026 18:25:47 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Levi Zim <i@kxxt.dev>
Cc: linux-mm@kvack.org, rcu@vger.kernel.org, bpf@vger.kernel.org, 
	Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Puranjay Mohan <puranjay@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Amery Hung <ameryhung@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: kmalloc_nolock() follow-ups, including kfree_rcu_nolock()
Message-ID: <2dhbxmhg4l35gupk3wgwtufsf735rnk4czmcoyspzckvexie3z@nswohkoipx44>
References: <esepccfhqg7m6jo76ns2znj2cnuaepx2xvw5zaygtwohq4psma@563ypprp6rr3>
 <9bea1536-534a-4a59-9b5f-92389fb05688@kxxt.dev>
 <6wvjo33urd5i4jvbf6rwp7kwe3ppn3ktgmjk663hq2jxax65gm@kxljf3hkqs5e>
 <1315d145-49ee-412f-ad91-0f6c61c4c2c9@kxxt.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315d145-49ee-412f-ad91-0f6c61c4c2c9@kxxt.dev>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 39AF340005
X-Rspam-User: 
X-Stat-Signature: 6nat6o4k4n7yj5x1fmrtor1e3t75dhc9
X-HE-Tag: 1778750750-836569
X-HE-Meta: U2FsdGVkX1/j8oZ1HeeY59aF0R2LzIZjiB61xto7FUm7N19Lyl8Mo6acAGnLXHJwPLhtXkA7xPLnUrhaOrFFQkimsIjRKq7vLaxkBTHF3vbW/1rHwS6L+1sQjz/eGzEZqddKsMnhX6MF5VV/2rIZx84wEoWoF/oQQw4Dj+24yWVEexn9UxIid2E50HbfRNQsy8qBDEsLCauCVo2+Ksc8p3iVEB37r3GV8EAMuQRoNTPDu9eKAUFF7SL+XWZif4CU57MkEJ3xY2pRvaElKCpNfTRHFYC0L2xbEri9GnN9HjI4uSHlB43530R3PZys003DWLIAlQwPuW1jdq4TLVg8d2dkrHo1QXGS9D0gEXPIvAI3yMVVDSvSm9R+VggJt1UHTA5egKc5wNNXjdeHNqoW5nPc5xwdWzSeZrsTyvokblkFFu5rDQn2NZ5ehYuHSTjJVSw+7mwMumhx2vgF0hIFHHzaJljd+7NosBVMwjrOj38zoSCtJE5fZbeMyoN4zgpnH1euZf1NcS1gHU1JHXoiRpUnAiKYvKgc5t5n4nesHJzRq+xZHm/Gzg8TUV6KgY0f/qs8f8wSUykb1He+uLoPPb2OqtIO9MtA/kDgxyD8z0sA0IRa6Bu02WTU6oS3tuD91kDMyVx5+Sc/SqZQXdSY1Op0xCKs5etxxXoPTfrRAutujlywo5iSygOHQdQrrhMMwS4lnPMZJ4THd6b8+jInT4h8MzK7UEpNhw/WvQ6+64ySvBMmNS0xnTuh48PRoKAiIULvhzy/bIKAE3wkRXvNNb6lmqrIWqicdkCsBKLwABx/1eLhDNF0vQDeNQJoqo7Z+EuRp7Gv+J8/q/9Wiz4RlQklDhrbrwAs4X0np6dlaoRK9uMBqND+U0SetuQbnZLUeUY7baw0BjmQmsG2DYYUkWXiX+ogbIfFjtCKppiya94YdvdPOg1J5tFwFxrQicC3+2gP4cchYuKGBTophU0
 3r4n33gz
 93VUU62lRugl2TdRF4Ut0v1lbH0R623c/EiBmBZH+WkPAEYjc4yzcDYT35WbdLJKVuaDkFFFewEHEMhcDfgOZy8XiC8GHL9jYDNmy9CZkAOzBnq7QLZt+p8QLIduWNxAAB8QuK8Sngr/WcrMBeOpkcWc27/EO3G8vD3uxV1Sarys9ykcjHZZuI3YtCifQonhIPnUHM1YbRX+k+XjFgGPQ6u76Bf+TDYiKLDrsB+B2c/qyslCyXJXyGqfoIPg39d48RCZXSfpHNV8ieMJRiDYjcNKQmX4NiWNTNQaznVH3GyR7N5mB+ELwRl2PPZf7NR9Lg82j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:34:01PM +0800, Levi Zim wrote:
> On 5/13/26 9:42 AM, Harry Yoo (Oracle) wrote:
> > On Tue, May 12, 2026 at 09:46:33PM +0800, Levi Zim wrote:
> >> I don't know how could we fix it otherwise after removing BPF memory allocator completely.
> >> Could we find a path to move forward without causing regressions on architectures without HAVE_CMPXCHG_DOUBLE?
> > 
> > Probably we can. Could you please see if this works for you?
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=slab-kmalloc-nolock-without-cmpxchg-double-rfc-v1r1-wip
> 
> Thanks a lot! I tested it and could confirm that it could fix the failure of
> bpf_task_storage_get(BPF_LOCAL_STORAGE_GET_F_CREATE) on riscv64.

Thanks for confirming!

I will add this to TODO and post them and Cc you when submitting it to
the mailing list.

> The commit message says that the allocation may still fail if the slab lock
> acquisition fails upon the first try.

kmalloc_nolock() can always fail, unfortunately.
We can only make it less likely to fail.

> But this is still a great improvement
> compared to the previous always failing code.

Yup. Thanks!

-- 
Cheers,
Harry / Hyeonggon

