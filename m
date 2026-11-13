Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296B6606A889
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nado3prZ
Received: by kanga.kvack.org (Postfix)
	id 3C3AE6B05EB; Fri, 13 Nov 2026 00:15:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379126B0654; Fri, 13 Nov 2026 00:15:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28A236B0655; Fri, 13 Nov 2026 00:15:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05C316B05EB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:15:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84804140622
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:15:32 +0000 (UTC)
X-FDA: 85428932904.29.130BD45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E1B7AC0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:15:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nado3prZ;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794546931;
	b=2OEDssn4On7sYIOkpQyGkYozutfwDupq5uoALudbfnWwcejFtjNrsV65sj1n9nobnbdBjA
	5g5DHRjAZUxfbsFeOBI/yKpJi3yFHWk8E93fFJLGYnTP2CBHzPFkd4MJcg1yzi284toVPA
	jVP4y63VHHLP03dkmBY4Rg2trSqll+g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nado3prZ;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794546931;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZa3tZ4YYrvdqsY2fuTuPviPfCZk/F7TkrMXqn8SDvU=;
	b=yrKEIg4VEri8r99vrYN5wIskQ7BdnlNMP+WrJauFWUxXxXiTCccfgGXYxgeEiTl1rZi5Yk
	DO8vLy5uBfo+rgFX7a5uVQR5K0alBbfDOrbXrxjiMXzyCK3noQmPZiL14anUAz6lQbl+Zb
	Zcidw0mnt5X9rU3qzhLQ80qXm15nZMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B84E601CB;
	Fri, 13 Nov 2026 05:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550071F000C4;
	Fri, 13 Nov 2026 05:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546929;
	bh=aZa3tZ4YYrvdqsY2fuTuPviPfCZk/F7TkrMXqn8SDvU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nado3prZO5HA5qtHqKc9NMPK5g8S/GDTf1PFS19BN0eD1f0itXc9SoD5GOIXYgdnz
	 k+9GHrawO9moE+d6NVvMHufK51BfNwvgh/5xN32f97sWZ8KbDaPLalNBrRzx2uJn6L
	 8cNxBwJ5L2JKqNqmVX36T/Z23IM27R080wHq+2Wuq6L1tza4A6D++gileL7+3uXla+
	 nPbrtD8dx4GpRO2IJpFDAoI7OhlReECMgFfjOK2rctbJyJwO7kol9YSVM2UhLo1IwS
	 khWbswPGnC3YZbtTKs0lPHxt8pEUz29SczQJq380SHCeHDqC1AvPR0yymQX9sNUuVf
	 FnpfB2rF7C1Xg==
Message-ID: <sashiko-outbox-212213@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] mm/huge_memory: don't warn when a page table
 blocks a huge pfn insert
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eliav Farber" <farbere@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, "H.
 Peter Anvin" <hpa@zytor.com>, x86@kernel.org, "William Kucharski" <william.kucharski@linux.dev>, "Vishal
 Moola" <vishal.moola@gmail.com>, "Alex Williamson" <alex@shazbot.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Peter Xu" <peterx@redhat.com>, "Jose A.
 Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261112051440.16140-4-farbere@amazon.com>
References: <20261112051440.16140-1-farbere@amazon.com>
 <20261112051440.16140-4-farbere@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 05:15:27 +0000
