Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 584B2CCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3C976B0127; Mon, 19 Oct 2026 01:16:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE006B0128; Mon, 19 Oct 2026 01:16:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C031D6B0129; Mon, 19 Oct 2026 01:16:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 911946B0127
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:16:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74C5BC05F9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:16:38 +0000 (UTC)
X-FDA: 85338215676.22.C353172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id B1B12180007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:16:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uvenVXd4;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792386996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFmgeB37RrMEaTiq9/1yjdALrJzKBo64oW+9MSxzpRw=;
	b=sVgosW0EofLpbJT4G76rJvZQnUq9SB9rr11+ZKl/tDCoPu9LTnfKq6rCi/PnwtIdoYkM1M
	V+sJpUeEY259cFoNhlBYXIjHuLn+NDGm48QHyOYH4l0/MvxHWEhPOhotoHcLAbmZEcsDnZ
	dbrhWkzOtnc6w2uvTHlZ6hZ1NAOm1GU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792386996;
	b=j5o07Z/Ir02k+NhJMD6kuTA6l3JNIJD3jDluQgP6t8fU+QB7ITWBqiO9xcfh2ajsi8yTxb
	dwoDaRcNdHHWoZnqYoPNJDxw/4i3pfXE127GrGognst22/VtwrO/LA43oQsCsvWKD3NTh0
	P1/faKt/2/oZde8ITo2bDBmO27MIZtU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uvenVXd4;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3EDD1476;
	Sun, 18 Oct 2026 22:16:32 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5AB0C3F7B4;
	Sun, 18 Oct 2026 22:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792386995; bh=mMlo5yhT+yBq0RqdKFNPHeYCznZMnItKtpCZiqLMqS8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uvenVXd4wUxq5NdWMjKhwYFhTtEUS42roohcPbVmjMYVF4Qxn4wIsXRwOz/kUAyCl
	 LRNTEFDqNlUbymET7J0YUwkJf0uYLJ4ZbTXK1wkoifNz/Vzjndr4CZ1xwEbgQgawn9
	 TyUsVpuKFxNHb6zsIuqeDRs9FRor0982wVA4uke4=
Message-ID: <3eeed828-6abc-4501-bdc9-e16769f52100@arm.com>
Date: Mon, 19 Oct 2026 10:46:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] selftests/mm: check MADV_COLD and MADV_PAGEOUT on
 partly advised THPs
To: "Gregory Price (Meta)" <gourry@gourry.net>,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-7-gourry@gourry.net>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20261014175756.2035176-7-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5w8mj4z1zpy5a1pmdtcupwhb57eknrfh
X-Rspam-User: 
X-Rspamd-Queue-Id: B1B12180007
X-Rspamd-Server: rspam10
X-HE-Tag: 1792386996-600392
X-HE-Meta: U2FsdGVkX19IY4OcrgFJh0KugRFG9DsDnLwHiqpnobQQstZo/yqi5NMSalqXndV4TUx+eZlxrXYNfzWKAbqDBL06ODbNy16umSnBdG/pGDX6fMUMzXHvwVgPuvkfI/VSf3T2yKueUlCs4VlRSqdXHdWH/IPXhkfrwRwD0HwIXjUsZeT9/hdyW7mqWmFiVf4n/v+2ZGB5sa8810O3nPuDPECuxEp/Ns37UnbRk59Y/wSrSA9SkRStBkiT40fADB4N7FGZaccKuLTku6Ix5J1VoGfPSieFn10e/IDFXG5i6zxQWyg38FDyciW1/9PeDLcN9bR7nc/PKT/6mqVce6fVFvxsHAxIE+qnpgug16aKxtBhBE8KC80WErdJ10fjPnD1JtztIBkjK/MXaE2cjPFeLClsMsZxMa02V+tJbRJwE8P2oDKxRu3Vg+H4sWyZhU/BslgVBfzVymzvuuOF7lsPH1qM9JTtYWWqgj92O1gjvNk2yn+1Hmj7zD9nxX/VjyrqEgi/RvRHpqAkhsco8ExaIx3XSfjySIoMJPlaNEp4jeo2B0GA3IYedPaEvxUQQ8eiSruKV7VViGpO0NPifyRbSSl0th3haQCE1KkNx1GTTlbd6XLNkKusZMzqczY0EArcGKNp8aDueB8OH3GuhoxcwoD3I6bJkJN7ekAuwfbmmA0FvQh97NgViFljZxEECqSW+8IXJm0ULfQZp5Qqy9ztgvLlDicsohNUhGeF1lvI4kovTLyEHSwTe1x9lCQHBohAj3+jJck0EsFjIHW+6AVfnUoA8zlLvsrMGqvar8REcVHRBmuB3MCbKGRBPIE9ohiaKrWvXIdmk9RTtOFh9fmCtAWHcIJ7D52sGFUEsK6WxJLP4huWbPOq09ee9CEBLD1XGpYqop1zS1ZDJ32JRt+eXc1Y56mJvNEWl7JkoqiPBOXyyd4umajZTQCV+fdAxwzwrsouhizbI8pgSJYKzCc
 dPSe8Y0w
 SioVjwI4Ch4bo9ViRYzSwXGHWbzAzQ2mu12u8T5liW+p2lz2HbIVCxoSDHWr+MYiPU+tnbujStVtlGBSjgJO6dEvWE4DGA/JI/9qnByRIHATdciyTLl3jUa1fF/O47qQVAGaZaEUKr6+KXn4FMmyBm+MstYjfG0qfOAgsPz6wn2Ts622vtGJ3FlF/pgZ4FyfMw//JizlFbW+TlP9fuOhpLghBhDv123LgvcpHxpn8EOYHHAEJAXXG/hF7GvzDTuPht3gVH03Y1pswJBXV7Sgb/qFcezZNJuOnCy9rQmWUpy9aRNUcq/Ncw3+B3UhU0fKWNwBLj+0dfA5IY/J0SRzvJTB5wlYWQyWSNacGuHKLMpLZCiFPn56cLYJxW7IJs7q3dtJGOeV+suwPGd8/6MJ8a6G4YDD4SlEzPzSMXQYgBml9mgI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/14/26 11:27 PM, Gregory Price (Meta) wrote:
> Paging out a THP that the advised range fully covers must not corrupt it.
> A THP that the range only partly covers must be split before reclaim, or
> skipped, so that no page outside the range is reclaimed. MADV_COLD takes
> the same split path.
> 
> Check that a whole PMD-mapped THP is swapped intact, that pages outside
> the range stay resident after paging out a base page or half of a PMD- or
> PTE-mapped THP, and that MADV_COLD on half of either THP preserves its
> contents. Tests skip when PMD-sized THPs cannot be allocated, and with
> /proc/kpageflags the PTE-mapped cases also confirm the folio stayed large.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  tools/testing/selftests/mm/madvise.c | 234 +++++++++++++++++++++++++++
>  1 file changed, 234 insertions(+)
> 
Looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

