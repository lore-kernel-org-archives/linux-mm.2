Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A9DDC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6AD6B018E; Tue, 18 Aug 2026 09:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429596B018F; Tue, 18 Aug 2026 09:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F11C6B0190; Tue, 18 Aug 2026 09:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 016FD6B018E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B1FC14012E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:00 +0000 (UTC)
X-FDA: 85114428000.06.58D61B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C483C40005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:11:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aNrYpejp;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058718;
	b=G6uSWh7/KPaO3S0Wgjl38r8z4ON1vGXW5ZcTOH1Zt5llH/j5PxODcM/mw05vzai0X3inr+
	/0l37qmmNUpmm1qztbS6ivR73Isa6iFZELXxp9zdplohgCK2hfs6CKVHgyqBbz2Mv6A6Pa
	xU5HQ6hMf9hMP2UM7jyMv7Il7lnzd28=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aNrYpejp;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6h2owgxuSrSq50nmTZy/3ZcRtlZHDF5Xk8R/h5i6bZI=;
	b=pae2GKfbAsc0pLTU0cfwR4fOBZfyz/NQfn3XIoB/mkWIftTfEcqUA7QNl+J0gA9LUJyrY1
	z/mBr8JVAsvyVnULGSjcume1/EFApu4UtWHxB7elwRI+ffuey+SdO1UheYqxvJy9RaSOLb
	vxJdctgrQ/5vp9Y73K4BfEgGf/OHUDk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52B6C6020E;
	Tue, 18 Aug 2026 13:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599521F000E9;
	Tue, 18 Aug 2026 13:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787058718;
	bh=6h2owgxuSrSq50nmTZy/3ZcRtlZHDF5Xk8R/h5i6bZI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aNrYpejpA0/PYDjoTrJu4ltXby89EraHWwucnYYvReADSf6HMr8EqJHBKWipyAuV+
	 TxWbEc95Is8kRzwf8Pdgn+qLZrqqY6XGmMhJfcWzEXPY2fhK9/dNI006bFvZkSPd44
	 SB0L8lSsmG4nO7huQUVWWJifX3OTwHYs43zjJAjWIXXGmGKE5NCQnI+LPTJarGvaK2
	 2JKLX7G83xLF/+7XHkaodPWTWUqQmvMy985mTuwG7XdhF5AmNb5Tz7dasaYQ713FLy
	 AZoRqD3kmt91XLsQb+GjWhg9jdyTdsogdlcaHf+4zujQ6kuvmwfo2SZjLfwd99StEn
	 cfVQWt3j+Tglw==
