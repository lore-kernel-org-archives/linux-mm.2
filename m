Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E6F7606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AvgbDVYG
Received: by kanga.kvack.org (Postfix)
	id 53DC86B05BB; Tue, 10 Nov 2026 12:07:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515BC6B05BC; Tue, 10 Nov 2026 12:07:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42CCD6B05BD; Tue, 10 Nov 2026 12:07:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 164096B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:07:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B3E0A0A31
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:07:28 +0000 (UTC)
X-FDA: 85419840576.22.603534A
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id B19F740008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:07:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=AvgbDVYG;
	spf=pass (imf07.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794330446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNcC9m18UoMJxRcJEPoSUxoKZdU2fxVY/XU8PXnrjcA=;
	b=BbUv5HjcVRZwBZjk4Hx2zCnktb97kjxga2rhp0Xait9+6L7qT4hh1bIN974OXwWlCQu6Z0
	lbs1RFfUL/Ud8/axhXQYaPQJi39OpduuhuTsIldSrv7agyzzyjIlb25WEgw5MZ4TAs1Gkz
	6G3LpA5yD/EkuxJNoPA6yF34hXkOLtM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=AvgbDVYG;
	spf=pass (imf07.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794330446;
	b=Z790rSKVXfXzcZCeVKx8UXKuh9jXTLTYN2JmOvHFu2aC0brF2FT/8sFV3Ne39Af9tQHEGr
	Ltuz1qzAjEJqOISadpQMlr8B8GB+HbC+JNkhl/Lbp12wGSFKjTBY3Idjn1qn88fGqxfTgK
	5Z7gntLgkp7GEUIZNldj1Qe6J+0kMKQ=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cdab8873d9dso977706a12.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794330445; x=1794935245; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FNcC9m18UoMJxRcJEPoSUxoKZdU2fxVY/XU8PXnrjcA=;
        b=AvgbDVYGpKSAW4dTx6v+P28lUC/wWnRQttlmDvtYX9waHtSXgZNDIysmS0ns40XexR
         ay+55OYxpndcmdATvvX0IktnwSTnk82JM3p20fioAHX+PkzNFpwG9XCi94EGHQps3vi0
         1xILTslGZ+cv6DAjWGWozBeuAzmGH28rdIB+B4h8LvP1nsyBJ3JUsTOUh49qm2HWerO4
         DAhJIZlLjldYq/go7NbALyQ6I31kdcUPuVnuZactACIMbbDL3JpAuGEivtWyTMBXDedF
         P122lfVNzQCLVcmXVreksez4+lf9piajUpWuNLq3LjDggbshJ4Yhu+HIeUB0bpIFTF4T
         UFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794330445; x=1794935245;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FNcC9m18UoMJxRcJEPoSUxoKZdU2fxVY/XU8PXnrjcA=;
        b=XzKKEFesgPLH5bPEVkEe7/LvpCmXJAneg6MCJesyR0k7F2qKNviMVitayIKfquprH3
         J0AiXedvkUMB9NAjTTZt8KL+aucC+fZ39ddVowZi+v+Qldrifs4gOA56ECDKbB0bmiOT
         b0/Z+Z+F8njo4HHZ67CwWTwbl3NMNKvnqNKwJfvGSzfZNByiH+a5m74XZe5shEKQG+Qy
         NumHsXyQqJB03DODDARgfu4Rjwu6np0115KA5o6ukPETHsuyELLDABzFtyGxEdlqsRPR
         jQOq+uDigCnvYxhF6v8nIEXXmEFfMFzsxIl/tYqXwGtFRQ4W2039bW5GbCo3WwunpMHF
         F+Ww==
X-Forwarded-Encrypted: i=1; AL+hErHp3PyeNyGyX1ASKJhBsZfWU7cTPyU+q5j5qJkmepoGAXWA4NfTO4OjPFGaiz/EERjsPJOCNbrAmA==@kvack.org
X-Gm-Message-State: APuU4Z8rylsj4qwagtTJr+cE2AHKRqzuKPv64O5i99dwZHQiJVZsV/wZ
	6FShClBQpgDYgEMTg2MWNaVCSHd0gB8a4hkO3d3/kJboAFfA7GEJTO1TDhUSTfVYxQ==
X-Gm-Gg: AYBFou22XDsqz9AtSbrtxY7uFn5aKHsvPmTNlaB9FT/83e6F/SH6leBYdVLlqXtN/oq
	jh9lx0h14ILWhYAPUFhZBi3jpsEaei3oq4w7ZODbbcra2ShY+6swrucVXpZP1R1+IZI0FgQBoMG
	MnmPWLvDFDcAs+jGyqVobXZvZoL1ScoP7gb+Dnwlcz1xOsKRfLtOKAWdGVXEYGvnbN39K6jS30n
	iIK2ricZ3pop31WvF18Q2HjHsLVUlGkIDOA7k1vBsUBwUL/EkSbhGpNO6GgQnYXx5q4Xrni9Ajg
	ixMCTZ1Oh8mqypvP1WFC4wVGn/wQogow4Lcs89cHexP+dCqjxhQR+ip9ZI2lEExYAth9eGZGDff
	/UKuob5kttGQ3vFOakwzi3o4zQmXbwqb/0o+KDjzFk12lTulUwnMHd3aFokThRp990AehSxISD0
	LEdpEkjwnCNErfqB0G7IuAKjoo6iwSvRjV+p9h5bzyc5pmKAPJO2nwi3Od8SaHExWeksmA3DjpW
	guz//4wwfMWKQh8JheS16V6DCWBhZMnWgmeiYaZx0oqxYwOMVzK0U9QPnlWqNHdyh34izbihbUi
	eRNtAcxEWN6xmfcbWWBqCGFyqdcBsX6Zju9qwZePp51i5kTkJkz5u2PrzM+KGIJy
X-Received: by 2002:a17:90a:e7c1:b0:3a5:133:ca5f with SMTP id 98e67ed59e1d1-3b166cdb54amr3659496a91.46.1794330444574;
        Tue, 10 Nov 2026 09:07:24 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db56c7esm499973a91.8.2026.11.10.09.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 09:07:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 17:07:22 +0000
Message-Id: <DMRP21FATCC0.ARAURXWV85JP@google.com>
Cc: <kvmarm@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Pratyush Yadav"
 <pratyush@kernel.org>, <kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <skhawaja@google.com>, <sagis@google.com>, <linux-arch@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 08/19] kho: block: Add the feature header to blocks
From: "David Matlack" <dmatlack@google.com>
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>,
 <seanjc@google.com>, <jgg@nvidia.com>, <loganodell@google.com>,
 <arnd@arndb.de>, <dwmw2@infradead.org>, <baolu.lu@linux.intel.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, <oupton@kernel.org>, <alex@shazbot.org>,
 <gle.com@google.com>, <pbonzini@redhat.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <kevin.tian@intel.com>, <joro@8bytes.org>
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-9-tarunsahu@google.com>
In-Reply-To: <20261110050202.529473-9-tarunsahu@google.com>
X-Stat-Signature: 19gtymz8fiqx5yafbkkkkb33pj39urww
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B19F740008
X-HE-Tag: 1794330446-662188
X-HE-Meta: U2FsdGVkX1+qd3m3fatXTP6nh9TqG4HnDEjPPLIaP7s/IT27yiV2R9fAvsm9o0oCMMvGgHmAR2fOIdqEQ0uSoQc3OkUTVFqGpJFemn2xuJm+3K9YseYL5jnYR1FpTVKEXbLBw+DoQzjOLZQbGueEloTYftEQQ5B3SGkvC+BQtqAiSiuxaBAKxVFIgkdKe0vZqvRnYbrYjkQSQGBJK+OrdE3pkpkZuTpUZGWqg8gUBfWH0gvCz6jBxa1w/O6Z+ukUeCrPIUeyZ7587y5ngcWjETetkg9gDYbmL6+fnM4ohRZRDU9zrXLSp/aEKQsU8ElgkyFoAmCf+pDgE84XPYrfJ5FSuLMH5bDoLMYglusrbgOWjpZLPDJ0O5U6NVh+BYZI05UuhPLvIE2b3NZCjO7aBtYEx0hlTAknqbXRVfMbiNMeSbZfLX7TXX17/6xHNEUBoLz7EFEHohyVuQls4Z2LTljca552CX3zLAwSosw+pvqKBu97bfpX0BD2yrrgwxkO7fGPOwfLjJfmo0t8InyhxCs6VDybyzb7wAc6tnu+CvLAti2kzG5u/8a+zrrkz/PPl5OIizLMKOn3EV+B/LyfNNjKEl4ssMm2Fe6n64iadyxlc9Aq2qw7I0aqQ+ixvm7jP9rt/zHm0sHcPI5ZqG0zIlWsUq8EwhfEJT2KZ3ViXdNIuL6tc8/Y6QLRlmZOVC37iVVeuCph5wA694bcgr2HVFRQk+CRRMBa4j8fMR6lFw2yIqd3dVU370AiTd75SDgspDRKEmxSzVWAA6DWoLNTOw60oEAvNuiYAh9aT12n6qE4Rb5Et03/AynktGjwGv7aLZLVoRKY3RF1GmIKpZB9aE3znyd5YmBBeGjStUyy5KB7HfMmy5nIEwJXPbhyRlbNfLfpowtashTNVfNttd8I7QDWN5FgPqkc/2AO4J1e01vZjAgk79UMWHSlLHK2hP09iFLi8WnAJK8gn42FN+4
 OyJFYjaX
 u7raCc49IeFlP9qUSAGmL/xnKhkWSlizDqvMEz2zxdx1nPP82Hi/sZO9C3clSaB6I4hd+2nkeqewFSAZW8uJywnXe5U605gjGVXD2T+71yuNp8dv0gih5Dz6MZM3sxwW9Ebe9YW8Xu1uqhUFXPofiRHxcL2Hm6PseUnMvbqvlp/Ii0JZL5GMS4qdVDPgh9UNL8JO9jehW4BXTJbWgMFE+O9oNGfFisAgf05Fuz9B1ElADYyfVkvz8shMLY4RSuOIgtbJX9Nhu2gFsRfNmyb9LD5TfkNuJ8/9lKElQiztZorYd4uNSv2qbyBmgdJJkUBbBjY5YH8x98EWcjGJh4qZ0daWGcITsGFrqJon13d2hjBeeCGkE3lEteFkOATqKmHYG+gaPIBIaUGpB1iNO4oKcZ9hmyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 10, 2026 at 5:01 AM UTC, Tarun Sahu wrote:
> Precede struct kho_block_header_ser with struct kho_ser_hdr using
> DECLARE_KHO_SER. Each block in a block set starts with struct
> kho_ser_hdr followed by struct kho_block_header_ser. Serialized entries
> start immediately after the header payload at offset fhdr->size.

This adds a feature header to every block in the set, but the layout it
describes is a property of the whole set: all blocks are written by the
same kernel with the same header.

Blocks are only ever added and removed at the tail, so the head block
is stable for the lifetime of the set. I'd put a single set-wide
header in the first block only, e.g. a struct kho_block_set_ser with
its own feature header, and keep the per-block header to next and
count.

entry_size (added in patch 2) is another set-wide property that belongs
there. All blocks in a set have the same entry size, so recording it in
every block is redundant, and restore has to check that the copies
agree.

[...]

>  		entry_size =3D ser->entry_size;
>  		bs->entry_size =3D entry_size;
> -		capacity =3D (KHO_BLOCK_SIZE - sizeof(*ser)) / bs->entry_size;
> +		capacity =3D (KHO_BLOCK_SIZE - fhdr->size) / bs->entry_size;
>  		bs->count_per_block =3D capacity;

Nothing checks that the blocks agree. Each block's entries start at its
own fhdr->size, and count_per_block ends up being whatever the last
block implies. With a single set-wide header this can't happen.

