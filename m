Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D82B7606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 15:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=P8I/kgxB
Received: by kanga.kvack.org (Postfix)
	id 06DBF6B0B8E; Fri, 23 Oct 2026 11:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045766B0B90; Fri, 23 Oct 2026 11:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78D86B0B91; Fri, 23 Oct 2026 11:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C801B6B0B8E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:12:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 679BA140122
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:12:43 +0000 (UTC)
X-FDA: 85354233006.03.0BB9FD4
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 78BB84000B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:12:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="P8I/kgxB";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=lrizzo@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792768361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTBZU2NYoxY52zS87kN5cvRsx8+DZYRk/wDlQGdD9fA=;
	b=Nj/+L+hqbvrhIRPEMQn7WK1JHmBHajzTZu315RnTLjrCGl7OUWrHs4DcBE2PO4pABttwOR
	HQ1t23Imy4V713Ziuwz1pDZmVO3ohAKsCOpIcYxradK8k/PUaj0rM4nehl+Z+3rqdtkj/1
	8BcgIEupMHNXQldze9cEz6aRf77Ss2E=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="P8I/kgxB";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=lrizzo@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792768361;
	b=P41MuNFWPK1BrNvDfV77+6ZJxPhPsHu0RbqzB2tD1VH3t90yWYRZhtbEKEbkAzCEIRnbxO
	kRSslS4r3nBESmDyGuwWlIH/9Cm1ZVskdmNpoMl7MutnGWUh8wBeBq2JHy5OvaEKCcMX6l
	P/Q/dl5CZ3RprEZ/aDlouP/LDrpZUpQ=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so61015ad.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:12:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792768360; cv=none;
        d=google.com; s=arc-20260327;
        b=OBeJnzdK/iQ/ctgKwTSdBeuERaVKWeT5ipyNmntz3dyhvGg8iMUT2i54T2eVynm9jq
         vl9xbjft5RRAMhZvS5zhtImgfs+KHbqzZK6LQeYTEytfEWQc5v/M/A2GzOTJbkq977RX
         gddKFMFxvM+KUb8l6W1ILtnxS3biOla3ihnoGl6MWyI3lmjNroCF+I3kSa8xiNd2Is2B
         0iwqhCN9KdEzibwsuuEwfSWPLV+en29o97wUmUNg4+FEfbS30V1EalLPtyrGmhN4B5jl
         aFcdJNhPvwenlTA05AFsq7D4DwgkpEbI5OYPzbeA4xNPohMkKd7iYsb0GPc4rZKe0rJV
         fCWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GTBZU2NYoxY52zS87kN5cvRsx8+DZYRk/wDlQGdD9fA=;
        fh=DVQDZWp/j34X+uVwBOLW9aNn1FQizq3wEG9rXWNHyfg=;
        b=Jgt+dvt7/eQb6szhSiaA4N7XxVZA7e9W3p4ea/iKnPId7NuBhoQeGlQp3lwYwQ92Bx
         FxhdRMpyZIlOnuVlaadqRYGhfqDtS8zJ8lH9WOhzylqBFIezbRKi39D//zk5TLSf+vlc
         pEEkAJ1tCy9QVWkzlKT3JgWWZmzcSNg2bzLSJZJIeBQVHnHOWEGPSDZso1oq2voNj5Z8
         N4H8cY8enQkWe/9O4ZLGV7qNuEbPpPO4p66Yl9UPRBaDJIibgUmMExP58LIKJlVOjFC2
         r+2T7uS1pmG3QoEL4KgDnmfLLPBup7Ek2/LQ4bMBDeZKVba1Avx0zA/c0kEJ18UsOfkg
         P7eA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792768360; x=1793373160; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GTBZU2NYoxY52zS87kN5cvRsx8+DZYRk/wDlQGdD9fA=;
        b=P8I/kgxBbw9dgT4Tyjvrqu3of+h/CDLXEl+kWy8yyl7WZ0pRBiiaMxxE0l4CLZoLiw
         GlHhGEeZwdFl3PPoO/sBgVjrpAARQX6Nl5yx4Bu8tREzN8izOShs/57UEZTDssPcqVw1
         VCQfyoMSasi3IT2gtvs0jEwYpDIyeyhhp/wZj6dHrmGjZBdWiXKZMwcL1s60Yww9KYx8
         OGNyaYq0xJfjtue/srY9bnL+8P9jkjNDwNboftQoauh3K+i9nQcvLcXmdsqLbCLQtfkE
         9e3iCy4+wvOTjx8BlnrAYGpKpIPXHetlVvYMBns6GT07m+/2+ku7OJ48jcnFpgMOlmeT
         cxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792768360; x=1793373160;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GTBZU2NYoxY52zS87kN5cvRsx8+DZYRk/wDlQGdD9fA=;
        b=XLKUUfQEgMch3jaeWJ404Mbg1VVmwe6hbkKzFwQA/srlzRZQ58kg+gmmWoFxtiy3LC
         quUrEEQYVPVnkyF6NKvrWzRA0DGwR212ilLkmPfkP6P4Fg7n3/2tO47r/9eTCLbrxkws
         gazzoFwMjJBfuw+0kiXsfhBVwurA29JegloidupysuJvyMOwmRgqsCvNsWIWOaP2GGgj
         IrMi7QGOpL7fNYCPP2sGUL6oVIX+8LwFFm1IOOQWAil3oN7UZzHQvtK5wpfT52tZdwBm
         DGytn5vH+M6fZoCjHuyqz1sKTdQAMU4F3jkT+TuHzviTupiyYKw/LmkBUWUAHacE7r3z
         Rbgg==
