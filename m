Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81466606A333
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YvgjBJDe
Received: by kanga.kvack.org (Postfix)
	id 909166B05CE; Mon, 23 Nov 2026 08:53:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1886B05CF; Mon, 23 Nov 2026 08:53:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F73C6B05D0; Mon, 23 Nov 2026 08:53:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5C46B05CE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:53:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2F3F1208BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:05 +0000 (UTC)
X-FDA: 85466525130.03.4CF6BD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 38CED80008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YvgjBJDe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441984;
	b=jhX52Q1cHPJwEZFFCM5tFwyg/iXxAjlxZqs1zSxBEvi+AbKfoBqdBptyI2/F7Ic/wfACkt
	m/8dlAcYltibZ0cvKzfmfzVwrfn5M25xOmnLjO/Qb282UxxRqqpHCH3Ed+Fis4Vla8EXSZ
	jfrZvM9NfjyaYdjMA6n5+LHj0P2D/8k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w7l6GOVj1ta19VMv5L9sRcj+U6VdIqUJoDJrYzcoSww=;
	b=Hzfh10/zfAdDg5xTQaHsFxHvgVcD2oH90MR9GcScOXXqQnmD2KJ3lPBhQoh0eEk1258y7T
	ntfixO0NzPWN7BXb2Z5Piu4Dc5oC/GSkPBzfxDRl5wojBe/a4kGxFHZI9xxQwAAshM/kfS
	1uVZ3WpHuI6hHD/pj+kKuhxbdsKgDG4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YvgjBJDe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EB7840A03;
	Mon, 23 Nov 2026 13:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0C11F000C6;
	Mon, 23 Nov 2026 13:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795441983;
	bh=w7l6GOVj1ta19VMv5L9sRcj+U6VdIqUJoDJrYzcoSww=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=YvgjBJDeY6bRVM//Ef/CR3wqhigSAXRBKPMQZnFSl5rRLTYBReyZxGh4KYDN8PZjg
	 e1+q37zjOWNa/zW6PenUUWn4c+VSxL3VGzz/+YMEB6zdCxuNSRKkYB0fP4i+Q14BwT
	 C/JymHhoTW1bVfQOv01xOXfAgeEuNJ0kuGBFXXQmTrpRqNPhoqIr3HHlAdhY+r4bUD
	 O/4WA+RiRgRRCs1i/0nEIMC5nXuVPNWyHrrDqCwNAZDqOsUYPVCgi46EHQtaywgH7d
	 t/KS4bMveDBrIxMGKCwvWZuMAhNU1gWeMuXMmM73wRDtKsvO63AyJoLgR4ttgh5g7b
	 E3/6pDDp/TlTQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  robin.murphy@arm.com,  maz@kernel.org,
  will@kernel.org,  David Matlack <dmatlack@google.com>,  Alexander Graf
 <graf@amazon.com>,  seanjc@google.com,  jgg@nvidia.com,
  loganodell@google.com,  arnd@arndb.de,  dwmw2@infradead.org,
  baolu.lu@linux.intel.com,  Bjorn Helgaas <bhelgaas@google.com>,
  oupton@kernel.org,  alex@shazbot.org,  gle.com@google.com,
  pbonzini@redhat.com,  Andrew Morton <akpm@linux-foundation.org>,
  kevin.tian@intel.com,  joro@8bytes.org,  kvmarm@lists.linux.dev,
  linux-pci@vger.kernel.org,  Pratyush Yadav <pratyush@kernel.org>,
  kexec@lists.infradead.org,  kvm@vger.kernel.org,  iommu@lists.linux.dev,
  linux-arm-kernel@lists.infradead.org,  skhawaja@google.com,
  sagis@google.com,  linux-arch@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 04/19] liveupdate: Reference struct luo_file_set_ser
 via serialized pointer
In-Reply-To: <20261110050202.529473-5-tarunsahu@google.com> (Tarun Sahu's
	message of "Tue, 10 Nov 2026 05:01:47 +0000")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-5-tarunsahu@google.com>
