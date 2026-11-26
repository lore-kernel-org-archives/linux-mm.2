Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07651606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 18:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n2CNBE5+
Received: by kanga.kvack.org (Postfix)
	id E3ABA6B05B0; Thu, 26 Nov 2026 13:49:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E131E6B05B1; Thu, 26 Nov 2026 13:49:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D511C6B05B4; Thu, 26 Nov 2026 13:49:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD2A96B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:49:34 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27410140211
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:49:34 +0000 (UTC)
X-FDA: 85478158668.13.9D41960
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 88C0F1A000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:49:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n2CNBE5+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795718972;
	b=tj/sT/ZhoFMoiqQwpqqBOEDXDxQe0JV3X52kOV8AVq9eXPqxYtv+6e4Ru428923jbHG1h7
	52xZPKGKTkxkvk8eTmxaoP0n/Wb4PnsX2R93PP1+b3W5qm5zy+rsET3Iv5oMK97sGOw4qW
	vCerhC1HF9exfqW17Zj4PCy3l7QF5Xc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795718972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJrIBssRihwY1hjT7BcClChtfC90/g3C4v7S4XKqBtA=;
	b=OGVPuW6X8nV1czZaE7vwLnEwXLP0mK6pNUM/3DoqL1mYpn/8EhJJFepbIfN83dGc4uWG81
	NVSdsdAAxRjeUDCoPxhEdlLdER1uNa8Xi5KyLjB2jddxcW6MJzpxwD79qCu5Kxim3QwBbu
	SBT9Eu+c4vyRwlvvfjZy9wVZdSqfcGs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n2CNBE5+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DA8760A54;
	Thu, 26 Nov 2026 18:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5161F000C0;
	Thu, 26 Nov 2026 18:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795718971;
	bh=OJrIBssRihwY1hjT7BcClChtfC90/g3C4v7S4XKqBtA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=n2CNBE5+M6S3Gti+E4h/BEiW+QZsCLWVg3Z07JmCFD4CJWtQOT7wmTFvMHay90J17
	 FASidj/Tb9qKR6r+t0f8m5l2GSXoRaCyDUjouiMfYBDRAya375OAB8ifBdjby0L3cN
	 XvZu0xkJxI/+pA9AAyI7y3aIotV8xSxGc2csYUvuvg6Uw1JsXVX+0NOYxmoIoYXxv2
	 M34fX1uPVfxBkS9zufumLpfpKWYxQRuFEpxczh1v12sNbqWWyTovgyCerZ8wJElZbL
	 qHPbpDy15BB/FUoYPImERW6CSIHqZ46EBBEwU+aASP6SbeqtKq5FQihbH4FEKfQfVt
	 VyCXs6QVLSDTA==
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
Subject: Re: [PATCH v4 18/19] mm: memfd_luo: Add feature header to struct
 memfd_luo_folio_ser
In-Reply-To: <20261110050202.529473-19-tarunsahu@google.com> (Tarun Sahu's
	message of "Tue, 10 Nov 2026 05:02:01 +0000")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-19-tarunsahu@google.com>
