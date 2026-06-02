Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF12CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DB2B6B048B; Tue,  2 Jun 2026 00:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2516B0490; Tue,  2 Jun 2026 00:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF7B6B0493; Tue,  2 Jun 2026 00:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1646B048B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:47:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B35CA1C1EDD
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:47:08 +0000 (UTC)
X-FDA: 84833738136.12.524727E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3015A16000C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:47:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YVUczLjs;
	spf=pass (imf08.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780375627;
	b=Jqwgpk31QpGTEVlcLkZ5qym6EPd07EALWMzhGu9UKEtByoqZ/wVu3xxdAHvsKMV1xBzzir
	J2KHsSNCvGCAmGc8quHskikwGyEpwpcxnU9msyZ87xmomV0LOA88ZtK3SWalbNS1+R626H
	hcXUDQjCGENTrDvB7Zled45GzDQ7jLY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YVUczLjs;
	spf=pass (imf08.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780375627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2vFw2b6Dq4kXYpDSqPPl/I2tXbfPjM4tacHe5F7/ME=;
	b=OozZP/SfpoW0IDrDNYVde6Z3DkqVL01ewTnP2JsEAwuGtdz6OVBMPXRSL5DWe5wHnAwAZ3
	6tPAFoJbU8QPgTyq3Q+OQELTFkGQJgF3V5RoBI5OcLYHuin65pnS0RnEJdC5/FCyYxNpEt
	gylqwO6AuYaoOyEkSPfnaqloKQImfAM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A79176001A;
	Tue,  2 Jun 2026 04:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867101F00893;
	Tue,  2 Jun 2026 04:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780375626;
	bh=w2vFw2b6Dq4kXYpDSqPPl/I2tXbfPjM4tacHe5F7/ME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YVUczLjsw80yEWH3gu3NkaGjxurIFsxviLifgTASl5KmyxzFoZ9D6BRbFnC647FHj
	 lx/XsyIDDrgeNc880H1ZCzZ6k2GAkGqLt2HPVSKtCr9mjn6m2DCwScX7GkN79pS6Kb
	 Ybu4ua2edqgSU8v2FiaC7J5DsTHfum101oh9NnXGGFgdKNTpHz803fqOarf2Aq/REj
	 rrFf4M6W83xFQsgAsvLEXmOIlSUp/imXkfYWMxxsDexeQ3reNFAuz1/La1vSHOW9B9
	 ecfNlu1N+o672xehcI60o8JlzLchfcXr0Hdq8pu+MVpFykxKhmlLGaQmBsGApTcQm1
	 IWYYOlv9b/uSQ==
Date: Tue, 2 Jun 2026 06:46:55 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>, WANG Xuerui <kernel@xen0n.name>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 5/5] sparc/mm: drop vmemmap_check_pmd helper and use
 generic code
Message-ID: <ah5gPx1TuEH1wFzC@localhost.localdomain>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
 <20260601084845.3792171-6-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601084845.3792171-6-songmuchun@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3015A16000C
X-Rspam-User: 
X-Stat-Signature: xa5fjpmnqdjwpry69wwb8ntj1sgi4hwz
X-HE-Tag: 1780375627-593951
X-HE-Meta: U2FsdGVkX18oIWrAp1U9X8pAw+RSb19kouoNYPfBMYzYRM2NtEE+EvTDDIQg2wGlRSWbrUACUfug3vvU5sRgfPxA64+pqJS9ky9OEud73+RaHekIeeG20Ru1TbiBlQ3Ux8U+cy9RrotWhd5J8g3CfgV3FBFQWH1PQEUqveNtoiWOC8DBHyHsmb255YZPcWo7JNx8CueS8ok0ORQSn6jBAfRvAwvZ+gkpn6SIhjAfaNSZyYL8XjyStp4m7rSg0jnQ4czbiEwcwmzOYKj+xLlrDPxzZ4tKfF0xzpJTw/tDc2kb9qrDE6ZfVyL/JE0VinvnOQP8iJZl8Q0O1cnLHQxNZYNCIuUVdsv18bxzHWM/E+I1wpKVqypZZrfvnnSs5z4E1PQV9Ylw8ufHcobeG3ba0CkJmVi6suznFjeAYeiXW0DaWg8wv2RbVjbQlydoxRu+wdwhyUzxmTd1jyXXDnHatu51BlQfKkoJVi6xbJoVx8p6PEZxw8rHUx0kownt9GtDj33ZNUWRjvWJurofQcB0GqlN6DYyJeqbZZDkfpN2Gavkt97IOkREhRsFV76vTzRxLaNgNpMDC0XmXdfylf2GXgGjPS+K2pMTWl66grR7cvDG4zt0ypX0ie+nTYRYP7qJjWwfu21wLq79q47PI6UDiSJMOBVHWwphDP0bqfxrd1ieyPzWirGmkDVae381d8+enCYCdJaMjHYE12ndfKxtkPwfyxcuOsiQR4YtgvZ1Vo4rhU29dgWyZOtu39l8wZXOF4OGfrUonGBMCf1e7vGFgwbUUZjjgKpmpu3+efsTET+Jj2MMShto1cf7gSeWw9dRMOa35G+O3BF5G+Qp16cibDeUJCWf0qMoXlFwTM52KwM0oGcIWfuO6DCB+rJ/ZqXaQ/AwtFT1xj3mgNJ3YWVdiJ8bN3wDrPMvQRq/NUyrSa+/jfW7zN+W3ORmcV72PoBUPnlqW6mr5ZDxOgqedNd
 dy2n0/vZ
 O5kQDPt0LmixP3OLxe8GqYbtD9n90vsQMp5LFtu2xcC9mNFfFu8lczRy8WTl4lYchVCRGYwOLoBgLpEEiU9vAyh3b0pD0hBo1zNAB5EhoiuQp8+21Ly5KhqdNhMxoOu9ena7Y8B5Kk9rjjK7X3Zi0KNzjHu75z1c2tEjB1KfwErfLmkFfYOuDUOTxmdmwFi2pLREhoDcWlkIdUN5+aN5BrCExlIQTzIp1ULhfipaMqTDIe6P2Ioyqnjz6ZpymHSEVTX5jsfXtzeCmBB/N0MHU+Fp4tn7rCz+0gb6WCTFS88c6vMf6SmtblpieNOGW19/Pndj3hQ1RehFxcNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 04:48:44PM +0800, Muchun Song wrote:
> The generic implementations now suffice; remove the sparc copies.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

