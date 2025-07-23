Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E70C83F34
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C86326B008A; Wed, 23 Jul 2025 04:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5DC96B0093; Wed, 23 Jul 2025 04:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CD86B0095; Wed, 23 Jul 2025 04:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A20D36B008A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:26:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 57BEC8062C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:26:48 +0000 (UTC)
X-FDA: 83694848496.06.76FE3C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B91E1C0003
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:26:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KgxqRpqv;
	spf=pass (imf21.hostedemail.com: domain of maz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=maz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753259206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1tt9yp1sAWQeXN6daT1C0pUrIG5Yal2NggGgMX3QrM=;
	b=k7eDZ6QVK7OtQNM/OC/RI40VNFTAA4f6fEqNx1PwW6Ifp7UTe/C2jQIvDy+Nt6aarTFdh/
	bjBGCtbx2DthWm/hBsCaDe/F+H7UFqlJGQeFCO7iGfVIiqZuGFxX8yzv70jYupEOJMJIEZ
	r9sp4maM+9hebvbvbEwxiamvCKkdupY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753259206; a=rsa-sha256;
	cv=none;
	b=eQ55/v23ha9VMVMopAQ4YjkFiKmoWXBWMnTz58UYG88CX1V/U3Ofrcvyb4ax1qNGGuAL7v
	bKjXnnlktJ7c+TmUgSxkf8KiOJ+IBK3VC/TigaEQ/hqxTQ0hLqXGKH0BE0woyPgJwaqoP2
	AdXv0QSczB/WeRNh7vwuNMIC7YGduF8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KgxqRpqv;
	spf=pass (imf21.hostedemail.com: domain of maz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=maz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A2A7C601D5;
	Wed, 23 Jul 2025 08:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47258C4CEE7;
	Wed, 23 Jul 2025 08:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753259205;
	bh=JLMV1LDmPmZFwVDJChckhpAPWnT8rA/zGH73/EfWR40=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KgxqRpqvnS9XMnEfExsx/b9BIdFFIXT0mgj5tZeBil26sOCmyigBk1hjuKRcMT6NJ
	 Nho0Fqu0mPadxYBYZTtEdgD5bN12bWlFC0G/LfFDKBXIrbSZAdXvGf1Hgx1U5B+wo1
	 7p4eRpiuN7E8N0TtwiyZXgNqsDxINXHoBaSaMXPbDowEHo2H3EbjDEuiU3vWVPuqE+
	 Npekzaz2lgUMsQwzu0Xs7lFV6OsKXpqMI8CHS67s5pu4RgYoW0hxT5HEquoLl+ua1+
	 ntK0b2+9duh3mwF3uRBl5OKFv3Pty8vbWJpg4mZNOaEU0sFI3Lf9IKPkYLjmrBr2OV
	 ULmlGb5coiOgw==
Received: from 82-132-236-66.dab.02.net ([82.132.236.66] helo=lobster-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ueUoE-000bpL-7x;
	Wed, 23 Jul 2025 09:26:42 +0100
Date: Wed, 23 Jul 2025 09:26:30 +0100
Message-ID: <87o6tbtirt.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org,
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
In-Reply-To: <20250717162731.446579-17-tabba@google.com>
References: <20250717162731.446579-1-tabba@google.com>
	<20250717162731.446579-17-tabba@google.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 82.132.236.66
X-SA-Exim-Rcpt-To: tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, qu
 ic_pderr
 in@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8B91E1C0003
X-Stat-Signature: skrryqu84a5to7h36mugncgg98r76xpk
X-Rspam-User: 
X-HE-Tag: 1753259206-465398
X-HE-Meta: U2FsdGVkX19jRfSv3fnjBfvUE91QH4IqgAko0GGNbDjGiT3/gbjXI9P6bzjV149ZZEw6Z5L/o8sufe/WqkaSrww/22I1eFjn9NJMmK7PqH4M1qLKIx1Zawg1i/zJuw+zejYNr0d+Tt5JCO+bZItvcuCAEYdZ4l01Al9dS0IOPOGTBMtAIOjekKn08V6uMuTHU7hJpSaVK1D/vG+OGCtI0B5MlmqGq6Ij7IqmiQwlSmVqgqbnYbhbzgxkAMW/CgCAfkIgo44GDv1+25tLxPUPmBsYldCJkbu1uZ69ljWEvTALCp1wggkXESyoeWvWtTmJRu5dvKQH2Fr/7lR7Bem4paOoGoCVLxq/L8gYz6YwV/j6OnieWs8hCK1ZNvnqy/yNqcGNEPgBfIh5BatRPJp7127IdQn4X/21VyXBolR8wPYLmbQFvWziI1ds/pjCfMvE6J4dx0zzvqF81uUxff+NrOpFUex6PHDltgAyZYGpUON7DGhsaqbA2LUXIKmVaKCIwfEz6J6kHbNBGZTavzP3Nl5IDFod/oFeBwyC0TJ1VXMtbuNPlB6hTHIJQeapEBBjmdrDtF48QSs55OCHPliDSfYKtAix19lTMjcjrvIz0FtU0JHosLhp/T7cjW/FFD2YRVfavARD02NbLxxs+SP9j9qm8K4fLsWInh8d7vuMLTvR1Dwy80pSjYEElSPJqG1tAtAzTDe04EYwPhsk77n46hKmWvhTIzIvxhgyMc/jKBnTPPhyXYIAaLFCK4+oVGA78CQOV0Ge4JPpLkcCFUtlFjpyWzy5m4Td7yvTdqgwkgT34CPYjJFszW+WOTiFf1zODKa1SWxed9B01vbHebKzFGiCgIE+5kVMD4NZ2LAsHrsilX1t9uHHNnVdYR6kVtNpQrbcCfja61Cu2rwmvcYoNM6TksII/svUCD7kowNPwqQceC3b/8tqamyu60y93941skGYkiV7gFji9ShpstJ
 HZps6tT4
 H5coLJPGhCZWnOs0KKITfLbD4MkuD6FrqCjUd4M07VpUdh7NXB6tcyLfoNz8/ZKDjduTsXmBrXjORPOxgU66LMBd2d15TdhoLaX4ErnKnKfiTwQ48EKFg9y3ay35xljqE27CC9a05Ria44zZTf07bPjcjAo9oLJiQAXosHJPTcCFoj2O15qgR9dfH/NsLdw+QLvzg92GQdelztMjsgtiIj7dcYmplhbQC5QSjvfy5cNkgpSkF2tXU1Gpj8ZSaSWQ9zpUVTgsfRQqpCqGzRaFa/+h6H5U++dUEipLCpRBa5cAvz94qZvEJLJOE/Jz3L5OnFkaOLMns3x+ce4OIbIQgTFF77Rtrwuvi5UkgpRWDj2iEC7NgfDnNJLVX3WHdQvvC6u7Rfp7+yaAtwniO8JBQz2Kivn+RhQol9A9j/vS7BLBLB2hSfVDB3JJkHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Jul 2025 17:27:26 +0100,
Fuad Tabba <tabba@google.com> wrote:
> 
> Add arm64 architecture support for handling guest page faults on memory
> slots backed by guest_memfd.
> 
> This change introduces a new function, gmem_abort(), which encapsulates
> the fault handling logic specific to guest_memfd-backed memory. The
> kvm_handle_guest_abort() entry point is updated to dispatch to
> gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
> determined by kvm_slot_has_gmem()).
> 
> Until guest_memfd gains support for huge pages, the fault granule for
> these memory regions is restricted to PAGE_SIZE.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Marc Zyngier <maz@kernel.org>

	M.

-- 
Jazz isn't dead. It just smells funny.