Message-ID: <9e533fcd-c80f-42df-847c-c15c4e3a1a70@kernel.org>
Date: Tue, 18 Aug 2026 15:11:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: remove the local PKEY_UNRESTRICTED fallback
To: Hemanth Selam <hemanth.selam@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Yury Khrustalev <yury.khrustalev@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260818114945.1312987-1-hemanth.selam@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818114945.1312987-1-hemanth.selam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C483C40005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: p7tuwgtqxnk9qq5w8eri45jqnrenp8sz
X-HE-Tag: 1787058718-819374
X-HE-Meta: U2FsdGVkX1/c2RToF3s/fFadAg2OpAmOAgrExsfkYx7OQ9FUYWrsI4p8qfPXIx/nhXII/onQV3eRRfX2HMaVOPNIExPJcok2U3bc7JFbcqQ/kQMC7zR9CvoAaaimxdR7f8yipubOq1sWkXLXdQbTN02YX78lBOQYUY3bejPdlAPZNaFgaGYlIBtycD9OLw0FF5aCHV+ZDP74cWqKc8WDUW5H/20ZNiSCxydePVlHclf28P5C954v1iPkUksjI8Xrq5WslM8xPTaaFBVMMuOEAC9nTD1mTd1diqXfVC5R8pCrF3MZW9RNU3wg25v6Yq8tsmLUGsX9siX6IUM7AZbkvh7qexNzd1ASDMMww7z9HQPy4noQFcOaNqR5LwWyq7HX21efe9Hv+ttIMa9GQWJoiJgWSgZMb9nIZimqZWqy9fg7600QjUGV4qlhX3UWD/WxKATPVka6y45xPYFvhUZfM268Z/5pzxWPsOp4zKYrhet14NZZyB46fjjiMqC+YQlZA9P/w1svHClJ6t+rXFVMZGC8eSeR7iVYg22fncM+7QcjnCpy3I0/MuhQGe0clk+F4UNkFjUDfo6ARnWTOEjrgX6z2MebakAAMolTcB7AD5ZqaPdYA6NaAsaOL+mZcvVFFgYNCgnusCTjODvB40q+/MQbrmCsPQq3JKCCcVWz99JPE3JSMBS8wIBR+HeluWFcLCOIZzu9KDVAG1Te5/dvMRysoLhKHvJpDal8F05JC1zY0WC3eTKW/YM7j+9TxkYV01MrFjDwVXeMdcXIi4/yLMR6WkSXXRxMXsAehF/8AZmKmqFejKu9piPpdo3FZzbiZshXmJ6X44QNtQkqIBwvUp6TohozVTxwOIz+WcooW53683eTNk80qgJE40Bdygpelt7xwpL6IX20HK/KftkqAP7nexBpfrHyNBw4pjcCX55FHwDQRMcYBWp8FgKkxtC/Fq9hJ+4M9AoAhOZO1WJ
 q+FgK71g
 OCl/kp8R3bGv6kwDIA42P+M8hD1cAoQnM9xJzv7W/HckkjL6BRJD86CFYKtT1pmOJOvANzpvAUl70rJVmaSbATlYt4CgsbfNdM2ty9lSOgXBfD1whYYVl1q0b7vi/a2g3TXniByyECdO5XN4im1shZI+C1yMp5F3DkhRhI5IZaov8udfC5HW1XB8dK7hi4pY9OMVtsfmyvS/cF6oe8UlzU8cBnvyBCogAunyJ8iYms+Potam69HHr+9XkmzeIBv7n57tqBcArXFbO8p3RKXPC1i9upK2TgaqpV723IoTq2LFPwOpuEMcOf29G9JlzbVvZF7SX0A1aMHEzqS9ONmJsdYb859Dnxg7KYKpeWWj3zRIabasF/RPf0ltHg3+k5gWFhGos57wvmvm9TT0uUBgf8eQEWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 13:49, Hemanth Selam wrote:
> pkey-helpers.h defines PKEY_UNRESTRICTED itself when the macro is not
> already known, a stopgap from when the generic definition was still
> under review.  It has been merged since, commit 6d61527d931b ("mm/pkey:
> Add PKEY_UNRESTRICTED macro"), and pkey-helpers.h already includes
> <linux/mman.h>, so the guard is never taken.  Honour the FIXME and drop
> it.
> 
> The mm selftests build against the headers of the kernel source, see
> Documentation/dev-tools/kselftest.rst.  Building them without "make
> headers", against system headers predating the macro, now fails to
> compile instead of quietly falling back.
> 
> No functional change intended.
> 
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>  tools/testing/selftests/mm/pkey-helpers.h | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
> index 2c377f4e9df1..626c2e1655dc 100644
> --- a/tools/testing/selftests/mm/pkey-helpers.h
> +++ b/tools/testing/selftests/mm/pkey-helpers.h
> @@ -112,13 +112,6 @@ void record_pkey_malloc(void *ptr, long size, int prot);
>  #define PKEY_MASK	(PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
>  #endif
>  
> -/*
> - * FIXME: Remove once the generic PKEY_UNRESTRICTED definition is merged.
> - */
> -#ifndef PKEY_UNRESTRICTED
> -#define PKEY_UNRESTRICTED 0x0
> -#endif
> -
>  #ifndef set_pkey_bits
>  static inline u64 set_pkey_bits(u64 reg, int pkey, u64 flags)
>  {

tools/include/uapi/asm-generic/mman-common.h:#define PKEY_UNRESTRICTED  0x0

So that looks good.

But we seem to have the same ifdef also in
tools/testing/selftests/powerpc/include/pkeys.h.

So likely that should be removed as well (after making sure that it compiles?)

-- 
Cheers,

David

