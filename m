Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E17C83F25
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A896B0096; Wed, 23 Jul 2025 04:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362746B0098; Wed, 23 Jul 2025 04:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2784E6B0099; Wed, 23 Jul 2025 04:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 160686B0096
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:29:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2B1AC05D3
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:29:28 +0000 (UTC)
X-FDA: 83694855216.18.0DAA35F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E674EC0005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:29:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U+NEuPjY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of maz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=maz@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753259366; a=rsa-sha256;
	cv=none;
	b=S/I4Fp8hPS6e4fxDcLhPuBlDiVxjWo8lmx+9AbjJsSFtZ0k/rlCjXErEnWv1Oe1h8U5AQU
	Gs6Jbq+ixwiAz+G2IDyUm3zY2aUSk6y4l2SvQbiIPsy9MYQXwfpZoOseOnrsiBNzl52V7l
	1i+wxivsq4UR0JVv8L+GJYFCOQ/xqBQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U+NEuPjY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of maz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=maz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753259366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xp3aRzVN3oPWZc4jXMJoXAT70b7hbTMb87NX+LIvjYA=;
	b=ZLFOuNzbIX46LL98cyE9KwdraxDaHOYIuMYm9HIYDI6Yt8YZucltdci0eLLXo0eWUeTFYI
	98AbuWWLvibHnxlBBOp/ws1u/6IGZACOy6Q+xMNni66mgn0nNXrvd2ocXfo0hddzBGIuqy
	yIVxibG4DfdqX4FCwsCiVvF2ZElkDMY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B3FC601D5;
	Wed, 23 Jul 2025 08:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4194C4CEE7;
	Wed, 23 Jul 2025 08:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753259365;
	bh=yZzDzspz/hbs+ZI2bARhhg1NrwdEQ/R1WgItfyvWZ64=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=U+NEuPjYVaMphb588UKQdnFGh8jYQIaGAFO5RSZHHS2uTzxjbffJ0wV4RvByDdefU
	 /yAbktW7knDpaELNN+dmSB3mYqfeH46gUiJQvPoUWU1sRxnpQEcNRc5SovTJQpGxx0
	 MX5wycFo6RF4QbJ6mD/LrV9SeGtSHRPRI/ZrUiIsxHcf3ofChhVSa5fb/YtRPuuVz4
	 /NhVhbIKE79+8AeB5pLHK98D1jqVlLWG4xV/X3wBGY4Z2dgXyioYf3DdxMkfhIiKCh
	 Tdm2s0Mn57hQU+44blC2fsrBL65MJMZlNp9/6m39D/5Bdr7xxK0cFMKlj06FkNGjb6
	 IintvPIq5gWUg==
Received: from 82-132-236-66.dab.02.net ([82.132.236.66] helo=lobster-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ueUqp-000bs6-Dx;
	Wed, 23 Jul 2025 09:29:23 +0100
Date: Wed, 23 Jul 2025 09:29:17 +0100
Message-ID: <87ms8vtin6.wl-maz@kernel.org>
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
Subject: Re: [PATCH v15 17/21] KVM: arm64: nv: Handle VNCR_EL2-triggered faults backed by guest_memfd
In-Reply-To: <20250717162731.446579-18-tabba@google.com>
References: <20250717162731.446579-1-tabba@google.com>
	<20250717162731.446579-18-tabba@google.com>
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
X-Stat-Signature: 6mq8o7oh88jygcc4ean5h4npe7rtpzem
X-Rspam-User: 
X-Rspamd-Queue-Id: E674EC0005
X-Rspamd-Server: rspam02
X-HE-Tag: 1753259366-792949
X-HE-Meta: U2FsdGVkX19dcUzWHKiLteJA+zGrBt9kKcxsRKwmO3Uhup0n+pjfhHAlxhvycx8uLMoA1qolxICfqADsQEuE3xZoE87CUw71fuz+/kSDRYQUSTN/u1viq1ynKGh9Zb+qrn+Ll5x3A40Jh9ddrY0ct3UWgvj5j6fm1evAReRKqKWkrebYHNgXxDZ04Cahbo1BIdepai217wW8h2vR4EVTV0FAlxoCDyJ85D8vrdinHU/k8AEUyLi0+3exzK5PVmTaczbiZu3aIC1tcMtXy5i4ii7MyAVfxQehVXXeOB+NlD0xXTGAZE4KNf50ftVBFP4jjemLQyJPWpL7gi3rE4bLkj+IJ4jJoLjT2DGsi6PWJnHUJpgBbmrrI8RI8Y/erIMVChL2CcNMGimwXngp/X78w/+/JvBC1JEWcxcrMOKvlrSJN6A3k2OGEU5vTp5qi6FFjCOpcHhlos3dob2tOVAsF8nz5mCa3c69QGNRi92QdWB1oR5w6eFNqhri8qtb+RCrgbcfypq+M3uUpB5IRNixlNSnEzJxztp+tAbW0JYx/ZbB9vJhL7oNmLN9vg6naah9gVgDdHYdpL0x76yQL9jtXnNdDgTCHT3bVeiGarfRX5CDB2pOThQQnRIpw2K+aypiaUkeHe8so9yTMTd+Ha2CrUptZm56m0zrWkcJiVsNuOF5lXs6UR4sAwr3Dn4J6QcpClx4n4OptNxfb2jLcatxdzZXAnES2KaliyMAa2DD6wosB/cWIHk08azYVoeVfyzNzpwQrdPPqGlSDfSpgXwJhdIZSDIei/3RceLVNDB5WI8ih58lWwpHFEoqRStftj39xvIrIrdnR/vyYw2YroKLMBl5VodjOLYckpGVYBqfoXp5xjIwun3cHdezBu1xTX6W6n3psFpBnGSAA/MhrB6ZGhOiKSvUKomm4ODAsdnVcMo1RvLOpIgv1IYVQL4DPc5+SUwR1qJh2hPgSSRvooR
 LZs/8BOf
 /YNnRuFYyCokhiSdEDPYuqUYdHbDEWsj3JnlCIMlRdWSm+YZYz1QCEaY4njYxmEtX3AFTy6IuS6an1bvujS0i3s3c3eK7aWeAnycen2xemWx2pizCHTpL8/AmB8PC/aU8mFdqNCDsUTBXu14mjHYblF+VuQrliPQtIyS7J3E++c27iPhIc9o3OoySpbb3YvjyYOJRsum+miWLGQU7w3ctDr2DNwenm5bwwH8FTX9/EAnWiK0cYdebJLRi1eNK1SBu0mLvK9Ly1r1YVoUMfHc09qXFNiaQudZ3wdu9qhra2eO91/uU/3g9nL61vTFLq16AxuBglpQ39ZfOSLZIzLalDaYUJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Jul 2025 17:27:27 +0100,
Fuad Tabba <tabba@google.com> wrote:
> 
> Handle faults for memslots backed by guest_memfd in arm64 nested
> virtualization triggerred by VNCR_EL2.
> 
> * Introduce is_gmem output parameter to kvm_translate_vncr(), indicating
>   whether the faulted memory slot is backed by guest_memfd.
> 
> * Dispatch faults backed by guest_memfd to kvm_gmem_get_pfn().
> 
> * Update kvm_handle_vncr_abort() to handle potential guest_memfd errors.
>   Some of the guest_memfd errors need to be handled by userspace,
>   instead of attempting to (implicitly) retry by returning to the guest.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Marc Zyngier <maz@kernel.org>

	M.

-- 
Jazz isn't dead. It just smells funny.

