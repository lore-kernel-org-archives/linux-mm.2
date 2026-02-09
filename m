Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B600EE0ADD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 08:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AED316B0005; Mon,  9 Feb 2026 03:06:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70646B0088; Mon,  9 Feb 2026 03:06:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951F86B0089; Mon,  9 Feb 2026 03:06:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 839906B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:06:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20C4EBAB4C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:06:15 +0000 (UTC)
X-FDA: 84424185510.27.5654FF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3F23E180006
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:06:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eM1R+TVu;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770624373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOrumXSAeCYRbMmBX1zNFB7tsuqJXBKrIjoJzdYBq2U=;
	b=tJt9f1qyODOq4rADaQIkgQX9OeKhJ8TM1VfC1v/cOIB9L9TNlXEpZsZBC9o4T3ZxLXLLg1
	QBETGv65wjSoXP+5Fig5NJKCOYYMPg18fL9c5hVUnqVS74Ny5Q/7LzKBVeXeKiyLCH1Y4+
	E/4VSqo3FDT06Fcv8jFwjkTwdNhu560=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eM1R+TVu;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770624373; a=rsa-sha256;
	cv=none;
	b=nDCSlDovlKkESqP6AIJLyvnX0IvSTOLmsbWZXBN4mc14oydw0c7OSAGbCbKHKHLR9rvru0
	APsEjd+jPI3h0sny1Kk9cU3IEHVlF6uRMqEeQGoqMp+BQ2JHi6IxHp7aJkBOE3fB91eZuu
	YaWuDj0qwwsP/HZg/biB/NM4TGfBe3w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1533742DB1;
	Mon,  9 Feb 2026 08:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBB2C116C6;
	Mon,  9 Feb 2026 08:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770624371;
	bh=SzUJ17uIjUXWqMNjh2fsfaFW+MRAmFwhSaZyTibNZYk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eM1R+TVuODddEFR9CmmJJyGTyy0/KNJj3yq1ovylzoVIG2ViR5LDrCuOD5hGJS61A
	 fg0E1/36evcKGBeYQ/2JIx8H4z3FxdQijDYoodBHb9QUGuFHdFuMgUgO+zl/hix3EA
	 mqG7LfgybHymjL5PQqSI7B4N74MY7s3jp0tOqIsBvF2P6fD99ps9kBKb1mM6Qj2FOc
	 NWToEw6xue9D47yKe9/QfC8K8yNHeMKoJ0boL1OVG8e0f3uRMuxIWmMlnAh7T+AOXV
	 uUZxFvZOhEQa28vaXb3pjlBF4AEjPgmNtB84kw2jmH1YSU7664P+pkzy8iQMDF3YdH
	 trQlWq2EFuPQg==
Message-ID: <64fa130c-a87a-4c73-a2af-ff52c9268588@kernel.org>
Date: Mon, 9 Feb 2026 09:06:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/fadvise: validate offset in generic_fadvise
To: klourencodev@gmail.com, linux-mm@kvack.org
Cc: jack@suse.cz, rppt@kernel.org, akpm@linux-foundation.org, vbabka@suse.cz,
 brauner@kernel.org, linux-fsdevel@vger.kernel.org
References: <CAFveykMPrkb=VYwQAjCEARsC_WAGfQXMz_gf8Q0CTHWHooNHVA@mail.gmail.com>
 <20260208135738.18992-1-klourencodev@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260208135738.18992-1-klourencodev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ymapxtbnuwcscfgtyfpemofoynrjuttn
X-Rspamd-Queue-Id: 3F23E180006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770624373-583220
X-HE-Meta: U2FsdGVkX1+eJCoeMlD6axY4Qgo6ioDSj8BNVs99SfDGKDkMPBovD7yiAjVmiLFmGqKb28bN9bQmasE4XTgNrlH/41Yg7/pVzausZVUHwuAT854OgjkyZwHFb49sTCvKSfWPtt4qymyUlIurcxxdznohN1D7H4+Bq3g13e9BaDUkGvNje9fDxNYfvldmLoNO7F3rjwRiJOId6L68AeP7qdDsoJFHOl7DIw0aD/JNmSs4/hcCs32fHunokoQ/eVdgCiYAc6cU2Xgbjl0O7iBPn4toQBYsLm9IZ/7oZayLKU6V0EFsJlps+IRjnHH15RKt4TI8rjamnkX49pa44FzIrdrZgPGLFnvh20BTEayjBKFWdMuCal0Foa2AA0k+NgRv9LPfGSuUCYjVktiFiVzC8ww4v3XU/MlC6OPBZT6eZcWRRC6ROMU+4Qib5ltx3wyaeDU7c7arZdMyNyxm3vJ4aZRp1hQ3FqAJlUb7oeL6N4aFmBcHbaJs/qjjjIhRkMgUJ5gTFU23cQvnnS0R4YGFei33TifGDhVtfWX4c1mD9HFwFirZfFjj6JyGZEKmTuraWkTGrIxx0OTSDq4VWgqc8/ZqZyiCxCp5KnBw8GMHjKeTV1J0FrZlkmAvX21seFLA1CYyeQAN9S8pPdBZ7qwkEptjisTgALJ9v0wwIZy9uxYu0J4IL60tdFlik5+O88oquTlci96KUgIPStV8aaqxQKKXbC+sFueSgmOZ+nUhlkt/gPrjMO10lvAj4ejAI2VD9+AeeQyG4x42HOZX5R8mYTIKz/0JSqmrTZEipFHfcYS+3NH6v44mVMC205eqHcWCzi9AufUof9EYqE39cEA+Bo2BIxR60z3/7IjiYq3AYuttANZodxjaHVoruvKII32PTdO/ZC7LXzC8+EM7YCK5mPCgmBj+t9xw3I0XhgOQ9ISFOaZpAQOq+bx+2P1rscC+ymLYj9VAYLzqhMSpsre
 2+41LBPe
 mOiugCrkCgQIVYd/LSUFL1q24faG63dnintTK0diQJCXmsT62RXiXlNl0tGW/1tpAvbck92OsCE8gCttRcAQKQ9JNiojwzFwRAr6ro9Ni0NB6alt4Xv6XyWz3h+y5NV4D3VCOCR38Ws6kIfrauwbgxIm235ookT8x/WMiL8MXyUpLC/s6QmPUhX/hlh7wiJwYiJr89reRtYLq+Q/FjkJswKAsm5ZeYxPCe+/XctkHvlCe3WfssStRstJpoRQ7GqPnPrI+6dwFhGPaibAxitjJpfP7rk7HRI1t6pye5Z6CBvZAX/UTs7cIxFcZwf0bwmxObuNE7rnWjKJJneV6Y+HOIAmY+zdDBV1pCEPfwtMhLb6taOMPIV0EZR89Bhgxz8ujfiQ3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/8/26 14:57, klourencodev@gmail.com wrote:
> From: Kevin Lourenco <klourencodev@gmail.com>
> 
> When converted to (u64) for page calculations, a negative offset can
> produce extremely large page indices. This may lead to issues in certain
> advice modes (excessive readahead or cache invalidation).
> 
> Reject negative offsets with -EINVAL for consistent argument validation
> and to avoid silent misbehavior.
> 
> POSIX and the man page do not clearly define behavior for negative
> offset/len. FreeBSD rejects negative offsets as well, so failing with
> -EINVAL is consistent with existing practice. The man page can be
> updated separately to document the Linux behavior.
> 
> Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

