Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231E1C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09BF16B0095; Fri, 18 Sep 2026 06:27:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C9A6B0096; Fri, 18 Sep 2026 06:27:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7DC66B0098; Fri, 18 Sep 2026 06:27:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C02286B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:27:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C347120626
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:27:24 +0000 (UTC)
X-FDA: 85226506008.05.B616267
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8273BA000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:27:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=Du4xoU7X;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789727242;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUkDSbiAS248nMrWXNTNmtWkBultYX6rVLee+4HO2Ss=;
	b=1zJ2GO4wvJEmrrH9tIDHhzONh0DErtJLwv341ytyJllPEtKL83RF817JIG2snF5HYaqB91
	9w5C7/H6ni2SFqowFj1agDjNHI+a/5GRixF2AZ538JOMP426A0TSc9j20FPVX+B+q2n2sb
	kCkJ2YcXa+ZTdBfvwmnVieQzkfAeOyU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789727242;
	b=j7rAhAPkoi99lsRpHc/puJTbFIdKYnAnJojDMUXhBpTcMXSjL7JPb92HDtl8yEVnO65YqL
	I4dJDwOrdqtrOGj4+WlcTlUHAVK7SeRqSDNMRSqB32NDbKu24Samc/FNV4cDqauIsvYZG5
	/XhF+ub9Vnli2zIEq8Jeo6Vcv3KeHxk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=Du4xoU7X;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C4F5142E96;
	Fri, 18 Sep 2026 10:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789961F000FF;
	Fri, 18 Sep 2026 10:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789727241;
	bh=LUkDSbiAS248nMrWXNTNmtWkBultYX6rVLee+4HO2Ss=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Du4xoU7XjcM1TU6N/dTK544nfxc5Xy4BGBBLWmcwaBcwvbxAkfkHsVFrdqrAPsSNR
	 Snp5SQgQywMHtT1ZKAD43KdCSFT61Wt+I/i//Tba+e+t/o/RERKfZj8UnuqflMPSL5
	 ZmWlhVxdVtD7qwnw/a2BcP2WEBdw1L0n1RWhDgC0dZMVpk5r1PDqcihr9V0X5Zr8Be
	 O7jQ7y50yEdU+BmUnsJ/aCm5tAaCmg21Vg6fHxN3SuCeKnMkicaeMaKAlCbh1TiAVS
	 /bUGsZMlSdpCGcZHfnhBCEDyjCUSVrCSdPi1aHOlrHCZfjUtHuUzjSKPie2NGP+BB3
	 ZbhYbBud2KtTQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 16/17] arm64: kexec_file: Simplify
 load_other_segments()
