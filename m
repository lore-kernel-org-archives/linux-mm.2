Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95FC6CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 06:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8F776B0088; Mon, 11 May 2026 02:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66CF6B008A; Mon, 11 May 2026 02:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D816B008C; Mon, 11 May 2026 02:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B77036B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:48:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C8DE4061F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:48:18 +0000 (UTC)
X-FDA: 84754209876.03.CE6C27D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7545D40003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:48:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=So7uUvuo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778482096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=37+wQpGIEnY9Pl7nNELo0iZPK4o3GkU3Xy2CW1TBbHQ=;
	b=sBYzeaaM+poCGy+VZr2avd3+k2QrZvg8hrgxqkoPWIW5ZIGfERxN6Wov9vdpNlq4BQB6Uj
	hSVFEJNLhoQCqJlk16IGUs/PSXnmxP3ma/7c+lU7R0rUFoqE5ux8p8g/TyQ2h50Vv7QDln
	6Zs1bYMDpM85sGOeSDq2shgqd9v/JkE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778482096; a=rsa-sha256;
	cv=none;
	b=h2ivhebUBUVMmtU0+n7KD5nFG6d8x4i25fYS23KBLdYIKhWpL6VoXhABIi++Y1qfUMpO+D
	f0Q6VYXmhIaMa7ZKwC0bKiIYk/kMHIu0ITs/RPT4Pc9C6SgWYRqjryW8vWW91I07x2SBrv
	oOpz7BdR8hIHsw5ksmdClZYhhipBAXU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=So7uUvuo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1939D4338D;
	Mon, 11 May 2026 06:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C44C2BCB0;
	Mon, 11 May 2026 06:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778482095;
	bh=Zkt06Qnk/8bTbufZI0SDXNWlCTIsqotZx3SwdOC5AKw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=So7uUvuo7yvNGlGAev/jav+ILcYZxcD823dwNtJ+9zhK0OPIsY4oNfiY+kIBt0efO
	 d7VumIIdvHEmhGJv8g5rt6tKrqcMc/sUogUrLer8bIj+Kmb4ZwJzsG+Xdc/PdHd+tS
	 HyMdmicF36r4oMc0kXYcSANCNtsADigNUhrBAck2DFL0jMWbgVLrxDgKQ9TwtTJi2L
	 lmN38lP+TJuj0U+twWc4COawUP3WyKlwI9oUkUZsRU4wzbBXlX2ee3j5aafaCIYy1r
	 LhDho/cfbL8juFIEK/wBqsI1hgFkpcAJEyhI2EQm6yeR6hDwfu1sbcpcjlrvloCvSh
	 iWKZlic1DVs1g==
Message-ID: <de2f992c-dc93-4b79-b841-11f47511dcfe@kernel.org>
Date: Mon, 11 May 2026 08:48:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] mm/rmap: initialize nr_pages to 1 at loop start in
 try_to_unmap_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-2-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260506094504.2588857-2-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7545D40003
X-Stat-Signature: 1qoyg6i5agot7a8yt8e3tif6cn9u46iu
X-Rspam-User: 
X-HE-Tag: 1778482096-318417
X-HE-Meta: U2FsdGVkX19fxMzOhpCjKy2s+lSGAY6wIo/fWI8EQTvq86tByIe6H1UasGvViGPd1AMTVUM8NwJnNIY0thb14da9Lf/Xhzt6cyqz+miCOy/fF3eyg956CumWSPNqFPXolglLg5X4A00veMf4e7ONvu/vX3XOot9O01gcjxKD3Efx5nbwra7QkNf2nbnGko5LOKiN+HGKFaKymBKyPDnZZPvpZVmMeuK0x7F2UQxsG2Rf/sAr1HhGc3kvRQTvn3y3irRklrdYioOzAGqP9k0GoGZwbwHUEm+x04+qtqTpNuwyT7hMMde5Z4ulF7LUhukOexAI5ivFPf7NceYbArojBB1Zr83nsLnHQmhNtsBA8IOx0xiCWPaFsT2a0BpJFVFpUbbBL5sYQ5HgnUzQRZR2smTptSIwnPw43o4XUjWs01H1nmWYIynxl+dsT3/9XV+WfaHy2wJ2uaJWukSN+gA/STx0rrnfGO5kOtGsEQxccjawAMt4BPvOmbwlOEJ/ALaI71qjZBKgIkJ1Df/u0wwMo4MzU/Tu6Ue4O0i2J4WcQOw7TXcYT0/MuCvPiQDV1qAhwF6gWgFbdcLvJ2JkXtuhUqEQaNLUUuLapfxZsR/NYTknHzsHOqIW34j5XjtGeRMMY+d/mxSym/SOfqfWITqvYMIuUxGRiE9xiwe08ik7Ven+Rn8SRYMD490ZciTx/sdk1DFrrALPJ1uWC3Z4ov1WHohmp0r32ShlHti/ZQwf5PUzQnuwj6gUu9JPdylretlpYdMAzFi61qenlspt5qdv+bRs2WVxxG/ZeG0Q5L0vYy3SFNaidAhKma3ercfe8MCJgyTP3GiIP7JCAiD7ZCYFURysi3rziUMs4s9iYhf/9aZ2JWHVb2DA98+jlS5vt1PKbT/lJ3uLlN6pDEbz8/n7tfkltkuhmx/GAK/NzObrSfi14T//hC59W7YQrU9czF18aFsFuv95wdq+6JTekYb
 GyJzQVDi
 UIvlMBue5Ijssc0gH0QVXjN7DEmamBdlDp1xp6+hqU/UtLWkP+vJ8bLcowbrx9bDxxaJEf5b25XqREqv4tsC9x/YJ8bBn5Pq3AmxkZzPpapkTPZkKimeYLYV+8G7uJ/KxEeb+t/iFd7m6Z5By2OEPGurWYJZTF8M/pR6QeQ67Ni3WvHLOaAx9mnzOTNNstnu5Rq9Jxmz4qLy9FJX8JkEIs+umWc26ATgc0WaPL/wbtkQ8YNDU0+q6ZMdHUhsRxWzORhJsI03+o+CSmlMyA6aTOxAJy5qfo+9RF83nrvOpFMFzfUn1lUBfWdrK/jYsWGfdXpdD+UrM06/nYQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 11:44, Dev Jain wrote:
> Initialize nr_pages to 1 at the start of each loop iteration, like
> folio_referenced_one() does.
> 
> Without this, nr_pages computed by a previous folio_unmap_pte_batch() call
> can be reused on a later iteration that does not run
> folio_unmap_pte_batch() again.
> 
> I don’t think this is causing a bug today, but it is fragile.
> 
> A real bug would require this sequence within the same try_to_unmap_one()
> call:
> 
> 1. Hit the pte_present(pteval) branch and set nr_pages > 1.
> 2. Later hit the else branch and do pte_clear() for device-exclusive PTE,
>    and execute rest of the code with nr_pages > 1.

Right, for hugetlb folios it should always stay at 1.

> 
> Executing the above would imply a lazyfree folio is mapped by a mix of
> present PTEs and device-exclusive PTEs.

Why lazyfree? We use nr_pages also for

	folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);

and

	folio_put_refs(folio, nr_pages);

Given that make_device_exclusive() operates on individual PTEs, wouldn't it be
possible to trigger that?


-- 
Cheers,

David

