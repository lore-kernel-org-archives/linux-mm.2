Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AD2ECCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 08:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A72A6B0088; Sun, 18 Oct 2026 04:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258156B008C; Sun, 18 Oct 2026 04:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E2F6B0092; Sun, 18 Oct 2026 04:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E726D6B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:34:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74A9B16042A
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:34:40 +0000 (UTC)
X-FDA: 85335085920.13.8EBFE01
Received: from mta1.migadu.com (out-240.mta1.migadu.com [95.215.58.240])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3DF94C0002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:34:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LCx1+dVW;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792312478;
	b=nDoqwTgikCgfTwboyhDjm3rVXmuuqswka64S7gJlC1DXYf+/4QFbTqsog8TQ+052RweXTi
	pIiyvNkUZ9NdEI97DrvAeUjyr9wUcTMr3UWCveK6NU2SNekuCDkJt9BYrVetThn1c+ARjX
	FppLlLZLyVaJjzvJ1Km1KS/3nak46is=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LCx1+dVW;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792312478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FHu0SrOXnVIwNP/Tb0Qhbw7/vflkiK9DWXkwldrzj4=;
	b=SUaoQLkchzVMfFSAuOkfdYLNHpMSzJbHM5nz9S+kKA3UtJgRVhMLHU6g3LuXAp7uknXJWJ
	d2em9yK/uqXzyFng3cR+ddYJTpf+9tm5Ayx3dFMhTTjmkqpcvY70MD+h37GNMGH3KyETHB
	1Fa1HqQVn/IXzFUO+woGuFTuwu7Lu4Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4FHu0SrOXnVIwNP/Tb0Qhbw7/vflkiK9DWXkwldrzj4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792312476; v=1; x=1792917276;
 b=LCx1+dVWxKkFYHab4iGMbh4EiGbeivfzobmOF7Km6kkmJSxkOiz9oHwe3BM5yIsDkkwE5kOk
 sR64MbrCwbAOOqc0b8/TEmLuk9aDDbsRMyGciKn55NMMKCnTJ2r6qvn2ke5kNlh9YGvx+bf1BU5
 uNVhmc/+sqCMbSbUVmTgA4oA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5616a91c2f12ed25;
	Sun, 18 Oct 2026 08:34:36 +0000
X-Mizu-Trace-ID: 5616a91c2f12ed25
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	muchun.song@linux.dev,
	osalvador@suse.de,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	agl@us.ibm.com,
	mel@csn.ul.ie,
	riel@surriel.com,
	peterx@redhat.com,
	kas@kernel.org,
	rppt@kernel.org,
	josef@toxicpanda.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 10/10] mm/mremap: fix calling fixup_hugetlb_reservations() on the wrong VMA
Date: Sun, 18 Oct 2026 16:34:31 +0800
Message-ID: <20261018083431.15699-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261015-urgent_fixes-v1-10-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-10-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DF94C0002
X-Stat-Signature: z75s75k4zggmxir8oa6781hi5x7es8ku
X-HE-Tag: 1792312478-503002
X-HE-Meta: U2FsdGVkX1+R2TVTFm4rm9/4nDzFJTM606YFTe9EBc+ZFYy4vKvH8n48L6cIsqz+3c7T+i94GeClpMnAG+5stjuqGnByacwFEGsqc4fiioApPfxCTIHcRwbHvIufF1AMBrXguzKs+QqC7D0j+FPhPm7BI57EqxzngRhuh+i/uPZNSP/7VE6ENAcTl7utrSq3o7m4dcljjKbWDtBg69YNr958Ca9Us1GVBUl47Q/9SaTduaV/Nq2M4LRjXQKqjAXBzwrrbOpW9dwRoC+n0WKjyrsB8qrVoAKGnICzmz4TaygKkvNEZqaglaVEVxr1CuOqbcfemu3JOe+KtloUpxZo/TQWAJd0tRk1HGX41ov3HupjJjKfADRfO94R6NFznR6i7rtxuMKdvQ3sukoyvvU8T+EqY5yT2UW/cejU9Q8i1/SO2uevtnFdJ5tTMw4T0EMQLZmmV2uS+7ptL5djtn038dgd4Lk1rIPL4aDeCrjC/LYvEl7wNr+vBLaMlfDuDSmQ35zfK/y+DoR/Nu5ESQDl09xWBBNPkXvWIPqjAvHXVI/2RXHOgDpGhuJiWKwHyY4/99AWhPBI49LLsmbclsInYT0SI66U3SNS37EJ4yUewjaJ5t0Fu0zdxmoLCkpedav1Pz7UAjNEO2cE2udHZBnmNqn8nosyhLawUDHhv1wqXNDpKeTXAQ3KcdkjvbAV8NUMQWQiSgbdUK2UK/jGF6hNGEcP2eqBsXcuP4CsPAs9kMuDUrf496ua41C/1noJAmEEiIRiB9hw8pASMOjE2ILXRvggyBx6tBq7TRNMJ8Arz792NKjKcWrMuNdALwVhfQ4alGefYHhtwirl4Dr3CcLtvSMEbINVH0HknGlh2cgEGSz1VACD1d/rhPJ0TNrRdxbHFsu1hsgL8PJSYrKg+H+j9zGDmPxVEtMQOpPoMAhB3IVnCvFF1YiA2/lXBG1LO522oIZX8H2QxH7OusPi0uD
 4jXD+RWl
 C9P3KUBgGl5mh93jwjMI/62F5RyjlVISL4rfdQ2t3dxh/82Q3MMiWZ6ayl/7TT/LDLcRIqJ2vx4v2g02hU6TeanxHzzEUYMJkOw1b/EkWqmH0wxY4sKEZdscubUC0QKNSwGyuHcfKjRAU83tbDhFl70EIH+wa43vMkGWo2bJyyc2s4ZpCr++A96YMpxKc3gYuRv1J1DLCg2u+jQH1QDtPdkgu7o5aQh6jaFExmfNms765/mqrqjZTfv3R1jsBbgW1t76ln50rgpP5Dd1jQB6HQRR84CYdkju38B/ps5MBE3XIsrIzkbZIlI7/j8bsmOE2eirFD6Uc1yev/nQlPgf/jcF2ZaCA0eB1v5o/qKzKw74QMF4aT7GeY+/pDArPWNvV4XiI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Oct 15, 2026 at 06:07:16PM +0200, David Hildenbrand (Arm) wrote:
>In case we fail to move the page tables, for example, because we fail
>to allocate a page table, we actually keep the old VMA.
>
>Calling fixup_hugetlb_reservations() on the old VMA is wrong. Fix it
>by just calling it on the VMA that will be removed.
>
>The user-visible impact is that the VMA loses its reservations, meaning
>that the existing reservations get stranded (leaked) and new hugetlb folios
>that are getting allocated in the VMA cannot make use of the
>reservations, failing these allocations.
>
>Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
>Cc: stable@vger.kernel.org
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

