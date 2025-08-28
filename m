Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB75FCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010EC8E0003; Thu, 28 Aug 2025 03:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2AB68E0001; Thu, 28 Aug 2025 03:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40488E0003; Thu, 28 Aug 2025 03:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D17FF8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:14:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C4A31389F5
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:14:43 +0000 (UTC)
X-FDA: 83825303646.21.05BD148
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6399D120017
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:14:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GIzhXS8P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756365281; a=rsa-sha256;
	cv=none;
	b=i6rCtsEYgyW3OlYnfexBQDn/49NAeeh7uGwxdslOAR799HuDhOsF0/7gctR4f5NC3OSmGw
	0S8xLJ2IXJvx1sQ0drPxE3B4LtPXsst4WmU9P6XdSk1RMgyOdKl4IO90IsazL51FOHT+Hn
	+Vcyd8pZKEBJ3F2tt0etPmCVYVFBhyg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GIzhXS8P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756365281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZgqJ9L5N8worhqIqqjXZLxcoaxzXMD11v4lBBZZ+WA=;
	b=ixBsc4Q0W+U+xRD3fDkN3j1jl3LB79eWd62eZ8GAt/3yMOOtE9QHtLZ/G4k/IbNRkJ6WGn
	eVJRmHuvKbwpB1whJPf+wM4u75SnQCEsaxla4vhby2F1rmNcgmDt+EJVMIkfxtJ/ZwiJbD
	ipMkE0GW0cY2y/M/zx4qY+P5wUsO3bE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E82A440276;
	Thu, 28 Aug 2025 07:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CFEC4CEED;
	Thu, 28 Aug 2025 07:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756365279;
	bh=u7MU8S7IUKFLA+3rSi4qDipSi5TbBda36l1aewE2udM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GIzhXS8PSnxYCSsCp5sOq9LQVBuQ368mCesgVvzDRbMdYsHsF986cg37wXBeCyBMt
	 +9JcuR+1Z6xLXbpb50R0WlQlVSU630yE+rXFA13Rz/ar7HDUsG+SQqVQ/qPuaU9PSc
	 st0CQpt/2vSNT+yhe5uzUC96g26FsCxSN3bQiUqxds342dEEdlsQZSDrKvMBsCjaJA
	 XbinE3bU++eTmz6yOUC9S2cjzgETY60Ju2PpaQh3yK3XNsKsgK7Dyky37zuld+l3EI
	 PlxGGISs04ykUysfnAZ+YNhYIGKhbXLwvpl/Khe/e/KH4qf9uCyuGDTImM3somOfat
	 y9luVBQTC6Mkg==
Date: Thu, 28 Aug 2025 10:14:14 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, pratyush@kernel.org,
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
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <aLABxkpPcbxyv6m_@kernel.org>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250826162019.GD2130239@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826162019.GD2130239@nvidia.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 6399D120017
X-Stat-Signature: 6kmbmfbbajoeyjxwhe1u9crcs9zfawyq
X-HE-Tag: 1756365281-742509
X-HE-Meta: U2FsdGVkX19DPCSuIut5bSRaHzCJSRk8cMApOo8WYyrDe1oxX9aM4jO5ScW5syuAWAeLOn39V0bdTSs0iOKF0vKEs0Mza71NFiTJfqK2YoakW6qfvWzOEHmaxZlNpu9YfrbBGNl7yjHPK8oDeWMotZSs8mjShuv1krWGEK7Z7iVGUIc5W6VvxDBhua/cVciIzzp3JxYXaq20APBdUpCkZqWhjLOb7gx5RZddwSQfe5KML8pET+maIktYKyEkzAwbemPRbcS3Dc36MJGAHo03RlvTOyPFhmvYj7snlglmLISXE4YbRAFtPfOQ3fNmfLDaXiUY/T19H3kKZm5CK57naR4lPvOy5HZKHqEwWv+wQLA9wwJJqZLMHT5pTE9REi4cmTkG/glPgkBxm3YYT1SLWK6zsCf+34IjalK0qSZqUuiTvf7RH9CxdPvnvDNTWaXl+RifDyAhRcG5f/H96Aslj9eK95W3lrEsOCdca5DjKogDfnAokHH1THot6OF5Ad1Dqdd3xVDzC8oAboDvQaYzeXxz0iGfpLIv4kodVuMIeBiMU7di+nSm3XZXKxHpsbRpmKgYsStLMydrsH0hNRDkZqJwFt4BndkNUTqP6RvLCdtvxsMKxdPbG0Spo28PVkO6Fk+Injl5rl8G0H4Cv0h1Z/wgdoWieHfysHjicfY1usZHAOoWOsgPR+B+kzkm0JuIlf0KApQXlC72hrEjfd0WgJtiSyuSFuLgdm2ZKeyUJVDw6QNE1UWfHZvXYnBxyIaDLVQuHwQYy4TaKsEagQ2SWL1++LIFbsiK0cNCbX1+cI0PzMqN4+ukMn4sJa5tk0bpuLgQh93Ogjjf7t6mgDd95rHwRPWHDSawk5oLb2tpbJ0qoXwxDls+5D4niPF6+aR3RpfSwAtud1orsjmfNbb3R04l/iOsH00r72wERhWFa0MQuKBWOvKI73uIjvE3UewJMH+RRx8fJ5KZPRuxVqU
 Hzs2feUR
 YhRfPpXUBltkT35kva/jdL6hHcvAV0AXC+5FwoctV+N4CF/nrEJugnn+INJDeptsg7zetJuYu3nDvqS2l3d0WECqZ3MopSdZ/zJyUoRmpShumHTsCcifdS1ZOo648J5djKaK5HUgWZRMUZgM+EFLOBeWPRzqPnJnrzrPvuHX2PNq56aYJauxyRuslfu5rABiv3EZA1ExlNwLQ3F6Utylrt0+dVovMvil7m3tVzOQ/HnINQYoKDrBwPhoHWnF+3Dhi9ezvpS6MQKYtHuqImEjWkQWQR9rqpnUOjk1XBXmd0fnKRw4OYhGx5PmLs5TJ7Wvm7evD/ORDO4pYzJU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 01:20:19PM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 07, 2025 at 01:44:35AM +0000, Pasha Tatashin wrote:
> 
> > +	err = fdt_property_placeholder(fdt, "folios", preserved_size,
> > +				       (void **)&preserved_folios);
> > +	if (err) {
> > +		pr_err("Failed to reserve folios property in FDT: %s\n",
> > +		       fdt_strerror(err));
> > +		err = -ENOMEM;
> > +		goto err_free_fdt;
> > +	}
> 
> Yuk.
> 
> This really wants some luo helper
> 
> 'luo alloc array'
> 'luo restore array'
> 'luo free array'
> 
> Which would get a linearized list of pages in the vmap to hold the
> array and then allocate some structure to record the page list and
> return back the u64 of the phys_addr of the top of the structure to
> store in whatever.
> 
> Getting fdt to allocate the array inside the fds is just not going to
> work for anything of size.

I agree that we need a side-car structure for preserving large (potentially
sparse) arrays, but I think it should be a part of KHO rather than LUO.

-- 
Sincerely yours,
Mike.