Date: Mon, 23 Nov 2026 13:52:55 +0000
Message-ID: <2vxzwlq3zmbs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38CED80008
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: d7ecuau3yna7a49kd8dcucrp9ej4pgmo
X-Rspam-User:
X-HE-Tag: 1795441984-813817
X-HE-Meta: U2FsdGVkX19vdQXKBa6dZ5q33jnbEFY/I+uv/JgSg8DMwOoO11Kv39xCpOma/rowBKn4c8YiOOqY6HBDEsnX5G6V9tgbUQ2YC1/ekePtf7AMQLwh248PBixUBZBBfG55xfsjKWcXe3IOXDSglFD3RJNCOMCQvAtNg9JB1NltgVKFq9CTaow2tWEltoUJovJbssaZsgq5ISprkJpeXSChTb1WXZYyYilwpLnaz8ETP/xwf2A1r+Z2gv25oTaD6o2QM1xqrXRDcL1+4vXQ7sgoqiuwoQaAUgP+gPVxjeXD6IKt007s3ZxHsR0Ru7D8R/bhJKEW4p2nLwR8M2CML1fivVhhD4qgwGS/rVK+f3I3xHDAUOT9aPtGW3c15ow8Cn+mqm9nReRK1eeFIf9cDdIzGllZ91wKI12tXT9ah04ifAzUxZpbtbVgyoT0d1K+1j2R3DN+vCVU4xkNlJzgwky4DQIE8XnMF9arXqGtm+Yf+U7BvOUsXrNkUxOBKFWk5zGq23tS/rdZPVu6yHt6RYCKI79Fipe7rq5IfKe5/Hz2JXhRcxynYpcFh11hA9S9WnzOaoNTQ6b0mRZwkTcLHL//FPZRkphqkF4Hx9mP2NFgZoM1BlgVWpXOPbrjex2/1Q6DhYb/hAioBbipbP8+fWfVyv49rCaH8NpUfOG85xkBZcKFTXksGrYxQF4o/ytCP174ClDoKaZLzbpTiDMVIQuAWgfsuCJBgUz8/8G/h34KiicHbXCMb9sXDdPPYspFpVptlnz1vxwVm+0ASEEH6Y7PDVCxLPjyNTXshdg3U62sDs8q12pFtr87iN+eO8hQxVSbFrg5UAcIFNsFYoAgDrSkbu5I7+kiz6W2UOsyB8jYZ0X5Sw1zWXSCrR8edDyS0axYn1J7IAlq2Zw5gfxLsW6+SGGZyd0VMMaF6t/7sV0EmFPQiGu72a9r4yEdv1ADBsaG0k20rNFLBTdMoCuoigV
 KwPzZRxk
 +bfg6XsyOkVUnVUNyegAxuoMk8GnRLnaSEwg5eM+birwhQRPxgmW+f3cXi2MzP22fS7LjpJXbFlkjBW2Dr06V9ekM2jPwma4juaYKk+QVlsiBGbgYF1o8bwy1rpKjovT6gj56OK3gRnR9iYE+OA4PNtFKShRgzj/EOs0LhyfRQb8uVb47KIx3W5AaXR4oM726TQAZ3ZJaAKXMsj553HOu9AxAIMDrQE0OuKTlIypBI+oljtxf/msd0x8eOzXuc0VAt+5oQIkAuzgzfu0dZwYZc1qmDqaYVUl6jsp13g5s+P25REIEQKNm9hVhykJZ6zcd3OGtZa5JdFah5tJUE3A9ULbCpJ158iG/csjekCNcwfDroPX7F3k1lnl0ZNsvozBUbnyKdAl4HmbzmXETBNhKCOK8o5wSLI3X3+B9ccvfGMHz1prMIYC9EE+wUXMwmENchewAWW57SQqFGGqZJ24q52tbZUOAd4AUrKTLn3AIha5YDBryl6xglzx2le/dToopq8abDAvlJ1yBw3hWnwMOolZqUgeBglMYqVpQwEEN+6Xk36dyANePUsDO9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10 2026, Tarun Sahu wrote:

> struct luo_session_ser currently embeds struct luo_file_set_ser directly
> by value. Embedding struct luo_file_set_ser couples the session layout's
> size and field offsets to struct luo_file_set_ser, preventing either
> structure from appending fields independently across kexec.
>
> Convert struct luo_session_ser to hold a DECLARE_KHOSER_PTR pointer to
> struct luo_file_set_ser instead of embedding it by value. Reserve space
> for both structures in each session block-set entry, placing struct
> luo_file_set_ser immediately after struct luo_session_ser, and bump
> LUO_ABI_COMPATIBLE from luo-v5 to luo-v6.
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Apart from the static asserts,

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

