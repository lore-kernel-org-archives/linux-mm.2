Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C423D10F22
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 11:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746716B0008; Wed, 26 Nov 2025 06:08:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71DD96B002E; Wed, 26 Nov 2025 06:08:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65B3F6B0030; Wed, 26 Nov 2025 06:08:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 527996B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:08:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 050F489AB9
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:08:29 +0000 (UTC)
X-FDA: 84152484780.06.0ABCF5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 34E1F40003
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:08:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hQ29ELhi;
	spf=pass (imf12.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764155308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U9DsEQJFMiNmINf2JGNBKh81XEvwQ5gISNQ0DN6QpHo=;
	b=b9LmB5Cosr1Xvgs39OiDysrM12SRkPSbjR2RRfgjeoAZScnYC+QVYnQIMe1x0wTDvw0UUz
	M1cb+ERQEVt+7l7bOs4xyTStRnmwoGsmwUs/DgE7Xun7kcal6cw3nawtZwEkMPe9OYlivb
	oOkO0+9HG/HW2usyWr3Bcyf1woLyA7Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hQ29ELhi;
	spf=pass (imf12.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764155308; a=rsa-sha256;
	cv=none;
	b=fGmnfan/4ftSCqfxud7iMfuDxxbcDpd4FHnF55ljiEQ09qLripHBVTU1vWJ5nRYYEuZKZz
	oSd0KMSRWblHnwYHMGb3q4FKeFV3Z26fNAA2oMzSVCsQgN9+4sdteHagOR43k3aEbwYqdk
	IbfGkd2OxOjSGKQZcqeMXmrHCn4vr+A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6367A44065;
	Wed, 26 Nov 2025 11:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EC6C113D0;
	Wed, 26 Nov 2025 11:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764155307;
	bh=CVdLyC6tIhbwP1dKRBost2ptghGpeg2cmZtZEA7xGm4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hQ29ELhin85lmtvEwxBL5KVjagO/88PonpwLzCU/2cvS4LT7AwcX9kgLwKmrPTrXx
	 GbO0IREIBGaoFUzm0IEhgiVy8pr8NL9vFTrxgsJgiNbjEP5BjdHMXljA0on33JsIgg
	 XMx2thnXWaGpKPCRCxotTZj7lPQiNP/Y0xWBT3jwEU7dGUsT2H0UFjkH9U051ciIOm
	 /CIKtWvjcs7CwMqWvV10Fn137Dwhjq0TORYIPvr8DInchqk05RqXijp8hodqJpXBwm
	 /lgMxLV86WSjPxgA69A2wa3aPUCLE2mSw/0Ghi4d8PJ+lN1uWDBeOHUdGgBUlq2p6W
	 tMjBR24MVFG+A==
Message-ID: <0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org>
Date: Wed, 26 Nov 2025 12:08:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
To: Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Julia Lawall <Julia.Lawall@inria.fr>,
 Nicolas Palix <nicolas.palix@imag.fr>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-7-samuel.holland@sifive.com>
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Content-Language: fr-FR
In-Reply-To: <20251113014656.2605447-7-samuel.holland@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 34E1F40003
X-Rspamd-Server: rspam02
X-Stat-Signature: kbq5z578mxqqctjwcfhijxs9xkcncz5p
X-Rspam-User: 
X-HE-Tag: 1764155308-395200
X-HE-Meta: U2FsdGVkX1/MWbn9KPr+ixjLz/G0ueHrvrrU7wN6kOEO6ZgsHBCMqIcWzRue0zuOYi6OOfsQVLFxjTpTIPj0TEQu6bishyzxlQQNTRp0d/fG5x5C2wxZW5GzGUz3OrQ5IDoBaEzSwyiANfFA8TqmaUZPaRtEYTuTZDhEnAtumDp9i0jCuhcvNc/ZMg++HOOCRVNA4P61RYC7Uv3OaMUuhj87JmSKxie12VsngaH7wjeG/ku9UB/Xk4i+x1nuoH7908PCLb1EGctszhJ1x0f0G1yEcn/tVLjvmSX+fyuGuXwe74kU4oBgsv9gLizInaqzjoZA/jYfLcOwVj/MXU99B1AeosJms6PPE0ueRdB8lbmZYweGp/3wdgguBBM0BFl0IOue/ACF/yodysjq0gmC9zIKA6zCw9OvrqSpBbyP2PY+k2TzhPUQk4qtVidruwk7RfwMCQ7n8nrDpMDunqD4AHg4htap2SOt2xhqi3HYWV/kb8jsN9g+NSzkOtZ5EOU7DJjlq4GYsdnterjmAyeVvCjH+qETAbeLYWoaRbseun9TB3hl2o7aE54ldmWD8Ft8BYRewQgvoDte9C8rkim1ytles+4qAojs40x7BwoNpDyREJCNP1fWHwwdgM3sBwQZk8XHNdxecCP15UqSzfWHjHpqLp5XltUibz35Xb2ypmAm/Z4PGG9MthbpJ9d+axutf3Hj60q1AaxnUi8rVZAbb+7t2+x64TnIfga9uCyVF8+e4AWcjInCOswIagjyjCXbg4/UzcAR4JcSI1fEH+vMDkE9o97Q+Fj+pGVx2icdJN0+7hO9XbQVIxki2+CVliQ8Axc+e1uvAR37YSFGE9fyvm0g1AF+PGJH9z5+V59vcnv327FSnOxFSEmlv+R7FEnizqT4vNA5JBlJto3k1uH8YpGWJwQZvydaU90pK1OkpChBH+GbF4PNXMZy4doBfthrdiKu30slwqmKlWqj/Z8
 N73m3yoT
 Skp677WSzcENa6j9CYJoX7qLvbnbi8jj56iy71oWiK0NnDwF2dwIiSUUWoLGHTKQxSpE1iGA5FC6osjjNbY9IxDeW1ZfWrkjxWhbSYFvoPgw14mXUxCWDwBjtd1bO+FflkJZWpfd9PNP2b2AgPY3LvAVTSD2CsjonxZBUuHk6/1ywz75UdaWQbi6f1x8ZH5l0/kxfIJnMnHljriuNLfNp4FLunuvKVOPlQZsrPyQWkLR4jmLrEUTKrc2gthWpdwTosBRLwM2bJExi1EMk2KaQXNLsK2yRrTXJxJF6PRoFVxidBZKA0jJczt3AmUMVyzjMBdj72OGgX6oF3afeSeANLa9CNi2U9amYOrkGQjgN2ow8fn5SiqR/YmBcpzK7Eh9xSgrVj8ka9zfaOqLyMDfOTtAGbzItPcJVSKWs+dZgA6MhLg8XHPHfz7nnKCPJGMuQVexGSQz17HZZYgXHpD/DtzbwAU6EbVFFz1fBxl3dVjGlMlwfgXaMFAWCbrO+UjjwCNaffcbPxEfbRbo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 13/11/2025 à 02:45, Samuel Holland a écrit :
> Some platforms need to fix up the values when reading or writing page
> tables. Because of this, the accessors must always be used; it is not
> valid to simply dereference a pXX_t pointer.
> 
> Fix all of the instances of this pattern in generic code, mostly by
> applying the below coccinelle semantic patch, repeated for each page
> table level. Some additional fixes were applied manually, mostly to
> macros where type information is unavailable.
> 
> In a few places, a `pte_t *` or `pmd_t *` is actually a pointer to a PTE
> or PMDE value stored on the stack, not a pointer to a page table. In
> those cases, it is not appropriate to use the accessors, because the
> value is not globally visible, and any transformation from pXXp_get()
> has already been applied. Those places are marked by naming the pointer
> `ptentp` or `pmdvalp`, as opposed to `ptep` or `pmdp`.
> 
...

> 
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
> This commit covers some of the same changes as an existing series from
> Anshuman Khandual[1]. Unlike that series, this commit is a purely
> mechanical conversion to demonstrate the RISC-V changes, so it does not
> insert local variables to avoid redundant calls to the accessors. A
> manual conversion like in that series could improve performance.

And this commit has the same problem as the series from Anshuman, see [2]:

Before the patch, as an exemple on powerpc/32 mm_find_pmd() was:

00001860 <mm_find_pmd>:
     1860:       80 63 00 18     lwz     r3,24(r3)
     1864:       54 84 65 3a     rlwinm  r4,r4,12,20,29
     1868:       7c 63 22 14     add     r3,r3,r4
     186c:       4e 80 00 20     blr

Now it is:

00001860 <mm_find_pmd>:
     1860:       81 23 00 18     lwz     r9,24(r3)
     1864:       54 84 65 3a     rlwinm  r4,r4,12,20,29
     1868:       7d 49 20 2e     lwzx    r10,r9,r4  <== Pointless read
     186c:       7c 69 22 14     add     r3,r9,r4
     1870:       7d 49 20 2e     lwzx    r10,r9,r4  <== Pointless read
     1874:       7d 29 20 2e     lwzx    r9,r9,r4   <== Pointless read
     1878:       4e 80 00 20     blr

To avoid it you need something like:

diff --git a/mm/rmap.c b/mm/rmap.c
index aafefc1d7955..0c61153f4ea9 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -819,15 +819,15 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned 
long address)
  	pmd_t *pmd = NULL;

  	pgd = pgd_offset(mm, address);
-	if (!pgd_present(pgdp_get(pgd)))
+	if (!mm_p4d_folded(mm) && !pgd_present(pgdp_get(pgd)))
  		goto out;

  	p4d = p4d_offset(pgd, address);
-	if (!p4d_present(p4dp_get(p4d)))
+	if (!mm_pud_folded(mm) && !p4d_present(p4dp_get(p4d)))
  		goto out;

  	pud = pud_offset(p4d, address);
-	if (!pud_present(pudp_get(pud)))
+	if (!mm_pmd_folded(mm) && !pud_present(pudp_get(pud)))
  		goto out;

  	pmd = pmd_offset(pud, address);


[2] 
https://lore.kernel.org/linux-mm/f40ea8bf-0862-41a7-af19-70bfbd838568@csgroup.eu/

> 
> [1]: https://lore.kernel.org/linux-mm/20240917073117.1531207-1-anshuman.khandual@arm.com/
> 

Christophe

