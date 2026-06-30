Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD08C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BEC76B00AE; Tue, 30 Jun 2026 08:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FA26B00B2; Tue, 30 Jun 2026 08:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F386B00B5; Tue, 30 Jun 2026 08:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF4036B00AE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:04:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52402C21CC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:04:04 +0000 (UTC)
X-FDA: 84936445608.07.9C8C4E8
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf08.hostedemail.com (Postfix) with ESMTP id EE50E160014
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:04:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=afnIokYB;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782821041;
	b=UjbkD+h9hphM6GKEOqAGW3X5EyRajMgK8eUYcKX5ks1byGXTxxtDA44Xl5p5YBUWZvOMQI
	2qfXdpTq78c7fo+9UfTPrOeNmDSEJa6y27nuhZm43ZkPq0DneCEenDcV4tEtKW1rijw1QH
	fp50C5aHapDwnP1udOLy21AjVlO4rkE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782821041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/DMUiQ1VPaw+ocwoQ3oyh/3Cnm4EySYJMIokcHus7g=;
	b=XmuvzI0i0joNohgvVwGQRJ2Zlw+nCn3E+sCOAQ3sa1hXSgnWbuKbQKactjh2wwHhQ1tY59
	NJc8u+gE0n+G8jkn9YFixAksA0sE+PZHesfZnbI3AWN9PRbHntRRC+9sKqKfqn8RNuu1RX
	Dy2sRBDhPJHEhBb2Jcd9Ww3KTKXwqH0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=afnIokYB;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782821039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V/DMUiQ1VPaw+ocwoQ3oyh/3Cnm4EySYJMIokcHus7g=;
	b=afnIokYBOW1Nsyw5v2FMpAPhzWDSn8Xmhm8lmi4QXXJYhfCyHTu/UVshzew1eNimj7yZJl
	5tPyYbPjrpHXa0TJ2MYRl71Qf/B0aW970KDwwl91kx9ODE/LlDdCTkLiwA5pgrxNr3s57T
	Dh0Z1m+HITnk4VjZz8g8g/Gx9nDfeSE=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: davem@davemloft.net,
	andreas@gaisler.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jannh@google.com,
	peterz@infradead.org,
	osalvador@kernel.org,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 1/3] sparc/mm: drop custom pte_clear_not_present_full()
Date: Tue, 30 Jun 2026 20:03:44 +0800
Message-Id: <20260630120344.81142-1-lance.yang@linux.dev>
In-Reply-To: <20260629-clear_not_present_full_ptes-v2-1-96089871a1e7@kernel.org>
References: <20260629-clear_not_present_full_ptes-v2-1-96089871a1e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: u948qa88getd5iqxrsu79yhpdz65ra3k
X-Rspamd-Queue-Id: EE50E160014
X-Rspamd-Server: rspam06
X-HE-Tag: 1782821040-404472
X-HE-Meta: U2FsdGVkX1838WgLH9nGx+DT6cFiLNJiBMq7XRgruBeI52J/AP5S6MbiH0m2wm7GyGYyOdcS6sAyMHJbB69D9d2uamqP2RXeXUWmpwj2AUzsFzYvxiWXSbs/CusHXxEpd1pJmHyrYFdgsVsmfAbtnDR1LxVsh5HqjdQefrfxqw3Cf8tkVhIDjPJ43fOpihRXpnrLOA46kHeMhnEmGy7iAZFXCmO6jvOh7tbk1aH7HMdIVkXajm5szQWdDTw6VQU9s+E1rVCc97ZjLPC7GtwzkiquBxuzU1YykxZRcXOqpPS4+VsX2KHe+fVFngFXno1Fez4VKvS0Vf/5RZ8Q0phZYuJsjTB41t34DgCWtAw2Qs9Sq0a1iU38DL2uiaM6VnvJFMMBl1s5E02C/IX/EhATB3cCF7Y2gvN14UTQ8duufPaS1C4p9jVohDz+0pd4jW/VronwBfLDiFRAry3qY5UB4FHXiXblmAwdHby0/AFmT+PswaXlfvToNIndywPuRNHaLTkVu6CVxvoCOl5oo+NbTkH9AIBcmN/xmWiuM4/792ZPtnJi9FQMU6Ftc3+jPcHjafR/BNBxCCPBud7MR+mcg0cm3FAy0OkGtx83qwMlfrbfm+1k3kT1KucIjYIKrDhmNgarHpDXuy/JMp5QcTh/DcRHurhJYXWUXwiOshFq3gRmzv8F7wiJPTPI1ULdSc6Vtf9BSmCdIHbaLNvNAyPc1Bj+1VVPegzhZD0c00b3/CsFt/z7svV1jf2k34OEPI79Wfq2Rh8l5rbCg1YX4YcS3l/9CR9yE7mBoo1Tr/+ghwv4YEnYksaAgd24EHd1VyZDdXAT6VKKyRhD1ywev4sRPUZoEUr74yWFcZPWPA/jKfFpG0b4YRLCL90rUe9yiSmyLvR13t2GBXjG7abmY2P3RlGRgvGob0uz8VzlZarMj2+zq8nnzhfJk3QD+UNGYfcDFCUeYB/zadCEQe/MfNF
 SgkN8Kab
 +5NkVp/laOhr6Jz9ix7i3FwuGqDv0+Gln8jjCpE3c0VDY2WSMbSnvKp4fybOATfQIrDACJdv2QyN1YRe+zVPJ7br/gFs9+ZQuSXZw8bHidcE7/UrE3lGEDzJmaigvsLAWF+HQ+JY1dXDn62lX5me6KJrzRrtIJcIqbniKc1nlJ4J676BYOPaqkVkIinrtA4OyYLgBTPrC6dLXWQ1reKnmhhDA9Ihr73pgINNmSW/AGh6hxSmSFujGUGALlb7r5S331eMirvg9oinznrAe6bydPhZy+lzOXrJO7F+/VOh/G88V4BUc2EnK+Ltu2Kwc/SdRfQM0phe8n1SQoFIUZ7aieyGAqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Jun 29, 2026 at 03:49:47PM +0200, David Hildenbrand (Arm) wrote:
>On sparc64, pte_clear_not_present_full() nowadays does a simple
>__set_pte_at(). In __set_pte_at() -> maybe_tlb_batch_add(), we check
>pte_accessible() to see whether to call tlb_batch_add().
>
>However, non-present PTEs are surely not accessible, so tlb_batch_add()
>is never called and the "full" parameter is irrelevant.
>
>Let's drop the helper and just let common code do a pte_clear().
>
>pte_clear() on sparc64 maps to set_pte_at()->set_ptes()->__set_pte_at()
>... so it ends up calling the same function, just with "full=0".
>
>Given that "full" is irrelevant, there is no change.
>
>We added pte_clear_not_present_full() for sparc64 in commit 90f08e399d05
>("sparc: mmu_gather rework"), and I suspect that it was already not
>required back then.
>
>Cc: Peter Zijlstra <peterz@infradead.org>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

fullmm only matters if an old non-present PTE can pass pte_accessible().
IIUC, that doesn't happen on sparc64 :)

LGTM. Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