X-Forwarded-Encrypted: i=1; AKwUvBz+hWwxp+xnKTSwTbLbS7g7gPguJOalMG9ptN/0Cnref9RMcY8fLITTgEK3Zt/y5GGFKphrzb9+hQ==@kvack.org
X-Gm-Message-State: AFq9FYK6C32+969/bz2s9az1vzsyDa9Klc2QbmnVMSX/Aoh+7DV6eyPz
	LAohLVVfTw5u8DPZo+uzLkD2FBQEkdWG9iizqg9j0NoERnulY880yi+EIG836zRcmfX4Psyn+4E
	8/VS5G3UlFrZReV2wpnAO4BcwxLIM20OaDxVFBHkM
X-Gm-Gg: AYBFou3XFMtESWCTaGMuCGek2Nx6VVkMG3fWARSP5EpJC+ABs3yplTLKpH7NR2IaqRO
	FVuTSLxyhiQzOCUqBEs+Ls0wVvUEZZ6nGDP3yUzw4gJHJHf3GuGYcJLau8HwEj77eDJdUdphdcF
	QPV35PHS2tlXp4vFhY6JQTxuil7v0AtrXjFVaytQb17X2M3l/UudE97lafWeXjQ8HD7mMJHXTAa
	l4XOwZfq1knJzFqmnQeedW0odFWnbrfwaFqABD07pn/k3F/geVBQ9ZaPE1t+NzNOkiRttprZG7U
	skO4zptLKfQ2kjAIYKMXBz628ol8jxy0wSVVU4sfr4aIpZY/oXmEtSiY6Mdo0SHpqChe+pIVZT5
	YKpXcdOtB4ACRhcJRhYJ3IPev8Twh5ijD4qaMhQ==
X-Received: by 2002:a17:902:e84f:b0:2d0:1aaf:daec with SMTP id
 d9443c01a7336-2ea7f4e1cbemr4092325ad.9.1792768358959; Fri, 23 Oct 2026
 08:12:38 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com> <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
 <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org> <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
 <20261022201229.GH3381610@ziepe.ca> <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
 <20261023140107.GC3977851@ziepe.ca> <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
 <20261023145023.GH3977851@ziepe.ca>
