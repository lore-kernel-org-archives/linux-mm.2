Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B32D606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 06:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YdOHLkm1
Received: by kanga.kvack.org (Postfix)
	id 58ADD6B05B1; Mon,  9 Nov 2026 01:16:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53B606B05B9; Mon,  9 Nov 2026 01:16:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4543E6B05BA; Mon,  9 Nov 2026 01:16:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26E3A6B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:16:47 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81E281A05E5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:16:45 +0000 (UTC)
X-FDA: 85414571970.15.AE55A82
Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7F6CF160002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:16:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YdOHLkm1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794205003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLoo3d8wA/2dmWzlOHmZSdy7DBfGYigRliA9FCVCD2U=;
	b=jgT/P2EXAImiAXFNrQuXr2iX81TKmnTVFFSwj6w9S++uOiZMcKO9AQPLfyvBi5YgE1OTAL
	PHwlznFQKOZ5JuO87pRUDhaOVH4x0IKwWvzpjKOMosCmFs3CNhM/N0pD4t6MSQ3CjPbEQd
	/qo8ZdwFa/+/cC9SpM3vB3tRcE649F0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YdOHLkm1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794205003;
	b=SCif4CF/+v+hgaWmyxNGjYYY8qHYOdueH2JcLKZXtG/fPY61xadSzYfjWD0MVBi1tfN8Sx
	EK2EuIQzT5PsJurd5mWICTPyckoEKdqrpqNqqNz6O6zMkUMzKZ5sngplnOnkpcnSlHBMI4
	UptiPxp72IZ9JuKG8iYUSY0X/SJCYiI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rLoo3d8wA/2dmWzlOHmZSdy7DBfGYigRliA9FCVCD2U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794205000; v=1; x=1794809800;
 b=YdOHLkm18ej0NUagkOx5fL3TEOgHMQ4gnUIWPRRwP2usH38o0YIcXOhwUKSi9HBHrLmHN3CF
 VnYMJvdPfaRR5Gnc4oHs25xqt4OL2JddMSYjRcOZQnm+keRRQyCMa8U5/cjU5k8uVN1qEiWUb8p
 luxB4nmOtrLFMWZo/OoPRgjQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b7a98a3c4281100a;
	Mon, 09 Nov 2026 06:16:40 +0000
X-Mizu-Trace-ID: b7a98a3c4281100a
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: david@kernel.org,
	maddy@linux.ibm.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	lance.yang@linux.dev,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	osalvador@suse.de,
	qi.zheng@linux.dev,
	muchun.song@linux.dev,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 5/5] mm/sparse-vmemmap: drop @pgmap from vmemmap population APIs
Date: Mon,  9 Nov 2026 14:16:30 +0800
Message-ID: <20261109061630.47601-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261107043122.25650-6-songmuchun@bytedance.com>
References: <20261107043122.25650-6-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7F6CF160002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: hsqetaghzo7feosx7gezc8r1mbtjgab9
X-HE-Tag: 1794205003-963663
X-HE-Meta: U2FsdGVkX1+A4cJbwOsOulXsn+VP6vkycbRS+kpc08h7aSab6VxHepCcZ6ziBHpx2zJEdzmNJnaoAuf+GxFYfo2LcYb5eabcJgYkp0BWw1AmB2h0ZexH/Q9b2krM6xBlzeMvlhnF5pat9E4fiGgOb7NT4LBxR1YjvIuY3ekIez47tJmEDkKIMim7Vuqg7Sr2xPhnYp43AOkuyKZIPQppnTVDQe0+HLFHof8n71lRWJsu3/uNBE4rJ1BerRzCNMFffwfOghK9stq2AZ+Giq7YCx1HWBsD05ajX/geHrKG2CIOsarVmL72tNGrV7h04zjthm7Yf/KKgv3+G3/wcKCgqcvPgFmMsdZrH9f8zjShmBSpP7RZNTNlQefsbhip1/7oCPqtP2N6p05yrpHUeNPmD0ntucm62Tk+yggg5cFll0+mGaGmPzGWLdsRSKMadlQ5J7aQWYhG9LGJfvYjgtRaPxcpGMYPHAOyEsnJvMnvN5Z1OQaeGpaLjEbZObb1yl3EYUGB3fJ6m3VzcS1BGrXb563aC/Nz1IK4bfd6JMzY+LXC9SdJwffdWl5bV5nsMjn4vIv1doF2Ny1WjDX0h/7ls7nLFTS9qN2MCp1zq2Rj8f2Tua3FjWO2OwBl64VDPV4fHtqqTtGTc/Z5qpneLskw3+F5xz1BBMTbXSYKzzMwTCOOefNBkeadUN5VJy1r6+QEQgFH/oGOojCvSrml5/inFBVxN3NeUBZHZ0sNSwZr2yxmOr8c1kjjfU+liGhfiieVVsxNs25N1WucmagB8hLJbTkkLuFT4zg2Znzfy5CQoMjhNhpptileGJIpVNuMhj8i+5A+GtRtrNDe9mxtSentgINKWch7zo/fsfXg8bWhgNQrX/JvOuJKlVz2GMpTQgFlfzOTtR8lVlnCEK+uXSij/k25s/KoXi1NViwMfx4N71MNJrO9+lP7/vLkJC98Lyb6qawdso2zfdLwQytu5rr
 jKU7m5cF
 IDZqvPVEOu/FwBS6Eplb4uX6KQukZfe6XMCCNnI9iqGQ2TGYf+/886jZmz4AWN1Vxw/rsGztT+68Q1+L0afUl3wGilyEc3D/op4bArDaEEZctF1T4KQlwhIF39g80qHtzu4q/0/Cd+JWiH+nyC185vCa9MnKidhkRhLEfTljjOXtxQnI0YC+1bi4D7yiGARisQjp0ulRvS/YQ/f62vEl8jfaUUlHKvdlX+K2qFpJJuTng6EUk1wwVjPTKDF0ea02ykIVSkrBq+UacEBtAO8ysvh8BOLlraZnYXRwf1v63qZP4jt2OCQmI/61ieQckhnY8MvvZtynP1dVj4p8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Nov 07, 2026 at 12:31:22PM +0800, Muchun Song wrote:
>The vmemmap population and memory hotplug paths no longer need @pgmap
>to decide whether a mapping can be optimized. That state is now carried
>in mem_section, and the architecture-specific population code can make
>the remaining decisions internally.
>
>Drop the @pgmap parameter from the vmemmap population helpers and the
>related memory hotplug interfaces, and remove the remaining
>dev_pagemap-specific coupling from those call chains.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

I had another another another look and couldn't spot a missed caller :D

Might as well stop passing pgmap around now that nothing down there uses
it.

LGTM1 Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

