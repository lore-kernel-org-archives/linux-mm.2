Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04EC4C44533
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1180F6B00B9; Tue, 21 Jul 2026 10:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F1166B00BB; Tue, 21 Jul 2026 10:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFD836B00BD; Tue, 21 Jul 2026 10:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C08196B00B9
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:57:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 559B880187
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:57:48 +0000 (UTC)
X-FDA: 85013088216.26.24E87DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7E9CF140011
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:57:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CF605gLh;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784645866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FE8BGgQW0fYMcN8NBCYcnkW6qzjkh5NcrjtCMjU8eh4=;
	b=arDqoYYLzOgyAGMirEWk5tItf4o+mOrmMnqw4PtLu6MdLEMSz2JTjCUO/5e1Kc+aePatsT
	Pm4whvfM6qbO0LJbDKjChhWcbcp3EOeMdYMjSXQF1G5KvhNMFx73Fv9sSodRtkDyik7u9X
	T6JOmdLE84HGMZKnv+hqoFS/6ZnxP08=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784645866;
	b=WCSaiBUJOKZHR50T2SEX16xjYSiWBeIuy1Gf9EEA5OALg4MgJfUQBuM68xZ7T/3mS14KAk
	oZS4h5d+7/T0+Kpm2eXwrVGZs4mh40VBK33SP9H7BhEAir0frk9xjgD+TuGh+DYlqjr8Hn
	vupP0+1urip3GL4EDQqaZCBZizZZkNY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CF605gLh;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B185842E54;
	Tue, 21 Jul 2026 14:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D9E1F000E9;
	Tue, 21 Jul 2026 14:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784645865;
	bh=FE8BGgQW0fYMcN8NBCYcnkW6qzjkh5NcrjtCMjU8eh4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CF605gLhkL6zeNadf6XOk+7+Xs2t0BTo91YzpcEjV43Dy4ytRnKlrI1fy3IfzLfr2
	 H237T7YQRtv9qWHYksEwmMf5RE3ZYvRoJSOeXXL+2yh4D1dEUPcTyLwLec9+Zn3EgK
	 qqCNVLPEojFqEefP3dviDr8CHO/fP2J8TwcR2ZYzx237I42d3HVsZR1VLnvfEXyRKs
	 0SKBkLrnKLIE8EkkKJgQ+T6TW+p6uojk9GEgxOrVIp+aEpxVUV3oDZJRz7AsXfNubY
	 ynooLXX47XDmMejrp+qJn7sUW0kyUeIx0eFx+Ch1dtyXdtQo0kiZamHTYgY5ojROd/
	 /R4xf4Sm53OYw==
Message-ID: <4da506a7-11e2-4cfd-9f0b-ad8635190e89@kernel.org>
Date: Tue, 21 Jul 2026 16:57:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/22] mm: move mm_flags helpers to mm_types.h
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>,
 x86@kernel.org, tboot-devel@lists.sourceforge.net,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-2-44be8a7685d7@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-2-44be8a7685d7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7E9CF140011
X-Stat-Signature: n9jf4xu1df97ag1adxbopkmpdjup3wh7
X-Rspam-User: 
X-HE-Tag: 1784645866-250230
X-HE-Meta: U2FsdGVkX1/NFcCtcPM8mzdgq3awnLt+S/DzY3d8Kt4isniR9aEiO4yEDWGlEm6jJgO8RG7jpxY5A8zqQZVo5PUSR4PEpXR/C0supqffPLF+ePcs8SvJw0fVwlVP52CNTv6hBEtRmcSzpT4fJ9aSLSKXly0nwRdKTd1203R78D0dYQHyNkY+QZV5Smbl0PFiTwbnh4xDNcy5MkKbiklQwRdwvRsng+SlkEVQIIVg11VevjcM3hEqd8cAaKmnAda2JJ4IFj3Wovn3WM4bEFfxdbtBkvScVPR+AShy7DY+J/t8j6hHRXlQMd3tWBJr3vnYEoLIN/cK8wMdnUBWgZe5bv8/CDdDG5ljs7On3au3ktg5R5HEqoZ9GueJ8TBjnXlRqgifD38SVm38Qot8E8ir8/cZfJZjoFephH+pEFcI/n0RqbS9nxoOXdVaJujpJfC69Rnh+a9K6liuy57yn4ps3LuhrAmR0oLkCQcbd6mQBKfDUSgGe5khJjjqWMzfzHfuZyzN3yMRsSigCHZDrgtkr2WetJP2vcnxgtfek7few1izWNFhinAbyn92FRAKKEk6t/aX4GTqLd/gNbiFU43lS6d36cAob2InzTKfxTdVzVmLmWUzbUWZMOgezjtla8brPKPWN1SYBYKlbvmQqKh08wACYrSKKLo7FLJ7oSQ1UzAOe925gfucWuTZAjZ7simR68Tq1MTohRpgnlBR6fMbotO0q/mdE2Eqr+3IKWpEtZ1c3Q+qZGGnPu1RYlRn/cjSFAgznEo5zsUXa9UFsN4cSm481O0qgtbsH9WAbz+qrruCAADBE8rE6Y4LDtE/c81BlFy0PtM8WejMsSnYz/kkXxA7wFAruvSw0zli5ZbHuUxdUIW66zdcD+Jj4auvWQYsX1E1p2XyweZIFs1cPbCXRmn7wf3psLN9ERopqVKmirWQVC48gjnSIwSJPDsd/oVx7lx9wxUIFoWFYKnmexc
 ysBYV0Vt
 es7M76h1o+pAWSPKuliWvV3O8Xzpooe6A1VCbJtD6E+R+o+KF087Z+6OqAejSl4ZeNqJO/PdNevZxx/bC19VPXtzeO6aNHs4vYYNgYFjq1Lbi7l39gCV3zU07yZeBtzE6hMi6052enPxEsA+UFdLpG3hDTi/yJ6/nTKKAdhXs/A+xMd3AetWO6A7wrYcejGxbwujZd9Nr7doXH5kbQvEeo3UFvVQz0ijhgVsuSa/bt2QqlDoCFW6RyM9h7DdW4GfShRVjFs3XGZUEx7hCUbt0FuJjBF85+JHp8SAQYwlRrQnDwHqGse9D2c8jpumWe+GL8M2gEAdfrtXtBJ1unuPgdJS1R96lfX9dSDKru/OmN8iLBMe52ZdZUbyRKET4oqy3o+G197x0ZZOf3GMmd+2LsXn1Dz/MYF0jASueIC7E4EgwcHjUjmQEVBgdr4axXRLvh+bGF66bBhK76xQfXbLYfn3cYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 16:03, Kevin Brodsky wrote:
> Some of the mm_flags helpers are defined in <linux/mm_types.h>,
> while others are defined in <linux/mm.h>. We will soon need to call
> one of the latter helpers from mm_types.h.
> 
> Regroup all the helpers in mm_types.h to keep things simple.
> 
> Also remove #include's that were added specifically for these
> helpers in mm.h.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