In-Reply-To: <20261023145023.GH3977851@ziepe.ca>
From: Luigi Rizzo <lrizzo@google.com>
Date: Fri, 23 Oct 2026 17:12:02 +0200
X-Gm-Features: AclHuK9W5A7aXTPFZUdD2jRhpUmEtp7k-vVQ254ZWcJE4ItfG1TCZYdvtBT8nSc
Message-ID: <CAMOZA0JfsviAkojjEewehxMq0r0AboS=L6AWafMj4_Azaeg-ww@mail.gmail.com>
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 78BB84000B
X-Rspam-User: 
X-Stat-Signature: 5q4k6iszeoqm7t7u9exfgyznrgsr1uiw
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792768361-860943
X-HE-Meta: U2FsdGVkX18+PdWfYjiHqpAjmn8GN2Kxp/YUq3RjD7qoMj4I6b2sKHDxw8fVvW0VUg7ZhRklIMBJVkBkXdH9PEbFw43gmgCYuSGLX1hE/wtTMY2bUpj8F5cXv9sXcmO8Xnse4vzZlOB8LiPYc8bnH1aUgL1VtDZjKVS1fRROW/1y3aTC8GiwE5hfp0n0MqMoIcnZ0MT79XxGYmSgIm6PMDySaIH8W7NjaLg15lsSm8XkUpH/lx8V95C/cAq9uGZSFztiaJcMfY6Xk7QwR38+6Au44IQUyrZIx4RuOJoXiXUrDX1uuosvV/R6FqRZ2fG13u2HRAqfS4it6TRneqE9c9ciGx3ttjRYPGRwWpNweAL9AchkTnq7nuBslnE6lk4MNWkIkADJMTKHehXCcQwy9LNo9YBWLIahdsszJPngtkBWydNJ3kgKtrYodj0ZFpO24cMtshAtzGJeTqD43RexyZR5rojkpt4f9XuTPwfCya0FHOTqgankZix4G6xP4pPeHNAf4s2xKjYujEIq7K0oM5D57uosHfVf5iMjC9fayoAgRFKTR2S5ZTOcnT0RLw8Ze0Tstm5t1rsXgcXqjio45in/QUdw6K3ymLOL9f+ZyAnuI4KNmH33cJZUbnAm/UMWkgvi8aCsuxc3pV4yaaL/pG0SAlaZTdxQMEUcxwfa35BedJKqFpEUk8R9eA4/epCOaKjeBT/uarm6XQnWoiZUiV703dVeztQpu1o8bskbV4NJeBzzdMUmgEqKY/pR4AmQtr+u8iYpQ1k1aX1dZGNDKM5qePhjH9EQM8dH295dVpl/MijZb9N+dLi4Lih19DrUqfIFzEylgBv8EAQGBLZSIFHSKeTY03GT9Adsy1MtfHtdFaaPi/QuExiIJwbE2/ccjL2gJ5yh5oKRgetJYvWfbq60XHPHNLNvshkioIK0TrLydgs3Zc6O+qCjtvqSs5HnFr3XIUkmYRXHuFaaIiS
 c0lR37Yr
 JmnGxgM0Mo2gYlFnhrfzNGhwCZsVK7CC++56nywc/KmeDY21bl54JTvYyWEdixH3ZZf5WdEUgXqL7nwSccerIOb5ZKf/+zKNCBjWHKhFsaPley5c5KrWdo1gxrJwYTVbXjt/3VmB9hTlIPY5wvNAundfTfcrM/cJGRGoLmuea9CneE8ouz9ghOY1h+j6fibZKqGs8bDsuykWE8Xhr8JiRcmURh66kvsgfcOMNYFGQKeBNjuynqduYLgxAU8+rJeVbotyKOBIZ6Xc7LbPYuuT9JLYV+u9u28408LqqqOAV8AvzlWuRXKJ+3HOxqEi/y5ysXkANgOC48VQOFZ0nLHmRexgtu0V2hATk4qPfwc0eDQcmcQjzrWw3Yxi53RR3F7uqFTp7ZEe4JTDk5shYAFfuq5QC8CnONqPNJd/STj6QmiFBkMw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 4:50=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Fri, Oct 23, 2026 at 04:30:25PM +0200, Luigi Rizzo wrote:

Just addressing the last part:

> ...The CC stuff seems
> actively dangerous. Unconditionally always using CC shared memory for
> skbs is completely security wrong. What I have traffic flowing inside
> my VM between containers or something? Does this end up putting those
> skbs in shared memory even if they never hit a physical NIC?  Same
> with a TDISP capable NIC, does this unconditionally degrade its
> security?

the current series was RFC and "unconditional"  just to show the concept.

My next version (a trivial change, really) is fully opt-in on a
per-device and per direction basis.

The unencrypted (or pre-mapped) buffers will only be used for traffic
that hits a device that opted in, and only for the directions that were
opted in. So we can finely tune the configuration based on hw capabilities,
threat model and performance requirements.

cheers
luigi

