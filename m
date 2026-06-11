Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA974CD98D4
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 08:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440A86B0096; Thu, 11 Jun 2026 04:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1606B0098; Thu, 11 Jun 2026 04:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32EC76B0099; Thu, 11 Jun 2026 04:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 227716B0096
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:01:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B6C4012050B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:01:57 +0000 (UTC)
X-FDA: 84866888274.30.31ACCFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0E97840011
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:01:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bsbYHwWC;
	spf=pass (imf01.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781164916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dD4/CQnNeeyrkkOYOUO1mj3STEaisPLiFqjfCgk+JU=;
	b=z4O4R0FM8A9LM7pSaNjj1FKV1MezfMXLZ3z3yPa3DPTNFzS4HrKXj/nJJjD0HfrXM2o+IL
	AcN6zCh5/4ztCc3IrBQRCch8oKpI+Da70afwsxFE0T9dPyRjvlO6IEQRpWlyfgQgBjpmBr
	vOVROcJQCfxGRYLSABq/2q/PoRVckyk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bsbYHwWC;
	spf=pass (imf01.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781164916;
	b=d2cR5W8xx2CWQeUIjehQkwNKof+EpLyoH9urj2QXFo3EgT9bm72TmdH6r0UBXpF9udz15I
	iheS7/JU21pNA0TG++6GZaLGa/5Ogl9aJ6t1R+9Gj9THIY29t02P6zWVnl6N0fZtm5BxcP
	DuJEfmTJVbKdVR29qVVAfxK/KLupla8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1930D40D68;
	Thu, 11 Jun 2026 08:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDE81F00893;
	Thu, 11 Jun 2026 08:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781164915;
	bh=7dD4/CQnNeeyrkkOYOUO1mj3STEaisPLiFqjfCgk+JU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bsbYHwWCImv67tbIFfumvMYPTQMPVJc9B3XM2fOGxPEjlnUB+K4WQ9QG3o2NQgESI
	 S3mJJCx7sB4kxjBR8Xq6WeTFztqOZ5pKDfXAZ2XC/oxUNFL9s/ORvUGAsDY0Po1wSL
	 hi98GUJnxp2ohZBQvHHfc91d9R+dcHsCwXHangO9vzQQiORIWO38cO2ZXpLTFiSmzz
	 eqqdP2AAWx77dUNV3PXKsTNuZLpJueU3U9f+kYMngrNOvDfdvVqy8Nam2hlKwzK06r
	 gXdGzGy2Cp6eZudu8zMb2EALFYVG1jEjIJ8qHdYpT9AqcjbKw1aPFg947/4XnfjPZT
	 QFBWEtJ+B4WJw==
Date: Thu, 11 Jun 2026 10:01:47 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 3/3] mm/vma: eliminate mmap_action->error_hook,
 introduce error_override
Message-ID: <aipra0klNhB7SG2w@localhost.localdomain>
References: <cover.1780397980.git.ljs@kernel.org>
 <55d13f7d016b827c459946d46a56105635be111c.1780397980.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55d13f7d016b827c459946d46a56105635be111c.1780397980.git.ljs@kernel.org>
X-Rspamd-Queue-Id: 0E97840011
X-Stat-Signature: ej3mzowpce1fma6fwq14kcreawrjszkb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781164915-516107
X-HE-Meta: U2FsdGVkX1/FE3EyyxNUSTsLHuwWBuDPWKVoLR/WxahlXbkIY183afCA0yKb4k9vGjOErOHzqOD3lN9e5BOz/xAuFRxhSHXkNzvugmwn5+n6MPdkl4E6aEswdLctt42/fjQqYCP3Z36FUVuWWTOqiPwcFX+ABewgcp0UJt4LQNFRRkXhBP2JkK2y82TplKv+1ZkPGRx5nqpgyiAzvOfxde3CBXMWjP6fHBMk/qoZXlSlQ1lALQOkX0QXpb56cZ7qeerlG6flVPsyA1uAafsq4omkDvHeFEFQ4E/eRxSN9QtsY0AqHfqvXTOkMPibRiJZ5zdL+dKMgGztN8FeETZZuJmH8LjJXCGKcvN1TQaqeB1ae+221HecS1PK2SnJIT76KyWl0SIoAh8/uuhvwnAkFhM9Wcies/FDyTkAOyaerKqwngxcv7g6zn/yHAq8gTY6nfQWoylCUSCevShQZmg0JWnMw88vIVjJ1zpFmZZDtKdzCpODuZmos44jNUmIgoEF6I2errpGhQkrD29hypHDj1/kQLXKOtJCgOVgoXeU9PymVGOxrZDk0tBzDU4xsLDZdzUhtApjYbYAGfIc8AryOcz6lJHHunSECZzMQY9jOuhqzOPP/g4XRGneBEAfVkxopV2vIMehoEm3aEX6mabAyGT+R3prs/Q4Z8ASgxn0RxN1KVJ+E1YvfeBenRy3lEq3yccEW3HptASskFOWb+iAzuguCC0N55Cm117IpGzT8aF/4QH3yMQZVwdK94mZKTLmZjOauGFvFxjrQMfPVnCNyarIWGkLoMpcUGz6SMizivVeKlljHUSOFIzCp89jltUckyicvFWzFT/rfldaV7Y3bGOWtefkAG68yW/L6jWYnQIh3vA2DO03HT8ewLLoERxh0hFFOXuRmMTdzjuPFTwZEbvkr5LmqodNe/hJVTyRz7Iqz7OzEvlEMLHJVBzH54S27IIXgziqpeO3MbEvN0f
 zlDfFoIB
 30jH7gRxlzS5f5aY6k5H+FM7mRfAF+toyxYvEAZDru+Wb4sN4WHFoHb3bTyczsiWwlzMTexxxPWeSV7UFSN4Zz36at+JffjiYVJWFQsQ3CztyhBmdc1D2OEL6g2gYW/yaAGRfHibiqeuv8rfeodgsBY9mKt7X747W80JKFp34/8Sp6IDh8M7nkrWV/LMaND+5QiRl5SSE5MX909Zln8s8WbgYqiIqbZAwhyomkhLZnpBIJvcXWvnWDaRxYa6jutDNDFR1n004/wEPCCs5bM2znXR18se1OSyvq2Bm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 12:06:27PM +0100, Lorenzo Stoakes wrote:
> Rather than providing a hook, simplify things by providing the ability to
> override mmap action errors.  This allows us to more carefully validate the
> value provided and thus ensure only a valid error code is specified, and
> simplifies the interface.
> 
> This way, we eliminate all hooks but mmap_prepare and allow only mmap
> actions to be specified (which core mm controls).
> 
> This significantly improves robustness and eliminates any unnecessary code
> duplication in driver mmap hooks.
> 
> We also update the /dev/mem logic (the only user) to use
> mmap_action->error_override instead.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

