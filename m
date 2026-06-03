Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C6BCD6E69
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 17:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3CE6B009F; Wed,  3 Jun 2026 13:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB5C6B00B3; Wed,  3 Jun 2026 13:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1556B00B5; Wed,  3 Jun 2026 13:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4236B009F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:55:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1AF3C1C106B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:55:15 +0000 (UTC)
X-FDA: 84839352990.01.AC58DA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 775AB16000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:55:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eltnyHCK;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780509313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIsSV0HW1+ANeS9umGY/QJFakDMw7AYj6n8OmAaihas=;
	b=nVa5dU34twiKcQVMoeYAZspfvycH39lwrQiFAonrox4aM3GIPQ7+5QerqlxVfrIgUIZSVz
	8T/vOIM7KJW07nlUNf6WgXreXSdNjgBJaJ4uAz3qjaBlVyoVgsG3fnxKOjVGfdnjDujnB1
	iaxoykQbMGvWZFzSU9g/mvIh6MwnyC0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780509313;
	b=FLhjECFsnFExL4XSQZH0n6NlupK5bPNJBZ1QXu+x6Lbr2FhqechiCbr+7euOr9Cdb3HNyo
	+OV6arCcP1uUFQ5CC3WF68ADoB6RLcnI/ItLdF4iFmHd02d7vwCheBt7LeVM8ZOcF1jpnd
	pLuUyxDBN1B0xBLudEIwRGtl2fpMWDU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eltnyHCK;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60F2E40994;
	Wed,  3 Jun 2026 17:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53841F00893;
	Wed,  3 Jun 2026 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780509312;
	bh=dIsSV0HW1+ANeS9umGY/QJFakDMw7AYj6n8OmAaihas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eltnyHCKe3zkwhu1VQv3PxsGoVF21f2sxBgxiCfQOPiPzKfR5rO5edX8/RlSzmBoX
	 AAAqZJL+3WF9xd8vANbabA7EozFcKo5yKs/Kh/tu3fhxweIo0uFsANF4mzRi/sjKgC
	 Ly5KHTbVH3X9bQITn0CsZXBP2/JMoi7uugaSoZEST0X12vNhKqOn4/giUa0gvgVxy4
	 ywdGNqeoXM0Fk5jAnbtUl2f2XU4I9j1AfhlBYVp3w1huH+Pv8E8ADcfw4gcHmJ+VnO
	 4KnZwmmgoEKAtFwQG/7BsTwhVk9LuqTJ8CWcE7zcxsYn1rCYWE+qZ6iTNKhDd5LL/A
	 0feE5ngEA/7iQ==
Date: Wed, 3 Jun 2026 17:55:10 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aiBqPjeHmECC0b0P@google.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com>
 <aho-Z6wshceTAYd9@google.com>
 <ea2c1323-1440-e927-f14a-0eac54a245bf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea2c1323-1440-e927-f14a-0eac54a245bf@gmail.com>
X-Rspamd-Queue-Id: 775AB16000E
X-Rspam-User: 
X-Stat-Signature: wwycnhe45q4pjzgzkps6y6bxccant3cd
X-Rspamd-Server: rspam08
X-HE-Tag: 1780509313-806404
X-HE-Meta: U2FsdGVkX1+jMCbqedUcGMV8qz74pni9KjKcm96lo2XY3SONS7Jw/ugW3HXoux8rWIrDGpfGkW8skY37qyo2mG3BIkc/+fk22rCsmYHeT21+b2RN8pkohdIDbdm9ALsP43+b9udufmLjaCdXqc2UaO4hvpCGLcP0XP1VP1LAe/VZdLm8LsoXMg3sCi7Eqge5vDy8phrBz4VPzt0w5smdmUeWrnLd9aBE9xn3xXsnRQxZq0jkZeMIGIn3wTDZGoMaqMsHuoMSTUHNSEAUABtPzQGNWI12XCrkZ6TewjUE/qoFT3+YQ3/cC29rOz/fpt7prjYqI3V6PIRGwS3FW6bvSFt+aAZh4xMJzXdZPvmMagRo+2IvAYYrB3McMB+WkRjMkD0JNnOHwjGwcmcGHb0ENALS9h3KxT++nCIn+jMY51QeLOYHdHGlq8gHnitX96+wk3SUy0AanUHEKcb9Gn0M+UY3/IIaFlXe9Uhr6pFRxWO8JAgqdn0juCPvV0Cl8PQKtunI4bWpjZzPMulRHVzK10qGp8yNB1qEjzDSq3kyInHo/9ANFI3r37OHtWaLz8f+0QUSRLequAWV6GS1nE3a5vBn6j0VsTIlG+taqd23TKoct/drkQqW1z9fSPp7yZilfn2Kkj4ptJAcCHTwW+GfirW3ywXITxNgj7pveBvA2KbMNG/kID7IyPXph+i727fn3W13hRgMEITUmGCUiO6o9wx6gZWnxtJuryYnImgaRxs+khe40zi6Xa77VMG3Dt7seyV3HYfRIPa+vSaw3BxwgSNdXoBzBc3Ny0zDS4p4Y6f9qgI3aeAevTltRXMJYGdxaEIcOIRILHyapCRf8gIKxxjWax7bcIWsHD3HS16CLvvfG8W+zfBb+vXY4noG670inFL0xqCHm+7hXdrI/mNEu6avRI5LhgtSjZRgzQ5nIPJjEuSBzJEp6ZAcbCvd5UUf/gz7rfW+a5T9DCIB9EF
 R2wkj5aF
 uhnhW82WkcjjGg4UXrHQp3vdpB2kUgk+DbEdqh9YgIbdnSipKDp4nleoMWNrBw+PFCnW4oBxZq4KsLDrJxHonbj0t2KmvUOjRuvaRB8CfcCZBF6B9lMJqi59ZQElu8dMjLe+Jh+1BHLF2Su8P7VZJQPhmVtXASIzwQL3G3CarXNQbmhk+PXplQq1nxDWHaHclb3Ryjz1hXxPKkKEzbvb8BLvUMtnmrHJCwdtBV0kt+sXWLVPdaHV8eTNrXyI0sJ0BUZbncapOpw0o3WoxW0RQMK5pKiNHvLPV54ui27fJ5W0GjIMfMzqyvIXQNOl49J+ihcz5XISu0SR/LA4BRP9qnvf8S2RCirNgRl7PKfQWw/ayrZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Is the main difference that we are scanning in batches here? I think we
> > can have shrink_memcg() do that too. If anything, it might make the
> > shrinker more efficient. Over-reclaim is ofc a concern, and especially
> > in the zswap_store() path as the overhead can be noticeable. Maybe we
> > can parameterize the batch size based on the code path.
> > 
> > Nhat, what do you think?
> 
> Nhat, since we now have the referenced-based second chance algorithm, should
> we consider doing batch writeback for shrink_memcg() as well?
> 
> Of course, we could pass a parameter to control whether batch writeback is
> needed, so as to preserve the original behavior of shrink_memcg().

Yeah probably best to parameterize the batch size and keep the current
behavior of the shrinker for this series. We can play with using batches
for the shrinker later.

> 
> Thanks,
> Hao