Date: Thu, 26 Nov 2026 18:49:24 +0000
Message-ID: <2vxz8q2fwhqj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 88C0F1A000A
X-Stat-Signature: m553z75ppg3a4jjiexehrqwh7zm4py53
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795718972-584930
X-HE-Meta: U2FsdGVkX1/AKImWz8ficpNUxXoh8Y/uMj5vtE0FEsYD+b7hsTW9zgORi/jRfEOUOH7NTA7wZKfY+UaLBUh9ZWPzVz7jMOJG1FqUiB8Ef3onm2MUaLJoImvtDVukq/Hoso+wgWVoIhQ6qpvpgElbdrc+0VoOHYuIaUE24hCMOjsKbRW+7HftPXnQBiIBN89UcpeT8FKendqMbkZl5yxNgLy/KA71wvNZUTTVgQMBcURKfUccQ9hkoN+gwYAsnDIwv39/Um2EMDnibmjATQlYJBaJ0bAhNPam3PWl5nfcmzYHPf7d4ea4xw9Cii7nZLexlMExK/Xb9UtGvR+KJu42d6QgOcAvcj4HUrjLV5RBSjh+yvmX0hjy6tA8vh1JQZO1m71LQfiB4nGGuxEwZINNhNjxMJ8bMQItVZrCO+8ZBztNRNiWMrSEH/vTfGAxAfaOqLzKKqxdTBQ9kq7TXnAPXcFRx0B5613+w/R/bavoswM359pYMJjKxRCONPPBpEaMlMmIayq6J+bHgRHwc6FRW+xYtq9nHk7tQgJXqfE3gQksdmMQM1SuElb39HVeFmAjZIctLGYg2Tb9/LKHZEQ19jrXYP85toMkMTWN9GJYTLq3T60GFcEpWDEpZt68nEqht3oBzV8m91amIoSq9Txec3dmmeEjrpvtBb938NSXa+OPFPKl0XFPVuFSxWJrb/Uitn0n0rKoQjztwiHANZhuz8+xTY1slS5L/32tOqAGyabNbaucGflOmbTNpHP9yZzFk705c5A4jJwjgqpmqyv8g7zXb9Lw6ey3AQeNmI6eQ0M/j+Fe+KTh3/IQVyp54MbpiTWQrA2wBTgMsrG2VAtLL9U3qNU0kuuYYGEF9qewl1sj6+vOQ3mVlmeymM50Pp/5fx8OP4JwK3RNRPEJcGisTqXEXjGJxYJqX0+x1VlNV/saBbi542cFYk0JyKSoqYBnfi6wCmTnqWrHZeflWSO
 0YTR3oFA
 KEXgcBoEwbYJ3U4F1pNbl5QWsr+YDoVSTojfMrs1qffGvT+ej2TVCei3ElB3ZPe9G43Wjd3Fl4d8k/kZwk1r8heL5sW8YvTTsFiQil3YmLPIH/ayMAomWdDCJeHKuzWKqpbDzpt3h+JeOerEm3iU6bGkh6WFcnczr9ebYHuHSZSMgbcP3ZfZHHb2pC2GkSclBfQWcR17qiahUtE/mmLbsm7IsHrghSjgyCoNp1a0IsbJ09YraJiDDsCSumQh2DmSu5ORidEPcqWfcOARhwbbxYLwGmZKM3WXKWGR4IkQtxHpGoy7NsOCI06iDWldFbaeNwIJIz3KEP1VDhzURhcddfdmT4BpU6vzrYjUT8D++OZdc6++Fs1+BgWJI1AfkNw7TwDTkEEsZKJpUaavpdslllt+R66BjttT/rBMVPXbX0a6O3k+5arsdqMxViEcfnDrP5QEuoZzzOJRG8M4QTJ4D/+bem36afQX3bTTBDYHhAuxfpkk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10 2026, Tarun Sahu wrote:

> Precede each serialized folio entry in the preserved memfd folio array
> with struct kho_ser_hdr via DECLARE_KHO_SER so future per-folio memfd
> features can append fields to struct memfd_luo_folio_ser without breaking
> compatibility between adjacent kernels.
>
> Allocate the preserved folio array using kho_ser_size(memfd_luo_folio_ser)
> per entry and initialize each entry feature header in
> memfd_luo_preserve_folios(). On the incoming path in
> memfd_luo_discard_folios() and memfd_luo_retrieve_folios(), validate each
> entry feature header with kho_ser_validate() and advance between entries
> using fhdr->size so entries written with a different feature layout are
> traversed accurately.

No. The flags in each folio entry is a part of memfd's ABI. These flags
don't have an ABI of their own. If the layout of memfd_luo_folio_ser
changes, it goes in the memfd_luo_ser flags.

Doubling the memory needed to preserve a memfd is not acceptable.

[...]

-- 
Regards,
Pratyush Yadav

