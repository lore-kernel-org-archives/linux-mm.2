Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80961CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 16:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ABAB6B0005; Sun, 23 Nov 2025 11:05:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5830C6B00B2; Sun, 23 Nov 2025 11:05:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BFC46B00B3; Sun, 23 Nov 2025 11:05:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC626B0005
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:05:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5EAA84D7D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 16:05:32 +0000 (UTC)
X-FDA: 84142346904.27.EDD54C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 262B01C0006
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 16:05:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aEj7LDNR;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763913931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AKZfVSNRNcEM/ElJbcEk8kddpeVZcPmjjX0jUr6E8Y=;
	b=UeunMSxwFuAdjAsUVn8h/XgBl75WHbwvIOWsQtDgPIHTp0pOOpw+SjnzSsvsOe2eVM92Po
	fn3VIuRyn1tKAdZpqhQzwXERna9iY/Pg6IPMh2Scu0CaMhLWlfFQ18FSKoAzTmCS//5WsS
	HnsXbHO+wxrYGYNtQt49ThqjskLFDmE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aEj7LDNR;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763913931; a=rsa-sha256;
	cv=none;
	b=vdiTmcXP3w3NkYvX3IpGY3SxATCq3FMu/J5WbOPzOix/rfk4O5Z1Z3PVW2zu6HHFzo5DLk
	Ful7Wi2gQf+3MlCn+CKJqoSVlSpN7oS2PqNS7QbC9slQUlT1NSSUF28lAkKLXVjMPLe93d
	wh5WcYbPBWFL/KW6GiBPIoO/GcDgqww=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB02C4026C;
	Sun, 23 Nov 2025 16:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38118C113D0;
	Sun, 23 Nov 2025 16:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763913929;
	bh=iVWayNIJ4hSH3Fqh4iv5N9nJbnfnFx1jKHx44lnHwXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aEj7LDNRFeKh3Brh5+Tnr8ys08Au6/iNifFEu4npSUjlpEkRYtPbFWkAjmIarvG8o
	 mEzqiU89wuYLBYXVGdOOOAk8rx0Dazs0GlcpSaYsgNGo5lwL5m2Jf7CBz0vNZ+4wqz
	 +z5CncVvHnb/uxJJcDP6+g3aw8zEFJbufD0NkRidmC1MmbAfTQHK3+qGpE2iZYHImm
	 2SQQG4LklKSH6FB+hsmnVgb9xIEjTOlGc1BRau9nScUKdf2XVH0eOEYomBOlHHJwME
	 Ar/tB4blesu7ifnYesL6JbhCDzsdhbiEJAcWwDtaXpVLrgYFZGAydc4FmD5GjGcEzi
	 qrOWnGFWJObLA==
Date: Sun, 23 Nov 2025 18:05:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v7 08/22] docs: add luo documentation
Message-ID: <aSMwsLstAutayHbC@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-9-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122222351.1059049-9-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 262B01C0006
X-Stat-Signature: as9jpjta6uymur7hpbbm5n9f7rz33don
X-Rspam-User: 
X-HE-Tag: 1763913930-153924
X-HE-Meta: U2FsdGVkX1+QBwJiK/HPQsY26h0Vr19qvvxKV0XCfVLNR1BNJ4HcmrAQQh3NodJnfSZAJoLw7K5qdgYSVCQjVO2XNThXAmyGjK/zd7tc7GVSq3YWd4LrjA5i4ltel4SL546x2QOMGGBpxD0Nuuu6Sai6ISgqVlR5cE0mbrjJKZ8eEjDiurB8wX9qnlcvQdjsZ0BRZpxmpikirZFrsRDspaBblDYs0LIJG80LRmrEQ8be/maqQLd8MMP1WufXaTywv2xXMYslJHPMnvV/1E32Q80YH73OnkeZlwaas6fdHsy2LoyKrx8ZRb7dHDXp2eJxHAN9tUzxAYlDH0xYMgOZ7HLLO9Bo8IyJoCgaDeHd8spz9jfiY1hiovvkW0nYcZ0a270Hb4fCCg/AxT0u+lE4qbtc7/s5Whe6iWiVSO9hi6fg8g0W0QbBEluFVFTIy4ZYqN6f+vm4sQrwUz5320J5RHNcaIrV5luC7HbAbIT1Qf3xIIzuzkibK2+JjryKf2srr++OBVz6RUj3pEwr3bJyrda8b1D7XQnpnOmPyiRarfRgoZewb76dw3mOuN/lUrKYhQGiWGI9haKBASdi2GPmNZCjl+aRLsQ3ciVvecq2QuMS59b9lgXfpnW7GVmPLppgy9HQxzeru8eqXWRDUpC756uHS7GJf1YikV/s4I+962pDKTZ7kdBDpg/a4rTNMWkZdQmF+eKUmIFABPgQCzgDFYJb87pvwCKm5tEgQU74hWhTUrZGVXbHijeBLDFaLVUQCxDZ8D9rxD9ljdg1tnptcZiS9dTOJyOlKqtpYNygF96fgdypCVxo87a7TMRkG+Ah2m25NkgdU3oE9ueDD8ClMCmYps//d2KynoATR/Ul9mh/BGKSXUY4eFrpIlrYNw8sg1nxOk+Riu0f/LZSj7JKhyG2s2X7U01lSmmoTNg79n5NQ0CL/sWF1uQ9bsfl5IEChOJq+8gDYlZN4BRvgL7
 k82fuOez
 FPzM+OpJeULkRuYFmcJKc75rDQjgffRMj3+aZNSJ90xU+zzbhq6s63NWIEPFXI1o2YkxjQde9Qec0mc1w6y6/SSz1mn5+OMRxBIwYs1R+xb7HoOumwbUCxn5z4NL9Qs4j+hKlgw9CUBU9kDtdfHWSSaizwHI+vlER/uDehLo9aZ4VvAUQpu9bucfTgE25wFxVeAPJdmVOgZkT8E4C5dZ8WYpEELDXkJwUvrYsUpJe2ps0zbTAtQZa1H7NaqIJIi4uN7t2OgiydTbA2EFd+xzLbSPh2swtvusoV5VcOEjFHYqLVY+jjqeKEoVGDIK/zTbPhPrEAxYtJpr5zFasLtjT3eghY5JThyoxMqX3RJoQ5mMBDEf2tLB7Wo4NsXJOOb6jN6qIuSjpncZ4RKH/wNmrWyWDlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:35PM -0500, Pasha Tatashin wrote:
> Add the documentation files for the Live Update Orchestrator
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---

> +Public API
> +==========
> +.. kernel-doc:: include/linux/liveupdate.h
> +
> +.. kernel-doc:: include/linux/kho/abi/luo.h

Please add 

   :functions:

here, otherwise "DOC: Live Update Orchestrator ABI" is repeated here as
well in the generated html.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

