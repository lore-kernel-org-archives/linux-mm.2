Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A0C0CA5FA2
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 16:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823ED6B044E; Tue, 20 Jan 2026 11:14:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1ED6B0450; Tue, 20 Jan 2026 11:14:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7078B6B0451; Tue, 20 Jan 2026 11:14:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 602D26B044E
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:14:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF27F160635
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:14:07 +0000 (UTC)
X-FDA: 84352838934.04.D203885
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 17E12160009
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:14:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dV47J2SI;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768925646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AP3b1QG+xPI6jPhdm+mXUYSwKq6bcsjkSqEhuIl9PpA=;
	b=anWBQs9CPawmL/d+Uc2iEfBvKu9KY9ZU4814AyVDksyBFhWQ7O0CmWPhff0KVNn3H/1Bct
	OEXoAVLR0LFIflwZ7JY2Wqs4UApoW2ci28+kxlUxXnElmyUZJru/v8uauyO2gsdoD/mxPK
	x3oXmlYJpJpR8Ez196FTiwGZs3yiZqI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dV47J2SI;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768925646; a=rsa-sha256;
	cv=none;
	b=5T2hZjSKl65knlQqmESsKfOxEsWnulaNvJMBtNJunwJvbo1WxnkI7mjgzqsvlY965T3EnP
	o4fIGTctYsUmGQv69YbjYIwGlqTeMkUCP2KYXvZNdrRoamr216qjFL6sCEB7frVaiwhX4z
	AoMYK51oDLk3/6SXDdEJwEsUFB6UtRI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C041740BC0;
	Tue, 20 Jan 2026 16:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF835C16AAE;
	Tue, 20 Jan 2026 16:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768925644;
	bh=C1IvwOEB2IeBsljjj1U5exHtGWqVJB2lEhayoPqkk5Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=dV47J2SIEbcMdZkZ9Lifr8FksIvm38/wEBwH1gTlZgjkovIsgQnrHeducibOmFi2u
	 0MXW3RUHb176VYbMK+JyeNcRLKwK0htuCP642Do6W9esCNrZRZeWgKmjratMzZhxJr
	 /Y/U7vCLf/7KDZtCnyqsm9dTVBjlTW7u7n4Y36QbguNVCx+fcoocx9lfyB/wYY22GI
	 YQxLDv4C46PPgDTux/jLnKScOureFjXjQ3T6yun1zCpFJ4Tb4SkyPicZP67prLnJsO
	 81We6TisKb/KfU/+uDFPsfyFCg9wnY9yaM5CIJw6/dHdUdK9aIvJTFBmcf7RmuOPU6
	 LE8IcaGoozNaQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Jason Miu <jasonmiu@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 4/6] kho: Introduce KHO FDT ABI header
In-Reply-To: <20260105165839.285270-5-rppt@kernel.org> (Mike Rapoport's
	message of "Mon, 5 Jan 2026 18:58:37 +0200")
References: <20260105165839.285270-1-rppt@kernel.org>
	<20260105165839.285270-5-rppt@kernel.org>
Date: Tue, 20 Jan 2026 16:14:01 +0000
Message-ID: <2vxz3440dzxy.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: qfj11p86wchj47tgdbrqnogxw4z6f5wo
X-Rspamd-Queue-Id: 17E12160009
X-Rspamd-Server: rspam04
X-HE-Tag: 1768925645-750893
X-HE-Meta: U2FsdGVkX1+JpPkSU/kl6LP1bDfQ80zSJ0r1nFLC9k35ZrcPEc7Q0jW++0VtBJzxpz8TXiY2M8kxqbd2SfXj2xo2JNPntQ+/X+9Yx37tJM7VYhyB744RjFJA/7Th1Oeg9To4MfpKNoQmupW6xJRF5Lxf7CO9zFEcC+nIbicN7wo9orwauHm4DY5NFeftNbXklo/05aiKe4aaz6om2N5sOwHUmH0ttG438issQMQXep+SjAnOz/l5wRNsxmUxzwTzWS1WMB5V+4kO6SBT7eKUyC2E0fPJJMAoJboAi/4HAoRpzDBE6njEtH2Qk9o80ifD/7FsyvoK9XWjbf8rQyQuLE4BT7hzGD/MmeMlpaM3fseRDkj5GnuO4R8NAGkqQ1DKaTk0uaDcMoBWV+oN049q5Lg6kzBMfOcPAInkdPiQIyibGXjDTpDykOVa3zY6ZIFDNoKfjBG0fka66DsVg3iDeic+xigo3RRLG0O0u2+cU6buFHje3F/uedWgCbRpQRJLVpBXjgYpZYudNBtr2F6EHoIv+fKRk9bvEwraWTMxOBndiYO+peHxMcWldQoBzMujpvS3a37Cs/Zriuv400lS4m6VQ0G4xkHTXdquIumjvMUM3IOdfDM/fkEdWfYnmPUPQOmDq7r52PgCXRRq1nwq2zIK3FL+4HuuUVw2iFvZODkLmiLmShPQ67AxmJzvic/v6KejxKLd8cgBQs3zblqe8j4gT58u8ytHXZFHB6dmiNDBvmC09gOLhU3ivgvwI3w4oDKXUWlPiRhrgdbeGoTTK92R9zG/oOh5vb5lWwdmvyG0fjwDO5jrSBTna+SRa1FRZsD0B8TecWLrWW2z+09hVXWzRZd8S7huLXFJeR3QTbbyx5lYCFadyHx2lFuoY+IiWBxryTg7OrGAnJJ4qaEn+zNfGy22kIrYF8xBODw+LUHbCOvn/UDsONHKeE3OsZHeMeJb0Il450fsDVE7eTX
 66fhVa/O
 Xov8KVzwsnjqRhg1PGxgH+S8d5TZcXt8pnObiZ3pfQjrvBfyb7ZV0YcERN/HgdL/zDuzYEb+Oj7fO1bc5epavsVa+mBO1pFoq/K562r/IzHArV7soyHVMkqsm66rhTy9TlEl1VFLDw7klVTXFnlO/70IVzWpa409gmf/Ffo/BukGrN1Wx8YTL09ed6/uB2z5t0Tuy+C/ZHo0CW1ZwYkeigqWsaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05 2026, Mike Rapoport wrote:

> From: Jason Miu <jasonmiu@google.com>
>
> Introduce the `include/linux/kho/abi/kexec_handover.h` header file,
> which defines the stable ABI for the KHO mechanism. This header specifies
> how preserved data is passed between kernels using an FDT.
>
> The ABI contract includes the FDT structure, node properties, and the
> "kho-v1" compatible string. By centralizing these definitions, this
> header serves as the foundational agreement for inter-kernel
> communication of preserved states, ensuring forward compatibility and
> preventing misinterpretation of data across kexec transitions.
>
> Since the ABI definitions are now centralized in the header files, the
> YAML files that previously described the FDT interfaces are
> redundant. These redundant files have therefore been removed.
>
> Signed-off-by: Jason Miu <jasonmiu@google.com>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

