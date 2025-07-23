Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E8DC83F25
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5016B8E0003; Wed, 23 Jul 2025 04:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8F08E0001; Wed, 23 Jul 2025 04:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C86D8E0003; Wed, 23 Jul 2025 04:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 270A48E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:20:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9CA8B14032B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:20:55 +0000 (UTC)
X-FDA: 83694833670.04.A7FCC63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id CDB9540006
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:20:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IMvdhjIV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of maz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=maz@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753258853; a=rsa-sha256;
	cv=none;
	b=aW/KaRrjbTfF3/sBU1ruI1W8nTyEMmrfFU9b6Ag+SvUhhTMJbKncQRRXj7m1uPxnPzq7sb
	sA4uq27cfQr8obodZg5EjcYgojCz5pVgzTFfLL1JgNtmNgSALQGTl/h5N0PWHuO6plawIQ
	EDuJ7sbrUv7HbXJqXS88uMwCVnQSlWk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IMvdhjIV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of maz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=maz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753258853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdHdt7Tkho0Ngkk9L+84Fwz094zwwdlyHg+fkPrGPts=;
	b=jQCMcFPYQdEaxKRe1Ck/cnv6SqWXjUyOa52Fp3LGQgcjVQsb3yrqL41QBtmT+JyPF46iz0
	pFq0g/xuGXBOACpRJcYqW2x3uZ+EMpSXf27UfM7p5gAR6b3jXPNzXfENi96n4NyYPfK3dg
	DkGKLUzv6Pbai5UVgRGqY83B4hSGte4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C79F0601D7;
	Wed, 23 Jul 2025 08:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68972C4CEE7;
	Wed, 23 Jul 2025 08:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753258852;
	bh=Xsw3QoZiMPB8j16P6Zigy/0n3Pl6zL7Tf5S+EO6pdSc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IMvdhjIVoTWOkOkifH69KUZdMExh3V0toaYm4XhvU5rQbUnqJ2W4/K9ljJhPpvAsJ
	 vBFe7YZ7c6P90+WqFyAIQ35nBaxBfCMVfRbvZKe0RXzK4Pg8puy92WGPjZw1q2nHM4
	 9p75I7HG1gZbDDrJGAwzy3lkgZcX5A9aPQ+yzory8QnE3mx4OJnwYOzkIbYUUjCxG9
	 nABfhefve/uAggH7xD+fSFwbUUt3jyv6kbu13WY6dI/T2xfzpEiNCkAck5WNIWDK7t
	 Ka4dWmv1gbJ5l/O0T8xz0hWbbZ5+BUREZl3UkbF1mM0CemYFKhUhQqrSQPcjIdoSln
	 rlQCXtwYFzblw==