X-Stat-Signature: ma1mtuwh37jbwzfc4n4ynj8m6h6kwo83
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E1B7AC0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794546930-417924
X-HE-Meta: U2FsdGVkX18MQvdfweZAkKnMRK7EKvksZozFFFbXKdtCWN9B9+flbT+HJjQw/8i9DJObqH4ty5vbj7Ph3mXOyUhTyecQ9n5b5FS7nLm9u+XVEG93RwdWTgggReF1PoidvN3yBZpGd3bhQy+1RVNE46GUmxrMF/iPB6rQi76NZplfW+wHv88PrZnRlz1Q5kCsUgxfnIw/ILudE5CyniVEECwfVZxpSg5htvR1FbIBr4r5KxaN1igtfHMGGEyk5OeYZvCLXi9FDr76IDHZ2LcvMfTMYsZrxOCMTgKJdm6c+z2XxNRLHxWm4BNfj3saPncfa4dD/7SG6XXndX3zgtUM0LbADkATJvFShJK7CgONr0ZrPFLV4GB6dfsA5ncp/LI6bEYZlJzvgtrd4mwm+YNkwclQXJo1RWhQxdo3xoq1JLdK3C9XWeB7SHw3bpl6g8izGXTllxScLUxWcL4hi23kEQNJuz16Mm7+bw3fxH3q6AQd2fF/+Vl9OvnYQWJfovh6bnK2M2RaPey71Htk8BKwCrtGVxiSX4A9KfDTeMKQQFRMC9LUKaK154WiIDT3x5rr3jCwvTrAxvK0NZ1GT+2kbo+QoebpZV75TYmRc+ZnY7iR4/hKUCvoRZ3efmMPbDPLiLP4SGWSftgbtgJblGIMsheHTM8JSlSXplWopxquuQUBkzKtdnSxP09wVzrOal77OQ0hsWdXRlyIpS6cwykqmZ5Giefnc2KzkX7JGk+3sXqKRsDW9J7pes+j+YLgpn3UvwWp/fvSDvhUbRs1eKgtB11gUnzs6ukMHF6RlX4rMQuIySrAAHd8P9158Ge9DT3Wf8QTZ+jhWX0SNqz81UAX9PI/fWQ1Sn3GCSkhXckjqBIWFOhruyZ8yv+oQFT6WvupqWTFde3vqHTTCh+/Tf70zGj0qv9dN5gBybNbqVx+xCGgS9nbdwl7bbVjBmS7eV57ySQOfsW5+Q3AiDowTqN
 uqtP+Z3C
 XZ01FOUOhSzyljr4ITQMgST2YtniO/7Ri6iGcKyPYtHcIDNH48jw2oHbSSzXXMYTVK01uz0btJ1EQL9DoRorSX55cskGowfE844vIu3s00zK3zr6Ce1tsNOLdVVgjpk1oRY8Eilv+ZcfyNYcwyTkKb3g6OmmgfRqvZ3OaRVpKu05q4i5xYvD0wcr8OZupmNhFOgUlKyCSsbbcihIj7NIWKPjQAS2kZfgLjGF76flFF3WsT1IkFvfchOxuETGf0bxnDsmnnqXD6+uu485+j+HGb3Y7Pmt5FQIYazZj9Wyv3yh0MZcBKoH9hQBCBmXwoR22voi3o6SQ2iKy/9s7Krk9k8Grnd06Jk5HUiQ1C+azV+ZtFWqtL1uBUgiJHcFeJ13hBHcthISpZIMUjBOgr4ShKVm3n2IoCMKhdXB+6fiQZd1nRRjEC5CMxqFU0b5LAJyPqw4P++7tpOz0nUe1WOLHGjScOONiOS0dEHKU7XA2kE1Vb5vI00Hu60uYUvXlqTkhPsbIVGsltsrSxng1mHEgSIMJaaJw01t6b0UrgscgNC386H+Hf/cZJ0ql/0iiUy2xZFzjLB9ovReAZLgR67VHaVn+PiC8pYaEygWwF9VItpOHiYPZz7hRzsqAcKaK8L9Ncob18+D9BiHnRr6q14fM6scL42vf17J8asXcfxTXd9nFLBj93XcKKRgbDuELNVWMoWMKoj02Uz1tGogB1Xyo3Wclk94kl+vrawOC20N0LBDLDoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/huge_memory: inaccurate Fixes trailer for insert_pmd() and
  insert_pud()
--

commit b401d2d30ea8d00390aed1659aa84d49600aa4d3
Author: Eliav Farber <farbere@amazon.com>

> mm/huge_memory: don't warn when a page table blocks a huge pfn insert
>
> insert_pmd() and insert_pud() treat a non-empty entry at their own level
> as a leaf and compare its PFN against the one being inserted. A page
> table installed by a concurrent order-0 fault also makes the entry
> non-empty, and pmd_pfn()/pud_pfn() then report the PFN of that table,
> which never matches. insert_pmd() warns unless the entry is the huge
> zero PMD, and insert_pud() warns on any mismatch.
>
> A VM_PFNMAP mapping with both ->fault and ->huge_fault can produce the
> mixed orders: an order-0 fault installs a page table over an address
> while a concurrent huge fault on the same address reaches insert_pmd().
> Changing an mm's THP policy while another thread faults the same PMD,
> for example with prctl(PR_SET_THP_DISABLE), is enough to do it.
>
> Compare the PFN only for a leaf entry. A page table is not an error, so
> take the existing out_unlock path, which returns VM_FAULT_NOPAGE and
> lets the access refault onto the smaller entry.
>
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

[Severity: Low]
In insert_pmd() and insert_pud(), the pmd_pfn() and pud_pfn() comparisons
and their WARN_ON_ONCE() calls only run when write is true.  Commit
f9e54c3a2f5b ("vfio/pci: implement huge_fault support") always passes
write =3D false to vmf_insert_pfn_pmd() and vmf_insert_pfn_pud(), so it
cannot reach this warning.

Should the Fixes: tag reference c6f3c5ee40c1 ("mm/huge_memory.c: fix
modifying of page protection by insert_pfn_pmd()"), which added these
checks to mm/huge_memory.c?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112051440.1614=
0-1-farbere@amazon.com?part=3D3

