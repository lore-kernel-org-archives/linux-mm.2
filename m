Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D6A606A335
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 16:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FpPY/s2D
Received: by kanga.kvack.org (Postfix)
	id 7C3546B05B2; Fri, 13 Nov 2026 11:48:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773E96B05B3; Fri, 13 Nov 2026 11:48:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B12F6B05B4; Fri, 13 Nov 2026 11:48:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E87C6B05B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:48:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9F798023E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:48:38 +0000 (UTC)
X-FDA: 85430679516.12.4529B34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1CF6140002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:48:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FpPY/s2D";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794588517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRTBPN00ennq6rQlp8MX60novBA/nnmfG2AteR92IcA=;
	b=fHfn+sF85WbYOekYuLU9jXhYqmBaygdznZBddP7R6XUgD275EL/AfKlKt396baQpuIlKpf
	2P4xz+KDaeXV633oNWzOWL7EOvjLXzfpUS//l01HL6Irn1Bb8BJmHx5y2gF9GSAE5gxKD7
	lnO/Gm5M+kl/hgQCRlYBusto7/XsN/Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794588517;
	b=Tr3OdnOxoZ0ecDs9BlaZEpqUonL0kkCUY2Zn6e08ipMy/7GAwrKupfWjKZqLgNJ2ClKiWm
	VVF7lWO5U7jmaVaixGwx3XyQ1kDOermYSf9m+WwelaklhbWx6iwm981Ov0SADooKLhS7Zg
	14x+txyBDuCVaOBMFMuLAK+Owhv1fZ8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FpPY/s2D";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C87344F22;
	Fri, 13 Nov 2026 16:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506491F000C4;
	Fri, 13 Nov 2026 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794588516;
	bh=zRTBPN00ennq6rQlp8MX60novBA/nnmfG2AteR92IcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FpPY/s2D3NbqEstY5RVQR88cqhbB1vi+TrBmf6gt9yQBvjdk1kdX79Xvl1+XZoNgP
	 We8ZE0Scqz1J5e+jRmeKHd3r9MyH+wzZG/gf2VfX3MB9h99FuPix6eQ5589EViffCx
	 Ubwndg+aZ0bBd/lYy8Hpxi0z/5Rg9cxEOYbYm5mAJMPPl2mf8NrxLFc8j9EyIIg8uy
	 bCSOUs8nVCF2N5Lh8JuH1JR8ntxIDG3lclrkhg3V3yQ6f+zQwZrU0+F5eocjc+t8uP
	 1kE9T4HbUn+FaMOe4+VmcSc/IW245EUQlUGUnqqIlCjKemThH6osIgFUKWmL1dFMit
	 F4tDoKQU8woiA==
Date: Fri, 13 Nov 2026 16:48:26 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Eliav Farber <farbere@amazon.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	William Kucharski <william.kucharski@linux.dev>, Vishal Moola <vishal.moola@gmail.com>, 
	Alex Williamson <alex@shazbot.org>, Matthew Wilcox <willy@infradead.org>, 
	Peter Xu <peterx@redhat.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm: fixes for huge PFN mappings
Message-ID: <avc-GTPIpOZVzwvX@gremlin>
References: <20261112051440.16140-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112051440.16140-1-farbere@amazon.com>
X-Stat-Signature: a78h9ban6tzi5gjokbsn71upghkaapst
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1CF6140002
X-HE-Tag: 1794588516-122558
X-HE-Meta: U2FsdGVkX18scOvIZrQnmceKnS0qbfsvG7B/+OS/O1ubzxnn4tpO4ljwwG/IeUy6Sk7rwSOhptKkckkLYLyAGIqir0hJ5zZ7OJOdLeoH4v7IbJFpHPd0qzKOZI2uUJUuyunlJ00acs/k9RxUQJL8Wsm/mLYHOgOKu+7SQ0Wj80tqvhpOkbXzEQscUrsl47X8KwnFfRJqVTjnd3nP1WvDSiwk+vWNa547KTWCjVrWlfXhsfSNe8Zry82jWtvXHifc3AtK8la0zyE/G3tTnXZEEB3x21dT6F3d7CH9LyV9IoTA4IvWitEsR6NrFz1aK0MX3K3GfXqTG5+CL72wmX6Dt47q0CwhbqRbOC2pCP9uQwvu5+fg+mf+qZ6nAFGSjvbzNaSmaI6Qo+aqkFUdJk7qwLYAObYNCmzBA9hDu+kKvFRv+hKTke+SywSM4Jlj6ZE6wptyIwdZ0owT2UFE+vD78KQNQkuR8N01vKUgZ8tVMIek9yQiw4UTGdxR2g/EJ5SWpYDeaypSPl41rAOUj7tLw6qEeZmKWYe65vBnTerZ9Y2Q7OXmNnTGKq0CBLrGuLeR/+GFzxGGAuGSZ/WabALmdGvgq698IQVqAZCyXgxyEsWa4PE8VFpQzBu0pK7j7mBpkAroVzfV0K7BXohR27bK/79SVxcMG5yAB/AwX0ElNpdno3E5nvfa92J1xwom3NsyqvHhr+4ibadpw+8araVCxd9qsOinwWU4m8iuo+tZkV5qVUvXLrxyVFVNg35S8PBuLsrTWrYfk7b4Nxr2pGuZW4ULBobzcUyqxEQbykfSasV+gyBgNx73fJcW32EDUTVGygqQmZaEqN6zSDd2U/y/bn9EIBt09eyfZzDUd4KppiZ6tcwwGsPYaWdm8zthUG89PBkSx8IuBOBAgVZ8hDho36ErXZMkC0ciEK5Eo9QYcvtEqsap9gett6XXLL9e1pAeRCg4vOmRFseNTFePMqS
 R0U1KN4A
 Vx9CsyOn9JZOig4PxhSyF5hNJ2Vsn3HbEL8Sr9gnppaQCxKLaKSy3ZC7gfrkUhQnMSDm2XO5r85WwJJrvduowqamreccFeQm5l55FNeeKQo7tux0ODNMrzQZa43ifgiJ0WHn1ngI2UTk2L9YcdoGYjtk7DMsjhfcvOHisPMJ+/Mndid1EXx3p/qPe+TIe0wRvtJy+D6oWskwb0RIN5kM2H6eqGCpesR/HSL51EUT4+0PxJr71xbgrbCxgsgKHP3p3SfOAHUMqNVeScSXYm7ZWGSEgJsEdebjZ24ykL/BdYuSzFebjYEPjoGZ49qPrGkrrd732rwbIuH3QAJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Eliav,

Thanks for the report.

As discussed inline, I'm not confident that you have a deep enough
understanding of the relevant code, so I will take over the series.

--
Cheers, Lorenzo