Received: from 82-132-236-66.dab.02.net ([82.132.236.66] helo=lobster-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ueUiX-000bju-0K;
	Wed, 23 Jul 2025 09:20:49 +0100
Date: Wed, 23 Jul 2025 09:20:35 +0100
Message-ID: <87pldrtj1o.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Kunwu Chan <kunwu.chan@linux.dev>
Cc: Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	pbonzini@redhat.com,
	chenhuacai@kernel.org,
	mpe@ellerman.id.au,
	anup@brainfault.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	seanjc@google.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	xiaoyao.li@intel.com,
	yilun.xu@intel.com,
	chao.p.peng@linux.intel.com,
	jarkko@kernel.org,
	amoorthy@google.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	mic@digikod.net,
	vbabka@suse.cz,
	vannapurve@google.com,
	ackerleytng@google.com,
	mail@maciej.szmigiero.name,
	david@redhat.com,
	michael.roth@amd.com,
	wei.w.wang@intel.com,
	liam.merwick@oracle.com,
	isaku.yamahata@gmail.com,
	kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com,
	steven.price@arm.com,
	quic_eberman@quicinc.com,
	quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	yuzenghui@huawei.com,
	oliver.upton@linux.dev,
	will@kernel.org,
	qperret@google.com,
	keirf@google.com,
	roypat@amazon.co.uk,
	shuah@kernel.org,
	hch@infradead.org,
	jgg@nvidia.com,
	rientjes@google.com,
	jhubbard@nvidia.com,
	fvdl@google.com,
	hughd@google.com,
	jthoughton@google.com,
	peterx@redhat.com,
	pankaj.gupta@amd.com,
	ira.weiny@intel.com
Subject: Re: [PATCH v15 16/21] KVM: arm64: Handle guest_memfd-backed guest page faults
In-Reply-To: <07976427-e5a4-4ca4-93e9-a428a962b0b2@linux.dev>
References: <20250717162731.446579-1-tabba@google.com>
	<20250717162731.446579-17-tabba@google.com>
	<07976427-e5a4-4ca4-93e9-a428a962b0b2@linux.dev>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-SA-Exim-Connect-IP: 82.132.236.66
X-SA-Exim-Rcpt-To: kunwu.chan@linux.dev, tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cv
 anscha@q
 uicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CDB9540006
X-Stat-Signature: 8pysgjy1ewdtstxf4x36u6tyetier9be
X-Rspam-User: 
X-HE-Tag: 1753258853-265730
X-HE-Meta: U2FsdGVkX1+9/OArOSv5OG7PLaKu+5rPA8uk2z+0+B1e7QEvHY/cZs2pgakNydERim8QoYZBV4RQhasud/6etKdM7+cn5CZ3qSjsHkohDi4vhG6uzrPhJKxDaA30s0M+0jDMSJOxuclWyuY/rbgaWl/lhsd2sScu9z7abcTrKXSqwQRSBWq3wbySDuLVEMs1TvcUxll0mzGuqa/LRNjYE3D6XR95Mmhvb1aDtGUJQimww3WGUm5P1vlmH73SeuYCu3MiqyZ/2K5R9EOP/RSC91vbaZ2tFcpsY5Hw27Etb9kbKLSEzN/UZ/dbbvQfpwRNL4RssozsV/ew+dkVGdGP3UF9OjIF+Heoz3J0WYu2P4kodx1YvAohj6awl8Y3wHmjVTwJ6uLVbnT7iGcN9lOluA4nlcFtsZAJkQ+nzP5Q9Be45SrFJ2muEWcgEuBMMmD/pPXHkUQkVEGddXaolylS4oPsrLf3Dzfg/B8951zrSZAq+0rbSv+QYY1DvXrYrfgnNDZBXXg63EYtLbdKwxFkn/jPHu2RUbRfpCNdhhj36xHfCNTvdTsruzfp9zIyJB2eyWiByjUYUQD7mDtvrYI1eynIcFipbyFlESk6SaM9A2f2N/bb/LCOCyDnfLfPsW3Q0MtXJivi7lBoR7pWPZ2nY3YhTUjO3D7qEMoramkvpPIuLpzo6jXnP91SpgRE8ISm/Vtty40jF3fLP4Thl/PjU9t/3bXBy+pnv20uplxwxBiFzPstNqKdZzmBhtT1mk1zLaqaqotzOlDiwohFgbwiwsILbNp/MPbdBXrlLiM1s3y2jHrWoq6Wq76GnJxbvgjGwKr2c20AXSAryTPA+d3MyCulHa4obccFJ73NY3UGRG36TqkrjnBBzoQhRCbS2psElgMkbVgwQUU93xKhNxxP0pa1kG8tkEo5K3mT33LWmD2SLXQGE/K7EO3cx2pX5WLsoEXYpEgSvG42EyNFKVy
 ouK6x09E
 X9rp0uEhDbJDtCfJX2rlUXztErgLCOqusyJSyiFQQt/ig4dJetY6IU0HmKV2wBfHL8n3h3pr/8d8kE1osifBt3h+tuHQJY/yg8PLuMQ7y9KfJaFq7y5vgMfuiyt8W0T0aqA07iWY6X1wm++N7iox4z0ueSeKte+Sy1xJBY4vuA/H9ixchD0rPDUST58sVHPUOviBl1xsQnjB9xVhfLAvmqvI+4k9jFjN3St2xGo4YyocfqFXpKGo7LjZE1iDFDPY0P6ni/BjT2R8PSxqKu0M+Ry8JZ9cNZsUDzKW2fyZl+Jcj4s1V04Owk4Z8Aeyq/x1XpAKI5Qhn7Nj9XgEdANDtUWM/bQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 13:31:34 +0100,
Kunwu Chan <kunwu.chan@linux.dev> wrote:
>=20
> On 2025/7/18 00:27, Fuad Tabba wrote:
> > Add arm64 architecture support for handling guest page faults on memory
> > slots backed by guest_memfd.
> >=20
> > This change introduces a new function, gmem_abort(), which encapsulates
> > the fault handling logic specific to guest_memfd-backed memory. The
> > kvm_handle_guest_abort() entry point is updated to dispatch to
> > gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
> > determined by kvm_slot_has_gmem()).
> >=20
> > Until guest_memfd gains support for huge pages, the fault granule for
> > these memory regions is restricted to PAGE_SIZE.
>=20
> Since huge pages are not currently supported, would it be more
> friendly to define=C2=A0 sth like
>=20
> "#define GMEM_PAGE_GRANULE PAGE_SIZE" at the top (rather than
> hardcoding PAGE_SIZE)
>=20
> =C2=A0and make it easier to switch to huge page support later?

No. PAGE_SIZE always has to be the fallback, no matter what. When (and
if) larger mappings get supported, there will be extra code for that
purpose, not just flipping a definition.

Thanks,

	M.

--=20
Jazz isn't dead. It just smells funny.

