Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C7CCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02B8D80146; Tue, 28 Oct 2025 09:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E3A8013F; Tue, 28 Oct 2025 09:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CCC80146; Tue, 28 Oct 2025 09:37:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAB128013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:37:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 255BAB837C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:37:26 +0000 (UTC)
X-FDA: 84047624892.22.B3EFF97
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7FCEA4001A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:37:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=b+vDaaHS;
	spf=pass (imf01.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761658644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xN7DyMekRKe/FGcxd1q4dV0LToW+6yk3O5piEP0SiUc=;
	b=FiY0jMe6YqcJFKpttEZR8Ywn+dm4SXafb6JtH1i3K4GEqpp6Lc1HPfovvmErZjUnxZq+YK
	7zj9q7zopKtSgyL/A0xnajt26gfT3+joUz44MskHaUoy/txgs3sPdBY3iKSeHnSyR+0qrM
	4gnFOsupwq82ivgjQjtalpjf8nZj0gk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=b+vDaaHS;
	spf=pass (imf01.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761658644; a=rsa-sha256;
	cv=none;
	b=fb4KrpgJtRzxGWsFCgvDJknqeCi2wrpZFraspdar+nb51HSNy97M7jic3ZBqSWN1YCO/5L
	c6ijrV0d5li3ZjnVCQolt5AnsSP2II/D2KAwj8vN3LATjfFu2EQAQKls2uKZeIvhZjUPLv
	pDX6wtYzsf/M2wluhsV7Pwp/+78ekq4=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7CBFE40E01A5;
	Tue, 28 Oct 2025 13:37:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Nbx6tKafUGdo; Tue, 28 Oct 2025 13:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1761658634; bh=xN7DyMekRKe/FGcxd1q4dV0LToW+6yk3O5piEP0SiUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b+vDaaHSCAjv8nA9AbrFC60fyiYK/P+Jv2oRSP2OTn1n/hsYFzG4lakZvmuiXdXP4
	 aegCWU4AInnzHCZUXiR2Oc8rcK88mS1apoARHguTeqaJJv/qt7aYRh1lEQNvF1KIWg
	 NhyVJ7nyGS0N5ihxKCYq24pQ1vCt7TspUzptpdPYWRmQiieC+dYcGLTLd7QRwOKagY
	 Nm9tBYOepur+MV6uQUT5qaXgrSqeKkn9RyUjjRNms6D8awxA5AMf6Nv7thDb0zuitb
	 hjyRoaA0XoYttAaYfutZszvrmWlIP7zd9W6tk9W7m4etxy3ehV97AB4FyKWU/tisab
	 Cfmc8f/icO7BP/QSwvHotSSBsPfhVuJbNQJrWeTVlf0ZisQvyR6YhMKV1Z56aW4k3U
	 OZmL2aL1weUvsqvHxVr2KuGK3eo3Q4b7bPnK66YPY6FMJLn7fwCoYLU6xOH/jpcpMC
	 IoyNB74uWJ5thpKX9JWaioU/Baw+NYO4umZxDTYI+qgnO22rlirNN7kDFV25/TAoyz
	 WhCArgwU3K9anyCKPVliWWN6Br0Ur8FVbFEg45gA5kLjvxL1j4J++ZWJjdwgIWDkB2
	 6hWsjtvFdLabtFiln8SN/Ri7fYu2MBiUqmW4uK5iEX4dvaMnzm+HqBUnrZ8D2753k6
	 8xt784koJeaU+A0q4ZP/48Ks=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id CB75440E00DA;
	Tue, 28 Oct 2025 13:36:54 +0000 (UTC)
Date: Tue, 28 Oct 2025 14:36:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, david@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
	mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
	acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
	willy@infradead.org, raghavendra.kt@amd.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 4/7] x86/mm: Simplify clear_page_*
Message-ID: <20251028133648.GAaQDG8PfOwrSiHYuk@fat_crate.local>
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-5-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251027202109.678022-5-ankur.a.arora@oracle.com>
X-Stat-Signature: m1p6igz8tczse6sdrdiyhb97dohgtr5s
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7FCEA4001A
X-HE-Tag: 1761658643-729025
X-HE-Meta: U2FsdGVkX18Ks9z5tkG3+VFA6RlFdRIrXcgvOfkCrzwBkSPrEAtuP5jqMT+rKx1bfj+5azzBEQoUTte/RlnmKyScxrCGdxooKHqdjz0/YHFcsNSWe9JLELnTiPO3ytI30CI6lYG82uJBsWQ4AA5vQP1L8qMCVVmwnVRw25iHSp/yhkslVi0Kn0jdwtnIg6mhyTrSnwxs3dVwrnEYRE0qfF1YsgN1G5p/FluksyEddYEyGTRbgtNcgkQ8coZbydHHT1qtwFiEZVox0f/hzZUZxBos9iaPYKRePDuey/yGD/VMkKzuEct+Zb9O2HRqp/fFI4jKQJKdZtjTTDj1Y1ZwmhJ4GCSMWKh3oqQiUK6xjmyPwxs5HJufiD8HKUfZqFta8cMIhHQw2RI2nbnk3uQorMKGF33+VivpAqfy1PQ8q0hGjTfsNAX+l6HkM/clAvn0fgaCs0K7FLOw6cC6udWixb6KzHf4+0XsWTth0lL02+dIZcq/SKhZw16LWxL0L4bz3cxiwlPP2bkrqkWHsxcvhRG9TjfpJSj4zHVqPdlPmo6AsytvzF5iiELN/BIvEPGkq5obKC4sIimFn81kZqxLXLjHryioWgcK1WWYMYAGbubD/VVYMRECzzLpFWdPrOGcmUy2/ap0RwIdNr6zfYWtHJNZHi63ImGbvKUvs69Oghv9ThSHmLb+OWS4a7GxAInlhgSzfTAlqDKlRPe6rCK860CSgmZ0TNYBeuczPyBy9gqYWS4VJCWqcMjw2LewY3Pb2BEsWIcQdx5dNPShwMO3isi29EvBc84mMD39SLz8pJV+dcfyC56vvtXJhVoELlYwRNPQzB9BKV3dXIo5gyK9rhq9T1FJtZd0iEChX3aLuhoJqLucuJjKhnwuU1xAsdnsUkAo2ystLdMJf0R0Rb0rLKOEBvUKsbTLVvlJLhe25hiQ/1ssrM8QLvd2GPZsFQjULyeMwWYPDGw9u5qVp2n
 DxKkpkJL
 INE2MVyrkwsFd1+QpSeVYUdNj8qDKXaFbTNIQM8u2IGmFkv4cHWq/1h472FRBDO9ohJO00IUDNra5LVoSUxdkbZVOwY9bV1IPFLEvx08q96PyBCcfoPQqVYOW4Zpy7y0rqzbKBl3sBySKRMxWGAbpkONYDyeL1f9cz6PvWGu8oyJK+glBT3K3IPvfD3FOu0lTrhizEE7VUCyNZRmx1YKq13Kc0/Jr6tKieDZ/0QVlgLzy1C4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 01:21:06PM -0700, Ankur Arora wrote:
> +/**
> + * clear_page() - clear a page using a kernel virtual address.
> + * @addr: address of kernel page
> + *
> + * Switch between three implementations of page clearing based on CPU
> + * capabilities:
> + *
> + *  - memzero_page_aligned_unrolled(): the oldest, slowest and universally

So I don't see how a memzero_<bla> name shows that it belongs to the
clear_page "stack" of functions? clear_page_orig() kinda conveys better what
this thing is. In any case, having "clear_page" somewhere there in the name
should stay.

> + *    supported method. Zeroes via 8-byte MOV instructions unrolled 8x
> + *    to write a 64-byte cacheline in each loop iteration..
							    ^

one fullstop is enough.

> + *
> + *  - "rep stosq": really old CPUs had crummy REP implementations.

We spell all x86 insns in ALL CAPS. Like you've almost done.

Also, it is

	REP; STOSQ

with a ;

Otherwise the idea for the cleanup makes sense.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

