Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6F04C5CFEB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBDF26B0128; Wed, 12 Aug 2026 06:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C94EE6B0129; Wed, 12 Aug 2026 06:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2BC6B012A; Wed, 12 Aug 2026 06:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1F236B0128
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:50:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9AA39A0298
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:50:45 +0000 (UTC)
X-FDA: 85092299250.25.2C86832
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0D58B1A0007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:50:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Kc9CsGgZ;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786531844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tOd6PpRPU/jaWpkEZh0iLAEcStPnZBl4J+E222fKyk=;
	b=VC2RxP5u/AubdM5eePtFMjst1KEMDRulQ7pQjCyUfau9thaXw2Gg/oyxJaF422IJX6ugKI
	VG+38u37AyKXHW7zmR3YIE4ACflGUYc5vmiWorbvCx5qdQM1s99iWJeJpUH1s0MHX+M5P+
	gtvE8SBie7Lt0B/1cgC7+vCqzrvzPIU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Kc9CsGgZ;
	spf=pass (imf19.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786531844;
	b=we5GxS0V6KZgrKOjoPOQw9dfkTY782bgDUxUbU6hn79oi5hE5YdjB+H1rSaeDbpgbGCbeu
	CgqP4WDzMIkVciyym2ylOxKdCJVoPZLEaH53tuyvkmR9hDhkdruVNZIX2oxx+xw3E6GUeh
	et+rguiP4Uu9utS4rGbInvU8KDL5rw0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9tOd6PpRPU/jaWpkEZh0iLAEcStPnZBl4J+E222fKyk=; b=Kc9CsGgZuur17iN2D221RDMhj2
	DcexZeEvhqKDDpgjdujdSRXnMZLhifzhaXSCbWHPYOXR5gr2xPoR0Ba95YP+I4OAeAYfEOGA3io/e
	lNI9WWre2RHJC7vsBTKfOHEPZEHrX+CSlvG5J9uf8CoutJSTvvWJADYAYga5Qzbu9fRRaIwzIjBbT
	D7tRC3pjpBMaq1NpTybBB4vXcOT7v8iOnfTmTLBeuR34EOyGgB+s0NC04cli07ynOByX4Q1Nk8CY8
	D08zHJXD3i4imeKqH072dHxuOsfeBm2Qv7IefHeign633Fm0ElYMpRPN3311ONIEU/+Gg9zMge3il
	tTNP6QTQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wu6XP-004I1e-0a;
	Wed, 12 Aug 2026 10:50:23 +0000
Date: Wed, 12 Aug 2026 03:50:16 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 3/3] mm: fail the fault on a malformed swap entry instead
 of retrying it
Message-ID: <anxPuemqdGrQQ9xS@gmail.com>
References: <20260810-swap-v1-0-375ef0767206@debian.org>
 <20260810-swap-v1-3-375ef0767206@debian.org>
 <8c16339b-6050-4a5e-aa89-9f2f96e7dcb4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c16339b-6050-4a5e-aa89-9f2f96e7dcb4@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D58B1A0007
X-Stat-Signature: 6dkgjahnx6x64goio1x1p9qgrqk9axqp
X-Rspam-User: 
X-HE-Tag: 1786531843-28998
X-HE-Meta: U2FsdGVkX1+sO37sWgCGT9Vxk7O0pWEQJy+d5sFFNbd9aInm0qfmA7orilUhWoD52oB8TaDnOIhfzHAdHTiuQk+zDpZhCJGLhL+bcOAFZZ3kX4RT9qIifrQLZNRxqLMpt/f0ctf9pzCMLuddoCnhA5IRthm07MD/xx4Pzy/Vomi55l8MafQvBYaB0YPpk5mC8KAkiRfmDXs39hF3l4jKGtBIYmhb25zvSpzmOUH2ZV+vN6aO7N2cHBSVhRqM3R/LpcJjGVoweMvFYTzvvejrFmT6prgnM+CZTY+d0AWyadBzw4hIsFjSAwR9kLMMfYToEOUmQe/nY50fwOL8YmFKJDQwDuevr0JvjxfNeJdO5gTcvVaVfTNnrOcJDJ9v0lToV7YFot4zNSlxFtKH+BAjpSX5hMcrl4NEV78Qu+KjPBHz/ay1vZ2UOey2D96qrzQBSVNKNuhGJM/yE5xs8ji++EcagpsOvhfQlmvh+sC/gOtDaBuvOBMC9/vZb09tyJ/iqkzRQt4u1Zjm+Z/GpTnSKYhOF0nAkqNxB34k+nph4EowmwULENgEIRITzx9ZEFW/2QekqELQ0PmBIJf+uqFgVYLRIHGN7407h20AE3eyWEpEvTIl7TKEhDzLtfNY0O2xl2t3qEfKHRl41eWHFGBlzdf3XZ2cDlch8RCWzbE1DzLTRnOhB40Cd/htGyOu59zWx8qP3hxm39Ys8A0Gwjz8/0nspTY/N1YNsVBN6nA/0qJaF/v63RRxmt372KaJpMJkNUI/9Yk85pEh0SajFgGMf/7tPj5ZULR/G5EzwNiSGwvcJB9FIEJ77b8nJUrKG1ypjeWicCTQFA9pd7PpfnP5dfa2DoNHdpiMfA9z7mbRitIcY9wTkh6vp1LW1SLRVUjFPIzzABnadxZigHF18u8zmi3ydX8pYHvE2acvat4eiF08wInCwqdsVSrlLx/HgFN+0QBG2ZDwPyWFdpEw9vC
 QDR3O4Uf
 BL80lePYYGiJE0MCaXUP5PxjQeJEnI3Xuc1afEAaupja3RK/PF7ZlO5nMGB+C57pLMybMERT9YJNcQeiKeoJULfsPX6f2jrb0TMZpWx2CNcZJ18C+t9Fb+h9Ngwm0fJ7BfIHo/vu5IfGfDNVcncYC6bZjG7HOQd11DALOCmOBW4rWEwmRRMe+ykjZclDQeBcbnMK05tBEJR39bXDSOUppue2DjAbYI3qq1Q3JcFZAjo07jCXGeW0twG7TXvB4NMRKWF1l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 05:38:50PM +0200, David Hildenbrand (Arm) wrote:
> On 8/10/26 18:26, Breno Leitao wrote:

> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4957,6 +4957,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >  	/* Prevent swapoff from happening to us. */
> >  	si = get_swap_device(entry);
> >  	if (IS_ERR_OR_NULL(si)) {
> > +		/* A malformed entry never becomes valid, so don't retry it. */
> > +		if (IS_ERR(si))
> > +			ret = VM_FAULT_SIGBUS;
> >  		si = NULL;
> >  		goto out;
> 
> Better update the comment above get_swap_device() to include "bad swap entries"
> as well. Best do that as part of patch #2.

Ack, I will update and respin.

> I didn't look too closely, but conceptually LGTM

Thanks for the review so far!
--breno

