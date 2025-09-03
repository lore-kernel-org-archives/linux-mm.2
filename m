Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9B8DCA1012
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 19:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A9BB8E000B; Wed,  3 Sep 2025 15:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259F58E0001; Wed,  3 Sep 2025 15:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148A78E000B; Wed,  3 Sep 2025 15:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F2D9F8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:30:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95A245AAC9
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:30:23 +0000 (UTC)
X-FDA: 83848930326.20.63682CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id E68E14000E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:30:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oEswwnUF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756927822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwX9DrdQ5CKSd6pwYo4K3d4ooyYflVXlOjkUbRLGPL8=;
	b=UWvBRonanjrcTWQt47qmWikAL2+HoulkKubXo154S2HBCjG5XFdR58cSqQPGWaUrnt7A6G
	rn6T4da1U/KQxv86BJJyKqbxNJ0WJGRLq2BtwTe3C2blaAQ4ZWvdmJdiRn2kN/dJYtEpcS
	d1Hwg2DSWiSeLoKDH2PCZLMGeo/DZZQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oEswwnUF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756927822; a=rsa-sha256;
	cv=none;
	b=6CcUCZLuaCTe46hlY+Rqx9SkvEcPXvNa1XRB5AFUPDldYwH4aquD/DhDB1bQpfPCBTUruD
	pQSN9z4p5dSATbCCsGR1Qae7E4l8cnBTx3KCVEmEuE51o4af+5gsDQaOSazcslHvOWjGMm
	RzJgDD5q+h7fmv+XrROh101eTCclMes=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 834BA40BE2;
	Wed,  3 Sep 2025 19:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8947C4CEE7;
	Wed,  3 Sep 2025 19:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756927820;
	bh=gbiYfCYnwD77BhT/g17AX8EiRn/Z+Y0d8Hl4eh52DYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oEswwnUFyX6YzOK/z9N9LFcK6410onGyQhtt7HqMPuK+Bz5kIyDe1S134VWl3YnUs
	 lZyvI6AgrLghgDHiy98MMxoZ7WvyVFYkjxu4ggWww2iXWCZCPdO+Ia4TCZZyXyLm5D
	 UT5oVtvwFau4bDLQtWOz7WkB//w1DzoalLjz1HHEtmXWa3UJMx17L3ErzqCldiZIxH
	 FmdEuS2fDqllHE+JjRk/ZP9kPsJNHnxvQD2u17gru4gEjBt8mMxdpcpLAJZMg8+ot7
	 cItYGLq9Pi0pvmfdOGQ/cJvywzKibKRdUyepLU/iOzvdqBqn/6gndLRA0AWLDHJKG4
	 CiNh1699nhn3w==
Date: Wed, 3 Sep 2025 22:29:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Pratyush Yadav <pratyush@kernel.org>,
	jasonmiu@google.com, graf@amazon.com, changyuanl@google.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <aLiXNLiWNFuvh4_G@kernel.org>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250826162019.GD2130239@nvidia.com>
 <aLXIcUwt0HVzRpYW@kernel.org>
 <CA+CK2bC96fxHBb78DvNhyfdjsDfPCLY5J5cN8W0hUDt9KAPBJQ@mail.gmail.com>
 <mafs03496w0kk.fsf@kernel.org>
 <CA+CK2bAb6s=gUTCNjMrOqptZ3a_nj3teuVSZs86AvVymvaURQA@mail.gmail.com>
 <20250902113857.GB186519@nvidia.com>
 <CA+CK2bB-CaEdvzxt9=c1SZwXBfy-nE202Q2mfHL_2K7spjf8rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bB-CaEdvzxt9=c1SZwXBfy-nE202Q2mfHL_2K7spjf8rw@mail.gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E68E14000E
X-Stat-Signature: u4qz5s67io1amn4tgyub4upytit1jat1
X-Rspam-User: 
X-HE-Tag: 1756927821-890434
X-HE-Meta: U2FsdGVkX1+4QP9GO+Ue8aVmDgn/JjZBdi6RYjkMeI7jBIAP20pfRoWSMSxn4Di97eK6u+m93BP795ErEO8xlmP1/KgVS/j1yiK+Q3qNdMDLC0I1azNa7ysNcrGsOEEo/pOyMaFN2tlkvJSiIuTfAKJa8mupmJfQJkaS/vXU4LeiWunsitkraKQGPkmMNVcUIi75Roo1U9muEfFV81w43rGx9CiRKL1nqKhxZmYXXvnTV4fCfDfMercy4h0fhKD50JPynnuELqyFiM+p0nJAMHQ1rHuso8Vy8LbxPIPEKu/bUm7iD5YP5TqibRb0IuKvRyHqjL02+NLlaw6QiXMhqOck7KjQ53v0N3ARTyDYEd7Tflx8AOjWiXZH6XAHYrLqQTzxHwQ3QmQC0awBwT3AnNxckh8Fij+utXggbvENywyyBq7aQD4jOB5davMucOBstaNKAyxKjz2eoVmOnjAm06pchBDTIrCKixnWG0ZUCPoIlqGbVLpB+vUcYrJ1kEDwgEPwiAxHdEcTEs9ThMjYGA4PUtzPJwPCYa9ckArmmCKf4FjScbasNrKInKMVtCgaC6eCikp6oj7H4HHq8ywf6GlsPjBKVx46m5ZAbzaJHRFO1LG4Jm9nr+FV6OnCsEEGWk1B2a50CMYwmpZYSBYhj/dEJT8dAv+0FkDlEUsJ0EvmxAlm96qKl0+z5R9WdKntWe15/ypm0nUFat7s3w+KS/hJDv4/adSLOcBs3t/nNShY10qFe99mvOlX32dO3BjtwRXLB39H/vaD4XWC0pw24vddfb8OVuzkXiKIvLBAwT0kInCF/FNr+VbENsE9fmebw+xUZ1IrFr5ZpfiW6NzXTnTK/DyKg43zoMgdVG/6/zdz6MNKSgF+87BDGdo1qI23om0bQMtOWRc7ZVcPJRZPEDEpItAJUPdLFK0Jgde4GbZMObR8vBXcxMvnUCbdtdvu/6aeAoifxeZBTB7CRIq
 qhylofdj
 rNwoG1Yo4T80lkrHwuDn7ZILrwWkd4cqei0DiyY7BtiYGBSci9sVTFFziZ534MHLNP0kZe75P/hNO89Wprkq5d/z3iNvaR/FMNpzfA/x1e2uh4K7p5lfBqTZ5TOW/GsHPsIE9qfiYpovjPPrSevOG5w+t87K5j0LWxgBTV3Y4uZy79YBRp56oRSfVaDJQbBFScNrSWBnYNqFZl2nysdr0T9mEIpN1OXLd39ATpLj2V5ISSIoiartiFjYB/DKGyOh0dG934a7ajFrnM+9Y+QlhmHxAKacJ5oCvTmYqmVt4HUvIYt9mPuI5O99VkZ9uNF06hVc0kiVHtvn+VyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 03:59:40PM +0000, Pasha Tatashin wrote:
> > 
> > And again in real systems we expect memfd to be fully populated too.
> 
> I thought so too, but we already have a use case for slightly sparse
> memfd, unfortunately, that becomes *very* inefficient when fully
> populated.

Wait, regardless of how sparse memfd is, once you memfd_pin_folios() the
number of folios to preserve is known and the metadata to preserve is a
fully populated array.

-- 
Sincerely yours,
Mike.