Reply-To: sashiko-reviews@lists.linux.dev
To: npiggin@gmail.com, vishal.l.verma@intel.com, kernel@xen0n.name,
	rafael@kernel.org, james.morse@arm.com, tangyouling@kylinos.cn,
	sourabhjain@linux.ibm.com, leitao@debian.org, coxu@redhat.com,
	palmer@rivosinc.com, linux-arm-kernel@lists.infradead.org,
	blum@kernel.org, baoquan.he@linux.dev, x86@kernel.org,
	jbouron@amazon.com, lizhengyu3@huawei.com, hbathini@linux.ibm.com,
	seanjc@google.com, dakr@kernel.org, sshegde@linux.ibm.com,
	pasha.tatashin@soleen.com, gshan@redhat.com, ritesh.list@gmail.com,
	piliu@redhat.com, chao.gao@intel.com, driver-core@lists.linux.dev,
	kees@kernel.org, kas@kernel.org, bp@alien8.de, mingo@redhat.com,
	bgwin@google.com, linux-kernel@vger.kernel.org,
	chenhuacai@kernel.org, linux-fsdevel@vger.kernel.org,
	maqianga@uniontech.com, zhangtianyang@loongson.cn,
	catalin.marinas@arm.com, maddy@linux.ibm.com,
	akpm@linux-foundation.org, yeoreum.yun@arm.com,
	loongarch@lists.linux.dev, ruirui.yang@linux.dev, graf@amazon.com,
	takahiro.akashi@linaro.org, mpe@ellerman.id.au, g@kvack.org,
	uodongtai@kylinos.cn, linux-mm@kvack.org, gregkh@linuxfoundation.org,
	pratyush@kernel.org, liukexin@kylinos.cn, robh@kernel.org,
	dave.hansen@linux.intel.com, "Jinjie  Ruan" <ruanjinjie@huawei.com>,
	rppt@kernel.org, ruanjinjie@huawei.com, mclapinski@google.com,
	thuth@redhat.com, adityag@linux.ibm.com, chleroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org, mark.rutland@arm.com, will@kernel.org,
	hpa@zytor.com, me@linux.beauty, ardb@kernel.org,
	eric.devolder@oracle.com, tglx@kernel.org
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-17-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-17-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:27:18 +0000
Message-Id: <20260918102718.789961F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8273BA000A
X-Stat-Signature: p9qdef1ys8fusc5b87x3b5yqs7jmji48
X-Rspam-User: 
X-HE-Tag: 1789727242-661304
X-HE-Meta: U2FsdGVkX18ViZvI68MyBBe/zGOYAON+HkHz1wnQ7itn5uH6KoZDefkAw7upV0jySGjjQ4IhJzIRZqw3NiVAglsUytYZ/ftNvjMvK9OV56v9+xh6od4ErTUT+RTWiHqe9Gpad8X3euk1pzQhRvn7jYXqh09k3nH4UoVn7+qNiEH09HAfSiuNhsQ+mVdQn941TI0NY2HFO+wz3t2keerJDFTMni+udLjHrRhzwhT6hXguMPLF5z3PKhD05X2ACH38MWRIe2+w87MFN+7nTYN9Gu1M0OkBIG5J+o/BDBvOY33lNd+pmb1sLj5DZfyGJuanYTYDiozAIq45pm4e51Y9Tym6SzncklJkML4xmcPXUqNNNky1J8Jz9XEWOF+83R61VQWE1Rbg41Fn2qjL5QBRU4p889AjfTJDYoyJx438CtiYYlj7c/N95CjLhIS8W/saO10H+vB3ZXyFeW967Azdyk93iCXEJEwtAr6SzYtkuXnX1Q8Z4TXGqBKSb2aDupMn/TxQzPXp1KMN1QRukHMXu4b5B/1jelcvKQblMlGXoD5VFQnbLTOfloVKlbSwjFNTdBmJGMFHxBrhj89LfSsrXH6mJRcvdfzhqWIyvgmNYo7M/dnq6r9anKV2XuYZ5WcOyVgXdQ5hyUuZVIHimsfY1OZdV3U8tuS6qXHfzcmncY+9LD4ZygjFMYukrCvAUDKbeIGZ/izBQrzvh4t1LcYarKIOqGXaLDstKs+uiTAi4JGCRYlZFwGnR4OEtMgPaXmAbauaaVT6XHMd7KuSBpuqyDY8mYT3GZqQtnF3DqLNwIYPxJx8qv11crYcIBII6fB4tWRYmS4XUyIfHHwDFGQGnNQZk3maVjVmLfMm8ugJjVokGJdrelvv5ip98UUlHuV0wuXP3SveTjgHArMqw87Hwo7xb70PQmon0WqibUpwZ85KffB/HXxXIiYAB+PVQmoaDKvsFhVMyS0WUFYGpUS
 M7nq4hUD
 nIGZ8jbGrgM/EWN1A1sbFRo+FoVFs4+T3wQWE4rB4q0qytAGoX5BchAtV/h8jwOMZwo3E4TvlrYXduqD6Brj7pn2+NMLl05HffTBcdRKLc2lCD1OGZ1wMgYSa6sJsM4vFKKbhxrVx8JZOgsq3+DsB3n17/6VCNoTC9AAmDuZ23ZefcWufNkcmCm4csaJ9G0htAYH1DrWJRFqww7l8kV4nKgoQxT7yAtA4camqM+YfY5SrXq20bOD5qPUGQ8c1MlvaUPZTl0AIaiQpU5ApEDpdrNHPboVHbW4ocuDbtp1N2qyf4LWiVnH//43/1qFVN7lIrctpaxjKyVbns1mhXIbN+biZpRjqfm0XmVq37McpgBQwpyTAjmDXxmU81soJN3ZMVrsatMkQFgDItz3jkrDLxPAs6xLimTeDVRzWPsIHeeqXvBYCbFDi3spHRKFUx4jrUXKInDWTObzE8tck7eWJRUZfIaBicvqDk34NvvkubvoKZ9Vc0jSLNlOpi19oNVerpIQljePuphCoF/9IIrO2/DvS6L76tCb5quc4BRWBThWUrlzUf0OCaGLBqeT8b5T+qMQfJaEPhh1J0jZL3uFMocNj3WV6Ev30xS9q7lFRJRDtVadKzWeJ6FdQKil3n9V49bIERxEAaJHWkobWohFZG+4lJw3z0t+5Ocd+bsDbbjT0uYyxO4xUeKMO1t6daQ+g8fomk5ILNS9/63VUXU7zFZGqe2p4pn8PLR4S/jrZOFR+A3oy6kwPnBEdzjjoQpLyt/kgJzRVnVhqWjTAGcBK0B4o0imUPzISI8OMGlD61xQbuRldmc1Dwwy6D45w1XlWAD4V2jjrxxAIsjVLSWe6jRdC6AnHTDMfXP33OBRnktKgjneAy0emMbiNm4CRXK3Uk2eNIw6W/buZ800UTjPYMaSDkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Use `kbuf` fields directly in crash_prepare_headers() to eliminate
> the local variables "headers" and "headers_sz"..
>=20
> Advance the assignment to image->elf_headers before
> calling kexec_add_buffer(). If kexec_add_buffer() fails, the explicit
> vfree() in the error path can be removed, as the global infrastructure
> in arch_kimage_file_post_load_cleanup() will handle the cleanup.
>=20
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Breno Leitao <leitao@debian.org>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D16


